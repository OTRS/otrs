# --
# Kernel/Language/fr_CA.pm - provides French language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# Copyright (C) 2004 Igor Genibel <igor.genibel at eds-opensource.com>
# Copyright (C) 2007 Remi Seguy <remi.seguy at laposte.net>
# Copyright (C) 2007 Massimiliano Franco <max-lists at ycom.ch>
# Copyright (C) 2004-2008 Yann Richard <ze at nbox.org>
# Copyright (C) 2009-2010 Olivier Sallou <olivier.sallou at irisa.fr>
# Copyright (C) 2013 Evans Bernier <ebernier@libergia.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_CA;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Oui',
        'No' => 'Non',
        'yes' => 'oui',
        'no' => 'non',
        'Off' => 'Désactivée',
        'off' => 'désactivée',
        'On' => 'Activée',
        'on' => 'activé',
        'top' => 'haut',
        'end' => 'fin',
        'Done' => 'Terminé',
        'Cancel' => 'Annuler',
        'Reset' => 'Réinitialiser',
        'more than ... ago' => '',
        'in more than ...' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Today' => 'Aujourd\'hui',
        'Tomorrow' => 'Demain',
        'Next week' => 'La semaine prochaine',
        'day' => 'jour',
        'days' => 'jours',
        'day(s)' => 'jour(s)',
        'd' => 'j',
        'hour' => 'heure',
        'hours' => 'heures',
        'hour(s)' => 'heure(s)',
        'Hours' => 'Heures',
        'h' => 'h',
        'minute' => 'minute',
        'minutes' => 'minutes',
        'minute(s)' => 'minute(s)',
        'Minutes' => 'Minutes',
        'm' => 'm',
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
        's' => 's',
        'Time unit' => '',
        'wrote' => 'a écrit',
        'Message' => 'Message',
        'Error' => 'Erreur',
        'Bug Report' => 'Relevé des bogues',
        'Attention' => 'Attention ',
        'Warning' => 'Avertissement',
        'Module' => 'Module ',
        'Modulefile' => 'Fichier de module',
        'Subfunction' => 'sous-fonction',
        'Line' => 'Ligne',
        'Setting' => 'Paramètre',
        'Settings' => 'Paramètres',
        'Example' => 'Exemple ',
        'Examples' => 'Exemples',
        'valid' => 'admissible',
        'Valid' => 'Admissibilité ',
        'invalid' => 'non admissible',
        'Invalid' => 'Non admissible',
        '* invalid' => '* non admissible',
        'invalid-temporarily' => 'temporairement non admissible',
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
        '-none-' => 'aucune',
        'none' => 'néant',
        'none!' => 'aucun',
        'none - answered' => 'aucun - réponse faite',
        'please do not edit!' => 'Ne pas modifier.',
        'Need Action' => 'Requiert une action',
        'AddLink' => 'Ajouter un lien',
        'Link' => 'Lier ',
        'Unlink' => 'Délier',
        'Linked' => 'Lié',
        'Link (Normal)' => 'Lien (Normal)',
        'Link (Parent)' => 'Lien (Parent)',
        'Link (Child)' => 'Lien (Enfant)',
        'Normal' => 'Normal',
        'Parent' => 'Parent',
        'Child' => 'Enfant',
        'Hit' => 'Occurence',
        'Hits' => 'Occurences',
        'Text' => 'Texte ',
        'Standard' => 'Standard',
        'Lite' => 'Allégée',
        'User' => 'Utilisateur',
        'Username' => 'Nom d\'utilisateur ',
        'Language' => 'Langue ',
        'Languages' => 'Langues',
        'Password' => 'Mot de passe ',
        'Preferences' => 'Préférences',
        'Salutation' => 'Formule de salutation ',
        'Salutations' => 'Formules de salutation',
        'Signature' => 'Signature ',
        'Signatures' => 'Signatures',
        'Customer' => 'Client ',
        'CustomerID' => 'Numéro de client ',
        'CustomerIDs' => 'Numéro de client (Groupe)',
        'customer' => 'client',
        'agent' => 'agent',
        'system' => 'système',
        'Customer Info' => 'Renseignements sur le client',
        'Customer Information' => 'Renseignements sur le client',
        'Customer Companies' => 'Entreprises clientes',
        'Company' => 'Entreprise ',
        'go!' => 'c\'est parti!',
        'go' => 'aller',
        'All' => 'Tout',
        'all' => 'tout',
        'Sorry' => 'Désolé',
        'update!' => 'Mettre à jour.',
        'update' => 'mettre à jour',
        'Update' => 'Mettre à jour',
        'Updated!' => 'Mise à jour effectuée.',
        'submit!' => 'Soumettre.',
        'submit' => 'soumettre',
        'Submit' => 'Soumettre',
        'change!' => 'Modifier.',
        'Change' => 'Modifier',
        'change' => 'modifier',
        'click here' => 'Cliquer ici',
        'Comment' => 'Commentaire ',
        'Invalid Option!' => 'Option invalide.',
        'Invalid time!' => 'Heure ou durée invalide.',
        'Invalid date!' => 'Date invalide.',
        'Name' => 'Nom ',
        'Group' => 'Groupe ajouté ',
        'Description' => 'Description ',
        'description' => 'description',
        'Theme' => 'Thème ',
        'Created' => 'Création le ',
        'Created by' => 'Créée par ',
        'Changed' => 'Modification le ',
        'Changed by' => 'Changement effectué par ',
        'Search' => 'Recherche',
        'and' => 'et le',
        'between' => 'entre',
        'before/after' => '',
        'Fulltext Search' => 'Recherche plein texte',
        'Data' => 'Données',
        'Options' => 'Options ',
        'Title' => 'Titre ',
        'Item' => 'Élément',
        'Delete' => 'Supprimer',
        'Edit' => 'Éditer ',
        'View' => 'Vue ',
        'Number' => 'Nombre',
        'System' => 'Système',
        'Contact' => 'Contact',
        'Contacts' => 'Contacts',
        'Export' => 'Exporter',
        'Up' => 'Chronologique croissant',
        'Down' => 'Chronologique décroissant',
        'Add' => 'Ajouter ',
        'Added!' => 'Ajout effectué.',
        'Category' => 'Catégorie',
        'Viewer' => 'Visualiseur',
        'Expand' => 'Développer',
        'Small' => 'Petit (S)',
        'Medium' => 'Moyen (M)',
        'Large' => 'Grand (L)',
        'Date picker' => 'Selection de date',
        'Show Tree Selection' => '',
        'The field content is too long!' => '',
        'Maximum size is %s characters.' => '',
        'This field is required or' => '',
        'New message' => 'Nouveau message',
        'New message!' => 'Nouveau message ',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Veuillez répondre à cette demande ou à ces demandes pour revenir à une vue normale de la file.',
        'You have %s new message(s)!' => 'Vous avez %s nouveau(x) message(s).',
        'You have %s reminder ticket(s)!' => 'Vous avez %s rappel(s) concernant vos demandes.',
        'The recommended charset for your language is %s!' => 'Le jeu de caractères correspondant à votre langue est %s.',
        'Change your password.' => 'Modifier votre mot de passe.',
        'Please activate %s first!' => 'Veuillez d\'abord activer le %s.',
        'No suggestions' => 'Pas de suggestion',
        'Word' => 'Mot',
        'Ignore' => 'Ignorer',
        'replace with' => 'remplacer par',
        'There is no account with that login name.' => 'Le nom d\'utilisateur ne correspond à aucun compte.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'La session ne peut être ouverte. Le nom d\'utilisateur ou le mot de passe est incorrect.',
        'There is no acount with that user name.' => 'Le nom d\'utilisateur ne correspond à aucun compte.',
        'Please contact your administrator' => 'Veuillez contacter votre administrateur',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'L\'authentification est réussie mais aucun enregistrement client n\'a été trouvé dans la base OTRS. Veuillez en informer votre administrateur.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '',
        'Logout' => 'Déconnexion',
        'Logout successful. Thank you for using %s!' => 'Déconnexion réussie. Le groupe %s vous remercie!',
        'Feature not active!' => 'Cette fonctionnalité n\'est pas activée. ',
        'Agent updated!' => 'La mise à jour des renseignements de l\'agent a été effectuée.',
        'Database Selection' => '',
        'Create Database' => 'Créer la base de données',
        'System Settings' => 'Paramètres du système',
        'Mail Configuration' => 'Configuration des courriels',
        'Finished' => 'Terminé',
        'Install OTRS' => 'Installer OTRS',
        'Intro' => 'Introduction',
        'License' => 'Licence ',
        'Database' => 'Base de données',
        'Configure Mail' => 'Configuration de la messagerie',
        'Database deleted.' => 'Base de données effacée.',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database already contains data - it should be empty!' => '',
        'Login is needed!' => 'Authentification requise !',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '',
        'Password is needed!' => 'Le mot de passe est requis.',
        'Take this Customer' => 'Choisir ce client',
        'Take this User' => 'Choisir cet utilisateur',
        'possible' => 'Réouverture de la demande',
        'reject' => 'Rejeter l\'option',
        'reverse' => 'inverse',
        'Facility' => 'service',
        'Time Zone' => 'Fuseau horaire',
        'Pending till' => 'En attente jusqu\'au ',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Ne travaillez pas dans OTRS avec votre compte de superutilisateur! Créez plutôt de nouveaux agents et travaillez à partir de ces comptes.',
        'Dispatching by email To: field.' => 'Classement des courriels selon le champ « À : »',
        'Dispatching by selected Queue.' => 'Classement selon la file sélectionnée',
        'No entry found!' => 'Aucun résultat n\'a été trouvé !',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Le délai de votre session est dépassé, veuillez vous ré-authentifier.',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Pas de permission.',
        '(Click here to add)' => '(Cliquez ici pour ajouter)',
        'Preview' => 'Grand (L)',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Le paquet n\'a pas été installé correctement. Veuillez l\'installer de nouveau.',
        '%s is not writable!' => '%s n\'est pas accessible en écriture',
        'Cannot create %s!' => 'Impossible de créer %s',
        'Check to activate this date' => 'Cochez pour activer cette date.',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Votre indicateur d\'absence est activé, souhaitez-vous le désactivé?',
        'News about OTRS releases!' => 'Nouvelles au sujet des versions de OTRS.',
        'Customer %s added' => 'Client %s ajouté',
        'Role added!' => 'Rôle ajouté.',
        'Role updated!' => 'Rôle mis à jour.',
        'Attachment added!' => 'Pièce jointe ajoutée.',
        'Attachment updated!' => 'Pièce jointe mise à jour.',
        'Response added!' => 'Réponse ajoutée.',
        'Response updated!' => 'Réponse mise à jour.',
        'Group updated!' => 'Groupe ajouté.',
        'Queue added!' => 'File ajoutée.',
        'Queue updated!' => 'File mise à jour.',
        'State added!' => 'État ajouté.',
        'State updated!' => 'État mis à jour.',
        'Type added!' => 'Type ajouté.',
        'Type updated!' => 'Type mis à jour.',
        'Customer updated!' => 'Client mis à jour.',
        'Customer company added!' => 'Entreprise cliente ajoutée.',
        'Customer company updated!' => 'Entreprise cliente mise à jour.',
        'Note: Company is invalid!' => '',
        'Mail account added!' => 'Compte de courrier électronique ajouté.',
        'Mail account updated!' => 'Compte de courrier électronique mis à jour.',
        'System e-mail address added!' => 'adresse électronique du système ajoutée.',
        'System e-mail address updated!' => 'adresse électronique du système mise à jour.',
        'Contract' => 'Contrat',
        'Online Customer: %s' => 'Nombre de clients en ligne : %s',
        'Online Agent: %s' => 'Nombre d\'opérateurs en ligne : %s',
        'Calendar' => 'Calendrier ',
        'File' => 'Fichier ',
        'Filename' => 'Nom de fichier',
        'Type' => 'Type ',
        'Size' => 'Taille ',
        'Upload' => 'Télécharger',
        'Directory' => 'Répertoire',
        'Signed' => 'Signé',
        'Sign' => 'Signer',
        'Crypted' => 'Crypté',
        'Crypt' => 'Crypter',
        'PGP' => 'PGP',
        'PGP Key' => 'Clé PGP',
        'PGP Keys' => 'Clés PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Certificat S/MIME',
        'S/MIME Certificates' => 'Certificats S/MIME',
        'Office' => 'Bureau',
        'Phone' => 'Téléphone ',
        'Fax' => 'Télécopieur ',
        'Mobile' => 'Téléphone mobile ',
        'Zip' => 'Code postal ',
        'City' => 'Ville ',
        'Street' => 'Rue ',
        'Country' => 'Pays ',
        'Location' => 'Localisation',
        'installed' => 'installé',
        'uninstalled' => 'désinstallé',
        'Security Note: You should activate %s because application is already running!' =>
            'Note de sécurité : Veuillez activer %s, car l\'application est déjà lancée.',
        'Unable to parse repository index document.' => 'Le système est incapable d\'analyser l\'index du répertoire.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Aucun paquet n\'a été trouvé dans le répertoire pour votre version du cadre d\'applications; les paquets trouvés concernent d\'autres versions.',
        'No packages, or no new packages, found in selected repository.' =>
            'Aucun paquet, ou nouveau paquet, n\'a été trouvé dans le répertoire selectionné.',
        'Edit the system configuration settings.' => 'Modifier la configuration du système.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '',
        'printed at' => 'imprimé à',
        'Loading...' => 'Chargement...',
        'Dear Mr. %s,' => 'Cher M. %s,',
        'Dear Mrs. %s,' => 'Cher Mme %s,',
        'Dear %s,' => 'Cher %s,',
        'Hello %s,' => 'Bonjour %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Le nouveau compte a été créé. Les informations relatives à l\'ouverture de session ont été envoyées à %s. Veuillez vérifier vos courriels.',
        'Please press Back and try again.' => 'Veuillez revenir à la page précédente et rééssayez.',
        'Sent password reset instructions. Please check your email.' => 'Les instructions relatives à la réinitialisation du mot de passe ont été envoyées. Veuillez vérifier vos courriels.',
        'Sent new password to %s. Please check your email.' => 'Le nouveau mot de passe a été envoyé à %s. Veuillez vérifier vos courriels.',
        'Upcoming Events' => 'Évènements à venir',
        'Event' => 'Évènement ',
        'Events' => 'Évènements',
        'Invalid Token!' => 'Jeton invalide.',
        'more' => 'plus',
        'Collapse' => 'Réduire',
        'Shown' => 'Affiché(s)',
        'Shown customer users' => '',
        'News' => 'Nouvelles',
        'Product News' => 'Nouvelles du produit',
        'OTRS News' => 'Nouvelles de OTRS',
        '7 Day Stats' => 'Statistiques sur 7 jours',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Mark' => '',
        'Unmark' => '',
        'Bold' => 'Gras',
        'Italic' => 'Italique',
        'Underline' => 'Souligné',
        'Font Color' => 'Couleur de police',
        'Background Color' => 'Couleur de fond',
        'Remove Formatting' => 'Supprimer le formatage',
        'Show/Hide Hidden Elements' => 'Montrer ou cacher les éléments cachés',
        'Align Left' => 'Aligner à gauche',
        'Align Center' => 'Aligner au centre',
        'Align Right' => 'Aligner à droite',
        'Justify' => 'Justifier',
        'Header' => 'En-tête',
        'Indent' => 'Ajouter retrait',
        'Outdent' => 'Supprimer retrait',
        'Create an Unordered List' => 'Créer une liste non ordonnée',
        'Create an Ordered List' => 'Créer une liste ordonnée',
        'HTML Link' => 'Lien HTML',
        'Insert Image' => 'Insérer image',
        'CTRL' => 'Contrôle',
        'SHIFT' => 'Majuscule',
        'Undo' => 'Annuler',
        'Redo' => 'Refaire',
        'Scheduler process is registered but might not be running.' => 'Le processus d\'ordonnancement est autorisé, mais n\'est peut-être pas en fonction.',
        'Scheduler is not running.' => 'L\'ordonnanceur n\'est pas en fonction.',
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Problems processing server result. Please try again later.' => '',
        'Username and password do not match. Please try again.' => '',
        'The selected process is invalid!' => '',
        'Upgrade to %s now!' => '',
        '%s Go to the upgrade center %s' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '',
        'Your system was successfully upgraded to %s.' => '',
        'There was a problem during the upgrade to %s.' => '',
        '%s was correctly reinstalled.' => '',
        'There was a problem reinstalling %s.' => '',
        'Your %s was successfully updated.' => '',
        'There was a problem during the upgrade of %s.' => '',
        '%s was correctly uninstalled.' => '',
        'There was a problem uninstalling %s.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => 'Jour de l\'An',
        'International Workers\' Day' => 'Fête internationale des travailleurs',
        'Christmas Eve' => 'Réveillon de Noël',
        'First Christmas Day' => '1er jour de Noël',
        'Second Christmas Day' => '2e jour de Noël',
        'New Year\'s Eve' => 'Veille du jour de l\'An',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS, demandeur',
        'OTRS as provider' => 'OTRS, fournisseur',
        'Webservice "%s" created!' => 'Le service Web "%s" a été créé.',
        'Webservice "%s" updated!' => 'Le service Web "%s" a été mise à jour.',

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
        'May_long' => 'Mai',
        'June' => 'Juin',
        'July' => 'Juillet',
        'August' => 'Août',
        'September' => 'Septembre',
        'October' => 'Octobre',
        'November' => 'Novembre',
        'December' => 'Décembre',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Les préférences ont bien été mises à jour.',
        'User Profile' => 'Profil utilisateur',
        'Email Settings' => 'Réglage des courriels',
        'Other Settings' => 'Autres paramétrages',
        'Change Password' => 'Changer de mot de passe',
        'Current password' => 'Mot de passe actuel',
        'New password' => 'Nouveau mot de passe',
        'Verify password' => 'Vérifier le mot de passe',
        'Spelling Dictionary' => 'Correcteur orthographique',
        'Default spelling dictionary' => 'Dictionnaire d\'orthographe par défaut.',
        'Max. shown Tickets a page in Overview.' => 'Nombre maximum de demandes affichées sur la page de visuallisation des demandes',
        'The current password is not correct. Please try again!' => 'Le mot de passe actuel n\'est pas correct. Merci d\'essayer à nouveau.',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Impossible de mettre à jour le mot de passe, votre nouveau mot de passe ne correspond pas. Merci d\'essayer à nouveau.',
        'Can\'t update password, it contains invalid characters!' => 'Impossible de mettre à jour le mot de passe, il contient des caractères invalides.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Impossible de mettre à jour le mot de passe; il doit contenir au moins %s caractères.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Impossible de mettre à jour le mot de passe; il doit contenir au moins deux lettres en minuscule et deux lettres en majuscule.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Impossible de mettre à jour le mot de passe; il doit contenir au moins un chiffre.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Impossible de mettre à jour le mot de passe; il doit contenir au moins deux caractères.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Impossible de mettre à jour le mot de passe; ce mot de passe a déjà été utilisé. Merci d\'en choisir un autre.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Sélectionner le caractère séparateur pour les fichiers CSV (stats et recherches). Si rien n\'est indiqué ici, le séparateur par défaut pour votre langage sera utilisé.',
        'CSV Separator' => 'Séparateur CSV',

        # Template: AAAStats
        'Stat' => 'Statistique',
        'Sum' => 'Somme',
        'No (not supported)' => '',
        'Days' => 'Jours',
        'Please fill out the required fields!' => 'Veuillez remplir les champs obligatoires.',
        'Please select a file!' => 'Sélectionnez un fichier.',
        'Please select an object!' => 'Sélectionnez un objet.',
        'Please select a graph size!' => 'Sélectionnez une taille de graphique.',
        'Please select one element for the X-axis!' => 'Sélectionnez un élément pour l\'axe X.',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Ne sélectionnez qu\'un seul élément ou désactivez le bouton « Figer » vis-à-vis l\'élément sélectionné.',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Après avoir sélectionné un champ, vous devez préciser les attributs.',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Veuillez inscrire une valeur dans le champ sélectionné ou décochez la case « Figer ».',
        'The selected end time is before the start time!' => 'La date de fin sélectionnée est antérieure à la date de début.',
        'You have to select one or more attributes from the select field!' =>
            'Vous devez sélectionner un ou plusieurs attributs dans le champ sélectionné.',
        'The selected Date isn\'t valid!' => 'La date sélectionnée est incorrecte.',
        'Please select only one or two elements via the checkbox!' => 'Ne sélectionnez qu\'un ou deux éléments au moyen des cases à cocher.',
        'If you use a time scale element you can only select one element!' =>
            'Si vous utilisez une échelle de temps, vous ne pouvez choisir un autre élément.',
        'You have an error in your time selection!' => ' La date est erronée.',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'La période choisie pour le rapport est trop courte, veuillez indiquer une période plus grande.',
        'The selected start time is before the allowed start time!' => 'La date de début sélectionnée est antérieure à la date de début autorisée.',
        'The selected end time is after the allowed end time!' => 'La date de fin sélectionnée est postérieure à la date de fin autorisée.',
        'The selected time period is larger than the allowed time period!' =>
            'La période sélectionnée est plus grande que la période autorisée.',
        'Common Specification' => 'Caractéristiques communes',
        'X-axis' => 'Axe X',
        'Value Series' => 'Séries de données',
        'Restrictions' => 'Restrictions',
        'graph-lines' => 'graphique - courbes',
        'graph-bars' => 'graphique - histogramme',
        'graph-hbars' => 'graphique - histogramme horizontal',
        'graph-points' => 'graphique - points',
        'graph-lines-points' => 'graphique - courbes et points',
        'graph-area' => 'graphique - aire',
        'graph-pie' => 'graphique - secteurs',
        'extended' => 'étendu',
        'Agent/Owner' => 'Agent ou propriétaire ',
        'Created by Agent/Owner' => 'Créé par l\'agent ou le propriétaire',
        'Created Priority' => 'Priorité créée ',
        'Created State' => 'État créé ',
        'Create Time' => 'Date de création ',
        'CustomerUserLogin' => 'Identifiant client ',
        'Close Time' => 'Date de fermeture ',
        'TicketAccumulation' => 'Total des demandes',
        'Attributes to be printed' => 'Attributs à imprimer',
        'Sort sequence' => 'Ordre de tri',
        'Order by' => 'Trier par',
        'Limit' => 'Limite ',
        'Ticketlist' => 'Liste des demandes',
        'ascending' => 'ascendant',
        'descending' => 'descendant',
        'First Lock' => 'Premier verrou',
        'Evaluation by' => 'Évaluation par',
        'Total Time' => 'Temps Total',
        'Ticket Average' => 'Moyenne des demandes',
        'Ticket Min Time' => 'Temps minimum de la demande',
        'Ticket Max Time' => 'Temps maximum de la demande',
        'Number of Tickets' => 'Nombre de demandes',
        'Article Average' => 'Moyenne des articles',
        'Article Min Time' => 'Temps minimum des articles',
        'Article Max Time' => 'Temps maximum des articles',
        'Number of Articles' => 'Nombre d\'articles',
        'Accounted time by Agent' => 'Temps alloué par agent',
        'Ticket/Article Accounted Time' => 'Temps alloué par demande ou par article',
        'TicketAccountedTime' => 'Temps de traitement de la demande',
        'Ticket Create Time' => 'Heure de création de la demande',
        'Ticket Close Time' => 'Heure de fermeture de la demande',

        # Template: AAASupportDataCollector
        'Unknown' => '',
        'Information' => '',
        'OK' => '',
        'Problem' => 'Problème',
        'Webserver' => '',
        'Operating System' => '',
        'OTRS' => '',
        'Table Presence' => '',
        'Internal Error: Could not open file.' => '',
        'Table Check' => '',
        'Internal Error: Could not read file.' => '',
        'Tables found which are not present in the database.' => '',
        'Database Size' => '',
        'Could not determine database size.' => 'La taille de la base de données n\'a pu être déterminée.',
        'Database Version' => '',
        'Could not determine database version.' => '',
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'Setting character_set_database needs to be UNICODE or UTF8.' => '',
        'Table Charset' => '',
        'There were tables found which do not have utf8 as charset.' => '',
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            '',
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',
        'Default Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',
        'MySQL 5.x or higher is required.' => '',
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to AL32UTF8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',
        'PostgreSQL 8.x or higher is required.' => '',
        'OTRS Disk Partition' => '',
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',
        'Disk Partitions Usage' => '',
        'Distribution' => '',
        'Could not determine distribution.' => '',
        'Kernel Version' => '',
        'Could not determine kernel version.' => '',
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',
        'Perl Version' => '',
        'Free Swap Space (%)' => '',
        'No Swap Enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',
        'Config Settings' => '',
        'Could not determine value.' => '',
        'Database Records' => '',
        'Tickets' => 'Demandes',
        'Ticket History Entries' => '',
        'Articles' => 'Articles',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Queues' => 'Files',
        'Agents' => 'Agents',
        'Roles' => 'Rôles',
        'Groups' => 'Groupes',
        'Dynamic Fields' => 'Champs dynamiques',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Processes' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',
        'Default SOAP Username and Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',
        'Error Log' => '',
        'There are error reports in your system log.' => '',
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',
        'Package installation status' => '',
        'Some packages are not correctly installed.' => '',
        'Package List' => '',
        'SystemID' => 'ID Système',
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',
        'OTRS Version' => '',
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',
        'Open Tickets' => 'Demandes ouvertes',
        'You should not have more than 8,000 open tickets in your system.' =>
            '',
        'Ticket Search Index module' => '',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',
        'Environment Variables' => '',
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',
        'Loaded Apache Modules' => '',
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Vous devez utiliser « FastCGI » ou « mod_perl » afin d\'améliorer la performance du système.',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload ou Apache2::Reload doit être utilisé en tant que « PerlModule » et « PerlInitHandler » pour s\'assurer que le serveur Web ne redémarre pas lors de l\'installation ou de la mise à niveau des modules.',
        'Apache::DBI Usage' => '',
        'Apache::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',
        'You should use PerlEx to increase your performance.' => 'Vous devez utiliser «PerlEx » afin d\'améliorer la performance du système.',

        # Template: AAATicket
        'Status View' => 'Vue des états ',
        'Service View' => '',
        'Bulk' => 'Groupées',
        'Lock' => 'Verrou ',
        'Unlock' => 'Déverrouillée',
        'History' => 'Historique',
        'Zoom' => 'Détails',
        'Age' => 'Âge ',
        'Bounce' => 'Retourner',
        'Forward' => 'Transférer',
        'From' => 'De ',
        'To' => 'À ',
        'Cc' => 'Copie ',
        'Bcc' => 'Copie invisible ',
        'Subject' => 'Objet ',
        'Move' => 'Déplacer',
        'Queue' => 'File ',
        'Priority' => 'Priorité ',
        'Priorities' => 'Priorités',
        'Priority Update' => 'Mise à jour de la priorité',
        'Priority added!' => 'Priorité ajoutée!',
        'Priority updated!' => 'Priorité mise à jour!',
        'Signature added!' => 'Signature ajoutée!',
        'Signature updated!' => 'Signature mise à jour!',
        'SLA' => 'SLA ',
        'Service Level Agreement' => 'Accord sur les niveaux de service',
        'Service Level Agreements' => 'Accords sur les niveaux de service',
        'Service' => 'Service ',
        'Services' => 'Services',
        'State' => 'État ',
        'States' => 'États',
        'Status' => 'État ',
        'Statuses' => 'États',
        'Ticket Type' => 'Type de demande',
        'Ticket Types' => 'Types de demande',
        'Compose' => 'Composer',
        'Pending' => 'En attente',
        'Owner' => 'Propriétaire ',
        'Owner Update' => 'Mise à jour du propriétaire',
        'Responsible' => 'Responsable',
        'Responsible Update' => 'Mise à jour du responsable',
        'Sender' => 'Émetteur',
        'Article' => 'Article ',
        'Ticket' => 'Demande ',
        'Createtime' => 'Date de création',
        'plain' => 'tel quel',
        'Email' => 'Courriel ',
        'email' => 'courriel ',
        'Close' => 'Fermer',
        'Action' => 'Action',
        'Attachment' => 'Pièce jointe ',
        'Attachments' => 'Pièces jointes ',
        'This message was written in a character set other than your own.' =>
            'Ce courriel a été écrit dans un jeu de caractères différent du vôtre.',
        'If it is not displayed correctly,' => 'S\'il n\'est pas affiché correctement',
        'This is a' => 'Ceci est un',
        'to open it in a new window.' => 'L\'ouvrir dans une nouvelle fenêtre',
        'This is a HTML email. Click here to show it.' => 'Ceci est un courriel au format HTML ; cliquer ici pour l\'afficher.',
        'Free Fields' => 'Champs libres',
        'Merge' => 'Fusionner',
        'merged' => 'fusionnée',
        'closed successful' => 'fermée (résolue)',
        'closed unsuccessful' => 'fermée (non résolue)',
        'Locked Tickets Total' => 'Total des demandes verrouillés',
        'Locked Tickets Reminder Reached' => 'Rappel des demandes fermées atteint',
        'Locked Tickets New' => 'Nouvelles demandes verrouillées',
        'Responsible Tickets Total' => 'Total des demandes du responsable',
        'Responsible Tickets New' => 'Nouvelles demandes du responsable',
        'Responsible Tickets Reminder Reached' => 'Rappel pour le responsable des demandes atteint.',
        'Watched Tickets Total' => 'Total des demandes vues',
        'Watched Tickets New' => 'Total de nouvelles demandes',
        'Watched Tickets Reminder Reached' => 'Rappel des demandes vues atteint',
        'All tickets' => 'Toutes les demandes',
        'Available tickets' => 'Demandes disponibles',
        'Escalation' => 'Escalade ',
        'last-search' => 'recherche précédente',
        'QueueView' => 'Vue des files d\'attentes ',
        'Ticket Escalation View' => 'Vue des escalades de la demande ',
        'Message from' => 'Message de',
        'End message' => 'Fin du message',
        'Forwarded message from' => 'Message transféré par',
        'End forwarded message' => 'Fin du message tranféré',
        'Bounce Article to a different mail address' => 'Retourner l\'article à une adresse électronique différente',
        'Reply to note' => '',
        'new' => 'nouvelle',
        'open' => 'ouverte',
        'Open' => 'Ouverts',
        'Open tickets' => 'Demandes ouvertes',
        'closed' => 'fermée',
        'Closed' => 'Fermées',
        'Closed tickets' => 'Demandes fermées',
        'removed' => 'supprimée',
        'pending reminder' => 'rappel en attente',
        'pending auto' => 'mise en attente automatique',
        'pending auto close+' => 'en attente de la fermeture automatique (+)',
        'pending auto close-' => 'en attente de la fermeture automatique (-)',
        'email-external' => 'courriel externe',
        'email-internal' => 'courriel interne',
        'note-external' => 'Note externe',
        'note-internal' => 'Note interne',
        'note-report' => 'Note rapport',
        'phone' => 'téléphone ',
        'sms' => 'SMS',
        'webrequest' => 'Requête par le web',
        'lock' => 'verrouillée',
        'unlock' => 'déverrouillée',
        'very low' => 'très basse',
        'low' => 'confort de fonctionnement',
        'normal' => 'normal',
        'high' => 'important',
        'very high' => 'très haut',
        '1 very low' => '1 minimale',
        '2 low' => '2 basse',
        '3 normal' => '3 normale',
        '4 high' => '4 haute',
        '5 very high' => '5 maximale',
        'auto follow up' => 'suivi automatique',
        'auto reject' => 'rejet automatique',
        'auto remove' => 'suppression automatique',
        'auto reply' => 'réponse automatique',
        'auto reply/new ticket' => 'réponse auto ou nouvelle demande',
        'Create' => 'Création',
        'Answer' => 'Réponse ',
        'Phone call' => 'Appel téléphonique ',
        'Ticket "%s" created!' => 'La demande %s a été créée.',
        'Ticket Number' => 'Numéro de demande',
        'Ticket Object' => 'Objet de la demande',
        'No such Ticket Number "%s"! Can\'t link it!' => 'La demande numéro "%s" n\'existe pas! Impossible de la lier !',
        'You don\'t have write access to this ticket.' => 'Vous n\'avez pas de permission d\'écriture pour cette demande.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Désolé, vous devez être le propriétaire de la demande pour effectuer cette action.',
        'Please change the owner first.' => 'D\'abord, veuillez modifier le propriétaire.',
        'Ticket selected.' => 'Demande sélectionnée.',
        'Ticket is locked by another agent.' => 'Demande verrouillée par un autre agent.',
        'Ticket locked.' => 'Demande verrouillée.',
        'Don\'t show closed Tickets' => 'Ne pas montrer les demandes fermées',
        'Show closed Tickets' => 'Voir les demandes fermées',
        'New Article' => 'Nouvel Article',
        'Unread article(s) available' => 'Article non lu disponible',
        'Remove from list of watched tickets' => 'Retirer de la liste des demandes sous surveillance',
        'Add to list of watched tickets' => 'Ajouter à la liste des demandes sous surveillance',
        'Email-Ticket' => 'Écrire un courriel',
        'Create new Email Ticket' => 'Créer une nouvelle demande par courriel',
        'Phone-Ticket' => 'Demande par téléphone',
        'Search Tickets' => 'Recherche de demande',
        'Customer Realname' => '',
        'Customer History' => '',
        'Edit Customer Users' => 'Éditer les utilisateurs clients',
        'Edit Customer' => 'Éditer les renseignements du client',
        'Bulk Action' => 'Action groupée',
        'Bulk Actions on Tickets' => 'Actions groupées sur les demandes',
        'Send Email and create a new Ticket' => 'Envoyer un courriel et créer une nouvelle demande',
        'Create new Email Ticket and send this out (Outbound)' => 'Créer une demande par courriel et l\'envoyer (Sortant)',
        'Create new Phone Ticket (Inbound)' => 'Créer une demande téléphonique (Entrant)',
        'Address %s replaced with registered customer address.' => 'Adresse %s remplacée par celle du client enregistré.',
        'Customer user automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Aperçu de toutes les demandes',
        'Locked Tickets' => 'Demandes verrouillées',
        'My Locked Tickets' => 'Mes demandes verrouillées',
        'My Watched Tickets' => 'Mes demandes sous surveillance',
        'My Responsible Tickets' => 'Les demandes dont je suis responsable',
        'Watched Tickets' => 'Demandes sous surveillance',
        'Watched' => 'Sous surveillance',
        'Watch' => 'Surveiller',
        'Unwatch' => 'Arrêter la surveillance',
        'Lock it to work on it' => 'Verrouiller la demande pour y travailler',
        'Unlock to give it back to the queue' => 'Déverrouillage permettant de remettre en file',
        'Show the ticket history' => 'Afficher l\'historique de la demande',
        'Print this ticket' => 'Imprimer cette demande',
        'Print this article' => 'Imprimer cet article',
        'Split' => 'Scinder',
        'Split this article' => 'Scinder cet article',
        'Forward article via mail' => 'Transférer l\'article par courriel',
        'Change the ticket priority' => 'Modifier la priorité de la demande no ',
        'Change the ticket free fields!' => 'Changer les champs libres de la demandes!',
        'Link this ticket to other objects' => 'Lier cette demande à d\'autres objets',
        'Change the owner for this ticket' => 'Changer le propriétaire de cette demande',
        'Change the  customer for this ticket' => 'Changer le utilisateur du ticket',
        'Add a note to this ticket' => 'Ajouter une note à cette demande',
        'Merge into a different ticket' => 'Fusionner avec une autre demande',
        'Set this ticket to pending' => 'Mettre cette demande en attente',
        'Close this ticket' => 'Fermer cette demande',
        'Look into a ticket!' => 'Voyez le détail de la demande!',
        'Delete this ticket' => 'Effacer cette demande',
        'Mark as Spam!' => 'Marquer comme pourriel!',
        'My Queues' => 'Mes files ',
        'Shown Tickets' => 'Demandes affichées',
        'Shown Columns' => '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Le courriel portant le numéro de demande « <OTRS_TICKET> » a été fusionné avec la demande numéro « <OTRS_MERGE_TO_TICKET> ».',
        'Ticket %s: first response time is over (%s)!' => 'Demande %s: le temps imparti pour la première réponse est dépassé (%s).',
        'Ticket %s: first response time will be over in %s!' => 'Demande %s: le temps imparti pour la première réponse sera dépassé dans %s.',
        'Ticket %s: update time is over (%s)!' => 'Demande %s: le temps imparti pour la révision est dépassé (%s).',
        'Ticket %s: update time will be over in %s!' => 'Demande %s: le temps imparti pour la révision sera dépassé dans %s.',
        'Ticket %s: solution time is over (%s)!' => 'Demande %s: le temps imparti pour fournir une solution est dépassé (%s).',
        'Ticket %s: solution time will be over in %s!' => 'Demande %s: le temps imparti pour fournir une solution sera dépassé dans %s.',
        'There are more escalated tickets!' => 'Il y a d\'autres demandes en escalade.',
        'Plain Format' => 'Format texte',
        'Reply All' => 'Répondre à tous',
        'Direction' => 'Direction',
        'Agent (All with write permissions)' => 'Agent (avec permission d\'écriture)',
        'Agent (Owner)' => 'Agent (Propriétaire)',
        'Agent (Responsible)' => 'Agent (Responsable)',
        'New ticket notification' => 'Notification de nouvelle demande ',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Prévenez-moi s\'il y a une nouvelle demande dans une de « Mes files ».',
        'Send new ticket notifications' => 'Envoyer les notifications de nouvelle demande.',
        'Ticket follow up notification' => 'Notification de suivi de demande ',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Envoyez-moi une notification si un client envoie un suivi et que je suis le propriétaire de la demande ou que la demande est déverrouillée et dans une de mes files abonnées.',
        'Send ticket follow up notifications' => 'Envoie des notifications de suivi de demande.',
        'Ticket lock timeout notification' => 'Notification de désactivation du verrou ',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Prévenez-moi si une demande est déverrouillée par le système.',
        'Send ticket lock timeout notifications' => 'Envoyer les notifications de désactivation du verrou.',
        'Ticket move notification' => 'Notification de déplacement d\'une demande ',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Prévenez-moi si une demande est déplacée dans une de « Mes files ».',
        'Send ticket move notifications' => 'Envoyer les notifications de déplacement de demande.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Faites la sélection de vos files préférées. Vous recevrez des notifications à propos de ces files par courrier électronique.',
        'Custom Queue' => 'File personnalisée',
        'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'La vue des files sera rafraîchit automatiquement après la période précisée si la fonctionnalité est activée.',
        'Refresh QueueView after' => 'Rafraichir la vue des files après',
        'Screen after new ticket' => 'Écran qui suit la création d\'une demande ',
        'Show this screen after I created a new ticket' => 'Faire apparaître cet écran après la création d\'une nouvelle demande.',
        'Closed Tickets' => 'Demandes fermées',
        'Show closed tickets.' => 'Voir les demandes fermées.',
        'Max. shown Tickets a page in QueueView.' => 'Nombre maximum de demandes affichées sur la page de la vue d\'une file.',
        'Ticket Overview "Small" Limit' => 'Limites de l\'affichage « S » (Petit ) ',
        'Ticket limit per page for Ticket Overview "Small"' => 'Nombre de demandes par page pour l\'affichage « S » (Petit). ',
        'Ticket Overview "Medium" Limit' => 'Limites de l\'affichage « M » (Moyen) ',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Nombre de demandes par page pour l\'affichage « M » (Moyen). ',
        'Ticket Overview "Preview" Limit' => 'Limites de l\'affichage « L » (Grand) ',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Nombre de demandes par page pour l\'affichage « L » (Grand).',
        'Ticket watch notification' => 'Notification de surveillance des demandes',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Pour les demandes sous surveillance, envoyez-moi les mêmes notifications que celles envoyées au propriétaire de ces demandes.',
        'Send ticket watch notifications' => 'Envoyer des notifications de surveillance des demandes',
        'Out Of Office Time' => 'Période d\'absence du bureau ',
        'New Ticket' => 'Nouvelle demande',
        'Create new Ticket' => 'Création d\'une nouvelle demande',
        'Customer called' => 'Client appellé',
        'phone call' => 'Appel téléphonique',
        'Phone Call Outbound' => 'Appel vers le client',
        'Phone Call Inbound' => 'Appel vers l\'agent',
        'Reminder Reached' => 'Rappel atteint',
        'Reminder Tickets' => 'Rappels',
        'Escalated Tickets' => 'Demandes escaladées',
        'New Tickets' => 'Nouvelles demandes',
        'Open Tickets / Need to be answered' => 'Demandes ouvertes en attente de réponse',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Les demandes ouvertes; ces demandes ont été traitées mais nécessitent une réponse.',
        'All new tickets, these tickets have not been worked on yet' => 'Les nouvelles demandes; ces demandes n\'ont pas été traitées.',
        'All escalated tickets' => 'Les demandes escaladées',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Les demandes dont la date de rappel à été atteinte.',
        'Archived tickets' => 'Demandes archivées',
        'Unarchived tickets' => 'Demandes non archivées',
        'Ticket Information' => 'Information sur la demande',

        # Template: AAAWeekDay
        'Sun' => 'Dim',
        'Mon' => 'Lun',
        'Tue' => 'Mar',
        'Wed' => 'Mer',
        'Thu' => 'Jeu',
        'Fri' => 'Ven',
        'Sat' => 'Sam',

        # Template: AdminACL
        'ACL Management' => '',
        'Filter for ACLs' => '',
        'Filter' => 'Filtre',
        'ACL Name' => '',
        'Actions' => 'Actions',
        'Create New ACL' => '',
        'Deploy ACLs' => '',
        'Export ACLs' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'Ce champ est requis.',
        'Overwrite existing ACLs?' => '',
        'Upload ACL configuration' => '',
        'Import ACL configuration(s)' => '',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '',
        'ACL name' => '',
        'Validity' => 'Admissibilité ',
        'Copy' => '',
        'No data found.' => 'Aucune donnée trouvée.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Go to overview' => 'Aller à la visualisation',
        'Delete ACL' => '',
        'Delete Invalid ACL' => '',
        'Match settings' => '',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => '',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '',
        'Check the official' => '',
        'documentation' => '',
        'Show or hide the content' => 'Montrer ou cacher le contenu',
        'Edit ACL information' => '',
        'Stop after match' => 'Cesser après la correspondance ',
        'Edit ACL structure' => '',
        'Save' => 'Sauvegarder',
        'or' => 'ou',
        'Save and finish' => 'Sauvegarder et terminer',
        'Do you really want to delete this ACL?' => '',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '',
        'An item with this name is already present.' => '',
        'Add all' => '',
        'There was an error reading the ACL data.' => '',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAttachment
        'Attachment Management' => 'Gestion des pièces jointes',
        'Add attachment' => 'Ajouter une pièce jointe',
        'List' => 'Liste',
        'Download file' => 'Télécharger le fichier',
        'Delete this attachment' => 'Supprimer la pièce jointe',
        'Add Attachment' => 'Ajouter une pièce jointe',
        'Edit Attachment' => 'Éditer une pièce jointe',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Gestion des réponses automatiques',
        'Add auto response' => 'Ajouter une réponse automatique',
        'Add Auto Response' => 'Ajouter une réponse automatique',
        'Edit Auto Response' => 'Éditer une réponse automatique',
        'Response' => 'Réponse ',
        'Auto response from' => 'Réponse automatique de ',
        'Reference' => 'Référence',
        'You can use the following tags' => 'Vous pouvez utiliser les codets suivants ',
        'To get the first 20 character of the subject.' => 'Pour avoir les 20 premiers caractères du sujet.',
        'To get the first 5 lines of the email.' => 'Pour avoir les 5 premières lignes du courriel.',
        'To get the realname of the sender (if given).' => 'Pour avoir le nom de l\'expéditeur s\'il est fourni.',
        'To get the article attribute' => 'Pour avoir l\'attribut de l\'article',
        ' e. g.' => ' p. ex.',
        'Options of the current customer user data' => 'Options des données du client actuel',
        'Ticket owner options' => 'Options du propriétaire de la demande',
        'Ticket responsible options' => 'Options du responsable de la demande',
        'Options of the current user who requested this action' => 'Options de l\'utilisateur actuel qui a demandé cette action',
        'Options of the ticket data' => 'Options des données de la demande',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Options de configuration',
        'Example response' => 'Exemple de réponse ',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestion des clients',
        'Wildcards like \'*\' are allowed.' => 'Les caractères génériques tels que \'*\' sont autorisés.',
        'Add customer' => 'Ajouter un client',
        'Select' => 'Sélectionner',
        'Please enter a search term to look for customers.' => 'Pour trouver des clients, inscrire un terme de recherche.',
        'Add Customer' => 'Ajouter un client',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gestion des clients',
        'Back to search results' => '',
        'Add customer user' => '',
        'Hint' => 'Conseil',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '',
        'Last Login' => 'Dernière connexion',
        'Login as' => 'Connecté en tant que',
        'Switch to customer' => '',
        'Add Customer User' => 'Ajouter un client',
        'Edit Customer User' => '',
        'This field is required and needs to be a valid email address.' =>
            'Le champ est obligatoire et l\'adresse de courrier électronique doit être valide.',
        'This email address is not allowed due to the system configuration.' =>
            'L\'adresse de courrier électronique n\'est pas autorisée selon la configuration du système.',
        'This email address failed MX check.' => 'L\'adresse de courrier électronique n\'est pas conforme.',
        'DNS problem, please check your configuration and the error log.' =>
            'Il y a un problème avec le système DNS, veuillez vérifier la configuration et le journal des erreurs.',
        'The syntax of this email address is incorrect.' => 'La syntaxe de cette adresse électronique est incorrecte.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gestion des relations avec les groupes de clients',
        'Notice' => 'Avis',
        'This feature is disabled!' => 'Cette fonctionnalité est désactivée.',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Cette fonctionnalité permet de donner des permissions à des groupes de clients.',
        'Enable it here!' => 'Activez-la ici',
        'Edit Customer Default Groups' => 'Editer les groupes par défault client',
        'These groups are automatically assigned to all customers.' => 'Ces groupes sont automatiquement assignés à tous les clients',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Faites la gestion de ces groupes au moyen',
        'Filter for Groups' => 'Filtre pour les groupes',
        'Just start typing to filter...' => '',
        'Select the customer:group permissions.' => 'Sélectionner les permissions pour les clients et pour les groupes.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Si rien n\'est sélectionné, aucune permission ne sera accordée à ce groupe (les clients n\'auront pas accès aux demandes).',
        'Search Results' => 'Résultat de recherche',
        'Customers' => 'Clients',
        'No matches found.' => 'Aucun résultat.',
        'Change Group Relations for Customer' => 'Modifier les relations du groupe pour le client',
        'Change Customer Relations for Group' => 'Modifier les relations du client pour le groupe',
        'Toggle %s Permission for all' => 'Sélectionner la Permission %s pour tous',
        'Toggle %s permission for %s' => 'Sélectionner la permission %s pour %s',
        'Customer Default Groups:' => 'Groupes par défaut du client :',
        'No changes can be made to these groups.' => 'Aucun changement n\'est possible pour ces groupes.',
        'ro' => 'Lecture seule',
        'Read only access to the ticket in this group/queue.' => 'Accès en lecture seule aux demandes de cette file ou ce groupe.',
        'rw' => 'Lecture et écriture',
        'Full read and write access to the tickets in this group/queue.' =>
            'Accès complet en lecture et écriture aux demandes de cette file ou ce groupe.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Gestion des relations de services aux clients',
        'Edit default services' => 'Éditer les services par défaut',
        'Filter for Services' => 'Filtre pour les services',
        'Allocate Services to Customer' => 'Attribuer des services au client',
        'Allocate Customers to Service' => 'Attribuer des clients au service',
        'Toggle active state for all' => 'Sélectionner l\'état actif pour tous',
        'Active' => 'Activer',
        'Toggle active state for %s' => 'Sélectionner un état actif pour %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestion des champs dynamiques',
        'Add new field for object' => 'Ajouter un nouveau champ pour l\'objet ',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Liste des champs dynamiques',
        'Dynamic fields per page' => 'Nombre de champs dynamiques par page ',
        'Label' => 'Étiquette ',
        'Order' => 'Ordre',
        'Object' => 'Objet ',
        'Delete this field' => 'Effacer ce champ',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Voulez-vous vraiment effacer ce champ dynamique? Toutes les données associées seront PERDUES.',
        'Delete field' => 'Effacer ce champ',

        # Template: AdminDynamicFieldCheckbox
        'Field' => ' ',
        'Go back to overview' => 'Retour à la visualisation',
        'General' => 'Généralités',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Ce champ est requis et sa valeur doit être composée de caractères alphabétiques et numériques seulement.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Le nom doit être unique et composé seulement de caractères alphabétiques et numériques.',
        'Changing this value will require manual changes in the system.' =>
            'Changer cette valeur exige également des changements manuels dans le système.',
        'This is the name to be shown on the screens where the field is active.' =>
            'L\'étiquette porte le nom qui sera affiché sur les écrans où le champ est actif.',
        'Field order' => 'Ordre du champ ',
        'This field is required and must be numeric.' => 'Ce champ est requis et doit être composé de caractères numériques.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'L\'affichage sur les écrans où le champ est actif respectera l\'ordre choisi.',
        'Field type' => 'Type de champ ',
        'Object type' => 'Type d\'objet ',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => ': Réglage du champ',
        'Default value' => 'Valeur par défaut ',
        'This is the default value for this field.' => 'La valeur par défaut est spécifiquement pour ce champ.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Différence entre la date actuelle et le date affichée ',
        'This field must be numeric.' => 'Ce champ doit être composé de caractères numériques',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Inscrivez la différence par défaut (en secondes) entre la date actuelle et la date sélectionnée qui doit être affichée dans les écrans d\'éditions (ex. 3600 ou -60).',
        'Define years period' => 'Période déterminée (en années) ',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            ' Activez cette fonctionnalité afin de fixer le nombre d\'années devant être affiché (dans le futur et dans le passé) à l\'intérieur de la section « année » du champ.',
        'Years in the past' => 'années passées',
        'Years in the past to display (default: 5 years).' => 'années passées à afficher (par défaut, 5 années)',
        'Years in the future' => 'Années futures',
        'Years in the future to display (default: 5 years).' => 'Années futures à afficher (par défaut, 5 années)',
        'Show link' => 'Montrer le lien ',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Vous pouvez ajouter un lien HTTP optionel dans le champ « valeur » des écrans de visualisation et de synthèse.',
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Valeurs possibles ',
        'Key' => 'Clé ',
        'Value' => 'Valeur ',
        'Remove value' => 'Retirer la valeur',
        'Add value' => 'Ajouter une valeur ',
        'Add Value' => 'Ajouter une valeur',
        'Add empty value' => 'Ajouter une valeur sans contenu ',
        'Activate this option to create an empty selectable value.' => 'Pour créer une valeur sans contenu, activer cette option.',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => 'Valeurs traduisibles ',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Pour que le contenu des valeurs soit traduit dans la langue définie par l\'utilisateur, activez cette option.',
        'Note' => 'Note ',
        'You need to add the translations manually into the language translation files.' =>
            'Vous devez traduire vous-même le contenu dans les fichiers de traduction.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Nombre de rangées ',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Précisez la hauteur de ce champ (en nombre de lignes), présent lors de l\'édition.',
        'Number of cols' => 'Nombre de colonnes ',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Précisez la largeur de ce champ (en nombre de caractères), présent lors de l\'édition.',
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => 'Message d\'erreur ',
        'Add RegEx' => '',

        # Template: AdminEmail
        'Admin Notification' => 'Notifications',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Le présent module permet aux administrateurs d\'envoyer des messages aux agents, aux groupes et aux autres membres du même rôle.',
        'Create Administrative Message' => 'Création d\'un message de l\'administrateur',
        'Your message was sent to' => 'Votre message a été envoyé à',
        'Send message to users' => 'Envoyer un message aux utilisateurs ',
        'Send message to group members' => 'Envoyer un message aux membres du groupe ',
        'Group members need to have permission' => 'Préciser la permission accordée aux membres du groupe ',
        'Send message to role members' => 'Envoyer un message aux membres de ce rôle ',
        'Also send to customers in groups' => 'Aussi envoyer aux clients dans les groupes',
        'Body' => 'Corps ',
        'Send' => 'Envoyer',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agent générique',
        'Add job' => 'Ajouter une tâche',
        'Last run' => 'Dernière utilisation',
        'Run Now!' => 'Démarrer maintenant',
        'Delete this task' => 'Supprimer cette tâche',
        'Run this task' => 'Exécuter cette tâche',
        'Job Settings' => 'Configuration de la tâche',
        'Job name' => 'Nom de la tâche ',
        'The name you entered already exists.' => 'Le nom que vous avez entré existe déjà.',
        'Toggle this widget' => 'Basculer vers ce gadget',
        'Automatic execution (multiple tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Minutes ',
        'Schedule hours' => 'Heures ',
        'Schedule days' => 'Jour ',
        'Currently this generic agent job will not run automatically.' =>
            'L\'agent générique ne s\'exécutera pas automatiquement.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Pour permettre l\'exécution automatique, sélectionnez au moins une valeur dans les champs « minutes », « heures » et « jours ».',
        'Event based execution (single ticket)' => '',
        'Event Triggers' => 'Déclencheurs d\'évènements',
        'List of all configured events' => '',
        'Delete this event' => 'Supprimer cet évènement',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'Voulez-vous vraiment supprimer ce déclencheur d\'évènements?',
        'Add Event Trigger' => 'Ajouter un déclencheur d\'évènements',
        'Add Event' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Pour ajouter un nouvel évènement, sélectionnez l\'objet et le nom de l\'évènement puis cliquez sur le bouton « + » ',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => 'Supprimer ce déclencheur d\'évènements',
        'Remove selection' => '',
        'Select Tickets' => '',
        '(e. g. 10*5155 or 105658*)' => '(ex. : 10*5155 ou 105658*) ',
        '(e. g. 234321)' => '(ex. : 234321) ',
        'Customer login' => 'Numéro d\'ouverture de session du client ',
        '(e. g. U5150)' => '(ex. : U5150) ',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Recherche plein texte dans l\'article (ex. "Valérie*m" ou "Eco*").',
        'Agent' => 'Agent',
        'Ticket lock' => 'Verrou ',
        'Create times' => 'Date de création ',
        'No create time settings.' => 'Ne pas utiliser la date de création des demandes.',
        'Ticket created' => 'Demandes créées entre le',
        'Ticket created between' => 'Demandes créées entre le',
        'Last changed times' => '',
        'No last changed time settings.' => '',
        'Ticket last changed' => '',
        'Ticket last changed between' => '',
        'Change times' => 'Date de modification ',
        'No change time settings.' => 'Ne pas utiliser la date de modification des demandes.',
        'Ticket changed' => 'Demandes modifiées',
        'Ticket changed between' => 'Demandes modifiées entre le',
        'Close times' => 'Date de fermeture ',
        'No close time settings.' => 'Ne pas utiliser la date de fermeture des demandes.',
        'Ticket closed' => 'Demandes fermées',
        'Ticket closed between' => 'Demandes fermées entre le',
        'Pending times' => 'Date d\'échéance ',
        'No pending time settings.' => 'Ne pas utiliser la date d\'échéance des demandes.',
        'Ticket pending time reached' => 'Dates d\'échéance atteintes',
        'Ticket pending time reached between' => 'Dates d\'échéance atteintes entre le',
        'Escalation times' => 'Date de l\'escalade ',
        'No escalation time settings.' => 'Ne pas utiliser la date de l\'escalade des demandes.',
        'Ticket escalation time reached' => 'Date d\'échéance des demandes atteinte',
        'Ticket escalation time reached between' => 'Date d\'échéance des demandes atteinte entre le',
        'Escalation - first response time' => 'Escalade - délai de la première réponse ',
        'Ticket first response time reached' => 'Délai de la première réponse atteint',
        'Ticket first response time reached between' => 'Délai de la première réponse atteint entre le',
        'Escalation - update time' => 'Escalade - délai de mise à jour ',
        'Ticket update time reached' => 'Délai de mise à jour des demandes atteint',
        'Ticket update time reached between' => 'Délai de mise à jour des demandes atteint entre le',
        'Escalation - solution time' => 'Escalade - délai de résolution ',
        'Ticket solution time reached' => 'Temps de résolution des demandes atteint',
        'Ticket solution time reached between' => 'Temps de résolution des demandes atteint entre le',
        'Archive search option' => 'Option de recherche dans les archives',
        'Update/Add Ticket Attributes' => '',
        'Set new service' => 'Définir un nouveau service',
        'Set new Service Level Agreement' => 'Définir un nouveau contrat de niveau de support',
        'Set new priority' => 'Fixer une nouvelle priorité ',
        'Set new queue' => 'Déterminer une nouvelle file ',
        'Set new state' => 'Déterminer un nouvel état ',
        'Pending date' => 'Délai d\'attente ',
        'Set new agent' => 'Déterminer un nouvel agent',
        'new owner' => 'nouveau propriétaire ',
        'new responsible' => 'nouveau responsable',
        'Set new ticket lock' => 'Fixer un nouveau verrou sur la demande ',
        'New customer' => 'Nouveau client ',
        'New customer ID' => 'Nouvel identifiant du client ',
        'New title' => 'Nouveau titre ',
        'New type' => 'Nouveau type',
        'New Dynamic Field Values' => 'Nouvelles valeurs de champ dynamique',
        'Archive selected tickets' => 'Archiver les demandes sélectionnées',
        'Add Note' => 'Ajouter une note',
        'Time units' => 'Unité de temps',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'Envoyer des notifications aux agents et aux clients visés lors de changements ',
        'CMD' => 'Directive ',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'La directive sera exécutée. Le numéro de la demande est ARG[0] et son identifiant est ARG[1].',
        'Delete tickets' => 'Supprimer les demandes ',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Avertissement : Les demandes concernées seront supprimées de la base de données et ne pourront être restaurées.',
        'Execute Custom Module' => 'Exécuter le module client',
        'Param %s key' => 'Clé du paramètre %s ',
        'Param %s value' => 'Valeur du paramètre %s ',
        'Save Changes' => 'Sauvegarder les modifications',
        'Results' => 'Résultats',
        '%s Tickets affected! What do you want to do?' => '%s demandes touchées. Que voulez vous faire?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Avertissement : Vous avez utilisé l\'option « supprimé ». Toutes les demandes effacés seront perdues!',
        'Edit job' => 'Éditer la tâche',
        'Run job' => 'Exécuter la tâche',
        'Affected Tickets' => 'Demandes touchées',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Débogueur de l\'interface générique pour le service Web %s',
        'Web Services' => 'Services Web',
        'Debugger' => 'Débogueur',
        'Go back to web service' => 'Retourner au service web',
        'Clear' => 'Supprimer',
        'Do you really want to clear the debug log of this web service?' =>
            'Voulez-vous vraiment supprimer l\'enregistrement de débogage de ce service Web?',
        'Request List' => 'Liste de demandes',
        'Time' => 'Date et heure',
        'Remote IP' => 'Fournisseur d\'information à distance',
        'Loading' => 'En cours de chargement',
        'Select a single request to see its details.' => 'Sélectionnez une demande pour voir l\'information s\'y rattachant.',
        'Filter by type' => 'Filtrer par type ',
        'Filter from' => 'Filtrer à partir de ',
        'Filter to' => 'Filtrer jusqu\'au ',
        'Filter by remote IP' => 'Filtrer par fournisseur d\'information à distance ',
        'Refresh' => 'Rafraîchir',
        'Request Details' => 'Détails demandés',
        'An error occurred during communication.' => 'Une erreur est survenue durant la communication.',
        'Show or hide the content.' => 'Afficher ou cacher le contenu.',
        'Clear debug log' => 'Supprimer l\'enregistrement de débogage',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Ajouter un nouveau demandeur au service Web %s',
        'Change Invoker %s of Web Service %s' => 'Changer le demandeur %s du service Web %s',
        'Add new invoker' => 'Ajouter un nouveau demandeur',
        'Change invoker %s' => 'Changer le demandeur %s',
        'Do you really want to delete this invoker?' => 'Voulez-vous vraiment supprimer ce demandeur?',
        'All configuration data will be lost.' => 'Tous les paramètres seront perdus.',
        'Invoker Details' => 'Détails du demandeur',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Le nom est généralement utilisé pour appeler l\'opération d\'un service Web à distance.',
        'Please provide a unique name for this web service invoker.' => 'Veuillez fournir un nom unique pour ce demandeur de service Web.',
        'Invoker backend' => 'Arrière-plan du demandeur',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Le module de OTRS comprenant l\'arrière-plan du demandeur traitera les données envoyées au système distant ainsi que celles composant la réponse.',
        'Mapping for outgoing request data' => 'Mappage des données des requêtes sortantes',
        'Configure' => 'Configurer',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Les données du demandeur de OTRS seront traitées lors du mappage; elles seront converties pour le système distant.',
        'Mapping for incoming response data' => 'Mappage des données composant les réponses entrantes',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Les données composant les réponses seront traitées lors du mappage; elles seront converties pour le demandeur de OTRS.',
        'Asynchronous' => 'Asynchrone',
        'This invoker will be triggered by the configured events.' => 'Les évènements configurés déclencheront le demandeur.',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'L\'ordonnanceur de OTRS gère les déclencheurs d\'évènements asynchrones en arrière-plan (recommandé).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Les déclencheurs d\'évènements synchrones seront traités directement lors de la requête Web.',
        'Save and continue' => 'Sauvegarder et continuer',
        'Delete this Invoker' => 'Supprimer ce demandeur',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Mappage élémentaire de l\'interface générique du service Web %s',
        'Go back to' => 'Retour à',
        'Mapping Simple' => 'Mappage élémentaire',
        'Default rule for unmapped keys' => 'Règle par défaut pour les clés non mappées',
        'This rule will apply for all keys with no mapping rule.' => 'Cette règle sera appliquée à toutes les clés n\'ayant pas de règle de mappage.',
        'Default rule for unmapped values' => 'Règle par défaut pour les valeurs non mappées',
        'This rule will apply for all values with no mapping rule.' => 'Cette règle sera appliquée à toutes les valeurs n\'ayant pas de règle de mappage.',
        'New key map' => 'Nouvelle mappe de clé',
        'Add key mapping' => 'Ajouter un mappage de clé',
        'Mapping for Key ' => 'Mappage de clé',
        'Remove key mapping' => 'Supprimer le mappage de clé',
        'Key mapping' => 'Mappage de clé',
        'Map key' => 'Mappe de clé',
        'matching the' => 'faire correspondre le ou la',
        'to new key' => 'à la nouvelle clé',
        'Value mapping' => 'Mappage de valeurs',
        'Map value' => 'Mappe de valeur',
        'to new value' => 'à la nouvelle valeur',
        'Remove value mapping' => 'Supprimer le mappage de valeur',
        'New value map' => 'Nouvelle mappe de valeur',
        'Add value mapping' => 'Ajouter un mappage de valeur',
        'Do you really want to delete this key mapping?' => 'Voulez-vous vraiment supprimer ce mappage de clé?',
        'Delete this Key Mapping' => 'Supprimer ce mappage de clé',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Ajouter une nouvelle opération au service Web %s',
        'Change Operation %s of Web Service %s' => 'Modifier l\'opération %s du service Web %s',
        'Add new operation' => 'Ajouter une nouvelle opération',
        'Change operation %s' => 'Changer l\'opération %s',
        'Do you really want to delete this operation?' => 'Voulez-vous vraiment supprimer cette opération?',
        'Operation Details' => 'Détails de l\'opération',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Le nom est généralement utilisé pour appeler cette opération du service Web à partir d\'un système distant.',
        'Please provide a unique name for this web service.' => 'Veuillez fournir un nom unique pour ce service Web.',
        'Mapping for incoming request data' => 'Mappage effectué pour une demande de donnée à venir',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'La réquisition de données sera traitée par mappage afin de la transformer en données lisibles par OTRS.',
        'Operation backend' => 'Arrière-plan des opérations',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Ce module de l\'arrière-plan des opérations de OTRS sera appelé dans le programme afin de traiter la demande, générant ainsi des donnée permettant de répondre.',
        'Mapping for outgoing response data' => 'Mappage pour les données de réponses sortantes',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Les données de réponse seront traitées par ce mappage afin de les transformer en un type de données lisibles par le système distant.',
        'Delete this Operation' => 'Supprimer cette opération',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => '',
        'Network transport' => 'Transport du réseau ',
        'Properties' => 'Propriétés',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'longueur maximale du message',
        'This field should be an integer number.' => 'Ce champ doit être un composé d\'un nombre entier.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => '',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Host' => 'Hôte ',
        'Remote host URL for the REST requests.' => '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => '',
        'The default HTTP command to use for the requests.' => '',
        'Authentication' => 'Authentification',
        'The authentication mechanism to access the remote system.' => 'Le mécanisme d\'authentification permettant d\'accéder au système distant.',
        'A "-" value means no authentication.' => 'La valeur « - » signifie que l\'authentification n\'a pas fonctionné.',
        'The user name to be used to access the remote system.' => 'Nom d\'utilisateur devant être utilisé pour accéder au système distant.',
        'The password for the privileged user.' => 'Le mot de passe des usagers privilégiés.',
        'Use SSL Options' => 'Utiliser les options du protocole SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Afficher ou cacher les options SSL pour se connecter au système distant',
        'Certificate File' => 'Fichier de certificat',
        'The full path and name of the SSL certificate file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => '',
        'Certificate Password File' => 'Fichier du mot de passe du certificat',
        'The full path and name of the SSL key file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => '',
        'Certification Authority (CA) File' => 'Fichier de l\'autorité de certification (AC)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Endpoint' => 'Point d\'extrémité',
        'URI to indicate a specific location for accessing a service.' =>
            'Identifiant uniforme de ressource (URI) qui permet d\'indiquer un lieu précis donnant accès à un service.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'par ex. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Espace de nommage',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'Identifiant uniforme de ressource (URI) pour offrir un contexte aux méthodes du protocole SOAP et réduire ainsi les ambiguïtés.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'par ex. urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'indiquez ici le poids maximal (en octets) des messages du protocole SOAP que OTRS traitera.',
        'Encoding' => 'codage',
        'The character encoding for the SOAP message contents.' => 'Le caractère codé pour le contenu du message du protocole SOAP',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'par ex. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'SOAPAction' => 'Action du protocole SOAP (SOAPAction)',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Réglez à « Oui » pour envoyer un en-tête d\'action de protocole SOAP (SOAPAction)rempli.',
        'Set to "No" to send an empty SOAPAction header.' => 'Réglez à « Non » pour envoyer un en-tête d\'action de protocole SOAP (SOAPAction) vide.',
        'SOAPAction separator' => 'séparateur d\'action du protocole SOAP (SOAPAction)',
        'Character to use as separator between name space and SOAP method.' =>
            'Caractère utilisé en tant que séparateur entre un espace de nommage et une méthode du protocole SOAP.',
        'Usually .Net web services uses a "/" as separator.' => 'Les services Web .net utilisent généralement une « / » comme séparateur.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Le chemin complet et le nom du fichier de certificat du protocole SSL (doit être en format « .p12 »).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'par ex. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'Le mot de passe pour ouvrir le certificat',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Le chemin complet et le nom du fichier de l\'autorité de certification qui authentifie la certification du protocole SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'par ex. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Répertoire de l\'autorité de certification (AC)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Le chemin complet menant au répertoire de l\'autorité de certification, où les certificats sont stockés dans le système de fichiers.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'par ex. /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Serveur proxy',
        'URI of a proxy server to be used (if needed).' => 'Au besoin, utiliser le URI d\'un serveur proxy.',
        'e.g. http://proxy_hostname:8080' => 'par ex. http://proxy_hostname:8080',
        'Proxy User' => 'Utilisateur proxy',
        'The user name to be used to access the proxy server.' => 'Pour accéder au serveur proxy, utiliser ce nom d\'utilisateur.',
        'Proxy Password' => 'Mot de passe proxy',
        'The password for the proxy user.' => 'Le mot de passe de l\'utilisateur proxy.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Gestion des services Web de l\'interface générique',
        'Add web service' => 'Ajouter un service Web',
        'Clone web service' => 'Cloner un service Web',
        'The name must be unique.' => 'Le nom doit être unique.',
        'Clone' => 'Cloner',
        'Export web service' => 'Exporter un service Web',
        'Import web service' => 'Importer un service Web',
        'Configuration File' => 'Fichier de configuration ',
        'The file must be a valid web service configuration YAML file.' =>
            'Le fichier doit être un fichier YAML de configuration de services Web valide.',
        'Import' => 'Importer',
        'Configuration history' => 'Historique ',
        'Delete web service' => 'Supprimer un service Web',
        'Do you really want to delete this web service?' => 'Voulez-vous vraiment supprimer ce service Web?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Une fois la configuration sauvegardée, vous serez redirigé vers l\'écran de gestion des services Web de l\'interface générique, section « Ajouter ».',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Si vous souhaitez accéder à l\'écran de visualisation, cliquez sur « Aller à la visualisation ».',
        'Web Service List' => 'Liste des services Web',
        'Remote system' => 'Système à distance ',
        'Provider transport' => 'Fournisseur de transport',
        'Requester transport' => 'Demandeur de transport',
        'Debug threshold' => 'Seuil de mise au point ',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'En mode « fournisseur », OTRS offre des services Web aux systèmes à distance.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'En mode « demandeur », OTRS utilise les services Web des systèmes à distance.',
        'Operations are individual system functions which remote systems can request.' =>
            'Les opérations constituent des fonctions individuelles du système, et les systèmes à distance peuvent en faire la demande.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Les demandeurs préparent les données pour faire une demande à un service Web à distance, puis ils traitent les données de la réponse.',
        'Controller' => 'Contrôleur',
        'Inbound mapping' => 'Mappage des fonctions entrantes',
        'Outbound mapping' => 'Mappage des fonctions sortantes',
        'Delete this action' => 'Supprimer cet action',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Au moins un %s possède un contrôleur qui n\'est pas activé ou présent; veuillez vérifier l\'enregistrement du contrôleur ou supprimer le %s',
        'Delete webservice' => 'Supprimer un service Web',
        'Delete operation' => 'Supprimer une opération',
        'Delete invoker' => 'Supprimer un demandeur',
        'Clone webservice' => 'Cloner un service Web ',
        'Import webservice' => 'Importer un service Web',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'L\'historique de la configuration de l\'interface générique pour le service Web %s',
        'Go back to Web Service' => 'Retour au service Web',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'L\'historique permet de voir, d\'exporter ou de restaurer les anciennes versions des configurations de services Web habituels.',
        'Configuration History List' => 'Liste des historiques de configuration',
        'Version' => 'Version ',
        'Create time' => 'Date de création ',
        'Select a single configuration version to see its details.' => 'Sélectionnez une version pour voir l\'information s\'y rattachant.',
        'Export web service configuration' => 'Exporter une configuration de service Web',
        'Restore web service configuration' => 'Restaurer une configuration de service Web',
        'Do you really want to restore this version of the web service configuration?' =>
            'Voulez-vous vraiment restaurer cette version de la configuration du service Web?',
        'Your current web service configuration will be overwritten.' => 'La configuration actuelle du service Web sera modifiée.',
        'Restore' => 'Restaurer',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ATTENTION: Lorsque vous modifier le nom du group \'admin\', avant de faire les changements appropriés dans SysConfig, vous serez déconnecté du panneau d\'administration. Si cela arrive, veuillez renommer à nouveau le groupe admin par une requête SQL.',
        'Group Management' => 'Gestion des groupes',
        'Add group' => 'Ajouter un groupe',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Le groupe administrateur permet d\'accéder à la zone d\'administration et le groupe statistiques permet d\'accéder à la zone de statistiques.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Créer de nouveaux groupes de gestion des permissions d\'accès pour les différents groupes d\'agents (p. ex. achats, support, ventes). ',
        'It\'s useful for ASP solutions. ' => 'Cette fonction est pratique pour les solutions ASP. ',
        'Add Group' => 'Ajouter un groupe',
        'Edit Group' => 'Éditer un groupe',

        # Template: AdminLog
        'System Log' => 'Journal',
        'Here you will find log information about your system.' => 'L\'information relative aux ouvertures de sessions dans le système est présentée ici.',
        'Hide this message' => 'Masquer ce message',
        'Recent Log Entries' => 'Ouvertures de sessions récentes',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestion des comptes de courrier électronique',
        'Add mail account' => 'Ajouter un compte',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Les courriels entrants dans un compte seront répartis dans la file sélectionnée.',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Si votre compte est sécurisé, la fonctionnalité de X-OTRS permettant d\'attribuer des en-têtes aux courriels entrants (notamment pour les priorités) sera activée. Le filtre du maître de poste sera activé de toute façon.',
        'Delete account' => 'Supprimer le compte',
        'Fetch mail' => 'Chercher un courriel',
        'Add Mail Account' => 'Ajouter un compte de courrier électronique',
        'Example: mail.example.com' => 'Exemple : courriel.exemple.com',
        'IMAP Folder' => 'Dossier IMAP ',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifiez ce champ seulement si vous souhaitez avoir accès à des courriels situés ailleurs que dans la boîte de réception.',
        'Trusted' => 'Sécurisé ',
        'Dispatching' => 'Classement ',
        'Edit Mail Account' => 'Éditer le compte de courrier électronique',

        # Template: AdminNavigationBar
        'Admin' => 'Administrateur',
        'Agent Management' => 'Gestion des agents',
        'Queue Settings' => 'Configuration des files',
        'Ticket Settings' => 'Configuration des demandes',
        'System Administration' => 'Administration du système',
        'Online Admin Manual' => '',

        # Template: AdminNotification
        'Notification Management' => 'Gestion des notifications',
        'Select a different language' => 'Choisir une autre langue.',
        'Filter for Notification' => 'Filtre pour les notifications',
        'Notifications are sent to an agent or a customer.' => 'Des notifications sont envoyées à un agent ou à un client.',
        'Notification' => 'Notifications ',
        'Edit Notification' => 'Éditer une notification',
        'e. g.' => 'p. ex.',
        'Options of the current customer data' => 'Options pour les données du client actuel',

        # Template: AdminNotificationEvent
        'Add notification' => 'Ajouter une notification',
        'Delete this notification' => 'Supprimer cette notification',
        'Add Notification' => 'Ajouter une notification',
        'Ticket Filter' => 'Filtrer les demandes',
        'Article Filter' => 'Filtre pour les articles',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => 'Type d\'article ',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => '',
        'Subject match' => 'Correspondance du sujet ',
        'Body match' => 'Correspondance du corps du courriel ',
        'Include attachments to notification' => 'Inclure des pièces jointes à la notification ',
        'Recipient' => 'Destinataire',
        'Recipient groups' => 'Groupes destinataires ',
        'Recipient agents' => 'Agents destinataires ',
        'Recipient roles' => 'Rôles des destinataires ',
        'Recipient email addresses' => 'Adresses de courrier électronique des destinataires ',
        'Notification article type' => 'Type de notification ',
        'Only for notifications to specified email addresses' => 'Seulement pour les notifications destinées aux adresses électroniques mentionnées',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Pour avoir les 20 premiers caractères du sujet (du dernier article de l\'agent).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Pour avoir les 5 premières ligne du corps (du dernier article de l\'agent).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Pour avoir les 20 premiers caractères du sujet (du dernier article du client).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Pour avoir les 5 premières lignes du sujet (du dernier article du client).',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '',
        'Downgrade to OTRS Free' => '',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => '',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '',
        '%s not Correctly Installed' => '',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '',
        'Reinstall %s' => '',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => '',
        '%s Not Yet Available' => '',
        '%s will be available soon.' => '',
        '%s Update Available' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            '',
        '%s Correctly Deployed' => '',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '',

        # Template: AdminOTRSBusinessNotInstalled
        'Upgrade to %s' => '',
        '%s will be available soon. Please check again in a few days.' =>
            '',
        'Please have a look at %s for more information.' => '',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Register this System' => '',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '',
        'With your existing contract you can only use a small part of the %s.' =>
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '',
        'Go to OTRS Package Manager' => '',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'Vendeur ',
        'Please uninstall the packages first using the package manager and try again.' =>
            '',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => '',

        # Template: AdminPGP
        'PGP Management' => 'Gestion des clés PGP',
        'Use this feature if you want to work with PGP keys.' => 'Cette fonctionnalité vous permet de travailler avec les clés PGP.',
        'Add PGP key' => 'Ajouter une clé PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Ainsi, vous pouvez directement éditer le trousseau configuré dans le système de configuration.',
        'Introduction to PGP' => 'Introduction aux clés PGP',
        'Result' => 'Résultat ',
        'Identifier' => 'Identifiant',
        'Bit' => 'Bit',
        'Fingerprint' => 'Empreinte',
        'Expires' => 'Échéance',
        'Delete this key' => 'Supprimer cette clé',
        'Add PGP Key' => 'Ajouter Clé PGP',
        'PGP key' => 'Clé PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestionnaire de paquets',
        'Uninstall package' => 'Désinstaller le paquet',
        'Do you really want to uninstall this package?' => 'Voulez-vous vraiment désinstaller ce paquet?',
        'Reinstall package' => 'Réinstaller le paquet',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Voulez-vous vraiment réinstaller ce paquet? Tout changement manuel sera perdu.',
        'Continue' => 'Continuer',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Installer',
        'Install Package' => 'Installer un paquet',
        'Update repository information' => 'Mettre à jour les informations du référentiel',
        'Online Repository' => 'Référentiels en ligne',
        'Module documentation' => 'Documents relatifs au module',
        'Upgrade' => 'Mise à jour',
        'Local Repository' => 'Référentiels locaux',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Désinstallation',
        'Reinstall' => 'Réinstallation',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Download package' => 'Télécharger un paquet',
        'Rebuild package' => 'Reconstruire un paquet',
        'Metadata' => 'Métadonnées',
        'Change Log' => 'Journal de modifications',
        'Date' => 'Date',
        'List of Files' => 'Liste de fichiers',
        'Permission' => 'Permission',
        'Download' => 'Téléchargement',
        'Download file from package!' => 'Télécharger le fichier à partir du paquet. ',
        'Required' => 'Obligatoire ',
        'PrimaryKey' => 'Clé primaire ',
        'AutoIncrement' => 'Augmentation automatique ',
        'SQL' => 'Requête SQL ',
        'File differences for file %s' => 'Différences de fichier pour le fichier %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Journal des performances',
        'This feature is enabled!' => 'Cette fonctionnalité est activée',
        'Just use this feature if you want to log each request.' => 'Utilisez cette fonctionnalité seulement si vous souhaitez enregistrer chacune des requêtes.',
        'Activating this feature might affect your system performance!' =>
            'Le fait d\'activer cette fonctionnalité peut perturber le rendement de votre système.',
        'Disable it here!' => 'Désactivez-la ici',
        'Logfile too large!' => 'Le fichier journal est trop grand.',
        'The logfile is too large, you need to reset it' => 'Le fichier journal est trop grand : vous devez le réinitialiser.',
        'Overview' => 'Visualisation ',
        'Range' => 'Plage',
        'last' => 'depuis',
        'Interface' => 'Interface',
        'Requests' => 'Requêtes',
        'Min Response' => 'Temps de réponse minimum',
        'Max Response' => 'Temps de réponse maximum',
        'Average Response' => 'Temps de réponse moyen',
        'Period' => 'Période',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Moyenne',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestion des filtres du maître de poste',
        'Add filter' => 'Ajouter un filtre',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'La présente fonctionnalité permet de distribuer et de filtrer les courriels entrants au moyen de leur en-tête. Elle permet aussi de faire de la correspondance de courriels au moyen d\'expressions courantes. ',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Pour faire correspondre seulement une adresse électronique, l\'inscrire dans le champ « De », « À » ou « c.c. ».',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Si vous souhaitez utiliser les expressions courantes, il est aussi possible d\'utiliser des valeurs de correspondance entre parenthèses.',
        'Delete this filter' => 'Supprimer ce filtre',
        'Add PostMaster Filter' => 'Ajouter un filtre',
        'Edit PostMaster Filter' => 'Éditer ce filtre',
        'The name is required.' => 'Vous devez entrer le nom.',
        'Filter Condition' => 'Condition de filtre',
        'AND Condition' => '',
        'Check email header' => '',
        'Negate' => '',
        'Look for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Le champ doit comporter une expression admissible ou un libellé.',
        'Set Email Headers' => 'Définir les en-têtes de courriel',
        'Set email header' => '',
        'Set value' => '',
        'The field needs to be a literal word.' => 'Ce champ doit comporter un libellé.',

        # Template: AdminPriority
        'Priority Management' => 'Gestion de la priorité',
        'Add priority' => 'Ajouter une priorité',
        'Add Priority' => 'Ajouter la priorité',
        'Edit Priority' => 'Éditer la priorité',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Create New Process' => '',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Overwrite existing entities' => '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Process name' => '',
        'Print' => 'Imprimer',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Annuler et fermer la fenêtre',
        'Go Back' => '',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => '',
        'Activity Name' => '',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => '',
        'Description (short)' => '',
        'Description (long)' => '',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'Fields' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Edit Details for Field' => '',
        'ArticleType' => '',
        'Display' => '',
        'Edit Field Details' => '',
        'Customer interface does not support internal article types.' => '',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => '',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '',
        'Filter Activities...' => '',
        'Create New Activity' => '',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => '',
        'Delete Process' => '',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'Process Name' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
        'Save settings' => '',
        'Save Activities, Activity Dialogs and Transitions' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => '',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Remove the Transition from this Process' => '',
        'No TransitionActions assigned.' => '',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => '',
        'Condition' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Configuration' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Remove this Field' => '',
        'And can\'t be repeated on the same condition.' => '',
        'Add a new Field' => '',
        'Add New Condition' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Remove this Parameter' => '',
        'Add a new Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => 'Gestion des files',
        'Add queue' => 'Ajouter une file',
        'Add Queue' => 'Ajouter une file',
        'Edit Queue' => 'Éditer une File',
        'A queue with this name already exists!' => '',
        'Sub-queue of' => 'Sous-file de ',
        'Unlock timeout' => 'Délai de déverrouillage',
        '0 = no unlock' => '0 = pas de déverrouillage',
        'Only business hours are counted.' => 'seules les plages horaires de bureau sont prises en compte.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Si un agent verrouille une demande et ne la ferme pas avant le délai de déverrouillage, la demande sera déverrouillée et sera disponible pour un autre agent.',
        'Notify by' => 'Notification après',
        '0 = no escalation' => '0 = pas de remontée de la demande',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Si une communication avec le client n\'est pas ajoutée à une nouvelle demande, soit par courriel externe soit par téléphone, avant que le délai défini ici expire, la demande sera escaladée.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Si un article est ajouté, par exemple un suivi envoyé par courriel ou inscrit sur le portail client, le moment de mise à jour de l\'escalade est réinitialisé. S\'il n\'y a pas de communication avec le client (soit par courriel externe ou par téléphone) adjointe à la demande avant que le moment défini ici expire, la demande sera escaladée.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Si la demande n\'est pas résolue avant que le délai défini ici expire, elle sera escaladée.',
        'Follow up Option' => 'Option de suivi ',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Défini si le suivi d\'une demande fermée conduira à la réouverture de celle-ci ou à l\'ouverture d\'une nouvelle demande. Si vous ne souhaitez pas activer l\'option de suivi, choisissez « Rejeter l\'option ».',
        'Ticket lock after a follow up' => 'Demande verrouillée après un suivi ',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Si un client fait un suivi sur une demande fermée, cette dernière se verrouillera systématiquement au nom de l\'ancien propriétaire.',
        'System address' => 'Adresse système ',
        'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expédition des réponses par courriel de cette file.',
        'Default sign key' => 'Clé de signature par défaut',
        'The salutation for email answers.' => 'La formule de salutation pour les réponses par courriel.',
        'The signature for email answers.' => 'La signature des réponses par courriel.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gestion des relations entre les files et les réponses automatiques',
        'Filter for Queues' => 'Filtre pour les files',
        'Filter for Auto Responses' => 'Filtre pour les réponses automatiques',
        'Auto Responses' => 'Réponses automatiques',
        'Change Auto Response Relations for Queue' => 'Modifier les réponses automatiques de la file',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRegistration
        'System Registration Management' => '',
        'Edit details' => '',
        'Show transmitted data' => '',
        'Deregister system' => '',
        'Overview of registered systems' => '',
        'System Registration' => '',
        'This system is registered with OTRS Group.' => '',
        'System type' => '',
        'Unique ID' => '',
        'Last communication with registration server' => '',
        'Send support data' => '',
        'System registration not possible' => '',
        'Please note that you can\'t register your system if your scheduler is not running correctly!' =>
            '',
        'Instructions' => '',
        'System deregistration not possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => '',
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '',
        'Read more' => '',
        'You need to log in with your OTRS-ID to register your system.' =>
            '',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            '',
        'Data Protection' => '',
        'What are the advantages of system registration?' => '',
        'You will receive updates about relevant security releases.' => '',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => '',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTRS without being registered?' => '',
        'System registration is optional.' => '',
        'You can download and use OTRS without being registered.' => '',
        'Is it possible to deregister?' => '',
        'You can deregister at any time.' => '',
        'Which data is transfered when registering?' => '',
        'A registered system sends the following data to OTRS Group:' => '',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            '',
        'Why do I have to provide a description for my system?' => '',
        'The description of the system is optional.' => '',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '',
        'How often does my OTRS system send updates?' => '',
        'Your system will send updates to the registration server at regular intervals.' =>
            '',
        'Typically this would be around once every three days.' => '',
        'In case you would have further questions we would be glad to answer them.' =>
            '',
        'Please visit our' => '',
        'portal' => '',
        'and file a request.' => '',
        'Here at OTRS Group we take the protection of your personal details very seriously and strictly adhere to data protection laws.' =>
            '',
        'All passwords are automatically made unrecognizable before the information is sent.' =>
            '',
        'Under no circumstances will any data we obtain be sold or passed on to unauthorized third parties.' =>
            '',
        'The following explanation provides you with an overview of how we guarantee this protection and which type of data is collected for which purpose.' =>
            '',
        'Data Handling with \'System Registration\'' => '',
        'Information received through the \'Service Center\' is saved by OTRS Group.' =>
            '',
        'This only applies to data that OTRS Group requires to analyze the performance and function of the OTRS server or to establish contact.' =>
            '',
        'Safety of Personal Details' => '',
        'OTRS Group protects your personal data from unauthorized access, use or publication.' =>
            '',
        'OTRS Group ensures that the personal information you store on the server is protected from unauthorized access and publication.' =>
            '',
        'Disclosure of Details' => '',
        'OTRS Group will not pass on your details to third parties unless required for business transactions.' =>
            '',
        'OTRS Group will only pass on your details to entitled public institutions and authorities if required by law or court order.' =>
            '',
        'Amendment of Data Protection Policy' => '',
        'OTRS Group reserves the right to amend this security and data protection policy if required by technical developments.' =>
            '',
        'In this case we will also adapt our information regarding data protection accordingly.' =>
            '',
        'Please regularly refer to the latest version of our Data Protection Policy.' =>
            '',
        'Right to Information' => '',
        'You have the right to demand information concerning the data saved about you, its origin and recipients, as well as the purpose of the data processing at any time.' =>
            '',
        'You can request information about the saved data by sending an e-mail to info@otrs.com.' =>
            '',
        'Further Information' => '',
        'Your trust is very important to us. We are willing to inform you about the processing of your personal details at any time.' =>
            '',
        'If you have any questions that have not been answered by this Data Protection Policy or if you require more detailed information about a specific topic, please contact info@otrs.com.' =>
            '',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => '',
        'You don\'t have an OTRS-ID yet?' => '',
        'Sign up now' => 'Enregistrez-vous maintenant',
        'Forgot your password?' => '',
        'Retrieve a new one' => '',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '',
        'Attribute' => 'Attribut',
        'FQDN' => '',
        'Optional description of this system.' => '',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '',
        'Service Center' => '',
        'Support Data Management' => '',
        'Register' => '',
        'Deregister System' => '',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => '',
        'You can modify registration settings here.' => '',
        'Overview of transmitted data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

        # Template: AdminRole
        'Role Management' => 'Gestion des rôles',
        'Add role' => 'Ajouter un rôle',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Permet de créer un rôle, d\'y ajouter des groupes et d\'attribuer ensuite ce rôle aux utilisateurs.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Il n\'y a pas de rôle défini. Utilisez le bouton « Ajouter » pour créer un nouveau rôle.',
        'Add Role' => 'Ajouter un rôle',
        'Edit Role' => 'Éditer rôle',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gestion des relations rôle-groupe',
        'Filter for Roles' => 'Filtre pour les rôles',
        'Select the role:group permissions.' => 'Sélectionner les permissions des rôles et des groupes.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Si rien n\'est sélectionné, il n\'y aura aucune permission pour ce groupe (les demandes ne seront pas accessibles pour le rôle).',
        'Change Role Relations for Group' => 'Modifier les relations des rôles pour un groupe',
        'Change Group Relations for Role' => 'Modifier les relations des groupes pour le rôle',
        'Toggle %s permission for all' => 'Sélectionner la permission %s pour tous',
        'move_into' => 'Déplacer',
        'Permissions to move tickets into this group/queue.' => 'Permission de déplacer une demande de cette file ou ce groupe.',
        'create' => 'Créer',
        'Permissions to create tickets in this group/queue.' => 'Permission de créer une demande dans cette file ou ce groupe.',
        'priority' => 'Priorité ',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permission de changer la priorité des demandes de cette file ou ce groupe.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gestion des relations agent-rôle',
        'Filter for Agents' => 'Filtre pour les agents',
        'Manage Role-Agent Relations' => 'Gestion des relations rôle-agent',
        'Change Role Relations for Agent' => 'Changer les rôles de l\'agent',
        'Change Agent Relations for Role' => 'Changer les agents du rôle :',

        # Template: AdminSLA
        'SLA Management' => 'Gestion des accords sur les niveaux de service (Service Level Agreement)',
        'Add SLA' => 'Ajouter un SLA',
        'Edit SLA' => 'Éditer le SLA',
        'Please write only numbers!' => 'Veuillez n\'utiliser que des chiffres svp.',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestion des certificats S/MIME ',
        'Add certificate' => 'Ajouter un certificat',
        'Add private key' => 'Ajouter une clé privée',
        'Filter for certificates' => 'Filtres pour les certificats',
        'Filter for S/MIME certs' => '',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Consultez aussi le ',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Vous pouvez mettre à jour la certification et les clés privées directement dans le système.',
        'Hash' => 'Algorithme de hachage',
        'Handle related certificates' => 'Gestion des certificats associés',
        'Read certificate' => '',
        'Delete this certificate' => 'Supprimer ce certificat',
        'Add Certificate' => 'Ajouter un certificat',
        'Add Private Key' => 'Ajouter une clé privée',
        'Secret' => 'Secret ',
        'Related Certificates for' => 'Certificats associés à',
        'Delete this relation' => 'Supprimer cette relation',
        'Available Certificates' => 'Certificats disponibles',
        'Relate this certificate' => 'Lie ce certificat',

        # Template: AdminSMIMECertRead
        'Close window' => 'Fermer fenêtre',
        'Certificate details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestion des formules de salutation',
        'Add salutation' => 'Ajouter une formule de salutation',
        'Add Salutation' => 'Ajouter une formule de salutation',
        'Edit Salutation' => 'Éditer une formule de salutation',
        'Example salutation' => 'Exemple de formule de salutation ',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Le mode sécurisé doit être activé.',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Normalement, le mode sécurisé sera activé lorsque l\'installation initiale sera terminée.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si le mode sécurisé n\'est pas activé, activez-le au moyen du système de configuration car votre application est déjà en fonction.',

        # Template: AdminSelectBox
        'SQL Box' => 'Requêtes SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            '',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Votre requête SQL comporte une erreur de syntaxe. Veuillez la corriger.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Il manque au moins un paramètre, ce qui empêche l\'association. Veuillez corriger la situation.',
        'Result format' => 'Format du résultat ',
        'Run Query' => 'Lancer la requête',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => 'Gestion des services',
        'Add service' => 'Ajouter un service',
        'Add Service' => 'Ajouter un service',
        'Edit Service' => 'Éditer le service ',
        'Sub-service of' => 'Sous-service de ',

        # Template: AdminServiceCenterSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Currently this data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',
        'The support bundle has been generated.' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => '',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => 'Informations',

        # Template: AdminSession
        'Session Management' => 'Gestion des sessions',
        'All sessions' => 'Toutes les sessions ',
        'Agent sessions' => 'Sessions des agents ',
        'Customer sessions' => 'Sessions des clients ',
        'Unique agents' => 'Agents seuls ',
        'Unique customers' => 'Clients seuls ',
        'Kill all sessions' => 'Supprimer toutes les sessions',
        'Kill this session' => 'Supprimer cette session',
        'Session' => 'Session',
        'Kill' => 'Supprimer',
        'Detail View for SessionID' => 'Vue détaillée pour l\'identification de la session',

        # Template: AdminSignature
        'Signature Management' => 'Gestion des signatures',
        'Add signature' => 'Ajouter une signature',
        'Add Signature' => 'Ajouter une signature',
        'Edit Signature' => 'Éditer une signature',
        'Example signature' => 'Exemple de signature',

        # Template: AdminState
        'State Management' => 'Gestion des états',
        'Add state' => 'Ajouter un état',
        'Please also update the states in SysConfig where needed.' => 'Veuillez également mettre les états à jour dans la configuration du système.',
        'Add State' => 'Ajouter un état',
        'Edit State' => 'Éditer un état',
        'State type' => 'Type d\'état de la demande ',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuration du système',
        'Navigate by searching in %s settings' => 'Naviguer en cherchant parmi les %s réglages.',
        'Navigate by selecting config groups' => 'Naviguer en sélectionnant des groupes de réglages.',
        'Download all system config changes' => 'Télécharger toutes les modifications de configuration du système',
        'Export settings' => 'Exporter des réglages',
        'Load SysConfig settings from file' => 'Charger la configuration du système à partir du fichier',
        'Import settings' => 'Importer les réglages',
        'Import Settings' => 'Importer les réglages',
        'Please enter a search term to look for settings.' => 'Pour trouver de l\'information sur la configuration, veuillez inscrire un terme de recherche.',
        'Subgroup' => 'Sous-groupe',
        'Elements' => 'Éléments',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Mettre à jour les paramètres de configuration',
        'This config item is only available in a higher config level!' =>
            'Cet élément de configuration n\'est disponible que dans un niveau supérieur de configuration',
        'Reset this setting' => 'Réinitialiser cet élément',
        'Error: this file could not be found.' => 'Erreur : ce fichier ne peut pas être trouvé',
        'Error: this directory could not be found.' => 'Erreur : ce répertoire ne peut pas être trouvé',
        'Error: an invalid value was entered.' => 'Erreur : valeur incorrecte',
        'Content' => 'Contenu',
        'Remove this entry' => 'Supprimer cette entrée',
        'Add entry' => 'Ajouter une entrée',
        'Remove entry' => 'Supprimer l\'entrée',
        'Add new entry' => 'Ajouter une nouvelle entrée',
        'Delete this entry' => 'Supprimer cette entrée',
        'Create new entry' => 'Créer une nouvelle entrée',
        'New group' => 'Nouveau groupe',
        'Group ro' => 'Groupe en lecture seule ',
        'Readonly group' => 'Groupe en lecture seule ',
        'New group ro' => 'Nouveau groupe en lecture seule',
        'Loader' => 'Chargeur ',
        'File to load for this frontend module' => 'Fichier à charger pour ce module d\'avant-plan',
        'New Loader File' => 'Nouveau fichier de chargeur',
        'NavBarName' => 'Nom de la barre de navigation ',
        'NavBar' => 'Barre de navigation ',
        'LinkOption' => 'Option de lien ',
        'Block' => 'Ensemble ',
        'AccessKey' => 'Accès clavier ',
        'Add NavBar entry' => 'Ajouter une entrée de barre de navigation',
        'Year' => 'Année',
        'Month' => 'Mois',
        'Day' => 'Jour',
        'Invalid year' => 'Année incorrecte',
        'Invalid month' => 'Mois incorrect',
        'Invalid day' => 'Jour incorrect',
        'Show more' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestion des adresses électroniques du système',
        'Add system address' => 'Ajouter une adresse dans le système',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Tous les courriels entrants qui affichent cette adresse dans les champs « À » ou « cc » seront classés dans la file sélectionnée.',
        'Email address' => 'Adresse électronique ',
        'Display name' => 'Nom à afficher ',
        'Add System Email Address' => 'Ajouter une adresse électronique dans le système',
        'Edit System Email Address' => 'Editer l\'adresse de messagerie du système',
        'The display name and email address will be shown on mail you send.' =>
            'Les courriels que vous envoyez afficheront l\'adresse électronique et le nom inscrits.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '',
        'Schedule New System Maintenance' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Start date' => '',
        'Stop date' => '',
        'Delete System Maintenance' => '',
        'Do you really want to delete this scheduled system maintenance?' =>
            '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => '',
        'Edit System Maintenance information' => '',
        'Date invalid!' => 'Date invalide',
        'Login message' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, exept current' => '',

        # Template: AdminTemplate
        'Manage Templates' => '',
        'Add template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Add Template' => '',
        'Edit Template' => '',
        'A standard template with this name already exists!' => '',
        'Template' => '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'L\'état actuel de la demande est',
        'Your email address is' => 'Votre adresse de courrier électronique est',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => 'Filtre pour les pièces jointes',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Sélectionner actif pour tous',
        'Link %s to selected %s' => 'Lier %s à la sélection %s ',

        # Template: AdminType
        'Type Management' => 'Gestion des types',
        'Add ticket type' => 'Ajouter un type de demande',
        'Add Type' => 'Ajouter un type',
        'Edit Type' => 'Éditer un type',
        'A type with this name already exists!' => '',

        # Template: AdminUser
        'Add agent' => 'Ajouter un agent',
        'Agents will be needed to handle tickets.' => 'Les demandes devront être gérées par des agents.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'N\'oubliez pas d\'ajouter un agent aux groupes et aux rôles.',
        'Please enter a search term to look for agents.' => 'Merci d\'entrer un terme de recherche pour chercher des agents',
        'Last login' => 'Dernière connexion',
        'Switch to agent' => 'Changer pour l\'agent : ',
        'Add Agent' => 'Ajouter un agent',
        'Edit Agent' => 'Modifier l\'agent',
        'Firstname' => 'Prénom ',
        'Lastname' => 'Nom ',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '',
        'Start' => 'Début ',
        'End' => 'Fin ',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gestion des relations agent-groupe',
        'Change Group Relations for Agent' => 'Changer les relations de groupe pour l\'agent : ',
        'Change Agent Relations for Group' => 'Changer les relations avec les agents pour le groupe : ',
        'note' => 'Note',
        'Permissions to add notes to tickets in this group/queue.' => 'Permission d\'ajouter des notes aux demandes de cette file ou ce groupe. ',
        'owner' => 'Propriétaire',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permission de changer le propriétaire des demandes de cette file ou ce groupe. ',

        # Template: AgentBook
        'Address Book' => 'Carnet d\'adresses',
        'Search for a customer' => 'Recherche d\'un client',
        'Add email address %s to the To field' => 'Ajouter l\'adresse courriel %s au champ « destinataire »',
        'Add email address %s to the Cc field' => 'Ajouter l\'adresse courriel %s au champ « Copie conforme »',
        'Add email address %s to the Bcc field' => 'Ajouter l\'adresse courriel %s au champ « en copie cachée »',
        'Apply' => 'Appliquer',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Client utilisateur ',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Dédoublement d\'une entrée',
        'This address already exists on the address list.' => 'Cette adresse est déjà dans la liste.',
        'It is going to be deleted from the field, please try again.' => 'Cela va être supprimé du champ. Veuillez ré-éssayer',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '',

        # Template: AgentDashboard
        'Dashboard' => 'Tableau de bord',

        # Template: AgentDashboardCalendarOverview
        'in' => 'dans',

        # Template: AgentDashboardCommon
        'Available Columns' => '',
        'Visible Columns (order by drag & drop)' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        'Start Chat' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',
        'Start chat' => '',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s est accessible.',
        'Please update now.' => 'Veuillez mettre à jour maintenant.',
        'Release Note' => 'Instructions d\'utilisation',
        'Level' => 'Niveau ',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Envoyé il y a %s',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'Grouped' => '',
        'Stacked' => '',
        'Expanded' => '',
        'Stream' => '',
        'CSV' => 'CSV',
        'PDF' => '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mes demandes verrouillées',
        'My watched tickets' => 'Mes demandes sous surveillance',
        'My responsibilities' => 'Mes responsabilités',
        'Tickets in My Queues' => 'Demandes dans mes files',
        'Tickets in My Services' => '',
        'Service Time' => 'Délai du service',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'La demande a été verrouillée',
        'Undo & close window' => 'Annuler et fermer la fenêtre',

        # Template: AgentInfo
        'Info' => 'Information',
        'To accept some news, a license or some changes.' => 'Pour accepter des nouvelles, une licence ou des modifications.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Lier l\'objet : %s',
        'go to link delete screen' => 'Aller au lien vers l\'écran de suppression',
        'Select Target Object' => 'Sélectionner l\'objet ciblé',
        'Link Object' => 'Lier l\'objet',
        'with' => 'avec ',
        'Unlink Object: %s' => 'Délier l\'objet : %s',
        'go to link add screen' => 'Aller au lien ajout écran',

        # Template: AgentPreferences
        'Edit your preferences' => 'Éditer vos préférences',

        # Template: AgentSchedulerInfo
        'General Information' => '',
        'Scheduler is an OTRS separated process that perform asynchronous tasks' =>
            'L’ordonnanceur est un processus distinct de OTRS qui exécute des tâches asynchrones',
        '(e.g. Generic Interface asynchronous invoker tasks)' => '(p. ex. Les tâches asynchrones du demandeur de l’interface générique)',
        'It is necessary to have the Scheduler running to make the system work correctly!' =>
            '',
        'Starting Scheduler' => '',
        'Make sure that %s exists (without .dist extension)' => '',
        'Check that cron deamon is running in the system' => '',
        'Confirm that OTRS cron jobs are running, execute %s start' => '',

        # Template: AgentSpelling
        'Spell Checker' => 'Vérificateur orthographique',
        'spelling error(s)' => 'erreurs d\'orthographe',
        'Apply these changes' => 'Appliquer ces changements',

        # Template: AgentStatsDelete
        'Delete stat' => 'Supprimer la statistique',
        'Do you really want to delete this stat?' => 'Voulez-vous vraiment supprimer cette statistique?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Étape %s',
        'General Specifications' => 'Caractéristiques générales',
        'Select the element that will be used at the X-axis' => 'Sélectionnez l\'élément qui sera utilisé pour l\'axe X',
        'Select the elements for the value series' => 'Sélectionnez les éléments des séries de données',
        'Select the restrictions to characterize the stat' => 'Sélectionnez des restrictions pour définir cette statistique',
        'Here you can make restrictions to your stat.' => 'Vous pouvez ici apporter des restrictions à vos statistiques.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Pour permettre à l\'agent qui génère les statistiques de changer les caractéristiques d\'un élément, décocher la case « Figer » correspondante.',
        'Fixed' => 'Figer',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Veuillez ne sélectionner qu\'un seul élément ou désactiver le bouton « Figer ».',
        'Absolute Period' => 'Période absolue ',
        'Between' => 'entre le',
        'Relative Period' => 'Période relative ',
        'The last' => 'depuis',
        'Finish' => 'Terminer',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permissions ',
        'You can select one or more groups to define access for different agents.' =>
            'Afin de donner des accès à différents agents, sélectionnez un ou plusieurs groupes.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Des formats de résultats sont désactivés parce qu\'un ou plusieurs paquets ne sont pas installés.',
        'Please contact your administrator.' => 'Veuillez communiquer avec votre administrateur.',
        'Graph size' => 'Taille du graphique ',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Pour les formats graphiques, veuillez préciser la taille.',
        'Sum rows' => 'Lignes des totaux ',
        'Sum columns' => 'Colonnes des totaux ',
        'Use cache' => 'Utiliser le cache ',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Un grand nombre de statistiques peut être emmagasiné en cache et ainsi accélérer l\'affichage de cette statistique.',
        'Show as dashboard widget' => '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '',
        'Please note' => '',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            '',
        'IE8 doesn\'t support statistics dashboard widgets.' => '',
        'If set to invalid end users can not generate the stat.' => 'Si l\'option « non admissible » est choisie, les utilisateurs finaux ne pourront pas générer les statistiques.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'La présente étape vous permet de choisir les éléments qui composeront les séries de données.',
        'You have the possibility to select one or two elements.' => 'Vous êtes libre de choisir un ou deux éléments. ',
        'Then you can select the attributes of elements.' => 'Ensuite, vous choisissez les attributs souhaités de ces éléments.',
        'Each attribute will be shown as single value series.' => 'Chacun des attributs sera affiché en tant que série de données.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Si aucun attribut n\'est choisi, tous les attributs de l\'élément sélectionné seront utilisés lors de la génération de statistiques, ainsi que tous les nouveaux attributs qui seront ajoutés par la suite.',
        'Scale' => 'Échelle de l\'axe X ',
        'minimal' => 'minimale',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Rappelez-vous que l\'échelle de la série de données doit être plus grande que l\'échelle de l\'axe X (exemple : axe des X => Mois, Série => Année)',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'La présente étape vous permet de caractériser l\'axe X. Sélectionnez un élément au moyen des boutons d\'option.',
        'maximal period' => 'période maximale',
        'minimal scale' => 'échelle minimale',

        # Template: AgentStatsImport
        'Import Stat' => 'Importer une statistique',
        'File is not a Stats config' => 'Ce n\'est pas un fichier de configuration de statistiques',
        'No File selected' => 'Aucun fichier n\'est sélectionné',

        # Template: AgentStatsOverview
        'Stats' => 'Statistiques',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Aucun élément n\'est sélectionné.',

        # Template: AgentStatsView
        'Export config' => 'Exporter la configuration',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Grâce aux champs de saisie et de sélection, vous pouvez adapter le format et le contenu des statistiques.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'L\'administrateur des statistiques détermine précisément quels sont les champs adaptables.',
        'Stat Details' => 'Caractéristiques de la statistique',
        'Format' => 'Format ',
        'Graphsize' => 'Taille du graphique',
        'Cache' => 'Cache ',
        'Exchange Axis' => 'Échangez les axes',

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Paramètres des statistiques configurables',
        'No element selected.' => 'Aucun élément n\'est sélectionné.',
        'maximal period from' => 'Période maximale depuis',
        'to' => 'vers',
        'not changable for dashboard statistics' => '',
        'Select Chart Type' => '',
        'Chart Type' => '',
        'Multi Bar Chart' => '',
        'Multi Line Chart' => '',
        'Stacked Area Chart' => '',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Modifier le texte libre de la demande no ',
        'Change Owner of Ticket' => 'Modifier le propriétaire de la demande no ',
        'Close Ticket' => 'Fermeture de la demande no ',
        'Add Note to Ticket' => 'Ajouter une note à la demande no ',
        'Set Pending' => 'Définir la mise en attente de la demande no ',
        'Change Priority of Ticket' => 'Modifier la priorité de la demande no ',
        'Change Responsible of Ticket' => 'Modifier le responsable de la demande',
        'All fields marked with an asterisk (*) are mandatory.' => '',
        'Service invalid.' => 'Service non admissible.',
        'New Owner' => 'Nouveau propriétaire ',
        'Please set a new owner!' => 'Veuillez configurer un nouveau propriétaire.',
        'Previous Owner' => 'Propriétaire précédent ',
        'Next state' => 'Nouvel état ',
        'For all pending* states.' => '',
        'Add Article' => '',
        'Create an Article' => '',
        'Spell check' => 'Vérifier L\'orthographe',
        'Text Template' => '',
        'Setting a template will overwrite any text or attachment.' => '',
        'Note type' => 'Type de note ',
        'Inform Agent' => 'Informer l\'agent',
        'Optional' => 'Optionnel',
        'Inform involved Agents' => 'Informer les agents impliqués',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Note will be (also) received by:' => '',

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Retourner la demande',
        'Bounce to' => 'Retourner à',
        'You need a email address.' => 'Vous devez avoir une adresse électronique.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Une adresse électronique valide est nécessaire. N\'utilisez pas d\'adresse électronique locale.',
        'Next ticket state' => 'Prochain état de la demande ',
        'Inform sender' => 'Informer l\'expéditeur ',
        'Send mail' => 'Envoyer le courriel',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Action groupée des demandes',
        'Send Email' => 'Envoyer le courriel',
        'Merge to' => 'Fusionner avec',
        'Invalid ticket identifier!' => 'Identificateur de demande invalide.',
        'Merge to oldest' => 'Fusionner avec le plus ancien',
        'Link together' => 'Lier ensemble',
        'Link to parent' => 'Lier au parent',
        'Unlock tickets' => 'Déverrouiller les demandes',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Rédiger une réponse à la demande no ',
        'Please include at least one recipient' => 'Merci d\'inclure au moins un destinataire',
        'Remove Ticket Customer' => 'Retirer la demande du client',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Merci de retirer cette entrée et de la remplacer par une valeur correcte.',
        'Remove Cc' => 'Retirer le Cc',
        'Remove Bcc' => 'Retirer le Bcc',
        'Address book' => 'Carnet d\'adresse',
        'Date Invalid!' => 'Date invalide',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Modifier le client de la demande no ',
        'Customer user' => 'Client utilisateur ',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Créer une nouvelle demande courriel',
        'Example Template' => '',
        'From queue' => 'De la file ',
        'To customer user' => '',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Tout prendre',

        # Template: AgentTicketEmailOutbound
        'E-Mail Outbound' => '',

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Transférer la demande no : %s - %s',

        # Template: AgentTicketHistory
        'History of' => 'Historique de la',
        'History Content' => 'Contenu de l\'historique',
        'Zoom view' => 'Vue de la synthèse',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Fusion de la demande no ',
        'You need to use a ticket number!' => 'Vous devez inscrire un numéro de demande.',
        'A valid ticket number is required.' => 'Le numéro de demande doit être valide.',
        'Need a valid email address.' => 'L\'adresse de courrier électronique doit être valide.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Déplacer la demande',
        'New Queue' => 'Nouvelle file',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Tout sélectionner',
        'No ticket data found.' => 'Aucune donnée relative à la demande n\'a été trouvée.',
        'Select this ticket' => '',
        'First Response Time' => 'Délai de la première réponse',
        'Update Time' => 'Délai de mise à jour ',
        'Solution Time' => 'Délai de résolution ',
        'Move ticket to a different queue' => 'Déplacer la demande vers une autre file',
        'Change queue' => 'Changer de file',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Modifier les options de recherche',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Demandes par page ',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',
        'Column Filters Form' => '',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'Créer une nouvelle demande téléphonique',
        'Please include at least one customer for the ticket.' => 'Veuillez ajouter au moins un client à la demande.',
        'To queue' => 'Vers la file ',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Vue complète du courriel',
        'Plain' => 'Normal',
        'Download this email' => 'Télécharger ce courriel',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Renseignements sur la demande',
        'Accounted time' => 'Temps alloué ',
        'Linked-Object' => 'Objet lié',
        'by' => 'par',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Search template' => 'Modèle de recherche ',
        'Create Template' => 'Créer Modèle',
        'Create New' => 'Créer nouveau',
        'Profile link' => 'Lien vers le profil',
        'Save changes in template' => 'Sauvegarder les modifications du modèle',
        'Filters in use' => '',
        'Additional filters' => '',
        'Add another attribute' => 'Ajouter un autre attribut ',
        'Output' => 'Format du résultat ',
        'Fulltext' => 'Texte complet ',
        'Remove' => 'Supprimer',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Nom de connexion du client',
        'Attachment Name' => '',
        '(e. g. m*file or myfi*)' => '',
        'Created in Queue' => 'Créée dans la file ',
        'Lock state' => 'État du verrou ',
        'Watcher' => 'Surveillance',
        'Article Create Time (before/after)' => 'Moment de la création de l\'article (avant/après) ',
        'Article Create Time (between)' => 'Moment de la création de l\'article (entre) ',
        'Ticket Create Time (before/after)' => 'Moment de la création de la demande (avant/après) ',
        'Ticket Create Time (between)' => 'Moment de la création de la demande (entre) ',
        'Ticket Change Time (before/after)' => 'Moment de la modification de la demande (avant/après) ',
        'Ticket Change Time (between)' => 'Moment de la modification de la demande (entre) ',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Moment de la fermeture de la demande (avant/après) ',
        'Ticket Close Time (between)' => 'Moment de la fermeture de la demande (entre) ',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Recherche dans les archives',
        'Run search' => 'Exécuter la recherche',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtre pour les articles',
        'Article Type' => 'Type d\'article',
        'Sender Type' => 'Type d\'expéditeur',
        'Save filter settings as default' => 'Sauvegarder les paramètres des filtres en tant que paramètres par défaut',
        'Event Type Filter' => '',
        'Event Type' => '',
        'Save as default' => '',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Locked' => 'Verrou ',
        'Linked Objects' => 'Objets liés',
        'Change Queue' => 'Changer de file',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Ticket Timeline View' => '',
        'Article Overview' => '',
        'Article(s)' => 'Article(s)',
        'Page' => 'Page ',
        'Add Filter' => 'Ajouter un filtre',
        'Set' => 'Définir',
        'Reset Filter' => 'Réinitialiser le filtre',
        'Show one article' => 'Afficher un article',
        'Show all articles' => 'Afficher tous les articles',
        'Show Ticket Timeline View' => '',
        'Unread articles' => 'Articles non lus',
        'No.' => 'No',
        'Important' => 'Important',
        'Unread Article!' => 'Article non lu.',
        'Incoming message' => 'Message entrant',
        'Outgoing message' => 'Message sortant',
        'Internal message' => 'Message interne',
        'Resize' => 'Redimensionner',
        'Mark this article as read' => '',
        'Show Full Text' => '',
        'Full Article Text' => '',
        'No more events found. Please try changing the filter settings.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Pour protéger votre vie privée, les contenus distants ont été bloqués.',
        'Load blocked content.' => 'Charger le contenu bloqué',

        # Template: ChatStartForm
        'First message' => '',

        # Template: CustomerError
        'Traceback' => 'Traçage',

        # Template: CustomerFooter
        'Powered by' => 'Alimenté par ',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Une ou plusieurs erreurs se sont produites!',
        'Close this dialog' => 'Fermer cette fenêtre de dialogue',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'La fenêtre contextuelle n\'a pas pu s\'ouvrir. Veuillez désactiver le bloqueur de fenêtres contextuelles pour cette application.',
        'There are currently no elements available to select from.' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'The browser you are using is too old.' => 'Votre navigateur est trop ancien.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS utilise un grand nombre de navigateurs; veuillez utiliser l\'un de ceux-ci.',
        'Please see the documentation or ask your admin for further information.' =>
            'Pour de plus amples renseignements, veuillez consulter la documentation ou communiquer avec à votre administrateur système.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript indisponible',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Pour utiliser OTRS, vous devez activer le JavaScript dans votre navigateur.',
        'Browser Warning' => 'Avertissement du navigateur',
        'One moment please, you are being redirected...' => '',
        'Login' => 'S\'authentifier',
        'User name' => 'Nom d\'utilisateur',
        'Your user name' => 'Votre nom d\'utilisateur',
        'Your password' => 'Votre mot de passe',
        'Forgot password?' => 'Mot de passe oublié?',
        'Log In' => 'Se connecter',
        'Not yet registered?' => 'Pas encore inscrit?',
        'Request new password' => 'Demande un nouveau mot de passe',
        'Your User Name' => 'Votre nom d\'utilisateur',
        'A new password will be sent to your email address.' => 'Un nouveau mot de passe sera envoyé à votre adresse électronique.',
        'Create Account' => 'Créer un compte',
        'Please fill out this form to receive login credentials.' => 'Veuillez remplir ce formulaire pour recevoir les justificatifs d\'identité permettant de se connecter.',
        'How we should address you' => 'Titre de civilité',
        'Your First Name' => 'Prénom',
        'Your Last Name' => 'Nom de famille',
        'Your email address (this will become your username)' => 'Votre adresse électronique (vous utiliserez celle-ci comme nom d\'utilisateur)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '',
        'You have unanswered chat requests' => '',
        'Edit personal preferences' => 'Éditer les préférences',

        # Template: CustomerRichTextEditor
        'Split Quote' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Accord de niveau de service',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bienvenue !',
        'Please click the button below to create your first ticket.' => 'Veuillez cliquer sur le bouton ci-dessous pour créer votre première demande.',
        'Create your first ticket' => 'Créer votre première demande',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Imprimer la demande',
        'Ticket Dynamic Fields' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'p. ex. 10*5155 ou 105658*',
        'Customer ID' => 'Identité du client',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Recherche plein texte dans les demandes (p. ex. "Laetitia*v" ou Emmanuel*")',
        'Carbon Copy' => 'Copie carbone',
        'e. g. m*file or myfi*' => '',
        'Types' => 'Types',
        'Time restrictions' => 'Restrictions de temps',
        'No time settings' => 'Pas de réglages de temps',
        'Only tickets created' => 'Seulement les demandes créées',
        'Only tickets created between' => 'Seulement les demandes créées entre',
        'Ticket archive system' => 'Système d\'archivage des demandes',
        'Save search as template?' => 'Sauvegarder la recherche comme modèle?',
        'Save as Template?' => 'Sauvegarder comme modèle',
        'Save as Template' => 'Sauver comme Modèle',
        'Template Name' => 'Nom de modèle',
        'Pick a profile name' => 'Choisir un nom de profil',
        'Output to' => 'Sortie vers',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Search Results for' => 'Résultats de recherche pour',
        'Remove this Search Term.' => 'Supprimer ce terme de recherche.',

        # Template: CustomerTicketZoom
        'Expand article' => 'Développer l\'article',
        'Next Steps' => '',
        'Reply' => 'Répondre',

        # Template: DashboardEventsTicketCalendar
        'All-day' => '',
        'Sunday' => 'Dimanche',
        'Monday' => 'Lundi',
        'Tuesday' => 'Mardi',
        'Wednesday' => 'Mercredi',
        'Thursday' => 'Jeudi',
        'Friday' => 'Vendredi',
        'Saturday' => 'Samedi',
        'Su' => 'Di',
        'Mo' => 'Lu',
        'Tu' => 'Ma',
        'We' => 'Me',
        'Th' => 'Je',
        'Fr' => 'Ve',
        'Sa' => 'Sa',
        'Event Information' => '',
        'Ticket fields' => '',
        'Dynamic fields' => '',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Date non valide (besoin d\'une date ultérieure).',
        'Invalid date (need a past date)!' => '',
        'Previous' => 'Précédent',
        'Open date selection' => 'Sélection de la date d\'ouverture',

        # Template: Error
        'Oops! An Error occurred.' => 'Oups! Une erreur est survenue.',
        'You can' => 'Vous pouvez',
        'Send a bugreport' => 'Envoyer un rapport d\'erreur',
        'go back to the previous page' => 'Revenir à la page précédente',
        'Error Details' => 'Détails de l\'erreur',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Si vous quittez cette page maintenant, toutes les fenêtres contextuelles seront également fermées!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Une fenêtre contextuelle de cet écran est déjà ouverte. Désirez-vous la fermer et télécharger celle-ci à la place?',
        'Please enter at least one search value or * to find anything.' =>
            'Veuillez entrer au moins un critère de recherche ou une « * » pour trouver quoi que ce soit.',
        'Please check the fields marked as red for valid inputs.' => '',
        'Please perform a spell check on the the text first.' => '',
        'Slide the navigation bar' => '',

        # Template: Header
        'You are logged in as' => 'Vous êtes connecté en tant que',
        'There are new chat requests available. Please visit the chat manager.' =>
            '',

        # Template: Installer
        'JavaScript not available' => 'JavaScript non disponible',
        'Database Settings' => 'Réglages de la base de données',
        'General Specifications and Mail Settings' => 'Caractéristiques générales et réglages de courriel',
        'Web site' => 'Site Web',
        'Mail check successful.' => 'Contrôle de courriel effectué avec succès.',
        'Error in the mail settings. Please correct and try again.' => 'Erreur dans la configuration courriel. Veuillez corriger la configuration et réessayer.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurer le courriel sortant',
        'Outbound mail type' => 'Type de courriel sortant',
        'Select outbound mail type.' => 'Sélectionner le type de courriel sortant.',
        'Outbound mail port' => 'Port de courriel sortant',
        'Select outbound mail port.' => 'Sélectionner le port de courriel sortant',
        'SMTP host' => 'Hôte SMTP',
        'SMTP host.' => 'Hôte SMTP.',
        'SMTP authentication' => 'Authentification SMTP',
        'Does your SMTP host need authentication?' => 'Est-ce-que votre hôte SMTP requiert une authentification?',
        'SMTP auth user' => 'Utilisateur de l\'authentification SMTP',
        'Username for SMTP auth.' => 'Nom utilisateur pour l\'authentification SMTP.',
        'SMTP auth password' => 'Mot de passe de l\'authentification SMTP',
        'Password for SMTP auth.' => 'Mot de passe pour l\'authentification SMTP.',
        'Configure Inbound Mail' => 'Configurer le courriel entrant',
        'Inbound mail type' => 'Type de courriel entrant',
        'Select inbound mail type.' => 'Sélectionner le type de courriel entrant',
        'Inbound mail host' => 'Hôte de courriel entrant',
        'Inbound mail host.' => 'Hôte de courriel entrant.',
        'Inbound mail user' => 'utilisateur du courriel entrant',
        'User for inbound mail.' => 'utilisateur pour le courriel entrant.',
        'Inbound mail password' => 'Mot de passe de courriel entrant',
        'Password for inbound mail.' => 'Mot de passe pour courriel entrant.',
        'Result of mail configuration check' => 'Résultat du contrôle de configuration de courriel',
        'Check mail configuration' => 'Vérifier la configuration courriel',
        'Skip this step' => 'Passer cette étape',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Configuration de la base de données réussie.',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => 'Vérifier la configuration de la base de données',
        'Result of database check' => 'Résultat du contrôle de la base de données',
        'Database check successful.' => 'Contrôle de base de donnée effectué avec succès.',
        'Database User' => '',
        'New' => 'Nouvelle',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Un nouvel utilisateur de la base de données avec des droits limités sera créé pour ce système OTRS.',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Pour pouvoir utiliser OTRS, vous devez entrer les commandes suivantes (Terminal ou Shell) en tant que segment résident.',
        'Restart your webserver' => 'Redémarrer votre serveur Web',
        'After doing so your OTRS is up and running.' => 'Après cela votre OTRS sera opérationnel.',
        'Start page' => 'Page de démarrage',
        'Your OTRS Team' => 'Votre Équipe OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Ne pas accepter la licence',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'L\'identifiant du système. Chaque numéro de demande et chaque identité de session HTTP contiennent ce numéro.',
        'System FQDN' => 'Serveur de nom de domaine complet du système',
        'Fully qualified domain name of your system.' => 'Nom de domaine complet de votre système',
        'AdminEmail' => 'Adresse électronique de l\'administrateur.',
        'Email address of the system administrator.' => 'L\'adresse électronique de l\'administrateur de votre système.',
        'Organization' => 'Entreprise ',
        'Log' => 'Journal',
        'LogModule' => 'Module de journalisation',
        'Log backend to use.' => 'Journal à utiliser',
        'LogFile' => 'Fichier journal',
        'Webfrontend' => 'L\'avant-plan Web',
        'Default language' => 'Langue par défaut',
        'Default language.' => 'Langue par défaut.',
        'CheckMXRecord' => 'Vérifier les enregistrements messager',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Les adresses électroniques entrées manuellement sont contrevérifiées avec les enregistrements message du serveur de nom de domaine. N\'utilisez pas cette option si votre serveur de nom de domaine est lent ou qu\'il ne résout pas les adresses publiques.',

        # Template: LinkObject
        'Object#' => 'Objet no ',
        'Add links' => 'Ajouter les liens',
        'Delete links' => 'Supprimer les liens',

        # Template: Login
        'Lost your password?' => 'Mot de passe oublié ?',
        'Request New Password' => 'Demander un nouveau mot de passe',
        'Back to login' => 'Retour à la page d\'ouverture de session',

        # Template: Motd
        'Message of the Day' => 'Message du jour',

        # Template: NoPermission
        'Insufficient Rights' => 'Droits insuffisants',
        'Back to the previous page' => 'Revenir à la page précédente',

        # Template: Pagination
        'Show first page' => 'Afficher la première page',
        'Show previous pages' => 'Afficher les pages précédentes',
        'Show page %s' => 'Afficher la page %s',
        'Show next pages' => 'Afficher les pages suivantes',
        'Show last page' => 'Afficher la dernière page',

        # Template: PictureUpload
        'Need FormID!' => 'Vous devez posséder un formulaire d\'identification.',
        'No file found!' => 'Aucun fichier n\'a été trouvé.',
        'The file is not an image that can be shown inline!' => 'Le fichier n\'est pas une image pouvant être affichée en ligne.',

        # Template: PrintHeader
        'printed by' => 'Imprimé par :',

        # Template: Test
        'OTRS Test Page' => 'Page de test de OTRS',
        'Counter' => 'Compteur',

        # Template: Warning
        'Go back to the previous page' => 'Revenir à la page précédente',

        # SysConfig
        ' (work units)' => '',
        '"%s"-notification sent to "%s".' => '%s-notification envoyée à "%s".',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => 'Temps passé sur l\'action: %s . Total du temps passé pour cette demande: %s unité(s).',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Le module ACL permet la fermeture des demandes parents uniquement si les demandes enfants sont déjà fermées (l\' « État » affiche quels sont les états qui ne peuvent être accessibles pour les demandes parents jusqu\'à ce que l\'ensemble des demandes enfants soient fermées).',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Active le clignotement de la file qui contient la demande la plus ancienne.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Active la fonction « mot de passe perdu » pour les agents, dans l\'interface des agents.',
        'Activates lost password feature for customers.' => 'Active la fonction « mot de passe perdu » pour les clients.',
        'Activates support for customer groups.' => 'Active le soutien pour les groupes de clients.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Active le filtre des articles dans la vue de la synthèse afin de désigner quels articles doivent être affichés.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Active les thèmes accessibles dans le système. La valeur « 1 » signifie « actif » et la valeur « 0 » signifie « inactif ».',
        'Activates the ticket archive system search in the customer interface.' =>
            'Active l\'outil de recherche dans l\'archivage des demandes de l\'interface client.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Active la fonction d\'archivage des demandes pour accélérer le système en déplaçant des demandes qui ne sont pas du jour. Pour rechercher vos demandes, activez l\'indicateur d\'archivage dans la boîte de recherche.',
        'Activates time accounting.' => 'Active la comptabilisation du temps.',
        'ActivityID' => '',
        'Added email. %s' => 'Ajout d\'une adresse électronique. %s',
        'Added link to ticket "%s".' => 'Ajout d\'un lien vers la demande "%s".',
        'Added note (%s)' => 'Ajout d\'une note (%s)',
        'Added subscription for user "%s".' => 'Abonnement pour l\'utilisateur "%s".',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Ajoute un suffixe comprenant l\'année et le mois en cours au fichier d\'enregistrement de OTRS. Un fichier d\'enregistrement est créé à chaque mois.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Ajoute les jours de congé ponctuels au calendrier désigné. Utilisez un seul caractère numérique pour les chiffres de 1 à 9 (ne pas inscrire 01 à 09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Ajoute les jours de congé ponctuels. Utilisez un seul caractère numérique pour les chiffres de 1 à 9 (ne pas inscrire 01 à 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Ajoute les jours de congé permanents au calendrier désigné. Utilisez un seul caractère numérique pour les chiffres de 1 à 9 (ne pas inscrire 01 à 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Ajoute les jours de congé permanents. Utilisez un seul caractère numérique pour les chiffres de 1 à 9 (ne pas inscrire 01 à 09).',
        'Agent Notifications' => 'Notifications pour les agents',
        'Agent called customer.' => 'L\'agent a appellé le client.',
        'Agent interface article notification module to check PGP.' => 'Module de notification des articles dans l\'interface agent pour vérifier les clés PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Module de notification des articles dans l\'interface agent pour vérifier les certificats S/MIME.',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Module de l\'interface agent pour accéder à la recherche plein texte dans la barre de navigation.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Module de l\'interface agent pour accéder à la recherche des profils dans la barre de navigation.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Module de l\'interface agent pour voir dans les courriels entrants si la clé S/MIME est accessible et vraie au moyen de la vue de la synthèse de la demande .',
        'Agent interface notification module to see the number of locked tickets.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Module de notification dans l\'interface agent pour voir le nombre de demandes dont un agent est responsable.',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Module de notification dans l\'interface agent pour voir le nombre de demandes sous surveillance.',
        'Agents <-> Groups' => 'Agents <-> Groupes',
        'Agents <-> Roles' => 'Agents <-> Rôles',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permet aux agents d\'intervertir les axes après avoir généré une statistique.',
        'Allows agents to generate individual-related stats.' => 'Permet aux agents de générer des statistiques relatives à une personne.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permet le choix d\'afficher les pièces jointes d\'une demande dans le navigateur (en file) ou de faire en sorte quelles soient téléchargeables.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permet de choisir le prochain état des demandes des clients dans l\'interface client.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permet aux clients de changer la priorité d\'une demande dans l\'interface client.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permet aux clients d\'établir un accord sur les niveaux de service relativement à une demande dans l\'interface client.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permet aux clients d\'établir la priorité d\'une demande dans l\'interface client.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Permet aux clients d\'établir la file d\'une demande dans l\'interface client. Si le réglage est « Non », une file par défaut doit être configurée.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permet aux clients d\'établir le service relatif à la demande dans l\'interface client.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            'Permet de sélectionner les services par défaut pour les clients inexistants.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Permet d\'établir de nouveaux types pour la demande (si l\'outil de définition des types de demande est activé).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permet d\'établir des services et des accords sur les niveaux de service (SLAs) pour les demandes (par ex. courriel, bureau, réseau, etc.) ainsi que des attributs d\'escalade des SLAs (si cette fonctionnalité est activée).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Permet d\'avoir des conditions de recherche étendues dans le champ de recherche de la demande dans l\'interface client. Cette fonction permet de faire des recherches de type (key1&&key2) ou (key1||key2).',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permet la visualisation de la demande en format « M » (moyen); les « Renseignements du client » (CustomerInfo => 1) présentent aussi les renseignements relatifs au client.',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permet la visualisation de la demande en format « S » (petit); les « Renseignements du client » (CustomerInfo => 1) présentent aussi les renseignements relatifs au client.',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permet aux administrateurs d\'ouvrir une session à titre d\'utilisateurs au moyen de la page de gestion des utilisateurs.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permet d\'établir un nouvel état de la demande dans l\'écran de déplacement des demandes de l\'interface agent.',
        'Archive state changed: "%s"' => 'Mise à jour de l\'indicateur d\'archivage',
        'ArticleTree' => '',
        'Attachments <-> Templates' => '',
        'Auto Responses <-> Queues' => 'Réponses automatiques <-> Files',
        'AutoFollowUp sent to "%s".' => 'Suivi automatique envoyé à "%s".',
        'AutoReject sent to "%s".' => 'Rejet automatique envoyé à "%s".',
        'AutoReply sent to "%s".' => 'Réponse automatique envoyée à "%s".',
        'Automated line break in text messages after x number of chars.' =>
            'Saut de ligne automatique dans les messages texte tous les x charactères.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Après la sélection d\'une action groupée, verrouille la demande et établit systématiquement que l\'agent qui y travaille devient son propriétaire.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Détermine systématiquement que le propriétaire d\'une demande en a la responsabilité (si l\'outil d\'identification de la responsabilité est activé).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Détermine systématiquement le responsable d\'une demande (s\'il n\'a pas encore été déterminé) après la mise à jour du premier propriétaire.',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Habillage blanc équilibré conçu par Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Pare tous les courriels entrants qui ont un numéro de demande qui n\'est pas valide inscrit dans le champ objet et dont l\'adresse de provenance est « @exemple.com ».',
        'Bounced to "%s".' => 'Retourner à "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'Construit un index des articles immédiatement après la création de l\'article.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Réglage d\'un exemple de commande. Ignore les courriels dont la commande externe retourne des résultats sur une sortie standard STDOUT (le courriel sera conduit dans une entrée standard STDIN de « .bin »).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Temps de mémorisation en mémoire cache, en secondes, de l\'authentification de l\'agent dans l\'interface générique.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Temps de mémorisation en mémoire cache, en secondes, de l\'authentification du client dans l\'interface générique.',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => 'Temps de mémorisation en mémoire cache, en secondes, de l\'arrière-plan de la configuration du service Web.',
        'Change password' => 'Changer de mot de passe',
        'Change queue!' => 'Changer de file.',
        'Change the customer for this ticket' => 'Changer le client de cette demande',
        'Change the free fields for this ticket' => 'Modifier les champs libres de cette demande',
        'Change the priority for this ticket' => 'Modifier la priorité de cette demande',
        'Change the responsible person for this ticket' => 'Modifier la personne responsable de cette demande',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Changement de priorité de "%s" (%s) pour "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Permet à tous les agents d\'être propriétaires des demandes (utile en programmation Web dynamique). Normalement, seuls les agents avec permission de lecture et d\'écriture dans la file de la demande apparaîtront.',
        'Checkbox' => 'Case à cocher',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Vérifie l\'identité du système dans l\'outil de détection du numéro de la demande lors de suivi (Sélectionnez « Non » si l\'identité du système a été changée après que le système a été utilisé).',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Commentaire destiné aux nouvelles entrées de l\'historique de l\'interface client.',
        'Comment2' => '',
        'Company Status' => '',
        'Company Tickets' => 'Demandes de l\'entreprise',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure your own log text for PGP.' => 'Configure votre journal pour le logiciel de chiffrement PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Contrôle la possibilité pour les clients de classer leurs demandes.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Contrôle si plus d\'une entrée dans le champ « de » peut être inscrite dans une nouvelle demande téléphonique depuis l\'interface agent.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Convertit les courriels HTML en messages texte.',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Créer et gérer les accords sur les niveaux de service (SLAs).',
        'Create and manage agents.' => 'Créer et gérer les agents.',
        'Create and manage attachments.' => 'Créer et gérer les pièces jointes.',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'Créer et gérer les clients.',
        'Create and manage dynamic fields.' => 'Créer et gérer les champs dynamiques.',
        'Create and manage event based notifications.' => 'Créer et gérer les notifications événementielles.',
        'Create and manage groups.' => 'Créer et gérer les groupes.',
        'Create and manage queues.' => 'Créer et gérer les files.',
        'Create and manage responses that are automatically sent.' => 'Créer et gérer les réponses envoyées automatiquement.',
        'Create and manage roles.' => 'Créer et gérer les rôles.',
        'Create and manage salutations.' => 'Créer et gérer les formules de salutation.',
        'Create and manage services.' => 'Créer et gérer les services.',
        'Create and manage signatures.' => 'Créer et gérer les signatures.',
        'Create and manage templates.' => '',
        'Create and manage ticket priorities.' => 'Créer et gérer les priorités de la demande.',
        'Create and manage ticket states.' => 'Créer et gérer les états des demandes.',
        'Create and manage ticket types.' => 'Créer et gérer les types de demandes.',
        'Create and manage web services.' => 'Créer et gérer les services Web.',
        'Create new email ticket and send this out (outbound)' => 'Créer une nouvelle demande par courriel et l\'envoyer (sortante)',
        'Create new phone ticket (inbound)' => 'Créer une nouvelle demande par téléphone (entrante)',
        'Create new process ticket' => '',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '',
        'Customer User <-> Groups' => '',
        'Customer User <-> Services' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Clients utilisateurs',
        'Customer called us.' => 'Le client nous a appellé.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Article du client (icône) lui montrant les demandes fermées regroupées. Le réglage de l\'ouverture de session de l\'utilisateur-client (CustomerUserLogin) à 1 permet la recherche de demandes fondée sur le nom d\'ouverture de session plutôt que sur l\'identification du client.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Article du client (icône) lui montrant les demandes ouvertes regroupées. Le réglage de l\'ouverture de session de l\'utilisateur-client (CustomerUserLogin) à 1 permet la recherche de demandes fondée sur le nom d\'ouverture de session plutôt que sur l\'identification du client.',
        'Customer request via web.' => 'Requête du client par le web.',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Clients <-> Groupes',
        'Data used to export the search result in CSV format.' => 'Données utilisées pour exporter les résultats de recherche dans le format CSV.',
        'Date / Time' => 'Date et heure',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Débogue l\'ensemble de traduction. Si le réglage est « Oui » les chaînes de texte sans traduction sont transmises à la sortie erreur standard (STDERR). L\'option facilite la création de nouveaux fichiers de traduction. Autrement, l\'option doit être réglée à « Non ».',
        'Default ACL values for ticket actions.' => 'Valeurs par défaut de la liste des droits d\'accès pour les actions des demandes.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Données par défaut à utiliser comme attributs dans l\'écran de recherche de demandes. Exemple : "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Données par défaut à utiliser comme attributs dans l\'écran de recherche de demandes. Exemple : "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default loop protection module.' => 'Module de protection en boucle par défaut.',
        'Default queue ID used by the system in the agent interface.' => 'Identification de files par défaut utilisée par le système dans l\'interface agent.',
        'Default skin for OTRS 3.0 interface.' => 'Habillage par défaut de l\'interface OTRS 3.0. ',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'Identification de demandes par défaut utilisée par le système dans l\'interface agent.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Identification de demandes par défaut utilisée par le système dans l\'interface client.',
        'Default value for NameX' => 'Valeur par défaut pour un « NomX »',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens aux chaînes sélectionnées. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
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
        'Define the start day of the week for the date picker.' => 'Détermine le jour débutant la semaine pour le sélecteur de date.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Détermine un élément client qui génère une icône LinkedIn à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Détermine un élément client qui génère une icône XING à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Détermine un élément client qui génère une icône Google à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Détermine un élément client qui génère une icône Google Maps à la fin du bloc d\'information client.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Détermine une liste par défaut de mots ignorés par le correcteur orthographique.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens aux nombres CVE. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens aux nombres MSBulletin. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens à des chaînes sélectionnées. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Détermine un filtre pour les html sortants afin d\'ajouter des liens aux nombres de retraçage des bogues. L\'élément Image permet de faire deux sortes d\'entrées. Tout d\'abord, le nom de l\'image (ex. faq.png). Dans ce cas, le chemin de l\'image dans OTRS sera utilisé. Il est aussi possible d\'insérer le lien vers l\'image.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Détermine un filtre pour traiter le texte dans les articles afin de mettre en surbrillance des mots clés prédéfinis.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Détermine une expression rationnelle qui exclu certaines adresses du contrôle de syntaxe si le « Contrôle des adresses électroniques » (CheckEmailAddresses) est réglé à « Oui ». Veuillez entrer une expression rationnelle dans ce champ pour les adresses électroniques qui ne sont pas syntaxiquement correctes, mais qui sont essentielles au système (p.ex. « root@localhost »).',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Détermine une expression rationnelle qui filtre les adresses électroniques qui ne devraient pas être utilisées dans l\'application.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Détermine un module utile qui charge des options spécifiques pour l\'utilisateur ou en affiche de nouvelles.',
        'Defines all the X-headers that should be scanned.' => 'Détermine les en-têtes qui doivent être analysés.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Détermine les langues accessibles par l\'application. Le duo « Clé et Contenu » relie le nom affiché à l\'avant-plan au fichier de langue PM approprié. La valeur « Clé » devrait être le nom de base du fichier PM (p.ex. « de.pm » est le nom du fichier, donc « de » est la valeur « Clé ») La valeur « Contenu » devrait être le nom affiché à l\'avant-plan. À cet endroit, spécifier la langue souhaitée (pour de plus amples renseignements, voir la documentation destinée aux développeurs (en anglais) au http://doc.otrs.org/). N\'oubliez pas d\'utiliser un équivalent HTML pour les caractères qui ne sont pas en code ASCII (p.ex. pour l\'allemand oe = o umlaut, il est nécessaire d\'utiliser le symbole &ouml).',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Détermine les paramètres pour l\'objet « Rafraîchissement » (RefreshTime) dans les préférences du client de l\'interface client.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Détermine les paramètres pour l\'objet « Demandes affichées » (ShownTickets) dans les préférences du client de l\'interface client.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Détermine les paramètres pour cet article dans les préférences du client.',
        'Defines all the possible stats output formats.' => 'Détermine les formats sortants possibles de statistiques.',
        'Defines an alternate URL, where the login link refers to.' => 'Détermine une adresse URL alternative à l\'endroit ou mène le lien d\'ouverture de session.',
        'Defines an alternate URL, where the logout link refers to.' => 'Détermine une adresse URL alternative à l\'endroit ou mène le lien de fermeture de session.',
        'Defines an alternate login URL for the customer panel..' => 'Détermine une adresse URL alternative d\'ouverture de session dans la page du client.',
        'Defines an alternate logout URL for the customer panel.' => 'Détermine une adresse URL alternative de fermeture de session dans la page du client.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Détermine l\'affichage du champ « de » des courriels envoyés à partir de réponses aux demandes et de demandes courriels.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de fermeture de la demande de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de retour des demandes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de rédaction des demandes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de transfert des demandes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de texte libre des demandes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de fusion de la synthèse de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de notes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran du propriétaire de la synthèse de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de mise en attente de la synthèse de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran des demandes téléphoniques entrantes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran des demandes téléphoniques sortantes de l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran de priorité de la synthèse de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire dans l\'écran du responsable de la demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Détermine si le verrouillage de la demande est nécessaire pour modifier le client d\'une demande dans l\'interface agent (si la demande n\'est pas encore verrouillée, elle le devient automatiquement et l\'agent qui y travaille devient son propriétaire).',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Détermine si la correction orthographique des messages rédigés doit être effectuée dans l\'interface agent.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Détermine si le compte du temps alloué doit être réglé pour toutes les demandes d\'une action groupée.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines scheduler PID update time in seconds.' => '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            'Détermine la période de mise en veille de l\'ordonnanceur, en secondes, après avoir traité toutes les tâches disponibles (nombre en représentation flottante).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Détermine l\'expression rationnelle de l\'adresse IP permettant l\'accès au référentiel local. Vous devez activer cette fonction pour pouvoir accéder au référentiel local et le paquet « liste du référentiel » (package::RepositoryList) est requis sur le système distant.',
        'Defines the URL CSS path.' => 'Détermine le chemin URL du programme de simulation CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Détermine le chemin URL de base des icônes, du CSS et de Java Script. ',
        'Defines the URL image path of icons for navigation.' => 'Détermine le chemin URL des images des icônes de navigation.',
        'Defines the URL java script path.' => 'Détermine le chemin URL de Java Script.',
        'Defines the URL rich text editor path.' => 'Détermine le chemin URL de l\'éditeur RTF.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Si nécessaire, détermine l\'adresse d\'un serveur DNS dédié pour les consultations de table de vérification des enregistrement du messager (CheckMXRecord).',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Détermine le corps du texte des courriels de notification envoyés aux agents à propos du nouveau mot de passe (le mot de passe sera envoyé après l\'utilisation de ce lien).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Détermine le corps du texte des courriels de notification envoyés aux agents avec un jeton à propos du nouveau mot de passe demandé (le mot de passe sera envoyé après l \'utilisation ce lien).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Détermine le corps du texte des courriels de notification envoyés aux clients à propos des nouveaux comptes.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Détermine le corps du texte des courriels de notification envoyés aux clients à propos des nouveaux mots de passe (le mot de passe sera envoyé après l\'utilisation de ce lien).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Détermine le corps du texte des courriels de notification envoyés aux clients avec un jeton à propos du nouveau mot de passe demandé (le mot de passe sera envoyé après l\'utilisation de ce lien).',
        'Defines the body text for rejected emails.' => 'Détermine le corps du texte des courriels rejetés.',
        'Defines the boldness of the line drawed by the graph.' => 'Détermine la largeur de trait de la ligne dessinée par le graphique.',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => 'Détermine les couleurs du graphique.',
        'Defines the column to store the keys for the preferences table.' =>
            'Détermine la colonne où seront stockées les clés des tables de préférences.',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Détermine les paramètres de configuration de cet élément qui seront présentés dans la vue des préférences.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Détermine les paramètres de configuration de cet élément qui seront présentés dans la vue des préférences. Assure l\'entretien des dictionnaires installés dans le système dans la section des données.',
        'Defines the connections for http/ftp, via a proxy.' => 'Détermine les connexions pour les protocoles HTTP ou FTP à partir d\'une passerelle de procuration.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Détermine le format de date utilisé dans les formulaires (champs d\'entrée ou d\'option).',
        'Defines the default CSS used in rich text editors.' => 'Détermine le CSS par défaut utilisé par les éditeurs RTF.',
        'Defines the default auto response type of the article for this operation.' =>
            'Détermine le type de réponses automatiques par défaut de l\'article pour cette opération.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Détermine le corps par défaut d\'une note dans l\'écran de texte libre de l\'interface agent.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Détermine la langue de l\'avant-plan par défaut. Les valeurs possibles sont déterminées par les fichiers de langues disponibles dans le système (consultez le réglage suivant).',
        'Defines the default history type in the customer interface.' => 'Détermine le type d\'historique par défaut dans l\'interface client.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Détermine le nombre maximal par défaut d\'attributs de l\'axe x pour l\'échelle de temps.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Détermine le nombre maximal par défaut de résultats de recherche affichés sur une page de visualisation.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après le suivi du client dans l\'interface client.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de demandes groupées de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de texte libre de la demande de l\'interface agent. ',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de notes de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après l\'ajout d\'une note dans l\'écran de responsabilité d\'une demande de l\'interface agent.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après qu\'elle a été retournée dans l\'écran de retour des demandes de l\'interface agent.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande après avoir été transférée dans l\'écran de transfert des demandes de l\'interface agent. ',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Détermine le nouvel état par défaut d\'une demande si elle a été rédigée ou répondue dans l\'écran de rédaction de l\'interface agent.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Détermine le corps de texte par défaut d\'une note dans l\'écran des demandes téléphoniques entrantes dans l\'interface agent.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Détermine le corps de texte par défaut d\'une note dans l\'écran des demandes téléphoniques sortantes dans l\'interface agent.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Détermine la priorité par défaut du suivi des demandes des clients dans l\'écran de synthèse de l\'interface client.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Détermine la priorité par défaut des demandes des nouveaux clients dans l\'interface client.',
        'Defines the default priority of new tickets.' => 'Détermine la priorité par défaut des nouvelles demandes.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Détermine la file par défaut des demandes des nouveaux clients dans l\'interface client.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Détermine la sélection par défaut des menus déroulants des objects dynamiques (Forme : caractéristique commune).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Détermine la sélection par défaut des menus déroulants des permissions (Forme : caractéristique commune).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Détermine la sélection par défaut des menus déroulants des formats statistiques (Forme : caractéristique commune). Veuillez insérer la touche format (voir Stats::Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Détermine le type d\'expéditeur par défaut des demandes dans l\'écran des demandes téléphoniques entrantes dans l\'interface agent.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Détermine le type d\'expéditeur par défaut des demandes dans l\'écran des demandes téléphoniques sortantes dans l\'interface agent.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Détermine le type d\'expéditeur par défaut pour les demandes dans l\'écran de synthèse de la demande de l\'interface client.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Détermine l\'attribut de recherche de demandes affiché par défaut dans l\'écran de recherche.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Détermine l\'ordre de tri par défaut pour toutes les files de la vue des files après le tri par priorité.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => 'Détermine le dictionnaire de référence par défaut pour la correction orthographique.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Détermine l\'état par défaut des demandes des nouveaux clients dans l\'interface client.',
        'Defines the default state of new tickets.' => 'Détermine l\'état par défaut des nouvelles demandes.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Détermine l\'objet par défaut des demandes dans l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Détermine l\'objet par défaut des demandes dans l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Détermine l\'objet par défaut des notes dans l\'écran de texte libre des demandes dans l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans l\'outil de recherche de demandes de l\'interface client.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des escalades de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des demandes fermées de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des responsables de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des états de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans la vue des demandes sous surveillance de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Détermine l\'attribut par défaut qui permet le tri des demandes dans les résultats de l\'outil de recherche des demandes de l\'interface agent.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Détermine la notification de demande retournée par défaut pour le client ou l\'expéditeur dans l\'écran de retour des demandes de l\'interface agent.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Détermine le nouvel état par défaut de la demande après qu\'une note téléphonique est ajoutée dans l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Détermine le nouvel état par défaut de la demande après qu\'une note téléphonique est ajoutée dans l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes après le tri par priorité dans la vue des escalades de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes après le tri par priorité dans la vue des états des demandes de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes dans la vue des responsables de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes dans la vue de fermeture des demandes de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes dans les résultats de recherche de demandes de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes dans la vue des demandes surveillées de l\'interface agent. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Détermine l\'ordre par défaut des demandes des résultats de recherche de l\'interface client. « Chronologique croissant » : la plus ancienne en haut de la liste et « Chronologique décroissant » : la plus récente en haut de la liste.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Détermine la priorité par défaut des demandes dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran de demandes groupées de l\'interface agent.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans son écran de texte libre de l\'interface agent.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans son écran de notes de l\'interface agent.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran du propriétaire de la synthèse de la demande dans l\'interface agent.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran de mise en attente de la synthèse de la demande dans l\'interface agent.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran de priorité de la synthèse de la demande dans l\'interface agent.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Détermine la priorité par défaut de la demande dans l\'écran du responsable dans l\'interface agent.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            'Détermine le type par défaut d\'un article dans l\'interface client.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Détermine le type par défaut du message transféré dans l\'écran de transfert de la demande dans l\'interface agent.',
        'Defines the default type of the article for this operation.' => 'Détermine le type par défaut de l\'article pour cette opération.',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran de fermeture de la demande dans l\'interface agent.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran de demandes groupées de l\'interface agent.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran de texte libre de la demande dans l\'interface agent.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran de notes de la demande dans l\'interface agent.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran du propriétaire de la synthèse de la demande dans l\'interface agent.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran de mise en attente dans la synthèse de la demande de l\'interface agent.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran de priorité de la synthèse de la demande dans l\'interface agent.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Détermine le type par défaut de la note dans l\'écran du responsable dans l\'interface agent.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Détermine le type par défaut de la note dans l\'écran de synthèse de la demande dans l\'interface client.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Détermine le module d\'avant-plan utilisé par défaut en l\'absence d\'un paramètre d\'action dans l\'adresse url de l\'interface agent.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Détermine le module d\'avant-plan utilisé par défaut en l\'absence d\'un paramètre d\'action dans l\'adresse url de l\'interface client.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Détermine la valeur par défaut du paramètre d\'action pour l\'avant-plan public. Le paramètre d\'action est utilisé dans les scripts du système.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Détermine les types d\'expéditeur visibles par défaut pour une demande (par défaut : le client).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Détermine le filtre qui traite le texte dans les articles afin de mettre en surbrillance les adresses URL.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Détermine le nom de domaine complet du système. Le réglage est utilisé en tant que variable, OTRS_CONFIG_FQDN est trouvé sous toutes les formes de message utilisé par l\'application afin de créer des liens vers les demandes dans votre système.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Détermine les groupes dans lesquels se trouvera chaque client si le soutien aux groupes de clients (CustomerGroupSupport) est activé et que vous ne souhaitez pas faire la gestion de chacun des utilisateurs de ces groupes.',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Détermine la hauteur de l\'élément de l\'éditeur RTF. Entrez un nombre de pixels ou un pourcentage relatif.',
        'Defines the height of the legend.' => 'Détermine la hauteur de la légende.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de demande par courriel de l\'interface agent.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran des demandes téléphoniques de l\'interface agent.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de texte libre de la demande.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de notes de la demande de l\'interface agent.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran du propriétaire de la demande de l\'interface agent.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de la mise en attente de la demande de l\'interface agent.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran de priorité de la demande de l\'interface agent.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de l\'écran du responsable de la demande de l\'interface agent.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Détermine le commentaire de l\'historique pour l\'action de synthèse de la demande de l\'interface client.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Détermine le commentaire de l\'historique pour cette opération qui sera utilisé dans l\'historique de l\'interface agent.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de demande par courriel de l\'interface agent.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran des demandes téléphoniques de l\'interface agent.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de texte libre de la demande.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de notes de la demande de l\'interface agent.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran du propriétaire de la demande de l\'interface agent.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de mise en attente de la demande de l\'interface agent.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de priorité de la demande de l\'interface agent.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour l\'action de l\'écran de responsabilité de la demande de l\'interface agent.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Détermine le type d\'historique pour l\'action de synthèse de la demande de l\'interface client.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Détermine le type d\'historique pour cette opération dans l\'interface client.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Détermine les heures et les jours de la semaine du calendrier indiqué afin de calculer le temps de travail.',
        'Defines the hours and week days to count the working time.' => 'Détermine les heures et les jours de la semaine afin de calculer le temps de travail.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Détermine la clé à vérifier dans le module « Kernel::Modules::AgentInfo ». Si la clé des préférences de l\'utilisateur est positive, le message est accepté par le système.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Détermine la clé à vérifier avec le module d\'acceptation du client (CustomerAccept). Si cette clé des préférences de l\'utilisateur est positive, le message est accepté par le système.',
        'Defines the legend font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Détermine le lien de type « Normal ». Si le nom source et le nom cible sont les mêmes, le lien est bidirectionnel, autrement, il est unidirectionnel.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Détermine le lien de type «ParentChild » (parent enfant). Si le nom source et le nom cible sont les mêmes, le lien est bidirectionnel, autrement, il est unidirectionnel.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Détermine le type de lien des groupes. Le type de lien entre les membres d\'un même groupe détermine le type de lien du groupe. Par exemple, si la demande A est liée à la demande B par un lien « Normal », ces demandes ne pourront en plus être liés par un lien de type « ParentChild » (parent enfant). ',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Détermine la liste des référentiels en ligne. Une autre installation pourrait servir de référentiel, par exemple, clé=« http://exemple.com/otrs/public.pl?Action=Référentielpublic;Fichier= » et Contenu=« Nom ».',
        'Defines the list of possible next actions on an error screen.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Détermine l\'emplacement Web de la liste des référentiels d\'installation de paquets supplémentaires. Le premier résultat affiché sera utilisé.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Détermine le module de journalisation du système. L\'option « Fichier » écrit tous les messages dans un journal donné, l\'option « Journal du système » utilise le programme démon, par exemple, le syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Détermine le temps maximal (en secondes) d\'une identification de session.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Détermine le nombre de pages maximal des fichiers PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Précise la taille maximale (en Mo) du fichier d\'enregistrement.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Détermine le module qui présente une notification générique dans l\'interface agent. Le champ « texte », si configuré comme tel, ou le contenu d\'un « fichier » sera affiché. ',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Détermine le module qui présente tous les clients connectés dans l\'interface agent.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Détermine le module qui présente tous les agents connectés dans l\'interface agent.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Détermine le module qui présente les agents présentement connectés dans l\'interface client.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Détermine le module qui présente les clients présentement connectés dans l\'interface client.',
        'Defines the module to authenticate customers.' => 'Détermine le module d\'authentification des clients.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Détermine le module d\'affichage de notifications de l\'interface agent lorsque l\'agent est connecté et que son indicateur d\'absence est activé.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Détermine le module d\'affichage de notifications de l\'interface agent lorsque le système est utilisé par l\'administrateur (Vous ne devriez normalement pas travailler connecté en tant qu\'administrateur).',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Détermine le module qui génère le rafraîchissement des en-têtes des sites HTML, dans l\'interface client.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Détermine le module qui génère le rafraîchissement des en-têtes des sites HTML.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Détermine le module d\'envoi des courriels. L\'option « Envoyer des courriels » utilise le système binaire d\'envoi des courriels de votre système d\'exploitation. Les mécanismes du protocole SMTP utilisent un serveur courriel (externe) distinct. L\'option « Ne pas envoyer de courriels » empêche l\'envoi de courriels ce qui est très utile lors de tests de système.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Détermine le module utilisé pour stocker les données de la session. L\'option « DB » permet de scinder le serveur d\'avant-plan du serveur de base de données. L\'option « FS » est plus rapide.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Détermine le nom de l\'application présentée dans l\'interface Web et celui des onglets et des barres de titres du navigateur Web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Détermine le nom de la colonne de la table des préférences où les données seront enregistrées.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Détermine le nom de la colonne de la table des préférences où les identifiants des utilisateurs seront enregistrés.',
        'Defines the name of the indicated calendar.' => 'Détermine le nom du calendrier spécifié.',
        'Defines the name of the key for customer sessions.' => 'Détermine le nom de la clé des sessions client.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Détermine le nom de la clé de session, par exemple, Session, SessionID ou OTRS.',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Détermine le nom de la table où les préférences du client sont enregistrées.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Détermine les nouveaux états possibles après avoir rédigé une demande ou y avoir répondu dans l\'écran de rédaction de l\'interface agent.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Détermine les nouveaux états possibles après avoir transféré une demande dans l\'écran de transfert de demande de l\'interface agent.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Détermine les nouveaux états possibles des demandes du client dans l\'interface client.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran des demandes groupées de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de texte libre de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de notes de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de propriété de la synthèse de la demande de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Détermine le nouvel état d\'une demande après avoir ajouté une note dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande dans l\'écran du responsable de la demande de l\'interface agent à la suite de l\'ajout d\'une note.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande dans l\'écran de retour des demandes de l\'interface agent à la suite d\'un retour.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Détermine le nouvel état d\'une demande dans l\'écran de déplacement des demandes de l\'interface agent à la suite de son déplacement dans une autre file.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => 'Détermine les paramètres de la table comprenant les préférences du client.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Détermine les paramètres de l\'arrière-plan du tableau de bord. L\'option « Group » (groupe) permet de restreindre l\'accès au module d\'extension (p.ex. Group: admin;group1;group2;). L\'option « Default » (par défaut) précise si l\'activation du module d\'extension se fait par défaut ou par l\'utilisateur. L\'option « CacheTTL » (durée de vie de la mémoire cache) précise le délai, en minutes, avant l\'expiration de la mémoire cache du module d\'extension.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Détermine les paramètres de l\'arrière-plan du tableau de bord. L\'option « Group » (groupe) permet de restreindre l\'accès au module d\'extension (p.ex. Group: admin;group1;group2;). L\'option « Default » (par défaut) précise si l\'activation du module d\'extension se fait par défaut ou par l\'utilisateur. L\'option « CacheTTLLocal » (durée de vie de la mémoire cache locale) précise le délai, en minutes, avant l\'expiration de la mémoire cache du module d\'extension.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Détermine les paramètres de l\'arrière-plan du tableau de bord. L\'option « Limit » (limite) précise le nombre d\'entrées affichées par défaut. L\'option « Group » (groupe) permet de restreindre l\'accès au module d\'extension (p.ex. Group: admin;group1;group2;). L\'option « Default » (par défaut) précise si l\'activation du module d\'extension se fait par défaut ou par l\'utilisateur. L\'option « CacheTTL » (durée de vie de la mémoire cache) précise le délai, en minutes, avant l\'expiration de la mémoire cache du module d\'extension.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Détermine les paramètres de l\'arrière-plan du tableau de bord. L\'option « Limit » (limite) précise le nombre d\'entrées affichées par défaut. L\'option « Group » (groupe) permet de restreindre l\'accès au module d\'extension (p.ex. Group: admin;group1;group2;). L\'option « Default » (par défaut) précise si l\'activation du module d\'extension se fait par défaut ou par l\'utilisateur. L\'option « CacheTTLLocal » (durée de vie de la mémoire cache locale) précise le délai, en minutes, avant l\'expiration de la mémoire cache du module d\'extension.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Détermine le mot de passe pour accéder au descripteur du protocole SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police à espacement constant en italique et en gras dans les documents PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police proportionnelle en italique et en gras dans les documents PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police à espacement constant en gras dans les documents PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police proportionnelle en gras dans les documents PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police à espacement constant en italique dans les documents PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police proportionnelle en italique dans les documents PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police à espacement constant dans les documents PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Détermine le chemin et le fichier TTF pour traiter la police proportionnelle dans les documents PDF.',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            'Détermine le chemin afin que l\'ordonnanceur stocke les données de sortie de son pupitre de commande (SchedulerOUT.log and SchedulerERR.log).',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Détermine le chemin du fichier d\'information affiché qui est situé sous Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Détermine le chemin vers le code binaire du logiciel PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Détermine le chemin vers le code binaire du protocole ouvert ssl. Une variable d\'environnement HOME peut être nécessaire ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'Détermine l\'emplacement de la légende et devrait être une clé de deux lettres sous la forme : B[GCD] ou D[HCB] (\'B[LCR]| R[TCB]\'). La première lettre indique l\'emplacement : Bas ou Droite (Bottom or Right) et la seconde lettre indique l\'alignement : Gauche, Droite, Centre, Haut ou Bas (Left, Right, Center, Top, or Bottom).',
        'Defines the postmaster default queue.' => 'Détermine la file par défaut du maître de poste.',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'Détermine le destinataire cible des demandes dans l\'interface client (l\'option « File » (Queue) affiche l\'ensemble des files, l\'option « Adresses du système » (SystemAddress) affiche l\'ensemble des adresses du système).',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Détermine la permission requise pour afficher une demande dans la vue de l\'escalade de l\'interface agent.',
        'Defines the search limit for the stats.' => 'Détermine la limite de recherche pour les statistiques.',
        'Defines the sender for rejected emails.' => 'Détermine l\'expéditeur des courriels rejetés.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Détermine le séparateur entre les noms réels des agents et l\'adresse électronique attribuée à une file.',
        'Defines the spacing of the legends.' => 'Détermine l\'espacement entre les légendes.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Détermine les permissions standards accessibles aux clients au sein de l\'application. Au besoin, vous pouvez inscrire des permissions supplémentaires. Celles-ci doivent être figées dans le code pour être efficaces. Assurez-vous que la permission « rw » (lecture et écriture) soit la dernière entrée inscrite après avoir ajouté les permissions susmentionnées.',
        'Defines the standard size of PDF pages.' => 'Détermine la taille standard des pages en format PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Détermine l\'état d\'une demande déjà fermée qui fait l\'objet d\'un suivi.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Détermine l\'état d\'une demande qui fait l\'objet d\'un suivi.',
        'Defines the state type of the reminder for pending tickets.' => 'Détermine le type d\'état du rappel des demandes en attente.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Détermine le sujet des notifications envoyées aux agents pour un nouveau mot de passe.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Détermine le sujet des notifications envoyées aux agents avec un jeton d\'authentification pour une nouvelle demande de mot de passe.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Détermine le sujet des notifications envoyées aux clients pour un nouveau compte d\'accès.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Détermine le sujet des notifications envoyées aux clients pour un nouveau mot de passe.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Détermine le sujet des notifications envoyées aux clients avec un jeton d\'authentification pour une nouvelle demande de mot de passe.',
        'Defines the subject for rejected emails.' => 'Détermine le sujet des courriels rejetés.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Détermine l\'adresse de courrier électronique de l\'administrateur du système. Elle sera affichée dans les écrans d\'erreur de l\'application. ',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Détermine l\'attribut cible dans le lien vers la base de données externe du client (p.ex. \'target="cdb"\').',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time in days to keep log backup files.' => 'Détermine la période, en jours, au cours de laquelle seront gardés les fichiers de copie de sauvegarde.',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            'Détermine la période, en secondes, après laquelle l\'ordonnanceur se redémarrera.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Détermine la période de temps du calendrier indiqué, qui pourra par la suite être attribué à une file précise.',
        'Defines the title font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'Détermine l\'identifiant de l\'utilisateur dans la page du client.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Détermine le nom d\'utilisateur qui permet l\'accès au descripteur du protocle SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Détermine les types d\'états valides d\'une demande.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Détermine les types d\'états valides des demandes déverrouillées. Vous pouvez utiliser le script « bin/otrs.UnlockTickets.pl » pour déverrouiller des demandes.',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Détermine les verrous visibles d\'une demande (par défaut, unlock et tmp_lock).',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Détermine la chasse des éléments de l\'éditeur RTF. Indiquez le nombre de pixels ou la valeur relative en pourcentage.',
        'Defines the width of the legend.' => 'Détermine la chasse de la légende.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Détermine quels types d\'envoi d\'article devraient être affichés dans l\'aperçu de la demande.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Détermine quels états doivent être programmés systématiquement (Contenu) après que le délai d\'attente de l\'état (Clé) a été atteint.',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Détermine quel article devrait être aggrandi dans l\'écran de visualisation. Si aucune configuration n\'a été effectuée, l\'article le plus récent sera aggrandi.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Deleted link to ticket "%s".' => 'Suppression du lien vers la demande "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Supprime une session si l\'identification de session est utilisée avec une adresse IP distante non valide.',
        'Deletes requested sessions if they have timed out.' => 'Supprime les sessions demandées si elles sont expirées.',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Détermine si la liste des files dans lesquelles il est possible de déplacer des demandes devrait être présentée sous forme de menu déroulant ou dans une nouvelle fenêtre dans l\'interface de l\'agent. Si l\'option « nouvelle fenêtre » est en fonction, vous pouvez ajouter une note à la demande.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Détermine si le module statistique peut générer des listes de demandes.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Détermine les nouveaux états de la demande après la création d\'une demande par courriel dans l\'interface agent.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Détermine les nouveaux états de la demande après la création d\'une demande téléphonique dans l\'interface agent.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Détermine l\'écran suivant une nouvelle demande du client dans l\'interface client.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Détermine l\'écran qui succède l\'écran de suivi de la synthèse de la demande dans l\'interface client.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Détermine les états possibles pour les demandes en attente qui ont changé d\'état après avoir atteint leur délai d\'attente.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Détermine les textes des champs « destinataire » (À : ) de la demande téléphonique et « expéditeur » (De :) de la demande par courriel dans l\'interface agent. En ce qui concerne les files « NewQueueSelectionType », le champ « <Queue> » affiche les noms des files et les champs « <Realname> <<Email>> » affichent le nom et le courriel du destinataire dans l\'adresse système (SystemAddress).',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Détermine les textes du champ « destinataire » (À : ) de la demande dans l\'interface client. En ce qui concerne les files « CustomerPanelSelectionType », le champ « <Queue> » affiche le nom des files et le nom et le courriel du destinaire apparaîtront dans les champs « <Realname> <<Email>> » de l\'adresse système (SystemAddress).',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Détermine la manière dont les objets liés sont affichés dans chaque masque.',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Détermine quelles options seront admissibles pour les destinataires (demandes téléphoniques) et pour les expéditeurs (demandes par courriel) dans l\'interface agent.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Détermine quelles files seront admissibles pour les destinaires des demandes dans l\'interface client.',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Désactive la notification de rappel à l\'agent responsable de la demande (Ticket::Responsible doit être activé).',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Affiche le temps alloué à un article dans la synthèse de la demande.',
        'Dropdown' => 'Menu déroulant',
        'Dynamic Fields Checkbox Backend GUI' => 'IUG de l\'arrière-plan pour les case à cocher ',
        'Dynamic Fields Date Time Backend GUI' => 'IUG de l\'arrière-plan pour les champs dynamiques « Date » et « Heure »',
        'Dynamic Fields Drop-down Backend GUI' => 'IUG de l\'arrière-plan pour les menus déroulants',
        'Dynamic Fields GUI' => 'IUG des champs dynamiques',
        'Dynamic Fields Multiselect Backend GUI' => 'IUG de l\'arrière-plan pour les champs « multi-choix »',
        'Dynamic Fields Overview Limit' => 'Nombre de champs dynamiques par page ',
        'Dynamic Fields Text Backend GUI' => 'IUG de l\'arrière-plan pour les champs « texte »',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Champs dynamiques utilisés pour exporter les résultats de recherche en format CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => ' ',
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
            'Champs dynamiques affichés dans l\'écran de message de la demande dans l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran de rédaction de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran de demande courriel de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran de transfert de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran de texte libre de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Champs dynamiques affichés dans l\'écran de visualisation en format « M » (Moyen) de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran de déplacement de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran de notes de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran propriété de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran de mise en attente de l\'interface agent. Réglages possibles : 0 = Désactivé, 1 = Activé, 2 = Activé et obligatoire.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran des demandes téléphoniques entrantes de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé, 2 = activé et nécessaire.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran des demandes téléphoniques sortantes de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé, 2 = activé et nécessaire.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran des demandes téléphoniques de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé, 2 = activé et nécessaire.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Champs dynamiques affichés dans l\'écran de visualisation en format « L » (Grand) de la demande de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé.',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Champs dynamiques affichés dans l\'écran d\'aperçu avant impression de la demande de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Champs dynamiques affichés dans l\'écran d\'aperçu avant impression de la demande de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran de priorité de la demande de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé, 2 = activé et nécessaire.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Champs dynamiques affichés dans l\'écran du responsable de la demande de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé, 2 = activé et nécessaire.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Champs dynamiques affichés dans l\'écran de visualisation des résultats de recherche de demandes de l\'interface agent. Réglages possibles : 0 = désactivé, 1 = activé.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Champs dynamiques affichés dans l\'écran de recherche de demandes de l\'interface client. Réglages possibles : 0 = désactivé, 1 = activé.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Champs dynamiques affichés dans l\'écran de synthèse de la demande de l\'interface client. Réglages possibles : 0 = désactivé, 1 = activé.',
        'DynamicField backend registration.' => 'Enregistrement des champs dynamiques (DynamicField) dans l\'arrière-plan.',
        'DynamicField object registration.' => 'Enregistrement de l\'objet « Champ dynamique » (DynamicField).',
        'Edit customer company' => '',
        'Email Addresses' => 'Adresses de courrier électronique',
        'Email sent to "%s".' => 'Courriel envoyé à "%s".',
        'Email sent to customer.' => 'Courriel envoyé au client.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Permet l\'envoi de PDF. Le module CPAN PDF::AP12 est nécessaire. S\'il n\'est pas installé, l\'envoi de PDF sera désactivé.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Permet la gestion des certificats S/MIME.',
        'Enables customers to create their own accounts.' => 'Permet aux clients de créer leur propre compte.',
        'Enables file upload in the package manager frontend.' => 'Permet le téléchargement de fichiers dans l\'avant-plan du gestionnaire de paquets.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Active ou désactive la fonction de surveillance de demandes qui permet à un agent de suivre une demande sans en être le propriétaire ni le responsable.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Permet l\'enregistrement des performances (pour enregistrer les temps de réponse). Cela perturbera le rendement du système. Vous devez activer le Frontend::Module###AdminPerformanceLog.',
        'Enables spell checker support.' => 'Permet la gestion du correcteur orthographique.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Active la fonction d\'action groupée des demandes pour que l\'avant-plan de l\'agent puisse travailler sur plus d\'une demande à la fois.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Active la fonction d\'action groupée des demandes pour les groupes en liste.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Active la fonction de responsabilité d\'une demande afin de pouvoir suivre une demande précise.',
        'Enables ticket watcher feature only for the listed groups.' => 'Active la fonction de surveillance de demandes pour les groupes en liste.',
        'Enroll this ticket into a process' => '',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => 'Vue des escalades',
        'EscalationTime' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Enregistrement du module des évènements. Pour une meilleure performance, vous pouvez créer un déclencheur d\'évènement (p.ex. Évènement => Créer une demande (Event => TicketCreate)). La création n\'est possible que si les champs dynamiques requièrent tous le même évènement.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
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
        'Execute SQL statements.' => 'Exécuter des requêtes SQL.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Exécute la vérification des suivis des courriels « en réponse à » ou ayant des en-têtes de référence qui n\'ont pas de numéro de demande dans le sujet.',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            'Exécute la vérification des suivis de pièces jointes aux courriels qui n\'ont pas de numéro de demande dans le sujet.',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            'Exécute la vérification des suivis du corps des courriels qui n\'ont pas de numéro de demande dans le sujet.',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            'Exécute la vérification des suivis des courriels ordinaires ou non traités qui n\'ont pas de numéro de demande dans le sujet.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Exporte l\'arborescence complet d\'un article dans les résultats de recherche (la performance du système pourrait être touchée).',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Recherche les paquets au moyen du serveur mandataire. Écrase « WebUserAgent::Proxy ».',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'Fichier affiché dans le module Kernel::Modules::AgentInfo, s\'il est situé sous Kernel/Output/HTML/Standard/AgentInfo.dtl.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Filtrer les courriels entrants.',
        'First Queue' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'FollowUp for [%s]. %s' => 'Un suivi de la demande [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Force le codage des courriels sortants (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Force à choisir un état de la demande différent après une action de verrouillage. Défini l\'état actuel en tant que clé et l\'état suivant en tant que contenu après une action de verrouillage.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Force le déverrouillage des demandes après qu\'elles sont déplacées dans une autre file.',
        'Forwarded to "%s".' => 'Transférée vers "%s".',
        'Frontend language' => 'Langue de l\'interface ',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Enregistrement du module interface (désactive le lien de la société si aucune fonction de la société n\'est utilisée).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => 'Enregistrement du module interface pour l\'interface agent.',
        'Frontend module registration for the customer interface.' => 'Enregistrement du module interface pour l\'interface client.',
        'Frontend theme' => 'Thème de l\'interface',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => 'Agent générique',
        'GenericInterface Debugger GUI' => 'Débogueur IUG de l\'interface générique',
        'GenericInterface Invoker GUI' => 'Demandeur IUG de l\'interface générique',
        'GenericInterface Operation GUI' => 'Opération IUG de l\'interface générique',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => 'TransportHTTPSOAP IUG de l\'interface générique',
        'GenericInterface Web Service GUI' => 'Service Web IUG de l\'interface générique',
        'GenericInterface Webservice History GUI' => 'Historique des services Web IUG de l\'interface générique',
        'GenericInterface Webservice Mapping GUI' => 'Mappage des services Web IUG de l\'interface générique',
        'GenericInterface module registration for the invoker layer.' => 'Enregistrement du module de l\'interface générique pour la couche du demandeur.',
        'GenericInterface module registration for the mapping layer.' => 'Enregistrement du module de l\'interface générique pour la couche de mappage.',
        'GenericInterface module registration for the operation layer.' =>
            'Enregistrement du module de l\'interface générique pour la couche des opérations.',
        'GenericInterface module registration for the transport layer.' =>
            'Enregistrement du module de l\'interface générique pour la couche de transport.',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'Donne aux utilisateurs finaux la possibilité de surclasser les délimiteurs dans les fichiers CSV déterminés dans les fichiers de traduction.',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'Permet l\'accès si l\'identifiant du client qui a fait la demande correspond à l\'identifiant de l\'utilisateur du client et que ce dernier a les permissions de groupe pour accéder à la file dans laquelle est la demande.',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'Permet d\'étendre vos recherches plein texte dans les articles (recherche dans le corps du texte et dans les champs « De », « À », « Cc », « Sujet »). Le moteur d\'exécution (Runtime) fera les recherches plein texte dans les données réelles (le moteur fonctionne bien jusqu\'à concurrence de 50 000 demandes). « Static DB » fractionne en chaînes tous les articles et crée ensuite un index, ce qui augmentera de 50 % l\'efficacité des recherches. Pour créer un premier index utiliser : « bin/otrs.RebuildFulltextIndex.pl ».',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous pouvez déterminer un pilote de base de données (l\'autodétection est habituellement utilisée).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous pouvez déterminer un mot de passe pour la connexion à la table du client.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous pouvez déterminer un nom d\'usager pour la connexion à la table du client.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le DSN pour la connexion à la table du client.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le nom de la colonne du mot de passe client (CustomerPassword) dans la table du client.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le type de cryptage des mots de passe.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le nom de la colonne pour la clé du client (CustomerKey) dans la table du client.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « Customer::AuthModule », vous devez préciser le nom de la table où sont stockées vos données clients.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Si vous sélectionnez l\'option « DB » pour le module « SessionModule », vous devez préciser une table dans la base de données où seront stockées les données de la session.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Si vous sélectionnez l\'option « FS » pour le module « SessionModule », vous devez préciser un répertoire où seront stockées les données de la session.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Si vous sélectionnez l\'option « HTTPBasicAuth » pour le module « Customer::AuthModule », vous pouvez préciser (en utilisant une expression rationnelle) la mise en chaîne de parties du « REMOTE_USER » (afin de supprimer les domaines de poids faibles). « RegExp-Note, $1 » servira alors à l\'ouverture de la session.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Si vous sélectionnez l\'option « HTTPBasicAuth » pour le module « Customer::AuthModule », vous pouvez préciser la mise en chaîne de parties de noms d\'utilisateur que vous souhaitez mettre de l\'avant (p. ex. pour les domaines de type « exemple_domaine\utilisateur à utilisateur »).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule » et que vous souhaitez ajouter un suffixe aux noms d\'utilisateur de chacun des clients, vous devez le spécifier ici (p. ex. vous voulez uniquement écrire le nom de l\'utilisateur alors que dans votre répertoire LDAP, il existe sous la forme « utilisateur@domaine »).',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule » et que vous devez avoir des paramètres spéciaux pour le module perl « Net::LDAP », vous devez le spécifier ici. Pour de plus amples renseignements sur les paramètres, consultez « perldoc Net::LDAP ».',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », que vos utilisateurs ont seulement des accès anonymes à l\'arborescence LDAP et que vous souhaitez faire des recherches dans les données, vous aurez besoin d\'un utilisateur qui a accès au répertoire LDPA. Veuillez indiquer ici le mot de passe pour cet utilisateur spécialisé.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », que vos utilisateurs ont seulement des accès anonymes à l\'arborescence LDAP et que vous souhaitez faire des recherches dans les données, vous aurez besoin d\'un utilisateur qui a accès au répertoire LDPA. Veuillez indiquer ici le nom d\'utilisateur pour cet utilisateur spécialisé.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous devez préciser la base DN « BaseDN ».',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous devez préciser l\'hôte LDAP.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous devez préciser l\'identifiant de l\'utilisateur.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous pouvez préciser les attributs de l\'utilisateur. Pour les groupes POSIX (posixGroups) LDPA, utilisez un numéro d\'identification d\'utilisateur; pour les autres groupes, utilisez un nom distinctif complet d\'utilisateur. ',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous pouvez ici préciser les attributs d\'accès.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous pouvez préciser si les applications doivent arrêter, par exemple, si une connexion à un serveur ne peut être établi en raison d\'un problème de réseau.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Si vous sélectionnez l\'option « LDAP » pour le module « Customer::AuthModule », vous pouvez vérifier si l\'utilisateur est autorisé à s\'authentifier parce qu\'il est dans un groupe POSIX (posixGroup) (p. ex. un utilisateur doit être dans un groupe XYX pour utiliser OTRS). Veuillez préciser le groupe ayant accès au système.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Si vous sélectionnez l\'option « LDAP », vous pouvez ajouter un filtre pour chaque requête LDAP, p. ex. (mail=*), (objectclass=user) or (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Si vous sélectionnez l\'option « RADIUS » pour le module « Customer::AuthModule », vous devez préciser le mot de passe pour l\'authentification à l\'hôte RADIUS.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Si vous sélectionnez l\'option « RADIUS » pour le module « Customer::AuthModule », vous devez préciser l\'hôte RADIUS.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si vous sélectionnez l\'option « RADIUS » pour le module « Customer::AuthModule », vous pouvez préciser si les applications doivent arrêter, par exemple, si une connexion à un serveur ne peut être établi en raison d\'un problème de réseau.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Si vous sélectionnez le processus « Envoyer des courriels » en tant que module « SendMailModule », vous devez préciser l\'emplacement du code binaire du processus ainsi que les options nécessaires.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Si vous sélectionnez le  « Journal du système » pour le module « LogModule », vous pouvez déterminer une fonction spécialisée. ',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'Si vous sélectionnez le « Journal du système » pour le module « LogModule », vous pouvez déterminer un connecteur logiciel spécialisé (avec solaris vous pourriez devoir utiliser un flux de données.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Si l\'option « Journal du système » est sélectionné pour le module « LogModule », le jeu de caractère qui doit être utilisé pour la connexion peut y être spécifié.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Si l\'option « Fichier » est sélectionné pour le module « LogModule », un fichier journal doit être spécifié. Si le fichier n\'existe pas, il sera créé par le système.',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Si une note est ajoutée par un agent, cette option règle l\'état de la demande dans l\'écran de fermeture de l\'interface agent.',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Si une note est ajoutée par un agent, cette option règle l\'état de la demande dans l\'écran d\'action groupée de l\'interface agent.',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Si une note est ajoutée par un agent, cette option règle l\'état de la demande dans l\'écran de texte libre de l\'interface agent.',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Si une note est ajoutée par un agent, cette option règle l\'état de la demande dans l\'écran de notes de l\'interface agent.',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Si une note est ajoutée par un agent, cette option règle l\'état de la demande dans l\'écran de responsabilité de l\'interface agent.',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Si une note est ajoutée par un agent, cette option règle l\'état de la demande dans l\'écran de propriété de la synthèse de la demande de l\'interface agent.',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Si une note est ajoutée par un agent, cette option règle l\'état de la demande dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Si une note est ajoutée par un agent, cette option règle l\'état de la demande dans l\'écran de priorité en attente de la synthèse de la demande de l\'interface agent.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Si un mécanisme « SMTP » est sélectionné en tant que module d\'envoi de courriel ( SendmailModule ) et qu\'une authentification au serveur de courriel est nécessaire, un mot de passe doit être spécifié.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Si un mécanisme « SMTP » est sélectionné en tant que module d\'envoi de courriel ( SendmailModule ) et qu\'une authentification au serveur de courriel est nécessaire, un nom d\'utilisateur doit être spécifié.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Si un mécanisme « SMTP » est sélectionné en tant que module d\'envoi de courriel ( SendmailModule ), l\'hôte de messagerie responsable de l\'envoi des courriels doit être spécifié.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Si un mécanisme « SMTP » est sélectionné en tant que module d\'envoi de courriel ( SendmailModule ), le port d\'écoute des connections entrantes du serveur courriel doit être spécifié.',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'OTRS livrera tous les fichiers CSS en format minimisé si vous activez cette option. AVERTISSEMENT : si vous désactivez cette option, il pourrait y avoir des problèmes au programme IE 7 parce qu\'il ne peut enregistrer plus de 32 fichiers CSS.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'OTRS livrera tous les fichiers JavaScript en format minimisé si vous activez cette option.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Les demandes téléphoniques et les demandes par courriel seront ouvertes dans des nouvelles fenêtres si cette option est activée.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Les différentes visualisations ( tableau de bord, vue de fermeture, vue des files) seront automatiquement rafraîchies après le délai déterminé ici.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Le premier plan du menu principal s\'ouvre d\'un pointage de la souris plutôt que d\'un clic, si cette option est activée.',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            'Cette adresse est utilisée dans l\'en-tête des notifications sortantes si cette option est activée. Si aucune adresse n\'est spécifiée, l\'en-tête sera vide.',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Si cette expression rationnelle correspond, aucun message ne sera envoyé par l\'autorépondeur.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'Si vous souhaitez utiliser une banque de données miroir pour les recherches plein texte des demandes des agents ou pour générer des statistiques, spécifiez le DNS de cette base de données.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'Si vous souhaitez utiliser une banque de données miroir pour les recherches plein texte des demandes des agents ou pour générer des statistiques, le mot de passe pour l\'authentification à cette base de données peut être spécifié.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'Si vous souhaitez utiliser une banque de données miroir pour les recherches plein texte des demandes des agents ou pour générer des statistiques, le nom de l\'utilisateur pour l\'authentification à cette base de données peut être spécifié.',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            'Ignore les articles avec envois automatiques (par ex. les réponses automatiques ou les notifications par courriels).',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Comprend les moments de création des articles dans les recherches de demandes de l\'interface agent.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'IndexAccelerator : pour choisir votre mode « TicketViewAccelerator » pour l\'arrière-plan. Le mode « RuntimeDB » génère chaque vue de file sur-le-champ à partir de la table de demandes (aucun problème de performance n\'est envisageable jusqu\'à un total de 60 000 demandes et jusqu\'à 6 000 demandes ouvertes dans le système). Le mode « StaticDB » est le mode le plus puissant. Il utilise un index des demandes supplémentaire qui s\'apparente à une vue (ce mode est recommandé si vous atteignez un total de 80 000 demandes et de 6 000 demandes ouvertes enregistrées dans le système). Utilisez le script « bin/otrs.RebuildTicketIndex.pl » pour la mise à jour initiale de l\'index.',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'Si vous souhaitez un correcteur othographique, ce module installe « ispell » ou « aspell » sur votre système. Veuillez spécifier le chemin du code binaire de l\'un ou l\'autre des correcteurs orthographiques de votre système.',
        'Interface language' => 'Langue de l\'interface ',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Il est possible de configurer différents habillages par domaine dans l\'application pour distinguer les agents entre eux par exemple. En utilisant une expression rationnelle (regex) vous pouvez configurer un couple clé-contenu qui correspond au domaine. La valeur « Clé » doit correspondre au domaine et la valeur « Contenu » doit être un habillage admissible à votre système. Veuillez consulter les exemples pour vérifier quels sont les formats appropriés d\'expressions rationnelles.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Il est possible de configurer différents habillages par domaine dans l\'application pour distinguer les clients entre eux par exemple. En utilisant une expression rationnelle (regex) vous pouvez configurer un couple clé-contenu qui correspond au domaine. La valeur « Clé » doit correspondre au domaine et la valeur « Contenu » doit être un habillage admissible à votre système. Veuillez consulter les exemples pour vérifier quels sont les formats appropriés d\'expressions rationnelles.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Il est possible de configurer différents thèmes par domaine dans l\'application pour distinguer les agents des clients par exemple. En utilisant une expression rationnelle (regex) vous pouvez configurer un couple clé-contenu qui correspond au domaine. La valeur « Clé » doit correspondre au domaine et la valeur « Contenu » doit être un habillage admissible à votre système. Veuillez consulter les exemples pour vérifier quels sont les formats appropriés d\'expressions rationnelles.',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Left' => '',
        'Link agents to groups.' => 'Lier les agents aux groupes.',
        'Link agents to roles.' => 'Lier les agents aux rôles.',
        'Link attachments to templates.' => '',
        'Link customer user to groups.' => '',
        'Link customer user to services.' => '',
        'Link queues to auto responses.' => 'Lier les files aux réponses automatiques.',
        'Link roles to groups.' => 'Lier les rôles aux groupes.',
        'Link templates to queues.' => '',
        'Links 2 tickets with a "Normal" type link.' => 'Lier deux demandes d\'un lien « Normal ».',
        'Links 2 tickets with a "ParentChild" type link.' => 'Lier deux demandes d\'un lien « ParentChild » (parent enfant).',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Liste des fichiers CSS qui doivent toujours être téléchargés sur l\'interface agent.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Liste des fichiers CSS qui doivent toujours être téléchargés sur l\'interface client.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Liste des fichiers CSS spécifiques au programme IE8 qui doivent toujours être téléchargés sur l\'interface agent.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Liste des fichiers CSS spécifiques au programme IE8 qui doivent toujours être téléchargés sur l\'interface client.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Liste des fichiers JavaScript qui doivent toujours être téléchargés sur l\'interface agent.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Liste des fichiers JavaScript qui doivent toujours être téléchargés sur l\'interface client.',
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
        'List view' => '',
        'Locked ticket.' => 'Demande verrouillée.',
        'Log file for the ticket counter.' => 'Fichier journal pour le compteur de demandes.',
        'Loop-Protection! No auto-response sent to "%s".' => 'Protection anti-boucle. Pas d\'auto réponse envoyée à "%s".',
        'Mail Accounts' => 'Comptes courriel',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'S\'assurer que l\'application vérifie l\'enregistrement du messager des adresses électroniques avant d\'envoyer un courriel ou de soumettre une demande téléphonique ou par courriel.',
        'Makes the application check the syntax of email addresses.' => 'S\'assurer que l\'application vérifie la syntaxe des adresses électroniques.',
        'Makes the picture transparent.' => 'Rendre l\'image transparente.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'S\'assurer que le gestionnaire de sessions utilise les témoins HTML. Si les témoins HTML sont désactivés ou que le navigateur du client les désactive, le système fonctionnera comme à l\'habitude et adjoindra l\'identification de la session aux liens.',
        'Manage OTRS Group services.' => '',
        'Manage PGP keys for email encryption.' => 'Gérer les clés PGP pour le cryptage des courriels.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gérer les comptes POP3 ou IMAP afin d\'aller y chercher des courriels.',
        'Manage S/MIME certificates for email encryption.' => 'Gérer les certificats S/MIME pour le cryptage des courriels.',
        'Manage existing sessions.' => 'Gérer les sessions existantes.',
        'Manage notifications that are sent to agents.' => 'Gérer les notifications qui sont envoyées aux agents.',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Le nombre maximal de caractères de la table de renseignements du client (numéro de téléphone et courriel) dans l\'écran de rédaction.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Le nombre maximal de lignes des boîtes des agents informés de l\'interface agent.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Le nombre maximal de lignes des boîtes des agents impliqués de l\'interface agent.',
        'Max size of the subjects in an email reply.' => 'La taille maximale des sujets des réponses courriels.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Le nombre maximal quotidien de réponses automatiques à sa propre adresse électronique (boucle de protection).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'La taille maximale en kilo-octets des courriels qui peuvent être récupérés par POP3, POP3S, IMAP, IMAPS.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Le nombre maximal de demandes à afficher dans les résultats de recherche de l\'interface agent.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Le nombre maximal de demandes à afficher dans les résultats de recherche de l\'interface client.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Le nombre maximal de caractères dans la table de renseignements du client dans la synthèse de la demande.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Module de sélection du destinataire dans l\'écran de nouvelle demande de l\'interface client.',
        'Module to check customer permissions.' => 'Module de vérification des permissions du client.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'Module de vérification de l\'appartenance d\'un utilisateur à un groupe. L\'accès est permis si l\'utilisateur appartient au groupe spécifié et qu\'il possède une permission de lecture seule ou de lecture et écriture.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => 'Module de vérification de l\'agent responsable de la demande.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Module de vérification des permissions des groupes pour les accès aux demandes des clients.',
        'Module to check the owner of a ticket.' => 'Module de vérification du propriétaire d\'une demande.',
        'Module to check the watcher agents of a ticket.' => 'Module de vérification des agents de surveillance d\'une demande. ',
        'Module to compose signed messages (PGP or S/MIME).' => 'Module de rédaction des messages signés (PGP ou S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Module de cryptage des messages (PGP ou S/MIME).',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Module qui permet de filtrer et de manipuler les messages entrants. Ce module permet de bloquer ou d\'ignorer tous les pourriels dont le champ d\'expéditeur comporte la valeur : noreply@address (pasderéponse@adresse).',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => 'Module qui génère des statistiques du temps alloué aux demandes.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Module qui génère un profil «OpenSearch » HTML pour les courtes recherches dans l\'interface agent.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Module qui génère un profil «OpenSearch » HTML pour les courtes recherches dans l\'interface client.',
        'Module to generate ticket solution and response time statistics.' =>
            'Module qui génère des statistiques de résolution de demandes et de temps de réponse.',
        'Module to generate ticket statistics.' => 'Module qui génère des statistiques concernant les demandes.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Module d\'affichage des notifications et des escalades (Affichage maximal (ShownMax) : nombre maximal d\'escalades affichées, Escalade à venir (EscalationInMinutes) : affiche les demandes qui escaladeront, Temps de cache (CacheTime) : temps de cache des escalades prévues en secondes.)',
        'Module to use database filter storage.' => 'Module qui permet d\'utiliser la mise en mémoire des filtres de base de données.',
        'Multiselect' => 'Multi-choix',
        'My Queues and My Services' => '',
        'My Queues or My Services' => '',
        'My Services' => '',
        'My Tickets' => 'Mes demandes',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Dénomination des files personnalisées. Les files personnalisées réfèrent aux files que vous avez choisies comme favorites.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'Nom x',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Une nouvelle demande a été créée: [%s] créée (Q=%s;P=%s;S=%s).',
        'New Window' => '',
        'New email ticket' => 'Nouvelle demande courriel',
        'New owner is "%s" (ID=%s).' => 'Le nouveau propriétaire est "%s" (ID=%s).',
        'New phone ticket' => 'Nouvelle demande téléphonique',
        'New process ticket' => '',
        'New responsible is "%s" (ID=%s).' => 'Mise à jour du responsable',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Les états de demande possibles après qu\'une note téléphonique est ajoutée dans l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Les états de demande possibles après qu\'une note téléphonique est ajoutée dans l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'No Notification' => '',
        'None' => '',
        'Notification sent to "%s".' => 'Notification envoyée à "%s".',
        'Notifications (Event)' => 'Notifications (Évènement)',
        'Number of displayed tickets' => 'Nombre de demandes affichées ',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Nombre de lignes (par demande) affichées par l\'utilitaire de recherche dans l\'interface agent.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Nombre de demandes affichées dans chaque page de résultats de recherche dans l\'interface agent.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Nombre de demandes affichées dans chaque page de résultats de recherche dans l\'interface client.',
        'Old: "%s" New: "%s"' => 'État Avant: "%s" Après: "%s"',
        'Online' => '',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Out Of Office' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Surcharge (redéfini) les fonctions existantes dans Kernel::System::Ticket. Ce module est utilisé pour faciliter la personnalisation.',
        'Overview Escalated Tickets' => 'Visualisation des demandes escaladées',
        'Overview Refresh Time' => 'Actualisation de la visualisation tous les ',
        'Overview of all open Tickets.' => 'Visualisation des demandes ouvertes.',
        'PGP Key Management' => 'Gestion des clés PGP',
        'PGP Key Upload' => 'Téléchargement des clés PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Paramètres de l\'objet « création du masque suivant » (CreateNextMask) dans la vue des préférences de l\'interface agent.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'Paramètres de l\'objet « Personnalisation des files » (CustomQueue) dans la vue des préférences de l\'interface agent.',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'Paramètres de l\'objet « Notification des suivis » (FollowUpNotify) dans la vue des préférences de l\'interface agent.',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'Paramètres de l\'objet « Notification des délais de verrouillage » (LockTimeoutNotify) dans la vue des préférences de l\'interface agent.',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'Paramètres de l\'objet « Notification des déplacements » (MoveNotify) dans la vue des préférences de l\'interface agent.',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'Paramètres de l\'objet « Notification des nouvelles demandes » (NewTicketNotify) dans la vue des préférences de l\'interface agent.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Paramètres de l\'objet « Rafraîchissement » (RefreshTime) dans la vue des préférences de l\'interface agent.',
        'Parameters for the ServiceUpdateNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'Paramètres de l\'objet « Notification de la surveillance » (WatcherNotify) dans la vue des préférences de l\'interface agent.',
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
            'Paramètres de l\'arrière-plan du tableau de bord du calendrier des demandes de l\'interface agent. L\'option « Limit » (limite) précise le nombre d\'entrées affichées par défaut. L\'option « Group » (groupe) permet de restreindre l\'accès au module d\'extension (p.ex. Group: admin;group1;group2;). L\'option « Default » (par défaut) précise si l\'activation du module d\'extension se fait par défaut ou par l\'utilisateur. L\'option « CacheTTL » (durée de vie de la mémoire cache) précise le délai, en minutes, avant l\'expiration de la mémoire cache du module d\'extension.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Paramètres de l\'arrière-plan du tableau de bord des statistiques de l\'interface agent. L\'option « Limit » (limite) précise le nombre d\'entrées affichées par défaut. L\'option « Group » (groupe) permet de restreindre l\'accès au module d\'extension (p.ex. Group: admin;group1;group2;). L\'option « Default » (par défaut) précise si l\'activation du module d\'extension se fait par défaut ou par l\'utilisateur. L\'option « CacheTTL » (durée de vie de la mémoire cache) précise le délai, en minutes, avant l\'expiration de la mémoire cache du module d\'extension.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            'Paramètres des pages de la visualisation des champs dynamiques (les pages dans lesquelles sont affichés les champs dynamiques).',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Paramètres des pages de la visualisation des demandes en affichage « M » (moyen) (les pages dans lesquelles sont affichées les demandes).',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Paramètres des pages de la visualisation des demandes en affichage « S » (petit)  (les pages dans lesquelles sont affichées les demandes).',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Paramètres des pages de la visualisation des demandes en affichage « L » (grand) (les pages dans lesquelles sont affichées les demandes).',
        'Parameters of the example SLA attribute Comment2.' => 'Paramètres des attributs SLA montrés en exemple (commentaire no 2).',
        'Parameters of the example queue attribute Comment2.' => 'Paramètres des attributs de file montrés en exemple (commentaire no 2).',
        'Parameters of the example service attribute Comment2.' => 'Paramètres des attributs de service montrés en exemple (commentaire no 2).',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Chemin du fichier journal (s\'appliquera uniquement si vous sélectionnez l\'option « FS » pour le module « LoopProtectionModule », car elle est obligatoire).',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            'Chemin du fichier où sont stockés les réglages de l\'objet « Objet de la file » (QueueObject) de l\'interface agent.',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            'Chemin du fichier où sont stockés les réglages de l\'objet « Objet de la file » (QueueObject) de l\'interface client.',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            'Chemin du fichier où sont stockés les réglages de l\'objet « Objet de la demande » (TicketObject) de l\'interface agent.',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            'Chemin du fichier où sont stockés les réglages de l\'objet « Objet de la demande » (TicketObject) de l\'interface client.',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            'Exécute l\'action configurée pour chaque évènement (à titre de demandeur) pour les services Web configurés.',
        'Permitted width for compose email windows.' => 'Largeur autorisée pour les fenêtres de rédaction de courriels.',
        'Permitted width for compose note windows.' => 'Largeur autorisée pour les fenêtres de rédaction de notes.',
        'Picture-Upload' => 'Télécharger l\'image',
        'PostMaster Filters' => 'Filtres du maître de poste',
        'PostMaster Mail Accounts' => 'Comptes du maître de poste',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'ProcessID' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Protection contre les attaques sous formes de requêtes illégitimes entre sites (pour de plus amples renseignements consulter le http://fr.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Vue des files',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => ' ',
        'Refresh interval' => 'Intervalle de rafraîchissement',
        'Removed subscription for user "%s".' => 'Désabonnement pour l\'utilisateur "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Remplace l\'expéditeur original par l\'adresse de courrier électronique du client actuel dans les réponses écrites au moyen de l\'écran de rédaction des demandes de l\'interface agent.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Permissions requises pour changer le client d\'une demande dans l\'interface agent.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de fermeture de la demande de l\'interface agent.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de retour de la demande dans l\'interface agent.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de rédaction de la demande dans l\'interface agent.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de suivi de la demande dans l\'interface agent.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de texte libre de la demande dans l\'interface agent.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de fusion de la synthèse de la demande dans l\'interface agent.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de notes de l\'interface agent.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de propriété de la synthèse de la demande de l\'interface agent.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran des demandes téléphoniques entrantes de l\'interface agent.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran des demandes téléphoniques sortantes de l\'interface agent.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de priorité de la synthèse de la demande dans l\'interface agent.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Permissions requises pour utiliser l\'écran de responsabilité de l\'interface agent.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Réinitialise et déverrouille le propriétaire de la demande lorsque cette dernière a été déplacée dans une autre file.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Restaure une demande archivée (seulement si l\'événement est un changement d\'état depuis un état fermé vers n\'importe quel état ouvert disponible).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles <-> Groups' => 'Rôles <-> Groupes',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Lors de l\'accès au module « AdminCustomerUser », le présent module exécute une recherche initiale de caractères de remplacement des utilisateurs clients existants.',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Exécute le système en mode « Démo ». Si vous sélectionnez « Oui », les agents pourront modifier leurs préférences comme la langue et le thème en passant par l\'interface Web de l\'agent. Ces changements ne seront admissibles que pour la présente session. Il ne sera pas possible pour les agents de modifier leurs mots de passe.',
        'S/MIME Certificate Upload' => 'Téléchargement du certificat S/MIME',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            'Sauvegarde les pièces jointes des articles. Le mode « DB » enregistre toutes les données de la base de données (ce mode n\'est pas recommandé pour l\'enregistrement de pièces jointes lourdes). Le mode « FS » enregistre les données du système de fichier ce qui est plus rapide mais oblige le serveur Web à fonctionner sous l\'utilisateur OTRS. Vous pouvez changer de module allègrement, sans perte de données, même sur un système qui est déjà en fonction.',
        'Schedule a maintenance period.' => '',
        'Search Customer' => 'Recherche d\'un client',
        'Search User' => '',
        'Search backend default router.' => 'Recherche du routeur par défaut de l\'arrière-plan.',
        'Search backend router.' => 'Recherche du routeur de l\'arrière-plan.',
        'Second Queue' => '',
        'Select your frontend Theme.' => 'Choix du thème de l\'interface',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Sélection du module de gestion des téléchargements en passant par l\'interface Web. L\'option « DB » stocke tous les téléchargements dans la base de données, « FS » utilise le fichier système.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Sélection du mode de génération de numéro demande. Le mode« AutoIncrement » incrémente le numéro de la demande comme suit : l\'identification du système et le compteur (par ex. 1010128, 1010139). Le mode « Date » génère un numéro de demande selon la date du jour, l\'identification du système et le compteur ; par exemple, année.mois.jour.identification du système.compteur (200206231010138 ou 200206231010139). le mode « Datechecksum » adjoindra le compteur à la date et à l\'identification du système en tant que somme de contrôle. La somme de contrôle sera renouvelée quotidiennement. Le format va comme suit : année.mois.jour.identification du système. compteur.somme de contrôle (par ex. 2002070110101520, 2002070110101535). Le mode « Random » génère un numéro de demande aléatoire selon le format « SystemID. Random », c\'est-à-dire identification du système.numéro aléatoire (par ex. 100057866352, 103745394596 ).',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my queues/services.' =>
            '',
        'Send me a notification if the service of a ticket is changed to a service in "My Services" and the ticket is in a queue where I have read permissions.' =>
            '',
        'Send me a notification if there is a new ticket in my queues/services.' =>
            '',
        'Send new ticket notifications if subscribed to' => '',
        'Send notifications to users.' => 'Envoyer des notifications aux utilisateurs.',
        'Send service update notifications' => '',
        'Send ticket follow up notifications if subscribed to' => '',
        'Sender type for new tickets from the customer inteface.' => 'Type d\'expéditeur des nouvelles demandes dans l\'interface client.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'N\'envoie la notification de suivi de l\'agent qu\'au propriétaire si la demande est déverrouillée (par défaut, on enverrait normalement la notification à tous les agents).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Envoie tous les courriels sortants en tant que copie conforme invisible (bcc) à l\'adresse spécifiée. Veuillez n\'utiliser cette option que pour les copies de secours.',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'Envoie les notifications aux clients identifiés seulement. En règle générale, si aucun client n\'est identifié, le dernier expéditeur client recevra la notification.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Envoie les notifications de rappel des demandes déverrouillées après que la date de rappel est atteinte (envoyées seulement au propriétaire de la demande).',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Envoie les notifications qui sont configurées dans l\'interface de l\'administrateur sous « Notification (événement) ».',
        'Service update notification' => '',
        'Service view' => '',
        'Set sender email addresses for this system.' => 'Choisir les adresses électroniques pour l\'envoi des courriels du système.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Règle le nombre de pixels par défaut des articles HTML (en file) de la synthèse de la demande dans l\'interface agent (AgentTicketZoom).',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Règle le nombre maximal de pixels des articles HTML (en file) de la synthèse de la demande dans l\'interface agent (AgentTicketZoom).',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Réglez à « Oui » si vous faites confiance à toutes vos clés publiques et privées du logiciel PGP, même si elles ne sont pas certifiées par une signature de confiance.',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'Règle si l\'agent doit sélectionner le propriétaire de la demande.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Règle le délai d\'attente (PendingTime) d\'une demande à 0 si son état est modifié pour un état sans attente.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Règle l\'âge, en minutes, (premier niveau) des files en surbrillance qui contiennent des demandes intouchées.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Règle l\'âge, en minutes, (deuxième niveau) des files en surbrillance qui contiennent des demandes intouchées.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Règle le niveau de configuration de l\'administateur. Selon le niveau de configuration, certaines options de configuration du système (sysconfig) seront affichées. Voici les différents niveaux de configuration en ordre croissant : expert, avancé et débutant. Plus le niveau de configuration est élevé (par exemple, le niveau débutant est le plus élevé), moins il sera possible pour l\'utilisateur de configurer accidentellement le système de façon à le rendre inutilisable.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Règle le type d\'article par défaut des nouvelles demandes par courriel dans l\'interface agent.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Règle le type d\'article par défaut des nouvelles demandes téléphoniques dans l\'interface agent.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Règle le corps de texte par défaut des notes ajoutées dans l\'écran de fermeture de la demande dans l\'interface agent.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Règle le corps du texte par défaut des notes ajoutées dans l\'écran de déplacement de la demande dans l\'interface agent.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran de notes de la demande dans l\'interface agent.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran du propriétaire dans la synthèse de la demande de l\'interface agent.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran de mise en attente dans la synthèse de la demande de l\'interface agent.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran de priorité dans la synthèse de la demande de l\'interface agent.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Établit le corps du texte par défaut des notes ajoutées à l\'écran du responsable de la demande de l\'interface agent.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Établit le type de lien par défaut des demandes partagées de l\'interface agent.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Établit l\'état suivant par défaut des nouvelles demandes téléphoniques dans l\'interface agent.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Établit l\'état suivant par défaut des demandes après la création d\'une demande par courriel dans l\'interface agent.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Établit le texte par défaut de la note dans les nouvelles demandes téléphoniques dans l\'interface agent, par exemple : « Nouvelle demande téléphonique ».',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Établit la priorité par défaut des nouvelles demandes par courriel dans l\'interface agent.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Établit la priorité par défaut des nouvelles demandes téléphoniques dans l\'interface agent.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Établit le type d\'expéditeur par défaut des nouvelles demandes par courriel dans l\'interface agent.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Établit le type d\'expéditeur par défaut des nouvelles demandes téléphoniques dans l\'interface agent.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Établit le sujet par défaut des nouvelles demandes par courriel dans l\'interface agent (p. ex. « Courriel sortant »).',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Établit le sujet par défaut des nouvelles demandes téléphoniques dans l\'interface agent (p. ex. « Appel téléphonique »).',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de fermeture de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de déplacement des demandes de l\'interface agent.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de notes de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran du propriétaire dans la synthèse de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de mise en attente dans la synthèse de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran de priorité dans la synthèse de la demande de l\'interface agent.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Établit le sujet par défaut des notes ajoutées à l\'écran du responsable de la demande de l\'interface agent.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Établit le texte par défaut des nouvelles demandes par courriel de l\'interface agent.',
        'Sets the display order of the different items in the preferences view.' =>
            'Établit l\'ordre d\'affichage des différents articles dans la vue des préférences.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'Établit le temps d\'inactivité (en secondes) après lequel une session est fermée et l\'utilisateur est déconnecté.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            'Établit le nombre de chiffre minimal du compteur (si le mode « Augmentation automatique » (AutoIncrement) a été sélectionné). Par défaut, le compteur commence à 10 000 donc, 5 chiffres.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Établit le nombre de lignes affichées dans les messages (p. ex. lignes affichées par demande dans la file de synthèse (QueueZoom).',
        'Sets the options for PGP binary.' => 'Établit les options de code binaire du logiciel PGP.',
        'Sets the order of the different items in the customer preferences view.' =>
            'Établit l\'ordre des différents articles dans la vue des préférences du client.',
        'Sets the password for private PGP key.' => 'Établit le mot de passe pour une clé PGP privée.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Établit les unités de temps préférées (p. ex. unité de travail, heures, minutes).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Établit le préfix du fichier de script sur le serveur, compte tenu de sa configuration sur le serveur Web. Le réglage est utilisé en tant que variable, OTRS_CONFIG_ScriptAlias est trouvé sous toutes les formes de message utilisé par l\'application afin de créer des liens vers les demandes du système.',
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
            'Établit l\'agent responsable de la demande dans l\'écran de fermeture de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de demandes groupées de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de texte libre de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de notes de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Établit l\'agent responsable de la demande dans l\'écran du responsable de l\'interface agent.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Établit le service dans l\'écran de fermeture de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Service needs to be activated).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Établit le service dans l\'écran de texte libre de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Service needs to be activated).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Établit le service dans l\'écran de notes de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Service needs to be activated).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Établit le service dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Service needs to be activated).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Établit le service dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Service needs to be activated).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Établit le service dans l\'écran de priorité de la synthèse de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Service needs to be activated).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Établit le service dans l\'écran du responsable de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Service needs to be activated).',
        'Sets the size of the statistic graph.' => 'Établit la taille du graphique de la statistique.',
        'Sets the stats hook.' => 'Règle le point d\'accueil pour le logiciel de statistiques.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'Règle le fuseau horaire du système (exige l\'utilisation du temps universel coordonné, UTC). À défaut, l\'heure affichée sera différente de l\'heure locale.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de fermeture de l\'interface agent.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran d\'action groupée de l\'interface agent.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de texte libre de l\'interface agent.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de notes de l\'interface agent.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de propriété de la synthèse de la demande dans l\'interface agent.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de mise en attente de la synthèse de la demande dans l\'interface agent.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de priorité de la synthèse de la demande dans l\'interface agent.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Règle le propriétaire de la demande dans l\'écran de responsabilité de l\'interface agent.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Règle le type de demande dans l\'écran de fermeture de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Règle le type de demande dans l\'écran d\'action groupée de l\'interface agent.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Règle le type de demande dans l\'écran de texte libre de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Règle le type de demande dans l\'écran de notes de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Règle le type de demande dans l\'écran de propriété de la synthèse de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Règle le type de demande dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Règle le type de demande dans l\'écran de priorité de la synthèse de la demande de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Type needs to be activated).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Règle le type de demande dans l\'écran de responsabilité de l\'interface agent, par exemple : Demande : Le service doit être activé (Ticket::Type needs to be activated).',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => 'Règle le type de temps qui doit être affiché.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Règle le délai (en secondes) des téléchargements HTTP ou FTP.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Règle le délai (en secondes) des téléchargements de paquets. Écrase le délai des agents utilisateurs Web « WebUserAgent::Timeout ».',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Règle le fuseau horaire par utilisateur (exige l\'utilisation du temps universel coordonné, UTC, par le système et un réglage à l\'attribut UTC de l\'élément fuseau horaire (TimeZone). À défaut, l\'heure affichée sera différente de l\'heure locale.',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'Règle le fuseau horaire par utilisateur en se basant sur Java Script ou sur l\'outil d\'identification du décalage horaire du navigateur au moment de la connexion.',
        'Should the cache data be help in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Affiche la sélection des responsables dans les demandes par courriel ou par téléphone de l\'interface agent.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Affiche les articles en RTF même si l\'option d\'écriture RTF est désactivée.',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Affiche un compte des icônes de la synthèse de la demande si des pièces sont jointes à l\'article.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien d\'abonnement ou de désabonnement à une demande dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de lier une demande à un objet dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de fusionner des demandes dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet l\'accès à l\'historique d\'une demande dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet l\'ajout d\'un champ de texte libre dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet l\'ajout d\'une note dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet l\'ajout d\'une note dans chaque visualisation de la demande de l\'interface agent.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet la fermeture d\'une demande dans chaque visualisation de la demande de l\'interface agent.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui pemet la fermeture d\'une demande dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Dans le menu, affiche un lien qui permet la suppression d\'une demande dans chaque visualisation de la demande de l\'interface agent. Des contrôles d\'accès supplémentaires pour permettre l\'affichage ou non de ce lien peuvent être effectués en utilisant la clé « Group » (groupe) et un contenu tel que « rw:group1;move_into:group2 » (lecture et écriture : groupe 1; déplacer:groupe 2). ',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Dans le menu, affiche un lien qui permet la suppression d\'une demande dans la vue de la synthèse de la demande de l\'interface agent. Des contrôles d\'accès supplémentaires pour permettre l\'affichage ou non de ce lien peuvent être effectués en utilisant la clé « Group » (groupe) et un contenu tel que « rw:group1;move_into:group2 » (lecture et écriture : groupe 1; déplacer:groupe 2). ',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet le retour dans la vue de la synthèse de la demande de l\'interface agent. Des contrôles d\'accès supplémentaires pour permettre l\'affichage ou non de ce lien peuvent être effectués en utilisant la clé « Group » (groupe) et un contenu tel que « rw:group1;move_into:group2 » (lecture et écriture : groupe 1; déplacer:groupe 2). ',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de verrouiller ou de déverrouiller une demande dans les visualisations des demandes de l\'interface agent.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de verrouiller ou de déverrouiller une demande dans les synthèses des demandes de l\'interface agent.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet le déplacement d\'une demande dans chaque visualisation de demandes de l\'interface agent.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet l\'impression d\'une demande ou d\'un article dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de voir le client qui a effectué la demande dans la visualisation de la demande de l\'interface agent.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de voir l\'historique d\'une demande dans chaque visualisation de demandes de l\'interface agent.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de voir le propriétaire d\'une demande dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet de voir la priorité d\'une demande dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet l\'agent responsable d\'une demande dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'Dans le menu, affiche le lien qui permet la mise en attente d\'une demande dans la vue de la synthèse de la demande de l\'interface agent.',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Dans le menu, affiche un lien qui permet le réglage d\'une demande en tant que pourriel dans chaque visualisation de demandes de l\'interface agent. Des contrôles d\'accès supplémentaires pour permettre l\'affichage ou non de ce lien peuvent être effectués en utilisant la clé « Group » (groupe) et un contenu tel que « rw:group1;move_into:group2 » (lecture et écriture : groupe 1; déplacer:groupe 2). ',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Dans le menu, affiche un lien qui permet le réglage de la priorité d\'une demande dans chaque visualisation de la demande de l\'interface agent.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Dans le menu, affiche un lien afin de faire la synthèse de la demande dans les visualisations des demandes de l\'interface agent.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Affiche un lien pour accéder aux pièces jointes aux articles au moyen d\'un visualiseur html en ligne dans la vue de la synthèse de l\'article de l\'interface agent.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Affiche un lien pour télécharger les pièces jointes aux articles dans la vue de la synthèse de l\'article de l\'interface agent.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Affiche un lien pour voir une synthèse de la demande par courriel en texte en clair.',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Affiche un lien pour indiquer qu\'une demande est un pourriel dans la vue de la synthèse de la demande de l\'agent interface. Il est possible d\'avoir un contrôle d\'accès supplémentaire afin de montrer ou non ce lien en utilisant la clé « Groupe » (Group) et un contenu comme : « rw:group1;move_into:group2 ».',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de texte libre de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de notes de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Affiche une liste des agents qui participent au traitement de la demande dans l\'écran du responsable de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de texte libre de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de notes de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Affiche une liste de tous les agents qui ont les permissions requises de la file ou de la demande afin de déterminer lequel ou lesquels devraient être informés de ces permissions dans l\'écran du responsable de la demande de l\'interface agent.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Affiche la visualisation de la demande en format « L » (Grand) (« CustomerInfo => 1 - » affiche l\'information relative aux clients, et « CustomerInfoMaxSize » affiche la taille maximale, en caractères, de l\'information relative aux clients.)',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'Affiche les files en lecture seule et en lecture et écriture dans la vue des files.',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Affiche les demandes ouvertes (même si elles sont verrouillées) dans la vue de l\'escalade de l\'interface agent.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Affiche les demandes ouvertes (même si elles sont verrouillées) dans la vue des états de l\'interface agent.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Affiche les articles de la demande (étendue) dans la vue de la synthèse.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Affiche les identifiants clients dans un champ de sélections multiples (n\'est pas utile si vous avez de nombreux identifiants clients).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Affiche la sélection de propriétaires de demandes par courriel ou par téléphone de l\'interface agent.',
        'Shows colors for different article types in the article table.' =>
            'Affiche différentes couleurs pour les types d\'article de la table des articles.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Affiche l\'historique des demandes de clients dans les « Demandes téléphoniques de l\'agent » (AgentTicketPhone), les « Demandes par courriel de l\'agent » (AgentTicketEmail) et les « Demandes des clients de l\'agent » (AgentTicketCustomer).',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Affiche soit le sujet du dernier article du client ou le titre de la demande dans la visualisation en format « S » (Petit).',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Affiche les listes de files existantes dans le système de type parents et enfants sous la forme d\'une arborescence ou d\'une liste.',
        'Shows information on how to start OTRS Scheduler' => '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Affiche les attributs activés de la demande dans l\'interface client (0 = activé et 1 = désactivé).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Affiche les articles triés dans l\'ordre habituel ou inverse dans la synthèse de la demande de l\'interface agent. ',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Affiche les renseignements de l\'utilisateur client (numéro de téléphone et adresse de courrier électronique) dans l\'écran de rédaction.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Affiche les renseignements de l\'utilisateur client dans la vue de la synthèse de la demande.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Affiche le message du jour dans le tableau de bord de l\'agent. L\'option « Group » (groupe) permet de restreindre l\'accès au module d\'extension (p.ex. Group: admin;group1;group2;). L\'option « Default » (par défaut) précise si l\'activation du module d\'extension se fait par défaut ou par l\'utilisateur. ',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Affiche le message du jour dans l\'écran d\'ouverture de session de l\'interface agent.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Affiche l\'historique de la demande (en ordre décroissant) dans l\'interface agent.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de fermeture de l\'interface agent.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de déplacement de l\'interface agent.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de demandes groupées de l\'interface agent.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de texte libre de l\'interface agent.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de notes de l\'interface agent.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Affiche le choix de priorités de la demande dans l\'écran du responsable de l\'interface agent.',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'Affiche les champs de titre dans l\'écran de fermeture de la demande de l\'interface agent.',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'Affiche les champs de titre dans l\'écran de texte libre de la demande de l\'interface agent.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Affiche les champs de titre dans l\'écran de notes de la demande de l\'interface agent.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Affiche les champs de titre dans l\'écran du propriétaire de la synthèse de la demande de l\'interface agent.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Affiche les champs de titre dans l\'écran de mise en attente de la synthèse de la demande de l\'interface agent.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Affiche les champs de titre dans l\'écran de priorité de la synthèse de la demande de l\'interface agent.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Affiche les champs de titre dans l\'écran de responsabilité de la synthèse de la demande dans l\'interface agent.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Le réglage à « Oui » permet l\'affichage de la durée dans sa forme longue (jours, heures, minutes ; le réglage à « Non » l\'affiche dans sa forme courte (jours, heures.',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'Le réglage à « Oui » affiche la description complète de la durée (jours, heures, minutes); le réglage à « Non » n\'affiche que les premières lettres (j, h, m).',
        'Skin' => 'Habillage ',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Classe les demandes (en ordre croissant ou décroissant) lorsqu\'une seule file est sélectionnée dans la vue des files et après que les demandes sont classées par priorité. Valeurs : 0 = en ordre croissant (Par défaut, la plus ancienne en haut de la file), 1 = en ordre décroissant (la plus récente en haut de la file). Utilise l\'identification de la file (QueueID) en tant que clé et « 0 » ou « 1 » en tant que valeur.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Exemple de réglage du logiciel « Spam Assassin ». Ignore les courriels comportant des « SpamAssassin ».',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Exemple de réglage du logiciel « Spam Assassin ». Déplace les courriels comportant des « SpamAssasin » dans la file de pourriels.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Précise si un agent devrait recevoir un courriel de notification pour ses propres actions.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => 'Précise la couleur de fond du graphique.',
        'Specifies the background color of the picture.' => 'Précise la couleur de fond de l\'image.',
        'Specifies the border color of the chart.' => 'Précise la couleur des bordures du graphique.',
        'Specifies the border color of the legend.' => 'Précise la couleur des bordures de la légende.',
        'Specifies the bottom margin of the chart.' => 'Précise la marge inférieure du graphique.',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            'Précise les différents types d\'articles qui seront utilisés dans le système.',
        'Specifies the different note types that will be used in the system.' =>
            'Précise les différents types de notes qui seront utilisés dans le système.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Précise le répertoire d\'enregistrement des données, si le mode « FS » est activé dans le module de stockage des demandes « TicketStorageModule ».',
        'Specifies the directory where SSL certificates are stored.' => 'Précise le répertoire dans lequel les certificats SSL sont enregistrés.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Précise le répertoire dans lequel les certificats SSL privés sont enregistrés.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Précise l\'adresse électronique qui devrait être utilisée par l\'application pour envoyer les notifications. L\'adresse électronique est utilisée pour construire le nom d\'affichage des courriels envoyés par le gestionnaire des notifications (par exemple « OTRS Notification Master » otrs@votre.exemple.com). Vous pouvez utiliser la variable « OTRS_CONFIG_FQDN » dans votre configuration ou utiliser une autre adresse électronique. Les notifications sont des messages tels que « en::Customer::QueueUpdate » ou « en::Agent::Move ».',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => 'Précise la marge de gauche du graphique.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Précise le nom qui devrait être utilisé par l\'application pour envoyer les notifications. Le nom de l\'expéditeur est utilisé pour construire le nom d\'affichage des courriels envoyés par le gestionnaire des notifications (par exemple « OTRS Notification Master » otrs@votre.exemple.com). Vous pouvez utiliser la variable « OTRS_CONFIG_FQDN » dans votre configuration ou utiliser une autre adresse électronique. Les notifications sont des messages tels que « en::Customer::QueueUpdate » ou « en::Agent::Move ».',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Précise le chemin menant au fichier du logo de l\'en-tête de page (gif ou jpg ou png, de 700 x 100 pixels).',
        'Specifies the path of the file for the performance log.' => 'Précise le chemin menant au fichier pour l\'enregistrement des performances.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Précise le chemin menant au convertisseur qui permet la vue des fichiers Microsoft Excel dans l\'interface Web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Précise le chemin menant au convertisseur qui permet la vue des fichiers Microsoft Word dans l\'interface Web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Précise le chemin menant au convertisseur qui permet la vue des documents PDF dans l\'interface Web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Précise le chemin menant au convertisseur qui permet la vue des fichiers XML dans l\'interface Web.',
        'Specifies the right margin of the chart.' => 'Précise la marge de droite du graphique.',
        'Specifies the text color of the chart (e. g. caption).' => 'Précise la couleur du texte du graphique (des sous-titres par exemple).',
        'Specifies the text color of the legend.' => 'Précise la couleur du texte de la légende.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Précise le texte qui doit apparaître dans le fichier journal pour indiquer l\'entrée d\'un script CGI.',
        'Specifies the top margin of the chart.' => 'Précise la marge supérieure du graphique.',
        'Specifies user id of the postmaster data base.' => 'Précise l\'identification de l\'utilisateur de la base de données du maître de poste.',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Permissions couramment accordées aux agents dans cette application. Des permissions supplémentaires peuvent être inscrites dans ces champs. Les permissions doivent être définies pour être efficaces. Quelques permissions prédéfinies ont été fournies : note, fermer, en attente, client, texte libre, déplacer, rédiger, responsable, transférer et retourner. Assurez-vous que « rw » (lecture et écriture) soit toujours la dernière permission enregistrée.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Chiffre de départ du dénombrement statistique. Chaque nouvelle statistique incrémente ce chiffre.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Démarre une recherche de caractères de remplacement de l\'object actif après le démarrage du masque de l\'objet lié.',
        'Stat#' => 'Statistique no ',
        'Statistics' => 'Statistiques',
        'Status view' => 'Vue des états ',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'Enregistre les témoins de connexion après la fermeture du navigateur',
        'Strips empty lines on the ticket preview in the queue view.' => 'Élimine les lignes vides dans l\'aperçu de la demande de la vue des files.',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'System Maintenance' => '',
        'System Request (%s).' => 'Requête système',
        'Templates <-> Queues' => '',
        'Textarea' => 'Zone de texte',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            'Le compte courriel du maître de poste « bin/PostMasterMailAccount.pl » se reconnectera à l\'hôte POP3, ou POP3S, ou IMAP, ou IMAPS après avoir atteint le nombre de messages précisé.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'Ceci est le nom interne (InternalName) qui devrait être utilisé pour l\'habillage dans l\'interface de l\'agent. Veuillez vérifier les habillages disponibles dans « Frontend::Agent::Skins ».',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Ceci est le nom interne (InternalName) qui devrait être utilisé pour l\'habillage dans l\'interface du client. Veuillez vérifier les habillages disponibles dans « Frontend::Customer::Skins ».',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Le séparateur entre le point d\'accueil de la demande (TicketHook) et le numéro de la demande. Par ex. « \': ou \'. »',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'La période en minutes, à la suite de l\'émission d\'un événement, après laquelle la notification d\'une nouvelle escalade et le démarrage d\'événements sont supprimés. ',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            'Le format du sujet. « Gauche » signifie « [TicketHook#:12345] Un sujet quelconque » et « Droite » signifie « Un sujet quelconque [TicketHook#:12345] ». « Aucun » signifie « Un sujet quelconque » sans numéro de demande, Dans ce dernier cas, vous devriez permettre PostmasterFollowupSearchInRaw ou PostmasterFollowupSearchInReferences de reconnaître les suivis effectués à partir de l\'en-tête ou du corps du courriel.',
        'The headline shown in the customer interface.' => 'Le titre vedette affiché dans l\'interface client.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'L\'identifiant d\'une demande, par ex. Demande no , Appel no , Ma demande no. Par défaut, c\'est le numéro de demande qui apparaîtra.',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Le logo affiché dans l\'en-tête de l\'interface agent. L\'adresse URL vers l\'image peut être une adresse relative vers le répertoire d\'habillages ou une adresse complète vers un serveur Web distant.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Le logo affiché dans l\'en-tête de l\'interface client. L\'adresse URL vers l\'image peut être une adresse relative vers le répertoire d\'habillages ou une adresse complète vers un serveur Web distant.',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'Le logo affiché dans le haut de la fenêtre d\'ouverture de session de l\'interface agent. L\'adresse URL vers l\'image doit être une adresse relative vers le répertoire d\'habillages.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Le texte affiché en début de sujet dans une réponse courriel, p. ex. : Rép.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Le texte affiché en début de sujet lorsqu\'un courriel est transféré, p. ex. : Tr.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Le module et la fonction d\'avant exécution seront exécutés pour chacune des requêtes (si précisé). Le module s\'avère utile pour vérifier certaines options des utilisateurs ou pour afficher des nouvelles au sujet des dernières applications offertes.',
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
            'Le réglage vous permet de modifier la liste prédéfinie des pays. La modification peut-être particulièrement utile si vous souhaitez travailler avec une courte liste de pays.',
        'Ticket Queue Overview' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            'Module d\'événements des demandes qui déclenche les arrêts d\'escalade.',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'La demande a été déplacée dans la file "%s" (%s) - Ancienne file : "%s" (%s).',
        'Ticket overview' => 'Visualisation de la demande ',
        'TicketNumber' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Temps, en secondes, à ajouter à l\'heure actuelle dans le cas d\'une mise en attente (par défaut : 86400 = 1 jour).',
        'Title updated: Old: "%s", New: "%s"' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Permet de basculer dans l\'affichage de la liste des fonctions des compagnons de OTRS dans le gestionnaire de paquets.',
        'Toolbar Item for a shortcut.' => 'Élément de la barre d\'outils offrant un raccourci.',
        'Tree view' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Active les animations de l\'interface utilisateur graphique. En cas de problème avec les animations, par exemple en matière de performance, vous pouvez les désactiver ici.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Active la vérification des adresses IP distantes. Le réglage devrait être « Non » si l\'application est utilisée par exemple au moyen d\'un serveur mandataire ou d\'un accès par ligne commutée, car l\'adresse IP distante est habituellement différente pour les requêtes.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Demande déverrouillée.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Met à jour l\'indicateur de prise de connaissance (vue) de la demande si chacun des articles ont été vus ou qu\'un nouvel article a été créé.',
        'Update and extend your system with software packages.' => 'Mettre à jour et améliorer le système au moyen de paquets.',
        'Updated SLA to %s (ID=%s).' => 'SLA positionné à %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Service positionné à %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Type positionné à %s (ID=%s).',
        'Updated: %s' => 'Mise à jour: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Mise à jour: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Met à jour l\'index des escalades des demandes après qu\'un attribut de demande a été mis à jour.',
        'Updates the ticket index accelerator.' => 'Effectue la mise à jour de l\'accélérateur de l\'index des demandes.',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Utilise les destinataires de la liste de réponses en copie conforme lors de la rédaction de réponses par courriel dans l\'écran de rédaction de l\'interface agent.',
        'Uses richtext for viewing and editing notification events.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Voir les résultats du test de performance.',
        'View system log messages.' => 'Voir le journal.',
        'Wear this frontend skin' => 'Choisissez cet habillage',
        'Webservice path separator.' => 'Séparateur de chemins vers les services Web.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Lorsque des demandes sont fusionnées, le client peut en être informé par courriel en cochant la case « Informer l\'expéditeur ». Vous pouvez définir un texte pré-formaté qui pourra ensuite être modifié par les agents.',
        'Write a new, outgoing mail' => '',
        'Yes, but hide archived tickets' => '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Votre sélection de files préférées. Vous recevrez l\'information pertinente au sujet de ces files par courriel (si l\'option est activé).',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            '',

    };
    # $$STOP$$
    return;
}

1;
