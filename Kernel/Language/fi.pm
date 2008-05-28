# --
# Kernel/Language/fi.pm - provides fi language translation
# Copyright (C) 2002 Antti Kämäräinen <antti at seu.net>
# Update (C) 2007 Mikko Hynninen <first.last at cence.fi>
# --
# $Id: fi.pm,v 1.62.2.2 2008-05-28 08:03:42 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::fi;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.62.2.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Tue May 29 15:14:00 2007

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateFormatShort} = '%D.%M.%Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Kyllä',
        'No' => 'Ei',
        'yes' => 'kyllä',
        'no' => 'ei',
        'Off' => 'Pois',
        'off' => 'pois',
        'On' => 'Päällä',
        'on' => 'päällä',
        'top' => 'ylös',
        'end' => 'Loppuun',
        'Done' => 'Valmis',
        'Cancel' => 'Peruuta',
        'Reset' => 'Tyhjennä',
        'last' => 'viimeinen',
        'before' => 'edellinen',
        'day' => 'päivä',
        'days' => 'päivää',
        'day(s)' => 'päivä(ä)',
        'hour' => 'tunti',
        'hours' => 'tuntia',
        'hour(s)' => 'tunti(a)',
        'minute' => 'minutti',
        'minutes' => 'minuuttia',
        'minute(s)' => 'minuutti(a)',
        'month' => 'kuukausi',
        'months' => 'kuukautta',
        'month(s)' => 'kuukautta',
        'week' => 'viikko',
        'week(s)' => 'viikkoa',
        'year' => 'vuosi',
        'years' => 'vuotta',
        'year(s)' => 'vuotta',
        'second(s)' => 'sekuntia',
        'seconds' => 'sekuntia',
        'second' => 'sekunti',
        'wrote' => 'kirjoittaa',
        'Message' => 'Viesti',
        'Error' => 'Virhe',
        'Bug Report' => 'Lähetä bugiraportti',
        'Attention' => 'Huomio',
        'Warning' => 'Varoitus',
        'Module' => 'Moduuli',
        'Modulefile' => 'Moduulitiedosto',
        'Subfunction' => 'Alifunktio',
        'Line' => 'Rivi',
        'Example' => 'Esimerkki',
        'Examples' => 'Esimerkit',
        'valid' => 'Kelvollinen',
        'invalid' => 'Virheellinen',
        '* invalid' => '* virheellinen',
        'invalid-temporarily' => '',
        ' 2 minutes' => ' 2 Minuuttia',
        ' 5 minutes' => ' 5 Minuuttia',
        ' 7 minutes' => ' 7 Minuuttia',
        '10 minutes' => '10 Minuuttia',
        '15 minutes' => '15 Minuuttia',
        'Mr.' => 'Mr.',
        'Mrs.' => 'Mrs.',
        'Next' => 'Seuraava',
        'Back' => 'Takaisin',
        'Next...' => 'Seuraava...',
        '...Back' => '...Edellinen',
        '-none-' => '-tyhjä-',
        'none' => 'ei mitään',
        'none!' => 'ei mitään!',
        'none - answered' => 'ei mitään - vastattu',
        'please do not edit!' => 'Älä muokkaa, kiitos!',
        'AddLink' => 'Lisää linkki',
        'Link' => 'Linkki',
        'Linked' => 'Linkitetty',
        'Link (Normal)' => 'Linkki (Normaali)',
        'Link (Parent)' => 'Linkki (Ylempi)',
        'Link (Child)' => 'Linkki (Alempi)',
        'Normal' => 'Normaali',
        'Parent' => 'Ylempi',
        'Child' => 'Alempi',
        'Hit' => 'Osuma',
        'Hits' => 'Osumat',
        'Text' => 'Teksti',
        'Lite' => 'Kevyt',
        'User' => 'Käyttäjä',
        'Username' => 'Käyttäjänimi',
        'Language' => 'Kieli',
        'Languages' => 'Kielet',
        'Password' => 'Salasana',
        'Salutation' => 'Tervehdys',
        'Signature' => 'Allekirjoitus',
        'Customer' => 'Asiakas',
        'CustomerID' => 'AsiakasID#',
        'CustomerIDs' => 'AsiakasIDt',
        'customer' => 'asiakas',
        'agent' => 'agentti',
        'system' => 'järjestelmä',
        'Customer Info' => 'Tietoa asiakkaasta',
        'Customer Company' => 'Asiakasyritys',
        'Company' => 'Yritys',
        'go!' => 'mene!',
        'go' => 'mene',
        'All' => 'Kaikki',
        'all' => 'kaikki',
        'Sorry' => 'Anteeksi',
        'update!' => 'päivitä!',
        'update' => 'päivitä',
        'Update' => 'Päivätä!',
        'submit!' => 'lähetä!',
        'submit' => 'lähetä',
        'Submit' => 'Lähetä',
        'change!' => 'muuta!',
        'Change' => 'Muuta',
        'change' => 'muuta',
        'click here' => 'klikkaa tästä',
        'Comment' => 'Kommentti',
        'Valid' => 'Käytössä',
        'Invalid Option!' => 'Virheellinen valinta!',
        'Invalid time!' => 'Virheellinen aika!',
        'Invalid date!' => 'Virheellinen päiväys',
        'Name' => 'Nimi',
        'Group' => 'Ryhmä',
        'Description' => 'Selitys',
        'description' => 'Selitys',
        'Theme' => 'Ulkoasu',
        'Created' => 'Luotu',
        'Created by' => 'Luonut',
        'Changed' => 'Muutettu',
        'Changed by' => 'Muuttanut',
        'Search' => 'Etsi',
        'and' => 'ja',
        'between' => 'välillä',
        'Fulltext Search' => 'Kokosanahaku',
        'Data' => 'Tieto',
        'Options' => 'Asetukset',
        'Title' => 'Otsikko',
        'Item' => '',
        'Delete' => 'Poista',
        'Edit' => 'Muokkaa',
        'View' => 'Katso',
        'Number' => 'Numero',
        'System' => 'Järjestelmä',
        'Contact' => 'Yhteystiedot',
        'Contacts' => 'Yhteystiedot',
        'Export' => 'Vie',
        'Up' => 'Ylös',
        'Down' => 'Alas',
        'Add' => 'Lisää',
        'Category' => 'Kategoria',
        'Viewer' => 'Katselija',
        'New message' => 'Uusi viesti',
        'New message!' => 'Uusi viesti!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Vastaa tähän viestiin saadaksesi se takaisin normaalille jonotuslistalle',
        'You got new message!' => 'Sinulla on uusi viesti!',
        'You have %s new message(s)!' => 'Sinulla on %s kpl uusia viestiä!',
        'You have %s reminder ticket(s)!' => 'Sinulla on %s muistutettavaa viestiä!',
        'The recommended charset for your language is %s!' => 'Suositeltava kirjainasetus kielellesi on %s',
        'Passwords doesn\'t match! Please try it again!' => 'Salasana ei täsmää! Ole hyvä ja yritä uudestaan!',
        'Password is already in use! Please use an other password!' => 'Salasana on jo käytössä! Ole hyvä ja käytä toista salasanaa!',
        'Password is already used! Please use an other password!' => 'Salasana on jo käytössä! Ole hyvä ja käytä toista salasanaa!',
        'You need to activate %s first to use it!' => 'Sinun tulee aktivoida %s ennen käyttöä',
        'No suggestions' => 'Ei ehdotusta',
        'Word' => 'Sana',
        'Ignore' => 'Ohita',
        'replace with' => 'Korvaa',
        'There is no account with that login name.' => 'Käyttäjätunnus tuntematon',
        'Login failed! Your username or password was entered incorrectly.' => 'Kirjautuminen epäonnistui! Käyttäjätunnus tai salasanan virheellinen.',
        'Please contact your admin' => 'Ota yhteyttä ylläpitäjääsi',
        'Logout successful. Thank you for using OTRS!' => 'Uloskirjautuminen onnistui. Kiitos kun käytit OTRS-järjestelmää',
        'Invalid SessionID!' => 'Virheellinen SessionID',
        'Feature not active!' => 'Ominaisuus ei käytössä',
        'Login is needed!' => 'Käyttäjätunnus on pakollinen!',
        'Password is needed!' => 'Salasana on pakollinen!',
        'License' => 'Lisenssi',
        'Take this Customer' => 'Valitse tämä asiakas',
        'Take this User' => 'Valitse tämä käyttäjä',
        'possible' => 'Käytössä',
        'reject' => 'Hylkää',
        'reverse' => 'käänteinen',
        'Facility' => '',
        'Timeover' => 'Vanhentuu',
        'Pending till' => 'Odottaa',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Ei toimi käyttäjäID:llä 1(järjestelmätunnus). Tee uusia käyttäjiä ',
        'Dispatching by email To: field.' => '',
        'Dispatching by selected Queue.' => '',
        'No entry found!' => 'Tietoa ei löytynyt!',
        'Session has timed out. Please log in again.' => 'Istunto on vanhentunut. Ole hyvä ja kirjaudu uudestaan.',
        'No Permission!' => 'Ei oikeutta!',
        'To: (%s) replaced with database email!' => 'Vastaanottaja: (%s) korvattu tietokannasta löytyvällä!',
        'Cc: (%s) added database email!' => 'CC: (%s) korvattu tietokannasta löytyvältä!',
        '(Click here to add)' => '(Paina tästä lisätäksesi)',
        'Preview' => 'Esikatselu',
        'Package not correctly deployed! You should reinstall the Package again!' => '',
        'Added User "%s"' => 'Käyttäjä %s lisätty',
        'Contract' => 'Sopimus',
        'Online Customer: %s' => 'Kirjautuneet asiakkaat: %s',
        'Online Agent: %s' => 'Kirjautuneet agentit: %s',
        'Calendar' => 'Kalenteri',
        'File' => 'Tiedosto',
        'Filename' => 'Tiedostonimi',
        'Type' => 'Tyyppi',
        'Size' => 'Koko',
        'Upload' => '',
        'Directory' => 'Hakemisto',
        'Signed' => 'Allekirjoitettu',
        'Sign' => 'Allekirjoita',
        'Crypted' => 'Salattu',
        'Crypt' => 'Salaa',
        'Office' => 'Toimisto',
        'Phone' => 'Puhelin',
        'Fax' => 'Faksi',
        'Mobile' => 'GSM',
        'Zip' => 'Postinumero',
        'City' => 'Kaupunki',
        'Country' => 'Maa',
        'installed' => 'asennettu',
        'uninstalled' => 'poistettu',
        'Security Note: You should activate %s because application is already running!' => 'Turvailmoitus: Aktivoi %s - järjestelmä on jo käytössä!',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => 'tulostettu',

        # Template: AAAMonth
        'Jan' => 'Tam',
        'Feb' => 'Hel',
        'Mar' => 'Maa',
        'Apr' => 'Huh',
        'May' => 'Tou',
        'Jun' => 'Kesä',
        'Jul' => 'Hei',
        'Aug' => 'Elo',
        'Sep' => 'Syys',
        'Oct' => 'Loka',
        'Nov' => 'Mar',
        'Dec' => 'Jou',
        'January' => 'Tammikuu',
        'February' => 'Helmikuu',
        'March' => 'Maaliskuu',
        'April' => 'Huhtikuu',
        'June' => 'Kesäkuu',
        'July' => 'Heinäkuu',
        'August' => 'Elokuu',
        'September' => 'Syyskuu',
        'October' => 'Lokakuu',
        'November' => 'Marraskuu',
        'December' => 'Joulukuu',

        # Template: AAANavBar
        'Admin-Area' => 'Ylläpito',
        'Agent-Area' => 'Agentti-alue',
        'Ticket-Area' => 'Tiketti-alue',
        'Logout' => 'Kirjaudu ulos',
        'Agent Preferences' => 'Agentin asetukset',
        'Preferences' => 'Käyttäjäasetukset',
        'Agent Mailbox' => 'Postilaatikko',
        'Stats' => 'Tilastot',
        'Stats-Area' => 'Tilastot',
        'Admin' => 'Ylläpito',
        'Customer Users' => 'Asiakaskäyttäjät',
        'Customer Users <-> Groups' => 'Asiakaskäyttäjät <-> Ryhmät',
        'Users <-> Groups' => 'Käyttäjät <-> Ryhmät',
        'Roles' => 'Roolit',
        'Roles <-> Users' => 'Roolit <-> Käyttäjät',
        'Roles <-> Groups' => 'Roolit <-> Ryhmät',
        'Salutations' => 'Tervehdykset',
        'Signatures' => 'Allekirjoitukset',
        'Email Addresses' => 'Sähköpostit',
        'Notifications' => 'Huomautukset',
        'Category Tree' => 'Kategoriapuu',
        'Admin Notification' => 'Admin huomautukset',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Asetukset tallennettu onnistuneesti',
        'Mail Management' => 'Osoitteiden hallinta',
        'Frontend' => 'Käyttöliittymä',
        'Other Options' => 'Muita asetuksia',
        'Change Password' => 'Vaihda salasana',
        'New password' => 'Uusi salasana',
        'New password again' => 'Salasana uudestaan',
        'Select your QueueView refresh time.' => 'Valitse jonotusnäkymän päivitysaika',
        'Select your frontend language.' => 'Valitse käyttöliittymän kieli',
        'Select your frontend Charset.' => 'Valitse käyttöliittymän kirjaisinasetukset',
        'Select your frontend Theme.' => 'Valitse käyttöliittymäsi ulkoasu',
        'Select your frontend QueueView.' => 'Valitse käyttöliittymäsi jonotusnäkymä',
        'Spelling Dictionary' => 'Oikolukusanasto',
        'Select your default spelling dictionary.' => 'Valitse oletus oikeinkirjoituksentarkistus.',
        'Max. shown Tickets a page in Overview.' => 'Näytä maks. tikettiä päänäkymässä',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Salasanan päivitys ei onnistunut, salasanat eivät täsmää. Yritä uudestaan.',
        'Can\'t update password, invalid characters!' => 'Salasanan päivitys ei onnistunut, virheellisiä merkkejä.',
        'Can\'t update password, need min. 8 characters!' => 'Salasanan päivitys ei onnistunut, minimi 8 merkkiä.',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Salasanan päivitys ei onnistunut, vähintään 2 isoa ja 2 pientä kirjainta.',
        'Can\'t update password, need min. 1 digit!' => 'Salasanan päivitys ei onnistunut, vähintään 1 numero.',
        'Can\'t update password, need min. 2 characters!' => 'Salasanan päivitys ei onnistunut, vähintään 2 kirjainta.',

        # Template: AAAStats
        'Stat' => 'Tilasto',
        'Please fill out the required fields!' => 'Ole hyvä ja täytä vaaditut kentät!',
        'Please select a file!' => 'Valitse tiedosto!',
        'Please select an object!' => 'Valitse objekti!',
        'Please select a graph size!' => 'Valitse graafin koko!',
        'Please select one element for the X-axis!' => 'Valitse yksi elementti X-akselille!',
        'You have to select two or more attributes from the select field!' => 'Sinun tulee valita yksi tai useampi arvo valintakentässä!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => '',
        'If you use a checkbox you have to select some attributes of the select field!' => '',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
        'The selected end time is before the start time!' => 'Valittu lopetusaika ennen aloitusaikaa!',
        'You have to select one or more attributes from the select field!' => '',
        'The selected Date isn\'t valid!' => 'Valittu päiväys ei kelvollinen!',
        'Please select only one or two elements via the checkbox!' => 'Valitse vain yksi tai kaksi elementtiä!',
        'If you use a time scale element you can only select one element!' => 'Jos valitset aikaväliasetuksen voit valita vain yhden elementin!',
        'You have an error in your time selection!' => 'Aikavalinta on virheellinen!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Raportoinnin aikaväli on liian pieni, valitse pidempi aikaväli!',
        'The selected start time is before the allowed start time!' => 'Valittu aloitusaika on suurempi kuin sallittu aloitusaika!',
        'The selected end time is after the allowed end time!' => 'Valittu lopetusaika on sallitun ajan jälkeen!',
        'The selected time period is larger than the allowed time period!' => 'Valittu aikaväli on suurempi kuin sallittu aikaväli!',
        'Common Specification' => 'Yleiset määritykset',
        'Xaxis' => 'Xakseli',
        'Value Series' => 'Arvosarja',
        'Restrictions' => 'Rajoitukset',
        'graph-lines' => '',
        'graph-bars' => '',
        'graph-hbars' => '',
        'graph-points' => '',
        'graph-lines-points' => '',
        'graph-area' => '',
        'graph-pie' => '',
        'extended' => 'laajennettu',
        'Agent/Owner' => 'Agentti/Omistaja',
        'Created by Agent/Owner' => 'Luonut Agentti/Omistaja',
        'Created Priority' => 'Luontiprioriteetti',
        'Created State' => 'Luontitila',
        'Create Time' => 'Luontiaika',
        'CustomerUserLogin' => 'Asiakastunnus',
        'Close Time' => 'Sulkemisaika',

        # Template: AAATicket
        'Lock' => 'Lukitse',
        'Unlock' => 'Poista lukitus',
        'History' => 'Historia',
        'Zoom' => 'Katso',
        'Age' => 'Ikä',
        'Bounce' => 'Delekoi',
        'Forward' => 'Välitä',
        'From' => 'Lähettäjä',
        'To' => 'Vastaanottaja',
        'Cc' => 'Kopio',
        'Bcc' => 'Piilokopio',
        'Subject' => 'Otsikko',
        'Move' => 'Siirrä',
        'Queue' => 'Jonotuslista',
        'Priority' => 'Prioriteetti',
        'State' => 'Tila',
        'Compose' => 'uusia viesti',
        'Pending' => 'Odottaa',
        'Owner' => 'Omistaja',
        'Owner Update' => 'Päivitä omistaja',
        'Responsible' => 'Vastaava',
        'Responsible Update' => 'Vastaavan päivitys',
        'Sender' => 'Lähettäjä',
        'Article' => 'Artikkeli',
        'Ticket' => 'Tiketti',
        'Createtime' => 'Luontiaika',
        'plain' => 'pelkkä teksti',
        'Email' => 'Sähköposti',
        'email' => 'sähköpostiosoite',
        'Close' => 'Sulje',
        'Action' => 'Tapahtumat',
        'Attachment' => 'Liitetiedosto',
        'Attachments' => 'Liitetiedostot',
        'This message was written in a character set other than your own.' => 'Tämä teksti on kirjoitettu eri kirjaisinasetuksilla kuin omasi',
        'If it is not displayed correctly,' => 'Jos tämä ei näy oikein,',
        'This is a' => 'Tämä on',
        'to open it in a new window.' => 'avataksesi se uuteen ikkunaan.',
        'This is a HTML email. Click here to show it.' => 'Tämä sähköposti on HTML-muodossa. Klikkaa tästä katsoaksesi sitä',
        'Free Fields' => 'Vapaakentät',
        'Merge' => 'Liitä',
        'merged' => 'liitetty',
        'closed successful' => 'Valmistui - Sulje',
        'closed unsuccessful' => 'Keskeneräinen - Sulje',
        'new' => 'uusi',
        'open' => 'avoin',
        'closed' => 'suljettu',
        'removed' => 'poistettu',
        'pending reminder' => 'Muistutus',
        'pending auto' => 'odottava autom.',
        'pending auto close+' => 'Automaattisulkeminen+',
        'pending auto close-' => 'Automaattisulkeminen-',
        'email-external' => 'Sähköposti - sisäinen',
        'email-internal' => 'Sähköposti - julkinen',
        'note-external' => 'Huomautus - sisäinen',
        'note-internal' => 'Huomautus - ulkoinen',
        'note-report' => 'Huomautus - raportti',
        'phone' => 'puhelimitse',
        'sms' => 'tekstiviesti',
        'webrequest' => 'web-pyyntö',
        'lock' => 'lukittu',
        'unlock' => 'poista lukitus',
        'very low' => 'Erittäin alhainen',
        'low' => 'Alhainen',
        'normal' => 'Normaali',
        'high' => 'Kiireellinen',
        'very high' => 'Erittäin kiireellinen',
        '1 very low' => '1 Erittäin alhainen',
        '2 low' => '2 Alhainen',
        '3 normal' => '3 Normaali',
        '4 high' => '4 Kiireellinen',
        '5 very high' => '5 Erittäin kiireellinen',
        'Ticket "%s" created!' => 'Tiketti "%s" luotu!',
        'Ticket Number' => 'Tiketin numero',
        'Ticket Object' => 'Tiketti',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ei tikettiä numerolla"%s"! Valitse toinen.',
        'Don\'t show closed Tickets' => 'Älä näytä suljettuja tikettejä',
        'Show closed Tickets' => 'Näytä suljetut',
        'New Article' => 'Uusi artikkeli',
        'Email-Ticket' => 'Sähköposti',
        'Create new Email Ticket' => 'Luo uusi sähköpostitiketti',
        'Phone-Ticket' => 'Puhelin',
        'Search Tickets' => 'Etsi tikettejä',
        'Edit Customer Users' => 'Muokkaa asiakaskäyttäjää',
        'Bulk-Action' => 'Bulk-tehtävä',
        'Bulk Actions on Tickets' => '',
        'Send Email and create a new Ticket' => 'Lähetä sähklöposti ja luo uusi tiketti',
        'Create new Email Ticket and send this out (Outbound)' => 'Luo uusi sähköpostitiketti ja lähetä se ulos',
        'Create new Phone Ticket (Inbound)' => 'Luo uusi puhelimitse tullut tiketti',
        'Overview of all open Tickets' => 'Yleisnäkymä kaikista avoimista tiketeistä',
        'Locked Tickets' => 'Lukitut tiketit',
        'Watched Tickets' => 'Valvotut tiketit',
        'Watched' => 'Valvotut',
        'Subscribe' => 'Kirjaudu',
        'Unsubscribe' => 'Poista kirjautuminen',
        'Lock it to work on it!' => 'Tee lukitus käsitelläksesi',
        'Unlock to give it back to the queue!' => 'Pura lukitus siirtääksesi takaisin jonoon!',
        'Shows the ticket history!' => 'Näytä tiketin historia!',
        'Print this ticket!' => 'Tulosta tämä tiketti!',
        'Change the ticket priority!' => 'Muuta tiketin prioriteettiä!',
        'Change the ticket free fields!' => 'Muuta tiketin vapaakenttiä!',
        'Link this ticket to an other objects!' => 'Liitä tiketti toiseen objektiin!',
        'Change the ticket owner!' => 'Vaihda tiketin omistaja!',
        'Change the ticket customer!' => 'Vaihda tiketin asiakas!',
        'Add a note to this ticket!' => 'Lisää huomautus tähän tikettiin!',
        'Merge this ticket!' => 'Liitä tämä tiketti!',
        'Set this ticket to pending!' => 'Aseta tiketti odottamaan!',
        'Close this ticket!' => 'Sulje tiketti!',
        'Look into a ticket!' => 'Katso tikettiä!',
        'Delete this ticket!' => 'Poista tämä tiketti!',
        'Mark as Spam!' => 'Merkitse roskapostiksi!',
        'My Queues' => 'Jononi',
        'Shown Tickets' => 'Näytetyt tiketit ',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Sähköpostisi tikettinumerolla "<OTRS_TICKET>" on liitetty tikettiin "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Tiketti %s: ensimmäinen vastausaika ylitetty (%s)',
        'Ticket %s: first response time will be over in %s!' => 'Tiketti %s: ensimmäinen vastaus suoritettava %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiketti %s: päivitysaika ylitetty (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiketti %s: Päivityssuoritettava viimeistään %s! ',
        'Ticket %s: solution time is over (%s)!' => 'Tiketti %s: Ratkaisuaika ylitetty (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiketti %s: Ratkaisuaika päättyy %s!',
        'There are more escalated tickets!' => '',
        'New ticket notification' => 'Ilmoitus uusista viesteistä',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Lähetä minulle ilmoitus jos minun jonoihini saapuu uusi tiketti',
        'Follow up notification' => 'Ilmoitus jatkokysymyksistä',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Lähetä ilmoitus jatkokysymyksistä, jos olen kyseisen tiketin omistaja',
        'Ticket lock timeout notification' => 'Ilmoitus tiketin lukituksen vanhenemisesta',
        'Send me a notification if a ticket is unlocked by the system.' => 'Lähetä minulle ilmoitus, jos järjestelmä poistaa tiketin lukituksen.',
        'Move notification' => 'Siirrä ilmoitus',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Lähetä minulle ilmoitus jos tiketti siirretään minun jonoihini',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Suosikkijonojen valinta. Saat sähköpostiilmoituksen näihin jonoihin saapuneista tiketeistä, jos niin asetettu.',
        'Custom Queue' => 'Valitsemasi jonotuslistat',
        'QueueView refresh time' => 'Jonotusnäkymän päivitysaika',
        'Screen after new ticket' => 'Näkymä tiketin luonnin jälkeen',
        'Select your screen after creating a new ticket.' => 'Valitse näkymä uuden tiketin luonnin jälkeen.',
        'Closed Tickets' => 'Suljetut tiketit',
        'Show closed tickets.' => 'Näytä suljetut tiketit.',
        'Max. shown Tickets a page in QueueView.' => 'Maks. näytettyjä tikettejä jononäkymässä.',
        'CompanyTickets' => 'Asiakastiketit',
        'MyTickets' => 'MinunTiketit',
        'New Ticket' => 'Uusi tiketti',
        'Create new Ticket' => 'Luo uusi tiketti',
        'Customer called' => 'Asiakas otti yhteyttä',
        'phone call' => 'puhelu',
        'Responses' => 'Vastaukset',
        'Responses <-> Queue' => 'Vastaukset <-> Jono',
        'Auto Responses' => 'Autom. vastaukset',
        'Auto Responses <-> Queue' => 'Autom. vastaukset <-> Jono',
        'Attachments <-> Responses' => 'Liitteet <-> Vastaukset',
        'History::Move' => 'Tiketti siirretty jonoon "%s" (%s) Jonosta "%s" (%s).',
        'History::TypeUpdate' => 'Päivitetty tyyppi %s (ID=%s).',
        'History::ServiceUpdate' => 'Päivitetty palvelu %s (ID=%s).',
        'History::SLAUpdate' => 'Päivitetty SLA %s (ID=%s).',
        'History::NewTicket' => 'Uusi tiketti [%s] luotu (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp for [%s]. %s',
        'History::SendAutoReject' => 'AutoReject sent to "%s".',
        'History::SendAutoReply' => 'AutomVastaus lähetetty "%s".',
        'History::SendAutoFollowUp' => 'AutoFollowUp lähetetty osoitteeseen "%s".',
        'History::Forward' => 'Ohjattu "%s".',
        'History::Bounce' => 'Palautettu (Bounced) osoitteeseen "%s".',
        'History::SendAnswer' => 'Sähköposti lähetetty "%s".',
        'History::SendAgentNotification' => '"%s"-huomautus lähetetty "%s".',
        'History::SendCustomerNotification' => 'Huomautus lähetetty "%s".',
        'History::EmailAgent' => 'Sähköposti lähetetty asiakkaalle.',
        'History::EmailCustomer' => 'Lisätty sähköposti. %s',
        'History::PhoneCallAgent' => 'Agentti otti yhteyttä asiakkaaseen.',
        'History::PhoneCallCustomer' => 'Asiakas otti meihin yhteyttä.',
        'History::AddNote' => 'Lisätty huomautus (%s)',
        'History::Lock' => 'Lukittu tiketti.',
        'History::Unlock' => 'Lukitus purettu.',
        'History::TimeAccounting' => '%s aikayksikköä lisätty. Kokonaisaika on nyt %s aikayksikköä.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Päivitetty: %s',
        'History::PriorityUpdate' => 'Päivitetty prioriteetti vanha "%s" (%s), uusi "%s" (%s).',
        'History::OwnerUpdate' => 'Uusi omistaja on "%s" (ID=%s).',
        'History::LoopProtection' => 'Viestiloopin esto! Ei automaattivastausta lähetetty "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Päivitetty: %s',
        'History::StateUpdate' => 'Vanha: "%s" Uusi: "%s"',
        'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Customer request via web.',
        'History::TicketLinkAdd' => 'Added link to ticket "%s".',
        'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Su',
        'Mon' => 'Ma',
        'Tue' => 'Ti',
        'Wed' => 'Ke',
        'Thu' => 'To',
        'Fri' => 'Pe',
        'Sat' => 'La',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Liitetiedostojen hallinta',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Automaattivastausten hallinta',
        'Response' => 'Vastaa',
        'Auto Response From' => 'Automaattivastaus ',
        'Note' => 'Huomautus',
        'Useable options' => 'Käytettävät asetukset',
        'To get the first 20 character of the subject.' => 'Saadaksesi ensimmäiset 20 merkkiä otsikosta.',
        'To get the first 5 lines of the email.' => 'Saadaksesi viisi riviä viestistä.',
        'To get the realname of the sender (if given).' => 'Saadaksesi lähettäjän nimitieto (jos asetettu).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Saadaksesi artikkelin asetukset (esim. <OTRS_CUSTOMER_From, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> ja <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Asetukset nykyiselle asiakastiedolle (esim. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Tiketin omistajaasetukset (esim. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Tiketin vastaavaasetus (esim. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Asetukset nykyiselle käyttäjälle joka pyysi tehtävää (esim. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Asiakasyrityksien hallinta',
        'Add Customer Company' => 'Lisää asiakasyritys',
        'Add a new Customer Company.' => 'Lisää uusi asiakasyritys.',
        'List' => 'Listaa',
        'This values are required.' => 'Pakollinen tieto.',
        'This values are read only.' => 'Tämä kenttä on lukutyyppinen',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Asiakas-käyttäjien hallinta',
        'Search for' => 'Etsi',
        'Add Customer User' => 'Lisää asiakaskäyttäjä',
        'Source' => 'Lähde',
        'Create' => 'Luo',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Asiakaskäyttäjä tulee luoda asiakashistoriaa ja kirjautumista varten.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Asiakaskäyttäjä <-> Ryhmähallinta',
        'Change %s settings' => 'Muuta %s asetuksia',
        'Select the user:group permissions.' => 'Valitse käyttäjä:ryhmä oikeudet.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Jos valintaa ei ole tehty, ei oikeuksia tässä ryhmässä (tiketit eivät näy käyttäjälle).',
        'Permission' => 'Käyttöoikeus',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Vain lukuoikeus tiketteihin tässä ryhmässä/jonossa.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' => 'Täysi luku ja kirjoitusoikeus tiketteihin tässä ryhmässä/jonossa.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserServiceChangeForm
        'Customer Users <-> Services Management' => '',
        'Select the customeruser:service relations.' => '',
        'Allocate services to CustomerUser' => '',
        'Allocate CustomerUser to service' => '',

        # Template: AdminCustomerUserServiceForm
        'Edit default services.' => '',

        # Template: AdminEmail
        'Message sent to' => 'Viesti lähetetty, vastaanottaja: ',
        'Recipents' => 'Vastaanottajat',
        'Body' => 'Runko-osa',
        'Send' => 'Lähetä',

        # Template: AdminGenericAgent
        'GenericAgent' => '',
        'Job-List' => '',
        'Last run' => '',
        'Run Now!' => 'Aja',
        'x' => 'x',
        'Save Job as?' => 'Tallenna nimellä',
        'Is Job Valid?' => '',
        'Is Job Valid' => '',
        'Schedule' => 'Aikataulu',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Kokosanahaku artikkeleista (esim "Mar*ku tai "Penti*")',
        '(e. g. 10*5155 or 105658*)' => '(esim. 10*5155 tai 105658*)',
        '(e. g. 234321)' => '(esim. 234321',
        'Customer User Login' => 'Asiakaskirjautuminen',
        '(e. g. U5150)' => '(esim. U5150)',
        'Agent' => 'Agentti',
        'Ticket Lock' => 'Tiketti lukittu',
        'TicketFreeFields' => 'Tiketin vapaakentät',
        'Create Times' => 'Luontiajat',
        'No create time settings.' => '',
        'Ticket created' => 'Tiketti luotu',
        'Ticket created between' => 'Tiketti luotu välillä',
        'Pending Times' => 'Odotusajat',
        'No pending time settings.' => 'Ei odotusaika-asetusta.',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'New Priority' => 'Uusi prioriteetti',
        'New Queue' => 'Uusi jono',
        'New State' => 'Uusi tila',
        'New Agent' => 'Uusi agentti',
        'New Owner' => 'Uusi omistaja',
        'New Customer' => 'Uusi asiakas',
        'New Ticket Lock' => 'Uusi tiketin lukitus',
        'CustomerUser' => 'Asiakaskäyttäjä',
        'New TicketFreeFields' => 'Uusi vapaakenttä',
        'Add Note' => 'Lisää huomautus',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
        'Delete tickets' => 'Poista tiketit',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
        'Send Notification' => 'Lähetä huomautus',
        'Param 1' => '',
        'Param 2' => '',
        'Param 3' => '',
        'Param 4' => '',
        'Param 5' => '',
        'Param 6' => '',
        'Send no notifications' => 'Älä lähetä huomautusta',
        'Yes means, send no agent and customer notifications on changes.' => '',
        'No means, send agent and customer notifications on changes.' => '',
        'Save' => 'Tallenna',
        '%s Tickets affected! Do you really want to use this job?' => '',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'Ryhmien hallinta',
        'Add Group' => 'Lisää ryhmä',
        'Add a new Group.' => 'Lisää uusi ryhmä',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin-ryhmän jäsenet pääsevät ylläpito- ja tilastoalueille.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Lisää uusi käyttäjäryhmä, että voit määritellä käyttöoikeuksia useammille eri tukiryhmille (Huolto, Ostot, Markkinointi jne.)',
        'It\'s useful for ASP solutions.' => 'Tämä on hyödyllinen ASP-käytössä',

        # Template: AdminLog
        'System Log' => 'Järjestelmälogi',
        'Time' => 'Aika',

        # Template: AdminNavigationBar
        'Users' => 'Käyttäjät',
        'Groups' => 'Ryhmät',
        'Misc' => 'Muut',

        # Template: AdminNotificationForm
        'Notification Management' => 'Huomautusten hallinta',
        'Notification' => 'Huomautus',
        'Notifications are sent to an agent or a customer.' => 'Huomautukset lähetetään joko agentille tai käyttäjälle',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakettien hallinta',
        'Uninstall' => 'Poista',
        'Version' => 'Versio',
        'Do you really want to uninstall this package?' => 'Haluatko varmasti poistaa paketin asennuksen?',
        'Reinstall' => 'Uudelleen',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Haluatko varmasti asentaa paketin uudestaan (kaikki manuaaliset asetukset poistuvat)?',
        'Continue' => 'Jatka',
        'Install' => 'Asenna',
        'Package' => 'Paketti',
        'Online Repository' => '',
        'Vendor' => 'Valmistaja',
        'Upgrade' => 'Päivitä',
        'Local Repository' => '',
        'Status' => 'Tila',
        'Overview' => '',
        'Download' => 'Lataa',
        'Rebuild' => '',
        'ChangeLog' => 'Muutokset',
        'Date' => 'Päiväys',
        'Filelist' => 'Tiedostot',
        'Download file from package!' => '',
        'Required' => 'Vaadittu',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => '',
        'This feature is enabled!' => '',
        'Just use this feature if you want to log each request.' => '',
        'Of couse this feature will take some system performance it self!' => '',
        'Disable it here!' => '',
        'This feature is disabled!' => '',
        'Enable it here!' => '',
        'Logfile too large!' => 'Lokitiedosto liian iso!',
        'Logfile too large, you need to reset it!' => 'Lokitiedosto on liian iso, sinun tulee puhdistaa se!',
        'Range' => 'Väli',
        'Interface' => '',
        'Requests' => '',
        'Min Response' => '',
        'Max Response' => '',
        'Average Response' => '',

        # Template: AdminPGPForm
        'PGP Management' => '',
        'Result' => '',
        'Identifier' => '',
        'Bit' => '',
        'Key' => '',
        'Fingerprint' => '',
        'Expires' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' => '',

        # Template: AdminPOP3
        'POP3 Account Management' => 'POP3 -tunnusten hallinta',
        'Host' => 'Palvelin',
        'Trusted' => 'Hyväksytty',
        'Dispatching' => 'Lähetä',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Kaikki saapuvat sähköpostit lähetetään valitulle jonotuslistalle',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '',
        'Filtername' => '',
        'Match' => '',
        'Header' => 'Otsikko',
        'Value' => 'Arvo',
        'Set' => '',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Jono <-> Auotm. vastaustenhallinta',

        # Template: AdminQueueForm
        'Queue Management' => 'Jonotuslistan Hallinta',
        'Sub-Queue of' => 'Ali jono jonolle',
        'Unlock timeout' => 'Aika lukituksen poistumiseen',
        '0 = no unlock' => '0 = ei lukituksen poistumista',
        'Escalation - First Response Time' => 'Käsittely - ensimmäinen vastaus',
        '0 = no escalation' => '0 = ei vanhentumisaikaa',
        'Escalation - Update Time' => 'Käsittely - Päivitysaika',
        'Escalation - Solution Time' => 'Käsittely - Ratkaisuaika',
        'Follow up Option' => 'Seuranta-asetukset',
        'Ticket lock after a follow up' => 'Tiketti lukitaan vastatessa',
        'Systemaddress' => 'Järjestelmän osoite',
        'Customer Move Notify' => 'Siirto ilmoitukset asiakkaalle',
        'Customer State Notify' => 'Tilailmoitukset asiakkaalle',
        'Customer Owner Notify' => 'Omistajan muutokset asiakkaalle',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
        'Escalation time' => 'Maksimi käsittelyaika',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Jos tikettiin ei vastattu tässä ajassa, vain tämä tiketti näytetään.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Jos tiketti on suljettu ja asiakas vastaa siihen - vastaus toimitetaan alkuperäiselle omistajalle.',
        'Will be the sender address of this queue for email answers.' => 'Lähettäjäosoite jonosta lähetetyille sähköposteille.',
        'The salutation for email answers.' => 'Tervehdys sähköpostiviesteissä.',
        'The signature for email answers.' => 'Allekirjoitus sähköpostiviesteissä',
        'OTRS sends an notification email to the customer if the ticket is moved.' => '',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Vastaukset <-> Jonojenhallinta',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Vastaus',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Vastaukset <-> Liitteidenhallinta',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Vastauspohjien hallinta',
        'A response is default text to write faster answer (with default text) to customers.' => 'Vastauspohja on oletusteksti, jonka avulla voit nopeuttaa vastaamista asiakkaille',
        'Don\'t forget to add a new response a queue!' => 'Älä unohda lisätä uutta vastauspohjaa jonotuslistalle.',
        'The current ticket state is' => 'Tiketin status on',
        'Your email address is new' => 'Sinun sähköpostiosoite on uusi',

        # Template: AdminRoleForm
        'Role Management' => 'Roolien hallinta',
        'Add Role' => 'Lisää rooli',
        'Add a new Role.' => 'Lisää uusi rooli.',
        'Create a role and put groups in it. Then add the role to the users.' => 'Lisää rooli ja lisää ryhmiä siihen. Lisää rooli tämän jälkeen käyttäjille.',
        'It\'s useful for a lot of users and groups.' => 'Tämä on kätevä useammalle käyttäjälle ja ryhmälle.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Roolit <-> Ryhmienhallinta',
        'move_into' => '',
        'Permissions to move tickets into this group/queue.' => '',
        'create' => 'lisäys',
        'Permissions to create tickets in this group/queue.' => '',
        'owner' => 'omistaja',
        'Permissions to change the ticket owner in this group/queue.' => '',
        'priority' => 'prioriteetti',
        'Permissions to change the ticket priority in this group/queue.' => '',

        # Template: AdminRoleGroupForm
        'Role' => 'Rooli',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Rooli <-> Käyttäjähallinta',
        'Active' => 'Aktivoi',
        'Select the role:user relations.' => 'Valitse rooli:käyttäjäsuhde.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Tervehdysten hallinta',
        'Add Salutation' => 'Lisää tervehdys',
        'Add a new Salutation.' => 'Lisää uusi tervehdys.',

        # Template: AdminSelectBoxForm
        'Select Box' => 'Suodatus',
        'Limit' => 'Rajoitus',
        'Go' => 'Mene',
        'Select Box Result' => 'Suodatustuloksia',

        # Template: AdminService
        'Service Management' => 'Palveluhallinta',
        'Add Service' => 'Lisää palvelu',
        'Add a new Service.' => 'Lisää uusi palvelu.',
        'Service' => 'Palvelu',
        'Sub-Service of' => 'Alipalvelu palvelulle',

        # Template: AdminSession
        'Session Management' => 'Istuntojen hallinta',
        'Sessions' => 'Istunnot',
        'Uniq' => 'Uniikki',
        'Kill all sessions' => 'Lopeta kaikki istunnot',
        'Session' => 'Istunto',
        'Content' => 'Sisältö',
        'kill session' => 'Lopeta istunto',

        # Template: AdminSignatureForm
        'Signature Management' => 'Allekirjoitusten hallinta',
        'Add Signature' => 'Lisää allekirjoitus',
        'Add a new Signature.' => 'Lisää uusi allekirjoitus.',

        # Template: AdminSLA
        'SLA Management' => 'SLA hallinta',
        'Add SLA' => 'Lisää SLA',
        'Add a new SLA.' => 'Lisää uusi SLA.',
        'SLA' => 'SLA',
        'First Response Time' => 'Ensimmäinen vastausaika',
        'Update Time' => 'Päivitysaika',
        'Solution Time' => 'Ratkaisuaika',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME hallinta',
        'Add Certificate' => 'Lisää sertifikaatti',
        'Add Private Key' => 'Lisää privaattiavain',
        'Secret' => 'Salasana',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => '',

        # Template: AdminStateForm
        'State Management' => 'Tilahallinta',
        'Add State' => 'Lisää tila',
        'Add a new State.' => 'Lisää uusi tila.',
        'State Type' => 'Tilatyyppi',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Muista päivittää oletusstatukset myös Kernel/Config.pm tiedostoon!',
        'See also' => 'Katso myös',

        # Template: AdminSysConfig
        'SysConfig' => 'Hallinta',
        'Group selection' => 'Ryhmävalinta',
        'Show' => 'Näytä',
        'Download Settings' => 'Lataa asetukset',
        'Download all system config changes.' => '',
        'Load Settings' => 'Lataa asetukset',
        'Subgroup' => 'Aliryhmä',
        'Elements' => 'Elementit',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Konfigurointiasetukset',
        'Default' => 'Oletus',
        'New' => 'Uusi',
        'New Group' => 'Uusi ryhmä',
        'Group Ro' => '',
        'New Group Ro' => '',
        'NavBarName' => '',
        'NavBar' => '',
        'Image' => 'Kuva',
        'Prio' => '',
        'Block' => '',
        'AccessKey' => '',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Sähköpostiosoitteiden määritys',
        'Add System Address' => 'Lisää järjestelmäosoite',
        'Add a new System Address.' => 'Lisää uusi järjestelmäosoite.',
        'Realname' => 'Nimi',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Kaikki viestit joissa tämä "Email" (To:)-kenttä.',

        # Template: AdminTypeForm
        'Type Management' => 'Tyyppihallinta',
        'Add Type' => 'Lisää tyyppi',
        'Add a new Type.' => 'Lisää uusi tyyppi.',

        # Template: AdminUserForm
        'User Management' => 'Käyttäjähallinta',
        'Add User' => 'Lisää käyttäjä',
        'Add a new Agent.' => 'Lisää uusi agentti.',
        'Login as' => 'Kirjaudu',
        'Firstname' => 'Etunimi',
        'Lastname' => 'Sukunimi',
        'User will be needed to handle tickets.' => 'Käyttäjä tarvitaan tikettien käsittelemiseen.',
        'Don\'t forget to add a new user to groups and/or roles!' => '',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Käyttäjä <-> Ryhmähallinta',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Osoitekirja',
        'Return to the compose screen' => 'Palaa viestin kirjoitusikkunaan',
        'Discard all changes and return to the compose screen' => 'Hylkää muutokset ja palaa viestin kirjoitusikkunaan',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object' => '',
        'Select' => 'Valitse',
        'Results' => 'Hakutulokset',
        'Total hits' => 'Hakutuloksia yhteensä',
        'Page' => 'Sivu',
        'Detail' => 'Tiedot',

        # Template: AgentLookup
        'Lookup' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Oikeinkirjoituksen tarkistus',
        'spelling error(s)' => 'Kirjoitusvirheitä',
        'or' => 'tai',
        'Apply these changes' => 'Hyväksy muutokset',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Haluatko varmasti poistaa tämän kohteen?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '',
        'Fixed' => 'Kiinteä',
        'Please select only one element or turn off the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => 'Välillä',
        'Relative Period' => '',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '',
        'Permissions' => 'Oikeudet',
        'Format' => 'Muoto',
        'Graphsize' => 'Graafikoko',
        'Sum rows' => 'Summasarakkeet',
        'Sum columns' => 'Summarivit',
        'Cache' => 'Välimuisti',
        'Required Field' => 'Vaaditut kentät',
        'Selection needed' => 'Valinta pakollinen',
        'Explanation' => 'Selitys',
        'In this form you can select the basic specifications.' => '',
        'Attribute' => '',
        'Title of the stat.' => 'Tilaston otsikko.',
        'Here you can insert a description of the stat.' => 'Voit lisätä tähän selityksen tilastolle.',
        'Dynamic-Object' => '',
        'Here you can select the dynamic object you want to use.' => '',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '',
        'Static-File' => '',
        'For very complex stats it is possible to include a hardcoded file.' => '',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => '',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '',
        'Multiple selection of the output format.' => '',
        'If you use a graph as output format you have to select at least one graph size.' => '',
        'If you need the sum of every row select yes' => '',
        'If you need the sum of every column select yes.' => '',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => '',
        '(Note: Useful for big databases and low performance server)' => '',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Valitse arvovälin elementit',
        'Scale' => 'Asteikko',
        'minimal' => 'Minimi',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '',
        'maximal period' => 'maksimijakso',
        'minimal scale' => 'Minimiskaala',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => 'Tuo',
        'File is not a Stats config' => 'Tiedosto ei sisällä tilastointiasetuksia',
        'No File selected' => 'Tiedostoa ei valittu',

        # Template: AgentStatsOverview
        'Object' => 'Objekti',

        # Template: AgentStatsPrint
        'Print' => 'Tulosta',
        'No Element selected.' => 'Ei valittua elementtiä.',

        # Template: AgentStatsView
        'Export Config' => 'Vie asetukset',
        'Information about the Stat' => 'Tietoja tilastosta',
        'Exchange Axis' => 'Vaihda akseleita',
        'Configurable params of static stat' => '',
        'No element selected.' => 'Ei valittua elementtiä.',
        'maximal period from' => '',
        'to' => '',
        'Start' => 'Alku',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Delekoi tiketti',
        'Ticket locked!' => 'Tiketti lukittu!',
        'Ticket unlock!' => 'Lukitus purettu!',
        'Bounce to' => 'Delekoi',
        'Next ticket state' => 'Uusi tiketin status',
        'Inform sender' => 'Informoi lähettäjää',
        'Send mail!' => 'Lähetä sähköposti!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '',
        'Spell Check' => 'Oikeinkirjoituksen tarkistus',
        'Note type' => 'Viestityyppi',
        'Unlock Tickets' => 'Pura lukitus',

        # Template: AgentTicketClose
        'Close ticket' => 'Sulje tiketti',
        'Previous Owner' => 'Edellinen omistaja',
        'Inform Agent' => '',
        'Optional' => 'Valinnainen',
        'Inform involved Agents' => '',
        'Attach' => 'Liite',
        'Next state' => 'Uusi tila',
        'Pending date' => 'Odottaa päivään',
        'Time units' => 'Työaika',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Lähetä vastaus tikettiin',
        'Pending Date' => 'Odotuspäivä',
        'for pending* states' => 'Automaattisulkeminen tai muistutus',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Vaihda tiketin asiakasta',
        'Set customer user and customer id of a ticket' => '',
        'Customer User' => 'Asiakas-käyttäjä',
        'Search Customer' => 'Etsi Asiakas',
        'Customer Data' => 'Asiakastieto',
        'Customer history' => 'Asiakkaan historiatiedot',
        'All customer tickets.' => 'Kaikki asiakastiketit.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Ilmoitukset',

        # Template: AgentTicketEmail
        'Compose Email' => 'Luo sähköposti',
        'new ticket' => 'Uusi tiketti',
        'Refresh' => 'Päivitä',
        'Clear To' => '',

        # Template: AgentTicketForward
        'Article type' => 'Huomautustyyppi',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Vaihda tiketin vapaakenttätietoja',

        # Template: AgentTicketHistory
        'History of' => 'Historia:',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Saapuneet',
        'Tickets' => 'Tiketit',
        'of' => '',
        'Filter' => 'Suodatin',
        'New messages' => 'Uusia viestejä',
        'Reminder' => 'Muistuttaja',
        'Sort by' => 'Järjestä',
        'Order' => 'Järjestys',
        'up' => 'alkuun',
        'down' => 'loppuun',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Liitä tiketti',
        'Merge to' => 'Kohde',

        # Template: AgentTicketMove
        'Move Ticket' => 'Siirrä tiketti',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Lisää huomautus tähän tikettiin',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Muuta tämän tiketin omistajaa',

        # Template: AgentTicketPending
        'Set Pending' => 'Aseta odottaa',

        # Template: AgentTicketPhone
        'Phone call' => 'Puhelut',
        'Clear From' => '',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Pelkkä teksti',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Tikettitieto',
        'Accounted time' => 'Käytetty aikaa',
        'Escalation in' => 'Vanhenee',
        'Linked-Object' => 'Liitetty',
        'Parent-Object' => 'Ylempi',
        'Child-Object' => 'Alempi',
        'by' => '',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Muuta prioriteettiä',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Tikettejä näkyvissä',
        'Tickets available' => 'Tikettejä avoinna',
        'All tickets' => 'Tikettejä yhteensä',
        'Queues' => 'Jonotuslista',
        'Ticket escalation!' => 'Tiketin maksimi hyväksyttävä käsittelyaika!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => 'Palveluaika',
        'Your own Ticket' => 'Oma tiketti',
        'Compose Follow up' => 'Lähetä vastaus',
        'Compose Answer' => 'Vastaa',
        'Contact customer' => 'Ota yhteyttä asiakkaaseen',
        'Change queue' => 'Vaihda jonotuslistaa',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Vaihda tiketistä vastaavan tieto',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Tikettihaku',
        'Profile' => 'Profiili',
        'Search-Template' => 'Hakupohja',
        'TicketFreeText' => 'Vapaakenttä',
        'Created in Queue' => 'Luotu jonossa',
        'Result Form' => 'Vastausmuoto',
        'Save Search-Profile as Template?' => 'Tallenna haku pohjaksi?',
        'Yes, save it with name' => 'Kyllä, tallenna nimellä',

        # Template: AgentTicketSearchResult
        'Search Result' => 'Hakutulos',
        'Change search options' => 'Muuta hakuasetuksia',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort
        'U' => 'Y',
        'D' => 'A',

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Tiketin tilanäkymä',
        'Open Tickets' => 'Avoimet tiketit',
        'Locked' => 'Lukitut',

        # Template: AgentTicketZoom

        # Template: AgentWindowTab

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '',

        # Template: CustomerFooter
        'Powered by' => 'Järjestelmä',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Käyttäjätunnus',
        'Lost your password?' => 'Unohditko salasanan?',
        'Request new password' => 'Pyydä uutta salasanaa',
        'Create Account' => 'Luo tunnus',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Tervetuloa %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Ajat',
        'No time settings.' => 'Ei aika-asetusta.',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klikkaa tästä lähettääksesi bugiraportti!',

        # Template: Footer
        'Top of Page' => 'Mene ylös',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-asennus',
        'Accept license' => 'Hyväksy lisenssi',
        'Don\'t accept license' => 'Älä hyväksy lisenssiä',
        'Admin-User' => 'Admin-käyttäjä',
        'Admin-Password' => 'Admin-salasana',
        'your MySQL DB should have a root password! Default is empty!' => '',
        'Database-User' => 'Tietokantakäyttäjä',
        'default \'hot\'' => '',
        'DB connect host' => '',
        'Database' => 'Tietokanta',
        'false' => '',
        'SystemID' => '',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
        'System FQDN' => '',
        '(Full qualified domain name of your system)' => '',
        'AdminEmail' => 'Ylläpidon sähköposti',
        '(Email of the system admin)' => 'Ylläpitäjän sähköpostiosoite',
        'Organization' => 'Organisaatio',
        'Log' => 'Loki',
        'LogModule' => 'LokiModuuli',
        '(Used log backend)' => '(Lokien säilytystapa)',
        'Logfile' => 'Logitiedosto',
        '(Logfile just needed for File-LogModule!)' => '',
        'Webfrontend' => 'Webnäkymä',
        'Default Charset' => 'Oletuskirjaisinasetus',
        'Use utf-8 it your database supports it!' => 'Käytä utf-8:a jos tietokantasi tukee sitä.',
        'Default Language' => 'Oletuskieli',
        '(Used default language)' => 'Oletuskieli',
        'CheckMXRecord' => 'TarkastaMXTieto',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Tarkista käytettyjen sähköpostiosoitteiden MX tietueet vastattaessa. Älä käytä tätä jos OTRS järjestelmä on hitaan yhteyden takana $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
        'Restart your webserver' => 'Käynnistä web-palvelin uudestaan',
        'After doing so your OTRS is up and running.' => 'Tämän jälkeen OTRS järjestelmä on käytettävissä.',
        'Start page' => 'Aloitussivu',
        'Have a lot of fun!' => '',
        'Your OTRS Team' => 'OTRS Tiimi',

        # Template: Login
        'Welcome to %s' => 'Tervetuloa käyttämään %s',

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ei käyttöoikeutta',

        # Template: Notify
        'Important' => 'Tärkeä',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'tulostaja: ',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS - Testisivu',
        'Counter' => 'Laskuri',

        # Template: Warning
        # Misc
        'Edit Article' => 'Muokkaa artikkelia',
        'Create Database' => 'Luo tietokanta',
        'Ticket Number Generator' => 'Tikettinumeroiden generoija',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
        'Create new Phone Ticket' => 'Luo uusi puhelintiketti',
        'Symptom' => 'Oire',
        'A message should have a To: recipient!' => 'Viestissä pitää olla vastaanottaja!',
        'Site' => 'Palvelin',
        'Customer history search (e. g. "ID342425").' => 'Asiakashistoriahaku (Esim. "ID342425").',
        'Close!' => 'Sulje!',
        'for agent firstname' => 'käsittelijän etunimi',
        'The message being composed has been closed.  Exiting.' => '',
        'A web calendar' => 'Web-kalenteri',
        'to get the realname of the sender (if given)' => 'nähdäksesi käyttäjän nimen',
        'Notification (Customer)' => 'Huomautus (asiakas)',
        'Select Source (for add)' => 'Lisää lähde (lisäykselle)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Home' => 'Etusivu',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Asetusvaihtoehdot (esim. <OTRS_CONFIG_HttpType>)',
        'System History' => 'Järjestelmähistoria',
        'customer realname' => 'käyttäjän oikea nimi',
        'Pending messages' => 'Odottavat viestit',
        'for agent login' => '',
        'Keyword' => 'Avainsanat',
        'Close type' => 'Sulkemisen syy',
        'for agent user id' => '',
        'sort upward' => 'Järjestä nousevasti',
        'Change user <-> group settings' => 'Vaihda käyttäjä <-> Ryhmähallinta',
        'Problem' => 'Ongelma',
        'next step' => 'Seuraava',
        'Customer history search' => 'Asiakashistoriahaku',
        'Admin-Email' => 'Ylläpidon sähköposti',
        'A message must be spell checked!' => 'Viesti täytyy oikolukea!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Sähköposti, tikettinumero "<OTRS_TICKET>" on välitetty osoitteeseen: "<OTRS_BOUNCE_TO>" . Ota yhteyttä kyseiseen osoitteeseen saadaksesi lisätietoja',
        'Mail Account Management' => 'Sähköpostitunnushallinta',
        'ArticleID' => 'ArtikkeliID',
        'A message should have a body!' => 'Viestiin tulee lisätä tietoja',
        'All Agents' => 'Kaikki agentit',
        'Keywords' => 'Avainsanat',
        'No * possible!' => 'Jokerimerkki (*) ei käytössä !',
        'Options ' => 'Asetukset',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Message for new Owner' => 'Viesti uudelle omistajalle',
        'to get the first 5 lines of the email' => 'nähdäksesi 5 ensimmäistä riviä sähköpostista',
        'Last update' => 'Edellinen päivitys',
        'to get the first 20 character of the subject' => 'nähdäksesi ensimmäiset 20 kirjainta otsikosta',
        'Drop Database' => 'Poista tietokanta',
        'FileManager' => 'Tiedostohallinta',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => '',
        'Pending type' => 'Odotustyyppi',
        'Comment (internal)' => 'Kommentti (sisäinen)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'This window must be called from compose window' => '',
        'You need min. one selected Ticket!' => 'Sinun tulee valita vähintään yksi tiketti',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        '(Used ticket number format)' => 'Tikettinumeroiden oletusformaatti',
        'Fulltext' => '',
        ' (work units)' => ' (esim. minuutteina)',
        'All Customer variables like defined in config option CustomerUser.' => '',
        'accept license' => 'Hyväksy lisenssi',
        'for agent lastname' => 'käsittelijän sukunimi',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => '',
        'Reminder messages' => 'Muistutettavat viestit',
        'A message should have a subject!' => 'Viestissä pitää olla otsikko!',
        'IMAPS' => 'IMAPS',
        'Don\'t forget to add a new user to groups!' => 'Älä unohda lisätä käyttäjää ryhmiin!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Laita vastaanottajakenttään sähköpostiosoite!',
        'You need to account time!' => 'Käsittelyaika',
        'System Settings' => 'Järjestelmäasetukset',
        'WebWatcher' => '',
        'Finished' => 'Valmis',
        'Split' => 'Jaa',
        'All messages' => 'Kaikki viestit',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'A article should have a title!' => '',
        'Event' => 'Tapahtyma',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'don\'t accept license' => 'En hyväksy lisenssiä',
        'A web mail client' => 'Webpostiohjelma',
        'WebMail' => 'WebMail',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => '',
        'Name is required!' => 'Nimi on vaadittu!',
        'Termin1' => '',
        'kill all sessions' => 'Lopeta kaikki istunnot',
        'to get the from line of the email' => 'nähdäksesi yhden rivin sähköpostista',
        'Solution' => 'Ratkaisu',
        'QueueView' => 'Jonotuslistanäkymä',
        'Welcome to OTRS' => 'Tervetuloa OTRS:n',
        'modified' => 'Muokannut',
        'sort downward' => 'Järjestä laskevasti',
        'You need to use a ticket number!' => '',
        'A web file manager' => '',
        'send' => 'lähetä',
        'Note Text' => 'Huomautusteksti',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => 'Tilamahdollisuuksien määrittäminen',
        'PhoneView' => 'Puhelu / Uusi tiketti',
        'maximal period form' => '',
        'Verion' => '',
        'TicketID' => 'TikettiID',
        'Management Summary' => '',
        'Modified' => 'Muokattu',
        'Ticket selected for bulk action!' => '',
    };
    # $$STOP$$
    return;
}

1;
