# --
# Kernel/Language/fr.pm - provides fr language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# --
# $Id: fr.pm,v 1.6 2003-01-03 19:54:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fr;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Fri Jan  3 20:40:04 2003 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minutes',
      ' 5 minutes' => ' 5 minutes',
      ' 7 minutes' => ' 7 minutes',
      '10 minutes' => '10 minutes',
      '15 minutes' => '15 minutes',
      'AddLink' => 'Ajouter un lien',
      'AdminArea' => 'Zone d\'administration',
      'all' => 'tout',
      'All' => 'Tout',
      'Attention' => 'Attention',
      'Bug Report' => 'Rapport d\'anomalie',
      'Cancel' => '',
      'Change' => 'Modifier',
      'change' => 'modifier',
      'change!' => 'modifier&nbsp;!',
      'click here' => '',
      'Comment' => 'Commentaire',
      'Customer' => 'Client',
      'Customer info' => 'Information client',
      'day' => 'jour',
      'days' => 'jours',
      'Description' => 'Description',
      'description' => 'description',
      'Don\'t work with UserID 1 (System account)! Create new users!' => '',
      'Done' => 'Fait',
      'end' => 'fin',
      'Error' => 'Erreur',
      'Example' => 'Exemple',
      'Examples' => 'Exemples',
      'Facility' => '',
      'Feature not acitv!' => '',
      'go' => '',
      'go!' => 'c\'est parti&nbsp;!',
      'Group' => 'Groupe',
      'Hit' => 'Hit',
      'Hits' => 'Hits',
      'hour' => 'heure',
      'hours' => 'heures',
      'Ignore' => 'Ignorer',
      'invalid' => '',
      'Invalid SessionID!' => '',
      'Language' => 'Langue',
      'Languages' => 'Langues',
      'Line' => 'Ligne',
      'Lite' => '',
      'Login failed! Your username or password was entered incorrectly.' => '',
      'Logout successful. Thank you for using OTRS!' => 'Déconnection réussie. Merci d\'avoir utilisé OTRS!',
      'Message' => 'Message',
      'minute' => 'minute',
      'minutes' => 'minutes',
      'Module' => 'Module',
      'Modulefile' => 'Fichier de module',
      'Name' => 'Nom',
      'New message' => 'Nouveau message',
      'New message!' => 'Nouveau message&nbsp;!',
      'No' => 'Non',
      'no' => 'aucun',
      'No suggestions' => 'Pas de suggestions',
      'none' => 'aucun',
      'none - answered' => 'aucun - répondu',
      'none!' => 'aucun&nbsp;!',
      'off' => 'éteint',
      'Off' => 'Éteint',
      'On' => 'Allumé',
      'on' => 'allumé',
      'Password' => 'Mot de Passe',
      'Pending till' => '',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Il faut répondre à ce(s) ticket(s) pour revenir à la vue normale de la file.',
      'Please contact your admin' => '',
      'please do not edit!' => 'Ne pas modifier&nbsp;!',
      'possible' => '',
      'QueueView' => 'Vue file',
      'reject' => '',
      'replace with' => 'remplacer par',
      'Reset' => 'Remise à zéro',
      'Salutation' => 'Salutation',
      'Signature' => 'Signature',
      'Sorry' => 'Désolé',
      'Stats' => 'Statistiques',
      'Subfunction' => 'sous-fonction',
      'submit' => 'soumettre',
      'submit!' => 'soumettre&nbsp;!',
      'Text' => 'Texte',
      'The recommended charset for your language is %s!' => 'Les jeux de charactères pour votre langue est %s!',
      'Theme' => 'Thème',
      'There is no account with that login name.' => '',
      'Timeover' => '',
      'top' => 'haut',
      'update' => 'Mise à jour',
      'update!' => 'actualiser&nbsp;!',
      'User' => 'Utilisateur',
      'Username' => 'Nom d\'utilisateur',
      'Valid' => 'Valide',
      'Warning' => 'Attention',
      'Welcome to OTRS' => 'Bienvenue à OTRS',
      'Word' => 'Mot',
      'wrote' => 'écrit',
      'yes' => 'oui',
      'Yes' => 'Oui',
      'You got new message!' => '',
      'You have %s new message(s)!' => '',
      'You have %s reminder ticket(s)!' => '',

    # Template: AAAMonth
      'Apr' => '',
      'Aug' => '',
      'Dec' => '',
      'Feb' => '',
      'Jan' => '',
      'Jul' => '',
      'Jun' => '',
      'Mar' => '',
      'May' => '',
      'Nov' => '',
      'Oct' => '',
      'Sep' => '',

    # Template: AAAPreferences
      'Custom Queue' => 'File d\'attente personnelle',
      'Follow up notification' => 'Notification de suivi',
      'Frontend' => 'Frontal',
      'Mail Management' => 'Gestion des Emails',
      'Move notification' => 'Notification de mouvement',
      'New ticket notification' => 'Notification de nouveau ticket',
      'Other Options' => 'Autres options',
      'Preferences updated successfully!' => 'Les préférences ont bien été mises à jours',
      'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
      'Select your frontend Charset.' => 'Choix du jeu de caractères du frontal',
      'Select your frontend language.' => 'Choix de la langue du frontal',
      'Select your frontend QueueView.' => 'Choisissez votre frontal de vue des files',
      'Select your frontend Theme.' => 'Choix du thème du frontal',
      'Select your QueueView refresh time.' => 'Choix du délai de rafraîchissement de la vue des files',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Me prévenir si un client envoie un suivi (follow-up) et que je suis le propriétaire du ticket.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Me prévenir si un ticket est déplacé dans une file personnalisé',
      'Send me a notification if a ticket is unlocked by the system.' => 'Me prévenir si un ticket est dévérouillé par le système',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Me prévenir si un nouveau ticket apparaît dans mes files personnelles.',
      'Ticket lock timeout notification' => 'Prévenir du dépassement du délai d\'un verrou ',

    # Template: AAATicket
      '1 very low' => '',
      '2 low' => '',
      '3 normal' => '',
      '4 high' => '',
      '5 very high' => '',
      'Action' => 'Action',
      'Age' => 'Vieillir',
      'Article' => 'Article',
      'Attachment' => 'Pièce jointe',
      'Attachments' => 'Pièces jointes',
      'Bcc' => 'Copie Invisible',
      'Bounce' => 'Renvoyer',
      'Cc' => 'Copie ',
      'Close' => 'Fermer',
      'closed successful' => 'clôture réussie',
      'closed unsuccessful' => 'clôture manquée',
      'Compose' => 'Composer',
      'Created' => 'Créé ',
      'Createtime' => 'Création du ',
      'email' => 'courriel',
      'eMail' => 'courriel',
      'email-external' => 'message externe',
      'email-internal' => 'message interne',
      'Forward' => 'Transmettre',
      'From' => 'De ',
      'high' => 'bloque tout un poste',
      'History' => 'Historique',
      'If it is not displayed correctly,' => 'Si il n\'est pas affiché correctement',
      'Lock' => 'Verrouiller',
      'low' => 'confort de fonctionnement',
      'Move' => 'Déplacer',
      'new' => 'nouveau',
      'normal' => 'bloque une fonction',
      'note-external' => 'Note externe',
      'note-internal' => 'Note interne',
      'note-report' => 'Note rapport',
      'open' => 'ouvrir',
      'Owner' => 'Propriétaire',
      'Pending' => 'En attente',
      'pending auto close+' => '',
      'pending auto close-' => '',
      'pending reminder' => '',
      'phone' => 'téléphone',
      'plain' => 'tel quel',
      'Priority' => 'Priorité',
      'Queue' => 'File',
      'removed' => 'supprimé',
      'Sender' => 'Émetteur',
      'sms' => 'sms',
      'State' => 'État',
      'Subject' => 'Sujet',
      'This is a' => 'Ceci est un',
      'This is a HTML email. Click here to show it.' => 'Ceci est un message au format HTML&nbsp;; cliquer ici pour l\'afficher.',
      'This message was written in a character set other than your own.' => '',
      'Ticket' => 'Ticket',
      'To' => 'À ',
      'to open it in a new window.' => 'Pour l\'ouvrir dans une nouvelle fenêtre',
      'Unlock' => 'Déverrouiller',
      'very high' => 'bloque un service entier',
      'very low' => 'confort intellectuel',
      'View' => 'Vue',
      'webrequest' => 'Requete par le web',
      'Zoom' => 'Détail',

    # Template: AAAWeekDay
      'Fri' => '',
      'Mon' => '',
      'Sat' => '',
      'Sun' => '',
      'Thu' => '',
      'Tue' => '',
      'Wed' => '',

    # Template: AdminAttachmentForm
      'Add attachment' => '',
      'Attachment Management' => '',
      'Change attachment settings' => '',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Ajouter une réponse automatique',
      'Auto Response From' => 'Réponse automatique de ',
      'Auto Response Management' => 'Gestion des réponses automatiques',
      'Change auto response settings' => 'Modifier les paramètres de réponses automatiques',
      'Charset' => 'Jeu de charactère',
      'Note' => 'Note',
      'Response' => 'Réponse',
      'to get the first 20 character of the subject' => 'pour avoir les 20 premiers charactères du sujet ',
      'to get the first 5 lines of the email' => 'pour avoir les 5 premières ligne du mail',
      'to get the from line of the email' => '',
      'to get the realname of the sender (if given)' => '',
      'to get the ticket number of the ticket' => '',
      'Type' => 'Type',
      'Useable options' => 'Options accessibles',

    # Template: AdminCharsetForm
      'Add charset' => 'Ajouter un jeu de caractères système',
      'Change system charset setting' => 'Modification des paramètres du jeu de caractères système',
      'System Charset Management' => 'Gestion du jeu de caractères système',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Ajouter un utilisateur client',
      'Change customer user settings' => 'Changer les préférences utilisateurs du client',
      'Customer User Management' => 'Gestion des clients utilisateurs',
      'Customer user will be needed to to login via customer panels.' => '',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email de l\'administrateur',
      'Body' => 'Corps',
      'OTRS-Admin Info!' => 'Information de l\'administrateur OTRS',
      'Recipents' => 'Récipients',

    # Template: AdminEmailSent
      'Message sent to' => 'Message envoyé à',

    # Template: AdminGroupForm
      'Add group' => 'Ajouter un groupe',
      'Change group settings' => 'Changer les paramètres d\'un groupe',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'De nouveaux groupes permettront de gérer les droits d\'accès pour les différents groupes d\'un agent (exemple&nbsp;: achats, comptabilité, support, ventes...).',
      'Group Management' => 'Administration des groupes',
      'It\'s useful for ASP solutions.' => 'C\'est utile pour les fournisseurs d\'applications.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.',

    # Template: AdminLanguageForm
      'Add language' => 'Ajouter une langue',
      'Change system language setting' => 'Modification des parmètres de langue du système',
      'System Language Management' => 'Gestion des langues du système',

    # Template: AdminLog
      'System Log' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email de l\'administrateur.',
      'AgentFrontend' => 'Frontal d\'agent',
      'Auto Response <-> Queue' => 'Réponse Automatique <-> Files',
      'Auto Responses' => 'Réponses automatiques',
      'Charsets' => 'Jeu de Charactère',
      'Customer User' => 'Client Utilisateur',
      'Email Addresses' => 'Adresses courriel',
      'Groups' => 'Groupes',
      'Logout' => 'Déconnexion',
      'Misc' => '',
      'POP3 Account' => '',
      'Responses' => 'Réponses',
      'Responses <-> Queue' => 'Réponses <-> Files',
      'Select Box' => 'Choisissez une boîte',
      'Session Management' => 'Gestion des sessions',
      'Status defs' => '',
      'System' => '',
      'User <-> Groups' => 'Utilisateur <-> Groupes',

    # Template: AdminPOP3Form
      'Add POP3 Account' => '',
      'All incoming emails with one account will be dispatched in the selected queue!' => '',
      'Change POP3 Account setting' => '',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => '',
      'Login' => 'Login',
      'POP3 Account Management' => '',
      'Trusted' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestion des files <-> réponses automatiques',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = pas d\'escalade',
      '0 = no unlock' => '0 = pas de vérouillage',
      'Add queue' => 'Ajouter une file',
      'Change queue settings' => 'Modifier les paramètres des files',
      'Escalation time' => 'Délai d\'escalade',
      'Follow up Option' => 'Option des suivis',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
      'Key' => 'Clef',
      'Queue Management' => 'Gestion des files',
      'Systemaddress' => '',
      'The salutation for email answers.' => '',
      'The signature for email answers.' => '',
      'Ticket lock after a follow up' => '',
      'Unlock timeout' => 'Déverrouiller la temporisation',
      'Will be the sender address of this queue for email answers.' => '',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => '',
      'Std. Responses <-> Queue Management' => 'Gestion des réponses standard <-> files',

    # Template: AdminQueueResponsesForm
      'Answer' => '',
      'Change answer <-> queue settings' => 'Modifier les paramètres de réponses <-> files',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => '',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => '',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Une réponse est un texte par défaut destiné à rédiger plus rapidement des réponses standard aux clients.',
      'Add response' => 'Ajouter une réponse',
      'Change response settings' => 'Modifier les paramètres des réponses',
      'Don\'t forget to add a new response a queue!' => 'Ne pas oublier d\'ajouter une file à une nouvelle réponse&nbsp;!',
      'Response Management' => 'Gestion des réponses',

    # Template: AdminSalutationForm
      'Add salutation' => 'Ajouter une salutation',
      'Change salutation settings' => 'Modification des paramètres de salutations',
      'customer realname' => 'nom réel du client',
      'Salutation Management' => 'Gestion des salutations',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Nombre de lignes maximal',

    # Template: AdminSelectBoxResult
      'Limit' => '',
      'Select Box Result' => '',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'Terminer toutes les sessions',

    # Template: AdminSessionTable
      'kill session' => 'Terminer une session',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Add signature' => 'Ajouter une signature',
      'Change signature settings' => 'Modification des paramètres de signatures',
      'for agent firstname' => 'pour le prénom de l\'agent',
      'for agent lastname' => 'pour le nom de l\'agent',
      'Signature Management' => 'Gestion des signatures',

    # Template: AdminStateForm
      'Add state' => 'Ajouter un état',
      'Change system state setting' => 'Modification des paramètres d\'états du système',
      'System State Management' => 'Gestion des états du système',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Ajouter une adresse courriel du système',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tous les courriels avec cette adresse en destinataire (À&nbsp;:) seront placés dans la file choisie..',
      'Change system address setting' => 'Modification des paramètres des adresses courriel du système',
      'Email' => 'Courriel',
      'Realname' => '',
      'System Email Addresses Management' => 'Gestion des adresses courriel du système',

    # Template: AdminUserForm
      'Add user' => 'Ajouter un utilisateur',
      'Change user settings' => 'Modification des paramètres utilisateurs',
      'Don\'t forget to add a new user to groups!' => 'Ne pas oublier d\'ajouter un nouvel utilisateur aux groupes&nbsp;!',
      'Firstname' => 'Prénom',
      'Lastname' => 'Nom',
      'User Management' => 'Administration des utilisateurs',
      'User will be needed to handle tickets.' => 'Un utilisateur sera nécessaire pour gérer les tickets.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => '',
      'User <-> Group Management' => 'Gestion utilisateurs <-> groupes',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Modifier les paramètres utilisateurs <-> groupes',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Un message doit avoir un destinataire (À&nbsp;:)!',
      'Bounce ticket' => '',
      'Bounce to' => '',
      'Inform sender' => '',
      'Next ticket state' => 'Prochain état du ticket',
      'Send mail!' => 'Envoyer le courriel&nbsp;!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Il faut une adresse courriel (ecemple&nbsp;: client@exemple.fr)&nbsp;!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => '',

    # Template: AgentClose
      ' (work units)' => '',
      'Close ticket' => '',
      'Close type' => '',
      'Close!' => '',
      'Note Text' => '',
      'Note type' => 'Type de note',
      'store' => 'stocker',
      'Time units' => '',

    # Template: AgentCompose
      'A message should have a subject!' => 'Un message doit avoir un sujet&nbsp;!',
      'Attach' => '',
      'Compose answer for ticket' => 'Composer une réponse pour le ticket',
      'for pending* states' => '',
      'Is the ticket answered' => '',
      'Options' => '',
      'Pending Date' => '',
      'Spell Check' => '',

    # Template: AgentCustomer
      'Back' => 'retour',
      'Change customer of ticket' => '',
      'Set customer id of a ticket' => 'Définir le numéro de client d\'un ticket',

    # Template: AgentCustomerHistory
      'Customer history' => '',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
      'Customer Data' => '',

    # Template: AgentForward
      'Article type' => 'Type d\'article',
      'Date' => '',
      'End forwarded message' => '',
      'Forward article of ticket' => 'Transmettre l\'article du ticket',
      'Forwarded message from' => '',
      'Reply-To' => '',

    # Template: AgentHistoryForm
      'History of' => '',

    # Template: AgentMailboxNavBar
      'All messages' => '',
      'CustomerID' => 'Numéro de client#',
      'down' => '',
      'Mailbox' => '',
      'New' => '',
      'New messages' => '',
      'Open' => '',
      'Open messages' => '',
      'Order' => '',
      'Pending messages' => '',
      'Reminder' => '',
      'Reminder messages' => '',
      'Sort by' => '',
      'Tickets' => '',
      'up' => '',

    # Template: AgentMailboxTicket
      'Add Note' => 'Ajouter note',

    # Template: AgentNavigationBar
      'FAQ' => '',
      'Locked tickets' => 'Tickets verrouillés',
      'new message' => 'Nouveau message',
      'PhoneView' => 'Vue téléphone',
      'Preferences' => 'Préférences',
      'Utilities' => 'Utilitaires',

    # Template: AgentNote
      'Add note to ticket' => 'Ajouter une note au ticket',
      'Note!' => '',

    # Template: AgentOwner
      'Change owner of ticket' => '',
      'Message for new Owner' => '',
      'New user' => '',

    # Template: AgentPending
      'Pending date' => '',
      'Pending type' => '',
      'Set Pending' => '',

    # Template: AgentPhone
      'Customer called' => '',
      'Phone call' => 'Appel téléphonique',
      'Phone call at %s' => '',

    # Template: AgentPhoneNew
      'new ticket' => 'nouveau ticket',

    # Template: AgentPlain
      'ArticleID' => '',
      'Plain' => 'Tel quel',
      'TicketID' => '',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Choix des files personnelles',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Modification du mot de passe',
      'New password' => 'Nouveau mot de passe',
      'New password again' => 'Nouveau mot de passe (confirmation)',

    # Template: AgentPriority
      'Change priority of ticket' => 'Modification de la priorité du ticket',
      'New state' => '',

    # Template: AgentSpelling
      'Apply these changes' => '',
      'Discard all changes and return to the compose screen' => '',
      'Return to the compose screen' => '',
      'Spell Checker' => '',
      'spelling error(s)' => '',
      'The message being composed has been closed.  Exiting.' => '',
      'This window must be called from compose window' => '',

    # Template: AgentStatusView
      'D' => '',
      'sort downward' => '',
      'sort upward' => '',
      'Ticket limit:' => '',
      'Ticket Status' => '',
      'U' => '',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket verrouillé&nbsp;!',
      'unlock' => 'déverrouiller',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => '',
      'Customer history search (e. g. "ID342425").' => '',
      'No * possible!' => '',

    # Template: AgentUtilSearchByText
      'Article free text' => '',
      'Fulltext search' => '',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Recherche en texte intégral (exemple&nbsp;: "Mar*in" ou "Constru*" ou "martin+bonjour")',
      'Search in' => '',
      'Ticket free text' => '',

    # Template: AgentUtilSearchByTicketNumber
      'search' => '',
      'search (e. g. 10*5155 or 105658*)' => '',

    # Template: AgentUtilSearchNavBar
      'Results' => '',
      'Site' => '',
      'Total hits' => 'Total des hits',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All open tickets' => '',
      'open tickets' => '',
      'Provides an overview of all' => '',
      'So you see what is going on in your system.' => '',

    # Template: CustomerCreateAccount
      'Create' => '',
      'Create Account' => '',

    # Template: CustomerError
      'Backend' => '',
      'BackendMessage' => '',
      'Click here to report a bug!' => 'Cliquer ici pour signaler une anomalie',
      'Handle' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => '',
      'Home' => '',
      'Online-Support' => '',
      'Products' => '',
      'Support' => '',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => '',
      'Request new password' => '',

    # Template: CustomerMessage
      'Follow up' => '',

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => '',
      'My Tickets' => '',
      'New Ticket' => 'nouveau ticket',
      'Ticket-Overview' => '',
      'Welcome %s' => '',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'of' => '',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom
      'Accounted time' => '',

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
      'next step' => '',

    # Template: InstallerSystem
      '(Email of the system admin)' => '',
      '(Full qualified domain name of your system)' => '',
      '(Logfile just needed for File-LogModule!)' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => '',
      '(Used log backend)' => '',
      '(Used ticket number format)' => '',
      'Default Charset' => '',
      'Default Language' => '',
      'Logfile' => '',
      'LogModule' => '',
      'Organization' => '',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => '',
      'Webfrontend' => '',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Pas d\'autorisation',

    # Template: Notify
      'Info' => '',

    # Template: QueueView
      'All tickets' => 'tous les tickets',
      'Queues' => 'Files',
      'Show all' => 'Tout montrer',
      'Ticket available' => 'Tickets disponibles',
      'tickets' => 'Tickets',
      'Tickets shown' => 'Tickets affichés',

    # Template: SystemStats
      'Graphs' => 'Graphiques',

    # Template: Test
      'OTRS Test Page' => '',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Escalade du ticket',

    # Template: TicketView
      'Change queue' => 'Changer de file',
      'Compose Answer' => 'Composer une réponse',
      'Contact customer' => 'Contacter le client',
      'Escalation in' => '',
      'phone call' => '',

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(cliquer ici pour ajouter un groupe)',
      '(Click here to add a queue)' => '(cliquer ici pour ajouter une file)',
      '(Click here to add a response)' => '(cliquer ici pour ajouter une réponse)',
      '(Click here to add a salutation)' => '(cliquer ici pour ajouter une salutation)',
      '(Click here to add a signature)' => '(cliquer ici pour ajouter une signature)',
      '(Click here to add a system email address)' => '(cliquer ici pour ajouter une adresse courriel du système)',
      '(Click here to add a user)' => '(cliquer ici pour ajouter un utilisateur)',
      '(Click here to add an auto response)' => '(cliquer ici pour ajouter une réponse automatique)',
      '(Click here to add charset)' => '(cliquer ici pour ajouter un jeu de caractères système',
      '(Click here to add language)' => '(cliquer ici pour ajouter une langue)',
      '(Click here to add state)' => '(cliquer ici pour ajouter un état)',
      'A message should have a From: recipient!' => '',
      'New ticket via call.' => '',
      'Time till escalation' => 'Durée avant escalade',
      'Update auto response' => 'Actualiser une réponse automatique',
      'Update charset' => 'Actualiser un jeu de caractères système',
      'Update group' => 'Actualiser un groupe',
      'Update language' => 'Actualiser une langue',
      'Update queue' => 'Actualiser une file',
      'Update response' => 'Actualiser une réponse',
      'Update salutation' => 'Actualiser une salutation',
      'Update signature' => 'Actualiser une signature',
      'Update state' => 'Actualiser un état',
      'Update system address' => 'Actualiser les adresses courriel du système',
      'Update user' => 'Actualiser un utilisateur',
      'You have to be in the admin group!' => 'Il est nécessaire d\'être dans le groupe d\'administration&nbsp;!',
      'You have to be in the stats group!' => 'Il est nécessaire d\'être dans le groupe des statistiques&nbsp;!',
      'You need a email address (e. g. customer@example.com) in From:!' => '',
      'auto responses set' => 'Réponse automatique positionnée',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;

}
# --
1;
