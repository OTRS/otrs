# --
# Kernel/Language/fr.pm - provides fr language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# --
# $Id: fr.pm,v 1.4 2002-12-20 19:08:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fr;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/\$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Fri Dec 20 19:49:20 2002 by Nicolas Goralski

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';

    # Template: AAABase
    $Hash{' 2 minutes'} = ' 2 minutes';
    $Hash{' 5 minutes'} = ' 5 minutes';
    $Hash{' 7 minutes'} = ' 7 minutes';
    $Hash{'10 minutes'} = '10 minutes';
    $Hash{'15 minutes'} = '15 minutes';
    $Hash{'AddLink'} = 'Ajouter un lien';
    $Hash{'AdminArea'} = 'Zone d\'administration';
    $Hash{'All'} = 'Tout';
    $Hash{'all'} = 'tout';
    $Hash{'Attention'} = 'Attention';
    $Hash{'Bug Report'} = 'Rapport d\'anomalie';
    $Hash{'Cancel'} = '';
    $Hash{'Change'} = 'Modifier';
    $Hash{'change'} = 'modifier';
    $Hash{'change!'} = 'modifier&nbsp;!';
    $Hash{'click here'} = '';
    $Hash{'Comment'} = 'Commentaire';
    $Hash{'Customer'} = 'Client';
    $Hash{'Customer info'} = 'Information client';
    $Hash{'day'} = 'jour';
    $Hash{'days'} = 'jours';
    $Hash{'description'} = 'description';
    $Hash{'Description'} = 'Description';
    $Hash{'Done'} = 'Fait';
    $Hash{'end'} = 'fin';
    $Hash{'Error'} = 'Erreur';
    $Hash{'Example'} = 'Exemple';
    $Hash{'Examples'} = 'Exemples';
    $Hash{'Feature not acitv!'} = '';
    $Hash{'go'} = '';
    $Hash{'go!'} = 'c\'est parti&nbsp;!';
    $Hash{'Group'} = 'Groupe';
    $Hash{'Hit'} = 'Hit';
    $Hash{'Hits'} = 'Hits';
    $Hash{'hour'} = 'heure';
    $Hash{'hours'} = 'heures';
    $Hash{'Ignore'} = 'Ignorer';
    $Hash{'invalid'} = '';
    $Hash{'Invalid SessionID!'} = '';
    $Hash{'Language'} = 'Langue';
    $Hash{'Languages'} = 'Langues';
    $Hash{'Line'} = 'Ligne';
    $Hash{'Lite'} = '';
    $Hash{'Login failed! Your username or password was entered incorrectly.'} = '';
    $Hash{'Logout successful. Thank you for using OTRS!'} = 'Déconnection réussie. Merci d\'avoir utilisé OTRS!';
    $Hash{'Message'} = 'Message';
    $Hash{'minute'} = 'minute';
    $Hash{'minutes'} = 'minutes';
    $Hash{'Module'} = 'Module';
    $Hash{'Modulefile'} = 'Fichier de module';
    $Hash{'Name'} = 'Nom';
    $Hash{'New message'} = 'Nouveau message';
    $Hash{'New message!'} = 'Nouveau message&nbsp;!';
    $Hash{'no'} = 'aucun';
    $Hash{'No'} = 'Non';
    $Hash{'No suggestions'} = 'Pas de suggestions';
    $Hash{'none'} = 'aucun';
    $Hash{'none - answered'} = 'aucun - répondu';
    $Hash{'none!'} = 'aucun&nbsp;!';
    $Hash{'Off'} = 'Éteint';
    $Hash{'off'} = 'éteint';
    $Hash{'on'} = 'allumé';
    $Hash{'On'} = 'Allumé';
    $Hash{'Password'} = 'Mot de Passe';
    $Hash{'Please answer this ticket(s) to get back to the normal queue view!'} = 'Il faut répondre à ce(s) ticket(s) pour revenir à la vue normale de la file.';
    $Hash{'Please contact your admin'} = '';
    $Hash{'please do not edit!'} = 'Ne pas modifier&nbsp;!';
    $Hash{'QueueView'} = 'Vue file';
    $Hash{'replace with'} = 'remplacer par';
    $Hash{'Reset'} = 'Remise à zéro';
    $Hash{'Salutation'} = 'Salutation';
    $Hash{'Signature'} = 'Signature';
    $Hash{'Sorry'} = 'Désolé';
    $Hash{'Stats'} = 'Statistiques';
    $Hash{'Subfunction'} = 'sous-fonction';
    $Hash{'submit'} = 'soumettre';
    $Hash{'submit!'} = 'soumettre&nbsp;!';
    $Hash{'Text'} = 'Texte';
    $Hash{'The recommended charset for your language is %s!'} = 'Les jeux de charactères pour votre langue est %s!';
    $Hash{'Theme'} = 'Thème';
    $Hash{'There is no account with that login name.'} = '';
    $Hash{'top'} = 'haut';
    $Hash{'update'} = 'Mise à jour';
    $Hash{'update!'} = 'actualiser&nbsp;!';
    $Hash{'User'} = 'Utilisateur';
    $Hash{'Username'} = 'Nom d\'utilisateur';
    $Hash{'Valid'} = 'Valide';
    $Hash{'Warning'} = 'Attention';
    $Hash{'Welcome to OTRS'} = 'Bienvenue à OTRS';
    $Hash{'Word'} = 'Mot';
    $Hash{'wrote'} = 'écrit';
    $Hash{'yes'} = 'oui';
    $Hash{'Yes'} = 'Oui';
    $Hash{'You got new message!'} = 'Vous avez un nouveau Message';

    # Template: AAAMonth
    $Hash{'Apr'} = '';
    $Hash{'Aug'} = '';
    $Hash{'Dec'} = '';
    $Hash{'Feb'} = '';
    $Hash{'Jan'} = '';
    $Hash{'Jul'} = '';
    $Hash{'Jun'} = '';
    $Hash{'Mar'} = '';
    $Hash{'May'} = '';
    $Hash{'Nov'} = '';
    $Hash{'Oct'} = '';
    $Hash{'Sep'} = '';

    # Template: AAAPreferences
    $Hash{'Custom Queue'} = 'File d\'attente personnelle';
    $Hash{'Follow up notification'} = 'Notification de suivi';
    $Hash{'Frontend'} = 'Frontal';
    $Hash{'Mail Management'} = 'Gestion des Emails';
    $Hash{'Move notification'} = 'Notification de mouvement';
    $Hash{'New ticket notification'} = 'Notification de nouveau ticket';
    $Hash{'Other Options'} = 'Autres options';
    $Hash{'Preferences updated successfully!'} = 'Les préférences ont bien été mises à jours';
    $Hash{'QueueView refresh time'} = 'Temps de rafraîchissement de la vue des files';
    $Hash{'Select your frontend Charset.'} = 'Choix du jeu de caractères du frontal';
    $Hash{'Select your frontend language.'} = 'Choix de la langue du frontal';
    $Hash{'Select your frontend QueueView.'} = 'Choisissez votre frontal de vue des files';
    $Hash{'Select your frontend Theme.'} = 'Choix du thème du frontal';
    $Hash{'Select your QueueView refresh time.'} = 'Choix du délai de rafraîchissement de la vue des files';
    $Hash{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Me prévenir si un client envoie un suivi (follow-up) et que je suis le propriétaire du ticket.';
    $Hash{'Send me a notification if a ticket is moved into a custom queue.'} = 'Me prévenir si un ticket est déplacé dans une file personnalisé';
    $Hash{'Send me a notification if a ticket is unlocked by the system.'} = 'Me prévenir si un ticket est dévérouillé par le système';
    $Hash{'Send me a notification if there is a new ticket in my custom queues.'} = 'Me prévenir si un nouveau ticket apparaît dans mes files personnelles.';
    $Hash{'Ticket lock timeout notification'} = 'Prévenir du dépassement du délai d\'un verrou ';

    # Template: AAATicket
    $Hash{'Action'} = 'Action';
    $Hash{'Age'} = 'Vieillir';
    $Hash{'Article'} = 'Article';
    $Hash{'Attachment'} = 'Pièce jointe';
    $Hash{'Attachments'} = 'Pièces jointes';
    $Hash{'Bcc'} = 'Copie Invisible';
    $Hash{'Bounce'} = 'Renvoyer';
    $Hash{'Cc'} = 'Copie ';
    $Hash{'Close'} = 'Fermer';
    $Hash{'closed successful'} = 'clôture réussie';
    $Hash{'closed unsuccessful'} = 'clôture manquée';
    $Hash{'Compose'} = 'Composer';
    $Hash{'Created'} = 'Créé ';
    $Hash{'Createtime'} = 'Création du ';
    $Hash{'email'} = 'courriel';
    $Hash{'eMail'} = 'courriel';
    $Hash{'email-external'} = 'message externe';
    $Hash{'email-internal'} = 'message interne';
    $Hash{'Forward'} = 'Transmettre';
    $Hash{'From'} = 'De ';
    $Hash{'high'} = 'bloque tout un poste';
    $Hash{'History'} = 'Historique';
    $Hash{'If it is not displayed correctly,'} = 'Si il n\'est pas affiché correctement';
    $Hash{'Lock'} = 'Verrouiller';
    $Hash{'low'} = 'confort de fonctionnement';
    $Hash{'Move'} = 'Déplacer';
    $Hash{'new'} = 'nouveau';
    $Hash{'normal'} = 'bloque une fonction';
    $Hash{'note-external'} = 'Note externe';
    $Hash{'note-internal'} = 'Note interne';
    $Hash{'note-report'} = 'Note rapport';
    $Hash{'open'} = 'ouvrir';
    $Hash{'Owner'} = 'Propriétaire';
    $Hash{'Pending'} = 'En attente';
    $Hash{'phone'} = 'téléphone';
    $Hash{'plain'} = 'tel quel';
    $Hash{'Priority'} = 'Priorité';
    $Hash{'Queue'} = 'File';
    $Hash{'removed'} = 'supprimé';
    $Hash{'Sender'} = 'Émetteur';
    $Hash{'sms'} = 'sms';
    $Hash{'State'} = 'État';
    $Hash{'Subject'} = 'Sujet';
    $Hash{'This is a'} = 'Ceci est un';
    $Hash{'This is a HTML email. Click here to show it.'} = 'Ceci est un message au format HTML&nbsp;; cliquer ici pour l\'afficher.';
    $Hash{'This message was written in a character set other than your own.'} = '';
    $Hash{'Ticket'} = 'Ticket';
    $Hash{'To'} = 'À ';
    $Hash{'to open it in a new window.'} = 'Pour l\'ouvrir dans une nouvelle fenêtre';
    $Hash{'Unlock'} = 'Déverrouiller';
    $Hash{'very high'} = 'bloque un service entier';
    $Hash{'very low'} = 'confort intellectuel';
    $Hash{'View'} = 'Vue';
    $Hash{'webrequest'} = 'Requete par le web';
    $Hash{'Zoom'} = 'Détail';

    # Template: AAAWeekDay
    $Hash{'Fri'} = '';
    $Hash{'Mon'} = '';
    $Hash{'Sat'} = '';
    $Hash{'Sun'} = '';
    $Hash{'Thu'} = '';
    $Hash{'Tue'} = '';
    $Hash{'Wed'} = '';

    # Template: AdminAutoResponseForm
    $Hash{'Add auto response'} = 'Ajouter une réponse automatique';
    $Hash{'Auto Response From'} = 'Réponse automatique de ';
    $Hash{'Auto Response Management'} = 'Gestion des réponses automatiques';
    $Hash{'Change auto response settings'} = 'Modifier les paramètres de réponses automatiques';
    $Hash{'Charset'} = 'Jeu de charactère';
    $Hash{'Note'} = 'Note';
    $Hash{'Response'} = 'Réponse';
    $Hash{'to get the first 20 character of the subject'} = 'pour avoir les 20 premiers charactères du sujet ';
    $Hash{'to get the first 5 lines of the email'} = 'pour avoir les 5 premières ligne du mail';
    $Hash{'to get the from line of the email'} = '';
    $Hash{'to get the realname of the sender (if given)'} = '';
    $Hash{'to get the ticket number of the ticket'} = '';
    $Hash{'Type'} = 'Type';
    $Hash{'Useable options'} = 'Options accessibles';

    # Template: AdminCharsetForm
    $Hash{'Add charset'} = 'Ajouter un jeu de caractères système';
    $Hash{'Change system charset setting'} = 'Modification des paramètres du jeu de caractères système';
    $Hash{'System Charset Management'} = 'Gestion du jeu de caractères système';

    # Template: AdminCustomerUserForm
    $Hash{'Add customer user'} = 'Ajouter un utilisateur client';
    $Hash{'Change customer user settings'} = 'Changer les préférences utilisateurs du client';
    $Hash{'Customer User Management'} = 'Gestion des clients utilisateurs';
    $Hash{'Customer user will be needed to to login via customer panels.'} = '';

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
    $Hash{'Admin-Email'} = 'Email de l\'administrateur';
    $Hash{'Body'} = 'Corps';
    $Hash{'OTRS-Admin Info!'} = 'Information de l\'administrateur OTRS';
    $Hash{'Recipents'} = 'Récipients';

    # Template: AdminEmailSent
    $Hash{'Message sent to'} = 'Message envoyé à';

    # Template: AdminGroupForm
    $Hash{'Add group'} = 'Ajouter un groupe';
    $Hash{'Change group settings'} = 'Changer les paramètres d\'un groupe';
    $Hash{'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'} = 'De nouveaux groupes permettront de gérer les droits d\'accès pour les différents groupes d\'un agent (exemple&nbsp;: achats, comptabilité, support, ventes...).';
    $Hash{'Group Management'} = 'Administration des groupes';
    $Hash{'It\'s useful for ASP solutions.'} = 'C\'est utile pour les fournisseurs d\'applications.';
    $Hash{'The admin group is to get in the admin area and the stats group to get stats area.'} = 'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.';

    # Template: AdminLanguageForm
    $Hash{'Add language'} = 'Ajouter une langue';
    $Hash{'Change system language setting'} = 'Modification des parmètres de langue du système';
    $Hash{'System Language Management'} = 'Gestion des langues du système';

    # Template: AdminLog
    $Hash{'System Log'} = '';

    # Template: AdminNavigationBar
    $Hash{'AdminEmail'} = 'Email de l\'administrateur.';
    $Hash{'AgentFrontend'} = 'Frontal d\'agent';
    $Hash{'Auto Response <-> Queue'} = 'Réponse Automatique <-> Files';
    $Hash{'Auto Responses'} = 'Réponses automatiques';
    $Hash{'Charsets'} = 'Jeu de Charactère';
    $Hash{'Customer User'} = 'Client Utilisateur';
    $Hash{'Email Addresses'} = 'Adresses courriel';
    $Hash{'Groups'} = 'Groupes';
    $Hash{'Logout'} = 'Déconnexion';
    $Hash{'POP3 Account'} = '';
    $Hash{'Responses'} = 'Réponses';
    $Hash{'Responses <-> Queue'} = 'Réponses <-> Files';
    $Hash{'Select Box'} = 'Choisissez une boîte';
    $Hash{'Session Management'} = 'Gestion des sessions';
    $Hash{'Status defs'} = '';
    $Hash{'User <-> Groups'} = 'Utilisateur <-> Groupes';

    # Template: AdminPOP3Form
    $Hash{'Add POP3 Account'} = '';
    $Hash{'All incoming emails with one account will be dispatched in the selected queue!'} = '';
    $Hash{'Change POP3 Account setting'} = '';
    $Hash{'Host'} = '';
    $Hash{'If your account is trusted, the x-otrs header (for priority, ...) will be used!'} = '';
    $Hash{'Login'} = 'Login';
    $Hash{'POP3 Account Management'} = '';
    $Hash{'Trusted'} = '';

    # Template: AdminQueueAutoResponseForm
    $Hash{'Queue <-> Auto Response Management'} = 'Gestion des files <-> réponses automatiques';

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
    $Hash{'0 = no escalation'} = '0 = pas d\'escalade';
    $Hash{'0 = no unlock'} = '0 = pas de vérouillage';
    $Hash{'Add queue'} = 'Ajouter une file';
    $Hash{'Change queue settings'} = 'Modifier les paramètres des files';
    $Hash{'Escalation time'} = 'Délai d\'escalade';
    $Hash{'Follow up Option'} = 'Option des suivis';
    $Hash{'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.'} = '';
    $Hash{'If a ticket will not be answered in thos time, just only this ticket will be shown.'} = '';
    $Hash{'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.'} = '';
    $Hash{'Key'} = 'Clef';
    $Hash{'Queue Management'} = 'Gestion des files';
    $Hash{'Systemaddress'} = '';
    $Hash{'The salutation for email answers.'} = '';
    $Hash{'The signature for email answers.'} = '';
    $Hash{'Ticket lock after a follow up'} = '';
    $Hash{'Unlock timeout'} = 'Déverrouiller la temporisation';
    $Hash{'Will be the sender address of this queue for email answers.'} = '';

    # Template: AdminQueueResponsesChangeForm
    $Hash{'Change %s settings'} = '';
    $Hash{'Std. Responses <-> Queue Management'} = 'Gestion des réponses standard <-> files';

    # Template: AdminQueueResponsesForm
    $Hash{'Answer'} = '';
    $Hash{'Change answer <-> queue settings'} = 'Modifier les paramètres de réponses <-> files';

    # Template: AdminResponseForm
    $Hash{'A response is default text to write faster answer (with default text) to customers.'} = 'Une réponse est un texte par défaut destiné à rédiger plus rapidement des réponses standard aux clients.';
    $Hash{'Add response'} = 'Ajouter une réponse';
    $Hash{'Change response settings'} = 'Modifier les paramètres des réponses';
    $Hash{'Don\'t forget to add a new response a queue!'} = 'Ne pas oublier d\'ajouter une file à une nouvelle réponse&nbsp;!';
    $Hash{'Response Management'} = 'Gestion des réponses';

    # Template: AdminSalutationForm
    $Hash{'Add salutation'} = 'Ajouter une salutation';
    $Hash{'Change salutation settings'} = 'Modification des paramètres de salutations';
    $Hash{'customer realname'} = 'nom réel du client';
    $Hash{'Salutation Management'} = 'Gestion des salutations';

    # Template: AdminSelectBoxForm
    $Hash{'Max Rows'} = 'Nombre de lignes maximal';

    # Template: AdminSelectBoxResult
    $Hash{'Limit'} = '';
    $Hash{'Select Box Result'} = '';
    $Hash{'SQL'} = '';

    # Template: AdminSession
    $Hash{'kill all sessions'} = 'Terminer toutes les sessions';

    # Template: AdminSessionTable
    $Hash{'kill session'} = 'Terminer une session';
    $Hash{'SessionID'} = '';

    # Template: AdminSignatureForm
    $Hash{'Add signature'} = 'Ajouter une signature';
    $Hash{'Change signature settings'} = 'Modification des paramètres de signatures';
    $Hash{'for agent firstname'} = 'pour le prénom de l\'agent';
    $Hash{'for agent lastname'} = 'pour le nom de l\'agent';
    $Hash{'Signature Management'} = 'Gestion des signatures';

    # Template: AdminStateForm
    $Hash{'Add state'} = 'Ajouter un état';
    $Hash{'Change system state setting'} = 'Modification des paramètres d\'états du système';
    $Hash{'System State Management'} = 'Gestion des états du système';

    # Template: AdminSystemAddressForm
    $Hash{'Add system address'} = 'Ajouter une adresse courriel du système';
    $Hash{'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!'} = 'Tous les courriels avec cette adresse en destinataire (À&nbsp;:) seront placés dans la file choisie..';
    $Hash{'Change system address setting'} = 'Modification des paramètres des adresses courriel du système';
    $Hash{'Email'} = 'Courriel';
    $Hash{'Realname'} = '';
    $Hash{'System Email Addresses Management'} = 'Gestion des adresses courriel du système';

    # Template: AdminUserForm
    $Hash{'Add user'} = 'Ajouter un utilisateur';
    $Hash{'Change user settings'} = 'Modification des paramètres utilisateurs';
    $Hash{'Don\'t forget to add a new user to groups!'} = 'Ne pas oublier d\'ajouter un nouvel utilisateur aux groupes&nbsp;!';
    $Hash{'Firstname'} = 'Prénom';
    $Hash{'Lastname'} = 'Nom';
    $Hash{'User Management'} = 'Administration des utilisateurs';
    $Hash{'User will be needed to handle tickets.'} = 'Un utilisateur sera nécessaire pour gérer les tickets.';

    # Template: AdminUserGroupChangeForm
    $Hash{'Change  settings'} = '';
    $Hash{'User <-> Group Management'} = 'Gestion utilisateurs <-> groupes';

    # Template: AdminUserGroupForm
    $Hash{'Change user <-> group settings'} = 'Modifier les paramètres utilisateurs <-> groupes';

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
    $Hash{'A message should have a To: recipient!'} = 'Un message doit avoir un destinataire (À&nbsp;:)!';
    $Hash{'Bounce ticket'} = '';
    $Hash{'Bounce to'} = '';
    $Hash{'Inform sender'} = '';
    $Hash{'Next ticket state'} = 'Prochain état du ticket';
    $Hash{'Send mail!'} = 'Envoyer le courriel&nbsp;!';
    $Hash{'You need a email address (e. g. customer@example.com) in To:!'} = 'Il faut une adresse courriel (ecemple&nbsp;: client@exemple.fr)&nbsp;!';
    $Hash{'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.'} = '';

    # Template: AgentClose
    $Hash{' (work units)'} = '';
    $Hash{'Close ticket'} = '';
    $Hash{'Close type'} = '';
    $Hash{'Close!'} = '';
    $Hash{'Note Text'} = '';
    $Hash{'Note type'} = 'Type de note';
    $Hash{'store'} = 'stocker';
    $Hash{'Time units'} = '';

    # Template: AgentCompose
    $Hash{'A message should have a subject!'} = 'Un message doit avoir un sujet&nbsp;!';
    $Hash{'Attach'} = '';
    $Hash{'Compose answer for ticket'} = 'Composer une réponse pour le ticket';
    $Hash{'Is the ticket answered'} = '';
    $Hash{'Options'} = '';
    $Hash{'Spell Check'} = '';

    # Template: AgentCustomer
    $Hash{'Back'} = 'retour';
    $Hash{'Change customer of ticket'} = '';
    $Hash{'Set customer id of a ticket'} = 'Définir le numéro de client d\'un ticket';

    # Template: AgentCustomerHistory
    $Hash{'Customer history'} = '';

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
    $Hash{'Customer Data'} = '';

    # Template: AgentForward
    $Hash{'Article type'} = 'Type d\'article';
    $Hash{'Date'} = '';
    $Hash{'End forwarded message'} = '';
    $Hash{'Forward article of ticket'} = 'Transmettre l\'article du ticket';
    $Hash{'Forwarded message from'} = '';
    $Hash{'Reply-To'} = '';

    # Template: AgentHistoryForm
    $Hash{'History of'} = '';

    # Template: AgentMailboxTicket
    $Hash{'Add Note'} = 'Ajouter note';
    $Hash{'CustomerID'} = 'Numéro de client#';

    # Template: AgentNavigationBar
    $Hash{'FAQ'} = '';
    $Hash{'Locked tickets'} = 'Tickets verrouillés';
    $Hash{'new message'} = 'Nouveau message';
    $Hash{'PhoneView'} = 'Vue téléphone';
    $Hash{'Preferences'} = 'Préférences';
    $Hash{'Utilities'} = 'Utilitaires';

    # Template: AgentNote
    $Hash{'Add note to ticket'} = 'Ajouter une note au ticket';
    $Hash{'Note!'} = '';

    # Template: AgentOwner
    $Hash{'Change owner of ticket'} = '';
    $Hash{'Message for new Owner'} = '';
    $Hash{'New user'} = '';

    # Template: AgentPhone
    $Hash{'Customer called'} = '';
    $Hash{'Phone call'} = 'Appel téléphonique';
    $Hash{'Phone call at %s'} = '';

    # Template: AgentPhoneNew
    $Hash{'new ticket'} = 'nouveau ticket';

    # Template: AgentPlain
    $Hash{'ArticleID'} = '';
    $Hash{'Plain'} = 'Tel quel';
    $Hash{'TicketID'} = '';

    # Template: AgentPreferencesCustomQueue
    $Hash{'Select your custom queues'} = 'Choix des files personnelles';

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
    $Hash{'Change Password'} = 'Modification du mot de passe';
    $Hash{'New password'} = 'Nouveau mot de passe';
    $Hash{'New password again'} = 'Nouveau mot de passe (confirmation)';

    # Template: AgentPriority
    $Hash{'Change priority of ticket'} = 'Modification de la priorité du ticket';
    $Hash{'New state'} = '';

    # Template: AgentSpelling
    $Hash{'Apply these changes'} = '';
    $Hash{'Discard all changes and return to the compose screen'} = '';
    $Hash{'Return to the compose screen'} = '';
    $Hash{'Spell Checker'} = '';
    $Hash{'spelling error(s)'} = '';
    $Hash{'The message being composed has been closed.  Exiting.'} = '';
    $Hash{'This window must be called from compose window'} = '';

    # Template: AgentStatusView
    $Hash{'D'} = '';
    $Hash{'sort downward'} = '';
    $Hash{'sort upward'} = '';
    $Hash{'Ticket limit:'} = '';
    $Hash{'Ticket Status'} = '';
    $Hash{'U'} = '';

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
    $Hash{'Ticket locked!'} = 'Ticket verrouillé&nbsp;!';
    $Hash{'unlock'} = 'déverrouiller';

    # Template: AgentUtilSearchByCustomerID
    $Hash{'Customer history search'} = '';
    $Hash{'Customer history search (e. g. "ID342425").'} = '';
    $Hash{'No * possible!'} = '';

    # Template: AgentUtilSearchByText
    $Hash{'Article free text'} = '';
    $Hash{'Fulltext search'} = '';
    $Hash{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Recherche en texte intégral (exemple&nbsp;: "Mar*in" ou "Constru*" ou "martin+bonjour")';
    $Hash{'Search in'} = '';
    $Hash{'Ticket free text'} = '';

    # Template: AgentUtilSearchByTicketNumber
    $Hash{'search'} = '';
    $Hash{'search (e. g. 10*5155 or 105658*)'} = '';

    # Template: AgentUtilSearchNavBar
    $Hash{'Results'} = '';
    $Hash{'Site'} = '';
    $Hash{'Total hits'} = 'Total des hits';

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
    $Hash{'All open tickets'} = '';
    $Hash{'open tickets'} = '';
    $Hash{'Provides an overview of all'} = '';
    $Hash{'So you see what is going on in your system.'} = '';

    # Template: CustomerCreateAccount
    $Hash{'Create'} = '';
    $Hash{'Create Account'} = '';

    # Template: CustomerError
    $Hash{'Backend'} = '';
    $Hash{'BackendMessage'} = '';
    $Hash{'Click here to report a bug!'} = 'Cliquer ici pour signaler une anomalie';
    $Hash{'Handle'} = '';

    # Template: CustomerFooter
    $Hash{'Powered by'} = '';

    # Template: CustomerHeader
    $Hash{'Contact'} = '';
    $Hash{'Home'} = '';
    $Hash{'Online-Support'} = '';
    $Hash{'Products'} = '';
    $Hash{'Support'} = '';

    # Template: CustomerLogin

    # Template: CustomerLostPassword
    $Hash{'Lost your password?'} = '';
    $Hash{'Request new password'} = '';

    # Template: CustomerMessage
    $Hash{'Follow up'} = '';

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
    $Hash{'Create new Ticket'} = '';
    $Hash{'My Tickets'} = '';
    $Hash{'New Ticket'} = 'nouveau ticket';
    $Hash{'Ticket-Overview'} = '';
    $Hash{'Welcome %s'} = '';

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
    $Hash{'of'} = '';

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom
    $Hash{'Accounted time'} = '';

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
    $Hash{'next step'} = '';

    # Template: InstallerSystem
    $Hash{'(Email of the system admin)'} = '';
    $Hash{'(Full qualified domain name of your system)'} = '';
    $Hash{'(Logfile just needed for File-LogModule!)'} = '';
    $Hash{'(The identify of the system. Each ticket number and each http session id starts with this number)'} = '';
    $Hash{'(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')'} = '';
    $Hash{'(Used default language)'} = '';
    $Hash{'(Used log backend)'} = '';
    $Hash{'(Used ticket number format)'} = '';
    $Hash{'Default Charset'} = '';
    $Hash{'Default Language'} = '';
    $Hash{'Logfile'} = '';
    $Hash{'LogModule'} = '';
    $Hash{'Organization'} = '';
    $Hash{'System'} = '';
    $Hash{'System FQDN'} = '';
    $Hash{'SystemID'} = '';
    $Hash{'Ticket Hook'} = '';
    $Hash{'Ticket Number Generator'} = '';
    $Hash{'Webfrontend'} = '';

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
    $Hash{'No Permission'} = 'Pas d\'autorisation';

    # Template: Notify
    $Hash{'Info'} = '';

    # Template: QueueView
    $Hash{'All tickets'} = 'tous les tickets';
    $Hash{'Queues'} = 'Files';
    $Hash{'Show all'} = 'Tout montrer';
    $Hash{'Ticket available'} = 'Tickets disponibles';
    $Hash{'tickets'} = 'Tickets';
    $Hash{'Tickets shown'} = 'Tickets affichés';

    # Template: SystemStats
    $Hash{'Graphs'} = 'Graphiques';
    $Hash{'Tickets'} = '';

    # Template: Test
    $Hash{'OTRS Test Page'} = '';

    # Template: TicketEscalation
    $Hash{'Ticket escalation!'} = 'Escalade du ticket';

    # Template: TicketView
    $Hash{'Change queue'} = 'Changer de file';
    $Hash{'Compose Answer'} = 'Composer une réponse';
    $Hash{'Contact customer'} = 'Contacter le client';
    $Hash{'phone call'} = '';
    $Hash{'Time till escalation'} = 'Durée avant escalade';

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
    $Hash{'(Click here to add a group)'} = '(cliquer ici pour ajouter un groupe)';
    $Hash{'(Click here to add a queue)'} = '(cliquer ici pour ajouter une file)';
    $Hash{'(Click here to add a response)'} = '(cliquer ici pour ajouter une réponse)';
    $Hash{'(Click here to add a salutation)'} = '(cliquer ici pour ajouter une salutation)';
    $Hash{'(Click here to add a signature)'} = '(cliquer ici pour ajouter une signature)';
    $Hash{'(Click here to add a system email address)'} = '(cliquer ici pour ajouter une adresse courriel du système)';
    $Hash{'(Click here to add a user)'} = '(cliquer ici pour ajouter un utilisateur)';
    $Hash{'(Click here to add an auto response)'} = '(cliquer ici pour ajouter une réponse automatique)';
    $Hash{'(Click here to add charset)'} = '(cliquer ici pour ajouter un jeu de caractères système';
    $Hash{'(Click here to add language)'} = '(cliquer ici pour ajouter une langue)';
    $Hash{'(Click here to add state)'} = '(cliquer ici pour ajouter un état)';
    $Hash{'A message should have a From: recipient!'} = '';
    $Hash{'New ticket via call.'} = '';
    $Hash{'Update auto response'} = 'Actualiser une réponse automatique';
    $Hash{'Update charset'} = 'Actualiser un jeu de caractères système';
    $Hash{'Update group'} = 'Actualiser un groupe';
    $Hash{'Update language'} = 'Actualiser une langue';
    $Hash{'Update queue'} = 'Actualiser une file';
    $Hash{'Update response'} = 'Actualiser une réponse';
    $Hash{'Update salutation'} = 'Actualiser une salutation';
    $Hash{'Update signature'} = 'Actualiser une signature';
    $Hash{'Update state'} = 'Actualiser un état';
    $Hash{'Update system address'} = 'Actualiser les adresses courriel du système';
    $Hash{'Update user'} = 'Actualiser un utilisateur';
    $Hash{'You have to be in the admin group!'} = 'Il est nécessaire d\'être dans le groupe d\'administration&nbsp;!';
    $Hash{'You have to be in the stats group!'} = 'Il est nécessaire d\'être dans le groupe des statistiques&nbsp;!';
    $Hash{'You need a email address (e. g. customer@example.com) in From:!'} = '';
    $Hash{'auto responses set'} = 'Réponse automatique positionnée';

    # $$STOP$$

    $Self->{Translation} = \%Hash;

}
# --
1;
