# Kernel/Language/fr.pm - provides fr language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# Copyright (C) 2004 Yann Richard <ze at nawak-online.org>
# --
# $Id: fr.pm,v 1.31 2004-02-26 17:43:52 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fr;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.31 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Sun Feb 15 22:51:39 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minutes',
      ' 5 minutes' => ' 5 minutes',
      ' 7 minutes' => ' 7 minutes',
      '(Click here to add)' => '(Cliquez içi pour ajouter)',
      '10 minutes' => '10 minutes',
      '15 minutes' => '15 minutes',
      'AddLink' => 'Ajouter un lien',
      'Admin-Area' => 'Zone d\'administration',
      'agent' => 'technicien',
      'Agent-Area' => 'Interface du technicien',
      'all' => 'tout',
      'All' => 'Tout',
      'Attention' => 'Attention',
      'before' => 'avant',
      'Bug Report' => 'Rapport d\'anomalie',
      'Cancel' => 'Annuler',
      'change' => 'modifier',
      'Change' => 'Modifier',
      'change!' => 'modifier !',
      'click here' => 'Cliquer ici',
      'Comment' => 'Commentaire',
      'Customer' => 'Client',
      'customer' => 'client',
      'Customer Info' => 'Information client',
      'day' => 'jour',
      'day(s)' => 'jour(s)',
      'days' => 'jours',
      'description' => 'description',
      'Description' => 'Description',
      'Dispatching by email To: field.' => 'Répartition par le champs \'à\' de l\'email',
      'Dispatching by selected Queue.' => 'Répartition selon la file sélectionnée',
      'Don\'t show closed Tickets' => 'Ne pas montrer les tickets fermés',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Cela ne fonctionne pas avec l\'identfifiant utilisateur 1 (Compte Système)! Veuillez créer un nouvel utilisateur!',
      'Done' => 'Fait',
      'end' => 'fin',
      'Error' => 'Erreur',
      'Example' => 'Exemple',
      'Examples' => 'Exemples',
      'Facility' => 'Facilité',
      'FAQ-Area' => 'Foire Aux Questions',
      'Feature not active!' => 'Cette fonctionnalité n\'est pas activée !',
      'go' => 'aller',
      'go!' => 'c\'est parti !',
      'Group' => 'Groupe',
      'Hit' => 'Hit',
      'Hits' => 'Hits',
      'hour' => 'heure',
      'hours' => 'heures',
      'Ignore' => 'Ignorer',
      'invalid' => 'invalide',
      'Invalid SessionID!' => 'ID de Session Invalide !',
      'Language' => 'Langue',
      'Languages' => 'Langues',
      'last' => 'dernier',
      'Line' => 'Ligne',
      'Lite' => 'allégée',
      'Login failed! Your username or password was entered incorrectly.' => 'La connection a échoué ! Votre nom d\'utilisateur ou votre mot de passe sont erronés.',
      'Logout successful. Thank you for using OTRS!' => 'Déconnection réussie. Merci d\'avoir utilisé OTRS!',
      'Message' => 'Message',
      'minute' => 'minute',
      'minutes' => 'minutes',
      'Module' => 'Module',
      'Modulefile' => 'Fichier de module',
      'month(s)' => 'mois',
      'Name' => 'Nom',
      'New Article' => 'Nouvel Article',
      'New message' => 'Nouveau message',
      'New message!' => 'Nouveau message !',
      'No' => 'Non',
      'no' => 'non',
      'No entry found!' => 'Aucun résultat n\'a été trouvé !',
      'No suggestions' => 'Pas de suggestions',
      'none' => 'aucun',
      'none - answered' => 'aucun - répondu',
      'none!' => 'aucun !',
      'Normal' => 'normal',
      'Off' => 'Éteint',
      'off' => 'éteint',
      'On' => 'Allumé',
      'on' => 'allumé',
      'Password' => 'Mot de Passe',
      'Pending till' => 'En attendant jusqu\'à',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Il faut répondre à ce(s) ticket(s) pour revenir à une vue normale de la file !',
      'Please contact your admin' => 'Veuillez contacter votre admnistrateur',
      'please do not edit!' => 'Ne pas modifier !',
      'Please go away!' => 'Passez votre chemin !',
      'possible' => 'possible',
      'Preview' => 'Aperçu',
      'QueueView' => 'Vue file',
      'reject' => 'rejeté',
      'replace with' => 'remplacer par',
      'Reset' => 'Remise à zéro',
      'Salutation' => 'Salutation',
      'Session has timed out. Please log in again.' => 'Le délai de votre session est dépassé, veuillez vous ré-authentifier.',
      'Show closed Tickets' => 'Voir les tickets fermés',
      'Signature' => 'Signature',
      'Sorry' => 'Désolé',
      'Stats' => 'Statistiques',
      'Subfunction' => 'sous-fonction',
      'submit' => 'soumettre',
      'submit!' => 'soumettre !',
      'system' => 'système',
      'Take this User' => 'Prendre cet utilisateur',
      'Text' => 'Texte',
      'The recommended charset for your language is %s!' => 'Le jeu de caractère correspondant à votre langue est %s!',
      'Theme' => 'Thème',
      'There is no account with that login name.' => 'Il n\'y a aucun compte avec ce nom de connexion',
      'Timeover' => 'Temp écoulé',
      'To: (%s) replaced with database email!' => 'Le champ \'à\' (%s) a été remplacé avec la valeur de la base de données des e-mail !',
      'top' => 'haut',
      'update' => 'mettre à jour',
      'Update' => 'Mettre à jour',
      'update!' => 'mettre à jour !',
      'User' => 'Utilisateur',
      'Username' => 'Nom d\'utilisateur',
      'Valid' => 'Valide',
      'Warning' => 'Attention',
      'week(s)' => 'semaine(s)',
      'Welcome to OTRS' => 'Bienvenue dans OTRS',
      'Word' => 'Mot',
      'wrote' => 'écrit',
      'year(s)' => 'année(s)',
      'yes' => 'oui',
      'Yes' => 'Oui',
      'You got new message!' => 'Vous avez un nouveau message !',
      'You have %s new message(s)!' => 'Vous avez %s nouveau(x) message(s) !',
      'You have %s reminder ticket(s)!' => 'Vous avez %s rappel(s) de ticket(s) !',

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
      'Closed Tickets' => 'Tickets fermés',
      'CreateTicket' => 'Créer Ticket',
      'Custom Queue' => 'File d\'attente personnalisé',
      'Follow up notification' => 'Notification de suivi',
      'Frontend' => 'Interface',
      'Mail Management' => 'Gestion des e-mails',
      'Max. shown Tickets a page in Overview.' => 'Nombre de ticket maximum sur la page d\'aperçu des tickets',
      'Max. shown Tickets a page in QueueView.' => 'Nombre de ticket maximum sur la page de la vue d\'une file',
      'Move notification' => 'Notification de mouvement',
      'New ticket notification' => 'Notification de nouveau ticket',
      'Other Options' => 'Autres options',
      'PhoneView' => 'Vue téléphone',
      'Preferences updated successfully!' => 'Les préférences ont bien été mises à jours !',
      'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
      'Screen after new ticket' => 'Ecran après un nouveau ticket',
      'Select your default spelling dictionary.' => 'Sélectionnez votre correcteur orthographique par défaut',
      'Select your frontend Charset.' => 'Choix du jeu de caractères de l\'interface',
      'Select your frontend language.' => 'Choix de la langue de l\'interface',
      'Select your frontend QueueView.' => 'Choisissez votre interface de vue des files',
      'Select your frontend Theme.' => 'Choix du thème de l\'interface',
      'Select your QueueView refresh time.' => 'Choix du délai de rafraîchissement de la vue des files',
      'Select your screen after creating a new ticket.' => 'Sélectionnez l\'écran qui sera affiché après avoir crée un nouveau ticket.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Me prévenir si un client envoie un suivi (follow-up) et que je suis le propriétaire du ticket.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Me prévenir si un ticket est déplacé dans une de mes files personnelles',
      'Send me a notification if a ticket is unlocked by the system.' => 'Me prévenir si un ticket est dévérouillé par le système',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Me prévenir si un nouveau ticket apparaît dans mes files personnelles.',
      'Show closed tickets.' => 'Voir les tickets fermés',
      'Spelling Dictionary' => 'Correcteur orthographique',
      'Ticket lock timeout notification' => 'Prévenir du dépassement du délai d\'un verrou',
      'TicketZoom' => 'Vue en détails',

    # Template: AAATicket
      '1 very low' => '1 très bas',
      '2 low' => '2 bas',
      '3 normal' => '3 normal',
      '4 high' => '4 important',
      '5 very high' => '5 très important',
      'Action' => 'Action',
      'Age' => 'Âge',
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
      'lock' => 'vérrouiller',
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
      'This is a HTML email. Click here to show it.' => 'Ceci est un message au format HTML ; cliquer ici pour l\'afficher.',
      'This message was written in a character set other than your own.' => 'Ce message a été &eaute;crit dans un jeu de caractères différent du v&ociric;tre.',
      'Ticket' => 'Ticket',
      'Ticket "%s" created!' => 'Le ticket %s a été crée !',
      'To' => 'à ',
      'to open it in a new window.' => 'L\'ouvrir dans une nouvelle fenêtre',
      'unlock' => 'déverrouiller',
      'Unlock' => 'Déverrouiller',
      'very high' => 'très haut',
      'very low' => 'très basse',
      'View' => 'Vue',
      'webrequest' => 'Requête par le web',
      'Zoom' => 'Détails',

    # Template: AAAWeekDay
      'Fri' => 'Ven',
      'Mon' => 'Lun',
      'Sat' => 'Sam',
      'Sun' => 'Dim',
      'Thu' => 'Jeu',
      'Tue' => 'Mar',
      'Wed' => 'Mer',

    # Template: AdminAttachmentForm
      'Add' => 'Ajouter',
      'Attachment Management' => 'Gestion des attachements',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Ajouter une réponse automatique',
      'Auto Response From' => 'Réponse automatique de ',
      'Auto Response Management' => 'Gestion des réponses automatiques',
      'Change auto response settings' => 'Modifier les paramètres de réponses automatiques',
      'Note' => 'Note',
      'Response' => 'Réponse',
      'to get the first 20 character of the subject' => 'pour avoir les 20 premiers caractères du sujet ',
      'to get the first 5 lines of the email' => 'pour avoir les 5 premières ligne du mail',
      'to get the from line of the email' => 'pour avoir les lignes \'From\' du mail',
      'to get the realname of the sender (if given)' => 'pour avoir le nom réel de l\'utilisateur (s\il est donné)',
      'to get the ticket id of the ticket' => 'pour avoir l\'identifiant du ticket',
      'to get the ticket number of the ticket' => 'pour avoir le numéro du ticket',
      'Type' => 'Type',
      'Useable options' => 'Options accessibles',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Gestion des clients utilisateurs',
      'Customer user will be needed to to login via customer panels.' => 'Les clients utilisateurs seront invité à se connecter par la page client.',
      'Select source:' => 'Sélectionnez la source',
      'Source' => 'Source',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Changer les param&ecirc;tres de %s',
      'Customer User <-> Group Management' => 'Client <-> Groupes',
      'Full read and write access to the tickets in this group/queue.' => 'Accès complet en lecture et écriture aux tickets dans cette file/groupe.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Si rien n\'est sélectionné, il n\'y aura pas de droits dans ce groupe (Les tickets ne seront plus disponible pour l\'utilisateur).',
      'Permission' => 'Droits',
      'Read only access to the ticket in this group/queue.' => 'Accès en lecture seulement aux tickets de cette file/groupe.',
      'ro' => 'lecture seule',
      'rw' => 'lecture/écriture',
      'Select the user:group permissions.' => 'Sélectionnez les permissions pour l\'utilisateur:groupe.',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Modifier les paramètres utilisateurs <-> groupes',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email de l\'administrateur',
      'Body' => 'Corps',
      'OTRS-Admin Info!' => 'Information de l\'administrateur OTRS !',
      'Recipents' => 'Récipients',
      'send' => 'envoyer',

    # Template: AdminEmailSent
      'Message sent to' => 'Message envoyé à',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'De nouveaux groupes permettront de gérer les droits d\'accès pour les différents groupes du technicien (exemple: achats, comptabilité, support, ventes...).',
      'Group Management' => 'Administration des groupes',
      'It\'s useful for ASP solutions.' => 'C\'est utile pour les fournisseurs d\'applications.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.',

    # Template: AdminLog
      'System Log' => 'Logs du Système',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email de l\'administrateur.',
      'Attachment <-> Response' => 'Pièce jointe <-> Réponse',
      'Auto Response <-> Queue' => 'Réponse Automatique <-> Files',
      'Auto Responses' => 'Réponses automatiques',
      'Customer User' => 'Client Utilisateur',
      'Customer User <-> Groups' => 'Client <-> Groupes',
      'Email Addresses' => 'Adresses électroniques',
      'Groups' => 'Groupes',
      'Logout' => 'Déconnexion',
      'Misc' => 'Divers',
      'Notifications' => 'Notifications',
      'PostMaster Filter' => 'PostMaster Filtre',
      'PostMaster POP3 Account' => 'PostMaster Compte POP3',
      'Responses' => 'Réponses',
      'Responses <-> Queue' => 'Réponses <-> Files',
      'Select Box' => 'Requête SQL libre.',
      'Session Management' => 'Gestion des sessions',
      'Status' => 'Statut',
      'System' => 'Système',
      'User <-> Groups' => 'Utilisateur <-> Groupes',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Options de configuration (ex: &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Gestion des notifications',
      'Notifications are sent to an agent or a customer.' => 'Des notifications sont envoyées à un technicien ou à un client.',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Options du propriétaire d\'un ticket (ex: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Tout les mails entrants avec un compte seront répartis dans la file sélectionné !',
      'Dispatching' => 'Répartition',
      'Host' => 'Hôte',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Si votre compte est vérifié, les en-t&ecirc;tes x-otrs (pour les priorités,...) seront utilisés !',
      'Login' => 'S\'authentifier',
      'POP3 Account Management' => 'Gestion du compte POP3',
      'Trusted' => 'Vérifié',

    # Template: AdminPostMasterFilterForm
      'Match' => '',
      'PostMasterFilter Management' => '',
      'Set' => 'Assigner',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestion des files <-> réponses automatiques',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = pas de remonté du ticket',
      '0 = no unlock' => '0 = pas de vérouillage',
      'Customer Move Notify' => 'Notification lors d\'un changement de file',
      'Customer Owner Notify' => 'Notification lors d\'un changement de propriétaire',
      'Customer State Notify' => 'Notification lors d\'un changement d\état',
      'Escalation time' => 'Délai de remonté du ticket',
      'Follow up Option' => 'Option des suivis',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si un ticket est cloturé et que le client envoie une note, le ticket pour l\'ancien propriétaire',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Si un ticket n\'est pas répondu dans le temps impartit, alors juste ce ticket sera affiché',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un technicien vérouille un ticket et qu\'il/elle n\'envoie pas une réponse dans le temps impartit, le ticket sera dévérouillé automatiquement.',
      'Key' => 'Clef',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envoit un e-mail au client quand la file d\'un ticket a changé',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envoit un e-mail au client quand le propriétaire d\'un ticket a changé',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envoit un e-mail au client quand l\'état d\'un ticket a changé',
      'Queue Management' => 'Gestion des files',
      'Sub-Queue of' => 'Sous-file',
      'Systemaddress' => 'Adresse du Système',
      'The salutation for email answers.' => 'La formule de politesse pour les réponses par mail',
      'The signature for email answers.' => 'La signature pour les réponses par email',
      'Ticket lock after a follow up' => 'Ticket bloqué aprés un suivi',
      'Unlock timeout' => 'Temporisation du déverrouillage',
      'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expépédition pour les réponses par courrier électronique',

    # Template: AdminQueueResponsesChangeForm
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
      'Don\'t forget to add a new response a queue!' => 'Ne pas oublier d\'ajouter une file à une nouvelle réponse !',
      'Next state' => 'Etat suivant',
      'Response Management' => 'Gestion des réponses',
      'The current ticket state is' => 'L\'état actuel du ticket est',

    # Template: AdminSalutationForm
      'customer realname' => 'nom réel du client',
      'for agent firstname' => 'pour le prénom du technicien',
      'for agent lastname' => 'pour le nom du technicien',
      'for agent login' => 'pour le nom de connexion (login) du technicien',
      'for agent user id' => 'pour l\'identifiant du technicien',
      'Salutation Management' => 'Gestion des salutations',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Nombre de lignes maximales',

    # Template: AdminSelectBoxResult
      'Limit' => 'Limite',
      'Select Box Result' => 'Choisissez le résultat',
      'SQL' => 'SQL',

    # Template: AdminSession
      'Agent' => 'Technicien',
      'kill all sessions' => 'Terminer toutes les sessions',
      'Overview' => 'Aperçu',
      'Sessions' => 'Session',
      'Uniq' => 'Unique',

    # Template: AdminSessionTable
      'kill session' => 'Terminer une session',
      'SessionID' => 'Identifiant de session',

    # Template: AdminSignatureForm
      'Signature Management' => 'Gestion des signatures',

    # Template: AdminStateForm
      'See also' => 'Voir aussi',
      'State Type' => 'Type d\'état',
      'System State Management' => 'Gestion des états du système',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Prennez garde de bien mettre à jour les états par défaut dans votre Kernelconfig.pm !',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tous les courriels avec cette adresse en destinataire (à :) seront placés dans la file choisie !',
      'Email' => 'Courrier électronique',
      'Realname' => 'Véritable Nom',
      'System Email Addresses Management' => 'Gestion des adresses courriel du système',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Ne pas oublier d\'ajouter un nouvel utilisateur aux groupes !',
      'Firstname' => 'Prénom',
      'Lastname' => 'Nom',
      'User Management' => 'Administration des utilisateurs',
      'User will be needed to handle tickets.' => 'Un utilisateur sera nécessaire pour gérer les tickets.',

    # Template: AdminUserGroupChangeForm
      'create' => 'créer',
      'move_into' => 'déplacer dans',
      'owner' => 'propriétaire',
      'Permissions to change the ticket owner in this group/queue.' => 'Permission de changer le propriétaire d\'un ticket dans cette file/groupe.',
      'Permissions to change the ticket priority in this group/queue.' => 'Permission de changer la priorité d\'un ticket dans cette file/groupe.',
      'Permissions to create tickets in this group/queue.' => 'Permission de créer un ticket dans cette file/groupe.',
      'Permissions to move tickets into this group/queue.' => 'Permission de déplacer un ticket dans cette file/groupe.',
      'priority' => 'priorité',
      'User <-> Group Management' => 'Gestion utilisateurs <-> groupes',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => 'Carnet d\'adresse',
      'Discard all changes and return to the compose screen' => 'Annuler tout les changements et retourner à l\'écran de saisie',
      'Return to the compose screen' => 'Retourner à l\'écran de saisie',
      'Search' => 'Chercher',
      'The message being composed has been closed.  Exiting.' => 'Le message en cours de composition a été clôturé. Sortie.',
      'This window must be called from compose window' => 'Cette fene&ecirc;tre doit &ecirc;tre appelé de la fen&ecirc;tre de composition',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Un message doit avoir un destinataire (à :)!',
      'Bounce ticket' => 'Renvoyer le ticket',
      'Bounce to' => 'Renvoyer à',
      'Inform sender' => 'Informer l\'emetteur',
      'Next ticket state' => 'Prochain état du ticket',
      'Send mail!' => 'Envoyer le courriel !',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Il faut une adresse courriel (ecemple : client@exemple.fr) !',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Votre email avec le ticket numéro "<OTRS_TICKET> est renvoyer à "<OTRS_BOUNCE_TO>". Contactez cette adresse pour de plus amples renseignements',

    # Template: AgentClose
      ' (work units)' => ' Unité de travail',
      'A message should have a body!' => 'Un message doit avoir un corp !',
      'A message should have a subject!' => 'Un message doit avoir un sujet !',
      'Close ticket' => 'Ticket clos',
      'Close type' => 'Type de cloture',
      'Close!' => 'Clôture!',
      'Note Text' => 'Note',
      'Note type' => 'Type de note',
      'Options' => 'Options',
      'Spell Check' => 'Vérification orthographique',
      'Time units' => 'Unité de temps',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => 'L\orthographe d\'un message doit être vérifié !',
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
      'Set customer user and customer id of a ticket' => 'Assigner une valeur pour le client et l\'identifiant client pour le ticket.',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Tout les tickets du client',
      'Customer history' => 'Historique du client',

    # Template: AgentCustomerMessage
      'Follow up' => 'Note',

    # Template: AgentCustomerView
      'Customer Data' => 'Données client',

    # Template: AgentEmailNew
      'All Agents' => 'Tout les techniciens',
      'Clear From' => 'Vider le formulaire',
      'Compose Email' => 'Ecrire un e-mail',
      'Lock Ticket' => 'Prendre le Ticket',
      'new ticket' => 'nouveau ticket',

    # Template: AgentForward
      'Article type' => 'Type d\'article',
      'Date' => 'Date',
      'End forwarded message' => 'Fin du message retransmit',
      'Forward article of ticket' => 'Transmettre l\'article du ticket',
      'Forwarded message from' => 'Message renvoyé par',
      'Reply-To' => 'Répondre à',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Changer le texte libre du ticket',
      'Value' => 'Valeur',

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
      'Tickets' => 'Tickets',
      'up' => 'haut',

    # Template: AgentMailboxTicket
      '"}' => '"}',
      '"}","14' => '"}","14',

    # Template: AgentMove
      'Move Ticket' => 'Changer la file du ticket',
      'New Owner' => 'Nouveau Propiétaire',
      'New Queue' => 'Nouvelle File',
      'Previous Owner' => 'Propriétaire Précédent',
      'Queue ID' => 'Identifiant de la File',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Tickets verrouillés',
      'new message' => 'Nouveau message',
      'Preferences' => 'Préférences',
      'Utilities' => 'Utilitaires',

    # Template: AgentNote
      'Add note to ticket' => 'Ajouter une note au ticket',
      'Note!' => 'Note !',

    # Template: AgentOwner
      'Change owner of ticket' => 'Changer le propriétaire du ticket',
      'Message for new Owner' => 'Message pour le nouveau Propriétaire',

    # Template: AgentPending
      'Pending date' => 'Date d\'attente',
      'Pending type' => 'Type d\'attente',
      'Pending!' => 'En attente !',
      'Set Pending' => 'Définir l\'attente',

    # Template: AgentPhone
      'Customer called' => 'Client appelé',
      'Phone call' => 'Appel téléphonique',
      'Phone call at %s' => 'Appel téléphonique à %s',

    # Template: AgentPhoneNew

    # Template: AgentPlain
      'ArticleID' => 'Identifiant de l\'Article',
      'Plain' => 'Tel quel',
      'TicketID' => 'Identifiant du Ticket',

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

    # Template: AgentSpelling
      'Apply these changes' => 'Appliquer ces changements',
      'Spell Checker' => 'Vérificateur orthographique',
      'spelling error(s)' => 'erreurs d\'orthographe',

    # Template: AgentStatusView
      'D' => 'A-Z',
      'of' => 'de',
      'Site' => 'Site',
      'sort downward' => 'Tri décroissant',
      'sort upward' => 'Tri croissant',
      'Ticket Status' => 'Status du Ticket',
      'U' => 'Z-A',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLink
      'Link' => 'Lien',
      'Link to' => 'Lien vers',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket verrouillé !',
      'Ticket unlock!' => 'Rendre le Ticket !',

    # Template: AgentTicketPrint
      'by' => 'par',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Temp passé',
      'Escalation in' => 'Remontée dans',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '(ex: 10*5155 or 105658*)',
      '(e. g. 234321)' => '(ex: 234321)',
      '(e. g. U5150)' => '(ex: U5150)',
      'and' => 'et le',
      'Customer User Login' => 'Nom de connexion du client',
      'Delete' => 'Effacer',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Recherche sur le texte d\'un article (ex: "Mar*in" or "Baue*")',
      'No time settings.' => 'Pas de paramettre de temps',
      'Profile' => 'Profil',
      'Result Form' => 'Format du résultat',
      'Save Search-Profile as Template?' => 'Sauver le profil de recherche ?',
      'Search-Template' => 'Profil de recherche',
      'Select' => 'Sélectionner',
      'Ticket created' => 'Ticket crée',
      'Ticket created between' => 'Ticket crée entre le',
      'Ticket Search' => 'Recherche de ticket',
      'TicketFreeText' => 'Texte Libre du Ticket',
      'Times' => 'Fois',
      'Yes, save it with name' => 'Oui, le sauver avec le nom',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'recherche dans l\'historique client',
      'Customer history search (e. g. "ID342425").' => 'recherche dans l\'historique client (ex: "ID342425")',
      'No * possible!' => 'Pas de * possible !',

    # Template: AgentUtilSearchNavBar
      'Change search options' => 'Changer les options de recherche',
      'Results' => 'Résultat',
      'Search Result' => 'Résultat de la recherche',
      'Total hits' => 'Total des hits',

    # Template: AgentUtilSearchResult
      '"}","15' => '"}","15',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '"}","30',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Tout les tickets fermés',
      'All open tickets' => 'Tous les tickets ouverts',
      'closed tickets' => 'tickets fermés',
      'open tickets' => 'tickets ouverts',
      'or' => 'ou',
      'Provides an overview of all' => 'Propose un aperçu de tous',
      'So you see what is going on in your system.' => 'Donc vous voyez ce qui se passe sur votre syst&egrave;me',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Fermer le suivie',
      'Your own Ticket' => 'Votre propre ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Composer une réponse',
      'Contact customer' => 'Contacter le client',
      'phone call' => 'Appel téléphonique',

    # Template: AgentZoomArticle
      'Split' => 'Partager',

    # Template: AgentZoomBody
      'Change queue' => 'Changer de file',

    # Template: AgentZoomHead
      'Free Fields' => 'Champs libre',
      'Print' => 'Imprimer',

    # Template: AgentZoomStatus
      '"}","18' => '"}","18',

    # Template: CustomerCreateAccount
      'Create Account' => 'Créer un compte',

    # Template: CustomerError
      'Traceback' => 'Trace du retour d\'erreur',

    # Template: CustomerFAQArticleHistory
      'Edit' => 'editer',
      'FAQ History' => 'Historique de la FAQ',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Cathégorie',
      'Keywords' => 'Mots clés',
      'Last update' => 'Dernière mise à jour',
      'Problem' => 'Problème',
      'Solution' => 'Solution',
      'Symptom' => 'Symptôme',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'Historique système de la FAQ',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'Article de la FAQ',
      'Modified' => 'Modifié',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'Vue d\'ensemble de la FAQ',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'Chercher dans la FAQ',
      'Fulltext' => 'Texte Complet',
      'Keyword' => 'Mot clé',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'Résultat de la recherche dans la FAQ',

    # Template: CustomerFooter
      'Powered by' => 'Fonction assuré par',

    # Template: CustomerHeader
      'Contact' => 'Contact',
      'Home' => 'Accueil',
      'Online-Support' => 'Support en ligne',
      'Products' => 'Produits',
      'Support' => 'Support',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Mot de passe perdu ?',
      'Request new password' => 'Demande de nouveau mot de passe',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Crétion d\'un nouveau Ticket',
      'FAQ' => 'FAQ',
      'New Ticket' => 'Nouveau Ticket',
      'Ticket-Overview' => 'Aperçu des Tickets',
      'Welcome %s' => 'Bienvenue %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Mes tickets',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Cliquer ici pour signaler une anomalie !',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Effacer la FAQ',
      'You really want to delete this article?' => 'Voulez vous vraiment effacer cet article ?',

    # Template: FAQArticleForm
      'Comment (internal)' => 'Commentaire interne',
      'Filename' => 'Nom de fichier',
      'Short Description' => 'Description Courte',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => 'Cathégorie dans la FAQ',

    # Template: FAQLanguageForm
      'FAQ Language' => 'Langue dans la FAQ',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => '',

    # Template: Footer
      'Top of Page' => 'Haut de page',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Créer la base de donnée',
      'Drop Database' => 'Effacer la base de donnée',
      'Finished' => 'Fini',
      'System Settings' => 'Paramèttres Système',
      'Web-Installer' => 'Installeur Web',

    # Template: InstallerFinish
      'Admin-User' => 'Administrateur',
      'After doing so your OTRS is up and running.' => 'Après avoir fait ceci votre OTRS est en service',
      'Have a lot of fun!' => 'Amusez vous bien !',
      'Restart your webserver' => 'Redemarrer votre serveur web',
      'Start page' => 'Page de départ',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Pour pouvoir utiliser votre OTRS, vous devez entrer les commandes suivantes dans votre terminal en tant que root.',
      'Your OTRS Team' => 'Votre Groupe OTRS',

    # Template: InstallerLicense
      'accept license' => 'Accepter la licence',
      'don\'t accept license' => 'Ne pas accepter la licence',
      'License' => 'Licence',

    # Template: InstallerStart
      'Create new database' => 'Créer une nouvelle base de donnée',
      'DB Admin Password' => 'Mot de passe administrateur base de donnée',
      'DB Admin User' => 'nom de connexion de l\'administrateur base de donnée',
      'DB Host' => 'Nom d\'hôte de la base',
      'DB Type' => 'Type de SGBD',
      'default \'hot\'' => '',
      'Delete old database' => 'Effacer l\'anciène base de donnée',
      'next step' => 'étape suivante',
      'OTRS DB connect host' => 'Hôte de la base OTRS',
      'OTRS DB Name' => 'Nom de la base OTRS',
      'OTRS DB Password' => 'Mot de passe de la base OTRS',
      'OTRS DB User' => 'Utilisateur de la base OTRS',
      'your MySQL DB should have a root password! Default is empty!' => 'Votre base MySQL doit avoir un mot de passe root ! Par défaut cela est vide !',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Verifie les enregistrements MX des adresse email utilisés lors de la composition d\'une réponse. N\'utilisez pas la "Vérification des enregistrements MX" si votre serveur OTRS est derriere une ligne modem $!',
      '(Email of the system admin)' => '(Email de l\'administrateur système)',
      '(Full qualified domain name of your system)' => '(Nom de domaine complet de votre machine)',
      '(Logfile just needed for File-LogModule!)' => '(fichier de log nécessaire pour le Module File-Log !)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(L\'identité du système. Chaque numéro de ticket et chaque id de session http dé avec ce nombre)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificateur des tickets. Certaines personnes veulent le configurer avec par ex: \'Ticket#\', \'Appel#\' ou \'MonTicket#\')',
      '(Used default language)' => '(Langage par défaut utilisé)',
      '(Used log backend)' => '(Backend de log utilisé)',
      '(Used ticket number format)' => '(Format numérique utilisé pour les tickets)',
      'CheckMXRecord' => 'Vérifier les enregistrements MX',
      'Default Charset' => 'Charset par défaut',
      'Default Language' => 'Langage par défaut ',
      'Logfile' => 'fichier de log',
      'LogModule' => 'Module de log',
      'Organization' => 'Société',
      'System FQDN' => 'Nom de Domaine Complètement Renseigné du système',
      'SystemID' => 'ID Système',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Générateur de numéro pour les tickets',
      'Use utf-8 it your database supports it!' => 'Utilisez UTF-8 si votre base de donnée le supporte !',
      'Webfrontend' => 'Frontal web',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Pas d\'autorisation',

    # Template: Notify
      'Info' => 'Information',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader
      'printed by' => 'Imprimé par :',

    # Template: QueueView
      'All tickets' => 'tous les tickets',
      'Page' => 'Page',
      'Queues' => 'Files',
      'Tickets available' => 'Tickets disponibles',
      'Tickets shown' => 'Tickets affichés',

    # Template: SystemStats
      'Graphs' => 'Graphiques',

    # Template: Test
      'OTRS Test Page' => 'Page de test d\'OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Remontée du ticket !',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Ajouter une note',

    # Template: Warning

    # Misc
      'A message should have a From: recipient!' => 'Un message devrait avoir un champ From: !',
      'AgentFrontend' => 'Interface du technicien',
      'Article free text' => 'Texte dans l\'article',
      'Charset' => 'Jeu de caractère',
      'Charsets' => 'Jeux de caractères',
      'Create' => 'Créer',
      'Feature not activ!' => 'Fonctionalité non active !',
      'Fulltext search' => 'Recherche inégrale de texte',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Recherche intégral de texte (ex: "Mar*in" ou "Constru*" ou "martin+bonjour")',
      'New state' => 'Nouvel état',
      'New ticket via call.' => 'Nouveau ticket par téléphone',
      'New user' => 'Nouvel utilisateur',
      'Search in' => 'Recherche dans',
      'Select your screen after creating a new ticket via PhoneView.' => 'Choisissez l\'écran qui sera affiché après avoir creé un ticket via la vue téléphone',
      'Set customer id of a ticket' => 'Définir le numéro de client d\'un ticket',
      'Show all' => 'Tout montrer',
      'Status defs' => 'Définitions des Status',
      'System Charset Management' => 'Gestion du jeu de caractères système',
      'System Language Management' => 'Gestion des langues du système',
      'Ticket free text' => 'Texte du ticket',
      'Ticket limit:' => 'limitation des Ticket',
      'Time till escalation' => 'Durée avant la remontée du ticket',
      'Users' => 'Utilisateurs',
      'With State' => 'Avec l\'état',
      'You have to be in the admin group!' => 'Il est nécessaire d\'être dans le groupe d\'administration !',
      'You have to be in the stats group!' => 'Il est nécessaire d\'être dans le groupe des statistiques !',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Vous devez avoir une adresse email dans le From:! (ex: client@example.com) ',
      'auto responses set' => 'Réponse automatique positionnée',
      'search' => 'Recherche',
      'search (e. g. 10*5155 or 105658*)' => 'Recherche (ex: 10*5155 ou 105658*)',
      'store' => 'stocker',
      'tickets' => 'Tickets',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;

}
# --
1;
