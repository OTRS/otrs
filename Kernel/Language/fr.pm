# Kernel/Language/fr.pm - provides fr language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# --
# $Id: fr.pm,v 1.10 2003-01-14 17:31:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fr;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Thu Jan  9 22:09:48 2003 by 

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
      'Cancel' => 'Annuler',
      'Change' => 'Modifier',
      'change' => 'modifier',
      'change!' => 'modifier&nbsp;!',
      'click here' => 'Cliquer l&agrave;',
      'Comment' => 'Commentaire',
      'Customer' => 'Client',
      'Customer info' => 'Information client',
      'day' => 'jour',
      'days' => 'jours',
      'description' => 'description',
      'Description' => 'Description',
      'Dispatching by email From field.' => 'R&eacute;partition par le champs \'De\' de l\'email',
      'Dispatching by selected Queue.' => 'R&eacute;partition par la file s&eacute;lectionn&eacute;e',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Cela ne fonctionne pas avec l\'ID utilisateur 1 (Compte System)! Veuillez c&eacute;er un nouvel utilisateur!',
      'Done' => 'Fait',
      'end' => 'fin',
      'Error' => 'Erreur',
      'Example' => 'Exemple',
      'Examples' => 'Exemples',
      'Facility' => '',
      'Feature not activ!' => 'Fonction non activ&eacute;',
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
      'Lite' => '',
      'Login failed! Your username or password was entered incorrectly.' => '',
      'Logout successful. Thank you for using OTRS!' => 'D&eacute;connection r&eacute;ussie. Merci d\'avoir utilis&eacute; OTRS!',
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
      'none - answered' => 'aucun - r&eacute;pondu',
      'none!' => 'aucun&nbsp;!',
      'Off' => '&eacute;teint',
      'off' => '&eacute;teint',
      'on' => 'allum&eacute;',
      'On' => 'Allum&eacute;',
      'Password' => 'Mot de Passe',
      'Pending till' => '',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Il faut r&eacute;pondre &agrave; ce(s) ticket(s) pour revenir &agrave; la vue normale de la file.',
      'Please contact your admin' => 'Veuillez contacter votre admnistrateur',
      'please do not edit!' => 'Ne pas modifier&nbsp;!',
      'possible' => 'possible',
      'QueueView' => 'Vue file',
      'reject' => 'rejet&eacute;',
      'replace with' => 'remplacer par',
      'Reset' => 'Remise &agrave; z&eacute;ro',
      'Salutation' => 'Salutation',
      'Signature' => 'Signature',
      'Sorry' => 'D&eacute;sol&eacute;',
      'Stats' => 'Statistiques',
      'Subfunction' => 'sous-fonction',
      'submit' => 'soumettre',
      'submit!' => 'soumettre&nbsp;!',
      'Text' => 'Texte',
      'The recommended charset for your language is %s!' => 'Les jeux de charact&egrave;res pour votre langue est %s!',
      'Theme' => 'Th&egrave;me',
      'There is no account with that login name.' => 'Il n\'y a aucun compte avec ce login',
      'Timeover' => 'Temp &eacute;coul&eacute;',
      'top' => 'haut',
      'update' => 'Mise &agrave; jour',
      'update!' => 'actualiser&nbsp;!',
      'User' => 'Utilisateur',
      'Username' => 'Nom d\'utilisateur',
      'Valid' => 'Valide',
      'Warning' => 'Attention',
      'Welcome to OTRS' => 'Bienvenue &agrave; OTRS',
      'Word' => 'Mot',
      'wrote' => '&eacute;crit',
      'yes' => 'oui',
      'Yes' => 'Oui',
      'You got new message!' => 'Vous avez un nouveau message',
      'You have %s new message(s)!' => 'Vous avez %s nouveau(x) message(s)',
      'You have %s reminder ticket(s)!' => '',

    # Template: AAAMonth
      'Apr' => 'Avr',
      'Aug' => 'Aou',
      'Dec' => 'D&eacute;c',
      'Feb' => 'F&eacute;v',
      'Jan' => 'Jan',
      'Jul' => 'Juil',
      'Jun' => 'Juin',
      'Mar' => 'Mar',
      'May' => 'Mai',
      'Nov' => 'Nov',
      'Oct' => 'Oct',
      'Sep' => 'Sep',

    # Template: AAAPreferences
      'Custom Queue' => 'File d\'attente personnelle',
      'Follow up notification' => 'Notification de suivi',
      'Frontend' => 'Frontal',
      'Mail Management' => 'Gestion des Emails',
      'Move notification' => 'Notification de mouvement',
      'New ticket notification' => 'Notification de nouveau ticket',
      'Other Options' => 'Autres options',
      'Preferences updated successfully!' => 'Les pr&eacute;f&eacute;rences ont bien &eacute;t&eacute; mises &agrave; jours',
      'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
      'Select your frontend Charset.' => 'Choix du jeu de caract&egrave;res du frontal',
      'Select your frontend language.' => 'Choix de la langue du frontal',
      'Select your frontend QueueView.' => 'Choisissez votre frontal de vue des files',
      'Select your frontend Theme.' => 'Choix du th&egrave;me du frontal',
      'Select your QueueView refresh time.' => 'Choix du d&eacute;lai de rafraîchissement de la vue des files',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Me pr&eacute;venir si un client envoie un suivi (follow-up) et que je suis le propri&eacute;taire du ticket.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Me pr&eacute;venir si un ticket est d&eacute;plac&eacute; dans une file personnalis&eacute;',
      'Send me a notification if a ticket is unlocked by the system.' => 'Me pr&eacute;venir si un ticket est d&eacute;v&eacute;rouill&eacute; par le syst&egrave;me',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Me pr&eacute;venir si un nouveau ticket apparaît dans mes files personnelles.',
      'Ticket lock timeout notification' => 'Pr&eacute;venir du d&eacute;passement du d&eacute;lai d\'un verrou ',

    # Template: AAATicket
      '1 very low' => '1 tr&egrave;s bas',
      '2 low' => '2 bas',
      '3 normal' => '3 normal',
      '4 high' => '4 important',
      '5 very high' => '5 tr&egrave;s important',
      'Action' => 'Action',
      'Age' => 'Vieillir',
      'Article' => 'Article',
      'Attachment' => 'Pi&egrave;ce jointe',
      'Attachments' => 'Pi&egrave;ces jointes',
      'Bcc' => 'Copie Invisible',
      'Bounce' => 'Renvoyer',
      'Cc' => 'Copie ',
      'Close' => 'Fermer',
      'closed successful' => 'cl&ocirc;ture r&eacute;ussie',
      'closed unsuccessful' => 'cl&ocirc;ture manqu&eacute;e',
      'Compose' => 'Composer',
      'Created' => 'Cr&eacute;&eacute; ',
      'Createtime' => 'Cr&eacute;ation du ',
      'email' => 'courriel',
      'eMail' => 'courriel',
      'email-external' => 'message externe',
      'email-internal' => 'message interne',
      'Forward' => 'Transmettre',
      'From' => 'De ',
      'high' => 'Important',
      'History' => 'Historique',
      'If it is not displayed correctly,' => 'S\'il n\'est pas affich&eacute; correctement',
      'Lock' => 'Vérrouiller',
      'low' => 'confort de fonctionnement',
      'Move' => 'D&eacute;placer',
      'new' => 'nouveau',
      'normal' => 'bloque une fonction',
      'note-external' => 'Note externe',
      'note-internal' => 'Note interne',
      'note-report' => 'Note rapport',
      'open' => 'ouvrir',
      'Owner' => 'Propri&eacute;taire',
      'Pending' => 'En attente',
      'pending auto close+' => '',
      'pending auto close-' => '',
      'pending reminder' => '',
      'phone' => 't&eacute;l&eacute;phone',
      'plain' => 'tel quel',
      'Priority' => 'Priorit&eacute;',
      'Queue' => 'File',
      'removed' => 'supprim&eacute;',
      'Sender' => '&eacute;metteur',
      'sms' => 'sms',
      'State' => '&eacute;tat',
      'Subject' => 'Sujet',
      'This is a' => 'Ceci est un',
      'This is a HTML email. Click here to show it.' => 'Ceci est un message au format HTML&nbsp;; cliquer ici pour l\'afficher.',
      'This message was written in a character set other than your own.' => '',
      'Ticket' => 'Ticket',
      'To' => '&agrave; ',
      'to open it in a new window.' => 'Pour l\'ouvrir dans une nouvelle fenêtre',
      'Unlock' => 'Déverrouiller',
      'very high' => 'bloque un service entier',
      'very low' => 'confort intellectuel',
      'View' => 'Vue',
      'webrequest' => 'Requete par le web',
      'Zoom' => 'D&eacute;tail',

    # Template: AAAWeekDay
      'Fri' => 'Ven',
      'Mon' => 'Lun',
      'Sat' => 'Sam',
      'Sun' => 'Dim',
      'Thu' => 'Mar',
      'Tue' => 'Jeu',
      'Wed' => 'Mer',

    # Template: AdminAttachmentForm
      'Add attachment' => 'Ajouter une pi&egrave;ce',
      'Attachment Management' => 'Gestion des attachements',
      'Change attachment settings' => 'Changer les param&ecirc;etres d\'attachement',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Ajouter une r&eacute;ponse automatique',
      'Auto Response From' => 'R&eacute;ponse automatique de ',
      'Auto Response Management' => 'Gestion des r&eacute;ponses automatiques',
      'Change auto response settings' => 'Modifier les param&egrave;tres de r&eacute;ponses automatiques',
      'Charset' => 'Jeu de charact&egrave;re',
      'Note' => 'Note',
      'Response' => 'R&eacute;ponse',
      'to get the first 20 character of the subject' => 'pour avoir les 20 premiers charact&egrave;res du sujet ',
      'to get the first 5 lines of the email' => 'pour avoir les 5 premi&egrave;res ligne du mail',
      'to get the from line of the email' => 'pour avoir les lignes \'From\' du mail',
      'to get the realname of the sender (if given)' => 'pour avoir le nom r&eacute;el de l\'utilisateur (s\il est donn&eacute;)',
      'to get the ticket number of the ticket' => 'pour avoir le num&eacute;ro du ticket',
      'Type' => 'Type',
      'Useable options' => 'Options accessibles',

    # Template: AdminCharsetForm
      'Add charset' => 'Ajouter un jeu de caract&egrave;res syst&egrave;me',
      'Change system charset setting' => 'Modification des param&egrave;tres du jeu de caract&egrave;res syst&egrave;me',
      'System Charset Management' => 'Gestion du jeu de caract&egrave;res syst&egrave;me',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Ajouter un utilisateur client',
      'Change customer user settings' => 'Changer les pr&eacute;f&eacute;rences utilisateurs du client',
      'Customer User Management' => 'Gestion des clients utilisateurs',
      'Customer user will be needed to to login via customer panels.' => 'Les clients utilisateurs seront invit&eacute; &agrave; se connecter par la page client.',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email de l\'administrateur',
      'Body' => 'Corps',
      'OTRS-Admin Info!' => 'Information de l\'administrateur OTRS',
      'Recipents' => 'R&eacute;cipients',

    # Template: AdminEmailSent
      'Message sent to' => 'Message envoy&eacute; &agrave;',

    # Template: AdminGroupForm
      'Add group' => 'Ajouter un groupe',
      'Change group settings' => 'Changer les param&egrave;tres d\'un groupe',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'De nouveaux groupes permettront de g&eacute;rer les droits d\'acc&egrave;s pour les diff&eacute;rents groupes d\'un agent (exemple&nbsp;: achats, comptabilit&eacute;, support, ventes...).',
      'Group Management' => 'Administration des groupes',
      'It\'s useful for ASP solutions.' => 'C\'est utile pour les fournisseurs d\'applications.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Le groupe admin permet d\'acc&eacute;der &agrave; la zone d\'administration et le groupe stats &agrave; la zone de statistiques.',

    # Template: AdminLanguageForm
      'Add language' => 'Ajouter une langue',
      'Change system language setting' => 'Modification des parm&egrave;tres de langue du syst&egrave;me',
      'System Language Management' => 'Gestion des langues du syst&egrave;me',

    # Template: AdminLog
      'System Log' => 'Logs du Syst&egrave;me',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email de l\'administrateur.',
      'AgentFrontend' => 'Frontal d\'agent',
      'Auto Response <-> Queue' => 'R&eacute;ponse Automatique <-> Files',
      'Auto Responses' => 'R&eacute;ponses automatiques',
      'Charsets' => 'Jeu de Charact&egrave;re',
      'Customer User' => 'Client Utilisateur',
      'Email Addresses' => 'Adresses courriel',
      'Groups' => 'Groupes',
      'Logout' => 'D&eacute;connexion',
      'Misc' => 'Divers',
      'POP3 Account' => 'Compte POP3',
      'Responses' => 'R&eacute;ponses',
      'Responses <-> Queue' => 'R&eacute;ponses <-> Files',
      'Select Box' => 'Choisissez une boîte',
      'Session Management' => 'Gestion des sessions',
      'Status defs' => 'D&eacute;finitions des Status',
      'System' => 'Syst&egrave;me',
      'User <-> Groups' => 'Utilisateur <-> Groupes',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Ajouter un compte POP3',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Tout les mails entrants avec un compte seront r&eacute;partis dans la file s&eacute;lectionn&eacute;',
      'Change POP3 Account setting' => 'Changer les param&ecirc;tres du compte POP3',
      'Dispatching' => 'R&eacute;partition',
      'Host' => 'H&ocirc;',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Si votre compte est v&eacute;rifi&eacute;, les en-t&ecirc;tes x-otrs (pour les priorit&eacute;s,...) seront utilis&eacute;s',
      'Login' => 'Login',
      'POP3 Account Management' => 'Gestion du compte POP3',
      'Trusted' => 'V&eacute;rifi&eacute;',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Gestion des files <-> r&eacute;ponses automatiques',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = pas d\'escalade',
      '0 = no unlock' => '0 = pas de v&eacute;rouillage',
      'Add queue' => 'Ajouter une file',
      'Change queue settings' => 'Modifier les param&egrave;tres des files',
      'Escalation time' => 'D&eacute;lai d\'escalade',
      'Follow up Option' => 'Option des suivis',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
      'Key' => 'Clef',
      'Queue Management' => 'Gestion des files',
      'Systemaddress' => 'Adresse du Syst&egrave;me',
      'The salutation for email answers.' => 'La formule de politesse pour les r&eacute;ponses par mail',
      'The signature for email answers.' => 'La signature pour les r&eacute;ponses par email',
      'Ticket lock after a follow up' => 'Ticket bloqu&eacute; apr&eacute;s un suivi',
      'Unlock timeout' => 'D&eacute;verrouiller la temporisation',
      'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'exp&eacute;p&eacute;dition pour les r&eacute;ponses par mail',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Changer les param&ecirc;tres de %s',
      'Std. Responses <-> Queue Management' => 'Gestion des r&eacute;ponses standard <-> files',

    # Template: AdminQueueResponsesForm
      'Answer' => '',
      'Change answer <-> queue settings' => 'Modifier les param&egrave;tres de r&eacute;ponses <-> files',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'R&eacute;ponses Std <-> Gestion des attachements Std',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Para&agrave;m&ecirc;tre des attachements',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Une r&eacute;ponse est un texte par d&eacute;faut destin&eacute; &agrave; r&eacute;diger plus rapidement des r&eacute;ponses standard aux clients.',
      'Add response' => 'Ajouter une r&eacute;ponse',
      'Change response settings' => 'Modifier les param&egrave;tres des r&eacute;ponses',
      'Don\'t forget to add a new response a queue!' => 'Ne pas oublier d\'ajouter une file &agrave; une nouvelle r&eacute;ponse&nbsp;!',
      'Response Management' => 'Gestion des r&eacute;ponses',

    # Template: AdminSalutationForm
      'Add salutation' => 'Ajouter une salutation',
      'Change salutation settings' => 'Modification des param&egrave;tres de salutations',
      'customer realname' => 'nom r&eacute;el du client',
      'Salutation Management' => 'Gestion des salutations',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Nombre de lignes maximales',

    # Template: AdminSelectBoxResult
      'Limit' => 'Limite',
      'Select Box Result' => 'Choisissez le r&eacute;sultat',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'Terminer toutes les sessions',

    # Template: AdminSessionTable
      'kill session' => 'Terminer une session',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Add signature' => 'Ajouter une signature',
      'Change signature settings' => 'Modification des param&egrave;tres de signatures',
      'for agent firstname' => 'pour le pr&eacute;nom de l\'agent',
      'for agent lastname' => 'pour le nom de l\'agent',
      'Signature Management' => 'Gestion des signatures',

    # Template: AdminStateForm
      'Add state' => 'Ajouter un &eacute;tat',
      'Change system state setting' => 'Modification des param&egrave;tres d\'&eacute;tats du syst&egrave;me',
      'System State Management' => 'Gestion des &eacute;tats du syst&egrave;me',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Ajouter une adresse courriel du syst&egrave;me',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tous les courriels avec cette adresse en destinataire (&agrave;&nbsp;:) seront plac&eacute;s dans la file choisie..',
      'Change system address setting' => 'Modification des param&egrave;tres des adresses courriel du syst&egrave;me',
      'Email' => 'Courriel',
      'Realname' => 'V&eacute;ritable Nom',
      'System Email Addresses Management' => 'Gestion des adresses courriel du syst&egrave;me',

    # Template: AdminUserForm
      'Add user' => 'Ajouter un utilisateur',
      'Change user settings' => 'Modification des param&egrave;tres utilisateurs',
      'Don\'t forget to add a new user to groups!' => 'Ne pas oublier d\'ajouter un nouvel utilisateur aux groupes&nbsp;!',
      'Firstname' => 'Pr&eacute;nom',
      'Lastname' => 'Nom',
      'User Management' => 'Administration des utilisateurs',
      'User will be needed to handle tickets.' => 'Un utilisateur sera n&eacute;cessaire pour g&eacute;rer les tickets.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => 'Changer les param&ecirc;tres',
      'User <-> Group Management' => 'Gestion utilisateurs <-> groupes',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Modifier les param&egrave;tres utilisateurs <-> groupes',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Un message doit avoir un destinataire (&agrave;&nbsp;:)!',
      'Bounce ticket' => 'Renvoyer le ticket',
      'Bounce to' => 'Renvoyer &agrave;',
      'Inform sender' => 'Informer l\'emetteur',
      'Next ticket state' => 'Prochain &eacute;tat du ticket',
      'Send mail!' => 'Envoyer le courriel&nbsp;!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Il faut une adresse courriel (ecemple&nbsp;: client@exemple.fr)&nbsp;!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'Votre email avec le ticket num&eacute;ro "<OTRS_TICKET> est renvoyer &agrave; "<OTRS_BOUNCE_TO>". Contactez cette adresse pour de plus amples renseignements',

    # Template: AgentClose
      ' (work units)' => ' Unit&eacute; de travail',
      'Close ticket' => 'Ticket clos',
      'Close type' => 'Type de cloture',
      'Close!' => 'Cloture!',
      'Note Text' => 'Note',
      'Note type' => 'Type de note',
      'store' => 'stocker',
      'Time units' => 'Unit&eacute; de temps',

    # Template: AgentCompose
      'A message should have a subject!' => 'Un message doit avoir un sujet&nbsp;!',
      'Attach' => 'Attach&eacute;',
      'Compose answer for ticket' => 'Composer une r&eacute;ponse pour le ticket',
      'for pending* states' => '',
      'Is the ticket answered' => 'Est-ce que le ticket est r&eacute;pondu',
      'Options' => '',
      'Pending Date' => '',
      'Spell Check' => 'V&eacute;rification orthographique',

    # Template: AgentCustomer
      'Back' => 'retour',
      'Change customer of ticket' => 'Changer le num&eacute;ro de client du ticket',
      'Set customer id of a ticket' => 'D&eacute;finir le num&eacute;ro de client d\'un ticket',

    # Template: AgentCustomerHistory
      'Customer history' => 'Historique du client',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
      'Customer Data' => 'Donn&eacute;es client',

    # Template: AgentForward
      'Article type' => 'Type d\'article',
      'Date' => '',
      'End forwarded message' => 'Fin du message retransmit',
      'Forward article of ticket' => 'Transmettre l\'article du ticket',
      'Forwarded message from' => 'Message renvoy&eacute; par',
      'Reply-To' => 'R&eacute;pondre &agrave;',

    # Template: AgentHistoryForm
      'History of' => 'Historique de',

    # Template: AgentMailboxNavBar
      'All messages' => 'Tout les messages',
      'CustomerID' => 'Num&eacute;ro de client#',
      'down' => 'bas',
      'Mailbox' => 'Bo&icirc;te aux lettres',
      'New' => 'Nouveau',
      'New messages' => 'Nouveaux messages',
      'Open' => 'Ouvrir',
      'Open messages' => 'Ouvrir des messages',
      'Order' => 'Ordre',
      'Pending messages' => 'Message en attente',
      'Reminder' => '',
      'Reminder messages' => '',
      'Sort by' => 'Trier par',
      'Tickets' => '',
      'up' => 'haut',

    # Template: AgentMailboxTicket
      'Add Note' => 'Ajouter une note',

    # Template: AgentNavigationBar
      'FAQ' => '',
      'Locked tickets' => 'Tickets verrouill&eacute;s',
      'new message' => 'Nouveau message',
      'PhoneView' => 'Vue t&eacute;l&eacute;phone',
      'Preferences' => 'Pr&eacute;f&eacute;rences',
      'Utilities' => 'Utilitaires',

    # Template: AgentNote
      'Add note to ticket' => 'Ajouter une note au ticket',
      'Note!' => '',

    # Template: AgentOwner
      'Change owner of ticket' => 'Changer le propri&eacute;taire du ticket',
      'Message for new Owner' => 'Message pour le nouveau Propri&eacute;taire',
      'New user' => 'Nouvel utilisateur',

    # Template: AgentPending
      'Pending date' => '',
      'Pending type' => '',
      'Set Pending' => '',

    # Template: AgentPhone
      'Customer called' => 'Client appel&eacute;',
      'Phone call' => 'Appel t&eacute;l&eacute;phonique',
      'Phone call at %s' => 'Appel t&eacute;l&eacute;phonique &agrave; %s',

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
      'Change priority of ticket' => 'Modification de la priorit&eacute; du ticket',
      'New state' => 'Nouvel &eacute;tat',

    # Template: AgentSpelling
      'Apply these changes' => 'Appliquer ces changements',
      'Discard all changes and return to the compose screen' => 'Annuler tout les changements et retourner &agrave; l\'&eacute;cran de saisie',
      'Return to the compose screen' => 'Retourner &agrave; l\'&eacute;cran de saisie',
      'Spell Checker' => 'V&eacute;rificateur orthographique',
      'spelling error(s)' => 'erreurs d\'orthographe',
      'The message being composed has been closed.  Exiting.' => 'Le message en cours de composition a &eacute;t&eacute; cl&ocirc;tur&eacute;. Sortie.',
      'This window must be called from compose window' => 'Cette fene&ecirc;tre doit &ecirc;tre appel&eacute; de la fen&ecirc;tre de composition',

    # Template: AgentStatusView
      'D' => '',
      'sort downward' => 'Tri d&eacute;croissant',
      'sort upward' => 'Tri croissant',
      'Ticket limit:' => 'limitation des Ticket',
      'Ticket Status' => 'Status du Ticket',
      'U' => '',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket verrouill&eacute;&nbsp;!',
      'unlock' => 'déverrouiller',

    # Template: AgentTicketPrint
      'by' => 'par',

    # Template: AgentTicketPrintHeader
      'Accounted time' => '',
      'Escalation in' => '',
      'printed by' => 'Imprim&eacute; par :',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'recherche dans l\'historique client',
      'Customer history search (e. g. "ID342425").' => 'recherche dans l\'historique client (ex: "ID342425")',
      'No * possible!' => 'Pas de * possible',

    # Template: AgentUtilSearchByText
      'Article free text' => 'Texte dans l\'article',
      'Fulltext search' => 'Recherche in&eacute;grale de texte',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Recherche int&eacute;gral de texte (ex: "Mar*in" ou "Constru*" ou "martin+bonjour")',
      'Search in' => 'Recherche dans',
      'Ticket free text' => 'Texte du ticket',
      'With State' => 'Avec l\'&eacute;tat',

    # Template: AgentUtilSearchByTicketNumber
      'search' => 'Recherche',
      'search (e. g. 10*5155 or 105658*)' => 'Recherche (ex: 10*5155 ou 105658*)',

    # Template: AgentUtilSearchNavBar
      'Results' => 'R&eacute;sultat',
      'Site' => '',
      'Total hits' => 'Total des hits',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All open tickets' => 'Tous les tickets ouverts',
      'open tickets' => 'tickets ouverts',
      'Provides an overview of all' => 'Propose un aperçu de tous',
      'So you see what is going on in your system.' => 'Donc vous voyez ce qui se passe sur votre syst&egrace;me',

    # Template: CustomerCreateAccount
      'Create' => 'Cr&eacute;er',
      'Create Account' => 'Cr&eacute;er un compte',

    # Template: CustomerError
      'Backend' => '',
      'BackendMessage' => 'Message du Backend',
      'Click here to report a bug!' => 'Cliquer ici pour signaler une anomalie',
      'Handle' => '',

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
      'Follow up' => 'Note',

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Cr&eacute;tion d\'un nouveau Ticket',
      'My Tickets' => 'Mes tickets',
      'New Ticket' => 'Nouveau Ticket',
      'Ticket-Overview' => 'Aperçu des Tickets',
      'Welcome %s' => 'Bienvenue %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'of' => 'de',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
      'next step' => '&eacute;tape suivante',

    # Template: InstallerSystem
      '(Email of the system admin)' => 'Email de l\'administrateur syst&egrave;',
      '(Full qualified domain name of your system)' => 'Nom de domaine complet de votre machine',
      '(Logfile just needed for File-LogModule!)' => 'fichier de log n&eacute;cessaire pour le Module File-Log',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(L\'identité du syst&egrave;me. Chaque num&eacute;ro de ticket et chaque id de session http d&eacute; avec ce nombre)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identificateur des tickets. Certaines personnes veulent le configurer avec par ex: \'Ticket#\', \'Appel#\' ou \'MonTicket#\')',
      '(Used default language)' => 'Langage par d&eacute;faut utilis&eacute;',
      '(Used log backend)' => 'Backend de log utilis&eacute;',
      '(Used ticket number format)' => 'format num&eacute;rique utilis&eacute; pour les tickets',
      'Default Charset' => 'Charset par d&eacute;faut',
      'Default Language' => 'Langage par d&eacute;faut ',
      'Logfile' => 'fichier de log',
      'LogModule' => 'Module de log',
      'Organization' => 'Soci&eacute;t&eacute;',
      'System FQDN' => '',
      'SystemID' => 'ID Syst&egrave;me',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'G&eacute;n&eacute;rateur de num&eacute;ro pour les tickets',
      'Webfrontend' => '',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Pas d\'autorisation',

    # Template: Notify
      'Info' => '',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'Print' => 'Imprimer',

    # Template: QueueView
      'All tickets' => 'tous les tickets',
      'Queues' => 'Files',
      'Show all' => 'Tout montrer',
      'Ticket available' => 'Tickets disponibles',
      'tickets' => 'Tickets',
      'Tickets shown' => 'Tickets affich&eacute;s',

    # Template: SystemStats
      'Graphs' => 'Graphiques',

    # Template: Test
      'OTRS Test Page' => 'Page de test d\'OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Escalade du ticket',

    # Template: TicketView
      'Change queue' => 'Changer de file',
      'Compose Answer' => 'Composer une r&eacute;ponse',
      'Contact customer' => 'Contacter le client',
      'phone call' => 'Appel t&eacute;l&eacute;phonique',

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(cliquer ici pour ajouter un groupe)',
      '(Click here to add a queue)' => '(cliquer ici pour ajouter une file)',
      '(Click here to add a response)' => '(cliquer ici pour ajouter une r&eacute;ponse)',
      '(Click here to add a salutation)' => '(cliquer ici pour ajouter une salutation)',
      '(Click here to add a signature)' => '(cliquer ici pour ajouter une signature)',
      '(Click here to add a system email address)' => '(cliquer ici pour ajouter une adresse courriel du syst&egrave;me)',
      '(Click here to add a user)' => '(cliquer ici pour ajouter un utilisateur)',
      '(Click here to add an auto response)' => '(cliquer ici pour ajouter une r&eacute;ponse automatique)',
      '(Click here to add charset)' => '(cliquer ici pour ajouter un jeu de caract&egrave;res syst&egrave;me',
      '(Click here to add language)' => '(cliquer ici pour ajouter une langue)',
      '(Click here to add state)' => '(cliquer ici pour ajouter un &eacute;tat)',
      'A message should have a From: recipient!' => 'Un message devrait avoir un champ From:',
      'New ticket via call.' => 'Nouveau ticket par t&eacute;l&eacute;phone',
      'Time till escalation' => 'Dur&eacute;e avant escalade',
      'Update auto response' => 'Actualiser une r&eacute;ponse automatique',
      'Update charset' => 'Actualiser un jeu de caract&egrave;res syst&egrave;me',
      'Update group' => 'Actualiser un groupe',
      'Update language' => 'Actualiser une langue',
      'Update queue' => 'Actualiser une file',
      'Update response' => 'Actualiser une r&eacute;ponse',
      'Update salutation' => 'Actualiser une salutation',
      'Update signature' => 'Actualiser une signature',
      'Update state' => 'Actualiser un &eacute;tat',
      'Update system address' => 'Actualiser les adresses courriel du syst&egrave;me',
      'Update user' => 'Actualiser un utilisateur',
      'You have to be in the admin group!' => 'Il est n&eacute;cessaire d\'être dans le groupe d\'administration&nbsp;!',
      'You have to be in the stats group!' => 'Il est n&eacute;cessaire d\'être dans le groupe des statistiques&nbsp;!',
      'You need a email address (e. g. customer@example.com) in From:!' => '',
      'auto responses set' => 'R&eacute;ponse automatique positionn&eacute;',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;

}
# --
1;
