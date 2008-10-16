# --
# Kernel/Language/fi.pm - provides Finnish language translation
# Copyright (C) 2002 Antti K‰m‰r‰inen <antti at seu.net>
# Copyright (C) 2007-2008 Mikko Hynninen <first.last at tietokartano.fi>
# --
# $Id: fi.pm,v 1.81 2008-10-16 14:42:26 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::fi;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.81 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri May 16 14:08:27 2008

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
        'Yes' => 'Kyll‰',
        'No' => 'Ei',
        'yes' => 'kyll‰',
        'no' => 'ei',
        'Off' => 'Pois',
        'off' => 'pois',
        'On' => 'P‰‰ll‰',
        'on' => 'p‰‰ll‰',
        'top' => 'ylˆs',
        'end' => 'Loppuun',
        'Done' => 'Valmis',
        'Cancel' => 'Peruuta',
        'Reset' => 'Tyhjenn‰',
        'last' => 'viimeinen',
        'before' => 'edellinen',
        'day' => 'p‰iv‰',
        'days' => 'p‰iv‰‰',
        'day(s)' => 'p‰iv‰(‰)',
        'hour' => 'tunti',
        'hours' => 'tuntia',
        'hour(s)' => 'tunti(a)',
        'minute' => 'minuutti',
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
        'wrote' => 'kirjoitti',
        'Message' => 'Viesti',
        'Error' => 'Virhe',
        'Bug Report' => 'L‰het‰ bugiraportti',
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
        'invalid-temporarily' => 'virheellinen-v‰likaikaisesti',
        ' 2 minutes' => ' 2 Minuuttia',
        ' 5 minutes' => ' 5 Minuuttia',
        ' 7 minutes' => ' 7 Minuuttia',
        '10 minutes' => '10 Minuuttia',
        '15 minutes' => '15 Minuuttia',
        'Mr.' => 'Mr.',
        'Mrs.' => 'Mrs.',
        'Next' => 'Seuraava',
        'Back' => 'Edellinen',
        'Next...' => 'Seuraava...',
        '...Back' => '...Edellinen',
        '-none-' => '-tyhj‰-',
        'none' => 'ei mit‰‰n',
        'none!' => 'ei mit‰‰n!',
        'none - answered' => 'ei mit‰‰n - vastattu',
        'please do not edit!' => 'ƒl‰ muokkaa, kiitos!',
        'AddLink' => 'Lis‰‰ linkki',
        'Link' => 'Linkki',
        'Unlink' => 'Pura linkki',
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
        'User' => 'K‰ytt‰j‰',
        'Username' => 'K‰ytt‰j‰nimi',
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
        'system' => 'j‰rjestelm‰',
        'Customer Info' => 'Tietoa asiakkaasta',
        'Customer Company' => 'Asiakasyritys',
        'Company' => 'Yritys',
        'go!' => 'mene!',
        'go' => 'mene',
        'All' => 'Kaikki',
        'all' => 'kaikki',
        'Sorry' => 'Anteeksi',
        'update!' => 'p‰ivit‰!',
        'update' => 'p‰ivit‰',
        'Update' => 'P‰iv‰t‰',
        'submit!' => 'l‰het‰!',
        'submit' => 'l‰het‰',
        'Submit' => 'L‰het‰',
        'change!' => 'muuta!',
        'Change' => 'Muuta',
        'change' => 'muuta',
        'click here' => 'klikkaa t‰st‰',
        'Comment' => 'Kommentti',
        'Valid' => 'K‰ytˆss‰',
        'Invalid Option!' => 'Virheellinen valinta!',
        'Invalid time!' => 'Virheellinen aika!',
        'Invalid date!' => 'Virheellinen p‰iv‰ys!',
        'Name' => 'Nimi',
        'Group' => 'Ryhm‰',
        'Description' => 'Kuvaus',
        'description' => 'kuvaus',
        'Theme' => 'Ulkoasu',
        'Created' => 'Luotu',
        'Created by' => 'Luonut',
        'Changed' => 'Muutettu',
        'Changed by' => 'Muuttanut',
        'Search' => 'Etsi',
        'and' => 'ja',
        'between' => 'v‰lill‰',
        'Fulltext Search' => 'Kokosanahaku',
        'Data' => 'Tieto',
        'Options' => 'Asetukset',
        'Title' => 'Otsikko',
        'Item' => 'osio',
        'Delete' => 'Poista',
        'Edit' => 'Muokkaa',
        'View' => 'Katso',
        'Number' => 'Numero',
        'System' => 'J‰rjestelm‰',
        'Contact' => 'Yhteystiedot',
        'Contacts' => 'Yhteystiedot',
        'Export' => 'Vie',
        'Up' => 'Ylˆs',
        'Down' => 'Alas',
        'Add' => 'Lis‰‰',
        'Category' => 'Kategoria',
        'Viewer' => 'Katselija',
        'New message' => 'Uusi viesti',
        'New message!' => 'Uusi viesti!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Vastaa t‰h‰n viestiin saadaksesi se takaisin normaalille jonotuslistalle',
        'You got new message!' => 'Sinulla on uusi viesti!',
        'You have %s new message(s)!' => 'Sinulla on %s kpl uusia viesti‰!',
        'You have %s reminder ticket(s)!' => 'Sinulla on %s muistutettavaa viesti‰!',
        'The recommended charset for your language is %s!' => 'Suositeltava merkistˆ kielellesi on %s',
        'Passwords doesn\'t match! Please try it again!' => 'Salasana ei t‰sm‰‰! Ole hyv‰ ja yrit‰ uudestaan!',
        'Password is already in use! Please use an other password!' => 'Salasana on jo k‰ytˆss‰! Ole hyv‰ ja k‰yt‰ toista salasanaa!',
        'Password is already used! Please use an other password!' => 'Salasana on jo k‰ytˆss‰! Ole hyv‰ ja k‰yt‰ toista salasanaa!',
        'You need to activate %s first to use it!' => 'Sinun tulee aktivoida %s ennen k‰yttˆ‰!',
        'No suggestions' => 'Ei ehdotusta',
        'Word' => 'Sana',
        'Ignore' => 'Ohita',
        'replace with' => 'Korvaa',
        'There is no account with that login name.' => 'Tuntematon k‰ytt‰j‰tunnus.',
        'Login failed! Your username or password was entered incorrectly.' => 'Kirjautuminen ep‰onnistui! K‰ytt‰j‰tunnus tai salasana virheellinen.',
        'Please contact your admin' => 'Ota yhteytt‰ yll‰pitoon',
        'Logout successful. Thank you for using OTRS!' => 'Uloskirjautuminen onnistui. Kiitos kun k‰ytit OTRS-j‰rjestelm‰‰',
        'Invalid SessionID!' => 'Virheellinen istuntotunnus',
        'Feature not active!' => 'Ominaisuus ei k‰ytˆss‰!',
        'Login is needed!' => 'K‰ytt‰j‰tunnus on pakollinen!',
        'Password is needed!' => 'Salasana on pakollinen!',
        'License' => 'Lisenssi',
        'Take this Customer' => 'Valitse t‰m‰ asiakas',
        'Take this User' => 'Valitse t‰m‰ k‰ytt‰j‰',
        'possible' => 'K‰ytˆss‰',
        'reject' => 'Hylk‰‰',
        'reverse' => 'k‰‰nteinen',
        'Facility' => 'Valmius',
        'Timeover' => 'Vanhentuu',
        'Pending till' => 'Odottaa',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Ei toimi k‰ytt‰j‰ID:ll‰ 1(j‰rjestelm‰tunnus). Lis‰‰ uusia k‰ytt‰ji‰!',
        'Dispatching by email To: field.' => 'Osoittaminen perustuen s‰hkˆpostin Vastaanottaja: kentt‰‰n.',
        'Dispatching by selected Queue.' => 'Osoittaminen perustuen valittuun jonoon.',
        'No entry found!' => 'Tietoa ei lˆytynyt!',
        'Session has timed out. Please log in again.' => 'Istuntosi on vanhentunut. Ole hyv‰ ja kirjaudu uudestaan.',
        'No Permission!' => 'Ei oikeutta!',
        'To: (%s) replaced with database email!' => 'Vastaanottaja: (%s) korvattu tietokannasta lˆytyv‰ll‰ osoitteella!',
        'Cc: (%s) added database email!' => 'CC: (%s) lis‰tty tietokannasta lˆyty‰ osoite!',
        '(Click here to add)' => '(Paina t‰st‰ lis‰t‰ksesi)',
        'Preview' => 'Esikatselu',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Paketti k‰yttˆˆnotto ei ole onnistunut! Ole hyv‰ ja asenna paketti uudestaan!',
        'Added User "%s"' => 'K‰ytt‰j‰ %s lis‰tty',
        'Contract' => 'Sopimus',
        'Online Customer: %s' => 'Kirjautuneet asiakkaat: %s',
        'Online Agent: %s' => 'Kirjautuneet agentit: %s',
        'Calendar' => 'Kalenteri',
        'File' => 'Tiedosto',
        'Filename' => 'Tiedostonimi',
        'Type' => 'Tyyppi',
        'Size' => 'Koko',
        'Upload' => 'Tuo',
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
        'Location' => '',
        'Street' => 'Katuosoite',
        'Country' => 'Maa',
        'installed' => 'asennettu',
        'uninstalled' => 'poistettu',
        'Security Note: You should activate %s because application is already running!' => 'Turvailmoitus: Aktivoi %s - j‰rjestelm‰ on jo k‰ytˆss‰!',
        'Unable to parse Online Repository index document!' => 'Online ohjelmistojakelun luettelotiedosto ei saatavilla!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => 'Ei asennettavia paketteja valittuna online ohjelmistojakelusta!',
        'printed at' => 'tulostettu',
        'Dear Mr. %s,' => 'Arvon Hra. %s,',
        'Dear Mrs. %s,' => 'Arvon Rva. %s',
        'Dear %s,' => 'Arvon %s,',
        'Hello %s,' => 'Hei %s,',
        'This account exists.' => 'Tunnus on olemassa.',
        'New account created. Sent Login-Account to %s.' => 'Uusi tunnus lis‰tty. Lƒhet‰ kirjautumistunnus osoitteeseen %s.',
        'Please press Back and try again.' => 'Klikkaa Takaisin ja yrit‰ uudestaan.',
        'Sent password token to: %s' => 'L‰het‰ valtuutusavain osoitteeseen: %s',
        'Sent new password to: %s' => 'L‰het‰ uusi salasana osoitteeseen: %s',
        'Invalid Token!' => 'Virheellinen valtuutusavain!',

        # Template: AAAMonth
        'Jan' => 'Tam',
        'Feb' => 'Hel',
        'Mar' => 'Maa',
        'Apr' => 'Huh',
        'May' => 'Tou',
        'Jun' => 'Kes‰',
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
        'June' => 'Kes‰kuu',
        'July' => 'Hein‰kuu',
        'August' => 'Elokuu',
        'September' => 'Syyskuu',
        'October' => 'Lokakuu',
        'November' => 'Marraskuu',
        'December' => 'Joulukuu',

        # Template: AAANavBar
        'Admin-Area' => 'Yll‰pito',
        'Agent-Area' => 'Agentti-alue',
        'Ticket-Area' => 'Tiketti-alue',
        'Logout' => 'Kirjaudu ulos',
        'Agent Preferences' => 'Agentin asetukset',
        'Preferences' => 'K‰ytt‰j‰asetukset',
        'Agent Mailbox' => 'Postilaatikko',
        'Stats' => 'Tilastot',
        'Stats-Area' => 'Tilastot',
        'Admin' => 'Yll‰pito',
        'Customer Users' => 'Asiakask‰ytt‰j‰t',
        'Customer Users <-> Groups' => 'Asiakask‰ytt‰j‰t <-> Ryhm‰t',
        'Users <-> Groups' => 'K‰ytt‰j‰t <-> Ryhm‰t',
        'Roles' => 'Roolit',
        'Roles <-> Users' => 'Roolit <-> K‰ytt‰j‰t',
        'Roles <-> Groups' => 'Roolit <-> Ryhm‰t',
        'Salutations' => 'Tervehdykset',
        'Signatures' => 'Allekirjoitukset',
        'Email Addresses' => 'S‰hkˆpostiosoitteet',
        'Notifications' => 'Huomautukset',
        'Category Tree' => 'Kategoriapuu',
        'Admin Notification' => 'Admin huomautukset',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Asetukset tallennettu onnistuneesti!',
        'Mail Management' => 'Osoitteiden hallinta',
        'Frontend' => 'K‰yttˆliittym‰',
        'Other Options' => 'Muita asetuksia',
        'Change Password' => 'Vaihda salasana',
        'New password' => 'Uusi salasana',
        'New password again' => 'Salasana uudestaan',
        'Select your QueueView refresh time.' => 'Valitse jonotusn‰kym‰n p‰ivitysaika.',
        'Select your frontend language.' => 'Valitse k‰yttˆliittym‰n kieli.',
        'Select your frontend Charset.' => 'Valitse k‰yttˆliittym‰n merkistˆasetukset.',
        'Select your frontend Theme.' => 'Valitse k‰yttˆliittym‰si ulkoasu',
        'Select your frontend QueueView.' => 'Valitse jonotusn‰kym‰si k‰yttˆliittym‰',
        'Spelling Dictionary' => 'Oikolukusanasto',
        'Select your default spelling dictionary.' => 'Valitse oikeinkirjoitustarkastuksen oletusasetus.',
        'Max. shown Tickets a page in Overview.' => 'N‰yt‰ maks. tiketti‰ yleisn‰kym‰ss‰',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Salasanan p‰ivitys ei onnistunut, salasanat eiv‰t t‰sm‰‰. Yrit‰ uudestaan.',
        'Can\'t update password, invalid characters!' => 'Salasanan p‰ivitys ei onnistunut, virheellisi‰ merkkej‰.',
        'Can\'t update password, need min. 8 characters!' => 'Salasanan p‰ivitys ei onnistunut, minimi 8 merkki‰.',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Salasanan p‰ivitys ei onnistunut, v‰hint‰‰n 2 isoa ja 2 pient‰ kirjainta.',
        'Can\'t update password, need min. 1 digit!' => 'Salasanan p‰ivitys ei onnistunut, v‰hint‰‰n 1 numero.',
        'Can\'t update password, need min. 2 characters!' => 'Salasanan p‰ivitys ei onnistunut, v‰hint‰‰n 2 kirjainta.',

        # Template: AAAStats
        'Stat' => 'Tilasto',
        'Please fill out the required fields!' => 'Ole hyv‰ ja t‰yt‰ vaaditut kent‰t!',
        'Please select a file!' => 'Valitse tiedosto!',
        'Please select an object!' => 'Valitse objekti!',
        'Please select a graph size!' => 'Valitse graafin koko!',
        'Please select one element for the X-axis!' => 'Valitse yksi elementti X-akselille!',
        'You have to select two or more attributes from the select field!' => 'Sinun tulee valita yksi tai useampi arvo valintakent‰ss‰!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Valitse vain yksi elementti tai poista valinta kohdasta \'Kiinte‰\' kohdasta jossa se on valittuna!',
        'If you use a checkbox you have to select some attributes of the select field!' => '',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Tee valinta valitussa kent‰ss‰ tai poista valinta kohdasta \'Kiinte‰\'!',
        'The selected end time is before the start time!' => 'Valittu lopetusaika ennen aloitusaikaa!',
        'You have to select one or more attributes from the select field!' => 'Sinun tulee tehd‰ yksi tai useampi valinta valikosta!',
        'The selected Date isn\'t valid!' => 'Valittu p‰iv‰ys ei kelvollinen!',
        'Please select only one or two elements via the checkbox!' => 'Valitse vain yksi tai kaksi elementti‰!',
        'If you use a time scale element you can only select one element!' => 'Jos valitset aikav‰liasetuksen voit valita vain yhden elementin!',
        'You have an error in your time selection!' => 'Aikavalinta on virheellinen!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Raportoinnin aikav‰li on liian pieni, valitse pidempi aikav‰li!',
        'The selected start time is before the allowed start time!' => 'Valittu aloitusaika on suurempi kuin sallittu aloitusaika!',
        'The selected end time is after the allowed end time!' => 'Valittu lopetusaika on sallitun ajan j‰lkeen!',
        'The selected time period is larger than the allowed time period!' => 'Valittu aikav‰li on suurempi kuin sallittu aikav‰li!',
        'Common Specification' => 'Yleiset m‰‰ritykset',
        'Xaxis' => 'X-akseli',
        'Value Series' => 'Arvosarja',
        'Restrictions' => 'Rajoitukset',
        'graph-lines' => 'kuvaaja-linjat',
        'graph-bars' => 'kuvaaja-tolpat',
        'graph-hbars' => 'kuvaaja-vaakatolpat',
        'graph-points' => 'kuvaaja-pisteet',
        'graph-lines-points' => 'kuvaaja-linjapisteet',
        'graph-area' => 'kuvaaja-alue',
        'graph-pie' => 'kuvaaja-piirakka',
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
        'Age' => 'Ik‰',
        'Bounce' => 'Delekoi',
        'Forward' => 'V‰lit‰',
        'From' => 'L‰hett‰j‰',
        'To' => 'Vastaanottaja',
        'Cc' => 'Kopio',
        'Bcc' => 'Piilokopio',
        'Subject' => 'Otsikko',
        'Move' => 'Siirr‰',
        'Queue' => 'Jonotuslista',
        'Priority' => 'Prioriteetti',
        'Priority Update' => 'Prioriteetin p‰ivitys',
        'State' => 'Tila',
        'Compose' => 'uusia viesti',
        'Pending' => 'Odottaa',
        'Owner' => 'Omistaja',
        'Owner Update' => 'P‰ivit‰ omistaja',
        'Responsible' => 'Vastaava',
        'Responsible Update' => 'Vastaavan p‰ivitys',
        'Sender' => 'L‰hett‰j‰',
        'Article' => 'Artikkeli',
        'Ticket' => 'Tiketti',
        'Createtime' => 'Luontiaika',
        'plain' => 'pelkk‰ teksti',
        'Email' => 'S‰hkˆposti',
        'email' => 's‰hkˆpostiosoite',
        'Close' => 'Sulje',
        'Action' => 'Tapahtumat',
        'Attachment' => 'Liitetiedosto',
        'Attachments' => 'Liitetiedostot',
        'This message was written in a character set other than your own.' => 'T‰m‰ viesti on kirjoitettu tuntemattomalla merkistˆll‰.',
        'If it is not displayed correctly,' => 'Jos t‰m‰ ei n‰y oikein,',
        'This is a' => 'T‰m‰ on',
        'to open it in a new window.' => 'avataksesi se uuteen ikkunaan.',
        'This is a HTML email. Click here to show it.' => 'T‰m‰ viesti on HTML-muodossa. Avaa klikkaamalla t‰st‰.',
        'Free Fields' => 'Vapaakent‰t',
        'Merge' => 'Liit‰',
        'merged' => 'liitetty',
        'closed successful' => 'Valmistui - Sulje',
        'closed unsuccessful' => 'Keskener‰inen - Sulje',
        'new' => 'uusi',
        'open' => 'avoin',
        'closed' => 'suljettu',
        'removed' => 'poistettu',
        'pending reminder' => 'Muistutus',
        'pending auto' => 'odottava autom.',
        'pending auto close+' => 'Automaattisulkeminen+',
        'pending auto close-' => 'Automaattisulkeminen-',
        'email-external' => 'S‰hkˆposti - ulkoinen',
        'email-internal' => 'S‰hkˆposti - sis‰inen',
        'note-external' => 'Huomautus - ulkoinen',
        'note-internal' => 'Huomautus - sis‰inen',
        'note-report' => 'Huomautus - raportti',
        'phone' => 'puhelimitse',
        'sms' => 'tekstiviesti',
        'webrequest' => 'web-pyyntˆ',
        'lock' => 'lukittu',
        'unlock' => 'poista lukitus',
        'very low' => 'Eritt‰in alhainen',
        'low' => 'Alhainen',
        'normal' => 'Normaali',
        'high' => 'Kiireellinen',
        'very high' => 'Eritt‰in kiireellinen',
        '1 very low' => '1 Eritt‰in alhainen',
        '2 low' => '2 Alhainen',
        '3 normal' => '3 Normaali',
        '4 high' => '4 Kiireellinen',
        '5 very high' => '5 Eritt‰in kiireellinen',
        'Ticket "%s" created!' => 'Tiketti "%s" luotu!',
        'Ticket Number' => 'Tiketin numero',
        'Ticket Object' => 'Tiketti',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ei tiketti‰ numerolla "%s"! Valitse toinen.',
        'Don\'t show closed Tickets' => 'ƒl‰ n‰yt‰ suljettuja tikettej‰',
        'Show closed Tickets' => 'N‰yt‰ suljetut tiketit',
        'New Article' => 'Uusi artikkeli',
        'Email-Ticket' => 'S‰hkˆposti',
        'Create new Email Ticket' => 'Luo uusi s‰hkˆpostitiketti',
        'Phone-Ticket' => 'Puhelin',
        'Search Tickets' => 'Etsi tikettej‰',
        'Edit Customer Users' => 'Muokkaa asiakask‰ytt‰j‰‰',
        'Edit Customer Company' => 'Muokkaa asiakasyrityst‰',
        'Bulk-Action' => 'Massatoimenpide',
        'Bulk Actions on Tickets' => 'Messatoimenpide tiketeille',
        'Send Email and create a new Ticket' => 'L‰het‰ s‰hklˆposti ja luo uusi tiketti',
        'Create new Email Ticket and send this out (Outbound)' => 'Luo uusi s‰hkˆpostitiketti ja l‰het‰ se eteenp‰in',
        'Create new Phone Ticket (Inbound)' => 'Luo uusi puhelimitse tullut tiketti',
        'Overview of all open Tickets' => 'Yleisn‰kym‰ kaikista avoimista tiketeist‰',
        'Locked Tickets' => 'Lukitut tiketit',
        'Watched Tickets' => 'Valvotut tiketit',
        'Watched' => 'Valvotut',
        'Subscribe' => 'Kirjaudu',
        'Unsubscribe' => 'Poista kirjautuminen',
        'Lock it to work on it!' => 'Tee lukitus k‰sitell‰ksesi',
        'Unlock to give it back to the queue!' => 'Pura lukitus siirt‰‰ksesi takaisin jonoon!',
        'Shows the ticket history!' => 'N‰yt‰ tiketin historia!',
        'Print this ticket!' => 'Tulosta t‰m‰ tiketti!',
        'Change the ticket priority!' => 'Muuta tiketin prioriteetti‰!',
        'Change the ticket free fields!' => 'Muuta tiketin vapaakentti‰!',
        'Link this ticket to an other objects!' => 'Liit‰ tiketti toiseen objektiin!',
        'Change the ticket owner!' => 'Vaihda tiketin omistaja!',
        'Change the ticket customer!' => 'Vaihda tiketin asiakas!',
        'Add a note to this ticket!' => 'Lis‰‰ huomautus t‰h‰n tikettiin!',
        'Merge this ticket!' => 'Liit‰ t‰m‰ tiketti!',
        'Set this ticket to pending!' => 'Aseta tiketti odottamaan!',
        'Close this ticket!' => 'Sulje tiketti!',
        'Look into a ticket!' => 'Tarkastele tiketti‰!',
        'Delete this ticket!' => 'Poista t‰m‰ tiketti!',
        'Mark as Spam!' => 'Merkitse roskapostiksi!',
        'My Queues' => 'Jononi',
        'Shown Tickets' => 'N‰ytetyt tiketit',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'S‰hkˆpostisi tikettinumerolla "<OTRS_TICKET>" on liitetty tikettiin "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Tiketti %s: ensimm‰inen vastausaika ylittynyt (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Tiketti %s: ensimm‰inen vastaus suoritettava %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiketti %s: p‰ivitysaika ylittynyt (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiketti %s: P‰ivitys suoritettava viimeist‰‰n %s! ',
        'Ticket %s: solution time is over (%s)!' => 'Tiketti %s: Ratkaisuaika ylittynyt (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiketti %s: Ratkaisuaika p‰‰ttyy %s!',
        'There are more escalated tickets!' => 'Useampia k‰sitelt‰vi‰ tikettej‰!',
        'New ticket notification' => 'Ilmoitus uusista viesteist‰',
        'Send me a notification if there is a new ticket in "My Queues".' => 'L‰het‰ minulle ilmoitus jos minun jonoihini saapuu uusi tiketti',
        'Follow up notification' => 'Ilmoitus jatkokysymyksist‰',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'L‰het‰ ilmoitus jatkokysymyksist‰, jos olen kyseisen tiketin omistaja',
        'Ticket lock timeout notification' => 'Ilmoitus tiketin lukituksen vanhenemisesta',
        'Send me a notification if a ticket is unlocked by the system.' => 'L‰het‰ minulle ilmoitus, jos j‰rjestelm‰ poistaa tiketin lukituksen.',
        'Move notification' => 'Siirtoilmoitus',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'L‰het‰ minulle ilmoitus jos tiketti siirret‰‰n minun jonoihini',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Suosikkijonojen valinta. Saat s‰hkˆpostiilmoituksen n‰ihin jonoihin saapuneista tiketeist‰, jos niin asetettu.',
        'Custom Queue' => 'Valitsemasi jonotuslistat',
        'QueueView refresh time' => 'Jonotusn‰kym‰n p‰ivitysaika',
        'Screen after new ticket' => 'N‰kym‰ tiketin luonnin j‰lkeen',
        'Select your screen after creating a new ticket.' => 'Valitse n‰kym‰ uuden tiketin luonnin j‰lkeen.',
        'Closed Tickets' => 'Suljetut tiketit',
        'Show closed tickets.' => 'N‰yt‰ suljetut tiketit.',
        'Max. shown Tickets a page in QueueView.' => 'Maks. n‰ytettyj‰ tikettej‰ jonon‰kym‰ss‰.',
        'CompanyTickets' => 'Asiakastiketit',
        'MyTickets' => 'MinunTiketit',
        'New Ticket' => 'Uusi tiketti',
        'Create new Ticket' => 'Luo uusi tiketti',
        'Customer called' => 'Asiakas otti yhteytt‰',
        'phone call' => 'puhelu',
        'Responses' => 'Vastaukset',
        'Responses <-> Queue' => 'Vastaukset <-> Jono',
        'Auto Responses' => 'Autom. vastaukset',
        'Auto Responses <-> Queue' => 'Autom. vastaukset <-> Jono',
        'Attachments <-> Responses' => 'Liitteet <-> Vastaukset',
        'History::Move' => 'Tiketti siirretty jonoon "%s" (%s) Jonosta "%s" (%s).',
        'History::TypeUpdate' => 'P‰ivitetty tyyppi %s (ID=%s).',
        'History::ServiceUpdate' => 'P‰ivitetty palvelu %s (ID=%s).',
        'History::SLAUpdate' => 'P‰ivitetty SLA %s (ID=%s).',
        'History::NewTicket' => 'Uusi tiketti [%s] luotu (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp for [%s]. %s',
        'History::SendAutoReject' => 'AutoReject sent to "%s".',
        'History::SendAutoReply' => 'AutomVastaus l‰hetetty "%s".',
        'History::SendAutoFollowUp' => 'AutoFollowUp l‰hetetty osoitteeseen "%s".',
        'History::Forward' => 'Ohjattu "%s".',
        'History::Bounce' => 'Palautettu (Bounced) osoitteeseen "%s".',
        'History::SendAnswer' => 'S‰hkˆposti l‰hetetty "%s".',
        'History::SendAgentNotification' => '"%s"-huomautus l‰hetetty "%s".',
        'History::SendCustomerNotification' => 'Huomautus l‰hetetty "%s".',
        'History::EmailAgent' => 'S‰hkˆposti l‰hetetty asiakkaalle.',
        'History::EmailCustomer' => 'Lis‰tty s‰hkˆposti. %s',
        'History::PhoneCallAgent' => 'Agentti otti yhteytt‰ asiakkaaseen.',
        'History::PhoneCallCustomer' => 'Asiakas otti meihin yhteytt‰.',
        'History::AddNote' => 'Lis‰tty huomautus (%s)',
        'History::Lock' => 'Lukittu tiketti.',
        'History::Unlock' => 'Lukitus purettu.',
        'History::TimeAccounting' => '%s aikayksikkˆ‰ lis‰tty. Kokonaisaika on nyt %s aikayksikkˆ‰.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'P‰ivitetty: %s',
        'History::PriorityUpdate' => 'P‰ivitetty prioriteetti vanha "%s" (%s), uusi "%s" (%s).',
        'History::OwnerUpdate' => 'Uusi omistaja on "%s" (ID=%s).',
        'History::LoopProtection' => 'Viestiloopin esto! Automaattivastausta ei l‰hetetty "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'P‰ivitetty: %s',
        'History::StateUpdate' => 'Vanha: "%s" Uusi: "%s"',
        'History::TicketFreeTextUpdate' => 'P‰ivitetty: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Asiakaspyyntˆ webin kautta.',
        'History::TicketLinkAdd' => 'Lis‰tty linkki tikettiin "%s".',
        'History::TicketLinkDelete' => 'Poistettu linkki tikettiin "%s".',
        'History::Subscribe' => 'Lis‰tty seuranta k‰ytt‰j‰lle "%s".',
        'History::Unsubscribe' => 'Poistettu seuranta k‰ytt‰j‰lt‰ "%s".',

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
        'Useable options' => 'K‰ytett‰v‰t asetukset',
        'To get the first 20 character of the subject.' => 'Saadaksesi ensimm‰iset 20 merkki‰ otsikosta.',
        'To get the first 5 lines of the email.' => 'Saadaksesi viisi rivi‰ viestist‰.',
        'To get the realname of the sender (if given).' => 'Saadaksesi l‰hett‰j‰n nimitieto (jos asetettu).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Saadaksesi artikkelin asetukset (esim. <OTRS_CUSTOMER_From, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> ja <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Asetukset nykyiselle asiakastiedolle (esim. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Tiketin omistajaasetukset (esim. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Tiketin vastaavaasetus (esim. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Asetukset nykyiselle k‰ytt‰j‰lle joka pyysi teht‰v‰‰ (esim. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Tikettitietojen m‰‰ritykset (esim. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Asetusm‰‰ritykset (esim. <OTRS_CONFIG_HttpType>)',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Asiakasyrityksien hallinta',
        'Search for' => 'Etsi',
        'Add Customer Company' => 'Lis‰‰ asiakasyritys',
        'Add a new Customer Company.' => 'Lis‰‰ uusi asiakasyritys.',
        'List' => 'Listaa',
        'This values are required.' => 'Pakollinen tieto.',
        'This values are read only.' => 'T‰m‰ kentt‰ on lukutyyppinen',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Asiakas-k‰ytt‰jien hallinta',
        'Add Customer User' => 'Lis‰‰ asiakask‰ytt‰j‰',
        'Source' => 'L‰hde',
        'Create' => 'Luo',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Asiakask‰ytt‰j‰ tulee luoda asiakashistoriaa ja kirjautumista varten.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Asiakask‰ytt‰j‰ <-> Ryhm‰hallinta',
        'Change %s settings' => 'Muuta %s asetuksia',
        'Select the user:group permissions.' => 'Valitse k‰ytt‰j‰:ryhm‰ oikeudet.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Jos valintaa ei ole tehty, ei oikeuksia t‰ss‰ ryhm‰ss‰ (tiketit eiv‰t n‰y k‰ytt‰j‰lle).',
        'Permission' => 'K‰yttˆoikeus',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Vain lukuoikeus tiketteihin t‰ss‰ ryhm‰ss‰/jonossa.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' => 'T‰ysi luku ja kirjoitusoikeus tiketteihin t‰ss‰ ryhm‰ss‰/jonossa.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Asiakask‰ytt‰j‰ <-> Palveluidenhallinta',
        'CustomerUser' => 'Asiakask‰ytt‰j‰',
        'Service' => 'Palvelu',
        'Edit default services.' => 'Muokkaa oletuspalveluita.',
        'Search Result' => 'Hakutulos',
        'Allocate services to CustomerUser' => 'Osoita palveluita asiakask‰ytt‰j‰lle',
        'Active' => 'Aktivoi',
        'Allocate CustomerUser to service' => 'Osoita asiakask‰ytt‰j‰ palveluun',

        # Template: AdminEmail
        'Message sent to' => 'Viesti l‰hetetty, vastaanottaja: ',
        'Recipents' => 'Vastaanottajat',
        'Body' => 'Runko-osa',
        'Send' => 'L‰het‰',

        # Template: AdminGenericAgent
        'GenericAgent' => '',
        'Job-List' => 'Tyˆjono',
        'Last run' => 'Edellinen ajo',
        'Run Now!' => 'Aja',
        'x' => 'x',
        'Save Job as?' => 'Tallenna nimell‰',
        'Is Job Valid?' => 'Onko tyˆ voimassa?',
        'Is Job Valid' => 'Onko tyˆ voimassa',
        'Schedule' => 'Aikataulu',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Kokosanahaku artikkeleista (esim. "Mar*ku tai "Penti*")',
        '(e. g. 10*5155 or 105658*)' => '(esim. 10*5155 tai 105658*)',
        '(e. g. 234321)' => '(esim. 234321)',
        'Customer User Login' => 'Asiakkaan kirjautumistunnus',
        '(e. g. U5150)' => '(esim. U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Agentti',
        'Ticket Lock' => 'Tiketti lukittu',
        'TicketFreeFields' => 'Tiketin vapaakent‰t',
        'Create Times' => 'Luontiajat',
        'No create time settings.' => 'Ei luontiaikaa asetettu.',
        'Ticket created' => 'Tiketti luotu',
        'Ticket created between' => 'Tiketti luotu v‰lill‰',
        'Close Times' => 'Sulkemisajat',
        'No close time settings.' => 'Ei sulkemisaikaa asetettu.',
        'Ticket closed' => 'Tiketti suljettu',
        'Ticket closed between' => 'Tiketti suljetty v‰lill‰',
        'Pending Times' => 'Odotusajat',
        'No pending time settings.' => 'Ei odotusaika-asetusta.',
        'Ticket pending time reached' => 'Tiketin odotusaika saavutettu',
        'Ticket pending time reached between' => 'Tiketin odotusaika saavutettu v‰lill‰',
        'New Service' => 'Uusi palvelu',
        'New SLA' => 'Uusi SLA',
        'New Priority' => 'Uusi prioriteetti',
        'New Queue' => 'Uusi jono',
        'New State' => 'Uusi tila',
        'New Agent' => 'Uusi agentti',
        'New Owner' => 'Uusi omistaja',
        'New Customer' => 'Uusi asiakas',
        'New Ticket Lock' => 'Uusi tiketin lukitus',
        'New Type' => 'Uusi tyyppi',
        'New Title' => 'Uusi otsikko',
        'New Type' => 'Uusi tyyppi',
        'New TicketFreeFields' => 'Uusi vapaakentt‰',
        'Add Note' => 'Lis‰‰ huomautus',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'T‰m‰ komento suoritetaan. ARG[0] tulee olemaan tiketin numero ja ARG[1] tiketin id.',
        'Delete tickets' => 'Poista tiketit',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Varoitus! Tiketti poistetaan tietokannasta! Tiketti‰ ei pysty palauttamaan!',
        'Send Notification' => 'L‰het‰ huomautus',
        'Param 1' => 'Asetus 1',
        'Param 2' => 'Asetus 2',
        'Param 3' => 'Asetus 3',
        'Param 4' => 'Asetus 4',
        'Param 5' => 'Asetus 5',
        'Param 6' => 'Asetus 6',
        'Send no notifications' => 'ƒl‰ l‰het‰ huomautusta',
        'Yes means, send no agent and customer notifications on changes.' => 'Kyll‰ tarkoittaa, ‰l‰ l‰het‰ agentille ja asiakkaalle ilmoitusta muutoksista.',
        'No means, send agent and customer notifications on changes.' => 'Ei tarkoittaa, l‰het‰ agentille ja asiakkaalle ilmoitus muutoksista.',
        'Save' => 'Tallenna',
        '%s Tickets affected! Do you really want to use this job?' => 'Vaikuttaa %s tikettiin! Haluatko varmasti suorittaa t‰m‰n tyˆn?',
        '"}' => '"}',

        # Template: AdminGroupForm
        'Group Management' => 'Ryhmien hallinta',
        'Add Group' => 'Lis‰‰ ryhm‰',
        'Add a new Group.' => 'Lis‰‰ uusi ryhm‰',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin-ryhm‰n j‰senet p‰‰sev‰t yll‰pito- ja tilasto ryhm‰n tilastoalueille.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Lis‰‰ uusi k‰ytt‰j‰ryhm‰ voidaksesi m‰‰ritell‰ k‰yttˆoikeuksia useammille eri tukiryhmille (Huolto, Ostot, Markkinointi jne.)',
        'It\'s useful for ASP solutions.' => 'T‰m‰ on hyˆdyllinen ASP-k‰ytˆss‰',

        # Template: AdminLog
        'System Log' => 'J‰rjestelm‰logi',
        'Time' => 'Aika',

        # Template: AdminMailAccount
        'Mail Account Management' => 'S‰hkˆpostitunnusten hallinta',
        'Host' => 'Palvelin',
        'Trusted' => 'Luotettu',
        'Dispatching' => 'L‰het‰',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Kaikki saapuvat s‰hkˆpostit l‰hetet‰‰n valitulle jonotuslistalle',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Jos tilisi on luotettu, jo aijemmin lis‰ttyj‰ X-OTRS viestin otsikkotietoja (prioriteetti jne.) k‰ytet‰‰n!',

        # Template: AdminNavigationBar
        'Users' => 'K‰ytt‰j‰t',
        'Groups' => 'Ryhm‰t',
        'Misc' => 'Muut',

        # Template: AdminNotificationForm
        'Notification Management' => 'Huomautusten hallinta',
        'Notification' => 'Huomautus',
        'Notifications are sent to an agent or a customer.' => 'Huomautukset l‰hetet‰‰n joko agentille tai asiakkaalle.',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakettien hallinta',
        'Uninstall' => 'Poista',
        'Version' => 'Versio',
        'Do you really want to uninstall this package?' => 'Haluatko varmasti poistaa paketin asennuksen?',
        'Reinstall' => 'Uudelleen asenna',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Haluatko varmasti asentaa paketin uudestaan (kaikki tehdyt muutokset poistuvat)?',
        'Continue' => 'Jatka',
        'Install' => 'Asenna',
        'Package' => 'Paketti',
        'Online Repository' => 'Online ohjelmistojakelu',
        'Vendor' => 'Valmistaja',
        'Upgrade' => 'P‰ivit‰',
        'Local Repository' => 'Paikallinen ohjelmistojakelu',
        'Status' => 'Tila',
        'Overview' => 'Yleisn‰kym‰',
        'Download' => 'Lataa',
        'Rebuild' => 'Rakenna uudelleen',
        'ChangeLog' => 'Muutokset',
        'Date' => 'P‰iv‰ys',
        'Filelist' => 'Tiedostot',
        'Download file from package!' => 'Lataa tiedosto paketista!',
        'Required' => 'Vaadittu',
        'PrimaryKey' => 'P‰‰Avain',
        'AutoIncrement' => 'Autom.Lis‰ys',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Suorityskykylogi',
        'This feature is enabled!' => 'T‰m‰ ominaisuus on k‰ytˆss‰!',
        'Just use this feature if you want to log each request.' => 'K‰yt‰ t‰t‰ ominaisuutta jos haluat kirjata ylˆs kaikki pyynnˆt.',
        'Of couse this feature will take some system performance it self!' => 'T‰m‰ ominaisuus vaatii j‰rjestelm‰n resursseja!',
        'Disable it here!' => 'Poista k‰ytˆst‰ t‰st‰!',
        'This feature is disabled!' => 'T‰m‰ ominaisuus on poissa k‰ytˆst‰!',
        'Enable it here!' => 'Ota k‰yttˆˆn t‰st‰!',
        'Logfile too large!' => 'Lokitiedosto liian iso!',
        'Logfile too large, you need to reset it!' => 'Lokitiedosto on liian iso, sinun tulee puhdistaa se!',
        'Range' => 'V‰li',
        'Interface' => 'Liittym‰',
        'Requests' => 'Kyselyt',
        'Min Response' => 'Min. vastaus',
        'Max Response' => 'Max. vastaus',
        'Average Response' => 'Keskiverto vastaus',
        'Period' => 'Jakso',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Keskiarvo',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP hallinta',
        'Result' => 'Vastaus',
        'Identifier' => 'Tunniste',
        'Bit' => 'Bitti',
        'Key' => 'Avain',
        'Fingerprint' => 'Sormenj‰lki',
        'Expires' => 'Vanhenee',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'T‰ll‰ tavoin voit muokata suoraan SysConfigissa m‰‰ritelty‰ avainrengasta.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Postin suodatusten hallinta',
        'Filtername' => 'Suodattimen nimi',
        'Match' => 'Asetukset',
        'Header' => 'Otsikko',
        'Value' => 'Arvo',
        'Set' => 'Aseta',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Ohjaa tai suodata sis‰‰n tulevia posteja perustuen s‰hkˆpostin X-Headers asetuksiin! RegExpit ovat myˆs sallittuja.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Jos haluat osumia vain s‰hkˆpostiosoitteeseen, k‰yt‰ EMAILADDRESS:info@esimerkki.com:a From, To, tai CC kohdissa.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Jono <-> Autom. vastaustenhallinta',

        # Template: AdminQueueForm
        'Queue Management' => 'Jonotuslistojen hallinta',
        'Sub-Queue of' => 'Alijono jonolle',
        'Unlock timeout' => 'Aika lukituksen poistumiseen',
        '0 = no unlock' => '0 = ei lukituksen poistumista',
        'Only business hours are counted.' => 'Vain tyˆaika huomioidaan',
        'Escalation - First Response Time' => 'K‰sittely - ensimm‰inen vastaus',
        '0 = no escalation' => '0 = ei vanhentumisaikaa',
        'Only business hours are counted.' => 'Vain tyˆaika huomioidaan',
        'Notify by' => 'Huomautuksen l‰hett‰j‰',
        'Escalation - Update Time' => 'K‰sittely - P‰ivitysaika',
        'Notify by' => 'Huomauksen l‰hett‰j‰',
        'Escalation - Solution Time' => 'K‰sittely - Ratkaisuaika',
        'Follow up Option' => 'Seuranta-asetukset',
        'Ticket lock after a follow up' => 'Tiketti lukitaan vastatessa',
        'Systemaddress' => 'J‰rjestelm‰n osoite',
        'Customer Move Notify' => 'Siirto ilmoitukset asiakkaalle',
        'Customer State Notify' => 'Tilailmoitukset asiakkaalle',
        'Customer Owner Notify' => 'Omistajan muutokset asiakkaalle',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Jos agentti lukitsee tiketin eik‰ vastaa siihen t‰ss‰ ajassa avautuu lukitus automaattisesti. T‰m‰n j‰lkeen tiketti on taas muiden n‰ht‰vill‰.',
        'Escalation time' => 'Maksimi k‰sittelyaika',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Jos tikettiin ei vastattu t‰ss‰ ajassa, vain t‰m‰ tiketti n‰ytet‰‰n.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Jos tiketti on suljettu ja asiakas vastaa siihen - vastaus toimitetaan alkuper‰iselle omistajalle.',
        'Will be the sender address of this queue for email answers.' => 'L‰hett‰j‰osoite jonosta l‰hetetyille s‰hkˆposteille.',
        'The salutation for email answers.' => 'Tervehdys s‰hkˆpostiviesteiss‰.',
        'The signature for email answers.' => 'Allekirjoitus s‰hkˆpostiviesteiss‰',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS l‰hett‰‰ huomautuspostin asiakkaalle jos tiketti siirret‰‰n.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS l‰hett‰‰ huomautuspostin asiakkaalle jos tiketin tila muuttuu.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS l‰hett‰‰ huomautuspostin asiakkaalle jos tiketin omistaja muuttuu.',

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
        'Don\'t forget to add a new response a queue!' => 'ƒl‰ unohda lis‰t‰ uutta vastauspohjaa jonotuslistalle.',
        'The current ticket state is' => 'Tiketin status on',
        'Your email address is new' => 'Sinun s‰hkˆpostiosoite on uusi',

        # Template: AdminRoleForm
        'Role Management' => 'Roolien hallinta',
        'Add Role' => 'Lis‰‰ rooli',
        'Add a new Role.' => 'Lis‰‰ uusi rooli.',
        'Create a role and put groups in it. Then add the role to the users.' => 'Lis‰‰ rooli ja lis‰‰ ryhmi‰ siihen. Lis‰‰ rooli t‰m‰n j‰lkeen k‰ytt‰jille.',
        'It\'s useful for a lot of users and groups.' => 'T‰m‰ on k‰tev‰ useammalle k‰ytt‰j‰lle ja ryhm‰lle.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Roolit <-> Ryhmienhallinta',
        'move_into' => 'siirto',
        'Permissions to move tickets into this group/queue.' => 'Oikeudet siirt‰‰ tikettej‰ t‰h‰n ryhm‰‰n/jonoon.',
        'create' => 'lis‰ys',
        'Permissions to create tickets in this group/queue.' => 'Oikeus lis‰t‰ tikettej‰ t‰h‰n ryhm‰‰n/jonoon.',
        'owner' => 'omistaja',
        'Permissions to change the ticket owner in this group/queue.' => 'Oikeus muuttaa tiketin omistajaa t‰ss‰ ryhm‰ss‰/jonossa.',
        'priority' => 'prioriteetti',
        'Permissions to change the ticket priority in this group/queue.' => 'Oikeus muuttaa tiketin prioriteettia t‰ss‰ ryhm‰ss‰/jonossa.',

        # Template: AdminRoleGroupForm
        'Role' => 'Rooli',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Rooli <-> K‰ytt‰j‰hallinta',
        'Select the role:user relations.' => 'Valitse rooli:k‰ytt‰j‰suhde.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Tervehdysten hallinta',
        'Add Salutation' => 'Lis‰‰ tervehdys',
        'Add a new Salutation.' => 'Lis‰‰ uusi tervehdys.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL laatikko',
        'Limit' => 'Rajoitus',
        'Go' => 'SUORITA',
        'Select Box Result' => 'Suodatustuloksia',

        # Template: AdminService
        'Service Management' => 'Palveluhallinta',
        'Add Service' => 'Lis‰‰ palvelu',
        'Add a new Service.' => 'Lis‰‰ uusi palvelu.',
        'Sub-Service of' => 'Alipalvelu palvelulle',

        # Template: AdminSession
        'Session Management' => 'Istuntojen hallinta',
        'Sessions' => 'Istunnot',
        'Uniq' => 'Uniikki',
        'Kill all sessions' => 'Lopeta kaikki istunnot',
        'Session' => 'Istunto',
        'Content' => 'Sis‰ltˆ',
        'kill session' => 'Lopeta istunto',

        # Template: AdminSignatureForm
        'Signature Management' => 'Allekirjoitusten hallinta',
        'Add Signature' => 'Lis‰‰ allekirjoitus',
        'Add a new Signature.' => 'Lis‰‰ uusi allekirjoitus.',

        # Template: AdminSLA
        'SLA Management' => 'SLA hallinta',
        'Add SLA' => 'Lis‰‰ SLA',
        'Add a new SLA.' => 'Lis‰‰ uusi SLA.',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME hallinta',
        'Add Certificate' => 'Lis‰‰ sertifikaatti',
        'Add Private Key' => 'Lis‰‰ yksityisavain',
        'Secret' => 'Salasana',
        'Hash' => 'Tarkiste',
        'In this way you can directly edit the certification and private keys in file system.' => 'T‰ll‰ tavoin voi suoraan muokata sertifikaatteja sek‰ yksityisavaimia tiedostoj‰rjestelm‰ss‰. ',

        # Template: AdminStateForm
        'State Management' => 'Tilahallinta',
        'Add State' => 'Lis‰‰ tila',
        'Add a new State.' => 'Lis‰‰ uusi tila.',
        'State Type' => 'Tilatyyppi',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Muista p‰ivitt‰‰ oletusstatukset myˆs Kernel/Config.pm tiedostoon!',
        'See also' => 'Katso myˆs',

        # Template: AdminSysConfig
        'SysConfig' => 'Hallinta',
        'Group selection' => 'Ryhm‰valinta',
        'Show' => 'N‰yt‰',
        'Download Settings' => 'Lataa asetukset',
        'Download all system config changes.' => 'Lataa kaikki j‰rjestelm‰n asetusmuutokset.',
        'Load Settings' => 'Lataa asetukset',
        'Subgroup' => 'Aliryhm‰',
        'Elements' => 'Elementit',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Konfigurointiasetukset',
        'Default' => 'Oletus',
        'New' => 'Uusi',
        'New Group' => 'Uusi ryhm‰',
        'Group Ro' => 'Ryhm‰ Luku',
        'New Group Ro' => 'Uusi ryhm‰ Luku',
        'NavBarName' => 'ValikonNimi',
        'NavBar' => 'Valikko',
        'Image' => 'Kuva',
        'Prio' => 'Prio',
        'Block' => 'Est‰',
        'AccessKey' => 'P‰‰syAvain',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'S‰hkˆpostiosoitteiden m‰‰ritys',
        'Add System Address' => 'Lis‰‰ j‰rjestelm‰osoite',
        'Add a new System Address.' => 'Lis‰‰ uusi j‰rjestelm‰osoite.',
        'Realname' => 'Nimi',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Kaikki viestit joissa t‰m‰ "Email" (To:)-kentt‰ osoitetaan valittuu jonoon!',

        # Template: AdminTypeForm
        'Type Management' => 'Tyyppihallinta',
        'Add Type' => 'Lis‰‰ tyyppi',
        'Add a new Type.' => 'Lis‰‰ uusi tyyppi.',

        # Template: AdminUserForm
        'User Management' => 'K‰ytt‰j‰hallinta',
        'Add User' => 'Lis‰‰ k‰ytt‰j‰',
        'Add a new Agent.' => 'Lis‰‰ uusi agentti.',
        'Login as' => 'Kirjaudu',
        'Firstname' => 'Etunimi',
        'Lastname' => 'Sukunimi',
        'User will be needed to handle tickets.' => 'K‰ytt‰j‰ tarvitaan tikettien k‰sittelemiseen.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Muista lis‰t‰ uusi k‰ytt‰j‰ ryhm‰‰n ja/tai rooli!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'K‰ytt‰j‰ <-> Ryhm‰hallinta',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Osoitekirja',
        'Return to the compose screen' => 'Palaa viestinkirjoitusikkunaan',
        'Discard all changes and return to the compose screen' => 'Hylk‰‰ muutokset ja palaa viestin kirjoitusikkunaan',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object' => 'Liitoskohde',
        'Select' => 'Valitse',
        'Results' => 'Hakutulokset',
        'Total hits' => 'Hakutuloksia yhteens‰',
        'Page' => 'Sivu',
        'Detail' => 'Tiedot',

        # Template: AgentLookup
        'Lookup' => 'Tarkastele',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Oikeinkirjoituksen tarkistus',
        'spelling error(s)' => 'Kirjoitusvirheit‰',
        'or' => 'tai',
        'Apply these changes' => 'Hyv‰ksy muutokset',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Haluatko varmasti poistaa t‰m‰n kohteen?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Valitse tilastoa koskevat rajaukset',
        'Fixed' => 'Kiinte‰',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Valitse vain yksi elementti tai poista valinta kohdasta \'Kiinte‰\'.',
        'Absolut Period' => 'Tarkka jakso',
        'Between' => 'V‰lill‰',
        'Relative Period' => 'Suhteellinen jakso',
        'The last' => 'Viimeinen',
        'Finish' => 'Loppu',
        'Here you can make restrictions to your stat.' => 'T‰ss‰ voit tehd‰ rajoituksia tilastoosi.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Jos poistat valinnan kohdasta "Kiinte‰", tilastoa tekev‰ agentti voi muuttaa elementin asetuksia.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Yleisten m‰‰rityksien lis‰ys',
        'Permissions' => 'Oikeudet',
        'Format' => 'Muoto',
        'Graphsize' => 'Graafikoko',
        'Sum rows' => 'Summasarakkeet',
        'Sum columns' => 'Summarivit',
        'Cache' => 'V‰limuisti',
        'Required Field' => 'Vaaditut kent‰t',
        'Selection needed' => 'Valinta pakollinen',
        'Explanation' => 'Selitys',
        'In this form you can select the basic specifications.' => 'T‰ss‰ lomakkeessa voit asettaa perusominaisuudet.',
        'Attribute' => 'Ominaisuus',
        'Title of the stat.' => 'Tilaston otsikko.',
        'Here you can insert a description of the stat.' => 'Voit lis‰t‰ t‰h‰n kuvaus tilastolle.',
        'Dynamic-Object' => 'Dynaaminen-Objekti',
        'Here you can select the dynamic object you want to use.' => 'T‰ss‰ voit valita k‰ytett‰v‰n dynaamisen objektin.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Huomio: Dynaamisten objektien m‰‰r‰ on riippuvainen sovelluksen asennuksesta)',
        'Static-File' => 'Kiinte‰-Tiedosto',
        'For very complex stats it is possible to include a hardcoded file.' => 'Monimutkaisissa tilastointim‰‰rityksiss‰ on mahdollista k‰ytt‰‰ erillist‰ tiedostoa.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Jos uusi erillinen m‰‰ritystiedosto on saatavilla t‰m‰ m‰‰ritys on aktiivisena.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Turva-asetukset. Voit valita yhden tai useamman ryhm‰n jolle t‰m‰ tilastointim‰‰ritys on n‰ht‰viss‰.',
        'Multiple selection of the output format.' => 'Useamman esitysmuodon valinta.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Jos k‰yt‰t esitysmuotona kuvaajaa tulee sinun valita v‰hint‰‰n yksi kuvaajan koko.',
        'If you need the sum of every row select yes' => 'Jos tarvitset rivien summat valitse kyll‰',
        'If you need the sum of every column select yes.' => 'Jos tarvitset sarakkeiden summat valitse kyll‰',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Suurin osa tilastoista voidaan lis‰t‰ v‰limuistiin. T‰m‰ nopeuttaa tilaston katsomista.',
        '(Note: Useful for big databases and low performance server)' => '(Huomio: Hyˆdyllinen isojen tietokantojen yhteydess‰, sek‰ ruuhkaisilla palvelimilla)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'T‰m‰ on hyˆdyllinen jos tilaston m‰‰ritys ei ole valmis tai et halua tilaston vastauksia n‰kyviin.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Valitse arvov‰lin elementit',
        'Scale' => 'Asteikko',
        'minimal' => 'Minimi',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Huomioi ett‰ arvoasteikon koon tulee olla suurempi kuin X-akselin (esim. X-akseli => Kuukausi, Arvoasteikko => Vuosi).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Valitse elementti, jota k‰ytet‰‰n X-akselilla',
        'maximal period' => 'maksimijakso',
        'minimal scale' => 'Minimiasteikko',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => 'Tuo',
        'File is not a Stats config' => 'Tiedosto ei sis‰ll‰ tilastointiasetuksia',
        'No File selected' => 'Tiedostoa ei valittu',

        # Template: AgentStatsOverview
        'Object' => 'Objekti',

        # Template: AgentStatsPrint
        'Print' => 'Tulosta',
        'No Element selected.' => 'Ei valittua elementti‰.',

        # Template: AgentStatsView
        'Export Config' => 'Vie asetukset',
        'Information about the Stat' => 'Tietoja tilastosta',
        'Exchange Axis' => 'Vaihda akseleita',
        'Configurable params of static stat' => 'M‰‰ritelt‰v‰t asetukset kiinte‰lle tilastolle',
        'No element selected.' => 'Ei valittua elementti‰.',
        'maximal period from' => 'maksimi jakso v‰lill‰',
        'to' => '-',
        'Start' => 'Aloita',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Delekoi tiketti',
        'Ticket locked!' => 'Tiketti lukittu!',
        'Ticket unlock!' => 'Lukitus purettu!',
        'Bounce to' => 'Delekoi',
        'Next ticket state' => 'Uusi tiketin status',
        'Inform sender' => 'Informoi l‰hett‰j‰‰',
        'Send mail!' => 'L‰het‰ s‰hkˆposti!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Tikettien massatoimenpide',
        'Spell Check' => 'Oikeinkirjoituksen tarkistus',
        'Note type' => 'Huomautustyyppi',
        'Unlock Tickets' => 'Pura lukitus',

        # Template: AgentTicketClose
        'Close ticket' => 'Sulje tiketti',
        'Previous Owner' => 'Edellinen omistaja',
        'Inform Agent' => 'Ilmoita agentille',
        'Optional' => 'Valinnainen',
        'Inform involved Agents' => 'Ilmoita osallistuneille agenteille',
        'Attach' => 'Liite',
        'Next state' => 'Uusi tila',
        'Pending date' => 'Odottaa p‰iv‰‰n',
        'Time units' => 'Tyˆaika',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'L‰het‰ vastaus tikettiin',
        'Pending Date' => 'Odotusp‰iv‰',
        'for pending* states' => 'Automaattisulkeminen tai muistutus',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Vaihda tiketin asiakasta',
        'Set customer user and customer id of a ticket' => 'Aseta tiketin asiakask‰ytt‰j‰ ja asiakas id',
        'Customer User' => 'Asiakas-k‰ytt‰j‰',
        'Search Customer' => 'Etsi Asiakas',
        'Customer Data' => 'Asiakastieto',
        'Customer history' => 'Asiakkaan historiatiedot',
        'All customer tickets.' => 'Kaikki asiakastiketit.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Vastaukset',

        # Template: AgentTicketEmail
        'Compose Email' => 'Luo s‰hkˆposti',
        'new ticket' => 'Uusi tiketti',
        'Refresh' => 'P‰ivit‰',
        'Clear To' => 'Puhdista vastaanottaja',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => 'Tiketin k‰sittelyn‰kym‰',
        'Escalation' => 'K‰sittely',
        'Today' => 'T‰n‰‰n',
        'Tomorrow' => 'Huomenna',
        'Next Week' => 'Seuraavalla viikolla',
        'up' => 'alkuun',
        'down' => 'loppuun',
        'Escalation' => 'K‰sittely',
        'Locked' => 'Lukitut',

        # Template: AgentTicketForward
        'Article type' => 'Huomautustyyppi',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Vaihda tiketin vapaakentt‰tietoja',

        # Template: AgentTicketHistory
        'History of' => 'Historia:',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Saapuneet',
        'Tickets' => 'Tiketit',
        'of' => '/',
        'Filter' => 'Suodatin',
        'New messages' => 'Uusia viestej‰',
        'Reminder' => 'Muistuttaja',
        'Sort by' => 'J‰rjest‰',
        'Order' => 'J‰rjestys',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Liit‰ tiketti',
        'Merge to' => 'Kohde',

        # Template: AgentTicketMove
        'Move Ticket' => 'Siirr‰ tiketti',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Lis‰‰ huomautus t‰h‰n tikettiin',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Muuta t‰m‰n tiketin omistajaa',

        # Template: AgentTicketPending
        'Set Pending' => 'Aseta odottaa',

        # Template: AgentTicketPhone
        'Phone call' => 'Puhelut',
        'Clear From' => 'Puhdista L‰hett‰j‰',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Pelkk‰ teksti',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Tikettitieto',
        'Accounted time' => 'K‰ytetty aika',
        'First Response Time' => 'Ensimm‰inen vastausaika',
        'Update Time' => 'P‰ivitysaika',
        'Solution Time' => 'Ratkaisuaika',
        'Linked-Object' => 'Liitetty',
        'Parent-Object' => 'Ylempi',
        'Child-Object' => 'Alempi',
        'by' => '/',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Muuta prioriteetti‰',

        # Template: AgentTicketQueue
        'Tickets shown' => 'N‰kyviss‰ tiketit',
        'Tickets available' => 'Tikettej‰ avoinna',
        'All tickets' => 'Tikettej‰ yhteens‰',
        'Queues' => 'Jonotuslistat',
        'Ticket escalation!' => 'Tiketin maksimi hyv‰ksytt‰v‰ k‰sittelyaika!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => 'Palveluaika',
        'Your own Ticket' => 'Oma tiketti',
        'Compose Follow up' => 'L‰het‰ vastaus',
        'Compose Answer' => 'Vastaa',
        'Contact customer' => 'Ota yhteytt‰ asiakkaaseen',
        'Change queue' => 'Vaihda jonotuslistaa',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Vaihda tiketist‰ vastaavan tieto',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Tikettihaku',
        'Profile' => 'Profiili',
        'Search-Template' => 'Hakupohja',
        'TicketFreeText' => 'Vapaakentt‰',
        'Created in Queue' => 'Luotu jonossa',
        'Close Times' => 'Sulkemisajat',
        'No close time settings.' => 'Ei sulkemisaikaa asetettu',
        'Ticket closed' => 'Tiketti suljettu',
        'Ticket closed between' => 'Tiketti suljettu v‰lill‰',
        'Result Form' => 'Vastausmuoto',
        'Save Search-Profile as Template?' => 'Tallenna haku pohjaksi?',
        'Yes, save it with name' => 'Kyll‰, tallenna nimell‰',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Muuta hakuasetuksia',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Tikettien tilan‰kym‰',
        'Open Tickets' => 'Avoimet tiketit',

        # Template: AgentTicketZoom
        'Expand View' => 'Laajenna n‰kym‰',
        'Collapse View' => 'Supista n‰kym‰',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Tiedot',

        # Template: CustomerFooter
        'Powered by' => 'J‰rjestelm‰',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'K‰ytt‰j‰tunnus',
        'Lost your password?' => 'Unohditko salasanan?',
        'Request new password' => 'Pyyd‰ uutta salasanaa',
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
        'Click here to report a bug!' => 'Klikkaa t‰st‰ l‰hett‰‰ksesi bugiraportti!',

        # Template: Footer
        'Top of Page' => 'Mene ylˆs',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-asennus',
        'Welcome to %s' => 'Tervetuloa k‰ytt‰m‰‰n %s',
        'Accept license' => 'Hyv‰ksy lisenssi',
        'Don\'t accept license' => 'ƒl‰ hyv‰ksy lisenssi‰',
        'Admin-User' => 'Admin-k‰ytt‰j‰',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Admin-salasana',
        'Database-User' => 'Tietokantak‰ytt‰j‰',
        'default \'hot\'' => 'oletuspalvelin',
        'DB connect host' => 'Tietokantapalvelin',
        'Database' => 'Tietokanta',
        'Default Charset' => 'Oletusmerkistˆ',
        'utf8' => 'utf8',
        'false' => 'virheellinen',
        'SystemID' => 'J‰rjestelm‰ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(j‰rjestelm‰n tunnus. Jokainen tiketti ja jokainen http istuntotunnus alkaa t‰ll‰ numerolla)',
        'System FQDN' => 'J‰rjestelm‰n is‰nt‰nimi',
        '(Full qualified domain name of your system)' => '(J‰rjestelm‰n is‰nt‰nimi (FQND) kokonaisuudessaan)',
        'AdminEmail' => 'Yll‰pidon s‰hkˆposti',
        '(Email of the system admin)' => 'Yll‰pit‰j‰n s‰hkˆpostiosoite',
        'Organization' => 'Organisaatio',
        'Log' => 'Loki',
        'LogModule' => 'LokiModuuli',
        '(Used log backend)' => '(Lokien s‰ilytystapa)',
        'Logfile' => 'Logitiedosto',
        '(Logfile just needed for File-LogModule!)' => '(Logitiedosto tarvitaan Tiedostologi moduulille!)',
        'Webfrontend' => 'Webn‰kym‰',
        'Use utf-8 it your database supports it!' => 'K‰yt‰ utf-8:a jos tietokantasi tukee sit‰!',
        'Default Language' => 'Oletuskieli',
        '(Used default language)' => '(K‰ytetty oletuskieli)',
        'CheckMXRecord' => 'TarkastaMXTieto',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Tarkista k‰ytettyjen s‰hkˆpostiosoitteiden MX tietueet vastattaessa. ƒl‰ k‰yt‰ t‰t‰ jos OTRS j‰rjestelm‰ on hitaan yhteyden takana $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Voidaksesi k‰ytt‰‰ OTRS-j‰rjestelm‰‰ tulee sinun kirjoittaa seuraava komento root oikeuksilla komentokehotteessa.',
        'Restart your webserver' => 'K‰ynnist‰ web-palvelin uudestaan',
        'After doing so your OTRS is up and running.' => 'T‰m‰n j‰lkeen OTRS j‰rjestelm‰ on k‰ytett‰viss‰.',
        'Start page' => 'Aloitussivu',
        'Your OTRS Team' => 'OTRS Tiimi',

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ei k‰yttˆoikeutta',

        # Template: Notify
        'Important' => 'T‰rke‰',

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
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Tiketin tunniste. Voit asettaa esim. \'Tiketti#\', \'Puhelu#\' tai \'OmaTiketti#\')',
        'Create new Phone Ticket' => 'Luo uusi puhelintiketti',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'T‰ll‰ tavalla voit muokata suoraan Kernel/Config.pm:ss‰ m‰‰ritelty‰ avainrengasta.',
        'Symptom' => 'Oire',
        'U' => 'Y',
        'A message should have a To: recipient!' => 'Viestiss‰ pit‰‰ olla vastaanottaja!',
        'Site' => 'Palvelin',
        'Customer history search (e. g. "ID342425").' => 'Asiakashistoriahaku (Esim. "ID342425").',
        'for agent firstname' => 'k‰sittelij‰n etunimi',
        'Close!' => 'Sulje!',
        'The message being composed has been closed.  Exiting.' => 'Kirjoittamasi viesti on suljettu.  Poistutaan.',
        'A web calendar' => 'Web-kalenteri',
        'to get the realname of the sender (if given)' => 'n‰hd‰ksesi k‰ytt‰j‰n nimen',
        'Notification (Customer)' => 'Huomautus (asiakas)',
        'Select Source (for add)' => 'Lis‰‰ l‰hde (lis‰ykselle)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Tikettitiedon asetukset (esim. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Home' => 'Etusivu',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Asetusvaihtoehdot (esim. <OTRS_CONFIG_HttpType>)',
        'System History' => 'J‰rjestelm‰historia',
        'customer realname' => 'k‰ytt‰j‰n oikea nimi',
        'Pending messages' => 'Odottavat viestit',
        'for agent login' => 'agentille tunnuksella',
        'Keyword' => 'Avainsanat',
        'Close type' => 'Sulkemisen syy',
        'for agent user id' => 'agentille k‰ytt‰j‰ id:ll‰',
        'sort upward' => 'J‰rjest‰ nousevasti',
        'Change user <-> group settings' => 'Vaihda k‰ytt‰j‰ <-> Ryhm‰hallinta',
        'Problem' => 'Ongelma',
        'next step' => 'Seuraava',
        'Customer history search' => 'Asiakashistoriahaku',
        'Admin-Email' => 'Yll‰pidon s‰hkˆposti',
        'A message must be spell checked!' => 'Viesti t‰ytyy oikolukea!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'S‰hkˆposti, tikettinumero "<OTRS_TICKET>" on v‰litetty osoitteeseen: "<OTRS_BOUNCE_TO>" . Ota yhteytt‰ kyseiseen osoitteeseen saadaksesi lis‰tietoja',
        'ArticleID' => 'ArtikkeliID',
        'A message should have a body!' => 'Viestiin tulee lis‰t‰ tietoja',
        'All Agents' => 'Kaikki agentit',
        'Keywords' => 'Avainsanat',
        'No * possible!' => 'Jokerimerkki (*) ei k‰ytˆss‰ !',
        'Options ' => 'Asetukset',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Ajoa suorittavan k‰ytt‰j‰n asetukset (esim. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Viesti uudelle omistajalle',
        'to get the first 5 lines of the email' => 'n‰hd‰ksesi 5 ensimm‰ist‰ rivi‰ s‰hkˆpostista',
        'Last update' => 'Edellinen p‰ivitys',
        'to get the first 20 character of the subject' => 'n‰hd‰ksesi ensimm‰iset 20 kirjainta otsikosta',
        'Select the customeruser:service relations.' => 'Valitse asiakask‰ytt‰j‰:palvelu suhteet.',
        'Drop Database' => 'Poista tietokanta',
        'FileManager' => 'Tiedostohallinta',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Nykyisen asiakask‰ytt‰j‰n asetukset (esim. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Odotustyyppi',
        'Comment (internal)' => 'Kommentti (sis‰inen)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Tiketin omistajan asetukset (esim. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'This window must be called from compose window' => 'T‰t‰ ikkunaa tulee kutsua viestinkirjoitusikkunasta',
        'You need min. one selected Ticket!' => 'Sinun tulee valita v‰hint‰‰n yksi tiketti!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Tikettitiedon asetukset (esim. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => 'Tikettinumeroiden oletusformaatti',
        'Fulltext' => 'Kokosana',
        ' (work units)' => ' (esim. minuutteina)',
        'All Customer variables like defined in config option CustomerUser.' => 'Kaikki asiakkaan muuttujat kuten m‰‰ritetty Asiakask‰ytt‰j‰n asetuksissa.',
        'accept license' => 'Hyv‰ksy lisenssi',
        'for agent lastname' => 'agentin sukunimi',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Ajoa suorittavan k‰ytt‰j‰n asetukset (esim. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Reminder messages' => 'Muistutettavat viestit',
        'A message should have a subject!' => 'Viestiss‰ pit‰‰ olla otsikko!',
        'IMAPS' => 'IMAPS',
        'Don\'t forget to add a new user to groups!' => 'ƒl‰ unohda lis‰t‰ uutta k‰ytt‰j‰‰ ryhmiin!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Laita vastaanottajakentt‰‰n s‰hkˆpostiosoite!',
        'You need to account time!' => 'K‰sittelyaika',
        'System Settings' => 'J‰rjestelm‰asetukset',
        'WebWatcher' => 'WebSeuranta',
        'Finished' => 'Valmis',
        'Split' => 'Jaa',
        'D' => 'A',
        'All messages' => 'Kaikki viestit',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Tikettitiedon asetukset (esim. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'A article should have a title!' => 'Artikkelilla tulee olla otsikko!',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'M‰‰ritysasetukset (esim. <OTRS_CONFIG_HttpType>)',
        'Event' => 'Tapahtyma',
        'don\'t accept license' => 'En hyv‰ksy lisenssi‰',
        'A web mail client' => 'Webpostiohjelma',
        'WebMail' => 'WebMail',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Tiketin omistajan asetukset (esim. <OTRS_OWNER_UserFirstName>)',
        'Name is required!' => 'Nimi on vaadittu!',
        'Termin1' => '',
        'kill all sessions' => 'Lopeta kaikki istunnot',
        'to get the from line of the email' => 'n‰hd‰ksesi yhden rivin s‰hkˆpostista',
        'Solution' => 'Ratkaisu',
        'QueueView' => 'Jonotuslistan‰kym‰',
        'Select Box' => 'Suodatus',
        'Welcome to OTRS' => 'Tervetuloa OTRS:n',
        'modified' => 'Muokannut',
        'Escalation in' => 'Vanhenee',
        'sort downward' => 'J‰rjest‰ laskevasti',
        'You need to use a ticket number!' => 'Sinun tulee k‰ytt‰‰ tikettinumeroa!',
        'A web file manager' => 'Web tiedostonhallinta',
        'Have a lot of fun!' => 'Pid‰ hauskaa!',
        'send' => 'l‰het‰',
        'Note Text' => 'Huomautusteksti',
        'POP3 Account Management' => 'POP3 -tunnusten hallinta',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Nykyisen asiakask‰ytt‰j‰n asetukset (esim. <OTRS_CUSTOMER_DATA_USERFIRTNAME>)',
        'System State Management' => 'Tilamahdollisuuksien hallinta',
        'PhoneView' => 'Puhelu / Uusi tiketti',
        'maximal period form' => '',
        'Verion' => 'Versio',
        'TicketID' => 'TikettiID',
        'Management Summary' => 'Hallinnan yhteenveto',
        'Modified' => 'Muokattu',
        'Ticket selected for bulk action!' => 'Tiketti valittu massatoimenpiteeseen!',

        'Link Object: %s' => 'Linkit‰ objekti: %s',
        'Unlink Object: %s' => 'Pura linkki objektiin: %s',
        'Linked as' => 'Linkitetty',
        'Can not create link with %s!' => 'Linkitys ep‰onnistui kohteeseen %s!',
        'Can not delete link with %s!' => 'Linkityksen poisto ep‰onnistui kohteeseen %s!',
        'Object already linked as %s.' => 'Objekti linkitetty jo kohteeseen %s.',
        'Priority Management' => 'Prioriteettien hallinta',
        'Add a new Priority.' => 'Lis‰‰ uusi prioriteetti.',
        'Add Priority' => 'Lis‰‰ prioriteetti',
        'Ticket Type is required!' => '',
        'Module documentation' => '',
        'Added!' => '',
        'Updated!' => '',
    };
    # $$STOP$$
    return;
}

1;
