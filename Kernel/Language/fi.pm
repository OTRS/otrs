# --
# Kernel/Language/fi.pm - provides fi language translation
# Copyright (C) 2002 Antti Kämäräinen <antti at seu.net>
# --
# $Id: fi.pm,v 1.10 2003-02-03 22:53:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fi;

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
    # Last translation Mon Feb  3 23:33:29 2003 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Minuuttia',
      ' 5 minutes' => ' 5 Minuuttia',
      ' 7 minutes' => ' 7 Minuuttia',
      '10 minutes' => '10 Minuuttia',
      '15 minutes' => '15 Minuuttia',
      'AddLink' => 'Lisää linkki',
      'AdminArea' => 'Ylläpito',
      'all' => 'kaikki',
      'All' => 'Kaikki',
      'Attention' => 'Huomio',
      'Bug Report' => 'Lähetä bugiraportti',
      'Cancel' => 'Peruuta',
      'Change' => 'Muuta',
      'change' => 'muuta',
      'change!' => 'muuta!',
      'click here' => 'klikkaa tästä',
      'Comment' => 'Kommentti',
      'Customer' => 'Asiakas',
      'Customer info' => 'Tietoa asiakkaasta',
      'day' => 'päivä',
      'days' => 'päivää',
      'description' => 'Selitys',
      'Description' => 'Selitys',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Ei toimi käyttäjäID:llä 1(järjestelmätunnus). Tee uusia käyttäjiä ',
      'Done' => 'Valmis',
      'end' => 'Loppuun',
      'Error' => 'Virhe',
      'Example' => 'Esimerkki',
      'Examples' => 'Esimerkit',
      'Facility' => '',
      'Feature not acitv!' => 'Ominaisuus ei käytössä',
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
      'New message' => 'Uusi viesti',
      'New message!' => 'Uusi viesti!',
      'no' => 'ei',
      'No' => 'Ei',
      'No suggestions' => 'Ei ehdotusta',
      'none' => 'ei mitään',
      'none - answered' => 'ei mitään - vastattu',
      'none!' => 'ei mitään!',
      'off' => 'pois',
      'Off' => 'Pois',
      'on' => 'päällä',
      'On' => 'Päällä',
      'Password' => 'Salasana',
      'Pending till' => 'Odottaa',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Vastaa tähän viestiin saadaksesi se takaisin normaalille jonotuslistalle',
      'Please contact your admin' => 'Ota yhteyttä ylläpitäjääsi',
      'please do not edit!' => 'Älä muokkaa, kiitos!',
      'possible' => 'Käytössä',
      'QueueView' => 'Jonotuslistanäkymä',
      'reject' => 'Hylkää',
      'replace with' => 'Korvaa',
      'Reset' => 'Tyhjennä',
      'Salutation' => 'Tervehdys',
      'Signature' => 'Allekirjoitus',
      'Sorry' => 'Anteeksi',
      'Stats' => 'Tilastot',
      'Subfunction' => 'Alifunktio',
      'submit' => 'lähetä',
      'submit!' => 'lähetä!',
      'Take this User' => '',
      'Text' => 'Teksti',
      'The recommended charset for your language is %s!' => 'Suositeltava kirjainasetus kielellesi on %s',
      'Theme' => 'Ulkoasu',
      'There is no account with that login name.' => 'Käyttäjätunnus tuntematon',
      'Timeover' => 'Vanhentuu',
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
      'Yes' => 'Kyllä',
      'yes' => 'kyllä',
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
      'Custom Queue' => 'Valitsemasi jonotuslistat',
      'Follow up notification' => 'Ilmoitus jatkokysymyksistä',
      'Frontend' => 'Käyttöliittymä',
      'Mail Management' => 'Osoitteiden hallinta',
      'Move notification' => 'Siirrä ilmoitus',
      'New ticket notification' => 'Ilmoitus uusista viesteistä',
      'Other Options' => 'Muita asetuksia',
      'Preferences updated successfully!' => 'Asetukset tallennettu onnistuneesti',
      'QueueView refresh time' => 'Jonotusnäkymän päivitysaika',
      'Select your frontend Charset.' => 'Valitse käyttöliittymän kirjaisinasetukset',
      'Select your frontend language.' => 'Valitse käyttöliittymän kieli',
      'Select your frontend QueueView.' => 'Valitse käyttöliittymäsi jonotusnäkymä',
      'Select your frontend Theme.' => 'Valitse käyttöliittymäsi ulkoasu',
      'Select your QueueView refresh time.' => 'Valitse jonotusnäkymän päivitysaika',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Lähetä ilmoitus jatkokysymyksistä, jos olen kyseisen tiketin omistaja',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Lähetä minulle ilmoitus, jos tikettejä siirretään valitsemiini jonoihin',
      'Send me a notification if a ticket is unlocked by the system.' => 'Lähetä minulle ilmoitus, jos järjestelmä poistaa tiketin lukituksen.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Lähetä ilmoitus uusista tiketeistä, jotka tulevat valitsemilleni jonotuslistoille',
      'Ticket lock timeout notification' => 'Ilmoitus tiketin lukituksen vanhenemisesta',

    # Template: AAATicket
      '1 very low' => '1 Erittäin alhainen',
      '2 low' => '2 Alhainen',
      '3 normal' => '3 Normaali',
      '4 high' => '4 Kiireellinen',
      '5 very high' => '5 Erittäin kiireellinen',
      'Action' => 'Hyväksy',
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
      'pending auto close+' => '',
      'pending auto close-' => '',
      'pending reminder' => '',
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
      'To' => 'Vastaanottaja',
      'to open it in a new window.' => 'avataksesi se uuteen ikkunaan.',
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
      'Add attachment' => 'Lisää liitetiedosto',
      'Attachment Management' => 'Liitetiedostojen hallinta',
      'Change attachment settings' => 'Muuta liitetiedostojen asetuksia',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Lisää automaattivastaus',
      'Auto Response From' => 'Automaattivastaus ',
      'Auto Response Management' => 'Automaattivastausten hallinta',
      'Change auto response settings' => 'Muuta automaattivastausten asetuksia',
      'Charset' => 'Kirjaisinasetus',
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
      'Add charset' => 'Lisää kirjaisinasetus',
      'Change system charset setting' => 'Muuta kirjaisinasetuksia',
      'System Charset Management' => 'Järjestelmän kirjaisinasetusten hallinta',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Lisää asiakas-käyttäjä',
      'Change customer user settings' => 'Muuta asiakas-käyttäjän asetuksia',
      'Customer User Management' => 'Asiakas-käyttäjien hallinta',
      'Customer user will be needed to to login via customer panels.' => 'Asiakas-käyttäjän pitää kirjautua Asiakas-liittymästä',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Ylläpidon sähköposti',
      'Body' => 'Runko-osa',
      'OTRS-Admin Info!' => '',
      'Recipents' => 'Vastaanottajat',

    # Template: AdminEmailSent
      'Message sent to' => 'Viesti lähetetty, vastaanottaja: ',

    # Template: AdminGroupForm
      'Add group' => 'Lisää ryhmä',
      'Change group settings' => 'Muuta ryhmän asetuksia',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Lisää uusi käyttäjäryhmä, että voit määritellä käyttöoikeuksia useammille eri tukiryhmille (Huolto, Ostot, Markkinointi jne.)',
      'Group Management' => 'Ryhmien hallinta',
      'It\'s useful for ASP solutions.' => 'Tämä on hyödyllinen ASP-käytössä',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin-ryhmän jäsenet pääsevät ylläpito- ja tilastoalueille.',

    # Template: AdminLanguageForm
      'Add language' => 'Lisää kieli',
      'Change system language setting' => 'Muokkaa järjestelmän kieliasetuksua',
      'System Language Management' => 'Järjestelmän kielen hallinta',

    # Template: AdminLog
      'System Log' => 'Järjestelmälogi',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Ylläpidon sähköposti',
      'AgentFrontend' => 'Tukinäkymä',
      'Auto Response <-> Queue' => 'Automaattivastaukset <-> Jonotuslista',
      'Auto Responses' => 'Automaattivastaukset',
      'Charsets' => 'Kirjaisinasetus',
      'Customer User' => 'Asiakas-käyttäjä',
      'Email Addresses' => 'Sähköpostiosoitteet',
      'Groups' => 'Ryhmät',
      'Logout' => 'Kirjaudu ulos',
      'Misc' => 'Muut',
      'POP3 Account' => 'POP3 -tunnus',
      'Responses' => 'Vastaukset',
      'Responses <-> Queue' => 'Vastaukset <-> Jonotuslista',
      'Select Box' => 'Suodatus',
      'Session Management' => 'Istuntojen hallinta',
      'Status defs' => 'Tikettien tilamääritykset',
      'System' => 'Järjestelmä',
      'User <-> Groups' => 'Käyttäjä <-> Ryhmät',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Lisää POP3 -tunnus',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Kaikki saapuvat sähköpostit lähetetään valitulle jonotuslistalle',
      'Change POP3 Account setting' => 'Muuta POP3 -asetuksia',
      'Dispatching' => '',
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
      'Add queue' => 'Lisää jonotuslista',
      'Change queue settings' => 'Muuta jonotuslistan asetuksia',
      'Escalation time' => 'Maksimi käsittelyaika',
      'Follow up Option' => 'Seuranta-asetukset',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
      'Key' => 'Key',
      'Queue Management' => 'Jonotuslistan Hallinta',
      'Systemaddress' => 'Järjestelmän osoite',
      'The salutation for email answers.' => '',
      'The signature for email answers.' => 'Allekirjoitus sähköpostiosoitteeseen',
      'Ticket lock after a follow up' => '',
      'Unlock timeout' => 'Aika lukituksen poistumiseen',
      'Will be the sender address of this queue for email answers.' => '',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Muuta %s asetuksia',
      'Std. Responses <-> Queue Management' => 'Oletusvastaukset <-> Jonotuslista',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Vastaus',
      'Change answer <-> queue settings' => 'Vaihda vastaus <-> Jonotuslista',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => '',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Muokkaa vastauksia <-> Liitetiedostojen hallinta',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Vastauspohja on oletusteksti, jonka avulla voit nopeuttaa vastaamista asiakkaille',
      'Add response' => 'Lisää vastauspohja',
      'Change response settings' => 'Muuta vastauspohjan asetuksia',
      'Don\'t forget to add a new response a queue!' => 'Älä unohda lisätä uutta vastauspohjaa jonotuslistalle.',
      'Response Management' => 'Vastauspohjien hallinta',

    # Template: AdminSalutationForm
      'Add salutation' => 'Lisää tervehdys',
      'Change salutation settings' => 'Muuta tervehdysasetuksia',
      'customer realname' => 'käyttäjän oikea nimi',
      'Salutation Management' => 'Tervehdysten hallinta',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. rivimäärä',

    # Template: AdminSelectBoxResult
      'Limit' => 'Rajoitus',
      'Select Box Result' => 'Suodatustuloksia',
      'SQL' => 'SQL',

    # Template: AdminSession
      'kill all sessions' => 'Tapa kaikki istunnot',

    # Template: AdminSessionTable
      'kill session' => 'Tapa istunto',
      'SessionID' => 'SessionID',

    # Template: AdminSignatureForm
      'Add signature' => 'Lisää allekirjoitus',
      'Change signature settings' => 'Muuta allekirjoitusasetuksia',
      'for agent firstname' => 'käsittelijän etunimi',
      'for agent lastname' => 'käsittelijän sukunimi',
      'Signature Management' => 'Allekirjoitusten hallinta',

    # Template: AdminStateForm
      'Add state' => 'Lisää uusi tila',
      'Change system state setting' => 'Muuta tiketin tila-asetuksia',
      'System State Management' => 'Tilamahdollisuuksien määrittäminen',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Lisää järjestelmän sähköpostiosoite',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle eingehenden Emails mit dem "To:" werden in die ausgewählte Queue einsortiert.',
      'Change system address setting' => 'Muuta järjestelmän sähköpostiasetuksia',
      'Email' => 'Sähköposti',
      'Realname' => 'Nimi',
      'System Email Addresses Management' => 'Sähköpostiosoitteiden määritys',

    # Template: AdminUserForm
      'Add user' => 'Lisää käyttäjä',
      'Change user settings' => 'Vaihda käyttäjän asetuksia',
      'Don\'t forget to add a new user to groups!' => 'Älä unohda lisätä käyttäjää ryhmiin!',
      'Firstname' => 'Etunimi',
      'Lastname' => 'Sukunimi',
      'User Management' => 'Käyttäjähallinta',
      'User will be needed to handle tickets.' => 'Käyttäjä tarvitaan tikettien käsittelemiseen.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => '',
      'User <-> Group Management' => 'Käyttäjä <-> Ryhmähallinta',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Vaihda käyttäjä <-> Ryhmähallinta',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Viestissä pitää olla vastaanottaja!',
      'Bounce ticket' => 'Delekoi tiketti',
      'Bounce to' => 'Delekoi',
      'Inform sender' => '',
      'Next ticket state' => 'Uusi tiketin status',
      'Send mail!' => 'Lähetä sähköposti!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Laita vastaanottajakenttään sähköpostiosoite!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'Sähköposti, tikettinumero "<OTRS_TICKET>" on välitetty osoitteeseen: "<OTRS_BOUNCE_TO>" . Ota yhteyttä kyseiseen osoitteeseen saadaksesi lisätietoja',

    # Template: AgentClose
      ' (work units)' => '',
      'Close ticket' => 'Sulje tiketti',
      'Close type' => 'Sulkemisen syy',
      'Close!' => 'Sulje!',
      'Note Text' => 'Huomautusteksti',
      'Note type' => 'Viestityyppi',
      'store' => 'tallenna',
      'Time units' => 'Aikayksiköt',

    # Template: AgentCompose
      'A message should have a subject!' => 'Viestissä pitää olla otsikko!',
      'Attach' => 'Liite',
      'Compose answer for ticket' => 'Lähetä vastaus tikettiin',
      'for pending* states' => '',
      'Is the ticket answered' => '',
      'Options' => 'Asetukset',
      'Pending Date' => 'Odotuspäivä',
      'Spell Check' => 'Oikeinkirjoituksen tarkistus',

    # Template: AgentCustomer
      'Back' => 'Takaisin',
      'Change customer of ticket' => 'Vaihda tiketin asiakasta',
      'Set customer id of a ticket' => 'Aseta tiketin asiakasnumero#',

    # Template: AgentCustomerHistory
      'Customer history' => 'Asiakkaan historiatiedot',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
      'Customer Data' => '',

    # Template: AgentForward
      'Article type' => 'Huomautustyyppi',
      'Date' => 'Päivämäärä',
      'End forwarded message' => 'Välitetyn viestin loppu',
      'Forward article of ticket' => 'Välitä tiketin artikkeli',
      'Forwarded message from' => 'Välitetty viesti. Lähettäjä:',
      'Reply-To' => 'Lähetä vastaus',

    # Template: AgentHistoryForm
      'History of' => '',

    # Template: AgentMailboxNavBar
      'All messages' => 'Kaikki viestit',
      'CustomerID' => 'AsiakasID#',
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
      'Add Note' => 'Lisää huomautus',

    # Template: AgentNavigationBar
      'FAQ' => 'FAQ/UKK',
      'Locked tickets' => 'Lukitut tiketit',
      'new message' => 'uusi viesti',
      'PhoneView' => 'Puhelu / Uusi tiketti',
      'Preferences' => 'Käyttäjäasetukset',
      'Utilities' => 'Etsi',

    # Template: AgentNote
      'Add note to ticket' => 'Lisää huomautus tähän tikettiin',
      'Note!' => '',

    # Template: AgentOwner
      'Change owner of ticket' => 'Muuta tämän tiketin omistajaa',
      'Message for new Owner' => '',
      'New user' => 'Uusi käyttäjä',

    # Template: AgentPending
      'Pending date' => '',
      'Pending type' => '',
      'Set Pending' => '',

    # Template: AgentPhone
      'Customer called' => 'Asiakas soitti',
      'Phone call' => 'Puhelut',
      'Phone call at %s' => 'Puhelu %s',

    # Template: AgentPhoneNew
      'Search Customer' => 'Etsi Asiakas',
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
      'New state' => 'Uusi tila',

    # Template: AgentSpelling
      'Apply these changes' => 'Hyväksy muutokset',
      'Discard all changes and return to the compose screen' => 'Hylkää muutokset ja palaa viestin kirjoitusikkunaan',
      'Return to the compose screen' => 'Palaa viestin kirjoitusikkunaan',
      'Spell Checker' => 'Oikeinkirjoituksen tarkistus',
      'spelling error(s)' => 'Kirjoitusvirheitä',
      'The message being composed has been closed.  Exiting.' => '',
      'This window must be called from compose window' => '',

    # Template: AgentStatusView
      'D' => 'A',
      'sort downward' => 'Järjestä laskevasti',
      'sort upward' => 'Järjestä nousevasti',
      'Ticket limit:' => 'Tikettien max määrä',
      'Ticket Status' => 'Tiketin tilatieto',
      'U' => 'Y',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Tiketti lukittu!',
      'unlock' => 'poista lukitus',

    # Template: AgentTicketPrint
      'by' => '',

    # Template: AgentTicketPrintHeader
      'Accounted time' => '',
      'Escalation in' => 'Vanhenee',
      'printed by' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Asiakashistoriahaku',
      'Customer history search (e. g. "ID342425").' => 'Asiakashistoriahaku (Esim. "ID342425").',
      'No * possible!' => 'Jokerimerkki (*) ei käytössä !',

    # Template: AgentUtilSearchByText
      'Article free text' => '',
      'Fulltext search' => 'Tekstihaku',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Tekstihaku("Etsi esimerkiksi "Mi*a" tai "Petr+Tekrat"',
      'Search in' => 'Etsi seuraavista:',
      'Ticket free text' => 'Etsi koko tiketistä',
      'With State' => '',

    # Template: AgentUtilSearchByTicketNumber
      'search' => 'Etsi',
      'search (e. g. 10*5155 or 105658*)' => 'etsi tikettinumerolla (Esim. 10*5155 or 105658*)',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Hakutulokset',
      'Site' => 'Palvelin',
      'Total hits' => 'Hakutuloksia yhteensä',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All open tickets' => 'Kaikki avoimet tiketit',
      'open tickets' => 'avoimet tiketit',
      'Provides an overview of all' => '',
      'So you see what is going on in your system.' => '',

    # Template: CustomerCreateAccount
      'Create' => 'Luo',
      'Create Account' => 'Luo tunnus',

    # Template: CustomerError
      'Backend' => '',
      'BackendMessage' => '',
      'Click here to report a bug!' => 'Klikkaa tästä lähettääksesi bugiraportti!',
      'Handle' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => 'Yhteystiedot',
      'Home' => 'Koti',
      'Online-Support' => 'Online-tuki',
      'Products' => 'Tuotteet',
      'Support' => 'Tuki',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Unohditko salasanan?',
      'Request new password' => 'Pyydä uutta salasanaa',

    # Template: CustomerMessage
      'Follow up' => 'Ilmoitukset',

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Luo uusi tiketti',
      'My Tickets' => 'Minun tikettini',
      'New Ticket' => 'Uusi tiketti',
      'Ticket-Overview' => 'Tiketin katselu',
      'Welcome %s' => 'Tervetuloa %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'of' => '',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
      'next step' => 'Seuraava',

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
      'Ticket Number Generator' => '',
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
      'Print' => '',

    # Template: QueueView
      'All tickets' => 'Tikettejä yhteensä',
      'Queues' => 'Jonotuslista',
      'Show all' => 'Yhteensä',
      'Ticket available' => 'Tikettejä avoinna',
      'tickets' => 'tikettiä',
      'Tickets shown' => 'Tikettejä näkyvissä',

    # Template: SystemStats
      'Graphs' => 'Grafiikat',

    # Template: Test
      'OTRS Test Page' => 'OTRS - Testisivu',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Tiketin maksimi hyväksyttävä käsittelyaika!',

    # Template: TicketView
      'Change queue' => 'Vaihda jonotuslistaa',
      'Compose Answer' => 'Vastaa',
      'Contact customer' => 'Ota yhteyttä asiakkaaseen',
      'phone call' => 'Puhelut',

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Klikkaa tästä luodaksesi ryhmän)',
      '(Click here to add a queue)' => '(Klikkaa tästä tehdäksesi uuden jonotuslistan)',
      '(Click here to add a response)' => '(Klikkaa tästä lisätäksesi vastauspohjan)',
      '(Click here to add a salutation)' => '(Klikkaa tästä lisätäksesi tervehdyksen)',
      '(Click here to add a signature)' => '(Klikkaa täältä lisätäksesi allekirjoituksen)',
      '(Click here to add a system email address)' => '(Klikkaa tästä lisätäksesi järjestelmän sähköpostiosoitteen)',
      '(Click here to add a user)' => '(Klikkaa tästä lisätäksesi käyttäjän',
      '(Click here to add an auto response)' => '(Klikkaa tästä lisätäksesi automaattivastauksen)',
      '(Click here to add charset)' => 'Klikkaa tästä lisätäksesi kirjaisinasetuksen',
      '(Click here to add language)' => '(Klikkaa tästä lisätäksesi uusi kieli)',
      '(Click here to add state)' => '(Klikkaa tästä lisätäksesi uusi status)',
      'A message should have a From: recipient!' => '',
      'New ticket via call.' => 'Uusi ',
      'Time till escalation' => 'Aikaa jäljellä maksimi käsittelyaikaan',
      'Update auto response' => 'Päivitä automaattivastaukset',
      'Update charset' => 'Päivitä kirjaisinasetukset',
      'Update group' => 'Päivitä ryhmätiedot',
      'Update language' => 'Päivitä kieli',
      'Update queue' => 'Päivitä jonotuslista',
      'Update response' => 'Päivitä vastauspohja',
      'Update salutation' => 'Päivitä tervehdys',
      'Update signature' => 'Päivitä allekirjoitus',
      'Update state' => 'Päivitä status',
      'Update system address' => 'Päivitä järjestelmän sähköpostiosoitetta',
      'Update user' => 'Päivitä käyttäjätiedot',
      'You have to be in the admin group!' => 'Sinun täytyy olla admin -ryhmässä!',
      'You have to be in the stats group!' => 'Sinun täytyy olla stats -ryhmässä',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Lähettäjä -kentässä pitää olla sähköpostiosoite (esim. teppo.testi@esimerkki.fi)',
      'auto responses set' => '',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
