# --
# Kernel/Language/es_CO.pm - provides Spanish language translation for Colombia
# Copyright (C) 2013 John Edisson Ortiz Roman <jortiz@slabinfo.com.co>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es_CO;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-08-20 14:43:47

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
        'Yes' => 'S√≠',
        'No' => 'No',
        'yes' => 's√≠',
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
        'more than ... ago' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Today' => 'Hoy',
        'Tomorrow' => 'Ma√±ana',
        'Next week' => 'Semana siguiente',
        'day' => 'd√≠a',
        'days' => 'd√≠as',
        'day(s)' => 'd√≠a(s)',
        'd' => 'd',
        'hour' => 'hora',
        'hours' => 'horas',
        'hour(s)' => 'hora(s)',
        'Hours' => 'Horas',
        'h' => 'h',
        'minute' => 'minuto',
        'minutes' => 'minutos',
        'minute(s)' => 'minuto(s)',
        'Minutes' => 'Minutos',
        'm' => 'm',
        'month' => 'mes',
        'months' => 'meses',
        'month(s)' => 'mes(es)',
        'week' => 'semana',
        'week(s)' => 'semana(s)',
        'year' => 'a√±o',
        'years' => 'a√±os',
        'year(s)' => 'a√±o(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
        's' => 's',
        'Time unit' => '',
        'wrote' => 'escribi√≥',
        'Message' => 'Mensaje',
        'Error' => 'Error',
        'Bug Report' => 'Informe de errores',
        'Attention' => 'Atenci√≥n',
        'Warning' => 'Advertencia',
        'Module' => 'M√≥dulo',
        'Modulefile' => 'Archivo de m√≥dulo',
        'Subfunction' => 'Subfunci√≥n',
        'Line' => 'L√≠nea',
        'Setting' => 'Configuraci√≥n',
        'Settings' => 'Configuraciones',
        'Example' => 'Ejemplo',
        'Examples' => 'Ejemplos',
        'valid' => 'v√°lido',
        'Valid' => 'V√°lido',
        'invalid' => 'inv√°lido',
        'Invalid' => 'Inv√°lido',
        '* invalid' => '* inv√°lido',
        'invalid-temporarily' => 'temporalmente-inv√°lido',
        ' 2 minutes' => ' 2 minutos',
        ' 5 minutes' => ' 5 minutos',
        ' 7 minutes' => ' 7 minutos',
        '10 minutes' => '10 minutos',
        '15 minutes' => '15 minutos',
        'Mr.' => 'Sr.',
        'Mrs.' => 'Sra.',
        'Next' => 'Siguiente',
        'Back' => 'Atr√°s',
        'Next...' => 'Siguiente...',
        '...Back' => '...Regresar',
        '-none-' => '-ninguno-',
        'none' => 'ninguno',
        'none!' => 'ninguno',
        'none - answered' => 'ninguno - respondido',
        'please do not edit!' => 'Por favor, no lo modifique',
        'Need Action' => 'Acci√≥n requerida',
        'AddLink' => 'A√±adir enlace',
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
        'Standard' => 'Est√°ndar',
        'Lite' => 'Reducida',
        'User' => 'Usuario',
        'Username' => 'Nombre de Usuario',
        'Language' => 'Idioma',
        'Languages' => 'Idiomas',
        'Password' => 'Contrase√±a',
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
        'Customer Info' => 'Informaci√≥n del Cliente',
        'Customer Information' => 'Informaci√≥n del Cliente',
        'Customer Company' => 'Compa√±√≠a del Cliente',
        'Customer Companies' => 'Compa√±√≠as de los Clientes',
        'Company' => 'Compa√±√≠a',
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
        'click here' => 'haga click aqu√≠',
        'Comment' => 'Comentario',
        'Invalid Option!' => 'Opci√≥n Inv√°lida',
        'Invalid time!' => 'Hora inv√°lida.',
        'Invalid date!' => 'Fecha inv√°lida.',
        'Name' => 'Nombre',
        'Group' => 'Grupo',
        'Description' => 'Descripci√≥n',
        'description' => 'descripci√≥n',
        'Theme' => 'Tema',
        'Created' => 'Creado',
        'Created by' => 'Creado por',
        'Changed' => 'Modificado',
        'Changed by' => 'Modificado por',
        'Search' => 'Buscar',
        'and' => 'y',
        'between' => 'entre',
        'Fulltext Search' => 'B√∫squeda de texto completo',
        'Data' => 'Datos',
        'Options' => 'Opciones',
        'Title' => 'T√≠tulo',
        'Item' => 'Art√≠culo',
        'Delete' => 'Borrar',
        'Edit' => 'Editar',
        'View' => 'Ver',
        'Number' => 'N√∫mero',
        'System' => 'Sistema',
        'Contact' => 'Contacto',
        'Contacts' => 'Contactos',
        'Export' => 'Exportar',
        'Up' => 'Arriba',
        'Down' => 'Abajo',
        'Add' => 'A√±adir',
        'Added!' => 'Agregado.',
        'Category' => 'Categor√≠a',
        'Viewer' => 'Visor',
        'Expand' => 'Expandir',
        'Small' => 'Peque√±o',
        'Medium' => 'Mediano',
        'Large' => 'Grande',
        'Date picker' => 'Selector de fecha',
        'New message' => 'Mensaje nuevo',
        'New message!' => '¬°Mensaje nuevo!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Por favor, responda a este(os) ticket(s) para regresar a la vista normal de la fila.',
        'You have %s new message(s)!' => 'Tiene %s mensaje(s) nuevo(s)',
        'You have %s reminder ticket(s)!' => 'Tiene %s recordatorio(s) de ticket',
        'The recommended charset for your language is %s!' => 'El juego de caracteres recomendado para su idioma es %s.',
        'Change your password.' => 'Cambiar contrase√±a',
        'Please activate %s first!' => '¬°Favor de activar %s primero!',
        'No suggestions' => 'Sin sugerencias.',
        'Word' => 'Palabra',
        'Ignore' => 'Ignorar',
        'replace with' => 'reemplazar con',
        'There is no account with that login name.' => 'No existe una cuenta para ese nombre de usuario.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            '¬°Inicio de sesi√≥n fallido! Nombre de usuario o contrase√±a incorrecto.',
        'There is no acount with that user name.' => 'No existe una cuenta para ese nombre de usuario',
        'Please contact your administrator' => 'Favor de contactar a su administrador',
        'Logout' => 'Cerrar Sesi√≥n',
        'Logout successful. Thank you for using %s!' => '',
        'Feature not active!' => 'Funcionalidad inactiva.',
        'Agent updated!' => '¬°Agente actualizado!',
        'Database Selection' => '',
        'Create Database' => 'Crear Base de Datos',
        'System Settings' => 'Configuraci√≥n del sistema',
        'Mail Configuration' => 'Configuraci√≥n de Correo',
        'Finished' => 'Finalizado',
        'Install OTRS' => 'Instalar OTRS',
        'Intro' => 'Introducci√≥n',
        'License' => 'Licencia',
        'Database' => 'Base de Datos',
        'Configure Mail' => 'Configurar Correo',
        'Database deleted.' => 'Base de Datos eliminada.',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database already contains data - it should be empty!' => '',
        'Login is needed!' => 'Inicio de sesi√≥n requerido.',
        'Password is needed!' => 'Contrase√±a requerida.',
        'Take this Customer' => 'Utilizar este cliente',
        'Take this User' => 'Utilizar este usuario',
        'possible' => 'posible',
        'reject' => 'rechazar',
        'reverse' => 'revertir',
        'Facility' => 'Instalaci√≥n',
        'Time Zone' => 'Zona Horaria',
        'Pending till' => 'Pendiente hasta',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'No use la cuenta de super usuario, Cree nuevos Agentes y trabaje con esas cuentas',
        'Dispatching by email To: field.' => 'Despachar por el campo Para: del correo electr√≥nico.',
        'Dispatching by selected Queue.' => 'Despachar por la fila seleccionada.',
        'No entry found!' => 'No se encontr√≥ entrada alguna.',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'La sesi√≥n ha caducado. Por favor, con√©ctese nuevamente.',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'No tiene Permiso.',
        '(Click here to add)' => '(Haga click aqu√≠ para a√±adir)',
        'Preview' => 'Vista Previa',
        'Package not correctly deployed! Please reinstall the package.' =>
            'El paquete no fue desplegado correctamente, por favor reinstale el paquete',
        '%s is not writable!' => '%s no es modificable!',
        'Cannot create %s!' => 'No se puede crear %s!',
        'Check to activate this date' => 'Chequear para activar esta fecha',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Usted configur√≥ su cuenta como "Fuera de la Oficina", ¬ødesea deshabilitarlo?',
        'Customer %s added' => 'Cliente %s a√±adido',
        'Role added!' => '¬°Rol a√±adido!',
        'Role updated!' => '¬°Rol actualizado!',
        'Attachment added!' => '¬°Archivo adjunto a√±adido!',
        'Attachment updated!' => '¬°Archivo adjunto actualizado!',
        'Response added!' => '¬°Respuesta a√±adida!',
        'Response updated!' => '¬°Respuesta actualizada!',
        'Group updated!' => '¬°Grupo actualizado!',
        'Queue added!' => '¬°Fila a√±adida!',
        'Queue updated!' => '¬°Fila actualizada!',
        'State added!' => '¬°Estado a√±adido!',
        'State updated!' => '¬°Estado actualizado!',
        'Type added!' => '¬°Tipo a√±adido!',
        'Type updated!' => '¬°Tipo actualizado!',
        'Customer updated!' => '¬°Cliente actualizado!',
        'Customer company added!' => '¬°Compa√±√≠a cliente agregada!',
        'Customer company updated!' => '¬°Compa√±√≠a cliente actualizada!',
        'Note: Company is invalid!' => '',
        'Mail account added!' => '¬°Cuenta de correo agregada!',
        'Mail account updated!' => '¬°Cuenta de correo actualizada!',
        'System e-mail address added!' => '¬°Direcci√≥n de correo del sistema agregada!',
        'System e-mail address updated!' => '¬°Direcci√≥n de correo del sistema actualizada!',
        'Contract' => 'Contrato',
        'Online Customer: %s' => 'Cliente Conectado: %s',
        'Online Agent: %s' => 'Agente Conectado: %s',
        'Calendar' => 'Calendario',
        'File' => 'Archivo',
        'Filename' => 'Nombre del archivo',
        'Type' => 'Tipo',
        'Size' => 'Tama√±o',
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
        'Phone' => 'Tel√©fono',
        'Fax' => 'Fax',
        'Mobile' => 'M√≥vil',
        'Zip' => 'CP',
        'City' => 'Ciudad',
        'Street' => 'Calle',
        'Country' => 'Pa√≠s',
        'Location' => 'Localidad',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' =>
            'Nota de seguridad: Debe activar %s porque la aplicaci√≥n ya est√° ejecut√°ndose',
        'Unable to parse repository index document.' => 'No es posible traducir el documento de √≠ndice del repositorio.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'No se encontraron paquetes en este repositorio para la versi√≥n del framework que ud. utiliza, s√≥lo contiene paquetes para otras versiones.',
        'No packages, or no new packages, found in selected repository.' =>
            'No se encontraron paquetes (o paquetes nuevos) en el repositorio seleccionado.',
        'Edit the system configuration settings.' => 'Modificar la configuraci√≥n del sistema.',
        'printed at' => 'impreso en',
        'Loading...' => 'Cargando...',
        'Dear Mr. %s,' => 'Apreciable Sr. %s,',
        'Dear Mrs. %s,' => 'Apreciable Sra. %s,',
        'Dear %s,' => 'Apreciable %s,',
        'Hello %s,' => 'Hola %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Esa direcci√≥n de correo electr√≥nico ya existe. Por favor, reinicie sesi√≥n o restablezca su contrase√±a.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Cuenta nueva creada. Informaci√≥n de inicio de sesi√≥n enviada a %s. Por favor, revise su correo electr√≥nico.',
        'Please press Back and try again.' => 'Por favor, presione Atr√°s e int√©ntelo de nuevo.',
        'Sent password reset instructions. Please check your email.' => 'Instrucciones de restablecimiento de contrase√±a enviadas. Por favor, revise su correo electr√≥nico.',
        'Sent new password to %s. Please check your email.' => 'Contrase√±a nueva enviada a %s. Por favor, revise su correo electr√≥nico.',
        'Upcoming Events' => 'Eventos Pr√≥ximos',
        'Event' => 'Evento',
        'Events' => 'Eventos',
        'Invalid Token!' => 'Informaci√≥n inv√°lida.',
        'more' => 'm√°s',
        'Collapse' => 'Colapso',
        'Shown' => 'Mostrados (as)',
        'Shown customer users' => '',
        'News' => 'Noticias',
        'Product News' => 'Noticias de Productos',
        'OTRS News' => 'Novedades de OTRS',
        '7 Day Stats' => 'Estad√≠sticas Semanales',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Mark' => '',
        'Unmark' => '',
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
        'Indent' => 'Aumentar sagr√≠a',
        'Outdent' => 'Reducir sangr√≠a',
        'Create an Unordered List' => 'Crear una Lista Desordenada',
        'Create an Ordered List' => 'Crear una Lista Ordenada',
        'HTML Link' => 'Enlace HTML',
        'Insert Image' => 'Insertar imagen',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Deshacer',
        'Redo' => 'Rehacer',
        'Scheduler process is registered but might not be running.' => 'El proceso del planificador se encuentra registrado, pero podr√≠a no estar corriendo.',
        'Scheduler is not running.' => 'El planificador no esta corriendo.',

        # Template: AAACalendar
        'New Year\'s Day' => 'A√±o nuevo',
        'International Workers\' Day' => 'D√≠a del trabajo',
        'Christmas Eve' => 'Noche buena',
        'First Christmas Day' => 'Navidad',
        'Second Christmas Day' => 'Segundo d√≠a de navidad',
        'New Year\'s Eve' => 'V√≠spera de a√±o nuevo',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS como solicitante',
        'OTRS as provider' => 'OTRS como proveedor',
        'Webservice "%s" created!' => '¬°Webservice "%s" creado!',
        'Webservice "%s" updated!' => '¬°Webservice "%s" actualizado!',

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
        'Email Settings' => 'Configuraci√≥n del Correo Electr√≥nico',
        'Other Settings' => 'Otras Configuraciones',
        'Change Password' => 'Cambiar Contrase√±a',
        'Current password' => 'Contrase√±a actual',
        'New password' => 'Nueva contrase√±a',
        'Verify password' => 'Verificar contrase√±a',
        'Spelling Dictionary' => 'Diccionario Ortogr√°fico',
        'Default spelling dictionary' => 'Diccionario por defecto',
        'Max. shown Tickets a page in Overview.' => 'Cantidad m√°xima de Tickets a mostrar en vista Resumen.',
        'The current password is not correct. Please try again!' => '¬°Contrase√±a incorrecta! Por favor, intente de nuevo.',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            '¬°No se puede actualizar su contrase√±a, porque las contrase√±as nuevas no coinciden! Por favor, intente de nuevo.',
        'Can\'t update password, it contains invalid characters!' => '¬°No se puede actualizar su contrase√±a, porque contiene caracteres inv√°lidos!',
        'Can\'t update password, it must be at least %s characters long!' =>
            '¬°No se puede actualizar su contrase√±a, porque debe contener al menos %s caracteres!',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => '¬°No se puede actualizar su contrase√±a, porque debe contener al menos 1 d√≠gito!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            '¬°No se puede actualizar su contrase√±a, porque debe contener al menos 2 caracteres!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            '¬°No se puede actualizar su contrase√±a, porque la que proporcin√≥ ya se est√° usando! Por favor, elija una nueva.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Seleccione el caracter de separaci√≥n para los archivos CSV (estad√≠sticas y b√∫squedas). En caso de que no lo seleccione, se usar√° el separador por defecto para su idioma.',
        'CSV Separator' => 'Separador CSV',

        # Template: AAAStats
        'Stat' => 'Estad√≠sticas',
        'Sum' => 'Suma',
        'Please fill out the required fields!' => 'Por favor, proporcione los campos requeridos.',
        'Please select a file!' => 'Por favor, seleccione un archivo.',
        'Please select an object!' => 'Por favor, seleccione un objeto.',
        'Please select a graph size!' => 'Por favor, seleccione un tama√±o de gr√°fica.',
        'Please select one element for the X-axis!' => 'Por favor, seleccione un elemento para el eje X.',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Por favor, seleccione √∫nicamente un elemento o desactive el bot√≥n \'Fijo\' donde el campo est√° se√±alado.',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Si usa una casilla de selecci√≥n, debe seleccionar algunos atributos de dicho campo.',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Por favor, inserte un valor en la caja de texto o desactive la opci√≥n \'Fijo\'',
        'The selected end time is before the start time!' => 'La fecha de finalizaci√≥n seleccionada es previa a la de inicio.',
        'You have to select one or more attributes from the select field!' =>
            'Debe elegir uno o m√°s atributos de la lista de selecci√≥n.',
        'The selected Date isn\'t valid!' => 'La fecha seleccionada es inv√°lida.',
        'Please select only one or two elements via the checkbox!' => 'Por favor, elija s√≥lo uno o dos elementos de la casilla de selecci√≥n.',
        'If you use a time scale element you can only select one element!' =>
            'Si utiliza una escala de tiempo, s√≥lo puede seleccionar un elemento.',
        'You have an error in your time selection!' => 'Tiene un error en la selecci√≥n del tiempo.',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Su intervalo de tiempo para el reporte es demasiado peque√±o, por favor utilice una escala mayor.',
        'The selected start time is before the allowed start time!' => 'El tiempo de inicio seleccionado es previo al permitido.',
        'The selected end time is after the allowed end time!' => 'El tiempo de finalizaci√≥n seleccionado es posterior al permitido.',
        'The selected time period is larger than the allowed time period!' =>
            'El periodo de tiempo seleccionado es mayor al permitido.',
        'Common Specification' => 'Especificaci√≥n com√∫n',
        'X-axis' => 'EjeX',
        'Value Series' => 'Serie de Valores',
        'Restrictions' => 'Restricciones',
        'graph-lines' => 'gr√°fica-l√≠neas',
        'graph-bars' => 'gr√°fica-barras ',
        'graph-hbars' => 'gr√°fica-barras-horiz',
        'graph-points' => 'gr√°fica-puntos',
        'graph-lines-points' => 'gr√°fica-punteada',
        'graph-area' => 'gr√°fica-√°rea',
        'graph-pie' => 'gr√°fica-pastel',
        'extended' => 'extendido',
        'Agent/Owner' => 'Agente/Propietario',
        'Created by Agent/Owner' => 'Creado por Agente/Propietario',
        'Created Priority' => 'Prioridad de Creaci√≥n',
        'Created State' => 'Estado de Creaci√≥n',
        'Create Time' => 'Tiempo de Creaci√≥n',
        'CustomerUserLogin' => 'Cuenta de inicio de sesi√≥n del Cliente',
        'Close Time' => 'Fecha de Cierre',
        'TicketAccumulation' => 'Acumulaci√≥n de Tickets',
        'Attributes to be printed' => 'Atributos a imprimir',
        'Sort sequence' => 'Secuencia de ordenamiento',
        'Order by' => 'Ordenar por',
        'Limit' => 'L√≠mite',
        'Ticketlist' => 'Lista de tickets',
        'ascending' => 'ascendente',
        'descending' => 'descendente',
        'First Lock' => 'Primer bloqueo',
        'Evaluation by' => 'Evaluaci√≥n por',
        'Total Time' => 'Tiempo Total',
        'Ticket Average' => 'Ticket-Promedio',
        'Ticket Min Time' => 'Ticket-Tiempo M√≠n',
        'Ticket Max Time' => 'Ticket-Tiempo M√°x',
        'Number of Tickets' => 'N√∫mero de tickets',
        'Article Average' => 'Art√≠culo-Promedio',
        'Article Min Time' => 'Art√≠culo-Tiempo M√≠n',
        'Article Max Time' => 'Art√≠culo-Tiempo M√°x',
        'Number of Articles' => 'N√∫mero de art√≠culos',
        'Accounted time by Agent' => 'Tiempo utilizado por el Agente',
        'Ticket/Article Accounted Time' => 'Tiempo utilizado por el Ticket/Articulo',
        'TicketAccountedTime' => 'Tiempo Utilizado por el Ticket',
        'Ticket Create Time' => 'Tiempo de creaci√≥n del ticket',
        'Ticket Close Time' => 'Tiempo de cierre del ticket',

        # Template: AAATicket
        'Status View' => 'Vista de Estados',
        'Bulk' => 'Acciones simult√°neas en los tickets seleccionados',
        'Lock' => 'Bloquear',
        'Unlock' => 'Desbloquear',
        'History' => 'Historia',
        'Zoom' => 'Detalle',
        'Age' => 'Antig√ºedad',
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
        'Priority added!' => '¬°Prioridad agregada!',
        'Priority updated!' => 'Prioridad actualizada!',
        'Signature added!' => '¬°Firma agregada!',
        'Signature updated!' => 'Firma actualizada!',
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
        'Article' => 'Art√≠culo',
        'Ticket' => 'Ticket',
        'Createtime' => 'Fecha de creaci√≥n ',
        'plain' => 'texto plano',
        'Email' => 'Correo',
        'email' => 'correo',
        'Close' => 'Cerrar',
        'Action' => 'Acci√≥n',
        'Attachment' => 'Anexo',
        'Attachments' => 'Anexos',
        'This message was written in a character set other than your own.' =>
            'Este mensaje fue escrito usando un juego de caracteres distinto al suyo',
        'If it is not displayed correctly,' => 'Si no se muestra correctamente',
        'This is a' => 'Este es un',
        'to open it in a new window.' => 'para abrir en una nueva ventana',
        'This is a HTML email. Click here to show it.' => 'Este es un mensaje HTML. Haga click aqu√≠ para mostrarlo.',
        'Free Fields' => 'Campos Libres',
        'Merge' => 'Mezclar',
        'merged' => 'mezclado',
        'closed successful' => 'cerrado exitosamente',
        'closed unsuccessful' => 'cerrado sin √©xito',
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
        'Available tickets' => 'Tickets disponibles',
        'Escalation' => 'Escalado',
        'last-search' => 'Ultima busqueda',
        'QueueView' => 'Ver la fila',
        'Ticket Escalation View' => 'Ver Escalado del Ticket',
        'Message from' => 'Mensaje de',
        'End message' => 'Fin del mensaje',
        'Forwarded message from' => 'Mensaje reenviado de',
        'End forwarded message' => 'Fin del mensaje reenviado',
        'new' => 'nuevo',
        'open' => 'abierto',
        'Open' => 'Abierto',
        'Open tickets' => 'Tickets Abiertos',
        'closed' => 'cerrado',
        'Closed' => 'Cerrado',
        'Closed tickets' => 'Tickets cerrados',
        'removed' => 'eliminado',
        'pending reminder' => 'recordatorio pendiente',
        'pending auto' => 'pendiente autom√°tico',
        'pending auto close+' => 'pendiente auto close+',
        'pending auto close-' => 'pendiente auto close-',
        'email-external' => 'correo-externo',
        'email-internal' => 'correo-interno',
        'note-external' => 'nota-externa',
        'note-internal' => 'nota-interna',
        'note-report' => 'nota-informe',
        'phone' => 'tel√©fono',
        'sms' => 'sms',
        'webrequest' => 'solicitud v√≠a web',
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
        'auto follow up' => 'auto seguimiento',
        'auto reject' => 'auto rechazar',
        'auto remove' => 'auto eliminar',
        'auto reply' => 'autor esponder',
        'auto reply/new ticket' => 'auto responder/nuevo ticket',
        'Create' => 'Crear',
        'Answer' => 'Responder',
        'Phone call' => 'Llamada telef√≥nica',
        'Ticket "%s" created!' => 'Ticket "%s" creado',
        'Ticket Number' => 'Ticket N√∫mero',
        'Ticket Object' => 'Objeto Ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'No existe el Ticket N√∫mero "%s", no se puede vincular',
        'You don\'t have write access to this ticket.' => 'Usted no tiene acceso de escritura a este ticket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Lo siento, usted debe ser el due√±o del ticket para realizar esta acci√≥n',
        'Please change the owner first.' => '',
        'Ticket selected.' => 'Ticket seleccionado',
        'Ticket is locked by another agent.' => 'El ticket se encuentra bloqueado por otro Agente.',
        'Ticket locked.' => 'Ticket bloqueado',
        'Don\'t show closed Tickets' => 'No mostrar los tickets cerrados',
        'Show closed Tickets' => 'Mostrar Tickets cerrados',
        'New Article' => 'Nuevo Art√≠culo',
        'Unread article(s) available' => 'Art√≠culo(s) sin leer disponible',
        'Remove from list of watched tickets' => 'Quitar de la lista de tickets monitoreados',
        'Add to list of watched tickets' => 'Agregar a la lista de tickets monitoreados',
        'Email-Ticket' => 'Ticket de Email',
        'Create new Email Ticket' => 'Crea nuevo Ticket de Email',
        'Phone-Ticket' => 'Ticket Telef√≥nico',
        'Search Tickets' => 'Buscar Tickets',
        'Edit Customer Users' => 'Editar Clientes',
        'Edit Customer Company' => 'Editar Compa√±√≠a de Clientes',
        'Bulk Action' => 'Acci√≥n M√∫ltiple',
        'Bulk Actions on Tickets' => 'Acci√≥n M√∫ltiple sobre Tickets',
        'Send Email and create a new Ticket' => 'Enviar un correo y crear un nuevo ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Crea nuevo Ticket de Email y descartar este (saliente)',
        'Create new Phone Ticket (Inbound)' => 'Crea nuevo Ticket Telef√≥nico (entrante)',
        'Address %s replaced with registered customer address.' => 'Direcci√≥n %s es reeplazado por la direcci√≥n registrada por el cliente.',
        'Customer automatically added in Cc.' => 'Cliente autom√°ticamente agregado en Cc.',
        'Overview of all open Tickets' => 'Resumen de todos los tickets abiertos',
        'Locked Tickets' => 'Tickets Bloqueados',
        'My Locked Tickets' => 'Mis Tickets Bloqueados',
        'My Watched Tickets' => 'Mis Tickets Monitoreados',
        'My Responsible Tickets' => 'Tickets bajo mi Responsabilidad',
        'Watched Tickets' => 'Tickets Monitoreados',
        'Watched' => 'Monitoreado',
        'Watch' => 'Monitorear',
        'Unwatch' => 'Dejar de monitorear',
        'Lock it to work on it' => 'Bloquear para trabajar en el',
        'Unlock to give it back to the queue' => 'Desbloquearlo para devolverlo a la fila',
        'Show the ticket history' => 'Mostrar el historial del ticket',
        'Print this ticket' => 'Imprimir este ticket',
        'Print this article' => 'Imprimir este art√≠culo',
        'Split' => 'Dividir',
        'Split this article' => 'Dividir este art√≠culo',
        'Forward article via mail' => 'Reenviar art√≠culo via email',
        'Change the ticket priority' => 'Cambiar la prioridad del ticket',
        'Change the ticket free fields!' => 'Cambiar los campos libres del ticket',
        'Link this ticket to other objects' => 'Enlazar este ticket con otros objetos',
        'Change the owner for this ticket' => 'Cambiar el propietario de este ticket',
        'Change the  customer for this ticket' => 'Cambiar el cliente de este ticket',
        'Add a note to this ticket' => 'Agregar una nota a este ticket',
        'Merge into a different ticket' => 'Combinar en un ticket diferente',
        'Set this ticket to pending' => 'Cambiar este ticket a pendiente',
        'Close this ticket' => 'Cerrar este ticket',
        'Look into a ticket!' => 'Revisar un ticket',
        'Delete this ticket' => 'Eliminar este ticket',
        'Mark as Spam!' => 'Marcar como correo no deseado',
        'My Queues' => 'Mis Filas',
        'Shown Tickets' => 'Tickets Mostrados',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Su correo con n√∫mero de ticket "<OTRS_TICKET>" se uni√≥ a "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: Tiempo para primera respuesta ha vencido (%s)',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: Tiempo para primera respuesta vencer√° en %s',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: Tiempo para actualizaci√≥n ha vencido (%s)',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: Tiempo para actualizaci√≥n vencer√° en %s',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: Tiempo para soluci√≥n ha vencido (%s)',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: Tiempo para soluci√≥n vencer√° en %s',
        'There are more escalated tickets!' => 'No hay m√°s tickets escalados',
        'Plain Format' => 'Sin formato',
        'Reply All' => 'Responder a todos',
        'Direction' => 'Direcci√≥n',
        'Agent (All with write permissions)' => 'Agente (todos con permiso de escritura)',
        'Agent (Owner)' => 'Agente (Propietario)',
        'Agent (Responsible)' => 'Agente (Responsable)',
        'New ticket notification' => 'Notificaci√≥n de nuevos tickets',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Notif√≠queme si hay un nuevo ticket en "Mis Filas".',
        'Send new ticket notifications' => 'Enviar notificaciones de ticket nuevo',
        'Ticket follow up notification' => 'Notificaci√≥n de seguimiento de ticket',
        'Ticket lock timeout notification' => 'Notificaci√≥n de bloqueo de tickets por tiempo',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Notif√≠queme si un ticket es desbloqueado por el sistema',
        'Send ticket lock timeout notifications' => 'Enviar notificaciones de ticket bloqueado por tiempo de espera',
        'Ticket move notification' => 'Notificaci√≥n de reubicaci√≥n de ticket',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Notif√≠queme si un ticket es colocado en una de "Mis Filas".',
        'Send ticket move notifications' => 'Enviar notificaciones de reubicaci√≥n de ticket',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Su selecci√≥n de sus filas favoritas. Usted tambi√©n ser√° notificado sobre esas filas v√≠a email si esta habilitado.',
        'Custom Queue' => 'Fila personal',
        'QueueView refresh time' => 'Tiempo de actualizaci√≥n de la vista de filas',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Si se habilita, la vista de filas se actualizar√° autom√°ticamente despu√©s del tiempo especificado.',
        'Refresh QueueView after' => 'Actualizar la vista de filas despu√©s de',
        'Screen after new ticket' => 'Pantalla posterior a nuevo ticket',
        'Show this screen after I created a new ticket' => 'Mostrar esta pantalla despu√©s de crear un ticket nuevo',
        'Closed Tickets' => 'Tickets Cerrados',
        'Show closed tickets.' => 'Mostrar Tickets cerrados',
        'Max. shown Tickets a page in QueueView.' => 'Cantidad de Tickets a mostrar en la Vista de Fila',
        'Ticket Overview "Small" Limit' => 'L√≠mite de vista de resumen "Peque√±a" de tickets',
        'Ticket limit per page for Ticket Overview "Small"' => 'L√≠mite de tickets por p√°gina mostrados en la vista de resumen "Peque√±a"',
        'Ticket Overview "Medium" Limit' => 'L√≠mite de la vista de resumen "Mediana" de tickets',
        'Ticket limit per page for Ticket Overview "Medium"' => 'L√≠mite de tickets por p√°gina mostrados en la vista de resumen "Mediana"',
        'Ticket Overview "Preview" Limit' => 'L√≠mite de la vista de resumen "Preliminar" de tickets',
        'Ticket limit per page for Ticket Overview "Preview"' => 'L√≠mite de tickets por p√°gina mostrados en la vista de resumen "Preliminar"',
        'Ticket watch notification' => 'Notificaci√≥n de ticket monitoreado',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Quiero recibir las mismas notificaciones que se env√≠en a los propietaios de mis tickets monitoreados',
        'Send ticket watch notifications' => 'Enviar notificaciones de ticket monitoreado',
        'Out Of Office Time' => 'Tiempo de ausencia de la oficina',
        'New Ticket' => 'Nuevo Ticket',
        'Create new Ticket' => 'Crear un nuevo Ticket',
        'Customer called' => 'Llamada de Cliente',
        'phone call' => 'llamada telef√≥nica',
        'Phone Call Outbound' => 'Llamada telef√≥nica saliente',
        'Phone Call Inbound' => 'Llamada telef√≥nica entrante',
        'Reminder Reached' => 'Recordatorios alcanzados',
        'Reminder Tickets' => 'Tickets de recordatorios',
        'Escalated Tickets' => 'Tickets escalados',
        'New Tickets' => 'Nuevos tickets',
        'Open Tickets / Need to be answered' => 'Tickets Abiertos / Que necesitan de una respuesta',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Todos los tickets abiertos en los que ya se trabaj√≥, pero necesitan una respuesta',
        'All new tickets, these tickets have not been worked on yet' => 'Todos los tickets nuevos en los que a√∫n no se ha trabajado',
        'All escalated tickets' => 'Todos los tickets escalados',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Todos los tickets que han llegado a la fecha de recordatorio',
        'Archived tickets' => 'Tickets archivados',
        'Unarchived tickets' => 'Tickets si archivar',
        'History::Move' => 'Ticket movido a la fila "%s" (%s) de la fila "%s" (%s).',
        'History::TypeUpdate' => 'Tipo actualizado a %s (ID=%s).',
        'History::ServiceUpdate' => 'Servicio actualizado a %s (ID=%s).',
        'History::SLAUpdate' => 'SLA actualizado a %s (ID=%s).',
        'History::NewTicket' => 'Nuevo Ticket [%s] creado (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Seguimiento para [%s]. %s',
        'History::SendAutoReject' => 'Rechazo autom√°tico enviado a "%s".',
        'History::SendAutoReply' => 'Respuesta autom√°tica enviada a "%s".',
        'History::SendAutoFollowUp' => 'Seguimiento autom√°tico enviado a "%s".',
        'History::Forward' => 'Reenviado a "%s".',
        'History::Bounce' => 'Reenviado a "%s".',
        'History::SendAnswer' => 'Correo enviado a "%s".',
        'History::SendAgentNotification' => '"%s"-notificaci√≥n enviada a "%s".',
        'History::SendCustomerNotification' => 'Notificaci√≥n; enviada a "%s".',
        'History::EmailAgent' => 'Correo enviado al cliente.',
        'History::EmailCustomer' => 'Correo a√±adido. %s',
        'History::PhoneCallAgent' => 'El agente llam√≥ al cliente.',
        'History::PhoneCallCustomer' => 'El cliente llam√≥.',
        'History::AddNote' => 'Nota a√±adida (%s)',
        'History::Lock' => 'Ticket bloqueado.',
        'History::Unlock' => 'Ticket desbloqueado.',
        'History::TimeAccounting' => '%s unidad(es) de tiempo contabilizadas. Nuevo total : %s unidad(es) de tiempo.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Actualizado: %s',
        'History::PriorityUpdate' => 'Cambiar prioridad de "%s" (%s) a "%s" (%s).',
        'History::OwnerUpdate' => 'El nuevo propietario es "%s" (ID=%s).',
        'History::LoopProtection' => 'Protecci√≥n de bucle! NO se envi√≥ auto-respuesta a "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Actualizado: %s',
        'History::StateUpdate' => 'Antiguo: "%s". Nuevo: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Actualizado: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Solicitud de cliente v√≠a web.',
        'History::TicketLinkAdd' => 'A√±adido enlace al ticket "%s".',
        'History::TicketLinkDelete' => 'Eliminado enlace al ticket "%s".',
        'History::Subscribe' => 'A√±adida subscripci√≥n para el usuario "%s".',
        'History::Unsubscribe' => 'Eliminada subscripci√≥n para el usuario "%s".',
        'History::SystemRequest' => 'Petici√≥n del Sistema (%s).',
        'History::ResponsibleUpdate' => 'El responsable nuevo es "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => '',
        'History::TicketTitleUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mi√©',
        'Thu' => 'Jue',
        'Fri' => 'Vie',
        'Sat' => 'S√°b',

        # Template: AdminACL
        'ACL Management' => '',
        'Filter for ACLs' => '',
        'Filter' => 'Filtro',
        'ACL Name' => '',
        'Actions' => 'Acciones',
        'Create New ACL' => '',
        'Deploy ACLs' => '',
        'Export ACLs' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'Este es un campo obligatorio.',
        'Overwrite existing ACLs?' => '',
        'Upload ACL configuration' => '',
        'Import ACL configuration(s)' => '',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '',
        'ACL name' => '',
        'Validity' => 'Validez',
        'Copy' => '',
        'No data found.' => 'No se encontraron datos.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Go to overview' => 'Ir la vista de resumen',
        'Delete ACL' => '',
        'Delete Invalid ACL' => '',
        'Match settings' => '',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => '',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '',
        'Check the official' => '',
        'documentation' => '',
        'Show or hide the content' => 'Mostrar u ocultar el contenido',
        'Edit ACL information' => '',
        'Stop after match' => 'Parar al coincidir',
        'Edit ACL structure' => '',
        'Save' => 'Guardar',
        'or' => 'o',
        'Save and finish' => '',
        'Do you really want to delete this ACL?' => '',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '',
        'An item with this name is already present.' => '',
        'Add all' => '',
        'There was an error reading the ACL data.' => '',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAttachment
        'Attachment Management' => 'Administraci√≥n de Anexos',
        'Add attachment' => 'Adjuntar archivo',
        'List' => 'Listar',
        'Download file' => 'Descargar archivo',
        'Delete this attachment' => 'Eliminar este archivo adjunto',
        'Add Attachment' => 'Adjuntar Archivo',
        'Edit Attachment' => 'Modificar Archivo Adjunto',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Administraci√≥n de Respuestas Autom√°ticas',
        'Add auto response' => 'Agregar auto respuesta',
        'Add Auto Response' => 'Agregar Auto Respuesta',
        'Edit Auto Response' => 'Modificar Auto Respuesta',
        'Response' => 'Respuesta',
        'Auto response from' => 'Auto respuesta de',
        'Reference' => 'Referencia',
        'You can use the following tags' => 'Puede utilizar las siguientes etiquetas',
        'To get the first 20 character of the subject.' => 'Para obtener los primeros 20 caracteres del asunto.',
        'To get the first 5 lines of the email.' => 'Para obtener las primeras 5 l√≠neas del correo.',
        'To get the realname of the sender (if given).' => 'Para obtener el nombre real del remitente (si se proporcion√≥).',
        'To get the article attribute' => 'Para obtener el atributo del art√≠culo',
        ' e. g.' => 'Por ejemplo:',
        'Options of the current customer user data' => 'Opciones para los datos del cliente actual',
        'Ticket owner options' => 'Opciones para el propietario del ticket',
        'Ticket responsible options' => 'Opciones para el responsable del ticket',
        'Options of the current user who requested this action' => 'Opciones del usuario actual, quien solicit√≥ esta acci√≥n',
        'Options of the ticket data' => 'Opciones de los datos del ticket',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Opciones de configuraci√≥n',
        'Example response' => 'Respuesta de ejemplo',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Administraci√≥n de Compa√±√≠as del Cliente',
        'Wildcards like \'*\' are allowed.' => 'Comodines como \'*\' son permitidos',
        'Add customer company' => 'A√±adir compa√±√≠a de cliente',
        'Select' => 'Seleccionar',
        'Please enter a search term to look for customer companies.' => 'Por favor, introduzca un par√°metro de b√∫squeda para buscar compa√±√≠as de clientes.',
        'Add Customer Company' => 'A√±adir Compa√±√≠a de Cliente',

        # Template: AdminCustomerUser
        'Customer Management' => 'Gesti√≥n de Clientes',
        'Back to search results' => '',
        'Add customer' => 'A√±adir cliente',
        'Hint' => 'Pista',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Se requiere un cliente para llevar un historial del mismo e iniciar sesi√≥n a trav√©s de la interfaz del cliente.',
        'Please enter a search term to look for customers.' => 'Por favor, introduzca un par√°metro de b√∫squeda para buscar clientes',
        'Last Login' => '√öltimo inicio de sesi√≥n',
        'Login as' => 'Conectarse como',
        'Switch to customer' => '',
        'Add Customer' => 'A√±adir Cliente',
        'Edit Customer' => 'Modificar Cliente',
        'This field is required and needs to be a valid email address.' =>
            'Este es un campo obligatorio y tiene que ser una direcci√≥n de correo electr√≥nico v√°lida.',
        'This email address is not allowed due to the system configuration.' =>
            'Esta direcci√≥n de correo electr√≥nico no est√° permitida, debido a la configuraci√≥n del sistema.',
        'This email address failed MX check.' => 'Esta direcci√≥n de correo electr√≥nico fall√≥ la verificaci√≥n MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema con el DNS. Por favor, verifique su configuraci√≥n y el registro de errores.',
        'The syntax of this email address is incorrect.' => 'La sint√°xis de esta direcci√≥n de correo electr√≥nico es incorrecta.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gestionar Relaciones Cliente-Grupo',
        'Notice' => 'Aviso',
        'This feature is disabled!' => 'Esta caracter√≠stica est√° deshabilitada',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utilice esta funci√≥n √∫nicamente si desea definir permisos de grupo para los clientes.',
        'Enable it here!' => 'Habil√≠telo aqu√≠',
        'Search for customers.' => 'B√∫squeda de clientes.',
        'Edit Customer Default Groups' => 'Modificar los grupos por defecto de los clientes',
        'These groups are automatically assigned to all customers.' => 'Estos grupos se asignan autom√°ticamente a todos los clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Es posible gestionar estos grupos por medio de la configuraci√≥n "CustomerGroupAlwaysGroups"',
        'Filter for Groups' => 'Filtro para Grupos',
        'Select the customer:group permissions.' => 'Seleccione los permisos cliente:grupo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Si nada se selecciona, no habr√° permisos para este grupo y los tickets no estar√°n disponibles para el cliente.',
        'Search Results' => 'Resultado de la b√∫squeda',
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
        'Read only access to the ticket in this group/queue.' => 'Acceso de s√≥lo lectura a los tickets de este grupo/fila.',
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
        'Dynamic Fields Management' => 'Administraci√≥n de campos din√°micos',
        'Add new field for object' => 'Agregar un nuevo campo',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Para agregar un nuevo campo, seleccione el tipo de campo desde el listado de objetos, el objeto define el l√≠mite del campo y no puede ser cambiado despues de la creaci√≥n del campo.',
        'Dynamic Fields List' => 'Listado de campos din√°micos',
        'Dynamic fields per page' => 'Campos din√°micos por p√°gina',
        'Label' => 'Etiqueta',
        'Order' => 'Orden',
        'Object' => 'Objeto',
        'Delete this field' => 'Eliminar este campo',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '¬øRealmente desea eliminar este campo dinamico? TODA la informaci√≥n asociada al mismo se PERDER√Å!',
        'Delete field' => 'Eliminar campo',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Campos Din√°micos',
        'Field' => 'Campo',
        'Go back to overview' => 'Volver a la vista general',
        'General' => 'General',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Este campo es requerido y el valor solo debe contener caracteres alfab√©ticos y num√©ricos.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Debe ser √∫nico y solo se aceptan caracteres alfab√©ticos y num√©ricos',
        'Changing this value will require manual changes in the system.' =>
            'Cambiar este valor requerir√° cambios manuales en el sistema.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Este es el nombre que se mostrar√° en pantalla cuando el campo este activo.',
        'Field order' => 'Orden de los cambios',
        'This field is required and must be numeric.' => 'Este campo es requerido y debe ser num√©rico',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Este es el orden en el cual este campo ser√° mostrado en pantalla cuando este activo.',
        'Field type' => 'Tipo de campo',
        'Object type' => 'Tipo de objeto',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => 'Configuraci√≥n del campo',
        'Default value' => 'Valor por defecto',
        'This is the default value for this field.' => 'Este es el valor por defecto para este campo.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Diferencia de fechas predeterminada',
        'This field must be numeric.' => 'Este campo deber√≠a ser num√©rico',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'La diferencia desde AHORA (en segundos) para calcular el valor por defecto del campo (ej. 3600 o -60).',
        'Define years period' => 'Defina el periodo en a√±os',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Active esta caracter√≠stica para definir un rango fijo en a√±os (en el futuro y en el pasado) que se mostrar√° en la parte a√±o del campo.',
        'Years in the past' => 'A√±os en el pasado',
        'Years in the past to display (default: 5 years).' => 'A√±os a mostrar en el pasado (por defecto: 5 a√±os).',
        'Years in the future' => 'A√±os en el futuro',
        'Years in the future to display (default: 5 years).' => 'A√±os a mostrar en el futuro (por defecto: 5 a√±os).',
        'Show link' => 'Mostrar enlace',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Aqu√≠ usted puede especificar un enlace HTTP opcional para el valor del campo en las vistas "Panel Principal" y "Ampliaci√≥n"',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Valores posibles',
        'Key' => 'Clave',
        'Value' => 'Valor',
        'Remove value' => 'Eliminar valor',
        'Add value' => 'A√±adir valor',
        'Add Value' => 'A√±adir valor',
        'Add empty value' => 'Agregar valor vac√≠o',
        'Activate this option to create an empty selectable value.' => 'Active esta funci√≥n para crear un valor vac√≠o seleccionable.',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => 'Valores traducibles',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Si usted activa esta opci√≥n los valores ser√°n traducidos al idioma predefinido del usuario.',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'Usted necesita agregar manualmente las traducciones a los archivos de lenguaje.',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'N√∫mero de filas',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Especifique la altura (en lineas) para este campo en el modo de edici√≥n.',
        'Number of cols' => 'N√∫mero de columnas',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Especifieque el ancho (en caracteres) para este campo en el modo de edici√≥n.',

        # Template: AdminEmail
        'Admin Notification' => 'Notificaci√≥n del Administrador',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Con este m√≥dulo, los administradores pueden enviar mensajes a los Agentes y/o miembros de Grupos y Roles.',
        'Create Administrative Message' => 'Crear Mensaje Administrativo',
        'Your message was sent to' => 'Mensaje enviado a',
        'Send message to users' => 'Enviar mensaje a los usuarios',
        'Send message to group members' => 'Enviar mensaje a los miembros del grupo',
        'Group members need to have permission' => 'Los miembros del grupo necesitan tener permiso',
        'Send message to role members' => 'Enviar mensaje a los miembros del rol',
        'Also send to customers in groups' => 'Tambi√©n enviar a los clientes de los grupos',
        'Body' => 'Cuerpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agente Gen√©rico',
        'Add job' => 'Agregar tarea',
        'Last run' => '√öltima ejecuci√≥n',
        'Run Now!' => 'Ejecutar ahora',
        'Delete this task' => 'Eliminar esta tarea',
        'Run this task' => 'Ejecutar esta tarea',
        'Job Settings' => 'Configuraciones de la Tarea',
        'Job name' => 'Nombre de la tarea',
        'Toggle this widget' => 'Activar este widget',
        'Automatic execution (multiple tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Fijar minutos',
        'Schedule hours' => 'Fijar horas',
        'Schedule days' => 'Fijar d√≠as',
        'Currently this generic agent job will not run automatically.' =>
            'Actualmente esta tarea del agente gen√©rico no se ejecutar√° autom√°ticamente',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Para habilitar la ejecuci√≥n autom√°tica, seleccione al menos un valor de minutos, horas y d√≠as.',
        'Event based execution (single ticket)' => '',
        'Event Triggers' => '',
        'List of all configured events' => '',
        'Delete this event' => '',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => '',
        'Ticket Filter' => 'Filtro de Ticket',
        '(e. g. 10*5155 or 105658*)' => '(ej: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(ej: 234321)',
        'Customer login' => 'Inicio de sesi√≥n del cliente',
        '(e. g. U5150)' => '(ej: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'B√∫squeda en todo el texto del art√≠culo (por ejemplo: "Mar*in" o "Baue*").',
        'Agent' => 'Agente',
        'Ticket lock' => 'Bloqueo de ticket',
        'Create times' => 'Tiempos de creaci√≥n',
        'No create time settings.' => 'No existen configuraciones para tiempo de creaci√≥n.',
        'Ticket created' => 'Ticket creado',
        'Ticket created between' => 'Ticket creado entre',
        'Change times' => 'Cambiar tiempos',
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
        'Escalation - update time' => 'Escalado - tiempo para la actualizaci√≥n',
        'Ticket update time reached' => 'El tiempo para la actualizaci√≥n del Ticket ha sido alcanzado',
        'Ticket update time reached between' => 'El tiempo para la actualizaci√≥n del Ticket ha sido alcanzado entre',
        'Escalation - solution time' => 'Escalado - tiempo para la soluci√≥n',
        'Ticket solution time reached' => 'El tiempo para la soluci√≥n del Ticket ha sido alcanzado',
        'Ticket solution time reached between' => 'El tiempo para la soluci√≥n del Ticket ha sido alcanzado entre',
        'Archive search option' => 'Opci√≥n de b√∫squeda en el archivo',
        'Ticket Action' => 'Acci√≥n del Ticket',
        'Set new service' => 'Establecer servicio nuevo',
        'Set new Service Level Agreement' => 'Establecer Acuerdo de Nivel de Servicio nuevo',
        'Set new priority' => 'Establecer prioridad nueva',
        'Set new queue' => 'Establecer fila nueva',
        'Set new state' => 'Establecer estado nuevo',
        'Pending date' => 'Fecha pendiente',
        'Set new agent' => 'Establecer agente nuevo',
        'new owner' => 'propietario nuevo',
        'new responsible' => 'responsable nuevo',
        'Set new ticket lock' => 'Establecer bloqueo de ticket nuevo',
        'New customer' => 'Cliente nuevo',
        'New customer ID' => 'ID de cliente nuevo',
        'New title' => 'T√≠tulo nuevo',
        'New type' => 'Tipo nuevo',
        'New Dynamic Field Values' => 'Valor de campo din√°mico nuevo',
        'Archive selected tickets' => 'Tickets seleccionados del archivo',
        'Add Note' => 'A√±adir Nota',
        'Time units' => 'Unidades de tiempo',
        '(work units)' => '(unidades de trabajo)',
        'Ticket Commands' => 'Instrucciones de Ticket',
        'Send agent/customer notifications on changes' => 'Enviar notificaci√≥n de cambios al agente/cliente',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Este comando se ejecutar√°. ARG[0] ser√° el n√∫mero del ticket y ARG[0] el identificador del ticket.',
        'Delete tickets' => 'Eliminar tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Advertencia: ¬°Todos los tickets afectados ser√°n eliminados de la base de datos y no se podr√° restaurar!',
        'Execute Custom Module' => 'Ejecutar M√≥dulo Personalizado',
        'Param %s key' => 'Par√°metro %s llave',
        'Param %s value' => 'Par√°metro %s valor',
        'Save Changes' => 'Guardar Cambios',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '¬°%s Tickets afectados! ¬øQu√© desea hacer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Advertencia: Eligi√≥ la opci√≥n ELIMINAR. ¬°Todos los tickets eliminados se perder√°n!. ',
        'Edit job' => 'Modificar tarea',
        'Run job' => 'Ejecutar tarea',
        'Affected Tickets' => 'Tickets Afectados',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => 'Servicios Web',
        'Debugger' => 'Depurador',
        'Go back to web service' => 'Volver al servicio web',
        'Clear' => 'Limpiar',
        'Do you really want to clear the debug log of this web service?' =>
            '¬øUsted realmente desea limpiar los registros del depurador para este servicio web?',
        'Request List' => 'L√≠mite de solicitudes',
        'Time' => 'Tiempo',
        'Remote IP' => 'Direcci√≥n IP remota',
        'Loading' => 'Cargando',
        'Select a single request to see its details.' => 'Seleccione una √∫nica solicitud para ver sus detalles.',
        'Filter by type' => 'Filtrar por tipo',
        'Filter from' => 'Filtrar "de"',
        'Filter to' => 'Filtrar "para"',
        'Filter by remote IP' => 'Filtrar por direcci√≥n IP remota',
        'Refresh' => 'Refrescar',
        'Request Details' => 'Detalles de la solicitud',
        'An error occurred during communication.' => 'Ocurri√≥ un error durante la comunicaci√≥n.',
        'Clear debug log' => 'Limpiar registro del depurador',

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
        'Asynchronous' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => '',
        'Delete this Invoker' => '',

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
        'GenericInterface Web Service Management' => 'Administraci√≥n de servicios web',
        'Add web service' => 'Agregar un servicio web',
        'Clone web service' => 'Clonar servicio web',
        'The name must be unique.' => 'El nombre deber√≠a ser √∫nico',
        'Clone' => 'Clonar',
        'Export web service' => 'Exportar servicio web',
        'Import web service' => 'Importar servicio web',
        'Configuration File' => 'Archivo de congiguraci√≥n',
        'The file must be a valid web service configuration YAML file.' =>
            'El archivo de configuraci√≥n del servicio web deber√≠a ser un archivo YAML v√°lido',
        'Import' => 'Importar',
        'Configuration history' => 'Historial de configuraci√≥n',
        'Delete web service' => 'Eliminar servicio web',
        'Do you really want to delete this web service?' => '¬øEsta seguro que desea eliminar este servicio web¬ø',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Despu√©s de guardar la configuraci√≥n usted ser√° redireccionado de nuevo a la ventana de edici√≥n.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Si usted desea regregar a la vista general, por favor presione el bot√≥n "Ir a la vista general".',
        'Web Service List' => 'Listado de servicios web',
        'Remote system' => 'Sistema remoto',
        'Provider transport' => 'Proveedor del transporte',
        'Requester transport' => 'Solicitante del transporte',
        'Details' => 'Detalles',
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
        'Version' => 'Versi√≥n',
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
            'ATENCI√ìN: Cuando cambia el nombre del grupo \'admin\', antes de realizar los cambios apropiados en SysConfig, bloquear√° el panel de administraci√≥n! Si esto sucediera, por favor vuelva a renombrar el grupo para administrar por declaraci√≥n SQL.',
        'Group Management' => 'Administraci√≥n de grupos',
        'Add group' => 'A√±adir grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'El grupo admin es para usar el √°rea de administraci√≥n y el grupo stats para usar el √°rea estadisticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crear grupos nuevos para manejar los permisos de acceso para los diferentes grupos de agentes (por ejemplo: departamento de compras, soporte t√©cnico, ventas, etc.).',
        'It\'s useful for ASP solutions. ' => 'Es √∫til para soluciones ASP.',
        'Add Group' => 'A√±adir Grupo',
        'Edit Group' => 'Modificar Grupo',

        # Template: AdminLog
        'System Log' => 'Log del Sistema',
        'Here you will find log information about your system.' => 'Aqu√≠ puede encontrar informaci√≥n de registros sobre su sistema.',
        'Hide this message' => '',
        'Recent Log Entries' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Administraci√≥n de Cuentas de Correo',
        'Add mail account' => 'A√±adir direcci√≥n de correo',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Todos los correos entrantes con una cuenta ser√°n enviados a la fila seleccionada',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Si su cuenta est√° validada, las cabeceras X-OTRS ya existentes en la llegada se utilizar√°n para la prioridad. El filtro Postmaster se usa de todas formas.',
        'Host' => 'Host',
        'Delete account' => 'Eliminar cuenta',
        'Fetch mail' => 'Obtener correo',
        'Add Mail Account' => 'Agregar Direcci√≥n de Correo',
        'Example: mail.example.com' => 'Ejemplo: correo.ejemplo.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Confiable',
        'Dispatching' => 'Remitiendo',
        'Edit Mail Account' => 'Modificar Direcci√≥n de Correo',

        # Template: AdminNavigationBar
        'Admin' => 'Administraci√≥n',
        'Agent Management' => 'Gesti√≥n de Agentes',
        'Queue Settings' => 'Configuraciones de Fila',
        'Ticket Settings' => 'Configuraciones de Ticket',
        'System Administration' => 'Administraci√≥n del Sistema',

        # Template: AdminNotification
        'Notification Management' => 'Administraci√≥n de Notificaciones',
        'Select a different language' => '',
        'Filter for Notification' => 'Filtro para Notiticaci√≥n',
        'Notifications are sent to an agent or a customer.' => 'Las notificaciones se env√≠an a un agente o cliente',
        'Notification' => 'Notificaciones',
        'Edit Notification' => 'Modificar Notificaci√≥n',
        'e. g.' => 'por ejemplo:',
        'Options of the current customer data' => 'Opciones para los datos del cliente actual',

        # Template: AdminNotificationEvent
        'Add notification' => 'Agregar notificaci√≥n',
        'Delete this notification' => 'Eliminar esta notificaci√≥n',
        'Add Notification' => 'Agregar Notificaci√≥n',
        'Article Filter' => 'Filtro de Art√≠culos',
        'Only for ArticleCreate event' => 'S√≥lo para el evento ArticleCreate',
        'Article type' => 'Tipo de art√≠culo',
        'Article sender type' => '',
        'Subject match' => 'Coincidencia de asunto',
        'Body match' => 'Coincidencia del cuerpo',
        'Include attachments to notification' => 'Incluir archivos adjuntos en la notificaci√≥n',
        'Recipient' => 'Destinatario',
        'Recipient groups' => 'Grupos destinatarios',
        'Recipient agents' => 'Agentes destinatarios',
        'Recipient roles' => 'Roles destinatarios',
        'Recipient email addresses' => 'Direcciones de correo electr√≥nico destinatarias',
        'Notification article type' => 'Tipo de notificaciones de art√≠culo',
        'Only for notifications to specified email addresses' => 'S√≥lo para notificaciones para las direcciones de correo electr√≥nicas especificadas',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para obtener los primeros 20 caracters del Sujeto (del √∫ltimo art√≠culo del agente).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para obtener las primeras 5 l√≠neas del cuerpo (del √∫ltimo art√≠culo del agente).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para obtener los primeros 20 caracters del Sujeto (del √∫ltimo art√≠culo del cliente).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para obtener las primeras 5 l√≠neas del cuerpo (del √∫ltimo art√≠culo del cliente).',

        # Template: AdminPGP
        'PGP Management' => 'Administraci√≥n PGP',
        'Use this feature if you want to work with PGP keys.' => 'Use esta funci√≥n si desea trabajar con llaves PGP.',
        'Add PGP key' => 'Agregar llave PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'De esta forma puede editar directamente el anillo de Claves configurado en Sysconfig',
        'Introduction to PGP' => 'Introducci√≥n a PGP',
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
        'Do you really want to uninstall this package?' => '¬øEst√° seguro de que desea desinstalar este paquete?',
        'Reinstall package' => 'Reinstalar paquete',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '¬øEst√° seguro de que desea reinstalar este paquete? Cualquier cambio manual se perder√°.',
        'Continue' => 'Continuar',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Instalar',
        'Install Package' => 'Instalar Paquete',
        'Update repository information' => 'Actualizar la informaci√≥n del repositorio',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Repositorio Online',
        'Vendor' => 'Vendedor',
        'Module documentation' => 'M√≥dulo de Documentaci√≥n',
        'Upgrade' => 'Actualizar',
        'Local Repository' => 'Repositorio Local',
        'This package is verified by OTRSverify (tm)' => '',
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
        'This feature is enabled!' => 'Esta caracter√≠stica est√° habilitada',
        'Just use this feature if you want to log each request.' => 'Use esta caracter√≠stica s√≥lo si desea registrar cada petici√≥n.',
        'Activating this feature might affect your system performance!' =>
            'Activar esta opci√≥n podr√≠a afectar el rendimiento de su sistema!',
        'Disable it here!' => 'Deshabil√≠telo aqu√≠',
        'Logfile too large!' => 'Archivo de log muy grande',
        'The logfile is too large, you need to reset it' => 'El archivo de registros es muy grande, necesita restablecerlo',
        'Overview' => 'Resumen',
        'Range' => 'Rango',
        'last' => '√∫ltimo',
        'Interface' => 'Interfase',
        'Requests' => 'Solicitudes',
        'Min Response' => 'Respuesta M√≠nima',
        'Max Response' => 'Respuesta M√°xima',
        'Average Response' => 'Respuesta Promedio',
        'Period' => 'Periodo',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Promedio',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Administraci√≥n del filtro maestro',
        'Add filter' => 'Agregar filtro',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para remitir o filtrar correos electr√≥nicos entrantes bas√°ndose en los encabezados de dichos correos. Tambi√©n es posible utilizar Expresiones Regulares para las coincidencias.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Si desea chequear s√≥lo la direcci√≥n del email, use EMAILADDRESS:info@example.com en De, Para o Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Si utiliza Expresiones Regulares, tambi√©n puede utilizar el valor de coincidencia en () como [***] en la acci√≥n de \'Establecer\'.',
        'Delete this filter' => 'Eliminar este filtro',
        'Add PostMaster Filter' => 'A√±adir Filtro de Administraci√≥n de Correo',
        'Edit PostMaster Filter' => 'Modificar Filtro de Administraci√≥n de Correo',
        'The name is required.' => '',
        'Filter Condition' => 'Condici√≥n del Filtro',
        'AND Condition' => '',
        'Negate' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'Establecer los Encabezados del Correo Electr√≥nico',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Administraci√≥n de Prioridades',
        'Add priority' => 'A√±adir prioridad',
        'Add Priority' => 'A√±adir Prioridad',
        'Edit Priority' => 'Modificar Prioridad',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Process Name' => '',
        'Create New Process' => '',
        'Synchronize All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Print' => 'Imprimir',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Cancelar y cerrar la ventana',
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
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
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
        'Fields' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Edit Details for Field' => '',
        'ArticleType' => '',
        'Display' => '',
        'Edit Field Details' => '',
        'Customer interface does not support internal article types.' => '',

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

        # Template: AdminProcessManagementPopupResponse

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
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
        'Save settings' => '',
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
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Remove the Transition from this Process' => '',
        'No TransitionActions assigned.' => '',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => '',
        'Condition' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Configuration' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Remove this Field' => '',
        'Add a new Field' => '',
        'Add New Condition' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Remove this Parameter' => '',
        'Add a new Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => 'Gestionar Filas',
        'Add queue' => 'Agregar fila',
        'Add Queue' => 'Agregar Fila',
        'Edit Queue' => 'Modificar Fila',
        'Sub-queue of' => 'Subfila de',
        'Unlock timeout' => 'Tiempo para desbloqueo autom√°tico',
        '0 = no unlock' => '0 = sin desbloqueo',
        'Only business hours are counted.' => 'S√≥lo se contar√°n las horas de trabajo',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Si un agente bloquea un ticket y no lo cierra antes de que el tiempo de espera termine, dicho ticket se desbloquear√° y estar√° disponible para otros agentes.',
        'Notify by' => 'Notificado por',
        '0 = no escalation' => '0 = sin escalado',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Si no se ha contactado al cliente, ya sea por medio de una nota externa o por tel√©fono, de un ticket nuevo antes de que el tiempo definido aqu√≠ termine, el ticket escalar√°.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Si se a√±ade un art√≠culo, como seguimiento v√≠a correo electr√≥nico o la interfaz del cliente, el tiempo de escalado de actualizaci√≥n se reinicia. Si no se ha contactado al cliente, ya sea por medio de una nota externa o por tel√©fono, de un ticket antes de que el tiempo definido aqu√≠ termine, el ticket escalar√°.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Si el ticket no se cierra antes de que el tiempo definido aqu√≠ termine, dicho ticket escalar√°.',
        'Follow up Option' => 'Opci√≥n de seguimiento',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica si seguimiento a tickets cerrados: reabrir√° dichos tickets, se rechazar√° o generar√° un ticket nuevo.',
        'Ticket lock after a follow up' => 'Bloquear un ticket despu√©s del seguimiento',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Si un ticket est√° cerrado y el cliente le da seguimiento, el ticket se bloquear√° para el antig√ºo propietario.',
        'System address' => 'Direcci√≥n del Sistema',
        'Will be the sender address of this queue for email answers.' => 'Ser√° la direcci√≥n del emisor en esta fila para respuestas por correo.',
        'Default sign key' => 'Llave de firma por defecto',
        'The salutation for email answers.' => 'Saludo para respuestas por correo.',
        'The signature for email answers.' => 'Firma para respuestas por correo.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Administrar Relaciones Fila-Auto Respuesta',
        'Filter for Queues' => 'Filtro para Filas',
        'Filter for Auto Responses' => 'Filtro para Auto Respuestas',
        'Auto Responses' => 'Respuestas Autom√°ticas',
        'Change Auto Response Relations for Queue' => 'Modificar Relaciones de Auto Respuesta para las Filas',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRole
        'Role Management' => 'Administraci√≥n de Roles',
        'Add role' => 'A√±adir rol',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Cree un rol y coloque grupos en el mismo. Luego a√±ada el rol a los usuarios.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'No hay roles definidos. Por favor, use el bot√≥n \'A√±adir\' para crear un rol nuevo.',
        'Add Role' => 'A√±adir Rol',
        'Edit Role' => 'Modificar Rol',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Administrar Relaciones Rol-Grupo',
        'Filter for Roles' => 'Filtro para Roles',
        'Roles' => 'Roles',
        'Select the role:group permissions.' => 'Seleccionar los permisos rol:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Si nada se selecciona, no habr√° permisos para este grupo y los tickets no estar√°n disponibles para el rol.',
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
        'SLA Management' => 'Administraci√≥n de SLA',
        'Add SLA' => 'A√±adir SLA',
        'Edit SLA' => 'Modificar SLA',
        'Please write only numbers!' => '¬°Por favor, escriba s√≥lo n√∫meros!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestion S/MIME',
        'Add certificate' => 'A√±adir certificado',
        'Add private key' => 'A√±adir llave privada',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Vea tambi√©n',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'De esta forma Ud. puede editar directamente la certificaci√≥n y claves privadas en el sistema de archivos.',
        'Hash' => '',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => 'Eliminar este certificado',
        'Add Certificate' => 'A√±adir Certificado',
        'Add Private Key' => 'A√±adir Clave Privada',
        'Secret' => 'Secreto',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'Cerrar ventana',

        # Template: AdminSalutation
        'Salutation Management' => 'Administraci√≥n de Saludos',
        'Add salutation' => 'A√±adir saludo',
        'Add Salutation' => 'A√±adir Saludo',
        'Edit Salutation' => 'Modificar Saludo',
        'Example salutation' => 'Saludo de ejemplo',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => '¬°El modo seguro necesita estar habilitado!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'El Modo Seguro (normalmente) queda habilitado cuando la instalaci√≥n inicial se completa.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si el modo seguro no est√° activo a√∫n, h√°galo a trav√©s de la Configuraci√≥n del Sistema, porque su aplicaci√≥n ya se est√° ejecutando.',

        # Template: AdminSelectBox
        'SQL Box' => 'Consola SQL',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aqu√≠ puede introducir SQL para ejecutarse directamente en la base de datos de la aplicaci√≥n.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'La sintaxis de su consulta SQL tiene un error. Por favor, verif√≠quela.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Existe al menos un par√°metro faltante para en enlace. Por favor, verif√≠quelo.',
        'Result format' => 'Formato del resultado',
        'Run Query' => 'Ejecutar Consulta',

        # Template: AdminService
        'Service Management' => 'Administraci√≥n de Servicios',
        'Add service' => 'A√±adir servicio',
        'Add Service' => 'A√±adir Servicio',
        'Edit Service' => 'Modificar Servicio',
        'Sub-service of' => 'Subservicio de',

        # Template: AdminSession
        'Session Management' => 'Administraci√≥n de Sesiones',
        'All sessions' => 'Todas las sesiones',
        'Agent sessions' => 'Sesiones de agente',
        'Customer sessions' => 'Sesiones de cliente',
        'Unique agents' => 'Agentes √∫nicos',
        'Unique customers' => 'Clientes √∫nicos',
        'Kill all sessions' => 'Finalizar todas las sesiones',
        'Kill this session' => 'Terminar esta sesi√≥n',
        'Session' => 'Sesi√≥n',
        'Kill' => 'Terminar',
        'Detail View for SessionID' => 'Vista detallada para el ID de sesi√≥n',

        # Template: AdminSignature
        'Signature Management' => 'Administraci√≥n de Firmas',
        'Add signature' => 'A√±adir firma',
        'Add Signature' => 'A√±adir Firma',
        'Edit Signature' => 'Modificar Firma',
        'Example signature' => 'Firma de ejemplo',

        # Template: AdminState
        'State Management' => 'Administraci√≥n de Estados',
        'Add state' => 'A√±adir estado',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'A√±adir Estado',
        'Edit State' => 'Modificar Estado',
        'State type' => 'Tipo de Estado',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuraci√≥n del sistema',
        'Navigate by searching in %s settings' => 'Navegar buscando en las configuraciones %s',
        'Navigate by selecting config groups' => 'Navegar por los grupos de configuraci√≥n',
        'Download all system config changes' => 'Descargar todos los cambios en la configuraci√≥n del sistema',
        'Export settings' => 'Exportar configuraciones',
        'Load SysConfig settings from file' => 'Cargar la configuraci√≥n del sistema desde archivo',
        'Import settings' => 'Importar configuraciones',
        'Import Settings' => 'Importar Configuraciones',
        'Please enter a search term to look for settings.' => 'Por favor, introduzca un par√°metro de b√∫squeda para buscar configuraciones.',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Modificar Configuraciones',
        'This config item is only available in a higher config level!' =>
            '¬°Este elemento de configuraci√≥n s√≥lo est√° disponible en un nivel de configuraci√≥n m√°s alto!',
        'Reset this setting' => 'Restablecer esta configuraci√≥n',
        'Error: this file could not be found.' => 'Error: no se encontr√≥ el archivo.',
        'Error: this directory could not be found.' => 'Error: no se encontr√≥ el directorio.',
        'Error: an invalid value was entered.' => 'Error: se introdujo un valor inv√°lido.',
        'Content' => 'Contenido',
        'Remove this entry' => 'Eliminar esta entrada',
        'Add entry' => 'A√±adir entrada',
        'Remove entry' => 'Eliminar entrada',
        'Add new entry' => 'A√±adir una entrada nueva',
        'Delete this entry' => 'Eliminar esta entrada',
        'Create new entry' => 'Crear una entrada nueva',
        'New group' => 'Grupo nuevo',
        'Group ro' => 'Grupo ro',
        'Readonly group' => 'Grupo de s√≥lo lectura',
        'New group ro' => 'Grupo ro nuevo',
        'Loader' => 'Cargador',
        'File to load for this frontend module' => 'Archivo a cargarse para este m√≥dulo frontend',
        'New Loader File' => 'Archivo nuevo para el Cargador',
        'NavBarName' => 'NombreBarraNavegaci√≥n',
        'NavBar' => 'BarraNavegaci√≥n',
        'LinkOption' => 'Opci√≥nEnlace',
        'Block' => 'Bloquear',
        'AccessKey' => 'TeclaAcceso',
        'Add NavBar entry' => 'A√±adir entrada de BarraNavegaci√≥n',
        'Year' => 'A√±o',
        'Month' => 'Mes',
        'Day' => 'D√≠a',
        'Invalid year' => 'A√±o inv√°lido',
        'Invalid month' => 'Mes inv√°lido',
        'Invalid day' => 'D√≠a inv√°lido',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Administraci√≥n de Direcciones de Correo del sistema',
        'Add system address' => 'A√±adir direcci√≥n del sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todos los correos electr√≥nicos entrantes con esta direcci√≥n en Para o Cc ser√°n enviados a la fila seleccionada.',
        'Email address' => 'Direcci√≥n de correo electr√≥nico',
        'Display name' => 'Nombre mostrado',
        'Add System Email Address' => 'Agregar Direcci√≥n de Correo Electr√≥nico del Sistema',
        'Edit System Email Address' => 'Modificar Direcci√≥n de Correo Electr√≥nico del Sistema',
        'The display name and email address will be shown on mail you send.' =>
            'El nombre a mostrar y la direcci√≥n de correo electr√≥nico se agregar√°n en los correos que ud. env√≠e.',

        # Template: AdminTemplate
        'Manage Templates' => '',
        'Add template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Add Template' => '',
        'Edit Template' => '',
        'Template' => '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'El estado actual del ticket es',
        'Your email address is' => 'Su direcci√≥n de correo electr√≥nico es',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => 'Filtro para Archivos Adjuntos',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Activar para todos',
        'Link %s to selected %s' => 'V√≠nculo %s a %s seleccionados(as)',

        # Template: AdminType
        'Type Management' => 'Administraci√≥n de Tipos',
        'Add ticket type' => 'A√±adir tipo de ticket',
        'Add Type' => 'A√±adir Tipo',
        'Edit Type' => 'Modificar Tipo',

        # Template: AdminUser
        'Add agent' => 'A√±adir agente',
        'Agents will be needed to handle tickets.' => 'Los agentes se requieren para que se encarguen de los tickets.',
        'Don\'t forget to add a new agent to groups and/or roles!' => '¬°Recuerde a√±adir a los agentes nuevos a grupos y/o roles!',
        'Please enter a search term to look for agents.' => 'Por favor, introduzca un par√°metro de b√∫squeda para buscar agentes.',
        'Last login' => '√öltimo inicio de sesi√≥n',
        'Switch to agent' => 'Cambiar a agente',
        'Add Agent' => 'A√±adir Agente',
        'Edit Agent' => 'Modificar Agente',
        'Firstname' => 'Nombre',
        'Lastname' => 'Apellido',
        'Will be auto-generated if left empty.' => '',
        'Start' => 'Iniciar',
        'End' => 'Fin',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gestionar Relaciones Agente-Grupo',
        'Change Group Relations for Agent' => 'Modificar Relaciones de Grupo para los Agentes',
        'Change Agent Relations for Group' => 'Modificar Relaciones de Agente para los Grupos',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permisos para a√±adir notas a los tickets de este/a grupo/fila',
        'owner' => 'propietario',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permisos para modificar el propietario de los tickets en este/a grupo/fila.',

        # Template: AgentBook
        'Address Book' => 'Libreta de Direcciones',
        'Search for a customer' => 'Buscar un cliente',
        'Add email address %s to the To field' => 'A√±adir direcci√≥n de correo electr√≥nico %s al campo Para',
        'Add email address %s to the Cc field' => 'A√±adir direcci√≥n de correo electr√≥nico %s al campo Cc',
        'Add email address %s to the Bcc field' => 'A√±adir direcci√≥n de correo electr√≥nico %s al campo Bcc',
        'Apply' => 'Aplicar',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ID del Cliente',
        'Customer User' => 'Cliente',

        # Template: AgentCustomerSearch
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Panel principal',

        # Template: AgentDashboardCalendarOverview
        'in' => 'en',

        # Template: AgentDashboardCommon
        'Available Columns' => '',
        'Visible Columns (order by drag & drop)' => '',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s est√° disponible!',
        'Please update now.' => 'Por fav√≥r, actualize ahora',
        'Release Note' => 'Notas de versi√≥n',
        'Level' => 'Nivel',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Enviado hace %s.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mis tickets bloqueados',
        'My watched tickets' => 'Mis tickets en observaci√≥n',
        'My responsibilities' => 'Mis responsabilidades',
        'Tickets in My Queues' => 'Tickets en mis filas',
        'Service Time' => 'Tiempo de Servicio',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'El ticket ha sido bloqueado',
        'Undo & close window' => 'Deshacer y cerrar la ventana',

        # Template: AgentInfo
        'Info' => 'Informaci√≥n',
        'To accept some news, a license or some changes.' => 'Para aceptar noticias, una licencia o algunos cambios.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Objeto Vinculado: %s',
        'go to link delete screen' => 'ir a la ventana del v√≠nculo de eliminar',
        'Select Target Object' => 'Seleccionar Objetivo',
        'Link Object' => 'Enlazar Objeto',
        'with' => 'con',
        'Unlink Object: %s' => 'Objecto desvinculado: %s',
        'go to link add screen' => 'ir a la ventana del v√≠nculo de a√±adir',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Modificar mis preferencias',

        # Template: AgentSpelling
        'Spell Checker' => 'Chequeo Ortogr√°fico',
        'spelling error(s)' => 'errores ortogr√°ficos',
        'Apply these changes' => 'Aplicar los cambios',

        # Template: AgentStatsDelete
        'Delete stat' => 'Eliminar estad√≠stica',
        'Stat#' => 'Estad√≠stica#',
        'Do you really want to delete this stat?' => '¬øRealmente desea eliminar esta estad√≠stica?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Paso %s',
        'General Specifications' => 'Especificaciones Generales',
        'Select the element that will be used at the X-axis' => 'Seleccione el elemento que se utilizar√° en el eje X',
        'Select the elements for the value series' => 'Seleccione los elementos para los valores de la serie',
        'Select the restrictions to characterize the stat' => 'Seleccione las restricciones para caracterizar la estad√≠stica',
        'Here you can make restrictions to your stat.' => 'Aqu√≠ puede declarar restricciones para sus estad√≠sticas.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Si elimina el candado en la casilla "Fijo", el agente que genera la estad√≠stica puede cambiar los atributos del elemento correspondiente',
        'Fixed' => 'Fijo',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor seleccione s√≥lo un elemento o desactive el bot√≥n \'Fijo\.',
        'Absolute Period' => 'Periodo Absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Periodo Relativo',
        'The last' => 'El √∫ltimo',
        'Finish' => 'Finalizar',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permisos',
        'You can select one or more groups to define access for different agents.' =>
            'Puede seleccionar uno o m√°s grupos para definir el acceso para los diferentes agentes.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Algunos formatos de resultado est√°n deshabilitados porque al menos un paquete requerido no est√° instalado.',
        'Please contact your administrator.' => 'Por favor, contacte a su administrador.',
        'Graph size' => 'Tama√±o del gr√°fico',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Si utiliza un gr√°fico como formato de salida debe seleccionar al menos un tama√±o de gr√°fico.',
        'Sum rows' => 'Sumar filas',
        'Sum columns' => 'Sumar columnas',
        'Use cache' => 'Usar cach√©',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'La mayor√≠a de las estadisticas pueden ser conservadas en cache. Esto acelera la presentaci√≥n de esta estad√≠stica.',
        'If set to invalid end users can not generate the stat.' => 'Si se define como inv√°lida, los usuarios finales no podr√°n generar la estad√≠stica.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Aqu√≠ se pueden definir los valores de la serie.',
        'You have the possibility to select one or two elements.' => 'Puede seleccionar uno o dos elementos.',
        'Then you can select the attributes of elements.' => 'Luego puede seleccionar los atributos de los elementos.',
        'Each attribute will be shown as single value series.' => 'Cada atributo se mostrar√° como un solo valor de la serie.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Si no selecciona alg√∫n atributo, todos los atributos del elemento se usar√°n si se genera una estad√≠stica, as√≠ como atributos nuevos que se hayan agregado desde la √∫ltima configuraci√≥n.',
        'Scale' => 'Escala',
        'minimal' => 'm√≠nimo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Recuerde, la escala para los valores de la serie debe ser mayor que la escala para el eje-X (ej: eje-X => Mes, ValorSeries => A√±o).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Aqu√≠ puede definir el eje X. Puede seleccionar un elemento por medio del bot√≥n de radio.',
        'maximal period' => 'periodo m√°ximo',
        'minimal scale' => 'escala m√≠nima',

        # Template: AgentStatsImport
        'Import Stat' => 'Importar estad√≠stica',
        'File is not a Stats config' => 'El archivo no es una configuraci√≥n de estad√≠sticas',
        'No File selected' => 'No hay archivo seleccionado',

        # Template: AgentStatsOverview
        'Stats' => 'Estad√≠sticas',

        # Template: AgentStatsPrint
        'No Element selected.' => 'No hay elemento seleccionado',

        # Template: AgentStatsView
        'Export config' => 'Exportar configuraci√≥n',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Con los campos de entrada y selecci√≥n es posible influir en el formato y contenido de la estad√≠stica.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Los campos de entrada y formatos exactos que se pueden infuenciar son definidos por el administrador de la estad√≠stica.',
        'Stat Details' => 'Detalles de la estad√≠stica',
        'Format' => 'Formato',
        'Graphsize' => 'Tama√±o de la Gr√°fica',
        'Cache' => 'Cach√©',
        'Exchange Axis' => 'Intercambiar Ejes',
        'Configurable params of static stat' => 'Par√°metro configurable de estad√≠stica est√°tica',
        'No element selected.' => 'No hay elemento seleccionado',
        'maximal period from' => 'periodo m√°ximo desde',
        'to' => 'a',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Modificar los Campos Libres del Ticket',
        'Change Owner of Ticket' => 'Cambiar el Propietario del Ticket',
        'Close Ticket' => 'Cerrar Ticket',
        'Add Note to Ticket' => 'Agregarle una Nota al Ticket',
        'Set Pending' => 'Establecer como pendiente',
        'Change Priority of Ticket' => 'Cambiar la Prioridad del Ticket',
        'Change Responsible of Ticket' => 'Cambiar el Responsable del Ticket',
        'Service invalid.' => 'Servicio inv√°lido.',
        'New Owner' => 'Propietario nuevo',
        'Please set a new owner!' => 'Por favor, defina un propietario nuevo.',
        'Previous Owner' => 'Propietario Anterior',
        'Inform Agent' => 'Notificar a Agente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Notificar a Agentes involucrados',
        'Spell check' => 'Corrector ortogr√°fico',
        'Note type' => 'Tipo de nota',
        'Next state' => 'Siguiente estado',
        'Date invalid!' => '¬°Fecha inv√°lida!',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Rebotar a',
        'You need a email address.' => 'Se requiere una direcci√≥n de correo electr√≥nico.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Se requiere una direcci√≥n de correo electr√≥nica v√°lida, que no sea local.',
        'Next ticket state' => 'Nuevo estado del ticket',
        'Inform sender' => 'Informar al emisor',
        'Send mail!' => 'Enviar correo',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Acci√≥n m√∫ltiple con Tickets',
        'Send Email' => '',
        'Merge to' => 'Fusionar con',
        'Invalid ticket identifier!' => '¬°Identificador de ticket inv√°lido!',
        'Merge to oldest' => 'Combinar con el mas viejo',
        'Link together' => 'Enlazar juntos',
        'Link to parent' => 'Enlazar al padre',
        'Unlock tickets' => 'Desbloquear tickets',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Redacte una respuesta para el ticket',
        'Please include at least one recipient' => '',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Agenda de direcciones',
        'Pending Date' => 'Fecha pendiente',
        'for pending* states' => 'en estado pendiente*',
        'Date Invalid!' => '¬°Fecha Inv√°lida!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Cambiar cliente del ticket',
        'Customer user' => 'Cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Crear un Ticket nuevo de Correo Electr√≥nico',
        'From queue' => 'De la fila',
        'To customer' => '',
        'Please include at least one customer for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Get all' => 'Obtener todos',
        'Text Template' => '',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Historia de',
        'History Content' => 'Contenido de la Historia',
        'Zoom view' => 'Vista detallada',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Fusionar Ticket',
        'You need to use a ticket number!' => '¬°Necesita usar un n√∫mero de ticket!',
        'A valid ticket number is required.' => 'Se requiere un n√∫mero de ticket v√°lido.',
        'Need a valid email address.' => 'Se require una direcci√≥n de correo electr√≥nica v√°lida.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Mover Ticket',
        'New Queue' => 'Fila nueva',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Seleccionar todos',
        'No ticket data found.' => 'No se encontraron datos de ticket.',
        'First Response Time' => 'Tiempo para Primera Respuesta',
        'Update Time' => 'Tiempo para Actualizaci√≥n',
        'Solution Time' => 'Tiempo para Soluci√≥n',
        'Move ticket to a different queue' => 'Mover ticket a una fila diferente',
        'Change queue' => 'Modificar fila',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Cambiar opciones de b√∫squeda',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => '',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Crear un Ticket Telef√≥nico Nuevo',
        'From customer' => 'Del cliente',
        'To queue' => 'Para la fila',

        # Template: AgentTicketPhoneCommon

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Vista de correo electr√≥nico sin formato',
        'Plain' => 'Texto plano',
        'Download this email' => 'Descargar este correo electr√≥nico',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informacion-Ticket',
        'Accounted time' => 'Tiempo contabilizado',
        'Linked-Object' => 'Objeto-vinculado',
        'by' => 'por',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Buscar-Modelo',
        'Create Template' => 'Crear Plantilla',
        'Create New' => 'Crear Nuevo(a)',
        'Profile link' => '',
        'Save changes in template' => 'Guardar los cambios en la plantilla',
        'Add another attribute' => 'A√±adir otro atributo',
        'Output' => 'Modelo de Resultados',
        'Fulltext' => 'Texto Completo',
        'Remove' => 'Quitar',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Nombre de inicio de sesi√≥n del cliente',
        'Created in Queue' => 'Creado en Fila',
        'Lock state' => 'Estado de bloqueo',
        'Watcher' => 'Observador',
        'Article Create Time (before/after)' => 'Tiempo de Creaci√≥n del Art√≠culo (antes/despu√©s)',
        'Article Create Time (between)' => 'Tiempo de Creaci√≥n del Art√≠culo (entre)',
        'Ticket Create Time (before/after)' => 'Tiempo de Creaci√≥n del Ticket (antes/despu√©s)',
        'Ticket Create Time (between)' => 'Tiempo de Creaci√≥n del Ticket (entre)',
        'Ticket Change Time (before/after)' => 'Tiempo de Modificaci√≥n del Ticket (antes/despu√©s)',
        'Ticket Change Time (between)' => 'Tiempo de Modificaci√≥n del Ticket (entre)',
        'Ticket Close Time (before/after)' => 'Tiempo de Cierre del Ticket (antes/despu√©s)',
        'Ticket Close Time (between)' => 'Tiempo de Cierre del Ticket (entre)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'B√∫squeda de Archivo',
        'Run search' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro de art√≠culos',
        'Article Type' => 'Tipo de art√≠culo',
        'Sender Type' => '',
        'Save filter settings as default' => 'Grabar configuraci√≥n de filtros como defecto',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Locked' => 'Bloqueado',
        'Linked Objects' => 'Objetos Enlazados',
        'Article(s)' => 'Art√≠culo(s)',
        'Change Queue' => 'Cambiar Fila',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Add Filter' => 'A√±adir Filtro',
        'Set' => 'Ajustar',
        'Reset Filter' => 'Restablecer Filtro',
        'Show one article' => 'Mostrar un art√≠culo',
        'Show all articles' => 'Mostrar todos los art√≠culos',
        'Unread articles' => 'Art√≠culos no le√≠dos',
        'No.' => 'N√∫m.',
        'Important' => 'Importante',
        'Unread Article!' => '¬°Art√≠culo sin leer!',
        'Incoming message' => 'Mensaje entrante',
        'Outgoing message' => 'Mensaje saliente',
        'Internal message' => 'Mensaje interno',
        'Resize' => 'Cambiar el tama√±o',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Cargar contenido bloqueado.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Determinar el origen',

        # Template: CustomerFooter
        'Powered by' => 'Impulsado por',
        'One or more errors occurred!' => '¬°Ha ocurrido al menos un error!',
        'Close this dialog' => 'Cerrar este di√°logo',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'No se pudo abrir la ventana pop-up. Por favor, deshabilite cualquier bloqueador de pop-ups para esta aplicaci√≥n.',
        'There are currently no elements available to select from.' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript No Disponible',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Para utilizar OTRS correctamente, es necesario que habilite JavaScript en su explorador web.',
        'Browser Warning' => 'Advertencia del Explorador',
        'The browser you are using is too old.' => 'El explorador que est√° usando es muy antiguo.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS correo en una amplia lista de exploradores, por favor utilice alguno de ellos.',
        'Please see the documentation or ask your admin for further information.' =>
            'Por favor, refi√©rase a la documentaci√≥n o pregunte a su administrador para obtener m√°s informaci√≥n.',
        'Login' => 'Identificador',
        'User name' => 'Nombre de usuario',
        'Your user name' => 'Su nombre de usuario',
        'Your password' => 'Su contrase√±a',
        'Forgot password?' => '¬øOlvid√≥ su contrase√±a?',
        'Log In' => 'Iniciar sesi√≥n',
        'Not yet registered?' => '¬øA√∫n no se ha registrado?',
        'Sign up now' => 'Inscr√≠base ahora',
        'Request new password' => 'Solicitar una nueva contrase√±a',
        'Your User Name' => 'Su Nombre de Usuario',
        'A new password will be sent to your email address.' => 'Una contrase√±a nueva se enviar√° a su direcci√≥n de correo electr√≥nico.',
        'Create Account' => 'Crear Cuenta',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'C√≥mo debemos contactarlo',
        'Your First Name' => 'Su Nombre',
        'Your Last Name' => 'Su Apellido',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Modificar preferencias presonales',
        'Logout %s' => 'Cerrar Sesi√≥n %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Acuerdo de nivel de servicio',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bienvenido',
        'Please click the button below to create your first ticket.' => 'Por favor, presione el bot√≥n crear ticket, para crear su primer requerimiento',
        'Create your first ticket' => 'Crear Ticket',

        # Template: CustomerTicketPrint
        'Ticket Print' => '',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'Por ejemplo: 10*5155 √≥ 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Texto de b√∫squeda en los tickets (por ejemplo: "John*n" o "Will*")',
        'Carbon Copy' => 'Copia al Carb√≥n',
        'Types' => 'Tipos',
        'Time restrictions' => 'Restricciones de tiempo',
        'No time settings' => '',
        'Only tickets created' => '√önicamente tickets creados',
        'Only tickets created between' => '√önicamente tickets creados entre',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => '¬øGuardar como Plantilla?',
        'Save as Template' => '',
        'Template Name' => 'Nombre de la Plantilla',
        'Pick a profile name' => '',
        'Output to' => 'Salida a',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Page' => 'P√°gina',
        'Search Results for' => 'Buscar Resultados para',

        # Template: CustomerTicketZoom
        'Expand article' => '',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'Responder',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
        'Sunday' => 'Domingo',
        'Monday' => 'Lunes',
        'Tuesday' => 'Martes',
        'Wednesday' => 'Mi√©rcoles',
        'Thursday' => 'Jueves',
        'Friday' => 'Viernes',
        'Saturday' => 'S√°bado',
        'Su' => 'Dom',
        'Mo' => 'Lun',
        'Tu' => 'Mar',
        'We' => 'Mi√©r',
        'Th' => 'Jue',
        'Fr' => 'Vier',
        'Sa' => 'S√°b',
        'Event Information' => '',
        'Ticket fields' => '',
        'Dynamic fields' => '',

        # Template: Datepicker
        'Invalid date (need a future date)!' => '¬°Fecha inv√°lida (se requiere una fecha futura)!',
        'Previous' => 'Previo(a)',
        'Open date selection' => 'Abrir fecha seleccionada',

        # Template: Error
        'Oops! An Error occurred.' => 'Se produjo un error.',
        'Error Message' => 'Mensaje de error',
        'You can' => 'Usted puede',
        'Send a bugreport' => 'Enviar un reporte de error',
        'go back to the previous page' => 'regresar a la p√°gina anterior',
        'Error Details' => 'Detalles del error',

        # Template: Footer
        'Top of page' => 'Inicio de la p√°gina',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Si sale de esta p√°gina ahora, todas las ventanas pop-up tambi√©n se cerrar√°n.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Ya hay una pop-up abierta de esta pantalla. ¬øDesea cerrarla y cargar esta en su lugar?',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Ud. inici√≥ sesi√≥n como',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript no disponible',
        'Database Settings' => 'Configuraciones de la Base de Datos',
        'General Specifications and Mail Settings' => 'Especificaciones Generales y Configuraciones de Correo',
        'Registration' => '',
        'Welcome to %s' => 'Bienvenido a %s',
        'Web site' => 'Sitio web',
        'Mail check successful.' => 'Verificaci√≥n satisfactoria de correo',
        'Error in the mail settings. Please correct and try again.' => 'Error en las configuraciones de lcorreo. Por favor, corr√≠jalas y vuelva a intentarlo.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurar Correo Saliente',
        'Outbound mail type' => 'Tipo de correo saliente',
        'Select outbound mail type.' => 'Seleccione el tipo de correo saliente.',
        'Outbound mail port' => 'Puerto para el correo saliente',
        'Select outbound mail port.' => 'Selecione el puerto para el correo saliente.',
        'SMTP host' => 'Host SMTP',
        'SMTP host.' => 'Host SMTP.',
        'SMTP authentication' => 'Autenticaci√≥n SMTP',
        'Does your SMTP host need authentication?' => '¬øSu host SMTP requiere autenticaci√≥n?',
        'SMTP auth user' => 'Autenticaci√≥n de usuario SMTP',
        'Username for SMTP auth.' => 'Nombre de usuario para la autenticaci√≥n SMTP.',
        'SMTP auth password' => 'Contrase√±a de autenticaci√≥n SMTP',
        'Password for SMTP auth.' => 'Contrase√±a para la autenticaci√≥n SMTP.',
        'Configure Inbound Mail' => 'Configurar Correo Entrante',
        'Inbound mail type' => 'Tipo de correo entrante',
        'Select inbound mail type.' => 'eleccione el tipo de correo entrante.',
        'Inbound mail host' => 'Host del correo entrante',
        'Inbound mail host.' => 'Host del correo entrante.',
        'Inbound mail user' => 'Usuario del correo entrante',
        'User for inbound mail.' => 'Usuario para el correo entrante.',
        'Inbound mail password' => 'Contrase√±a del correo entrante',
        'Password for inbound mail.' => 'Contrase√±a para el correo entrante.',
        'Result of mail configuration check' => 'Resultado de la verificaci√≥n de la configuraci√≥n de correo.',
        'Check mail configuration' => 'Verificar configuraci√≥n de correo',
        'Skip this step' => 'Omitir este paso',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Base de datos configurada con √©xito!',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => 'Verificar las configuraciones de la base de datos',
        'Result of database check' => 'Resultado de la verificaci√≥n de la base de datos',
        'OK' => '',
        'Database check successful.' => 'Verificaci√≥n satisfactoria de la base de datos',
        'Database User' => '',
        'New' => 'Nuevo',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Un usuario nuevo, con permisos limitados, se crear√° en este sistema OTRS, para la base de datos.',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerDBpostgresql

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para poder utilizar OTRS debe escribir la siguiente l√≠nea en la consola de sistema (Terminal/Shell) como usuario root',
        'Restart your webserver' => 'Reinicie su servidor web',
        'After doing so your OTRS is up and running.' => 'Despu√©s de hacer esto, su OTRS estar√° activo y ejecut√°ndose',
        'Start page' => 'P√°gina de inicio',
        'Your OTRS Team' => 'Su equipo OTRS',

        # Template: InstallerLicense
        'Accept license' => 'Aceptar licencia',
        'Don\'t accept license' => 'No aceptar licencia',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organizaci√≥n',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'ID de sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identificador del sistema. Todos los n√∫meros de tickets e ID\'s de sesiones HTTP contendr√°n este n√∫mero.',
        'System FQDN' => 'FQDN del sistema',
        'Fully qualified domain name of your system.' => 'Nombre de dominio totalmente calificado de su sistema.',
        'AdminEmail' => 'Correo del Administrador.',
        'Email address of the system administrator.' => 'Direcci√≥n de correo electr√≥nico del administrador del sistema.',
        'Log' => 'Log',
        'LogModule' => 'M√≥duloLog',
        'Log backend to use.' => 'Backend a usar para el log.',
        'LogFile' => 'ArchivoLog',
        'Webfrontend' => 'Interface Web',
        'Default language' => 'Idioma por defecto',
        'Default language.' => 'Idioma por defecto.',
        'CheckMXRecord' => 'Revisar record MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Las direcciones de correo electr√≥nico que se proporcionan manualmente, se verifican con los records MX encontrados en el DNS. No utilice esta opcion si su DNS es lento o no resuelve direcciones p√∫blicas.',

        # Template: LinkObject
        'Object#' => 'Objecto#',
        'Add links' => 'Agregar enlaces',
        'Delete links' => 'Eliminar enlaces',

        # Template: Login
        'Lost your password?' => '¬øPerdi√≥ su contrase√±a?',
        'Request New Password' => 'Solicite una Contrase√±a Nueva',
        'Back to login' => 'Regresar al inicio de sesi√≥n',

        # Template: Motd
        'Message of the Day' => 'Mensaje del d√≠a',

        # Template: NoPermission
        'Insufficient Rights' => 'Permisos insuficientes',
        'Back to the previous page' => 'Volver a la p√°gina anterior',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Mostrar la primera p√°gina',
        'Show previous pages' => 'Mostrar la p√°gina anterior',
        'Show page %s' => 'Mostrar la p√°gina %s',
        'Show next pages' => 'Mostrar la p√°gina siguiente',
        'Show last page' => 'Mostrar la √∫ltima p√°gina',

        # Template: PictureUpload
        'Need FormID!' => 'Se necesita el ID del Formulario',
        'No file found!' => '¬°No se encontr√≥ el archivo!',
        'The file is not an image that can be shown inline!' => '¬°El archivo no es una imagen que se pueda mostrar en l√≠nea!',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'impreso por',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'P√°gina de Prueba de OTRS',
        'Welcome %s' => 'Bienvenido %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Regresar a la p√°gina anterior',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'M√≥dulo ACL que permite cerrar los tickets padre √∫nicamente si todos sus hijos ya est√°n cerrados ("Estado" muestra cu√°les estados no est√°n disponibles para el ticket padre, hasta que todos sus hijos est√©n cerrados).',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Activa un mecanismo de parpadeo para la fila que contiene el ticket m√°s antiguo.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Activa la funci√≥n de contrase√±a perdida para agentes, en la interfaz de los mismos.',
        'Activates lost password feature for customers.' => 'Activa la funci√≥n de contrase√±a perdida para clientes.',
        'Activates support for customer groups.' => 'Activa soporte para grupos de clientes.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Activa el filtro de art√≠culos en la vista detallada para especificar qu√© art√≠culos deben mostrarse.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Activa los temas disponibles en el sistema. Valor 1 significa activo, 0 es inactivo.',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Activa el sistema de archivo de tickets para tener un sistema m√°s r√°pido, al mover algunos tickets fuera del √°mbito diario. Para buscar estos tickets, la bandera de archivo tiene que estar habilitada en la ventana de b√∫squeda.',
        'Activates time accounting.' => 'Activa la contatibilidad de tiempo.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'A√±ade un sufijo con el a√±o y mes actuales al archivo log de OTRS. Se generar√° un archivo log distinto para cada mes.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os). Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Agent Notifications' => 'Notificaciones para Agentes',
        'Agent interface article notification module to check PGP.' => 'M√≥dulo de notificaci√≥n de art√≠culos de la interfaz del agente para verificar PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'M√≥dulo de notificaci√≥n de art√≠culos de la interfaz del agente para verificar S/MIME.',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'M√≥dulo de la interfaz del agente para acceder al texto de b√∫squeda, a trav√©s de la barra de navegaci√≥n.',
        'Agent interface module to access search profiles via nav bar.' =>
            'M√≥dulo de la interfaz del agente para acceder a los perfiles de b√∫squeda, a trav√©s de la barra de navegaci√≥n.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'M√≥dulo de la interfaz del agente para verificar los correos electr√≥nicos entrantes, en la vista detallada del ticket, si la llave S/MIME est√° disponible y es verdadera.',
        'Agent interface notification module to check the used charset.' =>
            'M√≥dulo de notificaci√≥n de la interfaz del agente para verificar el juego de caracteres usado.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'M√≥dulo de notificaci√≥n de la interfaz del agente para visualizar el n√∫mero de tickets por los cuales un agente es responsable.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'M√≥dulo de notificaci√≥n de la interfaz del agente para visualizar el n√∫mero de tickets monitoreados.',
        'Agents <-> Groups' => 'Agentes <-> Grupos',
        'Agents <-> Roles' => 'Agentes <-> Roles',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Permite a√±adir notas en la ventana de cerrar ticket, en la interfaz del agente.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Permite a√±adir notas en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Permite a√±adir notas en la ventana de nota de ticket, en la interfaz del agente.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permite a√±adir notas en la ventana de propietario del ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permite a√±adir notas en la ventana de ticket pendiente, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permite a√±adir notas en la ventana de prioridad del ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Permite a√±adir notas en la ventana de responsable del ticket, en la interfaz del agente.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permite a los agentes intercambiar los ejes de la estad√≠stica al generar una.',
        'Allows agents to generate individual-related stats.' => 'Permite a los agentes generar estad√≠sticas relacionadas individualmente.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permite elegir entre mostrar los archivos adjuntos de un ticket en el explorador (en l√≠nea), o simplemente permitir descargarlos.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permite elegir el siguiente estado del ticket al redactar un art√≠culo, en la interfaz del cliente.',
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
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permite definir nuevos tipos para los tickets (si la funcionalidad de tipo de ticket est√° habilitada).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir servicios y SLAs para los tickets (por ejemplo: correo electr√≥nico, escritorio, red, etc.), as√≠ mismo como atributos para los SLAs (si la funcionalidad servicio/SLA est√° habilitada).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite el uso de condiciones de b√∫squeda extendida al buscar tickets en la interfaz del cliente. Con esta funcionalidad, es posible buscar condiciones como, por ejemplo, "(llave1&&llave2)" o "(llave1||llave2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite tener un formato de vista mediana para los tickets (Informaci√≥nCliente => 1 - muestra adem√°s la informaci√≥n del cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite tener un formato de vista peque√±a para los tickets (Informaci√≥nCliente => 1 - muestra adem√°s la informaci√≥n del cliente).',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permite al administrador iniciar sesi√≥n como otros usuarios, a trav√©s del panel de administraci√≥n de los mismos.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permite definir el estado de un ticket nuevo, en la ventana de mover ticket de la interfaz del agente.',
        'ArticleTree' => '',
        'Attachments <-> Templates' => '',
        'Auto Responses <-> Queues' => 'Respuestas Autom√°ticas <-> Filas',
        'Automated line break in text messages after x number of chars.' =>
            'Salto de l√≠nea autom√°tico en los mensajes de texto despu√©s de x n√∫mero de caracteres.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Bloquear autom√°ticamente y establecer como propietario al agente actual, luego de elegir realizar una Acci√≥n m√∫ltiple con Tickets.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Establecer autom√°ticamente como responsable de un ticket al propietario del mismo (si la funcionalidad de responsable del ticket est√° habilitada).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Establecer autom√°ticamente el responsable de un ticket (si no est√° definido a√∫n), luego de realizar la primera actualizaci√≥n de propietario.',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Piel blanca balanceda dise√±ada por Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Bloquea todos los correos electr√≥nicos entrantes que no tienen un n√∫mero de ticket v√°lido en el asunto con direcci√≥n De: @ejemplo.com.',
        'Builds an article index right after the article\'s creation.' =>
            'Crea un √≠ndice de art√≠culos justo despu√©s de la creaci√≥n del art√≠culo.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Ejemplo de configuraci√≥n CMD. Ignora correos electr√≥nicos donde el CMD externo regresa alguna salida en STDOUT (los correos electr√≥nicos ser√°n dirigidos a STDIN de some.bin).',
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
        'Change password' => 'Cambiar contrase√±a',
        'Change queue!' => 'Cambiar fila',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Cambia el propietario de los tickets a todos (√∫til para ASP). Normalmente s√≥lo se mostrar√°n los agentes con permiso rw en la fila del ticket.',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Verifica el ID del sistema en la detecci√≥n de n√∫meros de tickets para los seguimientos (use "No" si el ID del sistema se cambi√≥ despu√©s de empezar a utilizar OTRS).',
        'Closed tickets of customer' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled. Note: no more columns are allowed and will be discarded.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Comentario para entradas nuevas en la historia, en la interfaz del cliente.',
        'Company Status' => '',
        'Company Tickets' => 'Tickets de la Compa√±√≠a',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Define es posible que los clientes ordenen sus tickets.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Convierte correos HTML en mensajes de texto.',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Crear y gestionar Acuerdos de Nivel de Servicio (SLAs).',
        'Create and manage agents.' => 'Crear y gestionar agentes.',
        'Create and manage attachments.' => 'Crear y gestionar archivos adjuntos.',
        'Create and manage companies.' => 'Crear y gestionar compa√±√≠as.',
        'Create and manage customers.' => 'Crear y gestionar clientes.',
        'Create and manage dynamic fields.' => 'Crear y gestionar Campos din√°micos.',
        'Create and manage event based notifications.' => 'Crear y gestionar notificaciones basadas en eventos.',
        'Create and manage groups.' => 'Crear y gestionar grupos.',
        'Create and manage queues.' => 'Crear y gestionar filas.',
        'Create and manage responses that are automatically sent.' => 'Crear y gestionar respuestas enviadas de forma autom√°tica.',
        'Create and manage roles.' => 'Crear y gestionar roles.',
        'Create and manage salutations.' => 'Crear y gestionar saludos.',
        'Create and manage services.' => 'Crear y gestionar servicios.',
        'Create and manage signatures.' => 'Crear y gestionar firmas.',
        'Create and manage templates.' => '',
        'Create and manage ticket priorities.' => 'Crear y gestionar las prioridades del ticket.',
        'Create and manage ticket states.' => 'Crear y gestionar los estados del ticket.',
        'Create and manage ticket types.' => 'Crear y gestionar los tipos de ticket.',
        'Create and manage web services.' => 'Crear y gestionar servicios web',
        'Create new email ticket and send this out (outbound)' => 'Crear un ticket de correo electr√≥nico nuevo y mandarlo (saliente)',
        'Create new phone ticket (inbound)' => 'Crear un ticket telef√≥nico nuevo (entrante)',
        'Create new process ticket' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            'Texto personalizado que ver√°n los clientes que a√∫n no han creado tickets.',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Clientes',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Clientes <-> Grupos',
        'Customers <-> Services' => 'Clientes <-> Servicios',
        'Data used to export the search result in CSV format.' => 'Datos usados para exportar el resultado de la b√∫squeda a formato CSV.',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Depura el conjunto de traducci√≥n. Si se selecciona "S√≠", todas las cadenas de texto sin traducci√≥n se escriben en STDERR. Esto puede ser √∫til al crear archivos de traducci√≥n, de otra manera, esta opci√≥n deber√≠a permanecer en "No".',
        'Default ACL values for ticket actions.' => 'Valores ACL por defecto para las acciones de ticket.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'M√≥dulo de protecci√≥n de bucle por defecto.',
        'Default queue ID used by the system in the agent interface.' => 'ID de fila usado por defecto por el sistema, en la interfaz del agente.',
        'Default skin for OTRS 3.0 interface.' => 'Piel por defecto para la interfaz OTRS 3.0.',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de ticket usado por defecto por el sistema, en la interfaz del agente.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de ticket usado por defecto por el sistema, en la interfaz del cliente.',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para la salida html para a√±adir v√≠nculos a ciertas cadenas. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de im√°genes de OTRS. La otra posibilidad es insertar el v√≠nculo a la imagen.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set manually. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => 'Define el d√≠a inicial de la para el selector de fecha.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Define un art√≠culo de cliente que genera un √≠cono de VinculadoEn, al final de un bloque de informaci√≥n de cliente.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Define un art√≠culo de cliente que genera un √≠cono de XING, al final de un bloque de informaci√≥n de cliente.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Define un art√≠culo de cliente que genera un √≠cono de google, al final de un bloque de informaci√≥n de cliente.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Define un art√≠culo de cliente que genera un √≠cono de mapas google, al final de un bloque de informaci√≥n de cliente.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Define una lista de palabras por defecto, que son ignoradas por el corrector de ortograf√≠a.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para a√±adir v√≠nculos a los n√∫meros CVE. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de im√°genes de OTRS. La otra posibilidad es insertar el v√≠nculo a la imagen.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para a√±adir v√≠nculos a los n√∫meros MSBulletin. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de im√°genes de OTRS. La otra posibilidad es insertar el v√≠nculo a la imagen.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para a√±adir v√≠nculos a una cadena definida. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de im√°genes de OTRS. La otra posibilidad es insertar el v√≠nculo a la imagen.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para a√±adir v√≠nculos a los n√∫meros bugtraq. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de im√°genes de OTRS. La otra posibilidad es insertar el v√≠nculo a la imagen.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Define un filtro para procesar el texto de los art√≠culos, con la finalidad de resaltar las palabras llave predefinidas.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Define una expresi√≥n regular que excluye algunas direcciones de la verificaci√≥n de sintaxis (si se seleccion√≥ "S√≠" en "CheckEmailAddresses"). Por favor, introduzca una expresi√≥n regular en este campo para direcciones de correo electr√≥nico que, sint√°cticamente son inv√°lidas, pero son necesarias para el sistema (por ejemplo: "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Define una expresi√≥n regular que filtra todas las direcciones de correo electr√≥nico que no deber√≠an usarse en la aplicaci√≥n.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Define un m√≥dulo para cargar opciones de usuario espec√≠ficas o para mostrar noticias.',
        'Defines all the X-headers that should be scanned.' => 'Define todos los encabezados-X que deber√°n escanearse.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Define todos los idiomas en los que la aplicaci√≥n est√° disponible. El par Llave/Valor asocia el nombre front-end desplegado con el archivo PM del idioma apropiado. El valor "Llave" debe ser el nombre base del archivo PM (por ejemplo: si el archivo es de.pm, "Llave" es de). El valor de "Contenido" debe ser el nombre mostrado en el front-end. Especifique cualquier idioma personalizado aqu√≠ (vea el manual del desarrollador para mayor informaci√≥n al respecto: http://doc.otrs.org/). Por favor, recuerde usar los equivalentes HTML para caracteres que no son ASCII (por ejemplo: en Alem√°n, para la metafon√≠a oe = o, es necesario usar el s√≠mbolo &ouml;).',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Define todos los par√°metros para el objeto TiempoDeActualizaci√≥n, en las preferencias del cliente de la interfaz del mismo.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Define todos los par√°metros para el objeto TicketsMostrados, en las preferencias del cliente de la interfaz del mismo.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Define todos los par√°metros para este elemento, en las preferencias del cliente.',
        'Defines all the possible stats output formats.' => 'Define todos los formatos de salida posibles de las estad√≠sticas.',
        'Defines an alternate URL, where the login link refers to.' => 'Define una URL sustituta, a la que el v√≠nculo de inicio de sesi√≥n se refiera.',
        'Defines an alternate URL, where the logout link refers to.' => 'Define una URL sustituta, a la que el v√≠nculo de t√©rmino de sesi√≥n se refiera.',
        'Defines an alternate login URL for the customer panel..' => 'Define una URL sustituta para el inicio de sesi√≥n, en la interfaz del cliente.',
        'Defines an alternate logout URL for the customer panel.' => 'Define una URL sustituta para el t√©rmino de sesi√≥n, en la interfaz del cliente.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            'Define un v√≠nculo externo a la base de datos del cliente (por ejemplo: \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' o \'\').',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Define c√≥mo debe lucir el campo De en los correos electr√≥nicos (enviados como respuestas y tickets).',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cerrar dicho ticket, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para rebotar dicho ticket, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para redactar, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para reenviar dicho ticket, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana de campos libres de dicho ticket, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para mezclar dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para agregar una nota a dicho ticket de la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el propietario de dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para definir como pendiente dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para a√±adir una llamada saliente a dicho ticket, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar la prioridad de dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el agente responsable de dicho ticket, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el cliente de dicho ticket, en la interfaz del agente (si el ticket a√∫n no est√° bloqueado, se bloquea y el agente actual se convierte autom√°ticamente en el propietario).',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Define si la ortograf√≠a de los mensajes redactados debe verificarse en la interfaz del agente.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Define si la contabilidad de tiempo es obligatoria en la interfaz del agente.',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Define la expresi√≥n regular IP para acceder al repositorio local. Es necesario que esto se habilite para tener acceso al repositorio local y el paquete::ListaRepositorio se requiere en el host remoto.',
        'Defines the URL CSS path.' => 'Define la URL de la ruta CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Define la URL de la ruta base para los √≠conos, CSS y Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Define la URL de la ruta de los √≠conos para la navegaci√≥n.',
        'Defines the URL java script path.' => 'Define la URL de la ruta Java Script.',
        'Defines the URL rich text editor path.' => 'Define la URL de la ruta del editor de texto enriquecido.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Define la direcci√≥n de un servidor DNS dedicado, si se necesita, para las b√∫squedas de verificaci√≥n de registro MX.',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Define el texto para el cuerpo de las notificaciones electr√≥nicas que se env√≠an a los agentes, acerca de una contrase√±a nueva (dicha contrase√±a se enviar√° luego de usar este v√≠nculo).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Define el texto para el cuerpo de las notificaciones electr√≥nicas que se env√≠an a los agentes, con un token referente a la petici√≥n de una contrase√±a nueva (dicha contrase√±a se enviar√° luego de usar este v√≠nculo).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Define el texto para el cuerpo de las notificaciones electr√≥nicas que se env√≠an a los clientes, acerca de una cuenta nueva.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Define el texto para el cuerpo de las notificaciones electr√≥nicas que se env√≠an a los clientes, acerca de una contrase√±a nueva (dicha contrase√±a se enviar√° luego de usar este v√≠nculo).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Define el texto para el cuerpo de las notificaciones electr√≥nicas que se env√≠an a los clientes, con un token referente a la petici√≥n de una contrase√±a nueva (dicha contrase√±a se enviar√° luego de usar este v√≠nculo).',
        'Defines the body text for rejected emails.' => 'Define el texto para el cuerpo de los correos electr√≥nicos electr√≥nicos rechazados.',
        'Defines the boldness of the line drawed by the graph.' => 'Define el grosor de la l√≠nea dibujada por el gr√°fico.',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => 'Define los colores de los gr√°ficos.',
        'Defines the column to store the keys for the preferences table.' =>
            'Define la columna para guardar las llaves en la tabla de preferencias.',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Define los par√°metros de configuraci√≥n de este elemento, para que se muestren en la vista de preferencias.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Define los par√°metros de configuraci√≥n de este elemento, para que se muestren en la vista de preferencias. Aseg√∫rese de mantener los diccionarios instalados en el sistema, en la secci√≥n de datos.',
        'Defines the connections for http/ftp, via a proxy.' => 'Define la conexi√≥n para http/ftp, a trav√©s de un proxy.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Define el formato de entrada de las fechas, usado en los formularios (opci√≥n o campos de entrada).',
        'Defines the default CSS used in rich text editors.' => 'Define valor por defecto para el CSS de los editores de texto enriquecidos.',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de una nota, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Define el tema por defecto del front-end (HTML) a ser usado por agentes y clientes. Los temas por defecto son Est√°rdard y Ligero. Si ud. as√≠ lo desea, puede a√±adir su propio tema. Por favor, refi√©rase al manual del administrador para mayor informaci√≥n: http://doc.otrs.org/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Define el lenguaje por defecto del front-end. Todos los valores posibles se determinan por los archivos de idiomas disponible en el sistema (vea la siguiente configuraci√≥n).',
        'Defines the default history type in the customer interface.' => 'Define el tipo de historia por defecto en la interfaz del cliente.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Define el n√∫mero m√°ximo por defecto de atributos para el eje X, en la escala de tiempo.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Define el n√∫mero m√°ximo por defecto de resultados de b√∫squeda, mostrados en la p√°gina de vista de resumen.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de que el cliente le di√≥ seguimiento desde su propia interfaz.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cerrar dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana de acci√≥n m√∫ltiple sobre tickets, en la interfaz del agente.',
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
            'Define el valor por defecto del siguiente estado de un ticket, luego de haberlo redactado / respondido, en la ventana de redacci√≥n de dicho ticket, en la interfaz del agente.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de una nota, para tickets telef√≥nicos en la ventana de llamada telef√≥nica saliente de dicho ticket, en la interfaz del agente.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Define la prioridad por defecto para los tickets de seguimiento de los clientes, en la ventana de vista detallada de dicho ticket, en la interfaz del cliente.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Define la prioridad por defecto para los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default priority of new tickets.' => 'Define la prioridad por defecto para los tickets nuevos.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Define la fila por defecto para los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Define el valor seleccionado por defecto en la lista desplegable para objetos din√°micos (Formulario: Especificaci√≥n Com√∫n).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Define el valor seleccionado por defecto en la lista desplegable para permisos (Formulario: Especificaci√≥n Com√∫n).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Define el valor seleccionado por defecto en la lista desplegable de formatos para las estadisticas (Formulario: Especificaci√≥n Com√∫n).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el tipo de remitente por defecto para los tickets telef√≥nicos, en la ventana de ticket telef√≥nico saliente de la interfaz del agente.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Define el tipo de remitente por defecto para tickets, en la ventana de vista detallada del ticket de la interfaz del agente.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Define el atributo mostrado por defecto para la b√∫squeda de tickets, en la ventana de b√∫squeda.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_NameXTimeSlotStartYear=1974; Search_DynamicField_NameXTimeSlotStartMonth=01; Search_DynamicField_NameXTimeSlotStartDay=26; Search_DynamicField_NameXTimeSlotStartHour=00; Search_DynamicField_NameXTimeSlotStartMinute=00; Search_DynamicField_NameXTimeSlotStartSecond=00; Search_DynamicField_NameXTimeSlotStopYear=2013; Search_DynamicField_NameXTimeSlotStopMonth=01; Search_DynamicField_NameXTimeSlotStopDay=26; Search_DynamicField_NameXTimeSlotStopHour=23; Search_DynamicField_NameXTimeSlotStopMinute=59; Search_DynamicField_NameXTimeSlotStopSecond=59;\' and or \'Search_DynamicField_NameXTimePointFormat=week; Search_DynamicField_NameXTimePointStart=Before; Search_DynamicField_NameXTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Define el orden por defecto para todas las filas mostradas en la vista de filas, luego de haberse ordenado por prioridad.',
        'Defines the default spell checker dictionary.' => 'Define el diccionario por defecto para la verificaci√≥n ortogr√°fica.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Define el estado por defecto de los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default state of new tickets.' => 'Define el estado por defecto para los tickets nuevos.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el asunto por defecto de los tickets telef√≥nicos, en la ventana de ticket telef√≥nico saliente de la interfaz del agente.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Define el asunto por defecto de las notas, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la b√∫squeda, en la interfaz del cliente.',
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
            'Define el atributo de ticket por defecto para ordenar los tickets del resultado de una b√∫squeda, en la interfaz del agente.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Define la notificaci√≥n por defecto para tickets rebotados, que se enviar√° al cliente/remitente, en la ventana de rebotar un ticket, en la interfaz del agente.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haber a√±adido una nota telef√≥nica, en la ventana de ticket telef√≥nico saliente de la interfaz del agente.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets (luego de haberse ordenado por prioridad), en la vista de escalado de la interfaz del agente. Arriba: m√°s antiguo al principio. Abajo: m√°s reciente al principio.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets (luego de haberse ordenado por prioridad), en la vista de estados de la interfaz del agente. Arriba: m√°s antiguo al principio. Abajo: m√°s reciente al principio.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de responsables de la interfaz del agente. Arriba: m√°s antiguo al principio. Abajo: m√°s reciente al principio.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de tickets bloqueados de la interfaz del agente. Arriba: m√°s antiguo al principio. Abajo: m√°s reciente al principio.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, resultado de una b√∫squeda de tickets en la interfaz del agente. Arriba: m√°s antiguo al principio. Abajo: m√°s reciente al principio.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de tickets monitoreados de la interfaz del agente. Arriba: m√°s antiguo al principio. Abajo: m√°s reciente al principio.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, resultado de una b√∫squeda de tickets en la interfaz del cliente. Arriba: m√°s antiguo al principio. Abajo: m√°s reciente al principio.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para cerrar un ticket, en la interfaz del agente.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana de acci√≥n m√∫ltiple sobre tickets de la interfaz del agente.',
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
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            'Define el tipo por defecto para los art√≠culos, en la interfaz del cliente.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Define el tipo por defecto de un mensaje reenviado, en la ventana de reenv√≠o de tickets de la interfaz del agente.',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana de acci√≥n m√∫ltiple sobre tickets de la interfaz del agente.',
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
            'Define el tipo de nota por defecto, en la ventana de ticket telef√≥nico saliente de la interfaz del agente.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Define el tipo de nota por defecto, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Define el tipo de nota por defecto, en la ventana de vista detalla del ticket, en la interfaz del agente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Define el m√≥dulo frontend usado por defecto si no se proporciona el par√°metro Acci√≥n en la URL de la interfaz del agente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Define el m√≥dulo frontend usado por defecto si no se proporciona el par√°metro Acci√≥n en la URL de la interfaz del cliente.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Define el valor por defecto para el par√°metro Acci√≥n de la interfaz p√∫blica. Dicho par√°metro se usa en los scripts del sistema.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Define los valores visibles por defecto para el tipo de remitente de un ticket (por defecto: cliente).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Define el filtro que procesa el texto en los art√≠culos, para resaltar las URLs,',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            'Define el formato de las respuestas, en la ventana de redacci√≥n de un art√≠culo para un ticket, en la interfaz del agente ($QData{"OrigFrom"} es De 1:1, $QData{"OrigFromName"} es el nombre real de De)',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define el nombre del dominio totalmente calificado del sistema. Esta configuraci√≥n es usada como la variable OTRS_CONFIG_FQDN, misma que se encuentra en todos los tipos de mensajes usados en la aplicaci√≥n, para construir v√≠nculos a los tickets del sistema.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Define los grupos en los que estar√°n todos los clientes (si CustomerGroupSupport est√° habilitado y se desea evitar el gestionar cada usuario para estos grupos).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => 'Define la longitur de la leyenda.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana de cerrar un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana de ticket de correo electr√≥nico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana de ticket telef√≥nico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana de campos libres de ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana para agregar una nota al ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana para cambiar el propietario de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana para definir un ticket como pendiente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana de ticket telef√≥nico saliente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana para cambiar la prioridad de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana para cambiar el responsable de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Define el comentario hist√≥rico para la acci√≥n de la ventana de vista detallada de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana de cerrar un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana de ticket de correo electr√≥nico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana de ticket telef√≥nico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana de campos libres de ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana para agregar una nota al ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana para cambiar el propietario de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana para definir un ticket como pendiente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana de ticket telef√≥nico saliente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana para cambiar la prioridad de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana para cambiar el responsable de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Define el tipo hist√≥rico para la acci√≥n de la ventana de vista detallada de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => 'Define las horas y los d√≠as laborales de la semana.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Define la llave que se verificar√° con el m√≥dulo Kernel::Modules::AgentInfo. Si esta llave de preferencias de usuario es verdadera, el mensaje es aceptado por el sistema.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Define la llave que se verificar√° con CustomerAccept. Si esta llave de preferencias de usuario es verdadera, el mensaje es aceptado por el sistema.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define el tipo de v√≠nculo \'Normal\'. Si los nombres fuente y objetivo contienen el mismo valor, el v√≠nculo resultante es no-direccional; de lo contrario, se obtiene un v√≠nculo direccional.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define el tipo de v√≠nculo \'PadreHijo\'. Si los nombres fuente y objetivo contienen el mismo valor, el v√≠nculo resultante es no-direccional; de lo contrario, se obtiene un v√≠nculo direccional.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Define el tipo de v√≠nculo \'Grupos\'. Los tipos de v√≠nculo del mismo grupo se cancelan mutuamente. Por ejemplo: Si el ticket A est√° enlazado con el ticket B por un v√≠nculo \'Normal\', no es posible que estos mismos tickets adem√°s est√©n enlazados por un v√≠nculo de relaci√≥n \'PadreHijo\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Define la ubicaci√≥n para obtener una lista de repositorios en l√≠nea para paquetes adicionales. Se usar√° el primer resultado disponible.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Define el m√≥dulo log del sistema. "Archivo" escribe todos los mensajes en un archivo log, "SysLog" usa el demonio syslog del sistema, por ejemplo: syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Define el tiempo m√°ximo (en segundos) v√°lido para un id de sesi√≥n.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Define el n√∫mero m√°ximo de p√°ginas por archivo PDF.',
        'Defines the maximum size (in MB) of the log file.' => 'Define el tama√±o m√°ximo (en MG) del archivo log.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Define el m√≥dulo que muestra, en la interfaz del agente, una lista de todos los clientes con sesi√≥n activa.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Define el m√≥dulo que muestra, en la interfaz del agente, una lista de todos los agentes con sesi√≥n activa.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Define el m√≥dulo que muestra, en la interfaz del cliente, una lista de todos los agentes con sesi√≥n activa.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Define el m√≥dulo que muestra, en la interfaz del cliente, una lista de todos los clientes con sesi√≥n activa.',
        'Defines the module to authenticate customers.' => 'Define el m√≥dulo para autenticar clientes.',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Define el m√≥dulo para desplegar una notificaci√≥n, en la interfaz del agente, si el sistema est√° siendo usado por el usuario adminstrador (normalmente no es recomendable trabajar como administrador).',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Define el m√≥dulo para generar encabezados html de actualizaci√≥n de sitios html, en la interfaz del cliente.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Define el m√≥dulo para generar encabezados html de actualizaci√≥n de sitios html.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Define el m√≥dulo para enviar correos electr√≥nicos. "Sendmail" usa directamente el sendmail binario de su sistema operativo. Cualquiera de los mecanismos "SMTP" utiliza un servidor de correos (externo) espec√≠fico. "DoNotSendEmail" no env√≠a correos electr√≥nicos, lo cual es √∫til en sistemas de prueba.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Define el m√≥dulo usado para almacenar los datos de sesi√≥n. Con "DB" el servidor frontend puede separarse del servidor de la base de datos. "FS" es m√°s r√°pido.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Define el nombre de la aplicaci√≥n, mostrado en la interfaz web, leng√ºetas (tabs) y en la barra de t√≠tulo del explorador web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Define el nombre de la columna para guardar los datos en la tabla de preferencias.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Define el nombre de la columna para guardar el identificador del usuario en la tabla de preferencias.',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => 'Define el nombre de la llave para las sesiones de los clientes.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Define el nombre de las llaves de sesi√≥n. Por ejemplo: Sesi√≥n, Sesi√≥nID u OTRS.',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Define el nombre de la tabla en la que se almacenan las preferencias de los clientes.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de redactar / responder un ticket, en la ventana de redacci√≥n de la interfaz del agente.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de reenviar un ticket, en la ventana de reenv√≠o de tickets de la interfaz del agente.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Define la lista de posibles estados siguientes para los tickets de los clientes, en la interfaz del cliente.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana de acci√≥n m√∫ltiple sobre tickets de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para a√±adir una nota al ticket, en la interfaz del agente.',
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
        'Defines the parameters for the customer preferences table.' => 'Define los par√°metros para la tabla de preferencias del cliente.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Define los par√°metros para el backend del panel principal. "Group" se usa para restringir el acceso al plugin (por ejemplo, Grupo: admin;grupo1;grupo2;). "Default" indica si el plugin est√° habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTL" indica el periodo de expiraci√≥n (en minutos) del cach√© para el plugin.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Define los par√°metros para el backend del panel principal. "Group" se usa para restringir el acceso al plugin (por ejemplo, Grupo: admin;grupo1;grupo2;). "Default" indica si el plugin est√° habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTLLocal" indica el periodo de expiraci√≥n (en minutos) del cach√© para el plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Define los par√°metros para el backend del panel principal. "Limit" define el n√∫mero de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Grupo: admin;grupo1;grupo2;). "Default" indica si el plugin est√° habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTL" indica el periodo de expiraci√≥n (en minutos) del cach√© para el plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Define los par√°metros para el backend del panel principal. "Limit" define el n√∫mero de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Grupo: admin;grupo1;grupo2;). "Default" indica si el plugin est√° habilitado por defecto o si el usuario necesita habilitarlo manualmente. "CacheTTLLocal" indica el periodo de expiraci√≥n (en minutos) del cach√© para el plugin.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Define la contrase√±a para acceder al manejo SOAP (bin/cgi-bin/rpc.pl).',
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
            'Define la ruta del archivo de informaci√≥n mostrado, mismo que se localiza bajo Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Define la ruta al PGP binario.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Define la ruta al ssl abierto binario.',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'Define la posici√≥n de la leyenda. Debe ser una llave de 2 letras, con la forma \'B[LCR]|R[TCB]\'. La primera letra indica la posici√≥n (Bottom = Abajo o Right = Derecha), y la segunda letra determina la alineaci√≥n (Left = Izquierda, Right = Derecha, Center = Centro, Top = Arriba, o Bottom = Abajo).',
        'Defines the postmaster default queue.' => 'Define la fila por defecto del administrador de correos.',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            'Define el destinatario objetivo de los tickets telef√≥nicos y el remitente de los tickets de correo electr√≥nico ("Queue" muestra todas las filas, "SystemAddress" despliega todas las direcciones del sistema), en la interfaz del agente.',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'Define el destinatario objetivo de los tickets telef√≥nicos y el remitente de los tickets de correo electr√≥nico ("Queue" muestra todas las filas, "SystemAddress" despliega todas las direcciones del sistema), en la interfaz del cliente.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => 'Define el l√≠mite de b√∫squeda para las estad√≠sticas.',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Define el separador entre el nombre real de los agentes y la direcci√≥n de correo electr√≥nico de la fila proporcionada.',
        'Defines the spacing of the legends.' => 'Define el espaciado de las leyendas.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Define los permisos est√°ndar, disponibles para los clientes en la aplicaci√≥n. Si se requieren m√°s permisos, pueden agregarse aqu√≠, sin embargo, es necesario codificarlos para que funcionen. Por favor, cuando agregue alg√∫n permiso, aseg√∫rese de que "rw" permanezca como la √∫ltima entrada.',
        'Defines the standard size of PDF pages.' => 'Define el tama√±o est√°ndar de las p√°ginas PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Define el estado de un ticket si se le da seguimiento y ya estaba cerrado.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Define el estado de un ticket si se le da seguimiento.',
        'Defines the state type of the reminder for pending tickets.' => 'Define el tipo de estado para el recordatorio para los tickets pendientes.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Define el asunto para las notificaciones electr√≥nicas enviadas a los agentes, sobre una contrase√±a nueva.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Define el asunto para las notificaciones electr√≥nicas enviadas a los agentes, con token sobre una contrase√±a nueva solicitada.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Define el asunto para las notificaciones electr√≥nicas enviadas a los clientes, sobre una cuenta nueva.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Define el asunto para las notificaciones electr√≥nicas enviadas a los clientes, sobre una contrase√±a nueva.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Define el asunto para las notificaciones electr√≥nicas enviadas a los clientes, con token sobre una contrase√±a nueva solicitada.',
        'Defines the subject for rejected emails.' => 'Define el asunto para los correos electr√≥nicos rechazados.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Define la direcci√≥n de correo electr√≥nico del administrador del sistema, misma que se desplegar√° en las ventanas de error de la aplicaci√≥n.',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Define el identificador del sistema, que contendr√°n cada n√∫mero de ticket y cadena de sesi√≥n http, para asegurarse de que s√≥lo los tickets que pertenecen al sistema se procesar√°n como seguimientos (√∫til cuando existe comunicaci√≥n entre 2 instancias de OTRS).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Define el atributo objetivo en el v√≠nculo para una base de datos de cliente externa. Por ejemplo: \'target="cdb"\'.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define el tipo de protocolo que usa el servidor web para servir a la aplicaci√≥n. Si se usar√° el protocolo https, en lugar de http plano, debe especificarse aqu√≠. Ya que esto no afecta la configuraci√≥n/comportamiento del explorador seb, no modificar√° el me√©todo de acceso a la aplicaci√≥n y, si es incorrecto, no evitar√° el inicio de sesi√≥n a la aplicaci√≥n. Esta configuraci√≥n se usa como una variable (OTRS_CONFIG_HttpType) y est√° presente en todas las formas de mensajes que maneja la aplicaci√≥n, con la finalidad de crear v√≠nculos a los tickets dentro del sistema.',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            'Define el caracter usado para citar correos electr√≥nicos en la ventana de redacci√≥n de un art√≠culo para el ticket, en la interfaz del agente.',
        'Defines the user identifier for the customer panel.' => 'Define el identificador de usuario para la interfaz del cliente.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Define el nombre de usuario para acceder al manejo SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Define los tipos de estado v√°lidos para un ticket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Define los estados v√°lidos para tickets desbloqueados. El script "bin/otrs.UnlockTickets.pl" puede usarse para desbloquear tickets.',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Define los bloqueos visibles de un ticket. Por defecto: unlock, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define la anchura del editor de texto enriquecido. Proporcione un n√∫mero (pixeles) o un porcentaje (relativo).',
        'Defines the width of the legend.' => 'Define la anchura de la leyenda.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Define los estados deber√°n ajustarse autom√°ticamente (Contenido), despu√©s de que se cumpla el tiempo pendiente del estado (Llave).',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Elimina la sesi√≥n si el identificador de la misma est√° siendo usado con una direcci√≥n IP remota inv√°lida.',
        'Deletes requested sessions if they have timed out.' => 'Elimina las sesiones solicitadas, si ya expiraron.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Determina si la lista de filas posibles a las que los tickets pueden ser movidos, deber√° mostrarse en una lista desplegable o en una nueva ventana, en la interfaz del agente. Si se elije "Ventana nueva", es posible a√±adir una nota al mover el ticket.',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de haber creado un ticket de correo electr√≥nico nuevo en la interfaz del agente.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de haber creado un ticket telef√≥nico nuevo en la interfaz del agente.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determina la pantalla siguiente, luego de haber creado un ticket en la interfaz del cliente.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Determina la pantalla siguiente, luego de darle seguimiento a un ticket, en la vista detallada de dicho ticket de la interfaz del cliente.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determina los estados posibles para tickets pendientes que cambiaron de estado al alcanzar el tiempo l√≠mite.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Determina las cadena que se mostrar√°n como destinatario (Para:) de los tickets telef√≥nicos, y como remitente (De:) de los tickets de correo electr√≥nico, en la interfaz del agente. Para Queue como NewQueueSelectionType, "<Queue>" muestra los nombres de las filas; y para SystemAddress, "<Realname> <<Email>>" muestra el nombre y el correo electr√≥nico del destinatario.',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Determina las cadena que se mostrar√°n como remitente (De:) de los tickets, en la interfaz del cliente. Para Queue como NewQueueSelectionType, "<Queue>" muestra los nombres de las filas; y para SystemAddress, "<Realname> <<Email>>" muestra el nombre y el correo electr√≥nico del remitente.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determina la forma en la que los objetos vinculados se despliegan en cada vista detallada.',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Determina las opciones v√°lidas para el remitente (ticket telef√≥nico) y destinatario (ticket de correo electr√≥nico), en la interfaz del agente.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Determina las filas que ser√°n v√°lidas coom remitentes de los ticket, en la interfaz del cliente.',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Deshabilita el env√≠o de notificaciones de recordatorio al agente responsable de un ticket (Ticket::Responsible tiene que estar activo).',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Despliega la contabilidad de tiempo para un art√≠culo, en la vista detallada del ticket.',
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
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
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
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
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
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'Direcciones de Correo',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Habilita la salida PDF. El m√≥dulo CPAN PDF::API2 es necesario, si no est√° instalado, la salida PDF se deshabilitar√°.',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Habilita el soporte PGP. Cuando este soporte se activa para firmar y garantizar correos, es ALTAMENTE recomendable que el el usuario OTRS ejecute el servidor web. De lo contrario, se generar√°n problemas de privilegios al acceder a la carpeta .gnupg.',
        'Enables S/MIME support.' => 'Habilita el soporte S/MIME.',
        'Enables customers to create their own accounts.' => 'Permite a los clientes crear sus propias cuentas.',
        'Enables file upload in the package manager frontend.' => 'Permite cargar archivos en el frontend del administrador de paquetes.',
        'Enables or disable the debug mode over frontend interface.' => 'Habilita o deshabilita el modo de depuraci√≥n en la interfaz frontend.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Habilita o deshabilita la funcionalidad de monitoreo, para realizar un seguimiento de los tickets, sin ser el propietario o el responsable.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Habilita el log de desempe√±o (para registrar el tiempo de respuesta de las p√°ginas). El desempe√±o del sistema se ver√° afectado. Frontend::Module###AdminPerformanceLog tiene que estar habilitado.',
        'Enables spell checker support.' => 'Habilita el soporte para la revisi√≥n ortogr√°fica.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Habilita la funcionalidad de acci√≥n m√∫ltiple sobre tickets para la interfaz del agente.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Habilita la funcionalidad de acci√≥n m√∫ltiple sobre tickets √∫nicamente para los grupos listados.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Habilita la funcionalidad de responsable del ticket, para realizar un seguimiento de los tickets.',
        'Enables ticket watcher feature only for the listed groups.' => 'Habilita la funcionalidad de monitoreo de tickets s√≥lo para los grupos listados.',
        'Escalation view' => 'Vista de escalado',
        'Event list to be displayed on GUI' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Execute SQL statements.' => 'Ejecutar sentencias SQL.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones de seguimiento en En-Respuesta-A o en las cabeceras de referencia, en los correos que no tienen un n√∫mero de ticket en el asunto.',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones de archivos adjuntos a los correos de seguimiento, en los correos que no tienen un n√∫mero de ticket en el asunto.',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones del cuerpo de los correos de seguimiento, en los correos que no tienen un n√∫mero de ticket en el asunto.',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones de texto plano de los correos de seguimiento, en los correos que no tienen un n√∫mero de ticket en el asunto.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Exporta el √°rbol de art√≠culo completo en el resultado de la b√∫squeda. Esto puede afectar el desempe√±o del sistema.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Obtiene paquetes v√≠a proxy. Sobrescribe "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'Archivo que se muestra en el m√≥dulo Kernel::Modules::AgentInfo, si se encuentra bajo Kernel/Output/HTML/Standard/AgentInfo.dtl.',
        'Filter incoming emails.' => 'Filtrar correos electr√≥nicos entrantes.',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Fuerza la codificaci√≥n de correos electr√≥nicos salientes (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Fuerza a elegir un estado de ticket distinto al actual, luego de bloquear dicho ticket. Define como llave al estado actual y como contenido al estado posterior al bloqueo.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Fuerza a desbloquear los tickets, luego de moverlos a otra fila.',
        'Frontend language' => 'Idioma del frontend',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Registro de m√≥dulo frontend (deshabilita el v√≠nculo de compa√±√≠a si no se est√° usando la funcionalidad de compa√±√≠a).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => 'Registro de m√≥dulo frontend para la interfaz del agente.',
        'Frontend module registration for the customer interface.' => 'Registro de m√≥dulo frontend para la interfaz del cliente.',
        'Frontend theme' => 'Tema frontend',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'General ticket data shown in the dashboard widgets. Possible settings: 0 = Disabled, 1 = Enabled. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => 'AgenteGen√©rico',
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
            'Proporciona a los usuarios finales la posibilidad de sobrescribir el caracter de separaci√≥n de los archivos CSV, definido en los archivos de traducci√≥n.',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'Permite el acceso, si el ID del cliente del ticket coincide con el ID del cliente y, adem√°s, dicho cliente tiene permisos de grupo en la fila en la que est√° el ticket.',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'Extiende la b√∫squeda de texto completo en los art√≠culos (b√∫squedas en De, Para, Cc, Asunto y Cuerpo). Runtime realizar√° b√∫squedas de texto completo en los datos en tiempo real (funciona bien hasta 50,000 tickets). StaticDB buscar√° todos los art√≠culos y construir√° un √≠ndice despu√©s de la creaci√≥n de art√≠culos, incrementando las b√∫squedas en un 50%. Para generar un √≠ndice inicial, utilice "bin/otrs.RebuildFulltextIndex.pl".',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Si "DB" se eligi√≥ como Customer::AuthModule, puede especificarse un manejador de base de datos (normalmente se utiliza detecci√≥n autom√°tica).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Si "DB" se eligi√≥ como Customer::AuthModule, puede especificarse una contrase√±a para conectarse a la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Si "DB" se eligi√≥ como Customer::AuthModule, puede especificarse un nombre de usuario para conectarse a la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Si "DB" se eligi√≥ como Customer::AuthModule, puede especificarse un DSN para la conexi√≥n con la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Si "DB" se eligi√≥ como Customer::AuthModule, puede especificarse el nombre de la columna de la tabla del cliente para la contrase√±a.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Si "DB" se eligi√≥ como Customer::AuthModule, puede especificarse el tipo de encriptado de los passwords.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Si "DB" se eligi√≥ como Customer::AuthModule, puede especificarse el nombre de la columna de la tabla del cliente para el identificador (llave).',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Si "DB" se eligi√≥ como Customer::AuthModule, puede especificarse el nombre de la tabla en la que se guardar√°n los datos de los clientes.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Si "DB" se eligi√≥ como SessionModule, puede especificarse el nombre de la tabla en la que se guardar√°n los datos de sesi√≥n.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Si "FS" se eligi√≥ como SessionModule, puede especificarse un directorio en la que se guardar√°n los datos de sesi√≥n.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Si "HTTPBasicAuth" se eligi√≥ como Customer::AuthModule, puede especificarse (usando una expresi√≥n regular) la eliminaci√≥n de partes del REMOTE_USER (por ejmplo: para quitar dominios finales). Nota de expresi√≥n regular: $1 ser√° el nuevo inicio de sesi√≥n.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Si "HTTPBasicAuth" se eligi√≥ como Customer::AuthModule, puede especificarse la eliminaci√≥n de algunas partes de los nombres de usuario (por ejemplo: para los dominios que usan nombres de usuario como dominio_de_ejemplo\nombre_usuario).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule y se desea a√±adir un sufijo a cada nombre de inicio de sesi√≥n de los clientes, especif√≠quelo aqu√≠. Por ejemplo: se desea escribir √∫nicamente el nombre de usuario, pero en el directorio LDAP est√° registrado como usuario@dominio.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule y se requieren par√°metros especiales para el m√≥dulo perl Net::LDAP, pueden especificarse aqu√≠. Refi√©rase a "perldoc Net::LDAP" para mayor informaci√≥n sobre los par√°metros.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule y sus usuarios s√≥lo tienen acceso an√≥nimo al √°rbol LDAP, pero se desea buscar en los datos; esto puede lograrse con un usuario que tenga acceso al directorio LDAP. Especifique aqu√≠ la contrase√±a para dicho usuario.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule y sus usuarios s√≥lo tienen acceso an√≥nimo al √°rbol LDAP, pero se desea buscar en los datos; esto puede lograrse con un usuario que tenga acceso al directorio LDAP. Especifique aqu√≠ el nombre para dicho usuario.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule, puede especificarse la BaseDN.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule, puede especificarse el host LDAP.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule, puede especificarse el identificador de usuario.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule, pueden especificarse atributos de usuario. Para GruposPosix LDAP, use UID y para los dem√°s, utilice el usuario DN completo.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule, pueden especificarse aqu√≠ atributos de acceso.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule, puede especificarse si las aplicaciones se detendr√°n si, por ejemplo, no se puede establecer una conexi√≥n con el servidor por problemas en la red.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule, puede verificarse si al usuario se le permite autenticarse por estar en un GrupoPosix, por ejemplo: el usuario tiene que estar en el grupo xyz para usar OTRS. Especifique el grupo que puede acceder al sistema.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Si "LDAP" se eligi√≥ como Customer::AuthModule, es posible a√±adir un filtro a cada consulta LDAP, por ejemplo: (mail=*), (objectclass=user) o (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Si "Radius" se eligi√≥ como Customer::AuthModule, puede especificarse una contrase√±a para autenticar al host radius.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Si "Radius" se eligi√≥ como Customer::AuthModule, puede especificarse el host radius.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si "Radius" se eligi√≥ como Customer::AuthModule, puede especificarse si las aplicaciones se detendr√°n si, por ejemplo, no se puede establecer una conexi√≥n con el servidor por problemas en la red.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Si "Sendamail" se eligi√≥ como SendmailModule, puede especificarse la ubicaci√≥n del sendmail binario y las opciones necesarias.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Si "SysLog" se eligi√≥ como LogModule, puede especificarse un log especial.',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'Si "SysLog" se eligi√≥ como LogModule, puede especificarse un log sock especial (en solaris es posible que deba usar \'stream\').',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Si "SysLog" se eligi√≥ como LogModule, puede especificarse el juego de caracteres que debe usarse para el inicio de sesi√≥n.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Si "File" se eligi√≥ como LogModule, puede especificarse el archivo log. Si dicho archivo no existe, ser√° creado por el sistema.',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para cerrar tickets de la interfaz del agente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana de acci√≥n m√∫ltiple sobre tickets de la interfaz del agente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana de campos libres de ticket de la interfaz del agente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para a√±adir una nota, en la interfaz del agente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para cambiar el responsable de dicho ticket, en la interfaz del agente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para cambiar el propietario de dicho ticket, en la interfaz del agente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para definir dicho ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Si un agente agrega una nota, fija el estado del ticket en la ventana para cambiar la prioridad de dicho ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligi√≥ como SendmailModule y se requiere autenticaci√≥n para el servidor de correos, debe especificarse una contrase√±a.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligi√≥ como SendmailModule y se requiere autenticaci√≥n para el servidor de correos, debe especificarse un nombre de usuario.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligi√≥ como SendmailModule, debe especificarse el host que env√≠a los correos.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligi√≥ como SendmailModule, debe especificarse el puerto en el que el servidor de correos estar√° escuchando para conexiones entrantes.',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'Si se habilita, OTRS entregar√° todos los archivos CSS en forma reducida (minified). ADVERTENCIA: Si ud. desactiva esta opci√≥n, es muy probable que se generen problemas en IE 7, porque no puede cargar m√°s de 32 archivos CSS.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Si se habilita, OTRS entregar√° todos los archivos JavaScript en forma reducida (minified).',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Si se habilita, los m√≥dulos de tickets telef√≥nico y de correo electr√≥nico, se abrir√°n en una ventana nueva.',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            'Si se habilita, la versi√≥n de OTRS ser√° removida de los encabezados HTTP.',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Si se habilita, el primer nivel del men√∫ principal se abre al posicionar el cursor sobre √©l (en lugar de hacer click).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Si esta expresi√≥n regular coincide, ning√∫n mensaje se mandar√° por el contestador autom√°tico.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'Si desea utilizar una base de datos espejo para la b√∫squeda de texto completo de tickets o para generar estad√≠sticas, especifique el DSN a dicha base de datos.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'Si desea utilizar una base de datos espejo para la b√∫squeda de texto completo de tickets o para generar estad√≠sticas, puede especificarse la contrase√±a para autenticarse a dicha base de datos.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'Si desea utilizar una base de datos espejo para la b√∫squeda de texto completo de tickets o para generar estad√≠sticas, puede especificarse el usuario para autenticarse a dicha base de datos.',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Incluye los tiempos de creaci√≥n de los art√≠culos en la b√∫squeda de tickets de la interfaz del agente.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'Acelerador de √≠ndices para elegir su m√≥dulo backend TicketViewAccelerator, "RuntimeDB" genera sobre la marcha cada vista de filas desde la tabla de tickets (no hay problemas de desempe√±o hasta aprox. 60,000 tickets en total y 6,000 abiertos en el sistema). "StaticDB" es el m√≥dulo m√°s poderoso, ya que usa un √≠ndice de tickets extra que funciona como una vista (recomendado para m√°s de 80,000 tickets en total y 6,000 abiertos en el sistema). Use el script "bin/otrs.RebuildTicketIndex.pl" para actualizar su √≠ndice inicial.',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'Instala ispell o aspell en el sistema, si se desea usar el corrector ortogr√°fico. Por favor, especifique la ruta al aspell o ispell binario en su sistema operativo.',
        'Interface language' => 'Idioma de la interfaz',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes pieles, por ejemplo: para diferenciar entre distintos agentes, para usarse una base por-dominio en la aplicaci√≥n. Al definir una expresi√≥n regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una piel v√°lida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresi√≥n regular correcta.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes pieles, por ejemplo: para diferenciar entre distintos clientes, para usarse una base por-dominio en la aplicaci√≥n. Al definir una expresi√≥n regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una piel v√°lida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresi√≥n regular correcta.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes pieles, por ejemplo: para diferenciar entre agentes y clientes, para usarse una base por-dominio en la aplicaci√≥n. Al definir una expresi√≥n regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una piel v√°lida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresi√≥n regular correcta.',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Link agents to groups.' => 'Vincular agentes con grupos.',
        'Link agents to roles.' => 'Vincular agentes con roles.',
        'Link attachments to templates.' => '',
        'Link customers to groups.' => 'Vincular clientes con grupos.',
        'Link customers to services.' => 'Vincular clientes con servicios.',
        'Link queues to auto responses.' => 'Vincular filas con auto-respuestas.',
        'Link roles to groups.' => 'Vincular roles con grupos.',
        'Link templates to queues.' => '',
        'Links 2 tickets with a "Normal" type link.' => 'Vincular 2 tickets con un v√≠culo de tipo "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Vincular 2 tickets con un v√≠culo de tipo "PadreHijo".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista de archivos CSS que siempre se cargar√°n para la interfaz del agente.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS que siempre se cargar√°n para la interfaz del cliente.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Lista de archivos CSS espec√≠ficos para IE8 que siempre se cargar√°n para la interfaz del agente.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS espec√≠ficos para IE8 que siempre se cargar√°n para la interfaz del cliente.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista de archivos JS que siempre se cargar√°n para la interfaz del agente.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Lista de archivos JS que siempre se cargar√°n para la interfaz del cliente.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'Archivo log para el contador de tickets.',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Hace que la aplicaci√≥n verifique el registro MX de las direcciones de correo electr√≥nico, antes de enviar un correo o crear un ticket, ya sea telef√≥nico o de correo electr√≥nico.',
        'Makes the application check the syntax of email addresses.' => 'Hace que la aplicaci√≥n verifique la sintaxis de las direcciones de correo electr√≥nico.',
        'Makes the picture transparent.' => 'Hace las im√°genes transparentes.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Hace que la gesti√≥n de sesiones utilice cookies html. Si las cookies html est√°n deshabilitadas o si el explorador del cliente las tiene deshabilitadas, el sistema trabajar√° normalmente y agregar√° el identificador de sesi√≥n a los v√≠nculos.',
        'Manage PGP keys for email encryption.' => 'Gestionar las llaves PGP para encriptaci√≥n de correos electr√≥nicos.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gestionar las cuentas POP3 o IMAP de las que se extraen correos.',
        'Manage S/MIME certificates for email encryption.' => 'Gestionar certificados S/MIME para encriptaci√≥n de correos electr√≥nicos.',
        'Manage existing sessions.' => 'Gestionar sesiones existentes.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Gestionar tareas peri√≥dicas.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Tama√±o m√°ximo (en caracteres) para la tabla de informaci√≥n del cliente (tel√©fono y correo electr√≥nico) en la ventana de redacci√≥n.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => 'Tama√±o m√°ximo para los asuntos en la respuesta a un correo electr√≥nico.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'N√∫mero m√°ximo de respuestas autom√°ticas (v√≠a correos electr√≥nicos) al d√≠a para la direcci√≥n de correo electr√≥nico propia (protecci√≥n de bucle).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Tama√±o m√°ximo en KBytes para correos que pueden obtenerse v√≠a POP3/POP3S/IMAP/IMAPS.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'N√∫mero m√°ximo de tickets para ser mostrados en el resultado de una b√∫squeda, en la interfaz del agente.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'N√∫mero m√°ximo de tickets para ser mostrados en el resultado de una b√∫squeda, en la interfaz del cliente.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'N√∫mero m√°ximo (en caracteres) de la tabla de informaci√≥n del cliente en la vista detallada del ticket.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'M√≥dulo para la selecci√≥n del destinatario en la ventana de ticket nuevo, en la interfaz del cliente.',
        'Module to check customer permissions.' => 'M√≥dulo para verificar los permisos del cliente.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'M√≥dulo para verificar si un usuario se encuentra en un grupo espec√≠fico. Se permite el acceso si el usuario est√° en cierto grupo y tiene permisos ro y rw.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            'M√≥dulo para verificar si los correos recibidos deben marcarse como internos.',
        'Module to check the agent responsible of a ticket.' => 'M√≥dulo para verificar el agente responsable de un ticket.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'M√≥dulo para verificar los permisos de grupo para el acceso a los tickets de los clientes.',
        'Module to check the owner of a ticket.' => 'M√≥dulo para verificar el propietario de un ticket.',
        'Module to check the watcher agents of a ticket.' => 'M√≥dulo para verificar los agentes que monitorean un ticket.',
        'Module to compose signed messages (PGP or S/MIME).' => 'M√≥dulo para redactar mensajes firmados (PGP o S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'M√≥dulo para encriptar mensajes firmados (PGP o S/MIME).',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'M√≥dulo para filtrar y manipular mensajes entrantes. Bloquea/ignora todos los correos no deseados con direcciones De: noreply@.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'M√≥dulo para filtrar y manipular mensajes entrantes. Obtenga un n√∫mero de 4 d√≠gitos para el texto libre de ticket, use una expresi√≥n regular en Match, por ejemplo: From => \'(.+?)@.+?\', y utilice () como [***] en Set =>.',
        'Module to generate accounted time ticket statistics.' => 'M√≥dulo para generar estad√≠sticas de la contabilidad de tiempo de los tickets.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'M√≥dulo para generar perfil OpenSearch html para b√∫squeda simple de tickets en la interfaz del agente.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'M√≥dulo para generar perfil OpenSearch html para b√∫squeda simple de tickets en la interfaz del cliente.',
        'Module to generate ticket solution and response time statistics.' =>
            'M√≥dulo para generar estad√≠sticas del tiempo de soluci√≥n y respuesta de los tickets.',
        'Module to generate ticket statistics.' => 'M√≥dulo para generar estad√≠sticas de tickets.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'M√≥dulo para mostrar notificaciones y escalados (ShownMax: N√∫mero m√°ximo de escalados que se muestran, EscalationInMinutes: Mostrar el ticket que escalar√° en estos minutos, CacheTime: Cach√© de los escalados calculados en segundos).',
        'Module to use database filter storage.' => 'M√≥dulo para utilizar el almacenamiento de base de datos del filtro.',
        'Multiselect' => '',
        'My Tickets' => 'Mis Tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Nombre de fila personalizada, misma que es una selecci√≥n de sus filas de preferencia y puede elegirse en las configuraciones de sus preferencias.',
        'NameX' => '',
        'New email ticket' => 'Ticket de correo electr√≥nico nuevo',
        'New phone ticket' => 'Ticket telef√≥nico nuevo',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Lista de posibles estados siguientes de ticket, luego de haber a√±adido una nota telef√≥nica a un ticket, en la ventana de ticket telef√≥nico slaiente de la interfaz del agente.',
        'Notifications (Event)' => 'Notificaciones (Evento)',
        'Number of displayed tickets' => 'N√∫mero de t√≠ckets desplegados',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'N√∫mero de l√≠neas (por ticket) que se muestran por la utilidad de b√∫squeda de la interfaz del agente.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'N√∫mero de tickets desplegados en cada p√°gina del resultado de una b√∫squeda, en la interfaz del agente.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'N√∫mero de tickets desplegados en cada p√°gina del resultado de una b√∫squeda, en la interfaz del cliente.',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Sobrecarga (redefine) funciones existentes en Kernel::System::Ticket. √ötil para a√±adir personalizaciones f√°cilmente.',
        'Overview Escalated Tickets' => 'Resumen de Tickets Escalados',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => ' Resumen de todos los Tickets abiertos',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'Cargar Llave PGP',
        'Parameters for .' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Par√°metros para el objeto CrearM√°scaraNueva, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'Par√°metros para el objeto QueuePersonalizada, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'Par√°metros para el objeto Notificaci√≥nSeguimiento, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'Par√°metros para el objeto Notificaci√≥nTiempoDeEsperaBloqueo, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'Par√°metros para el objeto Notificaci√≥nMovimiento, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'Par√°metros para el objeto Notificaci√≥nTicketNuevo, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Par√°metros para el objeto TiempoActualizaci√≥n, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'Par√°metros para el objeto Notificaci√≥nObservador, en la vista de preferencias de la interfaz del agente.',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Par√°metros para el backend del panel principal de la vista de resumen de tickets nuevos de la interfaz del agente. "Limit" es el n√∫mero de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin est√° habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la cach√© del plugin.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Par√°metros para el backend del panel principal del calendario de ticket de la interfaz del agente. "Limit" es el n√∫mero de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin est√° habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la cach√© del plugin.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Par√°metros para el backend del panel principal de la vista de resumen de tickets escalados de la interfaz del agente. "Limit" es el n√∫mero de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin est√° habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la cach√© del plugin.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Par√°metros para el backend del panel principal de la vista de resumen de tickets con recordatorio pendiente de la interfaz del agente. "Limit" es el n√∫mero de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin est√° habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la cach√© del plugin.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Par√°metros para el backend del panel principal de la vista de resumen de tickets con recordatorio pendiente de la interfaz del agente. "Limit" es el n√∫mero de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin est√° habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la cach√© del plugin.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Par√°metros para el backend del panel principal de las estad√≠sticas de ticket de la interfaz del agente. "Limit" es el n√∫mero de entradas mostradas por defecto. "Group" se usa para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "Default" determina si el plugin est√° habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo en minutos para la cach√© del plugin.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Par√°metros para las p√°ginas (en las que se muestran los tickets) de la vista de resumen mediana.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Par√°metros para las p√°ginas (en las que se muestran los tickets) de la vista de resumen peqye√±a.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Par√°metros para las p√°ginas (en las que se muestran los tickets) de la vista de resumen previa.',
        'Parameters of the example SLA attribute Comment2.' => 'Par√°metros del ejemplo del atributo de SLA, Comment2.',
        'Parameters of the example queue attribute Comment2.' => 'Par√°metros del ejemplo del atributo de fila, Comment2.',
        'Parameters of the example service attribute Comment2.' => 'Par√°metros del ejemplo del atributo de servicio, Comment2.',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Ruta para el archivo log (aplica √∫nicamente si "FS" se eligi√≥ como LoopProtectionModule y si es obligatorio).',
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
        'Permitted width for compose email windows.' => 'Anchura permitida para las ventanas de redacci√≥n de correos electr√≥nicos.',
        'Permitted width for compose note windows.' => 'Anchura permitida para las ventanas de redacci√≥n de notas.',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'Filtros del Administrador de Correos',
        'PostMaster Mail Accounts' => 'Cuentas del Administrador de Correos',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Protecci√≥n contra CSRF (Solicitud de Falsificaci√≥n de Sitios Cruzada). Consulte http://en.wikipedia.org/wiki/Cross-site_request_forgery para mayor informaci√≥n.',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Vista de Filas',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => '',
        'Refresh interval' => 'Intervalo de actualizaci√≥n',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Reemplaza el destinatario original con la direcci√≥n de correo electr√≥nico del cliente actual, al redactar una respuesta en la ventana de redacci√≥n de tickets de la interfaz del agente.',
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
            'Permisos necesarios usar la ventana para a√±adir notas a los tickets, en la interfaz del agente.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar el propietario de un ticket, en la interfaz del agente.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para definir un ticket como pendiente, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Permisos necesarios usar la ventana de ticket telef√≥nico saliente, en la interfaz del agente.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar la prioridad de un ticket, en la interfaz del agente.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Reinicializa y desbloquea al propietario de un ticket, si este √∫ltimo se mueve a otra fila.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Restablece un ticket del archivo (s√≥lo si el evento es un cambio de estado de cerrado a cualquiera de los estados abiertos disponibles).',
        'Roles <-> Groups' => 'Roles <-> Grupos',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Ejecuta el sistema en modo "Demo". Si se selecciona "S√≠", los agentes pueden modificar preferencias, como elegir el idioma y el tema, a trav√©s de la interfaz del agente. Estos cambios s√≥lo ser√°n v√°lidos en la sesi√≥n actual. No se les permitir√° a los agentes que cambien su contrase√±a.',
        'S/MIME Certificate Upload' => 'Cargar Certificado S/MIME',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            'Guarda los archivos adjuntos de los art√≠culos. "DB" almacena todos en la base de datos (no se recomienda para guardar archivos adjuntos grandes), mientras que "FS" usa el sistema de archivos, lo cual es m√°s r√°pido, pero el servidor web tiene que ser ejecutado con el usuario OTRS. Es posible cambiar entre los m√≥dulos sin perder informaci√≥n, inclusive en un sistema en producci√≥n.',
        'Search Customer' => 'B√∫squeda de cliente',
        'Search User' => '',
        'Search backend default router.' => 'Buscar el router por defecto del backend.',
        'Search backend router.' => 'Buscar el router del backend.',
        'Select your frontend Theme.' => 'Seleccione su tema.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Selecciona el m√≥dulo para manejar las cargas de archivos en la interfaz web. "DB" almacena todos en la base de datos, mientras que "FS" usa el sistema de archivos.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Selecciona el m√≥dulo generador de n√∫meros de ticket. "AutoIncrement" incrementa el n√∫mero de ticket, se usan el ID del sistema y el contador, en la forma IDSistema.contador (por ejemplo: 1010138, 1010139). Con "Date", el n√∫mero de ticket se genera con la fecha actual, el ID de sistema y el contador, con el formato: A√±o.Mes.D√≠a.IDSistema.Contador.SumaDeComprobaci√≥n (por ejemplo: 2002070110101520, 2002070110101535). "Random" genera n√∫meros de tickets aleatorios, con el formato IDSistema.Aleatorio (por ejemplo: 100057866352, 103745394596).',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Enviarme notificaciones si un cliente realiza un seguimiento y yo soy el propietario del ticket o si el ticket est√° desbloqueado y se encuentra en alguna de las filas en las que estoy suscrito.',
        'Send notifications to users.' => 'Enviar notificaciones a usuarios.',
        'Send ticket follow up notifications' => 'Enviar notificaciones de seguimiento de tickets',
        'Sender type for new tickets from the customer inteface.' => 'Tipo de destinatario para tickets nuevos, creados  en la interfaz del cliente.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Enviar notificaciones de seguimiento √∫nicamente al agente propietario, si el ticket se desbloquea (por defecto se env√≠an notificaciones a todos los agentes).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Env√≠a todos los correos electr√≥nicos salientes v√≠a bcc a la direcci√≥n especificada. Por favor, utilice esta opci√≥n √∫nicamente por motivos de copia de seguridad).',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'Env√≠a notificaciones s√≥lo a los clientes especificados. Normalemente, si no se especifica un cliente, quien obtiene la notificaci√≥n es el √∫ltimo remitente.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Env√≠a notificaciones de recordatorio de tickets desbloqueados a sus propietarios, luego que alcanzaron la fecha de recordatorio.',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Env√≠a las notificaciones que se configuran en la interfaz de administraci√≥n, bajo "Notificaci√≥n (Evento)".',
        'Set sender email addresses for this system.' => 'Define la direcci√≥n de correo electr√≥nico remitente del sistema.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Define la altura por defecto (en pixeles) de art√≠culos HTML en l√≠nea en la vista detallada del ticket de la interfaz del agente.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Define la altura m√°xima (en pixeles) de art√≠culos HTML en l√≠nea en la vista detallada del ticket de la interfaz del agente.',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'Define si el propietario del ticket tiene que ser seleccionado por el agente.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Fija el tiempo pendiente de un ticket a 0, si el estado se cambia a uno no pendiente.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Fija la edad en minutos (primer nivel) para resaltar filas que contienen tickets sin tocar.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Fija la edad en minutos (segundo nivel) para resaltar filas que contienen tickets sin tocar.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Fija el nivel de configuraci√≥n del administrador. Dependiendo del nivel de configuraci√≥n, algunas configuraciones del sistema no se mostrar√°n. Los niveles est√°n en orden ascendente: Experto, Avanzado, Principiante. Entre m√°s alto sea el nivel de configuraci√≥n (por ejemplo: Beginner es el m√°s alto), es menos probable que el usuario pueda configurar accidentalemente el sistema de una forma que quede inutilizable.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Fija el tipo de art√≠culo por defecto para los tickets de correo electr√≥nico nuevos, en la interfaz del agente.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Fija el tipo de art√≠culo por defecto para los tickets telef√≥nicos nuevos, en la interfaz del agente.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se a√±aden en la ventana para cerrar tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se a√±aden en la ventana para mover tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se a√±aden en la ventana para agregar notas a los tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se a√±aden en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece el contenido por defecto del cuerpo de las notas que se a√±aden en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se a√±aden en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se a√±aden en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Define el tipo de v√≠nculo por defecto de tickets divididos, en la interfaz del agente.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Define el estado siguiente por defecto para tickets telef√≥nicos nuevos, en la interfaz del agente.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Define el estado siguiente por defecto para tickets de correo electr√≥nico nuevos, en la interfaz del agente.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas para tickets telef√≥nicos nuevos, en la interfaz del agente. Por ejemplo: \'Ticket nuevo v√≠a llamada\'.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Define la prioridad por defecto para tickets de correo electr√≥nico nuevos, en la interfaz del agente.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Define la prioridad por defecto para tickets telef√≥nicos nuevos, en la interfaz del agente.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Define el tipo de remitente por defecto para tickets de correo electr√≥nico nuevos, en la interfaz del agente.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Define el tipo de remitente por defecto para tickets telef√≥nicos nuevos, en la interfaz del agente.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Define el asunto por defecto para tickets de correo electr√≥nico nuevos, en la interfaz del agente. Por ejemplo: \'Correo electr√≥nico saliente\'.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Define el asunto por defecto para tickets telef√≥nicos nuevos, en la interfaz del agente. Por ejemplo: \'Llamada telef√≥nica\'.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se a√±aden en la ventana para cerrar tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se a√±aden en la ventana para mover tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se a√±aden en la ventana para agregar notas a los tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se a√±aden en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece el asunto por defecto del cuerpo de las notas que se a√±aden en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se a√±aden en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se a√±aden en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de los tickets de correo electr√≥nico nuevos, en la interfaz del agente.',
        'Sets the display order of the different items in the preferences view.' =>
            'Define el orden por defecto en el que se mostrar√°n los diferentes elementos, en la vista de preferencias.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'Define el tiempo de inactividad (en segundos) que deber√° pasar antes de cerrar la sesi√≥n de un usuario y finalizar su sesi√≥n.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            'Define el tama√±o m√≠nimo del contador de tickets (si "AutoIncrement" se eligi√≥ como TicketNumberGenerator). El valor por defecto es 5, lo cual quiere decir que el contador comineza en 10000.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Define el n√∫mero de l√≠neas mostradas en los mensajes de texto (por ejemplo: renglones de ticket en la vista detallada de las filas).',
        'Sets the options for PGP binary.' => 'Define las opciones para PGP binario.',
        'Sets the order of the different items in the customer preferences view.' =>
            'Define el orden de los diferentes elementos, en la vista de preferencias de la interfaz del cliente.',
        'Sets the password for private PGP key.' => 'Define la contrase√±a para la llave PGP privada.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Define las unidades de tiempo preferidas (por ejemplo: unidades laborales, horas, minutos).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Define el prefijo para la carpeta que contiene los scripts en el servidor, tal y como se configur√≥ en el servidor web. Esta configuraci√≥n se usa como una variable (OTRS_CONFIG_ScriptAlias) y est√° presente en todas las formas de mensajes que maneja la aplicaci√≥n, con la finalidad de crear v√≠nculos a los tickets dentro del sistema.',
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
            'Define el agente responsable de un ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana de acci√≥n m√∫ltiple sobre tickets de la interfaz del agente.',
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
        'Sets the size of the statistic graph.' => 'Define el tama√±o del gr√°fico para las estad√≠sticas.',
        'Sets the stats hook.' => 'Define el candado para las estad√≠sticas.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'Define la zona horaria del sistema (se requiere un sistema con UTC como hora, de lo contrario, habr√≠a una diferencia con la hora local).',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana de acci√≥n m√∫ltiple sobre tickets de la interfaz del agente.',
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
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => 'Define el tipo de tiempo que debe mostrarse.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Define el tiempo de espera (en segundos) para descargas http/ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Define el tiempo de espera (en segundos) para descargas de paquetes.',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Define la zona horaria del usuario (se requiere un sistema con UTC como hora, de lo contrario, habr√≠a una diferencia con la hora local).',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'Define la zona horaria del usuario, bas√°ndose en java script / zona horaria del navegador, al iniciar sesi√≥n en el sistema.',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Muestra una selecci√≥n del agente responsable, en los tickets telef√≥nico y de correo electr√≥nico de la interfaz del agente.',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Muestra un recuento de √≠conos en la vista detallada del ticket, si el art√≠culo tiene archivos adjuntos.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, para suscribirse / darse de baja de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite vincular un ticket con otro objeto, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite mezclar tickets, en la vista detallada de ticket de la interfaz del agente.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite acceder a la historia de dicho ticket, en su vista detallada de la interfaz del agente.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite a√±adir un campo de texto libre a un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite a√±adir una nota a un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite a√±adir una nota a un ticket, en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite cerrar un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite cerrar un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un v√≠nculo en el men√∫, que permite eliminar un ticket en todas y cada una de las vistas de resumen de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este v√≠nculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un v√≠nculo en el men√∫, que permite eliminar un ticket, en la vista detallada de dicho ticket de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este v√≠nculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite regresar a la ventana anterior, en la vista detallada de un ticket, en la interfaz del agente.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite bloquear / desbloquear un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite bloquear / desbloquear un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite mover un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite imprimir un ticket o un art√≠culo, en la vista detallada del ticket, en la interfaz del agente.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite verificar el cliente que solicit√≥ el ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite acceder a la historia de dicho ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite modificar el propietario de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite modificar la prioridad de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite modificar el responsable de un ticket, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite definir un ticket como pendiente, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un v√≠nculo en el men√∫, que permite definir un ticket como basura (spam) en todas y cada una de las vistas de resumen de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este v√≠nculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite modificar la prioridad de un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Muestra un v√≠nculo en el men√∫, que permite acceder a la vista detallada de un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Muestra un v√≠nculo para acceder a los archivos adjuntos de un art√≠culo a trav√©s de un visualizador html en l√≠nea, en la vista detallada de dicho art√≠culo de la interfaz del agente.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Muestra un v√≠nculo para descargar los archivos adjuntos de un art√≠culo, en la vista detallada de dicho art√≠culo de la interfaz del agente.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Muestra un v√≠nculo para visualizar un ticket de correo electr√≥nico en texto plano, en la vista detallada de dicho ticket.',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un v√≠nculo para definir un ticket como basura (spam), en la vista detallada de dicho art√≠culo de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este v√≠nculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
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
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para a√±adir notas en la fila/ticket), para determinar qui√©n debe ser informado acerca de esta nota, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para a√±adir notas en la fila/ticket), para determinar qui√©n debe ser informado acerca de esta nota, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para a√±adir notas en la fila/ticket), para determinar qui√©n debe ser informado acerca de esta nota, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para a√±adir notas en la fila/ticket), para determinar qui√©n debe ser informado acerca de esta nota, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para a√±adir notas en la fila/ticket), para determinar qui√©n debe ser informado acerca de esta nota, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para a√±adir notas en la fila/ticket), para determinar qui√©n debe ser informado acerca de esta nota, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para a√±adir notas en la fila/ticket), para determinar qui√©n debe ser informado acerca de esta nota, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Muestra una vista previa de la vista de resumen de los tickets (CustomerInfo => 1 - muestra tambi√©n la informaci√≥n del cliente y CustomerInfoMaxSize define el tama√±o m√°ximo, en caracteres, de dicha informaci√≥n).',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Muestra las filas ro y rw en la vista de filas.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Muestra todos los tickets abiertos (inclusive si est√°n bloqueados), en la vista de escalado de la interfaz del agente.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Muestra todos los tickets abiertos (inclusive si est√°n bloqueados), en la vista de estados de la interfaz del agente.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Muestra todos los art√≠culos de un ticket (expandidos), en la vista detallada de dicho ticket.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Muestra todos los identificadores de clientes en un campo de selecci√≥n m√∫ltiple (no es √∫til si existen muchos identificadores).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Muestra una selecci√≥n de propietario en los tickets telef√≥nico y de correo electr√≥nico de la interfaz del agente.',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Muestra tickets del historial del cliente en los tickets telef√≥nico y de correo electr√≥nico, en la interfaz del agente; y en la ventana para a√±adir un ticket, en la interfaz del cliente.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Muestra el asunto del √∫ltimo art√≠culo a√±adido por el cliente o el t√≠tulo del ticket, en el formato peque√±o de la vista de resumen.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Muestra las filas padre/hijo existentes en el sistema, ya sea en forma de √°rbol o de lista.',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Muestra los atributos de ticket activos en la interfaz del cliente (0 = Deshabilitado y 1 = Habilitado).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Muestra los art√≠culos ordenados normalmente o de forma inversa, en la vista detallada de un ticket, en la interfaz del agente.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Muestra la informaci√≥n del cliente (n√∫mero telef√≥nico y cuenta de correo electr√≥nico) en la ventana de redacci√≥n de art√≠culos.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Muestra la informaci√≥n del cliente en la vista detallada de un ticket, en la interfaz del agente.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Muestra el mensaje del d√≠a en el panel principal del agente. "Group" se usa para restringir el acceso al plugin (por ejemplo: Group: admin;grupo1;grupo2;). "Default" indica si el plugin est√° habilitado por defecto o si el usuario tiene que activarlo manualmente.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Muestra el mensaje del d√≠a en la ventana de inicio de sesi√≥n de la interfaz del agente.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Muestra la historia del ticket (ordenada inversamente) en la interfaz del agente.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para mover tickets, en la interfaz del agente.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana de acci√≥n m√∫ltiple sobre tickets de la interfaz del agente.',
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
            'Muestra los campos de t√≠tulo, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'Muestra los campos de t√≠tulo, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Muestra los campos de t√≠tulo, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra los campos de t√≠tulo, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra los campos de t√≠tulo, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra los campos de t√≠tulo, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Muestra los campos de t√≠tulo, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Si se elige "Yes", muestra el tiempo en formato largo (d√≠as, horas, minutos); de lo contrario, se usa el formato corto (d√≠as, horas).',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => 'Piel.',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Ordena los tickets (ascendente o descendentemente), luego de haberse ordenado por prioridad, cuando una sola fila se selecciona en la vista de filas. Values: 0 = ascendente (por defecto, m√°s antiguo arriba), 1 = descendente (m√°s reciente arriba). Use el identificador de la fila como Key y 0 √≥ 1 como Valor.',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Ejemplo de configuraci√≥n del eliminador de correo basura. Ignora los correos electr√≥nicos que est√°n marcados con SpamAssasin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Ejemplo de configuraci√≥n del eliminador de correo basura. Mueve los correos marcados a la fila basura.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Especifica si un agente debe recibir notificaciones en su correo electr√≥nico, acerca de sus propias acciones.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => 'Especifica el color de fondo para el gr√°fico.',
        'Specifies the background color of the picture.' => 'Especifica el color de fondo para la fotograf√≠a.',
        'Specifies the border color of the chart.' => 'Especifica el color de la orilla del gr√°fico.',
        'Specifies the border color of the legend.' => 'Especifica el color de la orilla de la leyenda.',
        'Specifies the bottom margin of the chart.' => 'Especifica el margen inferior del gr√°fico.',
        'Specifies the different article types that will be used in the system.' =>
            'Especifica los diferentes tipos de art√≠culo que se usar√°n en el sistema.',
        'Specifies the different note types that will be used in the system.' =>
            'Especifica los diferentes tipos de nota que se usar√°n en el sistema.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Especifica el directorio en el que se guardar√°n los datos, si "FS" se eligi√≥ como TicketStorageModule.',
        'Specifies the directory where SSL certificates are stored.' => 'Especifica el directorio donde se guardan los certificados SSL.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Especifica el directorio donde se guardan los certificados privados SSL.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Especifica la direcci√≥n de correo electr√≥nico que debe usar la aplicaci√≥n al mandar notificaciones. Dicha direcci√≥n se usa para construir el nombre completo a desplegar del notificador maestro (por ejemplo: "Notificador maestro de OTRS" otrs@su.ejemplo.com). Es posible usar la variable OTRS_CONFIG_FQDN, tal y como se defini√≥ en la configuraci√≥n, o elegir otra direcci√≥n de correo electr√≥nico. Las notificaciones son mensajes como es::Customer::QueueUpdate o es::Agent::Move.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => 'Especifica el margen izquierdo del gr√°fico.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Especifica el nombre que debe usar la aplicaci√≥n al mandar notificaciones. El remitente se usa para construir el nombre completo a desplegar del notificador maestro (por ejemplo: "Notificador maestro de OTRS" otrs@su.ejemplo.com). Las notificaciones son mensajes como es::Customer::QueueUpdate o es::Agent::Move.',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Especifica la ruta del archivo que corresponde al logo del encabezado de la p√°gina (gif|jpg|png, 700 x 100 pixeles).',
        'Specifies the path of the file for the performance log.' => 'Especifica la ruta del archivo que corresponde al log de desempe√±o.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos de Microsoft Excel en la interfaz web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos de Microsoft Word en la interfaz web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar documentos PDF en la interfaz web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos XML en la interfaz web.',
        'Specifies the right margin of the chart.' => 'Especifica el margen derecho del gr√°fico.',
        'Specifies the text color of the chart (e. g. caption).' => 'Especifica el color del texto para el gr√°fico (por ejemplo: t√≠tulo).',
        'Specifies the text color of the legend.' => 'Especifica el color de la leyenda.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Especifica el texto que debe aparecer en el archivo de desempe√±o para denotar una entrada de script CGI.',
        'Specifies the top margin of the chart.' => 'Especifica el margen superior del gr√°fico.',
        'Specifies user id of the postmaster data base.' => 'Especifica el identificador de usuario de la base de datos del administrador de correos.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Permisos est√°ndar disponibles para los agentes en la aplicaci√≥n. Si se requieren m√°s permisos, pueden especificarse aqu√≠, pero para que sean efectivos, es necesario definirlos. Otros permisos √∫tiles tambi√©n se proporcionaron, incorporados al sistema: nota, cerrar, pendiente, cliente, texto libre, mover, redactar, responsable, reenviar y rebotar. Aseg√∫rese de que "rw" permanezca siempre como el √∫ltimo permiso registrado.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'N√∫mero de inicio para el conteo de estad√≠sticas. Cada estad√≠stica nueva incrementa este n√∫mero.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'Estad√≠sticas',
        'Status view' => 'Vista de estados',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'Guarda las cookies despu√©s de que el explorador se cerr√≥.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Elimina las l√≠neas en blanco de la vista previa de tickets, en la vista de filas.',
        'Templates <-> Queues' => '',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            'El "bin/PostMasterMailAccount.pl" se reconecta al host POP3/POP3S/IMAP/IMAPS, despu√©s del n√∫mero de mensajes especificado.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'El nombre interno de la piel que debe usarse en la interfaz del agente. Por favor, verifique las pieles disponibles en Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'El nombre interno de la piel que debe usarse en la interfaz del cliente. Por favor, verifique las pieles disponibles en Frontend::Customer::Skins.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'El divisor entre el candado y el n√∫mero de ticket. Por ejemplo, \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            'El formato del asunto. \'Left\' significa \'[TicketHook#:12345] Alg√∫n asunto\', \'Right\' significa \'Alg√∫n asunto [TicketHook#:12345]\', \'None\' significa \'Alg√∫n asunto\', sin n√∫mero de ticket. Para la √∫ltima opci√≥n, es necesario que se habilite PostmasterFollowupSearchInRaw o PostmasterFollowUpSearchInReferences, para reconocer los seguimientos en base a las cabeceras de correo electr√≥nico y/o al cuerpo del mensaje.',
        'The headline shown in the customer interface.' => 'El encabezado mostrado en la interfaz del cliente.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'El identificador para un ticket, por ejemplo: Ticket#, Llamada#, MiTicket#. El valor por defecto es Ticket#.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'El logo mostrado en la parte superior de la caja de inicio de sesi√≥n de la interfaz del agente. La URL a la imagen tiene que ser relativa a la URL del directorio de im√°genes de piel.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'El texto para anteponer al asunto en una respuesta de correo electr√≥nico, por ejemplo: RE, AW, o AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'El texto para anteponer al asunto cuando un correo electr√≥nico se reenv√≠a, por ejemplo: FW, Fwd, o WG.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Este m√≥dulo y su funci√≥n PreRun() se ejecutar√°n, si as√≠ se define, por cada petici√≥n. Este m√≥dulo es √∫til para verificar algunas opciones de usuario o para desplegar noticias acerca de aplicaciones novedosas.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket Queue Overview' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Vista de resumen de los tickets',
        'TicketNumber' => '',
        'Tickets' => 'Tickets',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Tiempo en segundos que se a√±ade al tiempo actual, si se define un estado-pendiente (por defecto: 86400 = 1 d√≠a).',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => 'Elemento de la barra de herramientas para un atajo (shortcut).',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Activa las animaciones uadas en la GUI. Si tiene dificultados con dichas animaciones (por ejemplo: problemas de rendimiento), puede desactivarlas aqu√≠.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Activa la verificaci√≥n de direcciones ip remotas. Debe elegirse "No" si la aplicaci√≥n se usa, por ejemplo, a trav√©s de un servidor proxy o una conexi√≥n de acceso telef√≥nico, ya que la direcci√≥n ip remota es, en general, diferente para las peticiones.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Actualizar la bandera de ticket "Seen" ("Visto"), si ya se vi√≥ cada art√≠culo o si se cre√≥ un art√≠culo nuevo.',
        'Update and extend your system with software packages.' => 'Actualizar y extender su sistema con paquetes de software.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Actualiza el √≠ndice de escalado de ticket, luego de que un atributo de ticket se actualiz√≥.',
        'Updates the ticket index accelerator.' => 'Actualiza el acelerador de √≠ndice de ticket.',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Usa los destinatarios Cc, en la lista de respuesta Cc, al redactar una respuesta electr√≥nica en la ventana de redacci√≥n de la interfaz del agente.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Ver los resultados de rendimiento.',
        'View system log messages.' => 'Ver los mensajes del log del sistema.',
        'Wear this frontend skin' => 'Usar esta piel frontend.',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Cuando los tickets se mezclan, el cliente puede ser informado por correo electr√≥nico al seleccionar "Inform Sender". Es posible predefinir el contenido de dicha notificaci√≥n en esta √°rea de texto, que luego puede ser modificada por los agentes.',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Fila de selecci√≥n de filas favoritas. Ud. tambi√©n puede ser notificado de estas filas v√≠a correo si est√° habilitado',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets afectados. ¬øRealmente desea utilizar esta tarea?',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' =>
            '(Chequear registro MX de direcciones utilizadas al responder. ¬° No usarlo si su PC con OTRS est√° detr√°s de una l√≠nea telefonica $!)',
        '(Email of the system admin)' => '(email del administrador del sistema)',
        '(Full qualified domain name of your system)' => '(Nombre completo del dominio de su sistema)',
        '(Logfile just needed for File-LogModule!)' => '(Archivo de log necesario para File-LogModule)',
        '(Note: It depends on your installation how many dynamic objects you can use)' =>
            '(Nota: Depende de su instalaci√≥n cu√°ntos objetos din√°micos puede utilizar',
        '(Note: Useful for big databases and low performance server)' => '(Nota: Util para bases de datos grandes y servidores de bajo rendimiento)',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' =>
            '(La identidad del sistema. Cada n√∫mero de ticket y cada id de sesi√≥n http comienza con este n√∫mero)',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' =>
            '(Identificador de Ticket. Algunas personas quieren usar por ejemplo \'Ticket#\', \'Call#\' o \'MyTicket#\')',
        '(Used default language)' => '(Use el lenguaje por defecto)',
        '(Used log backend)' => '(Interface de log Utilizada)',
        '(Used ticket number format)' => '(Formato de n√∫mero de ticket utilizado)',
        'A article should have a title!' => 'Los art√≠culos deben tener t√≠tulo',
        'A message must be spell checked!' => 'El mensaje debe ser verificado ortogr√°ficamente!',
        'A message should have a To: recipient!' => 'El mensaje debe tener el destinatario Para: !',
        'A message should have a body!' => 'Los mensajes deben tener contenido',
        'A message should have a subject!' => 'Los mensajes deben tener asunto.',
        'A required field is:' => 'Un campo requerido es:',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Una respuesta es el texto por defecto para responder m√°s r√°pido (con el texto por defecto) a los clientes.',
        'A web calendar' => 'Calendario Web',
        'A web file manager' => 'Administrador web de archivos',
        'A web mail client' => 'Un cliente de correo Web',
        'Absolut Period' => 'Periodo Absoluto',
        'Account Type' => 'Tipo de cuenta',
        'Activates TypeAhead for the autocomplete feature, that enables users to type in whatever speed they desire, without losing any information. Often this means that keystrokes entered will not be displayed on the screen immediately.' =>
            'Activa TypeAhead para la funcionalidad de autocompletar, lo que le permite a los usuarios teclear a cualquier velocidad, sin perder informaci√≥n. Con frecuencia, esto significa que las pulsaciones del teclado no se mostrar√°n de forma inmediata en la pantalla.',
        'Add Customer User' => 'A√±adir Cliente',
        'Add Response' => 'A√±adir Respuesta',
        'Add System Address' => 'A√±adir Direcci√≥n de Sistema',
        'Add User' => 'A√±adir Usuario',
        'Add a new Agent.' => 'A√±adir un nuevo Agente',
        'Add a new Customer Company.' => 'A√±adir una nueva Compa√±√≠a del Cliente.',
        'Add a new Group.' => 'A√±adir nuevo Grupo',
        'Add a new Notification.' => 'Agregar una nueva Notificaci√≥n',
        'Add a new Priority.' => 'A√±adir una nueva Prioridad.',
        'Add a new Role.' => 'A√±adir un nuevo Rol',
        'Add a new SLA.' => 'A√±adir un nuevo SLA',
        'Add a new Salutation.' => 'A√±adir un nuevo Saludo',
        'Add a new Service.' => 'A√±adir un nuevo Servicio',
        'Add a new Signature.' => 'A√±adir una nueva Firma',
        'Add a new State.' => 'A√±adir un nuevo Estado',
        'Add a new System Address.' => 'A√±adir una Direcci√≥n de Sistema',
        'Add a new Type.' => 'A√±adir un nuevo Tipo',
        'Add a note to this ticket!' => 'A√±adir una nota a este ticket',
        'Add note to ticket' => 'A√±adir nota al ticket',
        'Add response' => 'A√±adir respuesta',
        'Added User "%s"' => 'Usuario "%s a√±adido"',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'A√±ade las direcciones de correo electr√≥nico de los clientes a los destinatarios, en la ventana de redacci√≥n de un art√≠culo para un ticket de la interfaz del agente.',
        'Adds the one time vacation days for the calendar number 1. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 1. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 2. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 2. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 3. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 3. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 4. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 4. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 5. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 5. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 6. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 6. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 7. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 7. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 8. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 8. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days for the calendar number 9. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones, √∫nicos para cada a√±o, al calendario n√∫mero 9. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 1. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 1. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 2. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 2. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 3. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 3. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 4. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 4. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 5. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 5. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 6. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 6. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 7. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 7. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 8. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 8. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the calendar number 9. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'A√±ade los d√≠as de vacaciones fijos (iguales para todos los a√±os), al calendario n√∫mero 9. Por favor, utilice el patr√≥n de un solo d√≠gito para los n√∫meros del 1 al 9 (en lugar de 01 - 09).',
        'Admin-Area' => '√Årea-Admin',
        'Admin-Email' => 'Correo del Administrador',
        'Admin-Password' => 'Contrase√±a-Administrador',
        'Admin-User' => 'Usuario-Admin',
        'Advisory' => 'Advertencia',
        'Agent Mailbox' => 'Buz√≥n del Agente',
        'Agent Preferences' => 'Preferencias del Agente',
        'Agent based' => 'Basado en agente',
        'Agent-Area' => '√Årea-Agente',
        'All Agent variables.' => 'Todas las variables de Agente',
        'All Agents' => 'Todos los Agentes',
        'All Customer variables like defined in config option CustomerUser.' =>
            'Todas las variables de cliente, como las declaradas en la opci√≥n de configuracion del cliente',
        'All customer tickets.' => 'Todos los tickets de un cliente',
        'All email addresses get excluded on replaying on composing an email.' =>
            'Toda direcci√≥n de correo electr√≥nico ser√° omitida mientras se compone la respuesta de un correo.',
        'All email addresses get excluded on replaying on composing and email.' =>
            'Todas las direcciones de correo electr√≥nico ser√° omitidas al componer la respuesta a un correo',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' =>
            'Todos los mensajes entrantes con esta direcci√≥n (Para:) ser√°n enviados a la fila seleccionada',
        'All messages' => 'Todos los mensajes',
        'All new tickets!' => 'Todos los nuevos tickets',
        'All tickets where the reminder date has reached!' => 'Todos los tickes que han alcanzado la fecha de recordatorio',
        'All tickets which are escalated!' => 'Todos los tickets que estan escalados',
        'Allocate CustomerUser to service' => 'Relacionar Clientes con Servicios',
        'Allocate services to CustomerUser' => 'Relacionar Servicios con Clientes',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite el uso de condiciones de b√∫squeda extendida al buscar tickets en la interfaz del agente. Con esta funcionalidad, es posible buscar condiciones como, por ejemplo, "(llave1&&llave2)" o "(llave1||llave2)".',
        'Artefact' => 'Artefacto',
        'Article Create Times' => 'Tiempo de Creaci√≥n de Art√≠culo',
        'Article created' => 'Art√≠culo Creado',
        'Article created between' => 'Art√≠culo creado entre',
        'Article filter settings' => 'Configuraci√≥n de filtro de art√≠culos',
        'Article free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana para cerrar un ticket de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana de ticket de correo electr√≥nico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana de ticket telef√≥nico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana de redacci√≥n de los mismos de la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana de campos libres de ticket de la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana para agregar una nota al ticket, en la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket owner screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana para cambiar el propietario de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket pending screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana de ticket pendiente de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana de llamada telef√≥nica saliente de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket priority screen of a zoomed ticket in the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana para cambiar la prioridad de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Article free text options shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los art√≠culos, mostrados en la ventana para cambiar el responsable de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'ArticleID' => 'Identificador de art√≠culo',
        'Attach' => 'Anexo',
        'Attachments <-> Responses' => 'Anexos <-> Respuestas',
        'Attribute' => 'Atributo',
        'Auto Response From' => 'Respuesta Autom√°tica De',
        'Bounce Ticket: ' => 'Rebotar Ticket',
        'Bounce ticket' => 'Ticket rebotado',
        'Can not create link with %s!' => 'No se puede vincular con %s!',
        'Can not delete link with %s' => 'No se puede eliminar v√≠nculo con %s',
        'Can\'t update password, invalid characters!' => 'No se puede actualizar la contrase√±a, caracteres inv√°lidos',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            '¬°No se puede actualizar su contrase√±a, porque debe contener al menos 2 caracteres en may√∫scula y 2 en min√∫scula!',
        'Can\'t update password, must be at least %s characters!' => 'No se puede actualizar la contrase√±a, se necesitan al menos %s caracteres',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' =>
            'No se puede actualizar la contrase√±a, se necesitan al menos 2 caracteres en min√∫sculas y 2 en may√∫sculas.',
        'Can\'t update password, needs at least 1 digit!' => 'No se puede actualizar la contrase√±a, se necesita al menos 1 d√≠gito.',
        'Can\'t update password, needs at least 2 characters!' => 'No se puede actualizar la contrase√±a, se necesitan al menos 2 caracteres.',
        'Can\'t update password, your new passwords do not match! Please try again!' =>
            'No se puede actualizar la contrase√±a, su nueva contrase√±a no coincide. Por favor reint√©ntelo.',
        'Category Tree' => 'Arbol de Categor√≠as',
        'Cc: (%s) added database email' => 'Cc: (%s) a√±adido a la base de datos de correo electr√≥nico',
        'Cc: (%s) added database email!' => '¬°Cc: (%s) se agreg√≥ el correo electr√≥nico registrado en la base de datos!',
        'Change %s settings' => 'Cambiar las configuraciones %s',
        'Change Attachment Relations for Response' => 'Modificar Relaciones de Archivos Adjuntos para las Respuestas',
        'Change Queue Relations for Response' => 'Modificar Relaciones de Fila para las Respuestas',
        'Change Response Relations for Attachment' => 'Modificar Relaciones de Respuesta para los Archivos Adjuntos',
        'Change Response Relations for Queue' => 'Modificar Relaciones de Respuestas para las Filas',
        'Change Times' => 'Cambio de Tiempo',
        'Change free text of ticket' => 'Cambiar el texto libre del ticket',
        'Change owner of ticket' => 'Cambiar el propietario del ticket',
        'Change priority of ticket' => 'Cambiar la prioridad del ticket',
        'Change responsible of ticket' => 'Cambiar responsable del ticket',
        'Change the ticket customer!' => 'Cambiar el cliente del ticket',
        'Change the ticket owner!' => 'Cambiar el propietario del ticket',
        'Change the ticket priority!' => 'Cambiar la prioridad del ticket',
        'Change the ticket responsible!' => 'Cambiar el responsable del ticket',
        'Change users <-> roles settings' => 'Modificar Configuraci√≥n de Usuarios <-> Roles',
        'ChangeLog' => 'Log de Cambios',
        'Child-Object' => 'Objeto-Hijo',
        'City{CustomerUser}' => 'Ciudad',
        'Clear From' => 'Vaciar De',
        'Clear To' => 'Vaciar Para',
        'Click here to report a bug!' => 'Haga click aqu√≠ para informar de un error',
        'Close Times' => 'Tiempos de Cierre',
        'Close this ticket!' => 'Cerrar este ticket',
        'Close ticket' => 'Cerrar el ticket',
        'Close type' => 'Tipo de cierre',
        'Close!' => 'Cerrar',
        'Collapse View' => 'Vista reducida',
        'Comment (internal)' => 'Comentario (interno)',
        'Comment{CustomerUser}' => 'Comentario',
        'Companies' => 'Compa√±√≠as',
        'CompanyTickets' => 'TicketsCompa√±√≠a',
        'Compose Answer' => 'Responder',
        'Compose Email' => 'Redactar Correo',
        'Compose Follow up' => 'Redactar seguimiento',
        'Config Options' => 'Opciones de Configuraci√≥n',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opciones de configuraci√≥n (ej. &lt;OTRS_CONFIG_HttpType&gt;)',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Opciones de configuraci√≥n (ej: <OTRS_CONFIG_HttpType>)',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Opciones de configuraci√≥n (ej. <OTRS_CONFIG_HttpType>).',
        'Configures a default TicketFreeField setting. "Counter" defines the free text field which should be used, "Key" is the TicketFreeKey, "Value" is the TicketFreeText and "Event" defines the trigger event.' =>
            'Define una configuraci√≥n por defecto para los campos libres del ticket. "Contador" determina el campo libre de ticket que debe usarse, "Key" y "Valor" son, respectivamente, la llave y el texto de dicho campo; "Evento" es el disparador del evento.',
        'Configures a default TicketFreeField setting. "Counter" defines the free text field which should be used, "Key" is the TicketFreeKey, "Value" is the TicketFreeText and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Define una configuraci√≥n por defecto para los campos libres del ticket. "Contador" determina el campo libre de ticket que debe usarse, "Key" y "Valor" son, respectivamente, la llave y el texto de dicho campo; "Evento" es el disparador del evento. Por favor, refi√©rase al cap√≠tulo "M√≥dulo de Eventos de Ticket" del manual del desarrollador (http://doc.otrs.org/).',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Configura el √≠ndice de texto completo. Ejecuta "bin/otrs.RebuildFulltextIndex.pl" para generar un √≠ndice nuevo.',
        'Contact customer' => 'Contactar con el cliente',
        'Country{CustomerUser}' => 'Pa√≠s',
        'Create Times' => 'Tiempos de Creaci√≥n',
        'Create and manage notifications that are sent to agents.' => 'Crear y gestionar notificaciones que se env√≠an a agentes.',
        'Create and manage response templates.' => 'Crear y gestionar plantillas de respuesta.',
        'Create new Phone Ticket' => 'Crear un nuevo Ticket Telef√≥nico',
        'Create new database' => 'Crear nueva base de datos',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' =>
            'Crear nuevos grupos para manipular los permisos de acceso por distintos grupos de agente (ej: departamento de compra, departamento de soporte, departamento de ventas,...).',
        'Create your first Ticket' => 'Cree su primer ticket.',
        'Create/Expires' => 'Creaci√≥n/Caducidad',
        'CreateTicket' => 'CrearTicket',
        'Currently only MySQL is supported in the web installer.' => 'Actualmente s√≥lo MySQL est√° disponible en el instalador web.',
        'Customer Data' => 'Informaci√≥n del cliente',
        'Customer Move Notify' => 'Notificar al Cliente al Mover',
        'Customer Owner Notify' => 'Notificar al Propietario al Mover',
        'Customer State Notify' => 'Notificaci√≥n de estado al Cliente',
        'Customer User Management' => 'Administraci√≥n de Clientes',
        'Customer Users <-> Groups' => 'Clientes <-> Grupos',
        'Customer Users <-> Groups Management' => 'Administraci√≥n de Clientes <-> Grupos',
        'Customer Users <-> Services' => 'Clientes <-> Servicios',
        'Customer Users <-> Services Management' => 'Administraci√≥n de Clientes <-> Servicios',
        'Customer history' => 'Historia del cliente',
        'Customer history search' => 'Historia de b√∫squedas del cliente',
        'Customer history search (e. g. "ID342425").' => 'Historia de b√∫squedas del cliente (ej: "ID342425")',
        'Customer item (icon) which shows the open tickets of this customer as info block.' =>
            'Art√≠culo del cliente (√≠cono) que muestra los tickets abiertos de dicho cliente como bloque de informaci√≥n.',
        'Customer user will be needed to have a customer history and to login via customer panel.' =>
            'El cliente se necesita para tener un historial e iniciar sesi√≥n a trav√©s del panel de clientes.',
        'CustomerID{CustomerUser}' => 'Identificador del cliente',
        'CustomerUser' => 'Cliente',
        'DB Admin Password' => 'Contrase√±a del Administrador de la BD',
        'DB Admin User' => 'Usuario Admin de la BD',
        'DB Type' => 'Tipo de BD',
        'DB connect host' => 'Host de conexi√≥n a la Base de datos',
        'DEPRECATED! This setting is not used any more and will be removed in a future version of OTRS.' =>
            'EN DESUSO! Esta opci√≥n no se usar√° mas y  ser√° eliminada en una versi√≥n futura de OTRS.',
        'Database Backend' => 'Base de Datos',
        'Database-User' => 'Usuario-Base de datos',
        'Days' => 'D√≠as',
        'Default' => 'Por Defecto',
        'Default Charset' => 'Juego de caracteres por defecto',
        'Default Language' => 'Lenguaje por defecto',
        'Default skin for interface.' => 'Piel por defecto para la interfaz.',
        'Defines the =hHeight for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define la altura del editor de texto enriquecido. Proporcione un n√∫mero (pixeles) o un porcentaje (relativo).',
        'Defines the default selection of the free key field number 1 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 1 para art√≠culos (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 1 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 1 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 10 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 10 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 11 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 11 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 12 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 12 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 13 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 13 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 14 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 14 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 15 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 15 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 16 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 16 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 2 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 2 para art√≠culos (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 2 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 2 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 3 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 3 para art√≠culos (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 3 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 3 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 4 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 4 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 5 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 5 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 6 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 6 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 7 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 7 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 8 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 8 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free key field number 9 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de llave libre n√∫mero 9 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 1 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 1 para art√≠culos (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 1 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 1 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 10 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 10 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 11 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 11 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 12 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 12 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 13 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 13 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 14 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 14 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 15 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 15 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 16 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 16 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 2 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 2 para art√≠culos (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 2 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 2 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 3 for articles (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 3 para art√≠culos (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 3 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 3 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 4 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 4 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 5 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 5 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 6 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 6 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 7 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 7 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 8 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 8 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default selection of the free text field number 9 for tickets (if more than one option is provided).' =>
            'Define el valor seleccionado por defecto en el campo de texto libre n√∫mero 9 para tickets (si es que hay m√°s de una opci√≥n).',
        'Defines the default sort criteria for all queues displayed in the queue view, after sort by priority is done.' =>
            'Define el criterio de ordenamiento por defecto para todas las filas mostradas en la vista de filas, luego de haberse ordenado por prioridad.',
        'Defines the difference from now (in seconds) of the free time field number 1\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo n√∫mero 1.',
        'Defines the difference from now (in seconds) of the free time field number 2\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo n√∫mero 2.',
        'Defines the difference from now (in seconds) of the free time field number 3\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo n√∫mero 3.',
        'Defines the difference from now (in seconds) of the free time field number 4\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo n√∫mero 4.',
        'Defines the difference from now (in seconds) of the free time field number 5\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo n√∫mero 5.',
        'Defines the difference from now (in seconds) of the free time field number 6\'s default value.' =>
            'Define la diferencia (en segundos) entre el momento actual  y el valor por defecto del campo libre de tiempo n√∫mero 6.',
        'Defines the free key field number 1 for articles to add a new article attribute.' =>
            'Define el campo de llave libre n√∫mero 1 de los art√≠culos, para agregar un atributo de art√≠culo nuevo.',
        'Defines the free key field number 1 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de llave libre n√∫mero 1 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 10 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 10 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 11 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 11 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 12 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 12 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 13 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 13 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 14 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 14 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 15 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 15 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 16 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 16 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 2 for articles to add a new article attribute.' =>
            'Define el campo de llave libre n√∫mero 2 de los art√≠culos, para agregar un atributo de art√≠culo nuevo.',
        'Defines the free key field number 2 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 2 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 3 for articles to add a new article attribute.' =>
            'Define el campo de llave libre n√∫mero 3 de los art√≠culos, para agregar un atributo de art√≠culo nuevo.',
        'Defines the free key field number 3 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 3 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 4 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 4 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 5 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 5 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 6 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 6 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 7 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 7 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 8 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 8 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free key field number 9 for tickets to add a new ticket attribute.' =>
            'Define el campo de llave libre n√∫mero 9 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 1 for articles to add a new article attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 1 de los art√≠culos, para agregar un atributo de art√≠culo nuevo.',
        'Defines the free text field number 1 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 1 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 10 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 10 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 11 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 11 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 12 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 12 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 13 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 13 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 14 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 14 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 15 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 15 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 16 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 16 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 2 for articles to add a new article attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 2 de los art√≠culos, para agregar un atributo de art√≠culo nuevo.',
        'Defines the free text field number 2 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 2 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 3 for articles to add a new article attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 3 de los art√≠culos, para agregar un atributo de art√≠culo nuevo.',
        'Defines the free text field number 3 for ticket to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 3 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 4 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 4 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 5 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 5 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 6 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 6 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 7 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 7 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 8 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 8 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free text field number 9 for tickets to add a new ticket attribute.' =>
            'Define el valor del campo de texto libre n√∫mero 9 de los tickets, para agregar un atributo de ticket nuevo.',
        'Defines the free time key field number 1 for tickets.' => 'Define el valor del campo de tiempo libre n√∫mero 1 de los tickets.',
        'Defines the free time key field number 2 for tickets.' => 'Define el valor del campo de tiempo libre n√∫mero 2 de los tickets.',
        'Defines the free time key field number 3 for tickets.' => 'Define el valor del campo de tiempo libre n√∫mero 3 de los tickets.',
        'Defines the free time key field number 4 for tickets.' => 'Define el valor del campo de tiempo libre n√∫mero 4 de los tickets.',
        'Defines the free time key field number 5 for tickets.' => 'Define el valor del campo de tiempo libre n√∫mero 5 de los tickets.',
        'Defines the free time key field number 6 for tickets.' => 'Define el valor del campo de tiempo libre n√∫mero 6 de los tickets.',
        'Defines the hours and week days of the calendar number 1, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 1.',
        'Defines the hours and week days of the calendar number 2, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 2.',
        'Defines the hours and week days of the calendar number 3, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 3.',
        'Defines the hours and week days of the calendar number 4, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 4.',
        'Defines the hours and week days of the calendar number 5, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 5.',
        'Defines the hours and week days of the calendar number 6, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 6.',
        'Defines the hours and week days of the calendar number 7, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 7.',
        'Defines the hours and week days of the calendar number 8, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 8.',
        'Defines the hours and week days of the calendar number 9, to count the working time.' =>
            'Define las horas y los d√≠as laborales de la semana, para el calendario n√∫mero 9.',
        'Defines the http link for the free text field number 1 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 1 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 10 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 10 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 11 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 11 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 12 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 12 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 13 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 13 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 14 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 14 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 15 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 15 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 16 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 16 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 2 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 2 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 3 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 3 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 4 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 4 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 5 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 5 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 6 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 6 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 7 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 7 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 8 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 8 (se usar√° en cada vista de ticket).',
        'Defines the http link for the free text field number 9 for tickets (it will be used in every ticket view).' =>
            'Define el v√≠nculo http para el campo de texto libre de ticket n√∫mero 9 (se usar√° en cada vista de ticket).',
        'Defines the list of online repositories. Another installations can be used as repositoriy, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Define la lista de repositorios en l√≠nea. Otras instalaciones pueden usarse como repositorio, por ejemplo: Llave="http://example.com/otrs/public.pl?Action=PublicRepository;File=" y Contenido="Algun Nombre".',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            'Define el tama√±o m√°ximo (en bytes) para cargar archivos, a trav√©s del explorador.',
        'Defines the name of the calendar number 1.' => 'Define el nombre del calendario n√∫mero 1.',
        'Defines the name of the calendar number 2.' => 'Define el nombre del calendario n√∫mero 2.',
        'Defines the name of the calendar number 3.' => 'Define el nombre del calendario n√∫mero 3.',
        'Defines the name of the calendar number 4.' => 'Define el nombre del calendario n√∫mero 4.',
        'Defines the name of the calendar number 5.' => 'Define el nombre del calendario n√∫mero 5.',
        'Defines the name of the calendar number 6.' => 'Define el nombre del calendario n√∫mero 6.',
        'Defines the name of the calendar number 7.' => 'Define el nombre del calendario n√∫mero 7.',
        'Defines the name of the calendar number 8.' => 'Define el nombre del calendario n√∫mero 8.',
        'Defines the name of the calendar number 9.' => 'Define el nombre del calendario n√∫mero 9.',
        'Defines the time zone of the calendar number 1, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 1, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the time zone of the calendar number 2, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 2, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the time zone of the calendar number 3, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 3, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the time zone of the calendar number 4, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 4, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the time zone of the calendar number 5, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 5, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the time zone of the calendar number 6, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 6, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the time zone of the calendar number 7, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 7, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the time zone of the calendar number 8, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 8, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the time zone of the calendar number 9, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario n√∫mero 9, que luego puede asignarse a una fila espec√≠fica.',
        'Defines the years (in future and in past) which can get selected in free time field number 1.' =>
            'Define los a√±os (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo n√∫mero 1.',
        'Defines the years (in future and in past) which can get selected in free time field number 2.' =>
            'Define los a√±os (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo n√∫mero 2.',
        'Defines the years (in future and in past) which can get selected in free time field number 3.' =>
            'Define los a√±os (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo n√∫mero 3.',
        'Defines the years (in future and in past) which can get selected in free time field number 4.' =>
            'Define los a√±os (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo n√∫mero 4.',
        'Defines the years (in future and in past) which can get selected in free time field number 5.' =>
            'Define los a√±os (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo n√∫mero 5.',
        'Defines the years (in future and in past) which can get selected in free time field number 6.' =>
            'Define los a√±os (tanto pasados como futuros) que pueden seleccionarse en el campo libre de tiempo n√∫mero 6.',
        'Defines whether the free time field number 1 is optional or not.' =>
            'Define si el campo libre de tiempo n√∫mero 1 es opcional o no.',
        'Defines whether the free time field number 2 is optional or not.' =>
            'Define si el campo libre de tiempo n√∫mero 2 es opcional o no.',
        'Defines whether the free time field number 3 is optional or not.' =>
            'Define si el campo libre de tiempo n√∫mero 3 es opcional o no.',
        'Defines whether the free time field number 4 is optional or not.' =>
            'Define si el campo libre de tiempo n√∫mero 4 es opcional o no.',
        'Defines whether the free time field number 5 is optional or not.' =>
            'Define si el campo libre de tiempo n√∫mero 5 es opcional o no.',
        'Defines whether the free time field number 6 is optional or not.' =>
            'Define si el campo libre de tiempo n√∫mero 6 es opcional o no.',
        'Delay time between autocomplete queries.' => 'Tiempo de retrazo entre consultas de autocompletado.',
        'Delete old database' => 'Eliminar BD antigua',
        'Delete this ticket!' => 'Eliminar este ticket',
        'Detail' => 'Detalle',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            'Determina si el contenedor de los resultados de la b√∫squeda de autocompletado, debe ajustar din√°micamente su anchura.',
        'Determines if the statatistics module may generate ticket lists.' =>
            'Determina si el m√≥dulo de estad√≠sticas debe generar listas de tickets.',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box (to avoid the use of destructive queries, such as DROP DATABASE, and also to steal user passwords).' =>
            'Deshabilita el instalador web (http://yourhost.example.com/otrs/installer.pl), para prevenir que el sistema sufra un secuestro (hijack). Si se selecciona "No", el sistema puede ser reinstalado y la configuraci√≥n b√°sica actual se usar√° para pre-poblar las preguntas, en el script del instalador. As√≠ mismo, al estar deshabilitado, es imposible hacer uso de: el agente gen√©rico, el manejador de paquetes y la caja de consultas SQL (para evitar el uso de consultas da√±inas, como DROP DATABASE, o para robar contrase√±as).',
        'Discard all changes and return to the compose screen' => 'Descartar todos los cambios y volver a la pantalla de redacci√≥n',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' =>
            'Clasificar o filtrar correos entrantes basado en encabezamientos X-Headers! Puede utilizar expresiones regulares.',
        'Do you really want to delete this Object?' => 'Seguro que desea eliminar este objeto?',
        'Do you really want to reinstall this package (all manual changes get lost)?' =>
            'Realmente desea reinstalar este paquete (todos los cambios manuales se perder√°n)?',
        'Don\'t forget to add a new response a queue!' => 'No olvide incluir una nueva respuesta en la fila',
        'Don\'t forget to add a new user to groups and/or roles!' => 'No olvide a√±adir los nuevos usuarios a grupos y/o roles',
        'Don\'t forget to add a new user to groups!' => 'No olvide incluir un nuevo usuario a los grupos',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'No trabaje con el usuario 1 (cuenta del sistema). Cree usuarios nuevos.',
        'Download Settings' => 'Descargar Configuraci√≥n',
        'Download all system config changes.' => 'Descargar todos los cambios de configuraci√≥n',
        'Drop Database' => 'Eliminar Base de Datos',
        'Dynamic-Object' => 'Objeto-Din√°mico',
        'Edit Article' => 'Editar Art√≠culo',
        'Edit Response' => 'Modificar Respuesta',
        'Edit default services.' => 'Modificar los servicios por defecto.',
        'Email based' => 'Basado en e-mail',
        'Email{CustomerUser}' => 'Correo electr√≥nico',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            'Habilita o deshabilita la funcionalidad de autocompletado para la b√∫squeda de clientes en la interfaz del agente.',
        'Escaladed Tickets' => 'Tickets Escalados',
        'Escalation - First Response Time' => 'Escalado - Tiempo Primer Respuesta',
        'Escalation - Solution Time' => 'Escalado - Tiempo Soluci√≥n',
        'Escalation - Update Time' => 'Escalado - Tiempo Actualizaci√≥n',
        'Escalation Times' => 'Tiempos de escalado',
        'Escalation in' => 'Escalado en',
        'Escalation time' => 'Tiempo de escalado',
        'Event is required!' => 'Debe especificar Evento',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all TicketFreeField elements need the same event.' =>
            'Registro de m√≥dulo de evento. Para aumentar el desempe√±o, puede definirse un disparador de evento (Por ejemplo: Evento => TicketCreate). Esto es posible s√≥lo si todos los campos libres de ticket requieren el mismo evento.',
        'Example for free text' => 'Ejemplo de texto libre',
        'Expand View' => 'Vista ampliada',
        'Experimental "Slim" skin which tries to save screen space for power users.' =>
            'Piel "Slim" experimental, que pretende ahorrar espacio en la pantalla para usuarios avanzados.',
        'Explanation' => 'Explicaci√≥n',
        'Export Config' => 'Exportar Configuraci√≥n',
        'False' => 'Falso',
        'Fax{CustomerUser}' => 'Fax',
        'FileManager' => 'Administrador de Archivos',
        'Filelist' => 'Lista de Archivos',
        'Filter for Language' => 'Filtro para Lenguaje',
        'Filter for Responses' => 'Filtro para Respuestas',
        'Filter name' => 'Nombre del filtro',
        'Filtername' => 'Nombre del filtro',
        'Firstname{CustomerUser}' => 'Nombre',
        'Follow up' => 'Seguimiento',
        'Follow up notification' => 'Notificaci√≥n de seguimiento',
        'For more info see:' => 'Para mas informaci√≥n vea:',
        'For very complex stats it is possible to include a hardcoded file.' =>
            'Para una estad√≠stica muy compleja es posible incluir un archivo preconfigurado',
        'Forward ticket: ' => 'Reenviar ticket',
        'Frontend' => 'Interfaz de usuario',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'B√∫squeda de texto en Art√≠culo (ej. "Mar*in" o "Baue*")',
        'Go' => 'Ir',
        'Go to group %s' => 'Ir al grupo %s',
        'Group %s' => 'Grupo %s',
        'Group Ro' => 'Grupo Ro',
        'Group based' => 'Basado en grupo',
        'Group selection' => 'Selecci√≥n de Grupo',
        'Hash/Fingerprint' => 'Hash/Huella digital',
        'Have a lot of fun!' => 'Disfr√∫telo!',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Aqu√≠ puede definir la serie de valores. Tiene la posibilidad de seleccionar uno o m√°s elementos. Luego, puede seleccionar los atributos de los elementos. Cada atributo ser√° mostrado como un elemento de la serie. Si no selecciona ning√∫n atributo, todos los atributos del elemento ser√°n utilizados si genera una estad√≠stica. Asimismo un nuevo atributo es a√±adido desde la √∫ltima configuraci√≥n.',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection, all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Aqu√≠ Ud. puede definir el eje x. Puede seleccionar un elemento con un boton circular (radio button). Si no selecciona un atributo, todos los atributos del elemento ser√°n usados si genera una estad√≠stica, apenas se agrega un nuevo atributo desde la √∫tima configuraci√≥n',
        'Here you can define the x-axis. You can select one element via the radio button. Then you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Aqui puede definir el eje-x. Puede seleccionar un elemento usando la casilla de selecci√≥n. Luego debe seleccionar dos o m√°s atributos del elemento. Si Ud. no selecciona ninguno, todos los atributos del elemento se utilizar√°n para generar una estad√≠stica. Asimismo un nuevo atributo es a√±adido desde la √∫ltima configuraci√≥n.',
        'Here you can insert a description of the stat.' => 'Aqu√≠ puede insertar una descripci√≥n de la estad√≠stica.',
        'Here you can select the dynamic object you want to use.' => 'Aqu√≠ puede seleccionar el elemento din√°mico que desea utilizar',
        'Home' => 'Inicio',
        'If "DB" was selected for SessionModule, a column for the identifiers in session table must be specified.' =>
            'Si "DB" se eligi√≥ como SessionModule, puede especificarse el nombre de la columna para los identificadores de la tabla de sesi√≥n.',
        'If "DB" was selected for SessionModule, a column for the values in session table must be specified.' =>
            'Si "DB" se eligi√≥ como SessionModule, puede especificarse el nombre de la columna para los valores de la tabla de sesi√≥n.',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si el Modo Seguro no est√° activado act√≠velo con SysConfig ya que su aplicaci√≥n est√° en funcionamiento.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' =>
            'Si un nuevo archivo preconfigurado est√° disponible, este atributo se le mostrar√° y podr√° seleccionar uno',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' =>
            'Si el ticket est√° cerrado y el cliente env√≠a un seguimiento al mismo, √©ste ser√° bloqueado para el antiguo propietario',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' =>
            'Si un ticket no ha sido respondido es este tiempo, s√≥lo este ticket se mostrar√°',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' =>
            'Si un agente bloquea un ticket y no env√≠a una respuesta en este tiempo, el ticket ser√° desbloqueado autom√°ticamente. El Ticket ser√° visible por todos los dem√°s agentes.',
        'If configured, all emails sent by the application will contain an X-Header with this organization or company name.' =>
            'Si se configura, todos los correos electr√≥nicos enviados por la aplicaci√≥n contendr√°n una Cabecera-X con el nombre de compa√±√≠a que se especique aqu√≠.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' =>
            'Si no se selecciona algo, no habr√° permisos en este grupo (los tickets no estar√°n disponibles para el cliente).',
        'If set, this address is used as envelope from header in outgoing notifications. If no address is specified, the envelope from header is empty.' =>
            'Si se define, esta direcci√≥n se usa como sobre para el encabezado de las notificaciones salientes.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Si ha fijado una clave para su base de datos, debe especificarla aqu√≠. Si no, d√©jelo en blanco. Por razones de seguridad, recomendamos establecer una clave para root. PAra m√°s informaci√≥n, consulte la documentaci√≥n de su base de datos.',
        'If you need the sum of every column select yes.' => 'Si necesita las suma de cada columna seleccione S√≠',
        'If you need the sum of every row select yes' => 'Si necesita la suma de cada fila seleccione S√≠',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' =>
            'Si utiliza expresiones regulares, puede tambi√©n usar el valor encontrado en () as [***] en \'Set\'.',
        'If you want to account time, please provide Subject and Text!' =>
            'Si desea contabilizar el tiempo, porfavor ingrese Sujeto y Texto',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Si desea instalar OTRS en otro tipo de base de datos, por favor lea el archivo README.database.',
        'Image' => 'Imagen',
        'In this form you can select the basic specifications.' => 'En esta pantalla puede seleccionar las especificaciones b√°sicas',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' =>
            'De esta forma, Ud. puede editar directamente las claves configuradas en Kernel/Config.pm.',
        'Incident' => 'Incidente',
        'Information about the Stat' => 'Informaci√≥n sobre la estad√≠stica',
        'Insert of the common specifications' => 'Inserte las especificaciones comunes',
        'Invalid SessionID!' => 'Identificador de sesi√≥n inv√°lido.',
        'Is Job Valid' => 'La tarea es v√°lida',
        'Is Job Valid?' => '¬øLa tarea es v√°lida?',
        'It\'s useful for ASP solutions.' => 'Esto es √∫til para soluciones ASP.',
        'It\'s useful for a lot of users and groups.' => 'Es √∫til para gestionar muchos usuarios y grupos.',
        'Job-List' => 'Lista de Tareas',
        'Keyword' => 'Palabra clave',
        'Keywords' => 'Palabras clave',
        'Last update' => 'Ultima Actualizaci√≥n',
        'Lastname{CustomerUser}' => 'Apellido',
        'Link attachments to responses templates.' => 'Vincular archivos adjuntos con plantillas de respuesta.',
        'Link responses to queues.' => 'Vincular respuestas con filas.',
        'Link this ticket to an other objects!' => 'Enlazar este ticket a otros objetos',
        'Link this ticket to other objects!' => '¬°Vincular este ticket con otros objetos!',
        'Link to Parent' => 'Enlazar con el padre',
        'Linked as' => 'Vinculado como',
        'List of IE6-specific CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS espec√≠ficos para IE6 que siempre se cargar√°n para la interfaz del cliente.',
        'List of IE7-specific CSS files to always be loaded for the agent interface.' =>
            'Lista de archivos CSS espec√≠ficos para IE7 que siempre se cargar√°n para la interfaz del agente.',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS espec√≠ficos para IE7 que siempre se cargar√°n para la interfaz del cliente.',
        'Load Settings' => 'Cargar Configuraci√≥n',
        'Lock it to work on it!' => 'Bloquearlo para trabajar en √©l',
        'Log file location is only needed for File-LogModule!' => '¬°La ubicaci√≥n del archivo log s√≥lo se requiere para el Archivo-M√≥duloLog!',
        'Logfile' => 'Archivo de log',
        'Logfile too large, you need to reset it!' => 'Archivo de log muy grande, necesita reinicializarlo',
        'Login failed! Your username or password was entered incorrectly.' =>
            'Inicio de sesi√≥n fallido. El nombre de usuario o contrase√±a fue introducido incorrectamente.',
        'Logout successful. Thank you for using OTRS!' => 'Sesi√≥n terminada satisfactoriamente.',
        'Lookup' => 'Observar',
        'Mail Management' => 'Administraci√≥n de Correo',
        'Mailbox' => 'Buz√≥n',
        'Manage Response-Queue Relations' => 'Administrar Relaciones Respuesta-Fila',
        'Manage Responses' => 'Gestionar Respuestas',
        'Manage Responses <-> Attachments Relations' => 'Administrar Relaciones Respuestas <-> Archivos Adjuntos',
        'Match' => 'Coincidir',
        'Max. displayed tickets' => 'N√∫mero m√°ximo de tickets mostrados.',
        'Max. shown Tickets a page' => 'N√∫mero m√°ximo de tickets mostrados por p√°gina',
        'Maximum size (in characters) of the customer info table in the queue view.' =>
            'N√∫mero m√°ximo (en caracteres) de la tabla de informaci√≥n del cliente en la vista de filas.',
        'Merge this ticket!' => 'Fusionar este ticket',
        'Message for new Owner' => 'Mensaje para el nuevo propietario',
        'Message sent to' => 'Mensaje enviado a',
        'Misc' => 'Miscel√°neo',
        'Mobile{CustomerUser}' => 'M√≥vil',
        'Modified' => 'Modificado',
        'Module to inform agents, via the agent interface, about the used charset. A notification is displayed, if the default charset is not used, e.g. in tickets.' =>
            'M√≥dulo para informar a los agentes, a trav√©s de su propia interfaz, acerca del juego de caracteres usado. Se despliega una notificaci√≥n en caso de que no se est√© usando el juego de caracteres por defecto en, por ejemplo, los tickets.',
        'Modules' => 'M√≥dulos',
        'Move notification' => 'Notificaci√≥n de movimientos',
        'Multiple selection of the output format.' => 'Selecci√≥n m√∫ltiple del formato de salida',
        'MyTickets' => 'MisTickets',
        'Name is required!' => 'Debe especificar Nombre',
        'Need a valid email address or don\'t use a local email address' =>
            'Se requiere una direcci√≥n de correo electr√≥nica v√°lida, que no sea local.',
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
        'New Title' => 'T√≠tulo nuevo',
        'New Type' => 'Tipo nuevo',
        'New account created. Sent Login-Account to %s.' => 'Cuenta nueva creada. Cuenta de inicio de sesi√≥n enviada a %s.',
        'New messages' => 'Nuevos mensajes',
        'New password again' => 'Repetir Contrase√±a',
        'Next Week' => 'Pr√≥xima semana',
        'No * possible!' => 'No * posible!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' =>
            'No hay paquetes para el Framework solicitado en este Repositorio en L√≠nea, pero hay paquetes para otros Frameworks',
        'No Packages or no new Packages in selected Online Repository!' =>
            'No hay paquetes o no hay paquetes nuevos en el Repositorio en L√≠nea seleccionado',
        'No Permission' => 'No tiene autorizaci√≥n',
        'No means, send agent and customer notifications on changes.' => '"No" significa enviar a los agentes y clientes notificaciones al realizar cambios.',
        'No time settings.' => 'Sin especificaci√≥n de tiempo',
        'Note Text' => 'Nota!',
        'Notification (Customer)' => 'Notificaci√≥n (Cliente)',
        'Notifications' => 'Notificaciones',
        'OTRS DB Name' => 'Nombre de la BD OTRS',
        'OTRS DB Password' => 'Contrase√±a para BD del usuario OTRS',
        'OTRS DB User' => 'Usuario de BD OTRS',
        'OTRS sends an notification email to the customer if the ticket is moved.' =>
            'OTRS env√≠a una notificaci√≥n por correo al cliente si el ticket se mueve',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' =>
            'OTRS env√≠a una notificaci√≥n por correo al cliente si el propietario del ticket cambia',
        'OTRS sends an notification email to the customer if the ticket state has changed.' =>
            'OTRS env√≠a una notificaci√≥n por correo al cliente si el estado del ticket cambia',
        'Object already linked as %s.' => 'Objecto ya vinculado como %s.',
        'Of couse this feature will take some system performance it self!' =>
            'De acuerdo a esta caracter√≠stica se efectuar√°n ciertas mejoras en el sistema por s√≠ mismo.',
        'Online' => 'En l√≠nea',
        'Only for ArticleCreate Event.' => 'Solo para el Evento CrearArt√≠culo',
        'Open Tickets' => 'Tickets Abiertos',
        'Options ' => 'Opciones',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' =>
            'Opciones de los datos del cliente activo (ej. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' =>
            'Opciones del usuario activo  (ej. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' =>
            'Opciones de los datos del cliente actual (ej. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' =>
            'Opciones del usuario que solicit√≥ la acci√≥n (ej. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' =>
            'Opciones del usuario activo que solicit√≥ esta acci√≥n (ej. <OTRS_CURRENT_UserFirstname>)',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' =>
            'Opciones del usuario actual que solicit√≥ √©sta acci√≥n (ej. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' =>
            'Opcciones de los datos del ticket (ej. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Opciones de la informaci√≥n del ticket (ej: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Opciones de la informaci√≥n del ticket (ej. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' =>
            'Opciones de los datos del Ticket (ej. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Other Options' => 'Otras Opciones',
        'Out Of Office' => 'Fuera de la oficina',
        'POP3 Account Management' => 'Administraci√≥n de cuenta POP3',
        'Package' => 'Paquete',
        'Package not correctly deployed! You should reinstall the Package again!' =>
            'Paquete instalado incorrectamente. Debe reinstalar el paquete.',
        'Package not correctly deployed! You should reinstall the package again!' =>
            '¬°El paquete no se instal√≥ correctamente, necesita instalarlo nuevamente!',
        'Package not correctly deployed, you need to deploy it again!' =>
            'El paquete no ha sido correctamente instalado, necesita instalarlo nuevamente!',
        'Package verification failed' => 'Fall√≥ la verificaci√≥n del paquete',
        'Package verification failed!' => '¬°La verificaci√≥n del paquete fall√≥!',
        'Param 1' => 'Par√°metro 1',
        'Param 2' => 'Par√°metro 2',
        'Param 3' => 'Par√°metro 3',
        'Param 4' => 'Par√°metro 4',
        'Param 5' => 'Par√°metro 5',
        'Param 6' => 'Par√°metro 6',
        'Parent-Object' => 'Objeto-Padre',
        'Password is already in use! Please use an other password!' => 'La contrase√±a ya se est√° utilizando. Por favor, utilice otra.',
        'Password is already used! Please use an other password!' => 'La contrase√±a ya fue usada. Por favor, utilice otra.',
        'Passwords doesn\'t match! Please try it again!' => 'Las contrase√±as no coinciden. Por favor, intente nuevamente.',
        'Pending Times' => 'Tiempos en espera',
        'Pending messages' => 'Mensajes pendientes',
        'Pending type' => 'Tipo pendiente',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' =>
            'Configuraci√≥n de permisos. Puede seleccionar uno o m√°s grupos para hacer visibles las estad√≠sticas configuradas a distintos agentes',
        'Permissions to change the ticket owner in this group/queue.' => 'Permiso para cambiar el propietario del ticket en este grupo/fila',
        'PhoneView' => 'Vista telef√≥nica',
        'Phone{CustomerUser}' => 'Tel√©fono',
        'Please contact your admin' => 'Por favor, contacte a su administrador.',
        'Please fill out this form to recieve login credentials.' => 'Por favor, llene este formulario para recibir las credenciales de inicio de sesi√≥n.',
        'Please supply a' => 'Por favor, proporcione un(o/a)',
        'Please supply a first name' => 'Por favor, proporcione un nombre',
        'Please supply a last name' => 'Por favor, proporcione un apellido',
        'PostMaster Filter' => 'Filtro del Administrador del Correo',
        'PostMaster Mail Account' => 'Cuenta del Administrador del Correo',
        'Print this ticket!' => 'Imprimir este ticket',
        'Prio' => 'Prio',
        'Problem' => 'Problema',
        'Queue <-> Auto Responses Management' => 'Administraci√≥n de Fila <-> Respuestas Autom√°ticas',
        'Queue ID' => 'Id de la Fila',
        'Queue Management' => 'Administraci√≥n de Filas',
        'QueueView Refresh Time' => 'Tiempo de Actualizaci√≥n de la Vista de Filas',
        'Realname' => 'Nombre real',
        'Rebuild' => 'Reconstruir',
        'Recipients' => 'Destinatarios',
        'Reminder' => 'Recordatorio',
        'Reminder messages' => 'Mensajes recordatorios',
        'Required Field' => 'Campos obligatorios',
        'Response Management' => 'Administraci√≥n de Respuestas',
        'Responses' => 'Respuestas',
        'Responses <-> Attachments Management' => 'Administraci√≥n de Respuestas <-> Anexos',
        'Responses <-> Queue Management' => 'Administraci√≥n de Respuestas <-> Filas',
        'Responses <-> Queues' => 'Respuestas <-> Filas',
        'Return to the compose screen' => 'Volver a la pantalla de redacci√≥n',
        'Role' => 'Rol',
        'Roles <-> Groups Management' => 'Administraci√≥n de Roles <-> Grupos',
        'Roles <-> Users' => 'Roles <-> Usuarios',
        'Roles <-> Users Management' => 'Administraci√≥n de Roles <-> Usuarios',
        'Run Search' => 'Realizar b√∫squeda',
        'Save Job as?' => '¬øGuardar Tarea como?',
        'Save Search-Profile as Template?' => 'Guardar perfil de b√∫squeda como patr√≥n?',
        'Schedule' => 'Horario',
        'Search Result' => 'Buscar resultados',
        'Search Ticket' => 'Buscar Ticket',
        'Search for' => 'Buscar por',
        'Search for customers (wildcards are allowed).' => 'Buscar clientes (se permite el uso de comodines).',
        'Search-Profile as Template?' => '¬øDefinir perfil de b√∫squeda como Platilla?',
        'Secure Mode need to be enabled!' => '¬°El Modo Seguro debe estar habilitado!',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'El Modo Seguro debe estar deshabilitado para poder reinstalar usado el instalador web.',
        'Select Box' => 'Ventana de selecci√≥n',
        'Select Box Result' => 'Seleccione tipo de resultado',
        'Select Source (for add)' => 'Seleccionar Fuente (para a√±adir)',
        'Select the customeruser:service relations.' => 'Seleccione las relaciones cliente:servicio.',
        'Select the element, which will be used at the X-axis' => 'Seleccione el elemento, que ser√° utilizado en el eje-X',
        'Select the restrictions to characterise the stat' => 'Seleccione las restricciones para caracterizar la estad√≠stica',
        'Select the role:user relations.' => 'Seleccionar las relaciones Rol-Cliente',
        'Select the user:group permissions.' => 'Seleccionar los permisos del usuario:grupo',
        'Select your QueueView refresh time.' => 'Seleccione su tiempo de actualizaci√≥n de la vista de filas.',
        'Select your default spelling dictionary.' => 'Seleccione su diccionario por defecto.',
        'Select your frontend Charset.' => 'Seleccione su juego de caracteres.',
        'Select your frontend QueueView.' => 'Seleccione su Vista de Filas.',
        'Select your frontend language.' => 'Seleccione su idioma de trabajo.',
        'Select your out of office time.' => 'Elija el tiempo fuera de la oficina.',
        'Select your screen after creating a new ticket.' => 'Seleccione la pantalla a mostrar despu√©s de crear un ticket',
        'Selection needed' => 'Selecci√≥n obligatoria',
        'Send Administrative Message to Agents' => 'Enviar Mensaje Administrativo a los Agentes',
        'Send Notification' => 'Enviar Notificaci√≥n',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' =>
            'Notif√≠queme si un cliente solicita un seguimiento y yo soy el due√±o del ticket.',
        'Send me a notification of an watched ticket like an owner of an ticket.' =>
            'Enviarme notificaci√≥n de un ticket vigilado como si fuera un ticket del que soy due√±o.',
        'Send no notifications' => 'No enviar notificaciones',
        'Sent new password to: %s' => 'Contrase√±a nueva enviada a: %s',
        'Sent password token to: %s' => 'Informaci√≥n de contrase√±a enviada a: %s',
        'Sessions' => 'Sesiones',
        'Set customer user and customer id of a ticket' => 'Asignar agente y cliente de un ticket',
        'Set this ticket to pending!' => 'Poner este ticket como pendiente',
        'Sets the default charset for the web interface to use (should represent the charset used to create the database or, in some cases, the database management system being used). "utf-8" is a good choice for environments expecting many charsets. You can specify another charset here (i.e. "iso-8859-1"). Please be sure that you will not be receiving foreign emails, or text, otherwise this could lead to problems.' =>
            'Define el juego de caracteres por defecto para la interfaz web (deber√≠a ser el mismo juego de caracteres que se us√≥ al crear la base de datos o, en algunos casos, el que utilice el manejador de base de datos del sistema). "utf-8" es una buena elecci√≥n para ambientes que esperan varios juegos de caracteres, sin embargo, es posible especificar uno diferente (por ejemplo: "iso-8859-1"). Por favor, aseg√∫rese de que no recibir√° correos o texto extranjeros, ya que esto podr√≠a causar problemas.',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            'Define el n√∫mero m√≠nimo de caracteres que debe haber, antes de enviar una consulta de autocompletado.',
        'Sets the number of lines that are displayed in the preview of messages (e.g. for tickets in the QueueView).' =>
            'Define el n√∫mero de l√≠neas mostradas en la vista previa de los mensajes (por ejemplo: para los tickets en la vista de filas).',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            'Define el n√∫mero de resultados de b√∫squeda mostrados por la funcionalidad de autocompletado.',
        'Show' => 'Mostrar',
        'Shows the ticket history!' => 'Mostrar la historia del ticket',
        'Site' => 'Sitio',
        'Solution' => 'Soluci√≥n',
        'Sort by' => 'Ordenado por',
        'Source' => 'Origen',
        'Spell Check' => 'Chequeo Ortogr√°fico',
        'State Type' => 'Tipo de Estado',
        'Static-File' => 'Archivo-Est√°tico',
        'Stats-Area' => 'Area de Estad√≠sticas',
        'Street{CustomerUser}' => 'Calle',
        'Sub-Queue of' => 'Subfila de',
        'Sub-Service of' => 'Sub-Servicio de',
        'Subscribe' => 'Subscribir',
        'Symptom' => 'S√≠ntoma',
        'System History' => 'Historia del Sistema',
        'System State Management' => 'Administraci√≥n de Estados del Sistema',
        'System Status' => 'Estado del Sistema',
        'Systemaddress' => 'Direcciones de correo del sistema',
        'Take care that you also updated the default states in you Kernel/Config.pm!' =>
            'Recuerde tambi√©n actualizar los estados en su archivo Kernel/Config.pm! ',
        'The Ticket was locked' => 'El Ticket ha sido bloqueado',
        'The User Name you wish to have' => 'El Nombre de Usuario que desea tener',
        'The logo shown in the header of the agent interface. The URL to the image must be a relative URL to the skin image directory.' =>
            'El logo mostrado en el encabezado de la interfaz del agente. La URL a la imagen tiene que ser relativa a la URL del directorio de im√°genes de piel.',
        'The logo shown in the header of the customer interface. The URL to the image must be a relative URL to the skin image directory.' =>
            'El logo mostrado en el encabezado de la interfaz del cliente. La URL a la imagen tiene que ser relativa a la URL del directorio de im√°genes de piel.',
        'The message being composed has been closed.  Exiting.' => 'El mensaje que se estaba redactando ha sido cerrado. Saliendo...',
        'These values are read-only.' => 'Estos valores son de s√≥lo-lectura.',
        'These values are required.' => 'Estos valores son obligatorios.',
        'This account exists.' => 'Esta cuenta existe.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' =>
            'Esto es √∫til si desea que nadie pueda obtener el resultado de una estad√≠stica o la misma a√∫n no est√° configurada',
        'This values are read only.' => 'Estos valores son de s√≥lo lectura.',
        'This values are required.' => 'Estos valores son necesarios.',
        'This window must be called from compose window' => 'Esta ventana debe ser llamada desde la ventana de redacci√≥n',
        'Ticket Information' => 'Informaci√≥n del Ticket',
        'Ticket Lock' => 'Ticket Bloqueado',
        'Ticket Number Generator' => 'Generador de n√∫meros de Tickets',
        'Ticket Search' => 'Buscar ticket',
        'Ticket Status View' => 'Ver Estado del Ticket',
        'Ticket Type is required!' => 'Se necesita el tipo de Ticket',
        'Ticket escalation!' => 'Escalado de ticket',
        'Ticket free text options shown in the close ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para cerrar un ticket de la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the email ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de ticket de correo electr√≥nico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the move ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana para mover un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de ticket telef√≥nico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free text options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de los tickets, mostrados en la ventana de redacci√≥n de art√≠culos, en la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
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
            'Opciones para los campos libres de los tickets, mostrados en la ventana de llamada telef√≥nica saliente de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
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
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de ticket de correo electr√≥nico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the move ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana para mover un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the phone ticket screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de ticket telef√≥nico, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
        'Ticket free time options shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de redacci√≥n de art√≠culos, en la interfaz del agente. Las  configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
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
            'Opciones para los campos libres de tiempo de los tickets, mostrados en la ventana de llamada telef√≥nica saliente de un ticket, en la interfaz del agente. Las configuraciones posibles son: 0 = Deshabilitado, 1 = Habilitado, 2 = Habilitado y obligatorio.',
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
        'Ticket selected for bulk action!' => 'Ticket seleccionado para acci√≥n m√∫ltiple!',
        'Ticket unlock!' => 'Ticket desbloqueado',
        'Ticket-Area' => '√Årea-Ticket',
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
        'Title of the stat.' => 'T√≠tulo de la estad√≠stica',
        'Title{CustomerUser}' => 'Saludo',
        'Title{user}' => 'T√≠tulo',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' =>
            'Para obtener los atributos (ej. <OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' =>
            'Para obtener el atributo del art√≠culo (ej. <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> y <OTRS_CUSTOMER_Body>).',
        'To protect your privacy, active or/and remote content has blocked.' =>
            'Para proteger su privacidad, contenido activo y/o remoto ha sido bloqueado.',
        'To: (%s) replaced with database email' => 'Para: (%s) sustituido con el correo electr√≥nico de la base de datos',
        'To: (%s) replaced with database email!' => '¬°Para: (%s) se reemplaz√≥ con el correo electr√≥nico registrado en la base de datos!',
        'Top of Page' => 'Inicio de p√°gina',
        'Total hits' => 'Total de coincidencias',
        'U' => 'A',
        'Unable to parse Online Repository index document!' => 'Incapaz de interpretar el documento √≠ndice del Repositorio en L√≠nea',
        'Uniq' => '√önico',
        'Unlock Tickets' => 'Desbloquear Tickets',
        'Unlock to give it back to the queue!' => 'Desbloquear para regresarlo a la fila',
        'Unsubscribe' => 'Desubscribir',
        'Use utf-8 it your database supports it!' => 'Use utf-8 si su base de datos lo permite!',
        'Useable options' => 'Opciones disponibles',
        'User Management' => 'Administraci√≥n de usuarios',
        'User will be needed to handle tickets.' => 'Se necesita un usuario para manipular los tickets.',
        'Username{CustomerUser}' => 'Nombre de Usuario',
        'Users' => 'Usuarios',
        'Users <-> Groups' => 'Usuarios <-> Grupos',
        'Users <-> Groups Management' => 'Administraci√≥n de Usuarios <-> Grupos',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            'Usa texto enriquecido para visualizar y editar: art√≠culos, saludos, firmas, respuestas est√°ndar, auto respuestas y notificaciones.',
        'Warning! This tickets will be removed from the database! This tickets are lost!' =>
            'Advertencia: Estos tickets se eliminar√°n de la base de datos y ser√°n inaccesibles',
        'Watch notification' => 'Vigilar notificaci√≥n',
        'Web-Installer' => 'Instalador Web',
        'WebMail' => 'CorreoWeb',
        'WebWatcher' => 'ObservadorWeb',
        'Welcome to OTRS' => 'Bienvenido a OTRS',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            'Cuando los tickets se mezclan, se agregar√° una nota autom√°ticamente al ticket que ya no est√° activo. Es posible definir el contenido de dicha nota en esta √°rea de texto (el agente no puede modificar este texto).',
        'Wildcards are allowed.' => 'Se permite el uso de comodines.',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Con una estadistica inv√°lida, no es posible generar estad√≠sticas.',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' =>
            'Con los campos de entrada y selecci√≥n, puede configurar las estad√≠sticas a sus necesidades. Los elementos de estad√≠sticas que puede editar dependen de c√≥mo haya sido configurado por el administrador',
        'Yes means, send no agent and customer notifications on changes.' =>
            '"S√≠" significa no enviar notificaci√≥n a los agentes y clientes al realizarse cambios.',
        'Yes, save it with name' => 'S√≠, guardarlo con nombre',
        'You got new message!' => 'Tiene un mensaje nuevo.',
        'You have not created a ticket yet.' => 'Usted a√∫n no ha creado tickets.',
        'You have to select two or more attributes from the select field!' =>
            'Debe seleccionar dos o m√°s atributos del campo seleccionado',
        'You need a email address (e. g. customer@example.com) in To:!' =>
            'Necesita una direcci√≥n de correo (ej: cliente@ejemplo.com) en Para:!',
        'You need min. one selected Ticket!' => 'Necesita al menos seleccionar un Ticket!',
        'You need to account time!' => 'Necesita contabilizar el tiempo',
        'You need to activate %s first to use it!' => 'Necesita activar %s primero para utilizarlo.',
        'Your email address is new' => 'Su direcci√≥n de correo es nueva',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Su correo con n√∫mero de ticket "<OTRS_TICKET>"  fue rebotado a "<OTRS_BOUNCE_TO>". Contacte con dicha direcci√≥n para m√°s informaci√≥n.',
        'Your language' => 'Su idioma',
        'Your own Ticket' => 'Sus tickets',
        'Zip{CustomerUser}' => 'C√≥digo Postal',
        'accept license' => 'aceptar licencia',
        'before' => 'antes',
        'customer realname' => 'Nombre del cliente',
        'default \'hot\'' => 'por defecto \'hot\'',
        'don\'t accept license' => 'no aceptar la licencia',
        'down' => 'abajo',
        'false' => 'falso',
        'for agent firstname' => 'nombre del agente',
        'for agent lastname' => 'apellido del agente',
        'for agent login' => 'login del agente',
        'for agent user id' => 'id del agente',
        'kill all sessions' => 'finalizar todas las sesiones',
        'kill session' => 'finalizar la sesi√≥n',
        'maximal period form' => 'periodo m√°ximo del formulario',
        'modified' => 'modificado',
        'new ticket' => 'nuevo ticket',
        'next step' => 'pr√≥ximo paso',
        'send' => 'enviar',
        'settings' => 'configuraci√≥n',
        'sort downward' => 'ordenar descendente',
        'sort upward' => 'ordenar ascendente',
        'to get the first 20 character of the subject' => 'para obtener los primeros 20 caracteres del asunto ',
        'to get the first 5 lines of the email' => 'para obtener las primeras 5 l√≠neas del correo',
        'to get the from line of the email' => 'para obtener la l√≠nea Para del correo',
        'to get the realname of the sender (if given)' => 'para obtener el nombre del emisor (si lo proporcion√≥)',
        'up' => 'arriba',
        'utf8' => 'utf8',
        'x' => 'x',

    };
    # $$STOP$$
    return;
}

1;
