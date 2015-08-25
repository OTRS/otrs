# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Si',
        'No' => 'Non',
        'yes' => 'si',
        'no' => 'non',
        'Off' => 'Desactivado',
        'off' => 'desactivado',
        'On' => 'Activado',
        'on' => 'en',
        'top' => 'superior',
        'end' => 'fin',
        'Done' => 'Feito',
        'Cancel' => 'Cancelar',
        'Reset' => 'Restabelecer',
        'more than ... ago' => 'hai máis de...',
        'in more than ...' => 'ten máis de...',
        'within the last ...' => 'no último...',
        'within the next ...' => 'nos seguintes...',
        'Created within the last' => 'Creado no último',
        'Created more than ... ago' => 'Creado hai máis de...',
        'Today' => 'Hoxe',
        'Tomorrow' => 'Mañá',
        'Next week' => 'A próxima semana',
        'day' => 'día',
        'days' => 'días',
        'day(s)' => 'día(s)',
        'd' => 'de',
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
        'year' => 'ano',
        'years' => 'anos',
        'year(s)' => 'ano(s)',
        'second(s)' => 'segundo(s)',
        'seconds' => 'segundos',
        'second' => 'segundo',
        's' => 's',
        'Time unit' => 'Unidade de tempo',
        'wrote' => 'escribiu',
        'Message' => 'Mensaxe',
        'Error' => 'Erro',
        'Bug Report' => 'Informe de fallo',
        'Attention' => 'Atención',
        'Warning' => 'Aviso',
        'Module' => 'Módulo',
        'Modulefile' => 'Arquivo do módulo',
        'Subfunction' => 'Sub-función',
        'Line' => 'Liña',
        'Setting' => 'Configuración',
        'Settings' => 'Configuración',
        'Example' => 'Exemplo',
        'Examples' => 'Exemplos',
        'valid' => 'correcto',
        'Valid' => 'Correcto',
        'invalid' => 'incorrecto',
        'Invalid' => 'Incorrecto',
        '* invalid' => '* incorrecto',
        'invalid-temporarily' => 'Non valido temporalmente',
        ' 2 minutes' => ' 2 minutos',
        ' 5 minutes' => ' 5 minutos',
        ' 7 minutes' => ' 7 minutos',
        '10 minutes' => '10 minutos',
        '15 minutes' => '15 minutos',
        'Mr.' => 'Sr.',
        'Mrs.' => 'Sra.',
        'Next' => 'Seguinte',
        'Back' => 'Volver',
        'Next...' => 'Seguinte...',
        '...Back' => '...Volver',
        '-none-' => '-ningún-',
        'none' => 'ningún',
        'none!' => 'ningún!',
        'none - answered' => 'Non contestado',
        'please do not edit!' => 'Non edite por favor!',
        'Need Action' => 'Acción necesaria',
        'AddLink' => 'Engadir Link',
        'Link' => 'Ligar',
        'Unlink' => 'Desligar',
        'Linked' => 'Ligado',
        'Link (Normal)' => 'Ligazón (Normal)',
        'Link (Parent)' => 'Ligazón (Pai)',
        'Link (Child)' => 'Ligazón (Fillo)',
        'Normal' => 'Normal',
        'Parent' => 'Pai',
        'Child' => 'Fillo',
        'Hit' => 'Coincidencia',
        'Hits' => 'Coincidencias',
        'Text' => 'Texto',
        'Standard' => 'Estándar',
        'Lite' => 'Lixeira',
        'User' => 'Usuario',
        'Username' => 'Nome de usuario',
        'Language' => 'Idioma',
        'Languages' => 'Idiomas',
        'Password' => 'Contrasinal',
        'Preferences' => 'Preferencias',
        'Salutation' => 'Saúdo',
        'Salutations' => 'Saúdos',
        'Signature' => 'Sinatura',
        'Signatures' => 'Sinaturas',
        'Customer' => 'Cliente',
        'CustomerID' => 'Identificador do cliente',
        'CustomerIDs' => 'Identificadores de cliente',
        'customer' => 'cliente',
        'agent' => 'axente',
        'system' => 'sistema',
        'Customer Info' => 'Información do cliente',
        'Customer Information' => 'Información do cliente',
        'Customer Companies' => 'Empresas do cliente',
        'Company' => 'Empresa',
        'go!' => 'ir!',
        'go' => 'ir',
        'All' => 'Todo',
        'all' => 'todo',
        'Sorry' => 'Desculpe',
        'update!' => 'actualizar!',
        'update' => 'actualizar',
        'Update' => 'actualizar',
        'Updated!' => 'Actualizado!',
        'submit!' => 'enviar!',
        'submit' => 'enviar',
        'Submit' => 'Enviar',
        'change!' => 'cambiar!',
        'Change' => 'Cambiar',
        'change' => 'cambiar',
        'click here' => 'prema aquí',
        'Comment' => 'Comentario',
        'Invalid Option!' => 'Opción incorrecta!',
        'Invalid time!' => 'Hora incorrecta!',
        'Invalid date!' => 'Data incorrecta!',
        'Name' => 'Nome',
        'Group' => 'Grupo',
        'Description' => 'Descrición',
        'description' => 'descrición',
        'Theme' => 'Tema',
        'Created' => 'Creado',
        'Created by' => 'Creado por',
        'Changed' => 'Cambiado',
        'Changed by' => 'Cambiado por',
        'Search' => 'Buscar',
        'and' => 'e',
        'between' => 'entre',
        'before/after' => 'antes/despois',
        'Fulltext Search' => 'Busca de texto completo',
        'Data' => 'Datos',
        'Options' => 'Opcións',
        'Title' => 'Título',
        'Item' => 'Elemento',
        'Delete' => 'Eliminar',
        'Edit' => 'Editar',
        'View' => 'Ver',
        'Number' => 'Número',
        'System' => 'Sistema',
        'Contact' => 'Contacto',
        'Contacts' => 'Contactos',
        'Export' => 'Exportar',
        'Up' => 'Arriba',
        'Down' => 'Abaixo',
        'Add' => 'Engadir',
        'Added!' => 'Engadido!',
        'Category' => 'Categoría',
        'Viewer' => 'Visor',
        'Expand' => 'Expandir',
        'Small' => 'Pequeno',
        'Medium' => 'Medio',
        'Large' => 'Grande',
        'Date picker' => 'Selector de data',
        'Show Tree Selection' => 'Mostrar a árbore de selección',
        'The field content is too long!' => 'O contido do campo é longo de máis!',
        'Maximum size is %s characters.' => 'O tamaño máximo é de %s caracteres.',
        'This field is required or' => 'O campo é obrigatorio ou',
        'New message' => 'Nova mensaxe',
        'New message!' => 'Mensaxe nova!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Responda a este(s) tícket(s) para regresar á vista normal da fila!',
        'You have %s new message(s)!' => 'Ten %s mensaxe(s) nova(s)!',
        'You have %s reminder ticket(s)!' => 'Ten %s recordatorios de ticket(s)!!!!',
        'The recommended charset for your language is %s!' => 'O conxunto de caracteres recomendado para o seu idioma é %s!',
        'Change your password.' => 'Cambie o seu contrasinal.',
        'Please activate %s first!' => 'Active %s primeiro!',
        'No suggestions' => 'Non hai suxestións',
        'Word' => 'Palabra',
        'Ignore' => 'Ignorar',
        'replace with' => 'substituír por',
        'There is no account with that login name.' => 'Non existe ningunha conta con ese nome.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Fallou o acceso! O nome de usuario ou o contrasinal foron introducidos incorrectamente.',
        'There is no acount with that user name.' => 'Non existe ningunha conta con ese nome.',
        'Please contact your administrator' => 'Contacte co seu administrador',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'A autenticación foi correcta, mais non se atopou o rexistro do cliente na infraestrutura de clientes. Contacte co seu administrador.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Este enderezo de correo xa existe. Acceda ou reinicie o seu contrasinal.',
        'Logout' => 'Pechar a sesión',
        'Logout successful. Thank you for using %s!' => 'A sesión foi pechada correctamente. Grazas por usar %s!',
        'Feature not active!' => 'Esta funcionalidade non está activa!',
        'Agent updated!' => 'Axente actualizado!',
        'Database Selection' => 'Selección de base de datos',
        'Create Database' => 'Crear base de datos',
        'System Settings' => 'Configuración do sistema',
        'Mail Configuration' => 'Configuración do correo',
        'Finished' => 'Rematado',
        'Install OTRS' => 'Instalar OTRS',
        'Intro' => 'Introdución',
        'License' => 'Licenza',
        'Database' => 'Base de datos',
        'Configure Mail' => 'Configurar o correo',
        'Database deleted.' => 'A base de datos foi eliminada.',
        'Enter the password for the administrative database user.' => 'Introduza o contrasinal para o usuario administrador da base de datos.',
        'Enter the password for the database user.' => 'Introduza o contrasinal para o usuario da base de datos.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Se non indicou xa un contrasinal de superusuario para a base de datos, haino que facer aquí. Se non, deixe este cambo baleiro.',
        'Database already contains data - it should be empty!' => 'A base de datos xa contén datos - debería estar baleira!',
        'Login is needed!' => 'É preciso ter accedido ao sistema!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Actualmente non é posíble acceder debido a un mantemento programado do sistema.',
        'Password is needed!' => 'Precísase un contrasinal!',
        'Take this Customer' => 'Coller este cliente',
        'Take this User' => 'Colla este Usuario',
        'possible' => 'posíble',
        'reject' => 'rexeitar',
        'reverse' => 'invertir',
        'Facility' => 'Instalación',
        'Time Zone' => 'Fuso horario',
        'Pending till' => 'Pendente ata',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Non empregue a conta de superusuario con OTRS! No canto diso, cree Axentes novos e traballe con esas contas.',
        'Dispatching by email To: field.' => 'Enviando por email A: campo',
        'Dispatching by selected Queue.' => 'Enviando a cola seleccionada',
        'No entry found!' => 'Non se atopou ningunha entrada!',
        'Session invalid. Please log in again.' => 'A sesión é incorrecta. Acceda de novo.',
        'Session has timed out. Please log in again.' => 'A sesión expirou. Ingrese novamente.',
        'Session limit reached! Please try again later.' => 'Alcanzado o limite da sesión! Intenteo novamente despois.',
        'No Permission!' => 'Permiso denegado!',
        '(Click here to add)' => '(Prema aquí para engadir)',
        'Preview' => 'Visualizar',
        'Package not correctly deployed! Please reinstall the package.' =>
            'O paquete non foi correctamente despregado! Por favor, volva a instalar o paquete.',
        '%s is not writable!' => 'Non é posíbel escribir en %s!',
        'Cannot create %s!' => 'Non é posíbel crear %s!',
        'Check to activate this date' => 'Marque para activar esta data',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Ten activado o servizo «fóra da oficina»; desexa desactivalo?',
        'News about OTRS releases!' => 'Novas sobre as versións novas de OTRS!',
        'Customer %s added' => 'Engadiuse o usuario %s',
        'Role added!' => 'Papel engadido!',
        'Role updated!' => 'Papel actualizado',
        'Attachment added!' => 'Engadiuse un anexo!',
        'Attachment updated!' => 'Actualizouse o anexo!',
        'Response added!' => 'Engadiuse unha resposta!',
        'Response updated!' => 'Actualizouse a resposta!',
        'Group updated!' => 'O grupo foi actualizado!',
        'Queue added!' => 'Engadiuse a fila!',
        'Queue updated!' => 'Actualizouse a fila!',
        'State added!' => 'Estado engadido!',
        'State updated!' => 'Estado actualizado!',
        'Type added!' => 'Engadiuse un tipo!',
        'Type updated!' => 'Actualizouse o tipo!',
        'Customer updated!' => 'O cliente foi actualizado!',
        'Customer company added!' => 'Empresa do cliente engadida!',
        'Customer company updated!' => 'Empresa do cliente actualizada!',
        'Note: Company is invalid!' => 'Nota: A empresa non é correcta!',
        'Mail account added!' => 'Engadiuse a conta de correo!',
        'Mail account updated!' => 'Actualizouse a conta de correo!',
        'System e-mail address added!' => 'Engadiuse o enderezo de correo do sistema!',
        'System e-mail address updated!' => 'Actualizouse o enderezo de correo do sistema!',
        'Contract' => 'Contrato',
        'Online Customer: %s' => 'Cliente na rede: %s',
        'Online Agent: %s' => 'Axente na rede: %s',
        'Calendar' => 'Calendario',
        'File' => 'Ficheiro',
        'Filename' => 'Nome de ficheiro',
        'Type' => 'Tipo',
        'Size' => 'Tamaño',
        'Upload' => 'Enviar',
        'Directory' => 'Directorio',
        'Signed' => 'Asinado',
        'Sign' => 'Asinar',
        'Crypted' => 'Cifrado',
        'Crypt' => 'Cifra',
        'PGP' => 'PGP',
        'PGP Key' => 'Chave de PGP',
        'PGP Keys' => 'Chaves de PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certificado S/MIME',
        'S/MIME Certificates' => 'Certificados S/MIME',
        'Office' => 'Oficina',
        'Phone' => 'Teléfono',
        'Fax' => 'Fax',
        'Mobile' => 'Móbil',
        'Zip' => 'CP',
        'City' => 'Cidade',
        'Street' => 'Rúa',
        'Country' => 'País',
        'Location' => 'Lugar',
        'installed' => 'instalado',
        'uninstalled' => 'desinstalado',
        'Security Note: You should activate %s because application is already running!' =>
            'Nota de seguranza: Debería activar %s porque o aplicativo xa está en execución!',
        'Unable to parse repository index document.' => 'Non foi posíbel analizar o documento de índice do repositorio.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Non se atoparon paquetes para a súa versión da infraestrutura neste repositorio, só contén paquetes para versións doutras infraestruturas.',
        'No packages, or no new packages, found in selected repository.' =>
            'Non se atoparon paquetes, ou non había paquetes novos, no repositorio seleccionado.',
        'Edit the system configuration settings.' => 'Editar as opcións de configuración do sistema.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'A información de ACL da base de datos non está sincronizada coa configuración do sistema; instale todas as ACL.',
        'printed at' => 'impreso o',
        'Loading...' => 'Cargando...',
        'Dear Mr. %s,' => 'Estimado Sr. %s,',
        'Dear Mrs. %s,' => 'Estimada Sra. %s,',
        'Dear %s,' => 'Estimado %s.',
        'Hello %s,' => 'Ola %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Non se permite rexistrar este enderezo de correo. Contacte co persoal de apoio.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Creouse unha conta nova. A información de acceso foille enviada a %s. Comprobe o seu correo.',
        'Please press Back and try again.' => 'Por favor presiona Atrás e volva a intentarlo.',
        'Sent password reset instructions. Please check your email.' => 'Enviadas as instruccións para resetea-la contrasinal. Por favor comprobe o seu email.',
        'Sent new password to %s. Please check your email.' => 'Enviada a nova contrasinal a %s. Por favor comprobe o seu email.',
        'Upcoming Events' => 'Eventos vindeiros',
        'Event' => 'Evento',
        'Events' => 'Eventos',
        'Invalid Token!' => 'Ficha incorrecta!',
        'more' => 'máis',
        'Collapse' => 'Contraer',
        'Shown' => 'Mostrado',
        'Shown customer users' => 'Mostrar os usuarios clientes',
        'News' => 'Noticias',
        'Product News' => 'Novas sobre o produto',
        'OTRS News' => 'Novas do OTRS',
        '7 Day Stats' => 'Estatísticas de 7 días',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'A información sobre a xestión de procesos da base de datos non está sincronizada coa configuración do sistema; sincronice todos os procesos.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Este paquete non foi comprobado polo Grupo OTRS! Non se recomenda empregar este paquete.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>Se continúa coa instalación deste paquete pódense producir as situacións seguintes!<br><br>&nbsp;-Problemas de seguranza<br>&nbspc;-Problemas de estabilidade&nbsp;&nbsp;-Problemas de desempeño<br>&nbsp;Teña en conta que as situacións provocadas por traballar con este paquete non as cobren os contratos de servizo de OTRS!<br><br>',
        'Mark' => 'Marcar',
        'Unmark' => 'Desmarcar',
        'Bold' => 'Grosa',
        'Italic' => 'Cursiva',
        'Underline' => 'Subliñado',
        'Font Color' => 'Cor do tipo de letra',
        'Background Color' => 'Cor de fondo',
        'Remove Formatting' => 'Retirar o formatado',
        'Show/Hide Hidden Elements' => 'Mostrar/Agochar os elementos agochados',
        'Align Left' => 'Aliñar á esquerda',
        'Align Center' => 'Centrar',
        'Align Right' => 'Aliñar á dereita',
        'Justify' => 'Xustificar',
        'Header' => 'Cabeceira',
        'Indent' => 'Sangría',
        'Outdent' => 'Alongar',
        'Create an Unordered List' => 'Lista non sen ordenar',
        'Create an Ordered List' => 'Crear unha lista ordenada',
        'HTML Link' => 'Ligazón HTML',
        'Insert Image' => 'Inserir unha imaxe',
        'CTRL' => 'CTRL',
        'SHIFT' => 'MAIÚSCULAS',
        'Undo' => 'Desfacer',
        'Redo' => 'Refacer',
        'Scheduler process is registered but might not be running.' => 'O proceso do planificador está rexistrado mais podería non estar en execución.',
        'Scheduler is not running.' => 'O planificador non se está a executar.',
        'All sessions have been killed, except for your own.' => 'Matáronse todas as sesións, excepto a súa.',
        'Can\'t contact registration server. Please try again later.' => 'Non se pode contactar co servizo de rexistro. Por favor, volva a intentalo mais tarde.',
        'No content received from registration server. Please try again later.' =>
            'Non se recibiu ningún contido do servidor de rexistro. Ténteo de novo máis tarde.',
        'Problems processing server result. Please try again later.' => 'Problemas no procesado dos resultados do servidor. Por favor, volva a intentalo mais tarde.',
        'Username and password do not match. Please try again.' => 'Nome de usuario e contrasinal non coinciden. Por favor, volva a intentalo.',
        'The selected process is invalid!' => 'O proceso seleccionado é invalido!',
        'Upgrade to %s now!' => 'Actualice a %s ahora!',
        '%s Go to the upgrade center %s' => '%s Ir ao centro de anovacións %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'A licencia para a súa %s e preto de expirar. Por favor contacte con %s para a renovación do seu contrato!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Existe unha actualización para o seu %s mais existe un conflito coa versión da súa infraestrutura! Actualice a súa infraestrutura antes!',
        'Your system was successfully upgraded to %s.' => 'O seu sistema foi actualizado satistactoriamente a %s',
        'There was a problem during the upgrade to %s.' => 'Houbo un problema durante a actualización a %s',
        '%s was correctly reinstalled.' => '%s foi reinstalado correctamente.',
        'There was a problem reinstalling %s.' => 'Houbo un problema reinstalando %s',
        'Your %s was successfully updated.' => 'O seu %s foi actualizado satisfactoriamente.',
        'There was a problem during the upgrade of %s.' => 'Houbo un problema durante a actualización de %s.',
        '%s was correctly uninstalled.' => '%s foi desinstalado correctamente.',
        'There was a problem uninstalling %s.' => 'Houbo un problema desistalando %s.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Aninovo',
        'International Workers\' Day' => 'Día do Traballo',
        'Christmas Eve' => 'Noiteboa',
        'First Christmas Day' => 'Primeiro día de Nadal.',
        'Second Christmas Day' => 'Segundo día do nadal.',
        'New Year\'s Eve' => 'Fin de ano',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS como solicitante',
        'OTRS as provider' => 'OTRS como fornecedor',
        'Webservice "%s" created!' => 'Servizo Web %s creado!',
        'Webservice "%s" updated!' => 'Servizo web %s actualizado!',

        # Template: AAAMonth
        'Jan' => 'Xan',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Abr',
        'May' => 'Maio',
        'Jun' => 'Xñ',
        'Jul' => 'Xl',
        'Aug' => 'Ag',
        'Sep' => 'Definir',
        'Oct' => 'Out',
        'Nov' => 'Nov',
        'Dec' => 'Dec',
        'January' => 'Xaneiro',
        'February' => 'Febreiro',
        'March' => 'Marzo',
        'April' => 'Abril',
        'May_long' => 'Maio',
        'June' => 'Xuño',
        'July' => 'Xullo',
        'August' => 'Agosto',
        'September' => 'Setembro',
        'October' => 'Outubro',
        'November' => 'Novembro',
        'December' => 'Decembro',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Actualización das preferencias satisfatoria!',
        'User Profile' => 'Perfil do usuario',
        'Email Settings' => 'Parámetros de configuración do correo electrónico',
        'Other Settings' => 'Outros axustes',
        'Change Password' => 'Cambiar o contrasinal',
        'Current password' => 'Contrasinal actual',
        'New password' => 'Novo contrasinal',
        'Verify password' => 'Verificar contrasinal',
        'Spelling Dictionary' => 'Dicionario de ortografía',
        'Default spelling dictionary' => 'Dicionario ortográfico predeterminado',
        'Max. shown Tickets a page in Overview.' => 'Cantidade máxima de Tickets por paxina na Vista Xeral.',
        'The current password is not correct. Please try again!' => 'O contrasinal actual non é correcto. Por favor, probe de novo!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Non se pode actualizar o contrasinal, as súas novas contrasinais non coinciden. Por favor, probe novamente!',
        'Can\'t update password, it contains invalid characters!' => 'Non se pode actualizar o contrasinal, contén carácteres non válidos!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Non se pode actualizar o contrasinal, debe conter polo menos %s carácteres!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Non se pode actualizar o contrasinal, debe conter polo menos 2 minúsculas e 2 maiúsculas!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Non se pode actualizar o contrasinal, debe conter polo menos 1 dixito!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Non se pode actualizar o contrasinal, debe conter polo menos 2 carácteres!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Non se pode actualizar o contrasinal porque xa foi empregada. Por favor escolla unha nova!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Escolla o carácter separador empregado nos arquivos CSV (estatísticas e buscas). Se non selecciona un separador aquí, o separador por defecto para o seu idioma será empregado.',
        'CSV Separator' => 'Separador de CSV',

        # Template: AAAStats
        'Stat' => 'Estatística',
        'Sum' => 'Suma',
        'No (not supported)' => 'Non (non admitido)',
        'Days' => 'Días',
        'Please fill out the required fields!' => 'Por favor rechee os campos necesarios!',
        'Please select a file!' => 'Por favor escolla un arquivo!',
        'Please select an object!' => 'Seleccione un obxecto!',
        'Please select a graph size!' => 'Por favor escolla o tamaño de grafico!',
        'Please select one element for the X-axis!' => 'Por favor escolla un elemento para o eixo das X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Por favor escolla só un elemento ou prema o botón "Fixado" onde o campo escollido encontrase marcado!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Se usa as caixas de verificación ten que seleccionar algúns atributos do campo seleccionar!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Por favor introduza un valor no campo de entrada seleccionado ou desactive a caixa de verificación "Fixado"',
        'The selected end time is before the start time!' => 'A hora de remate seleccionado é anterior á hora de inicio!',
        'You have to select one or more attributes from the select field!' =>
            'Debe escoller un ou mais atributos do campo seleccionar!',
        'The selected Date isn\'t valid!' => 'A data seleccionada é incorrecta!',
        'Please select only one or two elements via the checkbox!' => 'Por favor seleccione só un ou dous elementos mediante a caixa de verificación!',
        'If you use a time scale element you can only select one element!' =>
            'Se emprega a escala de tempo só pode escoller un elemento!',
        'You have an error in your time selection!' => 'Ten un erro na súa seleccion de tempo!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'O seu intervalo de tempo na presentación de informes e moi pequeno, por favor empregue unha escala de tempo maior!',
        'The selected start time is before the allowed start time!' => 'A hora de inicio seleccionado é anterior á hora de inicio permitida!',
        'The selected end time is after the allowed end time!' => 'A hora de remate seleccionado é posterior á hora de remate permitida!',
        'The selected time period is larger than the allowed time period!' =>
            'O período de tempo escollido e maior que o período de tempo permitido!',
        'Common Specification' => 'Especificación común!',
        'X-axis' => 'Eixo X',
        'Value Series' => 'Series de valor',
        'Restrictions' => 'Restricións',
        'graph-lines' => 'Liñas de gráfico',
        'graph-bars' => 'Barras de gráfico',
        'graph-hbars' => 'Hbarras de gráfico',
        'graph-points' => 'Puntos de gráfico',
        'graph-lines-points' => 'Liña de puntos de gráfico',
        'graph-area' => 'Área de gráfico',
        'graph-pie' => 'Gráfico circular',
        'extended' => 'Estendido',
        'Agent/Owner' => 'Axente/Dono',
        'Created by Agent/Owner' => 'Creado polo Axente/Propietario',
        'Created Priority' => 'Prioridade Creada',
        'Created State' => 'Estado Creado',
        'Create Time' => 'Tempo de Creación',
        'CustomerUserLogin' => 'AccesoClienteUsuario',
        'Close Time' => 'Hora de peche',
        'TicketAccumulation' => 'AcumulaciónTicket',
        'Attributes to be printed' => 'Atributos que imprimir',
        'Sort sequence' => 'Secuencia de clase',
        'Order by' => 'Ordene por',
        'Limit' => 'Límite',
        'Ticketlist' => 'Listaxe de Tickets',
        'ascending' => 'ascendente',
        'descending' => 'descendente',
        'First Lock' => 'Primeiro Bloqueo',
        'Evaluation by' => 'Avaliar por',
        'Total Time' => 'Tempo Total',
        'Ticket Average' => 'Media de Ticket',
        'Ticket Min Time' => 'Mínimo tempo de Ticket',
        'Ticket Max Time' => 'Máximo Tempo de Ticket',
        'Number of Tickets' => 'Número de Tickets',
        'Article Average' => 'Media de artigos',
        'Article Min Time' => 'Tempo Mínimo de Artigo',
        'Article Max Time' => 'Máximo Tempo de Artigo',
        'Number of Articles' => 'Número de artigos',
        'Accounted time by Agent' => 'Tempo considerado polo Axente',
        'Ticket/Article Accounted Time' => 'Tempo considerado polo Ticket/Artigo',
        'TicketAccountedTime' => 'TempoConsideradoTicket',
        'Ticket Create Time' => 'Tempo Creación Ticket',
        'Ticket Close Time' => 'Tempo Peche Ticket',

        # Template: AAASupportDataCollector
        'Unknown' => 'Descoñecido',
        'Information' => 'Información',
        'OK' => 'Aceptar',
        'Problem' => 'Problema',
        'Webserver' => 'Servidor Web',
        'Operating System' => 'Sistema Operativo',
        'OTRS' => 'OTRS',
        'Table Presence' => 'Presenza de táboas',
        'Internal Error: Could not open file.' => 'Erro interno: Non foi posíbel abrir o ficheiro.',
        'Table Check' => 'Comprobación de táboas',
        'Internal Error: Could not read file.' => 'Erro interno: Non foi posíbel ler o ficheiro.',
        'Tables found which are not present in the database.' => 'Táboas atopadas as cales non están presentes na base de datos.',
        'Database Size' => 'Tamaño da base de datos',
        'Could not determine database size.' => 'Non se pode determinar o tamaño da base de datos.',
        'Database Version' => 'Versión da base de datos',
        'Could not determine database version.' => 'Non se pode determinar a versión da base de datos.',
        'Client Connection Charset' => 'Conxunto de caracteres da conexión do cliente',
        'Setting character_set_client needs to be utf8.' => 'O axuste do character_set_client ten que ser utf8',
        'Server Database Charset' => 'Cadea de carácteres do Servidor da Base de Datos',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'O axuste character_set_database ten que ser UNICODE ou UTF8',
        'Table Charset' => 'Conxunto de caracteres da táboa',
        'There were tables found which do not have utf8 as charset.' => 'Foron atopadas tablas onde non temos utf8 seleccionado como cadea de carácteres.',
        'InnoDB Log File Size' => 'Tamaño do ficheiro de rexistro de InnoDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'A opción innodb_log_file_size ha de ter, como mínimo, 256 MB.',
        'Maximum Query Size' => 'Tamaño Máximo da Consulta',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'O axuste \'max_allowed_packet\' ten que ser maior que 20 MB.',
        'Query Cache Size' => 'Tamaño da Cache da Consulta',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Deberíase empregar a opción «query_cache_size» (maior de 10 MB mais non de 512 MB).',
        'Default Storage Engine' => 'Motor de almacenamento predeterminado',
        'Tables with a different storage engine than the default engine were found.' =>
            'Atopáronse táboas cun motor de almacenamento disinto do predeterminado.',
        'MySQL 5.x or higher is required.' => 'Requírese MySQL 5.x ou superior.',
        'NLS_LANG Setting' => 'Axuste de NLS_LANG',
        'NLS_LANG must be set to AL32UTF8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG debe ser posto a AL32UTF8(p.ex. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Axuste NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT debe ser posto como \'YYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'Axuste Comprobación SQL NLS_DATE_FORMAT',
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'O axuste client_encoding ten que ser UNICODE ou UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'O axuste server_encoding ten que ser UNICODE ou UTF8.',
        'Date Format' => 'Formato de data',
        'Setting DateStyle needs to be ISO.' => 'O axuste DateStyle ten que ser ISO.',
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL 8.x ou superior é requerido.',
        'OTRS Disk Partition' => 'Partición de disco de OTRS',
        'Disk Usage' => 'Uso de disco',
        'The partition where OTRS is located is almost full.' => 'A partición onde OTRS é localizado é practicamente chea.',
        'The partition where OTRS is located has no disk space problems.' =>
            'A partición onde OTRS é localizado non ten problemas de espazo en disco.',
        'Disk Partitions Usage' => 'Uso Particions Disco',
        'Distribution' => 'Distribución',
        'Could not determine distribution.' => 'non se pode determinar a distribución.',
        'Kernel Version' => 'Versión do kernel',
        'Could not determine kernel version.' => 'Non se pode determinar a versión do kernel.',
        'System Load' => 'Carga do sistema',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'A carga do sistema debe ser como máximo como o número de CPUs co sistema ten (P.Ex. a craga de 8 ou menos nun sistema con 8 CPUs é OK).',
        'Perl Modules' => 'Módulos de Perl',
        'Not all required Perl modules are correctly installed.' => 'Non todos os módulos de Perl requiridos están instalados correctamente.',
        'Perl Version' => 'Versión de Perl',
        'Free Swap Space (%)' => 'Espazo Libre de Permutación (%)',
        'No Swap Enabled.' => 'Permutación non Permitida.',
        'Used Swap Space (MB)' => 'Espazo de Permutación Usado (MB)',
        'There should be more than 60% free swap space.' => 'Ten que haber mais do 60% de espazo libre permutado.',
        'There should be no more than 200 MB swap space used.' => 'Non debe haber mais de 200 MB de espazo libre permutado.',
        'Config Settings' => 'Axustes de Configuración',
        'Could not determine value.' => 'Non se pode determinar o valor.',
        'Database Records' => 'Rexistros da base de datos',
        'Tickets' => 'Tickets',
        'Ticket History Entries' => 'Historial Entrada Ticket',
        'Articles' => 'Artigos',
        'Attachments (DB, Without HTML)' => 'Anexos (Base de datos, sen HTML)',
        'Customers With At Least One Ticket' => 'Clientes cun mínimo de un tícket',
        'Queues' => 'Filas',
        'Agents' => 'Axentes',
        'Roles' => 'Papeis',
        'Groups' => 'Grupos',
        'Dynamic Fields' => 'Campos Dinámicos',
        'Dynamic Field Values' => 'Valores Campo Dinámico',
        'Invalid Dynamic Fields' => 'Campos dinámicos incorrectos',
        'Invalid Dynamic Field Values' => 'Valores incorrectos de campo dinámico',
        'GenericInterface Webservices' => 'Interface Xenérica dos Servizos Web',
        'Processes' => 'Procesos',
        'Months Between First And Last Ticket' => 'Meses Entre o Primeiro e o Derradeiro Ticket',
        'Tickets Per Month (avg)' => 'Tíckets por mes (media)',
        'Default SOAP Username and Password' => 'Nome de usuario e Contrasinal SOAP por defecto',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Risco de Seguridade: Está empregando un axuste por defecto para SOAP::User e SOAP::Password. Por favor, cámbielo.',
        'Default Admin Password' => 'Contrasinal de administración predeterminada',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Risco de Seguridade: A conta de axente root@localhost ten ainda o contrasinal por defecto. Por favor cambielo ou invalide a conta.',
        'Error Log' => 'Rexistro de erros',
        'There are error reports in your system log.' => 'Hai erros de reporte no seu log do sistema.',
        'File System Writable' => 'Arquivo de Sitema Editable',
        'The file system on your OTRS partition is not writable.' => 'O arquivo de sitema na súa partición de OTRS non é editable.',
        'Domain Name' => 'Nome de Dominio',
        'Your FQDN setting is invalid.' => 'O seu axuste de FQDN é invalido.',
        'Package installation status' => 'Estado da instalación dos paquetes',
        'Some packages are not correctly installed.' => 'Algúns paquetes non están instalados correctamente.',
        'Package List' => 'Lista de paquetes',
        'SystemID' => 'IDSistema',
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'O axuste daIDSistema é invalido, debe conter só dixitos.',
        'OTRS Version' => 'Versión do OTRS',
        'Ticket Index Module' => 'Módulo de Índice de Ticket',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Ten mais de 60,000 tickets e debería empregar StaticDB backend. Vexa o manual do administrador (Sintonía do Rendemento) para mais información.',
        'Open Tickets' => 'Abrir Tickets',
        'You should not have more than 8,000 open tickets in your system.' =>
            'Non debe ter mais de 8,000 tickets no seu sistema.',
        'Ticket Search Index module' => 'Módulo de Índice da Busca de Ticket',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Ten mais de 50,000 artigos e deberia usar ó StaticDB backend. Vexa o manual do administrador  (Sintonía do Rendemento) para mais información.',
        'Orphaned Records In ticket_lock_index Table' => 'Rexistros orfos na táboa ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'A táboa ticket_lock_index contén rexistros orfos. Por favor execute otrs/bin/otrs.CleanTicketIndex.pl para limpar o índice StaticDb.',
        'Orphaned Records In ticket_index Table' => 'Rexistros orfos na táboa ticket_index',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'A táboa ticket_index contén rexistros orfos. Por favor execute otrs/bin/otrs.CleanTicketIndex.pl para limpar o índice StaticDb.',
        'Environment Variables' => 'Variables de Ambiente',
        'Webserver Version' => 'Versión do Servidor Web',
        'Could not determine webserver version.' => 'Non se pode determinar a versión do servidor web',
        'Loaded Apache Modules' => 'Módulos de Apache cargados',
        'MPM model' => 'Modelo MPM',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS require apache para ser executado co modelo \'prefork\' MPM.',
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
        'Apache::DBI Usage' => 'Uso de Apache::DBI',
        'Apache::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Deberíase empregar Apache ::DBI para obter un mellor desempeño coas conexións a bases de datos pre-estabelecidas.',
        'You should use PerlEx to increase your performance.' => 'Debe empregar PerlEx para mellorar o rendemento.',

        # Template: AAATicket
        'Status View' => 'Vista do estado',
        'Service View' => 'Vista de servizos',
        'Bulk' => 'Masa',
        'Lock' => 'Bloquear',
        'Unlock' => 'Desbloquear',
        'History' => 'Historial',
        'Zoom' => 'Ampliación',
        'Age' => 'Antigüidade',
        'Bounce' => 'Rebotar',
        'Forward' => 'Adiante',
        'From' => 'Desde',
        'To' => 'A',
        'Cc' => 'Copia',
        'Bcc' => 'Copia oculta',
        'Subject' => 'Asunto',
        'Move' => 'Mover',
        'Queue' => 'Fila',
        'Priority' => 'Prioridade',
        'Priorities' => 'Prioridades',
        'Priority Update' => 'Actualización de prioridade',
        'Priority added!' => 'Engadiuse a prioridade!',
        'Priority updated!' => 'Actualizouse a prioridade!',
        'Signature added!' => 'Sinatura engadida!',
        'Signature updated!' => 'Sinatura actualizada!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Acordo de nivel de servizo',
        'Service Level Agreements' => 'Acordos de nivel de servizos',
        'Service' => 'Servizo',
        'Services' => 'Servizos',
        'State' => 'Estado',
        'States' => 'Estado',
        'Status' => 'Estado',
        'Statuses' => 'Estados',
        'Ticket Type' => 'Tipo de tícket',
        'Ticket Types' => 'Tipos de tícket',
        'Compose' => 'Redactar',
        'Pending' => 'Pendente',
        'Owner' => 'Dono',
        'Owner Update' => 'Actualización do Propietario',
        'Responsible' => 'Responsable',
        'Responsible Update' => 'Actualización do Responsable',
        'Sender' => 'Remitente',
        'Article' => 'Artigo',
        'Ticket' => 'Tícket',
        'Createtime' => 'Tempo de Creación',
        'plain' => 'simple',
        'Email' => 'Correo',
        'email' => 'Correo',
        'Close' => 'Pechar',
        'Action' => 'Acción',
        'Attachment' => 'Anexo',
        'Attachments' => 'Anexos',
        'This message was written in a character set other than your own.' =>
            'Esta mesaxe foi escrita noutro conxunto de carácteres que o seu propio.',
        'If it is not displayed correctly,' => 'Se non se mostra correctamente,',
        'This is a' => 'Esto e un',
        'to open it in a new window.' => 'abrilo nunha nova ventá.',
        'This is a HTML email. Click here to show it.' => 'Esto é un email HTML. Faga click aqui para mostralo.',
        'Free Fields' => 'Campos libres',
        'Merge' => 'Combinar',
        'merged' => 'combinado',
        'closed successful' => 'pechado satisfactoriamente',
        'closed unsuccessful' => 'pechado infrutuosamente',
        'Locked Tickets Total' => 'Total de tíckets bloqueados',
        'Locked Tickets Reminder Reached' => 'Alcanzado o Recordatorio de Tickets Bloqueados',
        'Locked Tickets New' => 'Tíckets bloqueados novos',
        'Responsible Tickets Total' => 'Total de Tickets do Responsable',
        'Responsible Tickets New' => 'Novos Tickets do Responsable',
        'Responsible Tickets Reminder Reached' => 'Recordatorio dos Tickets do Responsable Alcanzado',
        'Watched Tickets Total' => 'Total de Tickets Mirados',
        'Watched Tickets New' => 'Novos Tickets Mirados',
        'Watched Tickets Reminder Reached' => 'Recordatorio dos Tickets Mirados Alcanzado',
        'All tickets' => 'Todos os tíckets',
        'Available tickets' => 'Tíckets dispoñíbeis',
        'Escalation' => 'Agravación',
        'last-search' => 'derradeira busca',
        'QueueView' => 'Vista da Cola',
        'Ticket Escalation View' => 'Vista do Escalado do Ticket',
        'Message from' => 'Mensaxe de',
        'End message' => 'Fin da mesaxe',
        'Forwarded message from' => 'Mensaxe encamiñado desde',
        'End forwarded message' => 'Fin da mesaxe enviada',
        'Bounce Article to a different mail address' => 'Facer rebotar o artigo a un enderezo de correo distinto',
        'Reply to note' => 'Contestación a nota',
        'new' => 'novo',
        'open' => 'abrir',
        'Open' => 'Abrir',
        'Open tickets' => 'Tickets abertos',
        'closed' => 'pechado',
        'Closed' => 'Pechado',
        'Closed tickets' => 'Tíckets pechados',
        'removed' => 'retirado',
        'pending reminder' => 'recordatorio pendente',
        'pending auto' => 'espera auto',
        'pending auto close+' => 'espera auto pechado+',
        'pending auto close-' => 'espera auto pechado-',
        'email-external' => 'email-externo',
        'email-internal' => 'email-interno',
        'note-external' => 'nota-externa',
        'note-internal' => 'nota-interna',
        'note-report' => 'nota-informe',
        'phone' => 'teléfono',
        'sms' => 'sms',
        'webrequest' => 'petición web',
        'lock' => 'bloquear',
        'unlock' => 'desbloquear',
        'very low' => 'moi baixo',
        'low' => 'baixo',
        'normal' => 'normal',
        'high' => 'alto',
        'very high' => 'moi alto',
        '1 very low' => '1 moi baixo',
        '2 low' => '2 baixo',
        '3 normal' => '3 normal',
        '4 high' => '4 alto',
        '5 very high' => '5 moi alto',
        'auto follow up' => 'autoseguimento',
        'auto reject' => 'autorexeitar',
        'auto remove' => 'auto eliminar',
        'auto reply' => 'autoresposta',
        'auto reply/new ticket' => 'autoresposta/novo ticket',
        'Create' => 'Crear',
        'Answer' => 'Resposta',
        'Phone call' => 'Chamada de teléfono',
        'Ticket "%s" created!' => 'Creouse o tícket «%s»!',
        'Ticket Number' => 'Numero do Ticket',
        'Ticket Object' => 'Obxeto do Ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Non tal Número "%s" do Ticket!Non se pode ligar!',
        'You don\'t have write access to this ticket.' => 'Non ten permiso de escritura neste ticket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'O sentimos, precisas ser o propietario do ticket para facer dita acción.',
        'Please change the owner first.' => 'Por favor cambie o propietario primeiro.',
        'Ticket selected.' => 'Ticket seleccionado.',
        'Ticket is locked by another agent.' => 'O tícket está bloqueado por outro axente.',
        'Ticket locked.' => 'Tícket boqueado.',
        'Don\'t show closed Tickets' => 'Non mostrar Tickets pechados.',
        'Show closed Tickets' => 'Mostrar Tickets pechados.',
        'New Article' => 'Novo artigo',
        'Unread article(s) available' => 'Artigo(s) sen leer dispoñibles',
        'Remove from list of watched tickets' => 'Elimine da lista de tickets vistos.',
        'Add to list of watched tickets' => 'Engadir á lista de tíckets vixiados',
        'Email-Ticket' => 'Email-Ticket',
        'Create new Email Ticket' => 'Cree un novo Email Ticket',
        'Phone-Ticket' => 'Ticket-Teléfono',
        'Search Tickets' => 'Busca Tickets',
        'Customer Realname' => 'Nome real do cliente',
        'Customer History' => 'Historial de cliente',
        'Edit Customer Users' => 'Editar os usuarios clientes',
        'Edit Customer' => 'Editar o cliente',
        'Bulk Action' => 'Acción en masa',
        'Bulk Actions on Tickets' => 'Acción en masa nos Tickets',
        'Send Email and create a new Ticket' => 'Enviar Email e crear un novo Ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Cree un novo Ticket de correo electrónico e envía isto (Saída)',
        'Create new Phone Ticket (Inbound)' => 'Cree un novo Ticket telefónico (Entrada)',
        'Address %s replaced with registered customer address.' => 'O enderezo %s foi substituído polo enderezo do cliente rexistrado.',
        'Customer user automatically added in Cc.' => 'O usuario cliente foi engadido automaticamente en Copia.',
        'Overview of all open Tickets' => 'Visión xeral de todos os Tickets abertos',
        'Locked Tickets' => 'Tíckets bloqueados',
        'My Locked Tickets' => 'Os meus tíckets bloqueados',
        'My Watched Tickets' => 'Meus Tickets Vistos',
        'My Responsible Tickets' => 'Tickets dos que son Responsable',
        'Watched Tickets' => 'Tickets Vistos',
        'Watched' => 'Vistos',
        'Watch' => 'Vixilancia',
        'Unwatch' => 'Non vistos',
        'Lock it to work on it' => 'Bloquealo para traballar con el',
        'Unlock to give it back to the queue' => 'Desbloquear para devolvelo á cola',
        'Show the ticket history' => 'Mostrar o historial do tícket',
        'Print this ticket' => 'Imprima este Ticket',
        'Print this article' => 'Imprimir este artigo',
        'Split' => 'Dividir',
        'Split this article' => 'Divida este articulo',
        'Forward article via mail' => 'Encamiñar o artigo mediante correo electrónico',
        'Change the ticket priority' => 'Cambie a prioridade deste Ticket',
        'Change the ticket free fields!' => 'Cambie os campos libres deste tícket!',
        'Link this ticket to other objects' => 'Vincule este Ticket con outros obxetos',
        'Change the owner for this ticket' => 'Cambie o propietario deste Ticket',
        'Change the  customer for this ticket' => 'Cambiar o cliente deste tícket.',
        'Add a note to this ticket' => 'Engada unha nota a este Ticket',
        'Merge into a different ticket' => 'Combinar cun tícket diferente',
        'Set this ticket to pending' => 'Poña este Ticket a espera',
        'Close this ticket' => 'Pechar este tícket',
        'Look into a ticket!' => 'Mire nun Ticket!',
        'Delete this ticket' => 'Borre este Ticket',
        'Mark as Spam!' => 'Marcar como lixo!',
        'My Queues' => 'As miñas filas',
        'Shown Tickets' => 'Tíckets mostrados',
        'Shown Columns' => 'Columnas mostradas',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'O seu correo, con número de tícket «<OTRS_TICKET>» foi combinado como «<OTRS_MERGE_TO_TICKET>».',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: tempo de primeira resposta superado (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: tempo de primeira resposta será superado en %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: tempo de actualización superado (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: tempo de actualización superado en %s!',
        'Ticket %s: solution time is over (%s)!' => 'Tícket %s: o tempo de solución finalizou (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tícket %s: o tempo de solución acaba en %s!',
        'There are more escalated tickets!' => 'Hai mais Tickets escalados!',
        'Plain Format' => 'Formato plano',
        'Reply All' => 'Contestar a Todos',
        'Direction' => 'Dirección',
        'Agent (All with write permissions)' => 'Axente (Todos os que teñen permiso de escrita)',
        'Agent (Owner)' => 'Axente (Dono)',
        'Agent (Responsible)' => 'Axente (Responsábel)',
        'New ticket notification' => 'Nova notificación de ticket',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Envíeme unha notificación se hai un ticket novo en "Miñas Colas".',
        'Send new ticket notifications' => 'Envíe notificacións de novos tickets',
        'Ticket follow up notification' => 'Notificación de seguimento de tícket',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Enviarme unha notificación se un cliente envía un seguimento e eu son o dono do tícket ou o tícket é desbloqueado e está nunha das miñas filas subscritas.',
        'Send ticket follow up notifications' => 'Envíe notificacións de seguimento de ticket',
        'Ticket lock timeout notification' => 'Notificación tempo de bloqueo de ticket excedido',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Envíeme unha notificación se un ticket e desbloqueado polo sistema.',
        'Send ticket lock timeout notifications' => 'Envía notificacións de tempos de bloqueo de tickets',
        'Ticket move notification' => 'Notificación dos movementos de Ticket',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Envíeme unha notificación se un ticket é movido a unha das "Miñas Colas".',
        'Send ticket move notifications' => 'Envíe notificacións dos movementos de ticket',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Selección de cola das súas colas favoritas. Será tamén notificado daquelas colas vía email se está habilitado.',
        'Custom Queue' => 'Cola Personalizada.',
        'QueueView refresh time' => 'Actualizar tempo da QueueView',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Se está habilitado, a QueueView será automaticamente actualizada despois do tempo especificado.',
        'Refresh QueueView after' => 'Actualize QueueView despois',
        'Screen after new ticket' => 'Pantalla despois de ticket novo',
        'Show this screen after I created a new ticket' => 'Mostrar esta pantalla despois de eu ter creado un tícket novo',
        'Closed Tickets' => 'Tíckets pechados',
        'Show closed tickets.' => 'Mostrar tickets pechados.',
        'Max. shown Tickets a page in QueueView.' => 'Máx. Tickets mostrados por páxina na QueueView.',
        'Ticket Overview "Small" Limit' => 'Limite "Baixo" na visión xeral do Ticket',
        'Ticket limit per page for Ticket Overview "Small"' => 'Limite de Ticket por páxina para a visión xeral "Baixa" do Ticket',
        'Ticket Overview "Medium" Limit' => 'Limite "Medio" na visión xeral do Ticket',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Limite de Ticket por páxina para a visión xeral "Media" do Ticket',
        'Ticket Overview "Preview" Limit' => 'Limite "Vista Previa" na visión xeral do Ticket',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limite de Ticket por páxina para a visión xeral "Vista Previa" do Ticket',
        'Ticket watch notification' => 'Notificación de Tickets vistos',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Envíeme as mesma notificacións para os meus tickets vistos coma para os que serei dono.',
        'Send ticket watch notifications' => 'Envíe notificacións de vista de tickets',
        'Out Of Office Time' => 'Tempo fóra da oficina',
        'New Ticket' => 'Novo Ticket',
        'Create new Ticket' => 'Cree un novo Ticket',
        'Customer called' => 'O cliente chamou',
        'phone call' => 'chamada de teléfono',
        'Phone Call Outbound' => 'Chamada saínte',
        'Phone Call Inbound' => 'Chamada entrante',
        'Reminder Reached' => 'Recordatorio Alcanzado',
        'Reminder Tickets' => 'Recordatorio Tickets',
        'Escalated Tickets' => 'Escalado Tickets',
        'New Tickets' => 'Novos Tickets',
        'Open Tickets / Need to be answered' => 'Tickets abertos / Necesitan ser contestados',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Tódolos tickets abertos, nestes tickets xa se a estado traballando, pero necesitan unha resposta',
        'All new tickets, these tickets have not been worked on yet' => 'Tódolos novos tickets, nestes tickets aínda non se a estado traballando',
        'All escalated tickets' => 'Tódolos tickets escalados',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Tólodos tickets cun recordatorio posto onde a data do recordatorio foi alcanzada',
        'Archived tickets' => 'Tíckets arquivados',
        'Unarchived tickets' => 'Tickets sen archivar',
        'Ticket Information' => 'Información Ticket',

        # Template: AAAWeekDay
        'Sun' => 'Do',
        'Mon' => 'Lu',
        'Tue' => 'Mar',
        'Wed' => 'Unirse con',
        'Thu' => 'Xo',
        'Fri' => 'Ve',
        'Sat' => 'Sá',

        # Template: AdminACL
        'ACL Management' => 'Xestión de ACL',
        'Filter for ACLs' => 'Filtro para ACLs',
        'Filter' => 'Filtro',
        'ACL Name' => 'Nome de ACL',
        'Actions' => 'Accións',
        'Create New ACL' => 'Crear unha ACL nova',
        'Deploy ACLs' => 'Despréguese para ACLs',
        'Export ACLs' => 'Exporte ACLs',
        'Configuration import' => 'Importación da configuración',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Aquí poderá actualizar o arquivo de configuración para importar ACLs o seu sistema. O arquivo necesita ser no formato .yml coma exportado polo módulo editor ACL.',
        'This field is required.' => 'Este campo é obrigatorio',
        'Overwrite existing ACLs?' => 'Sobrescribir ACLs existentes?',
        'Upload ACL configuration' => 'Configuración da actualización do ACL',
        'Import ACL configuration(s)' => 'Importar a(s) configuración(s) de ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Para crear un novo ACL pode importar ACLs que foran exportados doutros sistemas ou crear un completamente novo.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Os cambios nos ACLs feitos aquí so afectan o comportamiento do sistema, se despréganse os datos do ACL despois.Despregando os datos de ACL, os cambios feitos de novo serán gardados na configuración.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Por favor fíxese: Esta táboa representa a execución da orse dos ACLs. Se necesita cambialo orden no que os ACLs son executados, por favor cambie os nomes dos ACLs afectados.',
        'ACL name' => 'Nome de ACL',
        'Validity' => 'Validez',
        'Copy' => 'Copiar',
        'No data found.' => 'Non se atoparon datos.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ACL editado %s',
        'Go to overview' => 'Vaia a vista xeral',
        'Delete ACL' => 'Borre ACL',
        'Delete Invalid ACL' => 'Borre ACL invalido',
        'Match settings' => 'Axustes de correspondencia',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Axuste o criterio da correspondencia para este ACL. Use \'Propiedades\' para atopar o pantalla actual ou \'PropiedadesBaseDatos\' para atopar os atributos do ticket actual que está na base de datos.',
        'Change settings' => 'Cambiar a configuración',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Estableza que quere cambiar se o criterio é coincidente. Lembre que \'Posible\' e unha lista en branco, \'NoPosible\' é unha lista negra.',
        'Check the official' => 'Comprobe o oficial',
        'documentation' => 'documentación',
        'Show or hide the content' => 'Mostrar ou agochar o contido',
        'Edit ACL information' => 'Edite información ACL',
        'Stop after match' => 'Pare despois da coincidencia',
        'Edit ACL structure' => 'Edite a estructura ACL',
        'Save' => 'Gardar',
        'or' => 'ou',
        'Save and finish' => 'Garde e finalice',
        'Do you really want to delete this ACL?' => 'Quere realmente borrar este ACL?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Este elemento ainda contén sub elementos. Está seguro que quere borrar este elemento incluindo os seus sub elementos?',
        'An item with this name is already present.' => 'Xa existe un elemento con este nome.',
        'Add all' => 'Engadir todo',
        'There was an error reading the ACL data.' => 'Houbo un erro lendo os datos da ACL.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Cree unha ACL nova enviando os datos do formulario. Após crear a ACL será posíbel engadir elementos de configuración no modo de edición.',

        # Template: AdminAttachment
        'Attachment Management' => 'Xestión de anexos',
        'Add attachment' => 'Engadir un anexo',
        'List' => 'Lista',
        'Download file' => 'Descargue arquivo',
        'Delete this attachment' => 'Borre este adxunto',
        'Add Attachment' => 'Engadir un anexo',
        'Edit Attachment' => 'Edite o adxunto',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Xestión das respostas automáticas',
        'Add auto response' => 'Engadir unha resposta automática',
        'Add Auto Response' => 'Engadir unha resposta automática',
        'Edit Auto Response' => 'Editar a resposta automática',
        'Response' => 'Resposta',
        'Auto response from' => 'Resposta automática de',
        'Reference' => 'Referencia',
        'You can use the following tags' => 'Pode empregar os tags seguintes',
        'To get the first 20 character of the subject.' => 'Para obter os primeiros 20 carácteres do tema',
        'To get the first 5 lines of the email.' => 'Para obter as primeiras 5 liñas do email.',
        'To get the realname of the sender (if given).' => 'Para obter o nome real do emisor (se foi dado).',
        'To get the article attribute' => 'Para obter os atributos do artigo',
        ' e. g.' => 'por exemplo',
        'Options of the current customer user data' => 'Opcións dos datos do usuario cliente actual',
        'Ticket owner options' => 'Opcións do dono do tícket',
        'Ticket responsible options' => 'Opcións do responsable do ticket',
        'Options of the current user who requested this action' => 'Opcións do usuario actual que requeriu esta acción',
        'Options of the ticket data' => 'Opcións dos datos do ticket',
        'Options of ticket dynamic fields internal key values' => 'Opcióons dos valores clave internos dos datos dinámicos do ticket',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opcións de valores de mostra de campos dinámicos de ticket, útil para Dropdown e campos Multiseleccións',
        'Config options' => 'Opcións Configuración',
        'Example response' => 'Resposta de exemplo',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Xestión de clientes',
        'Wildcards like \'*\' are allowed.' => 'Comodíns coma \'*\' están permitidos',
        'Add customer' => 'Engadir un cliente',
        'Select' => 'Seleccionar',
        'Please enter a search term to look for customers.' => 'Introduza un termo de busca para procurar clientes.',
        'Add Customer' => 'Engadir un cliente',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Xestión de usuarios clientes',
        'Back to search results' => 'Retornar aos resultados da busca',
        'Add customer user' => 'Engadir un usuario cliente',
        'Hint' => 'Suxestión',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Os usuarios clientes son necesarios para ter un historial de cliente e para acceder mediante o panel de cliente.',
        'Last Login' => 'Último acceso',
        'Login as' => 'Acceder como',
        'Switch to customer' => 'Cambiar a usuario',
        'Add Customer User' => 'Engadir un usuario cliente',
        'Edit Customer User' => 'Editar usuario cliente',
        'This field is required and needs to be a valid email address.' =>
            'Este campo é requirido e precisa unha dirección de correo valida.',
        'This email address is not allowed due to the system configuration.' =>
            'Esta dirección de correo non está permitida debido a configuración do sistema.',
        'This email address failed MX check.' => 'Esta dirección de correo fallou a comprobación MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema de DNS; comprobe a configuración e o rexistro de erros.',
        'The syntax of this email address is incorrect.' => 'A sintaxe deste enderezo de correo electrónico é incorrecta.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Xestionar as relacións cliente-grupo',
        'Notice' => 'Aviso',
        'This feature is disabled!' => 'Esta funcionalidade está desactivada!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Empregue esta funcionalidade se desexa definir permisos de grupo para os clientes.',
        'Enable it here!' => 'Actíveo aquí!',
        'Edit Customer Default Groups' => 'Editar os Grupos Predeterminados dos Clientes',
        'These groups are automatically assigned to all customers.' => 'Estes grupos asígnanselle automaticamente a todos os clientes',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Estes grupos poden ser xestionados mediante a opción de configuración «CustomerGroupAlwaysGroups»',
        'Filter for Groups' => 'Filtrar por grupos',
        'Just start typing to filter...' => 'Comece a escribir un filtro...',
        'Select the customer:group permissions.' => 'Seleccionar os permisos cliente:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se non hai nada seleccionado, daquela non hai permisos neste grupo (os tíckets non estarán a disposición do cliente).',
        'Search Results' => 'Resultados da busca',
        'Customers' => 'Clientes',
        'No matches found.' => 'Non se atopou ningunha coincidencia.',
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

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Xestionar as relacións cliente-servizos',
        'Edit default services' => 'Edite os servizos predeterminados',
        'Filter for Services' => 'Filtrar por Servicios',
        'Allocate Services to Customer' => 'Asignar servizos a cliente',
        'Allocate Customers to Service' => 'Asignar clientes a servizo',
        'Toggle active state for all' => 'Conmute o estado activo a todos',
        'Active' => 'Activo',
        'Toggle active state for %s' => 'Conmutar o estado activo para %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Xestión dos Campos Dinámicos',
        'Add new field for object' => 'Engadir un campo novo para o obxecto',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Para engadir un novo campo, escolla o tipo de campo dun da lista de obxetos, o obxeto define os límites do campo e non pode ser modificado despois da creación do campo.',
        'Dynamic Fields List' => 'Listaxe dos Campos Dinámicos',
        'Dynamic fields per page' => 'Campos Dinámicos por paxina',
        'Label' => 'Etiqueta',
        'Order' => 'Orde',
        'Object' => 'Obxecto',
        'Delete this field' => 'Borre este campo',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Realmente quere borrar este campo dinámico? Tódolos  datos asociados serán PERDIDOS!',
        'Delete field' => 'Borre campo',

        # Template: AdminDynamicFieldCheckbox
        'Field' => 'Campo',
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
        'Field type' => 'Tipo de campo',
        'Object type' => 'Tipo de obxecto',
        'Internal field' => 'Campo interno',
        'This field is protected and can\'t be deleted.' => 'Este campo está protexido e non pode ser borrado.',
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
        'Admin Notification' => 'Notificación Administrador',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Con este módulo, os administradores poden enviar mensaxes a axentes, grupos ou membros dun rol.',
        'Create Administrative Message' => 'Crear unha mensaxe administrativa',
        'Your message was sent to' => 'A súa mensaxe foi enviada a ',
        'Send message to users' => 'Envíe mensaxe a usuarios',
        'Send message to group members' => 'Envía mensaxe aos membros do grupo',
        'Group members need to have permission' => 'Os membros do grupo deben ter permisos',
        'Send message to role members' => 'Envía mensaxes aos membros do rol',
        'Also send to customers in groups' => 'Enviar tamén os clientes en grupos',
        'Body' => 'Corpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Axente Xenérico',
        'Add job' => 'Engadir un traballo',
        'Last run' => 'Última execución',
        'Run Now!' => 'Execute Agora!',
        'Delete this task' => 'Borre esta tarefa',
        'Run this task' => 'Execute esta tarefa',
        'Job Settings' => 'Axustes de Traballo',
        'Job name' => 'Nome Traballo',
        'The name you entered already exists.' => 'O nome que introduciu xa existe.',
        'Toggle this widget' => 'Cambiar este Widget',
        'Automatic execution (multiple tickets)' => 'Execución Automatica (tickets múltiples)',
        'Execution Schedule' => 'Horario de Execución',
        'Schedule minutes' => 'Minutos de horario',
        'Schedule hours' => 'Horas de horario',
        'Schedule days' => 'Días de horario',
        'Currently this generic agent job will not run automatically.' =>
            'Actualmente este traballo de axente xenérico non se executará automaticamente',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Para activar a execución automática seleccione ao menos un valor de entre minutos, horas e días!',
        'Event based execution (single ticket)' => 'Execución baseada en eventos (ticket simple)',
        'Event Triggers' => 'Desencadeantes de Evento',
        'List of all configured events' => 'Lista de todos os eventos configurados',
        'Delete this event' => 'Eliminar este evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Adicionalmente ou alternativamente a unha execución periódica, vostede pode definir eventos de ticket que desencadearán esta tarefa.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Se un evento de ticket é disparado, o filtro de ticket será aplicado para comprobar se o ticket coincide. Soamente entón a tarefa é executada nese ticket.',
        'Do you really want to delete this event trigger?' => 'Vostede quere realmente borrar este desencadeante de evento?',
        'Add Event Trigger' => 'Engadir un disparador de eventos',
        'Add Event' => 'Engadir un evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Para engadir un novo evento, seleccione un novo obxeto  e  nome de evento e faga clic no botón "+". ',
        'Duplicate event.' => 'Evento duplicado.',
        'This event is already attached to the job, Please use a different one.' =>
            'Este eventoé xa concedido ao traballo, Por Favor utilizar un diferente.',
        'Delete this Event Trigger' => 'Borrar este Desencadeante de Evento',
        'Remove selection' => 'Elimine a selección',
        'Select Tickets' => 'Seleccione Tickets',
        '(e. g. 10*5155 or 105658*)' => '(p.ex. 10*5155 ou 105658*)',
        '(e. g. 234321)' => '(por exemplo 234321)',
        'Customer login' => 'Acceso do cliente',
        '(e. g. U5150)' => '(p.ex. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Busca de texto completo en artigo (ex. "Mar*in" ou "Baue*")',
        'Agent' => 'Axente',
        'Ticket lock' => 'Bloqueo de Ticket',
        'Create times' => 'Cree tempos',
        'No create time settings.' => 'Non crear axustes de tempo',
        'Ticket created' => 'Ticket creado',
        'Ticket created between' => 'Ticket creado entre',
        'Last changed times' => 'Tempo do derradeiro cambio',
        'No last changed time settings.' => 'Non axustes de tempo do derradeiro cambio.',
        'Ticket last changed' => 'Derradeiro cambio de ticket',
        'Ticket last changed between' => 'Derradeiro cambio de ticket entre',
        'Change times' => 'Tempo do cambio',
        'No change time settings.' => 'Non axustes do cambio do tempo',
        'Ticket changed' => 'Ticket cambiado',
        'Ticket changed between' => 'Ticket cambiado entre',
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
        'New customer' => 'Novo cliente',
        'New customer ID' => 'Novo identificador de cliente',
        'New title' => 'Novo título',
        'New type' => 'Novo tipo',
        'New Dynamic Field Values' => 'Novos valores de campos dinámicos',
        'Archive selected tickets' => 'Arquivar os tíckets seleccionados',
        'Add Note' => 'Engadir unha nota',
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
        'Save Changes' => 'Gardar os cambios',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '%s Tickets afectados! Que quere facer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Alerta: Usou a opción BORRAR. Tódolos tickets borrados serán perdidos!',
        'Edit job' => 'Edite tarefa',
        'Run job' => 'Execute tarefa',
        'Affected Tickets' => 'Tíckets afectados',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Debugger da InterfazXenerica para o Servizo Web %s',
        'Web Services' => 'Servizos Web',
        'Debugger' => 'Depurador',
        'Go back to web service' => 'Volte ao Servizo Web',
        'Clear' => 'Limpar',
        'Do you really want to clear the debug log of this web service?' =>
            'Quere realmente limpar o log do debug deste servizo web?',
        'Request List' => 'Lista de solicitudes',
        'Time' => 'Hora',
        'Remote IP' => 'IP remoto',
        'Loading' => 'Cargando',
        'Select a single request to see its details.' => 'Seleccione unha única petición para ver os seus detalles.',
        'Filter by type' => 'Filtro por tipo',
        'Filter from' => 'Filtro desde',
        'Filter to' => 'Filtro a',
        'Filter by remote IP' => 'Filtro por IP remota',
        'Refresh' => 'Actualizar',
        'Request Details' => 'Detalles da solicitude',
        'An error occurred during communication.' => 'Produciuse un erro durante a comunicación.',
        'Show or hide the content.' => 'Mostrar ou agochar o contido.',
        'Clear debug log' => 'Limpar o rexistro de depuración',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Engadir un invocador novo para o servizo web %s',
        'Change Invoker %s of Web Service %s' => 'Cambie o Invocador %s do Servizo Web %s',
        'Add new invoker' => 'Engadir un invocador novo',
        'Change invoker %s' => 'Cambie o invocador %s',
        'Do you really want to delete this invoker?' => 'Quere realmente borrar este invocador?',
        'All configuration data will be lost.' => 'Hanse perder todos os datos de configuración.',
        'Invoker Details' => 'Detalles do Invocador',
        'The name is typically used to call up an operation of a remote web service.' =>
            'O nome é tipicamente utilizado para chamar a unha operación dun servizo web remoto.',
        'Please provide a unique name for this web service invoker.' => 'Por favor proporcione un nome exclusivo a este invocador de servizo web.',
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
        'This invoker will be triggered by the configured events.' => 'Este invocador será disparado polos eventos configurados.',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Desencadeantes de eventos asincrónicos son manexados polo Planificador de OTRS en segundo plano (recomendado).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Desecadeantes de eventos sincrónicos serán procesados directamente durante a petición web.',
        'Save and continue' => 'Garde e continue',
        'Delete this Invoker' => 'Elimine este Invocador',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Mapeado Simple da InterfazXenérica do Servizo Web %s',
        'Go back to' => 'Volte a',
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
        'Delete this Key Mapping' => 'Borre esta Chave de Mapeado',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Engadir unha operación nova para o servizo web %s',
        'Change Operation %s of Web Service %s' => 'Cambie a Operación %s do Servizo Web %s',
        'Add new operation' => 'Engadir unha operación nova',
        'Change operation %s' => 'Cambie a Operación %s',
        'Do you really want to delete this operation?' => 'Quere realmente borrar esta operación?',
        'Operation Details' => 'Detalles de Operación',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'O nome é tipicamente utilizado para chamar a esta operación de servizo web dende un sistema remoto.',
        'Please provide a unique name for this web service.' => 'Por favor proporcione un nome único para este servizo web.',
        'Mapping for incoming request data' => 'Mapeado para as peticións de datos de entrada.',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'A petición de datos será procesada por este mapeado, para transformalo ao tipo de dato que espera OTRS.',
        'Operation backend' => 'Operación de backend',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Este módulo de operación de backend será chamado internamente para procesar a petición, xerando datos para a resposta.',
        'Mapping for outgoing response data' => 'Mapeado para os datos de resposta de saída',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Os datos de resposta serán procesados por este mapeado, para transformalos ao tipo de dato que o sistema remoto espera.',
        'Delete this Operation' => 'Borre esta Operación',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'InterfazXenérica Transporte HTTP::REST para o Servizo Web %s',
        'Network transport' => 'Transporte de rede',
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
        'Host' => 'Servidor',
        'Remote host URL for the REST requests.' => 'URL do servidor remoto das solicitudes REST.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'p.ex. https://www.otrs.com:10745/api/v1.0 (sen barra final)',
        'Controller mapping for Invoker' => 'Mapeado do controlador para o Invocador',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'O controlador ao cal o invocador debería enviar peticións. As variables marcadas con \': \' serán substituídas polos valores de datos e pasadas xunto coa petición. (p.ej. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Comando de petición válido para Invocador',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Un comando específico de HTTP  utilizase para as peticións con este Invocador (opcional).',
        'Default command' => 'Orde predeterminada',
        'The default HTTP command to use for the requests.' => 'O comando HTTP utilizase por defecto para estas peticións.',
        'Authentication' => 'Autenticación',
        'The authentication mechanism to access the remote system.' => 'O mecanismo de autenticación para acceder ao sistema remoto.',
        'A "-" value means no authentication.' => 'Un valor «-» significa sen autenticación.',
        'The user name to be used to access the remote system.' => 'O nome de usuario que usar para acceder ao sistema remoto.',
        'The password for the privileged user.' => 'O contrasinal para o usuario privilexiado.',
        'Use SSL Options' => 'Empregar as opcións de SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Mostrar ou agochar as opcións de SSL para conectarse ao sistema remoto.',
        'Certificate File' => 'Ficheiro de certificado',
        'The full path and name of the SSL certificate file.' => 'A ruta completa e o nome do ficheiro do certificado SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'p.ex. /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'Arquivo de Certificado de Contrasinal',
        'The full path and name of the SSL key file.' => 'A ruta completa e o nome do ficheiro da clave de SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'p.ex. /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Arquivo de Certicación de Autoridade (CA)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'A ruta completa e o nome do ficheiro do certificado da autoridade de certificación que valida o certificado de SSL.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'ex. /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'InterfaceXenérica de Transporte HTTP::SOAP para os Servizos Web %s',
        'Endpoint' => 'Final',
        'URI to indicate a specific location for accessing a service.' =>
            'URI para indicar un lugar específico para acceder a un servizo.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'ex. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Espazo de nomes',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI para lles dar un contexto aos métodos SOAP, reducindo ambigüidades.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'ex. urn:otrs-com:soap:functions ou http://www.otrs.com/GenericInterface/actions',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Aquí pode especificar o tamaño máximo (en bytes) de mensaxes SOAP que OTRS procesará.',
        'Encoding' => 'Codificando',
        'The character encoding for the SOAP message contents.' => 'Codificando o caracter para os contidos da mensaxe SOAP. ',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'ex. utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'SOAPAction' => 'SOAPAcción',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Establezca a "Si" para enviar unha cabeceira SOAPAcción enchida.',
        'Set to "No" to send an empty SOAPAction header.' => 'Establezca a "No" para enviar unha cabeceira SOAPAcción valeira.',
        'SOAPAction separator' => 'Separador SOAPAcción',
        'Character to use as separator between name space and SOAP method.' =>
            'Caracter para usar coma separador entre o espzo do nome e o método SOAP.',
        'Usually .Net web services uses a "/" as separator.' => 'Usualmente os servizos web .Net empregan unha "/" coma separador.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'A ruta completa e o nome do ficheiro do certificado SSL (ten que estar no formato .p12).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'ex. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'O contrasinal para abrir o certificado de SSL.',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'A ruta completa e o nome do ficheiro do certificado da autoridade de certificación que valida o certificado de SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'ex. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Directorio Autoridade de Certificación (AC)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'A ruta completa do directorio da autoridade de certificación onde os certificados AC son gardados no arquivo do sistema.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'ex. /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Servidor proxy',
        'URI of a proxy server to be used (if needed).' => 'URI dun servidor proxy para usar (de se precisar).',
        'e.g. http://proxy_hostname:8080' => 'ex. http://proxy_hostname:8080',
        'Proxy User' => 'Usuario do proxy',
        'The user name to be used to access the proxy server.' => 'O nome a empregar para o acceso o servidor de proxy.',
        'Proxy Password' => 'Contrasinal do proxy',
        'The password for the proxy user.' => 'O contrasinal do usuario de proxy.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'InterfaceXenérica de Xestión do Servizo Web',
        'Add web service' => 'Engadir un servizo web',
        'Clone web service' => 'Replicar o servizo web',
        'The name must be unique.' => 'O nome ten que ser único.',
        'Clone' => 'Replicar',
        'Export web service' => 'Exportar servizo web',
        'Import web service' => 'Importar servizo web',
        'Configuration File' => 'Ficheiro de configuración',
        'The file must be a valid web service configuration YAML file.' =>
            'O ficheiro ten que ser un ficheiro YAML de configuración de servizo web.',
        'Import' => 'Importar',
        'Configuration history' => 'Historial de configuración',
        'Delete web service' => 'Eliminar servizo web',
        'Do you really want to delete this web service?' => 'Desexa realmente eliminar este servicio web?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Despois de gardar a configuración será redirixido novamente a pantalla de edición.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Se quere voltar a vista xeral por favor faga clic no botón "Ir a vista xeral".',
        'Web Service List' => 'Lista  Servizo Web',
        'Remote system' => 'Sistema remoto',
        'Provider transport' => 'Transporte do fornecedor',
        'Requester transport' => 'Transporte do solicitante',
        'Debug threshold' => 'Limiar de depuración',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'No modo de fornecedor, OTRS ofrece servizos web que son empregados por sistemas remotos.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'No modo de solicitante, OTRS emprega servizos web de sistemas remotos.',
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
        'Delete webservice' => 'Elimine o servizo web',
        'Delete operation' => 'Elimine a operación',
        'Delete invoker' => 'Elimine o invocador',
        'Clone webservice' => 'Replicar o servizo web',
        'Import webservice' => 'Importe o servizo web',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Histórico da Configuración da InterfaceXenérica do Servizo Web %s',
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
        'Restore' => 'Reestablecer',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ALERTA: Cando vostede cambia o nome do grupo \'admin\', antes de facer os cambios apropiados no SysConfig, vostede será bloqueado fóra do panel de administración! Se isto sucede, por favor renomee o grupo de volta a admin por declaración de SQL.',
        'Group Management' => 'Xestión de grupos',
        'Add group' => 'Engadir un grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'O grupo de admin ten que chegar a área de admin e o grupo de stats para chegar a área de stats.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Cree novos grupos para manexar os permisos de acceso segundo o grupo de axente (ex. departamento compras, departamento soporte, departamento vendas...)',
        'It\'s useful for ASP solutions. ' => 'É util para solucións ASP.',
        'Add Group' => 'Engadir un grupo',
        'Edit Group' => 'Editar o grupo',

        # Template: AdminLog
        'System Log' => 'Rexistro do sistema',
        'Here you will find log information about your system.' => 'Aquí atopará información dos logs do seu sistema.',
        'Hide this message' => 'Agochar esta mensaxe',
        'Recent Log Entries' => 'Entradas recentes do rexistro',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Xestión de contas de correo',
        'Add mail account' => 'Engadir unha conta de correo',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Todo o correo entrante cunha conta será despachado na fila seleccionada!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Se a súa conta é de confianza, a cabeceira do X-OTRS que xa existe no tempo de chegada (por prioridade...) será empregada! O filtro de PostMaster será empregado en calquer caso.',
        'Delete account' => 'Eliminar a conta',
        'Fetch mail' => 'Recuperar o correo',
        'Add Mail Account' => 'Engadir unha conta de correo',
        'Example: mail.example.com' => 'Exemplo: mail.example.com',
        'IMAP Folder' => 'Cartafol de IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifique isto só se ten que obter correo dun cartafol distinto a INBOX.',
        'Trusted' => 'De confianza',
        'Dispatching' => 'Enviando',
        'Edit Mail Account' => 'Edite Conta Correo',

        # Template: AdminNavigationBar
        'Admin' => 'Administración',
        'Agent Management' => 'Xestión de axentes',
        'Queue Settings' => 'Configuración da fila',
        'Ticket Settings' => 'Axustes do Ticket',
        'System Administration' => 'Administración do sistema',
        'Online Admin Manual' => 'Manual de administración na rede',

        # Template: AdminNotification
        'Notification Management' => 'Xestión de notificacións',
        'Select a different language' => 'Escolla un idioma diferente',
        'Filter for Notification' => 'Filtro para Notificación',
        'Notifications are sent to an agent or a customer.' => 'As notificacións envíanselle a un axente ou a un cliente.',
        'Notification' => 'Notificación',
        'Edit Notification' => 'Edite Notificación',
        'e. g.' => 'por exemplo',
        'Options of the current customer data' => 'Opcións dos datos do cliente actual',

        # Template: AdminNotificationEvent
        'Add notification' => 'Engadir unha notificación',
        'Delete this notification' => 'Elimine esta notificación',
        'Add Notification' => 'Engadir unha notificación',
        'Ticket Filter' => 'Filtro do Ticket',
        'Article Filter' => 'Filtro de artigos',
        'Only for ArticleCreate and ArticleSend event' => 'Soamente para evento de CrearArtigo e EnviarArtigo',
        'Article type' => 'Tipo de artigo',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Se CrearArtigo ou EnviarArtigoson empregados para disparar un evento, ten que especificar un filtro de artigo tamén. Por favor seleccione polo menos un dos campos de filtros de artigo.',
        'Article sender type' => 'Tipo de remitente de artigos',
        'Subject match' => 'Tema coincide',
        'Body match' => 'Corpo coincide',
        'Include attachments to notification' => 'Incluír os anexos na notificación',
        'Recipient' => 'Destinatario',
        'Recipient groups' => 'Grupos receptores',
        'Recipient agents' => 'Axentes receptores',
        'Recipient roles' => 'Roles receptores',
        'Recipient email addresses' => 'Direccións correo receptoras',
        'Notification article type' => 'Tipo de artigo de notificación',
        'Only for notifications to specified email addresses' => 'Só para as notificacións aos enderezos de correo indicados',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Conseguir os primeiros 20 carácteres do tema (do último artigo de axente).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Conseguir as primeiras 5 liñas do corpo (do último artigo de axente).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para obter os primeiros vinte caracteres do asunto (do último artigo de cliente).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para obter as cinco primeiras liñas do corpo (do último artigo de cliente).',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Administrar %s',
        'Downgrade to OTRS Free' => 'Degrade a OTRS Gratis',
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
        'Upgrade to %s' => 'Mellorado a %s',
        '%s will be available soon. Please check again in a few days.' =>
            '%s estará dispoñíbel en breve. Comprobe de novo nuns días.',
        'Please have a look at %s for more information.' => 'Por favor vexa en %s para obter mais información.',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            'O seu OTRS Gratis e o baseamento de todalas accións futuras. Por favor rexistrese antes de continuar con procedemento de mmellora a %s!',
        'Register this System' => 'Rexistre este Sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Rexistro de Sistema é deshabilitado para o seu sistema. Por favor comprobe a súa configuración.',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Antes de beneficiarse de %s, por favor contacto con %s para obter o seu %s contrato.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Non foi posíbel conectarse a cloud.otrs.com mediante HTTPS. Asegúrese de que OTRS pode conectarse a cloud.otrs.com a través do porto 443.',
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
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            'Vostede está a punto de degradar a OTRS Gratis e perderá as seguintes carácteristicas e todos os datos relatacionados a estes:',
        'Chat' => 'Conversa',
        'Timeline view in ticket zoom' => 'Vista da liña de tempo no zoom do Ticket',
        'DynamicField ContactWithData' => 'CampoDinamico ContactoConDatos',
        'DynamicField Database' => 'CampoDinamico BaseDeDatos',
        'SLA Selection Dialog' => 'Diálogo de selección de SLA',
        'Ticket Attachment View' => 'Vista Adxuntos Ticket',
        'The %s skin' => 'A aparencia %s',

        # Template: AdminPGP
        'PGP Management' => 'Xestión PGP',
        'Use this feature if you want to work with PGP keys.' => 'Empregue está función se quere traballar con chaves PGP.',
        'Add PGP key' => 'Engadir unha chave de PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Desta maneira pódese editar directamente o chaveiro configurado en SysConfig.',
        'Introduction to PGP' => 'Introdución a PGP',
        'Result' => 'Resultado',
        'Identifier' => 'Identificador',
        'Bit' => 'Bit',
        'Fingerprint' => 'Pegada dactilar',
        'Expires' => 'Expira',
        'Delete this key' => 'Eliminar esta clave',
        'Add PGP Key' => 'Engadir unha chave de PGP',
        'PGP key' => 'Chave de PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Xestor de Paquetes',
        'Uninstall package' => 'Desinstalar o paquete',
        'Do you really want to uninstall this package?' => 'Confirma que desexa desinstalar este paquete?',
        'Reinstall package' => 'Reinstalar o paquete',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Confirma que desexa reinstalar este paquete? Os cambios manuais hanse perder.',
        'Continue' => 'Continuar',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Asegúrese de que a base de datos acepta paquetes de máis de %s MB de tamaño (actualmente só acepta paquetes de até %s MB). Adapte a opción max_allowed_packet da base de datos para evitar erros.',
        'Install' => 'Instalar',
        'Install Package' => 'Paquete de instalación',
        'Update repository information' => 'Actualice a información do repositorio',
        'Online Repository' => 'Repositorio na rede',
        'Module documentation' => 'Documentación do módulo',
        'Upgrade' => 'Repositorio local',
        'Local Repository' => 'Repositorio local',
        'This package is verified by OTRSverify (tm)' => 'Este pauqete foi verificado por OTRSverify (tm)',
        'Uninstall' => 'Desinstale',
        'Reinstall' => 'Reinstalar',
        'Features for %s customers only' => 'Funcionalidades só para clientes %s',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Con %s, pódese beneficiar de ás seguintes funcionalidades opcionáis. Por favor contacte con %s se precisa mais información.',
        'Download package' => 'Descargar paquete',
        'Rebuild package' => 'Reconstruír o paquete',
        'Metadata' => 'Metadatos',
        'Change Log' => 'Rexistro de cambios',
        'Date' => 'Data',
        'List of Files' => 'Listaxe de Arquivos',
        'Permission' => 'Permiso',
        'Download' => 'Descargar',
        'Download file from package!' => 'Descargue o arquivo dende o paquete!',
        'Required' => 'Necesario',
        'PrimaryKey' => 'ChavePrimaria',
        'AutoIncrement' => 'AutoIncremento',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Diferencias en arquivo do arquivo %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log de Rendemento',
        'This feature is enabled!' => 'Esta funcionalidade está activada!',
        'Just use this feature if you want to log each request.' => 'Empregue esta funcionalidade se desexa rexistrar cada solicitude.',
        'Activating this feature might affect your system performance!' =>
            'Activar esta funcionalidade pode afectar ó rendemento do seu sistema!',
        'Disable it here!' => 'Deshabiliteo aquí!',
        'Logfile too large!' => 'Arquivo de Log demasiado grande!',
        'The logfile is too large, you need to reset it' => 'O arquivo de log é demasiado grande, precisa resetealo',
        'Overview' => 'Vista xeral',
        'Range' => 'Intervalo',
        'last' => 'último',
        'Interface' => 'Interface',
        'Requests' => 'Solicitudes',
        'Min Response' => 'Resposta Min',
        'Max Response' => 'Resposta Max',
        'Average Response' => 'Resposta media',
        'Period' => 'Período',
        'Min' => 'Mín',
        'Max' => 'Máx',
        'Average' => 'Media',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Xestión  Filtros PostMaster',
        'Add filter' => 'Engadir un filtro',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para enviar ou filtrar os emails recibidos baseado nas cabeceiras dos emails. As coincidencias empregando Expresións Regulares tamén son posibles.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Sé quere que coincida soamente coa dirección de correo electrónico, empregue EMAILADDRESS:info@example.com en Desde, Para ou Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Se usa Expresións Regulares, pode tamén empregar o valor que coincida en () coma [***] na acción \'Estableza\'.',
        'Delete this filter' => 'Elimine este filtro',
        'Add PostMaster Filter' => 'Engadir un filtro de PostMaster',
        'Edit PostMaster Filter' => 'Edito Filtro PostMaster',
        'The name is required.' => 'O nome é obrigatorio',
        'Filter Condition' => 'Condición Filtro',
        'AND Condition' => 'Condición E',
        'Check email header' => 'Comprobar a cabeceira da mensaxe de  correo',
        'Negate' => 'Negar',
        'Look for value' => 'Atopar valor',
        'The field needs to be a valid regular expression or a literal word.' =>
            'O campo precisa ser unha expresión regular válida ou unha palabra literal.',
        'Set Email Headers' => 'Estableza Cabeceira Email',
        'Set email header' => 'Estableza cabeceira email',
        'Set value' => 'Estableza valor',
        'The field needs to be a literal word.' => 'O campo ten que ser unha palabra con letras.',

        # Template: AdminPriority
        'Priority Management' => 'Xestión das prioridades',
        'Add priority' => 'Engadir unha prioridade',
        'Add Priority' => 'Engadir unha prioridade',
        'Edit Priority' => 'Edite Prioridade',

        # Template: AdminProcessManagement
        'Process Management' => 'Xestión de procesos',
        'Filter for Processes' => 'Filtre por Procedementos',
        'Create New Process' => 'Crear un proceso novo',
        'Deploy All Processes' => 'Despregue Todolos Procesos',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Aquí pode cargar un arquivo de configuración para importar un proceso ao seu sistema. O arquivo necesita estar en formato .yml e exportado polo módulo de xestión de proceso.',
        'Overwrite existing entities' => 'Sobreescriba as entidades existentes',
        'Upload process configuration' => 'Cargue a configuración do procedemento',
        'Import process configuration' => 'Configuración do proceso de importación',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Para crear un novo Procedemento pode importar un que fora exportado doutro sistema ou crear un completamente novo.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Cambios nos Procedementos aquí só aflictirán o comportamento do sistema, se sincroniza os datos do Procedemento. Sincronizando os Procedementos, os cambios feitos de novo serán escritos na Configuración.',
        'Process name' => 'Nome do proceso',
        'Print' => 'Imprimir',
        'Export Process Configuration' => 'Exportar Configuración Procedemento',
        'Copy Process' => 'Copiar proceso',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Cancelar e pechar a xanela',
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
        'Create New Activity Dialog' => 'Crear un diálogo de actividade nova',
        'Assigned Activity Dialogs' => 'Diálogos de actividade asignados',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Tan pronto como use este botón ou ligazón, abandoará esta pantalla e o seu estado actual será gardado automaticamente. Quere continuar?',

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
        'Fields' => 'Campos',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Vostede pode asignar Campos a este Diálogo de Actividade arrastrando os elementos co rato da lista esquerda á lista da dereita.',
        'Filter available fields' => 'Campos de filtro dispoñibles',
        'Available Fields' => 'Campos dispoñíbeis',
        'Assigned Fields' => 'Campos asignados',
        'Edit Details for Field' => 'Edite Detalles para Campo',
        'ArticleType' => 'Tipo de Artigo',
        'Display' => 'Mostrar',
        'Edit Field Details' => 'Edite Detalles Campo',
        'Customer interface does not support internal article types.' => 'A interface do usuario non admite tipos de artigos internos.',

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
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Pode empezar unha conexión entre as Actividades baixando o elemento de Transición sobre a Actividade de Inicio da conexión. Despois diso pode movela do extremo frouxo da frecha ao Fin dá Actividade.',
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
        'Save settings' => 'Gardar a configuración',
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
        'Hide EntityIDs' => 'Ocultar EntityIds',
        'Delete Entity' => 'Elimine Entidade',
        'Remove Entity from canvas' => 'Elimine Entidade do canvas',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Esta Actividade está a ser empregada no Proceso. Non pode engadila dúas veces!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Esta Actividade non pode ser eliminada porque é a Actividade de Inicio.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'A Transición está a ser empregada para esta Actividade. Non pode usala dúas veces!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Esta AcciónTransición está a ser empregada nesta Ruta. Non pode empregala dúas veces!',
        'Remove the Transition from this Process' => 'Elimine a Transición para este Proceso',
        'No TransitionActions assigned.' => 'Non AcciónsTransición asignadas.',
        'The Start Event cannot loose the Start Transition!' => 'O Evento de Inicio non pode perder a Transición de Inicio!',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Aínda non se asignou ningún diálogo. Colla un diálogo de actividade da lista da esquerda e arrástreo para aquí.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Unha transición non conectada é xa posta no canvas. Por favor conecte esta transición antes de poñer outra transición.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Nesta pantalla pódese crear un proceso novo. Para que o novo proceso estea a disposición dos usuarios asegúrese de que o seu estado sexa «Activo» e sincronice após completar o traballo.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Inicie Actividade',
        'Contains %s dialog(s)' => 'Contén %s diálogo(s)',
        'Assigned dialogs' => 'Diálogos asignados',
        'Activities are not being used in this process.' => 'As Actividades non estar a ser empregadas neste proceso.',
        'Assigned fields' => 'Campos asignados',
        'Activity dialogs are not being used in this process.' => 'Non se está a usar diálogos de actividade neste proceso.',
        'Condition linking' => 'Conexión de condición',
        'Conditions' => 'Condicións',
        'Condition' => 'Condición',
        'Transitions are not being used in this process.' => 'As Transicións non están a ser empregadas neste proceso.',
        'Module name' => 'Nome do módulo',
        'Configuration' => 'Configuración',
        'Transition actions are not being used in this process.' => 'As Accións de Transición non están a ser empregadas neste proceso.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Por favor fíxese en que cambiar esta transición afectará os procesos seguintes',
        'Transition' => 'Transición',
        'Transition Name' => 'Nome da Transición',
        'Type of Linking between Conditions' => 'Tipo de ligazón entre condicións',
        'Remove this Condition' => 'Elimine esta Condición',
        'Type of Linking' => 'Tipo de ligazón',
        'Remove this Field' => 'Elimine este Campo',
        'And can\'t be repeated on the same condition.' => 'E non pode repetirse na mesma condición.',
        'Add a new Field' => 'Engadir un campo novo',
        'Add New Condition' => 'Engadir unha condición nova',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Por favor fíxese en que cambiar esta acción de transición afectará os procesos seguintes',
        'Transition Action' => 'Acción Transición',
        'Transition Action Name' => 'Nome Acción Transición',
        'Transition Action Module' => 'Módulo Acción Transición',
        'Config Parameters' => 'Parámetros Configurables',
        'Remove this Parameter' => 'Elimine este Parámetro',
        'Add a new Parameter' => 'Engada un novo Parámetro',

        # Template: AdminQueue
        'Manage Queues' => 'Xestionar as filas',
        'Add queue' => 'Engadir unha fila',
        'Add Queue' => 'Engadir unha fila',
        'Edit Queue' => 'Edite Cola',
        'A queue with this name already exists!' => 'Unha cola con este nome xa existe!',
        'Sub-queue of' => 'Sub-fila de',
        'Unlock timeout' => 'Desbloquear o tempo de espera',
        '0 = no unlock' => '0 = no desbloqueo',
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
        'The salutation for email answers.' => 'O saúdo para as respostas por correo electrónico.',
        'The signature for email answers.' => 'A sinatura para as respostas por correo electrónico.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Xestione Relacións de Resposta de Auto-Cola',
        'Filter for Queues' => 'Filtro para Colas',
        'Filter for Auto Responses' => 'Filtro para Auto Respostas',
        'Auto Responses' => 'Respostas automáticas',
        'Change Auto Response Relations for Queue' => 'Cambie Relacións de Resposta Auto para Cola',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Xestionar as relacións modelo-fila',
        'Filter for Templates' => 'Filtro para Modelos',
        'Templates' => 'Modelos',
        'Change Queue Relations for Template' => 'Cambie as Relacións da Cola para Modelo',
        'Change Template Relations for Queue' => 'Cambie Relacións de Modelo para Cola',

        # Template: AdminRegistration
        'System Registration Management' => 'Xestión do rexistro no sistema',
        'Edit details' => 'Edite detalles',
        'Show transmitted data' => 'Mostrar os datos transmitidos',
        'Deregister system' => 'Desrexistre sistema',
        'Overview of registered systems' => 'Vista xeral dos sistemas rexistrados',
        'System Registration' => 'Rexistro no sistema',
        'This system is registered with OTRS Group.' => 'Este sistema é rexistrado co grupo OTRS.',
        'System type' => 'Tipo de sistema',
        'Unique ID' => 'ID Único',
        'Last communication with registration server' => 'Derradeira comunicación co servidor de rexistro',
        'Send support data' => 'Enviar datos de axuda',
        'System registration not possible' => 'O rexistro do sistema non é posíbel',
        'Please note that you can\'t register your system if your scheduler is not running correctly!' =>
            'Teña en conta que o sistema non pode ser rexistrado se o planificador non se está a executar correctamente!',
        'Instructions' => 'Instrucións',
        'System deregistration not possible' => 'O desrexistro do sistema non é posible',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Por favor fíxese que non pode desrexistrar o seu sistema se está empregando %s ou tendo un contrato de servizo válido.',
        'OTRS-ID Login' => 'Log-In OTRS-ID',
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'O rexistro do sistema é un servizo do Grupo OTRS, que fornece numerosas vantaxes!',
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
        'In case you would have further questions we would be glad to answer them.' =>
            'No caso de que teña máis preguntas, encantaríanos respondelas.',
        'Please visit our' => 'Por favor visite o noso',
        'portal' => 'portal',
        'and file a request.' => 'e faga unha petición.',
        'Here at OTRS Group we take the protection of your personal details very seriously and strictly adhere to data protection laws.' =>
            'Aquí en Grupo OTRS levamos a protección dos seus detalles persoais moi seriamente e estritamente adherímonos as leis de protección de datos.',
        'All passwords are automatically made unrecognizable before the information is sent.' =>
            'Todos os contrasinais fanse irrecoñecíbeis automaticamente antes de que se envíe a información.',
        'Under no circumstances will any data we obtain be sold or passed on to unauthorized third parties.' =>
            'Baixo ningún concepto ningún dato que obtemos será vendido ou transmitido a  terceiras partes non autorizadas.',
        'The following explanation provides you with an overview of how we guarantee this protection and which type of data is collected for which purpose.' =>
            'A explicación seguinte proporciónalle unha visión xeral de como garantimos esta protección e que tipo de datos son recollidos é para que propósito.',
        'Data Handling with \'System Registration\'' => 'Datos de manipulación con \'Rexistro do Sistema\'',
        'Information received through the \'Service Center\' is saved by OTRS Group.' =>
            'A información recibida a través do «Centro de Servizo» é gardada polo Grupo OTRS.',
        'This only applies to data that OTRS Group requires to analyze the performance and function of the OTRS server or to establish contact.' =>
            'Este soamente aplica a datos dos cales o Grupo de OTRS esixe para analizar a actuación e función do servidor de OTRS ou para poñerse en contacto.',
        'Safety of Personal Details' => 'Seguridade de Detalles Persoais',
        'OTRS Group protects your personal data from unauthorized access, use or publication.' =>
            'O Grupo OTRS protexe os seus datos persoais de acceso non autorizado, uso ou publicación',
        'OTRS Group ensures that the personal information you store on the server is protected from unauthorized access and publication.' =>
            'O Grupo OTRS asegura que a información persoal que vostede almacena no servidor é protexida de acceso non autorizado e publicación.',
        'Disclosure of Details' => 'Revelación de Detalles',
        'OTRS Group will not pass on your details to third parties unless required for business transactions.' =>
            'O Grupo OTRS non transmitirá os seus detalles a terceiras partes a menos que sexan necesarios para transaccións de negocios.',
        'OTRS Group will only pass on your details to entitled public institutions and authorities if required by law or court order.' =>
            'O Grupo OTRS soamente transmitirá os seus detalles a institucións públicas tituladas e autoridades se é requirido por orde de lei ou tribunal.',
        'Amendment of Data Protection Policy' => 'Modificación de Política de Protección de Datos',
        'OTRS Group reserves the right to amend this security and data protection policy if required by technical developments.' =>
            'O Grupo OTRS reserva o dereito a emendar esta seguridade e política de protección de datos se é requirido por desenvolvementos técnicos.',
        'In this case we will also adapt our information regarding data protection accordingly.' =>
            'Neste caso tamén adaptaremos a nosa información en relación coa protección de datos.',
        'Please regularly refer to the latest version of our Data Protection Policy.' =>
            'Por favor refírase regularmente a última versión da nosa Política de Protección de Datos.',
        'Right to Information' => 'Dereito a Información',
        'You have the right to demand information concerning the data saved about you, its origin and recipients, as well as the purpose of the data processing at any time.' =>
            'Vostede ten o dereito a esixir que información acerca dos datos gardados sobre vostede, a súa orixe e receptores, así como o propósito do procesamento de datos en calquera momento.',
        'You can request information about the saved data by sending an e-mail to info@otrs.com.' =>
            'Vostede pode pedir información acerca dos datos gardados enviando un correo electrónico a info@otrs.com.',
        'Further Information' => 'Máis información',
        'Your trust is very important to us. We are willing to inform you about the processing of your personal details at any time.' =>
            'A súa confianza é moi importante para nós. Estamos desexosos de informalo do procesamento dos seus detalles persoáis en calquera momento.',
        'If you have any questions that have not been answered by this Data Protection Policy or if you require more detailed information about a specific topic, please contact info@otrs.com.' =>
            'Se vostede ten algunha cuestión á cal non respondeu esta Política de Protección de Datos ou se vostede require máis información detallada acerca dun tema específico, por favor póñase en contacto con info@otrs.com.',
        'If you deregister your system, you will lose these benefits:' =>
            'Se vostede desrexistra o seu sistema, perderá estes beneficios:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Vostede necesita conectarse coa súa identidade de OTRS para desrexistrar o seu sistema.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Ainda non ten unha ID-OTRS?',
        'Sign up now' => 'Inscríbase agora',
        'Forgot your password?' => 'Olvidou a sua contrasinal?',
        'Retrieve a new one' => 'Consiga unha nova',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Estes datos serán frecuentemente transferidos a Grupo OTRS cando rexistre este sistema.',
        'Attribute' => 'Atributo',
        'FQDN' => 'FQDN',
        'Optional description of this system.' => 'Descripción opcional deste sistema.',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Isto permite que o sistema envíe información de datos de axuda adicionais ao Grupo OTRS.',
        'Service Center' => 'Centro de Servizos',
        'Support Data Management' => 'Xestión dos datos de axuda',
        'Register' => 'Rexistro',
        'Deregister System' => 'Desrexistrar Sistema',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Se continúa con este paso ha anular o rexistro do sistema no Grupo OTRS.',
        'Deregister' => 'Desrexistrar',
        'You can modify registration settings here.' => 'Pode modificar os axustes de rexistro aquí.',
        'Overview of transmitted data' => 'Visión xeral de datos transmitidos',
        'There is no data regularly sent from your system to %s.' => 'Non hai datos enviados regularmente do seu sistema a %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Os datos seguintes envíanse como mínimo cada tres días desde o sistema a %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Os datos transferidos en formato JSON vía unha conexión segura https.',
        'System Registration Data' => 'Datos de rexistro no sistema',
        'Support Data' => 'Datos de axuda',

        # Template: AdminRole
        'Role Management' => 'Xestión de papeis',
        'Add role' => 'Engadir un papel',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Cree un papel e coloque grupos nel. A seguir, engada o papel aos usuarios.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Non hai ningún papel definido. Empregue o botón «Engadir» para crear un papel novo.',
        'Add Role' => 'Engadir un papel',
        'Edit Role' => 'Editar o papel',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Xestionar as relacións papel-grupo',
        'Filter for Roles' => 'Filtrar por papeis',
        'Select the role:group permissions.' => 'Seleccione os permisos de role:group.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Se nada é seleccionado, entón non hai permisos neste grupo (os tickets non estarán dispoñibles para o rol).',
        'Change Role Relations for Group' => 'Cambie Relacións de Rol para o Grupo',
        'Change Group Relations for Role' => 'Cambie Relacións de Grupo para o Rol',
        'Toggle %s permission for all' => 'Activar o permiso % s para todos',
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
        'Filter for Agents' => 'Fiiltro para Axentes',
        'Manage Role-Agent Relations' => 'Xestionar as relacións papel-axente',
        'Change Role Relations for Agent' => 'Cambie Relacións de Rol para Axente ',
        'Change Agent Relations for Role' => 'Cambie Relacións de Axente para Rol',

        # Template: AdminSLA
        'SLA Management' => 'Xestión de ACL',
        'Add SLA' => 'Engadir un SLA',
        'Edit SLA' => 'Editar o SLA',
        'Please write only numbers!' => 'Por favor escriba só números!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Xestión de S/MIME',
        'Add certificate' => 'Engadir un certificado',
        'Add private key' => 'Engadir unha chave privada',
        'Filter for certificates' => 'Filtro para certificados',
        'Filter for S/MIME certs' => 'Filtro para certificados S/MIME',
        'To show certificate details click on a certificate icon.' => 'Para mostrar os detalles do certificado prema no icono do certificado.',
        'To manage private certificate relations click on a private key icon.' =>
            'Para manexar as relacións de certificado privadas faga clic no icono de clave privada.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Aquí vostede pode engadir relacións ao seu certificado confidencial, estes serán incrustados á sinatura de S/MIME cada vez que vostede usa este certificado para asinar un correo electrónico.',
        'See also' => 'Consulte tamén',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Desta forma vostede pode directamente editar a certificación e chaves privadas no sistema de arquivos.',
        'Hash' => 'Hash',
        'Handle related certificates' => 'Manipular os certificados relacionados',
        'Read certificate' => 'Leer certificado',
        'Delete this certificate' => 'Elimine este certificado',
        'Add Certificate' => 'Engadir un certificado',
        'Add Private Key' => 'Engadir unha chave privada',
        'Secret' => 'Secreto',
        'Related Certificates for' => 'Certificados relacionados de',
        'Delete this relation' => 'Elimene esta relación',
        'Available Certificates' => 'Certificados dispoñíbeis',
        'Relate this certificate' => 'Relacionar este certificado',

        # Template: AdminSMIMECertRead
        'Close window' => 'Pechar a xanela',
        'Certificate details' => 'Detalles do certificado',

        # Template: AdminSalutation
        'Salutation Management' => 'Xestión de Saúdos',
        'Add salutation' => 'Engadir un saúdo',
        'Add Salutation' => 'Engadir un saúdo',
        'Edit Salutation' => 'Edite Saúdo',
        'Example salutation' => 'Saúdo de exemplo',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Modo seguro necesita estar activado!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'O modo seguro será (normalmente) fixado despois de que a instalación inicial sexa completada.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Se o modo seguro non está activado, actíveo via SysConfig porque a súa aplicación estase a executar.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Aquí vostede pode introducir SQL para envialo directamente á base de datos da aplicación. Non é posible cambiar o contido das táboas, soamente as consultas select son permitidas.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aquí vostede pode introducir SQL para envialo directamente á base de datos da aplicación.',
        'Only select queries are allowed.' => 'Soamente consultas select son permitidas.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'A sintaxe da súa consulta de SQL ten un erro. Por favor compróbea.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Hai polo menos un parámetro que falla para a unión. Por favor compróbeo.',
        'Result format' => 'Formato resultante',
        'Run Query' => 'Executar a consulta',
        'Query is executed.' => 'A consulta foi executada.',

        # Template: AdminService
        'Service Management' => 'Xestión de servizos',
        'Add service' => 'Engadir un servizo',
        'Add Service' => 'Engadir un servizo',
        'Edit Service' => 'Edite Servizo',
        'Sub-service of' => 'Sub-servizo de',

        # Template: AdminServiceCenterSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Estes datos son enviados a Grupo OTRS nunha base regular. Para parar de enviar a estes datos por favor actualice o seu rexistro de sistema.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Pódese disparar manualmente o envío de datos de axuda premendo neste botón:',
        'Send Update' => 'Enviar Actualización',
        'Sending Update...' => 'Enviando Actualización...',
        'Support Data information was successfully sent.' => 'A información de datos de axuda foi enviada correctamente.',
        'Was not possible to send Support Data information.' => 'Non foi posíbel enviar a información de datos de axuda.',
        'Update Result' => 'Resultado Actualización',
        'Currently this data is only shown in this system.' => 'Actualmente este dato é mostrado soamente neste sistema.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Recoméndase moito enviar estes datos ao Grupo OTRS para obter mellor axuda.',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Para activar o envío de datos rexistre o sistema no Grupo OTRS ou actualice a información de rexistro do sistema (asegúrese de activar a opción «enviar datos de axuda»).',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Un paquetede de apoio (incluíndo: información de rexistro de sistema, datos de apoio, unha lista de paquetes instalados e todolos arquivos de código fonte localmente modificados) pode ser xerado apertando este botón:',
        'Generate Support Bundle' => 'Xeración Paquete de Apoio',
        'Generating...' => 'Xerando...',
        'It was not possible to generate the Support Bundle.' => 'Non foi posible xenerar o Paquete de Apoio.',
        'Generate Result' => 'Resultado Xeración',
        'Support Bundle' => 'Paquete Apoio',
        'The mail could not be sent' => 'O mail non pudo ser enviado',
        'The support bundle has been generated.' => 'O paquete de apoio foi xerado',
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

        # Template: AdminSession
        'Session Management' => 'Xestión de sesións',
        'All sessions' => 'Todas as sesións',
        'Agent sessions' => 'Sesións de axentes',
        'Customer sessions' => 'Sesións do cliente',
        'Unique agents' => 'Axentes únicos',
        'Unique customers' => 'Clientes únicos',
        'Kill all sessions' => 'Matar todas as sesións',
        'Kill this session' => 'Matar esta sesión',
        'Session' => 'Sesión',
        'Kill' => 'Matar',
        'Detail View for SessionID' => 'Detalles',

        # Template: AdminSignature
        'Signature Management' => 'Xestión de Sinatura',
        'Add signature' => 'Engadir unha sinatura',
        'Add Signature' => 'Engadir unha sinatura',
        'Edit Signature' => 'Edite Sinatura',
        'Example signature' => 'Exemplo de sinatura',

        # Template: AdminState
        'State Management' => 'Estado',
        'Add state' => 'Engadir un estado',
        'Please also update the states in SysConfig where needed.' => 'Por favor actualice os estados en SysConfig cando sexa necesario.',
        'Add State' => 'Engadir un estado',
        'Edit State' => 'Edite Estado',
        'State type' => 'Tipo estado',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => 'Navegue buscando na configuración de %s',
        'Navigate by selecting config groups' => 'Navegue seleccionado grupos de configuracións',
        'Download all system config changes' => 'Descargue todolos cambios na configuración do sistema',
        'Export settings' => 'Exporte axustes',
        'Load SysConfig settings from file' => 'Cargue os axustes SysConfig dende arquivo',
        'Import settings' => 'Configuración da importación',
        'Import Settings' => 'Configuración da importación',
        'Please enter a search term to look for settings.' => 'Por favor introduza un termo de busqueda para buscar en axustes.',
        'Subgroup' => 'Subgrupo',
        'Elements' => 'Elementos',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Edite Axustes Configuración',
        'This config item is only available in a higher config level!' =>
            'Este elemento de configuración está só dispoñible nun nivel de configuración maior!',
        'Reset this setting' => 'Restablezca este axuste',
        'Error: this file could not be found.' => 'Error: este arquivo non pode ser atopado.',
        'Error: this directory could not be found.' => 'Error: este directorio non pode ser atopado.',
        'Error: an invalid value was entered.' => 'Error: un valor non valido foi introducido.',
        'Content' => 'Contido',
        'Remove this entry' => 'Elimine esta entrada',
        'Add entry' => 'Engadir unha entrada',
        'Remove entry' => 'Elimine entrada',
        'Add new entry' => 'Engadir unha entrada nova',
        'Delete this entry' => 'Borre esta entrada',
        'Create new entry' => 'Crear unha entrada nova',
        'New group' => 'Novo grupo',
        'Group ro' => 'ro grupo',
        'Readonly group' => 'Grupo só lectura',
        'New group ro' => 'Novo grupo ro',
        'Loader' => 'Cargador',
        'File to load for this frontend module' => 'Arquivo para cargar este módulo frontend',
        'New Loader File' => 'Novo Cargador de Arquivos',
        'NavBarName' => 'NomeNavBar',
        'NavBar' => 'NavBar',
        'LinkOption' => 'Ligar',
        'Block' => 'Bloquear',
        'AccessKey' => 'ChaveAcceso',
        'Add NavBar entry' => 'Engadir unha entrada da barra de navegación',
        'Year' => 'Ano',
        'Month' => 'Mes',
        'Day' => 'Día',
        'Invalid year' => 'Ano incorrecto',
        'Invalid month' => 'Mes incorrecto',
        'Invalid day' => 'Día incorrecto',
        'Show more' => 'Mostrar máis',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Xestión Enderezos de Correo Electrónico de Sistema',
        'Add system address' => 'Engadir un enderezo de correo do sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todo o correo entrante con este enderezo en A: ou Copia: será despachado á fila seleccionada.',
        'Email address' => 'Enderezo de correo electrónico',
        'Display name' => 'Nome a mostrar',
        'Add System Email Address' => 'Engadir un enderezo de correo do sistema',
        'Edit System Email Address' => 'Edite Enderezo de Correo Electrónico de Sistema',
        'The display name and email address will be shown on mail you send.' =>
            'O nome de mostra e o enderezo de correo electrónico será acompañado no correo que vostede envía.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Xestión do mantemento do sistema',
        'Schedule New System Maintenance' => 'Programe Novo Mantemento de Sistema',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Programar un período de mantemento do sistema para anunciar a axentes e clientes que o sistema estará inaccesíbel durante un período de tempo.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Algún tempo antes de que este mantemento de sistema empece os usuarios recibirán unha notificación en cada pantalla que anuncia sobre este feito.',
        'Start date' => 'Data de comezo',
        'Stop date' => 'Data de parada',
        'Delete System Maintenance' => 'Borre Mantemento de Sistema',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Vostede realmente quere borrar este mantemento de sistema programado?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Edite Mantemento de Sistema %s',
        'Edit System Maintenance information' => 'Edite información de Mantemento de Sistema',
        'Date invalid!' => 'A data é incorrecta!',
        'Login message' => 'mensaxe de acceso',
        'Show login message' => 'Mostre mensaxe de login',
        'Notify message' => 'Notifique mensaxe',
        'Manage Sessions' => 'Xestionar as sesións',
        'All Sessions' => 'Todas as sesións',
        'Agent Sessions' => 'Sesións de axentes',
        'Customer Sessions' => 'Sesións do cliente',
        'Kill all Sessions, except for your own' => 'Matar todas as sesións, excepto a súa.',

        # Template: AdminTemplate
        'Manage Templates' => 'Xestionar os modelos',
        'Add template' => 'Engadir un modelo',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Un modelo é un texto predeterminado que axuda os axentes a escribiren tíckets, respostas ou encamiñamentos máis rápidos.',
        'Don\'t forget to add new templates to queues.' => 'Non esqueza de engadir novos modelos as colas',
        'Add Template' => 'Engadir un modelo',
        'Edit Template' => 'Editar o modelo',
        'A standard template with this name already exists!' => 'Un modelo estandard con este nome xa existe!',
        'Template' => 'Modelo',
        'Create type templates only supports this smart tags' => 'Cree modelos tipo só soportados por estos smart tags',
        'Example template' => 'Modelo exemplo',
        'The current ticket state is' => 'O estado do tícket actual é',
        'Your email address is' => 'O seu enderezo de correo electrónico é',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Xestionar as relacións Modelos <-> Anexos',
        'Filter for Attachments' => 'Filtro para Anexos',
        'Change Template Relations for Attachment' => 'Cambie as Relacións do Modelo para Anexos',
        'Change Attachment Relations for Template' => 'Cambie Relacións Anexos para Modelo',
        'Toggle active for all' => 'Alternar activo para todos',
        'Link %s to selected %s' => 'Ligue %s cos seleccionados %s',

        # Template: AdminType
        'Type Management' => 'Xestión de tipos',
        'Add ticket type' => 'Engadir un tipo de tícket',
        'Add Type' => 'Engadir un tipo',
        'Edit Type' => 'Edite Tipo',
        'A type with this name already exists!' => 'Un tipo con este nome xa existe!',

        # Template: AdminUser
        'Add agent' => 'Engadir un axente',
        'Agents will be needed to handle tickets.' => 'Axentes serán necesitados para manexar tickets.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Non esqueza de engadir a un novo axente a grupos e/ou roles!',
        'Please enter a search term to look for agents.' => 'Por favor entre un termo de busca para buscar axentes.',
        'Last login' => 'Último acceso',
        'Switch to agent' => 'Cambie a axente',
        'Add Agent' => 'Engadir un axente',
        'Edit Agent' => 'Edite Axente',
        'Firstname' => 'Nome',
        'Lastname' => 'Apelido',
        'A user with this username already exists!' => 'Un usuario con este nome de usuario xa existe!',
        'Will be auto-generated if left empty.' => 'Será auto-xerada se é deixado baleiro.',
        'Start' => 'Inicio',
        'End' => 'Fin',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Xestionar as relacións axente-grupo',
        'Change Group Relations for Agent' => 'Cambie Relacións de Grupo para Axente',
        'Change Agent Relations for Group' => 'Cambie Relacións de Axente para Grupo',

        # Template: AgentBook
        'Address Book' => 'Caderno de enderezos',
        'Search for a customer' => 'Buscar un cliente',
        'Add email address %s to the To field' => 'Engadir o enderezo de correo %s ao campo de Para',
        'Add email address %s to the Cc field' => 'Engadir o enderezo de correo %s ao campo de copia',
        'Add email address %s to the Bcc field' => 'Engadir o enderezo de correo %s ao campo de copia oculta',
        'Apply' => 'Aplicar',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro de información ao cliente',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Usuario cliente',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Entrada duplicada',
        'This address already exists on the address list.' => 'Este enderezo xa existe na lista de enderezos.',
        'It is going to be deleted from the field, please try again.' => 'Vai ser borrado do campo, por favor probar outra vez.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: O cliente non é correcto!',

        # Template: AgentDashboard
        'Dashboard' => 'Taboleiro',

        # Template: AgentDashboardCalendarOverview
        'in' => 'en',

        # Template: AgentDashboardCommon
        'Available Columns' => 'Columnas dispoñíbeis',
        'Visible Columns (order by drag & drop)' => 'Columnas visibles (orde por arrastre & caída)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tickets escalados',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Información do cliente',
        'Phone ticket' => 'Ticket telefónico',
        'Email ticket' => 'Ticket correo electrónico',
        'Start Chat' => 'Inice Chat',
        '%s open ticket(s) of %s' => '%s tícket(s) abertos de %s',
        '%s closed ticket(s) of %s' => '%s tícket(s) pechado(s) de %s',
        'New phone ticket from %s' => 'Novo ticket telefónico de %s',
        'New email ticket to %s' => 'Novo ticket de correo electrónico a %s',
        'Start chat' => 'Comece chat',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está dispoñíbel!',
        'Please update now.' => 'Por favor actualice agora',
        'Release Note' => 'Nota de versión',
        'Level' => 'Nivel',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Publicado fai %s ',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            'O contido desta estatística está a ser preparado para vostede, por favor sexa paciente.',
        'Grouped' => 'Agrupado',
        'Stacked' => 'Amoreados',
        'Expanded' => 'Expandido',
        'Stream' => 'Fluxo',
        'CSV' => 'CSV',
        'PDF' => 'PDF',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Os meus tíckets bloqueados',
        'My watched tickets' => 'Os meus tickets mirados',
        'My responsibilities' => 'As miñas responsabilidades',
        'Tickets in My Queues' => 'Tíckets nas miñas filas',
        'Tickets in My Services' => 'Tickets en Meus Servizos',
        'Service Time' => 'Tempo de servizo',
        'Remove active filters for this widget.' => 'Elimine os filtros activos para este widget',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Totais',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fóra da oficina',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'ata',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'O tícket foi bloqueado',
        'Undo & close window' => 'Desfacer & pechar ventá',

        # Template: AgentInfo
        'Info' => 'Información',
        'To accept some news, a license or some changes.' => 'Para aceptar algunhas noticias, un permiso ou algúns cambios.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Ligar o obxecto: %s',
        'go to link delete screen' => 'vaia o enlace borrar pantalla',
        'Select Target Object' => 'Seleccione o Obxecto Obxetivo',
        'Link Object' => 'Ligar o obxecto',
        'with' => 'con',
        'Unlink Object: %s' => 'Desrelacione Obxecto: %s',
        'go to link add screen' => 'vaia o enlace engadir pantalla',

        # Template: AgentPreferences
        'Edit your preferences' => 'Edite as súas preferencias',

        # Template: AgentSchedulerInfo
        'General Information' => 'Información xeral',
        'Scheduler is an OTRS separated process that perform asynchronous tasks' =>
            'O Planificador é un proceso separado do OTRS que realiza tarefas asíncronas',
        '(e.g. Generic Interface asynchronous invoker tasks)' => '(ex. Interface Xenérica de tarefas do invocador asincrónicas)',
        'It is necessary to have the Scheduler running to make the system work correctly!' =>
            'É necesario ter o Planificador executándose para facer o sistema traballar correctamente!',
        'Starting Scheduler' => 'A iniciar o planificador',
        'Make sure that %s exists (without .dist extension)' => 'Asegúrese de que %s existe (sen extensión .dist)',
        'Check that cron deamon is running in the system' => 'Comprobar que o daemon cron está en execución no sistema',
        'Confirm that OTRS cron jobs are running, execute %s start' => 'Confirme que OTRS cron jobs se están a executar, execute %s o comezo',

        # Template: AgentSpelling
        'Spell Checker' => 'Verificador Deletrear',
        'spelling error(s)' => 'erro(s) de deletreo',
        'Apply these changes' => 'Aplicar estes cambios',

        # Template: AgentStatsDelete
        'Delete stat' => 'Elimine estatística',
        'Do you really want to delete this stat?' => 'Quere realmente borrar esta estatística?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Paso %s',
        'General Specifications' => 'Especificacións Xerais',
        'Select the element that will be used at the X-axis' => 'Seleccione o elemento que será utilizado no eixo X',
        'Select the elements for the value series' => 'Seleccione os elementos para as series de valores',
        'Select the restrictions to characterize the stat' => 'Selecciones as restriccións para caracterizar a estatística',
        'Here you can make restrictions to your stat.' => 'Aquí pode poñer restriccións a súa estatística.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Se vostede elimina o gancho no checkbox "Fixo", o axente que xera a estatística pode cambiar os atributos do elemento correspondente.',
        'Fixed' => 'Fixo',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor seleccione soamente un elemento ou apague o botón \'Fixo\'.',
        'Absolute Period' => 'Período Absoluto',
        'Between' => 'Entre',
        'Relative Period' => 'Período relativo',
        'The last' => 'O último',
        'Finish' => 'Rematar',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permisos',
        'You can select one or more groups to define access for different agents.' =>
            'Pode seleccionar un ou mais grupos para definir o acceso para distintos axentes.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Algúns formatos de resultado están desactivados porque polo menos un paquete necesario non está instalado.',
        'Please contact your administrator.' => 'Contacte co seu administrador.',
        'Graph size' => 'Tamaño de gráfico',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Se utiliza un gráfico como formato de saída vostede ten que seleccionar polo menos un tamaño de gráfico.',
        'Sum rows' => 'Filas de suma',
        'Sum columns' => 'Columnas de suma',
        'Use cache' => 'Use cache',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'É posíbel manter a maioría das estatísticas na memoria caché. Isto acelera a presentación destas estatísticas.',
        'Show as dashboard widget' => 'Mostrar como trebello no taboleiro',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Proporcione a estatística como un widget que os axentes poden activar no seu cadro de mando.',
        'Please note' => 'Por favor lembre',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Permitindo o widget de cadros de mando activará caching para esta estatística no cadro de mando.',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            'Os axentes non poderán cambiar a opción de hora absoluta para os trebellos de estatística do taboleiro',
        'IE8 doesn\'t support statistics dashboard widgets.' => 'O IE8 non admite trebellos de panel de estatísticas.',
        'If set to invalid end users can not generate the stat.' => 'Se se establece a inválido os usuarios finales non poden xerar o stat.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Aquí pode definir as series de valores.',
        'You have the possibility to select one or two elements.' => 'Ten a posibilidade de seleccionar un ou dous elementos.',
        'Then you can select the attributes of elements.' => 'Despois pode seleccionar os atributos dos elementos.',
        'Each attribute will be shown as single value series.' => 'Cada atributo será  mostrado como una serie de valores simple.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Se non selecciona ningún atributo todos os atributos do elemento serán utilizados se xera un stat, así como novos atributos que serán engadidos dende a última configuración.',
        'Scale' => 'Escala',
        'minimal' => 'mínimo',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Por favor acórdese, que a escala para serie de valor ten que ser máis grande que a escala para o eixo X (p.ej. Eixo X => Mes,  SeriesValor => Ano).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Aquí pode definir o eixo x. Vostede pode seleccionar un elemento mediante o botón radio.',
        'maximal period' => 'período máximo',
        'minimal scale' => 'escala mínima',

        # Template: AgentStatsImport
        'Import Stat' => 'Importación Estatística',
        'File is not a Stats config' => 'Arquivo non é configuración Estatística',
        'No File selected' => 'Non se seleccionou ningún ficheiro',

        # Template: AgentStatsOverview
        'Stats' => 'Estatísticas',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Non hai ningún elemento seleccionado.',

        # Template: AgentStatsView
        'Export config' => 'Exportar configuración',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Coa entrada e campos selectos vostede pode influír no formato e contidos da estatística.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Exactamente que campos e formatos pode influír vostede é definido polo administrador de estatística.',
        'Stat Details' => 'Detalles Estatística',
        'Format' => 'Formato',
        'Graphsize' => 'Tamaño do gráfico',
        'Cache' => 'Caché',
        'Exchange Axis' => 'Eixe de Intercambio',

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Parámetros configurables de estaísticas estaticas',
        'No element selected.' => 'Non hai ningún elemento seleccionado.',
        'maximal period from' => 'máximo período dende',
        'to' => 'a',
        'not changable for dashboard statistics' => 'non cambiable para estatísticas de cadro de mando',
        'Select Chart Type' => 'Seleccione Tipo de Gráfico',
        'Chart Type' => 'Tipo de gráfica',
        'Multi Bar Chart' => 'Gráfico Multi Barra',
        'Multi Line Chart' => 'Gráfico Multi Linea',
        'Stacked Area Chart' => 'Gráfico de Área Amoreada',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Cambie o Texto Libre do Ticket',
        'Change Owner of Ticket' => 'Cambie o Propietario do Ticket',
        'Close Ticket' => 'Pechar o tícket',
        'Add Note to Ticket' => 'Engadir unha nota ao tícket',
        'Set Pending' => 'Establezca Pendente',
        'Change Priority of Ticket' => 'Cambie Prioridade do Ticket',
        'Change Responsible of Ticket' => 'Cambie Responsable do Ticket',
        'All fields marked with an asterisk (*) are mandatory.' => 'Todos os campos marcados cun asterisco (*) son obrigatorios.',
        'Service invalid.' => 'Servizo incorrecto.',
        'New Owner' => 'Novo dono',
        'Please set a new owner!' => 'Por favor estableza novo propietario!',
        'Previous Owner' => 'Anterior Propietario',
        'Next state' => 'Estado seguinte',
        'For all pending* states.' => 'Para tódolos estados pendentes.',
        'Add Article' => 'Engadir un artigo',
        'Create an Article' => 'Crear un artigo',
        'Spell check' => 'Corrector ortográfico',
        'Text Template' => 'Modelo Texto',
        'Setting a template will overwrite any text or attachment.' => 'Establecer un modelo sobreescribira calquira texto ou anexo.',
        'Note type' => 'Tipo de nota',
        'Inform Agent' => 'Informar o Axente',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Informar os Axentes implicados',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Aquí pode seleccionar axentes adicionais os cales deberán recibir unha notificación respecto do novo artigo.',
        'Note will be (also) received by:' => 'A nota será recibida (tamén) por:',

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Facer rebotar o tícket',
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
        'Merge to' => 'Combinar con',
        'Invalid ticket identifier!' => 'Identificador de ticket inválido!',
        'Merge to oldest' => 'Combinar co máis antigo',
        'Link together' => 'Conéctese xunto',
        'Link to parent' => 'Ligar a pai',
        'Unlock tickets' => 'Desbloquear tickets',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Compoña resposta para ticket',
        'Please include at least one recipient' => 'Por favor inclúa polo menos un receptor',
        'Remove Ticket Customer' => 'Elimine Ticket Cliente',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Por favor elimine esta entrada e introdúzao unha nova co valor correcto.',
        'Remove Cc' => 'Elimine Cc',
        'Remove Bcc' => 'Elimine Bcc',
        'Address book' => 'Caderno de enderezos',
        'Date Invalid!' => 'A data é incorrecta!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Cambiar o cliente do tícket',
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
        'E-Mail Outbound' => 'Correo electrónico De Ida',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: primeiro tempo de resposta está por enriba (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: primeiro tempo de resposta vai estar por enriba en %s/%s!',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: o tempo de actualización vai estar por enriba en %s%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: o tempo de solución vai estar por enriba (%s%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: o tempo de solución vai estar por enriba en %s%s!',

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Encamiñar tícket: %s - %s',

        # Template: AgentTicketHistory
        'History of' => 'Historial de',
        'History Content' => 'Contido do historial',
        'Zoom view' => 'Vista zoom',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Combinación de tíckets',
        'You need to use a ticket number!' => 'Necsita un número de ticket!',
        'A valid ticket number is required.' => 'Un número de ticket válido é requirido.',
        'Need a valid email address.' => 'Precisa dun enderezo de correo electrónico correcto.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Mover Ticket',
        'New Queue' => 'Nova fila',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Seleccionar todo',
        'No ticket data found.' => 'Non se atoparon datos do ticket.',
        'Select this ticket' => 'Selecciones este ticket.',
        'First Response Time' => 'Tempo de Primeira Resposta',
        'Update Time' => 'Tempo Actualización',
        'Solution Time' => 'Tempo de Solución',
        'Move ticket to a different queue' => 'Mover ticket a unha cola diferente',
        'Change queue' => 'Cambiar a fila',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Cambiar as opcións de busca',
        'Remove active filters for this screen.' => 'Elimine os filtros activos para esta pantalla',
        'Tickets per page' => 'Tickets por páxina',

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

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Vista Texto Plano Email',
        'Plain' => 'Simple',
        'Download this email' => 'Descargue este email',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket-Info',
        'Accounted time' => 'Tempo intervención',
        'Linked-Object' => 'Obxecto-Relacionado',
        'by' => 'de',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Crear un tícket de proceso novo',
        'Process' => 'Proceso',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Rexistra Ticket nun Proceso',

        # Template: AgentTicketSearch
        'Search template' => 'Busque modelo',
        'Create Template' => 'Para crear un modelo',
        'Create New' => 'Crear novo',
        'Profile link' => 'Enlace de perfil',
        'Save changes in template' => 'Garde cambios no modelo',
        'Filters in use' => 'Filtros en uso',
        'Additional filters' => 'Filtros adicionais',
        'Add another attribute' => 'Engadir outro atributo',
        'Output' => 'Saída',
        'Fulltext' => 'Texto completo',
        'Remove' => 'Retirar',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Buscas nos atributos De, A, Cc, Tema e o corpo do artigo,  outros atributos primordiais co mesmo nome.',
        'Customer User Login' => 'Acceso de usuario cliente',
        'Attachment Name' => 'Nome do anexo',
        '(e. g. m*file or myfi*)' => '(p.ex. ome*fichiero ou omeufich*)',
        'Created in Queue' => 'Creado na Cola',
        'Lock state' => 'Estado do bloqueo',
        'Watcher' => 'Observador',
        'Article Create Time (before/after)' => 'Hora de creación do artigo (antes/despois)',
        'Article Create Time (between)' => 'Hora de creación do artigo (entre)',
        'Ticket Create Time (before/after)' => 'Crear Tempo Ticket (antes/despois)',
        'Ticket Create Time (between)' => 'Crear Tempo Ticket (entre)',
        'Ticket Change Time (before/after)' => 'Cambiar Tempo Ticket (antes/despois)',
        'Ticket Change Time (between)' => 'Cambiar Tempo Ticket (entre)',
        'Ticket Last Change Time (before/after)' => 'Tempo Último Cambio Ticket (antes/despois)',
        'Ticket Last Change Time (between)' => 'Tempo Último Cambio Ticket (entre)',
        'Ticket Close Time (before/after)' => 'Tempo Peche Ticket (antes/despois)',
        'Ticket Close Time (between)' => 'Tempo Peche Ticket (entre)',
        'Ticket Escalation Time (before/after)' => 'Tempo Escalado Ticket (antes/despois)',
        'Ticket Escalation Time (between)' => 'Tempo Escalado Ticket (entre)',
        'Archive Search' => 'Busca no arquivo',
        'Run search' => 'Comezar busca',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro de artigos',
        'Article Type' => 'Tipo de artigo',
        'Sender Type' => 'Tipo de Remitente',
        'Save filter settings as default' => 'Gardar axustes filtro como por defecto',
        'Event Type Filter' => 'Filtro de tipos de evento',
        'Event Type' => 'Tipo de evento',
        'Save as default' => 'Gardar como por defecto',
        'Archive' => 'Arquivo',
        'This ticket is archived.' => 'Este tícket está arquivado.',
        'Locked' => 'Bloqueado',
        'Linked Objects' => 'Obxectos ligados',
        'Change Queue' => 'Cambiar a fila',
        'There are no dialogs available at this point in the process.' =>
            'Non hai dialogos dispoñibles neste punto no proceso.',
        'This item has no articles yet.' => 'Este elemento non ten artigos aínda.',
        'Ticket Timeline View' => 'Ver Cronoloxía do Ticket',
        'Article Overview' => 'Vista Xeral Artigo',
        'Article(s)' => 'Artigo(s)',
        'Page' => 'Páxina',
        'Add Filter' => 'Engadir filtro',
        'Set' => 'Definir',
        'Reset Filter' => 'Restablecer Filtros',
        'Show one article' => 'Mostrar un artigo',
        'Show all articles' => 'Mostrar todos os artigos',
        'Show Ticket Timeline View' => 'Mostrar Vista Cronoloxía do Ticket',
        'Unread articles' => 'Artigos sen leer',
        'No.' => 'Nº.',
        'Important' => 'Importante',
        'Unread Article!' => 'Artigo non lido!',
        'Incoming message' => 'Mensaxe entrante',
        'Outgoing message' => 'Mensaxe de saída',
        'Internal message' => 'Mensaxe interna',
        'Resize' => 'Redimensionar',
        'Mark this article as read' => 'Marcar este artigo como lido',
        'Show Full Text' => 'Mostrar Texto Completo',
        'Full Article Text' => 'Texto Artigo Completo',
        'No more events found. Please try changing the filter settings.' =>
            'Non se atoparon máis eventos. Tente cambiando a configuración do filtro.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Para abrir enlaces no artigo seguinte, vostede podería necesitar apertar Ctrl ou Cmd ou chave Shift mentres fai clic no enlace (dependendo do seu explorador e OS).',
        'Close this message' => 'Pechar esta mensaxe',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Non é posíbel abrir este artigo! Talvez estea noutra páxina de artigo?',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Para protexer a súa privacidade bloqueouse contido remoto.',
        'Load blocked content.' => 'Cargar contido bloqueado',

        # Template: ChatStartForm
        'First message' => 'Primeiro mensaxe',

        # Template: CustomerError
        'Traceback' => 'Imprimir',

        # Template: CustomerFooter
        'Powered by' => 'Iniciar sesión',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Producíronse un ou máis erros!',
        'Close this dialog' => 'Pechar este diálogo',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Non se puido abrir á ventá despregable. Por favor deshabilite calquera bloqueador de despregables para esta aplicación.',
        'There are currently no elements available to select from.' => 'Actualmente non hai elementos dispoñíbeis dos que seleccionar.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Por favor apague o Modo de Compatibilidade en Internet Explorer!',
        'The browser you are using is too old.' => 'O navegador que usa é vello de máis.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS pode ser executado nunha enorme cantidade de navegadores; actualice a un destes.',
        'Please see the documentation or ask your admin for further information.' =>
            'Por favor vexa a documentación ou pregunte o seu administrador para mais información.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript non dispoñible',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Para experimentar co OTRS ten que activar o JavaScript no navegador.',
        'Browser Warning' => 'Aviso de Explorador',
        'One moment please, you are being redirected...' => 'Agarde un momentiño; vaise encamiñar...',
        'Login' => 'Iniciar sesión',
        'User name' => 'Nome do usuario',
        'Your user name' => 'O seu nome de usuario',
        'Your password' => 'O seu contrasinal',
        'Forgot password?' => 'Esqueceu o contrasinal?',
        'Log In' => 'Acceso',
        'Not yet registered?' => 'Aínda non se rexistrou?',
        'Request new password' => 'Solicitar un contrasinal novo',
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
        'You have unanswered chat requests' => 'Ten peticións de chat sen contestar',
        'Edit personal preferences' => 'Edite as preferencias persoais',
        'Logout %s %s' => 'Logout %s %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'Split Quote',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Acordo de nivel de servizo',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Reciba a benvida!',
        'Please click the button below to create your first ticket.' => 'Por favor faga clic no botón de abaixo para crear o seu primeiro ticket.',
        'Create your first ticket' => 'Cree o seu primeiro ticket',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Imprima Ticket',
        'Ticket Dynamic Fields' => 'Campos Dinámicos do Ticket',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'p.ex. 10*5155 ou 105658*',
        'Customer ID' => 'Identificador de cliente',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Busca de texto completo nos tickets (ex. "John*n" ou "Will*")',
        'Carbon Copy' => 'Copia',
        'e. g. m*file or myfi*' => 'p.ex. ome*fichiero ou omeufich*',
        'Types' => 'Tipos',
        'Time restrictions' => 'Restriccións de tempo',
        'No time settings' => 'Non hai configuración horaria',
        'Only tickets created' => 'Só tickets creados',
        'Only tickets created between' => 'Só tickets creados entre',
        'Ticket archive system' => 'Sistema de arquivo de ticket',
        'Save search as template?' => 'Garde a busca como modelo?',
        'Save as Template?' => 'Garde como Modelo?',
        'Save as Template' => 'Garde como Modelo',
        'Template Name' => 'Nome do modelo',
        'Pick a profile name' => 'Escolla un nome de perfil',
        'Output to' => 'Saída',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Search Results for' => 'Buscar resultados para',
        'Remove this Search Term.' => 'Elimine este Termo de Busca',

        # Template: CustomerTicketZoom
        'Expand article' => 'Expanda artigo',
        'Next Steps' => 'Pasos seguintes',
        'Reply' => 'Responder',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'Todo o día',
        'Sunday' => 'Domingo',
        'Monday' => 'Luns',
        'Tuesday' => 'Martes',
        'Wednesday' => 'Mércores',
        'Thursday' => 'Xoves',
        'Friday' => 'Venres',
        'Saturday' => 'Sábado',
        'Su' => 'Do',
        'Mo' => 'Lu',
        'Tu' => 'Sá',
        'We' => 'en',
        'Th' => 'Xo',
        'Fr' => 'Ve',
        'Sa' => 'Sá',
        'Event Information' => 'Información do evento',
        'Ticket fields' => 'Campos Ticket',
        'Dynamic fields' => 'Campos dinámicos',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'A data é incorrecta (ten que ser unha data futura)!',
        'Invalid date (need a past date)!' => 'A data é incorrecta (ten que ser unha data do pasado)!',
        'Previous' => 'Anterior',
        'Open date selection' => 'Abra selección de data',

        # Template: Error
        'Oops! An Error occurred.' => 'Oops! Un erro ocurriu.',
        'You can' => 'Vostede pode',
        'Send a bugreport' => 'Enviar un reporte de bugs',
        'go back to the previous page' => 'volte a páxina anterior',
        'Error Details' => 'Detalles do erro',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se vostede deixa agora esta páxina, todas as ventás despregables abertas serán pechadas, tamén!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Un despregable desta pantalla xa está aberto. Vostede quere pechalo e cargar en cambio este?',
        'Please enter at least one search value or * to find anything.' =>
            'Por favor introduza polo menos un valor de busca ou * para atopar calquera cousa.',
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Por favor elimine as palabras seguintes da súa busca porque elas non poden ser buscadas:',
        'Please check the fields marked as red for valid inputs.' => 'Por favor revise os campos marcados en vermello para entradas válidas.',
        'Please perform a spell check on the the text first.' => 'Por favor, realice una revisión ortográfica no primeiro el texto ',
        'Slide the navigation bar' => 'Desprazar a barra de navegación',

        # Template: Header
        'You are logged in as' => 'Está logeado como',
        'There are new chat requests available. Please visit the chat manager.' =>
            'Hai novas peticións de chat dispoñibles. Por favor visite o manager de chat.',

        # Template: Installer
        'JavaScript not available' => 'JavaScript non dispoñible',
        'Database Settings' => 'Configuración da base de datos',
        'General Specifications and Mail Settings' => 'Especificacións Xeráis e Axustes de Correo',
        'Welcome to %s' => 'Benvido a %s',
        'Web site' => 'Sitio web',
        'Mail check successful.' => 'Comprobación de correo satisfactoria.',
        'Error in the mail settings. Please correct and try again.' => 'Erro nos axustes de corre. Por favor corríxao e volva a intentalo.',

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
        'Database setup successful!' => 'A base de datos foi configurada correctamente!',

        # Template: InstallerDBStart
        'Install Type' => 'Tipo de instalación',
        'Create a new database for OTRS' => 'Cree unha nova base de datos para OTRS',
        'Use an existing database for OTRS' => 'Use unha base de datos existente para OTRS',

        # Template: InstallerDBmssql
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
        'Object#' => 'Obxecto nº',
        'Add links' => 'Engadir ligazóns',
        'Delete links' => 'Elimine enlaces',

        # Template: Login
        'Lost your password?' => 'Perdeu o seu contrasinal?',
        'Request New Password' => 'Solicitar un contrasinal novo',
        'Back to login' => 'Retornar á pantalla de acceso',

        # Template: Motd
        'Message of the Day' => 'Mensaxe do día',

        # Template: NoPermission
        'Insufficient Rights' => 'Dereitos insuficientes',
        'Back to the previous page' => 'Retornar á páxina anterior',

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

        # Template: PrintHeader
        'printed by' => 'imprimido por',

        # Template: Test
        'OTRS Test Page' => 'Páxina de probas do OTRS',
        'Welcome %s %s' => 'Benvido %s %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Volte a páxina anterior',

        # SysConfig
        ' (work units)' => '(unidades de traballo)',
        '"%s"-notification sent to "%s".' => '"%s"-notificación enviada a "%s".',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s unidad(es) de tempo considerado. Total %s unidad(es) de tempo agora.',
        '(UserLogin) Firstname Lastname' => '(Usuario) Nome Apelido',
        '(UserLogin) Lastname, Firstname' => '(Usuario) Apelido, Nome',
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
        'Activates support for customer groups.' => 'Activa a compatibilidade con grupos de clientes.',
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
        'Added email. %s' => 'Engadiuse o correo electrónico. %s',
        'Added link to ticket "%s".' => 'Engadiuse a ligazón ao ticket «%s».',
        'Added note (%s)' => 'Engadiuse unha nota (%s)',
        'Added subscription for user "%s".' => 'Engadiuse unha subscrición',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Engade un sufixo co ano e mes actuais ao arquivo OTRS log. Un logfile para cada mes será creado.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Engade enderezos de correo de clientes aos destinatarios na pantalla de redacción de tíckets da interface do axente. Os enderezos de correo dos clientes non se engaden se o tipo de artigo é correo interno.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Engade o tempo días de vacacións para o calendario indicado. Por favor utilice patrón de díxito simple para números do 1 ao 9 (en lugar de 01 - 09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Engade o tempo días de vacacións. Por favor utilice patrón de díxito simple para números do 1 ao 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Engade o tempo vacacións permanentes para o calendario indicado. Por favor utilice patrón de díxito simple para números do 1 ao 9 (en lugar de 01 - 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Engade o tempo permanente de vacacións. Por favor utilice patrón de díxito simple para números do 1 ao 9 (en lugar de 01 - 09).',
        'Agent Notifications' => 'Notificacións de axentes',
        'Agent called customer.' => 'Un axente chamou ao cliente.',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificación de artigo da interface de axente para comprobar PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificación de artigo da interface de axente para comprobar S/MIME.',
        'Agent interface module to access CIC search via nav bar.' => 'Módulo da interface de axente para acceder a busca CIC vía a barra de navegación.',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Módulo da interface de axente para acceder a busca de texto completo vía a barra de navegación.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Módulo da interface de axente para acceder a busca de perfís vía a barra de navegación.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo da interface de axente para comprobar correos electrónicos entrantes na Vist-Ticket-Zoom se a chave  S/MIME está dispoñible e é verdadeira.',
        'Agent interface notification module to see the number of locked tickets.' =>
            'Módulo de notificación da interface de axente para ver o número de tíckets bloqueados.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Módulo de notificación da interface de axente para ver o número de tickets dos que un axente é responsable.',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            'Módulo de notificación da interface de axente para ver o número de tickets nos Meu Servizos.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Módulo de notificación da interface de axente para ver o número de tickets mirados.',
        'Agents <-> Groups' => 'Axentes <-> Grupos',
        'Agents <-> Roles' => 'Axentes <-> Papeis',
        'All customer users of a CustomerID' => 'Todos os usuarios clientes dun identificador de cliente',
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
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Permite que os clientes indiquen a fila dos tíckets na interface do cliente. Se se indica que «Non», habería que configurar QueueDefault.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permite que os clientes indiquen o servizo dos tíckets na interface do cliente.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Permite que os clientes indiquen o tipo dos tíckets na interface do cliente. Se se indica que «Non», habería que configurar TicketTypeDefault.',
        'Allows default services to be selected also for non existing customers.' =>
            'Permite que os servizos por omisión sexan seleccionados tamén para clientes non existentes.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permitir á definición de novos tipos de ticket (se a función tipo de ticket está habilitada).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite a definición de servizos e ANSs para tickets (ex. email, desktop, rede...) e escalar atributos para os ANSs (se a función servizo de ticket/ANS está habilitada).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite condicións de busca estendidas na busca de ticket da interface de axente. Con esta función vostede pode buscar ex. con tipo de condicións como (key1&&key2) ou (key1||key2).',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permite condicións de busca estendidas nas buscas de tíckets da interface do cliente. Con esta funcionalidade pódese buscar, por exemplo, condicións tipo «(clave1&&clave2)» ou «(Clave1|Clave2)»',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter unha visión xeral de ticket de formato medio (CustomerInfo => 1 - mostra tamén a información de clientes).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite ter unha visión xeral de ticket de formato pequeno (CustomerInfo => 1 - mostra tamén a información de clientes).',
        'Allows invalid agents to generate individual-related stats.' => 'Permite que os axentes non correctos xeren estatísticas relacionadas con individuos.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Permite que os administradores accedan como outros clientes a través do panel de administración dos usuarios clientes.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permite que os administradores accedan como outros usuarios a través do panel de administración dos usuarios.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permite establecer un novo estado de ticket na pantalla de movemento do ticket da interface de axente.',
        'Archive state changed: "%s"' => 'Cambiou o estado do artigo: «%s»',
        'ArticleTree' => 'ÁrboreArtigos',
        'Attachments <-> Templates' => 'Anexos <-> Modelos',
        'Auto Responses <-> Queues' => 'Respostas automáticas <-> Filas',
        'AutoFollowUp sent to "%s".' => 'AutoSeguemento enviado a "%s".',
        'AutoReject sent to "%s".' => 'AutoRexeitar enviado a "%s".',
        'AutoReply sent to "%s".' => 'AutoRespota enviada a "%s".',
        'Automated line break in text messages after x number of chars.' =>
            'Salto de liña automatizada en mensaxes de texto despois de x número de carácteres.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Automaticamente bloqueado e establecido o propietario ao Axente actual despois de abrir a pantalla de movemento de ticket da interface de axente.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automaticamente bloqueado e establecido o propietario ao Axente actual despois de seleccionar unha Acción Masiva.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Automaticamente establecido o propietario do ticket ao responsable do mesmo (se a función de responsable do ticket está habilitada).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Establece automaticamente o responsable do ticket (se non está establecido ainda) despois da actualización do primeiro propietario.',
        'Balanced white skin by Felix Niklas (slim version).' => 'Apariencia blanca equilibrada por Felix Niklas (version slim).',
        'Balanced white skin by Felix Niklas.' => 'Apariencia blanca equilibrada por Felix Niklas ',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Axustes básicos de índice de texto completo. Execute "bin/otrs.RebuildFulltextIndex.pl" para xerar un novo índice.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Bloquea tódolos correos electrónicos entrantes que non teñen un número de ticket válido no tema con De: Enderezo de @example.com.',
        'Bounced to "%s".' => 'Rebotado para «%s».',
        'Builds an article index right after the article\'s creation.' =>
            'Constrúe un índice de artigo xusto despois da creación do artigo.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Montaxe exemplo CMD. Ignora os correos electrónicos onde unha CMD externa retorna nun STDOUT (correo será canalizado en STDIN de some.bin).',
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
        'Change password' => 'Cambiar o contrasinal',
        'Change queue!' => 'Cambiar a fila!',
        'Change the customer for this ticket' => 'Cambiar o cliente deste tícket.',
        'Change the free fields for this ticket' => 'Cambie os campos libres deste tícket',
        'Change the priority for this ticket' => 'Cambie a prioridade para este ticket',
        'Change the responsible person for this ticket' => 'Cambie a persoa responsable para este ticket',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Prioridade cambiada de "%s" (%s) a "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Cambiar propietario de tickets a todos (útil para ASP). Normalmente só o axente con permisos rw na cola do ticket vai ser mostrado.',
        'Checkbox' => 'Checkbox',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Comproba a IDSistema na detección do número de ticket para seguementos (empregue "No" se o IDSistema foi cambiado despois de usar o sistema).',
        'Closed tickets (customer user)' => 'Tíckets pechados (usuario cliente)',
        'Closed tickets (customer)' => 'Tíckets pechados (cliente)',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Filtro de columna de ticket para Vista Xeral de Ticket tipo "Pequeno".',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'As columnas que poden ser filtradas na vista de escalado da interface de axente. Posibles axustes: 0 = Deshabilitado, 1 = Habilitado, 2 = Permitido por defecto. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NomeX) son permitidos.',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'As columnas que poden ser filtradas na vista de bloqueo da interface de axente. Posibles axustes: 0 = Deshabilitado, 1 = Habilitado, 2 = Permitido por defecto. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NomeX) son permitidos.',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'As columnas que poden ser filtradas na vista da cola da interface de axente. Posibles axustes: 0 = Deshabilitado, 1 = Habilitado, 2 = Permitido por defecto. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NomeX) son permitidos.',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'As columnas que poden ser filtradas na vista de responsable da interface de axente. Posibles axustes: 0 = Deshabilitado, 1 = Habilitado, 2 = Permitido por defecto. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NomeX) son permitidos.',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'As columnas que poden ser filtradas na vista de servizo da interface de axente. Posibles axustes: 0 = Deshabilitado, 1 = Habilitado, 2 = Permitido por defecto. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NomeX) son permitidos.',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'As columnas que poden ser filtradas na vista de estado da interface de axente. Posibles axustes: 0 = Deshabilitado, 1 = Habilitado, 2 = Permitido por defecto. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NomeX) son permitidos.',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'As columnas que poden ser filtradas na vista de busca de ticket da interface de axente. Posibles axustes: 0 = Deshabilitado, 1 = Habilitado, 2 = Permitido por defecto. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NomeX) son permitidos.',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            'As columnas que poden ser filtradas na vista de reloxos da interface de axente. Posibles axustes: 0 = Deshabilitado, 1 = Habilitado, 2 = Permitidos por defecto. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NomeX) son permitidos.',
        'Comment for new history entries in the customer interface.' => 'Comentario para as entradas novas do historial na interface do cliente.',
        'Comment2' => 'Comentario2',
        'Company Status' => 'Estado da empresa',
        'Company Tickets' => 'Tíckets da empresa',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'O nome da empresa que se inclúe no correo saínte como X-Header.',
        'Configure Processes.' => 'Configure Procesos.',
        'Configure and manage ACLs.' => 'Configurar e xestionar as ACL.',
        'Configure your own log text for PGP.' => 'Configure o seu propio texto de log para PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Configure o axuste por defecto de TicketCampoDinamico. "Nome" define o campo dinámico que debe ser usado. "Valor" e o dato a ser establecido e "Evento" define o disparador do evento. Por favor comprobe o manual do desarrollador (http://doc.otrs.org/), capítulo "Ticket Event Module".',
        'Controls how to display the ticket history entries as readable values.' =>
            'Controla cómo mostrar o historial do ticket coma valores lexibles.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Controla se os clientes teñen a capacidade de ordenar os seus tíckets.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Controla se máis dunha das entradas pode ser establecida no novo ticket telefónico na interface de axente.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Controla se se permite ao administrador importar unha configuración do sistema gardada en SysConfig.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Controla se se permite ao administradorfacer cambios na base de datos vía AdminSelectBox.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Controla se as bandeiras vistas de ticket e artigo son eliminadas cando un ticket é arquivado',
        'Converts HTML mails into text messages.' => 'Convirte correos HTML en mensaxes de texto.',
        'Create New process ticket' => 'Crear un tícket de proceso novo',
        'Create and manage Service Level Agreements (SLAs).' => 'Crear e xestionar Acordos de Nivel de Servizo (SLA).',
        'Create and manage agents.' => 'Cree é xestione axentes.',
        'Create and manage attachments.' => 'Cree e xestione adxuntos.',
        'Create and manage customer users.' => 'Cree e xestione usuarios.',
        'Create and manage customers.' => 'Crear e xestionar clientes.',
        'Create and manage dynamic fields.' => 'Cree e xestione campos dinámicos.',
        'Create and manage event based notifications.' => 'Cree e xestione notificacións basadas en eventos.',
        'Create and manage groups.' => 'Cree e xestione grupos.',
        'Create and manage queues.' => 'Cree e xestione colas.',
        'Create and manage responses that are automatically sent.' => 'Cree e xestione respostas que son enviadas automáticamente.',
        'Create and manage roles.' => 'Crear e xestionar papeis.',
        'Create and manage salutations.' => 'Crear e xestionar saúdos.',
        'Create and manage services.' => 'Crear e xestionar servizos.',
        'Create and manage signatures.' => 'Crear e xestionar papeis sinaturas.',
        'Create and manage templates.' => 'Crear e xestionar modelos.',
        'Create and manage ticket priorities.' => 'Cree e xestione prioridades de ticket.',
        'Create and manage ticket states.' => 'Cree e xestione estados de ticket.',
        'Create and manage ticket types.' => 'Cree e xestione tipos de ticket.',
        'Create and manage web services.' => 'Crear e xestionar servizos web.',
        'Create new email ticket and send this out (outbound)' => 'Crear un novo ticket de correo electrónico é envíelo (saída)',
        'Create new phone ticket (inbound)' => 'Crear un novo ticket telefónico (entrada)',
        'Create new process ticket' => 'Crear un tícket de proceso novo',
        'Custom RSS Feed' => 'Custom RSS Feed',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Texto personalizada para a páxina que se lles mostra aos clientes que aínda non teñen tíckets (se precisa traducir eses textos, engádaos a un módulo de tradución personalizada).',
        'Customer Administration' => 'Administración de clientes',
        'Customer User <-> Groups' => 'Usuario cliente <-> Grupos',
        'Customer User <-> Services' => 'Usuario cliente <-> Servizos',
        'Customer User Administration' => 'Administración de usuarios clientes',
        'Customer Users' => 'Usuarios clientes',
        'Customer called us.' => 'O cliente chamounos a nós.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Elemento de cliente (icono) o cal mostra os tickets pechados deste cliente coma un bloque de información. Establecendo CustomerUserLogin a 1 busca por tickets baseado no nome do login en lugar de IDCliente. ',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Elemento de cliente (icono) o cal mostra os tickets abertos deste cliente coma un bloque de información. Establecendo CustomerUserLogin a 1 busca por tickets baseado no nome do login en lugar de IDCliente. ',
        'Customer request via web.' => 'Solicitude do cliente a través da web.',
        'Customer user search' => 'Busca de usuarios clientes',
        'CustomerID search' => 'Busca por identificador de cliente',
        'CustomerName' => 'NomeCliente',
        'Customers <-> Groups' => 'Clientes <-> Grupos',
        'Data used to export the search result in CSV format.' => 'Datos utilizados para exportar os resultados da busca en formato CSV.',
        'Date / Time' => 'Data / hora',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Depuracións a tradución establecida. Se isto é fixado a "Si" todas as cadeas (texto) sen traducións son escritas a STDERR. Isto pode ser útil cando está a crear un novo arquivo de tradución. Pola contra, esta opción debería permanecer coma "Non".',
        'Default ACL values for ticket actions.' => 'Valores ACL por defecto para as accións de ticket.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Prefixos da entidade XestiónProceso por defecto para IDs entidades que son automaticamente xeradas.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Datos por defecto para usar no atributo para a pantalla busca de ticket. Exemplo: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Datos por defecto para usar no atributo para a pantalla busca de ticket. Exemplo: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default loop protection module.' => 'Módulo de protección de bucle por defecto.',
        'Default queue ID used by the system in the agent interface.' => 'ID de cola por defecto utilizada polo sistema na interface de axente.',
        'Default skin for OTRS 3.0 interface.' => 'Aparencia predeterminada da interface de OTRS 3.0.',
        'Default skin for the agent interface (slim version).' => 'Aparencia predeterminada da interface do axente (versión lixeira).',
        'Default skin for the agent interface.' => 'Aparencia predeterminada da interface do axente.',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de ticket por defecto utilizado polo sistema na interface de axente.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de ticket por defecto utilizado polo sistema na interface de cliente.',
        'Default value for NameX' => 'Valor por defecto para NomeX',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para que a saída de html engada enlaces detrás dun string definido. A Imaxe do elemento permite dous tipos de entrada. Ao mesmo tempo o nome dunha imaxe (p.ej. faq.png). Neste caso a ruta da imaxe de OTRS será utilizada. A segunda posiblidade é introducir o enlace á imaxe.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            'Defina un mapeado entre variables dos datos de usuario (chaves) e campos dinámicos dun ticket (valores). O propósito é almacenar datos de usuario en campos dinámicos de ticket. Os campos dinámicos deben estar presentes no sistema e deberían ser permitidos para AgentTicketFreeText, para que poidan ser fixados/actualizados manualmente polo axente. Non se lles debe permitir para AgentTicketPhone, AgentTicketEmail e AgentTicketCustomer. Se o foran, terían precedencia sobre os valores automaticamente establecidos. Para usar este mapeado, vostede ten tamén que activar o axuste seguinte.',
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
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Defina un elemento de cliente, o cal vai xerar un icono de LinkedIn ao final do bloque de información do cliente.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Defina un elemento de cliente, o cal vai xerar un icono de XING ao final do bloque de información do cliente.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Defina un elemento de cliente, o cal vai xerar un icono de google ao final do bloque de información do cliente.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Defina un elemento de cliente, o cal vai xerar un icono de google maps ao final do bloque de información do cliente.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Defina unha lista por defecto de palabras, que van ser ignoradas polo corrector ortográfico.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para a saída de html que engada enlaces detrás dos números CVE. A Imaxe de elemento permite dous tipos de entrada. Á vez o nome dunha imaxe (p.ex. faq.png). Neste caso a ruta de imaxe de OTRS será utilizada. A segunda posibilidade é introducir o enlace á imaxe.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para a saída de html que engada enlaces detrás dos números MSBulletin. A Imaxe de elemento permite dous tipos de entrada. Á vez o nome dunha imaxe (p.ex. faq.png). Neste caso a ruta de imaxe de OTRS será utilizada. A segunda posibilidade é introducir o enlace á imaxe.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para a saída de html que engada enlaces detrás dun string definido. A Imaxe de elemento permite dous tipos de entrada. Á vez o nome dunha imaxe (p.ex. faq.png). Neste caso a ruta de imaxe de OTRS será utilizada. A segunda posibilidade é introducir o enlace á imaxe.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para a saída de html que engada enlaces detrás dos números bugtraq. A Imaxe de elemento permite dous tipos de entrada. Á vez o nome dunha imaxe (p.ex. faq.png). Neste caso a ruta de imaxe de OTRS será utilizada. A segunda posibilidade é introducir o enlace á imaxe.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Define un filtro para procesar o texto nos artigos, para subliñar palabras clave predefinidas.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Define unha expresión regular que exclúe algunos enderezos da comprobación da sintaxe (se "CheckEmailAddresses" está establecido a "Si"). Por favor introduzca unha expreg neste campo para enderezos de correo electrónico, que noon señan sintacticamente validos, pero necesarios para o sistema (ex. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Define unha expresión regular que filtre tódolos enderezos de correo electrónico que non deben ser usados na aplicación.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Define un módulo útil para cargar opcións de usuario específicas ou mostrar noticias.',
        'Defines all the X-headers that should be scanned.' => 'Define tódalas cabeceiras-X que deben ser escaneadas.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Define tódalas linguas que están dispoñibles para a aplicación. A parella Chave/Contido enlaza o nome a mostrar no front-end á lingua apropiada do arquivo PM. O valor "Clave" debería ser o nome base do arquivo PM (p. ex. de.pm é o arquivo, entón de é o valor "Clave"). O valor "Contido" debería ser o nome a mostrar para o front-end. Especifique calquera lingua propiamente definida aquí (vexa a documentación de desenvolvedores http://doc.otrs.org/ para máis infomation). Por favor acórdese de utilizar os equivalentes de HTML para carácteres non-ASCII (p. ex. para a diérese de oe = o do alemán, é necesario utilizar o símbolo &ouml;).',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Define tódolos parámetros para o obxecto RefreshTime nas preferencias de cliente da interface de cliente.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Define tódolos parámetros para o obxecto MostrarTickets nas preferencias de cliente da interface de cliente.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Define tódolos parámetros para este elemento nas preferencias de cliente.',
        'Defines all the possible stats output formats.' => 'Define tódolos posibles formatos de saída de estatísticas.',
        'Defines an alternate URL, where the login link refers to.' => 'Define unha URL alternativa, onde o enlace login se refire.',
        'Defines an alternate URL, where the logout link refers to.' => 'Define unha URL alternativa, onde o enlace logout se refire.',
        'Defines an alternate login URL for the customer panel..' => 'Define unha URL alternativa de login para o panel de cliente..',
        'Defines an alternate logout URL for the customer panel.' => 'Define unha URL alternativa de logout para o panel de cliente.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Define un enlace externo á base de datos do cliente (ex. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Define de que atributtos de ticket o axente pode seleccionara orde de resultado.',
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
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Define se mensaxes compostos deben ser comprobados ortograficamente na interface de axente.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Define se o modo realzado debería ser utilizado (permite uso de mesa, substituír, subscript, superscript, pegar dende palabra, etc).',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            'Define se a lista para filtros debería ser recuperada soamente de tickets actuais no sistema. Só para aclaración, lista de Clientes fará vir sempre dende os tickets do sistema.',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'Define se á contabilizar o tempo é obrigatorio na interface de axente. Se activado, unha nota debese introducir para todas as accións de ticket (non importa se a nota é configurada como activa ou é orixinalmente obrigatoria para a pantalla de acción de ticket individual).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Define se contabilizar o tempo debe ser establecido a tódolos tickets nunha acción masiva.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Define as colas nas que os tickets son usados para mostrar como eventos de calendario.',
        'Defines scheduler PID update time in seconds.' => 'Define planificador de tempo de actualización de PID en segundos.',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            'Define planificador de tempo de sono en segundos despois de procesar tódalas tarefas dispoñibles (número de punto flotante).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Define a expresión regular do IP para acceder ao repositorio local. Haino que activar para ter acceso completo ao repositorio local e o servidor remoto ten que ter package::RepositoryList.',
        'Defines the URL CSS path.' => 'Define a ruta CSS URL',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Define a ruta base URL para iconos, CSS e JavaScript.',
        'Defines the URL image path of icons for navigation.' => 'Define a ruta de imaxenes  URL para os iconos de navegación.',
        'Defines the URL java script path.' => 'Define a ruta java script URL',
        'Defines the URL rich text editor path.' => 'Define a ruta de texto enriquecido URL',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Define o enderezo do servidor dedicado DNS, se é necesario, para consultas "CheckMXRecord".',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Define o texto do corpo para correos de notificación enviados a axentes, sobre novo contrasinal (despois de usar este enlace o novo contrasinal vai ser enviado).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Define o texto de corpo para correos de notificación enviados a axentes, con sinal sobre novo contrasinal pedido (despois de usar este enlace o novo contrasinal será enviado).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Define o texto de corpo para correos de notificación enviados a clientes, sobre nova conta.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Define o texto de corpo para correos de notificación enviados a clientes, sobre novo contrasinal (despois de usar este enlace o novo contrasinal será enviado).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Define o texto de corpo para correos de notificación enviados a clientes, con sinal sobre novo contrasinal pedido (despois de usar este enlace o novo contrasinal será enviado).',
        'Defines the body text for rejected emails.' => 'Define o texto do corpo para correos rexeitados.',
        'Defines the boldness of the line drawed by the graph.' => 'Define el nivel de negrita da liña dibuxada polo gráfico.',
        'Defines the calendar width in percent. Default is 95%.' => 'Define a anchura de calendario en porcentaxe. Defecto é un 95%.',
        'Defines the colors for the graphs.' => 'Define os colores para os gráficos.',
        'Defines the column to store the keys for the preferences table.' =>
            'Define a columna para almacenar as chaves para a táboa de preferencias.',
        'Defines the config options for the autocompletion feature.' => 'Define as opcións de configuración da función autocompletar.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Define os parámetros de configuración deste elemento, para ser mostrado na vista de preferencias.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Define os parámetros de configuración deste elemento, para ser mostrados na vista de preferencias. Teña coidado para manter os dicionarios instalados no sistema na sección de datos.',
        'Defines the connections for http/ftp, via a proxy.' => 'Define as conexións para http/ftp, mediante un proxy.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Define o formato de entrada de datos utilizado en formularios (campos de opción ou entrada).',
        'Defines the default CSS used in rich text editors.' => 'Define o CSS utilizado por defecto en editores de texto enriquecido.',
        'Defines the default auto response type of the article for this operation.' =>
            'Define o tipo de resposta automatica por defecto do artigo para esta operación.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Define o corpo por defecto dunha nota na pantalla de texto libre do ticket da interface de axente.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Define o tema front-end (HTML) por defecto para ser usado por axentes é clientes. Se quere, pode engadir o seu propio tema. Por favor vexa o manual do administrador aloxado en http://doc.otrs.org/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Define o idioma do front-end por defecto. Tódolos posibles valores son determinados polos arquivos de idioma dispoñibles no sistema (vexa o axuste seguinte).',
        'Defines the default history type in the customer interface.' => 'Define o tipo de historico por defecto na interface de cliente.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Define a máxima cantidade de atributos do eixo-X por defecto para a escala de tempo.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Define por defecto á máxima cantidade de resultados de busca mostrados na páxina de visión xeral.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Define por defecto o próximo estado para un ticket despois do seguemento de cliente na interface de clientes.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define por defecto o próximo estado dun ticket despois de engadir unha nota, na pantalla de peche de ticket da interface de axente.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Define ó próximo estado por defecto dun ticket despois de engadir unha nota, na pantalla en masa de ticket da interface de axente.',
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
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define por defecto ó texto do corpo da nota para tickets telefónicos na pantalla ticket chamada entrante da interface de axente.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define por defecto ó texto do corpo da nota para tickets telefónicos na pantalla ticket chamada saínte da interface de axente.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Define por defecto a prioridade de seguemento de tickets de clientes na pantalla ticket zoom da interface de axente.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Define por defecto a prioridade de tickets de novos clientes da interface de axente.',
        'Defines the default priority of new tickets.' => 'Define as prioridades por defecto de novos tickets.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Define a cola por defecto para tickets de clientes da interface de cliente.',
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
        'Defines the default spell checker dictionary.' => 'Define o diccionario por defecto do corrector ortográfico.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Define o estado por defecto dos tickets dun novo cliente na interface de cliente.',
        'Defines the default state of new tickets.' => 'Define o estado por defecto de novos tickets.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define o tema por defecto para tickets telefónicos na pantalla ticket de chamada entrante da interface de axente.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define o tema por defecto para tickets telefónicos na pantalla ticket de chamada saínte da interface de axente.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Define o tema por defecto dunha nota na pantalla texto libre de ticket da interface de axente.',
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
        'Defines the default type for article in the customer interface.' =>
            'Define o tipo de artigo por defecto na interface cliente.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Define o tipo de mensaxe dianteiro por defecto na pantalla dianteira de ticket na interface axente.',
        'Defines the default type of the article for this operation.' => 'Define o tipo de artigo por defecto para esta operación.',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            'Define o tipo de mensaxe por defecto na pantalla saída de correo electrónico da interface axente.',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla pechar ticket da interface de axente.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla de ticket en masa da interface de axente.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla texto libre de ticket da interface de axente.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla nota de ticket da interface de axente.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla propietario de ticket dun ticket zoom da interface de axente.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla ticket pendente dun ticket zoom da interface de axente.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla ticket de chamada entrante da interface de axente.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla ticket de chamada saínte da interface de axente.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla prioridade de ticket dun ticket zoom da interface de axente.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Define o tipo de nota por defecto na pantalla responsable de ticket da interface de axente.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Define o tipo de nota por defecto na pantalla zoom de ticket da interface de cliente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Define o Módulo-Frontend usado por defecto se non foron dados os parámetros Acción da url na interface axente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Define o Módulo-Frontend usado por defecto se non foron dados os parametros Accion da url na interface cliente.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Define os valores porr defecto para os parametros de accion para el frontend público. El parametro de acción é usado nos scripts do sistema.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Define os tipos de remitentes visibles por defecto de un ticket (por defecto: cliente).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Define los campos dinámicos que usanse para mostrar eventos no calendario.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Define o filtro que procesa texto nos artigos, para resaltar as URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Define o formato das respostas na pantalla composición de ticket da interface axente ([% Data.OrigFrom | html %] é Dende 1:1, [% Data.OrigFromName | html %] é só nome real de Dende).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define o nome completo de dominio do sistema. Este axuste e usado coma unha variable, OTRS_CONFIG_FQDN que atópase en todolos formularios de mensaxeria usados pola aplicación, para construir enlaces a tickets dentro do seu sistema.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Define os grupos nos que está cada usuario cliente (se CustomerGroupSupport está activado e non se desexa xestionar cada usuario destes grupos).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Define a altura para o compoñente de editor de texto rico para esta pantalla. Introduza en número (pixeis) ou valor porcentual (relativo).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define a altura para o compoñente de editor de texto rico. Introduza en número (pixeis) ou valor porcentual (relativo).',
        'Defines the height of the legend.' => 'Define a altura da lenda.',
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
        'Defines the legend font in graphs (place custom fonts in var/fonts).' =>
            'Define a fonte da lenda nos gráficos (poñer fontes propias en var/fonts).',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define o tipo de enlace \'Normal\'. Se o nome da fonte e o nome do obxetivo conteñen o mesmo valor, o enlace resultante e un non direccional; doutra forma, o resultado é un enlace direccional.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define o tipo de enlace \'PaiFillo\'. Se o nome fonte e o nome obxetivo conteñen o mesmo valor, o enlace resultante e un non direccional; doutra forma, o resultado e un enlace direccional.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Define os grupos de tipos de enlace. Os tipos de enlace do mesmo grupo cancelan uns aos outros. Exemplo: Se ticket A é enlazado cun enlace \'Normal\' có ticket B, estos tickets non poden ser ligados adicionalmente cunha relación \'PaiFillo\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Define a lista de repositorios online. Outras instalacións poden empregarse coma repositorio, por exemplo: Chave="http://example.com/otrs/public.pl?Action=PublicRepository;File=" e Contido="Algún Nome".',
        'Defines the list of possible next actions on an error screen.' =>
            'Define a lista das posibles accións seguintes nunha pantalla de erro.',
        'Defines the list of types for templates.' => 'Define a lista de tipos para modelos.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Define o lugar para obter a lista de repositorios online para paquetes adicionais. Emprégase o primeiro resultado dispoñíble.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Define o módulo log para o sistema. "Arquivo" escribe tódolos mensaxes nun logfile dado, "SysLog" emprega o daemon syslog do sistema, ex. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Define o tamaño maximo (en bytes) para carga de arquivos vía o navegador. Alerta: Axustar esta opción a un valor moi baixo pode causar moitas máscaras na súa instancia de OTRS para parar de traballar (probablemente algunha máscara a cal colla entradas do usuario).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Define o tempo válido máximo (en segundos) para unha id de sesión.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            'Define a máxima lonxitude (en carácteres) para uns datos de planificador de tarefas. ALERTA: Non modifique este axuste a menos que vostede estea seguro da lonxitude da Base de datos actual para \'task_data\' arquivado da táboa \'scheduler_data_list\'.',
        'Defines the maximum number of pages per PDF file.' => 'Define o número máximo de páxinas por arquivo PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Define o número máximo de liñas citadas para ser engadidas as respostas.',
        'Defines the maximum size (in MB) of the log file.' => 'Define o tamaño máximo (en MB) do arquivo log.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Define o módulo que mostra a notificación xenérica na interface de axente. Ambos "Texto" - se configurado- ou os contidos de "Arquivo" van ser mostrados.',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Define o módulo que mostra tódolos clientes actualmente "logeados" na interface axente.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Define o módulo que mostra tódolos axentes actualmente "logeados" na interface de axente.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Define o módulo que mostra os axentes actualmente "logeados" na interface de cliente.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Define o módulo que mostra os clientes actualmente "logeados" na interface de cliente.',
        'Defines the module to authenticate customers.' => 'Define o módulo para autenticar clientes.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'Define o módulo para mostrar unha notificación en direntes interfaces nas diferentes ocasións para OTRS Business Solution™. ',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            'Define o módulo para mostrar unha notificación na interface de axente se o planificador non se está a executar.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Define o módulo para mostrar unha notificación na interface de axente, se o axente está "logeado" mentres ten fora da oficina activo.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Define o módulo para mostrar unha notificación na interface de axente, se o axente está "logeado" mentres ten o mantemento do sistema activo.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Define o módule para mostrar unha notificación na interface de axente, se o sistema está sendo empregado polo usuario administrador (normalmente non debe traballar coma administrador).',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Define o módulo para xerar recargas nas cabeceiras html dos sitios html, na interface de cliente.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Define o módulo para xerar recargas nas cabeceiras html dos sitios html.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Define o módulo para enviar correos electrónicos. "Enviarmail" usa directamente o binario sendmail do seu sistema operativo. Calquera dos mecanismos "SMTP" emprega un servidor mail específico (externo). "NonEnviarMail" non envía correos electrónicos e é útil para sistemas test.',
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
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Define o nome da táboa, onde as preferencias de cliente son almacenadas.',
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
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Define o seguinte estado dun ticket despois de engadir unha nota, na pantalla de ticket masivo da interface de axente.',
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
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Define o número de campos da cabeceira nos modulos frontend para engadir e actualizar filtros postmaster. Pode ser ata 99 campos.',
        'Defines the parameters for the customer preferences table.' => 'Define os parametros para a táboa de preferencias de cliente.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Define os parámetros para o cadro de mando do backend. "Cmd" usase para especificar comando con parámetros. "Grupo" emprégase para restrinxir o accesso ao plugin (ex. Grupo: admin;grupo1;grupo2;). "Defecto" indica se o plugin está habilitado por defecto ou se o usuario precisa habilitalo manualmente. "CacheTTl" indica o periodo de expiración da caché en minutos para o plugin.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Define os parámetros para o cadro de mando do backend. "Grupo" usase para restrinxir o acceso ao plugin (ex. Grupo: admin;grupo1;grupo2;). "Defecto" indica se o plugin está habilitado por defecto ou se o usuario precisa activalo manualmente. "CacheTTL" indica o periodo de expiración da cache en minutos para o plugin.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Define os parámetros para o cadro de mando do backend. "Grupo" usase para restrinxir o acceso ao plugin (ex. Grupo: admin;grupo1;grupo2;). "Defecto" indica se o plugin está habilitado por defecto ou se o usuario precisa activalo manualmente. "CacheTTLLocal" define o periodo de expiración da cache en minutos para o plugin.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Define os parámetros para o cadro de mando do backend. "Limit" define o número de entradas mostradas por defecto "Grupo" usase para restrinxir o acceso ao plugin (ex. Grupo: admin;grupo1;grupo2;). "Defecto" indica se o plugin está habilitado por defecto ou se o usuario precisa activalo manualmente. "CacheTTL" indica o periodo de expiración da cache en minutos para o plugin. ',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Define os parámetros para o cadro de mando do backend. "Limit" define o número de entradas mostradas por defecto "Grupo" usase para restrinxir o acceso ao plugin (ex. Grupo: admin;grupo1;grupo2;). "Defecto" indica se o plugin está habilitado por defecto ou se o usuario precisa activalo manualmente. "CacheTTLLocal" define o periodo de expiración da cache en minutos para o plugin. ',
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
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            'Define a ruta do planificador para almacenar a saída de consola (SchedulerOUT.log and SchedulerERR.log).',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Define a ruta do arquivo de información mostrado, que está localizado baixo Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Define a ruta ao binario PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Define a ruta do binario ssl aberto. Pode necesitar un HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'Define a colocación da lenda. Isto debería ser dúas chave de carta da forma: \'B[LCR]|R[TCB]. A primeira carta indica a colocación (Inferior ou Á Dereita), e a segunda carta a aliñación (Á esquerda, Á Dereita, Centro, Superior, ou Inferior).',
        'Defines the postmaster default queue.' => 'Define a cola por defecto de postmaster.',
        'Defines the priority in which the information is logged and presented.' =>
            'Define a prioridade na que á información é logeada e presentada. ',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'Define ó receptor obxectivo do ticket telefónico e o remitente do ticket de correo electrónico ("Cola" mostra todas as colas, "Enderezo de sistema" mostra todos os enderezos de sistema) na interface de axente.',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'Define ó receptor obxectivo dos tickets ("Cola" mostra todas as colas, "Enderezo de sistema" mostra todos os enderezos de sistema) na interface de cliente.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Define os permisos requiridos para mostrar un tícket na vista de escalado da interface de axente.',
        'Defines the search limit for the stats.' => 'Define os limite de busca para as estatísticas.',
        'Defines the sender for rejected emails.' => 'Define o remitente para correos electrónicos rexeitados.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Define o separador entre o nome real de axentes e a cola dada de enderezo de correo.',
        'Defines the spacing of the legends.' => 'Define o espaciado das lendas.',
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
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Define os campos do ticket que van ser mostrados eventos de calendario. A "Chave" define o atributo de campo ou ticket e o "Contido" define o nome de mostra.',
        'Defines the time in days to keep log backup files.' => 'Define o tempo en días para manter o log dos arquivos de recuperación.',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            'Define o tempo en segundos despois do cal o Planificador executa un reinicio automatico.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Define a zona horaria do calendario indicado, o cal pode ser asignado despois a unha cola especifica.',
        'Defines the title font in graphs (place custom fonts in var/fonts).' =>
            'Define a fonte do título nos gráficos (poña fontes propias en var/fonts).',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define o tipo de protocolo, utilizado polo servidor web, para servir a aplicación. Se o protocolo de https é utilizado en lugar de http sinxelo, debe ser especificado aquí. Debido a  que isto non ten ningún efecto nos axustes ou comportamento do servidor web, non cambiará o método de acceso na aplicación e, se está equivocado, non lle impedirá que rexistrarse na aplicación. Este axuste é soamente utilizado como unha variable, OTRS_CONFIG_HttpType que é atopado en todas as formas de mensaxería utilizada pola aplicación, para construír enlaces aos tickets dentro do seu sistema.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Define o carácter utilizado para citas de correo electrónico de texto plano na pantalla composición de ticket da interface de axente. Se isto é baleiro ou inactivo, correos electrónicos orixinais non serán citados senón que engadidos á resposta.',
        'Defines the user identifier for the customer panel.' => 'Define o identificador de usuario para o panel de cliente.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Define o nome de usuario para manexar o acceso SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Define os tipos de estado validos para un ticket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Define os estados validos para tickets non bloqueados. Para desbloquear los tickets o script "bin/otrs.UnlockTickets.pl" pode ser usado.',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Define os bloqueos visibles dun ticket. Defecto: unlock, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Define a anchura para o compoñente do editor de texto rico para esta pantalla. Introduzca número (pixeis) ou valor de porcentaxe (relativo).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define a anchura para o compoñente do editor de texto rico. Introduzca número (pixeis) ou valor da porcentaxe (relativa).',
        'Defines the width of the legend.' => 'Define a anchura da lenda.',
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
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Define cal tipo de artigo debe ser expandido cando accedemos a vista xeral. Se non se define nada, o derradeiro artigo será expandido.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Define, cales tickets de cal tipo de estado de ticket non deben ser listados en listas de ticket enlazadas.',
        'Deleted link to ticket "%s".' => 'Enlace eliminado ao ticket "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Elimina unha sesión se o id de sesión foi empregado un enderexo IP remoto invalido.',
        'Deletes requested sessions if they have timed out.' => 'Elimina as sesións solicitadas se se lles esgotou o tempo.',
        'Deploy and manage OTRS Business Solution™.' => 'Despregue e dirixa OTRS Business Solution™.',
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
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determina a seguinte pantalla despois dun novo ticket de cliente na interface de clientes.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Determina a seguinte pantalla despois da pantalla de seguemento dun ticket zoom na interface de clientes.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Determina a seguinte pantalla despois de que un ticket é movido. LastScreenOverview devolverá a última pantalla de visión xeral (p. ex. resultados de busca, vistacola, cadro de mando). TicketZoom volverá ao TicketZoom.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determina os posibles estados para tickets pendentes que cambiaban de estado despois de que alcanza o límite de tempo.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Determina os strings que serán mostrados como receptor (A:) do ticket telefónico e como remitente (De:) do ticket de correo electrónico na interface de axente. Para Cola como NewQueueSelectionType "<Cola>" ensina os nomes das colas e para SystemAddress "<nomeReal> <<Email>>" ensina o nome e correo electrónico do receptor.',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Determina os strings que serán mostrados como receptor (A:) do ticket na interface de cliente. Para Cola como CustomerPanelSelectionType, "<Cola>" ensina os nomes das colas, e para SystemAddress "<nomeReal> <<Email>>" ensina o nome e correo electrónico do receptor.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determina a forma en que os obxetos ligados son mostrados en cada máscara de zoom.',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Determina que opcións van ser válidas para o receptor (ticket telefónico) e o remitente (ticket de correo electrónico) na interface de axente.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Determina cales colas van ser validas para receptores de tickets na interface de cliente.',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            'Desactive seguridade restrinxida para IFrames dentro IE. Pode ser pedido para que SSO traballe en IE8.',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Desactiva envio notificacións de recordatorio ao axente responsable dun ticket(Ticket::Responsible necesita ser activado).',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            'Desactiva o instalador web  (http://yourhost.example.com/otrs/installer.pl), para evitar que o sistema poda ser secuestrado. Se se configura como «Non», o sistema pode ser reinstalado e a configuración básica actual é a que se emprega para responder as preguntas que faga o script de instalación. Se non está activo, tamén desactiva GenericAgent, PackageManager e SQL Box.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'Mostra unha alerta e prevén a busca cando se usan palabras de parada dentro dunha busca de texto completo.',
        'Display settings to override defaults for Process Tickets.' => 'Mostra axustes para sobreescribir os Procesos Tickets por defecto.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Mostra o tempo rexistrado para un artigo na vista zoom de ticket.',
        'Dropdown' => 'Despregable',
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
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Límite campos dinámicos por páxina para Vista Xeral Campos Dinámicos',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Opcións de campos dinámicos mostrados na pantalla de mensaxe de ticket da interface de cliente. Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido. NOTA. Se queremostrar estos campos tamén no ticket zoom da interface de cliente, debe activalos en CustomerTicketZoom###DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opcións de campos dinámicos na pantalla de saída de correo electrónico da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de saída de correo electrónico da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados no proceso de widget na pantalla ticket zoom da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados na barra lateral da pantalla zoom de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de ticket pechado da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de composición de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de ticket de correo electrónico da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de avanzar ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla texto libre de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados na pantalla vista xeral formato medio de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de mover ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de nota de  ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla vista xeral de ticket da interface de cliente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de propietario de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla ticket pendente da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de ticket de chamada entrante da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de ticket de chamada saínte da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de ticket telefónico da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados na pantalla formato vista xeral de vista previa de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados na pantalla imprimir ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados na pantalla imprimir ticket da interface de cliente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla prioridade de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Campos dinámicos mostrados na pantalla de responsable de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados na pantalla de vista xeral de resultados da busca de ticket da interface de cliente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            'Campos dinámicos mostrados na pantalla de busca de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados na pantalla de busca de ticket da interface de cliente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Campos dinámicos mostrados na pantalla de vista xeral formato pequeno de ticket da interface de axente.  Axustes posibles: 0 = Desactivado, 1 = Activado, 2 = Activado e requerido.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Campos dinámicos mostrados na pantalla zoom de ticket da interface de cliente.  Axustes posibles: 0 = Desactivado, 1 = Activado.',
        'DynamicField backend registration.' => 'Rexistro backend CampoDinamico.',
        'DynamicField object registration.' => 'Rexistro obxeto CampoDinamico.',
        'Edit customer company' => 'Editar a empresa do cliente',
        'Email Addresses' => 'Enderezos de Correo Electronico',
        'Email sent to "%s".' => 'Correo Electrónico enviado a "%s".',
        'Email sent to customer.' => 'Mensaxe de correo enviada ao cliente.',
        'Enable keep-alive connection header for SOAP responses.' => 'Activar a cabeceira da conexión manterse-viva para respostas SOAP.',
        'Enabled filters.' => 'Filtros activos.',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Activa saída PDF. O módulo CPAN PDF::API2 e requirido, se non está instalado, a saída PDF será desactivada.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Activa a compatibilidade con PGP. Cando a compatibilidade con PGP está activada para asinar e cifrar correo, recoméndase MOITO que o servidor web se execute como usuario OTRS. Caso contrario, haberá problemas cos privilexios ao acceder ao cartafol .gnupg.',
        'Enables S/MIME support.' => 'Activa a compatibilidade con S/MIME.',
        'Enables customers to create their own accounts.' => 'Permite que os clientes creen as súas propias contas.',
        'Enables file upload in the package manager frontend.' => 'Activa o envío de ficheiros na interface do xestor de paquetes.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Activa ou desactiva o cacheado de modelos. ALERTA: NON desactive cacheado para contorno de producción para él pois causará unha baixada do rendemento! Este axuste soamente debe ser desactivado por razóns de debugging!',
        'Enables or disables the debug mode over frontend interface.' => 'Activa ou desactiva o modo debug sobre a interface frontend.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Activa ou desactiva a función visor de ticket, para ter un seguemento de tickets sen ser o propietario nin o responsable.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Active o log de rendemento (para facer log do tempo de resposta da páxina). Vai afectar o rendemento do sistema. Frontend::Module###AdminPerformanceLog bebe ser activado.',
        'Enables spell checker support.' => 'Activa a compatibilidade coa corrección ortográfica.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Permite o tamaño de contador de ticket mínimo (se "Data" foi seleccionado como TicketNumberGenerator)',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Permite función de acción en masa do ticket para o frontend de axente para traballar en máis dun ticket á vez.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Permite función de acción en masa de ticket soamente para os grupos enumerados.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Permite función responsable de ticket, para seguimento dun ticket específico.',
        'Enables ticket watcher feature only for the listed groups.' => 'Permite función de visor de ticket soamente para os grupos listados.',
        'Enroll this ticket into a process' => 'Inscríbase este ticket nun proceso',
        'Escalation response time finished' => 'Tempo resposta escalado terminado',
        'Escalation response time forewarned' => 'Tempo resposta escalado agravado',
        'Escalation response time in effect' => 'Tempo resposta escalado en efecto',
        'Escalation solution time finished' => 'Tempo solución escalado terminado',
        'Escalation solution time forewarned' => 'Tempo solución escalado agravado',
        'Escalation solution time in effect' => 'Tempo solución escalado en efecto',
        'Escalation update time finished' => 'Tempo actualización escalado terminado',
        'Escalation update time forewarned' => 'Tempo actualización escalado agracado',
        'Escalation update time in effect' => 'Tempo actualización escalado en efecto',
        'Escalation view' => 'Vista Escalado',
        'EscalationTime' => 'TempoEscalado',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Rexistro módulo evento. Para maior rendemento pode definir un disparador de evento (ex. Event => CrearTicket).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Rexistro módulo evento. Para maior rendemento pode definir un disparador de evento (ex. Event => CrearTicket). Isto só e posible se tódolos campos dinámicos de Ticket necesitan o mesmo evento.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Módulo de evento que executa unha sentenza de actualización en IndiceTicket para renomear o nombe da cola se necesario e se StaticDB e usado actualmente.',
        'Event module that updates customer user service membership if login changes.' =>
            'Módulo de evento que actualiza a afiliación ao servizo de usuario do cliente se o login cambia.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Módulo de evento que actualiza os usuarios clientes despois de unha actualización de Cliente.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Módulo de evento que actualiza os tickets despois dunha actualización do Cliente Usuario.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Módulo evento que actualiza os tickets despois dunha actualización do Cliente.',
        'Events Ticket Calendar' => 'Clendario Eventos Ticket',
        'Execute SQL statements.' => 'Executar sentenzas SQL.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Executar comprobacións de seguemento en En-Responder-A ou Referencias cabeceiras para correos que non teñen número de ticket no tema.',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            'Executa un seguemento aos adxuntos do correo comprobando en correos que non teñen número de ticket no tema.',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            'Executa seguemento no corpo do correo comprobando se os correos non teñen número de ticket no tema.',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            'Executa seguemento no plano/cru do correo comprobando se os correos non teñen número de ticket no tema.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Exporta á árbore do artigo completo no resultado da busca (esto pode afectar o rendemento do sistema).',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Obtén paquetes a través dun proxy. Substitúe «WebUserAgent::Proxy».',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'O Arquivo que é mostrado no módulo Kernel::Modules::AgentInfo, se localizado baixo Kernel/Output/HTML/Standard/AgentInfo.dtl.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filtro para debug ACLs. Nota: Mais atributos de tickets poden ser engadidos no formato <OTRS_TICKET_Atribute> ex. <OTRS_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Filtro para debug Transicións. Nota: Mais filtros poden ser engadidos no formato <OTRS_TICKET_Atributte> ex. <OTRS_TICKET_Priority>.',
        'Filter incoming emails.' => 'Filtro para correos electrónicos entrantes.',
        'First Queue' => 'Primeira Cola',
        'FirstLock' => 'PrimeiroBloqueo',
        'FirstResponse' => 'PrimeiraResposta',
        'FirstResponseDiffInMin' => 'PrimeiraRespostaDifEnMin',
        'FirstResponseInMin' => 'PrimeiraRespostaEnMin',
        'Firstname Lastname' => 'Nome Apelidos',
        'Firstname Lastname (UserLogin)' => 'Nome Apelidos (UsuarioLogin)',
        'FollowUp for [%s]. %s' => 'Seguimento para [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Forza codificar os correos electrónicos de saída (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Forza a elexir un estado de ticket diferente (do actual) despois da acción de bloqueo. Define o estado actual coma chave, e o seguinte estado despois da acción de bloqueo coma contido.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Forza a desbloquear tickets despois de ser movidos a outra cola.',
        'Forwarded to "%s".' => 'Encamiñado a «%s».',
        'Frontend language' => 'Lingua frontend',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            'Rexistro módulo frontend (desactivar enlace AxenteTicketServizo se á función Ticket Servizo non é usada).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Rexistro módulo frontend (desactivar enlace compañía se á función compañía non é usada).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Rexistro módulo frontend (desactivar pantalla proceso ticket se non hai proceso dispoñible) para Cliente.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Rexistro módulo frontend (desactivar pantalla proceso ticket se non hai proceso dispoñible).',
        'Frontend module registration for the agent interface.' => 'Rexistro módulo frontend para a interface de axente.',
        'Frontend module registration for the customer interface.' => 'Rexistro módulo frontend para a interface de cliente.',
        'Frontend theme' => 'Tema frontend',
        'Fulltext index regex filters to remove parts of the text.' => 'Filtros expresión regular índice de texto completo para eliminar partes do texto.',
        'Fulltext search' => 'Busca de texto completo',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            'Datos xenerais de ticket mostrados nas vistas xenerais de ticket (retroceder). Axustes posibles: 0 = Desactivado, 1 = Dispoñible, 2 = Activado por defecto. Lembre que NúmeroTicket non pode ser desactivado, porque é necesario.',
        'GenericAgent' => 'AxenteXenérico',
        'GenericInterface Debugger GUI' => 'InterfaceXenérica Depurador GUI',
        'GenericInterface Invoker GUI' => 'InterfaceXenérica Invocador GUI',
        'GenericInterface Operation GUI' => 'InterfaceXenérica Operación GUI',
        'GenericInterface TransportHTTPREST GUI' => 'InterfaceXenérica TransporteHTTPREST GUI',
        'GenericInterface TransportHTTPSOAP GUI' => 'InterfaceXenérica TransporteHTTPSOAP GUI',
        'GenericInterface Web Service GUI' => 'InterfaceXenérica Servizo Web GUI',
        'GenericInterface Webservice History GUI' => 'InterfaceXenérica Histórico Servizo Web GUI',
        'GenericInterface Webservice Mapping GUI' => 'InterfaceXenérica Mapeado Servizo Web GUI',
        'GenericInterface module registration for the invoker layer.' => 'InterfaceXenérica módulo rexistro para a capa do invocador.',
        'GenericInterface module registration for the mapping layer.' => 'InterfaceXenérica módulo rexistro para a capa do mapeado.',
        'GenericInterface module registration for the operation layer.' =>
            'InterfaceXenérica módulo rexistro para a capa de operación.',
        'GenericInterface module registration for the transport layer.' =>
            'InterfaceXenérica módulo rexistro para a capa de transporte.',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'Da a posibilidade aos usuarios finales de sobreescribir o caracter separador para arquivos CSV, definidos nos arquivos de traducción.',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'Garante o acceso, se o ID de cliente do ticket coincide co ID do cliente usuario e o cliente usuario ten permisos de grupo na cola na que está o ticket.',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'Axuda estender a súa busca de texto completo de artigos (De, A, Cc, Tema e busca de Corpo). Runtime fará a texto completo buscas en datos vivos (funciona ben ata 50.000 tickets). StaticDB espirá todos os artigos e construirá un índice despois da creación de artigo, aumentando buscas de texto completo cerca dun 50%. Para crear un índice de uso inicial "bin/otrs.RebuildFulltextIndex.pl".',
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
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Se "BD" foi seleccionada para Customer::AuthModule, o tipo criptográfico dos contrasináis debe ser especificado.',
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
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'Se "SysLog" foi seleccionado para LogModulo, un especial log sock pode ser especificado (en solaris pode necesitar usar \'stream\').',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Se "SysLog" foi seleccionado para LogModulo, o conxunto de carácteres que debe ser usado para logearse pode ser especificado.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Se "Arquivo" foi seleccionado para LogModulo, un arquivo log debe ser especificado. Se o arquivo non existe, será creado polo sistema.',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla ticket pechado da interface de axente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla ticket masivo da interface de axente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla texto libre de ticket da interface de axente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla nota de ticket da interface de axente.',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla responsable do ticket da interface de axente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla propietario do ticket dun ticket zoom da interface de axente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla ticket pendente dun ticket zoom da interface de axente.',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Se unha nota é engadida por un axente, establece o estado dun ticket na pantalla prioridade do ticket dun ticket zoom da interface de axente.',
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
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'Se habilitado, OTRS proporcionará tódolos arquivos de CSS en forma minimizada. ALERTA: Se vostede apaga isto, probablemente haberá problemas en IE 7, porque non pode cargar máis de 32 arquivos de CSS.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Se habilitado, OTRS proporcionará tódolos arquivos JavaScript en forma minimizada.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Se habilitado, TicketTelefónico e TicketEmail serán abertos en novas ventás.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            'Se habilitado, o tag da versión OTRS será eliminado da interface Web, das cabeceiras HTTP e das cabeceiras-X dos correos saíntes.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'Se habilitado, o cliente pode buscar tickets en tódolos servizos (independentemente de que servizos sexan asignados ao cliente).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Se habilitado, as distintas vistas xerais (Cadro de mando, VistaBloqueada, VistaCola) recargará automaticamente despois do tempo especificado.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Se habilitado, o primeiro nivel do menu principal abriráse o pasar o rato por enriba (en lugar de só o facer clic).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            'Se é fixado, este enderezo é utilizado como cabeceira de remitente de sobre en notificacións de saída. Se ningún enderezo é especificado, a cabeceira de remitente de sobre está baleira.',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Se é fixado, este enderezo é utilizado como remitente de sobre en mensaxes de saída (non notificacións - vexa abaixo). Se ningún enderezo é especificado, o remitente de sobre é igual o enderezo de correo electrónico da cola.',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            'Se esta opción é permitida, entón os datos desencriptados serán almacenados na base de datos se son mostrados en AxenteTicketZoom.',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            'Cando esta opción é «Si», os tíckets creados mediante a interface web, a través de clientes ou axentes, reciben unha resposta automática, de estar configurada. Se a opción é «Non», non se envían respostas automáticas.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Se esta ExpReg coincide, ningún mensaxe vai ser enviado pola autoresposta.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'Se vostede quere utilizar unha base de datos espello para busca de texto completo de ticket de axente ou xerar estatísticas, especifique o DSN a esta base de datos.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'Se vostede quere utilizar unha base de datos espello para busca de texto completo de ticket de axente ou xerar estatísticas, o contrasinal para autenticarse a esta base de datos pode ser especificado.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'Se vostede quere utilizar unha base de datos espello para busca de texto completo de ticket de axente ou xerar estatísticas, o usuario para autenticarse a esta base de datos pode ser especificado.',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            'Ignora artigo con tipo de remitente de sistema para nova función de artigo (ex. auto respostas ou notificacións de correo electrónico).',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Inclúe tempo creación artigo na busca de ticket da interface de axente.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'IndexAccelerator: elixir o seu módulo de backend TicketViewAccelerator. "RuntimeDB" xera cada visión de cola no momento dende táboa de ticket(ningún problema de rendemento ata aprox. 60.000 tickets en total e 6.000 tickets abertos no sistema). "StaticDB" é o módulo máis potente, utiliza unha táboa de índice de ticket extra que funciona como unha vista (recomendada se máis de 80.000 e 6.000 billetes abertos son gardados no sistema). Utilice o script "bin/otrs.RebuildTicketIndex.pl" para actualización de índice inicial.',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'Instale ispell ou aspell no sistema de desexa empregar un corrector ortográfico. Indique a ruta ao binario de aspell ou de ispell no seu sistema operativo.',
        'Interface language' => 'Idioma da interface',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'É posible configurar aparencias diferentes, para por exemplo distinguir entre axentes diferentes, para ser utilizados nunha base de por dominio dentro da aplicación. Utilizando unha expresión regular (regex), vostede pode configurar un Chave/Contido par para coincidir un dominio. O valor en "Chave" debería coincidir co dominio, e o valor en "Contido" debería ser unha apariencia válida no seu sistema. Por favor vexa as entradas de exemplo para a forma correcta da regex.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'É posible configurar aparencias diferentes, para por exemplo distinguir entre clientes diferentes, para ser utilizados nunha base de por dominio dentro da aplicación. Utilizando unha expresión regular (regex), vostede pode configurar un Chave/Contido par para coincidir un dominio. O valor en "Chave" debería coincidir co dominio, e o valor en "Contido" debería ser unha aparencia válida no seu sistema. Por favor vexa as entradas de exemplo para a forma correcta do regex.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'É posible configurar temas diferentes, para por exemplo distinguir entre axentes e clientes, para ser utilizados nunha base de por dominio dentro da aplicación. Utilizando unha expresión regular (regex), vostede pode configurar un Chave/Contido par para igualar un dominio. O valor en "Chave" debería coincidir co dominio, e o valor en "Contido" debería ser unha tema válido no seu sistema. Por favor vexa as entradas de exemplo para a forma correcta do regex.',
        'Lastname, Firstname' => 'Apelido, Nome',
        'Lastname, Firstname (UserLogin)' => 'Apelido, Nome (Nome de usuario)',
        'Left' => 'Esquerda',
        'Link agents to groups.' => 'Ligar axentes a grupos.',
        'Link agents to roles.' => 'Ligar axentes a papeis.',
        'Link attachments to templates.' => 'Ligar anexos a modelos.',
        'Link customer user to groups.' => 'Ligar usuario cliente a grupos.',
        'Link customer user to services.' => 'Ligar usuario cliente a servizos.',
        'Link queues to auto responses.' => 'Enlaza colas con auto respostas.',
        'Link roles to groups.' => 'Ligar papeis a grupos.',
        'Link templates to queues.' => 'Ligar modelos a filas.',
        'Links 2 tickets with a "Normal" type link.' => 'Enlaza 2 tickets con tipo de enlace "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Enlaza 2 tickets con tipo de enlace "PaiFillo".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista de arquivos CSS para estar sempre cargados para a interface de axente.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Lista de arquivos CSS para estar sempre cargados para a interface de cliente.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Lista de arquivos CSS especificos de IE-8 para estar sempre cargados para a interface de axente.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Lista de arquivos CSS especificos de IE-8 para estar sempre cargados para a interface de cliente.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista de arquivos JS para estar sempre cargados para a interface de axente.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Lista de arquivos JS para estar sempre cargados para a interface de cliente.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Lista de tódolos eventos de ClienteCompañia para ser mostrados na GUI.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Lista de tódolos eventos de ClienteUsuario para ser mostrados na GUI.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Lista de tódolos eventos de CampoDinamico para ser mostrados na GUI.',
        'List of all Package events to be displayed in the GUI.' => 'Lista de eventos de paquete que se mostran na interface gráfica.',
        'List of all article events to be displayed in the GUI.' => 'Lista de tódolos eventos de artigo para ser mostrados na GUI.',
        'List of all queue events to be displayed in the GUI.' => 'Lista de tódolos eventos de cola para ser mostrados na GUI.',
        'List of all ticket events to be displayed in the GUI.' => 'Lista de tódolos eventos de ticket para ser mostrados na GUI.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Lista de los Modelos Estandard por defecto os cales son asignados automaticamente a novas Colas sobre á creación.',
        'List view' => 'Vista de lista',
        'Locked ticket.' => 'Tícket bloqueado.',
        'Log file for the ticket counter.' => 'Arquivo log para o contador de ticket.',
        'Loop-Protection! No auto-response sent to "%s".' => 'Protección de bucle! Ningunha auto resposta enviada a "%s".',
        'Mail Accounts' => 'Contas de correo',
        'Main menu registration.' => 'Rexistro menú principal.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Fai a aplicación comprobar o rexistro MX de enderezos de correo electrónico antes de enviar un correo electrónico ou o envío dun ticket de teléfono ou de correo electrónico.',
        'Makes the application check the syntax of email addresses.' => 'Fai a aplicación comprobar a sintaxe do enderezo de correo electrónico.',
        'Makes the picture transparent.' => 'Fai que a imaxe sexa transparente.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Fai a xestión da sesión usar cookies de html. Se as cookies html están deshabilitadas ou o cliente do navegador ten as cookies deshabilitadas, logo o sistema traballará coma normalmente é agregará o id da sesión aos enlaces.',
        'Manage OTRS Group services.' => 'Dirixa servizos do Grupo OTRS.',
        'Manage PGP keys for email encryption.' => 'Xestionar as claves de PGP para o cifrado do correo.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Xestionar as contas POP3 ou IMAP das que obter o correo.',
        'Manage S/MIME certificates for email encryption.' => 'Xestionar os certificados S/MIME para o cifrado do correo.',
        'Manage existing sessions.' => 'Xestionar as sesións existentes.',
        'Manage notifications that are sent to agents.' => 'Xestionar as notificacións que lles son enviadas aos axentes.',
        'Manage system registration.' => 'Xestionar o rexistro no sistema.',
        'Manage tasks triggered by event or time based execution.' => 'Dirixa tarefas disparadas por evento ou baseadas no tempo de execución.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Tamaño máximo (en carácteres) da táboa de información de cliente (teléfono e correo electrónico) na pantalla composta.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Tamaño máximo (en filas) da caixa de axentes informados na interface de axente.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Tamaño máximo (en filas) da caixa de axentes implicados na interface de axente.',
        'Max size of the subjects in an email reply.' => 'Tamaño máximo dos temas nunha resposta de correo electrónico.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maximas auto respostas de correo electrónico que son propiedade dun enderezo de correo electrónico por día (Protección de Bucle).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Tamaño máximo en KBytes para correos que poden ser recuperados vía POP3/POP3S/IMAP/IMAPS (KBytes).',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Máxima lonxitude (en carácteres) do campo dinámico no artigo da vista zoom de ticket.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Máxima lonxitude (en carácteres) do campo dinámico na barra lateral da vista zoom de ticket.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Número máximo de tickets para ser mostrados no resultado dunha busca na interface de axente.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Número máximo de tickets para ser mostrados no resultado dunha busca na interface de cliente.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Número máximo de tickets para ser mostrados no resultado desta operación.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Tamaño máximo (en carácteres) da táboa de información de cliente na vista zoom de ticket.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Módulo para selección-A na pantalla novo ticket na interface de axente.',
        'Module to check customer permissions.' => 'Módulo para comprobar os permisos do cliente.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'Módulo para comprobar se un usuario pertence a algún grupo especial. Concédeselle acceso se o usuario está no grupo indicado e ten os permisos ro e rw.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            'Módulo para comprobar se hai que marcar o correo recibido como correo interno (por causa do correo interno encamiñado orixinal). ArticleType e SenderType definen os valores para as mensaxes/artigos recibidos.',
        'Module to check the agent responsible of a ticket.' => 'Módulo para comprobar o axente responsable dun ticket.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Módulo para comprobar permisos de grupo para ó acceso a tickets de cliente.',
        'Module to check the owner of a ticket.' => 'Módulo para comprobar o propietario dun ticket.',
        'Module to check the watcher agents of a ticket.' => 'Módulo para comprobar os axentes vixiantes dun ticket.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Módulo para redactar mensaxes asinadas (PGP ou S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Módulo para cifrar mensaxes redactadas (PGP ou S/MIME).',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Módulo para filtrar e manipular as mensaxes entrantes. Bloquea/Ignora todo o correo lixo con enderezo From: noreply@.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Módulo para filtrar e manipular mensaxes entrantes. Leve un número de 4 díxitos ao texto libre de ticket, use regex en Coincidir ex. De => \'(.+?)@.+?\', e use () coma [***] en Establecer =>.',
        'Module to generate accounted time ticket statistics.' => 'Módulo para xenerar estatísticas de tempo empregado no ticket.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Módulo para xerar perfíl html BuscaAberta para busca ticket curta na interface de axente.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Módulo para xerar perfíl html BuscaAberta para busca ticket curta na interface de cliente.',
        'Module to generate ticket solution and response time statistics.' =>
            'Módulo para xerar estatísticas de tempo de solución e resposta de ticket.',
        'Module to generate ticket statistics.' => 'Módulo para xerar estatísticas de ticket.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Módulo para mostrar notificacións e escalados (MostrarMax: max. escalados mostrados, EscaladoEnMinutos: Mostra o ticket o cal será escalado en, TempoCache: Cache dos escalados calculados en segundos).',
        'Module to use database filter storage.' => 'Módulo para empregar o almacenamento de filtros da base de datos.',
        'Multiselect' => 'Multiselección',
        'My Queues and My Services' => 'As miñas filas e os meus servizos',
        'My Queues or My Services' => 'As miñas filas ou os meus servizos',
        'My Services' => 'Os meus servizos',
        'My Tickets' => 'Meus Tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Nome da fila personalizada. A fila personalizada é unha selección de filas das súas filas preferidas e pode ser seleccionada nas preferencias.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Nome do servizo personalizado. O servizo personalizado é unha selección de servizos dos seus servizos preferidos e pode ser seleccionado nas preferencias.',
        'NameX' => 'NomeX',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Novo Ticket [%s] creado (Q=%s; P=%s;S=%s).',
        'New Window' => 'Nova xanela',
        'New email ticket' => 'Novo ticket correo electrónico',
        'New owner is "%s" (ID=%s).' => 'O novo dono é «%s» (Identificador=%s).',
        'New phone ticket' => 'Novo ticket telefónico',
        'New process ticket' => 'Novo ticket de proceso',
        'New responsible is "%s" (ID=%s).' => 'O novo responsábel é «%s» (Identificador=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Próximos estados posibles de ticket despois de engadir unha nota de teléfono na pantalla ticket de chamada entrante da interface de axente.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Próximos estados posibles de ticket despois de engadir unha nota de teléfono na pantalla ticket de chamada saínte da interface de axente.',
        'No Notification' => 'Non hai ningunha notificación',
        'None' => 'Ningún',
        'Notification sent to "%s".' => 'Envióuselle unha notificación a «%s».',
        'Notifications (Event)' => 'Notificacións (Evento)',
        'Number of displayed tickets' => 'Número de tickets mostrados.',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Número de liñas (por ticket) que son mostrados pola utilidade de busca na interface de axente.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Número de tickets para ser mostrados en cada páxina dun resultado de busca na interface de axente.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Número de tickets para ser mostrados en cada páxina dun resultado de busca na interface de cliente.',
        'Old: "%s" New: "%s"' => 'Vello: «%s» Novo: «%s»',
        'Online' => 'Na rede',
        'Open tickets (customer user)' => 'Tíckets abertos (usuario cliente)',
        'Open tickets (customer)' => 'Tíckets abertos (cliente)',
        'Out Of Office' => 'Fóra da oficina',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Sobrecargas (redefine) funcións existentes en Kernel::System::Ticket. Utilizado para engadir facilmente personalizacións.',
        'Overview Escalated Tickets' => 'Vista Xeral Tickets Escalados',
        'Overview Refresh Time' => 'Vista Xeral Tempo Recarga',
        'Overview of all open Tickets.' => 'Vista Xeral  de tódolos Tickets abertos.',
        'PGP Key Management' => 'Xestión Clave de PGP',
        'PGP Key Upload' => 'Carga Clave de PGP',
        'Package event module file a scheduler task for update registration.' =>
            'Paquete de archivo de módulo de evento un planificador de tarefas para rexistro de actualización.',
        'Parameters for .' => 'Parámetros para.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto CrearSeguinteMáscara na vista preferencia da interface de axente.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto ColaPropia na vista preferencia da interface de axente.',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto ServizoPropio na vista preferencia da interface de axente.',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto SeguimentoNotificar na vista preferencia da interface de axente.',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto BloqueoTempoalcanzadoNotificar na vista preferencia da interface de axente.',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto NotificarMovemento na vista preferencia da interface de axente.',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'Parámetros para o obxecto NotificarNovoTicket na vista preferencias da interface de axente.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto TempoRecarga na vista preferencia da interface de axente.',
        'Parameters for the ServiceUpdateNotify object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto NotificarActualizaciónServizo na vista preferencia da interface de axente.',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'Parámetros para o obxecto NotificarVixiante na vista preferencia da interface de axente.',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Os parámetros para o cadro de mando do backend da información da compañía do cliente da interface de axente. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin se permite por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Os parámetros para o cadro de mando do backend do widget estado do id do cliente da interface de axente. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin se permite por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Os parámetros para o cadro de mando do backend da vista xeral da lista do cliente usuario da interface de axente. "Limite" e o número de entradas mostradas por defecto. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin se permite por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Os parámetros para o cadro de mando do backend da vista xeral de novos tickets da interface de axente. "Limite" é ó número de entradas mostradas por defecto."Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin se permite por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin. Nota: Soamente atributos de ticket e Campos Dinámicos (CampoDinamico_NomeX) son permitidos para ColumnasDefecto. Posibles axustes: 0 = Deshabilitados, 1 = Dispoñible, 2 = Habilitados por defecto.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Os parámetros para o cadro de mando do backend do widget de vista xeral da cola da interface de axente. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "QueuePermissionGroup" non é obrigatorio, as colas son só enumeradas se pertencen a este grupo de permiso se vostede o activa. "Estados" son unha lista de estados, a chave é a orde de ordear o estado no widget. "Defecto" determina se ao plugin se lle permite por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Os parámetros para o cadro de mando do backend da vista xeral dos tickets proceso executándose da interface de axente. "Límite" é a cantidade de entradas mostradas por defecto. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se ao plugin se lle permite por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Os parámetros para o cadro de mando do backend de calendario de ticket da interface de axente. "Límite" é a cantidade de entradas mostradas por defecto. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin é habilitado por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Os parámetros para o cadro de mando do backend de calendario de ticket da interface de axente. "Límite" é a cantidade de entradas mostradas por defecto. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin é habilitado por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NameX) son permitidos para DefaultColumns. Posibles axustes: 0 = Deshabilitados, 1 = Dispoñible, 2 = Permitidos por defecto.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Os parámetros para o cadro de mando do backend da vista xeral de recordatorio de ticket pendente da interface de axente. "Límite" é a cantidade de entradas mostradas por defecto. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin é habilitado por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NameX) son permitidos para DefaultColumns. Posibles axustes: 0 = Deshabilitados, 1 = Dispoñible, 2 = Permitidos por defecto.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Os parámetros para o cadro de mando do backend da vista xeral de recordatorio de ticket pendente da interface de axente. "Límite" é a cantidade de entradas mostradas por defecto. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin é habilitado por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin. Nota: Soamente atributos de Ticket e Campos Dinámicos (DynamicField_NameX) son permitidos para DefaultColumns. Posibles axustes: 0 = Deshabilitados, 1 = Dispoñible, 2 = Permitidos por defecto.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Os parámetros para o cadro de mando das estatísticas de ticket da interface de axente. "Límite" é a cantidade de entradas mostradas por defecto. "Grupo" é utilizado para restrinxir o acceso ao plugin (e. g. Grupo: admin;group1;group2;). "Defecto" determina se o plugin é habilitado por defecto ou se o usuario necesita activalo manualmente. "CacheTTLLocal" é o tempo de cache en minutos para o plugin.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            'Parámetros para as páxinas (nas cales os campos dinámicos son mostrados) da vista xeral de campos dinámica.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Parámetros para as páxinas (nas cales os tickets son mostrados) da vista xeral media de ticket.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Parámetros para as páxinas (nas cales os tickets son mostrados) da vista xeral pequena de ticket.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Parámetros para as páxinas (nas cales os tickets son mostrados) da vista xeral de vista previa do ticket.',
        'Parameters of the example SLA attribute Comment2.' => 'Parámetros do exemplo ANS atributo Comentario2.',
        'Parameters of the example queue attribute Comment2.' => 'Parámetros do exemplo cola atributo Comentario2.',
        'Parameters of the example service attribute Comment2.' => 'Parámetros do exemplo servizo atributo Comentario2.',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Ruta do arquivo log (só aplica se "FS" foi seleccionado para MóduloProtecciónBucle e é obrigatorio).',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            'Ruta do arquivo que almacena tódolos axustes para ó obxecto ObxectoCola da interface de axente.',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            'Ruta do arquivo que almacena tódolos axustes para ó obxecto ObxectoCola da interface de cliente.',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            'Ruta do arquivo que almacena tódolos axustes para ó ObxectoTicket da interface de axente.',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            'Ruta do arquivo que almacena tódolos axustes para ó ObxectoTicket da interface de cliente.',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            'Executa a acción configurada para cada evento (coma un Invocador) para cada Servizo Web configurado.',
        'Permitted width for compose email windows.' => 'Anchura permitida para compoñer ventás de correo electrónico.',
        'Permitted width for compose note windows.' => 'Anchura permitida para compoñer ventás de nota.',
        'Picture-Upload' => 'Carga-Imaxe',
        'PostMaster Filters' => 'Filtros PostMaster',
        'PostMaster Mail Accounts' => 'Contas Correo PostMaster',
        'Process Information' => 'Información do proceso',
        'Process Management Activity Dialog GUI' => 'Diálogo de Actividade de Proceso de Xestión GUI',
        'Process Management Activity GUI' => 'Actividade de Proceso de Xestión GUI',
        'Process Management Path GUI' => 'Ruta Proceso Xestión GUI',
        'Process Management Transition Action GUI' => 'Acción Transición Proceso Xestión GUI',
        'Process Management Transition GUI' => 'Transición Proceso Xestión GUI',
        'ProcessID' => 'IDProceso',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Protección contra CSRF (Falsificación de Petición de Lugar Cruzada) explota (para máis información ver http://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            'Proporciona unha vista xeral matricial dos tickets por estado por cola.',
        'Queue view' => 'Vista Cola',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            'Déase conta se un ticket é un seguimento ata un ticket existente que utiliza un número de ticket externo.',
        'Refresh Overviews after' => 'Recargar Vistas Xerais despois',
        'Refresh interval' => 'Intervalo Recarga',
        'Removed subscription for user "%s".' => 'Eliminar subscrición para o usuario "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Elimina a información do vixiante de ticket cando un ticket é arquivado.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Substitúe o remitente orixinal co enderezo de correo electrónico do cliente actual na resposta composta na pantalla de ticket composto da interface de axente.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Permisos requiridos para cambiar o cliente dun tícket na interface do axente.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de peche de tíckets da interface do axente.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Permisos requiridos para empregar a pantalla de correo saínte da interface do axente.',
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
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Restablece e desbloquea o propietario dun ticket se foi movido a outra cola.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Restablece un ticket dende o arquivo (só se o estado do evento cambia, de cerrado a calquera estado aberto dispoñible).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Retén tódolos servizos en listas incluso se son fillos de elementos invalidos.',
        'Right' => 'Dereita',
        'Roles <-> Groups' => 'Papeis <-> Grupos',
        'Running Process Tickets' => 'Tickets Proceso Executándose',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Executa unha busca inicial comodín dos clientes da compañía existentes cando acceden o módulo AdminClienteCompañía.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Executa unha busca inicial comodín dos clientes usuarios existentes cando acceden o módulo AdminClienteCompañía.',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Executa o sistema en modo "Demo". Se establecido a "Si", axentes poden cambiar preferencias, coma selección de lingua e tema via a interface web de axente. Estos cambios son soamente válidos para a sesión actual. Esto non será posible para axentes de cambiar os seus contrasinais.',
        'S/MIME Certificate Upload' => 'Carga Certificado S/MIME',
        'Sample command output' => 'Saída comando exemplo',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            'Garda os anexos dos artigos. «BD» almacena todos os datos na base de datos (non se recomenda para almacenar anexos grandes). «SF» almacena os datos no sistema de ficheiros; isto é máis rápido mais o servidor web debería ser executado co usuario OTRS. Pódese alternar entre os módulos mesmo nun sistema que xa estea en produción, sen perda de datos. Nota: A busca nos nomes dos anexos non é posíbel cando se emprega «SF».',
        'Schedule a maintenance period.' => 'Planifique un periodo mantemento.',
        'Search Customer' => 'Buscar clientes',
        'Search User' => 'Busque Usuario',
        'Search backend default router.' => 'Busca router por defecto de backend.',
        'Search backend router.' => 'Busca router backend.',
        'Second Queue' => 'Segunda Cola',
        'Select your frontend Theme.' => 'Seleccione o seu Tema frontend.',
        'Selects the cache backend to use.' => 'Seleccione o cache backend a usar.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Selecciona el módulo para manexar cargas vía a interface web. "BD" garda tódalas cargas na base de datos, "FS" emprega o arquivo de sistema.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Selecciona o módulo de xeradores de número de ticket. "AutoIncrement" incrementa o número de ticket, o SystemID e o contador son utilizados con formato de SystemID.contador (p.ej. 1010138, 1010139). Con "Data" os números de ticket serán xerados pola data actual, o SystemID e o contador. O formato parece como Ano.Mes.Dia.SystemID.contador (p.ex. 200206231010138, 200206231010139). Con "DateChecksum" o contador será engadido como checksum á cadea de data e SystemID. O checksum será rotado a diario. O formato parece como Ano.Mes.Dia.SystemID.Contador.CheckSum (p.ej. 2002070110101520, 2002070110101535). "Random" xera números de billete ó azar no formato "SystemID.Random" (p.ej. 100057866352, 103745394596).',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my queues/services.' =>
            'Enviarme unha notificación se un cliente envía un seguimento e eu son o dono do tícket ou o tícket é desbloqueado e está nunha das miñas filas ou servizos.',
        'Send me a notification if the service of a ticket is changed to a service in "My Services" and the ticket is in a queue where I have read permissions.' =>
            'Envíeme unha notificación se o servizo dun ticket é cambiado a un servizo en "Os Meus Servizos" e o ticket está nunha cola onde teño permisos de lectura.',
        'Send me a notification if there is a new ticket in my queues/services.' =>
            'Enviarme unha notificación se hai un tícket novo nas miñas filas/servizos.',
        'Send new ticket notifications if subscribed to' => 'Envíe novas notificacións de ticket se é subscrito a',
        'Send notifications to users.' => 'Envíe notificacións a usuarios.',
        'Send service update notifications' => 'Envíe notificacións de actualización de servizo',
        'Send ticket follow up notifications if subscribed to' => 'Envíe notificacións de seguimento de ticket se é subscrito a',
        'Sender type for new tickets from the customer inteface.' => 'Tipo de remitente para tickets novos dende a interface de clientes.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Envía notificación de seguemento ao axente  só se é propietario, se un ticket non está bloqueado (por defecto envíanse notificacións a tódolos axentes).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Envía tódolos correos electrónicos de ida mediante bcc ao enderezo especificado. Por favor use esto soamente por razóns de backup.',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'Envía notificacións de cliente só ao cliente mapeado. Normalmente, se ningún cliente é mapeado, o último remitente cliente obtén a notificación.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Envía notificacións de recordatorio de tickets non bloqueados despois de alcanzar a data de recordatorio (só enviado ao propietario do ticket).',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Envía notificacións as cales están configuradas na interface administrador baixo "Notificación (Evento)".',
        'Service update notification' => 'Servizo notificación actualización',
        'Service view' => 'Vista de servizos',
        'Set sender email addresses for this system.' => 'Estableza enderezos de correo electrónico de remitente para este sistema.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Estableza a altura por defecto (en pixels) de artigos de HTML inline en AxenteTicketZoom.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Estableza a altura máxima (en pixels) de artigos de HTML inline en AxenteTicketZoom.',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Estableza isto a si se vostede confía en tódalas súas chaves de pgp públicas e privadas, aínda que non sexan certificados cunha sinatura de confianza.',
        'Sets if SLA must be selected by the agent.' => 'Indica se o SLA debe ser seleccionado polo axente.',
        'Sets if SLA must be selected by the customer.' => 'Establece se o ANS debe ser seleccionado polo cliente.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Establece se nota debe ser enchida polo axente. Pode ser sobreescribido por Ticket::Frontend::NeedAccountedTime.',
        'Sets if service must be selected by the agent.' => 'Establce se servizo debe ser seleccionado polo axente.',
        'Sets if service must be selected by the customer.' => 'Establce se servizo debe ser seleccionado polo cliente.',
        'Sets if ticket owner must be selected by the agent.' => 'Establce se propietario do ticket debe ser seleccionado polo axente.',
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
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Establece o tipo de artigo por defecto para novos tickets de correo electrónico na interface de axente.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Establece o tipo de artigo por defecto para novos tickets telefónicos na interface de axente.',
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
        'Sets the display order of the different items in the preferences view.' =>
            'Establece a orde de mostrar os diferentes elementos na vista de preferencias.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'Establece o tempo de inactividade (en segundos) a pasar antes de que a sesión sexa matada e o usuario loged out.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            'Establece o número máximo de axentes activos dentro do timespan definido en TempoSesiónActiva.',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            'Establece o número máximo de clientes activos dentro do timespan definido en TempoSesiónActiva.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            'Establece o número máximo de sesións activas por axente dentro do timespan definido en TempoSesiónActiva.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            'Establece o número máximo de sesións activas por cliente dentro do timespan definido en TempoSesiónActiva.',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            'Establece o tamaño mínimo do contador de ticket (se "AutoIncremento" foi seleccionado coma XeneradorNúmeroTicket). Por defecto é 5, esto significa que o contador comeza dende 10000.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Establece os minutos que unha notificación é mostrada para darse conta dos próximos periodos de mantemento de sistema.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Establece o número de liñas que son mostradas en mensaxes de texto (ex. liñas en ticket na ColaZoom).',
        'Sets the options for PGP binary.' => 'Establece as opcións para o binario PGP.',
        'Sets the order of the different items in the customer preferences view.' =>
            'Establece a orde dos elementos diferentes na vista de preferencias de cliente.',
        'Sets the password for private PGP key.' => 'Establece o contrasinal para á chave PGP privada.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Establece as unidades de tempo preferidas (ex. horas traballo, horas, minutos).',
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
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Establece o servizo na pantalla de ticket pechado da interface de axente (Ticket::Service necesita ser activado).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Establece o servizo na pantalla de texto libre de ticket da interface de axente (Ticket::Service necesita ser activado).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Establece o servizo na pantalla nota de ticket da interface de axente (Ticket::Service necesita ser activado).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Establece o servizo na pantalla propietario de ticket dun ticket zoom na interface de axente (Ticket::Service necesita ser activado).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Establece o servizo na pantalla de ticket pendente dun ticket zoom na interface de axente (Ticket::Service necesita ser activado).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Establece o servizo na pantalla prioridade de ticketdun ticket zoom na interface de axente (Ticket::Service necesita ser activado).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Establece o servizo na pantalla responsable de ticket da interface de axente (Ticket::Service necesita ser activado).',
        'Sets the size of the statistic graph.' => 'Establece o tamaño do gráfico estatístico.',
        'Sets the stats hook.' => 'Establece o enganche as estatísticas.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'Establece a zona de tempo de sistema (necesario un sistema con UTC como tempo de sistema). Doutra maneira isto é un tempo diferente ao tempo local.',
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
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Establece o tipo de ticket na pantalla de ticket pechado da interface de axente (Ticket::Type necesita estar activo).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Establece o tipo de ticket na pantalla de ticket masivo da interface de axente.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Establece o tipo de ticket na pantalla texto libre de ticket da interface de axente (Ticket::Type necesita estar activo).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Establece o tipo de ticket na pantalla nota de ticket da interface de axente (Ticket::Type necesita estar activo).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Establece o tipo de ticket na pantalla propietario de ticket dun ticket zoom na interface de axente (Ticket::Type necesita estar activo).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Establece o tipo de ticket na pantalla de ticket pendente dun ticket zoom na interface de axente (Ticket::Type necesita estar activo).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Establece o tipo de ticket na pantalla prioridade de ticket dun ticket zoom na interface de axente (Ticket::Type necesita estar activo).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Establece o tipo de ticket na pantalla responsable de ticket na interface de axente (Ticket::Type necesita estar activo).',
        'Sets the time (in seconds) a user is marked as active.' => 'Establece o tempo (en segundos) que un usuario é marcado coma activo.',
        'Sets the time type which should be shown.' => 'Establece o tipo de tempo que debe ser mostrado.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Establece o tempo esgotado (en segundos) para descargas http/ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Establece o tempo esgotado (en segundos) para descargas de paquetes. Sobreescribe "WebUserAgent::TimeOut".',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Establece a zona de tempo de usuario por usuario (necesario un sistema con UTC como tempo de sistema e UTC baixo TimeZone). Doutra maneira isto é un tempo diferente ao tempo local.',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'Establece a zona de tempo de usuario por usuario baseado en javascript / navegador zona horaria función offset no tempo de login.',
        'Should the cache data be help in memory?' => 'Deben os datos de cache ser axudados en memoria?',
        'Should the cache data be stored in the selected cache backend?' =>
            'Deben almacenarse os datos cache na cache seleccionada no backend?',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Mostra unha selección de responsable en tickets telefónicos e de correo electronico na interface de axente.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Mostrar artigo coma texto rico inluso se a escritura en texto rico está deshabilitada.',
        'Show the current owner in the customer interface.' => 'Mostrar o dono actual na interface do cliente.',
        'Show the current queue in the customer interface.' => 'Mostrar a fila actual na interface do cliente.',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Mostra a conta de iconos no ticket zoom, se o artigo ten adxuntos.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para darse de alta / baixa de un ticket na vista ticket zoom da interface de axente.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace que permite enlazar un ticket con outro obxecto na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu que permite tickets fusionados na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para acceder o historico dun ticket na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para engadir un campo de texto libre na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para engadir unha nota na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Mostra un enlace no menu para engadir unha nota a un ticket en cada vista xeral de ticket da interface de axente.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Mostra un enlace no menu para pechar un ticket en cada vista xeral de ticket da interface de axente.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para pechar un ticket na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Mostra un enlace no menú para borrar un ticket en todas as vistas xerais de ticket da interface de axente. Control de acceso adicional para mostrar ou non mostrar este enlace podese facer utilizando Clave "Grupo" e Contido como "rw:group1;move_into:group2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Mostra un enlace no menú para borrar un ticket na vista zoom de ticket da interface de axente. Control de acceso adicional para mostrar ou non mostrar este enlace podese facer utilizando Clave "Grupo" e Contido como "rw:group1;move_into:group2".',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para inscribir un ticket en un proceso na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para voltar atrás na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Mostra un enlace no menu para bloquear / desbloquear un ticket  nas vistas xeráis de ticket da interface de axente.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu parabloquear / desbloquear tickets en la vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Mostra un enlace no menu para mover un ticket en en tódalas vistas xeráis de ticket da interface de axente.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para imprimir  un ticket ou un artigo na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para ver o cliente que requririu un ticket na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Mostra un enlace no menu para ver o historico dun ticket en tódalas vistas xeráis de ticket da interface de axente.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para ver o propietario dun ticket na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para ver a prioridade dun ticket na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para ver o responsable dun ticket na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para enviar un correo electrónico de saída na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'Mostra un enlace no menu para establecer un ticket como pendente na vista zoom de ticket da interface de axente.',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Mostra un enlace no menu para establecer un ticket como spam en tódalas vistas xeráis de ticket da interface de axente. Control de acceso adicional para mostrar ou non mostrar este enlace podese facer utilizando Clave "Grupo" e Contido como "rw:group1;move_into:group2".',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Mostra un enlace no menu para establecer á prioridade dun ticket en tódalas vistas xeráis de ticket da interface de axente.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Mostra un enlace no menu para facer zoom nun ticket nas vistas xeráis de ticket da interface de axente.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Mostra un enlace para acceder adxuntos de artigo vía un visor online html na vista zoom de artigo da interface de axente.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Mostra un enlace para descargar adxuntos de artigo na vista zoom de artigo da interface de axente.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Mostra un enlace para ver un ticket zoom de correo electrónico en texto plano.',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Mostra un enlace para establecer un ticket como spam na vista zoom de ticket da interface de axente. Control de acceso adicional para mostrar ou non mostrar este enlace podese facer utilizando Clave "Grupo" e Contido como "rw:group1;move_into:group2".',
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
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            'Mostra unha selección dos atributos do ticket para ordear a vista da cola da lista de ticket. As posibles seleccións poden ser configuradas vía \'TicketOverviewMenuSort###SortAttributes\'.',
        'Shows all both ro and rw queues in the queue view.' => 'Mostra ambas as dúas colas ro and rw na vista da cola.',
        'Shows all both ro and rw tickets in the service view.' => 'Mostra ambas os dous tickets ro and rw na vista dde servizo.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Mostra tódolos tickets abertos (incluso se están bloqueados) na vista de escalado da interface de axente.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Mostra tódolos tickets abertos (incluso se están bloqueados) na vista de estado da interface de axente.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Mostra tódolos artigos do ticket (expandido) na vista zoom.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Mostra tódolos identificadores de cliente nun campo de selección múltiple (non útil se ten moitos identificadores de cliente).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Mostra unha selección de propietarios en tickets teléfonicos e de correo eléctronico na interface de axente.',
        'Shows colors for different article types in the article table.' =>
            'Mostra colores para diferentes tipos de artigo na táboa artigo.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Mostra o historial de tíckets dos clientes en AgentTicketPhone, AgentTicketEmail e AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Mostra tanto o derradeiro subxeto de artigo ou o titulo de ticket na vista xeral de formato pequeno.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Mostra listas de colas pai/fillo existentes no sistema na forma dunha árbore ou unha lista.',
        'Shows information on how to start OTRS Scheduler' => 'Mostra información sobre como iniciar o Planificador de OTRS',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Mostra os atributos activados dun ticket na interface de cliente (0 = Deshabilitado e 1 = Habilitado).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Mostra artigos ordeados normalemnte ou ó revés, baixo zoom de ticket na interface de axente.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Mostra a información do usuario cliente (teléfono e correo electrónico) na vista composición.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Mostra a información dos usuarios clientes na vista zoom de ticket.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Mostra a mensaxe do día no taboleiro do axente. «Group» emprégase para restrinxir o acceso ao engadido (p.e.x Group: admin;grupo1;grupo2;). «Default» indica se o engadido está activado por omisión ou se o usuario o ten que activar manualmente.',
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
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'Mostra os campos do titulo na pantalla ticket pechado da interface de axente.',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'Mostra os campos do titulo na pantalla texto libre de ticket da interface de axente.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Mostra os campos do titulo na pantalla nota de ticket da interface de axente.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Mostra os campos do titulo na pantalla propietario de ticket dun ticket zoom na interface de axente.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Mostra os campos do titulo na pantalla de ticket pendente dun ticket zoom na interface de axente.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Mostra os campos do titulo na pantalla prioridade de ticket dun ticket zoom na interface de axente.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Mostra os campos do titulo na pantalla responsable de ticket da interface de axente.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Mostra o tempo en formato longo (días, horas, minutos), se establecido a "Si"; ou en formato curto (días, horas), se establecido a "Non".',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'Mostra descripción completa de tempo de uso (días, horas, minutos), se establecido a "Si"; ou só a primeira letra (d, h, m), se establecido a "Non".',
        'Skin' => 'Aparencia',
        'SolutionDiffInMin' => 'SolucionDifEnMin',
        'SolutionInMin' => 'SolucionEnMin',
        'Some description!' => 'Algunha descripción!',
        'Some picture description!' => 'Algunha descripción da imaxe!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Ordea os tickets (ascendente ou descendentemente) cando unha única cola é seleccionada na vista da cola e despois os tickets son ordeados por prioridades. Valores: 0 = ascendente (mais vello enriba, por defecto), 1 = descendente (mais novo enriba). Use IDCola para a chave e 0 ou 1 para o valor.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Ordea os tickets (ascendente ou descendentemente) cando unha única cola é seleccionada na vista de servizo e despois os tickets son ordeados por prioridade. Valores: 0 = ascendente (mais vello enriba, por defecto), 1 = descendente (mais novo enriba). Use IDServizo para a chave e 0 ou 1 para o valor.',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Exemplo de montaxe de Asasino de Spam. Ignorar correos electrónicos marcados con AsasinoSpam.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Exemplo de mantaxe de Asasino de Spam. Mover correos electrónicos marcados á cola de spam.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Especifica se un axente debe recibir notificacións de correo electrónico das súas propias accións.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            'Especifica os tipos de notas dispoñibles para esta máscara de ticket. Se a opción é deseleccionada, TipoArtigoDefecto e usado e á opción é eliminada da máscara.',
        'Specifies the background color of the chart.' => 'Especifica o color de fondo do gráfico.',
        'Specifies the background color of the picture.' => 'Especifica o color de fondo da imaxe.',
        'Specifies the border color of the chart.' => 'Especifica o color de borde do gráfico.',
        'Specifies the border color of the legend.' => 'Especifica o color de borde dda lenda.',
        'Specifies the bottom margin of the chart.' => 'Especifica a marxe inferior do gráfico.',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            'Especifica o tipo de artigo por defecto para á pantalla composición de ticket na interface de axente se o tipo de artigo non pode ser detectado automaticamente..',
        'Specifies the different article types that will be used in the system.' =>
            'Especifica os diferentes tipos de artigos que van ser usados no sistema.',
        'Specifies the different note types that will be used in the system.' =>
            'Especifica os diferentes tipos de notas que van ser usados no sistema.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Especifica o directorio para gardar os datos en, se "FS" foi seleccionado para TicketAlmacenarModulo.',
        'Specifies the directory where SSL certificates are stored.' => 'Especifica o directorio onde os certificados ssl están gardados.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Especifica o directorio onde os certificados privados ssl están gardados.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Especifica o enderezo de correo electrónico que debería ser utilizado pola aplicación cando envia notificacións. O enderezo de correo electrónico é utilizado para construír o nome de mostra total para o master de notificación (p. ex. "Master de Notificación de OTRS" otrs@your.example.com). Vostede pode utilizar a variable de OTRS_CONFIG_FQDN como establecida na súa configuración, ou elixir outro enderezo de correo electrónico. Notificacións son mensaxes como en::Customer::QueueUpdate ou en::Agent::Move.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Especifica o grupo onde o usuario necesita permisos rw para que él poida acceder a función "SwitchToCustomer".',
        'Specifies the left margin of the chart.' => 'Especifica a marxe esquerda do gráfico.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Especifica o nome que debería ser utilizado pola aplicación cando envia notificacións. O nome de remitente é utilizado para construír o nome de mostra completo para o Master de notificación (p. ex. "OTRS Notificación Master" otrs@your.example.com). Notificacións son mensaxes como en::Customer::QueueUpdate ou en::Agent::Move.',
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
        'Specifies the right margin of the chart.' => 'Especifica a marxe dereita do gráfico.',
        'Specifies the text color of the chart (e. g. caption).' => 'Especifica o color de texto do gráfico (ex. título).',
        'Specifies the text color of the legend.' => 'Especifica o color do texto da lenda.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Especifica o texto que debería aparecer no arquivo log para indicar unha entrada de script de CGI.',
        'Specifies the top margin of the chart.' => 'Especifica a marxe superior do gráfico.',
        'Specifies user id of the postmaster data base.' => 'Especifica o id usuario da base de datos postmaster.',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            'Especifica se tódolos backends de almacenamento deberían ser comprobados cando fanse buscas de adxuntos. Isto é soamente requirido para instalacións onde algúns adxuntos están no sistema de arquivo, e outros na base de datos.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Especifique cantos niveis sub directorio se deben utilizar cando creanse arquivos de cache. Isto debería previr demasiados arquivos de cache de estar nun directorio.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'Especifique a canle para ser utilizada para traer actualizacións de OTRS Business Solution™. Alerta: Presentacións de desenvolvemento poderían non ser totais, o seu sistema podería experimentar erros non-recuperables e en casos extremos podería voltarse sen resposta!',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Permisos normais dispoñíbeis para os axentes desde dentro do aplicativo. Se se precisaren máis precisos, é posíbel engadilos aquí. Os permisos teñen que ser definidos para seren efectivos. Outros permisos bos tamén se fornecen incorporados: nota, pechar, pendente, cliente, texto libre, mover, redactar, responsábel, encamiñar e rebotar. Asegúrese de que «rw» é sempre o último permiso rexistrado.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Empece número para reconto da estatística. Tódalas estatísticas novas incrementan este número.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Empece unha busca comodín do obxecto activo despois de que o enlace ao obxecto máscara foi empezado.',
        'Stat#' => 'Estatística#',
        'Statistics' => 'Estatísticas',
        'Status view' => 'Vista do estado',
        'Stop words for fulltext index. These words will be removed.' => 'Pare palabras para índice de texto completo. Estas palabras serán eliminadas.',
        'Stores cookies after the browser has been closed.' => 'Garde cookies despois de que o buscador foi pechado.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Tiras liñas baleiras na vista previa do ticket na vista de cola.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Tiras liñas baleiras na vista previa do ticket na vista de servizo.',
        'System Maintenance' => 'Mantemento do sistema',
        'System Request (%s).' => 'Petición do sistema (%s).',
        'Templates <-> Queues' => 'Modelos <-> Filas',
        'Textarea' => 'Área de texto',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            'O "bin/PostMasterMailAccount.pl" reconectarase ao host POP3/POP3S/IMAP/IMAPS despois  de contar as mensaxes especificadas.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'A aparencia NomeInterno de axente a cal debe ser usada na interface de axente. Por favor comprobe as aparencias dispoñibles en Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'A aparencia NomeInterno de cliente a cal debe ser usada na interface de cliente. Por favor comprobe as aparencias dispoñibles en Frontend::Agent::Skins.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'O separador entre GanchoTicket e número de ticket. Ex.  \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'A duración en minutos despois de emitir un evento, no cal o novo escalado notificar e empezar eventos son suprimidos.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            'O formato do tema. \'Esquerda\' significa \'[TicketHook#:12345] Algún Tema\', \'Dereita\' significa \'Algún Tema [TicketHook#:12345]\', \'Nada\' significa que \'Algún Tema\' e non número de ticket. No último caso vostede debería permitir a PostmasterFollowupSearchInRaw ou PostmasterFollowUpSearchInReferences para recoñecer seguimentos baseados en cabeceiras de correo electrónico e/ou corpo.',
        'The headline shown in the customer interface.' => 'A cabeceira que aparece na interface do cliente.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'O identificador dun tícket, p.e.x Ticket#, Chamada#, Omeutícket#. Por omisión é Ticket#.',
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
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'O logo mostrado sobre a caixa de login da interface de axente. A URL á imaxe debe ser unha URL relativa ao directorio de imaxe de aparencia.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'Número máximo de artigos expandidos nunha única páxina en AxenteTicketZoom.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'Número máximo de artigos mostrados nunha única páxina en AxenteTicketZoom.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'O texto ao comezo do tema nunha resposta de correo electrónico, ex. RE, AW, ou AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'O texto ao principio do asunto cando se encamiña unha mensaxe de correo, p.ex. Re ou FW.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            'Este módulo de evento garda atributos de ClienteUsuario coma tickets CamposDinamicos. Por favor vexa o axuste arriba sobre como configurar o mapeado.',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Este módulo e a súa función PreRun() será executada, se definido, para cada petición. Este módulo é útil para comprobar algunhas  opcións de usuario ou para mostrar novas sobre novas aplicacións.',
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
        'Ticket Queue Overview' => 'Vista xeral da fila de tíckets',
        'Ticket event module that triggers the escalation stop events.' =>
            'Módulo evento de ticket que dispara os eventos de parada do escalado.',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'O tícket foi movido á fila «%s» (%s) desde a fila «%s» (%s).',
        'Ticket overview' => 'Vista xeral de ticket',
        'TicketNumber' => 'NúmeroTicket',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Tempo en segundos que se engade á hora actual ao indicar estado pendente (predeterminado: 86400 = 1 día).',
        'Title updated: Old: "%s", New: "%s"' => 'Título actualizado: Anterior: «%s», Novo: «%s»',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Alterna á mostra da lista de OTRS FeatureAddons no PackageManager.',
        'Toolbar Item for a shortcut.' => 'Elemento da barra de ferramentas como atallo.',
        'Tree view' => 'Vista en árbore',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Apaga a validación do certificado SSL, por exemplo se usa un proxy HTTPS transparente. Use no seu propio risco!',
        'Turns on drag and drop for the main navigation.' => 'Encenda arrastre e caída para a navegación principal.',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Activa as animacións empregadas na interface gráfica. Se ten problemas con estas animacións (p.ex., problemas de desempeño) pódeas desactivar aquí.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Encenda comprobación sobre o enderezo de ip remoto. Debería ser fixado a "Non" se a aplicación é utilizada, por exemplo, vía un proxy farm ou unha conexión de marcación directa, porque o enderezo de ip remoto é na súa maioría diferente para as peticións.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Desbloquear tickets sempre que unha nota seña engadida e o propietario é fora da oficina.',
        'Unlocked ticket.' => 'Tícket desbloqueado.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Actualice a bandeira "Visto" se cada artigo é visto ou un novo Artigo foi creado.',
        'Update and extend your system with software packages.' => 'Actualice e extenda o seu sistema con paquetes de software.',
        'Updated SLA to %s (ID=%s).' => 'O SLA foi actualizado a %s (identificador=%s).',
        'Updated Service to %s (ID=%s).' => 'Actualizado Servizo a %s(ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Actualizado Tipo a %s(ID=%s).',
        'Updated: %s' => 'Actualizado: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Actualizado: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Actualiza o índice de escalado de ticket despois de que un atributo de ticket fora actualizado.',
        'Updates the ticket index accelerator.' => 'Actualiza o índice acelerador de ticket.',
        'UserFirstname' => 'UsuarioNome',
        'UserLastname' => 'UsuarioApelidos',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Usa receptores Cc nas respostas de lista Cc na composición dunha resposta de correo electrónico na pantalla ticket composición da interface de axente.',
        'Uses richtext for viewing and editing notification events.' => 'Usa texto rico para ver e editar eventos de notificación.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Usa texto rico para ver y editar: artigos, saúdos, sinaturas, modelos estandard, auto respostas e notificacións.',
        'View performance benchmark results.' => 'Ver os resultados das probas de banco de rendemento.',
        'View system log messages.' => 'Ver mensaxes log do sistema.',
        'Wear this frontend skin' => 'Aplicar esta aparencia',
        'Webservice path separator.' => 'Separador ruta Servizo Web.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Cando os tickets son fusionados, unha nota será engadida automaticamente ao ticket que xa non é activo. Aquí vostede pode definir o corpo desta nota (este texto non pode ser cambiado polo axente).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Cando os tickets son fusionados, unha nota será engadida automaticamente ao ticket que xa non é activo. Aquí vostede pode definir o tema desta nota (este texto non pode ser cambiado polo axente).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Cando os tickets son fusionados, o cliente pode ser informado por correo electrónico activando a caixa "Informar Remitente". Nesta áre de texto, pode definir un texto pre-formado que pode despois ser modificado polos axentes.',
        'Write a new, outgoing mail' => 'Escribe un novo, correo de saída',
        'Yes, but hide archived tickets' => 'Si, mais agochar os tíckets arquivados',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'A súa selección de filas das súas filas favoritas. Tamén pode recibir notificacións sobre esas filas mediante correo electrónico se está activado.',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            'A súa selección de servizo dos teus servizos favoritos. Tamén será notificado sobre aqueles servizos vía correo electrónico se está habilitado.',

    };
    # $$STOP$$
    return;
}

1;
