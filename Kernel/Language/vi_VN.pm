# --
# Kernel/Language/vi_VN.pm - provides vi_VN language translation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: vi_VN.pm,v 1.1.2.4 2008-05-28 08:03:42 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
package Kernel::Language::vi_VN;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1.2.4 $) [1];

sub Data {
    my ( $Self, %Param ) = @_;

    # $$START$$
    # Last translation file sync: Tue May 29 15:05:19 2007

    # possible charsets
    $Self->{Charset} = [ 'viscii' ];

    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes'                 => 'Có',
        'No'                  => 'Không',
        'yes'                 => 'Có',
        'no'                  => 'Không',
        'Off'                 => 'T¡t',
        'off'                 => 't¡t',
        'On'                  => 'M·',
        'on'                  => 'm·',
        'top'                 => 'trên ð¥u',
        'end'                 => 'cu¯i',
        'Done'                => 'Ðã xong',
        'Cancel'              => 'Hüy',
        'Reset'               => 'Làm lÕi',
        'last'                => 'Sau',
        'before'              => 'Trß¾c',
        'day'                 => 'ngày',
        'days'                => 'ngày',
        'day(s)'              => 'ngày',
        'hour'                => 'gi¶',
        'hours'               => 'gi¶',
        'hour(s)'             => 'gi¶',
        'minute'              => 'phút',
        'minutes'             => 'phút',
        'minute(s)'           => 'phút',
        'month'               => 'tháng',
        'months'              => 'tháng',
        'month(s)'            => 'tháng',
        'week'                => 'tu¥n',
        'week(s)'             => 'tu¥n',
        'year'                => 'nåm',
        'years'               => 'nåm',
        'year(s)'             => 'nåm',
        'second(s)'           => 'giây',
        'seconds'             => 'giây',
        'second'              => 'giây',
        'wrote'               => 'viªt',
        'Message'             => 'Thông báo',
        'Error'               => 'L²i',
        'Bug Report'          => 'Báo cáo l²i',
        'Attention'           => 'Chú ý',
        'Warning'             => 'Cänh báo',
        'Module'              => 'Mô ðun',
        'Modulefile'          => 'File mô ðun',
        'Subfunction'         => 'ChÑc nång con',
        'Line'                => 'Dòng',
        'Example'             => 'Ví dø',
        'Examples'            => 'Các ví dø',
        'valid'               => 'Hþp l®',
        'invalid'             => 'Không hþp l®',
        '* invalid'           => '* không hþp l®',
        'invalid-temporarily' => 'tÕm th¶i không hþp l®',
        ' 2 minutes'          => '2 phút',
        ' 5 minutes'          => '5 phút',
        ' 7 minutes'          => '7 phút',
        '10 minutes'          => '10 phút',
        '15 minutes'          => '15 phút',
        'Mr.'                 => 'Ông',
        'Mrs.'                => 'Bà',
        'Next'                => 'Tiªp',
        'Back'                => 'Tr· lÕi',
        'Next...'             => 'Tiªp...',
        '...Back'             => '...Tr· lÕi',
        '-none-'              => 'không',
        'none'                => 'không',
        'none!'               => 'không!',
        'none - answered'     => 'không ðßþc trä l¶i',
        'please do not edit!' => 'Xin ð×ng chïnh sØa!',
        'AddLink'             => 'Thêm liên kªt',
        'Link'                => 'Liên kªt',
        'Linked'              => 'Ðã liên kªt',
        'Link (Normal)'       => 'Liên kªt (Thß¶ng)',
        'Link (Parent)'       => 'Liên kªt (Cha)',
        'Link (Child)'        => 'Liên kªt (Con)',
        'Normal'              => 'Thß¶ng',
        'Parent'              => 'Cha',
        'Child'               => 'Con',
        'Hit'                 => 'Nh¤n chuµt',
        'Hits'                => 'Nh¤n chuµt',
        'Text'                => 'Vån bän',
        'Lite'                => 'Nh©',
        'User'                => 'Ngß¶i dùng',
        'Username'            => 'Tên ðång nh§p',
        'Language'            => 'Ngôn ngæ',
        'Languages'           => 'Các ngôn ngæ',
        'Password'            => 'M§t kh¦u',
        'Salutation'          => 'L¶i chào',
        'Signature'           => 'Chæ ký',
        'Customer'            => 'Khách hàng',
        'CustomerID'          => 'Mã khách hàng',
        'CustomerIDs'         => 'Mã khách hàng',
        'customer'            => 'khách hàng',
        'agent'               => 'nhân viên',
        'system'              => 'h® th¯ng',
        'Customer Info'       => 'Thông tin khách hàng',
        'Customer Company'    => 'Công ty khách hàng',
        'Company'             => 'Công ty',
        'go!'                 => 'tiªp tøc!',
        'go'                  => 'tiªp tøc',
        'All'                 => 't¤t cä',
        'all'                 => 't¤t cä',
        'Sorry'               => 'Xin l²i',
        'update!'             => 'c§p nh§t!',
        'update'              => 'c§p nh§t',
        'Update'              => 'C§p nh§t',
        'submit!'             => 'xác nh§n!',
        'submit'              => 'xác nh§n',
        'Submit'              => 'Xác nh§n',
        'change!'             => 'thay ð±i!',
        'Change'              => 'Thay ð±i',
        'change'              => 'thay ð±i',
        'click here'          => 'Nh¤n chuµt vào ðây',
        'Comment'             => 'Nh§n xét',
        'Valid'               => 'Hþp l®',
        'Invalid Option!'     => 'Lña ch÷n không hþp l®!',
        'Invalid time!'       => 'Th¶i gian không hþp l®!',
        'Invalid date!'       => 'Ngày tháng không hþp l®!',
        'Name'                => 'Tên',
        'Group'               => 'Nhóm',
        'Description'         => 'Mô tä',
        'description'         => 'mô tä',
        'Theme'               => 'Giao di®n',
        'Created'             => 'Ðã kh·i tÕo',
        'Created by'          => 'Kh·i tÕo b·i',
        'Changed'             => 'Ðã thay ð±i',
        'Changed by'          => 'Thay ð±i b·i',
        'Search'              => 'Tìm kiªm',
        'and'                 => 'và',
        'between'             => 'giæa',
        'Fulltext Search'     => 'Tìm kiªm toàn bµ vån bän',
        'Data'                => 'Dæ li®u',
        'Options'             => 'Các tùy ch÷n',
        'Title'               => 'Tiêu ð«',
        'Item'                => 'Møc',
        'Delete'              => 'Xóa',
        'Edit'                => 'SØa',
        'View'                => 'Xem',
        'Number'              => 'S¯',
        'System'              => 'H® th¯ng',
        'Contact'             => 'Liên h®',
        'Contacts'            => 'Liên h®',
        'Export'              => 'Xu¤t',
        'Up'                  => 'Trên',
        'Down'                => 'Dß¾i',
        'Add'                 => 'Thêm',
        'Category'            => 'Phân loÕi',
        'Viewer'              => 'Trình xem',
        'New message'         => 'Tin nh¡n m¾i',
        'New message!'        => 'Tin nh¡n m¾i!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Hãy trä l¶i thë này ð¬ tr· lÕi ph¥n xem các hàng ðþi thông thß¶ng!',
        'You got new message!'            => 'BÕn có tin nh¡n m¾i!',
        'You have %s new message(s)!'     => 'BÕn có %s tin nh¡n m¾i!',
        'You have %s reminder ticket(s)!' => 'BÕn có %s thë nh¡c công vi®c!',
        'The recommended charset for your language is %s!' =>
            'Bµ ký tñ gþi ý cho ngôn ngæ cüa bÕn là %s!',
        'Passwords doesn\'t match! Please try it again!' =>
            'Các m§t kh¦u không kh¾p nhau! Hãy thØ lÕi!',
        'Password is already in use! Please use an other password!' =>
            'M§t kh¦u ðã t×ng ðßþc sØ døng! Hãy sØ døng mµt m§t kh¦u khác!',
        'Password is already used! Please use an other password!' =>
            'M§t kh¦u ðã t×ng ðßþc sØ døng! Hãy sØ døng mµt m§t kh¦u khác!',
        'You need to activate %s first to use it!' =>
            '%s c¥n ðßþc kích hoÕt l¥n ð¥u tiên ð¬ sØ døng!',
        'No suggestions' => 'Không có gþi ý nào',
        'Word'           => 'T×',
        'Ignore'         => 'Bö qua',
        'replace with'   => 'thay thª b¢ng',
        'There is no account with that login name.' =>
            'Không có tài khoän nào v¾i tên truy c§p nhß thª.',
        'Login failed! Your username or password was entered incorrectly.' =>
            'Ðång nh§p th¤t bÕi! Tên truy c§p ho£c m§t kh¦u nh§p không chính xác.',
        'Please contact your admin' => 'Hãy liên h® v¾i quän tr¸ h® th¯ng cüa bÕn',
        'Logout successful. Thank you for using OTRS!' =>
            'Ðång xu¤t thành công! Cäm ½n bÕn ðã sØ døng OTRS!',
        'Invalid SessionID!'  => 'Mã phiên không hþp l®!',
        'Feature not active!' => 'Tính nång không hoÕt ðµng!',
        'Login is needed!'    => 'C¥n ðång nh§p!',
        'Password is needed!' => 'C¥n m§t kh¦u!',
        'License'             => 'Gi¤y phép',
        'Take this Customer'  => 'Ch¤p nh§n khách hàng này',
        'Take this User'      => 'Ch¤p nh§n ngß¶i dùng này',
        'possible'            => 'có th¬',
        'reject'              => 't× ch¯i',
        'reverse'             => 'ðäo ngßþc',
        'Facility'            => 'Ti®n ích',
        'Timeover'            => 'Hªt th¶i gian',
        'Pending till'        => 'Treo t¾i khi',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'Không làm vi®c v¾i mã ngß¶i dùng 1 (tài khoän h® th¯ng)! Hãy tÕo ngß¶i dùng m¾i!',
        'Dispatching by email To: field.' => 'GØi b¢ng email t¾i: trß¶ng.',
        'Dispatching by selected Queue.'  => 'GØi b·i hàng ðþi ðã ch÷n.',
        'No entry found!'                 => 'Không tìm th¤y møc nào!',
        'Session has timed out. Please log in again.' =>
            'Phiên ðã b¸ gián ðoÕn. Xin hãy ðång nh§p lÕi.',
        'No Permission!'                         => 'Không có quy«n!',
        'To: (%s) replaced with database email!' => 'T¾i: (%s) ðßþc thay thª b·i email c½ s· dæ li®u!',
        'Cc: (%s) added database email!'         => 'Cc: (%s) email c½ s· dæ li®u thêm!',
        '(Click here to add)'                    => '(Nh¤n chuµt vào ðây ð¬ thêm)',
        'Preview'                                => 'Xem trß¾c',
        'Package not correctly deployed! You should reinstall the Package again!' =>
            'Gói chßa ðßþc tri¬n khai chính xác! BÕn nên cài ð£t lÕi gói l¥n næa!',
        'Added User "%s"'     => 'Ngß¶i dùng "%s" ðã ðßþc thêm.',
        'Contract'            => 'Hþp ð°ng',
        'Online Customer: %s' => 'Khách hàng trñc tuyªn: %s',
        'Online Agent: %s'    => 'Nhân viên ðang online: %s',
        'Calendar'            => 'L¸ch',
        'File'                => 'File',
        'Filename'            => 'Tên file',
        'Type'                => 'LoÕi',
        'Size'                => 'CÞ',
        'Upload'              => 'Täi lên',
        'Directory'           => 'Ðß¶ng dçn',
        'Signed'              => 'Ðã ký',
        'Sign'                => 'Ký',
        'Crypted'             => 'Ðã g¡n mã',
        'Crypt'               => 'G¡n mã',
        'Office'              => 'Vån phòng',
        'Phone'               => 'Ði®n thoÕi',
        'Fax'                 => 'Fax',
        'Mobile'              => 'Di ðµng',
        'Zip'                 => 'Mã vùng',
        'City'                => 'Thành ph¯',
        'Country'             => 'Nß¾c',
        'installed'           => 'ðã cài ð£t',
        'uninstalled'         => 'ðã gÞ cài ð£t',
        'Security Note: You should activate %s because application is already running!' =>
            'Lßu ý bäo m§t: BÕn nên kích hoÕt %s b·i Ñng døng ðã hoÕt ðµng!',
        'Unable to parse Online Repository index document!' =>
            'Không th¬ phân tách tài li®u chï møc Kho chÑa trñc tuyªn!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!'
            => 'Không có gói nào cho c¤u trúc yêu c¥u trong Kho chÑa trñc tuyªn này, nhßng có các gói cho nhæng c¤u trúc khác.',
        'No Packages or no new Packages in selected Online Repository!' =>
            'Không có gói nào ho£c không có gói m¾i nào trong Kho chÑa trñc tuyªn ðã ch÷n!',
        'printed at' => 'ðßþc in tÕi',

        # Template: AAAMonth
        'Jan'       => 'Tháng 1',
        'Feb'       => 'Tháng 2',
        'Mar'       => 'Tháng 3',
        'Apr'       => 'Tháng 4',
        'May'       => 'Tháng 5',
        'Jun'       => 'Tháng 6',
        'Jul'       => 'Tháng 7',
        'Aug'       => 'Tháng 8',
        'Sep'       => 'Tháng 9',
        'Oct'       => 'Tháng 10',
        'Nov'       => 'Tháng 11',
        'Dec'       => 'Tháng 12',
        'January'   => 'Tháng Mµt',
        'February'  => 'Tháng Hai',
        'March'     => 'Tháng Ba',
        'April'     => 'Tháng Tß',
        'June'      => 'Tháng Sáu',
        'July'      => 'Tháng Bäy',
        'August'    => 'Tháng Tám',
        'September' => 'Tháng Chín',
        'October'   => 'Tháng Mß¶i',
        'November'  => 'Tháng Mß¶i mµt',
        'December'  => 'Tháng Mß¶i hai',

        # Template: AAANavBar
        'Admin-Area'                  => 'Khu vñc dành cho quän tr¸',
        'Agent-Area'                  => 'Khu vñc dành cho nhân viên',
        'Ticket-Area'                 => 'Khu vñc thë',
        'Logout'                      => 'Ðång xu¤t',
        'Agent Preferences'           => 'Giao di®n cho nhân viên phø trách',
        'Preferences'                 => 'Giao di®n',
        'Agent Mailbox'               => 'Hµp thß dành cho nhân viên',
        'Stats'                       => 'Th¯ng kê',
        'Stats-Area'                  => 'Khu vñc dành cho th¯ng kê',
        'Admin'                       => 'Quän tr¸',
        'Customer Users'              => 'Ngß¶i dùng khách hàng',
        'Customer Users <-> Groups'   => 'Ngß¶i dùng khách hàng <-> Nhóm',
        'Customer Users <-> Services' => 'Ngß¶i dùng khách hàng <-> D¸ch vø',
        'Users <-> Groups'            => 'Ngß¶i dùng <-> Nhóm',
        'Roles'                       => 'Vai trò',
        'Roles <-> Users'             => 'Vai trò <-> Ngß¶i dùng',
        'Roles <-> Groups'            => 'Vai trò <-> Nhóm',
        'Salutations'                 => 'L¶i chào',
        'Signatures'                  => 'Chæ ký',
        'Email Addresses'             => 'Ð¸a chï email',
        'Notifications'               => 'Thông báo',
        'Category Tree'               => 'Cây thß møc',
        'Admin Notification'          => 'Thông báo quän tr¸',

        # Template: AAAPreferences
        'Preferences updated successfully!'   => 'Giao di®n ðã ðßþc c§p nh§t thành công!',
        'Mail Management'                     => 'Quän tr¸ mail',
        'Frontend'                            => 'M£t ngoài',
        'Other Options'                       => 'Các tùy ch÷n khác',
        'Change Password'                     => 'Ð±i m§t kh¦u',
        'New password'                        => 'M§t kh¦u m¾i',
        'New password again'                  => 'Gõ lÕi m§t kh¦u m¾i',
        'Select your QueueView refresh time.' => 'Hãy ch÷n th¶i gian làm m¾i hàng ðþi cüa bÕn.',
        'Select your frontend language.'      => 'Hãy ch÷n ngôn ngæ m£t ngoài cüa bÕn.',
        'Select your frontend Charset.'       => 'Hãy ch÷n bµ mã ký tñ m£t ngoài cüa bÕn.',
        'Select your frontend Theme.'         => 'Hãy ch÷n giao di®n m£t ngoài cüa bÕn.',
        'Select your frontend QueueView.'     => 'Hãy ch÷n cách xem hàng ðþi m£t ngoài cüa bÕn.',
        'Spelling Dictionary'                 => 'T× ði¬n chính tä',
        'Select your default spelling dictionary.' => 'Hãy ch÷n t× ði¬n chính tä m£c ð¸nh cüa bÕn.',
        'Max. shown Tickets a page in Overview.' =>
            'S¯ thë hi¬n th¸ t¯i ða trên mµt trang trong ph¥n T±ng quan.',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' =>
            'Không th¬ c§p nh§t m§t kh¦u, các m§t kh¦u không kh¾p nhau! Hãy thØ lÕi l¥n næa!',
        'Can\'t update password, invalid characters!' =>
            'Không th¬ c§p nh§t m§t kh¦u, các ký tñ không hþp l®.',
        'Can\'t update password, need min. 8 characters!' =>
            'Không th¬ c§p nh§t m§t kh¦u, m§t kh¦u phäi ít nh¤t 8 ký tñ.',
        'Can\'t update password, need 2 lower and 2 upper characters!' =>
            'Không th¬ c§p nh§t m§t kh¦u, c¥n có 2 ký tñ dß¾i và 2 ký tñ trên.',
        'Can\'t update password, need min. 1 digit!' =>
            'Không th¬ c§p nh§t m§t kh¦u, m§t kh¦u c¥n có ít nh¤t 1 con s¯!',
        'Can\'t update password, need min. 2 characters!' =>
            'Không th¬ c§p nh§t m§t kh¦u, m§t kh¦u c¥n có ít nh¤t 2 ký tñ!',

        # Template: AAAStats
        'Stat'                                 => 'Th¯ng kê',
        'Please fill out the required fields!' => 'Hãy nh§p vào các trß¶ng b¡t buµc!',
        'Please select a file!'                => 'Hãy ch÷n 1 file!',
        'Please select an object!'             => 'Hãy ch÷n 1 ð¯i tßþng!',
        'Please select a graph size!'          => 'Hãy ch÷n 1 cÞ bi¬u ð°!',
        'Please select one element for the X-axis!' =>
            'Hãy ch÷n 1 thành t¯ cho trøc X!',
        'You have to select two or more attributes from the select field!' =>
            'BÕn phäi ch÷n 2 hay nhi«u thuµc tính t× trß¶ng ðã ch÷n!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!'
            => 'Hãy ch÷n duy nh¤t 1 thành t¯ ho£c t¡t nút \'Ðã sØa\'n½i trß¶ng ðã ch÷n ðßþc ðánh d¤u!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Nªu bÕn sØ døng mµt hµp ch÷n bÕn phäi ch÷n mµt s¯ thuµc tính cüa trß¶ng ðã ch÷n!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Hãy chèn mµt giá tr¸ trong trß¶ng nh§p ðã ch÷n ho£c t¡t hµp ch÷n \'Ðã sØa\'!',
        'The selected end time is before the start time!' =>
            'Th¶i gian kªt thúc ðã ch÷n trß¾c th¶i gian b¡t ð¥u!',
        'You have to select one or more attributes from the select field!' =>
            'BÕn phäi ch÷n 1 ho£c nhi«u thuµc tính t× trß¶ng ðã ch÷n!',
        'The selected Date isn\'t valid!' => 'Ngày ðã ch÷n không hþp l®!',
        'Please select only one or two elements via the checkbox!' =>
            'Hãy ch÷n chï 1 ho£c 2 thành t¯ thông qua hµp ch÷n!',
        'If you use a time scale element you can only select one element!' =>
            'Nªu bÕn sØ døng thành t¯ khung th¶i gian bÕn có th¬ chï ch÷n 1 thành t¯!',
        'You have an error in your time selection!' =>
            'Có 1 l²i trong quá trình ch÷n th¶i gian cüa bÕn!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Khoäng th¶i gian báo cáo quá nhö, hãy sØ døng khung th¶i gian l¾n h½n!',
        'The selected start time is before the allowed start time!' =>
            'Th¶i gian b¡t ð¥u ðã ch÷n trß¾c th¶i gian b¡t ð¥u cho phép!',
        'The selected end time is after the allowed end time!' =>
            'Th¶i gian kªt thúc ðã ch÷n sau th¶i gian kªt thúc cho phép!',
        'The selected time period is larger than the allowed time period!' =>
            'Khoäng th¶i gian ðã ch÷n l¾n h½n khoäng th¶i gian cho phép!',
        'Common Specification'   => 'Ð£c tä chung',
        'Xaxis'                  => 'Trøc X',
        'Value Series'           => 'Chu²i giá tr¸',
        'Restrictions'           => 'Các hÕn chª',
        'graph-lines'            => 'Bi¬u ð° ðß¶ng kë',
        'graph-bars'             => 'Bi¬u ð° thanh',
        'graph-hbars'            => 'Bi¬u ð° thanh ngang',
        'graph-points'           => 'Bi¬u ð° ch¤m',
        'graph-lines-points'     => 'Bi¬u ð° ðß¶ng kë ch¤m',
        'graph-area'             => 'Bi¬u ð° vùng',
        'graph-pie'              => 'Bi¬u ð° tròn',
        'extended'               => 'm· rµng',
        'Agent/Owner'            => 'Nhân viên/Phø trách',
        'Created by Agent/Owner' => 'Ðßþc tÕo b·i nhân viên/ngß¶i phø trách',
        'Created Priority'       => '¿u tiên kh·i tÕo',
        'Created State'          => 'TrÕng thái kh·i tÕo',
        'Create Time'            => 'Th¶i gian kh·i tÕo',
        'CustomerUserLogin'      => 'Ngß¶i dùng khách hàng ðång nh§p',
        'Close Time'             => 'Th¶igian ðóng',
        'CSV'                    => 'CSV',

        # Template: AAATicket
        'Lock'               => 'Khóa',
        'Unlock'             => 'M· khóa',
        'History'            => 'L¸ch sØ',
        'Zoom'               => 'Phóng ðÕi',
        'Age'                => 'Tu±i',
        'Bounce'             => 'Bö',
        'Forward'            => 'Chuy¬n tiªp',
        'From'               => 'T×',
        'To'                 => 'T¾i',
        'Cc'                 => 'Cc',
        'Bcc'                => 'Bcc',
        'Subject'            => 'Tiêu ð«',
        'Move'               => 'Chuy¬n',
        'Queue'              => 'Hàng ðþi',
        'Priority'           => '¿u tiên',
        'State'              => 'TrÕng thái',
        'Compose'            => 'TÕo',
        'Pending'            => 'Ðang treo',
        'Owner'              => 'Phø trách',
        'Owner Update'       => 'C§p nh§t phø trách',
        'Responsible'        => 'Ch¸u trách nhi®m',
        'Responsible Update' => 'C§p nh§t trách nhi®m',
        'Sender'             => 'Ngß¶i gØi',
        'Article'            => 'Bài viªt',
        'Ticket'             => 'Thë',
        'Createtime'         => 'Th¶i gian kh·i tÕo',
        'plain'              => 'g¯c',
        'Email'              => 'E-Mail',
        'email'              => 'E-Mail',
        'Close'              => 'Ðóng',
        'Action'             => 'Hành ðµng',
        'Attachment'         => 'Ðính kèm',
        'Attachments'        => 'Ðính kèm',
        'This message was written in a character set other than your own.' =>
            'Tin nh¡n này ðã ðßþc viªt b¢ng bµ ký tñ khác v¾i cüa bÕn.',
        'If it is not displayed correctly,' => 'Nªu nó không hi¬n th¸ chính xác,',
        'This is a'                         => 'Ðây là mµt',
        'to open it in a new window.' => 'm· trong cØa s± m¾i',
        'This is a HTML email. Click here to show it.' =>
            'Ðây là mµt email HTML. Nh¤n chuµt vào ðây ð¬ xem.',
        'Free Fields'          => 'Các trß¶ng tñ do',
        'Merge'                => 'Trµn',
        'merged'               => 'ðã trµn',
        'closed successful'    => 'ðóng thành công',
        'closed unsuccessful'  => 'ðóng không thành công',
        'new'                  => 'm¾i',
        'open'                 => 'm·',
        'closed'               => 'ðóng',
        'removed'              => 'gÞ bö',
        'pending reminder'     => 'ðang treo nh¡c nh·',
        'pending auto'         => 'ðang treo tñ ðµng',
        'pending auto close+'  => 'ðang treo tñ ðµng ðóng+',
        'pending auto close-'  => 'ðang treo tñ ðµng ðóng-',
        'email-external'       => 'E-mail bên ngoài',
        'email-internal'       => 'E-mail nµi bµ',
        'note-external'        => 'lßu ý bên ngoài',
        'note-internal'        => 'lßu ý nµi bµ',
        'note-report'          => 'lßu ý báo cáo',
        'phone'                => 'ði®n thoÕi',
        'sms'                  => 'tin nh¡n sms',
        'webrequest'           => 'yêu c¥u web',
        'lock'                 => 'khóa',
        'unlock'               => 'không khóa',
        'very low'             => 'r¤t ch§m',
        'low'                  => 'ch§m',
        'normal'               => 'bình thß¶ng',
        'high'                 => 'cao',
        'very high'            => 'r¤t cao',
        '1 very low'           => '1 r¤t ch§m',
        '2 low'                => '2 ch§m',
        '3 normal'             => '3 bình thß¶ng',
        '4 high'               => '4 cao',
        '5 very high'          => '5 r¤t cao',
        'Ticket "%s" created!' => 'Thë "%s" ðã ðßþc tÕo!',
        'Ticket Number'        => 'S¯ thë',
        'Ticket Object'        => 'Ð¯i tßþng thë',
        'No such Ticket Number "%s"! Can\'t link it!' =>
            'Không có thë nào có s¯ "%s" nhß v§y! Không th¬ liên kªt t¾i ðó!',
        'Don\'t show closed Tickets'         => 'Không hi¬n th¸ các thë ðã ðóng',
        'Show closed Tickets'                => 'Hi¬n th¸ các thë ðã ðóng',
        'New Article'                        => 'Bài viªt m¾i',
        'Email-Ticket'                       => 'Thë e-mail',
        'Create new Email Ticket'            => 'TÕo thë e-mail m¾i',
        'Phone-Ticket'                       => 'Thë Cuµc g÷i',
        'Search Tickets'                     => 'Tìm kiªm thë',
        'Edit Customer Users'                => 'SØa ngß¶i dùng khách hàng',
        'Bulk-Action'                        => 'L®nh lô',
        'Bulk Actions on Tickets'            => 'L®nh lô trên các thë',
        'Send Email and create a new Ticket' => 'GØi e-mail và tÕo 1 thë m¾i',
        'Create new Email Ticket and send this out (Outbound)' =>
            'TÕo 1 thë e-mail m¾i và gØi ra ngoài',
        'Create new Phone Ticket (Inbound)' => 'TÕo thë cuµc g÷i m¾i (vào trong)',
        'Overview of all open Tickets'      => 'T±ng quan t¤t cä các thë m·',
        'Locked Tickets'                    => 'Các thë ðã khóa',
        'Watched Tickets'                   => 'Các thë ðã xem',
        'Watched'                           => 'Ðã xem',
        'Subscribe'                         => 'Xác nh§n',
        'Unsubscribe'                       => 'Không xác nh§n',
        'Lock it to work on it!'            => 'Khóa ð¬ làm vi®c trên ðó!',
        'Unlock to give it back to the queue!'  => 'M· khóa ð¬ ðßa trä v« hàng ðþi!',
        'Shows the ticket history!'             => 'Xem l¸ch sØ thë!',
        'Print this ticket!'                    => 'In thë này!',
        'Change the ticket priority!'           => 'Thay ð±i ßu tiên thë',
        'Change the ticket free fields!'        => 'Thay ð±i các trß¶ng tñ do cüa thë',
        'Link this ticket to an other objects!' => 'Liên kªt thë này v¾i các ð¯i tßþng khác!',
        'Change the ticket owner!'              => 'Thay ð±i phø trách thë!',
        'Change the ticket customer!'           => 'Thay ð±i khách hàng thë!',
        'Add a note to this ticket!'            => 'Thêm lßu ý ð¯i v¾i thë này!',
        'Merge this ticket!'                    => 'Trµn thë này!',
        'Set this ticket to pending!'           => 'Thiªt ð£t treo thë này!',
        'Close this ticket!'                    => 'Ðóng thë này!',
        'Look into a ticket!'                   => 'Xem xét mµt thë!',
        'Delete this ticket!'                   => 'Xóa thë này!',
        'Mark as Spam!'                         => 'Ðánh d¤u là thß rác!',
        'My Queues'                             => 'Hàng ðþi cüa tôi',
        'Shown Tickets'                         => 'Các thë ðßþc hi¬n th¸',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'E-mail cüa bÕn v¾i s¯ thë "<OTRS_TICKET>" ðßþc trµn thành "<OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' =>
            'Thë %s: l¥n phän h°i ð¥u tiên quá (%s)!',
        'Ticket %s: first response time will be over in %s!' =>
            'Thë %s: l¥n phän h°i ð¥u tiên s¨ quá %s!',
        'Ticket %s: update time is over (%s)!' =>
            'Thë %s: l¥n c§p nh§t quá (%s)!',
        'Ticket %s: update time will be over in %s!' =>
            'Thë %s: l¥n c§p nh§t s¨ quá %s!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: L?sungszeit ist abgelaufen (%s)!',
        'Ticket %s: solution time will be over in %s!' =>
            'Thë %s: l¥n giäi pháp s¨ quá %s!',
        'There are more escalated tickets!' => 'Có nhi«u thë h½n!',
        'New ticket notification'           => 'Thông báo thë m¾i',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'GØi thông báo cho tôi nªu có thë m¾i trong "Hàng ðþi cüa tôi".',
        'Follow up notification' => 'Thông báo theo dõi',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'
            => 'GØi thông báo cho tôi nªu có khách hàng gØi theo dõi và tôi là phø trách cüa thë này.',
        'Ticket lock timeout notification' => 'Thông báo th¶i gian ch¶ khóa thë',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'GØi thông báo cho tôi nªu mµt thë chßa ðßþc khóa b·i h® th¯ng.',
        'Move notification' => 'Thông báo chuy¬n',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'GØi thông báo cho tôi nªu mµt thë ðßþc chuy¬n vào trong "Hàng ðþi cüa tôi".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.'
            => 'Lña ch÷n hàng ðþi trong s¯ các hàng ðþi ßa thích cüa bÕn. BÕn cûng s¨ nh§n ðßþc thông báo v« chúng thông qua email nªu chÑc nång ðßþc kích hoÕt',
        'QueueView refresh time'  => 'Th¶i gian làm m¾i Hàng ðþi',
        'Screen after new ticket' => 'Màn hình sau khi tÕo thë m¾i',
        'Select your screen after creating a new ticket.' =>
            'Hãy lña ch÷n màn hình sau khi tÕo mµt thë m¾i.',
        'Closed Tickets'       => 'Các thë ðã ðóng',
        'Show closed tickets.' => 'Hi¬n th¸ các thë ðã ðóng.',
        'Max. shown Tickets a page in QueueView.' =>
            'Các thë hi¬n th¸ t¯i ða trên m²i trang trong Hàng ðþi.',
        'CompanyTickets'            => 'Thë công ty',
        'MyTickets'                 => 'Thë cüa tôi',
        'New Ticket'                => 'Thë m¾i',
        'Create new Ticket'         => 'TÕo thë m¾i',
        'Customer called'           => 'Khách hàng ðßþc g÷i',
        'phone call'                => 'cuµc g÷i',
        'Responses'                 => 'Các trä l¶i',
        'Responses <-> Queue'       => 'Các trä l¶i <-> Hàng ðþi',
        'Auto Responses'            => 'Các trä l¶i tñ ðµng',
        'Auto Responses <-> Queue'  => 'Các trä l¶i tñ ðµng <-> Hàng ðþi',
        'Attachments <-> Responses' => 'Các ðính kèm <-> Các trä l¶i',
        'History::Move'             => 'L¸ch sØ::Chuy¬n.',
        'History::TypeUpdate'       => 'L¸ch sØ::C§p nh§t loÕi.',
        'History::ServiceUpdate'    => 'L¸ch sØ::C§p nh§t d¸ch vø.',
        'History::SLAUpdate'        => 'L¸ch sØ::C§p nh§t SLA "%s" (ID=%s).',
        'History::NewTicket'        => 'L¸ch sØ::Thë m¾i [%s] (Q=%s;P=%s;S=%s).',
        'History::FollowUp'         => 'L¸ch sØ::Theo dõi',
        'History::SendAutoReject'   => 'L¸ch sØ::GØi t× ch¯i tñ ðµng.',
        'History::SendAutoReply'    => 'L¸ch sØ::GØi phän h°i tñ ðµng.',
        'History::SendAutoFollowUp' => 'L¸ch sØ::GØi theo dõi tñ ðµng.',
        'History::Forward'          => 'L¸ch sØ::Chuy¬n tiªp.',
        'History::Bounce'           => 'L¸ch sØ::T× bö',
        'History::SendAnswer'       => 'L¸ch sØ::GØi trä l¶i',
        'History::SendAgentNotification'    => 'L¸ch sØ::GØi thông báo cho nhân viên phø trách',
        'History::SendCustomerNotification' => 'L¸ch sØ::GØi thông báo khách hàng',
        'History::EmailAgent'               => 'L¸ch sØ::Email nhân viên',
        'History::EmailCustomer'            => 'L¸ch sØ::Email khách hàng',
        'History::PhoneCallAgent'           => 'L¸ch sØ::Cuµc g÷i nhân viên',
        'History::PhoneCallCustomer'        => 'L¸ch sØ::Cuµc g÷i khách hàng',
        'History::AddNote'                  => 'L¸ch sØ::Thêm lßu ý',
        'History::Lock'                     => 'L¸ch sØ::Khóa',
        'History::Unlock'                   => 'L¸ch sØ::M· khóa',
        'History::TimeAccounting' => 'L¸ch sØ::Giäi thích th¶i gian',
        'History::Remove'         => 'L¸ch sØ::GÞ bö',
        'History::CustomerUpdate' => 'L¸ch sØ::C§p nh§t khách hàng',
        'History::PriorityUpdate' => 'L¸ch sØ::C§p nh§t ßu tiên',
        'History::OwnerUpdate'    => 'L¸ch sØ::C§p nh§t phø trách',
        'History::LoopProtection' => 'L¸ch sØ::Bäo v® vòng l£p',
        'History::Misc'           => 'L¸ch sØ::Khác',
        'History::SetPendingTime' => 'L¸ch sØ::Ð£t th¶i gian treo',
        'History::StateUpdate'    => 'L¸ch sØ::C§p nh§t trÕng thái',
        'History::TicketFreeTextUpdate' => 'L¸ch sØ::C§p nh§t thë',
        'History::WebRequestCustomer'   => 'L¸ch sØ::Khách hàng yêu c¥u web',
        'History::TicketLinkAdd'        => 'L¸ch sØ::Thêm liên kªt thë',
        'History::TicketLinkDelete'     => 'L¸ch sØ::Xóa liên kªt thë',

        # Template: AAAWeekDay
        'Sun' => 'Chü nh§t',
        'Mon' => 'ThÑ hai',
        'Tue' => 'ThÑ ba',
        'Wed' => 'ThÑ tß',
        'Thu' => 'ThÑ nåm',
        'Fri' => 'ThÑ sáu',
        'Sat' => 'ThÑ bäy',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Quän tr¸ ðính kèm',

        # Template: AdminAutoResponseForm
        'Auto Response Management'                      => 'Quän tr¸ phän h°i tñ ðµng',
        'Response'                                      => 'Phän h°i',
        'Auto Response From'                            => 'Phàn h°i tñ ðµng t×',
        'Note'                                          => 'Lßu ý',
        'Useable options'                               => 'Các tùy ch÷n có th¬ sØ døng',
        'To get the first 20 character of the subject.' => 'L¤y 20 ký tñ ð¥u tiên cüa tiêu ð«',
        'To get the first 5 lines of the email.'        => 'L¤y 5 dòng ð¥u tiên cüa email',
        'To get the realname of the sender (if given).' =>
            'L¤y tên thñc cüa ngß¶i gØi (nªu ðã cho)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).'
            => 'L¤y thuµc tính bài viªt (ví dø: (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' =>
            'Các tùy ch÷n cüa dæ li®u ngß¶i dùng khách hàng hi®n tÕi (ví dø: <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' =>
            'Các tùy ch÷n cüa phø trách thë (ví dø: <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' =>
            'Các tùy ch÷n trách nhi®m thë (ví dø:<OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).'
            => 'Các tùy ch÷n cüa ngß¶i dùng khách hàng yêu c¥u hành ðµng này (ví dø: <OTRS_CURRENT_UserFirstname).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).'
            => 'Các tùy ch÷n cüa dæ li®u thë (ví dø: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' =>
            'Tùy ch÷n c¤u hình (ví dø: <OTRS_CONFIG_HttpType).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Quän tr¸ công ty khách hàng',
        'Add Customer Company'        => 'Thêm công ty khách hàng',
        'Add a new Customer Company.' => 'Thêm 1 công ty khách hàng m¾i',
        'List'                        => 'Danh sách',
        'This values are required.'   => 'Giá tr¸ này ðßþc yêu c¥u',
        'This values are read only.'  => 'Giá tr¸ này chï ð÷c',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Quän tr¸ ngß¶i dùng khách hàng',
        'Search for'               => 'Tìm kiªm cho',
        'Add Customer User'        => 'Thêm ngß¶i dùng khách hàng',
        'Source'                   => 'Ngu°n',
        'Create'                   => 'TÕo',
        'Customer user will be needed to have a customer history and to login via customer panel.'
            => 'Ngß¶i dùng khách hàng s¨ c¥n có mµt l¸ch sØ khách hàng và ðång nh§p thông qua bäng ði«u khi¬n khách hàng',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Ngß¶i dùng khách hàng <-> Quän tr¸ nhóm',
        'Change %s settings'                   => 'Thay ð±i %s thiªt ð£t',
        'Select the user:group permissions.'   => 'Lña ch÷n ngß¶i dùng: các quy«n cüa nhóm.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).'
            => 'Nªu không ch÷n cái gì thì s¨ không có quy«n nào trong nhóm này (các thë s¨ không sÇn sàng sØ døng ð¯i v¾i ngß¶i dùng).',
        'Permission' => 'Quy«n',
        'ro'         => 'Chï ð÷c',
        'Read only access to the ticket in this group/queue.' =>
            'Quy«n chï ð÷c truy c§p vào thë trong nhóm/hàng ðþi này.',
        'rw' => 'ð÷c và ghi',
        'Full read and write access to the tickets in this group/queue.' =>
            'Quy«n ð÷c và ghi truy c§p vào thë trong nhóm/hàng ðþi này.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserServiceChangeForm
        'Customer Users <-> Services Management' => 'Ngß¶i dùng khách hàng <-> Quän tr¸ d¸ch vø',
        'Select the customeruser:service relations.' =>
            'Ch÷n m¯i quan h® ngß¶i dùng khách hàng:d¸ch vø.',
        'Allocate services to CustomerUser' => 'Phân ph¯i d¸ch vø t¾i ngß¶i dùng khách hàng',
        'Allocate CustomerUser to service'  => 'Phân ph¯i ngß¶i dùng khách hàng t¾i d¸ch vø',

        # Template: AdminCustomerUserServiceForm
        'Edit default services.' => 'SØa d¸ch vø m£c ð¸nh.',

        # Template: AdminEmail
        'Message sent to' => 'Tin nh¡n ðßþc gØi t¾i',
        'Recipents'       => 'Ngß¶i nh§n',
        'Body'            => 'Nµi dung',
        'Send'            => 'GØi',

        # Template: AdminGenericAgent
        'GenericAgent'  => 'Nhân viên phø trách chung',
        'Job-List'      => 'Danh sách công vi®c',
        'Last run'      => 'L¥n v§n hành trß¾c',
        'Run Now!'      => 'V§n hành ngay!',
        'x'             => 'x',
        'Save Job as?'  => 'Lßu công vi®c?',
        'Is Job Valid?' => 'Công vi®c có hþp l®?',
        'Is Job Valid'  => 'Công vi®c có hþp l®',
        'Schedule'      => 'Kª hoÕch',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' =>
            'Tìm kiªm trong bài viªt (ví dø: "Mar*in" ho£c "Baue*")',
        '(e. g. 10*5155 or 105658*)'          => 'ví dø: 10*5144 ho£c 105658*',
        '(e. g. 234321)'                      => 'ví dø: 234321',
        'Customer User Login'                 => 'Ðång nh§p ngß¶i dùng khách hàng',
        '(e. g. U5150)'                       => 'ví dø: U5150',
        'Agent'                               => 'Nhân viên',
        'Ticket Lock'                         => 'Khóa thë',
        'TicketFreeFields'                    => 'Các trß¶ng không thë',
        'Create Times'                        => 'Các l¥n kh·i tÕo',
        'No create time settings.'            => 'Không có thiªt ð£t l¥n kh·i tÕo',
        'Ticket created'                      => 'Thë ðã tÕo',
        'Ticket created between'              => 'Thë ðã tÕo giæa',
        'Pending Times'                       => 'Các l¥n treo',
        'No pending time settings.'           => 'Không có thiªt ð£t l¥n treo',
        'Ticket pending time reached'         => 'L¥n treo thë ðã ðÕt t¾i',
        'Ticket pending time reached between' => 'L¥n treo thë ðã ðÕt t¾i giæa',
        'New Priority'                        => '¿u tiên m¾i',
        'New Queue'                           => 'Hàng ðþi m¾i',
        'New State'                           => 'TrÕng thái m¾i',
        'New Agent'                           => 'Nhân viên m¾i',
        'New Owner'                           => 'Phø trách m¾i',
        'New Customer'                        => 'Khách hàng m¾i',
        'New Ticket Lock'                     => 'Khóa thë m¾i',
        'CustomerUser'                        => 'Ngß¶i dùng khách hàng',
        'New TicketFreeFields'                => 'Các trß¶ng không thë m¾i',
        'Add Note'                            => 'Thêm lßu ý',
        'CMD'                                 => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'L®nh này s¨ ðßþc chÕy. ARG[0] s¨ là s¯ thë. ARG[1] là mã thë.',
        'Delete tickets' => 'Xóa thë',
        'Warning! This tickets will be removed from the database! This tickets are lost!' =>
            'Lßu ý! Các thë này s¨ b¸ gÞ bö khöi c½ s· dæ li®u! Các thë này s¨ b¸ m¤t!',
        'Send Notification'     => 'GØi thông báo',
        'Param 1'               => 'Tham s¯ 1',
        'Param 2'               => 'Tham s¯ 2',
        'Param 3'               => 'Tham s¯ 3',
        'Param 4'               => 'Tham s¯ 4',
        'Param 5'               => 'Tham s¯ 5',
        'Param 6'               => 'Tham s¯ 6',
        'Send no notifications' => 'Không gØi thông báo nào',
        'Yes means, send no agent and customer notifications on changes.' =>
            'Có, nghîa là, không gØi thông báo cho nhân viên và khách hàng nào v« các thay ð±i.',
        'No means, send agent and customer notifications on changes.' =>
            'Không, nghîa là, gØi thông báo cho nhân viên và khách hàng v« các thay ð±i.',
        'Save' => 'Lßu',
        '%s Tickets affected! Do you really want to use this job?' =>
            '%s thë b¸ änh hß·ng! BÕn có thñc sñ mu¯n dùng công vi®c này?',

        # Template: AdminGroupForm
        'Group Management' => 'Quän tr¸ nhóm',
        'Add Group'        => 'Thêm nhóm',
        'Add a new Group.' => 'Thêm 1 nhóm m¾i.',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Nhóm quän tr¸ l¤y trong khu vñc quän tr¸ và nhóm th¯ng kê l¤y trong khu vñc th¯ng kê.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'
            => 'TÕo các nhóm m¾i ð¬ ði«u khi¬n quy«n truy c§p cho các nhóm nhân viên khác nhau (ví dø: bµ ph§n mua hàng, bµ ph§n h² trþ, bµ ph§n kinh doanh,...).',
        'It\'s useful for ASP solutions.' => 'Nó hæu ích cho giäi pháp ASP.',

        # Template: AdminLog
        'System Log' => 'Bän ghi h® th¯ng',
        'Time'       => 'Th¶i giab',

        # Template: AdminNavigationBar
        'Users'  => 'Ngß¶i dùng',
        'Groups' => 'Nhóm',
        'Misc'   => 'Khác',

        # Template: AdminNotificationForm
        'Notification Management' => 'Quän tr¸ thông báo',
        'Notification'            => 'Thông báo',
        'Notifications are sent to an agent or a customer.' =>
            'Các thông báo ðã ðßþc gØi t¾i 1 nhân viên ho£c khách hàng.',

        # Template: AdminPackageManager
        'Package Manager' => 'Quän tr¸ gói',
        'Uninstall'       => 'GÞ cài ð£t',
        'Version'         => 'Phiên bän',
        'Do you really want to uninstall this package?' =>
            'BÕn có thñc sñ mu¯n gÞ cài ð£t gói này?',
        'Reinstall' => 'Cài lÕi',
        'Do you really want to reinstall this package (all manual changes get lost)?' =>
            'BÕn có thñc sñ mu¯n cài lÕi ð£t gói này (t¤t cä nhæng thay ð±i b¸ m¤t)?',
        'Continue'                    => 'Tiªp tøc',
        'Install'                     => 'Cài ð£t',
        'Package'                     => 'Gói',
        'Online Repository'           => 'Kho trñc tuyªn',
        'Vendor'                      => 'Ngß¶i bán',
        'Upgrade'                     => 'Nâng c¤p',
        'Local Repository'            => 'Kho cøc bµ',
        'Status'                      => 'TrÕng thái',
        'Overview'                    => 'T±ng quan',
        'Download'                    => 'Täi xu¯ng',
        'Rebuild'                     => 'Dñng lÕi',
        'ChangeLog'                   => 'Bän ghi thay ð±i',
        'Date'                        => 'Dæ li®u',
        'Filelist'                    => 'Danh sách file',
        'Download file from package!' => 'Täi file t× gói xu¯ng!',
        'Required'                    => 'Ðßþc yêu c¥u',
        'PrimaryKey'                  => 'Khóa chính',
        'AutoIncrement'               => 'Gia tång tñ ðµng',
        'SQL'                         => 'SQL',
        'Diff'                        => 'Khác nhau',

        # Template: AdminPerformanceLog
        'Performance Log'          => 'Bän ghi thñc thi',
        'This feature is enabled!' => 'Tính nång này ðã ðßþc kích hoÕt!',
        'Just use this feature if you want to log each request.' =>
            'Chï sØ døng tính nång này nªu bÕn mu¯n ghi m²i yêu c¥u.',
        'Of couse this feature will take some system performance it self!' =>
            'T¤t nhiên tính nång này s¨ tñ thñc thi h® th¯ng.',
        'Disable it here!'          => 'Vô hi®u hóa tÕi ðây!',
        'This feature is disabled!' => 'Tính nång này ðã b¸ vô hi®u hóa!',
        'Enable it here!'           => 'Kích hoÕt tÕi ðây!',
        'Logfile too large!'        => 'File bän ghi quá l¾n!',
        'Logfile too large, you need to reset it!' =>
            'File bän ghi quá l¾n, bÕn c¥n thiªt ð£t lÕi!',
        'Range'            => 'Däi',
        'Interface'        => 'Giao di®n',
        'Requests'         => 'Yêu c¥u',
        'Min Response'     => 'Phän h°i t¯i thi¬u',
        'Max Response'     => 'Phän h°i t¯i ða',
        'Average Response' => 'Phän h°i trung bình',

        # Template: AdminPGPForm
        'PGP Management' => 'Quän tr¸ PGP',
        'Result'         => 'Kªt quä',
        'Identifier'     => 'T× ð¸nh danh',
        'Bit'            => 'Bit',
        'Key'            => 'Khóa',
        'Fingerprint'    => 'D¤u tay',
        'Expires'        => 'Hªt hÕn',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Theo cách này bÕn có th¬ sØa trñc tiªp c¤u hình khóa trong C¤u hình h® th¯ng.',

        # Template: AdminPOP3
        'POP3 Account Management' => 'Quän tr¸ tài khoän POP3',
        'Host'                    => 'Máy chü host',
        'Trusted'                 => 'Tin c§y',
        'Dispatching'             => 'Ðang gØi',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'T¤t cä các email ðªn v¾i 1 tài khoän s¨ ðßþc gØi vào trong hàng ðþi ðã ch÷n!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.'
            => 'Nªu tài khoän cüa bÕn là ðáng tin c§y, ð¥u trang X-OTRS ðã có tÕi th¶i gian ðªn (cho mÑc ðµ ßu tiên, ...) s¨ ðßþc sØ døng! Bµ l÷c PostMaster cûng s¨ ðßþc dùng.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Quän tr¸ bµ l÷c PostMaster',
        'Filtername'                   => 'L÷c tên',
        'Match'                        => 'Kªt hþp',
        'Header'                       => 'Ð¥u trang',
        'Value'                        => 'Giá tr¸',
        'Set'                          => 'Thiªt ð£t',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.'
            => 'GØi ho£c l÷c các email ðªn dña trên X-Headers email! RegExp cûng có th¬.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.'
            => 'Nªu bÕn mu¯n kªt hþp các ð¸a chï email, hãy dùng EMAILADDRESS:info@example.com trong trß¶ng T×, Ðªn ho£c Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' =>
            'Nªu bÕn dùng RegExp, bÕn cûng có th¬ sØ døng giá tr¸ kªt hþp trong () thành [***] trong \'Thiªt ð£t\'.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Hàng ðþi <-> Quän tr¸ phän h°i tñ ðµng',

        # Template: AdminQueueForm
        'Queue Management'                 => 'Quän tr¸ hàng ðþi',
        'Sub-Queue of'                     => 'Hàng ðþi con cüa',
        'Unlock timeout'                   => 'Th¶i gian ch¶ m· khóa',
        '0 = no unlock'                    => '0 = không m· khóa',
        'Escalation - First Response Time' => 'Tiªp tøc - Th¶i gian phän h°i ð¥u tiên',
        '0 = no escalation'                => '0 = không tiªp tøc',
        'Escalation - Update Time'         => 'Tiªp tøc - Th¶i gian c§p nh§t',
        'Escalation - Solution Time'       => 'Tiªp tøc - Th¶i gian giäi pháp',
        'Follow up Option'                 => 'Theo dõi tùy ch÷n',
        'Ticket lock after a follow up'    => 'Khóa thë sau khi theo dõi',
        'Systemaddress'                    => 'Ð¸a chï h® th¯ng',
        'Customer Move Notify'             => 'Thông báo chuy¬n khách hàng',
        'Customer State Notify'            => 'Thông báo trÕng thái khách hàng',
        'Customer Owner Notify'            => 'Thông báo phø trách khách hàng',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.'
            => 'Nªu 1 nhân viên khóa thë và h÷ không gØi trä l¶i trong th¶i gian này, thë s¨ ðßþc tñ ðµng m· khóa. Do v§y t¤t cä các nhân viên khác ð«u có th¬ nhìn th¤y thë ðó.',
        'Escalation time' => 'Th¶i gian tiªp tøc',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' =>
            'Nªu mµt thë không ðßþc trä l¶i trong th¶i gian này, chï duy nh¤t thë này s¨ ðßþc hi¬n th¸.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.'
            => 'Nªu mµt thë ðßþc ðóng và khách hàng gØi theo dõi, thë s¨ b¸ khóa cho ngß¶i phø trách cû.',
        'Will be the sender address of this queue for email answers.' =>
            'S¨ là ð¸a chï ngß¶i gØi cüa hàng ðþi này cho các email trä l¶i.',
        'The salutation for email answers.' => 'L¶i chào cho các email trä l¶i.',
        'The signature for email answers.'  => 'Chæ ký cho các email trä l¶i.',
        'OTRS sends an notification email to the customer if the ticket is moved.' =>
            'OTRS gØi mµt email thông báo t¾i khách hàng nªu thë ðßþc chuy¬n.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' =>
            'OTRS gØi mµt email thông báo t¾i khách hàng nªu trÕng thái thë thay ð±i.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' =>
            'OTRS gØi mµt email thông báo t¾i khách hàng nªu phø trách thë thay ð±i.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Phän h°i <-> Quän tr¸ hàng ðþi',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Trä l¶i',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Phän h°i <-> Quän tr¸ ðính kèm',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Quän tr¸ phän h°i',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Mµt phän h°i là mµt vån bän m£c ð¸nh ðßþc viªt câu trä l¶i nhanh gØi cho khách hàng.',
        'Don\'t forget to add a new response a queue!' =>
            'Ð×ng quên thêm phän h°i m¾i vào hàng ðþi!',
        'The current ticket state is' => 'TrÕng thái thë hi®n tÕi là',
        'Your email address is new'   => 'Ð¸a chï email cüa bÕn là m¾i',

        # Template: AdminRoleForm
        'Role Management' => 'Quän tr¸ vai trò',
        'Add Role'        => 'Thêm vai trò',
        'Add a new Role.' => 'Thêm vai trò m¾i.',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'TÕo 1 vai trò và ð£t các nhóm vào ðó. R°i thêm vai trò cho ngß¶i dùng.',
        'It\'s useful for a lot of users and groups.' =>
            'Nó hæu ích ð¯i v¾i nhi«u ngß¶i dùng và nhóm.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Vai trò <-> Quän tr¸ nhóm',
        'move_into'                   => 'chuy¬n t¾i',
        'Permissions to move tickets into this group/queue.' =>
            'Các quy«n ð¬ chuy¬n thë vào trong nhóm/hàng ðþi này.',
        'create' => 'tÕo',
        'Permissions to create tickets in this group/queue.' =>
            'Các quy«n ð¬ tÕo thë trong nhóm/hàng ðþi này.',
        'owner' => 'phø trách',
        'Permissions to change the ticket owner in this group/queue.' =>
            'Các quy«n ð¬ thay ð±i phø trách thë trong nhóm/hàng ðþi này.',
        'priority' => '¿u tiên',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Các quy«n ð¬ thay ð±i ßu tiên thë trong nhóm/hàng ðþi này.',

        # Template: AdminRoleGroupForm
        'Role' => 'Vai trò',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management'      => 'Vai trò <-> Quän tr¸ ngß¶i dùng',
        'Active'                          => 'HoÕt ðµng',
        'Select the role:user relations.' => 'Ch÷n m¯i quan h® vai trò:ngß¶i dùng.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Quän tr¸ l¶i chào',
        'Add Salutation'        => 'Thêm l¶i chào',
        'Add a new Salutation.' => 'Thêm l¶i chào m¾i.',

        # Template: AdminSelectBoxForm
        'Select Box'        => 'Ch÷n ô',
        'Limit'             => 'Gi¾i hÕn',
        'Go'                => 'T¾i',
        'Select Box Result' => 'Ch÷n ô kªt quä',

        # Template: AdminService
        'Service Management' => 'Quän tr¸ d¸ch vø',
        'Add Service'        => 'Thêm d¸ch vø',
        'Add a new Service.' => 'Thêm d¸ch vø m¾i.',
        'Service'            => 'D¸ch vø',
        'Sub-Service of'     => 'D¸ch vø con cüa',

        # Template: AdminSession
        'Session Management' => 'Quän tr¸ phiên',
        'Sessions'           => 'Các phiên',
        'Uniq'               => 'Duy nh¤t',
        'Kill all sessions'  => 'Xóa t¤t cä các phiên',
        'Session'            => 'Phiên',
        'Content'            => 'Nµi dung',
        'kill session'       => 'xóa phiên',

        # Template: AdminSignatureForm
        'Signature Management' => 'Quän tr¸ chæ ký',
        'Add Signature'        => 'Thêm chæ ký',
        'Add a new Signature.' => 'Thêm chæ ký m¾i.',

        # Template: AdminSLA
        'SLA Management'      => 'Quän tr¸ SLA',
        'Add SLA'             => 'Thêm SLA',
        'Add a new SLA.'      => 'Thêm SLA m¾i.',
        'SLA'                 => 'SLA',
        'First Response Time' => 'L¥n phän h°i ð¥u tiên',
        'Update Time'         => 'Th¶i gian c§p nh§t',
        'Solution Time'       => 'Th¶i gian giäi pháp',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Quän tr¸ S/MIME',
        'Add Certificate'   => 'Thêm chÑng chï',
        'Add Private Key'   => 'Thêm khóa cá nhân',
        'Secret'            => 'Bí m§t',
        'Hash'              => 'Båm',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Theo cách này bÕn có th¬ sØa chÑng chï và khóa cá nhân trñc tiªp trong h® th¯ng file.',

        # Template: AdminStateForm
        'State Management' => 'Quän tr¸ trÕng thái',
        'Add State'        => 'Thêm trÕng thái',
        'Add a new State.' => 'Thêm trÕng thái m¾i.',
        'State Type'       => 'LoÕi trÕng thái',
        'Take care that you also updated the default states in you Kernel/Config.pm!' =>
            'Hãy lßu ý r¢ng bÕn ðã c§p nh§t các trÕng thái m£c ð¸nh trong Kernel/Config.pm!',
        'See also' => 'Xem',

        # Template: AdminSysConfig
        'SysConfig'         => 'C¤u hình h® th¯ng',
        'Group selection'   => 'Lña ch÷n nhóm',
        'Show'              => 'Hi¬n th¸',
        'Download Settings' => 'Các thiªt ð£t täi xu¯ng',
        'Download all system config changes.' =>
            'Täi xu¯ng các thay ð±i c¤u hình h® th¯ng.',
        'Load Settings' => 'Các thiªt ð£t täi',
        'Subgroup'      => 'Nhóm con',
        'Elements'      => 'Các thành t¯',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Các tùy ch÷n c¤u hình',
        'Default'        => 'M£c ð¸nh',
        'New'            => 'M¾i',
        'New Group'      => 'Nhóm m¾i',
        'Group Ro'       => 'Nhóm chï ð÷c',
        'New Group Ro'   => 'Nhóm chï ð÷c m¾i',
        'NavBarName'     => 'Tên thanh ði«u hß¾ng',
        'NavBar'         => 'Thanh ði«u hß¾ng',
        'Image'          => 'Änh',
        'Prio'           => '¿u tiên',
        'Block'          => 'Kh¯i',
        'AccessKey'      => 'Phím truy c§p',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Quän tr¸ ð¸a chï email h® th¯ng',
        'Add System Address'                => 'Thêm ð¸a chï h® th¯ng',
        'Add a new System Address.'         => 'Thêm ð¸a chï h® th¯ng m¾i.',
        'Realname'                          => 'Tên thñc',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' =>
            'T¤t cä các email ðªn v¾i có t× "Email" (T¾i:) s¨ ðßþc gØi vào trong hàng ðþi ðã ch÷n.',

        # Template: AdminTypeForm
        'Type Management' => 'Quän tr¸ loÕi',
        'Add Type'        => 'Thêm loÕi',
        'Add a new Type.' => 'Thêm loÕi m¾i.',

        # Template: AdminUserForm
        'User Management'  => 'Quän tr¸ ngß¶i dùng',
        'Add User'         => 'Thêm ngß¶i dùng',
        'Add a new Agent.' => 'Thêm mµt nhân viên m¾i.',
        'Login as'         => 'Ðång nh§p v¾i',
        'Firstname'        => 'H÷',
        'Lastname'         => 'Tên',
        'User will be needed to handle tickets.' =>
            'Ngß¶i dùng s¨ c¥n ði«u khi¬n thë.',
        'Don\'t forget to add a new user to groups and/or roles!' =>
            'Ð×ng quên thêm mµt ngß¶i dùng m¾i vào nhóm và/ho£c vai trò!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Ngß¶i dùng <-> Quän tr¸ nhóm',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book'                 => 'S± ð¸a chï',
        'Return to the compose screen' => 'Tr· lÕi màn hình soÕn',
        'Discard all changes and return to the compose screen' =>
            'T× bö m÷i thay ð±i và tr· lÕi màn hình soÕn',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Thông tin',

        # Template: AgentLinkObject
        'Link Object' => 'Ð¯i tßþng liên kªt',
        'Select'      => 'Ch÷n',
        'Results'     => 'Kªt quä',
        'Total hits'  => 'T±ng s¯ lßþt b¤m',
        'Page'        => 'Trang',
        'Detail'      => 'Chi tiªt',

        # Template: AgentLookup
        'Lookup' => 'Tra',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker'       => 'Ki¬m tra chính tä',
        'spelling error(s)'   => 'L²i chính tä',
        'or'                  => 'ho£c',
        'Apply these changes' => 'Áp døng nhæng thay ð±i này',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'BÕn có thñc sñ mu¯n xóa ð¯i tßþng này không?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' =>
            'Lña ch÷n các gi¾i hÕn ð£c trßng cho th¯ng kê',
        'Fixed' => 'Ðã sØa',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Hãy ch÷n chï 1 thành t¯ ho£c t¡t nút \'Ðã sØa\'!',
        'Absolut Period'  => 'Chu kÏ tuy®t ð¯i',
        'Between'         => 'Giæa',
        'Relative Period' => 'Chu kÏ liên quan',
        'The last'        => 'Cu¯i cùng',
        'Finish'          => 'Kªt thúc',
        'Here you can make restrictions to your stat.' =>
            'BÕn có th¬ tÕo các gi¾i hÕn cho th¯ng kê tÕi ðây.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.'
            => 'Nªu bÕn bö ðánh d¤u trong ô "Ðã sØa", nhân viên phø trách sinh th¯ng kê có th¬ thay ð±i các thuµc tính cüa thành t¯ liên quan.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Chèn c¤u hình chung',
        'Permissions'                         => 'Các quy«n',
        'Format'                              => 'Ð¸nh dÕng',
        'Graphsize'                           => 'CÞ bi¬u ð°',
        'Sum rows'                            => 'T±ng s¯ hàng',
        'Sum columns'                         => 'T±ng s¯ cµt',
        'Cache'                               => 'Lßu træ',
        'Required Field'                      => 'Trß¶ng b¡t buµc',
        'Selection needed'                    => 'Lña ch÷n c¥n',
        'Explanation'                         => 'Giäi thích',
        'In this form you can select the basic specifications.' =>
            'Trong mçu này bÕn có th¬ ch÷n các ð£c tä c½ bän.',
        'Attribute'          => 'Thuµc tính',
        'Title of the stat.' => 'Tiêu ð« th¯ng kê.',
        'Here you can insert a description of the stat.' =>
            'BÕn có th¬ chèn mô tä th¯ng kê tÕi ðây.',
        'Dynamic-Object' => 'Ð¯i tßþng ðµng',
        'Here you can select the dynamic object you want to use.' =>
            'BÕn có th¬ ch÷n ð¯i tßþng ðµng mu¯n sØ døng tÕi ðây.',
        '(Note: It depends on your installation how many dynamic objects you can use)' =>
            '(Lßu ý: Nó phø thuµc vào cài ð£t cüa bÕn có bao nhiêu ð¯i tßþng ðµng bÕn mu¯n dùng)',
        'Static-File' => 'File tînh',
        'For very complex stats it is possible to include a hardcoded file.' =>
            'Ð¯i v¾i các th¯ng kê phÑc tÕp có th¬ bao g°m cä file ðã mã hóa.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.'
            => 'Nªu mµt file ðã mã hóa sÇn sàng sØ døng, thuµc tính này s¨ ðßþc hi¬n th¸ và bÕn có th¬ ch÷n nó.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.'
            => 'Các thiªt ð£t quy«n. BÕn có th¬ lña ch÷n 1 ho£c nhi«u nhóm ð¬ tÕo th¯ng kê ðã ðßþc c¤u hình mà các nhân viên khác nhau ð«u có th¬ nhìn th¤y.',
        'Multiple selection of the output format.' => 'Nhi«u lña ch÷n cüa ð¸nh dÕng ð¥u ra.',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Nªu bÕn dùng mµt bi¬u ð° làm ð¸nh dÕng ð¥u ra, bÕn phäi ch÷n ít nh¤t 1 cÞ bi¬u ð°.',
        'If you need the sum of every row select yes' =>
            'Nªu bÕn c¥n t±ng s¯ hàng, Hãy ch÷n \'Có\'.',
        'If you need the sum of every column select yes.' =>
            'Nªu bÕn c¥n t±ng s¯ cµt, Hãy ch÷n \'Có\'.',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'H¥u hªt các th¯ng kê ð«u có th¬ ðßþc lßu. Ði«u này s¨ ð¦y nhanh t¯c ðµ trình di­n cüa th¯ng kê.',
        '(Note: Useful for big databases and low performance server)' =>
            '(Lßu ý: Hæu døng ð¯i v¾i các c½ s· dæ li®u l¾n và máy chü c¤u hình th¤p)',
        'With an invalid stat it isn\'t feasible to generate a stat.' =>
            'Ð¯i v¾i th¯ng kê không hþp l®, không khä thi ð¬ sinh th¯ng kê.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.'
            => 'Ði«u này s¨ có ích nªu bÕn mu¯n không ai có th¬ l¤y kªt quä cüa th¯ng kê ho£c th¯ng kê không sÇn sàng ðßþc c¤u hình.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Ch÷n các thành t¯ cho chu²i giá tr¸',
        'Scale'                                    => 'PhÕm vi',
        'minimal'                                  => 't¯i thi¬u',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).'
            => 'Hãy nh¾ r¢ng, phÕm vi cho chu²i giá tr¸ phäi l¾n h½n phÕm vi cho trøc X (ví dø: trøc X => Tháng; Chu²i giá tr¸ => Nåm).',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.'
            => 'BÕn có th¬ ð¸nh nghîa chu²i giá tr¸ tÕi ðây. BÕn có khä nång chon 1 ho£c 2 thành t¯. Sau ðó có th¬ ch÷n các thuµc tính cüa thành t¯. M²i thuµc tính s¨ ðßþc hi¬n th¸ là mµt chu²i giá tr¸ ð½n lë. Nªu không ch÷n thuµc tính nào, t¤t cä thuµc tính cüa thành t¯ s¨ ðßþc sØ døng nªu bÕn sinh th¯ng kê. Cùng v¾i ðó mµt thuµc tính m¾i cûng ðßþc thêm k¬ t× l¥n c¤u hình cu¯i cùng.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' =>
            'Ch÷n thành t¯ sØ døng trên trøc X.',
        'maximal period' => 'chu kÏ t¯i ða',
        'minimal scale'  => 'phÕm vi t¯i thi¬u',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.'
            => 'BÕn có th¬ ð¸nh nghîa trøc X tÕi ðây. BÕn có th¬ ch÷n 1 thành t¯ thông qua nút b¤m radio. Sau ðó phäi ch÷n 1 ho£c nhi«u thuµc tính cüa thành t¯. Nªu không ch÷n t¤t cä thuµc tính cüa thành t¯ s¨ ðßþc sØ døng nªu bÕn sinh th¯ng kê. Cùng v¾i ðó mµt thuµc tính m¾i cûng ðßþc thêm k¬ t× l¥n c¤u hình cu¯i cùng.',

        # Template: AgentStatsImport
        'Import'                     => 'Nh§p',
        'File is not a Stats config' => 'File không phäi là mµt c¤u hình th¯ng kê',
        'No File selected'           => 'Không có file nào ðßþc ch÷n',

        # Template: AgentStatsOverview
        'Object' => 'Ð¯i tßþng',

        # Template: AgentStatsPrint
        'Print'                => 'In',
        'No Element selected.' => 'Không thành t¯ nào ðßþc ch÷n.',

        # Template: AgentStatsView
        'Export Config'               => 'C¤u hình xu¤t',
        'Information about the Stat' => 'Thông tin v« th¯ng kê',
        'Exchange Axis'               => 'Trøc trao ð±i',
        'Configurable params of static stat' =>
            'Tham s¯ c¤u hình cüa th¯ng kê tînh',
        'No element selected.' => 'Không thành t¯ nào ðßþc ch÷n.',
        'maximal period from'  => 'chu kÏ t¯i ða t×',
        'to'                   => 'ðªn',
        'Start'                => 'b¡t ð¥u',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.'
            => 'V¾i các trß¶ng ð¥u vào và ðã ch÷n bÕn có th¬ c¤u hình th¯ng kê theo yêu c¥u. V¾i các thành t¯ cüa mµt th¯ng kê bÕn có th¬ sØa tùy theo ngß¶i quän tr¸ th¯ng kê ðó ðã c¤u hình',

        # Template: AgentTicketBounce
        'Bounce ticket'     => 'Thë ðã bö',
        'Ticket locked!'    => 'Thë khóa!',
        'Ticket unlock!'    => 'Thë m·!',
        'Bounce to'         => 'T× bö t×',
        'Next ticket state' => 'TrÕng thái thë tiªp theo',
        'Inform sender'     => 'Thông báo ngß¶i gØi',
        'Send mail!'        => 'GØi mail!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'L®nh lô trên thë',
        'Spell Check'        => 'Ki¬m tra chính tä',
        'Note type'          => 'LoÕi lßu ý',
        'Unlock Tickets'     => 'Các thë m·',

        # Template: AgentTicketClose
        'Close ticket'           => 'Ðóng thë',
        'Previous Owner'         => 'Phø trách trß¾c',
        'Inform Agent'           => 'Nhân viên thông báo',
        'Optional'               => 'Tùy ch÷n',
        'Inform involved Agents' => 'Thông báo các nhân viên liên quan',
        'Attach'                 => 'Ðính kèm',
        'Next state'             => 'TrÕng thái tiªp',
        'Pending date'           => 'Ngày treo',
        'Time units'             => 'Các ð½n v¸ th¶i gian',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'SoÕn trä l¶i cho thë',
        'Pending Date'              => 'Ngày treo',
        'for pending* states'       => 'ð¯i v¾i các trÕng thái treo*',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Thay ð±i khách hàng cüa thë',
        'Set customer user and customer id of a ticket' =>
            'Thiªt ð£t mã khách hàng và ngß¶i dùng khách hàng cüa thë',
        'Customer User'         => 'Ngß¶i dùng khách hàng',
        'Search Customer'       => 'Tìm kiªm khách hàng',
        'Customer Data'         => 'Dæ li®u khách hàng',
        'Customer history'      => 'L¸ch sØ khách hàng',
        'All customer tickets.' => 'T¤t cä các thë khách hàng.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Theo dõi',

        # Template: AgentTicketEmail
        'Compose Email' => 'SoÕn email',
        'new ticket'    => 'thë m¾i',
        'Refresh'       => 'Làm m¾i',
        'Clear To'      => 'Xóa t¾i',

        # Template: AgentTicketForward
        'Article type' => 'LoÕi bài viªt',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Thay ð±i nµi dung thë',

        # Template: AgentTicketHistory
        'History of' => 'L¸ch sØ cüa',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox'      => 'Hµp mail',
        'Tickets'      => 'Các thë',
        'of'           => 'cüa',
        'Filter'       => 'L÷c',
        'New messages' => 'Tin nh¡n m¾i',
        'Reminder'     => 'Nh¡c nh·',
        'Sort by'      => 'S¡p xªp theo',
        'Order'        => 'Tr§t tñ',
        'up'           => 'lên',
        'down'         => 'xu¯ng',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Trµn thë',
        'Merge to'     => 'Trµn v¾i',

        # Template: AgentTicketMove
        'Move Ticket' => 'Chuy¬n thë',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Thêm lßu ý cho thë',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Thay ð±i phø trách thë',

        # Template: AgentTicketPending
        'Set Pending' => 'Thiªt ð£t treo',

        # Template: AgentTicketPhone
        'Phone call' => 'Cuµc g÷i',
        'Clear From' => 'Xóa t×',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'G¯c',

        # Template: AgentTicketPrint
        'Ticket-Info'    => 'Thông tin thë',
        'Accounted time' => 'Th¶i gian kê khai',
        'Escalation in'  => 'Tiªp tøc trong',
        'Linked-Object'  => 'Ð¯i tßþng liên kªt',
        'Parent-Object'  => 'Ð¯i tßþng cha',
        'Child-Object'   => 'Ð¯i tßþng con',
        'by'             => 'b·i',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Thay ð±i mÑc ðµ ßu tiên cüa thë',

        # Template: AgentTicketQueue
        'Tickets shown'      => 'Các thë hi¬n th¸',
        'Tickets available'  => 'Các thë sÇn sàng sØ døng',
        'All tickets'        => 'T¤t cä các thë',
        'Queues'             => 'Hàng ðþi',
        'Ticket escalation!' => 'Các thë tiªp tøc!',

        # Template: AgentTicketQueueTicketView
        'Service Time'      => 'Th¶i gian d¸ch vø',
        'Your own Ticket'   => 'Thë cüa bÕn',
        'Compose Follow up' => 'SoÕn theo dõi',
        'Compose Answer'    => 'SoÕn trä l¶i',
        'Contact customer'  => 'Liên h® khách hàng',
        'Change queue'      => 'Thay ð±i hàng ðþi',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Thay ð±i ngß¶i ch¸u trách nhi®m cüa thë',

        # Template: AgentTicketSearch
        'Ticket Search'                    => 'Tìm kiªm thë',
        'Profile'                          => 'H° s½',
        'Search-Template'                  => 'Tìm kiªm mçu',
        'TicketFreeText'                   => 'Nµi dung thë',
        'Created in Queue'                 => 'Ðã tÕo trong hàng ðþi',
        'Result Form'                      => 'Kªt quä t×',
        'Save Search-Profile as Template?' => 'Lßu h° s½ tìm kiªm thành mçu?',
        'Yes, save it with name'           => 'Có, lßu v¾i cùng mµt tên',

        # Template: AgentTicketSearchResult
        'Search Result'         => 'Kªt quä tìm kiªm',
        'Change search options' => 'Thay ð±i tùy ch÷n tìm kiªm',

        # Template: AgentTicketSearchResultShort
        'U' => 'U',
        'D' => 'D',

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Xem trÕng thái thë',
        'Open Tickets'       => 'M· thë',
        'Locked'             => 'Ðã khóa',

        # Template: AgentTicketZoom

        # Template: AgentWindowTab

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Truy nguyên',

        # Template: CustomerFooter
        'Powered by' => 'ChÕy trên n«n',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login'                  => 'Ðång nh§p',
        'Lost your password?'    => 'M¤t m§t kh¦u?',
        'Request new password'   => 'Yêu c¥u m§t kh¦u m¾i',
        'Create Account'         => 'TÕo tài khoän',
        'Sent new password to: ' => 'Ðã gØi m§t kh¦u m¾i t¾i: ',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Chào m×ng %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times'             => 'L¥n',
        'No time settings.' => 'Không có thiªt ð£t th¶i gian.',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning
        'This account exists.'             => 'Tài khoän này ðã t°n tÕi.',
        'Please press Back and try again.' => 'Xin hãy nh¤n Tr· lÕi và thØ lÕi l¥n næa.',

        # Template: Error
        'Click here to report a bug!' => 'Nh¤n chuµt vào ðây ð¬ gØi báo cáo l²i!',

        # Template: Footer
        'Top of Page' => 'Ð¥u trang',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer'         => 'Ngß¶i cài ð£t web',
        'Accept license'        => 'Ch¤p nh§n gi¤y phép',
        'Don\'t accept license' => 'Không ch¤p nh§n gi¤y phép',
        'Admin-User'            => 'Tên truy c§p quän tr¸',
        'Admin-Password'        => 'M§t kh¦u quän tr¸',
        'your MySQL DB should have a root password! Default is empty!' =>
            'C½ s· dæ li®u MySQL cüa bÕn nên có m§t kh¦u g¯c! M£c ð¸nh là ð¬ tr¯ng!',
        'Database-User'   => 'Ngß¶i dùng c½ s· dæ li®u',
        'default \'hot\'' => 'm£c ð¸nh \'hot\'',
        'DB connect host' => 'Máy chü host kªt n¯i c½ s· dæ li®u',
        'Database'        => 'C½ s· dæ li®u',
        'false'           => 'L²i',
        'SystemID'        => 'Mã h® th¯ng',
        '(The identify of the system. Each ticket number and each http session id starts with this number)'
            => '(Nh§n dÕng cüa h® th¯ng. M²i s¯ thë và m²i mã phiên http ð«u b¡t ð¥u b¢ng s¯ này)',
        'System FQDN' => 'H® th¯ng FQDN',
        '(Full qualified domain name of your system)' =>
            '(Tên mi«n ð¥y ðü ði«u ki®n cüa h® th¯ng)',
        'AdminEmail'                                => 'Email quän tr¸',
        '(Email of the system admin)'               => '(Email cüa quän tr¸ h® th¯ng)',
        'Organization'                              => 'T± chÑc',
        'Log'                                       => 'Bän ghi',
        'LogModule'                                 => 'Mô ðun bän ghi',
        '(Used log backend)'                        => '(Ðã sØ døng các bän ghi m£t sau)',
        'Logfile'                                   => 'File bän ghi',
        '(Logfile just needed for File-LogModule!)' => '(File bän ghi chï c¥n cho mô ðun File-Log!)',
        'Webfrontend'                               => 'M£t ngoài web',
        'Default Charset'                           => 'Mã ký tñ m£c ð¸nh',
        'Use utf-8 it your database supports it!' =>
            'Hãy dùng utf-8 nªu c½ s· dæ li®u cüa bÕn có h² trþ!',
        'Default Language'        => 'Ngôn ngæ m£c ð¸nh',
        '(Used default language)' => '(Dùng ngôn ngæ m£c ð¸nh)',
        'CheckMXRecord'           => 'Ki¬m tra bän ghi MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)'
            => '(Ki¬m tra các bän ghi MX cüa các ð¸a chï email ðã sØ døng b¢ng cách tÕo mµt trä l¶i. Không dùng Ki¬m tra bän ghi MX nªu h® th¯ng OTRS cüa bÕn n¢m sau 1 ðß¶ng dial-up!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.'
            => 'Ð¬ có th¬ sØ døng OTRS bÕn phäi nh§p dòng sau vào dòng l®nh cüa bÕn (Terminal/Shell) làm g¯c.',
        'Restart your webserver'                      => 'Kh·i ðµng lÕi máy chü web.',
        'After doing so your OTRS is up and running.' => 'Sau khi thñc hi®n OTRS cüa bÕn ðã hoÕt ðµng.',
        'Start page'                                  => 'Trang b¡t ð¥u',
        'Have a lot of fun!'                          => 'Hãy t§n hß·ng sñ vui thích!',
        'Your OTRS Team'                              => 'Ðµi OTRS cüa bÕn',

        # Template: Login
        'Welcome to %s' => 'Chào m×ng t¾i %s',

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Không có quy«n',

        # Template: Notify
        'Important' => 'Quan tr÷ng',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'ðßþc in b·i',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Trang test OTRS',
        'Counter'        => 'Bµ ðªm',

        # Template: Warning
        # Misc
        'Create Database'         => 'TÕo c½ s· dæ li®u',
        'verified'                => 'xác nh§n',
        'File-Name'               => 'Tên file',
        'Ticket Number Generator' => 'H® sinh s¯ thë',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')'
            => '(Nh§n dÕng thë. Mµt s¯ ngß¶i mu¯n thiªt ð£t ði«u này thành ví dø nhß \'Ticket#\', \'Call#\' ho£c \'MyTicket#\')',
        'Create new Phone Ticket' => 'TÕo thë cuµc g÷i m¾i',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' =>
            'Theo cách này bÕn có th¬ sØa trñc tiªp c¤u hình khóa trong Kernel/Config.pm',
        'A message should have a To: recipient!' =>
            'Mµt tin nh¡n nên có trß¶ng ngß¶i nh§n!',
        'Site' => 'Site',
        'Customer history search (e. g. "ID342425").' =>
            'Tìm kiªm l¸ch sØ khách hàng (ví dø: "ID342425").',
        'for agent firstname' => 'cho h÷ (tên) cüa nhân viên',
        'Close!'              => 'Ðóng!',
        'Reporter'            => 'Ngß¶i báo cáo',
        'Process-Path'        => 'Ðß¶ng dçn quy trình',
        'The message being composed has been closed.  Exiting.' =>
            'Tin nh¡n ðang soÕn b¸ ðóng. Ðang thoát.',
        'to get the realname of the sender (if given)' =>
            'ð¬ l¤y tên thñc cüa ngß¶i gØi (nªu có)',
        'FAQ Search Result'       => 'Kªt quä tìm kiªm FAQ',
        'Notification (Customer)' => 'Thông báo (Khách hàng)',
        'Select Source (for add)' => 'Ch÷n ngu°n (ð¬ thêm)',
        'Node-Name'               => 'Tên nút',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)'
            => 'Các tùy ch÷n cüa dæ li®u thë (ví dø: &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Home'                  => 'Trang chü',
        'Workflow Groups'       => 'Các nhóm Dòng công vi®c',
        'Current Impact Rating' => 'MÑc änh hß·ng hi®n tÕi',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' =>
            'Các tùy ch÷n c¤u hình (ví dø: <OTRS_CONFIG_HttpType>)',
        'FAQ System History'             => 'L¸ch sØ h® th¯ng FAQ',
        'customer realname'              => 'tên thñc khách hàng',
        'Pending messages'               => 'Các tin nh¡n treo',
        'Modules'                        => 'Mô ðun',
        'for agent login'                => 'cho nhân viên ðång nh§p',
        'Keyword'                        => 'T× khóa',
        'Reference'                      => 'Tham chiªu',
        'with'                           => 'v¾i',
        'Close type'                     => 'Ðóng loÕi',
        'DB Admin User'                  => 'Ngß¶i dùng quän tr¸ C½ s· dæ li®u',
        'for agent user id'              => 'ð¯i v¾i mã ngß¶i dùng nhân viên',
        'sort upward'                    => 's¡p xªp theo hß¾ng tång',
        'Classification'                 => 'Phân loÕi',
        'Change user <-> group settings' => 'Thay ð±i ngß¶i dùng <-> các thiªt ð£t nhóm',
        'next step'                      => 'bß¾c tiªp theo',
        'Customer history search'        => 'Tìm kiªm l¸ch sØ khách hàng',
        'not verified'                   => 'chßa ðßþc xác nh§n',
        'Stat#'                          => 'Th¯ng kê s¯',
        'Create new database'            => 'TÕo c½ s· dæ li®u m¾i',
        'Year'                           => 'Nåm',
        'A message must be spell checked!' =>
            'Tin nh¡n phäi ðßþc ki¬m tra chính tä!',
        'X-axis' => 'trøc X',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.'
            => 'Email cüa bÕn v¾i s¯ thë "<OTRS_TICKET>" ðßþc chuy¬n t¾i "<OTRS_BOUNCE_TO>". Hãy liên h® v¾i ð¸a chï này ð¬ có thêm thông tin.',
        'A message should have a body!' => 'Tin nh¡n nên có nµi dung!',
        'All Agents'                    => 'T¤t cä nhân viên',
        'Keywords'                      => 'T× khóa',
        'No * possible!'                => 'Không * có th¬!',
        'Load'                          => 'Täi',
        'Change Time'                   => 'Thay ð±i th¶i gian',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)'
            => 'Các tùy ch÷n cüa ngß¶i dùng hi®n tÕi yêu c¥u hành ðµng này (ví dø: &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner'                 => 'Tin nh¡n cho phø trách m¾i',
        'to get the first 5 lines of the email' => 'ð¬ l¤y 5 dòng ð¥u tiên cüa email',
        'OTRS DB Password'                      => 'M§t kh¦u c½ s· dæ li®u OTRS',
        'Last update'                           => 'L¥n c§p nh§t trß¾c',
        'not rated'                             => 'chßa xªp hÕng',
        'to get the first 20 character of the subject' =>
            'ð¬ l¤y 20 ký tñ ð¥u tiên cüa tiêu ð«',
        'DB Admin Password' => 'M§t kh¦u quän tr¸ C½ s· dæ li®u',
        'Drop Database'     => 'Bö qua C½ s· dæ li®u',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' =>
            'Các tùy ch÷n cüa dæ li®u ngß¶i dùng khách hàng hi®n tÕi (ví dø: <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type'       => 'LoÕi treo',
        'Comment (internal)' => 'Nh§n xét (nµi bµ)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' =>
            'Các tùy ch÷n phø trách thë (ví dø: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'This window must be called from compose window' =>
            'CØa s± này c¥n phäi ðßþc g÷i t× cØa s± soÕn thäo',
        'User-Number'                        => 'S¯ ngß¶i dùng',
        'You need min. one selected Ticket!' => 'BÕn c¥n t¯i thi¬u 1 thë ðßþc ch÷n!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)'
            => 'Các tùy ch÷n cüa dæ li®u thë (ví dø: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Ð¸nh dÕng s¯ thë sØ døng)',
        'Fulltext'                    => 'Toàn bµ vån bän',
        'Month'                       => 'Tháng',
        'Node-Address'                => 'Ð¸a chï nút',
        'All Agent variables.'        => 'T¤t cä các biªn s¯ nhân viên',
        ' (work units)'               => ' (các ð½n v¸ làm vi®c)',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' =>
            'BÕn sØ døng tùy ch÷n Xóa! Hãy c¦n th§n, t¤t cä các thë xóa s¨ b¸ m¤t!',
        'All Customer variables like defined in config option CustomerUser.' =>
            'T¤t cä các biªn s¯ khách hàng ðã ð¸nh nghîa trong c¤u hình tùy ch÷n ngß¶i dùng khách hàng.',
        'for agent lastname' => 'tên nhân viên',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)'
            => 'Các tùy ch÷n cüa ngß¶i dùng hi®n tÕi ngß¶i yêu c¥u hành ðµng này (ví dø: <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages'                => 'Tin nh¡n nh¡c nh·',
        'A message should have a subject!' => 'Thß nên có tiêu ð«!',
        'TicketZoom'                       => 'Phóng ðÕi thë',
        'Don\'t forget to add a new user to groups!' =>
            'Ð×ng quên b± sung mµt ngß¶i dùng m¾i vào nhóm!',
        'You need a email address (e. g. customer@example.com) in To:!' =>
            'BÕn c¥n ð¸a chï email trong trß¶ng T¾i (ví dø: kunde@example.com)!',
        'CreateTicket'              => 'TÕo thë',
        'unknown'                   => 'chßa xác ð¸nh',
        'You need to account time!' => 'BÕn c¥n t¾i th¶i gian tài khoän!',
        'System Settings'           => 'Thiªt ð£t h® th¯ng',
        'Finished'                  => 'Kªt thúc',
        'Imported'                  => 'Nh§p',
        'unread'                    => 'chßa ð÷c',
        'Split'                     => 'Chia',
        'All messages'              => 'T¤t cä tin nh¡n',
        'System Status'             => 'TrÕng thái h® th¯ng',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)'
            => 'Các tùy ch÷n cüa dæ li®u thë (ví dø: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'A article should have a title!' => 'Bài viªt nên có tiêu ð«!',
        'Event'                          => 'Sñ ki®n',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' =>
            'Các tùy ch÷n c¤u hình (ví dø: &lt;OTRS_CONFIG_HttpType&gt;)',
        'Imported by' => 'Nh§p b·i',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' =>
            'Các tùy ch÷n chü thë (ví dø <OTRS_OWNER_UserFirstname>)',
        'read'                              => 'ð÷c',
        'Product'                           => 'Sän ph¦m',
        'Name is required!'                 => 'Tên ðßþc yêu c¥u!',
        'kill all sessions'                 => 'xóa t¤t cä các phiên',
        'to get the from line of the email' => 'ð¬ l¤y t× dòng email',
        'Solution'                          => 'Giäi pháp',
        'QueueView'                         => 'Xem hàng ðþi',
        'My Queue'                          => 'Hàng ðþi cüa tôi',
        'Instance'                          => 'Trß¶ng hþp',
        'Day'                               => 'Ngày',
        'Service-Name'                      => 'Tên d¸ch vø',
        'Welcome to OTRS'                   => 'Chào m×ng bÕn ðªn v¾i OTRS',
        'tmp_lock'                          => 'khóa_tmp',
        'modified'                          => 'ðã chïnh sØa',
        'Delete old database'               => 'Xóa c½ s· dæ li®u cû',
        'sort downward'                     => 's¡p xªp theo hß¾ng giäm',
        'You need to use a ticket number!'  => 'BÕn c¥n dùng s¯ thë!',
        'Watcher'                           => 'Ngß¶i xem',
        'send'                              => 'gØi',
        'Note Text'                         => 'Lßu ý',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)'
            => 'Các tùy ch÷n cüa dæ li®u ngß¶i dùng khách hàng hi®n tÕi ((ví dø: &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;).',
        'System State Management'          => 'Quän tr¸ trÕng thái h® th¯ng',
        'PhoneView'                        => 'Xem s¯ ði®n thoÕi',
        'User-Name'                        => 'Tên ðång nh§p',
        'File-Path'                        => 'Ðß¶ng dçn file',
        'Modified'                         => 'Ðã chïnh sØa',
        'Ticket selected for bulk action!' => 'Thë ðã ðßþc ch÷n cho l®nh lô',
    };

    # $$STOP$$
    return;
}

1;
