# --
# Kernel/Language/it.pm - provides it language translation
# Copyright (C) 2003 Remo Catelotti <Remo.Catelotti at bull.it>
#               2003 Gabriele Santilli <gsantilli at omnibus.net>
# --
# $Id: it.pm,v 1.8 2004-02-10 00:18:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::it;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Feb 10 01:07:52 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M/%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %Y %T';
    $Self->{DateInputFormat} = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minuti',
      ' 5 minutes' => ' 5 minuti',
      ' 7 minutes' => ' 7 minuti',
      '(Click here to add)' => '',
      '10 minutes' => '10 minuti',
      '15 minutes' => '15 minuti',
      'AddLink' => 'Aggiungi link',
      'Admin-Area' => 'Area Amministrazione',
      'agent' => 'operatore',
      'Agent-Area' => '',
      'all' => 'tutti',
      'All' => 'Tutti',
      'Attention' => 'Attenzione',
      'before' => '',
      'Bug Report' => 'Segnala anomalie',
      'Cancel' => 'Annulla',
      'change' => 'modifica',
      'Change' => 'Modifica',
      'change!' => 'Modifica!',
      'click here' => 'clicca qui',
      'Comment' => 'Commento',
      'Customer' => 'Cliente',
      'customer' => 'cliente',
      'Customer Info' => 'Informazioni Cliente',
      'day' => 'giorno',
      'day(s)' => '',
      'days' => 'giorni',
      'description' => 'descrizione',
      'Description' => 'Descrizione',
      'Dispatching by email To: field.' => 'Smistamento in base al campo To:.',
      'Dispatching by selected Queue.' => 'Smistamento in base alla coda selezionata.',
      'Don\'t show closed Tickets' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Non lavorare con l\'operatore con ID 1 (System account)! Crea dei nuovi utenti!',
      'Done' => 'Fatto',
      'end' => 'fine pagina',
      'Error' => 'Errore',
      'Example' => 'Esempio',
      'Examples' => 'Esempi',
      'Facility' => 'Funzione',
      'FAQ-Area' => '',
      'Feature not active!' => 'Funzione non attiva!',
      'go' => 'vai',
      'go!' => 'vai!',
      'Group' => 'Gruppo',
      'Hit' => 'Accesso',
      'Hits' => 'Accessi',
      'hour' => 'ora',
      'hours' => 'ore',
      'Ignore' => 'Ignora',
      'invalid' => 'non valido',
      'Invalid SessionID!' => 'ID di sessione non valido!',
      'Language' => 'Lingua',
      'Languages' => 'Lingue',
      'last' => '',
      'Line' => 'Linea',
      'Lite' => '',
      'Login failed! Your username or password was entered incorrectly.' => 'Accesso fallito! Nome utente o password non corretti.',
      'Logout successful. Thank you for using OTRS!' => 'Disconnessione avvenuta con successo. Grazie per aver usato OTRS!',
      'Message' => 'Messaggio',
      'minute' => 'minuto',
      'minutes' => 'minuti',
      'Module' => 'Modulo',
      'Modulefile' => 'Archivio del modulo',
      'month(s)' => '',
      'Name' => 'Nome',
      'New Article' => '',
      'New message' => 'Nuovo messaggio',
      'New message!' => 'Nuovo messaggio!',
      'No' => 'No',
      'no' => 'no',
      'No entry found!' => 'Vuoto!',
      'No suggestions' => 'Non ci sono suggerimenti',
      'none' => 'nessuno',
      'none - answered' => 'nessuno - risposto',
      'none!' => 'nessuno!',
      'Normal' => '',
      'Off' => 'Spento',
      'off' => 'spento',
      'On' => 'Acceso',
      'on' => 'acceso',
      'Password' => 'Password',
      'Pending till' => 'In attesa per',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Per favore rispondi a questi ticket prima di tornare alla lista dei ticket!',
      'Please contact your admin' => 'Per favore contatta il tuo amministratore',
      'please do not edit!' => 'per favore non modificare!',
      'Please go away!' => '',
      'possible' => 'possibile',
      'Preview' => '',
      'QueueView' => 'Lista ticket',
      'reject' => 'respinto',
      'replace with' => 'sostituisci con',
      'Reset' => 'Ripristina',
      'Salutation' => 'Titolo',
      'Session has timed out. Please log in again.' => 'Sessione scaduta. Per favore, effettua di nuovo l\'accesso.',
      'Show closed Tickets' => '',
      'Signature' => 'Firme',
      'Sorry' => 'Spiacente',
      'Stats' => 'Statistiche',
      'Subfunction' => 'Sotto-funzione',
      'submit' => 'Accetta',
      'submit!' => 'accetta!',
      'system' => 'sistema',
      'Take this User' => 'Prendi questo Utente',
      'Text' => 'Testo',
      'The recommended charset for your language is %s!' => 'Il set di caratteri raccomandato per la tua lingua è %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Nome utente non valido.',
      'Timeover' => 'Tempo scaduto',
      'To: (%s) replaced with database email!' => '',
      'top' => 'inizio pagina',
      'update' => 'aggiorna',
      'Update' => '',
      'update!' => 'aggiorna!',
      'User' => 'Utenti',
      'Username' => 'Nome utente',
      'Valid' => 'Valido',
      'Warning' => 'Attenzione',
      'week(s)' => '',
      'Welcome to OTRS' => 'Benvenuto in OTRS',
      'Word' => 'Parola',
      'wrote' => 'ha scritto',
      'year(s)' => '',
      'yes' => 'sì',
      'Yes' => 'Sì',
      'You got new message!' => 'Hai un nuovo messaggio!',
      'You have %s new message(s)!' => 'Hai %s nuovi messaggi!',
      'You have %s reminder ticket(s)!' => 'Hai %s ticket(s) memorizzati',

    # Template: AAAMonth
      'Apr' => 'Apr',
      'Aug' => 'Ago',
      'Dec' => 'Dic',
      'Feb' => 'Feb',
      'Jan' => 'Gen',
      'Jul' => 'Lug',
      'Jun' => 'Giu',
      'Mar' => 'Mar',
      'May' => 'Mag',
      'Nov' => 'Nov',
      'Oct' => 'Ott',
      'Sep' => 'Set',

    # Template: AAAPreferences
      'Closed Tickets' => 'Ticket chiusi',
      'Custom Queue' => 'Coda personale',
      'Follow up notification' => 'Notifica di risposta',
      'Frontend' => 'Interfaccia',
      'Mail Management' => 'Gestione posta',
      'Max. shown Tickets a page in Overview.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Move notification' => 'Notifica spostamento',
      'New ticket notification' => 'Notifica nuovo ticket',
      'Other Options' => 'Altre opzioni',
      'PhoneView' => 'Inserisci ticket',
      'Preferences updated successfully!' => 'Preferenze modificate con successo!',
      'QueueView refresh time' => 'Tempo di aggiornamento lista ticket',
      'Screen after new ticket' => '',
      'Select your default spelling dictionary.' => 'Seleziona il dizionario',
      'Select your frontend Charset.' => 'Seleziona il set di caratteri da usare.',
      'Select your frontend language.' => 'Scegli la lingua per la tua interfaccia.',
      'Select your frontend QueueView.' => 'Scegli l\'interfaccia per la lista messaggi.',
      'Select your frontend Theme.' => 'Scegli il tema per la tua interfaccia.',
      'Select your QueueView refresh time.' => 'Scegli il tempo di aggiornamento della lista ticket.',
      'Select your screen after creating a new ticket.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Mandami una notifica se un cliente risponde ad un ticket che ho io in gestione.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Mandami una notifica se un ticket viene spostato in una delle code visualizzate nella mia coda personale.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Mandami una notifica se un ticket viene sbloccato dal sistema.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Mandami una notifica se c\'è un nuovo ticket in una delle code visualizzate nella mia coda personale.',
      'Show closed tickets.' => 'Mostra i ticket chiusi.',
      'Spelling Dictionary' => 'Dizionario',
      'Ticket lock timeout notification' => 'Notifica scadenza gestione ticket',
      'TicketZoom' => '',

    # Template: AAATicket
      '1 very low' => '1 molto bassa',
      '2 low' => '2 bassa',
      '3 normal' => '3 normale',
      '4 high' => '4 alta',
      '5 very high' => '5 molto alta',
      'Action' => 'Azione',
      'Age' => 'Tempo trascorso',
      'Article' => 'Articolo',
      'Attachment' => 'Allegato',
      'Attachments' => 'Allegati',
      'Bcc' => 'Ccn',
      'Bounce' => 'Rispedisci al mittente',
      'Cc' => 'Cc',
      'Close' => 'Chiudi',
      'closed successful' => 'chiuso',
      'closed unsuccessful' => 'non risolto',
      'Compose' => 'Componi',
      'Created' => 'Creato',
      'Createtime' => 'Creato alle',
      'email' => 'eMail',
      'eMail' => '',
      'email-external' => 'eMail esterna',
      'email-internal' => 'eMail interna',
      'Forward' => 'Inoltra',
      'From' => 'Da',
      'high' => 'alto',
      'History' => 'Storico',
      'If it is not displayed correctly,' => 'Se non è visualizzato correttamente,',
      'lock' => 'prendi in gestione',
      'Lock' => 'Prendi in gestione',
      'low' => 'basso',
      'Move' => 'Sposta',
      'new' => 'nuovo',
      'normal' => 'normale',
      'note-external' => 'Nota esterna',
      'note-internal' => 'Nota interna',
      'note-report' => 'Nota report',
      'open' => 'aperto',
      'Owner' => 'Operatore',
      'Pending' => 'In attesa',
      'pending auto close+' => 'in attesa di chiusura automatica+',
      'pending auto close-' => 'in attesa di chiusura automatica-',
      'pending reminder' => 'in attesa di risposta',
      'phone' => 'Telefono',
      'plain' => '',
      'Priority' => 'Priorità',
      'Queue' => 'Coda',
      'removed' => 'rimosso',
      'Sender' => 'Mittente',
      'sms' => '',
      'State' => 'Stato',
      'Subject' => 'Oggetto',
      'This is a' => 'Questo è un',
      'This is a HTML email. Click here to show it.' => 'Questa è una email in HTML. Clicca qui per visualizzarla.',
      'This message was written in a character set other than your own.' => 'Questo messaggio è stato scritto in un set di caratteri diverso dal tuo.',
      'Ticket' => '',
      'Ticket "%s" created!' => '',
      'To' => 'A',
      'to open it in a new window.' => 'per aprirlo in una nuova finestra.',
      'unlock' => 'abbandona gestione',
      'Unlock' => 'Abbandona gestione',
      'very high' => 'molto alto',
      'very low' => 'molto basso',
      'View' => 'Vista',
      'webrequest' => 'richiesta da web',
      'Zoom' => 'Dettagli',

    # Template: AAAWeekDay
      'Fri' => 'Ven',
      'Mon' => 'Lun',
      'Sat' => 'Sab',
      'Sun' => 'Dom',
      'Thu' => 'Mar',
      'Tue' => 'Gio',
      'Wed' => 'Mer',

    # Template: AdminAttachmentForm
      'Add' => '',
      'Attachment Management' => 'Gestione allegati',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Aggiungi risposta automatica',
      'Auto Response From' => 'Risposta automatica da',
      'Auto Response Management' => 'Gestione risposte automatiche',
      'Change auto response settings' => 'Modifica impostazioni risposta automatica',
      'Note' => 'Nota',
      'Response' => 'Risposta',
      'to get the first 20 character of the subject' => 'per avere i primi 20 caratteri dell\'oggetto',
      'to get the first 5 lines of the email' => 'per avere le prime 5 linee del messaggio',
      'to get the from line of the email' => 'per avere il mittente del messaggio',
      'to get the realname of the sender (if given)' => 'per avere il nome del mittente (se indicato)',
      'to get the ticket id of the ticket' => 'per avere l\'id del ticket',
      'to get the ticket number of the ticket' => 'per avere il numero del ticket',
      'Type' => 'Tipo',
      'Useable options' => 'Opzioni utilizzabili',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Gestione clienti',
      'Customer user will be needed to to login via customer panels.' => 'Qui è possibile inserire gli utenti che possono fare il login nel pannello clienti.',
      'Select source:' => '',
      'Source' => '',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Modifica impostazioni di %s',
      'Customer User <-> Group Management' => '',
      'Full read and write access to the tickets in this group/queue.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => 'Permessi',
      'Read only access to the ticket in this group/queue.' => '',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => '',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Modifica impostazioni Utente <-> Gruppo',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Invia messaggio agli operatori',
      'Body' => 'Testo',
      'OTRS-Admin Info!' => 'Informazioni dall\'amministratore di OTRS',
      'Recipents' => 'Destinatari',
      'send' => 'Invia',

    # Template: AdminEmailSent
      'Message sent to' => 'Messaggio inviato a',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Creare nuovi gruppi per gestire i permessi di accesso per diversi gruppi di agenti (p.es. sezione vendite, supporto tecnico, ecc.)',
      'Group Management' => 'Gestione gruppo',
      'It\'s useful for ASP solutions.' => 'È utile per soluzioni ASP',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Il gruppo admin ha accesso all\'area amministrazione mentre il gruppo stats ha accesso alle statistiche.',

    # Template: AdminLog
      'System Log' => 'Log di sistema',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Messaggio agli operatori',
      'Attachment <-> Response' => 'Allegati <-> Risposte',
      'Auto Response <-> Queue' => 'Risposte automatiche <-> Code',
      'Auto Responses' => 'Risposte automatiche',
      'Customer User' => 'Clienti',
      'Customer User <-> Groups' => '',
      'Email Addresses' => 'Indirizzi Email',
      'Groups' => 'Gruppi',
      'Logout' => 'Esci',
      'Misc' => 'Varie',
      'Notifications' => '',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => 'PostMaster Impostazioni POP3',
      'Responses' => 'Risposte',
      'Responses <-> Queue' => 'Risposte <-> Code',
      'Select Box' => 'Selezionare una funzione',
      'Session Management' => 'Gestione sessioni',
      'Status' => 'Stato',
      'System' => 'Sistema',
      'User <-> Groups' => 'Utenti <-> Gruppi',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Notification Management' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Tutti i messaggi in arrivo saranno smistati nella coda selezionata!',
      'Dispatching' => 'Smistamento',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Se si tratta di un account fidato, verranno usati gli header X-OTRS per la gestione dei ticket!',
      'Login' => '',
      'POP3 Account Management' => 'Gestione accessi POP3',
      'Trusted' => 'Fidato',

    # Template: AdminPostMasterFilterForm
      'Match' => '',
      'PostMasterFilter Management' => '',
      'Set' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestione Code <-> Risposte automatiche',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = nessuna escalation',
      '0 = no unlock' => '0 = nessuno sblocco automatico',
      'Customer Move Notify' => 'Notifica il cliente degli spostamenti',
      'Customer Owner Notify' => 'Notifica il cliente del cambio operatore',
      'Customer State Notify' => 'Notifica il cliente del cambio di stato',
      'Escalation time' => 'Tempo di escalation',
      'Follow up Option' => 'Opzioni per le risposte',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se un ticket è chiuso e il cliente invia una risposta, il ticket viene assegnato al vecchio operatore.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Se un ticket non viene risposto entro questo limite di tempo, sarà l\'unico ticket ad essere mostrato.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se un operatore prende in gestione un ticket ma non risponde entro il tempo specificato, il ticket viene sbloccato in modo da essere accessibile agli altri operatori.',
      'Key' => 'Etichetta',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS invia una notifica via email al cliente se il ticket viene spostato.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS invia una notifica via email al cliente se l\'operatore assegnato al ticket cambia.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS invia una notifica via email al cliente se lo stato del ticket cambia.',
      'Queue Management' => 'Gestione delle code',
      'Sub-Queue of' => 'Sottocoda di',
      'Systemaddress' => 'Indirizzo di sistema',
      'The salutation for email answers.' => 'Il saluto generato automaticamente per le risposte via email.',
      'The signature for email answers.' => 'La firma generata automaticamente per le risposte via email.',
      'Ticket lock after a follow up' => 'Assegnazione ticket dopo una risposta',
      'Unlock timeout' => 'Tempo di sblocco automatico',
      'Will be the sender address of this queue for email answers.' => 'Sarà l\'indirizzo email usato come mittente per le risposte inviate via email.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Gestione Risposte standard <-> Code',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Risposta',
      'Change answer <-> queue settings' => 'Modifica impostazioni Risposta <-> Coda',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Gestione Risposte standard <-> Allegati standard',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Modifica impostazioni Risposte <-> Allegati',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Una risposta è un testo predefinito usato per compilare più rapidamente le risposte per i clienti.',
      'Don\'t forget to add a new response a queue!' => 'Non dimenticare di aggiungere una risposta per ogni coda!',
      'Next state' => 'Stato successivo',
      'Response Management' => 'Gestione risposte',
      'The current ticket state is' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'nome del cliente',
      'for agent firstname' => 'per il nome dell\'operatore',
      'for agent lastname' => 'per il cognome dell\'operatore',
      'for agent login' => 'per il nome utente dell\'operatore',
      'for agent user id' => 'per l\'id utente dell\'operatore',
      'Salutation Management' => 'Gestione saluti',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Numero massimo di linee',

    # Template: AdminSelectBoxResult
      'Limit' => 'Limite',
      'Select Box Result' => 'Seleziona il risultato',
      'SQL' => '',

    # Template: AdminSession
      'Agent' => '',
      'kill all sessions' => 'Termina tutte le sessioni',
      'Overview' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSessionTable
      'kill session' => 'Termina sessione',
      'SessionID' => 'ID sessione',

    # Template: AdminSignatureForm
      'Signature Management' => 'Gestione firme',

    # Template: AdminStateForm
      'See also' => '',
      'State Type' => 'Tipologia',
      'System State Management' => 'Gestione stati ticket',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tutte le email in arrivo indirizzate a questo indirizzo (campo To:) saranno smistate nella coda selezionata!',
      'Email' => 'eMail',
      'Realname' => 'Nome',
      'System Email Addresses Management' => 'Gestione indirizzi di sistema',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Non dimenticare di aggiungere i nuovi operatori ad un gruppo!',
      'Firstname' => 'Nome',
      'Lastname' => 'Cognome',
      'User Management' => 'Gestione operatori',
      'User will be needed to handle tickets.' => 'Gli operatori sono necessari per gestire i ticket.',

    # Template: AdminUserGroupChangeForm
      'create' => 'crea',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'User <-> Group Management' => 'Gestione Utenti <-> Gruppi',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Annulla tutte le modifiche e torna alla composizione del messaggio',
      'Return to the compose screen' => 'Torna alla composizione del messaggio',
      'Search' => '',
      'The message being composed has been closed.  Exiting.' => 'La finestra con il messaggio che si stava componendo è stata chiusa. Sto uscendo.',
      'This window must be called from compose window' => 'Questa finestra deve essere aperta dalla finestra di composizione dei mesaggi',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Manca il destinatario del messaggio!',
      'Bounce ticket' => 'Rispedisci al mittente',
      'Bounce to' => 'Rispedisci a',
      'Inform sender' => 'Informa il mittente',
      'Next ticket state' => 'Stato successivo del ticket',
      'Send mail!' => 'Invia messaggio!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'È necessario inserire un indirizzo email (p.es. cliente@esempio.it) come destinatario!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'La tua email con il numero di ticket "<OTRS_TICKET>" assegnato a "<OTRS_BOUNCE_TO>". Contattare questo indirizzo per ulteriori informazioni.',

    # Template: AgentClose
      ' (work units)' => ' (unità di lavoro)',
      'A message should have a body!' => '',
      'A message should have a subject!' => 'Il messaggio deve avere un oggetto!',
      'Close ticket' => 'Ticket chiuso',
      'Close type' => 'Tipologia chiusura',
      'Close!' => 'Ticket Chiuso!',
      'Note Text' => 'Nota',
      'Note type' => 'Tipologia della nota',
      'Options' => 'Opzioni',
      'Spell Check' => 'Verifica ortografica',
      'Time units' => 'Tempo',
      'You need to account time!' => 'Devi inserire il tempo speso per la risposta!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Il messaggio deve subire il controllo ortografico!',
      'Attach' => 'Allega',
      'Compose answer for ticket' => 'Componi la risposta per il ticket',
      'for pending* states' => 'per gli stati di attesa*',
      'Is the ticket answered' => 'Il ticket è stato risposto?',
      'Pending Date' => 'Attesa fino a',

    # Template: AgentCustomer
      'Back' => 'Indietro',
      'Change customer of ticket' => 'Modifica il cliente del ticket',
      'CustomerID' => 'Codice cliente',
      'Search Customer' => 'Ricerca cliente',
      'Set customer user and customer id of a ticket' => 'Imposta l\'id cliente di un ticket',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'Storico del cliente',

    # Template: AgentCustomerMessage
      'Follow up' => 'Risposta',

    # Template: AgentCustomerView
      'Customer Data' => 'Dati del cliente',

    # Template: AgentEmailNew
      'All Agents' => '',
      'Clear From' => 'Cancella il campo mittente',
      'Compose Email' => '',
      'Lock Ticket' => '',
      'new ticket' => 'Nuovo Ticket',

    # Template: AgentForward
      'Article type' => 'Tipo articolo',
      'Date' => 'Data',
      'End forwarded message' => 'Fine del messaggio inoltrato',
      'Forward article of ticket' => 'Inoltro articolo del ticket',
      'Forwarded message from' => 'Messaggio inoltrato da',
      'Reply-To' => 'Rispondi a',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Cambia il testo del ticket',
      'Value' => 'Valore',

    # Template: AgentHistoryForm
      'History of' => 'Storico di',

    # Template: AgentMailboxNavBar
      'All messages' => 'Tutti i messaggi',
      'down' => 'decrescente',
      'Mailbox' => '',
      'New' => 'Nuovi',
      'New messages' => 'Nuovi messaggi',
      'Open' => 'Aperti',
      'Open messages' => 'Messaggi aperti',
      'Order' => 'Ordine',
      'Pending messages' => 'Messaggi in attesa',
      'Reminder' => 'Richiamo',
      'Reminder messages' => 'Messaggio di richiamo',
      'Sort by' => 'Ordina per',
      'Tickets' => 'Ticket',
      'up' => 'crescente',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'Move Ticket' => 'Sposta il ticket',
      'New Owner' => '',
      'New Queue' => 'Nuova coda ',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Ticket in gestione',
      'new message' => 'Nuovi messaggi',
      'Preferences' => 'Preferenze',
      'Utilities' => 'Utilità',

    # Template: AgentNote
      'Add note to ticket' => 'Aggiungi una nota al ticket',
      'Note!' => 'Nota!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Assegna il ticket ad un altro operatore',
      'Message for new Owner' => 'Messaggio per l\'operatore',

    # Template: AgentPending
      'Pending date' => 'In attesa fino a',
      'Pending type' => 'Tipo di attesa',
      'Pending!' => 'In attesa!',
      'Set Pending' => 'Imposta attesa',

    # Template: AgentPhone
      'Customer called' => 'Il cliente ha chiamato',
      'Phone call' => 'Chiamata telefonica',
      'Phone call at %s' => 'Chiamata telefonica di %s',

    # Template: AgentPhoneNew

    # Template: AgentPlain
      'ArticleID' => 'Codice articolo',
      'Plain' => '',
      'TicketID' => 'Codice ticket',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Scegli le code da visualizzare nella tua coda personale',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Cambia password',
      'New password' => 'Nuova password',
      'New password again' => 'Nuova password (conferma)',

    # Template: AgentPriority
      'Change priority of ticket' => 'Modifica la priorità del ticket',

    # Template: AgentSpelling
      'Apply these changes' => 'Applica le modifiche',
      'Spell Checker' => 'Verifica ortografica',
      'spelling error(s)' => 'Errori di ortografia',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'di',
      'Site' => 'Pagina',
      'sort downward' => 'ordine decrescente',
      'sort upward' => 'ordine crescente',
      'Ticket Status' => 'Stato ticket',
      'U' => 'C',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLink
      'Link' => '',
      'Link to' => '',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket già preso in gestione!',
      'Ticket unlock!' => 'Ticket libero!',

    # Template: AgentTicketPrint
      'by' => 'da',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Tempo addebitato',
      'Escalation in' => '',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      'and' => '',
      'Customer User Login' => '',
      'Delete' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'No time settings.' => '',
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Search' => 'Ricerca Ticket',
      'TicketFreeText' => '',
      'Times' => '',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Ricerca storico cliente',
      'Customer history search (e. g. "ID342425").' => 'Ricerca storico cliente (es: "ID342425")',
      'No * possible!' => 'Qui non è possibile usare l\'asterisco (*)!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => '',
      'Results' => 'Risultati',
      'Search Result' => '',
      'Total hits' => 'Totale risultati',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Tutti i ticket chiusi',
      'All open tickets' => 'Tutti i ticket aperti',
      'closed tickets' => 'ticket chiusi',
      'open tickets' => 'ticket aperti',
      'or' => 'oppure',
      'Provides an overview of all' => 'Visione generale di tutti i',
      'So you see what is going on in your system.' => 'Per vedere come vanno le cose nel sistema.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Componi risposta',
      'Your own Ticket' => 'I tuoi ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Componi risposta',
      'Contact customer' => 'Contatta il cliente',
      'phone call' => 'chiamata telefonica',

    # Template: AgentZoomArticle
      'Split' => 'Spezza',

    # Template: AgentZoomBody
      'Change queue' => 'Cambia coda',

    # Template: AgentZoomHead
      'Free Fields' => 'Campi liberi',
      'Print' => 'Stampa',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Registrati',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'Edit' => '',
      'FAQ History' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => '',
      'Keywords' => '',
      'Last update' => '',
      'Problem' => '',
      'Solution' => '',
      'Symptom' => '',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: CustomerFAQArticleView
      'FAQ Article' => '',
      'Modified' => '',

    # Template: CustomerFAQOverview
      'FAQ Overview' => '',

    # Template: CustomerFAQSearch
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => 'Contatti',
      'Home' => '',
      'Online-Support' => 'Supporto in linea',
      'Products' => 'Prodotti',
      'Support' => 'Supporto',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Hai dimenticato la tua password?',
      'Request new password' => 'Richiedi password',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Crea nuovo Ticket',
      'FAQ' => 'FAQ',
      'New Ticket' => 'Nuovo Ticket',
      'Ticket-Overview' => 'Sommario Ticket',
      'Welcome %s' => 'Benvenuto %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Lista Ticket',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Clicca qui per segnalare un bug!',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'Comment (internal)' => '',
      'Filename' => '',
      'Short Description' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => '',

    # Template: Footer
      'Top of Page' => 'Inizio Pagina',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Crea database ',
      'Drop Database' => 'Cancella database',
      'Finished' => 'Operazione terminata',
      'System Settings' => 'Impostazioni di sistema',
      'Web-Installer' => 'Web-Installer',

    # Template: InstallerFinish
      'Admin-User' => 'Utente amministratore',
      'After doing so your OTRS is up and running.' => 'Dopo di ciò OTRS sarà pronto all\'uso.',
      'Have a lot of fun!' => 'Divertiti con OTRS!',
      'Restart your webserver' => 'Riavvia il tuo server web',
      'Start page' => 'Pagina iniziale',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Per poter usare OTRS devi inserire questa riga di comando in una shell come utente root.',
      'Your OTRS Team' => 'Il team OTRS',

    # Template: InstallerLicense
      'accept license' => 'accetto la licenza',
      'don\'t accept license' => 'non accetto la licenza',
      'License' => 'Licenza',

    # Template: InstallerStart
      'Create new database' => 'Crea un nuovo database',
      'DB Admin Password' => 'Password del DB Admin',
      'DB Admin User' => 'Nome utente DB Admin',
      'DB Host' => '',
      'DB Type' => 'Tipo di DBMS',
      'default \'hot\'' => '\'hot\' predefinito',
      'Delete old database' => 'Cancella il vecchio database',
      'next step' => 'Fase successiva',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => '',
      'OTRS DB Password' => '',
      'OTRS DB User' => '',
      'your MySQL DB should have a root password! Default is empty!' => 'dovresti impostare una password di root per il tuo server MySQL!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Controlla il record MX per i domini degli indirizzi email quando si compone un messaggio. Non usare se il vostro server con OTRS ha una connessione dial-up!)',
      '(Email of the system admin)' => '(Indirizzo email dell\'amministratore di sistema)',
      '(Full qualified domain name of your system)' => '(Nome di dominio completo (FQDN) del sistema)',
      '(Logfile just needed for File-LogModule!)' => '(File di log --- necessario solo per il log su file (File-LogModule))',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(ID del sistema. Ogni ID di sessione e numero di ticket inizia con questo numero)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Prefisso per il numero di ticket --- es. "N.ro Ticket:" o "Ticket#" ecc.)',
      '(Used default language)' => '(Lingua predefinita)',
      '(Used log backend)' => '(Modulo da usare per il log)',
      '(Used ticket number format)' => '(Formato del numero dei ticket)',
      'CheckMXRecord' => 'Verifica record MX',
      'Default Charset' => 'Set di caratteri predefinito',
      'Default Language' => 'Lingua predefinita',
      'Logfile' => 'File di log',
      'LogModule' => 'Modulo di log',
      'Organization' => 'Azienda',
      'System FQDN' => 'FQDN del sistema',
      'SystemID' => 'ID del sistema',
      'Ticket Hook' => 'Prefisso ticket',
      'Ticket Number Generator' => 'Generatore numero ticket',
      'Use utf-8 it your database supports it!' => '',
      'Webfrontend' => 'Interfaccia web',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Autorizzazione negata',

    # Template: Notify
      'Info' => 'Informazioni',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'printed by' => 'stampato da',

    # Template: QueueView
      'All tickets' => 'Ticket totali',
      'Page' => '',
      'Queues' => 'Code',
      'Tickets available' => 'Ticket disponibili',
      'Tickets shown' => 'Ticket mostrati',

    # Template: SystemStats
      'Graphs' => 'Grafici',

    # Template: Test
      'OTRS Test Page' => 'Pagina di test OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => '',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Aggiungi nota',

    # Template: Warning

    # Misc
      '(E-Mail of the system admin)' => '(Indirizzo email dell\'amministratore di sistema)',
      'A message should have a From: recipient!' => 'Un messaggio dovrebbe avere un mittente!',
      'AgentFrontend' => 'Area Tecnici',
      'Article free text' => 'Testo libero articolo',
      'Charset' => 'Set di caratteri',
      'Charsets' => 'Set di caratteri',
      'Create' => 'Crea',
      'Customer info' => 'Informazioni sul cliente',
      'CustomerUser' => 'Cliente',
      'Fulltext search' => 'Ricerca integrale sul testo',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Ricerca integrale sul testo (es: "Mar*in" oppure "Baue*" oppure "martin+ciao")',
      'Handle' => 'Manipolare',
      'In Queue' => 'Nella Coda',
      'New state' => 'Nuovo stato',
      'New ticket via call.' => 'Nuovo ticket via telefono.',
      'New user' => 'Nuovo operatore',
      'Screen after new phone ticket' => '',
      'Search in' => 'Cerca in',
      'Select your screen after creating a new ticket via PhoneView.' => '',
      'Set customer id of a ticket' => 'Imposta il cliente associato al ticket',
      'Show all' => 'Mostra tutti i',
      'System Charset Management' => 'Gestione del set di caratteri di sistema',
      'System Language Management' => 'Gestione lingua del sistema',
      'Ticket free text' => 'Testo del ticket',
      'With Priority' => 'Con priorità',
      'With State' => 'Con stato',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'La tua email a cui è stato assegnato il numero di ticket "<OTRS_TICKET>" è stata rispedita a "<OTRS_BOUNCE_TO>". Contatta questo indirizzo per ulteriori informazioni.',
      'auto responses set' => 'Risposta automatica inserita',
      'invalid-temporarily' => 'temporaneamente invalido',
      'search' => 'Cerca',
      'search (e. g. 10*5155 or 105658*)' => 'Cerca (es: 10*5155 oppure 105658*)',
      'store' => 'salva',
      'tickets' => 'ticket',
      'valid' => 'valido',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
