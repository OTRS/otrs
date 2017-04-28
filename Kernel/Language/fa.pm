# --
# Copyright (C) 2006-2009 Amir Shams Parsa <a.parsa at gmail.com>
# Copyright (C) 2008 Hooman Mesgary <info at mesgary.com>
# Copyright (C) 2009 Afshar Mohebbi <afshar.mohebbi at gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Completeness}        = 0.98401133373811;

    # csv separator
    $Self->{Separator} = '';

    # TextDirection rtl or ltr
    $Self->{TextDirection} = 'rtl';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'بله',
        'No' => 'خیر',
        'yes' => 'بله',
        'no' => 'خیر',
        'Off' => 'خاموش',
        'off' => 'خاموش',
        'On' => 'روشن',
        'on' => 'روشن',
        'top' => 'بالا',
        'end' => 'پایان',
        'Done' => 'انجام شد',
        'Cancel' => 'لغو',
        'Reset' => 'ورود مجدد',
        'more than ... ago' => 'بیش از ... قبل',
        'in more than ...' => 'در بیش از ...',
        'within the last ...' => 'در آخرین ...',
        'within the next ...' => 'در بعدی ...',
        'Created within the last' => 'ایجاد شده در آخرین',
        'Created more than ... ago' => 'ایجاد شده بیشتر از ... قبل',
        'Today' => 'امروز ',
        'Tomorrow' => 'فردا ',
        'Next week' => 'هفته آینده',
        'day' => 'روز',
        'days' => 'روز',
        'day(s)' => 'روز',
        'd' => 'd',
        'hour' => 'ساعت',
        'hours' => 'ساعت',
        'hour(s)' => 'ساعت',
        'Hours' => 'ساعت',
        'h' => 'h',
        'minute' => 'دقیقه',
        'minutes' => 'دقیقه',
        'minute(s)' => 'دقیقه',
        'Minutes' => 'دقیقه',
        'm' => 'm',
        'month' => 'ماه',
        'months' => 'ماه',
        'month(s)' => 'ماه',
        'week' => 'هفته',
        'week(s)' => 'هفته',
        'quarter' => 'یک چهارم',
        'quarter(s)' => 'یک چهارم(ها)',
        'half-year' => 'نیمی از سال',
        'half-year(s)' => 'نیمی از سال(ها)',
        'year' => 'سال',
        'years' => 'سال',
        'year(s)' => 'سال',
        'second(s)' => 'ثانیه',
        'seconds' => 'ثانیه',
        'second' => 'ثانیه',
        's' => 's',
        'Time unit' => 'واحد زمان',
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
        'Setting' => 'تنظیم',
        'Settings' => 'تنظیمات',
        'Example' => 'مثال',
        'Examples' => 'مثال',
        'valid' => 'معتبر',
        'Valid' => 'معتبر',
        'invalid' => 'غیر معتبر',
        'Invalid' => 'نامعتبر',
        '* invalid' => 'غیر معتبر',
        'invalid-temporarily' => 'موقتا غیر معتبر',
        ' 2 minutes' => '۲ دقیقه',
        ' 5 minutes' => '۵ دقیقه',
        ' 7 minutes' => '۷ دقیقه',
        '10 minutes' => '۱۰ دقیقه',
        '15 minutes' => '۱۵ دقیقه',
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
        'Need Action' => 'نیاز به عملیات',
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
        'Standard' => 'استاندارد',
        'Lite' => 'اولیه',
        'User' => 'کاربر',
        'Username' => 'نام کاربری',
        'Language' => 'زبان',
        'Languages' => 'زبان',
        'Password' => 'رمز عبور',
        'Preferences' => 'تنظیمات',
        'Salutation' => 'عنوان',
        'Salutations' => 'عنوان',
        'Signature' => 'امضاء',
        'Signatures' => 'امضاء',
        'Customer' => 'مشترک',
        'CustomerID' => 'کد اشتراک',
        'CustomerIDs' => 'کد اشتراک',
        'customer' => 'مشترک',
        'agent' => 'کارشناس',
        'system' => 'سیستم',
        'Customer Info' => 'اطلاعات مشترک',
        'Customer Information' => 'اطلاعات مشترک',
        'Customer Companies' => 'شرکت/سازمان‌های مشترک',
        'Company' => 'شرکت/سازمان',
        'go!' => 'تائید!',
        'go' => 'تائید',
        'All' => 'همه',
        'all' => 'همه',
        'Sorry' => 'متاسفیم',
        'update!' => 'بروزرسانی !',
        'update' => 'بروزرسانی',
        'Update' => 'بروزرسانی',
        'Updated!' => 'به روز رسانی شد!',
        'submit!' => 'ارسال !',
        'submit' => 'ارسال',
        'Submit' => 'ارسال',
        'change!' => 'تغییر !',
        'Change' => 'تغییر',
        'change' => 'تغییر',
        'click here' => 'اینجا کلیک کنید',
        'Comment' => 'توضیح',
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
        'before/after' => 'قبل/بعد',
        'Fulltext Search' => 'جستجوی متنی',
        'Data' => 'داده‌ها',
        'Options' => 'گزینه‌ها',
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
        'Added!' => 'اضافه شد!',
        'Category' => 'دسته بندی',
        'Viewer' => 'نمایش دهنده',
        'Expand' => 'گسترش',
        'Small' => 'کوچک',
        'Medium' => 'متوسط',
        'Large' => 'بزرگ',
        'Date picker' => 'تقویم',
        'Show Tree Selection' => ' انتخاب درخت را نشان بده',
        'The field content is too long!' => 'محتویات این فیلد طولانی است!',
        'Maximum size is %s characters.' => 'حداکثر اندازه %s کاراکتر است.',
        'This field is required or' => 'این فیلد اجباری یا',
        'New message' => 'پیام جدید',
        'New message!' => 'پیام جدید !',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'لطفا برای بازگشت به نمایش عادی درخواست‌ها به این درخواست پاسخ دهید!',
        'You have %s new message(s)!' => 'شما %s پیام جدید دارید !',
        'You have %s reminder ticket(s)!' => 'شما %s درخواست جهت یادآوری دارید !',
        'The recommended charset for your language is %s!' => 'Charset پیشنهادی برای زبان شما  %s است!',
        'Change your password.' => 'کلمه عبور خود را تغییر دهید.',
        'Please activate %s first!' => 'لطفا ابتدا %s را فعال نمایید.',
        'No suggestions' => 'هیچ پیشنهادی وجود ندارد',
        'Word' => 'کلمه',
        'Ignore' => 'صرف نظر',
        'replace with' => 'جایگزین کن با',
        'There is no account with that login name.' => 'نام کاربری وارد شده موجود نیست',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'ورود ناموفق! نام کاربری یا کلمه عبور وارد شده اشتباه می‌باشد.',
        'There is no acount with that user name.' => 'حساب کاربری با این نام کاربری موجود نیست.',
        'Please contact your administrator' => 'لطفا با مدیر تماس بگیرید',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'احراز هویت موفقیت آمیز بود، اما هیچ اطلاعاتی مربوط به این مشتری در پایگاه داده مشتریان پیداه نشده است. لطفا با مدیر خود تماس بگیرید.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'این آدرس ایمیل در حال حاضر وجود دارد. لطفا وارد شوید و یارمز عبور خود را بازیابی کنید.',
        'Logout' => 'خروج ',
        'Logout successful. Thank you for using %s!' => 'خروج موفقیت آمیز. تشکر از شما برای استفاده از%s!',
        'Feature not active!' => 'این ویژگی فعال نیست.',
        'Agent updated!' => 'کارشناس به روز شد!',
        'Database Selection' => 'انتخاب پایگاه داده',
        'Create Database' => 'ایجاد بانک',
        'System Settings' => 'تنظیمات سیستم',
        'Mail Configuration' => 'پیکربندی پست الکترونیک',
        'Finished' => 'پایان یافت',
        'Install OTRS' => 'نصب  OTRS',
        'Intro' => 'معرفی',
        'License' => 'مجوز بهره برداری سیستم',
        'Database' => 'پایگاه داده',
        'Configure Mail' => 'پیکربندی ایمیل',
        'Database deleted.' => 'پایگاه داده حذف شد.',
        'Enter the password for the administrative database user.' => 'کلمه عبور کاربر مدیر پایگاه داده را وارد کنید.',
        'Enter the password for the database user.' => 'کلمه عبور برای کاربر پایگاه داده وارد کنید.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'اگر شما  کلمه ی عبور کاربر root را برای پایگاه داده تان تعیین کرده اید، باید آن را در اینجا وارد کنید. وگر نه در این فیلد چیزی وارد نکنید.',
        'Database already contains data - it should be empty!' => 'پایگاه داده در حال حاضر حاوی اطاعات است  -باید خالی باشد !',
        'Login is needed!' => 'نیاز است به سیستم وارد شوید',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'در حال حاضر بدلیل تعمیر و نگهداری سیستم برنامه ریزی شده، ورود به سایت امکان پذیر نمیباشد.',
        'Password is needed!' => 'ورود رمز عبور الزامی است',
        'Take this Customer' => 'این مشترک را بگیر',
        'Take this User' => 'این کاربر را بگیر',
        'possible' => 'بله',
        'reject' => 'خیر',
        'reverse' => 'برگردان',
        'Facility' => 'سهولت',
        'Time Zone' => 'منطقه زمانی',
        'Pending till' => 'تا زمانی که',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'برای کار با سیستم از حساب کاربری پیش‌فرض استفاده ننمایید! لطفا یک کارشناس جدید ساخته و با آن کار نمایید.',
        'Dispatching by email To: field.' => 'ارسال با پست الکترونیکی به:فیلد',
        'Dispatching by selected Queue.' => 'ارسال بوسیله لیست انتخاب شده',
        'No entry found!' => 'موردی پیدا نشد!',
        'Session invalid. Please log in again.' => 'جلسه نامعتبر است. لطفا مجددا وارد شوید.',
        'Session has timed out. Please log in again.' => 'مهلت Session شما به اتمام رسید . لطفا مجددا وارد سیستم شوید..',
        'Session limit reached! Please try again later.' => 'محدودیت در ورود! لطفا بعدا دوباره امتحان کنید.',
        'No Permission!' => 'دسترسی به این قسمت امکانپذیر نیست!',
        '(Click here to add)' => '(برای افزودن کلیک کنید)',
        'Preview' => 'پیش نمایش',
        'Package not correctly deployed! Please reinstall the package.' =>
            'بسته به درستی قرار نگرفته! لطفا بسته رامجدد نصب کنید .',
        '%s is not writable!' => '%s قابل نوشتن نمی‌باشد!',
        'Cannot create %s!' => '%s نمی‌تواند ساخته شود!',
        'Check to activate this date' => 'بررسی فعال شدن این تاریخ ',
        'You have Out of Office enabled, would you like to disable it?' =>
            'شما گزینه خارج از دفتردارید،می خواهید غیرفعالش کنید؟ ',
        'News about OTRS releases!' => 'اخبار در مورد انتشار OTRS!',
        'Go to dashboard!' => 'برو به داشبورد!',
        'Customer %s added' => 'مشترک %s افزوده شد',
        'Role added!' => 'نقش افزوده شد!',
        'Role updated!' => 'نقش به روزرسانی شد!',
        'Attachment added!' => 'پیوست افزوده شد!',
        'Attachment updated!' => 'پیوست به روزرسانی شد!',
        'Response added!' => 'پاسخ افزوده شد!',
        'Response updated!' => 'پاسخ به روزرسانی شد!',
        'Group updated!' => 'گروه به روزرسانی شد!',
        'Queue added!' => 'صف افزوده شد!',
        'Queue updated!' => 'صف به روزرسانی شد!',
        'State added!' => 'وضعیت افزوده شد!',
        'State updated!' => 'وضعیت به روزرسانی شد',
        'Type added!' => 'نوع افزوده شد!',
        'Type updated!' => 'نوع به روزرسانی شد!',
        'Customer updated!' => 'مشترک به روزرسانی شد!',
        'Customer company added!' => 'شرکت مشترک افزوده شد.',
        'Customer company updated!' => 'شرکت مشترک به روز شد.',
        'Note: Company is invalid!' => 'یادداشت: شرکت نامعتبر است.',
        'Mail account added!' => 'حساب ایمیل افزوده شد.',
        'Mail account updated!' => 'حساب ایمیل به روز شد.',
        'System e-mail address added!' => 'سیستم آدرس ایمیل اضافه شده است!',
        'System e-mail address updated!' => 'سیستم آدرس ایمیل به روزرسانی شده!',
        'Contract' => 'قرارداد',
        'Online Customer: %s' => 'مشترک فعال: %s',
        'Online Agent: %s' => 'کارشناس فعال: %s',
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
        'PGP' => 'PGP',
        'PGP Key' => 'کلید PGP',
        'PGP Keys' => 'کلیدهای PGP',
        'S/MIME' => 'S / MIME',
        'S/MIME Certificate' => 'گواهینامه S/MIME',
        'S/MIME Certificates' => 'گواهینامه‌های S/MIME',
        'Office' => 'محل کار',
        'Phone' => 'تلفن',
        'Fax' => 'نمابر',
        'Mobile' => 'تلفن همراه',
        'Zip' => 'کد پستی',
        'City' => 'شهر',
        'Street' => 'استان',
        'Country' => 'کشور',
        'Location' => 'موقعیت',
        'installed' => 'نصب شده',
        'uninstalled' => 'نصب نشده',
        'Security Note: You should activate %s because application is already running!' =>
            'نکته امنیتی:شما باید %s را فعال کنید زیرا نرم افزار در حال اجراست',
        'Unable to parse repository index document.' => 'ناتوانی در تجزیه کردن مستند',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'در این مخزن بسته بندی برای چهارچوب نسخه شما پیدا نشده است ، آن فقط شامل دیگر بسته بندی های چهارچوب نسخه ها میشود . ',
        'No packages, or no new packages, found in selected repository.' =>
            'بدون بسته بندی، و یا هیچ بسته های جدید، در مخزن انتخاب شده است.',
        'Edit the system configuration settings.' => 'ویرایش تنظیمات پیکربندی سیستم',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'اطلاعات ACL از پایگاه اطلاع داده  هماهنگی با پیکربندی سیستم نیست، لطفا تمام ACL ها را مستقر کنید . ',
        'printed at' => 'چاپ شده در',
        'Loading...' => 'بارگذاری...',
        'Dear Mr. %s,' => 'جناب آقای %s',
        'Dear Mrs. %s,' => 'سرکار خانم %s',
        'Dear %s,' => '%s گرامی',
        'Hello %s,' => 'سلام %s',
        'This email address is not allowed to register. Please contact support staff.' =>
            'این آدرس ایمیل مجاز به ثبت نام نیست . لطفا با کارکنان پشتیبانی تماس بگیرید.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'حساب کاربری جدید ساخته شد. اطلاعات ورود به %s ارسال شد. لطفا ایمیل خود را چک نمایید. ',
        'Please press Back and try again.' => 'کلید بازگشت را بزنید و دوباره سعی کنید',
        'Sent password reset instructions. Please check your email.' => 'دستورالعمل تنظیم مجدد کلمه عبور ارسال شد. لطفا ایمیل خود را چک نمایید.',
        'Sent new password to %s. Please check your email.' => 'کلمه عبور جدید به %s ارسال شد. لطفا ایمیل خود را چک نمایید.',
        'Upcoming Events' => 'رویدادهای پیش رو',
        'Event' => 'رویداد',
        'Events' => 'رویدادها',
        'Invalid Token!' => 'کد بازیابی معتبر نیست',
        'more' => 'بیشتر',
        'Collapse' => 'باز کردن',
        'Shown' => 'نمایش داده شده',
        'Shown customer users' => 'مشتری کاربر نشان داده شده است',
        'News' => 'اخبار',
        'Product News' => 'اخبار محصولات',
        'OTRS News' => 'اخبار سامانه پشتیبانی',
        '7 Day Stats' => 'گزارش ۷ روز',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'اطلاعات مدیریت فرآیند از پایگاه اطلاع داده هماهنگ با پیکربندی سیستم نیست، لطفا تمام فرآیندها را همگام سازی کنید.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'بسته توسط گروه OTRS تایید نشده است! توصیه نمی شود از این بسته استفاده کنید .',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br> اگر شما به نصب این بسته ادامه بدهید، موارد زیر ممکن است رخ دهد لرزه و nbsp؛  -مشکلات امنییتی  <BR> & nbsp؛  مشکلات ایستایی  <BR> & nbsp؛  مشکلات عملکرد لرزه ،لطفا توجه داشته باشید که مسائلی که با کار کردن با این بسته ایجاد می شود توسط قرارداد خدمات OTRS تحت پوشش نیست! لرزه',
        'Mark' => 'علامت دار',
        'Unmark' => 'بدون علامت',
        'Bold' => 'تو پر',
        'Italic' => 'کج',
        'Underline' => 'زیرخط',
        'Font Color' => 'رنگ قلم',
        'Background Color' => 'رنگ پس زمینه',
        'Remove Formatting' => 'برداشتن قالب‌بندی',
        'Show/Hide Hidden Elements' => 'نمایش/اختفای عناصر مخفی',
        'Align Left' => 'تنظیم از چپ',
        'Align Center' => 'تنظیم از وسط',
        'Align Right' => 'تنظیم از راست',
        'Justify' => 'هم تراز کردن',
        'Header' => 'سرصفحه',
        'Indent' => 'تو رفتگی',
        'Outdent' => 'بیرون آمدگی',
        'Create an Unordered List' => 'ایجاد یک لیست مرتب نشده',
        'Create an Ordered List' => 'ایجاد یک لیست مرتب شده',
        'HTML Link' => 'لینک HTML',
        'Insert Image' => 'درج تصویر',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'پس‌گرد',
        'Redo' => 'از نو',
        'OTRS Daemon is not running.' => 'سرویس OTRS در حال اجرا نیست.',
        'Can\'t contact registration server. Please try again later.' => 'در حال حاضرنمی توانید با سرور ثبت نام تماس بگیرید. لطفا بعدا دوباره امتحان کنید.',
        'No content received from registration server. Please try again later.' =>
            ' از سرور ثبت نام هیچ محتوایی دریافت نشده است. لطفا بعدا دوباره امتحان کنید.',
        'Problems processing server result. Please try again later.' => ' نتیجه مشکلات پردازش  سرور . لطفا بعدا دوباره امتحان کنید.',
        'Username and password do not match. Please try again.' => 'نام کاربری و رمز عبور مطابقت ندارند. لطفا دوباره تلاش کنید.',
        'The selected process is invalid!' => 'روند انتخاب نامعتبر است!',
        'Upgrade to %s now!' => 'ارتقا به %s در حال حاضر!',
        '%s Go to the upgrade center %s' => '%s برو به مرکز ارتقاء %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'مجوز %s شما رو به پایان است. لطفا برای بستن قرارداد مجدد با  %s تماس بگیرید.',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'یک به روز رسانی برای  %s شماموجود است، اما یک مشکلی با نسخه چارچوب شما وجود دارد! لطفا ابتدا چارچوب خود را به روز رسانی کنید !',
        'Your system was successfully upgraded to %s.' => 'سیستم شما با موفقیت در%s به روز رسانی شد  .',
        'There was a problem during the upgrade to %s.' => '  در طول ارتقاء%s یک مشکلی به وجود آمده بود .',
        '%s was correctly reinstalled.' => '%s به درستی نصب مجدد شد.',
        'There was a problem reinstalling %s.' => 'یک مشکل در نصب مجدد %s بوجود آمده بود.',
        'Your %s was successfully updated.' => ' %s شما با موفقیت به روزرسانی شد.',
        'There was a problem during the upgrade of %s.' => 'یک مشکل درطی ارتقاء%s وجود دارد  .',
        '%s was correctly uninstalled.' => '%s به درستی لغو نصب شد.',
        'There was a problem uninstalling %s.' => 'یک مشکل در پاک کردن%s وجود دارد  .',
        'Enable cloud services to unleash all OTRS features!' => 'فعال کردن سرویس های ابری به رها کردن تمام ویژگی های OTRS!',

        # Template: AAACalendar
        'New Year\'s Day' => 'روز اول ژانویه که آغاز سال نو مسیحیان است',
        'International Workers\' Day' => 'روز جهانی کارگر',
        'Christmas Eve' => 'شب کریسمس',
        'First Christmas Day' => 'روز اول کریسمس',
        'Second Christmas Day' => 'روز دوم کریسمس',
        'New Year\'s Eve' => 'شب سال نو',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS به عنوان درخواست',
        'OTRS as provider' => 'OTRS به عنوان ارائه دهنده',
        'Webservice "%s" created!' => '" %s "  از وب سرویس ایجاد شده است! ',
        'Webservice "%s" updated!' => ' " %s " از وب سرویس به روز رسانی  شده است!',

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
        'May_long' => 'می',
        'June' => 'ژون',
        'July' => 'جولای',
        'August' => 'آگوست',
        'September' => 'سپتامبر',
        'October' => 'اکتبر',
        'November' => 'نوامبر',
        'December' => 'دسامبر',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'تنظیمات با موفقیت ثبت شد.!',
        'User Profile' => 'مشخصات کاربر',
        'Email Settings' => 'تنظیمات پست الکترونیک',
        'Other Settings' => 'تنظیمات دیگر',
        'Notification Settings' => 'تنظیمات اطلاع رسانی',
        'Change Password' => 'تغیر رمز عبور',
        'Current password' => 'رمز عبور کنونی',
        'New password' => 'رمز عبور جدید',
        'Verify password' => 'تکرار رمز عبور',
        'Spelling Dictionary' => 'لغت‌نامه غلط یابی',
        'Default spelling dictionary' => 'لغت‌نامه غلط یابی پیش‌فرض',
        'Max. shown Tickets a page in Overview.' => 'حداکثر تعداد نمایش درخواست‌ها در نمای خلاصه',
        'The current password is not correct. Please try again!' => 'رمز عبور کنونی صحیح نمی‌باشد. لطفا مجددا تلاش نمایید!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'نمی‌توان کلمه عبور را به روز کرد، رمزهای عبور جدید با هم مطابقت ندارند. لطفا مجددا تلاش نمایید!',
        'Can\'t update password, it contains invalid characters!' => 'نمی‌توان کلمه عبور را به روز کرد، شامل کاراکترهای غیرمجاز می‌باشد!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'نمی‌توان کلمه عبور را به روز کرد، باید حداقل شامل %s کاراکتر باشد!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'نمی‌توان کلمه عبور را به روز کرد، باید شامل حداقل ۲ حرف کوچک و ۲ حرف بزرگ باشد!',
        'Can\'t update password, it must contain at least 1 digit!' => 'نمی‌توان کلمه عبور را به روز کرد، باید شامل حداقل یک عدد باشد!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'نمی‌توان کلمه عبور را به روز کرد، حداقل باید شامل ۲ کاراکتر باشد!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'نمی‌توان کلمه عبور را به روز کرد، این رمز عبور در حال حاضر استفاده می‌شود. لطفا یک مورد جدید وارد نمایید.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'لطفا کاراکتر استفاده شده برای فایل‌های CSV را انتخاب نمایید. اگر جداکننده‌ای را انتخاب نکنید، جداکننده پیش‌فرض زبان انتخاب شده توسط شما استفاده می‌گردد.',
        'CSV Separator' => 'جداکننده CSV',

        # Template: AAATicket
        'Status View' => 'نمای وضعیت',
        'Service View' => 'نمای سرویس',
        'Bulk' => 'دسته جمعی',
        'Lock' => 'تحویل گرفتن',
        'Unlock' => 'تحویل دادن',
        'History' => 'سابقه',
        'Zoom' => 'نمایش کامل',
        'Age' => 'طول عمر درخواست',
        'Bounce' => 'ارجاع',
        'Forward' => 'ارسال به دیگری',
        'From' => 'فرستنده',
        'To' => 'گیرنده',
        'Cc' => 'رونوشت',
        'Bcc' => 'رونوشت پنهان',
        'Subject' => 'موضوع',
        'Move' => 'انتقال',
        'Queue' => 'لیست درخواست',
        'Queues' => 'لیست‌های درخواست',
        'Priority' => 'اولویت',
        'Priorities' => 'الویت‌ها',
        'Priority Update' => 'بروزرسانی اولویت',
        'Priority added!' => 'اولویت اضافه شده است!',
        'Priority updated!' => 'اولویت به روز شده!',
        'Signature added!' => 'امضا اضافه شده است!',
        'Signature updated!' => 'امضا به روز شده!',
        'SLA' => 'موافقت نامه مطلوبیت ارائه خدمات (SLA)',
        'Service Level Agreement' => 'توافق سطح سرویس',
        'Service Level Agreements' => 'توافقات سطح سرویس',
        'Service' => 'خدمات',
        'Services' => 'خدمات',
        'State' => 'وضعیت',
        'States' => 'وضعیت‌ها',
        'Status' => 'وضعیت',
        'Statuses' => 'وضعیت‌ها',
        'Ticket Type' => 'نوع درخواست',
        'Ticket Types' => 'انواع درخواست',
        'Compose' => 'ارسال',
        'Pending' => 'معلق',
        'Owner' => 'صاحب',
        'Owner Update' => 'بروز رسانی توسط صاحب',
        'Responsible' => 'مسئول',
        'Responsible Update' => 'بروزرسانی توسط مسئول',
        'Sender' => 'فرستنده',
        'Article' => 'نوشته',
        'Ticket' => 'درخواست‌ها',
        'Createtime' => 'زمان ایجاد ',
        'plain' => 'ساده',
        'Email' => 'ایمیل',
        'email' => 'ایمیل',
        'Close' => 'بستن',
        'Action' => 'فعالیت',
        'Attachment' => 'پیوست',
        'Attachments' => 'پیوست‌ها',
        'This message was written in a character set other than your own.' =>
            'این پیام با charset دیگری بجز charset  شما نوشته شده است.',
        'If it is not displayed correctly,' => 'اگر به درستی نمایش داده نشده است',
        'This is a' => 'این یک',
        'to open it in a new window.' => 'برای باز شدن در پنجره جدید',
        'This is a HTML email. Click here to show it.' => 'این یک نامه با فرمت HTML است برای نمایش اینجا کلیک کنید.',
        'Free Fields' => 'فیلد‌های آزاد',
        'Merge' => 'ادغام ',
        'merged' => 'ادغام شد',
        'closed successful' => 'با موفقیت بسته شد',
        'closed unsuccessful' => 'با موفقیت بسته نشد',
        'Locked Tickets Total' => 'تمامی درخواست‌های تحویل گرفته شده',
        'Locked Tickets Reminder Reached' => 'درخواست‌های تحویل گرفته شده‌ای که زمان یادآوری آن رسیده',
        'Locked Tickets New' => 'درخواست‌های تازه تحویل گرفته شده',
        'Responsible Tickets Total' => 'تمام درخواست‌های من',
        'Responsible Tickets New' => 'تمام درخواست‌های جدید من',
        'Responsible Tickets Reminder Reached' => 'درخواست‌های من که زمان یادآوری آن‌ها رسیده',
        'Watched Tickets Total' => 'تمامی درخواست‌های مشاهده شده',
        'Watched Tickets New' => 'درخواست‌های مشاهده شده جدید',
        'Watched Tickets Reminder Reached' => 'درخواست‌های مشاهده شدهکه زمان یادآوری آن رسیده',
        'All tickets' => 'همه درخواست‌ها',
        'Available tickets' => 'درخواست موجود',
        'Escalation' => 'تشدید',
        'last-search' => 'آخرین جستجو',
        'QueueView' => 'نمای صف درخواست',
        'Ticket Escalation View' => 'نمای درخواست‌های خیلی مهم',
        'Message from' => 'فرم پیام',
        'End message' => 'پایان پیام',
        'Forwarded message from' => 'پیام فوروارد شده از',
        'End forwarded message' => 'پایان پیام فرستاده شده',
        'Bounce Article to a different mail address' => 'برگشت زدن نوشته به یک آدرس ایمیل دیگر ',
        'Reply to note' => 'به پاسخ توجه داشته باشید',
        'new' => 'جدید',
        'open' => 'باز',
        'Open' => 'باز',
        'Open tickets' => 'تیکت های باز',
        'closed' => 'بسته شده',
        'Closed' => 'بسته شده',
        'Closed tickets' => 'تیکت های بسته شده',
        'removed' => 'حذف شده',
        'pending reminder' => 'یادآوری حالت معلق',
        'pending auto' => 'حالت خودکار معلق',
        'pending auto close+' => 'حالت تعلیق-بستن خودکار(+)',
        'pending auto close-' => 'حالت تعلیق-بستن خودکار(-)',
        'email-external' => 'ایمیل-خارجی',
        'email-internal' => 'ایمیل-داخلی',
        'note-external' => 'یادداشت- خارجی',
        'note-internal' => 'یادداشت-داخلی',
        'note-report' => 'یادداشت-گزارش',
        'phone' => 'تلفن',
        'sms' => 'پیامک-SMS',
        'webrequest' => 'درخواست از طریق وب',
        'lock' => 'تحویل گرفته شده',
        'unlock' => 'تحویل داده شده',
        'very low' => 'خیلی پائین',
        'low' => 'پائین',
        'normal' => 'عادی',
        'high' => 'بالا',
        'very high' => 'خیلی بالا',
        '1 very low' => '۱ خیلی پائین',
        '2 low' => '۲ پائین',
        '3 normal' => '۳ عادی',
        '4 high' => '۴ بالا',
        '5 very high' => '۵ خیلی بالا',
        'auto follow up' => 'پیگیری خودکار',
        'auto reject' => 'رد خودکار ',
        'auto remove' => 'حذف خودکار',
        'auto reply' => 'پاسخ خودکار',
        'auto reply/new ticket' => 'پاسخ خودکار/تیکت جدید',
        'Create' => 'ایجاد',
        'Answer' => 'پاسخ',
        'Phone call' => 'تماس تلفنی',
        'Ticket "%s" created!' => 'درخواست %s ایجاد شد !',
        'Ticket Number' => 'شماره درخواست',
        'Ticket Object' => 'موضوع درخواست',
        'No such Ticket Number "%s"! Can\'t link it!' => 'این شماره درخواست وجود ندارد "%s"! نمایش امکانپذیر نیست',
        'You don\'t have write access to this ticket.' => 'شما دسترسی به نوشتن این درخواست را ندارید .',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'با عرض پوزش،برای انجام این عملیات شما نیاز به اطلاعت  صاحب بلیط دارید . ',
        'Please change the owner first.' => 'لطفا ابتدا مالک را تغییر دهید.',
        'Ticket selected.' => 'تیکت انتخاب شد.',
        'Ticket is locked by another agent.' => 'بلیط  توسط عامل های دیگری قفل شده است.',
        'Ticket locked.' => 'تیکت قفل شده است.',
        'Don\'t show closed Tickets' => 'درخواست‌های بسته شده را نمایش نده',
        'Show closed Tickets' => 'نمایش درخواست‌های بسته',
        'New Article' => 'نوشته جدید',
        'Unread article(s) available' => 'مطالب خوانده نشده وجود دارد',
        'Remove from list of watched tickets' => 'حذف از فهرست درخواست‌های مشاهده شده',
        'Add to list of watched tickets' => 'افزودن به فهرست درخواست‌های مشاهده شده',
        'Email-Ticket' => 'درخواست با ایمیل',
        'Create new Email Ticket' => 'ایجاد درخواست با ایمیل',
        'Phone-Ticket' => 'درخواست تلفنی',
        'Search Tickets' => 'جستجو در درخواست‌ها',
        'Customer Realname' => 'نام واقعی مشترک',
        'Customer History' => 'تاریخچه اشتراک',
        'Edit Customer Users' => 'ویرایش مشترکین',
        'Edit Customer' => 'ویرایش مشترک',
        'Bulk Action' => 'اعمال کلی',
        'Bulk Actions on Tickets' => 'اعمال کلی روی درخواست‌ها',
        'Send Email and create a new Ticket' => 'ارسال ایمیل و ایجاد درخواست جدید',
        'Create new Email Ticket and send this out (Outbound)' => 'ایجاد درخواست جدید با ایمیل و ارسال - بیرونی',
        'Create new Phone Ticket (Inbound)' => 'ایجاد درخواست جدید تلفنی- داخلی',
        'Address %s replaced with registered customer address.' => ' %s آدرس با آدرس مشتری ثبت شده جایگزین شده است.',
        'Customer user automatically added in Cc.' => 'نام کاربری مشتری به طور خودکار در رونوشت اضافه میشود',
        'Overview of all open Tickets' => 'پیش نمایش همه درخواست‌های باز',
        'Locked Tickets' => 'درخواست‌های تحویل گرفته شده',
        'My Locked Tickets' => 'درخواست‌های تحویل گرفته شده من',
        'My Watched Tickets' => 'درخواست‌های مشاهده شده من',
        'My Responsible Tickets' => 'درخواست‌های وظیفه من',
        'Watched Tickets' => 'درخواست‌های مشاهده شده',
        'Watched' => 'مشاهده شده',
        'Watch' => 'پیگیری',
        'Unwatch' => 'عدم پیگیری',
        'Lock it to work on it' => 'قفل آن را بر روی آن کاربگذار ',
        'Unlock to give it back to the queue' => 'ان را برگردان به لیست باز شده . ',
        'Show the ticket history' => 'نمایش تاریخ بلیط',
        'Print this ticket' => 'چاپ این بلیط',
        'Print this article' => 'چاپ این نوشته ',
        'Split' => 'جدا ساختن',
        'Split this article' => 'جدا کردن این نوشته',
        'Forward article via mail' => 'ارسال نوشته از طریق ایمیل',
        'Change the ticket priority' => 'تغییر اولویت بلیط',
        'Change the ticket free fields!' => 'تغییر فیلدهای خالی درخواست',
        'Link this ticket to other objects' => 'پیوند این درخواست به موضوع دیگر',
        'Change the owner for this ticket' => 'تغییرمالک برای این درخواست ',
        'Change the  customer for this ticket' => 'تغییر مشتری برای این درخواست ',
        'Add a note to this ticket' => 'اضافه کردن یک یادداشت  به این بلیط',
        'Merge into a different ticket' => 'ادغام در یک درخواست دیگر',
        'Set this ticket to pending' => 'قرارادادن این درخواست در لیست انتظار',
        'Close this ticket' => 'بستن این درخواست ',
        'Look into a ticket!' => 'مشاهده درخواست',
        'Delete this ticket' => 'حذف این درخواست ',
        'Mark as Spam!' => 'به‌عنوان هرزنامه علامت بزن',
        'My Queues' => 'لیست درخواست‌های من',
        'Shown Tickets' => 'درخواست‌های نمایش داده شده',
        'Shown Columns' => 'ستون نشان داده شده است',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Email شما با شماره درخواست  "<OTRS_TICKET>" با درخواست "<OTRS_MERGE_TO_TICKET>"  ادغام گردید.',
        'Ticket %s: first response time is over (%s)!' => ' زمان اولین پاسخ برای درخواست %s: %s ',
        'Ticket %s: first response time will be over in %s!' => 'زمان اولین پاسخ به درخواست %s ،  %sخواهد بود.',
        'Ticket %s: update time is over (%s)!' => 'زمان بروزرسانی درخواست %s: %s',
        'Ticket %s: update time will be over in %s!' => 'زمان بروزرسانی درخواست %s ، %s خواهد بود',
        'Ticket %s: solution time is over (%s)!' => 'زمان ارائه راهکار برای درخواست %s : %s ',
        'Ticket %s: solution time will be over in %s!' => ' زمان ارائه راهکار برای درخواست %s ، %s خواهد بود ',
        'There are more escalated tickets!' => 'درخواست‌های اولویت داده شده بیشتری وجود دارد',
        'Plain Format' => 'قالب ساده',
        'Reply All' => 'پاسخ به همه',
        'Direction' => 'جهت',
        'New ticket notification' => 'اعلام درخواست جدید',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'دریافت درخواست جدید را به من اطلاع بده.',
        'Send new ticket notifications' => 'ارسال اعلان‌های درخواست جدید',
        'Ticket follow up notification' => 'اعلان پیگیری درخواست',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'در صورتی‌که مشترک یک پیگیری ارسال کرد و من صاحب درخواست بودم یا درخواست تحویل داده شده و در یکی از صف‌هایی است که من عضو آن هستم، اعلانی برای من ارسال کن.',
        'Send ticket follow up notifications' => 'ارسال اعلان‌های پیگیری درخواست',
        'Ticket lock timeout notification' => 'پایان مهلت تحویل گرفتن درخواست را به من اطلاع بده',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'اگر درخواست توسط سیستم تحویل داده شد به من اطلاع بده',
        'Send ticket lock timeout notifications' => 'ارسال اعلان‌های خاتمه زمان تحویل درخواست',
        'Ticket move notification' => 'اعلان انتقال درخواست',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'انتقال یک درخواست به لیست درخواست‌های من را اطلاع بده.',
        'Send ticket move notifications' => 'ارسال اعلان‌های انتقال درخواست',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            ' لیست خود را از لیست مورد علاقه تان انتخاب کنید ;  شما همچنین از لیستهایی مطلع خواهید شد که اگر با ایمیل فعال باشند.',
        'Custom Queue' => 'لیست سفارشی',
        'QueueView refresh time' => 'زمان بازیابی لیست درخواست‌ها',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'اگر مشخص شده باشد، صف درخواست به صورت خودکار پس از زمان مشخص شده مجددا بارگذاری می‌شود.',
        'Refresh QueueView after' => 'بارگذاری مجدد صف پس از',
        'Screen after new ticket' => 'وضعیت نمایش پس از دریافت درخواست جدید',
        'Show this screen after I created a new ticket' => 'این صفحه را پس از اینکه یک درخواست جدید ساختم، نمایش بده',
        'Closed Tickets' => 'درخواست بسته شده',
        'Show closed tickets.' => 'نمایش درخواست‌های بسته شده',
        'Max. shown Tickets a page in QueueView.' => 'تعداد درخواست‌ها در صفحه نمایش',
        'Ticket Overview "Small" Limit' => ' بررسی اجمالی درخواست \ "کوچک " محدود ',
        'Ticket limit per page for Ticket Overview "Small"' => 'محدودیت درخواست در هر صفحه برای بررسی اجمالی درخواست \ "کوچک "',
        'Ticket Overview "Medium" Limit' => ' بررسی اجمالی درخواست \ "متوسط ​​" محدود',
        'Ticket limit per page for Ticket Overview "Medium"' => 'محدودیت لیست در هر صفحه برای  بررسی اجمالی لیست \ "متوسط ​​"',
        'Ticket Overview "Preview" Limit' => 'بررسی اجمالی درخواست \ "پیش نمایش " محدود',
        'Ticket limit per page for Ticket Overview "Preview"' => 'حد بلیط در هر صفحه برای بلیط بررسی اجمالی \ "پیش نمایش "',
        'Ticket watch notification' => 'اعلان دیدن درخواست',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'برای من اطلاعات مشابه مربوط به درخواست های مشاهده شده که درخواست شخصی خواهند شد را ارسال کن . ',
        'Send ticket watch notifications' => 'ارسال اعلان‌های مشاهده شدن درخواست',
        'Out Of Office Time' => 'زمان بیرون بودن از محل کار',
        'New Ticket' => 'درخواست جدید',
        'Create new Ticket' => 'ایجاد درخواست جدید',
        'Customer called' => 'مشترک تماس گرفته',
        'phone call' => 'تماس تلفنی',
        'Phone Call Outbound' => 'تماس تلفنی راه دور',
        'Phone Call Inbound' => 'تلفن تماس ورودی',
        'Reminder Reached' => 'زمان اعلام یک یادآوری است',
        'Reminder Tickets' => 'درخواست‌های یادآوری شده',
        'Escalated Tickets' => 'درخواست های خیلی مهم',
        'New Tickets' => 'درخواست‌های جدید',
        'Open Tickets / Need to be answered' => 'درخواست‌های باز / درخواست‌های نیازمند به پاسخ',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'تمام درخواست‌های باز، روی این درخواست‌ها کار شده اما به یک مسئول نیاز دارند ',
        'All new tickets, these tickets have not been worked on yet' => 'تمام درخواست‌های جدید، روی این درخواست‌ها هنوز کاری انجام شده',
        'All escalated tickets' => 'تمام درخواست‌هایی که زمان پاسخگویی آن‌ها رو به پایان است',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'تمام درخواست‌هایی که برای آن‌ها یک یادآوری تنظیم شده و زمان یادآوری فرا رسیده است',
        'Archived tickets' => 'بلیط آرشیو',
        'Unarchived tickets' => 'بلیط از بایگانی خارج شد',
        'Ticket Information' => 'اطلاعات درخواست',
        'including subqueues' => 'از جمله subqueues',
        'excluding subqueues' => 'به استثنای subqueues',

        # Template: AAAWeekDay
        'Sun' => 'یکشنبه',
        'Mon' => 'دوشنبه',
        'Tue' => 'سه‌شنبه',
        'Wed' => 'چهارشنبه',
        'Thu' => 'پنجشنبه',
        'Fri' => 'جمعه',
        'Sat' => 'شنبه',

        # Template: AdminACL
        'ACL Management' => 'مدیریت ACL',
        'Filter for ACLs' => 'فیلتر برای ACL ها',
        'Filter' => 'فیلتر',
        'ACL Name' => 'نام ACL',
        'Actions' => 'عملیات‌ها',
        'Create New ACL' => 'ایجاد ACL جدید ',
        'Deploy ACLs' => 'استقرار ACL ها',
        'Export ACLs' => 'صادرات ACL ها',
        'Configuration import' => 'واردات پیکربندی',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'در اینجا شما می توانید یک فایل پیکربندی برای ورود ACL ها  به سیستم خود را بارگذاری کنید. فایل نیاز به  فرمت  yml دارد  که توسط ماژول ویرایشگر ACL صادر می شود.',
        'This field is required.' => 'این فیلد مورد نیاز است.',
        'Overwrite existing ACLs?' => 'بازنویسی ACL ها موجود؟',
        'Upload ACL configuration' => 'پیکربندی ACL بارگذاری شده ',
        'Import ACL configuration(s)' => 'پیکربندی واردات ACL (s)',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'برای ایجاد یک ACL جدید شما هم می توانید واردات ACL ها که از سیستم دیگری صادر شده و یا ایجاد کنید یک ACL جدید کامل.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'تغییرات به ACL در اینجا تنها رفتار سیستم تاثیر می گذارد، اگر شما اطلاعات ACL اعزام پس از آن. با استقرار داده ACL، تغییرات تازه ساخته شده را به پیکربندی نوشته شده است.',
        'ACLs' => 'ACL ها',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'لطفا توجه داشته باشید: این جدول نشان دهنده حکم اعدام از ACL ها است. اگر شما نیاز به تغییر نظم که در آن ACL ها اجرا می شوند، لطفا نام ACL ها را تحت تاثیر قرار را تغییر دهید.',
        'ACL name' => 'نام ACL',
        'Validity' => 'اعتبار',
        'Copy' => 'کپی',
        'No data found.' => 'داده‌ای یافت نشد',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ویرایش ACL %s',
        'Go to overview' => 'به نمای کلی برو',
        'Delete ACL' => 'حذف ACL',
        'Delete Invalid ACL' => 'حذف نامعتبر ACL',
        'Match settings' => 'تطابق تنظیمات ',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'تنظیم معیارهای تطبیق برای این ACL است. استفاده از "Properties" را برای مطابقت با صفحه نمایش فعلی یا PropertiesDatabase »برای مطابقت ویژگی بلیط فعلی که در پایگاه داده می باشد.',
        'Change settings' => 'تغییر تنظیمات',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'تنظیم آنچه که می خواهید تغییر دهید اگر بازی معیارهای. به خاطر داشته باشید که ممکن است یک لیست سفید، \'PossibleNot، یک لیست سیاه است.',
        'Check the official' => 'بررسی رسمی',
        'documentation' => 'اسناد',
        'Show or hide the content' => 'نمایش یا عدم نمایش محتوا',
        'Edit ACL information' => 'ویرایش اطلاعات ACL',
        'Stop after match' => 'توقف بعد از تطبیق',
        'Edit ACL structure' => 'ساختار ویرایش ACL',
        'Save settings' => 'ذخیره تنظیمات',
        'Save ACL' => 'ذخیره ACL',
        'Save' => 'ذخیره',
        'or' => 'یا',
        'Save and finish' => 'ذخیره و پایان',
        'Do you really want to delete this ACL?' => 'آیا شما واقعا می خواهید این ACL را حذف کنید؟',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'این مورد را ارزیابی هنوز شامل آیتم های زیر. آیا مطمئن هستید که می خواهید به حذف این مورد را ارزیابی از جمله آیتم های زیر است؟',
        'An item with this name is already present.' => 'یک آیتم با این نام از قبل وجود دارد.',
        'Add all' => 'اضافه کردن همه',
        'There was an error reading the ACL data.' => 'یک خطای خواندن داده ACL وجود دارد.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'درست ACL جدید با ارسال داده های فرم را. پس از ایجاد ACL، شما قادر به اضافه کردن آیتم های پیکربندی در حالت ویرایش خواهد بود.',

        # Template: AdminAttachment
        'Attachment Management' => 'مدیریت پیوست‌ها',
        'Add attachment' => 'افزودن پیوست',
        'List' => 'فهرست',
        'Download file' => 'بارگیری فایل',
        'Delete this attachment' => 'حذف این پیوست',
        'Do you really want to delete this attachment?' => 'آیا شما واقعا می خواهید این پیوست را حذف کنید؟',
        'Add Attachment' => 'افزودن پیوست',
        'Edit Attachment' => 'ویرایش پیوست',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'مدیریت پاسخ خودکار',
        'Add auto response' => 'افزودن پاسخ خودکار',
        'Add Auto Response' => 'افزودن پاسخ خودکار',
        'Edit Auto Response' => 'ویرایش پاسخ خودکار',
        'Response' => 'پاسخ',
        'Auto response from' => 'پاسخ خودکار از طرف',
        'Reference' => 'منبع',
        'You can use the following tags' => 'شما می‌توانید از برچسب‌های زیر استفاده نمایید.',
        'To get the first 20 character of the subject.' => 'برای دریافت ۲۰ حرف اول موضوع',
        'To get the first 5 lines of the email.' => 'برای دریافت ۵ خط اول نامه',
        'To get the name of the ticket\'s customer user (if given).' => 'برای دریافت نام کاربر و ضوابط بلیط (در صورت داده شده).',
        'To get the article attribute' => 'برای گرفتن ویژگی مطلب',
        ' e. g.' => 'به عنوان مثال',
        'Options of the current customer user data' => 'گزینه‌هایی از داده مشترک کنونی',
        'Ticket owner options' => 'گزینه‌های صاحب درخواست',
        'Ticket responsible options' => 'گزینه‌های مسئول درخواست',
        'Options of the current user who requested this action' => 'گزینه‌هایی از کاربر کنونی که این عملیات را درخواست کرده است',
        'Options of the ticket data' => 'گزینه‌هایی از داده‌های درخواست',
        'Options of ticket dynamic fields internal key values' => 'گزینه درخواست رشته پویا ارزش های داخلی کلیدی',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'گزینه زمینه های پویا بلیط نمایش مقادیر، مفید برای زمینه های کرکره و چندین انتخاب',
        'Config options' => 'گزینه‌های پیکربندی',
        'Example response' => 'پاسخ نمونه',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'مدیریت سرویس های ابری',
        'Support Data Collector' => 'پشتیبانی از داده های جمع آوری شده',
        'Support data collector' => 'پشتیبانی از داده های جمع آوری شده ',
        'Hint' => 'تذکر',
        'Currently support data is only shown in this system.' => 'در حال حاضر اطلاعات پشتیبانی داداه ها فقط در این سیستم نمایش داده شد ه . ',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'آن را بسیار توصیه به ارسال این اطلاعات را به OTRS گروه به منظور رسیدن به پشتیبانی بهتر.',
        'Configuration' => 'پیکر بندی',
        'Send support data' => 'ارسال پشتیبانی  داده ها',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'این اجازه خواهد داد این سیستم را به ارسال اطلاعات اضافی داده ها پشتیبانی به OTRS گروه.',
        'System Registration' => 'ثبت نام سیستم',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'برای فعال کردن ارسال اطلاعات، لطفا ثبت نام سیستم خود را با OTRS گروه یا به روز رسانی اطلاعات ثبت نام سیستم تان انجام دهید (مطمئن شوید که  گزینه  "ارسال  پشتیبانی داده ها " فعال است.)',
        'Register this System' => 'ثبت نام این سیستم',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'سیستم ثبت نام برای سیستم شما غیر فعال است. لطفا پیکربندی خود را چک کنید.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'ثبت نام سیستم یک سرویس از OTRS گروه، فراهم می کند که بسیاری از مزایای است!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'لطفا توجه داشته باشید که استفاده از سیستم های ابری  OTRS نیاز به این سیستم  ثبت نام دارد . ',
        'Register this system' => 'ثبت نام این سیستم',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'در اینجا شما می توانید خدمات ابر در دسترس است که امن برقراری ارتباط با پیکربندی %s .',
        'Available Cloud Services' => 'سرویس های ابری در دسترس',
        'Upgrade to %s' => 'ارتقا به %s',

        # Template: AdminCustomerCompany
        'Customer Management' => 'مدیریت مشترک',
        'Wildcards like \'*\' are allowed.' => 'نویسه عام مانند "*" مجاز است.',
        'Add customer' => 'افزودن مشترک',
        'Select' => 'انتخاب',
        'List (only %s shown - more available)' => 'فهرست (فقط %s نشان داده شده است - در دسترس تر)',
        'List (%s total)' => 'فهرست ( تعداد %s)',
        'Please enter a search term to look for customers.' => 'لطفا عبارت جستجو را وارد نمایید تا مشترکین را جستجو نمایید.',
        'Add Customer' => 'افزودن مشترک',

        # Template: AdminCustomerUser
        'Customer User Management' => 'مدیریت کاربری مشترک',
        'Back to search results' => 'بازگشت به نتایج جستجو',
        'Add customer user' => 'اضافه کردن کاربران به مشتریان',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'کاربران و ضوابط مورد نیاز برای یک سابقه مشتری و برای ورود به سایت از طریق پنل مشتری می باشد.',
        'Last Login' => 'آخرین ورود',
        'Login as' => 'ورود به عنوان',
        'Switch to customer' => 'تغییر به مشتری',
        'Add Customer User' => 'اضافه کردن کاربر مشترک',
        'Edit Customer User' => ' ویرایش کاربر مشتری',
        'This field is required and needs to be a valid email address.' =>
            'این گزینه مورد نیاز است و باید یک آدرس ایمیل معتبر باشد.',
        'This email address is not allowed due to the system configuration.' =>
            'این آدرس ایمیل با توجه به پیکربندی سیستم، نامعتبر است.',
        'This email address failed MX check.' => 'این آدرس ایمیل در چک MX ناموفق بوده است.',
        'DNS problem, please check your configuration and the error log.' =>
            'مشکل DNS، لطفا تنظیمات خود و خطای ورود را بررسی کنید .',
        'The syntax of this email address is incorrect.' => 'گرامر این آدرس ایمیل نادرست می‌باشد.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'مدیریت روابط مشترک-گروه',
        'Notice' => 'توجه',
        'This feature is disabled!' => 'این ویژگی غیر فعال است',
        'Just use this feature if you want to define group permissions for customers.' =>
            'فقط زمانی از این ویژگی استفاده کنید که می‌خواهید از دسترسی‌های گروه برای مشترکین استفاده نمایید.',
        'Enable it here!' => 'از اینجا فعال نمائید',
        'Edit Customer Default Groups' => 'ویرایش گروه‌های پیش‌فرض مشترکین',
        'These groups are automatically assigned to all customers.' => 'این گروه‌ها به صورت خودکار به تمام مشترکین اعمال می‌شوند.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'شما می‌توانید این گروه‌ها را از طریق تنظیم پیکربندی "CustomerGroupAlwaysGroups" مدیریت نمایید.',
        'Filter for Groups' => 'فیلتر برای گروه‌ها',
        'Just start typing to filter...' => 'فقط شروع به تایپ برای فیلتر ...',
        'Select the customer:group permissions.' => 'انتخاب دسترسی‌های مشترک:گروه',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'اگرچیزی انتخاب نشود، هیچ دسترسی در این گروه موجود نیست (درخواست‌ها برای مشترک در دسترس نیست)',
        'Search Results' => 'نتیجه جستجو',
        'Customers' => 'مشترکین',
        'No matches found.' => 'هیچ موردی یافت نشد.',
        'Groups' => 'گروه‌ها',
        'Change Group Relations for Customer' => 'تغییر ارتباطات گروه برای مشترک',
        'Change Customer Relations for Group' => 'تغییر ارتباطات مشترک برای گروه',
        'Toggle %s Permission for all' => 'اعمال دسترسی %s برای همه',
        'Toggle %s permission for %s' => 'تعویض %s اجازه %s',
        'Customer Default Groups:' => 'گروه‌های پیش‌فرض مشترک',
        'No changes can be made to these groups.' => 'هیچ تغییری نمی‌توان به این گروه‌ها اعمال کرد.',
        'ro' => 'فقط خواندنی',
        'Read only access to the ticket in this group/queue.' => 'حق فقط خواندنی برای درخواست‌ها در این گروه /لیست.',
        'rw' => 'خواندنی و نوشتنی',
        'Full read and write access to the tickets in this group/queue.' =>
            'دسترسی کامل به درخواست‌ها در این لیست / گروه.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'مدیریت روابط مشترک-خدمات',
        'Edit default services' => 'ویرایش خدمات پیش‌فرض',
        'Filter for Services' => 'فیلتر برای خدمات',
        'Allocate Services to Customer' => 'اختصاص خدمات به مشترک',
        'Allocate Customers to Service' => 'اختصاص مشترکین به خدمت',
        'Toggle active state for all' => 'اعمال وضعیت فعال برای همه',
        'Active' => 'فعال',
        'Toggle active state for %s' => 'اعمال وضعیت فعال برای %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'مدیریت پویای زمینه',
        'Add new field for object' => 'اضافه کردن فیلد جدید برای موضوع',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'برای اضافه کردن یک رشته جدید، نوع رشته را از یکی موضوع های لیست انتخاب کنید، موضوع مرز رشته را تعریف میکند و نمی توان آن را پس از ایجاد رشته  تغییر داد.',
        'Dynamic Fields List' => ' فهرست زمینه حرکتی',
        'Dynamic fields per page' => 'زمینه های پویا در هر صفحه',
        'Label' => 'برچسب',
        'Order' => 'ترتیب',
        'Object' => 'مورد',
        'Delete this field' => 'حذف این قسمت',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'آیا شما واقعا می خواهید  این زمینه پویارا حذف کنید؟ تمام داده های مرتبط از دست خواهد رفت.',
        'Delete field' => 'حذف زمینه',
        'Deleting the field and its data. This may take a while...' => 'حذف رشته و داده های آن. این ممکن است یک مدت طول بکشد.....',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'رشته های پویا',
        'Field' => 'رشته',
        'Go back to overview' => 'برگرد به نمایش مجموعه',
        'General' => 'عمومی',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'این فیلد مورد نیاز است، و بها باید فقط حروف و عدد باشد.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'باید منحصر به فرد باشد و تنها حروف و عددی را بپذیرید.',
        'Changing this value will require manual changes in the system.' =>
            'تغییر این مقدار خواهد تغییرات دستی در سیستم نیاز داشته باشد.',
        'This is the name to be shown on the screens where the field is active.' =>
            'این نام به بر روی صفحه نمایش که در آن زمینه فعال است نشان داده شده است.',
        'Field order' => 'سفارش درست',
        'This field is required and must be numeric.' => 'این فیلد الزامی است و باید عدد باشد.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'این نظم که در آن این زمینه خواهد شد بر روی صفحه نمایش که در آن فعال است نشان داده شده است.',
        'Field type' => 'نوع رشته',
        'Object type' => 'نوع موضوع',
        'Internal field' => 'رشته داخلی',
        'This field is protected and can\'t be deleted.' => 'در این زمینه محافظت شده است و نمی تواند حذف شود.',
        'Field Settings' => 'تنظیمات درست',
        'Default value' => 'مقدار پیش‌فرض',
        'This is the default value for this field.' => 'این مقدار پیش فرض برای این رشته است.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'تفاوت تاریخ به طور پیش فرض',
        'This field must be numeric.' => 'در این زمینه باید عدد باشد.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'تفاوت از شرکت (در ثانیه) برای محاسبه درست مقدار پیش فرض (به عنوان مثال 3600 یا -60).',
        'Define years period' => 'تعریف دوره سال',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'فعال کردن این ویژگی برای تعریف یک محدوده ثابت از سال (در آینده و در گذشته) در بخشی از سال نمایش داده می شود.',
        'Years in the past' => 'سال در گذشته',
        'Years in the past to display (default: 5 years).' => 'سال در گذشته برای نمایش (به طور پیش فرض: 5 سال).',
        'Years in the future' => 'سال در آینده',
        'Years in the future to display (default: 5 years).' => 'سال در آینده برای نمایش (به طور پیش فرض: 5 سال).',
        'Show link' => 'نمایش لینک',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'در اینجا شما می توانید یک لینک HTTP اختیاری برای مقدار فیلد در صفحه نمایش بررسی ها و زوم را مشخص کنید.',
        'Link for preview' => 'لینک برای پیش نمایش',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'اگر در پر شده است، این URL خواهد شد برای یک پیش نمایش است که نشان داده شده است که این پیوند در زوم بلیط ماند استفاده می شود. لطفا توجه داشته باشید که برای این کار، زمینه URL به طور منظم بالا نیاز به در شود پر شده است، بیش از حد.',
        'Restrict entering of dates' => 'محدود کردن ورود از  تاریخ',
        'Here you can restrict the entering of dates of tickets.' => 'در اینجا شما می توانید تاریخ درخواست ورود را محدود کنید .',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'مقادیر ممکن',
        'Key' => 'کلید',
        'Value' => 'مقدار',
        'Remove value' => 'حذف مقدار',
        'Add value' => 'اضافه کردن مقدار',
        'Add Value' => 'اضافه کردن مقدار',
        'Add empty value' => 'اضافه کردن مقدار خالی',
        'Activate this option to create an empty selectable value.' => 'این گزینه را برای ساختن یک مقدارخالی انتخابی فعال کنید',
        'Tree View' => 'نمای درختی',
        'Activate this option to display values as a tree.' => 'این گزینه را برای نمایش مقادیر درختی فعال کنید.',
        'Translatable values' => 'ارزش ترجمه',
        'If you activate this option the values will be translated to the user defined language.' =>
            'اگر این گزینه را فعال شدن ارزش خواهد شد به زبان تعریف شده توسط کاربر ترجمه شده است.',
        'Note' => 'یادداشت',
        'You need to add the translations manually into the language translation files.' =>
            'شما نیاز به اضافه کردن ترجمه دستی برای فایل های ترجمه زبان دارید .',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'تعداد ردیف',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'شاخص ارتفاع (در خط) در این زمینه در حالت ویرایش است  . ',
        'Number of cols' => 'تعداد گذرگاه',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'مشخص عرض (در شخصیت) برای این رشته در حالت ویرایش.',
        'Check RegEx' => 'بررسی عبارت منظم',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'در اینجا شما می توانید یک عبارت منظم برای بررسی ارزش را مشخص کنید. عبارت منظم خواهد شد با اصلاح XMS اجرا شده است.',
        'RegEx' => 'عبارت منظم',
        'Invalid RegEx' => 'عبارت منظم نامعتبر',
        'Error Message' => 'پیغام خطا',
        'Add RegEx' => 'اضافه کردن عبارت منظم',

        # Template: AdminEmail
        'Admin Notification' => 'اعلام مدیر سیستم',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'با استفاده از این ماژول، مدیران سیستم می‌توانند پیغام‌ها را به کارشناسان، گروه‌ها و یا اعضای با نقش خاص ارسال کنند.',
        'Create Administrative Message' => 'ساخت پیغام مدیریتی',
        'Your message was sent to' => 'پیغام شما ارسال شد برای',
        'Send message to users' => 'ارسال پیغام به کاربران',
        'Send message to group members' => 'ارسال پیغام به اعضای گروه',
        'Group members need to have permission' => 'اعضای گروه نیاز به داشتن دسترسی دارند',
        'Send message to role members' => 'ارسال پیغام به اعضای یک نقش',
        'Also send to customers in groups' => 'برای مشترکین عضو گروه هم ارسال شود',
        'Body' => 'متن نامه',
        'Send' => 'ارسال',

        # Template: AdminGenericAgent
        'Generic Agent' => 'کارشناس عمومی',
        'Add job' => 'افزودن کار',
        'Last run' => 'آخرین اجرا',
        'Run Now!' => 'اجرا',
        'Delete this task' => 'حذف این وظیفه',
        'Run this task' => 'اجرای این وظیفه',
        'Do you really want to delete this task?' => 'آیا شما واقعا می خواهید این کار را حذف کنید؟',
        'Job Settings' => 'تنظیمات کار',
        'Job name' => 'نام کار',
        'The name you entered already exists.' => 'نامی که وارد کردید درحال حاضر وجود دارد.',
        'Toggle this widget' => 'اعمال این ابزارک',
        'Automatic execution (multiple tickets)' => 'اجرا به صورت خودکار (درخواست های متعدد)',
        'Execution Schedule' => 'برنامه اجرایی',
        'Schedule minutes' => 'زمانبندی دقایق',
        'Schedule hours' => 'زمانبندی ساعات',
        'Schedule days' => 'زمانبندی روزها',
        'Currently this generic agent job will not run automatically.' =>
            'این کار اتوماتیک در حال حاضر به طور خودکار انجام نخواهد شد',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'برای فعال کردن اجرای خودکار اقلا یکی از موارد دقیقه، ساعت یا روز را مقدار دهی کنید!',
        'Event based execution (single ticket)' => 'اجرای مبتنی بر رویداد (بلیط تک)',
        'Event Triggers' => 'رویداد راه انداز',
        'List of all configured events' => 'فهرست از تمام وقایع پیکربندی',
        'Delete this event' => 'حذف این رویداد',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'علاوه بر این و یا معادل آن به اعدام های دوره ای، شما می توانید حوادث بلیط که این کار را آغاز کند را تعریف کنیم.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'اگر یک رویداد بلیط شلیک می شود، فیلتر بلیط اعمال خواهد شد به بررسی در صورتی که بلیط منطبق است. تنها پس از آن کار است که بر روی بلیط را اجرا کنید.',
        'Do you really want to delete this event trigger?' => 'آیا شما واقعا می خواهید این محرک رویداد را حذف کنید  .',
        'Add Event Trigger' => 'اضافه کردن رویداد راه انداز',
        'Add Event' => 'اضافه کردن رویداد',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'برای اضافه کردن یک رویداد جدید انتخاب موضوع رویداد و نام  رویداد و کلیک بر روی  دکمه \ "+ " میباشد',
        'Duplicate event.' => 'تکرار رویداد.',
        'This event is already attached to the job, Please use a different one.' =>
            'این رویداد در حال حاضر به این کار متصل است، لطفا یک رویداد دیگر را استفاده کنید.',
        'Delete this Event Trigger' => 'حذف این رویداد راه انداز',
        'Remove selection' => 'حذف انتخاب',
        'Select Tickets' => 'درخواست را انتخاب کنید',
        '(e. g. 10*5155 or 105658*)' => '(مثال: ۱۰*۵۱۵۵ یا ۱۰۵۶۵۸*)',
        '(e. g. 234321)' => '(مثال: ۲۳۴۳۲۱)',
        'Customer user' => 'مشترک',
        '(e. g. U5150)' => '(مثال: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'جستجوی تمام متن در مطالب (مثال: "Mar*in")',
        'Agent' => 'کارشناس',
        'Ticket lock' => 'تحویل درخواست',
        'Create times' => 'زمان‌های ساخت',
        'No create time settings.' => 'تنظیمی برای زمان ایجاد درخواست وجود ندارد',
        'Ticket created' => 'زمان ایجاد درخواست',
        'Ticket created between' => 'بازه زمانی ایجاد درخواست',
        'Last changed times' => 'زمان آخرین تغییر ',
        'No last changed time settings.' => 'بدون آخرین تغییرات تنظیمات زمان .',
        'Ticket last changed' => 'آخرین تغییردرخواست ',
        'Ticket last changed between' => 'بین آخرین تغییر درخواست ',
        'Change times' => ' تغییر زمان',
        'No change time settings.' => 'هیچ تنظیمی برای تغییر زمان وجود ندارد',
        'Ticket changed' => 'درخواست تغییر داده شده',
        'Ticket changed between' => 'درخواست تغییر داده شده بین',
        'Close times' => 'زمان‌های بستن',
        'No close time settings.' => 'زمان بستن تنظیم نشده است',
        'Ticket closed' => 'درخواست بسته شده',
        'Ticket closed between' => 'درخواست بسته شده بین',
        'Pending times' => 'زمان‌های تعلیق',
        'No pending time settings.' => ' تنظیمی برای زمان تعلیق درخواست وجود ندارد ',
        'Ticket pending time reached' => 'زمان سررسید تعلیق ',
        'Ticket pending time reached between' => 'بازه زمانی سررسید تعلیق',
        'Escalation times' => 'زمان‌های نهایی پاسخگویی',
        'No escalation time settings.' => 'بدون هر گونه تنظیم برای زمان ارتقای اولویت در صف',
        'Ticket escalation time reached' => 'زمان ارتقای اولویت درخواست در صف فرا رسیده است',
        'Ticket escalation time reached between' => 'زمان ارتقای اولویت در صف بین',
        'Escalation - first response time' => 'زمان نهایی پاسخ - زمان اولین پاسخگویی',
        'Ticket first response time reached' => 'زمان اولین پاسخگویی به درخواست فرا رسیده است',
        'Ticket first response time reached between' => 'زمان اولین پاسخگویی به درخواست بین',
        'Escalation - update time' => 'زمان نهایی پاسخ - زمان به‌روز رسانی',
        'Ticket update time reached' => 'زمان به‌روز رسانی درخواست فرا رسیده است',
        'Ticket update time reached between' => 'زمان به‌روز رسانی درخواست بین',
        'Escalation - solution time' => 'زمان نهایی پاسخ - زمان حل درخواست',
        'Ticket solution time reached' => 'زمان حل درخواست فرا رسیده است',
        'Ticket solution time reached between' => 'زمان حل درخواست بین',
        'Archive search option' => 'آرشیو گزینه‌های جستجو',
        'Update/Add Ticket Attributes' => 'به روز رسانی / اضافه کردن لیست درخواست ',
        'Set new service' => 'تنظیم سرویس جدید',
        'Set new Service Level Agreement' => 'تنظیم توافق سطح سرویس جدید',
        'Set new priority' => 'تنظیم الویت جدید',
        'Set new queue' => 'تنظیم صف درخواست جدید',
        'Set new state' => 'تنظیم وضعیت جدید',
        'Pending date' => 'تاریخ تعلیق',
        'Set new agent' => 'تنظیم کارشناس جدید',
        'new owner' => 'صاحب جدید',
        'new responsible' => ' مسئول جدید',
        'Set new ticket lock' => 'تنظیم تحویل درخواست جدید',
        'New customer user' => ' مشتری کاربر جدید',
        'New customer ID' => 'شناسه مشترک جدید',
        'New title' => 'عنوان جدید',
        'New type' => 'نوع جدید',
        'New Dynamic Field Values' => 'مقادیر جدید پویا درست',
        'Archive selected tickets' => 'آرشیو درخواست‌های انتخاب شده',
        'Add Note' => 'افزودن یادداشت',
        'Time units' => 'واحد زمان',
        'Execute Ticket Commands' => 'اجرای دستورات درخواست ',
        'Send agent/customer notifications on changes' => 'آگاه کردن کارشناس/مشتری به هنگام ایجاد تغییرات',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'این دستور اجرا خواهد شد. ARG[0] شماره درخواست و ARG[1] id آن خواهد بود.',
        'Delete tickets' => 'حذف درخواست‌ها',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'اخطار: تمامی درخواست‌های تاثیر یافته از پایگاه داده حذف خواهد شد و قابل بازیابی نخواهد بود!',
        'Execute Custom Module' => 'اجرای ماژول سفارشی',
        'Param %s key' => 'PARAM %s کلید',
        'Param %s value' => 'PARAM %s ارزش',
        'Save Changes' => 'ذخیره‌سازی تغییرات',
        'Results' => 'نتیجه',
        '%s Tickets affected! What do you want to do?' => '%s درخواست تاثیر خواهند پذیرفت! می‌خواهید چه کاری انجام دهید؟',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'اخطار: شما از گزینه حذف استفاده کرده‌اید. تمامی درخواست‌های حذف شده از بین خواهند رفت!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'هشدار: وجود دارد %s بلیط تحت تاثیر قرار اما تنها %s ممکن است در طول یک اجرا کار اصلاح!',
        'Edit job' => 'ویرایش کار',
        'Run job' => 'اجرای کار',
        'Affected Tickets' => 'درخواست‌های تاثیر یافته',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'GenericInterface دیباگر برای وب سرویس %s',
        'You are here' => 'تو اینجایی',
        'Web Services' => 'وب سرویس',
        'Debugger' => 'اشکال زدا',
        'Go back to web service' => 'برگشت به وب سرویس',
        'Clear' => 'واضح',
        'Do you really want to clear the debug log of this web service?' =>
            'آیا شما واقعا می خواهید برای روشن ورود به سیستم اشکال زدایی از این وب سرویس؟',
        'Request List' => 'لیست درخواست',
        'Time' => 'زمان',
        'Remote IP' => 'از راه دور IP',
        'Loading' => 'در حال اجرا',
        'Select a single request to see its details.' => 'یک درخواست تکی برای دیدن جزئیات آن انتخاب کنید.',
        'Filter by type' => 'فیلتر بر اساس نوع',
        'Filter from' => 'فیلتر از',
        'Filter to' => 'فیلتر برای',
        'Filter by remote IP' => 'فیلتر بر اساس راه دور IP',
        'Limit' => 'محدوده',
        'Refresh' => 'بازیابی',
        'Request Details' => 'جزئیات درخواست',
        'An error occurred during communication.' => 'یک خطا در هنگام برقراری ارتباط رخ داده است.',
        'Show or hide the content.' => 'نمایش یا مخفی کردن محتوا.',
        'Clear debug log' => 'پاک کردن گزارش اشکال زدایی',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'اضافه کردن Invoker جدید به وب سرویس %s',
        'Change Invoker %s of Web Service %s' => 'تغییر Invoker %s از وب سرویس %s',
        'Add new invoker' => 'اضافه کردن invoker جدید',
        'Change invoker %s' => 'تغییر invoker %s',
        'Do you really want to delete this invoker?' => 'آیا شما واقعا می خواهید این invoker را حذف کنید؟',
        'All configuration data will be lost.' => 'همه داده های پیکربندی  از دست خواهد رفت.',
        'Invoker Details' => 'Invoker اطلاعات',
        'The name is typically used to call up an operation of a remote web service.' =>
            'نام معمولا برای پاسخ یک عملیات از یک وب سرویس از راه دور.',
        'Please provide a unique name for this web service invoker.' => 'لطفا یک نام منحصر به فرد برای این invoker وب سرویس ارائه کنید .',
        'Invoker backend' => 'باطن Invoker',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'این invoker ماژول باطن OTRS خواهد شد به نام برای آماده سازی داده ها به سیستم از راه دور ارسال می شود، و برای پردازش داده ها پاسخ آن است.',
        'Mapping for outgoing request data' => 'نقشه برداری برای درخواست داده های خروجی',
        'Configure' => 'تنظیمات',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'داده ها از فراخواننده OTRS خواهد شد این نقشه برداری پردازش، آن را تبدیل به نوع داده سیستم از راه دور انتظار.',
        'Mapping for incoming response data' => 'نگاشت برای پاسخ داده های ورودی ',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'پاسخ داده خواهد شد این نقشه برداری پردازش، آن را تبدیل به نوع داده فراخواننده OTRS انتظار.',
        'Asynchronous' => 'ناهمگام',
        'This invoker will be triggered by the configured events.' => 'این invoker باعث ایجاد حوادث پیکربندی خواهد شد . ',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'باعث رویداد آسنکرون توسط OTRS زمانبند شبح در پس زمینه به کار گرفته (توصیه می شود).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'باعث رویداد همزمان می تواند به طور مستقیم در طول درخواست وب پردازش شده است.',
        'Save and continue' => 'ذخیره و ادامه',
        'Delete this Invoker' => 'حذف این Invoker',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'GenericInterface نقشه برداری ساده برای وب سرویس %s',
        'Go back to' => 'بازگشت به',
        'Mapping Simple' => 'نگاشت ساده',
        'Default rule for unmapped keys' => 'قانونی به طور پیش فرض برای کلیدها در نگاشت نیامده',
        'This rule will apply for all keys with no mapping rule.' => 'این قانون برای تمام کلید ها با قانون نگاشت اعمال می شود.',
        'Default rule for unmapped values' => 'قانون به طور پیش فرض برای مقادیر نگاشت نیامده',
        'This rule will apply for all values with no mapping rule.' => 'این قانون برای همه با ارزش  قانون نگاشت اعمال نمی شود.',
        'New key map' => 'نگاشت کلید جدید',
        'Add key mapping' => 'اضافه کردن نگاشت کلید',
        'Mapping for Key ' => 'نگاشت برای کلید ',
        'Remove key mapping' => 'حذف نگاشت کلید ',
        'Key mapping' => 'نگاشت کلید',
        'Map key' => 'نگاشت کلیدی ',
        'matching the' => 'تطبیق با',
        'to new key' => 'به کلید جدید',
        'Value mapping' => 'ارزش نگاشت ',
        'Map value' => 'ارزش نگاشت',
        'to new value' => 'به ارزش های جدید',
        'Remove value mapping' => 'حذف ارزش نگاشت ',
        'New value map' => ' مقدار جدید نگاشت',
        'Add value mapping' => 'اضافه کردن ارزش نگاشت',
        'Do you really want to delete this key mapping?' => 'آیا شما واقعا می خواهید  این نگاشت کلید را حذف کنید؟',
        'Delete this Key Mapping' => 'حذف این نگاشت کلید',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => 'نگاشت GenericInterface XSLT برای وب سرویس %s',
        'Mapping XML' => 'نگاشت XML',
        'Template' => 'قالب',
        'The entered data is not a valid XSLT stylesheet.' => 'شیوه داده های وارد شده XSLT معتبر نیست.',
        'Insert XSLT stylesheet.' => 'شیوه قرار دادن XSLT .',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'اضافه کردن عملیات جدید به وب سرویس %s',
        'Change Operation %s of Web Service %s' => 'تغییر عملیات %s از وب سرویس %s',
        'Add new operation' => 'اضافه کردن عملیات جدید',
        'Change operation %s' => 'تغییر عملیات %s',
        'Do you really want to delete this operation?' => 'آیا واقعا میخواهید این عملیات را حذف کنید؟',
        'Operation Details' => 'جزئیات عملیات',
        'The name is typically used to call up this web service operation from a remote system.' =>
            ' نام بطور معمول از یک سیستم از راه دور برای تماس با این وب سرویس استفاده میشود . ',
        'Please provide a unique name for this web service.' => 'لطفا یک نام منحصر به فرد برای این وب سرویس ارائه دهید .',
        'Mapping for incoming request data' => 'نگاشت برای درخواست داده های ورودی',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'داده درخواست خواهد شد این نقشه برداری پردازش، آن را تبدیل به نوع OTRS داده انتظار دارد.',
        'Operation backend' => 'باطن عمل',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'این عملیات ماژول باطن OTRS صورت داخلی نامیده خواهد شد به پردازش درخواست، تولید داده ها را برای پاسخ.',
        'Mapping for outgoing response data' => 'نگاشت برای پاسخ خروجی داده ',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'پاسخ داده خواهد شد این نقشه برداری پردازش، آن را تبدیل به نوع داده سیستم از راه دور انتظار.',
        'Delete this Operation' => 'حذف این عملیات',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'انتقال HTTP :: REST برای وب سرویس %s توسط GenericInterface ',
        'Network transport' => 'انتقال شبکه ای',
        'Properties' => 'خواص',
        'Route mapping for Operation' => 'نگاشت مسیر برای عملیات',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'تعریف مسیر است که باید به این عملیات نقشه برداری. متغیرهای مشخص شده توسط \':\' خواهد شد به نام وارد شده نقشه برداری و سرانجام همراه با دیگران به نقشه برداری. (به عنوان مثال / درخواست /: TicketID).',
        'Valid request methods for Operation' => 'روش درخواست معتبر برای عملیات',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'محدود کردن این عملیات به روش درخواست خاص. اگر هیچ روشی انتخاب نشده است همه درخواست ها پذیرفته خواهد شد .',
        'Maximum message length' => 'حداکثر طول پیام',
        'This field should be an integer number.' => 'در این زمینه باید یک عدد صحیح باشد.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'اینجا شما می توانید حداکثر اندازه (در بایت) از پیام های REST که OTRS پردازش را مشخص کنید.',
        'Send Keep-Alive' => 'ارسال حفظ',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'این تنظیمات را تعریف می کند اگر اتصالات ورودی باید بسته شدن و یا زنده نگه داشت.',
        'Host' => 'میزبان',
        'Remote host URL for the REST requests.' => 'URL میزبان راه دور برای درخواست بقیه.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'به عنوان مثال https://www.otrs.com:10745/api/v1.0 (بدون دنباله بک اسلش)',
        'Controller mapping for Invoker' => ' برای  کنترل نگاشت Invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'کنترل که فراخواننده باید درخواست برای ارسال. متغیرهای مشخص شده توسط \':\' خواهد شد با مقدار داده جایگزین و سرانجام همراه با درخواست. (به عنوان مثال / درخواست /: TicketID صفحهی =: صفحهی و رمز عبور =: رمز عبور).',
        'Valid request command for Invoker' => 'درخواست فرماندهی معتبر برای Invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'فرمان HTTP خاص برای استفاده برای درخواست با این Invoker (اختیاری).',
        'Default command' => 'دستور پیش فرض',
        'The default HTTP command to use for the requests.' => 'دستور HTTP به طور پیش فرض برای استفاده از درخواست.',
        'Authentication' => 'احراز هویت',
        'The authentication mechanism to access the remote system.' => 'مکانیزم احراز هویت برای دسترسی به سیستم از راه دور.',
        'A "-" value means no authentication.' => 'A \ "- " ارزش به معنی هیچ احراز هویت.',
        'The user name to be used to access the remote system.' => 'نام کاربری مورد استفاده قرار گیرد برای دسترسی به سیستم از راه دور.',
        'The password for the privileged user.' => 'رمز عبور برای کاربر ممتاز.',
        'Use SSL Options' => 'استفاده از گزینه های SSL',
        'Show or hide SSL options to connect to the remote system.' => 'نمایش یا عدم نمایش گزینه های SSL برای اتصال به سیستم از راه دور.',
        'Certificate File' => 'فایل گواهی',
        'The full path and name of the SSL certificate file.' => 'مسیر کامل و نام فایل گواهی SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'به عنوان مثال /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'گواهی رمز عبور فایل',
        'The full path and name of the SSL key file.' => 'مسیر کامل و نام فایل کلید SSL.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'به عنوان مثال /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'مجوز صدور گواهینامه (CA) فایل',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'مسیر کامل و نام فایل گواهی مرجع صدور گواهینامه که تایید گواهی اس اس ال است.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'به عنوان مثال /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'GenericInterface حمل و نقل HTTP :: SOAP برای وب سرویس %s',
        'Endpoint' => 'نقطه پایانی',
        'URI to indicate a specific location for accessing a service.' =>
            'URI نشان می دهد یک مکان خاص را برای دسترسی به یک سرویس.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'به عنوان مثال http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'فضای نام',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI به روش SOAP زمینه ای، کاهش ابهامات.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'به عنوان مثال کوزه: OTRS-COM: صابون: توابع و یا http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => ' درخواست پاسخ به طرح نام',
        'Select how SOAP request function wrapper should be constructed.' =>
            'انتخاب کنید که چگونه SOAP تابع درخواست لفاف بسته بندی باید ساخته شود.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '"FunctionName» به عنوان مثال برای نام واقعی invoker / عملیات استفاده می شود.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '"گه از FREETEXT» به عنوان مثال برای ارزش پیکربندی واقعی استفاده می شود.',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'متن باید به عنوان نام تابع لفاف بسته بندی پسوند و یا جایگزینی استفاده  شود.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'لطفا عنصر XML نامگذاری محدودیت در نظر (به عنوان مثال استفاده نمیشود "<" و "و").',
        'Response name scheme' => 'درخواست پاسخ به طرح نام',
        'Select how SOAP response function wrapper should be constructed.' =>
            'انتخاب کنید که چگونه تابع پاسخ SOAP لفاف بسته بندی باید ساخته شود.',
        'Response name free text' => 'نام پاسخ های متنی رایگان',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'اینجا شما می توانید حداکثر اندازه (در بایت) از پیام های SOAP که OTRS پردازش می کند را مشخص کنید.',
        'Encoding' => 'کدگذاری',
        'The character encoding for the SOAP message contents.' => 'رمزگذاری کاراکتر برای محتویات پیام SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'به عنوان مثال UTF-8، latin1، ISO-8859-1، cp1250، و غیره',
        'SOAPAction' => 'SOAPAction',
        'Set to "Yes" to send a filled SOAPAction header.' => 'تنظیم کنید تا \ "بله " برای ارسال یک ضربه SOAPAction پر شده است.',
        'Set to "No" to send an empty SOAPAction header.' => 'تنظیم به \ "بدون " را به ارسال یک هدر SOAPAction خالی است.',
        'SOAPAction separator' => 'تفکیک کننده SOAPAction',
        'Character to use as separator between name space and SOAP method.' =>
            'از رقم به عنوان تفکیک کننده  فضای بین نام و روش SOAP استفاده کنید.',
        'Usually .Net web services uses a "/" as separator.' => 'معمولا خدمات وب دات نت استفاده می کند از یک \ "/ " به عنوان تفکیک کننده.',
        'Proxy Server' => 'سرور پروکسی',
        'URI of a proxy server to be used (if needed).' => 'URI از یک پروکسی سرور مورد استفاده قرار گیرد (در صورت نیاز).',
        'e.g. http://proxy_hostname:8080' => 'به عنوان مثال از http: // proxy_hostname: 8080',
        'Proxy User' => 'کاربر پروکسی',
        'The user name to be used to access the proxy server.' => 'نام کاربری برای دسترسی به پروکسی سرور مورد استفاده قرار گیرد .',
        'Proxy Password' => 'رمز عبور پروکسی',
        'The password for the proxy user.' => 'رمز عبور برای کاربران پروکسی.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'مسیر کامل و نام فایل گواهی SSL (باید در .p12 فرمت شود).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'به عنوان مثال /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'رمز عبور برای باز کردن گواهی اس اس ال.',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'مسیر کامل و نام فایل گواهی اقتدار صدور گواهینامه که تایید گواهینامه SSL.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'به عنوان مثال /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'مجوز (CA) راهنمای',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'مسیر کامل دایرکتوری که در آن اقتدار صدور گواهینامه گواهی CA ها در سیستم فایل ذخیره می شود.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'به عنوان مثال / انتخاب کردن / OTRS / ور / گواهی / SOAP / CA',
        'Sort options' => 'گزینه های مرتب سازی',
        'Add new first level element' => 'اضافه کردن عنصر جدید سطح اول',
        'Element' => 'عنصر',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'مرتب کردن عازم ناحیه دور دست برای زمینه های XML (ساختار شروع زیر نام تابع لفاف بسته بندی) - مشاهده اسناد و مدارک برای حمل و نقل SOAP.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'مدیریت GenericInterface وب سرویس',
        'Add web service' => 'اضافه کردن وب سرویس',
        'Clone web service' => 'وب سرویس کلون',
        'The name must be unique.' => 'این نام باید منحصر به فرد باشد.',
        'Clone' => 'کلون',
        'Export web service' => 'وب سرویس صادرات',
        'Import web service' => 'وب سرویس واردات',
        'Configuration File' => 'فایل پیکربندی',
        'The file must be a valid web service configuration YAML file.' =>
            'فایل باید یک وب سرویس فایل پیکربندی YAML معتبر باشد.',
        'Import' => 'ورود اطلاعات',
        'Configuration history' => 'تاریخ پیکربندی',
        'Delete web service' => 'حذف وب سرویس',
        'Do you really want to delete this web service?' => 'آیا شما واقعا  حذف این وب سرویس رامی خواهید؟',
        'Ready-to-run Web Services' => 'آماده به اجرای خدمات وب',
        'Here you can activate ready-to-run web services showcasing our best practices that are a part of %s.' =>
            'در اینجا شما می توانید از خدمات وب سایت آماده به اجرا فعال شدن نمایش بهترین شیوه های ما هستند که بخشی از %s .',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'لطفا توجه داشته باشید که این خدمات وب ممکن است در دیگر ماژول فقط با خاص در دسترس بستگی دارد %s سطح قرارداد (وجود خواهد داشت اطلاع رسانی با جزئیات بیشتر در هنگام وارد کردن).',
        'Import ready-to-run web service' => 'واردات آماده به اجرا وب سرویس',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated ready-to-run web services.' =>
            'دوست دارید از خدمات وب سایت ایجاد شده توسط کارشناسان بهره مند شوند؟ ارتقا به %s به واردات برخی از خدمات وب پیچیده آماده به اجرا.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'پس از این که تنظیمات را ذخیره کنید به شما خواهد شد دوباره به صفحه ویرایش هدایت می شوید.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'اگر می خواهید بازگشت به نمای کلی لطفا با کلیک بر \ "برو به بررسی اجمالی " را فشار دهید.',
        'Web Service List' => 'فهرست وب سرویس',
        'Remote system' => 'سیستم از راه دور',
        'Provider transport' => 'ارائه دهنده حمل و نقل ',
        'Requester transport' => ' درخواست حمل و نقل',
        'Debug threshold' => 'آستانه اشکال زدایی',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'در حالت ارائه دهنده، OTRS ارائه می دهد خدمات وب که توسط سیستم های راه دور استفاده می شود.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'در حالت درخواست، OTRS با استفاده از خدمات وب سیستم های از راه دور.',
        'Operations are individual system functions which remote systems can request.' =>
            'عملیات توابع سیستم منحصر به فرد است که سیستم از راه دور می توانید درخواست هستند.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokers آماده سازی داده برای یک درخواست به یک وب سرویس از راه دور، و پردازش داده ها پاسخ آن است.',
        'Controller' => 'کنترل کننده',
        'Inbound mapping' => 'نقشه برداری بین المللی به درون',
        'Outbound mapping' => 'نقشه برداری عازم ناحیه دور دست',
        'Delete this action' => 'حذف این اقدام',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'حداقل یک %s دارای یک کنترلر است که یا فعال و یا وجود ندارد، لطفا ثبت نام کنترل را بررسی کنید و یا حذف %s',
        'Delete webservice' => 'حذف از webservice',
        'Delete operation' => 'حذف عملیات',
        'Delete invoker' => 'حذف invoker',
        'Clone webservice' => 'از webservice کلون',
        'Import webservice' => 'از webservice واردات',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'تاریخچه پیکربندی GenericInterface برای وب سرویس %s',
        'Go back to Web Service' => 'بازگشت به وب سرویس',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'در اینجا شما می توانید نسخه های قدیمی تر از پیکربندی وب سرویس فعلی، صادرات مشاهده و یا حتی آنها را بازگرداند.',
        'Configuration History List' => 'فهرست تاریخچه پیکربندی',
        'Version' => 'نسخه',
        'Create time' => ' زمان ساخت',
        'Select a single configuration version to see its details.' => 'یک نسخه پیکربندی را انتخاب کنید برای دیدن جزئیات آن است.',
        'Export web service configuration' => 'صادرات پیکربندی وب سرویس',
        'Restore web service configuration' => 'بازگرداندن تنظیمات وب سرویس',
        'Do you really want to restore this version of the web service configuration?' =>
            'آیا شما واقعا می خواهید برای بازگرداندن این نسخه از پیکربندی وب سرویس؟',
        'Your current web service configuration will be overwritten.' => 'پیکربندی وب سرویس فعلی خود بازنویسی خواهد شد.',
        'Restore' => 'بازیابی',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'هشدار: اگر قبل از اعمال تغییرات مناسب در SysConfig نام گروه admin را تغییر دهید، دسترسی‌تان به بخش مدیریت سیستم از بین می‌رود! اگر چنین اتفاقی افتاد، نام آن را از طریق SQL دوباره به admin تغییر دهید.',
        'Group Management' => 'مدیریت گروه‌ها',
        'Add group' => 'افزودن گروه',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'گروه admin برای دسترسی به بخش مدیریت سیستم و گروه stats برای دسترسی به بخش گزارشات است.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'گروه‌های جدید بسازید تا دسترسی‌ها را برای گروه‌های مختلف کارشناسان مدیریت کنید (مثال: بخش خرید، بخش پشتیبانی، بخش فروش و ...)',
        'It\'s useful for ASP solutions. ' => 'این برای راه‌حل‌های ASP مفید می‌باشد.',
        'total' => 'مجموع',
        'Add Group' => 'ایجاد گروه',
        'Edit Group' => 'ویرایش گروه',

        # Template: AdminLog
        'System Log' => 'وقایع ثبت شده سیستم',
        'Here you will find log information about your system.' => 'در اینجا اطلاعات ثبت شده‌ای در رابطه با سیستم پیدا خواهید کرد.',
        'Hide this message' => 'پنهان کردن این پیغام',
        'Recent Log Entries' => 'وقایع ثبت شده جدید',

        # Template: AdminMailAccount
        'Mail Account Management' => 'مدیریت حساب‌های ایمیل ',
        'Add mail account' => 'افزودن حساب ایمیل',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'همه ایمیل‌های وارده از طریق یک آدرس به لیست درخواست انتخاب شده منتقل خواهد شد !',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'درصورتیکه آدرس شما مجاز و قابل اطمینان باشد زمان دریافت در header سیستم اولویت را تعیین کرده و پیام‌ها ارسال خواهد شد',
        'Delete account' => 'حذف حساب',
        'Fetch mail' => 'واکشی ایمیل',
        'Add Mail Account' => 'افزودن حساب ایمیل',
        'Example: mail.example.com' => 'مثال: mail.example.com',
        'IMAP Folder' => 'پوشه IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'فقط این را تغییر دهید اگر شما نیاز به دریافت نامه از پوشه های مختلف از صندوق.',
        'Trusted' => 'مجاز',
        'Dispatching' => 'توزیع',
        'Edit Mail Account' => 'ویرایش حساب ایمیل',

        # Template: AdminNavigationBar
        'Admin' => 'مدیریت سیستم',
        'Agent Management' => 'مدیریت کارشناس',
        'Queue Settings' => 'تنظیمات صف درخواست',
        'Ticket Settings' => 'تنظیمات درخواست',
        'System Administration' => 'مدیریت سیستم',
        'Online Admin Manual' => 'مدیریت دستی آن لاین',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'درخواست مدیریت اطلاع رسانی',
        'Add notification' => 'افزودن اعلان',
        'Export Notifications' => 'ارسال اطلاعات',
        'Configuration Import' => 'دریافت پیکربندی',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'در اینجا شما می توانید یک فایل پیکربندی برای واردات اطلاعیه بلیط را به سیستم خود را بارگذاری کنید. فایل نیاز به در فرمت .yml باشد که توسط ماژول اطلاع رسانی بلیط صادر می شود.',
        'Overwrite existing notifications?' => 'بازنویسی اطلاعات موجود؟',
        'Upload Notification configuration' => 'هشدار از طریق بارگذاری پیکربندی ',
        'Import Notification configuration' => ' هشدار از طریق دریافت پیکربندی',
        'Delete this notification' => 'حذف این اعلان',
        'Do you really want to delete this notification?' => 'آیا واقعا میخواهید این اطلاعات را حذف کنید؟',
        'Add Notification' => 'افزودن اعلان',
        'Edit Notification' => 'ویرایش اعلان',
        'Show in agent preferences' => 'نمایش در تنظیمات عامل',
        'Agent preferences tooltip' => 'عامل راهنمای تنظیمات ابزار',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'این پیام خواهد شد بر روی صفحه نمایش تنظیمات عامل به عنوان یک ابزار برای این اطلاع رسانی شده است.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'در اینجا شما می توانید انتخاب کنید که وقایع این اطلاع رسانی را آغاز کند. یک فیلتر بلیط اضافی را می توان زیر اعمال شده به فقط برای بلیط با معیارهای خاصی را ارسال کنید.',
        'Ticket Filter' => 'فیلتر درخواست',
        'Article Filter' => 'فیلتر مطلب',
        'Only for ArticleCreate and ArticleSend event' => 'فقط برای ArticleCreate و ArticleSend رویداد',
        'Article type' => 'نوع نوشته',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'اگر ArticleCreate یا ArticleSend به عنوان یک رویداد ماشه استفاده می شود، شما نیاز به مشخص از یک فیلتر مقاله است. لطفا حداقل یکی از زمینه های مقاله فیلتر را انتخاب کنید.',
        'Article sender type' => ' نوع نوشته فرستنده',
        'Subject match' => 'تطبیق موضوع',
        'Body match' => 'تطبیق بدنه',
        'Include attachments to notification' => 'الحاق پیوست‌ها به اعلان',
        'Recipients' => 'دریافت کنندگان',
        'Send to' => 'فرستادن به',
        'Send to these agents' => 'ارسال به این عوامل',
        'Send to all group members' => 'ارسال به تمام اعضای گروه',
        'Send to all role members' => 'ارسال به تمام نقشهای اعضا',
        'Send on out of office' => 'ارسال در خارج از دفتر',
        'Also send if the user is currently out of office.' => 'همچنین ارسال در صورتی که کاربر در حال حاضر خارج از دفتر.',
        'Once per day' => 'یک بار در روز',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'کاربر اطلاع فقط یک بار در روز با بلیط تک با استفاده از یک حمل و نقل انتخاب در مورد.',
        'Notification Methods' => 'روش های اطلاع رسانی',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'این روش ممکن است که می تواند مورد استفاده برای ارسال این اطلاع رسانی به هر یک از دریافت کنندگان می باشد. لطفا حداقل یک روش زیر انتخاب کنید.',
        'Enable this notification method' => 'فعال کردن این روش اطلاع رسانی',
        'Transport' => 'حمل و نقل',
        'At least one method is needed per notification.' => 'حداقل یک روش در اطلاع رسانی مورد نیاز است.',
        'Active by default in agent preferences' => 'به طور پیش فرض فعال در تنظیمات عامل است',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'این مقدار پیش فرض برای عوامل گیرنده اختصاص داده که یک انتخاب برای این اطلاع رسانی در تنظیمات خود را هنوز رتبهدهی نشده است. اگر در کادر فعال باشد، اطلاع رسانی خواهد شد به چنین عوامل فرستاده می شود.',
        'This feature is currently not available.' => 'این قابلیت در حال حاضر در دسترس نیست.',
        'No data found' => 'داده ای یافت نشد',
        'No notification method found.' => 'هیچ روش اطلاع رسانی یافت نشد.',
        'Notification Text' => 'متن اطلاع رسانی',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'از این زبان در حال حاضر و یا فعال در سیستم نیست. این متن اطلاع رسانی می تواند حذف اگر آن مورد نیاز نیست.',
        'Remove Notification Language' => 'حذف هشدار از طریق زبان',
        'Message body' => 'پیام بدن',
        'Add new notification language' => 'اضافه کردن زبان اطلاع رسانی جدید',
        'Do you really want to delete this notification language?' => 'آیا شما واقعا حذف این زبان اطلاع رسانی را میخواهید؟',
        'Tag Reference' => 'مرجع برچسب',
        'Notifications are sent to an agent or a customer.' => 'اعلام به یک کارشناس یا مشترک ارسال شد.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'برای گرفتن ۲۰ کاراکتر اول موضوع (از آخرین نوشته کارشناس).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'برای گرفتن اولین ۵ خط بدنه (از آخرین نوشته کارشناس).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'برای گرفتن اولین ۲۰ کاراکتر موضوع (از آخرین نوشته مشتری).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'برای گرفتن اولین ۵ خط بدنه (از آخرین نوشته مشتری).',
        'Attributes of the current customer user data' => 'ویژگی های داده های کاربر مشتری فعلی',
        'Attributes of the current ticket owner user data' => 'ویژگی های درخواست فعلی داده های کاربرمالک',
        'Attributes of the current ticket responsible user data' => 'ویژگی های درخواست فعلی داده های کاربر مسئول',
        'Attributes of the current agent user who requested this action' =>
            'ویژگی های عامل کاربر در حال حاضر که این عمل درخواست شده',
        'Attributes of the recipient user for the notification' => 'صفات کاربران دریافت کننده برای اطلاع رسانی',
        'Attributes of the ticket data' => 'ویژگی های درخواست داده ',
        'Ticket dynamic fields internal key values' => 'درخواست زمینه های پویا ارزش های کلیدی داخلی',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'بلیط زمینه های پویا نمایش مقادیر، مفید برای زمینه های کرکره و چندین انتخاب',
        'Example notification' => 'به عنوان مثال اطلاع رسانی ',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'دریافت کننده اضافی آدرس ایمیل ',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',
        'Notification article type' => 'نوع نوشته اعلان',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'یک مقاله ایجاد خواهد شد اگر اطلاع رسانی به مشتریان و یا یک آدرس ایمیل دیگر ارسال می شود.',
        'Email template' => 'قالب ایمیل',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'استفاده از این قالب برای تولید ایمیل کامل (فقط برای ایمیل های HTML).',
        'Enable email security' => 'فعال کردن امنیت ایمیل',
        'Email security level' => 'سطح امنیتی ایمیل',
        'If signing key/certificate is missing' => 'اگر امضای کلید / گواهی از دست رفته است',
        'If encryption key/certificate is missing' => 'اگر کلید رمزنگاری / گواهی از دست رفته است',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'مدیریت %s',
        'Downgrade to OTRS Free' => 'کاهش دادن به OTRS رایگان',
        'Read documentation' => 'خواندن اسناد',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s باعث می شود تماس به طور منظم با cloud.otrs.com برای بررسی در دسترس به روز رسانی و اعتبار قرارداد زمینه ای است.',
        'Unauthorized Usage Detected' => 'استفاده غیر مجاز شناسایی',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'این سیستم با استفاده از %s بدون مجوز مناسب! لطفا تماس با %s به تجدید و یا فعال شدن قرارداد خود را!',
        '%s not Correctly Installed' => '%s به درستی نصب نشده',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'شما %s به درستی نصب نشده است. لطفا آن را با دکمه زیر نصب کنید.',
        'Reinstall %s' => 'نصب مجدد %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'شما %s به درستی نصب نشده است، و نیز یک به روز رسانی در دسترس است.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'شما هم می توانید نصب مجدد نسخه فعلی خود را و یا انجام یک به روز رسانی را با دکمه های زیر (به روز رسانی توصیه می شود).',
        'Update %s' => 'بروز رسانی%2$s',
        '%s Not Yet Available' => '%s هنوز در دسترس است',
        '%s will be available soon.' => '%s به زودی در دسترس خواهد بود.',
        '%s Update Available' => '%s به روز رسانی دردسترس است',
        'An update for your %s is available! Please update at your earliest!' =>
            'به روز رسانی برای خود %s در دسترس است! لطفا در اولین فرصت به روز رسانی کنید !',
        '%s Correctly Deployed' => '%s به درستی مستقر شده',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'تبریک می گویم، شما %s به درستی نصب شده و بروزرسانی شده است !',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '%s به زودی در دسترس خواهد بود. لطفا پس از چند روز دوباره بررسی کنید.',
        'Please have a look at %s for more information.' => 'لطفا نگاهی داشته باشید به  %s برای اطلاعات بیشتر.',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            'OTRS رایگان خود را پایه ای برای تمام اقدامات آینده است. لطفا ابتدا ثبت نام کنید تا با روند ارتقاء ادامه %s !',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'قبل از اینکه شما می توانید از آن بهره مند %s ، لطفا با %s به خود %s قرارداد.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'اتصال به cloud.otrs.com از طریق HTTPS برقرار نشد. لطفا مطمئن شوید که OTRS خود را می توانید به cloud.otrs.com از طریق پورت 443 متصل کنید .  ',
        'With your existing contract you can only use a small part of the %s.' =>
            'با قرارداد های موجود خود را شما فقط می توانید یک بخش کوچک از استفاده %s .',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'اگر شما می خواهم به استفاده کامل از %s از قرارداد خود را به روز رسانی در حال حاضر! تماس با %s .',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'لغو کاهش دادن و بازگشت',
        'Go to OTRS Package Manager' => 'برو به OTRS مدیر بسته',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'با عرض پوزش، اما در حال حاضر شما می توانید با توجه به بسته های زیر که در بستگی دارد جمع و جور کردن %s :',
        'Vendor' => 'عرضه‌کننده',
        'Please uninstall the packages first using the package manager and try again.' =>
            'لطفا ابتدا با استفاده از بسته های مدیر بسته حذف و دوباره امتحان کنید.',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            'شما در حال جمع و جور کردن به OTRS رایگان هستند و ویژگی های زیر است و تمام اطلاعات مربوط به این از دست دادن:',
        'Chat' => 'گپ',
        'Report Generator' => 'گزارش ژنراتور',
        'Timeline view in ticket zoom' => 'نمایش جدول زمانی در زوم بلیط',
        'DynamicField ContactWithData' => 'DynamicField ContactWithData',
        'DynamicField Database' => 'پایگاه DynamicField',
        'SLA Selection Dialog' => 'SLA انتخاب گفت و گو',
        'Ticket Attachment View' => 'نمایش درخواست پیوست ',
        'The %s skin' => '%s پوست',

        # Template: AdminPGP
        'PGP Management' => 'مدیریت رمزگذاری PGP',
        'PGP support is disabled' => 'پشتیبانی PGP غیر فعال است',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'برای اینکه قادر به استفاده از PGP در OTRS باشید، شما باید برای اولین بار آن را فعال کنید .',
        'Enable PGP support' => 'فعال کردن پشتیبانی از PGP',
        'Faulty PGP configuration' => 'پیکربندی PGP معیوب',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'پشتیبانی PGP فعال است، اما پیکربندی های مربوطه دارای خطا است. لطفا پیکربندی با استفاده از دکمه زیر را بررسی کنید.',
        'Configure it here!' => 'پیکربندی آن را در اینجا!',
        'Check PGP configuration' => 'بررسی پیکربندی PGP',
        'Add PGP key' => 'افزودن کلید PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'از این طریق شما می‌توانید مستقیما کلید‌های خود را درسیستم تنظیم نمائید',
        'Introduction to PGP' => 'معرفی به PGP',
        'Result' => 'نتیجه',
        'Identifier' => 'شناسه',
        'Bit' => 'Bit',
        'Fingerprint' => 'اثر انگشت',
        'Expires' => 'ابطال',
        'Delete this key' => 'حذف این کلید',
        'Add PGP Key' => 'افزودن کلید PGP',
        'PGP key' => 'کلید PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'مدیریت بسته‌ها',
        'Uninstall package' => 'حذف بسته',
        'Do you really want to uninstall this package?' => 'از حذف این بسته اطمینان دارید؟',
        'Reinstall package' => 'نصب مجدد بسته',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'آیا واقعا می‌خواهید این بسته را مجددا نصب نمایید؟ تمام تغییرات دستی از بین خواهد رفت.',
        'Go to upgrading instructions' => '',
        'Go to the OTRS customer portal' => '',
        'package information' => '',
        'Package installation requires patch level update of OTRS' => '',
        'Package upgrade requires patch level update of OTRS' => '',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '',
        'Everything else will be done as part of your contract.' => '',
        'Please note that your installed OTRS version is %s.' => '',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within' => '',
        'the upgrading instructions' => '',
        'In case you would have further questions we would be glad to answer them.' =>
            'در مورد شما می سوال بیشتر دارند ما خوشحال خواهد بود به آنها پاسخ دهد.',
        'Please visit our customer' => '',
        'portal' => 'پورتال',
        'and file a request.' => 'و فایل درخواست.',
        'Continue' => 'ادامه',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'لطفا مطمئن شوید که پایگاه داده خود را بسته بر می پذیرد %s MB در اندازه (در حال حاضر تنها بسته می پذیرد تا %s MB). لطفا تنظیمات max_allowed_packet از پایگاه داده خود را به منظور جلوگیری از اشتباهات وفق دهند.',
        'Install' => 'نصب',
        'Install Package' => 'نصب بسته',
        'Update repository information' => 'به‌روز رسانی اطلاعات مخزن',
        'Cloud services are currently disabled.' => 'خدمات ابر در حال حاضر غیر فعال است.',
        'OTRS Verify™ can not continue!' => 'OTRS تایید ™ نمی تواند ادامه دهد.',
        'Enable cloud services' => 'فعال کردن سرویس های ابری',
        'Online Repository' => 'مخزن آنلاین بسته‌ها',
        'Module documentation' => 'مستندات ماژول',
        'Upgrade' => 'ارتقاء',
        'Local Repository' => 'مخزن محلی بسته‌ها',
        'This package is verified by OTRSverify (tm)' => 'این بسته توسط OTRSverify تایید (TM)',
        'Uninstall' => 'حذف بسته',
        'Reinstall' => 'نصب مجدد',
        'Features for %s customers only' => 'ویژگی ها برای %s تنها مشتریان',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'با %s ، شما می توانید از ویژگی های اختیاری زیر بهره مند شوند. لطفا تماس با %s اگر شما نیاز به اطلاعات بیشتر.',
        'Download package' => 'دریافت بسته',
        'Rebuild package' => 'ساخت مجدد بسته',
        'Metadata' => 'ابرداده',
        'Change Log' => 'وقایع ثبت شده تغییرات',
        'Date' => 'تاریخ',
        'List of Files' => 'فهرست فایل‌ها',
        'Permission' => 'حقوق دسترسی',
        'Download' => 'دریافت',
        'Download file from package!' => 'دریافت فایل از بسته!',
        'Required' => 'الزامی',
        'Primary Key' => 'کلید اولیه',
        'Auto Increment' => 'افزایش خودکار',
        'SQL' => 'SQL',
        'File differences for file %s' => 'تفاوت‌های فایل برای فایل %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'گزارش عملکرد',
        'This feature is enabled!' => 'این ویژگی فعال است.',
        'Just use this feature if you want to log each request.' => 'این ویژگی امکان ثبت همه درخواست‌ها را می‌دهد',
        'Activating this feature might affect your system performance!' =>
            'فعال کردن این خاصیت ممکن است سیستم شما را کند سازد!',
        'Disable it here!' => 'اینجا غیر فعال نمائید',
        'Logfile too large!' => 'فایل ثبت وقایع بیش از حد بزرگ است',
        'The logfile is too large, you need to reset it' => 'فایل ثبت وقایع بیش از حد بزرگ است، نیاز دارید که مجدد آن را بسازید',
        'Overview' => 'پیش نمایش',
        'Range' => 'حدود',
        'last' => 'آخرین',
        'Interface' => 'واسط',
        'Requests' => 'درخواست‌ها',
        'Min Response' => 'کمترین پاسخ',
        'Max Response' => 'بیشترین پاسخ',
        'Average Response' => 'میانگین پاسخ',
        'Period' => 'دوره',
        'Min' => 'کمترین',
        'Max' => 'بیشترین',
        'Average' => 'میانگین',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'مدیریت فیلتر پستی',
        'Add filter' => 'افزودن فیلتر',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'برای توزیع یا پالایش ایمیل‌ها وارده بر اساس هدرهای ایمیل. تطابق بر اساس عبارات منظم نیز مجاز است.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'برای انطباق اختصاصی Email از EMAILADDRESS:info@example.com در فرستنده،گیرنده و رونوشت استفاده نمائید.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'اگر از عبارات منظم استفاده می‌کنید، می‌توانید از مقدار تطابق یافته در () به عنوان [***] در عملیات Set استفاده نمایید.',
        'Delete this filter' => 'حذف این فیلتر',
        'Do you really want to delete this filter?' => 'آیا واقعا میخواهید این فیلتر را حذف کنید؟',
        'Add PostMaster Filter' => 'افزودن فیلتر پستی',
        'Edit PostMaster Filter' => 'ویرایش فیلتر پستی',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'شرط تطابق',
        'AND Condition' => 'و شرایط',
        'Check email header' => 'بررسی هدر ایمیل',
        'Negate' => 'خنثی کردن',
        'Look for value' => 'برای ارزش نگاه',
        'The field needs to be a valid regular expression or a literal word.' =>
            'زمینه نیاز به یک عبارت منظم معتبر و یا یک کلمه واقعی.',
        'Set Email Headers' => 'تنظیم هدرهای ایمیل',
        'Set email header' => ' تنظیم هدر ایمیل',
        'Set value' => 'تنظیم ارزش',
        'The field needs to be a literal word.' => 'زمینه نیاز به یک کلمه دارد .',

        # Template: AdminPriority
        'Priority Management' => 'مدیریت اولویت‌ها',
        'Add priority' => 'افزودن الویت',
        'Add Priority' => 'افزودن اولویت',
        'Edit Priority' => 'ویرایش الویت',

        # Template: AdminProcessManagement
        'Process Management' => 'مدیریت فرآیند',
        'Filter for Processes' => 'فیلتر برای پردازش',
        'Create New Process' => 'خلق فرآیند جدید',
        'Deploy All Processes' => 'استقرار تمام فرآیندها',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'در اینجا شما می توانید یک فایل پیکربندی برای وارد یک فرایند را به سیستم خود را بارگذاری کنید. فایل نیاز به در فرمت .yml باشد که توسط ماژول مدیریت فرایند صادر می شود.',
        'Overwrite existing entities' => 'بازنویسی نهادهای موجود',
        'Upload process configuration' => ' روند  بارگذاری پیکربندی',
        'Import process configuration' => ' روند دریافت پیکربندی',
        'Ready-to-run Processes' => 'آماده به اجرای فرایندهای',
        'Here you can activate ready-to-run processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'در اینجا شما می توانید فرآیندهای آماده به اجرا نمایش بهترین شیوه های ما را فعال کنید. لطفا توجه داشته باشید که برخی از تنظیمات اضافی ممکن است مورد نیاز باشد.',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated ready-to-run processes.' =>
            'دوست دارید از فرآیندهای ایجاد شده توسط کارشناسان بهره مند شوند؟ ارتقا به %s به واردات برخی از فرآیندهای پیچیده آماده به اجرا.',
        'Import ready-to-run process' => 'واردات آماده به اجرای فرایند',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'برای ایجاد یک فرایند جدید شما هم می توانید یک فرایند است که از یک سیستم دیگر صادر شد وارد و یا ایجاد یک جدید کامل.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'تغییرات در فرایندهای اینجا تنها رفتار سیستم را تحت تاثیر قرار، اگر شما داده های فرایند همگام سازی. با هماهنگ سازی فرآیندها، تغییرات تازه ساخته شده را به پیکربندی نوشته شده است.',
        'Processes' => 'فرایند ها',
        'Process name' => 'نام فرایند',
        'Print' => 'چاپ',
        'Export Process Configuration' => 'استخراج پیکربندی فرایند',
        'Copy Process' => 'فرایند کپی',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'لغو کنید و ببندید',
        'Go Back' => 'بازگشت',
        'Please note, that changing this activity will affect the following processes' =>
            'لطفا توجه داشته باشید، که در حال تغییر این فعالیت مراحل زیر را تحت تاثیر قرار',
        'Activity' => 'فعالیت',
        'Activity Name' => 'نام فعالیت',
        'Activity Dialogs' => 'تبادل فعالیت',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'شما می توانید فعالیت تبادل به این فعالیت با کشیدن عناصر با ماوس از لیست سمت چپ به لیست راست اختصاص دهید.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'مرتب سازی عناصر در لیست با کشیدن و رها کردن نیز ممکن است.',
        'Filter available Activity Dialogs' => 'فیلتر در دسترس تبادل فعالیت',
        'Available Activity Dialogs' => 'در دسترس تبادل فعالیت',
        'Name: %s, EntityID: %s' => 'نام: %s ، EntityID: %s',
        'Create New Activity Dialog' => 'ساختن فعالیت جدید گفت و گو',
        'Assigned Activity Dialogs' => 'فعالیتهای واگذارشده به گفتگو',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'به محض این که شما با استفاده از این دکمه و یا لینک، شما این صفحه نمایش را ترک و وضعیت فعلی خود را به طور خودکار ذخیره شده است. می خواهید ادامه دهید؟',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'لطفا توجه داشته باشید که در حال تغییر فعالیت این گفت و گو  فعالیت های زیر را تحت تاثیر قرارخواهد داد',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'لطفا توجه داشته باشید که کاربران مشتری قادر به دیدن و یااستفاده از زمینه های زیر نخواهند بود: مالک، مسئول، قفل، PendingTime و CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'زمینه صف تنها می تواند توسط مشتریان زمانی که یک بلیط جدید ایجاد استفاده می شود.',
        'Activity Dialog' => 'فعالیت های گفت و گو',
        'Activity dialog Name' => 'فعالیت نام گفت و گو',
        'Available in' => 'قابل دسترسی در',
        'Description (short)' => 'توضیحات (کوتاه)',
        'Description (long)' => 'توضیحات (طولانی)',
        'The selected permission does not exist.' => 'اجازه انتخاب وجود ندارد.',
        'Required Lock' => 'قفل مورد نیاز',
        'The selected required lock does not exist.' => 'انتخاب قفل مورد نیاز وجود ندارد.',
        'Submit Advice Text' => 'ارسال مشاوره متن',
        'Submit Button Text' => 'ارایه دادن دکمه متن',
        'Fields' => 'زمینه های',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'شما می توانید زمینه این فعالیت گفت و گو با کشیدن عناصر با ماوس از لیست سمت چپ به لیست راست اختصاص دهید.',
        'Filter available fields' => 'فیلتر زمینه های موجود',
        'Available Fields' => 'زمینه های موجود',
        'Name: %s' => 'نام: %s',
        'Assigned Fields' => 'زمینه اختصاص داده',
        'ArticleType' => 'ArticleType',
        'Display' => 'نمایش',
        'Edit Field Details' => 'ویرایش اطلاعات درست',
        'Customer interface does not support internal article types.' => 'رابط مشتری انواع مقاله داخلی پشتیبانی نمی کند.',

        # Template: AdminProcessManagementPath
        'Path' => 'PATH, 1998',
        'Edit this transition' => 'ویرایش این انتقال',
        'Transition Actions' => 'عملیات انتقال',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'شما می توانید عملیات انتقال به این انتقال با کشیدن عناصر با ماوس از لیست سمت چپ به لیست راست اختصاص دهید.',
        'Filter available Transition Actions' => 'فیلتر عملیات انتقال در دسترس',
        'Available Transition Actions' => 'عملیات انتقال در دسترس',
        'Create New Transition Action' => 'ایجاد جدید انتقال اقدام',
        'Assigned Transition Actions' => 'عملیات انتقال اختصاص داده',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'فعالیت',
        'Filter Activities...' => 'فیلتر فعالیت ...',
        'Create New Activity' => 'ساختن فعالیت جدید',
        'Filter Activity Dialogs...' => 'فیلتر فعالیت تبادل ...',
        'Transitions' => 'انتقال ها',
        'Filter Transitions...' => 'فیلتر انتقال، ...',
        'Create New Transition' => 'ساختن انتقال جدید',
        'Filter Transition Actions...' => 'عملیات فیلتر گذار ...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'ویرایش فرآیند',
        'Print process information' => 'اطلاعات فرآیند چاپ',
        'Delete Process' => 'حذف فرآیند',
        'Delete Inactive Process' => 'حذف فرآیند های غیر فعال',
        'Available Process Elements' => 'عناصر فرآیند در دسترس',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'عناصر ذکر شده در بالا در این نوار کناری را می توان به منطقه بوم در سمت راست با استفاده از کشیدن و رها نقل مکان کرد.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'شما می توانید فعالیت در منطقه بوم جایی برای اختصاص دادن این فعالیت به این فرآیند است.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'برای تعیین فعالیت گفت و گو به یک فعالیت رها کردن عنصر فعالیت محاوره ای از این نوار کناری بر فعالیت قرار داده شده در منطقه بوم.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'شما می توانید یک ارتباط بین دو فعالیت با حذف عنصر انتقال بیش از فعالیت شروع اتصال شروع می شود. پس از آن شما می توانید به پایان شل از فلش به پایان فعالیت درسایت حرکت می کند.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'اقدامات را می توان به انتقال با حذف اقدام عنصر بر روی برچسب از یک انتقال داده می شود.',
        'Edit Process Information' => 'ویرایش اطلاعات فرآیند',
        'Process Name' => 'نام پردازش',
        'The selected state does not exist.' => 'وضعیت انتخاب شده وجود ندارد.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'اضافه کردن و ویرایش فعالیت، تبادل و انتقال فعالیت',
        'Show EntityIDs' => 'نمایش EntityIDs',
        'Extend the width of the Canvas' => 'گسترش عرض بوم',
        'Extend the height of the Canvas' => 'گسترش ارتفاع بوم',
        'Remove the Activity from this Process' => 'حذف فعالیت از این روند',
        'Edit this Activity' => 'ویرایش این فعالیت',
        'Save Activities, Activity Dialogs and Transitions' => 'ذخیره فعالیت ها، فعالیت تبادل و انتقال',
        'Do you really want to delete this Process?' => 'آیا واقعا میخواهید این روند را حذف کنید؟',
        'Do you really want to delete this Activity?' => 'آیا شما واقعا می خواهید  این فعالیت را حذف کنید ؟',
        'Do you really want to delete this Activity Dialog?' => 'آیا شما واقعا می خواهید  این فعالیت گفت و گو را حذف کنید؟',
        'Do you really want to delete this Transition?' => 'آیا واقعا میخواهید این انتقال را حذف کنید؟',
        'Do you really want to delete this Transition Action?' => 'آیا شما واقعا می خواهید  این حرکت انتقال را حذف کنید؟',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'آیا شما واقعا می خواهید به حذف این فعالیت را از بوم؟ این فقط می تواند با ترک این صفحه نمایش بدون ذخیره خنثی کرد.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'آیا شما واقعا می خواهید به حذف این گذار از بوم؟ این فقط می تواند با ترک این صفحه نمایش بدون ذخیره خنثی کرد.',
        'Hide EntityIDs' => 'مخفی کردن EntityIDs',
        'Delete Entity' => 'حذف نهاد',
        'Remove Entity from canvas' => 'حذف نهاد از بوم',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'این فعالیت در حال حاضر در فرایند استفاده می شود. شما می توانید آن را دو باره اضافه کنید!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'این فعالیت را نمی توان حذف کرد چرا که آن شروع فعالیت است . ',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'این انتقال در حال حاضر برای این فعالیت استفاده می شود. شما می توانید از آن دو بار استفاده کنید !',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'این TransitionAction قبلا در این مسیر استفاده می شود. شما می توانید از آن استفاده کنید دو بار!',
        'Remove the Transition from this Process' => 'حذف انتقال از این فرایند',
        'No TransitionActions assigned.' => 'بدون TransitionActions اختصاص داده است.',
        'The Start Event cannot loose the Start Transition!' => 'این رویداد شروع می توانید شروع انتقال دست نیست!',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'هیچ تبادل اختصاص داده است. فقط یک گفت و گو فعالیت از لیست در سمت چپ انتخاب کنید و آن را در اینجا بکشید.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'انتقال بیارتباط است در حال حاضر بر روی بوم قرار داده است. لطفا این انتقال برای اولین بار قبل از قرار دادن انتقال دیگر متصل شوید.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'در این صفحه، شما می توانید یک فرآیند جدید ایجاد کنید. به منظور ایجاد فرآیند جدید در دسترس کاربران، لطفا مطمئن شوید که به مجموعه دولت خود را به «فعال» و همگام سازی پس از اتمام کار خود را.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'لغو و نزدیک',
        'Start Activity' => ' شروع فعالیت',
        'Contains %s dialog(s)' => 'شامل %s گفتگوی (بازدید کنندگان)',
        'Assigned dialogs' => 'گفتگوی معین',
        'Activities are not being used in this process.' => 'درفعالیت های دیگر هم این فرایند استفاده نمی شود.',
        'Assigned fields' => 'زمینه معین',
        'Activity dialogs are not being used in this process.' => 'تبادل فعالیت هستند که در این فرایند استفاده نمی شود.',
        'Condition linking' => ' شرط ارتباط',
        'Conditions' => 'شرایط',
        'Condition' => 'وضعیت',
        'Transitions are not being used in this process.' => 'انتقال هستند که در این فرایند استفاده نمی شود.',
        'Module name' => 'نام ماژول',
        'Transition actions are not being used in this process.' => 'اقدامات انتقال هستند که در این فرایند استفاده نمی شود.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'لطفا توجه داشته باشید که در حال تغییر این انتقال را به مراحل زیر را تحت تاثیر قرار',
        'Transition' => 'انتقال',
        'Transition Name' => 'نام انتقال',
        'Conditions can only operate on non-empty fields.' => 'شرایط فقط می توانید در زمینه های غیر خالی به کار گیرند.',
        'Type of Linking between Conditions' => 'نوع پیوند بین شرایط',
        'Remove this Condition' => 'حذف این شرط',
        'Type of Linking' => 'نوع لینک کردن',
        'Add a new Field' => 'اضافه کردن فیلد جدید',
        'Remove this Field' => 'حذف این فیلد',
        'And can\'t be repeated on the same condition.' => 'و نمی تواند در شرایط یکسان  تکرار شود.',
        'Add New Condition' => 'اضافه کردن شرط  جدید',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'لطفا توجه داشته باشید که در حال تغییر این عمل انتقال فرآیندهای زیر را تحت تاثیر قرار',
        'Transition Action' => 'انتقال عمل',
        'Transition Action Name' => 'نام انتقال فعالیت',
        'Transition Action Module' => 'انتقال واحد فعالیت',
        'Config Parameters' => 'پارامترهای پیکربندی',
        'Add a new Parameter' => 'اضافه کردن یک پارامتر جدید',
        'Remove this Parameter' => 'حذف این پارامتر',

        # Template: AdminQueue
        'Manage Queues' => 'مدیریت صف‌های درخواست',
        'Add queue' => 'افزودن صف درخواست',
        'Add Queue' => 'افزودن صف درخواست',
        'Edit Queue' => 'ویرایش صف درخواست',
        'A queue with this name already exists!' => 'یک صف با این نام وجود دارد.',
        'Sub-queue of' => 'زیر صف مربوط به',
        'Unlock timeout' => 'مهلت تحویل دادن درخواست',
        '0 = no unlock' => '0 = تحویل داده نشود',
        'Only business hours are counted.' => ' فقط ساعات اداری محاسبه شده است ',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'اگر یک کارشناس درخواستی را تحویل بگیرد و آن را قبل از زمان خاتمه تحویل بگذرد، نبندد، درخواست از دست کارشناس خارج شده و برای کارشناسان دیگر در دسترس خواهند شد.',
        'Notify by' => 'اعلان توسط',
        '0 = no escalation' => '0 = بدون زمان پاسخگویی نهایی',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'اگر مشخصات تماس مشترک، ایمیل خارجی و یا تلفن، قبل از اینکه زمان تعریف شده در اینجا به پایان برسد، اضافه نشده باشد، درخواست به زمان نهایی پاسخ خود رسیده است.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'اگر یک مطلب افزوده شده موجود باشد، مانند یک پیگیری از طریق ایمیل یا پرتال مشتری، زمان به‌روز رسانی برای زمان نهایی پاسخگویی تنظیم مجدد می‌شود. اگر مشخصات تماس مشترک، ایمیل خارجی و یا تلفن، قبل از اینکه زمان تعریف شده در اینجا به پایان برسد، اضافه نشده باشد، درخواست به زمان نهایی پاسخ خود رسیده است.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'اگر درخواستی تنظیم نشده که قبل از زمان تعریف شده در اینجا بسته شده، زمان پاسخگویی نهایی می‌رسد.',
        'Follow up Option' => 'گزینه پیگیری',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'مشخص می‌کند که اگر پیگیری درخواست‌های بسته شده باعث باز شدن مجدد آن شود، رد شده یا به یک درخواست جدید منتهی گردد.',
        'Ticket lock after a follow up' => 'درخواست بعد از پیگیری تحویل گرفته شود',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'اگر یک درخواست بسته شده و مشترک یک پیگیری ارسال کند، درخواست تحویل صاحب قدیمی خواهد شد.',
        'System address' => 'آدرس سیستم',
        'Will be the sender address of this queue for email answers.' => 'آدرس ارسال کننده این لیست برای پاسخ به ایمیل استفاده خواهد شد.',
        'Default sign key' => 'کلید امضای پیش‌فرض',
        'The salutation for email answers.' => 'عنوان برای پاسخ‌های ایمیلی',
        'The signature for email answers.' => 'یامضاء برای پاسخ‌های ایمیل ',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'مدیریت روابط صف درخواست-پاسخ خودکار',
        'This filter allow you to show queues without auto responses' => 'این فیلتر به شما اجازه نشان صف بدون پاسخ خودکار',
        'Queues without auto responses' => 'صف بدون پاسخ خودکار',
        'This filter allow you to show all queues' => 'این فیلتر به شما اجازه نشان دادن تمام صفها را میدهد',
        'Show all queues' => 'نمایش همه صف',
        'Filter for Queues' => 'فیلتر برای صف‌های درخواست',
        'Filter for Auto Responses' => 'فیلتر برای پاسخ‌های خودکار',
        'Auto Responses' => 'پاسخ خودکار',
        'Change Auto Response Relations for Queue' => 'تغییر روابط پاسخ خودکار برای صف درخواست',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'مدیریت روابط الگو صف',
        'Filter for Templates' => 'فیلتر برای قالب',
        'Templates' => 'قالب ها',
        'Change Queue Relations for Template' => 'تغییر روابط صف برای الگو',
        'Change Template Relations for Queue' => 'تغییر روابط الگو برای صف',

        # Template: AdminRegistration
        'System Registration Management' => 'سیستم مدیریت ثبت نام',
        'Edit details' => 'جزئیات ویرایش',
        'Show transmitted data' => 'نمایش انتقال داده ها',
        'Deregister system' => 'سیستم لغو ثبت',
        'Overview of registered systems' => 'بررسی اجمالی از سیستم ثبت نام',
        'This system is registered with OTRS Group.' => 'این سیستم با OTRS گروه ثبت شده است.',
        'System type' => 'نوع سیستم',
        'Unique ID' => 'شناسه منحصر به فرد',
        'Last communication with registration server' => 'ارتباط با سرور و زمان آخرین ثبت نام',
        'System registration not possible' => 'ثبت نام سیستم ممکن نیست',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'لطفا توجه داشته باشید که شما می توانید از سیستم خود را برای ثبت نام اینجا اگر OTRS دیمون را به درستی اجرا نیست!',
        'Instructions' => 'دستورعمل',
        'System deregistration not possible' => 'deregistration سیستم ممکن نیست',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'لطفا توجه داشته باشید که شما می توانید از سیستم خود را لغو ثبت می کنید اگر شما در حال استفاده از %s و یا داشتن یک قرارداد خدمات معتبر است.',
        'OTRS-ID Login' => 'OTRS-ID ورود',
        'Read more' => 'ادامه مطلب',
        'You need to log in with your OTRS-ID to register your system.' =>
            'شما نیاز به ورود خود را با OTRS-ID برای ثبت نام سیستم شما.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'شما OTRS-ID آدرس ایمیل شما استفاده می شود به ثبت نام در صفحه وب OTRS.com است.',
        'Data Protection' => 'حفاظت از داده ها',
        'What are the advantages of system registration?' => 'مزایای استفاده از ثبت نام سیستم چیست؟',
        'You will receive updates about relevant security releases.' => 'شما به روز رسانی در مورد نسخه های امنیتی مربوطه را دریافت خواهید کرد.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'با ثبت نام در سیستم شما ما می توانیم خدمات ما برای شما را بهبود بخشد، چرا که ما این اطلاعات را از همه مربوط به در دسترس.',
        'This is only the beginning!' => 'این تنها آغاز است!',
        'We will inform you about our new services and offerings soon.' =>
            'ما شما را در مورد خدمات و ارائه جدید ما به زودی اطلاع رسانی خواهد شد.',
        'Can I use OTRS without being registered?' => 'آیا می توانم از OTRS  استفاده کنم بدون اینکه ثبت نام کنم؟',
        'System registration is optional.' => 'ثبت نام سیستم اختیاری است.',
        'You can download and use OTRS without being registered.' => 'شما می توانید دانلود کنید و استفاده کنید از  OTRS بدون اینکه ثبت نام کنید .',
        'Is it possible to deregister?' => 'آیا لغو ثبت ممکن است؟',
        'You can deregister at any time.' => 'شما می توانید در هر زمان لغو ثبت کنید .',
        'Which data is transfered when registering?' => 'که داده منتقل هنگام ثبت نام؟',
        'A registered system sends the following data to OTRS Group:' => 'سیستم ثبت نام اطلاعات زیر به OTRS گروه می فرستد:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'نام کامل دامنه (FQDN)، مدل OTRS، پایگاه داده، سیستم عامل و نسخه پرل.',
        'Why do I have to provide a description for my system?' => 'چرا باید برای ارائه یک توصیف برای سیستم من؟',
        'The description of the system is optional.' => 'شرح سیستم اختیاری است.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'توضیحات و سیستم نوع را مشخص می کنید به شما کمک کند برای شناسایی و مدیریت جزئیات سیستم ثبت نام خود را.',
        'How often does my OTRS system send updates?' => 'هر چند وقت یکبار سیستم OTRS من ارسال به روز رسانی؟',
        'Your system will send updates to the registration server at regular intervals.' =>
            'سیستم خود را به روز رسانی به سرور ثبت نام در فواصل منظم ارسال می کند.',
        'Typically this would be around once every three days.' => 'به طور معمول این امر می تواند حدودا هر سه روز یکبار رخ دهد .',
        'Please visit our' => 'لطفا به ما مراجعه کنید',
        'If you deregister your system, you will lose these benefits:' =>
            'اگر شما سیستم خود را لغو ثبت کنید، شما این منافع را ازدست خواهید داد',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'شما نیاز به ورود خود را با OTRS-ID به لغو ثبت سیستم شما.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'شما هنوز یک OTRS-ID ندارید؟',
        'Sign up now' => 'اکنون عضو شوید',
        'Forgot your password?' => 'رمز عبور خود را فراموش کرده اید',
        'Retrieve a new one' => ' یک رمز جدید بازیابی کنید',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'این داده خواهد شد اغلب به OTRS گروه منتقل هنگامی که شما این سیستم ثبت نام کنید.',
        'Attribute' => 'صفت',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'OTRS نسخه',
        'Operating System' => 'سیستم عامل',
        'Perl Version' => 'پرل نسخه',
        'Optional description of this system.' => 'توضیحات اختیاری این سیستم.',
        'Register' => 'ثبت نام',
        'Deregister System' => 'لغو ثبت سیستم',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'در ادامه با این مرحله خواهد شد سیستم را از OTRS گروه لغو ثبت.',
        'Deregister' => 'لغو ثبت',
        'You can modify registration settings here.' => 'شما می توانید تنظیمات ثبت نام را اینجا تنظیم کنید.',
        'Overview of transmitted data' => 'بررسی اجمالی از داده های منتقل شده',
        'There is no data regularly sent from your system to %s.' => 'هیچ داده به طور منظم از سیستم خود را به ارسال وجود دارد %s .',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'داده های زیر است که در حداقل هر 3 روز از سیستم خود را به ارسال %s .',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'داده خواهد شد در قالب JSON از طریق یک اتصال امن HTTPS منتقل شده است.',
        'System Registration Data' => 'اطلاعات سیستم ثبت نام',
        'Support Data' => 'پشتیبانی از داده ها',

        # Template: AdminRole
        'Role Management' => 'مدیریت نقش',
        'Add role' => 'افزودن نقش',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'یک نقش بسازید و گروه را در آن قرار دهید سپس نقش را به کاربرها اضافه کنید',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'هیچ نقشی ساخته نشده است. لطفا از کلید «افزودن» برای ساخت نقش جدید استفاده نمایید.',
        'Add Role' => 'افزودن نقش',
        'Edit Role' => 'ویرایش نقش',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'مدیریت روابط نقش-گروه',
        'Filter for Roles' => 'فیلتر برای نقش‌ها',
        'Roles' => 'نقش‌ها',
        'Select the role:group permissions.' => 'نقش را انتخاب کنید: دسترسی‌های گروه.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'اگر چیزی انتخاب نشود، هیچ دسترسی در این گروه وجود نخواهد داشت (درخواست‌ها برای نقش در دسترس نخواهند بود)',
        'Change Role Relations for Group' => 'تغییر روابط نقش برای گروه',
        'Change Group Relations for Role' => 'تغییر روابط گروه برای نقش',
        'Toggle %s permission for all' => 'اعمال دسترسی %s برای همه',
        'move_into' => 'انتقال به',
        'Permissions to move tickets into this group/queue.' => 'مجوز انتقال درخواست به این گروه/لیست.',
        'create' => 'ساختن',
        'Permissions to create tickets in this group/queue.' => 'مجوز ایجاد درخواست در این گروه/لیست.',
        'note' => 'یادداشت',
        'Permissions to add notes to tickets in this group/queue.' => 'دسترسی‌ها برای افزودن یادداشت به درخواست‌ها در این گروه/صف درخواست',
        'owner' => 'صاحب',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'دسترسی‌ها برای تغییر صاحب درخواست‌ها در این گروه/صف درخواست',
        'priority' => 'الویت',
        'Permissions to change the ticket priority in this group/queue.' =>
            'مجوز تغییر اولویت درخواست در این گروه/لیست.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'مدیریت روابط کارشناس-نقش',
        'Add agent' => 'افزودن کارشناس',
        'Filter for Agents' => 'فیلتر برای کارشناسان',
        'Agents' => 'کارشناسان',
        'Manage Role-Agent Relations' => 'مدیریت روابط نقش-کارشناس',
        'Change Role Relations for Agent' => 'تغییر روابط نقش برای کارشناس',
        'Change Agent Relations for Role' => 'تغییر روابط کارشناس برای نقش',

        # Template: AdminSLA
        'SLA Management' => 'مدیریت SLA',
        'Add SLA' => 'افزودن توافقنامه SLA',
        'Edit SLA' => 'ویرایش SLA',
        'Please write only numbers!' => 'لطفا فقط ارقام را بنویسید!',

        # Template: AdminSMIME
        'S/MIME Management' => 'مدیریت S/MIME',
        'SMIME support is disabled' => 'پشتیبانی SMIME غیر فعال است',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'برای اینکه قادر به استفاده از SMIME در OTRS، شما باید آن را فعال کنید برای اولین بار.',
        'Enable SMIME support' => 'فعال کردن پشتیبانی SMIME',
        'Faulty SMIME configuration' => 'پیکربندی SMIME معیوب',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'پشتیبانی SMIME فعال است، اما پیکربندی های مربوطه دارای خطا است. لطفا پیکربندی با استفاده از دکمه زیر را بررسی کنید.',
        'Check SMIME configuration' => 'بررسی پیکربندی SMIME',
        'Add certificate' => 'افزودن گواهینامه',
        'Add private key' => 'افزودن کلید خصوصی',
        'Filter for certificates' => 'فیلتر برای گواهی',
        'Filter for S/MIME certs' => 'فیلتر برای S / MIME گواهیهای',
        'To show certificate details click on a certificate icon.' => 'برای نشان دادن جزئیات گواهی  بر روی آیکون گواهی کلیک کنید .',
        'To manage private certificate relations click on a private key icon.' =>
            'برای مدیریت روابط گواهی خصوصی بر روی آیکون کلید خصوصی را کلیک کنید.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'در اینجا شما می توانید روابط به گواهی خصوصی خود را اضافه کنید، این خواهد بود به امضای S / MIME تعبیه شده هر زمانی که شما با استفاده از این گواهی یک ایمیل به ثبت نام.',
        'See also' => 'همچنین ببنید',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'از این طریق شما میتوانید کلید‌های رمز خود را برای رمز گذاری نامه‌ها و پیامها به سیستم وارد نمائید',
        'Hash' => 'Hash',
        'Handle related certificates' => 'رسیدگی به مدارک معتبر',
        'Read certificate' => 'گواهی خوانده شده',
        'Delete this certificate' => 'حذف این گواهینامه',
        'Add Certificate' => 'افزودن گواهینامه',
        'Add Private Key' => 'افزودن کلید خصوصی',
        'Secret' => 'مخفی',
        'Related Certificates for' => 'گواهینامه های مرتبط برای',
        'Delete this relation' => 'حذف این رابطه',
        'Available Certificates' => 'گواهینامه ها موجود',
        'Relate this certificate' => 'مربوط به این مجوز',

        # Template: AdminSMIMECertRead
        'Close dialog' => 'بستن گفتگوی',
        'Certificate details' => 'جزئیات گواهی',

        # Template: AdminSalutation
        'Salutation Management' => 'مدیریت عنوان‌ها',
        'Add salutation' => 'افزودن عنوان',
        'Add Salutation' => 'افزودن عنوان',
        'Edit Salutation' => 'ویرایش عنوان',
        'e. g.' => 'به عنوان مثال',
        'Example salutation' => 'نمونه عنوان',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'نیاز است که حالت امن فعال شده باشد!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'حالت امن (به طور معمول) بعد از تکمیل نصب قابل تنظیم خواهد بود.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'اگر حالت امن فعال نشده است، آن را از طریق تنظیم سیستم فعال نمایید زیرا نرم‌افزار شما در حال اجرا می‌باشد.',

        # Template: AdminSelectBox
        'SQL Box' => 'جعبه SQL',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'در اینجا شما می توانید SQL وارد به ارسال آن به طور مستقیم به پایگاه داده نرم افزار. این ممکن است به تغییر محتوای جداول، تنها انتخاب نمایش داده شد مجاز است.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'در اینجا می‌توانید کوئری SQL وارد نمایید تا آن را به صورت مستقیم به پایگاه داده برنامه بفرستید.',
        'Only select queries are allowed.' => 'فقط مجاز هستید نمایش داده شد را انتخاب کنید ',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'گرامر نوشتاری کوئری SQL شما دارای اشتباه می‌باشد. لطفا آن را کنترل نمایید.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'حداقل یک پارامتر برای اجرا وجود ندارد. لطفا آن را کنترل نمایید.',
        'Result format' => 'قالب نتیجه',
        'Run Query' => 'اجرای کوئری',
        'Query is executed.' => 'پرس و جو اجرا است.',

        # Template: AdminService
        'Service Management' => 'مدیریت خدمات',
        'Add service' => 'افزودن خدمت',
        'Add Service' => 'افزودن خدمت',
        'Edit Service' => 'ویرایش خدمت',
        'Sub-service of' => 'زیرمجموعه‌ای از خدمت',

        # Template: AdminSession
        'Session Management' => 'مدیریت Session‌ها',
        'All sessions' => 'تمام sessionها',
        'Agent sessions' => 'session کارشناسان',
        'Customer sessions' => 'session مشترکین',
        'Unique agents' => 'کارشناسان یکه',
        'Unique customers' => 'مشترکین یکه',
        'Kill all sessions' => 'همه Session‌ها را از بین ببر',
        'Kill this session' => 'از بین بردن session',
        'Session' => 'Session',
        'Kill' => 'کشتن',
        'Detail View for SessionID' => 'نمای جزئیات برای SessionID',

        # Template: AdminSignature
        'Signature Management' => 'مدیریت امضاء',
        'Add signature' => 'افزودن امضاء',
        'Add Signature' => 'افزودن امضاء',
        'Edit Signature' => 'ویرایش امضاء',
        'Example signature' => 'امضای نمونه',

        # Template: AdminState
        'State Management' => 'مدیریت وضعیت',
        'Add state' => 'افزودن وضعیت',
        'Please also update the states in SysConfig where needed.' => 'لطفا کشورهای در SysConfig به روز رسانی که در آن مورد نیاز است.',
        'Add State' => 'افزودن وضعیت',
        'Edit State' => 'ویرایش وضعیت',
        'State type' => 'نوع وضعیت',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'ارسال اطلاعات پشتیبانی به OTRS گروه ممکن نیست!',
        'Enable Cloud Services' => 'فعال کردن خدمات ابر',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'این داده ها به OTRS گروه به طور منظم ارسال می شود. برای متوقف کردن ارسال این اطلاعات لطفا به روز رسانی ثبت نام سیستم شما.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'شما می توانید دستی ماشه داده پشتیبانی از ارسال با فشار دادن این دکمه:',
        'Send Update' => 'ارسال به روز رسانی',
        'Sending Update...' => 'ارسال به روز رسانی ...',
        'Support Data information was successfully sent.' => 'پشتیبانی از اطلاعات داده با موفقیت ارسال شد.',
        'Was not possible to send Support Data information.' => 'ممکن بود به ارسال اطلاعات پشتیبانی اطلاعات.',
        'Update Result' => 'نتیجه به روز رسانی ',
        'Currently this data is only shown in this system.' => 'در حال حاضر این داده ها فقط در این سیستم نشان داده میشوند.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'بسته نرم افزاری پشتیبانی (از جمله: اطلاعات ثبت نام سیستم، داده پشتیبانی، یک لیست از بسته های نصب شده و تمامی فایل های کد منبع به صورت محلی تغییر) را می توان با فشار دادن این دکمه تولید:',
        'Generate Support Bundle' => 'تولید پشتیبانی بسته نرم افزاری',
        'Generating...' => 'تولید ...',
        'It was not possible to generate the Support Bundle.' => 'ممکن بود برای تولید پشتیبانی بسته نرم افزاری.',
        'Generate Result' => ' نتیجه تولید',
        'Support Bundle' => 'پشتیبانی بسته نرم افزاری',
        'The mail could not be sent' => 'پست الکترونیکی ارسال نمی شود',
        'The support bundle has been generated.' => 'بسته نرم افزاری پشتیبانی تهیه شده است.',
        'Please choose one of the following options.' => 'لطفا یکی از گزینه های زیر را انتخاب نمایید.',
        'Send by Email' => 'ارسال از طریق ایمیل',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'بسته نرم افزاری پشتیبانی بیش از حد بزرگ به ارسال آن از طریق ایمیل است، این گزینه غیرفعال شده است.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'آدرس ایمیل برای این کاربر نامعتبر است، این گزینه غیرفعال شده است.',
        'Sending' => 'فرستنده',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'بسته نرم افزاری پشتیبانی به OTRS گروه از طریق ایمیل به طور خودکار ارسال خواهد شد .',
        'Download File' => 'دریافت فایل',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'فایل حاوی بسته نرم افزاری پشتیبانی خواهد شد به سیستم محلی دریافت کنید. لطفا فایل ذخیره و ارسال آن به گروه OTRS، با استفاده از یک روش جایگزین.',
        'Error: Support data could not be collected (%s).' => 'خطا: اطلاعات پشتیبانی نمی تواند جمع آوری  شود ( %s ).',
        'Details' => 'جزئیات',

        # Template: AdminSysConfig
        'SysConfig' => 'تنظیم سیستم',
        'Navigate by searching in %s settings' => 'حرکت توسط جستجو در تنظیمات %s',
        'Navigate by selecting config groups' => 'حرکت توسط انتخاب گروه‌های پیکربندی',
        'Download all system config changes' => 'دریافت تمام تغییرات پیکربندی سیستم',
        'Export settings' => 'ارسال تنظیمات',
        'Load SysConfig settings from file' => 'بارگذاری تنظیمات پیکربندی از فایل',
        'Import settings' => 'ورود تنظیمات',
        'Import Settings' => 'ورود تنظیمات',
        'Please enter a search term to look for settings.' => 'لطفا یک عبارت جستجو برای گشتن تنظیمات وارد نمایید.',
        'Subgroup' => 'زیرگروه',
        'Elements' => 'قسمت',

        # Template: AdminSysConfigEdit
        'Edit Config Settings in %s → %s' => 'ویرایش تنظیمات پیکربندی در %s → %s',
        'This setting is read only.' => 'این تنظیم فقط خواندنی است.',
        'This config item is only available in a higher config level!' =>
            'این آیتم پیکربندی فقط در سطح بالاتر پیکربندی در دسترس است!',
        'Reset this setting' => 'تنظیم مجدد تنظیمات',
        'Error: this file could not be found.' => 'خطا: این فایل یافت نمی‌شود.',
        'Error: this directory could not be found.' => 'خطا: این دایرکتوری یافت نمی‌شود.',
        'Error: an invalid value was entered.' => 'خطا: یک مقدار نامعتبر وارد شده است.',
        'Content' => 'محتوا',
        'Remove this entry' => 'پاک کردن این ورودی',
        'Add entry' => 'افزودن ورودی',
        'Remove entry' => 'پاک کردن ورودی',
        'Add new entry' => 'افزودن ورودی جدید',
        'Delete this entry' => 'حذف این ورودی',
        'Create new entry' => 'ساختن ورودی جدید',
        'New group' => 'گروه جدید',
        'Group ro' => 'گروه ro',
        'Readonly group' => 'گروه فقط خواندنی',
        'New group ro' => 'گروه ro جدید',
        'Loader' => 'بارکننده',
        'File to load for this frontend module' => 'فایل برای بارگذاری این ماژول پشتی',
        'New Loader File' => 'فایل بارکننده جدید',
        'NavBarName' => 'نام میله کنترل',
        'NavBar' => 'میله کنترل',
        'LinkOption' => 'گزینه رابطه',
        'Block' => 'بسته',
        'AccessKey' => 'کلید دسترسی',
        'Add NavBar entry' => 'افزودن ورودی میله کنترل',
        'NavBar module' => 'ماژول نوار پیمایش',
        'Year' => 'سال',
        'Month' => 'ماه',
        'Day' => 'روز',
        'Invalid year' => 'سال نامعتبر',
        'Invalid month' => 'ماه نامعتبر',
        'Invalid day' => 'روز نامعتبر',
        'Show more' => 'نمایش بیشتر',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'مدیریت آدرس‌های ایمیل سیستم',
        'Add system address' => 'افزودن آدرس سیستم',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'تمام ایمیل‌های وارده با این آدرس در To یا Cc به صف درخواست انتخاب شده توزیع خواهد شد.',
        'Email address' => 'آدرس ایمیل',
        'Display name' => 'نام نمایش داده شده',
        'Add System Email Address' => 'افزودن آدرس ایمیل سیستم',
        'Edit System Email Address' => 'ویرایش آدرس ایمیل سیستم',
        'The display name and email address will be shown on mail you send.' =>
            'نام نمایش داده شده و آدرس ایمیل در ایمیلی که شما می‌فرستید نمایش داده خواهد شد.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'سیستم مدیریت نگهداری و تعمیرات',
        'Schedule New System Maintenance' => 'برنامه تعمیر و نگهداری سیستم های جدید',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'برنامه ریزی یک دوره تعمیر و نگهداری سیستم برای اعلام عوامل و مشتریان سیستم پایین است برای یک دوره زمانی.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'چند وقت پیش از این تعمیر و نگهداری سیستم شروع می شود کاربران یک اطلاع رسانی در هر صفحه نمایش اعلام در مورد این واقعیت دریافت خواهید کرد.',
        'Start date' => 'تاریخ شروع',
        'Stop date' => 'تاریخ توقف',
        'Delete System Maintenance' => 'حذف تعمیر و نگهداری سیستم',
        'Do you really want to delete this scheduled system maintenance?' =>
            'آیا شما واقعا می خواهید  این تعمیر و نگهداری سیستم های برنامه ریزی شده را حذف کنید؟',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'ویرایش تعمیر و نگهداری سیستم %s',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'تاریخ نامعتبر!',
        'Login message' => 'پیام ورود',
        'Show login message' => 'پیام ورود نمایش',
        'Notify message' => 'اعلام کردن پیام',
        'Manage Sessions' => 'مدیریت جلسات',
        'All Sessions' => 'تمام جلسات',
        'Agent Sessions' => 'جلسات عامل',
        'Customer Sessions' => 'جلسات و ضوابط',
        'Kill all Sessions, except for your own' => 'کشتن تمام جلسات، به جز مال خود را',

        # Template: AdminTemplate
        'Manage Templates' => 'مدیریت قالب',
        'Add template' => 'اضافه کردن قالب',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'قالب یک متن پیش فرض است که کمک می کند تا عوامل خود را برای ارسال سریعتر بلیط، پاسخ و یا جلو است.',
        'Don\'t forget to add new templates to queues.' => 'فراموش نکنید که برای اضافه کردن قالب جدید به صف.',
        'Do you really want to delete this template?' => 'آیا واقعا مایل به حذف این قالب هستید؟',
        'Add Template' => 'افزودن قالب',
        'Edit Template' => 'ویرایش قالب',
        'A standard template with this name already exists!' => 'قالب استاندارد با این نام وجود دارد.',
        'Create type templates only supports this smart tags' => 'ایجاد قالب های نوع تنها پشتیبانی از این تگ های هوشمند',
        'Example template' => 'نمونه قالب',
        'The current ticket state is' => 'وضعیت فعلی درخواست',
        'Your email address is' => 'آدرس ایمیل شما:',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'مدیریت قالب <-> روابط فایل های پیوست',
        'Filter for Attachments' => 'فیلتر برای پیوست‌ها',
        'Change Template Relations for Attachment' => 'تغییر روابط الگو برای پیوست',
        'Change Attachment Relations for Template' => 'روابط تغییر فایل پیوست برای الگو',
        'Toggle active for all' => 'اعمال فعال برای همه',
        'Link %s to selected %s' => 'ارتباط %s به %s انتخاب شده',

        # Template: AdminType
        'Type Management' => 'مدیریت نوع‌ها',
        'Add ticket type' => 'افزودن نوع درخواست',
        'Add Type' => 'افزودن نوع',
        'Edit Type' => 'ویرایش درخواست',
        'A type with this name already exists!' => 'یک نوع با این نام وجود دارد.',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'کارشناسان نیاز دارند که به درخواست‌ها رسیدگی کنند.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'فراموش نکنید که یک کارشناس جدید را به گروه‌ها و/یا نقش‌ها بیفزایید!',
        'Please enter a search term to look for agents.' => 'لطفا یک عبارت جستجو برای گشتن کارشناسان وارد نمایید.',
        'Last login' => 'آخرین ورود',
        'Switch to agent' => 'سوئیچ به کارشناس',
        'Add Agent' => 'افزودن کارشناس',
        'Edit Agent' => 'ویرایش کارشناس',
        'Title or salutation' => 'عنوان یا سلام',
        'Firstname' => 'نام',
        'Lastname' => 'نام خانوادگی',
        'A user with this username already exists!' => 'کاربری با این نام کاربری وجو دارد!',
        'Will be auto-generated if left empty.' => ' اگر خالی بماند، به صورت خودکار تولید میشود.',
        'Start' => 'شروع',
        'End' => 'پایان',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'مدیریت روابط کارشناس-گروه',
        'Change Group Relations for Agent' => 'تغییر روابط گروه برای کارشناس',
        'Change Agent Relations for Group' => 'تغییر روابط کارشناس برای گروه',

        # Template: AgentBook
        'Address Book' => 'دفترچه  آدرس و تماس‌ها',
        'Search for a customer' => 'جستجو برای مشترک',
        'Add email address %s to the To field' => 'افزودن آدرس ایمیل %s به فیلد To',
        'Add email address %s to the Cc field' => 'افزودن آدرس ایمیل %s به فیلد Cc',
        'Add email address %s to the Bcc field' => 'افزودن آدرس ایمیل %s به فیلد Bcc',
        'Apply' => 'اعمال',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'مرکز اطلاعات مشترکین',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'مشترک',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'ورود تکراری',
        'This address already exists on the address list.' => 'این آدرس در لیست آدرس ها موجود است.',
        'It is going to be deleted from the field, please try again.' => 'آن است که رفتن به از میدان حذف شود، لطفا دوباره امتحان کنید.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'یادداشت: مشترک نامعتبر است!',
        'Start chat' => 'شروع گپ',
        'Video call' => 'تماس تصویری',
        'Audio call' => 'تماس صوتی',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTRS شبح یک فرایند شبح که انجام وظایف ناهمزمان، به عنوان مثال تشدید بلیط تحریک، ارسال ایمیل، و غیره است',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'یک شبح OTRS در حال اجرا برای عملیات سیستم درست الزامی است.',
        'Starting the OTRS Daemon' => 'شروع OTRS دیمون',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'مطمئن شوید که فایل \' %s \' وجود دارد (بدون .dist پسوند). این cron در هر 5 دقیقه اگر OTRS دیمون در حال اجرا است را بررسی کنید و شروع به آن در صورت نیاز.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'اعدام %s شروع به مطمئن شوید که به cron job از کاربر OTRS، فعال هستند.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'پس از 5 دقیقه، بررسی کنید که OTRS دیمون در حال اجرا در سیستم ( \'وضعیت بن / otrs.Daemon.pl\').',

        # Template: AgentDashboard
        'Dashboard' => 'داشبورد',

        # Template: AgentDashboardCalendarOverview
        'in' => 'در',

        # Template: AgentDashboardCommon
        'Close this widget' => 'بستن این ویجت',
        'Available Columns' => 'ستون در دسترس',
        'Visible Columns (order by drag & drop)' => 'ستون قابل مشاهده است (سفارش با کشیدن و رها کردن)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'تیکت های خیلی مهم',

        # Template: AgentDashboardCustomerUserList
        'Customer login' => 'ورود مشترک',
        'Customer information' => 'اطلاعات مشترک',
        'Phone ticket' => 'تیکت تلفنی',
        'Email ticket' => 'تیکت ایمیلی',
        '%s open ticket(s) of %s' => '%s بلیط باز (بازدید کنندگان) از %s',
        '%s closed ticket(s) of %s' => '%s بلیط بسته (بازدید کنندگان) از %s',
        'New phone ticket from %s' => 'درخواست گوشی جدید از %s',
        'New email ticket to %s' => 'درخواست ایمیل جدید به %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s موجود است.',
        'Please update now.' => 'لطفا بروزرسانی کنید.',
        'Release Note' => 'یادداشت انتشار',
        'Level' => 'سطح',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '%s وقت پیش ارسال شد',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'پیکربندی برای این ویجت آمار دارای خطامیباشد، لطفا تنظیمات خود را بررسی کند.',
        'Download as SVG file' => 'دانلود به صورت فایل SVG',
        'Download as PNG file' => 'دانلود به صورت فایل PNG',
        'Download as CSV file' => 'دانلود به عنوان فایل CSV',
        'Download as Excel file' => 'دانلود به صورت فایل اکسل',
        'Download as PDF file' => 'دانلود به عنوان فایل PDF',
        'Grouped' => 'گروه بندی شده',
        'Stacked' => 'انباشته',
        'Expanded' => 'Expanded',
        'Stream' => 'جریان',
        'No Data Available.' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'لطفا یک فرمت خروجی نمودار معتبر در پیکربندی این ویجت را انتخاب کنید.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'محتوای این آمار است که برای شما آماده میباشد، لطفا صبور باشید.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'این آمار در حال حاضر می توانید استفاده نیست زیرا پیکربندی آن باید توسط Administrator آمار اصلاح شود.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'درخواست‎های قفل شده من',
        'My watched tickets' => 'درخواست مشاهده شده من',
        'My responsibilities' => 'مسئولیت من',
        'Tickets in My Queues' => 'درخواستهای در صفهای من',
        'Tickets in My Services' => 'درخواستهای در سرویسهای من',
        'Service Time' => 'زمان سرویس',
        'Remove active filters for this widget.' => 'حذف فیلتر فعال برای این عنصر است.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'مجموع',

        # Template: AgentDashboardUserOnline
        'out of office' => 'زمان بیرون بودن از محل کار',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'تا',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'درخواست تحویل گرفته شده است',
        'Undo & close' => 'عملیات را برگردان و پنجره را ببند',

        # Template: AgentInfo
        'Info' => 'اطلاعات',
        'To accept some news, a license or some changes.' => 'برای پذیرش برخی اخبار، یک گواهینامه یا برخی تغییرات.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'مورد مرتبط:%s',
        'go to link delete screen' => 'به لینک صفحه حذف کردن برو',
        'Select Target Object' => 'آبجکت مقصد را انتخاب نمایید',
        'Link object %s with' => 'موضوع لینک %s با',
        'Unlink Object: %s' => 'مورد نا مرتبط:%s',
        'go to link add screen' => 'به لینک صفحه افزودن برو',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => 'استفاده غیر مجاز از %s شناسایی',
        'If you decide to downgrade to OTRS Free, you will lose all database tables and data related to %s.' =>
            'اگر شما تصمیم به جمع و جور کردن به OTRS رایگان، شما تمام جداول پایگاه داده و داده های مربوط به از دست دادن %s .',

        # Template: AgentPreferences
        'Edit your preferences' => 'تنظیمات شخصی خودتان را ویرایش نمایید',
        'Did you know? You can help translating OTRS at %s.' => 'آیا میدانستید ؟ شما میتوانید در ترجمه OTRS در %s به ما کمک کنید.',

        # Template: AgentSpelling
        'Spell Checker' => 'غلط یاب',
        'spelling error(s)' => 'خطاهای غلط یابی',
        'Apply these changes' => 'این تغییرات را در اعمال کن',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => 'آمار »اضافه',
        'Add New Statistic' => 'اضافه کردن  آمارجدید',
        'Dynamic Matrix' => 'ماتریس پویا',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            'بشقاب گزارش داده که در آن هر سلول شامل یک نقطه داده منحصر به فرد (به عنوان مثال تعداد بلیط).',
        'Dynamic List' => 'لیست پویا',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            'بشقاب گزارش داده که در آن هر سطر شامل داده از یک نهاد (به عنوان مثال یک بلیط).',
        'Static' => 'ایستا',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            'آمار پیچیده ای است که می تواند پیکربندی شده است و ممکن است داده های غیر جدولی بازگشت.',
        'General Specification' => 'مشخصات عمومی',
        'Create Statistic' => 'آماردرست ',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => 'آمار »ویرایش %s %s - %s',
        'Run now' => 'الان اجرا کن',
        'Statistics Preview' => ' پیش آمار',
        'Save statistic' => 'ذخیره آمار',

        # Template: AgentStatisticsImport
        'Statistics » Import' => 'آمار »دریافت',
        'Import Statistic Configuration' => 'دریافت پیکربندی آمار',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => 'آمار »بررسی اجمالی',
        'Statistics' => 'گزارشات',
        'Run' => 'دویدن',
        'Edit statistic "%s".' => 'ویرایش آمار \ " %s ".',
        'Export statistic "%s"' => 'آمارارسال \ " %s "',
        'Export statistic %s' => 'آمار ارسال %s',
        'Delete statistic "%s"' => 'حذف آمار \ " %s "',
        'Delete statistic %s' => 'حذف آمار %s',
        'Do you really want to delete this statistic?' => 'آیا واقعا میخواهید این آمار را حذف کنید؟',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => 'آمار »نمایش %s %s - %s',
        'Statistic Information' => 'اطلاعات آماری',
        'Sum rows' => 'جمع سطر‌ها',
        'Sum columns' => 'جمع ستون‌ها',
        'Show as dashboard widget' => 'نمایش به عنوان ویجت داشبورد',
        'Cache' => 'نگهداری',
        'This statistic contains configuration errors and can currently not be used.' =>
            'این آمار شامل خطاهای پیکربندی هستند و در حال حاضر قابل استفاده نیستند.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'تغییر متن رایگان از %s %s %s',
        'Change Owner of %s%s%s' => 'تغییر صاحب %s %s %s',
        'Close %s%s%s' => 'نزدیک %s %s %s',
        'Add Note to %s%s%s' => 'اضافه کردن یادداشت به %s %s %s',
        'Set Pending Time for %s%s%s' => 'تنظیم انتظار زمان برای %s %s %s',
        'Change Priority of %s%s%s' => 'تغییر اولویت %s %s %s',
        'Change Responsible of %s%s%s' => 'تغییر مسئول %s %s %s',
        'All fields marked with an asterisk (*) are mandatory.' => 'همه فیلدهایی که با ستاره مشخص شده اند (*) الزامی است.',
        'Service invalid.' => 'سرویس نامعتبر',
        'New Owner' => 'صاحب جدید',
        'Please set a new owner!' => 'لطفا یک صاحب جدید مشخص نمایید!',
        'New Responsible' => ' مسئول جدید',
        'Next state' => 'وضعیت بعدی',
        'For all pending* states.' => 'برای همه کشورهای * در انتظار.',
        'Add Article' => 'اضافه کردن نوشته',
        'Create an Article' => 'ایجاد یک مقاله',
        'Inform agents' => 'اطلاع عوامل',
        'Inform involved agents' => 'اطلاع عوامل درگیر',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'در اینجا شما می توانید عوامل اضافی که باید اطلاع رسانی در مورد این مقاله جدید دریافت خواهید کرد را انتخاب کنید.',
        'Text will also be received by' => 'متن نیز دریافت می شود  توسط',
        'Spell check' => 'غلط‌یابی',
        'Text Template' => 'قالب متن',
        'Setting a template will overwrite any text or attachment.' => 'تنظیم یک قالب هر گونه متن یا پیوست بازنویسی.',
        'Note type' => 'نوع یادداشت',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'پریدن %s %s %s',
        'Bounce to' => 'ارجاع شده به',
        'You need a email address.' => 'به یک آدرس ایمیل نیاز دارید',
        'Need a valid email address or don\'t use a local email address.' =>
            'به یک آدرس ایمیل معتبر نیاز دارید یا از یک آدرس ایمیل محلی استفاده نکنید.',
        'Next ticket state' => 'وضعیت بعدی درخواست',
        'Inform sender' => 'به ارسال کننده اطلاع بده',
        'Send mail' => 'ارسال ایمیل!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'عملیات کلی روی درخواست',
        'Send Email' => 'ارسال ایمیل!',
        'Merge to' => 'ادغام با',
        'Invalid ticket identifier!' => 'شناسه درخواست نامعتبر',
        'Merge to oldest' => 'ترکیب با قدیمی‌ترین',
        'Link together' => 'ارتباط با یک دیگر',
        'Link to parent' => 'ارتباط به والد',
        'Unlock tickets' => 'درخواست‌های تحویل داده شده',
        'Execute Bulk Action' => 'ادراه کردن میزان عمل',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'نوشتن پاسخ برای %s %s %s',
        'This address is registered as system address and cannot be used: %s' =>
            'این آدرس به عنوان آدرس سیستم ثبت شده و می تواند استفاده شود: %s',
        'Please include at least one recipient' => 'لطفا حداقل یک گیرنده را قراردهید',
        'Remove Ticket Customer' => 'حذف و ضوابط درخواست',
        'Please remove this entry and enter a new one with the correct value.' =>
            'لطفا این مطلب را حذف و یک مطلب جدید با مقدار صحیح را وارد کنید.',
        'Remove Cc' => 'حذف رونوشت',
        'Remove Bcc' => 'حذف کپی به',
        'Address book' => 'دفترچه آدرس',
        'Date Invalid!' => 'تاریخ نامعتبر!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'تغییر مشتری از %s %s %s',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'ساخت درخواست ایمیلی جدید',
        'Example Template' => 'به عنوان مثال قالب',
        'From queue' => 'از صف درخواست',
        'To customer user' => 'به کاربران مشتری',
        'Please include at least one customer user for the ticket.' => 'لطفا حداقل یک کاربر مشتری برای درخواست قرار دهید',
        'Select this customer as the main customer.' => 'این مشتری را به عنوان مشتری اصلی انتخاب کنید.',
        'Remove Ticket Customer User' => 'حذف درخواست  کاربرمشتری',
        'Get all' => 'گرفتن همه',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'عازم ناحیه دور دست ایمیل برای %s %s %s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'بلیط %s : زمان پاسخ برای اولین بار است که بیش از ( %s / %s )!',
        'Ticket %s: first response time will be over in %s/%s!' => 'بلیط %s : اول زمان پاسخ را در خواهد %s / %s !',
        'Ticket %s: update time is over (%s/%s)!' => 'بلیط %s : زمان به روز رسانی به پایان رسیده است ( %s / %s )!',
        'Ticket %s: update time will be over in %s/%s!' => 'بلیط %s : زمان به روز رسانی بیش از در خواهد %s / %s !',
        'Ticket %s: solution time is over (%s/%s)!' => 'بلیط %s : زمان حل به پایان رسیده است ( %s / %s )!',
        'Ticket %s: solution time will be over in %s/%s!' => 'بلیط %s : زمان حل بیش از در خواهد %s / %s !',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'رو به جلو %s %s %s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'تاریخ %s %s %s',
        'History Content' => 'محتوای سابقه',
        'Zoom view' => 'نمای کامل',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'ادغام %s %s %s',
        'Merge Settings' => 'ادغام تنظیمات',
        'You need to use a ticket number!' => 'شما باید از شماره درخواست استفاده نمائید!',
        'A valid ticket number is required.' => 'شماره درخواست معتبر مورد نیاز است.',
        'Need a valid email address.' => 'به آدرس ایمیل معتبر نیاز است.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'حرکت %s %s %s',
        'New Queue' => 'لیست درخواست جدید',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'انتخاب همه',
        'No ticket data found.' => 'اطلاعات درخواست یافت نشد.',
        'Open / Close ticket action menu' => 'باز / بستن بلیط منوی عمل',
        'Select this ticket' => 'انتخاب این تیکت',
        'First Response Time' => 'زمان اولین پاسخ',
        'Update Time' => 'زمان بروز رسانی',
        'Solution Time' => 'زمان ارائه راهکار',
        'Move ticket to a different queue' => 'انتقال درخواست یه صف درخواست دیگر',
        'Change queue' => 'تغییر لیست درخواست',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'تغییر گزینه‌های جستجو',
        'Remove active filters for this screen.' => 'حذف فیلتر فعال برای این صفحه نمایش.',
        'Tickets per page' => 'درخواست در هر صفحه',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'مرور تنظیم مجدد',
        'Column Filters Form' => 'فرم ستون فیلتر',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'تقسیم درخواست تلفن جدید',
        'Save Chat Into New Phone Ticket' => 'ذخیره چت به درخواست تلفن جدید',
        'Create New Phone Ticket' => 'ساخت درخواست تلفنی جدید',
        'Please include at least one customer for the ticket.' => 'لطفا حداقل یک مشتری برای درخواست قراردهید',
        'To queue' => 'به صف درخواست',
        'Chat protocol' => 'موافقت اولیه چت',
        'The chat will be appended as a separate article.' => 'چت به عنوان یک مقاله جداگانه اضافه خواهد شد.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'تماس بگیرید تلفن تماس برای %s %s %s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'نمایش ایمیل متن ساده برای %s %s %s',
        'Plain' => 'ساده',
        'Download this email' => 'دریافت این ایمیل',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'ایجاد درخواست جدید فرآیند',
        'Process' => 'پروسه',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'ثبت نام درخواست به یک فرایند',

        # Template: AgentTicketSearch
        'Search template' => 'الگوی جستجو',
        'Create Template' => 'ساخت قالب',
        'Create New' => 'ساخت مورد جدید',
        'Profile link' => 'لینک مشخصات',
        'Save changes in template' => 'ذخیره تغییرات در قالب',
        'Filters in use' => 'فیلترها برای استفاده',
        'Additional filters' => 'فیلتر های اضافی',
        'Add another attribute' => 'افزودن ویژگی دیگر',
        'Output' => 'نوع نتیجه',
        'Fulltext' => 'جستجوی تمام متن',
        'Remove' => 'حذف کردن',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'جستجو در صفات از، به، CC، موضوع و متن، فارغ از ویژگی های دیگر با همین نام.',
        'CustomerID (complex search)' => 'CustomerID (جستجوی پیچیده)',
        '(e. g. 234*)' => '',
        'CustomerID (exact match)' => 'CustomerID (مطابقت دقیق)',
        'Customer User Login (complex search)' => 'ورود و ضوابط کاربر (جستجوی پیچیده)',
        '(e. g. U51*)' => '',
        'Customer User Login (exact match)' => 'ورود و ضوابط کاربر (مطابقت دقیق)',
        'Attachment Name' => 'نام فایل پیوست',
        '(e. g. m*file or myfi*)' => '(به عنوان مثال متر * فایل یا myfi *)',
        'Created in Queue' => 'ایجاد شده در صف درخواست',
        'Lock state' => 'وضعیت تحویل',
        'Watcher' => 'مشاهده‌کننده',
        'Article Create Time (before/after)' => 'زمان ساخت مطلب (قبل از/بعد از)',
        'Article Create Time (between)' => 'زمان ساخت مطلب (بین)',
        'Ticket Create Time (before/after)' => 'زمان ساخت درخواست (قبل از/بعد از)',
        'Ticket Create Time (between)' => 'زمان ساخت درخواست (بین)',
        'Ticket Change Time (before/after)' => 'زمان تغییر درخواست (قبل از/بعد از)',
        'Ticket Change Time (between)' => 'زمان تغییر درخواست (بین)',
        'Ticket Last Change Time (before/after)' => 'بلیط آخرین تغییر زمان (قبل از / پس)',
        'Ticket Last Change Time (between)' => 'بلیط آخرین تغییر زمان (بین)',
        'Ticket Close Time (before/after)' => 'زمان بستن درخواست (قبل از/بعد از)',
        'Ticket Close Time (between)' => 'زمان بستن درخواست (بین)',
        'Ticket Escalation Time (before/after)' => 'تشدید درخواست زمان (قبل از / پس)',
        'Ticket Escalation Time (between)' => 'تشدید درخواست زمان (بین)',
        'Archive Search' => 'جستجوی آرشیو',
        'Run search' => 'اجرا جستجو ',

        # Template: AgentTicketZoom
        'Article filter' => 'فیلتر مطلب',
        'Article Type' => 'نوع مطلب',
        'Sender Type' => 'نوع فرستنده',
        'Save filter settings as default' => 'ذخیره تنظیمات فیلتر به عنوان تنظیمات پیش فرض',
        'Event Type Filter' => 'نوع رویداد فیلتر',
        'Event Type' => 'نوع رویداد',
        'Save as default' => 'ذخیره به عنوان پیش فرض',
        'Archive' => 'آرشیو',
        'This ticket is archived.' => 'این درخواست بایگانی شده است.',
        'Note: Type is invalid!' => 'توجه: نوع نامعتبر است!',
        'Locked' => 'تحویل گرفته شده',
        'Accounted time' => 'زمان محاسبه شده',
        'Linked Objects' => 'آبجکت‌های مرتبط شده',
        'Change Queue' => 'تغییر صف درخواست',
        'There are no dialogs available at this point in the process.' =>
            'هیچ پنجره موجود در این نقطه از این فرآیند وجود ندارد.',
        'This item has no articles yet.' => 'این محصول هنوز دارای هیچ مقاله ای نیست.',
        'Ticket Timeline View' => 'درخواست گاهشمار مشخصات',
        'Article Overview' => 'بررسی اجمالی مقاله',
        'Article(s)' => 'مطلب (ها)',
        'Page' => 'صفحه',
        'Add Filter' => 'افزودن فیلتر',
        'Set' => 'ثبت',
        'Reset Filter' => 'تنظیم مجدد فیلتر',
        'Show one article' => 'نمایش یک مطلب',
        'Show all articles' => 'نمایش تمام مطالب',
        'Show Ticket Timeline View' => 'نشان دادن درخواست گاهشمار مشخصات',
        'Unread articles' => 'مطالب خوانده نشده',
        'No.' => 'خیر',
        'Important' => 'مهم',
        'Unread Article!' => 'مطلب خوانده نشده!',
        'Incoming message' => 'پیغام وارده',
        'Outgoing message' => 'پیغام ارسالی',
        'Internal message' => 'پیغام داخلی',
        'Resize' => 'تغییر اندازه',
        'Mark this article as read' => 'علامت گذاری  این مقاله به عنوان خوانده شده',
        'Show Full Text' => 'نمایش کامل متن ',
        'Full Article Text' => ' متن  کامل مقاله',
        'No more events found. Please try changing the filter settings.' =>
            'هیچ رویداد بیشتر شده است. لطفا سعی کنید تغییر تنظیمات فیلتر.',
        'by' => 'توسط',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'برای باز کردن لینک در مقاله زیر، شما ممکن است نیاز به فشار دکمه های Ctrl و کلیدهای Cmd و یا کلید Shift در حالی که در سایت ثبت نام (بسته به نوع مرورگر و سیستم عامل خود را).',
        'Close this message' => 'این پیام را ببندید',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'مقاله نمی تواند باز شود. شاید آن در صفحه مقاله دیگری است؟',
        'Scale preview content' => 'محتوای پیش نمایش مقیاس',
        'Open URL in new tab' => 'باز کردن URL در تب جدید',
        'Close preview' => 'بستن پیش نمایش',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'پیش نمایش از این وب سایت می تواند ارائه شود چرا که آن را اجازه نمی دهد به تعبیه شده است.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'برای محافظت از حریم خصوصی شما، محتوای راه دور متوقف شد.',
        'Load blocked content.' => 'بارگذاری محتوای مسدود شده.',

        # Template: ChatStartForm
        'First message' => 'اولین پیام',

        # Template: CloudServicesDisabled
        'This feature requires cloud services.' => 'این قابلیت نیاز به سرویس های ابری دارد . ',
        'You can' => 'شما می‌توانید',
        'go back to the previous page' => 'به صفحه قبل برگرد',

        # Template: CustomerError
        'An Error Occurred' => 'خطا',
        'Error Details' => 'جزئیات خطا',
        'Traceback' => 'بازبینی',

        # Template: CustomerFooter
        'Powered by' => ' قدرت گرفته از ',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'یک یا جچند خطا رخ داده است!',
        'Close this dialog' => 'بستن این پنجره',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'پنجره popup نمی‌تواند باز شود. لطفا همه مسدودکننده‌های popup را برای این نرم‌افزار غیرفعال نمایید.',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'اگر اکنون این صفحه را ترک نمایید، تمام پنجره‌های popup باز شده نیز بسته خواهند شد!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'popup ای از این صفحه هم اکنون باز است. آیا می‌خواهید این را بسته و آن را به جایش بارگذاری نمایید؟',
        'There are currently no elements available to select from.' => 'در حال حاضر هیچ یک از عناصر در دسترس برای انتخاب  وجود ندارد.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'لطفا حالت سازگاری در اینترنت اکسپلورر را خاموش کنید !',
        'The browser you are using is too old.' => 'مرورگری که استفاده می‌کنید خیلی قدیمی است.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'این نرم‌افزار با تعداد زیادی از مرورگرها کار می‌کند. لطفا به یکی از آنها ارتقاء دهید.',
        'Please see the documentation or ask your admin for further information.' =>
            'لطفا مستندات را مشاهده کنید یا از مدیر سیستم برای اطلاعات بیشتر سوال بپرسید.',
        'Switch to mobile mode' => 'تغییر به حالت همراه',
        'Switch to desktop mode' => 'تغییر به حالت دسکتاپ',
        'Not available' => 'در دسترس نیست',
        'Clear all' => 'همه را پاک کن ',
        'Clear search' => ' پاک کردن جستجو',
        '%s selection(s)...' => '%s انتخاب (بازدید کنندگان) ...',
        'and %s more...' => 'و %s بیشتر ...',
        'Filters' => 'فیلترها ',
        'Confirm' => 'تائید',
        'You have unanswered chat requests' => 'شما  درخواست چت بدون پاسخ دارید',
        'Accept' => 'پذیرفتن',
        'Decline' => 'رد کردن',
        'An internal error occurred.' => 'یک اشتباه داخلی رخ داد.',
        'Connection error' => 'خطای اتصال',
        'Reload page' => 'بارگذاری مجدد صفحه',
        'Your browser was not able to communicate with OTRS properly, there seems to be something wrong with your network connection. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            'مرورگر خود را قادر به برقراری ارتباط با OTRS به درستی نمی به نظر می رسد، به چیزی اشتباه است با اتصال به شبکه شما وجود دارد. شما می توانید این صفحه بارگذاری دستی امتحان کنید یا صبر کنید تا مرورگر شما دوباره برقرار اتصال در خود را دارد.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'اتصال شده است دوباره برقرار پس از از دست دادن اتصال موقت. با توجه به این، از عناصر این صفحه می تواند متوقف کرده اند به درستی کار کند. به منظور قادر به استفاده از تمام عناصر به درستی دوباره، آن است که شدت توصیه می شود به بارگذاری مجدد این صفحه.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'جاوااسکریپت در دسترس نیست',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'به منظور تجربه این نرم‌افزار ، نیاز دارید که جاوااسکریپت مرورگر خود را فعال نمایید.',
        'Browser Warning' => 'اخطار مرورگر',
        'One moment please, you are being redirected...' => 'لطفا چند لحظه صبرکنید ، شما در حال هدایت می شوید ...',
        'Login' => 'ورود به سیستم',
        'User name' => 'نام کاربری',
        'Your user name' => 'نام کاربری شما',
        'Your password' => 'رمز عبور شما',
        'Forgot password?' => 'رمز عبور را فراموش کردید؟',
        '2 Factor Token' => '2 فاکتور رمز',
        'Your 2 Factor Token' => ' 2 فاکتور رمزشما',
        'Log In' => 'ورود',
        'Not yet registered?' => 'هنوز ثبت نام نشده‌اید؟',
        'Request new password' => 'درخواست رمز عبور جدید',
        'Your User Name' => 'نام کاربری شما',
        'A new password will be sent to your email address.' => 'رمز عبور جدید برای آدرس ایمیل شما ارسال خواهد شد.',
        'Create Account' => 'ثبت نام',
        'Please fill out this form to receive login credentials.' => 'لطفا این فرم را  برای دریافت اعتبار ورود پر کنید . ',
        'How we should address you' => 'ما چگونه شما را خطاب کنیم',
        'Your First Name' => 'نام شما',
        'Your Last Name' => 'نام خانوادگی شما',
        'Your email address (this will become your username)' => 'نشانی ایمیل شما (این تبدیل خواهد شد به نام کاربری شما)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'درخواست چت ورودی',
        'Edit personal preferences' => 'ویرایش تنظیمات شخصی',
        'Logout %s %s' => '%s - %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'نقل قول اسپلیت',
        'Open link' => 'لینک های باز',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'توافقنامه سطح سرویس',

        # Template: CustomerTicketOverview
        'Welcome!' => 'خوش آمدید',
        'Please click the button below to create your first ticket.' => 'لطفا دکمه زیر را برای ساخت اولین درخواست خود بفشارید.',
        'Create your first ticket' => 'ساخت اولین درخواست شما',

        # Template: CustomerTicketSearch
        'Profile' => 'مشخصات کاربری',
        'e. g. 10*5155 or 105658*' => 'به عنوان مثال 10*5155 یا 105658*',
        'Customer ID' => 'شناسه مشترک',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'جستجوی تمام متن درخواست‌ها (به عنوان مثال  "John*n" or "Will*")',
        'Recipient' => 'گیرنده',
        'Carbon Copy' => 'رونوشت کاربونی',
        'e. g. m*file or myfi*' => 'به عنوان مثال متر * فایل یا myfi *',
        'Types' => 'انواع',
        'Time restrictions' => 'محدودیت‌های زمان',
        'No time settings' => 'بدون تنظیمات زمان',
        'Specific date' => 'تاریخ خاص',
        'Only tickets created' => 'فقط درخواست‌های ساخته شده',
        'Date range' => 'محدوده زمانی',
        'Only tickets created between' => 'فقط درخواست‌های ساخته شده بین',
        'Ticket archive system' => 'سیستم آرشیودرخواست',
        'Save search as template?' => 'ذخیره جستجو به عنوان الگو؟',
        'Save as Template?' => 'ذخیره به عنوان قالب؟',
        'Save as Template' => 'ذخیره به عنوان الگو',
        'Template Name' => 'نام قالب',
        'Pick a profile name' => 'انتخاب یک نام مشخصات',
        'Output to' => 'خروجی به',

        # Template: CustomerTicketSearchResultShort
        'of' => ' از ',
        'Search Results for' => 'نتایج جستجو برای',
        'Remove this Search Term.' => 'حذف این عبارت جستجو.',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'آغاز گپ این درخواست از',
        'Expand article' => 'گسترش مطلب',
        'Information' => 'اطلاعات',
        'Next Steps' => 'گام های بعدی',
        'Reply' => 'پاسخ',
        'Chat Protocol' => 'پروتکل چت',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'تمام روز',
        'Sunday' => 'یکشنبه',
        'Monday' => 'دوشنبه',
        'Tuesday' => 'سه‌شنبه',
        'Wednesday' => 'چهارشنبه',
        'Thursday' => 'پنجشنبه',
        'Friday' => 'جمعه',
        'Saturday' => 'شنبه',
        'Su' => 'یک',
        'Mo' => 'دو',
        'Tu' => 'سه',
        'We' => 'چهار',
        'Th' => 'پنج',
        'Fr' => 'جمعه',
        'Sa' => 'شنبه',
        'Event Information' => 'اطلاعات رویداد',
        'Ticket fields' => 'زمینه های درخواست',
        'Dynamic fields' => 'زمینه های پویا',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'تاریخ نامعتبر (نیاز به تاریخی در آینده)!',
        'Invalid date (need a past date)!' => 'تاریخ نامعتبر (نیاز به یک تاریخ گذشته)!',
        'Previous' => 'قبلی',
        'Open date selection' => 'باز کردن انتخاب تاریخ',

        # Template: Error
        'An error occurred.' => 'یک خطا رخ داده است.',
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            'واقعا یک اشکال؟ 5 از 10 گزارش اشکال از نصب و راه اندازی اشتباه و یا ناقص از OTRS شود.',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            'با %s ، کارشناسان ما مراقبت از نصب صحیح و پوشش پشت خود را با پشتیبانی و به روز رسانی های امنیتی تناوبی.',
        'Contact our service team now.' => ' با تیم خدمات ما در حال حاضر تماس بگیرید.',
        'Send a bugreport' => 'ارسال گزارش خطا',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            'لطفا حداقل یک مقدار مورد جستجو را وارد کنید یا * به پیدا کردن هر چیزی.',
        'Please remove the following words from your search as they cannot be searched for:' =>
            'لطفا کلمات زیر از جستجوی خود را حذف به آنها می تواند قابل جستجو نیستند:',
        'Please check the fields marked as red for valid inputs.' => 'لطفا فیلدهای مشخص شده به عنوان قرمز برای ورودی های معتبر را بررسی کنید.',
        'Please perform a spell check on the the text first.' => 'لطفا ابتدا بررسی املا در متن انجام دهید.',
        'Slide the navigation bar' => 'اسلاید نوار ناوبری',
        'Unavailable for chat' => 'در دسترس نیست برای چت',
        'Available for internal chats only' => ' تنهابرای چت داخلی موجود است',
        'Available for chats' => 'موجود برای چت',
        'Please visit the chat manager' => 'لطفا از سایت چت دیدن کنید',
        'New personal chat request' => 'درخواست جدید  چت شخصی',
        'New customer chat request' => 'درخواست جدید چت مشتری',
        'New public chat request' => ' درخواست جدید چت عمومی',
        'Selected user is not available for chat.' => 'کاربران انتخاب شده است برای چت در دسترس نیست.',
        'New activity' => 'فعالیت جدید',
        'New activity on one of your monitored chats.' => 'فعالیت جدید بر روی یکی از چت نظارت خود را.',
        'Your browser does not support video and audio calling.' => 'مرورگر شما از ویدیو و تماس های صوتی پشتیبانی نمی کند.',
        'Selected user is not available for video and audio call.' => 'کاربران انتخاب شده است برای ویدیو و تماس های صوتی در دسترس نیست.',
        'Target user\'s browser does not support video and audio calling.' =>
            'مرورگر کاربر مورد نظر می کند، ویدیو و تماس های صوتی پشتیبانی نمی کند.',
        'Do you really want to continue?' => 'آیا واقعا میخواهید ادامه دهید؟',
        'Information about the OTRS Daemon' => 'اطلاعات در مورد OTRS دیمون',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            'این ویژگی بخشی از است %s . لطفا با ما تماس بگیرید %s برای ارتقاء.',
        'Find out more about the %s' => 'یافتن پست های بیشتر در مورد %s',

        # Template: Header
        'You are logged in as' => 'شما با این عنوان وارد شده‌اید',

        # Template: Installer
        'JavaScript not available' => 'جاوا اسکریپت در دسترس نیست',
        'Step %s' => 'مرحله %s',
        'Database Settings' => 'تنظیمات پایگاه داده',
        'General Specifications and Mail Settings' => 'مشخصات عمومی و تنظیمات ایمیل',
        'Finish' => 'پایان',
        'Welcome to %s' => 'خوش آمدید به %s',
        'Web site' => 'وب سایت',
        'Mail check successful.' => 'کنترل تنظیمات ایمیل موفقیت‌آمیز بود.',
        'Error in the mail settings. Please correct and try again.' => 'خطا در تنظیمات ایمیل. لطفا تصحیح نموده و مجددا تلاش نمایید.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'پیکربندی ایمیل ارسالی',
        'Outbound mail type' => 'نوع ایمیل ارسالی',
        'Select outbound mail type.' => 'نوع ایمیل ارسالی را انتخا نمایید.',
        'Outbound mail port' => 'پورت ایمیل ارسالی',
        'Select outbound mail port.' => 'پورت ایمیل ارسالی را انتخاب نمایید.',
        'SMTP host' => 'میزبان SMTP',
        'SMTP host.' => 'میزبان SMTP.',
        'SMTP authentication' => 'تصدیق SMTP',
        'Does your SMTP host need authentication?' => 'آیا میزبان SMTP شما نیاز به authentication دارد؟',
        'SMTP auth user' => 'کاربر SMTP',
        'Username for SMTP auth.' => 'نام کاربری برای تصدیق SMTP',
        'SMTP auth password' => 'رمز عبور SMTP',
        'Password for SMTP auth.' => 'رمز عبور برای تصدیق SMTP',
        'Configure Inbound Mail' => 'پیکربندی ایمیل وارده',
        'Inbound mail type' => 'نوع ایمیل وارده',
        'Select inbound mail type.' => 'نوع ایمیل وارده را انتخاب نمایید.',
        'Inbound mail host' => 'میزبان ایمیل وارده',
        'Inbound mail host.' => 'میزبان ایمیل وارده.',
        'Inbound mail user' => 'کاربر ایمیل وارده',
        'User for inbound mail.' => 'کاربر برای ایمیل وارده.',
        'Inbound mail password' => 'رمز عبور ایمیل وارده',
        'Password for inbound mail.' => 'رمز عبور برای ایمیل وارده.',
        'Result of mail configuration check' => 'نتیجه کنترل پیکربندی ایمیل',
        'Check mail configuration' => 'کنترل پیکربندی ایمیل',
        'Skip this step' => 'از این مرحله بگذر',

        # Template: InstallerDBResult
        'Database setup successful!' => 'راه اندازی پایگاه داده موفق!',

        # Template: InstallerDBStart
        'Install Type' => ' نوع نصب',
        'Create a new database for OTRS' => 'ایجاد یک پایگاه داده جدید برای OTRS',
        'Use an existing database for OTRS' => 'استفاده از یک پایگاه داده موجود برای OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'نام پایگاه داده :',
        'Check database settings' => 'کنترل تنظیمات پایگاه داده',
        'Result of database check' => 'نتیجه کنترل پایگاه داده',
        'Database check successful.' => 'کنترل پایگاه داده با موفقیت انجام شد.',
        'Database User' => 'پایگاه داده کاربر',
        'New' => 'جدید',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'یک کاربر برای پایگاه داده با دسترسی‌های محدود برای این سیستم ساخته خواهند شد.',
        'Repeat Password' => 'تکرار رمز عبور ',
        'Generated password' => 'رمز عبور تولید شده',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'رمزهای ورود مطابقت ندارند',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'پورت',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'برای استفاده از سیستم خط زیر را در Command Prompt اجرا نمائید.',
        'Restart your webserver' => 'سرور وب خود را راه اندازی مجدد نمائید',
        'After doing so your OTRS is up and running.' => 'بعد از انجام سیستم قابل استفاده خواهد بود',
        'Start page' => 'صفحه شروع',
        'Your OTRS Team' => 'تیم نرم‌افزار',

        # Template: InstallerLicense
        'Don\'t accept license' => 'عدم تائید مجوز بهره برداری',
        'Accept license and continue' => 'قبول مجوز و ادامه',

        # Template: InstallerSystem
        'SystemID' => 'شناسه سیستم',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'شناسه سیستم. هر شماره درخواست و هر شناسه HTTP Session شامل این شماره می‌باشد.',
        'System FQDN' => 'FQDN سیستم',
        'Fully qualified domain name of your system.' => 'FQDN سیستم شما',
        'AdminEmail' => 'ایمیل مدیر',
        'Email address of the system administrator.' => 'آدرس ایمیل مدیریت سیستم',
        'Organization' => 'سازمان',
        'Log' => 'وقایع ثبت شده',
        'LogModule' => 'ماژول ثبت وقایع',
        'Log backend to use.' => 'ورود باطن برای استفاده.',
        'LogFile' => 'فایل ثبت وقایع',
        'Webfrontend' => 'محیط کار وب',
        'Default language' => 'زبان پیش‌فرض',
        'Default language.' => 'زبان پیش‌فرض',
        'CheckMXRecord' => 'بررسی Mx Record',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'آدرس‌های ایمیل که به صورت دستی وارده شده در برابر رکوردهای MX یافت شده در DNS کنترل می‌شود. اگر DNS شما کند است و یا آدرس‌های عمومی را عبور نمی‌دهد از این گزینه استفاده نکنید.',

        # Template: LinkObject
        'Object#' => 'شماره آبجکت',
        'Add links' => 'افزودن رابطه‌ها',
        'Delete links' => 'حذف رابطه‌ها',

        # Template: Login
        'Lost your password?' => 'رمز عبور خود را فراموش کرده اید؟',
        'Request New Password' => 'درخواست رمز عبور جدید',
        'Back to login' => 'بازگشت به صفحه ورود',

        # Template: MobileNotAvailableWidget
        'Feature not available' => 'از ویژگی های موجود نیست',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'با عرض پوزش، اما این ویژگی از OTRS در حال حاضر برای دستگاه های تلفن همراه در دسترس نیست. اگر شما می خواهم به استفاده از آن، شما می توانید هر دو سوئیچ به حالت دسکتاپ و یا استفاده از دستگاه دسکتاپ خود را به طور منظم.',

        # Template: Motd
        'Message of the Day' => 'پیام روز',
        'This is the message of the day. You can edit this in %s.' => 'این پیام از روز است. شما می توانید این را در ویرایش %s .',

        # Template: NoPermission
        'Insufficient Rights' => 'حقوق دسترسی ناکافی',
        'Back to the previous page' => 'بازگشت به صفحه قبل',

        # Template: Pagination
        'Show first page' => 'نمایش اولین صفحه',
        'Show previous pages' => 'نمایش صفحات قبلی',
        'Show page %s' => 'نمایش صفحه %s',
        'Show next pages' => 'نمایش صفحات بعدی',
        'Show last page' => 'نمایش آخرین صفحه',

        # Template: PictureUpload
        'Need FormID!' => 'شناسه فرم مورد نیاز است',
        'No file found!' => 'فایلی یافت نشد!',
        'The file is not an image that can be shown inline!' => 'فایل مورد نظر تصویری نیست که بتواند به صورت inline نمایش داده شود.',

        # Template: PreferencesNotificationEvent
        'Notification' => 'اعلان',
        'No user configurable notifications found.' => 'هیچ کاربری اطلاعیه تنظیم شده است.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'برای دریافت پیام های اطلاع رسانی " %s با روش حمل و نقل %s .',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'لطفا توجه داشته باشید که شما می توانید به طور کامل غیر فعال کردن به عنوان اجباری مشخص شده اند.',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'با عرض پوزش، اما شما می توانید از تمام روش برای اطلاعیه مشخص شده به عنوان اجباری را غیر فعال کنید.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'با عرض پوزش، اما شما می توانید از تمام روش برای این اطلاع رسانی را غیر فعال کنید.',

        # Template: ActivityDialogHeader
        'Process Information' => 'پردازش اطلاعات',
        'Dialog' => 'گفتگو',

        # Template: Article
        'Inform Agent' => 'اطلاع به کارشناس',

        # Template: PublicDefault
        'Welcome' => 'خوش آمدید',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            'این به طور پیش فرض رابط عمومی OTRS موجود است! هیچ پارامتر action داده شده وجود دارد.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'شما می توانید یک ماژول سفارشی عمومی (از طریق مدیر بسته) نصب، به عنوان مثال ماژول پرسش و پاسخ، که دارای یک رابط عمومی است.',

        # Template: RichTextEditor
        'Remove Quote' => 'حذف نقل قول',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'دسترسی‌ها',
        'You can select one or more groups to define access for different agents.' =>
            'شما می‌توانید یک یا چندین گروه را برای دسترسی برای کارشناسان مختلف تعریف نمایید.',
        'Result formats' => 'فرمت نتیجه',
        'The selected time periods in the statistic are time zone neutral.' =>
            'دوره زمانی انتخاب شده در آمار هستند منطقه زمانی خنثی است.',
        'Create summation row' => 'ایجاد ردیف جمع',
        'Generate an additional row containing sums for all data rows.' =>
            'تولید یک ردیف اضافی شامل مبالغ برای همه ردیف داده.',
        'Create summation column' => 'ساختن ستون جمع',
        'Generate an additional column containing sums for all data columns.' =>
            'تولید یک ستون حاوی مبالغ اضافی برای همه ستون داده ها.',
        'Cache results' => 'نتایج کش',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'آمار فروشگاه های منجر داده ها در یک کش به توان در نمایش های بعدی با همان پیکربندی استفاده می شود (نیاز به حداقل یک انتخاب زمان درست).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'ارائه آمار به عنوان یک ویجت است که عوامل می تواند در داشبورد خود را فعال کنید.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'لطفا توجه داشته باشید که قادر می سازد ویجت داشبورد خواهد ذخیره برای این آمار در داشبورد فعال کنید.',
        'If set to invalid end users can not generate the stat.' => 'اگر به کاربران نهایی نامعتبر تنظیم شده باشد، نمی‌توان گزارش را تولید کرد.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'مشکلات در پیکربندی این آمار وجود دارد:',
        'You may now configure the X-axis of your statistic.' => 'شما اکنون میتوانید با محور X آماره خود را پیکربندی کنید.',
        'This statistic does not provide preview data.' => 'این آمار داده های پیش نمایش ارائه نمی دهد.',
        'Preview format:' => 'فرمت پیش نمایش:',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'لطفا توجه داشته باشید که پیش نمایش با استفاده از داده های تصادفی و فیلتر داده نمی دانند.',
        'Configure X-Axis' => 'پیکربندی X-محور',
        'X-axis' => 'محور افقی',
        'Configure Y-Axis' => 'پیکربندی محور Y',
        'Y-axis' => 'محور Y',
        'Configure Filter' => 'پیکربندی فیلتر',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'فقط یک گزینه را انتخاب نمائید و یا کلید ثابت را خاموش نمائید',
        'Absolute period' => 'دوره مطلق',
        'Between' => 'بین',
        'Relative period' => 'دوره نسبی',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'گذشته کامل %s و جاری + آینده کامل %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'هنوز تغییرات را به این عنصر اجازه نمی دهد که آمار تولید می شود.',

        # Template: StatsParamsWidget
        'Format' => 'فرمت',
        'Exchange Axis' => 'جابجایی محورها',
        'Configurable params of static stat' => 'پارامترهای قابل تنظیم گزارش ثابت',
        'No element selected.' => 'هیچ گزینه ای انتخاب نشده است',
        'Scale' => 'مقیاس',
        'show more' => 'نمایش بیشتر',
        'show less' => 'کمترنشان می دهد ',

        # Template: D3
        'Download SVG' => 'دانلود SVG',
        'Download PNG' => 'دانلود PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'دوره زمانی انتخاب شده به طور پیش فرض چارچوب زمانی برای این آمار به جمع آوری داده ها از تعریف می کند.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'تعریف می کند که واحد زمان که استفاده می شود به تقسیم یک دوره زمانی انتخاب به گزارش نقاط داده است.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'لطفا به یاد داشته باشید که این مقیاس برای محور Y را به بزرگتر از مقیاس برای محور X (به عنوان مثال محور X => ماه، محور Y => سال).',

        # Template: Test
        'OTRS Test Page' => 'صفحه آزمایش سیستم',
        'Welcome %s %s' => '%s - %s',
        'Counter' => 'شمارنده',

        # Template: Warning
        'Go back to the previous page' => 'به صفحه قبل بازگرد',

        # Perl Module: Kernel/Config/Defaults.pm
        'View system log messages.' => 'نمایش پیغام‌های ثبت وقایع سیستم',
        'Update and extend your system with software packages.' => 'به روزرسانی و گسترش سیستم به کمک بسته‌های نرم‌افزاری',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ACL ها نمی تواند به دلیل یک خطای ناشناخته وارد شود، لطفابرای اطلاعات بیشتر OTRS سیاهه های مربوط را بررسی کنید ',
        'The following ACLs have been added successfully: %s' => 'استفاده از ACL زیر با موفقیت اضافه شده است: %s',
        'The following ACLs have been updated successfully: %s' => 'استفاده از ACL زیر با موفقیت به روز شده است: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'وجود دارد که در آن خطاهای اضافه کردن / به روز رسانی ACL ها زیر است: %s . لطفا ورود به سیستم فایل برای اطلاعات بیشتر.',
        'This field is required' => 'این فیلد مورد نیاز است',
        'There was an error creating the ACL' => 'خطایی در ایجاد لیگ قهرمانان آسیا وجود دارد',
        'Need ACLID!' => 'نیاز ACLID!',
        'Could not get data for ACLID %s' => 'می تواند داده ها را برای ACLID نیست %s',
        'There was an error updating the ACL' => 'خطایی در به روزرسانی لیگ قهرمانان آسیا وجود دارد',
        'There was an error setting the entity sync status.' => 'خطا در تنظیم وضعیت همگام نهاد وجود دارد.',
        'There was an error synchronizing the ACLs.' => 'یک خطای هماهنگ سازی ACL وجود دارد.',
        'ACL %s could not be deleted' => 'ACL %s نمی تواند حذف شود',
        'There was an error getting data for ACL with ID %s' => 'یک خطای گرفتن داده برای ACL با ID وجود دارد %s',
        'Exact match' => 'مطابقت کامل',
        'Negated exact match' => 'مطابقت دقیق نفی',
        'Regular expression' => 'عبارت منظم',
        'Regular expression (ignore case)' => 'عبارت منظم (چشم پوشی مورد)',
        'Negated regular expression' => 'بیان نفی به طور منظم',
        'Negated regular expression (ignore case)' => 'عبارت منظم نفی (چشم پوشی مورد)',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer Company %s already exists!' => 'ضوابط شرکت %s قبل وجود دارد!',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'درخواست تلفنی جدید',
        'New email ticket' => 'درخواست ایمیلی جدید',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'پیکربندی زمینه معتبر نیست',
        'Objects configuration is not valid' => 'پیکربندی اشیاء معتبر نیست',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'می تواند پویا درست سفارش تنظیم مجدد نمی کند، لطفا ورود به سیستم خطا برای جزئیات بیشتر.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'subaction تعریف نشده است.',
        'Need %s' => 'نیاز %s',
        'The field does not contain only ASCII letters and numbers.' => 'میدان آیا فقط شامل حروف ASCII و اعداد نیست.',
        'There is another field with the same name.' => ' یکی دیگر از این زمینه با همین نام وجود دارد.',
        'The field must be numeric.' => 'زمینه باید عدد باشد.',
        'Need ValidID' => 'نیاز ValidID',
        'Could not create the new field' => 'نمی توانید زمینه جدید ایجاد کنید',
        'Need ID' => 'نیاز ID',
        'Could not get data for dynamic field %s' => ' توان داده هابرای زمینه پویا نیست %s',
        'The name for this field should not change.' => 'نام این زمینه نباید تغییر کند.',
        'Could not update the field %s' => 'نمی توانید زمینه را به روز رسانی کنید %s',
        'Currently' => 'در حال حاضر',
        'Unchecked' => 'بدون کنترل',
        'Checked' => 'بررسی',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'جلوگیری از ورود تاریخ در آینده',
        'Prevent entry of dates in the past' => 'جلوگیری از ورود تاریخ در گذشته',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => 'این مقدار فیلد تکراری است.',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'حداقل یک گیرنده را انتخاب کنید.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'archive tickets' => ' آرشیو درخواست',
        'restore tickets from archive' => 'بازگرداندن درخواست از آرشیو',
        'Need Profile!' => 'نیاز به مشخصات!',
        'Got no values to check.' => 'هیچ ارزش به بررسی کردم.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'لطفا کلمات زیر حذف زیرا آنها می توانند برای انتخاب بلیط مورد استفاده قرار گیرد:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'نیاز WebserviceID!',
        'Could not get data for WebserviceID %s' => 'می تواند داده ها را برای WebserviceID نیست %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Need InvokerType' => 'نیاز InvokerType',
        'Invoker %s is not registered' => 'Invoker %s ثبت نشده است',
        'InvokerType %s is not registered' => 'InvokerType %s ثبت نشده است',
        'Need Invoker' => 'نیاز Invoker',
        'Could not determine config for invoker %s' => 'می تواند پیکربندی برای invoker مشخص نیست %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Could not get registered configuration for action type %s' => 'می تواند پیکربندی ثبت نام برای نوع عمل نمی %s',
        'Could not get backend for %s %s' => 'می تواند باطن برای دریافت %s %s',
        'Could not update configuration data for WebserviceID %s' => 'می تواند داده های پیکربندی برای WebserviceID به روز رسانی کنید %s',
        'Keep (leave unchanged)' => 'نگه دارید (ترک بدون تغییر)',
        'Ignore (drop key/value pair)' => 'نادیده گرفتن (کلید قطره / جفت ارزش)',
        'Map to (use provided value as default)' => 'نقشه به (استفاده ارائه ارزش به عنوان پیش فرض)',
        'Exact value(s)' => 'مقدار دقیق (بازدید کنندگان)',
        'Ignore (drop Value/value pair)' => 'نادیده گرفتن (رها ارزش جفت / ارزش)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'Could not find required library %s' => 'نمی توانید کتابخانه مورد نیازرا پیدا کنید %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Need OperationType' => 'نیاز OperationType',
        'Operation %s is not registered' => 'عملیات %s ثبت نشده است',
        'OperationType %s is not registered' => 'OperationType %s ثبت نشده است',
        'Need Operation' => 'نیاز به عمل جراحی است',
        'Could not determine config for operation %s' => 'می تواند پیکربندی برای عملیات مشخص نیست %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need Subaction!' => 'نیاز Subaction!',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'یکی دیگر از خدمات وب سایت با همین نام وجود دارد.',
        'There was an error updating the web service.' => 'خطایی در به روزرسانی وب سرویس وجود دارد.',
        'Web service "%s" updated!' => 'وب سرویس \ " %s " به روز شده!',
        'There was an error creating the web service.' => 'خطایی در ایجاد وب سرویس وجود دارد.',
        'Web service "%s" created!' => 'وب سرویس \ " %s " ایجاد شده است!',
        'Need Name!' => 'نیاز به نام!',
        'Need ExampleWebService!' => 'نیاز ExampleWebService!',
        'Could not read %s!' => 'قادر به خواندن نیست %s !',
        'Need a file to import!' => 'نیاز به یک فایل برای دریافت است .',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'فایل وارد شده است محتوای YAML معتبر نیست! لطفا وارد سیستم شوید OTRS برای جزئیات بیشتر',
        'Web service "%s" deleted!' => 'وب سرویس \ " %s " حذف!',
        'New Web service' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'کردم هیچ WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'می تواند داده های تاریخ برای WebserviceHistoryID نیست %s',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Notification updated!' => 'اطلاع رسانی به روز شده!',
        'Notification added!' => 'اطلاع رسانی اضافه شده است!',
        'There was an error getting data for Notification with ID:%s!' =>
            'یک خطای گرفتن داده برای هشدار  با ID وجود دارد: %s !',
        'Unknown Notification %s!' => 'هشدار نامشخص  از طریق %s !',
        'There was an error creating the Notification' => 'خطایی در ایجاد هشدار  وجود دارد',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'اطلاعیه نمی تواند به دلیل یک خطای ناشناخته وارد شود، لطفا OTRS سیاهه های مربوط را بررسی کنید برای اطلاعات بیشتر',
        'The following Notifications have been added successfully: %s' =>
            'این اعلانها با موفقیت اضافه شده است: %s',
        'The following Notifications have been updated successfully: %s' =>
            'این اعلانها  با موفقیت به روز شده است: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'وجود دارد که در آن خطاهای اضافه کردن / به روز رسانی اطلاعیه زیر است: %s . لطفا ورود به سیستم فایل برای اطلاعات بیشتر.',
        'Agent who owns the ticket' => 'عامل کسیکه صاحب درخواست',
        'Agent who is responsible for the ticket' => 'عامل کسیکه مسئول درخواست است',
        'All agents watching the ticket' => 'تمام عوامل تماشای درخواست',
        'All agents with write permission for the ticket' => 'همه عوامل با مجوز نوشتن درخواست برای',
        'All agents subscribed to the ticket\'s queue' => 'تمام عوامل مشترک به صف درخواست',
        'All agents subscribed to the ticket\'s service' => 'تمام عوامل مشترک خدمات درخواست',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'تمام عوامل مشترک به هر دو صف و خدمات درخواست',
        'Customer of the ticket' => 'ضوابط درخواست',
        'Yes, but require at least one active notification method' => 'بله، اما نیاز به حداقل یک روش اطلاع رسانی فعال هست',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'محیط زیست PGP کار نمی کند. لطفا وارد سیستم شوید برای اطلاعات بیشتر ',
        'Need param Key to delete!' => 'نیاز کلید param را حذف کنید!',
        'Key %s deleted!' => 'کلید %s حذف!',
        'Need param Key to download!' => 'نیاز کلید param برای دانلود!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            'با عرض پوزش، آپاچی :: بازنگری به عنوان PerlModule و PerlInitHandler در فایل پیکربندی آپاچی مورد نیاز است. همچنین نگاه اسکریپت / apache2 را-httpd.include.conf. متناوبا، شما می توانید از دستور ابزار خط بن / otrs.Console.pl برای نصب بستههای استفاده کنید!',
        'No such package!' => 'بدون چنین بسته!',
        'No such file %s in package!' => 'بدون چنین فایل %s در بسته!',
        'No such file %s in local file system!' => 'بدون چنین فایلی  %s در فایل سیستم محلی!',
        'Can\'t read %s!' => 'نمی تواند بخواند %s !',
        'File is OK' => 'فایل خوب است',
        'Package has locally modified files.' => 'بسته بندی به صورت محلی فایل های اصلاح شده.',
        'No packages or no new packages found in selected repository.' =>
            'هیچ بسته و یا بدون بسته های جدید در مخزن انتخاب شده است.',
        'Package not verified due a communication issue with verification server!' =>
            'بسته بندی با توجه به یک موضوع ارتباط با سرور تأیید، تأیید نمی کند!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'نمی توانید به OTRS ویژگی اضافه کردن در لیست سرور اتصال!',
        'Can\'t get OTRS Feature Add-on list from server!' => 'نمی توانید OTRS ویژگی اضافه کردن در لیست از سرور دریافت کنید!',
        'Can\'t get OTRS Feature Add-on from server!' => 'نمی توانید ویژگی OTRS افزودنی از سرور!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'بدون چنین فیلتر: %s',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Need ExampleProcesses!' => 'نیاز ExampleProcesses!',
        'Need ProcessID!' => 'نیاز ProcessID!',
        'Yes (mandatory)' => 'بله (اجباری)',
        'Unknown Process %s!' => 'فرایند ناشناخته %s !',
        'There was an error generating a new EntityID for this Process' =>
            'یک خطای تولید یک EntityID جدید برای این فرایند وجود دارد',
        'The StateEntityID for state Inactive does not exists' => 'StateEntityID برای حالت غیر فعال وجود ندارد',
        'There was an error creating the Process' => 'خطایی در ایجاد این فرآیند وجود دارد',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'خطا در تنظیم وضعیت همگام نهاد برای نهاد فرآیند وجود دارد: %s',
        'Could not get data for ProcessID %s' => 'نمی تواند داده ها را برای ProcessID بگیرد %s',
        'There was an error updating the Process' => 'خطایی در به روزرسانی این فرآیند وجود دارد',
        'Process: %s could not be deleted' => 'فرآیند: %s نمی تواند حذف شود',
        'There was an error synchronizing the processes.' => 'یک خطای هماهنگ سازی فرآیند وجود دارد.',
        'The %s:%s is still in use' => '%s : %s هنوز هم مورد استفاده',
        'The %s:%s has a different EntityID' => '%s : %s مختلف EntityIDدارد',
        'Could not delete %s:%s' => 'نمیتوان حذف کرد %s : %s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'خطا در تنظیم وضعیت همگام نهاد وجود دارد %s نهاد: %s',
        'Could not get %s' => 'نمی تواند بگیرد%s',
        'Need %s!' => 'نیاز %s !',
        'Process: %s is not Inactive' => 'فرآیند: %sغیر فعال نیست',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'یک خطای تولید  EntityID جدید برای این فعالیت وجود دارد',
        'There was an error creating the Activity' => 'خطایی در ایجاد فعالیت وجود دارد',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'خطا در تنظیم وضعیت همگام نهاد برای نهاد فعالیت وجود دارد: %s',
        'Need ActivityID!' => 'نیاز ActivityID!',
        'Could not get data for ActivityID %s' => 'نمی تواند داده ها را برای ActivityID بگیرد %s',
        'There was an error updating the Activity' => 'خطایی هنگام فعالیت به روزرسانی وجود دارد',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'پارامتر: نیاز فعالیت و ActivityDialog!',
        'Activity not found!' => 'فعالیت یافت نشد!',
        'ActivityDialog not found!' => 'ActivityDialog یافت نشد!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActivityDialog در حال حاضر به فعالیت اختصاص داده است. شما نمی توانید ActivityDialog اضافه دو بار!',
        'Error while saving the Activity to the database!' => 'خطا در هنگام ذخیره فعالیت ها به پایگاه داده!',
        'This subaction is not valid' => 'این subaction معتبر نیست',
        'Edit Activity "%s"' => 'ویرایش فعالیت \ " %s "',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'یک خطای تولید  EntityID جدید برای این ActivityDialog وجود دارد',
        'There was an error creating the ActivityDialog' => 'یک خطای ایجاد ActivityDialog وجود دارد',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'خطا در تنظیم نهاد وضعیت همگام برای نهاد ActivityDialog وجود دارد: %s',
        'Need ActivityDialogID!' => 'نیاز ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'نمی تواند داده ها را برای ActivityDialogIDبگیرد %s',
        'There was an error updating the ActivityDialog' => 'یک خطای به روز رسانی ActivityDialog وجود دارد',
        'Edit Activity Dialog "%s"' => 'ویرایش فعالیت گفت و گو \ " %s "',
        'Agent Interface' => 'رابط عامل',
        'Customer Interface' => 'رابط مشتری',
        'Agent and Customer Interface' => 'عامل و  رابط مشتری',
        'Do not show Field' => 'زمینه را درست نشان نمی دهد ',
        'Show Field' => 'نمایش زمینه',
        'Show Field As Mandatory' => 'نمایش زمینه به عنوان اجباری',
        'fax' => 'فکس',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'ویرایش مسیر',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'یک خطای تولید  EntityID جدید برای این انتقال وجود دارد',
        'There was an error creating the Transition' => 'خطایی در ایجاد انتقال وجود دارد',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'خطا در تنظیم نهاد وضعیت همگام برای نهاد گذار وجود دارد: %s',
        'Need TransitionID!' => 'نیاز TransitionID!',
        'Could not get data for TransitionID %s' => 'نمی تواند داده ها را برای TransitionID گرفت %s',
        'There was an error updating the Transition' => 'خطایی هنگام انتقال وجود دارد',
        'Edit Transition "%s"' => 'ویرایش گذار \ " %s "',
        'xor' => 'XOR',
        'String' => 'String',
        'Transition validation module' => 'انتقال ماژول اعتبار سنجی',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'حداقل یک پارامتر پیکربندی معتبر مورد نیاز است.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'یک خطای تولید یک EntityID جدید برای این TransitionAction وجود دارد',
        'There was an error creating the TransitionAction' => 'یک خطای ایجاد TransitionAction وجود دارد',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'خطا در تنظیم نهاد وضعیت همگام برای نهاد TransitionAction وجود دارد: %s',
        'Need TransitionActionID!' => 'نیاز TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'نمی تواند داده ها را برای TransitionActionID\'گرفت %s',
        'There was an error updating the TransitionAction' => 'یک خطای به روز رسانی TransitionAction وجود دارد',
        'Edit Transition Action "%s"' => 'ویرایش انتقال اقدام \ " %s "',
        'Error: Not all keys seem to have values or vice versa.' => 'خطا: همه کلید به نظر می رسد ارزش و یا بالعکس.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Don\'t use :: in queue name!' => 'استفاده نکنید :: در نام صف!',
        'Click back and change it!' => ' کلیک بک کنید و آن را تغییر دهید!',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'صف (بدون پاسخ خودکار)',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'محیط زیست S / MIME کار نمی کند. لطفا وارد سیستم شوید برای اطلاعات بیشتر بررسی کنید!',
        'Need param Filename to delete!' => 'نیاز نام فایل PARAM را حذف کنید!',
        'Need param Filename to download!' => 'نیاز نام فایل PARAM برای دانلود!',
        'Needed CertFingerprint and CAFingerprint!' => 'مورد نیاز CertFingerprint و CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint باید از CertFingerprint متفاوت باشد',
        'Relation exists!' => 'رابطه وجود دارد!',
        'Relation added!' => 'رابطه اضافه شده است!',
        'Impossible to add relation!' => 'اضافه کردن رابطه غیر ممکن است  !',
        'Relation doesn\'t exists' => 'رابطه  وجود ندارد',
        'Relation deleted!' => 'حذف رابطه !',
        'Impossible to delete relation!' => '  حذف رابطه غیر ممکن است!',
        'Certificate %s could not be read!' => 'گواهی %s نمی تواند خوانده شود!',
        'Needed Fingerprint' => 'اثر انگشت مورد نیاز',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation updated!' => 'سلام به روز شده!',
        'Salutation added!' => 'سلام اضافه شده است!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'فایل %s نمی تواند بخواند!',

        # Perl Module: Kernel/Modules/AdminSysConfig.pm
        'Import not allowed!' => 'دریافت مجاز نیست!',
        'Need File!' => 'نیاز فایل!',
        'Can\'t write ConfigItem!' => 'نمی توانید ConfigItem بنویسید !',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'نباید تاریخ شروع  پس از تاریخ توقف تعریف  شود!',
        'There was an error creating the System Maintenance' => 'خطایی در ایجاد تعمیر و نگهداری سیستم وجود دارد',
        'Need SystemMaintenanceID!' => 'نیاز SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'نمی تواند داده ها را برای SystemMaintenanceID گرفت %s',
        'System Maintenance was saved successfully!' => 'تعمیر و نگهداری سیستم موفقیت ذخیره شد!',
        'Session has been killed!' => 'جلسه کشته شده است!',
        'All sessions have been killed, except for your own.' => 'تمام جلسات کشته شده اند، به جز خود شما.',
        'There was an error updating the System Maintenance' => 'خطایی هنگام تعمیر و نگهداری سیستم وجود دارد',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'بود ممکن است برای حذف ورود SystemMaintenance نه: %s !',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'الگو به روز شده!',
        'Template added!' => 'قالب اضافه شده است!',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'نیاز تایپ!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'چنین پیکربندی برای %s',
        'Statistic' => 'آمار',
        'No preferences for %s!' => 'هیچ تنظیمات برای %s !',
        'Can\'t get element data of %s!' => 'نمی توانید داده های عنصررا بگیرید %s !',
        'Can\'t get filter content data of %s!' => 'نمی توانید داده ها محتوای فیلتر را بگیرید  %s !',
        'Customer Company Name' => '',
        'Customer User ID' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'نیاز SourceObject و SourceKey!',
        'Please contact the administrator.' => 'لطفا با مدیر تماس بگیرید.',
        'You need ro permission!' => 'شما نیاز RO اجازه!',
        'Can not delete link with %s!' => 'نمی توانید لینک را حذف کنید با %s !',
        'Can not create link with %s! Object already linked as %s.' => 'نمی توانید لینک را ایجاد کنید با%s ! جسم در حال حاضر به عنوان مرتبط %s .',
        'Can not create link with %s!' => 'نمی توانید لینک را ایجاد کنید %s !',
        'The object %s cannot link with other object!' => 'هدف %s نمی تواند با جسم دیگر  لینک شود!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'PARAM گروه مورد نیاز است!',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'پارامتر %s از دست رفته است.',
        'Invalid Subaction.' => 'Subaction نامعتبر است.',
        'Statistic could not be imported.' => 'آمار نمی تواند وارد شود.',
        'Please upload a valid statistic file.' => 'لطفا یک فایل آمار معتبر آپلود کنید.',
        'Export: Need StatID!' => 'ارسال: نیاز StatID!',
        'Delete: Get no StatID!' => 'حذف: مطلع هیچ StatID!',
        'Need StatID!' => 'نیاز StatID!',
        'Could not load stat.' => 'آمار نمی تواند بارگزاری شود .',
        'Could not create statistic.' => 'نمی توانید آمار ایجاد کنید.',
        'Run: Get no %s!' => 'اجرا: دریافت هیچ %s !',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'بدون TicketID داده شده است!',
        'You need %s permissions!' => 'شما نیاز %s مجوز!',
        'Could not perform validation on field %s!' => 'نمی تواند اعتبار سنجی در زمینه انجام شود  %s !',
        'No subject' => 'بدون موضوع',
        'Previous Owner' => 'صاحب قبلی',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s مورد نیاز است!',
        'Plain article not found for article %s!' => 'مقاله ساده برای مقاله یافت نشد %s !',
        'Article does not belong to ticket %s!' => 'مقاله به درخواست تعلق ندارد %s !',
        'Can\'t bounce email!' => 'نمی توانید از ایمیل بپرید !',
        'Can\'t send email!' => 'نمی توانید ایمیل ارسال کنید!',
        'Wrong Subaction!' => 'Subaction اشتباه است!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'نمی توانید درخواست را قفل کنید، هیچ TicketIDs داده نمی شود!',
        'Ticket (%s) is not unlocked!' => 'درخواست  ( %s )باز نشده است .',
        'Bulk feature is not enabled!' => 'از ویژگی های فله فعال نیست!',
        'No selectable TicketID is given!' => 'بدون TicketID انتخاب داده شده است!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'شما هم بدون بلیط و یا فقط بلیط که توسط عوامل دیگر قفل شده انتخاب شده است.',
        'You need to select at least one ticket.' => 'شما نیاز به انتخاب حداقل یک بلیط.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Can not determine the ArticleType!' => 'نمی توانید ArticleType مشخص کنید!',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'No Subaction!' => 'بدون Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'کردم هیچ TicketID!',
        'System Error!' => 'خطای سیستم!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Invalid Filter: %s!' => 'فیلتر نامعتبر: %s !',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'نمی تواند تاریخ را نشان دهد، هیچ TicketID داده نشده است!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'نمی توانید درخواست را قفل کنید، هیچ TicketID داده نشده است!',
        'Sorry, the current owner is %s!' => 'با عرض پوزش، مالک فعلی است %s !',
        'Please become the owner first.' => 'لطفا تبدیل شود به صاحب اول.',
        'Ticket (ID=%s) is locked by %s!' => 'درخواست (ID = %s ) توسط قفل شده %s !',
        'Change the owner!' => 'تغییر صاحب!',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'نمی توانید درخواست خود را با خودش ادغام کنید!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'شما نیاز به مجوز حرکت دارید !',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'چت غیر فعال است.',
        'No permission.' => 'بدون مجوز و اجازه.',
        '%s has left the chat.' => '%s چت را ترک کرده است.',
        'This chat has been closed and will be removed in %s hours.' => 'این چت بسته شده است و خواهد شد در حذف %s ساعت است.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'بدون ArticleID!',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'نمی توانید مقاله ساده را بخوانید! شاید هیچ ایمیل ساده ای در باطن وجود ندارد! خواندن پیام باطن.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'نیاز TicketID!',
        'printed by' => 'چاپ شده توسط  :',
        'Ticket Dynamic Fields' => 'درخواست زمینه  پویا',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'نمی تواند ActivityDialogEntityID \ "بگیرد %s "!',
        'No Process configured!' => 'هیچ فرآیندی پیکربندی نشده است!',
        'Process %s is invalid!' => 'روند %s نامعتبر است!',
        'Subaction is invalid!' => 'Subaction نامعتبر است!',
        'Parameter %s is missing in %s.' => 'پارامتر %s در از دست رفته %s .',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'بدون ActivityDialog پیکربندی شده برای %s در _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'کردم هیچ شروع ActivityEntityID یا Start ActivityDialogEntityID برای فرآیند: %s در _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => ': می تواند بلیط برای TicketID نیست %s در _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'نمی تواند ActivityEntityID  تعیین  کند. DynamicField یا پیکربندی شده است به درستی تنظیم نشده!',
        'Process::Default%s Config Value missing!' => 'فرآیند :: پیش فرض %s پیکربندی ارزش از دست رفته!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'کردم هیچ ProcessEntityID یا TicketID و ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'می توانید StartActivityDialog و StartActivityDialog شدن برای ProcessEntityID \ "نمی %s "!',
        'Can\'t get Ticket "%s"!' => 'نمی توانید بلیط \ "از %s "!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'نمی توانید ProcessEntityID یا ActivityEntityID برای درخواست  \ "بگیرید %s "!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'می توانید پیکربندی فعالیت برای ActivityEntityID \ "نمی %s "!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'می توانید پیکربندی ActivityDialog برای ActivityDialogEntityID \ "نمی %s "!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'می توانید داده ها را برای درست \ "نمی %s " از ActivityDialog \ " %s "!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime میتوانید از استفاده اگر دولت و یا StateID برای ActivityDialog همان پیکربندی شده است. ActivityDialog: %s !',
        'Pending Date' => 'مهلت تعلیق',
        'for pending* states' => 'برای حالات تعلیق',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID از دست رفته!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'می تواند پیکربندی برای ActivityDialogEntityID \ "نمی %s "!',
        'Couldn\'t use CustomerID as an invisible field.' => 'می تواند به عنوان یک CustomerID میدان نامرئی استفاده کنید.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'ازدست رفته ProcessEntityID،خود را ActivityDialogHeader.tt بررسی کنید !',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'بدون StartActivityDialog یا StartActivityDialog برای فرآیند \ " %s " پیکربندی شده است!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'نمی تواند درخواست برای فرآیند با ProcessEntityID \ "ایجاد کنید %s "!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'تنظیم نشد ProcessEntityID \ " %s " در TicketID \ " %s "!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'تنظیم نشد ActivityEntityID \ " %s " در TicketID \ " %s "!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'نمی تواند ActivityDialog، TicketID نامعتبر ذخیره شود: %s !',
        'Invalid TicketID: %s!' => 'TicketID نامعتبر: %s !',
        'Missing ActivityEntityID in Ticket %s!' => 'ازدست رفته ActivityEntityID در درخواست %s !',
        'This step does not belong anymore the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => 'از دست رفته ProcessEntityID دردرخواست %s !',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'می تواند ارزش DynamicField تنظیم نشده برای %s از بلیط با ID \ " %s " در ActivityDialog \ " %s "!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'می تواند PendingTime برای بلیط با ID \ "تنظیم نشده %s " در ActivityDialog \ " %s "!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'اشتباه ActivityDialog درست پیکربندی: %s نمی تواند نمایش => 1 نمایش درست / (لطفا تنظیمات آن را تغییر دهید به نمایش => 0 / هنوز درست و یا صفحه نمایش => 2 نشان دادن درست / به عنوان اجباری نشان نمی دهد).',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'تنظیم نشد %s برای بلیط با ID \ " %s " در ActivityDialog \ " %s "!',
        'Default Config for Process::Default%s missing!' => 'پیش فرض پیکربندی برای فرآیند :: پیش فرض %s از دست رفته!',
        'Default Config for Process::Default%s invalid!' => 'پیش فرض پیکربندی برای فرآیند :: پیش فرض %s نامعتبر است!',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Untitled' => 's',
        'Customer Name' => 'نام مشتری',
        'Invalid Users' => 'کاربر نامعتبر',
        'CSV' => 'CSV',
        'Excel' => 'اکسل',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'ویژگی فعال نیست!',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'ویژگی غیر فعال است',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'لینک های حذف شده',
        'Ticket Locked' => 'درخواست قفل شده',
        'Pending Time Set' => 'انتظار زمان تنظیم',
        'Dynamic Field Updated' => 'به روز رسانی زمینه پویا ',
        'Outgoing Email (internal)' => 'خروجی ایمیل (داخلی)',
        'Ticket Created' => ' ایجاد درخواست',
        'Type Updated' => 'نوع به روز رسانی',
        'Escalation Update Time In Effect' => 'تشدید اثر بروز رسانی در',
        'Escalation Update Time Stopped' => 'تشدید بروز رسانی متوقف',
        'Escalation First Response Time Stopped' => 'تشدید نخست زمان پاسخ توقف',
        'Customer Updated' => 'مشتری به روز شده',
        'Internal Chat' => 'چت داخلی',
        'Automatic Follow-Up Sent' => ' پیگیری ارسال خودکار',
        'Note Added' => 'توجه داشته باشید او',
        'Note Added (Customer)' => 'توجه داشته باشید او (مشتری)',
        'State Updated' => 'وضعیت به روز رسانی',
        'Outgoing Answer' => 'خروجی پاسخ',
        'Service Updated' => 'خدمات به روز شده',
        'Link Added' => 'لینک اضافه شده',
        'Incoming Customer Email' => 'ورودی ایمیل مشتری',
        'Incoming Web Request' => 'ورودی درخواست وب',
        'Priority Updated' => 'اولویت به روز رسانی',
        'Ticket Unlocked' => 'درخواست باز',
        'Outgoing Email' => 'خروجی ایمیل',
        'Title Updated' => 'عنوان به روز رسانی',
        'Ticket Merged' => 'درخواست ها با هم ادغام شدند',
        'Outgoing Phone Call' => 'تماس های تلفنی خروجی',
        'Forwarded Message' => 'پیام فرستاده شده',
        'Removed User Subscription' => 'حذف اشتراک کاربر',
        'Time Accounted' => 'زمان اختصاص',
        'Incoming Phone Call' => 'تماس تلفنی ورودی',
        'System Request.' => 'درخواست پاسخ به سیستم.',
        'Incoming Follow-Up' => ' پیگیری ورودی',
        'Automatic Reply Sent' => 'پاسخ به صورت خودکار فرستاده شده',
        'Automatic Reject Sent' => 'به صورت خودکار رد ارسال',
        'Escalation Solution Time In Effect' => 'تشدید راه حل زمان در اثر',
        'Escalation Solution Time Stopped' => 'تشدید راه حل زمان توقف',
        'Escalation Response Time In Effect' => 'تشدید اثر زمان پاسخ',
        'Escalation Response Time Stopped' => 'تشدید زمان پاسخ متوقف',
        'SLA Updated' => 'SLA به روز رسانی',
        'Queue Updated' => 'صف به روز رسانی',
        'External Chat' => 'چت خارجی',
        'Queue Changed' => 'صف تغییر',
        'Notification Was Sent' => 'اطلاع رسانی فرستاده شد',
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            'ما متاسفیم، شما اجازه ندارد دیگر برای دسترسی به این بلیط در وضعیت فعلی آن است.',
        'Can\'t get for ArticleID %s!' => ' نمی توانم بگیرم ArticleID از %s !',
        'Article filter settings were saved.' => 'تنظیمات فیلتر مقاله ذخیره شدند.',
        'Event type filter settings were saved.' => 'تنظیمات فیلتر نوع رویداد ذخیره شدند.',
        'Need ArticleID!' => 'نیاز ArticleID!',
        'Invalid ArticleID!' => 'ArticleID نامعتبر است!',
        'Offline' => 'آفلاین',
        'User is currently offline.' => 'کاربر در حال حاضر آفلاین.',
        'User is currently active.' => 'کاربر در حال حاضر فعال است.',
        'Away' => 'دور',
        'User was inactive for a while.' => 'کاربر غیر فعال در حالی که برای بود.',
        'Unavailable' => 'در دسترس نیست',
        'User set their status to unavailable.' => 'کاربر وضعیت خود را به در دسترس تنظیم شده است.',
        'Fields with no group' => 'رشته های بی گروه',
        'View the source for this Article' => 'مشاهده منبع برای این مقاله',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileID و ArticleID مورد نیاز است!',
        'No TicketID for ArticleID (%s)!' => 'بدون TicketID برای ArticleID ( %s )!',
        'No such attachment (%s)!' => 'چنین ضمیمه  ( %s )!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'بررسی SysConfig تنظیم برای %s :: QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'بررسی SysConfig تنظیم برای %s :: TicketTypeDefault.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'نیاز CustomerID!',
        'My Tickets' => 'درخواست‌های من',
        'Company Tickets' => 'درخواست‌های سازمانی/شرکتی',
        'Untitled!' => 's',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            'لطفا کلمات زیر را حذف کنید زیرا آنها نمی توانند برای جستجو استفاده  شوند:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'نمی توانید درخواست را بازگشایی کنید، در این صف ممکن نیست !',
        'Create a new ticket!' => 'یک درخواست جدید ایجاد کنید!',

        # Perl Module: Kernel/Modules/Installer.pm
        'Directory "%s" doesn\'t exist!' => 'راهنمای \ " %s " وجود ندارد!',
        'Configure "Home" in Kernel/Config.pm first!' => 'پیکربندی \ "خانه " در هسته / Config.pm برای اولین بار!',
        'File "%s/Kernel/Config.pm" not found!' => 'فایل \ " %s /Kernel/Config.pm " یافت نشد!',
        'Directory "%s" not found!' => 'راهنمای \ " %s " یافت نشد!',
        'Kernel/Config.pm isn\'t writable!' => 'هسته / Config.pm قابل نوشتن نیست!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'اگر شما می خواهید به استفاده از نصب، قابل نوشتن هسته / Config.pm برای کاربران وب سرور مجموعه!',
        'Unknown Check!' => 'بررسی ناشناخته!',
        'The check "%s" doesn\'t exist!' => 'چک \ " %s " وجود ندارد!',
        'Database %s' => 'پایگاه های داده بسیار بزرگ به دست می آید .',
        'Configure MySQL' => '',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => 'نامشخص نوع پایگاه داده \ " %s ".',
        'Please go back.' => 'لطفا برگردید.',
        'Install OTRS - Error' => 'نصب OTRS - خطا',
        'File "%s/%s.xml" not found!' => 'فایل \ " %s / %s .XML " یافت نشد!',
        'Contact your Admin!' => 'تماس با مدیریت خود !',
        'Syslog' => '',
        'Can\'t write Config file!' => 'نمی توانید بنویسید، فایل پیکربندی شده است!',
        'Unknown Subaction %s!' => 'نامشخص Subaction %s !',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'نمی توانید به پایگاه داده متصل شوید، پرل و DBD :: %s نصب نشده است!',
        'Can\'t connect to database, read comment!' => 'نمی توانید به پایگاه داده متصل شوید، به عنوان خواننده نظر!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'خطا: لطفا مطمئن شوید که پایگاه داده خود را بسته بر می پذیرد %s MB در اندازه (در حال حاضر تنها بسته می پذیرد تا %s MB). لطفا تنظیمات max_allowed_packet از پایگاه داده خود را به منظور جلوگیری از اشتباهات وفق دهند.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'خطا: لطفا مقدار را برای innodb_log_file_size در پایگاه داده خود را به حداقل مجموعه %s (: در حال حاضر MB %s MB، توصیه می شود: %s MB). برای کسب اطلاعات بیشتر، لطفا یک نگاهی به %s .',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'نیاز بسته بندی پیکربندی :: RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'احراز هویت از %s !',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Sent message crypted to recipient!' => 'پیام های ارسال شده به گیرنده crypted!',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '\ "PGP امضا پیام " هدر پیدا شده است، اما نامعتبر است!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '\ "S / MIME امضا پیام " هدر پیدا شده است، اما نامعتبر است!',
        'Ticket decrypted before' => 'درخواست رمزگشایی قبل',
        'Impossible to decrypt: private key for email was not found!' => 'غیر ممکن است برای رمزگشایی: کلید خصوصی برای ایمیل یافت نشد!',
        'Successful decryption' => 'رمزگشایی موفق',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'زمان شروع یک درخواست پس از زمان پایان تنظیم  شده است!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => 'نمی توانید به سرور OTRS اخبار اتصال!',
        'Can\'t get OTRS News from server!' => 'می توانید OTRS اخبار از سرور دریافت کنید!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'نمی توانید به سرور اخبار محصولات اتصال!',
        'Can\'t get Product News from server!' => 'می توانید محصولات اخبار از سرور دریافت کنید!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'نمی توانید به اتصال %s !',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'sorted ascending' => 'مرتب شده صعودی',
        'sorted descending' => 'مرتب شده نزولی',
        'filter not active' => 'فیلتر فعال است',
        'filter active' => 'فیلتر فعال',
        'This ticket has no title or subject' => 'این بلیط هیچ عنوان یا موضوعی ندارد',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:' =>
            'ما متاسفیم، شما  دیگر برای دسترسی به این درخواست در وضعیت فعلی آن  اجازه ندارید. شما می توانید یکی از اقدامات زیر را انجام دهید:',
        'No Permission' => 'بدون مجوز و اجازه',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'مرتبط به عنوان',
        'Search Result' => 'نتیجه جستجو',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'بایگانی جستجو',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s ارتقا به %s در حال حاضر! %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => 'دوره تعمیر و نگهداری سیستم شروع خواهد شد در: ',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(در حال انجام)',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'لطفا مطمئن شوید که شما حداقل یک روش حمل و نقل برای اطلاعیه اجباری را انتخاب کرده ایم.',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'لطفا تاریخ پایان است که بعد از تاریخ شروع را مشخص کنید.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => 'لطفا رمز عبور جدید خود را عرضه کنید!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No (not supported)' => 'هیچ (پشتیبانی نمی شود)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'هیچ گذشته کامل و یا جاری + آینده کامل نسبت ارزش زمانی انتخاب شده است.',
        'The selected time period is larger than the allowed time period.' =>
            'دوره زمانی انتخاب شده بزرگتر از مدت زمان مجاز است.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'هیچ وقت ارزش در مقیاس موجود برای جریان انتخاب زمان ارزش مقیاس در محور X. نیست',
        'The selected date is not valid.' => 'تاریخ انتخاب شده معتبر نمی باشد.',
        'The selected end time is before the start time.' => 'انتخاب پایان زمان پیش از زمان آغاز است.',
        'There is something wrong with your time selection.' => 'مشکلی با انتخاب زمان شما وجود دارد.',
        'Please select only one element or allow modification at stat generation time.' =>
            'لطفا تنها یک عنصر را انتخاب کنید و یا اجازه اصلاح در زمان نسل آماررا بدهید .',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'لطفا حداقل یک مقدار این فیلد را انتخاب کنید و یا اجازه اصلاح در زمان نسل آمار را بدهید.',
        'Please select one element for the X-axis.' => 'لطفا یک عنصر برای محور X را انتخاب کنید.',
        'You can only use one time element for the Y axis.' => 'شما فقط می توانید برای محور Y از یک عنصر زمان استفاده کنید. ',
        'You can only use one or two elements for the Y axis.' => 'شما فقط می توانید یک یا دو عنصر برای محور Y استفاده کنید.',
        'Please select at least one value of this field.' => 'لطفا حداقل یک مقدار این فیلد را انتخاب کنید.',
        'Please provide a value or allow modification at stat generation time.' =>
            'لطفا یک مقدار را فراهم و یا اجازه اصلاح در زمان نسل آمار.',
        'Please select a time scale.' => 'لطفا یک مقیاس زمانی را انتخاب کنید.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'فاصله زمانی گزارش خود را بیش از حد کوچک است، لطفا با استفاده از یک مقیاس زمانی بزرگتر است.',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'لطفا کلمات زیر حذف زیرا آنها می توانند برای محدودیت بلیط مورد استفاده قرار گیرد: %s .',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'مرتب‌سازی بر اساس',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            'شما بیش از تعدادی از عوامل همزمان - تماس sales@otrs.com.',
        'Please note that the session limit is almost reached.' => 'لطفا توجه داشته باشید که حد جلسه است که تقریبا رسیده است.',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            'ورود را رد کرد! شما از حداکثر تعدادی از عوامل همزمان! تماس با sales@otrs.com بلافاصله!',
        'Session per user limit reached!' => 'جلسه در حد کاربران رسیده!',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'گزینه های پیکربندی مرجع',
        'This setting can not be changed.' => 'این تنظیم نمی تواند تغییر کند.',
        'This setting is not active by default.' => 'این تنظیم به طور پیش فرض فعال است.',
        'This setting can not be deactivated.' => 'این تنظیمات نمی تواند غیر فعال  شود.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'نصب نشده',
        'File is not installed!' => 'فایل نصب نشده است!',
        'File is different!' => 'فایل متفاوت است!',
        'Can\'t read file!' => 'نمی توانید فایل خوانده شده!',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'غیر فعال',
        'FadeAway' => 'ناپدید شدن',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t get Token from sever' => 'نمی توانید رمز از Sever بگیرید',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'جمع',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'نوع حالت',
        'Created Priority' => 'اولویت ایجاد',
        'Created State' => 'وضعیت ایجاد',
        'Create Time' => 'زمان ایجاد ',
        'Close Time' => 'زمان بسته شدن',
        'Escalation - First Response Time' => 'تشدید -  زمان اولین پاسخ',
        'Escalation - Update Time' => 'تشدید - به روز رسانی زمان',
        'Escalation - Solution Time' => 'تشدید - راه حل زمان',
        'Agent/Owner' => 'کارشناس/صاحب',
        'Created by Agent/Owner' => 'ایجاد شده توسط کارشناس/صاحب',
        'CustomerUserLogin' => 'نام کاربری مشترک',
        'CustomerUserLogin (complex search)' => 'CustomerUserLogin (جستجوی پیچیده)',
        'CustomerUserLogin (exact match)' => 'CustomerUserLogin (مطابقت دقیق)',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'ارزیابی شده به وسیله',
        'Ticket/Article Accounted Time' => 'زمان محاسبه شده برای درخواست/نوشته',
        'Ticket Create Time' => 'زمان ایجاد درخواست',
        'Ticket Close Time' => 'زمان بسته شدن درخواست',
        'Accounted time by Agent' => 'زمان محاسبه شده توسط کارشناس',
        'Total Time' => 'کل زمان‌ها',
        'Ticket Average' => 'میانگین درخواست',
        'Ticket Min Time' => 'حداقل زمان درخواست',
        'Ticket Max Time' => 'حداکثر زمان درخواست',
        'Number of Tickets' => 'تعداد درخواست‌ها',
        'Article Average' => 'میانگین نوشته',
        'Article Min Time' => 'حداقل زمان نوشته',
        'Article Max Time' => 'حداکثر زمان نوشته',
        'Number of Articles' => 'تعداد نوشته‌ها',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'نا محدود',
        'ascending' => 'صعودی',
        'descending' => 'نزولی',
        'Attributes to be printed' => 'خواصی که قرار است چاپ شوند',
        'Sort sequence' => 'توالی ترتیب',
        'State Historic' => 'تاریخی ایالتی',
        'State Type Historic' => 'نوع تاریخی ایالتی',
        'Historic Time Range' => 'تاریخی محدوده زمانی',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'راه حل میانگین',
        'Solution Min Time' => 'راه حل حداقل زمان',
        'Solution Max Time' => 'راه حل حداکثر زمان',
        'Solution Average (affected by escalation configuration)' => 'راه حل میانگین (متاثر از پیکربندی تشدید)',
        'Solution Min Time (affected by escalation configuration)' => 'راه حل حداقل زمان (متاثر از پیکربندی تشدید)',
        'Solution Max Time (affected by escalation configuration)' => 'راه حل حداکثر زمان (متاثر از پیکربندی تشدید)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'راه حل زمان کار میانگین (متاثر از پیکربندی تشدید)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'راه حل حداقل زمان کار (متاثر از پیکربندی تشدید)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'راه حل حداکثر زمان کار (متاثر از پیکربندی تشدید)',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => 'تعداد درخواست (متاثر از پیکربندی تشدید)',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'روزها',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'حضور جدول',
        'Internal Error: Could not open file.' => 'خطای داخلی: فایل باز نمی شود.',
        'Table Check' => 'جدول بررسی',
        'Internal Error: Could not read file.' => 'خطای داخلی: فایل خوانده نشد.',
        'Tables found which are not present in the database.' => 'استفاده از جدول موجود که در حال حاضر در پایگاه داده است.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'اندازه پایگاه داده',
        'Could not determine database size.' => ' اندازه پایگاه داده مشخص نیست.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'نسخه پایگاه داده',
        'Could not determine database version.' => ' نسخه پایگاه داده مشخص نیست.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'اتصال مشتری نویسهگان',
        'Setting character_set_client needs to be utf8.' => 'تنظیم character_set_client نیاز به UTF8 باشد.',
        'Server Database Charset' => 'سرور مجموعه کاراکتر پایگاه',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'تنظیم character_set_database نیاز به UNICODE یا UTF8.',
        'Table Charset' => 'جدول مجموعه کاراکتر',
        'There were tables found which do not have utf8 as charset.' => ' جداولی پیدا شده است که UTF8 به عنوان مجموعه کاراکتر وجود ندارد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'سازی InnoDB ورود حجم فایل',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'innodb_log_file_size تنظیم باید حداقل 256 مگابایت باشد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'حداکثر اندازه پرس و جو',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'تنظیمات \'max_allowed_packet باید بالاتر از 20 مگابایت باشد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'جستجوهای کش اندازه',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'تنظیمات \'query_cache_size باید استفاده شود (بالاتر از 10 مگابایت اما نه بیش از 512 مگابایت).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'موتور ذخیره سازی پیش فرض',
        'Table Storage Engine' => ' موتور ذخیره سازی جدول',
        'Tables with a different storage engine than the default engine were found.' =>
            'جداول با یک موتور ذخیره سازی متفاوت با موتور به طور پیش فرض پیدا شد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '5.x خروجی زیر و یا بالاتر مورد نیاز است.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'تنظیم NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG باید تنظیم شود تا al32utf8 (به عنوان مثال GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'تنظیم NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT باید روی ": MI: SS YYYY-MM-DD HH24، تنظیم شده است.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT تنظیم SQL بررسی',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'تنظیم client_encoding نیاز به UNICODE یا UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'تنظیم server_encoding نیاز به UNICODE یا UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'فرمت تاریخ',
        'Setting DateStyle needs to be ISO.' => 'تنظیم DateStyle نیاز به ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => '8.X PostgreSQL یا بالاتر مورد نیاز است.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'پارتیشن OTRS دیسک',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'کاربرد دیسک',
        'The partition where OTRS is located is almost full.' => 'پارتیشن که در آن واقع شده است OTRS تقریبا کامل است.',
        'The partition where OTRS is located has no disk space problems.' =>
            'پارتیشن که در آن واقع شده است OTRS هیچ مشکلی روی هارد دیسک ندارد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'دیسک پارتیشن طریقه استفاده',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'توزیع می کند.',
        'Could not determine distribution.' => 'نمی تواند توزیع مشخص کند.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'نسخه اصلی',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'بارگزاری سیستم',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'بار سیستم باید در حداکثر تعداد CPU سیستم (به عنوان مثال یک بار از 8 یا کمتر در یک سیستم با پردازنده 8 خوب است) باشد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'ماژول پرل',
        'Not all required Perl modules are correctly installed.' => 'همه ماژول های مورد نیاز پرل به درستی نصب نشده است.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'فضای swap خالی (٪)',
        'No swap enabled.' => ' مبادله را فعال نکنید.',
        'Used Swap Space (MB)' => 'فضای مبادله استفاده شده (MB)',
        'There should be more than 60% free swap space.' => 'باید بیش از 60٪ فضای swap رایگان وجود داشته باشد.',
        'There should be no more than 200 MB swap space used.' => 'باید فضای swap بیش از 200 MB مورد استفاده وجود داشته باشد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS' => 'OTRS',
        'Config Settings' => 'تنظیمات پیکربندی',
        'Could not determine value.' => 'نمی تواند ارزش را تعیین  کند.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'سرویس',
        'Daemon is running.' => 'شبح در حال اجرا است.',
        'Daemon is not running.' => 'سرویس در حال اجرا نیست.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => 'سوابق پایگاه داده',
        'Tickets' => 'درخواست‌ها',
        'Ticket History Entries' => 'درخواست تاریخچه مطالب',
        'Articles' => 'مقالات',
        'Attachments (DB, Without HTML)' => 'فایل های پیوست (DB، بدون HTML)',
        'Customers With At Least One Ticket' => 'مشتریان با حداقل یک درخواست',
        'Dynamic Field Values' => 'مقادیر فیلد پویا',
        'Invalid Dynamic Fields' => ' زمینه های پویا نامعتبر',
        'Invalid Dynamic Field Values' => 'ارزش فیلد پویا نامعتبر',
        'GenericInterface Webservices' => 'GenericInterface webservices های',
        'Process Tickets' => 'بلیط روند',
        'Months Between First And Last Ticket' => 'ماهها از اولین تا  آخرین درخواست',
        'Tickets Per Month (avg)' => 'درخواست در هر ماه (AVG)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'به طور پیش فرض SOAP نام کاربری و رمز',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'خطر امنیتی:  با استفاده از تنظیمات پیش فرض برای SOAP :: کاربر و SOAP :: رمز عبور. لطفا آن را تغییر دهید.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'به طور پیش فرض کلمه عبور کاربر admin',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'خطر امنیتی: حساب عامل ریشه @ localhost را هنوز رمز عبور به طور پیش فرض. لطفا آن را تغییر دهید و یا از درجه اعتبار ساقط حساب.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ErrorLog.pm
        'Error Log' => 'ورود به خطا',
        'There are error reports in your system log.' => 'گزارش خطا در ورود به سیستم شما وجود دارد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (نام دامنه)',
        'Please configure your FQDN setting.' => 'لطفا تنظیمات FQDN خود را پیکربندی کنید.',
        'Domain Name' => 'نام دامنه',
        'Your FQDN setting is invalid.' => 'تنظیم FQDN شما نامعتبر است.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'سیستم فایل قابل نوشتن',
        'The file system on your OTRS partition is not writable.' => 'سیستم فایل در پارتیشن OTRS  قابل نوشتن نیست.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'وضعیت بسته نصب و راه اندازی',
        'Some packages have locally modified files.' => 'برخی از بسته های به صورت محلی فایل ها اصلاح شده.',
        'Some packages are not correctly installed.' => 'برخی از بسته ها به درستی نصب نشده است.',
        'Package Verification Status' => 'وضعیت بسته تأیید',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            'برخی از بسته های توسط گروه OTRS تایید نشده است! توصیه می شود برای استفاده از این بسته نیست.',
        'Package Framework Version Status' => 'بسته بندی Framework نسخه وضعیت',
        'Some packages are not allowed for the current framework version.' =>
            'برخی از بسته های برای نسخه چارچوب فعلی مجاز نیست.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => 'فهرست پکیج ها',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => 'ایمیل Spooled',
        'There are emails in var/spool that OTRS could not process.' => 'هستند ایمیل در مسیر var / قرقره که OTRS نمی تواند فرآیند وجود دارد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'تنظیم سیستم شما نامعتبر است، آن تنها باید شامل ارقام باشد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => 'به طور پیش فرض نوع درخواست',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'پیکربندی پیش فرض نوع درخواست نامعتبر است و یا از دست رفته است. لطفا تنظیمات درخواست:: نوع :: پیش فرض را تغییر دهید و یک نوع درخواست معتبر را انتخاب کنید.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'درخواست شاخص ماژول',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'شما باید بیش از 60،000درخواست از باطن StaticDB استفاده کنید. کتابچه راهنمای کاربر مدیر (تنظیم عملکرد)  را برای اطلاعات بیشتر ببینید.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'کاربران نامعتبر با درخواست قفل شده',
        'There are invalid users with locked tickets.' => 'کاربران نامعتبر با درخواست قفل شده وجود دارد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'Open Tickets' => 'درخواست باز',
        'You should not have more than 8,000 open tickets in your system.' =>
            'نباید بیش از 8000 درخواست باز در سیستم شما وجود داشته باشد.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'درخواست جستجوی شاخص ماژول',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'شما باید بیش از 50،000 مقاله و باید از باطن StaticDB استفاده کنید. کتابچه راهنمای کاربر مدیر (تنظیم عملکرد) را برای اطلاعات بیشتر ببینید.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'سوابق یتیم در جدول ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'ticket_lock_index جدول شامل سوابق یتیم. لطفا اجرا بن / otrs.Console.pl \ "سیستم maint :: بلیط :: QueueIndexCleanup " برای تمیز کردن شاخص StaticDB.',
        'Orphaned Records In ticket_index Table' => 'سوابق یتیم در جدول ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => 'تنظیمات زمان',
        'Server time zone' => 'منطقه زمانی سرور',
        'Computed server time offset' => 'انحراف زمان سرور کامپیوتری',
        'OTRS TimeZone setting (global time offset)' => 'تنظیم منطقه زمانی OTRS (زمان جهانی افست)',
        'TimeZone may only be activated for systems running in UTC.' => 'منطقه زمانی ممکن است تنها برای سیستم های در حال اجرا در UTC فعال شود.',
        'OTRS TimeZoneUser setting (per-user time zone support)' => 'OTRS TimeZoneUser تنظیم (هر کاربر پشتیبانی منطقه زمان)',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            'TimeZoneUser ممکن است تنها برای سیستم های در حال اجرا در UTC که یک تنظیم منطقه زمانی OTRS ندارد فعال شود.',
        'OTRS TimeZone setting for calendar ' => 'OTRS تنظیم منطقه زمانی برای تقویم ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'وب Server',
        'Loaded Apache Modules' => 'لود ماژول های آپاچی',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'مدل MPM',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS به Apache به با "prefork را مدل MPM اجرا می شود.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI استفاده از شتاب دهنده ',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'شما باید FastCGI یا mod_perl وجود استفاده برای افزایش کارایی خود را.',
        'mod_deflate Usage' => 'طریقه استفاده mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'لطفا  mod_deflate به منظور بهبود سرعت رابط کاربری گرافیکی نصب کنید.',
        'mod_filter Usage' => 'طریقه استفاده mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'لطفا mod_filter نصب کنید اگر mod_deflate استفاده شده است.',
        'mod_headers Usage' => 'mod_headers طریقه استفاده',
        'Please install mod_headers to improve GUI speed.' => 'لطفا mod_headers نصب کنید به منظور بهبود سرعت رابط کاربری گرافیکی.',
        'Apache::Reload Usage' => 'آپاچی :: بارگزادی مجدد طریقه استفاده',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'آپاچی :: بارگذاری مجدد یا apache2 را :: بازنگری باید به عنوان PerlModule و PerlInitHandler برای جلوگیری از راه اندازی مجدد وب سرور در هنگام نصب و ارتقاء ماژول استفاده می شود.',
        'Apache2::DBI Usage' => 'apache2 را :: DBI طریقه استفاده',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'apache2 را :: DBI برای به دست آوردن عملکرد بهتر با قابلیت اتصال به پایگاه داده از پیش تعیین شده باید استفاده شود.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'متغیرهای محیطی',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'پشتیبانی جمع آوری داده ها',
        'Support data could not be collected from the web server.' => 'داده ها پشتیبانی می تواند از وب سرور نمی تواند جمع آوری شده.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => ' نسخه وب سرور',
        'Could not determine webserver version.' => ' نسخه وب سرور مشخص نیست.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => 'کاربران همزمان اطلاعات',
        'Concurrent Users' => 'کاربران موازی',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => 'ناشناخته',
        'OK' => 'خوب',
        'Problem' => 'مساله است.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'تنظیم مجدد از زمان باز کردن.',

        # Perl Module: Kernel/System/Ticket/Event/NotificationEvent/Transport/Email.pm
        'PGP sign only' => 'تنها PGP امضا',
        'PGP encrypt only' => 'رمزگذاری PGP تنها',
        'PGP sign and encrypt' => 'ثبت نام PGP و رمزگذاری',
        'SMIME sign only' => 'تنها SMIME امضا',
        'SMIME encrypt only' => 'SMIME رمزگذاری تنها',
        'SMIME sign and encrypt' => 'نشانه SMIME و رمزگذاری',
        'PGP and SMIME not enabled.' => 'PGP و SMIME فعال نیست.',
        'Skip notification delivery' => 'پرش تحویل اعلان',
        'Send unsigned notification' => 'ارسال هشدار از طریق بدون علامت',
        'Send unencrypted notification' => 'ارسال هشدار از طریق تکه تکه کردن',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Panic, user authenticated but no user data can be found in OTRS DB!! Perhaps the user is invalid.' =>
            'وحشت، کاربر تصدیق نه داده های کاربر را می توان در OTRS DB یافت. شاید برای کاربران نامعتبر است.',
        'Can`t remove SessionID.' => 'نمیتواند SESSIONID را حذف کنید.',
        'Logout successful.' => 'خروج موفقیت آمیز.',
        'Panic! Invalid Session!!!' => 'وحشت! جلسه نامعتبر است.',
        'No Permission to use this frontend module!' => 'بدون اجازه به استفاده از این ماژول ظاهر!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'احراز هویت موفق شد، اما هیچ سابقه مشتری در باطن مشتری پیدا شده است. لطفا با مدیر تماس بگیرید.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'تنظیم مجدد کلمه ناموفق است. لطفا با مدیر تماس بگیرید.',
        'Added via Customer Panel (%s)' => 'اضافه شده از طریق پنل مشتری ( %s )',
        'Customer user can\'t be added!' => 'کاربران مشتری نمی توانند اضافه شود!',
        'Can\'t send account info!' => 'نمی توانید اطلاعات حساب را ارسال کنید!',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'SecureMode active!' => 'SecureMode فعال!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'اگر می خواهید دوباره اجرا نصب، غیر فعال کردن SecureMode در SysConfig.',
        'Action "%s" not found!' => 'اقدام \ " %s " یافت نشد!',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => 'گروه برای دسترسی پیش فرض.',
        'Group of all administrators.' => 'گروه از همه مدیران.',
        'Group for statistics access.' => 'گروه برای دسترسی آمار.',
        'All new state types (default: viewable).' => 'تمام انواع حالت جدید (به طور پیش فرض: قابل مشاهده).',
        'All open state types (default: viewable).' => 'تمام انواع حالت باز (به طور پیش فرض: قابل مشاهده).',
        'All closed state types (default: not viewable).' => 'تمام انواع حالت بسته (به طور پیش فرض: قابل مشاهده نیست).',
        'All \'pending reminder\' state types (default: viewable).' => 'همه "در انتظار یادآوری، انواع حالت (به طور پیش فرض: قابل مشاهده).',
        'All \'pending auto *\' state types (default: viewable).' => 'همه "در انتظار خودکار * انواع حالت (به طور پیش فرض: قابل مشاهده).',
        'All \'removed\' state types (default: not viewable).' => 'تمام انواع حالت حذف (به طور پیش فرض: قابل مشاهده نیست).',
        'State type for merged tickets (default: not viewable).' => 'نوع حالت برای درخواست ادغام (به طور پیش فرض: قابل مشاهده نیست).',
        'New ticket created by customer.' => 'درخواست جدید ایجاد شده توسط مشتری.',
        'Ticket is closed successful.' => 'درخواست موفق بسته شده است.',
        'Ticket is closed unsuccessful.' => 'درخواست ناموفق بسته شده است.',
        'Open tickets.' => 'درخواست را باز کنید.',
        'Customer removed ticket.' => 'درخواست مشتری حذف خواهند شد.',
        'Ticket is pending for agent reminder.' => 'درخواست برای یادآوری عامل در انتظار.',
        'Ticket is pending for automatic close.' => 'درخواست  نزدیک اتوماتیک در انتظار.',
        'State for merged tickets.' => 'حالت برای ادغام درخواست.',
        'system standard salutation (en)' => 'سیستم سلام استاندارد (FA)',
        'Standard Salutation.' => 'سلام استاندارد.',
        'system standard signature (en)' => 'سیستم امضای استاندارد (FA)',
        'Standard Signature.' => 'امضاء استاندارد.',
        'Standard Address.' => ' نشانی استاندارد.',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'پیگیری برای درخواست بسته امکان پذیر است. درخواست بازگشایی خواهد شد.',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'پیگیری برای درخواست بسته امکان پذیر نیست. بدون درخواست جدید ایجاد خواهد شد.',
        'new ticket' => 'درخواست جدید',
        'Follow-ups for closed tickets are not possible. A new ticket will be created..' =>
            'پیگیری برایدرخواست بسته امکان پذیر نیست. یک درخواست جدید ایجاد خواهد شد ..',
        'Postmaster queue.' => 'صف رئيس پست.',
        'All default incoming tickets.' => 'همه به طور پیش فرض درخواست ورودی.',
        'All junk tickets.' => 'تمام درخواست های ناخواسته.',
        'All misc tickets.' => 'تمام درخواست متفرقه.',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'پاسخ خودکار خواهد شد که یک بلیط جدید بعد از ارسال ایجاد شده است.',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'به صورت خودکار رد خواهد شد که پس از پیگیری رد شده است ارسال (در صورت صف گزینه پیگیری است \ "رد ").',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'تایید خودکار است که پس از پیگیری فرستاده است یک بلیط برای دریافت شده است (در مورد صف پیگیری گزینه \ "ممکن " است).',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'پاسخ خودکار خواهد شد که پس از پیگیری ارسال رد شده است و یک بلیط جدید ایجاد شده است (در مورد صف پیگیری گزینه است \ "بلیط جدید ").',
        'Auto remove will be sent out after a customer removed the request.' =>
            'حذف خودکار ارسال می شود پس از یک مشتری درخواست حذف شدند.',
        'default reply (after new ticket has been created)' => 'به طور پیش فرض پاسخ (پس از بلیط جدید ایجاد شده است)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'به طور پیش فرض رد (پس از پیگیری و رد یک بلیط بسته)',
        'default follow-up (after a ticket follow-up has been added)' => 'به طور پیش فرض پیگیری (پس از یک بلیط پیگیری اضافه شده است)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'به طور پیش فرض / بلیط جدید ایجاد رد (پس از بسته پیگیری با ایجاد بلیط جدید)',
        'Unclassified' => 'طبقه بندی نشده',
        'tmp_lock' => 'tmp_lock',
        'email-notification-ext' => 'ایمیل اطلاع رسانی-EXT',
        'email-notification-int' => 'ایمیل اطلاع رسانی-INT',
        'Ticket create notification' => 'درخواست ایجاد اطلاع رسانی',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'شما اطلاع رسانی در هر زمان یک بلیط جدید در یکی از \ شما ایجاد می شود دریافت "صف من " یا \ "سرویس های من ".',
        'Ticket follow-up notification (unlocked)' => 'درخواست پیگیری اطلاع رسانی (کلیک کنید)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'شما یک اخطار دریافت خواهید اگر یک مشتری می فرستد یک پیگیری یک بلیط باز شده است که در \ خود را به "صف من " یا \ "سرویس های من ".',
        'Ticket follow-up notification (locked)' => 'درخواست پیگیری اطلاع رسانی (قفل شده)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'شما یک اخطار دریافت خواهید اگر یک مشتری یک پیگیری یک بلیط قفل شده که شما صاحب بلیط یا مسئول هستند به ارسال می کند.',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'شما اطلاع رسانی به زودی به عنوان یک بلیط متعلق به شما به طور خودکار باز دریافت خواهید کرد.',
        'Ticket owner update notification' => 'درخواست  شخصی به روزرسانی اطلاعات',
        'Ticket responsible update notification' => 'درخواست به روز رسانی اطلاعات مسئول',
        'Ticket new note notification' => 'درخواست اطلاع رسانی یادداشت جدید',
        'Ticket queue update notification' => 'درخواست به روز رسانی اطلاعات صف',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'شما یک اخطار دریافت خواهید اگر یک بلیط به یکی از \ خود نقل مکان کرد "صف من ".',
        'Ticket pending reminder notification (locked)' => 'درخواست در انتظار آگاه شدن از طریق یادآوری (قفل شده)',
        'Ticket pending reminder notification (unlocked)' => 'درخواست در انتظار آگاه شدن از طریق یادآوری (قفل)',
        'Ticket escalation notification' => 'درخواست تشدید اطلاع رسانی ',
        'Ticket escalation warning notification' => 'درخواست  تشدید اطلاع رسانی هشدار دهنده',
        'Ticket service update notification' => 'درخواست به روز رسانی اطلاع رسانی خدمات',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'شما یک اخطار دریافت خواهید اگر سرویس یک بلیط به یکی از \ خود را تغییر "سرویس های من ".',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
مشترک گرامی،

متاسفانه شماره درخواست معتبری در عنوان تشخیص داده نشد و
بنابراین این پیام ایمیلی قابل پردازش نیست.

لطفا یک درخواست جدید توسط پنل کاربری مشترک ایجاد کنید.

از همراهمی شما متشکریم

 تیم پشتیبانی
',
        ' (work units)' => ' (واحد کار)',
        '"%s" notification was sent to "%s" by "%s".' => '\ " %s " اطلاع رسانی به \ "ارسال شد %s " با \ " %s ".',
        '"Slim" skin which tries to save screen space for power users.' =>
            '\ "اسلیم " پوست که تلاش می کند برای صرفه جویی در فضای صفحه نمایش برای کاربران قدرت.',
        '%s' => '٪s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s واحد زمان (بازدید کنندگان) اختصاص داده است. در حال حاضر مجموع %s واحد زمان (بازدید کنندگان).',
        '(UserLogin) Firstname Lastname' => '(صفحهی) نام نام خانوادگی',
        '(UserLogin) Lastname Firstname' => '(صفحهی) نام خانوادگی FIRSTNAME',
        '(UserLogin) Lastname, Firstname' => '(صفحهی) نام خانوادگی، نام',
        '*** out of office until %s (%s d left) ***' => '*** خارج از دفتر تا %s ( %s د سمت چپ) ***',
        '100 (Expert)' => '100 (کارشناس)',
        '200 (Advanced)' => '200پیشرفته',
        '300 (Beginner)' => '300 (مبتدی)',
        'A TicketWatcher Module.' => 'ماژول TicketWatcher.',
        'A Website' => 'یک وبسایت',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'یک لیست از زمینه پویا که بلیط اصلی را به در جریان یک عملیات ادغام. تنها زمینه های پویا که بلیط اصلی در خالی هستند مجموعه خواهد شد.',
        'A picture' => 'یک تصویر',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ماژول ACL فقط زمانی که تمام درخواست‌های فرزند بسته شده باشد، اجازه بستن درخواست‌های والد را می‌دهد. ("وضعیت" نان می‌دهد که کدام وضعیت‌ها برای درخواست والدتا زمانی که تمام درخواست‌های فرزند بسته شده است، در دسترس می‌باشد.)',
        'Access Control Lists (ACL)' => 'فهرست سطخ دسترسی (ACL)',
        'AccountedTime' => 'AccountedTime',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'مکانیزم چشمک زدن را برای صف درخواستی که شامل قدیمی‌ترین درخواست می‌باشد فعال می‌کند.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'ویژگی رمز عبور فراموش شده را برای کارشناسان فعال می‌کند.',
        'Activates lost password feature for customers.' => 'ویژگی رمز عبور فراموش شده را برای مشترکین فعال می‌کند.',
        'Activates support for customer groups.' => 'پشتیبانی از گروه‌های مشترکین را فعال می‌سازد.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'فیلتر مطلب را در نمای نمایش کامل برای مشخص کردن اینکه کدام مطلب نمایش داده شود، فعال می‌کند.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'پوسته‌های ظاهری را در سیستم فعال می‌کند. مقدار ۱ یعنی فعال و مقدار ۰ یعنی غیرفعال.',
        'Activates the ticket archive system search in the customer interface.' =>
            'فعال کردن جستجو سیستم آرشیو درخواست در رابط مشتری.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'سیستم آرشیو درخواست را با انتقال برخی درخواست‌ها به خارج از ناحیه روزانه به منظور داشتن سیستمی سریع‌تر، فعال می‌کند. برای جستجوی این درخواست‌ها باید چک آرشیو در جستجوی درخواست انتخاب شده باشد.',
        'Activates time accounting.' => 'محاسبه زمان را فعال می‌کند.',
        'ActivityID' => 'ActivityID',
        'Add an inbound phone call to this ticket' => 'اضافه کردن یک تماس تلفنی بین المللی به درون این درخواست',
        'Add an outbound phone call to this ticket' => 'اضافه کردن یک تماس تلفنی به این درخواست',
        'Added email. %s' => 'اضافه شده ایمیل. %s',
        'Added link to ticket "%s".' => 'اضافه شدن لینک به بلیط \ " %s ".',
        'Added note (%s)' => 'اضافه شده توجه داشته باشید ( %s )',
        'Added subscription for user "%s".' => 'عضویت اضافه شده برای کاربر "%s".',
        'Address book of CustomerUser sources.' => 'کتاب آدرس از منابع CustomerUser.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'پسوند سال و ماه به فایل ثبت وقایع می‌افزاید. برای هر ماه یک فایل ساخته خواهد شد.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'می افزاید: مشتریان به آدرس ایمیل به گیرندگان در صفحه نوشتن بلیط رابط عامل. آدرس مشتریان ایمیل اضافه خواهد شد در صورتی که نوع مقاله ایمیل داخلی است.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'می افزاید: یک بار روز تعطیلات برای تقویم نشان داد. لطفا الگوی تک رقمی برای شماره 9 (- 09 به جای 01) استفاده از 1.',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'یک روز تعطیلی موقتی می‌افزاید. لطفا از الگوی عددی واحدی از ۱ تا ۹ استفاده نمایید (به جای 01 - 09 )',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'می افزاید: روز تعطیلات دائمی برای تقویم نشان داد. لطفا الگوی تک رقمی برای شماره 9 (- 09 به جای 01) استفاده از 1.',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'یک روز تعطیلی دائمی می‌افزاید. لطفا از الگوی عددی واحدی از ۱ تا ۹ استفاده نمایید (به جای 01 - 09 )',
        'Admin Area.' => 'بخش مدیریت.',
        'After' => 'پس',
        'Agent Name' => 'نام نماینده',
        'Agent Name + FromSeparator + System Address Display Name' => 'نام نماینده + FromSeparator + سیستم نام آدرس ها',
        'Agent Preferences.' => 'تنظیمات عامل.',
        'Agent called customer.' => 'سابقه::تماسهای تلفنی کارشناس',
        'Agent interface article notification module to check PGP.' => 'ماژول اعلان مطلب برای کارشناس به جهت کنترل PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'ماژول اعلان مطلب برای کارشناس به جهت کنترل S/MIME',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'عامل ماژول رابط برای دسترسی به جستجوی CIC از طریق نوار منو. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'عامل ماژول رابط برای دسترسی به جستجوی متن از طریق نوار منو. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'عامل ماژول رابط برای دسترسی به پروفایل جستجو از طریق نوار منو. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'ماژول واسط کارشناس برای کنترل ایمیل‌های وارده در نمای نمایش کامل درخواست در صورتی که کلید S/MIME موجود و صحیح باشد.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'عامل ماژول اطلاع رسانی رابط برای دیدن تعدادی از بلیط قفل شده است. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'عامل ماژول اطلاع رسانی رابط برای دیدن تعدادی از بلیط از عوامل مسئول است. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'عامل ماژول اطلاع رسانی رابط برای دیدن تعدادی از بلیط در سرویس های من. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'عامل ماژول اطلاع رسانی رابط برای دیدن تعدادی از بلیط تماشا. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'AgentCustomerSearch' => 'AgentCustomerSearch',
        'AgentCustomerSearch.' => 'AgentCustomerSearch.',
        'AgentUserSearch' => 'AgentUserSearch',
        'AgentUserSearch.' => 'AgentUserSearch.',
        'Agents <-> Groups' => 'کارشناسان <-> گروه‌ها',
        'Agents <-> Roles' => 'کارشناسان <-> نقش‌ها',
        'All customer users of a CustomerID' => 'همه کاربران مشتری از CustomerID',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'اجازه می دهد تا با اضافه کردن یادداشت در صفحه نمایش بلیط نزدیک رابط عامل. می توان با بلیط :: ظاهر :: NeedAccountedTime رونویسی.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'اجازه می دهد تا با اضافه کردن یادداشت در صفحه نمایش بلیط های متنی رایگان از رابط عامل. می توان با بلیط :: ظاهر :: NeedAccountedTime رونویسی.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'اجازه می دهد تا با اضافه کردن یادداشت در صفحه نمایش توجه داشته باشید بلیط رابط عامل. می توان با بلیط :: ظاهر :: NeedAccountedTime رونویسی.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'اجازه می دهد تا با اضافه کردن یادداشت در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از. می توان با بلیط :: ظاهر :: NeedAccountedTime رونویسی.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'اجازه می دهد تا با اضافه کردن یادداشت در صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل از. می توان با بلیط :: ظاهر :: NeedAccountedTime رونویسی.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'اجازه می دهد تا با اضافه کردن یادداشت در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از. می توان با بلیط :: ظاهر :: NeedAccountedTime رونویسی.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'اجازه می دهد تا با اضافه کردن یادداشت در صفحه نمایش بلیط مسئول رابط عامل. می توان با بلیط :: ظاهر :: NeedAccountedTime رونویسی.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'اجازه می دهد تا عوامل به تبادل محور یک آمار اگر آنها تولید یک.',
        'Allows agents to generate individual-related stats.' => 'اجازه می دهد تا عوامل به آمار و ارقام مربوط به فرد.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'اجازه می دهد تا انتخاب بین نشان دادن فایل پیوست یک بلیط در مرورگر (خطی) یا فقط آنها را دانلود (فایل پیوست) است.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'اجازه می دهد تا انتخاب حالت نوشتن بعدی برای درخواست مشتری در رابط مشتری.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'به مشتریان  برای تغییر اولویت بلیط در رابط مشتری اجازه می دهد .',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'مشتریان اجازه می دهد تا مجموعه ای از SLA بلیط در رابط مشتری.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'به مشتریان اجازه می دهد به تنظیم اولویت درخواست در رابط مشتری.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'مشتریان اجازه می دهد به مجموعه ای صف بلیط در رابط مشتری. اگر این تنظیم شده است «نه»، QueueDefault باید پیکربندی شوند.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'اجازه می دهد به مشتریان تا قراردهند  مجموعه خدمات درخواست در رابط مشتری.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'مشتریان اجازه می دهد تا مجموعه ای از نوع بلیط در رابط مشتری. اگر این تنظیم شده است «نه»، TicketTypeDefault باید پیکربندی شوند.',
        'Allows default services to be selected also for non existing customers.' =>
            'اجازه می دهد تا خدمات به طور پیش فرض به همچنین برای مشتریان غیر موجود انتخاب شود.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'اجازه تعریف جدید برای انواع  درخواست  می دهد(اگر ویژگی نوع درخواست فعال باشد).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'اجازه تعریف خدمات و SLA ها برای درخواست  می دهد (به عنوان مثال ایمیل، دسکتاپ، شبکه، ...)، و تشدید ویژگی برای SLA ها (اگر سرویس بلیط / ویژگی های SLA فعال باشد).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'اجازه می دهد تا شرایط جستجو شده در جستجوی بلیط از رابط عامل عمومی است. با این ویژگی شما می توانید به عنوان مثال عنوان بلیط با این نوع از شرایط مانند \ جستجو "(* key1 * && * key2 *) " یا \ "(* key1 * || * key2 *) ".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'اجازه می دهد تا داشتن یک دید کلی قطع متوسط ​​بلیط (CustomerInfo => 1 - نشان می دهد نیز اطلاعات مربوط به مشتری).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'اجازه می دهد تا داشتن یک دید کلی فرمت کوچک بلیط (CustomerInfo => 1 - نشان می دهد نیز اطلاعات مربوط به مشتری).',
        'Allows invalid agents to generate individual-related stats.' => 'اجازه تولید به  عوامل نامعتبر برای آمار و ارقام مربوط به فرد را میدهد. ',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'اجازه می دهد تا مدیران به عنوان مشتریان دیگر وارد شوند، از طریق استفاده از پنل مدیریت کاربران مشتری .',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'اجازه می دهد تا مدیران به عنوان کاربران دیگر وارد شوند، از طریق پانل کاربران دولت.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'اجازه می دهد تا به مجموعه ای از یک دولت درخواست جدید در صفحه نمایش درخواست حرکت از رابط عامل.',
        'Always show RichText if available' => 'همیشه RichText  نشان می دهد اگر موجود باشد',
        'Arabic (Saudi Arabia)' => 'عربی (عربستان سعودی)',
        'Archive state changed: "%s"' => ' تغییرحالت بایگانی: \ " %s "',
        'ArticleTree' => 'ArticleTree',
        'Attachments <-> Templates' => 'فایل های پیوست <-> قالب',
        'Auto Responses <-> Queues' => 'پاسخ خودکار <-> لیست درخواست',
        'AutoFollowUp sent to "%s".' => 'AutoFollowUp ارسال به \ " %s ".',
        'AutoReject sent to "%s".' => 'AutoReject ارسال به \ " %s ".',
        'AutoReply sent to "%s".' => 'ارسال خودکار  به \ " %s ".',
        'Automated line break in text messages after x number of chars.' =>
            'خط خودکار در پیام های متنی از تعداد X از کاراکتر.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'به صورت خودکار قفل و پس از باز کردن صفحه نمایش درخواست حرکت از رابط عامل تعیین مالک به عامل فعلی.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'به صورت خودکار قفل و پس از انتخاب برای یک عمل فله مجموعه مالک به عامل فعلی.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'به طور خودکار مجموعه صاحب یک بلیط به عنوان مسئول آن از (اگر بلیط ویژگی مسئول فعال باشد). این تنها کار خواهد کرد به صورت دستی اعمال در کاربران وارد سایت شوید. آن را برای اقدامات خودکار به عنوان مثال GenericAgent، پست و GenericInterface کار نمی کند.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'به طور خودکار مجموعه مسئول یک بلیط (در صورت تنظیم نشده است) پس از به روز رسانی صاحب اول.',
        'Balanced white skin by Felix Niklas (slim version).' => 'پوست سفید متعادل کننده شده توسط فلیکس نیکلاس (نسخه باریک).',
        'Balanced white skin by Felix Niklas.' => 'پوست سفید متعادل کننده شده توسط فلیکس نیکلاس.',
        'Based on global RichText setting' => 'بر اساس تنظیم RichText جهانی',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            'تنظیمات عمومی شاخص متن. اجرای \ "بن / otrs.Console.pl سیستم maint :: بلیط :: FulltextIndexRebuild " به منظور تولید یک شاخص جدید.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'بلوک تمام ایمیل های دریافتی است که یک تعداد بلیط معتبر در موضوع با از ندارید: @ example.com آدرس.',
        'Bounced to "%s".' => 'لینک ثابت به : "%s"',
        'Builds an article index right after the article\'s creation.' =>
            'ایجاد یک شاخص مقاله درست پس از ایجاد مطلب.',
        'Bulgarian' => 'بلغاری',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'به عنوان مثال راه اندازی CMD. نادیده ایمیل که در آن خارجی CMD باز می گردد برخی از خروجی در STDOUT (ایمیل خواهد شد را به STDIN از some.bin لوله کشی).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'زمان کش در ثانیه را برای احراز هویت عامل در GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'زمان کش در ثانیه را برای احراز هویت مشتری در GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'زمان کش در ثانیه برای بخش مدیریت DB لیگ قهرمانان آسیا.',
        'Cache time in seconds for the DB process backend.' => 'زمان کش در ثانیه برای فرایند باطن DB.',
        'Cache time in seconds for the SSL certificate attributes.' => 'زمان کش در ثانیه برای ویژگی گواهینامه SSL.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'زمان کش در ثانیه برای فرایند بلیط ماژول خروجی نوار ناوبری.',
        'Cache time in seconds for the web service config backend.' => 'زمان کش در ثانیه برای خدمات وب باطن پیکربندی.',
        'Catalan' => 'کاتالان',
        'Change password' => 'تغییر رمز عبور',
        'Change queue!' => 'تغییر صف درخواست!',
        'Change the customer for this ticket' => 'تغییر مشتری  برای این درخواست',
        'Change the free fields for this ticket' => 'تغییر زمینه رایگان برای این درخواست',
        'Change the priority for this ticket' => 'تغییر اولویت  برای این درخواست',
        'Change the responsible for this ticket' => 'تغییر مسئول برای این درخواست',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'اولویت تغییر از \ " %s " ( %s ) به \ " %s " ( %s ).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'تغییرات صاحب بلیط برای همه (برای ASP مفید). به طور معمول تنها عامل با مجوز RW در صف بلیط نشان داده خواهد شد.',
        'Checkbox' => 'قابل انتخاب',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'چک اگر یک ایمیل پیگیری بلیط های موجود به با جستجو در موضوع برای یک تعداد بلیط معتبر است.',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'چک سیستم را در بلیط تشخیص شماره برای پیگیری (استفاده از \ "بدون " اگر سیستم را پس از استفاده از سیستم تغییر داده شده است).',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            'چک در دسترس بودن OTRS کسب و کار راه حل ™ برای این سیستم.',
        'Checks the entitlement status of OTRS Business Solution™.' => 'چک وضعیت استحقاق OTRS کسب و کار راه حل ™.',
        'Chinese (Simplified)' => 'چینی (ساده شده)',
        'Chinese (Traditional)' => 'چینی (سنتی)',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            'انتخاب کنید چه نوع درخواستی تغییر کند تا شما به اطلاعات مورد نظرتان برسید.',
        'Closed tickets (customer user)' => 'درخواست های بسته (کاربران مشتری)',
        'Closed tickets (customer)' => 'درخواست های بسته (مشتری)',
        'Cloud Services' => 'خدمات ابر',
        'Cloud service admin module registration for the transport layer.' =>
            'ابر مدیر خدمات ثبت نام ماژول برای لایه حمل و نقل.',
        'Collect support data for asynchronous plug-in modules.' => 'جمع آوری داده ها پشتیبانی از پلاگین در ماژول ناهمزمان.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'فیلتر درخواست ستون برای نوع درخواست مروری \ "کوچک ".',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'ستون است که می تواند در نظر تشدید رابط عامل فیلتر شده است. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه: فقط بلیط صفات، پویا زمینه های (DynamicField_NameX) و ویژگی های و ضوابط (به عنوان مثال CustomerUserPhone، CustomerCompanyName، ...) مجاز است.',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'ستون است که می تواند در نظر قفل شده از رابط عامل فیلتر شده است. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه: فقط بلیط صفات، پویا زمینه های (DynamicField_NameX) و ویژگی های و ضوابط (به عنوان مثال CustomerUserPhone، CustomerCompanyName، ...) مجاز است.',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'ستون است که می تواند در نظر صف از رابط عامل فیلتر شده است. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه: فقط بلیط صفات، پویا زمینه های (DynamicField_NameX) و ویژگی های و ضوابط (به عنوان مثال CustomerUserPhone، CustomerCompanyName، ...) مجاز است.',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'ستون است که می تواند در نظر مسئول رابط عامل فیلتر شده است. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه: فقط بلیط صفات، پویا زمینه های (DynamicField_NameX) و ویژگی های و ضوابط (به عنوان مثال CustomerUserPhone، CustomerCompanyName، ...) مجاز است.',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'ستون است که می تواند در نظر خدمت رابط عامل فیلتر شده است. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه: فقط بلیط صفات، پویا زمینه های (DynamicField_NameX) و ویژگی های و ضوابط (به عنوان مثال CustomerUserPhone، CustomerCompanyName، ...) مجاز است.',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'ستون است که می تواند در نظر وضعیت رابط عامل فیلتر شده است. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه: فقط بلیط صفات، پویا زمینه های (DynamicField_NameX) و ویژگی های و ضوابط (به عنوان مثال CustomerUserPhone، CustomerCompanyName، ...) مجاز است.',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'ستون است که می تواند در نظر نتیجه جستجو بلیط رابط عامل فیلتر شده است. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه: فقط بلیط صفات، پویا زمینه های (DynamicField_NameX) و ویژگی های و ضوابط (به عنوان مثال CustomerUserPhone، CustomerCompanyName، ...) مجاز است.',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'ستون است که می تواند در نظر دیده بان رابط عامل فیلتر شده است. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه: فقط بلیط صفات، پویا زمینه های (DynamicField_NameX) و ویژگی های و ضوابط (به عنوان مثال CustomerUserPhone، CustomerCompanyName، ...) مجاز است.',
        'Comment for new history entries in the customer interface.' => 'نظر برای نوشته های تاریخ جدید در رابط مشتری.',
        'Comment2' => '1 نظر',
        'Communication' => 'ارتباطات',
        'Company Status' => 'وضعیت شرکت',
        'Company Tickets.' => 'درخواست شرکت.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'نام شرکت می باشد که در ایمیل های ارسالی به عنوان یک X-سربرگ شامل خواهد شد.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'ماژول Compat برای AgentZoom به AgentTicketZoom.',
        'Complex' => 'پیچیده',
        'Configure Processes.' => ' پردازش پیکربندی .',
        'Configure and manage ACLs.' => 'پیکربندی و مدیریت ACL ها است.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'پیکربندی هر پایگاه داده آینه فقط خواندنی های اضافی است که شما می خواهید به استفاده از.',
        'Configure sending of support data to OTRS Group for improved support.' =>
            'پیکربندی ارسال داده پشتیبانی به OTRS گروه برای پشتیبانی بهبود یافته.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'پیکربندی که صفحه نمایش باید نشان داده شود پس از یک درخواست جدید ایجاد شده است.',
        'Configure your own log text for PGP.' => 'پیکربندی متن ورود به سیستم خود  برای PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            'پیکربندی تنظیمات پیش فرض TicketDynamicField. \ "نام " تعریف می کند زمینه پویا است که باید مورد استفاده قرار گیرد، \ "ارزش " داده است که تعیین خواهد شد، و \ "رویداد " رویداد ماشه تعریف می کند. لطفا کتابچه راهنمای توسعه (http://otrs.github.io/doc/)، فصل \ "بلیط رویداد ماژول " تیک بزنید.',
        'Controls how to display the ticket history entries as readable values.' =>
            'کنترل نحوه نمایش نوشته های تاریخ بلیط به عنوان ارزش های قابل خواندن است.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'کنترل اگر مشتریان توانایی مرتب سازی درخواست های خود را داشته باشند.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'کنترل اگر بیش از یک  ورودی می تواند بلیط تلفن جدید در رابط عامل در تنظیم شده است.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'کنترل اگر مدیر مجاز به واردات یک پیکربندی سیستم ذخیره شده در SysConfig. است',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'کنترل اگر مدیر مجاز به ایجاد تغییرات به پایگاه داده از طریق AdminSelectBox. است',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'کنترل اگر پرچم درخواست و مقاله دیده شود آنها حذف می شوند زمانیکه یک بلیط بایگانی شده است.',
        'Converts HTML mails into text messages.' => 'تبدیل ایمیل های HTML و به پیام های متنی.',
        'Create New process ticket.' => 'ساختن درخواست روند جدید.',
        'Create and manage Service Level Agreements (SLAs).' => 'ساخت و مدیریت توافقات سطح سرویس (SLA)',
        'Create and manage agents.' => 'ساخت و مدیریت کارشناسان',
        'Create and manage attachments.' => 'ساخت و مدیریت پیوست‌ها',
        'Create and manage customer users.' => 'ایجاد و مدیریت کاربران مشتری می باشد.',
        'Create and manage customers.' => 'ساخت و مدیریت مشترکین',
        'Create and manage dynamic fields.' => 'ایجاد و مدیریت زمینه های پویا.',
        'Create and manage groups.' => 'ساخت و مدیریت گروه‌ها',
        'Create and manage queues.' => 'ساخت و مدیریت صف‌های درخواست',
        'Create and manage responses that are automatically sent.' => 'ساخت و مدیریت پاسخ‌های خودکار',
        'Create and manage roles.' => 'ساخت و مدیریت نقش‌ها',
        'Create and manage salutations.' => 'ساخت و مدیریت عناوین',
        'Create and manage services.' => 'ساخت و مدیریت خدمات',
        'Create and manage signatures.' => 'ساخت و مدیریت امضاءها',
        'Create and manage templates.' => 'ایجاد و مدیریت قالب.',
        'Create and manage ticket notifications.' => 'ایجاد و مدیریت اطلاعیه درخواست',
        'Create and manage ticket priorities.' => 'ساخت و مدیریت خصوصیات درخواست',
        'Create and manage ticket states.' => 'ساخت و مدیریت وضعیت درخواست‌ها',
        'Create and manage ticket types.' => 'ساخت و مدیریت انواع درخواست',
        'Create and manage web services.' => 'ایجاد و مدیریت خدمات وب .',
        'Create new Ticket.' => 'ایجاد درخواست جدید.',
        'Create new email ticket and send this out (outbound).' => 'ساختن درخواست ایمیل های جدید و ارسال این (خروجی).',
        'Create new email ticket.' => 'ساختن درخواست ایمیل جدید.',
        'Create new phone ticket (inbound).' => 'ساختن درخواست گوشی جدید (ورودی).',
        'Create new phone ticket.' => 'ساختن درخواست گوشی جدید.',
        'Create new process ticket.' => 'ساختن درخواست فرآیند جدید.',
        'Create tickets.' => 'ساختن درخواست',
        'Croatian' => 'کرواتی',
        'Custom RSS Feed' => 'سفارشی خوراک RSS',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'متن دلخواه برای صفحه نشان داده شده به مشتریان است که هیچ بلیط هنوز (اگر شما نیاز به آن متن ترجمه آنها را به یک ماژول ترجمه سفارشی اضافه کنید).',
        'Customer Administration' => 'اداره مشتری',
        'Customer Information Center Search.' => ' جستجو مرکز اطلاعات مشتری.',
        'Customer Information Center.' => 'مرکز اطلاعات مشتری.',
        'Customer Ticket Print Module.' => 'درخواست مشتری چاپ ماژول.',
        'Customer User <-> Groups' => 'مشتری کاربر <-> گروه',
        'Customer User <-> Services' => 'مشتری کاربر <-> خدمات',
        'Customer User Administration' => 'مشتری اداره کاربری',
        'Customer Users' => 'مشترکین',
        'Customer called us.' => 'سابقه:: تماسهای تلفنی مشترک',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'مورد و ضوابط (آیکون) نشان می دهد که بلیط بسته از این مشتری را به عنوان بلوک اطلاعات. تنظیم CustomerUserLogin تا 1 جستجو برای بلیط بر اساس نام کاربری به جای CustomerID.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'مورد و ضوابط (آیکون) نشان می دهد که بلیط باز این مشتری را به عنوان بلوک اطلاعات. تنظیم CustomerUserLogin تا 1 جستجو برای بلیط بر اساس نام کاربری به جای CustomerID.',
        'Customer preferences.' => 'ترجیحات مشتری.',
        'Customer request via web.' => 'سابقه::درخواست از طریق وب توسط مشترک',
        'Customer ticket overview' => 'مروری درخواست مشتری',
        'Customer ticket search.' => 'جستجو درخواست مشتری.',
        'Customer ticket zoom' => 'زوم درخواست مشتری',
        'Customer user search' => 'جستجو کاربران مشترک',
        'CustomerID search' => 'جستجو CustomerID',
        'CustomerName' => 'نام مشتری',
        'CustomerUser' => 'CustomerUser',
        'Customers <-> Groups' => 'مشترکین <-> گروه‌ها',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'کلمات توقف قابل تنظیم برای صفحه اول متن. این کلمات از صفحه اول جستجو حذف خواهند شد.',
        'Czech' => 'چک',
        'Danish' => 'دانمارکی',
        'Data used to export the search result in CSV format.' => 'داده استفاده شده برای ارسال نتایج جستجو به قالب CSV',
        'Date / Time' => 'زمان تاریخ',
        'Debug' => 'اشکال زدایی',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'از debugs مجموعه ترجمه. اگر این قرار است \ "بله " همه رشته ها (متن) بدون ترجمه به stderr را نوشته شده است. این می تواند مفید هنگامی که شما در حال ایجاد یک فایل ترجمه جدید است. در غیر این صورت، این گزینه باید همچنان به مجموعه \ "بدون ".',
        'Default' => 'پیش فرض',
        'Default (Slim)' => 'به طور پیش فرض (لاغر)',
        'Default ACL values for ticket actions.' => 'مقادیر ACL پیش‌فرض برای عملیات‌های درخواست',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'به طور پیش فرض پیشوند نهاد مدیریت پردازش برای شناسه های نهاد است که به طور خودکار تولید می شود.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'داده های پیش فرض برای استفاده بر روی ویژگی برای صفحه نمایش جستجو بلیط. به عنوان مثال: \ "TicketCreateTimePointFormat = سال؛ TicketCreateTimePointStart = آخرین. TicketCreateTimePoint = 2؛ ".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'داده های پیش فرض برای استفاده بر روی ویژگی برای صفحه نمایش جستجو بلیط. به عنوان مثال: \ "TicketCreateTimeStartYear = 2010؛ TicketCreateTimeStartMonth = 10؛ TicketCreateTimeStartDay = 4؛ TicketCreateTimeStopYear = 2010؛ TicketCreateTimeStopMonth = 11؛ TicketCreateTimeStopDay = 3؛ ".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'به طور پیش فرض نوع صفحه نمایش برای گیرنده (برای، سی) نام در AgentTicketZoom و CustomerTicketZoom.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'نوع صفحه نمایش به طور پیش فرض برای فرستنده (از) نام در AgentTicketZoom و CustomerTicketZoom.',
        'Default loop protection module.' => 'ماژول جلوگیری از تشکیل حلقه پیش‌فرض',
        'Default queue ID used by the system in the agent interface.' => 'شناسه پیش‌فرض صف استفاده شده برای سیستم در واسط کاربری کارشناس',
        'Default skin for the agent interface (slim version).' => 'پوست به طور پیش فرض برای رابط عامل (نسخه باریک).',
        'Default skin for the agent interface.' => 'پوست به طور پیش فرض برای رابط عامل.',
        'Default skin for the customer interface.' => 'پوست به طور پیش فرض برای رابط مشتری.',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID درخواست به طور پیش فرض استفاده شده توسط سیستم در رابط عامل.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID درخواست به طور پیش فرض استفاده شده توسط سیستم در رابط مشتری.',
        'Default value for NameX' => 'مقدار پیش فرض برای NameX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'تعریف عملیات که در آن یک دکمه تنظیمات در دسترس است در اشیاء مرتبط ویجت (LinkObject :: ViewMode = \ "پیچیده "). لطفا توجه داشته باشید که این اقدامات باید در بر داشت زیر JS و CSS فایل های ثبت نام کرده اند: Core.AllocationList.css، Core.UI.AllocationList.js، Core.UI.Table.Sort.js، Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'تعریف یک فیلتر برای خروجی HTML برای اضافه کردن لینک پشت یک رشته تعریف شده است. عنصر تصویر اجازه می دهد تا دو نوع ورودی. در یک بار نام یک تصویر (به عنوان مثال faq.png). در این مورد مسیر تصویر OTRS استفاده خواهد شد. احتمال و امکان دوم است برای قرار دادن لینک به تصویر.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            'تعریف یک نگاشت بین متغیرهای داده های کاربر و ضوابط (کیبورد) و زمینه های پویا یک بلیط (مقادیر). هدف این است که برای ذخیره اطلاعات کاربران به مشتریان در زمینه های پویا بلیط. زمینه پویا باید در سیستم می شود و باید برای AgentTicketFreeText را فعال کنید، به طوری که آنها می تواند مجموعه ای / دستی توسط عامل به روز شد. آنها باید برای AgentTicketPhone، AgentTicketEmail و AgentTicketCustomer فعال نیست. اگر آنها بود، آنها مقدم بر ارزش به طور خودکار تنظیم است. برای استفاده از این نقشه، شما باید به هم تنظیمات بعدی زیر را فعال کنید.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'تعریف نام زمینه پویا برای زمان پایان. این فیلد به صورت دستی به سیستم به عنوان بلیط افزود: \ "تاریخ / زمان " و باید در صفحه نمایش ایجاد بلیط و / یا در هر صفحه نمایش عمل بلیط دیگر فعال شود.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'تعریف نام زمینه پویا برای زمان شروع. این فیلد به صورت دستی به سیستم به عنوان بلیط افزود: \ "تاریخ / زمان " و باید در صفحه نمایش ایجاد بلیط و / یا در هر صفحه نمایش عمل بلیط دیگر فعال شود.',
        'Define the max depth of queues.' => 'تعریف عمق حداکثر صف.',
        'Define the queue comment 2.' => 'تعریف نظر صف 2.',
        'Define the service comment 2.' => 'تعریف نظر خدمات 2.',
        'Define the sla comment 2.' => 'تعریف نظر SLA 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'تعریف روز شروع هفته را برای جمع کننده اطلاعات تقویم نشان داد.',
        'Define the start day of the week for the date picker.' => 'تعریف روز شروع هفته برای جمع کننده اطلاعات.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'تعریف که ستون در بلیط مرتبط ویجت (LinkObject :: ViewMode = \ "پیچیده ") نشان داده شده است. توجه: فقط بلیط صفات و زمینه های پویا (DynamicField_NameX) برای DefaultColumns مجاز می باشد. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'یک Anchor را معرفی مشتری، که تولید یک آیکون مربوط در پایان یک بلوک اطلاعات مشتری.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'یک Anchor را معرفی مشتری، که تولید یک آیکون زینگ در پایان یک بلوک اطلاعات مشتری.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'یک Anchor را معرفی مشتری، که تولید یک آیکون گوگل در پایان یک بلوک اطلاعات مشتری.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'یک Anchor را معرفی مشتری، که تولید یک آیکون نقشه های گوگل در پایان یک بلوک اطلاعات مشتری.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'یک لیست به طور پیش فرض از کلمات، که توسط جستجوگر طلسم کنه.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'تعریف می کند یک فیلتر برای خروجی HTML برای اضافه کردن لینک در پشت اعداد CVE. عنصر تصویر اجازه می دهد تا دو نوع ورودی. در یک بار نام یک تصویر (به عنوان مثال faq.png). در این مورد مسیر تصویر OTRS استفاده خواهد شد. احتمال و امکان دوم است برای قرار دادن لینک به تصویر.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'تعریف می کند یک فیلتر برای خروجی HTML برای اضافه کردن لینک در پشت اعداد MSBulletin. عنصر تصویر اجازه می دهد تا دو نوع ورودی. در یک بار نام یک تصویر (به عنوان مثال faq.png). در این مورد مسیر تصویر OTRS استفاده خواهد شد. احتمال و امکان دوم است برای قرار دادن لینک به تصویر.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'تعریف می کند یک فیلتر برای خروجی HTML برای اضافه کردن لینک پشت یک رشته تعریف شده است. عنصر تصویر اجازه می دهد تا دو نوع ورودی. در یک بار نام یک تصویر (به عنوان مثال faq.png). در این مورد مسیر تصویر OTRS استفاده خواهد شد. احتمال و امکان دوم است برای قرار دادن لینک به تصویر.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'تعریف می کند یک فیلتر برای خروجی HTML برای اضافه کردن لینک در پشت اعداد BUGTRAQ. عنصر تصویر اجازه می دهد تا دو نوع ورودی. در یک بار نام یک تصویر (به عنوان مثال faq.png). در این مورد مسیر تصویر OTRS استفاده خواهد شد. احتمال و امکان دوم است برای قرار دادن لینک به تصویر.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'تعریف می کند یک فیلتر برای جمع آوری تعداد CVE از متون مقاله در AgentTicketZoom. نتایج خواهد شد در یک جعبه متا بعدی به مقاله نمایش داده شود. را پر کنید در URLPreview اگر شما می خواهم برای دیدن یک پیش نمایش در هنگام حرکت ماوس خود را بالا عنصر link. این می تواند از همان URL که در URL، بلکه یک جایگزین. لطفا توجه داشته باشید که برخی از وب سایت های انکار که در درون یک iframe (مانند گوگل) نمایش داده و به این ترتیب با حالت پیش نمایش کار نمی کند.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'تعریف می کند یک فیلتر برای پردازش متن در مقالات، به منظور برجسته کلمات کلیدی از پیش تعریف شده.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'تعریف یک عبارت منظم که در آنها از برخی از آدرس های از کنترل و بررسی گرامر (در صورت \ "CheckEmailAddresses " قرار است به \ "بله "). لطفا یک عبارت منظم در این زمینه برای آدرس ایمیل، که از لحاظ دستوری معتبر نیست وارد کنید، اما برای سیستم (یعنی \ "ریشه @ localhost را ") لازم است.',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'تعریف یک عبارت منظم است که فیلتر تمام آدرس های ایمیل  نباید در برنامه استفاده  شود.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'تعریف یک زمان خواب در میکروثانیه بین درخواست در حالی که آنها توسط یک کار پردازش شده است.',
        'Defines a useful module to load specific user options or to display news.' =>
            'تعریف یک ماژول مفید برای بارگذاری گزینه های کاربر خاص و یا برای نمایش اخبار.',
        'Defines all the X-headers that should be scanned.' => 'تعریف می کند همه X-header که باید اسکن شود.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'تعریف می کند تمام زبان هایی که در دسترس  برنامه می باشد. تنها نام انگلیسی از زبان را در اینجا مشخص کنید.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'تعریف می کند تمام زبان های که در دسترس  برنامه می باشد. تنها نام بومی زبان را در اینجا مشخص کنید.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'تعریف می کند تمام پارامترهای برای شی RefreshTime در ترجیحات مشتری رابط مشتری.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'تعریف می کند تمام پارامترهای برای ShownTickets در ترجیحات مشتری رابط مشتری شی.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'تعریف می کند تمام پارامترهای را برای این آیتم در تنظیمات مشتری.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'تعریف می کند تمام پارامترهای را برای این آیتم در تنظیمات مشتری. "PasswordRegExp اجازه می دهد تا برای مطابقت با کلمه عبور در مقابل یک عبارت منظم. تعریف حداقل تعداد کاراکتر با استفاده از \'PasswordMinSize. تعریف اگر حداقل 2 حروف کوچک و 2 نامه حروف بزرگ با تنظیم گزینه مناسب به \'1\' مورد نیاز است. تعریف: PasswordMin2Characters اگر رمز عبور نیاز به حداقل 2 نویسه (مجموعه را به 0 یا 1). "PasswordNeedDigit \'کنترل نیاز به حداقل 1 رقمی (مجموعه ای به 0 یا 1 به کنترل).',
        'Defines all the parameters for this notification transport.' => 'تعریف می کند همه پارامترها را برای این حمل و نقل اطلاع رسانی.',
        'Defines all the possible stats output formats.' => 'تعریف می کند همه امکانات فرمت آمار خروجی.',
        'Defines an alternate URL, where the login link refers to.' => 'یک Anchor را معرفی URL متناوب، که در آن لینک ورود به سیستم اشاره به.',
        'Defines an alternate URL, where the logout link refers to.' => 'یک Anchor را معرفی URL متناوب، که در آن لینک خروج از سیستم اشاره به.',
        'Defines an alternate login URL for the customer panel..' => 'یک Anchor را معرفی URL لاگین دیگر را برای پنل مشتری ..',
        'Defines an alternate logout URL for the customer panel.' => 'یک Anchor را معرفی URL خروج از سیستم جایگزین برای پنل مشتری می باشد.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'لینک های خارجی به پایگاه داده های مشتری (: یا \'\' به عنوان مثال \'؟ //yourhost/customer.php CID = [٪ Data.CustomerID٪] HTTP\') تعریف می کند.',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'تعریف می کند که از آن بلیط ویژگی های عامل می توانید سفارش نتیجه را انتخاب کنید.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'تعریف می کند که چگونه از میدان از ایمیل (ارسال از پاسخ و بلیط ایمیل) باید مانند نگاه.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'تعریف می کند اگر قبل از مرتب کردن بر اساس اولویت باید در نظر صف انجام شود.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'تعریف می کند اگر قبل از مرتب کردن بر اساس اولویت باید در نظر خدمات انجام  شود.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه نمایش بلیط نزدیک رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط می شود قفل شده است و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه نمایش خروجی ایمیل از رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه نمایش گزاف گویی بلیط رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه نوشتن بلیط رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در بلیط صفحه نمایش رو به جلو از رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در بلیط صفحه نمایش های متنی رایگان از رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه نمایش ادغام بلیط یک بلیط بزرگنمایی در رابط عامل را از مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل را از مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل را از مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در تلفن بلیط صفحه نمایش بین المللی به درون رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه نمایش خروجی تلفن بلیط رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل را از مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط در بلیط صفحه نمایش مسئول رابط عامل مورد نیاز است (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'تعریف می کند اگر یک قفل بلیط مورد نیاز برای تغییر مشتری یک بلیط در رابط عامل (اگر بلیط هنوز قفل نشده است، بلیط قفل می شود و عامل فعلی خواهد شد به طور خودکار به عنوان صاحب آن تنظیم).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'تعریف می کند اگر عوامل باید مجاز به ورود در صورتی که هیچ راز به اشتراک گذاشته شده ذخیره شده در تنظیمات خود را و در نتیجه با استفاده از احراز هویت دو عامل است.',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'تعریف می کند که پیام های تشکیل شده باید به طلسم در رابط عامل بررسی می شود.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'تعریف می کند اگر مشتریان باید مجاز به ورود در صورتی که هیچ راز به اشتراک گذاشته شده ذخیره شده در تنظیمات خود را و در نتیجه با استفاده از احراز هویت دو عامل است.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            'تعریف می کند اگر حالت پیشرفته استفاده شود (را قادر می سازد استفاده از جدول، جایگزین، زیرنویس، بالانویس، چسباندن از Word، و غیره) در رابط مشتری می باشد.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'تعریف می کند اگر حالت پیشرفته استفاده شود (را قادر می سازد استفاده از جدول، جایگزین، زیرنویس، بالانویس، چسباندن از Word، و غیره).',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'تعریف می کند در صورتی که رمز قبلا معتبر باید برای احراز هویت پذیرفته شده است. این است که کمی کمتر امن اما کاربران می دهد 30 ثانیه به زمان بیشتری برای وارد کنید رمز عبور یک بار خود را.',
        'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            'تعریف می کند اگر مقادیر فیلتر باید از تمام بلیط در دسترس بازیابی. اگر به \ "بله "، فقط مقادیر که در واقع هر بلیط در مورد استفاده برای فیلتر در دسترس خواهد بود. لطفا توجه داشته باشید: لیست مشتریان همیشه مثل این خواهد بازیابی شود.',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'تعریف می کند اگر حسابداری هم در رابط عامل الزامی است. اگر فعال شود، یک یادداشت باید برای همه اقدامات بلیط وارد (مهم نیست اگر توجه داشته باشید خود را به عنوان فعال پیکربندی و یا برای صفحه نمایش عمل بلیط فردی در اصل الزامی است).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'تعریف می کند اگر حسابداری هم باید به تمام بلیط در عمل بخش عمده تنظیم شده است.',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'تعریف می کند از قالب پیام دفتر. دو پارامتر رشته ( %s ) در دسترس: تاریخ پایان و تعداد روز باقی مانده.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'تعریف می کند که صف را بلیط برای نمایش به عنوان رویدادهای تقویم استفاده می شود.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            'تعریف می کند نام میزبان HTTP برای جمع آوری داده ها پشتیبانی با ماژول عمومی PublicSupportDataCollector، (به عنوان مثال استفاده از OTRS شبح).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'تعریف می کند بیان IP به طور منظم برای دسترسی به مخزن محلی. شما نیاز به فعال کردن دسترسی به این دارند به مخزن محلی خود و بسته :: RepositoryList در میزبان راه دور مورد نیاز است.',
        'Defines the URL CSS path.' => 'تعریف می کند که مسیر URL CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'تعریف می کند که URL مسیر پایه از آیکون ها، CSS و جاوا اسکریپت.',
        'Defines the URL image path of icons for navigation.' => 'تعریف می کند که URL مسیر تصویر از آیکون برای ناوبری.',
        'Defines the URL java script path.' => 'تعریف می کند که مسیر URL جاوا اسکریپت.',
        'Defines the URL rich text editor path.' => 'تعریف می کند URL غنی مسیر ویرایشگر متن.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'تعریف می کند که آدرس یک سرور DNS اختصاص داده شده، در صورت لزوم، برای \ "CheckMXRecord " نگاه یو پی اس.',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'تعریف می کند کلید تنظیمات عامل که در آن کلید رمز مشترک ذخیره شده است.',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'تعریف می کند که متن برای ایمیل اطلاع رسانی فرستاده شده به عوامل، در مورد کلمه عبور جدید (پس از استفاده از این لینک رمز عبور جدید ارسال خواهد شد).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'تعریف می کند که متن برای ایمیل اطلاع رسانی فرستاده شده به عوامل، با رمز در مورد رمز عبور جدید درخواست (پس از استفاده از این لینک رمز عبور جدید ارسال خواهد شد).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'تعریف می کند که متن برای ایمیل اطلاع رسانی ارسال شده به مشتریان، در مورد حساب کاربری جدید.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'تعریف می کند که متن برای ایمیل اطلاع رسانی ارسال شده به مشتریان، در مورد کلمه عبور جدید (پس از استفاده از این لینک رمز عبور جدید ارسال خواهد شد).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'تعریف می کند که متن برای ایمیل اطلاع رسانی به مشتریان ارسال با رمز در مورد رمز عبور جدید درخواست (پس از استفاده از این لینک رمز عبور جدید ارسال خواهد شد).',
        'Defines the body text for rejected emails.' => 'تعریف می کند که متن برای ایمیل را رد کرد.',
        'Defines the calendar width in percent. Default is 95%.' => 'پهنای تقویم در درصد است. به طور پیش فرض 95٪ است.',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            'تعریف می کند که شناسه گره خوشه. این است که تنها در پیکربندی خوشه است که در آن بیش از یک سیستم ظاهر OTRS وجود دارد استفاده می شود. توجه: تنها مقادیر از 1 تا 99 مجاز است.',
        'Defines the column to store the keys for the preferences table.' =>
            'تعریف می کند که ستون برای ذخیره کلید برای جدول تنظیمات است.',
        'Defines the config options for the autocompletion feature.' => 'تعریف می کند که گزینه های پیکربندی برای قابلیت تکمیل خودکار است.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'تعریف می کند که پارامترهای پیکربندی از این آیتم، به  نظردر تنظیمات نشان داده میشود.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.' =>
            'تعریف می کند که پارامترهای پیکربندی از این آیتم، به در نظر تنظیمات نشان داده شود. "PasswordRegExp اجازه می دهد تا برای مطابقت با کلمه عبور در مقابل یک عبارت منظم. تعریف حداقل تعداد کاراکتر با استفاده از \'PasswordMinSize. تعریف اگر حداقل 2 حروف کوچک و 2 نامه حروف بزرگ با تنظیم گزینه مناسب به \'1\' مورد نیاز است. تعریف: PasswordMin2Characters اگر رمز عبور نیاز به حداقل 2 نویسه (مجموعه را به 0 یا 1). "PasswordNeedDigit \'کنترل نیاز به حداقل 1 رقمی (مجموعه ای به 0 یا 1 به کنترل). "PasswordMaxLoginFailed اجازه می دهد تا به مجموعه ای از یک عامل برای نامعتبر به طور موقت اگر حداکثر باری رسیده شکست خورده است.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'تعریف می کند که پارامترهای پیکربندی از این آیتم، به در نظر تنظیمات نشان داده شود. مراقبت برای حفظ لغت نامه نصب شده در سیستم در بخش داده ها.',
        'Defines the connections for http/ftp, via a proxy.' => 'تعریف می کند که ارتباطات به HTTP / FTP، از طریق یک پروکسی است.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'تعریف می کند کلید ترجیحات مشتری که در آن کلید رمز مشترک ذخیره شده است.',
        'Defines the date input format used in forms (option or input fields).' =>
            'تعریف فرمت تاریخ ورودی مورد استفاده در اشکال (گزینه و یا ورودی زمینه).',
        'Defines the default CSS used in rich text editors.' => 'تعریف می کند که CSS به طور پیش فرض مورد استفاده در ویرایشگرهای متن غنی است.',
        'Defines the default auto response type of the article for this operation.' =>
            'تعریف می کند که به طور پیش فرض نوع پاسخ خودکار مقاله برای این عملیات.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'تعریف می کند که بدن به طور پیش فرض از توجه داشته باشید در بلیط صفحه نمایش های متنی رایگان از رابط عامل.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            'تعریف می کند که تم پیش فرض جلویی (HTML) به توسط عوامل و مشتریان استفاده می شود. اگر دوست دارید، شما می توانید موضوع خود را اضافه کنید. لطفا کتابچه راهنمای کاربر مدیر واقع در http://otrs.github.io/doc/ مراجعه کنید.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'زبان پیش فرض جلویی تعریف می کند. همه مقادیر ممکن توسط فایل های زبان موجود بر روی سیستم (تنظیمات بعدی را ببینید) تعیین می شود.',
        'Defines the default history type in the customer interface.' => 'تعریف می کند که به طور پیش فرض نوع تاریخ در رابط مشتری.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'تعریف می کند که به طور پیش فرض حداکثر تعداد محور X ویژگی برای مقیاس زمانی.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'تعریف می کند که به طور پیش فرض حداکثر تعداد آمار در هر صفحه بر روی صفحه نمایش مرور کلی.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'تعریف می کند که به طور پیش فرض حالت بعدی یک بلیط از مشتری پیگیری در رابط مشتری برای.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی به طور پیش فرض یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش بلیط نزدیک رابط عامل.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی به طور پیش فرض یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش فله بلیط رابط عامل.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی به طور پیش فرض یک بلیط پس از اضافه کردن یک یادداشت، در بلیط صفحه نمایش های متنی رایگان از رابط عامل.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی به طور پیش فرض یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که دولت بعدی به طور پیش فرض یک بلیط پس از اضافه کردن یک یادداشت، در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که دولت بعدی به طور پیش فرض یک بلیط پس از اضافه کردن یک یادداشت، در بلیط صفحه نمایش در حال بررسی یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که دولت بعدی به طور پیش فرض یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی به طور پیش فرض یک بلیط پس از اضافه کردن یک یادداشت، در بلیط صفحه نمایش مسئول رابط عامل.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض حالت یک بلیط بعد از بعدی بودن منعکس، در صفحه نمایش گزاف گویی بلیط رابط عامل.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض حالت یک بلیط بعد از بعدی بودن فرستاده، در بلیط صفحه نمایش رو به جلو از رابط عامل.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض بعدی دولت یک بلیط پس از پیام ارسال شده است، در صفحه نمایش خروجی ایمیل از رابط عامل.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض حالت بعدی یک بلیط اگر آن تشکیل شده است از / پاسخ در صفحه نوشتن بلیط رابط عامل.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض متن توجه داشته باشید بدن برای بلیط تلفن در گوشی بلیط صفحه نمایش بین المللی به درون رابط عامل.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض متن توجه داشته باشید بدن برای بلیط تلفن در صفحه نمایش خروجی تلفن بلیط رابط عامل.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'تعریف می کند که اولویت پیش فرض درخواست مشتری پیگیری در صفحه نمایش زوم درخواست در رابط مشتری است .',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'تعریف می کند که اولویت پیش فرض درخواست مشتری جدید در رابط مشتری است. ',
        'Defines the default priority of new tickets.' => 'تعریف می کند که اولویت پیش فرض درخواست جدید است.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'تعریف می کند که صف به طور پیش فرض برای درخواست مشتری جدید در رابط مشتری است.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'تعریف می کند، انتخاب پیش فرض در منوی کشویی برای اشیاء پویا (فرم: مشخصات مشترک).است',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'تعریف می کند، انتخاب پیش فرض در منوی کشویی برای مجوز (فرم: مشخصات مشترک).است',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'تعریف می کند، انتخاب پیش فرض در منوی کشویی برای فرمت آمار (فرم: مشخصات مشترک). لطفا کلید فرمت را وارد (آمار :: قالب مراجعه کنید).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض نوع فرستنده برای بلیط تلفن در گوشی بلیط صفحه نمایش بین المللی به درون رابط عامل.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض نوع فرستنده برای بلیط تلفن در صفحه نمایش خروجی تلفن بلیط رابط عامل.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'تعریف می کند که به طور پیش فرض نوع فرستنده برای بلیط در روی صفحه نمایش زوم بلیط رابط مشتری.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'تعریف می کند که به طور پیش فرض نشان داده بلیط ویژگی جستجو برای صفحه نمایش جستجو بلیط (AllTickets / ArchivedTickets / NotArchivedTickets).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'تعریف می کند که به طور پیش فرض نشان داده بلیط ویژگی جستجو برای صفحه نمایش جستجو بلیط.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'تعریف می کند که به طور پیش فرض نشان داده بلیط ویژگی جستجو برای صفحه نمایش جستجو بلیط. به عنوان مثال: \ "کلید " باید نام زمینه پویا در این مورد \'X\'، \ "محتوا "، باید ارزش درست پویا بسته به نوع پویا درست، متن را داشته باشد: یک متن، کرکره : \'1\'، تاریخ / زمان: Search_DynamicField_XTimeSlotStartYear = 1974؛ Search_DynamicField_XTimeSlotStartMonth = 01؛ Search_DynamicField_XTimeSlotStartDay = 26؛ Search_DynamicField_XTimeSlotStartHour = 00؛ Search_DynamicField_XTimeSlotStartMinute = 00؛ Search_DynamicField_XTimeSlotStartSecond = 00؛ Search_DynamicField_XTimeSlotStopYear = 2013؛ Search_DynamicField_XTimeSlotStopMonth = 01؛ Search_DynamicField_XTimeSlotStopDay = 26؛ Search_DynamicField_XTimeSlotStopHour = 23؛ Search_DynamicField_XTimeSlotStopMinute = 59؛ Search_DynamicField_XTimeSlotStopSecond = 59؛ \' و یا "Search_DynamicField_XTimePointFormat = هفته؛ Search_DynamicField_XTimePointStart = قبل از. Search_DynamicField_XTimePointValue = 7 \'؛.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'تعریف می کند که به طور پیش فرض مرتب سازی بر معیارهای برای همه صف نمایش داده شده در نمایش صف.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'تعریف می کند که به طور پیش فرض مرتب سازی بر معیارهای برای همه خدمات نمایش داده شده در نمایش خدمات.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'تعریف می کند که به طور پیش فرض مرتب کردن برای همه صف در نظر صف، پس از مرتب سازی بر اولویت است.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'تعریف می کند که به طور پیش فرض مرتب کردن برای همه خدمات در نظر خدمات، پس از مرتب کردن اولویت است.',
        'Defines the default spell checker dictionary.' => 'تعریف می کند  به طور پیش فرض فرهنگ لغت جستجوگر املا درست است',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'تعریف می کند که حالت پیش فرض از درخواست مشتری جدید در رابط مشتری است.',
        'Defines the default state of new tickets.' => 'تعریف می کند که حالت پیش فرض از درخواست های جدید است.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'تعریف می کند که موضوع به طور پیش فرض برای بلیط تلفن در گوشی بلیط صفحه نمایش بین المللی به درون رابط عامل.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'تعریف می کند که موضوع به طور پیش فرض برای بلیط تلفن در صفحه نمایش خروجی تلفن بلیط رابط عامل.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'تعریف می کند که موضوع به طور پیش فرض از توجه داشته باشید در بلیط صفحه نمایش های متنی رایگان از رابط عامل.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'تعریف می کند که به طور پیش فرض تعدادی از ثانیه (از زمان فعلی) به دوباره برنامه یک رابط شکست خورده کار عمومی است.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'تعریف می کند که به طور پیش فرض ویژگی بلیط برای بلیط مرتب سازی در یک جستجو بلیط رابط مشتری.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض ویژگی بلیط برای بلیط مرتب سازی در نظر تشدید رابط عامل.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض ویژگی بلیط برای بلیط مرتب سازی در نظر بلیط قفل رابط عامل.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض ویژگی بلیط برای بلیط مرتب سازی در نظر مسئول رابط عامل.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض ویژگی بلیط برای بلیط مرتب سازی در نمایش وضعیت رابط عامل.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض ویژگی بلیط برای بلیط مرتب سازی در نظر دیده بان رابط عامل.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض ویژگی بلیط برای مرتب سازی بلیط از نتیجه جستجو بلیط رابط عامل.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'تعریف می کند که به طور پیش فرض ویژگی بلیط برای مرتب سازی بلیط از نتیجه جستجو بلیط این عملیات.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض بلیط اطلاع رسانی برای مشتری / فرستنده در صفحه نمایش گزاف گویی بلیط رابط عامل میره.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض بلیط دولت بعد و پس از اضافه کردن یک یادداشت تلفن در گوشی بلیط صفحه نمایش بین المللی به درون رابط عامل.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'تعریف می کند که به طور پیش فرض بلیط دولت بعد و پس از اضافه کردن یک یادداشت تلفن در صفحه نمایش خروجی تلفن بلیط رابط عامل.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'تعریف می کند که سفارش بلیط به طور پیش فرض (پس از مرتب کردن اولویت) در نظر تشدید رابط عامل. تا: قدیمی ترین در بالای صفحه. پایین: شدن در بالای صفحه.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'تعریف می کند که سفارش بلیط به طور پیش فرض (پس از مرتب کردن اولویت) در نظر وضعیت رابط عامل. تا: قدیمی ترین در بالای صفحه. پایین: شدن در بالای صفحه.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'تعریف می کند که به طور پیش فرض سفارش بلیط در نظر مسئول رابط عامل. تا: قدیمی ترین در بالای صفحه. پایین: شدن در بالای صفحه.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'تعریف می کند که به طور پیش فرض سفارش بلیط در نظر بلیط قفل رابط عامل. تا: قدیمی ترین در بالای صفحه. پایین: شدن در بالای صفحه.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'تعریف می کند که به طور پیش فرض سفارش بلیط در نتیجه جستجو بلیط رابط عامل. تا: قدیمی ترین در بالای صفحه. پایین: شدن در بالای صفحه.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'تعریف می کند که به طور پیش فرض سفارش بلیط در نتیجه جستجو بلیط از این عملیات. تا: قدیمی ترین در بالای صفحه. پایین: شدن در بالای صفحه.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'تعریف می کند که به طور پیش فرض سفارش بلیط در نظر دیده بان رابط عامل. تا: قدیمی ترین در بالای صفحه. پایین: شدن در بالای صفحه.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'تعریف می کند که به طور پیش فرض سفارش بلیط از یک نتیجه جستجو در رابط مشتری. تا: قدیمی ترین در بالای صفحه. پایین: شدن در بالای صفحه.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'تعریف می کند که اولویت درخواست به طور پیش فرض در صفحه نمایش درخواست نزدیک رابط عامل است .',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'تعریف می کند که اولویت بلیط به طور پیش فرض در صفحه نمایش فله بلیط رابط عامل.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'تعریف می کند که اولویت بلیط به طور پیش فرض در بلیط صفحه نمایش های متنی رایگان از رابط عامل.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'تعریف می کند که اولویت بلیط به طور پیش فرض در صفحه نمایش توجه داشته باشید بلیط رابط عامل.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که اولویت بلیط به طور پیش فرض در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که اولویت بلیط به طور پیش فرض در بلیط صفحه نمایش در حال بررسی یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که اولویت بلیط به طور پیش فرض در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'تعریف می کند که اولویت درخواست به طور پیش فرض در درخواست صفحه نمایش مسئول رابط عامل است.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'تعریف می کند که به طور پیش فرض نوع بلیط برای بلیط مشتری جدید در رابط مشتری.',
        'Defines the default ticket type.' => 'تعریف می کند که نوع درخواست به طور پیش فرض است.',
        'Defines the default type for article in the customer interface.' =>
            'تعریف می کند که نوع پیش فرض برای مقاله در رابط مشتری است.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'تعریف می کند نوع طور پیش فرض از پیام فرستاده شده در بلیط صفحه نمایش رو به جلو از رابط عامل.',
        'Defines the default type of the article for this operation.' => 'تعریف می کند که نوع پیش فرض مقاله برای این عملیات است.',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            'تعریف می کند نوع طور پیش فرض از ارسال در صفحه نمایش خروجی ایمیل از رابط عامل.',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در صفحه نمایش بلیط نزدیک رابط عامل.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در صفحه نمایش فله بلیط رابط عامل.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در بلیط صفحه نمایش های متنی رایگان از رابط عامل.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در صفحه نمایش توجه داشته باشید بلیط رابط عامل.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در بلیط صفحه نمایش در حال بررسی یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در تلفن بلیط صفحه نمایش بین المللی به درون رابط عامل.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در صفحه نمایش خروجی تلفن بلیط رابط عامل.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در بلیط صفحه نمایش مسئول رابط عامل.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'تعریف می کند که نوع پیش فرض از توجه داشته باشید در صفحه نمایش زوم بلیط رابط مشتری.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'تعریف می کند که به طور پیش فرض استفاده می شود ظاهر ماژول اگر هیچ پارامتر اقدام داده شده در URL در رابط عامل.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'تعریف می کند که به طور پیش فرض استفاده می شود ظاهر ماژول اگر هیچ پارامتر اقدام داده شده در URL در رابط مشتری.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'مقدار پیش فرض برای پارامتر عمل برای ظاهر عمومی است. پارامتر عمل در اسکریپت از سیستم استفاده می شود.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'تعریف می کند که به طور پیش فرض انواع فرستنده قابل مشاهده یک بلیط (به طور پیش فرض: مشتری).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'تعریف می کند که زمینه های پویا هستند که برای نمایش بر روی رویدادهای تقویم استفاده می شود.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'تعریف می کند که مسیر پاییز پشت برای باز کردن باینری fetchmail مشاهده کنید. توجه: نام باینری نیاز به \'کامند fetchmail "، در صورت متفاوت است مدیر یک پیوند نمادین استفاده کنید.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'تعریف می کند که فیلتر است که پردازش متن در مقالات، به منظور برجسته آدرس ها.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'تعریف فرمت پاسخها را در صفحه نوشتن بلیط رابط عامل ([٪ Data.OrigFrom | HTML٪] است از 1: 1، [٪ Data.OrigFromName | HTML٪] تنها realname از از است).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'تعریف می کند که نام مناسب دامنه از سیستم. این تنظیم به عنوان یک متغیر، OTRS_CONFIG_FQDN است که در تمام اشکال پیام استفاده شده توسط برنامه، برای ساخت لینک به بلیط در سیستم شما یافت استفاده می شود.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'تعریف می کند که گروه های هر کاربر مشتری در خواهد بود (اگر CustomerGroupSupport فعال است و شما نمی خواهید به مدیریت هر کاربر برای این گروه ها).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'تعریف می کند که ارتفاع برای غنی جزء ویرایشگر متن برای این صفحه نمایش. تعداد (پیکسل) یا ارزش درصد (نسبی) را وارد کنید.',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'تعریف می کند که ارتفاع برای غنی جزء ویرایشگر متن. تعداد (پیکسل) یا ارزش درصد (نسبی) را وارد کنید.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای عمل روی صفحه نمایش بلیط نزدیک، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای عمل روی صفحه نمایش بلیط ایمیل، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای عمل روی صفحه نمایش بلیط تلفن، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'تعریف می کند که نظر تاریخ برای بلیط رایگان عمل صفحه نمایش متن، می شود که برای تاریخ بلیط استفاده می شود.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای عمل روی صفحه نمایش توجه داشته باشید بلیط، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای عمل روی صفحه نمایش صاحب بلیط، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای عمل روی صفحه نمایش بلیط در انتظار، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای گوشی بلیط عمل روی صفحه نمایش ورودی، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای گوشی بلیط عمل روی صفحه نمایش خروجی، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای عمل روی صفحه نمایش اولویت بلیط، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای بلیط عمل صفحه نمایش مسئول، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'تعریف می کند که نظر تاریخ برای بزرگنمایی بلیط، می شود که برای تاریخ بلیط در رابط مشتری استفاده می شود.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند که نظر تاریخ برای این عملیات، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای عمل روی صفحه نمایش بلیط نزدیک، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای عمل روی صفحه نمایش بلیط ایمیل، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای عمل روی صفحه نمایش بلیط تلفن، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'تعریف می کند نوع تاریخ برای بلیط رایگان عمل صفحه نمایش متن، می شود که برای تاریخ بلیط استفاده می شود.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای عمل روی صفحه نمایش توجه داشته باشید بلیط، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای عمل روی صفحه نمایش صاحب بلیط، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای بلیط در انتظار عمل روی صفحه نمایش، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای گوشی بلیط عمل روی صفحه نمایش ورودی، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای گوشی بلیط عمل روی صفحه نمایش خروجی، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای عمل روی صفحه نمایش اولویت بلیط، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای بلیط عمل صفحه نمایش مسئول، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'تعریف می کند نوع تاریخ برای بزرگنمایی بلیط، می شود که برای تاریخ بلیط در رابط مشتری استفاده می شود.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'تعریف می کند نوع تاریخ برای این عملیات، می شود که برای تاریخ بلیط در رابط عامل استفاده می شود.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'تعریف می کند که ساعت و روز هفته  برای شمارش زمان کاردر تقویم نشان داده میشود.',
        'Defines the hours and week days to count the working time.' => 'تعریف می کند که ساعت و روز هفته برای شمارش زمان کار است.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'تعریف می کند که کلید با هسته :: :: ماژول AgentInfo بررسی می شود. اگر این تنظیمات کلید کاربر درست است، این پیام است که توسط سیستم پذیرفته شده است.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'تعریف می کند که کلید را چک کنید با CustomerAccept. اگر این تنظیمات کلید کاربر درست است، پس از آن پیام است که توسط سیستم پذیرفته شده است.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'تعریف می کند نوع لینک \'عادی\'. اگر نام منبع و نام هدف حاوی همان مقدار از لینک در نتیجه غیر جهت است؛ در غیر این صورت، در نتیجه یک لینک جهت است.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'تعریف می کند نوع لینک "ParentChild. اگر نام منبع و نام هدف حاوی همان مقدار از لینک در نتیجه غیر جهت است؛ در غیر این صورت، در نتیجه یک لینک جهت است.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'تعریف می کند که گروه های نوع لینک. انواع لینک از همان گروه دیگری را لغو نمایید. مثال: اگر بلیط در هر یک لینک \'عادی\' با بلیط B مرتبط است، پس از آن این بلیط را می توان علاوه بر این با لینک رابطه یک ParentChild، مرتبط است.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'لیستی از مخازن آنلاین. نصب و راه اندازی دیگری را می توان به عنوان مخزن مورد استفاده برای عنوان مثال: کلید = \ "از http: //example.com/otrs/public.pl اقدام = PublicRepository؛ فایل = " و محتوا = \ "برخی از نام ".',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'لیستی از اقدامات بعدی ممکن است در یک صفحه خطا، یک مسیر کامل مورد نیاز است، پس از آن ممکن است برای اضافه کردن لینک های خارجی در صورت نیاز.',
        'Defines the list of types for templates.' => 'لیستی از انواع برای قالب تعریف میکند.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'تعریف می کند محل برای دریافت لیست مخزن آنلاین برای بسته های اضافی. اولین نتیجه در دسترس استفاده خواهد شد.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'تعریف می کند ماژول ورود به سیستم برای سیستم. \ "فایل " می نویسد: تمام پیام ها در یک فایل تاریخچه ثبت داده می شود، \ "syslog را " با استفاده از شبح syslog را از سیستم، به عنوان مثال و syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'تعریف می کند به اندازه حداکثر (در بایت) برای ارسال فایل از طریق مرورگر. هشدار: تنظیم این گزینه بر یک ارزش است که خیلی کم می تواند از ماسک های بسیاری در مثال OTRS شما می شود برای جلوگیری از کار (احتمالا هر ماسک که طول می کشد ورودی از کاربر).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'تعریف می کند که حداکثر زمان معتبر (در ثانیه) برای یک ID را وارد نمایید.',
        'Defines the maximum number of affected tickets per job.' => 'تعریف می کند که حداکثر تعداد درخواست های آسیب دیده در هر کاررا اعلام کنید.',
        'Defines the maximum number of pages per PDF file.' => 'تعریف می کند که حداکثر تعداد صفحه درهر فایل PDF. چه مقدار است',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'تعریف و حداکثر تعداد خطوط به نقل از پاسخ آن اضافه شود.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'تعریف حداکثر تعداد از وظایف را به عنوان همان زمان اجرا شود.',
        'Defines the maximum size (in MB) of the log file.' => 'تعریف می کند که حداکثر اندازه (در MB) از فایل وارد شوید.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'تعریف می کند که حداکثر اندازه در کیلوبایت پاسخ GenericInterface که به جدول gi_debugger_entry_content وارد شده است.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'تعریف می کند که نشان می دهد یک ماژول است که اطلاع رسانی عمومی در رابط عامل. در هر دو صورت \ "متن " - در صورت پیکربندی - و یا محتویات \ "فایل " نمایش داده خواهد شد.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'ماژول است که همه به در حال حاضر در عوامل در رابط عامل وارد تعریف می کند.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            'ماژول است که همه به در حال حاضر در مشتریان در رابط عامل وارد تعریف می کند.',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            'تعریف می کند ماژول که نشان می دهد در حال حاضر در عوامل در رابط مشتری وارد سایت شوید.',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            'تعریف می کند ماژول که نشان می دهد در حال حاضر در مشتریان در رابط مشتری وارد سایت شوید.',
        'Defines the module to authenticate customers.' => 'تعریف می کند که ماژول برای تأیید هویت مشتریان است.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            'تعریف می کند که ماژول برای نمایش اطلاع رسانی اگر خدمات ابر غیر فعال هستند.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'تعریف می کند که ماژول برای نمایش اطلاع رسانی در رابط های مختلف در مناسبت های مختلف برای OTRS کسب و کار راه حل ™.',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            'تعریف می کند که ماژول برای نمایش اطلاع رسانی در رابط عامل اگر OTRS شبح حال اجرا نیست.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'تعریف می کند که ماژول برای نمایش اطلاع رسانی در رابط عامل، اگر عامل در حالی که داشتن خارج از دفتر فعال وارد سایت شوید.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'تعریف می کند که ماژول برای نمایش اطلاع رسانی در رابط عامل، اگر عامل در حالی که داشتن تعمیر و نگهداری سیستم فعال وارد سایت شوید.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            'تعریف می کند که ماژول برای نمایش اطلاع رسانی در رابط عامل، اگر عامل محدود جلسه هشدار قبلی رسیده است.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'ماژول برای نمایش اطلاع رسانی در رابط عامل، در صورتی که سیستم توسط کاربر مدیریت استفاده را تعریف می کند (به طور معمول شما باید به عنوان مدیر کار نمی کند).',
        'Defines the module to generate code for periodic page reloads.' =>
            'تعریف می کند که ماژول تولید کد برای بارگذاری مجدد صفحه تناوبی است.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'تعریف می کند که ماژول برای ارسال ایمیل. \ "Sendmail باشد " به طور مستقیم با استفاده از باینری از sendmail از سیستم عامل خود را. هر یک از \ "SMTP " مکانیزم استفاده از یک (خارجی) mailserver ای مشخص شده است. \ "DoNotSendEmail " به ایمیل ارسال کنید و آن را برای سیستم های تست مفید است.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'تعریف می کند ماژول استفاده می شود برای ذخیره داده ها جلسه. با \ "DB " سرور ظاهر می توانید از سرور دسیبل برابر خرد. \ "FS " سریع تر است.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'تعریف می کند که نام برنامه، نشان داده شده در رابط وب، زبانه ها و نوار عنوان مرورگر وب.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'تعریف می کند که نام ستون برای ذخیره داده ها در جدول تنظیمات.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'تعریف می کند که نام ستون برای ذخیره شناسه کاربر در جدول تنظیمات.',
        'Defines the name of the indicated calendar.' => 'تعریف می کند که نام تقویم نشان داد.',
        'Defines the name of the key for customer sessions.' => 'تعریف می کند که نام کلید برای جلسات مشتری می باشد.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'تعریف می کند که نام کلید جلسه. به عنوان مثال جلسه، SESSIONID یا OTRS.',
        'Defines the name of the table where the user preferences are stored.' =>
            'تعریف می کند که نام جدول که در آن تنظیمات کاربر ذخیره می شود.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'تعریف می کند که حالت ممکن بعدی را بعد از ترکیب / پاسخ یک بلیط در صفحه نوشتن بلیط رابط عامل.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'تعریف می کند که حالت ممکن بعد و پس از حمل و نقل یک بلیط در بلیط صفحه نمایش رو به جلو از رابط عامل.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'تعریف می کند که حالت ممکن بعدی پس از ارسال پیام در صفحه نمایش خروجی ایمیل از رابط عامل.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'تعریف می کند که حالت ممکن بعدی برای بلیط مشتری در رابط مشتری.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش بلیط نزدیک رابط عامل.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش فله بلیط رابط عامل.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از اضافه کردن یک یادداشت، در بلیط صفحه نمایش های متنی رایگان از رابط عامل.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از اضافه کردن یک یادداشت، در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از اضافه کردن یک یادداشت، در روی صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از اضافه کردن یک یادداشت، در بلیط صفحه نمایش مسئول رابط عامل.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از منعکس، در صفحه نمایش گزاف گویی بلیط رابط عامل.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'تعریف می کند که دولت بعدی یک بلیط پس از به صف دیگری نقل مکان کرد، در روی صفحه نمایش بلیط حرکت از رابط عامل.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'تعریف تعداد کاراکتر در هر خط مورد استفاده در مورد یک HTML جایگزینی پیش نمایش مقاله در TemplateGenerator برای EventNotifications.',
        'Defines the number of days to keep the daemon log files.' => 'تعریف تعداد روز برای حفظ فایل ورود به سیستم شبح.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'تعریف تعداد فیلدهای هدر در ماژول ظاهر برای اضافه کردن و به روز رسانی فیلتر رئيس پست. آن را می توانید تا 99 زمینه باشد.',
        'Defines the parameters for the customer preferences table.' => 'تعریف می کند که پارامترهای جدول ترجیحات مشتری.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'تعریف می کند که پارامترهای باطن داشبورد. \ "CMD " جهت تعیین دستور با پارامترهای. \ "گروه " استفاده می شود برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " نشان می دهد اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTL " را نشان می دهد انقضای دوره کش در دقیقه برای پلاگین.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'تعریف می کند که پارامترهای باطن داشبورد. \ "گروه " استفاده می شود برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " نشان می دهد اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTL " را نشان می دهد انقضای دوره کش در دقیقه برای پلاگین.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'تعریف می کند که پارامترهای باطن داشبورد. \ "گروه " استفاده می شود برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " نشان می دهد اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " تعریف انقضای دوره کش در دقیقه برای پلاگین.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'تعریف می کند که پارامترهای باطن داشبورد. \ "محدود " تعریف می کند تعداد ورودی نمایش داده به طور پیش فرض. \ "گروه " استفاده می شود برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " نشان می دهد اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTL " را نشان می دهد انقضای دوره کش در دقیقه برای پلاگین.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'تعریف می کند که پارامترهای باطن داشبورد. \ "محدود " تعریف می کند تعداد ورودی نمایش داده به طور پیش فرض. \ "گروه " استفاده می شود برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " نشان می دهد اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " تعریف انقضای دوره کش در دقیقه برای پلاگین.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'تعریف می کند که رمز عبور برای دسترسی به دسته SOAP (بن / cgi-bin در / rpc.pl). کدام است',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'تعریف می کند که مسیر و TTF-فایل که مسئولیت رسیدگی به جسورانه قلم تکفاصله کج در اسناد PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'تعریف می کند که مسیر و TTF-فایل که مسئولیت رسیدگی به جسورانه فونت متناسب با حالت های italic در اسناد PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'تعریف می کند که مسیر و TTF-فایل که مسئولیت رسیدگی به قلم تکفاصله جسورانه در اسناد PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'تعریف می کند که مسیر و TTF-فایل که مسئولیت رسیدگی به فونت متناسب با حروف درشت در اسناد PDF. را دارد',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'تعریف می کند که مسیر و TTF-فایل که مسئولیت رسیدگی به قلم تکفاصله کج در اسناد PDF. را دارد',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'تعریف می کند که مسیر و TTF-فایل که مسئولیت رسیدگی به فونت متناسب با حالت های italic در اسناد PDF. را دارد',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'تعریف می کند که مسیر و TTF-فایل که مسئولیت رسیدگی به قلم تکفاصله در اسناد PDF. را دارد',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'تعریف می کند که مسیر و TTF-فایل که مسئولیت رسیدگی به فونت متناسب در اسناد PDF. را دارد',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'تعریف می کند که مسیر فایل اطلاعات نشان داده شده است،  در زیر هسته / خروجی / HTML / قالب / استاندارد / CustomerAccept.tt واقع شده است.',
        'Defines the path to PGP binary.' => 'تعریف می کند که مسیر به باینری PGP.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'تعریف می کند که مسیر برای باز کردن باینری SSL. این ممکن است یک پاکت HOME نیاز ($ ENV {HOME} = \'/ var / معاونت / wwwrun\'؛).',
        'Defines the postmaster default queue.' => 'تعریف می کند  به طور پیش فرض صف رئيس پست را.',
        'Defines the priority in which the information is logged and presented.' =>
            'تعریف می کند که اولویت است که در آن اطلاعات وارد شده و ارائه شده است.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'تعریف می کند که هدف دریافت کننده بلیط تلفن و فرستنده بلیط ایمیل (\ "صف " را نشان می دهد تمام صف، \ "آدرس سیستم " تمام آدرس های سیستم) در رابط عامل.',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'تعریف می کند که هدف دریافت کننده بلیط (\ "صف " را نشان می دهد تمام صف، \ "SystemAddress " نشان می دهد تنها صف که به آدرس سیستم اختصاص داده) در رابط مشتری.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'تعریف می کند که مجوز مورد نیاز برای نشان دادن یک درخواست در نظر تشدید رابط عامل است.',
        'Defines the search limit for the stats.' => ' حد جستجو برای آمار را تعریف می کند.',
        'Defines the sender for rejected emails.' => 'تعریف می کند که فرستنده ایمیل را رد کرد.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'تعریف می کند که جدا کننده بین عوامل نام واقعی و با توجه به آدرس ایمیل صف.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'تعریف می کند که مجوز استاندارد برای مشتریان داخل نرم افزار. اگر مجوزهای بیشتری مورد نیاز است، شما می توانید آنها را در اینجا وارد کنید. مجوز باید سخت کدگذاری موثر باشد. لطفا اطمینان حاصل شود، در هنگام اضافه کردن هر یک از مجوز مزبور، که \ "RW " اجازه آخرین ورود باقی مانده است.',
        'Defines the standard size of PDF pages.' => ' اندازه استاندارد برای صفحات PDF. تعریف می کند ',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'تعریف می کند که دولت یک بلیط اگر می شود پیگیری و بلیط در حال حاضر بسته شده است.',
        'Defines the state of a ticket if it gets a follow-up.' => 'تعریف می کند که دولت یک بلیط اگر می شود پیگیری.',
        'Defines the state type of the reminder for pending tickets.' => 'تعریف می کند نوع دولت از یادآوری برای انتظار بلیط.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'تعریف می کند این موضوع برای ایمیل های آگاه سازی فرستاده شده به عوامل، در مورد رمز عبور جدید.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'تعریف می کند این موضوع برای ایمیل های آگاه سازی فرستاده شده به عوامل، با رمز در مورد کلمه عبور جدید درخواست شده است.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'تعریف می کند این موضوع برای ایمیل های آگاه سازی فرستاده شده به مشتریان، در مورد حساب کاربری جدید.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'تعریف می کند این موضوع برای ایمیل های آگاه سازی فرستاده شده به مشتریان، در مورد رمز عبور جدید.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'تعریف می کند این موضوع برای ایمیل های آگاه سازی فرستاده شده به مشتریان، با رمز در مورد کلمه عبور جدید درخواست شده است.',
        'Defines the subject for rejected emails.' => 'تعریف می کند که موضوع برای ایمیل را رد کرد.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'تعریف می کند آدرس ایمیل مدیر سیستم است. از آن خواهد شد در صفحه نمایش خطا از نرم افزار نمایش داده شود.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'تعریف می کند شناسه سیستم. هر عدد بلیط و جلسه HTTP رشته شامل این ID. این تضمین می کند که تنها بلیط که متعلق به سیستم شما خواهد شد به شرح زیر یو پی اس (در هنگام برقراری ارتباط بین دو نمونه از OTRS مفید) پردازش شده است.',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'تعریف می کند ویژگی target در لینک به پایگاه داده های مشتری خارجی. به عنوان مثال \'AsPopup PopupType_TicketAction.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'تعریف می کند ویژگی target در لینک به پایگاه داده های مشتری خارجی. به عنوان مثال \'هدف = \ "CDB ".',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'تعریف می کند زمینه های بلیط که در حال رفتن به رویدادهای تقویم نمایش داده شود. در \ "کلید " تعریف درست و یا بلیط خاصیت ها و \ "محتوا " نام صفحه نمایش تعریف می کند.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'تعریف می کند که منطقه زمانی از تقویم نشان داد، که می تواند بعدا به صف خاص اختصاص داده شود.',
        'Defines the two-factor module to authenticate agents.' => 'تعریف می کند ماژول دو عامل به اعتبار عوامل.',
        'Defines the two-factor module to authenticate customers.' => 'تعریف می کند ماژول دو عامل به اعتبار مشتریان.',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'تعریف می کند نوع پروتکل مورد استفاده توسط وب سرور، برای خدمت به نرم افزار است. اگر پروتکل HTTPS به جای HTTP ساده استفاده می شود، در اینجا باید مشخص شود. از آنجا که این هیچ در تنظیمات و یا رفتار وب سرور تاثیر می گذارد، آن را به روش دسترسی به برنامه را تغییر دهید، و اگر آن اشتباه است، آن را به شما از ورود به نرم افزار جلوگیری نمی کند. این تنظیم فقط به عنوان یک متغیر، OTRS_CONFIG_HttpType است که در تمام اشکال پیام استفاده شده توسط برنامه پیدا شده است استفاده می شود، برای ساخت لینک به بلیط در سیستم خود را.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'تعریف می کند که کاراکتر استفاده می شود برای نقل قول ایمیل متن در صفحه نوشتن بلیط رابط عامل. اگر این خالی است و یا غیر فعال است، ایمیل اصلی نخواهد نقل شود اما افزوده به پاسخ.',
        'Defines the user identifier for the customer panel.' => 'تعریف می کند که شناسه کاربر برای پنل مشتری می باشد.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'تعریف می کند که نام کاربری برای دسترسی به دسته SOAP (بن / cgi-bin در / rpc.pl). میباشد',
        'Defines the valid state types for a ticket.' => 'انواع وضعیت معتبر برای یک بلیط.را تعریف میکند.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'تعریف می کند که ایالات معتبر برای بلیط باز شده است. برای باز کردن قفل بلیط اسکریپت \ "بن / otrs.Console.pl سیستم maint :: بلیط :: UnlockTimeout " می تواند استفاده شود.',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            'تعریف می کند که قفل قابل مشاهده یک بلیط. توجه: وقتی که این تنظیم را تغییر دهید، مطمئن شوید که به حذف کش به منظور استفاده از ارزش های جدید است. به طور پیش فرض: باز کردن، tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'پهنای برای غنی جزء ویرایشگر متن برای این صفحه نمایش. تعداد (پیکسل) یا ارزش درصد (نسبی) را وارد کنید.',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'پهنای برای غنی جزء ویرایشگر متن. تعداد (پیکسل) یا ارزش درصد (نسبی) را وارد کنید.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'تعریف می کند که مقاله انواع فرستنده باید در پیش نمایش یک درخواست نشان داده شود.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'تعریف می کند که اقلام برای \'عمل\' در سطح سوم ساختار ACL در دسترس هستند.',
        'Defines which items are available in first level of the ACL structure.' =>
            'تعریف می کند که اقلام در سطح اول از ساختار ACL در دسترس هستند.',
        'Defines which items are available in second level of the ACL structure.' =>
            'تعریف می کند که اقلام در سطح دوم از ساختار ACL در دسترس هستند.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'تعریف می کند که حالت ها باید به طور خودکار تنظیم شوند (محتوا)، پس از زمان انتظار به حالت (کلید) رسیده است.',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'تعریف می کند سرشار نوع مقاله باید هنگام ورود به کلی گسترش یافته است. اگر هیچ چیز تعریف شده است، آخرین مقاله گسترش خواهد یافت.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'تعریف می کند، که درخواست  که انواع حالت درخواست باید در لیست درخواست مرتبط ذکر شده نخواهد شد.',
        'Delete expired cache from core modules.' => 'حذف کش منقضی شده از ماژول های هسته ای است.',
        'Delete expired loader cache weekly (Sunday mornings).' => 'حذف منقضی شده هفتگی کش لودر (صبح یکشنبه).',
        'Delete expired sessions.' => 'حذف جلسات منقضی شده است.',
        'Deleted link to ticket "%s".' => 'لینک های حذف شده به درخواست \ " %s ".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'حذف یک جلسه اگر شناسه جلسه با یک آدرس IP از راه دور نامعتبر استفاده می شود.',
        'Deletes requested sessions if they have timed out.' => 'حذف جلسات درخواست اگر آنها به پایان رسیده است.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'ارائه اطلاعات اشکال زدایی گسترده در ظاهر در مورد هر گونه خطا AJAX رخ می دهد، اگر فعال باشد.',
        'Deploy and manage OTRS Business Solution™.' => 'استقرار و مدیریت کسب و کار OTRS راه حل ™.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'تعیین اگر لیستی از صف ممکن به حرکت به بلیط به باید در یک لیست کشویی یا در یک پنجره جدید در رابط عامل نمایش داده میشود. اگر \ "پنجره جدید " قرار است شما می توانید یک یادداشت حرکت بلیط برای اضافه کنید.',
        'Determines if the statistics module may generate ticket lists.' =>
            'تعیین  ماژول آمار ممکن است لیست درخواست تولید کند.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'تعیین حالات درخواست ممکن بعدی، پس از ایجاد یک درخواست ایمیل جدید در رابط عامل.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'تعیین حالات درخواست ممکن بعدی، پس از ایجاد یک درخواست تلفن جدید در رابط عامل.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'تعیین حالات درخواست ممکن بعدی، برای درخواست روند در رابط عامل.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            'تعیین ایالات بلیط ممکن بعدی، برای بلیط روند در رابط مشتری.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'تعیین صفحه بعدی بعد ازدرخواست مشتری جدید در رابط مشتری.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'تعیین صفحه بعدی بعد از صفحه نمایش پیگیری یک درخواست بزرگنمایی در رابط مشتری .',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'تعیین صفحه بعدی پس از بلیط منتقل شده است. LastScreenOverview خواهد آخرین صفحه نمای کلی (به عنوان مثال نتایج جستجو، queueview، داشبورد) بازگشت. TicketZoom به TicketZoom بازگشت.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'تعیین حالات ممکن برای درخواست در حال بررسی است که پس از رسیدن به محدودیت زمانی حالت تغییر کرده است.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'تعیین رشته است که به عنوان دریافت کننده نشان داده خواهد شد (برای :) بلیط تلفن و به عنوان فرستنده (از :) از بلیط ایمیل در رابط عامل. برای صف به عنوان NewQueueSelectionType \ "<صف> " نشان می دهد نام از صف و برای SystemAddress \ "<Realname> << >> ایمیل " نام و ایمیل دریافت کننده نشان می دهد.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'تعیین رشته است که به عنوان گیرنده (به :) بلیط در رابط مشتری از نشان داده خواهد شد. برای صف به عنوان CustomerPanelSelectionType، \ "<صف> " نشان می دهد نام از صف، و برای SystemAddress، \ "<Realname> << >> ایمیل " نشان می دهد نام و ایمیل دریافت کننده.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'تعیین راه اشیاء مرتبط در هر ماسک زوم نمایش داده شود.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'مشخص است که گزینه های گیرنده (درخواست تلفن) و فرستنده (درخواست ایمیل) در رابط عامل معتبر خواهد بود.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'مشخص می کند که صف برای گیرنده های نامه درخواست در رابط مشتری معتبر خواهد بود.',
        'Development' => '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'غیر فعال کردن HTTP هدر "Content-Security-Policy" اجازه می دهد تا بارگذاری محتویات اسکریپت های خارجی. غیر فعال کردن این هدر HTTP می تواند یک مسئله امنیتی! فقط آن را غیر فعال کنید، اگر شما می دانید آنچه شما انجام می دهند!',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'غیر فعال کردن HTTP هدر \ "X-قاب گزینه ها: SAMEORIGIN " اجازه می دهد OTRS به عنوان یک iframe در وب سایت های دیگر گنجانده شده است. غیر فعال کردن این هدر HTTP می تواند یک مسئله امنیتی! فقط آن را غیر فعال کنید، اگر شما می دانید آنچه شما انجام می دهند!',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE.' =>
            'غیر فعال کردن امنیت محدود برای فریم در اینترنت اکسپلورر. ممکن است لازم باشد برای SSO به کار در اینترنت اکسپلورر.',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'غیر فعال کردن ارسال اطلاعیه یادآور به عامل مسئول یک درخواست (درخواست :: نیازهای مسئول فعال شود).',
        'Disables the communication between this system and OTRS Group servers that provides cloud services. If active, some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            'غیر فعال ارتباط بین این سیستم و سرور OTRS گروه فراهم می کند که خدمات ابر. اگر فعال، برخی از قابلیت های می شود مانند ثبت نام سیستم از دست داده، داده ها پشتیبانی از ارسال، به روز رسانی و استفاده از OTRS کسب و کار راه حل ™، OTRS تایید ™، OTRS اخبار و محصولات اخبار داشبورد ویجتها، در میان دیگران.',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            'غیر فعال نصب وب سایت (http://yourhost.example.com/otrs/installer.pl)، برای جلوگیری از این سیستم از ربوده شده است. اگر به \ "بدون "، سیستم را می توان دوباره نصب و پیکربندی اولیه فعلی استفاده می شود به قبل از جمعیت سوالات در اسکریپت نصب. اگر فعال است، آن را نیز غیر فعال GenericAgent، سامانه مدیریت بسته و SQL جعبه.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'نمایش اخطار و جلوگیری از جستجو زمانی که با استفاده از کلمات در درون جستجوی متن هست.',
        'Display settings to override defaults for Process Tickets.' => 'تنظیمات پیش فرض صفحه نمایش برای نادیده گرفتن فرایند درخواست هست.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'نمایش زمان به حساب برای یک مقاله در نظر زوم درخواست است.',
        'Dropdown' => 'رها کردن',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'کلمات توقف هلندی شاخص متن. این کلمات از صفحه اول جستجو حذف خواهند شد.',
        'Dynamic Fields Checkbox Backend GUI' => 'رابط کاربری گرافیکی پویا زمینه جعبه بخش مدیریت',
        'Dynamic Fields Date Time Backend GUI' => 'پویا زمینه های تاریخ زمان بخش مدیریت رابط کاربری گرافیکی',
        'Dynamic Fields Drop-down Backend GUI' => 'پویا زمینه های کشویی GUI بخش مدیریت',
        'Dynamic Fields GUI' => 'رابط کاربری گرافیکی زمینه پویا ',
        'Dynamic Fields Multiselect Backend GUI' => 'رابط کاربری گرافیکی زمینه پویا چندین انتخاب بخش مدیریت',
        'Dynamic Fields Overview Limit' => 'زمینه پویا نمای کلی محدود',
        'Dynamic Fields Text Backend GUI' => ' زمینه های پویا متن بخش مدیریت رابط کاربری گرافیکی',
        'Dynamic Fields used to export the search result in CSV format.' =>
            ' زمینه های پویا مورد استفاده به صادرات نتیجه جستجو در فرمت CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'زمینه گروه پویا برای ویجت روند. کلید نام این گروه است، ارزش شامل زمینه نشان داده شود. به عنوان مثال: \'کلید => من گروه\'، \'مطالب و محتوا: Name_X، NameY.',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'زمینه های پویا محدود در هر صفحه برای بررسی اجمالی زمینه  پویا',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'زمینه های پویا گزینه نشان داده شده در صفحه نمایش پیام بلیط رابط مشتری. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است. توجه داشته باشید. اگر شما می خواهید برای نمایش این زمینه نیز در زوم بلیط رابط مشتری، شما باید آنها را قادر می سازد در CustomerTicketZoom ### DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا گزینه نشان داده شده در بخش پاسخ بلیط در روی صفحه نمایش زوم بلیط رابط مشتری. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش خروجی ایمیل از رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در ویجت فرآیند در روی صفحه نمایش زوم بلیط رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در نوار کناری صفحه نمایش زوم درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش نزدیک درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده است درخواست را در روی صفحه نمایش از رابط عامل تشکیل می دهند. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش ایمیل درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش درخواست انتقال از رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش درخواست های متنی رایگان از رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در محیط درخواست صفحه نمای کلی قالب رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در روی صفحه نمایش حرکت درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در روی صفحه نمایش  به درخواست رابط عامل توجه داشته باشید. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمای کلی درخواست رابط مشتری. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش صاحب درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش درخواست انتظار از رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در گوشی درخواست صفحه نمایش بین المللی به درون رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش خروجی تلفن درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش تلفن درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در پیش نمایش درخواست صفحه نمای کلی قالب رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در روی صفحه نمایش چاپ درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در روی صفحه نمایش چاپ درخواست رابط مشتری. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش اولویت درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'زمینه های پویا نشان داده شده در صفحه نمایش درخواست مسئول رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و مورد نیاز است.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در جستجودرخواست نتایج کلی صفحه نمایش رابط مشتری. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            'زمینه های پویا نشان داده شده در صفحه جستجوی درخواست رابط عامل. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال، 2 = فعال و نشان داده شده است به طور پیش فرض.',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در صفحه جستجوی درخواست رابط مشتری. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'زمینه های پویا نشان داده شده در درخواست فرمت های صفحه نمایش کوچک نمای کلی از رابط عامل. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'زمینه های پویا نشان داده شده در روی صفحه نمایش زوم درخواست رابط مشتری. تنظیمات ممکن: 0 = غیر فعال شده، 1 = فعال.',
        'DynamicField' => 'DynamicField',
        'DynamicField backend registration.' => 'DynamicField ثبت نام باطن.',
        'DynamicField object registration.' => 'DynamicField ثبت نام شی.',
        'E-Mail Outbound' => 'عازم ناحیه دور دست ایمیل',
        'Edit Customer Companies.' => 'ویرایش شرکت و مشتری',
        'Edit Customer Users.' => 'ویرایش کاربران مشتری',
        'Edit customer company' => 'ویرایش شرکت مشتری',
        'Email Addresses' => 'آدرس‌های ایمیل',
        'Email Outbound' => 'عازم ناحیه دور دست ایمیل',
        'Email sent to "%s".' => 'ایمیل ارسال به \ " %s ".',
        'Email sent to customer.' => 'سابقه:: نامه کارشناس',
        'Enable keep-alive connection header for SOAP responses.' => 'فعال کردن هدر ارتباط زنده نگه داشتن برای پاسخ SOAP.',
        'Enabled filters.' => 'فیلتر را فعال کنید.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'پشتیبانی PGP را قادر می سازد. زمانی که حمایت PGP برای امضای و رمزنگاری ایمیل فعال، آن را بسیار توصیه می شود که وب سرور به عنوان کاربر OTRS اجرا می شود. در غیر این صورت، وجود خواهد داشت مشکلات با امتیازات زمانی که دسترسی به .gnupg پوشه.',
        'Enables S/MIME support.' => 'پشتیبانی از S / MIME را قادر می سازد.',
        'Enables customers to create their own accounts.' => 'مشتریان را برای ایجاد حساب خود قادر می سازد .',
        'Enables fetch S/MIME from CustomerUser backend support.' => 'را قادر می سازد واکشی S / MIME از پشتیبانی باطن CustomerUser.',
        'Enables file upload in the package manager frontend.' => 'آپلود فایل در ظاهر مدیر بسته را قادر می سازد.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'فعال یا غیر فعال کش برای قالب. هشدار: الگو ذخیره غیر فعال کردن نیست برای محیط های تولید برای آن یک قطره عملکرد عظیم می شود! این تنظیم فقط باید برای اشکال زدایی دلایل غیر فعال است!',
        'Enables or disables the debug mode over frontend interface.' => 'فعال یا غیر فعال کردن حالت اشکال زدایی بیش از رابط ظاهر.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'فعال یا غیر فعال از ویژگی های نگهبان درخواست، برای پیگیری درخواست بدون داشتن صاحب و نه مسئول است.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'ورود به سیستم عملکرد را قادر می سازد (برای ورود به صفحه زمان پاسخ). این عملکرد سیستم تاثیر می گذارد. ظاهر :: ماژول ### AdminPerformanceLog باید فعال باشد.',
        'Enables spell checker support.' => 'پشتیبانی جستجوگر املا درست را قادر می سازد.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'حداقل اندازه بلیط ضد قادر می سازد (در صورت \ "تاریخ " به عنوان TicketNumberGenerator انتخاب شد).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'حجم درخواست از ویژگی های عمل برای ظاهر عامل به کار بر روی بیش از درخواست در یک زمان قادر می سازد.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'ویژگی های عمل حجم درخواست تنها برای گروه های ذکر شده را قادر می سازد .',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'درخواست ویژگی مسئول، برای پیگیری یک بلیط خاص را قادر می سازد .',
        'Enables ticket watcher feature only for the listed groups.' => ' از ویژگی های نگهبان درخواست تنها برای گروه های ذکر شده را قادر می سازد.',
        'English (Canada)' => 'انگلیسی (کانادا)',
        'English (United Kingdom)' => 'انگلیسی (بریتانیایی)',
        'English (United States)' => 'ایالات متحده انگلیسی)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'کلمات توقف انگلیسی برای شاخص متن. این کلمات از صفحه اول جستجو حذف خواهند شد.',
        'Enroll process for this ticket' => 'ثبت نام فرآیند  این درخواست برای',
        'Enter your shared secret to enable two factor authentication.' =>
            'راز مشترک خود را وارد کنید برای فعال کردن دو فاکتور تأیید هویت.',
        'Escalation response time finished' => 'زمان پاسخ افزایش به پایان رسید',
        'Escalation response time forewarned' => 'زمان پاسخ تشدید هشدار',
        'Escalation response time in effect' => 'زمان پاسخ تشدید اثر',
        'Escalation solution time finished' => 'زمان حل تشدید به پایان رسید',
        'Escalation solution time forewarned' => 'زمان حل تشدید هشدار',
        'Escalation solution time in effect' => 'زمان حل تشدید اثر',
        'Escalation update time finished' => 'زمان به روز رسانی تشدید به پایان رسید ',
        'Escalation update time forewarned' => 'زمان به روز رسانی تشدید هشدار',
        'Escalation update time in effect' => 'زمان به روز رسانی تشدید اثر',
        'Escalation view' => 'نمای درخواست‌های خیلی مهم',
        'EscalationTime' => 'EscalationTime',
        'Estonian' => 'زبان استونی',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'رویداد ثبت نام ماژول. برای عملکرد بیشتر شما می توانید رویداد ماشه (به عنوان مثال رویداد => TicketCreate) را تعریف کنیم.',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'رویداد ثبت نام ماژول. برای عملکرد بیشتر شما می توانید رویداد ماشه (به عنوان مثال رویداد => TicketCreate) را تعریف کنیم. این تنها راه ممکن است اگر تمام زمینه های پویا بلیط نیاز همان رویداد.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'ماژول رویداد است که انجام یک بیانیه به روز رسانی در TicketIndex به تغییر نام نام صف وجود دارد در صورت نیاز و اگر StaticDB است که در واقع استفاده می شود.',
        'Event module that updates customer user search profiles if login changes.' =>
            'ماژول رویداد که به روز رسانی پروفایل جستجو کاربران مشتری اگر تغییرات وارد سایت شوید.',
        'Event module that updates customer user service membership if login changes.' =>
            'ماژول رویداد که به روز رسانی عضویت خدمات کاربران مشتری اگر تغییرات وارد سایت شوید.',
        'Event module that updates customer users after an update of the Customer.' =>
            'ماژول رویداد که به روز رسانی به کاربران مشتری پس از به روز رسانی از مشتری می باشد.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'ماژول رویداد که به روز رسانی بلیط پس از به روز رسانی از کاربر مشتری.',
        'Event module that updates tickets after an update of the Customer.' =>
            'ماژول رویداد که به روز رسانی بلیط پس از بروز رسانی از مشتری است.',
        'Events Ticket Calendar' => 'رویدادها درخواست تقویم',
        'Execute SQL statements.' => 'اجرای عبارات SQL',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'اجرای یک دستور سفارشی و یا ماژول. توجه: اگر ماژول استفاده می شود، تابع مورد نیاز است.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'اجرا چک پیگیری در پاسخ به یا مراجع هدر برای ایمیل هایی که شماره درخواست را در موضوع ندارد.',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'اجرا چک پیگیری محتویات پیوست برای ایمیل هایی که شماره درخواست را در موضوع ندارد.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'اجرا چک پیگیری بدن ایمیل برای ایمیل هایی که شماره درخواست را در موضوع ندارد.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'اجرا چک پیگیری ایمیل منبع اولیه برای ایمیل هایی که شماره درخواست را در موضوع ندارد.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'صادرات کل درخت مقاله در نتیجه جستجو (می تواندبرعملکرد سیستم تاثیر بگذارد).',
        'Fetch emails via fetchmail (using SSL).' => 'واکشی ایمیل از طریق کامند fetchmail (با استفاده از SSL).',
        'Fetch emails via fetchmail.' => 'واکشی ایمیل از طریق fetchmail مشاهده کنید.',
        'Fetch incoming emails from configured mail accounts.' => 'واکشی ایمیل های دریافتی از حساب های ایمیل پیکربندی شده است.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'بازخوانی بسته از طریق پروکسی. رونویسی \ "WebUserAgent :: پروکسی ".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'فایل است که در کرنل :: ماژول :: AgentInfo نمایش داده، اگر در هسته / خروجی / HTML / قالب / استاندارد / AgentInfo.tt واقع شده است.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'فیلتر برای اشکال زدایی ACL ها است. توجه: چند ویژگی بلیط را می توان در قالب <OTRS_TICKET_Attribute> به عنوان مثال <OTRS_TICKET_Priority> اضافه شده است.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'فیلتر برای اشکال زدایی انتقال. توجه: بیشتر فیلتر را می توان در قالب <OTRS_TICKET_Attribute> به عنوان مثال <OTRS_TICKET_Priority> اضافه شده است.',
        'Filter incoming emails.' => 'فیلتر ایمیل‌های ورودی',
        'Finnish' => 'فنلاندی',
        'First Queue' => 'صف نخست',
        'FirstLock' => 'FirstLock',
        'FirstResponse' => 'FirstResponse',
        'FirstResponseDiffInMin' => 'FirstResponseDiffInMin',
        'FirstResponseInMin' => 'FirstResponseInMin',
        'Firstname Lastname' => 'نام نام خانوادگی',
        'Firstname Lastname (UserLogin)' => 'نام نام خانوادگی (صفحهی)',
        'FollowUp for [%s]. %s' => 'پیگیری برای [ %s ]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'را پشتیبانی می کند نیروهای ایمیل های ارسالی (7bit | 8bit های | نقل قابل چاپ | از base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'نیروهای به انتخاب یک دولت بلیط مختلف (از فعلی) بعد از عمل قفل. تعریف وضعیت فعلی به عنوان کلید، و دولت بعدی پس از عمل قفل به عنوان محتوا.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'نیروهای  باز کردن درخواست پس ازاین به صف دیگری نقل مکان کرد.',
        'Forwarded to "%s".' => 'لینک ثابت به : "%s"',
        'French' => 'فرانسوی',
        'French (Canada)' => 'فرانسه (کانادا)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'کلمات توقف فرانسه برای شاخص متن. این کلمات از صفحه اول جستجو حذف خواهند شد.',
        'Frontend' => 'ظاهر',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            'ثبت نام ماژول ظاهر (لینک AgentTicketService غیر فعال کردن اگر ویژگی بلیط Serivice استفاده نمی شود).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'ثبت نام ماژول ظاهر (لینک شرکت غیر فعال کردن اگر هیچ ویژگی شرکت استفاده می شود).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'ثبت نام ماژول ظاهر (فرآیندهای بلیط غیر فعال کردن صفحه نمایش اگر هیچ روند موجود) برای مشتری.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'ثبت نام ماژول ظاهر (فرآیندهای بلیط غیر فعال کردن صفحه نمایش اگر هیچ فرایند در دسترس).',
        'Frontend module registration for the agent interface.' => 'ظاهر ثبت نام ماژول برای رابط عامل.',
        'Frontend module registration for the customer interface.' => 'ظاهر ثبت نام ماژول برای رابط مشتری.',
        'Frontend theme' => 'طرح زمینه واسط',
        'Full value' => 'ارزش کامل',
        'Fulltext index regex filters to remove parts of the text.' => 'متن فیلتر شاخص عبارت منظم به حذف بخش هایی از متن.',
        'Fulltext search' => 'جستجوی متن',
        'Galician' => 'گاليکي',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            'اطلاعات بلیط عمومی نشان داده شده در مروری بلیط (پاییز پشت). تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال. توجه داشته باشید که TicketNumber نمی تواند غیر فعال شود، زیرا لازم است.',
        'Generate dashboard statistics.' => 'تولید آمار داشبورد.',
        'Generic Info module.' => 'ماژول اطلاعات عمومی است.',
        'GenericAgent' => 'کارشناس عمومی',
        'GenericInterface Debugger GUI' => 'رابط کاربری گرافیکی GenericInterface دیباگر',
        'GenericInterface Invoker GUI' => 'رابط کاربری گرافیکی GenericInterface Invoker',
        'GenericInterface Operation GUI' => 'رابط کاربری گرافیکی GenericInterface عملیات',
        'GenericInterface TransportHTTPREST GUI' => 'رابط کاربری گرافیکی GenericInterface TransportHTTPREST',
        'GenericInterface TransportHTTPSOAP GUI' => 'رابط کاربری گرافیکی GenericInterface TransportHTTPSOAP',
        'GenericInterface Web Service GUI' => 'رابط کاربری گرافیکی GenericInterface وب سرویس',
        'GenericInterface Webservice History GUI' => 'GenericInterface از webservice تاریخچه رابط کاربری گرافیکی',
        'GenericInterface Webservice Mapping GUI' => 'رابط کاربری گرافیکی GenericInterface از webservice نقشه برداری',
        'GenericInterface module registration for the invoker layer.' => 'GenericInterface ثبت نام ماژول برای لایه invoker است.',
        'GenericInterface module registration for the mapping layer.' => 'GenericInterface ثبت نام ماژول برای لایه های نقشه برداری.',
        'GenericInterface module registration for the operation layer.' =>
            'GenericInterface ثبت نام ماژول برای لایه عملیات.',
        'GenericInterface module registration for the transport layer.' =>
            'GenericInterface ثبت نام ماژول برای لایه حمل و نقل.',
        'German' => 'آلمانی',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'کلمات توقف آلمانی برای شاخص متن. این کلمات از صفحه اول جستجو حذف خواهند شد.',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'به کاربران این امکان را به نادیده گرفتن کاراکتر جدا برای فایل های CSV، تعریف شده در فایل های ترجمه.',
        'Global Search Module.' => 'بازارهای ماژول جستجو.',
        'Go back' => 'برگرد',
        'Google Authenticator' => 'Google Authenticator را',
        'Graph: Bar Chart' => 'نمودار: نمودار نوار',
        'Graph: Line Chart' => 'نمودار: نمودار خط',
        'Graph: Stacked Area Chart' => 'نمودار: نمودار محیطی پشتهای',
        'Greek' => 'یونانی',
        'HTML Reference' => 'HTML مرجع',
        'HTML Reference.' => 'HTML مرجع.',
        'Hebrew' => 'عبری',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            'کمک می کند تا به گسترش مقالات خود را جستجو متن کامل (از، به، CC، موضوع و جستجو بدن). در زمان اجرا خواهد جستجو متن کامل بر روی داده های زنده انجام (خوب کار می کند تا 50.000 بلیط). StaticDB همه مقالات نوار و شاخص پس از ایجاد مقاله ساخت، افزایش جستجو متن در حدود 50٪. برای ایجاد یک استفاده شاخص اولیه \ "بن / otrs.Console.pl سیستم maint :: بلیط :: FulltextIndexRebuild ".',
        'Hindi' => 'هندی',
        'Hungarian' => 'مجارستانی',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'اگر \ "DB " برای مشتریان :: AuthModule انتخاب شد، یک راننده پایگاه داده (به طور معمول خودکار استفاده می شود) می تواند مشخص شود.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'اگر \ "DB " برای مشتریان :: AuthModule انتخاب شد، یک رمز عبور برای اتصال به جدول مشتری می تواند مشخص شود.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'اگر \ "DB " برای مشتریان :: AuthModule انتخاب شد، یک نام کاربری برای اتصال به جدول مشتری می تواند مشخص شود.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'اگر \ "DB " برای مشتریان :: AuthModule انتخاب شد، DSN برای اتصال به جدول مشتری باید مشخص شود.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'اگر \ "DB " برای مشتریان :: AuthModule انتخاب شد، نام ستون برای CustomerPassword در جدول مشتری باید مشخص شود.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'اگر \ "DB " برای مشتریان :: AuthModule انتخاب شد، نوع دخمه از کلمات عبور باید مشخص شود.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'اگر \ "DB " برای مشتریان :: AuthModule انتخاب شد، نام ستون برای CustomerKey در جدول مشتری باید مشخص شود.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'اگر \ "DB " برای مشتریان :: AuthModule انتخاب شد، نام جدول که در آن داده های مشتری خود باید ذخیره شود باید مشخص شود.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'اگر \ "DB " برای SessionModule انتخاب شد، یک جدول در پایگاه داده که در آن جلسه داده ذخیره می شود باید مشخص شود.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'اگر \ "FS " برای SessionModule انتخاب شد، یک دایرکتوری که در آن داده جلسه ذخیره خواهد شد باید مشخص شود.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'اگر \ "HTTPBasicAuth " برای ضوابط انتخاب شد :: AuthModule، شما می توانید (با استفاده از یک استقبال میکنم) به نوار قطعات از REMOTE_USER (به عنوان مثال برای به حذف دامنه انتهایی) را مشخص کنید. استقبال میکنم-توجه داشته باشید، $ 1 خواهد بود که کاربری جدید ورود.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'اگر \ "HTTPBasicAuth " برای ضوابط انتخاب شد :: AuthModule، شما می توانید مشخص به نوار قطعات منجر از نام کاربر (به عنوان مثال برای دامنه های مانند example_domain \ کاربر به کاربر).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد و اگر شما می خواهید برای اضافه کردن یک پسوند به هر نام کاربری مشتری، آن را specifiy در اینجا، به عنوان مثال شما فقط می خواهم به ارسال کاربران نام کاربری اما در دایرکتوری LDAP شما وجود دارد کاربران @ دامنه.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد و پارامتر های ویژه ای را برای شبکه :: LDAP ماژول پرل مورد نیاز، شما می توانید آنها را در اینجا مشخص کنید. \ "خالص perldoc :: LDAP " برای اطلاعات بیشتر در مورد پارامترها را ببینید.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد و کاربران شما تنها دسترسی ناشناس به درخت LDAP، اما شما می خواهید از طریق داده های جستجو، شما می توانید این کار را با کاربران که دسترسی به دایرکتوری LDAP است را انجام دهد. مشخص رمز عبور برای این کاربر خاص است.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد و کاربران شما تنها دسترسی ناشناس به درخت LDAP، اما شما می خواهید از طریق داده های جستجو، شما می توانید این کار را با کاربران که دسترسی به دایرکتوری LDAP است را انجام دهد. نام کاربری برای این کاربر خاص در اینجا مشخص کنید.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد، BaseDN باید مشخص شود.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد، میزبان LDAP را می توان مشخص کرد.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد، شناسه کاربر باید مشخص شود.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد، ویژگی های کاربر می تواند مشخص شود. برای posixGroups LDAP استفاده UID، برای posixGroups غیر LDAP استفاده DN کاربر کامل.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'اگر \ "LDAP " برای ضوابط AuthModule انتخاب شد ::.، شما می توانید ویژگی های دسترسی، اینجا را مشخص کنید.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'اگر \ "LDAP " برای مشتریان :: AuthModule انتخاب شد، شما می توانید مشخص کنید اگر برنامه های کاربردی متوقف خواهد شد اگر به عنوان مثال یک اتصال به یک سرور می تواند به دلیل مشکلات شبکه ایجاد شود.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'اگر \ "LDAP " برای ضوابط Authmodule انتخاب شد ::، شما می توانید در صورتی که کاربر مجاز به تصدیق چرا که او در یک posixGroup است، به عنوان مثال کاربر نیاز به در یک XYZ گروه به استفاده از OTRS شود تیک بزنید. مشخص گروه، که ممکن است سیستم دسترسی داشته باشید.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'اگر \ "LDAP " انتخاب شد، شما می توانید یک فیلتر برای هر پرس و جو LDAP، به عنوان مثال (ایمیل = *)، (objectclass = کاربر) و یا (! objectclass = کامپیوتر) اضافه کنید.',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'اگر \ "شعاع " برای مشتریان :: AuthModule انتخاب شد، رمز عبور برای احراز هویت به میزبان شعاع باید مشخص شود.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'اگر \ "شعاع " برای مشتریان :: AuthModule انتخاب شد، میزبان شعاع باید مشخص شود.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'اگر \ "شعاع " برای مشتریان :: AuthModule انتخاب شد، شما می توانید مشخص کنید اگر برنامه های کاربردی متوقف خواهد شد اگر به عنوان مثال یک اتصال به یک سرور می تواند به دلیل مشکلات شبکه ایجاد شود.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'اگر \ "Sendmail باشد " به عنوان SendmailModule انتخاب شد، محل باینری از sendmail و گزینه های مورد نیاز باید مشخص شود.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'اگر \ "syslog را " برای LogModule انتخاب شد، یک مرکز ورود به سیستم خاص می تواند مشخص شود.',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'اگر \ "syslog را " برای LogModule انتخاب شد، یک جوراب ورود به سیستم خاص می تواند مشخص شود (در سولاریس شما ممکن است نیاز به استفاده از \'جریان\').',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'اگر \ "syslog را " برای LogModule انتخاب شد، مجموعه کاراکتر است که باید برای ورود به سیستم استفاده می شود می تواند مشخص شود.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'اگر \ "فایل " برای LogModule انتخاب شد، یک فایل تاریخچه ثبت باید مشخص شود. اگر فایل وجود ندارد، از آن خواهد شد توسط سیستم ایجاد شده است.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'اگر فعال، هیچ یک از عبارات منظم ممکن است آدرس ایمیل کاربر اجازه می دهد تا ثبت نام مطابقت.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'اگر فعال، یکی از عبارات منظم برای مطابقت آدرس ایمیل کاربر اجازه می دهد تا ثبت نام.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'اگر هر یک از \ "SMTP " مکانیزم به عنوان SendmailModule انتخاب شد، احراز هویت به میل سرور مورد نیاز است، یک رمز عبور باید مشخص شود.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'اگر هر یک از \ "SMTP " مکانیزم به عنوان SendmailModule انتخاب شد، احراز هویت به میل سرور مورد نیاز است، یک نام کاربری باید مشخص شود.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'اگر هر یک از \ "SMTP " مکانیزم به عنوان SendmailModule از mailhost می فرستد که از ایمیل باید مشخص شود انتخاب شد.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'اگر هر یک از \ "SMTP " مکانیزم به عنوان SendmailModule انتخاب شد، بندر که در آن mailserver ای خود را برای اتصالات ورودی گوش دادن باید مشخص شود.',
        'If enabled debugging information for ACLs is logged.' => 'اگر اطلاعات اشکال زدایی فعال برای ACL ها وارد شده است.',
        'If enabled debugging information for transitions is logged.' => 'در صورت فعال بودن اطلاعات اشکال زدایی برای انتقال به سیستم وارد شده است.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'اگر فعال شبح را به جریان خطای استاندارد را به یک فایل ورود به سیستم تغییر مسیر.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'اگر فعال شبح را به خروجی استاندارد را به یک فایل ورود به سیستم تغییر مسیر.',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            'اگر فعال باشد، OTRS تمام فایل های CSS در قالب minified شده ارائه کرده است. هشدار: اگر شما این خاموش، احتمال مشکلات در اینترنت اکسپلورر 7، به دلیل آن می تواند بیش از 32 فایل های CSS بار نیست.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'اگر فعال باشد، OTRS تمام فایل های جاوا اسکریپت را در فرم های Minified ارائه کرده است.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'اگر فعال باشد، TicketPhone و TicketEmail در پنجره جدید باز خواهد شد.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            'اگر فعال باشد، نسخه برچسب OTRS خواهد شد از Webinterface، هدر HTTP و X-هدر از ایمیل های خروجی حذف خواهند شد. توجه: اگر شما این گزینه را تغییر دهید، لطفا مطمئن شوید که به حذف کش.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'اگر فعال باشد، مشتری می تواند برای درخواست در همه خدمات (بدون در نظر گرفتن اینکه چه خدماتی به مشتری اختصاص داده) جستجو کنید.',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'اگر فعال باشد، مروری مختلف (داشبورد، LockedView، QueueView) به طور خودکار پس از زمان مشخص را تازه کنید.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'اگر فعال باشد، در سطح اول از منوی اصلی باز می شود بر روی موس (به جای تنها کلیک کنید).',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            'اگر هیچ SendmailNotificationEnvelopeFrom مشخص شده باشد، این تنظیم را ممکن می سازد به استفاده از ایمیل از جای آدرس فرستنده پاکت خالی (مورد نیاز در برخی از تنظیمات سرور ایمیل).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            'اگر تعیین شود، این آدرس به عنوان هدر فرستنده پاکت در اطلاعیه های خروجی استفاده می شود. اگر هیچ آدرس مشخص شده باشد، هدر فرستنده پاکت خالی است (مگر اینکه SendmailNotificationEnvelopeFrom :: FallbackToEmailFrom تنظیم شده است).',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'اگر تعیین شود، این آدرس به عنوان فرستنده پاکت در پیام های خروجی استفاده می شود (اطلاعیه - پایین را ببینید). اگر هیچ آدرس مشخص شده باشد، فرستنده پاکت برابر به صف آدرس ایمیل است.',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            'اگر این گزینه فعال باشد، پس از آن داده خواهد شد رمزگشایی در پایگاه داده ذخیره می شود در صورتی که در AgentTicketZoom نمایش داده شود.',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            'اگر این گزینه را به \'بله\'، بلیط ایجاد شده از طریق رابط وب، از طریق مشتریان و یا عوامل، یک خودکار یکطرفه صورت پیکربندی دریافت خواهید کرد. اگر این گزینه را به مجموعه "نه"، هیچ autoresponses ارسال خواهد شد.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'اگر این عبارت منظم مسابقات، هیچ پیام خواهد شد توسط پاسخگوی خودکار ارسال می کند.',
        'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            'اگر این تنظیم فعال است، تغییرات محلی به عنوان خطا در مدیریت بسته ها و داده های جمع آوری پشتیبانی برجسته است.',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'شامل بلیط از subqueues در به طور پیش فرض در هنگام انتخاب یک صف.',
        'Include unknown customers in ticket filter.' => 'شامل مشتریان ناشناخته در فیلتر درخواست',
        'Includes article create times in the ticket search of the agent interface.' =>
            'شامل مقاله ایجاد بار در جستجو درخواست رابط عامل.',
        'Incoming Phone Call.' => 'تماس تلفنی ورودی.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'IndexAccelerator: برای انتخاب ماژول باطن TicketViewAccelerator خود را. \ "RuntimeDB " تولید هر نظر صف در پرواز از جدول بلیط (بدون مشکل در عملکرد تا حدود 60.000 بلیط در کل و 6.000 بلیط باز در سیستم). \ "StaticDB " است که ماژول قدرتمند ترین، آن را با استفاده از یک جدول بلیط شاخص های اضافی است که مانند یک کار می کند (توصیه می شود اگر بیش از 80.000 و 6.000 بلیط باز در سیستم ذخیره می شود). استفاده از دستور \ "بن / otrs.Console.pl سیستم maint :: بلیط :: QueueIndexRebuild " برای ایجاد شاخص اولیه.',
        'Indonesian' => 'اندونزی',
        'Input' => 'ورودی',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            'نصب ispell یا aspell بر روی سیستم، اگر شما می خواهید به استفاده از یک جستجوگر املا نوشتن. لطفا مسیر به aspell یا ispell باینری در سیستم عامل خود را مشخص کنید.',
        'Interface language' => 'زبان واسط',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'ممکن است که به پیکربندی پوسته های مختلف، به عنوان مثال برای تمایز بین عوامل مختلف، به بر اساس هر دامنه در داخل نرم افزار استفاده می شود. با استفاده از یک عبارت منظم (عبارت منظم)، شما می توانید یک جفت محتوا / کلیدی برای مطابقت با یک دامنه پیکربندی کنید. ارزش در \ "کلید " باید دامنه مطابقت، و ارزش در \ "محتوا " باید یک پوست معتبر بر روی سیستم شما می شود. لطفا برای فرم مناسب از عبارت منظم مشاهده نوشته های مثال.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'ممکن است که به پیکربندی پوسته های مختلف، به عنوان مثال برای تمایز بین مشتریان مختلف، به بر اساس هر دامنه در داخل نرم افزار استفاده می شود. با استفاده از یک عبارت منظم (عبارت منظم)، شما می توانید یک جفت محتوا / کلیدی برای مطابقت با یک دامنه پیکربندی کنید. ارزش در \ "کلید " باید دامنه مطابقت، و ارزش در \ "محتوا " باید یک پوست معتبر بر روی سیستم شما می شود. لطفا برای فرم مناسب از عبارت منظم مشاهده نوشته های مثال.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'ممکن است که به پیکربندی تم های مختلف، به عنوان مثال برای تمایز بین عوامل و مشتریان، به بر اساس هر دامنه در داخل نرم افزار استفاده می شود. با استفاده از یک عبارت منظم (عبارت منظم)، شما می توانید یک جفت محتوا / کلیدی برای مطابقت با یک دامنه پیکربندی کنید. ارزش در \ "کلید " باید دامنه مطابقت، و ارزش در \ "محتوا " باید یک موضوع معتبر بر روی سیستم شما می شود. لطفا برای فرم مناسب از عبارت منظم مشاهده نوشته های مثال.',
        'Italian' => 'ایتالیایی',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            'کلمات توقف ایتالیایی شاخص متن. این کلمات از صفحه اول جستجو حذف خواهند شد.',
        'Ivory' => 'عاج',
        'Ivory (Slim)' => 'عاج (لاغر)',
        'Japanese' => 'ژاپنی',
        'JavaScript function for the search frontend.' => 'جاوا اسکریپت تابع برای ظاهر جستجو.',
        'Last customer subject' => 'آخرین موضوع مشتری',
        'Lastname Firstname' => 'نام خانوادگی',
        'Lastname Firstname (UserLogin)' => 'نام خانوادگی نام (صفحهی)',
        'Lastname, Firstname' => 'نام خانوادگی',
        'Lastname, Firstname (UserLogin)' => 'نام خانوادگی، نام (صفحهی)',
        'Latvian' => 'لتونی',
        'Left' => 'چپ',
        'Link Object' => 'لینک',
        'Link Object.' => 'شی لینک.',
        'Link agents to groups.' => 'برقراری ارتباط بین کارشناسان و گروه‌ها',
        'Link agents to roles.' => 'برقراری ارتباط بین کارشناسان و نقش‌ها',
        'Link attachments to templates.' => 'فایل پیوست لینک به قالب.',
        'Link customer user to groups.' => 'لینک کاربران مشتری به گروه.',
        'Link customer user to services.' => 'لینک کاربران مشتری به خدمات.',
        'Link queues to auto responses.' => 'برقراری ارتباط بین صف‌های درخواست و پاسخ‌های خودکار',
        'Link roles to groups.' => 'برقراری ارتباط بین نقش‌ها و گروه‌ها',
        'Link templates to queues.' => 'قالب لینک به صف.',
        'Links 2 tickets with a "Normal" type link.' => 'لینک 2 درخواست با یک \ "عادی " لینک نوع.',
        'Links 2 tickets with a "ParentChild" type link.' => 'لینک 2درخواست با یک \ "ParentChild " لینک نوع.',
        'List of CSS files to always be loaded for the agent interface.' =>
            'لیستی از فایل های CSS برای همیشه برای رابط عامل بارگذاری می شود.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'لیستی از فایل های CSS برای همیشه برای رابط مشتری بارگذاری می شود.',
        'List of JS files to always be loaded for the agent interface.' =>
            'لیستی از فایل های JS برای همیشه برای رابط عامل بارگذاری می شود.',
        'List of JS files to always be loaded for the customer interface.' =>
            'لیستی از فایل های JS برای همیشه برای رابط مشتری بارگذاری می شود.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'فهرست از تمام وقایع CustomerCompany در رابط کاربری گرافیکی نمایش داده می شود.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'فهرست از تمام وقایع CustomerUser در رابط کاربری گرافیکی نمایش داده می شود.',
        'List of all DynamicField events to be displayed in the GUI.' => 'فهرست از تمام وقایع DynamicField در رابط کاربری گرافیکی نمایش داده می شود.',
        'List of all Package events to be displayed in the GUI.' => 'فهرست از تمام وقایع بسته بندی در رابط کاربری گرافیکی نمایش داده می شود.',
        'List of all article events to be displayed in the GUI.' => 'فهرست از تمام وقایع مقاله در رابط کاربری گرافیکی نمایش داده می شود.',
        'List of all queue events to be displayed in the GUI.' => 'فهرست از تمام وقایع صف  در رابط کاربری گرافیکی نمایش داده می شود.',
        'List of all ticket events to be displayed in the GUI.' => 'فهرست از تمام وقایع درخواست در رابط کاربری گرافیکی نمایش داده می شود.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'فهرست پیش فرض قالب استاندارد که به طور خودکار به صف جدید بر ایجاد اختصاص داده است.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'لیستی از فایل های CSS پاسخگو برای همیشه برای رابط عامل بارگذاری می شود.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            'لیستی از فایل های CSS پاسخگو برای همیشه برای رابط مشتری بارگذاری می شود.',
        'List view' => 'نمایش لیستی',
        'Lithuanian' => 'زبان لیتوانی',
        'Lock / unlock this ticket' => 'قفل / باز کردن این درخواست',
        'Locked Tickets.' => 'درخواست قفل شده است.',
        'Locked ticket.' => 'سابقه::تحویل گرفتن درخواست',
        'Log file for the ticket counter.' => 'فایل ثبت وقایع برای شمارنده درخواست',
        'Logout of customer panel.' => 'خروج از پنل مشتری.',
        'Loop-Protection! No auto-response sent to "%s".' => 'حلقه حفاظت! بدون پاسخ خودکار ارسال به \ " %s ".',
        'Mail Accounts' => 'حساب های پست الکترونیکی',
        'Main menu registration.' => 'ثبت نام منوی اصلی.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'باعث می شود نرم افزار چک رکورد MX از آدرس های ایمیل قبل از ارسال ایمیل و یا ارسال یک تلفن و یا ایمیل بلیط.',
        'Makes the application check the syntax of email addresses.' => 'باعث می شود نرم افزار چک نحو آدرس ایمیل.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'باعث می شود مدیریت جلسه کوکی استفاده از HTML. اگر کوکی ها اچ غیر فعال و یا اگر کوکی ها مرورگر HTML غیر فعال است مشتری، سپس سیستم به طور معمول کار خواهد کرد و اضافه ID جلسه به لینک ها',
        'Malay' => 'مالایا',
        'Manage OTRS Group cloud services.' => 'مدیریت OTRS گروه خدمات ابر.',
        'Manage PGP keys for email encryption.' => 'مدیریت کلیدهای PGP برای رمزنگاری ایمیل',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'مدیریت حساب‌های POP3 و IMAP برای واکشی ایمیل‌ها',
        'Manage S/MIME certificates for email encryption.' => 'مدیریت گواهینامه‌ها برای رمزنگاری ایمیل‌ها',
        'Manage existing sessions.' => 'مدیریت session های موجود',
        'Manage support data.' => 'مدیریت داده پشتیبانی می کند.',
        'Manage system registration.' => 'مدیریت ثبت نام سیستم.',
        'Manage tasks triggered by event or time based execution.' => 'مدیریت وظایف موجب شده توسط رویداد یا زمان اجرای .',
        'Mark this ticket as junk!' => 'علامت گذاری به عنوان این درخواست به عنوان آشغال!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'حداکثر اندازه (در شخصیت) از جدول اطلاعات مربوط به مشتری (تلفن و ایمیل) در صفحه نوشتن.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'حداکثر اندازه (در ردیف) از عوامل آگاه در رابط عامل جعبه.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'حداکثر اندازه (در ردیف) از جمله عوامل مرتبط در رابط عامل جعبه.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'حداکثر اندازه از افراد در یک پاسخ ایمیل و در برخی از صفحه نمایش مرور کلی.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'پاسخ به ایمیل خودکار حداکثر به خود آدرس ایمیل در روز (حلقه حفاظت).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'اندازه حداکثر در کیلو بایت برای ایمیل است که می تواند از طریق POP3 / POP3S / IMAP / IMAPS (کیلو بایت) برگردانده شده.',
        'Maximum Number of a calendar shown in a dropdown.' => 'حداکثر تعداد یک تقویم نشان داده شده در منوی کرکره ای.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'حداکثر طول (به نویسه) زمینه پویا در مقاله از نظر زوم درخواست',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'حداکثر طول (به نویسه) زمینه پویا در نوار کناری از نظر زوم درخواست',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'حداکثر تعداد بلیط در نتیجه یک جستجو در رابط عامل نمایش داده میشود.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'حداکثر تعداد درخواست در نتیجه یک جستجو در رابط مشتری نمایش داده می شود.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'حداکثر تعداد درخواست در نتیجه این کار نمایش داده می شود.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'حداکثر اندازه (در شخصیت) از جدول اطلاعات مربوط به مشتری در نظر زوم بلیط.',
        'Merge this ticket and all articles into a another ticket' => 'ادغام این درخواست و تمام مقالات با درخواست دیگر',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'با هم ادغام شدند بلیط <OTRS_TICKET> تا <OTRS_MERGE_TO_TICKET>.',
        'Miscellaneous' => 'تنظیمات اضافی',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'ماژول برای انتخاب در صفحه نمایش درخواست جدید در رابط مشتری.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            'ماژول برای بررسی اگر ایمیل وارد باید به عنوان ایمیل داخلی (به دلیل ایمیل داخلی فرستاده اصلی) مشخص شده اند. ArticleType و SenderType ارزش برای ایمیل / مقاله وارد تعریف کنیم.',
        'Module to check the group permissions for customer access to tickets.' =>
            'ماژول برای بررسی مجوز گروه برای دسترسی مشتری به درخواست',
        'Module to check the group permissions for the access to tickets.' =>
            'ماژول برای بررسی مجوز گروه برای دسترسی به درخواست.',
        'Module to compose signed messages (PGP or S/MIME).' => 'ماژول برای نوشتن پیام های امضا (PGP و یا S / MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'ماژول برای دخمه پیام های تشکیل شده (PGP و یا S / MIME).',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            'ماژول به بهانه کاربران مشتری SMIME گواهی از پیام های دریافتی.',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'ماژول برای فیلتر کردن و دستکاری پیام های دریافتی. بلوک / چشم پوشی از همه ایمیل های اسپم با از: noreply @ آدرس.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'ماژول برای فیلتر کردن و دستکاری پیام های دریافتی. مطلع یک شماره 4 رقمی به بلیط های متنی رایگان، استفاده از عبارت منظم را در بازی به عنوان مثال از => \'(. +) @. +؟ "، و استفاده از () به عنوان [***] در مجموعه ای =>.',
        'Module to filter encrypted bodies of incoming messages.' => 'ماژول برای فیلتر بدن رمزگذاری شده از پیام های دریافتی.',
        'Module to generate accounted time ticket statistics.' => 'ماژول برای تولید آمار زمان بود.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'ماژول برای تولید مشخصات opensearch بر روی HTML برای جستجو بلیط کوتاه در رابط عامل.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'ماژول برای تولید مشخصات opensearch بر روی HTML برای جستجو بلیط کوتاه در رابط مشتری.',
        'Module to generate ticket solution and response time statistics.' =>
            'ماژول برای تولید راه حل درخواست و آمار زمان پاسخ.',
        'Module to generate ticket statistics.' => 'ماژول برای تولید آماردرخواست.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'ماژول برای اعطای دسترسی اگر CustomerID بلیط مسابقات CustomerID مشتری باشد.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'ماژول برای اعطای دسترسی اگر CustomerUserID بلیط مسابقات CustomerUserID مشتری باشد.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'ماژول برای اعطای دسترسی به هر عامل است که یک بلیط در گذشته درگیر (بر اساس نوشته های تاریخ بلیط).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'ماژول برای اعطای دسترسی به عامل مسئول یک درخواست.',
        'Module to grant access to the creator of a ticket.' => 'ماژول برای اعطای دسترسی به خالق یک درخواست .',
        'Module to grant access to the owner of a ticket.' => 'ماژول برای اعطای دسترسی به صاحب یک درخواست.',
        'Module to grant access to the watcher agents of a ticket.' => 'ماژول برای اعطای دسترسی به عوامل نگهبان یک درخواست.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'ماژول برای نمایش اعلام و escalations (ShownMax: حداکثر escalations نشان داده شده است، EscalationInMinutes: بلیط نمایش که تشدید، CacheTime خواهد شد: کش از escalations محاسبه در ثانیه).',
        'Module to use database filter storage.' => 'ماژول برای استفاده از ذخیره سازی فیلتر پایگاه داده.',
        'Multiselect' => 'چندین انتخاب',
        'My Services' => 'خدمات من',
        'My Tickets.' => 'درخواست من.',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'نام صف سفارشی. صف های سفارشی انتخاب صف از صف مورد نظر خود را است و می تواند در تنظیمات تنظیمات انتخاب شده است.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'نام خدمات سفارشی. خدمات سفارشی انتخاب خدمات خدمات مورد نظر خود را است و می تواند در تنظیمات تنظیمات انتخاب شده است.',
        'NameX' => 'NameX',
        'Nederlands' => 'هلند',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'درخواست جدید [ %s ] ایجاد شده (Q = %s ؛ P = %s ؛ S = %s ).',
        'New Window' => 'پنجره جدید',
        'New owner is "%s" (ID=%s).' => 'مالک جدید \ "است %s " (ID = %s ).',
        'New process ticket' => 'درخواست فرآیند جدید',
        'New responsible is "%s" (ID=%s).' => ' مسئول جدید \ "است %s " (ID = %s ).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'بعدی ایالات بلیط ممکن است پس از اضافه کردن یک یادداشت تلفن در گوشی بلیط صفحه نمایش بین المللی به درون رابط عامل.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'بعدی ایالات بلیط ممکن است پس از اضافه کردن یک یادداشت تلفن در صفحه نمایش خروجی تلفن بلیط رابط عامل.',
        'None' => 'هیچ',
        'Norwegian' => 'نروژی',
        'Notification sent to "%s".' => 'اعلان ارسال به \ " %s ".',
        'Number of displayed tickets' => 'تعداد درخواست‌های نمایش داده شده',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'تعداد خطوط (در هر بلیط) که توسط ابزار جستجو در رابط عامل نشان داده شده است.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'تعداد بلیط در هر صفحه از یک نتیجه جستجو در رابط عامل نمایش داده شود.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'تعداد بلیط در هر صفحه از یک نتیجه جستجو در رابط مشتری نمایش داده می شود.',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTRS می توانید یک یا چند پایگاه داده آینه فقط خواندنی برای عملیات گران قیمت مانند جستجو و یا آمار نسل متن استفاده کنید. در اینجا شما می توانید DSN برای پایگاه داده آینه اول را مشخص کنید.',
        'Old: "%s" New: "%s"' => 'قدیمی: \ " %s " جدید: \ " %s "',
        'Online' => 'آنلاین',
        'Open tickets (customer user)' => 'درخواست باز (کاربران مشتری)',
        'Open tickets (customer)' => 'درخواست گسترش (مشتری)',
        'Option' => 'انتخاب',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'محدودیت صف اختیاری برای ماژول اجازه CreatorCheck. اگر تعیین شود، مجوز فقط برای بلیط در صف مشخص اعطا می شود.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'محدودیت صف اختیاری برای ماژول اجازه InvolvedCheck. اگر تعیین شود، مجوز فقط برای بلیط در صف مشخص اعطا می شود.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'محدودیت صف اختیاری برای ماژول اجازه OwnerCheck. اگر تعیین شود، مجوز فقط برای بلیط در صف مشخص اعطا می شود.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'محدودیت صف اختیاری برای ماژول اجازه ResponsibleCheck. اگر تعیین شود، مجوز فقط برای بلیط در صف مشخص اعطا می شود.',
        'Out Of Office' => 'بیرون از دفتر',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'اضافه بار (باز تعریف) توابع موجود در هسته :: :: سیستم بلیط. استفاده به راحتی سفارشی اضافه کنید.',
        'Overview Escalated Tickets.' => 'درخواست تشدید هفتگی.',
        'Overview Refresh Time' => 'نمای کلی زمان بازسازی',
        'Overview of all escalated tickets.' => 'نمای کلی از تمام بلیط افزایش یافت.',
        'Overview of all open Tickets.' => 'نمایی کلی از تمام درخواست‌های باز',
        'Overview of all open tickets.' => 'نمای کلی از تمام درخواست باز.',
        'Overview of customer tickets.' => 'بررسی اجمالی از  درخواست مشتری .',
        'PGP Key Management' => 'PGP مدیریت کلید',
        'PGP Key Upload' => 'ارسال کلید PGP',
        'Package event module file a scheduler task for update registration.' =>
            'بسته ماژول رویداد پرونده وظیفه زمانبند برای ثبت نام به روز رسانی.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'پارامترهای CreateNextMask در نظر اولویت از رابط عامل شی.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'پارامترهای CustomQueue در نظر اولویت از رابط عامل شی.',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            'پارامترهای شی CustomService در نظر اولویت از رابط عامل.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'پارامترهای RefreshTime در نظر اولویت از رابط عامل شی.',
        'Parameters for the column filters of the small ticket overview.' =>
            'پارامترهای فیلتر ستون از نمای کلی درخواست کوچک است.',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'پارامترهای باطن داشبورد از اطلاعات مشتری از رابط عامل. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'پارامترهای باطن داشبورد از شناسه مشتری ویجت وضعیت رابط عامل. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'پارامترهای باطن داشبورد لیست کاربران مشتری مروری بر رابط عامل. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'پارامترهای باطن داشبورد از بلیط های جدید نمای کلی از رابط عامل. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است. توجه: فقط بلیط صفات و زمینه های پویا (DynamicField_NameX) برای DefaultColumns مجاز می باشد. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'پارامترهای باطن داشبورد از بلیط باز کلی از رابط عامل. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است. توجه: فقط بلیط صفات و زمینه های پویا (DynamicField_NameX) برای DefaultColumns مجاز می باشد. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'پارامترهای باطن داشبورد ویدجت کلی صف از رابط عامل. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "QueuePermissionGroup " اجباری نیست، صف فقط ذکر شده در صورتی که به این گروه اجازه تعلق اگر شما آن را فعال کنید. \ "ایالات " یک لیست از ایالات است، کلید ترتیب دولت در ویجت است. \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'پارامترهای باطن داشبورد از بلیط روند در حال اجرا نمای کلی از رابط عامل. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'پارامترهای باطن داشبورد کلی تشدید بلیط رابط عامل. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است. توجه: فقط بلیط صفات و زمینه های پویا (DynamicField_NameX) برای DefaultColumns مجاز می باشد. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال.',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'پارامترهای باطن داشبورد از وقایع و تقویم بلیط رابط عامل. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'پارامترهای باطن داشبورد بلیط در انتظار بررسی اجمالی یادآور رابط عامل. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است. توجه: فقط بلیط صفات و زمینه های پویا (DynamicField_NameX) برای DefaultColumns مجاز می باشد. تنظیمات ممکن: 0 = غیر فعال، 1 = موجود، 2 = پیش فرض فعال.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'پارامترهای باطن داشبورد از آمار بلیط رابط عامل. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است.',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'پارامترهای باطن داشبورد از برنامه های آینده از رابط عامل ویجت. \ "محدود " تعداد ورودی نشان داده شده است به طور پیش فرض است. \ "گروه " استفاده شده است برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " تعیین اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید. \ "CacheTTLLocal " زمان کش در دقیقه برای پلاگین است.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            'پارامترهای صفحات (که در آن زمینه های پویا نشان داده شده است) از نمای کلی زمینه های پویا.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'پارامترهای صفحات (که در آن درخواست نشان داده شده است) از نمای کلی درخواست متوسط.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'پارامترهای صفحات (که در آن درخواست نشان داده شده است) از نمای کلی درخواست کوچک است.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'پارامترهای صفحات (که در آن درخواست نشان داده شده است) از دید کلی پیش نمایش درخواست',
        'Parameters of the example SLA attribute Comment2.' => 'پارامترهای مثال SLA نسبت Comment2.',
        'Parameters of the example queue attribute Comment2.' => 'پارامترهای مثال صف نسبت Comment2.',
        'Parameters of the example service attribute Comment2.' => 'پارامترهای خدمات به عنوان مثال ویژگی Comment2.',
        'ParentChild' => 'ParentChild',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'راه را برای ورود به سیستم فایل (تنها در صورتی به \ "FS " برای LoopProtectionModule انتخاب شد و آن الزامی است).',
        'People' => 'کاربران',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            'انجام عمل پیکربندی برای هر رویداد (به عنوان یک Invoker) برای هر از webservice پیکربندی شده است.',
        'Permitted width for compose email windows.' => 'عرض مجاز برای ویندوز نوشتن ایمیل.',
        'Permitted width for compose note windows.' => 'عرض مجاز برای ویندوز توجه داشته باشید نوشتن.',
        'Persian' => 'فارسی',
        'Phone Call.' => 'شماره تماس',
        'Picture Upload' => 'تصویر آپلود',
        'Picture upload module.' => 'تصویر ماژول آپلود.',
        'Picture-Upload' => 'تصویر آپلود',
        'Polish' => 'لهستانی',
        'Portuguese' => 'پرتغالی',
        'Portuguese (Brasil)' => 'پرتغالی (برزیل)',
        'PostMaster Filters' => 'فیلترهای پستی',
        'PostMaster Mail Accounts' => 'حساب‌های ایمیل پستی',
        'Process Management Activity Dialog GUI' => 'فرآیند مدیریت فعالیت های گفت و گو GUI',
        'Process Management Activity GUI' => 'روند GUI مدیریت فعالیت',
        'Process Management Path GUI' => 'روند GUI مسیر مدیریت',
        'Process Management Transition Action GUI' => 'مدیریت فرآیند GUI انتقال اقدام',
        'Process Management Transition GUI' => 'روند GUI انتقال مدیریت',
        'Process Ticket.' => ' روند درخواست.',
        'Process pending tickets.' => 'پردازش درخواست در انتظار.',
        'Process ticket' => 'روند درخواست',
        'ProcessID' => 'ProcessID',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'محافظت در برابر CSRF (صلیب سایت درخواست جعل) سوء استفاده (برای اطلاعات بیشتر http://en.wikipedia.org/wiki/Cross-site_request_forgery را ببینید).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            'فراهم می کند مروری ماتریس از بلیط در هر حالت در صف.',
        'Queue view' => 'نمای صف درخواست',
        'Rebuild the ticket index for AgentTicketQueue.' => 'بازسازی شاخص بلیط برای AgentTicketQueue.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            'تشخیص اگر یک بلیط یک پیگیری بلیط های موجود برای استفاده از تعداد بلیط های خارجی است.',
        'Refresh interval' => 'بارگذاری مجدد ورودی',
        'Removed subscription for user "%s".' => 'عضویت حذف شده برای کاربر"%s".',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'حذف درخواست نگهبان اطلاعات زمانی که درخواست بایگانی شده است.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be active in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            'تجدید گواهی SMIME موجود از باطن مشتری می باشد. توجه: SMIME و SMIME :: FetchFromCustomer نیاز به فعال بودن در SysConfig و باطن مشتری نیاز به پیکربندی به بهانه ویژگی UserSMIMECertificate.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'جایگزین فرستنده اصلی با آدرس ایمیل مشتری فعلی در پاسخ نوشتن در صفحه نوشتن بلیط رابط عامل.',
        'Reports' => 'گزارشات',
        'Reports (OTRS Business Solution™)' => 'گزارش (OTRS کسب و کار راه حل ™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            'پردازش مجدد ایمیل از دایرکتوری قرقره است که نمی تواند در وهله اول وارد شود.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'دسترسی مورد نیاز برای تغییر درخواست دهنده ی یک درخواست در صفحه ی کارشناس.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش درخواست نزدیک در صفحه ی کارشناس.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش خروجی ایمیل در صفحه ی کارشناس.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش پرش درخواست در صفحه ی کارشناس .',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش آهنگسازی درخواست در صفحه ی کارشناس.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش انتقال درخواست در صفحه ی کارشناس.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده ازدرخواست صفحه نمایش های متنی رایگان در صفحه ی کارشناس.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش ادغام درخواست یک درخواست زوم شده  در صفحه ی کارشناس.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش توجه داشته باشید بلیط در رابط عامل.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش صاحب بلیط یک بلیط بزرگنمایی در رابط عامل.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش های ورودی تلفن بلیط در رابط عامل.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش خروجی تلفن بلیط در رابط عامل.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'دسترسی مورد نیاز برای استفاده از درخواست صفحه نمایش در صفحه ی کارشناس.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'بازنشانی و بازکردن دسترسی صاحب یک درخواست اگر آن را به صف دیگری انتقال داده.',
        'Responsible Tickets' => 'کارشناس درخواست',
        'Responsible Tickets.' => 'کارشناس درخواست.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            'بازیابی یک بلیط از آرشیو (فقط در صورتی که این رویداد تغییر دولت به هر حالت باز موجود است).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'حفظ تمام خدمات در لیست حتی اگر آنها کودکان از عناصر نامعتبر است.',
        'Right' => 'راست',
        'Roles <-> Groups' => 'نقش <-> گروه',
        'Run file based generic agent jobs (Note: module name need needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            'فایل اجرا بر اساس شغل عامل عمومی (توجه: نام ماژول نیاز به در پیکربندی ماژول PARAM مثلا \ "هسته :: :: سیستم GenericAgent " مشخص شود).',
        'Running Process Tickets' => 'در حال اجرا فرآیند درخواست',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'اجرا می شود جستجو کلمات اولیه این شرکت مشتری های موجود در هنگام دسترسی به ماژول AdminCustomerCompany است.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'اجرا می شود جستجو کلمات اولیه از کاربران مشتری های موجود در هنگام دسترسی به ماژول AdminCustomerUser است.',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'اجرا می شود سیستم در \ "نسخه ی نمایشی " حالت. اگر به \ "بله "، عوامل می توانید تنظیمات از قبیل انتخاب زبان و از طریق رابط وب عامل را تغییر دهید. این تغییرات تنها برای جلسه فعلی معتبر هستند. این ممکن نخواهد بود برای عوامل به تغییر کلمه عبور خود را.',
        'Russian' => 'روسی',
        'S/MIME Certificate Upload' => 'S / MIME گواهی آپلود',
        'SMS' => 'پیامک',
        'SMS (Short Message Service)' => 'اس ام اس (خدمات پیام کوتاه)',
        'Sample command output' => 'خروجی دستور نمونه',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            'موجب صرفه جویی در فایل پیوست مقالات. \ "DB " فروشگاه تمام اطلاعات در پایگاه داده (برای ذخیره سازی فایل پیوست بزرگ توصیه نمی شود). \ "FS " ذخیره اطلاعات در فایل سیستم. این است سریع تر اما وب سرور باید تحت کاربر OTRS اجرا کنید. شما می توانید بین ماژول حتی در یک سیستم است که در حال حاضر در تولید بدون از دست دادن داده ها تغییر دهید. توجه داشته باشید: جستجو برای نام دلبستگی پشتیبانی نمی که \ "FS " استفاده شده است.',
        'Schedule a maintenance period.' => 'برنامه ریزی یک دوره تعمیر و نگهداری.',
        'Screen' => 'صفحه نمایش',
        'Search Customer' => 'جستجوی مشترک',
        'Search Ticket.' => 'جستجو درخواست.',
        'Search Tickets.' => 'درخواست های جستجو.',
        'Search User' => 'جستجوی کاربر',
        'Search backend default router.' => 'جستجو باطن روتر به طور پیش فرض.',
        'Search backend router.' => 'جستجو  باطن روتر.',
        'Search.' => 'جستجو',
        'Second Queue' => 'صف دوم',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select your frontend Theme.' => 'الگوی نمایش سیستم را انتخاب نمائید',
        'Select your preferred layout for OTRS.' => '',
        'Selects the cache backend to use.' => 'باطن کش استفاده انتخاب می کند.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'ماژول که مسئولیت رسیدگی به ارسال از طریق رابط وب انتخاب می کند. \ "DB " فروشگاه های ارسال همه در پایگاه داده، \ "FS " با استفاده از سیستم فایل.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'ماژول بلیط مولد عدد انتخاب می کند. \ "AUTOINCREMENT " واحد افزایش تعداد بلیط، سیستم را و شمارنده با فرمت SystemID.counter (به عنوان مثال 1010138، 1010139) استفاده می شود. با \ "تاریخ " شماره بلیط خواهد شد تاریخ فعلی، سیستم را و شمارنده تولید می شود. فرمت نظر می رسد مانند Year.Month.Day.SystemID.counter (به عنوان مثال 200206231010138، 200206231010139). با \ "DateChecksum " مقابله به عنوان کنترلی به رشته ای از تاریخ و سیستم را اضافه خواهد شد. کنترلی خواهد شد به صورت روزانه چرخش. فرمت نظر می رسد مانند Year.Month.Day.SystemID.Counter.CheckSum (به عنوان مثال 2002070110101520، 2002070110101535). \ "تصادفی " تولید اعداد تصادفی بلیط در قالب \ "SystemID.Random " (به عنوان مثال 100057866352، 103745394596).',
        'Send new outgoing mail from this ticket' => 'ارسال ایمیل های ارسالی جدید این درخواست از',
        'Send notifications to users.' => 'ارسال اعلان‌ها به کاربران',
        'Sender type for new tickets from the customer inteface.' => 'نوع فرستنده برای درخواست جدید از inteface مشتری.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'می فرستد عامل پیگیری اطلاع رسانی تنها به مالک، اگر یک بلیط قفل شده است (به طور پیش فرض است که برای ارسال اطلاع رسانی به تمام عوامل).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'می فرستد تمام ایمیل های خروجی از طریق BCC به آدرس مشخص شده. لطفا این تنها به دلایل پشتیبان استفاده کنید.',
        'Sends customer notifications just to the mapped customer.' => 'می فرستد اطلاعیه مشتری فقط به مشتری نقشه برداری.',
        'Sends registration information to OTRS group.' => 'ارسال اطلاعات ثبت نام به گروه OTRS.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'می فرستد اطلاعیه یادآور بلیط قفل پس از رسیدن به تاریخ یادآوری (فقط به صاحب بلیط ارسال).',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'می فرستد اطلاعیه که در رابط مدیریت تحت \ پیکربندی "اعلان (رویداد) ".',
        'Serbian Cyrillic' => 'سیریلیک صربستان',
        'Serbian Latin' => 'صربی لاتین',
        'Service view' => 'نمای سرویس',
        'ServiceView' => 'ServiceView',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => 'تنظیم آدرس ایمیل‌های ارسال‌کننده برای این سیستم',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'مجموعه ای از ارتفاع به طور پیش فرض (به پیکسل) مقالات HTML درون خطی در AgentTicketZoom.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'مجموعه ای از محدودیت بلیط خواهد شد که در یک اعدام کار genericagent تک اجرا می شود.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'تنظیم حداکثر ارتفاع (به پیکسل) مقالات HTML درون خطی در AgentTicketZoom.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'با تنظیم این بله اگر شما در تمام کلید PGP عمومی و خصوصی خود را اعتماد، حتی اگر آنها را با یک امضا اعتماد تایید شده است.',
        'Sets if SLA must be selected by the agent.' => 'مجموعه SLA باید توسط کارشناس انتخاب شود.',
        'Sets if SLA must be selected by the customer.' => 'مجموعه SLA باید توسط مشتری انتخاب شود.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'مجموعه توجه داشته باشید باید در عامل پر شده است. می توان با بلیط :: ظاهر :: NeedAccountedTime رونویسی.',
        'Sets if service must be selected by the agent.' => 'مجموعه  سرویس باید توسط عامل انتخاب شود.',
        'Sets if service must be selected by the customer.' => 'مجموعه  سرویس باید توسط مشتری انتخاب شود.',
        'Sets if ticket owner must be selected by the agent.' => 'مجموعه صاحب درخواست باید توسط عامل انتخاب شود.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'مجموعه PendingTime یک بلیط تا 0، از اگر دولت به حالت عدم در حال بررسی تغییر کرده است.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'مجموعه سن در دقیقه (سطح اول) برای برجسته صف که حاوی بلیط دست نخورده.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'مجموعه سن در دقیقه (سطح دوم) برای برجسته صف که حاوی بلیط دست نخورده.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'سطح پیکربندی مدیر تنظیم می کند. بسته به سطح پیکربندی، برخی از گزینه های sysconfig نشان داده نخواهد کرد. سطوح config هستند در به ترتیب صعودی: کارشناس، پیشرفته، مبتدی. سطح پیکربندی بالاتر است (به عنوان مثال مبتدی بالاترین است)، به احتمال زیاد کمتر از آن است که کاربر به طور تصادفی می تواند پیکربندی سیستم در یک راه آن است که قابل استفاده نمی شود.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'تعداد مقالات در حالت پیش نمایش از مروری بلیط قابل مشاهده تنظیم می کند.',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'به طور پیش فرض نوع مقاله برای بلیط ایمیل جدید در رابط عامل تنظیم می کند.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'به طور پیش فرض نوع مقاله برای بلیط تلفن جدید در رابط عامل تنظیم می کند.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'به طور پیش فرض متن برای یادداشت اضافه شده در صفحه نمایش بلیط نزدیک رابط عامل تنظیم می کند.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'به طور پیش فرض متن برای یادداشت اضافه شده در روی صفحه نمایش حرکت بلیط رابط عامل تنظیم می کند.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'به طور پیش فرض متن برای یادداشت اضافه شده در صفحه نمایش توجه داشته باشید بلیط رابط عامل تنظیم می کند.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'به طور پیش فرض متن برای یادداشت اضافه شده در صفحه نمایش صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'به طور پیش فرض متن برای یادداشت اضافه شده در صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'به طور پیش فرض متن برای یادداشت اضافه شده در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'به طور پیش فرض متن برای یادداشت اضافه شده در بلیط صفحه نمایش مسئول رابط عامل تنظیم می کند.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'مجموعه پیغام خطای پیش فرض برای صفحه ورود به سیستم در عامل و رابط مشتری، آن را نشان داده زمانی که یک دوره تعمیر و نگهداری سیستم در حال اجرا فعال است.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'به طور پیش فرض نوع لینک بلیط خرد شده در رابط عامل تنظیم می کند.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'مجموعه پیام پیش فرض برای صفحه ورود به سیستم در عامل و رابط مشتری، آن را نشان داده زمانی که یک دوره تعمیر و نگهداری سیستم در حال اجرا فعال است.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'مجموعه پیام پیش فرض برای اطلاع رسانی است که در یک دوره تعمیر و نگهداری سیستم در حال اجرا نشان داده شده است.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'به طور پیش فرض حالت بعدی برای درخواست تلفن جدید را در صفحه ی کارشناس تنظیم می کند.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'مجموعه به طور پیش فرض حالت بلیط آینده، پس از ایجاد یک بلیط ایمیل در رابط عامل.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'متن پیش فرض توجه داشته باشید برای بلیط تلفن جدید تنظیم می کند. به عنوان مثال \'بلیط جدید از طریق تماس در رابط عامل.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'مجموعه از اولویت پیش فرض برای بلیط ایمیل جدید در رابط عامل.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'مجموعه از اولویت پیش فرض برای بلیط تلفن جدید در رابط عامل.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'به طور پیش فرض نوع فرستنده برای بلیط ایمیل جدید در رابط عامل تنظیم می کند.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'به طور پیش فرض نوع فرستنده برای بلیط تلفن جدید در رابط عامل تنظیم می کند.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'مجموعه این موضوع به طور پیش فرض برای بلیط ایمیل جدید (به عنوان مثال، عازم ناحیه دور دست ایمیل \') در رابط عامل.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'مجموعه این موضوع به طور پیش فرض برای بلیط گوشی جدید (به عنوان مثال «تماس با تلفن) در رابط عامل.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'مجموعه تم پیش فرض برای یادداشت های اضافه شده در صفحه نمایش بلیط نزدیک رابط عامل.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'مجموعه این موضوع به طور پیش فرض برای یادداشت اضافه شده در روی صفحه نمایش حرکت بلیط رابط عامل.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'مجموعه تم پیش فرض برای یادداشت های اضافه شده در صفحه نمایش توجه داشته باشید بلیط رابط عامل.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'مجموعه تم پیش فرض برای یادداشت های اضافه شده در صفحه نمایش صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'مجموعه تم پیش فرض برای یادداشت های اضافه شده در صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'مجموعه تم پیش فرض برای یادداشت های اضافه شده در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'مجموعه این موضوع به طور پیش فرض برای یادداشت اضافه شده در بلیط صفحه نمایش مسئول رابط عامل.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'متن پیش فرض برای بلیط ایمیل جدید در رابط عامل تنظیم می کند.',
        'Sets the display order of the different items in the preferences view.' =>
            'مجموعه سفارش صفحه نمایش از آیتم های مختلف در نمایش تنظیمات.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            'مجموعه زمان عدم فعالیت (در ثانیه) به تصویب قبل از یک جلسه کشته و یک کاربر وارد شده است است.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime before a prior warning will be visible for the logged in agents.' =>
            'حداکثر تعداد از عوامل فعال در بازه زمانی در SessionActiveTime قبل یک هشدار قبل تعریف شده قابل دیدن خواهد بود برای در عوامل وارد سایت شوید.',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            'مجموعه حداکثر تعداد عوامل فعال در بازه زمانی تعریف شده در SessionActiveTime.',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            'حداکثر تعداد مشتریان فعال در بازه زمانی تعریف شده در SessionActiveTime.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            'مجموعه حداکثر تعداد جلسات فعال در هر عامل در بازه زمانی تعریف شده در SessionActiveTime.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            'مجموعه حداکثر تعداد جلسات فعال در هر مشتریان در بازه زمانی تعریف شده در SessionActiveTime.',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            'مجموعه حداقل اندازه بلیط ضد اگر \ "AUTOINCREMENT " به عنوان TicketNumberGenerator انتخاب شد. به طور پیش فرض 5 است، این به معنای ضد از 10،000 شروع می شود.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'در دقیقه یک اطلاع رسانی برای اطلاع در مورد دوره تعمیر و نگهداری سیستم های آینده نشان داده شده است تنظیم می کند.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'مجموعه تعدادی از خطوط که در پیام های متنی (به عنوان مثال خطوط بلیط در QueueZoom) نمایش داده شود.',
        'Sets the options for PGP binary.' => 'مجموعه گزینه برای باینری PGP.',
        'Sets the order of the different items in the customer preferences view.' =>
            'مجموعه منظور از آیتم های مختلف در نظر ترجیحات مشتری.',
        'Sets the password for private PGP key.' => 'رمز عبور برای کلید PGP خصوصی تنظیم می کند.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'مجموعه واحد زمان مورد نظر (به عنوان مثال واحد کار، ساعت، دقیقه).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'پیشوند به پوشه Scripts بر روی سرور، به عنوان بر روی وب سرور پیکربندی تنظیم می کند. این تنظیم به عنوان یک متغیر، OTRS_CONFIG_ScriptAlias ​​است که در تمام اشکال پیام استفاده شده توسط برنامه پیدا شده است استفاده می شود، برای ساخت لینک به بلیط در سیستم.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'صف در بلیط صفحه نمایش نزدیک یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'صف در بلیط رایگان صفحه نمایش متن یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'صف در روی صفحه نمایش توجه داشته باشید بلیط یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'صف در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'صف در روی صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'صف در روی صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'صف در بلیط صفحه نمایش مسئول یک بلیط بزرگنمایی در رابط عامل از مجموعه.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'مجموعه عامل مسئول بلیط در صفحه نمایش بلیط نزدیک رابط عامل از.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'مجموعه عامل مسئول بلیط در صفحه نمایش فله بلیط رابط عامل از.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'مجموعه عامل مسئول بلیط در بلیط صفحه نمایش های متنی رایگان از رابط عامل از.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'مجموعه عامل مسئول بلیط در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل از.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'مجموعه عامل مسئول بلیط در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'مجموعه عامل مسئول بلیط در صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'مجموعه عامل مسئول بلیط در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'مجموعه عامل مسئول بلیط در بلیط صفحه نمایش مسئول رابط عامل از.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'مجموعه خدمات در روی صفحه نمایش بلیط نزدیک رابط عامل (بلیط :: خدمات نیاز به فعال شود).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'مجموعه خدمات در بلیط صفحه نمایش های متنی رایگان از رابط عامل (بلیط :: خدمات نیاز به فعال شود).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'مجموعه خدمات در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل (بلیط :: خدمات نیاز به فعال شود).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'مجموعه خدمات در روی صفحه نمایش صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از (بلیط :: خدمات نیاز به فعال شود).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'مجموعه خدمات در بلیط صفحه نمایش در حال بررسی یک بلیط بزرگنمایی در رابط عامل از (بلیط :: خدمات نیاز به فعال شود).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'مجموعه خدمات در روی صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از (بلیط :: خدمات نیاز به فعال شود).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'مجموعه خدمات در بلیط صفحه نمایش مسئول رابط عامل (بلیط :: خدمات نیاز به فعال شود).',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the stats hook.' => 'مجموعه آمار قلاب.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'مجموعه منطقه زمانی سیستم (نیاز به یک سیستم با ساعت محلی UTC تنظیم زمان سیستم). در غیر این صورت این زمان تفاوت را به وقت محلی است.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'مجموعه صاحب بلیط در صفحه نمایش بلیط نزدیک رابط عامل.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'مجموعه صاحب بلیط در صفحه نمایش فله بلیط رابط عامل.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'مجموعه صاحب بلیط در بلیط صفحه نمایش های متنی رایگان از رابط عامل.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'مجموعه صاحب بلیط در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'مجموعه صاحب بلیط در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'مجموعه صاحب بلیط در بلیط صفحه نمایش در حال بررسی یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'مجموعه صاحب بلیط در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'مجموعه صاحب بلیط در بلیط صفحه نمایش مسئول رابط عامل.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'مجموعه نوع بلیط در صفحه نمایش بلیط نزدیک رابط عامل (بلیط :: نوع نیاز به فعال شود).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'نوع بلیط در صفحه نمایش فله بلیط رابط عامل تنظیم می کند.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'مجموعه نوع بلیط در بلیط صفحه نمایش های متنی رایگان از رابط عامل (بلیط :: نوع نیاز به فعال شود).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'مجموعه نوع بلیط در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل (بلیط :: نوع نیاز به فعال شود).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'مجموعه نوع بلیط در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل از (بلیط :: نوع نیاز به فعال شود).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'مجموعه نوع بلیط در بلیط صفحه نمایش در حال بررسی یک بلیط بزرگنمایی در رابط عامل از (بلیط :: نوع نیاز به فعال شود).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'مجموعه نوع بلیط در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل از (بلیط :: نوع نیاز به فعال شود).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'مجموعه نوع بلیط در بلیط صفحه نمایش مسئول رابط عامل (بلیط :: نوع نیاز به فعال شود).',
        'Sets the time (in seconds) a user is marked as active (minimum active time is 300 seconds).' =>
            'مجموعه زمان (در ثانیه) یک کاربر به عنوان فعال مشخص شده (حداقل زمان فعال 300 ثانیه است).',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'ایست (در ثانیه) برای دریافت HTTP / FTP تنظیم می کند.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'ایست (در ثانیه) برای دریافت بسته را تنظیم میکند. رونویسی \ "WebUserAgent :: اتمام مهلت ".',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'مجموعه منطقه زمانی کاربر در هر کاربر (نیاز به یک سیستم با ساعت محلی UTC تنظیم زمان سیستم و تحت UTC محلی). در غیر این صورت این زمان تفاوت را به وقت محلی است.',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'مجموعه منطقه زمانی کاربر در هر کاربر بر اساس جاوا اسکریپت / مرورگر منطقه زمانی ویژگی جبران در زمان ورود به سیستم.',
        'Shared Secret' => 'راز مشترک',
        'Should the cache data be held in memory?' => 'باید داده های کش در حافظه برگزار می شود؟',
        'Should the cache data be stored in the selected cache backend?' =>
            'باید داده های کش در انتخاب کش باطن ذخیره می شود؟',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'نمایش یک انتخاب مسئول در تلفن و ایمیل بلیط در رابط عامل.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'مشاهده مقاله به عنوان متن غنی حتی اگر نوشتن متن غنی غیر فعال است.',
        'Show queues even when only locked tickets are in.' => 'نمایش صف حتی زمانی که بلیط تنها قفل شده در هستند.',
        'Show the current owner in the customer interface.' => 'نمایش مالک فعلی در رابط مشتری.',
        'Show the current queue in the customer interface.' => 'نمایش صف فعلی در رابط مشتری.',
        'Show the history for this ticket' => 'نشان دادن تاریخ این بلیط برای',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'نشان می دهد یک تعداد از آیکون در زوم بلیط، اگر مقاله پیوست دارد.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منو برای اشتراک / لغو اشتراک یک بلیط در نظر زوم بلیط رابط عامل از نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی که اجازه می دهد تا ارتباط یک بلیط با یکی دیگر از جسم در نظر زوم بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی که اجازه می دهد تا ادغام بلیط در نظر زوم بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منو برای دسترسی به تاریخ یک بلیط در نظر زوم بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'نشان می دهد یک لینک در منو به اضافه کردن یک فیلد متنی رایگان در نظر زوم بلیط رابط عامل. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی نشان می دهد به اضافه کردن یک یادداشت در نظر زوم بلیط رابط عامل. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'نشان می دهد یک لینک در منو به اضافه کردن یک یادداشت یک بلیط به در هر مروری بلیط رابط عامل.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'یک لینک در منوی نشان می دهد برای بستن یک بلیط در هر مروری بلیط رابط عامل.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی نشان می دهد برای بستن یک بلیط در نظر زوم بلیط رابط عامل. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'یک لینک در منو به حذف یک بلیط در هر مروری بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منو به یک بلیط در نظر زوم بلیط رابط عامل حذف نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'نشان می دهد یک لینک در منوی ثبت نام یک بلیط به یک فرایند در نظر زوم بلیط رابط عامل.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منو برای رفتن در نظر زوم بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'یک لینک در منو به قفل / باز کردن یک بلیط در مروری بلیط رابط عامل نشان می دهد.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منو به قفل / باز کردن بلیط در نظر زوم بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'یک لینک در منوی نشان می دهد به حرکت یک بلیط در هر مروری بلیط رابط عامل.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'نشان می دهد یک لینک در منو به چاپ یک بلیط یا یک مقاله در نظر زوم بلیط رابط عامل. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی نشان می دهد برای دیدن مشتری که بلیط در نظر زوم بلیط رابط عامل درخواست شده است. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'یک لینک در منوی نشان می دهد برای دیدن تاریخ یک بلیط در هر مروری بلیط رابط عامل.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی نشان می دهد برای دیدن صاحب یک بلیط در نظر زوم بلیط رابط عامل. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی نشان می دهد برای دیدن اولویت یک بلیط در نظر زوم بلیط رابط عامل. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی نشان می دهد برای دیدن عامل مسئول یک بلیط در نظر زوم بلیط رابط عامل. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منوی نشان می دهد به ارسال یک ایمیل عازم ناحیه دور دست در نظر زوم بلیط رابط عامل. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'یک لینک در منو برای تنظیم یک بلیط به عنوان آشغال در هر مروری بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک در منو برای تنظیم یک بلیط به عنوان انتظار در نظر زوم بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'یک لینک در منو برای تنظیم اولویت یک بلیط در هر مروری بلیط رابط عامل نشان می دهد.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'یک لینک در منوی نشان می دهد به زوم یک بلیط در مروری بلیط رابط عامل.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'یک لینک برای دسترسی به فایل پیوست مقاله از طریق یک بیننده آنلاین HTML در نظر زوم مقاله در رابط عامل نشان می دهد.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'یک لینک برای دانلود فایل پیوست مقاله در نظر زوم مقاله در رابط عامل نشان می دهد.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'یک لینک به یک بلیط ایمیل بزرگنمایی در متن ساده را نشان می دهد.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'یک لینک به تنظیم یک بلیط به عنوان آشغال در نظر زوم بلیط رابط عامل نشان می دهد. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود. به خوشه آیتم های منو برای کلید \ "CLUSTERNAME " و برای محتوای هر نام شما می خواهید برای دیدن در UI استفاده کنید. استفاده از \ "ClusterPriority " برای پیکربندی سفارش از یک خوشه خاص در نوار ابزار.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'یک لیست از تمام عوامل درگیر این بلیط، در روی صفحه نمایش بلیط نزدیک رابط عامل نشان می دهد.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'یک لیست از تمام عوامل درگیر این بلیط، بلیط در صفحه نمایش های متنی رایگان از رابط عامل نشان می دهد.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'یک لیست از تمام عوامل درگیر این بلیط، در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل نشان می دهد.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'یک لیست از تمام عوامل درگیر این بلیط، در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'یک لیست از تمام عوامل درگیر این بلیط، در روی صفحه نمایش بلیط در انتظار یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'یک لیست از تمام عوامل درگیر این بلیط، در روی صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'یک لیست از تمام عوامل درگیر این بلیط، بلیط در صفحه نمایش مسئول رابط عامل نشان می دهد.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'یک لیست از تمام عوامل ممکن است (تمام عوامل با مجوز توجه داشته باشید صف / بلیط) به تعیین که باید در مورد این یادداشت مطلع، در صفحه نمایش بلیط نزدیک رابط عامل نشان می دهد.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'یک لیست از تمام عوامل ممکن است (تمام عوامل با مجوز توجه داشته باشید صف / بلیط) به تعیین که باید در مورد این یادداشت مطلع، در بلیط صفحه نمایش های متنی رایگان از رابط عامل نشان می دهد.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'یک لیست از تمام عوامل ممکن است (تمام عوامل با مجوز توجه داشته باشید صف / بلیط) به تعیین که باید در مورد این یادداشت مطلع، در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل نشان می دهد.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'یک لیست از تمام عوامل ممکن است (تمام عوامل با مجوز توجه داشته باشید صف / بلیط) به تعیین که باید در مورد این یادداشت مطلع، در صفحه نمایش صاحب بلیط یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'یک لیست از تمام عوامل ممکن است (تمام عوامل با مجوز توجه داشته باشید صف / بلیط) به تعیین که باید در مورد این یادداشت مطلع، در بلیط صفحه نمایش در حال بررسی یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'یک لیست از تمام عوامل ممکن است (تمام عوامل با مجوز توجه داشته باشید صف / بلیط) به تعیین که باید در مورد این یادداشت مطلع، در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'یک لیست از تمام عوامل ممکن است (تمام عوامل با مجوز توجه داشته باشید صف / بلیط) به تعیین که باید در مورد این یادداشت مطلع، در بلیط صفحه نمایش مسئول رابط عامل نشان می دهد.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'یک پیش نمایش کلی بلیط (- نشان می دهد نیز مشتری اطلاعات، CustomerInfoMaxSize حداکثر اندازه در شخصیت مشتری اطلاعات. CustomerInfo => 1) نشان می دهد.',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            'را نشان می دهد را انتخاب کنید از ویژگی های بلیط به سفارش لیست بلیط نمایش صف. انتخاب ممکن را می توان از طریق \'TicketOverviewMenuSort ### SortAttributes، پیکربندی شده است.',
        'Shows all both ro and rw queues in the queue view.' => 'همه هر دو صف RO و RW در نظر صف نشان می دهد.',
        'Shows all both ro and rw tickets in the service view.' => 'همه هر دو بلیط RO و RW در نظر خدمات.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'نشان می دهد تمام بلیط باز (حتی اگر آنها قفل شده است) در نظر تشدید رابط عامل.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'نشان می دهد تمام بلیط باز (حتی اگر آنها قفل شده است) در نظر وضعیت رابط عامل.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'تمام مقالات بلیط (استایرن) در نظر زوم را نشان می دهد.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'همه شناسه های مشتری در یک میدان چند را انتخاب کنید (مفید می کنید اگر شما یک مقدار زیادی از شناسه مشتری).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'انتخاب صاحب در تلفن و ایمیل بلیط در رابط عامل نشان می دهد.',
        'Shows colors for different article types in the article table.' =>
            'رنگ برای انواع مقاله های مختلف در جدول مقاله نشان می دهد.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'نشان می دهد بلیط تاریخ مشتری در AgentTicketPhone، AgentTicketEmail و AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'هم موضوع آخرین مقاله مشتری و یا به عنوان بلیط در بررسی اجمالی فرمت کوچک نشان می دهد.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'نشان می دهد موجود لیست صف والد / فرزند در سیستم در قالب یک درخت یا یک لیست.',
        'Shows information on how to start OTRS Daemon' => 'نشان می دهد اطلاعات در مورد چگونگی شروع OTRS دیمون',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'نشان می دهد که بلیط فعال ویژگی های در رابط مشتری (0 = معلولین و 1 = فعال کنید).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'مقالات طبقه بندی شده اند به طور معمول یا در جهت معکوس، تحت زوم بلیط در رابط عامل نشان می دهد.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'اطلاعات کاربر با مشتری (تلفن و ایمیل) در صفحه نوشتن را نشان می دهد.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'اطلاعات کاربر مشتری در نظر زوم بلیط نشان می دهد.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'پیام روز (MOTD) در داشبورد عامل نشان می دهد. \ "گروه " استفاده می شود برای محدود کردن دسترسی به پلاگین (به عنوان مثال گروه: مدیریت. GROUP1؛ GROUP2؛). \ "پیش فرض " نشان می دهد اگر این افزونه به طور پیش فرض و یا اگر کاربر نیاز به آن را فعال کنید به صورت دستی فعال کنید.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'پیام روز در صفحه ورود به رابط عامل نشان می دهد.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'تاریخ بلیط (معکوس دستور داد) در رابط عامل نشان می دهد.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'گزینه های اولویت بلیط در صفحه نمایش بلیط نزدیک رابط عامل نشان می دهد.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'گزینه های اولویت بلیط در صفحه نمایش بلیط حرکت از رابط عامل نشان می دهد.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'گزینه های اولویت بلیط در صفحه نمایش فله بلیط رابط عامل نشان می دهد.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'گزینه های اولویت بلیط در بلیط صفحه نمایش های متنی رایگان از رابط عامل نشان می دهد.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'گزینه های اولویت بلیط در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل نشان می دهد.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'گزینه های اولویت بلیط در صفحه صاحب بلیط یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'گزینه های اولویت بلیط در بلیط صفحه نمایش در حال بررسی یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'گزینه های اولویت بلیط در صفحه نمایش اولویت بلیط یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'گزینه های اولویت بلیط در بلیط صفحه نمایش مسئول رابط عامل نشان می دهد.',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            'قسمت عنوان در بلیط صفحه نمایش های متنی رایگان از رابط عامل نشان می دهد.',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'زمینه عنوان در صفحه بلیط نزدیک رابط عامل نشان می دهد.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'زمینه عنوان در روی صفحه نمایش توجه داشته باشید بلیط رابط عامل نشان می دهد.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'زمینه عنوان در صفحه نمایش صاحب بلیط یک بلیط بزرگنمایی در رابط عامل را نشان می دهد.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            ' در صفحه تعیین اولویت درخواست در انتظار یک درخواست زوم شده در رابط عامل را نشان می دهد.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'درصفحه ی تعیین اولویت درخواست مربوط به کارشناس را نمایش دهید.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'درصفحه ی تعیین اولویت درخواست مربوط به کارشناس فیلد عنوان را نمایش دهید.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'زمان را نشان می دهد در فرمت های طولانی (روز، ساعت، دقیقه)، اگر به \ "بله "؛ و یا در قالب کوتاه (روز، ساعت)، اگر به \ "بدون ".',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'نشان می دهد استفاده از زمان توضیحات کامل (روز، ساعت، دقیقه)، اگر به \ "بله "؛ یا فقط حرف اول (D، H، M)، اگر به \ "بدون ".',
        'Simple' => 'ساده',
        'Skin' => 'پوسته',
        'Slovak' => 'اسلواکی',
        'Slovenian' => 'اسلوونی',
        'Software Package Manager.' => 'نرم افزار مدیریت بسته بندی.',
        'SolutionDiffInMin' => 'SolutionDiffInMin',
        'SolutionInMin' => 'SolutionInMin',
        'Some description!' => 'برخی از توضیحات!',
        'Some picture description!' => 'برخی از توضیحات تصویر!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'انواع بلیط (ascendingly یا descendingly) که یک صف واحد در نمایش صف انتخاب و پس از بلیط ها با اولویت طبقه بندی شده اند. ارزش: 0 = صعودی (قدیمی ترین در بالا، به طور پیش فرض)، 1 = نزولی (جوانترین در بالا). استفاده از QueueID برای کلید و 0 یا 1 برای ارزش.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'انواع بلیط (ascendingly یا descendingly) که یک صف واحد در نمایش خدمات انتخاب و پس از بلیط ها با اولویت طبقه بندی شده اند. ارزش: 0 = صعودی (قدیمی ترین در بالا، به طور پیش فرض)، 1 = نزولی (جوانترین در بالا). استفاده از ServiceID برای کلید و 0 یا 1 برای ارزش.',
        'Spam' => 'هرزنامه ها',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Spam Assassin به عنوان مثال راه اندازی. نادیده ایمیلی که با از SpamAssassin مشخص شده اند.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            ' Spam Assassinبه عنوان مثال راه اندازی. حرکت ایمیل به صف هرزنامه شناخته شد.',
        'Spanish' => 'اسپانیایی',
        'Spanish (Colombia)' => 'اسپانیایی (کلمبیا)',
        'Spanish (Mexico)' => 'اسپانیایی (مکزیک)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            'کلمات توقف اسپانیایی برای شاخص متن. این کلمات از صفحه اول جستجو حذف خواهند شد.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'مشخص میکند که آیا یک عامل باید ایمیل برای اطلاع از اقدامات خود را دریافت خواهید کرد.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            'مشخص نوع توجه داشته باشید موجود برای این ماسک بلیط. اگر این گزینه نخورده باشد، ArticleTypeDefault استفاده می شود و این گزینه از ماسک برداشته.',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            ' پیش فرض نوع مقاله برای صفحه نوشتن بلیط در رابط عامل در صورتی که نوع مقاله می تواند به طور خودکار تشخیص داده نمی شود.',
        'Specifies the different article types that will be used in the system.' =>
            ' انواع مقاله های مختلف که در سیستم استفاده خواهد شد را مشخص میکند .',
        'Specifies the different note types that will be used in the system.' =>
            'انواع مختلف نکته ها که در سیستم استفاده می شود را مشخص میکند.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'مشخص پوشه برای ذخیره داده ها در، اگر \ "FS " برای TicketStorageModule انتخاب شد.',
        'Specifies the directory where SSL certificates are stored.' => 'دایرکتوری که در آن گواهینامه های SSL ذخیره می شود را مشخص میکند.',
        'Specifies the directory where private SSL certificates are stored.' =>
            ' دایرکتوری که در آن گواهینامه های SSL خصوصی ذخیره شده است را مشخص میکند.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            'آدرس ایمیل که باید توسط نرم افزار در هنگام ارسال اطلاعیه استفاده می شود مشخص می کند. آدرس ایمیل استفاده می شود برای ساخت نام صفحه نمایش کامل برای کارشناسی ارشد اطلاع رسانی (یعنی \ "OTRS اطلاعیه " otrs@your.example.com). شما می توانید متغیر OTRS_CONFIG_FQDN به عنوان مجموعه ای در configuation خود استفاده کنید، یا آدرس ایمیل دیگر را انتخاب کنید.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            ' آدرس ایمیل برای دریافت پیام های اطلاع رسانی از وظایف زمانبندی را مشخص میکند.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'گروه که در آن کاربر به مجوز نیاز دارد RW به طوری که او می تواند \ "SwitchToCustomer " از ویژگی های دسترسی مشخص می کند.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            'نامی است که باید توسط نرم افزار در هنگام ارسال اطلاعیه استفاده می شود مشخص می کند. نام فرستنده استفاده می شود برای ساخت نام صفحه نمایش کامل برای کارشناسی ارشد اطلاع رسانی (یعنی \ "OTRS اطلاعیه " otrs@your.example.com).',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            ' نظمی که در آن نام و نام خانوادگی از عوامل نمایش داده خواهد شد را مشخص میکند.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '(| JPG | PNG، 700 × 100 پیکسل GIF) مسیر فایل  را برای آرم در هدر صفحه مشخص می کند.',
        'Specifies the path of the file for the performance log.' => 'مسیر فایل را برای ورود به سیستم عملکرد مشخص می کند.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'مسیر را به مبدل است که اجازه می دهد تا از نظر فایل های مایکروسافت اکسل، در رابط وب مشخص می کند.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'مسیر را به مبدل است که اجازه می دهد تا از نظر فایل های مایکروسافت ورد، در رابط وب مشخص می کند.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'مسیر را به مبدل است که اجازه می دهد تا از نظر اسناد PDF، در رابط وب مشخص می کند.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'مسیر را به مبدل است که اجازه می دهد تا از نظر فایل های XML، در رابط وب مشخص می کند.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'متنی که باید در پرونده ثبت نظر برسد به معنی ورود اسکریپت CGI مشخص .',
        'Specifies user id of the postmaster data base.' => ' شناسه کاربر از پایگاه داده رئيس پست را مشخص میکند.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            'مشخص میکند که آیا تمام پایانه (Backend) ذخیره سازی باید چک شود که دنبال فایل پیوست کنید. این فقط برای نصب و راه اندازی که در آن برخی از فایل پیوست در فایل سیستم، و دیگران در پایگاه داده مورد نیاز است.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'مشخص کنید که چگونه بسیاری از سطوح زیر دایرکتوری استفاده در هنگام ایجاد فایل های کش. این باید بیش از حد بسیاری از فایل های کش جلوگیری از بودن در یک دایرکتوری.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'مشخص کانال مورد استفاده قرار گیرد به بهانه روز رسانی OTRS کسب و کار راه حل ™. هشدار: نسخه توسعه ممکن است کامل، سیستم شما ممکن است اشتباهات غیر قابل بازیابی را تجربه کرده و در موارد شدید می تواند پاسخ نمیدهد!',
        'Specify the password to authenticate for the first mirror database.' =>
            'رمز عبور مشخص برای احراز هویت برای پایگاه داده آینه است.',
        'Specify the username to authenticate for the first mirror database.' =>
            'نام مشخص کاربری برای تأیید هویت برای پایگاه داده آینه است.',
        'Spell checker.' => 'بررسی کننده غلط املایی.',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'مجوز دسترس استاندارد برای عوامل داخل نرم افزار. اگر مجوزهای بیشتری مورد نیاز است، می توان آنها را در اینجا وارد شده است. مجوز باید تعریف شود، موثر باشد. برخی از مجوز خوب دیگر نیز ارائه ساخته شده در: توجه داشته باشید، نزدیک، در انتظار، مشتری، گه از FREETEXT، حرکت، آهنگسازی، مسئول، به جلو، و گزاف گویی. مطمئن شوید که \ "RW " همیشه آخرین اجازه ثبت شده است.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'شروع تعداد آمار شمارش. هر آمار جدید واحد افزایش این عدد است.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'جستجوی کلمات از جسم فعال پس از ماسک لینک شی آغاز شده است.',
        'Stat#' => 'شماره گزارش',
        'Status view' => 'نمای وضعیت',
        'Stores cookies after the browser has been closed.' => 'فروشگاه کوکی ها پس از مرورگر بسته شده است.',
        'Strips empty lines on the ticket preview in the queue view.' => 'نوار خطوط خالی بر روی پیش نمایش درخواست در نظر صف.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'نوار خطوط خالی بر روی پیش نمایش درخواست در نظر خدمات.',
        'Swahili' => 'سواحیلی',
        'Swedish' => 'سوئد',
        'System Address Display Name' => 'سیستم آدرس نام ها',
        'System Maintenance' => 'تعمیر و نگهداری سیستم',
        'System Request (%s).' => 'سیستم درخواست پاسخ به ( %s ).',
        'Target' => 'جهت بازشدن',
        'Templates <-> Queues' => 'قالب <-> صف',
        'Textarea' => 'ناحیه متنی',
        'Thai' => 'تایلندی',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'InternalName پوست عامل است که باید در رابط عامل استفاده شود. لطفا پوسته های موجود در ظاهر :: :: عامل پوسته را تیک بزنید.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'InternalName پوست مشتری است که باید در رابط مشتری استفاده می شود. لطفا پوسته های موجود در ظاهر :: مشتریان :: پوسته را تیک بزنید.',
        'The daemon registration for the scheduler cron task manager.' =>
            'ثبت نام شبح برای مدیریت زمانبندی کار cron  است.',
        'The daemon registration for the scheduler future task manager.' =>
            'ثبت نام شبح برای زمانبندی مدیر وظیفه آینده است.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            'ثبت نام شبح برای زمانبندی عمومی عامل مدیر وظیفه.',
        'The daemon registration for the scheduler task worker.' => 'ثبت نام شبح برای کارگر وظیفه زمانبند.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'تقسیم کننده بین TicketHook و تعداد درخواست به عنوان مثال \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'مدت زمان در دقیقه پس از رهبری یک رویداد، که در آن تشدید جدید مطلع و شروع به حوادث سرکوب می شوند.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'قالب این موضوع است. یعنی «چپ» [TicketHook #: 12،345] برخی از موضوع، به معنای "حق" \'برخی از تم [TicketHook #: 12،345]\'، \'هیچ\' به معنی \'برخی از تم و هیچ تعداد بلیط. در مورد دوم شما باید بررسی کنید که رئيس پست تنظیم :: CheckFollowUpModule ### 0200-منابع فعال است به رسمیت شناختن پیگیری بر اساس هدر ایمیل.',
        'The headline shown in the customer interface.' => 'تیتر نشان داده شده در رابط مشتری.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'شناسه یک بلیط برای، به عنوان مثال بلیط #، تماس #، MyTicket #. به طور پیش فرض بلیط # است.',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'آرم نشان داده شده در هدر از رابط عامل برای پوست \ "به طور پیش فرض ". \ "AgentLogo " برای توضیحات بیشتر را مشاهده کنید.',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            'آرم نشان داده شده در هدر از رابط عامل برای پوست \ "عاج ". \ "AgentLogo " برای توضیحات بیشتر را مشاهده کنید.',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            'آرم نشان داده شده در هدر از رابط عامل برای پوست \ "عاج باریک ". \ "AgentLogo " برای توضیحات بیشتر را مشاهده کنید.',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            'آرم نشان داده شده در هدر از رابط عامل برای پوست \ "باریک ". \ "AgentLogo " برای توضیحات بیشتر را مشاهده کنید.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'آرم نشان داده شده است در هدر رابط عامل. URL به تصویر می تواند یک آدرس نسبی به دایرکتوری تصویر پوست، و یا یک URL کامل به یک وب سرور از راه دور.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'آرم نشان داده شده است در هدر رابط مشتری. URL به تصویر می تواند یک آدرس نسبی به دایرکتوری تصویر پوست، و یا یک URL کامل به یک وب سرور از راه دور.',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'آرم در بالای جعبه ورود به سیستم رابط عامل نشان داده شده است. URL به تصویر باید آدرس نسبی به دایرکتوری تصویر پوست باشد.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'حداکثر تعداد مقالات در یک صفحه در AgentTicketZoom گسترش یافته است.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'حداکثر تعداد مقالات در یک صفحه در AgentTicketZoomنشان داده شده است.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            'حداکثر تعداد ایمیل در یک بار قبل از اتصال مجدد به سرور دریافت.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'متن در آغاز از این موضوع در یک پاسخ ایمیل، به عنوان مثال RE، AW، و یا به عنوان.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'متن در آغاز موضوع هنگامی که یک ایمیل فرستاده است، به عنوان مثال FW، FWD، یا WG.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            'این رویداد های ماژول ویژگی هایی از CustomerUser به عنوان بلیط DynamicFields. لطفا تنظیمات بالا برای نحوه پیکربندی نقشه برداری.',
        'This is the default orange - black skin for the customer interface.' =>
            'پوست سیاه و سفید برای رابط مشتری - این به طور پیش فرض نارنجی است.',
        'This is the default orange - black skin.' => 'پوست سیاه و سفید - این به طور پیش فرض نارنجی است.',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'این ماژول و عملکرد PreRun () آن اجرا خواهد شد، اگر تعریف شده است، برای هر درخواست. این ماژول مفید است که برای بررسی برخی از گزینه های کاربران و یا برای نمایش اخبار در مورد برنامه های جدید.',
        'This module is part of the admin area of OTRS.' => 'این ماژول بخشی از بخش مدیریت OTRS موجود است.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'این گزینه زمینه پویا که در آن یک مدیریت فرآیند نهاد فعالیت شناسه ذخیره شده است تعریف می کند.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'این گزینه زمینه پویا که در آن یک مدیریت فرآیند نهاد شناسه فرایند ذخیره شده است تعریف می کند.',
        'This option defines the process tickets default lock.' => 'این گزینه به طور پیش فرض درخواست روند قفل تعریف می کند.',
        'This option defines the process tickets default priority.' => 'این گزینه به طور پیش فرض درخواست اولویت فرایند تعریف می کند.',
        'This option defines the process tickets default queue.' => 'این گزینه به طور پیش فرض درخواست روند صف تعریف می کند.',
        'This option defines the process tickets default state.' => 'این گزینه به طور پیش فرض درخواست روند دولت تعریف می کند.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'این گزینه دسترسی به بلیط شرکت مشتری، که توسط کاربران مشتری ایجاد نمی انکار کند.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'این تنظیم امکان را به نادیده گرفتن ساخته شده است در لیست کشور با لیست خود را از کشور است. این امر به ویژه مفید است اگر شما فقط می خواهید به استفاده از یک گروه را انتخاب کنید کوچکی از کشورها.',
        'This will allow the system to send text messages via SMS.' => 'این اجازه خواهد داد به سیستم برای ارسال پیام های متنی از طریق SMS.',
        'Ticket Close.' => 'درخواست نزدیک ',
        'Ticket Compose Bounce Email.' => 'درخواست نوشتن پرش ایمیل.',
        'Ticket Compose email Answer.' => 'درخواست نوشتن برای پاسخ ایمیل.',
        'Ticket Customer.' => 'درخواست مشتری.',
        'Ticket Forward Email.' => 'درخواست انتقال ایمیل.',
        'Ticket FreeText.' => 'گه از FREETEXT درخواست',
        'Ticket History.' => 'تاریخ درخواست.',
        'Ticket Lock.' => 'قفل درخواست',
        'Ticket Merge.' => 'ادغام درخواست',
        'Ticket Move.' => 'درخواست حرکت ',
        'Ticket Note.' => 'توجه درخواست',
        'Ticket Notifications' => 'درخواست اطلاعیه',
        'Ticket Outbound Email.' => 'درخواست عازم ناحیه دور دست ایمیل.',
        'Ticket Owner.' => 'مالک درخواست',
        'Ticket Pending.' => ' انتظاردرخواست.',
        'Ticket Print.' => ' چاپ درخواست .',
        'Ticket Priority.' => 'اولویت درخواست',
        'Ticket Queue Overview' => 'بررسی اجمالی صف درخواست',
        'Ticket Responsible.' => 'درخواست به عهده دارد.',
        'Ticket Watcher' => 'نگهبان درخواست',
        'Ticket Zoom.' => 'درخواست زوم.',
        'Ticket bulk module.' => 'درخواست ماژول انبوه ',
        'Ticket event module that triggers the escalation stop events.' =>
            'درخواست ماژول رویداد که باعث حوادث تشدید توقف.',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'درخواست به صف \ "نقل مکان کرد %s " ( %s ) از صف \ " %s " ( %s ).',
        'Ticket notifications' => 'اطلاع رسانی تیکت',
        'Ticket overview' => 'نمای کلی درخواست',
        'Ticket plain view of an email.' => 'درخواست نظر ساده از یک ایمیل.',
        'Ticket title' => 'عنوان درخواست',
        'Ticket zoom view.' => 'نمایش زوم درخواست',
        'TicketNumber' => 'شماره درخواست',
        'Tickets.' => 'درخواست',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'زمان در ثانیه است که می شود به زمان واقعی اضافه شده است اگر تنظیم یک انتظار دولت (به طور پیش فرض: 86،400 = 1 روز).',
        'Title updated: Old: "%s", New: "%s"' => 'عنوان به روز رسانی: قدیمی: \ " %s "، جدید: \ " %s "',
        'To accept login information, such as an EULA or license.' => 'برای قبول اطلاعات ورود به سیستم، مانند EULA یا مجوز.',
        'To download attachments.' => 'برای دانلود فایل پیوست کنید.',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'نمایش پستی از لیست FeatureAddons OTRS در سامانه مدیریت بسته.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'مورد نوار ابزار برای یک میانبر. کنترل دسترسی اضافی برای نشان دادن یا این لینک نشان می دهد را نمی توان با استفاده از کلید \ "گروه " و محتوا مانند \ ":؛: GROUP2 \ move_into GROUP1 RW" انجام می شود.',
        'Transport selection for ticket notifications.' => 'انتخاب حمل و نقل اطلاعیه درخواست',
        'Tree view' => 'نمای درختی',
        'Triggers ticket escalation events and notification events for escalation.' =>
            'باعث حوادث تشدید بلیط و رویدادهای هشدار برای تشدید.',
        'Turkish' => 'ترکی',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'خاموش می شود اعتبار گواهی SSL، برای مثال اگر شما استفاده از یک پروکسی HTTPS شفاف است. با پذیرش خطر عواقب آن استفاده کنید!',
        'Turns on drag and drop for the main navigation.' => 'روشن کشیدن و رها کردن برای ناوبری اصلی.',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'نوبت در انیمیشن ها مورد استفاده در رابط کاربری گرافیکی. اگر شما مشکلات با این انیمیشن ها (به عنوان مثال مسائل مربوط به عملکرد)، شما می توانید آنها را در اینجا تبدیل شود.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'تبدیل بر روی چک آدرس IP از راه دور. این باید به مجموعه \ "بدون " اگر برنامه استفاده می شود، به عنوان مثال، از طریق یک مزرعه پروکسی و یا یک اتصال مودم، چون آدرس IP از راه دور بیشتر برای درخواست های مختلف است.',
        'Ukrainian' => 'اوکراینی',
        'Unlock tickets that are past their unlock timeout.' => 'باز کردن درخواست که گذشته ای برای باز کردن خود هستند.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'باز کردن بلیط هر زمان که یک توجه داشته باشید اضافه شده است و مالک از دفتر.',
        'Unlocked ticket.' => 'سابقه::تحویل دادن درخواست',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'به روز رسانی بلیط \ "دیده می شود " پرچم اگر هر مقاله دیده شد و یا یک مقاله جدید ایجاد کردم.',
        'Updated SLA to %s (ID=%s).' => ' SLA بروز شده به  %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => ' خدمات بروز شده به %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'نوع بروز شده به %s (ID=%s).',
        'Updated: %s' => 'به روز رسانی: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'به روز رسانی: %s = %s ؛ %s = %s ؛ %s = %s .',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'به روز رسانی صفحه اول تشدید بلیط پس از یک ویژگی بلیط به روز کردم.',
        'Updates the ticket index accelerator.' => 'به روز رسانی شتاب دهنده شاخص درخواست',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            'استفاده از نوع جدیدی از زمینه را انتخاب کنید و تکمیل خودکار در رابط عامل، که در آن قابل اجرا (InputFields).',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            'استفاده از نوع جدیدی از زمینه را انتخاب کنید و تکمیل خودکار در رابط مشتری، در آن قابل اجرا (InputFields).',
        'UserFirstname' => 'UserFirstname',
        'UserLastname' => 'UserLastname',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'استفاده از گیرندگان رونوشت در پاسخ لیست CC در نوشتن پاسخ ایمیل در صفحه نوشتن درخواست رابط عامل.',
        'Uses richtext for viewing and editing ticket notification.' => 'استفاده از richtext برای اطلاع رسانی مشاهده و ویرایش درخواست',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'استفاده از richtext برای مشاهده و ویرایش: مقالات، درود، امضا، قالب استاندارد، پاسخ خودکار و اطلاعیه ها.',
        'Vietnam' => 'ویتنام',
        'View performance benchmark results.' => 'نمایش نتایج آزمون کارایی',
        'Watch this ticket' => 'سازمان دیده بان این درخواست',
        'Watched Tickets.' => 'درخواست تماشا.',
        'We are performing scheduled maintenance.' => 'ما در حال انجام تعمیر و نگهداری برنامه ریزی شده هستیم .',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'ما در حال انجام تعمیر و نگهداری برنامه ریزی شده هستیم. ورود به طور موقت در دسترس نیست.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'ما در حال انجام تعمیر و نگهداری برنامه ریزی شده هستیم.ما باید بزودی به حالت آن لاین برگردیم.',
        'Web View' => 'مشاهده وب سایت',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'هنگامی که بلیط ادغام شدهاند، توجه داشته باشید به طور خودکار بلیط است که دیگر فعال به اضافه شده است. در اینجا شما می توانید بدن از این توجه داشته باشید (این متن را می توسط عامل نمی توان تغییر داد) را تعریف کنیم.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'هنگامی که بلیط ادغام شدهاند، توجه داشته باشید به طور خودکار بلیط است که دیگر فعال به اضافه شده است. در اینجا شما می توانید موضوع این توجه داشته باشید (این موضوع می تواند توسط عامل نمی توان تغییر داد) را تعریف کنیم.',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'هنگامی که بلیط هم ادغام شدند، مشتری می تواند در هر ایمیل با تنظیم چک باکس \ "اطلاع فرستنده " آگاه است. در این متن، شما می توانید یک متن از قبل فرمت شده که بعدا توسط عوامل اصلاح شود را تعریف کنیم.',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'یا نه به جمع آوری اطلاعات متا از مقالات با استفاده از فیلتر تنظیم شده در بلیط :: ظاهر :: ZoomCollectMetaFilters.',
        'Yes, but hide archived tickets' => 'بله، اما آرشیو درخواست پنهان است',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'ایمیل خود را با تعداد درخواست  \ "<OTRS_TICKET> " منعکس است با \ "<OTRS_BOUNCE_TO> ". این آدرس برای کسب اطلاعات بیشتر تماس بگیرید.',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'انتخاب صف خود را از صف نظر خود را. شما همچنین دریافت در مورد کسانی که صف از طریق ایمیل مطلع اگر فعال باشد.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'انتخاب خدمات خود را از خدمات مورد نظر خود را. شما همچنین دریافت در مورد کسانی که خدمات از طریق ایمیل مطلع اگر فعال باشد.',
        'attachment' => 'ضمیمه',
        'bounce' => '',
        'compose' => '',
        'debug' => 'اشکال زدایی',
        'error' => 'خطا',
        'forward' => '',
        'info' => 'اطلاعات',
        'inline' => 'درون خطی',
        'notice' => 'نکته',
        'pending' => '',
        'responsible' => '',
        'stats' => '',

    };
    # $$STOP$$
    return;
}

1;
