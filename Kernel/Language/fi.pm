# --
# Kernel/Language/fi.pm - provides fi language translation
# Copyright (C) 2002 Antti Kämäräinen <antti at seu.net>
# --
# $Id: fi.pm,v 1.6 2003-01-03 19:54:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::fi;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Fri Jan  3 20:39:54 2003 by 

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
      'Cancel' => '',
      'Change' => 'Muuta',
      'change' => 'muuta',
      'change!' => 'muuta!',
      'click here' => 'klikkaa tästä',
      'Comment' => 'Kommentti',
      'Customer' => 'Asiakas',
      'Customer info' => 'Tietoa asiakkaasta',
      'day' => 'päivä',
      'days' => 'päivää',
      'Description' => 'Selitys',
      'description' => 'Selitys',
      'Don\'t work with UserID 1 (System account)! Create new users!' => '',
      'Done' => '',
      'end' => 'Loppuun',
      'Error' => 'Virhe',
      'Example' => 'Esimerkki',
      'Examples' => 'Esimerkit',
      'Facility' => '',
      'Feature not acitv!' => '',
      'go' => 'mene',
      'go!' => 'mene!',
      'Group' => 'Ryhmä',
      'Hit' => 'Hit',
      'Hits' => '',
      'hour' => 'tunti',
      'hours' => 'tuntia',
      'Ignore' => '',
      'invalid' => '',
      'Invalid SessionID!' => '',
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
      'No' => 'Ei',
      'no' => 'ei',
      'No suggestions' => '',
      'none' => 'ei mitään',
      'none - answered' => 'ei mitään - vastattu',
      'none!' => 'ei mitään!',
      'off' => 'pois',
      'Off' => 'Pois',
      'On' => 'Päällä',
      'on' => 'päällä',
      'Password' => 'Salasana',
      'Pending till' => '',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Vastaa tähän viestiin saadaksesi se takaisin normaalille jonotuslistalle',
      'Please contact your admin' => '',
      'please do not edit!' => 'Älä muokkaa, kiitos!',
      'possible' => '',
      'QueueView' => 'Jonotuslistanäkymä',
      'reject' => '',
      'replace with' => '',
      'Reset' => '',
      'Salutation' => 'Tervehdys',
      'Signature' => 'Allekirjoitus',
      'Sorry' => 'Anteeksi',
      'Stats' => 'Tilastot',
      'Subfunction' => 'Alifunktio',
      'submit' => 'lähetä',
      'submit!' => 'lähetä!',
      'Text' => 'Teksti',
      'The recommended charset for your language is %s!' => '',
      'Theme' => '',
      'There is no account with that login name.' => '',
      'Timeover' => '',
      'top' => 'ylös',
      'update' => 'päivitä',
      'update!' => 'päivitä!',
      'User' => 'Käyttäjä',
      'Username' => 'Käyttäjänimi',
      'Valid' => 'Käytössä',
      'Warning' => '',
      'Welcome to OTRS' => '',
      'Word' => '',
      'wrote' => 'kirjoittaa',
      'yes' => 'kyllä',
      'Yes' => 'Kyllä',
      'You got new message!' => '',
      'You have %s new message(s)!' => '',
      'You have %s reminder ticket(s)!' => '',

    # Template: AAAMonth
      'Apr' => '',
      'Aug' => '',
      'Dec' => '',
      'Feb' => '',
      'Jan' => '',
      'Jul' => '',
      'Jun' => '',
      'Mar' => '',
      'May' => '',
      'Nov' => '',
      'Oct' => '',
      'Sep' => '',

    # Template: AAAPreferences
      'Custom Queue' => '',
      'Follow up notification' => '',
      'Frontend' => '',
      'Mail Management' => '',
      'Move notification' => '',
      'New ticket notification' => '',
      'Other Options' => '',
      'Preferences updated successfully!' => '',
      'QueueView refresh time' => '',
      'Select your frontend Charset.' => '',
      'Select your frontend language.' => '',
      'Select your frontend QueueView.' => '',
      'Select your frontend Theme.' => '',
      'Select your QueueView refresh time.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Lähetä ilmoitus jatkokysymyksistä, jos olen kyseisen tiketin omistaja',
      'Send me a notification if a ticket is moved into a custom queue.' => '',
      'Send me a notification if a ticket is unlocked by the system.' => '',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Lähetä ilmoitus uusista tiketeistä, jotka tulevat valitsemilleni jonotuslistoille',
      'Ticket lock timeout notification' => '',

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
      'Attachments' => '',
      'Bcc' => '',
      'Bounce' => 'Delekoi',
      'Cc' => 'Kopio',
      'Close' => 'Sulje',
      'closed successful' => 'Valmistui - Sulje',
      'closed unsuccessful' => 'Keskeneräinen - Sulje',
      'Compose' => 'uusia viesti',
      'Created' => 'Luotu',
      'Createtime' => 'Luontiaika',
      'email' => 'sähköposti',
      'eMail' => '',
      'email-external' => 'Sähköposti-sisäinen',
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
      'note-internal' => 'Huomautus - sisäinen',
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
      'Queue' => '',
      'removed' => 'poistettu',
      'Sender' => 'Lähettäjä',
      'sms' => '',
      'State' => 'Status',
      'Subject' => 'Otsikko',
      'This is a' => 'Tämä on',
      'This is a HTML email. Click here to show it.' => 'Tämä sähköposti on HTML-muodossa. Klikkaa tästä katsoaksesi sitä',
      'This message was written in a character set other than your own.' => 'Tämä teksti on kirjoitettu eri kirjaisinasetuksilla kuin omasi',
      'Ticket' => 'Ticket',
      'To' => 'Vastaanottaja',
      'to open it in a new window.' => 'avataksesi se uuteen ikkunaan.',
      'Unlock' => 'Poista lukitus',
      'very high' => 'Erittäin kiireellinen',
      'very low' => 'Erittäin alhainen',
      'View' => 'Katso',
      'webrequest' => '',
      'Zoom' => 'Katso',

    # Template: AAAWeekDay
      'Fri' => '',
      'Mon' => '',
      'Sat' => '',
      'Sun' => '',
      'Thu' => '',
      'Tue' => '',
      'Wed' => '',

    # Template: AdminAttachmentForm
      'Add attachment' => '',
      'Attachment Management' => '',
      'Change attachment settings' => '',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Lisää automaattivastaus',
      'Auto Response From' => '',
      'Auto Response Management' => 'Automaattivastausten hallinta',
      'Change auto response settings' => 'Muuta automaattivastausten asetuksia',
      'Charset' => '',
      'Note' => '',
      'Response' => 'Vastaa',
      'to get the first 20 character of the subject' => '',
      'to get the first 5 lines of the email' => '',
      'to get the from line of the email' => '',
      'to get the realname of the sender (if given)' => '',
      'to get the ticket number of the ticket' => '',
      'Type' => '',
      'Useable options' => 'Käytettävät asetukset',

    # Template: AdminCharsetForm
      'Add charset' => 'Lisää kirjaisinasetus',
      'Change system charset setting' => 'Muuta kirjaisinasetuksia',
      'System Charset Management' => 'Järjestelmän kirjaisinasetusten hallinta',

    # Template: AdminCustomerUserForm
      'Add customer user' => '',
      'Change customer user settings' => '',
      'Customer User Management' => '',
      'Customer user will be needed to to login via customer panels.' => '',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => '',
      'Body' => '',
      'OTRS-Admin Info!' => '',
      'Recipents' => '',

    # Template: AdminEmailSent
      'Message sent to' => '',

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
      'System Log' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => '',
      'AgentFrontend' => 'Tukinäkymä',
      'Auto Response <-> Queue' => 'Automaattivastaukset <-> Jonotuslista',
      'Auto Responses' => 'Automaattivastaukset',
      'Charsets' => '',
      'Customer User' => '',
      'Email Addresses' => 'Sähköpostiosoitteet',
      'Groups' => 'Ryhmät',
      'Logout' => 'Kirjaudu ulos',
      'Misc' => '',
      'POP3 Account' => '',
      'Responses' => 'Vastaukset',
      'Responses <-> Queue' => 'Vastaukset <-> Jonotuslista',
      'Select Box' => '',
      'Session Management' => 'Istuntojen hallinta',
      'Status defs' => '',
      'System' => '',
      'User <-> Groups' => '',

    # Template: AdminPOP3Form
      'Add POP3 Account' => '',
      'All incoming emails with one account will be dispatched in the selected queue!' => '',
      'Change POP3 Account setting' => '',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => '',
      'Login' => '',
      'POP3 Account Management' => '',
      'Trusted' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Jonotuslista <-> Automaattivastaushallinta',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '',
      '0 = no unlock' => '',
      'Add queue' => 'Lisää jonotuslista',
      'Change queue settings' => 'Muuta jonotuslistan asetuksia',
      'Escalation time' => 'Maksimi käsittelyaika',
      'Follow up Option' => '',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
      'Key' => 'Key',
      'Queue Management' => 'Jonotuslistan Hallinta',
      'Systemaddress' => '',
      'The salutation for email answers.' => '',
      'The signature for email answers.' => '',
      'Ticket lock after a follow up' => '',
      'Unlock timeout' => 'Aika lukituksen poistumiseen',
      'Will be the sender address of this queue for email answers.' => '',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => '',
      'Std. Responses <-> Queue Management' => 'Oletusvastaukset <-> Jonotuslista',

    # Template: AdminQueueResponsesForm
      'Answer' => '',
      'Change answer <-> queue settings' => 'Vaihda vastaus <-> Jonotuslista',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => '',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => '',

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
      'Limit' => '',
      'Select Box Result' => '',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'Tapa kaikki istunnot',

    # Template: AdminSessionTable
      'kill session' => 'Tapa istunto',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Add signature' => 'Lisää allekirjoitus',
      'Change signature settings' => 'Muuta allekirjoitusasetuksia',
      'for agent firstname' => 'käsittelijän etunimi',
      'for agent lastname' => 'käsittelijän sukunimi',
      'Signature Management' => 'Allekirjoitusten hallinta',

    # Template: AdminStateForm
      'Add state' => 'Lisää status',
      'Change system state setting' => 'Ändere System-State',
      'System State Management' => 'Tilamahdollisuuksien määrittäminen',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Lisää järjestelmän sähköpostiosoite',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle eingehenden Emails mit dem "To:" werden in die ausgewählte Queue einsortiert.',
      'Change system address setting' => 'Muuta järjestelmän sähköpostiasetuksia',
      'Email' => 'Sähköposti',
      'Realname' => '',
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
      'Bounce ticket' => '',
      'Bounce to' => '',
      'Inform sender' => '',
      'Next ticket state' => 'Uusi tiketin status',
      'Send mail!' => 'Lähetä sähköposti!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Laita vastaanottajakenttään sähköpostiosoite!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => '',

    # Template: AgentClose
      ' (work units)' => '',
      'Close ticket' => '',
      'Close type' => '',
      'Close!' => '',
      'Note Text' => '',
      'Note type' => 'Viestityyppi',
      'store' => 'tallenna',
      'Time units' => '',

    # Template: AgentCompose
      'A message should have a subject!' => 'Viestissä pitää olla otsikko!',
      'Attach' => '',
      'Compose answer for ticket' => 'Lähetä vastaus tikettiin',
      'for pending* states' => '',
      'Is the ticket answered' => '',
      'Options' => '',
      'Pending Date' => '',
      'Spell Check' => '',

    # Template: AgentCustomer
      'Back' => 'Takaisin',
      'Change customer of ticket' => '',
      'Set customer id of a ticket' => 'Aseta tiketin asiakasnumero#',

    # Template: AgentCustomerHistory
      'Customer history' => '',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
      'Customer Data' => '',

    # Template: AgentForward
      'Article type' => 'Huomautustyyppi',
      'Date' => '',
      'End forwarded message' => '',
      'Forward article of ticket' => 'Välitä tiketin artikkeli',
      'Forwarded message from' => '',
      'Reply-To' => '',

    # Template: AgentHistoryForm
      'History of' => '',

    # Template: AgentMailboxNavBar
      'All messages' => '',
      'CustomerID' => 'AsiakasID#',
      'down' => '',
      'Mailbox' => '',
      'New' => '',
      'New messages' => '',
      'Open' => '',
      'Open messages' => '',
      'Order' => '',
      'Pending messages' => '',
      'Reminder' => '',
      'Reminder messages' => '',
      'Sort by' => '',
      'Tickets' => '',
      'up' => '',

    # Template: AgentMailboxTicket
      'Add Note' => 'Lisää huomautus',

    # Template: AgentNavigationBar
      'FAQ' => '',
      'Locked tickets' => 'Lukitut tiketit',
      'new message' => 'uusi viesti',
      'PhoneView' => 'Puhelunäkymä',
      'Preferences' => 'Käyttäjäasetukset',
      'Utilities' => 'Etsi',

    # Template: AgentNote
      'Add note to ticket' => 'Lisää huomautus tähän tikettiin',
      'Note!' => '',

    # Template: AgentOwner
      'Change owner of ticket' => '',
      'Message for new Owner' => '',
      'New user' => '',

    # Template: AgentPending
      'Pending date' => '',
      'Pending type' => '',
      'Set Pending' => '',

    # Template: AgentPhone
      'Customer called' => '',
      'Phone call' => 'Puhelut',
      'Phone call at %s' => '',

    # Template: AgentPhoneNew
      'new ticket' => 'Uusi tiketti',

    # Template: AgentPlain
      'ArticleID' => '',
      'Plain' => 'Pelkkä teksti',
      'TicketID' => '',

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
      'New state' => '',

    # Template: AgentSpelling
      'Apply these changes' => '',
      'Discard all changes and return to the compose screen' => '',
      'Return to the compose screen' => '',
      'Spell Checker' => '',
      'spelling error(s)' => '',
      'The message being composed has been closed.  Exiting.' => '',
      'This window must be called from compose window' => '',

    # Template: AgentStatusView
      'D' => '',
      'sort downward' => '',
      'sort upward' => '',
      'Ticket limit:' => '',
      'Ticket Status' => '',
      'U' => '',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Tiketti lukittu!',
      'unlock' => 'poista lukitus',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Asiakashistoriahaku',
      'Customer history search (e. g. "ID342425").' => 'Asiakashistoriahaku (Esim. "ID342425").',
      'No * possible!' => 'Jokerimerkki (*) ei käytössä !',

    # Template: AgentUtilSearchByText
      'Article free text' => '',
      'Fulltext search' => 'Tekstihaku',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Tekstihaku("Etsi esimerkiksi "Mi*a" tai "Petr+Tekrat"',
      'Search in' => '',
      'Ticket free text' => '',

    # Template: AgentUtilSearchByTicketNumber
      'search' => 'Etsi',
      'search (e. g. 10*5155 or 105658*)' => 'etsi tikettinumerolla (Esim. 10*5155 or 105658*)',

    # Template: AgentUtilSearchNavBar
      'Results' => '',
      'Site' => '',
      'Total hits' => 'Hakutuloksia yhteensä',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All open tickets' => '',
      'open tickets' => '',
      'Provides an overview of all' => '',
      'So you see what is going on in your system.' => '',

    # Template: CustomerCreateAccount
      'Create' => '',
      'Create Account' => '',

    # Template: CustomerError
      'Backend' => '',
      'BackendMessage' => '',
      'Click here to report a bug!' => 'Klikkaa tästä lähettääksesi bugiraportti!',
      'Handle' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => '',
      'Home' => '',
      'Online-Support' => '',
      'Products' => '',
      'Support' => '',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => '',
      'Request new password' => '',

    # Template: CustomerMessage
      'Follow up' => '',

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => '',
      'My Tickets' => '',
      'New Ticket' => '',
      'Ticket-Overview' => '',
      'Welcome %s' => '',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'of' => '',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom
      'Accounted time' => '',

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
      'next step' => '',

    # Template: InstallerSystem
      '(Email of the system admin)' => '',
      '(Full qualified domain name of your system)' => '',
      '(Logfile just needed for File-LogModule!)' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => '',
      '(Used log backend)' => '',
      '(Used ticket number format)' => '',
      'Default Charset' => '',
      'Default Language' => '',
      'Logfile' => '',
      'LogModule' => '',
      'Organization' => '',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => '',
      'Webfrontend' => '',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Ei käyttöoikeutta',

    # Template: Notify
      'Info' => '',

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
      'OTRS Test Page' => '',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Tiketin maksimi hyväksyttävä käsittelyaika!',

    # Template: TicketView
      'Change queue' => 'Vaihda jonotuslistaa',
      'Compose Answer' => 'Vastaa',
      'Contact customer' => 'Ota yhteyttä asiakkaaseen',
      'Escalation in' => '',
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
      'New ticket via call.' => '',
      'Time till escalation' => 'Aikaa jäljellä maksimi käsittelyaikaan',
      'Update auto response' => '',
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
      'You have to be in the admin group!' => '',
      'You have to be in the stats group!' => '',
      'You need a email address (e. g. customer@example.com) in From:!' => '',
      'auto responses set' => '',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
