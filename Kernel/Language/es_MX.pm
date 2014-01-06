# --
# Kernel/Language/es_MX.pm - provides Spanish language translation for Mexico
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: es_MX.pm,v 1.61.2.2 2012-11-22 06:56:08 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_MX;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.61.2.2 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-05-17 09:59:38

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y - %T';
    $Self->{DateFormatLong}      = '%A, %D %B %Y - %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

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
        'Today' => 'Hoy',
        'Tomorrow' => 'Mañana',
        'Next week' => '',
        'day' => 'día',
        'days' => 'días',
        'day(s)' => 'día(s)',
        'd' => '',
        'hour' => 'hora',
        'hours' => 'horas',
        'hour(s)' => 'hora(s)',
        'Hours' => 'Horas',
        'h' => '',
        'minute' => 'minuto',
        'minutes' => 'minutos',
        'minute(s)' => 'minuto(s)',
        'Minutes' => 'Minutos',
        'm' => '',
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
        's' => '',
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
        'Valid' => 'Válido',
        'invalid' => 'inválido',
        'Invalid' => '',
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
        'Need Action' => 'Acción requerida',
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
        'Standard' => 'Estándar',
        'Lite' => 'Reducida',
        'User' => 'Usuario',
        'Username' => 'Nombre de Usuario',
        'Language' => 'Idioma',
        'Languages' => 'Idiomas',
        'Password' => 'Contraseña',
        'Preferences' => 'Preferencias',
        'Salutation' => 'Saludo',
        'Salutations' => 'Saludos',
        'Signature' => 'Firma',
        'Signatures' => 'Firmas',
        'Customer' => 'Cliente',
        'CustomerID' => 'Identificador del cliente',
        'CustomerIDs' => 'Identificadores del cliente',
        'customer' => 'cliente',
        'agent' => 'agente',
        'system' => 'sistema',
        'Customer Info' => 'Información del Cliente',
        'Customer Information' => 'Información del Cliente',
        'Customer Company' => 'Compañía del Cliente',
        'Customer Companies' => 'Compañías de los Clientes',
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
        'Date picker' => 'Selector de fecha',
        'New message' => 'Mensaje nuevo',
        'New message!' => '¡Mensaje nuevo!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Por favor, responda a este(os) ticket(s) para regresar a la vista normal de la fila.',
        'You have %s new message(s)!' => 'Tiene %s mensaje(s) nuevo(s)',
        'You have %s reminder ticket(s)!' => 'Tiene %s recordatorio(s) de ticket',
        'The recommended charset for your language is %s!' => 'El juego de caracteres recomendado para su idioma es %s.',
        'Change your password.' => 'Cambiar contraseña',
        'Please activate %s first!' => '¡Favor de activar %s primero!',
        'No suggestions' => 'Sin sugerencias.',
        'Word' => 'Palabra',
        'Ignore' => 'Ignorar',
        'replace with' => 'reemplazar con',
        'There is no account with that login name.' => 'No existe una cuenta para ese nombre de usuario.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            '¡Inicio de sesión fallido! Nombre de usuario o contraseña incorrecto.',
        'There is no acount with that user name.' => 'No existe una cuenta para ese nombre de usuario',
        'Please contact your administrator' => 'Favor de contactar a su administrador',
        'Logout' => 'Cerrar Sesión',
        'Logout successful. Thank you for using OTRS!' => 'Sesión terminada satisfactoriamente. ¡Gracias por utilizar OTRS!',
        'Invalid SessionID!' => 'Identificador de sesión inválido.',
        'Feature not active!' => 'Funcionalidad inactiva.',
        'Agent updated!' => '¡Agente actualizado!',
        'Create Database' => 'Crear Base de Datos',
        'System Settings' => 'Configuración del sistema',
        'Mail Configuration' => 'Configuración de Correo',
        'Finished' => 'Finalizado',
        'Install OTRS' => '',
        'Intro' => '',
        'License' => 'Licencia',
        'Database' => 'Base de Datos',
        'Configure Mail' => '',
        'Database deleted.' => '',
        'Database setup succesful!' => '',
        'Login is needed!' => 'Inicio de sesión requerido.',
        'Password is needed!' => 'Contraseña requerida.',
        'Take this Customer' => 'Utilizar este cliente',
        'Take this User' => 'Utilizar este usuario',
        'possible' => 'posible',
        'reject' => 'rechazar',
        'reverse' => 'revertir',
        'Facility' => 'Instalación',
        'Time Zone' => 'Zona Horaria',
        'Pending till' => 'Pendiente hasta',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'Despachar por el campo Para: del correo electrónico.',
        'Dispatching by selected Queue.' => 'Despachar por la fila seleccionada.',
        'No entry found!' => 'No se encontró entrada alguna.',
        'Session has timed out. Please log in again.' => 'La sesión ha caducado. Por favor, conéctese nuevamente.',
        'No Permission!' => 'No tiene Permiso.',
        '(Click here to add)' => '(Haga click aquí para añadir)',
        'Preview' => 'Vista Previa',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => '%s no es modificable!',
        'Cannot create %s!' => 'No se puede crear %s!',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => 'Cliente %s añadido',
        'Role added!' => '¡Rol añadido!',
        'Role updated!' => '¡Rol actualizado!',
        'Attachment added!' => '¡Archivo adjunto añadido!',
        'Attachment updated!' => '¡Archivo adjunto actualizado!',
        'Response added!' => '¡Respuesta añadida!',
        'Response updated!' => '¡Respuesta actualizada!',
        'Group updated!' => '¡Grupo actualizado!',
        'Queue added!' => '¡Fila añadida!',
        'Queue updated!' => '¡Fila actualizada!',
        'State added!' => '¡Estado añadido!',
        'State updated!' => '¡Estado actualizado!',
        'Type added!' => '¡Tipo añadido!',
        'Type updated!' => '¡Tipo actualizado!',
        'Customer updated!' => '¡Cliente actualizado!',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Mail account added!' => '',
        'Mail account updated!' => '',
        'System e-mail address added!' => '',
        'System e-mail address updated!' => '',
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
        'PGP' => 'PGP',
        'PGP Key' => 'Llave PGP',
        'PGP Keys' => 'Llaves PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certificado S/MIME',
        'S/MIME Certificates' => 'Certificados S/MIME',
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
        'Security Note: You should activate %s because application is already running!' =>
            'Nota de seguridad: Debe activar %s porque la aplicación ya está ejecutándose',
        'Unable to parse repository index document.' => 'No es posible traducir el documento de índice del repositorio.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'No se encontraron paquetes en este repositorio para la versión del framework que ud. utiliza, sólo contiene paquetes para otras versiones.',
        'No packages, or no new packages, found in selected repository.' =>
            'No se encontraron paquetes (o paquetes nuevos) en el repositorio seleccionado.',
        'Edit the system configuration settings.' => 'Modificar la configuración del sistema.',
        'printed at' => 'impreso en',
        'Loading...' => 'Cargando...',
        'Dear Mr. %s,' => 'Apreciable Sr. %s,',
        'Dear Mrs. %s,' => 'Apreciable Sra. %s,',
        'Dear %s,' => 'Apreciable %s,',
        'Hello %s,' => 'Hola %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Esa dirección de correo electrónico ya existe. Por favor, reinicie sesión o restablezca su contraseña.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Cuenta nueva creada. Información de inicio de sesión enviada a %s. Por favor, revise su correo electrónico.',
        'Please press Back and try again.' => 'Por favor, presione Atrás e inténtelo de nuevo.',
        'Sent password reset instructions. Please check your email.' => 'Instrucciones de restablecimiento de contraseña enviadas. Por favor, revise su correo electrónico.',
        'Sent new password to %s. Please check your email.' => 'Contraseña nueva enviada a %s. Por favor, revise su correo electrónico.',
        'Upcoming Events' => 'Eventos Próximos',
        'Event' => 'Evento',
        'Events' => 'Eventos',
        'Invalid Token!' => 'Información inválida.',
        'more' => 'más',
        'Collapse' => 'Colapso',
        'Shown' => 'Mostrados (as)',
        'News' => 'Noticias',
        'Product News' => 'Noticias de Productos',
        'OTRS News' => 'Novedades de OTRS',
        '7 Day Stats' => 'Estadísticas Semanales',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
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
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => 'Año nuevo',
        'International Workers\' Day' => 'Día del trabajo',
        'Christmas Eve' => 'Noche buena',
        'First Christmas Day' => 'Navidad',
        'Second Christmas Day' => 'Segundo día de navidad',
        'New Year\'s Eve' => 'Víspera de año nuevo',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

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

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Las preferencias se actualizaron satisfactoriamente.',
        'User Profile' => 'Perfil de Usuario',
        'Email Settings' => 'Configuración del Correo Electrónico',
        'Other Settings' => 'Otras Configuraciones',
        'Change Password' => 'Cambiar Contraseña',
        'Current password' => 'Contraseña actual',
        'New password' => 'Nueva contraseña',
        'Verify password' => 'Verificar contraseña',
        'Spelling Dictionary' => 'Diccionario Ortográfico',
        'Default spelling dictionary' => 'Diccionario por defecto',
        'Max. shown Tickets a page in Overview.' => 'Cantidad máxima de Tickets a mostrar en vista Resumen.',
        'The current password is not correct. Please try again!' => '¡Contraseña incorrecta! Por favor, intente de nuevo.',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            '¡No se puede actualizar su contraseña, porque las contraseñas nuevas no coinciden! Por favor, intente de nuevo.',
        'Can\'t update password, it contains invalid characters!' => '¡No se puede actualizar su contraseña, porque contiene caracteres inválidos!',
        'Can\'t update password, it must be at least %s characters long!' =>
            '¡No se puede actualizar su contraseña, porque debe contener al menos %s caracteres!',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            '¡No se puede actualizar su contraseña, porque debe contener al menos 2 caracteres en mayúscula y 2 en minúscula!',
        'Can\'t update password, it must contain at least 1 digit!' => '¡No se puede actualizar su contraseña, porque debe contener al menos 1 dígito!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            '¡No se puede actualizar su contraseña, porque debe contener al menos 2 caracteres!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            '¡No se puede actualizar su contraseña, porque la que proporcinó ya se está usando! Por favor, elija una nueva.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Seleccione el caracter de separación para los archivos CSV (estadísticas y búsquedas). En caso de que no lo seleccione, se usará el separador por defecto para su idioma.',
        'CSV Separator' => 'Separador CSV',

        # Template: AAAStats
        'Stat' => 'Estadísticas',
        'Sum' => 'Suma',
        'Please fill out the required fields!' => 'Por favor, proporcione los campos requeridos.',
        'Please select a file!' => 'Por favor, seleccione un archivo.',
        'Please select an object!' => 'Por favor, seleccione un objeto.',
        'Please select a graph size!' => 'Por favor, seleccione un tamaño de gráfica.',
        'Please select one element for the X-axis!' => 'Por favor, seleccione un elemento para el eje X.',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Por favor, seleccione únicamente un elemento o desactive el botón \'Fijo\' donde el campo está señalado.',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Si usa una casilla de selección, debe seleccionar algunos atributos de dicho campo.',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Por favor, inserte un valor en la caja de texto o desactive la opción \'Fijo\'',
        'The selected end time is before the start time!' => 'La fecha de finalización seleccionada es previa a la de inicio.',
        'You have to select one or more attributes from the select field!' =>
            'Debe elegir uno o más atributos de la lista de selección.',
        'The selected Date isn\'t valid!' => 'La fecha seleccionada es inválida.',
        'Please select only one or two elements via the checkbox!' => 'Por favor, elija sólo uno o dos elementos de la casilla de selección.',
        'If you use a time scale element you can only select one element!' =>
            'Si utiliza una escala de tiempo, sólo puede seleccionar un elemento.',
        'You have an error in your time selection!' => 'Tiene un error en la selección del tiempo.',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Su intervalo de tiempo para el reporte es demasiado pequeño, por favor utilice una escala mayor.',
        'The selected start time is before the allowed start time!' => 'El tiempo de inicio seleccionado es previo al permitido.',
        'The selected end time is after the allowed end time!' => 'El tiempo de finalización seleccionado es posterior al permitido.',
        'The selected time period is larger than the allowed time period!' =>
            'El periodo de tiempo seleccionado es mayor al permitido.',
        'Common Specification' => 'Especificación común',
        'X-axis' => 'EjeX',
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
        'Status View' => 'Vista de Estados',
        'Bulk' => 'Acciones simultáneas en los tickets seleccionados',
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
        'Queues' => 'Filas',
        'Priority' => 'Prioridad',
        'Priorities' => 'Prioridades',
        'Priority Update' => 'Modificar prioridad',
        'Priority added!' => '',
        'Priority updated!' => '',
        'Signature added!' => '',
        'Signature updated!' => '',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Acuerdo de Nivel de Servicio',
        'Service Level Agreements' => 'Acuerdos de Nivel de Servicio',
        'Service' => 'Servicio',
        'Services' => 'Servicios',
        'State' => 'Estado',
        'States' => 'Estados',
        'Status' => 'Estado',
        'Statuses' => 'Estados',
        'Ticket Type' => 'Tipo de Ticket',
        'Ticket Types' => 'Tipos de Ticket',
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
        'This message was written in a character set other than your own.' =>
            'Este mensaje fue escrito usando un juego de caracteres distinto al suyo',
        'If it is not displayed correctly,' => 'Si no se muestra correctamente',
        'This is a' => 'Este es un',
        'to open it in a new window.' => 'para abrir en una nueva ventana',
        'This is a HTML email. Click here to show it.' => 'Este es un mensaje HTML. Haga click aquí para mostrarlo.',
        'Free Fields' => 'Campos Libres',
        'Merge' => 'Mezclar',
        'merged' => 'mezclado',
        'closed successful' => 'cerrado exitosamente',
        'closed unsuccessful' => 'cerrado sin éxito',
        'Locked Tickets Total' => 'Total de Tickets Bloqueados',
        'Locked Tickets Reminder Reached' => 'Recordatorio Alcanzado de Tickets Bloqueados',
        'Locked Tickets New' => 'Ticket Bloqueado Nuevo',
        'Responsible Tickets Total' => 'Total de Tickets bajo mi Responsabilidad',
        'Responsible Tickets New' => 'Ticket Nuevo bajo mi Responsabilidad',
        'Responsible Tickets Reminder Reached' => 'Recordatorio Alcanzado de Tickets bajo mi Responsabilidad',
        'Watched Tickets Total' => 'Total de Tickets Monitoreados',
        'Watched Tickets New' => 'Ticket a Monitorear Nuevo',
        'Watched Tickets Reminder Reached' => 'Recordatorio Alcanzado de Tickets Monitoreados',
        'All tickets' => 'Todos los tickets',
        'Available tickets' => '',
        'Escalation' => 'Escalado',
        'last-search' => '',
        'QueueView' => 'Ver la fila',
        'Ticket Escalation View' => 'Ver Escalado del Ticket',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => 'nuevo',
        'open' => 'abierto',
        'Open' => 'Abierto',
        'Open tickets' => '',
        'closed' => 'cerrado',
        'Closed' => 'Cerrado',
        'Closed tickets' => '',
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
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Ticket "%s" created!' => 'Ticket "%s" creado',
        'Ticket Number' => 'Ticket Número',
        'Ticket Object' => 'Objeto Ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'No existe el Ticket Número "%s", no se puede vincular',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Ticket selected.' => '',
        'Ticket is locked by another agent.' => '',
        'Ticket locked.' => '',
        'Don\'t show closed Tickets' => 'No mostrar los tickets cerrados',
        'Show closed Tickets' => 'Mostrar Tickets cerrados',
        'New Article' => 'Nuevo Artículo',
        'Unread article(s) available' => 'Artículo(s) sin leer disponible',
        'Remove from list of watched tickets' => 'Quitar de la lista de tickets monitoreados',
        'Add to list of watched tickets' => 'Agregar a la lista de tickets monitoreados',
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
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Resumen de todos los tickets abiertos',
        'Locked Tickets' => 'Tickets Bloqueados',
        'My Locked Tickets' => 'Mis Tickets Bloqueados',
        'My Watched Tickets' => 'Mis Tickets Monitoreados',
        'My Responsible Tickets' => 'Tickets bajo mi Responsabilidad',
        'Watched Tickets' => 'Tickets Monitoreados',
        'Watched' => 'Monitoreado',
        'Watch' => 'Monitorear',
        'Unwatch' => 'Dejar de monitorear',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => 'Desbloquearlo para devolverlo a la fila',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'Cambiar los campos libres del ticket',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'Revisar un ticket',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'Marcar como correo no deseado',
        'My Queues' => 'Mis Filas',
        'Shown Tickets' => 'Tickets Mostrados',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Su correo con número de ticket "<OTRS_TICKET>" se unió a "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: Tiempo para primera respuesta ha vencido (%s)',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: Tiempo para primera respuesta vencerá en %s',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: Tiempo para actualización ha vencido (%s)',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: Tiempo para actualización vencerá en %s',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: Tiempo para solución ha vencido (%s)',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: Tiempo para solución vencerá en %s',
        'There are more escalated tickets!' => 'No hay más tickets escalados',
        'Plain Format' => 'Sin formato',
        'Reply All' => 'Responder a todos',
        'Direction' => 'Dirección',
        'Agent (All with write permissions)' => 'Agente (todos con permiso de escritura)',
        'Agent (Owner)' => 'Agente (Propietario)',
        'Agent (Responsible)' => 'Agente (Responsable)',
        'New ticket notification' => 'Notificación de nuevos tickets',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Notifíqueme si hay un nuevo ticket en "Mis Filas".',
        'Send new ticket notifications' => 'Enviar notificaciones de ticket nuevo',
        'Ticket follow up notification' => 'Notificación de seguimiento de ticket',
        'Ticket lock timeout notification' => 'Notificación de bloqueo de tickets por tiempo',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Notifíqueme si un ticket es desbloqueado por el sistema',
        'Send ticket lock timeout notifications' => 'Enviar notificaciones de ticket bloqueado por tiempo de espera',
        'Ticket move notification' => 'Notificación de reubicación de ticket',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Notifíqueme si un ticket es colocado en una de "Mis Filas".',
        'Send ticket move notifications' => 'Enviar notificaciones de reubicación de ticket',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => 'Fila personal',
        'QueueView refresh time' => 'Tiempo de actualización de la vista de filas',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Si se habilita, la vista de filas se actualizará automáticamente después del tiempo especificado.',
        'Refresh QueueView after' => 'Actualizar la vista de filas después de',
        'Screen after new ticket' => 'Pantalla posterior a nuevo ticket',
        'Show this screen after I created a new ticket' => 'Mostrar esta pantalla después de crear un ticket nuevo',
        'Closed Tickets' => 'Tickets Cerrados',
        'Show closed tickets.' => 'Mostrar Tickets cerrados',
        'Max. shown Tickets a page in QueueView.' => 'Cantidad de Tickets a mostrar en la Vista de Fila',
        'Ticket Overview "Small" Limit' => 'Límite de vista de resumen "Pequeña" de tickets',
        'Ticket limit per page for Ticket Overview "Small"' => 'Límite de tickets por página mostrados en la vista de resumen "Pequeña"',
        'Ticket Overview "Medium" Limit' => 'Límite de la vista de resumen "Mediana" de tickets',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Límite de tickets por página mostrados en la vista de resumen "Mediana"',
        'Ticket Overview "Preview" Limit' => 'Límite de la vista de resumen "Preliminar" de tickets',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Límite de tickets por página mostrados en la vista de resumen "Preliminar"',
        'Ticket watch notification' => 'Notificación de ticket monitoreado',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Quiero recibir las mismas notificaciones que se envíen a los propietaios de mis tickets monitoreados',
        'Send ticket watch notifications' => 'Enviar notificaciones de ticket monitoreado',
        'Out Of Office Time' => 'Tiempo de ausencia de la oficina',
        'New Ticket' => 'Nuevo Ticket',
        'Create new Ticket' => 'Crear un nuevo Ticket',
        'Customer called' => 'Llamada de Cliente',
        'phone call' => 'llamada telefónica',
        'Phone Call Outbound' => 'Llamada telefónica saliente',
        'Phone Call Inbound' => '',
        'Reminder Reached' => 'Recordatorios alcanzados',
        'Reminder Tickets' => 'Tickets de recordatorios',
        'Escalated Tickets' => 'Tickets escalados',
        'New Tickets' => 'Nuevos tickets',
        'Open Tickets / Need to be answered' => 'Tickets Abiertos / Que necesitan de una respuesta',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Todos los tickets abiertos en los que ya se trabajó, pero necesitan una respuesta',
        'All new tickets, these tickets have not been worked on yet' => 'Todos los tickets nuevos en los que aún no se ha trabajado',
        'All escalated tickets' => 'Todos los tickets escalados',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Todos los tickets que han llegado a la fecha de recordatorio',
        'Archived tickets' => '',
        'Unarchived tickets' => '',
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
        'History::TicketDynamicFieldUpdate' => 'Actualizado: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Solicitud de cliente vía web.',
        'History::TicketLinkAdd' => 'Añadido enlace al ticket "%s".',
        'History::TicketLinkDelete' => 'Eliminado enlace al ticket "%s".',
        'History::Subscribe' => 'Añadida subscripción para el usuario "%s".',
        'History::Unsubscribe' => 'Eliminada subscripción para el usuario "%s".',
        'History::SystemRequest' => 'Petición del Sistema (%s).',
        'History::ResponsibleUpdate' => 'El responsable nuevo es "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mié',
        'Thu' => 'Jue',
        'Fri' => 'Vie',
        'Sat' => 'Sáb',

        # Template: AdminAttachment
        'Attachment Management' => 'Administración de Anexos',
        'Actions' => 'Acciones',
        'Go to overview' => 'Ir la vista de resumen',
        'Add attachment' => 'Adjuntar archivo',
        'List' => 'Listar',
        'Validity' => '',
        'No data found.' => 'No se encontraron datos.',
        'Download file' => 'Descargar archivo',
        'Delete this attachment' => 'Eliminar este archivo adjunto',
        'Add Attachment' => 'Adjuntar Archivo',
        'Edit Attachment' => 'Modificar Archivo Adjunto',
        'This field is required.' => 'Este es un campo obligatorio.',
        'or' => 'o',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Administración de Respuestas Automáticas',
        'Add auto response' => 'Agregar auto respuesta',
        'Add Auto Response' => 'Agregar Auto Respuesta',
        'Edit Auto Response' => 'Modificar Auto Respuesta',
        'Response' => 'Respuesta',
        'Auto response from' => 'Auto respuesta de',
        'Reference' => 'Referencia',
        'You can use the following tags' => 'Puede utilizar las siguientes etiquetas',
        'To get the first 20 character of the subject.' => 'Para obtener los primeros 20 caracteres del asunto.',
        'To get the first 5 lines of the email.' => 'Para obtener las primeras 5 líneas del correo.',
        'To get the realname of the sender (if given).' => 'Para obtener el nombre real del remitente (si se proporcionó).',
        'To get the article attribute' => 'Para obtener el atributo del artículo',
        ' e. g.' => 'Por ejemplo:',
        'Options of the current customer user data' => 'Opciones para los datos del cliente actual',
        'Ticket owner options' => 'Opciones para el propietario del ticket',
        'Ticket responsible options' => 'Opciones para el responsable del ticket',
        'Options of the current user who requested this action' => 'Opciones del usuario actual, quien solicitó esta acción',
        'Options of the ticket data' => 'Opciones de los datos del ticket',
        'Config options' => 'Opciones de configuración',
        'Example response' => 'Respuesta de ejemplo',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Administración de Compañías del Cliente',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer company' => 'Añadir compañía de cliente',
        'Please enter a search term to look for customer companies.' => 'Por favor, introduzca un parámetro de búsqueda para buscar compañías de clientes.',
        'Add Customer Company' => 'Añadir Compañía de Cliente',

        # Template: AdminCustomerUser
        'Customer Management' => 'Gestión de Clientes',
        'Add customer' => 'Añadir cliente',
        'Select' => 'Seleccionar',
        'Hint' => 'Pista',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Se requiere un cliente para llevar un historial del mismo e iniciar sesión a través de la interfaz del cliente.',
        'Please enter a search term to look for customers.' => 'Por favor, introduzca un parámetro de búsqueda para buscar clientes',
        'Last Login' => 'Último inicio de sesión',
        'Add Customer' => 'Añadir Cliente',
        'Edit Customer' => 'Modificar Cliente',
        'This field is required and needs to be a valid email address.' =>
            'Este es un campo obligatorio y tiene que ser una dirección de correo electrónico válida.',
        'This email address is not allowed due to the system configuration.' =>
            'Esta dirección de correo electrónico no está permitida, debido a la configuración del sistema.',
        'This email address failed MX check.' => 'Esta dirección de correo electrónico falló la verificación MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema con el DNS. Por favor, verifique su configuración y el registro de errores.',
        'The syntax of this email address is incorrect.' => 'La sintáxis de esta dirección de correo electrónico es incorrecta.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gestionar Relaciones Cliente-Grupo',
        'Notice' => 'Aviso',
        'This feature is disabled!' => 'Esta característica está deshabilitada',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utilice esta función únicamente si desea definir permisos de grupo para los clientes.',
        'Enable it here!' => 'Habilítelo aquí',
        'Search for customers.' => '',
        'Edit Customer Default Groups' => 'Modificar los grupos por defecto de los clientes',
        'These groups are automatically assigned to all customers.' => 'Estos grupos se asignan automáticamente a todos los clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Es posible gestionar estos grupos por medio de la configuración "CustomerGroupAlwaysGroups"',
        'Filter for Groups' => 'Filtro para Grupos',
        'Select the customer:group permissions.' => 'Seleccione los permisos cliente:grupo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Si nada se selecciona, no habrá permisos para este grupo y los tickets no estarán disponibles para el cliente.',
        'Search Result:' => 'Resultado de la búsqueda:',
        'Customers' => 'Clientes',
        'Groups' => 'Grupos',
        'No matches found.' => 'No se encontraron coincidencias.',
        'Change Group Relations for Customer' => 'Modificar las Relaciones de Grupo de los Clientes',
        'Change Customer Relations for Group' => 'Modificar las Relaciones de Cliente de los Grupos',
        'Toggle %s Permission for all' => 'Activar permiso %s para todos',
        'Toggle %s permission for %s' => 'Activar permiso %s para %s',
        'Customer Default Groups:' => 'Grupos por defecto de los clientes:',
        'No changes can be made to these groups.' => 'Estos grupos no se pueden modificar.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Acceso de sólo lectura a los tickets de este grupo/fila.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Acceso completo de lectura y escritura a los tickets de este grupo/fila.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Administrar las relaciones Cliente-Servicios',
        'Edit default services' => 'Modificar los servicios por defecto',
        'Filter for Services' => 'Filtro para Servicios',
        'Allocate Services to Customer' => 'Asignar Servicios al Cliente',
        'Allocate Customers to Service' => 'Asignar Clientes al Servicio',
        'Toggle active state for all' => 'Habilitar estado activo para todos',
        'Active' => 'Activo',
        'Toggle active state for %s' => 'Habilitar estado activo para %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => 'Orden',
        'Object' => 'Objeto',
        'Delete this field' => '',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '',
        'Delete field' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '',
        'Field' => '',
        'Go back to overview' => '',
        'General' => '',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '',
        'Changing this value will require manual changes in the system.' =>
            '',
        'This is the name to be shown on the screens where the field is active.' =>
            '',
        'Field order' => '',
        'This field is required and must be numeric.' => '',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '',
        'Field type' => '',
        'Object type' => '',
        'Field Settings' => '',
        'Default value' => 'Valor por defecto',
        'This is the default value for this field.' => '',
        'Save' => 'Guardar',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '',
        'This field must be numeric.' => '',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => '',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '',
        'Years in the past to display (default: 5 years).' => '',
        'Years in the future' => '',
        'Years in the future to display (default: 5 years).' => '',
        'Show link' => '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => 'Clave',
        'Value' => 'Valor',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => '',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => '',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',

        # Template: AdminEmail
        'Admin Notification' => 'Notificación del Administrador',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '',
        'Create Administrative Message' => '',
        'Your message was sent to' => 'Mensaje enviado a',
        'Send message to users' => 'Enviar mensaje a los usuarios',
        'Send message to group members' => 'Enviar mensaje a los miembros del grupo',
        'Group members need to have permission' => 'Los miembros del grupo necesitan tener permiso',
        'Send message to role members' => 'Enviar mensaje a los miembros del rol',
        'Also send to customers in groups' => 'También enviar a los clientes de los grupos',
        'Body' => 'Cuerpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agente Genérico',
        'Add job' => 'Agregar tarea',
        'Last run' => 'Última ejecución',
        'Run Now!' => 'Ejecutar ahora',
        'Delete this task' => 'Eliminar esta tarea',
        'Run this task' => 'Ejecutar esta tarea',
        'Job Settings' => 'Configuraciones de la Tarea',
        'Job name' => 'Nombre de la tarea',
        'Currently this generic agent job will not run automatically.' =>
            'Actualmente esta tarea del agente genérico no se ejecutará automáticamente',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Para habilitar la ejecución automática, seleccione al menos un valor de minutos, horas y días.',
        'Schedule minutes' => 'Fijar minutos',
        'Schedule hours' => 'Fijar horas',
        'Schedule days' => 'Fijar días',
        'Toggle this widget' => 'Activar este widget',
        'Ticket Filter' => 'Filtro de Ticket',
        '(e. g. 10*5155 or 105658*)' => '(ej: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(ej: 234321)',
        'Customer login' => 'Inicio de sesión del cliente',
        '(e. g. U5150)' => '(ej: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Búsqueda en todo el texto del artículo (por ejemplo: "Mar*in" o "Baue*").',
        'Agent' => 'Agente',
        'Ticket lock' => 'Bloqueo de ticket',
        'Create times' => 'Tiempos de creación',
        'No create time settings.' => 'No existen configuraciones para tiempo de creación.',
        'Ticket created' => 'Ticket creado',
        'Ticket created between' => 'Ticket creado entre',
        'Change times' => '',
        'No change time settings.' => 'Sin cambio de marca de tiempo',
        'Ticket changed' => 'Ticket modificado',
        'Ticket changed between' => 'Ticket modificado entre',
        'Close times' => 'Tiempos de cierre',
        'No close time settings.' => 'No existen configuraciones para tiempo de cierre.',
        'Ticket closed' => 'Ticket cerrado',
        'Ticket closed between' => 'Ticket cerrado entre',
        'Pending times' => 'Tiempos de espera',
        'No pending time settings.' => 'No existen configuraciones para tiempo en espera',
        'Ticket pending time reached' => 'El tiempo en espera del Ticket ha sido alcanzado',
        'Ticket pending time reached between' => 'El tiempo en espera del Ticket ha sido alcanzado entre',
        'Escalation times' => 'Tiempos de escalado',
        'No escalation time settings.' => 'No existen configuraciones para tiempo de escalado',
        'Ticket escalation time reached' => 'El tiempo de escalado del Ticket ha sido alcanzado',
        'Ticket escalation time reached between' => 'El tiempo de escalado del Ticket ha sido alcanzado entre',
        'Escalation - first response time' => 'Escalado - tiempo para la primer respuesta',
        'Ticket first response time reached' => 'El tiempo para la primer respuesta del Ticket ha sido alcanzado',
        'Ticket first response time reached between' => 'El tiempo para la primer respuesta del Ticket ha sido alcanzado entre',
        'Escalation - update time' => 'Escalado - tiempo para la actualización',
        'Ticket update time reached' => 'El tiempo para la actualización del Ticket ha sido alcanzado',
        'Ticket update time reached between' => 'El tiempo para la actualización del Ticket ha sido alcanzado entre',
        'Escalation - solution time' => 'Escalado - tiempo para la solución',
        'Ticket solution time reached' => 'El tiempo para la solución del Ticket ha sido alcanzado',
        'Ticket solution time reached between' => 'El tiempo para la solución del Ticket ha sido alcanzado entre',
        'Archive search option' => 'Opción de búsqueda en el archivo',
        'Ticket Action' => 'Acción del Ticket',
        'Set new service' => 'Establecer servicio nuevo',
        'Set new Service Level Agreement' => 'Establecer Acuerdo de Nivel de Servicio nuevo',
        'Set new priority' => 'Establecer prioridad nueva',
        'Set new queue' => 'Establecer fila nueva',
        'Set new state' => 'Establecer estado nuevo',
        'Set new agent' => 'Establecer agente nuevo',
        'new owner' => 'propietario nuevo',
        'new responsible' => '',
        'Set new ticket lock' => 'Establecer bloqueo de ticket nuevo',
        'New customer' => 'Cliente nuevo',
        'New customer ID' => 'ID de cliente nuevo',
        'New title' => 'Título nuevo',
        'New type' => 'Tipo nuevo',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => 'Tickets seleccionados del archivo',
        'Add Note' => 'Añadir Nota',
        'Time units' => 'Unidades de tiempo',
        ' (work units)' => ' (unidades de trabajo)',
        'Ticket Commands' => 'Instrucciones de Ticket',
        'Send agent/customer notifications on changes' => 'Enviar notificación de cambios al agente/cliente',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Este comando se ejecutará. ARG[0] será el número del ticket y ARG[0] el identificador del ticket.',
        'Delete tickets' => 'Eliminar tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Advertencia: ¡Todos los tickets afectados serán eliminados de la base de datos y no se podrá restaurar!',
        'Execute Custom Module' => 'Ejecutar Módulo Personalizado',
        'Param %s key' => 'Parámetro %s llave',
        'Param %s value' => 'Parámetro %s valor',
        'Save Changes' => 'Guardar Cambios',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '¡%s Tickets afectados! ¿Qué desea hacer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Advertencia: Eligió la opción ELIMINAR. ¡Todos los tickets eliminados se perderán!. ',
        'Edit job' => 'Modificar tarea',
        'Run job' => 'Ejecutar tarea',
        'Affected Tickets' => 'Tickets Afectados',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Tiempo',
        'Remote IP' => '',
        'Loading' => 'Cargando',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Refrescar',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Show or hide the content' => 'Mostrar u ocultar el contenido',
        'Clear debug log' => '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => '',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Please provide a unique name for this web service invoker.' => '',
        'The name you entered already exists.' => '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => '',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Event Triggers' => '',
        'Asynchronous' => '',
        'Delete this event' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => '',
        'Save and finish' => '',
        'Delete this Invoker' => '',
        'Delete this Event Trigger' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => '',
        'Mapping Simple' => '',
        'Default rule for unmapped keys' => '',
        'This rule will apply for all keys with no mapping rule.' => '',
        'Default rule for unmapped values' => '',
        'This rule will apply for all values with no mapping rule.' => '',
        'New key map' => '',
        'Add key mapping' => '',
        'Mapping for Key ' => '',
        'Remove key mapping' => '',
        'Key mapping' => '',
        'Map key' => '',
        'matching the' => '',
        'to new key' => '',
        'Value mapping' => '',
        'Map value' => '',
        'to new value' => '',
        'Remove value mapping' => '',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => '',
        'Delete this Key Mapping' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => '',
        'Change operation %s' => '',
        'Do you really want to delete this operation?' => '',
        'Operation Details' => '',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => '',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => '',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => '',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'Certificate Password File' => '',
        'The password to open the SSL certificate.' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Proxy Server' => '',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => '',
        'The password for the proxy user.' => '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => '',
        'Clone web service' => '',
        'The name must be unique.' => '',
        'Clone' => '',
        'Export web service' => '',
        'Import web service' => '',
        'Configuration File' => '',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => 'Importar',
        'Configuration history' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Details' => '',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => '',
        'Inbound mapping' => '',
        'Outbound mapping' => '',
        'Delete this action' => '',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',
        'Delete webservice' => '',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => '',
        'Import webservice' => '',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => '',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'Versión',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => '',
        'Restore' => '',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ATENCIÓN: Cuando cambia el nombre del grupo \'admin\', antes de realizar los cambios apropiados en SysConfig, bloqueará el panel de administración! Si esto sucediera, por favor vuelva a renombrar el grupo para administrar por declaración SQL.',
        'Group Management' => 'Administración de grupos',
        'Add group' => 'Añadir grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'El grupo admin es para usar el área de administración y el grupo stats para usar el área estadisticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crear grupos nuevos para manejar los permisos de acceso para los diferentes grupos de agentes (por ejemplo: departamento de compras, soporte técnico, ventas, etc.).',
        'It\'s useful for ASP solutions. ' => 'Es útil para soluciones ASP.',
        'Add Group' => 'Añadir Grupo',
        'Edit Group' => 'Modificar Grupo',

        # Template: AdminLog
        'System Log' => 'Log del Sistema',
        'Here you will find log information about your system.' => 'Aquí puede encontrar información de registros sobre su sistema.',
        'Hide this message' => '',
        'Recent Log Entries' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Administración de Cuentas de Correo',
        'Add mail account' => 'Añadir dirección de correo',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Todos los correos entrantes con una cuenta serán enviados a la fila seleccionada',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Si su cuenta está validada, las cabeceras X-OTRS ya existentes en la llegada se utilizarán para la prioridad. El filtro Postmaster se usa de todas formas.',
        'Host' => 'Host',
        'Delete account' => 'Eliminar cuenta',
        'Fetch mail' => 'Obtener correo',
        'Add Mail Account' => 'Agregar Dirección de Correo',
        'Example: mail.example.com' => 'Ejemplo: correo.ejemplo.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Confiable',
        'Dispatching' => 'Remitiendo',
        'Edit Mail Account' => 'Modificar Dirección de Correo',

        # Template: AdminNavigationBar
        'Admin' => 'Administración',
        'Agent Management' => 'Gestión de Agentes',
        'Queue Settings' => 'Configuraciones de Fila',
        'Ticket Settings' => 'Configuraciones de Ticket',
        'System Administration' => 'Administración del Sistema',

        # Template: AdminNotification
        'Notification Management' => 'Administración de Notificaciones',
        'Select a different language' => '',
        'Filter for Notification' => 'Filtro para Notiticación',
        'Notifications are sent to an agent or a customer.' => 'Las notificaciones se envían a un agente o cliente',
        'Notification' => 'Notificaciones',
        'Edit Notification' => 'Modificar Notificación',
        'e. g.' => 'por ejemplo:',
        'Options of the current customer data' => 'Opciones para los datos del cliente actual',

        # Template: AdminNotificationEvent
        'Add notification' => 'Agregar notificación',
        'Delete this notification' => 'Eliminar esta notificación',
        'Add Notification' => 'Agregar Notificación',
        'Recipient groups' => 'Grupos destinatarios',
        'Recipient agents' => 'Agentes destinatarios',
        'Recipient roles' => 'Roles destinatarios',
        'Recipient email addresses' => 'Direcciones de correo electrónico destinatarias',
        'Article type' => 'Tipo de artículo',
        'Only for ArticleCreate event' => 'Sólo para el evento ArticleCreate',
        'Subject match' => 'Coincidencia de asunto',
        'Body match' => 'Coincidencia del cuerpo',
        'Include attachments to notification' => 'Incluir archivos adjuntos en la notificación',
        'Notification article type' => 'Tipo de notificaciones de artículo',
        'Only for notifications to specified email addresses' => 'Sólo para notificaciones para las direcciones de correo electrónicas especificadas',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para obtener los primeros 20 caracters del Sujeto (del último artículo del agente).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para obtener las primeras 5 líneas del cuerpo (del último artículo del agente).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para obtener los primeros 20 caracters del Sujeto (del último artículo del cliente).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para obtener las primeras 5 líneas del cuerpo (del último artículo del cliente).',

        # Template: AdminPGP
        'PGP Management' => 'Administración PGP',
        'Use this feature if you want to work with PGP keys.' => 'Use esta función si desea trabajar con llaves PGP.',
        'Add PGP key' => 'Agregar llave PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'De esta forma puede editar directamente el anillo de Claves configurado en Sysconfig',
        'Introduction to PGP' => 'Introducción a PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => 'Bit',
        'Fingerprint' => 'Huella',
        'Expires' => 'Expira',
        'Delete this key' => 'Eliminar esta llave',
        'Add PGP Key' => 'Agregar Llave PGP',
        'PGP key' => 'Llave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestor de paquetes',
        'Uninstall package' => 'Desinstalar paquete',
        'Do you really want to uninstall this package?' => '¿Está seguro de que desea desinstalar este paquete?',
        'Reinstall package' => 'Reinstalar paquete',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '¿Está seguro de que desea reinstalar este paquete? Cualquier cambio manual se perderá.',
        'Continue' => 'Continuar',
        'Install' => 'Instalar',
        'Install Package' => 'Instalar Paquete',
        'Update repository information' => 'Actualizar la información del repositorio',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Repositorio Online',
        'Vendor' => 'Vendedor',
        'Module documentation' => 'Módulo de Documentación',
        'Upgrade' => 'Actualizar',
        'Local Repository' => 'Repositorio Local',
        'Uninstall' => 'Desinstalar',
        'Reinstall' => 'Reinstalar',
        'Feature Add-Ons' => '',
        'Download package' => 'Descargar paquete',
        'Rebuild package' => 'Reconstruir paquete',
        'Metadata' => 'Metadatos',
        'Change Log' => 'Registro de Cambios',
        'Date' => 'Fecha',
        'List of Files' => 'Lista de Archivos',
        'Permission' => 'Permiso',
        'Download' => 'Descargar',
        'Download file from package!' => 'Descargar archivo del paquete!',
        'Required' => 'Obligatorio',
        'PrimaryKey' => 'ClavePrimaria',
        'AutoIncrement' => 'AutoIncrementar',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Diferencias de archivo para %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log de rendimiento',
        'This feature is enabled!' => 'Esta característica está habilitada',
        'Just use this feature if you want to log each request.' => 'Use esta característica sólo si desea registrar cada petición.',
        'Activating this feature might affect your system performance!' =>
            'Activar esta opción podría afectar el rendimiento de su sistema!',
        'Disable it here!' => 'Deshabilítelo aquí',
        'Logfile too large!' => 'Archivo de log muy grande',
        'The logfile is too large, you need to reset it' => 'El archivo de registros es muy grande, necesita restablecerlo',
        'Overview' => 'Resumen',
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

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Administración del filtro maestro',
        'Add filter' => 'Agregar filtro',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para remitir o filtrar correos electrónicos entrantes basándose en los encabezados de dichos correos. También es posible utilizar Expresiones Regulares para las coincidencias.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Si desea chequear sólo la dirección del email, use EMAILADDRESS:info@example.com en De, Para o Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Si utiliza Expresiones Regulares, también puede utilizar el valor de coincidencia en () como [***] en la acción de \'Establecer\'.',
        'Delete this filter' => 'Eliminar este filtro',
        'Add PostMaster Filter' => 'Añadir Filtro de Administración de Correo',
        'Edit PostMaster Filter' => 'Modificar Filtro de Administración de Correo',
        'Filter name' => 'Nombre del filtro',
        'The name is required.' => '',
        'Stop after match' => 'Parar al coincidir',
        'Filter Condition' => 'Condición del Filtro',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'Establecer los Encabezados del Correo Electrónico',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Administración de Prioridades',
        'Add priority' => 'Añadir prioridad',
        'Add Priority' => 'Añadir Prioridad',
        'Edit Priority' => 'Modificar Prioridad',

        # Template: AdminQueue
        'Manage Queues' => 'Gestionar Filas',
        'Add queue' => 'Agregar fila',
        'Add Queue' => 'Agregar Fila',
        'Edit Queue' => 'Modificar Fila',
        'Sub-queue of' => 'Subfila de',
        'Unlock timeout' => 'Tiempo para desbloqueo automático',
        '0 = no unlock' => '0 = sin desbloqueo',
        'Only business hours are counted.' => 'Sólo se contarán las horas de trabajo',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Si un agente bloquea un ticket y no lo cierra antes de que el tiempo de espera termine, dicho ticket se desbloqueará y estará disponible para otros agentes.',
        'Notify by' => 'Notificado por',
        '0 = no escalation' => '0 = sin escalado',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Si no se ha contactado al cliente, ya sea por medio de una nota externa o por teléfono, de un ticket nuevo antes de que el tiempo definido aquí termine, el ticket escalará.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Si se añade un artículo, como seguimiento vía correo electrónico o la interfaz del cliente, el tiempo de escalado de actualización se reinicia. Si no se ha contactado al cliente, ya sea por medio de una nota externa o por teléfono, de un ticket antes de que el tiempo definido aquí termine, el ticket escalará.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Si el ticket no se cierra antes de que el tiempo definido aquí termine, dicho ticket escalará.',
        'Follow up Option' => 'Opción de seguimiento',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica si seguimiento a tickets cerrados: reabrirá dichos tickets, se rechazará o generará un ticket nuevo.',
        'Ticket lock after a follow up' => 'Bloquear un ticket después del seguimiento',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Si un ticket está cerrado y el cliente le da seguimiento, el ticket se bloqueará para el antigüo propietario.',
        'System address' => 'Dirección del Sistema',
        'Will be the sender address of this queue for email answers.' => 'Será la dirección del emisor en esta fila para respuestas por correo.',
        'Default sign key' => 'Llave de firma por defecto',
        'The salutation for email answers.' => 'Saludo para respuestas por correo.',
        'The signature for email answers.' => 'Firma para respuestas por correo.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Administrar Relaciones Fila-Auto Respuesta',
        'Filter for Queues' => 'Filtro para Filas',
        'Filter for Auto Responses' => 'Filtro para Auto Respuestas',
        'Auto Responses' => 'Respuestas Automáticas',
        'Change Auto Response Relations for Queue' => 'Modificar Relaciones de Auto Respuesta para las Filas',
        'settings' => 'configuración',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Administrar Relaciones Respuesta-Fila',
        'Filter' => 'Filtro',
        'Filter for Responses' => 'Filtro para Respuestas',
        'Responses' => 'Respuestas',
        'Change Queue Relations for Response' => 'Modificar Relaciones de Fila para las Respuestas',
        'Change Response Relations for Queue' => 'Modificar Relaciones de Respuestas para las Filas',

        # Template: AdminResponse
        'Manage Responses' => 'Gestionar Respuestas',
        'Add response' => 'Añadir respuesta',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            '',
        'Don\'t forget to add new responses to queues.' => '',
        'Delete this entry' => 'Eliminar esta entrada',
        'Add Response' => 'Añadir Respuesta',
        'Edit Response' => 'Modificar Respuesta',
        'The current ticket state is' => 'El estado actual del ticket es',
        'Your email address is' => 'Su dirección de correo electrónico es',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Administrar Relaciones Respuestas <-> Archivos Adjuntos',
        'Filter for Attachments' => 'Filtro para Archivos Adjuntos',
        'Change Response Relations for Attachment' => 'Modificar Relaciones de Respuesta para los Archivos Adjuntos',
        'Change Attachment Relations for Response' => 'Modificar Relaciones de Archivos Adjuntos para las Respuestas',
        'Toggle active for all' => 'Activar para todos',
        'Link %s to selected %s' => 'Vínculo %s a %s seleccionados(as)',

        # Template: AdminRole
        'Role Management' => 'Administración de Roles',
        'Add role' => 'Añadir rol',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Cree un rol y coloque grupos en el mismo. Luego añada el rol a los usuarios.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'No hay roles definidos. Por favor, use el botón \'Añadir\' para crear un rol nuevo.',
        'Add Role' => 'Añadir Rol',
        'Edit Role' => 'Modificar Rol',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Administrar Relaciones Rol-Grupo',
        'Filter for Roles' => 'Filtro para Roles',
        'Roles' => 'Roles',
        'Select the role:group permissions.' => 'Seleccionar los permisos rol:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Si nada se selecciona, no habrá permisos para este grupo y los tickets no estarán disponibles para el rol.',
        'Change Role Relations for Group' => 'Modificar Relaciones de Rol para los Grupos',
        'Change Group Relations for Role' => 'Modificar Relaciones de Grupo para los Roles',
        'Toggle %s permission for all' => 'Activar permiso %s para todos',
        'move_into' => 'mover_a',
        'Permissions to move tickets into this group/queue.' => 'Permiso para mover tickets a este grupo/fila',
        'create' => 'crear',
        'Permissions to create tickets in this group/queue.' => 'Permiso para crear tickets en este grupo/fila',
        'priority' => 'prioridad',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permiso para cambiar la prioridad del ticket en este grupo/fila',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Administrar Relaciones Agente-Rol',
        'Filter for Agents' => 'Filtro para Agentes',
        'Agents' => 'Agentes',
        'Manage Role-Agent Relations' => 'Administrar Relaciones Rol-Agente',
        'Change Role Relations for Agent' => 'Modificar Relacioes de Rol para los Agentes',
        'Change Agent Relations for Role' => 'Modificar Relacioes de Agente para los Roles',

        # Template: AdminSLA
        'SLA Management' => 'Administración de SLA',
        'Add SLA' => 'Añadir SLA',
        'Edit SLA' => 'Modificar SLA',
        'Please write only numbers!' => '¡Por favor, escriba sólo números!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestion S/MIME',
        'Add certificate' => 'Añadir certificado',
        'Add private key' => 'Añadir llave privada',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Vea también',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'De esta forma Ud. puede editar directamente la certificación y claves privadas en el sistema de archivos.',
        'Hash' => '',
        'Create' => 'Crear',
        'Handle related certificates' => '',
        'Delete this certificate' => 'Eliminar este certificado',
        'Add Certificate' => 'Añadir Certificado',
        'Add Private Key' => 'Añadir Clave Privada',
        'Secret' => 'Secreto',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Administración de Saludos',
        'Add salutation' => 'Añadir saludo',
        'Add Salutation' => 'Añadir Saludo',
        'Edit Salutation' => 'Modificar Saludo',
        'Example salutation' => 'Saludo de ejemplo',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => '¡El modo seguro necesita estar habilitado!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'El Modo Seguro (normalmente) queda habilitado cuando la instalación inicial se completa.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'El Modo Seguro debe estar deshabilitado para poder reinstalar usado el instalador web.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si el modo seguro no está activo aún, hágalo a través de la Configuración del Sistema, porque su aplicación ya se está ejecutando.',

        # Template: AdminSelectBox
        'SQL Box' => 'Consola SQL',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aquí puede introducir SQL para ejecutarse directamente en la base de datos de la aplicación.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'La sintaxis de su consulta SQL tiene un error. Por favor, verifíquela.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Existe al menos un parámetro faltante para en enlace. Por favor, verifíquelo.',
        'Result format' => 'Formato del resultado',
        'Run Query' => 'Ejecutar Consulta',

        # Template: AdminService
        'Service Management' => 'Administración de Servicios',
        'Add service' => 'Añadir servicio',
        'Add Service' => 'Añadir Servicio',
        'Edit Service' => 'Modificar Servicio',
        'Sub-service of' => 'Subservicio de',

        # Template: AdminSession
        'Session Management' => 'Administración de Sesiones',
        'All sessions' => 'Todas las sesiones',
        'Agent sessions' => 'Sesiones de agente',
        'Customer sessions' => 'Sesiones de cliente',
        'Unique agents' => 'Agentes únicos',
        'Unique customers' => 'Clientes únicos',
        'Kill all sessions' => 'Finalizar todas las sesiones',
        'Kill this session' => 'Terminar esta sesión',
        'Session' => 'Sesión',
        'Kill' => 'Terminar',
        'Detail View for SessionID' => 'Vista detallada para el ID de sesión',

        # Template: AdminSignature
        'Signature Management' => 'Administración de Firmas',
        'Add signature' => 'Añadir firma',
        'Add Signature' => 'Añadir Firma',
        'Edit Signature' => 'Modificar Firma',
        'Example signature' => 'Firma de ejemplo',

        # Template: AdminState
        'State Management' => 'Administración de Estados',
        'Add state' => 'Añadir estado',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'Añadir Estado',
        'Edit State' => 'Modificar Estado',
        'State type' => 'Tipo de Estado',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuración del sistema',
        'Navigate by searching in %s settings' => 'Navegar buscando en las configuraciones %s',
        'Navigate by selecting config groups' => '',
        'Download all system config changes' => 'Descargar todos los cambios en la configuración del sistema',
        'Export settings' => 'Exportar configuraciones',
        'Load SysConfig settings from file' => 'Cargar la configuración del sistema desde archivo',
        'Import settings' => 'Importar configuraciones',
        'Import Settings' => 'Importar Configuraciones',
        'Please enter a search term to look for settings.' => 'Por favor, introduzca un parámetro de búsqueda para buscar configuraciones.',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Modificar Configuraciones',
        'This config item is only available in a higher config level!' =>
            '¡Este elemento de configuración sólo está disponible en un nivel de configuración más alto!',
        'Reset this setting' => 'Restablecer esta configuración',
        'Error: this file could not be found.' => 'Error: no se encontró el archivo.',
        'Error: this directory could not be found.' => 'Error: no se encontró el directorio.',
        'Error: an invalid value was entered.' => 'Error: se introdujo un valor inválido.',
        'Content' => 'Contenido',
        'Remove this entry' => 'Eliminar esta entrada',
        'Add entry' => 'Añadir entrada',
        'Remove entry' => 'Eliminar entrada',
        'Add new entry' => 'Añadir una entrada nueva',
        'Create new entry' => 'Crear una entrada nueva',
        'New group' => 'Grupo nuevo',
        'Group ro' => 'Grupo ro',
        'Readonly group' => 'Grupo de sólo lectura',
        'New group ro' => 'Grupo ro nuevo',
        'Loader' => 'Cargador',
        'File to load for this frontend module' => 'Archivo a cargarse para este módulo frontend',
        'New Loader File' => 'Archivo nuevo para el Cargador',
        'NavBarName' => 'NombreBarraNavegación',
        'NavBar' => 'BarraNavegación',
        'LinkOption' => 'OpciónEnlace',
        'Block' => 'Bloquear',
        'AccessKey' => 'TeclaAcceso',
        'Add NavBar entry' => 'Añadir entrada de BarraNavegación',
        'Year' => 'Año',
        'Month' => 'Mes',
        'Day' => 'Día',
        'Invalid year' => 'Año inválido',
        'Invalid month' => 'Mes inválido',
        'Invalid day' => 'Día inválido',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Administración de Direcciones de Correo del sistema',
        'Add system address' => 'Añadir dirección del sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todos los correos electrónicos entrantes con esta dirección en Para o Cc serán enviados a la fila seleccionada.',
        'Email address' => 'Dirección de correo electrónico',
        'Display name' => 'Nombre mostrado',
        'Add System Email Address' => 'Agregar Dirección de Correo Electrónico del Sistema',
        'Edit System Email Address' => 'Modificar Dirección de Correo Electrónico del Sistema',
        'The display name and email address will be shown on mail you send.' =>
            'El nombre a mostrar y la dirección de correo electrónico se agregarán en los correos que ud. envíe.',

        # Template: AdminType
        'Type Management' => 'Administración de Tipos',
        'Add ticket type' => 'Añadir tipo de ticket',
        'Add Type' => 'Añadir Tipo',
        'Edit Type' => 'Modificar Tipo',

        # Template: AdminUser
        'Add agent' => 'Añadir agente',
        'Agents will be needed to handle tickets.' => 'Los agentes se requieren para que se encarguen de los tickets.',
        'Don\'t forget to add a new agent to groups and/or roles!' => '¡Recuerde añadir a los agentes nuevos a grupos y/o roles!',
        'Please enter a search term to look for agents.' => 'Por favor, introduzca un parámetro de búsqueda para buscar agentes.',
        'Last login' => 'Último inicio de sesión',
        'Login as' => 'Conectarse como',
        'Switch to agent' => 'Cambiar a agente',
        'Add Agent' => 'Añadir Agente',
        'Edit Agent' => 'Modificar Agente',
        'Firstname' => 'Nombre',
        'Lastname' => 'Apellido',
        'Password is required.' => '',
        'Start' => 'Iniciar',
        'End' => 'Fin',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gestionar Relaciones Agente-Grupo',
        'Change Group Relations for Agent' => 'Modificar Relaciones de Grupo para los Agentes',
        'Change Agent Relations for Group' => 'Modificar Relaciones de Agente para los Grupos',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permisos para añadir notas a los tickets de este/a grupo/fila',
        'owner' => 'propietario',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permisos para modificar el propietario de los tickets en este/a grupo/fila.',

        # Template: AgentBook
        'Address Book' => 'Libreta de Direcciones',
        'Search for a customer' => 'Buscar un cliente',
        'Add email address %s to the To field' => 'Añadir dirección de correo electrónico %s al campo Para',
        'Add email address %s to the Cc field' => 'Añadir dirección de correo electrónico %s al campo Cc',
        'Add email address %s to the Bcc field' => 'Añadir dirección de correo electrónico %s al campo Bcc',
        'Apply' => 'Aplicar',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Búsqueda de cliente',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Panel principal',

        # Template: AgentDashboardCalendarOverview
        'in' => 'en',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está disponible!',
        'Please update now.' => 'Por favór, actualize ahora',
        'Release Note' => 'Notas de versión',
        'Level' => 'Nivel',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Enviado hace %s.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '',
        'My watched tickets' => '',
        'My responsibilities' => '',
        'Tickets in My Queues' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'El ticket ha sido bloqueado',
        'Undo & close window' => 'Deshacer y cerrar la ventana',

        # Template: AgentInfo
        'Info' => 'Información',
        'To accept some news, a license or some changes.' => 'Para aceptar noticias, una licencia o algunos cambios.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Objeto Vinculado: %s',
        'Close window' => 'Cerrar ventana',
        'go to link delete screen' => 'ir a la ventana del vínculo de eliminar',
        'Select Target Object' => 'Seleccionar Objetivo',
        'Link Object' => 'Enlazar Objeto',
        'with' => 'con',
        'Unlink Object: %s' => 'Objecto desvinculado: %s',
        'go to link add screen' => 'ir a la ventana del vínculo de añadir',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Modificar mis preferencias',

        # Template: AgentSpelling
        'Spell Checker' => 'Chequeo Ortográfico',
        'spelling error(s)' => 'errores ortográficos',
        'Apply these changes' => 'Aplicar los cambios',

        # Template: AgentStatsDelete
        'Delete stat' => 'Eliminar estadística',
        'Stat#' => 'Estadística#',
        'Do you really want to delete this stat?' => '¿Realmente desea eliminar esta estadística?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Paso %s',
        'General Specifications' => 'Especificaciones Generales',
        'Select the element that will be used at the X-axis' => 'Seleccione el elemento que se utilizará en el eje X',
        'Select the elements for the value series' => 'Seleccione los elementos para los valores de la serie',
        'Select the restrictions to characterize the stat' => 'Seleccione las restricciones para caracterizar la estadística',
        'Here you can make restrictions to your stat.' => 'Aquí puede declarar restricciones para sus estadísticas.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Si elimina el candado en la casilla "Fijo", el agente que genera la estadística puede cambiar los atributos del elemento correspondiente',
        'Fixed' => 'Fijo',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor seleccione sólo un elemento o desactive el botón \'Fijo\.',
        'Absolute Period' => 'Periodo Absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Periodo Relativo',
        'The last' => 'El último',
        'Finish' => 'Finalizar',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permisos',
        'You can select one or more groups to define access for different agents.' =>
            'Puede seleccionar uno o más grupos para definir el acceso para los diferentes agentes.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Algunos formatos de resultado están deshabilitados porque al menos un paquete requerido no está instalado.',
        'Please contact your administrator.' => 'Por favor, contacte a su administrador.',
        'Graph size' => 'Tamaño del gráfico',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Si utiliza un gráfico como formato de salida debe seleccionar al menos un tamaño de gráfico.',
        'Sum rows' => 'Sumar filas',
        'Sum columns' => 'Sumar columnas',
        'Use cache' => 'Usar caché',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'La mayoría de las estadisticas pueden ser conservadas en cache. Esto acelera la presentación de esta estadística.',
        'If set to invalid end users can not generate the stat.' => 'Si se define como inválida, los usuarios finales no podrán generar la estadística.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Aquí se pueden definir los valores de la serie.',
        'You have the possibility to select one or two elements.' => 'Puede seleccionar uno o dos elementos.',
        'Then you can select the attributes of elements.' => 'Luego puede seleccionar los atributos de los elementos.',
        'Each attribute will be shown as single value series.' => 'Cada atributo se mostrará como un solo valor de la serie.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Si no selecciona algún atributo, todos los atributos del elemento se usarán si se genera una estadística, así como atributos nuevos que se hayan agregado desde la última configuración.',
        'Scale' => 'Escala',
        'minimal' => 'mínimo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Recuerde, la escala para los valores de la serie debe ser mayor que la escala para el eje-X (ej: eje-X => Mes, ValorSeries => Año).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Aquí puede definir el eje X. Puede seleccionar un elemento por medio del botón de radio.',
        'maximal period' => 'periodo máximo',
        'minimal scale' => 'escala mínima',

        # Template: AgentStatsImport
        'Import Stat' => 'Importar estadística',
        'File is not a Stats config' => 'El archivo no es una configuración de estadísticas',
        'No File selected' => 'No hay archivo seleccionado',

        # Template: AgentStatsOverview
        'Stats' => 'Estadísticas',

        # Template: AgentStatsPrint
        'Print' => 'Imprimir',
        'No Element selected.' => 'No hay elemento seleccionado',

        # Template: AgentStatsView
        'Export config' => 'Exportar configuración',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Con los campos de entrada y selección es posible influir en el formato y contenido de la estadística.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Los campos de entrada y formatos exactos que se pueden infuenciar son definidos por el administrador de la estadística.',
        'Stat Details' => 'Detalles de la estadística',
        'Format' => 'Formato',
        'Graphsize' => 'Tamaño de la Gráfica',
        'Cache' => 'Caché',
        'Exchange Axis' => 'Intercambiar Ejes',
        'Configurable params of static stat' => 'Parámetro configurable de estadística estática',
        'No element selected.' => 'No hay elemento seleccionado',
        'maximal period from' => 'periodo máximo desde',
        'to' => 'a',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Modificar los Campos Libres del Ticket',
        'Change Owner of Ticket' => 'Cambiar el Propietario del Ticket',
        'Close Ticket' => 'Cerrar Ticket',
        'Add Note to Ticket' => 'Agregarle una Nota al Ticket',
        'Set Pending' => 'Establecer como pendiente',
        'Change Priority of Ticket' => 'Cambiar la Prioridad del Ticket',
        'Change Responsible of Ticket' => 'Cambiar el Responsable del Ticket',
        'Cancel & close window' => 'Cancelar y cerrar la ventana',
        'Service invalid.' => 'Servicio inválido.',
        'New Owner' => 'Propietario nuevo',
        'Please set a new owner!' => 'Por favor, defina un propietario nuevo.',
        'Previous Owner' => 'Propietario Anterior',
        'Inform Agent' => 'Notificar a Agente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Notificar a Agentes involucrados',
        'Spell check' => 'Corrector ortográfico',
        'Note type' => 'Tipo de nota',
        'Next state' => 'Siguiente estado',
        'Pending date' => 'Fecha pendiente',
        'Date invalid!' => '¡Fecha inválida!',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Rebotar a',
        'You need a email address.' => 'Se requiere una dirección de correo electrónico.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Se requiere una dirección de correo electrónica válida, que no sea local.',
        'Next ticket state' => 'Nuevo estado del ticket',
        'Inform sender' => 'Informar al emisor',
        'Send mail!' => 'Enviar correo',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Acción múltiple con Tickets',
        'Send Email' => '',
        'Merge to' => 'Fusionar con',
        'Invalid ticket identifier!' => '¡Identificador de ticket inválido!',
        'Merge to oldest' => 'Combinar con el mas viejo',
        'Link together' => 'Enlazar juntos',
        'Link to parent' => 'Enlazar al padre',
        'Unlock tickets' => 'Desbloquear tickets',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Redacte una respuesta para el ticket',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Please include at least one recipient' => '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Agenda de direcciones',
        'Pending Date' => 'Fecha pendiente',
        'for pending* states' => 'en estado pendiente*',
        'Date Invalid!' => '¡Fecha Inválida!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Cambiar cliente del ticket',
        'Customer Data' => 'Información del cliente',
        'Customer user' => 'Cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Crear un Ticket nuevo de Correo Electrónico',
        'From queue' => 'De la fila',
        'To customer' => '',
        'Please include at least one customer for the ticket.' => '',
        'Get all' => 'Obtener todos',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',
        'Need a valid email address or don\'t use a local email address' =>
            'Se requiere una dirección de correo electrónica válida, que no sea local.',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Historia de',
        'History Content' => 'Contenido de la Historia',
        'Zoom view' => 'Vista detallada',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Fusionar Ticket',
        'You need to use a ticket number!' => '¡Necesita usar un número de ticket!',
        'A valid ticket number is required.' => 'Se requiere un número de ticket válido.',
        'Need a valid email address.' => 'Se require una dirección de correo electrónica válida.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Mover Ticket',
        'New Queue' => 'Fila nueva',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Seleccionar todos',
        'No ticket data found.' => 'No se encontraron datos de ticket.',
        'First Response Time' => 'Tiempo para Primera Respuesta',
        'Service Time' => 'Tiempo de Servicio',
        'Update Time' => 'Tiempo para Actualización',
        'Solution Time' => 'Tiempo para Solución',
        'Move ticket to a different queue' => 'Mover ticket a una fila diferente',
        'Change queue' => 'Modificar fila',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Cambiar opciones de búsqueda',
        'Tickets per page' => '',

        # Template: AgentTicketOverviewPreview
        '","26' => '',

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Escalado en',
        'Locked' => 'Bloqueado',
        '","30' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Crear un Ticket Telefónico Nuevo',
        'From customer' => 'Del cliente',
        'To queue' => 'Para la fila',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Llamada telefónica',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Vista de correo electrónico sin formato',
        'Plain' => 'Texto plano',
        'Download this email' => 'Descargar este correo electrónico',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informacion-Ticket',
        'Accounted time' => 'Tiempo contabilizado',
        'Linked-Object' => 'Objeto-vinculado',
        'by' => 'por',

        # Template: AgentTicketPriority

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Buscar-Modelo',
        'Create Template' => 'Crear Plantilla',
        'Create New' => 'Crear Nuevo(a)',
        'Profile link' => '',
        'Save changes in template' => 'Guardar los cambios en la plantilla',
        'Add another attribute' => 'Añadir otro atributo',
        'Output' => 'Modelo de Resultados',
        'Fulltext' => 'Texto Completo',
        'Remove' => 'Quitar',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Nombre de inicio de sesión del cliente',
        'Created in Queue' => 'Creado en Fila',
        'Lock state' => 'Estado de bloqueo',
        'Watcher' => 'Observador',
        'Article Create Time (before/after)' => 'Tiempo de Creación del Artículo (antes/después)',
        'Article Create Time (between)' => 'Tiempo de Creación del Artículo (entre)',
        'Ticket Create Time (before/after)' => 'Tiempo de Creación del Ticket (antes/después)',
        'Ticket Create Time (between)' => 'Tiempo de Creación del Ticket (entre)',
        'Ticket Change Time (before/after)' => 'Tiempo de Modificación del Ticket (antes/después)',
        'Ticket Change Time (between)' => 'Tiempo de Modificación del Ticket (entre)',
        'Ticket Close Time (before/after)' => 'Tiempo de Cierre del Ticket (antes/después)',
        'Ticket Close Time (between)' => 'Tiempo de Cierre del Ticket (entre)',
        'Archive Search' => 'Búsqueda de Archivo',
        'Run search' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro de artículos',
        'Article Type' => 'Tipo de artículo',
        'Sender Type' => '',
        'Save filter settings as default' => 'Grabar configuración de filtros como defecto',
        'Ticket Information' => 'Información del Ticket',
        'Linked Objects' => 'Objetos Enlazados',
        'Article(s)' => 'Artículo(s)',
        'Change Queue' => 'Cambiar Fila',
        'Article Filter' => 'Filtro de Artículos',
        'Add Filter' => 'Añadir Filtro',
        'Set' => 'Ajustar',
        'Reset Filter' => 'Restablecer Filtro',
        'Show one article' => 'Mostrar un artículo',
        'Show all articles' => 'Mostrar todos los artículos',
        'Unread articles' => 'Artículos no leídos',
        'No.' => 'Núm.',
        'Unread Article!' => '¡Artículo sin leer!',
        'Incoming message' => 'Mensaje entrante',
        'Outgoing message' => 'Mensaje saliente',
        'Internal message' => 'Mensaje interno',
        'Resize' => 'Cambiar el tamaño',

        # Template: AttachmentBlocker
        'To protect your privacy, active or/and remote content has blocked.' =>
            'Para proteger su privacidad, contenido activo y/o remoto ha sido bloqueado.',
        'Load blocked content.' => 'Cargar contenido bloqueado.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Determinar el origen',

        # Template: CustomerFooter
        'Powered by' => 'Impulsado por',
        'One or more errors occurred!' => '¡Ha ocurrido al menos un error!',
        'Close this dialog' => 'Cerrar este diálogo',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'No se pudo abrir la ventana pop-up. Por favor, deshabilite cualquier bloqueador de pop-ups para esta aplicación.',

        # Template: CustomerHeader

        # Template: CustomerLogin
        'Login' => 'Identificador',
        'User name' => 'Nombre de usuario',
        'Your user name' => 'Su nombre de usuario',
        'Your password' => 'Su contraseña',
        'Forgot password?' => '¿Olvidó su contraseña?',
        'Log In' => 'Iniciar sesión',
        'Not yet registered?' => '¿Aún no se ha registrado?',
        'Sign up now' => 'Inscríbase ahora',
        'Request new password' => 'Solicitar una nueva contraseña',
        'Your User Name' => 'Su Nombre de Usuario',
        'A new password will be sent to your email address.' => 'Una contraseña nueva se enviará a su dirección de correo electrónico.',
        'Create Account' => 'Crear Cuenta',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Cómo debemos contactarlo',
        'Your First Name' => 'Su Nombre',
        'Please supply a first name' => 'Por favor, proporcione un nombre',
        'Your Last Name' => 'Su Apellido',
        'Please supply a last name' => 'Por favor, proporcione un apellido',
        'Your email address (this will become your username)' => '',
        'Please supply a' => 'Por favor, proporcione un(o/a)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Modificar preferencias presonales',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Acuerdo de nivel de servicio',

        # Template: CustomerTicketOverview
        'Welcome!' => '',
        'Please click the button below to create your first ticket.' => '',
        'Create your first ticket' => '',

        # Template: CustomerTicketPrint
        'Ticket Print' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'Por ejemplo: 10*5155 ó 105658*',
        'Customer ID' => 'ID del Cliente',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Texto de búsqueda en los tickets (por ejemplo: "John*n" o "Will*")',
        'Recipient' => 'Destinatario',
        'Carbon Copy' => 'Copia al Carbón',
        'Time restrictions' => 'Restricciones de tiempo',
        'No time settings' => '',
        'Only tickets created' => 'Únicamente tickets creados',
        'Only tickets created between' => 'Únicamente tickets creados entre',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => '¿Guardar como Plantilla?',
        'Save as Template' => '',
        'Template Name' => 'Nombre de la Plantilla',
        'Pick a profile name' => '',
        'Output to' => 'Salida a',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Page' => 'Página',
        'Search Results for' => 'Buscar Resultados para',

        # Template: CustomerTicketZoom
        '","18' => '',
        'Expand article' => '',
        'Reply' => 'Responder',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => '¡Fecha inválida (se requiere una fecha futura)!',
        'Previous' => 'Previo(a)',
        'Sunday' => 'Domingo',
        'Monday' => 'Lunes',
        'Tuesday' => 'Martes',
        'Wednesday' => 'Miércoles',
        'Thursday' => 'Jueves',
        'Friday' => 'Viernes',
        'Saturday' => 'Sábado',
        'Su' => 'Dom',
        'Mo' => 'Lun',
        'Tu' => 'Mar',
        'We' => 'Miér',
        'Th' => 'Jue',
        'Fr' => 'Vier',
        'Sa' => 'Sáb',
        'Open date selection' => 'Abrir fecha seleccionada',

        # Template: Error
        'Oops! An Error occurred.' => 'Se produjo un error.',
        'Error Message' => 'Mensaje de error',
        'You can' => 'Usted puede',
        'Send a bugreport' => 'Enviar un reporte de error',
        'go back to the previous page' => 'regresar a la página anterior',
        'Error Details' => 'Detalles del error',

        # Template: Footer
        'Top of page' => 'Inicio de la página',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Si sale de esta página ahora, todas las ventanas pop-up también se cerrarán.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Ya hay una pop-up abierta de esta pantalla. ¿Desea cerrarla y cargar esta en su lugar?',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'You are logged in as' => 'Ud. inició sesión como',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript no disponible',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Para utilizar OTRS correctamente, es necesario que habilite JavaScript en su explorador web.',
        'Database Settings' => 'Configuraciones de la Base de Datos',
        'General Specifications and Mail Settings' => 'Especificaciones Generales y Configuraciones de Correo',
        'Registration' => '',
        'Welcome to %s' => 'Bienvenido a %s',
        'Web site' => 'Sitio web',
        'Database check successful.' => 'Verificación satisfactoria de la base de datos',
        'Mail check successful.' => 'Verificación satisfactoria de correo',
        'Error in the mail settings. Please correct and try again.' => 'Error en las configuraciones de lcorreo. Por favor, corríjalas y vuelva a intentarlo.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurar Correo Saliente',
        'Outbound mail type' => 'Tipo de correo saliente',
        'Select outbound mail type.' => 'Seleccione el tipo de correo saliente.',
        'Outbound mail port' => 'Puerto para el correo saliente',
        'Select outbound mail port.' => 'Selecione el puerto para el correo saliente.',
        'SMTP host' => 'Host SMTP',
        'SMTP host.' => 'Host SMTP.',
        'SMTP authentication' => 'Autenticación SMTP',
        'Does your SMTP host need authentication?' => '¿Su host SMTP requiere autenticación?',
        'SMTP auth user' => 'Autenticación de usuario SMTP',
        'Username for SMTP auth.' => 'Nombre de usuario para la autenticación SMTP.',
        'SMTP auth password' => 'Contraseña de autenticación SMTP',
        'Password for SMTP auth.' => 'Contraseña para la autenticación SMTP.',
        'Configure Inbound Mail' => 'Configurar Correo Entrante',
        'Inbound mail type' => 'Tipo de correo entrante',
        'Select inbound mail type.' => 'eleccione el tipo de correo entrante.',
        'Inbound mail host' => 'Host del correo entrante',
        'Inbound mail host.' => 'Host del correo entrante.',
        'Inbound mail user' => 'Usuario del correo entrante',
        'User for inbound mail.' => 'Usuario para el correo entrante.',
        'Inbound mail password' => 'Contraseña del correo entrante',
        'Password for inbound mail.' => 'Contraseña para el correo entrante.',
        'Result of mail configuration check' => 'Resultado de la verificación de la configuración de correo.',
        'Check mail configuration' => 'Verificar configuración de correo',
        'Skip this step' => 'Omitir este paso',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => 'Falso',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Si ha fijado una clave para su base de datos, debe especificarla aquí. Si no, déjelo en blanco. Por razones de seguridad, recomendamos establecer una clave para root. PAra más información, consulte la documentación de su base de datos.',
        'Currently only MySQL is supported in the web installer.' => 'Actualmente sólo MySQL está disponible en el instalador web.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Si desea instalar OTRS en otro tipo de base de datos, por favor lea el archivo README.database.',
        'Database-User' => 'Usuario-Base de datos',
        'New' => 'Nuevo',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'Un usuario nuevo, con permisos limitados, se creará en este sistema OTRS, para la base de datos.',
        'default \'hot\'' => 'por defecto \'hot\'',
        'DB--- host' => '',
        'Check database settings' => 'Verificar las configuraciones de la base de datos',
        'Result of database check' => 'Resultado de la verificación de la base de datos',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para poder utilizar OTRS debe escribir la siguiente línea en la consola de sistema (Terminal/Shell) como usuario root',
        'Restart your webserver' => 'Reinicie su servidor web',
        'After doing so your OTRS is up and running.' => 'Después de hacer esto, su OTRS estará activo y ejecutándose',
        'Start page' => 'Página de inicio',
        'Your OTRS Team' => 'Su equipo OTRS',

        # Template: InstallerLicense
        'Accept license' => 'Aceptar licencia',
        'Don\'t accept license' => 'No aceptar licencia',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organización',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'ID de sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identificador del sistema. Todos los números de tickets e ID\'s de sesiones HTTP contendrán este número.',
        'System FQDN' => 'FQDN del sistema',
        'Fully qualified domain name of your system.' => 'Nombre de dominio totalmente calificado de su sistema.',
        'AdminEmail' => 'Correo del Administrador.',
        'Email address of the system administrator.' => 'Dirección de correo electrónico del administrador del sistema.',
        'Log' => 'Log',
        'LogModule' => 'MóduloLog',
        'Log backend to use.' => 'Backend a usar para el log.',
        'LogFile' => 'ArchivoLog',
        'Log file location is only needed for File-LogModule!' => '¡La ubicación del archivo log sólo se requiere para el Archivo-MóduloLog!',
        'Webfrontend' => 'Interface Web',
        'Default language' => 'Idioma por defecto',
        'Default language.' => 'Idioma por defecto.',
        'CheckMXRecord' => 'Revisar record MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Las direcciones de correo electrónico que se proporcionan manualmente, se verifican con los records MX encontrados en el DNS. No utilice esta opcion si su DNS es lento o no resuelve direcciones públicas.',

        # Template: LinkObject
        'Object#' => 'Objecto#',
        'Add links' => 'Agregar enlaces',
        'Delete links' => 'Eliminar enlaces',

        # Template: Login
        'JavaScript Not Available' => 'JavaScript No Disponible',
        'Browser Warning' => 'Advertencia del Explorador',
        'The browser you are using is too old.' => 'El explorador que está usando es muy antiguo.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS correo en una amplia lista de exploradores, por favor utilice alguno de ellos.',
        'Please see the documentation or ask your admin for further information.' =>
            'Por favor, refiérase a la documentación o pregunte a su administrador para obtener más información.',
        'Lost your password?' => '¿Perdió su contraseña?',
        'Request New Password' => 'Solicite una Contraseña Nueva',
        'Back to login' => 'Regresar al inicio de sesión',

        # Template: Motd
        'Message of the Day' => 'Mensaje del día',

        # Template: NoPermission
        'Insufficient Rights' => 'Permisos insuficientes',
        'Back to the previous page' => 'Volver a la página anterior',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Mostrar la primera página',
        'Show previous pages' => 'Mostrar la página anterior',
        'Show page %s' => 'Mostrar la página %s',
        'Show next pages' => 'Mostrar la página siguiente',
        'Show last page' => 'Mostrar la última página',

        # Template: PictureUpload
        'Need FormID!' => 'Se necesita el ID del Formulario',
        'No file found!' => '¡No se encontró el archivo!',
        'The file is not an image that can be shown inline!' => '¡El archivo no es una imagen que se pueda mostrar en línea!',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'impreso por',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Página de Prueba de OTRS',
        'Welcome %s' => 'Bienvenido %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Regresar a la página anterior',

        # SysConfig
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite cerrar los tickets padre únicamente si todos sus hijos ya están cerrados ("Estado" muestra cuáles estados no están disponibles para el ticket padre, hasta que todos sus hijos estén cerrados).',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Activa un mecanismo de parpadeo para la fila que contiene el ticket más antiguo.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Activa la función de contraseña perdida para agentes, en la interfaz de los mismos.',
        'Activates lost password feature for customers.' => 'Activa la función de contraseña perdida para clientes.',
        'Activates support for customer groups.' => 'Activa soporte para grupos de clientes.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Activa el filtro de artículos en la vista detallada para especificar qué artículos deben mostrarse.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Activa los temas disponibles en el sistema. Valor 1 significa activo, 0 es inactivo.',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Activa el sistema de archivo de tickets para tener un sistema más rápido, al mover algunos tickets fuera del ámbito diario. Para buscar estos tickets, la bandera de archivo tiene que estar habilitada en la ventana de búsqueda.',
        'Activates time accounting.' => 'Activa la contatibilidad de tiempo.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Añade un sufijo con el año y mes actuales al archivo log de OTRS. Se generará un archivo log distinto para cada mes.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años). Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Agent Notifications' => 'Notificaciones para Agentes',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificación de artículos de la interfaz del agente para verificar PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificación de artículos de la interfaz del agente para verificar S/MIME.',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Módulo de la interfaz del agente para acceder al texto de búsqueda, a través de la barra de navegación.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Módulo de la interfaz del agente para acceder a los perfiles de búsqueda, a través de la barra de navegación.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo de la interfaz del agente para verificar los correos electrónicos entrantes, en la vista detallada del ticket, si la llave S/MIME está disponible y es verdadera.',
        'Agent interface notification module to check the used charset.' =>
            'Módulo de notificación de la interfaz del agente para verificar el juego de caracteres usado.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Módulo de notificación de la interfaz del agente para visualizar el número de tickets por los cuales un agente es responsable.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Módulo de notificación de la interfaz del agente para visualizar el número de tickets monitoreados.',
        'Agents <-> Groups' => 'Agentes <-> Grupos',
        'Agents <-> Roles' => 'Agentes <-> Roles',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Permite añadir notas en la ventana de cerrar ticket, en la interfaz del agente.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Permite añadir notas en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Permite añadir notas en la ventana de nota de ticket, en la interfaz del agente.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permite añadir notas en la ventana de propietario del ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permite añadir notas en la ventana de ticket pendiente, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permite añadir notas en la ventana de prioridad del ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Permite añadir notas en la ventana de responsable del ticket, en la interfaz del agente.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permite a los agentes intercambiar los ejes de la estadística al generar una.',
        'Allows agents to generate individual-related stats.' => 'Permite a los agentes generar estadísticas relacionadas individualmente.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permite elegir entre mostrar los archivos adjuntos de un ticket en el explorador (en línea), o simplemente permitir descargarlos.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permite elegir el siguiente estado del ticket al redactar un artículo, en la interfaz del cliente.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permite a los clientes cambiar la prioridad del ticket en la interfaz del cliente.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permite a los clientes definir el SLA del ticket en la interfaz del cliente.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permite a los clientes definir la prioridad del ticket en la interfaz del cliente.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Permite a los clientes definir la fila del ticket en la interfaz del cliente. Si se selecciona \'No\', es necesario que se configure la fila por defecto.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permite a los clientes definir el servicio del ticket en la interfaz del cliente.',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permite definir nuevos tipos para los tickets (si la funcionalidad de tipo de ticket está habilitada).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir servicios y SLAs para los tickets (por ejemplo: correo electrónico, escritorio, red, etc.), así mismo como atributos para los SLAs (si la funcionalidad servicio/SLA está habilitada).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite el uso de condiciones de búsqueda extendida al buscar tickets en la interfaz del cliente. Con esta funcionalidad, es posible buscar condiciones como, por ejemplo, "(llave1&&llave2)" o "(llave1||llave2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite tener un formato de vista mediana para los tickets (InformaciónCliente => 1 - muestra además la información del cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite tener un formato de vista pequeña para los tickets (InformaciónCliente => 1 - muestra además la información del cliente).',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permite al administrador iniciar sesión como otros usuarios, a través del panel de administración de los mismos.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permite definir el estado de un ticket nuevo, en la ventana de mover ticket de la interfaz del agente.',
        'Attachments <-> Responses' => 'Anexos <-> Respuestas',
        'Auto Responses <-> Queues' => 'Respuestas Automáticas <-> Filas',
        'Automated line break in text messages after x number of chars.' =>
            'Salto de línea automático en los mensajes de texto después de x número de caracteres.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Bloquear automáticamente y establecer como propietario al agente actual, luego de elegir realizar una Acción múltiple con Tickets.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Establecer automáticamente como responsable de un ticket al propietario del mismo (si la funcionalidad de responsable del ticket está habilitada).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Establecer automáticamente el responsable de un ticket (si no está definido aún), luego de realizar la primera actualización de propietario.',
        'Balanced white skin by Felix Niklas.' => 'Piel blanca balanceda diseñada por Felix Niklas.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Bloquea todos los correos electrónicos entrantes que no tienen un número de ticket válido en el asunto con dirección De: @ejemplo.com.',
        'Builds an article index right after the article\'s creation.' =>
            'Crea un índice de artículos justo después de la creación del artículo.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Ejemplo de configuración CMD. Ignora correos electrónicos donde el CMD externo regresa alguna salida en STDOUT (los correos electrónicos serán dirigidos a STDIN de some.bin).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'Cambiar contraseña',
        'Change queue!' => 'Cambiar fila',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Cambia el propietario de los tickets a todos (útil para ASP). Normalmente sólo se mostrarán los agentes con permiso rw en la fila del ticket.',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Verifica el ID del sistema en la detección de números de tickets para los seguimientos (use "No" si el ID del sistema se cambió después de empezar a utilizar OTRS).',
        'Closed tickets of customer' => '',
        'Comment for new history entries in the customer interface.' => 'Comentario para entradas nuevas en la historia, en la interfaz del cliente.',
        'Companies' => 'Compañías',
        'Company Tickets' => 'Tickets de la Compañía',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Configura el índice de texto completo. Ejecuta "bin/otrs.RebuildFulltextIndex.pl" para generar un índice nuevo.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Define es posible que los clientes ordenen sus tickets.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Converts HTML mails into text messages.' => 'Convierte correos HTML en mensajes de texto.',
        'Create and manage Service Level Agreements (SLAs).' => 'Crear y gestionar Acuerdos de Nivel de Servicio (SLAs).',
        'Create and manage agents.' => 'Crear y gestionar agentes.',
        'Create and manage attachments.' => 'Crear y gestionar archivos adjuntos.',
        'Create and manage companies.' => 'Crear y gestionar compañías.',
        'Create and manage customers.' => 'Crear y gestionar clientes.',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => 'Crear y gestionar notificaciones basadas en eventos.',
        'Create and manage groups.' => 'Crear y gestionar grupos.',
        'Create and manage queues.' => 'Crear y gestionar filas.',
        'Create and manage response templates.' => 'Crear y gestionar plantillas de respuesta.',
        'Create and manage responses that are automatically sent.' => 'Crear y gestionar respuestas enviadas de forma automática.',
        'Create and manage roles.' => 'Crear y gestionar roles.',
        'Create and manage salutations.' => 'Crear y gestionar saludos.',
        'Create and manage services.' => 'Crear y gestionar servicios.',
        'Create and manage signatures.' => 'Crear y gestionar firmas.',
        'Create and manage ticket priorities.' => 'Crear y gestionar las prioridades del ticket.',
        'Create and manage ticket states.' => 'Crear y gestionar los estados del ticket.',
        'Create and manage ticket types.' => 'Crear y gestionar los tipos de ticket.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'Crear un ticket de correo electrónico nuevo y mandarlo (saliente)',
        'Create new phone ticket (inbound)' => 'Crear un ticket telefónico nuevo (entrante)',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customers <-> Groups' => 'Clientes <-> Grupos',
        'Customers <-> Services' => 'Clientes <-> Servicios',
        'DEPRECATED! This setting is not used any more and will be removed in a future version of OTRS.' =>
            '',
        'Data used to export the search result in CSV format.' => 'Datos usados para exportar el resultado de la búsqueda a formato CSV.',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Depura el conjunto de traducción. Si se selecciona "Sí", todas las cadenas de texto sin traducción se escriben en STDERR. Esto puede ser útil al crear archivos de traducción, de otra manera, esta opción debería permanecer en "No".',
        'Default ACL values for ticket actions.' => 'Valores ACL por defecto para las acciones de ticket.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'Módulo de protección de bucle por defecto.',
        'Default queue ID used by the system in the agent interface.' => 'ID de fila usado por defecto por el sistema, en la interfaz del agente.',
        'Default skin for OTRS 3.0 interface.' => 'Piel por defecto para la interfaz OTRS 3.0.',
        'Default skin for interface.' => 'Piel por defecto para la interfaz.',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de ticket usado por defecto por el sistema, en la interfaz del agente.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de ticket usado por defecto por el sistema, en la interfaz del cliente.',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para la salida html para añadir vínculos a ciertas cadenas. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTRS. La otra posibilidad es insertar el vínculo a la imagen.',
        'Define the start day of the week for the date picker.' => 'Define el día inicial de la para el selector de fecha.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Define un artículo de cliente que genera un ícono de VinculadoEn, al final de un bloque de información de cliente.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Define un artículo de cliente que genera un ícono de XING, al final de un bloque de información de cliente.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Define un artículo de cliente que genera un ícono de google, al final de un bloque de información de cliente.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Define un artículo de cliente que genera un ícono de mapas google, al final de un bloque de información de cliente.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Define una lista de palabras por defecto, que son ignoradas por el corrector de ortografía.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para añadir vínculos a los números CVE. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTRS. La otra posibilidad es insertar el vínculo a la imagen.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para añadir vínculos a los números MSBulletin. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTRS. La otra posibilidad es insertar el vínculo a la imagen.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para añadir vínculos a una cadena definida. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTRS. La otra posibilidad es insertar el vínculo a la imagen.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para añadir vínculos a los números bugtraq. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTRS. La otra posibilidad es insertar el vínculo a la imagen.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Define un filtro para procesar el texto de los artículos, con la finalidad de resaltar las palabras llave predefinidas.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Define una expresión regular que excluye algunas direcciones de la verificación de sintaxis (si se seleccionó "Sí" en "CheckEmailAddresses"). Por favor, introduzca una expresión regular en este campo para direcciones de correo electrónico que, sintácticamente son inválidas, pero son necesarias para el sistema (por ejemplo: "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Define una expresión regular que filtra todas las direcciones de correo electrónico que no deberían usarse en la aplicación.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Define un módulo para cargar opciones de usuario específicas o para mostrar noticias.',
        'Defines all the X-headers that should be scanned.' => 'Define todos los encabezados-X que deberán escanearse.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Define todos los idiomas en los que la aplicación está disponible. El par Llave/Valor asocia el nombre front-end desplegado con el archivo PM del idioma apropiado. El valor "Llave" debe ser el nombre base del archivo PM (por ejemplo: si el archivo es de.pm, "Llave" es de). El valor de "Contenido" debe ser el nombre mostrado en el front-end. Especifique cualquier idioma personalizado aquí (vea el manual del desarrollador para mayor información al respecto: http://doc.otrs.org/). Por favor, recuerde usar los equivalentes HTML para caracteres que no son ASCII (por ejemplo: en Alemán, para la metafonía oe = o, es necesario usar el símbolo &ouml;).',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Define todos los parámetros para el objeto TiempoDeActualización, en las preferencias del cliente de la interfaz del mismo.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Define todos los parámetros para el objeto TicketsMostrados, en las preferencias del cliente de la interfaz del mismo.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Define todos los parámetros para este elemento, en las preferencias del cliente.',
        'Defines all the possible stats output formats.' => 'Define todos los formatos de salida posibles de las estadísticas.',
        'Defines an alternate URL, where the login link refers to.' => 'Define una URL sustituta, a la que el vínculo de inicio de sesión se refiera.',
        'Defines an alternate URL, where the logout link refers to.' => 'Define una URL sustituta, a la que el vínculo de término de sesión se refiera.',
        'Defines an alternate login URL for the customer panel..' => 'Define una URL sustituta para el inicio de sesión, en la interfaz del cliente.',
        'Defines an alternate logout URL for the customer panel.' => 'Define una URL sustituta para el término de sesión, en la interfaz del cliente.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            'Define un vínculo externo a la base de datos del cliente (por ejemplo: \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' o \'\').',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Define cómo debe lucir el campo De en los correos electrónicos (enviados como respuestas y tickets).',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cerrar dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para rebotar dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para redactar, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para reenviar dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana de campos libres de dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para mezclar dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para agregar una nota a dicho ticket de la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el propietario de dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para definir como pendiente dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para añadir una llamada saliente a dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar la prioridad de dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el agente responsable de dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el cliente de dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Define si la ortografía de los mensajes redactados debe verificarse en la interfaz del agente.',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Define si la contabilidad de tiempo es obligatoria en la interfaz del agente.',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Define la expresión regular IP para acceder al repositorio local. Es necesario que esto se habilite para tener acceso al repositorio local y el paquete::ListaRepositorio se requiere en el host remoto.',
        'Defines the URL CSS path.' => 'Define la URL de la ruta CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Define la URL de la ruta base para los íconos, CSS y Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Define la URL de la ruta de los íconos para la navegación.',
        'Defines the URL java script path.' => 'Define la URL de la ruta Java Script.',
        'Defines the URL rich text editor path.' => 'Define la URL de la ruta del editor de texto enriquecido.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Define la dirección de un servidor DNS dedicado, si se necesita, para las búsquedas de verificación de registro MX.',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Define el texto para el cuerpo de las notificaciones electrónicas que se envían a los agentes, acerca de una contraseña nueva (dicha contraseña se enviará luego de usar este vínculo).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Define el texto para el cuerpo de las notificaciones electrónicas que se envían a los agentes, con un token referente a la petición de una contraseña nueva (dicha contraseña se enviará luego de usar este vínculo).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Define el texto para el cuerpo de las notificaciones electrónicas que se envían a los clientes, acerca de una cuenta nueva.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Define el texto para el cuerpo de las notificaciones electrónicas que se envían a los clientes, acerca de una contraseña nueva (dicha contraseña se enviará luego de usar este vínculo).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Define el texto para el cuerpo de las notificaciones electrónicas que se envían a los clientes, con un token referente a la petición de una contraseña nueva (dicha contraseña se enviará luego de usar este vínculo).',
        'Defines the body text for rejected emails.' => 'Define el texto para el cuerpo de los correos electrónicos electrónicos rechazados.',
        'Defines the boldness of the line drawed by the graph.' => 'Define el grosor de la línea dibujada por el gráfico.',
        'Defines the colors for the graphs.' => 'Define los colores de los gráficos.',
        'Defines the column to store the keys for the preferences table.' =>
            'Define la columna para guardar las llaves en la tabla de preferencias.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Define los parámetros de configuración de este elemento, para que se muestren en la vista de preferencias.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Define los parámetros de configuración de este elemento, para que se muestren en la vista de preferencias. Asegúrese de mantener los diccionarios instalados en el sistema, en la sección de datos.',
        'Defines the connections for http/ftp, via a proxy.' => 'Define la conexión para http/ftp, a través de un proxy.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Define el formato de entrada de las fechas, usado en los formularios (opción o campos de entrada).',
        'Defines the default CSS used in rich text editors.' => 'Define valor por defecto para el CSS de los editores de texto enriquecidos.',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de una nota, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Define el tema por defecto del front-end (HTML) a ser usado por agentes y clientes. Los temas por defecto son Estárdard y Ligero. Si ud. así lo desea, puede añadir su propio tema. Por favor, refiérase al manual del administrador para mayor información: http://doc.otrs.org/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Define el lenguaje por defecto del front-end. Todos los valores posibles se determinan por los archivos de idiomas disponible en el sistema (vea la siguiente configuración).',
        'Defines the default history type in the customer interface.' => 'Define el tipo de historia por defecto en la interfaz del cliente.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Define el número máximo por defecto de atributos para el eje X, en la escala de tiempo.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Define el número máximo por defecto de resultados de búsqueda, mostrados en la página de vista de resumen.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de que el cliente le dió seguimiento desde su propia interfaz.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cerrar dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana de acción múltiple sobre tickets, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana de nota para dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cambiar el propietario de dicho ticket, en su vista detallada, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para definir dicho ticket como pendiente, en su vista detallada, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cambiar la prioridad de dicho ticket, en su vista detallada, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cambiar el responsable de dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haber sido rebotado, en la ventana para rebotar dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haber sido reenviado, en la ventana para reenviar dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haberlo redactado / respondido, en la ventana de redacción de dicho ticket, en la interfaz del agente.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de una nota, para tickets telefónicos en la ventana de llamada telefónica saliente de dicho ticket, en la interfaz del agente.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Define la prioridad por defecto para los tickets de seguimiento de los clientes, en la ventana de vista detallada de dicho ticket, en la interfaz del cliente.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Define la prioridad por defecto para los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default priority of new tickets.' => 'Define la prioridad por defecto para los tickets nuevos.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Define la fila por defecto para los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Define el valor seleccionado por defecto en la lista desplegable para objetos dinámicos (Formulario: Especificación Común).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Define el valor seleccionado por defecto en la lista desplegable para permisos (Formulario: Especificación Común).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Define el valor seleccionado por defecto en la lista desplegable de formatos para las estadisticas (Formulario: Especificación Común).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el tipo de remitente por defecto para los tickets telefónicos, en la ventana de ticket telefónico saliente de la interfaz del agente.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Define el tipo de remitente por defecto para tickets, en la ventana de vista detallada del ticket de la interfaz del agente.',
        'Defines the default sender type of the article for this operation.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Define el atributo mostrado por defecto para la búsqueda de tickets, en la ventana de búsqueda.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Define el orden por defecto para todas las filas mostradas en la vista de filas, luego de haberse ordenado por prioridad.',
        'Defines the default spell checker dictionary.' => 'Define el diccionario por defecto para la verificación ortográfica.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Define el estado por defecto de los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default state of new tickets.' => 'Define el estado por defecto para los tickets nuevos.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el asunto por defecto de los tickets telefónicos, en la ventana de ticket telefónico saliente de la interfaz del agente.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Define el asunto por defecto de las notas, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la búsqueda, en la interfaz del cliente.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de escalado, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de tickets bloqueados, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de responsables, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de estados, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de monitoreo, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets del resultado de una búsqueda, en la interfaz del agente.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Define la notificación por defecto para tickets rebotados, que se enviará al cliente/remitente, en la ventana de rebotar un ticket, en la interfaz del agente.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haber añadido una nota telefónica, en la ventana de ticket telefónico saliente de la interfaz del agente.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets (luego de haberse ordenado por prioridad), en la vista de escalado de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets (luego de haberse ordenado por prioridad), en la vista de estados de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de responsables de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de tickets bloqueados de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, resultado de una búsqueda de tickets en la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de tickets monitoreados de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, resultado de una búsqueda de tickets en la interfaz del cliente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para cerrar un ticket, en la interfaz del agente.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para agregar una nota al ticket, en la interfaz del agente.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para modificar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para cambiar el agente responsable de un ticket, en la vista detallada de dicho ticket, en la interfaz del agente.',
        'Defines the default type for article in the customer interface.' =>
            'Define el tipo por defecto para los artículos, en la interfaz del cliente.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Define el tipo por defecto de un mensaje reenviado, en la ventana de reenvío de tickets de la interfaz del agente.',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana de ticket telefónico saliente de la interfaz del agente.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Define el tipo de nota por defecto, en la ventana de vista detalla del ticket, en la interfaz del agente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Define el módulo frontend usado por defecto si no se proporciona el parámetro Acción en la URL de la interfaz del agente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Define el módulo frontend usado por defecto si no se proporciona el parámetro Acción en la URL de la interfaz del cliente.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Define el valor por defecto para el parámetro Acción de la interfaz pública. Dicho parámetro se usa en los scripts del sistema.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Define los valores visibles por defecto para el tipo de remitente de un ticket (por defecto: cliente).',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Define el filtro que procesa el texto en los artículos, para resaltar las URLs,',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            'Define el formato de las respuestas, en la ventana de redacción de un artículo para un ticket, en la interfaz del agente ($QData{"OrigFrom"} es De 1:1, $QData{"OrigFromName"} es el nombre real de De)',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define el nombre del dominio totalmente calificado del sistema. Esta configuración es usada como la variable OTRS_CONFIG_FQDN, misma que se encuentra en todos los tipos de mensajes usados en la aplicación, para construir vínculos a los tickets del sistema.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Define los grupos en los que estarán todos los clientes (si CustomerGroupSupport está habilitado y se desea evitar el gestionar cada usuario para estos grupos).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => 'Define la longitur de la leyenda.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana de cerrar un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana de ticket de correo electrónico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana de ticket telefónico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Define el comentario histórico para la acción de la ventana de campos libres de ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para agregar una nota al ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para cambiar el propietario de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para definir un ticket como pendiente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana de ticket telefónico saliente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para cambiar la prioridad de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para cambiar el responsable de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Define el comentario histórico para la acción de la ventana de vista detallada de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana de cerrar un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana de ticket de correo electrónico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana de ticket telefónico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Define el tipo histórico para la acción de la ventana de campos libres de ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para agregar una nota al ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para cambiar el propietario de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para definir un ticket como pendiente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana de ticket telefónico saliente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para cambiar la prioridad de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para cambiar el responsable de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Define el tipo histórico para la acción de la ventana de vista detallada de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => 'Define las horas y los días laborales de la semana.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Define la llave que se verificará con el módulo Kernel::Modules::AgentInfo. Si esta llave de preferencias de usuario es verdadera, el mensaje es aceptado por el sistema.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Define la llave que se verificará con CustomerAccept. Si esta llave de preferencias de usuario es verdadera, el mensaje es aceptado por el sistema.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define el tipo de vínculo \'Normal\'. Si los nombres fuente y objetivo contienen el mismo valor, el vínculo resultante es no-direccional; de lo contrario, se obtiene un vínculo direccional.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define el tipo de vínculo \'PadreHijo\'. Si los nombres fuente y objetivo contienen el mismo valor, el vínculo resultante es no-direccional; de lo contrario, se obtiene un vínculo direccional.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Define el tipo de vínculo \'Grupos\'. Los tipos de vínculo del mismo grupo se cancelan mutuamente. Por ejemplo: Si el ticket A está enlazado con el ticket B por un vínculo \'Normal\', no es posible que estos mismos tickets además estén enlazados por un vínculo de relación \'PadreHijo\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Define la ubicación para obtener una lista de repositorios en línea para paquetes adicionales. Se usará el primer resultado disponible.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Define el módulo log del sistema. "Archivo" escribe todos los mensajes en un archivo log, "SysLog" usa el demonio syslog del sistema, por ejemplo: syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            'Define el tamaño máximo (en bytes) para cargar archivos, a través del explorador.',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Define el tiempo máximo (en segundos) válido para un id de sesión.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Define el número máximo de páginas por archivo PDF.',
        'Defines the maximum size (in MB) of the log file.' => 'Define el tamaño máximo (en MG) del archivo log.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Define el módulo que muestra, en la interfaz del agente, una lista de todos los clientes con sesión activa.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Define el módulo que muestra, en la interfaz del agente, una lista de todos los agentes con sesión activa.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Define el módulo que muestra, en la interfaz del cliente, una lista de todos los agentes con sesión activa.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Define el módulo que muestra, en la interfaz del cliente, una lista de todos los clientes con sesión activa.',
        'Defines the module to authenticate customers.' => 'Define el módulo para autenticar clientes.',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Define el módulo para desplegar una notificación, en la interfaz del agente, si el sistema está siendo usado por el usuario adminstrador (normalmente no es recomendable trabajar como administrador).',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Define el módulo para generar encabezados html de actualización de sitios html, en la interfaz del cliente.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Define el módulo para generar encabezados html de actualización de sitios html.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Define el módulo para enviar correos electrónicos. "Sendmail" usa directamente el sendmail binario de su sistema operativo. Cualquiera de los mecanismos "SMTP" utiliza un servidor de correos (externo) específico. "DoNotSendEmail" no envía correos electrónicos, lo cual es útil en sistemas de prueba.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Define el módulo usado para almacenar los datos de sesión. Con "DB" el servidor frontend puede separarse del servidor de la base de datos. "FS" es más rápido.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Define el nombre de la aplicación, mostrado en la interfaz web, lengüetas (tabs) y en la barra de título del explorador web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Define el nombre de la columna para guardar los datos en la tabla de preferencias.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Define el nombre de la columna para guardar el identificador del usuario en la tabla de preferencias.',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => 'Define el nombre de la llave para las sesiones de los clientes.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Define el nombre de las llaves de sesión. Por ejemplo: Sesión, SesiónID u OTRS.',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Define el nombre de la tabla en la que se almacenan las preferencias de los clientes.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de redactar / responder un ticket, en la ventana de redacción de la interfaz del agente.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de reenviar un ticket, en la ventana de reenvío de tickets de la interfaz del agente.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Define la lista de posibles estados siguientes para los tickets de los clientes, en la interfaz del cliente.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para añadir una nota al ticket, en la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para establecer un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de haber sido rebotado, en la ventana para rebotar dicho ticket, en la interfaz del agente.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de moverlo a otra fila, en la ventana para mover un ticket, en la interfaz del agente.',
        'Defines the parameters for the customer preferences table.' => 'Define los parámetros para la tabla de preferencias del cliente.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Define los parámetros para el backend del panel principal. "Group" se usa para restringir el acceso al plugin (por ejemplo, Grupo: admin;grupo1;grupo2;). "Default" indica si el plugin está habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTL" indica el periodo de expiración (en minutos) del caché para el plugin.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Define los parámetros para el backend del panel principal. "Group" se usa para restringir el acceso al plugin (por ejemplo, Grupo: admin;grupo1;grupo2;). "Default" indica si el plugin está habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTLLocal" indica el periodo de expiración (en minutos) del caché para el plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Define los parámetros para el backend del panel principal. "Limit" define el número de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Grupo: admin;grupo1;grupo2;). "Default" indica si el plugin está habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTL" indica el periodo de expiración (en minutos) del caché para el plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Define los parámetros para el backend del panel principal. "Limit" define el número de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Grupo: admin;grupo1;grupo2;). "Default" indica si el plugin está habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTLLocal" indica el periodo de expiración (en minutos) del caché para el plugin.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Define la contraseña para acceder al manejo SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra negrita cursiva monoespaciado, en los documentos PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra negrita cursiva proporcional, en los documentos PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra negrita monoespaciado, en los documentos PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra negrita proporcional, en los documentos PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra cursiva monoespaciado, en los documentos PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra cursiva proporcional, en los documentos PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra con monoespaciado, en los documentos PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra proporcional, en los documentos PDF.',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Define la ruta del archivo de información mostrado, mismo que se localiza bajo Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Define la ruta al PGP binario.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Define la ruta al ssl abierto binario.',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'Define la posición de la leyenda. Debe ser una llave de 2 letras, con la forma \'B[LCR]|R[TCB]\'. La primera letra indica la posición (Bottom = Abajo o Right = Derecha), y la segunda letra determina la alineación (Left = Izquierda, Right = Derecha, Center = Centro, Top = Arriba, o Bottom = Abajo).',
        'Defines the postmaster default queue.' => 'Define la fila por defecto del administrador de correos.',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            'Define el destinatario objetivo de los tickets telefónicos y el remitente de los tickets de correo electrónico ("Queue" muestra todas las filas, "SystemAddress" despliega todas las direcciones del sistema), en la interfaz del agente.',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'Define el destinatario objetivo de los tickets telefónicos y el remitente de los tickets de correo electrónico ("Queue" muestra todas las filas, "SystemAddress" despliega todas las direcciones del sistema), en la interfaz del cliente.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => 'Define el límite de búsqueda para las estadísticas.',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Define el separador entre el nombre real de los agentes y la dirección de correo electrónico de la fila proporcionada.',
        'Defines the spacing of the legends.' => 'Define el espaciado de las leyendas.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Define los permisos estándar, disponibles para los clientes en la aplicación. Si se requieren más permisos, pueden agregarse aquí, sin embargo, es necesario codificarlos para que funcionen. Por favor, cuando agregue algún permiso, asegúrese de que "rw" permanezca como la última entrada.',
        'Defines the standard size of PDF pages.' => 'Define el tamaño estándar de las páginas PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Define el estado de un ticket si se le da seguimiento y ya estaba cerrado.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Define el estado de un ticket si se le da seguimiento.',
        'Defines the state type of the reminder for pending tickets.' => 'Define el tipo de estado para el recordatorio para los tickets pendientes.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los agentes, sobre una contraseña nueva.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los agentes, con token sobre una contraseña nueva solicitada.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los clientes, sobre una cuenta nueva.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los clientes, sobre una contraseña nueva.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los clientes, con token sobre una contraseña nueva solicitada.',
        'Defines the subject for rejected emails.' => 'Define el asunto para los correos electrónicos rechazados.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Define la dirección de correo electrónico del administrador del sistema, misma que se desplegará en las ventanas de error de la aplicación.',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Define el identificador del sistema, que contendrán cada número de ticket y cadena de sesión http, para asegurarse de que sólo los tickets que pertenecen al sistema se procesarán como seguimientos (útil cuando existe comunicación entre 2 instancias de OTRS).',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Define el atributo objetivo en el vínculo para una base de datos de cliente externa. Por ejemplo: \'target="cdb"\'.',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define el tipo de protocolo que usa el servidor web para servir a la aplicación. Si se usará el protocolo https, en lugar de http plano, debe especificarse aquí. Ya que esto no afecta la configuración/comportamiento del explorador seb, no modificará el meétodo de acceso a la aplicación y, si es incorrecto, no evitará el inicio de sesión a la aplicación. Esta configuración se usa como una variable (OTRS_CONFIG_HttpType) y está presente en todas las formas de mensajes que maneja la aplicación, con la finalidad de crear vínculos a los tickets dentro del sistema.',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            'Define el caracter usado para citar correos electrónicos en la ventana de redacción de un artículo para el ticket, en la interfaz del agente.',
        'Defines the user identifier for the customer panel.' => 'Define el identificador de usuario para la interfaz del cliente.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Define el nombre de usuario para acceder al manejo SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Define los tipos de estado válidos para un ticket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Define los estados válidos para tickets desbloqueados. El script "bin/otrs.UnlockTickets.pl" puede usarse para desbloquear tickets.',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Define los bloqueos visibles de un ticket. Por defecto: unlock, tmp_lock.',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define la anchura del editor de texto enriquecido. Proporcione un número (pixeles) o un porcentaje (relativo).',
        'Defines the width of the legend.' => 'Define la anchura de la leyenda.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Define los estados deberán ajustarse automáticamente (Contenido), después de que se cumpla el tiempo pendiente del estado (Llave).',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Elimina la sesión si el identificador de la misma está siendo usado con una dirección IP remota inválida.',
        'Deletes requested sessions if they have timed out.' => 'Elimina las sesiones solicitadas, si ya expiraron.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Determina si la lista de filas posibles a las que los tickets pueden ser movidos, deberá mostrarse en una lista desplegable o en una nueva ventana, en la interfaz del agente. Si se elije "Ventana nueva", es posible añadir una nota al mover el ticket.',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            'Determina si el contenedor de los resultados de la búsqueda de autocompletado, debe ajustar dinámicamente su anchura.',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de haber creado un ticket de correo electrónico nuevo en la interfaz del agente.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de haber creado un ticket telefónico nuevo en la interfaz del agente.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determina la pantalla siguiente, luego de haber creado un ticket en la interfaz del cliente.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Determina la pantalla siguiente, luego de darle seguimiento a un ticket, en la vista detallada de dicho ticket de la interfaz del cliente.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return to search results, queueview, dashboard or the like, LastScreenView will return to TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determina los estados posibles para tickets pendientes que cambiaron de estado al alcanzar el tiempo límite.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Determina las cadena que se mostrarán como destinatario (Para:) de los tickets telefónicos, y como remitente (De:) de los tickets de correo electrónico, en la interfaz del agente. Para Queue como NewQueueSelectionType, "<Queue>" muestra los nombres de las filas; y para SystemAddress, "<Realname> <<Email>>" muestra el nombre y el correo electrónico del destinatario.',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Determina las cadena que se mostrarán como remitente (De:) de los tickets, en la interfaz del cliente. Para Queue como NewQueueSelectionType, "<Queue>" muestra los nombres de las filas; y para SystemAddress, "<Realname> <<Email>>" muestra el nombre y el correo electrónico del remitente.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determina la forma en la que los objetos vinculados se despliegan en cada vista detallada.',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Determina las opciones válidas para el remitente (ticket telefónico) y destinatario (ticket de correo electrónico), en la interfaz del agente.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Determina las filas que serán válidas coom remitentes de los ticket, en la interfaz del cliente.',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Deshabilita el envío de notificaciones de recordatorio al agente responsable de un ticket (Ticket::Responsible tiene que estar activo).',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box (to avoid the use of destructive queries, such as DROP DATABASE, and also to steal user passwords).' =>
            'Deshabilita el instalador web (http://yourhost.example.com/otrs/installer.pl), para prevenir que el sistema sufra un secuestro (hijack). Si se selecciona "No", el sistema puede ser reinstalado y la configuración básica actual se usará para pre-poblar las preguntas, en el script del instalador. Así mismo, al estar deshabilitado, es imposible hacer uso de: el agente genérico, el manejador de paquetes y la caja de consultas SQL (para evitar el uso de consultas dañinas, como DROP DATABASE, o para robar contraseñas).',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Despliega la contabilidad de tiempo para un artículo, en la vista detallada del ticket.',
        'Dropdown' => '',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
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
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Email Addresses' => 'Direcciones de Correo',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Habilita la salida PDF. El módulo CPAN PDF::API2 es necesario, si no está instalado, la salida PDF se deshabilitará.',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Habilita el soporte PGP. Cuando este soporte se activa para firmar y garantizar correos, es ALTAMENTE recomendable que el el usuario OTRS ejecute el servidor web. De lo contrario, se generarán problemas de privilegios al acceder a la carpeta .gnupg.',
        'Enables S/MIME support.' => 'Habilita el soporte S/MIME.',
        'Enables customers to create their own accounts.' => 'Permite a los clientes crear sus propias cuentas.',
        'Enables file upload in the package manager frontend.' => 'Permite cargar archivos en el frontend del administrador de paquetes.',
        'Enables or disable the debug mode over frontend interface.' => 'Habilita o deshabilita el modo de depuración en la interfaz frontend.',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            'Habilita o deshabilita la funcionalidad de autocompletado para la búsqueda de clientes en la interfaz del agente.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Habilita o deshabilita la funcionalidad de monitoreo, para realizar un seguimiento de los tickets, sin ser el propietario o el responsable.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Habilita el log de desempeño (para registrar el tiempo de respuesta de las páginas). El desempeño del sistema se verá afectado. Frontend::Module###AdminPerformanceLog tiene que estar habilitado.',
        'Enables spell checker support.' => 'Habilita el soporte para la revisión ortográfica.',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Habilita la funcionalidad de acción múltiple sobre tickets para la interfaz del agente.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Habilita la funcionalidad de acción múltiple sobre tickets únicamente para los grupos listados.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Habilita la funcionalidad de responsable del ticket, para realizar un seguimiento de los tickets.',
        'Enables ticket watcher feature only for the listed groups.' => 'Habilita la funcionalidad de monitoreo de tickets sólo para los grupos listados.',
        'Escalation view' => 'Vista de escalado',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Example for free text' => 'Ejemplo de texto libre',
        'Execute SQL statements.' => 'Ejecutar sentencias SQL.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones de seguimiento en En-Respuesta-A o en las cabeceras de referencia, en los correos que no tienen un número de ticket en el asunto.',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones de archivos adjuntos a los correos de seguimiento, en los correos que no tienen un número de ticket en el asunto.',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones del cuerpo de los correos de seguimiento, en los correos que no tienen un número de ticket en el asunto.',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones de texto plano de los correos de seguimiento, en los correos que no tienen un número de ticket en el asunto.',
        'Experimental "Slim" skin which tries to save screen space for power users.' =>
            'Piel "Slim" experimental, que pretende ahorrar espacio en la pantalla para usuarios avanzados.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Exporta el árbol de artículo completo en el resultado de la búsqueda. Esto puede afectar el desempeño del sistema.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Obtiene paquetes vía proxy. Sobrescribe "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'Archivo que se muestra en el módulo Kernel::Modules::AgentInfo, si se encuentra bajo Kernel/Output/HTML/Standard/AgentInfo.dtl.',
        'Filter incoming emails.' => 'Filtrar correos electrónicos entrantes.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Fuerza la codificación de correos electrónicos salientes (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Fuerza a elegir un estado de ticket distinto al actual, luego de bloquear dicho ticket. Define como llave al estado actual y como contenido al estado posterior al bloqueo.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Fuerza a desbloquear los tickets, luego de moverlos a otra fila.',
        'Frontend language' => 'Idioma del frontend',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Registro de módulo frontend (deshabilita el vínculo de compañía si no se está usando la funcionalidad de compañía).',
        'Frontend module registration for the agent interface.' => 'Registro de módulo frontend para la interfaz del agente.',
        'Frontend module registration for the customer interface.' => 'Registro de módulo frontend para la interfaz del cliente.',
        'Frontend theme' => 'Tema frontend',
        'GenericAgent' => 'AgenteGenérico',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
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
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'Proporciona a los usuarios finales la posibilidad de sobrescribir el caracter de separación de los archivos CSV, definido en los archivos de traducción.',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'Permite el acceso, si el ID del cliente del ticket coincide con el ID del cliente y, además, dicho cliente tiene permisos de grupo en la fila en la que está el ticket.',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'Extiende la búsqueda de texto completo en los artículos (búsquedas en De, Para, Cc, Asunto y Cuerpo). Runtime realizará búsquedas de texto completo en los datos en tiempo real (funciona bien hasta 50,000 tickets). StaticDB buscará todos los artículos y construirá un índice después de la creación de artículos, incrementando las búsquedas en un 50%. Para generar un índice inicial, utilice "bin/otrs.RebuildFulltextIndex.pl".',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse un manejador de base de datos (normalmente se utiliza detección automática).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse una contraseña para conectarse a la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse un nombre de usuario para conectarse a la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse un DSN para la conexión con la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse el nombre de la columna de la tabla del cliente para la contraseña.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse el tipo de encriptado de los passwords.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse el nombre de la columna de la tabla del cliente para el identificador (llave).',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse el nombre de la tabla en la que se guardarán los datos de los clientes.',
        'If "DB" was selected for SessionModule, a column for the identifiers in session table must be specified.' =>
            'Si "DB" se eligió como SessionModule, puede especificarse el nombre de la columna para los identificadores de la tabla de sesión.',
        'If "DB" was selected for SessionModule, a column for the values in session table must be specified.' =>
            'Si "DB" se eligió como SessionModule, puede especificarse el nombre de la columna para los valores de la tabla de sesión.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Si "DB" se eligió como SessionModule, puede especificarse el nombre de la tabla en la que se guardarán los datos de sesión.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Si "FS" se eligió como SessionModule, puede especificarse un directorio en la que se guardarán los datos de sesión.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Si "HTTPBasicAuth" se eligió como Customer::AuthModule, puede especificarse (usando una expresión regular) la eliminación de partes del REMOTE_USER (por ejmplo: para quitar dominios finales). Nota de expresión regular: $1 será el nuevo inicio de sesión.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Si "HTTPBasicAuth" se eligió como Customer::AuthModule, puede especificarse la eliminación de algunas partes de los nombres de usuario (por ejemplo: para los dominios que usan nombres de usuario como dominio_de_ejemplo\nombre_usuario).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Si "LDAP" se eligió como Customer::AuthModule y se desea añadir un sufijo a cada nombre de inicio de sesión de los clientes, especifíquelo aquí. Por ejemplo: se desea escribir únicamente el nombre de usuario, pero en el directorio LDAP está registrado como usuario@dominio.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Si "LDAP" se eligió como Customer::AuthModule y se requieren parámetros especiales para el módulo perl Net::LDAP, pueden especificarse aquí. Refiérase a "perldoc Net::LDAP" para mayor información sobre los parámetros.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Si "LDAP" se eligió como Customer::AuthModule y sus usuarios sólo tienen acceso anónimo al árbol LDAP, pero se desea buscar en los datos; esto puede lograrse con un usuario que tenga acceso al directorio LDAP. Especifique aquí la contraseña para dicho usuario.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Si "LDAP" se eligió como Customer::AuthModule y sus usuarios sólo tienen acceso anónimo al árbol LDAP, pero se desea buscar en los datos; esto puede lograrse con un usuario que tenga acceso al directorio LDAP. Especifique aquí el nombre para dicho usuario.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede especificarse la BaseDN.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede especificarse el host LDAP.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede especificarse el identificador de usuario.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, pueden especificarse atributos de usuario. Para GruposPosix LDAP, use UID y para los demás, utilice el usuario DN completo.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, pueden especificarse aquí atributos de acceso.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede especificarse si las aplicaciones se detendrán si, por ejemplo, no se puede establecer una conexión con el servidor por problemas en la red.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede verificarse si al usuario se le permite autenticarse por estar en un GrupoPosix, por ejemplo: el usuario tiene que estar en el grupo xyz para usar OTRS. Especifique el grupo que puede acceder al sistema.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Si "LDAP" se eligió como Customer::AuthModule, es posible añadir un filtro a cada consulta LDAP, por ejemplo: (mail=*), (objectclass=user) o (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Si "Radius" se eligió como Customer::AuthModule, puede especificarse una contraseña para autenticar al host radius.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Si "Radius" se eligió como Customer::AuthModule, puede especificarse el host radius.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si "Radius" se eligió como Customer::AuthModule, puede especificarse si las aplicaciones se detendrán si, por ejemplo, no se puede establecer una conexión con el servidor por problemas en la red.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Si "Sendamail" se eligió como SendmailModule, puede especificarse la ubicación del sendmail binario y las opciones necesarias.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Si "SysLog" se eligió como LogModule, puede especificarse un log especial.',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'Si "SysLog" se eligió como LogModule, puede especificarse un log sock especial (en solaris es posible que deba usar \'stream\').',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Si "SysLog" se eligió como LogModule, puede especificarse el juego de caracteres que debe usarse para el inicio de sesión.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Si "File" se eligió como LogModule, puede especificarse el archivo log. Si dicho archivo no existe, será creado por el sistema.',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para cerrar tickets de la interfaz del agente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana de campos libres de ticket de la interfaz del agente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para añadir una nota, en la interfaz del agente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para cambiar el responsable de dicho ticket, en la interfaz del agente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para cambiar el propietario de dicho ticket, en la interfaz del agente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para definir dicho ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para cambiar la prioridad de dicho ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligió como SendmailModule y se requiere autenticación para el servidor de correos, debe especificarse una contraseña.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligió como SendmailModule y se requiere autenticación para el servidor de correos, debe especificarse un nombre de usuario.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligió como SendmailModule, debe especificarse el host que envía los correos.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligió como SendmailModule, debe especificarse el puerto en el que el servidor de correos estará escuchando para conexiones entrantes.',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'Si se habilita, OTRS entregará todos los archivos CSS en forma reducida (minified). ADVERTENCIA: Si ud. desactiva esta opción, es muy probable que se generen problemas en IE 7, porque no puede cargar más de 32 archivos CSS.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Si se habilita, OTRS entregará todos los archivos JavaScript en forma reducida (minified).',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Si se habilita, los módulos de tickets telefónico y de correo electrónico, se abrirán en una ventana nueva.',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            'Si se habilita, la versión de OTRS será removida de los encabezados HTTP.',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Si se habilita, el primer nivel del menú principal se abre al posicionar el cursor sobre él (en lugar de hacer click).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Si esta expresión regular coincide, ningún mensaje se mandará por el contestador automático.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'Si desea utilizar una base de datos espejo para la búsqueda de texto completo de tickets o para generar estadísticas, especifique el DSN a dicha base de datos.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'Si desea utilizar una base de datos espejo para la búsqueda de texto completo de tickets o para generar estadísticas, puede especificarse la contraseña para autenticarse a dicha base de datos.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'Si desea utilizar una base de datos espejo para la búsqueda de texto completo de tickets o para generar estadísticas, puede especificarse el usuario para autenticarse a dicha base de datos.',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Incluye los tiempos de creación de los artículos en la búsqueda de tickets de la interfaz del agente.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'Acelerador de índices para elegir su módulo backend TicketViewAccelerator, "RuntimeDB" genera sobre la marcha cada vista de filas desde la tabla de tickets (no hay problemas de desempeño hasta aprox. 60,000 tickets en total y 6,000 abiertos en el sistema). "StaticDB" es el módulo más poderoso, ya que usa un índice de tickets extra que funciona como una vista (recomendado para más de 80,000 tickets en total y 6,000 abiertos en el sistema). Use el script "bin/otrs.RebuildTicketIndex.pl" para actualizar su índice inicial.',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'Instala ispell o aspell en el sistema, si se desea usar el corrector ortográfico. Por favor, especifique la ruta al aspell o ispell binario en su sistema operativo.',
        'Interface language' => 'Idioma de la interfaz',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes pieles, por ejemplo: para diferenciar entre distintos agentes, para usarse una base por-dominio en la aplicación. Al definir una expresión regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una piel válida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresión regular correcta.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes pieles, por ejemplo: para diferenciar entre distintos clientes, para usarse una base por-dominio en la aplicación. Al definir una expresión regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una piel válida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresión regular correcta.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes pieles, por ejemplo: para diferenciar entre agentes y clientes, para usarse una base por-dominio en la aplicación. Al definir una expresión regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una piel válida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresión regular correcta.',
        'Link agents to groups.' => 'Vincular agentes con grupos.',
        'Link agents to roles.' => 'Vincular agentes con roles.',
        'Link attachments to responses templates.' => 'Vincular archivos adjuntos con plantillas de respuesta.',
        'Link customers to groups.' => 'Vincular clientes con grupos.',
        'Link customers to services.' => 'Vincular clientes con servicios.',
        'Link queues to auto responses.' => 'Vincular filas con auto-respuestas.',
        'Link responses to queues.' => 'Vincular respuestas con filas.',
        'Link roles to groups.' => 'Vincular roles con grupos.',
        'Links 2 tickets with a "Normal" type link.' => 'Vincular 2 tickets con un vículo de tipo "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Vincular 2 tickets con un vículo de tipo "PadreHijo".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista de archivos CSS que siempre se cargarán para la interfaz del agente.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS que siempre se cargarán para la interfaz del cliente.',
        'List of IE6-specific CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS específicos para IE6 que siempre se cargarán para la interfaz del cliente.',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS específicos para IE7 que siempre se cargarán para la interfaz del cliente.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Lista de archivos CSS específicos para IE8 que siempre se cargarán para la interfaz del agente.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS específicos para IE8 que siempre se cargarán para la interfaz del cliente.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista de archivos JS que siempre se cargarán para la interfaz del agente.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Lista de archivos JS que siempre se cargarán para la interfaz del cliente.',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'Archivo log para el contador de tickets.',
        'Mail Accounts' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Hace que la aplicación verifique el registro MX de las direcciones de correo electrónico, antes de enviar un correo o crear un ticket, ya sea telefónico o de correo electrónico.',
        'Makes the application check the syntax of email addresses.' => 'Hace que la aplicación verifique la sintaxis de las direcciones de correo electrónico.',
        'Makes the picture transparent.' => 'Hace las imágenes transparentes.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Hace que la gestión de sesiones utilice cookies html. Si las cookies html están deshabilitadas o si el explorador del cliente las tiene deshabilitadas, el sistema trabajará normalmente y agregará el identificador de sesión a los vínculos.',
        'Manage PGP keys for email encryption.' => 'Gestionar las llaves PGP para encriptación de correos electrónicos.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gestionar las cuentas POP3 o IMAP de las que se extraen correos.',
        'Manage S/MIME certificates for email encryption.' => 'Gestionar certificados S/MIME para encriptación de correos electrónicos.',
        'Manage existing sessions.' => 'Gestionar sesiones existentes.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Gestionar tareas periódicas.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Tamaño máximo (en caracteres) para la tabla de información del cliente (teléfono y correo electrónico) en la ventana de redacción.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => 'Tamaño máximo para los asuntos en la respuesta a un correo electrónico.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Número máximo de respuestas automáticas (vía correos electrónicos) al día para la dirección de correo electrónico propia (protección de bucle).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Tamaño máximo en KBytes para correos que pueden obtenerse vía POP3/POP3S/IMAP/IMAPS.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Número máximo de tickets para ser mostrados en el resultado de una búsqueda, en la interfaz del agente.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Número máximo de tickets para ser mostrados en el resultado de una búsqueda, en la interfaz del cliente.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Número máximo (en caracteres) de la tabla de información del cliente en la vista detallada del ticket.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Módulo para la selección del destinatario en la ventana de ticket nuevo, en la interfaz del cliente.',
        'Module to check customer permissions.' => 'Módulo para verificar los permisos del cliente.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'Módulo para verificar si un usuario se encuentra en un grupo específico. Se permite el acceso si el usuario está en cierto grupo y tiene permisos ro y rw.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            'Módulo para verificar si los correos recibidos deben marcarse como internos.',
        'Module to check the agent responsible of a ticket.' => 'Módulo para verificar el agente responsable de un ticket.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Módulo para verificar los permisos de grupo para el acceso a los tickets de los clientes.',
        'Module to check the owner of a ticket.' => 'Módulo para verificar el propietario de un ticket.',
        'Module to check the watcher agents of a ticket.' => 'Módulo para verificar los agentes que monitorean un ticket.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Módulo para redactar mensajes firmados (PGP o S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Módulo para encriptar mensajes firmados (PGP o S/MIME).',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Módulo para filtrar y manipular mensajes entrantes. Bloquea/ignora todos los correos no deseados con direcciones De: noreply@.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Módulo para filtrar y manipular mensajes entrantes. Obtenga un número de 4 dígitos para el texto libre de ticket, use una expresión regular en Match, por ejemplo: From => \'(.+?)@.+?\', y utilice () como [***] en Set =>.',
        'Module to generate accounted time ticket statistics.' => 'Módulo para generar estadísticas de la contabilidad de tiempo de los tickets.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Módulo para generar perfil OpenSearch html para búsqueda simple de tickets en la interfaz del agente.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Módulo para generar perfil OpenSearch html para búsqueda simple de tickets en la interfaz del cliente.',
        'Module to generate ticket solution and response time statistics.' =>
            'Módulo para generar estadísticas del tiempo de solución y respuesta de los tickets.',
        'Module to generate ticket statistics.' => 'Módulo para generar estadísticas de tickets.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Módulo para mostrar notificaciones y escalados (ShownMax: Número máximo de escalados que se muestran, EscalationInMinutes: Mostrar el ticket que escalará en estos minutos, CacheTime: Caché de los escalados calculados en segundos).',
        'Module to use database filter storage.' => 'Módulo para utilizar el almacenamiento de base de datos del filtro.',
        'Multiselect' => '',
        'My Tickets' => 'Mis Tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Nombre de fila personalizada, misma que es una selección de sus filas de preferencia y puede elegirse en las configuraciones de sus preferencias.',
        'NameX' => '',
        'New email ticket' => 'Ticket de correo electrónico nuevo',
        'New phone ticket' => 'Ticket telefónico nuevo',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Lista de posibles estados siguientes de ticket, luego de haber añadido una nota telefónica a un ticket, en la ventana de ticket telefónico slaiente de la interfaz del agente.',
        'Notifications (Event)' => 'Notificaciones (Evento)',
        'Number of displayed tickets' => 'Número de tíckets desplegados',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Número de líneas (por ticket) que se muestran por la utilidad de búsqueda de la interfaz del agente.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Número de tickets desplegados en cada página del resultado de una búsqueda, en la interfaz del agente.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Número de tickets desplegados en cada página del resultado de una búsqueda, en la interfaz del cliente.',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Sobrecarga (redefine) funciones existentes en Kernel::System::Ticket. Útil para añadir personalizaciones fácilmente.',
        'Overview Escalated Tickets' => 'Resumen de Tickets Escalados',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => ' Resumen de todos los Tickets abiertos',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'Cargar Llave PGP',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Parámetros para el objeto CrearMáscaraNueva, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'Parámetros para el objeto QueuePersonalizada, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'Parámetros para el objeto NotificaciónSeguimiento, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'Parámetros para el objeto NotificaciónTiempoDeEsperaBloqueo, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'Parámetros para el objeto NotificaciónMovimiento, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'Parámetros para el objeto NotificaciónTicketNuevo, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Parámetros para el objeto TiempoActualización, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'Parámetros para el objeto NotificaciónObservador, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del panel principal de la vista de resumen de tickets nuevos de la interfaz del agente. "Limit" es el número de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la caché del plugin.',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del panel principal del calendario de ticket de la interfaz del agente. "Limit" es el número de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la caché del plugin.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del panel principal de la vista de resumen de tickets escalados de la interfaz del agente. "Limit" es el número de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la caché del plugin.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del panel principal de la vista de resumen de tickets con recordatorio pendiente de la interfaz del agente. "Limit" es el número de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la caché del plugin.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del panel principal de la vista de resumen de tickets con recordatorio pendiente de la interfaz del agente. "Limit" es el número de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la caché del plugin.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del panel principal de las estadísticas de ticket de la interfaz del agente. "Limit" es el número de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la caché del plugin.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Parámetros para las páginas (en las que se muestran los tickets) de la vista de resumen mediana.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Parámetros para las páginas (en las que se muestran los tickets) de la vista de resumen peqyeña.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Parámetros para las páginas (en las que se muestran los tickets) de la vista de resumen previa.',
        'Parameters of the example SLA attribute Comment2.' => 'Parámetros del ejemplo del atributo de SLA, Comment2.',
        'Parameters of the example queue attribute Comment2.' => 'Parámetros del ejemplo del atributo de fila, Comment2.',
        'Parameters of the example service attribute Comment2.' => 'Parámetros del ejemplo del atributo de servicio, Comment2.',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Ruta para el archivo log (aplica únicamente si "FS" se eligió como LoopProtectionModule y si es obligatorio).',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            'Ruta para el archivo que almacena todas las configuraciones para el ObjetoFila de la interfaz del agente.',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            'Ruta para el archivo que almacena todas las configuraciones para el ObjetoFila de la interfaz del cliente.',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            'Ruta para el archivo que almacena todas las configuraciones para el ObjetoTicket de la interfaz del agente.',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            'Ruta para el archivo que almacena todas las configuraciones para el ObjetoTicket de la interfaz del cliente.',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => 'Anchura permitida para las ventanas de redacción de correos electrónicos.',
        'Permitted width for compose note windows.' => 'Anchura permitida para las ventanas de redacción de notas.',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'Filtros del Administrador de Correos',
        'PostMaster Mail Accounts' => 'Cuentas del Administrador de Correos',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Protección contra CSRF (Solicitud de Falsificación de Sitios Cruzada). Consulte http://en.wikipedia.org/wiki/Cross-site_request_forgery para mayor información.',
        'Queue view' => 'Vista de Filas',
        'Refresh Overviews after' => '',
        'Refresh interval' => 'Intervalo de actualización',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Reemplaza el destinatario original con la dirección de correo electrónico del cliente actual, al redactar una respuesta en la ventana de redacción de tickets de la interfaz del agente.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Permisos necesarios para cambiar el cliente de un ticket, en la interfaz del agente.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para cerrar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para rebotar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para redactar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para reenviar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Permisos necesarios usar la ventana de campos libres de texto de ticket, en la interfaz del agente.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para mezclar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para añadir notas a los tickets, en la interfaz del agente.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar el propietario de un ticket, en la interfaz del agente.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para definir un ticket como pendiente, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Permisos necesarios usar la ventana de ticket telefónico saliente, en la interfaz del agente.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar la prioridad de un ticket, en la interfaz del agente.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Reinicializa y desbloquea al propietario de un ticket, si este último se mueve a otra fila.',
        'Responses <-> Queues' => 'Respuestas <-> Filas',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Restablece un ticket del archivo (sólo si el evento es un cambio de estado de cerrado a cualquiera de los estados abiertos disponibles).',
        'Roles <-> Groups' => 'Roles <-> Grupos',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Ejecuta el sistema en modo "Demo". Si se selecciona "Sí", los agentes pueden modificar preferencias, como elegir el idioma y el tema, a través de la interfaz del agente. Estos cambios sólo serán válidos en la sesión actual. No se les permitirá a los agentes que cambien su contraseña.',
        'S/MIME Certificate Upload' => 'Cargar Certificado S/MIME',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            'Guarda los archivos adjuntos de los artículos. "DB" almacena todos en la base de datos (no se recomienda para guardar archivos adjuntos grandes), mientras que "FS" usa el sistema de archivos, lo cual es más rápido, pero el servidor web tiene que ser ejecutado con el usuario OTRS. Es posible cambiar entre los módulos sin perder información, inclusive en un sistema en producción.',
        'Saves the login and password on the session table in the database, if "DB" was selected for SessionModule.' =>
            '',
        'Search backend default router.' => 'Buscar el router por defecto del backend.',
        'Search backend router.' => 'Buscar el router del backend.',
        'Select your frontend Theme.' => 'Seleccione su tema.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Selecciona el módulo para manejar las cargas de archivos en la interfaz web. "DB" almacena todos en la base de datos, mientras que "FS" usa el sistema de archivos.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Selecciona el módulo generador de números de ticket. "AutoIncrement" incrementa el número de ticket, se usan el ID del sistema y el contador, en la forma IDSistema.contador (por ejemplo: 1010138, 1010139). Con "Date", el número de ticket se genera con la fecha actual, el ID de sistema y el contador, con el formato: Año.Mes.Día.IDSistema.Contador.SumaDeComprobación (por ejemplo: 2002070110101520, 2002070110101535). "Random" genera números de tickets aleatorios, con el formato IDSistema.Aleatorio (por ejemplo: 100057866352, 103745394596).',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Enviarme notificaciones si un cliente realiza un seguimiento y yo soy el propietario del ticket o si el ticket está desbloqueado y se encuentra en alguna de las filas en las que estoy suscrito.',
        'Send notifications to users.' => 'Enviar notificaciones a usuarios.',
        'Send ticket follow up notifications' => 'Enviar notificaciones de seguimiento de tickets',
        'Sender type for new tickets from the customer inteface.' => 'Tipo de destinatario para tickets nuevos, creados  en la interfaz del cliente.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Enviar notificaciones de seguimiento únicamente al agente propietario, si el ticket se desbloquea (por defecto se envían notificaciones a todos los agentes).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Envía todos los correos electrónicos salientes vía bcc a la dirección especificada. Por favor, utilice esta opción únicamente por motivos de copia de seguridad).',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'Envía notificaciones sólo a los clientes especificados. Normalemente, si no se especifica un cliente, quien obtiene la notificación es el último remitente.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Envía notificaciones de recordatorio de tickets desbloqueados a sus propietarios, luego que alcanzaron la fecha de recordatorio.',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Envía las notificaciones que se configuran en la interfaz de administración, bajo "Notificación (Evento)".',
        'Set sender email addresses for this system.' => 'Define la dirección de correo electrónico remitente del sistema.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Define la altura por defecto (en pixeles) de artículos HTML en línea en la vista detallada del ticket de la interfaz del agente.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Define la altura máxima (en pixeles) de artículos HTML en línea en la vista detallada del ticket de la interfaz del agente.',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => 'Define si el propietario del ticket tiene que ser seleccionado por el agente.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Fija el tiempo pendiente de un ticket a 0, si el estado se cambia a uno no pendiente.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Fija la edad en minutos (primer nivel) para resaltar filas que contienen tickets sin tocar.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Fija la edad en minutos (segundo nivel) para resaltar filas que contienen tickets sin tocar.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Fija el nivel de configuración del administrador. Dependiendo del nivel de configuración, algunas configuraciones del sistema no se mostrarán. Los niveles están en orden ascendente: Experto, Avanzado, Principiante. Entre más alto sea el nivel de configuración (por ejemplo: Beginner es el más alto), es menos probable que el usuario pueda configurar accidentalemente el sistema de una forma que quede inutilizable.',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Fija el tipo de artículo por defecto para los tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Fija el tipo de artículo por defecto para los tickets telefónicos nuevos, en la interfaz del agente.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para cerrar tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para mover tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para agregar notas a los tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece el contenido por defecto del cuerpo de las notas que se añaden en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Define el tipo de vínculo por defecto de tickets divididos, en la interfaz del agente.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Define el estado siguiente por defecto para tickets telefónicos nuevos, en la interfaz del agente.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Define el estado siguiente por defecto para tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas para tickets telefónicos nuevos, en la interfaz del agente. Por ejemplo: \'Ticket nuevo vía llamada\'.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Define la prioridad por defecto para tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Define la prioridad por defecto para tickets telefónicos nuevos, en la interfaz del agente.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Define el tipo de remitente por defecto para tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Define el tipo de remitente por defecto para tickets telefónicos nuevos, en la interfaz del agente.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Define el asunto por defecto para tickets de correo electrónico nuevos, en la interfaz del agente. Por ejemplo: \'Correo electrónico saliente\'.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Define el asunto por defecto para tickets telefónicos nuevos, en la interfaz del agente. Por ejemplo: \'Llamada telefónica\'.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para cerrar tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para mover tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para agregar notas a los tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece el asunto por defecto del cuerpo de las notas que se añaden en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de los tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the display order of the different items in the preferences view.' =>
            'Define el orden por defecto en el que se mostrarán los diferentes elementos, en la vista de preferencias.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'Define el tiempo de inactividad (en segundos) que deberá pasar antes de cerrar la sesión de un usuario y finalizar su sesión.',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            'Define el tamaño mínimo del contador de tickets (si "AutoIncrement" se eligió como TicketNumberGenerator). El valor por defecto es 5, lo cual quiere decir que el contador comineza en 10000.',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            'Define el número mínimo de caracteres que debe haber, antes de enviar una consulta de autocompletado.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Define el número de líneas mostradas en los mensajes de texto (por ejemplo: renglones de ticket en la vista detallada de las filas).',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            'Define el número de resultados de búsqueda mostrados por la funcionalidad de autocompletado.',
        'Sets the options for PGP binary.' => 'Define las opciones para PGP binario.',
        'Sets the order of the different items in the customer preferences view.' =>
            'Define el orden de los diferentes elementos, en la vista de preferencias de la interfaz del cliente.',
        'Sets the password for private PGP key.' => 'Define la contraseña para la llave PGP privada.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Define las unidades de tiempo preferidas (por ejemplo: unidades laborales, horas, minutos).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Define el prefijo para la carpeta que contiene los scripts en el servidor, tal y como se configuró en el servidor web. Esta configuración se usa como una variable (OTRS_CONFIG_ScriptAlias) y está presente en todas las formas de mensajes que maneja la aplicación, con la finalidad de crear vínculos a los tickets dentro del sistema.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Define el servicio, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Define el servicio, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Define el servicio, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Define el servicio, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Define el servicio, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Define el servicio, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Define el servicio, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Sets the size of the statistic graph.' => 'Define el tamaño del gráfico para las estadísticas.',
        'Sets the stats hook.' => 'Define el candado para las estadísticas.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'Define la zona horaria del sistema (se requiere un sistema con UTC como hora, de lo contrario, habría una diferencia con la hora local).',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Define el tipo de ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Define el tipo de ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Define el tipo de ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Define el tipo de ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Define el tipo de ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Define el tipo de ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Define el tipo de ticket, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Sets the time type which should be shown.' => 'Define el tipo de tiempo que debe mostrarse.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Define el tiempo de espera (en segundos) para descargas http/ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Define el tiempo de espera (en segundos) para descargas de paquetes.',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Define la zona horaria del usuario (se requiere un sistema con UTC como hora, de lo contrario, habría una diferencia con la hora local).',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'Define la zona horaria del usuario, basándose en java script / zona horaria del navegador, al iniciar sesión en el sistema.',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Muestra una selección del agente responsable, en los tickets telefónico y de correo electrónico de la interfaz del agente.',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Muestra un recuento de íconos en la vista detallada del ticket, si el artículo tiene archivos adjuntos.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, para suscribirse / darse de baja de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite vincular un ticket con otro objeto, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite mezclar tickets, en la vista detallada de ticket de la interfaz del agente.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite acceder a la historia de dicho ticket, en su vista detallada de la interfaz del agente.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite añadir un campo de texto libre a un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite añadir una nota a un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite añadir una nota a un ticket, en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite cerrar un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite cerrar un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un vínculo en el menú, que permite eliminar un ticket en todas y cada una de las vistas de resumen de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este vínculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un vínculo en el menú, que permite eliminar un ticket, en la vista detallada de dicho ticket de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este vínculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite regresar a la ventana anterior, en la vista detallada de un ticket, en la interfaz del agente.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite bloquear / desbloquear un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite bloquear / desbloquear un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite mover un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite imprimir un ticket o un artículo, en la vista detallada del ticket, en la interfaz del agente.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite verificar el cliente que solicitó el ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite acceder a la historia de dicho ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite modificar el propietario de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite modificar la prioridad de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite modificar el responsable de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite definir un ticket como pendiente, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un vínculo en el menú, que permite definir un ticket como basura (spam) en todas y cada una de las vistas de resumen de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este vínculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite modificar la prioridad de un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite acceder a la vista detallada de un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Muestra un vínculo para acceder a los archivos adjuntos de un artículo a través de un visualizador html en línea, en la vista detallada de dicho artículo de la interfaz del agente.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Muestra un vínculo para descargar los archivos adjuntos de un artículo, en la vista detallada de dicho artículo de la interfaz del agente.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Muestra un vínculo para visualizar un ticket de correo electrónico en texto plano, en la vista detallada de dicho ticket.',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un vínculo para definir un ticket como basura (spam), en la vista detallada de dicho artículo de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este vínculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para cerrar dicho ticket de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Muestra una vista previa de la vista de resumen de los tickets (CustomerInfo => 1 - muestra también la información del cliente y CustomerInfoMaxSize define el tamaño máximo, en caracteres, de dicha información).',
        'Shows all both ro and rw queues in the queue view.' => 'Muestra las filas ro y rw en la vista de filas.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Muestra todos los tickets abiertos (inclusive si están bloqueados), en la vista de escalado de la interfaz del agente.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Muestra todos los tickets abiertos (inclusive si están bloqueados), en la vista de estados de la interfaz del agente.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Muestra todos los artículos de un ticket (expandidos), en la vista detallada de dicho ticket.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Muestra todos los identificadores de clientes en un campo de selección múltiple (no es útil si existen muchos identificadores).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Muestra una selección de propietario en los tickets telefónico y de correo electrónico de la interfaz del agente.',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Muestra tickets del historial del cliente en los tickets telefónico y de correo electrónico, en la interfaz del agente; y en la ventana para añadir un ticket, en la interfaz del cliente.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Muestra el asunto del último artículo añadido por el cliente o el título del ticket, en el formato pequeño de la vista de resumen.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Muestra las filas padre/hijo existentes en el sistema, ya sea en forma de árbol o de lista.',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Muestra los atributos de ticket activos en la interfaz del cliente (0 = Deshabilitado y 1 = Habilitado).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Muestra los artículos ordenados normalmente o de forma inversa, en la vista detallada de un ticket, en la interfaz del agente.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Muestra la información del cliente (número telefónico y cuenta de correo electrónico) en la ventana de redacción de artículos.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Muestra la información del cliente en la vista detallada de un ticket, en la interfaz del agente.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Muestra el mensaje del día en el panel principal del agente. "Group" se usa para restringir el acceso al plugin (por ejemplo: Group: admin;grupo1;grupo2;). "Default" indica si el plugin está habilitado por defecto o si el usuario tiene que activarlo manualmente.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Muestra el mensaje del día en la ventana de inicio de sesión de la interfaz del agente.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Muestra la historia del ticket (ordenada inversamente) en la interfaz del agente.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para mover tickets, en la interfaz del agente.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'Muestra los campos de título, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'Muestra los campos de título, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Muestra los campos de título, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra los campos de título, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra los campos de título, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra los campos de título, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Muestra los campos de título, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Si se elige "Yes", muestra el tiempo en formato largo (días, horas, minutos); de lo contrario, se usa el formato corto (días, horas).',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => 'Piel.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Ordena los tickets (ascendente o descendentemente), luego de haberse ordenado por prioridad, cuando una sola fila se selecciona en la vista de filas. Values: 0 = ascendente (por defecto, más antiguo arriba), 1 = descendente (más reciente arriba). Use el identificador de la fila como Key y 0 ó 1 como Valor.',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Ejemplo de configuración del eliminador de correo basura. Ignora los correos electrónicos que están marcados con SpamAssasin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Ejemplo de configuración del eliminador de correo basura. Mueve los correos marcados a la fila basura.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Especifica si un agente debe recibir notificaciones en su correo electrónico, acerca de sus propias acciones.',
        'Specifies the background color of the chart.' => 'Especifica el color de fondo para el gráfico.',
        'Specifies the background color of the picture.' => 'Especifica el color de fondo para la fotografía.',
        'Specifies the border color of the chart.' => 'Especifica el color de la orilla del gráfico.',
        'Specifies the border color of the legend.' => 'Especifica el color de la orilla de la leyenda.',
        'Specifies the bottom margin of the chart.' => 'Especifica el margen inferior del gráfico.',
        'Specifies the different article types that will be used in the system.' =>
            'Especifica los diferentes tipos de artículo que se usarán en el sistema.',
        'Specifies the different note types that will be used in the system.' =>
            'Especifica los diferentes tipos de nota que se usarán en el sistema.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Especifica el directorio en el que se guardarán los datos, si "FS" se eligió como TicketStorageModule.',
        'Specifies the directory where SSL certificates are stored.' => 'Especifica el directorio donde se guardan los certificados SSL.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Especifica el directorio donde se guardan los certificados privados SSL.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Especifica la dirección de correo electrónico que debe usar la aplicación al mandar notificaciones. Dicha dirección se usa para construir el nombre completo a desplegar del notificador maestro (por ejemplo: "Notificador maestro de OTRS" otrs@su.ejemplo.com). Es posible usar la variable OTRS_CONFIG_FQDN, tal y como se definió en la configuración, o elegir otra dirección de correo electrónico. Las notificaciones son mensajes como es::Customer::QueueUpdate o es::Agent::Move.',
        'Specifies the left margin of the chart.' => 'Especifica el margen izquierdo del gráfico.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Especifica el nombre que debe usar la aplicación al mandar notificaciones. El remitente se usa para construir el nombre completo a desplegar del notificador maestro (por ejemplo: "Notificador maestro de OTRS" otrs@su.ejemplo.com). Las notificaciones son mensajes como es::Customer::QueueUpdate o es::Agent::Move.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Especifica la ruta del archivo que corresponde al logo del encabezado de la página (gif|jpg|png, 700 x 100 pixeles).',
        'Specifies the path of the file for the performance log.' => 'Especifica la ruta del archivo que corresponde al log de desempeño.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos de Microsoft Excel en la interfaz web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos de Microsoft Word en la interfaz web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar documentos PDF en la interfaz web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos XML en la interfaz web.',
        'Specifies the right margin of the chart.' => 'Especifica el margen derecho del gráfico.',
        'Specifies the text color of the chart (e. g. caption).' => 'Especifica el color del texto para el gráfico (por ejemplo: título).',
        'Specifies the text color of the legend.' => 'Especifica el color de la leyenda.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Especifica el texto que debe aparecer en el archivo de desempeño para denotar una entrada de script CGI.',
        'Specifies the top margin of the chart.' => 'Especifica el margen superior del gráfico.',
        'Specifies user id of the postmaster data base.' => 'Especifica el identificador de usuario de la base de datos del administrador de correos.',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Permisos estándar disponibles para los agentes en la aplicación. Si se requieren más permisos, pueden especificarse aquí, pero para que sean efectivos, es necesario definirlos. Otros permisos útiles también se proporcionaron, incorporados al sistema: nota, cerrar, pendiente, cliente, texto libre, mover, redactar, responsable, reenviar y rebotar. Asegúrese de que "rw" permanezca siempre como el último permiso registrado.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Número de inicio para el conteo de estadísticas. Cada estadística nueva incrementa este número.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'Estadísticas',
        'Status view' => 'Vista de estados',
        'Stores cookies after the browser has been closed.' => 'Guarda las cookies después de que el explorador se cerró.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Elimina las líneas en blanco de la vista previa de tickets, en la vista de filas.',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            'El "bin/PostMasterMailAccount.pl" se reconecta al host POP3/POP3S/IMAP/IMAPS, después del número de mensajes especificado.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'El nombre interno de la piel que debe usarse en la interfaz del agente. Por favor, verifique las pieles disponibles en Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'El nombre interno de la piel que debe usarse en la interfaz del cliente. Por favor, verifique las pieles disponibles en Frontend::Customer::Skins.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'El divisor entre el candado y el número de ticket. Por ejemplo, \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            'El formato del asunto. \'Left\' significa \'[TicketHook#:12345] Algún asunto\', \'Right\' significa \'Algún asunto [TicketHook#:12345]\', \'None\' significa \'Algún asunto\', sin número de ticket. Para la última opción, es necesario que se habilite PostmasterFollowupSearchInRaw o PostmasterFollowUpSearchInReferences, para reconocer los seguimientos en base a las cabeceras de correo electrónico y/o al cuerpo del mensaje.',
        'The headline shown in the customer interface.' => 'El encabezado mostrado en la interfaz del cliente.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'El identificador para un ticket, por ejemplo: Ticket#, Llamada#, MiTicket#. El valor por defecto es Ticket#.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'El logo mostrado en la parte superior de la caja de inicio de sesión de la interfaz del agente. La URL a la imagen tiene que ser relativa a la URL del directorio de imágenes de piel.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'El texto para anteponer al asunto en una respuesta de correo electrónico, por ejemplo: RE, AW, o AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'El texto para anteponer al asunto cuando un correo electrónico se reenvía, por ejemplo: FW, Fwd, o WG.',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Este módulo y su función PreRun() se ejecutarán, si así se define, por cada petición. Este módulo es útil para verificar algunas opciones de usuario o para desplegar noticias acerca de aplicaciones novedosas.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Vista de resumen de los tickets',
        'Tickets' => 'Tickets',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Tiempo en segundos que se añade al tiempo actual, si se define un estado-pendiente (por defecto: 86400 = 1 día).',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => 'Elemento de la barra de herramientas para un atajo (shortcut).',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Activa las animaciones uadas en la GUI. Si tiene dificultados con dichas animaciones (por ejemplo: problemas de rendimiento), puede desactivarlas aquí.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Activa la verificación de direcciones ip remotas. Debe elegirse "No" si la aplicación se usa, por ejemplo, a través de un servidor proxy o una conexión de acceso telefónico, ya que la dirección ip remota es, en general, diferente para las peticiones.',
        'Types' => 'Tipos',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Actualizar la bandera de ticket "Seen" ("Visto"), si ya se vió cada artículo o si se creó un artículo nuevo.',
        'Update and extend your system with software packages.' => 'Actualizar y extender su sistema con paquetes de software.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Actualiza el índice de escalado de ticket, luego de que un atributo de ticket se actualizó.',
        'Updates the ticket index accelerator.' => 'Actualiza el acelerador de índice de ticket.',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Usa los destinatarios Cc, en la lista de respuesta Cc, al redactar una respuesta electrónica en la ventana de redacción de la interfaz del agente.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            'Usa texto enriquecido para visualizar y editar: artículos, saludos, firmas, respuestas estándar, auto respuestas y notificaciones.',
        'View performance benchmark results.' => 'Ver los resultados de rendimiento.',
        'View system log messages.' => 'Ver los mensajes del log del sistema.',
        'Wear this frontend skin' => 'Usar esta piel frontend.',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            'Cuando los tickets se mezclan, se agregará una nota automáticamente al ticket que ya no está activo. Es posible definir el contenido de dicha nota en esta área de texto (el agente no puede modificar este texto).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Cuando los tickets se mezclan, el cliente puede ser informado por correo electrónico al seleccionar "Inform Sender". Es posible predefinir el contenido de dicha notificación en esta área de texto, que luego puede ser modificada por los agentes.',
        'Your language' => 'Su idioma',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Fila de selección de filas favoritas. Ud. también puede ser notificado de estas filas vía correo si está habilitado',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets afectados. ¿Realmente desea utilizar esta tarea?',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' =>
            '(Chequear registro MX de direcciones utilizadas al responder. ¡ No usarlo si su PC con OTRS está detrás de una línea telefonica $!)',
        '(Email of the system admin)' => '(email del administrador del sistema)',
        '(Full qualified domain name of your system)' => '(Nombre completo del dominio de su sistema)',
        '(Logfile just needed for File-LogModule!)' => '(Archivo de log necesario para File-LogModule)',
        '(Note: It depends on your installation how many dynamic objects you can use)' =>
            '(Nota: Depende de su instalación cuántos objetos dinámicos puede utilizar',
        '(Note: Useful for big databases and low performance server)' => '(Nota: Util para bases de datos grandes y servidores de bajo rendimiento)',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' =>
            '(La identidad del sistema. Cada número de ticket y cada id de sesión http comienza con este número)',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' =>
            '(Identificador de Ticket. Algunas personas quieren usar por ejemplo \'Ticket#\', \'Call#\' o \'MyTicket#\')',
        '(Used default language)' => '(Use el lenguaje por defecto)',
        '(Used log backend)' => '(Interface de log Utilizada)',
        '(Used ticket number format)' => '(Formato de número de ticket utilizado)',
        'A article should have a title!' => 'Los artículos deben tener título',
        'A message must be spell checked!' => 'El mensaje debe ser verificado ortográficamente!',
        'A message should have a To: recipient!' => 'El mensaje debe tener el destinatario Para: !',
        'A message should have a body!' => 'Los mensajes deben tener contenido',
        'A message should have a subject!' => 'Los mensajes deben tener asunto.',
        'A required field is:' => 'Un campo requerido es:',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Una respuesta es el texto por defecto para responder más rápido (con el texto por defecto) a los clientes.',
        'A web calendar' => 'Calendario Web',
        'A web file manager' => 'Administrador web de archivos',
        'A web mail client' => 'Un cliente de correo Web',
        'Absolut Period' => 'Periodo Absoluto',
        'Account Type' => 'Tipo de cuenta',
        'Activates TypeAhead for the autocomplete feature, that enables users to type in whatever speed they desire, without losing any information. Often this means that keystrokes entered will not be displayed on the screen immediately.' =>
            'Activa TypeAhead para la funcionalidad de autocompletar, lo que le permite a los usuarios teclear a cualquier velocidad, sin perder información. Con frecuencia, esto significa que las pulsaciones del teclado no se mostrarán de forma inmediata en la pantalla.',
        'Add Customer User' => 'Añadir Cliente',
        'Add System Address' => 'Añadir Dirección de Sistema',
        'Add User' => 'Añadir Usuario',
        'Add a new Agent.' => 'Añadir un nuevo Agente',
        'Add a new Customer Company.' => 'Añadir una nueva Compañía del Cliente.',
        'Add a new Group.' => 'Añadir nuevo Grupo',
        'Add a new Notification.' => 'Agregar una nueva Notificación',
        'Add a new Priority.' => 'Añadir una nueva Prioridad.',
        'Add a new Role.' => 'Añadir un nuevo Rol',
        'Add a new SLA.' => 'Añadir un nuevo SLA',
        'Add a new Salutation.' => 'Añadir un nuevo Saludo',
        'Add a new Service.' => 'Añadir un nuevo Servicio',
        'Add a new Signature.' => 'Añadir una nueva Firma',
        'Add a new State.' => 'Añadir un nuevo Estado',
        'Add a new System Address.' => 'Añadir una Dirección de Sistema',
        'Add a new Type.' => 'Añadir un nuevo Tipo',
        'Add a note to this ticket!' => 'Añadir una nota a este ticket',
        'Add note to ticket' => 'Añadir nota al ticket',
        'Added User "%s"' => 'Usuario "%s añadido"',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Añade las direcciones de correo electrónico de los clientes a los destinatarios, en la ventana de redacción de un artículo para un ticket de la interfaz del agente.',
        'Adds the one time vacation days for the calendar number 1. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 1. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 2. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 2. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 3. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 3. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 4. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 4. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 5. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 5. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 6. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 6. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 7. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 7. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 8. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 8. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 9. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones, únicos para cada año, al calendario número 9. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 1. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 1. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 2. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 2. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 3. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 3. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 4. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 4. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 5. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 5. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 6. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 6. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 7. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 7. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 8. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 8. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 9. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones fijos (iguales para todos los años), al calendario número 9. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09).',
        'Admin-Area' => 'Área-Admin',
        'Admin-Email' => 'Correo del Administrador',
        'Admin-Password' => 'Contraseña-Administrador',
        'Admin-User' => 'Usuario-Admin',
        'Advisory' => 'Advertencia',
        'Agent Mailbox' => 'Buzón del Agente',
        'Agent Preferences' => 'Preferencias del Agente',
        'Agent based' => 'Basado en agente',
        'Agent-Area' => 'Área-Agente',
        'All Agent variables.' => 'Todas las variables de Agente',
        'All Agents' => 'Todos los Agentes',
        'All Customer variables like defined in config option CustomerUser.' =>
            'Todas las variables de cliente, como las declaradas en la opción de configuracion del cliente',
        'All customer tickets.' => 'Todos los tickets de un cliente',
        'All email addresses get excluded on replaying on composing an email.' =>
            'Toda dirección de correo electrónico será omitida mientras se compone la respuesta de un correo.',
        'All email addresses get excluded on replaying on composing and email.' =>
            'Todas las direcciones de correo electrónico será omitidas al componer la respuesta a un correo',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' =>
            'Todos los mensajes entrantes con esta dirección (Para:) serán enviados a la fila seleccionada',
        'All messages' => 'Todos los mensajes',
        'All new tickets!' => 'Todos los nuevos tickets',
        'All tickets where the reminder date has reached!' => 'Todos los tickes que han alcanzado la fecha de recordatorio',
        'All tickets which are escalated!' => 'Todos los tickets que estan escalados',
        'Allocate CustomerUser to service' => 'Relacionar Clientes con Servicios',
        'Allocate services to CustomerUser' => 'Relacionar Servicios con Clientes',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite el uso de condiciones de búsqueda extendida al buscar tickets en la interfaz del agente. Con esta funcionalidad, es posible buscar condiciones como, por ejemplo, "(llave1&&llave2)" o "(llave1||llave2)".',
        'Answer' => 'Responder',
        'Artefact' => 'Artefacto',
        'Article Create Times' => 'Tiempo de Creación de Artículo',
        'Article created' => 'Artículo Creado',
        'Article created between' => 'Artículo creado entre',
        'Article filter settings' => 'Configuración de filtro de artículos',
        'Article free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana para cerrar un ticket de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana de ticket de correo electrónico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana de ticket telefónico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana de redacción de los mismos de la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana de campos libres de ticket de la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana para agregar una nota al ticket, en la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket owner screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana para cambiar el propietario de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket pending screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana de ticket pendiente de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana de llamada telefónica saliente de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket priority screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana para cambiar la prioridad de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los artículos, mostrados en la ventana para cambiar el responsable de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'ArticleID' => 'Identificador de artículo',
        'Attach' => 'Anexo',
        'Attribute' => 'Atributo',
        'Auto Response From' => 'Respuesta Automática De',
        'Bounce Ticket: ' => 'Rebotar Ticket',
        'Bounce ticket' => 'Ticket rebotado',
        'Can not create link with %s!' => 'No se puede vincular con %s!',
        'Can not delete link with %s' => 'No se puede eliminar vínculo con %s',
        'Can\'t update password, invalid characters!' => 'No se puede actualizar la contraseña, caracteres inválidos',
        'Can\'t update password, must be at least %s characters!' => 'No se puede actualizar la contraseña, se necesitan al menos %s caracteres',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' =>
            'No se puede actualizar la contraseña, se necesitan al menos 2 caracteres en minúsculas y 2 en mayúsculas.',
        'Can\'t update password, needs at least 1 digit!' => 'No se puede actualizar la contraseña, se necesita al menos 1 dígito.',
        'Can\'t update password, needs at least 2 characters!' => 'No se puede actualizar la contraseña, se necesitan al menos 2 caracteres.',
        'Can\'t update password, your new passwords do not match! Please try again!' =>
            'No se puede actualizar la contraseña, su nueva contraseña no coincide. Por favor reinténtelo.',
        'Category Tree' => 'Arbol de Categorías',
        'Cc: (%s) added database email' => 'Cc: (%s) añadido a la base de datos de correo electrónico',
        'Cc: (%s) added database email!' => '¡Cc: (%s) se agregó el correo electrónico registrado en la base de datos!',
        'Change %s settings' => 'Cambiar las configuraciones %s',
        'Change Times' => 'Cambio de Tiempo',
        'Change free text of ticket' => 'Cambiar el texto libre del ticket',
        'Change owner of ticket' => 'Cambiar el propietario del ticket',
        'Change priority of ticket' => 'Cambiar la prioridad del ticket',
        'Change responsible of ticket' => 'Cambiar responsable del ticket',
        'Change the ticket customer!' => 'Cambiar el cliente del ticket',
        'Change the ticket owner!' => 'Cambiar el propietario del ticket',
        'Change the ticket priority!' => 'Cambiar la prioridad del ticket',
        'Change the ticket responsible!' => 'Cambiar el responsable del ticket',
        'Change users <-> roles settings' => 'Modificar Configuración de Usuarios <-> Roles',
        'ChangeLog' => 'Log de Cambios',
        'Child-Object' => 'Objeto-Hijo',
        'City{CustomerUser}' => 'Ciudad',
        'Clear From' => 'Vaciar De',
        'Clear To' => 'Vaciar Para',
        'Click here to report a bug!' => 'Haga click aquí para informar de un error',
        'Close Times' => 'Tiempos de Cierre',
        'Close this ticket!' => 'Cerrar este ticket',
        'Close ticket' => 'Cerrar el ticket',
        'Close type' => 'Tipo de cierre',
        'Close!' => 'Cerrar',
        'Collapse View' => 'Vista reducida',
        'Comment (internal)' => 'Comentario (interno)',
        'Comment{CustomerUser}' => 'Comentario',
        'CompanyTickets' => 'TicketsCompañía',
        'Compose Answer' => 'Responder',
        'Compose Email' => 'Redactar Correo',
        'Compose Follow up' => 'Redactar seguimiento',
        'Config Options' => 'Opciones de Configuración',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opciones de configuración (ej. &lt;OTRS_CONFIG_HttpType&gt;)',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Opciones de configuración (ej: <OTRS_CONFIG_HttpType>)',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Opciones de configuración (ej. <OTRS_CONFIG_HttpType>).',
        'Configures a default TicketFreeField setting. "Counter" defines the free text field which should be used, "Key" is the TicketFreeKey, "Value" is the TicketFreeText and "Event" defines the trigger event.' =>
            'Define una configuración por defecto para los campos libres del ticket. "Contador" determina el campo libre de ticket que debe usarse, "Key" y "Valor" son, respectivamente, la llave y el texto de dicho campo; "Evento" es el disparador del evento.',
        'Configures a default TicketFreeField setting. "Counter" defines the free text field which should be used, "Key" is the TicketFreeKey, "Value" is the TicketFreeText and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Define una configuración por defecto para los campos libres del ticket. "Contador" determina el campo libre de ticket que debe usarse, "Key" y "Valor" son, respectivamente, la llave y el texto de dicho campo; "Evento" es el disparador del evento. Por favor, refiérase al capítulo "Módulo de Eventos de Ticket" del manual del desarrollador (http://doc.otrs.org/).',
        'Contact customer' => 'Contactar con el cliente',
        'Country{CustomerUser}' => 'País',
        'Create Times' => 'Tiempos de Creación',
        'Create and manage notifications that are sent to agents.' => 'Crear y gestionar notificaciones que se envían a agentes.',
        'Create new Phone Ticket' => 'Crear un nuevo Ticket Telefónico',
        'Create new database' => 'Crear nueva base de datos',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' =>
            'Crear nuevos grupos para manipular los permisos de acceso por distintos grupos de agente (ej: departamento de compra, departamento de soporte, departamento de ventas,...).',
        'Create your first Ticket' => 'Cree su primer ticket.',
        'Create/Expires' => 'Creación/Caducidad',
        'CreateTicket' => 'CrearTicket',
        'Customer Move Notify' => 'Notificar al Cliente al Mover',
        'Customer Owner Notify' => 'Notificar al Propietario al Mover',
        'Customer State Notify' => 'Notificación de estado al Cliente',
        'Customer User' => 'Cliente',
        'Customer User Management' => 'Administración de Clientes',
        'Customer Users' => 'Clientes',
        'Customer Users <-> Groups' => 'Clientes <-> Grupos',
        'Customer Users <-> Groups Management' => 'Administración de Clientes <-> Grupos',
        'Customer Users <-> Services' => 'Clientes <-> Servicios',
        'Customer Users <-> Services Management' => 'Administración de Clientes <-> Servicios',
        'Customer history' => 'Historia del cliente',
        'Customer history search' => 'Historia de búsquedas del cliente',
        'Customer history search (e. g. "ID342425").' => 'Historia de búsquedas del cliente (ej: "ID342425")',
        'Customer item (icon) which shows the open tickets of this customer as info block.' =>
            'Artículo del cliente (ícono) que muestra los tickets abiertos de dicho cliente como bloque de información.',
        'Customer user will be needed to have a customer history and to login via customer panel.' =>
            'El cliente se necesita para tener un historial e iniciar sesión a través del panel de clientes.',
        'CustomerID{CustomerUser}' => 'Identificador del cliente',
        'CustomerUser' => 'Cliente',
        'DB Admin Password' => 'Contraseña del Administrador de la BD',
        'DB Admin User' => 'Usuario Admin de la BD',
        'DB Type' => 'Tipo de BD',
        'DB connect host' => 'Host de conexión a la Base de datos',
        'Database Backend' => 'Base de Datos',
        'Days' => 'Días',
        'Default' => 'Por Defecto',
        'Default Charset' => 'Juego de caracteres por defecto',
        'Default Language' => 'Lenguaje por defecto',
        'Defines the =hHeight for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define la altura del editor de texto enriquecido. Proporcione un número (pixeles) o un porcentaje (relativo).',
        'Defines the default selection of the free key field number 1 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 1 para artículos (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 1 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 1 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 10 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 10 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 11 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 11 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 12 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 12 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 13 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 13 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 14 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 14 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 15 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 15 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 16 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 16 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 2 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 2 para artículos (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 2 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 2 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 3 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 3 para artículos (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 3 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 3 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 4 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 4 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 5 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 5 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 6 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 6 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 7 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 7 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 8 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 8 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free key field number 9 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre número 9 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 1 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 1 para artículos (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 1 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 1 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 10 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 10 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 11 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 11 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 12 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 12 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 13 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 13 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 14 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 14 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 15 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 15 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 16 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 16 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 2 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 2 para artículos (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 2 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 2 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 3 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 3 para artículos (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 3 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 3 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 4 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 4 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 5 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 5 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 6 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 6 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 7 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 7 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 8 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 8 para tickets (si es que hay más de una opción).',
        'Defines the default selection of the free text field number 9 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre número 9 para tickets (si es que hay más de una opción).',
        'Defines the default sort criteria for all queues displayed in the queue view, after sort by priority is done.' =>
            'Define el criterio de ordenamiento por defecto para todas las filas mostradas en la vista de filas, luego de haberse ordenado por prioridad.',
        'Defines the difference from now (in seconds) of the free time field number 1\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo número 1.',
        'Defines the difference from now (in seconds) of the free time field number 2\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo número 2.',
        'Defines the difference from now (in seconds) of the free time field number 3\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo número 3.',
        'Defines the difference from now (in seconds) of the free time field number 4\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo número 4.',
        'Defines the difference from now (in seconds) of the free time field number 5\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo número 5.',
        'Defines the difference from now (in seconds) of the free time field number 6\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo número 6.',
        'Defines the free key field number 1 for articles to add a new article attribute.' =>
            'Define el campo de llave libre número 1 de los artículos, para agregar un atributo de artículo nuevo.',
        'Defines the free key field number 1 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de llave libre número 1 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 10 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 10 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 11 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 11 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 12 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 12 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 13 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 13 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 14 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 14 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 15 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 15 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 16 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 16 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 2 for articles to add a new article attribute.' =>
            'Define el campo de llave libre número 2 de los artículos, para agregar un atributo de artículo nuevo.',
        'Defines the free key field number 2 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 2 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 3 for articles to add a new article attribute.' =>
            'Define el campo de llave libre número 3 de los artículos, para agregar un atributo de artículo nuevo.',
        'Defines the free key field number 3 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 3 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 4 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 4 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 5 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 5 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 6 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 6 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 7 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 7 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 8 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 8 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 9 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre número 9 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 1 for articles to add a new article attribute.' =>
            'Define el valor del campo de texto libre número 1 de los artículos, para agregar un atributo de artículo nuevo.',
        'Defines the free text field number 1 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 1 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 10 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 10 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 11 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 11 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 12 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 12 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 13 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 13 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 14 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 14 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 15 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 15 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 16 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 16 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 2 for articles to add a new article attribute.' =>
            'Define el valor del campo de texto libre número 2 de los artículos, para agregar un atributo de artículo nuevo.',
        'Defines the free text field number 2 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 2 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 3 for articles to add a new article attribute.' =>
            'Define el valor del campo de texto libre número 3 de los artículos, para agregar un atributo de artículo nuevo.',
        'Defines the free text field number 3 for ticket to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 3 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 4 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 4 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 5 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 5 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 6 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 6 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 7 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 7 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 8 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 8 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 9 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre número 9 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free time key field number 1 for tickets.' => 'Define el valor del campo de tiempo libre número 1 de los tickets.',
        'Defines the free time key field number 2 for tickets.' => 'Define el valor del campo de tiempo libre número 2 de los tickets.',
        'Defines the free time key field number 3 for tickets.' => 'Define el valor del campo de tiempo libre número 3 de los tickets.',
        'Defines the free time key field number 4 for tickets.' => 'Define el valor del campo de tiempo libre número 4 de los tickets.',
        'Defines the free time key field number 5 for tickets.' => 'Define el valor del campo de tiempo libre número 5 de los tickets.',
        'Defines the free time key field number 6 for tickets.' => 'Define el valor del campo de tiempo libre número 6 de los tickets.',
        'Defines the hours and week days of the calendar number 1, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 1.',
        'Defines the hours and week days of the calendar number 2, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 2.',
        'Defines the hours and week days of the calendar number 3, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 3.',
        'Defines the hours and week days of the calendar number 4, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 4.',
        'Defines the hours and week days of the calendar number 5, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 5.',
        'Defines the hours and week days of the calendar number 6, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 6.',
        'Defines the hours and week days of the calendar number 7, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 7.',
        'Defines the hours and week days of the calendar number 8, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 8.',
        'Defines the hours and week days of the calendar number 9, to count the working time.' =>
            'Define las horas y los días laborales de la semana, para el calendario número 9.',
        'Defines the http link for the free text field number 1 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 1 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 10 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 10 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 11 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 11 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 12 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 12 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 13 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 13 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 14 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 14 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 15 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 15 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 16 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 16 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 2 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 2 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 3 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 3 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 4 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 4 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 5 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 5 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 6 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 6 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 7 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 7 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 8 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 8 (se usará en cada vista de ticket).',
        'Defines the http link for the free text field number 9 for tickets (it will be used in every ticket view).' =>
            'Define el vínculo http para el campo de texto libre de ticket número 9 (se usará en cada vista de ticket).',
        'Defines the list of online repositories. Another installations can be used as repositoriy, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Define la lista de repositorios en línea. Otras instalaciones pueden usarse como repositorio, por ejemplo: Llave="http://example.com/otrs/public.pl?Action=PublicRepository;File=" y Contenido="Algun Nombre".',
        'Defines the name of the calendar number 1.' => 'Define el nombre del calendario número 1.',
        'Defines the name of the calendar number 2.' => 'Define el nombre del calendario número 2.',
        'Defines the name of the calendar number 3.' => 'Define el nombre del calendario número 3.',
        'Defines the name of the calendar number 4.' => 'Define el nombre del calendario número 4.',
        'Defines the name of the calendar number 5.' => 'Define el nombre del calendario número 5.',
        'Defines the name of the calendar number 6.' => 'Define el nombre del calendario número 6.',
        'Defines the name of the calendar number 7.' => 'Define el nombre del calendario número 7.',
        'Defines the name of the calendar number 8.' => 'Define el nombre del calendario número 8.',
        'Defines the name of the calendar number 9.' => 'Define el nombre del calendario número 9.',
        'Defines the time zone of the calendar number 1, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 1, que luego puede asignarse a una fila específica.',
        'Defines the time zone of the calendar number 2, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 2, que luego puede asignarse a una fila específica.',
        'Defines the time zone of the calendar number 3, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 3, que luego puede asignarse a una fila específica.',
        'Defines the time zone of the calendar number 4, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 4, que luego puede asignarse a una fila específica.',
        'Defines the time zone of the calendar number 5, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 5, que luego puede asignarse a una fila específica.',
        'Defines the time zone of the calendar number 6, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 6, que luego puede asignarse a una fila específica.',
        'Defines the time zone of the calendar number 7, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 7, que luego puede asignarse a una fila específica.',
        'Defines the time zone of the calendar number 8, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 8, que luego puede asignarse a una fila específica.',
        'Defines the time zone of the calendar number 9, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario número 9, que luego puede asignarse a una fila específica.',
        'Defines the years (in future and in past) which can get selected in free time field number 1.' =>
            'Define los años (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo número 1.',
        'Defines the years (in future and in past) which can get selected in free time field number 2.' =>
            'Define los años (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo número 2.',
        'Defines the years (in future and in past) which can get selected in free time field number 3.' =>
            'Define los años (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo número 3.',
        'Defines the years (in future and in past) which can get selected in free time field number 4.' =>
            'Define los años (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo número 4.',
        'Defines the years (in future and in past) which can get selected in free time field number 5.' =>
            'Define los años (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo número 5.',
        'Defines the years (in future and in past) which can get selected in free time field number 6.' =>
            'Define los años (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo número 6.',
        'Defines whether the free time field number 1 is optional or not.' =>
            'Define si el campo libre de tiempo número 1 es opcional o no.',
        'Defines whether the free time field number 2 is optional or not.' =>
            'Define si el campo libre de tiempo número 2 es opcional o no.',
        'Defines whether the free time field number 3 is optional or not.' =>
            'Define si el campo libre de tiempo número 3 es opcional o no.',
        'Defines whether the free time field number 4 is optional or not.' =>
            'Define si el campo libre de tiempo número 4 es opcional o no.',
        'Defines whether the free time field number 5 is optional or not.' =>
            'Define si el campo libre de tiempo número 5 es opcional o no.',
        'Defines whether the free time field number 6 is optional or not.' =>
            'Define si el campo libre de tiempo número 6 es opcional o no.',
        'Delay time between autocomplete queries.' => 'Tiempo de retrazo entre consultas de autocompletado.',
        'Delete old database' => 'Eliminar BD antigua',
        'Delete this ticket!' => 'Eliminar este ticket',
        'Detail' => 'Detalle',
        'Determines if the statatistics module may generate ticket lists.' =>
            'Determina si el módulo de estadísticas debe generar listas de tickets.',
        'Discard all changes and return to the compose screen' => 'Descartar todos los cambios y volver a la pantalla de redacción',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' =>
            'Clasificar o filtrar correos entrantes basado en encabezamientos X-Headers! Puede utilizar expresiones regulares.',
        'Do you really want to delete this Object?' => 'Seguro que desea eliminar este objeto?',
        'Do you really want to reinstall this package (all manual changes get lost)?' =>
            'Realmente desea reinstalar este paquete (todos los cambios manuales se perderán)?',
        'Don\'t forget to add a new response a queue!' => 'No olvide incluir una nueva respuesta en la fila',
        'Don\'t forget to add a new user to groups and/or roles!' => 'No olvide añadir los nuevos usuarios a grupos y/o roles',
        'Don\'t forget to add a new user to groups!' => 'No olvide incluir un nuevo usuario a los grupos',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'No trabaje con el usuario 1 (cuenta del sistema). Cree usuarios nuevos.',
        'Download Settings' => 'Descargar Configuración',
        'Download all system config changes.' => 'Descargar todos los cambios de configuración',
        'Drop Database' => 'Eliminar Base de Datos',
        'Dynamic-Object' => 'Objeto-Dinámico',
        'Edit Article' => 'Editar Artículo',
        'Edit default services.' => 'Modificar los servicios por defecto.',
        'Email based' => 'Basado en e-mail',
        'Email{CustomerUser}' => 'Correo electrónico',
        'Escaladed Tickets' => 'Tickets Escalados',
        'Escalation - First Response Time' => 'Escalado - Tiempo Primer Respuesta',
        'Escalation - Solution Time' => 'Escalado - Tiempo Solución',
        'Escalation - Update Time' => 'Escalado - Tiempo Actualización',
        'Escalation Times' => 'Tiempos de escalado',
        'Escalation time' => 'Tiempo de escalado',
        'Event is required!' => 'Debe especificar Evento',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all TicketFreeField elements need the same event.' =>
            'Registro de módulo de evento. Para aumentar el desempeño, puede definirse un disparador de evento (Por ejemplo: Evento => TicketCreate). Esto es posible sólo si todos los campos libres de ticket requieren el mismo evento.',
        'Expand View' => 'Vista ampliada',
        'Explanation' => 'Explicación',
        'Export Config' => 'Exportar Configuración',
        'Fax{CustomerUser}' => 'Fax',
        'FileManager' => 'Administrador de Archivos',
        'Filelist' => 'Lista de Archivos',
        'Filter for Language' => 'Filtro para Lenguaje',
        'Filtername' => 'Nombre del filtro',
        'Firstname{CustomerUser}' => 'Nombre',
        'Follow up' => 'Seguimiento',
        'Follow up notification' => 'Notificación de seguimiento',
        'For more info see:' => 'Para mas información vea:',
        'For very complex stats it is possible to include a hardcoded file.' =>
            'Para una estadística muy compleja es posible incluir un archivo preconfigurado',
        'Forward ticket: ' => 'Reenviar ticket',
        'Frontend' => 'Interfaz de usuario',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Búsqueda de texto en Artículo (ej. "Mar*in" o "Baue*")',
        'Go' => 'Ir',
        'Go to group %s' => 'Ir al grupo %s',
        'Group %s' => 'Grupo %s',
        'Group Ro' => 'Grupo Ro',
        'Group based' => 'Basado en grupo',
        'Group selection' => 'Selección de Grupo',
        'Hash/Fingerprint' => 'Hash/Huella digital',
        'Have a lot of fun!' => 'Disfrútelo!',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Aquí puede definir la serie de valores. Tiene la posibilidad de seleccionar uno o más elementos. Luego, puede seleccionar los atributos de los elementos. Cada atributo será mostrado como un elemento de la serie. Si no selecciona ningún atributo, todos los atributos del elemento serán utilizados si genera una estadística. Asimismo un nuevo atributo es añadido desde la última configuración.',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection, all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Aquí Ud. puede definir el eje x. Puede seleccionar un elemento con un boton circular (radio button). Si no selecciona un atributo, todos los atributos del elemento serán usados si genera una estadística, apenas se agrega un nuevo atributo desde la útima configuración',
        'Here you can define the x-axis. You can select one element via the radio button. Then you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Aqui puede definir el eje-x. Puede seleccionar un elemento usando la casilla de selección. Luego debe seleccionar dos o más atributos del elemento. Si Ud. no selecciona ninguno, todos los atributos del elemento se utilizarán para generar una estadística. Asimismo un nuevo atributo es añadido desde la última configuración.',
        'Here you can insert a description of the stat.' => 'Aquí puede insertar una descripción de la estadística.',
        'Here you can select the dynamic object you want to use.' => 'Aquí puede seleccionar el elemento dinámico que desea utilizar',
        'Home' => 'Inicio',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si el Modo Seguro no está activado actívelo con SysConfig ya que su aplicación está en funcionamiento.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' =>
            'Si un nuevo archivo preconfigurado está disponible, este atributo se le mostrará y podrá seleccionar uno',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' =>
            'Si el ticket está cerrado y el cliente envía un seguimiento al mismo, éste será bloqueado para el antiguo propietario',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' =>
            'Si un ticket no ha sido respondido es este tiempo, sólo este ticket se mostrará',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' =>
            'Si un agente bloquea un ticket y no envía una respuesta en este tiempo, el ticket será desbloqueado automáticamente. El Ticket será visible por todos los demás agentes.',
        'If configured, all emails sent by the application will contain an X-Header with this organization or company name.' =>
            'Si se configura, todos los correos electrónicos enviados por la aplicación contendrán una Cabecera-X con el nombre de compañía que se especique aquí.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' =>
            'Si no se selecciona algo, no habrá permisos en este grupo (los tickets no estarán disponibles para el cliente).',
        'If set, this address is used as envelope from header in outgoing notifications. If no address is specified, the envelope from header is empty.' =>
            'Si se define, esta dirección se usa como sobre para el encabezado de las notificaciones salientes.',
        'If you need the sum of every column select yes.' => 'Si necesita las suma de cada columna seleccione Sí',
        'If you need the sum of every row select yes' => 'Si necesita la suma de cada fila seleccione Sí',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' =>
            'Si utiliza expresiones regulares, puede también usar el valor encontrado en () as [***] en \'Set\'.',
        'If you want to account time, please provide Subject and Text!' =>
            'Si desea contabilizar el tiempo, porfavor ingrese Sujeto y Texto',
        'Image' => 'Imagen',
        'Important' => 'Importante',
        'In this form you can select the basic specifications.' => 'En esta pantalla puede seleccionar las especificaciones básicas',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' =>
            'De esta forma, Ud. puede editar directamente las claves configuradas en Kernel/Config.pm.',
        'Incident' => 'Incidente',
        'Information about the Stat' => 'Información sobre la estadística',
        'Insert of the common specifications' => 'Inserte las especificaciones comunes',
        'Is Job Valid' => 'La tarea es válida',
        'Is Job Valid?' => '¿La tarea es válida?',
        'It\'s useful for ASP solutions.' => 'Esto es útil para soluciones ASP.',
        'It\'s useful for a lot of users and groups.' => 'Es útil para gestionar muchos usuarios y grupos.',
        'Job-List' => 'Lista de Tareas',
        'Keyword' => 'Palabra clave',
        'Keywords' => 'Palabras clave',
        'Last update' => 'Ultima Actualización',
        'Lastname{CustomerUser}' => 'Apellido',
        'Link this ticket to an other objects!' => 'Enlazar este ticket a otros objetos',
        'Link this ticket to other objects!' => '¡Vincular este ticket con otros objetos!',
        'Link to Parent' => 'Enlazar con el padre',
        'Linked as' => 'Vinculado como',
        'List of IE7-specific CSS files to always be loaded for the agent interface.' =>
            'Lista de archivos CSS específicos para IE7 que siempre se cargarán para la interfaz del agente.',
        'Load Settings' => 'Cargar Configuración',
        'Lock it to work on it!' => 'Bloquearlo para trabajar en él',
        'Logfile' => 'Archivo de log',
        'Logfile too large, you need to reset it!' => 'Archivo de log muy grande, necesita reinicializarlo',
        'Login failed! Your username or password was entered incorrectly.' =>
            'Inicio de sesión fallido. El nombre de usuario o contraseña fue introducido incorrectamente.',
        'Lookup' => 'Observar',
        'Mail Management' => 'Administración de Correo',
        'Mailbox' => 'Buzón',
        'Match' => 'Coincidir',
        'Max. displayed tickets' => 'Número máximo de tickets mostrados.',
        'Max. shown Tickets a page' => 'Número máximo de tickets mostrados por página',
        'Maximum size (in characters) of the customer info table in the queue view.' =>
            'Número máximo (en caracteres) de la tabla de información del cliente en la vista de filas.',
        'Merge this ticket!' => 'Fusionar este ticket',
        'Message for new Owner' => 'Mensaje para el nuevo propietario',
        'Message sent to' => 'Mensaje enviado a',
        'Misc' => 'Misceláneo',
        'Mobile{CustomerUser}' => 'Móvil',
        'Modified' => 'Modificado',
        'Module to inform agents, via the agent interface, about the used charset. A notification is displayed, if the default charset is not used, e.g. in tickets.' =>
            'Módulo para informar a los agentes, a través de su propia interfaz, acerca del juego de caracteres usado. Se despliega una notificación en caso de que no se esté usando el juego de caracteres por defecto en, por ejemplo, los tickets.',
        'Modules' => 'Módulos',
        'Move notification' => 'Notificación de movimientos',
        'Multiple selection of the output format.' => 'Selección múltiple del formato de salida',
        'MyTickets' => 'MisTickets',
        'Name is required!' => 'Debe especificar Nombre',
        'New Agent' => 'Agente nuevo',
        'New Customer' => 'Cliente nuevo',
        'New Group' => 'Nuevo grupo',
        'New Group Ro' => 'Nuevo Grupo Ro',
        'New Priority' => 'Prioridad nueva',
        'New SLA' => 'SLA nuevo',
        'New Service' => 'Servicio nuevo',
        'New State' => 'Estado nuevo',
        'New Ticket Lock' => 'Bloqueo de ticket nuevo',
        'New TicketFreeFields' => 'CamposLibresDeTicket nuevos',
        'New Title' => 'Título nuevo',
        'New Type' => 'Tipo nuevo',
        'New account created. Sent Login-Account to %s.' => 'Cuenta nueva creada. Cuenta de inicio de sesión enviada a %s.',
        'New messages' => 'Nuevos mensajes',
        'New password again' => 'Repetir Contraseña',
        'Next Week' => 'Próxima semana',
        'No * possible!' => 'No * posible!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' =>
            'No hay paquetes para el Framework solicitado en este Repositorio en Línea, pero hay paquetes para otros Frameworks',
        'No Packages or no new Packages in selected Online Repository!' =>
            'No hay paquetes o no hay paquetes nuevos en el Repositorio en Línea seleccionado',
        'No Permission' => 'No tiene autorización',
        'No means, send agent and customer notifications on changes.' => '"No" significa enviar a los agentes y clientes notificaciones al realizar cambios.',
        'No time settings.' => 'Sin especificación de tiempo',
        'Note Text' => 'Nota!',
        'Notification (Customer)' => 'Notificación (Cliente)',
        'Notifications' => 'Notificaciones',
        'OTRS DB Name' => 'Nombre de la BD OTRS',
        'OTRS DB Password' => 'Contraseña para BD del usuario OTRS',
        'OTRS DB User' => 'Usuario de BD OTRS',
        'OTRS sends an notification email to the customer if the ticket is moved.' =>
            'OTRS envía una notificación por correo al cliente si el ticket se mueve',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' =>
            'OTRS envía una notificación por correo al cliente si el propietario del ticket cambia',
        'OTRS sends an notification email to the customer if the ticket state has changed.' =>
            'OTRS envía una notificación por correo al cliente si el estado del ticket cambia',
        'Object already linked as %s.' => 'Objecto ya vinculado como %s.',
        'Of couse this feature will take some system performance it self!' =>
            'De acuerdo a esta característica se efectuarán ciertas mejoras en el sistema por sí mismo.',
        'Online' => 'En línea',
        'Only for ArticleCreate Event.' => 'Solo para el Evento CrearArtículo',
        'Open Tickets' => 'Tickets Abiertos',
        'Options ' => 'Opciones',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' =>
            'Opciones de los datos del cliente activo (ej. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' =>
            'Opciones del usuario activo  (ej. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' =>
            'Opciones de los datos del cliente actual (ej. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' =>
            'Opciones del usuario que solicitó la acción (ej. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' =>
            'Opciones del usuario activo que solicitó esta acción (ej. <OTRS_CURRENT_UserFirstname>)',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' =>
            'Opciones del usuario actual que solicitó ésta acción (ej. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' =>
            'Opcciones de los datos del ticket (ej. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Opciones de la información del ticket (ej: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Opciones de la información del ticket (ej. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' =>
            'Opciones de los datos del Ticket (ej. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Other Options' => 'Otras Opciones',
        'Out Of Office' => 'Fuera de la oficina',
        'POP3 Account Management' => 'Administración de cuenta POP3',
        'Package' => 'Paquete',
        'Package not correctly deployed! You should reinstall the Package again!' =>
            'Paquete instalado incorrectamente. Debe reinstalar el paquete.',
        'Package not correctly deployed! You should reinstall the package again!' =>
            '¡El paquete no se instaló correctamente, necesita instalarlo nuevamente!',
        'Package not correctly deployed, you need to deploy it again!' =>
            'El paquete no ha sido correctamente instalado, necesita instalarlo nuevamente!',
        'Package verification failed' => 'Falló la verificación del paquete',
        'Package verification failed!' => '¡La verificación del paquete falló!',
        'Param 1' => 'Parámetro 1',
        'Param 2' => 'Parámetro 2',
        'Param 3' => 'Parámetro 3',
        'Param 4' => 'Parámetro 4',
        'Param 5' => 'Parámetro 5',
        'Param 6' => 'Parámetro 6',
        'Parent-Object' => 'Objeto-Padre',
        'Password is already in use! Please use an other password!' => 'La contraseña ya se está utilizando. Por favor, utilice otra.',
        'Password is already used! Please use an other password!' => 'La contraseña ya fue usada. Por favor, utilice otra.',
        'Passwords doesn\'t match! Please try it again!' => 'Las contraseñas no coinciden. Por favor, intente nuevamente.',
        'Pending Times' => 'Tiempos en espera',
        'Pending messages' => 'Mensajes pendientes',
        'Pending type' => 'Tipo pendiente',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' =>
            'Configuración de permisos. Puede seleccionar uno o más grupos para hacer visibles las estadísticas configuradas a distintos agentes',
        'Permissions to change the ticket owner in this group/queue.' => 'Permiso para cambiar el propietario del ticket en este grupo/fila',
        'PhoneView' => 'Vista telefónica',
        'Phone{CustomerUser}' => 'Teléfono',
        'Please contact your admin' => 'Por favor, contacte a su administrador.',
        'Please fill out this form to recieve login credentials.' => 'Por favor, llene este formulario para recibir las credenciales de inicio de sesión.',
        'PostMaster Filter' => 'Filtro del Administrador del Correo',
        'PostMaster Mail Account' => 'Cuenta del Administrador del Correo',
        'Print this ticket!' => 'Imprimir este ticket',
        'Prio' => 'Prio',
        'Problem' => 'Problema',
        'Queue <-> Auto Responses Management' => 'Administración de Fila <-> Respuestas Automáticas',
        'Queue ID' => 'Id de la Fila',
        'Queue Management' => 'Administración de Filas',
        'QueueView Refresh Time' => 'Tiempo de Actualización de la Vista de Filas',
        'Realname' => 'Nombre real',
        'Rebuild' => 'Reconstruir',
        'Recipients' => 'Destinatarios',
        'Reminder' => 'Recordatorio',
        'Reminder messages' => 'Mensajes recordatorios',
        'Required Field' => 'Campos obligatorios',
        'Response Management' => 'Administración de Respuestas',
        'Responses <-> Attachments Management' => 'Administración de Respuestas <-> Anexos',
        'Responses <-> Queue Management' => 'Administración de Respuestas <-> Filas',
        'Return to the compose screen' => 'Volver a la pantalla de redacción',
        'Role' => 'Rol',
        'Roles <-> Groups Management' => 'Administración de Roles <-> Grupos',
        'Roles <-> Users' => 'Roles <-> Usuarios',
        'Roles <-> Users Management' => 'Administración de Roles <-> Usuarios',
        'Run Search' => 'Realizar búsqueda',
        'Save Job as?' => '¿Guardar Tarea como?',
        'Save Search-Profile as Template?' => 'Guardar perfil de búsqueda como patrón?',
        'Schedule' => 'Horario',
        'Search Result' => 'Buscar resultados',
        'Search Ticket' => 'Buscar Ticket',
        'Search for' => 'Buscar por',
        'Search for customers (wildcards are allowed).' => 'Buscar clientes (se permite el uso de comodines).',
        'Search-Profile as Template?' => '¿Definir perfil de búsqueda como Platilla?',
        'Secure Mode need to be enabled!' => '¡El Modo Seguro debe estar habilitado!',
        'Select Box' => 'Ventana de selección',
        'Select Box Result' => 'Seleccione tipo de resultado',
        'Select Source (for add)' => 'Seleccionar Fuente (para añadir)',
        'Select the customeruser:service relations.' => 'Seleccione las relaciones cliente:servicio.',
        'Select the element, which will be used at the X-axis' => 'Seleccione el elemento, que será utilizado en el eje-X',
        'Select the restrictions to characterise the stat' => 'Seleccione las restricciones para caracterizar la estadística',
        'Select the role:user relations.' => 'Seleccionar las relaciones Rol-Cliente',
        'Select the user:group permissions.' => 'Seleccionar los permisos del usuario:grupo',
        'Select your QueueView refresh time.' => 'Seleccione su tiempo de actualización de la vista de filas.',
        'Select your default spelling dictionary.' => 'Seleccione su diccionario por defecto.',
        'Select your frontend Charset.' => 'Seleccione su juego de caracteres.',
        'Select your frontend QueueView.' => 'Seleccione su Vista de Filas.',
        'Select your frontend language.' => 'Seleccione su idioma de trabajo.',
        'Select your out of office time.' => 'Elija el tiempo fuera de la oficina.',
        'Select your screen after creating a new ticket.' => 'Seleccione la pantalla a mostrar después de crear un ticket',
        'Selection needed' => 'Selección obligatoria',
        'Send Administrative Message to Agents' => 'Enviar Mensaje Administrativo a los Agentes',
        'Send Notification' => 'Enviar Notificación',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' =>
            'Notifíqueme si un cliente solicita un seguimiento y yo soy el dueño del ticket.',
        'Send me a notification of an watched ticket like an owner of an ticket.' =>
            'Enviarme notificación de un ticket vigilado como si fuera un ticket del que soy dueño.',
        'Send no notifications' => 'No enviar notificaciones',
        'Sent new password to: %s' => 'Contraseña nueva enviada a: %s',
        'Sent password token to: %s' => 'Información de contraseña enviada a: %s',
        'Sessions' => 'Sesiones',
        'Set customer user and customer id of a ticket' => 'Asignar agente y cliente de un ticket',
        'Set this ticket to pending!' => 'Poner este ticket como pendiente',
        'Sets the default charset for the web interface to use (should represent the charset used to create the database or, in some cases, the database management system being used). "utf-8" is a good choice for environments expecting many charsets. You can specify another charset here (i.e. "iso-8859-1"). Please be sure that you will not be receiving foreign emails, or text, otherwise this could lead to problems.' =>
            'Define el juego de caracteres por defecto para la interfaz web (debería ser el mismo juego de caracteres que se usó al crear la base de datos o, en algunos casos, el que utilice el manejador de base de datos del sistema). "utf-8" es una buena elección para ambientes que esperan varios juegos de caracteres, sin embargo, es posible especificar uno diferente (por ejemplo: "iso-8859-1"). Por favor, asegúrese de que no recibirá correos o texto extranjeros, ya que esto podría causar problemas.',
        'Sets the number of lines that are displayed in the preview of messages (e.g. for tickets in the QueueView).' =>
            'Define el número de líneas mostradas en la vista previa de los mensajes (por ejemplo: para los tickets en la vista de filas).',
        'Show' => 'Mostrar',
        'Shows the ticket history!' => 'Mostrar la historia del ticket',
        'Site' => 'Sitio',
        'Solution' => 'Solución',
        'Sort by' => 'Ordenado por',
        'Source' => 'Origen',
        'Spell Check' => 'Chequeo Ortográfico',
        'Split' => 'Dividir',
        'State Type' => 'Tipo de Estado',
        'Static-File' => 'Archivo-Estático',
        'Stats-Area' => 'Area de Estadísticas',
        'Street{CustomerUser}' => 'Calle',
        'Sub-Queue of' => 'Subfila de',
        'Sub-Service of' => 'Sub-Servicio de',
        'Subscribe' => 'Subscribir',
        'Symptom' => 'Síntoma',
        'System History' => 'Historia del Sistema',
        'System State Management' => 'Administración de Estados del Sistema',
        'System Status' => 'Estado del Sistema',
        'Systemaddress' => 'Direcciones de correo del sistema',
        'Take care that you also updated the default states in you Kernel/Config.pm!' =>
            'Recuerde también actualizar los estados en su archivo Kernel/Config.pm! ',
        'The Ticket was locked' => 'El Ticket ha sido bloqueado',
        'The User Name you wish to have' => 'El Nombre de Usuario que desea tener',
        'The logo shown in the header of the agent interface. The URL to the image must be a relative URL to the skin image directory.' =>
            'El logo mostrado en el encabezado de la interfaz del agente. La URL a la imagen tiene que ser relativa a la URL del directorio de imágenes de piel.',
        'The logo shown in the header of the customer interface. The URL to the image must be a relative URL to the skin image directory.' =>
            'El logo mostrado en el encabezado de la interfaz del cliente. La URL a la imagen tiene que ser relativa a la URL del directorio de imágenes de piel.',
        'The message being composed has been closed.  Exiting.' => 'El mensaje que se estaba redactando ha sido cerrado. Saliendo...',
        'These values are read-only.' => 'Estos valores son de sólo-lectura.',
        'These values are required.' => 'Estos valores son obligatorios.',
        'This account exists.' => 'Esta cuenta existe.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' =>
            'Esto es útil si desea que nadie pueda obtener el resultado de una estadística o la misma aún no está configurada',
        'This values are read only.' => 'Estos valores son de sólo lectura.',
        'This values are required.' => 'Estos valores son necesarios.',
        'This window must be called from compose window' => 'Esta ventana debe ser llamada desde la ventana de redacción',
        'Ticket Lock' => 'Ticket Bloqueado',
        'Ticket Number Generator' => 'Generador de números de Tickets',
        'Ticket Search' => 'Buscar ticket',
        'Ticket Status View' => 'Ver Estado del Ticket',
        'Ticket Type is required!' => 'Se necesita el tipo de Ticket',
        'Ticket escalation!' => 'Escalado de ticket',
        'Ticket free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para cerrar un ticket de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de ticket de correo electrónico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the move ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para mover un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de ticket telefónico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de redacción de artículos, en la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para reenviar un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de campos libres de ticket de la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para crear un mensaje ticket nuevo, en la interfaz del cliente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para agregar una nota al ticket, en la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket owner screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para cambiar el propietario de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket pending screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de ticket pendiente de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de llamada telefónica saliente de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket priority screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para cambiar la prioridad de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para cambiar el responsable de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para buscar tickets de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket search screen in the customer interface. Possible settings: 0 = Disabled and 1 = Enabled.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para buscar tickets de la interfaz del cliente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para cerrar un ticket de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de ticket de correo electrónico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the move ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para mover un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de ticket telefónico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de redacción de artículos, en la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para reenviar un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de campos libres de ticket de la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para crear un mensaje ticket nuevo, en la interfaz del cliente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para agregar una nota al ticket, en la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket owner screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para cambiar el propietario de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket pending screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de ticket pendiente de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de llamada telefónica saliente de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket priority screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para cambiar la prioridad de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para cambiar el responsable de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para buscar tickets de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket search screen in the customer interface. Possible settings: 0 = Disabled and 1 = Enabled.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para buscar tickets de la interfaz del cliente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket locked!' => 'Ticket bloqueado',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' =>
            'Opciones del propietario del Ticket (ej. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Opciones del propietario del ticket (ej. <OTRS_OWNER_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Opciones del propietario del Ticket (ej. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' =>
            'Opciones del responsable del Ticket (ej. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Ticket selected for bulk action!' => 'Ticket seleccionado para acción múltiple!',
        'Ticket unlock!' => 'Ticket desbloqueado',
        'Ticket-Area' => 'Área-Ticket',
        'TicketFreeFields' => 'CamposLibresDeTicket',
        'TicketFreeText' => 'TextoLibreTicket',
        'TicketID' => 'Identificador de Ticket',
        'TicketZoom' => 'Detalle del Ticket',
        'Tickets available' => 'Tickets disponibles',
        'Tickets shown' => 'Tickets mostrados',
        'Tickets which need to be answered!' => 'Tickets que necesitan ser respondidos',
        'Time1' => 'Tiempo1',
        'Time2' => 'Tiempo2',
        'Time3' => 'Tiempo3',
        'Time4' => 'Tiempo4',
        'Time5' => 'Tiempo5',
        'Time6' => 'Tiempo6',
        'Times' => 'Veces',
        'Title of the stat.' => 'Título de la estadística',
        'Title{CustomerUser}' => 'Saludo',
        'Title{user}' => 'Título',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' =>
            'Para obtener los atributos (ej. <OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' =>
            'Para obtener el atributo del artículo (ej. <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> y <OTRS_CUSTOMER_Body>).',
        'To: (%s) replaced with database email' => 'Para: (%s) sustituido con el correo electrónico de la base de datos',
        'To: (%s) replaced with database email!' => '¡Para: (%s) se reemplazó con el correo electrónico registrado en la base de datos!',
        'Top of Page' => 'Inicio de página',
        'Total hits' => 'Total de coincidencias',
        'U' => 'A',
        'Unable to parse Online Repository index document!' => 'Incapaz de interpretar el documento índice del Repositorio en Línea',
        'Uniq' => 'Único',
        'Unlock Tickets' => 'Desbloquear Tickets',
        'Unlock to give it back to the queue!' => 'Desbloquear para regresarlo a la fila',
        'Unsubscribe' => 'Desubscribir',
        'Use utf-8 it your database supports it!' => 'Use utf-8 si su base de datos lo permite!',
        'Useable options' => 'Opciones disponibles',
        'User Management' => 'Administración de usuarios',
        'User will be needed to handle tickets.' => 'Se necesita un usuario para manipular los tickets.',
        'Username{CustomerUser}' => 'Nombre de Usuario',
        'Users' => 'Usuarios',
        'Users <-> Groups' => 'Usuarios <-> Grupos',
        'Users <-> Groups Management' => 'Administración de Usuarios <-> Grupos',
        'Warning! This tickets will be removed from the database! This tickets are lost!' =>
            'Advertencia: Estos tickets se eliminarán de la base de datos y serán inaccesibles',
        'Watch notification' => 'Vigilar notificación',
        'Web-Installer' => 'Instalador Web',
        'WebMail' => 'CorreoWeb',
        'WebWatcher' => 'ObservadorWeb',
        'Welcome to OTRS' => 'Bienvenido a OTRS',
        'Wildcards are allowed.' => 'Se permite el uso de comodines.',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Con una estadistica inválida, no es posible generar estadísticas.',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' =>
            'Con los campos de entrada y selección, puede configurar las estadísticas a sus necesidades. Los elementos de estadísticas que puede editar dependen de cómo haya sido configurado por el administrador',
        'Yes means, send no agent and customer notifications on changes.' =>
            '"Sí" significa no enviar notificación a los agentes y clientes al realizarse cambios.',
        'Yes, save it with name' => 'Sí, guardarlo con nombre',
        'You got new message!' => 'Tiene un mensaje nuevo.',
        'You have not created a ticket yet.' => 'Usted aún no ha creado tickets.',
        'You have to select two or more attributes from the select field!' =>
            'Debe seleccionar dos o más atributos del campo seleccionado',
        'You need a email address (e. g. customer@example.com) in To:!' =>
            'Necesita una dirección de correo (ej: cliente@ejemplo.com) en Para:!',
        'You need min. one selected Ticket!' => 'Necesita al menos seleccionar un Ticket!',
        'You need to account time!' => 'Necesita contabilizar el tiempo',
        'You need to activate %s first to use it!' => 'Necesita activar %s primero para utilizarlo.',
        'Your email address is new' => 'Su dirección de correo es nueva',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Su correo con número de ticket "<OTRS_TICKET>"  fue rebotado a "<OTRS_BOUNCE_TO>". Contacte con dicha dirección para más información.',
        'Your own Ticket' => 'Sus tickets',
        'Zip{CustomerUser}' => 'Código Postal',
        'accept license' => 'aceptar licencia',
        'customer realname' => 'Nombre del cliente',
        'don\'t accept license' => 'no aceptar la licencia',
        'down' => 'abajo',
        'false' => 'falso',
        'for agent firstname' => 'nombre del agente',
        'for agent lastname' => 'apellido del agente',
        'for agent login' => 'login del agente',
        'for agent user id' => 'id del agente',
        'kill all sessions' => 'finalizar todas las sesiones',
        'kill session' => 'finalizar la sesión',
        'maximal period form' => 'periodo máximo del formulario',
        'modified' => 'modificado',
        'new ticket' => 'nuevo ticket',
        'next step' => 'próximo paso',
        'send' => 'enviar',
        'sort downward' => 'ordenar descendente',
        'sort upward' => 'ordenar ascendente',
        'to get the first 20 character of the subject' => 'para obtener los primeros 20 caracteres del asunto ',
        'to get the first 5 lines of the email' => 'para obtener las primeras 5 líneas del correo',
        'to get the from line of the email' => 'para obtener la línea Para del correo',
        'to get the realname of the sender (if given)' => 'para obtener el nombre del emisor (si lo proporcionó)',
        'up' => 'arriba',
        'utf8' => 'utf8',
        'x' => 'x',

    };
    # $$STOP$$
    return;
}

1;
