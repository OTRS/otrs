# --
# Kernel/Language/it.pm - provides it language translation
# Copyright (C) 2003 Remo Catelotti <Remo.Catelotti at bull.it>
#               2003 Gabriele Santilli <gsantilli at omnibus.net>
# --
# $Id: it.pm,v 1.15 2005-04-05 12:28:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::it;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Aug 24 10:09:14 2004 by 

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
      '(Click here to add)' => '(clicca per aggiungere)',
      '...Back' => '...indietro',
      '10 minutes' => '10 minuti',
      '15 minutes' => '15 minuti',
      'Added User "%s"' => 'Utente "%s" aggiunto',
      'AddLink' => 'Aggiungi link',
      'Admin-Area' => 'Area Amministrazione',
      'agent' => 'operatore',
      'Agent-Area' => 'Area Operatore',
      'all' => 'tutti',
      'All' => 'Tutti',
      'Attention' => 'Attenzione',
      'Back' => 'Indietro',
      'before' => 'precedente',
      'Bug Report' => 'Segnala anomalie',
      'Calendar' => 'Calendario',
      'Cancel' => 'Annulla',
      'change' => 'modifica',
      'Change' => 'Modifica',
      'change!' => 'Modifica!',
      'click here' => 'clicca qui',
      'Comment' => 'Commento',
      'Contract' => 'Contratto',
      'Crypt' => 'Crittografa',
      'Crypted' => 'Crittografato',
      'Customer' => 'Cliente',
      'customer' => 'cliente',
      'Customer Info' => 'Informazioni Cliente',
      'day' => 'giorno',
      'day(s)' => 'giorno(i)',
      'days' => 'giorni',
      'description' => 'descrizione',
      'Description' => 'Descrizione',
      'Directory' => 'Cartella',
      'Dispatching by email To: field.' => 'Smistamento in base al campo To:.',
      'Dispatching by selected Queue.' => 'Smistamento in base alla coda selezionata.',
      'Don\'t show closed Tickets' => 'Non mostrare le richieste chiuse',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Non lavorare con l\'operatore con ID 1 (System account)! Crea dei nuovi utenti!',
      'Done' => 'Fatto',
      'end' => 'fine pagina',
      'Error' => 'Errore',
      'Example' => 'Esempio',
      'Examples' => 'Esempi',
      'Facility' => 'Funzione',
      'FAQ-Area' => 'Area FAQ',
      'Feature not active!' => 'Funzione non attiva!',
      'go' => 'vai',
      'go!' => 'vai!',
      'Group' => 'Gruppo',
      'History::AddNote' => 'Aggiunta nota (%s)',
      'History::Bounce' => 'Bounced to "%s".',
      'History::CustomerUpdate' => 'Aggiornato: %s',
      'History::EmailAgent' => 'Email inviata al cliente.',
      'History::EmailCustomer' => 'Email. %s aggiunta',
      'History::FollowUp' => 'Prosecuzione per [%s]. %s',
      'History::Forward' => 'Inoltrato a "%s".',
      'History::Lock' => 'Richiesta bloccata.',
      'History::LoopProtection' => 'Loop-Protection! Nessuna risposta automatica inviata a "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Richiesta mossa nella coda "%s" (%s) dalla coda "%s" (%s).',
      'History::NewTicket' => 'Nuova richiesta [%s] creata (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'Nuovo operatore assegnato = "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'L\'operatore ha chiamato il cliente.',
      'History::PhoneCallCustomer' => 'Il cliente ha chiamato noi.',
      'History::PriorityUpdate' => 'Priorita\' cambiata da "%s" (%s) a "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notifica inviata a "%s".',
      'History::SendAnswer' => 'Email inviata a "%s".',
      'History::SendAutoFollowUp' => 'Prosecuzione automatica inviata a "%s".',
      'History::SendAutoReject' => 'Rifiuto automatico inviato a "%s".',
      'History::SendAutoReply' => 'Risposta automatica inviata a "%s".',
      'History::SendCustomerNotification' => 'Notifica inviata a "%s".',
      'History::SetPendingTime' => 'Aggiornato: %s',
      'History::StateUpdate' => 'Vecchio: "%s" Nuovo: "%s"',
      'History::TicketFreeTextUpdate' => 'Aggiornato: %s=%s;%s=%s;',
      'History::TicketLinkAdd' => 'Aggiunto link alla richiesta "%s".',
      'History::TicketLinkDelete' => 'Eliminato link alla richiesta "%s".',
      'History::TimeAccounting' => '%s unita\' temporali addebitate. Nuovo totale: %s.',
      'History::Unlock' => 'Richiesta lasciata.',
      'History::WebRequestCustomer' => 'Richiesta del cliente via web.',
      'Hit' => 'Accesso',
      'Hits' => 'Accessi',
      'hour' => 'ora',
      'hours' => 'ore',
      'Ignore' => 'Ignora',
      'invalid' => 'non valido',
      'Invalid SessionID!' => 'ID di sessione non valido!',
      'Language' => 'Lingua',
      'Languages' => 'Lingue',
      'last' => 'ultimo',
      'Line' => 'Linea',
      'Lite' => 'Ridotta',
      'Login failed! Your username or password was entered incorrectly.' => 'Accesso fallito! Nome utente o password non corretti.',
      'Logout successful. Thank you for using OTRS!' => 'Disconnessione avvenuta con successo. Grazie per aver usato OTRS!',
      'Message' => 'Messaggio',
      'minute' => 'minuto',
      'minutes' => 'minuti',
      'Module' => 'Modulo',
      'Modulefile' => 'Archivio del modulo',
      'month(s)' => 'mese(i)',
      'Name' => 'Nome',
      'New Article' => 'Nuovo articolo',
      'New message' => 'Nuovo messaggio',
      'New message!' => 'Nuovo messaggio!',
      'Next' => 'Prossimo',
      'Next...' => 'Prossimo...',
      'No' => 'No',
      'no' => 'no',
      'No entry found!' => 'Vuoto!',
      'No Permission!' => 'Permessi insufficienti',
      'No such Ticket Number "%s"! Can\'t link it!' => 'Numero richiesta "%s" non presente! Collegamento impossibile!',
      'No suggestions' => 'Non ci sono suggerimenti',
      'none' => 'nessuno',
      'none - answered' => 'nessuno - risposto',
      'none!' => 'nessuno!',
      'Normal' => 'Normale',
      'off' => 'spento',
      'Off' => 'Spento',
      'On' => 'Acceso',
      'on' => 'acceso',
      'Online Agent: %s' => 'Operatori collegati: %s',
      'Online Customer: %s' => 'Clienti collegati: %s',
      'Password' => 'Password',
      'Passwords dosn\'t match! Please try it again!' => 'La password non corrisponde! Per favore, prova di nuovo',
      'Pending till' => 'In attesa per',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Per favore rispondi a queste richieste prima di tornare alla lista!',
      'Please contact your admin' => 'Per favore contatta il tuo amministratore',
      'please do not edit!' => 'per favore non modificare!',
      'possible' => 'possibile',
      'Preview' => 'Anteprima',
      'QueueView' => 'Lista ticket',
      'reject' => 'respinto',
      'replace with' => 'sostituisci con',
      'Reset' => 'Ripristina',
      'Salutation' => 'Titolo',
      'Session has timed out. Please log in again.' => 'Sessione scaduta. Per favore, effettua di nuovo l\'accesso.',
      'Show closed Tickets' => 'Mostra le richieste chiuse',
      'Sign' => 'Firma',
      'Signature' => 'Firma',
      'Signed' => 'Firmato',
      'Size' => 'Dimensione',
      'Sorry' => 'Spiacente',
      'Stats' => 'Statistiche',
      'Subfunction' => 'Sotto-funzione',
      'submit' => 'Accetta',
      'submit!' => 'accetta!',
      'system' => 'sistema',
      'Take this Customer' => 'Prendi questo Cliente',
      'Take this User' => 'Prendi questo Utente',
      'Text' => 'Testo',
      'The recommended charset for your language is %s!' => 'Il set di caratteri raccomandato per la tua lingua è %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Nome utente non valido.',
      'Ticket Number' => 'Numero Richiesta',
      'Timeover' => 'Tempo scaduto',
      'To: (%s) replaced with database email!' => 'A: (%s) sostituito con l\'indirizzo presente nel database',
      'top' => 'inizio pagina',
      'Type' => 'Tipo',
      'update' => 'aggiorna',
      'Update' => 'Aggiorna',
      'update!' => 'aggiorna!',
      'Upload' => 'Caricamento',
      'User' => 'Utenti',
      'Username' => 'Nome utente',
      'Valid' => 'Valido',
      'Warning' => 'Attenzione',
      'week(s)' => 'settimana(e)',
      'Welcome to OTRS' => 'Benvenuto in OTRS',
      'Word' => 'Parola',
      'wrote' => 'ha scritto',
      'year(s)' => 'anno(i)',
      'Yes' => 'Sì',
      'yes' => 'sì',
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
      'Closed Tickets' => 'Richieste chiuse',
      'CreateTicket' => 'CreaRichiesta',
      'Custom Queue' => 'Coda personale',
      'Follow up notification' => 'Notifica di risposta',
      'Frontend' => 'Interfaccia',
      'Mail Management' => 'Gestione posta',
      'Max. shown Tickets a page in Overview.' => 'Numero massimo di richieste per pagina nel Sommario',
      'Max. shown Tickets a page in QueueView.' => 'Numero massimo di richieste per pagina nella Lista Richieste',
      'Move notification' => 'Notifica spostamento',
      'New ticket notification' => 'Notifica nuova richiesta',
      'Other Options' => 'Altre opzioni',
      'PhoneView' => 'RichiestaTelefonica',
      'Preferences updated successfully!' => 'Preferenze modificate con successo!',
      'QueueView refresh time' => 'Tempo di aggiornamento lista richieste',
      'Screen after new ticket' => 'Pagina da mostrare dopo una nuova richiesta',
      'Select your default spelling dictionary.' => 'Seleziona il dizionario standard',
      'Select your frontend Charset.' => 'Seleziona il set di caratteri da usare.',
      'Select your frontend language.' => 'Scegli la lingua per la tua interfaccia.',
      'Select your frontend QueueView.' => 'Scegli l\'interfaccia per la lista messaggi.',
      'Select your frontend Theme.' => 'Scegli il tema per la tua interfaccia.',
      'Select your QueueView refresh time.' => 'Scegli il tempo di aggiornamento della lista ticket.',
      'Select your screen after creating a new ticket.' => 'Scegli la pagina da mostrare dopo una nuova richiesta',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Mandami una notifica se un cliente risponde ad una richiesta che ho io in gestione.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Mandami una notifica se una richiesta viene spostata in una coda della lista "Le mie Code"',
      'Send me a notification if a ticket is unlocked by the system.' => 'Mandami una notifica se una richiesta viene sbloccata dal sistema.',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Mandami una notifica se viene inserita una nuova richiesta in una coda della lista "Le mie Code"',
      'Show closed tickets.' => 'Mostra le richieste chiuse.',
      'Spelling Dictionary' => 'Dizionario',
      'Ticket lock timeout notification' => 'Notifica scadenza gestione richieste',
      'TicketZoom' => 'DettagliRichiesta',

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
      'Bcc' => '',
      'Bounce' => 'Rispedisci al mittente',
      'Cc' => 'Cc',
      'Close' => 'Chiudi',
      'closed' => 'chiuso',
      'closed successful' => 'chiuso con successo',
      'closed unsuccessful' => 'chiuso senza successo',
      'Compose' => 'Componi',
      'Created' => 'Creato',
      'Createtime' => 'Istante di creazione',
      'email' => '',
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
      'note-report' => 'Nota rapporto',
      'open' => 'aperto',
      'Owner' => 'Operatore',
      'Pending' => 'In attesa',
      'pending auto close+' => 'in attesa di chiusura automatica+',
      'pending auto close-' => 'in attesa di chiusura automatica-',
      'pending reminder' => 'in attesa di risposta',
      'phone' => 'telefono',
      'plain' => 'diretto',
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
      'Ticket' => 'Richiesta',
      'Ticket "%s" created!' => 'Richiesta "%s" creata!',
      'To' => 'A',
      'to open it in a new window.' => 'per aprire in una nuova finestra.',
      'Unlock' => 'Abbandona gestione',
      'unlock' => 'abbandona gestione',
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
      'Add' => 'Aggiungi',
      'Attachment Management' => 'Gestione allegati',

    # Template: AdminAutoResponseForm
      'Auto Response From' => 'Risposta automatica da',
      'Auto Response Management' => 'Gestione risposte automatiche',
      'Note' => 'Nota',
      'Response' => 'Risposta',
      'to get the first 20 character of the subject' => 'per avere i primi 20 caratteri dell\'oggetto',
      'to get the first 5 lines of the email' => 'per avere le prime 5 linee del messaggio',
      'to get the from line of the email' => 'per avere il mittente del messaggio',
      'to get the realname of the sender (if given)' => 'per avere il nome completo del mittente (se indicato)',
      'to get the ticket id of the ticket' => 'per avere l\'id della richiesta',
      'to get the ticket number of the ticket' => 'per avere il numero della richiesta',
      'Useable options' => 'Opzioni disponibili',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Gestione clienti',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => 'Il cliente sarà necessario per registrare la sua storia e permettere il collegamento via web',
      'Result' => 'Risultato',
      'Search' => 'Cerca',
      'Search for' => 'Cerca',
      'Select Source (for add)' => 'Seleziona sorgente (da aggiungere)',
      'Source' => 'Sorgente',
      'The message being composed has been closed.  Exiting.' => 'La finestra con il messaggio che si stava componendo è stata chiusa. Sto uscendo.',
      'This values are read only.' => 'Questi valori non sono modificabili',
      'This values are required.' => 'Questi valori sono richiesti',
      'This window must be called from compose window' => 'Questa finestra deve essere aperta dalla finestra di composizione dei mesaggi',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Modifica impostazioni di %s',
      'Customer User <-> Group Management' => 'Clienti <-> Gestione Gruppi',
      'Full read and write access to the tickets in this group/queue.' => 'Accesso completo in lettura e scrittura alle richieste in questo gruppo/coda',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Se non viene selezionata nessuna opzione, non verranno dati permessi a questo gruppo (le richieste non saranno disponibili).',
      'Permission' => 'Permessi',
      'Read only access to the ticket in this group/queue.' => 'Accesso in sola lettura alle richieste in questo gruppo/coda.',
      'ro' => 'sola lettura',
      'rw' => 'lettura e scrittura',
      'Select the user:group permissions.' => 'Seleziona i permessi della coppia utente:gruppo.',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Modifica impostazioni Utente <-> Gruppo',

    # Template: AdminEmail
      'Admin-Email' => 'Invia messaggio agli operatori',
      'Body' => 'Testo',
      'OTRS-Admin Info!' => 'Informazioni dall\'amministratore di OTRS',
      'Recipents' => 'Destinatari',
      'send' => 'invia',

    # Template: AdminEmailSent
      'Message sent to' => 'Messaggio inviato a',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => '(per esempio \'10*5155\' o \'105658*\')',
      '(e. g. 234321)' => '(per esempio \'234321\')',
      '(e. g. U5150)' => '(per esempio \'U5150\')',
      '-' => '',
      'Add Note' => 'Aggiungi nota',
      'Agent' => 'Operatore',
      'and' => 'e',
      'CMD' => 'comando',
      'Customer User Login' => 'Identificativo di Accesso del Cliente',
      'CustomerID' => 'Codice cliente',
      'CustomerUser' => 'Cliente',
      'Days' => 'Giorni',
      'Delete' => 'Cancella',
      'Delete tickets' => 'Elimina richieste',
      'Edit' => 'Modifica',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Ricerca a testo libero nel testo dell\'articolo (per esempio \'Ro*si\' o \'Ma*io\')',
      'GenericAgent' => 'OperatoreGenerico',
      'Hours' => 'Ore',
      'Job-List' => 'Lista attività',
      'Jobs' => 'Attività',
      'Last run' => 'Ultima esecuzione',
      'Minutes' => 'Minuti',
      'Modules' => 'Moduli',
      'New Agent' => 'Nuovo Operatore',
      'New Customer' => 'Nuovo Cliente',
      'New Owner' => 'Nuovo Gestore',
      'New Priority' => 'Nuova Priorità',
      'New Queue' => 'Nuova coda',
      'New State' => 'Nuovo stato',
      'New Ticket Lock' => 'Nuovo gestore della richiesta',
      'No time settings.' => 'Non ci sono impostazioni temporali.',
      'Param 1' => 'Parametro 1',
      'Param 2' => 'Parametro 2',
      'Param 3' => 'Parametro 3',
      'Param 4' => 'Parametro 4',
      'Param 5' => 'Parametro 5',
      'Param 6' => 'Parametro 6',
      'Save' => 'Salva',
      'Save Job as?' => 'Salva attività con nome?',
      'Schedule' => 'Programma',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Questo comando verrà eseguito. ARG[0] sarà il numero della richiesta. ARG[1] sarà l\'identificativo della richiesta.',
      'Ticket created' => 'Richiesta creata',
      'Ticket created between' => 'Richiesta creata fra',
      'Ticket Lock' => 'Gestione Richiesta',
      'TicketFreeText' => 'Ricerca a testo libero nella richiesta',
      'Times' => 'Volte',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Attenzione! Queste richieste verranno eliminate dalla base dati! Queste richieste saranno perse!',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Creare nuovi gruppi per gestire i permessi di accesso per diversi gruppi di agenti (p.es. sezione vendite, supporto tecnico, ecc.)',
      'Group Management' => 'Gestione gruppo',
      'It\'s useful for ASP solutions.' => 'È utile per soluzioni ASP',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Il gruppo admin ha accesso all\'area amministrazione mentre il gruppo stats ha accesso alle statistiche.',

    # Template: AdminLog
      'System Log' => 'Log di sistema',
      'Time' => 'Tempo',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Messaggio agli operatori',
      'Attachment <-> Response' => 'Allegati <-> Risposte',
      'Auto Response <-> Queue' => 'Risposte automatiche <-> Code',
      'Auto Responses' => 'Risposte automatiche',
      'Customer User' => 'Clienti',
      'Customer User <-> Groups' => 'Clienti <-> Gruppi',
      'Email Addresses' => 'Indirizzi Email',
      'Groups' => 'Gruppi',
      'Logout' => 'Esci',
      'Misc' => 'Varie',
      'Notifications' => 'Notifiche',
      'PGP Keys' => 'Chiavi di crittografia PGP',
      'PostMaster Filter' => 'Filtri per le email in ingresso',
      'PostMaster POP3 Account' => 'Impostazioni POP3 per le email il ingresso',
      'Responses' => 'Risposte',
      'Responses <-> Queue' => 'Risposte <-> Code',
      'Role' => 'Ruolo',
      'Role <-> Group' => 'Ruolo <-> Gruppo',
      'Role <-> User' => 'Ruolo <-> Utente',
      'Roles' => 'Ruoli',
      'Select Box' => 'Selezionare una funzione',
      'Session Management' => 'Gestione Sessioni',
      'SMIME Certificates' => 'Certificati SMIME',
      'Status' => 'Stato',
      'System' => 'Sistema',
      'User <-> Groups' => 'Utenti <-> Gruppi',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Opzioni di configurazione (per es. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Gestione delle notifiche',
      'Notifications are sent to an agent or a customer.' => 'Le notifiche sono inviate ad un operatore o a un cliente',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Per ottenere i dati del cliente (per es. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Per ottenere l\'utente che ha richiesto l\'azione (per es. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Per ottenere il gestore della richiesta (per es. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => 'Scade',
      'File' => '',
      'Fingerprint' => 'Impronta (fingerprint)',
      'FIXME: WHAT IS PGP?' => 'CORREGGIMI: COS\'E\' PGP?',
      'Identifier' => 'Identificatore',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'In questo modo puoi modificare direttamente il \'keyring\' configurato nel file Kernel/Config.pm',
      'Key' => 'Etichetta',
      'PGP Key Management' => 'Gestione chiave PGP',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Tutti i messaggi in arrivo saranno smistati nella coda selezionata!',
      'Dispatching' => 'Smistamento',
      'Host' => '',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Se il tuo account è fidato (trusted), verrà utilizzato l\'header x-otrs dell\'istante di arrivo (priorità, ...)! Il filtro di ingresso verrà utilizzato in ogni caso.',
      'POP3 Account Management' => 'Gestione accessi POP3',
      'Trusted' => 'Fidato',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Effettua lo smistamento o filtra la posta in ingresso in base all\'X-Header! Sono accettate anche espressioni regolari.',
      'Filtername' => 'Nome del filtro',
      'Header' => 'Intestazione (header)',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Se usi espressioni regolari, puoi anche utilizzare il valore corrispondente a () come [***] negli insiemi',
      'Match' => 'Corrispondenza',
      'PostMaster Filter Management' => 'Gestione filtri posta in ingresso',
      'Set' => 'Impostazione',
      'Value' => 'Valore',

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
      'Follow up Option' => 'Opzioni per le prosecuzioni',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se un ticket è chiuso e il cliente invia una risposta, il ticket viene assegnato al vecchio operatore.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Se un ticket non viene risposto entro questo limite di tempo, sarà l\'unico ticket ad essere mostrato.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se un operatore prende in gestione un ticket ma non risponde entro il tempo specificato, il ticket viene sbloccato in modo da essere accessibile agli altri operatori.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS invia una notifica via email al cliente se il ticket viene spostato.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS invia una notifica via email al cliente se l\'operatore assegnato al ticket cambia.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS invia una notifica via email al cliente se lo stato del ticket cambia.',
      'Queue Management' => 'Gestione delle code',
      'Sub-Queue of' => 'Sottocoda di',
      'Systemaddress' => 'Indirizzo di sistema',
      'The salutation for email answers.' => 'Saluto (parte iniziale) per le email generate automaticamente dal sistema.',
      'The signature for email answers.' => 'Firma (parte finale) per le email generate automaticamente dal sistema.',
      'Ticket lock after a follow up' => 'Presa in gestione della richiesta dopo una prosecuzione',
      'Unlock timeout' => 'Tempo di sblocco automatico',
      'Will be the sender address of this queue for email answers.' => 'Mittente utilizzato per le risposte relative alle richieste di questa coda.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Gestione associazioni Risposte standard <-> Code',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Risposta',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Gestione associazioni Risposte standard <-> Allegati standard',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Una risposta è un testo predefinito usato per compilare più rapidamente le risposte per i clienti.',
      'All Customer variables like defined in config option CustomerUser.' => 'Tutte le variabili del cliente come definite nella configurazione',
      'Don\'t forget to add a new response a queue!' => 'Non dimenticare di aggiungere una risposta per ogni coda!',
      'Next state' => 'Stato successivo',
      'Response Management' => 'Gestione risposte',
      'The current ticket state is' => 'Lo stato corrente della richiesta è',
      'Your email address is new' => 'Il tuo indirizzo di email è nuovo',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => 'Crea un ruolo e mettici i gruppi. Poi aggiungi il ruolo agli utenti.',
      'It\'s useful for a lot of users and groups.' => 'E\' utile per molti utenti e gruppi',
      'Role Management' => 'Gestione ruoli',

    # Template: AdminRoleGroupChangeForm
      'create' => 'crea',
      'move_into' => 'muovi_in',
      'owner' => 'gestore',
      'Permissions to change the ticket owner in this group/queue.' => 'Autorizzazione a cambiare il gestore di una richiesta in questo gruppo/coda.',
      'Permissions to change the ticket priority in this group/queue.' => 'Autorizzazione a cambiare la priorità di una richiesta in questo gruppo/coda',
      'Permissions to create tickets in this group/queue.' => 'Autorizzazione a creare richieste in questo gruppo/coda',
      'Permissions to move tickets into this group/queue.' => 'Autorizzazione a muovere richieste in questo gruppo/coda',
      'priority' => 'priorità',
      'Role <-> Group Management' => 'Gestione Ruolo <-> Gruppo',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => 'Cambia impostazioni ruolo <-> gruppo',

    # Template: AdminRoleUserChangeForm
      'Active' => 'Attivo',
      'Role <-> User Management' => 'Gestione Ruolo <-> Utente',
      'Select the role:user relations.' => 'Seleziona le relazioni ruolo:utente.',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => 'Cambia impostazioni utente <-> gruppo',

    # Template: AdminSMIMEForm
      'Add Certificate' => 'Aggiungi certificato',
      'Add Private Key' => 'Aggiunti chiave privata',
      'FIXME: WHAT IS SMIME?' => 'CORREGGIMI: COS\'E\' SMIME?',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => 'Puoi modificare il certificato e la chiave privata direttamente sul filesystem.',
      'Secret' => 'Segreto',
      'SMIME Certificate Management' => 'Gestione certificati SMIME',

    # Template: AdminSalutationForm
      'customer realname' => 'nome del cliente',
      'for agent firstname' => 'per il nome dell\'operatore',
      'for agent lastname' => 'per il cognome dell\'operatore',
      'for agent login' => 'per il nome utente dell\'operatore',
      'for agent user id' => 'per l\'id utente dell\'operatore',
      'Salutation Management' => 'Gestione saluti',

    # Template: AdminSelectBoxForm
      'Limit' => 'Limite',
      'SQL' => '',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'Seleziona il risultato',

    # Template: AdminSession
      'kill all sessions' => 'Termina tutte le sessioni',
      'kill session' => 'Termina sessione',
      'Overview' => 'Sommario',
      'Session' => 'Sessione',
      'Sessions' => 'Sessioni',
      'Uniq' => '',

    # Template: AdminSignatureForm
      'Signature Management' => 'Gestione firme',

    # Template: AdminStateForm
      'See also' => 'Vedi anche',
      'State Type' => 'Tipologia',
      'System State Management' => 'Gestione stati richieste',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Assicurati di aver aggiornato gli stati pre-impostati (default) nel file Kernel/Config.pm!',

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
      'User will be needed to handle tickets.' => 'Gli operatori sono necessari per gestire le richieste.',

    # Template: AdminUserGroupChangeForm
      'User <-> Group Management' => 'Gestione Utenti <-> Gruppi',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => 'Rubrica',
      'Discard all changes and return to the compose screen' => 'Annulla tutte le modifiche e torna alla composizione del messaggio',
      'Return to the compose screen' => 'Torna alla composizione del messaggio',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Manca il destinatario del messaggio!',
      'Bounce ticket' => 'Rispedisci richiesta',
      'Bounce to' => 'Rispedisci a',
      'Inform sender' => 'Informa il mittente',
      'Next ticket state' => 'Stato successivo della richiesta',
      'Send mail!' => 'Invia messaggio!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'È necessario inserire un indirizzo email (per .es. cliente@esempio.it) come destinatario!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'La tua email con il numero di richiesta "<OTRS_TICKET>" è stata reindirizzata a "<OTRS_BOUNCE_TO>". Contattare questo indirizzo per ulteriori informazioni.',

    # Template: AgentBulk
      '$Text{"Note!' => '$Text{"Nota!',
      'A message should have a subject!' => 'Il messaggio deve avere un oggetto!',
      'Note type' => 'Tipologia della nota',
      'Note!' => 'Nota!',
      'Options' => 'Opzioni',
      'Spell Check' => 'Verifica ortografica',
      'Ticket Bulk Action' => 'Azione di massa',

    # Template: AgentClose
      ' (work units)' => ' (unità di lavoro)',
      'A message should have a body!' => 'Un messaggio deve avere un contenuto!',
      'Close ticket' => 'Chiudi richiesta',
      'Close type' => 'Tipologia chiusura',
      'Close!' => 'Chiuso!',
      'Note Text' => 'Nota',
      'Time units' => 'Tempo',
      'You need to account time!' => 'Devi inserire il tempo impiegato per la risposta!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Il messaggio necessita di correzione ortografica!',
      'Attach' => 'Allega',
      'Compose answer for ticket' => 'Componi la risposta alla richiesta',
      'for pending* states' => 'per gli stati di attesa*',
      'Is the ticket answered' => 'Alla richiesta è stato risposto?',
      'Pending Date' => 'Attesa fino a',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'Modifica il cliente del ticket',
      'Search Customer' => 'Ricerca cliente',
      'Set customer user and customer id of a ticket' => 'Imposta l\'id cliente di una richiesta',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Tutte le richieste del cliente.',
      'Customer history' => 'Storico del cliente',

    # Template: AgentCustomerMessage
      'Follow up' => 'Risposta',

    # Template: AgentCustomerView
      'Customer Data' => 'Dati del cliente',

    # Template: AgentEmailNew
      'All Agents' => 'Tutti gli operatori',
      'Clear To' => 'Cancella destinatario',
      'Compose Email' => 'Componi email',
      'new ticket' => 'nuova richiesta',

    # Template: AgentForward
      'Article type' => 'Tipo articolo',
      'Date' => 'Data',
      'End forwarded message' => 'Fine del messaggio inoltrato',
      'Forward article of ticket' => 'Inoltro articolo della richiesta',
      'Forwarded message from' => 'Messaggio inoltrato da',
      'Reply-To' => 'Rispondi a',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Cambia il testo della richiesta',

    # Template: AgentHistoryForm
      'History of' => 'Storico di',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => 'Informazioni',

    # Template: AgentLookup
      'Lookup' => 'Ricerca',

    # Template: AgentMailboxNavBar
      'All messages' => 'Tutti i messaggi',
      'down' => 'decrescente',
      'Mailbox' => 'Casella postale',
      'New' => 'Nuovi',
      'New messages' => 'Nuovi messaggi',
      'Open' => 'Aperti',
      'Open messages' => 'Messaggi aperti',
      'Order' => 'Ordine',
      'Pending messages' => 'Messaggi in attesa',
      'Reminder' => 'Richiamo',
      'Reminder messages' => 'Messaggio di richiamo',
      'Sort by' => 'Ordina per',
      'Tickets' => 'Richieste',
      'up' => 'crescente',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',
      'Add a note to this ticket!' => 'Aggiungi una nota a questa richiesta!',
      'Change the ticket customer!' => 'Cambia il cliente associato alla richiesta!',
      'Change the ticket owner!' => 'Cambia il gestore della richiesta!',
      'Change the ticket priority!' => 'Cambia la priorità della richiesta!',
      'Close this ticket!' => 'Chiudi la richiesta!',
      'Shows the detail view of this ticket!' => 'Mostra i dettagli della richiesta!',
      'Unlock this ticket!' => 'Abbandona la gestione della richiesta!',

    # Template: AgentMove
      'Move Ticket' => 'Sposta la richiesta',
      'Previous Owner' => 'Gestore precedente',
      'Queue ID' => 'Identificativo coda',

    # Template: AgentNavigationBar
      'Agent Preferences' => 'Impostazione preferenze per l\'operatore',
      'Bulk Action' => 'Azione massiva',
      'Bulk Actions on Tickets' => 'Azione di massa sulle richieste selezionate',
      'Create new Email Ticket' => 'Crea una nuova richiesta inviando una email al cliente',
      'Create new Phone Ticket' => 'Crea una nuova richiesta in seguito ad una chiamata telefonica',
      'Email-Ticket' => 'Rich. Email',
      'Locked tickets' => 'Richieste in gestione',
      'new message' => 'Nuovi messaggi',
      'Overview of all open Tickets' => 'Vista globale di tutte le richieste aperte',
      'Phone-Ticket' => 'Rich. Telef.',
      'Preferences' => 'Preferenze',
      'Search Tickets' => 'Effettua una ricerca nella base dati',
      'Ticket selected for bulk action!' => 'Richiesta selezionata per azione di massa!',
      'You need min. one selected Ticket!' => 'Devi selezionare almeno una richiesta!',

    # Template: AgentNote
      'Add note to ticket' => 'Aggiungi una nota alla richiesta',

    # Template: AgentOwner
      'Change owner of ticket' => 'Assegna la richiesta ad un altro operatore',
      'Message for new Owner' => 'Messaggio per l\'operatore',

    # Template: AgentPending
      'Pending date' => 'In attesa fino a',
      'Pending type' => 'Tipo di attesa',
      'Set Pending' => 'Imposta attesa',

    # Template: AgentPhone
      'Phone call' => 'Chiamata telefonica',

    # Template: AgentPhoneNew
      'Clear From' => 'Cancella il campo mittente',

    # Template: AgentPlain
      'ArticleID' => 'Codice articolo',
      'Download' => 'Scarica',
      'Plain' => '',
      'TicketID' => 'Codice richiesta',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => 'Le mie code',
      'You also get notified about this queues via email if enabled.' => 'Se attivi l\'opzione "Notifica nuova richiesta", ti verrà inviata una email ogni volta che una richiesta viene inserita in una di queste code.',
      'Your queue selection of your favorite queues.' => 'Lista delle code preferite',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Cambia password',
      'New password' => 'Nuova password',
      'New password again' => 'Nuova password (conferma)',

    # Template: AgentPriority
      'Change priority of ticket' => 'Modifica la priorità della richiesta',

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
      'Ticket Status' => 'Stato richiesta',
      'U' => 'C',

    # Template: AgentTicketLink
      'Delete Link' => 'Elimina Collegamento',
      'Link' => 'Collega',
      'Link to' => 'Collega a',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Richiesta già presa in gestione!',
      'Ticket unlock!' => 'Richiesta abbandonata!',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Tempo addebitato',
      'Escalation in' => '',

    # Template: AgentUtilSearch
      'Profile' => 'Profilo',
      'Result Form' => 'Tipo di risultato',
      'Save Search-Profile as Template?' => 'Salvare il profilo di ricerca come modello',
      'Search-Template' => 'Modello di ricerca',
      'Select' => 'Seleziona',
      'Ticket Search' => 'Ricerca richiesta',
      'Yes, save it with name' => 'Sì, salva con nome',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Ricerca storico cliente',
      'Customer history search (e. g. "ID342425").' => 'Ricerca storico cliente (per es. "ID342425")',
      'No * possible!' => 'Qui non è possibile usare l\'asterisco (*)!',

    # Template: AgentUtilSearchResult
      'Change search options' => 'Modifica le opzioni di ricerca',
      'Results' => 'Risultati',
      'Search Result' => 'Risultato ricerca',
      'Total hits' => 'Totale risultati',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Tutte le richieste chiuse',
      'All open tickets' => 'Tutte le richieste aperte',
      'closed tickets' => 'richieste chiuse',
      'open tickets' => 'richieste aperte',
      'or' => 'oppure',
      'Provides an overview of all' => 'Visione generale di tutti i',
      'So you see what is going on in your system.' => 'Per vedere come vanno le cose nel sistema.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Componi risposta',
      'Your own Ticket' => 'Le tue richieste',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Componi risposta',
      'Contact customer' => 'Contatta il cliente',
      'phone call' => 'chiamata telefonica',

    # Template: AgentZoomArticle
      'Split' => 'Spezza',

    # Template: AgentZoomBody
      'Change queue' => 'Cambia coda',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => '',
      'Free Fields' => 'Campi liberi',
      'Link this ticket to an other one!' => 'Collega questa richiesta ad un\'altra!',
      'Lock it to work on it!' => 'Prendi la richiesta in gestione per lavorarci!',
      'Print' => 'Stampa',
      'Print this ticket!' => 'Stampa questa richiesta!',
      'Set this ticket to pending!' => 'Metti in stato di attesa questa richiesta!',
      'Shows the ticket history!' => 'Mostra la storia della richiesta!',

    # Template: AgentZoomStatus
      '"}","18' => '',
      'Locked' => 'In gestione',
      'SLA Age' => 'durata SLA',

    # Template: Copyright
      'printed by' => 'stampato da',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Registrati',
      'Login' => 'Codice utente',

    # Template: CustomerError
      'Traceback' => 'Dettaglio del passato',

    # Template: CustomerFAQArticleHistory
      'FAQ History' => 'Storico FAQ',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Categoria',
      'Keywords' => 'Parole chiave',
      'Last update' => 'Ultimo aggiornamento',
      'Problem' => 'Problema',
      'Solution' => 'Soluzione',
      'Symptom' => 'Sintomi',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'Storico sistema FAQ',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'Articolo FAQ',
      'Modified' => 'Modificato',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'Sommario FAQ',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'Ricerca FAQ',
      'Fulltext' => 'Testo libero',
      'Keyword' => 'Parola chiave',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'Risultato ricerca FAQ',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerLostPassword
      'Lost your password?' => 'Hai dimenticato la password?',
      'Request new password' => 'Richiedi una nuova password',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => 'Le richieste del gruppo',
      'Create new Ticket' => 'Crea nuova richiesta',
      'FAQ' => 'FAQ',
      'MyTickets' => 'Le mie richieste',
      'New Ticket' => 'Nuova richiesta',
      'Welcome %s' => 'Benvenuto/a %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerTicketSearch

    # Template: CustomerTicketSearchResultPrint

    # Template: CustomerTicketSearchResultShort

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Clicca qui per segnalare un bug!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Elimina FAQ',
      'You really want to delete this article?' => 'Sei veramente sicuro di voler cancellare questo articolo?',

    # Template: FAQArticleForm
      'A article should have a title!' => 'Manca il titolo!',
      'Comment (internal)' => 'Commento (interno)',
      'Filename' => 'Nome file',
      'Title' => 'Titolo',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => 'Categoria FAQ',
      'Name is required!' => 'Manca il nome!',

    # Template: FAQLanguageForm
      'FAQ Language' => 'Lingua FAQ',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => 'Inizio Pagina',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => 'Crea database ',
      'Drop Database' => 'Cancella database',
      'Finished' => 'Operazione terminata',
      'System Settings' => 'Impostazioni di sistema',
      'Web-Installer' => 'Installazione guidata via web',

    # Template: InstallerFinish
      'Admin-User' => 'Utente amministratore',
      'After doing so your OTRS is up and running.' => 'Dopo di ciò OTRS sarà pronto all\'uso.',
      'Have a lot of fun!' => 'Divertiti con OTRS!',
      'Restart your webserver' => 'Riavvia il tuo server web',
      'Start page' => 'Pagina iniziale',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Per poter usare OTRS devi inserire questa riga di comando in una shell come utente root.',
      'Your OTRS Team' => 'Gruppo di sviluppo di OTRS',

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
      'Ticket Hook' => 'Prefisso richieste',
      'Ticket Number Generator' => 'Generatore numero ticket',
      'Use utf-8 it your database supports it!' => '',
      'Webfrontend' => 'Interfaccia web',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Autorizzazione negata',

    # Template: Notify

    # Template: PrintFooter
      'URL' => '',

    # Template: QueueView
      'All tickets' => 'Richieste totali',
      'Page' => 'Pagina',
      'Queues' => 'Code',
      'Tickets available' => 'Richieste disponibili',
      'Tickets shown' => 'Richieste mostrate',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'Pagina di test OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => '',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => '',

    # Template: customer-css
      'Contact' => 'Contatti',
      'Online-Support' => 'Supporto in linea',
      'Products' => 'Prodotti',
      'Support' => 'Supporto',

    # Misc
      '"}","15' => '',
      '"}","30' => '',
      '(E-Mail of the system admin)' => '(Indirizzo email dell\'amministratore di sistema)',
      'A message should have a From: recipient!' => 'Un messaggio deve avere un mittente!',
      'Add auto response' => 'Aggiungi risposta automatica',
      'AgentFrontend' => 'Area Tecnici',
      'Article free text' => 'Testo libero articolo',
      'Change Response <-> Attachment settings' => 'Modifica impostazioni Risposte <-> Allegati',
      'Change answer <-> queue settings' => 'Modifica impostazioni Risposta <-> Coda',
      'Change auto response settings' => 'Modifica impostazioni risposta automatica',
      'Charset' => 'Set di caratteri',
      'Charsets' => 'Set di caratteri',
      'Create' => 'Crea',
      'Customer called' => 'Il cliente ha chiamato',
      'Customer info' => 'Informazioni sul cliente',
      'Customer user will be needed to to login via customer panels.' => 'Qui è possibile inserire gli utenti che possono fare il login nel pannello clienti.',
      'FAQ State' => 'Stato FAQ',
      'Fulltext search' => 'Ricerca integrale sul testo',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Ricerca integrale sul testo (per es.: "Mar*in" oppure "Baue*" oppure "martin+ciao")',
      'Graphs' => 'Grafici',
      'Handle' => 'Manipolare',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Se si tratta di un account fidato, verranno usati gli header X-OTRS per la gestione delle richieste!',
      'In Queue' => 'Nella Coda',
      'Lock Ticket' => 'Prendi in gestione richiesta',
      'Max Rows' => 'Numero massimo di linee',
      'My Tickets' => 'Lista Richieste',
      'New state' => 'Nuovo stato',
      'New ticket via call.' => 'Nuova richiesta telefonica.',
      'New user' => 'Nuovo operatore',
      'Pending!' => 'In attesa!',
      'Phone call at %s' => 'Chiamata telefonica di %s',
      'Please go away!' => 'Perfavore allontanati!',
      'PostMasterFilter Management' => 'Gestione filtro posta in ingresso',
      'Screen after new phone ticket' => 'Pagina dopo nuova richiesta telefonica',
      'Search in' => 'Cerca in',
      'Select source:' => 'Seleziona sorgente:',
      'Select your custom queues' => 'Scegli le code da visualizzare nella tua coda personale',
      'Select your screen after creating a new ticket via PhoneView.' => 'Seleziona la pagina successiva a quella di creazione di una nuova richiesta telefonica',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Mandami una notifica se una richiesta viene spostata in una delle code visualizzate nella mia coda personale.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Mandami una notifica se c\'è una nuova richiesta in una delle code visualizzate nella mia coda personale.',
      'SessionID' => 'ID sessione',
      'Set customer id of a ticket' => 'Imposta il cliente associato alla richiesta ',
      'Short Description' => 'Descrizione breve',
      'Show all' => 'Mostra tutti i',
      'System Charset Management' => 'Gestione del set di caratteri di sistema',
      'System Language Management' => 'Gestione lingua del sistema',
      'Ticket free text' => 'Testo della richiesta',
      'Ticket-Overview' => 'Sommario Richiesta',
      'Utilities' => 'Utilità',
      'With Priority' => 'Con priorità',
      'With State' => 'Con stato',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'La tua email a cui è stato assegnato il numero di richiesta "<OTRS_TICKET>" è stata rispedita a "<OTRS_BOUNCE_TO>". Contatta questo indirizzo per ulteriori informazioni.',
      'auto responses set' => 'Risposta automatica inserita',
      'by' => 'da',
      'invalid-temporarily' => 'temporaneamente invalido',
      'search' => 'Cerca',
      'search (e. g. 10*5155 or 105658*)' => 'Cerca (per es. 10*5155 oppure 105658*)',
      'store' => 'salva',
      'tickets' => 'richieste',
      'valid' => 'valido',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
