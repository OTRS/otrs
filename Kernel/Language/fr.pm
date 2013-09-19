# --
# Kernel/Language/fr.pm - provides French language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# Copyright (C) 2004 Igor Genibel <igor.genibel at eds-opensource.com>
# Copyright (C) 2007 Remi Seguy <remi.seguy at laposte.net>
# Copyright (C) 2007 Massimiliano Franco <max-lists at ycom.ch>
# Copyright (C) 2004-2008 Yann Richard <ze at nbox.org>
# Copyright (C) 2009-2010 Olivier Sallou <olivier.sallou at irisa.fr>
# Copyright (C) 2011-2013 Raphaël Doursenaud <rdoursenaud@gpcsolutions.fr>
# Copyright (C) 2013 Dylan Oberson <dylan.oberson@epfl.ch>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-09-19 16:21:46

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
        'Off' => 'Désactivé',
        'off' => 'désactivé',
        'On' => 'Activé',
        'on' => 'activé',
        'top' => 'haut',
        'end' => 'fin',
        'Done' => 'Fait',
        'Cancel' => 'Annuler',
        'Reset' => 'Remise à zéro',
        'more than ... ago' => '',
        'in more than ...' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Today' => 'Aujourd\'hui',
        'Tomorrow' => 'Demain',
        'Next week' => 'Semaine prochaine',
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
        'Bug Report' => 'Rapport d\'anomalie',
        'Attention' => 'Attention',
        'Warning' => 'Attention',
        'Module' => 'Module',
        'Modulefile' => 'Fichier de module',
        'Subfunction' => 'sous-fonction',
        'Line' => 'Ligne',
        'Setting' => 'Paramètre',
        'Settings' => 'Paramètres',
        'Example' => 'Exemple',
        'Examples' => 'Exemples',
        'valid' => 'valide',
        'Valid' => 'Valide',
        'invalid' => 'invalide',
        'Invalid' => 'Invalide',
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
        'Need Action' => 'Requiert une action',
        'AddLink' => 'Ajouter un lien',
        'Link' => 'Lier',
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
        'Text' => 'Texte',
        'Standard' => 'Standard',
        'Lite' => 'Allégée',
        'User' => 'Utilisateur',
        'Username' => 'Identifiant',
        'Language' => 'Langue',
        'Languages' => 'Langues',
        'Password' => 'Mot de Passe',
        'Preferences' => 'Préférences',
        'Salutation' => 'En-tête',
        'Salutations' => 'En-têtes',
        'Signature' => 'Signature',
        'Signatures' => 'Signatures',
        'Customer' => 'Client',
        'CustomerID' => 'Code client',
        'CustomerIDs' => 'Codes client (Groupe)',
        'customer' => 'client',
        'agent' => 'opérateur',
        'system' => 'système',
        'Customer Info' => 'Information client',
        'Customer Information' => 'Information client',
        'Customer Company' => 'Entreprise du client',
        'Customer Companies' => 'Entreprises clientes',
        'Company' => 'Entreprise',
        'go!' => 'c\'est parti !',
        'go' => 'aller',
        'All' => 'Tout',
        'all' => 'tout',
        'Sorry' => 'Désolé',
        'update!' => 'mettre à jour !',
        'update' => 'mettre à jour',
        'Update' => 'Mettre à jour',
        'Updated!' => 'Mis(e) à jour !',
        'submit!' => 'envoyer !',
        'submit' => 'envoyer',
        'Submit' => 'Envoyer',
        'change!' => 'modifier !',
        'Change' => 'Modifier',
        'change' => 'modifier',
        'click here' => 'Cliquer ici',
        'Comment' => 'Commentaire',
        'Invalid Option!' => 'Option invalide !',
        'Invalid time!' => 'Heure/Durée invalide !',
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
        'Search' => 'Rechercher',
        'and' => 'et',
        'between' => 'entre',
        'before/after' => '',
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
        'Added!' => 'Ajouté !',
        'Category' => 'Catégorie',
        'Viewer' => 'Visionneuse',
        'Expand' => 'Etendre',
        'Small' => 'Petit',
        'Medium' => 'Moyen',
        'Large' => 'Grand',
        'Date picker' => 'Selection de date',
        'New message' => 'Nouveau message',
        'New message!' => 'Nouveau message !',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Veuillez répondre à ce(s) ticket(s) pour revenir à une vue normale de la file !',
        'You have %s new message(s)!' => 'Vous avez %s nouveau(x) message(s) !',
        'You have %s reminder ticket(s)!' => 'Vous avez %s rappel(s) de ticket(s) !',
        'The recommended charset for your language is %s!' => 'Le jeu de caractère correspondant à votre langue est %s !',
        'Change your password.' => 'Modifier votre mot de passe',
        'Please activate %s first!' => 'Merci d\'activer %s en premier lieu',
        'No suggestions' => 'Pas de suggestions',
        'Word' => 'Mot',
        'Ignore' => 'Ignorer',
        'replace with' => 'remplacer par',
        'There is no account with that login name.' => 'Il n\'y a aucun compte avec ce nom de connexion',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Mauvaise authentification! Votre nom de compte ou mot de passe étaient erronés',
        'There is no acount with that user name.' => 'Il n\'y a aucun compte avec ce nom d\'utilisateur',
        'Please contact your administrator' => 'Veuillez contacter votre administrateur SVP',
        'Logout' => 'Déconnexion',
        'Logout successful. Thank you for using %s!' => 'Déconnexion réussie. Merci d\'avoir utilisé %s !',
        'Feature not active!' => 'Cette fonctionnalité n\'est pas activée !',
        'Agent updated!' => 'Information de l\'opérateur mises à jour',
        'Database Selection' => '',
        'Create Database' => 'Créer la base de données',
        'System Settings' => 'Paramètres Système',
        'Mail Configuration' => 'Configuration de la messagerie',
        'Finished' => 'Fini',
        'Install OTRS' => 'Installer OTRS',
        'Intro' => '',
        'License' => 'Licence',
        'Database' => 'Base de donnée',
        'Configure Mail' => 'Configurer Mail',
        'Database deleted.' => 'Base de données effacée.',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database already contains data - it should be empty!' => '',
        'Login is needed!' => 'Authentification requise !',
        'Password is needed!' => 'Le mot de passe est requis !',
        'Take this Customer' => 'Choisir ce client',
        'Take this User' => 'Choisir cet utilisateur',
        'possible' => 'possible',
        'reject' => 'rejeté',
        'reverse' => 'inverse',
        'Facility' => 'Service',
        'Time Zone' => 'Fuseau horaire',
        'Pending till' => 'En attendant jusqu\'à',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'Répartition par le champ \'À:\' de l\'e-mail',
        'Dispatching by selected Queue.' => 'Répartition selon la file sélectionnée',
        'No entry found!' => 'Aucun résultat n\'a été trouvé !',
        'Session invalid. Please log in again.' => 'Session non valide. Veuillez vous ré-authentifier.',
        'Session has timed out. Please log in again.' => 'Le délai de votre session est dépassé, veuillez vous ré-authentifier.',
        'Session limit reached! Please try again later.' => 'Limite de session atteinte. Veuillez réessayer ultérieurement',
        'No Permission!' => 'Pas de permission !',
        '(Click here to add)' => '(Cliquez ici pour ajouter)',
        'Preview' => 'Aperçu',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => '% n\'est pas accessible en écriture',
        'Cannot create %s!' => 'Impossible de créer %s',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => 'Client %s ajouté',
        'Role added!' => 'Rôle ajouté!',
        'Role updated!' => 'Rôle mis à jour!',
        'Attachment added!' => 'Pièce jointe ajoutée!',
        'Attachment updated!' => 'Pièce jointe mise à jour!',
        'Response added!' => 'Réponse ajoutée!',
        'Response updated!' => 'Réponse mise à jour!',
        'Group updated!' => 'Groupe ajouté!',
        'Queue added!' => 'File ajoutée!',
        'Queue updated!' => 'File mise à jour!',
        'State added!' => 'État ajouté!',
        'State updated!' => 'État mis à jour!',
        'Type added!' => 'Type ajouté!',
        'Type updated!' => 'Type mis à jour!',
        'Customer updated!' => 'Client mis à jour!',
        'Customer company added!' => 'Entreprise du client ajoutée !',
        'Customer company updated!' => 'Entreprise du client mise à jour !',
        'Note: Company is invalid!' => '',
        'Mail account added!' => 'Compte de messagerie ajouté !',
        'Mail account updated!' => 'Compte de messagerie mis à jour !',
        'System e-mail address added!' => 'Adresse e-mail système ajoutée !',
        'System e-mail address updated!' => 'Adresse e-mail système mise à jour !',
        'Contract' => 'Contrat',
        'Online Customer: %s' => 'Clients en ligne: %s',
        'Online Agent: %s' => 'Opérateurs en ligne: %s',
        'Calendar' => 'Calendrier',
        'File' => 'Fichier',
        'Filename' => 'Nom de fichier',
        'Type' => 'Type',
        'Size' => 'Taille',
        'Upload' => 'Envoyer',
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
        'Phone' => 'Téléphone',
        'Fax' => 'Fax',
        'Mobile' => 'Téléphone portable',
        'Zip' => 'Code postal',
        'City' => 'Ville',
        'Street' => 'Rue',
        'Country' => 'Pays',
        'Location' => 'Plan',
        'installed' => 'installé',
        'uninstalled' => 'désinstallé',
        'Security Note: You should activate %s because application is already running!' =>
            'Note de Sécurité: Vous devriez activer %s parce que l\'application est déjà lancée !',
        'Unable to parse repository index document.' => '',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '',
        'No packages, or no new packages, found in selected repository.' =>
            '',
        'Edit the system configuration settings.' => 'Modifier la configuration du système.',
        'printed at' => 'imprimé à',
        'Loading...' => 'Chargement...',
        'Dear Mr. %s,' => 'Cher M. %s',
        'Dear Mrs. %s,' => 'Cher Mme %s',
        'Dear %s,' => 'Cher %s',
        'Hello %s,' => 'Bonjour %s',
        'This email address already exists. Please log in or reset your password.' =>
            'Cette adresse e-mail existe déjà. Veuillez vous authentifier ou re-initialiser votre mot de passe',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nouveau compte créé. Informations de connexion envoyées à %s. Veuillez consulter votre e-mail.',
        'Please press Back and try again.' => 'Veuillez retourner à la page précédente et rééssayer.',
        'Sent password reset instructions. Please check your email.' => 'Instructions d\'initialisation du mot de passe envoyées. Veuillez consulter votre e-mail.',
        'Sent new password to %s. Please check your email.' => 'Nouveau mot de passe envoyé à %s. Veuillez consulter votre e-mail.',
        'Upcoming Events' => 'Évènements à venir',
        'Event' => 'Évènement',
        'Events' => 'Évènements',
        'Invalid Token!' => 'Jeton invalide !',
        'more' => 'plus',
        'Collapse' => 'Réduire',
        'Shown' => 'Affiché(s)',
        'Shown customer users' => 'Utilisateurs clients affichés',
        'News' => 'Nouvelles',
        'Product News' => 'Nouvelles du produit',
        'OTRS News' => 'Nouvelles d\'OTRS',
        '7 Day Stats' => 'Stats sur 7 jours',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Les informations de Gestion de Processus de la base de données ne sont pas synchrones avec la configurations système. Veuillez synchroniser tous les processus.',
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
        'Remove Formatting' => 'Supprimer le formattage',
        'Show/Hide Hidden Elements' => 'Montrer/Cacher les éléments cachés',
        'Align Left' => 'Aligner à Gauche',
        'Align Center' => 'Aligner au Centre',
        'Align Right' => 'Aligner à Droite',
        'Justify' => 'Justifier',
        'Header' => 'En-tête',
        'Indent' => 'Ajouter indentation',
        'Outdent' => 'Supprimer indentation',
        'Create an Unordered List' => 'Créer une liste non ordonnée',
        'Create an Ordered List' => 'Créer une liste ordonnée',
        'HTML Link' => 'Lien HTML',
        'Insert Image' => 'Insérer image',
        'CTRL' => 'Contrôle',
        'SHIFT' => 'Shift',
        'Undo' => 'Annuler',
        'Redo' => 'Refaire',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

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
        'Preferences updated successfully!' => 'Les préférences ont bien été mises à jour !',
        'User Profile' => 'Profil utilisateur',
        'Email Settings' => 'Paramétrage e-mail',
        'Other Settings' => 'Autres paramétrages',
        'Change Password' => 'Changer de mot de passe',
        'Current password' => 'Mot de passe actuel',
        'New password' => 'Nouveau mot de passe',
        'Verify password' => 'Vérification du mot de passe',
        'Spelling Dictionary' => 'Correcteur orthographique',
        'Default spelling dictionary' => 'Dictionnaire d\'orthographe par défaut.',
        'Max. shown Tickets a page in Overview.' => 'Nombre maximum de tickets affichés sur la page d\'aperçu des tickets',
        'The current password is not correct. Please try again!' => 'Le mot de passe actuel n\'est pas correct. Merci d\'essayer à nouveau!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Impossible de mettre à jour le mot de passe, votre nouveau mot de passe ne correspond pas. Merci d\'essayer à nouveau!',
        'Can\'t update password, it contains invalid characters!' => 'Impossible de mettre à jour le mot de passe, il contienti des caractères invalides!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Impossible de mettre à jour le mot de passe,, il doit contenir au moins %s caractères!',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Impossible de mettre à jour le mot de passe, il doit contenir au moins 1 chiffre!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Impossible de mettre à jour le mot de passe, il doit contenir au moins 2 caractères!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Impossible de mettre à jour le mot de passe, ce mot de passe a déjà été utilisé. Merci d\'en choisir un autre!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Sélectionner le caractère séparateur pour les fichiers CSV (stats et recherches). Si rien n\'est indiqué ici, le séparateur par défaut pour votre langage est utilisé.',
        'CSV Separator' => 'Séparateur CSV',

        # Template: AAAStats
        'Stat' => 'Statistique',
        'Sum' => 'Somme',
        'Please fill out the required fields!' => 'Remplissez les champs obligatoires svp !',
        'Please select a file!' => 'Sélectionnez un fichier svp !',
        'Please select an object!' => 'Sélectionnez un objet svp !',
        'Please select a graph size!' => 'Sélectionnez une taille pour le graphique svp !',
        'Please select one element for the X-axis!' => 'Sélectionnez un élément pour l\'axe X svp !',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Merci de sélectionner un seul élément ou de désactiver le bouton \'Fixe\' où le bouton de sélection est marqué',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Si vous cochez une case, vous devez indiquer des attributs du champ sélectionné !',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Veuillez donner une valeur pour le champ sélectionné ou décochez la case \'Fixed\' !',
        'The selected end time is before the start time!' => 'La date de fin est antérieure à la date de début !',
        'You have to select one or more attributes from the select field!' =>
            'Vous devez sélectionner un ou plusieurs attributs du champ sélectionné !',
        'The selected Date isn\'t valid!' => 'La date sélectionnée n\'est pas valide !',
        'Please select only one or two elements via the checkbox!' => 'Sélectionnez uniquement un ou deux éléments via les cases à cocher !',
        'If you use a time scale element you can only select one element!' =>
            'Si vous employez un élément d\'échelle de temps vous ne pouvez choisir qu\'un seul élément',
        'You have an error in your time selection!' => 'Vous avez une erreur dans le choix de la date !',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'La période choisie pour le rapport est trop courte, veuillez indiquer une plage plus grande !',
        'The selected start time is before the allowed start time!' => 'La date de début choisie est antérieure à la date de début autorisée !',
        'The selected end time is after the allowed end time!' => 'La date de fin choisie est posterieure à la date de fin autorisée !',
        'The selected time period is larger than the allowed time period!' =>
            'La plage de temps choisie est supérieure à la période de temps autorisée !',
        'Common Specification' => 'Caractéristiques Communes',
        'X-axis' => 'Axe X',
        'Value Series' => 'Séries de valeurs',
        'Restrictions' => 'Restrictions',
        'graph-lines' => 'Graphique-Lignes',
        'graph-bars' => 'Graphique-Barres',
        'graph-hbars' => 'Graphique-Barres horizontales',
        'graph-points' => 'Graphique-Points',
        'graph-lines-points' => 'Graphique-Lignes-Points',
        'graph-area' => 'Graphique-Surface',
        'graph-pie' => 'Graphique-Camembert',
        'extended' => 'étendu',
        'Agent/Owner' => 'Opérateur/Propriétaire',
        'Created by Agent/Owner' => 'Créé par le Opérateur/Propriétaire',
        'Created Priority' => 'Priorité créée',
        'Created State' => 'État créé',
        'Create Time' => 'Date de création',
        'CustomerUserLogin' => 'Identifiant Client',
        'Close Time' => 'Date de clôture',
        'TicketAccumulation' => 'Cumul de ticket',
        'Attributes to be printed' => 'Attributs à imprimer',
        'Sort sequence' => 'Ordre de tri',
        'Order by' => 'Trier par',
        'Limit' => 'Limite',
        'Ticketlist' => 'Liste des tickets',
        'ascending' => 'ascendant',
        'descending' => 'descendant',
        'First Lock' => 'Premier verrou',
        'Evaluation by' => 'Evaluation par',
        'Total Time' => 'Temps Total',
        'Ticket Average' => 'Moyenne des tickets',
        'Ticket Min Time' => 'Temps minimum du ticket',
        'Ticket Max Time' => 'Temps maximum du ticket',
        'Number of Tickets' => 'Nombre de tickets',
        'Article Average' => 'Moyenne des articles',
        'Article Min Time' => 'Temps minimum des articles',
        'Article Max Time' => 'Temps maximum des articles',
        'Number of Articles' => 'Nombre d\'articles',
        'Accounted time by Agent' => 'Temps passé par opérateur',
        'Ticket/Article Accounted Time' => 'Temps passé par Ticket/Article',
        'TicketAccountedTime' => 'Temps passé sur le ticket',
        'Ticket Create Time' => 'Heure de création du ticket',
        'Ticket Close Time' => 'Heure de fermeture du ticket',

        # Template: AAATicket
        'Status View' => 'Vue des statuts',
        'Bulk' => 'Actions groupées',
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
        'Queues' => 'Files',
        'Priority' => 'Priorité',
        'Priorities' => 'Priorités',
        'Priority Update' => 'Mise à jour de la priorité',
        'Priority added!' => 'Priorité ajoutée!',
        'Priority updated!' => 'Priorité mise à jour!',
        'Signature added!' => 'Signature ajoutée!',
        'Signature updated!' => 'Signature mise à jour!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Contrat de niveau de support',
        'Service Level Agreements' => 'Contrats de niveau de support',
        'Service' => 'Service',
        'Services' => 'Services',
        'State' => 'État',
        'States' => 'États',
        'Status' => 'Statut',
        'Statuses' => 'Status',
        'Ticket Type' => 'Type de ticket',
        'Ticket Types' => 'Types de tickets',
        'Compose' => 'Composer',
        'Pending' => 'En attente',
        'Owner' => 'Propriétaire',
        'Owner Update' => 'Mise à jour du propriétaire',
        'Responsible' => 'Responsable',
        'Responsible Update' => 'Mise à jour du responsable',
        'Sender' => 'émetteur',
        'Article' => 'Article',
        'Ticket' => 'Ticket',
        'Createtime' => 'Date de création',
        'plain' => 'tel quel',
        'Email' => 'E-mail',
        'email' => 'e-mail',
        'Close' => 'Fermer',
        'Action' => 'Action',
        'Attachment' => 'Pièce jointe',
        'Attachments' => 'Pièces jointes',
        'This message was written in a character set other than your own.' =>
            'Ce message a été écrit dans un jeu de caractères différent du vôtre.',
        'If it is not displayed correctly,' => 'S\'il n\'est pas affiché correctement',
        'This is a' => 'Ceci est un',
        'to open it in a new window.' => 'L\'ouvrir dans une nouvelle fenêtre',
        'This is a HTML email. Click here to show it.' => 'Ceci est un e-mail au format HTML ; cliquer ici pour l\'afficher.',
        'Free Fields' => 'Champs libres',
        'Merge' => 'Fusionner',
        'merged' => 'Fusionné',
        'closed successful' => 'clos (résolu)',
        'closed unsuccessful' => 'clos (non résolu)',
        'Locked Tickets Total' => 'Total des tickets verrouillés',
        'Locked Tickets Reminder Reached' => 'Tickets verrouillés ayant atteint le rappel',
        'Locked Tickets New' => 'Nouveaux Tickets Verrouillés',
        'Responsible Tickets Total' => 'Total des tickets du responsable',
        'Responsible Tickets New' => 'Nouveaux tickets du responsable',
        'Responsible Tickets Reminder Reached' => '',
        'Watched Tickets Total' => 'Total Tickets vus',
        'Watched Tickets New' => 'Total Nouveaux Tickets',
        'Watched Tickets Reminder Reached' => 'Rappel atteint des Tickets vus',
        'All tickets' => 'Tous les Tickets',
        'Available tickets' => 'Tickets Disponibles',
        'Escalation' => 'Remontée',
        'last-search' => 'dernière-recherche',
        'QueueView' => 'Vue file',
        'Ticket Escalation View' => 'Vue des remontées du ticket',
        'Message from' => 'Message de',
        'End message' => 'Fin du message',
        'Forwarded message from' => 'Message transféré par',
        'End forwarded message' => 'Fin du message tranféré',
        'new' => 'nouveau',
        'open' => 'ouvert',
        'Open' => 'Ouverts',
        'Open tickets' => 'Tickets ouverts',
        'closed' => 'fermé',
        'Closed' => 'Fermés',
        'Closed tickets' => 'Tickets fermés',
        'removed' => 'supprimé',
        'pending reminder' => 'Attente du rappel',
        'pending auto' => 'En attente auto',
        'pending auto close+' => 'En attente de la fermeture automatique(+)',
        'pending auto close-' => 'En attente de la fermeture automatique(-)',
        'email-external' => 'e-mail externe',
        'email-internal' => 'e-mail interne',
        'note-external' => 'Note externe',
        'note-internal' => 'Note interne',
        'note-report' => 'Note rapport',
        'phone' => 'téléphone',
        'sms' => 'SMS',
        'webrequest' => 'Requête par le web',
        'lock' => 'verrouillé.',
        'unlock' => 'déverrouillé',
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
        'auto follow up' => 'suivi automatique',
        'auto reject' => 'rejet automatique',
        'auto remove' => 'suppression automatique',
        'auto reply' => 'réponse automatique',
        'auto reply/new ticket' => 'réponse auto/nouveau ticket',
        'Create' => 'Création',
        'Answer' => '',
        'Phone call' => 'Appel téléphonique',
        'Ticket "%s" created!' => 'Le ticket %s a été créé !',
        'Ticket Number' => 'Numéro de ticket',
        'Ticket Object' => 'Objet ticket',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Pas de ticket numéro "%s" ! Impossible de le lier !',
        'You don\'t have write access to this ticket.' => 'Vous n\'avez pas de permission d\'écriture pour ce ticket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Désolé, vous devez être le propriétaire du ticket pour effectuer cette action.',
        'Please change the owner first.' => 'D\'abord, veuillez modifier le propriétaire.',
        'Ticket selected.' => 'Ticket sélectionné.',
        'Ticket is locked by another agent.' => 'Ticket verrouillé par un autre opérateur.',
        'Ticket locked.' => 'Ticket verrouillé.',
        'Don\'t show closed Tickets' => 'Ne pas montrer les tickets cloturés',
        'Show closed Tickets' => 'Voir les tickets cloturés',
        'New Article' => 'Nouvel Article',
        'Unread article(s) available' => 'Article(s) non lu(s) disponible(s)',
        'Remove from list of watched tickets' => 'Enlever de la liste des tickets suivis',
        'Add to list of watched tickets' => 'Ajouter à la liste des tickets suivis',
        'Email-Ticket' => 'Ticket E-mail',
        'Create new Email Ticket' => 'Créer un nouveau ticket par e-mail',
        'Phone-Ticket' => 'Ticket Téléphone',
        'Search Tickets' => 'Recherche de tickets',
        'Edit Customer Users' => 'Editer clients',
        'Edit Customer Company' => 'Éditer l\'entreprise cliente',
        'Bulk Action' => 'Action groupée',
        'Bulk Actions on Tickets' => 'Action groupées sur les tickets',
        'Send Email and create a new Ticket' => 'Envoyer un E-mail et créer un nouveau Ticket',
        'Create new Email Ticket and send this out (Outbound)' => 'Créer un nouveau Ticket E-mail et l\'envoyer (Sortant)',
        'Create new Phone Ticket (Inbound)' => 'Créer un ticket Téléphone (Entrant)',
        'Address %s replaced with registered customer address.' => 'Adresse %s remplacée par celle du client enregistré.',
        'Customer user automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Aperçu de tous les Tickets ouverts',
        'Locked Tickets' => 'Tickets verrouillés',
        'My Locked Tickets' => 'Mes tickets verrouillés',
        'My Watched Tickets' => 'Mes tickets surveillés',
        'My Responsible Tickets' => 'Mes tickets en responsabilité',
        'Watched Tickets' => 'Tickets surveillés',
        'Watched' => 'Surveillé',
        'Watch' => 'Surveiller',
        'Unwatch' => 'Arrêter le suivi',
        'Lock it to work on it' => 'Le verrouiller afin de travailler dessus',
        'Unlock to give it back to the queue' => 'Le dévérouiller afin de le remettre dans sa file',
        'Show the ticket history' => 'Afficher Historique du Ticket',
        'Print this ticket' => 'Imprimer ce ticket',
        'Print this article' => 'Imprimer cet article',
        'Split' => 'Scinder',
        'Split this article' => 'Scinder cet article',
        'Forward article via mail' => 'Transférer Article par mail',
        'Change the ticket priority' => 'Modifier la priorité du ticket',
        'Change the ticket free fields!' => 'Changer les champs libres du ticket !',
        'Link this ticket to other objects' => 'Lier ce ticket à d\'autres objets',
        'Change the owner for this ticket' => 'Changer le propriétaire du ticket',
        'Change the  customer for this ticket' => 'Changer le client du ticket',
        'Add a note to this ticket' => 'Ajouter une note à ce ticket',
        'Merge into a different ticket' => 'Fusionner avec un autre ticket',
        'Set this ticket to pending' => 'Mettre ce ticket en attente',
        'Close this ticket' => 'Fermer ce ticket',
        'Look into a ticket!' => 'Voir le détail du ticket !',
        'Delete this ticket' => 'Supprimer ce ticket',
        'Mark as Spam!' => 'Marquer comme Spam !',
        'My Queues' => 'Mes files',
        'Shown Tickets' => 'Tickets affichés',
        'Shown Columns' => '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Votre e-mail avec le numéro de ticket "<OTRS_TICKET>" a été fusionné avec le ticket numéro "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: le temps imparti pour la première réponse est dépassé (%s) !',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: le temps imparti pour la première réponse sera dépassé dans %s !',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: le temps imparti pour la révision est dépassé (%s) !',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: le temps imparti pour la révision sera dépassé dans %s !',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: le temps imparti pour fournir une solution est dépassé (%s) !',
        'Ticket %s: solution time will be over in %s!' => 'Ticket %s: le temps imparti pour fournir une solution sera dépassé dans %s !',
        'There are more escalated tickets!' => 'Il y a d\'autres tickets remontés !',
        'Plain Format' => 'Format texte',
        'Reply All' => 'Répondre à tous',
        'Direction' => 'Direction',
        'Agent (All with write permissions)' => 'Opérateur (Tous avec permission d\'écriture)',
        'Agent (Owner)' => 'Opérateur (Propriétaire)',
        'Agent (Responsible)' => 'Opérateur (Responsable)',
        'New ticket notification' => 'Notification de nouveau ticket',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Me prévenir si il y a un nouveau ticket dans une de "Mes files".',
        'Send new ticket notifications' => 'Envoyer les notifications en cas de nouveau ticket',
        'Ticket follow up notification' => 'Notification de suivi de ticket',
        'Ticket lock timeout notification' => 'Prévenir du dépassement du délai d\'un verrou',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Me prévenir si un ticket est déverrouillé par le système',
        'Send ticket lock timeout notifications' => 'Envoyer les notifications de désactivation d\'un verrou.',
        'Ticket move notification' => 'Notification de déplacement de Ticket',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Me prévenir si un ticket est déplacé dans une de "Mes files".',
        'Send ticket move notifications' => 'Envoyer notifications en cas de déplacement d\'un ticket',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Faites la sélection de vos files préférées. Vous recevrez des notifications à propos de ces files par e-mail.',
        'Custom Queue' => 'File d\'attente personnalisée',
        'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'La vue des files sera rafraîchit automatiquement après la période précisée si la fonctionnalité est activée.',
        'Refresh QueueView after' => 'Rafraichir la vue des files après',
        'Screen after new ticket' => 'Écran après un nouveau ticket',
        'Show this screen after I created a new ticket' => 'Faire apparaître cet écran après la création d\'un nouveau ticket',
        'Closed Tickets' => 'Tickets fermés',
        'Show closed tickets.' => 'Voir les tickets fermés',
        'Max. shown Tickets a page in QueueView.' => 'Nombre maximum de tickets affichés sur la page de la vue d\'une file',
        'Ticket Overview "Small" Limit' => '',
        'Ticket limit per page for Ticket Overview "Small"' => '',
        'Ticket Overview "Medium" Limit' => '',
        'Ticket limit per page for Ticket Overview "Medium"' => '',
        'Ticket Overview "Preview" Limit' => '',
        'Ticket limit per page for Ticket Overview "Preview"' => '',
        'Ticket watch notification' => 'Notification de surveillance de Ticket',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Pour les tickets sous surveillance, envoyez-moi les mêmes notifications que celles envoyées au propriétaire de ces tickets.',
        'Send ticket watch notifications' => 'Envoi de notifications à la vue du ticket',
        'Out Of Office Time' => 'Heure de sortie du travail',
        'New Ticket' => 'Nouveau ticket',
        'Create new Ticket' => 'Création d\'un nouveau ticket',
        'Customer called' => 'Client appellé',
        'phone call' => 'Appel téléphonique',
        'Phone Call Outbound' => 'Appel vers Client',
        'Phone Call Inbound' => 'Appel vers Opérateur',
        'Reminder Reached' => 'Rappel atteint',
        'Reminder Tickets' => 'Tickets de rappel',
        'Escalated Tickets' => 'Tickets remontés',
        'New Tickets' => 'Nouveaux tickets',
        'Open Tickets / Need to be answered' => 'Tickets ouverts en attente de réponse',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Les tickets ouverts; ces ticket ont été traités mais nécessitent une réponse.',
        'All new tickets, these tickets have not been worked on yet' => 'Les nouveaux tickets; ces tickets n\'ont pas été traités.',
        'All escalated tickets' => 'Tous les tickets escaladés',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Tout les tickets dont la date de rappel à été atteinte.',
        'Archived tickets' => 'Tickets archivés',
        'Unarchived tickets' => 'Tickets non archivés',
        'History::Move' => 'Le ticket a été déplacé dans la file "%s" (%s) - Ancienne file: "%s" (%s).',
        'History::TypeUpdate' => 'Type positionné à %s (ID=%s).',
        'History::ServiceUpdate' => 'Service positionné à %s (ID=%s).',
        'History::SLAUpdate' => 'SLA positionné à %s (ID=%s).',
        'History::NewTicket' => 'Un nouveau ticket a été crée: [%s] created (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Un suivi du ticket [%s]. %s',
        'History::SendAutoReject' => 'Rejet automatique envoyé à "%s".',
        'History::SendAutoReply' => 'Réponse automatique envoyée à "%s".',
        'History::SendAutoFollowUp' => 'Suivi automatique envoyé à "%s".',
        'History::Forward' => 'Transféré vers "%s".',
        'History::Bounce' => 'Redirigé vers "%s".',
        'History::SendAnswer' => 'E-mail envoyé à "%s".',
        'History::SendAgentNotification' => '"%s"-notification envoyé à "%s".',
        'History::SendCustomerNotification' => 'Notification envoyé à "%s".',
        'History::EmailAgent' => 'E-mail envoyé au client.',
        'History::EmailCustomer' => 'Ajout d\'une adresse e-mail %s',
        'History::PhoneCallAgent' => 'L\'opérateur a appellé le client.',
        'History::PhoneCallCustomer' => 'Le client nous a appellé.',
        'History::AddNote' => 'Ajout d\'une note (%s)',
        'History::Lock' => 'Ticket verrouillé.',
        'History::Unlock' => 'Ticket déverrouillé.',
        'History::TimeAccounting' => 'Temps passé sur l\'action: %s . Total du temps passé pour ce ticket: %s unité(s).',
        'History::Remove' => 'Supprimer %s',
        'History::CustomerUpdate' => 'Mise à jour: %s',
        'History::PriorityUpdate' => 'Changement de priorité de "%s" (%s) pour "%s" (%s).',
        'History::OwnerUpdate' => 'Le nouveau propriétaire est "%s" (ID=%s).',
        'History::LoopProtection' => 'Protection anti-boucle ! Pas d\'auto réponse envoyé à "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Mise à jour: %s',
        'History::StateUpdate' => 'État Avant: "%s" Après: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Mise à jour: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Requête du client via le web.',
        'History::TicketLinkAdd' => 'Ajout d\'un lien vers le ticket "%s".',
        'History::TicketLinkDelete' => 'Suppression du lien vers le ticket "%s".',
        'History::Subscribe' => 'Abonnement pour l\'utilisateur "%s".',
        'History::Unsubscribe' => 'Désabonnement pour l\'utilisateur "%s".',
        'History::SystemRequest' => 'Requête système',
        'History::ResponsibleUpdate' => 'Mise à jour du responsable',
        'History::ArchiveFlagUpdate' => 'Mise à jour de l\'indicateur d\'archivage',
        'History::TicketTitleUpdate' => '',

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
        'This field is required.' => 'Ce champ est requis',
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
        'Validity' => 'Validité',
        'Copy' => '',
        'No data found.' => 'Aucune donnée trouvée',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Go to overview' => 'Aller à la vue d\'ensemble',
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
        'Stop after match' => 'Stopper après correspondance',
        'Edit ACL structure' => '',
        'Save' => 'Sauver',
        'or' => 'ou',
        'Save and finish' => '',
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
        'Add attachment' => 'Ajouter pièce jointe',
        'List' => 'Lister',
        'Download file' => 'Télécharger fichier',
        'Delete this attachment' => 'Supprimer pièce jointe',
        'Add Attachment' => 'Ajouter pièce jointe',
        'Edit Attachment' => 'Editer pièce jointe',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Gestion des réponses automatiques',
        'Add auto response' => 'Ajouter réponse automatique',
        'Add Auto Response' => 'Ajouter Réponse Automatique',
        'Edit Auto Response' => 'Editer Réponse Automatique',
        'Response' => 'Réponse',
        'Auto response from' => 'Réponse automatique de',
        'Reference' => 'Référence',
        'You can use the following tags' => 'Vous pouvez utiliser les tags suivants',
        'To get the first 20 character of the subject.' => 'Pour avoir les 20 premiers caractères du sujet.',
        'To get the first 5 lines of the email.' => 'Pour avoir les 5 premières lignes de l\'e-mail.',
        'To get the realname of the sender (if given).' => 'Pour avoir le nom de l\'expéditeur s\'il est fourni.',
        'To get the article attribute' => 'Pour avoir l\'attribut de l\'article',
        ' e. g.' => 'p. ex.',
        'Options of the current customer user data' => 'Options des données du client actuel',
        'Ticket owner options' => 'Options du propriétaire du ticket',
        'Ticket responsible options' => 'Options du responsable du ticket',
        'Options of the current user who requested this action' => 'Options de l\'utilisateur actuel qui a demandé cette action',
        'Options of the ticket data' => 'Options des données du ticket',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Options de configuration',
        'Example response' => 'Exemple de réponse',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestion des clients',
        'Wildcards like \'*\' are allowed.' => 'Les caractères génériques tels que \'*\ sont autorisés',
        'Add customer' => 'Ajouter un client',
        'Select' => 'Sélectionner',
        'Please enter a search term to look for customers.' => 'Merci d\'entrer un motif pour rechercher des clients',
        'Add Customer' => 'Ajouter un client',
        'Edit Customer' => 'Editer client',

        # Template: AdminCustomerUser
        'Customer User Management' => '',
        'Back to search results' => '',
        'Add customer user' => '',
        'Hint' => 'Conseil',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '',
        'Last Login' => 'Dernière connexion',
        'Login as' => 'Connecté en tant que',
        'Switch to customer' => 'Basculer vers le client',
        'Add Customer User' => '',
        'Edit Customer User' => '',
        'This field is required and needs to be a valid email address.' =>
            'Ce champ est obligatoire et doit être une adresse e-mail valide.',
        'This email address is not allowed due to the system configuration.' =>
            'Cette adresse e-mail n\'est past permise par la configuration du système',
        'This email address failed MX check.' => 'Cette adresse e-mail n\'a pas passé la vérification MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problème DNS. Veuillez contrôler le journal d\'erreur ainsi que votre configuration.',
        'The syntax of this email address is incorrect.' => 'La syntaxe de cette adresse e-mail est incorrecte.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Gérer les relations Client-Groupe',
        'Notice' => 'Note',
        'This feature is disabled!' => 'Cette fonctionnalité est désactivée !',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utiliser cette fonction uniquement si vous shouhaitez définir des permissions de groupe pour les clients',
        'Enable it here!' => 'Activez la ici !',
        'Search for customers.' => 'Rechercher des clients.',
        'Edit Customer Default Groups' => 'Editer les groupes par défault du client',
        'These groups are automatically assigned to all customers.' => 'Ces groupes sont automatiquement assignés à tous les clients',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Filtre pour les Groupes',
        'Select the customer:group permissions.' => 'Selectionner les permissions client::groupe',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Si rien n\'est sélectionné, alors il n\'y aura aucune permission dans ce groupe (les tickets ne seront pas accessibles au client).',
        'Search Results' => 'Résultat de recherche',
        'Customers' => 'Clients',
        'Groups' => 'Groupes',
        'No matches found.' => 'Aucun résultat.',
        'Change Group Relations for Customer' => '',
        'Change Customer Relations for Group' => '',
        'Toggle %s Permission for all' => 'Sélectionner la Permission %s pour tous',
        'Toggle %s permission for %s' => 'Sélectionner la permission %s pour %s',
        'Customer Default Groups:' => 'Groupes par défaut du client',
        'No changes can be made to these groups.' => 'Aucun changement possible pour ces groupes',
        'ro' => 'lecture seule',
        'Read only access to the ticket in this group/queue.' => 'Accès en lecture seulement aux tickets de cette file/groupe.',
        'rw' => 'lecture/écriture',
        'Full read and write access to the tickets in this group/queue.' =>
            'Accès complet en lecture et écriture aux tickets dans cette file/groupe.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Gérer les Relations Client-Services',
        'Edit default services' => 'Editer les services par défaut',
        'Filter for Services' => 'Filtre pour les Services',
        'Allocate Services to Customer' => '',
        'Allocate Customers to Service' => '',
        'Toggle active state for all' => 'Sélectionner l\'état actif pour tous',
        'Active' => 'Actif',
        'Toggle active state for %s' => 'Sélectionner l\'état actif pour %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestion des champs dynamiques',
        'Add new field for object' => 'Ajouter un nouveau champ pour l\'objet',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Pour ajouter un nouveau champ, sélectionner l\'objet désiré, puis le type de champ dans le menu déroulant correspondant. Le type défini la structure du champ, et il ne peut être changé après la création.',
        'Dynamic Fields List' => 'Liste des champs dynamiques',
        'Dynamic fields per page' => 'Nombre de champs dynamiques par page',
        'Label' => 'Label',
        'Order' => 'Ordre',
        'Object' => 'Objet',
        'Delete this field' => 'Effacer ce champs',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Voulez-vous vraiment effacer ce champ dynamique? Toute donnée associée sera PERDUE!',
        'Delete field' => 'Effacer ce champ',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Champs dynamiques',
        'Field' => 'Champ',
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
        'Field order' => 'Ordre du champ',
        'This field is required and must be numeric.' => 'Ce champ est requis et doit être composé de caractères numériques.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'L\'affichage sur les écrans où le champ est actif respectera l\'ordre choisi.',
        'Field type' => 'Type de champ',
        'Object type' => 'Type d\'objet',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => 'Ce champ est protégé et ne peut pas être supprimé',
        'Field Settings' => 'Réglage du champ',
        'Default value' => 'Valeur par défaut',
        'This is the default value for this field.' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Différence entre la date actuelle et le date affichée',
        'This field must be numeric.' => 'Ce champ doit être composé de caractères numériques',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => 'Période déterminée (en années)',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Activez cette fonctionnalité afin de fixer le nombre d\'années devant être affiché (dans le futur et dans le passé) à l\'intérieur de la section « année » du champ.',
        'Years in the past' => 'années passées',
        'Years in the past to display (default: 5 years).' => 'années passées à afficher (par défaut, 5 années)',
        'Years in the future' => 'Années futures',
        'Years in the future to display (default: 5 years).' => 'Années futures à afficher (par défaut, 5 années)',
        'Show link' => 'Montrer le lien',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Valeurs possibles',
        'Key' => 'Clé',
        'Value' => 'Valeur',
        'Remove value' => 'Retirer la valeur',
        'Add value' => 'Ajouter une valeur',
        'Add Value' => 'Ajouter une valeur',
        'Add empty value' => 'Ajouter une valeur sans contenu',
        'Activate this option to create an empty selectable value.' => 'Pour créer une valeur sans contenu, activer cette option.',
        'Tree View' => 'Vue hiérarchique',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => 'Valeurs traduisibles',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Pour que le contenu des valeurs soit traduit dans la langue définie par l\'utilisateur, activez cette option.',
        'Note' => 'Note',
        'You need to add the translations manually into the language translation files.' =>
            'Vous devez traduire vous-même le contenu dans les fichiers de traduction.',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Nombre de rangées',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Précisez la hauteur de ce champ (en nombre de lignes), présent lors de l\'édition.',
        'Number of cols' => 'Nombre de colonnes',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Précisez la largeur de ce champ (en nombre de caractères), présent lors de l\'édition.',

        # Template: AdminEmail
        'Admin Notification' => 'Notification des administrateurs',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Le présent module permet aux administrateurs d\'envoyer des messages aux opérateurs, aux groupes et aux autres membres du même rôle.',
        'Create Administrative Message' => 'Création d\'un message de l\'administrateur',
        'Your message was sent to' => 'Votre message a été envoyé à',
        'Send message to users' => 'Envoyer un message aux utilisateurs',
        'Send message to group members' => 'Envoyer un message aux membres du groupe',
        'Group members need to have permission' => 'Préciser la permission accordée aux membres du groupe',
        'Send message to role members' => 'Envoyer message aux membres du rôle',
        'Also send to customers in groups' => 'Envoyer aussi aux clients dans les groupes',
        'Body' => 'Corps',
        'Send' => 'Envoyer',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Agent générique',
        'Add job' => 'Ajouter tâche',
        'Last run' => 'Dernier lancement',
        'Run Now!' => 'Lancer maintenant !',
        'Delete this task' => 'Supprimer cette tâche',
        'Run this task' => 'Exécuter cette tâche',
        'Job Settings' => 'Configuration de la tâche',
        'Job name' => 'Nom de la tâche',
        'Toggle this widget' => '',
        'Automatic execution (multiple tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Planification Minutes',
        'Schedule hours' => 'Planification Heures',
        'Schedule days' => 'Planification Jours',
        'Currently this generic agent job will not run automatically.' =>
            'Actuellement, cet agent générique ne s\'exécutera pas automatiquement',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Pour permettre l\'exécution automatique, sélectionnez au moins une valeur dans minutes, heures et jours !',
        'Event based execution (single ticket)' => '',
        'Event Triggers' => '',
        'List of all configured events' => '',
        'Delete this event' => '',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => '',
        'Ticket Filter' => 'Filtre ticket',
        '(e. g. 10*5155 or 105658*)' => '(ex: 10*5155 or 105658*)',
        '(e. g. 234321)' => '(ex: 234321)',
        'Customer login' => 'Login Client',
        '(e. g. U5150)' => '(ex: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Recherche plein texte dans article (p. ex. "Valérie*m" ou "Eco*").',
        'Agent' => 'Opérateur',
        'Ticket lock' => 'Verrouillage ticket',
        'Create times' => 'Date de création',
        'No create time settings.' => 'Pas de critère de date de création',
        'Ticket created' => 'Ticket créé',
        'Ticket created between' => 'Ticket créé entre le',
        'Change times' => 'Modification d\'heure',
        'No change time settings.' => 'Paramètrage de non modification d\'heure',
        'Ticket changed' => 'Ticket modifié',
        'Ticket changed between' => 'Ticket modifié entre',
        'Close times' => 'Dates de clotûre',
        'No close time settings.' => 'Pas de paramètre de temps de fermeture',
        'Ticket closed' => 'Ticket fermé',
        'Ticket closed between' => 'Ticket fermé entre',
        'Pending times' => 'Dates de mise en attente',
        'No pending time settings.' => 'pas de critère de date d\'échéance',
        'Ticket pending time reached' => 'Date d\'échéance atteinte le',
        'Ticket pending time reached between' => 'Date d\'échéance atteinte entre le',
        'Escalation times' => 'Dates de remontée',
        'No escalation time settings.' => 'Pas de paramètres de délai de remontée',
        'Ticket escalation time reached' => 'Délai de remontée du ticket atteint',
        'Ticket escalation time reached between' => 'Délai de remontée du ticket atteint entre',
        'Escalation - first response time' => 'Remontée - Date de première réponse',
        'Ticket first response time reached' => 'Premier temps de réponse du ticket atteint',
        'Ticket first response time reached between' => 'Premier temps de réponse du ticket atteint entre',
        'Escalation - update time' => 'Remontée - Date de mise à jour',
        'Ticket update time reached' => 'Temps de mise à jour du ticket atteint',
        'Ticket update time reached between' => 'Temps de mise à jour du ticket atteint entre',
        'Escalation - solution time' => 'Remontée - Date de solution',
        'Ticket solution time reached' => 'Temps de résolution du ticket atteint',
        'Ticket solution time reached between' => 'Temps de résolution du ticket atteint entre',
        'Archive search option' => 'Option de recherche Archive',
        'Ticket Action' => 'Action sur Ticket',
        'Set new service' => 'Définir un nouveau service',
        'Set new Service Level Agreement' => 'Définir un nouveau contrat de niveau de service',
        'Set new priority' => 'Définir une nouvelle priorité',
        'Set new queue' => 'Définir une nouvelle file',
        'Set new state' => 'Définir un nouvel état',
        'Pending date' => 'Délais d\'attente',
        'Set new agent' => 'Définir un nouveà l\'opérateur',
        'new owner' => 'nouveau propriétaire',
        'new responsible' => 'nouveau responsable',
        'Set new ticket lock' => 'Placer un nouveau verrou sur le ticket',
        'New customer' => 'Nouveau client',
        'New customer ID' => 'Nouvel ID client',
        'New title' => 'Nouveau titre',
        'New type' => 'Nouveau type',
        'New Dynamic Field Values' => 'Nouvelles Valeurs de Champ Dynamique',
        'Archive selected tickets' => 'Archiver tickets sélectionnés',
        'Add Note' => 'Ajouter une note',
        'Time units' => 'Unité de temps',
        '(work units)' => 'Unité de travail',
        'Ticket Commands' => 'Commandes de Ticket',
        'Send agent/customer notifications on changes' => 'Envoyer des notifications à l\'opérateur/au client sur les changements',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Cette commande sera exécuté. ARG[0] sera le numéro du ticket et ARG[1] son identifiant.',
        'Delete tickets' => 'Supprimer les tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Attention: Tous les tickets impactés seront supprimés de la base de donnée et ne pourront être restaurés!',
        'Execute Custom Module' => 'Exécuter le Module Client',
        'Param %s key' => 'Clé Param %s',
        'Param %s value' => 'Valeur Param %s',
        'Save Changes' => 'Enregistrer les Modifications',
        'Results' => 'Résultat',
        '%s Tickets affected! What do you want to do?' => '%s Tickets impactés! Que voulez vous faire?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Attention: Vous allez utiliser l\'option supprimer. Tous les tickets supprimés seront perdus!',
        'Edit job' => 'Editer tâche',
        'Run job' => 'Exécuter tâche',
        'Affected Tickets' => 'Tickets impactés',

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
        'Remote IP' => '',
        'Loading' => 'En cours de chargement',
        'Select a single request to see its details.' => '',
        'Filter by type' => 'Filtrer par type',
        'Filter from' => 'Filtrer à partir de',
        'Filter to' => 'Filtrer jusqu\'au',
        'Filter by remote IP' => '',
        'Refresh' => 'Rafraîchir',
        'Request Details' => '',
        'An error occurred during communication.' => 'Une erreur est survenue durant la communication.',
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
        'The name you entered already exists.' => 'Le nom que vous avez entré existe déjà.',
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
        'GenericInterface Mapping Simple for Web Service %s' => 'Mappage simple de l\'interface générique du service Web %s',
        'Go back to' => 'Retour à',
        'Mapping Simple' => 'Mappage simple',
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

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Network transport' => 'Transport du réseau ',
        'Properties' => 'Propriétés',
        'Endpoint' => 'Point d\'extrémité',
        'URI to indicate a specific location for accessing a service.' =>
            'Identifiant uniforme de ressource (URI) qui permet d\'indiquer un lieu précis donnant accès à un service.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'par ex. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Espace de nommage',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'Identifiant uniforme de ressource (URI) pour offrir un contexte aux méthodes du protocole SOAP et réduire ainsi les ambiguïtés.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'par ex. urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Maximum message length' => 'longueur maximale du message',
        'This field should be an integer number.' => 'Ce champ doit être un composé d\'un nombre entier.',
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
        'Authentication' => 'Authentification',
        'The authentication mechanism to access the remote system.' => 'Le mécanisme d\'authentification permettant d\'accéder au système distant.',
        'A "-" value means no authentication.' => 'La valeur « - » signifie que l\'authentification n\'a pas fonctionné.',
        'The user name to be used to access the remote system.' => 'Nom d\'utilisateur devant être utilisé pour accéder au système distant.',
        'The password for the privileged user.' => 'Le mot de passe des usagers privilégiés.',
        'Use SSL Options' => 'Utiliser les options du protocole SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Afficher ou cacher les options SSL pour se connecter au système distant',
        'Certificate File' => 'Fichier de certificat',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Le chemin complet et le nom du fichier de certificat du protocole SSL (doit être en format « .p12 »).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'par ex. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'Certificate Password File' => 'Fichier du mot de passe du certificat',
        'The password to open the SSL certificate.' => 'Le mot de passe pour ouvrir le certificat SSL',
        'Certification Authority (CA) File' => 'Fichier de l\'autorité de certification (AC)',
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
        'Details' => 'Informations',
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
        'Show or hide the content.' => 'Afficher ou cacher le contenu.',
        'Restore' => 'Restaurer',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ATTENTION: Lorsque vous modifier le nom du group \'admin\', avant de faire les changements appropriés dans SysConfig, vous serez déconnecté du panneau d\'administration. Si cela arrive, veuillez renommer à nouveau le groupe admin par une requête SQL.',
        'Group Management' => 'Administration des groupes',
        'Add group' => 'Ajouter groupe',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Créer de nouveux groupes de gestion des permissions d\'accès pour les différents groupes de opérateurs (p. ex. achats, support, ventes,...). ',
        'It\'s useful for ASP solutions. ' => 'C\'est utile pour les solutions ASP',
        'Add Group' => 'Ajouter un groupe',
        'Edit Group' => 'Editer Groupe',

        # Template: AdminLog
        'System Log' => 'Journaux du Système',
        'Here you will find log information about your system.' => 'Vous trouverez ici les informations de log sur votre système',
        'Hide this message' => 'Masquer ce message',
        'Recent Log Entries' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestion du compte de messagerie',
        'Add mail account' => 'Ajouter compte mail',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Tous les e-mails entrants avec un compte associé seront répartis dans la file sélectionnée !',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Si votre compte est vérifié, les entêtes X-OTRS (pour les priorités,...) seront utilisées !',
        'Host' => 'Hôte',
        'Delete account' => 'Supprimer le compte',
        'Fetch mail' => 'Parcourir mail',
        'Add Mail Account' => 'Aouter un compte mail',
        'Example: mail.example.com' => 'Exemple : mail.exemple.com',
        'IMAP Folder' => 'Dossier IMAP ',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifiez ce champ seulement si vous souhaitez avoir accès à des mails situés ailleurs que dans la boîte de réception.',
        'Trusted' => 'Vérifié',
        'Dispatching' => 'Répartition',
        'Edit Mail Account' => 'Editer compte mail',

        # Template: AdminNavigationBar
        'Admin' => 'Administrateur',
        'Agent Management' => 'Gestion des Opérateurs',
        'Queue Settings' => 'Configuration des Files',
        'Ticket Settings' => 'Configuration des Tickets',
        'System Administration' => 'Administration Système',

        # Template: AdminNotification
        'Notification Management' => 'Gestion des notifications',
        'Select a different language' => 'Choisir une autre langue.',
        'Filter for Notification' => 'Filtre pour Notification',
        'Notifications are sent to an agent or a customer.' => 'Des notifications sont envoyées à un opérateur ou à un client.',
        'Notification' => 'Notification',
        'Edit Notification' => 'Editer Notification',
        'e. g.' => 'p. ex.',
        'Options of the current customer data' => 'Options des données du cient actuel',

        # Template: AdminNotificationEvent
        'Add notification' => 'Ajouter notification',
        'Delete this notification' => 'Supprimer cette notification',
        'Add Notification' => 'Ajouter Notification',
        'Article Filter' => 'Filtre pour Article',
        'Only for ArticleCreate event' => 'Seulement pour l\'évenement CréationArticle',
        'Article type' => 'Type d\'article',
        'Article sender type' => '',
        'Subject match' => 'Correspondance du sujet',
        'Body match' => 'Correspondance du corps du message',
        'Include attachments to notification' => 'Inclure les pièces jointes à la notification',
        'Recipient' => 'Destinataire',
        'Recipient groups' => 'Groupes destinataires',
        'Recipient agents' => 'Opérateurs destinataires',
        'Recipient roles' => 'Rôles destinaires',
        'Recipient email addresses' => 'Adresses e-mail destinataires',
        'Notification article type' => 'Type de notification',
        'Only for notifications to specified email addresses' => 'Seulement pour les notifications destinées aux adresses mails mentionnées',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Pour avoir les 20 premiers caractères du sujet (du dernier article de l\'opérateur).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Pour avoir les 5 premières ligne du corps (du dernier article de l\'opérateur).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Pour avoir les 20 premiers caractères du sujet (du dernier article du client).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Pour avoir les 5 premières lignes du sujet (du dernier article du client).',

        # Template: AdminPGP
        'PGP Management' => 'Gestion de PGP',
        'Use this feature if you want to work with PGP keys.' => 'Cette fonctionnalité vous permet de travailler avec les clés PGP.',
        'Add PGP key' => 'Ajouter clé PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Dans ce cas vous pouvez directement éditer le trousseau configuré dans SysConfig.',
        'Introduction to PGP' => 'Introduction aux clés PGP',
        'Result' => 'Résultat',
        'Identifier' => 'Identifiant',
        'Bit' => 'Bit',
        'Fingerprint' => 'Empreinte',
        'Expires' => 'Expiration',
        'Delete this key' => 'Supprimer cette clé',
        'Add PGP Key' => 'Ajouter Clé PGP',
        'PGP key' => 'Clé PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestionnaire de paquet',
        'Uninstall package' => 'Désinstaller package',
        'Do you really want to uninstall this package?' => 'Voulez-vous vraiment déinstaller ce paquet ?',
        'Reinstall package' => 'Réinstaller package',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Voulez-vous vraiment réinstaller ce package? Un quelconque changement manuel sera perdu. ',
        'Continue' => 'Continuer',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Installation',
        'Install Package' => 'Installer Package',
        'Update repository information' => 'Mettre à jour les informations du dépot',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Dépot en ligne',
        'Vendor' => 'Vendeur',
        'Module documentation' => 'Documentation du module',
        'Upgrade' => 'Mise à jour',
        'Local Repository' => 'Dépôt local',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Désinstallation',
        'Reinstall' => 'Ré-installation',
        'Feature Add-Ons' => 'Fonctionnalité des Compléments',
        'Download package' => 'Télécharger package',
        'Rebuild package' => 'Reconstruire package',
        'Metadata' => 'Metadata',
        'Change Log' => 'Journal des modifications',
        'Date' => 'Date',
        'List of Files' => 'Liste de fichiers',
        'Permission' => 'Droits',
        'Download' => 'Téléchargement',
        'Download file from package!' => 'Télécharger le fichier depuis le paquet !',
        'Required' => 'Obligatoire',
        'PrimaryKey' => 'Clé primaire',
        'AutoIncrement' => 'Auto incrémentation',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Différences de fichier pour le fichier %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Enregistrement des indicateurs de performance',
        'This feature is enabled!' => 'Cette fonctionnalité est activée',
        'Just use this feature if you want to log each request.' => 'N\'employer cette fonction que si vous voulez enregitrer chaque requête',
        'Activating this feature might affect your system performance!' =>
            'Activer cette fonctionnalité peut avoir un impact sur les performances de votre système !',
        'Disable it here!' => 'Désactivez là ici !',
        'Logfile too large!' => 'Fichier de log trop grand !',
        'The logfile is too large, you need to reset it' => 'Le fichier de log est trop grand, vous devez le réinitialiser',
        'Overview' => 'Aperçu',
        'Range' => 'Plage',
        'last' => 'dernier',
        'Interface' => 'Interface',
        'Requests' => 'Requêtes',
        'Min Response' => 'Temps de réponse minimum',
        'Max Response' => 'Temps de réponse maximun',
        'Average Response' => 'Temps de réponse moyen',
        'Period' => 'Période',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Moyenne',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestion des filtres PostMaster',
        'Add filter' => 'Ajouter filtre',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Si vous voulez tester uniquement l\'e-mail, utiliser EMAILADDRESS:info@example.com dans De, À ou Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '',
        'Delete this filter' => 'Supprimer ce filtre',
        'Add PostMaster Filter' => 'Ajouter un filtre PostMaster',
        'Edit PostMaster Filter' => 'Editer ce filtre PostMaster',
        'The name is required.' => 'Le nom est requis',
        'Filter Condition' => 'Condition de filtre',
        'AND Condition' => '',
        'Negate' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'Régler les entêtes e-mail',
        'The field needs to be a literal word.' => 'Ce champ doit comporter un libellé.',

        # Template: AdminPriority
        'Priority Management' => 'Gestion de la priorité',
        'Add priority' => 'Ajouter priorité',
        'Add Priority' => 'Ajouter la priorité',
        'Edit Priority' => 'Editer priorité',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Process Name' => '',
        'Create New Process' => '',
        'Synchronize All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
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

        # Template: AdminProcessManagementPopupResponse

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
        'Manage Queues' => 'Gérer les Files',
        'Add queue' => 'Ajouter une file',
        'Add Queue' => 'Ajouter une File',
        'Edit Queue' => 'Editer une File',
        'Sub-queue of' => 'Sous-file de',
        'Unlock timeout' => 'Délai du déverrouillage',
        '0 = no unlock' => '0 = pas de déverrouillage',
        'Only business hours are counted.' => 'Seules les plages horaires de bureau sont prises en compte.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Si un opérateur vérouille un ticket et ne le ferme pas avant le délai de dévérouillage, le ticket sera dévérouillé et sera disponible pour un autre opérateur.',
        'Notify by' => 'Notification par',
        '0 = no escalation' => '0 = pas de remontée du ticket',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Si un contact client n\'est pas ajouté à un nouveau ticket, soit par e-mail externe ou téléphone, avant que le temps défini ici expire, le ticket sera remonté.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Si le ticket n\'est pas clôturé avant que le délai défini ici n\'expire, le ticket est remonté.',
        'Follow up Option' => 'Option des suivis',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Défini si le suivi des tickets clôturés doit réouvrir le ticket, être rejeté ou créer un nouveau ticket.',
        'Ticket lock after a follow up' => 'Ticket verrouillé après un suivi',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Si le tiket est clos et que le client envoie un suivi, le ticket sera vérouillé à l\'ancien propriétaire.',
        'System address' => 'Adresse Système',
        'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expédition pour les réponses par e-mail de cette file.',
        'Default sign key' => 'Clé de signature par défaut',
        'The salutation for email answers.' => 'La formule de politesse pour les réponses par e-mail.',
        'The signature for email answers.' => 'La signature pour les réponses par e-mail.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gérer les relations entre les files et les réponses automatiques',
        'Filter for Queues' => 'Filtre pour les files',
        'Filter for Auto Responses' => 'Filtre pour les réponses automatiques',
        'Auto Responses' => 'Réponses automatiques',
        'Change Auto Response Relations for Queue' => 'Modifier les réponses automatiques pour la file',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRole
        'Role Management' => 'Gestion des Rôles',
        'Add role' => 'Ajouter un rôle',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Crée un rôle et y ajoute des groupes. Ajoute alors le rôle aux utilisateurs.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Il n\'y a pas de rôle défini. Utilisez le bouton \'Ajouter\' pour créer un nouveau rôle.',
        'Add Role' => 'Ajouter un rôle',
        'Edit Role' => 'Editer rôle',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gérer Relations Rôle-Groupe',
        'Filter for Roles' => 'Filtre pour Rôles',
        'Roles' => 'Rôles',
        'Select the role:group permissions.' => 'Sélectionner les permissions rôle:groupe',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Si rien n\'est sélectionné, alors il n\'y a aucune permission pour ce groupe (les tickets ne seront pas disponibles pour ce rôle).',
        'Change Role Relations for Group' => 'Modifier les relations des rôles pour un groupe',
        'Change Group Relations for Role' => 'Modifier les relations des groupes pour le rôle',
        'Toggle %s permission for all' => 'Sélectionner permission %s pour tous',
        'move_into' => 'déplacer dans',
        'Permissions to move tickets into this group/queue.' => 'Permission de déplacer un ticket dans cette file/ce groupe.',
        'create' => 'créer',
        'Permissions to create tickets in this group/queue.' => 'Permission de créer un ticket dans cette file/ce groupe.',
        'priority' => 'priorité',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permission de changer la priorité d\'un ticket dans cette file/ce groupe.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gérer les relations Opérateur-Rôle',
        'Filter for Agents' => 'Filtre pour opérateurs',
        'Agents' => 'Opérateurs',
        'Manage Role-Agent Relations' => 'Gérer Relations Rôle-Opérateur',
        'Change Role Relations for Agent' => 'Changer les rôles pour un opérateur',
        'Change Agent Relations for Role' => 'Changer les opérateurs pour un rôle ',

        # Template: AdminSLA
        'SLA Management' => 'Gestion des Accords sur la qualité de service (Service Level Agreement)',
        'Add SLA' => 'Ajouter un SLA',
        'Edit SLA' => 'Editer SLA',
        'Please write only numbers!' => 'Merci de n\'écrire que des nombres',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestion S/MIME',
        'Add certificate' => 'Ajouter certificat',
        'Add private key' => 'Ajouter clé privé',
        'Filter for certificates' => 'Filtres pour les certificats',
        'Filter for SMIME certs' => 'Filtres pour les certificats SMIME',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Vous pouvez ajouter ici des liens à votre certification privée, ceux-ci seront incorporés à votre signature SMIME chaque fois que vous utiliserez cette certification pour signer un email.',
        'See also' => 'Voir aussi',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Dans ce cas vous pouvez directement éditer le certificat et la clé privée dans le système de fichier',
        'Hash' => 'Hashage',
        'Handle related certificates' => 'Gestion des certificats associés',
        'Read certificate' => 'Lire le certificat',
        'Delete this certificate' => 'Supprimer ce certificat',
        'Add Certificate' => 'Ajouter un certificat',
        'Add Private Key' => 'Ajouter une clé privée',
        'Secret' => 'Secret',
        'Related Certificates for' => 'Certificats associés à',
        'Delete this relation' => 'Supprimer cette relation',
        'Available Certificates' => 'Certificats disponibles',
        'Relate this certificate' => 'Lie ce certificat',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => 'Certificat SMIME',
        'Close window' => 'Fermer fenêtre',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestion des Formules de Politesse',
        'Add salutation' => 'Ajouter une formule de politesse',
        'Add Salutation' => 'Ajouter une Formule de Politesse',
        'Edit Salutation' => 'Editer Formule de Politesse',
        'Example salutation' => 'Exemple de formule de politesse',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            'Cette option forcera le démarrage de l\'ordonnanceur même si le processus est encore enregistré dans la base de données',
        'Start scheduler' => 'Démarrer l\'ordonnanceur',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            'L\'ordonnanceur ne peut être démarré. Assurez-vous qu\'il n\'est pas déjà en fonction, puis essayez à nouveau au moyen de l\'option Forcer le démarrage.',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Le mode sécurisé doit être activé',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Le mode sécurisé sera (normallement) activé lorsque l\'installation initiale sera terminée.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si le mode sécurisé n\'est pas activé, activez le via SysConfig car votre application est en train de tourner',

        # Template: AdminSelectBox
        'SQL Box' => 'Requêtes SQL',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Ici vous pouvez entrez du SQL pour l\'envoyer directement à la base de donnée',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Votre requête SQL comporte une erreur de syntaxe. Veuillez la corriger.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Il manque au moins un paramètre, ce qui empêche l\'association. Veuillez corriger la situation.',
        'Result format' => 'Format du résultat',
        'Run Query' => 'Exécuter requête',

        # Template: AdminService
        'Service Management' => 'Gestion des Services',
        'Add service' => 'Ajouter service',
        'Add Service' => 'Ajouter un Service',
        'Edit Service' => 'Editer service',
        'Sub-service of' => 'Sous-service de',

        # Template: AdminSession
        'Session Management' => 'Gestion des sessions',
        'All sessions' => 'Toutes les sessions',
        'Agent sessions' => 'Sessions Opérateurs',
        'Customer sessions' => 'Session Clients',
        'Unique agents' => 'Opérateurs uniques',
        'Unique customers' => 'Clients uniques',
        'Kill all sessions' => 'Supprimer toutes les sessions',
        'Kill this session' => 'tuer cette session',
        'Session' => 'Session',
        'Kill' => 'Tuer',
        'Detail View for SessionID' => 'Vue détaillée pour SessionID',

        # Template: AdminSignature
        'Signature Management' => 'Gestion des signatures',
        'Add signature' => 'Ajouter une signature',
        'Add Signature' => 'Ajouter une signature',
        'Edit Signature' => 'Editer signature',
        'Example signature' => 'Exemple de signature',

        # Template: AdminState
        'State Management' => 'Gestion des états',
        'Add state' => 'Ajouter un état',
        'Please also update the states in SysConfig where needed.' => 'Veuillez également mettre les états à jour dans SysConfig.',
        'Add State' => 'Ajouter un état',
        'Edit State' => 'Editer état',
        'State type' => 'Type d\'état',

        # Template: AdminSysConfig
        'SysConfig' => 'Configuration Système',
        'Navigate by searching in %s settings' => 'Naviguer en cherchant parmi %s réglages',
        'Navigate by selecting config groups' => 'Naviguer en sélectionnant les groupes de configuration',
        'Download all system config changes' => 'Télécharger toutes les modifications de configuration système',
        'Export settings' => 'Configuration d\'export',
        'Load SysConfig settings from file' => 'Charger la configuration SysConfig à partir du fichier',
        'Import settings' => 'configuration d\'import',
        'Import Settings' => 'Configuration d\'Import',
        'Please enter a search term to look for settings.' => 'Merci d\'entrer un motif de recherche pour chercher dans la configuration',
        'Subgroup' => 'Sous-groupe',
        'Elements' => 'Éléments',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Editer les éléments de configuration',
        'This config item is only available in a higher config level!' =>
            'Cet élément de configuration n\'est disponible que dans un niveau supérieur de configuration',
        'Reset this setting' => 'Réinitialiser cet élément',
        'Error: this file could not be found.' => 'Erreur: ce fichier ne peut pas être trouvé',
        'Error: this directory could not be found.' => 'Erreur: ce répertoire ne peut pas être trouvé',
        'Error: an invalid value was entered.' => 'Erreur: valeur incorrecte',
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
        'Loader' => 'Chargeur',
        'File to load for this frontend module' => 'Fichier à charger pour ce module d\'interface',
        'New Loader File' => 'Nouveau chargeur de fichier',
        'NavBarName' => 'Nom de la barre de navigation',
        'NavBar' => 'Barre de navigation',
        'LinkOption' => 'Option de lien',
        'Block' => 'Bloc',
        'AccessKey' => 'Accès clavier',
        'Add NavBar entry' => 'Ajouter entrée de barre de navigation',
        'Year' => 'Année',
        'Month' => 'Mois',
        'Day' => 'Jour',
        'Invalid year' => 'Année incorrecte',
        'Invalid month' => 'Mois incorrect',
        'Invalid day' => 'Jour incorrect',
        'Show more' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestion des e-mails du système',
        'Add system address' => 'Ajouter adresse système',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Tous les e-mail entrants avec cette adresse en À ou Cc seront envoyés dans la file sélectionnée',
        'Email address' => 'Adresse e-mail',
        'Display name' => 'Nom à afficher',
        'Add System Email Address' => 'Ajouter l\'adresse e-mail du système',
        'Edit System Email Address' => 'Éditer l\'adresse e-mail du système',
        'The display name and email address will be shown on mail you send.' =>
            'Le nom à afficher et l\'adresse e-mail seront affichés dans les messages que vous envoyez.',

        # Template: AdminTemplate
        'Manage Templates' => '',
        'Add template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Add Template' => '',
        'Edit Template' => '',
        'Template' => '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'L\'état actuel du ticket est',
        'Your email address is' => 'Votre e-mail est',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => '',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Sélectionner actif pour tous',
        'Link %s to selected %s' => 'Lien %s vers sélection %s',

        # Template: AdminType
        'Type Management' => 'Gestion des Types',
        'Add ticket type' => 'Ajouter type de ticket',
        'Add Type' => 'Ajouter un Type',
        'Edit Type' => 'Editer Type',

        # Template: AdminUser
        'Add agent' => 'Ajouter opérateur',
        'Agents will be needed to handle tickets.' => 'Des opérateurs seront requis pour gérer les tickets',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'N\'oubliez pas d\'ajouter un nouvel opérateur aux groupes et/ou rôles',
        'Please enter a search term to look for agents.' => 'Merci d\'entrer un motif de recherche pour chercher des opérateurs',
        'Last login' => 'Dernière connexion',
        'Switch to agent' => 'Changer d\'opérateur vers',
        'Add Agent' => 'Ajouter un opérateur',
        'Edit Agent' => 'Modifier l\'opérateur ',
        'Firstname' => 'Prénom',
        'Lastname' => 'Nom',
        'Will be auto-generated if left empty.' => '',
        'Start' => 'Démarrer',
        'End' => 'Fin',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gérer Relations opérateur-Groupe',
        'Change Group Relations for Agent' => 'Changer les relations de groupe pour l\'opérateur : ',
        'Change Agent Relations for Group' => 'Changer les relations avec les opérateurs pour le groupe : ',
        'note' => 'note',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissions d\'ajouter des notes aux tickets dans ce groupe/cette file',
        'owner' => 'propriétaire',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissions de changer le propriétaire des tickets dans ce gorupe/cette file.',

        # Template: AgentBook
        'Address Book' => 'Carnet d\'adresses',
        'Search for a customer' => 'Rechercher un client',
        'Add email address %s to the To field' => 'Ajouter l\'adresse e-mail %s au champ À',
        'Add email address %s to the Cc field' => 'Ajouter l\'adresse e-mail %s au champ Cc',
        'Add email address %s to the Bcc field' => 'Ajouter l\'adresse e-mail %s au champ Cci',
        'Apply' => 'Appliquer',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ID Client',
        'Customer User' => 'Client Utilisateur',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Doublon',
        'This address already exists on the address list.' => 'Cette adresse existe déjà dans la liste d\'addresses.',
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

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tickets remontés',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Information client',
        'Phone ticket' => 'Ticket téléphonique',
        'Email ticket' => 'Ticket par e-mail',
        '%s open ticket(s) of %s' => '%s ticket(s) ouvert(s) de %s',
        '%s closed ticket(s) of %s' => '%s ticket(s) fermé(s) de %s',
        'New phone ticket from %s' => 'Nouveau ticket téléphonique de %s',
        'New email ticket to %s' => 'Nouveau ticket par e-mail de %s',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s est disponible !',
        'Please update now.' => 'Merci de mettre à jour maintenant',
        'Release Note' => 'Note de version',
        'Level' => 'Niveau',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Envoyé il y a %s',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mes tickets verrouillés',
        'My watched tickets' => 'Mes tickets suivis',
        'My responsibilities' => 'Mes responsabilités',
        'Tickets in My Queues' => 'Tickets dans mes Files',
        'Service Time' => 'Temps pour le service',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Le ticket a été verrouillé',
        'Undo & close window' => 'Annuler et fermer la fenêtre',

        # Template: AgentInfo
        'Info' => 'Information',
        'To accept some news, a license or some changes.' => 'Pour accepter des nouvelles, une licence ou des modifications.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Lier l\'Objet: %s',
        'go to link delete screen' => 'Aller au lien vers l\'écran de suppression',
        'Select Target Object' => 'Sélectionner l\'Objet cible',
        'Link Object' => 'Lier l\'objet',
        'with' => 'avec',
        'Unlink Object: %s' => 'Délier l\'objet: %s',
        'go to link add screen' => 'Aller au lien ajout écran',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Editer vos préférences',

        # Template: AgentSpelling
        'Spell Checker' => 'Vérificateur orthographique',
        'spelling error(s)' => 'erreurs d\'orthographe',
        'Apply these changes' => 'Appliquer ces changements',

        # Template: AgentStatsDelete
        'Delete stat' => 'Supprimer la statistique',
        'Stat#' => 'Stat#',
        'Do you really want to delete this stat?' => 'Voulez-vous vraiment supprimer cette statistique?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Étape %s',
        'General Specifications' => 'Spécifications Générales',
        'Select the element that will be used at the X-axis' => 'Sélectionner l\'élement qui sera utilisé pour l\'axe X',
        'Select the elements for the value series' => 'Sélectionnez les éléments de la série de données',
        'Select the restrictions to characterize the stat' => 'Sélectionner les restrictions pour caractériser cette statistique',
        'Here you can make restrictions to your stat.' => 'Vous pouvez ici appliquer des restrictions à vos statistiques.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Si vous enlevez la coche dans la case, l\'opérateur generant les statistiques peut changer les attributs de l\élement correspondant',
        'Fixed' => 'Fixé',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Sélectionnez un seul élément ou désactivez le bouton \'Fixé\'',
        'Absolute Period' => 'Période Absolue',
        'Between' => 'Entre',
        'Relative Period' => 'Période relative',
        'The last' => 'Le dernier',
        'Finish' => 'Terminer',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Permissions',
        'You can select one or more groups to define access for different agents.' =>
            'Afin de donner des accès à différents opérateurs, sélectionnez un ou plusieurs groupes.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Des formats de résultats sont désactivés parce qu\'un ou plusieurs package(s) ne sont pas installés.',
        'Please contact your administrator.' => 'Veuillez contacter votre administrateur s\'il vous plaît.',
        'Graph size' => 'Taille du graphique',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Si vous choisissez Graphe comme format de sortie, vous devez choisir la taille',
        'Sum rows' => 'Ligne de somme',
        'Sum columns' => 'Colonnes de somme',
        'Use cache' => 'Utiliser le cache',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'La plus grande part des stats peuvent être mise en cache. Cela accèlere leur présentation',
        'If set to invalid end users can not generate the stat.' => 'Si mis à invalide, les utilisateurs finaux ne pourront pas générer la statistique.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'La présente étape vous permet de choisir les éléments qui composeront les séries de données.',
        'You have the possibility to select one or two elements.' => 'Vous êtes libre de choisir un ou deux éléments. ',
        'Then you can select the attributes of elements.' => 'Ensuite, vous choisissez les attributs souhaités de ces éléments.',
        'Each attribute will be shown as single value series.' => 'Chacun des attributs sera affiché en tant que série de données.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Si aucun attribut n\'est choisi, tous les attributs de l\'élément sélectionné seront utilisés lors de la génération de statistiques, ainsi que tous les nouveaux attributs qui seront ajoutés par la suite.',
        'Scale' => 'Échelle',
        'minimal' => 'minimale',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'SVP, rappelez vous que la plage pour la série de données doit être plus grande que l\'echelle de l\'axe des X (ex. axe des X => Mois, Série => Année',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'La présente étape vous permet de définir l\'axe X. Sélectionnez un élément au moyen des boutons d\'option.',
        'maximal period' => 'période minimale',
        'minimal scale' => 'Échelle minimale',

        # Template: AgentStatsImport
        'Import Stat' => 'Importer Statistique',
        'File is not a Stats config' => 'Ce n\'est pas un fichier de configuration de statistiques',
        'No File selected' => 'Aucun fichier sélectionné',

        # Template: AgentStatsOverview
        'Stats' => 'Statistiques',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Aucun élément sélectionné.',

        # Template: AgentStatsView
        'Export config' => 'Exporter la configuration',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Grâce aux champs de saisie et de sélection, vous pouvez adapter le format et le contenu des statistiques.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'L\'administrateur des statistiques détermine précisément quels sont les champs adaptables.',
        'Stat Details' => 'Details de la statistique',
        'Format' => 'Format',
        'Graphsize' => 'Taille du graphique',
        'Cache' => 'Cache',
        'Exchange Axis' => 'Échangez les axes',
        'Configurable params of static stat' => 'Paramètres modifiables des statistiques',
        'No element selected.' => 'Aucun élément sélectionné.',
        'maximal period from' => 'Période maximale depuis',
        'to' => 'vers',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Changer le Texte Libre du Ticket',
        'Change Owner of Ticket' => 'Changer le propriétaire du Ticket',
        'Close Ticket' => 'Fermer le Ticket',
        'Add Note to Ticket' => 'Ajouter une Note au Ticket',
        'Set Pending' => 'Définir la mise en attente',
        'Change Priority of Ticket' => 'Changer la priorité du Ticket',
        'Change Responsible of Ticket' => 'Changer le responsable du Ticket',
        'All fields marked with an asterisk (*) are mandatory.' => '',
        'Service invalid.' => 'Service invalide',
        'New Owner' => 'Nouveau Propriétaire',
        'Please set a new owner!' => 'Merci de renseigner un propriétaire',
        'Previous Owner' => 'Propriétaire Précédent',
        'Inform Agent' => 'Informer l\'opérateur',
        'Optional' => 'Optionnel',
        'Inform involved Agents' => 'Informer les opérateurs impliqués',
        'Spell check' => 'Vérifier orthographe',
        'Note type' => 'Type de note',
        'Next state' => 'État suivant',
        'Date invalid!' => 'Date invalide',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Renvoyer le Ticket',
        'Bounce to' => 'Renvoyer à',
        'You need a email address.' => 'Vous devez avoir une adresse e-mail.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Une adresse e-mail valide est nécessaire ou n\'utilisez pas d\'adresse e-mail locale.',
        'Next ticket state' => 'Prochain état du ticket',
        'Inform sender' => 'Informer l\'emetteur',
        'Send mail' => 'Envoyer le message !',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket en action groupée',
        'Send Email' => 'Envoyer E-mail',
        'Merge to' => 'Fusionner avec',
        'Invalid ticket identifier!' => 'Identifiant de ticket invalide !',
        'Merge to oldest' => 'Fusionner avec le plus ancien',
        'Link together' => 'Lier ensemble',
        'Link to parent' => 'Lier au parent',
        'Unlock tickets' => 'Déverrouiller les tickets',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Rédiger une réponse pour le ticket',
        'Please include at least one recipient' => 'Merci d\'inclure au moins un destinataire',
        'Remove Ticket Customer' => 'Retirer le Ticket Client',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Merci de retirer cette entrée et de la remplacer par une valeur correcte.',
        'Remove Cc' => 'Retirer le Cc',
        'Remove Bcc' => 'Retirer le Bcc',
        'Address book' => 'Carnet d\'adresse',
        'Pending Date' => 'En attendant la date',
        'for pending* states' => 'pour tous les états de mise en attente',
        'Date Invalid!' => 'Date invalide',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Modifier le client du ticket',
        'Customer user' => 'Client Utilisateur',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Créer un Nouveau Ticket par E-mail',
        'From queue' => 'De la file',
        'To customer user' => '',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer user as the main customer user.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Tout prendre',
        'Text Template' => '',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Tranférer le ticket: %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Historique de',
        'History Content' => 'Contenu de l\'historique',
        'Zoom view' => 'Zoomer sur la vue',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Fusion de Ticket',
        'You need to use a ticket number!' => 'Vous devez utiliser un numéro de ticket !',
        'A valid ticket number is required.' => 'Un numéro de ticket valide est obligatoire.',
        'Need a valid email address.' => 'Une adresse e-mail valide est nécessaire.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Changer la file du ticket',
        'New Queue' => 'Nouvelle File',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Tout sélectionner',
        'No ticket data found.' => 'Aucune donnée de ticket trouvée',
        'First Response Time' => 'Temps pour fournir la première réponse (prise en compte)',
        'Update Time' => 'Temps pour fournir un point d\'avancement',
        'Solution Time' => 'Temps pour fournir la réponse',
        'Move ticket to a different queue' => 'Déplacer ticket vers une autre file',
        'Change queue' => 'Changer de file',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Changer les options de recherche',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Tickets par page',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Créer un nouveau Ticket téléphonique',
        'Please include at least one customer for the ticket.' => 'Veuillez inclure au moins un client au ticket',
        'Select this customer as the main customer.' => '',
        'To queue' => 'Vers la file',

        # Template: AgentTicketPhoneCommon

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Vue complète du texte du message',
        'Plain' => 'Tel quel',
        'Download this email' => 'Télécharger cet e-mail',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Information du Ticket',
        'Accounted time' => 'Temp passé',
        'Linked-Object' => 'Objet lié',
        'by' => 'par',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Modèle de recherche',
        'Create Template' => 'Créer Modèle',
        'Create New' => 'Créer nouveau',
        'Profile link' => 'Lien du Profil',
        'Save changes in template' => 'Sauvegarder les modifications du modèle',
        'Add another attribute' => 'Ajouter un autre attribut',
        'Output' => 'Format du résultat',
        'Fulltext' => 'Texte Complet',
        'Remove' => 'Supprimer',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Nom de connexion du client',
        'Created in Queue' => 'Créé dans la file',
        'Lock state' => 'État verrouillé',
        'Watcher' => 'Surveillance',
        'Article Create Time (before/after)' => 'Date Création Article (avant/après)',
        'Article Create Time (between)' => 'Date Création Article (Période)',
        'Ticket Create Time (before/after)' => 'Date Création Ticket (avant/après)',
        'Ticket Create Time (between)' => 'Date Création Ticket (Période)',
        'Ticket Change Time (before/after)' => 'Date Modification Ticket (avant/après)',
        'Ticket Change Time (between)' => 'Date Modification Ticket (Période)',
        'Ticket Close Time (before/after)' => 'Date Fermeture Ticket (avant/après)',
        'Ticket Close Time (between)' => 'Date Fermeture Ticket (Période)',
        'Ticket Escalation Time (before/after)' => 'Date Remontée Ticket (avant/après)',
        'Ticket Escalation Time (between)' => 'Date Remontée Ticket (Période)',
        'Archive Search' => 'Recherche Archive',
        'Run search' => 'Lancer la recherche',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filtre d\'Article',
        'Article Type' => 'Type d\'Article',
        'Sender Type' => 'Type de l\'expéditeur',
        'Save filter settings as default' => 'Sauvegarder les paramètres de filtrage comme paramètres par défaut',
        'Archive' => 'Archiver',
        'This ticket is archived.' => 'Ce ticket est archivé',
        'Locked' => 'Verrouillé',
        'Linked Objects' => 'Objets liés',
        'Article(s)' => 'Article(s)',
        'Change Queue' => 'Modifier file',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Add Filter' => 'Ajouter filtre',
        'Set' => 'Assigner',
        'Reset Filter' => 'Réinitialiser filtre',
        'Show one article' => 'Montrer un article',
        'Show all articles' => 'Montrer tous les articles',
        'Unread articles' => 'Articles non lus',
        'No.' => 'Non.',
        'Important' => '',
        'Unread Article!' => 'Article non lu!',
        'Incoming message' => 'Message entrant',
        'Outgoing message' => 'Message sortant',
        'Internal message' => 'Message Interne',
        'Resize' => 'Redimensionner',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Pour protéger votre vie privée, les contenus distants ont été bloqués.',
        'Load blocked content.' => 'Charger le contenu bloqué',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Trace du retour d\'erreur',

        # Template: CustomerFooter
        'Powered by' => 'Fonction assurée par',
        'One or more errors occurred!' => 'Une ou plusieurs erreurs se sont produites!',
        'Close this dialog' => 'Fermer cette fenêtre de dialogue',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'La fenêtre popup n\'a pas pu s\'ouvrir. Merci de désactiver le bloqueur de popup pour cette application.',
        'There are currently no elements available to select from.' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript non disponible',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Pour utiliser OTRS, vous devez activer le JavaScript dans votre navigateur.',
        'Browser Warning' => 'Avertissement du navigateur',
        'The browser you are using is too old.' => 'Votre navigateur est trop ancien.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS tourne sur un grand nombre de navigateurs, merci de mettre à jour votre navigateur vers l\'un de ceux-ci.',
        'Please see the documentation or ask your admin for further information.' =>
            'Merci de se référer à la documentation ou demander à votre administrateur système pour de plus amples informations.',
        'Login' => 'Connexion',
        'User name' => 'Identifiant',
        'Your user name' => 'Votre Identifiant',
        'Your password' => 'Votre mot de passe',
        'Forgot password?' => 'Mot de passe oublié?',
        'Log In' => 'Connexion',
        'Not yet registered?' => 'Pas encore enregistré?',
        'Sign up now' => 'Enregistrez-vous maintenant',
        'Request new password' => 'Demande de nouveau mot de passe',
        'Your User Name' => 'Votre nom',
        'A new password will be sent to your email address.' => 'Un nouveau mot de passe sera envoyé à votre adresse e-mail',
        'Create Account' => 'Créer un compte',
        'Please fill out this form to receive login credentials.' => 'Veuillez remplir ce formulaire pour recevoir vos identifiants de connexion',
        'How we should address you' => 'Comment devons-nous nous adresser à vous',
        'Your First Name' => 'Votre prénom',
        'Your Last Name' => 'Votre nom de famille',
        'Your email address (this will become your username)' => 'Votre adresse e-mail (celle-ci deviendra votre identifiant)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Editer les préférences',
        'Logout %s' => 'Déconnecter %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Contrat de niveau de service (SLA)',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Bienvenue !',
        'Please click the button below to create your first ticket.' => 'Merci de cliquer sur le bouton suivant pour créer votre premier ticket.',
        'Create your first ticket' => 'Créez votre premier ticket',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Imprimer le Ticket',
        'Ticket Dynamic Fields' => '',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'p. ex. 10*5155 ou 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Recherche plein texte dans les tickets (p. ex. "Laetitia*v" ou Emmanuel*")',
        'Carbon Copy' => 'Copie Carbone',
        'Types' => 'Types',
        'Time restrictions' => 'Restrictions de temps',
        'No time settings' => 'Pas de réglages de temps',
        'Only tickets created' => 'Seulement les tickets créés',
        'Only tickets created between' => 'Seulement les tickets créés entre',
        'Ticket archive system' => 'Système d\'archivage de ticket',
        'Save search as template?' => 'Enregistrer la recherche comme modèle ?',
        'Save as Template?' => 'Enregistrer comme Modèle',
        'Save as Template' => 'Enregistrer comme Modèle',
        'Template Name' => 'Nom du Modèle',
        'Pick a profile name' => 'Choisissez un nom de profil',
        'Output to' => 'Sortie vers',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Page' => 'Page',
        'Search Results for' => 'Résultats de recherche pour',

        # Template: CustomerTicketZoom
        'Expand article' => 'Déplier l\'article',
        'Information' => 'Information',
        'Next Steps' => 'Étapes Suivantes',
        'Reply' => 'Répondre',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
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
        'Invalid date (need a future date)!' => 'Date invalide (une date future est nécessaire) !',
        'Previous' => 'Précédent',
        'Open date selection' => 'Sélection date d\'ouverture',

        # Template: Error
        'Oops! An Error occurred.' => 'Oups! Une erreur est survenue.',
        'Error Message' => 'Message d\'Erreur',
        'You can' => 'Vous pouvez',
        'Send a bugreport' => 'Envoyer un rapport de bug',
        'go back to the previous page' => 'Revenir à la page précédente',
        'Error Details' => 'Détails de l\'erreur',

        # Template: Footer
        'Top of page' => 'Haut de la page',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Si vous quittez cette page maintenant, toutes les fenêtres popup seront closes également!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Un popup de cet écran est déjà ouvert. Désirez-vous le fermer et charger celui-ci à la place?',
        'Please enter at least one search value or * to find anything.' =>
            'merci d\'entrer au moins une valeur de recherche ou * pour trouver quoi que ce soit.',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => 'Recherche plein texte',
        'CustomerID Search' => 'Recherche ID Client',
        'CustomerUser Search' => 'Recherche Utilisateur Client',
        'You are logged in as' => 'Vous êtes connecté avec',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript non disponible',
        'Database Settings' => 'Réglages de Base de Données',
        'General Specifications and Mail Settings' => 'Spécifications Générales et Réglages de Messagerie',
        'Registration' => 'Inscription',
        'Welcome to %s' => 'Bienvenue dans %s',
        'Web site' => 'Site web',
        'Mail check successful.' => 'Contrôle de mail effectué avec succès.',
        'Error in the mail settings. Please correct and try again.' => 'Erreur dans la configuration de la messagerie. Merci de corriger et de ré-essayer.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurer le mail sortant',
        'Outbound mail type' => 'Type de mail sortant',
        'Select outbound mail type.' => 'Sélectionner le type de mail sortant',
        'Outbound mail port' => 'Port mail sortant',
        'Select outbound mail port.' => 'Sélectionner le port mail sortant',
        'SMTP host' => 'Hôte SMTP',
        'SMTP host.' => 'Hôte SMTP.',
        'SMTP authentication' => 'Authentification SMTP',
        'Does your SMTP host need authentication?' => 'Est-ce-que votre hôte SMTP supporte l\'authentification?',
        'SMTP auth user' => 'Utilisateur auth SMTP',
        'Username for SMTP auth.' => 'Nom utilisateur pour auth SMTP.',
        'SMTP auth password' => 'Mot de passe auth SMTP',
        'Password for SMTP auth.' => 'Mot de passe pour autgh SMTP.',
        'Configure Inbound Mail' => 'Configurer mail entrant',
        'Inbound mail type' => 'Type de mail entrant',
        'Select inbound mail type.' => 'Sélectionner le type de mail entrant',
        'Inbound mail host' => 'Hôte mail entrant',
        'Inbound mail host.' => 'Hôte mail entrant.',
        'Inbound mail user' => 'Utilisateur mail entrant',
        'User for inbound mail.' => 'Utilisateuyr pour mail entrant.',
        'Inbound mail password' => 'Mot de passe mail entrant',
        'Password for inbound mail.' => 'Mot de passe pour mail entrant.',
        'Result of mail configuration check' => 'Résultat du contrôle de configuration mail',
        'Check mail configuration' => 'Vérifier la configuration mail',
        'Skip this step' => 'Passer cette étape',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Mise en place Base de données réussie!',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => 'Vérifier la configuration base de données',
        'Result of database check' => 'Résultat du contrôle de la base de données',
        'OK' => '',
        'Database check successful.' => 'Contrôle de base de donnée effectué avec succès.',
        'Database User' => '',
        'New' => 'Nouveau',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Un nouvel utilisateur de la base de données sera créé avec des droits limités pour ce système OTRS.',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerDBpostgresql

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Pour pouvoir utiliser OTRS, vous devez entrer les commandes suivantes dans votre terminal en tant que root.',
        'Restart your webserver' => 'Redémarrer votre serveur web',
        'After doing so your OTRS is up and running.' => 'Après avoir fait ceci votre OTRS est en service',
        'Start page' => 'Page de démarrage',
        'Your OTRS Team' => 'Votre Équipe OTRS',

        # Template: InstallerLicense
        'Accept license' => 'Accepter la licence',
        'Don\'t accept license' => 'Ne pas accepter la licence',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Société',
        'Position' => 'Poste',
        'Complete registration and continue' => 'Remplir l\'enregistrement et continuer',
        'Please fill in all fields marked as mandatory.' => 'Veuillez remplir tous les champs obligatoires.',

        # Template: InstallerSystem
        'SystemID' => 'ID Système',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '',
        'System FQDN' => 'FQDN du système',
        'Fully qualified domain name of your system.' => 'Nom de domaine pleinement qualifié de votre système.',
        'AdminEmail' => 'E-mail administrateur',
        'Email address of the system administrator.' => 'Adresse e-mail de l\'administrateur système.',
        'Log' => 'Journal',
        'LogModule' => 'Module de journalisation',
        'Log backend to use.' => 'Moteur de journalisation à utiliser.',
        'LogFile' => 'Fichier de log',
        'Webfrontend' => 'Frontal web',
        'Default language' => 'Langue par défaut',
        'Default language.' => 'Langue par défaut.',
        'CheckMXRecord' => 'Vérifier les enregistrements MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Les adresses emails entrées manuellement sont contrevérifiées avec les enregistrements message du serveur de nom de domaine. N\'utilisez pas cette option si votre serveur de nom de domaine est lent ou qu\'il ne résout pas les adresses publiques.',

        # Template: LinkObject
        'Object#' => 'N° Objet',
        'Add links' => 'Ajouter des liens',
        'Delete links' => 'Supprimer les liens',

        # Template: Login
        'Lost your password?' => 'Mot de passe oublié ?',
        'Request New Password' => 'Demander un nouveau mot de passe',
        'Back to login' => 'Retour à la page de connexion',

        # Template: Motd
        'Message of the Day' => 'Message du jour',

        # Template: NoPermission
        'Insufficient Rights' => 'Droits insuffisants',
        'Back to the previous page' => 'Revenir à la page précédente',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Montrer la première page',
        'Show previous pages' => 'Montrer les pages précédentes',
        'Show page %s' => 'Montrer la page %s',
        'Show next pages' => 'Montrer les pages suivantes',
        'Show last page' => 'Montrer la dernière page',

        # Template: PictureUpload
        'Need FormID!' => 'Vous devez posséder un formulaire d\'identification.',
        'No file found!' => 'Aucun fichier trouvé !',
        'The file is not an image that can be shown inline!' => 'Le fichier n\'est pas une image qui puisse être affichée directement !',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'Imprimé par :',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Page de test d\'OTRS',
        'Welcome %s' => 'Bienvenue %s',
        'Counter' => 'Compteur',

        # Template: Warning
        'Go back to the previous page' => 'Revenir à la page précédente',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Module ACL qui autorise la fermture du ticket parent uniquement si tout ses enfants sont déjà clos("Etat" montre quels états ne sont pas disponibles pour le ticket parent tant que ses enfants ne sont pas clos).',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Active un méchanisme de clignotement du nom de la file qui contient le plus vieux ticket.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Active la fonction de mot de passe perdu pour les opérateurs, dans l\'interface des opérateurs.',
        'Activates lost password feature for customers.' => 'Active la fonction mot de passe perdu pour les clients.',
        'Activates support for customer groups.' => 'Active le support pour les groupes de client.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Active le filtre d\'article dans la vue de zoom pour spécifier quels articles doivent être montrés.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Active les thèmes disponibles sur le système. La valeur 1 le rend actif, 0 le désactive.',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Active le système d\'archive de ticket pour accélérer le système en déplaçant des tickets qui ne sont pas du jour. Pour chercher dans ces tickets, le flag archive doit être activé dans la recherche de ticket.',
        'Activates time accounting.' => 'Active la comptabilisation du temps',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Ajoute les jour de vacances. Merci d\'utiliser un seul chiffre pour les nombres de 1 à 9 (au lieu de 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Ajoute les jour de vacances permanentes. Merci d\'utiliser un seul chiffre pour les nombres de 1 à 9 (au lieu de 01 - 09).',
        'Agent Notifications' => 'Notifications pour les opérateurs',
        'Agent interface article notification module to check PGP.' => 'Module de notification d\'article dans l\'interface opérateur pour vérifier le PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'Module de notification d\'article dans l\'interface opérateur pour vérifier le S/MIME',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Module de l\'interface opérateur pour accéder à la recherche plein texte dans la barre de navigation.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Module de l\'interface opérateur pour accéder à la recherche des profils dans la barre de navigation.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to check the used charset.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => 'Opérateurs <-> Groupes',
        'Agents <-> Roles' => 'Opérateurs <-> Rôles',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Autorise l\'ajout de notes dans l\'écran de fermeture du ticket dans l\'interface opérateur.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Autorise l\'ajout de notes dans l\'écran de champ libre du ticket dans l\'interface opérateur.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Autorise l\'ajout de notes dans l\'écran de note du ticket dans l\'interface opérateur.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Autorise l\'ajout de notes dans l\'écran du propriétaire d\'un ticket zoomé dans l\'interface opérateur.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Autorise l\'ajout de notes dans l\'écran de mise en attente d\'un ticket zoomé dans l\'interface opérateur.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Autorise l\'ajout de notes dans l\'écran de priorité d\'un ticket zoomé dans l\'interface opérateur.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Autorise l\'ajout de notes dans l\'écran du responsable d\'un ticket dans l\'interface opérateur.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Autorise les opérateurs à échanger les axes d\'une statistique si ils en génèrent une.',
        'Allows agents to generate individual-related stats.' => 'Autorise les opérateurs à générer des statistiques relatives à un individu.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'ArticleTree' => '',
        'Attachments <-> Templates' => '',
        'Auto Responses <-> Queues' => 'Réponses Auto <-> Files',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
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
        'Change password' => 'Changer de mot de passe',
        'Change queue!' => 'Changer de file!',
        'Change the customer for this ticket' => 'Changer le client de ce ticket',
        'Change the free fields for this ticket' => 'Changer les champs libres de ce ticket',
        'Change the priority for this ticket' => 'Changer la priorité de ce ticket',
        'Change the responsible person for this ticket' => 'Changer la personne responsable pour ce ticket',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => 'Tickets clos',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled. Note: no more columns are allowed and will be discarded.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => '',
        'Company Tickets' => 'Tickets de l\'entreprise',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Contrôle si les clients ont la possibilité de classer leurs tickets.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Contrôle si plus d\'une entrée peut être mise dans un nouveau ticket téléphone depuis l\'interface opérateur.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Créer et gérer les contrats de niveau de support (SLAs).',
        'Create and manage agents.' => 'Créer et gérer les opérateurs.',
        'Create and manage attachments.' => 'Créer et gérer les pièces jointes.',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'Créer et gérer les clients.',
        'Create and manage dynamic fields.' => 'Créer et gérer les champs dynamiques.',
        'Create and manage event based notifications.' => 'Créer et gérer les notifications évenementielles.',
        'Create and manage groups.' => 'Créer et gérer les groupes.',
        'Create and manage queues.' => 'Créer et gérer les files.',
        'Create and manage responses that are automatically sent.' => 'Créer et gérer  les réponses envoyées automatiquement.',
        'Create and manage roles.' => 'Créer et gérer les rôles.',
        'Create and manage salutations.' => 'Créer et gérer les en-têtes.',
        'Create and manage services.' => 'Créer et gérer les services.',
        'Create and manage signatures.' => 'Créer et gérer les signatures.',
        'Create and manage templates.' => '',
        'Create and manage ticket priorities.' => 'Créer et gérer les priorités de ticket.',
        'Create and manage ticket states.' => 'Créer et gérer les états de ticket.',
        'Create and manage ticket types.' => 'Créer et gérer les types de ticket.',
        'Create and manage web services.' => 'Créer et gérer les services web.',
        'Create new email ticket and send this out (outbound)' => 'Créer un nouvel ticket par e-mail et l\'envoyer (sortant)',
        'Create new phone ticket (inbound)' => 'Créer un nouveau ticket par téléphone (entrant)',
        'Create new process ticket' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User <-> Groups' => '',
        'Customer User <-> Services' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Clients',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Clients <-> Groupes',
        'Data used to export the search result in CSV format.' => 'Données utilisées pour exporter les résultats de recherche dans le format CSV.',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => 'ACL par défaut pour les actions du ticket.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => 'ID de file par défaut utilisée par le système dans l\'interface opérateur.',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de ticket par défaut utilisé par le système dans l\'interface opérateur.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de ticket par défaut utilisé par le système dans l\'interface client.',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Défini un élément client qui génère un icone LinkedIn à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Défini un élément client qui génère un icone XING à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Défini un élément client qui génère un icone Google à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Défini un élément client qui génère un icone Google Maps à la fin du bloc d\'information client.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Défini une liste de mots ignorés par le correcteur orthographique.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => 'Défini tous les X-headers qui doivent être analysés',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
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
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
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
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
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
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
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
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum size (in MB) of the log file.' => '',
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
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
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
        'Defines the parameters for the customer preferences table.' => '',
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
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
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
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
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
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
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
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
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
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'Adresses E-mail',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
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
        'Escalation view' => 'Vue par remontées',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Execute SQL statements.' => 'Executer des requêtes SQL.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => 'Filtrer les e-mails entrants.',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => 'Langue de l\'interface',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Thème Interface',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'General ticket data shown in the dashboard widgets. Possible settings: 0 = Disabled, 1 = Enabled. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => 'Automate générique',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
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
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
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
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
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
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Langue de l\'interface',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Link agents to groups.' => 'Lier les opérateurs aux groupes',
        'Link agents to roles.' => 'Lier les opérateurs aux rôles',
        'Link attachments to templates.' => '',
        'Link customer user to groups.' => '',
        'Link customer user to services.' => '',
        'Link queues to auto responses.' => 'Lier les files aux réponses automatiques',
        'Link roles to groups.' => 'Lier les rôles aux groupes',
        'Link templates to queues.' => '',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'Fichier log pour le compteur de tickets.',
        'Mail Accounts' => 'Comptes de messagerie',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => 'Rendre l\'image transparente.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => 'Gérer les clés PGP pour le chiffrement des e-mails.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gérer les comptes POP3 ou IMAP où aller chercher les e-mails.',
        'Manage S/MIME certificates for email encryption.' => 'Gérer les certificats S/MIME pour le chiffrement des e-mails.',
        'Manage existing sessions.' => 'Gérer les sessions existantes.',
        'Manage notifications that are sent to agents.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
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
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
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
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Tickets' => 'Mes Tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Nouveau ticket par e-mail',
        'New phone ticket' => 'Nouveau ticket par téléphone',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Notification (Evenement)',
        'Number of displayed tickets' => 'Nombre de tickets affichés',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => 'Tickets ouverts du client',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Aperçu des tickets remontés',
        'Overview Refresh Time' => 'Aperçu du temps de rafraichissement',
        'Overview of all open Tickets.' => 'Aperçu de tous les tickets ouverts',
        'PGP Key Management' => '',
        'PGP Key Upload' => '',
        'Parameters for .' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
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
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => 'Envoyer une image',
        'PostMaster Filters' => 'Filtres Postmasters',
        'PostMaster Mail Accounts' => 'Comptes Mail PostMaster',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Vue Files',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => 'Rafraîchir les vues d\'ensemble après',
        'Refresh interval' => 'Intervalle d\'actualisation',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
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
        'Roles <-> Groups' => 'Rôles <-> Groupes',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Envoyer Certificat S/MIME',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search Customer' => 'Recherche de client',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Choix du thème de l\'interface',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '',
        'Send notifications to users.' => 'Envoyer des notifications aux clients',
        'Send ticket follow up notifications' => 'Envoyer des notifications de suivi de ticket',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => 'Mettre en place les adresses d\'envoi de messages électroniques pour ce système.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent.' => '',
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
        'Sets the default link type of splitted tickets in the agent interface.' =>
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
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
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
        'Sets the size of the statistic graph.' => '',
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
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
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
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
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
        'Skin' => 'Thème',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
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
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'Statistiques',
        'Status view' => 'Vue par état',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Templates <-> Queues' => '',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
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
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket Queue Overview' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Vue d\'ensemble du Ticket',
        'TicketNumber' => '',
        'Tickets' => 'Ticket',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Temps en secondes à ajouter à l\'heure actuelle dans le cas dans état en attente (défaut: 86400 = 1 jour)',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Déclenche l\'affichage de la liste des fonctions Add-ons dans les gestionnaire de paquet',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'Mettre à jour et améliorer OTRS via des paquets.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Voir les résultats du benchmark de performance.',
        'View system log messages.' => 'Voir les messages de log système',
        'Wear this frontend skin' => '',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Votre sélection de files préférées. Vous recevrez des notifications à propos de ces files par e-mail si activé.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Add Customer Company' => 'Ajouter un client au service',
        'Add Response' => 'Ajouter Réponse',
        'Add customer company' => 'Ajouter une entreprise cliente',
        'Add response' => 'Ajouter réponse',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Ajoute l\'adresse e-mail des clients en destinataire dans l\'écran de création de l\'interface opérateur.',
        'Attachments <-> Responses' => 'Pièces jointes <-> Réponses',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Impossible de mettre à jour le mot de passe, il doit contenir au moins 2 lettres en minuscule et 2 en majuscule!',
        'Change Queue Relations for Response' => 'Modifier les files pour la réponse',
        'Change Response Relations for Queue' => 'Modifier les réponses pour la file',
        'Create and manage companies.' => 'Créer et gérer les entreprises.',
        'Create and manage response templates.' => 'Créer et gérer les modèles de réponse.',
        'Currently only MySQL is supported in the web installer.' => 'Pour le moment, seul MySQL est supporté pour cet installateur web.',
        'Customer Company Management' => 'Gestion des services clients',
        'Customer Data' => 'Données client',
        'Customer automatically added in Cc.' => 'Client automatiquement ajouté dans Cc.',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Le client devra avoir un historique et se connecter via le panneau utilisateur',
        'Customers <-> Services' => 'Clients <-> Services',
        'Database-User' => 'Nom de l\'utilisateur de la base de donnée',
        'Default skin for interface.' => 'Habillage par défaut pour l\'interface.',
        'Edit Response' => 'Editer Réponse',
        'Escalation in' => 'Remontée dans',
        'False' => 'Faux',
        'Filter for Responses' => 'Filtre pour réponses',
        'For more info see:' => 'Pour plus d\'informations, allez à',
        'From customer' => 'Du client',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Si vous avez un mot de passe pour le compte root de votre base de données, il doit être saisi ici. Sinon, laissez ce champ vide. Pour des raisons de sécurité, nous vous recommandons de mettre un mot de passe pour le compte root. Pour plus d\'information, referez vous svp à la documentation de votre gestionnaire de base de données.',
        'Link attachments to responses templates.' => 'Lier pièces jointes aux modèles de réponse',
        'Link customers to groups.' => 'Lier les clients aux groupes',
        'Link customers to services.' => 'Lier les clients aux services',
        'Link responses to queues.' => 'Lier les réponses aux files',
        'Log file location is only needed for File-LogModule!' => 'L\'emplacement du fichier journal n\'est nécessaire que pour le module de journalisation fichier !',
        'Logout successful. Thank you for using OTRS!' => 'Déconnexion réussie. Merci d\'avoir utilisé OTRS !',
        'Manage Response-Queue Relations' => 'Gérer les relations entre les files et les réponses',
        'Manage Responses' => 'Gérer les Réponses',
        'Manage Responses <-> Attachments Relations' => 'Gérer Réponses <-> Relations pièce jointe',
        'Manage periodic tasks.' => 'Gérer les tâches périodiques.',
        'Package verification failed!' => 'Vérification du paquet échouée !',
        'Password is required.' => 'Mot de passe requis',
        'Please enter a search term to look for customer companies.' => 'Merci d\'entrer un motif de recherche pour chercher les entreprises clientes',
        'Please supply a' => 'Veuillez donner une',
        'Please supply a first name' => 'Veuillez fournir un prénom',
        'Please supply a last name' => 'Veuillez fournir un nom de famille',
        'Responses' => 'Réponses',
        'Responses <-> Queues' => 'Réponses <-> Files',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Le mode sécurisé doit être désactivé dans le but de réinstaller en utilisant le web-installer (installateur web)',
        'Show  article' => 'Afficher l\'article',
        'There are no further steps in this process' => 'Il n\'y a pas d\'autres étapes dans ce processus',
        'To customer' => 'Vers le client',
        'before' => 'avant',
        'default \'hot\'' => '\'hot\' par défaut',
        'settings' => 'Paramètres',

    };
    # $$STOP$$
    return;
}

1;
