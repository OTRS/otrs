# --
# Kernel/Language/sv.pm - Swedish language translation
# Copyright (C) 2004 Mats Eric Olausson <mats at synergy.se>
# Copyright (C) 2009 Mikael Mattsson" <Mikael.Mattsson at konsumvarmland.se>
# --
# $Id: sv.pm,v 1.79 2010-01-19 22:57:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::sv;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.79 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat Jun 27 13:55:43 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M %Y %T';
    $Self->{DateFormatLong}      = '%A %D. %B %Y %T';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Separator}           = ';';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Ja',
        'No' => 'Nej',
        'yes' => 'ja',
        'no' => 'inga',
        'Off' => 'Av',
        'off' => 'av',
        'On' => 'På',
        'on' => 'på',
        'top' => 'topp',
        'end' => 'slut',
        'Done' => 'Klar',
        'Cancel' => 'Avbryt',
        'Reset' => 'Nollställ',
        'last' => 'sista',
        'before' => 'före',
        'day' => 'dag',
        'days' => 'dagar',
        'day(s)' => 'dag(ar)',
        'hour' => 'timme',
        'hours' => 'timmar',
        'hour(s)' => '',
        'minute' => 'minut',
        'minutes' => 'minuter',
        'minute(s)' => 'minut(er)',
        'month' => 'månad',
        'months' => 'månader',
        'month(s)' => 'månad(er)',
        'week' => 'vecka',
        'week(s)' => 'vecka(or)',
        'year' => 'år',
        'years' => 'år',
        'year(s)' => 'år',
        'second(s)' => 'sekund(er)',
        'seconds' => 'sekunder',
        'second' => 'sekund',
        'wrote' => 'skrev',
        'Message' => 'Meddelande',
        'Error' => 'Fel',
        'Bug Report' => 'Rapportera fel',
        'Attention' => 'OBS',
        'Warning' => 'Varning',
        'Module' => 'Modul',
        'Modulefile' => 'Modulfil',
        'Subfunction' => 'Underfunktion',
        'Line' => 'Rad',
        'Setting' => 'Inställning',
        'Settings' => 'Inställningar',
        'Example' => 'Exempel',
        'Examples' => 'Exempel',
        'valid' => 'giltig',
        'invalid' => 'ogiltig',
        '* invalid' => '* ogiltlig',
        'invalid-temporarily' => '* ogiltlig-tillfälligt',
        ' 2 minutes' => ' 2 minuter',
        ' 5 minutes' => ' 5 minuter',
        ' 7 minutes' => ' 7 minuter',
        '10 minutes' => '10 minuter',
        '15 minutes' => '15 minuter',
        'Mr.' => 'Mr.',
        'Mrs.' => 'Mrs.',
        'Next' => 'Nästa',
        'Back' => 'Tillbaka',
        'Next...' => 'Nästa...',
        '...Back' => '...Tillbaka',
        '-none-' => '-inga-',
        'none' => 'inga',
        'none!' => 'inga!',
        'none - answered' => 'inga - besvarat',
        'please do not edit!' => 'Var vänlig och ändra inte detta!',
        'AddLink' => 'Lägg till länk',
        'Link' => 'Länk',
        'Unlink' => 'Avlänka',
        'Linked' => 'Länkat',
        'Link (Normal)' => 'Länk (Normal)',
        'Link (Parent)' => 'Länk (Förälder)',
        'Link (Child)' => 'Länk (Barn)',
        'Normal' => 'Normal',
        'Parent' => 'Förälder',
        'Child' => 'Barn',
        'Hit' => 'Träff',
        'Hits' => 'Träffar',
        'Text' => 'Text',
        'Lite' => 'Enkel',
        'User' => 'Användare',
        'Username' => 'Användarnamn',
        'Language' => 'Språk',
        'Languages' => 'Språk',
        'Password' => 'Lösenord',
        'Salutation' => 'Hälsning',
        'Signature' => 'Signatur',
        'Customer' => 'Kund',
        'CustomerID' => 'KundID',
        'CustomerIDs' => 'KundIDn',
        'customer' => 'kund',
        'agent' => 'agent',
        'system' => 'System',
        'Customer Info' => 'Kundinfo',
        'Customer Company' => 'Kundföretag',
        'Company' => 'Företag',
        'go!' => 'Starta!',
        'go' => 'Starta',
        'All' => 'Alla',
        'all' => 'alla',
        'Sorry' => 'Beklagar',
        'update!' => 'Uppdatera!',
        'update' => 'uppdatera',
        'Update' => 'Uppdatera',
        'Updated!' => 'Uppdaterad!',
        'submit!' => 'Skicka!',
        'submit' => 'Skicka',
        'Submit' => 'Skicka',
        'change!' => 'ändra!',
        'Change' => 'Ändra',
        'change' => 'ändra',
        'click here' => 'klicka här',
        'Comment' => 'Kommentar',
        'Valid' => 'Giltigt',
        'Invalid Option!' => 'Ogiltligt val!',
        'Invalid time!' => 'Ogiltlig tid!',
        'Invalid date!' => 'Ogiltligt datum!',
        'Name' => 'Namn',
        'Group' => 'Grupp',
        'Description' => 'Beskrivning',
        'description' => 'beskrivning',
        'Theme' => 'Tema',
        'Created' => 'Skapat',
        'Created by' => 'Skapat av',
        'Changed' => 'Ändrat',
        'Changed by' => 'Ändrat av',
        'Search' => 'Sök',
        'and' => 'och',
        'between' => 'mellan',
        'Fulltext Search' => 'Fulltextsökning',
        'Data' => 'Data',
        'Options' => 'Tillval',
        'Title' => 'Titel',
        'Item' => 'Enhet',
        'Delete' => 'Radera',
        'Edit' => 'Redigera',
        'View' => 'Bild',
        'Number' => 'Nummer',
        'System' => 'System',
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontakter',
        'Export' => 'Exportera',
        'Up' => 'Upp',
        'Down' => 'Ner',
        'Add' => 'Lägg till',
        'Added!' => 'Tillagd',
        'Category' => 'Kategori',
        'Viewer' => 'Bevakare',
        'Expand' => 'Expandera',
        'New message' => 'Nytt meddelande',
        'New message!' => 'Nytt meddelande!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Vänligen besvara denna/dessa ärenden för att komma tillbaka till den normala kö-visningsbilden!',
        'You got new message!' => 'Du har fått ett nytt meddelande!',
        'You have %s new message(s)!' => 'Du har %s nya meddelanden!',
        'You have %s reminder ticket(s)!' => 'Du har %s påminnelse-ärende(n)!',
        'The recommended charset for your language is %s!' => 'Den rekommenderade teckenuppsättningen för ditt språk är %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Lösenorden är inte lika! Gör ett nytt försök!',
        'Password is already in use! Please use an other password!' => 'Lösenordet används redan! Använd ett annat lösenord!',
        'Password is already used! Please use an other password!' => 'Lösenordet har redan använts! Använd ett annat lösenord!',
        'You need to activate %s first to use it!' => 'Du måste aktivera %s först för att kunna använda det!',
        'No suggestions' => 'Inga förslag',
        'Word' => 'Ord',
        'Ignore' => 'Ignorera',
        'replace with' => 'Ersätt med',
        'There is no account with that login name.' => 'Det finns inget konto med detta namn.',
        'Login failed! Your username or password was entered incorrectly.' => 'Inloggningen misslyckades! Angivet användarnamn och/eller lösenord är inte korrekt.',
        'Please contact your admin' => 'Vänligen kontakta administratören',
        'Logout successful. Thank you for using OTRS!' => 'Utloggningen lyckades.  Tack för att du använde OTRS!',
        'Invalid SessionID!' => 'Ogiltigt SessionID!',
        'Feature not active!' => 'Funktion inte aktiverad!',
        'Notifications (Event)' => 'Meddelande (Akitivtet)',
        'Login is needed!' => 'Inloggning krävs!',
        'Password is needed!' => 'Lösenord krävs!',
        'License' => 'Licens',
        'Take this Customer' => 'Välj denna kund',
        'Take this User' => 'Välj denna användare',
        'possible' => 'möjlig',
        'reject' => 'Avvisas',
        'reverse' => 'baklänges',
        'Facility' => 'Innrättning',
        'Timeover' => 'Tidsöverträdelse',
        'Pending till' => 'Väntande tills',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Det är inte rekommenderat att arbeta som userid 1 (systemkonto)! Skapa nya användare!',
        'Dispatching by email To: field.' => 'Skickar iväg enligt epostmeddelandets Till:-fält.',
        'Dispatching by selected Queue.' => 'Skickar iväg enligt vald kö.',
        'No entry found!' => 'Ingen inmatning funnen!',
        'Session has timed out. Please log in again.' => 'Sessionstiden har löpt ut.  Vänligen logga på igen.',
        'No Permission!' => 'Ej Behörig!',
        'To: (%s) replaced with database email!' => 'Till: (%s) ersatt med epost från databas!',
        'Cc: (%s) added database email!' => 'Cc: (.s) tillagd med epost från databas.',
        '(Click here to add)' => '(Klicka här för att lägga till)',
        'Preview' => 'Forhandsvisning',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Paketet är inte korrekt installerat! Du bör installera om det!',
        'Added User "%s"' => 'La till Användare "%s"',
        'Contract' => 'Kontrakt',
        'Online Customer: %s' => 'Kund online: %s',
        'Online Agent: %s' => 'Agent online: %s',
        'Calendar' => 'Kalender',
        'File' => 'Fil',
        'Filename' => 'Filnamn',
        'Type' => 'Typ',
        'Size' => 'Storlek',
        'Upload' => 'Ladda upp',
        'Directory' => 'Katalog',
        'Signed' => 'Signatur',
        'Sign' => 'Signerat',
        'Crypted' => 'Krypterat',
        'Crypt' => 'Kryptering',
        'Office' => 'Kontor',
        'Phone' => 'Telefon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobil',
        'Zip' => 'Postnr',
        'City' => 'Stad',
        'Street' => 'Gata',
        'Country' => 'Land',
        'Location' => 'Plats',
        'installed' => 'installerad',
        'uninstalled' => 'avinstallerad',
        'Security Note: You should activate %s because application is already running!' => 'Säkerhetsinfo: Du bör aktivera %s för programmet körs redan!',
        'Unable to parse Online Repository index document!' => 'Kan inte hantera onlinelagringens indexdokument',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Inga Paket för valt Ramverk i det här Online-Repositoryt, men paket för andra Ramverk!',
        'No Packages or no new Packages in selected Online Repository!' => 'Inga Paket eller inga nya Paket i valt Online-Repository',
        'printed at' => 'utskriven vid',
        'Dear Mr. %s,' => 'Bäste Herr %s,',
        'Dear Mrs. %s,' => 'Bäste Fru %s,',
        'Dear %s,' => 'Bäste %s,',
        'Hello %s,' => 'Hej %s,',
        'This account exists.' => 'Kontot finns.',
        'New account created. Sent Login-Account to %s.' => 'Nytt konto skapat. Skickade inloggningsuppgifter till %s',
        'Please press Back and try again.' => 'Tryck på bakåtknappen och försök igen.',
        'Sent password token to: %s' => 'Skickade lösenordsinfo till: %s',
        'Sent new password to: %s' => 'Skickade nytt lösenord till: %s',
        'Upcoming Events' => 'Kommande Evenemang',
        'Event' => 'Evenemang',
        'Events' => 'Evenemang',
        'Invalid Token!' => 'Ogiltlig inmatning!',
        'more' => 'mer',
        'For more info see:' => 'För mer info:',
        'Package verification failed!' => 'Paketverifiering misslyckades!',
        'Collapse' => 'Kollapsa',
        'News' => 'Nyheter',
        'Product News' => 'Produktnyheter',
        'Bold' => 'Fet',
        'Italic' => 'Kursiv',
        'Underline' => 'Understruket',
        'Font Color' => 'Typsnittsfärg',
        'Background Color' => 'Bakgrundsfärg',
        'Remove Formatting' => 'Radera Formatering',
        'Show/Hide Hidden Elements' => 'Visa/Dölj dolda element',
        'Align Left' => 'Vänsterställ',
        'Align Center' => 'Centrera',
        'Align Right' => 'Högerställ',
        'Justify' => 'Justera',
        'Header' => 'Huvud',
        'Indent' => 'indrag',
        'Outdent' => 'utdrag',
        'Create an Unordered List' => 'Skapa en Osorterad Lista',
        'Create an Ordered List' => 'Skapa en Sorterad Lista',
        'HTML Link' => 'HTML-Länk',
        'Insert Image' => 'Infoga Bild',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Ångra',
        'Redo' => 'Gör om',

        # Template: AAAMonth
        'Jan' => 'jan',
        'Feb' => 'feb',
        'Mar' => 'mar',
        'Apr' => 'apr',
        'May' => 'maj',
        'Jun' => 'jun',
        'Jul' => 'jul',
        'Aug' => 'aug',
        'Sep' => 'sep',
        'Oct' => 'okt',
        'Nov' => 'nov',
        'Dec' => 'dec',
        'January' => 'Januari',
        'February' => 'Februari',
        'March' => 'Mars',
        'April' => 'April',
        'May_long' => 'Maj',
        'June' => 'Juni',
        'July' => 'Juli',
        'August' => 'Augusti',
        'September' => 'September',
        'October' => 'Oktober',
        'November' => 'November',
        'December' => 'December',

        # Template: AAANavBar
        'Admin-Area' => 'Administrationsrelaterat',
        'Agent-Area' => 'Agentrelaterat',
        'Ticket-Area' => 'Ärenden',
        'Logout' => 'Logga ut',
        'Agent Preferences' => 'Agentinställningar',
        'Preferences' => 'Inställningar',
        'Agent Mailbox' => 'Agentmailbox',
        'Stats' => 'Statistik',
        'Stats-Area' => 'Statistik',
        'Admin' => 'Administration',
        'Customer Users' => 'Kundanvändare',
        'Customer Users <-> Groups' => 'Kundanvändare <-> Grupper',
        'Users <-> Groups' => 'Användare <-> Grupper',
        'Roles' => 'Roller',
        'Roles <-> Users' => 'Roller <-> Användare',
        'Roles <-> Groups' => 'Roller <-> Grupper',
        'Salutations' => 'Hälsningar',
        'Signatures' => 'Signaturer',
        'Email Addresses' => 'Epostadresser',
        'Notifications' => 'Meddelanden',
        'Category Tree' => 'Kategoriträd',
        'Admin Notification' => 'Admin-meddelanden',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Inställningar lagrade!',
        'Mail Management' => 'Eposthantering',
        'Frontend' => 'Gränssnitt',
        'Other Options' => 'Andra tillval',
        'Change Password' => 'Byt lösenord',
        'New password' => 'Nytt lösenord',
        'New password again' => 'Nytt lösenord (igen)',
        'Select your QueueView refresh time.' => 'Välj automatisk uppdateringsintervall för Kö-bild.',
        'Select your frontend language.' => 'Välj språk.',
        'Select your frontend Charset.' => 'Välj teckenuppsättning.',
        'Select your frontend Theme.' => 'Välj stil-tema.',
        'Select your frontend QueueView.' => 'Välj Kö-bild.',
        'Spelling Dictionary' => 'Stavningslexikon',
        'Select your default spelling dictionary.' => 'Välj standard ordbok for stavningskontroll.',
        'Max. shown Tickets a page in Overview.' => 'Max. visade ärenden per sida i Översikt.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Kan inte lösenordet, lösenorden är inte lika! Försök igen!',
        'Can\'t update password, invalid characters!' => 'Kan inte ändra lösenordet, du har använt ogiltliga tecken!',
        'Can\'t update password, must be at least %s characters!' => 'Kan inte ändra lösenordet, det måste vara minst %s tecken långt! ',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Kan inte ändra lösenordet, det måste innehålla minst två gemener och två versaler! ',
        'Can\'t update password, needs at least 1 digit!' => 'Kan inte ändra lösenordet, det krävs minst en siffra!',
        'Can\'t update password, needs at least 2 characters!' => 'Kan inte ändra lösenordet, det krävs minst två bokstäver!',

        # Template: AAAStats
        'Stat' => 'Statistik',
        'Please fill out the required fields!' => 'Fyll i de tvingande fälten!',
        'Please select a file!' => 'Välj en fil!',
        'Please select an object!' => 'Välj ett objekt!',
        'Please select a graph size!' => 'Välj en grafstorlek!',
        'Please select one element for the X-axis!' => 'Välj ett av elementen för X-axeln!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Välj endast ett element, eller stäng av flaggan \'Fast\' där den är markerad!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Om du använder en bockruta måste du välja något av attributen för det valda fältet!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Infoga ett värde i valt fält, eller bocka ur \'Fast\' -rutan',
        'The selected end time is before the start time!' => 'Vald sluttid är före starttiden!',
        'You have to select one or more attributes from the select field!' => 'Du måste välja ett eller flera attribut i valt fält!',
        'The selected Date isn\'t valid!' => 'Valt datum är inte giltligt!',
        'Please select only one or two elements via the checkbox!' => 'Välj bara ett eller två element via bockrutan!',
        'If you use a time scale element you can only select one element!' => 'Om du använder en tidsskala kan du bara välja ett element!',
        'You have an error in your time selection!' => 'Du har ett fel i ditt tidsval!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Ditt rapporteringsintervall är för litet, använd en större tidsskala',
        'The selected start time is before the allowed start time!' => 'Vald starttid är innan den tillåtna starttiden!',
        'The selected end time is after the allowed end time!' => 'Vald sluttid är efter den tillåtna sluttiden!',
        'The selected time period is larger than the allowed time period!' => 'Vald tidsperiod är större än den tillåtna tidsperioden!',
        'Common Specification' => 'Vanlig Spec.',
        'Xaxis' => 'X-axel',
        'Value Series' => 'Värdeserie',
        'Restrictions' => 'Begränsningar',
        'graph-lines' => 'graf-linjer',
        'graph-bars' => 'graf-block',
        'graph-hbars' => 'graf-hblock',
        'graph-points' => 'graf-punkter',
        'graph-lines-points' => 'graf-linjer-punkter',
        'graph-area' => 'graf-area',
        'graph-pie' => 'graf-paj',
        'extended' => 'utökad',
        'Agent/Owner' => 'Agent/Ägare',
        'Created by Agent/Owner' => 'Skapad av Agent/Ägare',
        'Created Priority' => 'Skapad Prioritet',
        'Created State' => 'Skapad Status',
        'Create Time' => 'Skapad Tid',
        'CustomerUserLogin' => 'KundAnvändarLogin',
        'Close Time' => 'StängTid',
        'TicketAccumulation' => 'Ärendeackumulering',
        'Attributes to be printed' => 'Attribut som skall skrivas ut',
        'Sort sequence' => 'Sorteringssekvens',
        'Order by' => 'Sortera efter',
        'Limit' => 'Gräns',
        'Ticketlist' => 'Ärendelista',
        'ascending' => 'stigande',
        'descending' => 'fallande',
        'First Lock' => 'Första Lås',
        'Evaluation by' => 'Utvärdering av',
        'Total Time' => 'Total Tid',
        'Ticket Average' => 'Ärende Medel',
        'Ticket Min Time' => 'Ärende Min Tid',
        'Ticket Max Time' => 'Ärende Max Tid',
        'Number of Tickets' => 'Antal Ärenden',
        'Article Average' => 'Artikel Medel',
        'Article Min Time' => 'Artikel Min Tid',
        'Article Max Time' => 'Artikel Max tid',
        'Number of Articles' => 'Antal Artiklar',
        'Accounted time by Agent' => 'Redovisad tid per Agent',
        'Ticket/Article Accounted Time' => 'Ärende/Artikel Redovisad Tid',
        'TicketAccountedTime' => 'ÄrendeRedovisadTid',
        'Ticket Create Time' => 'Ärende Skapad Tid',
        'Ticket Close Time' => 'Ärende Stängt Tid',

        # Template: AAATicket
        'Lock' => 'Lås',
        'Unlock' => 'Lås upp',
        'History' => 'Historik',
        'Zoom' => 'Zooma',
        'Age' => 'Ålder',
        'Bounce' => 'Studsa',
        'Forward' => 'Vidarebefordra',
        'From' => 'Från',
        'To' => 'Till',
        'Cc' => 'Kopia',
        'Bcc' => 'Dold kopia',
        'Subject' => 'Ämne',
        'Move' => 'Flytta',
        'Queue' => 'Kö',
        'Priority' => 'Prioritet',
        'Priority Update' => 'Ändra Prioritet',
        'State' => 'Status',
        'Compose' => 'Författa',
        'Pending' => 'Väntande',
        'Owner' => 'Ägare',
        'Owner Update' => 'Ändra Ägare',
        'Responsible' => 'Ansvarig',
        'Responsible Update' => 'Ändra Ansvarig',
        'Sender' => 'Avsändare',
        'Article' => 'Artikel',
        'Ticket' => 'Ärende',
        'Createtime' => 'Tidpunkt för skapande',
        'plain' => 'rå',
        'Email' => 'Epost',
        'email' => 'epost',
        'Close' => 'Stäng',
        'Action' => 'Åtgärd',
        'Attachment' => 'Bifogat dokument',
        'Attachments' => 'Bifogade dokument',
        'This message was written in a character set other than your own.' => 'Detta meddelande är skrivet med en annan teckenuppsättning än den du använder.',
        'If it is not displayed correctly,' => 'Ifall det inte visas korrekt,',
        'This is a' => 'Detta är en',
        'to open it in a new window.' => 'för att öppna i ett nytt fönster',
        'This is a HTML email. Click here to show it.' => 'Detta är ett HTML-email. Klicka här för att visa.',
        'Free Fields' => 'Fria Fält',
        'Merge' => 'Sammanfoga',
        'merged' => 'sammanfogat',
        'closed successful' => 'Löst och stängt',
        'closed unsuccessful' => 'Olöst men stängt',
        'new' => 'ny',
        'open' => 'öppen',
        'Open' => 'Öppen',
        'closed' => 'stängt',
        'Closed' => 'Stängt',
        'removed' => 'borttagen',
        'pending reminder' => 'väntar på påminnelse',
        'pending auto' => 'väntar på auto',
        'pending auto close+' => 'väntar på att stängas (löst)',
        'pending auto close-' => 'väntar på att stängas (olöst)',
        'email-external' => 'email externt',
        'email-internal' => 'email internt',
        'note-external' => 'notis externt',
        'note-internal' => 'notis internt',
        'note-report' => 'notis till rapport',
        'phone' => 'telefon',
        'sms' => 'sms',
        'webrequest' => 'web-anmodan',
        'lock' => 'låst',
        'unlock' => 'upplåst',
        'very low' => 'planeras',
        'low' => 'låg',
        'normal' => 'normal',
        'high' => 'hög',
        'very high' => 'kritisk',
        '1 very low' => '1 Planeras',
        '2 low' => '2 låg',
        '3 normal' => '3 medium',
        '4 high' => '4 hög',
        '5 very high' => '5 kritisk',
        'Ticket "%s" created!' => 'Ärende "%s" skapad!',
        'Ticket Number' => 'Ärendenummer',
        'Ticket Object' => 'Ärendeobjekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ärendenummer "%s" finns inte, kan inte länka dit!',
        'Don\'t show closed Tickets' => 'Visa inte stängda ärenden',
        'Show closed Tickets' => 'Visa stängda ärenden',
        'New Article' => 'Ny artikel',
        'Email-Ticket' => 'Epostärende',
        'Create new Email Ticket' => 'Skapa nytt Epostärende',
        'Phone-Ticket' => 'Telefonärende',
        'Search Tickets' => 'Sök ärenden',
        'Edit Customer Users' => 'Redigera Kundanvändare',
        'Edit Customer Company' => 'Redigera Kundföretag',
        'Bulk Action' => 'Massförändring',
        'Bulk Actions on Tickets' => 'Massförändring av Ärenden',
        'Send Email and create a new Ticket' => 'Skicka Epost och skapa nytt Ärende',
        'Create new Email Ticket and send this out (Outbound)' => 'Skapa nytt Epostärende och skicka detta (Utgående)',
        'Create new Phone Ticket (Inbound)' => 'Skapa nytt Telefonärende (Inkommande)',
        'Overview of all open Tickets' => 'Översikt över alla öppna Ärenden',
        'Locked Tickets' => 'Låsta Ärenden',
        'Watched Tickets' => 'Bevakade Ärenden',
        'Watched' => 'Bevakade',
        'Subscribe' => 'Bevaka',
        'Unsubscribe' => 'Bevaka inte',
        'Lock it to work on it!' => 'Lås ärende för att arbeta med det!',
        'Unlock to give it back to the queue!' => 'Lås upp för att lägga tillbaka ärendet till kön!',
        'Shows the ticket history!' => 'Visar ärendehistoriken!',
        'Print this ticket!' => 'Skriv ut detta ärende!',
        'Change the ticket priority!' => 'Ändra ärendets prioritet!',
        'Change the ticket free fields!' => 'Ändra ärendets fria fält!',
        'Link this ticket to an other objects!' => 'Koppla ärendet till andra objekt!',
        'Change the ticket owner!' => 'Ändra ärendets ägare!',
        'Change the ticket customer!' => 'Ändra ärendets kund!',
        'Add a note to this ticket!' => 'Lägg till en notis på ärendet!',
        'Merge this ticket!' => 'Slå samman ärendet!',
        'Set this ticket to pending!' => 'Sätt ärendet som väntande!',
        'Close this ticket!' => 'Stäng ärendet!',
        'Look into a ticket!' => 'Visa ärendet!',
        'Delete this ticket!' => 'Radera ärendet!',
        'Mark as Spam!' => 'Markera som SPAM!',
        'My Queues' => 'Mina köer',
        'Shown Tickets' => 'Visade Ärenden',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Ditt epostärende med nummer "<OTRS_TICKET>" har slagits samman med "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Ärende %s: första åtgärdstid har passerats (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ärende %s: första åtgärdstid har passerats om %s!',
        'Ticket %s: update time is over (%s)!' => 'Ärende %s: uppdateringstid har passerats (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ärende %s: uppdateringstid har passerats om %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ärende %s: lösningstid har passerats (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Ärende %s: lösningstid har passerats om %s!',
        'There are more escalated tickets!' => 'Det finns fler eskalerade ärenden!',
        'New ticket notification' => 'Meddelande om nyskapat ärende',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Skicka mig ett meddelande om det finns nya ärenden i "Mina Köer".',
        'Follow up notification' => 'Meddelande om uppföljning',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Skicka mig ett meddelande om kundkorrespondens för ärenden som jag är ägare till.',
        'Ticket lock timeout notification' => 'Meddela mig då tiden gått ut för ett ärende-lås',
        'Send me a notification if a ticket is unlocked by the system.' => 'Skicka mig ett meddelande ifall systemet tar bort låset på ett ärende.',
        'Move notification' => 'Meddelande om ändring av kö',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Skicka mig ett meddelande ifall ett ärende flyttas till en av "Mina köer"',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Ditt urval av favoritköer. Du blir också meddelad om dessa köer via epost om det aktiverats.',
        'Custom Queue' => 'Utvald kö',
        'QueueView refresh time' => 'Automatisk uppdateringsintervall fö Kö-bild',
        'Screen after new ticket' => 'Skärm efter inmatning av nytt ärende',
        'Select your screen after creating a new ticket.' => 'Välj skärmbild som visas efter registrering av ny hänvisning/ärende.',
        'Closed Tickets' => 'Låsta ärenden',
        'Show closed tickets.' => 'Visa låsta ärenden.',
        'Max. shown Tickets a page in QueueView.' => 'Max. visade ärenden per sida i Kö-bild.',
        'Watch notification' => 'Bevakningsmeddelanden',
        'Send me a notification of an watched ticket like an owner of an ticket.' => '',
        'Out Of Office' => 'Ej på Kontoret',
        'Select your out of office time.' => 'Välj din fånvarotid.',
        'CompanyTickets' => 'Företagsärenden',
        'MyTickets' => 'Mina ärenden',
        'New Ticket' => 'Nytt ärende',
        'Create new Ticket' => 'Skapa nytt ärende',
        'Customer called' => 'Kund ringde',
        'phone call' => 'telefonsamtal',
        'Reminder Reached' => 'Påminnelse Finns',
        'Reminder Tickets' => 'Påminnelse Ärenden',
        'Escalated Tickets' => 'Eskalerade Ärenden',
        'New Tickets' => 'Nya Ärenden',
        'Open Tickets / Need to be answered' => 'Öppna ärenden / Måste besvaras',
        'Tickets which need to be answered!' => 'Ärenden som måste besvaras!',
        'All new tickets!' => 'Alla nya ärenden!',
        'All tickets which are escalated!' => 'Alla ärenden som har eskalerats!',
        'All tickets where the reminder date has reached!' => 'Alla ärenden där påmminnelsetiden nåtts!',
        'Responses' => 'Svar',
        'Responses <-> Queues' => 'Svar <-> Kö',
        'Auto Responses' => 'AutoSvar',
        'Auto Responses <-> Queues' => 'AutoSvar <-> Kö',
        'Attachments <-> Responses' => '<Bifogade filer <-> Svar',
        'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp for [%s]. %s',
        'History::SendAutoReject' => 'AutoReject sent to "%s".',
        'History::SendAutoReply' => 'AutoReply sent to "%s".',
        'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
        'History::Forward' => 'Forwarded to "%s".',
        'History::Bounce' => 'Bounced to "%s".',
        'History::SendAnswer' => 'Email sent to "%s".',
        'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
        'History::SendCustomerNotification' => 'Notification sent to "%s".',
        'History::EmailAgent' => 'Email sent to customer.',
        'History::EmailCustomer' => 'Added email. %s',
        'History::PhoneCallAgent' => 'Agent called customer.',
        'History::PhoneCallCustomer' => 'Customer called us.',
        'History::AddNote' => 'Added note (%s)',
        'History::Lock' => 'Locked ticket.',
        'History::Unlock' => 'Unlocked ticket.',
        'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Updated: %s',
        'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
        'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Updated: %s',
        'History::StateUpdate' => 'Old: "%s" New: "%s"',
        'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Customer request via web.',
        'History::TicketLinkAdd' => 'Added link to ticket "%s".',
        'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'sön',
        'Mon' => 'mån',
        'Tue' => 'tis',
        'Wed' => 'ons',
        'Thu' => 'tor',
        'Fri' => 'fre',
        'Sat' => 'lör',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Hantering av bifogade dokument',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Autosvar-hantering',
        'Response' => 'Svar',
        'Auto Response From' => 'autosvar-avsändare',
        'Note' => 'Notis',
        'Useable options' => 'Användbara tillägg',
        'To get the first 20 character of the subject.' => 'För att få dom första 20 tecknen i ärenderaden',
        'To get the first 5 lines of the email.' => 'För att få dom första fem raderna i mejlet',
        'To get the realname of the sender (if given).' => 'För att få avsändarens riktiga namn (om angivet).',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'För att få artikelns attribut (t.ex. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> och <OTRS_CUSTOMER_Body)).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Val av nuvarande kunds data (t.ex. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Ärende-Ägarval (t.ex. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Ärende-Ansvarigval (t.ex. <OTRS_RESPONSIBLE_USerFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Val för användaren som begärde åtgärden (t.ex. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Val för ärendedata (t.ex. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Inställningsval (t.ex. <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Kundföretagshantering',
        'Search for' => 'Sök efter',
        'Add Customer Company' => 'Lägg till Kundföretag',
        'Add a new Customer Company.' => 'Lägg till ett nytt Kundföretag.',
        'List' => 'Lista',
        'These values are required.' => 'Dessa värden är tvingande.',
        'These values are read-only.' => 'Dessa värden är skrivskyddade.',

        # Template: AdminCustomerUserForm
        'Title{CustomerUser}' => '',
        'Firstname{CustomerUser}' => '',
        'Lastname{CustomerUser}' => '',
        'Username{CustomerUser}' => '',
        'Email{CustomerUser}' => '',
        'CustomerID{CustomerUser}' => '',
        'Phone{CustomerUser}' => '',
        'Fax{CustomerUser}' => '',
        'Mobile{CustomerUser}' => '',
        'Street{CustomerUser}' => '',
        'Zip{CustomerUser}' => '',
        'City{CustomerUser}' => '',
        'Country{CustomerUser}' => '',
        'Comment{CustomerUser}' => '',
        'The message being composed has been closed.  Exiting.' => 'Det tilhörande redigeringsfönstret har stängts. Avslutar.',
        'This window must be called from compose window' => 'Denna funktion måste startas från redigeringsfönstret',
        'Customer User Management' => 'Kundanvändare',
        'Add Customer User' => 'Lägg till Kundanvändare',
        'Source' => 'Källa',
        'Create' => 'Skapa',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Kundanvändare krävs för att hålla kundhistorik och för att dom ska kunna logga in via kundpanelen.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Kundanvändare <-> Grupphantering',
        'Change %s settings' => 'Ändra %s-inställningar',
        'Select the user:group permissions.' => 'Välj användar:grupp-rättigheter.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Om ingenting är valt finns inga rättigheter i denna grupp (ärenden i denna grupp kommer inte att finnas tillgängliga för användaren).',
        'Permission' => 'Rättighet',
        'ro' => 'läs',
        'Read only access to the ticket in this group/queue.' => 'Endast läsrättighet till ärenden i denna grupp/kö.',
        'rw' => 'skriv',
        'Full read and write access to the tickets in this group/queue.' => 'Fulla läs- och skrivrättigheter till ärenden i denna grupp/kö.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Kundanvändare <-> Tjänsthantering',
        'CustomerUser' => 'Kundanvändare',
        'Service' => 'Tjänst',
        'Edit default services.' => 'Redigera standardtjänster',
        'Search Result' => 'Sökeresultat',
        'Allocate services to CustomerUser' => 'Allokera tjänster till Kundanvändare',
        'Active' => 'Aktivera',
        'Allocate CustomerUser to service' => 'Allokera Kundanvändare till tjänst',

        # Template: AdminEmail
        'Message sent to' => 'Meddelande skickat till',
        'A message should have a subject!' => 'Ett meddelande måste ha en Ämnesrad!',
        'Recipients' => 'Mottagare',
        'Body' => 'Meddelandetext',
        'Send' => 'Skicka',

        # Template: AdminGenericAgent
        'GenericAgent' => 'GenerellAgent',
        'Job-List' => 'Jobblista',
        'Last run' => 'Senaste körning',
        'Run Now!' => 'Kör Nu!',
        'x' => 'x',
        'Save Job as?' => 'Spara Jobb som?',
        'Is Job Valid?' => 'Är Jobbet Giltligt?',
        'Is Job Valid' => 'Är Jobbet Giltligt',
        'Schedule' => 'Schema',
        'Currently this generic agent job will not run automatically.' => 'För närvarande kommer detta jobb inte köras automatiskt.',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'För att aktivera automatisk körning måste du minst välja ett värde från minuter, timmar och dagar!',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fritextsök i artiklar (t.ex. "Mo*ot" eller "Kött*")',
        '(e. g. 10*5155 or 105658*)' => 't.ex. 10*5144 eller 105658*',
        '(e. g. 234321)' => 't.ex. 163736',
        'Customer User Login' => 'kundanvändare loginnamn',
        '(e. g. U5150)' => 't.ex. INGJAN',
        'SLA' => 'SLA',
        'Agent' => 'Agent',
        'Ticket Lock' => 'Ärendelås',
        'TicketFreeFields' => 'ÄrendeFriaFält',
        'Create Times' => 'Skapat-Tider',
        'No create time settings.' => 'Inga Skapat-Tider.',
        'Ticket created' => 'Ärende skapat',
        'Ticket created between' => 'Ärendet skapat mellan',
        'Close Times' => 'Stängt-Tider',
        'No close time settings.' => 'Inga Stängt-Tider',
        'Ticket closed' => 'Ärende stängt',
        'Ticket closed between' => 'Ärende stängt mellan',
        'Pending Times' => 'Avvaktar-Tider',
        'No pending time settings.' => 'Inga Avvaktar-Tider',
        'Ticket pending time reached' => 'Ärende väntetid nådd',
        'Ticket pending time reached between' => 'Ärende väntetid nådd mellan',
        'Escalation Times' => 'Eskalerings-Tider',
        'No escalation time settings.' => 'Inga Eskalerings-Tider',
        'Ticket escalation time reached' => 'Ärende Eskaleringstid nådd',
        'Ticket escalation time reached between' => 'Ärende Eskaleringstid nådd mellan',
        'Escalation - First Response Time' => 'Eskalering - Första responstid',
        'Ticket first response time reached' => 'Ärende första responstid nådd',
        'Ticket first response time reached between' => 'Ärende första responstid nådd mellan',
        'Escalation - Update Time' => 'Eskalering - Uppdateringstid',
        'Ticket update time reached' => 'Ärende uppdateringstid nådd',
        'Ticket update time reached between' => 'Ärende uppdaterings tid nådd mellan',
        'Escalation - Solution Time' => 'Eskalering - Lösningstid',
        'Ticket solution time reached' => 'Ärende lösningstid nådd',
        'Ticket solution time reached between' => 'Ärende lösningstid nådd mellan',
        'New Service' => 'Ny tjänst',
        'New SLA' => 'Ny SLA',
        'New Priority' => 'Ny Prioritet',
        'New Queue' => 'Ny Kö',
        'New State' => 'Ny Status',
        'New Agent' => 'Ny Agent',
        'New Owner' => 'Ny Ägare',
        'New Customer' => 'Ny Kund',
        'New Ticket Lock' => 'Nytt Ärendelås',
        'New Type' => 'Ny Typ',
        'New Title' => 'Ny Titel',
        'New TicketFreeFields' => 'Ny TicketFriaFält',
        'Add Note' => 'Lägg till anteckning',
        'Time units' => 'Tidsenheter',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Detta kommando kommer utföras. ARG[0] blir dess ärendenummer. ARG[1] dess ärende-id.',
        'Delete tickets' => 'Radera ärenden',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Varning! Dessa ärenden kommer raderas från databasen! Ärendena förloras!',
        'Send Notification' => 'Skicka Meddelande',
        'Param 1' => 'Param 1',
        'Param 2' => 'Param 2',
        'Param 3' => 'Param 3',
        'Param 4' => 'Param 4',
        'Param 5' => 'Param 5',
        'Param 6' => 'Param 6',
        'Send agent/customer notifications on changes' => 'Meddela agent/kund angående ändringar',
        'Save' => 'Spara',
        '%s Tickets affected! Do you really want to use this job?' => '%s Ärenden påverkas! Vill du verkligen använda detta jobb?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>          'VARNING: När du ändrar namnet på gruppen \'admin\', innan du gör lämpliga ändringar i SysConfig, kommer du låsas ut ur administrationspanelen! Om detta inträffar, döp om grubben tillbaka till admin via SQL. ',
        'Group Management' => 'grupphantering',
        'Add Group' => 'Lägg till Grupp',
        'Add a new Group.' => 'Lägg till en ny Grupp.',
        'The admin group is to get in the admin area and the stats group to get stats area.' => '\'admin\'-gruppen ger tillgång till Admin-arean, \'stats\'-gruppen till Statistik-arean.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Skapa nya grupper för att kunna hantera olika rättigheter för skilda grupper av agenter (t.ex. inköpsavdelning, supportavdelning, försäljningsavdelning, ...).',
        'It\'s useful for ASP solutions.' => 'Nyttigt för ASP-lösningar.',

        # Template: AdminLog
        'System Log' => 'Systemlogg',
        'Time' => 'Tid',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Epostkontohantering',
        'Host' => 'Värd',
        'Trusted' => 'Betrodd',
        'Dispatching' => 'Fördelning',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Inkommande email från POP3-konton sorteras till vald kö!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'om ditt konto är betrott, kommer befinglig X-OTRS-header användas vid ankomst (För prioritering, ...) PostMasterfilter kommer användas ändå.',

        # Template: AdminNavigationBar
        'Users' => 'Användare',
        'Groups' => 'Grupper',
        'Misc' => 'Div',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Meddelandehantering',
        'Add Notification' => 'Lägg till Meddelande',
        'Add a new Notification.' => 'Lägg till nytt Meddelande',
        'Name is required!' => 'Namn krävs!',
        'Event is required!' => 'Aktivitet krävs!',
        'A message should have a body!' => 'Ett meddelande måste innehålla en meddelandetext!',
        'Recipient' => 'Mottagare',
        'Group based' => 'Gruppbaserad',
        'Agent based' => 'Agentbaserad',
        'Email based' => 'Epostbaserad',
        'Article Type' => 'Artikeltyp',
        'Only for ArticleCreate Event.' => 'Endast för ArtikelSkapa-Aktivitet',
        'Subject match' => 'Ärenderad matchar',
        'Body match' => 'Kropp matchar',
        'Notifications are sent to an agent or a customer.' => 'Meddelanden skickats till agenter eller kunder.',
        'To get the first 20 character of the subject (of the latest agent article).' => 'För att få de första 20 tecknen i ärenderaden (på senaste agentartikeln).',
        'To get the first 5 lines of the body (of the latest agent article).' => 'För att få de första fem raderna i kroppen (på senaste agentartikeln).',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'För att få artikelattributen (t.ex. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> och <OTRS_AGENT_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => 'För att då de första 20 tecknen i ärenderaden (på senaste kundartikeln).',
        'To get the first 5 lines of the body (of the latest customer article).' => 'För att få de fem första raderna i kroppen (på senaste kundartikeln).',

        # Template: AdminNotificationForm
        'Notification' => 'Meddelande',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakethanterare',
        'Uninstall' => 'Avinstallera',
        'Version' => 'Version',
        'Do you really want to uninstall this package?' => 'Vill du verkligen avinstallera detta paket?',
        'Reinstall' => 'Ominstallera',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Vill du verligen ominstallera detta paket (Alla manuella ändringar försvinner)?',
        'Continue' => 'Fortsätt',
        'Install' => 'Installera',
        'Package' => 'Paket',
        'Online Repository' => 'Online Repository',
        'Vendor' => 'Leverantör',
        'Module documentation' => 'Moduldokumentation',
        'Upgrade' => 'Uppgradera',
        'Local Repository' => 'Local Repository',
        'Status' => 'Status',
        'Overview' => 'Översikt',
        'Download' => 'Nerladdning',
        'Rebuild' => 'Rebuild',
        'ChangeLog' => 'Ändringslogg',
        'Date' => 'Datum',
        'Filelist' => 'Fillista',
        'Download file from package!' => 'Ladda ner fil från paket!',
        'Required' => 'Krävs',
        'PrimaryKey' => 'Primärnyckel',
        'AutoIncrement' => 'AutoInkrement',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Prestandalogg',
        'This feature is enabled!' => 'Denna funktion är aktiverad!',
        'Just use this feature if you want to log each request.' => 'Använd endast denna funktion om du vill logga varje request.',
        'Activating this feature might affect your system performance!' => 'Att aktivera denna funktion kan påverka din systemprestanda!',
        'Disable it here!' => 'Avaktivera det här!',
        'This feature is disabled!' => 'Denna funktion är avaktiverad!',
        'Enable it here!' => 'Aktivera den här!',
        'Logfile too large!' => 'Loggfilen är för stor!',
        'Logfile too large, you need to reset it!' => 'Loggfilen är för stor, du måste återställa den!',
        'Range' => 'Intervall',
        'Interface' => 'Interface',
        'Requests' => 'Requests',
        'Min Response' => 'Min respons',
        'Max Response' => 'Max respons',
        'Average Response' => 'Medel respons',
        'Period' => 'Period',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Medel',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP-Hantering',
        'Result' => 'Resultat',
        'Identifier' => 'Identifierare',
        'Bit' => 'Bit',
        'Key' => 'Nyckel',
        'Fingerprint' => 'Fingeravtryck',
        'Expires' => 'Upphör',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'På det här sättet kan du direkt redigera nyckelringen som är inställd i SysConfig.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Filter',
        'Filtername' => 'Filternamn',
        'Stop after match' => 'Avsluta efter träff',
        'Match' => 'Träff',
        'Value' => 'Innehåll',
        'Set' => 'Använd',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Sänd eller filtrera inkommande epost baserad på X-Headers! RegExp är också möjlig.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Om du bara vill hantera epostadressen, använd EMAILADDRESS:info@example.com i Från, Till eller CC.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Om du använder RegExp, kan du också använda träffvärdet i ()= såsom [***] i \'Set\'.',

        # Template: AdminPriority
        'Priority Management' => 'Prioritet',
        'Add Priority' => 'Lägg till Prioritet',
        'Add a new Priority.' => 'Lägg till ny Prioritet.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Kö <-> Autosvar',
        'settings' => 'inställningar',

        # Template: AdminQueueForm
        'Queue Management' => 'Köhantering',
        'Sub-Queue of' => 'Underkö till',
        'Unlock timeout' => 'Tidsintervall för borttagning av lås',
        '0 = no unlock' => '0 = ingen upplåsning',
        'Only business hours are counted.' => 'Endast kontorstid räknas.',
        '0 = no escalation' => '0 = ingen upptrappning',
        'Notify by' => 'Meddela via',
        'Follow up Option' => 'Korrespondens på låst ärende',
        'Ticket lock after a follow up' => 'Ärendet låses efter uppföljningsmail',
        'Systemaddress' => 'Systemadress',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ifall ett ärende som är låst av en agent men ändå inte blir besvarat inom denna tid, kommer låset automatiskt att tas bort.',
        'Escalation time' => 'Upptrappningstid',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Ifall ett ärende inte blir besvarat inom denna tid, visas enbart detta ärende.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ifall en kund skickar uppföljningsmail på ett låst ärende, blir ärendet låst till förra ägaren.',
        'Will be the sender address of this queue for email answers.' => 'Avsändaradress för email i denna Kö.',
        'The salutation for email answers.' => 'Hälsningsfras för email-svar.',
        'The signature for email answers.' => 'Signatur för email-svar.',
        'Customer Move Notify' => 'Meddelande om flytt av kund',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS skickar ett meddelande till kunden ifall ärendet flyttas.',
        'Customer State Notify' => 'Meddelande om statusändring för Kund',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS skickar ett meddelande till kunden vid statusuppdatering.',
        'Customer Owner Notify' => 'Meddelande om byte av ägare av Kund',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS skickar ett meddelande till kunden vid ägarbyte.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Svar <-> Köer',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Svar',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Svar <-> Bifogade filer',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Hantera svar',
        'A response is default text to write faster answer (with default text) to customers.' => 'Ett svar är en standardtext för att underlätta besvarandet av vanliga kundfrågor.',
        'Don\'t forget to add a new response a queue!' => 'Kom ihåg att lägga till ett nytt svar till en kö!',
        'The current ticket state is' => 'Nuvarande ärendestatus',
        'Your email address is new' => 'Din epostadress är ny',

        # Template: AdminRoleForm
        'Role Management' => 'Roller',
        'Add Role' => 'Lägg till Roll',
        'Add a new Role.' => 'Lägg till ny Roll.',
        'Create a role and put groups in it. Then add the role to the users.' => 'Skapa en roll och lägg grupper i den. Lägg sedan till rollen till användare.',
        'It\'s useful for a lot of users and groups.' => 'Det är användbart för många användare och grupper.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Roller <-> Grupper',
        'move_into' => 'Flytta till',
        'Permissions to move tickets into this group/queue.' => 'Rätt att flytta ärenden i denna grupp/Kö.',
        'create' => 'Skapa',
        'Permissions to create tickets in this group/queue.' => 'Rätt att skapa ärenden i denna grupp/Kö.',
        'owner' => 'Ägare',
        'Permissions to change the ticket owner in this group/queue.' => 'Rätt att ändra ärende-ägare i denna grupp/Kö.',
        'priority' => 'prioritet',
        'Permissions to change the ticket priority in this group/queue.' => 'Rätt att ändra ärendeprioritet i denna grupp/Kö.',

        # Template: AdminRoleGroupForm
        'Role' => 'Roll',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Roller <-> Användare',
        'Select the role:user relations.' => 'Välj roll:användar relationer',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Hantering av Hälsningsfraser',
        'Add Salutation' => 'Lägg till Hälsningsfras',
        'Add a new Salutation.' => 'Lägg till en ny Hälsningsfras.',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Säkert läge måste slås på!',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Säkert läge använda (normalt) efter iledande installation är slutförd.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Säkert läge måste slås av för att kunna ominstallera via webb-installeraren.',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Om säkert läge inte är aktiverat, slå på det via SysConfig, för din applikation körs redan.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL Box',
        'Go' => 'Kör',
        'Select Box Result' => 'Select Box Resultat',

        # Template: AdminService
        'Service Management' => 'Tjänster',
        'Add Service' => 'Lägg till Tjänst',
        'Add a new Service.' => 'Lägg till ny Tjänst.',
        'Sub-Service of' => 'UnderTjänst till',

        # Template: AdminSession
        'Session Management' => 'Sessionshantering',
        'Sessions' => 'Sessioner',
        'Uniq' => 'Unika',
        'Kill all sessions' => 'Terminera alla sessioner',
        'Session' => 'Session',
        'Content' => 'Innehåll',
        'kill session' => 'Terminera session',

        # Template: AdminSignatureForm
        'Signature Management' => 'Signaturer',
        'Add Signature' => 'Lägg till Signatur',
        'Add a new Signature.' => 'Lägg till ny Signatur.',

        # Template: AdminSLA
        'SLA Management' => 'SLA',
        'Add SLA' => 'Lägg till SLA',
        'Add a new SLA.' => 'Lägg till ny SLA.',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME',
        'Add Certificate' => 'Lägg till Certifikat',
        'Add Private Key' => 'Lägg till Privat Nyckel',
        'Secret' => 'Hemlighet',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => 'På det här sättet kan du redigera certifikat och nycklar på filsystemet.',

        # Template: AdminStateForm
        'State Management' => 'Status',
        'Add State' => 'Lägg till Status',
        'Add a new State.' => 'Lägg till ny Status.',
        'State Type' => 'Statustyp',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Se till att du också uppdaterade standardstatusarna i Kernel/Config.pm!',
        'See also' => 'Se också',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Group selection' => 'Gruppval',
        'Show' => 'Visa',
        'Download Settings' => 'Ladda ner inställningar',
        'Download all system config changes.' => 'Ladda ner alla systemkonfigurationsändringar.',
        'Load Settings' => 'Ladda Inställningar',
        'Subgroup' => 'Undergrupp',
        'Elements' => 'Element',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Konfigureringsinställningar',
        'Default' => 'Standard',
        'New' => 'Nytt',
        'New Group' => 'Ny Grupp',
        'Group Ro' => 'Grupp Ro',
        'New Group Ro' => 'Ny Grupp Ro',
        'NavBarName' => 'NavigationsRadNamn',
        'NavBar' => 'NavigationsRad',
        'Image' => 'Bild',
        'Prio' => 'Prioritet',
        'Block' => 'Blockera',
        'AccessKey' => 'ÅtkomstTangent',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'System-emailadresser',
        'Add System Address' => 'Lägg till Systemadress',
        'Add a new System Address.' => 'Lägg till ny Systemadress',
        'Realname' => 'Fullständigt namn',
        'All email addresses get excluded on replaying on composing an email.' => 'Alla epostadresser exkluderas vid skapande av epost',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alla inkommande mail till denna adressat (To:) delas ut till vald kö.',

        # Template: AdminTypeForm
        'Type Management' => 'Ärendetyp',
        'Add Type' => 'Lägg till Typ',
        'Add a new Type.' => 'Lägg till ny Typ',

        # Template: AdminUserForm
        'User Management' => 'Användare',
        'Add User' => 'Lägg till Användare',
        'Add a new Agent.' => 'Lägg till ny Agent.',
        'Login as' => 'Logga in som',
        'Title{user}' => '',
        'Firstname' => 'Förnamn',
        'Lastname' => 'Efternamn',
        'Start' => 'Start',
        'End' => 'Slut',
        'User will be needed to handle tickets.' => 'Användare krävs för att hantera ärenden.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Glöm inte att lägga nya användare i grupper och/eller roller!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Användare <-> Grupper',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adressbok',
        'Return to the compose screen' => 'Stäng fönstret',
        'Discard all changes and return to the compose screen' => 'Bortse från ändringarna och stäng fönstret',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardCalendarOverview
        'in' => 'i',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s är tillgänlig!',
        'Please update now.' => 'Vänligen uppdatera nu.',
        'Release Note' => 'Release Note',
        'Level' => 'Nivå',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Postad för %s sedan.',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Länkobjekt: %s',
        'Object' => 'Objekt',
        'Link Object' => 'Länka objekt',
        'with' => 'med',
        'Select' => 'Välj',
        'Unlink Object: %s' => 'Avlänka objekt: %s',

        # Template: AgentLookup
        'Lookup' => 'Slå upp',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Stavningskontroll',
        'spelling error(s)' => 'Stavfel',
        'or' => 'eller',
        'Apply these changes' => 'Verkställ ändringar',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Vll du verkligen radera detta Objekt?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Välj begränsningar som karaktäriserar statistiken',
        'Fixed' => 'Fast',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Välj endast ett värde, eller slå av knappen \'Fast\'.',
        'Absolut Period' => 'Absolut period',
        'Between' => 'Mellan',
        'Relative Period' => 'Relativ period',
        'The last' => 'De senaste',
        'Finish' => 'Slut',
        'Here you can make restrictions to your stat.' => 'Här kan du sätta restriktioner på din statistik.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Om du raderar innehållet i "Fast" bockrutan, kan agenten som genererar statistiken ändra attributen på motsvarande element.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '',
        'Permissions' => '',
        'Format' => '',
        'Graphsize' => '',
        'Sum rows' => '',
        'Sum columns' => '',
        'Cache' => '',
        'Required Field' => '',
        'Selection needed' => '',
        'Explanation' => '',
        'In this form you can select the basic specifications.' => '',
        'Attribute' => '',
        'Title of the stat.' => '',
        'Here you can insert a description of the stat.' => '',
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
        'Select the elements for the value series' => '',
        'Scale' => '',
        'minimal' => '',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '',
        'maximal period' => '',
        'minimal scale' => '',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => '',
        'File is not a Stats config' => '',
        'No File selected' => '',

        # Template: AgentStatsOverview
        'Results' => 'Resultat',
        'Total hits' => 'Totalt hittade',
        'Page' => 'Sida',

        # Template: AgentStatsPrint
        'Print' => 'Skriv ut',
        'No Element selected.' => '',

        # Template: AgentStatsView
        'Export Config' => '',
        'Information about the Stat' => '',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => '',
        'maximal period from' => '',
        'to' => '',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Ett meddelande måste ha en mottagare i Till:-fältet!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'I Till-fältet måste anges en giltig emailadress (t.ex. kund@exempeldomain.se)!',
        'Bounce ticket' => 'Skicka över ärende',
        'Ticket locked!' => 'Ärendet låst',
        'Ticket unlock!' => 'Ärendet upplåst',
        'Bounce to' => 'Skicka över till',
        'Next ticket state' => 'Nästa ärendestatus',
        'Inform sender' => 'Informera avsändare',
        'Send mail!' => 'Skicka mail!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Du måste redovisa tiden!',
        'Ticket Bulk Action' => 'Ärendemassförändring',
        'Spell Check' => 'Stavningskontroll',
        'Note type' => 'Anteckningstyp',
        'Next state' => 'Nästa tillstånd',
        'Pending date' => 'Väntande datum',
        'Merge to' => 'Slå samman med',
        'Merge to oldest' => 'Slå samman till äldsta',
        'Link together' => 'Länka',
        'Link to Parent' => 'Länka med Förälder',
        'Unlock Tickets' => 'Lås upp Ärenden',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Ärendetyp krävs!',
        'A required field is:' => 'Ett tvingande fält är:',
        'Close ticket' => 'Stäng ärende',
        'Previous Owner' => 'Tidigare ägare',
        'Inform Agent' => 'Meddela Agent',
        'Optional' => 'Valfri',
        'Inform involved Agents' => 'Meddela inblandade agenter',
        'Attach' => 'Bifoga',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Stavningskontroll måste utföras på alla meddelanden!',
        'Compose answer for ticket' => 'Författa svar till ärende',
        'Pending Date' => 'Väntar till',
        'for pending* states' => 'för väntetillstånd',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Ändra kund för ärende',
        'Set customer user and customer id of a ticket' => 'Ange kundanvändare och organisations-id för ett ärende',
        'Customer User' => 'Kundanvändare',
        'Search Customer' => 'Sök kund',
        'Customer Data' => 'Kunddata',
        'Customer history' => 'Kundhistorik',
        'All customer tickets.' => 'Alla kundärenden.',

        # Template: AgentTicketEmail
        'Compose Email' => 'Skriv email',
        'new ticket' => 'Nytt ärende',
        'Refresh' => 'Uppdatera',
        'Clear To' => 'Rensa Till',
        'All Agents' => 'Alla agenter',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Artikeltyp',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Ändra friatextfält i ärende',

        # Template: AgentTicketHistory
        'History of' => 'Historik för',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Du måste ange ett ärendenummer!',
        'Ticket Merge' => 'Slå samman',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => '',
        'Move Ticket' => 'Flytta ärende',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Lägg till anteckning till ärende',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Första Responstid',
        'Service Time' => 'Tjänsttid',
        'Update Time' => 'Uppdateringstid',
        'Solution Time' => 'Lösningstid',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Du måste ha minst ett valt ärende!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filter',
        'Change search options' => 'Ändra sökinställningar',
        'Tickets' => 'Ärenden',
        'of' => 'av',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Skriv svar',
        'Contact customer' => 'Kontakta kund',
        'Change queue' => 'Ändra kö',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'Sortera stigande',
        'up' => 'stigande',
        'sort downward' => 'Sortera sjunkande',
        'down' => 'sjunkande',
        'Escalation in' => 'Upptrappning om',
        'Locked' => 'Låst',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Ändra ett ärendes ägare',

        # Template: AgentTicketPending
        'Set Pending' => 'Markera som väntande',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefonsamtal',
        'Clear From' => 'Nollställ Från:',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Enkel',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ärendeinfo',
        'Accounted time' => 'Redovisad tid',
        'Linked-Object' => 'Länkat objekt',
        'by' => 'av',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Ändra ärendeprioritet',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Ärenden som visas',
        'Tickets available' => 'Tillgängliga ärenden',
        'All tickets' => 'Alla ärenden',
        'Queues' => 'Köer',
        'Ticket escalation!' => 'Ärende-upptrappning!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Ändra ansvarig på ärendet',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Ärende-sök',
        'Profile' => 'Profil',
        'Search-Template' => 'Sökmall',
        'TicketFreeText' => 'ÄrendeFriText',
        'Created in Queue' => 'Skapad i Kö',
        'Article Create Times' => 'Artikel Skapad Tider',
        'Article created' => 'Artikel skapad',
        'Article created between' => 'Artikel skapad mellan',
        'Change Times' => 'ÄndringsTider',
        'No change time settings.' => 'Inga Ändringstider',
        'Ticket changed' => 'Ärende ändrat',
        'Ticket changed between' => 'Ärende ändrat mellan',
        'Result Form' => 'Resultatbild',
        'Save Search-Profile as Template?' => 'Spara sökkriterier som mall?',
        'Yes, save it with name' => 'Ja, spara med namn',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Fritext',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Expandera vy',
        'Collapse View' => 'Minimera vy',
        'Split' => 'Dela',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Artikelfilterinställningar',
        'Save filter settings as default' => 'Spara filterinställningar som standard',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Återspårning',

        # Template: CustomerFooter
        'Powered by' => 'Drivs av',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Login',
        'Lost your password?' => 'Glömt lösenordet?',
        'Request new password' => 'Be om nytt lösenord',
        'Create Account' => 'Skapa konto',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Välkommen %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Tider',
        'No time settings.' => 'Inga tidsinställningar.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klicka här för att rapportera ett fel!',

        # Template: Footer
        'Top of Page' => 'Början av sidan',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Hem',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-installation',
        'Welcome to %s' => 'Välkommen till %s',
        'Accept license' => 'Acceptera licens',
        'Don\'t accept license' => 'Acceptera inte licens',
        'Admin-User' => 'Admin-användare',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>          'Om du har ett root-lösenord för databasen måste det anges här. Annars lämnar du fältet tomt. Av säkerhetssjäl rekommenderar vi dig att du har ett rootlösenord. För mer information hänvisas du till databasdokumentationen.',
        'Admin-Password' => 'Admin-Lösen',
        'Database-User' => 'Databas-Användare',
        'default \'hot\'' => 'default \'hot\'',
        'DB connect host' => 'DB anslutninsvärd (host)',
        'Database' => 'Databas',
        'Default Charset' => 'Standard teckenuppsättning',
        'utf8' => 'utf8',
        'false' => 'falsk',
        'SystemID' => 'SystemID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Unikt id för detta system.  Alla ärendenummer och http-sessionsid börjar med denna id)',
        'System FQDN' => 'System FQDN',
        '(Full qualified domain name of your system)' => '(Fullt kvalificerat dns-namn för ditt system)',
        'AdminEmail' => 'Admin-email',
        '(Email of the system admin)' => '(Email till systemadmin)',
        'Organization' => 'Organisation',
        'Log' => 'Logg',
        'LogModule' => 'LoggningsModul',
        '(Used log backend)' => '(Valt logg-backend)',
        'Logfile' => 'Loggfil',
        '(Logfile just needed for File-LogModule!)' => '(Loggfil behövs enbart för File-LogModule!)',
        'Webfrontend' => 'Webb-gränssnitt',
        'Use utf-8 it your database supports it!' => 'Använd utf-8 ifall din databas stödjer det!',
        'Default Language' => 'Standardspråk',
        '(Used default language)' => '(Valt standardspråk)',
        'CheckMXRecord' => 'KontrolleraMXFält',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrollerar mx-uppslag för uppgivna emailadresser i meddelanden som skrivs.  Använd inte CheckMXRecord om din OTRS-maskin är bakom en uppringd lina!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'För att kunna använda OTRS, måste följende rad skrivas på kommandoraden som root.',
        'Restart your webserver' => 'Starta om din webbserver',
        'After doing so your OTRS is up and running.' => 'Efter detta är OTRS igång.',
        'Start page' => 'Startsida',
        'Your OTRS Team' => 'Ditt OTRS-Team',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ingen åtkomst',

        # Template: Notify
        'Important' => 'Viktigt',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'utskrivet av',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS Test-sida',
        'Counter' => 'Räknare',

        # Template: Warning

        # Template: YUI

        # Misc
        'Edit Article' => 'Redigera Artikel',
        'Create Database' => 'Skapa databas',
        'DB Host' => 'DB Värd (host)',
        'Ticket Number Generator' => 'Ärende-nummergenerator',
        'Symptom' => 'Symptom',
        'U' => 'U',
        'Site' => 'Plats',
        'Customer history search (e. g. "ID342425").' => 'Sök efter kundhistorik (t.ex. "ID342425").',
        'Can not delete link with %s!' => 'Kan inte radera länk med %s!',
        'for agent firstname' => 'för agents förnamn',
        'Close!' => 'Stäng!',
        'Subgroup \'' => 'Undergrupp \'',
        'No means, send agent and customer notifications on changes.' => 'Nej betyder, sänd agent och kundmeddelanden vid ändringar.',
        'A web calendar' => 'En webbkalender',
        'to get the realname of the sender (if given)' => 'för att få fram avsändarens fulla namn (om möjligt)',
        'OTRS DB Name' => 'OTRS DB namn',
        'Notification (Customer)' => 'Meddelande (Kund)',
        'Select Source (for add)' => 'Välj källa (för tillägg)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Val för ärende data (t.ex &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Barn-Objekt',
        'Days' => 'Dagar',
        'Queue ID' => 'Kö-id',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Konfigurationsval (t.ex. <OTRS_CONFIG_HttpType>)',
        'System History' => 'Systemhistorik',
        'customer realname' => 'Fullt kundnamn',
        'Pending messages' => 'Väntande meddelanden',
        'Port' => 'Port',
        'for agent login' => 'för agents login',
        'Keyword' => 'Nyckelord',
        'Close type' => 'Stängningstyp',
        'DB Admin User' => 'DB Adminanvändare',
        'for agent user id' => 'för agents användar-id',
        'Change user <-> group settings' => 'Ändra användar- <-> grupp-inställningar',
        'Problem' => 'Problem',
        'for ' => 'för',
        'Escalation' => 'Eskalering',
        '"}' => '"}',
        'Order' => 'Sortering',
        'next step' => 'nästa steg',
        'Follow up' => 'Uppföljning',
        'Customer history search' => 'Kundhistorik',
        'Admin-Email' => 'Admin-email',
        'Stat#' => 'Stat#',
        'Create new database' => 'Skapa ny databas',
        'Keywords' => 'Nyckelord',
        'Ticket Escalation View' => 'Ärendeeskaleringsvy',
        'Today' => 'Idag',
        'No * possible!' => 'Wildcards * inte tillåtna!',
        'Options ' => 'Tillval',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Tillval för nuvarande användare som begärde denna åtgärd (t.ex. <OTRS_CURRENT_USERFIRSTNAME>)',
        'Message for new Owner' => 'Meddelande till ny ägare',
        'to get the first 5 lines of the email' => 'för att få fram de första 5 raderna av emailen',
        'Sort by' => 'Sortera efter',
        'OTRS DB Password' => 'OTRS DB lösenord',
        'Last update' => 'Senast ändrat',
        'Tomorrow' => 'Imorgon',
        'to get the first 20 character of the subject' => 'för att få fram de förste 20 tecknen i ämnesbeskrivningen',
        'Select the customeruser:service relations.' => 'Välj Kund:Servicerelationer',
        'DB Admin Password' => 'DB Adminlösenord',
        'Drop Database' => 'Radera databas',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',
        'FileManager' => 'Filhanterare',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'ger tillgång till data för gällande kund (t.ex. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Väntande typ',
        'Comment (internal)' => 'Kommentar (intern)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Ärendeägarval (T.ex. <OTRS_OWNER_USERFIRSTNAME>)',
        'Minutes' => 'Minuter',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '<Ärendedataval (t.ex. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Valt format för ärendenummer)',
        'Reminder' => 'Påminnelse',
        ' (work units)' => ' (arbetsenheter)',
        'Next Week' => 'Nästa Vecka',
        'Operation' => 'Åtgärd',
        'accept license' => 'godkänn licens',
        'for agent lastname' => 'för agents efternamn',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'ger tillgång till data för agenten som utför handlingen (t.ex. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Påminnelsemeddelanden',
        'Parent-Object' => 'Förälderobjekt',
        'Of couse this feature will take some system performance it self!' => 'Denna funktion kommer i sig själv använda viss systemprestanda!',
        'IMAPS' => 'IMAPS',
        'Detail' => 'Detalj',
        'Your own Ticket' => 'Ditt eget ärende',
        'TicketZoom' => 'Ärende Zoom',
        'Don\'t forget to add a new user to groups!' => 'Glöm inte att lägga in en ny användare i en grupp!',
        'Open Tickets' => 'Öppna Ärenden',
        'CreateTicket' => 'Skapa Ärende',
        'You have to select two or more attributes from the select field!' => 'Du måste välja minst två eller fler attribut!',
        'System Settings' => 'Systeminställningar',
        'WebWatcher' => '',
        'Hours' => 'Timmar',
        'Finished' => 'Klar',
        'Account Type' => 'Kontotyp',
        'D' => 'N',
        'System Status' => 'Systemmeddelanden',
        'All messages' => 'Alla meddelanden',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Object already linked as %s.' => '',
        'A article should have a title!' => '',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'All email addresses get excluded on replaying on composing and email.' => '',
        'don\'t accept license' => 'godkänn inte licens',
        'A web mail client' => '',
        'IMAP' => '',
        'Compose Follow up' => 'Skriv uppföljningssvar',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Article time' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'ger tillgang till data för agenten som står som ägare till ärendet (t.ex. <OTRS_OWNER_UserFirstname>)',
        'DB Type' => 'DB typ',
        'kill all sessions' => 'Terminera alla sessioner',
        'to get the from line of the email' => 'för att få fram avsändarraden i emailen',
        'Solution' => 'Lösning',
        'QueueView' => 'Köer',
        'Select Box' => 'SQL-access',
        'New messages' => 'Nya meddelanden',
        'Can not create link with %s!' => '',
        'Linked as' => '',
        'modified' => '',
        'Calculator' => '',
        'Delete old database' => 'Radera gammal databas',
        'A web file manager' => '',
        'Have a lot of fun!' => 'Ha det så roligt!',
        'send' => 'Skicka',
        'Send no notifications' => '',
        'Note Text' => 'Anteckingstext',
        'POP3 Account Management' => 'Administration av POP3-Konto',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => 'Hantering av systemstatus',
        'OTRS DB User' => 'OTRS DB användare',
        'Mailbox' => '',
        'PhoneView' => 'Tel.samtal',
        'maximal period form' => '',
        'Management Summary' => '',
        'Escaladed Tickets' => '',
        'Yes means, send no agent and customer notifications on changes.' => '',
        'POP3' => '',
        'POP3S' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Emailen med ärendenummer "<OTRS_TICKET>" har skickats över till "<OTRS_BOUNCE_TO>". Vänligen kontakta denna adress för vidare hänvisningar.',
        'Ticket Status View' => '',
        'Modified' => 'Ändrat',
        'Ticket selected for bulk action!' => 'Ärende valt för massförändring!',
        'Agent Dashboard' => 'Kontrollpanel',
        'TimeAccounting' => 'Tidsredovisning',
        'A Survey module' => 'Undersökningsmodul',
        'Survey' => 'Undersökning',
        'FAQ-Area' => 'Frågor och svar',
        'FAQ' => 'FAQ',
        'StatusView' => 'Statusvy',
        'My Locked Tickets' => 'Mina Låsta Ärenden',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
