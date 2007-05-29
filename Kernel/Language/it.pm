# --
# Kernel/Language/it.pm - provides it language translation
# Copyright (C) 2003 Remo Catelotti <Remo.Catelotti at bull.it>
#               2003 Gabriele Santilli <gsantilli at omnibus.net>
#               2005 Giordano Bianchi <giordano.bianchi at gmail.com>
# --
# $Id: it.pm,v 1.45 2007-05-29 12:52:58 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::it;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.45 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Tue May 29 14:48:57 2007

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M/%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %Y %T';
    $Self->{DateFormatShort} = '%D/%M/%Y';
    $Self->{DateInputFormat} = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Sì',
        'No' => '',
        'yes' => 'sì',
        'no' => '',
        'Off' => 'Spento',
        'off' => 'spento',
        'On' => 'Acceso',
        'on' => 'acceso',
        'top' => 'inizio pagina',
        'end' => 'fine pagina',
        'Done' => 'Fatto',
        'Cancel' => 'Annulla',
        'Reset' => 'Ripristina',
        'last' => 'ultimo',
        'before' => 'precedente',
        'day' => 'giorno',
        'days' => 'giorni',
        'day(s)' => 'giorno(i)',
        'hour' => 'ora',
        'hours' => 'ore',
        'hour(s)' => 'ora(e)',
        'minute' => 'minuto',
        'minutes' => 'minuti',
        'minute(s)' => 'minuto(i)',
        'month' => 'mese',
        'months' => 'mesi',
        'month(s)' => 'mese(i)',
        'week' => 'settimana',
        'week(s)' => 'settimana(e)',
        'year' => 'anno',
        'years' => 'anni',
        'year(s)' => 'anno(i)',
        'second(s)' => '',
        'seconds' => '',
        'second' => '',
        'wrote' => 'ha scritto',
        'Message' => 'Messaggio',
        'Error' => 'Errore',
        'Bug Report' => 'Segnala anomalie',
        'Attention' => 'Attenzione',
        'Warning' => 'Attenzione',
        'Module' => 'Modulo',
        'Modulefile' => 'Archivio del modulo',
        'Subfunction' => 'Sotto-funzione',
        'Line' => 'Linea',
        'Example' => 'Esempio',
        'Examples' => 'Esempi',
        'valid' => 'valido',
        'invalid' => 'non valido',
        '* invalid' => '',
        'invalid-temporarily' => 'non valido-temporaneamente',
        ' 2 minutes' => ' 2 minuti',
        ' 5 minutes' => ' 5 minuti',
        ' 7 minutes' => ' 7 minuti',
        '10 minutes' => '10 minuti',
        '15 minutes' => '15 minuti',
        'Mr.' => 'Sig',
        'Mrs.' => 'Sig.ra',
        'Next' => 'Prossimo',
        'Back' => 'Indietro',
        'Next...' => 'Prossimo...',
        '...Back' => '...indietro',
        '-none-' => '',
        'none' => 'nessuno',
        'none!' => 'nessuno!',
        'none - answered' => 'nessuno - risposto',
        'please do not edit!' => 'per favore non modificare!',
        'AddLink' => 'Aggiungi link',
        'Link' => 'Collega',
        'Linked' => 'Collegato',
        'Link (Normal)' => 'Collega (Normale)',
        'Link (Parent)' => 'Collega (Genitore)',
        'Link (Child)' => 'Collega (Figlio)',
        'Normal' => 'Normale',
        'Parent' => 'Genitore',
        'Child' => 'Figlio',
        'Hit' => 'Accesso',
        'Hits' => 'Accessi',
        'Text' => 'Testo',
        'Lite' => 'Ridotta',
        'User' => 'Utenti',
        'Username' => 'Nome utente',
        'Language' => 'Lingua',
        'Languages' => 'Lingue',
        'Password' => '',
        'Salutation' => 'Titolo',
        'Signature' => 'Firma',
        'Customer' => 'Cliente',
        'CustomerID' => 'Codice cliente',
        'CustomerIDs' => 'Codici Cliente',
        'customer' => 'cliente',
        'agent' => 'operatore',
        'system' => 'sistema',
        'Customer Info' => 'Informazioni Cliente',
        'Customer Company' => '',
        'Company' => '',
        'go!' => 'vai!',
        'go' => 'vai',
        'All' => 'Tutti',
        'all' => 'tutti',
        'Sorry' => 'Spiacente',
        'update!' => 'aggiorna!',
        'update' => 'aggiorna',
        'Update' => 'Aggiorna',
        'submit!' => 'accetta!',
        'submit' => 'accetta',
        'Submit' => 'Accetta',
        'change!' => 'Modifica!',
        'Change' => 'Modifica',
        'change' => 'modifica',
        'click here' => 'clicca qui',
        'Comment' => 'Commento',
        'Valid' => 'Valido',
        'Invalid Option!' => 'Opzione non-valida',
        'Invalid time!' => 'ora non-valida',
        'Invalid date!' => 'data non-valida',
        'Name' => 'Nome',
        'Group' => 'Gruppo',
        'Description' => 'Descrizione',
        'description' => 'descrizione',
        'Theme' => 'Tema',
        'Created' => 'Creato',
        'Created by' => 'Creato da',
        'Changed' => 'Modificato',
        'Changed by' => 'Modificato da',
        'Search' => 'Cerca',
        'and' => 'e',
        'between' => 'tra',
        'Fulltext Search' => 'Ricerca Fulltext',
        'Data' => '',
        'Options' => 'Opzioni',
        'Title' => 'Titolo',
        'Item' => 'Oggetto',
        'Delete' => 'Cancella',
        'Edit' => 'Modifica',
        'View' => 'Vista',
        'Number' => 'Numero',
        'System' => 'Sistema',
        'Contact' => 'Contatto',
        'Contacts' => 'Contatti',
        'Export' => 'Esporta',
        'Up' => 'Su',
        'Down' => 'Giù',
        'Add' => 'Aggiungi',
        'Category' => 'Categoria',
        'Viewer' => 'Visualizzatore',
        'New message' => 'Nuovo messaggio',
        'New message!' => 'Nuovo messaggio!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Per favore rispondi a queste richieste prima di tornare alla lista!',
        'You got new message!' => 'Hai un nuovo messaggio!',
        'You have %s new message(s)!' => 'Hai %s nuovi messaggi!',
        'You have %s reminder ticket(s)!' => 'Hai %s Richiesta(e) memorizzati',
        'The recommended charset for your language is %s!' => 'Il set di caratteri raccomandato per la tua lingua è %s!',
        'Passwords doesn\'t match! Please try it again!' => 'La password non corrisponde! Per favore, prova di nuovo',
        'Password is already in use! Please use an other password!' => 'La password è già in uso. Per favore provare con un\' altra password',
        'Password is already used! Please use an other password!' => 'La password è già stata usata! Provare con un\' altra password',
        'You need to activate %s first to use it!' => 'Devi prima attivare %s per poterlo usare',
        'No suggestions' => 'Non ci sono suggerimenti',
        'Word' => 'Parola',
        'Ignore' => 'Ignora',
        'replace with' => 'sostituisci con',
        'There is no account with that login name.' => 'Nome utente non valido.',
        'Login failed! Your username or password was entered incorrectly.' => 'Accesso fallito! Nome utente o password non corretti.',
        'Please contact your admin' => 'Per favore contatta il tuo amministratore',
        'Logout successful. Thank you for using OTRS!' => 'Disconnessione avvenuta con successo. Grazie per aver usato OTRS!',
        'Invalid SessionID!' => 'ID di sessione non valido!',
        'Feature not active!' => 'Funzione non attiva!',
        'Login is needed!' => '',
        'Password is needed!' => 'La password è richiesta',
        'License' => 'Licenza',
        'Take this Customer' => 'Prendi questo Cliente',
        'Take this User' => 'Prendi questo Utente',
        'possible' => 'possibile',
        'reject' => 'respinto',
        'reverse' => '',
        'Facility' => 'Funzione',
        'Timeover' => 'Tempo scaduto',
        'Pending till' => 'In attesa per',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Non lavorare con l\'operatore con ID 1 (System account)! Crea dei nuovi utenti!',
        'Dispatching by email To: field.' => 'Smistamento in base al campo To:.',
        'Dispatching by selected Queue.' => 'Smistamento in base alla coda selezionata.',
        'No entry found!' => 'Vuoto!',
        'Session has timed out. Please log in again.' => 'Sessione scaduta. Per favore, effettua di nuovo l\'accesso.',
        'No Permission!' => 'Permessi insufficienti',
        'To: (%s) replaced with database email!' => 'A: (%s) sostituito con l\'indirizzo presente nel database',
        'Cc: (%s) added database email!' => '',
        '(Click here to add)' => '(clicca per aggiungere)',
        'Preview' => 'Anteprima',
        'Package not correctly deployed! You should reinstall the Package again!' => '',
        'Added User "%s"' => 'Utente "%s" aggiunto',
        'Contract' => 'Contratto',
        'Online Customer: %s' => 'Clienti collegati: %s',
        'Online Agent: %s' => 'Operatori collegati: %s',
        'Calendar' => 'Calendario',
        'File' => '',
        'Filename' => 'Nome file',
        'Type' => 'Tipo',
        'Size' => 'Dimensione',
        'Upload' => 'Caricamento',
        'Directory' => 'Cartella',
        'Signed' => 'Firmato',
        'Sign' => 'Firma',
        'Crypted' => 'Crittografato',
        'Crypt' => 'Crittografa',
        'Office' => '',
        'Phone' => '',
        'Fax' => '',
        'Mobile' => '',
        'Zip' => '',
        'City' => '',
        'Country' => '',
        'installed' => '',
        'uninstalled' => '',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => '',

        # Template: AAAMonth
        'Jan' => 'Gen',
        'Feb' => '',
        'Mar' => '',
        'Apr' => '',
        'May' => 'Mag',
        'Jun' => 'Giu',
        'Jul' => 'Lug',
        'Aug' => 'Ago',
        'Sep' => 'Set',
        'Oct' => 'Ott',
        'Nov' => '',
        'Dec' => 'Dic',
        'January' => '',
        'February' => '',
        'March' => '',
        'April' => '',
        'June' => '',
        'July' => '',
        'August' => '',
        'September' => '',
        'October' => '',
        'November' => '',
        'December' => '',

        # Template: AAANavBar
        'Admin-Area' => 'Area Amministrazione',
        'Agent-Area' => 'Area Operatore',
        'Ticket-Area' => 'Area Richieste',
        'Logout' => 'Esci',
        'Agent Preferences' => 'Impostazione preferenze per l\'operatore',
        'Preferences' => 'Preferenze',
        'Agent Mailbox' => 'Casella dell\' Operatore',
        'Stats' => 'Statistiche',
        'Stats-Area' => 'Area Statistiche',
        'Admin' => '',
        'Customer Users' => 'Utenti Clienti',
        'Customer Users <-> Groups' => 'Utenti Clienti <-> Gruppi',
        'Users <-> Groups' => 'Utenti <-> Gruppi',
        'Roles' => 'Ruoli',
        'Roles <-> Users' => 'Ruoli <-> Utenti',
        'Roles <-> Groups' => 'Ruoli <-> Gruppi',
        'Salutations' => '',
        'Signatures' => 'Firme',
        'Email Addresses' => 'Indirizzi Email',
        'Notifications' => 'Notifiche',
        'Category Tree' => 'Albero delle Categorie',
        'Admin Notification' => 'Notifiche Amministrative',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Preferenze modificate con successo!',
        'Mail Management' => 'Gestione posta',
        'Frontend' => 'Interfaccia',
        'Other Options' => 'Altre opzioni',
        'Change Password' => 'Cambia Password',
        'New password' => 'Nuova Password',
        'New password again' => 'Ripetere Nuova Password',
        'Select your QueueView refresh time.' => 'Scegli il tempo di aggiornamento della lista delle richieste.',
        'Select your frontend language.' => 'Scegli la lingua per la tua interfaccia.',
        'Select your frontend Charset.' => 'Seleziona il set di caratteri da usare.',
        'Select your frontend Theme.' => 'Scegli il tema per la tua interfaccia.',
        'Select your frontend QueueView.' => 'Scegli l\'interfaccia per la lista messaggi.',
        'Spelling Dictionary' => 'Dizionario',
        'Select your default spelling dictionary.' => 'Seleziona il dizionario standard',
        'Max. shown Tickets a page in Overview.' => 'Numero massimo di richieste per pagina nel Sommario',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => '',
        'Can\'t update password, invalid characters!' => 'Non posso aggiornare la password, dei caratteri non sono validi',
        'Can\'t update password, need min. 8 characters!' => 'Non posso aggiornare la password, ho bisogno di almeno 8 caratteri ',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Non posso aggiornare la password, ho bisogno di 2 caratteri maiuscoli e 2 minuscoli ',
        'Can\'t update password, need min. 1 digit!' => 'Non posso aggiornare la password, ho bisogno di almeno 1 numero',
        'Can\'t update password, need min. 2 characters!' => 'Non posso aggiornare la password, ho bisogno di almeno 2 caratteri',

        # Template: AAAStats
        'Stat' => '',
        'Please fill out the required fields!' => '',
        'Please select a file!' => '',
        'Please select an object!' => '',
        'Please select a graph size!' => '',
        'Please select one element for the X-axis!' => '',
        'You have to select two or more attributes from the select field!' => '',
        'Please select only one element or turn of the button \'Fixed\' where the select field is marked!' => '',
        'If you use a checkbox you have to select some attributes of the select field!' => '',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
        'The selected end time is before the start time!' => '',
        'You have to select one or more attributes from the select field!' => '',
        'The selected Date isn\'t valid!' => '',
        'Please select only one or two elements via the checkbox!' => '',
        'If you use a time scale element you can only select one element!' => '',
        'You have an error in your time selection!' => '',
        'Your reporting time interval is to small, please use a larger time scale!' => '',
        'The selected start time is before the allowed start time!' => '',
        'The selected end time is after the allowed end time!' => '',
        'The selected time period is larger than the allowed time period!' => '',
        'Common Specification' => '',
        'Xaxis' => '',
        'Value Series' => '',
        'Restrictions' => '',
        'graph-lines' => '',
        'graph-bars' => '',
        'graph-hbars' => '',
        'graph-points' => '',
        'graph-lines-points' => '',
        'graph-area' => '',
        'graph-pie' => '',
        'extended' => '',
        'Agent/Owner' => '',
        'Created by Agent/Owner' => '',
        'Created Priority' => '',
        'Created State' => '',
        'Create Time' => '',
        'CustomerUserLogin' => '',
        'Close Time' => '',

        # Template: AAATicket
        'Lock' => 'Prendi in gestione',
        'Unlock' => 'Abbandona gestione',
        'History' => 'Storico',
        'Zoom' => 'Dettagli',
        'Age' => 'Tempo trascorso',
        'Bounce' => 'Rispedisci al mittente',
        'Forward' => 'Inoltra',
        'From' => 'Da',
        'To' => 'A',
        'Cc' => '',
        'Bcc' => '',
        'Subject' => 'Oggetto',
        'Move' => 'Sposta',
        'Queue' => 'Coda',
        'Priority' => 'Priorità',
        'State' => 'Stato',
        'Compose' => 'Componi',
        'Pending' => 'In attesa',
        'Owner' => 'Operatore',
        'Owner Update' => 'Aggiornamento Operatore',
        'Responsible' => '',
        'Responsible Update' => '',
        'Sender' => 'Mittente',
        'Article' => 'Articolo',
        'Ticket' => 'Richiesta',
        'Createtime' => 'Istante di creazione',
        'plain' => 'diretto',
        'Email' => '',
        'email' => '',
        'Close' => 'Chiudi',
        'Action' => 'Azione',
        'Attachment' => 'Allegato',
        'Attachments' => 'Allegati',
        'This message was written in a character set other than your own.' => 'Questo messaggio è stato scritto in un set di caratteri diverso dal tuo.',
        'If it is not displayed correctly,' => 'Se non è visualizzato correttamente,',
        'This is a' => 'Questo è un',
        'to open it in a new window.' => 'per aprire in una nuova finestra.',
        'This is a HTML email. Click here to show it.' => 'Questa è una email in HTML. Clicca qui per visualizzarla.',
        'Free Fields' => 'Campi Liberi',
        'Merge' => 'Unisci',
        'merged' => '',
        'closed successful' => 'chiuso con successo',
        'closed unsuccessful' => 'chiuso senza successo',
        'new' => 'nuovo',
        'open' => 'aperto',
        'closed' => 'chiuso',
        'removed' => 'rimosso',
        'pending reminder' => 'in attesa di risposta',
        'pending auto' => '',
        'pending auto close+' => 'in attesa di chiusura automatica+',
        'pending auto close-' => 'in attesa di chiusura automatica-',
        'email-external' => 'Email esterna',
        'email-internal' => 'Email interna',
        'note-external' => 'Nota esterna',
        'note-internal' => 'Nota interna',
        'note-report' => 'Nota rapporto',
        'phone' => 'telefono',
        'sms' => '',
        'webrequest' => 'richiesta da web',
        'lock' => 'prendi in gestione',
        'unlock' => 'abbandona gestione',
        'very low' => 'molto basso',
        'low' => 'basso',
        'normal' => 'normale',
        'high' => 'alto',
        'very high' => 'molto alto',
        '1 very low' => '1 molto bassa',
        '2 low' => '2 bassa',
        '3 normal' => '3 normale',
        '4 high' => '4 alta',
        '5 very high' => '5 molto alta',
        'Ticket "%s" created!' => 'Richiesta "%s" creata!',
        'Ticket Number' => 'Numero Richiesta',
        'Ticket Object' => 'Oggetto Richiesta',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Numero richiesta "%s" non presente! Collegamento impossibile!',
        'Don\'t show closed Tickets' => 'Non mostrare le richieste chiuse',
        'Show closed Tickets' => 'Mostra le richieste chiuse',
        'New Article' => 'Nuovo articolo',
        'Email-Ticket' => 'Richiesta Email',
        'Create new Email Ticket' => 'Crea una nuova richiesta via email',
        'Phone-Ticket' => 'Richiesta-Telefonica',
        'Search Tickets' => 'Ricerca Richieste',
        'Edit Customer Users' => 'Modifica Utenti Clienti',
        'Bulk-Action' => 'Operazioni Multiple',
        'Bulk Actions on Tickets' => 'Operazione di massa sulle richieste',
        'Send Email and create a new Ticket' => 'Manda un email e crea una nuova richiesta',
        'Create new Email Ticket and send this out (Outbound)' => '',
        'Create new Phone Ticket (Inbound)' => '',
        'Overview of all open Tickets' => 'Vista globale di tutte le richieste aperte',
        'Locked Tickets' => 'Richieste in gestione',
        'Watched Tickets' => '',
        'Watched' => '',
        'Subscribe' => '',
        'Unsubscribe' => '',
        'Lock it to work on it!' => 'Prendi in gestione per lavorarci',
        'Unlock to give it back to the queue!' => 'Abbandona la gestione per ri-inserirla nella coda',
        'Shows the ticket history!' => 'Visualizza lo storico della richiesta',
        'Print this ticket!' => 'Stampa questa richiesta',
        'Change the ticket priority!' => 'Cambia la priorità della richiesta',
        'Change the ticket free fields!' => 'Cambia i campi liberi della richiesta',
        'Link this ticket to an other objects!' => 'Collega questa richiesta ad un altro oggetto',
        'Change the ticket owner!' => 'Cambia il proprietario della richiesta',
        'Change the ticket customer!' => 'Cambia il cliente della richiesta',
        'Add a note to this ticket!' => 'Aggiungi una nota a questa richiesta',
        'Merge this ticket!' => 'Unisci questa richiesta',
        'Set this ticket to pending!' => 'Imposta questa richiesta come sospesa',
        'Close this ticket!' => 'Chiudi questa richiesta',
        'Look into a ticket!' => 'Visualizza questa richiesta',
        'Delete this ticket!' => 'Cancella questa richiesta',
        'Mark as Spam!' => 'Segnala come spam',
        'My Queues' => 'Le mie Code',
        'Shown Tickets' => 'Richieste Visualizzate',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'La tua email con la richiesta numero "<OTRS_TICKET>" è stata unita a "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => '',
        'Ticket %s: first response time will be over in %s!' => '',
        'Ticket %s: update time is over (%s)!' => '',
        'Ticket %s: update time will be over in %s!' => '',
        'Ticket %s: solution time is over (%s)!' => '',
        'Ticket %s: solution time will be over in %s!' => '',
        'There are more escalated tickets!' => '',
        'New ticket notification' => 'Notifica nuova richiesta',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Mandami una notifica se viene inserita una nuova richiesta in una coda della lista "Le mie Code"',
        'Follow up notification' => 'Notifica di risposta',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Mandami una notifica se un cliente risponde ad una richiesta che ho io in gestione.',
        'Ticket lock timeout notification' => 'Notifica scadenza gestione richieste',
        'Send me a notification if a ticket is unlocked by the system.' => 'Mandami una notifica se una richiesta viene sbloccata dal sistema.',
        'Move notification' => 'Notifica spostamento',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Mandami una notifica se una richiesta viene spostata in una coda della lista "Le mie Code"',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'La vostra selezione delle code preferite. Se attivato, sarete anche notificati delle modifiche su questa coda',
        'Custom Queue' => 'Coda personale',
        'QueueView refresh time' => 'Tempo di aggiornamento lista richieste',
        'Screen after new ticket' => 'Pagina da mostrare dopo una nuova richiesta',
        'Select your screen after creating a new ticket.' => 'Scegli la pagina da mostrare dopo una nuova richiesta',
        'Closed Tickets' => 'Richieste chiuse',
        'Show closed tickets.' => 'Mostra le richieste chiuse.',
        'Max. shown Tickets a page in QueueView.' => 'Numero massimo di richieste per pagina nella Lista Richieste',
        'CompanyTickets' => '',
        'MyTickets' => '',
        'New Ticket' => '',
        'Create new Ticket' => '',
        'Customer called' => '',
        'phone call' => '',
        'Responses' => 'Risposte',
        'Responses <-> Queue' => '',
        'Auto Responses' => 'Risposte Automatiche',
        'Auto Responses <-> Queue' => 'Risposte Automatiche <-> Code',
        'Attachments <-> Responses' => 'Allegati <-> Risposte',
        'History::Move' => 'Richiesta mossa nella coda "%s" (%s) dalla coda "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'Nuova richiesta [%s] creata (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Prosecuzione per [%s]. %s',
        'History::SendAutoReject' => 'Rifiuto automatico inviato a "%s".',
        'History::SendAutoReply' => 'Risposta automatica inviata a "%s".',
        'History::SendAutoFollowUp' => 'Prosecuzione automatica inviata a "%s".',
        'History::Forward' => 'Inoltrato a "%s".',
        'History::Bounce' => 'Rimbalzato a "%s".',
        'History::SendAnswer' => 'Email inviata a "%s".',
        'History::SendAgentNotification' => '"%s"-notifica inviata a "%s".',
        'History::SendCustomerNotification' => 'Notifica inviata a "%s".',
        'History::EmailAgent' => 'Email inviata al cliente.',
        'History::EmailCustomer' => 'Email. %s aggiunta',
        'History::PhoneCallAgent' => 'L\'operatore ha chiamato il cliente.',
        'History::PhoneCallCustomer' => 'Il cliente ha chiamato noi.',
        'History::AddNote' => 'Aggiunta nota (%s)',
        'History::Lock' => 'Richiesta bloccata.',
        'History::Unlock' => 'Richiesta lasciata.',
        'History::TimeAccounting' => '%s unita\' temporali addebitate. Nuovo totale: %s.',
        'History::Remove' => 'Rimosso da %s',
        'History::CustomerUpdate' => 'Aggiornato: %s',
        'History::PriorityUpdate' => 'Priorita\' cambiata da "%s" (%s) a "%s" (%s).',
        'History::OwnerUpdate' => 'Nuovo operatore assegnato = "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! Nessuna risposta automatica inviata a "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Aggiornato: %s',
        'History::StateUpdate' => 'Vecchio: "%s" Nuovo: "%s"',
        'History::TicketFreeTextUpdate' => 'Aggiornato: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Richiesta del cliente via web.',
        'History::TicketLinkAdd' => 'Aggiunto link alla richiesta "%s".',
        'History::TicketLinkDelete' => 'Eliminato link alla richiesta "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mer',
        'Thu' => 'Gio',
        'Fri' => 'Ven',
        'Sat' => 'Sab',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Gestione allegati',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Gestione risposte automatiche',
        'Response' => 'Risposta',
        'Auto Response From' => 'Risposta automatica da',
        'Note' => 'Nota',
        'Useable options' => 'Opzioni disponibili',
        'To get the first 20 character of the subject.' => '',
        'To get the first 5 lines of the email.' => '',
        'To get the realname of the sender (if given).' => '',
        'To get the article attribut (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => '',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => '',
        'Add Customer Company' => '',
        'Add a new Customer Company.' => '',
        'List' => '',
        'This values are required.' => 'Questi valori sono richiesti',
        'This values are read only.' => 'Questi valori non sono modificabili',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Gestione clienti',
        'Search for' => 'Cerca',
        'Add Customer User' => '',
        'Source' => 'Sorgente',
        'Create' => 'Crea',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Il cliente sarà necessario per registrare la sua storia e permettere il collegamento via web',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => '',
        'Change %s settings' => 'Modifica impostazioni di %s',
        'Select the user:group permissions.' => 'Seleziona i permessi della coppia utente:gruppo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Se non viene selezionata nessuna opzione, non verranno dati permessi a questo gruppo (le richieste non saranno disponibili).',
        'Permission' => 'Permessi',
        'ro' => 'sola lettura',
        'Read only access to the ticket in this group/queue.' => 'Accesso in sola lettura alle richieste in questo gruppo/coda.',
        'rw' => 'lettura e scrittura',
        'Full read and write access to the tickets in this group/queue.' => 'Accesso completo in lettura e scrittura alle richieste in questo gruppo/coda',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminEmail
        'Message sent to' => 'Messaggio inviato a',
        'Recipents' => 'Destinatari',
        'Body' => 'Testo',
        'Send' => '',

        # Template: AdminGenericAgent
        'GenericAgent' => 'OperatoreGenerico',
        'Job-List' => 'Lista attività',
        'Last run' => 'Ultima esecuzione',
        'Run Now!' => 'Esegui Ora',
        'x' => '',
        'Save Job as?' => 'Salva attività con nome?',
        'Is Job Valid?' => 'L\' attività è normale?',
        'Is Job Valid' => 'L\' attività è normale',
        'Schedule' => 'Programma',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Ricerca a testo libero nel testo dell\'articolo (per esempio \'Ro*si\' o \'Ma*io\')',
        '(e. g. 10*5155 or 105658*)' => '(per esempio \'10*5155\' o \'105658*\')',
        '(e. g. 234321)' => '(per esempio \'234321\')',
        'Customer User Login' => 'Identificativo di Accesso del Cliente',
        '(e. g. U5150)' => '(per esempio \'U5150\')',
        'Agent' => 'Operatore',
        'Ticket Lock' => 'Gestione Richiesta',
        'TicketFreeFields' => '',
        'Create Times' => '',
        'No create time settings.' => '',
        'Ticket created' => 'Richiesta creata',
        'Ticket created between' => 'Richiesta creata fra',
        'Pending Times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'New Priority' => 'Nuova Priorità',
        'New Queue' => 'Nuova coda',
        'New State' => 'Nuovo stato',
        'New Agent' => 'Nuovo Operatore',
        'New Owner' => 'Nuovo Gestore',
        'New Customer' => 'Nuovo Cliente',
        'New Ticket Lock' => 'Nuovo gestore della richiesta',
        'CustomerUser' => 'Cliente',
        'New TicketFreeFields' => '',
        'Add Note' => 'Aggiungi nota',
        'CMD' => 'comando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Questo comando verrà eseguito. ARG[0] sarà il numero della richiesta. ARG[1] sarà l\'identificativo della richiesta.',
        'Delete tickets' => 'Elimina richieste',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Attenzione! Queste richieste verranno eliminate dalla base dati! Queste richieste saranno perse!',
        'Send Notification' => '',
        'Param 1' => 'Parametro 1',
        'Param 2' => 'Parametro 2',
        'Param 3' => 'Parametro 3',
        'Param 4' => 'Parametro 4',
        'Param 5' => 'Parametro 5',
        'Param 6' => 'Parametro 6',
        'Send no notifications' => '',
        'Yes means, send no agent and customer notifications on changes.' => '',
        'No means, send agent and customer notifications on changes.' => '',
        'Save' => 'Salva',
        '%s Tickets affected! Do you really want to use this job?' => '',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'Gestione gruppo',
        'Add Group' => '',
        'Add a new Group.' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Il gruppo admin ha accesso all\'area amministrazione mentre il gruppo stats ha accesso alle statistiche.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Creare nuovi gruppi per gestire i permessi di accesso per diversi gruppi di agenti (p.es. sezione vendite, supporto tecnico, ecc.)',
        'It\'s useful for ASP solutions.' => 'È utile per soluzioni ASP',

        # Template: AdminLog
        'System Log' => 'Log di sistema',
        'Time' => 'Tempo',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => '',
        'Account Type' => '',
        'POP3' => '',
        'POP3S' => '',
        'IMAP' => '',
        'IMAPS' => '',
        'Mailbox' => 'Casella postale',
        'Port' => '',
        'Trusted' => 'Fidato',
        'Dispatching' => 'Smistamento',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Tutti i messaggi in arrivo saranno smistati nella coda selezionata!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Se il tuo account è fidato (trusted), verrà utilizzato l\'header X-OTRS dell\'istante di arrivo (priorità, ...)! Il filtro di ingresso verrà utilizzato in ogni caso.',

        # Template: AdminNavigationBar
        'Users' => 'Utenti',
        'Groups' => 'Gruppi',
        'Misc' => 'Varie',

        # Template: AdminNotificationForm
        'Notification Management' => 'Gestione delle notifiche',
        'Notification' => 'Notifica',
        'Notifications are sent to an agent or a customer.' => 'Le notifiche sono inviate ad un operatore o a un cliente',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestione Pacchetti',
        'Uninstall' => 'disinstalla',
        'Version' => 'Versione',
        'Do you really want to uninstall this package?' => 'Vuoi davvero disinstallare questo pacchetto?',
        'Reinstall' => 'Re-installa',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '',
        'Cancle' => '',
        'Continue' => '',
        'Install' => 'Installa',
        'Package' => 'Pacchetto',
        'Online Repository' => 'Archivio Online',
        'Vendor' => 'Fornitore',
        'Upgrade' => '',
        'Local Repository' => 'Archivio Locale',
        'Status' => 'Stato',
        'Overview' => 'Sommario',
        'Download' => 'Scarica',
        'Rebuild' => 'Ricrea',
        'ChangeLog' => '',
        'Date' => '',
        'Filelist' => '',
        'Download file from package!' => '',
        'Required' => '',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => '',
        'This feature is enabled!' => '',
        'Just use this feature if you want to log each request.' => '',
        'Of couse this feature will take some system performance it self!' => '',
        'Disable it here!' => '',
        'This feature is disabled!' => '',
        'Enable it here!' => '',
        'Logfile too large!' => '',
        'Logfile too large, you need to reset it!' => '',
        'Range' => '',
        'Interface' => '',
        'Requests' => '',
        'Min Response' => '',
        'Max Response' => '',
        'Average Response' => '',

        # Template: AdminPGPForm
        'PGP Management' => 'Gestione PGP',
        'Result' => 'Risultato',
        'Identifier' => 'Identificatore',
        'Bit' => '',
        'Key' => 'Etichetta',
        'Fingerprint' => 'Impronta (fingerprint)',
        'Expires' => 'Scade',
        'In this way you can directly edit the keyring configured in SysConfig.' => '',

        # Template: AdminPOP3
        'POP3 Account Management' => 'Gestione accessi POP3',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestione filtri posta in ingresso',
        'Filtername' => 'Nome del filtro',
        'Match' => 'Corrispondenza',
        'Header' => 'Intestazione (header)',
        'Value' => 'Valore',
        'Set' => 'Impostazione',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Effettua lo smistamento o filtra la posta in ingresso in base all\'X-Header! Sono accettate anche espressioni regolari.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Se usi espressioni regolari, puoi anche utilizzare il valore corrispondente a () come [***] negli insiemi',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => '',

        # Template: AdminQueueForm
        'Queue Management' => 'Gestione delle code',
        'Sub-Queue of' => 'Sottocoda di',
        'Unlock timeout' => 'Tempo di sblocco automatico',
        '0 = no unlock' => '0 = nessuno sblocco automatico',
        'Escalation - First Response Time' => '',
        '0 = no escalation' => '0 = nessuna escalation',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Follow up Option' => 'Opzioni per le prosecuzioni',
        'Ticket lock after a follow up' => 'Presa in gestione della richiesta dopo una prosecuzione',
        'Systemaddress' => 'Indirizzo di sistema',
        'Customer Move Notify' => 'Notifica il cliente degli spostamenti',
        'Customer State Notify' => 'Notifica il cliente del cambio di stato',
        'Customer Owner Notify' => 'Notifica il cliente del cambio operatore',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Se un operatore prende in gestione una richiesta ma non risponde entro il tempo specificato, la richiesta viene sbloccata in modo da essere accessibile agli altri operatori.',
        'Escalation time' => 'Tempo di escalation',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Se una richiesta non viene risposta entro questo limite di tempo, sarà l\'unica richiesta ad essere visualizzata.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Se una richiesta è chiusa e il cliente invia una risposta, la richiesta viene assegnata al vecchio operatore.',
        'Will be the sender address of this queue for email answers.' => 'Mittente utilizzato per le risposte relative alle richieste di questa coda.',
        'The salutation for email answers.' => 'Saluto (parte iniziale) per le email generate automaticamente dal sistema.',
        'The signature for email answers.' => 'Firma (parte finale) per le email generate automaticamente dal sistema.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS invia una notifica via email al cliente se la richiesta viene spostata.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS invia una notifica via email al cliente se lo stato della richiesta cambia.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS invia una notifica via email al cliente se l\'operatore assegnato alla richiesta cambia.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Risposte <-> Gestione Code',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Risposta',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Risposte <-> Gestione Allegati',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Gestione risposte',
        'A response is default text to write faster answer (with default text) to customers.' => 'Una risposta è un testo predefinito usato per compilare più rapidamente le risposte per i clienti.',
        'Don\'t forget to add a new response a queue!' => 'Non dimenticare di aggiungere una risposta per ogni coda!',
        'The current ticket state is' => 'Lo stato corrente della richiesta è',
        'Your email address is new' => 'Il tuo indirizzo di email è nuovo',

        # Template: AdminRoleForm
        'Role Management' => 'Gestione ruoli',
        'Add Role' => '',
        'Add a new Role.' => '',
        'Create a role and put groups in it. Then add the role to the users.' => 'Crea un ruolo e mettici i gruppi. Poi aggiungi il ruolo agli utenti.',
        'It\'s useful for a lot of users and groups.' => 'E\' utile per molti utenti e gruppi',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => '',
        'move_into' => 'muovi_in',
        'Permissions to move tickets into this group/queue.' => 'Autorizzazione a muovere richieste in questo gruppo/coda',
        'create' => 'crea',
        'Permissions to create tickets in this group/queue.' => 'Autorizzazione a creare richieste in questo gruppo/coda',
        'owner' => 'gestore',
        'Permissions to change the ticket owner in this group/queue.' => 'Autorizzazione a cambiare il gestore di una richiesta in questo gruppo/coda.',
        'priority' => 'priorità',
        'Permissions to change the ticket priority in this group/queue.' => 'Autorizzazione a cambiare la priorità di una richiesta in questo gruppo/coda',

        # Template: AdminRoleGroupForm
        'Role' => 'Ruolo',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Ruoli <-> Gestione Utenti',
        'Active' => 'Attivo',
        'Select the role:user relations.' => 'Seleziona le relazioni ruolo:utente.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Gestione saluti',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'Select Box' => 'Selezionare una funzione',
        'Limit' => 'Limite',
        'Go' => '',
        'Select Box Result' => 'Seleziona il risultato',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => '',
        'Add a new Service.' => '',
        'Service' => '',
        'Sub-Service of' => '',

        # Template: AdminSession
        'Session Management' => 'Gestione Sessioni',
        'Sessions' => 'Sessioni',
        'Uniq' => '',
        'Kill all sessions' => '',
        'Session' => 'Sessione',
        'Content' => '',
        'kill session' => 'Termina sessione',

        # Template: AdminSignatureForm
        'Signature Management' => 'Gestione firme',
        'Add Signature' => '',
        'Add a new Signature.' => '',

        # Template: AdminSLA
        'SLA Management' => '',
        'Add SLA' => '',
        'Add a new SLA.' => '',
        'SLA' => '',
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',

        # Template: AdminSMIMEForm
        'S/MIME Management' => '',
        'Add Certificate' => 'Aggiungi certificato',
        'Add Private Key' => 'Aggiunti chiave privata',
        'Secret' => 'Segreto',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => 'Puoi modificare il certificato e la chiave privata direttamente sul filesystem.',

        # Template: AdminStateForm
        'State Management' => '',
        'Add State' => '',
        'Add a new State.' => '',
        'State Type' => 'Tipologia',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Assicurati di aver aggiornato gli stati pre-impostati (default) nel file Kernel/Config.pm!',
        'See also' => 'Vedi anche',

        # Template: AdminSysConfig
        'SysConfig' => '',
        'Group selection' => '',
        'Show' => '',
        'Download Settings' => '',
        'Download all system config changes.' => '',
        'Load Settings' => '',
        'Subgroup' => '',
        'Elements' => '',

        # Template: AdminSysConfigEdit
        'Config Options' => '',
        'Default' => '',
        'New' => 'Nuovi',
        'New Group' => '',
        'Group Ro' => '',
        'New Group Ro' => '',
        'NavBarName' => '',
        'NavBar' => '',
        'Image' => '',
        'Prio' => '',
        'Block' => '',
        'AccessKey' => '',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Gestione indirizzi di sistema',
        'Add System Address' => '',
        'Add a new System Address.' => '',
        'Realname' => 'Nome',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tutte le email in arrivo indirizzate a questo indirizzo (campo To:) saranno smistate nella coda selezionata!',

        # Template: AdminSystemStatus
        'System Status' => '',

        # Template: AdminTicketCustomerNotification
        'Notification (Customer)' => '',
        'Event' => '',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'Gestione operatori',
        'Add User' => '',
        'Add a new Agent.' => '',
        'Login as' => '',
        'Firstname' => 'Nome',
        'Lastname' => 'Cognome',
        'User will be needed to handle tickets.' => 'Gli operatori sono necessari per gestire le richieste.',
        'Don\'t forget to add a new user to groups and/or roles!' => '',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => '',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Rubrica',
        'Return to the compose screen' => 'Torna alla composizione del messaggio',
        'Discard all changes and return to the compose screen' => 'Annulla tutte le modifiche e torna alla composizione del messaggio',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Informazioni',

        # Template: AgentLinkObject
        'Link Object' => '',
        'Select' => 'Seleziona',
        'Results' => 'Risultati',
        'Total hits' => 'Totale risultati',
        'Page' => 'Pagina',
        'Detail' => '',

        # Template: AgentLookup
        'Lookup' => 'Ricerca',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Verifica ortografica',
        'spelling error(s)' => 'Errori di ortografia',
        'or' => 'oppure',
        'Apply these changes' => 'Applica le modifiche',

        # Template: AgentStatsDelete
        'Stat#' => '',
        'Do you really want to delete this Object?' => 'Vuoi davvero cancellare questo oggetto?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '',
        'Fixed' => '',
        'Please select only one Element or turn of the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => '',
        'Relative Period' => '',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributs of the corresponding element.' => '',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '',
        'Permissions' => '',
        'Format' => '',
        'Graphsize' => '',
        'Sum rows' => '',
        'Sum columns' => '',
        'Cache' => '',
        'Required Field' => '',
        'Selection needed' => '',
        'Explanation' => '',
        'In this form you can select the basic specifications.' => '',
        'Attribute' => '',
        'Title of the stat.' => '',
        'Here you can insert a description of the stat.' => '',
        'Dynamic-Object' => '',
        'Here you can select the dynamic object you want to use.' => '',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '',
        'Static-File' => '',
        'For very complex stats it is possible to include a hardcoded file.' => '',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => '',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '',
        'Multiple selection of the output format.' => '',
        'If you use a graph as output format you have to select at least one graph size.' => '',
        'If you need the sum of every row select yes' => '',
        'If you need the sum of every column select yes.' => '',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => '',
        '(Note: Useful for big databases and low performance server)' => '',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => '',
        'Scale' => '',
        'minimal' => '',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '',
        'maximal period' => '',
        'minimal scale' => '',
        'Here you can define the x-axis. You can select one element via the radio button. Than you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => '',
        'File is not a Stats config' => '',
        'No File selected' => '',

        # Template: AgentStatsOverview
        'Object' => '',

        # Template: AgentStatsPrint
        'Print' => 'Stampa',
        'No Element selected.' => '',

        # Template: AgentStatsView
        'Export Config' => '',
        'Informations about the Stat' => '',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => '',
        'maximal period from' => '',
        'to' => '',
        'Start' => '',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketArticleUpdate
        'A message should have a subject!' => 'Il messaggio deve avere un oggetto!',
        'A message should have a body!' => 'Un messaggio deve avere un contenuto!',
        'You need to account time!' => 'Devi inserire il tempo impiegato per la risposta!',
        'Edit Article' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Rispedisci richiesta',
        'Ticket locked!' => 'Richiesta già presa in gestione!',
        'Ticket unlock!' => 'Richiesta abbandonata!',
        'Bounce to' => 'Rispedisci a',
        'Next ticket state' => 'Stato successivo della richiesta',
        'Inform sender' => 'Informa il mittente',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'La tua email con il numero di richiesta "<OTRS_TICKET>" è stata reindirizzata a "<OTRS_BOUNCE_TO>". Contattare questo indirizzo per ulteriori informazioni.',
        'Send mail!' => 'Invia messaggio!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Azione di massa',
        'Spell Check' => 'Verifica ortografica',
        'Note type' => 'Tipologia della nota',
        'Unlock Tickets' => '',

        # Template: AgentTicketClose
        'Close ticket' => 'Chiudi richiesta',
        'Previous Owner' => 'Gestore precedente',
        'Inform Agent' => 'Informa Operatore',
        'Optional' => 'Opzionale',
        'Inform involved Agents' => 'Informa gli operatori coinvolti',
        'Attach' => 'Allega',
        'Next state' => 'Stato successivo',
        'Pending date' => 'In attesa fino a',
        'Time units' => 'Tempo',
        ' (work units)' => ' (unità di lavoro)',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Componi la risposta alla richiesta',
        'Pending Date' => 'Attesa fino a',
        'for pending* states' => 'per gli stati di attesa*',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Modifica il cliente della richiesta',
        'Set customer user and customer id of a ticket' => 'Imposta l\'id cliente di una richiesta',
        'Customer User' => 'Clienti',
        'Search Customer' => 'Ricerca cliente',
        'Customer Data' => 'Dati del cliente',
        'Customer history' => 'Storico del cliente',
        'All customer tickets.' => 'Tutte le richieste del cliente.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Risposta',

        # Template: AgentTicketEmail
        'Compose Email' => 'Componi email',
        'new ticket' => 'nuova richiesta',
        'Refresh' => '',
        'Clear To' => 'Cancella destinatario',

        # Template: AgentTicketForward
        'Article type' => 'Tipo articolo',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Cambia il testo della richiesta',

        # Template: AgentTicketHistory
        'History of' => 'Storico di',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Tickets' => 'Richieste',
        'of' => 'di',
        'Filter' => '',
        'New messages' => 'Nuovi messaggi',
        'Reminder' => 'Richiamo',
        'Sort by' => 'Ordina per',
        'Order' => 'Ordine',
        'up' => 'crescente',
        'down' => 'decrescente',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Unisci Richiesta',
        'Merge to' => 'Unisci a',

        # Template: AgentTicketMove
        'Move Ticket' => 'Sposta la richiesta',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Aggiungi una nota alla richiesta',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Assegna la richiesta ad un altro operatore',

        # Template: AgentTicketPending
        'Set Pending' => 'Imposta attesa',

        # Template: AgentTicketPhone
        'Phone call' => 'Chiamata telefonica',
        'Clear From' => 'Cancella il campo mittente',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => '',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Richiesta-Info',
        'Accounted time' => 'Tempo addebitato',
        'Escalation in' => '',
        'Linked-Object' => 'Oggetto Collegato',
        'Parent-Object' => 'Oggetto Genitore',
        'Child-Object' => 'Oggetto Figlio',
        'by' => 'da',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Modifica la priorità della richiesta',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Richieste mostrate',
        'Tickets available' => 'Richieste disponibili',
        'All tickets' => 'Richieste totali',
        'Queues' => 'Code',
        'Ticket escalation!' => 'Richiesta escalation!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => '',
        'Your own Ticket' => 'Le tue richieste',
        'Compose Follow up' => 'Componi risposta',
        'Compose Answer' => 'Componi risposta',
        'Contact customer' => 'Contatta il cliente',
        'Change queue' => 'Cambia coda',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => '',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Ricerca richiesta',
        'Profile' => 'Profilo',
        'Search-Template' => 'Modello di ricerca',
        'TicketFreeText' => 'Ricerca a testo libero nella richiesta',
        'Created in Queue' => 'Creata nella Coda',
        'Result Form' => 'Tipo di risultato',
        'Save Search-Profile as Template?' => 'Salvare il profilo di ricerca come modello',
        'Yes, save it with name' => 'Sì, salva con nome',

        # Template: AgentTicketSearchResult
        'Search Result' => 'Risultato ricerca',
        'Change search options' => 'Modifica le opzioni di ricerca',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort
        'U' => 'C',
        'D' => '',

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Visualizzazione Stato delle richieste',
        'Open Tickets' => 'Richieste Aperte',
        'Locked' => 'In gestione',

        # Template: AgentTicketZoom

        # Template: AgentWindowTab

        # Template: Calculator
        'Calculator' => '',
        'Operation' => '',

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Dettaglio del passato',

        # Template: CustomerFAQ

        # Template: CustomerFooter
        'Powered by' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Codice utente',
        'Lost your password?' => 'Hai dimenticato la password?',
        'Request new password' => 'Richiedi una nuova password',
        'Create Account' => 'Registrati',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Benvenuto/a %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Volte',
        'No time settings.' => 'Non ci sono impostazioni temporali.',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Clicca qui per segnalare un bug!',

        # Template: Footer
        'Top of Page' => 'Inizio Pagina',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Installazione guidata via web',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Utente amministratore',
        'Admin-Password' => '',
        'your MySQL DB should have a root password! Default is empty!' => 'dovresti impostare una password di root per il tuo server MySQL!',
        'Database-User' => '',
        'default \'hot\'' => '\'hot\' predefinito',
        'DB connect host' => '',
        'Database' => '',
        'false' => 'falso',
        'SystemID' => 'ID del sistema',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(ID del sistema. Ogni ID di sessione e numero di ticket inizia con questo numero)',
        'System FQDN' => 'FQDN del sistema',
        '(Full qualified domain name of your system)' => '(Nome di dominio completo (FQDN) del sistema)',
        'AdminEmail' => 'Messaggio agli operatori',
        '(Email of the system admin)' => '(Indirizzo email dell\'amministratore di sistema)',
        'Organization' => 'Azienda',
        'Log' => '',
        'LogModule' => 'Modulo di log',
        '(Used log backend)' => '(Modulo da usare per il log)',
        'Logfile' => 'File di log',
        '(Logfile just needed for File-LogModule!)' => '(File di log --- necessario solo per il log su file (File-LogModule))',
        'Webfrontend' => 'Interfaccia web',
        'Default Charset' => 'Set di caratteri predefinito',
        'Use utf-8 it your database supports it!' => '',
        'Default Language' => 'Lingua predefinita',
        '(Used default language)' => '(Lingua predefinita)',
        'CheckMXRecord' => 'Verifica record MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Controlla il record MX per i domini degli indirizzi email quando si compone un messaggio. Non usare se il vostro server con OTRS ha una connessione dial-up!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Per poter usare OTRS devi inserire questa riga di comando in una shell come utente root.',
        'Restart your webserver' => 'Riavvia il tuo server web',
        'After doing so your OTRS is up and running.' => 'Dopo di ciò OTRS sarà pronto all\'uso.',
        'Start page' => 'Pagina iniziale',
        'Have a lot of fun!' => 'Divertiti con OTRS!',
        'Your OTRS Team' => 'Gruppo di sviluppo di OTRS',

        # Template: Login
        'Welcome to %s' => 'Benvenuto in %s',

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Autorizzazione negata',

        # Template: Notify
        'Important' => 'Importante',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'stampato da',

        # Template: PublicFAQ

        # Template: PublicView
        'Management Summary' => '',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Pagina di test OTRS',
        'Counter' => '',

        # Template: Warning
        # Misc
        'Create Database' => 'Crea database ',
        'Ticket Number Generator' => 'Generatore numero ticket',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Prefisso per il numero di ticket --- es. "N.ro Ticket:" o "Ticket#" ecc.)',
        'Create new Phone Ticket' => 'Crea una nuova richiesta in seguito ad una chiamata telefonica',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'In questo modo puoi modificare direttamente il \'keyring\' configurato nel file Kernel/Config.pm',
        'Symptom' => 'Sintomi',
        'A message should have a To: recipient!' => 'Manca il destinatario del messaggio!',
        'Site' => 'Pagina',
        'Customer history search (e. g. "ID342425").' => 'Ricerca storico cliente (per es. "ID342425")',
        'for agent firstname' => 'per il nome dell\'operatore',
        'Close!' => 'Chiuso!',
        'The message being composed has been closed.  Exiting.' => 'La finestra con il messaggio che si stava componendo è stata chiusa. Sto uscendo.',
        'A web calendar' => 'Calendario web',
        'to get the realname of the sender (if given)' => 'per avere il nome completo del mittente (se indicato)',
        'Select Source (for add)' => 'Seleziona sorgente (da aggiungere)',
        'Days' => 'Giorni',
        'Queue ID' => 'Identificativo coda',
        'Home' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Opzioni di configurazione (per es. <OTRS_CONFIG_HttpType>)',
        'System History' => 'Storico del sistema',
        'customer realname' => 'nome del cliente',
        'First Response' => '',
        'Pending messages' => 'Messaggi in attesa',
        'Modules' => 'Moduli',
        'for agent login' => 'per il nome utente dell\'operatore',
        'Keyword' => 'Parola chiave',
        'Close type' => 'Tipologia chiusura',
        'DB Admin User' => 'Nome utente DB Admin',
        'for agent user id' => 'per l\'id utente dell\'operatore',
        'sort upward' => 'ordine crescente',
        'Change user <-> group settings' => 'Modifica impostazioni Utente <-> Gruppo',
        'Problem' => 'Problema',
        'next step' => 'Fase successiva',
        'Customer history search' => 'Ricerca storico cliente',
        'Admin-Email' => 'Invia messaggio agli operatori',
        'Create new database' => 'Crea un nuovo database',
        'A message must be spell checked!' => 'Il messaggio necessita di correzione ortografica!',
        'ArticleID' => 'Codice articolo',
        'All Agents' => 'Tutti gli operatori',
        'Keywords' => 'Parole chiave',
        'No * possible!' => 'Qui non è possibile usare l\'asterisco (*)!',
        'Options ' => '',
        'Message for new Owner' => 'Messaggio per l\'operatore',
        'to get the first 5 lines of the email' => 'per avere le prime 5 linee del messaggio',
        'Last update' => 'Ultimo aggiornamento',
        'to get the first 20 character of the subject' => 'per avere i primi 20 caratteri dell\'oggetto',
        'DB Admin Password' => 'Password del DB Admin',
        'Advisory' => 'Avviso',
        'Drop Database' => 'Cancella database',
        'FileManager' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Per ottenere i dati del cliente (per es. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Tipo di attesa',
        'Comment (internal)' => 'Commento (interno)',
        'This window must be called from compose window' => 'Questa finestra deve essere aperta dalla finestra di composizione dei mesaggi',
        'Minutes' => 'Minuti',
        'You need min. one selected Ticket!' => 'Devi selezionare almeno una richiesta!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        '(Used ticket number format)' => '(Formato del numero dei ticket)',
        'Fulltext' => 'Testo libero',
        'Incident' => 'Incidente',
        'All Agent variables.' => '',
        'All Customer variables like defined in config option CustomerUser.' => 'Tutte le variabili del cliente come definite nella configurazione',
        'accept license' => 'accetto la licenza',
        'for agent lastname' => 'per il cognome dell\'operatore',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Per ottenere l\'utente che ha richiesto l\'azione (per es. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Messaggio di richiamo',
        'Ticket Hook' => 'Prefisso richieste',
        'TicketZoom' => 'DettagliRichiesta',
        'Don\'t forget to add a new user to groups!' => 'Non dimenticare di aggiungere i nuovi operatori ad un gruppo!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'È necessario inserire un indirizzo email (per .es. cliente@esempio.it) come destinatario!',
        'CreateTicket' => 'CreaRichiesta',
        'System Settings' => 'Impostazioni di sistema',
        'WebWatcher' => '',
        'Hours' => 'Ore',
        'Finished' => 'Operazione terminata',
        'Split' => 'Spezza',
        'All messages' => 'Tutti i messaggi',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Artefact' => 'Artefatto',
        'A article should have a title!' => 'Manca il titolo!',
        'don\'t accept license' => 'non accetto la licenza',
        'A web mail client' => 'Un client di web mail',
        'WebMail' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Per ottenere il gestore della richiesta (per es. <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => 'Manca il nome!',
        'DB Type' => 'Tipo di DBMS',
        'Termin1' => '',
        'kill all sessions' => 'Termina tutte le sessioni',
        'to get the from line of the email' => 'per avere il mittente del messaggio',
        'Solution' => 'Soluzione',
        'QueueView' => 'Lista Richieste',
        'Welcome to OTRS' => '',
        'modified' => 'modificato',
        'Delete old database' => 'Cancella il vecchio database',
        'sort downward' => 'ordine decrescente',
        'You need to use a ticket number!' => 'Devi usare un numero di richiesta',
        'A web file manager' => 'Un gestore dei file via web',
        'send' => 'invia',
        'Note Text' => 'Nota',
        'System State Management' => 'Gestione stati richieste',
        'PhoneView' => 'RichiestaTelefonica',
        'maximal period form' => '',
        'Verion' => 'Versione',
        'TicketID' => 'Codice richiesta',
        'Modified' => 'Modificato',
        'Ticket selected for bulk action!' => 'Richiesta selezionata per azione di massa!',
    };
    # $$STOP$$
}

1;
