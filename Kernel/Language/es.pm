# --
# Kernel/Language/es.pm - provides Spanish language translation
# Copyright (C) 2003-2006 Jorge Becerra <jorge at hab.desoft.cu>
# Copyright (C) 2007 Carlos Oyarzabal <carlos.oyarzabal at grupocash.com.mx>
# Copyright (C) 2008 Pelayo Romero Martí­n <pelayo.romero at gmail.com>
# Copyright (C) 2009 Gustavo Azambuja <gazambuja at gmail.com>
# Copyright (C) 2009 Emiliano Gonzalez <egonzalez@ergio.com.ar>
# Copyright (C) 2013 Enrique Matías Sánchez <quique@unizar.es>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::es;

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

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Sí',
        'No' => 'No',
        'yes' => 'sí',
        'no' => 'no',
        'Off' => 'Desactivado',
        'off' => 'desactivado',
        'On' => 'Activado',
        'on' => 'activado',
        'top' => 'inicio',
        'end' => 'fin',
        'Done' => 'Hecho',
        'Cancel' => 'Cancelar',
        'Reset' => 'Restablecer',
        'more than ... ago' => 'hace más de ...',
        'in more than ...' => 'en más de ...',
        'within the last ...' => 'en los últimos ...',
        'within the next ...' => 'en los próximos ...',
        'Created within the last' => 'Creado en los últimos',
        'Created more than ... ago' => 'Creado hace más de ...',
        'Today' => 'Hoy',
        'Tomorrow' => 'Mañana',
        'Next week' => 'Próxima semana',
        'day' => 'día',
        'days' => 'días',
        'day(s)' => 'día(s)',
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
        'year' => 'año',
        'years' => 'años',
        'year(s)' => 'año(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
        's' => 's',
        'Time unit' => 'Unidad de tiempo',
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
        'Setting' => 'Ajuste',
        'Settings' => 'Ajustes',
        'Example' => 'Ejemplo',
        'Examples' => 'Ejemplos',
        'valid' => 'válido',
        'Valid' => 'Válido',
        'invalid' => 'no válido',
        'Invalid' => 'No válido',
        '* invalid' => '* no válido',
        'invalid-temporarily' => 'temporalmente-no-válido',
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
        '...Back' => '...Atrás',
        '-none-' => '-ninguno-',
        'none' => 'ninguno',
        'none!' => '¡ninguno!',
        'none - answered' => 'ninguno  - respondido',
        'please do not edit!' => '¡Por favor, no editar!',
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
        'Lite' => 'Ligera',
        'User' => 'Usuario',
        'Username' => 'Nombre de usuario',
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
        'CustomerIDs' => 'Identificadores de los clientes',
        'customer' => 'cliente',
        'agent' => 'agente',
        'system' => 'sistema',
        'Customer Info' => 'Información del cliente',
        'Customer Information' => 'Información del cliente',
        'Customer Companies' => 'Empresas de los clientes',
        'Company' => 'Empresa',
        'go!' => '¡ir!',
        'go' => 'ir',
        'All' => 'Todo',
        'all' => 'todo',
        'Sorry' => 'Disculpe',
        'update!' => '¡actualizar!',
        'update' => 'actualizar',
        'Update' => 'Actualizar',
        'Updated!' => '¡Actualizado!',
        'submit!' => '¡enviar!',
        'submit' => 'enviar',
        'Submit' => 'Enviar',
        'change!' => '¡modificar!',
        'Change' => 'Modificar',
        'change' => 'modificar',
        'click here' => 'pulse aquí',
        'Comment' => 'Comentario',
        'Invalid Option!' => '¡Opción no válida!',
        'Invalid time!' => '¡Hora no válida!',
        'Invalid date!' => '¡Fecha no válida!',
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
        'before/after' => 'antes/después',
        'Fulltext Search' => 'Búsqueda de texto completo',
        'Data' => 'Datos',
        'Options' => 'Opciones',
        'Title' => 'Título',
        'Item' => 'Elemento',
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
        'Added!' => '¡Añadido!',
        'Category' => 'Categoría',
        'Viewer' => 'Visor',
        'Expand' => 'Expandir',
        'Small' => 'Pequeño',
        'Medium' => 'Mediano',
        'Large' => 'Grande',
        'Date picker' => 'Selector de fecha',
        'Show Tree Selection' => 'Mostrar selección en árbol',
        'The field content is too long!' => 'El contenido del campo es demasiado largo',
        'Maximum size is %s characters.' => 'La cantidad máxima de caracteres es %s',
        'This field is required or' => 'Este campo es obligatorio o',
        'New message' => 'Mensaje nuevo',
        'New message!' => '¡Mensaje nuevo!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Por favor, responda a este ticket para regresar a la vista normal de la cola.',
        'You have %s new message(s)!' => '¡Tiene %s nuevo(s) mensaje(s)!',
        'You have %s reminder ticket(s)!' => '¡Tiene %s recordatorio(s) de ticket(s)!',
        'The recommended charset for your language is %s!' => '¡El juego de caracteres recomendado para su idioma es %s!',
        'Change your password.' => 'Cambie su contraseña',
        'Please activate %s first!' => 'Por favor, active %s antes.',
        'No suggestions' => 'Sin sugerencias',
        'Word' => 'Palabra',
        'Ignore' => 'Ignorar',
        'replace with' => 'reemplazar con',
        'There is no account with that login name.' => 'No existe ninguna cuenta con ese nombre de usuario.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Inicio de sesión fallido. El nombre de usuario o contraseña son incorrectas.',
        'There is no acount with that user name.' => 'No hay ninguna cuenta con ese nombre de usuario',
        'Please contact your administrator' => 'Por favor, contacte con su administrador',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Autenticación exitosa, pero no se encontró ningún registro del cliente en el backend cliente. Por favor, contactar con su administrador',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'La cuenta de correo ya existe. Por favor inicie sesión o restablezca su contraseña\'',
        'Logout' => 'Cerrar la sesión',
        'Logout successful. Thank you for using %s!' => 'Sesión cerrada con éxito. ¡Gracias por utilizar %s!',
        'Feature not active!' => '¡Característica no activa!',
        'Agent updated!' => '¡Agente actualizado!',
        'Database Selection' => 'Selección de la base de datos',
        'Create Database' => 'Crear la base de datos',
        'System Settings' => 'Ajustes del sistema',
        'Mail Configuration' => 'Configuración del correo',
        'Finished' => 'Finalizado',
        'Install OTRS' => 'Instalar OTRS',
        'Intro' => 'Introducción',
        'License' => 'Licencia',
        'Database' => 'Base de datos',
        'Configure Mail' => 'Configurar el correo',
        'Database deleted.' => 'Base de datos borrada.',
        'Enter the password for the administrative database user.' => 'Introduzca la contraseña del usuario administrador de la base de datos.',
        'Enter the password for the database user.' => 'Introduzca la contraseña del usuario de la base de datos.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Si ha establecido una contraseña para root en su base de datos, debe introducirla aquí. Si no, deje este campo en blanco.',
        'Database already contains data - it should be empty!' => 'La base de datos ya contiene datos. Debería estar vacía.',
        'Login is needed!' => '¡Se requiere inicio de sesión!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'No es posible iniciar sesión debido a un mantenimiento del sistema programado',
        'Password is needed!' => '¡Se requiere una contraseña!',
        'Take this Customer' => 'Utilizar este cliente',
        'Take this User' => 'Utilizar este usuario',
        'possible' => 'posible',
        'reject' => 'rechazar',
        'reverse' => 'revertir',
        'Facility' => 'Instalación',
        'Time Zone' => 'Zona horaria',
        'Pending till' => 'Pendiente hasta',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'No use la cuenta de superusuario para trabajar con OTRS. Cree nuevos agentes y trabaje con esas cuentas.',
        'Dispatching by email To: field.' => 'Despachar por el campo Para: del correo electrónico',
        'Dispatching by selected Queue.' => 'Despachar por la cola seleccionada',
        'No entry found!' => '¡No se encontró ninguna entrada!',
        'Session invalid. Please log in again.' => 'Sesión no válida. Por favor, inicie sesión de nuevo.',
        'Session has timed out. Please log in again.' => 'La sesión ha caducado. Por favor, inicie sesión de nuevo.',
        'Session limit reached! Please try again later.' => 'Se ha alcanzado el límite de sesiones. Por favor, inténtelo de nuevo más tarde.',
        'No Permission!' => '¡No tiene permiso!',
        '(Click here to add)' => '(Pulse aquí para añadir)',
        'Preview' => 'Vista previa',
        'Package not correctly deployed! Please reinstall the package.' =>
            'El paquete no fue desplegado correctamente. Por favor, reinstale el paquete.',
        '%s is not writable!' => '¡%s no es modificable!',
        'Cannot create %s!' => '¡No se puede crear %s!',
        'Check to activate this date' => 'Marque para activar esta fecha',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Tiene habilitado «Fuera de la oficina», ¿desea inhabilitarlo?',
        'News about OTRS releases!' => 'Noticias acerca de lanzamientos de OTRS!',
        'Customer %s added' => 'Añadido el cliente %s',
        'Role added!' => '¡Rol añadido!',
        'Role updated!' => '¡Rol actualizado!',
        'Attachment added!' => '¡Añadido fichero adjunto!',
        'Attachment updated!' => '¡Actualizado fichero adjunto!',
        'Response added!' => '¡Respuesta añadida!',
        'Response updated!' => '¡Respuesta actualizada!',
        'Group updated!' => '¡Grupo actualizado!',
        'Queue added!' => '¡Cola añadida!',
        'Queue updated!' => '¡Cola actualizada!',
        'State added!' => '¡Estado añadido!',
        'State updated!' => '¡Estado actualizado!',
        'Type added!' => '¡Tipo añadido!',
        'Type updated!' => '¡Tipo actualizado!',
        'Customer updated!' => '¡Cliente actualizado!',
        'Customer company added!' => '¡Empresa del cliente añadido!',
        'Customer company updated!' => '¡Empresa del cliente actualizado!',
        'Note: Company is invalid!' => 'Nota: La empresa no es válida.',
        'Mail account added!' => '¡Cuenta de correo añadida!',
        'Mail account updated!' => '¡Cuenta de correo actualizada!',
        'System e-mail address added!' => '¡Cuenta de correo del sistemas añadido!',
        'System e-mail address updated!' => '¡Cuenta de correo del sistema actualizada!',
        'Contract' => 'Contrato',
        'Online Customer: %s' => 'Cliente conectado: %s',
        'Online Agent: %s' => 'Agente conectado: %s',
        'Calendar' => 'Calendario',
        'File' => 'Archivo',
        'Filename' => 'Nombre del archivo',
        'Type' => 'Tipo',
        'Size' => 'Tamaño',
        'Upload' => 'Cargar',
        'Directory' => 'Directorio',
        'Signed' => 'Firmado',
        'Sign' => 'Firma',
        'Crypted' => 'Cifrado',
        'Crypt' => 'Cifrar',
        'PGP' => 'PGP',
        'PGP Key' => 'Clave PGP',
        'PGP Keys' => 'Claves PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certificado S/MIME',
        'S/MIME Certificates' => 'Certificados S/MIME',
        'Office' => 'Oficina',
        'Phone' => 'Teléfono',
        'Fax' => 'Fax',
        'Mobile' => 'Móvil',
        'Zip' => 'Código Postal',
        'City' => 'Ciudad',
        'Street' => 'Calle',
        'Country' => 'País',
        'Location' => 'Localidad',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' =>
            'Nota de seguridad: ¡Ud. debe activar %s porque la aplicación ya está ejecutándose!',
        'Unable to parse repository index document.' => 'No es posible analizar el documento índice del repositorio.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'En este repositorio no se encontraros paquetes para su versión del marco de trabajo, sólo contiene paquetes para otras versiones del marco de trabajo.',
        'No packages, or no new packages, found in selected repository.' =>
            'No se encontraron paquetes (o paquetes nuevos) en el repositorio seleccionado.',
        'Edit the system configuration settings.' => 'Editar los ajustes de configuración del sistema.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'La información sobre ACL de la base de datos no está sincronizada con la configuración del sistema. Por favor, despliegue todas las ACL.',
        'printed at' => 'impreso en',
        'Loading...' => 'Cargando...',
        'Dear Mr. %s,' => 'Estimado Sr. %s.',
        'Dear Mrs. %s,' => 'Estimada Sra. %s.',
        'Dear %s,' => 'Estimado %s.',
        'Hello %s,' => 'Hola %s.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Esta cuenta no está permitida para registrarse. Por favor, póngase en contacto con el personal de apoyo.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Creada la nueva cuenta. Enviada la información de inicio de sesión a %s. Por favor, revise su correo electrónico.',
        'Please press Back and try again.' => 'Por favor, presione Atrás e inténtelo de nuevo.',
        'Sent password reset instructions. Please check your email.' => 'Enviadas instrucción de restablecimiento de contraseña. Por favor, revise su correo electrónico',
        'Sent new password to %s. Please check your email.' => 'Enviada nueva contraseña a %s. Por favor, revise su correo electrónico.',
        'Upcoming Events' => 'Próximos eventos',
        'Event' => 'Evento',
        'Events' => 'Eventos',
        'Invalid Token!' => '¡Ficha no válida!',
        'more' => 'más',
        'Collapse' => 'Contraer',
        'Shown' => 'Mostrados',
        'Shown customer users' => 'Usuarios cliente mostrados',
        'News' => 'Noticias',
        'Product News' => 'Noticias de productos',
        'OTRS News' => 'Noticias de OTRS',
        '7 Day Stats' => 'Estadísticas semanales',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'La información de la gestión de procesos de la base de datos no está sincronizada con la configuración del sistema. Por favor, sincronice todos los procesos.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Paquete no verificado por el grupo OTRS. Se recomienda que no use este paquete.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>Si continúa e instala este paquete, se podrían producir los siguientes problemas<br><br>&nbsp;-Problemas de seguridad<br>&nbsp;-Problemas de estabilidad<br>&nbsp;-Problemas de rendimiento<br><br>Tenga en cuenta que los problemas causados por usar este paquete no están cubiertos por los contratos de servicio de OTRS.<br><br>',
        'Mark' => 'Marcar',
        'Unmark' => 'Desmarcar',
        'Bold' => 'Negrita',
        'Italic' => 'Itálica',
        'Underline' => 'Subrayado',
        'Font Color' => 'Color de letra',
        'Background Color' => 'Color de fondo',
        'Remove Formatting' => 'Eliminar el formato',
        'Show/Hide Hidden Elements' => 'Mostrar/Ocultar elementos ocultos',
        'Align Left' => 'Alinear a la izquierda',
        'Align Center' => 'Alinear al centro',
        'Align Right' => 'Alinear a la derecha',
        'Justify' => 'Justificado',
        'Header' => 'Encabezado',
        'Indent' => 'Sangrar',
        'Outdent' => 'Reducir sangría',
        'Create an Unordered List' => 'Crear una lista sin orden',
        'Create an Ordered List' => 'Crear una lista ordenada',
        'HTML Link' => 'Enlace HTML',
        'Insert Image' => 'Insertar una imagen',
        'CTRL' => 'CTRL',
        'SHIFT' => 'Mayúsculas',
        'Undo' => 'Deshacer',
        'Redo' => 'Rehacer',
        'Scheduler process is registered but might not be running.' => 'El proceso del planificador está registrado, pero podría no estar ejecutándose.',
        'Scheduler is not running.' => 'El planificador no está en ejecución.',
        'All sessions have been killed, except for your own.' => 'Todas las sesiones se han cerrado, excepto la suya propia.',
        'Can\'t contact registration server. Please try again later.' => 'No es posible contactar con el servidor de registro. Por favor, inténtelo de nuevo más tarde.',
        'No content received from registration server. Please try again later.' =>
            'No se ha recibido ningún contenido del servidor de registro. Por favor, inténtelo de nuevo más tarde.',
        'Problems processing server result. Please try again later.' => 'Problemas al procesar el resultado del servidor. Por favor, inténtelo de nuevo más tarde.',
        'Username and password do not match. Please try again.' => 'El usuario y la contraseña no coinciden. Por favor, inténtelo de nuevo.',
        'The selected process is invalid!' => '¡El proceso seleccionado no es válido!',
        'Upgrade to %s now!' => 'Actualizar a %s ahora!',
        '%s Go to the upgrade center %s' => '%s Vaya al centro de actualizaciones %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'La licencia de su %s esta por expirar. Por favor contactese con %s para renovar su contrato!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Una actualización de su %s esta disponible, pero existe un conflicto con la versión del framework! Por favor actualice su framework primero!',
        'Your system was successfully upgraded to %s.' => 'Su sistema su actualizado satisfactoriamente a %s',
        'There was a problem during the upgrade to %s.' => 'Hubo un problema durante la actualización a %s',
        '%s was correctly reinstalled.' => '%s fue correctamente instalado',
        'There was a problem reinstalling %s.' => 'Hubo un problema reinstalando %s',
        'Your %s was successfully updated.' => 'Su %s fue actualizado satisfactoriamente',
        'There was a problem during the upgrade of %s.' => 'Hubo un problema durante la actualización de %s',
        '%s was correctly uninstalled.' => '%s fue correctamente desinstalado',
        'There was a problem uninstalling %s.' => 'Hubo un problema desinstalando %s',

        # Template: AAACalendar
        'New Year\'s Day' => 'Año nuevo',
        'International Workers\' Day' => 'Día del trabajo',
        'Christmas Eve' => 'Nochebuena',
        'First Christmas Day' => 'Navidad',
        'Second Christmas Day' => 'Segundo día de navidad',
        'New Year\'s Eve' => 'Nochevieja',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS como solicitante',
        'OTRS as provider' => 'OTRS como proveedor',
        'Webservice "%s" created!' => '¡Servicio web «%s» creado!',
        'Webservice "%s" updated!' => '¡Servicio web «%s» actualizado!',

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
        'Preferences updated successfully!' => '¡Las preferencias se actualizaron satisfactoriamente!',
        'User Profile' => 'Perfil del usuario',
        'Email Settings' => 'Ajustes del correo electrónico',
        'Other Settings' => 'Otros ajustes',
        'Change Password' => 'Cambiar la contraseña',
        'Current password' => 'Contraseña actual',
        'New password' => 'Nueva contraseña',
        'Verify password' => 'Verificar la contraseña',
        'Spelling Dictionary' => 'Diccionario ortográfico',
        'Default spelling dictionary' => 'Diccionario ortográfico predeterminado',
        'Max. shown Tickets a page in Overview.' => 'Cantidad máxima de tickets a mostrar en la vista general',
        'The current password is not correct. Please try again!' => 'La contraseña actual no es correcta. ¡Inténtelo de nuevo!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'No es posible actualizar la contraseña, su nueva contraseña no coinciden. ¡Inténtelo de nuevo!',
        'Can\'t update password, it contains invalid characters!' => 'No es posible actualizar la contraseña, contiene caracteres no válidos.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'No es posible actualizar la contraseña, debe tener al menor %s caracteres.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'No es posible actualizar la contraseña, debe contener al menos 2 minúsculas y 2 mayúsculas.',
        'Can\'t update password, it must contain at least 1 digit!' => 'No es posible actualizar la contraseña, debe contener al menos un dígito.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'No es posible actualizar la contraseña, debe contener al menos 2 caracteres.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'No es posible actualizar la contraseña, esta contraseña ya ha sido usada. Elija una nueva.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Seleccione el carácter separador a usar en los archivos CSV (estadísticas y búsquedas). Si no selecciona ningún separador aquí, se usará el separador predeterminado para su idioma.',
        'CSV Separator' => 'Separador CSV',

        # Template: AAAStats
        'Stat' => 'Estadísticas',
        'Sum' => 'Suma',
        'No (not supported)' => 'No (no soportado)',
        'Days' => 'Días',
        'Please fill out the required fields!' => '¡Por favor, proporcione los campos requeridos!',
        'Please select a file!' => '¡Por favor, seleccione un archivo!',
        'Please select an object!' => '¡Por favor, seleccione un objeto!',
        'Please select a graph size!' => '¡Por favor, seleccione un tamaño de gráfico!',
        'Please select one element for the X-axis!' => '¡Por favor, seleccione un elemento para el eje X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            '¡Por favor, seleccione un único elemento o desactive el botón «Fijo» donde el campo seleccionado está marcado!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            '¡Si usa una casilla de selección, debe seleccionar algunos atributos de dicho campo!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            '¡Por favor, inserte un valor en el campo de entrada seleccionado o desactive la casilla «Fijo»!',
        'The selected end time is before the start time!' => '¡La fecha de finalización seleccionada es anterior a la de inicio!',
        'You have to select one or more attributes from the select field!' =>
            '¡Debe seleccionar uno o más atributos del campo de selección!',
        'The selected Date isn\'t valid!' => '¡La fecha seleccionada no es válida!',
        'Please select only one or two elements via the checkbox!' => '¡Por favor, seleccione sólo uno o dos elementos usando la casilla de selección!',
        'If you use a time scale element you can only select one element!' =>
            '¡Si utiliza una escala de tiempo, sólo puede seleccionar un elemento!',
        'You have an error in your time selection!' => '¡Tiene un error en la selección del tiempo!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'El intervalo de tiempo para informes es demasiado pequeño, ¡por favor use una escala más grande!',
        'The selected start time is before the allowed start time!' => '¡El momento de inicio seleccionado es anterior al permitido!',
        'The selected end time is after the allowed end time!' => '¡El momento de finalización seleccionado es posterior al permitido!',
        'The selected time period is larger than the allowed time period!' =>
            '¡El periodo de tiempo seleccionado es mayor que el permitido!',
        'Common Specification' => 'Especificación común',
        'X-axis' => 'Eje-X',
        'Value Series' => 'Serie de valores',
        'Restrictions' => 'Restricciones',
        'graph-lines' => 'gráfica-de-líneas',
        'graph-bars' => 'gráfica-de-barras ',
        'graph-hbars' => 'gráfica-de-barras-horiz',
        'graph-points' => 'gráfica-de-puntos',
        'graph-lines-points' => 'gráfica-punteada',
        'graph-area' => 'gráfica-de-área',
        'graph-pie' => 'gráfico-de-tarta',
        'extended' => 'extendido',
        'Agent/Owner' => 'Agente/Propietario',
        'Created by Agent/Owner' => 'Creado por Agente/Propietario',
        'Created Priority' => 'Prioridad de creación',
        'Created State' => 'Estado de creación',
        'Create Time' => 'Fecha de creación',
        'CustomerUserLogin' => 'Nombre de usuario del cliente',
        'Close Time' => 'Fecha de cierre',
        'TicketAccumulation' => 'Acumulacion de tickets',
        'Attributes to be printed' => 'Atributos a imprimir',
        'Sort sequence' => 'Ordenar la secuencia',
        'Order by' => 'Ordenar por',
        'Limit' => 'Límite',
        'Ticketlist' => 'Lista de tickets',
        'ascending' => 'ascendente',
        'descending' => 'descendente',
        'First Lock' => 'Primer bloqueo',
        'Evaluation by' => 'Evaluación por',
        'Total Time' => 'Tiempo total',
        'Ticket Average' => 'Media de los tickets',
        'Ticket Min Time' => 'Tiempo mínimo de los tickets',
        'Ticket Max Time' => 'Teimpo máximo de los tickets',
        'Number of Tickets' => 'Número de tickets',
        'Article Average' => 'Media de los artículos',
        'Article Min Time' => 'Tiempo mínimo de los artículos',
        'Article Max Time' => 'Tiempo máximo de los artículos',
        'Number of Articles' => 'Número de artículos',
        'Accounted time by Agent' => 'Tiempo utilizado por el Agente',
        'Ticket/Article Accounted Time' => 'Tiempo utilizado por ticket/artículo',
        'TicketAccountedTime' => 'Tiempo utilizado para el ticket',
        'Ticket Create Time' => 'Hora de creación del ticket',
        'Ticket Close Time' => 'Hora de finalización del ticket',

        # Template: AAASupportDataCollector
        'Unknown' => 'desconocido',
        'Information' => 'Información',
        'OK' => 'Aceptar',
        'Problem' => 'Problema',
        'Webserver' => 'Servidor Web',
        'Operating System' => 'Sistema Operativo',
        'OTRS' => 'OTRS',
        'Table Presence' => 'Presecia De Tablas',
        'Internal Error: Could not open file.' => 'Error Interno: No se pude abrir el archivo',
        'Table Check' => 'Comprobación De Tablas',
        'Internal Error: Could not read file.' => 'Error Interno: No se pudo leer el archivo',
        'Tables found which are not present in the database.' => 'Tablas encontradas que no se encuentran presentes en la base de datos',
        'Database Size' => 'Tamaño de la Base De Datos',
        'Could not determine database size.' => 'No se pudo determinar el tamaño de la base de datos',
        'Database Version' => 'Versión De La Base De Datos',
        'Could not determine database version.' => 'No se pudo determinar la versión de la base de datos',
        'Client Connection Charset' => 'Juego de Caracteres de la Conexión del Cliente',
        'Setting character_set_client needs to be utf8.' => 'El ajuste character_set_client necesita ser utf8.',
        'Server Database Charset' => 'Juego de Caracteres del Servidor de Base de Datos',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'el ajuste de character_set_database necesita ser UNICODE o UTF8.',
        'Table Charset' => 'Juego de Caracter de la Tabla',
        'There were tables found which do not have utf8 as charset.' => 'Se encontrarón tablas las cuales el juego de caracteres no es utf8.',
        'InnoDB Log File Size' => 'Tamaño del Archivo Log InnoDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'El ajuste innodb_log_file_size debe ser de al menos 256 MB.',
        'Maximum Query Size' => 'Tamaño Máximo de la Consulta',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'El ajuste \'max_allowed_packet\' debe ser mayor de 20 MB,',
        'Query Cache Size' => 'Tamaño de la Cache de la Consulta',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'El ajuste \'query_cache_size\' debe ser usada (mayor de 10 MB pero no menor de 512 MB).',
        'Default Storage Engine' => 'Motor Predeterminado de Almacenamiento',
        'Tables with a different storage engine than the default engine were found.' =>
            'Tablas con diferente motor de almacenamiento que la de por defecto fueron encontradas.',
        'MySQL 5.x or higher is required.' => 'MySQL 5.x o mayor es requerida.',
        'NLS_LANG Setting' => 'Ajuste NLS_LANG',
        'NLS_LANG must be set to AL32UTF8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG debe ser configurada a AL32UTF8 (ejm. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Ajuste NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT debe ser configurado a \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'El ajuste NLS_DATE_FORMAT Comprobar SQL',
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'El ajuste client_encoding necesita ser UNICODE o UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'El ajuste server_encoding necesita ser UNICODE o UTF8.',
        'Date Format' => 'Formato de Fecha',
        'Setting DateStyle needs to be ISO.' => 'El ajuste DateStyle necesita ser ISO.',
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL 8.x o mayor es requerido.',
        'OTRS Disk Partition' => 'Partición del Disco OTRS',
        'Disk Usage' => 'Uso del Disco',
        'The partition where OTRS is located is almost full.' => 'La partición donde se localiza OTRS está casi lleno.',
        'The partition where OTRS is located has no disk space problems.' =>
            'La partición donde se localiza OTRS no tiene problemas de espacio de disco.',
        'Disk Partitions Usage' => 'Uso de la Partición del Disco',
        'Distribution' => 'Distribución',
        'Could not determine distribution.' => 'No se pudo determinar la distribución.',
        'Kernel Version' => 'Versión del Kernel',
        'Could not determine kernel version.' => 'No se pudo determinar la versión del kernel.',
        'System Load' => 'Carga del Sistema',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'La carga del sistema debe ser como máximo el número de CPUs que el sistema tiene (ejm. una carga de 8 o menos en un sistema con 8 CPUs esta OK).',
        'Perl Modules' => 'Módulos De Perl',
        'Not all required Perl modules are correctly installed.' => 'No todos los modulos Perl requeridos están instalados correctamente.',
        'Perl Version' => 'Versión de Perl',
        'Free Swap Space (%)' => 'Espacio de Intercambio Libre (%)',
        'No Swap Enabled.' => 'Espacio de Intercambio No Habilitado',
        'Used Swap Space (MB)' => 'Espacio de Intercambio Usado (MB)',
        'There should be more than 60% free swap space.' => 'Debe haber mas del 60% de espacio de intercambio libre.',
        'There should be no more than 200 MB swap space used.' => 'Debe haber no mas de 200 MB de espacio de intercambio usado.',
        'Config Settings' => 'Configuraciones del sistema',
        'Could not determine value.' => 'No se pudo determinar el valor.',
        'Database Records' => 'Registros de la Base de Datos',
        'Tickets' => 'Tickets',
        'Ticket History Entries' => 'Entradas Del Historial De Ticket',
        'Articles' => 'Artículos',
        'Attachments (DB, Without HTML)' => 'Adjuntos (BD, Sin HTML)',
        'Customers With At Least One Ticket' => 'Clientes Con Al Menos Un ticket',
        'Queues' => 'Colas',
        'Agents' => 'Agentes',
        'Roles' => 'Roles',
        'Groups' => 'Grupos',
        'Dynamic Fields' => 'Campos Dinámicos',
        'Dynamic Field Values' => 'Valores de Campos Dinámicos',
        'Invalid Dynamic Fields' => 'Campo Dinámico Invalido',
        'Invalid Dynamic Field Values' => 'Valor del Campo Dinámico Invalido',
        'GenericInterface Webservices' => 'Servicios Web de la Interfaz Genérica',
        'Processes' => 'Procesos',
        'Months Between First And Last Ticket' => 'Meses Entre el Primer y Último Ticket',
        'Tickets Per Month (avg)' => 'Tickets Al Mes (promedio)',
        'Default SOAP Username and Password' => 'Nombre de Usuario y Contraseña Por Defecto Para SOAP',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Riesgo de Seguridad: Esta usando la configuración por defecto para SOAP::User y SOAP::Password. Por favor cambiela.',
        'Default Admin Password' => 'Contraseña Por Defecto Para Admin',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Riesgo de seguridad: la cuenta del agente root@ ocalhost todavía tiene la contraseña predeterminada. Favor de cambiarlo o invalidar la cuenta.',
        'Error Log' => 'Registro de Errores',
        'There are error reports in your system log.' => 'Existen reportes de error en el registro del sistema.',
        'File System Writable' => 'Sistema de Archivos Grabable',
        'The file system on your OTRS partition is not writable.' => 'El sistema de archivos de la partición OTRS no es grabable.',
        'Domain Name' => 'Nombre de Dominio',
        'Your FQDN setting is invalid.' => 'El ajuste de su FQDN es invalida.',
        'Package installation status' => 'Estado de la instalación de paquetes',
        'Some packages are not correctly installed.' => 'Algunos paquetes no estan correctamente instalados.',
        'Package List' => 'Listado de paquetes',
        'SystemID' => 'ID del sistema',
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'El ajuste del ID del Sistema es invalida, debe contener solamente dígitos.',
        'OTRS Version' => 'Versión De OTRS',
        'Ticket Index Module' => 'Módulo De Índice de Tickets',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Usted tiene más de 60,000 tickets y debería usar el backend StaticDB. Ver el manual admin (Optimización del Rendimiento) para más información.',
        'Open Tickets' => 'Tickets Abiertos',
        'You should not have more than 8,000 open tickets in your system.' =>
            'No debe tener más de 8,000 tickets abiertos en su sistema.',
        'Ticket Search Index module' => 'Módulo de Busqueda por Índice de Ticket',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Usted tiene más de 50,000 artículos y debería usar el backend StaticDB. Ver el manual admin (Optimización del Rendimiento) para más información.',
        'Orphaned Records In ticket_lock_index Table' => 'Registros Huérfanos En La Tabla ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'La tabla ticket_lock_index contiene registros huerfanos. Por favor ejecute otrs/bin/otrs.CleanTicketIndex.pl para limpiar el índice StaticDB.',
        'Orphaned Records In ticket_index Table' => 'Registros Huerfanos en la Tabla ticket_index',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'La tabla ticket_index contiene registros huerfanos. Por favor ejecute otrs/bin/otrs.CleanTicketIndex.pl para limpiar el índice StaticDB.',
        'Environment Variables' => 'Variables de entorno',
        'Webserver Version' => 'Versión del Servidor Web',
        'Could not determine webserver version.' => 'No se pudo determinar la versión del servidor web.',
        'Loaded Apache Modules' => 'Módulos Apache Cargados',
        'MPM model' => 'modelo MPM',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS requiere apache para ejecutarse con el módulo \'prefork\' MPM.',
        'CGI Accelerator Usage' => 'Uso Del Acelerador de CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Usted debe usar FastCGI o mod_perl para aumentar el rendimiento.',
        'mod_deflate Usage' => 'Uso del mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Por favor instale mod_deflate para mejorar la velocidad del GUI',
        'mod_filter Usage' => 'Uso de mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Por favor, instale el módulo mod_filter si se utiliza el módulo mod_deflate.',
        'mod_headers Usage' => 'Uso del mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Por favor instale mod_headers para mejorar la velocidad del GUI',
        'Apache::Reload Usage' => 'Uso del Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload o Apache2::Reload debe ser usado como PerlModulo y PerlInitHandler para prevenir que el servidor web se reinicie cuando se instala o se actualiza un módulo.',
        'Apache::DBI Usage' => 'Uso del Apache::DBI',
        'Apache::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache::DBI debe ser usado para obtener una mejor performance con conexiones a la base de datos pre-establecidas.',
        'You should use PerlEx to increase your performance.' => 'Debe usar PerlEx para incrementar la performance.',

        # Template: AAATicket
        'Status View' => 'Vista de Estados',
        'Service View' => 'Vista de Servicios',
        'Bulk' => 'Bloque',
        'Lock' => 'Bloquear',
        'Unlock' => 'Desbloquear',
        'History' => 'Historial',
        'Zoom' => 'Ampliación',
        'Age' => 'Antigüedad',
        'Bounce' => 'Rebotar',
        'Forward' => 'Reenviar',
        'From' => 'De',
        'To' => 'Para',
        'Cc' => 'Copia',
        'Bcc' => 'Copia oculta',
        'Subject' => 'Asunto',
        'Move' => 'Mover',
        'Queue' => 'Cola',
        'Priority' => 'Prioridad',
        'Priorities' => 'Prioridades',
        'Priority Update' => 'Actualización de la prioridad',
        'Priority added!' => '¡Prioridad añadida!',
        'Priority updated!' => '¡Prioridad actualizada!',
        'Signature added!' => '¡Firma añadida!',
        'Signature updated!' => '¡Firma actualizada!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Acuerdo de Nivel de Servicio',
        'Service Level Agreements' => 'Acuerdos de Niveles de Servicios',
        'Service' => 'Servicio',
        'Services' => 'Servicios',
        'State' => 'Estado',
        'States' => 'Estados',
        'Status' => 'Estado',
        'Statuses' => 'Estados',
        'Ticket Type' => 'Tipo de Ticket',
        'Ticket Types' => 'Tipos de Tickets',
        'Compose' => 'Redactar',
        'Pending' => 'Pendiente',
        'Owner' => 'Propietario',
        'Owner Update' => 'Actualización del Propietario',
        'Responsible' => 'Responsable',
        'Responsible Update' => 'Actualización del responsable',
        'Sender' => 'Remitente',
        'Article' => 'Artículo',
        'Ticket' => 'Ticket',
        'Createtime' => 'Fecha de Creación',
        'plain' => 'plano',
        'Email' => 'Correo',
        'email' => 'correo',
        'Close' => 'Cerrar',
        'Action' => 'Acción',
        'Attachment' => 'Adjunto',
        'Attachments' => 'Adjuntos',
        'This message was written in a character set other than your own.' =>
            'Este mensaje fue escrito usando un juego de caracteres distinto al suyo',
        'If it is not displayed correctly,' => 'Si no se muestra correctamente,',
        'This is a' => 'Este es un',
        'to open it in a new window.' => 'para abrirlo en una nueva ventana.',
        'This is a HTML email. Click here to show it.' => 'Éste es un correo HTML. Pulse aquí para mostrarlo.',
        'Free Fields' => 'Campos libres',
        'Merge' => 'Fusionar',
        'merged' => 'fusionado',
        'closed successful' => 'cerrado con éxito',
        'closed unsuccessful' => 'cerrado sin éxito',
        'Locked Tickets Total' => 'Total de tickets bloqueados',
        'Locked Tickets Reminder Reached' => 'Alcanzado el recordatorio de tickets bloqueados',
        'Locked Tickets New' => 'Nuevos tickets bloqueados',
        'Responsible Tickets Total' => 'Total de Tickets del Responsable',
        'Responsible Tickets New' => 'Nuevo Ticket del Responsable',
        'Responsible Tickets Reminder Reached' => 'Recordatorio de Tickets del Responsable Alcanzado',
        'Watched Tickets Total' => 'Total de Tickets Vistas',
        'Watched Tickets New' => 'Nuevo Tickets Visto',
        'Watched Tickets Reminder Reached' => 'Recordatorio de Tickets Vistos Alcanzados',
        'All tickets' => 'Todos los tickets',
        'Available tickets' => 'Tickets disponibles',
        'Escalation' => 'Escalado',
        'last-search' => 'última-búsqueda',
        'QueueView' => 'Vista de Colas',
        'Ticket Escalation View' => 'Vista de Tickets Escalados',
        'Message from' => 'Mensaje de',
        'End message' => 'Fin del mensaje',
        'Forwarded message from' => 'Mensaje reenviado de',
        'End forwarded message' => 'Fin del mensaje reenviado',
        'Bounce Article to a different mail address' => 'Rebote Artículo a una dirección de correo diferente',
        'Reply to note' => 'Responder la nota',
        'new' => 'nuevo',
        'open' => 'abierto',
        'Open' => 'Abierto',
        'Open tickets' => 'Tickets Abiertos',
        'closed' => 'cerrado',
        'Closed' => 'Cerrado',
        'Closed tickets' => 'Tickets cerrados',
        'removed' => 'eliminado',
        'pending reminder' => 'pendiente de recordatorio',
        'pending auto' => 'pendiente automático',
        'pending auto close+' => 'pendiente de cierre automático+',
        'pending auto close-' => 'pendiente de cierre automático-',
        'email-external' => 'correo-externo',
        'email-internal' => 'correo-interno',
        'note-external' => 'nota-externa',
        'note-internal' => 'nota-interna',
        'note-report' => 'nota-informe',
        'phone' => 'teléfono',
        'sms' => 'sms',
        'webrequest' => 'solicitud vía web',
        'lock' => 'bloqueado',
        'unlock' => 'desbloqueado',
        'very low' => 'muy baja',
        'low' => 'baja',
        'normal' => 'normal',
        'high' => 'alta',
        'very high' => 'muy alta',
        '1 very low' => '1 muy baja',
        '2 low' => '2 baja',
        '3 normal' => '3 normal',
        '4 high' => '4 alta',
        '5 very high' => '5 muy alta',
        'auto follow up' => 'seguimiento automático',
        'auto reject' => 'rechazo automático',
        'auto remove' => 'eliminación automática',
        'auto reply' => 'respuesta automática',
        'auto reply/new ticket' => 'respuesta automática/nuevo ticket',
        'Create' => 'Crear',
        'Answer' => 'Responder',
        'Phone call' => 'Llamada telefónica',
        'Ticket "%s" created!' => '¡Ticket "%s" creado!',
        'Ticket Number' => 'Número de Ticket',
        'Ticket Object' => 'Ticket Objeto',
        'No such Ticket Number "%s"! Can\'t link it!' => '¡No existe el número de ticket "%s"! ¡No se puede enlazar a él!',
        'You don\'t have write access to this ticket.' => 'No tiene permisos de escritura sobre este ticket',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Disculpe, necesita ser el propietario del ticket para realizar esta acción.',
        'Please change the owner first.' => 'Por favor, cambie antes el propietario.',
        'Ticket selected.' => 'Ticket seleccionado',
        'Ticket is locked by another agent.' => 'El ticket está bloqueado por otro agente',
        'Ticket locked.' => 'Ticket bloqueado',
        'Don\'t show closed Tickets' => 'No mostrar los tickets cerrados',
        'Show closed Tickets' => 'Mostrar los tickets cerrados',
        'New Article' => 'Nuevo artículo',
        'Unread article(s) available' => 'Artículo(s) sin leer disponible(s)',
        'Remove from list of watched tickets' => 'Eliminar de la lista de tickets vistos',
        'Add to list of watched tickets' => 'Añadir a la lista de tickets vistos',
        'Email-Ticket' => 'Ticket por correo',
        'Create new Email Ticket' => 'Crea nuevo ticket por correo',
        'Phone-Ticket' => 'Ticket telefónico',
        'Search Tickets' => 'Buscar tickets',
        'Customer Realname' => 'Nombre Real del Cliente',
        'Customer History' => 'Historial del Cliente',
        'Edit Customer Users' => 'Editar Usuario Cliente',
        'Edit Customer' => 'Editar Cliente',
        'Bulk Action' => 'Acción en Bloque',
        'Bulk Actions on Tickets' => 'Acción en Bloque sobre tickets',
        'Send Email and create a new Ticket' => 'Enviar un correo y crear un nuevo ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Crea nuevo ticket por correo y enviar éste (saliente)',
        'Create new Phone Ticket (Inbound)' => 'Crea nuevo ticket telefónico (entrante)',
        'Address %s replaced with registered customer address.' => 'Dirección %s reemplaza con la del cliente registrado.',
        'Customer user automatically added in Cc.' => 'Usuario Cliente añadido automáticamente a Cc.',
        'Overview of all open Tickets' => 'Vista general de todos los Tickets abiertos',
        'Locked Tickets' => 'Tickets Bloqueados',
        'My Locked Tickets' => 'Mis Tickets Bloqueados',
        'My Watched Tickets' => 'Mis Tickets vistos',
        'My Responsible Tickets' => 'Tickets de mi Responsabilidad',
        'Watched Tickets' => 'Tickets Vistos',
        'Watched' => 'Vistos',
        'Watch' => 'Ver',
        'Unwatch' => 'No Vistos',
        'Lock it to work on it' => 'Bloquear para trabajar en él',
        'Unlock to give it back to the queue' => 'Desbloquear para devolverlo a la cola',
        'Show the ticket history' => 'Mostrar el historial del ticket',
        'Print this ticket' => 'Imprimir este ticket',
        'Print this article' => 'Imprimir este artículo',
        'Split' => 'Dividir',
        'Split this article' => 'Dividir este artículo',
        'Forward article via mail' => 'Reenviar el artículo por correo',
        'Change the ticket priority' => 'Cambiar la prioridad del ticket',
        'Change the ticket free fields!' => '¡Cambiar los campos libres del ticket!',
        'Link this ticket to other objects' => 'Enlazar este ticket a otros objetos',
        'Change the owner for this ticket' => 'Cambiar el propietario de este ticket',
        'Change the  customer for this ticket' => 'Cambiar el cliente de este ticket',
        'Add a note to this ticket' => 'Añadir una nota a este ticket',
        'Merge into a different ticket' => 'Fusionar con otro ticket',
        'Set this ticket to pending' => 'Poner este ticket en pendiente',
        'Close this ticket' => 'Cerrar este ticket',
        'Look into a ticket!' => '¡Revisar un ticket!',
        'Delete this ticket' => 'Borrar este ticket',
        'Mark as Spam!' => '¡Marcar como spam!',
        'My Queues' => 'Mis colas',
        'Shown Tickets' => 'Tickets mostrados',
        'Shown Columns' => 'Columnas mostradas',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Su correo con el número de ticket "<OTRS_TICKET>" se fusionó con "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: ¡Se ha excedido el tiempo para la primera respuesta (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: ¡El tiempo para primera respuesta expirará en %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: ¡Se ha excedido el tiempo para la actualización (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: ¡El tiempo para la actualización vencerá en %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: ¡Se ha sobrepasado el tiempo para solucionarlo (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: ¡El tiempo para solucionarlo vencerá en %s!',
        'There are more escalated tickets!' => '¡Hay más tickets escalados¡',
        'Plain Format' => 'Formato plano',
        'Reply All' => 'Responder a todos',
        'Direction' => 'Dirección',
        'Agent (All with write permissions)' => 'Agente (todos con permisos de escritura)',
        'Agent (Owner)' => 'Agente (propietario)',
        'Agent (Responsible)' => 'Agente (responsable)',
        'New ticket notification' => 'Notificación de nuevos tickets',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Notificarme si hay un nuevo ticket en "Mis colas".',
        'Send new ticket notifications' => 'Enviar notificaciones de nuevo ticket',
        'Ticket follow up notification' => 'Enviar notificaciones de seguimiento',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Enviarme una notificación si un cliente envía un seguimiento y soy el propietario del ticket o el ticket está desbloqueado y en una las colas a las que estoy suscrito.',
        'Send ticket follow up notifications' => 'Enviar notificaciones de seguimiento de tickets',
        'Ticket lock timeout notification' => 'Notificación de bloqueo de tickets por tiempo',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Notificarme si un ticket es desbloqueado por el sistema',
        'Send ticket lock timeout notifications' => 'Enviar notificaciones de bloqueo de ticket por tiempo excedido',
        'Ticket move notification' => 'Notificación de movimiento de ticket',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Notificarme si un ticket es colocado en una de "Mis colas".',
        'Send ticket move notifications' => 'Enviar notificaciones de movimiento de ticket',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'La selección de sus colas favoritas. También se le notifican estas colas por correo si se habilita.',
        'Custom Queue' => 'Cola personalizada',
        'QueueView refresh time' => 'Tiempo de actualización de la vista de colas',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Si se habilita, la Vista de colas se actualizará automáticamente tras el tiempo indicado.',
        'Refresh QueueView after' => 'Refrescar la Vista de colas tras',
        'Screen after new ticket' => 'Pantalla posterior a nuevo ticket',
        'Show this screen after I created a new ticket' => 'Mostrar esta pantalla después de crear un nuevo ticket',
        'Closed Tickets' => 'Tickets cerrados',
        'Show closed tickets.' => 'Mostrar los tickets cerrados',
        'Max. shown Tickets a page in QueueView.' => 'Cantidad máxima de tickets a mostrar en la Vista de colas',
        'Ticket Overview "Small" Limit' => 'Límite en la Vista general «pequeña» de tickets',
        'Ticket limit per page for Ticket Overview "Small"' => 'Límite de tickets por página en la Vista general de tickets «pequeña»',
        'Ticket Overview "Medium" Limit' => 'Límite en la Vista general «mediana» de tickets',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Límite de tickets por página en la Vista general de tickets «mediana»',
        'Ticket Overview "Preview" Limit' => 'Límite en la Vista general «previsualización» de tickets',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Límite de tickets por página en la Vista general de tickets «previsualización»',
        'Ticket watch notification' => 'Notificación de tickets vistos',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Enviarme las mismas notificaciones para mis tickets vistos que recibirán los propietarios del ticket',
        'Send ticket watch notifications' => 'Enviar notificaciones de tickets vistos',
        'Out Of Office Time' => 'Tiempo de ausencia de la oficina',
        'New Ticket' => 'Nuevo Ticket',
        'Create new Ticket' => 'Crear un nuevo Ticket',
        'Customer called' => 'Cliente llamado',
        'phone call' => 'llamada telefónica',
        'Phone Call Outbound' => 'Llamada Telefónica Saliente',
        'Phone Call Inbound' => 'Llamada Telefónica Entrante',
        'Reminder Reached' => 'Recordatorio Alcanzado',
        'Reminder Tickets' => 'Tickets Recordatorio',
        'Escalated Tickets' => 'Tickets Escalados',
        'New Tickets' => 'Nuevos Tickets',
        'Open Tickets / Need to be answered' => 'Tickets Abiertos / Que necesitan de una respuesta',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Todos los Tickets abiertos, ya se ha trabajado en estos tickets, pero necesitan una respuesta',
        'All new tickets, these tickets have not been worked on yet' => 'Todos los Tickets nuevos, todavía no se ha trabajado en estos tickets',
        'All escalated tickets' => 'Todos los Tickets escalados',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Todos los Tickets para los que se ha alcanzado su fecha de recordatorio',
        'Archived tickets' => 'Tickets archivados',
        'Unarchived tickets' => 'Tickets no archivados',
        'Ticket Information' => 'Información del ticket',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mié',
        'Thu' => 'Jue',
        'Fri' => 'Vie',
        'Sat' => 'Sáb',

        # Template: AdminACL
        'ACL Management' => 'Gestión de las ACL',
        'Filter for ACLs' => 'Filtro para las ACL',
        'Filter' => 'Filtro',
        'ACL Name' => 'Nombre de la ACL',
        'Actions' => 'Acciones',
        'Create New ACL' => 'Crear una nueva ACL',
        'Deploy ACLs' => 'Desplegar las ACL',
        'Export ACLs' => 'Exportar las ACL',
        'Configuration import' => 'Importar configuración',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Aquí puede cargar un archivo de configuración para importar ACLs a su sistema. El archivo debe estar en formato .yml tal y como lo exporta el módulo de edición de ACL.',
        'This field is required.' => 'Este campo es requerido.',
        'Overwrite existing ACLs?' => '¿Sobrescribir las ACL existentes?',
        'Upload ACL configuration' => 'Cargar configuración de ACL',
        'Import ACL configuration(s)' => 'Importar configuración de ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Para crear una nueva ACL puede importar ACLs que hayan sido exportadas en otro sistema, o bien crear una completamente nueva.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Los cambios a estas ACL sólo afectan al comportamiento del sistema, si despliega los datos de las ACL después. Al desplegar los datos de las ACL, los nuevos cambios realizados se escribirán en la configuración.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Por favor, observe: Esta tabla representa el order de ejecución de las ACL. Si necesita cambiar el orden en que se ejecutan las ACL, cambie los nombres de las ACL afectadas.',
        'ACL name' => 'Nombre de la ACL',
        'Validity' => 'Validez',
        'Copy' => 'Copiar',
        'No data found.' => 'No se encontró ningún dato.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Editar la ACL %s',
        'Go to overview' => 'Ir a la vista general',
        'Delete ACL' => 'Borrar la ACL',
        'Delete Invalid ACL' => 'Borrar ACL no válida',
        'Match settings' => 'Ajustes de la coincidencia',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Establecer los criterios de coincidencia para esta ACL. Use «Propiedades» para coincidir con la pantalla actual o «BasededatosPropiedades» para coincidir con los atributos del ticket actual que están en la base de datos.',
        'Change settings' => 'Cambiar los ajustes',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Establecer qué quiere cambiar si los criterios coinciden. Tenga en cuenta que «Posible» es una lista blanca, «PosibleNo» una lista negra.',
        'Check the official' => 'Compruebe la oficial',
        'documentation' => 'documentación',
        'Show or hide the content' => 'Mostrar u ocultar el contenido',
        'Edit ACL information' => 'Editar la información de la ACL',
        'Stop after match' => 'Parar al coincidir',
        'Edit ACL structure' => 'Editar la estructura de la ACL',
        'Save' => 'Guardar',
        'or' => 'o',
        'Save and finish' => 'Guardar y finalizar',
        'Do you really want to delete this ACL?' => '¿Realmente desea borrar esta ACL?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Este elemento todavía contiene subelementos. ¿Seguro que desea eliminar este elemento y sus subelementos?',
        'An item with this name is already present.' => 'Ya hay un elemento con este nombre.',
        'Add all' => 'Añadir todos',
        'There was an error reading the ACL data.' => 'Se produjo un error al leer los datos de la ACL.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Crear una nueva ACL enviando los datos del formulario. Tras crear la ACL, podrá añadir elementos de configuración en el modo de edición.',

        # Template: AdminAttachment
        'Attachment Management' => 'Gestión de adjuntos',
        'Add attachment' => 'Añadir anexo',
        'List' => 'Lista',
        'Download file' => 'Descargar el archivo',
        'Delete this attachment' => 'Borrar este adjunto',
        'Add Attachment' => 'Añadir un adjunto',
        'Edit Attachment' => 'Editar adjunto',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Gestión de respuestas automáticas',
        'Add auto response' => 'Añadir respuesta automática',
        'Add Auto Response' => 'Añadir respuesta automática',
        'Edit Auto Response' => 'Editar respuesta automática',
        'Response' => 'Respuesta',
        'Auto response from' => 'Respuesta automática de',
        'Reference' => 'Referencia',
        'You can use the following tags' => 'Puede usar las siguientes etiquetas',
        'To get the first 20 character of the subject.' => 'Para obtener los primeros 20 caracteres del asunto.',
        'To get the first 5 lines of the email.' => 'Para obtener las primeras 5 líneas del correo.',
        'To get the realname of the sender (if given).' => 'Para obtener el nombre real del remitente (si existe)',
        'To get the article attribute' => 'Para obtener el atributo del artículo',
        ' e. g.' => 'v. g.',
        'Options of the current customer user data' => 'Opciones de los datos del ciente usuario actual',
        'Ticket owner options' => 'Opciones del propietario del ticket',
        'Ticket responsible options' => 'Opciones del responsable del ticket',
        'Options of the current user who requested this action' => 'Opciones del usuario actual que solicitó esta acción',
        'Options of the ticket data' => 'Opciones de los datos del ticket',
        'Options of ticket dynamic fields internal key values' => 'Opciones de los valores de las claves internas de los campos dinámicos de los tickets',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opciones de los valores mostrados de los campos dinámicos de los tickets, útil para los campos desplegables y de selección múltiple',
        'Config options' => 'Opciones de configuración',
        'Example response' => 'Ejemplo de respuesta',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestión de clientes',
        'Wildcards like \'*\' are allowed.' => 'Se permiten caracteres comodín como \'*\'.',
        'Add customer' => 'Añadir un cliente',
        'Select' => 'Seleccionar',
        'Please enter a search term to look for customers.' => 'Introduzca un término de búsqueda para buscar clientes.',
        'Add Customer' => 'Añadir un cliente',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gestión de Usuarios Cliente',
        'Back to search results' => 'Volver a los resultados de la búsqueda',
        'Add customer user' => 'Añadir un usuario cliente',
        'Hint' => 'Consejo',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Los usuarios cliente necesitan tener un historial de cliente e iniciar sesión por medio del panel de cliente.',
        'Last Login' => 'Última sesión',
        'Login as' => 'Conectarse como',
        'Switch to customer' => 'Cambiar a cliente',
        'Add Customer User' => 'Añadir Usuario Cliente',
        'Edit Customer User' => 'Editar Usuario Cliente',
        'This field is required and needs to be a valid email address.' =>
            'Este campo es necesario y tiene que ser una dirección de correo electrónico válida.',
        'This email address is not allowed due to the system configuration.' =>
            'No se permite esta dirección de correo debido a la configuración del sistema.',
        'This email address failed MX check.' => 'Esta dirección de correo no superó la verificación MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema con el DNS. Por favor, verifique su configuración y el registro de errores.',
        'The syntax of this email address is incorrect.' => 'La sintaxis de esta dirección de correo es incorrecta',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gestionar las relaciones Cliente-Grupo',
        'Notice' => 'Nota',
        'This feature is disabled!' => '¡Esta característica está inhabilitada!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utilice esta característica sólo si desea definir permisos de grupo para los clientes.',
        'Enable it here!' => '¡Habilítelo aquí!',
        'Edit Customer Default Groups' => 'Editar los Grupos Predeterminados de los Clientes',
        'These groups are automatically assigned to all customers.' => 'Estos grupos se asignan automáticamente a todos los clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Puede gestionar estos grupos mediante el ajuste de configuración «CustomerGroupAlwaysGroups».',
        'Filter for Groups' => 'Filtrar por grupos',
        'Just start typing to filter...' => 'Empiece a escribir para filtrar...',
        'Select the customer:group permissions.' => 'Seleccionar los permisos cliente:grupo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Si no se selecciona nada, este grupo no tendrá permisos (los tickets no estarán disponibles para el cliente).',
        'Search Results' => 'Resultado de la búsqueda',
        'Customers' => 'Clientes',
        'No matches found.' => 'No se encontraron coincidencias.',
        'Change Group Relations for Customer' => 'Cambiar las Relaciones de Grupo del Cliente',
        'Change Customer Relations for Group' => 'Cambiar las Relaciones de Cliente del Grupo',
        'Toggle %s Permission for all' => 'Conmutar el permiso %s para todos',
        'Toggle %s permission for %s' => 'Conmutar el permiso %s para %s',
        'Customer Default Groups:' => 'Grupos Predeterminados del Cliente:',
        'No changes can be made to these groups.' => 'No se pueden hacer cambios a estos grupos.',
        'ro' => 'sólo lectura',
        'Read only access to the ticket in this group/queue.' => 'Acceso de sólo lectura a los tickets de este grupo/cola.',
        'rw' => 'lectura escritura',
        'Full read and write access to the tickets in this group/queue.' =>
            'Acceso completo de lectura y escritura a los tickets de este grupo/cola.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Gestionar las Relaciones Cliente-Servicios',
        'Edit default services' => 'Editar los servicios predeterminados',
        'Filter for Services' => 'Filtro para los servicios',
        'Allocate Services to Customer' => 'Asignar Servicios al Cliente',
        'Allocate Customers to Service' => 'Asignar Clientes al Servicio',
        'Toggle active state for all' => 'Conmutar el estado activo a todos',
        'Active' => 'Activo',
        'Toggle active state for %s' => 'Conmutar el estado activo a %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestión de Campos Dinámicos',
        'Add new field for object' => 'Añadir un nuevo campo al objeto',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Para añadir un nuevo campo, seleccione el tipo de campo de la lista de objetos, el objeto define los limites del campo y no puede ser cambiado despues de la creación del campo.',
        'Dynamic Fields List' => 'Lista de Campos Dinámicos',
        'Dynamic fields per page' => 'Campos dinámicos por página',
        'Label' => 'Etiqueta',
        'Order' => 'Orden',
        'Object' => 'Objeto',
        'Delete this field' => 'Borrar este campo',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '¿Seguro que desea borrar este campo dinámico? ¡Se PERDERÁN TODOS los datos asociados!',
        'Delete field' => 'Borrar el campo',

        # Template: AdminDynamicFieldCheckbox
        'Field' => 'Campo',
        'Go back to overview' => 'Volver a la vista general',
        'General' => 'General',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Este campo es necesario, y el valor debería contener sólo caracteres alfabéticos y numéricos.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Debe ser único y sólo aceptar caracteres alfabéticos y numéricos.',
        'Changing this value will require manual changes in the system.' =>
            'Cambiar este valor requerirá cambios manuales en el sistema.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Éste es el nombre a mostrar en las pantallas en las que el campo esté activo.',
        'Field order' => 'Orden de campo',
        'This field is required and must be numeric.' => 'Este campo es necesario y debe ser numérico.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Éste es el orden en que se mostrará este campo en las pantallas en las que esté activo.',
        'Field type' => 'Tipo de campo',
        'Object type' => 'Tipo de objeto',
        'Internal field' => 'Campo interno',
        'This field is protected and can\'t be deleted.' => 'Este campo está protegido y no se puede borrar.',
        'Field Settings' => 'Ajustes del campo',
        'Default value' => 'Valor predeterminado',
        'This is the default value for this field.' => 'Éste es valor predeterminado para este campo.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Diferencia de fechas predeterminada',
        'This field must be numeric.' => 'Este campo debe ser numérico.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'La diferencia de AHORA (en segundos) para calcular el valor predeterminado del campo (vg 3600 o -60).',
        'Define years period' => 'Definir el periodo en años',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Active esta característica para definir un intervalo fijo de años (en el futuro y en el pasado) a mostrar en la parte año de este campo.',
        'Years in the past' => 'Años en el pasado',
        'Years in the past to display (default: 5 years).' => 'Años en el pasado a mostrar (por defecto: 5 años).',
        'Years in the future' => 'Años en el futuro',
        'Years in the future to display (default: 5 years).' => 'Años en el futuro a mostrar (por defecto: 5 años).',
        'Show link' => 'Mostrar el enlace',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Aquí puede indicar un enlace HTTP opcional para el valor del campo en las pantallas de Vista general y Ampliación',
        'Restrict entering of dates' => 'Restringir entrada de fechas',
        'Here you can restrict the entering of dates of tickets.' => 'Aquí puede restringir la entrada de fechas para los tickets.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Posibles valores',
        'Key' => 'Clave',
        'Value' => 'Valor',
        'Remove value' => 'Eliminar el valor',
        'Add value' => 'Añadir un valor',
        'Add Value' => 'Añadir un valor',
        'Add empty value' => 'Añadir un valor vacío',
        'Activate this option to create an empty selectable value.' => 'Active esta opción para crear un valor seleccionable vacío.',
        'Tree View' => 'Vista en árbol',
        'Activate this option to display values as a tree.' => 'Active esta opción para mostrar los valores como un árbol.',
        'Translatable values' => 'Valores traducibles',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Si activa esta opción los valores se traducirán al idioma definido por el usuario.',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'Necesita añadir las traducciones manualmente en los ficheros de traducción al idioma.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Número de filas',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Indica la altura (en líneas) de este campo en el modo de edición.',
        'Number of cols' => 'Número de columnas',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Indica la anchura (en caracteres) de este campo en el modo de edición.',
        'Check RegEx' => 'Comprobar RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Aquí puede especificar una expresión regular para comprobar el valor. El regex se ejecutara con los modificadores xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Inválido RegEx',
        'Error Message' => 'Mensaje de error',
        'Add RegEx' => 'Añadir RegEx',

        # Template: AdminEmail
        'Admin Notification' => 'Notificación del administrador',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Con este módulo, los administradores pueden enviar mensajes a los agentes y miembros de grupos o roles.',
        'Create Administrative Message' => 'Crear mensaje administrativo',
        'Your message was sent to' => 'Se ha enviado su mensaje a',
        'Send message to users' => 'Enviar mensaje a los usuarios',
        'Send message to group members' => 'Enviar mensaje a los miembros del grupo',
        'Group members need to have permission' => 'Los miembros del grupo tienen que tener permiso',
        'Send message to role members' => 'Enviar mensajes a los miembros del rol',
        'Also send to customers in groups' => 'Enviar también a los clientes de los grupos',
        'Body' => 'Cuerpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agente genérico',
        'Add job' => 'Añadir trabajo',
        'Last run' => 'Última ejecución',
        'Run Now!' => '¡Ejecutar ahora!',
        'Delete this task' => 'Borrar esta tarea',
        'Run this task' => 'Ejecutar esta tarea',
        'Job Settings' => 'Ajustes del trabajo',
        'Job name' => 'Nombre del trabajo',
        'The name you entered already exists.' => 'El nombre introducido ya existe.',
        'Toggle this widget' => 'Conmutar este widget',
        'Automatic execution (multiple tickets)' => 'Ejecución automática (múltiples tickets)',
        'Execution Schedule' => 'Planificación de la ejecución',
        'Schedule minutes' => 'Minutos para la planificación',
        'Schedule hours' => 'Horas para planificación',
        'Schedule days' => 'Días para la planificación',
        'Currently this generic agent job will not run automatically.' =>
            'Actualmente este trabajo de agente genérico no se ejecutará automáticamente.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '¡Para habilitar la ejecución automática, seleccione al menos un valor de minutos, horas y días!',
        'Event based execution (single ticket)' => 'Ejecución basada en eventos (un único ticket)',
        'Event Triggers' => 'Disparadores del evento',
        'List of all configured events' => 'Lista de todos los eventos configurados',
        'Delete this event' => 'Borrar este evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Además o en lugar de una ejecución periódica, puede definir eventos de ticket que disparen este trabajo.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Si se dispara un evento de ticket, se aplicará el filtro de tickets para combrobar si el ticket coincide. Sólo entonces se ejecuta el trabajo sobre ese ticket.',
        'Do you really want to delete this event trigger?' => '¿Realmente desea borrar este disparador de evento?',
        'Add Event Trigger' => 'Añadir disparador de evento',
        'Add Event' => 'Añadir Evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Para añadir un nuevo evento seleccione el objeto evento y el nombre del evento y pulse el botón "+"',
        'Duplicate event.' => 'Duplicar el evento',
        'This event is already attached to the job, Please use a different one.' =>
            'Este evento ya está ligado al trabajo, seleccione uno diferente.',
        'Delete this Event Trigger' => 'Borrar este disparador de eventos',
        'Remove selection' => 'Remover selección',
        'Select Tickets' => 'Seleccionar Ticket',
        '(e. g. 10*5155 or 105658*)' => '(ej: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(ej: 234321)',
        'Customer login' => 'Usuario del cliente',
        '(e. g. U5150)' => '(ej: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Búsqueda de texto completo en un artículo (ej. «Mar*in» o «Baue*»).',
        'Agent' => 'Agente',
        'Ticket lock' => 'Bloqueo de tickets',
        'Create times' => 'Fechas de creación',
        'No create time settings.' => 'No hay fecha de creación',
        'Ticket created' => 'Ticket creado',
        'Ticket created between' => 'Ticket creado entre',
        'Last changed times' => 'Últimas fechas modificadas',
        'No last changed time settings.' => 'No hay últimas ajustes de fechas modificadas.',
        'Ticket last changed' => 'Último Ticket modificado',
        'Ticket last changed between' => 'Último Ticket modificado entre',
        'Change times' => 'Fecha de modificación',
        'No change time settings.' => 'No hay fecha de modificación',
        'Ticket changed' => 'Ticket modificado',
        'Ticket changed between' => 'Ticket modificado entre',
        'Close times' => 'Fechas de cierre',
        'No close time settings.' => 'No hay fechas de cierre',
        'Ticket closed' => 'Ticket cerrado',
        'Ticket closed between' => 'Ticket cerrado entre',
        'Pending times' => 'Fechas de recordatorio',
        'No pending time settings.' => 'No hay fechas de recordatorio',
        'Ticket pending time reached' => 'Alcanzado el tiempo de espera del ticket',
        'Ticket pending time reached between' => 'Alcanzado el tiempo de espera del ticket entre',
        'Escalation times' => 'Fechas de escalada',
        'No escalation time settings.' => 'No hay ajustes para las fechas de escalada',
        'Ticket escalation time reached' => 'Alcanzada la fecha de escalada del ticket',
        'Ticket escalation time reached between' => 'Alcanzada la fecha de escalada del ticket entre',
        'Escalation - first response time' => 'Escalada - fecha de la primera respuesta',
        'Ticket first response time reached' => 'Alcanzada la fecha de primera respuesta al ticket',
        'Ticket first response time reached between' => 'Alcanzada la fecha de primera respuesta entre',
        'Escalation - update time' => 'Escalada - fecha de actualización',
        'Ticket update time reached' => 'Alcanzada la fecha de actualización del ticket',
        'Ticket update time reached between' => 'Alcanzada la fecha de actualización del ticket entre',
        'Escalation - solution time' => 'Escalada - fecha de solución',
        'Ticket solution time reached' => 'Alcanzada la fecha de solución del ticket',
        'Ticket solution time reached between' => 'Alcanzada la fecha de solución del ticket entre',
        'Archive search option' => 'Buscar en el archivo',
        'Update/Add Ticket Attributes' => 'Actualizar/Añadir Atributos de Ticket',
        'Set new service' => 'Establecer nuevo servicio',
        'Set new Service Level Agreement' => 'Establecer nuevo Acuerdo de Nivel de Servicio',
        'Set new priority' => 'Establecer nueva prioridad',
        'Set new queue' => 'Establecer nueva cola',
        'Set new state' => 'Establecer nuevo estado',
        'Pending date' => 'Fecha pendiente',
        'Set new agent' => 'Establecer nuevo agente',
        'new owner' => 'nuevo propietario',
        'new responsible' => 'nuevo responsable',
        'Set new ticket lock' => 'Establecer nuevo bloqueo de ticket',
        'New customer' => 'Nuevo cliente',
        'New customer ID' => 'Nuevo ID de cliente',
        'New title' => 'Nuevo título',
        'New type' => 'Nuevo tipo',
        'New Dynamic Field Values' => 'Nuevos valores de campo dinámico',
        'Archive selected tickets' => 'Archivar los tickets seleccionados',
        'Add Note' => 'Añadir una nota',
        'Time units' => 'Unidades de tiempo',
        'Execute Ticket Commands' => 'Ejecutar Comandos del Ticket',
        'Send agent/customer notifications on changes' => 'Enviar notificaciones al agente/cliente cuando haya cambios',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Se ejecutará esta orden. ARG[0] será el número del ticket, ARG[1] el id del ticket.',
        'Delete tickets' => 'Borrar los tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Advertencia: ¡Se eliminarán de la base de datos todos los tickets afectados, y no podrán restaurarse!',
        'Execute Custom Module' => 'Ejecutar módulo personalizado',
        'Param %s key' => 'Clave del parámetro %s',
        'Param %s value' => 'Valor del parámetro %s',
        'Save Changes' => 'Guardar los cambios',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '¡%s tickets afectados! ¿Qué desea hacer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Advertencia: Ha usado la opción BORRAR. ¡Se perderán todos los tickets borrados!',
        'Edit job' => 'Editar el trabajo',
        'Run job' => 'Ejecutar el trabajo',
        'Affected Tickets' => 'Tickets afectados',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Depurador de la interfaz genérica para el servicio web %s',
        'Web Services' => 'Servicios web',
        'Debugger' => 'Depurador',
        'Go back to web service' => 'Volver al servicio web',
        'Clear' => 'Limpiar',
        'Do you really want to clear the debug log of this web service?' =>
            '¿Seguro que desea limpiar el registro de depuración de este servicio web?',
        'Request List' => 'Lista de solicitudes',
        'Time' => 'Fecha y hora',
        'Remote IP' => 'IP remota',
        'Loading' => 'Cargando',
        'Select a single request to see its details.' => 'Seleccione una única solicitud para ver sus detalles.',
        'Filter by type' => 'Filtrar por tipo',
        'Filter from' => 'Filtrar desde',
        'Filter to' => 'Filtrar hasta',
        'Filter by remote IP' => 'Filtrar por IP remota',
        'Refresh' => 'Actualizar',
        'Request Details' => 'Detalles de la solicitud',
        'An error occurred during communication.' => 'Se produjo un error durante la comunicación.',
        'Show or hide the content.' => 'Mostrar u ocultar el contenido.',
        'Clear debug log' => 'Limpiar el registro de depuración',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Añadir un nuevo invocador al servicio web %s',
        'Change Invoker %s of Web Service %s' => 'Cambiar el invocador %s del servicio web %s',
        'Add new invoker' => 'Añadir nuevo invocador',
        'Change invoker %s' => 'Cambiar el invocador %s',
        'Do you really want to delete this invoker?' => '¿Realmente desea borrar este invocador?',
        'All configuration data will be lost.' => 'Se perderán todos los datos de configuración.',
        'Invoker Details' => 'Detalles del invocador',
        'The name is typically used to call up an operation of a remote web service.' =>
            'El nombre se usa normalmente para llamar una operación de un servicio web remoto.',
        'Please provide a unique name for this web service invoker.' => 'Proporcione un nombre único para este invocador de servicio web.',
        'Invoker backend' => 'Backend del invocador',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Se llamará a este módulo del backend del invocador OTRS para preparar los datos a enviar al sistema remoto, y para procesar los datos de la respuesta.',
        'Mapping for outgoing request data' => 'Mapeo para los datos de la solicitud saliente',
        'Configure' => 'Configurar',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Los datos del invocador de OTRS serán procesador por este mapeo, para transformarlos al tipo de datos que el sistema remoto espera.',
        'Mapping for incoming response data' => 'Mapeo para los datos de la respuesta entrante',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Los datos de la respuesta serán procesados por este mapeo, para transformarlos al tipo de datos que el invocador de OTRS espera.',
        'Asynchronous' => 'Asíncrono',
        'This invoker will be triggered by the configured events.' => 'Este invocador será disparado por los eventos configurados.',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Los disparadores de eventos asíncronos son gestionados por el planificador de OTRS en segundo plano (recomendado)',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Los disparadores de eventos asíncronos serían procesados directamente durante la solicitud web.',
        'Save and continue' => 'Guardar y continuar',
        'Delete this Invoker' => 'Borrar este invocador',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Simple Mapeo de la Interface Genérica para Servicio Web %s',
        'Go back to' => 'Volver a',
        'Mapping Simple' => 'Simple Mapeo',
        'Default rule for unmapped keys' => 'Regla por defecto para llaves sin asignar',
        'This rule will apply for all keys with no mapping rule.' => 'Esta regla aplica para todas las claves sin regla asignada.',
        'Default rule for unmapped values' => 'Regla por defecto para valores sin asignar',
        'This rule will apply for all values with no mapping rule.' => 'Esta regla aplica para todos los valores sin regla asignada.',
        'New key map' => 'Nueva asignación de clave',
        'Add key mapping' => 'Añadir asignación de clave',
        'Mapping for Key ' => 'Asignación para clave',
        'Remove key mapping' => 'Remover asignación de clave',
        'Key mapping' => 'Asignación de clave',
        'Map key' => 'Clave Asignada',
        'matching the' => 'coincida con el',
        'to new key' => 'a nueva clave',
        'Value mapping' => 'Asignacion de Valores',
        'Map value' => 'Valor Asignado',
        'to new value' => 'a nuevo valor',
        'Remove value mapping' => 'Remover asignación de valor',
        'New value map' => 'Nuevo asignación de valor',
        'Add value mapping' => 'Añadir asignación de valor',
        'Do you really want to delete this key mapping?' => '¿De verdad quiere eliminar esta asignación de clave?',
        'Delete this Key Mapping' => 'Borrar esta Asignación de Clave',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Añadir nueva operación al Servicio Web %s',
        'Change Operation %s of Web Service %s' => 'Cambiar Operación %s del Servicio Web %s',
        'Add new operation' => 'Añadir nueva operación',
        'Change operation %s' => 'Cambiar operación %s',
        'Do you really want to delete this operation?' => '¿De verdad quiere eliminar esta operación?',
        'Operation Details' => 'Detalles de la Operación',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'El nombre se utiliza normalmente para acceder a esta operación de servicio web desde un sistema remoto.',
        'Please provide a unique name for this web service.' => 'Por favor, proporcione un nombre único para este servicio web.',
        'Mapping for incoming request data' => 'Asignación para la solicitud de datos entrantes',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'La solicitud de datos serán procesados por esta asignación, para transformar a la clase de datos que OTRS espera.',
        'Operation backend' => 'Backend Operación',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Este módulo OTRS backend operación será llamado internamente para procesar la solicitud, la generación de datos para la respuesta.',
        'Mapping for outgoing response data' => 'Asignación de datos de respuesta de salida',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Los datos de respuesta serán procesados por esta asignación, para transformar a la clase de datos que el sistema remoto espera.',
        'Delete this Operation' => 'Borrar esta Operación',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'Transporte HTTP::REST de la Interface Genérica para Servicio Web %s',
        'Network transport' => 'Transporte de Red',
        'Properties' => 'Propiedades',
        'Route mapping for Operation' => 'Asignación de rutas para la Operación',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Definir la ruta que debe ser asignada a esta operación. Variables marcadas por una \':\' serán asignadas al nombre ingresado y pasadas por otras asignaciones. (ej. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Métodos solicitud válida para la Operación',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limitar esta operación a los métodos de petición específicos. Si no se selecciona ningún método se aceptarán todas las solicitudes.',
        'Maximum message length' => 'Longitud máxima del mensaje',
        'This field should be an integer number.' => 'Este campo debe ser un número entero.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Aquí puede especificar el tamaño máximo (en bytes) de mensajes REST que procesará OTRS.',
        'Send Keep-Alive' => 'Enviar Mantener-Activo',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Esta configuración define si las conexiones entrantes deben quedar cerrados o mantenerse activas.',
        'Host' => 'Host',
        'Remote host URL for the REST requests.' => 'URL del host remoto para las solicitudes REST.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'ej. https://www.otrs.com:10745/api/v1.0 (sin la barra invertida)',
        'Controller mapping for Invoker' => 'Asignación del Controlador para el Invocador',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'El controlador al que el invocador debe enviar peticiones a. Variables marcadas por un \'.\' quedarán reemplazadas por los valores de los datos y pasados con la petición (e.j. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Comando petición válido para Invocador',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Comando HTTP específico para usar por peticiones con este invocador (opcional).',
        'Default command' => 'Comando por defecto',
        'The default HTTP command to use for the requests.' => 'El comando HTTP por defecto para usar con las peticiones.',
        'Authentication' => 'Autenticación',
        'The authentication mechanism to access the remote system.' => 'Mecanismo de autenticación para acceder al sistema remoto.',
        'A "-" value means no authentication.' => 'Un valor "-" significa que no estás autenticado.',
        'The user name to be used to access the remote system.' => 'Nombre de usuario a ser usado para acceder al sistema remoto.',
        'The password for the privileged user.' => 'La contraseña para el usuario con permisos especiales.',
        'Use SSL Options' => 'Usar opciones SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Muestra u oculta las opciones SSL para conectar al sistema remoto.',
        'Certificate File' => 'Archivo de Cetificado',
        'The full path and name of the SSL certificate file.' => 'La ruta completa y nombre del archivo de certificado SSL',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'ej. /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'Archivo de Contraseña del Certificado',
        'The full path and name of the SSL key file.' => 'Ruta completa y nombre del archivo llave SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'ej.  /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Archivo de Autoridad de Certificacion (CA)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'Ruta completa y nombre del archivo del certificado de autoridad de certificación que valida el certificado SSL.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'ej.  /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'InterfazGenerica Transporta HTTP::SOAP para Servicio Web %s',
        'Endpoint' => 'Puntofinal',
        'URI to indicate a specific location for accessing a service.' =>
            'URI para indicar una localización específica para acceder al servicio.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'ej. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Espacio de nombre',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI para dar un contexto a métodos SOAP, reduciendo ambiguedades.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'ej. urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Aquí puede especificar el tamaño máximo (en bytes) de mensajes SOAP que procesará OTRS.',
        'Encoding' => 'Codificación',
        'The character encoding for the SOAP message contents.' => 'El caracter codificación para contenidos de mensaje SOAP. ',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'ej. utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'SOAPAction' => 'SOAPAcción',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Establece a "Si" para enviar una cabecera SOAPAccion cubierta.',
        'Set to "No" to send an empty SOAPAction header.' => 'Establece a "No" para enviar una cabecera SOAPAcción vacía.',
        'SOAPAction separator' => 'Separador SOAPAcción',
        'Character to use as separator between name space and SOAP method.' =>
            'Caracter para usar como separador entre el espacio del nombre y el método SOAP.',
        'Usually .Net web services uses a "/" as separator.' => 'Usualmente servicios web de .Net usan "/" como separador.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'La ruta completa y nombre del archivo de certificado SSL (debe estar en formato .p12).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'ej. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'La clave para abrir el certificado SSL',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'La ruta completa y el nombre de la autoridad de certificación del archivo del certificado que valida el certificado SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'ej.  /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Directorio Autoridad Certificación (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'La ruta completa del directorio de la autoridad de certificación donde los certificados de CA se almacenan en el sistema de archivos .',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'ej. /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Servidor Proxy',
        'URI of a proxy server to be used (if needed).' => 'URI del servidor proxy a usar (si se requiere).',
        'e.g. http://proxy_hostname:8080' => 'ej. http://proxy_hostname:8080',
        'Proxy User' => 'Usuario de Proxy',
        'The user name to be used to access the proxy server.' => 'El nombre de usuario a ser usado para acceder al servidor proxy.',
        'Proxy Password' => 'Contraseña de Proxy',
        'The password for the proxy user.' => 'El password para el usuario de proxy.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Gestión Servicio Web InterfazGenerica',
        'Add web service' => 'Agregar servicio web',
        'Clone web service' => 'Clonar servicio web.',
        'The name must be unique.' => 'El nombre debe ser unico.',
        'Clone' => 'Clonar',
        'Export web service' => 'Exportar servicio web',
        'Import web service' => 'Importar servicio web',
        'Configuration File' => 'Archivo de Configuración',
        'The file must be a valid web service configuration YAML file.' =>
            'El archivo debe ser un archivo válido YAML de configuración de servicio web.',
        'Import' => 'Importar',
        'Configuration history' => 'Historial de Configuración',
        'Delete web service' => 'Eliminar servicio web',
        'Do you really want to delete this web service?' => '¿Realmente desea eliminar este servicio web?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Después de salvar su configuración ud. será redireccionado de nuevo a la pantalla de edición',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Si desea volver al resumen por favor presione el botón "Volver a resumen"',
        'Web Service List' => 'Lista de Servicios Web',
        'Remote system' => 'Sistema remoto',
        'Provider transport' => 'Proveedor transporte',
        'Requester transport' => 'Solicitante transporte',
        'Debug threshold' => 'Umbral de depuración',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'En modo proveedor, OTRS ofrece servicios web los cuales son usados por sistemas remotos.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'En modo solicitante, OTRS usa servicios web de sistemas remotos.',
        'Operations are individual system functions which remote systems can request.' =>
            'Operaciones son funciones de sistema individuales las cuales los sistemas remotos pueden solicitar.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Los invocadores preparan datos para una petición a un servicio web remoto, y procesa los datos de respuesta.',
        'Controller' => 'Controlador',
        'Inbound mapping' => 'Mapeo de entrada',
        'Outbound mapping' => 'Mapeo de salida',
        'Delete this action' => 'Borrar esta acción',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Al menos un %s tiene un controlador que o bien no está activo o no está presente , compruebe el registro de controladores o elimine el % s',
        'Delete webservice' => 'Borrar servicio web',
        'Delete operation' => 'Eliminar operación',
        'Delete invoker' => 'Borrar Invocador',
        'Clone webservice' => 'Clonar servicio web',
        'Import webservice' => 'Importar servicio web',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Historico Configuración InterfazGenerica para Servicio Web %s',
        'Go back to Web Service' => 'Volver al Servicio Web',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Aquí puedes ver versiones anteriores de la configuración del servicio web actual, exportarlo o incluso restaurarlos.',
        'Configuration History List' => 'Lista Histórico Configuración',
        'Version' => 'Versión',
        'Create time' => 'Crear tiempo',
        'Select a single configuration version to see its details.' => 'Seleccione una única versión de configuración para ver sus detalles.',
        'Export web service configuration' => 'Exportar configuración de servicio web',
        'Restore web service configuration' => 'Restaurar configuración de servicio web',
        'Do you really want to restore this version of the web service configuration?' =>
            'Quieres realmente restablecer esta versión de la configuración del servicio web?',
        'Your current web service configuration will be overwritten.' => 'Tu configuración del servicio web va a ser sobreescrito.',
        'Restore' => 'Restaurar',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ATENCIÓN: Cuando cambia el nombre del grupo \'admin\', antes de realizar los cambios apropiados en SysConfig, ¡bloqueará el panel de administración! Si esto sucediera, por favor vuelva a renombrar el grupo para administrar por declaración SQL.',
        'Group Management' => 'Administración de grupos',
        'Add group' => 'Agregar grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'El grupo admin es para usar el área de administración y el grupo stats para usar el área estadisticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crear nuevos grupos para manejar permisos de acceso para diferentes grupos de agente (ej. departamento compras, departamento soporte, departamento ventas, ...).',
        'It\'s useful for ASP solutions. ' => 'Es útil para soluciones ASP.',
        'Add Group' => 'Añadir Grupo',
        'Edit Group' => 'Editar grupo',

        # Template: AdminLog
        'System Log' => 'Registro del sistema',
        'Here you will find log information about your system.' => 'Aquí encontrará información de registro sobre su sistema.',
        'Hide this message' => 'Ocultar este mensaje',
        'Recent Log Entries' => 'Entradas recientes del registro',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestión de Cuentas de Correo',
        'Add mail account' => 'Agregar cuenta de correo',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            '¡Todos los correos entrantes con una cuenta serán enviados a la cola seleccionada!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Si su cuenta está validada, ¡las cabeceras X-OTRS ya existentes en la llegada se utilizarán para la prioridad! El filtro Postmaster se usa de todas formas.',
        'Delete account' => 'Eliminar cuenta',
        'Fetch mail' => 'Traer correos',
        'Add Mail Account' => 'Agregar Cuenta de Correo',
        'Example: mail.example.com' => 'Ejemplo: mail.ejemplo.com',
        'IMAP Folder' => 'Carpeta IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifique esto solo si necesita obtener correos de un directorio distinto a INBOX',
        'Trusted' => 'Validado',
        'Dispatching' => 'Remitiendo',
        'Edit Mail Account' => 'Editar Cuenta de Correo',

        # Template: AdminNavigationBar
        'Admin' => 'Administrar',
        'Agent Management' => 'Gestión de agentes',
        'Queue Settings' => 'Ajustes de las colas',
        'Ticket Settings' => 'Ajustes de los tickets',
        'System Administration' => 'Administración del sistema',
        'Online Admin Manual' => 'Manual de Administración Online',

        # Template: AdminNotification
        'Notification Management' => 'Gestión de Notificaciones',
        'Select a different language' => 'Seleccione un lenguaje diferente',
        'Filter for Notification' => 'Filtro para Notificaciones',
        'Notifications are sent to an agent or a customer.' => 'Las notificaciones se envían a un agente o cliente',
        'Notification' => 'Notificaciones',
        'Edit Notification' => 'Editar Notificación',
        'e. g.' => 'ej.',
        'Options of the current customer data' => 'Opciones de los datos actuales del cliente',

        # Template: AdminNotificationEvent
        'Add notification' => 'Agregar notificación',
        'Delete this notification' => 'Eliminar esta notificación',
        'Add Notification' => 'Agregar Notificación',
        'Ticket Filter' => 'Filtro de tickets',
        'Article Filter' => 'Filtro de artículos',
        'Only for ArticleCreate and ArticleSend event' => 'Solo para eventos de ArticleCreate y ArticleSend',
        'Article type' => 'Tipo de artículo',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Si CrearArticulo o EnviarArticulo es usado como disparador de evento, necesitas especificar un filtro de articulo también. Por favor seleccione al menos uno de los campos de filtro de articulo.',
        'Article sender type' => 'Tipo de remitente de articulo',
        'Subject match' => 'Coincidencia de asunto',
        'Body match' => 'Coincidencia del cuerpo',
        'Include attachments to notification' => 'Incluir archivos adjuntos a la notificación',
        'Recipient' => 'Destinatario',
        'Recipient groups' => 'Grupos destinatarios',
        'Recipient agents' => 'Agentes destinatarios',
        'Recipient roles' => 'Roles destinatarios',
        'Recipient email addresses' => 'Correo electrónico destinatario',
        'Notification article type' => 'Notificación de tipo',
        'Only for notifications to specified email addresses' => 'Sólo para notificaciones a la dirección de email especificada',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para obtener los primeros 20 caracters del Sujeto (del último artículo del agente).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para obtener las primeras 5 líneas del cuerpo (del último artículo del agente).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para obtener los primeros 20 caracters del Sujeto (del último artículo del cliente).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para obtener las primeras 5 líneas del cuerpo (del último artículo del cliente).',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Administrar %s',
        'Downgrade to OTRS Free' => 'Degradar a OTRS Gratis',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s hace contacto regular con cloud.otrs.com para comprobar actualizaciones disponibles y la validez del contrato subyacente.',
        'Unauthorized Usage Detected' => 'Detectado Uso No Autorizado',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Este sistema usa el %s sin la licencia apropiada! por favor contacte con %s para renovar o activar tu contrato!',
        '%s not Correctly Installed' => '%s no esta Correctamente Instalado',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'Su %s no esta correctamente instalado. Por favor reinstale con el botón de abajo',
        'Reinstall %s' => 'Reinstalar %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'Tu %s no está correctamente instalado, y hay también disponible una actualización.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Puedes o bien reinstalar tu versión actual o realizar una actualización con los botones siguientes (recomendada actualización).',
        'Update %s' => 'Actualización %s',
        '%s Not Yet Available' => '%s No Está Aún Dsiponible',
        '%s will be available soon.' => '%s estará disponible pronto.',
        '%s Update Available' => '%s Actualización Disponible',
        'An update for your %s is available! Please update at your earliest!' =>
            'Una actualización para tu %s está disponible! Por favor actualice cuanto antes!',
        '%s Correctly Deployed' => '%s Desplegado correctamente',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Felicidades, su % s se ha instalado correctamente y se encuentra actualizado!',

        # Template: AdminOTRSBusinessNotInstalled
        'Upgrade to %s' => 'Actualizar a %s',
        '%s will be available soon. Please check again in a few days.' =>
            '%s estará disponible pronto. Por favor, puedes volver a intentarlo dentro de unos días .',
        'Please have a look at %s for more information.' => 'Por favor, eche un vistazo a %s para más información.',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            'Su OTRS libre es la base para todas las acciones futuras. Por favor regístrese primero antes de continuar con el proceso de mejora de %s!',
        'Register this System' => 'Registre este Sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'El Registro no está disponible para su sistema. Por favor revise su configuración.',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Antes de que pueda beneficiarse de %s , por favor póngase en contacto con %s para obtener su contrato de %s.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Conexión a cloud.otrs.com a través de HTTPS no se pudo establecer . Por favor, asegúrese de que su OTRS puede conectarse a través del puerto 443 cloud.otrs.com.',
        'With your existing contract you can only use a small part of the %s.' =>
            'Con su contrato existente sólo se puede utilizar una pequeña parte de la %s.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Si quieres sacar el máximo provecho de la  %s consiga su mejora de contrato ahora! Contacte %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Cancelar el degrado y regresar',
        'Go to OTRS Package Manager' => 'Ir al Manejador de Paquetes de OTRS',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Lo sentimos , pero actualmente no se puede degradar debido a los siguientes paquetes que dependen de %s:',
        'Vendor' => 'Vendedor',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Por favor, desinstale los paquetes primero utilizando el gestor de paquetes y vuelva a intentarlo .',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            'Vas a degradar a OTRS gratuito y perderá las siguientes características y todos los datos relacionados con los siguientes:',
        'Chat' => 'Chat',
        'Timeline view in ticket zoom' => 'Vista LineaTiempo en ticket zoom',
        'DynamicField ContactWithData' => 'CampoDinamico ContactoConDatos',
        'DynamicField Database' => 'CampoDinamico BaseDatos',
        'SLA Selection Dialog' => 'ANS Dialogo Selección',
        'Ticket Attachment View' => 'Vista Adjuntos Ticket',
        'The %s skin' => 'La apariencia %s',

        # Template: AdminPGP
        'PGP Management' => 'Administración PGP',
        'Use this feature if you want to work with PGP keys.' => 'Utilice esta función si desea trabajar con claves PGP.',
        'Add PGP key' => 'Agregar Clave PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'De esta forma puede editar directamente el anillo de Claves configurado en Sysconfig',
        'Introduction to PGP' => 'Introducción a PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => 'Bit',
        'Fingerprint' => 'Huella',
        'Expires' => 'Expira',
        'Delete this key' => 'Borrar esta clave',
        'Add PGP Key' => 'Agregar Clave PGP',
        'PGP key' => 'Clave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestor de paquetes',
        'Uninstall package' => 'Desinstalar paquete',
        'Do you really want to uninstall this package?' => 'Está seguro de que desea desinstalar este paquete?',
        'Reinstall package' => 'Reinstalar paquete',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '¿Realmente desea reinstalar este paquete? Se perderá cualquier cambio manual.',
        'Continue' => 'Continuar',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Por favor, asegúrese de que su base de datos acepta paquetes de más de % s MB de tamaño (actualmente sólo acepta paquetes hasta % s MB ) . Por favor, adapte el ajuste max_allowed_packet de su base de datos con el fin de evitar errores.',
        'Install' => 'Instalar',
        'Install Package' => 'Instalar Paquete',
        'Update repository information' => 'Actualizar información de repositorio',
        'Online Repository' => 'Repositorio en línea',
        'Module documentation' => 'Módulo de documentación',
        'Upgrade' => 'Actualizar',
        'Local Repository' => 'Repositorio Local',
        'This package is verified by OTRSverify (tm)' => 'Este paquete está verificado por OTRSverify (tm)',
        'Uninstall' => 'Desinstalar',
        'Reinstall' => 'Reinstalar',
        'Features for %s customers only' => 'Características sólo para clientes %s',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Con %s , usted puede beneficiarse de las siguientes características opcionales. Por favor contacte con %s si necesita más información.',
        'Download package' => 'Descargar paquete',
        'Rebuild package' => 'Reconstruir paquete',
        'Metadata' => 'Metadatos',
        'Change Log' => 'Cambio de Log',
        'Date' => 'Fecha',
        'List of Files' => 'Lista de Archivos',
        'Permission' => 'Permisos',
        'Download' => 'Descargar',
        'Download file from package!' => '¡Descargar fichero del paquete!',
        'Required' => 'Obligatorio',
        'PrimaryKey' => 'ClavePrimaria',
        'AutoIncrement' => 'AutoIncrementar',
        'SQL' => 'Límite',
        'File differences for file %s' => 'Diferencias de archivo para el archivo %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Trazas de rendimiento',
        'This feature is enabled!' => '¡Esta característica está habilitada!',
        'Just use this feature if you want to log each request.' => 'Use esta característica sólo si desea registrar cada petición.',
        'Activating this feature might affect your system performance!' =>
            '¡Activar esta opción podría afectar el rendimiento de su sistema!',
        'Disable it here!' => '¡Deshabilítelo aquí!',
        'Logfile too large!' => '¡Archivo de trazas muy grande!',
        'The logfile is too large, you need to reset it' => 'El archivolog es demasiado grande , es necesario reiniciarlo',
        'Overview' => 'Resumen',
        'Range' => 'Rango',
        'last' => 'último',
        'Interface' => 'Interfaz',
        'Requests' => 'Solicitudes',
        'Min Response' => 'Respuesta Mínima',
        'Max Response' => 'Respuesta Máxima',
        'Average Response' => 'Respuesta Promedio',
        'Period' => 'Periodo',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Promedio',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestión del filtro maestro',
        'Add filter' => 'Agregar filtro',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para enviar o filtrar los correos electrónicos entrantes basados ​​en encabezados de correo electrónico . La coincidencia usando Expresiones Regulares también es posible.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Si desea chequear sólo la dirección del email, use EMAILADDRESS:info@example.com en De, Para o Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Si utiliza Expresiones Regulares , también puede utilizar el valor emparejado en () como [***] en la acción \'Set\' .',
        'Delete this filter' => 'Borrar este filtro',
        'Add PostMaster Filter' => 'Añada Filtro PostMaster',
        'Edit PostMaster Filter' => 'Esite Filtro PostMaster',
        'The name is required.' => 'El nombre es imprescindible.',
        'Filter Condition' => 'Condición Filtro',
        'AND Condition' => 'Condición AND',
        'Check email header' => 'Comprobar encabezado email',
        'Negate' => 'Negar',
        'Look for value' => 'Busque valor',
        'The field needs to be a valid regular expression or a literal word.' =>
            'El campo tiene que ser una expresión regular válida o una palabra literal.',
        'Set Email Headers' => 'Establecer Encabezados de Email',
        'Set email header' => 'Establecer encabezado de Email',
        'Set value' => 'Establecer valor',
        'The field needs to be a literal word.' => 'El campo tiene que ser una palabra literal.',

        # Template: AdminPriority
        'Priority Management' => 'Gestión de prioridades',
        'Add priority' => 'Añadir prioridad',
        'Add Priority' => 'Añadir prioridad',
        'Edit Priority' => 'Editar la prioridad',

        # Template: AdminProcessManagement
        'Process Management' => 'Gestión de Procesos',
        'Filter for Processes' => 'Filtro para Procesos',
        'Create New Process' => 'Crear nuevo proceso',
        'Deploy All Processes' => 'Desplegar todos los Procesos',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Aquí puede cargar un archivo de configuración para importar un proceso a su sistema. El archivo debe estar en formato .yml como exportado por el módulo de gestión de procesos.',
        'Overwrite existing entities' => 'Sobrescribir entidades existentes',
        'Upload process configuration' => 'Configuración del proceso Cargar',
        'Import process configuration' => 'Configuración del proceso de importación',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Para crear un nuevo proceso puede importar un proceso que se exportó desde otro sistema o crear uno completamente nuevo.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Los cambios en los procesos aquí sólo afectan al comportamiento del sistema , si sincroniza los datos del Proceso . Mediante la sincronización de los Procesos , los cambios recién hechos se escribirán en la Configuración.',
        'Process name' => 'Nombre de proceso',
        'Print' => 'Imprimir',
        'Export Process Configuration' => 'Exportar Configuración de Procesos',
        'Copy Process' => 'Copiar Proceso',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Cancelar y cerrar esta ventana',
        'Go Back' => 'Volver',
        'Please note, that changing this activity will affect the following processes' =>
            'Tenga en cuenta , que el cambio de esta actividad afectará a los siguientes procesos',
        'Activity' => 'Actividad',
        'Activity Name' => 'Nombre de Actividad',
        'Activity Dialogs' => 'Dialogos de Actividad',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Puede asignar Diálogos de Actividad a esta Actividad arrastrando los elementos con el ratón en la lista de la izquierda a la lista de la derecha .',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Ordenar los elementos dentro de la lista también es posible mediante arrastrar y soltar .',
        'Filter available Activity Dialogs' => 'Filtros disponibles en Diálogos de Actividad ',
        'Available Activity Dialogs' => 'Dialogos Actividad Disponibles',
        'Create New Activity Dialog' => 'Cree Nueva Actividad de Diálogo',
        'Assigned Activity Dialogs' => 'Asignación de Diálogos Actividad',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Tan pronto como use este botón o enlace , saldrá de esta pantalla y su estado actual se guardará automáticamente. ¿Quieres continuar?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Tenga en cuenta que el cambio de este diálogo de actividad afectará a las siguientes actividades',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Tenga en cuenta que los usuarios clientes no serán capaces de ver o utilizar los siguientes campos : Propietario, Responsable, Bloqueo, TiempoEspera y IDCliente.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'El campo Cola sólo puede ser usado por clientes cuando crean un nuevo ticket.',
        'Activity Dialog' => 'Diálogo Actividad',
        'Activity dialog Name' => 'Nombre diálogo actividad',
        'Available in' => 'Disponible en',
        'Description (short)' => 'Descripción (corta)',
        'Description (long)' => 'Descripción (larga)',
        'The selected permission does not exist.' => 'El permiso seleccionado no existe.',
        'Required Lock' => 'Bloqueo Requerido',
        'The selected required lock does not exist.' => 'El bloqueo requerido seleccionado no existe.',
        'Submit Advice Text' => 'Envíe Texto Aviso',
        'Submit Button Text' => 'Texto Botón Enviar',
        'Fields' => 'Campos',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Puede asignar Campos a esta Diálogo de Actividad arrastrando los elementos con el ratón de la lista de la izquierda a la lista de la derecha .',
        'Filter available fields' => 'Campos filtro disponibles',
        'Available Fields' => 'Campos Disponibles',
        'Assigned Fields' => 'Campos Asignados',
        'Edit Details for Field' => 'Edite Detalles para Campo',
        'ArticleType' => 'TipoArticulo',
        'Display' => 'Mostrar',
        'Edit Field Details' => 'Edite Detalles Campo',
        'Customer interface does not support internal article types.' => 'Interfaz de cliente no soporta tipos de artículo internos.',

        # Template: AdminProcessManagementPath
        'Path' => 'Ruta',
        'Edit this transition' => 'Edite esta transición',
        'Transition Actions' => 'Acciones Transición',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Puede asignar Acciones de Transición a esta Transición arrastrando los elementos con el ratón de la lista de la izquierda a la lista de la derecha .',
        'Filter available Transition Actions' => 'Filtros disponibles Acciones Transición',
        'Available Transition Actions' => 'Acciones Transición Disponibles',
        'Create New Transition Action' => 'Crear Nueva Acción Transición',
        'Assigned Transition Actions' => 'Acción Transición Asignada',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Actividades',
        'Filter Activities...' => 'Filtrar Actividades...',
        'Create New Activity' => 'Crear Nueva Actividad',
        'Filter Activity Dialogs...' => 'Filtrar Diálogos Actividad...',
        'Transitions' => 'Transiciones',
        'Filter Transitions...' => 'Filtrar Transiciones...',
        'Create New Transition' => 'Crear Nueva Transición',
        'Filter Transition Actions...' => 'Filtrar Acciones Transición...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Editar Porceso',
        'Print process information' => 'Imprimir información proceso',
        'Delete Process' => 'Borrar Proceso',
        'Delete Inactive Process' => 'Elimine Proceso Inactivo',
        'Available Process Elements' => 'Elementos Proceso Disponibles',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Los elementos listado anteriormente en esta barra lateral se pueden mover a la zona canvas de la derecha usando arrastrar y soltar .',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Puede emplazar las Actividades en el área canvas para asignar esta Actividad al Proceso.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Para asignar un Diálogo de Actividad a una Actividad suelte el elemento del Diálogo de Actividad de esta barra lateral sobre la Actividad situada en el área canvas.',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Puedes empezar una conexión entre Actividades soltando el elemento Transición sobre la Actividad de Inicio de la conexión. Después de esto puedes mover el extremo suelto de la flecha al Final Actividad.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Las Acciones pueden ser asignadas a una Transición soltando el Elemento de Acción sobre la etiqueta de la Transición.',
        'Edit Process Information' => 'Editar información de Proceso',
        'Process Name' => 'Nombre de Proceso',
        'The selected state does not exist.' => 'El estado seleccionado no existe.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Añada y Edite Actividades, Diálogos de Actividad y Transiciones.',
        'Show EntityIDs' => 'Mostrar IDsEntidad',
        'Extend the width of the Canvas' => 'Amplíe la anchura del Canvas',
        'Extend the height of the Canvas' => 'Amplíe la altura del Canvas',
        'Remove the Activity from this Process' => 'Elimine la Actividad de este Proceso',
        'Edit this Activity' => 'Edite esta Actividad',
        'Save settings' => 'Guardar configuraciones',
        'Save Activities, Activity Dialogs and Transitions' => 'Guarde Actividades, Diálogos de Actividad y Transiciones',
        'Do you really want to delete this Process?' => 'Quiere realmente borrar este Proceso?',
        'Do you really want to delete this Activity?' => 'Quiere realmente borrar esta Actividad?',
        'Do you really want to delete this Activity Dialog?' => 'Quiere realmente borrar este Diálogo de Actividad?',
        'Do you really want to delete this Transition?' => 'Quiere realmente borrar esta Transición?',
        'Do you really want to delete this Transition Action?' => 'Quiere realmente borrar esta Acción de Transición?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Quiere realmente eliminar esta actividad del canvas? Esto sólo puede ser deshecho abandonando esta pantalla sin guardar.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Quiere realmente eliminar esta transición del canvas? Esto sólo puede ser deshecho abandonando esta pantalla sin guardar.',
        'Hide EntityIDs' => 'Ocultar IDsEntidad',
        'Delete Entity' => 'Borrar Entidad',
        'Remove Entity from canvas' => 'Eliminar Entidad de canvas',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Esta Actividad ya está siendo utilizada en el Proceso. No puede añadirla por duplicado!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Esta Actividad no se puede borrar porque es la Actividad de Inicio.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Esta Transición ya esta siendo utilizada para esta Actividad. No puede usarla por duplicado!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Esta AcciónTransición ya esta siendo utilizada en esta Ruta. No puede usarla por duplicado!',
        'Remove the Transition from this Process' => 'Elimine la Transición de este Proceso',
        'No TransitionActions assigned.' => 'No AccionesTransición asignadas.',
        'The Start Event cannot loose the Start Transition!' => 'El Evento de Inicio no puede perder la Transición de Inicio!',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'No se han asignado aún diálogos. Simplemente escoja un diálogo de actividad de la lista de la izquierda y arrástrela aquí.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Una transición no conectada ya está colocada en el canvas. Por favor, conecte esta transición primero antes de hacer otra transición .',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'En esta pantalla, puede crear un nuevo proceso . Con el fin de hacer que el nuevo proceso esté a disposición de los usuarios , por favor asegúrese de ajustar su estado a \'Activa\' y sincronizar después de completar su trabajo.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Comenzar Actividad',
        'Contains %s dialog(s)' => 'Contiene %s diálogo(s)',
        'Assigned dialogs' => 'Diálogos asignados',
        'Activities are not being used in this process.' => 'Actividades no están siendo usadas en este proceso.',
        'Assigned fields' => 'Campos asignados',
        'Activity dialogs are not being used in this process.' => 'Diálogos de actividad no están siendo usados en este proceso.',
        'Condition linking' => 'Condición de vinculación',
        'Conditions' => 'Condiciones',
        'Condition' => 'Condición',
        'Transitions are not being used in this process.' => 'Transiciones no están siendo usadas en este proceso.',
        'Module name' => 'Nombre del Módulo',
        'Configuration' => 'Configuración',
        'Transition actions are not being used in this process.' => 'Acciones de transición no están siendo usadas en este proceso.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Tenga en cuenta que el cambio de esta transición afectará a los siguientes procesos',
        'Transition' => 'Transición',
        'Transition Name' => 'Nombre de la Transición',
        'Type of Linking between Conditions' => 'Tipo de Vinculación entre Condiciones',
        'Remove this Condition' => 'Eliminar esta Condición',
        'Type of Linking' => 'Tipo de Vinculación',
        'Remove this Field' => 'Eliminar este Campo',
        'And can\'t be repeated on the same condition.' => 'Y no puede ser repetida en la misma condición.',
        'Add a new Field' => 'Añadir nuevo Campo',
        'Add New Condition' => 'Añadir Nueva Condición',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Tenga en cuenta que el cambio de esta acción de transición afectará a los siguientes procesos',
        'Transition Action' => 'Acción de Transición',
        'Transition Action Name' => 'Nombre Acción de Transición',
        'Transition Action Module' => 'Módulo Acción de Transición',
        'Config Parameters' => 'Parámetros de Configuración',
        'Remove this Parameter' => 'Elimine este Parámetro',
        'Add a new Parameter' => 'Añada un nuevo Parámetro',

        # Template: AdminQueue
        'Manage Queues' => 'Gestionar las colas',
        'Add queue' => 'Añadir cola',
        'Add Queue' => 'Añadir cola',
        'Edit Queue' => 'Editar la cola',
        'A queue with this name already exists!' => 'Una cola con este nombre ya existe!',
        'Sub-queue of' => 'Subcola de',
        'Unlock timeout' => 'Tiempo para desbloqueo automático',
        '0 = no unlock' => '0 = sin desbloqueo',
        'Only business hours are counted.' => 'Sólo se contarán las horas de trabajo',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Si un agente bloquea un ticket y no se cierra antes de que haya pasado el tiempo de espera de desbloqueo, el ticket se desbloqueará y estará disponible para otros agentes .',
        'Notify by' => 'Notificado por',
        '0 = no escalation' => '0 = sin escalada',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Si no se añade un contacto de cliente, ya sea correo electrónico externo o teléfono, a un nuevo ticket antes de que la hora definida aquí expire, el ticket es escalado.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Si se añade un artículo, como un seguimiento a través de correo electrónico o portal del cliente , el tiempo de actualización de escalado se restablece. Si no hay contacto del cliente, ya sea correo electrónico o teléfono externo, añadido a un ticket antes de que la hora definida aquí expire, el ticket es escalado .',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Si el ticket no se establece a cerrado antes de que la hora definida aquí expire, el ticket es escalado.',
        'Follow up Option' => 'Opción de seguimiento',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica si el seguimiento a los tickets cerrados volvería a abrir el ticket , ser rechazado o dar lugar a un nuevo ticket.',
        'Ticket lock after a follow up' => 'Bloquear un ticket después del seguimiento',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Si un ticket es cerrado y el cliente envía un seguimiento del ticket se bloqueará al antiguo propietario.',
        'System address' => 'Dirección sistema',
        'Will be the sender address of this queue for email answers.' => 'Será la dirección del emisor en esta cola para respuestas por correo.',
        'Default sign key' => 'Clave de firma por defecto',
        'The salutation for email answers.' => 'Saludo para respuestas por correo.',
        'The signature for email answers.' => 'Firma para respuestas por correo.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Administrar Colas - Relaciones Auto Respuesta  ',
        'Filter for Queues' => 'Filtrar por Colas',
        'Filter for Auto Responses' => 'Filtrar por Auto Respuestas',
        'Auto Responses' => 'Respuestas Automáticas',
        'Change Auto Response Relations for Queue' => 'Cambiar Relaciones Auto Respuesta para Cola',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Administrar Relaciones Plantilla-Cola',
        'Filter for Templates' => 'Filtrar por Plantillas',
        'Templates' => 'Plantillas',
        'Change Queue Relations for Template' => 'Cambiar Relaciones Cola para Plantilla',
        'Change Template Relations for Queue' => 'Cambiar Relaciones Plantilla para Cola',

        # Template: AdminRegistration
        'System Registration Management' => 'Gestión de Registro del sistema',
        'Edit details' => 'Edite detalles',
        'Show transmitted data' => 'Mostrar datos transmitidos',
        'Deregister system' => 'Dar de baja sistema',
        'Overview of registered systems' => 'Vista general de sistemas registrados',
        'System Registration' => 'Registro del sistema',
        'This system is registered with OTRS Group.' => 'Este sistema se encuentra registrado por OTRS Group',
        'System type' => 'Tipo de sistema',
        'Unique ID' => 'Identificador unico',
        'Last communication with registration server' => 'Última comunicación con el servidor de registro',
        'Send support data' => 'Enviar datos de soporte',
        'System registration not possible' => 'Registrar el sistema no es posible',
        'Please note that you can\'t register your system if your scheduler is not running correctly!' =>
            'Tenga en cuenta que no se puede registrar el sistema si el planificador no está funcionando correctamente!',
        'Instructions' => 'Instrucciones',
        'System deregistration not possible' => 'Dar de baja el sistema no es posible',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Tenga en cuenta que no se puede dar de baja su sistema si usted está utilizando el %s o teniendo un contrato de servicio válido.',
        'OTRS-ID Login' => 'Inicio de sesión con OTRS-ID',
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '!El registro del sistema es un servicio del grupo OTRS, el cual provee innumerables ventajas!',
        'Read more' => 'Leer más',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Debe iniciar sesión con su OTRS-ID para registrar el sistema.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Su OTRS-ID es la dirección de correo electrónico que utilizó para registrarse en la página web OTRS.com',
        'Data Protection' => 'Protección de Datos',
        'What are the advantages of system registration?' => '¿Cuáles son las ventajas de registrar su sistema?',
        'You will receive updates about relevant security releases.' => 'Usted recibirá actualizaciones sobre versiones de seguridad importantes.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Con el registro de su sistema podremos mejorar nuestros servicios hacia usted, porque tenemos disponible toda la información importante.',
        'This is only the beginning!' => '!Esto es sólo el comienzo!',
        'We will inform you about our new services and offerings soon.' =>
            'Muy pronto le estaremos informando sobre nuevos servicios y ofertas',
        'Can I use OTRS without being registered?' => '¿Es posible utilizar OTRS sin registrarlo?',
        'System registration is optional.' => 'El registro del sistema es opcional.',
        'You can download and use OTRS without being registered.' => 'Usted puede descargar y utilizar OTRS sin estar registrado.',
        'Is it possible to deregister?' => '¿Es posible dar de baja el registro?',
        'You can deregister at any time.' => 'Usted puede dar de baja el registro en cualquier momento.',
        'Which data is transfered when registering?' => '¿Qué datos se transfieren al registrarse?',
        'A registered system sends the following data to OTRS Group:' => 'Un sistema registrado envía los siguientes datos al grupo OTRS:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Nombre de dominio totalmente calificado (FQDN), versión de OTRS, base de datos, sistema operativo y versión de Perl',
        'Why do I have to provide a description for my system?' => '¿Por qué debo de proporcionar una descripción del sistema?',
        'The description of the system is optional.' => 'La descripción del sistema es opcional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'La descripción y el tipo de sistema que especifique ayudara para identificar y gestionar los datos de sus sistemas registrados',
        'How often does my OTRS system send updates?' => '¿Con qué frecuencia mi sistema OTRS envía actualizaciones?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'El sistema enviará actualizaciones al servidor de registro en intervalos regulares.',
        'Typically this would be around once every three days.' => 'Normalmente, esto sería alrededor de una vez cada tres días.',
        'In case you would have further questions we would be glad to answer them.' =>
            'En caso de que tenga alguna duda estaremos encantados de responderla.',
        'Please visit our' => 'Por favor, visite nuestro',
        'portal' => 'portal',
        'and file a request.' => 'e ingrese una solicitud.',
        'Here at OTRS Group we take the protection of your personal details very seriously and strictly adhere to data protection laws.' =>
            'Aquí en Grupo OTRS nos tomamos la protección de sus datos personales muy en serio y nos adherimos estrictamente a las leyes de protección de datos.',
        'All passwords are automatically made unrecognizable before the information is sent.' =>
            'Todas las contraseñas se hacen automáticamente irreconocibles antes de enviar la información.',
        'Under no circumstances will any data we obtain be sold or passed on to unauthorized third parties.' =>
            'En ningún caso los datos que obtenemos se venderán ni serán cedidos a terceros no autorizados.',
        'The following explanation provides you with an overview of how we guarantee this protection and which type of data is collected for which purpose.' =>
            'La siguiente explicación le proporciona una visión general de cómo garantizamos esta protección y qué tipo de datos se recogen y con que proposito.',
        'Data Handling with \'System Registration\'' => 'Datos de manipulación con "Registro del sistema"',
        'Information received through the \'Service Center\' is saved by OTRS Group.' =>
            'La información recibida a través del \'Centro de Servicio\' es guardada por Grupo OTRS.',
        'This only applies to data that OTRS Group requires to analyze the performance and function of the OTRS server or to establish contact.' =>
            'Esto sólo se aplica a los datos que el Grupo OTRS requiere para analizar el desempeño y la función del servidor de OTRS o establecer contacto.',
        'Safety of Personal Details' => 'Seguridad de los Datos Personales',
        'OTRS Group protects your personal data from unauthorized access, use or publication.' =>
            'Grupo OTRS protege sus datos personales de acceso no autorizado , uso o publicación.',
        'OTRS Group ensures that the personal information you store on the server is protected from unauthorized access and publication.' =>
            'Grupo OTRS garantiza que los datos personales que se almacenan en el servidor están protegidos contra el acceso y la publicación no autorizada.',
        'Disclosure of Details' => 'Divulgación de Datos',
        'OTRS Group will not pass on your details to third parties unless required for business transactions.' =>
            'Grupo OTRS no pasará sus datos a terceros a menos que sea requerido para las transacciones comerciales .',
        'OTRS Group will only pass on your details to entitled public institutions and authorities if required by law or court order.' =>
            'Grupo OTRS sólo pasará sus datos a las instituciones y autoridades públicas con derecho si es requerido por la ley u orden judicial.',
        'Amendment of Data Protection Policy' => 'Modificación de la Política de Protección de Datos',
        'OTRS Group reserves the right to amend this security and data protection policy if required by technical developments.' =>
            'Grupo OTRS se reserva el derecho a modificar la presente política de seguridad y protección de datos si es requerido por la evolución técnica .',
        'In this case we will also adapt our information regarding data protection accordingly.' =>
            'En este caso también adaptaremos nuestra información con respecto a la protección de datos en consecuencia.',
        'Please regularly refer to the latest version of our Data Protection Policy.' =>
            'Por favor, consulte regularmente la última versión de nuestra Política de Protección de Datos.',
        'Right to Information' => 'Derecho de información',
        'You have the right to demand information concerning the data saved about you, its origin and recipients, as well as the purpose of the data processing at any time.' =>
            'Usted tiene el derecho de exigir la información relativa a sus datos guardados, su origen y receptores , así como la finalidad del tratamiento de datos en cualquier momento.',
        'You can request information about the saved data by sending an e-mail to info@otrs.com.' =>
            'Puede solicitar información sobre los datos guardados mediante el envío de un email a info@otrs.com.',
        'Further Information' => 'Información adicional',
        'Your trust is very important to us. We are willing to inform you about the processing of your personal details at any time.' =>
            'Su confianza es muy importante para nosotros. Estamos dispuestos a informarle sobre el tratamiento de sus datos personales en cualquier momento.',
        'If you have any questions that have not been answered by this Data Protection Policy or if you require more detailed information about a specific topic, please contact info@otrs.com.' =>
            'Si usted tiene alguna pregunta que no ha sido respondida por la presente Política de Protección de Datos o si necesita información más detallada acerca de un tema específico, por favor póngase en contacto con info@otrs.com.',
        'If you deregister your system, you will lose these benefits:' =>
            'Si da de baja su sistema, perderá estos beneficios :',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Debe iniciar sesión con su OTRS-ID para dar de baja su sistema.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => '¿Aún no tiene su OTRS-ID?',
        'Sign up now' => 'Regístrese ahora',
        'Forgot your password?' => '¿Olvidó su contraseña?',
        'Retrieve a new one' => 'Solicitar una nueva',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Estos datos se transferiran con frecuencia al grupo OTRS cuando registre este sistema.',
        'Attribute' => 'Atributo',
        'FQDN' => 'Nombre de dominio totalmente calificado',
        'Optional description of this system.' => 'Descripción opcional de este sistema.',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Esto permitirá al sistema enviar información de datos de apoyo adicional al Grupo OTRS.',
        'Service Center' => 'Centro de Servicios',
        'Support Data Management' => 'Gestión de Datos de Soporte',
        'Register' => 'Registrar',
        'Deregister System' => 'Sistema dado de baja',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Continuando con este paso se dará de baja el sistema para el grupo OTRS.',
        'Deregister' => 'Dar de baja',
        'You can modify registration settings here.' => 'Usted puede modificar los ajustes de registro aquí.',
        'Overview of transmitted data' => 'Resumen de los datos transmitidos',
        'There is no data regularly sent from your system to %s.' => 'No hay datos enviados con regularidad de su sistema a %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Los siguientes datos se envían como mínimo cada 3 días desde su sistema a %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Los datos se transfieren en formato JSON a través de una conexión segura https.',
        'System Registration Data' => 'Datos Registro Sistema',
        'Support Data' => 'Datos de Soporte',

        # Template: AdminRole
        'Role Management' => 'Gestión de Roles',
        'Add role' => 'Agregar rol',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Cree un rol y coloque grupos en el mismo. Luego añada el rol a los usuarios.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'No hay roles definidos. Por favor use el botón \'\'Agregar" para crear un nuevo rol.',
        'Add Role' => 'Añadir Rol',
        'Edit Role' => 'Editar Rol',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gestionar las relaciones Rol - Grupo',
        'Filter for Roles' => 'Filtro por Roles',
        'Select the role:group permissions.' => 'Seleccione los permisos rol:grupo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Si nada es seleccionado, entonces no hay permisos en este grupo (los tickets no estarán disponibles para el Rol)',
        'Change Role Relations for Group' => 'Cambiar las relaciones de Rol del Grupo',
        'Change Group Relations for Role' => 'Cambiar las relaciones de Grupo del Rol',
        'Toggle %s permission for all' => 'Activar el permiso %s para todos',
        'move_into' => 'mover_a',
        'Permissions to move tickets into this group/queue.' => 'Permiso para mover tickets a este grupo/cola',
        'create' => 'crear',
        'Permissions to create tickets in this group/queue.' => 'Permiso para crear tickets en este grupo/cola',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permisos para añadir notas a los tickets de este grupo/cola.',
        'owner' => 'propietario',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permisos para cambiar el propietario de los tickets de este grupo/cola.',
        'priority' => 'prioridad',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permiso para cambiar la prioridad del ticket en este grupo/cola',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gestionar las relaciones Agente - Rol',
        'Filter for Agents' => 'Filtro para Agentes',
        'Manage Role-Agent Relations' => 'Gestionar las relaciones Rol - Agente',
        'Change Role Relations for Agent' => 'Cambiar las relaciones de Rol del Agente',
        'Change Agent Relations for Role' => 'Cambiar las relaciones de Agente del Rol',

        # Template: AdminSLA
        'SLA Management' => 'Gestión de SLA',
        'Add SLA' => 'Añadir SLA',
        'Edit SLA' => 'Editar el SLA',
        'Please write only numbers!' => 'Introduzca sólo números.',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestion S/MIME',
        'Add certificate' => 'Añadir certificado',
        'Add private key' => 'Añadir clave privada',
        'Filter for certificates' => 'Filtro para certificados',
        'Filter for S/MIME certs' => 'Filtro para certificados S/MIME',
        'To show certificate details click on a certificate icon.' => 'Para mostrar los detalles de certificado hacer click en un icono de certificado.',
        'To manage private certificate relations click on a private key icon.' =>
            'Para gestionar las relaciones de certificados privados hacer clic en un icono de la llave privada.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Aquí usted puede agregar relaciones con su certificado privado, estos serán incorporados a la firma S/MIME cada vez que se utiliza este certificado para firmar un correo electrónico.',
        'See also' => 'Vea también',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'De esta forma Ud. puede editar directamente la certificación y claves privadas en el sistema de ficheros.',
        'Hash' => 'De esta forma Ud. puede editar directamente la certificación y claves privadas en el sistema de ficheros.',
        'Handle related certificates' => 'Maneje certificados relacionados',
        'Read certificate' => 'Leer certificado',
        'Delete this certificate' => 'Eliminar este certificado',
        'Add Certificate' => 'Añadir un certificado',
        'Add Private Key' => 'Añadir una Clave privada',
        'Secret' => 'Secreto',
        'Related Certificates for' => 'Certificados relacionados para',
        'Delete this relation' => 'Eliminar esta relación',
        'Available Certificates' => 'Certificados Disponibles',
        'Relate this certificate' => 'Relacionar este certificado',

        # Template: AdminSMIMECertRead
        'Close window' => 'Cerrar la ventana',
        'Certificate details' => 'Detalles del Certificado',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestión de saludos',
        'Add salutation' => 'Añadir saludo',
        'Add Salutation' => 'Añadir saludo',
        'Edit Salutation' => 'Editar el saludo',
        'Example salutation' => 'Saludo de ejemplo',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => '¡Es necesario habilitar modo seguro!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'El Modo Seguro (normalmente) queda habilitado cuando la instalación inicial se completa.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si el modo seguro no está activado , activarlo a través de sysconfig porque su aplicación ya se está ejecutando .',

        # Template: AdminSelectBox
        'SQL Box' => 'Consola SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Aquí puede introducir una SQL para enviarla directamente a la base de datos de la aplicación. No es posible cambiar el contenido de las tablas , sólo consultas select están permitidas.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aquí puede introducir una SQL para enviarla directamente a la base de datos de la aplicación.',
        'Only select queries are allowed.' => 'Solo consultas select están permitidas.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'La sintaxis de tu consulta SQL tiene un error. Por favor compruébela.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Hay por lo menos un parámetro que falta para la unión. Compruébelo por favor.',
        'Result format' => 'Formato resultado',
        'Run Query' => 'Ejecutar Consulta',
        'Query is executed.' => 'Consulta se ejecuta.',

        # Template: AdminService
        'Service Management' => 'Gestión de servicios',
        'Add service' => 'Añadir servicio',
        'Add Service' => 'Añadir servicio',
        'Edit Service' => 'Editar el servicio',
        'Sub-service of' => 'Subservicio de',

        # Template: AdminServiceCenterSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Estos datos se envían a Grupo OTRS en una base regular. Para detener el envío de estos datos por favor actualice su registro del sistema.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Puedes disparar manualmente los envíos de Datos de Soporte presionando este botón:',
        'Send Update' => 'Enviar Actualización',
        'Sending Update...' => 'Enviando Actualización...',
        'Support Data information was successfully sent.' => 'Información de Datos de Soporte fue enviada satisfactoriamente.',
        'Was not possible to send Support Data information.' => 'No fue posible enviar información de Datos de Soporte.',
        'Update Result' => 'Actualizar Resultado',
        'Currently this data is only shown in this system.' => 'Actualmente estos datos sólo se muestran en este sistema.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Es altamente recomendable enviar estos datos a Grupo OTRS con el fin de obtener un mejor servicio de soporte.',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Para habilitar el envío de datos, registre su sistema con Grupo OTRS o actualice su información de registro del sistema ( asegúrese de activar la opción \'Enviar datos de soporte enviar\'.)',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Un paquete de apoyo (incluyendo : información de registro del sistema, los datos de apoyo, una lista de los paquetes instalados y todos los archivos de código fuente modificados localmente) puede generarse presionando este botón:',
        'Generate Support Bundle' => 'Generar Paquete de Apoyo',
        'Generating...' => 'Generando...',
        'It was not possible to generate the Support Bundle.' => 'No fue posible generar el Paquete de Apoyo.',
        'Generate Result' => 'Generar Resultado',
        'Support Bundle' => 'Paquete de Soporte',
        'The mail could not be sent' => 'El correo no pudo ser enviado',
        'The support bundle has been generated.' => 'El paquete de soporte ha sido generado.',
        'Please choose one of the following options.' => 'Por favor escoja una de las siguientes opciones.',
        'Send by Email' => 'Enviar por Email',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'El paquete de soporte es demasiado grande para enviarlo por correo electrónico, esta opción ha sido deshabilitada.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'La dirección de correo electrónico para este usuario no es válida, esta opción se ha desactivado.',
        'Sending' => 'Remitente',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'El paquete de soporte será enviado a Grupo OTRS a través de correo electrónico de forma automática.',
        'Download File' => 'Descargar Archivo',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Un archivo que contiene el paquete de soporte se descargará en el sistema local. Por favor, guarde el archivo y envíelo al Grupo de OTRS, utilizando un método alternativo .',
        'Error: Support data could not be collected (%s).' => 'Error: Los datos de soporte no han podido ser recolectados (%s).',
        'Details' => 'Detalles',

        # Template: AdminSession
        'Session Management' => 'Gestión de Sesiones',
        'All sessions' => 'Todas las sesiones',
        'Agent sessions' => 'Sesiones de agente',
        'Customer sessions' => 'Sesiones de cliente',
        'Unique agents' => 'Agentes únicos',
        'Unique customers' => 'Clientes únicos',
        'Kill all sessions' => 'Finalizar todas las sesiones',
        'Kill this session' => 'Matar esta sesión',
        'Session' => 'Sesión',
        'Kill' => 'Matar',
        'Detail View for SessionID' => 'Vista Detalle para SesiónID',

        # Template: AdminSignature
        'Signature Management' => 'Gestión de firmas',
        'Add signature' => 'Añadir firma',
        'Add Signature' => 'Añadir firma',
        'Edit Signature' => 'Editar la firma',
        'Example signature' => 'Firma de ejemplo',

        # Template: AdminState
        'State Management' => 'Gestión de estados',
        'Add state' => 'Añadir estado',
        'Please also update the states in SysConfig where needed.' => 'Actualice también los estados en SysConfig donde sea necesario.',
        'Add State' => 'Añadir estado',
        'Edit State' => 'Editar el estado',
        'State type' => 'Tipo de estado',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuración del sistema',
        'Navigate by searching in %s settings' => 'Navegue por búsqueda en ajustes %s',
        'Navigate by selecting config groups' => 'Navegue seleccionando grupos de configuración',
        'Download all system config changes' => 'Descargue todos los cambios de configuración de sistema',
        'Export settings' => 'Exportar ajustes',
        'Load SysConfig settings from file' => 'Cargue ajustes de SysConfig desde archivo',
        'Import settings' => 'Importar ajustes',
        'Import Settings' => 'Importar Ajustes',
        'Please enter a search term to look for settings.' => 'Por favor, introduzca un término de búsqueda para buscar los ajustes.',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Edite Ajustes de Configuración',
        'This config item is only available in a higher config level!' =>
            'Este elemento de configuración sólo está disponible en un nivel de configuración mayor!',
        'Reset this setting' => 'Reestablecer este ajuste',
        'Error: this file could not be found.' => 'Error: este archivo no pudo ser encontrado.',
        'Error: this directory could not be found.' => 'Error: este directorio no pudo ser encontrado.',
        'Error: an invalid value was entered.' => 'Error: un valor inválido fue introducido.',
        'Content' => 'Contenido',
        'Remove this entry' => 'Elimine esta entrada',
        'Add entry' => 'Añada entrada',
        'Remove entry' => 'Elimine entrada',
        'Add new entry' => 'Añadir nueva entrada',
        'Delete this entry' => 'Eliminar esta entrada',
        'Create new entry' => 'Crear nueva entrada',
        'New group' => 'Nuevo grupo',
        'Group ro' => 'Grupo ro',
        'Readonly group' => 'Grupo de sólo lectura',
        'New group ro' => 'Nuevo grupo ro',
        'Loader' => 'Cargador',
        'File to load for this frontend module' => 'Archivo a cargar para este módulo frontend',
        'New Loader File' => 'Nuevo Cargador de Archivo',
        'NavBarName' => 'NombreBarraNavegación',
        'NavBar' => 'BarraNavegación',
        'LinkOption' => 'Enlazar',
        'Block' => 'Bloqueo',
        'AccessKey' => 'TeclaAcceso',
        'Add NavBar entry' => 'Añada entrada en NavBar',
        'Year' => 'Año',
        'Month' => 'Mes',
        'Day' => 'Día',
        'Invalid year' => 'Año no válido',
        'Invalid month' => 'Mes no válido',
        'Invalid day' => 'Día no válido',
        'Show more' => 'Mostrar más',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestión de Direcciones de Correo del sistema',
        'Add system address' => 'Añadir dirección de sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todo el correo electrónico entrante con esta dirección en Para o Cc será enviado a la cola seleccionada.',
        'Email address' => 'Dirección de correo electrónico',
        'Display name' => 'Mostrar nombre',
        'Add System Email Address' => 'Añadir Dirección de Correo Electrónico de Sistema',
        'Edit System Email Address' => 'Editar Dirección de Correo Electrónico de Sistema',
        'The display name and email address will be shown on mail you send.' =>
            'El nombre a mostrar y la dirección de correo electrónico serán mostrados en el correo que tu envías.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Sistema de Gestión de Mantenimiento',
        'Schedule New System Maintenance' => 'Planificar Nuevo Mantenimiento de Sistema',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Programar un periodo de mantenimiento del sistema para anunciar a los Agentes y Clientes que el sistema está desactivado por un período de tiempo.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Algún tiempo antes de que comience este mantenimiento de sistema los usuarios recibirán una notificación en cada pantalla anunciando sobre este hecho.',
        'Start date' => 'Fecha inicio',
        'Stop date' => 'Fecha fin',
        'Delete System Maintenance' => 'Eliminar Mantenimiento de Sistema',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Quieres realmente eliminar este mantenimiento de sistema programado?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Edite Mantenimiento %s de Sistema',
        'Edit System Maintenance information' => 'Edite la información de Mantenimiento de Sistema',
        'Date invalid!' => 'Fecha no válida',
        'Login message' => 'Mensaje de login',
        'Show login message' => 'Mostrar mensaje de login',
        'Notify message' => 'Notificar mensaje',
        'Manage Sessions' => 'Administrar Sesiones',
        'All Sessions' => 'Todas las Sesiones',
        'Agent Sessions' => 'Sesiones Agente',
        'Customer Sessions' => 'Sesiones Cliente',
        'Kill all Sessions, except for your own' => 'Matar todas las Sesiones, excepto de la suya propia',

        # Template: AdminTemplate
        'Manage Templates' => 'Gestionar Plantillas',
        'Add template' => 'Agregar plantilla',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Una plantilla es el texto por defecto que ayuda a sus agentes a escribir mas rápido los tickets, respuestas o reenvios',
        'Don\'t forget to add new templates to queues.' => 'No olvide agregar las nuevas plantillas a las colas',
        'Add Template' => 'Agregar Plantilla',
        'Edit Template' => 'Editar Plantilla',
        'A standard template with this name already exists!' => 'Ya existe na plantilla estándar con este nombre',
        'Template' => 'Plantilla',
        'Create type templates only supports this smart tags' => 'Crear plantillas tipo sólo soporta estas etiquetas inteligentes',
        'Example template' => 'Plantilla Ejemplo',
        'The current ticket state is' => 'El estado actual del ticket es',
        'Your email address is' => 'Su dirección de correo electrónico es',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Gestionar Relación Plantillas <-> Adjuntos',
        'Filter for Attachments' => 'Filtro para Adjuntos',
        'Change Template Relations for Attachment' => 'Cambiar las relaciones de Plantillas del Adunto',
        'Change Attachment Relations for Template' => 'Cambiar las relaciones de Adjuntos de la Plantilla',
        'Toggle active for all' => 'Alternar a activo para todos',
        'Link %s to selected %s' => 'Enlaza %s al %s seleccionado',

        # Template: AdminType
        'Type Management' => 'Gestión de tipos',
        'Add ticket type' => 'Añadir tipo de ticket',
        'Add Type' => 'Añadir tipo',
        'Edit Type' => 'Editar el tipo',
        'A type with this name already exists!' => 'Un tipo con este nombre ya existe!',

        # Template: AdminUser
        'Add agent' => 'Añadir agente',
        'Agents will be needed to handle tickets.' => 'Se necesitan agentes para gestionar los tickets.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'No olvide añadir un nuevo agente a grupos y/o roles.',
        'Please enter a search term to look for agents.' => 'Introduzca un término de búsqueda para buscar agentes.',
        'Last login' => 'Última sesión',
        'Switch to agent' => 'Cambiar al agente',
        'Add Agent' => 'Añadir agente',
        'Edit Agent' => 'Editar el agente',
        'Firstname' => 'Nombre',
        'Lastname' => 'Apellido',
        'A user with this username already exists!' => 'Un usuario con este nombre ya existe!',
        'Will be auto-generated if left empty.' => 'Se autogenerará si se deja en blanco.',
        'Start' => 'Iniciar',
        'End' => 'Fin',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gestionar las relaciones agente-grupo',
        'Change Group Relations for Agent' => 'Cambiar las relaciones de grupo del agente',
        'Change Agent Relations for Group' => 'Cambiar las relaciones de agente del grupo',

        # Template: AgentBook
        'Address Book' => 'Libreta de direcciones',
        'Search for a customer' => 'Buscar un cliente',
        'Add email address %s to the To field' => 'Añadir la dirección de correo %s al campo Para',
        'Add email address %s to the Cc field' => 'Añadir la dirección de correo %s al campo Cc',
        'Add email address %s to the Bcc field' => 'Añadir la dirección de correo %s al campo Bcc',
        'Apply' => 'Aplicar',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro de información del cliente',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Cliente',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Entrada duplicada',
        'This address already exists on the address list.' => 'Esta dirección ya estaba en la lista de direcciones.',
        'It is going to be deleted from the field, please try again.' => 'Se va a borrar del campo, inténtelo de nuevo.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: ¡el cliente no es válido!',

        # Template: AgentDashboard
        'Dashboard' => 'Panel principal',

        # Template: AgentDashboardCalendarOverview
        'in' => 'en',

        # Template: AgentDashboardCommon
        'Available Columns' => 'Columnas disponibles',
        'Visible Columns (order by drag & drop)' => 'Columnas visibles (ordenar arrastrando y soltando)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tickets escalados',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Información del cliente',
        'Phone ticket' => 'Ticket telefónico',
        'Email ticket' => 'Ticket por correo',
        'Start Chat' => 'Inicar Chat',
        '%s open ticket(s) of %s' => '%s tickets abiertos de %s',
        '%s closed ticket(s) of %s' => '%s tickets cerrados de %s',
        'New phone ticket from %s' => 'Nuevo ticket telefónico de %s',
        'New email ticket to %s' => 'Nuevo ticket por correo para %s',
        'Start chat' => 'Iniciar chat',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '¡%s %s está disponible!',
        'Please update now.' => 'Por favor, actualice ahora.',
        'Release Note' => 'Notas de versión',
        'Level' => 'Nivel',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Enviado hace %s.',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Se está preparado el contenido de esta estadística para usted, por favor sea paciente.',
        'Grouped' => 'Agrupado',
        'Stacked' => 'Apilado',
        'Expanded' => 'Expandido',
        'Stream' => 'Stream',
        'CSV' => 'CSV',
        'PDF' => 'PDF',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mis tickets bloqueados',
        'My watched tickets' => 'Mis tickets vigilados',
        'My responsibilities' => 'Mis responsabilidades',
        'Tickets in My Queues' => 'Tickets en mis colas',
        'Tickets in My Services' => 'Tickets en Mis Servicios',
        'Service Time' => 'Tiempo de servicio',
        'Remove active filters for this widget.' => 'Eliminar los filtros activos para este componente.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Totales',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fuera de la oficina',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'hasta',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'El ticket ha sido bloqueado',
        'Undo & close window' => 'Deshacer y cerrar la ventana',

        # Template: AgentInfo
        'Info' => 'Información',
        'To accept some news, a license or some changes.' => 'Para aceptar algunas noticias, una licencia o algunos cambios.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Enlazar el objeto: %s',
        'go to link delete screen' => 'ir a la pantalla de borrado de enlaces',
        'Select Target Object' => 'Seleccione el objeto destino',
        'Link Object' => 'Enlazar objeto',
        'with' => 'con',
        'Unlink Object: %s' => 'Desenlazar el objeto: %s',
        'go to link add screen' => 'ir a la pantalla de añadir enlaces',

        # Template: AgentPreferences
        'Edit your preferences' => 'Editar sus preferencias',

        # Template: AgentSchedulerInfo
        'General Information' => 'Información General',
        'Scheduler is an OTRS separated process that perform asynchronous tasks' =>
            'El planificador es un proceso OTRS separado que ejecuta tareas asíncronas.',
        '(e.g. Generic Interface asynchronous invoker tasks)' => '(ej. Interfaz Genérica del invocador de tareas asíncronas)',
        'It is necessary to have the Scheduler running to make the system work correctly!' =>
            'Es necesario tener un Planificador ejecutándose para hacer que el sistema funcione correctamente!',
        'Starting Scheduler' => 'Comenzando Planificador',
        'Make sure that %s exists (without .dist extension)' => 'Asegúrese de que %s existe (sin la extensión .dist)',
        'Check that cron deamon is running in the system' => 'Compruebe que cron daemon esta ejecutándose en el sistema',
        'Confirm that OTRS cron jobs are running, execute %s start' => 'Confirme que los trabajos cron de OTRS se están ejecutando, ejecute inicio %s',

        # Template: AgentSpelling
        'Spell Checker' => 'Verificación ortográfica',
        'spelling error(s)' => 'errores ortográficos',
        'Apply these changes' => 'Aplicar los cambios',

        # Template: AgentStatsDelete
        'Delete stat' => 'Borrar la estadística',
        'Do you really want to delete this stat?' => '¿Seguro que desea borrar esta estadística?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Paso %s',
        'General Specifications' => 'Especificaciones generales',
        'Select the element that will be used at the X-axis' => 'Seleccione el elemento que se usará para el eje X.',
        'Select the elements for the value series' => 'Seleccione los elementos para la serie de valores',
        'Select the restrictions to characterize the stat' => 'Seleccione las restricciones para caracterizar la estadística',
        'Here you can make restrictions to your stat.' => 'Aquí puede declarar restricciones para su estadística.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Si elimina el candado en la casilla «Fijado», el agente que genere la estadística puede cambiar los atributos del elemento correspondiente',
        'Fixed' => 'Fijado',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor seleccione sólo un elemento o desactive el botón «Fijado».',
        'Absolute Period' => 'Periodo absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Periodo relativo',
        'The last' => 'El último',
        'Finish' => 'Finalizar',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permisos',
        'You can select one or more groups to define access for different agents.' =>
            'Puede seleccionar uno o más grupos para definir accesos para diferentes agentes.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Algunos formatos de resultado están inhabilitados porque hay al menos un paquete necesario que no está instalado.',
        'Please contact your administrator.' => 'Contacte con su administrador.',
        'Graph size' => 'Tamaño de la gráfica',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Si utiliza una gráfica como formato de salida debe seleccionar al menos un tamaño de gráfica.',
        'Sum rows' => 'Sumar las filas',
        'Sum columns' => 'Sumar las columnas',
        'Use cache' => 'Usar la caché',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'La mayoría de las estadisticas se pueden conservar en la caché. Esto acelera la presentación de esta estadística.',
        'Show as dashboard widget' => 'Mostrar como un elemento gráfico en el panel principal',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Proporcionar la estadística como un elemento gráfico que los agentes pueden activar en su panel principal.',
        'Please note' => 'Por favor, observe',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Habilitar el elemento gráfico en el panel principal activará el cacheo para esta estadística en el panel principal.',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            'Los agentes no podrán cambiar los ajustes de tiempo absoluto para los elementos de estadísticas del panel principal.',
        'IE8 doesn\'t support statistics dashboard widgets.' => 'IE8 no admite elementos de estadísticas en el panel principal.',
        'If set to invalid end users can not generate the stat.' => 'Si se establece a un valor no válido los usuarios finales no pueden generar la estadística.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Aquí puede definir la serie de valores.',
        'You have the possibility to select one or two elements.' => 'Tiene la posibilidad de seleccionar uno o dos elementos.',
        'Then you can select the attributes of elements.' => 'Después puede seleccionar los atributos de los elementos.',
        'Each attribute will be shown as single value series.' => 'Cada elemento se mostrará como una única serie de valores.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Si no selecciona ningún atributo, se usarán todos los atributos del elemento al generar una estadística, así como los nuevos atributos que se hayan añadido desde la última configuración.',
        'Scale' => 'Escala',
        'minimal' => 'mínimo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Recuerde, la escala para la serie de valores debe ser mayor que la escala para el eje-X (ej: eje-X => Mes, SerieValores => Año).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Aquí puede definir el eje X. Puede seleccionar un elemento por medio del botón de selección excluyente.',
        'maximal period' => 'periodo máximo',
        'minimal scale' => 'escala mínima',

        # Template: AgentStatsImport
        'Import Stat' => 'Importar estadística',
        'File is not a Stats config' => 'El fichero no es una configuración de estadísticas',
        'No File selected' => 'No se ha seleccionado ningún fichero',

        # Template: AgentStatsOverview
        'Stats' => 'Estadísticas',

        # Template: AgentStatsPrint
        'No Element selected.' => 'No hay ningún elemento seleccionado',

        # Template: AgentStatsView
        'Export config' => 'Exportar la configuración',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Con los campos de entrada y selección puede influir en el formato y contenido de la estadístca.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Los campos y formatos en los que puede influir están definidos por el administrador de la estadística.',
        'Stat Details' => 'Detalles de la estadística',
        'Format' => 'Formato',
        'Graphsize' => 'Tamaño de la gráfica',
        'Cache' => 'Caché',
        'Exchange Axis' => 'Intercambiar los ejes',

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Parámetros configurables de estadística estática',
        'No element selected.' => 'No hay seleccionado ningún elemento',
        'maximal period from' => 'periodo máximo desde',
        'to' => 'hasta',
        'not changable for dashboard statistics' => 'no modificable para estadísticas del panel principal',
        'Select Chart Type' => 'Seleccionar Tipo de Gráfico',
        'Chart Type' => 'Tipo de Gráfico',
        'Multi Bar Chart' => 'Gráfico Multi Barra',
        'Multi Line Chart' => 'Gráfico Multi Linea',
        'Stacked Area Chart' => 'Gráfico de Área Apilada',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Cambiar el texto libre del ticket',
        'Change Owner of Ticket' => 'Cambiar el propietario del ticket',
        'Close Ticket' => 'Cerrar el ticket',
        'Add Note to Ticket' => 'Añadir una nota al ticket',
        'Set Pending' => 'Establecer como pendiente',
        'Change Priority of Ticket' => 'Cambiar la prioridad del ticket',
        'Change Responsible of Ticket' => 'Cambiar el responsable del ticket',
        'All fields marked with an asterisk (*) are mandatory.' => 'Todos los campos marcados con un asterisco (*) son obligatorios.',
        'Service invalid.' => 'Servicio no válido',
        'New Owner' => 'Nuevo propietario',
        'Please set a new owner!' => 'Por favor, introduzca un nuevo propietario.',
        'Previous Owner' => 'Propietario anterior',
        'Next state' => 'Siguiente estado',
        'For all pending* states.' => 'Para todos los estados pendientes*.',
        'Add Article' => 'Añadir Artículo',
        'Create an Article' => 'Crear un Artículo',
        'Spell check' => 'Verificar la ortografía',
        'Text Template' => 'Plantilla de texto',
        'Setting a template will overwrite any text or attachment.' => 'Establecer una plantilla sobreescribirá cualquier texto o adjunto.',
        'Note type' => 'Tipo de nota',
        'Inform Agent' => 'Informar al agente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Informar a los agentes involucrados',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Aquí puede seleccionar agentes adicionales que deben recibir una notificación sobre el nuevo artículo.',
        'Note will be (also) received by:' => 'La nota será recibida (también) por:',

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Rebotar el ticket',
        'Bounce to' => 'Rebotar a',
        'You need a email address.' => 'Necesita una dirección de correo electrónico.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Necesita una dirección de correo válida, o no use una dirección de correo local.',
        'Next ticket state' => 'Nuevo estado del ticket',
        'Inform sender' => 'Informar al remitente',
        'Send mail' => 'Enviar correo',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Acción en Bloque con Tickets',
        'Send Email' => 'Enviar correo',
        'Merge to' => 'Fusionar con',
        'Invalid ticket identifier!' => 'Identificador de ticket no válido',
        'Merge to oldest' => 'Fusionar con el mas antiguo',
        'Link together' => 'Enlazar juntos',
        'Link to parent' => 'Enlazar al padre',
        'Unlock tickets' => 'Desbloquear los tickets',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Redactar una respuesta para el ticket',
        'Please include at least one recipient' => 'Incluya al menos un destinatario',
        'Remove Ticket Customer' => 'Eliminar el cliente del ticket',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Elimine esta entrada e introduzca una nueva con el valor correcto.',
        'Remove Cc' => 'Eliminar Cc',
        'Remove Bcc' => 'Eliminar Bcc',
        'Address book' => 'Libreta de direcciones',
        'Date Invalid!' => '¡Fecha no válida!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Cambiar el cliente del ticket',
        'Customer user' => 'Usuario del cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Crear un nuevo ticket por correo electrónico',
        'Example Template' => 'Ejemplo Plantilla',
        'From queue' => 'De la cola',
        'To customer user' => 'Al usuario cliente',
        'Please include at least one customer user for the ticket.' => 'Por favor, incluya al menos un usuario cliente para el ticket.',
        'Select this customer as the main customer.' => 'Seleccionar a este cliente como el cliente principal.',
        'Remove Ticket Customer User' => 'Eliminar el usuario cliente del ticket',
        'Get all' => 'Obtener todo',
        'Do you really want to continue?' => '',

        # Template: AgentTicketEmailOutbound
        'E-Mail Outbound' => 'E-Mail Saliente',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: tiempo de primera respuesta ha sido excedido (%s%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: tiempo de primera respuesta será excedido en %s%s!',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: tiempo de actualización será excedido en %s%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: tiempo de resolución ha sido excedido (%s%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: tiempo de resolución será excedido en %s%s!',

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Reenviar el ticket: %s - %s',

        # Template: AgentTicketHistory
        'History of' => 'Historial de',
        'History Content' => 'Contenido del historial',
        'Zoom view' => 'Vista ampliada',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Fusionar el ticket',
        'You need to use a ticket number!' => '¡Es necesario usar un número de ticket!',
        'A valid ticket number is required.' => 'Se requiere un número de ticket válido.',
        'Need a valid email address.' => 'Se requiere una dirección de correo electrónico válida.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Mover el ticket',
        'New Queue' => 'Nueva cola',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Seleccionar todo',
        'No ticket data found.' => 'No se encontraron datos del ticket.',
        'Select this ticket' => 'Seleccionar este ticket',
        'First Response Time' => 'Tiempo para primera respuesta',
        'Update Time' => 'Tiempo para actualización',
        'Solution Time' => 'Tiempo para solución',
        'Move ticket to a different queue' => 'Mover el ticket a otra cola',
        'Change queue' => 'Cambiar de cola',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Cambiar las opciones de búsqueda',
        'Remove active filters for this screen.' => 'Eliminar los filtros activos para esta pantalla.',
        'Tickets per page' => 'Tickets por página',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Restablecer la vista general',
        'Column Filters Form' => 'Formulario de filtros de columna',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Dividir En Nuevo Ticket Telefónico',
        'Save Chat Into New Phone Ticket' => 'Guardar Chat En Nuevo Ticket Telefónico',
        'Create New Phone Ticket' => 'Crear un nuevo ticket telefónico',
        'Please include at least one customer for the ticket.' => 'Incluya al menos un cliente para el ticket',
        'To queue' => 'A la cola',
        'Chat protocol' => 'Protocolo chat',
        'The chat will be appended as a separate article.' => 'El chat se agregará como un artículo separado.',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Vista del correo en texto plano',
        'Plain' => 'Texto plano',
        'Download this email' => 'Descargar este correo',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Información del ticket',
        'Accounted time' => 'Tiempo contabilizado',
        'Linked-Object' => 'Objeto enlazado',
        'by' => 'por',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Crear un nuevo ticket de proceso',
        'Process' => 'Proceso',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Registrar Ticket en un Proceso',

        # Template: AgentTicketSearch
        'Search template' => 'Plantilla de búsqueda',
        'Create Template' => 'Crear plantilla',
        'Create New' => 'Crear nueva',
        'Profile link' => 'Enlace al perfil',
        'Save changes in template' => 'Guardar los cambios de la plantilla',
        'Filters in use' => 'Filtros en uso',
        'Additional filters' => 'Filtros adicionales',
        'Add another attribute' => 'Añadir otro atributo',
        'Output' => 'Formato del resultado',
        'Fulltext' => 'Texto completo',
        'Remove' => 'Eliminar',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Busca en los atributos De, Para, Cc, Asunto y el cuerpo del artículo, ignorando otros atributos con el mismo nombre.',
        'Customer User Login' => 'Nombre de usuario del cliente',
        'Attachment Name' => 'Nombre Adjunto',
        '(e. g. m*file or myfi*)' => '(ej. m*archivo or miar*)',
        'Created in Queue' => 'Creado en la cola',
        'Lock state' => 'Estado bloqueado',
        'Watcher' => 'Vigilante',
        'Article Create Time (before/after)' => 'Hora de creación del artículo (antes/después)',
        'Article Create Time (between)' => 'Hora de creación del artículo (entre)',
        'Ticket Create Time (before/after)' => 'Hora de creación del ticket (antes/después)',
        'Ticket Create Time (between)' => 'Hora de creación del ticket (entre)',
        'Ticket Change Time (before/after)' => 'Hora de modificación del ticket (antes/después)',
        'Ticket Change Time (between)' => 'Hora de modificación del ticket (entre)',
        'Ticket Last Change Time (before/after)' => 'Tiempo Último Cambio Ticket (antes/después)',
        'Ticket Last Change Time (between)' => 'Tiempo Último Cambio Ticket (entre)',
        'Ticket Close Time (before/after)' => 'Hora de cierre del ticket (antes/después)',
        'Ticket Close Time (between)' => 'Hora de cierre del ticket (entre)',
        'Ticket Escalation Time (before/after)' => 'Hora de escalada del ticket (antes/después)',
        'Ticket Escalation Time (between)' => 'Hora de escalada del ticket (entre)',
        'Archive Search' => 'Guardar la búsqueda',
        'Run search' => 'Ejecutar la búsqueda',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro de artículos',
        'Article Type' => 'Tipo de artículo',
        'Sender Type' => 'Tipo de remitente',
        'Save filter settings as default' => 'Guardar los ajustes del filtro como predeterminados',
        'Event Type Filter' => 'Filtro Tipo Evento',
        'Event Type' => 'Tipo Evento',
        'Save as default' => 'Guardar como Por Defecto',
        'Archive' => 'Archivar',
        'This ticket is archived.' => 'Este ticket está archivado.',
        'Locked' => 'Bloqueo',
        'Linked Objects' => 'Objetos enlazados',
        'Change Queue' => 'Cambiar de cola',
        'There are no dialogs available at this point in the process.' =>
            'No hay diálogos disponibles en este punto del proceso.',
        'This item has no articles yet.' => 'Este elemento todavía no tiene ningún artículo.',
        'Ticket Timeline View' => 'Vista Linea Temporal de Ticket',
        'Article Overview' => 'Vista General Artículo',
        'Article(s)' => 'Artículo(s)',
        'Page' => 'Página',
        'Add Filter' => 'Añadir un filtro',
        'Set' => 'Establecer',
        'Reset Filter' => 'Restablecer el filtro',
        'Show one article' => 'Mostrar un artículo',
        'Show all articles' => 'Mostrar todos los artículos',
        'Show Ticket Timeline View' => 'Mostrar Vista Linea Temporal de Ticket',
        'Unread articles' => 'Artículos no leídos',
        'No.' => 'Nº',
        'Important' => 'Importante',
        'Unread Article!' => 'Artículo no leído',
        'Incoming message' => 'Mensaje entrante',
        'Outgoing message' => 'Mensaje saliente',
        'Internal message' => 'Mensaje interno',
        'Resize' => 'Redimensionar',
        'Mark this article as read' => 'Marcar este artículo como leído',
        'Show Full Text' => 'Mostrar Texto Completo',
        'Full Article Text' => 'Texto Artículo Completo',
        'No more events found. Please try changing the filter settings.' =>
            'No se encontraron más eventos. Por favor pruebe cambiando los ajustes de filtro.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Para abrir enlaces en el siguiente artículo, es posible que tenga que pulsar Ctrl o Cmd o Shift mientras hace clic en el enlace (dependiendo de su navegador y sistema operativo ). ',
        'Close this message' => 'Cerrar este mensaje',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'El artículo no se pudo abrir! Tal vez sea en otro artículo de la página?',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Para proteger su privacidad, se bloqueó el contenido remoto.',
        'Load blocked content.' => 'Cargar el contenido remoto.',

        # Template: ChatStartForm
        'First message' => 'Primer mensaje',

        # Template: CustomerError
        'Traceback' => 'Traza inversa',

        # Template: CustomerFooter
        'Powered by' => 'Funciona con',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => '¡Se han producido uno o más errores!',
        'Close this dialog' => 'Cerrar este diálogo',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'No fue posible abrir una ventana emergente.  Inhabilite los bloqueadores de ventanas emergentes para esta aplicacíon.',
        'There are currently no elements available to select from.' => 'Actualmente no hay elementos disponibles que seleccionar.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Por favor apague el Modo Compatibilidad en Internet Explorer!',
        'The browser you are using is too old.' => 'El navegador que está usando es demasiado antiguo.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS funciona con un gran número de navegadores, por favor, actulícese a uno de ellos.',
        'Please see the documentation or ask your admin for further information.' =>
            'Para más información, consulte la documentación o pregunte a su administrador.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript no disponible',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Para utilizar OTRS, necesitará habilitar JavaScript en su navegador.',
        'Browser Warning' => 'Advertencia del navegador',
        'One moment please, you are being redirected...' => 'Un momento por favor, está siendo redirigido...',
        'Login' => 'Inicio de sesión',
        'User name' => 'Nombre de usuario',
        'Your user name' => 'Su nombre de usuario',
        'Your password' => 'Su contraseña',
        'Forgot password?' => '¿Olvidó su contraseña?',
        'Log In' => 'Iniciar sesión',
        'Not yet registered?' => '¿Todavía no está registrado?',
        'Request new password' => 'Solicitar una nueva contraseña',
        'Your User Name' => 'Su nombre de usuario',
        'A new password will be sent to your email address.' => 'Se le enviará una nueva contraseña a su dirección de correo electrónico.',
        'Create Account' => 'Crear una cuenta',
        'Please fill out this form to receive login credentials.' => 'Rellene este formulario para recibir las credenciales de inicio de sesión.',
        'How we should address you' => 'Cómo debemos dirigirnos a usted',
        'Your First Name' => 'Su nombre',
        'Your Last Name' => 'Su apellido',
        'Your email address (this will become your username)' => 'Su dirección de correo electrónico (esto será su nombre de usuario)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Petición de Chat Entrante',
        'You have unanswered chat requests' => 'Tienes peticiones de chat sin responder',
        'Edit personal preferences' => 'Editar las preferencias personales',
        'Logout %s %s' => 'Cerrar Sesión %s %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'Dividir Cita',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Acuerdo de nivel de servicio',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bienvenido',
        'Please click the button below to create your first ticket.' => 'Pulse el botón inferior para crear su primer ticket.',
        'Create your first ticket' => 'Cree su primer ticket',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Imprimir el ticket',
        'Ticket Dynamic Fields' => 'Campos dinámicos del ticket',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'ej: 10*5155 or 105658*',
        'Customer ID' => 'ID del cliente',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Búsqueda de texto completo en los tickets (vg «Juan*n» o «Guillermo*»)',
        'Carbon Copy' => 'Copia carbón',
        'e. g. m*file or myfi*' => 'ej. m*archivo o miar*',
        'Types' => 'Tipos',
        'Time restrictions' => 'Restricciones de tiempo',
        'No time settings' => 'Sin ajustes de tiempo',
        'Only tickets created' => 'Sólo los tickets creados',
        'Only tickets created between' => 'Sólo los tickets creados entre',
        'Ticket archive system' => 'Sistema de archivo de tickets',
        'Save search as template?' => '¿Guardar la búsqueda como una plantilla?',
        'Save as Template?' => '¿Guardar como plantilla?',
        'Save as Template' => 'Guardar como plantilla',
        'Template Name' => 'Nombre de la plantilla',
        'Pick a profile name' => 'Elija un nombre de perfil',
        'Output to' => 'Formato de salida',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Search Results for' => 'Resultados de la búsqueda de',
        'Remove this Search Term.' => 'Elimine este Termino de Búsqueda.',

        # Template: CustomerTicketZoom
        'Expand article' => 'Expandir el artículo',
        'Next Steps' => 'Siguientes pasos',
        'Reply' => 'Contestar',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'Todo el Día',
        'Sunday' => 'Domingo',
        'Monday' => 'Lunes',
        'Tuesday' => 'Martes',
        'Wednesday' => 'Miércoles',
        'Thursday' => 'Jueves',
        'Friday' => 'Viernes',
        'Saturday' => 'Sábado',
        'Su' => 'Do',
        'Mo' => 'Lu',
        'Tu' => 'Ma',
        'We' => 'Mi',
        'Th' => 'Ju',
        'Fr' => 'Vi',
        'Sa' => 'Sá',
        'Event Information' => 'Información del evento',
        'Ticket fields' => 'Campos del ticket',
        'Dynamic fields' => 'Campos dinámicos',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Fecha no válida (se necesita una fecha futura)',
        'Invalid date (need a past date)!' => 'Fecha inválida (necesaria fecha pasada)!',
        'Previous' => 'Anterior',
        'Open date selection' => 'Abrir selección de fecha',

        # Template: Error
        'Oops! An Error occurred.' => '¡Ups! Se ha producido un error.',
        'You can' => 'Puede',
        'Send a bugreport' => 'Enviar un informe de error',
        'go back to the previous page' => 'retroceder a la página anterior',
        'Error Details' => 'Detalles del error',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Si deja esta página ahora, también se cerrarán todas las ventanas emergentes abiertas.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Ya está abierta una ventana emergente de esta pantalla. ¿Desea cerrarla y cargar ésta en su lugar?',
        'Please enter at least one search value or * to find anything.' =>
            'Introduzca al menos un valor de búsqueda, o * para buscar todo.',
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Por favor elimine las siguientes palabras de su búsqueda pues ellas no pueden ser buscadas por:',
        'Please check the fields marked as red for valid inputs.' => 'Compruebe que los campos marcados en rojo tienen datos válidos.',
        'Please perform a spell check on the the text first.' => 'Por favor ejecute una comprobación ortográfica en el texto primero.',
        'Slide the navigation bar' => 'Deslice la barra de navegación',

        # Template: Header
        'You are logged in as' => 'Ha iniciado sesión como',
        'There are new chat requests available. Please visit the chat manager.' =>
            'Hay nuevas peticiones de chat disponibles. Por favor visite el manager de chat.',

        # Template: Installer
        'JavaScript not available' => 'JavaScript no disponible',
        'Database Settings' => 'Ajustes de la base de datos',
        'General Specifications and Mail Settings' => 'Indicaciones generales y ajustes del correo',
        'Welcome to %s' => 'Bienvenido a %s',
        'Web site' => 'Sitio web',
        'Mail check successful.' => 'Se ha verificado el correo con éxito.',
        'Error in the mail settings. Please correct and try again.' => 'Error en los ajustes del correo. Corríjalos e inténtelo de nuevo.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurar el correo saliente',
        'Outbound mail type' => 'Tipo de correo saliente',
        'Select outbound mail type.' => 'Seleccionar el tipo de correo saliente',
        'Outbound mail port' => 'Puero del correo saliente',
        'Select outbound mail port.' => 'Seleccionar el puerto del coreo saliente',
        'SMTP host' => 'Servidor SMTP',
        'SMTP host.' => 'Servidor SMTP.',
        'SMTP authentication' => 'Autenticación SMTP',
        'Does your SMTP host need authentication?' => '¿Su servidor SMTP necesita autenticación?',
        'SMTP auth user' => 'Usuario para la autenticación SMTP',
        'Username for SMTP auth.' => 'Nombre de usuario para la autenticación SMTP.',
        'SMTP auth password' => 'Contraseña para la autenticación SMTP',
        'Password for SMTP auth.' => 'Contraseña para la autenticación SMTP.',
        'Configure Inbound Mail' => 'Configurar el correo entrante',
        'Inbound mail type' => 'Tipo de correo entrante',
        'Select inbound mail type.' => 'Seleccionar el tipo de correo entrante.',
        'Inbound mail host' => 'Servidor de correo entrante',
        'Inbound mail host.' => 'Servidor de correo entrante.',
        'Inbound mail user' => 'Usuario de correo entrante',
        'User for inbound mail.' => 'Usuario para el correo entrante',
        'Inbound mail password' => 'Contraseña para el correo entrante',
        'Password for inbound mail.' => 'Contraseña para el correo entrante.',
        'Result of mail configuration check' => 'Resultado de la verificación de la configuración del correo',
        'Check mail configuration' => 'Comprobar la configuración del correo',
        'Skip this step' => 'Omitir este paso',

        # Template: InstallerDBResult
        'Database setup successful!' => '¡Base de datos configurada con éxito!',

        # Template: InstallerDBStart
        'Install Type' => 'Tipo de instalación',
        'Create a new database for OTRS' => 'Crear una nueva base de datos para OTRS',
        'Use an existing database for OTRS' => 'Usar una base de datos existente para OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Nombre de la base de datos',
        'Check database settings' => 'Verificar los ajustes de la base de datos',
        'Result of database check' => 'Resultado de la verificación de la base de datos',
        'Database check successful.' => 'Se ha verificado la base de datos con éxito.',
        'Database User' => 'Usuario de la base de datos',
        'New' => 'Nuevo',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Se creará un nuevo usuario de la base de datos con permisos limitados para este sistema OTRS.',
        'Repeat Password' => 'Repita la contraseña',
        'Generated password' => 'Contraseña generada',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Las contraseñas no coinciden',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Puerto',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para poder utilizar OTRS debe escribir la siguiente línea en la consola de sistema (Terminal/Shell) como usuario root',
        'Restart your webserver' => 'Reinicie su servidor web',
        'After doing so your OTRS is up and running.' => 'Después de hacer esto, su OTRS estará activo y ejecutándose',
        'Start page' => 'Página de inicio',
        'Your OTRS Team' => 'Su equipo OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'No aceptar la licencia',
        'Accept license and continue' => 'Aceptar la licencia y continuar',

        # Template: InstallerSystem
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'El identificador del sistema. Cada número de ticket y cada identificador de sesión HTTP contienen este número.',
        'System FQDN' => 'FQDN del sistema',
        'Fully qualified domain name of your system.' => 'Nombre de dominio totalmente cualificado de su sistema.',
        'AdminEmail' => 'Correo del administrador.',
        'Email address of the system administrator.' => 'Dirección de correo electrónico del administrador del sistema.',
        'Organization' => 'Organización',
        'Log' => 'Registro',
        'LogModule' => 'Módulo de registro',
        'Log backend to use.' => 'Motor de registro a usar.',
        'LogFile' => 'Fichero de registro',
        'Webfrontend' => 'Interfaz web',
        'Default language' => 'Idioma predeterminado',
        'Default language.' => 'Idioma predeterminado.',
        'CheckMXRecord' => 'Verificar los registros MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Las direcciones de correo introducidas manualmente se verifican contra los registros MX encontrados en el DNS. No utilice esta opción si su DNS es lento o no resuelve direcciones públicas.',

        # Template: LinkObject
        'Object#' => 'Objeto nº',
        'Add links' => 'Añadir enlaces',
        'Delete links' => 'Borrar enlaces',

        # Template: Login
        'Lost your password?' => '¿Perdió su contraseña?',
        'Request New Password' => 'Solicitar nueva contraseña',
        'Back to login' => 'Volver al inicio de sesión',

        # Template: Motd
        'Message of the Day' => 'Mensaje del día',

        # Template: NoPermission
        'Insufficient Rights' => 'Derechos insuficientes',
        'Back to the previous page' => 'Volver a la página anterior',

        # Template: Pagination
        'Show first page' => 'Mostrar la primera página',
        'Show previous pages' => 'Mostrar las páginas anteriores',
        'Show page %s' => 'Mostrar la página %s',
        'Show next pages' => 'Mostrar las siguientes páginas',
        'Show last page' => 'Mostrar la última página',

        # Template: PictureUpload
        'Need FormID!' => 'Se necesita el identificador del formulario',
        'No file found!' => 'No se encontró ningún fichero.',
        'The file is not an image that can be shown inline!' => 'Este fichero no es una imagen que se pueda mostrar.',

        # Template: PrintHeader
        'printed by' => 'impreso por',

        # Template: Test
        'OTRS Test Page' => 'Página de prueba de OTRS',
        'Welcome %s %s' => 'Bienvenido %s %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Volver a la página anterior',

        # SysConfig
        ' (work units)' => '(unidades de trabajo)',
        '"%s"-notification sent to "%s".' => '"%s"-notificación enviada a «%s».',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s unidad(es) de tiempo contabilizadas. Total ahora: %s unidad(es) de tiempo.',
        '(UserLogin) Firstname Lastname' => '(LoginUsuario) Nombre Apellidos',
        '(UserLogin) Lastname, Firstname' => '(LoginUsuario) Apellidos, Nombre ',
        'A Website' => 'Un Sitio Web',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Una lista de los campos dinámicos que se fusionó con el ticket principal durante una operación de combinación. Sólo los campos dinámicos que están vacíos en el ticket principal se establecerán.',
        'A picture' => 'Una foto',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite el cierre detickets padre sólo si todos sus hijos ya están cerrados ("Estado" muestra que estados no están disponibles para ticket padre hasta que todas las entradas de sus hijos están cerradas).',
        'Access Control Lists (ACL)' => 'Listas Control Acceso (ACL)',
        'AccountedTime' => 'Tiempo Registrado',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Activa un mecanismo de parpadeo de la cola que contiene el ticket más antiguo.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Activa la función perdida de contraseña para los agentes, en la interfaz del agente.',
        'Activates lost password feature for customers.' => 'Activa la función perdida de contraseña para los clientes.',
        'Activates support for customer groups.' => 'Activa soporte para grupos de clientes.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Activa el filtro de artículo en la vista de zoom para especificar qué artículos se deben mostrar.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Activa los temas disponibles en el sistema. Valor 1 significa activo, 0 significa inactivo.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Activa la búsqueda de sistema de archivo de tickets en la interfaz del cliente.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Activa el sistema de archivo de ticket para tener un sistema más rápido, moviendo algunos tickets fuera del ámbito cotidiano. Para buscar estos tickets, la bandera de archivo tiene que estar activada en la búsqueda de tickets .',
        'Activates time accounting.' => 'Activa la contabilidad del tiempo.',
        'ActivityID' => 'IDActividad',
        'Added email. %s' => 'Correo añadido. %s',
        'Added link to ticket "%s".' => 'Añadido enlace al ticket «%s».',
        'Added note (%s)' => 'Nota añadida (%s)',
        'Added subscription for user "%s".' => 'Añadida suscripción para el usuario «%s».',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Añade un sufijo con el año y mes actual para el archivo de registro de OTRS. Se creará un archivo de registro para cada mes .',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Añade direcciones de correo electrónico de clientes  a los destinatarios en la pantalla de composición de ticket de la interfaz del agente. No se añadirá la dirección de correo electrónico de los clientes si el tipo de artículo es email-interno.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones en un tiempo para el calendario indicado . Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09 ).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones en un tiempo. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09 ).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones permanentes para el calendario indicado . Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09 ).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Añade los días de vacaciones permanentes. Por favor, utilice el patrón de un solo dígito para los números del 1 al 9 (en lugar de 01 - 09 ).',
        'Agent Notifications' => 'Notificaciones de Agente',
        'Agent called customer.' => 'El agente llamó al cliente.',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificación de artículo de la interfaz de agente para verificar PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificación de artículo de la interfaz de agente para verificar S/MIME.',
        'Agent interface module to access CIC search via nav bar.' => 'Módulo de la interfaz de agente para acceder a la búsqueda CIC vía la barra de navegación.',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Módulo de la interfaz de agente para acceder a la búsqueda de texto completo vía la barra de navegación.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Módulo de la interfaz de agente para acceder a la búsqueda de perfiles vía la barra de navegación.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo de la interfaz de agente para comprobar los correos entrantes en la Vista-Zoom-Ticket si la clave S/MIME está disponible y es verdadera.',
        'Agent interface notification module to see the number of locked tickets.' =>
            'Módulo de notificación de la interfaz de agente para ver el número de tickets bloqueados.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Módulo de notificación de la interfaz de agente para ver el número de tickets de los que un agente es responsable.',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            'Módulo de notificación de la interfaz de agente para ver el número de tickets en Mis Servicios.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Módulo de notificación de la interfaz de agente para ver el número de tickets vistos.',
        'Agents <-> Groups' => 'Agentes <-> Grupos',
        'Agents <-> Roles' => 'Agentes <-> Roles',
        'All customer users of a CustomerID' => 'Todos los clientes de un IDCliente',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla de ticket cerrado de la interfaz de agente. Puede sobrescribirse por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla texto libre de ticket de la interfaz de agente. Puede sobrescribirse por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla nota de ticket de la interfaz de agente. Puede sobrescribirse por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla propietario de ticket de un ticket ampliado en la interfaz de agente. Puede sobrescribirse por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla de ticket pendiente de un ticket ampliado en la interfaz de agente. Puede sobrescribirse por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla prioridad de ticket de un ticket ampliado en la interfaz de agente. Puede sobrescribirse por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla responsable de ticket de la interfaz de agente. Puede sobrescribirse por Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permite a los agentes intercambiar el eje de una estadística si generan una.',
        'Allows agents to generate individual-related stats.' => 'Permite a los agentes generar estadísticas individualmente relacionadas .',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permite elegir entre mostrar los archivos adjuntos de un ticket en el navegador (en línea) o simplemente hacerlos descargables (archivo adjunto) .',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permite elegir el siguiente estado de composición para los tickets de los clientes en la interfaz del cliente.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permite a los clientes cambiar la prioridad de ticket en la interfaz del cliente.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permite a los clientes establecer el SLA de ticket en la interfaz del cliente.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permite a los clientes establecer la prioridad de ticket en la interfaz de cliente.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Permite a los clientes establecer la cola de ticket en la interfaz del cliente. Si se establece a \'No\', la ColaPorDefecto debe ser configurada.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permite a los clientes establecer el servicio de ticket en la interfaz del cliente.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Permite a los clientes establecer el tipo de ticket en la interfaz del cliente. Si se establece a \'No\', TipoTicketPorDefecto debe estar configurado.',
        'Allows default services to be selected also for non existing customers.' =>
            'Permito que los servicios por defecto sean seleccionados también por clientes no existentes.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permite definir nuevos tipos para ticket (si la función tipo de ticket está habilitada).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir servicios y SLAs para los tickets (ej. email, escritorio, red...), y los atributos de escalado para los SLAs (si la función servicio/SLA de ticket está activada).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite condiciones de búsqueda extendidas en búsqueda de ticket de la interfaz de agente. Con esta función, puede buscar ej . con este tipo de condiciones como "( key1 && key2 )" o "(key1 || key2 )".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite condiciones de búsqueda extendidas en búsqueda de ticket de la interfaz de cliente. Con esta función, puede buscar ej. con este tipo de condiciones como "( key1 && key2 )" o "( key1 || key2 )".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite tener un formato medio de la vista general de ticket (InfoCliente => 1 - muestra también la información de cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite tener un formato pequeño de la vista general de ticket (InfoCliente => 1 - muestra también la información de cliente).',
        'Allows invalid agents to generate individual-related stats.' => 'Permite a agentes no válidos el generar estadísticas relacionadas individualmente.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Permite a los administradores el acceso como otros clientes, vía el panel de administración del usuario cliente.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permite a los administradores el acceso como otros clientes, vía el panel de administración de usuario.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permite establecer un nuevo estado de ticket en la pantalla mover ticket de la interfaz de agente.',
        'Archive state changed: "%s"' => 'Cambiado el estado del archivo: «%s»',
        'ArticleTree' => 'Árbol de Artículos',
        'Attachments <-> Templates' => 'Adjuntos <-> Plantillas',
        'Auto Responses <-> Queues' => 'Respuestas Automáticas <-> Colas',
        'AutoFollowUp sent to "%s".' => 'Seguimiento automático enviado a «%s».',
        'AutoReject sent to "%s".' => 'Rechazo automático enviado a «%s».',
        'AutoReply sent to "%s".' => 'Respuesta automática enviada a «%s».',
        'Automated line break in text messages after x number of chars.' =>
            'Salto de linea automático en mensajes de texto después de x número de caracteres.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Automáticamente bloqueado y establecido propietario el Agente actual después de abrir la pantalla mover ticket de la interfaz de agente.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automáticamente bloqueado y establecido propietario el Agente actual después de seleccionar una Acción Masiva.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Automáticamente establece al propietario de un ticket como responsable del mismo (si la función resopnsable de ticket está habilitada).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Automáticamente establece al responsable de un ticket (si no está establecido aún) después de la primera actualización de propietario.',
        'Balanced white skin by Felix Niklas (slim version).' => 'Apariencia blanca equilibrada por Felix Niklas (version slim).',
        'Balanced white skin by Felix Niklas.' => 'Apariencia blanca equilibrada por Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Ajustes básicos de indice de texto completo. Ejecute "bin/otrs.RebuildFulltextIndex.pl" para generar un nuevo índice.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'Rebotado a «%s».',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
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
        'Change password' => 'Cambiar Contraseña',
        'Change queue!' => '',
        'Change the customer for this ticket' => 'Cambiar el cliente de este ticket',
        'Change the free fields for this ticket' => 'Cambiar los campos libres de este ticket',
        'Change the priority for this ticket' => 'Cambiar la prioridad de este ticket',
        'Change the responsible person for this ticket' => 'Cambiar la persona responsable de este ticket',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Cambiada prioridad de «%s» (%s) a «%s» (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Comment2' => '',
        'Company Status' => '',
        'Company Tickets' => 'Tickets de Compañía',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => 'Crea Nuevo ticket de proceso',
        'Create and manage Service Level Agreements (SLAs).' => 'Crea y gestiona Acueros de Nivel de Servicio (SLAs)',
        'Create and manage agents.' => 'Crea y gestiona agentes',
        'Create and manage attachments.' => 'Crea y gestiona Adjuntos',
        'Create and manage customer users.' => 'Crea y gestiona usuarios clientes.',
        'Create and manage customers.' => 'Crea y gestiona clientes',
        'Create and manage dynamic fields.' => 'Crea y gestiona campos dinámicos',
        'Create and manage event based notifications.' => 'Crea y gestiona notificaciones basadas en eventos.',
        'Create and manage groups.' => 'Crea y gestiona grupos.',
        'Create and manage queues.' => 'Crea y gestiona colas.',
        'Create and manage responses that are automatically sent.' => 'Crea y gestiona las respuestas enviadas automáticamente.',
        'Create and manage roles.' => 'Crea y gestiona roles.',
        'Create and manage salutations.' => 'Crea y gestiona Saludos.',
        'Create and manage services.' => 'Crea y gestiona servicios.',
        'Create and manage signatures.' => 'Crea y gestiona firmas.',
        'Create and manage templates.' => 'Crea y gestiona plantillas.',
        'Create and manage ticket priorities.' => 'Crea y gestiona prioridades de tickets.',
        'Create and manage ticket states.' => 'Crea y gestiona estado de los tickets.',
        'Create and manage ticket types.' => 'Crea y gestiona tipos de tickets.',
        'Create and manage web services.' => 'Crea y gestiona servicios web.',
        'Create new email ticket and send this out (outbound)' => 'Crear nuevo ticket por correo y enviarlo (saliente)',
        'Create new phone ticket (inbound)' => 'Crear nuevo ticket telefónico (entrante)',
        'Create new process ticket' => 'Crea nuevo ticket de proceso',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Administración de Clientes',
        'Customer User <-> Groups' => 'Usuario Cliente <-> Grupos',
        'Customer User <-> Services' => 'Usuario Cliente <-> Servicios',
        'Customer User Administration' => 'Administración de los usuarios cliente',
        'Customer Users' => 'Clientes',
        'Customer called us.' => 'El cliente nos llamó.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer request via web.' => 'Solicitud de cliente vía web.',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'Customers <-> Groups' => '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
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
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines scheduler PID update time in seconds.' => '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the legend font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of possible next actions on an error screen.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the title font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Deleted link to ticket "%s".' => 'Eliminado enlace al ticket «%s».',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
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
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
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
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'Direcciones de Correo',
        'Email sent to "%s".' => 'Correo enviado a «%s».',
        'Email sent to customer.' => 'Correo enviado al cliente.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Enroll this ticket into a process' => '',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => 'Vista de escalados',
        'EscalationTime' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
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
        'Execute SQL statements.' => '',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => '',
        'First Queue' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'FollowUp for [%s]. %s' => 'Seguimiento para [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'Reenviado a «%s».',
        'Frontend language' => 'Idioma de la interfaz',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Tema de la interfaz',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => 'AgenteGenérico',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
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
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Si se habilita, las diferentes vistas generales (panel principal, vista de bloqueados, vista de colas) se actualizarán automáticamente tras el tiempo indicado.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Idioma de la interfaz',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Left' => '',
        'Link agents to groups.' => 'Crea enlace de Agentes a Grupos',
        'Link agents to roles.' => 'Crea enlace de Agentes a Roles',
        'Link attachments to templates.' => 'Crea enlace de Adjuntos a Plantillas',
        'Link customer user to groups.' => 'Crea enlace de Usuarios Clientes a Grupos',
        'Link customer user to services.' => 'Crea enlace de Usuarios Clientes a Servicios.',
        'Link queues to auto responses.' => 'Crea enlace de Colas a Respuestas Automáticas',
        'Link roles to groups.' => 'Crea enlace de Roles a Grupos.',
        'Link templates to queues.' => 'Crea enlace de Plantillas a Colas.',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'List view' => '',
        'Locked ticket.' => 'Ticket bloqueado.',
        'Log file for the ticket counter.' => '',
        'Loop-Protection! No auto-response sent to "%s".' => '¡Protección contra bucles! No se envió respuesta automática a «%s».',
        'Mail Accounts' => 'Cuentas de Correo',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage OTRS Group services.' => '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => '',
        'Manage notifications that are sent to agents.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Queues and My Services' => 'Mis Colas y Mis Servicios',
        'My Queues or My Services' => 'Mis Colas o Mis Servicios',
        'My Services' => 'Mis Servicios',
        'My Tickets' => 'Mis Tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Nuevo ticket [%s] creado (Q=%s;P=%s;S=%s).',
        'New Window' => '',
        'New email ticket' => 'Nuevo ticket por correo',
        'New owner is "%s" (ID=%s).' => 'El nuevo propietario es «%s» (ID=%s).',
        'New phone ticket' => 'Nuevo ticket telefónico',
        'New process ticket' => 'Nuevo ticket de Proceso',
        'New responsible is "%s" (ID=%s).' => 'El nuevo responsable es «%s» (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Siguiente estado posible del ticket después de agregar una nota en la pantalla de llamada telefónica entrante para la interfaz de agente.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Siguiente estado posible del ticket después de agregar una nota en la pantalla de llamada telefónica saliente para la interfaz de agente.',
        'No Notification' => 'Sin notificación',
        'None' => '',
        'Notification sent to "%s".' => 'Notificación enviada a «%s».',
        'Notifications (Event)' => 'Notificaciones (Event)',
        'Number of displayed tickets' => 'Número de tickets mostrados',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Old: "%s" New: "%s"' => 'Antiguo: "%s". Nuevo: "%s"',
        'Online' => 'En linea',
        'Open tickets (customer user)' => 'Tickets abiertos (usuario cliente)',
        'Open tickets (customer)' => 'Tickets abiertos (cliente)',
        'Out Of Office' => 'Fuera de la Oficina',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Vista general de los tickets escalados',
        'Overview Refresh Time' => 'Tiempo de actualización de la vista general',
        'Overview of all open Tickets.' => 'Vista general de todos los tickets abiertos.',
        'PGP Key Management' => 'Administración del Clave PGP',
        'PGP Key Upload' => 'Carga de Clave PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => 'Parametros para',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the ServiceUpdateNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => 'Carga de Foto',
        'PostMaster Filters' => 'Filtros de Correo Electrónico',
        'PostMaster Mail Accounts' => 'Cuentas de Correo Electrónico',
        'Process Information' => 'Información de Proceso',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'ProcessID' => 'ID de Proceso',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Vista por colas',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => 'Actualizar las vistas generales tras',
        'Refresh interval' => 'Intervalo de actualización',
        'Removed subscription for user "%s".' => 'Eliminada suscripción para el usuario «%s».',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles <-> Groups' => 'Roles <-> Grupos',
        'Running Process Tickets' => 'Corriendo Tickets de Proceso',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Carga de Certificado S/MIME',
        'Sample command output' => 'Ejemplo de comando de salida.',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Search Customer' => 'Búsqueda de un cliente',
        'Search User' => 'Buscar Usuario',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Second Queue' => 'Cola Secundaria',
        'Select your frontend Theme.' => 'Seleccione su tema',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my queues/services.' =>
            'Notificarme si un cliente hace un seguimiento de ticket y soy el propietario del ticket o el ticket esta desbloqueado y tambien esta en una de mis colas/mis servicios',
        'Send me a notification if the service of a ticket is changed to a service in "My Services" and the ticket is in a queue where I have read permissions.' =>
            'Notificarme si el servicio de un ticket es cambiado a un servicio en "Mis Servicios" y el ticket esta en una cola donde tengo permisos de lectura',
        'Send me a notification if there is a new ticket in my queues/services.' =>
            'Notificarme si hay un nuevo ticket en mis colas/servicios',
        'Send new ticket notifications if subscribed to' => '',
        'Send notifications to users.' => '',
        'Send service update notifications' => '',
        'Send ticket follow up notifications if subscribed to' => '',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Service update notification' => '',
        'Service view' => 'Vista de servicio',
        'Set sender email addresses for this system.' => '',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
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
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the size of the statistic graph.' => '',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Should the cache data be help in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows information on how to start OTRS Scheduler' => '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => 'Apariencia',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => 'Alguna descripción de imagen!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Estadística nº',
        'Statistics' => 'Estadísticas',
        'Status view' => 'Vista por estados',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'System Maintenance' => 'Mantenimiento de Sistema',
        'System Request (%s).' => 'Petición del sistema (%s).',
        'Templates <-> Queues' => 'Plantillas <-> Colas',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
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
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
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
            '',
        'Ticket Queue Overview' => 'Resumen de Tickets por Cola',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Ticket movido a la cola «%s» (%s) de la cola «%s» (%s).',
        'Ticket overview' => 'Vista general de tickets',
        'TicketNumber' => 'Número de Ticket',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => 'Título actualizado: Antiguo: «%s», Nuevo: «%s»',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Tree view' => 'Vista en árbol',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Ticket desbloqueado.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => '',
        'Updated SLA to %s (ID=%s).' => 'SLA actualizado a %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Servicio actualizado a %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Tipo actualizado a %s (ID=%s).',
        'Updated: %s' => 'Actualizado: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Actualizado: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => 'Nombre de Usuario',
        'UserLastname' => 'Apellido de Usuario',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing notification events.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => '',
        'View system log messages.' => 'Muestra mensajes de log del sistema.',
        'Wear this frontend skin' => 'Poner esta piel a la interfaz',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Write a new, outgoing mail' => '',
        'Yes, but hide archived tickets' => '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Cola de selección de colas favoritas. Ud. también puede ser notificado de estas colas vía correo si está habilitado',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            '',

    };
    # $$STOP$$
    return;
}

1;
