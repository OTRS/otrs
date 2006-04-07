# Kernel/Language/fr.pm - provides fr language translation
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# Copyright (C) 2004-2005 Yann Richard <ze at nbox.org>
# Copyright (C) 2004 Igor Genibel <igor.genibel at eds-opensource.com>
# --
# $Id: fr.pm,v 1.50.2.3 2006-04-07 12:16:59 cs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fr;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.50.2.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:14:19 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'Oui',
      'No' => 'Non',
      'yes' => 'oui',
      'no' => 'non',
      'Off' => 'Éteint',
      'off' => 'éteint',
      'On' => 'Allumé',
      'on' => 'allumé',
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
      'wrote' => 'écrit',
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
      'none - answered' => 'aucun - répondu',
      'please do not edit!' => 'Ne pas modifier !',
      'AddLink' => 'Ajouter un lien',
      'Link' => 'Lien',
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
      'Salutation' => '',
      'Signature' => 'Signature',
      'Customer' => 'Client',
      'CustomerID' => 'Numéro de client',
      'CustomerIDs' => 'Numéro de client (Groupe)',
      'customer' => 'client',
      'agent' => 'technicien',
      'system' => 'système',
      'Customer Info' => 'Information client',
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
      'Created by' => 'Crée par',
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
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Il faut répondre à ce(s) ticket(s) pour revenir à une vue normale de la file !',
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
      'Welcome to %s' => 'Bienvenue dans %s',
      'There is no account with that login name.' => 'Il n\'y a aucun compte avec ce nom de connexion',
      'Login failed! Your username or password was entered incorrectly.' => 'La connection a échoué ! Votre nom d\'utilisateur ou votre mot de passe sont erronés.',
      'Please contact your admin' => 'Veuillez contacter votre admnistrateur',
      'Logout successful. Thank you for using OTRS!' => 'Déconnexion réussie. Merci d\'avoir utilisé OTRS!',
      'Invalid SessionID!' => 'ID de Session Invalide !',
      'Feature not active!' => 'Cette fonctionnalité n\'est pas activée !',
      'Take this Customer' => 'Choisir ce client',
      'Take this User' => 'Choisir cet utilisateur',
      'possible' => 'possible',
      'reject' => 'rejeté',
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
      'Added User "%s"' => 'Ajout de l\'utilisateur "%s"',
      'Contract' => 'Contrat',
      'Online Customer: %s' => 'Clients en ligne: %s',
      'Online Agent: %s' => 'Agents en ligne: %s',
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

      # Template: AAAMonth
      'Jan' => 'Jan',
      'Feb' => 'Fév',
      'Mar' => 'Mar',
      'Apr' => 'Avr',
      'May' => 'Mai',
      'Jun' => 'Juin',
      'Jul' => 'Juil',
      'Aug' => 'Aôu',
      'Sep' => 'Sep',
      'Oct' => 'Oct',
      'Nov' => 'Nov',
      'Dec' => 'Déc',

      # Template: AAANavBar
      'Admin-Area' => 'Zone d\'administration',
      'Agent-Area' => 'Interface du technicien',
      'Ticket-Area' => 'Tickets',
      'Logout' => 'Déconnexion',
      'Agent Preferences' => 'Préférences de l\'Agent',
      'Preferences' => 'Préférences',
      'Agent Mailbox' => 'Boite e-mail de l\'Agent',
      'Stats' => 'Statistiques',
      'Stats-Area' => 'Statistiques',
      'FAQ-Area' => 'Foire Aux Questions',
      'FAQ' => 'FAQ',
      'FAQ-Search' => '(FAQ) Rechercher',
      'FAQ-Article' => '(FAQ) Article',
      'New Article' => 'Nouvel Article',
      'FAQ-State' => '(FAQ) État',
      'Admin' => 'Administrateur',
      'A web calendar' => 'Un calendrier Web',
      'WebMail' => 'Webmail',
      'A web mail client' => 'Un logiciel de messagerie via le web',
      'FileManager' => 'Gestionnaire de fichiers',
      'A web file manager' => 'Un gestionnaire de fichier via le web',
      'Artefact' => '',
      'Incident' => 'Incident',
      'Advisory' => 'Avertissement',
      'WebWatcher' => '',
      'Customer Users' => 'Clients',
      'Customer Users <-> Groups' => 'Clients <-> Groupes',
      'Users <-> Groups' => 'Agent <-> Groupes',
      'Roles' => 'Rôles',
      'Roles <-> Users' => 'Rôles <-> Agents',
      'Roles <-> Groups' => 'Rôles <-> Groupes',
      'Salutations' => 'Salutations',
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
      'Password is needed!' => 'Le mot de passe est requis !',

      # Template: AAATicket
      'Lock' => 'Vérrouiller',
      'Unlock' => 'Déverrouiller',
      'History' => 'Historique',
      'Zoom' => 'Détails',
      'Age' => 'Âge',
      'Bounce' => 'Renvoyer',
      'Forward' => 'Transmettre',
      'From' => 'De ',
      'To' => 'À',
      'Cc' => 'Copie ',
      'Bcc' => 'Copie Invisible',
      'Subject' => 'Sujet',
      'Move' => 'Déplacer',
      'Queue' => 'File',
      'Priority' => 'Priorité',
      'State' => 'État',
      'Compose' => 'Composer',
      'Pending' => 'En attente',
      'Owner' => 'Propriétaire',
      'Owner Update' => '',
      'Sender' => 'émetteur',
      'Article' => 'Article',
      'Ticket' => 'Ticket',
      'Createtime' => 'Création du ',
      'plain' => 'tel quel',
      'email' => 'courriel',
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
      'closed successful' => 'clôture réussie',
      'closed unsuccessful' => 'clôture manquée',
      'new' => 'nouveau',
      'open' => 'ouvrir',
      'closed' => 'fermer',
      'removed' => 'supprimé',
      'pending reminder' => 'Attente du rappel',
      'pending auto close+' => 'Attente de la fermeture automatique(+)',
      'pending auto close-' => 'Attente de la fermeture automatique(-)',
      'email-external' => 'message externe',
      'email-internal' => 'message interne',
      'note-external' => 'Note externe',
      'note-internal' => 'Note interne',
      'note-report' => 'Note rapport',
      'phone' => 'téléphone',
      'sms' => 'sms',
      'webrequest' => 'Requête par le web',
      'lock' => 'vérrouiller',
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
      'Don\'t show closed Tickets' => 'Ne pas montrer les tickets fermés',
      'Show closed Tickets' => 'Voir les tickets fermés',
      'Email-Ticket' => 'Écrire un e-mail',
      'Create new Email Ticket' => 'Créer un nouveau ticket en envoyant un e-mail',
      'Phone-Ticket' => 'Vue téléphone',
      'Create new Phone Ticket' => 'Saisie d\'une demande téléphonique',
      'Search Tickets' => 'Recherche de tickets',
      'Edit Customer Users' => 'Editer clients',
      'Bulk-Action' => 'Action groupé',
      'Bulk Actions on Tickets' => 'Action groupés sur les tickets',
      'Send Email and create a new Ticket' => 'Envoyer un courriel et créer un nouveau Ticket',
      'Overview of all open Tickets' => 'Vue de tout les Tickets',
      'Locked Tickets' => 'Tickets vérrouillés',
      'Lock it to work on it!' => 'Vérouillez le pour travailler dessus!',
      'Unlock to give it back to the queue!' => 'Dévérrouiller pour qu\'il retourne dans sa file!',
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
      'Mark as Spam!' => 'Signaler comme Spam!',
      'My Queues' => 'Mes files',
      'Shown Tickets' => 'Tickets affichés',
      'New ticket notification' => 'Notification de nouveau ticket',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Me prévenir si il y a un nouveau ticket dans une de "Mes files".',
      'Follow up notification' => 'Notification de suivi',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Me prévenir si un client envoie un suivi (follow-up) et que je suis le propriétaire du ticket.',
      'Ticket lock timeout notification' => 'Prévenir du dépassement du délai d\'un verrou',
      'Send me a notification if a ticket is unlocked by the system.' => 'Me prévenir si un ticket est dévérouillé par le système',
      'Move notification' => 'Notification de mouvement',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Me prévenir si un ticket est déplacé dans une de "Mes files".',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => 'File d\'attente personnalisé',
      'QueueView refresh time' => 'Temps de rafraîchissement de la vue des files',
      'Screen after new ticket' => 'Écran après un nouveau ticket',
      'Select your screen after creating a new ticket.' => 'Sélectionnez l\'écran qui sera affiché après avoir créé un nouveau ticket.',
      'Closed Tickets' => 'Tickets fermés',
      'Show closed tickets.' => 'Voir les tickets fermés',
      'Max. shown Tickets a page in QueueView.' => 'Nombre de tickets maximum sur la page de la vue d\'une file',
      'Responses' => 'Réponses',
      'Responses <-> Queue' => 'Réponses <-> Files',
      'Auto Responses' => 'Réponses automatiques',
      'Auto Responses <-> Queue' => 'Réponses automatiques <-> Files',
      'Attachments <-> Responses' => 'Pièces jointes <-> Réponses',
      'History::Move' => 'Le ticket a été déplacé dans la file "%s" (%s) - Ancienne file: "%s" (%s).',
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
      'History::PhoneCallAgent' => 'Agent a appellé le client.',
      'History::PhoneCallCustomer' => 'Le client nous a appellé.',
      'History::AddNote' => 'Ajout d\'une note (%s)',
      'History::Lock' => 'Ticket vérouillé.',
      'History::Unlock' => 'Ticket dévérouillé.',
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

      # Template: AAAWeekDay
      'Sun' => 'Dim',
      'Mon' => 'Lun',
      'Tue' => 'Mar',
      'Wed' => 'Mer',
      'Thu' => 'Jeu',
      'Fri' => 'Ven',
      'Sat' => 'Sam',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Gestion des attachements',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Gestion des réponses automatiques',
      'Response' => 'Réponse',
      'Auto Response From' => 'Réponse automatique de ',
      'Note' => 'Note',
      'Useable options' => 'Options accessibles',
      'to get the first 20 character of the subject' => 'pour avoir les 20 premiers caractères du sujet ',
      'to get the first 5 lines of the email' => 'pour avoir les 5 premières ligne du mail',
      'to get the from line of the email' => 'pour avoir les lignes \'De\' du courriel',
      'to get the realname of the sender (if given)' => 'pour avoir le nom réel de l\'utilisateur (s\il est donné)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Le message en cours de rédaction a été clôturé. Sortie.',
      'This window must be called from compose window' => 'Cette fenêtre doit être appelée de la fenêtre depuis la fenêtre de rédaction',
      'Customer User Management' => 'Gestion des clients utilisateurs',
      'Search for' => 'Chercher à',
      'Result' => 'Résultat',
      'Select Source (for add)' => 'Sélectionnez une source (pour ajout)',
      'Source' => 'Source',
      'This values are read only.' => 'Ces valeurs sont en lecture seule.',
      'This values are required.' => 'Ces valeurs sont obligatoires.',
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

      # Template: AdminEmail
      'Message sent to' => 'Message envoyé à',
      'Recipents' => 'Récipients',
      'Body' => 'Corps',
      'send' => 'envoyer',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
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
      'Agent' => 'Technicien',
      'TicketFreeText' => 'Texte Libre du Ticket',
      'Ticket Lock' => 'Ticket vérouillé',
      'Times' => 'Fois',
      'No time settings.' => 'Pas de paramètre de temps',
      'Ticket created' => 'Ticket créé',
      'Ticket created between' => 'Ticket créé entre le',
      'New Priority' => 'Nouvelle Priorité',
      'New Queue' => 'Nouvelle File',
      'New State' => 'Nouvel État',
      'New Agent' => 'Nouvel Agent',
      'New Owner' => 'Nouveau Propriétaire',
      'New Customer' => 'Nouveau Client',
      'New Ticket Lock' => 'Nouveau Verrou',
      'CustomerUser' => 'Client utilisateur',
      'Add Note' => 'Ajouter une note',
      'CMD' => 'CMD',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Cette commande sera exécuté. ARG[0] sera le numéro du ticket et ARG[1] son identifiant.',
      'Delete tickets' => 'Effacer les tickets',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Attention, ces tickets seront éffacés de la base de donnée ! Ils seront définitivement perdu !',
      'Modules' => 'Modules',
      'Param 1' => 'Paramètre 1',
      'Param 2' => 'Paramètre 2',
      'Param 3' => 'Paramètre 3',
      'Param 4' => 'Paramètre 4',
      'Param 5' => 'Paramètre 5',
      'Param 6' => 'Paramètre 6',
      'Save' => 'Sauver',

      # Template: AdminGroupForm
      'Group Management' => 'Administration des groupes',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Créer de nouveaux groupes permettra de gérer les droits d\'accès pour les différents groupes du technicien (exemple: achats, comptabilité, support, ventes...).',
      'It\'s useful for ASP solutions.' => 'C\'est utile pour les fournisseurs d\'applications.',

      # Template: AdminLog
      'System Log' => 'Journaux du Système',
      'Time' => 'Date et heure',

      # Template: AdminNavigationBar
      'Users' => 'Utilisateurs',
      'Groups' => 'Groupes',
      'Misc' => 'Divers',

      # Template: AdminNotificationForm
      'Notification Management' => 'Gestion des notifications',
      'Notification' => 'Notification',
      'Notifications are sent to an agent or a customer.' => 'Des notifications sont envoyées à un technicien ou à un client.',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Options de configuration (ex: &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Options du propriétaire d\'un ticket (ex: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Options concernant l\'utilisateur actuel ayant effectué cet action (ex: &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Options concernant les données du client actuel (ex: &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',

      # Template: AdminPackageManager
      'Package Manager' => 'Gestionnaire de paquet',
      'Uninstall' => 'Déinstallation',
      'Verion' => 'Version',
      'Do you really want to uninstall this package?' => 'Voulez-vous vraiment déinstaller ce paquet ?',
      'Install' => 'Installation',
      'Package' => 'Paquet',
      'Online Repository' => 'Dépot en ligne',
      'Version' => 'Version',
      'Vendor' => 'Vendeur',
      'Upgrade' => 'Mise à jour',
      'Local Repository' => '',
      'Status' => 'État',
      'Overview' => 'Aperçu',
      'Download' => 'Téléchargement',
      'Rebuild' => 'Re-construction',
      'Reinstall' => 'Ré-installation',

      # Template: AdminPGPForm
      'PGP Management' => 'Gestion de PGP',
      'Identifier' => 'Identifiant',
      'Bit' => '',
      'Key' => 'Clé',
      'Fingerprint' => 'Empreinte',
      'Expires' => 'Expiration',
      'In this way you can directly edit the keyring configured in SysConfig.' => 'Dans ce cas vous pouvez directement éditer le trousseau configuré dans SysConfig.',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'Gestion du compte POP3',
      'Host' => 'Hôte',
      'Trusted' => 'Vérifié',
      'Dispatching' => 'Répartition',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Tous les courriels entrants avec un compte seront répartis dans la file sélectionnée !',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Si votre compte est vérifié, les ent&ecirc;tes x-otrs (pour les priorités,...) seront utilisés !',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => 'Gestion des filtres PostMaster',
      'Filtername' => 'Nom du filtre',
      'Match' => 'Correspond',
      'Header' => 'En-tête',
      'Value' => 'Valeur',
      'Set' => 'Assigner',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'dispatcher ou filtrer les courriels entrant basé sur les en-têtes (X-*)! L\'utilisationd\'expression régulière est aussi possible.',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Files <-> Gestion des réponses automatiques',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Gestion des files',
      'Sub-Queue of' => 'Sous-file',
      'Unlock timeout' => 'Délai du déverrouillage',
      '0 = no unlock' => '0 = pas de vérouillage',
      'Escalation time' => 'Délai de remonté du ticket',
      '0 = no escalation' => '0 = pas de remonté du ticket',
      'Follow up Option' => 'Option des suivis',
      'Ticket lock after a follow up' => 'Ticket verrouillé aprés un suivi',
      'Systemaddress' => 'Adresse du Système',
      'Customer Move Notify' => 'Notification lors d\'un changement de file',
      'Customer State Notify' => 'Notification lors d\'un changement d\'état',
      'Customer Owner Notify' => 'Notification lors d\'un changement de propriétaire',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Si un technicien verrouille un ticket et qu\'il/elle n\'envoie pas une réponse dans le temps imparti, le ticket sera déverrouillé automatiquement. Le ticket sera alors visible de tous les autres techniciens',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Si un ticket n\'est pas répondu dans le temps imparti, ce ticket sera seulement affiché',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Si un ticket est cloturé et que le client envoie une note, le ticket sera verrouillé pour l\'ancien propriétaire',
      'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expédition pour les réponses par courriel.',
      'The salutation for email answers.' => 'La formule de politesse pour les réponses par mail',
      'The signature for email answers.' => 'La signature pour les réponses par courriel',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS envoit un courriel au client ilorsque le ticket change de file.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS envoit un courriel au client lorsque le ticket change d\'état.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS envoit un courriel au client lorsque le ticket change de propriétaire.',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => 'Réponses <-> Gestion des files',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Réponse',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => 'Réponses <-> Gestion des pièces jointes',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Gestion des réponses',
      'A response is default text to write faster answer (with default text) to customers.' => 'Une réponse est un texte par défaut destiné à rédiger plus rapidement des réponses standard aux clients.',
      'Don\'t forget to add a new response a queue!' => 'Ne pas oublier d\'ajouter une file à une nouvelle réponse !',
      'Next state' => 'État suivant',
      'All Customer variables like defined in config option CustomerUser.' => 'Toutes les variables client tels que définies dans les options "Client utilisateur"',
      'The current ticket state is' => 'L\'état actuel du ticket est',
      'Your email address is new' => 'Votre adresse électronique est nouvelle',

      # Template: AdminRoleForm
      'Role Management' => 'Gestion des Rôles',
      'Create a role and put groups in it. Then add the role to the users.' => 'Créer un rôle et ',
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
      'Active' => 'Actif',
      'Select the role:user relations.' => 'Sélection des relations role/utilisateur',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Préfixes des messages',
      'customer realname' => 'nom réel du client',
      'for agent firstname' => 'pour le prénom du technicien',
      'for agent lastname' => 'pour le nom du technicien',
      'for agent user id' => 'pour l\'identifiant du technicien',
      'for agent login' => 'pour le nom de connexion (login) du technicien',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Requête SQL libre.',
      'SQL' => 'SQL',
      'Limit' => 'Limite',
      'Select Box Result' => 'Choisissez le résultat',

      # Template: AdminSession
      'Session Management' => 'Gestion des sessions',
      'Sessions' => 'Sessions',
      'Uniq' => 'Unique',
      'kill all sessions' => 'Terminer toutes les sessions',
      'Session' => 'Session',
      'kill session' => 'Terminer une session',

      # Template: AdminSignatureForm
      'Signature Management' => 'Gestion des signatures',

      # Template: AdminSMIMEForm
      'SMIME Management' => 'Gestion SMIME',
      'Add Certificate' => 'Ajouter un certificat',
      'Add Private Key' => 'Ajouter une clé privée',
      'Secret' => 'Secrêt',
      'Hash' => 'Hashage',
      'In this way you can directly edit the certification and private keys in file system.' => 'Dans ce cas vous pouvez directement éditer le certificat et la clé privée dans le système de fichier',

      # Template: AdminStateForm
      'System State Management' => 'Gestion des états du système',
      'State Type' => 'Type d\'état',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Prennez garde de bien mettre à jour les états par défaut dans votre Kernel/Config.pm !',
      'See also' => 'Voir aussi',

      # Template: AdminSysConfig
      'SysConfig' => 'Configuration Système',
      'Group selection' => 'Sélection du groupe',
      'Show' => 'Voir',
      'Download Settings' => 'Paramettres de téléchargement',
      'Download all system config changes.' => 'Télécharger tout les changements de la configuration système.',
      'Load Settings' => 'Charger les parramettres',
      'Subgroup' => 'Sous-groupe',
      'Elements' => 'Élements',

      # Template: AdminSysConfigEdit
      'Config Options' => 'Options de configuration',
      'Default' => 'Défaut',
      'Content' => 'Contenu',
      'New' => 'Nouveau',
      'New Group' => 'Nouveau groupe',
      'Group Ro' => 'Groupe lecture seule',
      'New Group Ro' => 'Nouveau groupe (lecture seule)',
      'NavBarName' => 'Nom de la barre de navigation',
      'Image' => 'Image',
      'Prio' => 'Priorité',
      'Block' => 'Bloc',
      'NavBar' => 'Barre de navigation',
      'AccessKey' => 'Accès clavier',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Gestion des adresses courriel du système',
      'Email' => 'Courrier électronique',
      'Realname' => 'Véritable Nom',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Tous les courriels avec cette adresse en destinataire (À:) seront répartis dans la file sélectionnée !',

      # Template: AdminUserForm
      'User Management' => 'Administration des utilisateurs',
      'Firstname' => 'Prénom',
      'Lastname' => 'Nom',
      'User will be needed to handle tickets.' => 'Un utilisateur sera nécessaire pour gérer les tickets.',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

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
      'Link Object' => '',
      'Select' => 'Sélectionner',
      'Results' => 'Résultat',
      'Total hits' => 'Total des hits',
      'Site' => 'Site',
      'Detail' => 'Détail',

      # Template: AgentLookup
      'Lookup' => 'Consulter',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => 'Ticket sélectionné pour une action groupé!',
      'You need min. one selected Ticket!' => 'Vous devez nommer au moins un Ticket!',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Vérificateur orthographique',
      'spelling error(s)' => 'erreurs d\'orthographe',
      'or' => 'ou',
      'Apply these changes' => 'Appliquer ces changements',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Un message doit avoir un destinataire (À:)!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Il faut une adresse courriel (ex&nbsp;: client@exemple.fr)&nbsp;!',
      'Bounce ticket' => 'Renvoyer le ticket',
      'Bounce to' => 'Renvoyer à',
      'Next ticket state' => 'Prochain état du ticket',
      'Inform sender' => 'Informer l\'emetteur',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Votre message concernant le ticket numéro "<OTRS_TICKET> est réémis à "<OTRS_BOUNCE_TO>". Contactez cette adresse pour de plus amples renseignements',
      'Send mail!' => 'Envoyer le courriel !',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Un message doit avoir un sujet !',
      'Ticket Bulk Action' => 'Ticket en action groupé',
      'Spell Check' => 'Vérification orthographique',
      'Note type' => 'Type de note',
      'Unlock Tickets' => 'Dévérouiller Tickets',

      # Template: AgentTicketClose
      'A message should have a body!' => 'Un message doit avoir un corp !',
      'You need to account time!' => 'Vous devez avoir un compte de temps&nbsp;!',
      'Close ticket' => 'Ticket clos',
      'Note Text' => 'Note',
      'Close type' => 'Type de clôture',
      'Time units' => 'Unité de temps',
      ' (work units)' => ' Unité de travail',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'Lorthographe dun message doit être vérifié!',
      'Compose answer for ticket' => 'Rédiger une réponse pour le ticket',
      'Attach' => 'Attaché',
      'Pending Date' => 'En attendant la date',
      'for pending* states' => 'pour tous les états d\'attente',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Changer le client du ticket',
      'Set customer user and customer id of a ticket' => 'Assigner un utilisateur client et un identifiant client pour le ticket.',
      'Customer User' => 'Client Utilisateur',
      'Search Customer' => 'Recherche de client',
      'Customer Data' => 'Données client',
      'Customer history' => 'Historique du client',
      'All customer tickets.' => 'Tout les tickets du client',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Note',

      # Template: AgentTicketEmail
      'Compose Email' => 'Écrire un courriel',
      'new ticket' => 'nouveau ticket',
      'Clear To' => 'Effacer la zone de saisie "De:"',
      'All Agents' => 'Tous les techniciens',
      'Termin1' => 'Termin1',

      # Template: AgentTicketForward
      'Article type' => 'Type d\'article',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Changer le texte libre du ticket',

      # Template: AgentTicketHistory
      'History of' => 'Historique de',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket verrouillé !',
      'Ticket unlock!' => 'Rendre le ticket !',

      # Template: AgentTicketMailbox
      'Mailbox' => 'Bo&icirc;te aux lettres',
      'Tickets' => '',
      'All messages' => 'Tous les messages',
      'New messages' => 'Nouveaux messages',
      'Pending messages' => 'Message en attente',
      'Reminder messages' => 'Message de rappel',
      'Reminder' => 'Rappel',
      'Sort by' => 'Trier par',
      'Order' => 'Ordre',
      'up' => 'vers le haut',
      'down' => 'vers le bas',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => 'Vous devez utiliser un numéro de ticket!',
      'Ticket Merge' => 'Fusion de Ticket',
      'Merge to' => 'Fusionner avec',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Votre ticket numéro "<OTRS_TICKET>" a été fusionné avec le ticket numéro "<OTRS_MERGE_TO_TICKET>".',

      # Template: AgentTicketMove
      'Queue ID' => 'Identifiant de la File',
      'Move Ticket' => 'Changer la file du ticket',
      'Previous Owner' => 'Propriétaire Précédent',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Ajouter une note au ticket',
      'Inform Agent' => 'Informer l\'agent',
      'Optional' => 'Optionnel',
      'Inform involved Agents' => 'Informer les agents impliqués',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Changer le propriétaire du ticket',
      'Message for new Owner' => 'Message pour le nouveau propriétaire',

      # Template: AgentTicketPending
      'Set Pending' => 'Définir l\'attente',
      'Pending type' => 'Type d\'attente',
      'Pending date' => 'Délais d\'attente',

      # Template: AgentTicketPhone
      'Phone call' => 'Appel téléphonique',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'Vider le formulaire',

      # Template: AgentTicketPlain
      'Plain' => 'Tel quel',
      'TicketID' => 'Identifiant du Ticket',
      'ArticleID' => 'Identifiant de l\'Article',

      # Template: AgentTicketPrint
      'Ticket-Info' => 'Information du Ticket',
      'Accounted time' => 'Temp passé',
      'Escalation in' => 'Remontée dans',
      'Linked-Object' => 'Objet lié',
      'Parent-Object' => 'Objet Parent',
      'Child-Object' => 'Objet Enfant',
      'by' => 'par',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Modification de la priorité du ticket',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Tickets affichés',
      'Page' => 'Page',
      'Tickets available' => 'Tickets disponibles',
      'All tickets' => 'tous les tickets',
      'Queues' => 'Files',
      'Ticket escalation!' => 'Remontée du ticket !',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Votre propre ticket',
      'Compose Follow up' => 'Fermer le suivi',
      'Compose Answer' => 'Rédiger une réponse',
      'Contact customer' => 'Contacter le client',
      'Change queue' => 'Changer de file',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'Recherche de ticket',
      'Profile' => 'Profil',
      'Search-Template' => 'Profil de recherche',
      'Created in Queue' => 'Créé dans la file',
      'Result Form' => 'Format du résultat',
      'Save Search-Profile as Template?' => 'Sauver le profil de recherche ?',
      'Yes, save it with name' => 'Oui, le sauver avec le nom',
      'Customer history search' => 'Recherche dans l\'historique client',
      'Customer history search (e. g. "ID342425").' => 'Recherche dans l\'historique client (ex: "ID342425")',
      'No * possible!' => 'Pas de * possible !',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Résultat de la recherche',
      'Change search options' => 'Changer les options de recherche',

      # Template: AgentTicketSearchResultPrint
      '"}' => '"}',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'Tri croissant',
      'U' => 'A-Z',
      'sort downward' => 'Tri décroissant',
      'D' => 'Z-A',

      # Template: AgentTicketStatusView
      'Ticket Status View' => 'Vue de l\'état du ticket',
      'Open Tickets' => 'Tickets ouverts',

      # Template: AgentTicketZoom
      'Split' => 'Scinder',

      # Template: AgentTicketZoomStatus
      'Locked' => 'Vérrouillé',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => 'Trace du retour d\'erreur',

      # Template: CustomerFAQ
      'Print' => 'Imprimer',
      'Keywords' => 'Mots clés',
      'Symptom' => 'Symptôme',
      'Problem' => 'Problème',
      'Solution' => 'Solution',
      'Modified' => 'Modifié',
      'Last update' => 'Dernière mise à jour',
      'FAQ System History' => 'Historique système de la FAQ',
      'modified' => 'modifié',
      'FAQ Search' => 'Chercher dans la FAQ',
      'Fulltext' => 'Texte Complet',
      'Keyword' => 'Mot clé',
      'FAQ Search Result' => 'Résultat de la recherche dans la FAQ',
      'FAQ Overview' => 'Vue d\'ensemble de la FAQ',

      # Template: CustomerFooter
      'Powered by' => 'Fonction assurée par',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => 'S\'authentifier',
      'Lost your password?' => 'Mot de passe perdu ?',
      'Request new password' => 'Demande de nouveau mot de passe',
      'Create Account' => 'Créer un compte',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Bienvenue %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => 'de',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Cliquer ici pour signaler une anomalie !',

      # Template: FAQ
      'Comment (internal)' => 'Commentaire interne',
      'A article should have a title!' => 'Un article doit avoir un titre',
      'New FAQ Article' => '(FAQ) Nouvel article',
      'Do you really want to delete this Object?' => 'Voulez vous vraiment effacer cet objet ?',
      'System History' => 'Historique du système',

      # Template: FAQCategoryForm
      'Name is required!' => 'Un nom est requis!',
      'FAQ Category' => 'Catégorie dans la FAQ',

      # Template: FAQLanguageForm
      'FAQ Language' => 'Langue dans la FAQ',

      # Template: Footer
      'QueueView' => 'Vue file',
      'PhoneView' => 'Vue téléphone',
      'Top of Page' => 'Haut de page',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Accueil',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Installeur Web',
      'accept license' => 'Accepter la licence',
      'don\'t accept license' => 'Ne pas accepter la licence',
      'Admin-User' => 'Administrateur',
      'Admin-Password' => 'Mot de passe de l\'administrateur',
      'your MySQL DB should have a root password! Default is empty!' => 'Votre base MySQL doit avoir un mot de passe root ! Par défaut cela est vide !',
      'Database-User' => 'Nom de l\'utilisateur de la base de donnée',
      'default \'hot\'' => 'hôte par défaut',
      'DB connect host' => 'Nom d\'hôte de la base de donnée',
      'Database' => 'Base de donnée',
      'Create' => 'Création',
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
      'Default Charset' => 'Charset par défaut',
      'Use utf-8 it your database supports it!' => 'Utilisez UTF-8 si votre base de donnée le supporte !',
      'Default Language' => 'Langage par défaut ',
      '(Used default language)' => '(Langage par défaut utilisé)',
      'CheckMXRecord' => 'Vérifier les enregistrements MX',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Verifie les enregistrements MX des adresses électroniques utilisées lors de la rédaction d\'une réponse. N\'utilisez pas la "Vérification des enregistrements MX" si votre serveur OTRS est derrière une ligne modem $!',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Pour pouvoir utiliser OTRS, vous devez entrer les commandes suivantes dans votre terminal en tant que root.',
      'Restart your webserver' => 'Redémarrer votre serveur web',
      'After doing so your OTRS is up and running.' => 'Après avoir fait ceci votre OTRS est en service',
      'Start page' => 'Page de démarrage',
      'Have a lot of fun!' => 'Amusez vous bien !',
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

      # Template: SystemStats
      'Format' => 'Format',

      # Template: Test
      'OTRS Test Page' => 'Page de test d\'OTRS',
      'Counter' => 'Compteur',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => 'Hôte de la base OTRS',
      'Create Database' => 'Créer la base de données',
      'DB Host' => 'Nom d\'hôte de la base',
      'Change roles <-> groups settings' => 'Changer les rôles <-> paramèttres des groupes',
      'Ticket Number Generator' => 'Générateur de numéro pour les tickets',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identifiiant des tickets. Certaines personnes veulent le configurer avec par ex: \'Ticket#\', \'Appel#\' ou \'MonTicket#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Dans ce cas vous pouvez directement éditer le trousseau de clé dans Kernel/Config.pm',
      'Change users <-> roles settings' => 'Changement d\'utilisateur <-> parramèttres des rôles',
      'Close!' => 'Clôture!',
      'Subgroup' => 'Sous-groupe',
      'TicketZoom' => 'Vue en détails',
      'Don\'t forget to add a new user to groups!' => 'Ne pas oublier d\'ajouter un nouvel utilisateur aux groupes !',
      'License' => 'Licence',
      'CreateTicket' => 'Créer Ticket',
      'OTRS DB Name' => 'Nom de la base OTRS',
      'System Settings' => 'Paramètres Système',
      'Hours' => 'Heures',
      'Finished' => 'Fini',
      'Days' => 'Jours',
      'DB Admin User' => 'nom de connexion de l\'administrateur base de donnée',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
      'Change user <-> group settings' => 'Modifier les paramètres utilisateurs <-> groupes',
      'DB Type' => 'Type de SGBD',
      'next step' => 'étape suivante',
      'Admin-Email' => 'Email de l\'administrateur',
      'Create new database' => 'Créer une nouvelle base de données',
      'Delete old database' => 'Effacer l\'ancienne base de données',
      'OTRS DB User' => 'Utilisateur de la base OTRS',
      'Options ' => 'Options',
      'OTRS DB Password' => 'Mot de passe de la base OTRS',
      'DB Admin Password' => 'Mot de passe administrateur base de données',
      'Drop Database' => 'Effacer la base de données',
      '(Used ticket number format)' => '(Format numérique utilisé pour les tickets)',
      'FAQ History' => 'Historique de la FAQ',
      'Package not correctly deployed, you need to deploy it again!' => '',
      'Customer called' => 'Client appellé',
      'Phone' => 'Téléphone',
      'Office' => 'Bureau',
      'CompanyTickets' => '',
      'MyTickets' => 'Mes tickets',
      'New Ticket' => 'Nouveau ticket',
      'Create new Ticket' => 'Création d\'un nouveau ticket',
      'installed' => 'installé',
      'uninstalled' => 'désinstallé',
    };
    # $$STOP$$
}
# --
1;
