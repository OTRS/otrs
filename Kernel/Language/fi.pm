# --
# Kernel/Language/fi.pm - provides fi language translation
# Copyright (C) 2002 Team Seu.Net <team at seu.net>
# --
# $Id: fi.pm,v 1.1 2002-12-11 23:45:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fi;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/\$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];

    # Template: AAABase
    $Hash{' 2 minutes'} = ' 2 Minuuttia';
    $Hash{' 5 minutes'} = ' 5 Minuuttia';
    $Hash{' 7 minutes'} = ' 7 Minuuttia';
    $Hash{'10 minutes'} = '10 Minuuttia';
    $Hash{'15 minutes'} = '15 Minuuttia';
    $Hash{'AddLink'} = 'Lisää linkki';
    $Hash{'AdminArea'} = 'Ylläpito';
    $Hash{'All'} = 'Kaikki';
    $Hash{'all'} = 'kaikki';
    $Hash{'Attention'} = 'Huomio';
    $Hash{'Bug Report'} = 'Lähetä bugiraportti';
    $Hash{'Cancel'} = '';
    $Hash{'Change'} = 'Muuta';
    $Hash{'change'} = 'muuta';
    $Hash{'change!'} = 'muuta!';
    $Hash{'click here'} = 'klikkaa tästä';
    $Hash{'Comment'} = 'Kommentti';
    $Hash{'Customer'} = 'Asiakas';
    $Hash{'Customer info'} = 'Tietoa asiakkaasta';
    $Hash{'day'} = 'päivä';
    $Hash{'days'} = 'päivää';
    $Hash{'description'} = 'Selitys';
    $Hash{'Description'} = 'Selitys';
    $Hash{'Done'} = '';
    $Hash{'end'} = 'Loppuun';
    $Hash{'Error'} = 'Virhe';
    $Hash{'Example'} = 'Esimerkki';
    $Hash{'Examples'} = 'Esimerkit';
    $Hash{'Feature not acitv!'} = '';
    $Hash{'go'} = 'mene';
    $Hash{'go!'} = 'mene!';
    $Hash{'Group'} = 'Ryhmä';
    $Hash{'Hit'} = 'Hit';
    $Hash{'Hits'} = '';
    $Hash{'hour'} = 'tunti';
    $Hash{'hours'} = 'tuntia';
    $Hash{'Ignore'} = '';
    $Hash{'Invalid SessionID!'} = '';
    $Hash{'Language'} = 'Kieli';
    $Hash{'Languages'} = 'Kielet';
    $Hash{'Line'} = 'Rivi';
    $Hash{'Lite'} = 'Kevyt';
    $Hash{'Login failed! Your username or password was entered incorrectly.'} = '';
    $Hash{'Logout successful. Thank you for using OTRS!'} = 'Uloskirjautuminen onnistui. Kiitos kun käytit OTRS-järjestelmää';
    $Hash{'Message'} = 'Viesti';
    $Hash{'minute'} = 'minutti';
    $Hash{'minutes'} = 'minuuttia';
    $Hash{'Module'} = 'Moduuli';
    $Hash{'Modulefile'} = 'Moduulitiedosto';
    $Hash{'Name'} = 'Nimi';
    $Hash{'New message'} = 'Uusi viesti';
    $Hash{'New message!'} = 'Uusi viesti!';
    $Hash{'No'} = 'Ei';
    $Hash{'no'} = 'ei';
    $Hash{'No suggestions'} = '';
    $Hash{'none'} = 'ei mitään';
    $Hash{'none - answered'} = 'ei mitään - vastattu';
    $Hash{'none!'} = 'ei mitään!';
    $Hash{'off'} = 'pois';
    $Hash{'Off'} = 'Pois';
    $Hash{'on'} = 'päällä';
    $Hash{'On'} = 'Päällä';
    $Hash{'Password'} = 'Salasana';
    $Hash{'Please answer this ticket(s) to get back to the normal queue view!'} = 'Vastaa tähän viestiin saadaksesi se takaisin normaalille jonotuslistalle';
    $Hash{'Please contact your admin'} = '';
    $Hash{'please do not edit!'} = 'Älä muokkaa, kiitos!';
    $Hash{'QueueView'} = 'Jonotuslistanäkymä';
    $Hash{'replace with'} = '';
    $Hash{'Reset'} = '';
    $Hash{'Salutation'} = 'Tervehdys';
    $Hash{'Signature'} = 'Allekirjoitus';
    $Hash{'Sorry'} = 'Anteeksi';
    $Hash{'Stats'} = 'Tilastot';
    $Hash{'Subfunction'} = 'Alifunktio';
    $Hash{'submit'} = '';
    $Hash{'submit!'} = 'lähetä!';
    $Hash{'Text'} = 'Teksti';
    $Hash{'The recommended charset for your language is %s!'} = '';
    $Hash{'Theme'} = '';
    $Hash{'There is no account with that login name.'} = '';
    $Hash{'top'} = 'ylös';
    $Hash{'update'} = 'päivitä';
    $Hash{'update!'} = 'päivitä!';
    $Hash{'User'} = 'Käyttäjä';
    $Hash{'Username'} = 'Käyttäjänimi';
    $Hash{'Valid'} = 'Käytössä';
    $Hash{'Warning'} = '';
    $Hash{'Welcome to OTRS'} = '';
    $Hash{'Word'} = '';
    $Hash{'wrote'} = 'kirjoittaa';
    $Hash{'Yes'} = 'Kyllä';
    $Hash{'yes'} = 'kyllä';
    $Hash{'You got new message!'} = '';

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
    $Hash{'Select your frontend Charset.'} = '';
    $Hash{'Select your frontend language.'} = '';
    $Hash{'Select your frontend QueueView.'} = '';
    $Hash{'Select your frontend Theme.'} = '';
    $Hash{'Select your QueueView refresh time.'} = '';
    $Hash{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Lähetä ilmoitus jatkokysymyksistä, jos olen kyseisen tiketin omistaja';
    $Hash{'Send me a notification if a ticket is moved into a custom queue.'} = '';
    $Hash{'Send me a notification if a ticket is unlocked by the system.'} = '';
    $Hash{'Send me a notification if there is a new ticket in my custom queues.'} = 'Lähetä ilmoitus uusista tiketeistä, jotka tulevat valitsemilleni jonotuslistoille';
    $Hash{'Ticket lock timeout notification'} = '';

    # Template: AAATicket
    $Hash{'Action'} = 'Hyväksy';
    $Hash{'Age'} = 'Ikä';
    $Hash{'Article'} = 'Artikkeli';
    $Hash{'Attachment'} = 'Liitetiedosto';
    $Hash{'Attachments'} = '';
    $Hash{'Bcc'} = '';
    $Hash{'Bounce'} = 'Delekoi';
    $Hash{'Cc'} = 'Kopio';
    $Hash{'Close'} = 'Sulje';
    $Hash{'closed succsessful'} = 'Valmistui - Sulje';
    $Hash{'closed unsuccsessful'} = 'Keskeneräinen - Sulje';
    $Hash{'Compose'} = 'uusia viesti';
    $Hash{'Created'} = 'Luotu';
    $Hash{'Createtime'} = 'Luontiaika';
    $Hash{'eMail'} = '';
    $Hash{'email'} = 'sähköposti';
    $Hash{'email-external'} = 'Sähköposti-sisäinen';
    $Hash{'email-internal'} = 'Sähköposti - julkinen';
    $Hash{'Forward'} = 'Välitä';
    $Hash{'From'} = 'Lähettäjä';
    $Hash{'high'} = 'Kiireellinen';
    $Hash{'History'} = 'Historia';
    $Hash{'If it is not displayed correctly,'} = 'Jos tämä ei näy oikein,';
    $Hash{'Lock'} = 'Lukitse';
    $Hash{'low'} = 'Alhainen';
    $Hash{'Move'} = 'Siirrä';
    $Hash{'new'} = 'uusi';
    $Hash{'normal'} = 'Normaali';
    $Hash{'note-external'} = 'Huomautus - sisäinen';
    $Hash{'note-internal'} = 'Huomautus - sisäinen';
    $Hash{'note-report'} = 'Huomautus - raportti';
    $Hash{'open'} = 'avoin';
    $Hash{'Owner'} = 'Omistaja';
    $Hash{'Pending'} = 'Odottaa';
    $Hash{'phone'} = 'puhelimitse';
    $Hash{'plain'} = 'pelkkä teksti';
    $Hash{'Priority'} = 'Prioriteetti';
    $Hash{'Queue'} = '';
    $Hash{'removed'} = 'poistettu';
    $Hash{'Sender'} = 'Lähettäjä';
    $Hash{'sms'} = '';
    $Hash{'State'} = 'Status';
    $Hash{'Subject'} = 'Otsikko';
    $Hash{'This is a'} = 'Tämä on';
    $Hash{'This is a HTML email. Click here to show it.'} = 'Tämä sähköposti on HTML-muodossa. Klikkaa tästä katsoaksesi sitä';
    $Hash{'This message was written in a character set other than your own.'} = 'Tämä teksti on kirjoitettu eri kirjaisinasetuksilla kuin omasi';
    $Hash{'Ticket'} = 'Ticket';
    $Hash{'To'} = 'Vastaanottaja';
    $Hash{'to open it in a new window.'} = 'avataksesi se uuteen ikkunaan.';
    $Hash{'Unlock'} = 'Poista lukitus';
    $Hash{'very high'} = 'Erittäin kiireellinen';
    $Hash{'very low'} = 'Erittäin alhainen';
    $Hash{'View'} = 'Katso';
    $Hash{'webrequest'} = '';
    $Hash{'Zoom'} = 'Katso';

    # Template: AdminAutoResponseForm
    $Hash{'Add auto response'} = 'Lisää automaattivastaus';
    $Hash{'Auto Response From'} = '';
    $Hash{'Auto Response Management'} = 'Automaattivastausten hallinta';
    $Hash{'Change auto response settings'} = 'Muuta automaattivastausten asetuksia';
    $Hash{'Charset'} = '';
    $Hash{'Note'} = '';
    $Hash{'Response'} = 'Vastaa';
    $Hash{'to get the first 20 character of the subject'} = '';
    $Hash{'to get the first 5 lines of the email'} = '';
    $Hash{'to get the from line of the email'} = '';
    $Hash{'to get the realname of the sender (if given)'} = '';
    $Hash{'to get the ticket number of the ticket'} = '';
    $Hash{'Type'} = '';
    $Hash{'Useable options'} = 'Käytettävät asetukset';

    # Template: AdminCharsetForm
    $Hash{'Add charset'} = 'Lisää kirjaisinasetus';
    $Hash{'Change system charset setting'} = 'Muuta kirjaisinasetuksia';
    $Hash{'System Charset Management'} = 'Järjestelmän kirjaisinasetusten hallinta';

    # Template: AdminCustomerUserForm
    $Hash{'Add customer user'} = '';
    $Hash{'Change customer user settings'} = '';
    $Hash{'Customer User Management'} = '';
    $Hash{'Customer user will be needed to to login via customer panels.'} = '';

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
    $Hash{'Admin-Email'} = '';
    $Hash{'Body'} = '';
    $Hash{'OTRS-Admin Info!'} = '';
    $Hash{'Recipents'} = '';

    # Template: AdminEmailSent
    $Hash{'Message sent to'} = '';

    # Template: AdminGroupForm
    $Hash{'Add group'} = 'Lisää ryhmä';
    $Hash{'Change group settings'} = 'Muuta ryhmän asetuksia';
    $Hash{'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'} = 'Lisää uusi käyttäjäryhmä, että voit määritellä käyttöoikeuksia useammille eri tukiryhmille (Huolto, Ostot, Markkinointi jne.)';
    $Hash{'Group Management'} = 'Ryhmien hallinta';
    $Hash{'It\'s useful for ASP solutions.'} = 'Tämä on hyödyllinen ASP-käytössä';
    $Hash{'The admin group is to get in the admin area and the stats group to get stats area.'} = 'Admin-ryhmän jäsenet pääsevät ylläpito- ja tilastoalueille.';

    # Template: AdminLanguageForm
    $Hash{'Add language'} = 'Lisää kieli';
    $Hash{'Change system language setting'} = 'Muokkaa järjestelmän kieliasetuksua';
    $Hash{'System Language Management'} = 'Järjestelmän kielen hallinta';

    # Template: AdminNavigationBar
    $Hash{'AdminEmail'} = '';
    $Hash{'AgentFrontend'} = 'Tukinäkymä';
    $Hash{'Auto Response <-> Queue'} = 'Automaattivastaukset <-> Jonotuslista';
    $Hash{'Auto Responses'} = 'Automaattivastaukset';
    $Hash{'Charsets'} = '';
    $Hash{'CustomerUser'} = '';
    $Hash{'Email Addresses'} = 'Sähköpostiosoitteet';
    $Hash{'Groups'} = 'Ryhmät';
    $Hash{'Logout'} = 'Kirjaudu ulos';
    $Hash{'Responses'} = 'Vastaukset';
    $Hash{'Responses <-> Queue'} = 'Vastaukset <-> Jonotuslista';
    $Hash{'Select Box'} = '';
    $Hash{'Session Management'} = 'Istuntojen hallinta';
    $Hash{'Status defs'} = '';
    $Hash{'User <-> Groups'} = '';

    # Template: AdminQueueAutoResponseForm
    $Hash{'Queue <-> Auto Response Management'} = 'Jonotuslista <-> Automaattivastaushallinta';

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
    $Hash{'0 = no escalation'} = '';
    $Hash{'0 = no unlock'} = '';
    $Hash{'Add queue'} = 'Lisää jonotuslista';
    $Hash{'Change queue settings'} = 'Muuta jonotuslistan asetuksia';
    $Hash{'Escalation time'} = 'Maksimi käsittelyaika';
    $Hash{'Follow up Option'} = '';
    $Hash{'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.'} = '';
    $Hash{'If a ticket will not be answered in thos time, just only this ticket will be shown.'} = '';
    $Hash{'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.'} = '';
    $Hash{'Key'} = 'Key';
    $Hash{'Queue Management'} = 'Jonotuslistan Hallinta';
    $Hash{'Systemaddress'} = '';
    $Hash{'The salutation for email answers.'} = '';
    $Hash{'The signature for email answers.'} = '';
    $Hash{'Ticket lock after a follow up'} = '';
    $Hash{'Unlock timeout'} = 'Aika lukituksen poistumiseen';
    $Hash{'Will be the sender address of this queue for email answers.'} = '';

    # Template: AdminQueueResponsesChangeForm
    $Hash{'Change %s settings'} = '';
    $Hash{'Std. Responses <-> Queue Management'} = 'Oletusvastaukset <-> Jonotuslista';

    # Template: AdminQueueResponsesForm
    $Hash{'Answer'} = '';
    $Hash{'Change answer <-> queue settings'} = 'Vaihda vastaus <-> Jonotuslista';

    # Template: AdminResponseForm
    $Hash{'A response is default text to write faster answer (with default text) to customers.'} = 'Vastauspohja on oletusteksti, jonka avulla voit nopeuttaa vastaamista asiakkaille';
    $Hash{'Add response'} = 'Lisää vastauspohja';
    $Hash{'Change response settings'} = 'Muuta vastauspohjan asetuksia';
    $Hash{'Don\'t forget to add a new response a queue!'} = 'Älä unohda lisätä uutta vastauspohjaa jonotuslistalle.';
    $Hash{'Response Management'} = 'Vastauspohjien hallinta';

    # Template: AdminSalutationForm
    $Hash{'Add salutation'} = 'Lisää tervehdys';
    $Hash{'Change salutation settings'} = 'Muuta tervehdysasetuksia';
    $Hash{'customer realname'} = 'käyttäjän oikea nimi';
    $Hash{'Salutation Management'} = 'Tervehdysten hallinta';

    # Template: AdminSelectBoxForm
    $Hash{'Max Rows'} = 'Max. rivimäärä';

    # Template: AdminSelectBoxResult
    $Hash{'Limit'} = '';
    $Hash{'Select Box Result'} = '';
    $Hash{'SQL'} = '';

    # Template: AdminSession
    $Hash{'kill all sessions'} = 'Tapa kaikki istunnot';

    # Template: AdminSessionTable
    $Hash{'kill session'} = 'Tapa istunto';
    $Hash{'SessionID'} = '';

    # Template: AdminSignatureForm
    $Hash{'Add signature'} = 'Lisää allekirjoitus';
    $Hash{'Change signature settings'} = 'Muuta allekirjoitusasetuksia';
    $Hash{'for agent firstname'} = 'käsittelijän etunimi';
    $Hash{'for agent lastname'} = 'käsittelijän sukunimi';
    $Hash{'Signature Management'} = 'Allekirjoitusten hallinta';

    # Template: AdminStateForm
    $Hash{'Add state'} = 'Lisää status';
    $Hash{'Change system state setting'} = 'Ändere System-State';
    $Hash{'System State Management'} = 'Tilamahdollisuuksien määrittäminen';

    # Template: AdminSystemAddressForm
    $Hash{'Add system address'} = 'Lisää järjestelmän sähköpostiosoite';
    $Hash{'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!'} = 'Alle eingehenden Emails mit dem "To:" werden in die ausgewählte Queue einsortiert.';
    $Hash{'Change system address setting'} = 'Muuta järjestelmän sähköpostiasetuksia';
    $Hash{'Email'} = 'Sähköposti';
    $Hash{'Realname'} = '';
    $Hash{'System Email Addresses Management'} = 'Sähköpostiosoitteiden määritys';

    # Template: AdminUserForm
    $Hash{'Add user'} = 'Lisää käyttäjä';
    $Hash{'Change user settings'} = 'Vaihda käyttäjän asetuksia';
    $Hash{'Don\'t forget to add a new user to groups!'} = 'Älä unohda lisätä käyttäjää ryhmiin!';
    $Hash{'Firstname'} = 'Etunimi';
    $Hash{'Lastname'} = 'Sukunimi';
    $Hash{'Login'} = '';
    $Hash{'User Management'} = 'Käyttäjähallinta';
    $Hash{'User will be needed to handle tickets.'} = 'Käyttäjä tarvitaan tikettien käsittelemiseen.';

    # Template: AdminUserGroupChangeForm
    $Hash{'Change  settings'} = '';
    $Hash{'User <-> Group Management'} = 'Käyttäjä <-> Ryhmähallinta';

    # Template: AdminUserGroupForm
    $Hash{'Change user <-> group settings'} = 'Vaihda käyttäjä <-> Ryhmähallinta';

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
    $Hash{'A message should have a To: recipient!'} = 'Viestissä pitää olla vastaanottaja!';
    $Hash{'Bounce ticket'} = '';
    $Hash{'Bounce to'} = '';
    $Hash{'Inform sender'} = '';
    $Hash{'Next ticket state'} = 'Uusi tiketin status';
    $Hash{'Send mail!'} = 'Lähetä sähköposti!';
    $Hash{'You need a email address (e. g. customer@example.com) in To:!'} = 'Laita vastaanottajakenttään sähköpostiosoite!';
    $Hash{'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.'} = '';

    # Template: AgentClose
    $Hash{' (work units)'} = '';
    $Hash{'Close ticket'} = '';
    $Hash{'Close type'} = '';
    $Hash{'Close!'} = '';
    $Hash{'Note Text'} = '';
    $Hash{'Note type'} = 'Viestityyppi';
    $Hash{'store'} = 'tallenna';
    $Hash{'Time units'} = '';

    # Template: AgentCompose
    $Hash{'A message should have a subject!'} = 'Viestissä pitää olla otsikko!';
    $Hash{'Attach'} = '';
    $Hash{'Compose answer for ticket'} = 'Lähetä vastaus tikettiin';
    $Hash{'Is the ticket answered'} = '';
    $Hash{'Options'} = '';
    $Hash{'Spell Check'} = '';

    # Template: AgentCustomer
    $Hash{'Back'} = 'Takaisin';
    $Hash{'Change customer of ticket'} = '';
    $Hash{'Set customer id of a ticket'} = 'Aseta tiketin asiakasnumero#';

    # Template: AgentCustomerHistory
    $Hash{'Customer history'} = '';

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
    $Hash{'Customer Data'} = '';

    # Template: AgentForward
    $Hash{'Article type'} = 'Huomautustyyppi';
    $Hash{'Date'} = '';
    $Hash{'End forwarded message'} = '';
    $Hash{'Forward article of ticket'} = 'Välitä tiketin artikkeli';
    $Hash{'Forwarded message from'} = '';
    $Hash{'Reply-To'} = '';

    # Template: AgentHistoryForm
    $Hash{'History of'} = '';

    # Template: AgentMailboxTicket
    $Hash{'Add Note'} = 'Lisää huomautus';
    $Hash{'CustomerID'} = 'AsiakasID#';

    # Template: AgentNavigationBar
    $Hash{'FAQ'} = '';
    $Hash{'Locked tickets'} = 'Lukitut tiketit';
    $Hash{'new message'} = 'uusi viesti';
    $Hash{'PhoneView'} = 'Puhelunäkymä';
    $Hash{'Preferences'} = 'Käyttäjäasetukset';
    $Hash{'Utilities'} = 'Etsi';

    # Template: AgentNote
    $Hash{'Add note to ticket'} = 'Lisää huomautus tähän tikettiin';
    $Hash{'Note!'} = '';

    # Template: AgentOwner
    $Hash{'Change owner of ticket'} = '';
    $Hash{'Message for new Owner'} = '';
    $Hash{'New user'} = '';

    # Template: AgentPhone
    $Hash{'Customer called'} = '';
    $Hash{'Phone call'} = 'Puhelut';
    $Hash{'Phone call at %s'} = '';

    # Template: AgentPhoneNew
    $Hash{'A message should have a From: recipient!'} = '';
    $Hash{'new ticket'} = 'Uusi tiketti';
    $Hash{'New ticket via call.'} = '';
    $Hash{'You need a email address (e. g. customer@example.com) in From:!'} = '';

    # Template: AgentPlain
    $Hash{'ArticleID'} = '';
    $Hash{'Plain'} = 'Pelkkä teksti';
    $Hash{'TicketID'} = '';

    # Template: AgentPreferencesCustomQueue
    $Hash{'Select your custom queues'} = 'Valitse erityinen jonotuslista';

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
    $Hash{'Change Password'} = 'Vaihda salasana';
    $Hash{'New password'} = 'Uusi salasana';
    $Hash{'New password again'} = 'Kirjoita salasana uudelleen';

    # Template: AgentPriority
    $Hash{'Change priority of ticket'} = 'Muuta prioriteettiä';
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
    $Hash{'Ticket locked!'} = 'Tiketti lukittu!';
    $Hash{'unlock'} = 'poista lukitus';

    # Template: AgentUtilSearchByCustomerID
    $Hash{'Customer history search'} = 'Asiakashistoriahaku';
    $Hash{'Customer history search (e. g. "ID342425").'} = 'Asiakashistoriahaku (Esim. "ID342425").';
    $Hash{'No * possible!'} = 'Jokerimerkki (*) ei käytössä !';

    # Template: AgentUtilSearchByText
    $Hash{'Article free text'} = '';
    $Hash{'Fulltext search'} = 'Tekstihaku';
    $Hash{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Tekstihaku("Etsi esimerkiksi "Mi*a" tai "Petr+Tekrat"';
    $Hash{'Search in'} = '';
    $Hash{'Ticket free text'} = '';

    # Template: AgentUtilSearchByTicketNumber
    $Hash{'search'} = 'Etsi';
    $Hash{'search (e. g. 10*5155 or 105658*)'} = 'etsi tikettinumerolla (Esim. 10*5155 or 105658*)';

    # Template: AgentUtilSearchNavBar
    $Hash{'Results'} = '';
    $Hash{'Site'} = '';
    $Hash{'Total hits'} = 'Hakutuloksia yhteensä';

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
    $Hash{'Click here to report a bug!'} = 'Klikkaa tästä lähettääksesi bugiraportti!';
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
    $Hash{'New Ticket'} = '';
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
    $Hash{'No Permission'} = 'Ei käyttöoikeutta';

    # Template: Notify
    $Hash{'Info'} = '';

    # Template: QueueView
    $Hash{'All tickets'} = 'Tikettejä yhteensä';
    $Hash{'Queues'} = 'Jonotuslista';
    $Hash{'Show all'} = 'Yhteensä';
    $Hash{'Ticket available'} = 'Tikettejä avoinna';
    $Hash{'tickets'} = 'tikettiä';
    $Hash{'Tickets shown'} = 'Tikettejä näkyvissä';

    # Template: SystemStats
    $Hash{'Graphs'} = 'Grafiikat';
    $Hash{'Tickets'} = '';

    # Template: Test
    $Hash{'OTRS Test Page'} = '';

    # Template: TicketEscalation
    $Hash{'Ticket escalation!'} = 'Tiketin maksimi hyväksyttävä käsittelyaika!';

    # Template: TicketView
    $Hash{'Change queue'} = 'Vaihda jonotuslistaa';
    $Hash{'Compose Answer'} = 'Vastaa';
    $Hash{'Contact customer'} = 'Ota yhteyttä asiakkaaseen';
    $Hash{'phone call'} = 'Puhelut';
    $Hash{'Time till escalation'} = 'Aikaa jäljellä maksimi käsittelyaikaan';

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
    $Hash{'(Click here to add a group)'} = '(Klikkaa tästä luodaksesi ryhmän)';
    $Hash{'(Click here to add a queue)'} = '(Klikkaa tästä tehdäksesi uuden jonotuslistan)';
    $Hash{'(Click here to add a response)'} = '(Klikkaa tästä lisätäksesi vastauspohjan)';
    $Hash{'(Click here to add a salutation)'} = '(Klikkaa tästä lisätäksesi tervehdyksen)';
    $Hash{'(Click here to add a signature)'} = '(Klikkaa täältä lisätäksesi allekirjoituksen)';
    $Hash{'(Click here to add a system email address)'} = '(Klikkaa tästä lisätäksesi järjestelmän sähköpostiosoitteen)';
    $Hash{'(Click here to add a user)'} = '(Klikkaa tästä lisätäksesi käyttäjän';
    $Hash{'(Click here to add an auto response)'} = '(Klikkaa tästä lisätäksesi automaattivastauksen)';
    $Hash{'(Click here to add charset)'} = 'Klikkaa tästä lisätäksesi kirjaisinasetuksen';
    $Hash{'(Click here to add language)'} = '(Klikkaa tästä lisätäksesi uusi kieli)';
    $Hash{'(Click here to add state)'} = '(Klikkaa tästä lisätäksesi uusi status)';
    $Hash{'Update auto response'} = '';
    $Hash{'Update charset'} = 'Päivitä kirjaisinasetukset';
    $Hash{'Update group'} = 'Päivitä ryhmätiedot';
    $Hash{'Update language'} = 'Päivitä kieli';
    $Hash{'Update queue'} = 'Päivitä jonotuslista';
    $Hash{'Update response'} = 'Päivitä vastauspohja';
    $Hash{'Update salutation'} = 'Päivitä tervehdys';
    $Hash{'Update signature'} = 'Päivitä allekirjoitus';
    $Hash{'Update state'} = 'Päivitä status';
    $Hash{'Update system address'} = 'Päivitä järjestelmän sähköpostiosoitetta';
    $Hash{'Update user'} = 'Päivitä käyttäjätiedot';
    $Hash{'You have to be in the admin group!'} = '';
    $Hash{'You have to be in the stats group!'} = '';
    $Hash{'auto responses set'} = '';

    $Self->{Translation} = \%Hash;

}
# --
1;
