# Kernel/Language/fr.pm - provides fr language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# Copyright (C) 2004 Yann Richard <ze at nbox.org>
# Copyright (C) 2004 Igor Genibel <igor.genibel at eds-opensource.com>
# --
# $Id: fr.pm,v 1.38.2.1 2004-09-21 19:01:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fr;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.38.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Aug 24 10:08:55 2004 by 

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
      '...Back' => 'Revenir en arrière',
      '10 minutes' => '10 minutes',
      '15 minutes' => '15 minutes',
      'Added User "%s"' => 'Ajout de l\'utilisateur "%s"',
      'AddLink' => 'Ajouter un lien',
      'Admin-Area' => 'Zone d\'administration',
      'agent' => 'technicien',
      'Agent-Area' => 'Interface du technicien',
      'all' => 'tout',
      'All' => 'Tout',
      'Attention' => 'Attention',
      'Back' => 'retour',
      'before' => 'avant',
      'Bug Report' => 'Rapport d\'anomalie',
      'Calendar' => '',
      'Cancel' => 'Annuler',
      'change' => 'modifier',
      'Change' => 'Modifier',
      'change!' => 'modifier !',
      'click here' => 'Cliquer ici',
      'Comment' => 'Commentaire',
      'Contract' => '',
      'Crypt' => '',
      'Crypted' => '',
      'Customer' => 'Client',
      'customer' => 'client',
      'Customer Info' => 'Information client',
      'day' => 'jour',
      'day(s)' => 'jour(s)',
      'days' => 'jours',
      'description' => 'description',
      'Description' => 'Description',
      'Directory' => 'Répertoire',
      'Dispatching by email To: field.' => 'Répartition par le champs \'À:\' du courriel',
      'Dispatching by selected Queue.' => 'Répartition selon la file sélectionnée',
      'Don\'t show closed Tickets' => 'Ne pas montrer les tickets fermés',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Cela ne fonctionne pas avec l\'identfifiant utilisateur 1 (Compte Système)! Veuillez créer un nouvel utilisateur!',
      'Done' => 'Fait',
      'end' => 'fin',
      'Error' => 'Erreur',
      'Example' => 'Exemple',
      'Examples' => 'Exemples',
      'Facility' => 'Service',
      'FAQ-Area' => 'Foire Aux Questions',
      'Feature not active!' => 'Cette fonctionnalité n\'est pas activée !',
      'go' => 'aller',
      'go!' => 'c\'est parti !',
      'Group' => 'Groupe',
      'History::AddNote' => 'Ajout d\'une note (%s)',
      'History::Bounce' => 'Redirigé vers "%s".',
      'History::CustomerUpdate' => 'Mise à jour: %s',
      'History::EmailAgent' => 'Email envoyé au client.',
      'History::EmailCustomer' => 'Ajout d\'une adresse email. %s',
      'History::FollowUp' => 'Un suivie du ticket [%s]. %s',
      'History::Forward' => 'Transféré vers "%s".',
      'History::Lock' => 'Ticket vérouillé.',
      'History::LoopProtection' => 'Protection anti-boucle! Pas d\'auto réponse envoyé à "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Le ticket a été déplacé dans la file "%s" (%s) - Ancienne file: "%s" (%s).',
      'History::NewTicket' => 'Un nouveau ticket a été crée: [%s] created (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'Le nouveau propriétaire est "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'Agent a appellé le client.',
      'History::PhoneCallCustomer' => 'Le client nous a appellé.',
      'History::PriorityUpdate' => 'Changement de priorité de "%s" (%s) pour "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notification envoyé à "%s".',
      'History::SendAnswer' => 'Email envoyé à "%s".',
      'History::SendAutoFollowUp' => 'Suivie automatique envoyé à "%s".',
      'History::SendAutoReject' => 'Rejet automatique envoyé à "%s".',
      'History::SendAutoReply' => 'Réponse automatique envoyé à "%s".',
      'History::SendCustomerNotification' => 'Notification envoyé à "%s".',
      'History::SetPendingTime' => 'Mise à jour: %s',
      'History::StateUpdate' => 'Avant: "%s" Après: "%s"',
      'History::TicketFreeTextUpdate' => 'Mise à jour: %s=%s;%s=%s;',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
      'History::TimeAccounting' => 'Temps passé sur l\'action: %s . Total du temps passé pour ce ticket: %s unité(s).',
      'History::Unlock' => 'Ticket dévérouillé.',
      'History::WebRequestCustomer' => 'Requête du client via le web.',
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
      'Logout successful. Thank you for using OTRS!' => 'Déconnexion réussie. Merci d\'avoir utilisé OTRS!',
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
      'Next' => '',
      'Next...' => '',
      'No' => 'Non',
      'no' => 'non',
      'No entry found!' => 'Aucun résultat n\'a été trouvé !',
      'No Permission!' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'No suggestions' => 'Pas de suggestions',
      'none' => 'aucun',
      'none - answered' => 'aucun - répondu',
      'none!' => 'aucun !',
      'Normal' => 'normal',
      'off' => 'éteint',
      'Off' => 'Éteint',
      'On' => 'Allumé',
      'on' => 'allumé',
      'Online Agent: %s' => '',
      'Online Customer: %s' => '',
      'Password' => 'Mot de Passe',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Pending till' => 'En attendant jusqu\'à',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Il faut répondre à ce(s) ticket(s) pour revenir à une vue normale de la file !',
      'Please contact your admin' => 'Veuillez contacter votre admnistrateur',
      'please do not edit!' => 'Ne pas modifier !',
      'possible' => 'possible',
      'Preview' => 'Aperçu',
      'QueueView' => 'Vue file',
      'reject' => 'rejeté',
      'replace with' => 'remplacer par',
      'Reset' => 'Remise à zéro',
      'Salutation' => 'Salutation',
      'Session has timed out. Please log in again.' => 'Le délai de votre session est dépassé, veuillez vous ré-authentifier.',
      'Show closed Tickets' => 'Voir les tickets fermés',
      'Sign' => 'Signer',
      'Signature' => 'Signature',
      'Signed' => 'Signé',
      'Size' => 'Taille',
      'Sorry' => 'Désolé',
      'Stats' => 'Statistiques',
      'Subfunction' => 'sous-fonction',
      'submit' => 'soumettre',
      'submit!' => 'soumettre !',
      'system' => 'système',
      'Take this Customer' => 'Choisir ce client',
      'Take this User' => 'Choisir cet utilisateur',
      'Text' => 'Texte',
      'The recommended charset for your language is %s!' => 'Le jeu de caractère correspondant à votre langue est %s!',
      'Theme' => 'Thème',
      'There is no account with that login name.' => 'Il n\'y a aucun compte avec ce nom de connexion',
      'Ticket Number' => 'Numéro de ticket',
      'Timeover' => 'Temp écoulé',
      'To: (%s) replaced with database email!' => 'Le champ \'À:\' (%s) a été remplacé avec la valeur de la base de données des des adresses de courriel !',
      'top' => 'haut',
      'Type' => 'Type',
      'update' => 'mettre à jour',
      'Update' => 'Mettre à jour',
      'update!' => 'mettre à jour !',
      'Upload' => 'Uploader',
      'User' => 'Utilisateur',
      'Username' => 'Nom d\'utilisateur',
      'Valid' => 'Valide',
      'Warning' => 'Attention',
      'week(s)' => 'semaine(s)',
      'Welcome to OTRS' => 'Bienvenue dans OTRS',
      'Word' => 'Mot',
      'wrote' => 'écrit',
      'year(s)' => 'année(s)',
      'Yes' => 'Oui',
      'yes' => 'oui',
      'You got new message!' => 'Vous avez un nouveau message !',
      'You have %s new message(s)!' => 'Vous avez %s nouveau(x) message(s) !',
      'You have %s reminder ticket(s)!' => 'Vous avez %s rappel(s) de ticket(s) !',

    # Template: AAAMonth
      'Apr' => 'Avr',
      'Aug' => 'Aôu',
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
      'Max. shown Tickets a page in Overview.' => 'Nombre de tickets maximum sur la page d\'aperçu des tickets',
      'Max. shown Tickets a page in QueueView.' => 'Nombre de tickets maximum sur la page de la vue d\'une file',
      'Move notification' => 'Notification de mouvement',
      'New ticket notification' => 'Notification de nouveau ticket',
      'Other Options' => 'Autres options',
      'PhoneView' => 'Vue téléphone',
      'Preferences updated successfully!' => 'Les préférences ont bien été mises à jours !',
      'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
      'Screen after new ticket' => 'Écran après un nouveau ticket',
      'Select your default spelling dictionary.' => 'Sélectionnez votre correcteur orthographique par défaut',
      'Select your frontend Charset.' => 'Choix du jeu de caractères de l\'interface',
      'Select your frontend language.' => 'Choix de la langue de l\'interface',
      'Select your frontend QueueView.' => 'Choisissez votre interface de vue des files',
      'Select your frontend Theme.' => 'Choix du thème de l\'interface',
      'Select your QueueView refresh time.' => 'Choix du délai de rafraîchissement de la vue des files',
      'Select your screen after creating a new ticket.' => 'Sélectionnez l\'écran qui sera affiché après avoir créé un nouveau ticket.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Me prévenir si un client envoie un suivi (follow-up) et que je suis le propriétaire du ticket.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Me prévenir si un ticket est déplacé dans une de "Mes files".',
      'Send me a notification if a ticket is unlocked by the system.' => 'Me prévenir si un ticket est dévérouillé par le système',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Me prévenir si il y a un nouveau ticket dans une de "Mes files".',
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
      'closed' => '',
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
      'high' => 'important',
      'History' => 'Historique',
      'If it is not displayed correctly,' => 'S\'il n\'est pas affiché correctement',
      'lock' => 'vérrouiller',
      'Lock' => 'Vérrouiller',
      'low' => 'confort de fonctionnement',
      'Move' => 'Déplacer',
      'new' => 'nouveau',
      'normal' => 'normal',
      'note-external' => 'Note externe',
      'note-internal' => 'Note interne',
      'note-report' => 'Note rapport',
      'open' => 'ouvrir',
      'Owner' => 'Propriétaire',
      'Pending' => 'En attente',
      'pending auto close+' => 'Attente de la fermeture automatique(+)',
      'pending auto close-' => 'Attente de la fermeture automatique(-)',
      'pending reminder' => 'Attente du rappel',
      'phone' => 'téléphone',
      'plain' => 'tel quel',
      'Priority' => 'Priorité',
      'Queue' => 'File',
      'removed' => 'supprimé',
      'Sender' => 'émetteur',
      'sms' => 'sms',
      'State' => 'État',
      'Subject' => 'Sujet',
      'This is a' => 'Ceci est un',
      'This is a HTML email. Click here to show it.' => 'Ceci est un message au format HTML ; cliquer ici pour l\'afficher.',
      'This message was written in a character set other than your own.' => 'Ce message a été écrit dans un jeu de caractères différent du vôtre.',
      'Ticket' => 'Ticket',
      'Ticket "%s" created!' => 'Le ticket %s a été créé !',
      'To' => 'À',
      'to open it in a new window.' => 'L\'ouvrir dans une nouvelle fenêtre',
      'Unlock' => 'Déverrouiller',
      'unlock' => 'déverrouiller',
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
      'Auto Response From' => 'Réponse automatique de ',
      'Auto Response Management' => 'Gestion des réponses automatiques',
      'Note' => 'Note',
      'Response' => 'Réponse',
      'to get the first 20 character of the subject' => 'pour avoir les 20 premiers caractères du sujet ',
      'to get the first 5 lines of the email' => 'pour avoir les 5 premières ligne du mail',
      'to get the from line of the email' => 'pour avoir les lignes \'De\' du courriel',
      'to get the realname of the sender (if given)' => 'pour avoir le nom réel de l\'utilisateur (s\il est donné)',
      'to get the ticket id of the ticket' => 'pour avoir l\'identifiant du ticket',
      'to get the ticket number of the ticket' => 'pour avoir le numéro du ticket',
      'Useable options' => 'Options accessibles',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Gestion des clients utilisateurs',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => 'Les clients utilisateurs seront invités à se connecter par la page client.',
      'Result' => 'Résultat',
      'Search' => 'Chercher',
      'Search for' => 'Chercher à',
      'Select Source (for add)' => 'Sélectionnez une source (pour ajout)',
      'Source' => 'Source',
      'The message being composed has been closed.  Exiting.' => 'Le message en cours de rédaction a été clôturé. Sortie.',
      'This values are read only.' => 'Ces valeurs sont en lecture seule.',
      'This values are required.' => 'Ces valeurs sont obligatoires.',
      'This window must be called from compose window' => 'Cette fenêtre doit être appelée de la fenêtre depuis la fenêtre de rédaction',

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

    # Template: AdminEmail
      'Admin-Email' => 'Email de l\'administrateur',
      'Body' => 'Corps',
      'OTRS-Admin Info!' => 'Information de l\'administrateur OTRS !',
      'Recipents' => 'Récipients',
      'send' => 'envoyer',

    # Template: AdminEmailSent
      'Message sent to' => 'Message envoyé à',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => '(ex: 10*5155 or 105658*)',
      '(e. g. 234321)' => '(ex: 234321)',
      '(e. g. U5150)' => '(ex: U5150)',
      '-' => '-',
      'Add Note' => 'Ajouter une note',
      'Agent' => 'Technicien',
      'and' => 'et le',
      'CMD' => '',
      'Customer User Login' => 'Nom de connexion du client',
      'CustomerID' => 'Numéro de client',
      'CustomerUser' => '',
      'Days' => 'Jours',
      'Delete' => 'Effacer',
      'Delete tickets' => 'Effacer les tickets',
      'Edit' => 'Éditer',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Recherche sur le texte d\'un article (ex: "Mar*in" or "Baue*")',
      'GenericAgent' => '',
      'Hours' => 'Heures',
      'Job-List' => '',
      'Jobs' => '',
      'Last run' => '',
      'Minutes' => 'Minutes',
      'Modules' => '',
      'New Agent' => 'Nouvel Agent',
      'New Customer' => 'Nouveau Client',
      'New Owner' => 'Nouveau Propriétaire',
      'New Priority' => 'Nouvelle Priorité',
      'New Queue' => 'Nouvelle File',
      'New State' => 'Nouvel État',
      'New Ticket Lock' => 'Nouveau Verrou',
      'No time settings.' => 'Pas de paramètre de temps',
      'Param 1' => 'Paramètre 1',
      'Param 2' => 'Paramètre 2',
      'Param 3' => 'Paramètre 3',
      'Param 4' => 'Paramètre 4',
      'Param 5' => 'Paramètre 5',
      'Param 6' => 'Paramètre 6',
      'Save' => 'Sauver',
      'Save Job as?' => '',
      'Schedule' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Cette commande sera exécuté. ARG[0] sera le numéro du ticket et ARG[1] son identifiant.',
      'Ticket created' => 'Ticket créé',
      'Ticket created between' => 'Ticket créé entre le',
      'Ticket Lock' => 'Ticket vérouillé',
      'TicketFreeText' => 'Texte Libre du Ticket',
      'Times' => 'Fois',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Attention, ces tickets seront éffacés de la base de donnée ! Ils seront définitivement perdu !',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Créer de nouveaux groupes permettra de gérer les droits d\'accès pour les différents groupes du technicien (exemple: achats, comptabilité, support, ventes...).',
      'Group Management' => 'Administration des groupes',
      'It\'s useful for ASP solutions.' => 'C\'est utile pour les fournisseurs d\'applications.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.',

    # Template: AdminLog
      'System Log' => 'Journaux du Système',
      'Time' => 'Date et heure',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Courriel de l\'administrateur.',
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
      'PGP Keys' => 'Clés PGP',
      'PostMaster Filter' => 'Filtre PostMaster',
      'PostMaster POP3 Account' => 'Compte POP3 PostMaster',
      'Responses' => 'Réponses',
      'Responses <-> Queue' => 'Réponses <-> Files',
      'Role' => '',
      'Role <-> Group' => '',
      'Role <-> User' => '',
      'Roles' => '',
      'Select Box' => 'Requête SQL libre.',
      'Session Management' => 'Gestion des sessions',
      'SMIME Certificates' => 'Certificats SMIME',
      'Status' => 'État',
      'System' => 'Système',
      'User <-> Groups' => 'Utilisateur <-> Groupes',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Options de configuration (ex: &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Gestion des notifications',
      'Notifications are sent to an agent or a customer.' => 'Des notifications sont envoyées à un technicien ou à un client.',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Options concernant les données du client actuel (ex: &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Options concernant l\'utilisateur actuel ayant effectué cet action (ex: &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Options du propriétaire d\'un ticket (ex: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => 'Expiration',
      'File' => 'Fichier',
      'Fingerprint' => 'Empreinte',
      'FIXME: WHAT IS PGP?' => 'FIXEZ MOI: Qu\'est ce que PGP',
      'Identifier' => 'Identifier',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Dans ce cas vous pouvez directement éditer le trousseau de clé dans Kernel/Config.pm',
      'Key' => 'Clé',
      'PGP Key Management' => 'Gestion de Clé PGP',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Tous les courriels entrants avec un compte seront répartis dans la file sélectionnée !',
      'Dispatching' => 'Répartition',
      'Host' => 'Hôte',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Si votre compte est vérifié, les ent&ecirc;tes x-otrs (pour les priorités,...) seront utilisés !',
      'POP3 Account Management' => 'Gestion du compte POP3',
      'Trusted' => 'Vérifié',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'dispatcher ou filtrer les courriels entrant basé sur les en-têtes (X-*)! L\'utilisationd\'expression régulière est aussi possible.',
      'Filtername' => 'Nom du filtre',
      'Header' => 'En-tête',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',
      'Match' => 'Correspond',
      'PostMaster Filter Management' => 'Gestion des filtres PostMaster',
      'Set' => 'Assigner',
      'Value' => 'Valeur',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestion des files <-> réponses automatiques',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = pas de remonté du ticket',
      '0 = no unlock' => '0 = pas de vérouillage',
      'Customer Move Notify' => 'Notification lors d\'un changement de file',
      'Customer Owner Notify' => 'Notification lors d\'un changement de propriétaire',
      'Customer State Notify' => 'Notification lors d\'un changement d\'état',
      'Escalation time' => 'Délai de remonté du ticket',
      'Follow up Option' => 'Option des suivis',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si un ticket est cloturé et que le client envoie une note, le ticket sera verrouillé pour l\'ancien propriétaire',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Si un ticket n\'est pas répondu dans le temps imparti, ce ticket sera seulement affiché',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un technicien verrouille un ticket et qu\'il/elle n\'envoie pas une réponse dans le temps imparti, le ticket sera déverrouillé automatiquement. Le ticket sera alors visible de tous les autres techniciens',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envoit un courriel au client ilorsque le ticket change de file.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envoit un courriel au client lorsque le ticket change de propriétaire.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envoit un courriel au client lorsque le ticket change d\'état.',
      'Queue Management' => 'Gestion des files',
      'Sub-Queue of' => 'Sous-file',
      'Systemaddress' => 'Adresse du Système',
      'The salutation for email answers.' => 'La formule de politesse pour les réponses par mail',
      'The signature for email answers.' => 'La signature pour les réponses par courriel',
      'Ticket lock after a follow up' => 'Ticket verrouillé aprés un suivi',
      'Unlock timeout' => 'Délai du déverrouillage',
      'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expédition pour les réponses par courriel.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Réponses standard <-> Files',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Réponse',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Réponses Standard <-> Gestion des attachements standard',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Une réponse est un texte par défaut destiné à rédiger plus rapidement des réponses standard aux clients.',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'Don\'t forget to add a new response a queue!' => 'Ne pas oublier d\'ajouter une file à une nouvelle réponse !',
      'Next state' => 'État suivant',
      'Response Management' => 'Gestion des réponses',
      'The current ticket state is' => 'L\'état actuel du ticket est',
      'Your email address is new' => 'Votre adresse électronique est nouvelle',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',
      'Role Management' => '',

    # Template: AdminRoleGroupChangeForm
      'create' => 'créer',
      'move_into' => 'déplacer dans',
      'owner' => 'propriétaire',
      'Permissions to change the ticket owner in this group/queue.' => 'Permission de changer le propriétaire d\'un ticket dans cette file/groupe.',
      'Permissions to change the ticket priority in this group/queue.' => 'Permission de changer la priorité d\'un ticket dans cette file/groupe.',
      'Permissions to create tickets in this group/queue.' => 'Permission de créer un ticket dans cette file/groupe.',
      'Permissions to move tickets into this group/queue.' => 'Permission de déplacer un ticket dans cette file/groupe.',
      'priority' => 'priorité',
      'Role <-> Group Management' => '',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => '',

    # Template: AdminRoleUserChangeForm
      'Active' => '',
      'Role <-> User Management' => '',
      'Select the role:user relations.' => '',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => '',

    # Template: AdminSMIMEForm
      'Add Certificate' => '',
      'Add Private Key' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',
      'Secret' => '',
      'SMIME Certificate Management' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'nom réel du client',
      'for agent firstname' => 'pour le prénom du technicien',
      'for agent lastname' => 'pour le nom du technicien',
      'for agent login' => 'pour le nom de connexion (login) du technicien',
      'for agent user id' => 'pour l\'identifiant du technicien',
      'Salutation Management' => 'Préfixes des messages',

    # Template: AdminSelectBoxForm
      'Limit' => 'Limite',
      'SQL' => 'SQL',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'Choisissez le résultat',

    # Template: AdminSession
      'kill all sessions' => 'Terminer toutes les sessions',
      'kill session' => 'Terminer une session',
      'Overview' => 'Aperçu',
      'Session' => '',
      'Sessions' => 'Session',
      'Uniq' => 'Unique',

    # Template: AdminSignatureForm
      'Signature Management' => 'Gestion des signatures',

    # Template: AdminStateForm
      'See also' => 'Voir aussi',
      'State Type' => 'Type d\'état',
      'System State Management' => 'Gestion des états du système',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Prennez garde de bien mettre à jour les états par défaut dans votre Kernel/Config.pm !',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tous les courriels avec cette adresse en destinataire (À:) seront répartis dans la file sélectionnée !',
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
      'User <-> Group Management' => 'Gestion utilisateurs <-> groupes',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => 'Carnet d\'adresses',
      'Discard all changes and return to the compose screen' => 'Annuler tous les changements et retourner à l\'écran de saisie',
      'Return to the compose screen' => 'Retourner à l\'écran de saisie',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Un message doit avoir un destinataire (À:)!',
      'Bounce ticket' => 'Renvoyer le ticket',
      'Bounce to' => 'Renvoyer à',
      'Inform sender' => 'Informer l\'emetteur',
      'Next ticket state' => 'Prochain état du ticket',
      'Send mail!' => 'Envoyer le courriel !',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Il faut une adresse courriel (ex&nbsp;: client@exemple.fr)&nbsp;!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Votre message concernant le ticket numéro "<OTRS_TICKET> est réémis à "<OTRS_BOUNCE_TO>". Contactez cette adresse pour de plus amples renseignements',

    # Template: AgentBulk
      '$Text{"Note!' => '',
      'A message should have a subject!' => 'Un message doit avoir un sujet !',
      'Note type' => 'Type de note',
      'Note!' => 'Note !',
      'Options' => 'Options',
      'Spell Check' => 'Vérification orthographique',
      'Ticket Bulk Action' => '',

    # Template: AgentClose
      ' (work units)' => ' Unité de travail',
      'A message should have a body!' => 'Un message doit avoir un corp !',
      'Close ticket' => 'Ticket clos',
      'Close type' => 'Type de clôture',
      'Close!' => 'Clôture!',
      'Note Text' => 'Note',
      'Time units' => 'Unité de temps',
      'You need to account time!' => 'Vous devez avoir un compte de temps&nbsp;!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'L\'orthographe d\'un message doit être vérifié&nbsp;!',
      'Attach' => 'Attaché',
      'Compose answer for ticket' => 'Rédiger une réponse pour le ticket',
      'for pending* states' => 'pour tous les états d\'attente',
      'Is the ticket answered' => 'Est-ce qu\'il y a eu une réponse concernant le ticket',
      'Pending Date' => 'En attendant la date',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'Changer le client du ticket',
      'Search Customer' => 'Recherche de client',
      'Set customer user and customer id of a ticket' => 'Assigner un utilisateur client et un identifiant client pour le ticket.',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Tout les tickets du client',
      'Customer history' => 'Historique du client',

    # Template: AgentCustomerMessage
      'Follow up' => 'Note',

    # Template: AgentCustomerView
      'Customer Data' => 'Données client',

    # Template: AgentEmailNew
      'All Agents' => 'Tous les techniciens',
      'Clear To' => 'Effacer la zone de saisie "De:"',
      'Compose Email' => 'Écrire un courriel',
      'new ticket' => 'nouveau ticket',

    # Template: AgentForward
      'Article type' => 'Type d\'article',
      'Date' => 'Date',
      'End forwarded message' => 'Fin du message retransmi',
      'Forward article of ticket' => 'Transmettre l\'article du ticket',
      'Forwarded message from' => 'Message renvoyé par',
      'Reply-To' => 'Répondre à',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Changer le texte libre du ticket',

    # Template: AgentHistoryForm
      'History of' => 'Historique de',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => 'Information',

    # Template: AgentLookup
      'Lookup' => 'Consulter',

    # Template: AgentMailboxNavBar
      'All messages' => 'Tous les messages',
      'down' => 'vers le bas',
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
      'up' => 'vers le haut',

    # Template: AgentMailboxTicket
      '"}' => '"}',
      '"}","14' => '"}","14',
      'Add a note to this ticket!' => 'Ajouter une note au ticket!',
      'Change the ticket customer!' => 'Changer le client du ticket!',
      'Change the ticket owner!' => 'Changer le propriétaire du ticket!',
      'Change the ticket priority!' => 'Changer la priorité du ticket!',
      'Close this ticket!' => 'Fermer ce ticket!',
      'Shows the detail view of this ticket!' => 'Voir la vue détaillé de ce ticket!',
      'Unlock this ticket!' => 'Déverrouiller ce ticket!',

    # Template: AgentMove
      'Move Ticket' => 'Changer la file du ticket',
      'Previous Owner' => 'Propriétaire Précédent',
      'Queue ID' => 'Identifiant de la File',

    # Template: AgentNavigationBar
      'Agent Preferences' => '',
      'Bulk Action' => '',
      'Bulk Actions on Tickets' => '',
      'Create new Email Ticket' => '',
      'Create new Phone Ticket' => '',
      'Email-Ticket' => '',
      'Locked tickets' => 'Tickets verrouillés',
      'new message' => 'Nouveau message',
      'Overview of all open Tickets' => '',
      'Phone-Ticket' => '',
      'Preferences' => 'Préférences',
      'Search Tickets' => '',
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

    # Template: AgentNote
      'Add note to ticket' => 'Ajouter une note au ticket',

    # Template: AgentOwner
      'Change owner of ticket' => 'Changer le propriétaire du ticket',
      'Message for new Owner' => 'Message pour le nouveau propriétaire',

    # Template: AgentPending
      'Pending date' => 'Délais d\'attente',
      'Pending type' => 'Type d\'attente',
      'Set Pending' => 'Définir l\'attente',

    # Template: AgentPhone
      'Phone call' => 'Appel téléphonique',

    # Template: AgentPhoneNew
      'Clear From' => 'Vider le formulaire',

    # Template: AgentPlain
      'ArticleID' => 'Identifiant de l\'Article',
      'Download' => '',
      'Plain' => 'Tel quel',
      'TicketID' => 'Identifiant du Ticket',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => '',
      'You also get notified about this queues via email if enabled.' => '',
      'Your queue selection of your favorite queues.' => '',

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

    # Template: AgentTicketLink
      'Delete Link' => 'Effacer le lien',
      'Link' => 'Lien',
      'Link to' => 'Lien vers',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket verrouillé !',
      'Ticket unlock!' => 'Rendre le ticket !',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Temp passé',
      'Escalation in' => 'Remontée dans',

    # Template: AgentUtilSearch
      'Profile' => 'Profil',
      'Result Form' => 'Format du résultat',
      'Save Search-Profile as Template?' => 'Sauver le profil de recherche ?',
      'Search-Template' => 'Profil de recherche',
      'Select' => 'Sélectionner',
      'Ticket Search' => 'Recherche de ticket',
      'Yes, save it with name' => 'Oui, le sauver avec le nom',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Recherche dans l\'historique client',
      'Customer history search (e. g. "ID342425").' => 'Recherche dans l\'historique client (ex: "ID342425")',
      'No * possible!' => 'Pas de * possible !',

    # Template: AgentUtilSearchResult
      'Change search options' => 'Changer les options de recherche',
      'Results' => 'Résultat',
      'Search Result' => 'Résultat de la recherche',
      'Total hits' => 'Total des hits',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Tous les tickets fermés',
      'All open tickets' => 'Tous les tickets ouverts',
      'closed tickets' => 'tickets fermés',
      'open tickets' => 'tickets ouverts',
      'or' => 'ou',
      'Provides an overview of all' => 'Fourni un aperçu de tous',
      'So you see what is going on in your system.' => 'Donc vous voyez ce qui se passe sur votre syst&egrave;me',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Fermer le suivi',
      'Your own Ticket' => 'Votre propre ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Rédiger une réponse',
      'Contact customer' => 'Contacter le client',
      'phone call' => 'Appel téléphonique',

    # Template: AgentZoomArticle
      'Split' => 'Scinder',

    # Template: AgentZoomBody
      'Change queue' => 'Changer de file',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => 'Changer les champs libres du ticket!',
      'Free Fields' => 'Champs libre',
      'Link this ticket to an other one!' => 'Lier ce ticket à un autre!',
      'Lock it to work on it!' => 'Vérouiller ce ticket pour travailler dessus!',
      'Print' => 'Imprimer',
      'Print this ticket!' => 'Imprimer ce ticket!',
      'Set this ticket to pending!' => 'Mettre ce ticket en attente!',
      'Shows the ticket history!' => 'Voir l\'historique du ticket!',

    # Template: AgentZoomStatus
      '"}","18' => '"}","18',
      'Locked' => 'Vérrouillé',
      'SLA Age' => '',

    # Template: Copyright
      'printed by' => 'Imprimé par :',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Créer un compte',
      'Login' => 'S\'authentifier',

    # Template: CustomerError
      'Traceback' => 'Trace du retour d\'erreur',

    # Template: CustomerFAQArticleHistory
      'FAQ History' => 'Historique de la FAQ',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Catégorie',
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
      'Powered by' => 'Fonction assurée par',

    # Template: CustomerLostPassword
      'Lost your password?' => 'Mot de passe perdu ?',
      'Request new password' => 'Demande de nouveau mot de passe',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => '',
      'Create new Ticket' => 'Création d\'un nouveau Ticket',
      'FAQ' => 'FAQ',
      'MyTickets' => 'Mes tickets',
      'New Ticket' => 'Nouveau Ticket',
      'Welcome %s' => 'Bienvenue %s',

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
      'Click here to report a bug!' => 'Cliquer ici pour signaler une anomalie !',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Effacer la FAQ',
      'You really want to delete this article?' => 'Voulez vous vraiment effacer cet article ?',

    # Template: FAQArticleForm
      'A article should have a title!' => '',
      'Comment (internal)' => 'Commentaire interne',
      'Filename' => 'Nom de fichier',
      'Title' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => 'Catégorie dans la FAQ',
      'Name is required!' => 'Un nom est requis!',

    # Template: FAQLanguageForm
      'FAQ Language' => 'Langue dans la FAQ',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => 'Haut de page',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => 'Créer la base de données',
      'Drop Database' => 'Effacer la base de données',
      'Finished' => 'Fini',
      'System Settings' => 'Paramètres Système',
      'Web-Installer' => 'Installeur Web',

    # Template: InstallerFinish
      'Admin-User' => 'Administrateur',
      'After doing so your OTRS is up and running.' => 'Après avoir fait ceci votre OTRS est en service',
      'Have a lot of fun!' => 'Amusez vous bien !',
      'Restart your webserver' => 'Redémarrer votre serveur web',
      'Start page' => 'Page de démarrage',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Pour pouvoir utiliser OTRS, vous devez entrer les commandes suivantes dans votre terminal en tant que root.',
      'Your OTRS Team' => 'Votre Équipe OTRS',

    # Template: InstallerLicense
      'accept license' => 'Accepter la licence',
      'don\'t accept license' => 'Ne pas accepter la licence',
      'License' => 'Licence',

    # Template: InstallerStart
      'Create new database' => 'Créer une nouvelle base de données',
      'DB Admin Password' => 'Mot de passe administrateur base de données',
      'DB Admin User' => 'nom de connexion de l\'administrateur base de donnée',
      'DB Host' => 'Nom d\'hôte de la base',
      'DB Type' => 'Type de SGBD',
      'default \'hot\'' => 'hôte par défaut',
      'Delete old database' => 'Effacer l\'ancienne base de données',
      'next step' => 'étape suivante',
      'OTRS DB connect host' => 'Hôte de la base OTRS',
      'OTRS DB Name' => 'Nom de la base OTRS',
      'OTRS DB Password' => 'Mot de passe de la base OTRS',
      'OTRS DB User' => 'Utilisateur de la base OTRS',
      'your MySQL DB should have a root password! Default is empty!' => 'Votre base MySQL doit avoir un mot de passe root ! Par défaut cela est vide !',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Verifie les enregistrements MX des adresses électroniques utilisées lors de la rédaction d\'une réponse. N\'utilisez pas la "Vérification des enregistrements MX" si votre serveur OTRS est derrière une ligne modem $!',
      '(Email of the system admin)' => '(Adresse de l\'administrateur système)',
      '(Full qualified domain name of your system)' => '(Nom de domaine complet de votre machine)',
      '(Logfile just needed for File-LogModule!)' => '(fichier de log nécessaire pour le Module File-Log !)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(L\'identité du système. Chaque numéro de ticket et chaque id de session http commence avec ce nombre)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identifiiant des tickets. Certaines personnes veulent le configurer avec par ex: \'Ticket#\', \'Appel#\' ou \'MonTicket#\')',
      '(Used default language)' => '(Langage par défaut utilisé)',
      '(Used log backend)' => '(Backend de log utilisé)',
      '(Used ticket number format)' => '(Format numérique utilisé pour les tickets)',
      'CheckMXRecord' => 'Vérifier les enregistrements MX',
      'Default Charset' => 'Charset par défaut',
      'Default Language' => 'Langage par défaut ',
      'Logfile' => 'fichier de log',
      'LogModule' => 'Module de log',
      'Organization' => 'Société',
      'System FQDN' => 'Nom de Domaine complet du système',
      'SystemID' => 'ID Système',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Générateur de numéro pour les tickets',
      'Use utf-8 it your database supports it!' => 'Utilisez UTF-8 si votre base de donnée le supporte !',
      'Webfrontend' => 'Frontal web',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Pas d\'autorisation',

    # Template: Notify

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: QueueView
      'All tickets' => 'tous les tickets',
      'Page' => 'Page',
      'Queues' => 'Files',
      'Tickets available' => 'Tickets disponibles',
      'Tickets shown' => 'Tickets affichés',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'Page de test d\'OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Remontée du ticket !',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => 'Accueil',

    # Template: customer-css
      'Contact' => 'Contact',
      'Online-Support' => 'Support en ligne',
      'Products' => 'Produits',
      'Support' => 'Support',

    # Misc
      'AgentFrontend' => 'Interface du technicien',
      'Article free text' => 'Texte dans l\'article',
      'Charset' => 'Jeu de caractère',
      'Charsets' => 'Jeux de caractères',
      'Create' => 'Créer',
      'Customer called' => 'Client appelé',
      'Customer user will be needed to to login via customer panels.' => 'Les clients utilisateurs seront invité à se connecter par la page client.',
      'FAQ State' => 'État de la FAQ',
      'Feature not activ!' => 'Fonctionalité non activée !',
      'Fulltext search' => 'Recherche intégrale de texte',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Recherche intégral de texte (ex: "Mar*in" ou "Constru*" ou "martin+bonjour")',
      'Graphs' => 'Graphiques',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Si votre compte est vérifié, les en-t&ecirc;tes x-otrs (pour les priorités,...) seront utilisés !',
      'Lock Ticket' => 'Verrouiller le Ticket',
      'Max Rows' => 'Nombre de lignes maximales',
      'My Tickets' => 'Mes tickets',
      'New state' => 'Nouvel état',
      'New ticket via call.' => 'Nouveau ticket par téléphone',
      'New user' => 'Nouvel utilisateur',
      'Pending!' => 'En attente !',
      'Phone call at %s' => 'Appel téléphonique à %s',
      'Please go away!' => 'Passez votre chemin !',
      'PostMasterFilter Management' => 'Gestion des filtres PostMaster',
      'Search in' => 'Recherche dans',
      'Select source:' => 'Sélectionnez la source',
      'Select your custom queues' => 'Choix des files personnelles',
      'Select your screen after creating a new ticket via PhoneView.' => 'Choisissez l\'écran qui sera affiché après avoir créé un ticket via la vue téléphone',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Me prévenir si un ticket est déplacé dans une de mes files personnelles',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Me prévenir si un nouveau ticket apparaît dans mes files personnelles.',
      'SessionID' => 'Identifiant de session',
      'Set customer id of a ticket' => 'Définir le numéro de client d\'un ticket',
      'Short Description' => 'Description Courte',
      'Show all' => 'Tout montrer',
      'Status defs' => 'Définitions des états',
      'System Charset Management' => 'Gestion du jeu de caractères du système',
      'System Language Management' => 'Gestion des langues du système',
      'Ticket free text' => 'Texte du ticket',
      'Ticket limit:' => 'Limitation du Ticket',
      'Ticket-Overview' => 'Aperçu des Tickets',
      'Time till escalation' => 'Durée avant la remontée du ticket',
      'Users' => 'Utilisateurs',
      'Utilities' => 'Utilitaires',
      'With State' => 'Avec l\'état',
      'You have to be in the admin group!' => 'Il est nécessaire d\'être dans le groupe d\'administration !',
      'You have to be in the stats group!' => 'Il est nécessaire d\'être dans le groupe des statistiques !',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Vous devez avoir une adresse électronique dans le De:! (ex: client@example.com)',
      'auto responses set' => 'Réponse automatique positionnée',
      'by' => 'par',
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
