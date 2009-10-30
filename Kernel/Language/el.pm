# --
# Kernel/Language/el.pm - provides el language translation
# Copyright (C) 2006 Stelios Maistros <smaistros aegean.gr>
# Copyright (C) 2006 George Thomas <gthomas aegean.gr>
# --
# $Id: el.pm,v 1.61 2009-10-30 09:44:04 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::el;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.61 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat Jun 27 14:01:21 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-7', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Separator}           = ';';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Ναι',
        'No' => 'Οχι',
        'yes' => 'ναι',
        'no' => 'οχι',
        'Off' => 'Απενεργοποίηση',
        'off' => 'απενεργοποίηση',
        'On' => 'Ενεργοποίηση',
        'on' => 'ενεργοποίηση',
        'top' => 'αρχή',
        'end' => 'τέλος',
        'Done' => 'Έγινε',
        'Cancel' => 'Ακυρο',
        'Reset' => 'Αρχικοποίηση',
        'last' => 'τέλος',
        'before' => 'πρίν',
        'day' => 'ημέρα',
        'days' => 'ημέρες',
        'day(s)' => 'ημέρα(ες)',
        'hour' => 'ώρα',
        'hours' => 'ώρες',
        'hour(s)' => 'ώρα(ες)',
        'minute' => 'λεπτό',
        'minutes' => 'λεπτά',
        'minute(s)' => 'λεπτό(α)',
        'month' => 'μήνας',
        'months' => 'μήνες',
        'month(s)' => 'μήνας(ες)',
        'week' => 'εβδομάδα',
        'week(s)' => 'εβδομάδα(ες)',
        'year' => 'χρόνος',
        'years' => 'χρόνια',
        'year(s)' => 'χρόνος(ια)',
        'second(s)' => '',
        'seconds' => '',
        'second' => '',
        'wrote' => 'έγινε εγγραφή',
        'Message' => 'μήνυμα',
        'Error' => 'Σφάλμα',
        'Bug Report' => 'Αναφορά Σφάλματος',
        'Attention' => 'Προσοχή',
        'Warning' => 'Προειδοποίηση',
        'Module' => 'Μονάδα',
        'Modulefile' => 'Αρχείο μονάδας',
        'Subfunction' => 'Συνάρτηση',
        'Line' => 'Γραμή',
        'Setting' => '',
        'Settings' => '',
        'Example' => 'Παράδειγμα',
        'Examples' => 'Παραδείγματα',
        'valid' => '',
        'invalid' => '',
        '* invalid' => '',
        'invalid-temporarily' => '',
        ' 2 minutes' => ' 2 λεπτά',
        ' 5 minutes' => ' 5 λεπτά',
        ' 7 minutes' => ' 7 λεπτά',
        '10 minutes' => '10 λεπτά',
        '15 minutes' => '15 λεπτά',
        'Mr.' => 'Κος',
        'Mrs.' => 'Κα',
        'Next' => 'Επόμενο',
        'Back' => 'Προηγούμενο',
        'Next...' => 'Επόμενο...',
        '...Back' => '...Προηγούμενο',
        '-none-' => '-κανένα-',
        'none' => 'κανένα',
        'none!' => 'κανένα!',
        'none - answered' => 'κανένα - δεν απάντησε',
        'please do not edit!' => 'παρακαλώ να μην αλλαχθεί!',
        'AddLink' => 'Προσθήκη συνδέσμου',
        'Link' => 'Σύνδεσμος',
        'Unlink' => '',
        'Linked' => 'Συνδεδεμένος',
        'Link (Normal)' => 'Συνδεσμος (Κανονικός)',
        'Link (Parent)' => 'Σύνδεσμος (Γονέας)',
        'Link (Child)' => 'Σύνδεσμος (Παιδί)',
        'Normal' => 'Κανονικός',
        'Parent' => 'Γονέας',
        'Child' => 'Παιδί',
        'Hit' => 'Επίσκεψη-επιτυχία',
        'Hits' => 'Επισκέψεις-Επιτυχίες',
        'Text' => 'Κείμενο',
        'Lite' => 'Ελαφρύ',
        'User' => 'Χρήστης',
        'Username' => 'Ονομα Χρήστη',
        'Language' => 'Γλώσσα',
        'Languages' => 'Γλώσσες',
        'Password' => 'Κωδικός',
        'Salutation' => 'Προσφώνηση',
        'Signature' => 'Υπογραφή',
        'Customer' => 'Πελάτης',
        'CustomerID' => 'Πελάτης#',
        'CustomerIDs' => 'Πελάτης#',
        'customer' => 'πελάτης',
        'agent' => 'συνεργάτης',
        'system' => 'σύστημα',
        'Customer Info' => 'προφίλ πελάτη',
        'Customer Company' => 'Οργανισμός Πελάτη',
        'Company' => 'Οργανισμός',
        'go!' => 'Εκτέλεση!',
        'go' => 'Εκτέλεση',
        'All' => 'Όλα',
        'all' => 'όλα',
        'Sorry' => 'Συγγνώμη',
        'update!' => 'ενημέρωση!',
        'update' => 'ενημέρωση',
        'Update' => 'Ενημέρωση',
        'Updated!' => '',
        'submit!' => 'αποστολή!',
        'submit' => 'αποστολή',
        'Submit' => 'Αποστόλή',
        'change!' => 'αλλαγή!',
        'Change' => 'Αλλαγή',
        'change' => 'αλλαγή',
        'click here' => 'πατήστε εδώ',
        'Comment' => 'Σχόλιο',
        'Valid' => 'Έγκυρο',
        'Invalid Option!' => 'Μη έγκυρη επιλογή!',
        'Invalid time!' => 'Μη έγκυρη ώρα!',
        'Invalid date!' => 'Μη έγκυρη ημερομηνία!',
        'Name' => 'Όνομα',
        'Group' => 'Ομαδα',
        'Description' => 'Περιγραφή',
        'description' => 'περιγραφή',
        'Theme' => 'Θέμα',
        'Created' => 'Δημιουργήθηκε',
        'Created by' => 'Δημιουργήθηκε απο',
        'Changed' => 'Αλλαξε',
        'Changed by' => 'Αλλαξε απο',
        'Search' => 'Αναζήτηση',
        'and' => 'και',
        'between' => 'μεταξύ',
        'Fulltext Search' => 'Αναζήτηση πλήρους κειμένου',
        'Data' => 'Στοιχεία',
        'Options' => 'Επιλογές',
        'Title' => 'Τίτλος',
        'Item' => 'Ζήτημα',
        'Delete' => 'Διαγραφή',
        'Edit' => 'Αλλαγή',
        'View' => 'Επιλογή',
        'Number' => 'Αριθμός',
        'System' => 'Σύστημα',
        'Contact' => 'Επαφή',
        'Contacts' => 'Επαφές',
        'Export' => 'Εξαγωγή',
        'Up' => 'Πάνω',
        'Down' => 'Κάτω',
        'Add' => 'Προσθήκη',
        'Added!' => '',
        'Category' => 'Κατηγορία',
        'Viewer' => 'viewer',
        'Expand' => '',
        'New message' => 'Νέο Μήνυμα',
        'New message!' => 'Νέο Μήνυμα!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Παρακαλώ απαντήστε σε αυτο το δελτίο(α) για να επιστρέψετε στην
κανονική προβολή της ουράς!',
        'You got new message!' => 'Εχετε νέο μήνυμα !',
        'You have %s new message(s)!' => 'Έχετε  %s νέο(α) μήνυμα(τα) !',
        'You have %s reminder ticket(s)!' => 'Έχετε  %s !δελτία υπενθύμισης',
        'The recommended charset for your language is %s!' => 'Η συνιστώμενη κωδικοποίηση για την γλωσσα σας ειναι %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Οι κωδικοί δεν ταιριάζουν! Παρακαλώ προσπαθήστε ξανά!',
        'Password is already in use! Please use an other password!' => 'Ο κωδικός βρίσκεται ήδη σε χρήση! Παρακαλώ χρησιμοποιήστε έναν άλλο κωδικό!',
        'Password is already used! Please use an other password!' => 'Ο κωδικός χρησιμοποιείται ήδη! Παρακαλώ χρησιμοποιήστε έναν άλλο κωδικό!',
        'You need to activate %s first to use it!' => 'Πρέπει να ενεργοποιήσετε το %s πρώτα για να το χρησιμοποιήσετε !',
        'No suggestions' => 'Καμία σύσταση',
        'Word' => 'Λέξη',
        'Ignore' => 'Παράληψη',
        'replace with' => 'αντικατάσταση με',
        'There is no account with that login name.' => 'Δεν υπαρχει λογαριασμός με αυτο το όνομα χρήστη.',
        'Login failed! Your username or password was entered incorrectly.' => 'Η είσοδος απορρίφθηκε! Το όνομα χρήστη η ο κωδικός δώθηκε λανθασμένα.',
        'Please contact your admin' => 'Παρακαλώ επικοινωνήστε με τον διαχειριστή σας',
        'Logout successful. Thank you for using OTRS!' => 'Επιτυχής έξοδος. Ευχαριστούμε που χρησιμοποιήσατε το OTRS!',
        'Invalid SessionID!' => 'Λανθασμενο SessionID!',
        'Feature not active!' => 'Μη ενεργή επιλογή!',
        'Notification (Event)' => 'Ειδοποιήσεις (Event)',
        'Login is needed!' => 'Απαιτείται Σύνδεση !',
        'Password is needed!' => 'Ο κωδικός είναι απαραίτητος!',
        'License' => 'Αδεια',
        'Take this Customer' => 'Πάρε αυτόν τον πελάτη',
        'Take this User' => 'Πάρε αυτόν τον Χρήστη',
        'possible' => 'δυνατόν',
        'reject' => 'άρνηση',
        'reverse' => 'Ανάποδα',
        'Facility' => 'Οργανισμός',
        'Timeover' => 'Υπέρβαση Χρόνου',
        'Pending till' => 'Εκρεμμεί μέχρι',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Δεν δουλευει με τον Χρήστη# 1 (λογαριασμός συστήματος) !',
        'Dispatching by email To: field.' => 'Αποστολή με ηλεκτρονικό ταχυδρομείο προς (πεδίο email To:).',
        'Dispatching by selected Queue.' => 'Αποστολή με την επιλεγμένη ουρά.',
        'No entry found!' => 'Δεν βρεθηκε εγγραφή',
        'Session has timed out. Please log in again.' => 'Εξαντλήθηκε ο χρόνος τής σύνδεσης. Παρακαλώ συνδεθείτε ξανά.',
        'No Permission!' => 'Απαγορεύεται!',
        'To: (%s) replaced with database email!' => 'Πρός: (%s) αντικαταστάθηκε με το email της βάσης δεδομένων!',
        'Cc: (%s) added database email!' => 'Σε: (%s) προστέθηκε το email της βάσης δεδομένων !',
        '(Click here to add)' => '(πατήστε εδώ για προσθήκη)',
        'Preview' => 'Προεπισκόπηση',
        'Package not correctly deployed! You should reinstall the Package again!' => '',
        'Added User "%s"' => 'Εγινε Πρόσθήκη χρήστη "%s"',
        'Contract' => 'Συμβόλαιο',
        'Online Customer: %s' => 'Συνδεδεμένος πελάτης: %s',
        'Online Agent: %s' => 'Συνδεδεμένος συνεργάτης',
        'Calendar' => 'Ημερολόγιο',
        'File' => 'Αρχείο',
        'Filename' => 'Ονομα Αρχείου',
        'Type' => 'Τύπος',
        'Size' => 'Μέγεθος',
        'Upload' => 'Ανέβασμα',
        'Directory' => 'Φάκελλος',
        'Signed' => 'Υπεγράφη',
        'Sign' => 'Υπογραφή',
        'Crypted' => 'Κρυπτογραφημένο',
        'Crypt' => 'Κρυπτογράφηση',
        'Office' => 'Γραφείο',
        'Phone' => 'Τηλέφωνο',
        'Fax' => 'Fax',
        'Mobile' => 'Κινητό',
        'Zip' => 'Ταχ Τομέας',
        'City' => 'Πόλη',
        'Street' => '',
        'Country' => 'Χώρα',
        'Location' => '',
        'installed' => 'Εγκταστάθηκε',
        'uninstalled' => 'Απεγκαταστάθηκε',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => '',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => '',
        'Hello %s,' => '',
        'This account exists.' => '',
        'New account created. Sent Login-Account to %s.' => '',
        'Please press Back and try again.' => '',
        'Sent password token to: %s' => '',
        'Sent new password to: %s' => '',
        'Upcoming Events' => '',
        'Event' => '',
        'Events' => '',
        'Invalid Token!' => '',
        'more' => '',
        'For more info see:' => '',
        'Package verification failed!' => '',
        'Collapse' => '',
        'News' => '',
        'Product News' => '',
        'Bold' => '',
        'Italic' => '',
        'Underline' => '',
        'Font Color' => '',
        'Background Color' => '',
        'Remove Formatting' => '',
        'Show/Hide Hidden Elements' => '',
        'Align Left' => '',
        'Align Center' => '',
        'Align Right' => '',
        'Justify' => '',
        'Header' => 'Κεφαλίδα',
        'Indent' => '',
        'Outdent' => '',
        'Create an Unordered List' => '',
        'Create an Ordered List' => '',
        'HTML Link' => '',
        'Insert Image' => '',
        'CTRL' => '',
        'SHIFT' => '',
        'Undo' => '',
        'Redo' => '',

        # Template: AAAMonth
        'Jan' => 'Ιαν',
        'Feb' => 'Φεβ',
        'Mar' => 'Μαρ',
        'Apr' => 'Απρ',
        'May' => 'Μάι',
        'Jun' => 'Ιουν',
        'Jul' => 'Ιουλ',
        'Aug' => 'Αυγ',
        'Sep' => 'Σεπ',
        'Oct' => 'Οκτ',
        'Nov' => 'Νοε',
        'Dec' => 'Δεκ',
        'January' => 'Ιανουάριος',
        'February' => 'Φεβρουάριος',
        'March' => 'Μάρτιος',
        'April' => 'Απρίλιος',
        'May_long' => 'Mάιos',
        'June' => 'Ιούνιος',
        'July' => 'Ιούλιος',
        'August' => 'Aυγουστος',
        'September' => 'Σεπτέμβριος',
        'October' => 'Οκτώβριος',
        'November' => 'Νοέμβριος',
        'December' => 'Δεκέμβριος',

        # Template: AAANavBar
        'Admin-Area' => 'Περιοχή-Διαχειριστή',
        'Agent-Area' => 'Περιοχή-Συνεργάτη',
        'Ticket-Area' => 'Περιοχή-Δελτίου',
        'Logout' => 'Έξοδος',
        'Agent Preferences' => 'Προτιμήσεις Συνεργάτη',
        'Preferences' => 'Προτιμήσεις',
        'Agent Mailbox' => 'Γραμματοκιβώτιο Συνεργάτη',
        'Stats' => 'Στατιστικά',
        'Stats-Area' => 'Περιοχή-Στατιστικών',
        'Admin' => 'Διαχειριστής',
        'Customer Users' => 'Χρήστες-Πελάτες',
        'Customer Users <-> Groups' => ' Χρηστες<->Ομαδες Πελάτες',
        'Users <-> Groups' => 'Χρήστες <-> Ομάδες',
        'Roles' => 'Ρόλοι',
        'Roles <-> Users' => 'Ρόλοι <-> Χρήστες',
        'Roles <-> Groups' => 'Ρόλοι <-> Ομάδες',
        'Salutations' => 'Εισαγωγικό Κέιμενο Μηνύματος',
        'Signatures' => 'Υπογραφές',
        'Email Addresses' => 'Διευθύνσεις Ηλεκτρονικού Ταχυδρομείου',
        'Notifications' => 'Ειδοποιήσεις',
        'Category Tree' => 'Δέντρο Κατηγοριών',
        'Admin Notification' => 'Ειδοποίηση Διαχειριστή',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Οι προτιμήσεις ενημερώθηκαν επιτυχώς!',
        'Mail Management' => 'Διαχείριση μηνυμάτων',
        'Frontend' => 'Περιβαλλον Χρήστη',
        'Other Options' => 'Αλλες Έπιλογές',
        'Change Password' => 'Αλλαγή Κωδικού',
        'New password' => 'Νέος Κωδικός',
        'New password again' => 'Νέος Κωδικός (επανάληψη)',
        'Select your QueueView refresh time.' => 'Επιλέξτε τον χρόνο ανανέωσης προβολής της ουράς σας.',
        'Select your frontend language.' => 'Επιλέξτε την γλωσσα του περιβαλλοντος χρηστη.',
        'Select your frontend Charset.' => 'Επιλέξτε την γλωσσα του περιβάλλοντος χρήστη.',
        'Select your frontend Theme.' => 'Επιλέξτε το θέμα του περιβάλλοντος χρήστη.',
        'Select your frontend QueueView.' => 'Επιλέξτε την προβολή ουράς του περιβάλλοντος χρήστη.',
        'Spelling Dictionary' => 'Ορθογραφικό Λεξικό',
        'Select your default spelling dictionary.' => 'Επιλέξτε το προεπιλεγμενο ορθογραφικό λεξικό.',
        'Max. shown Tickets a page in Overview.' => 'Μεγιστος αριθμος δελτιων σε μια σελιδα.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Δεν μπορεί να γίνει αλλαγή κωδικού,οι κωδικοί δεν ταιριάζουν!',
        'Can\'t update password, invalid characters!' => 'Δεν μπορεί να γίνει αλλαγή κωδικού,μη έγκυροι χαρακτήρες.',
        'Can\'t update password, must be at least %s characters!' => 'Δεν μπορεί να γίνει αλλαγή κωδικού,ελάχιστο επιτρεπόμενο μήκος κωδικού %s χαρακτήρες.',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Δεν μπορεί να γίνει αλλαγή κωδικού,χρειάζονται τουλάχιστον 2 μικροί και 2 κεφαλαίοι χαρακτήρες.',
        'Can\'t update password, needs at least 1 digit!' => 'Δεν μπορεί να γίνει αλλαγή κωδικού, χρειάζεται τουλάχιστον 1 αριθμός!',
        'Can\'t update password, needs at least 2 characters!' => 'Δεν μπορεί να γίνει αλλαγή κωδικού, ελαχιστο μηκος 2 χαρακτηρες!',

        # Template: AAAStats
        'Stat' => '',
        'Please fill out the required fields!' => 'Παρακαλώ συμπληρώστε τα απαραίτητα πεδία',
        'Please select a file!' => 'Παρακαλώ επιλέξτε αρχείο',
        'Please select an object!' => 'Παρακαλώ επιλέξτε αντικέιμενο',
        'Please select a graph size!' => 'Παρακαλώ επίλεξτε μέγεθος γραφικού',
        'Please select one element for the X-axis!' => 'Παρακαλώ επιλέξτε ενα στοιχείο του Αξονα X',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Παρακαλώ επιλέξτε μονο ενα στοιχείο η ενεργοποιηστε το κουμπί \'Fixed\' του επιλεγμένου πεδίου !',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Εφόσον χρησιμοποιήσετε κουτί επιλογής πρεπει να επιλέξετε και ιδιότητες του επιλεγμένου πεδίου',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Παρακαλώ εισάγετε τιμή στο επιλεγμένο πεδίο η απενεργοποιήστε το \'Fixed\' κουτί !',
        'The selected end time is before the start time!' => 'Το επιλεγμένο τέλος χρόνου ειναι πριν την τιμή αρχής χρόνου !',
        'You have to select one or more attributes from the select field!' => 'Πρέπει να διαλέξετε μια η περισσότερες ιδιότητες απο το επιλεγμένο πεδίο',
        'The selected Date isn\'t valid!' => 'Η επιλεγμένη ημερομηνία δεν ειναι έγκυρη !',
        'Please select only one or two elements via the checkbox!' => 'Παρακαλώ διαλέξτε μονο ενα η δύο στοιχεία μέσω του κουτιού επιλογής',
        'If you use a time scale element you can only select one element!' => 'Χρησιμοποιείτε μονο ενα στοιχείου κλίμακας χρόνου !',
        'You have an error in your time selection!' => 'Υπάρχει σφάλμα στην επιλογή χρόνου !',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Η περίοδος χρόνου είναι πολύ μικρή, επιλέξτε μεγαλύτερη κλίμακα !',
        'The selected start time is before the allowed start time!' => 'Η επιλεγμένη αρχή χρόνου ειναι πριν την επιτρεπόμενη τιμή αρχής χρόνου',
        'The selected end time is after the allowed end time!' => 'Το επιλεγμένο τέλος χρόνου είναι μετά το επιτρεπόμενο τέλος χρόνου',
        'The selected time period is larger than the allowed time period!' => 'Η επιλεγμένη χρονική περίοδος είναι μεγαλύτερη απο την επιτρεπόμενη χρονική περίοδο',
        'Common Specification' => 'Κοινές προδιαγραφές',
        'Xaxis' => 'Αξονας Χ',
        'Value Series' => 'Τιμές',
        'Restrictions' => 'Περιορισμοί',
        'graph-lines' => 'Γραμμές',
        'graph-bars' => 'Στήλες',
        'graph-hbars' => 'Οριζόντιες Στήλες',
        'graph-points' => 'Σημεία',
        'graph-lines-points' => 'Γραμμές και Σημεία',
        'graph-area' => 'Περιοχή Γραφήματος',
        'graph-pie' => 'Πίτα',
        'extended' => 'εκτεταμένο',
        'Agent/Owner' => 'Διαφικασία / Ιδιοκτήτης',
        'Created by Agent/Owner' => 'Δημιουργήθηκε απο διαδικασία/ιδικτήτη',
        'Created Priority' => 'Δημιουργία προτεραιότητας',
        'Created State' => 'Δημιουργία Κατάστασης',
        'Create Time' => 'Χρόνος Δημιουργίας',
        'CustomerUserLogin' => 'Σύνδεση Πελάτη',
        'Close Time' => 'Χρόνος Κλεισίματος',
        'TicketAccumulation' => '',
        'Attributes to be printed' => '',
        'Sort sequence' => '',
        'Order by' => '',
        'Limit' => 'Οριο',
        'Ticketlist' => '',
        'ascending' => '',
        'descending' => '',
        'First Lock' => '',
        'Evaluation by' => '',
        'Total Time' => '',
        'Ticket Average' => '',
        'Ticket Min Time' => '',
        'Ticket Max Time' => '',
        'Number of Tickets' => '',
        'Article Average' => '',
        'Article Min Time' => '',
        'Article Max Time' => '',
        'Number of Articles' => '',
        'Accounted time by Agent' => '',
        'Ticket/Article Accounted Time' => '',
        'TicketAccountedTime' => '',
        'Ticket Create Time' => '',
        'Ticket Close Time' => '',

        # Template: AAATicket
        'Lock' => 'Κλείδωμα',
        'Unlock' => 'Ανοιγμα',
        'History' => 'Ιστορικό',
        'Zoom' => 'Εστίαση',
        'Age' => 'Ηλικία',
        'Bounce' => 'Αναπήδηση',
        'Forward' => 'Προώθηση',
        'From' => 'Από',
        'To' => 'Πρός',
        'Cc' => 'Κοινοποίηση',
        'Bcc' => 'Ιδιαίτερη Κοινοποίηση',
        'Subject' => 'Θέμα',
        'Move' => 'Μεταφορά',
        'Queue' => 'Ουρά',
        'Priority' => 'Προτεραιότητα',
        'Priority Update' => '',
        'State' => 'Κατάσταση',
        'Compose' => 'Σύνθεση',
        'Pending' => 'Εκρεμούν',
        'Owner' => 'Ιδιοκτήτης',
        'Owner Update' => 'Ενημέρωση Ιδιοκτήτη',
        'Responsible' => 'Υπε\'υθυνος',
        'Responsible Update' => '',
        'Sender' => 'Αποστολέας',
        'Article' => 'Αρθρο',
        'Ticket' => 'Δελτία',
        'Createtime' => 'Χρονος δημιουργίας',
        'plain' => 'απλό',
        'Email' => 'Ηλεκτρονικό Ταχυδρομείο',
        'email' => 'ηλεκτρονικό ταχυδρομείο',
        'Close' => 'Κλείσιμο',
        'Action' => 'Ενέργεια',
        'Attachment' => 'Συνημμένο',
        'Attachments' => 'Συννημένα',
        'This message was written in a character set other than your own.' => 'Αυτό το μήνυμα εχει γραφτεί με μια κωδικοποίηση διαφορετική απο την δική σας.',
        'If it is not displayed correctly,' => 'Αν αυτό δεν φαίνεται σωστά ,',
        'This is a' => 'Αυτό είναι ένα',
        'to open it in a new window.' => 'για να το ανοίξετε σε ενα καινούργιο παράθυρο',
        'This is a HTML email. Click here to show it.' => 'Αυτο ειναι ενα HTML Email. Πατήστε εδώ για να το ανοίξετε.',
        'Free Fields' => 'Ελεύθερα Πεδία',
        'Merge' => 'Ένωση',
        'merged' => 'Ενωμένο',
        'closed successful' => 'Έκλεισε επιτυχώς',
        'closed unsuccessful' => 'Έκλεισε ανεπιτυχώς',
        'new' => 'Νέο',
        'open' => 'Ανοικτό',
        'Open' => '',
        'closed' => 'Κλειστό',
        'Closed' => '',
        'removed' => 'Αποσύρθηκε',
        'pending reminder' => 'Υπενθύμιση Εκρεμότητας',
        'pending auto' => '',
        'pending auto close+' => 'Αυτόματο Κλείσιμο Εκρεμότητας+',
        'pending auto close-' => 'Αυτόματο κλείσιμο Εκρεμότητας-',
        'email-external' => 'Δημόσιο email',
        'email-internal' => 'Ιδιωτικό email',
        'note-external' => 'Σημείωση-Δημόσια',
        'note-internal' => 'Σημείωση-Ιδιωτική',
        'note-report' => 'Σημείωση-αναφορά',
        'phone' => 'Τηλέφωνο',
        'sms' => 'SMS',
        'webrequest' => 'κλήση',
        'lock' => 'κλείσιμο',
        'unlock' => 'άνοιγμα',
        'very low' => 'Πολύ Χαμηλή',
        'low' => 'Χαμηλή',
        'normal' => 'Κανονική',
        'high' => 'Υψηλή',
        'very high' => 'Πολύ Υψηλή',
        '1 very low' => '1 πολύ χαμηλή',
        '2 low' => '2 χαμηλή',
        '3 normal' => '3 κανονική',
        '4 high' => '4 υψηλή',
        '5 very high' => '5 πολυ υψηλή',
        'Ticket "%s" created!' => 'δημιουργηθηκε το Δελτιο "%s" !',
        'Ticket Number' => 'Αριθμός Δελτίου',
        'Ticket Object' => 'Αντικέιμενο Δελτίου',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Αριθμός δελτίου  "%s" δεν μπορεί να γίνει η σύνδεση!δεν υπάρχει τέτοιος αριθμός δελτίου!',
        'Don\'t show closed Tickets' => 'να μην εμφανίζονται τα κλειστά δελτία',
        'Show closed Tickets' => 'εμφάνιση κλειστών δελτίων',
        'New Article' => 'Νέο άρθρο',
        'Email-Ticket' => 'Δελτίο Email',
        'Create new Email Ticket' => 'Δημιουργία νέου Email Δελτίου',
        'Phone-Ticket' => 'Δελτίο Τηλεφώνου',
        'Search Tickets' => 'Αναζήτηση Δελτίων',
        'Edit Customer Users' => 'Αλλαγή Χρηστών-πελατών',
        'Edit Customer Company' => '',
        'Bulk Action' => 'Μαζική ενέργεια',
        'Bulk Actions on Tickets' => 'Μαζική Ενέργεια Δελτίων',
        'Send Email and create a new Ticket' => 'Αποστολη email και δημιουργια νεου Δελτίου',
        'Create new Email Ticket and send this out (Outbound)' => 'Δημιουργία Νεόυ Δελτίου (email) και αποστολή',
        'Create new Phone Ticket (Inbound)' => 'Δημιουργία νέου δελτίου μέσω τηλέφώνου',
        'Overview of all open Tickets' => 'Έλεγχος όλων των ανοιχτών Δελτίων',
        'Locked Tickets' => 'Κλειδωμένα Δελτία',
        'Watched Tickets' => 'Παρακολουθούμενα Δελτία',
        'Watched' => 'Παρακολουθούμενα',
        'Subscribe' => 'Εγγραφή Συνδρομής',
        'Unsubscribe' => 'Διαγραφή Συνδρομής',
        'Lock it to work on it!' => 'Κλειδώστε το ώστε να το επεξεργαστείτε!',
        'Unlock to give it back to the queue!' => 'Ξεκλειδώστε το και επιστρέψτε το στην ουρά!',
        'Shows the ticket history!' => 'Δείχνει την ιστορία του Δελτίου!',
        'Print this ticket!' => 'Εκτύπωση Δελτίου!',
        'Change the ticket priority!' => 'Αλλαγή της προτεραιότητας του δελτίου!',
        'Change the ticket free fields!' => 'Αλλάξτε τα ελέυθερα του δελτίου!',
        'Link this ticket to an other objects!' => 'Σύνδεση δελτίου με ενα άλλο αντικείμενο!',
        'Change the ticket owner!' => 'Αλλαγή του ιδιοκτήτη δελτίου!',
        'Change the ticket customer!' => 'Αλλαγή του παραλήπτη δελτίου!',
        'Add a note to this ticket!' => 'Προσθήκη σημείωσης στ δελτίο!',
        'Merge this ticket!' => 'Ένωση του δελτίου!',
        'Set this ticket to pending!' => 'Αλλαγή του δελτίου σε κατάσταση εκρεμότητας!',
        'Close this ticket!' => 'Κλείσιμο δελτίου!',
        'Look into a ticket!' => 'Προβολη του δελτίου!',
        'Delete this ticket!' => 'Διαγραφή Δελτίου!',
        'Mark as Spam!' => 'Χαρακτηρισμός ως ανεπυθήμητο!',
        'My Queues' => 'Οι Ουρές μου',
        'Shown Tickets' => 'Δελτια που παρουσιάζονται',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Το μηνυμα σας με αριθμο δελτίου "<OTRS_TICKET>" ενώθηκε με το δελτίο <OTRS_MERGE_TO_TICKET>" !',
        'Ticket %s: first response time is over (%s)!' => 'Δελτίο %s: πρώτος χρόνος απάντησης ξεπερνάει (%s) !',
        'Ticket %s: first response time will be over in %s!' => 'Δελτίο %s: ο πρώτος χρόνος απάντησης θα έχει λήξει σε (%s) !',
        'Ticket %s: update time is over (%s)!' => 'Δελτίο %s: χρόνος ενημέρωσης έχει λήξει (%s) !',
        'Ticket %s: update time will be over in %s!' => 'Δελτίο %s: ο χρόνος ενημέρωσης θα λήξει σε (%s) !',
        'Ticket %s: solution time is over (%s)!' => 'Δελτίο %s: Επίλυση σε (%s) !',
        'Ticket %s: solution time will be over in %s!' => 'Δελτίο %s: χρόνος επίλυσης λήγει σε (%s) !',
        'There are more escalated tickets!' => 'Δεν υπάρχουν άλλα αυξημένης κρισιμότητας δελτία',
        'New ticket notification' => 'Νέα ειδοποίηση δελτίου',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Αποστολή ειδοποίησης αν υπάρχει ενα νέο δελτίο στις "Ουρές μου".',
        'Follow up notification' => 'Παρακολούθηση ειδοποίησης',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Ειδοποίησε με αν ενας χρήστης παρακολουθεί
ενα δελτίο που μου ανήκει.',
        'Ticket lock timeout notification' => 'ειδοποίηση χρονοκλειδώματος δελτίου',
        'Send me a notification if a ticket is unlocked by the system.' => 'Αποστολή ειδοποίησης αν ενα δελτίο ξεκλειδωθεί απο το σύστημα.',
        'Move notification' => 'Μεταφορά ειδοποίησης',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Αποστολη ειδοποιησης αν ενα δελτιο αποσταλει σε μια απο τις
"Ουρές μου".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Οι επιλεγμένες απο τις
αγαπημένες σας ουρές.Μπορείτε να ειδοποιείστε μεσω email αν το ενεργοποιήσετε.',
        'Custom Queue' => 'Προσαρμοσμένη Ουρά',
        'QueueView refresh time' => 'Χρόνος ανανέωσης προβολής της ουράς',
        'Screen after new ticket' => 'Οθόνη μετά την δημιουργία νέου δελτίου',
        'Select your screen after creating a new ticket.' => 'Επιλογή της οθόνης μετά την δημιουργία νέου δελτίου.',
        'Closed Tickets' => 'Κλειστά δελτία',
        'Show closed tickets.' => 'Προβολή κλειστών δελτίων.',
        'Max. shown Tickets a page in QueueView.' => 'Μέγιστος αριθμός δελτίων που προβάλονται ανα σελίδα σε προβολή ουράς.',
        'Watch notification' => '',
        'Send me a notification of an watched ticket like an owner of an ticket.' => '',
        'Out Of Office' => '',
        'Select your out of office time.' => '',
        'CompanyTickets' => 'Δελτία Οργανισμού',
        'MyTickets' => 'Τα Δελτία μου',
        'New Ticket' => 'Νέο Δελτίο',
        'Create new Ticket' => 'Δημιουργία Νένου Δελτίου',
        'Customer called' => 'Πελάτης έκανε κλήση',
        'phone call' => 'Τηλεφώνημα',
        'Reminder Reached' => '',
        'Reminder Tickets' => '',
        'Escalated Tickets' => '',
        'New Tickets' => '',
        'Open Tickets / Need to be answered' => '',
        'Tickets which need to be answered!' => '',
        'All new tickets!' => '',
        'All tickets which are escalated!' => '',
        'All tickets where the reminder date has reached!' => '',
        'Responses' => 'Απαντήσεις',
        'Responses <-> Queue' => 'Απαντήσεις <-> Ουρές',
        'Auto Responses' => 'Αυτόματες Απαντήσεις',
        'Auto Responses <-> Queue' => 'Αυτόματες Απαντήσεις <-> Ουρές',
        'Attachments <-> Responses' => 'Συνημμένα <-> Απαντήσεις',
        'History::Move' => 'Μεταφορά δελτίου στην ουρά "%s" (%s) απο την ουρά "%s" (%s).',
        'History::TypeUpdate' => 'Ενημέρωση τύπου σε %s (ID=%s).',
        'History::ServiceUpdate' => 'Ενημέρωση υπηρεσίας σε %s (ID=%s).',
        'History::SLAUpdate' => 'Ενημέρωση SLA σε %s (ID=%s).',
        'History::NewTicket' => 'Νέο Δελτίο [%s] δημιουργήθηκε (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Συνέχεια για [%s]. %s',
        'History::SendAutoReject' => 'Αυτόματη Αρνηση σταλθηκε στο "%s".',
        'History::SendAutoReply' => 'Αυτόματη απ΄ντηση στάλθηκε στο "%s".',
        'History::SendAutoFollowUp' => 'Αυτόματη συνέχεια στάληθηκε στο "%s".',
        'History::Forward' => 'Προώθηση στο "%s".',
        'History::Bounce' => 'Αναπίδηση στο "%s".',
        'History::SendAnswer' => 'Αποστολή Email στο "%s".',
        'History::SendAgentNotification' => '"%s"-ενημέρωση στάλθηκε στο "%s".',
        'History::SendCustomerNotification' => 'Ενημέρωση στάλθηκε στο "%s".',
        'History::EmailAgent' => 'Αποστολή email στον πελάτη.',
        'History::EmailCustomer' => 'Αποστολή Email στον πελάτη. %s',
        'History::PhoneCallAgent' => 'Κλήση κειριστή προς πελάτη.',
        'History::PhoneCallCustomer' => 'Κλήση πελάτη προς εμάς.',
        'History::AddNote' => 'Προσθήκη σημέιωσης (%s)',
        'History::Lock' => 'Κλείδωμα Δελτίου',
        'History::Unlock' => 'Ξεκλείδωμα δελτίου.',
        'History::TimeAccounting' => '%s μονάδες χρόνου ενημερώθηκαν. Το νέο σύνολο είναι %s time μονάδες.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Ενημερώθηκε: %s',
        'History::PriorityUpdate' => 'Αλλαγή προτεραιότητας απο "%s" (%s) σε "%s" (%s).',
        'History::OwnerUpdate' => 'Νέος ιδιοκτήτης είναι "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! Δεν στάλθηκε αυτόματη απάντηση στο "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Ενημερώθηκε: %s',
        'History::StateUpdate' => 'Παλαιό: "%s" Νέο: "%s"',
        'History::TicketFreeTextUpdate' => 'Ενημερώθηκε: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Αίτημα πελάτη μέσω web.',
        'History::TicketLinkAdd' => 'Προσθήκη συνδέσμου στο δελτίο "%s".',
        'History::TicketLinkDelete' => 'Διαγραφή συνδέσμού απο το δελτίο "%s".',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Κυρ',
        'Mon' => 'Δευ',
        'Tue' => 'Τρι',
        'Wed' => 'Τετ',
        'Thu' => 'Πεμ',
        'Fri' => 'Παρ',
        'Sat' => 'Σαβ',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Διαχείριση Συνημμένων',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Διαχείρηση Αυτόματων Απαντήσεων',
        'Response' => 'Απάντηση',
        'Auto Response From' => 'Αυτοματη Απάντηση Απο',
        'Note' => 'Σημείωση',
        'Useable options' => 'Διαθέσιμες Επιλογές',
        'To get the first 20 character of the subject.' => '',
        'To get the first 5 lines of the email.' => '',
        'To get the realname of the sender (if given).' => '',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => '',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Διαχείρηση Οργανισμού Πελάτη',
        'Search for' => 'Αναζήτηση για',
        'Add Customer Company' => 'Προσθήκη Οργανισμου Πελάτη',
        'Add a new Customer Company.' => 'Προσθήκη νέου Οργανισμού Πελάτη',
        'List' => 'Κατάλογος',
        'These values are required.' => 'Οι τιμές απαιτούνται.',
        'These values are read-only.' => 'Οι τιμές ειναι μονο για ανάγνωση.',

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
        'The message being composed has been closed.  Exiting.' => 'Η δυνατότητα επεξεργασίας του μηνύματος έχει κλείσει.Έξοδος...',
        'This window must be called from compose window' => 'Αυτό το παράθυρο πρέπει να κληθεί απο το παράθυρο επεξεργασίας',
        'Customer User Management' => 'Διαχείριση χρήστη πελάτη',
        'Add Customer User' => 'Προσθήκη πελάτη χρήστη',
        'Source' => 'Πηγή',
        'Create' => 'Δημιουργία',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Ο χρήστης πελάτης θα πρέπει να έχει ενα ιστορικό πελάτη και να συνδεθεί μέσω του πίνακα πελατών.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Χρήστες πελάτες <-> διαχείρηση ομάδας',
        'Change %s settings' => 'Αλλαγή  %s επιλογών',
        'Select the user:group permissions.' => 'Επιλογή των δικαιωμάτων του χρήστη/ομάδας.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Αν τιποτα δεν εχει
επιλεγεί τοτε δεν υπαρχουν δικαιωματα σε αυτην την ομαδα(τα δελτία θα είναι διαθέσιμα για τον χρήστη.)',
        'Permission' => 'Δικαίωμα',
        'ro' => 'Μόνο ανάγνωση',
        'Read only access to the ticket in this group/queue.' => 'Αυτή η ομάδα/ουρά έχει μόνο δικαιώματα ανάγνωσης σε αυτό το δελτίο .',
        'rw' => 'Ανάγνωση και εγγραφή',
        'Full read and write access to the tickets in this group/queue.' => 'Πλήρη δικαιώματα ανάγνωσης και εγγραφής στην ομάδα/ουρά για αυτό το
δελτίο.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '',
        'CustomerUser' => 'Χρήστης-Πελάτης',
        'Service' => 'Υπηρεσία',
        'Edit default services.' => '',
        'Search Result' => 'Αποτέλεσμα Αναζήτησης',
        'Allocate services to CustomerUser' => '',
        'Active' => 'Ενεργό',
        'Allocate CustomerUser to service' => '',

        # Template: AdminEmail
        'Message sent to' => 'Το μήνυμα εστάλει προς',
        'A message should have a subject!' => 'Το μήνυμα πρέπει να έχει ενα θέμα!',
        'Recipients' => 'Αποδέκτες',
        'Body' => 'Κύριο μέρος',
        'Send' => 'Αποστολή',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Αυτόματες Διαδικασίες',
        'Job-List' => 'Λίστα Εργασιών',
        'Last run' => 'Τελευταία εκτέλεση',
        'Run Now!' => 'Εκτέλεση Τώρα!',
        'x' => '',
        'Save Job as?' => 'Αποθήκευση Εργασίας ως;',
        'Is Job Valid?' => 'Είναι η εργασία έγκυρη;',
        'Is Job Valid' => 'Είναι η εργασία έγκυρη',
        'Schedule' => 'Πρόγραμμα',
        'Currently this generic agent job will not run automatically.' => '',
        'To enable automatic execution select at least one value from minutes, hours and days!' => '',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Αναζήτηση πλήρους κειμένου στο άρθρο (π.χ. "Mar*in" ή "Baue*")',
        '(e. g. 10*5155 or 105658*)' => 'π.χ. 10*5144 ή 105658*',
        '(e. g. 234321)' => 'π.χ. 234321',
        'Customer User Login' => 'Σύνδεση Χρήστη Πελάτη',
        '(e. g. U5150)' => 'π.χ. U5150',
        'SLA' => '',
        'Agent' => 'Συνεργάτης',
        'Ticket Lock' => 'Κλείδωμα Δελτίων',
        'TicketFreeFields' => 'Ελεύθερα Πεδία',
        'Create Times' => 'Χρόνοι Δημιουργίας',
        'No create time settings.' => 'Δεν υπάρχουν ρυθμίσεις χρόνου δημιουργίας',
        'Ticket created' => 'Δημιουργήθηκε δελτίο',
        'Ticket created between' => 'Το Δελτίο δημιουργήθηκε μεταξύ',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => 'Εκκρεμοτητα',
        'No pending time settings.' => 'Δεν υπάρχουν ρυθμίσεις για εκρεμμότητα',
        'Ticket pending time reached' => 'Τέλος Οριου χρόνου εκρεμότητας δελτίου',
        'Ticket pending time reached between' => 'Οριο χρόνου εκρεμότητας δελτίου μεταξύ',
        'Escalation Times' => '',
        'No escalation time settings.' => '',
        'Ticket escalation time reached' => '',
        'Ticket escalation time reached between' => '',
        'Escalation - First Response Time' => '',
        'Ticket first response time reached' => '',
        'Ticket first response time reached between' => '',
        'Escalation - Update Time' => 'Κλιμάκωση - ενημέρωση χρόνου',
        'Ticket update time reached' => '',
        'Ticket update time reached between' => '',
        'Escalation - Solution Time' => 'Κλιμάκωση - χρόνος ενημέρωσης',
        'Ticket solution time reached' => '',
        'Ticket solution time reached between' => '',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => 'Νέα Προτεραιότητα',
        'New Queue' => 'Νέα Ουρά',
        'New State' => 'Νέα Κατάσταση',
        'New Agent' => 'Νέος Συνεργάτης',
        'New Owner' => 'Νέος Ιδιοκτήτης',
        'New Customer' => 'Νέος Πελάτης',
        'New Ticket Lock' => 'Νέο Κλείδωμα Δελτίου',
        'New Type' => '',
        'New Title' => '',
        'New TicketFreeFields' => 'Νέα Ελεύθερα Πεδία',
        'Add Note' => 'Προσθήκη Σημείωσης',
        'Time units' => 'Μονάδες Χρόνου',
        'CMD' => 'Διαταγή',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Αυτή η εντολή θα εκτελεστεί. ARG[0] θα είναι το
νούμερο του δελτίου και ARG[1] ο κωδικός του δελτίου .',
        'Delete tickets' => 'Διαγραφή δελτίων',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Προσοχή! Τα δελτία αυτά θα μεταφερθούν απο την βάση
δεδομένων!Τα δελτία αυτά θα χαθούν!',
        'Send Notification' => 'Ενημέρωση Αποστολής',
        'Param 1' => 'Παράμετρος 1',
        'Param 2' => 'Παράμετρος 2',
        'Param 3' => 'Παράμετρος 3',
        'Param 4' => 'Παράμετρος 4',
        'Param 5' => 'Παράμετρος 5',
        'Param 6' => 'Παράμετρος 6',
        'Send agent/customer notifications on changes' => '',
        'Save' => 'Αποθήκευση',
        '%s Tickets affected! Do you really want to use this job?' => '%s Δελτία θα επηρεασθούν. Επιβεβαιώστε την εκτέλεση αυτής της εργασίας',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => '',
        'Group Management' => 'Διαχείριση Ομάδων',
        'Add Group' => 'Πρσθήκη Ομάδας',
        'Add a new Group.' => 'Πρσθήκε Νέας Ομάδας',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Η ομάδα διαχειριστών εχει διακαιωμτατα στην
περιοχη διαχειριστων και στην ομαδα στατιστικων .',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => '',
        'It\'s useful for ASP solutions.' => 'Είναι χρήσιμο σε ASP λύσεις.',

        # Template: AdminLog
        'System Log' => 'Καταγραφές Συστήματος',
        'Time' => 'Χρόνος',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => '',
        'Trusted' => 'Εμπιστος',
        'Dispatching' => 'Αποστολή',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Όλα τα εισερχόμενα emails με έναν λογαριασμό θα
αποστέλονται στην επιλεγμένη ουρά!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

        # Template: AdminNavigationBar
        'Users' => 'Χρήστες',
        'Groups' => 'Ομάδες',
        'Misc' => 'Διάφορα',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Διαχείριση ειδοποιήσεων',
        'Add Notification' => '',
        'Add a new Notification.' => '',
        'Name is required!' => 'Το όνομα απαιτείται!',
        'Event is required!' => '',
        'A message should have a body!' => 'Το μήνυμα πρέπει να εχει κυρίως κείμενο!',
        'Recipient' => '',
        'Group based' => '',
        'Agent based' => '',
        'Email based' => '',
        'Article Type' => '',
        'Only for ArticleCreate Event.' => '',
        'Subject match' => '',
        'Body match' => '',
        'Notifications are sent to an agent or a customer.' => 'Οι ειδοποιήσεις στέλνονται σε έναν συνεργάτη ή σε έναν πελαάτη.',
        'To get the first 20 character of the subject (of the latest agent article).' => '',
        'To get the first 5 lines of the body (of the latest agent article).' => '',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => '',
        'To get the first 20 character of the subject (of the latest customer article).' => '',
        'To get the first 5 lines of the body (of the latest customer article).' => '',

        # Template: AdminNotificationForm
        'Notification' => 'Ειδοποιήσεις',

        # Template: AdminPackageManager
        'Package Manager' => 'Διαχειριση Πακέτων',
        'Uninstall' => 'Απεγκατάσταση',
        'Version' => 'Έκδοση',
        'Do you really want to uninstall this package?' => 'Είστε σίγουροι οτι θέλετε να απεγκαταστήσετε αυτό το πακέτο;',
        'Reinstall' => 'Επανεγκατάσταση',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '',
        'Continue' => 'Συνέχεια',
        'Install' => 'Εγκατάσταση',
        'Package' => 'Πακέτο',
        'Online Repository' => 'Online αποθηκευτικός χώρος',
        'Vendor' => 'Κατασκευαστής',
        'Module documentation' => '',
        'Upgrade' => 'Αναβάθμιση',
        'Local Repository' => 'Τοπικός αποθηκευτικός χώρος',
        'Status' => 'Κατάσταση',
        'Overview' => 'Επισκόπηση',
        'Download' => 'Κατέβασμα',
        'Rebuild' => 'Ανακατασκευή',
        'ChangeLog' => 'Καταγραφικό Αλλαγών',
        'Date' => 'Ημερομηνία',
        'Filelist' => 'Λίστα Αρχείων',
        'Download file from package!' => 'Κατέβασμα αρχείου απο πακέτο !',
        'Required' => 'Απαιτείται',
        'PrimaryKey' => 'Προτεύον Κλειδί',
        'AutoIncrement' => 'Αυτόματη αύξηση',
        'SQL' => 'SQL',
        'Diff' => 'Διαφορές',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Καταγραφικό απόδοσης',
        'This feature is enabled!' => 'Αυτή η δυνατότητα έχει επιλεχθεί',
        'Just use this feature if you want to log each request.' => 'Χρησιμοποιείστε αυτή την δυνατότητα αν θελετε να καταγραψετε κάθε αίτημα',
        'Activating this feature might affect your system performance!' => '',
        'Disable it here!' => 'Απενεργοποίση εδώ !',
        'This feature is disabled!' => 'Αυτη η δυνατότητα εχει απενεργοποιηθεί',
        'Enable it here!' => 'Ενεργοποιήστε το εδώ !',
        'Logfile too large!' => 'Το αρχείο καταγραφών ειναι πολύ μεγάλο',
        'Logfile too large, you need to reset it!' => 'Το αρχείο καταγραφών ειναι πολύ μεγάλο, πρεπει να το επεναφέρετε στις αρχικές ρυθμίσεις',
        'Range' => 'Εμβέλεια',
        'Interface' => 'Διεπιφάνεια',
        'Requests' => 'Αιτήματα',
        'Min Response' => 'Min Απάντηση',
        'Max Response' => 'Μαχ Απάντηση',
        'Average Response' => 'Απαντηση κατά μέσω όρο',
        'Period' => '',
        'Min' => '',
        'Max' => '',
        'Average' => '',

        # Template: AdminPGPForm
        'PGP Management' => 'Διαχείριση PGP',
        'Result' => 'Αποτέλεσμα',
        'Identifier' => '',
        'Bit' => '',
        'Key' => 'Kλειδί',
        'Fingerprint' => 'Αποτύπωμα',
        'Expires' => 'Λήγει',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Με αυτον τον τροπο μπορειτε κατευθειαν να επεξεργαστείτε το
κeyring που διαμορφωνεται στο SysConfig.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Διαχείριση Φίλτρου PostMaster',
        'Filtername' => 'Όνομα φίλτρου',
        'Stop after match' => '',
        'Match' => 'Ακριβώς ώς',
        'Value' => 'Τιμή',
        'Set' => '',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Αποστολή η φιλτραρισμα εισερχόμενης αλληλογραφίας με βαση τις κεφαλίδες. Μπορείτε να κάνετε χρήση RegExpressions.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Αν κάνετε χρήση RegExp, μπορείτε να βάλετε την τιμή σε () όπως [***] in \'Set\'.',

        # Template: AdminPriority
        'Priority Management' => '',
        'Add Priority' => '',
        'Add a new Priority.' => '',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Ουρές <-> Διαχείριση Αυτόματων Απαντήσεων',
        'settings' => '',

        # Template: AdminQueueForm
        'Queue Management' => 'Διαχείριση Ουρών',
        'Sub-Queue of' => 'Υπο Ουρά της ',
        'Unlock timeout' => 'Timeout για ξεκλείδωμα',
        '0 = no unlock' => '0 = Δεν Ξεκλειδώνει',
        'Only business hours are counted.' => '',
        '0 = no escalation' => '0 = Χωρίς Αναβάθμιση',
        'Notify by' => '',
        'Follow up Option' => 'Follow Option',
        'Ticket lock after a follow up' => 'Κλείδωμα Δελτίου μετα το Follow-Up',
        'Systemaddress' => 'Systemadress',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Αν ενας συνεργάτης κλειδώσει ενα δελτίο, και δεν ενημερώσει εντός αυτού του χρονικού διατστηματος, το δελτίο θα ανοιξει αυτόματα. Ετσι το δελτίο θα είναι ορατό σε όλους τους συνεργάτες.',
        'Escalation time' => 'Χρόνος Αναβάθμισης',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Αν ενα δελτίο δεν απαντηθεί σε αυτό το χρονικό διαστημα, μονο αυτό δελτίο θα είναι ορατό.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Αν ενα δελτίο είναι κλειστό και ο πελάτης στέλνει ενα followup μηνυμα, το δελτίο θα κλειδωθεί για τον προηγούμενο ιδιοκτήτη.',
        'Will be the sender address of this queue for email answers.' => 'Θα είναι η διεύθυνση του αποστολέα αυτής της ουράς για απαντήσεις μέσω email.',
        'The salutation for email answers.' => 'Προσφώνηση για απαντήσεις μέσω Email.',
        'The signature for email answers.' => 'Υπογραφή για απαντήσεις μέσω Email.',
        'Customer Move Notify' => 'Ενημέρωση Μεταφοράς Πελάτη',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'To OTRS αποστέλλει ενημερωτικό μηνημα στον πελάτη αν γίνει μεταφορά δελτίου.',
        'Customer State Notify' => 'Ενημέρωση Κατάστασης Πελάτη',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'To OTRS αποστέλλει ενημερωτικό μηνημα στον πελάτη αν γίνει αλλαγή δελτίου.',
        'Customer Owner Notify' => 'Ενημέρωση Πελάτη - Ιδιοκτητη',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'To OTRS αποστέλλει ενημερωτικό μηνημα στον πελάτη αν γίνει αλλαγή ιδιοκτήτη δελτίου.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Απαντήσεις <-> Διαχείριση Ουρών',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Απάντηση',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Απαντήσεις <-> Διαχείριση Συνημμένων',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Διαχείριση Απαντήσεων',
        'A response is default text to write faster answer (with default text) to customers.' => 'Μια απάντηση ειναι το προεπιλεγμένο κείμενο για την δημουργία απαντησεων στον πελάτη.',
        'Don\'t forget to add a new response a queue!' => 'Μην ξεχάσετε να προσθέσετε νέα απάντηση στην ουρά!',
        'The current ticket state is' => 'Η κατάσταση του παρόντος δελτίου είναι',
        'Your email address is new' => 'Η διεθυνση email ειναι καινούργια',

        # Template: AdminRoleForm
        'Role Management' => 'Διαχείρηση Ρόλων',
        'Add Role' => 'Προσθήκη ρόλου',
        'Add a new Role.' => 'Προσθήκη νέου ρόλου',
        'Create a role and put groups in it. Then add the role to the users.' => 'Δημιουργήστε ενα ρόλο και αναθέστε ομάδες. Μετά προσθέστε τον ρόλο στους χρήστες.',
        'It\'s useful for a lot of users and groups.' => 'Είναι χρησμο για πολλαπλους χρήστες και ομάδες.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Ρόλοι <-> Διαχείριση Ομάδων',
        'move_into' => 'Μεταφορά στο ',
        'Permissions to move tickets into this group/queue.' => 'Δικαιώματα για μεταφορά δελτίων σε αυτη την ομάδα / ουρά.',
        'create' => 'Δημιουργία',
        'Permissions to create tickets in this group/queue.' => 'Δικαιώματα για δημιουργία δελτίων σε αυτή την ομάδα΄/ ουρά.',
        'owner' => 'Ιδιοκτήτης',
        'Permissions to change the ticket owner in this group/queue.' => 'Δικαιώματα για αλλαγή ιδιοκτήτη δελτίων σε αυτή την ομάδα / ουρά.',
        'priority' => 'Προτεραιότητα',
        'Permissions to change the ticket priority in this group/queue.' => 'Δικαιώματα για αλλαγή προτεραιότητας δελτίων σε αυτη την ομάδα / ουρά.',

        # Template: AdminRoleGroupForm
        'Role' => 'Ρόλος',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Ρόλοι <-> Διαχείριση χρηστών',
        'Select the role:user relations.' => 'Επιλογή τής σχέσης ρόλου:χρήστη.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Διαχείριση προσφωνήσεων',
        'Add Salutation' => 'Προσθήκη χαιρετισμού',
        'Add a new Salutation.' => 'Προσθ\'ηκη νέου χαιρετισμού',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' => '',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => '',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => '',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Go' => 'Εκτέλεση',
        'Select Box Result' => 'Αποτέλεσμα Διαταγών SQL',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => 'Προσθήκη υπηρεσίας',
        'Add a new Service.' => 'Προσθήκη νέας υπηρεσίας',
        'Sub-Service of' => 'Υπο-Υπηρεσία της ',

        # Template: AdminSession
        'Session Management' => 'Διαχείριση Σύνδεσης',
        'Sessions' => 'Συνδέσεις',
        'Uniq' => 'Μοναδικό',
        'Kill all sessions' => 'Τερματισμός όλων των εργασιών',
        'Session' => 'Εργασία',
        'Content' => 'Περιεχόμενο',
        'kill session' => 'καταστροφή του session',

        # Template: AdminSignatureForm
        'Signature Management' => 'Διαχείριση υπογραφών',
        'Add Signature' => 'Προσθήκη Υπογραφής',
        'Add a new Signature.' => 'Προσθήκη Νέας Υπογραφής',

        # Template: AdminSLA
        'SLA Management' => '',
        'Add SLA' => '',
        'Add a new SLA.' => '',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Διαχειριση S/MIME',
        'Add Certificate' => 'Προσθήκη πιστοποιητικού',
        'Add Private Key' => 'Προσθήκη ιδιωτικού κλειδιού',
        'Secret' => 'Μυστικό',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => 'Με αυτόν τον τρόπο μπορείτε κατευθείαν να
επεξεργαστείτε τα πιστοποιητικά και ιδιωτικά κλειδιά στο αρχείο συστήματος.',

        # Template: AdminStateForm
        'State Management' => 'Διαχείριση Κατάστασης',
        'Add State' => 'Προσθήκη Κατάστασης',
        'Add a new State.' => 'Προσθήκη Νέας Κατάστασης',
        'State Type' => 'Τύπος Κατάστασης',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Φροντίστε να ενημερώσετε επίσης τις προεπιλεγμένες καταστάσεις στο Kernel/Config.pm!',
        'See also' => 'Δείτε επίσης',

        # Template: AdminSysConfig
        'SysConfig' => '',
        'Group selection' => 'Επιλογή Ομάδων',
        'Show' => 'Προβολή',
        'Download Settings' => 'Ρυθμίσεις Download',
        'Download all system config changes.' => 'Κάντε Download όλες τις αλλαγές στο system config.',
        'Load Settings' => 'Φόρτωμα Ρυθμίσεων',
        'Subgroup' => 'Υπο-ομάδα',
        'Elements' => 'Στοιχεία',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Επιλογές Ρυθμίσεων',
        'Default' => 'Προεπιλεγμενο',
        'New' => 'Νέο',
        'New Group' => 'Νέα Ομάδα',
        'Group Ro' => 'Ομάδα RO',
        'New Group Ro' => 'Νέα Ομάδα Ro',
        'NavBarName' => '',
        'NavBar' => '',
        'Image' => 'Εικόνα',
        'Prio' => '',
        'Block' => 'Αποκλεισμός',
        'AccessKey' => '',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Email συστηματος',
        'Add System Address' => 'Προσθήκη Διεύθυνσης Συστήματος',
        'Add a new System Address.' => 'Προσθήκης νέας διεύθυνσης συστήματος',
        'Realname' => '',
        'All email addresses get excluded on replaying on composing an email.' => '',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Ολα τα εισερχόμενα μηνύματα με αυτήν διεύθυνση (To:) θα αποστέλονται στην επιλεγμένη ουρά.',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'Διαχείριση Χρηστών',
        'Add User' => 'Προσθήκη Χρήστη',
        'Add a new Agent.' => '',
        'Login as' => 'Σύνδεση ως',
        'Title{user}' => '',
        'Firstname' => 'Ονομα',
        'Lastname' => 'Επώνυμο',
        'Start' => 'Αρχή',
        'End' => '',
        'User will be needed to handle tickets.' => 'Ο χρήστης θα διαχειρίζεται δελτία.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Μην ξεχάσετε να προσθέσετε ενα νέο χρήστη σε ομάδα η και ρόλους!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Χρήστες <-> Διαχείριση Ομάδων',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Βιβλίο Διευθύνσεων',
        'Return to the compose screen' => 'Επιστροφή στην οθόνη εισαγωγής',
        'Discard all changes and return to the compose screen' => 'Αγνοήστε τις αλλαγές και επιστρέψτε στην οθόνη εισαγωγής',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => '',

        # Template: AgentDashboardCalendarOverview
        'in' => '',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '',
        'Please update now.' => '',
        'Release Note' => '',
        'Level' => '',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => '',

        # Template: AgentLinkObject
        'Link Object: %s' => '',
        'Object' => 'Αντικείμενο',
        'Link Object' => 'Συνδεόμενο Αντικείμενο',
        'with' => 'με',
        'Select' => 'Επιλογή',
        'Unlink Object: %s' => '',

        # Template: AgentLookup
        'Lookup' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Ορθογράφος',
        'spelling error(s)' => 'Ορθογραφικά Λάθη',
        'or' => 'ή',
        'Apply these changes' => 'Εφαρμογή Αλλαγών',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Να διαγραφεί αυτό το αντικείμενο ?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '',
        'Fixed' => 'Διορθώθηκε',
        'Please select only one element or turn off the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => 'Μεταξύ',
        'Relative Period' => '',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '',

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
        'Import' => 'Εισαγωγή',
        'File is not a Stats config' => '',
        'No File selected' => 'Δέν έγινε επιλογή Αρχείου',

        # Template: AgentStatsOverview
        'Results' => 'Αποτελέσματα',
        'Total hits' => 'Συνολικα hits',
        'Page' => 'Σελίδα',

        # Template: AgentStatsPrint
        'Print' => 'Εκτύπωση',
        'No Element selected.' => 'Δεν εγινε επιλογή στοιχείου',

        # Template: AgentStatsView
        'Export Config' => '',
        'Information about the Stat' => '',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => '',
        'maximal period from' => '',
        'to' => 'πρός',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Το μηνυμα πρεπει να έχει αποδέκτη !',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Απαιτείται email διευθυνση (πχ. customer@example.com) στο To: !',
        'Bounce ticket' => 'Αναπήδηση δελτίου',
        'Ticket locked!' => 'Κλειδωμένο Δελτίο!',
        'Ticket unlock!' => 'Ανοιγμα Δελτίου!',
        'Bounce to' => 'Αναπήδηση σε',
        'Next ticket state' => 'Κατάσταση Επόμενου Δελτίου',
        'Inform sender' => 'Ενημέρωση αποστολέα',
        'Send mail!' => 'Αποστολή μηνύματος!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Πρέπει να υπολογιστεί ο χρόνος!',
        'Ticket Bulk Action' => 'Μαζικές ενέργειες δελτιου',
        'Spell Check' => 'Ελεγχος Ορθογραφίας',
        'Note type' => 'Τύπος Σημείωσης',
        'Next state' => 'Nδchster Status',
        'Pending date' => 'Ημερομηνία Εκρεμμότητας',
        'Merge to' => 'Ένωση με',
        'Merge to oldest' => '',
        'Link together' => '',
        'Link to Parent' => '',
        'Unlock Tickets' => 'Ξεκλείδωμα Δελτίων',

        # Template: AgentTicketClose
        'Ticket Type is required!' => '',
        'A required field is:' => '',
        'Close ticket' => 'Κλείσιμο δελτίου',
        'Previous Owner' => 'Προηγούμενος Ιδιοκτήτης',
        'Inform Agent' => 'Ενημέρωση Συνεργάτη',
        'Optional' => 'Προεραιτικό',
        'Inform involved Agents' => 'Ενημέρωση εμπλεκομμένων συνεργατών',
        'Attach' => 'Συναπτόμενο',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Το μήνυμα πρέπει να έχει ελεγχθεί για την ορθογραφία του!',
        'Compose answer for ticket' => 'Σύνθεση απάντησης για το δελτίο',
        'Pending Date' => 'εκκρεμής ημερομηνία',
        'for pending* states' => 'για εκκρεμείς* καταστάσεις',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Αλλαγή παραλήπτη του μηνύματος',
        'Set customer user and customer id of a ticket' => 'Ορίσμος του χρηστη πελατη και του id του πελατη σε ενα δελτίο',
        'Customer User' => 'Πελάτης Χρήστης',
        'Search Customer' => 'Αναζήτηση Πελάτη',
        'Customer Data' => 'Δεδομένα Πελάτη',
        'Customer history' => 'Ιστορικό Πελάτη',
        'All customer tickets.' => 'Όλα τα δελτία του πελάτη',

        # Template: AgentTicketEmail
        'Compose Email' => 'Σύνθεση Μηνύματος',
        'new ticket' => 'νέο δελτίο',
        'Refresh' => '',
        'Clear To' => 'Εκκαθαρίση σε',
        'All Agents' => 'Ολοι οι Συνεργάτες',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Τύπος Κειμένου',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Αλλαγή ελεύθερου κειμένου του δελτίου',

        # Template: AgentTicketHistory
        'History of' => 'Ιστορικό του',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Παρακαλώ χρησιμοποιείστε αριθμό δελτίου!',
        'Ticket Merge' => 'Ένωση μηνυμάτων',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => '',
        'Move Ticket' => 'Μεταφορά Δελτίου',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Προσθήκη σημείωσης στο δελτίο',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Χρόνος πρώτης απάντησης',
        'Service Time' => 'Χρόνος συντήρησης',
        'Update Time' => 'Χρόνος ενημερωσης',
        'Solution Time' => 'Χρόνος επίλυσης',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Απαιτείται τουλάχιστον ενα δελτίο!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Φίλτρο',
        'Change search options' => 'Αλλαγή Επιλογών Αναζήτησης',
        'Tickets' => 'Δελτία',
        'of' => 'του',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Δημιουργία Απάντησης',
        'Contact customer' => 'Επικοινωνία με Πέλατη',
        'Change queue' => 'Αλλαγή Ουράς',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'Αύξουσα Ταξινόμηση',
        'up' => 'Αύξουσα',
        'sort downward' => 'Φθήνουσα Ταξινόμηση',
        'down' => 'Φθίνουσα',
        'Escalation in' => 'Αναβάθμιση σε',
        'Locked' => 'Κλειδωμένο',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Αλλαγή Ιδιοκτήτη Δελτίου',

        # Template: AgentTicketPending
        'Set Pending' => 'Σε Εκρεμμότητα',

        # Template: AgentTicketPhone
        'Phone call' => 'Τηλεφωνική Κλήση',
        'Clear From' => 'Εκκαθάριση Απο',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Απλό',

        # Template: AgentTicketPrint
        'Ticket-Info' => '',
        'Accounted time' => 'Χρήση Χρόνου',
        'Linked-Object' => '',
        'by' => 'από',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Αλλαγή Προτεραιότητας Δελτίου',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Εμφανή Δελτία',
        'Tickets available' => 'Διαθέσιμα Δελτία',
        'All tickets' => 'Συνολικά Δελτία',
        'Queues' => 'Ουρές',
        'Ticket escalation!' => 'Αναβάθμιση Δελτίου!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Αλλαγή υπεύθυνου δελτίου',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Αναζήτηση Δελτίου',
        'Profile' => 'Προφίλ',
        'Search-Template' => 'Αναζήτηση Template',
        'TicketFreeText' => 'Πεδία Ελεύθερου Κειμένου',
        'Created in Queue' => 'Δημιουργία σε ουρά',
        'Article Create Times' => '',
        'Article created' => '',
        'Article created between' => '',
        'Change Times' => '',
        'No change time settings.' => '',
        'Ticket changed' => '',
        'Ticket changed between' => '',
        'Result Form' => 'Αποτελέσματα',
        'Save Search-Profile as Template?' => 'Αποθήκευση Φόρμας Αναζήτησης ?',
        'Yes, save it with name' => 'Ναι - με όνομα',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Ολο το κείμενο',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => '',
        'Collapse View' => '',
        'Split' => 'Διαχωρισμός',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => '',
        'Save filter settings as default' => '',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '',

        # Template: CustomerFooter
        'Powered by' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Σύνδεση',
        'Lost your password?' => 'Χάσατε τον Κωδικό?',
        'Request new password' => 'Ανάκτηση Κωδικού',
        'Create Account' => 'Δημιουργία Λογαριασμού',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Καλώς Ηλθατε %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Φορές',
        'No time settings.' => 'Χωρις χρονικες ρυθμίσεις.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Κάνετε click εδώ για να αναφέρετε πρόβλημα στο σύστημα!',

        # Template: Footer
        'Top of Page' => 'Αρχή Σελίδας',

        # Template: FooterSmall

        # Template: Header
        'Home' => '',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => '',
        'Welcome to %s' => 'Καλωσορίσατε στο %s',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Διαχειριστής',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Κωδικός Διαχειριστή',
        'Database-User' => 'Ονομα χρήστη βάσης',
        'default \'hot\'' => 'Προεπιλογή \'hot\'',
        'DB connect host' => '',
        'Database' => 'Βάση Δεδομένων',
        'Default Charset' => 'Προεπιλεγμενο Σετ Χαρακτήρων',
        'utf8' => '',
        'false' => '',
        'SystemID' => '',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Η ταυτότητα του συστήματος. Κάθε δελτίο και κάθε σύνδεση httpd θα έχει ώς πρόθεμα αυτόν τον αριθμό)',
        'System FQDN' => '',
        '(Full qualified domain name of your system)' => '(Ονομα και Domain του συστημάτος)',
        'AdminEmail' => '',
        '(Email of the system admin)' => '(Email του διαχειριστή)',
        'Organization' => 'Οργανισμός',
        'Log' => 'Καταγραφικό',
        'LogModule' => '',
        '(Used log backend)' => '(Χρήση Log Backend)',
        'Logfile' => 'Ονομα αρχείου Log',
        '(Logfile just needed for File-LogModule!)' => '(Logfile απαιτείται για το File-LogModule!)',
        'Webfrontend' => 'Web Interface',
        'Use utf-8 it your database supports it!' => 'Χρησιμοποιείστε utf-8 αν η βάση σας το υποτηρίζει!',
        'Default Language' => 'Προεπιλογή γλώσσας',
        '(Used default language)' => '(Εγινε χρήση προκαθορισμένης γλώσσσας)',
        'CheckMXRecord' => '',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Ελεγχος του MX Record της ηλεκτρονικής διεύθυνσης με σύνθεση απάντησης. Μην χρησιμοποιείτε CheckMXRecord αν το σύστημα σας χρησιμοποιεί σύνδεση dialup!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Για να μπορεσετε να χρησιμοπιήσετε το OTRS πρέπει να είσάγετε την παρακάτω γραμμή στο Terminal command line ώς χρήστης root.',
        'Restart your webserver' => 'Κανετε εποανεκίνηση του webserver.',
        'After doing so your OTRS is up and running.' => 'Μετά απο αυτή την ενέργεια το OTRS θα ενεργοποιηθεί.',
        'Start page' => 'Αρχική Σελίδα',
        'Your OTRS Team' => 'Η ομάδα OTRS',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Δεν έχετε δικαίωμα',

        # Template: Notify
        'Important' => 'Σημαντικό',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'εκτυπώθηκε απο',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS δοκιμαστική σελίδα',
        'Counter' => 'Μετρητής',

        # Template: Warning

        # Template: YUI

        # Misc
        'Edit Article' => '',
        'Create Database' => 'Δημιουργία Βάσης',
        'DB Host' => 'DB Διακομιστής',
        'Ticket Number Generator' => 'Γεννήτρια Αριθμού Δελτίου',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Αναγνώριση Δελτίου \'Νο. Δελτίου\', \'Νο. Κλήσης\' η  \'Κλήση#\')',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
        'Create new Phone Ticket' => 'Δημιουργία νέου Δελτίου τηλεφώνου',
        'Symptom' => 'Σύμπτωμα',
        'U' => '',
        'Site' => 'Site',
        'Customer history search (e. g. "ID342425").' => 'Αναζήτηση σε ιστορικό πελάτη (π.χ. "ID342425").',
        'Can not delete link with %s!' => '',
        'Close!' => 'Κλείσιμο! ',
        'for agent firstname' => 'Για όνομα συνεργάτη',
        'No means, send agent and customer notifications on changes.' => 'Οχι, σημαίνει αποστολή ενημερώσεων πελάτη μετά απο αλλαγές',
        'A web calendar' => 'Ημερολόγιο',
        'to get the realname of the sender (if given)' => 'Επιλογή του πραγματικού ονόματος του αποστολέα(αν αυτό δίνεται)',
        'OTRS DB Name' => '',
        'Notification (Customer)' => '',
        'Select Source (for add)' => 'Επιλογή πηγής (για προσθήκη)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Child-Object' => '',
        'Days' => 'Ημέρες',
        'Queue ID' => 'Ουρά ID',
        'Workflow Groups' => 'Workflow Gruppen',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'επεξεργασία επιλογών (π.χ. <OTRS_CONFIG_HttpType>)',
        'System History' => 'Ιστορικό Συστήματος',
        'customer realname' => 'Πραγματικό όνομα πελάτη',
        'First Response' => 'Πρώτη Απάντηση',
        'Pending messages' => 'Εκρεμμή Μηνύματα',
        'Modules' => 'Κομμάτι',
        'for agent login' => 'Για Login συνεργάτη',
        'Keyword' => 'Λέξη Κλειδί',
        'Close type' => 'Τύπος κλεισίματος',
        'DB Admin User' => 'DB Admin Χρήστης',
        'for agent user id' => 'Για UserID συνεργάτη',
        'Change user <-> group settings' => 'Αλλαγή χρηστών <-> Ρυθμίσεις Ομάδων',
        'Escalation' => '',
        '"}' => '',
        'Order' => 'Ταξινόμηση',
        'next step' => 'Επόμενο Βήμα',
        'Follow up' => 'Παρακολούθηση',
        'Customer history search' => 'Αναζήτηση σε ιστορικό πελάτη',
        'Δεν υπάρχουν πακέττα για το ζητούμενο Framework σε αυτό το Online αποθηκευτήριο, αλλά υπάρχουν πακέττα για άλλα Frameworks!' => '',
        'Stat#' => '',
        'Create new database' => 'Δημιουργία νέας βάσης',
        'No entry Found!' => 'Δεν βρέθηκε εγγραφή!',
        'ArticleID' => '',
        'Keywords' => 'Λέξεις Κλειδιά',
        'Ticket Escalation View' => '',
        'Today' => '',
        'No * possible!' => 'Δεν είναι δυνατο να κάνετε χρήση του "*" !',
        'Load' => 'Φόρτωμα',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Message for new Owner' => 'Μήνυμα για τον νεό ιδιοκτήτη',
        'to get the first 5 lines of the email' => 'Επιλογή των πρώτων 5 γραμμών του μηνύματος',
        'Sort by' => 'Ταξινόμηση Κατα',
        'OTRS DB Password' => 'OTRS DB Κωδικός',
        'Last update' => 'Τελευταία Ενημέρωση',
        'Tomorrow' => '',
        'to get the first 20 character of the subject' => 'Επιλογή 20 πρώτων χαρακτήρων του θέματος',
        'Select the customeruser:service relations.' => '',
        'DB Admin Password' => 'DB Admin Κωδικός',
        'Drop Database' => 'Διαγραφή Βάσης',
        'Advisory' => 'Οδηγία',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',
        'FileManager' => 'Διαχειριστής Aρχείων',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Επιλογές για τα δεδομένα του συγκεκριμένου
χρήστη-πελάτη (π.χ. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Τύπος Εκρεμμότητας',
        'Comment (internal)' => 'Σχόλιο (Εσωτερικό)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used!PostMaster filter will be used
anyway.' => 'Αν ο λογαριασμός σας είναι εμπιστευόμενος, θα χρησιμοποιηθεί(κατά προτεραιότητα) η ήδη υπάρχουσα X-OTRS κεφαλίδα στον
χρόνο άφιξης. Το φίλτρο PostMaster θα χρησιμοποιηθεί έτσι και αλλιώς',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Optionen von Ticket Daten (z. B. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Μορφή Δελτίου που χρησιμοποιηθηκε)',
        'Reminder' => 'Υπενθύμηση',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales
department, ...).' => 'Δημιουργία νέων ομάδων για να διαχειρίζονται τα δικαιώματα απο διάφορες ομάδες συνεργατών(π.χ.τμήμα αγορών,τμήμα
υποστήριξης,τμήμα πωλήσεων,...).',
        'Incident' => 'Περιστατικό',
        'OTRS DB connect host' => 'OTRS DB σύνδεση διακομιστή',
        'All Agent variables.' => '',
        ' (work units)' => ' (μονάδες εργασίας)',
        'Next Week' => '',
        'All Customer variables like defined in config option CustomerUser.' => 'Ολες οι μεταβλητές πελατών είναι στην επιλογή CustomerUser.',
        'accept license' => 'Αποδοχή Αδειας',
        'for agent lastname' => 'Για επώνυμο συνεργάτη',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Επιλογές για τον συγκεκριμένο χρήστη που
ζήτησε αυτή την ενέργεια (π.χ. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Μηνύματα Υπενθύμισης',
        'Parent-Object' => '',
        'Of couse this feature will take some system performance it self!' => 'Φυσικά αυτή η δυνατότητα θα καταναλώσει πόρους απο το σύστημα !',
        'Detail' => 'Λεπτομέρεια',
        'Your own Ticket' => 'Το Δελτίο Σου',
        'TicketZoom' => 'Ανοιγμα Δελτίου',
        'Don\'t forget to add a new user to groups!' => 'Μην ξεχάσετε να προσθέσετε ενα νέο χρήστη στις ομάδες!',
        'Open Tickets' => 'Ανοικτά Δελτία',
        'CreateTicket' => 'Δημιουργία Δελτίου',
        'You have to select two or more attributes from the select field!' => 'Πρέπει να επιλέξετε δύο η περισσότερες ιδιότητες απο το επιλεγμένο πεδίο',
        'System Settings' => 'Ρυθμίσεις Συστήματος',
        'WebWatcher' => 'Webwatcher',
        'Finished' => 'Τέλος',
        'D' => '',
        'All messages' => 'Συνολικά Μηνύματα',
        'System Status' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Artefact' => 'Αντικείμενο',
        'Object already linked as %s.' => '',
        'A article should have a title!' => 'Κάθε θέμα πρεπει να έχει τίτλο !',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'All email addresses get excluded on replaying on composing and email.' => '',
        'don\'t accept license' => 'Μη Αποδοχή Αδειας',
        'A web mail client' => 'Παραλήπτης ηλεκτρονικού ταχυδρομείου',
        'Compose Follow up' => 'Δημιουργία Follow up',
        'WebMail' => 'Ταχυδρομείο',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'επιλογές ιδιοκτήτη δελτίου(z. B. <OTRS_OWNER_UserFirstname>)',
        'DB Type' => 'DB Type',
        'kill all sessions' => 'καταστροφή όλων των sessions',
        'to get the from line of the email' => 'Επιλογή της γραμμής αποστολέα του μηνύματος',
        'Solution' => 'Επίλυση',
        'QueueView' => 'Ουρές',
        'My Queue' => 'Η ουρά μου',
        'Select Box' => 'Διαταγές SQL',
        'New messages' => 'Νέα Μηνύματα',
        'Can not create link with %s!' => '',
        'Linked as' => '',
        'Welcome to OTRS' => 'Καλώς Ηλθατε στο OTRS',
        'modified' => 'Αλλαξε',
        'Delete old database' => 'Διαγραφή παλαιας βάσης',
        'A web file manager' => 'Διαχειριστής αρχείων διαδικτύου',
        'Have a lot of fun!' => 'Καλή Διασκέδαση!',
        'Δεν υπάρχουν πακέττα η δεν επιλεχθηκαν νέα πακέτα στο επιλεγμένο Online αποθηκευτήριο !' => '',
        'send' => 'Αποστολή',
        'Send no notifications' => 'Μη Αποστολή Ενημερώσεων',
        'Note Text' => 'Κείμενο Σημείωσης',
        'POP3 Account Management' => 'Διαχείρηση Λογαριασμών POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => 'Διαχείριση Κατάστασης Συστήματος',
        'OTRS DB User' => 'OTRS DB χρήστης',
        'Mailbox' => 'Γραμματοκιβωτιο',
        'PhoneView' => 'Ουρές Τηλεφώνου',
        'Σημείωση Ασφάλειας: Πρέπει να ενεργοποιήσετε %s διότι η εφαρμογή ήδη τρέχει !' => '',
        'maximal period form' => '',
        'TicketID' => 'Αναγνωριστίκό (ID) Δελτίου',
        'Escaladed Tickets' => '',
        'Yes means, send no agent and customer notifications on changes.' => 'Ναι, σημαίνει μη αποστολή ενημερώσεων σε πελάτη μετά απο αλλαγές',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'το
email σας με αριθμο δελτιου "<OTRS_TICKET>" αναπηδησε στο "<OTRS_BOUNCE_TO>".Επισκευθείτε αυτήν την διεύθυνση για περισσότερες πληροφορίες',
        'Ticket Status View' => 'Κατάσταση Δελτίου',
        'Modified' => 'Ενημερώθηκε',
        'Αδυναμία επεξεργασίας του αρχείου Online Repository index!' => '',
        'Ticket selected for bulk action!' => 'Δελτίο Επιλεχθηκε για Μαζική Εργασία',
        'History::SystemRequest' => 'System Request (%s).',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
