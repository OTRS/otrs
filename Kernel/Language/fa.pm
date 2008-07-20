# --
# Kernel/Language/fa.pm - provides fa language translation
# Copyright (C) 2006-2008 Amir Shams Parsa <amir at parsa.name>
# Copyright (C) 2008 Hooman Mesgary <info at mesgary.com>
# --
# $Id: fa.pm,v 1.42 2008-07-20 20:40:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::fa;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.42 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Tue July 15 15:36:24 2008

    # possible charsets
    $Self->{Charset} = ['utf-8', 'utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
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
        'second(s)' => 'ثانیه',
        'seconds' => 'ثانیه',
        'second' => 'ثانیه',
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
        '* invalid' => 'غیر معتبر',
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
        'Unlink' => 'حذف لینک',
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
        'Lite' => 'اولیه',
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
        'agent' => 'کارشناس پشتیبانی',
        'system' => 'سیستم',
        'Customer Info' => 'اطلاعات مشترک',
        'Customer Company' => 'شرکت/سازمان مشترک',
        'Company' => 'شرکت/سازمان',
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
        'Invalid Option!' => 'انتخاب نا معتبر',
        'Invalid time!' => 'زمان نا معتبر',
        'Invalid date!' => 'تاریخ نا معتبر',
        'Name' => 'نام',
        'Group' => 'گروه',
        'Description' => 'توضیحات',
        'description' => 'توضیحات',
        'Theme' => 'طرح زمینه',
        'Created' => 'ایجاد شد',
        'Created by' => 'ایجاد شده توسط',
        'Changed' => 'تغییر یافت',
        'Changed by' => 'تغییر یافته توسط',
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
        'Please answer this ticket(s) to get back to the normal queue view!' => 'لطفا برای بازگشت به نمایش عادی تیکت ها به این تیکت پاسخ دهید!',
        'You got new message!' => 'شما پیام جدیدی دریافت کرده اید !',
        'You have %s new message(s)!' => 'شما %s پیام جدید دارید !',
        'You have %s reminder ticket(s)!' => 'شما %s تیکت جهت یادآوری دارید !',
        'The recommended charset for your language is %s!' => 'Charset پیشنهادی برای زبان شما  %s است!',
        'Passwords doesn\'t match! Please try it again!' => 'رمز عبور ها یکسان نیست لطفا مجددا سعی نمائید!',
        'Password is already in use! Please use an other password!' => 'این رمز عبور در حال استفاده است لطفا آنرا تغییر دهید!',
        'Password is already used! Please use an other password!' => 'این رمز عبور در حال استفاده است لطفا آنرا تغییر دهید!',
        'You need to activate %s first to use it!' => 'شما برای استفاده  %s ابتدا میبایست آنرا فعال نمائید!',
        'No suggestions' => 'هیچ پیشنهادی وجود ندارد',
        'Word' => 'کلمه',
        'Ignore' => 'صرف نظر',
        'replace with' => 'جایگزین کن با',
        'There is no account with that login name.' => 'نام کاربری وارد شده موجود نیست',
        'Login failed! Your username or password was entered incorrectly.' => 'ورود ناموفق . اطلاعات وارد شده صحیح نیست.',
        'Please contact your admin' => 'لطفا با مدیر سیستم تماس بگیرید',
        'Logout successful. Thank you for using OTRS!' => 'خروج از سیستم با موفقیت انجام شد . از همراهی شما متشکریم.',
        'Invalid SessionID!' => 'شناسه Session  نا معتبر!',
        'Feature not active!' => 'این ویژگی فعال نیست.',
        'Login is needed!' => 'نیاز است به سیستم وارد شوید',
        'Password is needed!' => 'ورود رمز عبور الزامی است',
        'License' => 'مجوز بهره برداری سیستم',
        'Take this Customer' => 'این مشترک را بگیر',
        'Take this User' => 'این کاربر را بگیر',
        'possible' => 'امکانپذیر',
        'reject' => 'نپذیر',
        'reverse' => 'برگردان',
        'Facility' => 'سهولت',
        'Timeover' => 'وقت تمام شد',
        'Pending till' => 'تا زمانی که',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'با نام کاربری سیستم کار نکنید برای ادامه یک نام کاربری جدید بسازید.!',
        'Dispatching by email To: field.' => 'ارسال با پست الکترونیکی به:فیلد',
        'Dispatching by selected Queue.' => 'ارسال بوسیله لیست انتخاب شده',
        'No entry found!' => 'موردی پیدا نشد!',
        'Session has timed out. Please log in again.' => 'مهلت Session شما به اتمام رسید . لطفا مجددا وارد سیستم شوید..',
        'No Permission!' => 'دسترسی به این قسمت امکانپذیر نیست!',
        'To: (%s) replaced with database email!' => 'گیرنده: (%s) با آدرس e-mail موجود در بانک جایگزین شد!',
        'Cc: (%s) added database email!' => 'رونوشت: (%s)آدرس e-mail اضافه شد.',
        '(Click here to add)' => '(برای افزودن کلیک کنید)',
        'Preview' => 'پیش نمایش',
        'Package not correctly deployed! You should reinstall the Package again!' => 'نرم افزار بدرستی نصب نشده است، شما میبایست عملیات نصب را مجددا اجرا نمائید.',
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
        'Directory' => 'پوشه',
        'Signed' => 'امضاء شده',
        'Sign' => 'امضاء',
        'Crypted' => 'رمز گذاری شده',
        'Crypt' => 'رمز',
        'Office' => 'محل کار',
        'Phone' => 'تلفن',
        'Fax' => 'نمابر',
        'Mobile' => 'تلفن همراه',
        'Zip' => 'کد پستی',
        'City' => 'شهر',
        'Street' => 'استان',
        'Country' => 'کشور',
        'installed' => 'نصب شده',
        'uninstalled' => 'نصب نشده',
        'Security Note: You should activate %s because application is already running!' => 'نکته امنیتی:شما باید %s را فعال کنید زیرا نرم افزار در حال اجراست',
        'Unable to parse Online Repository index document!' => 'خطا در بازیابی مخزن نرم افزارها',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'برای Framework درخواست شده بسته ای وجود ندارد اما برای سایر Framework ها!',
        'No Packages or no new Packages in selected Online Repository!' => 'در مخزن انتخاب شده بسته جدیدی وجود ندارد',
        'printed at' => 'چاپ شده در',
        'Dear Mr. %s,' => 'جناب آقای %s',
        'Dear Mrs. %s,' => 'سرکار خانم %s',
        'Dear %s,' => '%s گرامی',
        'Hello %s,' => 'سلام %s',
        'This account exists.' => 'این حساب کاربری موجود است',
        'New account created. Sent Login-Account to %s.' => 'حساب کاربری جدید ایجاد شد.اطلاعات ورود به سیستم به %s ارسال شد.',
        'Please press Back and try again.' => 'کلید بازگشت را بزنید و دوباره سعی کنید',
        'Sent password token to: %s' => 'کد بازیابی رمز عبور به آدرس %s ارسال شد.',
        'Sent new password to: %s' => 'رمز عبور جدید به آدرس %s ارسال شد',
        'Invalid Token!' => 'کد بازیابی معتبر نیست',

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
        'January' => 'ژانویه',
        'February' => 'فوریه',
        'March' => 'مارس',
        'April' => 'آپریل',
        'June' => 'ژون',
        'July' => 'جولای',
        'August' => 'آگوست',
        'September' => 'سپتامبر',
        'October' => 'اکتبر',
        'November' => 'نوامبر',
        'December' => 'دسامبر',

        # Template: AAANavBar
        'Admin-Area' => 'بخش مدیریت',
        'Agent-Area' => 'بخش پشتیبانی',
        'Ticket-Area' => 'بخش درخواست',
        'Logout' => 'خروج ',
        'Agent Preferences' => 'تنظیمات بخش پشتیبانی',
        'Preferences' => 'تنظیمات',
        'Agent Mailbox' => 'صندوق پستی کارشناس پشتیبانی',
        'Stats' => 'وضعیت',
        'Stats-Area' => 'بخش نظارت ',
        'Admin' => 'مدیریت سیستم',
        'Customer Users' => 'مشترکین',
        'Customer Users <-> Groups' => 'مشترک <-> گروه',
        'Users <-> Groups' => 'کاربر <-> گروه',
        'Roles' => 'وظایف',
        'Roles <-> Users' => 'وظیفه <-> کابر',
        'Roles <-> Groups' => 'وظیفه <-> گروه',
        'Salutations' => 'عنوان',
        'Signatures' => 'امضاء',
        'Email Addresses' => 'آدرس e-mail',
        'Notifications' => 'اعلام ها',
        'Category Tree' => 'درخت دسته بندی',
        'Admin Notification' => 'اعلام مدیر سیستم',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'تنظیمات با موفقیت ثبت شد.!',
        'Mail Management' => 'مدیریت نامه ها',
        'Frontend' => 'رابط نمایشی',
        'Other Options' => 'سایر گزینه ها',
        'Change Password' => 'تغیر رمز عبور',
        'New password' => 'رمز عبور جدید',
        'New password again' => 'تکرار رمز عبور',
        'Select your QueueView refresh time.' => 'زمان بازیابی لیست را انتخاب نمائید',
        'Select your frontend language.' => 'زبان سیستم را انتخاب نمائید',
        'Select your frontend Charset.' => 'Charset خود را انتخاب نمائید',
        'Select your frontend Theme.' => 'الگوی نمایش سیستم را انتخاب نمائید',
        'Select your frontend QueueView.' => 'شیوه نمایش لیست را انتخاب نمائید',
        'Spelling Dictionary' => 'لغت نامه غلط یابی',
        'Select your default spelling dictionary.' => ' لغت نامه غلط یابی خود را انتخاب نمائید',
        'Max. shown Tickets a page in Overview.' => 'تعداد نمایش تیکت ها در نمای خلاصه',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'رمز های عبور وارد شده یکسان نیست!',
        'Can\'t update password, invalid characters!' => 'کاراکتر غیر مجاز !',
        'Can\'t update password, need min. 8 characters!' => 'طول رمز عبور معتبر 8 رقم است!',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'دست کم 2 حرف کوچک و 2 حرف بزرگ در رمز عبور خود استفاده نمائید!',
        'Can\'t update password, need min. 1 digit!' => 'دست کم 1 عدد در رمز عبور خود استفاده نمائید.!',
        'Can\'t update password, need min. 2 characters!' => 'دست کم 2 کاراکتر در رمز عبور خود استفاده نمائید.!',

        # Template: AAAStats
        'Stat' => 'آمار',
        'Please fill out the required fields!' => 'لطفا ستون های لازم را تکمیل نمائید',
        'Please select a file!' => 'لطفا یک فایل را انتخاب نمائید',
        'Please select an object!' => 'لطفا یک مورد را انتخاب نمائید',
        'Please select a graph size!' => 'لطفا اندازه نمودار را انتخاب نمائید',
        'Please select one element for the X-axis!' => 'لطفا محور افقی را انتخاب نمائید',
        'You have to select two or more attributes from the select field!' => 'از قسمت انتخاب ستون دست کم 2 مورد را انتخاب نمائید',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'لطفا فقط یک مورد را انتخاب نمائید یا دکمه \'  ثابت شده (Fixed) \'  را جایی که ستون را علامت میزنید خاموش نمائید',
        'If you use a checkbox you have to select some attributes of the select field!' => 'اگر گزینه ای را استفاده میکنید باید بعضی از مشخصات آنرا نیز وارد کنید',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'مقدار ستون را وارد نمائید و یا گزینه \'ثابت(Fixed)\'  را خاموش کنید.',
        'The selected end time is before the start time!' => 'زمان پایان انتخاب شده قبل از زمان شروع است',
        'You have to select one or more attributes from the select field!' => 'شما مجبور به انتخاب دست کم یکی از مشخصات ستون هستید',
        'The selected Date isn\'t valid!' => 'زمان انتخاب شده معتبر نیست',
        'Please select only one or two elements via the checkbox!' => 'یک یا دو مورد را در گزینه ها انتخاب نمائید',
        'If you use a time scale element you can only select one element!' => 'در صورتیکه از مقیاس زمان استفاده می کنید میتوانید فقط یک مورد را انتخاب نمائید',
        'You have an error in your time selection!' => 'خطا در انتخاب زمان',
        'Your reporting time interval is too small, please use a larger time scale!' => 'بازه زمانی گزارش خیلی کوتاه است',
        'The selected start time is before the allowed start time!' => 'زمان شروع انتخاب شده کمتر از حد مجاز است',
        'The selected end time is after the allowed end time!' => 'زمان پایان انتخاب شده بیشتر از حد مجاز است',
        'The selected time period is larger than the allowed time period!' => 'دوره زمانی انتخاب شده بزرگتر از حد مجاز است',
        'Common Specification' => 'مشخصات عمومی',
        'Xaxis' => 'محور افقی',
        'Value Series' => 'لیست مقادیر',
        'Restrictions' => 'محدوده',
        'graph-lines' => 'نمودار خطی',
        'graph-bars' => 'نمودار ستونی',
        'graph-hbars' => 'نمودار ستونی - افقی',
        'graph-points' => 'نمودار نقطه ای',
        'graph-lines-points' => 'نمودار نقطه ای خطی',
        'graph-area' => 'نمودار سطحی',
        'graph-pie' => 'نمودار دایره ای',
        'extended' => 'پیشرفته',
        'Agent/Owner' => 'کارشناس/صاحب',
        'Created by Agent/Owner' => 'ایجاد شده توسط کارشناس/صاحب',
        'Created Priority' => 'اولویت ایجاد',
        'Created State' => 'وضعیت ایجاد',
        'Create Time' => 'زمان ایجاد ',
        'CustomerUserLogin' => 'نام کاربری مشترک',
        'Close Time' => 'زمان بسته شدن',

        # Template: AAATicket
        'Lock' => 'تحویل گرفته شده',
        'Unlock' => 'آزاد',
        'History' => 'سابقه',
        'Zoom' => 'نمایش کامل',
        'Age' => 'مدت اعتبار',
        'Bounce' => 'ارجاع',
        'Forward' => 'ارسال به دیگری',
        'From' => 'فرستنده',
        'To' => 'گیرنده',
        'Cc' => 'رونوشت',
        'Bcc' => 'رونوشت پنهان',
        'Subject' => 'موضوع',
        'Move' => 'انتقال',
        'Queue' => 'لیست درخواست',
        'Priority' => 'اولویت',
        'Priority Update' => 'بروزرسانی توسط اولویت',
        'State' => 'وضعیت',
        'Compose' => 'ارسال',
        'Pending' => 'معلق',
        'Owner' => 'صاحب',
        'Owner Update' => 'بروز رسانی توسط صاحب',
        'Responsible' => 'مسئول',
        'Responsible Update' => 'بروزرسانی توسط مسئول',
        'Sender' => 'فرستنده',
        'Article' => 'مورد',
        'Ticket' => 'درخواست',
        'Createtime' => 'زمان ایجاد ',
        'plain' => 'ساده',
        'Email' => 'EMail',
        'email' => 'e-mail',
        'Close' => 'بستن',
        'Action' => 'فعالیت',
        'Attachment' => 'پیوست',
        'Attachments' => 'پیوست ها',
        'This message was written in a character set other than your own.' => 'این پیام با charset دیگری بجز charset  شما نوشته شده است.',
        'If it is not displayed correctly,' => 'اگر به درستی نمایش داده نشده است',
        'This is a' => 'این یک',
        'to open it in a new window.' => 'برای باز شدن در پنجره جدید',
        'This is a HTML email. Click here to show it.' => 'این یک نامه با فرمت HTML است برای نمایش اینجا کلیک کنید.',
        'Free Fields' => 'فیلد های آزاد',
        'Merge' => 'ادغام ',
        'merged' => 'ادغام شد',
        'closed successful' => 'با موفقیت بسته شد',
        'closed unsuccessful' => 'با موفقیت بسته نشد',
        'new' => 'جدید',
        'open' => 'باز',
        'closed' => 'بسته شده',
        'removed' => 'حذف شده',
        'pending reminder' => 'یادآوری حالت معلق',
        'pending auto' => 'حالت خودکار معلق',
        'pending auto close+' => 'حالت تعلیق-بستن خودکار(+)',
        'pending auto close-' => 'حالت تعلیق-بستن خودکار(-)',
        'email-external' => 'email-خارجی',
        'email-internal' => 'email-داخلی',
        'note-external' => 'یادداشت- خارجی',
        'note-internal' => 'یادداشت-داخلی',
        'note-report' => 'یادداشت-گزارش',
        'phone' => 'تلفن',
        'sms' => 'پیامک-SMS',
        'webrequest' => 'درخواست از طریق وب',
        'lock' => 'تحویل گرفته شده',
        'unlock' => 'آزاد',
        'very low' => 'خیلی پائین',
        'low' => 'پائین',
        'normal' => 'عادی',
        'high' => 'بالا',
        'very high' => 'خیلی بالا',
        '1 very low' => '1 خیلی پائین',
        '2 low' => '2 پائین',
        '3 normal' => 'عادی',
        '4 high' => '4 بالا',
        '5 very high' => '5 خیلی بالا',
        'Ticket "%s" created!' => 'درخواست %s ایجاد شد !',
        'Ticket Number' => 'شماره درخواست',
        'Ticket Object' => 'موضوع درخواست',
        'No such Ticket Number "%s"! Can\'t link it!' => 'این شماره درخواست وجود ندارد "%s"! نمایش امکانپذیر نیست',
        'Don\'t show closed Tickets' => 'درخواست های بسته شده را نمایش نده',
        'Show closed Tickets' => 'نمایش درخواست های بسته',
        'New Article' => 'مورد جدید',
        'Email-Ticket' => 'درخواست با Email',
        'Create new Email Ticket' => 'ایجاد درخواست با Email',
        'Phone-Ticket' => 'درخواست تلفنی',
        'Search Tickets' => 'جستجو در درخواست ها',
        'Edit Customer Users' => 'ویرایش مشترکین',
        'Edit Customer Company' => 'ویرایش شرکت/سازمان مشترک',
        'Bulk-Action' => 'اعمال کلی',
        'Bulk Actions on Tickets' => 'اعمال کلی روی درخواست ها',
        'Send Email and create a new Ticket' => 'ارسال email و ایجاد درخواست جدید',
        'Create new Email Ticket and send this out (Outbound)' => 'ایجاد درخواست جدید با Email و ارسال - بیرونی',
        'Create new Phone Ticket (Inbound)' => 'ایجاد درخواست جدید تلفنی- داخلی',
        'Overview of all open Tickets' => 'پیش نمایش همه درخواست های باز',
        'Locked Tickets' => 'درخواست های تحویل گرفته شده',
        'Watched Tickets' => 'درخواست های مشاهده شده',
        'Watched' => 'مشاهده شده',
        'Subscribe' => 'عضویت',
        'Unsubscribe' => 'لغو عضویت',
        'Lock it to work on it!' => 'برای کار روی درخواست آن را تحویل بگیرید',
        'Unlock to give it back to the queue!' => 'برای بازگرداندن درخواست به لیست آن را آزاد کنید',
        'Shows the ticket history!' => 'نمایش سابقه درخواست',
        'Print this ticket!' => 'این درخواست را چاپ کن',
        'Change the ticket priority!' => 'ویرایش اولویت درخواست',
        'Change the ticket free fields!' => 'تغییر فیلدهای خالی درخواست',
        'Link this ticket to an other objects!' => 'این درخواست را به مورد دیگری لینک کن',
        'Change the ticket owner!' => 'تغییر صاحب درخواست',
        'Change the ticket customer!' => 'تغییر مشترک درخواست',
        'Add a note to this ticket!' => 'افزودن یادداشت به درخواست',
        'Merge this ticket!' => 'ادغام این درخواست',
        'Set this ticket to pending!' => 'این درخواست را به حال معلق ببر',
        'Close this ticket!' => 'درخواست را ببند',
        'Look into a ticket!' => 'مشاهده درخواست',
        'Delete this ticket!' => 'حذف درخواست',
        'Mark as Spam!' => 'بعنوان SPAM علامت بزن',
        'My Queues' => 'لیست درخواست های من',
        'Shown Tickets' => 'درخواست های نمایش داده شده',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Email شما با شماره درخواست  "<OTRS_TICKET>" با درخواست "<OTRS_MERGE_TO_TICKET>"  ادغام گردید.',
        'Ticket %s: first response time is over (%s)!' => ' زمان اولین پاسخ برای درخواست %s: %s ',
        'Ticket %s: first response time will be over in %s!' => 'زمان اولین پاسخ به درخواست %s ،  %sخواهد بود.',
        'Ticket %s: update time is over (%s)!' => 'زمان بروزرسانی درخواست %s: %s',
        'Ticket %s: update time will be over in %s!' => 'زمان بروزرسانی درخواست %s ، %s خواهد بود',
        'Ticket %s: solution time is over (%s)!' => 'زمان ارائه راهکار برای درخواست %s : %s ',
        'Ticket %s: solution time will be over in %s!' => ' زمان ارائه راهکار برای درخواست %s ، %s خواهد بود ',
        'There are more escalated tickets!' => 'درخواست های زیادی وجود دارد',
        'New ticket notification' => 'اعلام درخواست جدید',
        'Send me a notification if there is a new ticket in "My Queues".' => 'دریافت تیکت جدید را به من اطلاع بده.',
        'Follow up notification' => 'اعلام پیگیری درخواست',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'در صورت ارسال یک پیگیری از طرف مشترک به من اطلاع بده.',
        'Ticket lock timeout notification' => 'پایان مهلت تحویل گرفتن درخواست را به من اطلاع بده',
        'Send me a notification if a ticket is unlocked by the system.' => 'اگر درخواست توسط سیستم آزاد شد به من اطلاع بده',
        'Move notification' => 'اعلام انتقال',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'انتقال یک درخواست به لیست درخواست های من را اطلاع بده.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'شما از طریق email از وضعیت لیست خود مطلع خواهید شد - در صورتیکه این گزینه در سیستم فعال باشد',
        'Custom Queue' => 'لیست سفارشی',
        'QueueView refresh time' => 'زمان بازیابی لیست درخواست ها',
        'Screen after new ticket' => 'وضعیت نمایش پس از دریافت درخواست جدید',
        'Select your screen after creating a new ticket.' => 'وضعیت نمایش را بعد از ایجاد درخواست جدید انتخاب کنید.',
        'Closed Tickets' => 'درخواست بسته شده',
        'Show closed tickets.' => 'نمایش درخواست های بسته',
        'Max. shown Tickets a page in QueueView.' => 'تعداد درخواست ها در صفحه نمایش',
        'CompanyTickets' => 'درخواست های شرکت',
        'MyTickets' => 'درخواست های من',
        'New Ticket' => 'درخواست جدید',
        'Create new Ticket' => 'ایجاد درخواست جدید',
        'Customer called' => 'مشترک تماس گرفته',
        'phone call' => 'تماس تلفنی',
        'Responses' => 'پاسخ ها',
        'Responses <-> Queue' => 'پاسخ <-> لیست درخواست',
        'Auto Responses' => 'پاسخ خودکار',
        'Auto Responses <-> Queue' => 'پاسخ خودکار <-> لیست درخواست',
        'Attachments <-> Responses' => 'پاسخ <-> پیوست ها',
        'History::Move' => 'سابقه::انتقال',
        'History::TypeUpdate' => 'نوع بروز شده به %s (ID=%s).',
        'History::ServiceUpdate' => ' خدمات بروز شده به %s (ID=%s).',
        'History::SLAUpdate' => ' SLA بروز شده به  %s (ID=%s).',
        'History::NewTicket' => 'درخواست جدید::سابقه',
        'History::FollowUp' => 'سابقه::پیگیری',
        'History::SendAutoReject' => 'سابقه::ارسال رد کردن خودکار ',
        'History::SendAutoReply' => 'سابقه::ارسال پاسخ خودکار',
        'History::SendAutoFollowUp' => 'سابقه:: ارسال پیگیری خودکار',
        'History::Forward' => 'سابقه::ارسال به دیگری',
        'History::Bounce' => 'سابقه:: ارجاع',
        'History::SendAnswer' => 'سابقه::ارسال پاسخ',
        'History::SendAgentNotification' => 'سابقه::ارسال اعلام به کارشناس',
        'History::SendCustomerNotification' => 'سابقه::ارسال اعلام به مشترک',
        'History::EmailAgent' => 'سابقه:: نامه کارشناس',
        'History::EmailCustomer' => 'سابقه::نامه مشترک',
        'History::PhoneCallAgent' => 'سابقه::تماسهای تلفنی کارشناس',
        'History::PhoneCallCustomer' => 'سابقه:: تماسهای تلفنی مشترک',
        'History::AddNote' => 'سابقه::افزودن یادداشت',
        'History::Lock' => 'سابقه::تحویل گرفتن تیکت',
        'History::Unlock' => 'سابقه::آزاد کردن تیکت',
        'History::TimeAccounting' => 'سابقه::حساب زمان',
        'History::Remove' => 'سابقه::حذف درخواست',
        'History::CustomerUpdate' => 'سابقه::بروزرسانی مشترک',
        'History::PriorityUpdate' => 'سابقه::بروزرسانی اولویت',
        'History::OwnerUpdate' => 'سابقه::بروزرسانی صاحب درخواست',
        'History::LoopProtection' => 'سابقه::حفاظت گردشی',
        'History::Misc' => 'سابقه::سایر',
        'History::SetPendingTime' => 'سابقه::تنظیم زمان تعلیق',
        'History::StateUpdate' => 'سابقه::بروزرسانی وضعیت',
        'History::TicketFreeTextUpdate' => 'سابقه::بروزرسانی درخواست متنی',
        'History::WebRequestCustomer' => 'سابقه::درخواست از طریق وب توسط مشترک',
        'History::TicketLinkAdd' => 'سابقه::لینک افزودن درخواست ',
        'History::TicketLinkDelete' => 'سابقه::لینک حذف درخواست ',
        'History::Subscribe' => 'عضویت اضافه شده برای کاربر "%s".',
        'History::Unsubscribe' => 'عضویت حذف شده برای کاربر"%s".',

        # Template: AAAWeekDay
        'Sun' => 'یکشنبه',
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
        'Auto Response From' => 'فرستنده پاسخ خودکار',
        'Note' => 'یادداشت',
        'Useable options' => 'گزینه های قابل استفاده',
        'To get the first 20 character of the subject.' => 'برای دریافت 20 حرف اول موضوع',
        'To get the first 5 lines of the email.' => 'برای دریافت 5 خط اول نامه',
        'To get the realname of the sender (if given).' => 'برای دریافت نام فرستنده',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'برای دریافت مشخصات مورد نظیر(<OTRS_CUSTOMER_From>، <OTRS_CUSTOMER_To>، <OTRS_CUSTOMER_Cc>، <OTRS_CUSTOMER_Subject>  و <OTRS_CUSTOMER_Body>)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'گزینه های اطلاعات این مشترک',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'گزینه های صاحب درخواست',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'گزینه های مسئول درخواست',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'گزینه های این کاربر که درخواست این فعالیت را داده ',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'گزینه های اطلاعات درخواست',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'گزینه های پیکره بندی',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'مدیریت شرکت مشترک',
        'Search for' => 'جستجو برای',
        'Add Customer Company' => 'افزودن شرکت مشترک ',
        'Add a new Customer Company.' => 'افزودن شرکت جدید ',
        'List' => '',
        'This values are required.' => 'این مقادیر مورد نیاز هستند.',
        'This values are read only.' => 'این مقادیر فقط قابل خواندن هستند.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'مدیریت مشترکین',
        'Add Customer User' => 'افزودن کاربر مشترک',
        'Source' => 'منبع',
        'Create' => 'ایجاد',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'نام کاربری مشترکین برای ورود به سیستم و نگهداری سوابق مورد استفاده قرار خواهد گرفت',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'مدیریت مشترکین  کاربر <-> گروه',
        'Change %s settings' => 'تغییر تنظیمات %s',
        'Select the user:group permissions.' => 'حقوق دسترسی (کاربر:گروه) را انتخاب نمائید',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'اگر هیچ گزینه ای انتخاب نشده باشد دسترسی به تیکت ها برای این گروه امکانپذیر نخواهد بود.',
        'Permission' => 'حقوق دسترسی',
        'ro' => 'فقط خواندنی',
        'Read only access to the ticket in this group/queue.' => 'حق فقط خواندنی برای تیکت ها در این گروه /لیست.',
        'rw' => 'خواندنی و نوشتنی',
        'Full read and write access to the tickets in this group/queue.' => 'دسترسی کامل به تیکت ها در این لیست / گروه.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'مشترک <-> مدیریت خدمات',
        'CustomerUser' => 'مشترک',
        'Service' => 'خدمات',
        'Edit default services.' => 'ویرایش خدمات پیش فرض',
        'Search Result' => 'نتیجه جستجو',
        'Allocate services to CustomerUser' => 'خدمات تخصیص داده شده به مشترک',
        'Active' => 'فعال',
        'Allocate CustomerUser to service' => 'مشترکین تخصیص داده شده به این خدمت',

        # Template: AdminEmail
        'Message sent to' => 'پیام ارسال شد به',
        'Recipents' => 'گیرنده ها',
        'Body' => 'متن نامه',
        'Send' => 'ارسال',

        # Template: AdminGenericAgent
        'GenericAgent' => 'کارشناس عمومی',
        'Job-List' => 'لیست کارها',
        'Last run' => 'آخرین اجرا',
        'Run Now!' => 'اجرا',
        'x' => '*',
        'Save Job as?' => 'کار را ذخیره کن با عنوان',
        'Is Job Valid?' => 'آیا کار معتبر است؟',
        'Is Job Valid' => 'آیا کار معتبر است',
        'Schedule' => 'زمان بندی',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'جستجوی متنی در موارد به شکل ( "Mar*in" یا "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(مثال: 10*5155 یا 105658*)',
        '(e. g. 234321)' => '(مثال: 234321)',
        'Customer User Login' => 'ورود مشترکین به سیستم',
        '(e. g. U5150)' => '(مثال: U5150)',
        'SLA' => 'موافقت نامه مطلوبیت ارائه خدمات (SLA)',
        'Agent' => 'کارشناس پشتیبانی',
        'Ticket Lock' => 'تحویل گیرنده درخواست',
        'TicketFreeFields' => 'ستون های آزاد درخواست',
        'Create Times' => 'زمان های ایجاد درخواست',
        'No create time settings.' => 'تنظیمی برای زمان ایجاد درخواست وجود ندارد',
        'Ticket created' => 'زمان ایجاد درخواست',
        'Ticket created between' => 'بازه زمانی ایجاد درخواست',
        'Close Times' => 'زمان های بسته شدن درخواست',
        'No close time settings.' => 'تنظیمی برای زمان بستن درخواست وجود ندارد',
        'Ticket closed' => 'زمان بسته شدن درخواست',
        'Ticket closed between' => 'بازه زمانی بستن درخواست',
        'Pending Times' => 'زمان های تعلیق درخواست',
        'No pending time settings.' => ' تنظیمی برای زمان تعلیق درخواست وجود ندارد ',
        'Ticket pending time reached' => 'زمان سررسید تعلیق ',
        'Ticket pending time reached between' => 'بازه زمانی سررسید تعلیق',
        'New Service' => 'خدمات جدید',
        'New SLA' => ' موافقت نامه مطلوبیت ارائه خدمات (SLA) جدید',
        'New Priority' => 'اولویت جدید',
        'New Queue' => 'لیست درخواست جدید',
        'New State' => 'وضعیت جدید',
        'New Agent' => 'کارشناس پشتیبانی جدید',
        'New Owner' => 'صاحب جدید',
        'New Customer' => 'مشترک جدید',
        'New Ticket Lock' => 'تحویل گیرنده جدید',
        'New Type' => 'نوع جدید',
        'New Title' => 'عنوان جدید',
        'New Type' => 'نوع جدید',
        'New TicketFreeFields' => 'ستون آزاد درخواست',
        'Add Note' => 'افزودن یادداشت',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'این دستور اجرا خواهد شد. ARG[0] شماره تیکت و ARG[1] id آن خواهد بود.',
        'Delete tickets' => 'حذف تیکت ها',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'توجه !این تیکت ها از بانک حذف خواهد شد . ',
        'Send Notification' => 'ارسال اعلام',
        'Param 1' => 'پارامتر 1',
        'Param 2' => 'پارامتر 2',
        'Param 3' => 'پارامتر 3',
        'Param 4' => 'پارامتر 4',
        'Param 5' => 'پارامتر 5',
        'Param 6' => 'پارامتر 6',
        'Send no notifications' => 'اعلام ها را ارسال نکن',
        'Yes means, send no agent and customer notifications on changes.' => 'پاسخ بله به معنی عدم ارسال اعلام به کارشناس و مشترک پس از اعمال تغییرات است',
        'No means, send agent and customer notifications on changes.' => ' پاسخ خیر به معنی ارسال اعلام به کارشناس و مشترک پس از اعمال تغییرات است ',
        'Save' => 'ذخیره',
        '%s Tickets affected! Do you really want to use this job?' => '%s درخواست مطابقت دارد.آیا واقعا قصد اجرای این کار را دارید؟',
        '"}' => '{',

        # Template: AdminGroupForm
        'Group Management' => 'مدیریت گروه ها',
        'Add Group' => 'ایجاد گروه',
        'Add a new Group.' => 'ایجاد گروه جدید',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'گروه admin برای دسترسی به محیط مدیریت سیستم میباشد.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'برای مدیریت بهتر بر دسترسی گروههای کارشناسی گروه جدید بسازید.',
        'It\'s useful for ASP solutions.' => 'این مورد برای راه حل های ASP مناسب میباشد.',

        # Template: AdminLog
        'System Log' => 'گزارش سیستم',
        'Time' => 'زمان',

        # Template: AdminMailAccount
        'Mail Account Management' => 'مدیریت حساب های نامه ',
        'Host' => 'سرور',
        'Trusted' => 'مجاز',
        'Dispatching' => 'توزیع',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'همه نامه ها از طریق یک آدرس به لیست تیکت انتخاب شده منتقل خواهد شد !',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'درصورتیکه آدرس شما مجاز و قابل اطمینان باشد زمان دریافت در header سیستم اولویت را تعیین کرده و پیام ها ارسال خواهد شد',

        # Template: AdminNavigationBar
        'Users' => 'کاربر ها',
        'Groups' => 'گروه ها',
        'Misc' => 'سایر',

        # Template: AdminNotificationForm
        'Notification Management' => 'مدیریت اعلام ها',
        'Notification' => 'اعلام',
        'Notifications are sent to an agent or a customer.' => 'اعلام به یک کارشناس پشتیبانی یا مشترک ارسال شد.',

        # Template: AdminPackageManager
        'Package Manager' => 'مدیریت بسته ها',
        'Uninstall' => 'حذف بسته',
        'Version' => 'ویرایش',
        'Do you really want to uninstall this package?' => 'از حذف این بسته اطمینان دارید؟',
        'Reinstall' => 'نصب مجدد',
        'Do you really want to reinstall this package (all manual changes get lost)?' => ' آیا از نصب مجدد این بسته اطمینان دارید. همه تغیرات دستی رونویسی خواهد شد ',
        'Continue' => 'ادامه',
        'Install' => 'نصب',
        'Package' => 'بسته',
        'Online Repository' => 'مخزن آن لاین بسته ها',
        'Vendor' => 'فروشنده',
        'Upgrade' => 'بروزرسانی',
        'Local Repository' => 'مخزن محلی بسته ها',
        'Status' => 'وضعیت',
        'Overview' => 'پیش نمایش',
        'Download' => 'دریافت',
        'Rebuild' => 'ساخت مجدد',
        'ChangeLog' => 'گزارش تغیرات',
        'Date' => 'تاریخ',
        'Filelist' => 'لیست فایل ها',
        'Download file from package!' => 'دریافت فایل از بسته',
        'Required' => 'الزامی',
        'PrimaryKey' => 'کلید اصلی',
        'AutoIncrement' => 'افزایشی خودکار',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'گزارش عملکرد',
        'This feature is enabled!' => 'این ویژگی فعال است.',
        'Just use this feature if you want to log each request.' => 'این ویژگی امکان ثبت همه درخواست ها را میدهد',
        'Of couse this feature will take some system performance it self!' => 'این ویژگی خود بعضی از عملکردهای سیستم را میگیرد',
        'Disable it here!' => 'اینجا غیر فعال نمائید',
        'This feature is disabled!' => 'این ویژگی غیر فعال است',
        'Enable it here!' => 'اینجا فعال نمائید',
        'Logfile too large!' => 'فایل گزارش بیش از حد بزرگ است',
        'Logfile too large, you need to reset it!' => 'فایل گزارش بیش از حد بزرگ شده است،آن راپاکسازی نمائید',
        'Range' => 'حدود',
        'Interface' => 'واسط',
        'Requests' => 'درخواست ها',
        'Min Response' => 'کمترین پاسخ',
        'Max Response' => 'بیشترین پاسخ',
        'Average Response' => 'میانگین پاسخ',
        'Period' => 'دوره',
        'Min' => 'کمترین',
        'Max' => 'بیشترین',
        'Average' => 'میانگین',

        # Template: AdminPGPForm
        'PGP Management' => 'مدیریت رمزگذاری',
        'Result' => 'نتیجه',
        'Identifier' => 'کد ملی',
        'Bit' => 'Bit',
        'Key' => 'کلید',
        'Fingerprint' => 'اثر انگشت',
        'Expires' => 'ابطال',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'از این طریق شما میتوانید مستقیما کلید های خود را درسیستم تنظیم نمائید',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'مدیریت فیلتر پستی',
        'Filtername' => 'نام فیلتر',
        'Match' => 'مطابقت',
        'Header' => 'سرصفحه',
        'Value' => 'مقدار',
        'Set' => 'ثبت',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'email ها را از طریق Header یا RegExp فیلتر کن.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'برای انطباق اختصاصی Email از EMAILADDRESS:info@example.com در فرستنده،گیرنده و رونوشت استفاده نمائید.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'اگر از RegExp استفاده میکنید میتوانید از مقادیر مطابق در () بعنوان[***] در ثبت استفاده نمائید',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'مدیریت لیست <-> پاسخ خودکار',

        # Template: AdminQueueForm
        'Queue Management' => 'مدیریت لیست های درخواست',
        'Sub-Queue of' => 'لیست فرعی',
        'Unlock timeout' => 'مهلت آزاد شدن درخواست',
        '0 = no unlock' => '0 = آزاد نشود',
        'Only business hours are counted.' => 'فقط ساعات اداری محاسبه شده است',
        'Escalation - First Response Time' =>  'بالارفتن اولین پاسخ',
        '0 = no escalation' => '0 = بدون افزایش',
        'Only business hours are counted.' => ' فقط ساعات اداری محاسبه شده است ',
        'Notify by' => 'اعلام با',
        'Escalation - Update Time' => ' بالارفتن زمان بروز رسانی',
        'Notify by' => 'اعلام با',
        'Escalation - Solution Time' => ' بالارفتن زمان ارائه راهکار',
        'Follow up Option' => 'گزینه پیگیری',
        'Ticket lock after a follow up' => 'درخواست بعد از پیگیری تحویل گرفته شود',
        'Systemaddress' => 'آدرس سیستمی',
        'Customer Move Notify' => 'اعلام انتقال به مشترک',
        'Customer State Notify' => 'اعلام وضعیت به مشترک',
        'Customer Owner Notify' => 'اعلام تعیین صاحب به مشترک',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'اگر یک کارشناس درخواست را تحویل بگیرد و در این مدت زمان نتواند به آن پاسخ دهد درخواست آزاد شده و به لیست باز میگردد و قابل دسترس برای سایر کارشناسان خواهد شد',
        'Escalation time' => 'زمان زیاد شدن',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'اگر به هیچ درخواستی الان پاسخ داده نشد فقط این درخواست نمایش داده شود',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'اگر یک درخواست بسته شود و مشترک دوباره آنرا پیگیری کند بطور خودکار به صاحب  قبلی آن تحویل داده خواهد شد',
        'Will be the sender address of this queue for email answers.' => 'آدرس ارسال کننده این لیست برای پاسخ به نامه استفاده خواهد شد.',
        'The salutation for email answers.' => 'عنوان برای پاسخ email',
        'The signature for email answers.' => 'امضاء email ',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'اگر درخواست به شخص دیگری منتقل شد سیستم با Email اطلاع خواهد داد.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'اگر وضعیت درخواست تغییر کرد سیستم با Email اطلاع خواهد داد',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'اگر صاحب درخواست تغییر کرد سیستم با Email اطلاع خواهد داد.',

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
        'Select the role:user relations.' => 'ارتبتط هر کاربر را با وظیفه مربوط به آن مشخص کنید',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'مدیریت عنوان ها',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Limit' => 'محدوده',
        'Go' => '',
        'Select Box Result' => 'نتیجه باکس انتخاب',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => '',
        'Add a new Service.' => '',
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
        'Please select only one element or turn off the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => '',
        'Relative Period' => '',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '',

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
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

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
        'Information about the Stat' => '',
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

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'صعودی',
        'down' => 'نزولی',
        'Escalation' => '',
        'Locked' => 'در اختیار',

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
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',
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
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'نوع نتیجه',
        'Save Search-Profile as Template?' => 'ذخیره بعنوان الگوی جستجو?',
        'Yes, save it with name' => 'بله آنرا ذخیره کن با نام',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'تغییر گزینه های جستجو',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'نمایش وضعیت تیکت',
        'Open Tickets' => 'تیکت های باز',

        # Template: AgentTicketZoom
        'Expand View' => '',
        'Collapse View' => '',

        # Template: AgentWindowTab

        # Template: AJAX

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
        'Welcome to %s' => '',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Administrateur',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => '',
        'Database-User' => '',
        'default \'hot\'' => 'hôte par défaut',
        'DB connect host' => '',
        'Database' => '',
        'Default Charset' => 'Charset par défaut',
        'utf8' => '',
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
        'Use utf-8 it your database supports it!' => 'Utilisez UTF-8 si votre base de donnée le supporte !',
        'Default Language' => 'Langage par défaut ',
        '(Used default language)' => '(Langage par défaut utilisé)',
        'CheckMXRecord' => 'Vérifier les enregistrements MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Verifie les enregistrements MX des adresses électroniques utilisées lors de la rédaction d\'une réponse. N\'utilisez pas la "Vérification des enregistrements MX" si votre serveur OTRS est derrière une ligne modem $!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Pour pouvoir utiliser OTRS, vous devez entrer les commandes suivantes dans votre terminal en tant que root.',
        'Restart your webserver' => 'Redémarrer votre serveur web',
        'After doing so your OTRS is up and running.' => 'Après avoir fait ceci votre OTRS est en service',
        'Start page' => 'Page de démarrage',
        'Your OTRS Team' => 'Votre ةquipe OTRS',

        # Template: Login

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
        'Create Database' => 'ایجاد بانک',
        'DB Host' => 'سرور بانک اطلاعاتی',
        'Change roles <-> groups settings' => 'تغیر تنظیمات وظیفه <-> گروه',
        'Ticket Number Generator' => 'تولید کننده شماره تیکت ها',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(مشخصه تیکت ها. اکثر کاربران مایلنداز این ترکیب استفاده کنند مثال: \'شماره تیکت\', \'نام شرکت#\' یا \'نام دلخواه #\')',
        'Create new Phone Ticket' => 'ایجاد تیکت تلفنی',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'تنظیم مستقیم کلید ها Kernel/Config.pm',
        'Symptom' => 'نشانه',
        'U' => 'Z-A, ی-الف',
        'A message should have a To: recipient!' => 'آدرس دریافت کننده پیام مشخص نشده است!',
        'Site' => 'سایت',
        'Customer history search (e. g. "ID342425").' => 'جستجو در سوابق مشترک (مثال: "ID342425")',
        'for agent firstname' => 'برای نام کارشناس',
        'Close!' => 'بستن!',
        'The message being composed has been closed.  Exiting.' => 'پیامی که ارسال شد بسته شد.',
        'A web calendar' => 'یک تقویم',
        'to get the realname of the sender (if given)' => 'برای گرفتن نام فرستنده',
        'OTRS DB Name' => 'نام بانک اطلاعاتی سیستم',
        'Notification (Customer)' => '',
        'Select Source (for add)' => 'منبع را انتخاب نمائید (برای افزودن)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Days' => 'روز',
        'Queue ID' => 'کد لیست',
        'Home' => 'صفحه اول',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'گزینه های تنظیمات ',
        'System History' => 'سوابق سیستم',
        'customer realname' => 'نام و نام خانوادگی مشترک',
        'Pending messages' => 'پیامهای در تعلیق',
        'Modules' => 'ماژول ها',
        'for agent login' => 'برای ورود کارشناس به سیستم',
        'Keyword' => 'کلمه کلیدی',
        'Close type' => 'نوع بستن',
        'DB Admin User' => 'نام کاربری مدیر بانک اطلاعاتی ',
        'for agent user id' => 'برای کد کاربری کارشناس',
        'sort upward' => 'صعودی',
        'Change user <-> group settings' => 'تغییر تنظیمات کاربر <-> گروه',
        'Problem' => 'مشکل',
        'next step' => 'قدم بعدی',
        'Customer history search' => 'جستجو در سوابق مشترک',
        'Admin-Email' => 'e-mail مدیر سیستم',
        'Create new database' => 'ایجاد بانک جدید',
        'A message must be spell checked!' => 'پیام باید غلط یابی شده باشد!',
        'Ticket#' => 'شماره تیکت',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'پیام شما در تیکت به شماره "<OTRS_TICKET> ارجاع شد به "<OTRS_BOUNCE_TO>". برای اطلاعات بیشتر با این آدرس تماس بگیرید',
        'ArticleID' => 'شماره مورد',
        'A message should have a body!' => 'پیام میبایست دارای متن باشد !',
        'All Agents' => 'همه کارشناسان',
        'Keywords' => 'کلمات کلیدی',
        'No * possible!' => 'هیچ * ممکن نیست !',
        'Options ' => 'گزینه ها',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'گزینه های تنظیمات صاحب تیکت',
        'Message for new Owner' => 'پیام برای صاحب جدید تیکت',
        'to get the first 5 lines of the email' => 'برای گرفتن 5 خط اول email',
        'OTRS DB Password' =>  'رمز عبور بانک اطلاعاتی سیستم',
        'Last update' => 'آخرین بروزرسانی',
        'to get the first 20 character of the subject' => 'برای گرفتن 20 کاراکتر اول موضوع',
        'Select the customeruser:service relations.' => '',
        'DB Admin Password' => 'رمز عبور مدیر سیستم',
        'Advisory' => 'مشورتی',
        'Drop Database' => 'حذف کامل بانک اطلاعاتی',
        'FileManager' => 'میریت فایل',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'گزینه های مشترک فعلی',
        'Pending type' => 'نوع تعلیق',
        'Comment (internal)' => 'توضیح داخلی',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'This window must be called from compose window' => 'این پنجره میبایست از طریق پنجره ارسال فراخوانی شود',
        'You need min. one selected Ticket!' => 'شما دست کم به یک تیکت انتخاب شده نیاز دارید!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>  'گزینه های اطلاعات تیکت',
        '(Used ticket number format)' => '(فرمت شماره تیکت)',
        'Fulltext' => 'جستجوی متنی',
        'Incident' => 'رویداد',
        'OTRS DB connect host' => 'سرور میزبان بانک اطلاعاتی ',
        ' (work units)' => ' واحد کار',
        'All Customer variables like defined in config option CustomerUser.' => 'همه تنظیمات مشترکین در فایل تنظیمات سیستم ذخیره شده است',
        'accept license' => 'Accepter la licence',
        'for agent lastname' => 'برای نام خانوادگی کارشناس',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'گزینه های تنظیمات صاحب تیکت',
        'Reminder messages' => 'پیامهای یادآوری',
        'Change users <-> roles settings' => 'تغییر تنظیمات کاربر <-> وظیفه',
        'A message should have a subject!' => 'یک پیام میبایست دارای عنوان باشد',
        'TicketZoom' => 'نمایش کامل تیکت',
        'Don\'t forget to add a new user to groups!' => 'فراموش نکنید که یک کاربر به گروه ایجاد شده اضافه کنید!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'آدرس email وارد شده معتبر نیست!',
        'CreateTicket' => 'ایجاد تیکت',
        'You need to account time!' => 'شما نیاز به محاسبه زمان دارید!',
        'System Settings' => 'تنظیمات سیستم',
        'WebWatcher' => 'بازرسی وب',
        'Hours' => 'ساعت',
        'Finished' => 'پایان یافت',
        'Split' => 'قسمت کردن تیکت',
        'D' => 'A-Z, الف-ی',
        'System Status' => '',
        'All messages' => 'همه پیام ها',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'گزینه های اطلاعات تیکت',
        'Artefact' => 'محصول',
        'A article should have a title!' => 'یک مورد باید دارای عنوان باشد',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'گزینه های تنظیمات ',
        'Event' => '',
        'don\'t accept license' => 'Ne pas accepter la licence',
        'A web mail client' => 'یک محیط پست الکترونیکی',
        'WebMail' => 'پست الکترونیکی تحت وب',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'گزینه های اطلاعات تیکت ها',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Options du propriÃ©taire d\'un ticket (ex: <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => 'نام مورد نیاز است!',
        'DB Type' => 'نوع بانک اطلاعاتی سیستم',
        'kill all sessions' => 'همه Session ها را از بین ببر',
        'to get the from line of the email' => 'برای گرفتن خط (از) email',
        'Solution' => 'راه حل',
        'QueueView' => 'نمایش لیست',
        'Select Box' => 'باکس انتخاب.',
        'Welcome to OTRS' => 'به سیستم پشتیبانی سورس باز خوش آمدید',
        'modified' => 'تغییر یافته',
        'Escalation in' => 'جابجایی در',
        'Delete old database' => 'حذف بانک قبلی',
        'sort downward' => 'نزولی',
        'You need to use a ticket number!' => 'شما باید از شماره تیکت استفاده نمائید!',
        'A web file manager' => 'یک محیط مدیریت فایل تحت وب',
        'Have a lot of fun!' => 'Amusez vous bien !',
        'send' => 'ارسال',
        'Note Text' => 'یادداشت',
        'POP3 Account Management' => 'مدیریت POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'گزینه های مشترک فعلی',
        'System State Management' => 'مدیریت وضعیت سیستم',
        'OTRS DB User' => 'نام کاربری بانک اطلاعاتی سیستم',
        'PhoneView' => 'نمایش تلفن',
        'Verion' => 'ویرایش',
        'TicketID' => 'شماره تیکت',
        'Modified' => 'تغییر یافته',
        'Ticket selected for bulk action!' => 'تیکت جهت عملیات کلی انتخاب گردید!',

        'Link Object: %s' => '',
        'Unlink Object: %s' => '',
        'Linked as' => '',
        'Can not create link with %s!' => '',
        'Can not delete link with %s!' => '',
        'Object already linked as %s.' => '',
        'Priority Management' => '',
        'Add a new Priority.' => '',
        'Add Priority' => '',
    };
    # $$STOP$$
    return;
}

1;
