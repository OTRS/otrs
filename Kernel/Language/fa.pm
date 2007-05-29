# --
# Kernel/Language/fa.pm - provides fa language translation
# Copyright (C) 2006 Amir Shams Parsa <amir at parsa.name>
# --
# $Id: fa.pm,v 1.23 2007-05-29 13:31:52 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::fa;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.23 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Tue May 29 15:13:12 2007

    # possible charsets
    $Self->{Charset} = ['utf-8', 'utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateFormatShort} = '%D.%M.%Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # TextDirection rtl or ltr
    $Self->{TextDirection} = 'rtl';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'بله',
        'No' => 'خير',
        'yes' => 'بله',
        'no' => 'خير',
        'Off' => 'خاموش',
        'off' => 'خاموش',
        'On' => 'روشن',
        'on' => 'روشن',
        'top' => 'بالا',
        'end' => 'پایان',
        'Done' => 'انجام شد',
        'Cancel' => 'لغو',
        'Reset' => 'ورود مجدد',
        'last' => 'آخرین',
        'before' => 'قبل از',
        'day' => 'روز',
        'days' => 'روز',
        'day(s)' => 'روز',
        'hour' => 'ساعت',
        'hours' => 'ساعت',
        'hour(s)' => 'ساعت',
        'minute' => 'دقیقه',
        'minutes' => 'دقیقه',
        'minute(s)' => 'دقیقه',
        'month' => 'ماه',
        'months' => 'ماه',
        'month(s)' => 'ماه',
        'week' => 'هفته',
        'week(s)' => 'هفته',
        'year' => 'سال',
        'years' => 'سال',
        'year(s)' => 'سال',
        'second(s)' => '',
        'seconds' => '',
        'second' => '',
        'wrote' => 'نوشته شد',
        'Message' => 'پیام',
        'Error' => 'خطا',
        'Bug Report' => 'گزارش خطا',
        'Attention' => 'توجه',
        'Warning' => 'اخطار',
        'Module' => 'ماژول',
        'Modulefile' => 'فایل ماژول',
        'Subfunction' => 'زیر تابع',
        'Line' => 'خط',
        'Example' => 'مثال',
        'Examples' => 'مثال',
        'valid' => 'معتبر',
        'invalid' => 'غیر معتبر',
        '* invalid' => '',
        'invalid-temporarily' => 'موقتا غیر معتبر',
        ' 2 minutes' => '2 دقیقه',
        ' 5 minutes' => '5 دقیقه',
        ' 7 minutes' => '7 دقیقه',
        '10 minutes' => '10 دقیقه',
        '15 minutes' => '15 دقیقه',
        'Mr.' => 'آقای',
        'Mrs.' => 'خانم',
        'Next' => 'بعدی',
        'Back' => 'بازگشت',
        'Next...' => 'بعدی...',
        '...Back' => '...قبلی',
        '-none-' => '--',
        'none' => '--',
        'none!' => '--!',
        'none - answered' => 'هیچکدام پاسخ داده نشده',
        'please do not edit!' => 'لطفا ویرایش نکنید!',
        'AddLink' => 'افزودن لینک',
        'Link' => 'لینک',
        'Linked' => 'لینک شده',
        'Link (Normal)' => 'لینک (معمولی)',
        'Link (Parent)' => 'لینک (اصلی)',
        'Link (Child)' => 'لینک (فرعی)',
        'Normal' => 'عادی',
        'Parent' => 'اصلی',
        'Child' => 'فرعی',
        'Hit' => 'بازدید',
        'Hits' => 'بازدید',
        'Text' => 'متن',
        'Lite' => '',
        'User' => 'کاربر',
        'Username' => 'نام کاربری',
        'Language' => 'زبان',
        'Languages' => 'زبان',
        'Password' => 'رمز عبور',
        'Salutation' => 'عنوان',
        'Signature' => 'امضاء',
        'Customer' => 'مشترک',
        'CustomerID' => 'کد اشتراک',
        'CustomerIDs' => 'کد اشتراک',
        'customer' => 'مشترک',
        'agent' => 'کارشناس',
        'system' => 'سیستم',
        'Customer Info' => 'اطلاعات مشترک',
        'Customer Company' => '',
        'Company' => '',
        'go!' => 'تائید!',
        'go' => 'تائید',
        'All' => 'همه',
        'all' => 'همه',
        'Sorry' => 'متاسفیم',
        'update!' => 'بروزرسانی !',
        'update' => 'بروزرسانی',
        'Update' => 'بروزرسانی',
        'submit!' => 'ارسال !',
        'submit' => 'ارسال',
        'Submit' => 'ارسال',
        'change!' => 'تغییر !',
        'Change' => 'تغییر',
        'change' => 'تغییر',
        'click here' => 'اینجا کلیک کنید',
        'Comment' => 'توضیح',
        'Valid' => 'معتبر',
        'Invalid Option!' => 'انتخاب معتبر',
        'Invalid time!' => 'زمان معتبر',
        'Invalid date!' => 'تاریخ معتبر',
        'Name' => 'نام',
        'Group' => 'گروه',
        'Description' => 'توضیحات',
        'description' => 'توضیحات',
        'Theme' => 'طرح زمینه',
        'Created' => 'ایجاد شد',
        'Created by' => 'ایجاد شده بوسیله',
        'Changed' => 'تغییر یافت',
        'Changed by' => 'تغییر یافته بوسیله',
        'Search' => 'جستجو',
        'and' => 'و',
        'between' => 'بین',
        'Fulltext Search' => 'جستجوی متنی',
        'Data' => 'داده ها',
        'Options' => 'گزینه ها',
        'Title' => 'عنوان',
        'Item' => 'مورد',
        'Delete' => 'حذف',
        'Edit' => 'ویرایش',
        'View' => 'نمایش',
        'Number' => 'عدد',
        'System' => 'سیستم',
        'Contact' => 'تماس',
        'Contacts' => 'تماس',
        'Export' => 'خروجی به',
        'Up' => 'بالا',
        'Down' => 'پائین',
        'Add' => 'افزودن',
        'Category' => 'دسته بندی',
        'Viewer' => 'نمایش دهنده',
        'New message' => 'پیام جدید',
        'New message!' => 'پیام جدید !',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'لطفا برای بازگشت به نمایش عادی صف تیکت ها به این تیکت پاسخ دهید!',
        'You got new message!' => 'شما پیام جدیدی دریافت کرده اید !',
        'You have %s new message(s)!' => 'شما %s پیام جدید دارید !',
        'You have %s reminder ticket(s)!' => 'شما %s تیکت یادآوری دارید !',
        'The recommended charset for your language is %s!' => 'charset پیشنهادی برای زبان شما  %s است!',
        'Passwords doesn\'t match! Please try it again!' => 'رمز عبور ها یکسان نیست لطفا مجددا سعی نمائید!',
        'Password is already in use! Please use an other password!' => 'این رمز عبور در حال استفاده است لطفا آنرا تغییر دهید!',
        'Password is already used! Please use an other password!' => 'این رمز عبور در حال استفاده است لطفا آنرا تغییر دهید!',
        'You need to activate %s first to use it!' => 'شما برای استفاده  %s ابتدا میبایست آنرا فعال نمائید!',
        'No suggestions' => 'هیچ پیشنهادی وجود ندارد',
        'Word' => 'کلمه',
        'Ignore' => 'صرف نظر',
        'replace with' => 'جایگزین کن با',
        'There is no account with that login name.' => 'هیچ حسابی با نام کاربری وارد شده مطابقت ندارد',
        'Login failed! Your username or password was entered incorrectly.' => 'ورود ناموفق . اطلاعات وارد شده صحیح نمیباشد.',
        'Please contact your admin' => 'لطفا با مدیر سیستم تماس بگیرید',
        'Logout successful. Thank you for using OTRS!' => 'خروج با موفقیت انجام گرفت . از استفاده از سیستم پشتیبانی سورس باز متشکریم.',
        'Invalid SessionID!' => 'SessionID نا معتبر!',
        'Feature not active!' => 'این ویژگی فعال نیست.',
        'Login is needed!' => '',
        'Password is needed!' => 'ورود رمز عبور الزامی است',
        'License' => 'مجوز بهره برداری سیستم',
        'Take this Customer' => 'این مشترک را بگیر',
        'Take this User' => 'این کاربر را بگیر',
        'possible' => 'امکانپذیر',
        'reject' => 'نپذیر',
        'reverse' => '',
        'Facility' => 'سهولت',
        'Timeover' => 'زمان اتمام',
        'Pending till' => 'تا زمانی که',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'با نام کاربری سیستم کار نکنید برای ادامه یک نام کاربری جدید ایجاد نمائید.!',
        'Dispatching by email To: field.' => 'ارسال با پست الکترونیکی به:فیلد',
        'Dispatching by selected Queue.' => 'ارسال بوسیله صف انتخاب شده',
        'No entry found!' => 'موردی پیدا نشد!',
        'Session has timed out. Please log in again.' => 'مهلت Session شما به اتمام رسید . لطفا مجددا وارد سیستم شوید..',
        'No Permission!' => 'دسترسی به این قسمت امکانپذیر نیست!',
        'To: (%s) replaced with database email!' => 'به: (%s) با آدرس e-mail موجود در بانک جایگزین شد!',
        'Cc: (%s) added database email!' => 'کپی به: (%s) آدرس e-mail اضافه شده',
        '(Click here to add)' => '(برای افزودن کلیک کنید)',
        'Preview' => 'پیش نمایش',
        'Package not correctly deployed! You should reinstall the Package again!' => '',
        'Added User "%s"' => 'کاربر اضافه شده "%s"',
        'Contract' => 'قرارداد',
        'Online Customer: %s' => 'مشترک فعال: %s',
        'Online Agent: %s' => 'کارشناس پشتیبانی فعال: %s',
        'Calendar' => 'تقویم',
        'File' => 'فایل',
        'Filename' => 'نام فایل',
        'Type' => 'نوع',
        'Size' => 'اندازه',
        'Upload' => 'ارسال فایل',
        'Directory' => 'دایرکتوری',
        'Signed' => 'امضاء شده',
        'Sign' => 'امضاء',
        'Crypted' => 'رمز گذاری شده',
        'Crypt' => 'رمز',
        'Office' => 'شرکت',
        'Phone' => 'تلفن',
        'Fax' => '',
        'Mobile' => '',
        'Zip' => '',
        'City' => '',
        'Country' => '',
        'installed' => 'نصب شده',
        'uninstalled' => 'نصب نشده',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => '',

        # Template: AAAMonth
        'Jan' => 'ژانویه',
        'Feb' => 'فوریه',
        'Mar' => 'مارس',
        'Apr' => 'آپریل',
        'May' => 'می',
        'Jun' => 'ژون',
        'Jul' => 'جولای',
        'Aug' => 'آگوست',
        'Sep' => 'سپتامبر',
        'Oct' => 'اکتبر',
        'Nov' => 'نوامبر',
        'Dec' => 'دسامبر',
        'January' => '',
        'February' => '',
        'March' => '',
        'April' => '',
        'June' => '',
        'July' => '',
        'August' => '',
        'September' => '',
        'October' => '',
        'November' => '',
        'December' => '',

        # Template: AAANavBar
        'Admin-Area' => 'محیط مدیریت',
        'Agent-Area' => 'محیط پشتیبانی',
        'Ticket-Area' => 'محیط تیکت',
        'Logout' => 'خروج',
        'Agent Preferences' => 'تنظیمات کارشناس',
        'Preferences' => 'تنظیمات',
        'Agent Mailbox' => 'صندوق پستی کارشناس',
        'Stats' => 'وضعیت',
        'Stats-Area' => 'محیط وضعیت ',
        'Admin' => 'مدیریت سیستم',
        'Customer Users' => 'مشترکین',
        'Customer Users <-> Groups' => 'مشترک <-> گروه',
        'Users <-> Groups' => 'کاربر <-> گروه',
        'Roles' => 'وظیفه',
        'Roles <-> Users' => 'وظیفه <-> کابر',
        'Roles <-> Groups' => 'وظیفه <-> گروه',
        'Salutations' => 'عنوان',
        'Signatures' => 'امضاء',
        'Email Addresses' => 'آدرس e-mail',
        'Notifications' => 'اخطار',
        'Category Tree' => 'درخت دسته بندی',
        'Admin Notification' => 'اخطار مدیر سیستم',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'تنظیمات با موفقیت ثبت گردید!',
        'Mail Management' => 'مدیریت نامه ها',
        'Frontend' => 'رابط نمایشی',
        'Other Options' => 'سایر گزینه ها',
        'Change Password' => 'تغیر رمز عبور',
        'New password' => 'رمز عبور جدید',
        'New password again' => 'تکرار رکز عبور',
        'Select your QueueView refresh time.' => 'زمان بازیابی مجدد صف را انتخاب نمائید',
        'Select your frontend language.' => 'زبان رابط را انتخاب نمائید',
        'Select your frontend Charset.' => 'Charset خود را انتخاب نمائید',
        'Select your frontend Theme.' => 'الگوی نمایش رابط را انتخاب نمائید',
        'Select your frontend QueueView.' => 'رابط نمایش صف را انتخاب نمائید',
        'Spelling Dictionary' => 'دیکشنری غلط یابی',
        'Select your default spelling dictionary.' => 'دیکشنری غلط یابی خود را انتخاب نمائید',
        'Max. shown Tickets a page in Overview.' => 'حداکثر تعداد نمایش تیکت ها در پیش نمایش',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'رمز های عبور وارد شده یکسان نیست!',
        'Can\'t update password, invalid characters!' => 'کاراکتر غیر مجاز !',
        'Can\'t update password, need min. 8 characters!' => 'حداقل طول رمز عبور 8 رقم میباشد!',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'دست کم 2 حرف کوچک و 2 حرف بزرگ میبایست در رمز عبور استفاده شود!',
        'Can\'t update password, need min. 1 digit!' => 'دست کم 1 عدد مورد نیاز است!',
        'Can\'t update password, need min. 2 characters!' => 'دست کم 2 کاراکتر مورد نیاز است!',

        # Template: AAAStats
        'Stat' => '',
        'Please fill out the required fields!' => '',
        'Please select a file!' => '',
        'Please select an object!' => '',
        'Please select a graph size!' => '',
        'Please select one element for the X-axis!' => '',
        'You have to select two or more attributes from the select field!' => '',
        'Please select only one element or turn of the button \'Fixed\' where the select field is marked!' => '',
        'If you use a checkbox you have to select some attributes of the select field!' => '',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
        'The selected end time is before the start time!' => '',
        'You have to select one or more attributes from the select field!' => '',
        'The selected Date isn\'t valid!' => '',
        'Please select only one or two elements via the checkbox!' => '',
        'If you use a time scale element you can only select one element!' => '',
        'You have an error in your time selection!' => '',
        'Your reporting time interval is to small, please use a larger time scale!' => '',
        'The selected start time is before the allowed start time!' => '',
        'The selected end time is after the allowed end time!' => '',
        'The selected time period is larger than the allowed time period!' => '',
        'Common Specification' => '',
        'Xaxis' => '',
        'Value Series' => '',
        'Restrictions' => '',
        'graph-lines' => '',
        'graph-bars' => '',
        'graph-hbars' => '',
        'graph-points' => '',
        'graph-lines-points' => '',
        'graph-area' => '',
        'graph-pie' => '',
        'extended' => '',
        'Agent/Owner' => '',
        'Created by Agent/Owner' => '',
        'Created Priority' => '',
        'Created State' => '',
        'Create Time' => '',
        'CustomerUserLogin' => '',
        'Close Time' => '',

        # Template: AAATicket
        'Lock' => 'در اختیار',
        'Unlock' => 'آزاد',
        'History' => 'سابقه',
        'Zoom' => 'نمایش کامل',
        'Age' => 'عمر',
        'Bounce' => 'ارجاع',
        'Forward' => 'ارسال به دیگری',
        'From' => 'از ',
        'To' => 'به',
        'Cc' => 'کپی به',
        'Bcc' => 'کپی پنهان به',
        'Subject' => 'موضوع',
        'Move' => 'انتقال',
        'Queue' => 'لیست تیکت',
        'Priority' => 'اولویت',
        'State' => 'وضعیت',
        'Compose' => 'ارسال',
        'Pending' => 'در حالت تعلیق',
        'Owner' => 'صاحب',
        'Owner Update' => 'بروز رسانی بوسیله صاحب',
        'Responsible' => '',
        'Responsible Update' => '',
        'Sender' => 'ارسال کننده',
        'Article' => 'مورد',
        'Ticket' => 'تیکت',
        'Createtime' => 'زمان ایجاد ',
        'plain' => 'ساده',
        'Email' => '',
        'email' => 'e-mail',
        'Close' => 'بستن',
        'Action' => 'فعالیت',
        'Attachment' => 'پیوست',
        'Attachments' => 'پیوست ها',
        'This message was written in a character set other than your own.' => 'این پیام با charset دیگری بجز charset شما نوشته شده است.',
        'If it is not displayed correctly,' => 'اگر به درستی نمایش داده نشده است',
        'This is a' => 'این یک',
        'to open it in a new window.' => 'برای باز شدن در پنجره جدید',
        'This is a HTML email. Click here to show it.' => 'این یک نامه HTML است برای نمایش اینجا کلیک کنید.',
        'Free Fields' => 'فیلد های آزاد',
        'Merge' => 'ادغام ',
        'merged' => '',
        'closed successful' => 'با موفقیت بسته شد',
        'closed unsuccessful' => 'با موفقیت بسته نشد',
        'new' => 'جدید',
        'open' => 'باز',
        'closed' => 'بسته شده',
        'removed' => 'حذف شده',
        'pending reminder' => 'یادآوری کننده حالت تعلیق',
        'pending auto' => '',
        'pending auto close+' => 'حالت تعلیق-بستن خودکار(+)',
        'pending auto close-' => 'حالت تعلیق-بستن خودکار(-)',
        'email-external' => 'email-خارجی',
        'email-internal' => 'email-داخلی',
        'note-external' => 'یادداشت- خارجی',
        'note-internal' => 'یادداشت-داخلی',
        'note-report' => 'یادداشت-گزارش',
        'phone' => 'تلفن',
        'sms' => 'پیام کوتاه-SMS',
        'webrequest' => 'درخواست از طریق وب',
        'lock' => 'در اختیار',
        'unlock' => 'آزاد',
        'very low' => 'خیلی پائین',
        'low' => 'پائین',
        'normal' => 'معمولی',
        'high' => 'بالا',
        'very high' => 'خیلی بالا',
        '1 very low' => '1 خیلی پائین',
        '2 low' => '2 پائین',
        '3 normal' => 'عادی',
        '4 high' => '4 بالا',
        '5 very high' => '5 خیلی بالا',
        'Ticket "%s" created!' => 'تیکت %s ایجاد گردید !',
        'Ticket Number' => 'شماره تیکت',
        'Ticket Object' => 'موضوع تیکت',
        'No such Ticket Number "%s"! Can\'t link it!' => 'این شماره تیکت وجود ندارد "%s"! نمایش این تیکت امکانپذیر نیست',
        'Don\'t show closed Tickets' => 'تیکت های بسته را نمایش نده',
        'Show closed Tickets' => 'نمایش تیکت های بسته',
        'New Article' => 'مورد جدید',
        'Email-Ticket' => 'تیکت پستی',
        'Create new Email Ticket' => 'ایجاد تیکت پستی',
        'Phone-Ticket' => 'تیکت تلفنی',
        'Search Tickets' => 'جستجو در تیکت ها',
        'Edit Customer Users' => 'ویرایش مشترکین',
        'Bulk-Action' => 'اعمال کلی',
        'Bulk Actions on Tickets' => 'اعمال کلی روی تیکت ها',
        'Send Email and create a new Ticket' => 'ارسال email و ایجاد تیکت جدید',
        'Create new Email Ticket and send this out (Outbound)' => '',
        'Create new Phone Ticket (Inbound)' => '',
        'Overview of all open Tickets' => 'پیش نمایش همه تیکت های باز',
        'Locked Tickets' => 'تیکت های در اختیار کارشناس',
        'Watched Tickets' => '',
        'Watched' => '',
        'Subscribe' => '',
        'Unsubscribe' => '',
        'Lock it to work on it!' => 'برای کار روی تیکت آن را در اختیار بگیرید',
        'Unlock to give it back to the queue!' => 'برای بازگرداندن تیکت به لیست آن را آزاد کنید',
        'Shows the ticket history!' => 'نمایش سابقه تیکت',
        'Print this ticket!' => 'این تیکت را چاپ کن',
        'Change the ticket priority!' => 'ویرایش اولویت تیکت',
        'Change the ticket free fields!' => 'تغییر فیلدهای خالی تیکت',
        'Link this ticket to an other objects!' => 'این تیکت را به شیء دیگری لینک کن',
        'Change the ticket owner!' => 'تغییر صاحب لینک',
        'Change the ticket customer!' => 'تغییر مشترک تیکت',
        'Add a note to this ticket!' => 'افزودن یادداشت به تیکت',
        'Merge this ticket!' => 'ادغام این تیکت',
        'Set this ticket to pending!' => 'این تیکت را به حالت تعلیق ببر',
        'Close this ticket!' => 'تیکت را ببند',
        'Look into a ticket!' => 'مشاهده تیکت',
        'Delete this ticket!' => 'حذف تیکت',
        'Mark as Spam!' => 'بعنوان SPAM علامت بزن',
        'My Queues' => 'لیست تیکت های من',
        'Shown Tickets' => 'تیکت های نمایش داده شده',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'پیام شما با شماره تیکت  "<OTRS_TICKET>" با  "<OTRS_MERGE_TO_TICKET>" ادغام گردید.',
        'Ticket %s: first response time is over (%s)!' => '',
        'Ticket %s: first response time will be over in %s!' => '',
        'Ticket %s: update time is over (%s)!' => '',
        'Ticket %s: update time will be over in %s!' => '',
        'Ticket %s: solution time is over (%s)!' => '',
        'Ticket %s: solution time will be over in %s!' => '',
        'There are more escalated tickets!' => '',
        'New ticket notification' => 'اعلان تیکت جدید',
        'Send me a notification if there is a new ticket in "My Queues".' => 'دریافت تیکت جدید را به من اطلاع بده.',
        'Follow up notification' => 'پیگیری تیکت را به من اطلاع بده',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'در صورت ارسال یک پیگیری از طرف مشترک به من اطلاع بده.',
        'Ticket lock timeout notification' => 'زمان اتمام مهلت در اختیار بودن تیکت به من اطلاع بده',
        'Send me a notification if a ticket is unlocked by the system.' => 'اگر تیکت توسط سیستم آزاد شد به من اطلاع بده',
        'Move notification' => 'اعلان جابجایی',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'انتقال یک تیکت به لیست تیکت های من را اطلاع بده.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'شما از طریق email از وضعیت لیست خود مطلع خواهید شد - در صورتیکه این گزینه در سیستم فعال باشد',
        'Custom Queue' => 'لیست سفارشی',
        'QueueView refresh time' => 'زمان بازیابی لیست تیکت ها',
        'Screen after new ticket' => 'وضعیت نمایش پس از دریافت تیکت جدید',
        'Select your screen after creating a new ticket.' => 'وضعیت نمایش را بعد از تیکت جدید انتخاب کنید.',
        'Closed Tickets' => 'تیکت بسته شده',
        'Show closed tickets.' => 'نمایش تیکت های بسته',
        'Max. shown Tickets a page in QueueView.' => 'حداکثر تعداد تیکت هادر صفحه نمایش',
        'CompanyTickets' => 'تیکت های شرکت',
        'MyTickets' => 'تیکت های من',
        'New Ticket' => 'تیکت جدید',
        'Create new Ticket' => 'ایجاد تیکت جدید',
        'Customer called' => 'مشترک تماس گرفته',
        'phone call' => '',
        'Responses' => 'پاسخ ها',
        'Responses <-> Queue' => 'پاسخ <-> لیست تیکت',
        'Auto Responses' => 'پاسخ خودکار',
        'Auto Responses <-> Queue' => 'پاسخ خودکار <-> لیست تیکت',
        'Attachments <-> Responses' => 'پاسخ خودکار <-> پاسخ',
        'History::Move' => 'سابقه::انتقال',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'تیکت جدید::سابقه',
        'History::FollowUp' => 'سابقه::پیگیری',
        'History::SendAutoReject' => 'سابقه::ارسال رد کردن خودکار ',
        'History::SendAutoReply' => 'سابقه::ارسال پاسخ خودکار',
        'History::SendAutoFollowUp' => 'سابقه:: ارسال پیگیری خودکار',
        'History::Forward' => 'سابقه::ارسال به دیگری',
        'History::Bounce' => 'سابقه:: ارجاع',
        'History::SendAnswer' => 'سابقه::ارسال پاسخ',
        'History::SendAgentNotification' => 'سابقه::ارسال اعلان به کارشناس',
        'History::SendCustomerNotification' => 'سابقه::ارسال اعلان به مشترک',
        'History::EmailAgent' => 'سابقه::email کارشناس',
        'History::EmailCustomer' => 'سابقه::email مشترک',
        'History::PhoneCallAgent' => 'سابقه::تماسهای تلفنی کارشناس',
        'History::PhoneCallCustomer' => 'سابقه:: تماسهای تلفنی مشترک',
        'History::AddNote' => 'سابقه::افزودن یادداشت',
        'History::Lock' => 'سابقه::در اختیار گرفتن تیکت',
        'History::Unlock' => 'سابقه::آزاد کردن تیکت',
        'History::TimeAccounting' => 'سابقه::حسابرسی زمان',
        'History::Remove' => 'سابقه::حذف تیکت',
        'History::CustomerUpdate' => 'سابقه::بروزرسانی مشترک',
        'History::PriorityUpdate' => 'سابقه::بروزرسانی اولویت',
        'History::OwnerUpdate' => 'سابقه::بروزرسانی صاحب تیکت',
        'History::LoopProtection' => 'سابقه::حفاظت گردشی',
        'History::Misc' => 'سابقه::سایر',
        'History::SetPendingTime' => 'سابقه::تنظیم زمان تعلیق',
        'History::StateUpdate' => 'سابقه::بروزرسانی وضعیت',
        'History::TicketFreeTextUpdate' => 'سابقه::بروزرسانی تیکت متن',
        'History::WebRequestCustomer' => 'سابقه::درخواست از طریق وب مشترک',
        'History::TicketLinkAdd' => 'سابقه::لینک تیکت افزودن',
        'History::TicketLinkDelete' => 'سابقه::لینک تیکت حذف',

        # Template: AAAWeekDay
        'Sun' => 'یک شنبه',
        'Mon' => 'دوشنبه',
        'Tue' => 'سه شنبه',
        'Wed' => 'چهارشنبه',
        'Thu' => 'پنجشنبه',
        'Fri' => 'جمعه',
        'Sat' => 'شنبه',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'مدیریت پیوست ها',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'مدیریت پاسخ خودکار',
        'Response' => 'پاسخ',
        'Auto Response From' => 'ارسال کننده پاسخ خودکار',
        'Note' => 'یادداشت',
        'Useable options' => 'گزینه های قابل استفاده',
        'To get the first 20 character of the subject.' => '',
        'To get the first 5 lines of the email.' => '',
        'To get the realname of the sender (if given).' => '',
        'To get the article attribut (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => '',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => '',
        'Add Customer Company' => '',
        'Add a new Customer Company.' => '',
        'List' => '',
        'This values are required.' => 'این مقادیر مورد نیاز هستند.',
        'This values are read only.' => 'این مقادیر فقط قابل خواندن هستند.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'مدیریت مشترکین',
        'Search for' => 'جستجو برای',
        'Add Customer User' => '',
        'Source' => 'منبع',
        'Create' => '',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'نام کاربری مشترکین برای ورود به سیستم مورد استفاده قرار خوهد گرفت',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'مدیریت مشترک <-> گروه',
        'Change %s settings' => 'تغییر تنظیمات %s',
        'Select the user:group permissions.' => 'حقوق دسترسی کاربر:گروه را انتخاب نمائید',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'اگر هیچ گزینه ای انتخاب نشده باشد دسترسی به تیکت ها برای این گروه امکانپذیر نخواهد بود.',
        'Permission' => 'حقوق دسترسی',
        'ro' => 'فقط خواندنی',
        'Read only access to the ticket in this group/queue.' => 'حق فقط خواندنی برای تیکت ها در این گروه /لیست.',
        'rw' => 'خواندنی و نوشتنی',
        'Full read and write access to the tickets in this group/queue.' => 'دسترسی کامل به تیکت ها در این لیست / گروه.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminEmail
        'Message sent to' => 'ارسال پیام به',
        'Recipents' => 'گیرنده',
        'Body' => 'متن نامه',
        'Send' => '',

        # Template: AdminGenericAgent
        'GenericAgent' => 'کارشناس عمومی',
        'Job-List' => 'لیست کارها',
        'Last run' => 'آخرین اجرا',
        'Run Now!' => 'اجرا کن',
        'x' => '*',
        'Save Job as?' => 'کار را ذخیره کن با عنوان',
        'Is Job Valid?' => 'کار معتبر است؟',
        'Is Job Valid' => 'کار معتبر است',
        'Schedule' => 'زمان بندی',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'جستجوی متنی در موارد قبلی',
        '(e. g. 10*5155 or 105658*)' => '(مثال: 10*5155 یا 105658*)',
        '(e. g. 234321)' => '(مثال: 234321)',
        'Customer User Login' => 'ورود مشترکین به سیستم',
        '(e. g. U5150)' => '(مثال: U5150)',
        'Agent' => 'کارشناس',
        'Ticket Lock' => 'در اختیار دارنده تیکت',
        'TicketFreeFields' => '',
        'Create Times' => '',
        'No create time settings.' => '',
        'Ticket created' => 'تاریخ ایجاد تیکت',
        'Ticket created between' => 'دوره ایجاد تیکت',
        'Pending Times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'New Priority' => 'اولویت جدید',
        'New Queue' => 'لیست تیکت جدید',
        'New State' => 'وضعیت جدید',
        'New Agent' => 'کارشناس جدید',
        'New Owner' => 'صاحب جدید',
        'New Customer' => 'مشترک جدید',
        'New Ticket Lock' => 'در اختیار دارنده جدید',
        'CustomerUser' => 'مشترک',
        'New TicketFreeFields' => '',
        'Add Note' => 'افزودن یادداشت',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'این دستور اجرا خواهد شد. ARG[0] شماره تیکت و ARG[1] id آن خواهد بود.',
        'Delete tickets' => 'حذف تیکت ها',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'توجه !این تیکت ها از بانک حذف خواهد شد . ',
        'Send Notification' => '',
        'Param 1' => 'پارامتر 1',
        'Param 2' => 'پارامتر 2',
        'Param 3' => 'پارامتر 3',
        'Param 4' => 'پارامتر 4',
        'Param 5' => 'پارامتر 5',
        'Param 6' => 'پارامتر 6',
        'Send no notifications' => '',
        'Yes means, send no agent and customer notifications on changes.' => '',
        'No means, send agent and customer notifications on changes.' => '',
        'Save' => 'ذخیره',
        '%s Tickets affected! Do you really want to use this job?' => '',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'مدیریت گروه ها',
        'Add Group' => '',
        'Add a new Group.' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'گروه admin برای دسترسی به محیط مدیریت سیستم میباشد.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Créer de nouveaux groupes permettra de gérer les droits d\'accès pour les différents groupes du technicien (exemple: achats, comptabilité, support, ventes...).',
        'It\'s useful for ASP solutions.' => 'این مورد برای راه حل های ASP مناسب میباشد.',

        # Template: AdminLog
        'System Log' => 'گزارش سیستم',
        'Time' => 'زمان',

        # Template: AdminNavigationBar
        'Users' => 'کاربر ها',
        'Groups' => 'گروه ها',
        'Misc' => 'سایر',

        # Template: AdminNotificationForm
        'Notification Management' => 'مدیریت اعلان ها',
        'Notification' => 'اعلان',
        'Notifications are sent to an agent or a customer.' => 'اعلان به یک کارشناس یا مشترک ارسال شد.',

        # Template: AdminPackageManager
        'Package Manager' => 'مدیریت بسته ها',
        'Uninstall' => 'حذف بسته',
        'Version' => 'ویرایش',
        'Do you really want to uninstall this package?' => 'از حذف این بسته اطمینان دارید؟',
        'Reinstall' => 'نصب مجدد',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '',
        'Cancle' => '',
        'Continue' => '',
        'Install' => 'نصب',
        'Package' => 'بسته',
        'Online Repository' => 'منبع آن لاین',
        'Vendor' => 'فروشنده',
        'Upgrade' => 'بروزرسانی',
        'Local Repository' => 'منبع محلی',
        'Status' => 'وضعیت',
        'Overview' => 'پیش نمایش',
        'Download' => 'دریافت',
        'Rebuild' => 'ساخت مجدد',
        'ChangeLog' => '',
        'Date' => '',
        'Filelist' => '',
        'Download file from package!' => '',
        'Required' => '',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => '',
        'This feature is enabled!' => '',
        'Just use this feature if you want to log each request.' => '',
        'Of couse this feature will take some system performance it self!' => '',
        'Disable it here!' => '',
        'This feature is disabled!' => '',
        'Enable it here!' => '',
        'Logfile too large!' => '',
        'Logfile too large, you need to reset it!' => '',
        'Range' => '',
        'Interface' => '',
        'Requests' => '',
        'Min Response' => '',
        'Max Response' => '',
        'Average Response' => '',

        # Template: AdminPGPForm
        'PGP Management' => 'مدیریت رمزگذاری',
        'Result' => 'نتیجه',
        'Identifier' => 'کد ملی',
        'Bit' => 'بیت',
        'Key' => 'کلید',
        'Fingerprint' => 'اثر انگشت',
        'Expires' => 'باطل',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'از این طریق شما میتوانید مستقیما کلید های خود را درسیستم تنظیم نمائید',

        # Template: AdminPOP3
        'POP3 Account Management' => 'مدیریت POP3',
        'Host' => 'سرور',
        'Trusted' => 'مجاز',
        'Dispatching' => 'توزیع',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'همه نامه ها از طریق یک آدرس به لیست تیکت ها منتقل خواهد شد !',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'درصورتیکه آدرس شما مجاز و قابل اطمینان باشد زمان دریافت در header سیستم اولویل را تعیین کرده و پیام ها ارسال خواهد شد',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'مدیریت فیلتر پستی',
        'Filtername' => 'نام فیلتر',
        'Match' => 'مطابقت',
        'Header' => '',
        'Value' => 'مقدار',
        'Set' => 'ثبت',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'email ها را از طریق Header یا RegExp فیلتر کن.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'اگر از RegExp استفاده میکنید میتوانید از مقادیر مطابق در () بعنوان[***] در ثبت استفاده نمائید',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'مدیریت لیست <-> پاسخ خودکار',

        # Template: AdminQueueForm
        'Queue Management' => 'مدیریت لییت های تیکت',
        'Sub-Queue of' => 'لیست فرعی',
        'Unlock timeout' => 'مهلت آزاد شدن تیکت',
        '0 = no unlock' => '0 = آزاد نشود',
        'Escalation - First Response Time' => '',
        '0 = no escalation' => '0 = بدون جابجایی',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Follow up Option' => 'گزینه پیگیری',
        'Ticket lock after a follow up' => 'تیکت بعد از پیگیری در اختیار قرارگیرد',
        'Systemaddress' => 'آدرس سیستمی',
        'Customer Move Notify' => 'اعلان انتقال به مشترک',
        'Customer State Notify' => 'اعلان وضعیت به مشترک',
        'Customer Owner Notify' => 'اعلان صاحب به مشترک',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'اگر یک کارشناس تیکت را در اختیار بگیرد و در این مدت زمان نتواند به آن پاسخ دهد تیکت آزاد شده و به لیست باز میگردد و قابل دسترس سایر کارشناسان خواهد شد',
        'Escalation time' => 'زمان جابجایی',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'اگر این تیکت پاسخ داده نشود فقط این تیکت نمایش داده شود',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'اگر یک تیکت بسته شود و مشترک دوباره آنرا پیگیری کند بطور خودکار دراختیار صاحب تیکت قرار خواهد گرفت',
        'Will be the sender address of this queue for email answers.' => 'آدرس ارسال کننده این لیست برای پاسخ email استفاده خواهد شد.',
        'The salutation for email answers.' => 'عنوان نام برای پاسخ email',
        'The signature for email answers.' => 'امضاء email پاسخ',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'اگر تیکت به شخص دیگری منتقل شد سیستم با Email اطلاع خواهد داد.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'اگر وضعیت تیکت تغییر کرد سیستم با Email اطلاع خواهد داد',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'اگر صاحب تیکت تغییر کرد سیستم با Email اطلاع خواهد داد.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'مدیریت لیست <-> پاسخ',

        # Template: AdminQueueResponsesForm
        'Answer' => 'پاسخ',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'مدیریت پاسخ <-> پیوست',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'مدیریت پاسخ ها',
        'A response is default text to write faster answer (with default text) to customers.' => 'یک پاسخ متنی است که برای تسریع در پاسخگویی به مشترکین ارسال میشود.',
        'Don\'t forget to add a new response a queue!' => 'فراموش نکنید که یک پاسخ به لیست اضافه کنید !',
        'The current ticket state is' => 'وضعیت فعلی تیکت',
        'Your email address is new' => 'آدرس Email شما جدید شد.',

        # Template: AdminRoleForm
        'Role Management' => 'مدیریت وظایف',
        'Add Role' => '',
        'Add a new Role.' => '',
        'Create a role and put groups in it. Then add the role to the users.' => 'ایجاد یک وظیفه.ابتدا گروه را در آن قرار بده سپس کاربرها را به آن اضافه کن',
        'It\'s useful for a lot of users and groups.' => 'این برای اکثر کاربران و گروه ها قابل استفاده است',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'مدیریت وظیفه <-> گروه',
        'move_into' => 'انتقال به',
        'Permissions to move tickets into this group/queue.' => 'مجوز انتقال تیکت به این گروه/لیست.',
        'create' => 'créer',
        'Permissions to create tickets in this group/queue.' => 'مجوز ایجاد تیکت در این گروه/لیست.',
        'owner' => 'صاحب',
        'Permissions to change the ticket owner in this group/queue.' => 'مجوز تغییرتیکت در این گروه/لیست.',
        'priority' => 'اولویت',
        'Permissions to change the ticket priority in this group/queue.' => 'مجوز تغییر اولویت تیکت در این گروه/لیست.',

        # Template: AdminRoleGroupForm
        'Role' => 'وظیفه',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'مدیریت کاربران <-> وظیفه',
        'Active' => 'Actif',
        'Select the role:user relations.' => 'ارتبتط هر کاربر را با وظیفه مربوط به آن مشخص کنید',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'مدیریت عنوان ها',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'Select Box' => 'باکس انتخاب.',
        'Limit' => 'محدوده',
        'Go' => '',
        'Select Box Result' => 'نتیجه باکس انتخاب',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => '',
        'Add a new Service.' => '',
        'Service' => '',
        'Sub-Service of' => '',

        # Template: AdminSession
        'Session Management' => 'مدیریت Session ها',
        'Sessions' => 'Session ها',
        'Uniq' => 'واحد',
        'Kill all sessions' => '',
        'Session' => '',
        'Content' => 'تماس',
        'kill session' => 'session را از بین ببر',

        # Template: AdminSignatureForm
        'Signature Management' => 'مدیریت امضاء',
        'Add Signature' => '',
        'Add a new Signature.' => '',

        # Template: AdminSLA
        'SLA Management' => '',
        'Add SLA' => '',
        'Add a new SLA.' => '',
        'SLA' => '',
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'مدیریت S/MIME',
        'Add Certificate' => 'افزودن Certificate',
        'Add Private Key' => 'افزودن کلید خصوصی',
        'Secret' => 'رمز',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => 'از این طریق شما میتوانید کلید های رمز خود را برای رمز گذاری نامه ها و پیامها به سیستم وارد نمائید',

        # Template: AdminStateForm
        'State Management' => '',
        'Add State' => '',
        'Add a new State.' => '',
        'State Type' => 'نوع وضعیت',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'دقت کنید که حتما وضعیت پیشفرض را در Kernel/Config.pm ذخیره کرده باشید.',
        'See also' => 'همچنین ببنید',

        # Template: AdminSysConfig
        'SysConfig' => 'تنظیم سیستم',
        'Group selection' => 'انتخاب گروه',
        'Show' => 'نمایش',
        'Download Settings' => 'دریافت تنظیمات',
        'Download all system config changes.' => 'دریافت همه تغیرات سیستم',
        'Load Settings' => 'بازیابی تنظیمات',
        'Subgroup' => 'زیرگروه',
        'Elements' => 'قسمت',

        # Template: AdminSysConfigEdit
        'Config Options' => 'انتخاب هاب تنظیم',
        'Default' => 'پیش فرض',
        'New' => 'جدید',
        'New Group' => 'گروه جدید',
        'Group Ro' => 'گروه فقط خواندنی',
        'New Group Ro' => 'گروه جدید فقط خواندنی',
        'NavBarName' => 'نام میله کنترل',
        'NavBar' => 'میله کنترل',
        'Image' => 'تصویر',
        'Prio' => 'اولویت',
        'Block' => 'بسته',
        'AccessKey' => 'کلید دسترسی',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'مدیریت آدرسهای Email سیستم',
        'Add System Address' => '',
        'Add a new System Address.' => '',
        'Realname' => 'نام و نام خانوادگی',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'همه نامه ها با گیرنده مشخص شده به لیست انتخاب شده منتقل خواهد شد!',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'مدیریت کاربران',
        'Add User' => '',
        'Add a new Agent.' => '',
        'Login as' => '',
        'Firstname' => 'نام',
        'Lastname' => 'نام خانوادگی',
        'User will be needed to handle tickets.' => 'کاربر نیاز خواهد داشت که تیکت ها را کنترل کند.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'فراموش نکنید که کاربر میبایست به گروه و وظیفه مربوطه لینک شود',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'مدیریت کاربر <-> گروه',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'دفترچه  آدرس و تماسها',
        'Return to the compose screen' => 'بازگشت به صفحه ارسال',
        'Discard all changes and return to the compose screen' => 'همه تغییرات را نادیده بگیر و به صفحه ارسال بازگرد',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'اطلاعات',

        # Template: AgentLinkObject
        'Link Object' => 'لینک',
        'Select' => 'انتخاب',
        'Results' => 'نتیجه',
        'Total hits' => 'همه بازدید ها',
        'Page' => 'صفحه',
        'Detail' => 'جزئیات',

        # Template: AgentLookup
        'Lookup' => 'بررسی',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'غلط یاب',
        'spelling error(s)' => 'خطاهای غلط یابی',
        'or' => 'یا',
        'Apply these changes' => 'این تغییرات را در نظر بگبر',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'آیا واقعا قصد حذف این مورد را دارید؟',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '',
        'Fixed' => '',
        'Please select only one Element or turn of the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => '',
        'Relative Period' => '',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributs of the corresponding element.' => '',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '',
        'Permissions' => '',
        'Format' => 'فرمت',
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
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '',
        'maximal period' => '',
        'minimal scale' => '',
        'Here you can define the x-axis. You can select one element via the radio button. Than you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => '',
        'File is not a Stats config' => '',
        'No File selected' => '',

        # Template: AgentStatsOverview
        'Object' => '',

        # Template: AgentStatsPrint
        'Print' => 'چاپ',
        'No Element selected.' => '',

        # Template: AgentStatsView
        'Export Config' => '',
        'Informations about the Stat' => '',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => '',
        'maximal period from' => '',
        'to' => '',
        'Start' => '',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'تیکت ارجاعی',
        'Ticket locked!' => 'تیکت در اختیار !',
        'Ticket unlock!' => 'تیکت آزاد !',
        'Bounce to' => 'ارجاع شده به',
        'Next ticket state' => 'وضعیت بعدی تیکت',
        'Inform sender' => 'به ارسال کننده اطلاع بده',
        'Send mail!' => 'ارسال نامه !',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'تیکت عملیات کلی',
        'Spell Check' => 'غلط یابی',
        'Note type' => 'نوع یادداشت',
        'Unlock Tickets' => 'تیکت های آزاد',

        # Template: AgentTicketClose
        'Close ticket' => 'بستن تیکت',
        'Previous Owner' => 'صاحب قبلی',
        'Inform Agent' => 'اطلاع به کارشناس',
        'Optional' => 'اختیاری',
        'Inform involved Agents' => 'اطلاع به کارشناسان مربوطه',
        'Attach' => 'پیوست',
        'Next state' => 'وضعیت بعدی',
        'Pending date' => 'تاریخ تعلیق',
        'Time units' => 'واحد زمان',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'ارسال پاسخ به تیکت',
        'Pending Date' => 'مهلت تعلیق',
        'for pending* states' => 'برای وضعیت تعلیق',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'تغییر مشترک تیکت',
        'Set customer user and customer id of a ticket' => 'ثبت نام و کد مشترک در تیکت.',
        'Customer User' => 'مشترک',
        'Search Customer' => 'جستجوی مشترک',
        'Customer Data' => 'اطلاعات مشترک',
        'Customer history' => 'سوابق مشترک',
        'All customer tickets.' => 'همه تیکت های مشترک',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'پیگیری',

        # Template: AgentTicketEmail
        'Compose Email' => 'ارسال Email',
        'new ticket' => 'تیکت جدید',
        'Refresh' => '',
        'Clear To' => 'آزاد کن به',

        # Template: AgentTicketForward
        'Article type' => 'نوع مورد',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'تغییر متن تیکت',

        # Template: AgentTicketHistory
        'History of' => 'سوابق',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'صندوق نامه ها',
        'Tickets' => 'تیکت ها',
        'of' => ' ',
        'Filter' => '',
        'New messages' => 'پیام جدید',
        'Reminder' => 'یادآوری',
        'Sort by' => 'مرتب سازی بر حسب',
        'Order' => 'ترتیب',
        'up' => 'صعودی',
        'down' => 'نزولی',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'ادغام تیکت',
        'Merge to' => 'ادغام با',

        # Template: AgentTicketMove
        'Move Ticket' => 'انتقال تیکت',

        # Template: AgentTicketNote
        'Add note to ticket' => 'افزودن یادداشت به تیکت',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'تغییر صاحب تیکت',

        # Template: AgentTicketPending
        'Set Pending' => 'ثبت تعلیق',

        # Template: AgentTicketPhone
        'Phone call' => 'تماس تلفنی',
        'Clear From' => 'ورود مجدد اطلاعات',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'ساده',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'اطلاعات تیکت',
        'Accounted time' => 'زمان محاسبه شده',
        'Escalation in' => 'جابجایی در',
        'Linked-Object' => 'لینک',
        'Parent-Object' => 'اصلی',
        'Child-Object' => 'فرعی',
        'by' => 'بوسیله',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'غییر اولویت تیکت',

        # Template: AgentTicketQueue
        'Tickets shown' => 'نمایش تیکت',
        'Tickets available' => 'تیکت موجود',
        'All tickets' => 'همه تیکت ها',
        'Queues' => 'لیست ها',
        'Ticket escalation!' => 'جابجایی تیکت !',

        # Template: AgentTicketQueueTicketView
        'Service Time' => '',
        'Your own Ticket' => 'تیکت شما',
        'Compose Follow up' => 'ارسال پیگیری',
        'Compose Answer' => 'ارسال پاسخ',
        'Contact customer' => 'تماس با مشترک',
        'Change queue' => 'تغییر لیست تیکت',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => '',

        # Template: AgentTicketSearch
        'Ticket Search' => 'جستجوی تیکت',
        'Profile' => 'اطلاعات',
        'Search-Template' => 'الگوی جستجو',
        'TicketFreeText' => 'متن تیکت',
        'Created in Queue' => 'ایجاد در لیست',
        'Result Form' => 'نوع نتیجه',
        'Save Search-Profile as Template?' => 'ذخیره بعنوان الگوی جستجو?',
        'Yes, save it with name' => 'بله آنرا ذخیره کن با نام',

        # Template: AgentTicketSearchResult
        'Search Result' => 'نتیجه جستجو',
        'Change search options' => 'تغییر گزینه های جستجو',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort
        'U' => 'Z-A, ی-الف',
        'D' => 'A-Z, الف-ی',

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'نمایش وضعیت تیکت',
        'Open Tickets' => 'تیکت های باز',
        'Locked' => 'در اختیار',

        # Template: AgentTicketZoom

        # Template: AgentWindowTab

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'بازبینی',

        # Template: CustomerFooter
        'Powered by' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'ورود به سیستم',
        'Lost your password?' => 'رمز عبور خود را فراموش کرده اید؟',
        'Request new password' => 'درخواست رمز عبور جدید',
        'Create Account' => 'ثبت نام',

        # Template: CustomerNavigationBar
        'Welcome %s' => '%s به سیستم خوش آمدید',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'زمان',
        'No time settings.' => 'بدون تنظیمات زمان',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'برای گزارش یک اشکال اینجا کلیک کنید !',

        # Template: Footer
        'Top of Page' => 'بالای صفحه',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Installeur Web',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Administrateur',
        'Admin-Password' => '',
        'your MySQL DB should have a root password! Default is empty!' => 'Votre base MySQL doit avoir un mot de passe root ! Par défaut cela est vide !',
        'Database-User' => '',
        'default \'hot\'' => 'hôte par défaut',
        'DB connect host' => '',
        'Database' => '',
        'false' => '',
        'SystemID' => 'ID Système',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(L\'identité du système. Chaque numéro de ticket et chaque id de session http commence avec ce nombre)',
        'System FQDN' => 'Nom de Domaine complet du système',
        '(Full qualified domain name of your system)' => '(Nom de domaine complet de votre machine)',
        'AdminEmail' => 'Courriel de l\'administrateur.',
        '(Email of the system admin)' => '(Adresse de l\'administrateur système)',
        'Organization' => 'Société',
        'Log' => '',
        'LogModule' => 'Module de log',
        '(Used log backend)' => '(Backend de log utilisé)',
        'Logfile' => 'fichier de log',
        '(Logfile just needed for File-LogModule!)' => '(fichier de log nécessaire pour le Module File-Log !)',
        'Webfrontend' => 'Frontal web',
        'Default Charset' => 'Charset par défaut',
        'Use utf-8 it your database supports it!' => 'Utilisez UTF-8 si votre base de donnée le supporte !',
        'Default Language' => 'Langage par défaut ',
        '(Used default language)' => '(Langage par défaut utilisé)',
        'CheckMXRecord' => 'Vérifier les enregistrements MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Verifie les enregistrements MX des adresses électroniques utilisées lors de la rédaction d\'une réponse. N\'utilisez pas la "Vérification des enregistrements MX" si votre serveur OTRS est derrière une ligne modem $!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Pour pouvoir utiliser OTRS, vous devez entrer les commandes suivantes dans votre terminal en tant que root.',
        'Restart your webserver' => 'Redémarrer votre serveur web',
        'After doing so your OTRS is up and running.' => 'Après avoir fait ceci votre OTRS est en service',
        'Start page' => 'Page de démarrage',
        'Have a lot of fun!' => 'Amusez vous bien !',
        'Your OTRS Team' => 'Votre ةquipe OTRS',

        # Template: Login
        'Welcome to %s' => '',

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'حق دسترسی کافی نیست',

        # Template: Notify
        'Important' => 'مهم',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'چاپ شده بوسیله  :',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'صفحه آزمایش سیستم',
        'Counter' => 'شمارنده',

        # Template: Warning
        # Misc
        'Edit Article' => '',
        'Create Database' => 'ÃÂ§ÃÂÃÂ¬ÃÂ§ÃÂ¯ ÃÂ¨ÃÂ§ÃÂÃÂ©',
        'DB Host' => 'ÃÂ³ÃÂ±ÃÂÃÂ± ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂªÃÂ',
        'Change roles <-> groups settings' => 'ÃÂªÃÂºÃÂÃÂ± ÃÂªÃÂÃÂ¸ÃÂÃÂÃÂ§ÃÂª ÃÂÃÂ¸ÃÂÃÂÃÂ <-> ÃÂ¯ÃÂ±ÃÂÃÂ',
        'Ticket Number Generator' => 'ÃÂªÃÂÃÂÃÂÃÂ¯ ÃÂ©ÃÂÃÂÃÂ¯ÃÂ ÃÂ´ÃÂÃÂ§ÃÂ±ÃÂ ÃÂªÃÂÃÂ©ÃÂª ÃÂÃÂ§',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(ÃÂÃÂ´ÃÂ®ÃÂµÃÂ ÃÂªÃÂÃÂ©ÃÂª ÃÂÃÂ§. ÃÂ§ÃÂ©ÃÂ«ÃÂ± ÃÂ©ÃÂ§ÃÂ±ÃÂ¨ÃÂ±ÃÂ§ÃÂ ÃÂÃÂ§ÃÂÃÂÃÂÃÂ¯ÃÂ§ÃÂ² ÃÂ§ÃÂÃÂ ÃÂªÃÂ±ÃÂ©ÃÂÃÂ¨ ÃÂ§ÃÂ³ÃÂªÃÂÃÂ§ÃÂ¯ÃÂ ÃÂ©ÃÂÃÂÃÂ¯ ÃÂÃÂ«ÃÂ§ÃÂ: \'ÃÂ´ÃÂÃÂ§ÃÂ±ÃÂ ÃÂªÃÂÃÂ©ÃÂª\', \'ÃÂÃÂ§ÃÂ ÃÂ´ÃÂ±ÃÂ©ÃÂª#\' ÃÂÃÂ§ \'ÃÂÃÂ§ÃÂ ÃÂ¯ÃÂÃÂ®ÃÂÃÂ§ÃÂ #\')',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'ÃÂªÃÂÃÂ¸ÃÂÃÂ ÃÂÃÂ³ÃÂªÃÂÃÂÃÂ ÃÂ©ÃÂÃÂÃÂ¯ ÃÂÃÂ§ Kernel/Config.pm',
        'Create new Phone Ticket' => 'Ø§ÛØ¬Ø§Ø¯ ØªÛÚ©Øª ØªÙÙÙÛ',
        'Symptom' => 'ÃÂÃÂ´ÃÂ§ÃÂÃÂ',
        'A message should have a To: recipient!' => 'Ø¢Ø¯Ø±Ø³ Ø¯Ø±ÛØ§ÙØª Ú©ÙÙØ¯Ù Ù¾ÛØ§Ù ÙØ´Ø®Øµ ÙØ´Ø¯Ù Ø§Ø³Øª!',
        'Site' => 'ÃÂ³ÃÂ§ÃÂÃÂª',
        'Customer history search (e. g. "ID342425").' => 'ÃÂ¬ÃÂ³ÃÂªÃÂ¬ÃÂ ÃÂ¯ÃÂ± ÃÂ³ÃÂÃÂ§ÃÂ¨ÃÂ ÃÂÃÂ´ÃÂªÃÂ±ÃÂ© (ÃÂÃÂ«ÃÂ§ÃÂ: "ID342425")',
        'Close!' => 'ÃÂ¨ÃÂ³ÃÂªÃÂ!',
        'for agent firstname' => 'Ø¨Ø±Ø§Û ÙØ§Ù Ú©Ø§Ø±Ø´ÙØ§Ø³',
        'The message being composed has been closed.  Exiting.' => 'Ù¾ÛØ§ÙÛ Ú©Ù Ø§Ø±Ø³Ø§Ù Ø´Ø¯ Ø¨Ø³ØªÙ Ø´Ø¯.',
        'A web calendar' => 'ÛÚ© ØªÙÙÛÙ',
        'to get the realname of the sender (if given)' => 'Ø¨Ø±Ø§Û Ú¯Ø±ÙØªÙ ÙØ§Ù ÙØ±Ø³ØªÙØ¯Ù',
        'OTRS DB Name' => 'ÃÂÃÂ§ÃÂ ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂªÃÂ ÃÂ³ÃÂÃÂ³ÃÂªÃÂ',
        'Notification (Customer)' => '',
        'Select Source (for add)' => 'ÙÙØ¨Ø¹ Ø±Ø§ Ø§ÙØªØ®Ø§Ø¨ ÙÙØ§Ø¦ÛØ¯ (Ø¨Ø±Ø§Û Ø§ÙØ²ÙØ¯Ù)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Days' => 'ÃÂ±ÃÂÃÂ²',
        'Queue ID' => 'ÃÂ©ÃÂ¯ ÃÂÃÂÃÂ³ÃÂª',
        'Home' => 'ØµÙØ­Ù Ø§ÙÙ',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Ú¯Ø²ÛÙÙ ÙØ§Û ØªÙØ¸ÛÙØ§Øª ',
        'System History' => 'ÃÂ³ÃÂÃÂ§ÃÂ¨ÃÂ ÃÂ³ÃÂÃÂ³ÃÂªÃÂ',
        'customer realname' => 'ÙØ§Ù Ù ÙØ§Ù Ø®Ø§ÙÙØ§Ø¯Ú¯Û ÙØ´ØªØ±Ú©',
        'First Response' => '',
        'Pending messages' => 'Ù¾ÛØ§ÙÙØ§Û Ø¯Ø± ØªØ¹ÙÛÙ',
        'Modules' => 'ÃÂÃÂ§ÃÂÃÂÃÂ ÃÂÃÂ§',
        'for agent login' => 'Ø¨Ø±Ø§Û ÙØ±ÙØ¯ Ú©Ø§Ø±Ø´ÙØ§Ø³ Ø¨Ù Ø³ÛØ³ØªÙ',
        'Keyword' => 'ÃÂ©ÃÂÃÂÃÂ ÃÂ©ÃÂÃÂÃÂ¯ÃÂ',
        'Close type' => 'ÃÂÃÂÃÂ¹ ÃÂ¨ÃÂ³ÃÂªÃÂ',
        'DB Admin User' => 'ÃÂÃÂ§ÃÂ ÃÂ©ÃÂ§ÃÂ±ÃÂ¨ÃÂ±ÃÂ ÃÂÃÂ¯ÃÂÃÂ± ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂªÃÂ ',
        'for agent user id' => 'Ø¨Ø±Ø§Û Ú©Ø¯ Ú©Ø§Ø±Ø¨Ø±Û Ú©Ø§Ø±Ø´ÙØ§Ø³',
        'sort upward' => 'ØµØ¹ÙØ¯Û',
        'Change user <-> group settings' => 'ÃÂªÃÂºÃÂÃÂÃÂ± ÃÂªÃÂÃÂ¸ÃÂÃÂÃÂ§ÃÂª ÃÂ©ÃÂ§ÃÂ±ÃÂ¨ÃÂ± <-> ÃÂ¯ÃÂ±ÃÂÃÂ',
        'Problem' => 'ÃÂÃÂ´ÃÂ©ÃÂ',
        'next step' => 'ÃÂÃÂ¯ÃÂ ÃÂ¨ÃÂ¹ÃÂ¯ÃÂ',
        'Customer history search' => 'ÃÂ¬ÃÂ³ÃÂªÃÂ¬ÃÂ ÃÂ¯ÃÂ± ÃÂ³ÃÂÃÂ§ÃÂ¨ÃÂ ÃÂÃÂ´ÃÂªÃÂ±ÃÂ©',
        'Admin-Email' => 'e-mail ÃÂÃÂ¯ÃÂÃÂ± ÃÂ³ÃÂÃÂ³ÃÂªÃÂ',
        'Create new database' => 'ÃÂ§ÃÂÃÂ¬ÃÂ§ÃÂ¯ ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ¬ÃÂ¯ÃÂÃÂ¯',
        'A message must be spell checked!' => 'Ù¾ÛØ§Ù Ø¨Ø§ÛØ¯ ØºÙØ· ÛØ§Ø¨Û Ø´Ø¯Ù Ø¨Ø§Ø´Ø¯!',
        'Ticket#' => 'ÃÂ´ÃÂÃÂ§ÃÂ±ÃÂ ÃÂªÃÂÃÂ©ÃÂª',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Ù¾ÛØ§Ù Ø´ÙØ§ Ø¯Ø± ØªÛÚ©Øª Ø¨Ù Ø´ÙØ§Ø±Ù "<OTRS_TICKET> Ø§Ø±Ø¬Ø§Ø¹ Ø´Ø¯ Ø¨Ù "<OTRS_BOUNCE_TO>". Ø¨Ø±Ø§Û Ø§Ø·ÙØ§Ø¹Ø§Øª Ø¨ÛØ´ØªØ± Ø¨Ø§ Ø§ÛÙ Ø¢Ø¯Ø±Ø³ ØªÙØ§Ø³ Ø¨Ú¯ÛØ±ÛØ¯',
        'ArticleID' => 'شماره مورد',
        'A message should have a body!' => 'پیام میبایست دارای متن باشد !',
        'All Agents' => 'ÙÙÙ Ú©Ø§Ø±Ø´ÙØ§Ø³Ø§Ù',
        'Keywords' => 'ÃÂ©ÃÂÃÂÃÂ§ÃÂª ÃÂ©ÃÂÃÂÃÂ¯ÃÂ',
        'No * possible!' => 'ÃÂÃÂÃÂ * ÃÂÃÂÃÂ©ÃÂ ÃÂÃÂÃÂ³ÃÂª !',
        'Options ' => 'ÃÂ¯ÃÂ²ÃÂÃÂÃÂ ÃÂÃÂ§',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Message for new Owner' => 'ÃÂ¾ÃÂÃÂ§ÃÂ ÃÂ¨ÃÂ±ÃÂ§ÃÂ ÃÂµÃÂ§ÃÂ­ÃÂ¨ ÃÂ¬ÃÂ¯ÃÂÃÂ¯ ÃÂªÃÂÃÂ©ÃÂª',
        'to get the first 5 lines of the email' => 'Ø¨Ø±Ø§Û Ú¯Ø±ÙØªÙ 5 Ø®Ø· Ø§ÙÙ email',
        'OTRS DB Password' => 'ÃÂ±ÃÂÃÂ² ÃÂ¹ÃÂ¨ÃÂÃÂ± ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂªÃÂ ÃÂ³ÃÂÃÂ³ÃÂªÃÂ',
        'Last update' => 'ÃÂ¢ÃÂ®ÃÂ±ÃÂÃÂ ÃÂ¨ÃÂ±ÃÂÃÂ²ÃÂ±ÃÂ³ÃÂ§ÃÂÃÂ',
        'to get the first 20 character of the subject' => 'Ø¨Ø±Ø§Û Ú¯Ø±ÙØªÙ 20 Ú©Ø§Ø±Ø§Ú©ØªØ± Ø§ÙÙ ÙÙØ¶ÙØ¹',
        'DB Admin Password' => 'ÃÂ±ÃÂÃÂ² ÃÂ¹ÃÂ¨ÃÂÃÂ± ÃÂÃÂ¯ÃÂÃÂ± ÃÂ³ÃÂÃÂ³ÃÂªÃÂ',
        'Drop Database' => 'ÃÂ­ÃÂ°ÃÂ ÃÂ©ÃÂ§ÃÂÃÂ ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂªÃÂ',
        'Advisory' => 'ÙØ´ÙØ±ØªÛ',
        'FileManager' => 'ÙÛØ±ÛØª ÙØ§ÛÙ',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Ú¯Ø²ÛÙÙ ÙØ§Û ÙØ´ØªØ±Ú© ÙØ¹ÙÛ',
        'Pending type' => 'ÃÂÃÂÃÂ¹ ÃÂªÃÂ¹ÃÂÃÂÃÂ',
        'Comment (internal)' => 'ÃÂªÃÂÃÂ¶ÃÂÃÂ­ ÃÂ¯ÃÂ§ÃÂ®ÃÂÃÂ',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'This window must be called from compose window' => 'Ø§ÛÙ Ù¾ÙØ¬Ø±Ù ÙÛØ¨Ø§ÛØ³Øª Ø§Ø² Ø·Ø±ÛÙ Ù¾ÙØ¬Ø±Ù Ø§Ø±Ø³Ø§Ù ÙØ±Ø§Ø®ÙØ§ÙÛ Ø´ÙØ¯',
        'You need min. one selected Ticket!' => 'Ø´ÙØ§ Ø¯Ø³Øª Ú©Ù Ø¨Ù ÛÚ© ØªÛÚ©Øª Ø§ÙØªØ®Ø§Ø¨ Ø´Ø¯Ù ÙÛØ§Ø² Ø¯Ø§Ø±ÛØ¯!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Ú¯Ø²ÛÙÙ ÙØ§Û Ø§Ø·ÙØ§Ø¹Ø§Øª ØªÛÚ©Øª ÙØ§',
        '(Used ticket number format)' => '(ÃÂÃÂ±ÃÂÃÂª ÃÂ´ÃÂÃÂ§ÃÂ±ÃÂ ÃÂªÃÂÃÂ©ÃÂª)',
        'Fulltext' => 'ÃÂªÃÂÃÂ§ÃÂ ÃÂÃÂªÃÂ',
        'Incident' => 'Ø±ÙÛØ¯Ø§Ø¯',
        'OTRS DB connect host' => 'ÃÂ³ÃÂ±ÃÂÃÂ± ÃÂÃÂÃÂ²ÃÂ¨ÃÂ§ÃÂ ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂªÃÂ ',
        ' (work units)' => ' ÙØ§Ø­Ø¯ Ú©Ø§Ø±',
        'All Customer variables like defined in config option CustomerUser.' => 'ÙÙÙ ØªÙØ¸ÛÙØ§Øª ÙØ´ØªØ±Ú©ÛÙ Ø¯Ø± ÙØ§ÛÙ ØªÙØ¸ÛÙØ§Øª Ø³ÛØ³ØªÙ Ø°Ø®ÛØ±Ù Ø´Ø¯Ù Ø§Ø³Øª',
        'accept license' => 'Accepter la licence',
        'for agent lastname' => 'Ø¨Ø±Ø§Û ÙØ§Ù Ø®Ø§ÙÙØ§Ø¯Ú¯Û Ú©Ø§Ø±Ø´ÙØ§Ø³',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Ú¯Ø²ÛÙÙ ÙØ§Û ØªÙØ¸ÛÙØ§Øª ØµØ§Ø­Ø¨ ØªÛÚ©Øª',
        'Reminder messages' => 'Ù¾ÛØ§ÙÙØ§Û ÛØ§Ø¯Ø¢ÙØ±Û',
        'Change users <-> roles settings' => 'ÃÂªÃÂºÃÂÃÂÃÂ± ÃÂªÃÂÃÂ¸ÃÂÃÂÃÂ§ÃÂª ÃÂ©ÃÂ§ÃÂ±ÃÂ¨ÃÂ± <-> ÃÂÃÂ¸ÃÂÃÂÃÂ',
        'A message should have a subject!' => 'یک پیام میبایست دارای عنوان باشد',
        'TicketZoom' => 'ÃÂÃÂÃÂ§ÃÂÃÂ´ ÃÂ©ÃÂ§ÃÂÃÂ ÃÂªÃÂÃÂ©ÃÂª',
        'Don\'t forget to add a new user to groups!' => 'ÃÂÃÂ±ÃÂ§ÃÂÃÂÃÂ´ ÃÂÃÂ©ÃÂÃÂÃÂ¯ ÃÂ©ÃÂ ÃÂÃÂ© ÃÂ©ÃÂ§ÃÂ±ÃÂ¨ÃÂ± ÃÂ¨ÃÂ ÃÂ¯ÃÂ±ÃÂÃÂ ÃÂ§ÃÂÃÂ¬ÃÂ§ÃÂ¯ ÃÂ´ÃÂ¯ÃÂ ÃÂ§ÃÂ¶ÃÂ§ÃÂÃÂ ÃÂ©ÃÂÃÂÃÂ¯!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Ø¢Ø¯Ø±Ø³ email ÙØ§Ø±Ø¯ Ø´Ø¯Ù ÙØ¹ØªØ¨Ø± ÙÛØ³Øª!',
        'CreateTicket' => 'ÃÂ§ÃÂÃÂ¬ÃÂ§ÃÂ¯ ÃÂªÃÂÃÂ©ÃÂª',
        'You need to account time!' => 'شما نیاز به محاسبه زمان دارید!',
        'System Settings' => 'ÃÂªÃÂÃÂ¸ÃÂÃÂÃÂ§ÃÂª ÃÂ³ÃÂÃÂ³ÃÂªÃÂ',
        'WebWatcher' => 'Ø¨Ø§Ø²Ø±Ø³Û ÙØ¨',
        'Hours' => 'ÃÂ³ÃÂ§ÃÂ¹ÃÂª',
        'Finished' => 'ÃÂ¾ÃÂ§ÃÂÃÂ§ÃÂ ÃÂÃÂ§ÃÂÃÂª',
        'Split' => 'ÙØ³ÙØª Ú©Ø±Ø¯Ù ØªÛÚ©Øª',
        'All messages' => 'ÙÙÙ Ù¾ÛØ§Ù ÙØ§',
        'System Status' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Artefact' => 'ÙØ­ØµÙÙ',
        'A article should have a title!' => 'ÃÂÃÂ© ÃÂÃÂÃÂ±ÃÂ¯ ÃÂ¨ÃÂ§ÃÂÃÂ¯ ÃÂ¯ÃÂ§ÃÂ±ÃÂ§ÃÂ ÃÂ¹ÃÂÃÂÃÂ§ÃÂ ÃÂ¨ÃÂ§ÃÂ´ÃÂ¯',
        'Event' => '',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'don\'t accept license' => 'Ne pas accepter la licence',
        'A web mail client' => 'ÛÚ© ÙØ­ÛØ· Ù¾Ø³Øª Ø§ÙÚ©ØªØ±ÙÙÛÚ©Û',
        'WebMail' => 'Ù¾Ø³Øª Ø§ÙÚ©ØªØ±ÙÙÛÚ©Û ØªØ­Øª ÙØ¨',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'ÃÂ¯ÃÂ²ÃÂÃÂÃÂ ÃÂÃÂ§ÃÂ ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂª ÃÂªÃÂÃÂ©ÃÂª',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Options du propriÃ©taire d\'un ticket (ex: <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => 'ÃÂÃÂ§ÃÂ ÃÂÃÂÃÂ±ÃÂ¯ ÃÂÃÂÃÂ§ÃÂ² ÃÂ§ÃÂ³ÃÂª!',
        'DB Type' => 'ÃÂÃÂÃÂ¹ ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂªÃÂ ÃÂ³ÃÂÃÂ³ÃÂªÃÂ',
        'kill all sessions' => 'ÙÙÙ Session ÙØ§ Ø±Ø§ Ø§Ø² Ø¨ÛÙ Ø¨Ø¨Ø±',
        'to get the from line of the email' => 'Ø¨Ø±Ø§Û Ú¯Ø±ÙØªÙ Ø®Ø· (Ø§Ø²) email',
        'Solution' => 'ÃÂ±ÃÂ§ÃÂ ÃÂ­ÃÂ',
        'QueueView' => 'ÃÂÃÂÃÂ§ÃÂÃÂ´ ÃÂÃÂÃÂ³ÃÂª',
        'Welcome to OTRS' => 'Ø¨Ù Ø³ÛØ³ØªÙ Ù¾Ø´ØªÛØ¨Ø§ÙÛ Ø³ÙØ±Ø³ Ø¨Ø§Ø² Ø®ÙØ´ Ø¢ÙØ¯ÛØ¯',
        'modified' => 'ÃÂªÃÂºÃÂÃÂÃÂ± ÃÂÃÂ§ÃÂÃÂª',
        'Delete old database' => 'ÃÂ­ÃÂ°ÃÂ ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂÃÂ¨ÃÂÃÂ',
        'sort downward' => 'ÙØ²ÙÙÛ',
        'You need to use a ticket number!' => 'Ø´ÙØ§ Ø¨Ø§ÛØ¯ Ø§Ø² Ø´ÙØ§Ø±Ù ØªÛÚ©Øª Ø§Ø³ØªÙØ§Ø¯Ù ÙÙØ§Ø¦ÛØ¯!',
        'A web file manager' => 'ÛÚ© ÙØ­ÛØ· ÙØ¯ÛØ±ÛØª ÙØ§ÛÙ ØªØ­Øª ÙØ¨',
        'send' => 'Ø§Ø±Ø³Ø§Ù',
        'Note Text' => 'ÃÂÃÂ§ÃÂ¯ÃÂ¯ÃÂ§ÃÂ´ÃÂª',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => 'ÙØ¯ÛØ±ÛØª ÙØ¶Ø¹ÛØª Ø³ÛØ³ØªÙ',
        'OTRS DB User' => 'ÃÂÃÂ§ÃÂ ÃÂ©ÃÂ§ÃÂ±ÃÂ¨ÃÂ±ÃÂ ÃÂ¨ÃÂ§ÃÂÃÂ© ÃÂ§ÃÂ·ÃÂÃÂ§ÃÂ¹ÃÂ§ÃÂªÃÂ ÃÂ³ÃÂÃÂ³ÃÂªÃÂ',
        'PhoneView' => 'ÃÂÃÂÃÂ§ÃÂÃÂ´ ÃÂªÃÂÃÂÃÂ',
        'Verion' => 'ÃÂÃÂÃÂ±ÃÂ§ÃÂÃÂ´',
        'TicketID' => 'شماره تیکت',
        'Modified' => 'ÃÂªÃÂºÃÂÃÂÃÂ± ÃÂÃÂ§ÃÂÃÂªÃÂ',
        'Ticket selected for bulk action!' => 'ØªÛÚ©Øª Ø¬ÙØª Ø¹ÙÙÛØ§Øª Ú©ÙÛ Ø§ÙØªØ®Ø§Ø¨ Ú¯Ø±Ø¯ÛØ¯!',
    };
    # $$STOP$$
}

1;
