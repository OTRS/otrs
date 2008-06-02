# --
# Kernel/Language/fr.pm - provides fr language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# Copyright (C) 2004 Igor Genibel <igor.genibel at eds-opensource.com>
# Copyright (C) 2004-2007 Yann Richard <ze at nbox.org>
# Copyright (C) 2007 Remi Seguy <remi.seguy at laposte.net>
# Copyright (C) 2007 Massimiliano Franco <max-lists at ycom.ch>
# --
# $Id: fr.pm,v 1.88 2008-06-02 12:47:40 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::fr;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.88 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri May 16 14:08:29 2008

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Oui',
        'No' => 'Non',
        'yes' => 'oui',
        'no' => 'non',
        'Off' => 'Désactivé',
        'off' => 'désactivé',
        'On' => 'Activé',
        'on' => 'activé',
        'top' => 'haut',
        'end' => 'fin',
        'Done' => 'Fait',
        'Cancel' => 'Annuler',
        'Reset' => 'Remise à zéro',
        'last' => 'dernier',
        'before' => 'avant',
        'day' => 'jour',
        'days' => 'jours',
        'day(s)' => 'jour(s)',
        'hour' => 'heure',
        'hours' => 'heures',
        'hour(s)' => 'heure(s)',
        'minute' => 'minute',
        'minutes' => 'minutes',
        'minute(s)' => 'minute(s)',
        'month' => 'mois',
        'months' => 'mois',
        'month(s)' => 'mois',
        'week' => 'semaine',
        'week(s)' => 'semaine(s)',
        'year' => 'année',
        'years' => 'années',
        'year(s)' => 'année(s)',
        'second(s)' => 'seconde(s)',
        'seconds' => 'secondes',
        'second' => 'seconde',
        'wrote' => 'a écrit',
        'Message' => 'Message',
        'Error' => 'Erreur',
        'Bug Report' => 'Rapport d\'anomalie',
        'Attention' => 'Attention',
        'Warning' => 'Attention',
        'Module' => 'Module',
        'Modulefile' => 'Fichier de module',
        'Subfunction' => 'sous-fonction',
        'Line' => 'Ligne',
        'Example' => 'Exemple',
        'Examples' => 'Exemples',
        'valid' => 'valide',
        'invalid' => 'invalide',
        '* invalid' => '* invalide',
        'invalid-temporarily' => 'temporairement invalide',
        ' 2 minutes' => ' 2 minutes',
        ' 5 minutes' => ' 5 minutes',
        ' 7 minutes' => ' 7 minutes',
        '10 minutes' => '10 minutes',
        '15 minutes' => '15 minutes',
        'Mr.' => 'M.',
        'Mrs.' => 'Mme',
        'Next' => 'Suivant',
        'Back' => 'Retour',
        'Next...' => 'Suivant...',
        '...Back' => '...Retour',
        '-none-' => '-aucun-',
        'none' => 'aucun',
        'none!' => 'aucun !',
        'none - answered' => 'aucun - réponse faite',
        'please do not edit!' => 'Ne pas modifier !',
        'AddLink' => 'Ajouter un lien',
        'Link' => 'Lien',
        'Unlink' => '',
        'Linked' => 'Liée',
        'Link (Normal)' => 'Lien (Normal)',
        'Link (Parent)' => 'Lien (Parent)',
        'Link (Child)' => 'Lien (Enfant)',
        'Normal' => 'Normal',
        'Parent' => 'Parent',
        'Child' => 'Enfant',
        'Hit' => '',
        'Hits' => '',
        'Text' => 'Texte',
        'Lite' => 'allégée',
        'User' => 'Utilisateur',
        'Username' => 'Nom d\'utilisateur',
        'Language' => 'Langue',
        'Languages' => 'Langues',
        'Password' => 'Mot de Passe',
        'Salutation' => 'En-tête',
        'Signature' => 'Signature',
        'Customer' => 'Client',
        'CustomerID' => 'Numéro de client',
        'CustomerIDs' => 'Numéro de client (Groupe)',
        'customer' => 'client',
        'agent' => 'technicien',
        'system' => 'système',
        'Customer Info' => 'Information client',
        'Customer Company' => 'Entreprise du client',
        'Company' => 'Entreprise',
        'go!' => 'c\'est parti !',
        'go' => 'aller',
        'All' => 'Tout',
        'all' => 'tout',
        'Sorry' => 'Désolé',
        'update!' => 'mettre à jour !',
        'update' => 'mettre à jour',
        'Update' => 'Mettre à jour',
        'submit!' => 'soumettre !',
        'submit' => 'soumettre',
        'Submit' => 'Soumettre',
        'change!' => 'modifier !',
        'Change' => 'Modifier',
        'change' => 'modifier',
        'click here' => 'Cliquer ici',
        'Comment' => 'Commentaire',
        'Valid' => 'Valide',
        'Invalid Option!' => 'Option invalide !',
        'Invalid time!' => 'Temps invalide !',
        'Invalid date!' => 'Date invalide !',
        'Name' => 'Nom',
        'Group' => 'Groupe',
        'Description' => 'Description',
        'description' => 'description',
        'Theme' => 'Thème',
        'Created' => 'Créé',
        'Created by' => 'Créé par',
        'Changed' => 'Changé',
        'Changed by' => 'Changé par',
        'Search' => 'Chercher',
        'and' => 'et le',
        'between' => 'entre',
        'Fulltext Search' => 'Recherche sur tout le texte',
        'Data' => 'Données',
        'Options' => 'Options',
        'Title' => 'Titre',
        'Item' => 'Élément',
        'Delete' => 'Effacer',
        'Edit' => 'Éditer',
        'View' => 'Vue',
        'Number' => 'Nombre',
        'System' => 'Système',
        'Contact' => 'Contact',
        'Contacts' => 'Contacts',
        'Export' => 'Exporter',
        'Up' => 'Haut',
        'Down' => 'Bas',
        'Add' => 'Ajouter',
        'Category' => 'Catégorie',
        'Viewer' => 'Visionneuse',
        'New message' => 'Nouveau message',
        'New message!' => 'Nouveau message !',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Veuillez répondre à ce(s) ticket(s) pour revenir à une vue normale de la file !',
        'You got new message!' => 'Vous avez un nouveau message !',
        'You have %s new message(s)!' => 'Vous avez %s nouveau(x) message(s) !',
        'You have %s reminder ticket(s)!' => 'Vous avez %s rappel(s) de ticket(s) !',
        'The recommended charset for your language is %s!' => 'Le jeu de caractère correspondant à votre langue est %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Les mots de passes diffèrent! Essayez de nouveau svp!',
        'Password is already in use! Please use an other password!' => 'Mot de passe déjà utilisé! Essayez en un autre svp!',
        'Password is already used! Please use an other password!' => 'Ce mot de passe a déjà été utilisé! Essayez en un autre svp!',
        'You need to activate %s first to use it!' => 'Vous devez dabord activer %s pour l\'utiliser !',
        'No suggestions' => 'Pas de suggestions',
        'Word' => 'Mot',
        'Ignore' => 'Ignorer',
        'replace with' => 'remplacer par',
        'There is no account with that login name.' => 'Il n\'y a aucun compte avec ce nom de connexion',
        'Login failed! Your username or password was entered incorrectly.' => 'La connection a échoué ! Votre nom d\'utilisateur ou votre mot de passe sont erronés.',
        'Please contact your admin' => 'Veuillez contacter votre admnistrateur',
        'Logout successful. Thank you for using OTRS!' => 'Déconnexion réussie. Merci d\'avoir utilisé OTRS!',
        'Invalid SessionID!' => 'ID de Session Invalide !',
        'Feature not active!' => 'Cette fonctionnalité n\'est pas activée !',
        'Login is needed!' => 'Authentification requise !',
        'Password is needed!' => 'Le mot de passe est requis !',
        'License' => 'Licence',
        'Take this Customer' => 'Choisir ce client',
        'Take this User' => 'Choisir cet utilisateur',
        'possible' => 'possible',
        'reject' => 'rejeté',
        'reverse' => 'inverse',
        'Facility' => 'Service',
        'Timeover' => 'Temp écoulé',
        'Pending till' => 'En attendant jusqu\'à',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Cela ne fonctionne pas avec l\'identfifiant utilisateur 1 (Compte Système)! Veuillez créer un nouvel utilisateur!',
        'Dispatching by email To: field.' => 'Répartition par le champs \'À:\' du courriel',
        'Dispatching by selected Queue.' => 'Répartition selon la file sélectionnée',
        'No entry found!' => 'Aucun résultat n\'a été trouvé !',
        'Session has timed out. Please log in again.' => 'Le délai de votre session est dépassé, veuillez vous ré-authentifier.',
        'No Permission!' => 'Pas de permission!',
        'To: (%s) replaced with database email!' => 'Le champ \'À:\' (%s) a été remplacé avec la valeur de la base de données des des adresses de courriel !',
        'Cc: (%s) added database email!' => 'Cc: (%s) a été ajouté à la base de donnée d\'e-mail',
        '(Click here to add)' => '(Cliquez içi pour ajouter)',
        'Preview' => 'Aperçu',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Le paquet n\'a pas été correctement déployé ! Vous devez le réinstaller à nouveau !',
        'Added User "%s"' => 'Ajout de l\'utilisateur "%s"',
        'Contract' => 'Contrat',
        'Online Customer: %s' => 'Clients en ligne: %s',
        'Online Agent: %s' => 'Techniciens en ligne: %s',
        'Calendar' => 'Calendrier',
        'File' => 'Fichier',
        'Filename' => 'Nom de fichier',
        'Type' => 'Type',
        'Size' => 'Taille',
        'Upload' => 'Uploader',
        'Directory' => 'Répertoire',
        'Signed' => 'Signé',
        'Sign' => 'Signer',
        'Crypted' => 'Crypté',
        'Crypt' => 'Crypter',
        'Office' => 'Bureau',
        'Phone' => 'Téléphone',
        'Fax' => 'Fax',
        'Mobile' => 'Téléphone portable',
        'Zip' => 'Code postal',
        'City' => 'Ville',
        'Street' => '',
        'Country' => 'Pays',
        'installed' => 'installé',
        'uninstalled' => 'désinstallé',
        'Security Note: You should activate %s because application is already running!' => 'Note de Sécurité: Vous devriez activer %s parce que l\'application est déjà lancée !',
        'Unable to parse Online Repository index document!' => 'Impossible d\'analyser l\'index du dépôt en ligne',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Aucun paquet pour le Framework sélectionné dans ce dépot en ligne, mais des paquets pour d\'autres Frameworks !',
        'No Packages or no new Packages in selected Online Repository!' => 'Pas de paquets ou de nouveau paquets dans le dépot en ligne sélectionné !',
        'printed at' => 'imprimé à',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => '',
        'Hello %s,' => '',
        'This account exists.' => '',
        'New account created. Sent Login-Account to %s.' => '',
        'Please press Back and try again.' => '',
        'Sent password token to: %s' => '',
        'Sent new password to: %s' => '',
        'Invalid Token!' => '',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Fév',
        'Mar' => 'Mar',
        'Apr' => 'Avr',
        'May' => 'Mai',
        'Jun' => 'Juin',
        'Jul' => 'Juil',
        'Aug' => 'Aoû',
        'Sep' => 'Sep',
        'Oct' => 'Oct',
        'Nov' => 'Nov',
        'Dec' => 'Déc',
        'January' => 'Janvier',
        'February' => 'Février',
        'March' => 'Mars',
        'April' => 'Avril',
        'June' => 'Juin',
        'July' => 'Juillet',
        'August' => 'Août',
        'September' => 'Septembre',
        'October' => 'Octobre',
        'November' => 'Novembre',
        'December' => 'Décembre',

        # Template: AAANavBar
        'Admin-Area' => 'Zone d\'administration',
        'Agent-Area' => 'Interface du technicien',
        'Ticket-Area' => 'Tickets',
        'Logout' => 'Déconnexion',
        'Agent Preferences' => 'Préférences du technicien',
        'Preferences' => 'Préférences',
        'Agent Mailbox' => 'Boite e-mail du technicien',
        'Stats' => 'Statistiques',
        'Stats-Area' => 'Statistiques',
        'Admin' => 'Administrateur',
        'Customer Users' => 'Clients',
        'Customer Users <-> Groups' => 'Clients <-> Groupes',
        'Users <-> Groups' => 'Agent <-> Groupes',
        'Roles' => 'Rôles',
        'Roles <-> Users' => 'Rôles <-> Agents',
        'Roles <-> Groups' => 'Rôles <-> Groupes',
        'Salutations' => 'En-têtes',
        'Signatures' => 'Signatures',
        'Email Addresses' => 'Adresses électroniques',
        'Notifications' => 'Notifications',
        'Category Tree' => 'Liste des catégories',
        'Admin Notification' => 'Notification des administrateurs',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Les préférences ont bien été mises à jours !',
        'Mail Management' => 'Gestion des e-mails',
        'Frontend' => 'Interface',
        'Other Options' => 'Autres options',
        'Change Password' => 'Changer de mot de passe',
        'New password' => 'Nouveau mot de passe',
        'New password again' => 'Nouveau mot de passe (encore)',
        'Select your QueueView refresh time.' => 'Choix du délai de rafraîchissement de la vue des files',
        'Select your frontend language.' => 'Choix de la langue de l\'interface',
        'Select your frontend Charset.' => 'Choix du jeu de caractères de l\'interface',
        'Select your frontend Theme.' => 'Choix du thème de l\'interface',
        'Select your frontend QueueView.' => 'Choisissez votre interface de vue des files',
        'Spelling Dictionary' => 'Correcteur orthographique',
        'Select your default spelling dictionary.' => 'Sélectionnez votre correcteur orthographique par défaut',
        'Max. shown Tickets a page in Overview.' => 'Nombre de tickets maximum sur la page d\'aperçu des tickets',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Mise à jour du mot de passe impossible, les mots de passe diffèrent! Essayez à nouveau svp!',
        'Can\'t update password, invalid characters!' => 'Mise à jour du mot de passe impossible, caractères invalides!',
        'Can\'t update password, need min. 8 characters!' => 'Mise à jour du mot de passe impossible, Le mot de passe doit avoir au moins 8 caractères!',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Mise à jour du mot de passe impossible, Le mot de passe doit comporter 2 majuscules et 2 minuscules!',
        'Can\'t update password, need min. 1 digit!' => 'Mise à jour du mot de passe impossible, Le mot de passe doit comporter un chiffre minimum!',
        'Can\'t update password, need min. 2 characters!' => 'Mise à jour du mot de passe impossible, Le mot de passe doit comporter 2 caractères minimum!',

        # Template: AAAStats
        'Stat' => 'Stat',
        'Please fill out the required fields!' => 'Remplissez les champs obligatoires svp !',
        'Please select a file!' => 'Sélectionnez un fichier svp !',
        'Please select an object!' => 'Sélectionnez un objet svp !',
        'Please select a graph size!' => 'Sélectionnez un graphique svp !',
        'Please select one element for the X-axis!' => 'Sélectionnez un élément pour l\'axe des X svp !',
        'You have to select two or more attributes from the select field!' => 'Vous avez sélectionné deux attributs ou plus !',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Veuillez sélectionner un seul élément ou désactivez le bouton \'Fixe\' là où le champ sélectionné est en surbrillance! ',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Si vous cochez une case, vous devez indiquer des attributs du champ sélectionné',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Veuillez donner une valeur pour le champ sélectionné ou désactivez la case',
        'The selected end time is before the start time!' => 'La date de fin est anterieure à la date de début',
        'You have to select one or more attributes from the select field!' => 'Vous devez sélectionner un ou plusieurs attributs du champ sélectionné',
        'The selected Date isn\'t valid!' => 'La date sélectionnée n\'est pas valide !',
        'Please select only one or two elements via the checkbox!' => 'Sélectionnez uniquement un ou deux éléments via les cases à cocher!',
        'If you use a time scale element you can only select one element!' => 'Si vous employez un élément d\'échelle de temps vous pouvez seulement choisir un élément',
        'You have an error in your time selection!' => 'Vous avez une erreur dans le choix de la date',
        'Your reporting time interval is too small, please use a larger time scale!' => 'La période choisie pour le rapport est trop courte, veuillez indiquer une plage plus grande',
        'The selected start time is before the allowed start time!' => 'La date de début choisie est antérieure à la date de début autorisée',
        'The selected end time is after the allowed end time!' => 'La date de fin choisie esst posterieure à la date de fin autorisée',
        'The selected time period is larger than the allowed time period!' => 'La plage de temps choisie est supérieure à la date de temps autorisée',
        'Common Specification' => 'Caractéristiques Communes',
        'Xaxis' => 'Axe X',
        'Value Series' => 'Séries de valeurs',
        'Restrictions' => '',
        'graph-lines' => '',
        'graph-bars' => '',
        'graph-hbars' => '',
        'graph-points' => '',
        'graph-lines-points' => '',
        'graph-area' => '',
        'graph-pie' => '',
        'extended' => 'étendu',
        'Agent/Owner' => 'Technicien/Propriétaire',
        'Created by Agent/Owner' => 'Créé par le Technicien/Propriétaire',
        'Created Priority' => '',
        'Created State' => '',
        'Create Time' => 'Date de création',
        'CustomerUserLogin' => '',
        'Close Time' => 'Date de fermeture',

        # Template: AAATicket
        'Lock' => 'Verrouiller',
        'Unlock' => 'Déverrouiller',
        'History' => 'Historique',
        'Zoom' => 'Détails',
        'Age' => 'Âge',
        'Bounce' => 'Renvoyer',
        'Forward' => 'Transmettre',
        'From' => 'De',
        'To' => 'À',
        'Cc' => 'Copie ',
        'Bcc' => 'Copie Invisible',
        'Subject' => 'Sujet',
        'Move' => 'Déplacer',
        'Queue' => 'File',
        'Priority' => 'Priorité',
        'Priority Update' => '',
        'State' => 'État',
        'Compose' => 'Composer',
        'Pending' => 'En attente',
        'Owner' => 'Propriétaire',
        'Owner Update' => 'Mise à jour du propriétaire',
        'Responsible' => 'Responsable',
        'Responsible Update' => 'Mise à jour du responsable',
        'Sender' => 'émetteur',
        'Article' => 'Article',
        'Ticket' => 'Ticket',
        'Createtime' => 'Création du',
        'plain' => 'tel quel',
        'Email' => 'Courrier électronique',
        'email' => 'courriel',
        'Close' => 'Fermer',
        'Action' => 'Action',
        'Attachment' => 'Pièce jointe',
        'Attachments' => 'Pièces jointes',
        'This message was written in a character set other than your own.' => 'Ce message a été écrit dans un jeu de caractères différent du vôtre.',
        'If it is not displayed correctly,' => 'S\'il n\'est pas affiché correctement',
        'This is a' => 'Ceci est un',
        'to open it in a new window.' => 'L\'ouvrir dans une nouvelle fenêtre',
        'This is a HTML email. Click here to show it.' => 'Ceci est un message au format HTML ; cliquer ici pour l\'afficher.',
        'Free Fields' => 'Champs libres',
        'Merge' => 'Fusionner',
        'merged' => 'Fusionné',
        'closed successful' => 'clôture réussie',
        'closed unsuccessful' => 'clôture manquée',
        'new' => 'nouveau',
        'open' => 'ouvrir',
        'closed' => 'fermé',
        'removed' => 'supprimé',
        'pending reminder' => 'Attente du rappel',
        'pending auto' => 'En attente auto',
        'pending auto close+' => 'En attente de la fermeture automatique(+)',
        'pending auto close-' => 'En attente de la fermeture automatique(-)',
        'email-external' => 'message externe',
        'email-internal' => 'message interne',
        'note-external' => 'Note externe',
        'note-internal' => 'Note interne',
        'note-report' => 'Note rapport',
        'phone' => 'téléphone',
        'sms' => 'SMS',
        'webrequest' => 'Requête par le web',
        'lock' => 'verrouiller',
        'unlock' => 'déverrouiller',
        'very low' => 'très basse',
        'low' => 'confort de fonctionnement',
        'normal' => 'normal',
        'high' => 'important',
        'very high' => 'très haut',
        '1 very low' => '1 très bas',
        '2 low' => '2 bas',
        '3 normal' => '3 normal',
        '4 high' => '4 important',
        '5 very high' => '5 très important',
        'Ticket "%s" created!' => 'Le ticket %s a été créé !',
        'Ticket Number' => 'Numéro de ticket',
        'Ticket Object' => 'Objet ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Pas de numéro de ticket "%s"! Je ne peut pas le lier',
        'Don\'t show closed Tickets' => 'Ne pas montrer les tickets cloturés',
        'Show closed Tickets' => 'Voir les tickets cloturés',
        'New Article' => 'Nouvel Article',
        'Email-Ticket' => 'Écrire un e-mail',
        'Create new Email Ticket' => 'Créer un nouveau ticket en envoyant un e-mail',
        'Phone-Ticket' => 'Vue téléphone',
        'Search Tickets' => 'Recherche de tickets',
        'Edit Customer Users' => 'Editer clients',
        'Edit Customer Company' => '',
        'Bulk-Action' => 'Action groupée',
        'Bulk Actions on Tickets' => 'Action groupées sur les tickets',
        'Send Email and create a new Ticket' => 'Envoyer un courriel et créer un nouveau Ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Créer un ticket Email et l\'envoyer (Sortant)',
        'Create new Phone Ticket (Inbound)' => 'Créer un ticket Téléphone (Entrant)',
        'Overview of all open Tickets' => 'Vue de tous les Tickets',
        'Locked Tickets' => 'Tickets verrouillés',
        'Watched Tickets' => 'Tickets surveillés',
        'Watched' => 'Surveillé',
        'Subscribe' => 'S\'abonner',
        'Unsubscribe' => 'Se désabonner',
        'Lock it to work on it!' => 'Verrouillez le pour travailler dessus!',
        'Unlock to give it back to the queue!' => 'Déverrouillez pour qu\'il retourne dans sa file!',
        'Shows the ticket history!' => 'Voir l\'historique du ticket!',
        'Print this ticket!' => 'Imprimer ce ticket!',
        'Change the ticket priority!' => 'Changer la priorité du ticket',
        'Change the ticket free fields!' => 'Changer les champs libres du ticket',
        'Link this ticket to an other objects!' => 'Lier ce ticket à un autre objet!',
        'Change the ticket owner!' => 'Changer le propriétaire du ticket!',
        'Change the ticket customer!' => 'Changer le client du ticket!',
        'Add a note to this ticket!' => 'Ajouter une note au ticket!',
        'Merge this ticket!' => 'Fusionner ce ticket!',
        'Set this ticket to pending!' => 'Mettre le ticket en attente!',
        'Close this ticket!' => 'Fermer ce ticket!',
        'Look into a ticket!' => 'Voir le détail du ticket!',
        'Delete this ticket!' => 'Effacer ce ticket!',
        'Mark as Spam!' => 'Marquer comme Spam!',
        'My Queues' => 'Mes files',
        'Shown Tickets' => 'Tickets affichés',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Votre ticket numéro "<OTRS_TICKET>" a été fusionné avec le ticket numéro "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: le temps imparti pour la première réponse est dépassé (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: le temps imparti pour la première réponse sera dépassé dans %s!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: le temps imparti pour la révision est dépassé (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: le temps imparti pour la révision sera dépassé dans %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: le temps imparti pour fournir une solution est dépassé (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: le temps imparti pour fournir une solution sera dépassé dans %s!',
        'There are more escalated tickets!' => 'Il y a d\'autres tickets en escalade',
        'New ticket notification' => 'Notification de nouveau ticket',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Me prévenir si il y a un nouveau ticket dans une de "Mes files".',
        'Follow up notification' => 'Notification de suivi',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Me prévenir si un client envoie un suivi (follow-up) sur un ticket dont je suis propriétaire.',
        'Ticket lock timeout notification' => 'Prévenir du dépassement du délai d\'un verrou',
        'Send me a notification if a ticket is unlocked by the system.' => 'Me prévenir si un ticket est déverrouillé par le système',
        'Move notification' => 'Notification de mouvement',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Me prévenir si un ticket est déplacé dans une de "Mes files".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Votre sélection des files préférées. Vous recevrez une information par email si disponible',
        'Custom Queue' => 'File d\'attente personnalisée',
        'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
        'Screen after new ticket' => 'Écran après un nouveau ticket',
        'Select your screen after creating a new ticket.' => 'Sélectionnez l\'écran qui sera affiché après avoir créé un nouveau ticket.',
        'Closed Tickets' => 'Tickets fermés',
        'Show closed tickets.' => 'Voir les tickets fermés',
        'Max. shown Tickets a page in QueueView.' => 'Nombre de tickets maximum sur la page de la vue d\'une file',
        'CompanyTickets' => 'Tickets de l\'entreprise cliente',
        'MyTickets' => 'Mes tickets',
        'New Ticket' => 'Nouveau ticket',
        'Create new Ticket' => 'Création d\'un nouveau ticket',
        'Customer called' => 'Client appellé',
        'phone call' => 'Appel téléphonique',
        'Responses' => 'Réponses',
        'Responses <-> Queue' => 'Réponses <-> Files',
        'Auto Responses' => 'Réponses automatiques',
        'Auto Responses <-> Queue' => 'Réponses automatiques <-> Files',
        'Attachments <-> Responses' => 'Pièces jointes <-> Réponses',
        'History::Move' => 'Le ticket a été déplacé dans la file "%s" (%s) - Ancienne file: "%s" (%s).',
        'History::TypeUpdate' => 'Type positionné à %s (ID=%s).',
        'History::ServiceUpdate' => 'Service positionné à %s (ID=%s).',
        'History::SLAUpdate' => 'SLA positionné à %s (ID=%s).',
        'History::NewTicket' => 'Un nouveau ticket a été crée: [%s] created (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Un suivie du ticket [%s]. %s',
        'History::SendAutoReject' => 'Rejet automatique envoyé à "%s".',
        'History::SendAutoReply' => 'Réponse automatique envoyé à "%s".',
        'History::SendAutoFollowUp' => 'Suivie automatique envoyé à "%s".',
        'History::Forward' => 'Transféré vers "%s".',
        'History::Bounce' => 'Redirigé vers "%s".',
        'History::SendAnswer' => 'Email envoyé à "%s".',
        'History::SendAgentNotification' => '"%s"-notification envoyé à "%s".',
        'History::SendCustomerNotification' => 'Notification envoyé à "%s".',
        'History::EmailAgent' => 'Email envoyé au client.',
        'History::EmailCustomer' => 'Ajout d\'une adresse email. %s',
        'History::PhoneCallAgent' => 'Le technicien a appellé le client.',
        'History::PhoneCallCustomer' => 'Le client nous a appellé.',
        'History::AddNote' => 'Ajout d\'une note (%s)',
        'History::Lock' => 'Ticket verrouillé.',
        'History::Unlock' => 'Ticket déverrouillé.',
        'History::TimeAccounting' => 'Temps passé sur l\'action: %s . Total du temps passé pour ce ticket: %s unité(s).',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Mise à jour: %s',
        'History::PriorityUpdate' => 'Changement de priorité de "%s" (%s) pour "%s" (%s).',
        'History::OwnerUpdate' => 'Le nouveau propriétaire est "%s" (ID=%s).',
        'History::LoopProtection' => 'Protection anti-boucle! Pas d\'auto réponse envoyé à "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Mise à jour: %s',
        'History::StateUpdate' => 'Avant: "%s" Après: "%s"',
        'History::TicketFreeTextUpdate' => 'Mise à jour: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Requête du client via le web.',
        'History::TicketLinkAdd' => 'Added link to ticket "%s".',
        'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Dim',
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mer',
        'Thu' => 'Jeu',
        'Fri' => 'Ven',
        'Sat' => 'Sam',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Gestion des pièces jointes',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Gestion des réponses automatiques',
        'Response' => 'Réponse',
        'Auto Response From' => 'Réponse automatique de ',
        'Note' => 'Note',
        'Useable options' => 'Options accessibles',
        'To get the first 20 character of the subject.' => 'Pour avoir les 20 premiers caractères',
        'To get the first 5 lines of the email.' => 'Pour avoir les 5 premières lignes',
        'To get the realname of the sender (if given).' => 'Pour avoir le nom de l\'expéditeur s\'il est fourni.',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'pour avoir les attributs de l\'article (par ex. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> et <OTRS_CUSTOMER_Body>)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Propriétés des données personnelles du client',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Propriétés du propriétaire du ticket',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Propriétés du responsable du ticket',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Propriétés du client qui a demandé cette action',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Propriétés du ticket',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Propriétés de la configuration',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Gestion des services clients',
        'Search for' => 'Chercher à',
        'Add Customer Company' => 'Ajouter un client au service',
        'Add a new Customer Company.' => 'Ajouter un nouveau service',
        'List' => 'Lister',
        'This values are required.' => 'Ces valeurs sont obligatoires.',
        'This values are read only.' => 'Ces valeurs sont en lecture seule.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Gestion des clients utilisateurs',
        'Add Customer User' => 'Ajouter un client utilisateur',
        'Source' => 'Source',
        'Create' => 'Création',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Les clients utilisateurs seront invités à se connecter par la page client.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Clients <-> Gestion des groupes',
        'Change %s settings' => 'Changer les param&ecirc;tres de %s',
        'Select the user:group permissions.' => 'Sélectionnez les permissions pour l\'utilisateur:groupe.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Si rien n\'est sélectionné, il n\'y aura pas de droits dans ce groupe (Les tickets ne seront plus disponible pour l\'utilisateur).',
        'Permission' => 'Droits',
        'ro' => 'lecture seule',
        'Read only access to the ticket in this group/queue.' => 'Accès en lecture seulement aux tickets de cette file/groupe.',
        'rw' => 'lecture/écriture',
        'Full read and write access to the tickets in this group/queue.' => 'Accès complet en lecture et écriture aux tickets dans cette file/groupe.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '',
        'CustomerUser' => 'Client utilisateur',
        'Service' => 'Service',
        'Edit default services.' => '',
        'Search Result' => 'Résultat de la recherche',
        'Allocate services to CustomerUser' => '',
        'Active' => 'Actif',
        'Allocate CustomerUser to service' => '',

        # Template: AdminEmail
        'Message sent to' => 'Message envoyé à',
        'Recipents' => 'Récipients',
        'Body' => 'Corps',
        'Send' => 'Envoyer',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Automate générique',
        'Job-List' => 'Liste de tâches',
        'Last run' => 'Dernier lancement',
        'Run Now!' => 'Lancer maintenant!',
        'x' => 'x',
        'Save Job as?' => 'Sauver la tâche en tant que?',
        'Is Job Valid?' => 'Cette tâche est-elle valide?',
        'Is Job Valid' => 'Cette tâche est-elle valide',
        'Schedule' => 'Planifier',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Recherche sur le texte d\'un article (ex: "Mar*in" or "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(ex: 10*5155 or 105658*)',
        '(e. g. 234321)' => '(ex: 234321)',
        'Customer User Login' => 'Nom de connexion du client',
        '(e. g. U5150)' => '(ex: U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Technicien',
        'Ticket Lock' => 'Ticket verrouillé',
        'TicketFreeFields' => 'Champs libres du ticket',
        'Create Times' => 'Dates de création',
        'No create time settings.' => 'Pas de critère de date de création',
        'Ticket created' => 'Ticket créé',
        'Ticket created between' => 'Ticket créé entre le',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => 'Dates d\'échéance',
        'No pending time settings.' => 'pas de critère de date d\'échéance',
        'Ticket pending time reached' => 'Date d\'échéance atteinte le',
        'Ticket pending time reached between' => 'Date d\'échéance atteinte entre le',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => 'Nouvelle Priorité',
        'New Queue' => 'Nouvelle File',
        'New State' => 'Nouvel État',
        'New Agent' => 'Nouveau Technicien',
        'New Owner' => 'Nouveau Propriétaire',
        'New Customer' => 'Nouveau Client',
        'New Ticket Lock' => 'Nouveau Verrou',
        'New Type' => '',
        'New Title' => '',
        'New Type' => '',
        'New TicketFreeFields' => 'Nouveau champs libres',
        'Add Note' => 'Ajouter une note',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Cette commande sera exécuté. ARG[0] sera le numéro du ticket et ARG[1] son identifiant.',
        'Delete tickets' => 'Effacer les tickets',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Attention, ces tickets seront éffacés de la base de donnée ! Ils seront définitivement perdus !',
        'Send Notification' => 'Envoyer une notification',
        'Param 1' => 'Paramètre 1',
        'Param 2' => 'Paramètre 2',
        'Param 3' => 'Paramètre 3',
        'Param 4' => 'Paramètre 4',
        'Param 5' => 'Paramètre 5',
        'Param 6' => 'Paramètre 6',
        'Send no notifications' => 'Ne pas envoyer de notifications',
        'Yes means, send no agent and customer notifications on changes.' => 'Oui signifie : ne rien envoyer sur changement au technicien et au client.',
        'No means, send agent and customer notifications on changes.' => 'Non signifie : Envoyer un mail au technicien et au client sur changement.',
        'Save' => 'Sauver',
        '%s Tickets affected! Do you really want to use this job?' => '%s tickets affectés! Voulez vous vraiment utiliser cette commande ?',
        '"}' => '"}',

        # Template: AdminGroupForm
        'Group Management' => 'Administration des groupes',
        'Add Group' => 'Ajouter un groupe',
        'Add a new Group.' => 'Ajouter un nouveau groupe',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Créer de nouveaux groupes permettra de gérer les droits d\'accès pour les différents groupes du technicien (exemple: achats, comptabilité, support, ventes...).',
        'It\'s useful for ASP solutions.' => 'C\'est utile pour les fournisseurs d\'applications.',

        # Template: AdminLog
        'System Log' => 'Journaux du Système',
        'Time' => 'Date et heure',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => 'Hôte',
        'Trusted' => 'Vérifié',
        'Dispatching' => 'Répartition',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Tous les courriels entrants avec un compte seront répartis dans la file sélectionnée !',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Si votre compte est vérifié, les ent&ecirc;tes X-OTRS (pour les priorités,...) seront utilisés !',

        # Template: AdminNavigationBar
        'Users' => 'Utilisateurs',
        'Groups' => 'Groupes',
        'Misc' => 'Divers',

        # Template: AdminNotificationForm
        'Notification Management' => 'Gestion des notifications',
        'Notification' => 'Notification',
        'Notifications are sent to an agent or a customer.' => 'Des notifications sont envoyées à un technicien ou à un client.',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestionnaire de paquet',
        'Uninstall' => 'Déinstallation',
        'Version' => 'Version',
        'Do you really want to uninstall this package?' => 'Voulez-vous vraiment déinstaller ce paquet ?',
        'Reinstall' => 'Ré-installation',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Voulez-vous vraiment réinstaller ce paquet (Tous les changements manuels seront perdus) ?',
        'Continue' => 'Continuer',
        'Install' => 'Installation',
        'Package' => 'Paquet',
        'Online Repository' => 'Dépot en ligne',
        'Vendor' => 'Vendeur',
        'Upgrade' => 'Mise à jour',
        'Local Repository' => 'Dépôt local',
        'Status' => 'État',
        'Overview' => 'Aperçu',
        'Download' => 'Téléchargement',
        'Rebuild' => 'Re-construction',
        'ChangeLog' => 'Enregistrement des changements',
        'Date' => 'Date',
        'Filelist' => 'Liste des fichiers',
        'Download file from package!' => 'Télécharger le fichier depuis le paquet',
        'Required' => 'Obligatoire',
        'PrimaryKey' => 'Clé primaire',
        'AutoIncrement' => 'Auto incrémentation',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Enregistrement des indicateurs de performance',
        'This feature is enabled!' => 'Cette fonctionnalité est activée',
        'Just use this feature if you want to log each request.' => 'N\'employer cette fonction que si vous voulez enregitrer chaque requête',
        'Of couse this feature will take some system performance it self!' => 'Bien évidemment, cette fonction consomme des ressources système',
        'Disable it here!' => 'Désactivez là ici',
        'This feature is disabled!' => 'Cette fonctionnalité est désactivée',
        'Enable it here!' => 'Activez là ici',
        'Logfile too large!' => 'Fichier de log trop grand !',
        'Logfile too large, you need to reset it!' => 'Fichier de log trop grand, une remise à zéro est nécessaire !',
        'Range' => 'Plage',
        'Interface' => 'Interface',
        'Requests' => 'Requêtes',
        'Min Response' => 'Temps de réponse minimum',
        'Max Response' => 'Temps de réponse maximun',
        'Average Response' => 'Temps de réponse moyen',
        'Period' => '',
        'Min' => '',
        'Max' => '',
        'Average' => '',

        # Template: AdminPGPForm
        'PGP Management' => 'Gestion de PGP',
        'Result' => 'Résultat',
        'Identifier' => 'Identifiant',
        'Bit' => 'Bit',
        'Key' => 'Clé',
        'Fingerprint' => 'Empreinte',
        'Expires' => 'Expiration',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Dans ce cas vous pouvez directement éditer le trousseau configuré dans SysConfig.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestion des filtres PostMaster',
        'Filtername' => 'Nom du filtre',
        'Match' => 'Correspond',
        'Header' => 'En-tête',
        'Value' => 'Valeur',
        'Set' => 'Assigner',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'dispatcher ou filtrer les courriels entrants en se basant sur les en-têtes (X-*)! L\'utilisationd\'expression régulière est aussi possible.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Si vous voulez tester uniquement l\'email, utiliser EMAILADDRESS:info@example.com dans From, To ou Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Si vous utilisez RegExp, vous pouvez aussi tester la valeur entre () comme [***] dans \'Set\'.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Files <-> Gestion des réponses automatiques',

        # Template: AdminQueueForm
        'Queue Management' => 'Gestion des files',
        'Sub-Queue of' => 'Sous-file',
        'Unlock timeout' => 'Délai du déverrouillage',
        '0 = no unlock' => '0 = pas de verrouillage',
        'Only business hours are counted.' => '',
        'Escalation - First Response Time' => 'Rémontée du ticket - Premier temps de réponse',
        '0 = no escalation' => '0 = pas de remontée du ticket',
        'Only business hours are counted.' => '',
        'Notify by' => '',
        'Escalation - Update Time' => 'Escalade - échéance pour le suivi',
        'Notify by' => '',
        'Escalation - Solution Time' => 'Escalade - échéance pour la solution',
        'Follow up Option' => 'Option des suivis',
        'Ticket lock after a follow up' => 'Ticket verrouillé après un suivi',
        'Systemaddress' => 'Adresse du Système',
        'Customer Move Notify' => 'Notification lors d\'un changement de file',
        'Customer State Notify' => 'Notification lors d\'un changement d\'état',
        'Customer Owner Notify' => 'Notification lors d\'un changement de propriétaire',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un technicien verrouille un ticket et qu\'il/elle n\'envoie pas une réponse dans le temps imparti, le ticket sera déverrouillé automatiquement. Le ticket sera alors visible de tous les autres techniciens',
        'Escalation time' => 'Délai de remontée du ticket',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Si une réponse n\'est pas apportée au ticket dans le temps imparti, seul ce ticket sera affiché',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si un ticket est clôturé et que le client envoie une note, le ticket sera verrouillé pour l\'ancien propriétaire',
        'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expédition pour les réponses par courriel pour cette file.',
        'The salutation for email answers.' => 'La formule de politesse pour les réponses par mail',
        'The signature for email answers.' => 'La signature pour les réponses par courriel',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envoi un courriel au client lorsque le ticket change de file.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envoi un courriel au client lorsque le ticket change d\'état.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envoi un courriel au client lorsque le ticket change de propriétaire.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Réponses <-> Gestion des files',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Réponse',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Réponses <-> Gestion des pièces jointes',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Gestion des réponses',
        'A response is default text to write faster answer (with default text) to customers.' => 'Une réponse est un texte par défaut destiné à rédiger plus rapidement des réponses standards aux clients.',
        'Don\'t forget to add a new response a queue!' => 'Ne pas oublier d\'ajouter une file à une nouvelle réponse !',
        'The current ticket state is' => 'L\'état actuel du ticket est',
        'Your email address is new' => 'Votre adresse électronique est nouvelle',

        # Template: AdminRoleForm
        'Role Management' => 'Gestion des Rôles',
        'Add Role' => 'Ajouter un rôle',
        'Add a new Role.' => 'Ajoute un nouveau rôle.',
        'Create a role and put groups in it. Then add the role to the users.' => 'Crée un rôle et y ajoute des groupes. Ajoute alors le rôle aux utilisateurs.',
        'It\'s useful for a lot of users and groups.' => 'Pratique lorsqu\'on a beaucoup d\'utilisateurs et de groupes',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Rôles <-> Gestion des groupes',
        'move_into' => 'déplacer dans',
        'Permissions to move tickets into this group/queue.' => 'Permission de déplacer un ticket dans cette file/groupe.',
        'create' => 'créer',
        'Permissions to create tickets in this group/queue.' => 'Permission de créer un ticket dans cette file/groupe.',
        'owner' => 'propriétaire',
        'Permissions to change the ticket owner in this group/queue.' => 'Permission de changer le propriétaire d\'un ticket dans cette file/groupe.',
        'priority' => 'priorité',
        'Permissions to change the ticket priority in this group/queue.' => 'Permission de changer la priorité d\'un ticket dans cette file/groupe.',

        # Template: AdminRoleGroupForm
        'Role' => 'Rôles',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Rôles <-> Gestion des utilisateurs',
        'Select the role:user relations.' => 'Sélection des relations role/utilisateur',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Préfixes des messages',
        'Add Salutation' => 'Ajouter une en-tête',
        'Add a new Salutation.' => 'Ajoute une nouvelle en-tête.',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Limit' => 'Limite',
        'Go' => 'Valider',
        'Select Box Result' => 'Choisissez le résultat',

        # Template: AdminService
        'Service Management' => 'Gestion des Services',
        'Add Service' => 'Ajouter un Service',
        'Add a new Service.' => 'Ajoute un nouveau Service.',
        'Sub-Service of' => 'Sous-service de',

        # Template: AdminSession
        'Session Management' => 'Gestion des sessions',
        'Sessions' => 'Sessions',
        'Uniq' => 'Unique',
        'Kill all sessions' => 'Supprimer toutes les sessions',
        'Session' => 'Session',
        'Content' => 'Contenu',
        'kill session' => 'Supprimer la session',

        # Template: AdminSignatureForm
        'Signature Management' => 'Gestion des signatures',
        'Add Signature' => 'Ajouter une signature',
        'Add a new Signature.' => 'Ajouter une nouvelle signature.',

        # Template: AdminSLA
        'SLA Management' => 'Gestion des Accords sur la qualité de service (Service Level Agreement)',
        'Add SLA' => 'Ajouter un SLA',
        'Add a new SLA.' => 'Ajouter un nouveau SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Gestion S/MIME',
        'Add Certificate' => 'Ajouter un certificat',
        'Add Private Key' => 'Ajouter une clé privée',
        'Secret' => 'Secret',
        'Hash' => 'Hashage',
        'In this way you can directly edit the certification and private keys in file system.' => 'Dans ce cas vous pouvez directement éditer le certificat et la clé privée dans le système de fichier',

        # Template: AdminStateForm
        'State Management' => 'Gestion des états',
        'Add State' => 'Ajouter un état',
        'Add a new State.' => 'Ajoute un nouvel état.',
        'State Type' => 'Type d\'état',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Prenez garde de bien mettre à jour les états par défaut dans votre Kernel/Config.pm !',
        'See also' => 'Voir aussi',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuration Système',
        'Group selection' => 'Sélection du groupe',
        'Show' => 'Voir',
        'Download Settings' => 'Paramètres de téléchargement',
        'Download all system config changes.' => 'Télécharger tous les changements de la configuration système.',
        'Load Settings' => 'Charger les paramètres',
        'Subgroup' => 'Sous-groupe',
        'Elements' => 'Éléments',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Options de configuration',
        'Default' => 'Défaut',
        'New' => 'Nouveau',
        'New Group' => 'Nouveau groupe',
        'Group Ro' => 'Groupe lecture seule',
        'New Group Ro' => 'Nouveau groupe (lecture seule)',
        'NavBarName' => 'Nom de la barre de navigation',
        'NavBar' => 'Barre de navigation',
        'Image' => 'Image',
        'Prio' => 'Priorité',
        'Block' => 'Bloc',
        'AccessKey' => 'Accès clavier',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Gestion des adresses courriel du système',
        'Add System Address' => 'Ajouter une adresse système',
        'Add a new System Address.' => 'Ajoute une nouvelle adresse système',
        'Realname' => 'Véritable Nom',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tous les courriels avec cette adresse en destinataire (À:) seront répartis dans la file sélectionnée !',

        # Template: AdminTypeForm
        'Type Management' => 'Gestion des Types',
        'Add Type' => 'Ajouter un Type',
        'Add a new Type.' => 'Ajoute un nouveau Type.',

        # Template: AdminUserForm
        'User Management' => 'Administration des utilisateurs',
        'Add User' => 'Ajouter un utilisateur',
        'Add a new Agent.' => 'Ajoute un nouvel agent.',
        'Login as' => 'Connecté en tant que',
        'Firstname' => 'Prénom',
        'Lastname' => 'Nom',
        'User will be needed to handle tickets.' => 'Un utilisateur sera nécessaire pour gérer les tickets.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'N\'oubliez pas d\'ajouter un nouvel utilisateur à des groupes et/ou des rôles !',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Utilisateurs <-> Gestion des groupes',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Carnet d\'adresses',
        'Return to the compose screen' => 'Retourner à l\'écran de saisie',
        'Discard all changes and return to the compose screen' => 'Annuler tous les changements et retourner à l\'écran de saisie',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Information',

        # Template: AgentLinkObject
        'Link Object' => 'Lier l\'objet',
        'Select' => 'Sélectionner',
        'Results' => 'Résultat',
        'Total hits' => 'Nombre de résultats trouvés',
        'Page' => 'Page',
        'Detail' => 'Détail',

        # Template: AgentLookup
        'Lookup' => 'Consulter',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Vérificateur orthographique',
        'spelling error(s)' => 'erreurs d\'orthographe',
        'or' => 'ou',
        'Apply these changes' => 'Appliquer ces changements',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Voulez vous vraiment effacer cet objet ?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Sélectionnez les restrictions pour affiner les statistiques',
        'Fixed' => 'Fixé',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Sélectionnez un seul élément ou désactivez le bouton \'Fixé\'',
        'Absolut Period' => 'Période absolue',
        'Between' => 'Entre',
        'Relative Period' => 'Période relative',
        'The last' => 'Le dernier',
        'Finish' => 'Terminer',
        'Here you can make restrictions to your stat.' => 'Vous pouvez ici appliquer des restrictions à vos statistiques.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Si vous enlevez la coche dans la case, le technicien generant les statistiques peut changer les attributs de l\élement correspondant',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Insertion des caractéristiques communes',
        'Permissions' => 'Permissions',
        'Format' => 'Format',
        'Graphsize' => 'Taille du graphique',
        'Sum rows' => 'Ligne de somme',
        'Sum columns' => 'Colonnes de somme',
        'Cache' => 'Cache',
        'Required Field' => 'Champ requis',
        'Selection needed' => 'Sélection requise',
        'Explanation' => 'Explication',
        'In this form you can select the basic specifications.' => 'Dans ce formulaire, vous pouvez choisir les caractéristiques de base',
        'Attribute' => 'Attributs',
        'Title of the stat.' => 'Titre des statistiques',
        'Here you can insert a description of the stat.' => 'Vous pouvez insérer ici une description des statistiques.',
        'Dynamic-Object' => 'Objet dynamique',
        'Here you can select the dynamic object you want to use.' => 'Ici vous pouvez sélectionner l\'objet dynamique que vous voulez utiliser',
        '(Note: It depends on your installation how many dynamic objects you can use)' => 'Note: Le nombre d\'objets dynamiques que vous pouvez utiliser dépend de votre configuration technique',
        'Static-File' => 'Fichier statique',
        'For very complex stats it is possible to include a hardcoded file.' => 'Pour des statistiques très complexes, il est possible d\'inclure un fichier déjà encodé',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Si un nouveau fichier encodé est disponible, cet attribut sera visible et vous pourrez le sélectionner',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Permissions. Vous pouvez sélectionner un ou plusieurs groupes pour autoriser la consultation des statistiques pour différents techniciens.',
        'Multiple selection of the output format.' => 'Selection multiple du format de sortie',
        'If you use a graph as output format you have to select at least one graph size.' => 'Si vous choisissez Graphe comme format de sortie, vous devez choisir la taille',
        'If you need the sum of every row select yes' => 'Si vous avez besoin de la somme pour chaque ligne, choisissez Oui',
        'If you need the sum of every column select yes.' => 'Si vous avez besoin de la somme pour chaque colonne, choisissez Oui',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'La plus grande part des stats peuvent être mise en cache. Cela accèlere leur présentation',
        '(Note: Useful for big databases and low performance server)' => 'Note: utile pour les bases de données volumineuses et les serveurs peu performants',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Il est impossible de produire des statistiques avec des données invalides.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Ceci est utilie si vous voulez que personne n\'obtienne les statistiques ou si elles ne sont pas encore configurées',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Sélectionnez les éléments de la série de données',
        'Scale' => 'Échelle',
        'minimal' => 'minimale',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'SVP, rappelez vous que la plage pour la série de données doit être plus grande que l\'echelle de l\'axe des X (ex. axe des X => Mois, Série => Année',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Sélectionnez l\'élément qui sera utilisé pour l\'axe des X',
        'maximal period' => 'période minimale',
        'minimal scale' => 'Échelle minimale',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => 'Importer',
        'File is not a Stats config' => 'Ce n\'est pas un fichier de configuration de statistiques',
        'No File selected' => 'Aucun fichier sélectionné',

        # Template: AgentStatsOverview
        'Object' => 'Objet',

        # Template: AgentStatsPrint
        'Print' => 'Imprimer',
        'No Element selected.' => 'Aucun élément sélectionné.',

        # Template: AgentStatsView
        'Export Config' => 'Exporter la configuration',
        'Information about the Stat' => 'Informations à propos de la statistique',
        'Exchange Axis' => 'Échangez les axes',
        'Configurable params of static stat' => 'Paramètres modifiables des statistiques',
        'No element selected.' => 'Aucun élément sélectionné.',
        'maximal period from' => 'Période maximale de',
        'to' => 'vers',
        'Start' => 'Démarrer',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Renvoyer le ticket',
        'Ticket locked!' => 'Ticket verrouillé !',
        'Ticket unlock!' => 'Rendre le ticket !',
        'Bounce to' => 'Renvoyer à',
        'Next ticket state' => 'Prochain état du ticket',
        'Inform sender' => 'Informer l\'emetteur',
        'Send mail!' => 'Envoyer le courriel !',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket en action groupée',
        'Spell Check' => 'Vérification orthographique',
        'Note type' => 'Type de note',
        'Unlock Tickets' => 'Déverrouiller les Tickets',

        # Template: AgentTicketClose
        'Close ticket' => 'Ticket clos',
        'Previous Owner' => 'Propriétaire Précédent',
        'Inform Agent' => 'Informer l\'agent',
        'Optional' => 'Optionnel',
        'Inform involved Agents' => 'Informer les agents impliqués',
        'Attach' => 'Attacher',
        'Next state' => 'État suivant',
        'Pending date' => 'Délais d\'attente',
        'Time units' => 'Unité de temps',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Rédiger une réponse pour le ticket',
        'Pending Date' => 'En attendant la date',
        'for pending* states' => 'pour tous les états de mise en attente',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Changer le client du ticket',
        'Set customer user and customer id of a ticket' => 'Assigner un utilisateur client et un identifiant client pour le ticket.',
        'Customer User' => 'Client Utilisateur',
        'Search Customer' => 'Recherche de client',
        'Customer Data' => 'Données client',
        'Customer history' => 'Historique du client',
        'All customer tickets.' => 'Tous les tickets du client',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Note',

        # Template: AgentTicketEmail
        'Compose Email' => 'Écrire un courriel',
        'new ticket' => 'nouveau ticket',
        'Refresh' => 'Rafraîchir',
        'Clear To' => 'Effacer la zone de saisie "De:"',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'vers le haut',
        'down' => 'vers le bas',
        'Escalation' => '',
        'Locked' => 'Verrouillé',

        # Template: AgentTicketForward
        'Article type' => 'Type d\'article',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Changer le texte libre du ticket',

        # Template: AgentTicketHistory
        'History of' => 'Historique de',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Boite aux lettres',
        'Tickets' => 'Ticket',
        'of' => 'de',
        'Filter' => 'Filtre',
        'New messages' => 'Nouveaux messages',
        'Reminder' => 'Rappel',
        'Sort by' => 'Trier par',
        'Order' => 'Ordre',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Fusion de Ticket',
        'Merge to' => 'Fusionner avec',

        # Template: AgentTicketMove
        'Move Ticket' => 'Changer la file du ticket',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Ajouter une note au ticket',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Changer le propriétaire du ticket',

        # Template: AgentTicketPending
        'Set Pending' => 'Définir la mise en attente',

        # Template: AgentTicketPhone
        'Phone call' => 'Appel téléphonique',
        'Clear From' => 'Vider le formulaire',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Tel quel',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Information du Ticket',
        'Accounted time' => 'Temp passé',
        'First Response Time' => 'Temps pour fournir la première réponse (prise en compte)',
        'Update Time' => 'Temps pour fournir un point d\'avancement',
        'Solution Time' => 'Temps pour fournir la réponse',
        'Linked-Object' => 'Objet lié',
        'Parent-Object' => 'Objet Parent',
        'Child-Object' => 'Objet Enfant',
        'by' => 'par',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Modification de la priorité du ticket',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Tickets affichés',
        'Tickets available' => 'Tickets disponibles',
        'All tickets' => 'tous les tickets',
        'Queues' => 'Files',
        'Ticket escalation!' => 'Remontée du ticket !',

        # Template: AgentTicketQueueTicketView
        'Service Time' => '',
        'Your own Ticket' => 'Votre propre ticket',
        'Compose Follow up' => 'Fermer le suivi',
        'Compose Answer' => 'Rédiger une réponse',
        'Contact customer' => 'Contacter le client',
        'Change queue' => 'Changer de file',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Changer le responsable du ticket',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Recherche de ticket',
        'Profile' => 'Profil',
        'Search-Template' => 'Profil de recherche',
        'TicketFreeText' => 'Texte Libre du Ticket',
        'Created in Queue' => 'Créé dans la file',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'Format du résultat',
        'Save Search-Profile as Template?' => 'Sauver le profil de recherche ?',
        'Yes, save it with name' => 'Oui, le sauver avec le nom',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Changer les options de recherche',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Vue de l\'état du ticket',
        'Open Tickets' => 'Tickets ouverts',

        # Template: AgentTicketZoom
        'Expand View' => '',
        'Collapse View' => '',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Trace du retour d\'erreur',

        # Template: CustomerFooter
        'Powered by' => 'Fonction assurée par',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'S\'authentifier',
        'Lost your password?' => 'Mot de passe oublié ?',
        'Request new password' => 'Demande de nouveau mot de passe',
        'Create Account' => 'Créer un compte',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Bienvenue %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Fois',
        'No time settings.' => 'Pas de paramètre de temps',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Cliquer ici pour signaler une anomalie!',

        # Template: Footer
        'Top of Page' => 'Haut de page',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Installeur Web',
        'Welcome to %s' => 'Bienvenue dans %s',
        'Accept license' => 'Accepter la licence',
        'Don\'t accept license' => 'Ne pas accepter la licence',
        'Admin-User' => 'Administrateur',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Mot de passe de l\'administrateur',
        'Database-User' => 'Nom de l\'utilisateur de la base de donnée',
        'default \'hot\'' => 'hôte par défaut',
        'DB connect host' => 'Nom d\'hôte de la base de donnée',
        'Database' => 'Base de donnée',
        'Default Charset' => 'Charset par défaut',
        'utf8' => '',
        'false' => 'faux',
        'SystemID' => 'ID Système',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(L\'identité du système. Chaque numéro de ticket et chaque id de session http commence avec ce nombre)',
        'System FQDN' => 'Nom de Domaine complet du système',
        '(Full qualified domain name of your system)' => '(Nom de domaine complet de votre machine)',
        'AdminEmail' => 'Courriel de l\'administrateur.',
        '(Email of the system admin)' => '(Adresse de l\'administrateur système)',
        'Organization' => 'Société',
        'Log' => 'Log',
        'LogModule' => 'Module de log',
        '(Used log backend)' => '(Backend de log utilisé)',
        'Logfile' => 'fichier de log',
        '(Logfile just needed for File-LogModule!)' => '(fichier de log nécessaire pour le Module File-Log !)',
        'Webfrontend' => 'Frontal web',
        'Use utf-8 it your database supports it!' => 'Utilisez UTF-8 si votre base de donnée le supporte !',
        'Default Language' => 'Langage par défaut ',
        '(Used default language)' => '(Langage par défaut utilisé)',
        'CheckMXRecord' => 'Vérifier les enregistrements MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Verifie les enregistrements MX des adresses électroniques utilisées lors de la rédaction d\'une réponse. N\'utilisez pas la "Vérification des enregistrements MX" si votre serveur OTRS est derrière une ligne modem $!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Pour pouvoir utiliser OTRS, vous devez entrer les commandes suivantes dans votre terminal en tant que root.',
        'Restart your webserver' => 'Redémarrer votre serveur web',
        'After doing so your OTRS is up and running.' => 'Après avoir fait ceci votre OTRS est en service',
        'Start page' => 'Page de démarrage',
        'Your OTRS Team' => 'Votre Équipe OTRS',

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Pas d\'autorisation',

        # Template: Notify
        'Important' => 'Important',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'Imprimé par :',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Page de test d\'OTRS',
        'Counter' => 'Compteur',

        # Template: Warning
        # Misc
        'Edit Article' => 'Éditer l\'article',
        'Create Database' => 'Créer la base de données',
        'DB Host' => 'Nom d\'hôte de la base',
        'Change roles <-> groups settings' => 'Changer les rôles <-> paramètres des groupes',
        'Ticket Number Generator' => 'Générateur de numéro pour les tickets',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identifiant des tickets. Certaines personnes veulent le configurer avec par ex: \'Ticket#\', \'Appel#\' ou \'MonTicket#\')',
        'Create new Phone Ticket' => 'Saisie d\'une demande téléphonique',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Dans ce cas vous pouvez directement éditer le trousseau de clé dans Kernel/Config.pm',
        'Symptom' => 'Symptôme',
        'U' => 'A-Z',
        'A message should have a To: recipient!' => 'Un message doit avoir un destinataire (À:)!',
        'Site' => 'Site',
        'Customer history search (e. g. "ID342425").' => 'Recherche dans l\'historique client (ex: "ID342425")',
        'for agent firstname' => 'pour le prénom du technicien',
        'Close!' => 'Clôture!',
        'The message being composed has been closed.  Exiting.' => 'Le message en cours de rédaction a été clôturé. Sortie.',
        'A web calendar' => 'Un calendrier Web',
        'to get the realname of the sender (if given)' => 'pour avoir le nom réel de l\'utilisateur (s\il est donné)',
        'FAQ Search Result' => 'Résultat de la recherche dans la FAQ',
        'OTRS DB Name' => 'Nom de la base OTRS',
        'Notification (Customer)' => 'Notification (Client)',
        'FAQ Category' => 'Catégorie dans la FAQ',
        'Select Source (for add)' => 'Sélectionnez une source (pour ajout)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Options des données du ticket (ex: &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'New FAQ Article' => '(FAQ) Nouvel article',
        'Days' => 'Jours',
        'Queue ID' => 'Identifiant de la File',
        'Home' => 'Accueil',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Options de configuration (ex: <OTRS_CONFIG_HttpType>)',
        'System History' => 'Historique du système',
        'FAQ System History' => 'Historique système de la FAQ',
        'customer realname' => 'nom réel du client',
        'Pending messages' => 'Message en attente',
        'Modules' => 'Modules',
        'for agent login' => 'pour le nom de connexion (login) du technicien',
        'Keyword' => 'Mot clé',
        'Close type' => 'Type de clôture',
        'FAQ-Article' => '(FAQ) Article',
        'DB Admin User' => 'nom de connexion de l\'administrateur base de donnée',
        'for agent user id' => 'pour l\'identifiant du technicien',
        'sort upward' => 'Tri croissant',
        'Change user <-> group settings' => 'Modifier les paramètres utilisateurs <-> groupes',
        'FAQ-Area' => 'Foire Aux Questions',
        'Problem' => 'Problème',
        'next step' => 'étape suivante',
        'Customer history search' => 'Recherche dans l\'historique client',
        'Admin-Email' => 'Email de l\'administrateur',
        'Create new database' => 'Créer une nouvelle base de données',
        'A message must be spell checked!' => 'L\'orthographe d\'un message doit être vérifiée!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Votre message concernant le ticket numéro "<OTRS_TICKET> est réémis à "<OTRS_BOUNCE_TO>". Contactez cette adresse pour de plus amples renseignements',
        'FAQ Language' => 'Langue dans la FAQ',
        'ArticleID' => 'Identifiant de l\'Article',
        'A message should have a body!' => 'Un message doit avoir un corps !',
        'All Agents' => 'Tous les techniciens',
        'Keywords' => 'Mots clés',
        'No * possible!' => 'Pas de * possible !',
        'Options ' => 'Options',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Options ',
        'Message for new Owner' => 'Message pour le nouveau propriétaire',
        'to get the first 5 lines of the email' => 'pour avoir les 5 premières lignes du mail',
        'OTRS DB Password' => 'Mot de passe de la base OTRS',
        'Last update' => 'Dernière mise à jour',
        'to get the first 20 character of the subject' => 'pour avoir les 20 premiers caractères du sujet ',
        'Select the customeruser:service relations.' => '',
        'DB Admin Password' => 'Mot de passe administrateur base de données',
        'Advisory' => 'Avertissement',
        'Drop Database' => 'Effacer la base de données',
        'FileManager' => 'Gestionnaire de fichiers',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Options concernant les données du client actuel (ex: <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Type d\'attente',
        'Comment (internal)' => 'Commentaire interne',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Options du propriétaire du ticket (ex: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'This window must be called from compose window' => 'Cette fenêtre doit être appelée de la fenêtre depuis la fenêtre de rédaction',
        'FAQ-Search' => '(FAQ) Rechercher',
        'You need min. one selected Ticket!' => 'Vous devez nommer au moins un Ticket!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Options des données du ticket (ex: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Format numérique utilisé pour les tickets)',
        'Fulltext' => 'Texte Complet',
        'OTRS DB connect host' => 'Hôte de la base OTRS',
        ' (work units)' => ' Unité de travail',
        'All Customer variables like defined in config option CustomerUser.' => 'Toutes les variables client tels que définies dans les options "Client utilisateur"',
        'accept license' => 'Accepter la licence',
        'for agent lastname' => 'pour le nom du technicien',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Options concernant l\'utilisateur actuel ayant effectué cet action (ex: <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Message de rappel',
        'Change users <-> roles settings' => 'Changement d\'utilisateur <-> parramèttres des rôles',
        'A message should have a subject!' => 'Un message doit avoir un sujet !',
        'TicketZoom' => 'Vue en détails',
        'Don\'t forget to add a new user to groups!' => 'Ne pas oublier d\'ajouter un nouvel utilisateur aux groupes !',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Il faut une adresse courriel (ex&nbsp;: client@exemple.fr)&nbsp;!',
        'CreateTicket' => 'Créer Ticket',
        'You need to account time!' => 'Vous devez comptabiliser le temps;!',
        'System Settings' => 'Paramètres Système',
        'WebWatcher' => 'WebWatcher',
        'Hours' => 'Heures',
        'Finished' => 'Fini',
        'Account Type' => 'Type de compte',
        'Split' => 'Scinder',
        'D' => 'Z-A',
        'System Status' => 'État du système',
        'All messages' => 'Tous les messages',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Options des données du ticket (ex: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'A article should have a title!' => 'Un article doit avoir un titre',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Options de configuration (ex: &lt;OTRS_CONFIG_HttpType&gt;)',
        'Event' => 'Évènement',
        'FAQ Overview' => 'Vue d\'ensemble de la FAQ',
        'don\'t accept license' => 'Ne pas accepter la licence',
        'A web mail client' => 'Un logiciel de messagerie via le web',
        'FAQ-State' => 'État FAQ',
        'WebMail' => 'Webmail',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Options des données du ticket (ex:  <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Options du propriétaire d\'un ticket (ex: <OTRS_OWNER_UserFirstname>)',
        'FAQ Search' => 'Chercher dans la FAQ',
        'Name is required!' => 'Un nom est requis!',
        'DB Type' => 'Type de SGBD',
        'Termin1' => 'Termin1',
        'kill all sessions' => 'Terminer toutes les sessions',
        'to get the from line of the email' => 'pour avoir les lignes \'De\' du courriel',
        'Solution' => 'Solution',
        'QueueView' => 'Vue file',
        'Select Box' => 'Requête SQL libre.',
        'Welcome to OTRS' => 'Bienvenue dans OTRS',
        'modified' => 'modifié',
        'Escalation in' => 'Remontée dans',
        'Delete old database' => 'Effacer l\'ancienne base de données',
        'sort downward' => 'Tri décroissant',
        'You need to use a ticket number!' => 'Vous devez utiliser un numéro de ticket!',
        'A web file manager' => 'Un gestionnaire de fichier via le web',
        'Have a lot of fun!' => 'Amusez vous bien !',
        'send' => 'envoyer',
        'Note Text' => 'Note',
        'POP3 Account Management' => 'Gestion du compte POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Options des données du client actuel (ex:  &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Gestion des états du système',
        'OTRS DB User' => 'Utilisateur de la base OTRS',
        'PhoneView' => 'Vue téléphone',
        'maximal period form' => '',
        'Verion' => 'Version',
        'TicketID' => 'Identifiant du Ticket',
        'FAQ History' => 'Historique de la FAQ',
        'Modified' => 'Modifié',
        'Ticket selected for bulk action!' => 'Ticket sélectionné pour une action groupée!',

        'Link Object: %s' => '',
        'Unlink Object: %s' => '',
        'Already linked as' => '',
    };
    # $$STOP$$
    return;
}

1;
