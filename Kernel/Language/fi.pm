# --
# Kernel/Language/fi.pm - provides fi language translation
# Copyright (C) 2002 Antti Kämäräinen <antti at seu.net>
# --
# $Id: fi.pm,v 1.18 2004-01-21 23:46:08 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fi;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.18 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Thu Jan 22 00:28:23 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Minuuttia',
      ' 5 minutes' => ' 5 Minuuttia',
      ' 7 minutes' => ' 7 Minuuttia',
      '10 minutes' => '10 Minuuttia',
      '15 minutes' => '15 Minuuttia',
      'AddLink' => 'Lisää linkki',
      'Admin-Area' => 'Ylläpito',
      'agent' => '',
      'Agent-Area' => '',
      'all' => 'kaikki',
      'All' => 'Kaikki',
      'Attention' => 'Huomio',
      'Bug Report' => 'Lähetä bugiraportti',
      'Cancel' => 'Peruuta',
      'change' => 'muuta',
      'Change' => 'Muuta',
      'change!' => 'muuta!',
      'click here' => 'klikkaa tästä',
      'Comment' => 'Kommentti',
      'Customer' => 'Asiakas',
      'customer' => '',
      'Customer Info' => 'Tietoa asiakkaasta',
      'day' => 'päivä',
      'days' => 'päivää',
      'description' => 'Selitys',
      'Description' => 'Selitys',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'Don\'t show closed Tickets' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Ei toimi käyttäjäID:llä 1(järjestelmätunnus). Tee uusia käyttäjiä ',
      'Done' => 'Valmis',
      'end' => 'Loppuun',
      'Error' => 'Virhe',
      'Example' => 'Esimerkki',
      'Examples' => 'Esimerkit',
      'Facility' => '',
      'FAQ-Area' => '',
      'Feature not active!' => 'Ominaisuus ei käytössä',
      'go' => 'mene',
      'go!' => 'mene!',
      'Group' => 'Ryhmä',
      'Hit' => 'Hit',
      'Hits' => 'Hitit',
      'hour' => 'tunti',
      'hours' => 'tuntia',
      'Ignore' => 'Ohita',
      'invalid' => 'Virheellinen',
      'Invalid SessionID!' => 'Virheellinen SessionID',
      'Language' => 'Kieli',
      'Languages' => 'Kielet',
      'Line' => 'Rivi',
      'Lite' => 'Kevyt',
      'Login failed! Your username or password was entered incorrectly.' => '',
      'Logout successful. Thank you for using OTRS!' => 'Uloskirjautuminen onnistui. Kiitos kun käytit OTRS-järjestelmää',
      'Message' => 'Viesti',
      'minute' => 'minutti',
      'minutes' => 'minuuttia',
      'Module' => 'Moduuli',
      'Modulefile' => 'Moduulitiedosto',
      'Name' => 'Nimi',
      'New Article' => '',
      'New message' => 'Uusi viesti',
      'New message!' => 'Uusi viesti!',
      'No' => 'Ei',
      'no' => 'ei',
      'No entry found!' => '',
      'No suggestions' => 'Ei ehdotusta',
      'none' => 'ei mitään',
      'none - answered' => 'ei mitään - vastattu',
      'none!' => 'ei mitään!',
      'Off' => 'Pois',
      'off' => 'pois',
      'On' => 'Päällä',
      'on' => 'päällä',
      'Password' => 'Salasana',
      'Pending till' => 'Odottaa',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Vastaa tähän viestiin saadaksesi se takaisin normaalille jonotuslistalle',
      'Please contact your admin' => 'Ota yhteyttä ylläpitäjääsi',
      'please do not edit!' => 'Älä muokkaa, kiitos!',
      'Please go away!' => '',
      'possible' => 'Käytössä',
      'QueueView' => 'Jonotuslistanäkymä',
      'reject' => 'Hylkää',
      'replace with' => 'Korvaa',
      'Reset' => 'Tyhjennä',
      'Salutation' => 'Tervehdys',
      'Session has timed out. Please log in again.' => '',
      'Show closed Tickets' => '',
      'Signature' => 'Allekirjoitus',
      'Sorry' => 'Anteeksi',
      'Stats' => 'Tilastot',
      'Subfunction' => 'Alifunktio',
      'submit' => 'lähetä',
      'submit!' => 'lähetä!',
      'system' => '',
      'Take this User' => '',
      'Text' => 'Teksti',
      'The recommended charset for your language is %s!' => 'Suositeltava kirjainasetus kielellesi on %s',
      'Theme' => 'Ulkoasu',
      'There is no account with that login name.' => 'Käyttäjätunnus tuntematon',
      'Timeover' => 'Vanhentuu',
      'To: (%s) replaced with database email!' => '',
      'top' => 'ylös',
      'update' => 'päivitä',
      'update!' => 'päivitä!',
      'User' => 'Käyttäjä',
      'Username' => 'Käyttäjänimi',
      'Valid' => 'Käytössä',
      'Warning' => 'Varoitus',
      'Welcome to OTRS' => 'Tervetuloa käyttämään OTRS-järjestelmää',
      'Word' => 'Sana',
      'wrote' => 'kirjoittaa',
      'yes' => 'kyllä',
      'Yes' => 'Kyllä',
      'You got new message!' => 'Sinulla on uusi viesti!',
      'You have %s new message(s)!' => 'Sinulla on %s kpl uusia viestiä!',
      'You have %s reminder ticket(s)!' => 'Sinulla on %s muistutettavaa viestiä!',

    # Template: AAAMonth
      'Apr' => 'Huh',
      'Aug' => 'Elo',
      'Dec' => 'Jou',
      'Feb' => 'Hel',
      'Jan' => 'Tam',
      'Jul' => 'Hei',
      'Jun' => 'Kesä',
      'Mar' => 'Maa',
      'May' => 'Tou',
      'Nov' => 'Mar',
      'Oct' => 'Loka',
      'Sep' => 'Syys',

    # Template: AAAPreferences
      'Closed Tickets' => '',
      'Custom Queue' => 'Valitsemasi jonotuslistat',
      'Follow up notification' => 'Ilmoitus jatkokysymyksistä',
      'Frontend' => 'Käyttöliittymä',
      'Mail Management' => 'Osoitteiden hallinta',
      'Max. shown Tickets a page in Overview.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Move notification' => 'Siirrä ilmoitus',
      'New ticket notification' => 'Ilmoitus uusista viesteistä',
      'Other Options' => 'Muita asetuksia',
      'PhoneView' => 'Puhelu / Uusi tiketti',
      'Preferences updated successfully!' => 'Asetukset tallennettu onnistuneesti',
      'QueueView refresh time' => 'Jonotusnäkymän päivitysaika',
      'Screen after new phone ticket' => '',
      'Select your default spelling dictionary.' => '',
      'Select your frontend Charset.' => 'Valitse käyttöliittymän kirjaisinasetukset',
      'Select your frontend language.' => 'Valitse käyttöliittymän kieli',
      'Select your frontend QueueView.' => 'Valitse käyttöliittymäsi jonotusnäkymä',
      'Select your frontend Theme.' => 'Valitse käyttöliittymäsi ulkoasu',
      'Select your QueueView refresh time.' => 'Valitse jonotusnäkymän päivitysaika',
      'Select your screen after creating a new ticket via PhoneView.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Lähetä ilmoitus jatkokysymyksistä, jos olen kyseisen tiketin omistaja',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Lähetä minulle ilmoitus, jos tikettejä siirretään valitsemiini jonoihin',
      'Send me a notification if a ticket is unlocked by the system.' => 'Lähetä minulle ilmoitus, jos järjestelmä poistaa tiketin lukituksen.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Lähetä ilmoitus uusista tiketeistä, jotka tulevat valitsemilleni jonotuslistoille',
      'Show closed tickets.' => 'Näytä suljetut tiketit.',
      'Spelling Dictionary' => 'Oikolukusanasto',
      'Ticket lock timeout notification' => 'Ilmoitus tiketin lukituksen vanhenemisesta',
      'TicketZoom' => '',

    # Template: AAATicket
      '1 very low' => '1 Erittäin alhainen',
      '2 low' => '2 Alhainen',
      '3 normal' => '3 Normaali',
      '4 high' => '4 Kiireellinen',
      '5 very high' => '5 Erittäin kiireellinen',
      'Action' => 'Tapahtumat',
      'Age' => 'Ikä',
      'Article' => 'Artikkeli',
      'Attachment' => 'Liitetiedosto',
      'Attachments' => 'Liitetiedostot',
      'Bcc' => 'Piilokopio',
      'Bounce' => 'Delekoi',
      'Cc' => 'Kopio',
      'Close' => 'Sulje',
      'closed successful' => 'Valmistui - Sulje',
      'closed unsuccessful' => 'Keskeneräinen - Sulje',
      'Compose' => 'uusia viesti',
      'Created' => 'Luotu',
      'Createtime' => 'Luontiaika',
      'email' => 'sähköpostiosoite',
      'eMail' => 'Sähköpostiosoite',
      'email-external' => 'Sähköposti - sisäinen',
      'email-internal' => 'Sähköposti - julkinen',
      'Forward' => 'Välitä',
      'From' => 'Lähettäjä',
      'high' => 'Kiireellinen',
      'History' => 'Historia',
      'If it is not displayed correctly,' => 'Jos tämä ei näy oikein,',
      'lock' => 'lukittu',
      'Lock' => 'Lukitse',
      'low' => 'Alhainen',
      'Move' => 'Siirrä',
      'new' => 'uusi',
      'normal' => 'Normaali',
      'note-external' => 'Huomautus - sisäinen',
      'note-internal' => 'Huomautus - ulkoinen',
      'note-report' => 'Huomautus - raportti',
      'open' => 'avoin',
      'Owner' => 'Omistaja',
      'Pending' => 'Odottaa',
      'pending auto close+' => 'Automaattisulkeminen+',
      'pending auto close-' => 'Automaattisulkeminen-',
      'pending reminder' => 'Muistutus',
      'phone' => 'puhelimitse',
      'plain' => 'pelkkä teksti',
      'Priority' => 'Prioriteetti',
      'Queue' => 'Jonotuslista',
      'removed' => 'poistettu',
      'Sender' => 'Lähettäjä',
      'sms' => 'tekstiviesti',
      'State' => 'Tila',
      'Subject' => 'Otsikko',
      'This is a' => 'Tämä on',
      'This is a HTML email. Click here to show it.' => 'Tämä sähköposti on HTML-muodossa. Klikkaa tästä katsoaksesi sitä',
      'This message was written in a character set other than your own.' => 'Tämä teksti on kirjoitettu eri kirjaisinasetuksilla kuin omasi',
      'Ticket' => 'Tiketti',
      'Ticket "%s" created!' => '',
      'To' => 'Vastaanottaja',
      'to open it in a new window.' => 'avataksesi se uuteen ikkunaan.',
      'unlock' => 'poista lukitus',
      'Unlock' => 'Poista lukitus',
      'very high' => 'Erittäin kiireellinen',
      'very low' => 'Erittäin alhainen',
      'View' => 'Katso',
      'webrequest' => 'web-pyyntö',
      'Zoom' => 'Katso',

    # Template: AAAWeekDay
      'Fri' => 'Pe',
      'Mon' => 'Ma',
      'Sat' => 'La',
      'Sun' => 'Su',
      'Thu' => 'To',
      'Tue' => 'Ti',
      'Wed' => 'Ke',

    # Template: AdminAttachmentForm
      'Add' => '',
      'Attachment Management' => 'Liitetiedostojen hallinta',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Lisää automaattivastaus',
      'Auto Response From' => 'Automaattivastaus ',
      'Auto Response Management' => 'Automaattivastausten hallinta',
      'Change auto response settings' => 'Muuta automaattivastausten asetuksia',
      'Note' => 'Huomautus',
      'Response' => 'Vastaa',
      'to get the first 20 character of the subject' => 'nähdäksesi ensimmäiset 20 kirjainta otsikosta',
      'to get the first 5 lines of the email' => 'nähdäksesi 5 ensimmäistä riviä sähköpostista',
      'to get the from line of the email' => 'nähdäksesi yhden rivin sähköpostista',
      'to get the realname of the sender (if given)' => 'nähdäksesi käyttäjän nimen',
      'to get the ticket id of the ticket' => '',
      'to get the ticket number of the ticket' => 'nähdäksesi tiketin numeron',
      'Type' => 'Tyyppi',
      'Useable options' => 'Käytettävät asetukset',

    # Template: AdminCharsetForm
      'Charset' => 'Kirjaisinasetus',
      'System Charset Management' => 'Järjestelmän kirjaisinasetusten hallinta',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Asiakas-käyttäjien hallinta',
      'Customer user will be needed to to login via customer panels.' => 'Asiakas-käyttäjän pitää kirjautua Asiakas-liittymästä',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Muuta %s asetuksia',
      'Customer User <-> Group Management' => '',
      'Full read and write access to the tickets in this group/queue.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => 'Käyttöoikeus',
      'Read only access to the ticket in this group/queue.' => '',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => '',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Vaihda käyttäjä <-> Ryhmähallinta',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Ylläpidon sähköposti',
      'Body' => 'Runko-osa',
      'OTRS-Admin Info!' => '',
      'Recipents' => 'Vastaanottajat',
      'send' => 'lähetä',

    # Template: AdminEmailSent
      'Message sent to' => 'Viesti lähetetty, vastaanottaja: ',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Lisää uusi käyttäjäryhmä, että voit määritellä käyttöoikeuksia useammille eri tukiryhmille (Huolto, Ostot, Markkinointi jne.)',
      'Group Management' => 'Ryhmien hallinta',
      'It\'s useful for ASP solutions.' => 'Tämä on hyödyllinen ASP-käytössä',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin-ryhmän jäsenet pääsevät ylläpito- ja tilastoalueille.',

    # Template: AdminLog
      'System Log' => 'Järjestelmälogi',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Ylläpidon sähköposti',
      'Attachment <-> Response' => '',
      'Auto Response <-> Queue' => 'Automaattivastaukset <-> Jonotuslista',
      'Auto Responses' => 'Automaattivastaukset',
      'Customer User' => 'Asiakas-käyttäjä',
      'Customer User <-> Groups' => '',
      'Email Addresses' => 'Sähköpostiosoitteet',
      'Groups' => 'Ryhmät',
      'Logout' => 'Kirjaudu ulos',
      'Misc' => 'Muut',
      'Notifications' => '',
      'POP3 Account' => 'POP3 -tunnus',
      'Responses' => 'Vastaukset',
      'Responses <-> Queue' => 'Vastaukset <-> Jonotuslista',
      'Select Box' => 'Suodatus',
      'Session Management' => 'Istuntojen hallinta',
      'Status' => '',
      'System' => 'Järjestelmä',
      'User <-> Groups' => 'Käyttäjä <-> Ryhmät',

    # Template: AdminNotificationForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Vastauspohja on oletusteksti, jonka avulla voit nopeuttaa vastaamista asiakkaille',
      'Don\'t forget to add a new response a queue!' => 'Älä unohda lisätä uutta vastauspohjaa jonotuslistalle.',
      'Next state' => '',
      'Notification Management' => '',
      'The current ticket state is' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Kaikki saapuvat sähköpostit lähetetään valitulle jonotuslistalle',
      'Dispatching' => 'Lähetä',
      'Host' => 'Palvelin',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => '',
      'Login' => 'Käyttäjätunnus',
      'POP3 Account Management' => 'POP3 -tunnusten hallinta',
      'Trusted' => 'Hyväksytty',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Jonotuslista <-> Automaattivastaushallinta',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = ei vanhentumisaikaa',
      '0 = no unlock' => '0 = ei lukituksen poistumista',
      'Customer Move Notify' => '',
      'Customer Owner Notify' => '',
      'Customer State Notify' => '',
      'Escalation time' => 'Maksimi käsittelyaika',
      'Follow up Option' => 'Seuranta-asetukset',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
      'Key' => 'Key',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'Queue Management' => 'Jonotuslistan Hallinta',
      'Sub-Queue of' => '',
      'Systemaddress' => 'Järjestelmän osoite',
      'The salutation for email answers.' => '',
      'The signature for email answers.' => 'Allekirjoitus sähköpostiosoitteeseen',
      'Ticket lock after a follow up' => '',
      'Unlock timeout' => 'Aika lukituksen poistumiseen',
      'Will be the sender address of this queue for email answers.' => '',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Oletusvastaukset <-> Jonotuslista',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Vastaus',
      'Change answer <-> queue settings' => 'Vaihda vastaus <-> Jonotuslista',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => '',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Muokkaa vastauksia <-> Liitetiedostojen hallinta',

    # Template: AdminResponseForm
      'Response Management' => 'Vastauspohjien hallinta',

    # Template: AdminSalutationForm
      'customer realname' => 'käyttäjän oikea nimi',
      'for agent firstname' => 'käsittelijän etunimi',
      'for agent lastname' => 'käsittelijän sukunimi',
      'for agent login' => '',
      'for agent user id' => '',
      'Salutation Management' => 'Tervehdysten hallinta',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. rivimäärä',

    # Template: AdminSelectBoxResult
      'Limit' => 'Rajoitus',
      'Select Box Result' => 'Suodatustuloksia',
      'SQL' => 'SQL',

    # Template: AdminSession
      'Agent' => '',
      'kill all sessions' => 'Tapa kaikki istunnot',
      'Overview' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSessionTable
      'kill session' => 'Tapa istunto',
      'SessionID' => 'SessionID',

    # Template: AdminSignatureForm
      'Signature Management' => 'Allekirjoitusten hallinta',

    # Template: AdminStateForm
      'See also' => '',
      'State Type' => '',
      'System State Management' => 'Tilamahdollisuuksien määrittäminen',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle eingehenden Emails mit dem "To:" werden in die ausgewählte Queue einsortiert.',
      'Email' => 'Sähköposti',
      'Realname' => 'Nimi',
      'System Email Addresses Management' => 'Sähköpostiosoitteiden määritys',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Älä unohda lisätä käyttäjää ryhmiin!',
      'Firstname' => 'Etunimi',
      'Lastname' => 'Sukunimi',
      'User Management' => 'Käyttäjähallinta',
      'User will be needed to handle tickets.' => 'Käyttäjä tarvitaan tikettien käsittelemiseen.',

    # Template: AdminUserGroupChangeForm
      'create' => '',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'User <-> Group Management' => 'Käyttäjä <-> Ryhmähallinta',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Hylkää muutokset ja palaa viestin kirjoitusikkunaan',
      'Return to the compose screen' => 'Palaa viestin kirjoitusikkunaan',
      'Search' => '',
      'The message being composed has been closed.  Exiting.' => '',
      'This window must be called from compose window' => '',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Viestissä pitää olla vastaanottaja!',
      'Bounce ticket' => 'Delekoi tiketti',
      'Bounce to' => 'Delekoi',
      'Inform sender' => 'Informoi lähettäjää',
      'Next ticket state' => 'Uusi tiketin status',
      'Send mail!' => 'Lähetä sähköposti!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Laita vastaanottajakenttään sähköpostiosoite!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Sähköposti, tikettinumero "<OTRS_TICKET>" on välitetty osoitteeseen: "<OTRS_BOUNCE_TO>" . Ota yhteyttä kyseiseen osoitteeseen saadaksesi lisätietoja',

    # Template: AgentClose
      ' (work units)' => ' (esim. minuutteina)',
      'A message should have a body!' => '',
      'A message should have a subject!' => 'Viestissä pitää olla otsikko!',
      'Close ticket' => 'Sulje tiketti',
      'Close type' => 'Sulkemisen syy',
      'Close!' => 'Sulje!',
      'Note Text' => 'Huomautusteksti',
      'Note type' => 'Viestityyppi',
      'Options' => 'Asetukset',
      'Spell Check' => 'Oikeinkirjoituksen tarkistus',
      'Time units' => 'Työaika',
      'You need to account time!' => 'Käsittelyaika',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Viesti täytyy oikolukea!',
      'Attach' => 'Liite',
      'Compose answer for ticket' => 'Lähetä vastaus tikettiin',
      'for pending* states' => 'Automaattisulkeminen tai muistutus',
      'Is the ticket answered' => 'Onko tikettiin vastattu',
      'Pending Date' => 'Odotuspäivä',

    # Template: AgentCustomer
      'Back' => 'Takaisin',
      'Change customer of ticket' => 'Vaihda tiketin asiakasta',
      'CustomerID' => 'AsiakasID#',
      'Search Customer' => 'Etsi Asiakas',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'Asiakkaan historiatiedot',

    # Template: AgentCustomerMessage
      'Follow up' => 'Ilmoitukset',

    # Template: AgentCustomerView
      'Customer Data' => '',

    # Template: AgentForward
      'Article type' => 'Huomautustyyppi',
      'Date' => 'Päivämäärä',
      'End forwarded message' => 'Välitetyn viestin loppu',
      'Forward article of ticket' => 'Välitä tiketin artikkeli',
      'Forwarded message from' => 'Välitetty viesti. Lähettäjä:',
      'Reply-To' => 'Lähetä vastaus',

    # Template: AgentFreeText
      'Change free text of ticket' => '',
      'Value' => '',

    # Template: AgentHistoryForm
      'History of' => 'Historia:',

    # Template: AgentMailboxNavBar
      'All messages' => 'Kaikki viestit',
      'down' => 'loppuun',
      'Mailbox' => 'Saapuneet',
      'New' => 'Uusi',
      'New messages' => 'Uusia viestejä',
      'Open' => 'Avaa',
      'Open messages' => 'Avaa viesti',
      'Order' => 'Järjestys',
      'Pending messages' => 'Odottavat viestit',
      'Reminder' => 'Muistuttaja',
      'Reminder messages' => 'Muistutettavat viestit',
      'Sort by' => 'Järjestä',
      'Tickets' => 'Tiketit',
      'up' => 'alkuun',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'All Agents' => '',
      'Move Ticket' => '',
      'New Owner' => '',
      'New Queue' => '',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Lukitut tiketit',
      'new message' => 'uusi viesti',
      'Preferences' => 'Käyttäjäasetukset',
      'Utilities' => 'Etsi',

    # Template: AgentNote
      'Add note to ticket' => 'Lisää huomautus tähän tikettiin',
      'Note!' => '',

    # Template: AgentOwner
      'Change owner of ticket' => 'Muuta tämän tiketin omistajaa',
      'Message for new Owner' => '',

    # Template: AgentPending
      'Pending date' => '',
      'Pending type' => '',
      'Pending!' => '',
      'Set Pending' => '',

    # Template: AgentPhone
      'Customer called' => 'Asiakas soitti',
      'Phone call' => 'Puhelut',
      'Phone call at %s' => 'Puhelu %s',

    # Template: AgentPhoneNew
      'Clear From' => '',
      'Lock Ticket' => '',
      'new ticket' => 'Uusi tiketti',

    # Template: AgentPlain
      'ArticleID' => '',
      'Plain' => 'Pelkkä teksti',
      'TicketID' => 'TikettiID',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Valitse erityinen jonotuslista',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Vaihda salasana',
      'New password' => 'Uusi salasana',
      'New password again' => 'Kirjoita salasana uudelleen',

    # Template: AgentPriority
      'Change priority of ticket' => 'Muuta prioriteettiä',

    # Template: AgentSpelling
      'Apply these changes' => 'Hyväksy muutokset',
      'Spell Checker' => 'Oikeinkirjoituksen tarkistus',
      'spelling error(s)' => 'Kirjoitusvirheitä',

    # Template: AgentStatusView
      'D' => 'A',
      'of' => '',
      'Site' => 'Palvelin',
      'sort downward' => 'Järjestä laskevasti',
      'sort upward' => 'Järjestä nousevasti',
      'Ticket Status' => 'Tiketin tilatieto',
      'U' => 'Y',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Tiketti lukittu!',
      'Ticket unlock!' => '',

    # Template: AgentTicketPrint
      'by' => '',

    # Template: AgentTicketPrintHeader
      'Accounted time' => '',
      'Escalation in' => 'Vanhenee',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      'and' => '',
      'Customer User Login' => '',
      'Delete' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'No time settings.' => '',
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Search' => '',
      'TicketFreeText' => '',
      'Times' => '',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Asiakashistoriahaku',
      'Customer history search (e. g. "ID342425").' => 'Asiakashistoriahaku (Esim. "ID342425").',
      'No * possible!' => 'Jokerimerkki (*) ei käytössä !',

    # Template: AgentUtilSearchNavBar
      'Change search options' => '',
      'Results' => 'Hakutulokset',
      'Search Result' => '',
      'Total hits' => 'Hakutuloksia yhteensä',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => '',
      'All open tickets' => 'Kaikki avoimet tiketit',
      'closed tickets' => '',
      'open tickets' => 'avoimet tiketit',
      'or' => '',
      'Provides an overview of all' => '',
      'So you see what is going on in your system.' => '',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => '',
      'Your own Ticket' => '',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Vastaa',
      'Contact customer' => 'Ota yhteyttä asiakkaaseen',
      'phone call' => 'Puhelut',

    # Template: AgentZoomArticle
      'Split' => '',

    # Template: AgentZoomBody
      'Change queue' => 'Vaihda jonotuslistaa',

    # Template: AgentZoomHead
      'Free Fields' => '',
      'Print' => 'Tulosta',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Luo tunnus',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'delete' => '',
      'edit' => '',
      'FAQ History' => '',
      'print' => '',
      'view' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => '',
      'Keywords' => '',
      'Last update' => '',
      'Problem' => '',
      'Solution' => '',
      'Sympthom' => '',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: CustomerFAQArticleView
      'FAQ Article' => '',
      'Modified' => '',

    # Template: CustomerFAQOverview
      'FAQ Overview' => '',

    # Template: CustomerFAQSearch
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => 'Yhteystiedot',
      'Home' => 'Etusivu',
      'Online-Support' => 'Online-tuki',
      'Products' => 'Tuotteet',
      'Support' => 'Tuki',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Unohditko salasanan?',
      'Request new password' => 'Pyydä uutta salasanaa',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Luo uusi tiketti',
      'FAQ' => 'FAQ/UKK',
      'New Ticket' => 'Uusi tiketti',
      'Ticket-Overview' => 'Tiketin katselu',
      'Welcome %s' => 'Tervetuloa %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Minun tikettini',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Klikkaa tästä lähettääksesi bugiraportti!',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'Filename' => '',
      'Short Description' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView
      'history' => '',

    # Template: FAQCategoryForm
      'FAQ Category' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => '',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Luo tietokanta',
      'Drop Database' => 'Poista tietokanta',
      'Finished' => 'Valmis',
      'System Settings' => '',
      'Web-Installer' => '',

    # Template: InstallerFinish
      'Admin-User' => '',
      'After doing so your OTRS is up and running.' => '',
      'Have a lot of fun!' => '',
      'Restart your webserver' => '',
      'Start page' => 'Aloitussivu',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Your OTRS Team' => '',

    # Template: InstallerLicense
      'accept license' => 'Hyväksy lisenssi',
      'don\'t accept license' => 'En hyväksy lisenssiä',
      'License' => 'Lisenssi',

    # Template: InstallerStart
      'Create new database' => '',
      'DB Admin Password' => '',
      'DB Admin User' => '',
      'DB Host' => '',
      'DB Type' => '',
      'default \'hot\'' => '',
      'Delete old database' => '',
      'next step' => 'Seuraava',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => '',
      'OTRS DB Password' => '',
      'OTRS DB User' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      '(Email of the system admin)' => 'Ylläpitäjän sähköpostiosoite',
      '(Full qualified domain name of your system)' => '',
      '(Logfile just needed for File-LogModule!)' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => 'Oletuskieli',
      '(Used log backend)' => '',
      '(Used ticket number format)' => 'Tikettinumeroiden oletusformaatti',
      'CheckMXRecord' => '',
      'Default Charset' => 'Oletuskirjaisinasetus',
      'Default Language' => 'Oletuskieli',
      'Logfile' => 'Logitiedosto',
      'LogModule' => '',
      'Organization' => 'Organisaatio',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Tikettinumeroiden generoija',
      'Webfrontend' => 'Webnäkymä',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Ei käyttöoikeutta',

    # Template: Notify
      'Info' => 'Info',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'printed by' => 'tulostanut: ',

    # Template: QueueView
      'All tickets' => 'Tikettejä yhteensä',
      'Page' => '',
      'Queues' => 'Jonotuslista',
      'Tickets available' => 'Tikettejä avoinna',
      'Tickets shown' => 'Tikettejä näkyvissä',

    # Template: SystemStats
      'Graphs' => 'Kuvaajat',

    # Template: Test
      'OTRS Test Page' => 'OTRS - Testisivu',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Tiketin maksimi hyväksyttävä käsittelyaika!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Lisää huomautus',

    # Template: Warning

    # Misc
      'A message should have a From: recipient!' => '',
      'AgentFrontend' => 'Tukinäkymä',
      'Article free text' => '',
      'Backend' => '',
      'BackendMessage' => '',
      'Charsets' => 'Kirjaisinasetus',
      'Create' => 'Luo',
      'Fulltext search' => 'Tekstihaku',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Tekstihaku("Etsi esimerkiksi "Mi*a" tai "Petr+Tekrat"',
      'Handle' => '',
      'New state' => 'Uusi tila',
      'New ticket via call.' => 'Uusi ',
      'New user' => 'Uusi käyttäjä',
      'Search in' => 'Etsi seuraavista:',
      'Set customer id of a ticket' => 'Aseta tiketin asiakasnumero#',
      'Show all' => 'Yhteensä',
      'Status defs' => 'Tikettien tilamääritykset',
      'System Language Management' => 'Järjestelmän kielen hallinta',
      'Ticket free text' => 'Etsi koko tiketistä',
      'Ticket limit:' => 'Tikettien max määrä',
      'Time till escalation' => 'Aikaa jäljellä maksimi käsittelyaikaan',
      'With State' => '',
      'You have to be in the admin group!' => 'Sinun täytyy olla admin -ryhmässä!',
      'You have to be in the stats group!' => 'Sinun täytyy olla stats -ryhmässä',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Lähettäjä -kentässä pitää olla sähköpostiosoite (esim. teppo.testi@esimerkki.fi)',
      'auto responses set' => 'Automaattivastaus asetettu',
      'search' => 'Etsi',
      'search (e. g. 10*5155 or 105658*)' => 'etsi tikettinumerolla (Esim. 10*5155 or 105658*)',
      'store' => 'tallenna',
      'tickets' => 'tikettiä',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
