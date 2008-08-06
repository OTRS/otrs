# --
# Kernel/Language/ct.pm - provides ct language translation
# Copyright (C) 2008 Sistemes OTIC (ibsalut) - Antonio Linde
# --
# $Id: ct.pm,v 1.13 2008-08-06 11:48:12 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::ct;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri May 16 14:07:42 2008

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
        'No' => 'No',
        'yes' => 'si',
        'no' => 'no',
        'Off' => 'Off',
        'off' => 'off',
        'On' => 'On',
        'on' => 'on',
        'top' => 'inici',
        'end' => 'fi',
        'Done' => 'Fet',
        'Cancel' => 'Cancel·lar',
        'Reset' => 'Reiniciar',
        'last' => 'darrer',
        'before' => 'abans',
        'day' => 'dia',
        'days' => 'dias',
        'day(s)' => 'dia(s)',
        'hour' => 'hora',
        'hours' => 'hores',
        'hour(s)' => 'hora(es)',
        'minute' => 'minut',
        'minutes' => 'minuts',
        'minute(s)' => 'minut(s)',
        'month' => 'mes',
        'months' => 'mesos',
        'month(s)' => 'mes(os)',
        'week' => 'setmana',
        'week(s)' => 'setmana(es)',
        'year' => 'any',
        'years' => 'anys',
        'year(s)' => 'any(s)',
        'second(s)' => 'segon(s)',
        'seconds' => 'segons',
        'second' => 'segon',
        'wrote' => 'va escriure',
        'Message' => 'Missatje',
        'Error' => 'Error',
        'Bug Report' => 'Informe d\'errors',
        'Attention' => 'Atenció',
        'Warning' => 'Atenció',
        'Module' => 'Mòdul',
        'Modulefile' => 'Arxiu de mòdul',
        'Subfunction' => 'Subfuncions',
        'Line' => 'Línia',
        'Example' => 'Exemple',
        'Examples' => 'Exemples',
        'valid' => 'vàlid',
        'invalid' => 'invàlid',
        '* invalid' => '* invàlid',
        'invalid-temporarily' => 'invàlid-temporalment',
        ' 2 minutes' => ' 2 minuts',
        ' 5 minutes' => ' 5 minuts',
        ' 7 minutes' => ' 7 minuts',
        '10 minutes' => '10 minuts',
        '15 minutes' => '15 minuts',
        'Mr.' => 'Sr.',
        'Mrs.' => 'Sra.',
        'Next' => 'Següent',
        'Back' => 'Tornar',
        'Next...' => 'Següent...',
        '...Back' => '..Tornar',
        '-none-' => '-no res-',
        'none' => 'no res',
        'none!' => 'no res!',
        'none - answered' => 'no res  - respost',
        'please do not edit!' => 'Per favor no ho editi!',
        'AddLink' => 'Afegir enllaç',
        'Link' => 'Enllaç',
        'Unlink' => 'Llevar enllaç',
        'Linked' => 'Enllaçat',
        'Link (Normal)' => 'Enllaç (Normal)',
        'Link (Parent)' => 'Enllaç (Pare)',
        'Link (Child)' => 'Enllaç (Fill)',
        'Normal' => 'Normal',
        'Parent' => 'Pare',
        'Child' => 'Fill',
        'Hit' => 'Resultat',
        'Hits' => 'Resultats',
        'Text' => 'Text',
        'Lite' => 'Petit',
        'User' => 'Usuari',
        'Username' => 'Nom d\'Usuari',
        'Language' => 'Idioma',
        'Languages' => 'Idiomes',
        'Password' => 'Contrasenya',
        'Salutation' => 'Saludo',
        'Signature' => 'Signaturas',
        'Customer' => 'Client',
        'CustomerID' => 'Nombre de client',
        'CustomerIDs' => 'Nombres de client',
        'customer' => 'client',
        'agent' => 'agent',
        'system' => 'Sistema',
        'Customer Info' => 'Informació del client',
        'Customer Company' => 'Client Companyia',
        'Company' => 'Companyia',
        'go!' => 'anar!',
        'go' => 'anar',
        'All' => 'Tot',
        'all' => 'tot',
        'Sorry' => 'Disculpi',
        'update!' => 'Actualitzar!',
        'update' => 'actualitzar',
        'Update' => 'Actualitzar',
        'submit!' => 'enviar!',
        'submit' => 'enviar',
        'Submit' => 'Enviar',
        'change!' => 'camviar!',
        'Change' => 'Camviar',
        'change' => 'camviar',
        'click here' => 'faci clic aquí',
        'Comment' => 'Comentari',
        'Valid' => 'Vàlid',
        'Invalid Option!' => 'Opció no valida',
        'Invalid time!' => 'Hora no valida',
        'Invalid date!' => 'Data no valida',
        'Name' => 'Nombre',
        'Group' => 'Grup',
        'Description' => 'Descripció',
        'description' => 'descripció',
        'Theme' => 'Tema',
        'Created' => 'Creat',
        'Created by' => 'Creat per',
        'Changed' => 'Modificat',
        'Changed by' => 'Modificat per',
        'Search' => 'Cercar',
        'and' => 'i',
        'between' => 'entre',
        'Fulltext Search' => 'Recerca de text complet',
        'Data' => 'Dades',
        'Options' => 'Opcions',
        'Title' => 'Títol',
        'Item' => 'Article',
        'Delete' => 'Esborrar',
        'Edit' => 'Editar',
        'View' => 'Veure',
        'Number' => 'Nombre',
        'System' => 'Sistema',
        'Contact' => 'Contacte',
        'Contacts' => 'Contactes',
        'Export' => 'Exportar',
        'Up' => 'Amunt',
        'Down' => 'Avall',
        'Add' => 'Afegir',
        'Category' => 'Categoria',
        'Viewer' => 'Visualitzador',
        'New message' => 'Nou missatge',
        'New message!' => 'Nou missatge!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Per favor respongui al tiquet per a regressar a la vista normal de la cua.',
        'You got new message!' => 'Vostè té un nou missatge',
        'You have %s new message(s)!' => 'Vostè té %s un nou(s) missatge(s)!',
        'You have %s reminder ticket(s)!' => 'Vostè té %s tiquets recordatoris',
        'The recommended charset for your language is %s!' => 'El joc de caràcters recomanat per al seu idioma és %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Les contrasenyes no coincideixen. Per favor intenti\'l de nou !',
        'Password is already in use! Please use an other password!' => 'La contrasenya ja s\'està utilitzant! Per Favor utilitzi altra!',
        'Password is already used! Please use an other password!' => 'La contrasenya ja va ser usada! Per Favor utilitzi altra!',
        'You need to activate %s first to use it!' => 'Necessita activar %s primer per a usar-lo!',
        'No suggestions' => 'Sense suggeriments',
        'Word' => 'Paraula',
        'Ignore' => 'Ignorar',
        'replace with' => 'reemplaçar amb',
        'There is no account with that login name.' => 'No existeix un compte amb aquest login',
        'Login failed! Your username or password was entered incorrectly.' => 'Identificació incorrecta. El seu nom d\'usuari o contrasenya ha estat introduït incorrectament',
        'Please contact your admin' => 'Per favor contacti amb ladministrador',
        'Logout successful. Thank you for using OTRS!' => 'Desconnexió reeixida. Gràcies per utilitzar OTRS!',
        'Invalid SessionID!' => 'Sessió no vàlida',
        'Feature not active!' => 'Característica no activa',
        'Login is needed!' => 'Es requereix login',
        'Password is needed!' => 'Falta la contrasenya!',
        'License' => 'Llicència',
        'Take this Customer' => 'Utilitzar aquest client',
        'Take this User' => 'Utilitzar aquest usuari',
        'possible' => 'possible',
        'reject' => 'rebutjar',
        'reverse' => 'capgirar',
        'Facility' => 'Facilitat',
        'Timeover' => 'Vencimient',
        'Pending till' => 'Pendent fins a',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'No treballi amb l\'Identificador 1 (compte de sistema)! Creï nous usuaris!',
        'Dispatching by email To: field.' => 'Despatxar pel camp To: del correu',
        'Dispatching by selected Queue.' => 'Despatxar per la cua seleccionada',
        'No entry found!' => 'No es va trobar!',
        'Session has timed out. Please log in again.' => 'La sessió ha expirat. Per favor iniciï una sessió novament.',
        'No Permission!' => 'No té Permís!',
        'To: (%s) replaced with database email!' => 'To: (%s) substituït amb email de la base de dades!',
        'Cc: (%s) added database email!' => 'Cc: (%s) Afegit a la base de correu!',
        '(Click here to add)' => '(Faci clic aqui per a afegir)',
        'Preview' => 'Vista Prèvia',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Paquet no instal·lat correctament! Vostè ha de reinstal·lar el paquet novament!',
        'Added User "%s"' => 'Afegit Usuari "%s"',
        'Contract' => 'Contracte',
        'Online Customer: %s' => 'Client connectat: %s',
        'Online Agent: %s' => 'Agent connectat: %s',
        'Calendar' => 'Calendari',
        'File' => 'Arxiu',
        'Filename' => 'Nom de l\'arxiu',
        'Type' => 'Tipus',
        'Size' => 'Tamany',
        'Upload' => 'Penjar',
        'Directory' => 'Directori',
        'Signed' => 'Signat',
        'Sign' => 'Signatura',
        'Crypted' => 'Encriptat',
        'Crypt' => 'Encriptar',
        'Office' => 'Oficina',
        'Phone' => 'Telèfono',
        'Fax' => 'Fax',
        'Mobile' => 'Mòbil',
        'Zip' => 'CP',
        'City' => 'Ciutat',
        'Street' => 'Carrer',
        'Country' => 'Pais',
        'Location' => '',
        'installed' => 'instal·lat',
        'uninstalled' => 'desinstal·lat',
        'Security Note: You should activate %s because application is already running!' => 'Nota de seguretat: Vostè ha d\'activar %s perquè l\'aplicació ja està corrent!',
        'Unable to parse Online Repository index document!' => 'Incapaç d\'interpretar el document índex del Repositorio en Línia!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'No hi ha paquets per al Framework sol·licitat en aquest repositori en línia, però si hi ha per a altres Frameworks',
        'No Packages or no new Packages in selected Online Repository!' => 'No hi ha paquets o no hi ha paquets nous en el repositori en línia seleccionat',
        'printed at' => 'imprès en',
        'Dear Mr. %s,' => 'Benvolgut Sr. %s',
        'Dear Mrs. %s,' => 'Benvolguda Sra. %s',
        'Dear %s,' => 'Benvolgut %s',
        'Hello %s,' => 'Hola %s,',
        'This account exists.' => 'Aquest compte existeix',
        'New account created. Sent Login-Account to %s.' => 'Nou compte creat. Dades d\'inici de sessió enviats a %s.',
        'Please press Back and try again.' => 'Per favor premi Tornar i provi de nou.',
        'Sent password token to: %s' => 'Enviar el \'token\' de la contrasenya a: %s ',
        'Sent new password to: %s' => 'Enviar nova contrasenya a: %s',
        'Invalid Token!' => '\'Token\' invàlid!',

        # Template: AAAMonth
        'Jan' => 'Gen',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Abr',
        'May' => 'Maig',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Ago',
        'Sep' => 'Set',
        'Oct' => 'Oct',
        'Nov' => 'Nov',
        'Dec' => 'Des',
        'January' => 'Gener',
        'February' => 'Febrer',
        'March' => 'Març',
        'April' => 'Abril',
        'June' => 'Juny',
        'July' => 'Juliol',
        'August' => 'Agost',
        'September' => 'Setembre',
        'October' => 'Octubre',
        'November' => 'Novembre',
        'December' => 'Desembre',

        # Template: AAANavBar
        'Admin-Area' => 'Area d\'administració',
        'Agent-Area' => 'Area-Agent',
        'Ticket-Area' => 'Area-Tiquet',
        'Logout' => 'Desconnectar-se',
        'Agent Preferences' => 'Preferències d\'Agent',
        'Preferences' => 'Preferències',
        'Agent Mailbox' => 'Bústia d\'Agent',
        'Stats' => 'Estadístiques',
        'Stats-Area' => 'Area-Estadístiques',
        'Admin' => 'Admin',
        'Customer Users' => 'Clients',
        'Customer Users <-> Groups' => 'Clients <-> Grups',
        'Users <-> Groups' => 'Usuaris <-> Grups',
        'Roles' => 'Rols',
        'Roles <-> Users' => 'Rols <-> Usuaris',
        'Roles <-> Groups' => 'Rols <-> Grups',
        'Salutations' => 'Salutacions',
        'Signatures' => 'Signatures',
        'Email Addresses' => 'Adreces de Correu',
        'Notifications' => 'Notificacions',
        'Category Tree' => 'Arbre de categories',
        'Admin Notification' => 'Notificació a l\'administrador',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Les preferències van ser actualitzades!',
        'Mail Management' => 'Gestió de Correus',
        'Frontend' => 'Frontal',
        'Other Options' => 'Altres Opcions',
        'Change Password' => 'Canviar contrasenya',
        'New password' => 'Nova contrasenya',
        'New password again' => 'Repetir Contrasenya',
        'Select your QueueView refresh time.' => 'Seleccioni el temps d\'actualització de la vista de cues',
        'Select your frontend language.' => 'Seleccioni el seu idioma de treball',
        'Select your frontend Charset.' => 'Seleccioni el seu joc de caràcters',
        'Select your frontend Theme.' => 'Seleccioni el seu tema',
        'Select your frontend QueueView.' => 'Seleccioni la seva Vista de cua de treball',
        'Spelling Dictionary' => 'Diccionari Ortogràfic',
        'Select your default spelling dictionary.' => 'Seleccioni el seu diccionari per defecte',
        'Max. shown Tickets a page in Overview.' => 'Quantitat de Tiquets a mostrar en Resum',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'No es pot actualitzar la contrasenya, no coincideixen! Per favor intenti\'l de nou!',
        'Can\'t update password, invalid characters!' => 'No es pot actualitzar la contrasenya, caràcters invàlids!',
        'Can\'t update password, need min. 8 characters!' => 'No es pot actualitzar la contrasenya, es necessiten almenys 8 caràcters',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'No es pot actualitzar la contrasenya, es necessiten almenys 2 en minúscula i 2 en majúscula!',
        'Can\'t update password, need min. 1 digit!' => 'No es pot actualitzar la contrasenya, es necessita almenys 1 dígit!',
        'Can\'t update password, need min. 2 characters!' => 'No es pot actualitzar la contrasenya, es necessiten almenys 2 caràcters!',

        # Template: AAAStats
        'Stat' => 'Estadístiques',
        'Please fill out the required fields!' => 'Per favor empleni els camps requerits',
        'Please select a file!' => 'Per favor seleccioni un arxiu',
        'Please select an object!' => 'Per favor seleccioni un objecte',
        'Please select a graph size!' => 'Per favor, seleccioni una grandària de gràfic',
        'Please select one element for the X-axis!' => 'Per favor, seleccioni un element per a l\'eix X',
        'You have to select two or more attributes from the select field!' => 'Ha de seleccionar dos o més atributs del camp seleccionat',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Per favor, seleccioni un sol element o desactivi el botó \'Fix\' on el camp seleccionat està marcat!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Si usa una casella de selecció, ha de seleccionar alguns atributs del camp seleccionat',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Per favor introdueixi un valor en el camp d\'entrada o desactivi la selecció \'Fixa\'',
        'The selected end time is before the start time!' => 'La data de final és prèvia a la inicial!',
        'You have to select one or more attributes from the select field!' => 'Ha de seleccionar un o més atributs del camp seleccionat!',
        'The selected Date isn\'t valid!' => 'La data seleccionada no és vàlida',
        'Please select only one or two elements via the checkbox!' => 'Per favor seleccioni només un o dos elements usant la casella de selecció!',
        'If you use a time scale element you can only select one element!' => 'Si utilitza l\'escala de temps només pot seleccionar un element!',
        'You have an error in your time selection!' => 'Té un error en la selecció de temps!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'L\'interval de temps per a informes és massa petit, per favor utilitzi una escala de temps major!',
        'The selected start time is before the allowed start time!' => 'El període de temps inicial és anterior al permès!',
        'The selected end time is after the allowed end time!' => 'El període de temps final és posterior al permès!',
        'The selected time period is larger than the allowed time period!' => 'El període de temps és major que el permès!',
        'Common Specification' => 'Especificació comuna',
        'Xaxis' => 'EixX',
        'Value Series' => 'Sèrie de Valors',
        'Restrictions' => 'Restriccions',
        'graph-lines' => 'gràfica-de-línies',
        'graph-bars' => 'gràfica-de-barres',
        'graph-hbars' => 'gràfica-de-barreshor',
        'graph-points' => 'gràfica-de-punts',
        'graph-lines-points' => 'gràfica-de-línies-punts',
        'graph-area' => 'gráfica-de-àrea',
        'graph-pie' => 'gráfica-de-pastís',
        'extended' => 'estès',
        'Agent/Owner' => 'Agent/Propietari',
        'Created by Agent/Owner' => 'Creat per Agent/Propietari',
        'Created Priority' => 'Prioritat de Creació',
        'Created State' => 'Estat al Crear-se',
        'Create Time' => 'Data de Creació',
        'CustomerUserLogin' => 'Login de Client',
        'Close Time' => 'Data de Tancament',

        # Template: AAATicket
        'Lock' => 'Bloquejar',
        'Unlock' => 'Desbloquejar',
        'History' => 'Història',
        'Zoom' => 'Detall',
        'Age' => 'Antiguitat',
        'Bounce' => 'Rebotar',
        'Forward' => 'Reenviar',
        'From' => 'De',
        'To' => 'A',
        'Cc' => 'Còpia ',
        'Bcc' => 'Còpia Invisible',
        'Subject' => 'Assumpte',
        'Move' => 'Moure',
        'Queue' => 'Cues',
        'Priority' => 'Prioritat',
        'Priority Update' => 'Actualitzar la prioritat',
        'State' => 'Estat',
        'Compose' => 'Redactar',
        'Pending' => 'Pendent',
        'Owner' => 'Propietari',
        'Owner Update' => 'Actualitzar Propietari',
        'Responsible' => 'Responsable',
        'Responsible Update' => 'Actualitzar Responsable',
        'Sender' => 'Remitent',
        'Article' => 'Article',
        'Ticket' => 'Tiquet',
        'Createtime' => 'Data de creació',
        'plain' => 'text',
        'Email' => 'Correu',
        'email' => 'correu',
        'Close' => 'Tancar',
        'Action' => 'Acció',
        'Attachment' => 'Adjunt',
        'Attachments' => 'Adjunts',
        'This message was written in a character set other than your own.' => 'Aquest missatge va ser escrit usant un joc de caràcters distint al seu',
        'If it is not displayed correctly,' => 'Si no es mostra correctament',
        'This is a' => 'Aquest és un',
        'to open it in a new window.' => 'Per a obrir en una nova finestra',
        'This is a HTML email. Click here to show it.' => 'Aquest és un missatge HTML. Faci clic aquí per a mostrar-lo.',
        'Free Fields' => 'Camps lliures',
        'Merge' => 'Fusionar',
        'merged' => 'fusionat',
        'closed successful' => 'tancat amb èxit',
        'closed unsuccessful' => 'tancat sense èxit ',
        'new' => 'nou',
        'open' => 'obert',
        'closed' => 'tancat',
        'removed' => 'eliminat',
        'pending reminder' => 'recordatori pendent',
        'pending auto' => 'pendent auto',
        'pending auto close+' => 'pendent auto close+',
        'pending auto close-' => 'pendent auto close-',
        'email-external' => 'correu-extern',
        'email-internal' => 'correu-intern',
        'note-external' => 'nota-externa',
        'note-internal' => 'nota-interna',
        'note-report' => 'nota-informe',
        'phone' => 'telèfon',
        'sms' => 'sms',
        'webrequest' => 'Sol·licitud via web',
        'lock' => 'bloquejat',
        'unlock' => 'desbloquejat',
        'very low' => 'molt baix',
        'low' => 'baix',
        'normal' => 'normal',
        'high' => 'alt',
        'very high' => 'molt alt',
        '1 very low' => '1 molt baix',
        '2 low' => '2 baix',
        '3 normal' => '3 normal',
        '4 high' => '4 alt',
        '5 very high' => '5 molt alt',
        'Ticket "%s" created!' => 'Tiquet "%s" creat!',
        'Ticket Number' => 'Nombre tiquet',
        'Ticket Object' => 'Objecte tiquet',
        'No such Ticket Number "%s"! Can\'t link it!' => 'No existeix el tiquet Nombre "%s"! No pot vincular-lo!',
        'Don\'t show closed Tickets' => 'No mostrar els tiquets tancats',
        'Show closed Tickets' => 'Mostrar Tiquets tancats',
        'New Article' => 'Nou article',
        'Email-Ticket' => 'Tiquet-Correu',
        'Create new Email Ticket' => 'Crea nou tiquet de correu',
        'Phone-Ticket' => 'Tiquet-Telefònic',
        'Search Tickets' => 'Cercar tiquets',
        'Edit Customer Users' => 'Editar els usuaris del client',
        'Edit Customer Company' => 'Editar la companyia del client',
        'Bulk-Action' => 'Acció múltiple',
        'Bulk Actions on Tickets' => 'Acció múltiple en tiquets',
        'Send Email and create a new Ticket' => 'Enviar un correu i crear un nou tiquet',
        'Create new Email Ticket and send this out (Outbound)' => 'Crea nou tiquet de correu i ho envia (sortida)',
        'Create new Phone Ticket (Inbound)' => 'Crea nou tiquet telefònic (entrada)',
        'Overview of all open Tickets' => 'Resum de tots els tiquets oberts',
        'Locked Tickets' => 'Tiquets bloquejats',
        'Watched Tickets' => 'Tiquets observats',
        'Watched' => 'Observat',
        'Subscribe' => 'Subscriure',
        'Unsubscribe' => 'Cancel·lar subscripció',
        'Lock it to work on it!' => 'Bloquejar-lo per a treballar en ell!',
        'Unlock to give it back to the queue!' => 'Desbloquejar-lo per a regressar-lo a la cua!',
        'Shows the ticket history!' => 'Mostrar la història del tiquet!',
        'Print this ticket!' => 'Imprimir aquest tiquet!',
        'Change the ticket priority!' => 'Canviar la prioritat del tiquet!',
        'Change the ticket free fields!' => 'Canviar els camps lliures del tiquet!',
        'Link this ticket to an other objects!' => 'Enllaçar aquest tiquet a altres objectes',
        'Change the ticket owner!' => 'Canviar el propietari del tiquet!',
        'Change the ticket customer!' => 'Canviar el client del tiquet!',
        'Add a note to this ticket!' => 'Afegir una nota a aquest tiquet!',
        'Merge this ticket!' => 'Unir aquest tiquet!',
        'Set this ticket to pending!' => 'Col·locar aquest tiquet com pendent!',
        'Close this ticket!' => 'Tancar aquest tiquet!',
        'Look into a ticket!' => 'Revisar un tiquet',
        'Delete this ticket!' => 'Eliminar aquest tiquet!',
        'Mark as Spam!' => 'Marcar com correu no desitjat!',
        'My Queues' => 'Les meves Cues',
        'Shown Tickets' => 'Mostrar tiquets',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'El seu correu amb nombre de tiquet "<OTRS_TICKET>" es va unir a "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Tiquet %s: Temps per a primera resposta ha vençut (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Tiquet %s: Temps per a primera resposta està per vèncer en %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiquet %s: Temps per a actualització ha vençut (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiquet %s: Temps per a actualització està per vèncer en %s!',
        'Ticket %s: solution time is over (%s)!' => 'Tiquet %s: Temps per a solució ha vençut (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiquet %s: Temps per a solució està per vèncer en %s!',
        'There are more escalated tickets!' => 'No hi ha més tiquets escalats',
        'New ticket notification' => 'Notificació de nous tiquets',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Notifiqui\'m si hi ha un nou tiquet en "Les meves Cues".',
        'Follow up notification' => 'Seguir notificació',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Notifiqui\'m si un client envia un seguiment i jo sóc el propietari del tiquet.',
        'Ticket lock timeout notification' => 'Notificació de bloqueig de tiquets per temps',
        'Send me a notification if a ticket is unlocked by the system.' => 'Notifiqui\'m si un tiquet és desbloquejat pel sistema',
        'Move notification' => 'Notificació de moviments',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Notifiqui\'m si un tiquet és mogut en una de "Les meves Cues". ',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Cua de selecció de cues favorites. Vostè també pot ser notificat d\'aquestes cues per correu si està habilitat',
        'Custom Queue' => 'Cua personal',
        'QueueView refresh time' => 'Temps d\'actualització de la vista de cues',
        'Screen after new ticket' => 'Pantalla posterior a nou tiquet',
        'Select your screen after creating a new ticket.' => 'Seleccioni la pantalla a mostrar després de crear un tiquet ',
        'Closed Tickets' => 'Tiquets tancats',
        'Show closed tickets.' => 'Mostrar tiquets tancats',
        'Max. shown Tickets a page in QueueView.' => 'Quantitat de Tiquets a mostrar en la Vista de Cua',
        'CompanyTickets' => 'TiquetsCompanyia',
        'MyTickets' => 'ElsMeusTiquets',
        'New Ticket' => 'NouTiquet',
        'Create new Ticket' => 'Crear un nou tiquet',
        'Customer called' => 'Client cridat ',
        'phone call' => 'Cridada telefònica',
        'Responses' => 'Respostes',
        'Responses <-> Queue' => 'Respostes <-> Cues',
        'Auto Responses' => 'Respostes Automàtiques',
        'Auto Responses <-> Queue' => 'Respostes Automàtiques <-> Cues',
        'Attachments <-> Responses' => 'Adjunts <-> Respostes',
        'History::Move' => 'Tiquet mogut a la cua "%s" (%s) de la cua "%s" (%s).',
        'History::TypeUpdate' => 'Tipus actualitzat a %s (ANEU=%s).',
        'History::ServiceUpdate' => 'Servei actualitzat a %s (ANEU=%s).',
        'History::SLAUpdate' => 'SLA actualitzada a %s (ANEU=%s).',
        'History::NewTicket' => 'Nou tiquet [s] creat (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Seguiment per a [s]. %s',
        'History::SendAutoReject' => 'Rebuig automàtic enviat a "%s".',
        'History::SendAutoReply' => 'Resposta automàtica enviada a "%s".',
        'History::SendAutoFollowUp' => 'Seguiment automàtic enviat a "%s".',
        'History::Forward' => 'Reexpedit a "%s".',
        'History::Bounce' => 'Reexpedit a "%s".',
        'History::SendAnswer' => 'Correu enviat a "%s".',
        'History::SendAgentNotification' => '"%s"-notificació enviada a "%s".',
        'History::SendCustomerNotification' => 'Notificació; enviada a "%s".',
        'History::EmailAgent' => 'Correu enviat al agent.',
        'History::EmailCustomer' => 'Afegit correu. %s',
        'History::PhoneCallAgent' => 'El agent va cridar al client.',
        'History::PhoneCallCustomer' => 'El client va cridar.',
        'History::AddNote' => 'Anota afegida (%s)',
        'History::Lock' => 'Tiquet bloquejat.',
        'History::Unlock' => 'Tiquet desbloquejat.',
        'History::TimeAccounting' => '%s unitat(s) de temps comptabilitzades. Nou total : %s unitat(s) de temps.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Actualitzat: %s',
        'History::PriorityUpdate' => 'Canviar prioritat de "%s" (%s) a "%s" (%s).',
        'History::OwnerUpdate' => 'El nou propietari és "%s" (ID=%s).',
        'History::LoopProtection' => 'Protecció de llaç! NO es va enviar auto-resposta a "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Actualitzat: %s',
        'History::StateUpdate' => 'Antic: "%s" Nou: "%s"',
        'History::TicketFreeTextUpdate' => 'Actualitzat: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Sol·licitud de client per web.',
        'History::TicketLinkAdd' => 'Afegit enllaç al tiquet "%s".',
        'History::TicketLinkDelete' => 'Eliminat enllaç al tiquet "%s".',
        'History::Subscribe' => 'Subscriure\'s',
        'History::Unsubscribe' => 'Cancel·lar subscripció',

        # Template: AAAWeekDay
        'Sun' => 'Diu',
        'Mon' => 'Dil',
        'Tue' => 'Dim',
        'Wed' => 'DiM',
        'Thu' => 'Dij',
        'Fri' => 'Div',
        'Sat' => 'Dis',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'gestió d\'adjunts',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Gestió de respostes automàtiques',
        'Response' => 'Resposta',
        'Auto Response From' => 'Resposta automàtica de ',
        'Note' => 'Nota',
        'Useable options' => 'Opcions accessibles',
        'To get the first 20 character of the subject.' => 'Per a obtenir els primers 20 caràcters de l\'assumpte.',
        'To get the first 5 lines of the email.' => 'Per a obtenir les primeres 5 línies del correu.',
        'To get the realname of the sender (if given).' => 'Per a obtenir el nom real del remitent (si existeix).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Per a obtenir l\'atribut de l\'article (p.e.,
(<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> i <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Opcions de dades de l\'actual usuari client (p.e., <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Opcions del propietari del tiquet (p.e., <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Opcions del responsable del tiquet (p.e., <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Opcions de l\'actual usuari qui va requerir aquesta acció (p.e., <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Opcions de dades del tiquet (p.e., <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Opcions de configuració (p.e., <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Administració de Client Companyia',
        'Search for' => 'Cercar per',
        'Add Customer Company' => 'Agregar Client Companyia',
        'Add a new Customer Company.' => 'Agregar un nou Client Companyia',
        'List' => 'Llista',
        'This values are required.' => 'Aquests valors són obligatoris',
        'This values are read only.' => 'Aquests valors són només de lectura',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Gestió de clients',
        'Add Customer User' => 'Agregar Client Usuari',
        'Source' => 'Origen',
        'Create' => 'Crear',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'El client necessita tenir una història i connectar-se via panell de clients',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Clients <-> Gestió de Grups',
        'Change %s settings' => 'Canviar %s especificacions',
        'Select the user:group permissions.' => 'Seleccionar els permisos d\'usuari:grup',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Si no se selecciona alguna cosa, no haurà permisos en aquest grup (Els tiquets no estaran disponibles per a aquest client).',
        'Permission' => 'Permisos',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Accés de només lectura als tiquets en aquest grup/cua.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' => 'Accés complet de lectura i escriptura als tiquets en aquest grup/cua.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Clients <-> Gestió de serveis',
        'CustomerUser' => 'UsuariClient',
        'Service' => 'Servei',
        'Edit default services.' => 'Editar serveis predeterminats',
        'Search Result' => 'Resultat de la recerca',
        'Allocate services to CustomerUser' => 'Assignar serveis a clients',
        'Active' => 'Actiu',
        'Allocate CustomerUser to service' => 'Assignar clients a serveis',

        # Template: AdminEmail
        'Message sent to' => 'Missatge enviat a',
        'Recipents' => 'Destinataris',
        'Body' => 'Cos',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'GenericAgent' => 'AgentGenèric',
        'Job-List' => 'Llista de Tasques',
        'Last run' => 'Última execució',
        'Run Now!' => 'Executar ara',
        'x' => 'x',
        'Save Job as?' => 'Guardar Tasca com?',
        'Is Job Valid?' => 'És una tasca Vàlida?',
        'Is Job Valid' => 'És una tasca Vàlida',
        'Schedule' => 'Horari',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Recerca de text en Article (ex. "Mar*in" or "Baue*") ',
        '(e. g. 10*5155 or 105658*)' => '(ex: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(ex: 234321)',
        'Customer User Login' => 'Identificador del client',
        '(e. g. U5150)' => '(ex: U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Agent',
        'Ticket Lock' => 'Tiquet Bloquejat',
        'TicketFreeFields' => 'CampsLliuresDeTiquet',
        'Create Times' => 'Temps de Creació',
        'No create time settings.' => 'No hi ha valors per a temps de creació',
        'Ticket created' => 'Tiquet creat',
        'Ticket created between' => 'Tiquet creat entre',
        'Close Times' => 'Temps tancats',
        'No close time settings.' => 'Sense configuración de temps tancat',
        'Ticket closed' => 'Tiquet tancat',
        'Ticket closed between' => 'Tiquet tancat entre',
        'Pending Times' => 'Temps Pendents',
        'No pending time settings.' => 'No hi ha valors per a temps de pendent',
        'Ticket pending time reached' => 'Temps de Pendent del Tiquet arribat',
        'Ticket pending time reached between' => 'Temps de Pendent del Tiquet arribat entre',
        'New Service' => 'Nou servei',
        'New SLA' => 'Nova SLA',
        'New Priority' => 'Nova prioritat',
        'New Queue' => 'Nova cua',
        'New State' => 'Nou estat',
        'New Agent' => 'Nou Agent',
        'New Owner' => 'Nou Propietari',
        'New Customer' => 'Nou Client',
        'New Ticket Lock' => 'Nou bloqueig de tiquet',
        'New Type' => 'Nou tipus',
        'New Title' => 'Nou títol',
        'New Type' => 'Nou tipus',
        'New TicketFreeFields' => 'Nou CampsLliuresDeTiquet',
        'Add Note' => 'Afegir Nota',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'S\'executarà el comandament. ARG%[0] el nombre del tiquet. ARG%[0] l\'id del tiquet.',
        'Delete tickets' => 'Eliminar tiquets',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Avís! Aquests tiquets seran eliminats de la base de dades! Aquests tiquets es perdran!',
        'Send Notification' => 'Enviar Notificació',
        'Param 1' => 'Paràmetre 1',
        'Param 2' => 'Paràmetre 2',
        'Param 3' => 'Paràmetre 3',
        'Param 4' => 'Paràmetre 4',
        'Param 5' => 'Paràmetre 5',
        'Param 6' => 'Paràmetre 6',
        'Send no notifications' => 'No enviar notificacions',
        'Yes means, send no agent and customer notifications on changes.' => 'Si, significa no enviar notificacions als agents i clients al realitzar-se canvis.',
        'No means, send agent and customer notifications on changes.' => 'No, significa enviar als agents i clients notificacions al realitzar canvis.',
        'Save' => 'Guardar',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tiquets Modificats! Realment desitja utilitzar aquesta tasca?',
        '"}' => '"}',

        # Template: AdminGroupForm
        'Group Management' => 'Administració de grups',
        'Add Group' => 'Afegir Grup',
        'Add a new Group.' => 'Afegir nou grup',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'El grup admin és per a usar l\'àrea d\'administració i el grup stats per a usar l\'àrea estadisticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Crear nous grups per a manipular els permisos d\'accés per diferents grups d\'agent (exemple: departament de compra, departament de suport, departament de vendes,...).',
        'It\'s useful for ASP solutions.' => 'Això és útil per a solucions ASP.',

        # Template: AdminLog
        'System Log' => 'Traces del Sistema',
        'Time' => 'Temps',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestió de comptes de correu',
        'Host' => 'Amfitrió',
        'Trusted' => 'Es pot confiar',
        'Dispatching' => 'Remetent',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Tots els correus d\'entrada seran enviats a la cua seleccionada',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Si es pot confiar en el seu compte, els camps X-OTRS ja existents en la capçalera en el moment de l\'arribada (per a prioritat, ...) s\'utilitzaran! El filtre PostMaster s\'utilitzarà de totes maneres.',

        # Template: AdminNavigationBar
        'Users' => 'Usuaris',
        'Groups' => 'Grups',
        'Misc' => 'Miscel·lànies',

        # Template: AdminNotificationForm
        'Notification Management' => 'Gestió de Notificacions',
        'Notification' => 'Notificacions',
        'Notifications are sent to an agent or a customer.' => 'Les notificacions se li envian a un agent o client',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestor de paquets',
        'Uninstall' => 'Desinstal·lar',
        'Version' => 'Version',
        'Do you really want to uninstall this package?' => 'Segur que desitja desinstal·lar aquest paquet?',
        'Reinstall' => 'Reinstal·lar',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Realment desitja reinstal·lar aquest paquet (tots els canvis manuals es perdran)?',
        'Continue' => 'Continua',
        'Install' => 'Instal·lar',
        'Package' => 'Paquet',
        'Online Repository' => 'Repositori en línia',
        'Vendor' => 'Venedor',
        'Upgrade' => 'Actualitzer',
        'Local Repository' => 'Repositori Local',
        'Status' => 'Estat',
        'Overview' => 'Resum',
        'Download' => 'Descarregar',
        'Rebuild' => 'Reconstruir',
        'ChangeLog' => 'CanviLog',
        'Date' => 'Data',
        'Filelist' => 'LlistaFitxer',
        'Download file from package!' => 'Descarregar arxiu del paquet!',
        'Required' => 'Requerit',
        'PrimaryKey' => 'ClauPrimària',
        'AutoIncrement' => 'AutoIncrementar',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Registre de rendiment',
        'This feature is enabled!' => 'Aquesta característica està habilitada',
        'Just use this feature if you want to log each request.' => 'Usi aquesta característica només si desitja registrar cada petició.',
        'Of couse this feature will take some system performance it self!' => 'Evidentment aquesta característica afectarà al rendiment del sistema per si mateixa!',
        'Disable it here!' => 'Desactivar aquí!',
        'This feature is disabled!' => 'Aquesta característica està desactivada!',
        'Enable it here!' => 'Activar aquí',
        'Logfile too large!' => 'Registre molt gran',
        'Logfile too large, you need to reset it!' => 'Registre molt gran, necessita reinicialitzar-lo!',
        'Range' => 'Rang',
        'Interface' => 'Interfície',
        'Requests' => 'Sol·licituds',
        'Min Response' => 'Resposta Mínima',
        'Max Response' => 'Resposta Màxima',
        'Average Response' => 'Resposta Promig',
        'Period' => 'Període',
        'Min' => 'Mín',
        'Max' => 'Màx',
        'Average' => 'Promig',

        # Template: AdminPGPForm
        'PGP Management' => 'Administració PGP',
        'Result' => 'Resultat',
        'Identifier' => 'Identificador',
        'Bit' => 'Bit',
        'Key' => 'Clau',
        'Fingerprint' => 'Empremta digital',
        'Expires' => 'Expira',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'D\'aquesta forma pot editar directament l\'anell de Claus configurat en SysConfig',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestió del filtre PostMaster',
        'Filtername' => 'NombreFiltre',
        'Match' => 'Coincidir',
        'Header' => 'Capçalera',
        'Value' => 'Valor',
        'Set' => 'Ajustar',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Classificar o filtrar correus entrants basat en el camp X-Headers del correu! Pot utilitzar expressions regulars.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Si vol fer coincidir només l\'adreça de correu, usi EMAILADDRESS:info@example.com en el camp From, To o Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Si utilitza una expressió regular, pot també usar el valor trobat en () com [***] en \'Set\'.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Cua <-> Gestió de respostes automàtiques',

        # Template: AdminQueueForm
        'Queue Management' => 'Gestió de Cues',
        'Sub-Queue of' => 'Sub-cua de',
        'Unlock timeout' => 'Temps per a desbloqueig automàtic',
        '0 = no unlock' => '0 = sense bloqueig',
        'Only business hours are counted.' => 'Només es conta l\'horari laboral',
        'Escalation - First Response Time' => 'Escalat - Temps per a Primera Resposta',
        '0 = no escalation' => '0 = sense escalat',
        'Only business hours are counted.' => 'Només es conta l\'horari laboral',
        'Notify by' => 'Notificat per',
        'Escalation - Update Time' => 'Escalat - Temps per a Actualització',
        'Notify by' => 'Notificat per',
        'Escalation - Solution Time' => 'Escalat - Temps per a Solució',
        'Follow up Option' => 'Opció de seguiment',
        'Ticket lock after a follow up' => 'Bloquejar un tiquet després del seguiment',
        'Systemaddress' => 'Adreces de correu del sistema ',
        'Customer Move Notify' => 'Notificar al Client al Moure',
        'Customer State Notify' => 'Notificació d\'estat al Client',
        'Customer Owner Notify' => 'Notificar al propietari al Moure',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un agent bloqueja un tiquet i ell/ella no envia una resposta en aquest temps, el tiquet serà desbloquejat automàticament',
        'Escalation time' => 'Temps d\'escalat',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Si un tiquet no ha estat respost en aquest temps, només aquest tiquet es mostrarà',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si el tiquet està tancat i el client envia un seguiment al mateix, aquest serà bloquejat per a l\'antic propietari',
        'Will be the sender address of this queue for email answers.' => 'Serà l\'adreça de l\'emissor en aquesta cua per a respostes per correu.',
        'The salutation for email answers.' => 'Salutació per a les respostes per correu.',
        'The signature for email answers.' => 'Signatura per a respostes per correu.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envia una notificació per correu si el tiquet es mou',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envia una notificació per correu al client si l\'estat del tiquet canvia',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envia una notificació per correu al client si el propietari del tiquet canvia',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Respostes <-> Gestió de Cues',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Respondre',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Respostes <-> Gestió d\'Annexos',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Gestió de Respostes',
        'A response is default text to write faster answer (with default text) to customers.' => 'Una resposta és el text per defecte per a escriure respostes més ràpid (amb el text per defecte) als clients.',
        'Don\'t forget to add a new response a queue!' => 'No oblidi incloure una nova resposta en la cua!',
        'The current ticket state is' => 'L\'estat actual del tiquet és',
        'Your email address is new' => 'La seva adreça de correu és nova',

        # Template: AdminRoleForm
        'Role Management' => 'Gestió de Rols',
        'Add Role' => 'Afegir rol',
        'Add a new Role.' => 'Afegir un rol nou',
        'Create a role and put groups in it. Then add the role to the users.' => 'Crea un rol i col·loca grups en el mateix. Després afegix el rol als usuaris.',
        'It\'s useful for a lot of users and groups.' => 'És útil per a gestionar molts usuaris i grups.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Rols <-> Gestió de Grups',
        'move_into' => 'moure_a',
        'Permissions to move tickets into this group/queue.' => 'Permís per a moure tiquets a aquest grup/cua',
        'create' => 'crear',
        'Permissions to create tickets in this group/queue.' => 'Permís per a crear tiquets en aquest grup/cua',
        'owner' => 'propietari',
        'Permissions to change the ticket owner in this group/queue.' => 'Permís per a canviar el propietari del tiquet en aquest grup/cua',
        'priority' => 'prioritat',
        'Permissions to change the ticket priority in this group/queue.' => 'Permís per a canviar la prioritat del tiquet en aquest grup/cua',

        # Template: AdminRoleGroupForm
        'Role' => 'Rol',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Rols <-> Gestió d\'Usuaris',
        'Select the role:user relations.' => 'Seleccionar les relacions Rol:Client',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Gestió de salutacions',
        'Add Salutation' => 'Afegir salutació',
        'Add a new Salutation.' => 'Afegir una salutació nova',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL',
        'Limit' => 'Límit',
        'Go' => 'Anar',
        'Select Box Result' => 'Seleccioni tipus de resultat',

        # Template: AdminService
        'Service Management' => 'Gestió de serveis',
        'Add Service' => 'Afegir servei',
        'Add a new Service.' => 'Afegir un servei nou',
        'Sub-Service of' => 'Sub-Servei de',

        # Template: AdminSession
        'Session Management' => 'Gestió de sessions',
        'Sessions' => 'Sessions',
        'Uniq' => 'Únic',
        'Kill all sessions' => 'Finalitzar totes les sessions',
        'Session' => 'Sessió',
        'Content' => 'Contingut',
        'kill session' => 'Finalitzar una sessió',

        # Template: AdminSignatureForm
        'Signature Management' => 'Gestió de signatures',
        'Add Signature' => 'Afegir signatura',
        'Add a new Signature.' => 'Afegir una signatura nova',

        # Template: AdminSLA
        'SLA Management' => 'Gestió de SLA',
        'Add SLA' => 'Afegir SLA',
        'Add a new SLA.' => 'Afegir una SLA nova',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Gestió S/MIME',
        'Add Certificate' => 'Afegir certificat',
        'Add Private Key' => 'Afegir clau privada',
        'Secret' => 'Secret',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => 'D\'aquesta forma pot editar directament la certificació i claus privades en el sistema de fitxers.',

        # Template: AdminStateForm
        'State Management' => 'Gestió d\'estat',
        'Add State' => 'Afegir estat',
        'Add a new State.' => 'Afegir un estat nou',
        'State Type' => 'Tipus d\'estat',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Recordi també actualitzar els estats en el seu arxiu Kernel/Config.pm!',
        'See also' => 'Vegi també',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Group selection' => 'Selecció de Grup',
        'Show' => 'Mostrar',
        'Download Settings' => 'Descarregar Configuració',
        'Download all system config changes.' => 'Descarregar tots els canvis de configuració',
        'Load Settings' => 'Carregar Configuració',
        'Subgroup' => 'Subgrup',
        'Elements' => 'Elements',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Opcions de Configuració',
        'Default' => 'Predeterminat',
        'New' => 'Nou',
        'New Group' => 'Nou grup',
        'Group Ro' => 'Grup Ro',
        'New Group Ro' => 'Nou Grup Ro',
        'NavBarName' => 'NomBarNav',
        'NavBar' => 'BarNav',
        'Image' => 'Imatge',
        'Prio' => 'Prio',
        'Block' => 'Bloquejar',
        'AccessKey' => 'ClauAccés',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Gestió d\'adreces de correu del sistema',
        'Add System Address' => 'Afegir adreça del sistema',
        'Add a new System Address.' => 'Afegir una adreça del sistema nova',
        'Realname' => 'Nom',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tots els missatges entrants amb aquest "correu" (To:) seran enviats a la cua seleccionada!',

        # Template: AdminTypeForm
        'Type Management' => 'Gestió de tipus',
        'Add Type' => 'Afegir tipus',
        'Add a new Type.' => 'Afegir un tipus nou',

        # Template: AdminUserForm
        'User Management' => 'Gestió d\'usuaris',
        'Add User' => 'Afegir usuari',
        'Add a new Agent.' => 'Afegir un usuari nou',
        'Login as' => 'Connectar-se com',
        'Firstname' => 'Nom',
        'Lastname' => 'Cognom',
        'User will be needed to handle tickets.' => 'Es necessita un usuari per a manipular els tiquets.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'No oblidi afegir els nous usuaris als grups i/o rols',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Usuaris <-> Gestió de Grups',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Llibreta d\'Adreces',
        'Return to the compose screen' => 'Tornar a la pantalla de redacció',
        'Discard all changes and return to the compose screen' => 'Descartar tots els canvis i tornar a la pantalla de redacció',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Informació',

        # Template: AgentLinkObject
        'Link Object' => 'Enllaçar Objecte',
        'Select' => 'Seleccionar',
        'Results' => 'Resultats',
        'Total hits' => 'Total de coincidències',
        'Page' => 'Pàgina',
        'Detail' => 'Detall',

        # Template: AgentLookup
        'Lookup' => 'Cercar',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Verificació Ortogràfica',
        'spelling error(s)' => 'errors gramaticals',
        'or' => 'o',
        'Apply these changes' => 'Aplicar aquests canvis',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Segur que desitja eliminar aquest objecte?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Seleccioni les restriccions per a caracteritzar l\'estadística',
        'Fixed' => 'Fix',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Per favor seleccioni un element de desactivi el botó \'Fix\'',
        'Absolut Period' => 'Període Absolut',
        'Between' => 'Entre',
        'Relative Period' => 'Període Relatiu',
        'The last' => 'L\'últim',
        'Finish' => 'Finalitzar',
        'Here you can make restrictions to your stat.' => 'Aquí pot declarar restriccions a les seves estadístiques.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Si elimina la marca en la casella "Fix", l\'agent que genera l\'estadística pot canviar els atributs de l\'element corresponent',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Insereixi les especificacions ordinàries',
        'Permissions' => 'Permisos',
        'Format' => 'Format',
        'Graphsize' => 'TamanyGràfic',
        'Sum rows' => 'Sumar files',
        'Sum columns' => 'Sumar columnes',
        'Cache' => 'Memòria cau',
        'Required Field' => 'Camps obligatoris',
        'Selection needed' => 'Selecció necessària',
        'Explanation' => 'Explicació',
        'In this form you can select the basic specifications.' => 'En aquesta pantalla pot seleccionar les especificacions bàsiques',
        'Attribute' => 'Atribut',
        'Title of the stat.' => 'Títol de l\'estadística',
        'Here you can insert a description of the stat.' => 'Aquí pot inserir una descripció de l\'estadística.',
        'Dynamic-Object' => 'Objecte-Dinàmic',
        'Here you can select the dynamic object you want to use.' => 'Aquí pot seleccionar l\'element dinàmic que desitgi utilitzar',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Nota: Depèn de la seva instal·lació quants objectes dinàmics pot utilitzar)',
        'Static-File' => 'Arxiu-Estàtic',
        'For very complex stats it is possible to include a hardcoded file.' => 'Per a una estadística molt complexa és possible incloure un arxiu prefixat',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Si un nou arxiu prefixat està disponible, aquest atribut se li mostrarà i pot seleccionar un',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Configuració de permisos. Pot seleccionar un o més grups per a fer visible les estadístiques configurades a agents distints',
        'Multiple selection of the output format.' => 'Selecció múltiple del format de sortida',
        'If you use a graph as output format you have to select at least one graph size.' => 'Si utilitza un gràfic com format de sortida ha de seleccionar almenys una tamany de gràfic.',
        'If you need the sum of every row select yes' => 'Si necessita la suma de cada fila seleccioni Si',
        'If you need the sum of every column select yes.' => 'Si necessita la suma de cada columna seleccioni Si',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'La majoria de les estadístiques poden ser conservades en memòria cau. Això accelera la presentació d\'aquesta estadística.',
        '(Note: Useful for big databases and low performance server)' => '(Nota: Útil per a bases de dades grans i servidors de baix rendiment)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Amb una estadística invàlida, no és possible generar estadístiques.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Això és útil si desitja que ningú pugui obtenir el resultat d\'una estadística o la mateixa encara no està configurada ',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Seleccioni els elements per als valors de la sèrie',
        'Scale' => 'Escala',
        'minimal' => 'mínim',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Recordi, que l\'escala per als valors de la sèrie necessita ser major que l\'escala per a l\'eix-X (ej: eix-X => Mes, ValorSeries => Any).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Aquí pot seleccionar el valor de la sèrie. Té la possibilitat de seleccionar un o més elements. Després pot seleccionar els atributs dels elements. Cada atribut serà mostrat com un element de la sèrie. Si no selecciona cap atribut, tots els atributs de l\'element seran utilitzats si genera una estadística.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Seleccioni l\'element, que serà utilitzat en l\'eix-X',
        'maximal period' => 'període màxim',
        'minimal scale' => 'escala mínima',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Aquí pot definir l\'eix-x. Pot seleccionar un element usant la casella de selecció. Després ha de seleccionar dos o més atributs de l\'element. Si no selecciona cap, tots els atributs de l\'element s\'utilitzaran per a generar una estadística. Així com un nou atribut és afegit des de l\'última configuració',

        # Template: AgentStatsImport
        'Import' => 'Importar',
        'File is not a Stats config' => 'L\'arxiu no és una configuració d\'estadístiques',
        'No File selected' => 'No hi ha arxiu seleccionat',

        # Template: AgentStatsOverview
        'Object' => 'Objecte',

        # Template: AgentStatsPrint
        'Print' => 'Imprimir',
        'No Element selected.' => 'No hi ha element seleccionat',

        # Template: AgentStatsView
        'Export Config' => 'Exportar Configuració',
        'Information about the Stat' => 'Informacions sobre l\'estadística',
        'Exchange Axis' => 'Intercanviar Eixos',
        'Configurable params of static stat' => 'Paràmetre configurable d\'estadística estàtica',
        'No element selected.' => 'No hi ha element seleccionat',
        'maximal period from' => 'període màxim de',
        'to' => 'a',
        'Start' => 'Començar',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Amb l\'entrada i camps seleccionats pot configurar les estadístiques a les seves necessitats. Que elements d\'estadístiques pot editar depèn de com hagi estat configurat per l\'administrador.',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Tiquet retornat',
        'Ticket locked!' => 'Tiquet bloquejat!',
        'Ticket unlock!' => 'Tiquet desbloquejat!',
        'Bounce to' => 'Retornar a',
        'Next ticket state' => 'Nou estat del tiquet',
        'Inform sender' => 'Informar a l\'emissor',
        'Send mail!' => 'Enviar correu!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Acció múltiple amb Tiquets',
        'Spell Check' => 'Verificació ortogràfica',
        'Note type' => 'Tipus de nota',
        'Unlock Tickets' => 'Desbloquejar Tiquets',

        # Template: AgentTicketClose
        'Close ticket' => 'Tancar el tiquet',
        'Previous Owner' => 'Propietari Anterior',
        'Inform Agent' => 'Notificar Agent',
        'Optional' => 'Opcional',
        'Inform involved Agents' => 'Notificar Agents involucrats',
        'Attach' => 'Annex',
        'Next state' => 'Següent estat',
        'Pending date' => 'Data pendent',
        'Time units' => 'Unitats de temps',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Redacti una resposta al tiquet',
        'Pending Date' => 'Data pendent',
        'for pending* states' => 'per a estats pendents*',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Canviar client del tiquet',
        'Set customer user and customer id of a ticket' => 'Assignar agent i client d\'un tiquet',
        'Customer User' => 'Client',
        'Search Customer' => 'Recerques del client',
        'Customer Data' => 'Informació del client',
        'Customer history' => 'Història del client',
        'All customer tickets.' => 'Tots els tiquets d\'un client',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Seguiment',

        # Template: AgentTicketEmail
        'Compose Email' => 'Redactar Correu',
        'new ticket' => 'nou tiquet',
        'Refresh' => 'Actualitzar',
        'Clear To' => 'Còpia Oculta a',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => 'Vista escalat de tiquet',
        'Escalation' => 'Escalat',
        'Today' => 'Avui',
        'Tomorrow' => 'Demà',
        'Next Week' => 'Pròxima setmana',
        'up' => 'amunt',
        'down' => 'avall',
        'Escalation' => 'Escalat',
        'Locked' => 'Bloquejat',

        # Template: AgentTicketForward
        'Article type' => 'Tipus d\'article',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Canviar el text lliure del tiquet',

        # Template: AgentTicketHistory
        'History of' => 'Història de',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Bústia',
        'Tickets' => 'Tiquets',
        'of' => 'de',
        'Filter' => 'Filtre',
        'New messages' => 'Nou missatge',
        'Reminder' => 'Recordatori',
        'Sort by' => 'Ordenat per',
        'Order' => 'Ordenar',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Fusionar tiquet',
        'Merge to' => 'Fusionar a',

        # Template: AgentTicketMove
        'Move Ticket' => 'Moure tiquet',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Afegir nota al tiquet',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Canviar el propietari del tiquet',

        # Template: AgentTicketPending
        'Set Pending' => 'Fixar pendent',

        # Template: AgentTicketPhone
        'Phone call' => 'Cridada telefònica',
        'Clear From' => 'Esborrar de',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Text pla',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informació-Tiquet',
        'Accounted time' => 'Temps comptabilitzat',
        'First Response Time' => 'Temps de resposta',
        'Update Time' => 'Temps d\'actualització',
        'Solution Time' => 'Temps de resolució',
        'Linked-Object' => 'Objecte-enllaçat',
        'Parent-Object' => 'Objecte-pare',
        'Child-Object' => 'Objecte-fill',
        'by' => 'per',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Canviar la prioritat del tiquet',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Tiquets mostrats',
        'Tickets available' => 'Tiquets disponibles',
        'All tickets' => 'Tots els tiquets',
        'Queues' => 'Cues',
        'Ticket escalation!' => 'Escalat de tiquet!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => 'Temps de servei',
        'Your own Ticket' => 'Els seus tiquets',
        'Compose Follow up' => 'Redactar seguiment',
        'Compose Answer' => 'Respondre',
        'Contact customer' => 'Contactar amb el client',
        'Change queue' => 'Canviar cua',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Canviar responsable del tiquet',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Buscar tiquet',
        'Profile' => 'Perfil',
        'Search-Template' => 'Buscar-Plantilla',
        'TicketFreeText' => 'TextLliureTiquet',
        'Created in Queue' => 'Creat en Cua',
        'Close Times' => 'Temps tancats',
        'No close time settings.' => 'Sense configuració de temps tancat',
        'Ticket closed' => 'Tiquet tancat',
        'Ticket closed between' => 'Tiquet tancat entre',
        'Result Form' => 'Formulari de resultats',
        'Save Search-Profile as Template?' => 'Guardar perfil de recerca com plantilla?',
        'Yes, save it with name' => 'Si, guardar-lo amb nom',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Canviar opcions de recerca',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Veure l\'estat del tiquet ',
        'Open Tickets' => 'Tiquets Oberts',

        # Template: AgentTicketZoom
        'Expand View' => 'Expandir vista',
        'Collapse View' => 'Reduir vista',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Rastrejar',

        # Template: CustomerFooter
        'Powered by' => 'Funciona con',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Identificador',
        'Lost your password?' => 'Va perdre la seva contrasenya',
        'Request new password' => 'Sol·licitar una nova contrasenya',
        'Create Account' => 'Crear Compte',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Benvingut %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Vegades',
        'No time settings.' => 'Sense especificació de data',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Faci clic aqui per a reportar un error!',

        # Template: Footer
        'Top of Page' => 'Inici de pàgina',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Instal·lador-Web',
        'Welcome to %s' => 'Benvingut a %s',
        'Accept license' => 'Acceptar llicència',
        'Don\'t accept license' => 'No acceptar llicència',
        'Admin-User' => 'Usuari-Admin',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Si la seva base de dades té una contrasenya per a root, ha d\'introduir-la aquí. Si no, deixi aquest camp en blanc. Per raons de seguretat és recomanable posar una contrasenya a l\'usuari root. Per a més informació per favor refereixi\'s a la documentació de la seva base de dades.',
        'Admin-Password' => 'Contrasenya-Admin',
        'Database-User' => 'Usuari-Base de dades',
        'default \'hot\'' => 'per defecte \'hot\'',
        'DB connect host' => 'Amfitrió BD',
        'Database' => 'Base de dades',
        'Default Charset' => 'Joc de caràcters per defecte',
        'utf8' => 'utf8',
        'false' => 'fals',
        'SystemID' => 'ID de sistema',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(La identitat del sistema. Cada nombre de tiquet i cada id de sessió http comença amb aquest nombre)',
        'System FQDN' => 'FQDN del sistema',
        '(Full qualified domain name of your system)' => '(Nom complet del domini del seu sistema)',
        'AdminEmail' => 'Correu de l\'administrador',
        '(Email of the system admin)' => '(correu de l\'administrador del sistema)',
        'Organization' => 'Organizació',
        'Log' => 'Traça',
        'LogModule' => 'Mòdul de traces',
        '(Used log backend)' => '(Interfície de traces utilitzada)',
        'Logfile' => 'Arxiu de traces',
        '(Logfile just needed for File-LogModule!)' => '(Arxiu de traces només necessari para File-LogModule)',
        'Webfrontend' => 'Interfície web',
        'Use utf-8 it your database supports it!' => 'Usar utf-8 si la seva base de dades ho permet!',
        'Default Language' => 'Idioma per defecte',
        '(Used default language)' => '(Idioma per defecte)',
        'CheckMXRecord' => 'Revisar registre MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Chequear registre MX d\'adreces utilitzades al respondre. No usar-lo si la màquina amb OTRS està darrere d\'una linea commutada $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Per a poder utilitzar OTRS ha d\'escriure la següent linea de comandos (Terminal/Shell) com root',
        'Restart your webserver' => 'Reiniciï el seu servidor web',
        'After doing so your OTRS is up and running.' => 'Després de fer això el seu OTRS estarà actiu i executant-se',
        'Start page' => 'Pàgina d\'inici',
        'Your OTRS Team' => 'El seu equip OTRS',

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'No té autorització',

        # Template: Notify
        'Important' => 'Important',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'imprès per',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Pàgina de prova de OTRS ',
        'Counter' => 'Comptador',

        # Template: Warning
        # Misc
        'Edit Article' => 'Editar article',
        'Create Database' => 'Crear Base de dades',
        'Ticket Number Generator' => 'Generador de nombres de Tiquets',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificador de Ticker. Algunes persones agraden d\'usar per exemple \'Tiquet#\', \'Cridada#\' o \'ElMeuTiquet#\')',
        'Create new Phone Ticket' => 'Crear un nou Tiquet Telefònic',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'D\'aquesta forma pot editar directament les claus configurades en Kernel/Config.pm.',
        'Symptom' => 'Símptoma',
        'U' => 'A',
        'A message should have a To: recipient!' => 'El missatge ha de tenes el destinatari To: !',
        'Site' => 'Ubicació',
        'Customer history search (e. g. "ID342425").' => 'Història de recerques del client (exemple: "ID342425").',
        'for agent firstname' => 'nom de l\'agent',
        'Close!' => 'Tancar!',
        'The message being composed has been closed.  Exiting.' => 'El missatge que s\'estava redactant ha estat tancat.  Sortint.',
        'A web calendar' => 'Calendari Web',
        'to get the realname of the sender (if given)' => 'per a obtenir el nom de l\'emissor (si ho va proporcionar)',
        'OTRS DB Name' => 'Nom de la BD OTRS',
        'Notification (Customer)' => 'Notificació (Client)',
        'Select Source (for add)' => 'Seleccionar Font (per a afegir)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Opcions de la data del tiquet (ex. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Days' => 'Dies',
        'Queue ID' => 'ID de la Cua',
        'Home' => 'Inici',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Opcions de configuració (ej: <OTRS_CONFIG_HttpType>)',
        'System History' => 'Història del Sistema',
        'customer realname' => 'Nom del client',
        'Pending messages' => 'Missatges pendents',
        'Modules' => 'Mòduls',
        'for agent login' => 'login de l\'agent',
        'Keyword' => 'paraula clau',
        'Close type' => 'Tipus de tancament',
        'DB Admin User' => 'Usuari Admin de la BD',
        'for agent user id' => 'id de l\'agent',
        'sort upward' => 'ordenar ascendent',
        'Problem' => 'Problema',
        'next step' => 'pròxim pas',
        'Customer history search' => 'Història de recerques del client',
        'Admin-Email' => 'Correu-Admin',
        'Incident Management (OTIC)' => 'Gestió D\'Incidències (OTIC)',
        'Create new database' => 'Crear nova base de dades',
        'A message must be spell checked!' => 'El missatge ha de ser verificat ortograficamente!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'El seu correu amb el tiquet nombre "<OTRS_TICKET>" va ser retornat a "<OTRS_BOUNCE_TO>". Contacti aquesta adreça para mes informació',
        'ArticleID' => 'Identificador d\'article',
        'A message should have a body!' => 'Els missatges han de tenir contingut',
        'All Agents' => 'Tots els Agents',
        'Keywords' => 'Paraules clau',
        'No * possible!' => 'No * possible!',
        'Options ' => 'Opcions',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opcions de l\'usuari actual qui ha sol·licitat aquesta acció (ex.: &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Missatge per al nou propietari',
        'to get the first 5 lines of the email' => 'per a obtenir les primeres 5 línies del correu',
        'OTRS DB Password' => 'Contrasenya per a BD de l\'usuari OTRS',
        'Last update' => 'Darrera actualització',
        'to get the first 20 character of the subject' => 'per a obtenir els primers 20 caràcters de l\'assumpte',
        'Select the customeruser:service relations.' => 'Seleccioni el client:relacions de serveis',
        'DB Admin Password' => 'Contrasenya de l\'administrador de la BD',
        'Advisory' => 'Advertiment',
        'Drop Database' => 'Eliminar Base de dades',
        'FileManager' => 'Administrador d\'Arxius',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Opcions de dades d\'usuari de l\'usuari actual (ex.: <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Tipus pendent',
        'Comment (internal)' => 'Comentari (intern)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opcions del propietari del tiquet (ex.: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'This window must be called from compose window' => 'Aquesta finestra ha de ser cridada des de la finestra de redacció',
        'Minutes' => 'Minuts',
        'You need min. one selected Ticket!' => 'Necessita almenys seleccionar un Tiquet!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Opcions per a la informació de tiquet (ex.: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Format de tiquet usat)',
        'Fulltext' => 'Text Complet',
        'Incident' => 'Incident',
        'All Agent variables.' => 'Totes les variables d\'agent',
        ' (work units)' => ' (unitats de treball)',
        'All Customer variables like defined in config option CustomerUser.' => 'Totes les variables de client com apareixen declarades en l\'opció de configuració del client',
        'accept license' => 'acceptar llicència',
        'for agent lastname' => 'cognom de l\'agent',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Opcions de l\'usuari actiu que sol·licita aquesta acció (ex. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Missatges recordatoris',
        'Change users <-> roles settings' => 'Canviar Usuaris <-> Configuració de Rols',
        'A message should have a subject!' => 'Els missatges han de tenir assumpte!',
        'TicketZoom' => 'Detall del Tiquet',
        'Don\'t forget to add a new user to groups!' => 'No oblidi incloure l\'usuari en grups!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Necessita una adreça de correu (exemple: client@exemple.com) en To:!',
        'CreateTicket' => 'CrearTiquet',
        'You need to account time!' => 'Necessita comptabilitzar el temps!',
        'System Settings' => 'Configuració del sistema',
        'WebWatcher' => 'ObservadorWeb',
        'Hours' => 'Hores',
        'Finished' => 'Finalitzat',
        'Account Type' => 'Tipus compte',
        'Split' => 'Dividir',
        'D' => 'D',
        'System Status' => 'Estat del sistema',
        'All messages' => 'Tots els missatges',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Opcions per a la informació el tiquet (ex. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Artefact' => 'Artefacte',
        'A article should have a title!' => 'Els articles han de tenir títol',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opcions de configuració (ex. &lt;OTRS_CONFIG_HttpType&gt;)',
        'Event' => 'Esdeveniment',
        'don\'t accept license' => 'no accepto la llicència',
        'A web mail client' => 'Un client de correu web',
        'WebMail' => 'Correu web',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Opcions del propietari del tiquet (ex. <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => 'Ha d\'especificar nom!',
        'DB Type' => 'Tipus de BD',
        'kill all sessions' => 'Finalitzar totes les sessions',
        'to get the from line of the email' => 'per a obtenir la línia del registre from: del correu',
        'Solution' => 'Solució',
        'Package not correctly deployed, you need to deploy it again!' => 'El paquet no ha estat correctament instal·lat, necessita instal·lar-lo novament!',
        'QueueView' => 'Veure la cua',
        'Select Box' => 'Finestra de selecció ',
        'Welcome to OTRS' => 'Benvingut a OTRS',
        'modified' => 'modificat',
        'Escalation in' => 'Escalat en',
        'Delete old database' => 'Eliminar la base de dades antiga',
        'sort downward' => 'ordenar descendent',
        'You need to use a ticket number!' => 'Necessita usar un nombre de tiquet! ',
        'A web file manager' => 'Administrador web d\'arxius',
        'Have a lot of fun!' => 'Gaudeixi\'l!',
        'send' => 'enviar',
        'Note Text' => 'Nota!',
        'POP3 Account Management' => 'Gestió de compte POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opcions de dades d\'usuari del client actual (ex. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Gestió d\'estats del Sistema',
        'OTRS DB User' => 'Usuari de BD OTRS',
        'PhoneView' => 'Vista telefònica',
        'maximal period form' => 'màxim període del formulari',
        'TicketID' => 'Identificador de Tiquet',
        'closed with workaround' => 'tancat amb solució temporal',
        'Modified' => 'Modificat',
        'Ticket selected for bulk action!' => 'Tiquet seleccionat per a acció múltiple!',

        'Link Object: %s' => 'Enllaçar l\'objecte: %s',
        'Unlink Object: %s' => 'Llevar enllaç de l\'objecte: %s',
        'Linked as' => 'Enllaçat com',
        'Can not create link with %s!' => 'No es pot crear enllaç amb %s! ',
        'Can not delete link with %s!' => 'No es pot suprimir enllaç amb %s! ',
        'Object already linked as %s.' => 'Objecte ja enllaçat com %s.',
        'Priority Management' => 'Gestió de prioritat',
        'Add a new Priority.' => 'Afegir una nova prioritat',
        'Add Priority' => 'Afegir prioritat',
        'Ticket Type is required!' => '',
    };
    # $$STOP$$
    return;
}

1;
