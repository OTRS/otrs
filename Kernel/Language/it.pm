# --
# Copyright (C) 2003,2008 Remo Catelotti <Remo.Catelotti at eutelia.it>
# Copyright (C) 2003 Gabriele Santilli <gsantilli at omnibus.net>
# Copyright (C) 2005,2009 Giordano Bianchi <giordano.bianchi at gmail.com>
# Copyright (C) 2009 Remo Catelotti <Remo.Catelotti at agilesistemi.com>
# Copyright (C) 2009 Emiliano Coletti <e.coletti at gmail.com>
# Copyright (C) 2009 Alessandro Faraldi <faraldia at gmail.com>
# Copyright (C) 2010 Alessandro Grassi <alessandro.grassi at devise.it>
# Copyright (C) 2012,2013 Massimo Bianchi <mxbianchi at tiscali.it>
# Copyright (C) 2013 Luca Maranzano <liuk@linux.it>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::it;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %Y %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.665386461833893;

    # csv separator
    $Self->{Separator} = '';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Sì',
        'No' => 'No',
        'yes' => 'sì',
        'no' => 'no',
        'Off' => 'Spento',
        'off' => 'spento',
        'On' => 'Acceso',
        'on' => 'acceso',
        'top' => 'inizio pagina',
        'end' => 'fine pagina',
        'Done' => 'Fatto',
        'Cancel' => 'Annulla',
        'Reset' => 'Ripristina',
        'more than ... ago' => 'più di ...',
        'in more than ...' => 'in più di ...',
        'within the last ...' => 'negli ultimi ... ',
        'within the next ...' => 'nei prossimi ... ',
        'Created within the last' => 'Creato negli ultimi',
        'Created more than ... ago' => 'Creato più di ... fa',
        'Today' => 'Oggi',
        'Tomorrow' => 'Domani',
        'Next week' => 'Settimana prossima',
        'day' => 'giorno',
        'days' => 'giorni',
        'day(s)' => 'giorno(i)',
        'd' => 'g',
        'hour' => 'ora',
        'hours' => 'ore',
        'hour(s)' => 'ora(e)',
        'Hours' => 'Ore',
        'h' => 'h',
        'minute' => 'minuto',
        'minutes' => 'minuti',
        'minute(s)' => 'minuto(i)',
        'Minutes' => 'Minuti',
        'm' => 'm',
        'month' => 'mese',
        'months' => 'mesi',
        'month(s)' => 'mese(i)',
        'week' => 'settimana',
        'week(s)' => 'settimana(e)',
        'quarter' => 'trimestre',
        'quarter(s)' => 'trimestre(i)',
        'half-year' => 'semestre',
        'half-year(s)' => 'semestre(i)',
        'year' => 'anno',
        'years' => 'anni',
        'year(s)' => 'anno(i)',
        'second(s)' => 'secondo(i)',
        'seconds' => 'secondi',
        'second' => 'secondo',
        's' => 's',
        'Time unit' => 'Unità di tempo',
        'wrote' => 'ha scritto',
        'Message' => 'Messaggio',
        'Error' => 'Errore',
        'Bug Report' => 'Segnala anomalie',
        'Attention' => 'Attenzione',
        'Warning' => 'Attenzione',
        'Module' => 'Modulo',
        'Modulefile' => 'Archivio del modulo',
        'Subfunction' => 'Sottofunzione',
        'Line' => 'Linea',
        'Setting' => 'Impostazione',
        'Settings' => 'Impostazioni',
        'Example' => 'Esempio',
        'Examples' => 'Esempi',
        'valid' => 'valido',
        'Valid' => 'Valido',
        'invalid' => 'non valido',
        'Invalid' => 'Non valido',
        '* invalid' => '* non valido',
        'invalid-temporarily' => 'non valido-temporaneamente',
        ' 2 minutes' => ' 2 minuti',
        ' 5 minutes' => ' 5 minuti',
        ' 7 minutes' => ' 7 minuti',
        '10 minutes' => '10 minuti',
        '15 minutes' => '15 minuti',
        'Mr.' => 'Sig',
        'Mrs.' => 'Sig.ra',
        'Next' => 'Successivo',
        'Back' => 'Precedente',
        'Next...' => 'Successivo...',
        '...Back' => '...Precedente',
        '-none-' => '-nessuno-',
        'none' => 'nessuno',
        'none!' => 'nessuno!',
        'none - answered' => 'nessuna - risposta',
        'please do not edit!' => 'non modificare!',
        'Need Action' => 'Azione richiesta',
        'AddLink' => 'Aggiungi collegamento',
        'Link' => 'Collega',
        'Unlink' => 'Rimuovi collegamento',
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
        'Standard' => 'Standard',
        'Lite' => 'Ridotta',
        'User' => 'Utente',
        'Username' => 'Nome utente',
        'Language' => 'Lingua',
        'Languages' => 'Lingue',
        'Password' => 'Password',
        'Preferences' => 'Preferenze',
        'Salutation' => 'Titolo',
        'Salutations' => 'Titolo',
        'Signature' => 'Firma',
        'Signatures' => 'Firme',
        'Customer' => 'Cliente',
        'CustomerID' => 'Codice cliente',
        'CustomerIDs' => 'Codici cliente',
        'customer' => 'cliente',
        'agent' => 'operatore',
        'system' => 'sistema',
        'Customer Info' => 'Informazioni cliente',
        'Customer Information' => 'Informazioni cliente',
        'Customer Companies' => 'Aziende dei clienti',
        'Company' => 'Azienda',
        'go!' => 'vai!',
        'go' => 'vai',
        'All' => 'Tutti',
        'all' => 'tutti',
        'Sorry' => 'Spiacente',
        'update!' => 'aggiorna!',
        'update' => 'aggiorna',
        'Update' => 'Aggiorna',
        'Updated!' => 'Aggiornato!',
        'submit!' => 'invia!',
        'submit' => 'invia',
        'Submit' => 'Invia',
        'change!' => 'modifica!',
        'Change' => 'Modifica',
        'change' => 'modifica',
        'click here' => 'fai clic qui',
        'Comment' => 'Commento',
        'Invalid Option!' => 'Opzione non valida!',
        'Invalid time!' => 'Ora non valida!',
        'Invalid date!' => 'Data non valida!',
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
        'before/after' => 'prima/dopo',
        'Fulltext Search' => 'Ricerca testo intero',
        'Data' => 'Dati',
        'Options' => 'Opzioni',
        'Title' => 'Titolo',
        'Item' => 'Elemento',
        'Delete' => 'Elimina',
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
        'Added!' => 'Aggiunto',
        'Category' => 'Categoria',
        'Viewer' => 'Visualizzatore',
        'Expand' => 'Espandi',
        'Small' => 'Piccolo',
        'Medium' => 'Medio',
        'Large' => 'Grande',
        'Date picker' => 'Selettore data',
        'Show Tree Selection' => 'Mostra la selezione ad albero',
        'The field content is too long!' => 'Il contenuto del campo è troppo lungo!',
        'Maximum size is %s characters.' => 'La dimensione massima è di %s caratteri.',
        'This field is required or' => 'Questo campo è obbligatorio oppure ',
        'New message' => 'Nuovo messaggio',
        'New message!' => 'Nuovo messaggio!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Rispondi a queste richieste prima di tornare alla lista!',
        'You have %s new message(s)!' => 'Hai %s nuovi messaggi!',
        'You have %s reminder ticket(s)!' => 'Hai %s promemoria memorizzati',
        'The recommended charset for your language is %s!' => 'Il set di caratteri consigliato per la tua lingua è %s!',
        'Change your password.' => 'Cambia la tua password.',
        'Please activate %s first!' => 'Attiva prima %s!',
        'No suggestions' => 'Non ci sono suggerimenti',
        'Word' => 'Parola',
        'Ignore' => 'Ignora',
        'replace with' => 'sostituisci con',
        'There is no account with that login name.' => 'Nome utente non valido.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Accesso non riuscito! Il nome utente o la password sono errati.',
        'There is no acount with that user name.' => 'Non esistono account con questo nome utente.',
        'Please contact your administrator' => 'Contatta il tuo amministratore',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Autenticazione riuscita, ma non è possibile trovare informazioni relative al cliente. Contatta il tuo amministratore di sistema.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'L\'indirizzo email inserito esiste già. Effettuare l\'accesso o reimposta la password.',
        'Logout' => 'Esci',
        'Logout successful. Thank you for using %s!' => 'Disconnessione avvenuta con successo. Grazie per aver usato %s!',
        'Feature not active!' => 'Funzione non attiva!',
        'Agent updated!' => 'Agente aggiornato!',
        'Database Selection' => 'Selezione database',
        'Create Database' => 'Crea database',
        'System Settings' => 'Impostazioni di sistema',
        'Mail Configuration' => 'Configurazione della posta',
        'Finished' => 'Operazione terminata',
        'Install OTRS' => 'Installa OTRS',
        'Intro' => 'Introduzione',
        'License' => 'Licenza',
        'Database' => 'Database',
        'Configure Mail' => 'Configurazione posta',
        'Database deleted.' => 'Database eliminato.',
        'Enter the password for the administrative database user.' => 'Inserisci la password per l\'utente amministrativo del database',
        'Enter the password for the database user.' => 'Inserisci la password per l\'utente del database',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Se hai impostato una password di root per il database inseriscila qui, altrimenti lascia il campo vuoto.',
        'Database already contains data - it should be empty!' => 'Il database risulta contenere dati - dovrebbe essere vuoto!',
        'Login is needed!' => 'Devi effettuare l\'accesso!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Al momento non è possibile accedere al sistema per attività di manutenzione in corso.',
        'Password is needed!' => 'La password è richiesta',
        'Take this Customer' => 'Prendi questo cliente',
        'Take this User' => 'Prendi questo utente',
        'possible' => 'possibile',
        'reject' => 'rifiuta',
        'reverse' => 'inverti',
        'Facility' => 'Funzione',
        'Time Zone' => 'Fuso orario',
        'Pending till' => 'In attesa fino a',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Non usare l\'account di superutente per lavorare con OTRS. Crea nuovi agenti e lavora con questi account.',
        'Dispatching by email To: field.' => 'Smistamento in base al campo A:.',
        'Dispatching by selected Queue.' => 'Smistamento in base alla coda selezionata.',
        'No entry found!' => 'Nessun elemento trovato!',
        'Session invalid. Please log in again.' => 'Sessione non valida. Effettua di nuovo l\'accesso.',
        'Session has timed out. Please log in again.' => 'Sessione scaduta per inattività. Effettua di nuovo l\'accesso.',
        'Session limit reached! Please try again later.' => 'Numero massimo di sessioni raggiunto. Per favore, riprovare più tardi.',
        'No Permission!' => 'Permessi insufficienti!',
        '(Click here to add)' => '(Fai clic qui per aggiungere)',
        'Preview' => 'Anteprima',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Estensione non installata correttamente! Reinstalla il pacchetto!',
        '%s is not writable!' => '%s non è scrivibile!',
        'Cannot create %s!' => 'Impossibile creare %s!',
        'Check to activate this date' => 'Seleziona per attivare questa data',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Risposta automatica abilitata. Vuoi disabilitarla?',
        'News about OTRS releases!' => 'Novità sui rilasci di OTRS!',
        'Customer %s added' => 'Cliente %s aggiunto',
        'Role added!' => 'Ruolo aggiunto!',
        'Role updated!' => 'Ruolo aggiornato!',
        'Attachment added!' => 'Allegato aggiunto!',
        'Attachment updated!' => 'Allegato aggiornato!',
        'Response added!' => 'Risposta aggiunta!',
        'Response updated!' => 'Risposta aggiornata!',
        'Group updated!' => 'Gruppo aggiornato!',
        'Queue added!' => 'Coda aggiunta!',
        'Queue updated!' => 'Coda aggiornata!',
        'State added!' => 'Stato aggiunto!',
        'State updated!' => 'Stato aggiornato!',
        'Type added!' => 'Tipo aggiunto!',
        'Type updated!' => 'Tipo aggiornato!',
        'Customer updated!' => 'Cliente aggiornato!',
        'Customer company added!' => 'Azienda del cliente aggiunta!',
        'Customer company updated!' => 'Azienda del cliente aggiornata!',
        'Note: Company is invalid!' => 'Nota: l\'azienda non è valida!',
        'Mail account added!' => 'Account di posta aggiunto!',
        'Mail account updated!' => 'Account di posta aggiornato!',
        'System e-mail address added!' => 'Account di posta di sistema aggiunto!',
        'System e-mail address updated!' => 'Account di posta di sistema aggiornato!',
        'Contract' => 'Contratto',
        'Online Customer: %s' => 'Clienti collegati: %s',
        'Online Agent: %s' => 'Operatori collegati: %s',
        'Calendar' => 'Calendario',
        'File' => 'File',
        'Filename' => 'Nome file',
        'Type' => 'Tipo',
        'Size' => 'Dimensione',
        'Upload' => 'Caricamento',
        'Directory' => 'Cartella',
        'Signed' => 'Firmato',
        'Sign' => 'Firma',
        'Crypted' => 'Cifrato',
        'Crypt' => 'Cifra',
        'PGP' => 'PGP',
        'PGP Key' => 'Chiave PGP',
        'PGP Keys' => 'Chiavi PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certificato S/MIME',
        'S/MIME Certificates' => 'Certificati S/MIME',
        'Office' => 'Ufficio',
        'Phone' => 'Telefono',
        'Fax' => 'Fax',
        'Mobile' => 'Cellulare',
        'Zip' => 'CAP',
        'City' => 'Città',
        'Street' => 'Via',
        'Country' => 'Stato',
        'Location' => 'Sede',
        'installed' => 'Installato',
        'uninstalled' => 'disinstallato',
        'Security Note: You should activate %s because application is already running!' =>
            'Nota di sicurezza: dovresti attivare %s perché l\'applicazione è già in esecuzione!',
        'Unable to parse repository index document.' => 'Impossibile analizzare l\'indice dei repository.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Non esistono pacchetti per la vostra versione del framework in questo repository, ne sono contenuti solo per altre versioni.',
        'No packages, or no new packages, found in selected repository.' =>
            'Nessun pacchetto, o nessun pacchetto nuovo è stato trovato nel repository selezionato.',
        'Edit the system configuration settings.' => 'Modifica le impostazioni di sistema.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Le ACL dal database non sono allineate con la configurazione di sistema, effettua il rilascio di tutte le ACL.',
        'printed at' => 'stampato il',
        'Loading...' => 'Caricamento in corso...',
        'Dear Mr. %s,' => 'Egr. Sig. %s,',
        'Dear Mrs. %s,' => 'Gent.ma Sig.ra %s,',
        'Dear %s,' => 'Egr. %s,',
        'Hello %s,' => 'Salve %s ,',
        'This email address is not allowed to register. Please contact support staff.' =>
            'L\'indirizzo email inserito non è abilitato per la registrazione. Contatta il supporto tecnico.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nuovo account creato. Le informazioni di accesso sono state inviate a %s. Controlla l\'email.',
        'Please press Back and try again.' => 'Premi Indietro e riprova.',
        'Sent password reset instructions. Please check your email.' => 'Inviate le istruzioni per il ripristino della password. Controlla l\'email.',
        'Sent new password to %s. Please check your email.' => 'Nuova password inviata a %s. Controlla l\'email.',
        'Upcoming Events' => 'Eventi prossimi',
        'Event' => 'Evento',
        'Events' => 'Eventi',
        'Invalid Token!' => 'Token non valido!',
        'more' => 'altro',
        'Collapse' => 'Contrai',
        'Shown' => 'Mostrati',
        'Shown customer users' => 'Clienti mostrati',
        'News' => 'Notizie',
        'Product News' => 'Notizie sul prodotto',
        'OTRS News' => 'Notizie OTRS',
        '7 Day Stats' => 'Statistiche ultimi 7 Giorni',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Le informazioni di Process Management del database non sono sincronizzate con la configurazione di sistema, sincronizza tutti i processi.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Pacchetto non verificato da OTRS! Si consiglia di non utilizzarlo.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>Se prosegui con l\'installazione di questo pacchetto, si potrebbero verificare le seguenti problematiche!<br><br>&nbsp;-Problemi di sicurezza<br>&nbsp;-Problemi di stabilità<br>&nbsp;-Problemi prestazionali<br><br>Eventuali problemi derivanti dall\'uso di questo pacchetto non sono coperti dai contratti di servizio di OTRS!<br><br>',
        'Mark' => 'Seleziona',
        'Unmark' => 'Deseleziona',
        'Bold' => 'Grassetto',
        'Italic' => 'Corsivo',
        'Underline' => 'Sottolinea',
        'Font Color' => 'Colore carattere',
        'Background Color' => 'Colore sfondo',
        'Remove Formatting' => 'Rimuovi formattazione',
        'Show/Hide Hidden Elements' => 'Mostra/Nascondi elementi nascosti',
        'Align Left' => 'Allinea a sinistra',
        'Align Center' => 'Allinea al centro',
        'Align Right' => 'Allinea a destra',
        'Justify' => 'Giustifica',
        'Header' => 'Intestazione',
        'Indent' => 'Rientro',
        'Outdent' => 'Rimuovi rientro',
        'Create an Unordered List' => 'Crea un elenco non ordinato',
        'Create an Ordered List' => 'Crea un elenco ordinato',
        'HTML Link' => 'Collegamento HTML',
        'Insert Image' => 'Inserisci immagine',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Annulla',
        'Redo' => 'Rifai',
        'OTRS Daemon is not running.' => 'Il demone OTRS non è in esecuzione.',
        'Can\'t contact registration server. Please try again later.' => 'Impossibile contattare il server per la registrazione. Riprova più tardi.',
        'No content received from registration server. Please try again later.' =>
            'Nessun dato ricevuto dal server per la registrazione. Riprova più tardi.',
        'Problems processing server result. Please try again later.' => 'Si sono verificati problemi elaborando la risposta del server. Riprova più tardi.',
        'Username and password do not match. Please try again.' => 'Il nome utente e la password non corrispondono. Prova ancora.',
        'The selected process is invalid!' => 'Il processo selezionato non è valido!',
        'Upgrade to %s now!' => 'Aggiorna a %s subito!',
        '%s Go to the upgrade center %s' => '%s Vai al centro aggiornamento %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'La tua licenza %s sta per scadere. Contatta %s per rinnovare il tuo contratto.',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'È disponibile un aggiornamento per te %s, ma è in conflitto con la versione del framework! Aggiorna prima il tuo framework!',
        'Your system was successfully upgraded to %s.' => 'Il tuo sistema è stato aggiornato correttamente a %s.',
        'There was a problem during the upgrade to %s.' => 'Si è verificato un problema durante l\'aggiornamento a %s.',
        '%s was correctly reinstalled.' => '%s è stato reinstallato correttamente.',
        'There was a problem reinstalling %s.' => 'Si è verificato un problema durante la reinstallazione di %s.',
        'Your %s was successfully updated.' => 'Il tuo %s è stato aggiornato correttamente.',
        'There was a problem during the upgrade of %s.' => 'Si è verificato un problema durante l\'aggiornamento di %s.',
        '%s was correctly uninstalled.' => '%s è stato correttamente disinstallato.',
        'There was a problem uninstalling %s.' => 'Si è verificato un problema durante la disinstallazione di %s.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Capodanno',
        'International Workers\' Day' => 'Festa dei lavoratori',
        'Christmas Eve' => 'Vigilia di Natale',
        'First Christmas Day' => 'Natale',
        'Second Christmas Day' => 'Santo Stefano',
        'New Year\'s Eve' => 'Vigilia di Capodanno',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS come richiedente',
        'OTRS as provider' => 'OTRS come fornitore',
        'Webservice "%s" created!' => 'Web service "%s" creato!',
        'Webservice "%s" updated!' => 'Web service "%s" aggiornato!',

        # Template: AAAMonth
        'Jan' => 'Gen',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Apr',
        'May' => 'Mag',
        'Jun' => 'Giu',
        'Jul' => 'Lug',
        'Aug' => 'Ago',
        'Sep' => 'Set',
        'Oct' => 'Ott',
        'Nov' => 'Nov',
        'Dec' => 'Dic',
        'January' => 'Gennaio',
        'February' => 'Febbraio',
        'March' => 'Marzo',
        'April' => 'Aprile',
        'May_long' => 'Maggio',
        'June' => 'Giugno',
        'July' => 'Luglio',
        'August' => 'Agosto',
        'September' => 'Settembre',
        'October' => 'Ottobre',
        'November' => 'Novembre',
        'December' => 'Dicembre',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Preferenze modificate con successo!',
        'User Profile' => 'Profilo utente',
        'Email Settings' => 'Impostazioni email',
        'Other Settings' => 'Altre impostazioni',
        'Notification Settings' => 'Impostazioni delle notifiche',
        'Change Password' => 'Cambia password',
        'Current password' => 'Password attuale',
        'New password' => 'Nuova password',
        'Verify password' => 'Verifica password',
        'Spelling Dictionary' => 'Dizionario',
        'Default spelling dictionary' => 'Dizionario predefinito',
        'Max. shown Tickets a page in Overview.' => 'Numero massimo di richieste per pagina nel Sommario',
        'The current password is not correct. Please try again!' => 'La password corrente è errata. Riprova!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Impossibile aggiornare la password, le password nuove non corrispondono. Riprova!',
        'Can\'t update password, it contains invalid characters!' => 'Impossibile aggiornare la password, contiene caratteri non validi!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Impossibile aggiornare la password, deve essere lunga almeno %s caratteri!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Impossibile aggiornare la password, deve contenere almeno due lettere minuscole e due maiuscole!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Impossibile aggiornare la password, deve contenere almeno un numero!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Impossibile aggiornare la password, deve contenere almeno due caratteri!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Impossibile aggiornare la password, questa password è stata già usata. Scegline un\'altra!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Seleziona il carattere di separazione usato nei file CSV (statistiche e ricerca). Se non selezioni un separatore, sarà usato il separatore predefinito per la tua lingua.',
        'CSV Separator' => 'Separatore CSV',

        # Template: AAATicket
        'Status View' => 'Visualizzazione stato',
        'Service View' => 'Visualizzazione servizio',
        'Bulk' => 'Aggiornamento multiplo',
        'Lock' => 'Blocca',
        'Unlock' => 'Rilascia',
        'History' => 'Storico',
        'Zoom' => 'Dettagli',
        'Age' => 'Tempo trascorso',
        'Bounce' => 'Rispedisci',
        'Forward' => 'Inoltra',
        'From' => 'Da',
        'To' => 'A',
        'Cc' => 'Cc',
        'Bcc' => 'Ccn',
        'Subject' => 'Oggetto',
        'Move' => 'Sposta',
        'Queue' => 'Coda',
        'Queues' => 'Code',
        'Priority' => 'Priorità',
        'Priorities' => 'Priorità',
        'Priority Update' => 'Aggiornamento priorità',
        'Priority added!' => 'Priorità aggiunta!',
        'Priority updated!' => 'Priorità aggiornata!',
        'Signature added!' => 'Firma aggiunta!',
        'Signature updated!' => 'Firma aggiornata!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Accordo sul livello di servizio',
        'Service Level Agreements' => 'Accordi sul livello di servizio',
        'Service' => 'Servizio',
        'Services' => 'Servizi',
        'State' => 'Stato',
        'States' => 'Stati',
        'Status' => 'Stato',
        'Statuses' => 'Stati',
        'Ticket Type' => 'Tipo ticket',
        'Ticket Types' => 'Tipi ticket',
        'Compose' => 'Componi',
        'Pending' => 'In attesa',
        'Owner' => 'Operatore',
        'Owner Update' => 'Aggiornamento operatore',
        'Responsible' => 'Responsabile',
        'Responsible Update' => 'Aggiornamento responsabile',
        'Sender' => 'Mittente',
        'Article' => 'Articolo',
        'Ticket' => 'Ticket',
        'Createtime' => 'Istante di creazione',
        'plain' => 'non formattato',
        'Email' => 'Email',
        'email' => 'email',
        'Close' => 'Chiudi',
        'Action' => 'Azione',
        'Attachment' => 'Allegato',
        'Attachments' => 'Allegati',
        'This message was written in a character set other than your own.' =>
            'Questo messaggio è stato scritto con un insieme di caratteri diverso dal tuo.',
        'If it is not displayed correctly,' => 'Se non è visualizzato correttamente,',
        'This is a' => 'Questo è un',
        'to open it in a new window.' => 'per aprire in una nuova finestra.',
        'This is a HTML email. Click here to show it.' => 'Questa è una email in HTML. Fai clic qui per visualizzarla.',
        'Free Fields' => 'Campi liberi',
        'Merge' => 'Unisci',
        'merged' => 'unito',
        'closed successful' => 'chiuso con successo',
        'closed unsuccessful' => 'chiuso senza successo',
        'Locked Tickets Total' => 'Totale ticket presi in carico',
        'Locked Tickets Reminder Reached' => 'Ticket presi in carico con promemoria raggiunto',
        'Locked Tickets New' => 'Nuovi ticket presi in carico',
        'Responsible Tickets Total' => 'Totale ticket responsabili',
        'Responsible Tickets New' => 'Nuovi ticket responsabili',
        'Responsible Tickets Reminder Reached' => 'Ticket responsabili con promemoria raggiunto',
        'Watched Tickets Total' => 'Totale ticket osservati',
        'Watched Tickets New' => 'Nuovi ticket osservati',
        'Watched Tickets Reminder Reached' => 'Ticket osservati con promemoria raggiunto',
        'All tickets' => 'Tutti i ticket',
        'Available tickets' => 'Ticket senza operatore assegnato',
        'Escalation' => '',
        'last-search' => 'Ultima ricerca',
        'QueueView' => 'Vista della coda',
        'Ticket Escalation View' => 'Vista gestione Ticket',
        'Message from' => 'Messaggio da',
        'End message' => 'Fine messaggio',
        'Forwarded message from' => 'Messaggio inoltrato da',
        'End forwarded message' => 'Fine messaggio inoltrato',
        'Bounce Article to a different mail address' => 'Reinvia l\'articolo a un indirizzo di posta diverso',
        'Reply to note' => 'Rispondere alla nota',
        'new' => 'nuovo',
        'open' => 'aperto',
        'Open' => 'aperto',
        'Open tickets' => 'Ticket aperti',
        'closed' => 'chiuso',
        'Closed' => 'Chiuso',
        'Closed tickets' => 'Ticket chiusi',
        'removed' => 'rimosso',
        'pending reminder' => 'in attesa di promemoria',
        'pending auto' => 'in attesa di chiusura automatica',
        'pending auto close+' => 'in attesa di chiusura automatica+',
        'pending auto close-' => 'in attesa di chiusura automatica-',
        'email-external' => 'Email esterna',
        'email-internal' => 'Email interna',
        'note-external' => 'Nota esterna',
        'note-internal' => 'Nota interna',
        'note-report' => 'Nota rapporto',
        'phone' => 'telefono',
        'sms' => 'SMS',
        'webrequest' => 'richiesta da web',
        'lock' => 'blocca',
        'unlock' => 'sblocca',
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
        'auto follow up' => 'follow up automatico',
        'auto reject' => 'rifiuto automatico',
        'auto remove' => 'rimozione automatica',
        'auto reply' => 'risposta automatica',
        'auto reply/new ticket' => 'risposta automatica con creazione nuovo ticket',
        'Create' => 'Crea',
        'Answer' => 'Rispondi',
        'Phone call' => 'Chiamata telefonica',
        'Ticket "%s" created!' => 'Ticket "%s" creato!',
        'Ticket Number' => 'Numero ticket',
        'Ticket Object' => 'Oggetto ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Numero ticket "%s" non presente! Collegamento impossibile!',
        'You don\'t have write access to this ticket.' => 'Non hai accesso in modifica a questo ticket',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Spiacente, devi essere il proprietario del ticket per effettuare questa operazione.',
        'Please change the owner first.' => 'Prima è necessario cambiare l\'operatore assegnato.',
        'Ticket selected.' => 'Ticket selezionato.',
        'Ticket is locked by another agent.' => 'Il ticket è assegnato a un altro operatore',
        'Ticket locked.' => 'Ticket assegnato.',
        'Don\'t show closed Tickets' => 'Non mostrare i ticket chiusi',
        'Show closed Tickets' => 'Mostra i ticket chiusi',
        'New Article' => 'Nuovo articolo',
        'Unread article(s) available' => 'Articoli non letti disponibili',
        'Remove from list of watched tickets' => 'Rimuovere dalla lista di ticket osservati',
        'Add to list of watched tickets' => 'Aggiungere alla lista di ticket osservati',
        'Email-Ticket' => 'Ticket via email',
        'Create new Email Ticket' => 'Crea un nuovo ticket via email',
        'Phone-Ticket' => 'Ticket telefonico',
        'Search Tickets' => 'Ricerca ticket',
        'Customer Realname' => 'Nome reale cliente',
        'Customer History' => 'Storico utente',
        'Edit Customer Users' => 'Modifica utenti clienti',
        'Edit Customer' => 'Modifica cliente',
        'Bulk Action' => 'Operazioni multiple',
        'Bulk Actions on Tickets' => 'Operazione multipla sulle richieste',
        'Send Email and create a new Ticket' => 'Invia un\'email e crea un nuovo ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Crea un nuovo ticket via email e invialo (outbound)',
        'Create new Phone Ticket (Inbound)' => 'Crea un nuovo ticket da telefonata',
        'Address %s replaced with registered customer address.' => 'L\'indirizzo %s è stato sostituito con l\'indirizzo registrato del cliente',
        'Customer user automatically added in Cc.' => 'L\'utente del cliente è stato automaticamente aggiunto in Cc.',
        'Overview of all open Tickets' => 'Vista globale di tutte le richieste aperte',
        'Locked Tickets' => 'Richieste in gestione',
        'My Locked Tickets' => 'Miei ticket presi in carico',
        'My Watched Tickets' => 'Miei ticket osservati',
        'My Responsible Tickets' => 'Miei ticket di cui sono il responsabile',
        'Watched Tickets' => 'Ticket osservati',
        'Watched' => 'Osservati',
        'Watch' => 'Osserva',
        'Unwatch' => 'Non osservare',
        'Lock it to work on it' => 'Bloccalo per lavorarlo',
        'Unlock to give it back to the queue' => 'Sbloccalo per rimetterlo nella coda',
        'Show the ticket history' => 'Mostra lo storico del ticket',
        'Print this ticket' => 'Stampa questo ticket',
        'Print this article' => 'Stampa questo articolo',
        'Split' => 'Dividi',
        'Split this article' => 'Dividi questo articolo',
        'Forward article via mail' => 'Inoltra l\'articolo via email',
        'Change the ticket priority' => 'Cambia la priorità al ticket',
        'Change the ticket free fields!' => 'Cambia i campi liberi del ticket!',
        'Link this ticket to other objects' => 'Collega questo ticket ad un altro oggetto',
        'Change the owner for this ticket' => 'Cambia operatore per questo ticket',
        'Change the  customer for this ticket' => 'Cambia il cliente per questo ticket',
        'Add a note to this ticket' => 'Aggiungi una nota a questo ticket',
        'Merge into a different ticket' => 'Unisci a un altro ticket',
        'Set this ticket to pending' => 'Metti questo ticket in attesa',
        'Close this ticket' => 'Chiudi questo ticket',
        'Look into a ticket!' => 'Visualizza un ticket!',
        'Delete this ticket' => 'Elimina questo ticket',
        'Mark as Spam!' => 'Segnala come spam',
        'My Queues' => 'Le mie code',
        'Shown Tickets' => 'Ticket visualizzati',
        'Shown Columns' => 'Mostra colonne',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'La tua email con il numero di ticket "<OTRS_TICKET>" è stata unita a "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: Prima risposta scaduta (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: Prima risposta scade dopo %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: aggiornamento scade dopo %s!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: aggiornamento scade dopo %s! ',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: soluzione scaduta il (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: soluzione scade dopo %s! ',
        'There are more escalated tickets!' => 'Ci sono altri ticket scalati!',
        'Plain Format' => 'Formato semplice',
        'Reply All' => 'Rispondi a tutti',
        'Direction' => 'Direzione',
        'New ticket notification' => 'Notifica nuovo ticket',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Inviami una notifica se viene inserito un nuovo ticket in una coda della lista "Le mie code"',
        'Send new ticket notifications' => 'Inviare nuove notifiche ticket',
        'Ticket follow up notification' => 'Notifica di follow-up del ticket',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '',
        'Send ticket follow up notifications' => 'Invia le notifiche di follow-up',
        'Ticket lock timeout notification' => 'Notifica scadenza gestione richieste',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Inviami una notifica se un ticket viene sbloccato dal sistema.',
        'Send ticket lock timeout notifications' => 'Invia notifiche di time-out della presa in carico',
        'Ticket move notification' => 'Notifica di spostamento del ticket',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Inviami una notifica se un ticket viene spostato in una coda della lista "Le mie code"',
        'Send ticket move notifications' => 'Invia notifica di spostamento del ticket',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Selezione delle code preferite. Se abilitato, sarete notificati via email.',
        'Custom Queue' => 'Coda personale',
        'QueueView refresh time' => 'Tempo di aggiornamento vista della coda',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Se abilitata, dopo il tempo prefissato la vista della coda sarà aggiornata automaticamente.',
        'Refresh QueueView after' => 'Ricarica la vista della coda dopo',
        'Screen after new ticket' => 'Pagina da mostrare dopo un nuovo ticket',
        'Show this screen after I created a new ticket' => 'Mostra questa schermata dopo aver creato un ticket',
        'Closed Tickets' => 'Richieste chiuse',
        'Show closed tickets.' => 'Mostra le richieste chiuse.',
        'Max. shown Tickets a page in QueueView.' => 'Numero di richieste visualizzate per pagina nella vista della coda.',
        'Ticket Overview "Small" Limit' => 'Limite di visualizzazione ticket nella visuale "Piccola"',
        'Ticket limit per page for Ticket Overview "Small"' => 'Limite di visualizzazione ticket per pagina nella visuale "Piccola"',
        'Ticket Overview "Medium" Limit' => 'Limite di visualizzazione ticket nella visuale "Media"',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Limite di visualizzazione ticket per pagina nella visuale "Media"',
        'Ticket Overview "Preview" Limit' => 'Limite di visualizzazione ticket nella visuale "Grande"',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limite di visualizzazione ticket per pagina nella visuale "Grande"',
        'Ticket watch notification' => 'Notifica di osservazione dei ticket',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Inviami per i ticket osservati la stessa notifica che ricevono i proprietari.',
        'Send ticket watch notifications' => 'Inviare notifica di osservazione ticket',
        'Out Of Office Time' => 'Orario di assenza dall\'ufficio',
        'New Ticket' => 'Nuovo ticket',
        'Create new Ticket' => 'Crea un nuovo ticket',
        'Customer called' => 'Utente chiamato',
        'phone call' => 'Telefonata',
        'Phone Call Outbound' => 'Telefonata effettuata',
        'Phone Call Inbound' => 'Telefonata ricevuta',
        'Reminder Reached' => 'Promemoria raggiunti',
        'Reminder Tickets' => 'Tickets di promemoria',
        'Escalated Tickets' => 'Ticket scalati',
        'New Tickets' => 'Nuovi ticket',
        'Open Tickets / Need to be answered' => 'Ticket aperti / che richiedono risposta',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Tutti i ticket aperti, questi ticket sono in lavorazione ma necessitano di una risposta',
        'All new tickets, these tickets have not been worked on yet' => 'Tutti i nuovi ticket, questi ticket devono ancora essere elaborati',
        'All escalated tickets' => 'Tutti i ticket scalati',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Tutti i ticket con un promemoria scaduto',
        'Archived tickets' => 'Ticket archiviati',
        'Unarchived tickets' => 'Ticket non archiviati',
        'Ticket Information' => 'Informazioni sul ticket',
        'including subqueues' => 'incluse le sottocode',
        'excluding subqueues' => 'escluse le sottocode',

        # Template: AAAWeekDay
        'Sun' => 'Dom',
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mer',
        'Thu' => 'Gio',
        'Fri' => 'Ven',
        'Sat' => 'Sab',

        # Template: AdminACL
        'ACL Management' => 'Gestione ACL',
        'Filter for ACLs' => 'Filtro per ACL',
        'Filter' => 'Filtro',
        'ACL Name' => 'Nome ACL',
        'Actions' => 'Azioni',
        'Create New ACL' => 'Crea una nuova ACL',
        'Deploy ACLs' => 'Rendi attive le ACL',
        'Export ACLs' => 'Esporta le ACL',
        'Configuration import' => 'Importazione configurazione',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Qui puoi caricare un file di configurazione per importare le ACL. Il file deve essere in formato .yml così come viene esportato dal modulo editor delle ACL',
        'This field is required.' => 'Questo campo è obbligatorio',
        'Overwrite existing ACLs?' => 'Sovrascrivere le ACL esistenti?',
        'Upload ACL configuration' => 'Carica una configurazione di ACL',
        'Import ACL configuration(s)' => 'Importa una configurazione di ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Per creare una nuova ACL si può importarne una proveniente da un altro sistema o crearne una nuova del tutto.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Nota: questa tabella rappresenta l\'ordine di esecuzione delle ACL. Se è necessario modificare l\'ordine in cui vengono eseguite le ACL, modifica i nomi delle ACL interessate.',
        'ACL name' => 'Nome ACL',
        'Validity' => 'Validità',
        'Copy' => 'Copia',
        'No data found.' => 'Nessun dato trovato.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Modifica l\'ACL %s',
        'Go to overview' => 'Vai al riepilogo',
        'Delete ACL' => 'Elimina ACL',
        'Delete Invalid ACL' => 'Elimina ACL non valida',
        'Match settings' => 'Criteri di corrispondenza',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => 'Cambia impostazioni',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '',
        'Check the official' => 'Controlla la versione ufficiale',
        'documentation' => 'documentazione',
        'Show or hide the content' => 'Mostra o nascondi contenuto',
        'Edit ACL information' => 'Modifica le informazioni dell\'ACL',
        'Stop after match' => 'Ferma dopo trovato',
        'Edit ACL structure' => 'Modifica la struttura dell\'ACL',
        'Save' => 'Salva',
        'or' => 'oppure',
        'Save and finish' => 'Salva e termina',
        'Do you really want to delete this ACL?' => 'Sei sicuro di volere eliminare questa ACL?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Questa voce contiene delle sottovoci. Sei sicuro di volere rimuovere questa voce con le relative sottovoci?',
        'An item with this name is already present.' => 'Una voce con questo nome esiste già.',
        'Add all' => 'Aggiungi tutto',
        'There was an error reading the ACL data.' => 'Si è verificato un errore durante la lettura dei dati dell\'ACL',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAttachment
        'Attachment Management' => 'Gestione allegati',
        'Add attachment' => 'Aggiungi allegato',
        'List' => 'Lista',
        'Download file' => 'Scarica file',
        'Delete this attachment' => 'Elimina questo allegato',
        'Add Attachment' => 'Aggiungi allegato',
        'Edit Attachment' => 'Modifica allegato',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Gestione risposte automatiche',
        'Add auto response' => 'Aggiungi risposta automatica',
        'Add Auto Response' => 'Aggiungi risposta automatica',
        'Edit Auto Response' => 'Modifica risposta automatica',
        'Response' => 'Risposta',
        'Auto response from' => 'Risposta automatica da',
        'Reference' => 'Riferimento',
        'You can use the following tags' => 'Puoi usare i seguenti tag',
        'To get the first 20 character of the subject.' => 'Usa i primi 20 caratteri dell\'oggetto.',
        'To get the first 5 lines of the email.' => 'Usa le prime 5 righe dell\'email.',
        'To get the realname of the sender (if given).' => 'Usa il realname dello user (se presente).',
        'To get the article attribute' => 'Usa l\'attributo dell\'articolo',
        ' e. g.' => 'ad es.',
        'Options of the current customer user data' => 'Opzioni dei dati del cliente corrente',
        'Ticket owner options' => 'Operazioni proprietario ticket',
        'Ticket responsible options' => 'Operazione responsabile ticket',
        'Options of the current user who requested this action' => 'Opzioni dell\'utente corrente che ha richiesto questa azione',
        'Options of the ticket data' => 'Opzioni dei dati del ticket',
        'Options of ticket dynamic fields internal key values' => 'Opzioni per i valori dei campi dinamici a livello di ticket',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opzioni per i valori dei campi dinamici a livello di ticket, utili per i campi a tendina e a selezione multipla',
        'Config options' => 'Opzioni di configurazione',
        'Example response' => 'Risposta di esempio',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Gestione servizi Cloud',
        'Support Data Collector' => 'Collezionatore dati di supporto',
        'Support data collector' => 'Collezionatore dati di supporto',
        'Hint' => 'Suggerimento',
        'Currently support data is only shown in this system.' => 'Attualmente i dati di supporto sono mostrati solo in questo sistema.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Consigliamo vivamente di inviare questi dati a OTRS Group per ottenere un supporto migliore.',
        'Configuration' => 'Configurazione',
        'Send support data' => 'Invia dati di supporto',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Ciò consentirà al sistema di inviare dati di supporto aggiuntivi a OTRS Group.',
        'System Registration' => 'Registrazione del sistema',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Registra questo sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'La registrazione è disabilitata per il tuo sistema. Controlla la tua configurazione.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'La registrazione del sistema è un servizio di OTRS Group, che fornisce molti vantaggi!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            '',
        'Register this system' => 'Registra questo sistema',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Qui puoi configurare i servizi cloud disponibili che comunicano in modo sicuro con %s.',
        'Available Cloud Services' => 'Servizi Cloud disponibili',
        'Upgrade to %s' => 'Aggiorna a %s',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestione clienti',
        'Wildcards like \'*\' are allowed.' => ' Sono permessi i caratteri jolly come \'*\'.',
        'Add customer' => 'Aggiungi cliente',
        'Select' => 'Seleziona',
        'Please enter a search term to look for customers.' => 'Inserire una chiave di ricerca per i clienti.',
        'Add Customer' => 'Aggiungi cliente',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gestione utenti cliente',
        'Back to search results' => 'Torna ai risultati della ricerca',
        'Add customer user' => 'Aggiungi un utente cliente',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Gli utenti cliente sono necessari per avere lo storico dei clienti e per effettuare l\'accesso dal pannello dei clienti.',
        'Last Login' => 'Ultimo accesso',
        'Login as' => 'Accedi come',
        'Switch to customer' => 'Impersona il cliente',
        'Add Customer User' => 'Aggiungi utente cliente',
        'Edit Customer User' => 'Modifica utente cliente',
        'This field is required and needs to be a valid email address.' =>
            'Questo campo è obbligatorio e deve contenere un indirizzo email valido.',
        'This email address is not allowed due to the system configuration.' =>
            'Questo indirizzo email non è consentito dalla configurazione di sistema.',
        'This email address failed MX check.' => 'Questo indirizzo email non ha superato il controllo MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema con il DNS, verifica la tua configurazione e il log degli errori.',
        'The syntax of this email address is incorrect.' => 'La sintassi di questa email è errata.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gestisci relazioni Cliente-Gruppo',
        'Notice' => 'Notifica',
        'This feature is disabled!' => 'Questa funzione è disabilitata',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Usa questa funzione solo se vuoi definire permessi di gruppo per i clienti.',
        'Enable it here!' => 'Abilita funzione qui',
        'Edit Customer Default Groups' => 'Modifica gruppi predefiniti degli utenti',
        'These groups are automatically assigned to all customers.' => 'Questi gruppi saranno assegnati automaticamente a tutti gli utenti.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'È possibile gestire questi gruppi tramite l\'impostazione di configurazione "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtri per gruppi',
        'Just start typing to filter...' => 'Digita qualche carattere per attivare il filtro...',
        'Select the customer:group permissions.' => 'Seleziona i permessi cliente:gruppo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se non si effettua una selezione, non ci saranno permessi in questo gruppo (i ticket non saranno disponibili al cliente)',
        'Search Results' => 'Risultato della ricerca',
        'Customers' => 'Utenti',
        'No matches found.' => 'Nessun risultato.',
        'Groups' => 'Gruppi',
        'Change Group Relations for Customer' => 'Cambia relazioni di gruppo per il cliente',
        'Change Customer Relations for Group' => 'Cambia relazioni dei clienti per il gruppo',
        'Toggle %s Permission for all' => 'Imposta permesso %s per tutti',
        'Toggle %s permission for %s' => 'Imposta permesso %s per %s',
        'Customer Default Groups:' => 'Gruppi predefiniti cliente:',
        'No changes can be made to these groups.' => 'Nessun cambiamento verrà effettuato a questi gruppi.',
        'ro' => 'sola lettura',
        'Read only access to the ticket in this group/queue.' => 'Accesso in sola lettura alle richieste in questo gruppo/coda.',
        'rw' => 'lettura e scrittura',
        'Full read and write access to the tickets in this group/queue.' =>
            'Accesso completo in lettura e scrittura alle richieste in questo gruppo/coda',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Gestisci relazioni cliente-servizi',
        'Edit default services' => 'Modifica servizi di default',
        'Filter for Services' => 'Filtri per i servizi',
        'Allocate Services to Customer' => 'Alloca servizi a cliente',
        'Allocate Customers to Service' => 'Alloca clienti a servizio',
        'Toggle active state for all' => 'Imposta stato attivo per tutti',
        'Active' => 'Attivo',
        'Toggle active state for %s' => 'Imposta stato attivo per %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestione campi dinamici',
        'Add new field for object' => 'Aggiungi un nuovo campo per l\'oggetto',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Elenco campi dinamici',
        'Dynamic fields per page' => 'Campi dinamici per pagina',
        'Label' => 'Etichetta',
        'Order' => 'Ordine',
        'Object' => 'Oggetto',
        'Delete this field' => 'Elimina questo campo',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Vuoi davvero eliminare questo campo dinamico? TUTTI i dati associati saranno PERSI!',
        'Delete field' => 'Elimina campo',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Campi dinamici',
        'Field' => 'Campo',
        'Go back to overview' => 'Torna alla vista globale',
        'General' => 'Generale',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Campo obbligatorio. Il valore può contenere solo lettere e numeri.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Deve essere univoco e contenere solo lettere e numeri.',
        'Changing this value will require manual changes in the system.' =>
            'La modifica di questo valore richiede modifiche manuali al sistema.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Questo è il nome mostrato sulle pagine quando il campo è attivo',
        'Field order' => 'Ordine del campo',
        'This field is required and must be numeric.' => 'Campo obbligatorio. Può contenere solo numeri.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Questo è l\'ordine con cui il campo sarà mostrato sulle pagine quando è attivo.',
        'Field type' => 'Tipo di campo',
        'Object type' => 'Tipo di oggetto',
        'Internal field' => 'Campo interno',
        'This field is protected and can\'t be deleted.' => 'Questo campo è protetto e non può essere eliminato.',
        'Field Settings' => 'Impostazioni del campo',
        'Default value' => 'Valore predefinito',
        'This is the default value for this field.' => 'Questo è il valore predefinito per il campo',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Differenza predefinita tra le date',
        'This field must be numeric.' => 'Questo campo deve essere numerico',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Differenza rispetto al momento attuale in secondi, per calcolare il valore predefinito del campo (ad es. 3600 o -60).',
        'Define years period' => 'Periodo in anni',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Attiva questa funzionalità per definire un intervallo fisso di anni, nel futuro e nel passato, mostrato nella parte anno del campo',
        'Years in the past' => 'Anni nel passato',
        'Years in the past to display (default: 5 years).' => 'Anni nel passato da mostrare (predefinito: 5 anni).',
        'Years in the future' => 'Anni nel futuro',
        'Years in the future to display (default: 5 years).' => 'Anni nel futuro da mostrare (predefinito: 5 anni).',
        'Show link' => 'Mostra collegamento',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Qui puoi specificare un collegamento http per il campo nelle schermate vista globale e zoom.',
        'Restrict entering of dates' => 'Limita la digitazione di date',
        'Here you can restrict the entering of dates of tickets.' => 'Qui puoi limitare la digitazione delle date dei ticket.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Valori ammessi',
        'Key' => 'Chiave',
        'Value' => 'Valore',
        'Remove value' => 'Rimuovi valore',
        'Add value' => 'Aggiungi valore',
        'Add Value' => 'Aggiungi valore',
        'Add empty value' => 'Aggiungi valore vuoto',
        'Activate this option to create an empty selectable value.' => 'Attiva questa opzione per creare un valore nullo selezionabile.',
        'Tree View' => 'Visualizzazione ad albero',
        'Activate this option to display values as a tree.' => 'Attiva questa opzione per visualizzare i valori come un albero.',
        'Translatable values' => 'Valore da tradurre',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Se attivate questa opzione i valori saranno tradotti nella lingua dell\'utente',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'È necessario aggiungere le traduzioni manualmente nei file di traduzione.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Numero di righe',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Specifica l\'altezza (in righe) per questo campo in modalità di modifica.',
        'Number of cols' => 'Numero di colonne',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Specifica la larghezza (in caratteri) per questo campo in modalità di modifica.',
        'Check RegEx' => 'Espressione regolare di controllo',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => 'Espressione regolare',
        'Invalid RegEx' => 'Espressione regolare non valida',
        'Error Message' => 'Messaggio di errore',
        'Add RegEx' => 'Aggiungi espressione regolare',

        # Template: AdminEmail
        'Admin Notification' => 'Notifiche amministrative',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Con questo modulo, gli amministratori possono inviare messaggi a operatori, gruppi o appartenenti a un ruolo.',
        'Create Administrative Message' => 'Creazione messaggio amministrativo',
        'Your message was sent to' => 'Il messaggio è stato inviato a',
        'Send message to users' => 'Invia messaggio agli utenti',
        'Send message to group members' => 'Invia messaggio ai membri del gruppo',
        'Group members need to have permission' => 'I membri del gruppo necessitano del permesso',
        'Send message to role members' => 'Invia messaggio ai membri del ruolo',
        'Also send to customers in groups' => 'Invia anche ai clienti nei gruppi',
        'Body' => 'Testo',
        'Send' => 'Invia',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agente generico',
        'Add job' => 'Aggiungi job',
        'Last run' => 'Ultima esecuzione',
        'Run Now!' => 'Esegui ora!',
        'Delete this task' => 'Elimina questo task',
        'Run this task' => 'Esegui questo task',
        'Job Settings' => 'Impostazioni job',
        'Job name' => 'Nome job',
        'The name you entered already exists.' => 'Il nome immesso è già esistente.',
        'Toggle this widget' => 'Imposta questo widget',
        'Automatic execution (multiple tickets)' => 'Esecuzione automatica (su ticket multipli)',
        'Execution Schedule' => 'Pianificazione esecuzione',
        'Schedule minutes' => 'Minuti della pianificazione',
        'Schedule hours' => 'Ore della pianificazione',
        'Schedule days' => 'Giorni della pianificazione',
        'Currently this generic agent job will not run automatically.' =>
            'Attualmente questo agente generico non viene lanciato automaticamente.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Per abilitare l\'esecuzione automatica, seleziona almeno un valore per i minuti, ore e giorni! ',
        'Event based execution (single ticket)' => 'Esecuzione scatenata da evento (singolo ticket)',
        'Event Triggers' => 'Trigger di eventi',
        'List of all configured events' => 'Elenco di tutti gli eventi configurati',
        'Delete this event' => 'Elimina questo evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'Vuoi davvero eliminare questo trigger?',
        'Add Event Trigger' => 'Aggiungi trigger di eventi',
        'Add Event' => 'Aggiungi evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Per aggiungere un nuovo evento seleziona nome e oggetto, e premi sul pulsante "+"',
        'Duplicate event.' => 'Evento duplicato.',
        'This event is already attached to the job, Please use a different one.' =>
            'Questo evento è già collegato al job, specificarne uno diverso',
        'Delete this Event Trigger' => 'Elimina questo trigger',
        'Remove selection' => 'Rimuovi selezione',
        'Select Tickets' => 'Seleziona ticket',
        '(e. g. 10*5155 or 105658*)' => '(per esempio \'10*5155\' o \'105658*\')',
        '(e. g. 234321)' => '(per esempio \'234321\')',
        'Customer login' => 'Login cliente',
        '(e. g. U5150)' => '(per esempio \'U5150\')',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Ricerca a testo nell\'articolo (ad es. "Mar*in" o "Baue*").',
        'Agent' => 'Operatore',
        'Ticket lock' => 'Presa in carico ticket',
        'Create times' => 'Tempi di creazione',
        'No create time settings.' => 'Data di creazione mancante ',
        'Ticket created' => 'Ticket creato',
        'Ticket created between' => 'Ticket creato tra',
        'Last changed times' => 'Ultimo evento di modifica',
        'No last changed time settings.' => '',
        'Ticket last changed' => 'Ultima modifica apportata al ticket',
        'Ticket last changed between' => 'Ultima modifica apportata al ticket fra',
        'Change times' => 'Modifica orari',
        'No change time settings.' => 'Nessuna modifica tempo.',
        'Ticket changed' => 'Ticket cambiato',
        'Ticket changed between' => 'Ticket cambiato fra ',
        'Close times' => 'Tempi di chiusura',
        'No close time settings.' => 'Nessuna data di chiusura.',
        'Ticket closed' => 'Ticket chiusi',
        'Ticket closed between' => 'Ticket chiusi tra ',
        'Pending times' => 'Tempi di attesa',
        'No pending time settings.' => 'Tempo di attesa non selezionato',
        'Ticket pending time reached' => 'Tempo di attesa per ticket raggiunto',
        'Ticket pending time reached between' => 'Tempo di attesa per ticket raggiunto fra ',
        'Escalation times' => 'Tempi di escalation',
        'No escalation time settings.' => 'Tempo di gestione non selezionato.',
        'Ticket escalation time reached' => 'Tempo di gestione per ticket superato',
        'Ticket escalation time reached between' => 'Tempo di gestione per ticket superato fra',
        'Escalation - first response time' => 'Escalation - Prima risposta',
        'Ticket first response time reached' => 'Tempo di prima risposta superato',
        'Ticket first response time reached between' => 'Tempo di prima risposta superato fra',
        'Escalation - update time' => 'Escalation - Aggiornamento',
        'Ticket update time reached' => 'Tempo di gestione - Aggiorna scaduto ',
        'Ticket update time reached between' => 'Tempo di gestione - Aggiorna scaduto fra',
        'Escalation - solution time' => 'Escalation - Soluzione',
        'Ticket solution time reached' => 'Tempo per soluzione scaduto',
        'Ticket solution time reached between' => 'Tempo per soluzione scaduto fra ',
        'Archive search option' => 'Opzione di ricerca in archivio',
        'Update/Add Ticket Attributes' => 'Aggiorna/Aggiungi attributi ticket',
        'Set new service' => 'Imposta nuovo servizio',
        'Set new Service Level Agreement' => 'Imposta nuovo Service Level Agreement',
        'Set new priority' => 'Imposta nuova priorità',
        'Set new queue' => 'Imposta nuova coda',
        'Set new state' => 'Imposta nuovo stato',
        'Pending date' => 'In attesa fino a',
        'Set new agent' => 'Imposta nuovo agente',
        'new owner' => 'Nuovo proprietario',
        'new responsible' => 'Nuovo responsabile',
        'Set new ticket lock' => 'Imposta nuova presa in carico del ticket',
        'New customer' => 'Nuovo cliente',
        'New customer ID' => 'Nuovo ID cliente',
        'New title' => 'Nuovo titolo',
        'New type' => 'Nuovo tipo',
        'New Dynamic Field Values' => 'Nuovo valore di campo dinamico',
        'Archive selected tickets' => 'Archivia i ticket selezionati',
        'Add Note' => 'Aggiungi nota',
        'Time units' => 'Tempo',
        'Execute Ticket Commands' => 'Esegui i comandi associati al ticket',
        'Send agent/customer notifications on changes' => 'Invia a un agente/utente una notifica se cambia',
        'CMD' => 'comando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Questo comando sarà eseguito. ARG[0] sarà il numero del ticket. ARG[1] sarà l\'identificativo del ticket.',
        'Delete tickets' => 'Elimina ticket',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Attenzione: Tutti i ticket corrispondenti saranno rimossi dal database e non potranno essere ripristinati!',
        'Execute Custom Module' => 'Esegui Modulo Custom',
        'Param %s key' => 'Chiave parametro %s',
        'Param %s value' => 'Valore parametro %s',
        'Save Changes' => 'Salva cambiamenti',
        'Results' => 'Risultati',
        '%s Tickets affected! What do you want to do?' => '%s ticket corrispondenti! Cosa vuoi fare?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Avviso: è stata usata l\'opzione ELIMINA. Tutti i ticket eliminati saranno persi!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Edit job' => 'Modifica job',
        'Run job' => 'Esegui job',
        'Affected Tickets' => 'Ticket corrispondenti',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'GenericInterface Debugger per il web service %s',
        'You are here' => 'Sei qui',
        'Web Services' => 'Web service',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Ritorna al web service',
        'Clear' => 'Cancella',
        'Do you really want to clear the debug log of this web service?' =>
            'Vuoi davvero cancellare il log di debug per questo web service?',
        'Request List' => 'Lista richieste',
        'Time' => 'Tempo',
        'Remote IP' => 'IP remoto',
        'Loading' => 'Caricamento',
        'Select a single request to see its details.' => 'Seleziona una sola richiesta per vederne i dettagli',
        'Filter by type' => 'Filtra per tipo',
        'Filter from' => 'Filtra da',
        'Filter to' => 'Filtra a',
        'Filter by remote IP' => 'Filtra per IP remoto',
        'Limit' => 'Limite',
        'Refresh' => 'Aggiorna',
        'Request Details' => 'Richiedi dettagli',
        'An error occurred during communication.' => 'Errore durante la comunicazione',
        'Show or hide the content.' => 'Mostra o nascondi il contenuto',
        'Clear debug log' => 'Cancella il debug log',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Aggiungi nuovo invoker al web service %s',
        'Change Invoker %s of Web Service %s' => 'Cambia l\'invoker %s del web service %s',
        'Add new invoker' => 'Aggiungi nuovo Invoker',
        'Change invoker %s' => 'Cambia Invoker %s',
        'Do you really want to delete this invoker?' => 'Vuoi davvero eliminare questo invoker?',
        'All configuration data will be lost.' => 'Tutti i dati di configurazione saranno persi.',
        'Invoker Details' => 'Dettagli dell\'Invoker',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Questo nome è normalmente usato per innescare l\'operazione di un web service remoto.',
        'Please provide a unique name for this web service invoker.' => 'Impostare un nome univoco per questo invoker di web service.',
        'Invoker backend' => 'Invoker backend',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Questo modulo di Invoker di backend viene utilizzato per preparare i dati da inviare al sistema remoto e per processare le risposte.',
        'Mapping for outgoing request data' => 'Mapping per i dati delle richieste in uscita',
        'Configure' => 'Configurazione',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'I dati dell\'Invoker OTRS saranno trasformati con questa mappatura, per modificarli secondo le aspettative del sistema remoto.',
        'Mapping for incoming response data' => 'Mapping per i dati delle richieste in ingresso',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'I dati del sistema remoto saranno trasformati con questa mappatura, per modificarli secondo le aspettative del sistema OTRS.',
        'Asynchronous' => 'Asincrono',
        'This invoker will be triggered by the configured events.' => 'Questo Invoker sarà scatenato dagli eventi configurati.',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'I trigger sincroni di eventi saranno elaborati direttamente durante la richiesta web.',
        'Save and continue' => 'Salva e prosegui',
        'Delete this Invoker' => 'Elimina questo invoker',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'GenericInterface Mapping semplice per il web service %s',
        'Go back to' => 'Torna indietro a',
        'Mapping Simple' => 'Mapping Semplice',
        'Default rule for unmapped keys' => 'Regole di default per chiavi non mappate',
        'This rule will apply for all keys with no mapping rule.' => 'Questa regola sarà applicata per tutte le chiavi senza regole specifiche di mapping',
        'Default rule for unmapped values' => 'Regola di default per valori non mappati',
        'This rule will apply for all values with no mapping rule.' => 'Questa regola sarà applicata per tutti i valori senza regole specifiche di mapping',
        'New key map' => 'Nuova mappatura chiavi',
        'Add key mapping' => 'Aggiungi mappatura chiavi',
        'Mapping for Key ' => 'Mappatura per la chiave',
        'Remove key mapping' => 'Rimuovere mappatura chiave',
        'Key mapping' => 'Mappatura chiave',
        'Map key' => 'Chiave Sorgente',
        'matching the' => 'appaiata con',
        'to new key' => 'Chiave Destinazione',
        'Value mapping' => 'Mappatura valori',
        'Map value' => 'Valore Sorgente',
        'to new value' => 'Valore Destinazione',
        'Remove value mapping' => 'Rimuovere mappatura valori',
        'New value map' => 'Nuova mappatura valori',
        'Add value mapping' => 'Aggiungi mappatura valori',
        'Do you really want to delete this key mapping?' => 'Vuoi davvero eliminare questa mappatura?',
        'Delete this Key Mapping' => 'Elimina questa mappatura',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => '',
        'Mapping XML' => 'Mappatura XML',
        'Template' => 'Modello',
        'The entered data is not a valid XSLT stylesheet.' => 'I dati inseriti non sono un foglio di stile XSLT valido.',
        'Insert XSLT stylesheet.' => 'Inserisci foglio di stile XSLT.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Aggiungi una nuova operazione al web service %s',
        'Change Operation %s of Web Service %s' => 'Modifica l\'operazione %s del web service %s',
        'Add new operation' => 'Aggiungi nuova operazione',
        'Change operation %s' => 'Modifica operazione %s',
        'Do you really want to delete this operation?' => 'Vuoi davvero eliminare questa operazione?',
        'Operation Details' => 'Dettagli operazione',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Il nome è solitamente utilizzato per richiamare questa operazione del web service da un sistema remoto',
        'Please provide a unique name for this web service.' => 'Indica un nome univoco per questo web service',
        'Mapping for incoming request data' => 'Mappatura per i dati in ingresso',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'I dati del sistema remoto saranno trasformati con questa mappatura, per modificarli secondo le aspettative del sistema OTRS.',
        'Operation backend' => 'Motore operazione',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Questo modulo di backend di OTRS sarà chiamato internamente per elaborare la richiesta, generando i dati per la risposta',
        'Mapping for outgoing response data' => 'Mappatura per i dati in uscita',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'I dati ricevuti saranno trasformati con questa mappatura, per modificarli secondo le aspettative del sistema remoto.',
        'Delete this Operation' => 'Elimina questa operazione',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'GenericInterface Transport HTTP::REST per il web service %s',
        'Network transport' => 'Network transport',
        'Properties' => 'Proprietà',
        'Route mapping for Operation' => 'Mappatura di instradamento per l\'Operazione',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'Lunghezza massima del messaggio',
        'This field should be an integer number.' => 'Questo campo deve essere un numero intero.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => 'Invia Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Host' => 'Fidato',
        'Remote host URL for the REST requests.' => 'URL host remoto per le richieste REST.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'ad es. https://www.otrs.com:10745/api/v1.0 (senza barra finale)',
        'Controller mapping for Invoker' => 'Mappatura del controller per l\'invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => 'Comando di richiesta per l\'invoker valido',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Uno specifico comando HTTP da utilizzare per le richieste con questo invoker (facoltativo).',
        'Default command' => 'Comando predefinito',
        'The default HTTP command to use for the requests.' => 'Il comando HTTP predefinito da utilizzare per le richieste.',
        'Authentication' => 'Autenticazione',
        'The authentication mechanism to access the remote system.' => 'Meccanismo di autenticazione per accedere al sistema remoto',
        'A "-" value means no authentication.' => '"-" indica nessuna autenticazione',
        'The user name to be used to access the remote system.' => 'Utente per accesso al sistema remoto.',
        'The password for the privileged user.' => 'Password per l\'utente',
        'Use SSL Options' => 'Opzione per utilizzo di SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Mostra o nascondi l\'opzione SSL per connettersi al sistema remoto.',
        'Certificate File' => 'File del Certificato',
        'The full path and name of the SSL certificate file.' => 'Il percorso completo e il nome del file del certificato SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'ad es. /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'File della password del certificato',
        'The full path and name of the SSL key file.' => 'Il percorso completo e il nome del file della chiave SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'ad es. /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'File dell\'autorità di certificazione (CA)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'Il percorso completo e il nome del file dell\'autorità di certificazione che convalida il certificato SSL.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'ad es. /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'GenericInterface Transport HTTP::SOAP per il web service %s',
        'Endpoint' => 'Terminatore',
        'URI to indicate a specific location for accessing a service.' =>
            'URI per indicare una specifica locazione per accedere al servizio',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'es. http://local.otrs.com:8000/Webservice/Esempio',
        'Namespace' => 'Spazio dei nomi',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI per indicare ai metodi SOAP il contesto, per ridurre le ambiguità',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'es. rn:otrs-com:soap:functions o http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Schema del nome di richiesta',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '',
        '\'FreeText\' is used as example for actual configured value.' =>
            '',
        'Response name free text' => 'Testo del nome di risposta',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => 'Schema del nome di risposta',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Specifica il la dimensione massima (in byte) del messaggio SOAP che OTRS elaborerà.',
        'Encoding' => 'Codifica',
        'The character encoding for the SOAP message contents.' => 'L\'encoding del contenuto del messaggio',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'es. utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'SOAPAction' => 'SOAPAction',
        'Set to "Yes" to send a filled SOAPAction header.' => '"Sì" per inviare un\'intestazione SOAPAction compilata.',
        'Set to "No" to send an empty SOAPAction header.' => '"No" per inviare un\'intestazione SOAPAction vuota.',
        'SOAPAction separator' => 'separatore SOAPAction',
        'Character to use as separator between name space and SOAP method.' =>
            'Carattere da utilizzare come separatore tra lo spazio dei nomi e il metodo SOAP.',
        'Usually .Net web services uses a "/" as separator.' => 'Normalmente i web service .Net utilizzano "/" come separatore.',
        'Proxy Server' => 'Server proxy',
        'URI of a proxy server to be used (if needed).' => 'URI del Proxy Server, se richiesto',
        'e.g. http://proxy_hostname:8080' => 'es. http://proxy_hostname:8080',
        'Proxy User' => 'Utente del proxy',
        'The user name to be used to access the proxy server.' => 'Utente per l\'accesso al Proxy Server',
        'Proxy Password' => 'Password per l\'utente del proxy',
        'The password for the proxy user.' => 'La password per l\'utente per il proxy.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Percorso completo e nome del certificato SSL, in formato .p12',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'es. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'Password per aprire il certificato SSL',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Percorso completo e nome del file dell\'autorità di certificazione che convalida il certificato SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'es. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Cartella dell\'autorità di certificazione (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Percorso completo e nome del file della directory che contiene i certificati CA',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'es. /opt/otrs/var/certificates/SOAP/CA',
        'Sort options' => 'Opzioni di ordinamento',
        'Add new first level element' => 'Aggiungi nuovo elemento di primo livello',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'GenericInterface gestione web service',
        'Add web service' => 'Aggiungi web service',
        'Clone web service' => 'Copia web service',
        'The name must be unique.' => 'Il nome deve essere univoco.',
        'Clone' => 'Copia',
        'Export web service' => 'Esporta web service',
        'Import web service' => 'Importa web service',
        'Configuration File' => 'File di Configurazione',
        'The file must be a valid web service configuration YAML file.' =>
            'Il file deve essere un file di configurazione di web service in formato YAML.',
        'Import' => 'Importa',
        'Configuration history' => 'Storico della configurazione',
        'Delete web service' => 'Elimina il web service',
        'Do you really want to delete this web service?' => 'Vuoi davvero eliminare questo web service?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Dopo aver salvato, sarai rediretto alla schermata di modifica.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Se vuoi ritornare alla vista globale, utilizza il pulsante "Vai alla vista globale".',
        'Web Service List' => 'Elenco web service',
        'Remote system' => 'Sistema Remoto',
        'Provider transport' => 'Trasporto del Provider',
        'Requester transport' => 'Trasporto del Richiedente',
        'Debug threshold' => 'Soglia di debug',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'In modalità fornitore, OTRS espone web service utilizzati dai sistemi remoti.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'In modalità richiedente, OTRS sfrutta i web service del sistema remoto',
        'Operations are individual system functions which remote systems can request.' =>
            'Operazioni sono funzionalità singole che i sistemi remoti possono richiedere',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Gli invoker preparano i dati per una richiesta al web service di un sistema remoto, e processano i dati ricevuti in risposta',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Mappatura in ingresso',
        'Outbound mapping' => 'Mappatura in uscita',
        'Delete this action' => 'Elimina questa azione',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Almeno un %s ha un controller che è non attivo o non disponibile, verifica la registrazione del controller o elimina la %s',
        'Delete webservice' => 'Elimina web service',
        'Delete operation' => 'Elimina operazione',
        'Delete invoker' => 'Elimina invoker',
        'Clone webservice' => 'Copia web service',
        'Import webservice' => 'Importa web service',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'GenericInterface Storico delle configurazioni per il web service %s',
        'Go back to Web Service' => 'Ritorna al web service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Qui potete vedere le versioni precedenti della configurazione del web service, potete esportarle o ripristinale.',
        'Configuration History List' => 'Elenco storico configurazioni',
        'Version' => 'Versione',
        'Create time' => 'Data di Creazione',
        'Select a single configuration version to see its details.' => 'Selezionate una sola versione per vederne i dettagli.',
        'Export web service configuration' => 'Esporta la configurazione del web service',
        'Restore web service configuration' => 'Ripristina la configurazione del web service',
        'Do you really want to restore this version of the web service configuration?' =>
            'Vuoi davvero ripristinare questa versione della configurazione del web service?',
        'Your current web service configuration will be overwritten.' => 'La configurazione attuale del web service sarà sovrascritta.',
        'Restore' => 'Ripristina',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'AVVISO: Quando cambi il nome del gruppo \'admin\', prima delle opportune modifiche in SysConfig, sarai escluso dal pannello di amministrazione! Se ciò accade ripristina il nome precedente del gruppo a \'admin\'.',
        'Group Management' => 'Gestione gruppo',
        'Add group' => 'Aggiungi gruppo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Il gruppo admin ha accesso all\'area di amministrazione mentre il gruppo stats ha accesso alle statistiche.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crea nuovi gruppi per gestire i permessi di accesso per diversi gruppi di agenti (ad esempio il dipartimento acquisti, dipartimento di supporto, dipartimento vendite, ...). ',
        'It\'s useful for ASP solutions. ' => 'È utile per soluzioni ASP. ',
        'Add Group' => 'Inserisci gruppo',
        'Edit Group' => 'Modifica gruppo',

        # Template: AdminLog
        'System Log' => 'Log di sistema',
        'Here you will find log information about your system.' => 'Qui si troveranno informazioni di log sul sistema.',
        'Hide this message' => 'Nascondi questo messaggio',
        'Recent Log Entries' => 'Interazioni recenti',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestione Credenziali Mail ',
        'Add mail account' => 'Aggiungi account di posta',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Tutti i messaggi in arrivo saranno smistati nella coda selezionata!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Se il tuo account è fidato, verrà utilizzata l\'intestazione X-OTRS dell\'ora di arrivo (priorità, ...)! Il filtro PostMaster verrà utilizzato in ogni caso.',
        'Delete account' => 'Elimina account',
        'Fetch mail' => 'Scarica posta',
        'Add Mail Account' => 'Aggiungi account di posta',
        'Example: mail.example.com' => 'Esempio: mail.esempio.it',
        'IMAP Folder' => 'Cartella IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifica questo solo per recuperare la posta da una cartella diversa da INBOX',
        'Trusted' => 'Fidato',
        'Dispatching' => 'Smistamento',
        'Edit Mail Account' => 'Modifica account di posta',

        # Template: AdminNavigationBar
        'Admin' => 'Admin',
        'Agent Management' => 'Gestione agenti',
        'Queue Settings' => 'Impostazioni delle code',
        'Ticket Settings' => 'Impostazioni dei ticket',
        'System Administration' => 'Amministrazione di sistema',
        'Online Admin Manual' => 'Manuale di amministrazione in linea',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Gestione delle notifiche dei ticket',
        'Add notification' => 'Aggiungi notifica',
        'Export Notifications' => 'Esportazione notifiche',
        'Configuration Import' => 'Importazione configurazione',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Overwrite existing notifications?' => 'Vuoi sovrascrivere le notifiche esistenti?',
        'Upload Notification configuration' => 'Carica configurazione delle notifiche',
        'Import Notification configuration' => 'Importa configurazione delle notifiche',
        'Delete this notification' => 'Elimina questa notifica',
        'Do you really want to delete this notification?' => 'Vuoi davvero eliminare questa notifica?',
        'Add Notification' => 'Aggiungi notifica',
        'Edit Notification' => 'Modifica notifica',
        'Show in agent preferences' => 'Mostra nelle preferenze degli agenti',
        'Agent preferences tooltip' => 'Suggerimento preferenze agente',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'Filtro ticket',
        'Article Filter' => 'Filtro articoli',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => 'Tipo articolo',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => 'Tipologia del mittente dell\'articolo',
        'Subject match' => 'Corrispondenza dell\'oggetto',
        'Body match' => 'Match nel corpo mail ',
        'Include attachments to notification' => 'Includi allegati nella notifica',
        'Recipients' => 'Destinatari',
        'Send to' => 'Invia a',
        'Send to these agents' => 'Invia a questi agenti',
        'Send to all group members' => 'Invia a tutti i membri del gruppo',
        'Send to all role members' => 'Invia a tutti i membri del ruolo',
        'Send on out of office' => 'Invia se fuori sede',
        'Also send if the user is currently out of office.' => 'Invia anche se l\'utente è attualmente fuori sede.',
        'Once per day' => 'Una volta al giorno',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'Notification Methods' => 'Metodi di notifica',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => 'Abilita questo metodo di notifica',
        'Transport' => 'Trasporto',
        'At least one method is needed per notification.' => '',
        'Send by default' => 'Invia in modo predefinito',
        'Should the notification be sent to agents who have not yet made a choice in their preferences?' =>
            '',
        'This feature is currently not available.' => 'Questa funzionalità non è attualmente disponibile.',
        'No data found' => 'Nessun dato trovato',
        'No notification method found.' => 'Nessun metodo di notifica trovato.',
        'Notification Text' => 'Testo della notifica',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Questa lingua non è presente o abilitata sul sistema. Questo testo di notifica può essere eliminato se non più necessario. ',
        'Remove Notification Language' => 'Rimuovi lingua delle notifiche',
        'Message body' => 'Corpo del messaggio',
        'Add new notification language' => 'Aggiungi nuova lingua delle notifiche',
        'Do you really want to delete this notification language?' => 'Vuoi davvero eliminare questa lingua delle notifiche?',
        'Tag Reference' => '',
        'Notifications are sent to an agent or a customer.' => 'Le notifiche sono inviate ad un operatore o a un cliente',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Per avere i primi 20 caratteri mail - subject (agent) ',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Per avere le prime 5 righe corpo mail (agent).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Per avere i primi 20 caratteri mail - subject (customer).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Per avere le prime 5 righe corpo mail (customer).',
        'Attributes of the current customer user data' => 'Attributi dei dati utente del cliente attuale',
        'Attributes of the current ticket owner user data' => '',
        'Attributes of the current ticket responsible user data' => '',
        'Attributes of the current agent user who requested this action' =>
            'Attributi dell\'utente agente attuale che ha richiesto questa azione',
        'Attributes of the recipient user for the notification' => 'Attributi dell\'utente destinatario delle notifiche',
        'Attributes of the ticket data' => 'Attributi dei dati del ticket',
        'Ticket dynamic fields internal key values' => '',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Example notification' => 'Notifica di esempio',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Indirizzi email di destinazione aggiuntivi',
        'Notification article type' => 'Tipo di articolo di notifica',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Email template' => 'Modello di email',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Utilizza questo modello per generare l\'email completa (solo per email HTML).',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Gestisci %s',
        'Downgrade to OTRS Free' => 'Ritorna a OTRS Free',
        'Read documentation' => 'Leggi la documentazione',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s contatta regolarmente cloud.otrs.com per controllare la disponibilità di aggiornamenti e la validità del contratto sottostante.',
        'Unauthorized Usage Detected' => 'Rilevato utilizzo non autorizzato',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Questo sistema utilizza %s senza una licenza appropriata! Contatta %s per rinnovare o attivare il tuo contratto!',
        '%s not Correctly Installed' => '%s non è installato correttamente',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'Il tuo %s non è installato correttamente. Installalo nuovamente con il pulsante in basso.',
        'Reinstall %s' => 'Reinstalla %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'Il tuo %s non è installato correttamente, ed è disponibile anche un aggiornamento.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Puoi reinstallare la versione attuale o eseguire un aggiornamento con i pulsanti in basso (aggiornamento consigliato).',
        'Update %s' => 'Aggiorna %s',
        '%s Not Yet Available' => '%s non ancora disponibile',
        '%s will be available soon.' => '%s sarà presto disponibile.',
        '%s Update Available' => 'Aggiornamento %s disponibile',
        'An update for your %s is available! Please update at your earliest!' =>
            'È disponibile un aggiornamento per il tuo %s! Aggiorna appena puoi!',
        '%s Correctly Deployed' => '',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Congratulazioni, il tuo %s è installato correttamente e aggiornato!',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '%s sarà disponibile presto. Controlla nuovamente tra qualche giorno.',
        'Please have a look at %s for more information.' => 'Consulta %s per ulteriori informazioni.',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            'OTRS Free è la base per tutte le azioni future. Registrati prima di continuare con il processo di aggiornamento di %s!',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Prima di poter beneficiare di %s, contatta %s per ottenere il tuo contratto di %s.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'La connessione a cloud.otrs.com tramite HTTPS non può essere stabilita. Assicurati che il tuo OTRS possa connettersi a cloud.otrs.com tramite la porta 443.',
        'With your existing contract you can only use a small part of the %s.' =>
            'Con il tuo contratto esistente, puoi utilizzare solo una piccola parte di %s.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Se desideri trarre tutti i vantaggi da %s, aggiorna subito il tuo contratto! Contatta %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Annulla il downgrade e torna indietro',
        'Go to OTRS Package Manager' => 'Vai al gestore dei pacchetti di OTRS',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'Fornitore',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Disinstalla prima i pacchetti utilizzando il gestore dei pacchetti e prova ancora.',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'Chat',
        'Report Generator' => 'Generatore di resoconti',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => 'Finestra di selezione SLA',
        'Ticket Attachment View' => '',
        'The %s skin' => 'Il tema %s',

        # Template: AdminPGP
        'PGP Management' => 'Gestione PGP',
        'Use this feature if you want to work with PGP keys.' => 'Usa questa funzione se desideri lavorare con chiavi PGP.',
        'Add PGP key' => 'Aggiungi chiave PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'In questo modo puoi configurare direttamente il portachiavi PGP in SysConfig',
        'Introduction to PGP' => 'Introduzione a PGP',
        'Result' => 'Risultato',
        'Identifier' => 'Identificatore',
        'Bit' => 'Bit',
        'Fingerprint' => 'Impronta (fingerprint)',
        'Expires' => 'Scade',
        'Delete this key' => 'Elimina questa chiave',
        'Add PGP Key' => 'Aggiungi chiave PGP',
        'PGP key' => 'Chiave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestione Pacchetti',
        'Uninstall package' => 'Disinstalla pacchetto',
        'Do you really want to uninstall this package?' => 'Vuoi davvero disinstallare questo pacchetto?',
        'Reinstall package' => 'Reinstalla pacchetto',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Vuoi davvero reinstallare questo pacchetto? Ogni modifica manuale sarà persa.',
        'Continue' => 'Continua',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Installa',
        'Install Package' => 'Installa pacchetto',
        'Update repository information' => 'Aggiorna informazioni sui repository',
        'Online Repository' => 'Archivio Online',
        'Module documentation' => 'Documentazione sul modulo',
        'Upgrade' => 'Aggiorna',
        'Local Repository' => 'Archivio Locale',
        'This package is verified by OTRSverify (tm)' => 'Questo pacchetto è verificato da OTRSverify (tm)',
        'Uninstall' => 'rimuovi pacchetto',
        'Reinstall' => 'Re-installa',
        'Features for %s customers only' => 'Funzionalità solo per gli utenti %s',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Con %s, puoi beneficiare delle seguenti funzionalità opzionali. Contatta %s se hai bisogno di ulteriori informazioni.',
        'Download package' => 'Scarica pacchetto',
        'Rebuild package' => 'Ricostruisci pacchetto',
        'Metadata' => 'Metadati',
        'Change Log' => 'Storia delle Modifiche',
        'Date' => 'Data',
        'List of Files' => 'Lista dei file',
        'Permission' => 'Permessi',
        'Download' => 'Scarica',
        'Download file from package!' => 'Scarica file dal pacchetto!',
        'Required' => 'Richiesto',
        'PrimaryKey' => 'Chiave primaria',
        'AutoIncrement' => 'AutoIncremento',
        'SQL' => 'Limite',
        'File differences for file %s' => 'Differenze per il file %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log delle Performance',
        'This feature is enabled!' => 'Funzione abilitata',
        'Just use this feature if you want to log each request.' => 'Usa questa funzionalità per tracciare ogni richiesta.',
        'Activating this feature might affect your system performance!' =>
            'L\'attivazione di questa funzionalità può ridurre le prestazioni del sistema.',
        'Disable it here!' => 'Disabilita funzione qui',
        'Logfile too large!' => 'Log File troppo grande ',
        'The logfile is too large, you need to reset it' => 'Il file di log è troppo grande, è necessario un reset del file',
        'Overview' => 'Vista Globale',
        'Range' => 'Intervallo',
        'last' => 'ultimo',
        'Interface' => 'Interfaccia',
        'Requests' => 'Richieste',
        'Min Response' => 'Minimo per Risposta',
        'Max Response' => 'Massimo per Risposta',
        'Average Response' => 'Media per Risposta',
        'Period' => 'Periodo',
        'Min' => 'Minimo',
        'Max' => 'Massimo',
        'Average' => 'Media',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestione filtri posta in ingresso',
        'Add filter' => 'Aggiungi filtro',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Per gestire o filtrare email in entrata basandosi sugli header. È anche possibile usare espressioni regolari.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Se vuoi che corrisponda solo negli indirizzi di email , usa EMAILADDRESS:info@example.com in From, To or Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Se desideri usare espressioni regolari, puoi usare il valore corrispondente tra () come [***] nell\'azione \'Set\'.',
        'Delete this filter' => 'Elimina questo filtro',
        'Add PostMaster Filter' => 'Aggiungi filtro PostMaster',
        'Edit PostMaster Filter' => 'Modifica filtro PostMaster',
        'The name is required.' => 'Il nome è obbligatorio',
        'Filter Condition' => 'Condizione per il filtro',
        'AND Condition' => 'Condizione AND',
        'Check email header' => 'Controlla l\'intestazione dell\'email',
        'Negate' => 'Nega',
        'Look for value' => 'Cerca un valore',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Il campo deve essere una espressione regolare valida o una parola specifica.',
        'Set Email Headers' => 'Imposta intestazione dell\'email',
        'Set email header' => 'Imposta intestazione dell\'email',
        'Set value' => 'Imposta il valore',
        'The field needs to be a literal word.' => 'Il campo deve essere una parola specifica',

        # Template: AdminPriority
        'Priority Management' => 'Gestione Priorità',
        'Add priority' => 'Aggiungi Priorità',
        'Add Priority' => 'Aggiungi Priorità',
        'Edit Priority' => 'Modifica Priorità',

        # Template: AdminProcessManagement
        'Process Management' => 'Gestione dei processi',
        'Filter for Processes' => 'Filtra per Processo',
        'Create New Process' => 'Crea Nuovo Processo',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Qui è possibile importare un file di configurazione per importare un processo a sistema. Il file deve essere in formato .yml come esportato dal modulo di export della gestione processi',
        'Overwrite existing entities' => 'Sovrascrivi le entità esistenti',
        'Upload process configuration' => 'Carica la configurazione di processo',
        'Import process configuration' => 'Importa la configurazione di processo',
        'Example processes' => 'Processi di esempio',
        'Here you can activate best practice example processes that are part of %s. Please note that some additional configuration may be required.' =>
            '',
        'Import example process' => 'Importa processo di esempio',
        'Do you want to benefit from processes created by experts? Upgrade to %s to be able to import some sophisticated example processes.' =>
            'Vuoi beneficiare dei processi creati da esperti? Aggiorna a %s per poter importare alcuni processi di esempio sofisticati.',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Per creare un nuovo processo puoi importare un processo esportato da un altro sistema o crearne uno completamente nuovo.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'I cambiamenti al processo sono riportati a sistema solo se effettuate la sincronizzazione. Con la sincronizzazione le modifiche sono scritte nella configurazione.',
        'Processes' => 'Processi',
        'Process name' => 'Nome del processo',
        'Print' => 'Stampa',
        'Export Process Configuration' => 'Esporta la configurazione del processo',
        'Copy Process' => 'Copia il Processo',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Annulla e chiudi',
        'Go Back' => 'Indietro',
        'Please note, that changing this activity will affect the following processes' =>
            'Attenzione, i cambiamenti a questa attività influenzano i seguenti processi',
        'Activity' => 'Attività',
        'Activity Name' => 'Nome dell\'attività',
        'Activity Dialogs' => 'Interazioni dell\'attività',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Puoi assegnare le interazioni dell\'attività trascinando gli elementi con il mouse dalla lista di sinistra a quella di destra.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Puoi ordinare gli elementi dell\'elenco anche attraverso il trascinamento.',
        'Filter available Activity Dialogs' => 'Imposta un filtro alle interazioni delle attività disponibili.',
        'Available Activity Dialogs' => 'Interazioni dell\'attività disponibili',
        'Create New Activity Dialog' => 'Crea una nuova interazione per l\'attività',
        'Assigned Activity Dialogs' => 'Interazioni per l\'attività assegnati',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Non appena utilizzi il pulsante o il collegamento, abbandonerai questa schermata e lo stato corrente sarà salvato in automatico. Vuoi continuare?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Attenzione, i cambiamenti a questo messaggio delle attività influenzano le seguenti attività',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => 'messaggio dell\'attività',
        'Activity dialog Name' => 'Nome per messaggio dell\'attività',
        'Available in' => 'Disponibile in',
        'Description (short)' => 'Descrizione (breve)',
        'Description (long)' => 'Descrizione (estesa)',
        'The selected permission does not exist.' => 'Il permesso selezionato non esiste.',
        'Required Lock' => 'Blocco richiesto',
        'The selected required lock does not exist.' => 'Il lock richiesto e selezionato non esiste.',
        'Submit Advice Text' => 'Testo per i suggerimenti di invio',
        'Submit Button Text' => 'Testo per il bottone di invio',
        'Fields' => 'Campi',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Puoi assegnare campi a questo messaggio di attività trascinando gli elementi con il mouse dalla lista di sinistra a quella di destra.',
        'Filter available fields' => 'Filtro sui campi disponibili',
        'Available Fields' => 'Campi disponibili',
        'Assigned Fields' => 'Campi assegnati',
        'ArticleType' => 'Tipologia Articolo',
        'Display' => 'Mostra',
        'Edit Field Details' => 'Modifica i dettagli per il campo',
        'Customer interface does not support internal article types.' => 'L\'interfaccia cliente non supporta i tipi di articoli interni.',

        # Template: AdminProcessManagementPath
        'Path' => 'percorso',
        'Edit this transition' => 'Modifica questa transizione',
        'Transition Actions' => 'Azioni di transizione',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Puoi assegnare azioni di transizione a questo transizione trascinando gli elementi con il mouse dalla lista di sinistra a quella di destra.',
        'Filter available Transition Actions' => 'Filtra sulle azioni di transizioni disponibili',
        'Available Transition Actions' => 'Azioni di transizione disponibili',
        'Create New Transition Action' => 'Crea nuova azione di transizione',
        'Assigned Transition Actions' => 'Azione di transizione assegnate',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Attività',
        'Filter Activities...' => 'Filtra attività...',
        'Create New Activity' => 'Crea nuova attività...',
        'Filter Activity Dialogs...' => 'Filtra le interazioni dell\'attività',
        'Transitions' => 'Transizioni',
        'Filter Transitions...' => 'Filtra sulle transizioni...',
        'Create New Transition' => 'Crea Nuova Transizione',
        'Filter Transition Actions...' => 'Filtra sulle azioni di transizione',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Modifica Processo',
        'Print process information' => 'Stampa le informazioni del processo',
        'Delete Process' => 'Elimina processo',
        'Delete Inactive Process' => 'Elimina processo inattivo',
        'Available Process Elements' => 'Elementi di Processo disponibili',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Gli elementi presenti sopra questa barra possono essere spostati nel riquadro a destra trascinandoli.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Puoi immettere Attività nel riquadro per assegnare l\'Attività al Processo',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Per assegnare un messaggio di attività ad una attività trascinare il messaggio dalla barra sopra l\'attività nel riquadro.',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Puoi effettuare una connessione tra le attività trascinando gli elementi di transizione sulla attività iniziale. Successivamente puoi spostare l\'estremità libera sulla attività finale.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Le azioni possono essere assegnate ad una transizione trascinando l\'elemento sulla descrizione della trascrizione.',
        'Edit Process Information' => 'Modifica le informazioni del Processo',
        'Process Name' => 'Nome del Processo',
        'The selected state does not exist.' => 'Lo stato selezionato non esiste.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Aggiungi e modifica le attività, le interazioni delle attività e le transizioni',
        'Show EntityIDs' => 'Mostra gli identificativi EntityID',
        'Extend the width of the Canvas' => 'Aumenta la larghezza del riquadro',
        'Extend the height of the Canvas' => 'Aumenta l\'altezza del riquadro',
        'Remove the Activity from this Process' => 'Rimuovi l\'attività dal Processo',
        'Edit this Activity' => 'Modifica questa attività',
        'Save settings' => 'Salva impostazioni',
        'Save Activities, Activity Dialogs and Transitions' => 'Salva attività, finestre di attività e transizioni',
        'Do you really want to delete this Process?' => 'Vuoi davvero eliminare questo processo?',
        'Do you really want to delete this Activity?' => 'Vuoi davvero eliminare questa attività?',
        'Do you really want to delete this Activity Dialog?' => 'Vuoi davvero eliminare questa finestra dell\'attività?',
        'Do you really want to delete this Transition?' => 'Vuoi davvero eliminare questa transizione?',
        'Do you really want to delete this Transition Action?' => 'Vuoi davvero eliminare questa azione di transizione?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Vuoi davvero rimuovere questa attività dal riquadro? Ciò può essere annullato solo uscendo dalla schermata senza salvare.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Vuoi davvero rimuovere questa transizione dal riquadro? Ciò può essere annullato solo uscendo dalla schermata senza salvare.',
        'Hide EntityIDs' => 'Nascondi EntityID',
        'Delete Entity' => 'Elimina entità',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Questa attività è già in uso nel Processo. Non puoi aggiungerla due volte!.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Questa attività non può essere eliminata perché è l\'attività iniziale.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Questa Transizione è già utilizzata per questa Attività. Non puoi aggiungerla due volte!.',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Questa Azione di Transizione è già in uso in questo percorso. Non puoi usarla due volte!.',
        'Remove the Transition from this Process' => 'Rimuovi la transizione da questo processo',
        'No TransitionActions assigned.' => 'Non ci sono Azioni di Transizione Assegnate.',
        'The Start Event cannot loose the Start Transition!' => 'L\'evento di inizio non può perdere la Transizione d\'inizio!',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Non ci sono interazioni assegnate. Seleziona un messaggio dall\'elenco a sinistra e trascinalo qui.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'In questa schermata puoi creare un nuovo processo. Per rendere il nuovo processo disponibile agli utenti, occorre mettere lo stato in \'Attivo\' ed effettuare la sincronizzazione al termine del lavoro.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Avvia attività',
        'Contains %s dialog(s)' => 'Contiene %s finestra(e)',
        'Assigned dialogs' => 'Finestre assegnate',
        'Activities are not being used in this process.' => 'Le attività non sono utilizzate in questo processo.',
        'Assigned fields' => 'Campi assegnati',
        'Activity dialogs are not being used in this process.' => 'Le finestre di attività non sono utilizzate in questo processo.',
        'Condition linking' => '',
        'Conditions' => 'Condizioni',
        'Condition' => 'Condizione',
        'Transitions are not being used in this process.' => 'Le transizioni non sono utilizzate in questo processo.',
        'Module name' => 'Nome del modulo',
        'Transition actions are not being used in this process.' => 'Le azioni di transizione non sono utilizzate in questo processo.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Attenzione, i cambiamenti a questa transizione impattano sui seguenti processi',
        'Transition' => 'Transizione',
        'Transition Name' => 'Nome della Transizione',
        'Type of Linking between Conditions' => 'Tipo del collegamento tra le Condizioni',
        'Remove this Condition' => 'Rimuovi questa Condizione',
        'Type of Linking' => 'Tipo di Collegamento',
        'Add a new Field' => 'Aggiungi un nuovo campo',
        'Remove this Field' => 'Rimuovi questo campo',
        'And can\'t be repeated on the same condition.' => 'E non può essere ripetuto nella stessa condizione.',
        'Add New Condition' => 'Aggiungi nuova condizione',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Attenzione, i cambiamenti a questa azione di transizione impattano sui seguenti processi',
        'Transition Action' => 'Azione di Transizione',
        'Transition Action Name' => 'Nome dell\'azione di transizione',
        'Transition Action Module' => 'Modulo per l\'azione di transizione',
        'Config Parameters' => 'parametri di configurazione',
        'Add a new Parameter' => 'Aggiungi un nuovo parametro',
        'Remove this Parameter' => 'Rimuovi questo parametro',

        # Template: AdminQueue
        'Manage Queues' => 'Gestione code',
        'Add queue' => 'Aggiungi coda',
        'Add Queue' => 'Aggiungi coda',
        'Edit Queue' => 'Modifica coda',
        'A queue with this name already exists!' => 'Una coda con questo nome esiste già!',
        'Sub-queue of' => 'Sotto-coda di',
        'Unlock timeout' => 'Tempo di sblocco automatico',
        '0 = no unlock' => '0 = nessuno sblocco automatico',
        'Only business hours are counted.' => 'Sono considerate solo le ore lavorative.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Se un agente prende in carico un ticket e non lo chiude prima dello sblocco automatico, il ticket viene sbloccato e diventa disponibile per altri agenti.',
        'Notify by' => 'Notificato da',
        '0 = no escalation' => '0 = nessuna escalation',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Se non c\'è un nuovo contatto con il cliente, sia per email che per telefono per un ticket nuovo, prima che il tempo qui definito scada, il ticket viene scalato',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Se c\'è un articolo aggiunto, come un follow-up o il portale cliente, il tempo di aggiornamento di scalo viene azzerato. Se non c\'è un contatto con il cliente, sia per posta che per telefono, aggiunto al ticket prima che scada il tempo definito qui, il ticket viene scalato.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Se il ticket non viene impostato a chiuso prima che scada il tempo qui definito, il ticket viene scalato.',
        'Follow up Option' => 'Opzioni per i follow-up',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Specifica se i follow-up ai ticket chiusi riaprono i ticket, vengono respinti o portano a un nuovo ticket.',
        'Ticket lock after a follow up' => 'Blocco del ticket dopo una prosecuzione',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Se un ticket viene chiuso e il cliente manda un follow-up, il ticket sarà preso in carica dal vecchio proprietario.',
        'System address' => 'Indirizzo di sistema',
        'Will be the sender address of this queue for email answers.' => 'Mittente utilizzato per le risposte relative alle richieste di questa coda.',
        'Default sign key' => 'Chiave di default per le firme',
        'The salutation for email answers.' => 'Saluto (parte iniziale) per le email generate automaticamente dal sistema.',
        'The signature for email answers.' => 'Firma (parte finale) per le email generate automaticamente dal sistema.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gestisci relazioni Coda-Risposte automatiche',
        'Filter for Queues' => 'Filtri per le code',
        'Filter for Auto Responses' => 'Filtri per le risposte automatiche',
        'Auto Responses' => 'Risposte Automatiche',
        'Change Auto Response Relations for Queue' => 'Cambia le relazioni delle risposte automatiche con la coda',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => 'Filtro per modelli',
        'Templates' => 'Modelli',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRegistration
        'System Registration Management' => 'Gestione della registrazione del sistema',
        'Edit details' => 'Modifica i dettagli',
        'Show transmitted data' => 'Mostra i dati trasmessi',
        'Deregister system' => 'Cancella registrazione sistema',
        'Overview of registered systems' => 'Riepilogo dei sistemi registrati',
        'This system is registered with OTRS Group.' => 'Questo sistema è registrato con OTRS Group.',
        'System type' => 'Tipo di sistema',
        'Unique ID' => 'ID univoco',
        'Last communication with registration server' => 'Ultima comunicazione con il server di registrazione',
        'System registration not possible' => 'La registrazione del sistema non è possibile',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Nota che non puoi registrare il tuo sistema se OTRS Daemon non è correttamente in esecuzione!',
        'Instructions' => 'Istruzioni',
        'System deregistration not possible' => 'Cancellazione della registrazione di sistema non possibile',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Nota che non puoi cancellare la registrazione del tuo sistema se stai utilizzando %s o hai un contratto di servizio valido.',
        'OTRS-ID Login' => 'Accesso OTRS-ID',
        'Read more' => 'Leggi altro',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Devi accedere con il tuo OTRS-ID per registrare il tuo sistema.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Il tuo OTRS-ID è l\'indirizzo email che hai utilizzato per registrarti sulla pagina web di OTRS.com.',
        'Data Protection' => 'Protezione dati',
        'What are the advantages of system registration?' => 'Quali sono i vantaggi della registrazione del sistema?',
        'You will receive updates about relevant security releases.' => 'Riceverai aggiornamenti sui rilascio di sicurezza importanti.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Con la registrazione del sistema, possiamo migliorare il nostro servizio per te, poiché abbiamo la disponibilità di tutte le informazioni rilevanti.',
        'This is only the beginning!' => 'Questo è solo l\'inizio!',
        'We will inform you about our new services and offerings soon.' =>
            'Ti informeremo sui nostri nuovi servizi e sulle offerte in arrivo.',
        'Can I use OTRS without being registered?' => 'Posso utilizzare OTRS senza essere registrato?',
        'System registration is optional.' => 'La registrazione del sistema è facoltativa.',
        'You can download and use OTRS without being registered.' => 'Puoi scaricare e utilizzare OTRS senza essere registrato.',
        'Is it possible to deregister?' => 'È possibile cancellare la registrazione?',
        'You can deregister at any time.' => 'Puoi cancellare la registrazione in qualsiasi momento.',
        'Which data is transfered when registering?' => 'Quali dati sono trasferiti con la registrazione?',
        'A registered system sends the following data to OTRS Group:' => 'Un sistema registrato invia i dati seguenti a OTRS Group:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Nome di dominio qualificato (FQDN), versione OTRS, database, sistema operativo e versione Perl.',
        'Why do I have to provide a description for my system?' => 'Perché devo fornire una descrizione del mio sistema?',
        'The description of the system is optional.' => 'La descrizione del sistema è facoltativa.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'La descrizione e il tipo di sistema che specifichi ti aiutano a identificare e gestire i dettagli dei tuoi sistemi registrati.',
        'How often does my OTRS system send updates?' => 'Quanto spesso il mio sistema OTRS invia aggiornamenti?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Il tuo server invierà aggiornamenti al server di registrazione a intervalli regolari.',
        'Typically this would be around once every three days.' => 'Normalmente dovrebbe avvenire una volta ogni tre giorni.',
        'In case you would have further questions we would be glad to answer them.' =>
            'Nel caso dovessi avere altre domande, saremo felici di risponderti.',
        'Please visit our' => 'Visita il nostro',
        'portal' => 'portale',
        'and file a request.' => 'e crea una richiesta.',
        'If you deregister your system, you will lose these benefits:' =>
            'Se cancelli la registrazione del tuo sistema, perderai questi vantaggi:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Devi accedere con il tuo OTRS-ID per cancellare la registrazione del tuo sistema.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Non hai ancora un OTRS-ID?',
        'Sign up now' => 'Registrazione',
        'Forgot your password?' => 'Hai dimenticato la password?',
        'Retrieve a new one' => 'Ottienine uno nuovo',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Questi dati saranno trasferiti frequentemente a OTRS Group quando registri questo sistema.',
        'Attribute' => 'Attributo',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'Versione OTRS',
        'Operating System' => 'Sistema operativo',
        'Perl Version' => 'Versione di Perl',
        'Optional description of this system.' => 'Descrizione facoltativa del sistema.',
        'Register' => 'Registra',
        'Deregister System' => 'Cancella registrazione sistema',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Se si prosegue con questo passaggio, la registrazione del sistema sarà cancellata da OTRS Group.',
        'Deregister' => 'Cancella registrazione',
        'You can modify registration settings here.' => 'Puoi modificare qui le impostazioni di registrazione.',
        'Overview of transmitted data' => 'Riepilogo dei dati trasmessi',
        'There is no data regularly sent from your system to %s.' => 'Non ci sono dati inviati regolarmente dal tuo sistema a %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'I seguenti dati sono inviati almeno ogni 3 giorni dal tuo sistema a %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'I dati saranno trasferiti in formato JSON tramite una connessione sicura HTTPS.',
        'System Registration Data' => 'Dati di registrazione del sistema',
        'Support Data' => 'Dati di supporto',

        # Template: AdminRole
        'Role Management' => 'Gestione ruoli',
        'Add role' => 'Aggiungi ruolo',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Crea un ruolo e mettici i gruppi. Poi aggiungi il ruolo agli utenti.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Non ci sono ruoli definiti. Usa il tasto Aggiungi per crearne uno nuovo.',
        'Add Role' => 'Aggiungi Ruolo',
        'Edit Role' => 'Modifica ruolo',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gestione relazioni ruolo-gruppo',
        'Filter for Roles' => 'Filtri per i ruoli',
        'Roles' => 'Ruoli',
        'Select the role:group permissions.' => 'Seleziona i permessi ruolo:gruppo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Se non si seleziona niente, non ci sono permessi in questo gruppo (i ticket non saranno disponibili per questo ruolo).',
        'Change Role Relations for Group' => 'Cambia le relazioni del ruolo per il gruppo',
        'Change Group Relations for Role' => 'Cambia le relazioni del gruppo per il ruolo',
        'Toggle %s permission for all' => 'Imposta il permesso %s per tutti',
        'move_into' => 'muovi_in',
        'Permissions to move tickets into this group/queue.' => 'Autorizzazione a muovere richieste in questo gruppo/coda',
        'create' => 'crea',
        'Permissions to create tickets in this group/queue.' => 'Permessi per creare richieste in questo gruppo/coda.',
        'note' => 'Annotazioni',
        'Permissions to add notes to tickets in this group/queue.' => 'Permesso di aggiungere note ai ticket in questo gruppo/coda.',
        'owner' => 'gestore',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permessi per cambiare il gestore dei ticket in questo gruppo/coda.',
        'priority' => 'priorità',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Autorizzazione a cambiare la priorità di un ticket in questo gruppo/coda.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gestione relazioni agente-ruolo',
        'Add agent' => 'Aggiungi agente',
        'Filter for Agents' => 'Filtro per gli agenti',
        'Agents' => 'Agenti',
        'Manage Role-Agent Relations' => 'Gestione relazioni ruolo-agente',
        'Change Role Relations for Agent' => 'Cambia relazioni di ruolo per l\'agente',
        'Change Agent Relations for Role' => 'Cambia relazioni di agente per il ruolo',

        # Template: AdminSLA
        'SLA Management' => 'Gestione SLA',
        'Add SLA' => 'Aggiungi SLA',
        'Edit SLA' => 'Modifica SLA',
        'Please write only numbers!' => 'Usa solo numeri!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestione S/MIME ',
        'Add certificate' => 'Aggiungi certificato',
        'Add private key' => 'Aggiungi chiave privata',
        'Filter for certificates' => 'Filtro per i certificati',
        'Filter for S/MIME certs' => 'Filtro per i certificati S/MIME',
        'To show certificate details click on a certificate icon.' => 'Per mostrare i dettagli del certificato, fai clic sull\'icona del certificato.',
        'To manage private certificate relations click on a private key icon.' =>
            'Per gestire le relazione del certificato privato, fai clic sull\'icona di una chiave privata.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Vedi anche',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Puoi modificare il certificato e la chiave privata direttamente sul filesystem.',
        'Hash' => 'Puoi modificare il certificato e la chiave privata direttamente sul filesystem.',
        'Handle related certificates' => 'Gestisci i certificati collegati',
        'Read certificate' => 'leggi il certificato',
        'Delete this certificate' => 'Elimina questo certificato',
        'Add Certificate' => 'Aggiungi certificato',
        'Add Private Key' => 'Aggiunti chiave privata',
        'Secret' => 'Segreto',
        'Related Certificates for' => 'Certificato collegato a',
        'Delete this relation' => 'Elimina questa relazione',
        'Available Certificates' => 'Certificati disponibili',
        'Relate this certificate' => 'Collegati a questo certificato',

        # Template: AdminSMIMECertRead
        'Certificate details' => 'Dettagli del certificato',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestione saluti',
        'Add salutation' => 'Aggiungi saluto',
        'Add Salutation' => 'Aggiungi saluto',
        'Edit Salutation' => 'Modifica saluto',
        'e. g.' => 'es.',
        'Example salutation' => 'Saluto di esempio',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'È necessario abilitare la modalità sicura!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'La modalità sicura (normalmente) viene abilitata dopo il completamento installazione.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Se non è attivata la modalità sicura, attivarla tramite SySConfig perché il programma è già in esecuzione.',

        # Template: AdminSelectBox
        'SQL Box' => 'script SQL ',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Qui è possibile inserire SQL per inviarlo direttamente al database.',
        'Only select queries are allowed.' => 'Sono consentite solo query di selezione.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'La sintassi della query SQL è sbagliata.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'C\'è almeno un parametro mancante per il binding. Controlla.',
        'Result format' => 'Formato dei risultati',
        'Run Query' => 'Esegui query',
        'Query is executed.' => 'La query è eseguita.',

        # Template: AdminService
        'Service Management' => 'Gestione Servizi',
        'Add service' => 'Aggiungi servizio',
        'Add Service' => 'inserisci un servizio',
        'Edit Service' => 'Modifica servizio',
        'Sub-service of' => 'Sotto-servizio di',

        # Template: AdminSession
        'Session Management' => 'Gestione Sessioni',
        'All sessions' => 'Tutte le sessioni',
        'Agent sessions' => 'Sessioni degli agenti',
        'Customer sessions' => 'Sessioni dei clienti',
        'Unique agents' => 'Agenti unici',
        'Unique customers' => 'Clienti unici',
        'Kill all sessions' => 'termina tutte le sessioni',
        'Kill this session' => 'Termina questa sessione',
        'Session' => 'Sessione',
        'Kill' => 'Termina',
        'Detail View for SessionID' => 'Visualizza dettagli per SessionID',

        # Template: AdminSignature
        'Signature Management' => 'Gestione firme digitali',
        'Add signature' => 'Aggiungi firma',
        'Add Signature' => 'Aggiungi Firma',
        'Edit Signature' => 'Modifica firma',
        'Example signature' => 'Firma di esempio',

        # Template: AdminState
        'State Management' => 'Gestione Stati',
        'Add state' => 'Aggiungi stato',
        'Please also update the states in SysConfig where needed.' => 'Aggiorna anche gli stati in SysConfig, dove necessario.',
        'Add State' => 'inserisci stato',
        'Edit State' => 'Modifica stato',
        'State type' => 'Tipo di stato',

        # Template: AdminSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => 'Invia aggiornamento',
        'Sending Update...' => 'Invio aggiornamenti in corso...',
        'Support Data information was successfully sent.' => 'Informazioni dei dati di supporto inviate correttamente.',
        'Was not possible to send Support Data information.' => 'Non è stato possibile inviare le informazioni dei dati di supporto.',
        'Update Result' => 'Aggiorna risultati',
        'Currently this data is only shown in this system.' => 'Attualmente questi dati sono mostrati solo in questo sistema.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => 'Il messaggio non può essere inviato',
        'The support bundle has been generated.' => '',
        'Please choose one of the following options.' => 'Scegli una delle seguenti opzioni.',
        'Send by Email' => 'Invia tramite posta',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => 'Mittente',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => 'Scarica file',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => 'Errore: i dati di supporto non possono essere collezionati (%s).',
        'Details' => 'Dettagli',

        # Template: AdminSysConfig
        'SysConfig' => 'Configurazione Sistema',
        'Navigate by searching in %s settings' => 'Naviga cercando nelle impostazioni di %s',
        'Navigate by selecting config groups' => 'Naviga selezionando i gruppi di configurazione',
        'Download all system config changes' => 'Scarica tutti i cambiamenti alla configurazione di sistema',
        'Export settings' => 'Esporta impostazioni',
        'Load SysConfig settings from file' => 'Carica impostazioni di SysConfig da file',
        'Import settings' => 'Importa configurazione',
        'Import Settings' => 'Importa configurazione',
        'Please enter a search term to look for settings.' => 'Inserire una chiave di ricerca per trovare impostazioni.',
        'Subgroup' => 'Sottogruppi',
        'Elements' => 'Elementi',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Modifica impostazioni di configurazione',
        'This setting is read only.' => 'Questa impostazione è in sola lettura.',
        'This config item is only available in a higher config level!' =>
            'Questa configurazione è solo disponibile a livelli più alti!',
        'Reset this setting' => 'Reimposta questa opzione',
        'Error: this file could not be found.' => 'Errore: impossibile trovare questo file.',
        'Error: this directory could not be found.' => 'Errore: impossibile trovare questa cartella.',
        'Error: an invalid value was entered.' => 'Errore: Sono stati inseriti dati non validi.',
        'Content' => 'Contenuto',
        'Remove this entry' => 'Rimuovi questa entry',
        'Add entry' => 'Aggiungi entry',
        'Remove entry' => 'Rimuovi entry',
        'Add new entry' => 'Aggiungi nuova entry',
        'Delete this entry' => 'Elimina questa voce',
        'Create new entry' => 'Crea nuova entry',
        'New group' => 'Nuovo gruppo',
        'Group ro' => 'Gruppo RO',
        'Readonly group' => 'Gruppo sola lettura',
        'New group ro' => 'Nuovo gruppo RO',
        'Loader' => 'Caricatore',
        'File to load for this frontend module' => 'File da caricare per questo modulo di frontend',
        'New Loader File' => 'Nuovo file caricatore',
        'NavBarName' => 'NomeBarraNav',
        'NavBar' => 'BarraNav',
        'LinkOption' => 'Opzione collegamento',
        'Block' => 'Blocco',
        'AccessKey' => 'ChiaveAccesso',
        'Add NavBar entry' => 'Aggiungi entry BarraNav',
        'Year' => 'Anno',
        'Month' => 'Mese',
        'Day' => 'Giorno',
        'Invalid year' => 'Anno invalido',
        'Invalid month' => 'Mese invalido',
        'Invalid day' => 'Giorno invalido',
        'Show more' => 'Mostra altro',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestione indirizzi Email di sistema',
        'Add system address' => 'Aggiungi indirizzo di sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Tutta la posta in entrata con questo indirizzo in A: o Cc: verrà inoltrata alla coda selezionata.',
        'Email address' => 'Indirizzo email',
        'Display name' => 'Nome visibile',
        'Add System Email Address' => 'Aggiungi indirizzo email di sistema',
        'Edit System Email Address' => 'Modifica indirizzo email di sistema',
        'The display name and email address will be shown on mail you send.' =>
            'Il nome visualizzato e l\'indirizzo email verranno visualizzati sulle email inviate da qui.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Gestione delle manutenzioni del sistema',
        'Schedule New System Maintenance' => 'Pianifica nuova manutenzione di sistema',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Start date' => 'Data di inizio',
        'Stop date' => 'Data di fine',
        'Delete System Maintenance' => 'Elimina manutenzione di sistema',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Vuoi davvero eliminare questa manutenzione di sistema pianificata?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Modifica manutenzione di sistema %s',
        'Edit System Maintenance information' => 'Modifica informazioni di manutenzione del sistema',
        'Date invalid!' => 'Data invalida!',
        'Login message' => 'Messaggio all\'accesso',
        'Show login message' => 'Mostra messaggio all\'accesso',
        'Notify message' => 'Messaggio di notifica',
        'Manage Sessions' => 'Gestisci sessioni',
        'All Sessions' => 'Tutte le sessioni',
        'Agent Sessions' => 'Sessioni agenti',
        'Customer Sessions' => 'Sessioni clienti',
        'Kill all Sessions, except for your own' => 'Termina tutte le sessioni, eccetto la tua',

        # Template: AdminTemplate
        'Manage Templates' => 'Gestisci modelli',
        'Add template' => 'Aggiungi modello',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => 'Non dimenticare di aggiungere nuovi modelli alle code.',
        'Add Template' => 'Aggiungi modello',
        'Edit Template' => 'Modifica modello',
        'A standard template with this name already exists!' => 'Un modello standard con questo nome esiste già!',
        'Create type templates only supports this smart tags' => '',
        'Example template' => 'Modello di esempio',
        'The current ticket state is' => 'Lo stato attuale del ticket è',
        'Your email address is' => 'Il tuo indirizzo email è',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Gestione modelli <-> Relazioni allegati',
        'Filter for Attachments' => 'Filtro per gli allegati',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Imposta attivo per tutti',
        'Link %s to selected %s' => 'Collega %s a %s selezionato',

        # Template: AdminType
        'Type Management' => 'Gestione tipologie',
        'Add ticket type' => 'Aggiungi tipo di ticket',
        'Add Type' => 'Aggiungi tipo',
        'Edit Type' => 'Modifica tipo',
        'A type with this name already exists!' => 'Un tipo con questo nome esiste già!',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'Gli agenti serviranno a gestire i ticket.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Non dimenticare di aggiungere gli agenti nuovi ai gruppo e/o ai ruoli!',
        'Please enter a search term to look for agents.' => 'Inserisci una chiave di ricerca per trovare agenti.',
        'Last login' => 'Ultimo accesso',
        'Switch to agent' => 'Cambia ad agente',
        'Add Agent' => 'Aggiungi agente',
        'Edit Agent' => 'Modifica agente',
        'Firstname' => 'Nome',
        'Lastname' => 'Cognome',
        'A user with this username already exists!' => 'Un utente con questo nome esiste già!',
        'Will be auto-generated if left empty.' => 'Sarà generato automaticamente se lasciato vuoto.',
        'Start' => 'Inizio',
        'End' => 'Fine',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gestisci relazioni Agente-Gruppo',
        'Change Group Relations for Agent' => 'Cambia relazioni di gruppo per l\'agente',
        'Change Agent Relations for Group' => 'Cambia relazioni di agente per il gruppo',

        # Template: AgentBook
        'Address Book' => 'Rubrica',
        'Search for a customer' => 'Ricerca cliente',
        'Add email address %s to the To field' => 'Aggiungi indirizzo email %s al campo A:',
        'Add email address %s to the Cc field' => 'Aggiungi indirizzo email %s al campo Cc:',
        'Add email address %s to the Bcc field' => 'Aggiungi indirizzo email %s al campo Bcc:',
        'Apply' => 'Applica',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro Informazioni Cliente',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Clienti',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Voce duplicata',
        'This address already exists on the address list.' => 'Questo indirizzo esiste già nell\'elenco.',
        'It is going to be deleted from the field, please try again.' => 'Sta per essere eliminato dal campo, riprova.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: il cliente non è valido!',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTRS Daemon è un processo demone che esegue operazioni asincrone, ad es. trigger dell\'escalation dei ticket, invio delle email, ecc.',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'Un OTRS Daemon in esecuzione è obbligatorio per una corretta operatività del sistema.',
        'Starting the OTRS Daemon' => 'Avvio di OTRS Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            '',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'Dopo 5 minuti, controlla che OTRS Daemon sia in esecuzione nel sistema (\'bin/otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Cruscotto',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardCommon
        'Available Columns' => 'Colonne disponibili',
        'Visible Columns (order by drag & drop)' => 'Colonne visibili (ordina con trascinamento e rilascio)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Informazioni sul Cliente',
        'Phone ticket' => 'Ticket da Telefonata',
        'Email ticket' => 'Ticket da Email',
        'Start Chat' => 'Avvia chat',
        '%s open ticket(s) of %s' => '%s Ticket aperti su %s',
        '%s closed ticket(s) of %s' => '%s Ticket chiusi su %s',
        'New phone ticket from %s' => 'Nuovo Ticket telefonico da %s',
        'New email ticket to %s' => 'Nuovo Ticket via email da %s',
        'Start chat' => 'Avvia chat',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s è disponibile!',
        'Please update now.' => 'Aggiorna ora.',
        'Release Note' => 'Nota di rilascio',
        'Level' => 'Livello',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Inviato %s giorni fa.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '',
        'Download as SVG file' => 'Scarica come file SVG',
        'Download as PNG file' => 'Scarica come file PNG',
        'Download as CSV file' => 'Scarica come file CSV',
        'Download as Excel file' => 'Scarica come file Excel',
        'Download as PDF file' => 'Scarica come file PDF',
        'Grouped' => '',
        'Stacked' => '',
        'Expanded' => '',
        'Stream' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Ticket assegnati a me',
        'My watched tickets' => 'Ticket che sorveglio',
        'My responsibilities' => 'Ticket di cui sono responsabile',
        'Tickets in My Queues' => 'Ticket nelle mie code',
        'Tickets in My Services' => 'Ticket nei miei servizi',
        'Service Time' => 'Tempo di servizio',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Totali',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fuori sede',
        'Selected agent is not available for chat' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'Fino a',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Il Ticket è stato assegnato',
        'Undo & close' => 'Annulla e chiudi',

        # Template: AgentInfo
        'Info' => 'Informazioni',
        'To accept some news, a license or some changes.' => 'Accettare delle news, una licenza o dei cambiamenti.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Collega oggetto : %s ',
        'go to link delete screen' => 'vai alla schermata di eliminazione del collegamento',
        'Select Target Object' => 'Seleziona oggetto di destinazione',
        'Link Object' => 'Collega oggetto',
        'with' => 'con',
        'Unlink Object: %s' => 'Scollega oggetto: %s ',
        'go to link add screen' => 'vai alla schermata di aggiunta del collegamento',

        # Template: AgentPreferences
        'Edit your preferences' => 'Modifica preferenze',
        'Did you know? You can help translating OTRS at %s.' => 'Lo sapevi? Puoi collaborare alla traduzione di OTRS su %s.',

        # Template: AgentSpelling
        'Spell Checker' => 'Controllo ortografico',
        'spelling error(s)' => 'Errori di ortografia',
        'Apply these changes' => 'Applica le modifiche',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => 'Statistiche » Aggiungi',
        'Add New Statistic' => 'Aggiungi nuova statistica',
        'Dynamic Matrix' => 'Matrice dinamica',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            '',
        'Dynamic List' => 'Elenco dinamico',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            '',
        'Static' => 'Statico',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            '',
        'General Specification' => '',
        'Create Statistic' => 'Crea statistica',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => 'Statistiche » Modifica %s%s — %s',
        'Run now' => 'Esegui ora',
        'Statistics Preview' => 'Anteprima statistiche',
        'Save statistic' => 'Salva statistica',

        # Template: AgentStatisticsImport
        'Statistics » Import' => 'Statistiche » Importa',
        'Import Statistic Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => 'Statistiche » Riepilogo',
        'Statistics' => 'Statistiche',
        'Run' => 'Esegui',
        'Edit statistic "%s".' => 'Modifica la statistica "%s".',
        'Export statistic "%s"' => 'Esporta statistica "%s"',
        'Export statistic %s' => 'Esporta statistica %s',
        'Delete statistic "%s"' => 'Elimina la statistica "%s"',
        'Delete statistic %s' => 'Elimina la statistica %s',
        'Do you really want to delete this statistic?' => 'Vuoi davvero eliminare questa statistica?',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => 'Statistiche » Visualizza %s%s — %s',
        'Statistic Information' => 'Informazioni statistica',
        'Sum rows' => 'Somma le righe',
        'Sum columns' => 'somma le colonne',
        'Show as dashboard widget' => 'Mostra come oggetto del cruscotto',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s' => '',
        'Change Owner of %s%s' => '',
        'Close %s%s' => 'Chiudi %s%s',
        'Add Note to %s%s' => 'Aggiungi nota a %s%s',
        'Set Pending Time for %s%s' => '',
        'Change Priority of %s%s' => '',
        'Change Responsible of %s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => '',
        'Service invalid.' => 'Servizio non valido.',
        'New Owner' => 'Nuovo Gestore',
        'Please set a new owner!' => 'Imposta un nuovo proprietario!',
        'New Responsible' => 'Nuovo responsabile',
        'Next state' => 'Stato successivo',
        'For all pending* states.' => '',
        'Add Article' => 'Aggiungi articolo',
        'Create an Article' => 'Crea un\'articolo',
        'Inform agents' => '',
        'Inform involved agents' => '',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Text will also be received by:' => '',
        'Spell check' => 'Controllo ortografico',
        'Text Template' => 'Modello di testo',
        'Setting a template will overwrite any text or attachment.' => '',
        'Note type' => 'Tipologia della nota',

        # Template: AgentTicketBounce
        'Bounce %s%s' => '',
        'Bounce to' => 'Rispedisci a',
        'You need a email address.' => 'È necessario un indirizzo email.',
        'Need a valid email address or don\'t use a local email address.' =>
            'È necessario un indirizzo email valido o non usare un indirizzo email locale.',
        'Next ticket state' => 'Stato successivo del ticket',
        'Inform sender' => 'Informa il mittente',
        'Send mail' => 'Invia messaggio!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Azioni multiple',
        'Send Email' => 'Invia Email',
        'Merge to' => 'Unisci a',
        'Invalid ticket identifier!' => 'Identificatore ticket non valido!',
        'Merge to oldest' => 'Unisci a precedente',
        'Link together' => 'Collega',
        'Link to parent' => 'Collega a genitore',
        'Unlock tickets' => 'Sblocca ticket',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s' => 'Componi risposta per %s%s',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => 'Includere almeno un destinatario',
        'Remove Ticket Customer' => 'Rimuovi il Ticket del cliente',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Rimuovere i valori ed immetterne di validi',
        'Remove Cc' => 'Rimuovi persone in copia',
        'Remove Bcc' => 'Rimuovi persone in copia nascosta',
        'Address book' => 'Rubrica',
        'Date Invalid!' => 'Data non valida!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s' => '',
        'Customer user' => 'Utente cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Crea nuovo ticket email',
        'Example Template' => 'Modello di esempio',
        'From queue' => 'Dalla coda',
        'To customer user' => '',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Prendi tutto',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s' => 'Inoltra %s%s',

        # Template: AgentTicketHistory
        'History of %s%s' => 'Storico di %s%s',
        'History Content' => 'Contenuto dello storico',
        'Zoom view' => 'Vista di Dettaglio',

        # Template: AgentTicketMerge
        'Merge %s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => 'Devi usare un numero di ticket!',
        'A valid ticket number is required.' => 'Serve un numero ticket valido.',
        'Need a valid email address.' => 'Serve un indirizzo email valido',

        # Template: AgentTicketMove
        'Move %s%s' => 'Sposta in %s%s',
        'New Queue' => 'Nuova coda',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Seleziona tutto',
        'No ticket data found.' => 'Non sono stati trovati dati ticket.',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => 'Seleziona questo ticket',
        'First Response Time' => 'Tempo iniziale per risposta',
        'Update Time' => 'Tempo per aggiornamento',
        'Solution Time' => 'Tempo per soluzione',
        'Move ticket to a different queue' => 'Sposta il ticket ad una coda differente',
        'Change queue' => 'Cambia coda',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Modifica le opzioni di ricerca',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Numero di ticket per pagina',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',
        'Column Filters Form' => '',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'Crea nuovo ticket telefonico',
        'Please include at least one customer for the ticket.' => '',
        'To queue' => 'Alla coda',
        'Chat protocol' => 'Protocollo di chat',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s' => '',
        'Plain' => 'Testo nativo',
        'Download this email' => 'Scarica questa email',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Crea nuovo ticket con processo',
        'Process' => 'Processo',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Search template' => 'Modello di ricerca',
        'Create Template' => 'Crea modello',
        'Create New' => 'Crea nuovo',
        'Profile link' => 'Collegamento a profilo',
        'Save changes in template' => 'Salva modifiche al template',
        'Filters in use' => 'Filtri in uso',
        'Additional filters' => 'Filtri aggiuntivi',
        'Add another attribute' => 'Aggiungi un altro attributo',
        'Output' => 'Tipo di risultato',
        'Fulltext' => 'Testo libero',
        'Remove' => 'Rimuovi',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Identificativo di Accesso del Cliente',
        'Attachment Name' => 'Nome allegato',
        '(e. g. m*file or myfi*)' => '(ad es. m*file o miofi*)',
        'Created in Queue' => 'Creata nella Coda',
        'Lock state' => 'Blocca stato',
        'Watcher' => 'Osservatore',
        'Article Create Time (before/after)' => 'Tempo di creazione articolo (prima/dopo)',
        'Article Create Time (between)' => 'Tempo di creazione articolo (in mezzo)',
        'Ticket Create Time (before/after)' => 'Tempo di creazione ticket (prima/dopo)',
        'Ticket Create Time (between)' => 'Tempo di creazione ticket (in mezzo)',
        'Ticket Change Time (before/after)' => 'Tempo di modifica ticket (prima/dopo)',
        'Ticket Change Time (between)' => 'Tempo di modifica ticket (in mezzo)',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Tempo di chiusura ticket (prima/dopo)',
        'Ticket Close Time (between)' => 'Tempo di chiusura ticket (in mezzo)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Ricerca archivio',
        'Run search' => 'Esegui ricerca',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtro articolo',
        'Article Type' => 'Tipo articolo',
        'Sender Type' => 'Tipo mittente',
        'Save filter settings as default' => 'Salva impostazioni filtri come predefinite',
        'Event Type Filter' => '',
        'Event Type' => 'Tipo evento',
        'Save as default' => 'Salva come predefinito',
        'Archive' => 'Archivio',
        'This ticket is archived.' => 'Questo ticket è stato archiviato.',
        'Locked' => 'In gestione',
        'Accounted time' => 'Tempo addebitato',
        'Linked Objects' => 'Oggetti collegati',
        'Change Queue' => 'Cambia coda',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => 'Questo oggetto non ha ancora articoli',
        'Ticket Timeline View' => '',
        'Article Overview' => '',
        'Article(s)' => 'Articoli',
        'Page' => 'Pagina',
        'Add Filter' => 'Aggiungi filtro',
        'Set' => 'Impostazione',
        'Reset Filter' => 'Reimposta filtro',
        'Show one article' => 'Mostra un articolo',
        'Show all articles' => 'Mostra tutti gli articoli',
        'Show Ticket Timeline View' => '',
        'Unread articles' => 'Articoli non letti',
        'No.' => 'Num.',
        'Important' => 'Importante',
        'Unread Article!' => 'Articolo non letto!',
        'Incoming message' => 'Messaggio ricevuto',
        'Outgoing message' => 'messaggio in uscita',
        'Internal message' => 'messaggio interno',
        'Resize' => 'Ridimensiona',
        'Mark this article as read' => 'Marca questo articolo come letto',
        'Show Full Text' => 'Mostra testo completo',
        'Full Article Text' => '',
        'No more events found. Please try changing the filter settings.' =>
            '',
        'by' => 'da',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => 'Chiudi questo messaggio',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Per proteggere la tua privacy, il contenuto remoto è stato bloccato.',
        'Load blocked content.' => 'Carica contenuto bloccato.',

        # Template: ChatStartForm
        'First message' => 'Primo messaggio',

        # Template: CustomerError
        'Traceback' => 'Dettaglio della tracciatura ',

        # Template: CustomerFooter
        'Powered by' => 'Fornito da',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Si sono verificati uno o più errori!',
        'Close this dialog' => 'Chiudere questa schermata',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Impossibile aprire una finestra di popup. Disabilita ogni blocco di popup per questa applicazione.',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se si abbandona questa pagina, tutti i popup verranno chiusi!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Un popup di questa schermata è già aperto. Si desidera chiuderlo ed aprire questo invece?',
        'There are currently no elements available to select from.' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'The browser you are using is too old.' => 'Il browser in uso è obsoleto.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS funziona con una quantità innumerevole di browser, utilizza uno di questi.',
        'Please see the documentation or ask your admin for further information.' =>
            'Consulta la documentazione o chiedi al tuo amministratore per ulteriori informazioni.',
        'Switch to mobile mode' => 'Passa alla modalità mobile',
        'Switch to desktop mode' => 'Passa alla modalità desktop',
        'Not available' => 'Non disponibile',
        'Clear all' => 'Cancella tutto',
        'Clear search' => 'Cancella la ricerca',
        '%s selection(s)...' => '%s selezioni...',
        'and %s more...' => 'e %s altri...',
        'Filters' => 'Filtri',
        'Confirm' => 'Conferma',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript non disponibile',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Per poter usare OTRS, è necessario abilitare JavaScript nel browser.',
        'Browser Warning' => 'Attenzione: browser non compatibile',
        'One moment please, you are being redirected...' => 'Attendi un attimo, stai per essere rediretto...',
        'Login' => 'Accesso',
        'User name' => 'Nome utente',
        'Your user name' => 'Il suo user name',
        'Your password' => 'La sua password',
        'Forgot password?' => 'Password dimenticata?',
        '2 Factor Token' => '',
        'Your 2 Factor Token' => '',
        'Log In' => 'Accesso',
        'Not yet registered?' => 'Non ancora registrato?',
        'Request new password' => 'Richiedi una nuova password',
        'Your User Name' => 'Il tuo nome utente',
        'A new password will be sent to your email address.' => 'Una nuova password sarà inviata al tuo indirizzo email.',
        'Create Account' => 'Registrati',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Come chiamarla',
        'Your First Name' => 'Il suo nome',
        'Your Last Name' => 'Il suo cognome',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '',
        'You have unanswered chat requests' => '',
        'Edit personal preferences' => 'Modifica impostazioni personali',
        'Logout %s %s' => '',

        # Template: CustomerRichTextEditor
        'Split Quote' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'SLA',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Benvenuto!',
        'Please click the button below to create your first ticket.' => 'Usa il pulsante qui sotto per creare il tuo primo ticket.',
        'Create your first ticket' => 'Crea il tuo primo ticket!',

        # Template: CustomerTicketSearch
        'Profile' => 'Profilo',
        'e. g. 10*5155 or 105658*' => 'es 10*5155 or 105658*',
        'Customer ID' => 'ID Cliente',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Ricerca a testo nei ticket (es "John*n" or "Will*")',
        'Recipient' => 'Destinatario',
        'Carbon Copy' => 'Copia',
        'e. g. m*file or myfi*' => 'ad es. m*file o miofi*',
        'Types' => 'Tipi',
        'Time restrictions' => 'Restrizioni di tempo',
        'No time settings' => 'Nessuna impostazione per il tempo',
        'Only tickets created' => 'Solo ticket creati',
        'Only tickets created between' => 'Solo ticket creati tra',
        'Ticket archive system' => 'Sistema di Archiviazione Ticket',
        'Save search as template?' => 'Salvare la ricerca come modello?',
        'Save as Template?' => 'Salvare come modello?',
        'Save as Template' => 'Salva come modello',
        'Template Name' => 'Nome modello',
        'Pick a profile name' => 'Scegli un profilo',
        'Output to' => 'Output',

        # Template: CustomerTicketSearchResultShort
        'of' => 'di',
        'Search Results for' => 'Risultati di ricerca per',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '',
        'Expand article' => 'Espandi l\'articolo',
        'Information' => 'Informazione',
        'Next Steps' => 'Prossime attività',
        'Reply' => 'Risposta',
        'Chat Protocol' => 'Protocollo di chat',

        # Template: DashboardEventsTicketCalendar
        'All-day' => '',
        'Sunday' => 'Domenica',
        'Monday' => 'Lunedì',
        'Tuesday' => 'Martedì',
        'Wednesday' => 'Mercoledì',
        'Thursday' => 'Giovedì',
        'Friday' => 'Venerdì',
        'Saturday' => 'Sabato',
        'Su' => 'Do',
        'Mo' => 'Lu',
        'Tu' => 'Ma',
        'We' => 'Me',
        'Th' => 'Gi',
        'Fr' => 'Ve',
        'Sa' => 'Sa',
        'Event Information' => 'Informazioni evento',
        'Ticket fields' => 'Campi ticket',
        'Dynamic fields' => 'Campi dinamici',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Data non valida (è necessaria una data nel futuro)!',
        'Invalid date (need a past date)!' => '',
        'Previous' => 'Precedente',
        'Open date selection' => 'Apri selezione data',

        # Template: Error
        'Oops! An Error occurred.' => 'Oops! Si è verificato un errore.',
        'You can' => 'Si può',
        'Send a bugreport' => 'Invia una segnalazione di bug',
        'go back to the previous page' => 'torna alla pagina precedente',
        'Error Details' => 'Dettagli dell\'errore',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            'Inserisci almeno un termine o * per cercare tutto.',
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',
        'Please check the fields marked as red for valid inputs.' => '',
        'Please perform a spell check on the the text first.' => '',
        'Slide the navigation bar' => '',
        'Unavailable for chat' => 'Non disponibile per la chat',
        'Available for internal chats only' => '',
        'Available for chats' => 'Disponibile per la chat',
        'Please visit the chat manager' => 'Visita il gestore della chat',
        'New personal chat request' => '',
        'New customer chat request' => '',
        'New public chat request' => '',
        'New activity' => 'Nuova attività',
        'New activity on one of your monitored chats.' => '',
        'Do you really want to continue?' => 'Vuoi davvero continuare?',
        'Information about the OTRS Daemon' => 'Informazioni su OTRS Daemon',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            '',
        'Find out more about the %s' => '',

        # Template: Header
        'You are logged in as' => 'Si è effettuato l\'accesso come',

        # Template: Installer
        'JavaScript not available' => 'JavaScript non disponibile',
        'Step %s' => 'Passo %s',
        'Database Settings' => 'Impostazioni database',
        'General Specifications and Mail Settings' => 'Specifiche generiche ed impostazioni email',
        'Finish' => 'Fine',
        'Welcome to %s' => 'Benvenuto in %s',
        'Web site' => 'Sito web',
        'Mail check successful.' => 'Controllo email eseguito con successo.',
        'Error in the mail settings. Please correct and try again.' => 'Errore nelle impostazioni dell\'email. Correggi e riprova.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configura posta in uscita',
        'Outbound mail type' => 'Tipo di posta in uscita',
        'Select outbound mail type.' => 'Seleziona il tipo di posta in uscita.',
        'Outbound mail port' => 'Porta del server di posta',
        'Select outbound mail port.' => 'Seleziona la porta del server di posta.',
        'SMTP host' => 'Host SMTP',
        'SMTP host.' => 'Host SMTP.',
        'SMTP authentication' => 'Autenticazione SMTP',
        'Does your SMTP host need authentication?' => 'Serve autenticazione SMTP per questo host?',
        'SMTP auth user' => 'Utente per autenticazione SMTP',
        'Username for SMTP auth.' => 'Username per l\'autenticazione SMTP',
        'SMTP auth password' => 'Password per autenticazione SMTP',
        'Password for SMTP auth.' => 'Password per l\'autenticazione SMTP',
        'Configure Inbound Mail' => 'Configura posta in entrata',
        'Inbound mail type' => 'Tipo posta in entrata',
        'Select inbound mail type.' => 'Seleziona il tipo di posta in entrata.',
        'Inbound mail host' => 'Host di posta in entrata',
        'Inbound mail host.' => 'Host di posta in entrata',
        'Inbound mail user' => 'Host di posta in entrata',
        'User for inbound mail.' => 'Nome utente per la posta in entrata.',
        'Inbound mail password' => 'Password per la posta in entrata',
        'Password for inbound mail.' => 'Password per la posta in entrata',
        'Result of mail configuration check' => 'Risultato del controllo di configurazione della posta',
        'Check mail configuration' => 'Controllo configurazione della posta',
        'Skip this step' => 'Salta questo passaggio',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Configurazione database terminata con successo',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => 'Crea un nuovo database per OTRS',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => 'Nome del database',
        'Check database settings' => 'Controlla impostazioni database',
        'Result of database check' => 'Risultato del controllo database',
        'Database check successful.' => 'Controllo database eseguito con successo.',
        'Database User' => 'Utente del database',
        'New' => 'Nuovi',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Verrà creato un nuovo database a permessi limitati per questo sistema OTRS',
        'Repeat Password' => 'Ripeti la password',
        'Generated password' => 'Password generata',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Le password non coincidono',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Porta',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Per poter usare OTRS, devi inserire questa riga di comando in una shell come utente root.',
        'Restart your webserver' => 'Riavvia il tuo server web',
        'After doing so your OTRS is up and running.' => 'Dopo di ciò OTRS sarà pronto all\'uso.',
        'Start page' => 'Pagina iniziale',
        'Your OTRS Team' => 'Gruppo di sviluppo di OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Non accetto la licenza',
        'Accept license and continue' => 'Accetto la licenza e continua',

        # Template: InstallerSystem
        'SystemID' => 'ID del sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'L\'identificatore di questo sistema. Ogni numero di ticket e ogni ID di sessione HTTP contengono questo numero.',
        'System FQDN' => 'FQDN del sistema',
        'Fully qualified domain name of your system.' => 'Nome FQDN di questo sistema',
        'AdminEmail' => 'Admin Email',
        'Email address of the system administrator.' => 'Indirizzo dell\'amministratore di sistema.',
        'Organization' => 'Società',
        'Log' => 'Log',
        'LogModule' => 'Modulo di log',
        'Log backend to use.' => 'Backend di log da usare',
        'LogFile' => 'File di log',
        'Webfrontend' => 'Interfaccia web',
        'Default language' => 'Lingua di default',
        'Default language.' => 'Lingua di default.',
        'CheckMXRecord' => 'Controlli sui record MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Gli indirizzi scritti a mano vengono controllati tramite i record MX trovati nei DNS. Non usare questa opzione se il DNS usato dalla macchina è lento o non risolve gli indirizzi pubblici.',

        # Template: LinkObject
        'Object#' => '',
        'Add links' => 'Aggiungi collegamenti',
        'Delete links' => 'Elimina collegamenti',

        # Template: Login
        'Lost your password?' => 'Hai dimenticato la password?',
        'Request New Password' => 'Richiedi nuova password',
        'Back to login' => 'Torna all\'accesso',

        # Template: MobileNotAvailableWidget
        'Feature not available' => 'Funzionalità non disponibile',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'Motto del giorno',

        # Template: NoPermission
        'Insufficient Rights' => 'Permessi insufficienti',
        'Back to the previous page' => 'Pagina precedente',

        # Template: Pagination
        'Show first page' => 'Mostra prima pagina',
        'Show previous pages' => 'Mostra pagine precedenti',
        'Show page %s' => 'Mostra pagina %s',
        'Show next pages' => 'Mostra pagine successive',
        'Show last page' => 'Mostra ultima pagina',

        # Template: PictureUpload
        'Need FormID!' => 'FormID necessario!',
        'No file found!' => 'Nessun file trovato!',
        'The file is not an image that can be shown inline!' => 'Il file non è un\'immagine che può essere mostrata in linea!',

        # Template: PreferencesNotificationEvent
        'Notification' => 'Notifica',
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => 'Informazioni processo',
        'Dialog' => 'Finestra',

        # Template: Article
        'Inform Agent' => 'Informa Operatore',

        # Template: PublicDefault
        'Welcome' => 'Benvenuto',

        # Template: GeneralSpecificationsWidget
        'Permissions' => ' Permessi',
        'You can select one or more groups to define access for different agents.' =>
            'Si può scegliere uno o più gruppi per definire l\'accesso a diversi agenti.',
        'Result formats' => '',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data columns.' =>
            '',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data rows.' =>
            '',
        'Cache results' => '',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration.' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Se impostato a invalido gli utenti finali non possono generare la statistica.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format:' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => 'Configura asse X',
        'X-axis' => 'Asse X',
        'Configure Y-Axis' => 'Configura asse Y',
        'Y-axis' => 'Asse Y',
        'Configure Filter' => 'Configura filtro',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Seleziona solo un elemento e togli  \'Fisso\'. ',
        'Absolute period' => 'Periodo assoluto',
        'Between' => 'fra',
        'Relative period' => 'Periodo relativo',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'Formato',
        'Exchange Axis' => 'Scambia assi',
        'Configurable params of static stat' => 'Parametri configurabili per le statistiche ',
        'No element selected.' => 'nessun elemento selezionato',
        'Scale' => 'scala valori',

        # Template: D3
        'Download SVG' => 'Scarica SVG',
        'Download PNG' => 'Scarica PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'Pagina di test OTRS',
        'Welcome %s %s' => 'Benvenuto %s %s',
        'Counter' => 'Contatore',

        # Template: Warning
        'Go back to the previous page' => 'Torna alla pagina precedente',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'Nuovo ticket da telefonata',
        'New email ticket' => 'Nuovo ticket da email',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Currently' => 'Attualmente',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'Web service "%s" updated!' => '',
        'Web service "%s" created!' => '',
        'Web service "%s" deleted!' => '',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who owns the ticket' => '',
        'Agent who is responsible for the ticket' => '',
        'All agents watching the ticket' => '',
        'All agents with write permission for the ticket' => '',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer of the ticket' => 'Cliente del ticket',
        'Yes, but require at least one active notification method' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Package not verified due a communication issue with verification server!' =>
            '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'Statistic' => 'Statistica',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Can not delete link with %s!' => '',
        'Can not create link with %s!' => '',
        'Object already linked as %s.' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No subject' => 'Nessun oggetto',
        'Previous Owner' => 'Gestore precedente',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Ticket is locked by another agent and will be ignored!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        '%s has left the chat.' => '',
        'This chat has been closed and will be removed in %s hours.' => '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'printed by' => 'stampato da',
        'Ticket Dynamic Fields' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Pending Date' => 'Attesa fino a',
        'for pending* states' => 'per gli stati di attesa*',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Invalid Users' => 'Utenti non validi',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. ' =>
            '',
        'Fields with no group' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/Installer.pm
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'This ticket has no title or subject' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'This user is currently offline' => 'Questo utente non è attualmente in linea',
        'This user is currently active' => 'Questo utente è attualmente attivo',
        'This user is currently away' => 'Questo utente è attualmente assente',
        'This user is currently unavailable' => 'Questo utente non è attualmente disponibile',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            '',
        ' You can take one of the next actions:' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Collegato come',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s Aggiorna a %s ora! %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'Please contact your administrator!' => 'Contatta il tuo amministratore!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => 'Fornisci la nuova password!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => 'La data selezionata non è valida.',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Ordina per ',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => '',
        'This setting can not be deactivated.' => 'Questa impostazione non può essere disattivata.',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'Priorità creata',
        'Created State' => 'Stato ticket',
        'CustomerUserLogin' => 'Login Utente Cliente',
        'Create Time' => 'Tempo di Creazione',
        'Close Time' => 'Tempo di Chiusura',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Agente/Proprietario',
        'Created by Agent/Owner' => 'Creato da Agente/Proprietario',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Valutato da',
        'Ticket/Article Accounted Time' => 'Ticket/Tempo allocato',
        'Ticket Create Time' => 'Istante di creazione Ticket',
        'Ticket Close Time' => 'Istante di chiusura Ticket',
        'Accounted time by Agent' => 'Tempo impiegato dall\'agente',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'Attributes to be printed' => 'Attributi sa stampare',
        'Sort sequence' => 'Sequenza di ordinamento',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Giorni',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tabella delle Presenze',
        'Internal Error: Could not open file.' => 'Errore interno: Impossibile aprire il file.',
        'Table Check' => 'Controllo Tabelle',
        'Internal Error: Could not read file.' => 'Errore interno: Impossibile leggere il file.',
        'Tables found which are not present in the database.' => 'Trovate tabelle non presenti nel database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Dimensione Database',
        'Could not determine database size.' => 'Impossibile determinare la dimensione del database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Versione Database',
        'Could not determine database version.' => 'Impossibile determinare la versione del database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Charset della Connessione Client',
        'Setting character_set_client needs to be utf8.' => 'Il parametro character_set_client deve essere impostato a utf8.',
        'Server Database Charset' => 'Charset del Server Database',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'Il parametro character_set_database deve essere UNICODE o UTF8.',
        'Table Charset' => 'Charset della Tabella',
        'There were tables found which do not have utf8 as charset.' => 'Sono state trovate tabelle che non hanno il charset impostato a utf8',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Dimensione Massima della Query',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'Il parametro \'max_allowed_packet\' deve essere maggiore di 20 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Dimensione della Query Cache',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Si consiglia l\'uso del parametro \'query_cache_size\' (fra 10 MB e 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Default Storage Engine',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            'Sono state trovate tabelle che hanno una storage engine diversa dal default del database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'È richiesto l\'uso di MySQL 5.x o versioni superiori.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Impostazione NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG deve essere impostato a al32utf8 (ad es. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Parametro NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'Il parametro NLS_DATE_FORMAT deve essere impostato nel formato \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'Controllo impostazione SQL NLS_DATE_FORMAT',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Il parametro client_encoding deve essere UNICODE o UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Il parametro server_encoding deve essere UNICODE o UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Formato Data',
        'Setting DateStyle needs to be ISO.' => 'Il parametro DateStyle deve essere di tipo ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => 'Per PostgreSQL è richiesta la versione 8.x o superiore.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'Partizione disco di OTRS',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Utilizzo Disco',
        'The partition where OTRS is located is almost full.' => 'La partizione dove risiede OTRS è quasi satura.',
        'The partition where OTRS is located has no disk space problems.' =>
            'La partizione disco dove risiede OTRS non ha problemi di spazio.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Operating System/Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribuzione',
        'Could not determine distribution.' => 'Impossibile determinare la distribuzione.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Versione di Kernel',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Carico di sistema',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Moduli Perl',
        'Not all required Perl modules are correctly installed.' => 'Non tutti i moduli Perl necessari sono correttamente installati.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Spazio Swap libero (%)',
        'No swap enabled.' => 'Swap non abilitata.',
        'Used Swap Space (MB)' => 'Utilizzo spazio Swap (MB)',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS/Config Settings' => '',
        'Could not determine value.' => 'Impossibile determinare il valore.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'OTRS' => 'OTRS',
        'Daemon' => 'Demone',
        'Daemon is not running.' => 'Il demone non è in esecuzione.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'OTRS/Database Records' => '',
        'Tickets' => 'Richieste',
        'Ticket History Entries' => 'Voci nello Storico Ticket',
        'Articles' => 'Articoli',
        'Attachments (DB, Without HTML)' => 'Allegati (DB, senza HTML)',
        'Customers With At Least One Ticket' => 'Clienti Con Almeno Un Ticket',
        'Dynamic Field Values' => 'Valori dei Campi Dinamici',
        'Invalid Dynamic Fields' => 'Campi Dinamici non validi',
        'Invalid Dynamic Field Values' => 'Valori dei Campi Dinamici non validi',
        'GenericInterface Webservices' => 'GenericInterface Webservice',
        'Months Between First And Last Ticket' => 'Numero mesi fra primo e ultimo Ticket',
        'Tickets Per Month (avg)' => 'Ticket per mese (media)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Possibile rischio sicurezza: si stanno usando le impostazioni predefinite per SOAP::User e SOAP::Password, si consiglia di cambiarle.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Password di Admin predefinita',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Attenzione: l\'utente root@localhost ha la password predefinita. Si consiglia di cambiare la password o disabilitare l\'utente.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ErrorLog.pm
        'Error Log' => 'Log di Errore',
        'There are error reports in your system log.' => 'Ci sono voci di errori nei log di sistema.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (nome di dominio)',
        'Please configure your FQDN setting.' => 'Configura l\'impostazione di FQDN.',
        'Domain Name' => 'Nome a Dominio',
        'Your FQDN setting is invalid.' => 'L\'impostazione del FQDN non è valida.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'File System scrivibile.',
        'The file system on your OTRS partition is not writable.' => 'Il file system dove risiede OTRS non è scrivibile.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'Stato di installazione del pacchetto',
        'Some packages are not correctly installed.' => 'Alcuni pacchetti non sono correttamente installati.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'OTRS/Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Il parametro SystemID è invalido, può contenere solo numeri.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'Open Tickets' => 'Ticket Aperti',
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'OTRS/Time Settings' => 'OTRS/Impostazioni orario',
        'Server time zone' => 'Fuso orario server',
        'Computed server time offset' => '',
        'OTRS TimeZone setting (global time offset)' => '',
        'TimeZone may only be activated for systems running in UTC.' => '',
        'OTRS TimeZoneUser setting (per-user time zone support)' => '',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            '',
        'OTRS TimeZone setting for calendar ' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver/Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'Webserver' => 'Webserver',
        'MPM model' => 'Modello MPM',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Utilizzo dell\'acceleratore CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => 'Utilizzo di mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Si suggerisce l\'installazione di mod_deflate per migliorare i tempi di risposta dell\'interfaccia utente',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => 'Utilizzo di mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Si suggerisce l\'installazione di mod_headers per migliorare i tempi di risposta dell\'interfaccia utente.',
        'Apache::Reload Usage' => 'Utilizzo di Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache2::DBI Usage' => 'Apache2::DBI Usage',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Webserver/Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/IIS/Performance.pm
        'You should use PerlEx to increase your performance.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Versione Webserver',
        'Could not determine webserver version.' => 'Impossibile determinare la versione del server web.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => 'Sconosciuto',
        'OK' => 'OK',
        'Problem' => 'Problema',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Reset password unsuccessful. Please contact your administrator' =>
            '',
        'Panic! Invalid Session!!!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => 'Gruppo per l\'accesso predefinito.',
        'Group of all administrators.' => 'Gruppo di tutti gli amministratori.',
        'Group for statistics access.' => 'Gruppo per l\'accesso alle statistiche.',
        'All new state types (default: viewable).' => '',
        'All open state types (default: viewable).' => '',
        'All closed state types (default: not viewable).' => '',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'All \'removed\' state types (default: not viewable).' => '',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'Ticket is closed successful.' => '',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => 'Ticket aperti.',
        'Customer removed ticket.' => 'Il cliente ha rimosso il ticket.',
        'Ticket is pending for agent reminder.' => '',
        'Ticket is pending for automatic close.' => '',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => 'Formula di saluto standard.',
        'system standard signature (en)' => '',
        'Standard Signature.' => 'Firma standard.',
        'Standard Address.' => 'Indirizzo standard.',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => 'nuovo ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created..' =>
            '',
        'Postmaster queue.' => 'Coda Postmaster.',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => 'Non classificato',
        'tmp_lock' => 'tmp_lock',
        'email-notification-ext' => '',
        'email-notification-int' => '',
        'fax' => 'fax',
        'Ticket create notification' => '',
        'Ticket follow-up notification (unlocked)' => '',
        'Ticket follow-up notification (locked)' => '',
        'Ticket owner update notification' => '',
        'Ticket responsible update notification' => '',
        'Ticket new note notification' => '',
        'Ticket queue update notification' => '',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => '',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => '',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => ' (unità di lavoro)',
        '"%s" notification was sent to "%s" by "%s".' => 'La notifica "%s" è stata inviata a "%s" da "%s".',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s unità temporali addebitate. Nuovo totale: %s.',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'A Website' => 'Un sito web',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => 'Un\'immagine',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Modulo ACL che permette di chiudere ticket genitori solo se tutti i ticket figli sono già chiusi ("Stato" mostra quali stati non sono disponibili per il ticket padre finché non sono chiusi tutti i figli).',
        'Access Control Lists (ACL)' => 'Access Control List (ACL)',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Attiva il meccanismo di blinking della coda che contiene il ticket più vecchio.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Attiva la funzione password dimenticata per gli agenti, nell\'interfaccia per agenti.',
        'Activates lost password feature for customers.' => 'Attiva la funzione di password dimenticata per i clienti.',
        'Activates support for customer groups.' => 'Attiva il supporto per i gruppi di clienti.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Attiva il filtro degli articoli nella visualizzazione zoom per specificare quali articoli devono essere mostrati.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Attiva i temi disponibili sul sistema. Il valore 1 significa attivi, 0 significa inattivi.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Attiva la ricerca nei ticket archiviati nell\'interfaccia cliente',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Attiva il sistema di archivio dei ticket per avere un sistema più veloce spostando alcuni ticket fuori dall\'ambito giornaliero. Per cercare questi ticket, il contrassegno dell\'archivio deve essere abilitato nella ricerca dei ticket.',
        'Activates time accounting.' => 'Attiva Rendicontazione Tempo.',
        'ActivityID' => '',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added email. %s' => 'Email. %s aggiunta',
        'Added link to ticket "%s".' => 'Aggiunto collegamento al ticket "%s".',
        'Added note (%s)' => 'Aggiunta nota (%s)',
        'Added subscription for user "%s".' => 'Aggiunta sottoscrizione per l\'utente "%s".',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Aggiunge un suffisso con l\'attuale anno e mese nel log di OTRS. Verrà creato un log per ogni mese.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Aggiunge i giorni di vacanza singoli per il calendario indicato. Usa una cifra sola per i numeri da 1 a 9 (invece di 01 - 09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Aggiunge i giorni di vacanza eccezionali. Usa una cifra sola per i numeri da 1 a 9 (invece di 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Aggiunge i giorni ricorrenti di vacanza . Usa una cifra sola per i numeri da 1 a 9 (invece di 01 - 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Aggiunge i giorni di vacanza permanenti. Usa una cifra sola per i numeri da 1 a 9 (invece di 01 - 09).',
        'After' => 'Dopo',
        'Agent called customer.' => 'L\'operatore ha chiamato il cliente.',
        'Agent interface article notification module to check PGP.' => 'Modulo di notifica degli articoli dell\'interfaccia agente per il controllo PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'Modulo di notifica degli articoli dell\'interfaccia agente per il controllo S/MIME',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Modulo dell\'interfaccia degli agenti per accedere alla ricerca fulltext tramite barra di navigazione',
        'Agent interface module to access search profiles via nav bar.' =>
            'Modulo dell\'interfaccia degli agenti per accedere ai profili di ricerca tramite barra di navigazione',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Modulo dell\'interfaccia degli agenti per controllare le email in entrata nella visualizzazione ticket zoom se S/MIME è disponibile e attivo',
        'Agent interface notification module to see the number of locked tickets.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Modulo dell\'interfaccia degli agenti per vedere il numero di ticket di cui è responsabile l\'agente.',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Modulo dell\'interfaccia degli agenti per vedere il numero di ticket sotto osservazione.',
        'Agents <-> Groups' => 'Agenti <-> Gruppi',
        'Agents <-> Roles' => 'Agenti <-> Ruoli',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permette di aggiungere note nella schermata di chiusura del ticket nell\'interfaccia dell\'agente. Può essere sovrascritto da Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permette di aggiungere note nella schermata a testo libero del ticket nell\'interfaccia dell\'agente. Può essere sovrascritto da Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permette di aggiungere note nella schermata del ticket nell\'interfaccia dell\'agente. Può essere sovrascritto da Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permette di aggiungere note nella schermata proprietario del ticket nella schermata ingrandita nell\'interfaccia agente. Può essere sovrascritto da Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permette di aggiungere note ad un ticket in attesa nella schermata ingrandita dell\'interfaccia agente. Può essere sovrascritto da Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permette di aggiungere note nella sezione priorità di un ticket nella schermata ingrandita dell\'interfaccia agente. Può essere sovrascritto da Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permette agli agenti di scambiare gli assi di una statistica che generano.',
        'Allows agents to generate individual-related stats.' => 'Permette agli agenti di generare statistiche individuali.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permette di scegliere tra mostrare gli allegati di un ticket nel browser (in linea) o renderli scaricabili (allegato).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permette di scegliere lo stato di composizione successivo nella schermata dei ticket dei clienti.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permette ai clienti di cambiare la priorità dei ticket nell\'interfaccia cliente.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permette ai clienti di impostare la SLA dei ticket nell\'interfaccia cliente.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permette ai clienti di impostare la priorità dei ticket nell\'interfaccia cliente.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Permette ai clienti di impostare la coda dei ticket nell\'interfaccia cliente. Se impostato su No, si deve configurare QueueDefault',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permette ai clienti di impostare il servizio dei ticket nell\'interfaccia cliente.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Permette ai clienti di impostare la tipologia di ticket nell\'interfaccia. Se impostato a \'No\', TicketTypeDefault deve essere configurato.',
        'Allows default services to be selected also for non existing customers.' =>
            'permette \'inserimento di servizi di default per clienti non registrati.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permette di definire nuovi tipi di ticket (se è abilitata la funzione ticket type)',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permette di definire servizi e SLA per i ticket (e.g. email, desktop, network, ...), e attributi di scalo per gli SLA (se è abilitata la funzione servizio/SLA)',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permette l\'utilizzo di criteri di ricerca estesi nell\'interfaccia agente.',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permette di usare le condizioni avanzate di ricerca nell\'interfaccia dei clienti. Con questa funzionalità si può cercare con condizioni del tipo "(chiave1&&chiave2)" o "(chiave1||chiave2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permette di avere il formato medio nella visualizzazione dei ticket (CustomerInfo =>1 - mostra anche le informazioni del cliente)',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permette di avere il formato piccolo nella visualizzazione dei ticket (CustomerInfo =>1 - mostra anche le informazioni del cliente)',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Permette agli amministratori di effettuare la login come altri clienti attraverso il pannello di amministrazione clienti.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permette agli amministratori di effettuare l\'accesso come altri utenti, tramite il pannello di amministrazione.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permette di impostare un nuovo stato di ticket nella schermata di movimento ticket dell\'interfaccia degli agenti.',
        'Arabic (Saudi Arabia)' => 'Arabo (Arabia Saudita)',
        'Archive state changed: "%s"' => 'Aggiornamento Flag Archivio',
        'ArticleTree' => '',
        'Attachments <-> Templates' => 'Allegati <-> Modelli',
        'Auto Responses <-> Queues' => 'Risposte automatiche <-> Code',
        'AutoFollowUp sent to "%s".' => 'Prosecuzione automatica inviata a "%s".',
        'AutoReject sent to "%s".' => 'Rifiuto automatico inviato a "%s".',
        'AutoReply sent to "%s".' => 'Risposta automatica inviata a "%s".',
        'Automated line break in text messages after x number of chars.' =>
            'A capo automatico nelle linee dopo X caratteri',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Prendi in carico automaticamente sull\'agente corrente dopo aver selezionato un\'azione multipla.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Imposta automaticamente il proprietario di un ticket come responsabile del ticket (se la funzione di responsabilità è abilitata).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Imposta automaticamente la responsabilità del ticket (se non è già impostata) dopo il primo cambio di proprietà.',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Tema Balanced White by Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blocca tutte le email in entrata che non hanno un numero di ticket valido nell\'oggetto con indirizzo Da: @esempio.com.',
        'Bounced to "%s".' => 'Rispedito a "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'Costruisce un indice degli articoli subito dopo la creazione dell\'articolo.',
        'Bulgarian' => 'Bulgaro',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Configurazione di esempio di CMD. Ignora le email dove il comando esterno CMD ritorna un certo output in STDOUT (le email verranno messe in pipe STDIN a qualcosa.bin).',
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
        'Catalan' => 'Catalano',
        'Change password' => 'Cambio password',
        'Change queue!' => 'Cambio coda!',
        'Change the customer for this ticket' => 'Cambia il cliente per questo ticket',
        'Change the free fields for this ticket' => 'Cambia i campi liberi per questo ticket',
        'Change the priority for this ticket' => 'Cambia la priorità di questo ticket',
        'Change the responsible for this ticket' => 'Cambia il responsabile per questo ticket',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Priorità cambiata da "%s" (%s) a "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Cambia il proprietario del ticket a tutti (utile per ASP). Normalmente solo gli agenti con permessi R/W sulla coda del ticket verranno mostrati.',
        'Checkbox' => 'Caselle a scelta obbligata',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Controlla il SystemID nel rilevamento del numero di ticket per i follow-up (usare "No" se il SystemID è stato cambiato dopo aver usato il sistema).',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Chinese (Simplified)' => 'Cinese (semplificato)',
        'Chinese (Traditional)' => 'Cinese (tradizionale)',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            '',
        'Closed tickets (customer user)' => 'Ticket chiusi (utente cliente)',
        'Closed tickets (customer)' => 'Ticket chiusi (utente cliente)',
        'Cloud Services' => 'Servizi Cloud',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Commento per nuove voce nello storico dell\'interfaccia cliente.',
        'Comment2' => 'Commento2',
        'Communication' => 'Comunicazione',
        'Company Status' => 'Stato Società',
        'Company Tickets' => 'Ticket della Società',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => 'Processi Configurati.',
        'Configure and manage ACLs.' => 'Configura e gestisci le ACL.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Controlla se i clienti hanno la possibilità di ordinare i loro ticket.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Converte la posta in HTML in Interazioni di testo.',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Crea e gestisce gli SLA',
        'Create and manage agents.' => 'Crea e gestisce gli agenti',
        'Create and manage attachments.' => 'Crea e gestisce gli allegati',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'Crea e gestisce i clienti',
        'Create and manage dynamic fields.' => '',
        'Create and manage groups.' => 'Crea e gestisce i gruppi',
        'Create and manage queues.' => 'Crea e gestisce le code.',
        'Create and manage responses that are automatically sent.' => 'Crea e gestisce le risposte che vengono inviate automaticamente.',
        'Create and manage roles.' => 'Crea e gestisce i ruoli.',
        'Create and manage salutations.' => 'Crea e gestisce i saluti.',
        'Create and manage services.' => 'Crea e gestisce i servizi.',
        'Create and manage signatures.' => 'Crea e gestisce le firme.',
        'Create and manage templates.' => '',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => 'Crea e gestisce le priorità dei ticket.',
        'Create and manage ticket states.' => 'Crea e gestisce gli stati dei ticket.',
        'Create and manage ticket types.' => 'Crea e gestisce i tipi di ticket.',
        'Create and manage web services.' => 'Crea e gestisce i web service',
        'Create new email ticket and send this out (outbound)' => 'Crea un nuovo ticket email e invia questo (esternamente)',
        'Create new phone ticket (inbound)' => 'Crea un nuovo ticket telefonico (internamente)',
        'Create new process ticket' => '',
        'Croatian' => 'Croato',
        'Custom RSS Feed' => 'Fonte RSS personalizzata',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Amministrazione clienti',
        'Customer User <-> Groups' => 'Utente cliente <-> Gruppi',
        'Customer User <-> Services' => 'Utente cliente <-> Servizi',
        'Customer User Administration' => 'Amministrazione utenti cliente',
        'Customer Users' => 'Utenti Cliente',
        'Customer called us.' => 'Il cliente ha chiamato noi.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer request via web.' => 'Ticket del cliente via web.',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Clienti <-> Gruppi',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => 'Ceco',
        'Danish' => 'Danese',
        'Data used to export the search result in CSV format.' => 'Dati usati per esportare i risultati di ricerca in formato CSV',
        'Date / Time' => 'Data / Ora',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Debug del set di traduzione. Se questo è impostato a "Sì" tutte le stringhe (testo) non tradotte sono scritte su STDERR. Può essere utile quando si crea un nuovo file di traduzione. Altrimenti, questa opzione dovrebbe rimanere impostata su "No".',
        'Default ACL values for ticket actions.' => 'ACL di default per le azioni sui ticket.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Prefisso standard per le entità di Process Management generate automaticamente.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => 'Modulo di default per la protezione dei loop',
        'Default queue ID used by the system in the agent interface.' => 'ID di coda di default usato dal sistema nell\'interfaccia degli agenti',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'Ticket ID predefinito usato dal sistema nell\'interfaccia agenti.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Ticket ID predefinito usato dal sistema nell\'interfaccia clienti.',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definisce un filtro per l\'output HTML per aggiungere collegamenti dietro una determinata stringa. L\'elemento Image permette due tipi di input. Uno è il nome di una certa immagine (ad es. faq.png). In questo caso verrà usato il percorso delle immagini di OTRS. La seconda possibilità è inserire un collegamento all\'immagine.',
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
        'Define the start day of the week for the date picker.' => 'Definire il giorno di inizio settimana per il selezionatore di date.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definire un oggetto cliente, che genera l\'icona LinkedIn alla fine di un blocco di informazioni cliente.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definire un oggetto cliente, che genera l\'icona XING alla fine di un blocco di informazioni cliente.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definire un oggetto cliente, che genera l\'icona Google alla fine di un blocco di informazioni cliente.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definire un oggetto cliente, che genera l\'icona Google Maps alla fine di un blocco di informazioni cliente.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Definire una lista di parole che vengono ignorate dal controllo ortografico.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definire un filtro per l\'output HTML per aggiungere i collegamenti dietro ai numeri CVE. L\'elemento Image permette due tipi di input. Uno è il nome di una certa immagine (ad es. faq.png). In questo caso verrà usato il percorso delle immagini di OTRS. La seconda possibilità è inserire un collegamento all\'immagine.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definire un filtro per l\'output HTML per aggiungere i collegamenti dietro ai numeri MSBulletin. L\'elemento Image permette due tipi di input. Uno è il nome di una certa immagine (ad es. faq.png). In questo caso verrà usato il percorso delle immagini di OTRS. La seconda possibilità è inserire un collegamento all\'immagine.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definire un filtro per l\'output HTML per aggiungere i collegamenti dietro una determinata stringa. L\'elemento Image permette due tipi di input. Uno è il nome di una certa immagine (ad es. faq.png). In questo caso verrà usato il percorso delle immagini di OTRS. La seconda possibilità è inserire un collegamento all\'immagine.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definire un filtro per l\'output HTML per aggiungere i collegamenti dietro ai numeri bugtraq. L\'elemento Image permette due tipi di input. Uno è il nome di una certa immagine (ad es. faq.png). In questo caso verrà usato il percorso delle immagini di OTRS. La seconda possibilità è inserire un collegamento all\'immagine.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Definisce un filtro per analizzare il testo negli articoli, in modo da evidenziare certe parole chiave.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Definire un\'espressione regolare che esclude alcuni indirizzi dal controllo sintattico (se "CheckEmailAddress" è impostato a "Sì"). Inserire una espressione regolare in questo campo per gli indirizzi email, che non sono sintatticamente validi, ma che sono necessari per il sistema (ad es. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Definisce un\'espressione regolare che filtra tutti gli indirizzi email che non dovrebbero essere usati nell\'applicazione.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            'Definisce un modulo utile per caricare opzioni utente specifiche o per mostrare notizie.',
        'Defines all the X-headers that should be scanned.' => 'Definisce tutti gli X-Header che dovrebbero essere esaminati.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Definire tutti i parametri per l\'oggetto RefreshTime nelle preferenze del cliente nell\'interfaccia dei clienti.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Definire tutti i parametri per l\'oggetto ShownTickets nelle preferenze del cliente nell\'interfaccia dei clienti.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Definire tutti i parametri per questo oggetto nelle preferenze del cliente.',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => 'Definisce tutti i possibili formati di output delle statistiche.',
        'Defines an alternate URL, where the login link refers to.' => 'Definisce un URL alternativo, a cui si riferisce il collegamento di accesso.',
        'Defines an alternate URL, where the logout link refers to.' => 'Definisce un URL alternativo, a cui si riferisce il collegamento di uscita.',
        'Defines an alternate login URL for the customer panel..' => 'Definisce un URL alternativo, a cui si riferisce il collegamento di accesso del pannello dei clienti.',
        'Defines an alternate logout URL for the customer panel.' => 'Definisce un URL alternativo, a cui si riferisce il link di uscita del pannello dei clienti.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Definisce l\'aspetto del campo Da: delle email (inviate come risposte nei ticket email).',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di chiusura ticket dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di rispedizione ticket dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di composizione ticket dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di inoltro ticket dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di free text dei ticket dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di unione di un ticket sotto zoom dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di note dei ticket dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di proprietà di un ticket sotto zoom dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di attesa di un ticket sotto zoom dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di ticket telefonico in uscita dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di priorità di un ticket sotto zoom dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria nella schermata di responsabilità ticket dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Definisce se una presa in carico è necessaria per un cambio di cliente di un ticket dell\'interfaccia degli agenti (se il ticket non è ancora preso in carico, il ticket viene preso in carico automaticamente e l\'agente viene automaticamente impostato come proprietario).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Definisce se i messaggi devono essere controllati ortograficamente nell\'interfaccia degli agenti.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'Definisce se la contabilizzazione tempo è obbligatoria nell\'interfaccia agente. Se attivato, una nota deve essere inserita per tutte le azioni del ticket (non importa se la nota stessa è configurata come attiva o è originariamente obbligatoria per le schermate di azione individuali del ticket).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Definisce se la rendicontazione del tempo è necessaria per le azioni multiple',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Definisce l\'espressione regolare di IP per accedere al repository locale. È necessario abilitare questa funzione per avere accesso al tuo repository locale e il pacchetto package::RepositoryList è richiesto sull\'host remoto.',
        'Defines the URL CSS path.' => 'Definisce la path CSS dell\'URL',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Definisce la path URL di icone, CSS e Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Definisce la path URL delle icone di navigazione.',
        'Defines the URL java script path.' => 'Definisce la path URL dei java script.',
        'Defines the URL rich text editor path.' => 'Definisce la path URL del rich text editor.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Definisce l\'indirizzo di un server DNS dedicato, se necessario, per i look-up di "CheckMXRecord".',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Definisce il corpo del testo per le email di notifica inviate agli agenti, riguardo alla nuova password (dopo aver usato questo collegamento la nuova password sarà inviata).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Definisce il corpo delle email di notifica inviate agli agenti, con il token riguardante la nuova password richiesta (dopo aver usato questo collegamento la nuova password sarà inviata).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Definisce il corpo delle email di notifica inviate ai clienti, circa i nuovi account',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Definisce il corpo delle email di notifica inviate ai clienti, circa le nuove password',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Definisce il corpo delle email di notifica inviate ai clienti, con token per la nuova password richiesta (dopo aver usato questo collegamento la nuova password sarà inviata)',
        'Defines the body text for rejected emails.' => 'Definisce il corpo delle email rifiutate.',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            '',
        'Defines the column to store the keys for the preferences table.' =>
            'Definisce le colonne in cui memorizzare le chiavi per la tabella delle preferenze.',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Definisce i parametri di configurazione per questo oggetto, in modo che vengano mostrate nella schermata delle preferenze.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Definisce i parametri di configurazione per questo oggetto, in modo che vengano mostrate nella schermata delle preferenze. Ricordati di mantenere i dizionari installati nel sistema nella sezione dati.',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
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
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
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
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
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
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
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
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
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
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
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
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
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
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
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
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
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
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Deleted link to ticket "%s".' => 'Eliminato link alla richiesta "%s".',
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
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
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
        'Dropdown' => 'Menu a tendina',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
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
        'E-Mail Outbound' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'Indirizzi Email',
        'Email sent to "%s".' => 'Email inviata a "%s".',
        'Email sent to customer.' => 'Email inviata al cliente.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Abilita supporto S/MIME',
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
        'English (Canada)' => 'Inglese (Canada)',
        'English (United Kingdom)' => 'Inglese (Regno Unito)',
        'English (United States)' => 'Inglese (Stati Uniti)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication.' =>
            '',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => '',
        'EscalationTime' => '',
        'Estonian' => 'Estone',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
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
        'Execute SQL statements.' => 'Esegui statement SQL',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Filtra email in ingresso',
        'Finnish' => 'Finlandese',
        'First Queue' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => 'Nome Cognome',
        'Firstname Lastname (UserLogin)' => '',
        'FollowUp for [%s]. %s' => 'Prosecuzione per [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'Inoltrato a "%s".',
        'French' => 'Francese',
        'French (Canada)' => 'Francese (Canada)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
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
        'Frontend theme' => 'Tema per l\'interfaccia',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'Galician' => 'Galiziano',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'GenericAgent' => 'OperatoreGenerico',
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
        'German' => 'Tedesco',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Go back' => 'Indietro',
        'Google Authenticator' => '',
        'Greek' => 'Greco',
        'Hebrew' => 'Ebraico',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            '',
        'Hindi' => 'Hindi',
        'Hungarian' => 'Ungherese',
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
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
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
            '',
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
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Lingua dell\'interfaccia',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian' => 'Italiano',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Japanese' => 'Giapponese',
        'JavaScript function for the search frontend.' => '',
        'Lastname, Firstname' => 'Cognome, Nome',
        'Lastname, Firstname (UserLogin)' => 'Cognome, Nome (Utente)',
        'Latvian' => 'Lettone',
        'Left' => 'Sinistra',
        'Link agents to groups.' => '',
        'Link agents to roles.' => '',
        'Link attachments to templates.' => '',
        'Link customer user to groups.' => '',
        'Link customer user to services.' => '',
        'Link queues to auto responses.' => '',
        'Link roles to groups.' => '',
        'Link templates to queues.' => '',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
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
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lithuanian' => 'Lituano',
        'Lock / unlock this ticket' => '',
        'Locked ticket.' => 'Ticket bloccato.',
        'Log file for the ticket counter.' => '',
        'Loop-Protection! No auto-response sent to "%s".' => 'Loop-Protection! Nessuna risposta automatica inviata a "%s".',
        'Mail Accounts' => 'Account di posta',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => 'Malese',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => 'Gestisci le sessioni esistenti.',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark this ticket as junk!' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
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
        'Merge this ticket and all articles into a another ticket' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'Ticket <OTRS_TICKET> unito a <OTRS_MERGE_TO_TICKET>.',
        'Miscellaneous' => 'Varie',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
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
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '',
        'Module to grant access to the agent responsible of a ticket.' =>
            '',
        'Module to grant access to the creator of a ticket.' => '',
        'Module to grant access to the owner of a ticket.' => '',
        'Module to grant access to the watcher agents of a ticket.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => 'Selezione multipla',
        'My Services' => 'I miei servizi',
        'My Tickets' => 'I miei ticket',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'Nederlands' => 'Olandese',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Nuovo ticket [%s] creato (Q=%s;P=%s;S=%s).',
        'New Window' => 'Nuova finestra',
        'New owner is "%s" (ID=%s).' => 'Nuovo operatore assegnato = "%s" (ID=%s).',
        'New process ticket' => '',
        'New responsible is "%s" (ID=%s).' => 'Il nuovo responsabile è "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'None' => 'Nessuno',
        'Norwegian' => 'Norvegese',
        'Notification sent to "%s".' => 'Notifica inviata a "%s".',
        'Number of displayed tickets' => 'Numero di richieste mostrate',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'Vecchio: "%s" Nuovo: "%s"',
        'Online' => 'In linea',
        'Open tickets (customer user)' => 'Ticket aperti (utente cliente)',
        'Open tickets (customer)' => 'Ticket aperti (cliente)',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Out Of Office' => 'Fuori sede',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Vista globale dei ticket scalati',
        'Overview Refresh Time' => 'Frequenza di aggiornamento della Vista Globale',
        'Overview of all open Tickets.' => 'Vista Globale di tutte le richieste aperte.',
        'PGP Key Management' => 'Gestione chiavi PGP',
        'PGP Key Upload' => 'Caricamento chiavi PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => 'Parametri per .',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
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
        'People' => 'Persone',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => 'Iraniano',
        'Picture-Upload' => 'Caricamento immagine',
        'Polish' => 'Polacco',
        'Portuguese' => 'Portoghese',
        'Portuguese (Brasil)' => 'Portoghese (Brasile)',
        'PostMaster Filters' => 'Filtri PostMaster',
        'PostMaster Mail Accounts' => 'Account di posta PostMaster',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process pending tickets.' => '',
        'ProcessID' => 'ID processo',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Vista per Coda',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => 'Intervallo di aggiornamento',
        'Removed subscription for user "%s".' => 'Rimossa sottoscrizione per l\'utente "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => 'Resoconti',
        'Reports (OTRS Business Solution™)' => 'Resoconti (OTRS Business Solution™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
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
        'Right' => 'Destra',
        'Roles <-> Groups' => 'Ruoli <-> Gruppi',
        'Run file based generic agent jobs (Note: module name need needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => 'Russo',
        'S/MIME Certificate Upload' => 'Caricamento certificato S/MIME',
        'SMS' => 'SMS',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen' => 'Schermo',
        'Search Customer' => 'Ricerca cliente',
        'Search User' => 'Cerca utente',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Second Queue' => '',
        'Select your frontend Theme.' => 'Scegli il tema per la tua interfaccia.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'Invia notifiche agli utenti.',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Serbian Cyrillic' => 'Serbo (Cirillico)',
        'Serbian Latin' => 'Serbo (Latino)',
        'Service view' => '',
        'Set minimum loglevel. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages.' =>
            '',
        'Set sender email addresses for this system.' => '',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
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
        'Sets the options for PGP binary.' => 'Imposta le opzioni per il binario di PGP.',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => 'Imposta la password per la chiave privata PGP.',
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Shared Secret' => 'Segreto condiviso',
        'Should the cache data be help in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => 'Mostra l\'agente attuale nell\'interfaccia utente.',
        'Show the current queue in the customer interface.' => 'Mostra la coda attuale nell\'interfaccia utente.',
        'Show the history for this ticket' => 'Mostra lo storico di questo ticket',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows information on how to start OTRS Daemon' => '',
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
        'Skin' => 'Tema',
        'Slovak' => 'Slovacco',
        'Slovenian' => 'Sloveno',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => 'Una descrizione!',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish' => 'Spagnolo',
        'Spanish (Colombia)' => 'Spagnolo (Colombia)',
        'Spanish (Mexico)' => 'Spagnolo (Messico)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
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
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
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
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Statistica#',
        'Status view' => 'Vista di stato',
        'Stores cookies after the browser has been closed.' => 'Memorizza i cookie dopo la chiusura del browser.',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Swahili' => 'Swahili',
        'Swedish' => 'Svedese',
        'System Maintenance' => 'Manutenzione di sistema',
        'System Request (%s).' => 'Richiesta di sistema (%s).',
        'Templates <-> Queues' => 'Modelli <-> Code',
        'Textarea' => 'Area di testo',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
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
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
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
        'This will allow the system to send text messages via SMS.' => '',
        'Ticket Notifications' => 'Notifiche ticket',
        'Ticket Queue Overview' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Ticket spostato nella coda "%s" (%s) dalla coda "%s" (%s).',
        'Ticket notifications' => 'Notifiche dei ticket',
        'Ticket overview' => 'Vista Globale delle richieste',
        'TicketNumber' => 'NumeroTicket',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => 'Titolo aggiornato: vecchio: "%s", nuovo: "%s"',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => 'Elemento della barra degli strumenti per una scorciatoia.',
        'Transport selection for ticket notifications.' => 'Selezione trasporto per le notifiche dei ticket.',
        'Tree view' => 'Vista ad albero',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => 'Turco',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Ukrainian' => 'Ucraino',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Ticket sbloccato.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => '',
        'Updated SLA to %s (ID=%s).' => 'SLA aggiornato a %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Servizio aggiornato a %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Tipo aggiornato a %s (ID=%s).',
        'Updated: %s' => 'Aggiornato: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Aggiornato: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => 'Vietnamita',
        'View performance benchmark results.' => 'Visualizza i risultati del test di performance',
        'View system log messages.' => 'Visualizza messaggi del log di sistema.',
        'Watch this ticket' => 'Osserva questo ticket',
        'We are performing scheduled maintenance.' => '',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Yes, but hide archived tickets' => 'Sì, ma nascondi i ticket archiviati',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'La tua selezione delle code preferite. Se attivata, riceverai notifiche tramite posta anche per queste code.',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            '',

    };
    # $$STOP$$
    return;
}

1;
