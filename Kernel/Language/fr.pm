# Kernel/Language/fr.pm - provides fr language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# --
# $Id: fr.pm,v 1.20 2003-04-12 22:36:35 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fr;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.20 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Sun Apr 13 00:30:52 2003 by 

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
      'agent' => '',
      'all' => 'tout',
      'All' => 'Tout',
      'Attention' => 'Attention',
      'Bug Report' => 'Rapport d\'anomalie',
      'Cancel' => 'Annuler',
      'change' => 'modifier',
      'Change' => 'Modifier',
      'change!' => 'modifier&nbsp;!',
      'click here' => 'Cliquer là',
      'Comment' => 'Commentaire',
      'Customer' => 'Client',
      'customer' => '',
      'Customer Info' => 'Information client',
      'day' => 'jour',
      'days' => 'jours',
      'description' => 'description',
      'Description' => 'Description',
      'Dispatching by email To: field.' => 'Répartition par le champs \'à\' de l\'email',
      'Dispatching by selected Queue.' => 'Répartition par la file sélectionnée',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Cela ne fonctionne pas avec l\'ID utilisateur 1 (Compte Système)! Veuillez créer un nouvel utilisateur!',
      'Done' => 'Fait',
      'end' => 'fin',
      'Error' => 'Erreur',
      'Example' => 'Exemple',
      'Examples' => 'Exemples',
      'Facility' => 'Facilité',
      'Feature not active!' => '',
      'go' => 'Go',
      'go!' => 'c\'est parti&nbsp;!',
      'Group' => 'Groupe',
      'Hit' => 'Hit',
      'Hits' => 'Hits',
      'hour' => 'heure',
      'hours' => 'heures',
      'Ignore' => 'Ignorer',
      'invalid' => 'invalide',
      'Invalid SessionID!' => 'ID de Session Invalide',
      'Language' => 'Langue',
      'Languages' => 'Langues',
      'Line' => 'Ligne',
      'Lite' => 'allégée',
      'Login failed! Your username or password was entered incorrectly.' => 'La connection a échoué ! Votre nom d\'utilisateur ou votre mot de passe a été saisie incorrectement',
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
      'no' => 'aucune',
      'No entry found!' => '',
      'No suggestions' => 'Pas de suggestions',
      'none' => 'aucun',
      'none - answered' => 'aucun - répondu',
      'none!' => 'aucun&nbsp;!',
      'Off' => 'éteint',
      'off' => 'Éteint',
      'On' => 'Allumé',
      'on' => 'allumé',
      'Password' => 'Mot de Passe',
      'Pending till' => 'En attendant jusqu\'à',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Il faut répondre à ce(s) ticket(s) pour revenir à la vue normale de la file.',
      'Please contact your admin' => 'Veuillez contacter votre admnistrateur',
      'please do not edit!' => 'Ne pas modifier&nbsp;!',
      'possible' => 'possible',
      'QueueView' => 'Vue file',
      'reject' => 'rejeté',
      'replace with' => 'remplacer par',
      'Reset' => 'Remise à zéro',
      'Salutation' => 'Salutation',
      'Session has timed out. Please log in again.' => '',
      'Signature' => 'Signature',
      'Sorry' => 'Désolé',
      'Stats' => 'Statistiques',
      'Subfunction' => 'sous-fonction',
      'submit' => 'soumettre',
      'submit!' => 'soumettre&nbsp;!',
      'system' => '',
      'Take this User' => '',
      'Text' => 'Texte',
      'The recommended charset for your language is %s!' => 'Les jeux de charactères pour votre langue est %s!',
      'Theme' => 'Thème',
      'There is no account with that login name.' => 'Il n\'y a aucun compte avec ce login',
      'Timeover' => 'Temp écoulé',
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
      'You got new message!' => 'Vous avez un nouveau message',
      'You have %s new message(s)!' => 'Vous avez %s nouveau(x) message(s)',
      'You have %s reminder ticket(s)!' => 'Vous avez %s rappel(s) de ticket(s)',

    # Template: AAAMonth
      'Apr' => 'Avr',
      'Aug' => 'Aou',
      'Dec' => 'Déc',
      'Feb' => 'Fév',
      'Jan' => 'Jan',
      'Jul' => 'Juil',
      'Jun' => 'Juin',
      'Mar' => 'Mar',
      'May' => 'Mai',
      'Nov' => 'Nov',
      'Oct' => 'Oct',
      'Sep' => 'Sep',

    # Template: AAAPreferences
      'Closed Tickets' => '',
      'Custom Queue' => 'File d\'attente personnelle',
      'Follow up notification' => 'Notification de suivi',
      'Frontend' => 'Interface',
      'Mail Management' => 'Gestion des Emails',
      'Move notification' => 'Notification de mouvement',
      'New ticket notification' => 'Notification de nouveau ticket',
      'Other Options' => 'Autres options',
      'Preferences updated successfully!' => 'Les préférences ont bien été mises à jours',
      'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
      'Select your default spelling dictionary.' => '',
      'Select your frontend Charset.' => 'Choix du jeu de caractères de l\'interface',
      'Select your frontend language.' => 'Choix de la langue de l\'interface',
      'Select your frontend QueueView.' => 'Choisissez votre interface de vue des files',
      'Select your frontend Theme.' => 'Choix du thème de l\'interface',
      'Select your QueueView refresh time.' => 'Choix du délai de rafraîchissement de la vue des files',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Me prévenir si un client envoie un suivi (follow-up) et que je suis le propriétaire du ticket.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Me prévenir si un ticket est déplacé dans une file personnallisé',
      'Send me a notification if a ticket is unlocked by the system.' => 'Me prévenir si un ticket est dévérouillé par le système',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Me prévenir si un nouveau ticket apparaît dans mes files personnelles.',
      'Show closed tickets.' => '',
      'Spelling Dictionary' => '',
      'Ticket lock timeout notification' => 'Prévenir du dépassement du délai d\'un verrou ',

    # Template: AAATicket
      '1 very low' => '1 très bas',
      '2 low' => '2 bas',
      '3 normal' => '3 normal',
      '4 high' => '4 important',
      '5 very high' => '5 très important',
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
      'high' => 'Important',
      'History' => 'Historique',
      'If it is not displayed correctly,' => 'S\'il n\'est pas affiché correctement',
      'lock' => '',
      'Lock' => 'Vérrouiller',
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
      'pending auto close+' => 'En attendant la fermeture automatique(+)',
      'pending auto close-' => 'En attendant la fermeture automatique(-)',
      'pending reminder' => 'En attendant le rappel',
      'phone' => 'téléphone',
      'plain' => 'tel quel',
      'Priority' => 'Priorité',
      'Queue' => 'File',
      'removed' => 'supprimé',
      'Sender' => 'émetteur',
      'sms' => 'sms',
      'State' => 'état',
      'Subject' => 'Sujet',
      'This is a' => 'Ceci est un',
      'This is a HTML email. Click here to show it.' => 'Ceci est un message au format HTML&nbsp;; cliquer ici pour l\'afficher.',
      'This message was written in a character set other than your own.' => 'Ce message a été &eaute;crit dans un type de charactè autre que le v&ociric;tre',
      'Ticket' => 'Ticket',
      'To' => 'à ',
      'to open it in a new window.' => 'Pour l\'ouvrir dans une nouvelle fenêtre',
      'unlock' => 'déverrouiller',
      'Unlock' => 'Déverrouiller',
      'very high' => 'bloque un service entier',
      'very low' => 'confort intellectuel',
      'View' => 'Vue',
      'webrequest' => 'Requete par le web',
      'Zoom' => 'Détails',

    # Template: AAAWeekDay
      'Fri' => 'Ven',
      'Mon' => 'Lun',
      'Sat' => 'Sam',
      'Sun' => 'Dim',
      'Thu' => 'Mar',
      'Tue' => 'Jeu',
      'Wed' => 'Mer',

    # Template: AdminAttachmentForm
      'Add attachment' => 'Ajouter une pièce',
      'Attachment Management' => 'Gestion des attachements',
      'Change attachment settings' => 'Changer les param&ecirc;etres d\'attachement',

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
      'to get the from line of the email' => 'pour avoir les lignes \'From\' du mail',
      'to get the realname of the sender (if given)' => 'pour avoir le nom réel de l\'utilisateur (s\il est donné)',
      'to get the ticket id of the ticket' => '',
      'to get the ticket number of the ticket' => 'pour avoir le numéro du ticket',
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
      'Customer user will be needed to to login via customer panels.' => 'Les clients utilisateurs seront invité à se connecter par la page client.',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email de l\'administrateur',
      'Body' => 'Corps',
      'OTRS-Admin Info!' => 'Information de l\'administrateur OTRS',
      'Permission' => '',
      'Recipents' => 'Récipients',
      'send' => '',

    # Template: AdminEmailSent
      'Message sent to' => 'Message envoyé à',

    # Template: AdminGroupForm
      'Add group' => 'Ajouter un groupe',
      'Change group settings' => 'Changer les paramètres d\'un groupe',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'De nouveaux groupes permettront de gérer les droits d\'accès pour les différents groupes d\'un agent (exemple&nbsp;: achats, comptabilité, support, ventes...).',
      'Group Management' => 'Administration des groupes',
      'It\'s useful for ASP solutions.' => 'C\'est utile pour les fournisseurs d\'applications.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.',

    # Template: AdminLog
      'System Log' => 'Logs du Système',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email de l\'administrateur.',
      'AgentFrontend' => 'Interface de l\'agent',
      'Attachment <-> Response' => '',
      'Auto Response <-> Queue' => 'Réponse Automatique <-> Files',
      'Auto Responses' => 'Réponses automatiques',
      'Charsets' => 'Jeu de Charactère',
      'Customer User' => 'Client Utilisateur',
      'Email Addresses' => 'Adresses électroniques',
      'Groups' => 'Groupes',
      'Logout' => 'Déconnexion',
      'Misc' => 'Divers',
      'POP3 Account' => 'Compte POP3',
      'Responses' => 'Réponses',
      'Responses <-> Queue' => 'Réponses <-> Files',
      'Select Box' => 'Requête SQL libre.',
      'Session Management' => 'Gestion des sessions',
      'Status' => '',
      'System' => 'Système',
      'User <-> Groups' => 'Utilisateur <-> Groupes',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Ajouter un compte POP3',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Tout les mails entrants avec un compte seront répartis dans la file sélectionné',
      'Change POP3 Account setting' => 'Changer les param&ecirc;tres du compte POP3',
      'Dispatching' => 'Répartition',
      'Host' => 'Hôte',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Si votre compte est vérifié, les en-t&ecirc;tes x-otrs (pour les priorités,...) seront utilisés',
      'Login' => 'Nom d\'utilisateur',
      'POP3 Account Management' => 'Gestion du compte POP3',
      'Trusted' => 'Vérifié',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestion des files <-> réponses automatiques',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = pas d\'escalade',
      '0 = no unlock' => '0 = pas de vérouillage',
      'Add queue' => 'Ajouter une file',
      'Change queue settings' => 'Modifier les paramètres des files',
      'Customer Move Notify' => '',
      'Customer Owner Notify' => '',
      'Customer State Notify' => '',
      'Escalation time' => 'Délai d\'escalade',
      'Follow up Option' => 'Option des suivis',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si un ticket est cloturé et que le client envoie une note, le ticket pour l\'ancien propriétaire',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Si un ticket n\'est pas répondu dans le temps impartit, alors juste ce ticket sera affiché',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un agent vérouille un ticket et qu\'il/elle n\'envoie pas une réponse dans le temps impartit, le ticket sera dévérouillé automatiquement.',
      'Key' => 'Clef',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'Queue Management' => 'Gestion des files',
      'Sub-Queue of' => '',
      'Systemaddress' => 'Adresse du Système',
      'The salutation for email answers.' => 'La formule de politesse pour les réponses par mail',
      'The signature for email answers.' => 'La signature pour les réponses par email',
      'Ticket lock after a follow up' => 'Ticket bloqué aprés un suivi',
      'Unlock timeout' => 'Temporisation du déverrouillage',
      'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expépédition pour les réponses par courrier électronique',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Changer les param&ecirc;tres de %s',
      'Std. Responses <-> Queue Management' => 'Gestion des réponses standard <-> files',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Réponse',
      'Change answer <-> queue settings' => 'Modifier les paramètres de réponses <-> files',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Réponses Std <-> Gestion des attachements Std',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Paraàm&ecirc;tre des attachements',

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
      'for agent firstname' => 'pour le prénom de l\'agent',
      'for agent lastname' => 'pour le nom de l\'agent',
      'for agent login' => '',
      'for agent user id' => '',
      'Salutation Management' => 'Gestion des salutations',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Nombre de lignes maximales',

    # Template: AdminSelectBoxResult
      'Limit' => 'Limite',
      'Select Box Result' => 'Choisissez le résultat',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'Terminer toutes les sessions',

    # Template: AdminSessionTable
      'kill session' => 'Terminer une session',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Add signature' => 'Ajouter une signature',
      'Change signature settings' => 'Modification des paramètres de signatures',
      'Signature Management' => 'Gestion des signatures',

    # Template: AdminStateForm
      'Add state' => 'Ajouter un état',
      'Change system state setting' => 'Modification des paramètres d\'états du système',
      'State Type' => '',
      'System State Management' => 'Gestion des états du système',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Ajouter une adresse électronique du système',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tous les courriels avec cette adresse en destinataire (à&nbsp;:) seront placés dans la file choisie..',
      'Change system address setting' => 'Modification des paramètres des adresses courriel du système',
      'Email' => 'Courrier électronique',
      'Realname' => 'Véritable Nom',
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
      'Change  settings' => 'Changer les param&ecirc;tres',
      'User <-> Group Management' => 'Gestion utilisateurs <-> groupes',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Modifier les paramètres utilisateurs <-> groupes',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Un message doit avoir un destinataire (à&nbsp;:)!',
      'Bounce ticket' => 'Renvoyer le ticket',
      'Bounce to' => 'Renvoyer à',
      'Inform sender' => 'Informer l\'emetteur',
      'Next ticket state' => 'Prochain état du ticket',
      'Send mail!' => 'Envoyer le courriel&nbsp;!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Il faut une adresse courriel (ecemple&nbsp;: client@exemple.fr)&nbsp;!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Votre email avec le ticket numéro "<OTRS_TICKET> est renvoyer à "<OTRS_BOUNCE_TO>". Contactez cette adresse pour de plus amples renseignements',

    # Template: AgentClose
      ' (work units)' => ' Unité de travail',
      'A message should have a subject!' => 'Un message doit avoir un sujet&nbsp;!',
      'Close ticket' => 'Ticket clos',
      'Close type' => 'Type de cloture',
      'Close!' => 'Clôture!',
      'Note Text' => 'Note',
      'Note type' => 'Type de note',
      'Options' => '',
      'Spell Check' => 'Vérification orthographique',
      'Time units' => 'Unité de temps',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => '',
      'Attach' => 'Attaché',
      'Compose answer for ticket' => 'Composer une réponse pour le ticket',
      'for pending* states' => 'pour les états d\'attente',
      'Is the ticket answered' => 'Est-ce que le ticket est répondu',
      'Pending Date' => 'En attendant la date',

    # Template: AgentCustomer
      'Back' => 'retour',
      'Change customer of ticket' => 'Changer le numéro de client du ticket',
      'CustomerID' => 'Numéro de client#',
      'Search Customer' => 'Recherche de client',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'Customer history' => 'Historique du client',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerMessage
      'Follow up' => 'Note',
      'Next state' => '',

    # Template: AgentCustomerView
      'Customer Data' => 'Données client',

    # Template: AgentForward
      'Article type' => 'Type d\'article',
      'Date' => '',
      'End forwarded message' => 'Fin du message retransmit',
      'Forward article of ticket' => 'Transmettre l\'article du ticket',
      'Forwarded message from' => 'Message renvoyé par',
      'Reply-To' => 'Répondre à',

    # Template: AgentFreeText
      'Change free text of ticket' => '',
      'Value' => '',

    # Template: AgentHistoryForm
      'History of' => 'Historique de',

    # Template: AgentMailboxNavBar
      'All messages' => 'Tout les messages',
      'down' => 'bas',
      'Mailbox' => 'Bo&icirc;te aux lettres',
      'New' => 'Nouveau',
      'New messages' => 'Nouveaux messages',
      'Open' => 'Ouvrir',
      'Open messages' => 'Ouvrir des messages',
      'Order' => 'Ordre',
      'Pending messages' => 'Message en attente',
      'Reminder' => 'Rappel',
      'Reminder messages' => 'Message de rappel',
      'Sort by' => 'Trier par',
      'Tickets' => '',
      'up' => 'haut',

    # Template: AgentMailboxTicket

    # Template: AgentMove
      'Move Ticket' => '',
      'New Queue' => '',
      'New user' => 'Nouvel utilisateur',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Tickets verrouillés',
      'new message' => 'Nouveau message',
      'PhoneView' => 'Vue téléphone',
      'Preferences' => 'Préférences',
      'Utilities' => 'Utilitaires',

    # Template: AgentNote
      'Add note to ticket' => 'Ajouter une note au ticket',
      'Note!' => '',

    # Template: AgentOwner
      'Change owner of ticket' => 'Changer le propriétaire du ticket',
      'Message for new Owner' => 'Message pour le nouveau Propriétaire',

    # Template: AgentPending
      'Pending date' => 'Date d\'attente',
      'Pending type' => 'Type d\'attente',
      'Pending!' => '',
      'Set Pending' => 'Définir l\'attente',

    # Template: AgentPhone
      'Customer called' => 'Client appelé',
      'Phone call' => 'Appel téléphonique',
      'Phone call at %s' => 'Appel téléphonique à %s',

    # Template: AgentPhoneNew
      'Clear From' => '',
      'create' => '',
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
      'New state' => 'Nouvel état',

    # Template: AgentSpelling
      'Apply these changes' => 'Appliquer ces changements',
      'Discard all changes and return to the compose screen' => 'Annuler tout les changements et retourner à l\'écran de saisie',
      'Return to the compose screen' => 'Retourner à l\'écran de saisie',
      'Spell Checker' => 'Vérificateur orthographique',
      'spelling error(s)' => 'erreurs d\'orthographe',
      'The message being composed has been closed.  Exiting.' => 'Le message en cours de composition a été clôturé. Sortie.',
      'This window must be called from compose window' => 'Cette fene&ecirc;tre doit &ecirc;tre appelé de la fen&ecirc;tre de composition',

    # Template: AgentStatusView
      'D' => '',
      'of' => 'de',
      'Site' => '',
      'sort downward' => 'Tri décroissant',
      'sort upward' => 'Tri croissant',
      'Ticket Status' => 'Status du Ticket',
      'U' => '',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket verrouillé&nbsp;!',
      'Ticket unlock!' => '',

    # Template: AgentTicketPrint
      'by' => 'par',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Temp passé',
      'Escalation in' => 'Escalade dans',
      'printed by' => 'Imprimé par :',

    # Template: AgentUtilSearch
      'Article free text' => 'Texte dans l\'article',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Recherche intégral de texte (ex: "Mar*in" ou "Constru*" ou "martin+bonjour")',
      'search' => 'Recherche',
      'search (e. g. 10*5155 or 105658*)' => 'Recherche (ex: 10*5155 ou 105658*)',
      'Ticket free text' => 'Texte du ticket',
      'Ticket Search' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'recherche dans l\'historique client',
      'Customer history search (e. g. "ID342425").' => 'recherche dans l\'historique client (ex: "ID342425")',
      'No * possible!' => 'Pas de * possible',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Résultat',
      'Total hits' => 'Total des hits',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All closed tickets' => '',
      'All open tickets' => 'Tous les tickets ouverts',
      'closed tickets' => '',
      'open tickets' => 'tickets ouverts',
      'or' => '',
      'Provides an overview of all' => 'Propose un aperçu de tous',
      'So you see what is going on in your system.' => 'Donc vous voyez ce qui se passe sur votre syst&egrave;me',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => '',
      'Your own Ticket' => '',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Composer une réponse',
      'Contact customer' => 'Contacter le client',
      'phone call' => 'Appel téléphonique',

    # Template: AgentZoomArticle
      'Split' => '',

    # Template: AgentZoomBody
      'Change queue' => 'Changer de file',

    # Template: AgentZoomHead
      'Free Fields' => '',
      'Print' => 'Imprimer',

    # Template: AgentZoomStatus

    # Template: CustomerCreateAccount
      'Create Account' => 'Créer un compte',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => '',
      'Home' => 'Accueil',
      'Online-Support' => 'Support en ligne',
      'Products' => 'Produits',
      'Support' => '',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Mot de passe perdu ?',
      'Request new password' => 'Demande de nouveau mot de passe',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Crétion d\'un nouveau Ticket',
      'My Tickets' => 'Mes tickets',
      'New Ticket' => 'Nouveau Ticket',
      'Ticket-Overview' => 'Aperçu des Tickets',
      'Welcome %s' => 'Bienvenue %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Cliquer ici pour signaler une anomalie',

    # Template: Footer
      'Top of Page' => '',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => '',
      'Drop Database' => '',
      'Finished' => '',
      'System Settings' => '',

    # Template: InstallerLicense
      'accept license' => '',
      'don\'t accept license' => '',
      'License' => '',

    # Template: InstallerStart
      'next step' => 'étape suivante',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      '(Email of the system admin)' => 'Email de l\'administrateur systè',
      '(Full qualified domain name of your system)' => 'Nom de domaine complet de votre machine',
      '(Logfile just needed for File-LogModule!)' => 'fichier de log nécessaire pour le Module File-Log',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(L\'identité du système. Chaque numéro de ticket et chaque id de session http dé avec ce nombre)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificateur des tickets. Certaines personnes veulent le configurer avec par ex: \'Ticket#\', \'Appel#\' ou \'MonTicket#\')',
      '(Used default language)' => 'Langage par défaut utilisé',
      '(Used log backend)' => 'Backend de log utilisé',
      '(Used ticket number format)' => 'format numérique utilisé pour les tickets',
      'CheckMXRecord' => '',
      'Default Charset' => 'Charset par défaut',
      'Default Language' => 'Langage par défaut ',
      'Logfile' => 'fichier de log',
      'LogModule' => 'Module de log',
      'Organization' => 'Société',
      'System FQDN' => 'Nom de Domaine Complètement Renseigné du système',
      'SystemID' => 'ID Système',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Générateur de numéro pour les tickets',
      'Webfrontend' => 'Frontal web',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Pas d\'autorisation',

    # Template: Notify
      'Info' => '',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader

    # Template: QueueView
      'All tickets' => 'tous les tickets',
      'Queues' => 'Files',
      'Tickets available' => 'Tickets disponibles',
      'Tickets shown' => 'Tickets affichés',

    # Template: SystemStats
      'Graphs' => 'Graphiques',

    # Template: Test
      'OTRS Test Page' => 'Page de test d\'OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Escalade du ticket',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Ajouter une note',

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
      'A message should have a From: recipient!' => 'Un message devrait avoir un champ From:',
      'Add language' => 'Ajouter une langue',
      'Backend' => '',
      'BackendMessage' => 'Message du Backend',
      'Change system language setting' => 'Modification des parmètres de langue du système',
      'Create' => 'Créer',
      'FAQ' => '',
      'Feature not activ!' => 'Fonction non activé',
      'Fulltext search' => 'Recherche inégrale de texte',
      'Handle' => '',
      'New ticket via call.' => 'Nouveau ticket par téléphone',
      'Search in' => 'Recherche dans',
      'Set customer id of a ticket' => 'Définir le numéro de client d\'un ticket',
      'Show all' => 'Tout montrer',
      'Status defs' => 'Définitions des Status',
      'System Language Management' => 'Gestion des langues du système',
      'Ticket limit:' => 'limitation des Ticket',
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
      'Users' => 'Utilisateurs',
      'With State' => 'Avec l\'état',
      'You have to be in the admin group!' => 'Il est nécessaire d\'être dans le groupe d\'administration&nbsp;!',
      'You have to be in the stats group!' => 'Il est nécessaire d\'être dans le groupe des statistiques&nbsp;!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Vous devez avoir une adresse email dans le From:! (ex: client@example.com) ',
      'auto responses set' => 'Réponse automatique positionnée',
      'store' => 'stocker',
      'tickets' => 'Tickets',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;

}
# --
1;
