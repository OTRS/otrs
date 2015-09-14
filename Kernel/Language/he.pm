# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# Copyright (C) 2014 Amir Elion <amir.elion@gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::he;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    my %Param = @_;


    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.432264479244345;

    # csv separator
    $Self->{Separator} = '';

    # TextDirection rtl or ltr
    $Self->{TextDirection} = 'rtl';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'כן',
        'No' => 'לא',
        'yes' => 'כן',
        'no' => 'לא',
        'Off' => 'כבוי',
        'off' => 'כבוי',
        'On' => 'מופעל',
        'on' => 'מופעל',
        'top' => 'למעלה',
        'end' => 'סוף',
        'Done' => 'בוצע',
        'Cancel' => 'ביטול',
        'Reset' => 'אפס',
        'more than ... ago' => 'יותר מלפני ... ',
        'in more than ...' => 'בעוד יותר מ ... ',
        'within the last ...' => 'ב ... האחרונים',
        'within the next ...' => 'ב ... הבאים',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Today' => 'היום',
        'Tomorrow' => 'מחר',
        'Next week' => 'בשבוע הבא',
        'day' => 'יום',
        'days' => 'ימים',
        'day(s)' => 'יום/ימים',
        'd' => 'י',
        'hour' => 'שעה',
        'hours' => 'שעות',
        'hour(s)' => 'שעה/שעות',
        'Hours' => 'שעות',
        'h' => 'ש',
        'minute' => 'דקה',
        'minutes' => 'דקות',
        'minute(s)' => 'דקה/דקות',
        'Minutes' => 'דקות',
        'm' => 'ד',
        'month' => 'חודש',
        'months' => 'חודשים',
        'month(s)' => 'חודש(ים)',
        'week' => 'שבוע',
        'week(s)' => 'שבוע(ות)',
        'quarter' => '',
        'quarter(s)' => '',
        'half-year' => '',
        'half-year(s)' => '',
        'year' => 'שנה',
        'years' => 'שנים',
        'year(s)' => 'שנה/שנים',
        'second(s)' => 'שניה/שניות',
        'seconds' => 'שניות',
        'second' => 'שניה',
        's' => 'ש',
        'Time unit' => 'יחידת זמן',
        'wrote' => 'כתב',
        'Message' => 'הודעה',
        'Error' => 'שגיאה',
        'Bug Report' => 'דיווח באג',
        'Attention' => 'שימו לב',
        'Warning' => 'אזהרה',
        'Module' => 'מודולה',
        'Modulefile' => 'קובץ מודולה',
        'Subfunction' => 'תת פונקציה',
        'Line' => 'קו',
        'Setting' => 'הגדרה',
        'Settings' => 'הגדרות',
        'Example' => 'דוגמא',
        'Examples' => 'דוגמאות',
        'valid' => 'תקף',
        'Valid' => 'תקף',
        'invalid' => 'לא תקף',
        'Invalid' => 'לא תקף',
        '* invalid' => '* לא תקף',
        'invalid-temporarily' => 'לא תקף זמנית',
        ' 2 minutes' => ' 2 דקות',
        ' 5 minutes' => ' 5 דקות',
        ' 7 minutes' => ' 7 דקות',
        '10 minutes' => '10 דקות',
        '15 minutes' => '15 דקות',
        'Mr.' => 'מר',
        'Mrs.' => 'מרת',
        'Next' => 'קדימה',
        'Back' => 'אחורה',
        'Next...' => 'קדימה...',
        '...Back' => '...אחורה',
        '-none-' => '-אף אחד-',
        'none' => 'אין',
        'none!' => 'אין!',
        'none - answered' => 'אף אחד - ללא מענה',
        'please do not edit!' => 'נא לא לערוך!',
        'Need Action' => 'נדרשת פעולה',
        'AddLink' => 'הוסף קישור',
        'Link' => 'קישור',
        'Unlink' => 'הסר קישור',
        'Linked' => 'מקושר',
        'Link (Normal)' => 'קישור (רגיל)',
        'Link (Parent)' => 'קישור (אב)',
        'Link (Child)' => 'קישור (בן)',
        'Normal' => 'רגיל',
        'Parent' => 'אב',
        'Child' => 'בן',
        'Hit' => 'ביקור',
        'Hits' => 'ביקורים',
        'Text' => 'מלל',
        'Standard' => 'סטנדרטי',
        'Lite' => 'Lite',
        'User' => 'משתמש',
        'Username' => 'שם משתמש',
        'Language' => 'שפה',
        'Languages' => 'שפות',
        'Password' => 'סיסמא',
        'Preferences' => 'העדפות',
        'Salutation' => 'כינוי כבוד',
        'Salutations' => 'כינויי כבוד',
        'Signature' => 'חתימה',
        'Signatures' => 'חתימות',
        'Customer' => 'לקוח',
        'CustomerID' => 'מספר זיהוי לקוח',
        'CustomerIDs' => 'מספרי זיהוי לקוח',
        'customer' => 'לקוח',
        'agent' => 'סוכן',
        'system' => 'מערכת',
        'Customer Info' => 'מידע לקוח',
        'Customer Information' => 'מידע לקוח',
        'Customer Companies' => 'חברות הלקוח',
        'Company' => 'חברה',
        'go!' => 'התחל!',
        'go' => 'התחל',
        'All' => 'כל',
        'all' => 'כל',
        'Sorry' => 'מצטערים',
        'update!' => 'עדכון!',
        'update' => 'עדכון',
        'Update' => 'עדכון',
        'Updated!' => 'עודכן!',
        'submit!' => 'שלח!',
        'submit' => 'שלח',
        'Submit' => 'שלח',
        'change!' => 'שנה!',
        'Change' => 'שנה',
        'change' => 'שנה',
        'click here' => 'לחץ כאן',
        'Comment' => 'הערה',
        'Invalid Option!' => 'אפשרות לא חוקית!',
        'Invalid time!' => 'זמן לא חוקי!',
        'Invalid date!' => 'תאריך לא חוקי!',
        'Name' => 'שם',
        'Group' => 'קבוצה',
        'Description' => 'תיאור',
        'description' => 'תיאור',
        'Theme' => 'ערכת עיצוב',
        'Created' => 'נוצר',
        'Created by' => 'נוצר על ידי',
        'Changed' => 'שונה',
        'Changed by' => 'שנה על ידי',
        'Search' => 'חיפוש',
        'and' => 'וגם',
        'between' => 'בין',
        'before/after' => 'לפני/אחרי',
        'Fulltext Search' => 'חיפוש טקסט מלא',
        'Data' => 'נתונים',
        'Options' => 'אפשרויות',
        'Title' => 'כותרת',
        'Item' => 'פריט',
        'Delete' => 'מחק',
        'Edit' => 'ערוך',
        'View' => 'צפה',
        'Number' => 'מספר',
        'System' => 'מערכת',
        'Contact' => 'איש קשר',
        'Contacts' => 'אנשי קשר',
        'Export' => 'ייצא',
        'Up' => 'למעלה',
        'Down' => 'למטה',
        'Add' => 'הוסף',
        'Added!' => 'נוסף!',
        'Category' => 'קטגוריה',
        'Viewer' => 'צופה',
        'Expand' => 'הרחב',
        'Small' => 'קטן',
        'Medium' => 'בינוני',
        'Large' => 'גדול',
        'Date picker' => 'בורר תאריך',
        'Show Tree Selection' => 'הצג עץ בחריה',
        'The field content is too long!' => 'תוכן השדה ארוך מדי!',
        'Maximum size is %s characters.' => 'הגודל המירבי הוא %s תווים.',
        'This field is required or' => 'שדה זה הוא שדה חובה או',
        'New message' => 'הודעה חדשה',
        'New message!' => 'הודעה חדשה!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'אנא השב על פניה/פניות אלו כדי לחזור לתצוגת המעקב הרגילה!',
        'You have %s new message(s)!' => 'יש לך %s הודעות חדשות!',
        'You have %s reminder ticket(s)!' => 'יש לך %s תזכורות!',
        'The recommended charset for your language is %s!' => 'קידוד התווים המומלץ לשפה שלך הוא %s!',
        'Change your password.' => 'שנה את הסיסמא שלך.',
        'Please activate %s first!' => 'אנא הפעל %s קודם לכן!',
        'No suggestions' => 'אין הצעות',
        'Word' => 'מילה',
        'Ignore' => 'התעלם',
        'replace with' => 'החלף ב',
        'There is no account with that login name.' => 'אין חשבון עם שם משתמש זה.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'ההתחברות נכשלה! שם המשתמש או הסיסמא שלך לא הוקלדו נכון.',
        'There is no acount with that user name.' => 'אין חשבון עם שם משתמש זה.',
        'Please contact your administrator' => 'אנא צרו קשר עם מנהל המערכת',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '',
        'Logout' => 'התנתק',
        'Logout successful. Thank you for using %s!' => 'ההתנתקות הצליחה! תודה על השימוש ב-%s!',
        'Feature not active!' => 'יכולת זו אינה מופעלת!',
        'Agent updated!' => 'הסוכן עודכן!',
        'Database Selection' => 'בחירת בסיס נתונים',
        'Create Database' => 'צור בסיס נתונים',
        'System Settings' => 'הגדרות מערכת',
        'Mail Configuration' => 'הגדרות דואר אלקטרוני',
        'Finished' => 'הסתיים',
        'Install OTRS' => 'התקנת OTRS',
        'Intro' => 'מבוא',
        'License' => 'רישיון',
        'Database' => 'בסיס נתונים',
        'Configure Mail' => 'הגדר דואר אלקטרוני',
        'Database deleted.' => 'בסיס הנתונים נמחק.',
        'Enter the password for the administrative database user.' => 'הקלידו את הסיסמא למשתמש מנהל בסיס הנתונים',
        'Enter the password for the database user.' => 'הקלידו את הסיסמא למשתמש בסיס הנתונים',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'אם קבעתם סיסמת root לבסיס הנתונים שלכם, יש להקלידה כאן. אם לא, השאירו את השדה ריק',
        'Database already contains data - it should be empty!' => 'בסיס הנתונים כבר מכיל מידע - עליו להיות ריק!',
        'Login is needed!' => 'נדרשת התחברות!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '',
        'Password is needed!' => 'נדרשת סיסמא!',
        'Take this Customer' => 'קבל לקוח זה',
        'Take this User' => 'קבל משתמש זה',
        'possible' => 'אפשרי',
        'reject' => 'דחה',
        'reverse' => 'הפוך',
        'Facility' => 'מתקן',
        'Time Zone' => 'אזור זמן',
        'Pending till' => 'ממתין עד',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'אל תשתמשו בחשבון משתמש העל עם המערת! צרו סוכנים חדשים ועבדו עם חשבונות אלו במקום זאת',
        'Dispatching by email To: field.' => 'שליחה לפי שדה דוא"ל אל.',
        'Dispatching by selected Queue.' => 'שליחה לפי התור שנבחר.',
        'No entry found!' => 'לא נמצאה רשומה!',
        'Session invalid. Please log in again.' => 'ההתחברות אינה תקפה. אנא התחבר שנית.',
        'Session has timed out. Please log in again.' => 'ההתחברות פגה. אנא התחבר שנית.',
        'Session limit reached! Please try again later.' => 'הזמן המירבי של ההתחברות חלף. אנא נסו שוב מאוחר יותר.',
        'No Permission!' => 'אין הרשאה!',
        '(Click here to add)' => '(לחץ כאן על מנת להוסיף)',
        'Preview' => 'תצוגה מקדימה',
        'Package not correctly deployed! Please reinstall the package.' =>
            'החבילה לא מותקנת נכון. אנא התקינו מחדש.',
        '%s is not writable!' => '%s אינו משתנה!',
        'Cannot create %s!' => 'לא ניתן ליצור %s!',
        'Check to activate this date' => 'סמנו כדי להפעיל תאריך זה',
        'You have Out of Office enabled, would you like to disable it?' =>
            'הגדרה של היעדרות מהמשרד מופעלת, האם תרצו לכבותה?',
        'News about OTRS releases!' => '',
        'Customer %s added' => 'הלקוח %s נוסף',
        'Role added!' => 'התפקיד נוסף!',
        'Role updated!' => 'התפקיד עודכן!',
        'Attachment added!' => 'קובץ מצורף נוסף!',
        'Attachment updated!' => 'קובץ מצורף עודכן!',
        'Response added!' => 'המענה נוסף!',
        'Response updated!' => 'המענה עודכן!',
        'Group updated!' => 'הקבוצה עודכנה',
        'Queue added!' => 'התור נוסף!',
        'Queue updated!' => 'התור עודכן!',
        'State added!' => 'הסטטוס נוסף!',
        'State updated!' => 'הסטטוס עודכן!',
        'Type added!' => 'הסוג נוסף!',
        'Type updated!' => 'הסוג עודכן!',
        'Customer updated!' => 'הלקוח עודכן!',
        'Customer company added!' => 'חברת הלקוח נוספה!',
        'Customer company updated!' => 'חברת הלקוח עודכנה!',
        'Note: Company is invalid!' => 'שים לב: החברה אינה תקינה!',
        'Mail account added!' => 'חשבון דוא"ל נוסף!',
        'Mail account updated!' => 'חשבון דוא"ל עודכן!',
        'System e-mail address added!' => 'כתובת דוא"ל מערכת נוספה!',
        'System e-mail address updated!' => 'כתובת דוא"ל מערכת עודכנה!',
        'Contract' => 'חוזה',
        'Online Customer: %s' => 'לקוח מקוון: %s',
        'Online Agent: %s' => 'סוכן מקוון: %s',
        'Calendar' => 'לוח שנה',
        'File' => 'קובץ',
        'Filename' => 'שם קובץ',
        'Type' => 'סוג',
        'Size' => 'גודל',
        'Upload' => 'העלה',
        'Directory' => 'תיקייה',
        'Signed' => 'חתום',
        'Sign' => 'חתום',
        'Crypted' => 'מוצפן',
        'Crypt' => 'הצפן',
        'PGP' => 'PGP',
        'PGP Key' => 'מפתח PGP',
        'PGP Keys' => 'מפתחות PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'תעודת S/MIME',
        'S/MIME Certificates' => 'תעודות S/MIME',
        'Office' => 'משרד',
        'Phone' => 'טלפון',
        'Fax' => 'פקס',
        'Mobile' => 'נייד',
        'Zip' => 'מיקוד',
        'City' => 'עיר',
        'Street' => 'רחוב',
        'Country' => 'ארץ',
        'Location' => 'מיקום',
        'installed' => 'מותקן',
        'uninstalled' => 'לא מותקן',
        'Security Note: You should activate %s because application is already running!' =>
            '',
        'Unable to parse repository index document.' => '',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '',
        'No packages, or no new packages, found in selected repository.' =>
            '',
        'Edit the system configuration settings.' => 'ערכו את הגדרות המערכת.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '',
        'printed at' => 'הודפס ב',
        'Loading...' => 'טוען...',
        'Dear Mr. %s,' => 'אדון %s היקר,',
        'Dear Mrs. %s,' => 'גברת %s היקרה,',
        'Dear %s,' => '%s היקר/ה,',
        'Hello %s,' => 'שלום %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'חשבון חדש נוצר. פרטי התחברות נשלחו אל %s. אנא בדקו את הדוא"ל שלכם',
        'Please press Back and try again.' => 'אנא לחצו על חזור ונסו שנית.',
        'Sent password reset instructions. Please check your email.' => 'נשלחו הנחיות לאיפוס סיסמא. אנא בדקו את הדוא"K שלכם.',
        'Sent new password to %s. Please check your email.' => 'סיסמא חדשה נשלחה אל %s. אנא בדקו את הדוא"ל שלכם',
        'Upcoming Events' => 'אירועים קרובים',
        'Event' => 'אירוע',
        'Events' => 'אירועים',
        'Invalid Token!' => 'קוד לא תקין!',
        'more' => 'עוד',
        'Collapse' => 'צמצם',
        'Shown' => 'מוצג',
        'Shown customer users' => 'משתמשי לקוח מוצגים',
        'News' => 'חדשות',
        'Product News' => 'חדשות מוצר',
        'OTRS News' => 'חדשות OTRS',
        '7 Day Stats' => 'סטטיסטיקה של 7 ימים',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Mark' => 'סמן',
        'Unmark' => 'בטל סימון',
        'Bold' => 'מודגש',
        'Italic' => 'מוטה',
        'Underline' => 'קו תחתון',
        'Font Color' => 'צבע גופן',
        'Background Color' => 'צבע רקע',
        'Remove Formatting' => 'הסר עיצוב',
        'Show/Hide Hidden Elements' => 'הצג/הסתר רכיבים מוסתרים',
        'Align Left' => 'הצמד לשמאל',
        'Align Center' => 'מרכז',
        'Align Right' => 'הצמד לימין',
        'Justify' => 'הצמד לשני הכיוונים',
        'Header' => 'כותרת',
        'Indent' => 'הזחה',
        'Outdent' => 'בטל הזחה',
        'Create an Unordered List' => 'צור רשימה לא ממוספרת',
        'Create an Ordered List' => 'צור רשימה ממוספרת',
        'HTML Link' => 'קישור HTML',
        'Insert Image' => 'הוסף תמונה',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'בטל',
        'Redo' => 'בצע שנית',
        'OTRS Daemon is not running.' => '',
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Problems processing server result. Please try again later.' => '',
        'Username and password do not match. Please try again.' => 'שם משתמש וסיסמא אינם תואמים. אנא נסו שנית.',
        'The selected process is invalid!' => 'התהליך שנבחר אינו תקין!',
        'Upgrade to %s now!' => '',
        '%s Go to the upgrade center %s' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '',
        'Your system was successfully upgraded to %s.' => '',
        'There was a problem during the upgrade to %s.' => '',
        '%s was correctly reinstalled.' => '',
        'There was a problem reinstalling %s.' => '',
        'Your %s was successfully updated.' => '',
        'There was a problem during the upgrade of %s.' => '',
        '%s was correctly uninstalled.' => '',
        'There was a problem uninstalling %s.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => 'יום תחילת השנה',
        'International Workers\' Day' => 'חג העובדים הבינלאומי',
        'Christmas Eve' => 'ערב חג המולד',
        'First Christmas Day' => '1. היום הראשון של חג המולד',
        'Second Christmas Day' => '2. היום השני של חג המולד',
        'New Year\'s Eve' => 'ערב השנה החדשה האזרחי',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS כמבקש',
        'OTRS as provider' => 'OTRS כמספק',
        'Webservice "%s" created!' => 'Webservice "%s" נוצר!',
        'Webservice "%s" updated!' => 'Webservice "%s" עודכן!',

        # Template: AAAMonth
        'Jan' => 'ינו',
        'Feb' => 'פבר',
        'Mar' => 'מרץ',
        'Apr' => 'אפר',
        'May' => 'מאי',
        'Jun' => 'יונ',
        'Jul' => 'יול',
        'Aug' => 'אוג',
        'Sep' => 'ספא',
        'Oct' => 'אוק',
        'Nov' => 'נוב',
        'Dec' => 'דצמ',
        'January' => 'ינואר',
        'February' => 'פברואר',
        'March' => 'מרץ',
        'April' => 'אפריל',
        'May_long' => 'מאי',
        'June' => 'יוני',
        'July' => 'יולי',
        'August' => 'אוגוסט',
        'September' => 'ספטמבר',
        'October' => 'אוקטובר',
        'November' => 'נובמבר',
        'December' => 'דצמבר',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'ההעדפות עודכנו בהצלחה!',
        'User Profile' => 'פרופיל משתמש',
        'Email Settings' => 'הגדרות דוא"ל',
        'Other Settings' => 'הגדרות אחרות',
        'Change Password' => 'שנה סיסמא',
        'Current password' => 'סיסמא נוכחית',
        'New password' => 'סיסמא חדשה',
        'Verify password' => 'אמת סיסמא',
        'Spelling Dictionary' => 'מילון איות',
        'Default spelling dictionary' => 'מילון איות רגיל',
        'Max. shown Tickets a page in Overview.' => 'מספר הפניות המירבי המוצג בעמוד מבט על.',
        'The current password is not correct. Please try again!' => 'הסיסמא הנוכחית אינה נכונה. אנא נסה שנית!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'לא ניתן לעדכן סיסמא. הסיסמאות החדשות שלכם אינן תואמות. אנא נסו שנית!',
        'Can\'t update password, it contains invalid characters!' => 'לא ניתן לעדכן סיסמא. היא כוללת תווים אסורים!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'לא ניתן לעדכן סיסמא. היא חייבת להכיל לפחות  %s  תווים!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'לא ניתן לעדכן סיסמא. היא חייבת להכיל לפחות 2 אותיות קטנות ו- 2 גדולות!.',
        'Can\'t update password, it must contain at least 1 digit!' => 'לא ניתן לעדכן סיסמא. היא חייבת להכיל לפחות מספר אחד!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'לא ניתן לעדכן סיסמא. היא חייבת להכיל לפחות 2 תווים!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'לא ניתן לעדכן סיסמא. כבר השתמשתם בסיסמא זו. אנא בחרו סיסמא חדשה!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '',
        'CSV Separator' => 'מפריד CSV',

        # Template: AAATicket
        'Status View' => 'תצוגת סטטוס',
        'Service View' => '',
        'Bulk' => 'מרובה',
        'Lock' => 'נעל',
        'Unlock' => 'שחרר נעילה',
        'History' => 'היסטוריה',
        'Zoom' => 'זום',
        'Age' => 'נוצר לפני',
        'Bounce' => 'החזר',
        'Forward' => 'קדימה',
        'From' => 'מאת',
        'To' => 'אל',
        'Cc' => 'העתק',
        'Bcc' => 'העתק נסתר',
        'Subject' => 'נושא',
        'Move' => 'העבר',
        'Queue' => 'תור',
        'Queues' => 'תורות',
        'Priority' => 'עדיפות',
        'Priorities' => 'עדיפויות',
        'Priority Update' => 'עדכן עדיפות',
        'Priority added!' => 'העדיפות נוספה!',
        'Priority updated!' => 'העדיפות עודכנה!',
        'Signature added!' => 'חתימה נוספה!',
        'Signature updated!' => 'חתימה עודכנה!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'הסכם רמת שירות',
        'Service Level Agreements' => 'הסכמי רמת שירות',
        'Service' => 'שירות',
        'Services' => 'שירותים',
        'State' => 'מצב',
        'States' => 'מצבים',
        'Status' => 'סטטוס',
        'Statuses' => 'סטטוסים',
        'Ticket Type' => 'סוג פניה',
        'Ticket Types' => 'סוגי פניות',
        'Compose' => 'חבר',
        'Pending' => 'ממתין',
        'Owner' => 'בעלים',
        'Owner Update' => 'הבעלים עודכן',
        'Responsible' => 'אחראי',
        'Responsible Update' => 'אחראי עודכן',
        'Sender' => 'שולח',
        'Article' => 'מאמר',
        'Ticket' => 'פניה',
        'Createtime' => 'זמן יצירה',
        'plain' => 'לא מעוצב',
        'Email' => 'דוא"ל',
        'email' => 'דוא"ל',
        'Close' => 'סגור',
        'Action' => 'פעולה',
        'Attachment' => 'קובץ מצורף',
        'Attachments' => 'קבצים מצורפים',
        'This message was written in a character set other than your own.' =>
            'הודעה זו נכתבה עם תווים שונים מאלו שלכם.',
        'If it is not displayed correctly,' => 'אם זה לא מוצג באופן תקין,',
        'This is a' => 'זה',
        'to open it in a new window.' => 'לפתיחה בחלון חדש',
        'This is a HTML email. Click here to show it.' => 'זוהי הודעת HTML. לחצו כאן כדי להציגה.',
        'Free Fields' => 'שדות חופשיים',
        'Merge' => 'מזג',
        'merged' => 'מוזג',
        'closed successful' => 'סגירה הצליחה',
        'closed unsuccessful' => 'סגירה לא הצליחה',
        'Locked Tickets Total' => 'סה"כ פניות נעולות',
        'Locked Tickets Reminder Reached' => 'הגיע זמן תזכורת פניה נעולה',
        'Locked Tickets New' => 'פניה נעולה חדשה',
        'Responsible Tickets Total' => 'סה"כ פניות של אחראי',
        'Responsible Tickets New' => 'פניות חדשות לאחראי',
        'Responsible Tickets Reminder Reached' => 'הגיע זמן תזכורת אחראי פניות',
        'Watched Tickets Total' => 'סה"כ פניות במעקב',
        'Watched Tickets New' => 'פניות חדשות במעקב',
        'Watched Tickets Reminder Reached' => 'הגיע זמן תזכורת פניות במעקב',
        'All tickets' => 'כל הפניות',
        'Available tickets' => 'פניות זמינות',
        'Escalation' => 'אסקלציה',
        'last-search' => 'חיפוש אחרון',
        'QueueView' => 'תצוגת התור',
        'Ticket Escalation View' => 'תצוגת אסקלציה של פניה',
        'Message from' => 'הודעה מ',
        'End message' => 'סוף ההודעה',
        'Forwarded message from' => 'הודעה שהועברה מאת',
        'End forwarded message' => 'סוף ההודעה שהועברה',
        'Bounce Article to a different mail address' => '',
        'Reply to note' => '',
        'new' => 'חדש',
        'open' => 'פתוח',
        'Open' => 'פתוח',
        'Open tickets' => 'פניות פתוחות',
        'closed' => 'סגור',
        'Closed' => 'סגור',
        'Closed tickets' => 'פניות סגורות',
        'removed' => 'הוסר',
        'pending reminder' => 'ממתין לתזכורת',
        'pending auto' => 'ממתין לאוטמטי',
        'pending auto close+' => 'ממתין לסגירה אוטומטית+',
        'pending auto close-' => 'ממתין לסגירה אוטומטית-',
        'email-external' => 'דוא"ל חיצוני',
        'email-internal' => 'דוא"ל פנימי',
        'note-external' => 'הודעה חיצונית',
        'note-internal' => 'הודעה פנימית',
        'note-report' => 'הודעה לדוח',
        'phone' => 'טלפון',
        'sms' => 'SMS',
        'webrequest' => 'בקשת אינטרנט',
        'lock' => 'נעל',
        'unlock' => 'שחרר נעילה',
        'very low' => 'נמוכה מאוד',
        'low' => 'נמוכה',
        'normal' => 'רגילה',
        'high' => 'גבוהה',
        'very high' => 'גבוהה מאוד',
        '1 very low' => '1 נמוכה מאוד',
        '2 low' => '2 נמוכה',
        '3 normal' => '3 רגילה',
        '4 high' => '4 גבוהה',
        '5 very high' => '5 גבוהה מאוד',
        'auto follow up' => 'מעקב אוטומטי',
        'auto reject' => 'דחייה אוטומטית',
        'auto remove' => 'הסרה אוטומטית',
        'auto reply' => 'מענה אוטומטי',
        'auto reply/new ticket' => 'מענה אוטומטי/פניה חדשה',
        'Create' => 'צור',
        'Answer' => 'מענה',
        'Phone call' => 'שיחת טלפון',
        'Ticket "%s" created!' => 'הפניה "%s" נוצרה!',
        'Ticket Number' => 'מספר פניה',
        'Ticket Object' => 'אובייקט הפניה',
        'No such Ticket Number "%s"! Can\'t link it!' => 'מספר פניה "%s" לא קיים! לא ניתן לקשר אליה!',
        'You don\'t have write access to this ticket.' => 'אין לכם הרשאות גישה לפניה זו.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'מצטערים. עליכם להיות בעלי הפניה כדי לבצע פעולה זו.',
        'Please change the owner first.' => 'אנא שנו את הבעלים קודם.',
        'Ticket selected.' => 'הפניה נבחרה.',
        'Ticket is locked by another agent.' => 'הפניה בבעלות סוכן אחר!',
        'Ticket locked.' => 'הפניה נעולה.',
        'Don\'t show closed Tickets' => 'אל תציג פניות סגורות',
        'Show closed Tickets' => 'הצג פניות סגורות',
        'New Article' => 'מאמר חדש',
        'Unread article(s) available' => 'מאמר(ים) שלא נקראו זמינים',
        'Remove from list of watched tickets' => 'הסר מרשימת פניות במעקב',
        'Add to list of watched tickets' => 'הוסף לרשימת פניות במעקב',
        'Email-Ticket' => 'פניה בדוא"ל',
        'Create new Email Ticket' => 'צור פניה חדשה בדוא"ל',
        'Phone-Ticket' => 'פניה בטלפון',
        'Search Tickets' => 'חפש פניה',
        'Customer Realname' => '',
        'Customer History' => '',
        'Edit Customer Users' => 'ערוך משתמשי לקוח',
        'Edit Customer' => 'ערוך לקוח',
        'Bulk Action' => 'פעולה גורפת',
        'Bulk Actions on Tickets' => 'פעולות גורפות על פניות',
        'Send Email and create a new Ticket' => 'שלח דוא"ל וצור פניה חדשה',
        'Create new Email Ticket and send this out (Outbound)' => 'צור פניה חדשה בדוא"ל ושלח אותה (דואר יוצא)',
        'Create new Phone Ticket (Inbound)' => 'צור פניה חדשה בטלפון (שיחה נכנסת)',
        'Address %s replaced with registered customer address.' => 'הכתובת %s מוחלפת בכתובת של הלקוח הרשום.',
        'Customer user automatically added in Cc.' => 'משתשמ לקוח נוסף אוטומטית למכותבים.',
        'Overview of all open Tickets' => 'מבט-על של כל הפניות הפתוחות',
        'Locked Tickets' => 'פניות נעולות',
        'My Locked Tickets' => 'הפניות הנעולות שלי',
        'My Watched Tickets' => 'הפניות שאני עוקב אחריהן',
        'My Responsible Tickets' => 'הפניות שאני אחראי עליהן',
        'Watched Tickets' => 'פניות במעקב',
        'Watched' => 'במעקב',
        'Watch' => 'עקוב',
        'Unwatch' => 'הסר מעקב',
        'Lock it to work on it' => 'נעל זאת כדי לעבוד על כך',
        'Unlock to give it back to the queue' => 'שחרר נעילה כדי להחזירה לתור',
        'Show the ticket history' => 'הצג את היסטוריית הפניה',
        'Print this ticket' => 'הדפס פניה זו',
        'Print this article' => 'הדפס מאמר זה',
        'Split' => 'פצל',
        'Split this article' => 'פצל מאמר זה',
        'Forward article via mail' => 'העבר מאמר דרך דוא"ל',
        'Change the ticket priority' => 'שנה עדיפות של הפניה',
        'Change the ticket free fields!' => 'שנה את השדות החופשיים של פניה זו!',
        'Link this ticket to other objects' => 'קשר את הפניה לאובייקטים אחרים',
        'Change the owner for this ticket' => 'שנה את הבעלים של פניה זו',
        'Change the  customer for this ticket' => 'שנה את הלקוח עבור פניה זו',
        'Add a note to this ticket' => 'הוסף הערה לפניה זו',
        'Merge into a different ticket' => 'מזג יחד עם פניה קיימת',
        'Set this ticket to pending' => 'סמן פניה זו כ"ממתינה"',
        'Close this ticket' => 'סגור פניה זו',
        'Look into a ticket!' => 'הסתכל בפרטי הפניה!',
        'Delete this ticket' => 'מחק פניה זו!',
        'Mark as Spam!' => 'סמן כספאם!',
        'My Queues' => 'התורות שלי',
        'Shown Tickets' => 'פניות מוצגות',
        'Shown Columns' => 'עמודות מוצגות',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'הדוא"ל שלכם עם פניה מספר "<OTRS_TICKET>" מוזגה עם פניה "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'פניה %s: זמן המענה הראשוני חלף (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'פניה %s: זמן המענה הראשוני יחלוף תוך %s!',
        'Ticket %s: update time is over (%s)!' => 'פניה %s: זמן העדכון חלף (%s)!',
        'Ticket %s: update time will be over in %s!' => 'פניה %s: זמן העדכון יחלוף בעוד %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: Lösungszeit ist abgelaufen (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'פניה %s: זמן הפתרון יחלוף בעוד %s!',
        'There are more escalated tickets!' => 'יש עוד פניות שעברו אסקלציה!',
        'Plain Format' => 'תצורה ללא עיצוב',
        'Reply All' => 'השב לכולם',
        'Direction' => 'כיוון',
        'New ticket notification' => 'התראה על פניה חדשה',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'שלח לי התראה אם יש פניה חדשה ב"תורות" שלי.',
        'Send new ticket notifications' => 'שלח התראה על פניה חדשה',
        'Ticket follow up notification' => 'התראה למעקב אחר פניה',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'שלח לי התראות אם לקוח שולח מעקב ואני הבעלים של הפניה או שהפניה לא נעולה ובאחד מהתורים שאני מנוי עליהם.',
        'Send ticket follow up notifications' => 'שלח התראות מעקב פניות',
        'Ticket lock timeout notification' => 'התראת נעילת פניה עקב זמן שחלף',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'שלח לי התראות אם נעילת פניה נפתחת על ידי המערכת.',
        'Send ticket lock timeout notifications' => 'שלח התראות נעילת פניה עקב זמן שחלף',
        'Ticket move notification' => 'התראת העברת פניה',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'שלח לי התראה אם פניה מועברת לתוך אחד מ"התורות" שלי.',
        'Send ticket move notifications' => 'שלח התראות בעת העברת פניה',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => 'תור מותאם',
        'QueueView refresh time' => 'זמן רענון תצוגת תור',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            '',
        'Refresh QueueView after' => 'רענן תצוגת תור מהירה לאחר',
        'Screen after new ticket' => 'המסך לאחר פניות חשדות',
        'Show this screen after I created a new ticket' => 'הצג מסך זה לאחר שאני יוצר פניה חדשה',
        'Closed Tickets' => 'פניות שנסגרו',
        'Show closed tickets.' => 'הצג פניות שנסגרו.',
        'Max. shown Tickets a page in QueueView.' => 'המספר המירבי של פניות בעמוד תצגות תור מהירה.',
        'Ticket Overview "Small" Limit' => 'מגבלת מבט-על מוקטן של פניות',
        'Ticket limit per page for Ticket Overview "Small"' => '',
        'Ticket Overview "Medium" Limit' => '',
        'Ticket limit per page for Ticket Overview "Medium"' => '',
        'Ticket Overview "Preview" Limit' => '',
        'Ticket limit per page for Ticket Overview "Preview"' => '',
        'Ticket watch notification' => 'התראת פניה במעקב',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'שלח לי אותן התראות עבור פניות במעקב כמו ההתראות של בעלי פניות אלו',
        'Send ticket watch notifications' => 'שלח התראות פניות במעקב',
        'Out Of Office Time' => 'זמן מחוץ למשרד',
        'New Ticket' => 'פניה חדשה',
        'Create new Ticket' => 'צור פניה חדשה',
        'Customer called' => 'הלקוח התקשר',
        'phone call' => 'שיחת טלפון',
        'Phone Call Outbound' => 'שיחת טלפון יוצאת',
        'Phone Call Inbound' => 'שיחת טלפון נכנסת',
        'Reminder Reached' => 'הגיע זמן התזכורת',
        'Reminder Tickets' => 'פניות תזכורת',
        'Escalated Tickets' => 'פניות עם אסקלציה',
        'New Tickets' => 'פניות חדשות',
        'Open Tickets / Need to be answered' => 'פניות פתוחות / ממתינות למענה',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'כל הפניות הפתוחות, פניות שכבר עבדו עליהן, אך עדיין ממתינות למענה',
        'All new tickets, these tickets have not been worked on yet' => 'כל הפניות החדשות, כאלו שטרם עבדו עליהן',
        'All escalated tickets' => 'כל הפניות שעברו אסקלציה',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'כל הפניות שמוגדרת להן תזכורת שמועדה הגיע',
        'Archived tickets' => 'פניות שבארכיון',
        'Unarchived tickets' => 'פניות שאינן בארכיון',
        'Ticket Information' => 'מידע על הפניה',
        'including subqueues' => '',
        'excluding subqueues' => '',

        # Template: AAAWeekDay
        'Sun' => 'א',
        'Mon' => 'ב',
        'Tue' => 'ג',
        'Wed' => 'ד',
        'Thu' => 'ה',
        'Fri' => 'ו',
        'Sat' => 'ש',

        # Template: AdminACL
        'ACL Management' => 'ניהול ACL',
        'Filter for ACLs' => 'מסנן עבור ACLs',
        'Filter' => 'מסנן',
        'ACL Name' => 'שם ACL',
        'Actions' => 'פעולות',
        'Create New ACL' => 'צור ACL חדש',
        'Deploy ACLs' => 'הפעל ACLs',
        'Export ACLs' => 'ייצא ACLs',
        'Configuration import' => 'הגדרות ייבוא',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'זהו שדה נדרש.',
        'Overwrite existing ACLs?' => 'לדרוס ACL קיימים?',
        'Upload ACL configuration' => 'העלה הגדרות ACL',
        'Import ACL configuration(s)' => 'ייבא הגדרות ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '',
        'ACL name' => '',
        'Validity' => 'תקפות',
        'Copy' => 'העתק',
        'No data found.' => 'לא נמצאו נתונים.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ערוך ACL %s',
        'Go to overview' => 'עבור למבט-על',
        'Delete ACL' => 'מחק ACL',
        'Delete Invalid ACL' => 'מחק ACL לא חוקי',
        'Match settings' => 'התאם הגדרות',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => 'שנה הגדרות',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '',
        'Check the official' => '',
        'documentation' => 'תיעוד',
        'Show or hide the content' => 'הצג או הסתר תוכן',
        'Edit ACL information' => 'ערוך מידע ACL',
        'Stop after match' => 'עצור לאחר ההתאמה',
        'Edit ACL structure' => 'ערוך מבנה ACL',
        'Save' => 'שמור',
        'or' => 'או',
        'Save and finish' => 'שמור וסיים',
        'Do you really want to delete this ACL?' => '',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '',
        'An item with this name is already present.' => 'פריט עם שם זה כבר קיים.',
        'Add all' => 'הוסף הכל',
        'There was an error reading the ACL data.' => 'שגיאה בקריאת נתוני ACL.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAttachment
        'Attachment Management' => 'ניהול קצבים מצורפים',
        'Add attachment' => 'הוסף קובץ מצורף',
        'List' => 'רשימה',
        'Download file' => 'הורד קובץ',
        'Delete this attachment' => 'מחק קובץ מצורף זה',
        'Add Attachment' => 'הוסף קובץ מצורף',
        'Edit Attachment' => 'ערוך קובץ מצורף',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'ניהול מענים אוטומטיים',
        'Add auto response' => 'הוסף מענה אוטומטי',
        'Add Auto Response' => 'הוסף מענה אוטומטי',
        'Edit Auto Response' => 'ערוך מענה אוטומטי',
        'Response' => 'מענה',
        'Auto response from' => 'מענה אוטומטי מאת',
        'Reference' => 'הפנייה',
        'You can use the following tags' => 'אתם יכולים להשתמש בתגיות הבאות',
        'To get the first 20 character of the subject.' => 'לקבל את 20 התווים הראשונים של הנושא',
        'To get the first 5 lines of the email.' => 'לקבל את 5 השורות הראשונות של הדוא"ל',
        'To get the realname of the sender (if given).' => 'לקבל את השם האמיתי של השולח (אם נמסר)',
        'To get the article attribute' => 'לקבל את מאפייני המאמר',
        ' e. g.' => 'למשל',
        'Options of the current customer user data' => 'אפשרויות של נתוני משתמש לקוח נוכחי',
        'Ticket owner options' => 'אפשרויות בעל הפניה',
        'Ticket responsible options' => 'אפשרויות האחראי על הפניה',
        'Options of the current user who requested this action' => 'אפשרויות למשתמש הנוכחי שביקש את הפעולה הזו',
        'Options of the ticket data' => 'אפשרויות לנתוני הפניה',
        'Options of ticket dynamic fields internal key values' => 'אפשרויות לערכי מפתח פנימי בשדות פניה דינמיים',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'אפשרויות הגדרה',
        'Example response' => 'מענה לדוגמא',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '',
        'Support Data Collector' => '',
        'Support data collector' => '',
        'Hint' => 'רמז',
        'Currently support data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '',
        'Configuration' => 'הגדרות',
        'Send support data' => '',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '',
        'System Registration' => 'רישום מערכת',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => '',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '',
        'Please note that you using OTRS cloud services requires the system to be registered.' =>
            '',
        'Register this system' => '',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '',
        'Upgrade to %s' => '',

        # Template: AdminCustomerCompany
        'Customer Management' => 'ניהול לקוחות',
        'Wildcards like \'*\' are allowed.' => 'תווי חיפוש מיוחדים כגון \'*\' מותרים.',
        'Add customer' => 'הוסף לקוח',
        'Select' => 'בחר',
        'Please enter a search term to look for customers.' => 'אנא בחרו מונח לחיפוש עבור לקוחות.',
        'Add Customer' => 'הוסף לקוח',

        # Template: AdminCustomerUser
        'Customer User Management' => 'ניהול משתמשי לקוח',
        'Back to search results' => 'חזרה לתוצאות חיפוש',
        'Add customer user' => 'הוסף משתמש לקוח',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'משתמשי לקוח נדרשים כדי שתהיה היסטוריית לקוח והתחברות דרך כניסת הלקוחות.',
        'Last Login' => 'התחברות אחרונה',
        'Login as' => 'התחבר כ',
        'Switch to customer' => 'החלף ללקוח',
        'Add Customer User' => 'הוסף משתמש לקוח',
        'Edit Customer User' => 'ערוך משתמש לקוח',
        'This field is required and needs to be a valid email address.' =>
            'שדה זה נדרש וחייב להכיל כתובת דוא"ל תקינה.',
        'This email address is not allowed due to the system configuration.' =>
            'כתובת דוא"ל זו אינה מותרת עקב הגדרות מערכת.',
        'This email address failed MX check.' => '',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => '',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'נהל יחסי קבוצת לקוח',
        'Notice' => 'הודעה',
        'This feature is disabled!' => 'יכולת זו כבויה!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'השתמשו באפשרות זו אם ברצונכם להגדיר הרשאות קבוצתיות עבור לקוחות',
        'Enable it here!' => 'אפשר זאת כאן!',
        'Edit Customer Default Groups' => 'ערוך קבוצות ברירת מחדל של לקוחות',
        'These groups are automatically assigned to all customers.' => 'קבוצות אל משוייכות אוטומטית לכל הלקוחות.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'תוכלו לנהל קבוצות אלו דרך הגדרות "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'סנן לפי קבוצות',
        'Just start typing to filter...' => '',
        'Select the customer:group permissions.' => 'בחרו את הלקוח:הרשאות קבוצה',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'אם דבר לא נבחר, אז אין הרשאות לקבוצה זו (פניות לא יהיו זמינות ללקוח).',
        'Search Results' => 'תוצאות חיפוש',
        'Customers' => 'לקוחות',
        'No matches found.' => 'לא נמצאו התאמות.',
        'Groups' => 'קבוצות',
        'Change Group Relations for Customer' => 'שנה יחסי קבוצה עבור הלקוח',
        'Change Customer Relations for Group' => 'שנה יחסי הלקוח עבור הקבוצה',
        'Toggle %s Permission for all' => 'שנה הרשאה %s עבור כולם',
        'Toggle %s permission for %s' => 'שנה הרשאה %s עבור %s',
        'Customer Default Groups:' => 'קבוצות ברירת מחדל ללקוח:',
        'No changes can be made to these groups.' => 'לא ניתן לערוך שינויים בקבוצות אלו.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'גישת קריאה בלבד לפניות בקבוצה/תור זה.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'הרשאות קריאה וכתיבה מלאות לפניות בקבוצה/תור זה.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'נהל יחסי לקוח-שירותים',
        'Edit default services' => 'ערוך שירותי ברירת מחדל',
        'Filter for Services' => 'סנן עבור שירותים',
        'Allocate Services to Customer' => 'הקצה שירותים ללקוח',
        'Allocate Customers to Service' => 'הקצה לקוחות לשירות',
        'Toggle active state for all' => 'שנה את המצב הפעיל עבור כולם',
        'Active' => 'פעיל',
        'Toggle active state for %s' => 'שנה מצב פעיל עבור %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'ניהול שדות דינמיים',
        'Add new field for object' => 'הוסף שדה חדש לאובייקט',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'רשימת שדות דינמיים',
        'Dynamic fields per page' => 'שדות דינמיים לעמוד',
        'Label' => 'תווית',
        'Order' => 'סדר',
        'Object' => 'אובייקט',
        'Delete this field' => 'מחק שדה זה',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'האם אתם באמת רוצים למחוק שדה דינמי זה? כל הנתונים המקושרים יאבדו!',
        'Delete field' => 'מחק שדה',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'שדות דינמיים',
        'Field' => 'שדה',
        'Go back to overview' => 'חזור למבט-על',
        'General' => 'כללי',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'זהו שדה נדרש, והערך צריך להיות עם תווי אותיות ומספרים בלבד.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'חייב להיות ייחודי ולקבל רק תווי אותיות ומספרים.',
        'Changing this value will require manual changes in the system.' =>
            'שינוי ערך זה ידרוש שינויים ידניים במערכת.',
        'This is the name to be shown on the screens where the field is active.' =>
            'זהו השם שיוצג במסכים בו השדה פעיל.',
        'Field order' => 'סדר השדות',
        'This field is required and must be numeric.' => 'זהו שדה נדרש והוא חייב להיות מספרי.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'זהו הסדר בו שדה זה יוצג במסכים בו הוא פעיל.',
        'Field type' => 'סוג השדה',
        'Object type' => 'סוג האובייקט',
        'Internal field' => 'שדה פנימי',
        'This field is protected and can\'t be deleted.' => 'שדה זה מוגן ולא ניתן למחקו.',
        'Field Settings' => 'הגדרות שדה',
        'Default value' => 'ערך ברירת מחדל',
        'This is the default value for this field.' => 'זהו ערך ברירת המחדל עבור שדה זה.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'ברירת מחדל להפרש תאריך',
        'This field must be numeric.' => 'שדה זה חייב להיות מספרי.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => 'הגדר תקופה בשנים',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => 'שנים בעבר',
        'Years in the past to display (default: 5 years).' => 'שנים בעבר להצגה (ברירת מחדל: 5).',
        'Years in the future' => 'שנים בעתיד',
        'Years in the future to display (default: 5 years).' => 'שנים בעתיד להצגה (ברירת מחדל: 5).',
        'Show link' => 'הצג קישור',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'ערכים אפשריים',
        'Key' => 'מפתח',
        'Value' => 'ערך',
        'Remove value' => 'הסר ערך',
        'Add value' => 'הוסף ערך',
        'Add Value' => 'הוסף ערך',
        'Add empty value' => 'הוסף ערך ריק',
        'Activate this option to create an empty selectable value.' => '',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => 'ערכים ברי תרגום',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => 'הערה',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'מספר שורות',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'קבעו את הגובה (בשורות) עבור שדה זו במצב עריכה.',
        'Number of cols' => 'מספר העמודות',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'קבעו את הרוחב (בתווים) עבור שדה זה במצב עריכה.',
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => 'הודעת שגיאה',
        'Add RegEx' => '',

        # Template: AdminEmail
        'Admin Notification' => 'התראת מנהל מערכת',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '',
        'Create Administrative Message' => 'צור הודעת מנהל מערכת',
        'Your message was sent to' => 'ההודעה שלך נשלחה אל',
        'Send message to users' => 'שלח הודעה למשתמשים',
        'Send message to group members' => 'שלח הודעה לחברי קבוצה',
        'Group members need to have permission' => '',
        'Send message to role members' => 'שלח הודעה לחברי תפקיד',
        'Also send to customers in groups' => 'שלח גם ללקוחות בקבוצה',
        'Body' => 'גוף',
        'Send' => 'שלח',

        # Template: AdminGenericAgent
        'Generic Agent' => 'סוכן גנרי',
        'Add job' => 'הוסף משימה',
        'Last run' => 'ריצה אחרונה',
        'Run Now!' => 'הפעל ריצה כעת!',
        'Delete this task' => 'מחק משימה זו',
        'Run this task' => 'הרץ משימה זו',
        'Job Settings' => 'הגדרות המשימה',
        'Job name' => 'שם המשימה',
        'The name you entered already exists.' => 'השם שהקלדתם כבר קיים.',
        'Toggle this widget' => '',
        'Automatic execution (multiple tickets)' => 'ביצוע אוטומטי (פניות מרובות)',
        'Execution Schedule' => 'תזמון הביצוע',
        'Schedule minutes' => 'דקות התזמון',
        'Schedule hours' => 'שעות התזמון',
        'Schedule days' => 'ימי התזמון',
        'Currently this generic agent job will not run automatically.' =>
            '',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '',
        'Event based execution (single ticket)' => 'ביצוע מבוסס אירוע (פניה בודדת)',
        'Event Triggers' => 'טריגרים לאירועים',
        'List of all configured events' => 'רשימת כל האירועים המוגדרים',
        'Delete this event' => 'מחק אירוע זה',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'האם אתם באמת רוצים למחוק טריגר אירוע זה?',
        'Add Event Trigger' => 'הוסף טריגר לאירוע',
        'Add Event' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'להוספת אירוע חדש בחרו את אובייקט האירוע ואת שם האירוע ולחצו על כפתור "+"',
        'Duplicate event.' => 'שכפל אירוע',
        'This event is already attached to the job, Please use a different one.' =>
            'אירוע זה כבר משויך למשימה. אנא בחרו אחד אחר.',
        'Delete this Event Trigger' => 'מחק את טריגר האירוע',
        'Remove selection' => '',
        'Select Tickets' => '',
        '(e. g. 10*5155 or 105658*)' => '(למשל 10*5144 או 105658*)',
        '(e. g. 234321)' => '(למשל 234321)',
        'Customer login' => 'התחברות לקוח',
        '(e. g. U5150)' => '(למשל U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '',
        'Agent' => 'סוכן',
        'Ticket lock' => 'נעילת פניה',
        'Create times' => 'זמני יצירה',
        'No create time settings.' => '',
        'Ticket created' => 'הפניה נוצרה',
        'Ticket created between' => 'פניה נוצרה בין',
        'Last changed times' => '',
        'No last changed time settings.' => '',
        'Ticket last changed' => '',
        'Ticket last changed between' => '',
        'Change times' => 'זמן השינוי',
        'No change time settings.' => '',
        'Ticket changed' => 'הפניה השתנתה',
        'Ticket changed between' => 'הפניה שונתה בין',
        'Close times' => 'זמן הסגירה',
        'No close time settings.' => 'אין הגדרות זמן סגירה',
        'Ticket closed' => 'הפניה נסגרה',
        'Ticket closed between' => 'הפניה נסגרה בין',
        'Pending times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'Escalation times' => 'זמני אסקלציה',
        'No escalation time settings.' => 'אין הגדרות זמני אסקלציה',
        'Ticket escalation time reached' => 'הגיע זמן אסקלציה של פניה',
        'Ticket escalation time reached between' => 'הגיע זמן אסקלציה של פניה בין',
        'Escalation - first response time' => 'אסקלציה - זמן מענה ראשוני',
        'Ticket first response time reached' => 'זמן מענה ראשוני לפניה הגיע',
        'Ticket first response time reached between' => 'זמן מענה ראשוני לפניה הגיע בין',
        'Escalation - update time' => 'אסקלציה - זמן עדכון',
        'Ticket update time reached' => 'זמן עדכון פניה הגיע',
        'Ticket update time reached between' => 'זמן עדכון פניה הגיע בין',
        'Escalation - solution time' => 'זמן אסקלציה - פתרון',
        'Ticket solution time reached' => 'פתרון הפניה הגיע',
        'Ticket solution time reached between' => 'פתרון הפניה הגיע בין',
        'Archive search option' => 'אפשרות חיפוש ארכיון',
        'Update/Add Ticket Attributes' => '',
        'Set new service' => 'קבע שירות חדש',
        'Set new Service Level Agreement' => 'קבע רמת SLA חדשה',
        'Set new priority' => 'קבע עדיפות חדשה',
        'Set new queue' => 'הגדר תור חדש',
        'Set new state' => 'הגדר מצב חדש',
        'Pending date' => 'תאריך ממתין',
        'Set new agent' => 'קבע סוכן חדש',
        'new owner' => 'בעלים חדש',
        'new responsible' => 'אחראי חדש',
        'Set new ticket lock' => 'קבע נעילת פניה חדשה',
        'New customer' => 'לקוח חדש',
        'New customer ID' => 'מספר זיהוי לקוח חדש',
        'New title' => 'כותרת חדשה',
        'New type' => 'סוג חדש',
        'New Dynamic Field Values' => 'ערכי שדות דינמיים חדשים',
        'Archive selected tickets' => 'העבר פניות שנבחרו לארכיון',
        'Add Note' => 'הוסף הודעה',
        'Time units' => 'יחידות זמן',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'שלח לסוכן/לקוח התראות על שינויים',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'מחק פניות',
        'Delete tickets' => 'מחק פניות',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '',
        'Execute Custom Module' => '',
        'Param %s key' => 'מפתח פרמטר %s',
        'Param %s value' => 'ערך פרמטר %s',
        'Save Changes' => 'שמור שינויים',
        'Results' => 'תוצאות',
        '%s Tickets affected! What do you want to do?' => '%s פניות הושפעו! מה אתם רוצים לעשות?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '',
        'Edit job' => 'ערוך עבודה',
        'Run job' => 'הרץ עבודה',
        'Affected Tickets' => 'פניות מושפעות',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'You are here' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => 'נקה',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => 'רשימת בקשות',
        'Time' => 'זמן',
        'Remote IP' => '',
        'Loading' => 'טוען...',
        'Select a single request to see its details.' => '',
        'Filter by type' => 'סנן לפי סוג',
        'Filter from' => 'סנן מ-',
        'Filter to' => 'סנן עד',
        'Filter by remote IP' => '',
        'Limit' => 'הגבל',
        'Refresh' => 'רענן',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Show or hide the content.' => 'הצג או הסתר את התוכן.',
        'Clear debug log' => '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => '',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Please provide a unique name for this web service invoker.' => '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => 'הגדר',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Asynchronous' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => 'שמור והמשך',
        'Delete this Invoker' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => 'חזור אל',
        'Mapping Simple' => 'מיפוי פשוט',
        'Default rule for unmapped keys' => '',
        'This rule will apply for all keys with no mapping rule.' => '',
        'Default rule for unmapped values' => '',
        'This rule will apply for all values with no mapping rule.' => '',
        'New key map' => '',
        'Add key mapping' => '',
        'Mapping for Key ' => '',
        'Remove key mapping' => '',
        'Key mapping' => '',
        'Map key' => '',
        'matching the' => '',
        'to new key' => '',
        'Value mapping' => '',
        'Map value' => '',
        'to new value' => '',
        'Remove value mapping' => '',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => '',
        'Delete this Key Mapping' => '',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => '',
        'Mapping XML' => '',
        'Template' => 'תבנית',
        'The entered data is not a valid XSLT stylesheet.' => '',
        'Insert XSLT stylesheet.' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => '',
        'Change operation %s' => '',
        'Do you really want to delete this operation?' => '',
        'Operation Details' => '',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => '',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => 'מאפיינים',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'אורך הודעה מירבי',
        'This field should be an integer number.' => 'שדה זה צריך להיות מספר שלם.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => '',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Host' => 'מארח',
        'Remote host URL for the REST requests.' => '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => '',
        'The default HTTP command to use for the requests.' => '',
        'Authentication' => 'אימות',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
        'The full path and name of the SSL certificate file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => '',
        'Certificate Password File' => '',
        'The full path and name of the SSL key file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Endpoint' => 'נקודת סיום',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '',
        '\'FreeText\' is used as example for actual configured value.' =>
            '',
        'Response name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => 'קידוד',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Proxy Server' => 'שרת Proxy',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => 'משתמש Proxy',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => 'סיסמת Proxy',
        'The password for the proxy user.' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'The password to open the SSL certificate.' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Sort options' => '',
        'Add new first level element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => '',
        'Clone web service' => '',
        'The name must be unique.' => '',
        'Clone' => 'שכפל',
        'Export web service' => 'ייצא Webservice',
        'Import web service' => 'ייבא Webservice',
        'Configuration File' => '',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => 'ייבא',
        'Configuration history' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => 'מערכת מרוחקת',
        'Provider transport' => '',
        'Requester transport' => '',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => '',
        'Inbound mapping' => '',
        'Outbound mapping' => '',
        'Delete this action' => '',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',
        'Delete webservice' => 'מחק Webservice',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => 'שכפל Webservice',
        'Import webservice' => 'ייבא Webservice',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => '',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'גרסה',
        'Create time' => 'זמן היצירה',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Restore' => 'שחזר',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '',
        'Group Management' => 'ניהול קבוצות',
        'Add group' => 'הוסף קבוצה',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '',
        'It\'s useful for ASP solutions. ' => '',
        'Add Group' => 'הוסף קבוצה',
        'Edit Group' => 'ערוך קבוצה',

        # Template: AdminLog
        'System Log' => '',
        'Here you will find log information about your system.' => '',
        'Hide this message' => 'הסתר הודעה זו',
        'Recent Log Entries' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => 'ניהול חשבון דוא"ל',
        'Add mail account' => 'הוסף חשבון דואר.',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            '',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            '',
        'Delete account' => 'מחק חשבון',
        'Fetch mail' => 'הבא דואר',
        'Add Mail Account' => 'הוסף חשבון דואר',
        'Example: mail.example.com' => 'למשל: mail.example.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'אמין',
        'Dispatching' => 'שליחה',
        'Edit Mail Account' => 'ערוך חשבון דואר',

        # Template: AdminNavigationBar
        'Admin' => 'ניהול',
        'Agent Management' => 'ניהול סוכנים',
        'Queue Settings' => 'הגדרות תור',
        'Ticket Settings' => 'הגדרות פניות',
        'System Administration' => 'ניהול מערכת',
        'Online Admin Manual' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '',
        'Add notification' => 'הוסף התראה',
        'Export Notifications' => '',
        'Configuration Import' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Overwrite existing notifications?' => '',
        'Upload Notification configuration' => '',
        'Import Notification configuration' => '',
        'Delete this notification' => 'מחק התראה זו',
        'Do you really want to delete this notification?' => '',
        'Add Notification' => 'הוסף התראה',
        'Edit Notification' => 'ערוך התראה',
        'Show in agent preferences' => '',
        'Agent preferences tooltip' => '',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'מסנן פניות',
        'Article Filter' => 'מסנן מאמר',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => 'סוג מאמר',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => 'סוג שולח מאמר',
        'Subject match' => 'התאמת נושא',
        'Body match' => 'התאמה לגוף',
        'Include attachments to notification' => 'כלול קבצים מצורפים בהתראות',
        'Recipients' => '',
        'Send to' => '',
        'Send to these agents' => '',
        'Send to all group members' => '',
        'Send to all role members' => '',
        'Send on out of office' => '',
        'Also send if the user is currently out of office.' => '',
        'Once per day' => '',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'Notification Methods' => '',
        'These are the possible methods that can be used to send this notification to each of the recipients. Note: Excluding Email, other methods might not reach all selected recipients, please take a look on the documentation of each merthod to get more information. Please select at least one method below.' =>
            '',
        'Transport' => '',
        'Enable this notification method' => '',
        'At least one method is needed per notification.' => '',
        'This feature is currently not available.' => '',
        'No data found' => '',
        'No notification method found.' => '',
        'Notification Text' => '',
        'Remove Notification Language' => '',
        'Message body' => '',
        'Add new notification language' => '',
        'Do you really want to delete this notification language?' => '',
        'Tag Reference' => '',
        'Notifications are sent to an agent or a customer.' => 'התראות נשלחות לסוכן או לקוח.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '',
        'Options of the recipient user for the notification' => '',

        # Template: AdminNotificationEventTransportEmailSettings
        'Recipient email addresses' => 'כתובת דוא"ל של נמענים',
        'Notification article type' => 'סוג התראת מאמר',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '',
        'Downgrade to OTRS Free' => '',
        'Read documentation' => '',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => '',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '',
        '%s not Correctly Installed' => '',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '',
        'Reinstall %s' => '',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => '',
        '%s Not Yet Available' => '',
        '%s will be available soon.' => '',
        '%s Update Available' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            '',
        '%s Correctly Deployed' => '',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '',
        'Please have a look at %s for more information.' => '',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '',
        'With your existing contract you can only use a small part of the %s.' =>
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '',
        'Go to OTRS Package Manager' => '',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'שדרג',
        'Please uninstall the packages first using the package manager and try again.' =>
            '',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => '',

        # Template: AdminPGP
        'PGP Management' => 'ניהול PGP',
        'Use this feature if you want to work with PGP keys.' => '',
        'Add PGP key' => 'הוסף מפתח PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            '',
        'Introduction to PGP' => 'מבוא ל-PGP',
        'Result' => 'תוצאה',
        'Identifier' => 'מזהה',
        'Bit' => 'Bit',
        'Fingerprint' => 'טביעת אצבע',
        'Expires' => 'פג',
        'Delete this key' => 'מחק מפתח זה',
        'Add PGP Key' => 'הוסף מפתח PGP',
        'PGP key' => 'מפתח PGP',

        # Template: AdminPackageManager
        'Package Manager' => '',
        'Uninstall package' => '',
        'Do you really want to uninstall this package?' => '',
        'Reinstall package' => '',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '',
        'Continue' => 'המשך',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'התקנה',
        'Install Package' => 'התקן חבילה',
        'Update repository information' => '',
        'Online Repository' => 'גרסה',
        'Module documentation' => 'תיעוד מודולה',
        'Upgrade' => 'שדרג',
        'Local Repository' => '',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'הסר התקנה',
        'Reinstall' => 'התקן מחדש',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Download package' => 'הורד חבילה',
        'Rebuild package' => 'בנה חבילה מחדש',
        'Metadata' => '',
        'Change Log' => '',
        'Date' => 'תאריך',
        'List of Files' => 'רשימת קבצים',
        'Permission' => 'הרשאה',
        'Download' => 'הורדה',
        'Download file from package!' => 'הורדת קובץ מהחבילה!',
        'Required' => 'נדרש',
        'PrimaryKey' => 'PrimaryKey',
        'AutoIncrement' => 'AutoIncrement',
        'SQL' => 'SQL',
        'File differences for file %s' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performance Log',
        'This feature is enabled!' => 'יכולת זו מאופשרת!',
        'Just use this feature if you want to log each request.' => '',
        'Activating this feature might affect your system performance!' =>
            '',
        'Disable it here!' => 'נטרל זאת כאן!',
        'Logfile too large!' => 'קובץ לוג גדול מדי!',
        'The logfile is too large, you need to reset it' => '',
        'Overview' => 'מבט-על',
        'Range' => 'טווח',
        'last' => 'אחרון',
        'Interface' => 'ממשק',
        'Requests' => 'בקשות',
        'Min Response' => 'מענה מינימלי',
        'Max Response' => 'מענה מירבי',
        'Average Response' => 'מענה ממוצע',
        'Period' => 'תקופה',
        'Min' => 'מינ',
        'Max' => 'מקס',
        'Average' => 'ממוצע',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'ניהול מסנן PostMaster',
        'Add filter' => 'הוסף מסנן',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '',
        'Delete this filter' => 'מחק מסנן זה',
        'Add PostMaster Filter' => 'הוסף מסנן PostMaster',
        'Edit PostMaster Filter' => 'ערוך מסנן PostMaster',
        'The name is required.' => 'השם הוא נדרש.',
        'Filter Condition' => 'תנאי מסנן',
        'AND Condition' => 'תנאי וגם',
        'Check email header' => '',
        'Negate' => 'היפוך',
        'Look for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => '',
        'Set email header' => '',
        'Set value' => '',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'ניהול עדיפיות',
        'Add priority' => 'הוסף עדיפות',
        'Add Priority' => 'הוסף עדיפות',
        'Edit Priority' => 'ערוך עדיפות',

        # Template: AdminProcessManagement
        'Process Management' => 'ניהול תהליכים',
        'Filter for Processes' => 'סנן עבור תהליך',
        'Create New Process' => 'צור תהליך חדש',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Overwrite existing entities' => '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'Example processes' => '',
        'Here you can activate best practice example processes that are part of %s. Please note that some additional configuration may be required.' =>
            '',
        'Import example process' => '',
        'Do you want to benefit from processes created by experts? Upgrade to %s to be able to import some sophisticated example processes.' =>
            '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => 'תהליכים',
        'Process name' => 'שם התהליך',
        'Print' => 'הדפס',
        'Export Process Configuration' => 'ייצא הגדרות תהליך',
        'Copy Process' => 'העתק תהליך',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
        'Go Back' => 'חזור',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => 'פעילות',
        'Activity Name' => 'שם הפעילות',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => 'זמין ב',
        'Description (short)' => 'תיאור (קצר)',
        'Description (long)' => 'תיאור (ארוך)',
        'The selected permission does not exist.' => 'ההרשאה שנבחרה אינה קיימת.',
        'Required Lock' => 'נעילה נדרשת',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => 'טקסט העזרה לשליחה',
        'Submit Button Text' => 'טקסט כפתור שליחה',
        'Fields' => 'שדות',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => 'שדות זמינים למסננים',
        'Available Fields' => 'שדות זמינים',
        'Assigned Fields' => 'שדות משוייכים',
        'Edit Details for Field' => 'ערוך פרטים לשדה',
        'ArticleType' => 'סוג מאמר',
        'Display' => 'הצג',
        'Edit Field Details' => 'ערוך פרטי שדה',
        'Customer interface does not support internal article types.' => '',

        # Template: AdminProcessManagementPath
        'Path' => 'נתיב',
        'Edit this transition' => '',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'פעילויות',
        'Filter Activities...' => 'מסנן פעילויות...',
        'Create New Activity' => 'צור פעילות חדשה',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'ערוך תהליך',
        'Print process information' => 'הדפס פרטי תהליך',
        'Delete Process' => 'מחק תהליך',
        'Delete Inactive Process' => 'מחק תהליך לא פעיל',
        'Available Process Elements' => 'פריטי תהליך זמינים',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => 'ערוך מידע תהליך',
        'Process Name' => 'שם התהליך',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => 'ערוך פעילות זו',
        'Save settings' => 'שמור הגדרות',
        'Save Activities, Activity Dialogs and Transitions' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => '',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Remove the Transition from this Process' => '',
        'No TransitionActions assigned.' => '',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'התחל פעילות',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => 'תנאים',
        'Condition' => 'תנאי',
        'Transitions are not being used in this process.' => '',
        'Module name' => 'שם המודולה',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => 'הסר תנאי זה',
        'Type of Linking' => 'סוג הקישור',
        'Remove this Field' => 'הסר שדה זה',
        'And can\'t be repeated on the same condition.' => '',
        'Add a new Field' => 'הוסף שדה חדש',
        'Add New Condition' => 'הוסף תנאי חדש',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Remove this Parameter' => 'הסר פרמטר זה',
        'Add a new Parameter' => 'הוסף פרמטר חדש',

        # Template: AdminQueue
        'Manage Queues' => 'נהל תורות',
        'Add queue' => 'הוסף תור',
        'Add Queue' => 'הוסף תור',
        'Edit Queue' => 'ערוך תור',
        'A queue with this name already exists!' => '',
        'Sub-queue of' => 'תור משנה של',
        'Unlock timeout' => '0 = אין שחרור נעילה',
        '0 = no unlock' => '0 = אין שחרור נעילה',
        'Only business hours are counted.' => '',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '',
        'Notify by' => 'התראה על ידי',
        '0 = no escalation' => '0 = ללא אסקלציה',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '',
        'Follow up Option' => 'אפשרות מעקב',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '',
        'Ticket lock after a follow up' => 'נעילת פניה לאחר מעקב',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '',
        'System address' => 'כתובת מערכת',
        'Will be the sender address of this queue for email answers.' => '',
        'Default sign key' => '',
        'The salutation for email answers.' => '',
        'The signature for email answers.' => 'חתימה עבור מענים בדוא"ל',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'נהל יחסי תור-מענה אוטומטי',
        'Filter for Queues' => 'סנן עבור תורות',
        'Filter for Auto Responses' => 'סנן עבור מענים אוטמטיים',
        'Auto Responses' => 'מענים אוטומטיים',
        'Change Auto Response Relations for Queue' => 'שנה יחסי מענה אוטומטי עבור תור',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'נהל יחסי תבנית-תור',
        'Filter for Templates' => 'סנן עבור תבניות',
        'Templates' => 'תבניות',
        'Change Queue Relations for Template' => 'שנה יחסי תור לתבנית',
        'Change Template Relations for Queue' => 'שנה יחסי תבנית לתור',

        # Template: AdminRegistration
        'System Registration Management' => 'ניהול רישום מערכת',
        'Edit details' => 'ערוך פרטים',
        'Show transmitted data' => '',
        'Deregister system' => 'בטל רישום מערכת',
        'Overview of registered systems' => 'מבט-על של מערכות רשומות',
        'This system is registered with OTRS Group.' => 'מערכת זו רשומה עם קבוצת OTRS.',
        'System type' => 'סוג מערכת',
        'Unique ID' => 'Unique ID',
        'Last communication with registration server' => 'תקשורת אחרונה עם שרת הרישום',
        'System registration not possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '',
        'Instructions' => '',
        'System deregistration not possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => 'OTRS-ID Login',
        'Read more' => 'קרא עוד',
        'You need to log in with your OTRS-ID to register your system.' =>
            '',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            '',
        'Data Protection' => '',
        'What are the advantages of system registration?' => 'מהם היתרונות של רישום מערכת?',
        'You will receive updates about relevant security releases.' => 'תקבלו עדכונים על תיקוני אבטחת מידע רלוונטיים.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => 'זוהי רק ההתחלה!',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTRS without being registered?' => 'האם אפשר להשתמש ב- OTRS בלי להירשם',
        'System registration is optional.' => 'רישום מערכת הוא אופציונלי',
        'You can download and use OTRS without being registered.' => '',
        'Is it possible to deregister?' => 'האם אפשר לבטל רישום?',
        'You can deregister at any time.' => 'ניתן לבטל רישום בכל זמן.',
        'Which data is transfered when registering?' => 'איזה מידע מועבר בעת הרישום?',
        'A registered system sends the following data to OTRS Group:' => 'רישום מערכת שולח את המידע הבא לקבוצת OTRS:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'ד',
        'Why do I have to provide a description for my system?' => '',
        'The description of the system is optional.' => 'תיאור המערכת הוא אופצינולי.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '',
        'How often does my OTRS system send updates?' => 'כל כמה זמן נשלחים עדכונים למערכת OTRS?',
        'Your system will send updates to the registration server at regular intervals.' =>
            '',
        'Typically this would be around once every three days.' => 'בדרך כלל זה מתרחש אחת לשלושה ימים',
        'In case you would have further questions we would be glad to answer them.' =>
            '',
        'Please visit our' => 'אנא בקרו את',
        'portal' => 'הפורטל שלנו,',
        'and file a request.' => 'והגישו בקשה.',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => '',
        'Sign up now' => 'הירשמו עכשיו',
        'Forgot your password?' => 'שכחתם סיסמא?',
        'Retrieve a new one' => 'קבלו חדשה',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '',
        'Attribute' => 'מאפיין',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'גרסת OTRS',
        'Operating System' => 'מערכת הפעלה',
        'Perl Version' => 'גרסת Perl',
        'Optional description of this system.' => 'תיאור אופציונלי של מערכת זו.',
        'Register' => 'רישום',
        'Deregister System' => 'ביטול רישום מערכת',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => 'בטל רישום',
        'You can modify registration settings here.' => '',
        'Overview of transmitted data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

        # Template: AdminRole
        'Role Management' => 'ניהול תפקידים',
        'Add role' => 'הוסף תפקיד',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '',
        'Add Role' => 'הוסף תפקיד',
        'Edit Role' => 'ערוך תפקיד',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'נהל יחסי תפקיד-קבוצה',
        'Filter for Roles' => 'סנן עבור תפקידים',
        'Roles' => 'תפקידים',
        'Select the role:group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '',
        'Change Role Relations for Group' => 'שנה יחסי תפקיד לקבוצה',
        'Change Group Relations for Role' => 'שנה יחסי קבוצה לתפקיד',
        'Toggle %s permission for all' => 'שנה הרשאת %s לכולם',
        'move_into' => 'העבר אל',
        'Permissions to move tickets into this group/queue.' => '',
        'create' => 'צור',
        'Permissions to create tickets in this group/queue.' => '',
        'note' => 'הערה',
        'Permissions to add notes to tickets in this group/queue.' => 'הרשאות להוספת הערות לפניות בקבוצה/תור זה.',
        'owner' => 'בעלים',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'הרשאות לשינוי בעלי הפניות בקבוצה/תור זה',
        'priority' => 'עדיפות',
        'Permissions to change the ticket priority in this group/queue.' =>
            '',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'נהל יחסי סוכן-תפקיד',
        'Add agent' => 'הוסף סוכן',
        'Filter for Agents' => 'סנן עבור סוכנים',
        'Agents' => 'סוכנים',
        'Manage Role-Agent Relations' => 'נהל יחסי תפקיד-סוכן',
        'Change Role Relations for Agent' => 'שנה יחסי תפקיד לסוכן',
        'Change Agent Relations for Role' => 'שנה יחסי סוכן לתפקיד',

        # Template: AdminSLA
        'SLA Management' => 'ניהול SLA',
        'Add SLA' => 'הוסף SLA',
        'Edit SLA' => 'ערוך SLA',
        'Please write only numbers!' => 'נא להקליד מספרים בלבד!',

        # Template: AdminSMIME
        'S/MIME Management' => 'נהיול S/MIME',
        'Add certificate' => '',
        'Add private key' => 'הוסף מפתח פרטי',
        'Filter for certificates' => '',
        'Filter for S/MIME certs' => '',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'ראו גם',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '',
        'Hash' => 'Hash',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => '',
        'Add Certificate' => '',
        'Add Private Key' => '',
        'Secret' => '',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'Certificate details' => '',

        # Template: AdminSalutation
        'Salutation Management' => '',
        'Add salutation' => '',
        'Add Salutation' => '',
        'Edit Salutation' => '',
        'e. g.' => 'למשל',
        'Example salutation' => '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Sicherheitsmodus muss eingeschaltet sein!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            '',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            '',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '',
        'Result format' => '',
        'Run Query' => '',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => 'ניהול שירותים',
        'Add service' => 'הוסף שירות',
        'Add Service' => 'הוסף שירות',
        'Edit Service' => 'ערוך שירות',
        'Sub-service of' => 'שירות-משנה של',

        # Template: AdminSession
        'Session Management' => '',
        'All sessions' => '',
        'Agent sessions' => '',
        'Customer sessions' => '',
        'Unique agents' => '',
        'Unique customers' => 'לקוחות ייחודיים',
        'Kill all sessions' => '',
        'Kill this session' => '',
        'Session' => 'Session',
        'Kill' => '',
        'Detail View for SessionID' => 'פרטים',

        # Template: AdminSignature
        'Signature Management' => 'ניהול חתימות',
        'Add signature' => 'הוסף חתימה',
        'Add Signature' => 'הוסף חתימה',
        'Edit Signature' => 'ערוך חתימה',
        'Example signature' => 'חתימה לדוגמא',

        # Template: AdminState
        'State Management' => 'ניהול מצבים',
        'Add state' => 'הוסף מצב',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'הוסף מצב',
        'Edit State' => 'ערוך מצב',
        'State type' => 'סוג מצב',

        # Template: AdminSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Currently this data is only shown in this system.' => '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',
        'The support bundle has been generated.' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => 'שולח',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => 'פרטים',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => '',
        'Navigate by selecting config groups' => '',
        'Download all system config changes' => '',
        'Export settings' => 'ייצא הגדרות',
        'Load SysConfig settings from file' => '',
        'Import settings' => 'ייבא הגדרות',
        'Import Settings' => 'ייבא הגדרות',
        'Please enter a search term to look for settings.' => '',
        'Subgroup' => 'תת קבוצה',
        'Elements' => 'פריט',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => '',
        'This setting is read only.' => '',
        'This config item is only available in a higher config level!' =>
            '',
        'Reset this setting' => 'אפס הגדרה זו',
        'Error: this file could not be found.' => '',
        'Error: this directory could not be found.' => '',
        'Error: an invalid value was entered.' => '',
        'Content' => 'תוכן',
        'Remove this entry' => 'הסר רשומה זו',
        'Add entry' => 'הוסף רשומה',
        'Remove entry' => 'הסר רשומה',
        'Add new entry' => 'הוסך רשומה חדשה',
        'Delete this entry' => 'מחק רשומה זו',
        'Create new entry' => 'צור רשומה חדשה',
        'New group' => 'קבוצה חדשה',
        'Group ro' => 'ro של קבוצה',
        'Readonly group' => 'קבוצה לקריאה בלבד',
        'New group ro' => 'ro חדש לקבוצה',
        'Loader' => '',
        'File to load for this frontend module' => '',
        'New Loader File' => '',
        'NavBarName' => 'תפריט ניווט חדש',
        'NavBar' => 'תפריט ניווט',
        'LinkOption' => 'LinkOption',
        'Block' => 'Block',
        'AccessKey' => 'AccessKey',
        'Add NavBar entry' => '',
        'Year' => 'שנה',
        'Month' => 'חודש',
        'Day' => 'יום',
        'Invalid year' => '',
        'Invalid month' => '',
        'Invalid day' => '',
        'Show more' => 'הצג עוד',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'ניהול כתובת דוא"ל מערכת',
        'Add system address' => 'הוסף כתובת מערכת',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '',
        'Email address' => 'כתובת דוא"ל',
        'Display name' => 'שם תצוגה',
        'Add System Email Address' => 'הוסף כתובת דוא"ל מערכת',
        'Edit System Email Address' => 'ערוך כתובת דוא"ל מערכת',
        'The display name and email address will be shown on mail you send.' =>
            'שם התצוגה והדוא"ל יוצגו בהודעה שתשלחו',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '',
        'Schedule New System Maintenance' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Start date' => '',
        'Stop date' => '',
        'Delete System Maintenance' => '',
        'Do you really want to delete this scheduled system maintenance?' =>
            '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => '',
        'Edit System Maintenance information' => '',
        'Date invalid!' => 'תאריך לא תקף!',
        'Login message' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Manage Templates' => 'נהל תבניות',
        'Add template' => 'הוסף תבנית',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => 'אל תשכחו להוסיף תבניות חדשות לתורות.',
        'Add Template' => 'הוסף תבנית',
        'Edit Template' => 'ערוך תבנית',
        'A standard template with this name already exists!' => '',
        'Create type templates only supports this smart tags' => 'צור סוג תבניות שתומכות רק בתגית חכמה זו',
        'Example template' => 'תבנית לדוגמא',
        'The current ticket state is' => 'מצב הפניה הנוכחי הוא',
        'Your email address is' => 'כתובת הדוא"ל שלך היא',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'נהל יחסי תבניות <-> קבצים מצורפים',
        'Filter for Attachments' => 'מסנן עבור קבצים מצורפים',
        'Change Template Relations for Attachment' => 'שנה יחסי תבנית לקובץ מצורף',
        'Change Attachment Relations for Template' => 'שנה יחסי קובץ מצורף לתבנית',
        'Toggle active for all' => 'הפוך לפעיל עבור כולם',
        'Link %s to selected %s' => 'קשר %s ל-%s שנבחרו',

        # Template: AdminType
        'Type Management' => 'ניהול סוגים',
        'Add ticket type' => 'הוסף סוג פניה',
        'Add Type' => 'הוסף סוג',
        'Edit Type' => 'ערוך סוג',
        'A type with this name already exists!' => '',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'יש ליצור סוכנים על מנת לטפל לפניות.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'אל תשכחו להוסיף סוכן חדש לקבוצות ו/או תפקידים!',
        'Please enter a search term to look for agents.' => 'אנא הקלידו את המונח לחיפוש עבור סוכנים',
        'Last login' => 'התחברות אחרונה',
        'Switch to agent' => 'החלף לסוכן',
        'Add Agent' => 'הוסף סוכן',
        'Edit Agent' => 'ערוך סוכן',
        'Firstname' => 'שם פרטי',
        'Lastname' => 'שם משפחה',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => 'תיווצר אוטומטית אם השדה ריק.',
        'Start' => 'התחל',
        'End' => 'סיים',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'נהל יחסי סוכן-קבוצה',
        'Change Group Relations for Agent' => 'שנה יחסי קבוצה לסוכן',
        'Change Agent Relations for Group' => 'שנה יחסי סוכן לקבוצה',

        # Template: AgentBook
        'Address Book' => '',
        'Search for a customer' => '',
        'Add email address %s to the To field' => 'הוסף כתובת דוא"ל %s לשדה To',
        'Add email address %s to the Cc field' => 'הוסף כתובת דוא"ל %s לשדה CC',
        'Add email address %s to the Bcc field' => 'הוסף כתובת דוא"ל %s לשדה BCC',
        'Apply' => 'החל',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'מרכז מידע ללקוח',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'משתמש לקוח',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'רשומה כפולה',
        'This address already exists on the address list.' => 'כתובת זו כבר קיימת ברשימת הכתובות',
        'It is going to be deleted from the field, please try again.' => 'זה יימחק מהשדה, אנא נסו שנית.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'שימו לב: הלקוח לא תקין!',

        # Template: AgentDaemonInfo
        'General Information' => '',
        'OTRS Daemon is a separated process that perform asynchronous tasks' =>
            '',
        '(e.g. Generic Interface asynchronous invoker tasks, Ticket escalation triggering, Email sending, etc.)' =>
            '',
        'It is necessary to have the OTRS Daemon running to make the system work correctly!' =>
            '',
        'Starting OTRS Daemon' => '',
        'Make sure that %s exists (without .dist extension)' => '',
        'Check that cron deamon is running in the system' => '',
        'Confirm that OTRS cron jobs are running, execute %s start' => '',

        # Template: AgentDashboard
        'Dashboard' => 'לוח בקרה',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardCommon
        'Available Columns' => 'עמודות זמינות',
        'Visible Columns (order by drag & drop)' => 'עמודות נראות (סדר בגרירה של העמודות)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'פניות באסקלציה',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'פרטי לקוח',
        'Phone ticket' => 'פניה בטלפון',
        'Email ticket' => 'פניה בדוא"ל',
        'Start Chat' => '',
        '%s open ticket(s) of %s' => '%s פניות פתוחות מתוך %s',
        '%s closed ticket(s) of %s' => '%s פניות סגורות מתוך %s',
        'New phone ticket from %s' => 'פניות טלפון חדשות מ-%s',
        'New email ticket to %s' => 'פניות דוא"ל חדשות מ-%s',
        'Start chat' => '',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s זמין!',
        'Please update now.' => 'אנא עדכנו כעת.',
        'Release Note' => 'פרטי גרסה',
        'Level' => 'רמה',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'נכתב לפני %s.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '',
        'Download as SVG file' => '',
        'Download as PNG file' => '',
        'Download as CSV file' => '',
        'Download as Excel file' => '',
        'Download as PDF file' => '',
        'Grouped' => '',
        'Stacked' => '',
        'Expanded' => '',
        'Stream' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'הפניות הנעולות שלי',
        'My watched tickets' => 'הפניות במעקב שלי',
        'My responsibilities' => 'באחריות שלי',
        'Tickets in My Queues' => 'פניות בתורים שלי',
        'Tickets in My Services' => '',
        'Service Time' => 'זמן השירוץ',
        'Remove active filters for this widget.' => 'הסר מסננים פעילים לחלונית זו.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'סה"כ',

        # Template: AgentDashboardUserOnline
        'out of office' => 'מחוץ למשרד',
        'Selected agent is not available for chat' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'עד',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => '',
        'Undo & close' => '',

        # Template: AgentInfo
        'Info' => 'מידע',
        'To accept some news, a license or some changes.' => '',

        # Template: AgentLinkObject
        'Link Object: %s' => 'קשר אובייקט ל: %s',
        'go to link delete screen' => 'עבור למסך מחיקת קישור',
        'Select Target Object' => 'בחר אובייקט מטרה',
        'Link Object' => 'קשר אובייקט',
        'with' => 'עפ',
        'Unlink Object: %s' => 'בטל קישור אובייקט: %s',
        'go to link add screen' => 'עבור למסך הוספת קישור',

        # Template: AgentPreferences
        'Edit your preferences' => 'ערכו את ההעדפות שלכם',
        'Did you know? You can help translating OTRS at %s.' => '',

        # Template: AgentSpelling
        'Spell Checker' => 'בודק איות',
        'spelling error(s)' => 'שגיאות איות',
        'Apply these changes' => 'החל שינויים אלו',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => '',
        'Add New Statistic' => '',
        'Dynamic Matrix' => '',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            '',
        'Dynamic List' => '',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            '',
        'Static' => '',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            '',
        'General Specification' => '',
        'Create Statistic' => '',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => '',
        'Run now' => '',
        'Statistics Preview' => '',
        'Save statistic' => '',

        # Template: AgentStatisticsImport
        'Statistics » Import' => '',
        'Import Statistic Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => '',
        'Statistics' => 'סטטיסטיקה',
        'Run' => '',
        'Edit statistic "%s".' => '',
        'Export statistic "%s"' => '',
        'Export statistic %s' => '',
        'Delete statistic "%s"' => '',
        'Delete statistic %s' => '',
        'Do you really want to delete this statistic?' => '',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => '',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s' => '',
        'Change Owner of %s%s' => '',
        'Close %s%s' => '',
        'Add Note to %s%s' => '',
        'Set Pending Time for %s%s' => '',
        'Change Priority of %s%s' => '',
        'Change Responsible of %s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => 'כל השדות המסומנים עם כוכבית (*) הם שדות חובה.',
        'Service invalid.' => 'שירות לא חוקי.',
        'New Owner' => 'בעלים חדש',
        'Please set a new owner!' => 'אנא בחרו בעלים חדש',
        'New Responsible' => '',
        'Next state' => 'מצב חדש',
        'For all pending* states.' => '',
        'Add Article' => '',
        'Create an Article' => '',
        'Spell check' => 'בדיקתת איות',
        'Text Template' => 'תבנית טקסט',
        'Setting a template will overwrite any text or attachment.' => '',
        'Note type' => 'סוג ההערה',
        'Inform Agent' => 'יידע סוכן',
        'Optional' => 'אופציונלי',
        'Inform involved Agents' => 'יידע סוכנים מעורבים',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Note will be (also) received by:' => '',

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'העבר פניה',
        'Bounce to' => 'העבר אל',
        'You need a email address.' => 'Sie benötigen eine E-Mail-Adresse',
        'Need a valid email address or don\'t use a local email address.' =>
            'Benötige eine gültige E-Mail-Adresse, verwenden Sie keine lokale Adresse.',
        'Next ticket state' => 'מצב הפניה הבא',
        'Inform sender' => 'יידע את השולח',
        'Send mail' => 'שלח דו"אל',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'פעולות גורפות על פניות',
        'Send Email' => 'שלח דוא"ל',
        'Merge to' => 'מזג אל',
        'Invalid ticket identifier!' => '',
        'Merge to oldest' => 'מזג לישן ביותר',
        'Link together' => 'קשר יחד',
        'Link to parent' => 'קשר לפריט אב',
        'Unlock tickets' => 'שחחר נעילות פניות',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s' => '',
        'Please include at least one recipient' => 'נא לכלול לפחות נמען אחד',
        'Remove Ticket Customer' => 'הסר לקוח של פניה',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Remove Cc' => 'הסר Cc',
        'Remove Bcc' => 'הסר Bcc',
        'Address book' => 'פנקס כתובות',
        'Date Invalid!' => 'תאריך לא תקין!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s' => '',
        'Customer user' => 'משתמש הלקוח',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'צור פניית דוא"ל חדשה',
        'Example Template' => '',
        'From queue' => 'מהתור',
        'To customer user' => 'למשתמש לקוח',
        'Please include at least one customer user for the ticket.' => 'נא לכלול לפחות משתמש לקוח אחד עבור הפניה',
        'Select this customer as the main customer.' => 'בחר לקוח זה כלקוח העיקרי.',
        'Remove Ticket Customer User' => 'הסר משתמש לקוח מהפניה',
        'Get all' => 'קבל הכל',
        'Do you really want to continue?' => '',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s' => '',
        'History Content' => 'תוכן ההיסטוריה',
        'Zoom view' => 'מבט זום',

        # Template: AgentTicketMerge
        'Merge %s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => 'עליך להשתמש במספר פניה!',
        'A valid ticket number is required.' => 'Eine gültige Ticketnummer ist erforderlich.',
        'Need a valid email address.' => 'Benötige gültige E-Mail-Adresse.',

        # Template: AgentTicketMove
        'Move %s%s' => '',
        'New Queue' => 'תור חדש',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'בחר הכל',
        'No ticket data found.' => 'לא נמצאו נתוני פניה.',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => '',
        'First Response Time' => 'זמן המענה הראשוני',
        'Update Time' => 'זמן העדכון',
        'Solution Time' => 'זמן הפתרון',
        'Move ticket to a different queue' => 'העבר פניה לתור אחר',
        'Change queue' => 'שנה תור',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'שנה אפשרויות חיפוש',
        'Remove active filters for this screen.' => 'הסר מסננים פעילים במסך זה.',
        'Tickets per page' => 'פניות בעמוד',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'אפס מבט-על',
        'Column Filters Form' => 'טופס סינון עמודות',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'צור פניית טלפון חדשה',
        'Please include at least one customer for the ticket.' => 'נא לכלול לפחות לקוח אחד לפניה.',
        'To queue' => 'לתור',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s' => '',
        'Plain' => 'לא מעוצב',
        'Download this email' => 'הורד דוא"ל זה',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'צור פניית תהליך חדשה',
        'Process' => 'תהליך',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Search template' => 'חפש תבנית',
        'Create Template' => 'צור תבנית',
        'Create New' => 'צור חדשה',
        'Profile link' => 'קישור לפרופיל',
        'Save changes in template' => 'שמור שינויים בתבנית',
        'Filters in use' => '',
        'Additional filters' => '',
        'Add another attribute' => 'הוסף מאפיין נוסף',
        'Output' => 'פלט',
        'Fulltext' => 'טקסט מלא',
        'Remove' => 'הסר',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'חיפושים במאפיינים של שדות מאת, אל, העתק, ובגוף המאמר, הגוברים על מאפיינים אחרים באותו שם.',
        'Customer User Login' => 'התחברות משתמש לקוח',
        'Attachment Name' => '',
        '(e. g. m*file or myfi*)' => '',
        'Created in Queue' => 'נוצר בתור',
        'Lock state' => 'נעל מצב',
        'Watcher' => 'צופה',
        'Article Create Time (before/after)' => 'זמן יצירת מאמר (לפני/אחרי)',
        'Article Create Time (between)' => 'זמן יצירת מאמר (בין)',
        'Ticket Create Time (before/after)' => 'זמן יצירת פניה (לפני/אחרי)',
        'Ticket Create Time (between)' => 'זמן יצירת פניה (בין)',
        'Ticket Change Time (before/after)' => 'זמן שינוי פניה (לפני/אחרי)',
        'Ticket Change Time (between)' => 'זמן שינוי פניה (בין)',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Close Time (before/after)' => 'זמן סגירת פניה (לפני/אחרי)',
        'Ticket Close Time (between)' => 'זמן סגירת פניה (בין)',
        'Ticket Escalation Time (before/after)' => 'זמן אסקלציית פניה (לפני/אחרי)',
        'Ticket Escalation Time (between)' => 'זמן אסקלציית פניה (בין)',
        'Archive Search' => 'העבר חיפוש לארכיון',
        'Run search' => 'הרץ חיפוש',

        # Template: AgentTicketZoom
        'Article filter' => 'מסנן מאמרים',
        'Article Type' => 'סוג מאמר',
        'Sender Type' => 'סוג שולח',
        'Save filter settings as default' => 'שמור הגדרות מסנן כברירת מחדל',
        'Event Type Filter' => '',
        'Event Type' => '',
        'Save as default' => '',
        'Archive' => 'ארכיון',
        'This ticket is archived.' => 'פניה זו היא בארכיון.',
        'Locked' => 'נעולה',
        'Accounted time' => 'זמן שחושב',
        'Linked Objects' => 'פריטים מקושרים',
        'Change Queue' => 'שנה תור',
        'There are no dialogs available at this point in the process.' =>
            'אין תיבות שיח זמינות בשלב זה של התהליך.',
        'This item has no articles yet.' => 'לפריט זה עדיין אין מאמרים',
        'Ticket Timeline View' => '',
        'Article Overview' => '',
        'Article(s)' => 'מאמר(ים)',
        'Page' => 'עמוד',
        'Add Filter' => 'הוסף מסנן',
        'Set' => 'הגדר',
        'Reset Filter' => 'אפס מסנן',
        'Show one article' => 'הצג מאמר אחד',
        'Show all articles' => 'הצג את כל המאמרים',
        'Show Ticket Timeline View' => '',
        'Unread articles' => 'מאמרים שלא נקראו',
        'No.' => 'מס.',
        'Important' => 'חשוב',
        'Unread Article!' => 'מאמר שלא נקרא!',
        'Incoming message' => 'הודעה נכנסת',
        'Outgoing message' => 'הודעה יוצאת',
        'Internal message' => 'הודעה פנימית',
        'Resize' => 'שנה גודל',
        'Mark this article as read' => '',
        'Show Full Text' => '',
        'Full Article Text' => '',
        'No more events found. Please try changing the filter settings.' =>
            '',
        'by' => 'על ידי ',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'על מנת להגן על הפרטיות שלך, נחסם תוכן חיצוני.',
        'Load blocked content.' => 'טען תוכן חסום.',

        # Template: ChatStartForm
        'First message' => '',

        # Template: CustomerError
        'Traceback' => 'Traceback',

        # Template: CustomerFooter
        'Powered by' => 'מבוסס על',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'התרחשו שגיאה אחת או יותר!',
        'Close this dialog' => 'סגור תיבת שיח זו',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'לא ניתן לפתוח חלון קופץ. אנא נטרלו חוסמי חלונות קופצים עבור יישום זה.',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '',
        'There are currently no elements available to select from.' => 'אין כעת פריטים זמינים שניתן לבחור.',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'The browser you are using is too old.' => 'הדפדפן שלכם ישן מדי.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'מערכת זו מופעלת על מגוון רחב של דפדפנים, אנא שדרגו לאחד מהם.',
        'Please see the documentation or ask your admin for further information.' =>
            'אנא צפו בתיעוד או בקשו מידע נוסף ממנהל המערכת.',
        'Switch to mobile mode' => '',
        'Switch to desktop mode' => '',
        'Not available' => '',
        'Clear all' => '',
        'Clear search' => '',
        '%s selection(s)...' => '',
        'and %s more...' => '',
        'Filters' => '',
        'Confirm' => '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript לא זמין.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'על מנת להפעיל את המערכת, עליכם לאפשר JavaScript בדפדפן.',
        'Browser Warning' => 'אזהרת דפדפן',
        'One moment please, you are being redirected...' => '',
        'Login' => 'התחבר',
        'User name' => 'שם משתמש',
        'Your user name' => 'שם המשתמש שלך',
        'Your password' => 'הסיסמא שלך',
        'Forgot password?' => 'שכחת סיסמא?',
        '2 Factor Token' => '',
        'Your 2 Factor Token' => '',
        'Log In' => 'התחבר',
        'Not yet registered?' => 'עדיין לא נרשמת?',
        'Request new password' => 'בקש סיסמא חדשה',
        'Your User Name' => 'שם המשתמש שלך',
        'A new password will be sent to your email address.' => 'סיסמא חדשה תישלח לכובת הדוא"ל שלך.',
        'Create Account' => 'צור חשבון',
        'Please fill out this form to receive login credentials.' => 'אנא מלאו את הטופס על מנת לקבל פרטי התחברות.',
        'How we should address you' => 'כיצד עלינו לפנות אליכם?',
        'Your First Name' => 'השם הפרטי שלך',
        'Your Last Name' => 'שם המשפחה שלך',
        'Your email address (this will become your username)' => 'כתובת הדוא"ל שלך (זה יהיה שם המשתמש שלך)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '',
        'You have unanswered chat requests' => '',
        'Edit personal preferences' => 'עריכת העדפות אישיות',
        'Logout %s %s' => '',

        # Template: CustomerRichTextEditor
        'Split Quote' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'הסכם רמת שירות SLA',

        # Template: CustomerTicketOverview
        'Welcome!' => 'ברוכים הבאים!',
        'Please click the button below to create your first ticket.' => 'נא ללחוץ על הכפתור למטה על מנת ליצור את הפניה הראשונה שלכם.',
        'Create your first ticket' => 'צרו את הפניה הראשונה שלכם',

        # Template: CustomerTicketSearch
        'Profile' => 'פרופיל',
        'e. g. 10*5155 or 105658*' => 'למשל 10*5155 או 105658*',
        'Customer ID' => 'מספר זיהוי לקוח',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'חיפוש טקסט מלא בפניות (למשל "ממשק*" או "מס*ים")',
        'Recipient' => 'נמען',
        'Carbon Copy' => 'העתק',
        'e. g. m*file or myfi*' => '',
        'Types' => 'סוגים',
        'Time restrictions' => 'הגבלות זמן',
        'No time settings' => 'Keine Zeiteinstellungen',
        'Only tickets created' => 'רק פניות שנוצרו',
        'Only tickets created between' => 'רק פניות שנוצרו בין',
        'Ticket archive system' => 'מערכת ארכיון פניות',
        'Save search as template?' => 'שמור חיפוש זה כתבנית?',
        'Save as Template?' => 'שמור כתבנית?',
        'Save as Template' => 'שמור כתבנית',
        'Template Name' => 'שם התבנית',
        'Pick a profile name' => 'בחר שם פרופיל',
        'Output to' => 'פלט אל',

        # Template: CustomerTicketSearchResultShort
        'of' => 'מתוך',
        'Search Results for' => 'חפש תוצאות עבור',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '',
        'Expand article' => 'הרחב מאמר',
        'Information' => 'מידע',
        'Next Steps' => 'השלבים הבאים',
        'Reply' => 'השב',
        'Chat Protocol' => '',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'יום שלם',
        'Sunday' => 'ראשון',
        'Monday' => 'שני',
        'Tuesday' => 'שלישי',
        'Wednesday' => 'רביעי',
        'Thursday' => 'חמישי',
        'Friday' => 'שישי',
        'Saturday' => 'שבת',
        'Su' => 'א',
        'Mo' => 'ב',
        'Tu' => 'ג',
        'We' => 'ד',
        'Th' => 'ה',
        'Fr' => 'ו',
        'Sa' => 'ש',
        'Event Information' => 'פרטי האירוע',
        'Ticket fields' => 'שדות הפניה',
        'Dynamic fields' => 'שדות דינמיים',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'תאריך לא תקין (חייב להיות עתידי)!',
        'Invalid date (need a past date)!' => '',
        'Previous' => 'קודם',
        'Open date selection' => 'פתח בחירת תאריך',

        # Template: Error
        'Oops! An Error occurred.' => 'אופס. התרחשה שגיאה.',
        'You can' => 'אתם יכולים',
        'Send a bugreport' => 'לשלוח דיווח על שגיאה',
        'go back to the previous page' => 'לחזור לעמוד הקודם',
        'Error Details' => 'פרטי השגיאה',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            '',
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',
        'Please check the fields marked as red for valid inputs.' => '',
        'Please perform a spell check on the the text first.' => '',
        'Slide the navigation bar' => '',
        'Unavailable for chat' => '',
        'Available for internal chats only' => '',
        'Available for chats' => '',
        'Please visit the chat manager' => '',
        'New personal chat request' => '',
        'New customer chat request' => '',
        'New public chat request' => '',
        'New activity' => '',
        'New activity on one of your monitored chats.' => '',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            '',
        'Find out more about the %s' => '',

        # Template: Header
        'You are logged in as' => 'אתם מחוברים כ',

        # Template: Installer
        'JavaScript not available' => 'JavaScript לא זמין',
        'Step %s' => 'שלב %s',
        'Database Settings' => 'הגדרות בסיס נתונים',
        'General Specifications and Mail Settings' => '',
        'Finish' => 'סיים',
        'Welcome to %s' => '',
        'Web site' => 'אתר',
        'Mail check successful.' => 'בדיקת דועאר הצליחה.',
        'Error in the mail settings. Please correct and try again.' => '',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '',
        'Outbound mail type' => 'סוג',
        'Select outbound mail type.' => '',
        'Outbound mail port' => '',
        'Select outbound mail port.' => '',
        'SMTP host' => '',
        'SMTP host.' => '',
        'SMTP authentication' => '',
        'Does your SMTP host need authentication?' => '',
        'SMTP auth user' => '',
        'Username for SMTP auth.' => '',
        'SMTP auth password' => '',
        'Password for SMTP auth.' => '',
        'Configure Inbound Mail' => 'הגדרת דואר נכנס',
        'Inbound mail type' => 'סוג דואר נכנס',
        'Select inbound mail type.' => 'בחרו סוג דואר נכנס',
        'Inbound mail host' => 'מארח דואר נכנס',
        'Inbound mail host.' => 'מארח דואר נכנס.',
        'Inbound mail user' => 'משתמש עבור דואר יוצא',
        'User for inbound mail.' => 'משתמש עבור דואר נכנס.',
        'Inbound mail password' => 'סיסמא עבור דואר יוצא',
        'Password for inbound mail.' => 'סיסמא עבור דואר נכנס.',
        'Result of mail configuration check' => 'תוצאות בדיקת הגדרות דוא"ל',
        'Check mail configuration' => 'בדוק הדגרות דוא"ל',
        'Skip this step' => 'דלג על שלב זה',

        # Template: InstallerDBResult
        'Database setup successful!' => 'התקנת בסיס הנתונים הצליחה!',

        # Template: InstallerDBStart
        'Install Type' => 'סוג ההתקנה',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => 'שם בסיס הנתונים',
        'Check database settings' => 'בדוק הגדרות בסיס נתונים',
        'Result of database check' => 'תוצאות בדיקת בסיס נתונים',
        'Database check successful.' => 'בדיקת בסיס הנתונים הצליחה.',
        'Database User' => 'משתמש בסיס נתונים',
        'New' => 'חדש',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            '',
        'Repeat Password' => 'חזרו על סיסמא',
        'Generated password' => 'ייצר סיסמא',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'הסיסמאות לא תואמות',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Port',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            '',
        'Restart your webserver' => 'אתחל את השרת שלך.',
        'After doing so your OTRS is up and running.' => 'לאחר שמערכת OTRS תותקן.',
        'Start page' => 'עמוד התחלה',
        'Your OTRS Team' => '',

        # Template: InstallerLicense
        'Don\'t accept license' => 'סרב לקבל רישיון',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '',
        'System FQDN' => 'System FQDN',
        'Fully qualified domain name of your system.' => 'שם הדומיין המלא של המערכת שלכם.',
        'AdminEmail' => 'דוא"ל של מנהל מערכת',
        'Email address of the system administrator.' => 'דוא"ל של מנהל מערכת.',
        'Organization' => 'ארגון',
        'Log' => '',
        'LogModule' => '',
        'Log backend to use.' => '',
        'LogFile' => '',
        'Webfrontend' => '',
        'Default language' => 'שפת ברירת מחדל',
        'Default language.' => 'שפת ברירת מחדל.',
        'CheckMXRecord' => '',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '',

        # Template: LinkObject
        'Object#' => 'אובייקט#',
        'Add links' => 'הוסף קישורים',
        'Delete links' => 'מחק קישורים',

        # Template: Login
        'Lost your password?' => 'שכחתם סיסמא?',
        'Request New Password' => 'בקש סיסמא חדשה',
        'Back to login' => 'חזרה להתחברות',

        # Template: MobileNotAvailableWidget
        'Feature not available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'ההודעה היומית',

        # Template: NoPermission
        'Insufficient Rights' => 'הרשאות לא מספיקות',
        'Back to the previous page' => 'חזרה לעמוד הקודם',

        # Template: Pagination
        'Show first page' => 'הצג עמוד ראשון',
        'Show previous pages' => 'הצג עמוד קודם',
        'Show page %s' => 'הצג עמוד %s',
        'Show next pages' => 'הצג עמוד הבא',
        'Show last page' => 'הצג עמוד אחרון',

        # Template: PictureUpload
        'Need FormID!' => 'נדרש FormID!',
        'No file found!' => 'לא נמצא קובץ!',
        'The file is not an image that can be shown inline!' => 'קובץ זה אינו תמונה ולא ניתן להראותו משולב!',

        # Template: PreferencesNotificationEvent
        'Notification' => 'התראה',
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: PublicDefault
        'Welcome' => '',

        # Template: Test
        'OTRS Test Page' => 'עמוד בדיקה OTRS',
        'Welcome %s %s' => '',
        'Counter' => 'מונה',

        # Template: Warning
        'Go back to the previous page' => 'חזור לעמוד הקודם',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'פניית טלפון חדשה',
        'New email ticket' => 'פניית דוא"ל חדשה',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Currently' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'Web service "%s" updated!' => '',
        'Web service "%s" created!' => '',
        'Web service "%s" deleted!' => '',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who owns the ticket' => '',
        'Agent who is responsible for the ticket' => '',
        'All agents watching the ticket' => '',
        'All agents with write permission for the ticket' => '',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer of the ticket' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Package not verified due a communication issue with verification server!' =>
            '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'Statistic' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Can not delete link with %s!' => '',
        'Can not create link with %s!' => '',
        'Object already linked as %s.' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No subject' => '',
        'Previous Owner' => 'בעלים קודם',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Ticket is locked by another agent and will be ignored!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'printed by' => 'הודפס על ידי',
        'Ticket Dynamic Fields' => 'שדות פניה דינמיים',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Pending Date' => '',
        'for pending* states' => '',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Invalid Users' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. ' =>
            '',
        'Fields with no group' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/Installer.pm
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'This ticket has no title or subject' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'This user is currently offline' => '',
        'This user is currently active' => '',
        'This user is currently away' => '',
        'This user is currently unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            '',
        ' You can take one of the next actions:' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'Please contact your administrator!' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'X-axis' => 'ציר X',
        'Y-axis' => '',
        'The selected start time is before the allowed start time.' => '',
        'The selected end time is later than the allowed end time.' => '',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'The selected time upcoming period is larger than the allowed time upcoming period.' =>
            '',
        'The selected time scale is smaller than the allowed time scale.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => '',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'סדר לפי',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'נוצר בעדיפות',
        'Created State' => 'מצב נוכחי',
        'CustomerUserLogin' => 'התחברות משתמש לקוח',
        'Create Time' => 'זמן היצירה',
        'Close Time' => 'זמן הסגירה',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'סוכן/בעלים',
        'Created by Agent/Owner' => 'נוצר על ידי סוכן/בעלים',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'הערכה לפי',
        'Ticket/Article Accounted Time' => 'זמן שהוקדש לפניה/מאמר',
        'Ticket Create Time' => 'זמן יצירת הפניה',
        'Ticket Close Time' => 'זמן סגירת הפניה',
        'Accounted time by Agent' => 'זמן שהוקדש לפי סוכן',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'Attributes to be printed' => 'מאפיינים שיש להדפיס',
        'Sort sequence' => 'רצף הסידור',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '',
        'Internal Error: Could not open file.' => '',
        'Table Check' => '',
        'Internal Error: Could not read file.' => '',
        'Tables found which are not present in the database.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => '',
        'Could not determine database size.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '',
        'Could not determine database version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'Setting character_set_database needs to be UNICODE or UTF8.' => '',
        'Table Charset' => '',
        'There were tables found which do not have utf8 as charset.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Operating System/Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '',
        'Could not determine distribution.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS/Config Settings' => '',
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'OTRS' => '',
        'Daemon' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'OTRS/Database Records' => '',
        'Tickets' => 'פניות',
        'Ticket History Entries' => '',
        'Articles' => '',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ErrorLog.pm
        'Error Log' => '',
        'There are error reports in your system log.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages are not correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'OTRS/Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'Open Tickets' => '',
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'OTRS/Time Settings' => '',
        'Server time zone' => '',
        'Computed server time offset' => '',
        'OTRS TimeZone setting (global time offset)' => '',
        'TimeZone may only be activated for systems running in UTC.' => '',
        'OTRS TimeZoneUser setting (per-user time zone support)' => '',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            '',
        'OTRS TimeZone setting for calendar ' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver/Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'Webserver' => '',
        'MPM model' => '',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Webserver/Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/IIS/Performance.pm
        'You should use PerlEx to increase your performance.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => '',
        'OK' => 'אישור',
        'Problem' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Reset password unsuccessful. Please contact your administrator' =>
            '',
        'Panic! Invalid Session!!!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'All new state types (default: viewable).' => '',
        'All open state types (default: viewable).' => '',
        'All closed state types (default: not viewable).' => '',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'All \'removed\' state types (default: not viewable).' => '',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'Ticket is closed successful.' => '',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'Ticket is pending for automatic close.' => '',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created..' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        'tmp_lock' => '',
        'email-notification-ext' => '',
        'email-notification-int' => '',
        'fax' => '',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => '',
        '"%s" notification was sent to "%s" by "%s".' => '',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s זמן שהוקדש. סך זמן מצטבר %s.',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'Access Control Lists (ACL)' => 'Access Control Lists (ACL)',
        'AccountedTime' => 'Erfasste Zeit',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '',
        'Activates lost password feature for agents, in the agent interface.' =>
            '',
        'Activates lost password feature for customers.' => '',
        'Activates support for customer groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
        'ActivityID' => '',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added email. %s' => 'דוא"ל נוסף. %s',
        'Added link to ticket "%s".' => 'נוצר קישור עבור "%s".',
        'Added note (%s)' => 'הערה נוספה (%s)',
        'Added subscription for user "%s".' => 'משתמש נרשם למעקב אחרי "%s".',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'After' => '',
        'Agent called customer.' => 'סוכן התקשר.',
        'Agent interface article notification module to check PGP.' => '',
        'Agent interface article notification module to check S/MIME.' =>
            '',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            '',
        'Agent interface module to access search profiles via nav bar.' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to see the number of locked tickets.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => 'סוכנים <-> קבוצות',
        'Agents <-> Roles' => 'סוכן <-> תפקיד',
        'All customer users of a CustomerID' => 'Alle Kundenbenutzer einer Kundennummer',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '',
        'Allows agents to generate individual-related stats.' => '',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Archive state changed: "%s"' => 'עודכן סטטוס ארכיון: "%s"',
        'ArticleTree' => 'Artikelbaum',
        'Attachments <-> Templates' => 'קבצים מצרופים <-> תבניות',
        'Auto Responses <-> Queues' => 'מענים אוטומטיים <-> תורים',
        'AutoFollowUp sent to "%s".' => 'מעקב אוטומטי ל-"%s" נשלח.',
        'AutoReject sent to "%s".' => 'דחייה אוטומטית של "%s" נשלחה.',
        'AutoReply sent to "%s".' => 'מענה אוטומטי ל-"%s" נשלח.',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'חזר "%s".',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'שנה סיסמא',
        'Change queue!' => 'שנה תור',
        'Change the customer for this ticket' => 'שנה את הלקוח של פניה זו',
        'Change the free fields for this ticket' => 'שנה את השדות החופשיים לפניה זו',
        'Change the priority for this ticket' => 'שנה את העדיפות של פניה זו',
        'Change the responsible for this ticket' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'עדיפות עודכנה עבור "%s" (%s) לאחר "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            '',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Cloud Services' => '',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Comment2' => '',
        'Communication' => '',
        'Company Status' => 'סטטוס חברה',
        'Company Tickets' => 'פניות של החברה',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => 'הגדר תהליכים.',
        'Configure and manage ACLs.' => '',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'המר דוא"לי HTML להודעות טקסט',
        'Create New process ticket' => 'צור פניית תהליך חדשה',
        'Create and manage Service Level Agreements (SLAs).' => 'צור ונהל הסכמי רמת שירות (SLA).',
        'Create and manage agents.' => 'צור ונהל סוכנים.',
        'Create and manage attachments.' => 'צור ונהל קבצים מצורפים.',
        'Create and manage customer users.' => 'צור ונהל משתמשי לקוח.',
        'Create and manage customers.' => 'צור ונהל לקוחות.',
        'Create and manage dynamic fields.' => 'צור ונהל שדות דינמיים.',
        'Create and manage groups.' => 'צור ונהל קבוצות.',
        'Create and manage queues.' => 'צור ונהל תורים.',
        'Create and manage responses that are automatically sent.' => 'צור ונהל מענים שנשלחים אוטומטית.',
        'Create and manage roles.' => 'צור ונהל תפקידים.',
        'Create and manage salutations.' => 'צור ונהל ברכות.',
        'Create and manage services.' => 'צור ונהל שירותים.',
        'Create and manage signatures.' => 'צור ונהל חתימות.',
        'Create and manage templates.' => 'צור ונהל תבניות.',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => 'צור ונהל עדיפויות פניות.',
        'Create and manage ticket states.' => 'צור ונהל מצבי פניות.',
        'Create and manage ticket types.' => 'צור ונהל סוגי פניות.',
        'Create and manage web services.' => 'צור ונהל שירותי Webservices.',
        'Create new email ticket and send this out (outbound)' => 'צור ונהל פניית דוא"ל חדשה ושלח אותה (דואר יוצא)',
        'Create new phone ticket (inbound)' => 'צור ונהל פניית טלפון חדשה (נכנסת)',
        'Create new process ticket' => 'צור ונהל פניית תהליך חדשה',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '',
        'Customer User <-> Groups' => 'משתמש לקוח <-> קבוצות',
        'Customer User <-> Services' => 'משתמש לקוח <-> שירותים',
        'Customer User Administration' => 'ניהול משתמשי לקוח',
        'Customer Users' => 'משתמשי לקוח',
        'Customer called us.' => 'לקוח התקשר.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer request via web.' => 'לקוח שהשיבו לפניה זו באתר.',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => 'שם לקוח',
        'Customers <-> Groups' => 'לקוחות <-> קבוצות',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => 'תאריך / זמן',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the queue comment 2.' => '',
        'Define the service comment 2.' => '',
        'Define the sla comment 2.' => '',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://otrs.github.io/doc/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of possible next actions on an error screen.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Deleted link to ticket "%s".' => 'נמחק קישור עבור "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => 'Einfachauswahl',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => 'ערוך חברת הלקוח',
        'Email Addresses' => 'כתובת דוא"ל',
        'Email sent to "%s".' => 'דוא"ל נשלח ל-"%s".',
        'Email sent to customer.' => 'דוא"ל נשלח ללקוח.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => 'אפשר מסננים',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication.' =>
            '',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => 'תצוגת אסקלציה',
        'EscalationTime' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Events Ticket Calendar' => '',
        'Execute SQL statements.' => '',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'סנן דואר נכנס.',
        'First Queue' => '',
        'FirstLock' => 'נעילה ראשונה',
        'FirstResponse' => 'מענה ראשון',
        'FirstResponseDiffInMin' => 'הפרש מענה ראשון בדקות',
        'FirstResponseInMin' => 'מענה ראשון בדקות',
        'Firstname Lastname' => 'שם פרטי ומשפחה',
        'Firstname Lastname (UserLogin)' => 'שם פרטי ומשפחה (התחברות משתמש)',
        'FollowUp for [%s]. %s' => 'מעקב עבור [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'העבר "%s".',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => '',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'GenericAgent' => '',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Webservice History GUI' => '',
        'GenericInterface Webservice Mapping GUI' => '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Go back' => '',
        'Google Authenticator' => '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'שפת ממשק',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'JavaScript function for the search frontend.' => '',
        'Lastname, Firstname' => 'שם משפחה, שם פרטי',
        'Lastname, Firstname (UserLogin)' => 'שם משפחה, שם פרטי (התחברות משתמש)',
        'Left' => '',
        'Link agents to groups.' => 'קשר סוכנים לקבוצות.',
        'Link agents to roles.' => 'קשר סוכנים לתפקידים.',
        'Link attachments to templates.' => 'קשר קבצים מצורפים לתבניות.',
        'Link customer user to groups.' => 'קשר משתמש לקוח לקבוצות.',
        'Link customer user to services.' => 'קשר לקוחות לשירותים.',
        'Link queues to auto responses.' => 'קשר תורים למענים אוטומטיים.',
        'Link roles to groups.' => 'קשר תפקידים לקבוצות.',
        'Link templates to queues.' => 'קשר תבניות לתורים.',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lock / unlock this ticket' => '',
        'Locked ticket.' => 'פניה ננעלה.',
        'Log file for the ticket counter.' => '',
        'Loop-Protection! No auto-response sent to "%s".' => 'הגנת לולאה! לא נשלחה תשובה אוטמטית אל "%s".',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => '',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark this ticket as junk!' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Merge this ticket and all articles into a another ticket' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Miscellaneous' => '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => 'Mehrfachauswahl',
        'My Services' => '',
        'My Tickets' => 'Meine Tickets',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'פניה חדשה [%s] נוצרה (Q=%s;P=%s;S=%s).',
        'New Window' => '',
        'New owner is "%s" (ID=%s).' => 'בעלים חדשים של "%s" (ID=%s).',
        'New process ticket' => 'פניית תהליך חדשה',
        'New responsible is "%s" (ID=%s).' => 'האחראי החדש הוא "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'None' => '',
        'Notification sent to "%s".' => 'הודעה נשלחה "%s".',
        'Number of displayed tickets' => 'מספר פניות מוצגות',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'ישן: "%s" חדש: "%s"',
        'Online' => '',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Out Of Office' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'מבט-על של פניות באסקלציה',
        'Overview Refresh Time' => 'מבט-על של זמן רענון',
        'Overview of all open Tickets.' => 'מבט-על של כל הפניות הפתוחות',
        'PGP Key Management' => 'ניהול מפתח PGP',
        'PGP Key Upload' => 'העלאת מפתח PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'People' => '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => '',
        'PostMaster Filters' => '',
        'PostMaster Mail Accounts' => '',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'תצוגת תורים',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => 'לרענן כל',
        'Removed subscription for user "%s".' => 'משתמש ביטל מעקב אחרי "%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => '',
        'Reports (OTRS Business Solution™)' => '',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles <-> Groups' => 'תפקידים <-> קבוצות',
        'Run file based generic agent jobs (Note: module name need needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'S/MIME Zertifikat hochladen',
        'SMS' => '',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen' => '',
        'Search Customer' => 'חפש לקוח',
        'Search User' => 'חפש משתמש',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Second Queue' => '',
        'Select your frontend Theme.' => 'בחרו את ערכת העיצוב שלכם.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'שלח התראות למשתמשים.',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Service view' => '',
        'Set minimum loglevel. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages.' =>
            '',
        'Set sender email addresses for this system.' => 'קבע כתובת דוא"ל לשולח עבור מערכת זו.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Shared Secret' => '',
        'Should the cache data be help in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows information on how to start OTRS Daemon' => '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => 'ערכת עיצוב',
        'SolutionDiffInMin' => 'הפרש פתרון בדקות',
        'SolutionInMin' => 'פתרון בדקות',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'סטטיטיקה #',
        'Status view' => 'תצוגת סטטוס',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'System Maintenance' => '',
        'System Request (%s).' => 'בקשת מערכת (%s).',
        'Templates <-> Queues' => 'תבניות <-> תורים',
        'Textarea' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'This will allow the system to send SMS messages.' => '',
        'Ticket Notifications' => '',
        'Ticket Queue Overview' => 'מבט-על על תורים של פניות',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'פניה הועברה מתור "%s" (%s) לתור "%s" (%s).',
        'Ticket notifications' => '',
        'Ticket overview' => 'מבט-על בפניות',
        'TicketNumber' => 'מספר פניה',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => 'עודכנה כותרת פניה: ישנה: "%s", חדשה: "%s"',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Transport selection for ticket notifications.' => '',
        'Tree view' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'פניה נפתחה מחדש.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => '',
        'Updated SLA to %s (ID=%s).' => 'SLA עודכן "%s" (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'שירות עודכן "%s" (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'סוג עודכן "%s" (ID=%s).',
        'Updated: %s' => 'עודכן: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'עודכן: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'UserFirstname' => 'שם פרטי של משתמש',
        'UserLastname' => 'שם משפחה של משתמש',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => '',
        'View system log messages.' => '',
        'Watch this ticket' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            '',

    };
    # $$STOP$$
    return;
}

1;
