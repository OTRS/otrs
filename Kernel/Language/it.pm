# --
# Kernel/Language/en.pm - provides en language translation
# Copyright (C) 2003 Remo Catelotti <Remo.Catelotti at bull.it>
# --
# $Id: it.pm,v 1.1.2.1 2003-05-10 16:51:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::it;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Apr 15 16:40:44 2003 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minuti',
      ' 5 minutes' => ' 5 minuti',
      ' 7 minutes' => ' 7 minuti',
      '10 minutes' => '10 minuti',
      '15 minutes' => '15 minuti',
      'AddLink' => 'Aggiungi un collegamento ',
      'AdminArea' => 'Area amministrazione',
      'agent' => 'agente',
      'all' => 'tutti',
      'All' => 'Tutti',
      'Attention' => 'Attenzione',
      'Bug Report' => 'Anomalie',
      'Cancel' => 'Annulla',
      'change' => 'modifica',
      'Change' => 'Modifica',
      'change!' => 'Modifica&nbsp;!',
      'click here' => 'Vai',
      'Comment' => 'Commento',
      'Customer' => 'Cliente',
      'customer' => 'cliente',
      'Customer Info' => 'Informazioni Cliente',
      'day' => 'giorno',
      'days' => 'giorni',
      'description' => 'descrizione',
      'Description' => 'Descrizione',
      'Dispatching by email To: field.' => 'Spedire via email a: campo.',
      'Dispatching by selected Queue.' => 'Spedire via coda selezionata.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Non lavorare con l\'Identificatore 1 (Amministratore del Sistema)! Creare nuovo utente!',
      'Done' => 'Uscire',
      'end' => 'fine',
      'Error' => 'Errore',
      'Example' => 'Esempio',
      'Examples' => 'Esempi',
      'Facility' => 'Funzioni',
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
      'Invalid SessionID!' => 'Identificatore di Sessione non valida',
      'Language' => 'Lingua',
      'Languages' => 'Lingue',
      'Line' => 'Linea',
      'Lite' => 'Basso',
      'Login failed! Your username or password was entered incorrectly.' => 'Connessione non valida! nome Utente o Parola Chiave digitato, non corretto',
      'Logout successful. Thank you for using OTRS!' => 'Uscita corretta. Grazie per aver usato OTRS!',
      'Message' => 'Messaggio',
      'minute' => 'minuto',
      'minutes' => 'minuti',
      'Module' => 'Modulo',
      'Modulefile' => 'Archivio del modulo',
      'Name' => 'Nome',
      'New message' => 'Nuovo messaggio',
      'New message!' => 'Nuovo messaggio!',
      'No' => 'No',
      'no' => 'no',
      'No entry found!' => 'Vuoto ',
      'No suggestions' => 'Non ci sono suggerimenti',
      'none' => 'nessuna',
      'none - answered' => 'nessuna - risposta',
      'none!' => 'nessuna!',
      'Off' => 'Spento',
      'off' => 'spento',
      'On' => 'Acceso',
      'on' => 'acceso',
      'Password' => 'Parola chiave',
      'Pending till' => 'In attesa ',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Prego rispondere a questo ticket per tornare a vedere lo stato delle code!',
      'Please contact your admin' => 'Prego contattare il Vostro amministratore',
      'please do not edit!' => 'Prego non modificare!',
      'possible' => 'possibile',
      'QueueView' => 'Visualizza coda ',
      'reject' => 'rifiutato',
      'replace with' => 'sostituisci con',
      'Reset' => 'Ripristina',
      'Salutation' => 'Saluti',
      'Session has timed out. Please log in again.' => 'Sessione scaduta.Prego collegarsi nuovamente ',
      'Signature' => 'Firma',
      'Sorry' => 'Spiacente',
      'Stats' => 'Statistiche',
      'Subfunction' => 'Sotto-funzione',
      'submit' => 'invia',
      'submit!' => 'invia&nbsp;!',
      'system' => 'sistema',
      'Take this User' => 'Prendi questo Utente',
      'Text' => 'Testo',
      'The recommended charset for your language is %s!' => 'Il charset raccomandato per la vostra lingua e %s!',
      'Theme' => 'Schema',
      'There is no account with that login name.' => 'Non esiste nessun ticket per voi',
      'Timeover' => 'Tempo scaduto',
      'top' => 'inizio',
      'update' => 'aggiorna',
      'update!' => 'aggiorna&nbsp;!',
      'User' => 'Utente',
      'Username' => 'Nome Utente',
      'Valid' => 'Valido',
      'Warning' => 'Attenzione',
      'Welcome to OTRS' => 'Benvenuto in OTRS',
      'Word' => 'Parola',
      'wrote' => 'inviato',
      'yes' => 'si',
      'Yes' => 'Si',
      'You got new message!' => 'Hai ricevuto nuovo messaggio',
      'You have %s new message(s)!' => 'Hai ricevuto  %s nuovi messaggi',
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
      'Closed Tickets' => 'Tickets Chiusi',
      'Custom Queue' => 'Coda Personale',
      'Follow up notification' => 'Notificazioni Seguenti',
      'Frontend' => 'Interfaccia',
      'Mail Management' => 'Gestione delle Email',
      'Move notification' => 'Notificazione dei movimenti',
      'New ticket notification' => 'Notificazione nuovo ticket',
      'Other Options' => 'Altre opzioni',
      'Preferences updated successfully!' => 'L\'aggiornamento ha avuto successo',
      'QueueView refresh time' => 'Tempo di aggiornamento della coda',
      'Select your default spelling dictionary.' => 'Seleziona il dizionario',
      'Select your frontend Charset.' => 'Seleziona  tipo Carattere',
      'Select your frontend language.' => 'Seleziona la Lingua',
      'Select your frontend QueueView.' => 'Seleziona  tipo di coda',
      'Select your frontend Theme.' => 'Seleziona tipo Tema',
      'Select your QueueView refresh time.' => 'Seleziona il tempo di aggiornamento della coda',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Devo essere informato se un cliente invia un seguito (follow-up) al proprietario di questo ticket .',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Devo essere informato se un ticket viene mosso in una coda personale utente',
      'Send me a notification if a ticket is unlocked by the system.' => 'Devo essere informato se un ticket viene liberato dal sistema ',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Devo essere informato se un ticket viene aggiunto nella mia coda personale .',
      'Show closed tickets.' => 'Mostra i ticket chiusi.',
      'Spelling Dictionary' => 'Dizionario',
      'Ticket lock timeout notification' => 'Devo essere informato se viene superato il tempo di notifica (timeout notification)',

    # Template: AAATicket
      '1 very low' => '1 molto basso',
      '2 low' => '2 basso',
      '3 normal' => '3 normale',
      '4 high' => '4 alto',
      '5 very high' => '5 molto alto',
      'Action' => 'Azione',
      'Age' => 'Eta',
      'Article' => 'Articolo',
      'Attachment' => 'Allegato',
      'Attachments' => 'Allegati',
      'Bcc' => 'Copia Invisible',
      'Bounce' => 'Restituire',
      'Cc' => 'Copia ',
      'Close' => 'Chiuso',
      'closed successful' => 'chiuso con successo',
      'closed unsuccessful' => 'chiuso con anomalie',
      'Compose' => 'Comporre',
      'Created' => 'Creato ',
      'Createtime' => 'Tempo di Creazione ',
      'email' => 'email',
      'eMail' => 'eMail',
      'email-external' => 'posta-esterna',
      'email-internal' => 'posta-interna',
      'Forward' => 'Trasmettere',
      'From' => 'Da ',
      'high' => 'alta priorita',
      'History' => 'Storia',
      'If it is not displayed correctly,' => 'Se non visibile correttamente',
      'lock' => 'bloccato',
      'Lock' => 'Bloccato',
      'low' => 'bassa priorita',
      'Move' => 'Muovi',
      'new' => 'nuovo',
      'normal' => 'normale priorita',
      'note-external' => 'Nota-esterna',
      'note-internal' => 'nota-interna',
      'note-report' => ' nota-rapporto',
      'open' => 'Aperto',
      'Owner' => 'Proprietario',
      'Pending' => 'In attesa',
      'pending auto close+' => 'Chiusura automatica in corso(+)',
      'pending auto close-' => 'Chiusura automatica in corso(-)',
      'pending reminder' => 'In attesa di risposta',
      'phone' => 'Telefono',
      'plain' => 'tutto',
      'Priority' => 'Priorita',
      'Queue' => 'Coda',
      'removed' => 'Cancellato',
      'Sender' => 'Inviante',
      'sms' => 'sms',
      'State' => 'Stato',
      'Subject' => 'Soggetto',
      'This is a' => 'Questo e` un',
      'This is a HTML email. Click here to show it.' => 'Questo messaggio e` in formato HTML. Clicca per leggere in contenuto.',
      'This message was written in a character set other than your own.' => 'Questo messaggio e` scritto con caratteri diversi da quelli disponibili',
      'Ticket' => 'Ticket',
      'To' => 'A ',
      'to open it in a new window.' => 'Per aprire una nuova finestra',
      'unlock' => 'sbloccato',
      'Unlock' => 'Sbloccato',
      'very high' => 'Molto alto',
      'very low' => 'Molto basso',
      'View' => 'Vedere',
      'webrequest' => 'Richiesta via web',
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
      'Add attachment' => 'Aggiungi allegato',
      'Attachment Management' => 'Gestione allegato',
      'Change attachment settings' => 'Modifica configurazione allegato',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Aggiungi risposta automatica',
      'Auto Response From' => 'Risposta automatica Da ',
      'Auto Response Management' => 'Gestione risposta automatica',
      'Change auto response settings' => 'Modifica configurazione della risposta automatica',
      'Charset' => 'Tipo Carattere',
      'Note' => 'Nota',
      'Response' => 'Risposta',
      'to get the first 20 character of the subject' => 'per avere i primi 20 caratteri del suggetto',
      'to get the first 5 lines of the email' => 'per avere le prime 5 linee del  messaggio',
      'to get the from line of the email' => 'per avere la linea FROM del messaggio',
      'to get the realname of the sender (if given)' => 'per avere il numero/nome del mittente (se indicato)',
      'to get the ticket id of the ticket' => 'per avere il TICKET ID ',
      'to get the ticket number of the ticket' => 'per avere il numero del ticket',
      'Type' => 'Tipo',
      'Useable options' => 'Opzione Accessibile',

    # Template: AdminCharsetForm
      'Add charset' => 'Aggiungi Tipo Carattere',
      'Change system charset setting' => 'Modifica parametri del Tipo Carattere ',
      'System Charset Management' => 'Gestione del Tipo Carattere',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Aggiungi cliente',
      'Change customer user settings' => 'Modifica parametri  del cliente',
      'Customer User Management' => 'Gestione Cliente',
      'Customer user will be needed to to login via customer panels.' => 'Gli utenti sono pregati di collegarsi con la maschera corretta .',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Amministratore di Email',
      'Body' => 'Corpo',
      'OTRS-Admin Info!' => 'Informazione Amministratore OTRS',
      'Permission' => 'Permessi',
      'Recipents' => 'Contenitore email',
      'send' => 'Invia',

    # Template: AdminEmailSent
      'Message sent to' => 'Messaggio inviato a',

    # Template: AdminGroupForm
      'Add group' => 'Aggiungi gruppo',
      'Change group settings' => 'Modifica parametri del gruppo',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Dei nuovi gruppi permetteranno di gestire i diritti per diversi gruppi di agente (esempi&nbsp;: forniture, supporto, vendite,tecnici,...).',
      'Group Management' => 'Amministrazione del gruppo',
      'It\'s useful for ASP solutions.' => 'Utile per le suluzioni applicative ASP .',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Il gruppo admin permette di accedere all\'area amministrazione e il gruppo stats all\'area delle statistiche',

    # Template: AdminLog
      'System Log' => 'Log di Sistema',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Amministratore di Email .',
      'AgentFrontend' => 'Interfaccia Agente',
      'Attachment <-> Response' => 'Allegati <-> Risposta',
      'Auto Response <-> Queue' => 'Risposta Automatica <-> coda',
      'Auto Responses' => 'Risposte Automatiche',
      'Charsets' => 'Tipo Carattere',
      'Customer User' => 'Cliente',
      'Email Addresses' => 'Indirizzo elettronico',
      'Groups' => 'Gruppo',
      'Logout' => 'Esci',
      'Misc' => 'Divers',
      'POP3 Account' => 'Collegamento POP3',
      'Responses' => 'Risposte',
      'Responses <-> Queue' => 'Risposte <-> Files',
      'Select Box' => 'Selezionare una funzione',
      'Session Management' => 'Gestione della sessione',
      'Status' => 'Stato',
      'System' => 'Sistema',
      'User <-> Groups' => 'Utente <-> Gruppo',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Aggiungere un collegamento POP3',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Tutte le emails in arrivo saranno ripartite nel file selezionato',
      'Change POP3 Account setting' => 'Cambiamento dei parametri colegamento POP3',
      'Dispatching' => 'Ripartizione',
      'Host' => 'Sistema',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Per la vostra sessione sicura, x-otrs (per priorita,...) saranno utilizzate',
      'Login' => 'Nome utente',
      'POP3 Account Management' => 'Gestione del POP3',
      'Trusted' => 'Sicuro',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestione archivio  <-> Risposta Automatica',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = no storia',
      '0 = no unlock' => '0 = non sbloccato',
      'Add queue' => 'Aggiungi una coda',
      'Change queue settings' => 'Modifica parametri di una coda',
      'Customer Move Notify' => 'Notifica Movimento Utente ',
      'Customer Owner Notify' => 'Notifica Proprietario Utente',
      'Customer State Notify' => 'Notifica Stato Utente',
      'Escalation time' => 'Tempo ',
      'Follow up Option' => 'Opzioni di sequenza',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se un ticket e` chiuso e il cliente invia una nota, il ticket viene bloccato per il proprietario',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Se non si risponde ad un ticket nel tempo selezionato, allora solo questo ticket viene visualizzato',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se un agente blocca un ticket e lui o lei non invia una risposta nel tempo utile fissato , il ticket viene sbloccato automaticamente.',
      'Key' => 'Chiave',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS invia una notifica via email se il ticket e movimentato',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS invia una notifica via email se il proprietario del ticket combia ',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS invia una notifica via email se lo stato del ticket combia ',
      'Queue Management' => 'Gestione delle Code ',
      'Sub-Queue of' => 'Coda-secondaria di',
      'Systemaddress' => 'Indirizzo del sistema',
      'The salutation for email answers.' => 'Il saluto outomatico generato per una risposta via email',
      'The signature for email answers.' => 'La firma automatica generata per una risposta via email',
      'Ticket lock after a follow up' => 'Ticket bloccati dopo una risposta',
      'Unlock timeout' => 'tempo massimo per lo sblocco automatico',
      'Will be the sender address of this queue for email answers.' => 'Indirizzo email di risposta per le risposte automatiche via email',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Modifica parametri di %s',
      'Std. Responses <-> Queue Management' => 'Risposta standard <-> Gestione Code',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Risposta',
      'Change answer <-> queue settings' => 'Cambia i parametri di risposta <-> files',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Risposte Std. <-> Gestione degli allegati Std',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Cambia risposta <-> Parametri degli allegati',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Una risposta e` un testo destinato compilare rapidamente delle risposte ai clienti.',
      'Add response' => 'Aggiungi risposta ',
      'Change response settings' => 'Modifica parametri della risposta',
      'Don\'t forget to add a new response a queue!' => 'Non dimenticare di aggiungere una nuova risposta alla coda !',
      'Response Management' => 'Gestione Risposte',

    # Template: AdminSalutationForm
      'Add salutation' => 'Aggiungi saluti',
      'Change salutation settings' => 'Modifica parametri saluti',
      'customer realname' => 'Numero del cliente',
      'for agent firstname' => 'per il nome  agente',
      'for agent lastname' => 'per il cognome agente',
      'for agent login' => 'per identificazione agente',
      'for agent user id' => 'per id agente ',
      'Salutation Management' => 'Gestione Saluti ',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Numero massimo di linee',

    # Template: AdminSelectBoxResult
      'Limit' => 'Limite',
      'Select Box Result' => 'Seleziona il risultato',
      'SQL' => 'SQL',

    # Template: AdminSession
      'kill all sessions' => 'Chiusura di tutte le sessioni',

    # Template: AdminSessionTable
      'kill session' => 'Chiusura della sessione',
      'SessionID' => 'Identificazione di sessione',

    # Template: AdminSignatureForm
      'Add signature' => 'Aggiungi Firma',
      'Change signature settings' => 'Modifica parametri Firma',
      'Signature Management' => 'Gestione della  Firma',

    # Template: AdminStateForm
      'Add state' => 'Aggiungi stato',
      'Change system state setting' => 'Modifica parametri dello stato del sistema',
      'State Type' => 'Tipo Stato',
      'System State Management' => 'Gestione dello stato del sistema',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Aggiungi Indirizzo del Sistema ',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tutte le emails in arrivo con questo indirizzo (To:) saranno inviate alla coda selezionata ..',
      'Change system address setting' => 'Modifica dei parametri indirizzi di siystama',
      'Email' => 'Indirizzo di Email',
      'Realname' => 'Nome esteso ',
      'System Email Addresses Management' => 'Gestione degli indirizzi email di sistema ',

    # Template: AdminUserForm
      'Add user' => 'Aggiungi utente',
      'Change user settings' => 'Modifica paramentri utente ',
      'Don\'t forget to add a new user to groups!' => 'Non dimenticare di aggiungere un utente ai gruppi !',
      'Firstname' => 'Nome',
      'Lastname' => 'Cognome',
      'User Management' => 'Utente di amministrazione',
      'User will be needed to handle tickets.' => 'Deve esistere un utente per la gestione dei tickets.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => 'Modifica parametri',
      'User <-> Group Management' => 'Utenti <-> Gruppi',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Modifica  parametri utente  <-> inserimento gruppo',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Manca il destinatario nel messaggio (To:)!',
      'Bounce ticket' => 'Ticket Rifiutato',
      'Bounce to' => 'Rifiutato a',
      'Inform sender' => 'Informa mittente del messaggio',
      'Next ticket state' => 'Nuovo stato del ticket',
      'Send mail!' => 'Invia messaggio!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Manca indirizzo di mail (esempio&nbsp;: cliente@esempio.it)&nbsp;!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'La tua email con il numero di ticket "<OTRS_TICKET>" assegnato a "<OTRS_BOUNCE_TO>". Contattare questo indirizzo per ulteriori informazioni.',

    # Template: AgentClose
      ' (work units)' => ' (gruppo di lavoro)',
      'A message should have a subject!' => 'Il messaggio deve avere un soggetto!',
      'Close ticket' => 'Ticket Chiuso',
      'Close type' => 'Tipo di Chiusura',
      'Close!' => 'Chiuso!',
      'Note Text' => 'Nota',
      'Note type' => 'Tipo di nota',
      'Options' => 'Opzioni',
      'Spell Check' => 'Verifica Ortografica',
      'Time units' => 'Tempo',
      'You need to account time!' => 'Serve il tempo di account',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Un messaggio deve essere controllato',
      'Attach' => 'Allega',
      'Compose answer for ticket' => 'Componi una risposta per il ticket',
      'for pending* states' => 'per lo stato attuale ',
      'Is the ticket answered' => 'Esiste una risposta al ticket',
      'Pending Date' => 'Data di attesa',

    # Template: AgentCustomer
      'Back' => 'Indietro',
      'Change customer of ticket' => 'Modifica numero cliente del ticket',
      'CustomerID' => 'Numero del Cliente',
      'Search Customer' => 'Ricerca del Cliente',
      'Set customer user and customer id of a ticket' => 'Compila cliente e numero cliente per un ticket',

    # Template: AgentCustomerHistory
      'Customer history' => 'Storia del Cliente',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerMessage
      'Follow up' => 'Seguito',
      'Next state' => 'prossimo stato',

    # Template: AgentCustomerView
      'Customer Data' => 'Dati del cliente',

    # Template: AgentForward
      'Article type' => 'Tipo articolo',
      'Date' => 'Data',
      'End forwarded message' => 'Fine del messaggio rispedito',
      'Forward article of ticket' => 'Inoltro articolo del  ticket',
      'Forwarded message from' => 'Messaggio riinviato da:',
      'Reply-To' => 'Rispondere a:',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Cambia il messaggio di testo per un ticket',
      'Value' => 'Valore',

    # Template: AgentHistoryForm
      'History of' => 'Storia di ',

    # Template: AgentMailboxNavBar
      'All messages' => 'Tutti i messaggi',
      'down' => 'sotto',
      'Mailbox' => 'Mailbox',
      'New' => 'Nuovo',
      'New messages' => 'Nuovo messaggio',
      'Open' => 'Aperto',
      'Open messages' => 'Apri messaggio',
      'Order' => 'Ordine',
      'Pending messages' => 'Messaggio in attesa',
      'Reminder' => 'Richiamo',
      'Reminder messages' => 'Messaggio di richiamo ',
      'Sort by' => 'Ordinati per',
      'Tickets' => 'Tickets',
      'up' => 'sopra',

    # Template: AgentMailboxTicket

    # Template: AgentMove
      'Move Ticket' => 'Sposta il Ticket',
      'New Queue' => 'Nuova Coda ',
      'New user' => 'Nuovo utente',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Ticket bloccati',
      'new message' => 'nuovo messaggio',
      'PhoneView' => 'Telefono ',
      'Preferences' => 'Preferenze',
      'Utilities' => 'Funzioni',

    # Template: AgentNote
      'Add note to ticket' => 'Aggiungi nota al ticket',
      'Note!' => 'Nota!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Modifica proprietario del ticket',
      'Message for new Owner' => 'Messaggio per il nuovo proprietario',

    # Template: AgentPending
      'Pending date' => 'Data in attesa ',
      'Pending type' => 'Tipo in attesa',
      'Pending!' => 'In attesa',
      'Set Pending' => 'Definizione attesa ',

    # Template: AgentPhone
      'Customer called' => 'Chiamata Cliente',
      'Phone call' => 'Chiamata telefonica',
      'Phone call at %s' => 'Chiamata telefonica a  %s',

    # Template: AgentPhoneNew
      'Clear From' => 'Cancella il FROM',
      'create' => 'crea',
      'new ticket' => 'Nuovo ticket',

    # Template: AgentPlain
      'ArticleID' => 'Identificatore articolo',
      'Plain' => 'Plain',
      'TicketID' => 'Identificatore del Ticket',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Seleziona la coda utente',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Modifica Parola Chiave',
      'New password' => 'Nuova Parola Chiave ',
      'New password again' => 'Nuova Parola Chiave (conferma)',

    # Template: AgentPriority
      'Change priority of ticket' => 'Modifica priorita del ticket',

    # Template: AgentSpelling
      'Apply these changes' => 'Applica le modifiche',
      'Discard all changes and return to the compose screen' => 'Annulla tutte le modifiche e torna nella schermata precedente',
      'Return to the compose screen' => 'Ritorna nella schermata precedente',
      'Spell Checker' => 'Verifica Ortografica',
      'spelling error(s)' => 'Errori di ortografia',
      'The message being composed has been closed.  Exiting.' => 'Il messaggio in corso di composizione viene chiuso. Uscire.',
      'This window must be called from compose window' => 'Questa finestra deve essere richiamata dalla finestra di composiszione ',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'di',
      'Site' => 'Sito',
      'sort downward' => 'Ordina in modo discendente',
      'sort upward' => 'Ordina in modo ascendente',
      'Ticket Status' => 'Stato del Ticket',
      'U' => 'A',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket bloccato&nbsp;!',
      'Ticket unlock!' => 'Ticket sbloccato&nbsp;!',

    # Template: AgentTicketPrint
      'by' => 'da',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Tempo utilizzato ',
      'Escalation in' => 'Escalation in ',
      'printed by' => 'Stampato da :',

    # Template: AgentUtilSearch
      'Article free text' => 'Testo libero articolo',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Ricerca integrale sul testo (es: "Mar*in" oppure "Constru*" oppure "martin+ciao")',
      'search' => 'Cerca',
      'search (e. g. 10*5155 or 105658*)' => 'Cerca (es: 10*5155 oppure 105658*)',
      'Ticket free text' => 'Testo del ticket',
      'Ticket Search' => 'Ricerca Ticket',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Ricerca  storia del Cliente',
      'Customer history search (e. g. "ID342425").' => 'Ricerca storia Cliente (es: "ID342425")',
      'No * possible!' => 'Non possibile!',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Risultato',
      'Total hits' => 'Totale degli accessi al sistema ',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Tutti i ticket chiusi',
      'All open tickets' => 'Tutti  tickets aperti',
      'closed tickets' => 'ticket chiusi',
      'open tickets' => 'tickets aperti',
      'or' => 'o',
      'Provides an overview of all' => 'Visione generale di tutto',
      'So you see what is going on in your system.' => 'Vedete il lavoro sul vostro sistema.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Componi il seguito',
      'Your own Ticket' => 'I tuoi Ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Componi risposta',
      'Contact customer' => 'Contatta il Cliente',
      'phone call' => 'Chiamata telefonica',

    # Template: AgentZoomArticle
      'Split' => 'Spezza',

    # Template: AgentZoomBody
      'Change queue' => 'Cambio coda',

    # Template: AgentZoomHead
      'Free Fields' => 'Campi Liberi',
      'Print' => 'Stampa',

    # Template: AgentZoomStatus

    # Template: CustomerCreateAccount
      'Create Account' => 'Creazione di utente otrs',

    # Template: CustomerError
      'Traceback' => 'Riporta errori',

    # Template: CustomerFooter
      'Powered by' => 'Powered by',

    # Template: CustomerHeader
      'Contact' => 'Contatto',
      'Home' => 'Pagina iniziale',
      'Online-Support' => 'Supporto in linea',
      'Products' => 'Prodotti',
      'Support' => 'Supporto',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Hai perso la Parola Chiave ?',
      'Request new password' => 'Richiedo  nuova Parola Chiave',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Crea nuovo Ticket',
      'My Tickets' => 'Miei tickets',
      'New Ticket' => 'Nuovo Ticket',
      'Ticket-Overview' => 'Riapertura dei Tickets',
      'Welcome %s' => 'Benvenuto %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Clicca qui per segnalare errore',

    # Template: Footer
      'Top of Page' => 'Inizio Pagina',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Creazione Database ',
      'Drop Database' => 'Cancella Database',
      'Finished' => 'Finito',
      'System Settings' => 'Parametri Sistema',
      'Web-Installer' => 'Web-Installer',

    # Template: InstallerFinish
      'Admin-User' => 'Utente di amministrazione',
      'After doing so your OTRS is up and running.' => 'Dopo questo OTRS viene attivato ',
      'Have a lot of fun!' => 'Divertiti con OTRS ',
      'Restart your webserver' => 'Riattiva il tuo webserver ',
      'Start page' => 'Pagina iniziale',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Per abilitare OTRS devi lanciare da linea comando come utente root il seguente comando.',
      'Your OTRS Team' => 'Il tuo team OTRS ',

    # Template: InstallerLicense
      'accept license' => 'accetto le licenze',
      'don\'t accept license' => 'non accetto le licenze',
      'License' => 'Licenze',

    # Template: InstallerStart
      'Create new database' => 'Creazione di un nuovo database',
      'DB Admin Password' => 'DB Admin parola chiave ',
      'DB Admin User' => 'DB Admin Utente',
      'DB Host' => 'DB Host nome sistema ',
      'DB Type' => 'DB tipo ',
      'default \'hot\'' => 'iniziale \'hot\'',
      'Delete old database' => 'Cancella precedente database',
      'next step' => 'Fase successiva',
      'OTRS DB connect host' => 'OTRS DB connect host',
      'OTRS DB Name' => 'OTRS DB Name',
      'OTRS DB Password' => 'OTRS DB Password',
      'OTRS DB User' => 'OTRS DB User',
      'your MySQL DB should have a root password! Default is empty!' => 'il tuo MySQL DB dovrebbe avere una parola chiave di sicurezza ! Come default non esiste!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Controlla i messaggi nella MX per la email usata componendo un risposta. Non usare CheckMXRecord se il tuo sistema OTRS risiede a valle di una dial-up line $!)',
      '(Email of the system admin)' => '(Email dell\'Amministratore di sistema)',
      '(Full qualified domain name of your system)' => '(Nome completo del dominio del vostro sistema)',
      '(Logfile just needed for File-LogModule!)' => '(Archivio del log necessario per  File-LogModule!)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Identificatore del sistema. Ciascun numero di ticket e Ciascun id di sessione http che riferiscono a questo numero)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificatore di tickets. Quante  persone stanno usando ad esempio: \'Ticket#\', \'Appel#\' or \'MonTicket#\')',
      '(Used default language)' => '(Lingua predefinita)',
      '(Used log backend)' => '(Used log backend)',
      '(Used ticket number format)' => '(Formato di tickets usato)',
      'CheckMXRecord' => 'CheckMXRecord',
      'Default Charset' => 'Tipo carattere predefinito',
      'Default Language' => 'Lingua predefinito ',
      'Logfile' => 'Archivio del logger',
      'LogModule' => 'Modulo per il logger',
      'Organization' => 'Organizzazione',
      'System FQDN' => 'FQDN del sistema',
      'SystemID' => 'ID del sistema',
      'Ticket Hook' => 'Ticket Agganciato',
      'Ticket Number Generator' => 'Generatore del numero di tickets',
      'Webfrontend' => 'Interfaccia WEB',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Autorizzazione negata',

    # Template: Notify
      'Info' => 'Informazione',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader

    # Template: QueueView
      'All tickets' => 'Tutti i tickets',
      'Queues' => 'Code',
      'Tickets available' => 'Tickets presenti',
      'Tickets shown' => 'Tickets richiesti',

    # Template: SystemStats
      'Graphs' => 'Grafica',

    # Template: Test
      'OTRS Test Page' => 'Pagina di test OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Sequeza dei ticket',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Aggiungi nota',

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Clicca qui per aggiungere un gruppo)',
      '(Click here to add a queue)' => '(Clicca qui per aggiungere una coda)',
      '(Click here to add a response)' => '(Clicca qui per aggiungere una risposta)',
      '(Click here to add a salutation)' => '(Clicca qui per aggiungere i saluti)',
      '(Click here to add a signature)' => '(Clicca qui per aggiungere una firma)',
      '(Click here to add a system email address)' => '(Clicca qui per aggiungere un indirizzo elettronico del sistema)',
      '(Click here to add a user)' => '(Clicca qui per aggiungere un utente)',
      '(Click here to add an auto response)' => '(Clicca qui per aggiungere una risposta automatica)',
      '(Click here to add charset)' => '(Clicca qui per aggiungere  tipi carattere)',
      '(Click here to add language)' => '(Clicca qui per aggiungere una lingua)',
      '(Click here to add state)' => '(Clicca qui per aggiungere nuovo stato)',
      '(E-Mail of the system admin)' => '(E-Mail of the system admin)',
      'A message should have a From: recipient!' => 'Un messaggio deve avere compilato il campo From:',
      'Create' => 'Crea',
      'CustomerUser' => 'Utente',
      'FAQ' => 'FAQ',
      'Fulltext search' => 'Ricerca integrale sul testo',
      'Handle' => 'Manipolare',
      'In Queue' => 'Nella Coda',
      'New state' => 'Nuovo stato',
      'New ticket via call.' => 'Nuovo ticket via telefono',
      'Search in' => 'Ricerca in',
      'Set customer id of a ticket' => 'Definizione numero cliente del ticket',
      'Show all' => 'Mostra tutto',
      'System Language Management' => 'Gestione  lingua del sistema',
      'Update auto response' => 'Attualizza risposta automatica',
      'Update charset' => 'Attualizza tipi carattere',
      'Update group' => 'Attualizza gruppo',
      'Update language' => 'Attualizza lingua',
      'Update queue' => 'Attualizza  coda',
      'Update response' => 'Attualizza risposta',
      'Update salutation' => 'Attualizza saluti',
      'Update signature' => 'Attualizza firma',
      'Update state' => 'Attualizza stato',
      'Update system address' => 'Aggiorna indirizzi',
      'Update user' => 'Aggiorna utente',
      'With Priority' => 'Con priorita',
      'With State' => 'Con Stato',
      'auto responses set' => 'Risposta automatica inserita',
      'invalid-temporarily' => 'temporaneamente-invalido',
      'store' => 'salva',
      'tickets' => 'Tickets',
      'valid' => 'valido',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
