# --
# Kernel/Language/French.pm - provides french language translations
# Copyright (C) 2002 Martin Scherbaum <maddin@exsuse.de>
# --
# $Id: French.pm,v 1.2 2002-07-18 23:30:58 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::French;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # some common words
    $Self->{Lock} = 'Tirer';
    $Self->{Unlock} = 'Rendre';
    $Self->{unlock} = 'rendre';
    $Self->{Zoom} = 'Contenu';
    $Self->{History} = 'Histoire';
    $Self->{'Add Note'} = 'Ajouter commentaire';
    $Self->{Bounce} = 'Bounce';
    $Self->{Age} = 'Age';
    $Self->{Priority} = 'Priorité';
    $Self->{State} = 'Status';
    $Self->{From} = 'De';
    $Self->{To} = 'Pour';
    $Self->{Cc} = 'Cc';
    $Self->{Subject} = 'Sujet';
    $Self->{Move} = 'Mouvoir';
    $Self->{Queues} = 'Queues';
    $Self->{Close} = 'Fermer';
    $Self->{Compose} = 'Creer';
    $Self->{Pending} = 'Attendre';
    $Self->{end} = 'Fin';
    $Self->{top} = 'Début';
    $Self->{day} = 'jour';
    $Self->{days} = 'jours';
    $Self->{hour} = 'heure';
    $Self->{hours} = 'heures';
    $Self->{minute} = 'minute';
    $Self->{minutes} = 'minutes';
    $Self->{Owner} = 'Propriétaire';
    $Self->{Sender} = 'Envoyeur';
    $Self->{Article} = 'Article';
    $Self->{Ticket} = 'Ticket';
    $Self->{Createtime} = 'Créé le';
    $Self->{Created} = 'Créé';
    $Self->{View} = 'Vue';
    $Self->{Action} = 'Action';
    $Self->{User} = 'Utilisateur';
    $Self->{Back} = 'retourner';
    $Self->{store} = 'sauvegarder';
    $Self->{currently} = 'courrant';
    $Self->{Customer} = 'Client';
    $Self->{'Customer info'} = 'Info client';
    $Self->{'Set customer id of a ticket'} = 'Assigner ID client pour un ticket';
    $Self->{'All tickets of this customer'} = 'Tous tickets de ce client';
    $Self->{'New CustomerID'} = 'ID client nouveau';
    $Self->{'for ticket'} = 'pour ticket';
    $Self->{'Start work'} = 'Début de travail';
    $Self->{'Stop work'} = 'Fin de travail';
    $Self->{'CustomerID'} = 'ID client';
    $Self->{'Compose Answer'} = 'Composer une réponse';
    $Self->{'Change queue'} = 'Changer de queue';
    $Self->{'go!'} = 'allez!';
    $Self->{'update!'} = 'actualiser!';
    $Self->{'submit!'} = 'envoyer!';
    $Self->{'change!'} = 'changer!';
    $Self->{'change'} = 'changer';
    $Self->{'Comment'} = 'Commentaire';
    $Self->{'Valid'} = 'Valid';
    $Self->{'Forward'} = 'Rediriger';
    $Self->{'Name'} = 'Nom';
    $Self->{'Group'} = 'Equipe';
    $Self->{'Response'} = 'Réponse';
    $Self->{'none!'} = 'aucun!';
    $Self->{'German'} = 'Allemand';
    $Self->{'English'} = 'Anglais';
    $Self->{'French'} = 'Français';
    $Self->{'Lite'} = 'Simple';
    # admin area
    $Self->{'Firstname'} = 'Prénom';
    $Self->{'Lastname'} = 'Nom';
    $Self->{'Add User'} = 'Ajouter utilisateur';
    $Self->{'Languages'} = 'Langues';
    $Self->{'Language'} = 'Langue';
    $Self->{'Salutation'} = 'Salutation';
    $Self->{'Signature'} = 'Signature';
    $Self->{'Standart Responses'} = 'Réponse standard';
    $Self->{'System Addresses'} = 'Adresses du système';
    $Self->{'Admin Area'} = 'Administration';
    $Self->{'Preferences'} = 'Préférences';
    $Self->{'top'} = 'haut';
    $Self->{'AgentFrontend'} = 'SurfaceAgent';
    $Self->{'Groups'} = 'Equipes';
    $Self->{'User'} = 'Utilisateur';
    $Self->{'User <-> Groups'} = 'Utilisateur <-> Equipes';
    $Self->{'Std. Responses <-> Queue'} = 'Réponses standards <-> Queue';
    $Self->{'Add Group'} = 'Ajouter équipe';
    $Self->{'Change Group settings'} = 'Modifier équipe';
    $Self->{'Add Queue'} = 'Ajouter queue';
    $Self->{'Systemaddress'} = 'Adresse du système';
    $Self->{'Change Queue settings'} = 'Modifier une queue';
    $Self->{'Add Response'} = 'Ajouter une réponse';
    $Self->{'Change Response settings'} = 'Modifier une réponse';
    $Self->{'Add Salutation'} = 'Ajouter une adresse';
    $Self->{'Change Salutation settings'} = 'Modifier une adresse';
    # nav bar
    $Self->{Logout} = 'Quitter';
    $Self->{QueueView} = 'Vue queue';
    $Self->{PhoneView} = 'Vue téléphone';
    $Self->{Utilities} = 'Utilitaire';
    $Self->{AdminArea} = 'Administration';
    $Self->{Preferences} = 'Préférences';
    $Self->{'Locked tickets'} = 'Mes tickets';
    $Self->{'new message'} = 'Message nouveau';
    # ticket history
    $Self->{'History of Ticket'} = 'Histoire de ticket';
    # ticket note
    $Self->{'Add note to ticket'} = 'Ajouter un commentaire au ticket';
    $Self->{'Note type'} = 'type de commentaire';
    # queue view
    $Self->{'Tickets shown'} = 'Tickets montrés';
    $Self->{'Ticket available'} = 'Ticket disponibles';
    $Self->{'Show all'} = 'Tous montrés';
    $Self->{'tickets'} = 'Tickets';
    $Self->{'All tickets'} = 'Tous tickets';
    # locked tickets
    $Self->{'All locked Tickets'} = 'Mes tickets';
    $Self->{'New message'} = 'Message nouveau';
    $Self->{'New message!'} = 'Message nouveau!';
    # util
    $Self->{'Hit'} = 'Resultat';
    $Self->{'Total hits'} = 'Resultat totale';
    $Self->{'Search again'} = 'Recherche';
    $Self->{'max viewable hits'} = 'max. resultats visibles';
    $Self->{'Utilities/Search'} = 'Utilitaires/recherche';
    $Self->{'Ticket# search (e. g. 10*5155 or 105658*)'} = 'Ticket# Suche (z. B. 10*5155 or 105658*)';
    $Self->{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Volltextsuche (z. B. "Mar*in" ode "Baue*" oder "martin+hallo")';
    # compose
    $Self->{'Compose message'} = 'Composer un message';
    $Self->{'please do not edit!'} = 'Ne pas modifier!';
    $Self->{'Send mail!'} = 'Envoyer message!';
    $Self->{'wrote'} = 'écrit';
    $Self->{'Compose answer for ticket'} = 'Composer réponse pour';
    $Self->{'Ticket locked!'} = 'Ticket bloqué!';
    # forward
    $Self->{'Forward article of ticket'} = 'Acheminer l\'article du ticket';
    $Self->{'Article type'} = 'Type d\'article';
    $Self->{'Next ticket state'} = 'Status prochain du ticket';

    # preferences
    $Self->{'User Preferences'} = 'Préférences utilisateur';
    $Self->{'Change Password'} = 'Changer mot de pass';
    $Self->{'New password'} = 'Mot de pass nouveau';
    $Self->{'New password again'} = 'Répéter nouveau mot de pass';
    $Self->{'Select your custom queues'} = 'Selection de queues préférées';
    $Self->{'Select your frontend language'} = 'Selection de la langue du surface';
    $Self->{'Select your frontend Charset'} = 'Selection de police de charactère';
    $Self->{'Select your frontend theme'} = 'Selection du schema de visualisation';
    $Self->{'Frontend language'} = 'Selection de la langue du surface';
    # change priority
    $Self->{'Change priority of ticket'} = 'Changer la priorité de ticket';
    # some other words ...
    $Self->{AddLink} = 'Ajouter lien';
#    $Self->{} = '';
#    $Self->{} = '';
#    $Self->{} = '';

    # states
    $Self->{'new'} = 'nouveau';
    $Self->{'open'} = 'ouvert';
    $Self->{'closed succsessful'} = 'fermé avec succès';
    $Self->{'closed unsuccsessful'} = 'fermé avec succès';
    $Self->{'removed'} = 'effacé';
    # article types
    $Self->{'email-external'} = 'Message à externe';
    $Self->{'email-internal'} = 'Message à interne';
    $Self->{'note-internal'} = 'Commentaire pour interne';
    $Self->{'note-external'} = 'Commentaire pour externe';
    $Self->{'note-report'} = 'Commentaire pour reports';

#    $Self->{''} = '';
#    $Self->{''} = '';

    # priority
    $Self->{'very low'} = 'très bas';
    $Self->{'low'} = 'bas';
    $Self->{'normal'} = 'normale';
    $Self->{'high'} = 'haut';
    $Self->{'very high'} = 'très haut';

    return;
}
# --

1;

