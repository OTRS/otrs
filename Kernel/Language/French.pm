# --
# Kernel/Language/French.pm - provides French language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# --
# $Id: French.pm,v 1.5 2002-11-21 22:17:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::French;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/\$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];

    # Template: AAABasics
    $Hash{' 2 minutes'} = ' 2 minutes';
    $Hash{' 5 minutes'} = ' 5 minutes';
    $Hash{' 7 minutes'} = ' 7 minutes';
    $Hash{'10 minutes'} = '10 minutes';
    $Hash{'15 minutes'} = '15 minutes';
    $Hash{'AddLink'} = 'Ajouter un lien';
    $Hash{'AdminArea'} = 'Zone d\'administration';
    $Hash{'all'} = 'tout';
    $Hash{'All'} = 'Tout';
    $Hash{'Attention'} = 'Attention';
    $Hash{'Bug Report'} = 'Rapport d\'anomalie';
    $Hash{'Cancel'} = '';
    $Hash{'change'} = 'modifier';
    $Hash{'Change'} = 'Modifier';
    $Hash{'change!'} = 'modifier&nbsp;!';
    $Hash{'click here'} = '';
    $Hash{'Comment'} = 'Commentaire';
    $Hash{'Customer'} = 'Client';
    $Hash{'Customer info'} = 'Information client';
    $Hash{'day'} = 'jour';
    $Hash{'days'} = 'jours';
    $Hash{'Description'} = 'Description';
    $Hash{'description'} = 'description';
    $Hash{'Done'} = '';
    $Hash{'end'} = 'fin';
    $Hash{'Error'} = 'Erreur';
    $Hash{'Example'} = 'Exemple';
    $Hash{'Examples'} = 'Exemples';
    $Hash{'go'} = '';
    $Hash{'go!'} = 'c\'est parti&nbsp;!';
    $Hash{'Group'} = 'Groupe';
    $Hash{'Hit'} = 'Hit';
    $Hash{'Hits'} = '';
    $Hash{'hour'} = 'heure';
    $Hash{'hours'} = 'heures';
    $Hash{'Ignore'} = '';
    $Hash{'Language'} = 'Langue';
    $Hash{'Languages'} = 'Langues';
    $Hash{'Line'} = 'Ligne';
    $Hash{'Logout successful. Thank you for using OTRS!'} = '';
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
    $Hash{'No suggestions'} = '';
    $Hash{'none'} = 'aucun';
    $Hash{'none - answered'} = 'aucun - répondu';
    $Hash{'none!'} = 'aucun&nbsp;!';
    $Hash{'off'} = 'éteint';
    $Hash{'Off'} = 'Éteint';
    $Hash{'On'} = 'Allumé';
    $Hash{'on'} = 'allumé';
    $Hash{'Password'} = '';
    $Hash{'Please answer this ticket(s) to get back to the normal queue view!'} = 'Il faut répondre à ce(s) ticket(s) pour revenir à la vue normale de la file.';
    $Hash{'please do not edit!'} = 'Ne pas modifier&nbsp;!';
    $Hash{'QueueView'} = 'Vue file';
    $Hash{'replace with'} = '';
    $Hash{'Reset'} = '';
    $Hash{'Salutation'} = 'Salutation';
    $Hash{'Signature'} = 'Signature';
    $Hash{'Sorry'} = 'Désolé';
    $Hash{'Stats'} = 'Statistiques';
    $Hash{'Subfunction'} = 'sous-fonction';
    $Hash{'submit'} = '';
    $Hash{'submit!'} = 'soumettre&nbsp;!';
    $Hash{'Text'} = '';
    $Hash{'The recommended charset for your language is %s!'} = '';
    $Hash{'Theme'} = '';
    $Hash{'top'} = 'haut';
    $Hash{'update'} = '';
    $Hash{'update!'} = 'actualiser&nbsp;!';
    $Hash{'User'} = 'Utilisateur';
    $Hash{'Username'} = '';
    $Hash{'Valid'} = 'Valide';
    $Hash{'Warning'} = '';
    $Hash{'Welcome to OTRS'} = '';
    $Hash{'Word'} = '';
    $Hash{'wrote'} = 'écrit';
    $Hash{'yes'} = 'oui';
    $Hash{'Yes'} = 'Oui';
    $Hash{'You got new message!'} = '';

    # Template: AAALanguage
    $Hash{'Brazilian'} = 'Brésilien';
    $Hash{'Chinese'} = 'Chinois';
    $Hash{'Czech'} = 'Tchèque';
    $Hash{'Danish'} = 'Danois';
    $Hash{'Dutch'} = 'Hollandais';
    $Hash{'English'} = 'Anglais';
    $Hash{'French'} = 'Français';
    $Hash{'German'} = 'Allemand';
    $Hash{'Greek'} = 'Grec';
    $Hash{'Italian'} = 'Italien';
    $Hash{'Korean'} = 'Koréen';
    $Hash{'Polish'} = 'Polonais';
    $Hash{'Russian'} = 'Russe';
    $Hash{'Spanish'} = 'Espagnol';
    $Hash{'Swedish'} = 'Suédois';

    # Template: AAAPreferences
    $Hash{'Custom Queue'} = '';
    $Hash{'Follow up notification'} = '';
    $Hash{'Frontend'} = '';
    $Hash{'Mail Management'} = '';
    $Hash{'Move notification'} = '';
    $Hash{'New ticket notification'} = '';
    $Hash{'Other Options'} = '';
    $Hash{'Preferences updated successfully!'} = '';
    $Hash{'QueueView refresh time'} = '';
    $Hash{'Select your frontend Charset.'} = 'Choix du jeu de caractères du frontal';
    $Hash{'Select your frontend language.'} = 'Choix de la langue du frontal';
    $Hash{'Select your frontend QueueView.'} = '';
    $Hash{'Select your frontend Theme.'} = 'Choix du thème du frontal';
    $Hash{'Select your QueueView refresh time.'} = 'Choix du délai de rafraîchissement de la vue des files';
    $Hash{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Me prévenir si un client envoie un suivi (follow-up) et que je suis le propriétaire du ticket.';
    $Hash{'Send me a notification if a ticket is moved into a custom queue.'} = '';
    $Hash{'Send me a notification if a ticket is unlocked by the system.'} = '';
    $Hash{'Send me a notification if there is a new ticket in my custom queues.'} = 'Me prévenir si un nouveau ticket apparaît dans mes files personnelles.';
    $Hash{'Ticket lock timeout notification'} = '';

    # Template: AAATicket
    $Hash{'Action'} = 'Action';
    $Hash{'Age'} = 'Vieillir';
    $Hash{'Article'} = 'Article';
    $Hash{'Attachment'} = 'Pièce jointe';
    $Hash{'Attachments'} = '';
    $Hash{'Bcc'} = '';
    $Hash{'Bounce'} = 'Renvoyer';
    $Hash{'Cc'} = 'Copie ';
    $Hash{'Close'} = 'Fermer';
    $Hash{'closed succsessful'} = 'clôture réussie';
    $Hash{'closed unsuccsessful'} = 'clôture manquée';
    $Hash{'Compose'} = 'Composer';
    $Hash{'Created'} = 'Créé ';
    $Hash{'Createtime'} = 'Création du ';
    $Hash{'eMail'} = '';
    $Hash{'email'} = 'courriel';
    $Hash{'email-external'} = 'message externe';
    $Hash{'email-internal'} = 'message interne';
    $Hash{'Forward'} = 'Transmettre';
    $Hash{'From'} = 'De ';
    $Hash{'high'} = 'bloque tout un poste';
    $Hash{'History'} = 'Historique';
    $Hash{'If it is not displayed correctly,'} = '';
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
    $Hash{'Queue'} = '';
    $Hash{'removed'} = 'supprimé';
    $Hash{'Sender'} = 'Émetteur';
    $Hash{'sms'} = '';
    $Hash{'State'} = 'État';
    $Hash{'Subject'} = 'Sujet';
    $Hash{'This is a'} = '';
    $Hash{'This is a HTML email. Click here to show it.'} = 'Ceci est un message au format HTML&nbsp;; cliquer ici pour l\'afficher.';
    $Hash{'This message was written in a character set other than your own.'} = '';
    $Hash{'Ticket'} = 'Ticket';
    $Hash{'To'} = 'À ';
    $Hash{'to open it in a new window.'} = '';
    $Hash{'Unlock'} = 'Déverrouiller';
    $Hash{'very high'} = 'bloque un service entier';
    $Hash{'very low'} = 'confort intellectuel';
    $Hash{'View'} = 'Vue';
    $Hash{'webrequest'} = '';
    $Hash{'Zoom'} = 'Détail';

    # Template: AdminAutoResponseForm
    $Hash{'Add auto response'} = 'Ajouter une réponse automatique';
    $Hash{'Auto Response From'} = '';
    $Hash{'Auto Response Management'} = 'Gestion des réponses automatiques';
    $Hash{'Change auto response settings'} = 'Modifier les paramètres de réponses automatiques';
    $Hash{'Charset'} = '';
    $Hash{'Note'} = '';
    $Hash{'Response'} = 'Réponse';
    $Hash{'to get the first 20 character of the subject'} = '';
    $Hash{'to get the first 5 lines of the email'} = '';
    $Hash{'Type'} = '';
    $Hash{'Useable options'} = 'Options accessibles';

    # Template: AdminCharsetForm
    $Hash{'Add charset'} = 'Ajouter un jeu de caractères système';
    $Hash{'Change system charset setting'} = 'Modification des paramètres du jeu de caractères système';
    $Hash{'System Charset Management'} = 'Gestion du jeu de caractères système';

    # Template: AdminCustomerUserForm
    $Hash{'Add customer user'} = '';
    $Hash{'Change customer user settings'} = '';
    $Hash{'Customer User Management'} = '';
    $Hash{'Customer user will be needed to to login via customer panels.'} = '';
    $Hash{'CustomerID'} = 'Numéro de client#';
    $Hash{'Email'} = 'Courriel';
    $Hash{'Firstname'} = 'Prénom';
    $Hash{'Lastname'} = 'Nom';
    $Hash{'Login'} = '';

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
    $Hash{'Admin-Email'} = '';
    $Hash{'Body'} = '';
    $Hash{'OTRS-Admin Info!'} = '';
    $Hash{'Recipents'} = '';

    # Template: AdminEmailSent
    $Hash{'Message sent to'} = '';

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

    # Template: AdminNavigationBar
    $Hash{'AdminEmail'} = '';
    $Hash{'AgentFrontend'} = 'Frontal d\'agent';
    $Hash{'Auto Response <-> Queue'} = '';
    $Hash{'Auto Responses'} = 'Réponses automatiques';
    $Hash{'Charsets'} = '';
    $Hash{'CustomerUser'} = '';
    $Hash{'Email Addresses'} = 'Adresses courriel';
    $Hash{'Groups'} = 'Groupes';
    $Hash{'Logout'} = 'Déconnexion';
    $Hash{'Responses'} = 'Réponses';
    $Hash{'Responses <-> Queue'} = 'Réponses <-> Files';
    $Hash{'Select Box'} = '';
    $Hash{'Session Management'} = 'Gestion des sessions';
    $Hash{'Status defs'} = '';
    $Hash{'User <-> Groups'} = '';

    # Template: AdminQueueAutoResponseForm
    $Hash{'Queue <-> Auto Response Management'} = 'Gestion des files <-> réponses automatiques';

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
    $Hash{'0 = no escalation'} = '';
    $Hash{'0 = no unlock'} = '';
    $Hash{'Add queue'} = 'Ajouter une file';
    $Hash{'Change queue settings'} = 'Modifier les paramètres des files';
    $Hash{'Escalation time'} = 'Délai d\'escalade';
    $Hash{'Follow up Option'} = '';
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
    $Hash{'Realname'} = '';
    $Hash{'System Email Addresses Management'} = 'Gestion des adresses courriel du système';

    # Template: AdminUserForm
    $Hash{'Add user'} = 'Ajouter un utilisateur';
    $Hash{'Change user settings'} = 'Modification des paramètres utilisateurs';
    $Hash{'Don\'t forget to add a new user to groups!'} = 'Ne pas oublier d\'ajouter un nouvel utilisateur aux groupes&nbsp;!';
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
    $Hash{'A message should have a From: recipient!'} = '';
    $Hash{'new ticket'} = 'nouveau ticket';
    $Hash{'New ticket via call.'} = '';
    $Hash{'You need a email address (e. g. customer@example.com) in From:!'} = '';

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

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom
    $Hash{'Accounted time'} = '';

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header
    $Hash{'Home'} = '';

    # Template: InstallerStart
    $Hash{'next step'} = '';

    # Template: InstallerSystem

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
    $Hash{'auto responses set'} = 'Réponse automatique positionnée';

    $Self->{Translation} = \%Hash;

}
# --
1;
