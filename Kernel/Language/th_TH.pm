# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::th_TH;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%T - %D/%M/%Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.819419419419419;

    # csv separator
    $Self->{Separator} = ',';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'ใช่',
        'No' => 'ไม่',
        'yes' => 'ใช่',
        'no' => 'ไม่',
        'Off' => 'ปิด',
        'off' => 'ปิด',
        'On' => 'เปิด',
        'on' => 'เปิด',
        'top' => 'บน',
        'end' => 'จบ',
        'Done' => 'ดำเนินการเสร็จแล้ว',
        'Cancel' => 'ยกเลิก',
        'Reset' => 'รีเซ็ต',
        'more than ... ago' => 'มากกว่า... ที่ผ่านมา',
        'in more than ...' => 'ในมากกว่า...',
        'within the last ...' => 'ภายในครั้งล่าสุด',
        'within the next ...' => 'ภายในครั้งต่อไป...',
        'Created within the last' => 'สร้างขึ้นภายในครั้งล่าสุด...',
        'Created more than ... ago' => 'สร้างขึ้นมากกว่า...ที่ผ่านมา',
        'Today' => 'วันนี้',
        'Tomorrow' => 'พรุ่งนี้',
        'Next week' => 'อาทิตย์ถัดไป',
        'day' => 'วัน',
        'days' => 'วัน',
        'day(s)' => 'วัน(s)',
        'd' => 'ว',
        'hour' => 'ชั่วโมง',
        'hours' => 'ชั่วโมง',
        'hour(s)' => 'ชั่วโมง(s)',
        'Hours' => 'ชั่วโมง',
        'h' => 'ช',
        'minute' => 'นาที',
        'minutes' => 'นาที',
        'minute(s)' => 'นาที(s)',
        'Minutes' => 'นาที',
        'm' => 'ด',
        'month' => 'เดือน',
        'months' => 'เดือน',
        'month(s)' => 'เดือน(s)',
        'week' => 'อาทิตย์',
        'week(s)' => 'อาทิตย์(s)',
        'quarter' => 'ไตรมาส',
        'quarter(s)' => 'ไตรมาส(s)',
        'half-year' => 'ครึ่งปี',
        'half-year(s)' => 'ครึ่งปี(s)',
        'year' => 'ปี',
        'years' => 'ปี',
        'year(s)' => 'ปี(s)',
        'second(s)' => 'วินาที(s)',
        'seconds' => 'วินาที',
        'second' => 'วินาที',
        's' => 'วินาที',
        'Time unit' => 'หน่วยเวลา',
        'wrote' => 'เขียน',
        'Message' => 'ข้อความ',
        'Error' => 'ข้อผิดพลาด',
        'Bug Report' => 'รายงานข้อผิดพลาด',
        'Attention' => 'ความสนใจ',
        'Warning' => 'คำเตือน',
        'Module' => 'โมดูล',
        'Modulefile' => 'ไฟล์โมดูล',
        'Subfunction' => 'ฟังก์ชั่นย่อย',
        'Line' => 'ไลน์',
        'Setting' => 'การตั้งค่า',
        'Settings' => 'การตั้งค่า',
        'Example' => 'ตัวอย่าง',
        'Examples' => 'ตัวอย่าง',
        'valid' => 'ถูกต้อง',
        'Valid' => 'ถูกต้อง',
        'invalid' => 'ถูกต้อง',
        'Invalid' => 'ไม่ถูกต้อง',
        '* invalid' => 'ไม่ถูกต้อง',
        'invalid-temporarily' => 'ไม่ถูกต้องชั่วคราว',
        ' 2 minutes' => '2 นาที',
        ' 5 minutes' => '5 นาที',
        ' 7 minutes' => '7 นาที',
        '10 minutes' => '10 นาที',
        '15 minutes' => '15 นาที',
        'Mr.' => 'นาย',
        'Mrs.' => 'นาง',
        'Next' => 'ถัดไป',
        'Back' => 'กลับไป',
        'Next...' => 'ถัดไป...',
        '...Back' => '...กลับไป',
        '-none-' => '-ไม่มี-',
        'none' => 'ไม่มี',
        'none!' => 'ไม่มี!',
        'none - answered' => 'ไม่มีคำตอบ',
        'please do not edit!' => 'ได้โปรดอย่าแก้ไข!',
        'Need Action' => 'ต้องการการดำเนินการ',
        'AddLink' => 'เพิ่มลิงค์',
        'Link' => 'ลิงค์',
        'Unlink' => 'ยกเลิกการลิงค์',
        'Linked' => 'เชื่อมต่อแล้ว',
        'Link (Normal)' => 'การเชื่อมต่อ(Normal)',
        'Link (Parent)' => 'การเชื่อมต่อ(Parent)',
        'Link (Child)' => 'การเชื่อมต่อ(Child)',
        'Normal' => 'Normal',
        'Parent' => 'Parent',
        'Child' => 'Child',
        'Hit' => 'กดปุ่ม',
        'Hits' => 'กดปุ่ม',
        'Text' => 'ข้อความ',
        'Standard' => 'มาตรฐาน',
        'Lite' => 'Lite',
        'User' => 'ผู้ใช้',
        'Username' => 'ชื่อผู้ใช้',
        'Language' => 'ภาษา',
        'Languages' => 'ภาษา',
        'Password' => 'รหัสผ่าน',
        'Preferences' => 'การกำหนดลักษณะ',
        'Salutation' => 'คำขึ้นต้น',
        'Salutations' => 'คำขึ้นต้น',
        'Signature' => 'ลายเซ็น',
        'Signatures' => 'ลายเซ็น',
        'Customer' => 'ลูกค้า',
        'CustomerID' => 'ไอดีลูกค้า',
        'CustomerIDs' => 'ไอดีลูกค้า',
        'customer' => 'ลูกค้า',
        'agent' => 'เอเย่นต์',
        'system' => 'ระบบ',
        'Customer Info' => 'ข้อมูลลูกค้า',
        'Customer Information' => 'ข้อมูลลูกค้า',
        'Customer Companies' => 'บริษัทลูกค้า',
        'Company' => 'บริษัท',
        'go!' => 'ไป!',
        'go' => 'ไป',
        'All' => 'ทั้งหมด',
        'all' => 'ทั้งหมด',
        'Sorry' => 'เสียใจด้วย',
        'update!' => 'อัปเดต!',
        'update' => 'อัปเดต',
        'Update' => 'อัปเดต',
        'Updated!' => 'อัปเดต!',
        'submit!' => 'ส่ง!',
        'submit' => 'ส่ง',
        'Submit' => 'ส่ง',
        'change!' => 'เปลี่ยน!',
        'Change' => 'เปลี่ยน',
        'change' => 'เปลี่ยน',
        'click here' => 'คลิกที่นี้',
        'Comment' => 'ความคิดเห็น',
        'Invalid Option!' => 'ตัวเลือกไม่ถูกต้อง!',
        'Invalid time!' => 'เวลาไม่ถูกต้อง!',
        'Invalid date!' => 'วันที่ไม่ถูกต้อง!',
        'Name' => 'ชื่อ',
        'Group' => 'กลุ่ม',
        'Description' => 'คำอธิบาย',
        'description' => 'คำอธิบาย',
        'Theme' => 'ตีม',
        'Created' => 'สร้างแล้ว',
        'Created by' => 'สร้างโดย',
        'Changed' => 'เปลี่ยนแล้ว',
        'Changed by' => 'เปลี่ยนโดย',
        'Search' => 'ค้นหา',
        'and' => 'และ',
        'between' => 'ระหว่าง',
        'before/after' => 'ก่อน/หลัง',
        'Fulltext Search' => 'ค้นหาข้อความฉบับเต็ม',
        'Data' => 'ข้อมูล',
        'Options' => 'ตัวเลือก',
        'Title' => 'หัวข้อ',
        'Item' => 'รายการ',
        'Delete' => 'ลบ',
        'Edit' => 'แก้ไข',
        'View' => 'มุมมอง',
        'Number' => 'หมายเลข',
        'System' => 'ระบบ',
        'Contact' => 'ติดต่อ',
        'Contacts' => 'ติดต่อ',
        'Export' => 'ส่งออก',
        'Up' => 'ขึ้น',
        'Down' => 'ลง',
        'Add' => 'เพิ่ม',
        'Added!' => 'เพิ่มแล้ว!',
        'Category' => 'หมวดหมู่',
        'Viewer' => 'ผู้ชม',
        'Expand' => 'การขยาย',
        'Small' => 'ขนาดเล็ก',
        'Medium' => 'ขนาดกลาง',
        'Large' => 'ขนาดใหญ่',
        'Date picker' => 'วันที่ที่เลือก',
        'Show Tree Selection' => 'แสดงการเลือก Tree ',
        'The field content is too long!' => 'เนื้อหาในฟิลด์ยาวเกินไป',
        'Maximum size is %s characters.' => 'จำนวนที่มากที่สุดคือ %s ตัวอักษร',
        'This field is required or' => 'ต้องการฟิลด์นี้หรือ',
        'New message' => 'ข้อความถัดไป',
        'New message!' => 'ข้อความใหม่!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'โปรดตอบกลับตั๋วนี้เพื่อกลับไปยังมุมมองคิวปกติ',
        'You have %s new message(s)!' => 'คุณมี %s ข้อความใหม่(s)!',
        'You have %s reminder ticket(s)!' => 'คุณมี  %s ตั๋วการแจ้งเตือน(s)!',
        'The recommended charset for your language is %s!' => 'ชุดตัวอักษรที่แนะนำสำหรับภาษาของคุณคือ%s!',
        'Change your password.' => 'เปลี่ยนรหัสผ่านของคุณ.',
        'Please activate %s first!' => 'กรุณาเปิดใช้งาน %s ก่อน!',
        'No suggestions' => 'ไม่มีข้อเสนอแนะ',
        'Word' => 'คำพูด',
        'Ignore' => 'ละเว้น',
        'replace with' => 'แทนที่ด้วย',
        'There is no account with that login name.' => 'ไม่มีบัญชีชื่อล็อคอินนี้',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'เข้าระบบลงล้มเหลว! ชื่อผู้ใช้หรือรหัสผ่านของคุณไม่ถูกต้อง',
        'There is no acount with that user name.' => 'ไม่มีบัญชีชื่อผู้ใช้นี้',
        'Please contact your administrator' => 'กรุณาติดต่อผู้ดูแลระบบ',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'การตรวจสอบสิทธิ์เสร็จสิ้นแล้วแต่ไม่พบบันทึกลูกค้าในแบ็กเอนด์ของลูกค้า กรุณาติดต่อผู้ดูแลระบบ',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'อีเมลนี้มีอยู่แล้วกรุณาเข้าสู่ระบบหรือรีเซ็ตรหัสผ่านของคุณ',
        'Logout' => 'ออกจากระบบ',
        'Logout successful. Thank you for using %s!' => 'ออกจากระบบสำเร็จ ขอบคุณที่ใช้',
        'Feature not active!' => 'ฟีเจอร์ใช้งานไม่ได้!',
        'Agent updated!' => 'อัปเดตเอเย่นต์แล้ว',
        'Database Selection' => 'การเลือกฐานข้อมูล',
        'Create Database' => 'สร้างฐานข้อมูล',
        'System Settings' => 'การตั้งค่าระบบ',
        'Mail Configuration' => 'การกำหนดค่าเมล์',
        'Finished' => 'เสร็จสิ้น',
        'Install OTRS' => 'การติดตั้งOTRS',
        'Intro' => 'แนะนำ',
        'License' => 'ใบอนุญาต',
        'Database' => 'ฐานข้อมูล',
        'Configure Mail' => 'กำหนดค่าเมล์',
        'Database deleted.' => 'ฐานข้อมูลที่ถูกลบ',
        'Enter the password for the administrative database user.' => 'ป้อนรหัสผ่านสำหรับผู้ใช้ฐานข้อมูลในการบริหาร',
        'Enter the password for the database user.' => 'ป้อนรหัสผ่านสำหรับผู้ใช้ฐานข้อมูล',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'หากคุณตั้งรหัสผ่าน root สำหรับฐานข้อมูลของคุณก็จะต้องป้อนเข้าที่นี่หากไม่ได้ตั้งค่าไว้ ก็ปล่อยให้ฟิลด์นี้ว่างเปล่า',
        'Database already contains data - it should be empty!' => 'ฐานข้อมูลมีข้อมูลอยู่แล้ว - มันควรจะว่างเปล่า!',
        'Login is needed!' => 'จำเป็นต้องเข้าระบบ!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'ยังไม่สามารถเข้าสู่ระบบในตอนนี้เนื่องจากการบำรุงรักษาระบบที่กำหนด',
        'Password is needed!' => 'จำเป็นต้องใช้รหัสผ่าน!',
        'Take this Customer' => 'ใช้ลูกค้านี้',
        'Take this User' => 'ใช้ผู้ใช้นี้',
        'possible' => 'ความเป็นไปได้',
        'reject' => 'ปฏิเสธ',
        'reverse' => 'ย้อนกลับ',
        'Facility' => 'สิ่งอำนวยความสะดวก',
        'Time Zone' => 'โซนเวลา',
        'Pending till' => 'รอดำเนินการจนถึง',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'อย่าใช้บัญชี Superuser เพื่อใช้งานOTRS! สร้างเอเย่นต์ใหม่และใช้งานด้วยบัญชีเหล่านี้แทน',
        'Dispatching by email To: field.' => 'ส่งโดยการส่งอีเมล์ไปที่: ฟิลด์',
        'Dispatching by selected Queue.' => 'ส่งโดยคิวที่เลือก',
        'No entry found!' => 'ไม่พบข้อมูลการเข้า!',
        'Session invalid. Please log in again.' => 'เซสชั่นที่ไม่ถูกต้อง กรุณาเข้าสู่ระบบอีกครั้ง',
        'Session has timed out. Please log in again.' => 'เซสชั่นได้หมดเวลา กรุณาเข้าสู่ระบบอีกครั้ง',
        'Session limit reached! Please try again later.' => 'เซสชั่นถึงขีดจำกัด! กรุณาลองใหม่อีกครั้งในภายหลัง.',
        'No Permission!' => 'ไม่มีสิทธิ์!',
        '(Click here to add)' => '(คลิกที่นี่เพื่อเพิ่ม)',
        'Preview' => 'ดูตัวอย่าง',
        'Package not correctly deployed! Please reinstall the package.' =>
            'ไม่สามารถใช้งานแพคเกจได้อย่างถูกต้อง! กรุณาติดตั้งแพคเกจ',
        '%s is not writable!' => 'ไม่สามารถเขียนได้!',
        'Cannot create %s!' => 'ไม่สามารถสร้าง %s!',
        'Check to activate this date' => 'ตรวจสอบเพื่อเปิดใช้งานวันนี้',
        'You have Out of Office enabled, would you like to disable it?' =>
            'คุณไม่อยู่ที่สำนักงานที่เปิดใช้งาน คุณต้องการจะปิดการใช้งานหรือไม่?',
        'News about OTRS releases!' => 'ข่าวเกี่ยวกับการเผยแพร่OTRS !',
        'Go to dashboard!' => 'ไปที่แดชบอร์ด!',
        'Customer %s added' => 'ลูกค้าเพิ่มขึ้น % s',
        'Role added!' => 'เพิ่มบทบาทแล้ว!',
        'Role updated!' => 'อัปเดตบทบาทแล้ว!',
        'Attachment added!' => 'เพิ่มสิ่งที่แนบมาแล้ว!',
        'Attachment updated!' => 'อัปเดตสิ่งที่แนบมาแล้ว!',
        'Response added!' => 'เพิ่มการตอบสนอง!',
        'Response updated!' => 'อัปเดตการตอบสนอง!',
        'Group updated!' => 'อัปเดตกลุ่มแล้ว!',
        'Queue added!' => 'เพิ่มคิวแล้ว!',
        'Queue updated!' => 'อัปเดตคิวแล้ว!',
        'State added!' => 'เพิ่มสถานภาพแล้ว!',
        'State updated!' => 'อัปเดตสถานภาพแล้ว!',
        'Type added!' => 'เพิ่มประเภทแล้ว!',
        'Type updated!' => 'อัปเดตประเภทแล้ว!',
        'Customer updated!' => 'อัปเดตลูกค้าแล้ว!',
        'Customer company added!' => 'เพิ่มลูกค้าบริษัทแล้ว!',
        'Customer company updated!' => 'อัปเดตลูกค้าบริษัทแล้ว!',
        'Note: Company is invalid!' => 'หมายเหตุ: บริษัทไม่ถูกต้อง!',
        'Mail account added!' => 'เพิ่มบัญชีอีเมลแล้ว!',
        'Mail account updated!' => 'อัปเดตบัญชีอีเมลแล้ว!',
        'System e-mail address added!' => 'เพิ่มระบบที่อยู่อีเมล์!',
        'System e-mail address updated!' => 'อัปเดตระบบที่อยู่อีเมล์!',
        'Contract' => 'สัญญา',
        'Online Customer: %s' => 'ลูกค้าออนไลน์:%s',
        'Online Agent: %s' => 'เอเย่นต์ออนไลน์:%s',
        'Calendar' => 'ปฏิทิน',
        'File' => 'ไฟล์',
        'Filename' => 'ชื่อไฟล์',
        'Type' => 'ประเภท',
        'Size' => 'ขนาด',
        'Upload' => 'อัพโหลด',
        'Directory' => 'Directory',
        'Signed' => 'ลงนาม',
        'Sign' => 'ลงนาม',
        'Crypted' => 'Crypted',
        'Crypt' => 'Crypt',
        'PGP' => 'PGP',
        'PGP Key' => 'คีย์ PGP',
        'PGP Keys' => 'คีย์ PGP',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'ใบรับรอง S/MIME',
        'S/MIME Certificates' => 'ใบรับรอง S/MIME',
        'Office' => 'ออฟฟิศ',
        'Phone' => 'โทรศัพท์',
        'Fax' => 'แฟกซ์',
        'Mobile' => 'โทรศัพท์มือถือ',
        'Zip' => 'รหัสไปรษณีย์',
        'City' => 'เมือง',
        'Street' => 'ถนน',
        'Country' => 'ประเทศ',
        'Location' => 'ตำแหน่งที่อยู่',
        'installed' => 'ติดตั้งแล้ว',
        'uninstalled' => 'ยกเลิกการติดตั้ง',
        'Security Note: You should activate %s because application is already running!' =>
            'หมายเหตุด้านความปลอดภัย: คุณควรเปิดใช้งาน% เพราะแอพลิเคชันกำลังทำงานอยู่!',
        'Unable to parse repository index document.' => 'ไม่สามารถที่จะแยกพื้นที่เก็บข้อมูลเอกสารดัชนี',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'ไม่พบแพคเกจสำหรับเฟรมเวิร์คของคุณในพื้นที่เก็บข้อมูลนี้ มีเพียงแพคเกจสำหรับเฟรมเวิร์ครุ่นอื่นๆ',
        'No packages, or no new packages, found in selected repository.' =>
            'ไม่พบแพคเกจในพื้นที่เก็บข้อมูลที่คุณเลือก',
        'Edit the system configuration settings.' => 'แก้ไขการตั้งค่าการกำหนดค่าระบบ',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ข้อมูลACL จากฐานข้อมูลไม่ได้ซิงค์กับการกำหนดค่าระบบกรุณาใช้งาน ACLs ทั้งหมด',
        'printed at' => 'พิมพ์ที่',
        'Loading...' => 'กำลังโหลด ...',
        'Dear Mr. %s,' => 'เรียนคุณ% s,',
        'Dear Mrs. %s,' => 'เรียนคุณ% s,',
        'Dear %s,' => 'เรียน% s,',
        'Hello %s,' => 'สวัสดี% s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            'ที่อยู่อีเมลนี้ไม่ได้รับอนุญาตให้ลงทะเบียน กรุณาติดต่อเจ้าหน้าที่ฝ่ายสนับสนุน',
        'New account created. Sent login information to %s. Please check your email.' =>
            'สร้างบัญชีใหม่เรียบร้อยแล้ว ข้อมูลส่งเข้าสู่ระบบไปยัง% s กรุณาตรวจสอบอีเมลของคุณ',
        'Please press Back and try again.' => 'กรุณากดที่ปุ่มกลับและลองอีกครั้ง',
        'Sent password reset instructions. Please check your email.' => 'ได้ส่งคำแนะนำสำหรับการรีเซ็ตรหัสผ่านแล้ว กรุณาตรวจสอบอีเมลของคุณ',
        'Sent new password to %s. Please check your email.' => 'รหัสผ่านใหม่ถูกส่งไปยัง% s กรุณาตรวจสอบอีเมลของคุณ',
        'Upcoming Events' => 'กิจกรรมที่กำลังจะมาถึง',
        'Event' => 'กิจกรรม',
        'Events' => 'กิจกรรม',
        'Invalid Token!' => 'Token ไม่ถูกต้อง!',
        'more' => 'มากขึ้น',
        'Collapse' => 'ล่มสลาย',
        'Shown' => 'แสดงให้เห็น',
        'Shown customer users' => 'ผู้ใช้งานลูกค้าที่แสดงให้เห็น',
        'News' => 'ข่าว',
        'Product News' => 'ข่าวผลิตภัณฑ์',
        'OTRS News' => 'ข่าวOTRS',
        '7 Day Stats' => 'สถิติ 7 วัน',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'ข้อมูลการจัดการกระบวนการจากฐานข้อมูลไม่ได้อยู่ในซิงค์กับการกำหนดค่าระบบกรุณาเชื่อมต่อกระบวนการทั้งหมด',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'แพคเกจยังไม่ได้รับการตรวจสอบโดยกลุ่ม OTRS! ขอแนะนำไม่ให้ใช้แพคเกจนี้',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>หากคุณยังคงติดตั้งแพคเกจนี้ ปัญหาต่อไปนี้อาจเกิดขึ้น!<br><br>&nbsp;-  ปัญหาด้านความปลอดภัย<br>&nbsp;- ปัญหาความเสถียรภาพ<br>&nbsp;-ปัญหาประสิทธิภาพการทำงาน<br><br>โปรดทราบว่าปัญหาที่เกิดจากการทำงานร่วมกับแพคเกจนี้จะไม่ครอบคลุมตามสัญญาการให้การบริการของ OTRS!<br><br>',
        'Mark' => 'มาร์ค',
        'Unmark' => 'ยกเลิกการมาร์ค',
        'Bold' => 'ตัวหนา',
        'Italic' => 'ตัวเอียง',
        'Underline' => 'ขีดเส้นใต้',
        'Font Color' => 'สีตัวอักษร',
        'Background Color' => 'สีพื้นหลัง',
        'Remove Formatting' => 'ลบรูปแบบ',
        'Show/Hide Hidden Elements' => 'แสดง/ซ่อน องค์ประกอบที่ซ่อนอยู่',
        'Align Left' => 'จัดตำแหน่งด้านซ้าย',
        'Align Center' => 'จัดตำแหน่งกึ่งกลาง',
        'Align Right' => 'จัดตำแหน่งด้านขวา',
        'Justify' => 'แสดงให้เห็น',
        'Header' => 'หัวข้อ',
        'Indent' => 'เยื้องเข้า',
        'Outdent' => 'เยื้องออก',
        'Create an Unordered List' => 'สร้างรายชื่อแบบไม่เรียงลำดับ',
        'Create an Ordered List' => 'สร้างรายชื่อแบบเรียงลำดับ',
        'HTML Link' => 'ลิงค์ HTML',
        'Insert Image' => 'ใส่รูปภาพ',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'เลิกทำ',
        'Redo' => 'ทำซ้ำ',
        'OTRS Daemon is not running.' => 'OTRS Daemonไม่ทำงาน',
        'Can\'t contact registration server. Please try again later.' => 'ไม่สามารถติดต่อกับเซิร์ฟเวอร์ลงทะเบียน กรุณาลองใหม่อีกครั้งในภายหลัง.',
        'No content received from registration server. Please try again later.' =>
            'ไม่มีเนื้อหาที่ได้รับจากเซิร์ฟเวอร์ลงทะเบียนกรุณาลองใหม่อีกครั้งในภายหลัง.',
        'Problems processing server result. Please try again later.' => 'ปัญหาการประมวลผลผลจากเซิร์ฟเวอร์ กรุณาลองใหม่อีกครั้งในภายหลัง.',
        'Username and password do not match. Please try again.' => 'ชื่อผู้ใช้และรหัสผ่านไม่ตรงกัน กรุณาลองอีกครั้ง.',
        'The selected process is invalid!' => 'ขั้นตอนที่เลือกไม่ถูกต้อง!',
        'Upgrade to %s now!' => 'อัพเกรดเป็น% s ในขณะนี้!',
        '%s Go to the upgrade center %s' => '% s ไปที่ศูนย์การอัพเกรด% s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'ใบอนุญาตสำหรับ% s ของคุณกำลังจะหมดอายุ กรุณาโทรติดต่อกับ% s เพื่อต่อสัญญาของคุณ!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'การอัปเดตสำหรับ% s ของคุณพร้อมใช้งาน แต่มีข้อขัดแย้งกับเวอร์ชั่นเฟรมเวิร์คของคุณ! โปรดอัปเดตเฟรมเวิร์คก่อน!',
        'Your system was successfully upgraded to %s.' => 'ระบบของคุณประสบความสำเร็จในการอัพเกรดเปน % s',
        'There was a problem during the upgrade to %s.' => 'มีปัญหาเกิดขึ้นระหว่างการอัพเกรดเป็น% s',
        '%s was correctly reinstalled.' => '% s ได้รับการติดตั้งอย่างถูกต้อง',
        'There was a problem reinstalling %s.' => 'มีปัญหาในการติดตั้งอีกครั้ง% s',
        'Your %s was successfully updated.' => '% s ของคุณอัพเดตเรียบร้อยแล้ว',
        'There was a problem during the upgrade of %s.' => 'มีปัญหาเกิดขึ้นระหว่างการอัพเกรดของ% s',
        '%s was correctly uninstalled.' => '% sได้ยกเลิกการติดตั้งอย่างถูกต้อง',
        'There was a problem uninstalling %s.' => 'มีปัญหาในการถอนการติดตั้ง% s ',
        'Enable cloud services to unleash all OTRS features!' => 'เปิดใช้บริการคลาวด์เพื่อเปิดใช้งานคุณสมบัติ OTRS ทั้งหมด!',

        # Template: AAACalendar
        'New Year\'s Day' => 'วันขึ้นปีใหม่',
        'International Workers\' Day' => 'วันแรงงานสากล',
        'Christmas Eve' => 'วันคริสต์มาสอีฟ',
        'First Christmas Day' => 'วันแรกของคริสต์มาส',
        'Second Christmas Day' => 'วันที่สองของ',
        'New Year\'s Eve' => 'วันส่งท้ายปีเก่า',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS เป็นผู้ร้องขอ',
        'OTRS as provider' => 'OTRS เป็นผู้ให้บริการ',
        'Webservice "%s" created!' => 'สร้าง Webservice "%s" แล้ว!',
        'Webservice "%s" updated!' => 'อัปเดต Webservice "%s" !',

        # Template: AAAMonth
        'Jan' => 'ม.ค.',
        'Feb' => 'ก.พ',
        'Mar' => 'มี.ค.',
        'Apr' => 'เม.ย.',
        'May' => 'พ.ค.',
        'Jun' => 'มิ.ย.',
        'Jul' => 'ก.ค.',
        'Aug' => 'ส.ค.',
        'Sep' => 'ก.ย.',
        'Oct' => 'ต.ค.',
        'Nov' => 'พ.ย.',
        'Dec' => 'ธ.ค.',
        'January' => 'มกราคม',
        'February' => 'กุมภาพันธ์',
        'March' => 'มีนาคม',
        'April' => 'เมษายน',
        'May_long' => 'พฤษภาคม',
        'June' => 'มิถุนายน',
        'July' => 'กรกฎาคม',
        'August' => 'สิงหาคม',
        'September' => 'กันยายน',
        'October' => 'ตุลาคม\t',
        'November' => 'พฤศจิกายน\t',
        'December' => 'ธันวาคม',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'อัพเดตการตั้งค่าเรียบร้อยแล้ว!',
        'User Profile' => 'โปรไฟล์ผู้ใช้',
        'Email Settings' => 'การตั้งค่าอีเมล์',
        'Other Settings' => 'การตั้งค่าอื่นๆ',
        'Notification Settings' => 'การตั้งค่าการแจ้งเตือน',
        'Change Password' => 'เปลี่ยนรหัสผ่าน',
        'Current password' => 'รหัสผ่านปัจจุบัน',
        'New password' => 'รหัสผ่านใหม่',
        'Verify password' => 'ยืนยันรหัสผ่าน',
        'Spelling Dictionary' => 'พจนานุกรมการสะกดคำ',
        'Default spelling dictionary' => 'ค่าเริ่มต้นของพจนานุกรมการสะกดคำ',
        'Max. shown Tickets a page in Overview.' => 'สูงสุด แสดงตั๋วหน้านี้ในภาพรวม',
        'The current password is not correct. Please try again!' => 'รหัสผ่านปัจจุบันไม่ถูกต้อง กรุณาลองอีกครั้ง!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'ไม่สามารถอัพเดตรหัสผ่าน เนื่องจากรหัสผ่านใหม่ของคุณไม่ตรงกัน กรุณาลองอีกครั้ง!',
        'Can\'t update password, it contains invalid characters!' => 'ไม่สามารถอัพเดตรหัสผ่านเนื่องจากมีตัวอักษรที่ไม่ถูกต้อง!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'ไม่สามารถอัพเดตรหัสผ่าน ต้องมีความยาวอักขระอย่างน้อย% s!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'ไม่สามารถอัพเดตรหัสผ่านเนื่องจากต้องมีอย่างน้อย 2 ตัวพิมพ์เล็กและ 2 ตัวพิมพ์ใหญ่!',
        'Can\'t update password, it must contain at least 1 digit!' => 'ไม่สามารถอัพเดตรหัสผ่าน เนื่องจากต้องมีตัวเลขอย่างน้อย 1 หลัก!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'ไม่สามารถอัพเดตรหัสผ่านเนื่องจากต้องมีอย่างน้อย 2 ตัวอักษร!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'ไม่สามารถอัพเดตรหัสผ่าน เนื่องจากรหัสผ่านนี้มีการใช้งานแล้ว โปรดเลือกใหม่!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'เลือกตัวอักษรตัวคั่นที่ใช้ในไฟล์ CSV (สถิติและการค้นหา) ถ้าคุณไม่ได้เลือกตัวคั่นตอนนี้ ตัวคั่นเริ่มต้นสำหรับภาษาของคุณจะถูกนำไปใช้แทน',
        'CSV Separator' => 'ตัวคั่น CSV ',

        # Template: AAATicket
        'Status View' => 'มุมมองสถานภาพ',
        'Service View' => 'ุมุมมองการบริการ',
        'Bulk' => 'จำนวนมาก',
        'Lock' => 'ล็อค',
        'Unlock' => 'ปลดล็อค',
        'History' => 'ประวัติ',
        'Zoom' => 'ซูม',
        'Age' => 'อายุ',
        'Bounce' => 'การตีกลับ',
        'Forward' => 'ส่งต่อ',
        'From' => 'จาก',
        'To' => 'ถึง',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'หัวข้อ',
        'Move' => 'ย้าย',
        'Queue' => 'คิว',
        'Queues' => 'คิว',
        'Priority' => 'ลำดับความสำคัญ',
        'Priorities' => 'ลำดับความสำคัญ',
        'Priority Update' => 'อัพเดตลำดับความสำคัญ',
        'Priority added!' => 'เพิ่มลำดับความสำคัญ!',
        'Priority updated!' => 'อัพเดตลำดับความสำคัญแล้ว!',
        'Signature added!' => 'เพิ่มลายเซ็นแล้ว!',
        'Signature updated!' => 'อัพเดตลายเซ็นแล้ว!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'ข้อตกลงระดับการให้บริการ',
        'Service Level Agreements' => 'ข้อตกลงระดับการให้บริการ',
        'Service' => 'การบริการ',
        'Services' => 'การบริการ',
        'State' => 'สถานภาพ',
        'States' => 'สถานภาพ',
        'Status' => 'สถานะ',
        'Statuses' => 'สถานะ',
        'Ticket Type' => 'ประเภทของตั๋ว',
        'Ticket Types' => 'ประเภทของตั๋ว',
        'Compose' => 'เรียบเรียง',
        'Pending' => 'อยู่ระหว่างดำเนินการ',
        'Owner' => 'เจ้าของ',
        'Owner Update' => 'อัพเดตเจ้าของ',
        'Responsible' => 'การตอบสนอง',
        'Responsible Update' => 'อัปเดตการตอบสนอง',
        'Sender' => 'ผู้ส่ง',
        'Article' => 'บทความ',
        'Ticket' => 'ตั๋ว',
        'Createtime' => 'เวลาที่สร้าง',
        'plain' => 'ว่าง',
        'Email' => 'อีเมล์',
        'email' => 'อีเมล์',
        'Close' => 'ปิด',
        'Action' => 'การดำเนินการ',
        'Attachment' => 'สิ่งที่แนบมา',
        'Attachments' => 'สิ่งที่แนบมา',
        'This message was written in a character set other than your own.' =>
            'ข้อความนี้ถูกเขียนในชุดอักขระอื่นที่ไม่ใช่ของคุณเอง',
        'If it is not displayed correctly,' => 'ถ้ามันไม่ได้แสดงอย่างถูกต้อง',
        'This is a' => 'นี่คือ',
        'to open it in a new window.' => 'เพื่อเปิดในหน้าต่างใหม่',
        'This is a HTML email. Click here to show it.' => 'นี่คืออีเมลแบบ HTML คลิกที่นี่เพื่อแสดงมัน',
        'Free Fields' => 'ฟิลด์ฟรี',
        'Merge' => 'ผสาน',
        'merged' => 'ผสาน',
        'closed successful' => 'การปิดที่ประสบความสำเร็จ',
        'closed unsuccessful' => 'การปิดที่ไม่ประสบความสำเร็จ',
        'Locked Tickets Total' => 'จำนวนรวมตั๋วล็อค',
        'Locked Tickets Reminder Reached' => 'การแจ้งเตือนการล็อคตั๋วมาถึงแล้ว',
        'Locked Tickets New' => 'ตั๋วล็อคใหม่',
        'Responsible Tickets Total' => 'จำนวนรวมของตั๋วที่มีความรับผิดชอบ',
        'Responsible Tickets New' => 'ผู้รับผิดชอบตั๋วใหม่',
        'Responsible Tickets Reminder Reached' => 'การแจ้งเตือนผู้รับผิดชอบตั๋วมาถึงแล้ว',
        'Watched Tickets Total' => 'จำนวนรวมของตั๋วที่ดูแล้ว',
        'Watched Tickets New' => 'ตั๋วใหม่ที่ดูแล้ว',
        'Watched Tickets Reminder Reached' => 'การแจ้งเตือนตั๋วที่ดูแล้วมาถึงแล้ว',
        'All tickets' => 'ตั๋วทุกใบ',
        'Available tickets' => 'ตั๋วที่สามารถใช้ได้',
        'Escalation' => 'การขยาย',
        'last-search' => 'การค้นหาครั้งสุดท้าย',
        'QueueView' => 'มุมมองของคิว',
        'Ticket Escalation View' => 'มุมมองการขยายตั๋ว',
        'Message from' => 'ข้อความจาก',
        'End message' => 'ข้อความตอนท้าย',
        'Forwarded message from' => 'ส่งต่อข้อความจา',
        'End forwarded message' => 'ข้อความตอนท้ายของข้อความที่ส่งต่อ',
        'Bounce Article to a different mail address' => 'บทความตีกลับไปยังที่อยู่อีเมลที่แตกต่างกัน',
        'Reply to note' => 'ตอบกลับไปยังโน้ต',
        'new' => 'ใหม่',
        'open' => 'เปิด',
        'Open' => 'เปิด',
        'Open tickets' => 'เปิดตั๋ว',
        'closed' => 'ปิด',
        'Closed' => 'ปิด',
        'Closed tickets' => 'ปิดตั๋ว',
        'removed' => 'ลบออก',
        'pending reminder' => 'การแจ้งเตือนที่ค้างอยู่',
        'pending auto' => 'อยู่ระหว่างดำเนินการอัตโนมัติ',
        'pending auto close+' => 'อยู่ระหว่างดำเนินการปิดอัตโนมัติ +',
        'pending auto close-' => 'อยู่ระหว่างดำเนินการปิดอัตโนมัติ -',
        'email-external' => 'อีเมลภายนอก',
        'email-internal' => 'อีเมลภายใน',
        'note-external' => 'โน้ตภายนอก',
        'note-internal' => 'โน้ตภายใน',
        'note-report' => 'โน้ตรายงาน',
        'phone' => 'โทรศัพท์',
        'sms' => 'ข้อความ',
        'webrequest' => 'webrequest',
        'lock' => 'ล็อค',
        'unlock' => 'ปลดล็อค',
        'very low' => 'ต่ำมาก',
        'low' => 'ต่ำ',
        'normal' => 'ปกติ',
        'high' => 'สูง',
        'very high' => 'สูงมาก',
        '1 very low' => '1 ต่ำมาก',
        '2 low' => '2 ต่ำ',
        '3 normal' => '3 ปกติ',
        '4 high' => '4 สูง',
        '5 very high' => '5 สูงมาก',
        'auto follow up' => 'ติดตามอัตโนมัติ',
        'auto reject' => 'ปฏิเสธอัตโนมัติ',
        'auto remove' => 'ลบออกอัตโนมัติ',
        'auto reply' => 'ตอบกลับอัตโนมัติ',
        'auto reply/new ticket' => 'ตอบกลับอัตโนมัติ/ตั๋วใหม่',
        'Create' => 'สร้าง',
        'Answer' => 'ตอบ',
        'Phone call' => 'สายเข้า',
        'Ticket "%s" created!' => 'สร้างตั๋ว "%s" แล้ว!',
        'Ticket Number' => 'หมายเลขตั๋ว',
        'Ticket Object' => 'ออบเจคตั๋ว',
        'No such Ticket Number "%s"! Can\'t link it!' => 'ไม่มีหมายเลขตั๋วดังกล่าว "% s"! ไม่สามารถเชื่อมโยง!',
        'You don\'t have write access to this ticket.' => 'คุณไม่จำเป็นต้องเขียนการเข้าถึงตั๋วนี้',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'ขออภัยคุณต้องเป็นเจ้าของตั๋วเพื่อดำเนินการ',
        'Please change the owner first.' => 'กรุณาเปลี่ยนผู้เป็นเจ้าของก่อน',
        'Ticket selected.' => 'ตั๋วที่เลือก',
        'Ticket is locked by another agent.' => 'ตั๋วถูกล็อกโดยเอเย่นต์อื่น',
        'Ticket locked.' => 'ตั๋วถูกล็อค',
        'Don\'t show closed Tickets' => 'อย่าแสดงตั๋วที่ปิดแล้ว',
        'Show closed Tickets' => 'แสดงตั๋วที่ปิดแล้ว',
        'New Article' => 'บทความใหม่',
        'Unread article(s) available' => 'บทความยังไม่ได้อ่าน (s)ที่สามารถใช้ได้',
        'Remove from list of watched tickets' => 'ลบออกจากรายการของตั๋วที่ดูแล้ว',
        'Add to list of watched tickets' => 'เพิ่มไปยังรายการของตั๋วที่ดูแล้ว',
        'Email-Ticket' => 'อีเมล์ตั๋ว',
        'Create new Email Ticket' => 'สร้างอีเมล์ตั๋วใหม่',
        'Phone-Ticket' => 'ตั๋วจากโทรศัพท์',
        'Search Tickets' => 'ค้นหาตั๋ว',
        'Customer Realname' => 'ชื่อจริงของลูกค้า',
        'Customer History' => 'ประวัติของลูกค้า',
        'Edit Customer Users' => 'แก้ไขผู้ใช้ลูกค้า',
        'Edit Customer' => 'แก้ไขลูกค้า',
        'Bulk Action' => 'ดำเนินการเป็นกลุ่ม',
        'Bulk Actions on Tickets' => 'ดำเนินการเป็นกลุ่มบนตั๋ว',
        'Send Email and create a new Ticket' => 'ส่งอีเมล์และสร้างตั๋วใหม่',
        'Create new Email Ticket and send this out (Outbound)' => 'สร้างอีเมล์ตั๋วใหม่และส่งออก(Outbound)',
        'Create new Phone Ticket (Inbound)' => 'สร้างตั๋วโทรศัพท์ใหม่ (ขาเข้า)',
        'Address %s replaced with registered customer address.' => 'ที่อยู่% s แทนที่ด้วยที่อยู่ของลูกค้าที่ลงทะเบียน',
        'Customer user automatically added in Cc.' => 'ผู้ใช้ลูกค้าถูกเพิ่มโดยอัตโนมัติใน  Cc',
        'Overview of all open Tickets' => 'ภาพรวมของตั๋วที่เปิดอยู่ทั้งหมด',
        'Locked Tickets' => 'ตั๋วที่ถูกล็อค',
        'My Locked Tickets' => 'ตั๋วที่ถูกล็อคของฉัน',
        'My Watched Tickets' => 'ตั๋วดูแล้วของฉัน',
        'My Responsible Tickets' => 'ตั๋วที่ฉันมีความรับผิดชอบ',
        'Watched Tickets' => 'ตั๋วดูแล้ว',
        'Watched' => 'ดู',
        'Watch' => 'ดู',
        'Unwatch' => 'ยังไม่ได้ดู',
        'Lock it to work on it' => 'ล็อคไว้เพื่อทำงานกับมัน',
        'Unlock to give it back to the queue' => 'ปลดล็อคเพื่อส่งกลับไปที่คิว',
        'Show the ticket history' => 'แสดงประวัติตั๋ว',
        'Print this ticket' => 'พิมพ์ตั๋วนี้',
        'Print this article' => 'พิมพ์บทความนี้',
        'Split' => 'แยก',
        'Split this article' => 'แยกบทความนี้',
        'Forward article via mail' => 'ส่งต่อบทความผ่านทางอีเมล',
        'Change the ticket priority' => 'เปลี่ยนลำดับความสำคัญของตั๋ว',
        'Change the ticket free fields!' => 'เปลี่ยนฟิลด์ตั๋วฟรี!',
        'Link this ticket to other objects' => 'เชื่อมโยงตั๋วนี้เพื่อออบเจคอื่น ๆ',
        'Change the owner for this ticket' => 'เปลี่ยนเจ้าของตั๋วนี้',
        'Change the  customer for this ticket' => 'เปลี่ยนลูกค้าสำหรับตั๋วนี้',
        'Add a note to this ticket' => 'เพิ่มโน้ตไปยังตั๋วนี้',
        'Merge into a different ticket' => 'ผสานเข้ากับตั๋วที่แตกต่างกัน',
        'Set this ticket to pending' => 'เซตตั๋วนี้ในที่รอดำเนินการ',
        'Close this ticket' => 'ปิดตั๋วนี้',
        'Look into a ticket!' => 'มองเข้าไปในตั๋ว!',
        'Delete this ticket' => 'ลบตั๋วนี้',
        'Mark as Spam!' => 'มาร์คว่าเป็นสแปม!',
        'My Queues' => 'คิวของฉัน',
        'Shown Tickets' => 'ตั๋วที่แสดง',
        'Shown Columns' => 'คอลัมน์ที่แสดง',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'อีเมล์ของคุณที่มีหมายเลขตั๋ว "<OTRS_TICKET>" ถูกรวมกับ "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'ตั๋ว% s: หมดเวลาสำหรับตอบสนองครั้งแรก (% s)!',
        'Ticket %s: first response time will be over in %s!' => 'ตั๋ว% s: เวลาตอบสนองครั้งแรกจะหมดเวลาใน% s!',
        'Ticket %s: update time is over (%s)!' => 'ตั๋ว% s: หมดเวลาอัพเดต(%s)!',
        'Ticket %s: update time will be over in %s!' => 'ตั๋ว% s: เวลาอัพเดตจะหมดใน %s!',
        'Ticket %s: solution time is over (%s)!' => 'ตั๋ว% s: หมดเวลาสำหรับการแก้ปัญหา (% s)!',
        'Ticket %s: solution time will be over in %s!' => 'ตั๋ว% s: เวลาการแก้ปัญหาจะจบลงใน (% s)!',
        'There are more escalated tickets!' => 'มีตั๋วที่มีการขยายมากขึ้น!',
        'Plain Format' => 'รูปแบบธรรมดา',
        'Reply All' => 'ตอบกลับทั้งหมด',
        'Direction' => 'ทิศทาง',
        'New ticket notification' => 'การแจ้งเตือนตั๋วใหม่',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'ส่งการแจ้งเตือนหากมีตั๋วใหม่ใน "คิวของฉัน"',
        'Send new ticket notifications' => 'ส่งการแจ้งเตือนตั๋วใหม่',
        'Ticket follow up notification' => 'ตั๋วติดตามการแจ้งเตือน',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'ส่งการแจ้งเตือนหากลูกค้าส่งการติดตามและฉันเป็นเจ้าของตั๋วหรือตั๋วจะถูกปลดล็อกและเป็นหนึ่งในของคิวของฉัน',
        'Send ticket follow up notifications' => 'ส่งการแจ้งเตือนตั๋วติดตาม',
        'Ticket lock timeout notification' => 'การแจ้งเตือนตั๋วล็อคหมดเวลา',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'ส่งการแจ้งเตือนหากตั๋วถูกปลดล็อกโดยระบบ',
        'Send ticket lock timeout notifications' => 'ส่งการแจ้งเตือนตั๋วล็อคหมดเวลา',
        'Ticket move notification' => 'การแจ้งเตือนการย้ายตั๋ว',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'ส่งการแจ้งเตือนหากตั๋วจะถูกย้ายไปเป็นหนึ่งใน "คิวของฉัน"',
        'Send ticket move notifications' => 'ส่งการแจ้งเตือนการย้ายตั๋ว',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'เลือกคิวของคุณจากคิวที่คุณชื่นชอบ นอกจากนี้คุณยังจะได้รับการแจ้งเตือนเกี่ยวกับคิวเหล่านั้นผ่านทางอีเมล์ถ้าเปิดใช้งาน',
        'Custom Queue' => 'คิวที่กำหนดเอง',
        'QueueView refresh time' => 'เวลาการรีเฟรชมุมมองคิว',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'หากเปิดใช้งาน QueueView จะรีเฟรชหลังจากเวลาที่กำหนดโดยอัตโนมัติ',
        'Refresh QueueView after' => 'รีเฟรชมุมมองคิวหลังจาก',
        'Screen after new ticket' => 'หน้าจอหลังจากตั๋วใหม่',
        'Show this screen after I created a new ticket' => 'แสดงหน้าจอนี้หลังจากที่ผมสร้างตั๋วใหม่',
        'Closed Tickets' => 'ตั๋วที่ถูกปิด',
        'Show closed tickets.' => 'แสดงตั๋วที่ถูกปิด',
        'Max. shown Tickets a page in QueueView.' => 'สูงสุด แสดงตั๋วหน้านี้ในมุมมองคิว',
        'Ticket Overview "Small" Limit' => 'ภาพรวมของตั๋วขนาดเล็ก',
        'Ticket limit per page for Ticket Overview "Small"' => 'จำนวนจำกัดของตั๋วต่อหนึ่งหน้าสำหรับภาพรวมตั๋ว "เล็ก ๆ "',
        'Ticket Overview "Medium" Limit' => 'ภาพรวมของตั๋วขนาดกลาง',
        'Ticket limit per page for Ticket Overview "Medium"' => 'จำนวนจำกัดของตั๋วต่อหนึ่งหน้าสำหรับภาพรวมตั๋ว "ขนาดกลาง "',
        'Ticket Overview "Preview" Limit' => 'ภาพรวมของตั๋ว "ดูตัวอย่าง" จำกัด',
        'Ticket limit per page for Ticket Overview "Preview"' => 'จำนวนจำกัดของตั๋วต่อหนึ่งหน้าสำหรับภาพรวมตั๋ว "ดูตัวอย่าง "',
        'Ticket watch notification' => 'การแจ้งเตือนการดูตั๋ว',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'ส่งการแจ้งเตือนเช่นเดียวกันสำหรับตั๋วที่ดูของฉันที่เจ้าของตั๋วจะได้รับ',
        'Send ticket watch notifications' => 'ส่งการแจ้งเตือนการดูตั๋ว',
        'Out Of Office Time' => 'หมดเวลาทำงาน',
        'New Ticket' => 'ตั๋วใหม่',
        'Create new Ticket' => 'สร้างตั๋วใหม่',
        'Customer called' => 'ลูกค้าเรียก',
        'phone call' => 'โทรศัพท์เรียกเข้า',
        'Phone Call Outbound' => 'โทรศัพท์ขาออก',
        'Phone Call Inbound' => 'โทรศัพท์ขาเข้า',
        'Reminder Reached' => 'การแจ้งเตือนถึงแล้ว',
        'Reminder Tickets' => 'ตั๋วการแจ้งเตือน',
        'Escalated Tickets' => 'ตั๋วการขยาย',
        'New Tickets' => 'ตั๋วใหม่',
        'Open Tickets / Need to be answered' => 'ตั๋วที่ถูกเปิด/ ต้องการคำตอบ',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'ตั๋วที่เปิดอยู่ทั้งหมดนี้ได้รับการทำงานแล้วแต่จำเป็นต้องมีตอบสนอง',
        'All new tickets, these tickets have not been worked on yet' => 'ตั๋วใหม่ทั้งหมดเหล่านี้ยังไม่ได้ถูกทำงาน',
        'All escalated tickets' => 'ตั๋วการขยายทั้งหมด',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'ตั๋วทั้งหมดที่มีการตั้งค่าการแจ้งเตือนซึ่งการแจ้งเตือนวันที่ได้รับแล้ว',
        'Archived tickets' => 'ตั๋วที่เก็บถาวร',
        'Unarchived tickets' => 'ตั๋วถาวรที่ถูกยกเลิก',
        'Ticket Information' => 'ข้อมูลของตั๋ว',
        'including subqueues' => 'รวมถึงคิวย่อย',
        'excluding subqueues' => 'ไม่รวมคิวย่อย',

        # Template: AAAWeekDay
        'Sun' => 'อา',
        'Mon' => 'จ',
        'Tue' => 'อ',
        'Wed' => 'พ',
        'Thu' => 'พฤ',
        'Fri' => 'ศ',
        'Sat' => 'ส',

        # Template: AdminACL
        'ACL Management' => 'การจัดการ ACL',
        'Filter for ACLs' => 'ตัวกรองสำหรับ ACLs',
        'Filter' => 'ตัวกรอง',
        'ACL Name' => 'ชื่อ ACL',
        'Actions' => 'การกระทำ',
        'Create New ACL' => 'สร้างACL ใหม่',
        'Deploy ACLs' => 'การปรับใช้ ACLs',
        'Export ACLs' => 'ส่งออก ACL',
        'Configuration import' => 'การกำหนดค่าการนำเข้า',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'คุณสามารถอัปโหลดไฟล์การกำหนดค่าที่จะนำเข้าACLs สู่ในระบบของคุณที่นี่และไฟล์ต้องอยู่ในรูปแบบ .ymlขณะที่ส่งออกโดยโมดูลตัวแก้ไขACL',
        'This field is required.' => 'จำเป็นต้องกรอกข้อมูลในช่องนี้.',
        'Overwrite existing ACLs?' => 'เขียนทับ ACLs ที่มีอยู่?',
        'Upload ACL configuration' => 'อัปโหลดการกำหนดค่า ACL',
        'Import ACL configuration(s)' => 'นำเข้าการกำหนดค่า ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'เพื่อสร้างACLใหม่คุณสามารถสร้างโดยนำเข้าACLsที่ถูกส่งเข้ามาจากระบบอื่นหรือสร้างใหม่',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'การเปลี่ยนแปลง ACLs ที่นี่จะส่งผลกระทบต่อการทำงานของระบบเท่านั้น ถ้าหากคุณปรับใช้ข้อมูล ACL ในภายหลัง จะทำให้การเปลี่ยนแปลครั้งใหม่นั้นถูกเขียนที่การกำหนดค่าเนื่องการปรับใช้ข้อมูล ACL',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'โปรดทราบ: ตารางนี้แสดงถึงลำดับการดำเนินการของ ACLsถ้าคุณต้องการที่จะเปลี่ยนลำดับดำเนินการของ ACLs โปรดเปลี่ยนชื่อ ACLs ที่ ได้รับผลกระทบ',
        'ACL name' => 'ชื่อ ACL',
        'Validity' => 'ความถูกต้อง',
        'Copy' => 'คัดลอก',
        'No data found.' => 'ไม่พบข้อมูล.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'แก้ไข ACL %s',
        'Go to overview' => 'ไปที่ภาพรวม',
        'Delete ACL' => 'ลบACL',
        'Delete Invalid ACL' => 'ลบ ACL ที่ใช้ไม่ได้',
        'Match settings' => 'การตั้งค่าการจับคู่',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'กำหนดหลักเกณฑ์การจับคู่สำหรับ ACL นี้ ใช้ \'Properties\' เพื่อให้ตรงกับหน้าจอปัจจุบันหรือ \'PropertiesDatabase\' เพื่อให้ตรงกับคุณลักษณะของตั๋วในปัจจุบันที่อยู่ในฐานข้อมูล',
        'Change settings' => 'เปลี่ยนการตั้งค่า',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'ตั้งค่าสิ่งที่คุณต้องการที่จะเปลี่ยนแปลงถ้าหากตรงตามเกณฑ์ โปรดจำไว้ว่า \'Possible\' เป็นรายการที่อนุญาต \'PossibleNo\' คือแบล็คลิสต์',
        'Check the official' => 'ตรวจสอบที่เป็นทางการ',
        'documentation' => 'เอกสาร',
        'Show or hide the content' => 'แสดงหรือซ่อนเนื้อหา',
        'Edit ACL information' => 'แก้ไขข้อมูล ACL',
        'Stop after match' => 'หยุดหลังจากจับคู่แล้ว',
        'Edit ACL structure' => 'แก้ไขโครงสร้างACL ',
        'Save ACL' => '',
        'Save' => 'บันทึก',
        'or' => 'หรือ',
        'Save and finish' => 'บันทึกและเสร็จสิ้น',
        'Do you really want to delete this ACL?' => 'คุณต้องการลบ ACL นี้หรือไม่?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'รายการนี้ยังคงประกอบด้วยรายการย่อย คุณแน่ใจหรือไม่ว่าคุณต้องการลบรายการนี้ซึ่งรวมถึงรายการย่อย?',
        'An item with this name is already present.' => 'ไอเท็มที่ใช้ชื่อนี้ได้ถูกนำเสนอแล้ว',
        'Add all' => 'เพิ่มทั้งหมด',
        'There was an error reading the ACL data.' => 'มีข้อผิดพลาดการอ่านข้อมูล ACL',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'สร้าง ACL ใหม่โดยการส่งข้อมูลแบบฟอร์ม หลังจากที่สร้าง ACLคุณจะสามารถเพิ่มรายการการตั้งค่าในโหมดแก้ไข',

        # Template: AdminAttachment
        'Attachment Management' => 'การจัดการสิ่งที่แนบมา',
        'Add attachment' => 'เพิ่มสิ่งที่แนบมา',
        'List' => 'ลิสต์',
        'Download file' => 'ดาวน์โหลดไฟล์',
        'Delete this attachment' => 'ลบสิ่งที่แนบมานี้',
        'Do you really want to delete this attachment?' => '',
        'Add Attachment' => 'เพิ่มเอกสารแนบ',
        'Edit Attachment' => 'แก้ไขสิ่งที่แนบมา',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'การจัดการการตอบสนองอัตโนมัติ',
        'Add auto response' => 'เพิ่มการตอบสนองอัตโนมัติ',
        'Add Auto Response' => 'เพิ่มการตอบสนองอัตโนมัติ',
        'Edit Auto Response' => 'แก้ไขการตอบสนองอัตโนมัติ',
        'Response' => 'ตอบสนอง',
        'Auto response from' => 'การตอบสนองอัตโนมัติจาก',
        'Reference' => 'อ้างอิง',
        'You can use the following tags' => 'คุณสามารถใช้แท็กต่อไปนี้',
        'To get the first 20 character of the subject.' => 'เพื่อให้ได้20 ตัวอักษรแรกของเนื้อเรื่อง',
        'To get the first 5 lines of the email.' => 'เพื่อให้ได้5 บรรทัดแรกของอีเมล',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'เพื่อให้ได้คุณลักษณะของบทความ',
        ' e. g.' => 'ตัวอย่างเช่น',
        'Options of the current customer user data' => 'ตัวเลือกของลูกค้าผู้ใช้ข้อมูลในปัจจุบัน',
        'Ticket owner options' => 'ตัวเลือกเจ้าของตั๋ว',
        'Ticket responsible options' => 'ตัวเลือกผู้รับผิดชอบตั๋ว',
        'Options of the current user who requested this action' => 'ตัวเลือกของผู้ใช้ปัจจุบันที่ร้องขอการกระทำนี้',
        'Options of the ticket data' => 'ตัวเลือกของข้อมูลของตั๋ว',
        'Options of ticket dynamic fields internal key values' => 'ตัวเลือกของช่องตั๋วแบบไดนามิกค่าคีย์ภายใน',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'ตัวเลือกของช่องตั๋วแบบไดนามิกที่แสดงค่าที่มีประโยชน์สำหรับDropdownและช่องสำหรับเลือกหลายรายการ',
        'Config options' => 'ตัวเลือกการกำหนดค่า',
        'Example response' => 'ตัวอย่างการตอบสนอง',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'การจัดการบริการระบบคลาวด์',
        'Support Data Collector' => 'สนับสนุนการเก็บรวบรวมข้อมูล',
        'Support data collector' => 'สนับสนุนการเก็บรวบรวมข้อมูล',
        'Hint' => 'คำแนะนำ',
        'Currently support data is only shown in this system.' => 'ข้อมูลสนับสนุนตอนนี้จะแสดงเฉพาะในระบบนี้',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'ขอแนะนำให้ส่งข้อมูลนี้ไปยังกลุ่มOTRS เพื่อให้ได้รับการสนับสนุนที่ดีขึ้น',
        'Configuration' => 'การกำหนดค่าการ',
        'Send support data' => 'ส่งข้อมูลการสนับสนุน',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'ซึ่งจะช่วยให้ระบบสามารถส่งข้อมูลการสนับสนุนเพิ่มเติมไปยังกลุ่มOTRS',
        'System Registration' => 'ระบบการลงทะเบียน',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'เพื่อเปิดใช้งานการส่งข้อมูลกรุณาลงทะเบียนระบบของคุณกับกลุ่มOTRSหรืออัปเดตข้อมูลการลงทะเบียนระบบของคุณ (ต้องแน่ใจว่าได้เปิดใช้งาน \'ตัวเลือกการส่งข้อมูลสนับสนุน\'.)',
        'Register this System' => 'ลงทะเบียนระบบนี้',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'ระบบการลงทะเบียนถูกปิดใช้งานสำหรับระบบของคุณ กรุณาตรวจสอบการตั้งค่าของคุณ',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'ระบบการลงทะเบียนคือหนึ่งในการบริการของ OTRS ซึ่งมีประโยชน์มาก!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'โปรดทราบว่าการใช้บริการคลาวด์ของ OTRSต้องใช้ระบบที่จะถูกลงทะเบียน',
        'Register this system' => 'ลงทะเบียนระบบนี้',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'คุณสามารถกำหนดค่าการบริการคลาวด์ที่สามารถใช้ได้ที่นี่ซึ่งสามารถสื่อสารอย่างปลอดภัยกับ% s',
        'Available Cloud Services' => 'การบริการระบบคลาวด์ที่สามารถใช้ได้',
        'Upgrade to %s' => 'อัพเกรดเป็น% s',

        # Template: AdminCustomerCompany
        'Customer Management' => 'การจัดการลูกค้า',
        'Wildcards like \'*\' are allowed.' => 'สัญลักษณ์เช่น \'*\' ได้รับอนุญาต',
        'Add customer' => 'เพิ่มลูกค้า',
        'Select' => 'เลือก',
        'List (only %s shown - more available)' => '',
        'List (%s total)' => '',
        'Please enter a search term to look for customers.' => 'กรุณากรอกคำค้นหาที่จะค้นหาลูกค้า',
        'Add Customer' => 'เพิ่มลูกค้า',

        # Template: AdminCustomerUser
        'Customer User Management' => 'การจัดการลูกค้าผู้ใช้',
        'Back to search results' => 'กลับไปยังผลการค้นหา',
        'Add customer user' => 'เพิ่มลูกค้าผู้ใช้',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'ลูกค้าผู้ใช้จำเป็นต้องมีประวัติลูกค้าและเข้าสู่ระบบผ่านทางแผงของลูกค้า',
        'Last Login' => 'เข้าระบบครั้งสุดท้าย',
        'Login as' => 'เข้าระบบเป็น',
        'Switch to customer' => 'เปลี่ยนเป็นลูกค้า',
        'Add Customer User' => 'เพิ่มลูกค้าผู้ใช้',
        'Edit Customer User' => 'แก้ไขลูกค้าผู้ใช้',
        'This field is required and needs to be a valid email address.' =>
            'ข้อมูลนี้จำเป็นและต้องป็นที่อยู่อีเมลที่ถูกต้อง',
        'This email address is not allowed due to the system configuration.' =>
            'อีเมลนี้จะไม่ได้รับอนุญาตเนื่องจากการกำหนดค่าระบบ',
        'This email address failed MX check.' => 'อีเมลนี้ล้มเหลวในการตรวจสอบ MX',
        'DNS problem, please check your configuration and the error log.' =>
            'ปัญหา DNS โปรดตรวจสอบการตั้งค่าและล็อกข้อผิดพลาดของคุณ',
        'The syntax of this email address is incorrect.' => 'รูปแบบของที่อยู่อีเมลนี้ไม่ถูกต้อง',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'จัดการความสัมพันธ์กับกลุ่มลูกค้า',
        'Notice' => 'การแจ้งให้ทราบ',
        'This feature is disabled!' => 'ฟีเจอร์นี้จะถูกปิดใช้งาน!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'เพียงแค่ใช้ฟีเจอร์นี้ถ้าคุณต้องการที่จะกำหนดสิทธิ์ของกลุ่มสำหรับลูกค้า',
        'Enable it here!' => 'เปิดใช้งานได้ที่นี่!',
        'Edit Customer Default Groups' => 'แก้ไขกลุ่มลูกค้าเริ่มต้น',
        'These groups are automatically assigned to all customers.' => 'กลุ่มเหล่านี้จะถูกกำหนดอัตโนมัติไปยังลูกค้าทุกท่าน',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'คุณสามารถจัดการกลุ่มคนเหล่านี้ผ่านการตั้งค่าการกำหนดรูปแบบ "CustomerGroupAlwaysGroups"',
        'Filter for Groups' => 'ตัวกรองสำหรับกลุ่มต่างๆ',
        'Just start typing to filter...' => 'แค่เริ่มต้นการพิมพ์เพื่อกรอง ...',
        'Select the customer:group permissions.' => 'เลือกลูกค้า: สิทธิ์ของกลุ่ม',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'หากไม่มีอะไรถูกเลือกแล้วจะไม่มีสิทธิ์ในกลุ่มนี้ (ตั๋วจะไม่สามารถใช้ได้สำหรับลูกค้า)',
        'Search Results' => 'ผลการค้นหา',
        'Customers' => 'ลูกค้า',
        'No matches found.' => 'ไม่พบคู่',
        'Groups' => 'กลุ่ม',
        'Change Group Relations for Customer' => 'เปลี่ยนกลุ่มความสัมพันธ์ระหว่างลูกค้า',
        'Change Customer Relations for Group' => 'เปลี่ยนความสัมพันธ์ของลูกค้าสำหรับกลุ่ม',
        'Toggle %s Permission for all' => 'สลับ %s การอนุญาตทั้งหมด',
        'Toggle %s permission for %s' => 'สลับ %s การอนุญาตสำหรับ %s',
        'Customer Default Groups:' => 'กลุ่มลูกค้าเริ่มต้น:',
        'No changes can be made to these groups.' => 'ไม่มีการเปลี่ยนแปลงใหนที่สามารถทำเพื่อกลุ่มเหล่านี้',
        'ro' => 'แถว',
        'Read only access to the ticket in this group/queue.' => 'ตั๋วในกลุ่ม/คิวนี้ สามารถอ่านเท่านั้น',
        'rw' => 'แถว',
        'Full read and write access to the tickets in this group/queue.' =>
            'ตั๋วในกลุ่ม/คิวนี้ สามารถอ่านและเขียน',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'การจัดการความสัมพันธ์ระหว่างลูกค้าและการบริการ',
        'Edit default services' => 'แก้ไขการบริการเริ่มต้น',
        'Filter for Services' => 'ตัวกรองสำหรับการบริการ',
        'Allocate Services to Customer' => 'จัดสรรการให้บริการแก่ลูกค้า',
        'Allocate Customers to Service' => 'จัดสรรลูกค้าให้การบริการ',
        'Toggle active state for all' => 'สลับสถานะการทำงานทั้งหมด',
        'Active' => 'ใช้งาน',
        'Toggle active state for %s' => 'สลับสถานะการทำงานสำหรับ %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'การจัดการDynamic Fields ',
        'Add new field for object' => 'เพิ่มฟิลด์ใหม่สำหรับออบเจค',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'ในการเพิ่มช่องข้อมูลใหม่ โปรดเลือกชนิดของช่องข้อมูลจากรายการของออบเจคและออบเจคจะกําหนดขอบเขตของช่องข้อมูลและมันไม่สามารถเปลี่ยนแปลงได้หลังจากการสร้างแล้ว',
        'Dynamic Fields List' => 'รายการไดมานิคฟิลด์',
        'Dynamic fields per page' => 'ไดมานิคฟิลด์แต่ละหน้า',
        'Label' => 'ฉลาก',
        'Order' => 'ลำดับ',
        'Object' => 'ออบเจค',
        'Delete this field' => 'ลบฟิลด์นี้',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'คุณแน่ใจหรือไม่ที่จะลบไดมานิคฟิลด์นี้? ข้อมูลที่เกี่ยวข้องทั้งหมดจะหายไป!',
        'Delete field' => 'ลบฟิลด์',
        'Deleting the field and its data. This may take a while...' => 'การลบฟิลด์และข้อมูล อาจจะใช้เวลาสักครู่ ...',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'ไดมานิคฟิลด์',
        'Field' => 'ฟิลด์',
        'Go back to overview' => 'กลับไปที่ภาพรวม',
        'General' => 'ทั่วไป',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'จำเป็นต้องกรอกข้อมูลในช่องนี้และข้อมูลในช่องนี้ควรจะเป็นตัวอักษรและตัวเลขเท่านั้น',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'ต้องเป็นชื่อเฉพาะ และเป็นตัวหนังสือและตัวเลขเท่านั่น',
        'Changing this value will require manual changes in the system.' =>
            'การเปลี่ยนค่านี้จะต้องมีการเปลี่ยนแปลงด้วยตนเองในระบบ',
        'This is the name to be shown on the screens where the field is active.' =>
            'นี่คือชื่อที่จะแสดงบนหน้าจอที่ฟิลด์มีการใช้งาน',
        'Field order' => 'ลำดับของฟิลด์',
        'This field is required and must be numeric.' => 'ข้อมูลนี้จำเป็นต้องมีและต้องเป็นตัวเลข',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'นี่คือลำดับที่จะแสดงบนหน้าจอที่ฟิลด์มีการใช้งาน',
        'Field type' => 'ประเภทของฟิลด์',
        'Object type' => 'ประเภทของออบเจค',
        'Internal field' => 'ฟิลด์ภายใน',
        'This field is protected and can\'t be deleted.' => 'ข้อมูลนี้มีการป้องกันและไม่สามารถลบได้',
        'Field Settings' => 'การตั้งค่าฟิลด์',
        'Default value' => 'ค่าเริ่มต้น',
        'This is the default value for this field.' => 'นี่คือค่าเริ่มต้นสำหรับข้อมูลนี้',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'วันที่เริ่มต้นที่แตกต่างกัน',
        'This field must be numeric.' => 'ข้อมูลนี้ต้องเป็นตัวเลข',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'ความแตกต่างจากตอนนี้ (ในวินาที) ในการคำนวณค่าเริ่มต้นของฟิลด์ (เช่น 3600 หรือ -60)',
        'Define years period' => 'กำหนดระยะเวลา',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'เปิดใช้งานคุณสมบัตินี้เพื่อกำหนดช่วงคงที่ของปีต่างๆ (ในอนาคตและในอดีต) ที่จะแสดงในช่องของปี',
        'Years in the past' => 'ปีที่ผ่านมา',
        'Years in the past to display (default: 5 years).' => 'ปีที่ผ่านมาที่จะแสดง (ค่าเริ่มต้น: 5 ปี)',
        'Years in the future' => 'ปีถัดไป',
        'Years in the future to display (default: 5 years).' => 'ปีถัดไปที่จะแสดง (ค่าเริ่มต้น: 5 ปี)',
        'Show link' => 'แสดงลิงค์',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'คุณสามารถระบุตัวเลือกการเชื่อมโยง HTTPที่นี่ สำหรับข้อมูลในภาพรวมและหน้าจอซูม',
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'Restrict entering of dates' => 'จำกัดการป้อนวันที่',
        'Here you can restrict the entering of dates of tickets.' => 'คุณสามารถจำกัดการป้อนวันที่ของตั๋วที่นี่',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'ค่าที่เป็นไปได้',
        'Key' => 'คีย์',
        'Value' => 'ค่า',
        'Remove value' => 'ลบค่า',
        'Add value' => 'เพิ่มค่า',
        'Add Value' => 'เพิ่มค่า',
        'Add empty value' => 'เพิ่มค่าว่างเปล่า',
        'Activate this option to create an empty selectable value.' => 'ปิดใช้งานตัวเลือกนี้เพื่อสร้างค่าว่างเปล่าที่สามารถเลือกได้',
        'Tree View' => 'มุมมองแผนภูมิ',
        'Activate this option to display values as a tree.' => 'เปิดใช้งานตัวเลือกนี้เพื่อแสดงค่าเป็น tree',
        'Translatable values' => 'ค่าที่สามารถแปล',
        'If you activate this option the values will be translated to the user defined language.' =>
            'ถ้าคุณเปิดใช้งานตัวเลือกนี้ค่าจะถูกแปลเป็นภาษาที่ผู้ใช้กำหนด',
        'Note' => 'โน้ต',
        'You need to add the translations manually into the language translation files.' =>
            'คุณจำเป็นต้องเพิ่มการแปลภาษาด้วยตนเองลงในไฟล์การแปล',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'จำนวนแถว',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'ระบุความสูง (ในบรรทัด) สำหรับข้อมูลนี้ในโหมดการแก้ไข',
        'Number of cols' => 'จำนวนคอลัมน์',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'ระบุความกว้าง (ในตัวอักษร) สำหรับข้อมูลนี้ในโหมดการแก้ไข',
        'Check RegEx' => 'ตรวจสอบRegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'ที่นี่คุณสามารถระบุการแสดงผลปกติเพื่อตรวจสอบค่าและregex จะถูกดำเนินการด้วยการปรับเปลี่ยน XMS',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'RegEx ที่ใช้ไม่ได้',
        'Error Message' => 'ข้อความผิดพลาด',
        'Add RegEx' => 'เพิ่มRegEx',

        # Template: AdminEmail
        'Admin Notification' => 'ผู้ดูแลการแจ้งเตือน',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'ด้วยโมดูลนี้ผู้ดูแลระบบสามารถส่งข้อความไปยังตัวแทน กลุ่มหรือสมาชิกบทบาท',
        'Create Administrative Message' => 'สร้างข้อความการดูแลระบบ',
        'Your message was sent to' => 'ข้อความของคุณถูกส่งไปยัง',
        'Send message to users' => 'ส่งข้อความไปยังผู้ใช้',
        'Send message to group members' => 'ส่งข้อความไปยังสมาชิกในกลุ่ม',
        'Group members need to have permission' => 'สมาชิกในกลุ่มต้องได้รับอนุญาต',
        'Send message to role members' => 'ส่งข้อความไปยังสมาชิกบทบาท',
        'Also send to customers in groups' => 'และยังส่งให้กับลูกค้าในกลุ่ม',
        'Body' => 'เนื้อหา',
        'Send' => 'ส่ง',

        # Template: AdminGenericAgent
        'Generic Agent' => 'เอเย่นต์ทั่วไป',
        'Add job' => 'เพิ่มงาน',
        'Last run' => 'การทำงานที่ผ่านมา',
        'Run Now!' => 'รันตอนนี้!',
        'Delete this task' => 'ลบงานนี้',
        'Run this task' => 'รันงานนี้',
        'Do you really want to delete this task?' => '',
        'Job Settings' => 'การตั้งค่าการทำงาน',
        'Job name' => 'ชื่องาน',
        'The name you entered already exists.' => 'ชื่อที่คุณป้อนมีอยู่แล้ว',
        'Toggle this widget' => 'สลับเครื่องมือนี้',
        'Automatic execution (multiple tickets)' => 'การดำเนินการอัตโนมัติ (ตั๋วหลายใบ)',
        'Execution Schedule' => 'ตารางเวลาการดำเนินการ',
        'Schedule minutes' => 'ตารางนาที',
        'Schedule hours' => 'ตารางชั่วโมง',
        'Schedule days' => 'ตารางวัน',
        'Currently this generic agent job will not run automatically.' =>
            'ขณะนี้เอเย่นต์งานงานทั่วไปจะไม่ทำงานโดยอัตโนมัติ',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'เพื่อเปิดใช้งานการดำเนินการแบบอัตโนมัติเลือกอย่างน้อยหนึ่งค่าจากนาทีชั่วโมงและวัน!',
        'Event based execution (single ticket)' => 'การดำเนินการตามกิจกรรม (ตั๋วใบเดียว)',
        'Event Triggers' => 'ตัวกระตุ้นกิจกรรม',
        'List of all configured events' => 'รายการของกิจกรรมที่มีการกำหนดค่าทั้งหมด',
        'Delete this event' => 'ลบอีเว้นท์นี้',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'นอกจากนี้หรืออีกทางเลือกหนึ่งเพื่อให้การดำเนินการเป็นระยะๆ คุณสามารถกำหนดตั๋วกิจกรรมที่จะส่งสัญญาณให้งานนี้',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'หากตั๋วกิจกรรมถูกยกเลิก ตัวกรองตั๋วจะถูกนำมาใช้เพื่อตรวจสอบว่าตรงกับตั๋ว แล้วงานจะรันบนตั๋วที่ว่า',
        'Do you really want to delete this event trigger?' => 'คุณต้องการลบตัวกระตุ้นกิจกรรมนี้หรือไม่?',
        'Add Event Trigger' => 'เพิ่มตัวกระตุ้นกิจกรรม',
        'Add Event' => 'เพิ่มกิจกรรม',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'ในการเพิ่มกิจกรรมใหม่เลือกออปเจ็กต์กิจกรรมและชื่อกิจกรรมและคลิกที่ปุ่ม "+"',
        'Duplicate event.' => 'กิจกรรมที่ซ้ำกัน',
        'This event is already attached to the job, Please use a different one.' =>
            'กิจกรรมนี้แนบมากับงานเป็นที่เรียบร้อยแล้ว โปรดใช้กิจกรรมอื่นแทน',
        'Delete this Event Trigger' => 'ลบกระตุ้นกิจกรรมนี้',
        'Remove selection' => 'ลบการคัดเลือก',
        'Select Tickets' => 'เลือกตั๋ว',
        '(e. g. 10*5155 or 105658*)' => '(เช่น 10*5155 หรือ 105658*)',
        '(e. g. 234321)' => '(เช่น  234321)',
        'Customer user' => 'ลูกค้าผู้ใช้',
        '(e. g. U5150)' => '(เช่น U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'ค้นหาแบบฉบับเต็มในบทความ (เช่น "Mar*in" หรือ "Baue*")',
        'Agent' => 'เอเย่นต์',
        'Ticket lock' => 'ตั๋วล็อค',
        'Create times' => 'เวลาที่สร้าง',
        'No create time settings.' => 'ไม่มีการตั้งค่าเวลาที่สร้าง',
        'Ticket created' => 'ตั๋วที่สร้างขึ้น',
        'Ticket created between' => 'ตั๋วถูกสร้างขึ้นระหว่าง',
        'Last changed times' => 'เวลาการเปลี่ยนแปลงครั้งล่าสุด',
        'No last changed time settings.' => 'ไม่มีการตั้งค่าเวลาการเปลี่ยนแปลงครั้งล่าสุด',
        'Ticket last changed' => 'การเปลี่ยนแปลงตั๋วล่าสุด',
        'Ticket last changed between' => 'ตั๋วเปลี่ยนแปลงล่าสุดระหว่าง',
        'Change times' => 'เวลาที่เปลี่ยนแปลง',
        'No change time settings.' => 'ไม่มีการตั้งค่าเวลาการเปลี่ยนแปลง',
        'Ticket changed' => 'ตั๋วถูกเปลี่ยนแปลง',
        'Ticket changed between' => 'ตั๋วถูกเปลี่ยนแปลงระหว่าง',
        'Close times' => 'เวลาที่ปิด',
        'No close time settings.' => 'ไม่มีการตั้งค่าเวลาที่ปิด',
        'Ticket closed' => 'ตั๋วถูกปิด',
        'Ticket closed between' => 'ตั๋วถูกปิดในระหว่าง',
        'Pending times' => 'เวลาที่รอดำเนินการ',
        'No pending time settings.' => 'ไม่มีการตั้งค่าเวลาที่รอดำเนินการ',
        'Ticket pending time reached' => 'ตั๋วที่รอเวลาดำเนินการมาถึงแล้ว',
        'Ticket pending time reached between' => 'ตั๋วที่รอเวลาดำเนินการมาถึงในระหว่าง',
        'Escalation times' => 'เวลาการขยาย',
        'No escalation time settings.' => 'ไม่มีการตั้งค่าเวลาการขยาย',
        'Ticket escalation time reached' => 'ตั๋วการขยายเวลามาถึง',
        'Ticket escalation time reached between' => 'ตั๋วการขยายเวลามาถึงในระหว่าง',
        'Escalation - first response time' => 'การขยาย - เวลาที่ตอบสนองครั้งแรก',
        'Ticket first response time reached' => 'เวลาที่ตอบสนองตั๋วครั้งแรกมาถึงแล้ว',
        'Ticket first response time reached between' => 'ตั๋วของเวลาที่ตอบสนองครั้งแรกมาถึงในระหว่าง',
        'Escalation - update time' => 'การขยาย - เวลาการปรับปรุง',
        'Ticket update time reached' => 'ตํ๋วของเวลาการปรับปรุงมาถึงแล้ว',
        'Ticket update time reached between' => 'ตํ๋วของเวลาการปรับปรุงมาถึงในเวลา',
        'Escalation - solution time' => 'การขยาย - เวลาการแก้ปัญหา',
        'Ticket solution time reached' => 'ตั๋วของเวลาการแก้ปัญหามาถึงแล้ว',
        'Ticket solution time reached between' => 'ตั๋วของเวลาการแก้ปัญหามาถึงในระหว่าง',
        'Archive search option' => 'ตัวเลือกการค้นหาหน่วยเก็บถาวร',
        'Update/Add Ticket Attributes' => 'ปรับปรุง/เพิ่มแอตทริบิวต์ของตั๋ว',
        'Set new service' => 'กำหนดการบริการใหม่',
        'Set new Service Level Agreement' => 'ระบุข้อตกลงระดับบริการใหม่',
        'Set new priority' => 'กำหนดลำดับความสำคัญใหม่',
        'Set new queue' => 'กำหนดคิวใหม่',
        'Set new state' => 'กำหนดสถานภาพใหม่',
        'Pending date' => 'วันที่รอดำเนินการ',
        'Set new agent' => 'กำหนดเอเย่นต์ใหม่',
        'new owner' => 'เจ้าของใหม่',
        'new responsible' => 'ผู้รับผิดชอบใหม่',
        'Set new ticket lock' => 'กำหนดตั๋วล็อคใหม่',
        'New customer user' => 'ลูกค้าผู้ใช้ใหม่',
        'New customer ID' => 'ไอดีลูกค้าใหม่',
        'New title' => 'หัวข้อใหม่',
        'New type' => 'ประเภทใหม่',
        'New Dynamic Field Values' => 'ค่าไดนามิกฟิลด์ใหม่ ',
        'Archive selected tickets' => 'การเก็บถาวรของตั๋วที่ถูกเลือก',
        'Add Note' => 'เพิ่มโน้ต',
        'This field must have less then 200 characters.' => '',
        'Time units' => 'หน่วยเวลา',
        'Execute Ticket Commands' => 'คำสั่งดำเนินการตั๋ว',
        'Send agent/customer notifications on changes' => 'ส่งการแจ้งเตือนเกี่ยวกับการเปลี่ยนแปลงไปยัง เอเย่นต์/ ลูกค้า',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'คำสั่งนี้จะถูกดำเนินการ ARG [0]จะเป็นหมายเลขตั๋ว ARG [1]ID ของตั๋ว',
        'Delete tickets' => 'ลบตั๋ว',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'คำเตือน: ตั๋วที่ได้รับผลกระทบทั้งหมดจะถูกลบออกจากฐานข้อมูลและไม่สามารถเรียกคืน!',
        'Execute Custom Module' => 'ดำเนินการโมดูลที่กำหนดเอง',
        'Param %s key' => 'กุญแจสำคัญของพารามิเตอร์ %s ',
        'Param %s value' => 'ค่าพารามิเตอร์ %s',
        'Save Changes' => 'บันทึกการเปลี่ยนแปลง',
        'Results' => 'ผลลัพธ์',
        '%s Tickets affected! What do you want to do?' => 'ตั๋ว s% ได้รับผลกระทบ! คุณต้องการจะทำอะไร?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'คำเตือน: คุณใช้ตัวเลือกลบ ตั๋วที่ถูกลบทั้งหมดจะหายไป!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'คำเตือน: มีตั๋ว% s ได้รับผลกระทบ แต่ s% เท่านั้นที่อาจมีการเปลี่ยนแปลงในระหว่างการดำเนินงานหนึ่ง!',
        'Edit job' => 'แก้ไขงาน',
        'Run job' => 'รันงาน',
        'Affected Tickets' => 'ตั๋วที่ได้รับผลกระทบ',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'อินเตอร์เฟซทั่วไปของการดีบักสำหรับ Web Service %s',
        'You are here' => 'คุณอยู่ที่นี่',
        'Web Services' => 'Web Services',
        'Debugger' => 'การดีบัก',
        'Go back to web service' => 'กลับไปWeb Services',
        'Clear' => 'ล้าง',
        'Do you really want to clear the debug log of this web service?' =>
            'คุณต้องการที่จะยกเลิกการบันทึกของการแก้ปัญหาของweb serviceนี้หรือไม่?',
        'Request List' => 'ลิสต์การร้องขอ',
        'Time' => 'เวลา',
        'Remote IP' => 'รีโมท IP',
        'Loading' => 'กำลังโหลด',
        'Select a single request to see its details.' => 'เลือกคำขอเดียวเพื่อดูรายละเอียด',
        'Filter by type' => 'กรองตามประเภท',
        'Filter from' => 'กรองจากการ',
        'Filter to' => 'กรองเพื่อ',
        'Filter by remote IP' => 'กรองตามremote IP',
        'Limit' => 'ขีดจำกัด',
        'Refresh' => 'รีเฟรช',
        'Request Details' => 'รายละเอียดการร้องขอ',
        'An error occurred during communication.' => 'เกิดข้อผิดพลาดในระหว่างการสื่อสาร',
        'Show or hide the content.' => 'แสดงหรือซ่อนเนื้อหา',
        'Clear debug log' => 'ยกเลิกการบันทึกการแก้ปัญหา',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'เพิ่มผู้ร้องขอไปยัง Web Service %s',
        'Change Invoker %s of Web Service %s' => 'เปลี่ยนผู้ร้องขอ%s ของ Web Service %s',
        'Add new invoker' => 'เพิ่มผู้ร้องขอใหม่',
        'Change invoker %s' => 'เปลี่ยนผู้ร้องขอ %s',
        'Do you really want to delete this invoker?' => 'คุณต้องการลบผู้ร้องขอนี้หรือไม่?',
        'All configuration data will be lost.' => 'ข้อมูลการกำหนดค่าทั้งหมดจะหายไป',
        'Invoker Details' => 'รายละเอียดของผู้ร้องขอ',
        'The name is typically used to call up an operation of a remote web service.' =>
            'โดยปกติจะใช้ชื่อนี้เพื่อเรียกการทำงานของweb serviceจากระยะไกล',
        'Please provide a unique name for this web service invoker.' => 'โปรดระบุชื่อที่ไม่ซ้ำกันสำหรับผู้ร้องขอweb service นี้',
        'Invoker backend' => 'ผู้ร้องขอเบื้องหลัง',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'โมดูลผู้ร้องขอเบื้องหลังของOTRSนี้จะถูกเรียกเพื่อเตรียมข้อมูลที่จะส่งไปยังระบบระยะไกลและเพื่อประมวลผลข้อมูลการตอบสนอง',
        'Mapping for outgoing request data' => 'แผนที่สำหรับข้อมูลการร้องขอขาออก',
        'Configure' => 'การกำหนดค่า',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'ข้อมูลจากผู้ร้องขอของOTRS  จะถูกดำเนินการจากแผนที่นี้เพื่อเปลี่ยนมันไปเป็นประเภทของข้อมูลที่คาดว่าเป็นระบบจากระยะไกล',
        'Mapping for incoming response data' => 'แผนที่สำหรับข้อมูลการตอบสนองที่เข้ามา',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'ข้อมูลการตอบสนองจะถูกประมวลผลโดยแผนที่นี้เพื่อเปลี่ยนมันไปเป็นข้อมูลผู้ร้องขอตามการคาดการของ OTRS ',
        'Asynchronous' => 'ไม่ตรงกัน',
        'This invoker will be triggered by the configured events.' => 'ผู้ร้องขอนี้จะถูกกำหนดโดยกิจกรรมที่ถูกกำหนดไว้',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'ตัวกระตุ้นกิจกรรมที่ไม่ตรงกันจะถูกจัดการโดย OTRS Scheduler Daemon ในเบื้องหลัง (แนะนำ)',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'ตัวกระต้นกิจกรรมที่ตรงกันจะถูกประมวลผลโดยตรงในระหว่างการร้องขอเว็บ',
        'Save and continue' => 'บันทึกและดำเนินการต่อไป',
        'Delete this Invoker' => 'ลบผู้ร้องขอนี้',
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'อินเตอร์เฟซทั่วไปของการทำแผนที่อย่างง่ายสำหรับ Web Service %s',
        'Go back to' => 'กลับไปยัง',
        'Mapping Simple' => 'การทำแผนที่อย่างง่าย',
        'Default rule for unmapped keys' => 'กฎเริ่มต้นสำหรับคีย์ของการยกเลิกแผนที่',
        'This rule will apply for all keys with no mapping rule.' => 'กฎนี้จะนำไปใช้สำหรับคีย์ทั้งหมดที่ไม่มีกฎการทำแผนที่',
        'Default rule for unmapped values' => 'กฎเริ่มต้นสำหรับค่าของการยกเลิกแผนที่',
        'This rule will apply for all values with no mapping rule.' => 'กฎนี้จะนำไปใช้สำหรับค่าทั้งหมดที่ไม่มีกฎการทำแผนที่',
        'New key map' => 'คีย์ใหม่ของแผนที่',
        'Add key mapping' => 'เพิ่มคีย์ของการทำแผนที่',
        'Mapping for Key ' => 'ทำแผนที่สำหรับคีย์',
        'Remove key mapping' => 'ลบคีย์ของการทำแผนที่',
        'Key mapping' => 'คีย์ของการทำแผนที่',
        'Map key' => 'คีย์ของแผนที่',
        'matching the' => 'ตรงกับ',
        'to new key' => 'เพื่อคีย์ใหม่',
        'Value mapping' => 'ค่าของการทำแผนที่',
        'Map value' => 'ค่าแผ่นที่',
        'to new value' => 'เพื่อค่าใหม่',
        'Remove value mapping' => 'ลบค่าของการทำแผนที่',
        'New value map' => 'ค่าแผนที่ใหม่',
        'Add value mapping' => 'เพิ่มค่าของการทำแผนที่',
        'Do you really want to delete this key mapping?' => 'คุณต้องการลบคีย์ของการทำแผนที่นี้หรือไม่?',
        'Delete this Key Mapping' => 'ลบคีย์ของการทำแผนที่นี้',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => 'อินเตอร์เฟซทั่วไปของการทำแผนที่ XSLT สำหรับ Web Service %s',
        'Mapping XML' => 'การทำแผนที่ XML',
        'Template' => 'แม่แบบ',
        'The entered data is not a valid XSLT stylesheet.' => 'ข้อมูลที่ป้อนไม่ใช่สไตล์ XSLT ที่ถูกต้อง',
        'Insert XSLT stylesheet.' => 'แทรก XSLT stylesheet.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'เพิ่มการดำเนินงานใหม่ไปยัง Web Service %s',
        'Change Operation %s of Web Service %s' => 'เปลี่ยนการดำเนินงานของ Web Service %s',
        'Add new operation' => 'เพิ่มการดำเนินงานใหม่',
        'Change operation %s' => 'เปลี่ยนการดำเนินงาน %s',
        'Do you really want to delete this operation?' => 'คุณต้องการที่จะลบการดำเนินการนี้หรือไม่?',
        'Operation Details' => 'รายละเอียดการดำเนินงาน',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'โดยปกติจะใช้ชื่อนี้เพื่อเรียกการทำงานของweb serviceนี้จากระยะไกล',
        'Please provide a unique name for this web service.' => 'โปรดระบุชื่อที่ไม่ซ้ำกันสำหรับweb service นี้',
        'Mapping for incoming request data' => 'แผนที่สำหรับข้อมูลการร้องขอขาเข้า',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'ข้อมูลการร้องขอจะถูกประมวลผลโดยแผนที่นี้เพื่อเปลี่ยนมันไปเป็นข้อมูลตามการคาดการของ OTRS',
        'Operation backend' => 'การดำเนินงานเบื้องหลัง',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'โมดูลผู้ร้องขอเบื้องหลังของOTRSนี้จะถูกเรียกจากภายในเพื่อเพื่อดำเนินการตามคำขอและสร้างข้อมูลสำหรับการตอบสนอง',
        'Mapping for outgoing response data' => 'แผนที่สำหรับข้อมูลการตอบสนองที่ส่งออก',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'ข้อมูลการตอบสนองจะถูกประมวลผลโดยแผนที่นี้เพื่อเปลี่ยนมันไปเป็นข้อมูลการคาดการของระบบระยะไกล',
        'Delete this Operation' => 'ลบการดำเนินการนี้',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'อินเตอร์เฟซทั่วไปของการขนส่ง HTTP ::RESTสำหรับ Web Service %s',
        'Network transport' => 'เครือข่ายการขนส่ง',
        'Properties' => 'คุณสมบัติ',
        'Route mapping for Operation' => 'การทำแผนที่เส้นทางสำหรับการดำเนินงาน',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'กำหนดเส้นทางที่ควรจะได้รับแผนที่เพื่อไปยังการดำเนินการนี้ ตัวแปรถูกทำเครื่องหมายด้วย \':\' จะได้รับการชี้นำไปยังชื่อที่ถูกป้อนและผ่านไปพร้อมกับอื่น ๆ ในการทำแผนที่ (เช่น / ตั๋ว /: TicketID)',
        'Valid request methods for Operation' => 'วิธีการที่ร้องขอที่ถูกต้องสำหรับการดำเนินการ',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'จำกัดการดำเนินการนี้เพื่อเจาะจงวิธีการร้องขอหากไม่มีวิธีการใดถูกเลือก คำขอทั้งหมดจะได้รับการยอมรับ',
        'Maximum message length' => 'ความยาวสูงสุดของข้อความ',
        'This field should be an integer number.' => 'ข้อมูลในช่องนี้ควรจะเป็นตัวเลข',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'คุณสามารถระบุขนาดสูงสุด(ไบต์)ของข้อความREST ที่นี่ว่าOTRS จะดำเนินการ',
        'Send Keep-Alive' => 'ส่ง Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'การกำหนดค่านี้ถูกกำหนดไว้ถ้าการติดต่อเข้ามาควรจะได้รับการปิดหรือคงถูกรักษาไว้',
        'Host' => 'โฮสต์',
        'Remote host URL for the REST requests.' => 'URL โฮสต์ระยะไกลสำหรับการร้องขอREST',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'เช่น https://www.otrs.com:10745/api/v1.0 (โดยไม่ต้องต่อท้ายด้วยเครื่องหมาย backslash)',
        'Controller mapping for Invoker' => 'ตัวควบคุมการทำแผนที่สำหรับผู้ร้องขอ',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'ตัวควบคุมที่ผู้ร้องขอควรส่งการร้องขอไป ตัวแปรถูกทำเครื่องหมายด้วย \':\' จะได้รับการแทนที่ด้วยค่าข้อมูลและผ่านไปตามคำขอต่อไป (เช่น / ตั๋ว /: TicketID UserLogin =: UserLogin&Password =: รหัสผ่าน)',
        'Valid request command for Invoker' => 'คำสั่งคำขอที่ถูกต้องสำหรับผู้ร้องขอ',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'คำสั่ง HTTP ที่เฉพาะเจาะจงที่จะใช้สำหรับการร้องขอด้วย Invoker นี้ (ถ้ามี)',
        'Default command' => 'คำสั่งเริ่มต้น',
        'The default HTTP command to use for the requests.' => 'คำสั่ง HTTP เริ่มต้นที่จะใช้สำหรับการร้องขอ',
        'Authentication' => 'การรับรองความถูกต้อง',
        'The authentication mechanism to access the remote system.' => 'กลไกการรับรองความถูกต้องในการเข้าถึงระบบรีโมต',
        'A "-" value means no authentication.' => 'เครื่องหมาย  "-" หมายถึงไม่มีการตรวจสอบสิทธิ์',
        'The user name to be used to access the remote system.' => 'ชื่อผู้ใช้ที่จะใช้ในการเข้าถึงระบบรีโมต',
        'The password for the privileged user.' => 'รหัสผ่านสำหรับผู้ใช้ที่ได้รับสิทธิพิเศษ',
        'Use SSL Options' => 'ใช้ตัวเลือก SSL',
        'Show or hide SSL options to connect to the remote system.' => 'แสดงหรือซ่อนตัวเลือก SSL เพื่อเชื่อมต่อกับระบบรีโมต',
        'Certificate File' => 'ไฟล์หนังสือรับรอง',
        'The full path and name of the SSL certificate file.' => 'เส้นทางฉบับเต็มและชื่อของไฟล์ใบรับรอง SSL',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'เช่น. /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'ใบรับรองไฟล์รหัสผ่าน',
        'The full path and name of the SSL key file.' => 'เส้นทางฉบับเต็มและชื่อของไฟล์คีย์ SSL',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'เช่น  /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'ไฟล์ผู้ออกใบรับรอง (CA)',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'เส้นทางแบบเต็มและชื่อของผู้มีอำนาจในการรับรองไฟล์ใบรับรองเพื่อตรวจใบรับรอง SSL',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'เช่น /opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'อินเตอร์เฟซทั่วไปของการขนส่ง HTTP::SOAPสำหรับ Web Service %s',
        'Endpoint' => 'จุดสิ้นสุด',
        'URI to indicate a specific location for accessing a service.' =>
            'URI เพื่อบ่งชี้ถึงสถานที่ที่ระบุในการเข้าถึงการบริการ',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'เช่น. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'พื้นที่ชื่อ',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI ที่จะให้วิธีการ SOAPตามบริบทจะช่วยลดความคลุมเครือ',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'เช่น  urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'ร้องขอรูปแบบชื่อ',
        'Select how SOAP request function wrapper should be constructed.' =>
            'เลือกวิธีที่ SOAP ร้องขอฟังก์ชั่นการห่อหุ้มที่ควรจะสร้าง',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' ถูกนำมาใช้เป็นตัวอย่างที่เกิดขึ้นจริงสำหรับInvoker / ชื่อการดำเนินงาน',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FREETEXT\' ถูกนำมาใช้เป็นตัวอย่างสำหรับค่าการกำหนดค่าที่แท้จริง',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'ข้อความที่จะนำมาใช้เพื่อเป็นชื่อต่อท้ายหรือทดแทนฟังก์ชั่นการห่อหุ้ม',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'โปรดพิจารณาข้อจำกัดการตั้งชื่อองค์ประกอบ XML (เช่นไม่ใช้ \'<\' และ \'&\')',
        'Response name scheme' => 'รูปแบบชื่อการตอบสนอง',
        'Select how SOAP response function wrapper should be constructed.' =>
            'เลือกวิธีที่ SOAP ตอบสนองฟังก์ชั่นการห่อหุ้มที่ควรจะสร้าง',
        'Response name free text' => 'ชื่อการตอบสนองข้อความฟรี',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'คุณสามารถระบุขนาดสูงสุด(ไบต์)ของข้อความSOAP ที่OTRS จะดำเนินการที่นี้',
        'Encoding' => 'การเข้ารหัส',
        'The character encoding for the SOAP message contents.' => 'การเข้ารหัสตัวอักษรสำหรับเนื้อหาของข้อความ SOAP',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'เช่น. UTF-8, latin1, ISO-8859-1, CP1250 ฯลฯ',
        'SOAPAction' => 'SOAPAction',
        'Set to "Yes" to send a filled SOAPAction header.' => 'ตั้งค่า "ใช่" เพื่อส่งหัวข้อSOAPAction ที่กรอกแล้ว
 ',
        'Set to "No" to send an empty SOAPAction header.' => 'ตั้งค่า "ไม่" เพื่อส่งหัวข้อSOAPAction ที่ว่างเปล่า',
        'SOAPAction separator' => 'ตัวคั่น SOAPAction',
        'Character to use as separator between name space and SOAP method.' =>
            'ตัวอักษรที่จะใช้เป็นตัวคั่นระหว่างพื้นที่ชื่อและวิธีการSOAP',
        'Usually .Net web services uses a "/" as separator.' => 'โดยปกติ.Net web services ใช้ "/" เป็นตัวคั่น',
        'Proxy Server' => 'เซิร์ฟเวอร์สำรอง',
        'URI of a proxy server to be used (if needed).' => 'URI ของเซิร์ฟเวอร์สำรองที่จะใช้ (ถ้าจำเป็น)',
        'e.g. http://proxy_hostname:8080' => 'เช่น. http: // proxy_hostname: 8080',
        'Proxy User' => 'ผู้ใช้สำรอง',
        'The user name to be used to access the proxy server.' => 'ชื่อผู้ใช้ที่จะใช้ในการเข้าถึงเซิร์ฟเวอร์สำรอง',
        'Proxy Password' => 'รหัสผ่านสำรอง',
        'The password for the proxy user.' => 'รหัสผ่านสำหรับตัวแทนผู้ใช้งาน',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'เส้นทางฉบับเต็มและชื่อของไฟล์ใบรับรอง SSL (ต้องอยู่ในรูปแบบ .p12)',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'เช่น /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'รหัสผ่านเพื่อเปิดใบรับรอง SSL',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'เส้นทางแบบเต็มและชื่อของผู้มีอำนาจในการรับรองไฟล์ใบรับรองเพื่อตรวจใบรับรอง SSL',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'เช่น /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'สารบบผู้ออกใบรับรอง (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'เส้นทางแบบเต็มของไดเรกทอรีผู้มีสิทธิ์ออกใบรับรองซึ่งใบรับรองCAจะถูกเก็บไว้ในระบบไฟล์',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'เช่น /opt/otrs/var/certificates/SOAP/CA',
        'Sort options' => 'ตัวเลือกการจัดเรียง',
        'Add new first level element' => 'เพิ่มองค์ประกอบขั้นแรกใหม่',
        'Element' => 'องค์ประกอบ',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'ลำดับการจัดเรียงขาออกสำหรับฟิลด์ XML (เริ่มต้นโครงสร้างข้างล่างฟังก์ชั่นการห่อหุ้ม) - ดูเอกสารสำหรับการขนส่งSOAP',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'อินเตอร์เฟซทั่วไปของการจัดการ Web Service',
        'Add web service' => 'เพิ่ม web service',
        'Clone web service' => 'โคลนนิ่ง web service',
        'The name must be unique.' => 'ชื่อต้องไม่ซ้ำกัน.',
        'Clone' => 'โคลนนิ่ง',
        'Export web service' => 'ส่งออก web service',
        'Import web service' => 'นำเข้า web service',
        'Configuration File' => 'ไฟล์การกำหนดค่า',
        'The file must be a valid web service configuration YAML file.' =>
            'ไฟล์ดังกล่าวจะต้องเป็นไฟล์การกำหนดค่าYAML web serviceที่ถูกต้อง',
        'Import' => 'นำเข้า',
        'Configuration history' => 'ประวัติของการกำหนดค่า',
        'Delete web service' => 'ลบ web service',
        'Do you really want to delete this web service?' => 'คุณต้องการลบweb serviceนี้หรือไม่?',
        'Ready-to-run Web Services' => '',
        'Here you can activate ready-to-run web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import ready-to-run web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated ready-to-run web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'หลังจากที่คุณบันทึกการตั้งค่าคุณจะถูกเปลี่ยนเส้นทางไปยังหน้าจอการแก้ไขอีกครั้ง',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'ถ้าคุณต้องการที่จะกลับไปที่ภาพรวมโปรดคลิกที่ปุ่ม "ไปที่ภาพรวม"',
        'Web Service List' => 'รายการ Web Service',
        'Remote system' => 'ระบบระยะไกล',
        'Provider transport' => 'ขนส่งผู้ให้บริการ',
        'Requester transport' => 'การขนส่งผู้ร้องขอ',
        'Debug threshold' => 'เกณฑ์การแก้ปัญหา',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'ในโหมดผู้ให้บริการ OTRS เสนอบริการเว็บที่ใช้โดยระบบทางไกล',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'ในโหมดการร้องขอ, OTRSใช้บริการเว็บของระบบทางไกล',
        'Operations are individual system functions which remote systems can request.' =>
            'การดำเนินงานเป็นระบบการทำงานของแต่ละบุคคลซึ่งระบบระยะไกลสามารถร้องขอ',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'ผู้ร้องขอเตรียมข้อมูลสำหรับการร้องขอไปยังการบริการเว็บระยะไกลและการประมวลผลข้อมูลการตอบสนอง',
        'Controller' => 'ตัวควบคุม',
        'Inbound mapping' => 'การทำแผนที่ขาเข้า',
        'Outbound mapping' => 'การทำแผนที่ขาออก',
        'Delete this action' => 'ลบการกระทำนี้',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'อย่างน้อย% s มีการควบคุมที่ไม่ได้ใช้งานหรือไม่มีการนำเสนอโปรดตรวจสอบการลงทะเบียนตัวควบคุมหรือลบออก% s',
        'Delete webservice' => 'ลบ webservice',
        'Delete operation' => 'ลบการดำเนินการ',
        'Delete invoker' => 'ลบผู้ร้องขอ',
        'Clone webservice' => 'โคลนนิ่ง web service',
        'Import webservice' => 'นำเข้า web service',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'อินเตอร์เฟซทั่วไปของประวัติการกำหนดค่าสำหรับ Web Service %s',
        'Go back to Web Service' => 'กลับไปยัง Web Services',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'คุณสามารถดูเวอร์ชั่นเก่าของเว็บกำหนดค่าบริการในปัจจุบัน การส่งออกหรือแม้กระทั่งการนำกลับมาใช้ใหม่ได้ที่นี่',
        'Configuration History List' => 'รายการประวัติของการกำหนดค่า',
        'Version' => 'เวอร์ชั่น',
        'Create time' => 'เวลาที่สร้าง',
        'Select a single configuration version to see its details.' => 'เลือกเวอร์ชั่นการกำหนดค่าเพื่อดูรายละเอียด',
        'Export web service configuration' => 'ส่งออกการกำหนดค่า web service',
        'Restore web service configuration' => 'เรียกคืนการกำหนดค่า web service',
        'Do you really want to restore this version of the web service configuration?' =>
            'คุณต้องการที่จะเรียกคืนเวอร์ชันเรียกคืนการกำหนดค่า web serviceนี้หรือไม่?',
        'Your current web service configuration will be overwritten.' => 'การกำหนดค่าweb service ปัจจุบันของคุณจะถูกเขียนทับ',
        'Restore' => 'การเรียกคืน',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'คำเตือน: เมื่อคุณเปลี่ยนชื่อของกลุ่ม \'ผู้ดูแลระบบ\' ก่อนที่จะทำการเปลี่ยนแปลงที่เหมาะสมใน sysconfig คุณจะถูกล็อคออกจากแผงการดูแลระบบ!หากเกิดเหตุการณ์นี้กรุณาเปลี่ยนชื่อกลุ่มกลับไปเป็นผู้ดูแลระบบต่อหนึ่งคำสั่ง SQL',
        'Group Management' => 'การจัดการกลุ่ม',
        'Add Group' => 'เพิ่มกลุ่ม',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'กลุ่มผู้ดูแลระบบจะได้รับการเข้าไปในพื้นที่ของแอดมินและกลุ่มสถิติจะได้รับพื้นที่สถิติ',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'สร้างกลุ่มใหม่เพื่อจัดการสิทธิ์การเข้าถึงสำหรับกลุ่มที่แตกต่างกันของเอเย่นต์ (เช่นฝ่ายจัดซื้อ, ฝ่ายสนับสนุนฝ่ายขาย, ... )',
        'It\'s useful for ASP solutions. ' => 'ซึ่งจะมีประโยชน์สำหรับการแก้ปัญหา ASP',
        'total' => 'ผลรวม',
        'Edit Group' => 'แก้ไขกลุ่ม',

        # Template: AdminLog
        'System Log' => 'ระบบ Log',
        'Here you will find log information about your system.' => 'คุณจะพบข้อมูลเกี่ยวกับการเข้าสู่ระบบในระบบของคุณที่นี่',
        'Hide this message' => 'ซ่อนข้อความนี้',
        'Recent Log Entries' => 'รายการการเข้าสู่ระบบล่าสุด',

        # Template: AdminMailAccount
        'Mail Account Management' => 'การจัดการบัญชีเมล',
        'Add mail account' => 'เพิ่มบัญชีอีเมล',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'อีเมลขาเข้าทั้งหมดที่มีบัญชีเดียวจะถูกส่งไปอยู่ในคิวที่เลือก!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'หากบัญชีของคุณเชื่อถือได้, ส่วนหัวของ X-OTRS ที่มีอยู่แล้วในช่วงเวลาที่มาถึง (สำหรับลำดับความสำคัญ ... )จะถูกนำไปใช้! ตัวกรองpostmasterจะนำไปใช้ต่อไป',
        'Delete account' => 'ลบบัญชี',
        'Fetch mail' => 'การดึงข้อมูลอีเมล',
        'Add Mail Account' => 'เพิ่มบัญชีอีเมล',
        'Example: mail.example.com' => 'ตัวอย่าง: mail.example.com',
        'IMAP Folder' => 'โฟลเดอร์ IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'ปรับเปลี่ยนแค่นี้ถ้าคุณต้องการที่จะดึงอีเมลจากโฟลเดอร์ที่แตกต่างจากINBOX',
        'Trusted' => 'ที่น่าเชื่อถือ',
        'Dispatching' => 'ส่งออกไปยังปลายทาง',
        'Edit Mail Account' => 'แก้ไขบัญชีเมล',

        # Template: AdminNavigationBar
        'Admin' => 'ผู้ดูแลระบบ',
        'Agent Management' => 'การจัดการเอเย่นต์',
        'Queue Settings' => 'การตั้งค่าคิว',
        'Ticket Settings' => 'การตั้งค่าตั๋ว',
        'System Administration' => 'การบริหารระบบ',
        'Online Admin Manual' => 'คู่มือการใช้งานของผู้ดูแลระบบออนไลน์',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'การจัดการการแจ้งเตือนตั๋ว',
        'Add notification' => 'เพิ่มการแจ้งเตือน',
        'Export Notifications' => 'ส่งออกการแจ้งเตือน',
        'Configuration Import' => 'การกำหนดค่าการนำเข้า',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'คุณสามารถอัปโหลดไฟล์การกำหนดค่าที่จะนำการแจ้งเตือนตั๋วเข้าสู่ระบบของคุณที่นี่และไฟล์ต้องอยู่ในรูปแบบ .ymlขณะที่ส่งออกโดยโมดูลการแจ้งเตือนตั๋ว',
        'Overwrite existing notifications?' => 'เขียนทับการแจ้งเตือนที่มีอยู่?',
        'Upload Notification configuration' => 'อัปโหลดการตั้งค่าการแจ้งเตือน',
        'Import Notification configuration' => 'นำเข้าการตั้งค่าการแจ้งเตือน',
        'Delete this notification' => 'ลบการแจ้งเตือนนี้',
        'Do you really want to delete this notification?' => 'คุณต้องการที่จะลบการแจ้งเตือนนี้หรือไม่?',
        'Add Notification' => 'เพิ่มการแจ้งเตือน',
        'Edit Notification' => 'แก้ไขการแจ้งเตือน',
        'Show in agent preferences' => 'แสดงในการตั้งค่าเอเย่นต์',
        'Agent preferences tooltip' => 'คำแนะนำการตั้งค่าเอเย่นต์',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'ข้อความนี้จะแสดงบนหน้าจอการตั้งค่าเอเย่นต์เพื่อเป็นคำแนะนำสำหรับการแจ้งเตือนนี้',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'คุณสามารถเลือกกิจกรรมที่จะกระตุ้นประกาศนี้ที่นี่ ตัวกรองตั๋วเพิ่มเติมสามารถนำมาใช้เพียงเพื่อส่งค่าตั๋วกับเกณฑ์ที่แน่นอน',
        'Ticket Filter' => 'ตัวกรองตั๋ว',
        'Article Filter' => 'ตัวกรองบทความ',
        'Only for ArticleCreate and ArticleSend event' => 'เฉพาะ ArticleCreate และกิจกรรม ArticleSend',
        'Article type' => 'ประเภทของบทความ',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'หาก ArticleCreate หรือ ArticleSend ใช้เป็นตัวกรุตุ้นกิจกรรมคุณจะต้องระบุตัวกรองบทความเช่นกัน โปรดเลือกอย่างน้อยหนึ่งฟิลด์ตัวกรองบทความ',
        'Article sender type' => 'ประเภทผู้ส่งบทความ',
        'Subject match' => 'ชื่อเรื่องตรงกัน',
        'Body match' => 'เนื้อเรื่องตรงกัน',
        'Include attachments to notification' => 'แนบเอกสารไปยังการแจ้งเตือน',
        'Recipients' => 'ผู้รับ',
        'Send to' => 'ส่งถึง',
        'Send to these agents' => 'ส่งให้เอเย่นต์เหล่านี้',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => 'ส่งให้กับสมาชิกที่มีบทบาททั้งหมด',
        'Send on out of office' => 'ส่งออกจากสำนักงาน',
        'Also send if the user is currently out of office.' => 'ส่งเช่นกันหากผู้ใช้ปัจจุบันอยู่นอกออฟฟิศ',
        'Once per day' => 'วันละครั้ง',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'แจ้งให้ผู้ใช้เพียงครั้งเดียวต่อวันเกี่ยวกับตั๋วเพียงใบเดียวโดยใช้การขนส่งที่คุณเลือก',
        'Notification Methods' => 'วิธีการแจ้งเตือน',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'นี่คือวิธีการที่เป็นไปได้ที่สามารถนำมาใช้ในการส่งการแจ้งเตือนนี้ให้กับผู้รับแต่ละคน กรุณาเลือกวิธีการอย่างน้อยหนึ่งวิธีการดังต่อไปนี้',
        'Enable this notification method' => 'เปิดใช้งานวิธีการแจ้งเตือนนี้',
        'Transport' => 'ขนส่ง',
        'At least one method is needed per notification.' => 'ความจำเป็นใช้อย่างน้อยหนึ่งวิธีการต่อหนึ่งการแจ้งเตือน',
        'Active by default in agent preferences' => 'ใช้งานโดยค่าเริ่มต้นในการตั้งค่าเอเย่นต์',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'นี้เป็นค่าเริ่มต้นสำหรับตัวแทนผู้รับมอบหมายที่ไม่ได้เลือกสำหรับการแจ้งเตือนนี้ในการตั้งค่าของพวกเขา ถ้ากล่องถูกเปิดใช้งานการแจ้งเตือนจะถูกส่งให้กับตัวแทนดังกล่าว',
        'This feature is currently not available.' => 'ฟีเจอร์นี้ไม่สามารถใช้งานได้ในขณะนี้',
        'No data found' => 'ไม่พบข้อมูล',
        'No notification method found.' => 'ไม่พบวิธีการแจ้งเตือน',
        'Notification Text' => 'ข้อความแจ้งเตือน',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'ภาษานี้ไม่ถูกเสนอหรือเปิดใช้งานในระบบ ข้อความแจ้งเตือนนี้อาจถูกลบออกหากไม่มีความจำเป็นอีกต่อไป',
        'Remove Notification Language' => 'ลบภาษาของการแจ้งเตือน',
        'Message body' => 'เนื้อหาของข้อความ',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Add new notification language' => 'เพิ่มภาษาใหม่ของการแจ้งเตือน',
        'Do you really want to delete this notification language?' => 'คุณต้องการที่จะลบภาษาของการแจ้งเตือนนี้หรือไม่?',
        'Tag Reference' => 'แท็กข้อมูลอ้างอิง',
        'Notifications are sent to an agent or a customer.' => 'การแจ้งเตือนจะถูกส่งไปยังเอเย่นต์หรือลูกค้า',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'เพื่อให้ได้20 ตัวอักษรแรกของเนื้อเรื่อง(จากบทความเอเย่นต์ล่าสุด) ',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'เพื่อให้ได้5 บรรทัดแรกของเนื้อหา(จากบทความเอเย่นต์ล่าสุด) ',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'เพื่อให้ได้20 ตัวอักษรแรกของเนื้อเรื่อง(จากบทความลูกค้าล่าสุด) ',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'เพื่อให้ได้5 บรรทัดแรกของเนื้อหา(จากบทความลูกค้าล่าสุด) ',
        'Attributes of the current customer user data' => 'คุณลักษณะของข้อมูลลูกค้าผู้ใช้ปัจจุบัน',
        'Attributes of the current ticket owner user data' => 'คุณลักษณะของข้อมูลผู้ใช้เจ้าของตั๋วปัจจุบัน',
        'Attributes of the current ticket responsible user data' => 'คุณลักษณะของข้อมูลผู้ใช้ที่ดูแลตั๋วปัจจุบัน',
        'Attributes of the current agent user who requested this action' =>
            'คุณลักษณะของผู้ใช้เอเย่นต์ปัจจุบันที่ร้องขอการดำเนินการนี้',
        'Attributes of the recipient user for the notification' => 'คุณลักษณะของผู้ใช้ผู้รับสำหรับการแจ้งเตือน',
        'Attributes of the ticket data' => 'คุณลักษณะของข้อมูลตั๋ว',
        'Ticket dynamic fields internal key values' => 'ค่าคีย์ภายในช่องตั๋วแบบไดนามิก',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'ช่องตั๋วแบบไดนามิกแสดงค่าที่มีประโยชน์สำหรับDropdownและช่องสำหรับเลือกหลายรายการ',
        'Example notification' => 'ตัวอย่างการแจ้งเตือน',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'ที่อยู่อีเมลของผู้รับเพิ่มเติม',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',
        'Notification article type' => 'ประเภทบทความการแจ้งเตือน',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'บทความที่จะถูกสร้างขึ้นหากการแจ้งเตือนถูกส่งให้กับลูกค้าหรือที่อยู่อีเมลเพิ่มเติม',
        'Email template' => 'แม่แบบของอีเมล์',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'ใช้รูปแบบนี้เพื่อสร้างอีเมลที่สมบูรณ์ (เฉพาะอีเมล HTML)',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'จัดการ% s',
        'Go to the OTRS customer portal' => '',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'อ่านเอกสาร',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s ทำการติดต่อเป็นประจำกับ cloud.otrs.comเพื่อตรวจสอบการปรับปรุงที่มีและความถูกต้องของสัญญาพื้นฐาน',
        'Unauthorized Usage Detected' => 'ตรวจพบการใช้งานที่ไม่ได้รับอนุญาต',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'ระบบนี้ใช้ %s โดยไม่มีใบอนุญาตที่ถูกต้อง! กรุณาโทรติดต่อกับ %s เพื่อต่ออายุหรือเปิดใช้งานสัญญาของคุณ!',
        '%s not Correctly Installed' => '%s ไม่ได้ติดตั้งอย่างถูกต้อง',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '%s ของคุณไม่ได้ติดตั้งอย่างถูกต้อง โปรดติดตั้งด้วยปุ่มด้านล่าง',
        'Reinstall %s' => 'การติดตั้งใหม่% s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '%s ของคุณไม่ได้ติดตั้งอย่างถูกต้องและยังมีการปรับปรุงที่พร้อมใช้งานอีกด้วย',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'คุณสามารถติดตั้งเวอร์ชันปัจจุบันของคุณหรือดำเนินการอัพเดตด้วยปุ่มด้านล่างดังกล่าว (แนะนำให้ทำการอัพเดต)',
        'Update %s' => 'อัพเดท% s',
        '%s Not Yet Available' => '% s ยังไม่สามารถใช้ได้',
        '%s will be available soon.' => '% s จะพร้อมใช้งานเร็ว ๆ นี้',
        '%s Update Available' => '%s การอัปเดตที่พร้อมใช้งาน',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => '',
        'To install the current version of OTRS Business Solution™, you need to update to OTRS %s or higher.' =>
            '',
        'To install the current version of OTRS Business Solution™, the Maximum OTRS Version is %s.' =>
            '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            'การอัปเดตสำหรับ% s ของคุณพร้อมใช้งาน โปรดอัปเดตโดยเร็วที่สุด!',
        '%s Correctly Deployed' => '%s ถูกนำไปใช้อย่างถูกต้อง',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'ขอแสดงความยินดี %s ของคุณมีการติดตั้งอย่างถูกต้องและเป็นเวอร์ชั่นล่าสุด',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '%s จะสามารถใช้ได้ในเร็ว ๆ นี้ กรุณาตรวจสอบอีกครั้งภายในไม่กี่วันนี้',
        'Please have a look at %s for more information.' => 'โปรดดูได้ที่ %s สำหรับข้อมูลเพิ่มเติม',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'ก่อนที่คุณจะสามารถได้รับประโยชน์จาก %s กรุณาติดต่อ %s เพื่อรับสัญญาของคุณ %s',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'การเชื่อมต่อกับ cloud.otrs.com ผ่าน HTTPS ไม่สามารถยืนยันได โปรดตรวจสอบว่า OTRSของคุณคุณสามารถเชื่อมต่อกับ cloud.otrs.com ผ่านทางพอร์ต443',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'With your existing contract you can only use a small part of the %s.' =>
            'ด้วยสัญญาที่มีอยู่ของคุณคุณสามารถใช้ส่วนเล็ก ๆ ของ %s',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'ถ้าคุณต้องการที่จะรับประโยชน์สูงสุดจาก %s อัพเกรดสัญญาของคุณตอนนี้! ติดต่อ% s',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'ยกเลิกการดาวน์เกรดแล้วย้อนกลับ',
        'Go to OTRS Package Manager' => 'ไปยังตัวจัดการแพคเกจ OTRS ',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'ขออภัยขณะนี้คุณไม่สามารถดาวน์เกรดเนื่องจากการแพคเกจดังต่อไปนี้ซึ่งขึ้นอยู่กับ %s:',
        'Vendor' => 'ผู้จำหน่าย',
        'Please uninstall the packages first using the package manager and try again.' =>
            'โปรดถอนการติดตั้งแพคเกจแรกโดยใช้ตัวจัดการแพคเกจและลองอีกครั้ง',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'แชท',
        'Report Generator' => 'ตัวสร้างรายงาน',
        'Timeline view in ticket zoom' => 'มุมมองเส้นเวลาในการซูมตั๋ว',
        'DynamicField ContactWithData' => 'ฟิลด์แบบไดนามิค ติดต่อกับข้อมูล',
        'DynamicField Database' => 'ฟิลด์แบบไดนามิค ฐานข้อมูล',
        'SLA Selection Dialog' => 'SLA การเลือกไดอะล็อก',
        'Ticket Attachment View' => 'มุมมองตั๋วที่มีเอกสารแนบ',
        'The %s skin' => 'สกิน %s',

        # Template: AdminPGP
        'PGP Management' => 'การจัดการ PGP',
        'PGP support is disabled' => 'การสนับสนุน PGP จะถูกปิดใช้งาน',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'เพื่อให้สามารถใช้ PGP ใน OTRS คุณต้องเปิดการใช้งานก่อน',
        'Enable PGP support' => 'เปิดใช้การสนับสนุน PGP',
        'Faulty PGP configuration' => 'การกำหนดค่า PGP ผิดพลาด',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'เปิดใช้งานการสนับสนุน PGP แล้วแต่การกำหนดค่าที่เกี่ยวข้องมีข้อผิดพลาด กรุณาตรวจสอบการตั้งค่าโดยใช้ปุ่มด้านล่าง',
        'Configure it here!' => 'กำหนดค่าได้ที่นี่!',
        'Check PGP configuration' => 'ตรวจสอบการตั้งค่า PHP',
        'Add PGP key' => 'เพิ่มคีย์ PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'ด้วยวิธีนี้คุณสามารถแก้ไขการคีย์การกำหนดค่าใน sysconfigได้โดยตรง',
        'Introduction to PGP' => 'ข้อมูลเบื้องต้นเกี่ยวกับ PGP',
        'Result' => 'ผลลัพธ์',
        'Identifier' => 'ตัวบ่งชี้',
        'Bit' => 'บิต',
        'Fingerprint' => 'ลายนิ้วมือ',
        'Expires' => 'หมดอายุ',
        'Delete this key' => 'ลบคีย์นี้',
        'Add PGP Key' => 'เพิ่มคีย์ PGP',
        'PGP key' => 'คีย์ PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'ตัวจัดการแพคเกจ',
        'Uninstall package' => 'ยกเลิกการติดตั้งแพคเกจ',
        'Do you really want to uninstall this package?' => 'คุณต้องการยกเลิกการติดตั้งแพคเกจนี้หรือไม่?',
        'Reinstall package' => 'ติดตั้งแพคเกจอีกครั้ง',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'คุณต้องการติดตั้งแพคเกจนี้อีกครั้งหรือไม่? การเปลี่ยนแปลงด้วยตนเองจะหายไป',
        'Go to updating instructions' => '',
        'package information' => '',
        'Package installation requires a patch level update of OTRS.' => '',
        'Package update requires a patch level update of OTRS.' => '',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '',
        'Please note that your installed OTRS version is %s.' => '',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            '',
        'This package can only be installed on OTRS version %s or older.' =>
            '',
        'This package can only be installed on OTRS version %s or newer.' =>
            '',
        'You will receive updates for all other relevant OTRS issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            'ในกรณีที่คุณมีคำถามอื่นๆเรายินดีที่จะตอบคำถามเหล่านั้น',
        'Continue' => 'ดำเนินการต่อ',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'กรุณาตรวจสอบให้แน่ใจว่าฐานข้อมูลของคุณรับขนาดแพคเกจมากกว่า %s MB  (ขณะนี้สามารถยอมรับเฉพาะแพคเกจที่มีขนาดถึง %s MB) กรุณาปรับตั้งค่า max_allowed_packet ของฐานข้อมูลของคุณเพื่อหลีกเลี่ยงข้อผิดพลาด',
        'Install' => 'ติดตั้ง',
        'Install Package' => 'ติดตั้งแพคเกจ',
        'Update repository information' => 'อัปเดตข้อมูลของพื้นที่เก็บข้อมูล',
        'Cloud services are currently disabled.' => 'บริการคลาวด์ถูกปิดการใช้งานในขณะนี้',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™ ไม่สามารถดำเนินการต่อไป!',
        'Enable cloud services' => 'เปิดใช้บริการคลาวด์',
        'Online Repository' => 'พื้นที่เก็บข้อมูลออนไลน์',
        'Module documentation' => 'เอกสารของโมดูล',
        'Upgrade' => 'อัพเกรด',
        'Local Repository' => 'พื้นที่เก็บข้อมูลท้องถิ่น',
        'This package is verified by OTRSverify (tm)' => 'แพคเกจนี้ถูกตรวจสอบโดยOTRSverify (tm)',
        'Uninstall' => 'ยกเลิกการติดตั้ง',
        'Reinstall' => 'ติดตั้งใหม่',
        'Features for %s customers only' => 'ฟีเจอร์สำหรับลูกค้า% เท่านั้น',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'ด้วย %s คุณสามารถได้รับประโยชน์จากคุณสมบัติเสริมต่อไปนี้ กรุณาติดต่อกับ% s ถ้าคุณต้องการข้อมูลเพิ่มเติม',
        'Download package' => 'ดาวน์โหลดแพคเกจ',
        'Rebuild package' => 'สร้างแพคเกจอีกครั้ง',
        'Metadata' => 'ข้อมูลเมต้า',
        'Change Log' => 'เปลี่ยนแปลงการเข้าสู่ระบบ',
        'Date' => 'วัน',
        'List of Files' => 'รายการไฟล์',
        'Permission' => 'การอนุญาต',
        'Download' => 'ดาวน์โหลด',
        'Download file from package!' => 'ดาวน์โหลดไฟล์จากแพคเกจ',
        'Required' => 'ที่จำเป็น',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File differences for file %s' => 'ความแตกต่างของไฟล์สำหรับไฟล์ %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'การเข้าสู่ระบบการปฏิบัติงาน',
        'This feature is enabled!' => 'ฟีเจอร์ได้เปิดใช้งาน!',
        'Just use this feature if you want to log each request.' => 'เพียงใช้ฟีเจอร์นี้ถ้าคุณต้องการที่จะบันทึกคำขอแต่ละคำขอ',
        'Activating this feature might affect your system performance!' =>
            'การเปิดใช้งานคุณสมบัตินี้อาจส่งผลกระทบต่อประสิทธิภาพการทำงานของระบบของคุณ!',
        'Disable it here!' => 'ปิดการใช้งานได้ที่นี่!',
        'Logfile too large!' => 'logfile มีขนาดใหญ่เกินไป!',
        'The logfile is too large, you need to reset it' => 'logfile มีขนาดใหญ่เกินไป! คุณจำเป็นต้องรีเซ็ตมัน',
        'Overview' => 'ภาพรวม',
        'Range' => 'ช่วง',
        'last' => 'ล่าสุด',
        'Interface' => 'อินเตอร์เฟซ',
        'Requests' => 'การร้องขอ',
        'Min Response' => 'การตอบสนองขั้นต่ำ',
        'Max Response' => 'การตอบสนองสูงสุด',
        'Average Response' => 'การตอบสนองโดยเฉลี่ย',
        'Period' => 'ระยะเวลา',
        'Min' => 'นาที',
        'Max' => 'สูงสุด',
        'Average' => 'ค่าเฉลี่ย',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'การจัดการตัวกรองPostmaster',
        'Add filter' => 'เพิ่มตัวกรอง',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'เพื่อส่งหรือกรองอีเมลขาเข้าขึ้นอยู่กับหัวข้อของอีเมล นอกจากนี้ยังสามารถจับคู่โดยใช้นิพจน์ปกติ',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'ถ้าคุณต้องการเพียงเพื่อให้ที่อยู่อีเมลตรงกัน โปรดใช้ EMAILADDRESS: info@example.com ใน
จาก ถึงหรือสำเนา',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'ถ้าคุณใช้นิพจน์ปกติคุณก็ยังสามารถใช้ค่าจับคู่ใน () เป็น [***] ในการดำเนินการ \'ตั้งค่า\'',
        'Delete this filter' => 'ลบตัวกรองนี้',
        'Do you really want to delete this filter?' => '',
        'Add PostMaster Filter' => 'เพิ่มตัวกรอง PostMaster',
        'Edit PostMaster Filter' => 'แก้ไขตัวกรอง PostMaster',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'เงื่อนไขตัวกรอง',
        'AND Condition' => 'เงื่อนไข AND',
        'Check email header' => 'ตรวจสอบหัวข้อของอีเมล',
        'Negate' => 'ปฏิเสธ',
        'Look for value' => 'มองหาค่า',
        'The field needs to be a valid regular expression or a literal word.' =>
            'ฟิลด์จะต้องเป็นนิพจน์ทั่วไปที่ถูกต้องหรือเป็นตัวอักษรที่มีความหมาย',
        'Set Email Headers' => 'กำหนดหัวข้ออีเมล์',
        'Set email header' => 'กำหนดหัวข้ออีเมล์',
        'Set value' => 'กำหนดค่า',
        'The field needs to be a literal word.' => 'ฟิลด์จะต้องเป็นตัวอักษรที่มีความหมาย',

        # Template: AdminPriority
        'Priority Management' => 'การบริหารจัดการลำดับความสำคัญ',
        'Add priority' => 'เพิ่มลำดับความสำคัญ',
        'Add Priority' => 'เพิ่มลำดับความสำคัญ',
        'Edit Priority' => 'แก้ไขลำดับความสำคัญ',

        # Template: AdminProcessManagement
        'Process Management' => 'กระบวนการจัดการ',
        'Filter for Processes' => 'ตัวกรองสำหรับกระบวนการต่างๆ',
        'Create New Process' => 'สร้างการประมวลผลใหม่',
        'Deploy All Processes' => 'ปรับใช้กระบวนการทั้งหมด',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'คุณสามารถอัปโหลดไฟล์การกำหนดค่าที่จะนำเข้าสู่กระบวนการในระบบของคุณที่นี่และไฟล์ต้องอยู่ในรูปแบบ .ymlขณะที่ส่งออกโดยโมดูลการจัดการกระบวนการ ',
        'Overwrite existing entities' => 'เขียนทับแอนตีตี้ที่มีอยู่',
        'Upload process configuration' => 'อัปโหลดการกำหนดค่าขั้นตอนต่างๆ',
        'Import process configuration' => 'นำเข้าการกำหนดค่าขั้นตอน',
        'Ready-to-run Processes' => '',
        'Here you can activate ready-to-run processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated ready-to-run processes.' =>
            '',
        'Import ready-to-run process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'เพื่อสร้างขั้นตอนใหม่คุณสามารถสร้างโดยนำเข้าขั้นตอนที่ถูกส่งเข้ามาจากระบบอื่นหรือสร้างใหม่',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'เปลี่ยนแปลงที่ขั้นตอนต่างๆที่นี่ส่งผลกระทบต่อการทำงานของระบบเท่านั้นหากคุณเชื่อมโยงข้อมูลของขั้นตอน โดยการเชื่อมโยงขั้นตอนต่างๆนั้นจะทำให้การเปลี่ยนแปลงที่ทำใหม่ถูกเขียนไปที่ตั้งค่า',
        'Processes' => 'ขั้นตอนต่างๆ',
        'Process name' => 'ชื่อขั้นตอน',
        'Print' => 'พิมพ์',
        'Export Process Configuration' => 'ส่งออกการกำหนดค่าขั้นตอน',
        'Copy Process' => 'คัดลอกขั้นตอน',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'ยกเลิกและปิด',
        'Go Back' => 'กลับไป',
        'Please note, that changing this activity will affect the following processes' =>
            'หมายเหตุ การเปลี่ยนกิจกรรมนี้จะมีผลต่อกระบวนการถัดไป',
        'Activity' => 'กิจกรรม',
        'Activity Name' => 'ชื่อกิจกรรม',
        'Activity Dialogs' => 'กิจกรรมไดอะล็อก',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'คุณสามารถกำหนดกิจกรรมไดอะล็อกเพื่อกิจกรรมนี้โดยการลากองค์ประกอบด้วยเมาส์จากรายการด้านซ้ายไปยังรายการด้านขวา',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'การจัดเรียงองค์ประกอบภายในรายการสามารถทำได้โดยการลากและเลื่อนเช่นกัน',
        'Filter available Activity Dialogs' => 'ตัวกรองที่สามารถใช้ได้ในกิจกรรมไดอะล็อก',
        'Available Activity Dialogs' => 'กิจกรรมไดอะล็อกที่สามารถใช้ได้',
        'Name: %s, EntityID: %s' => 'ชื่อ: %s, EntityID: %s',
        'Create New Activity Dialog' => 'สร้างกิจกรรมไดอะล็อกใหม่',
        'Assigned Activity Dialogs' => 'กิจกรรมไดอะล็อกที่ได้รับมอบหมาย',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'ทันทีที่คุณจะใช้ปุ่มหรือการเชื่อมโยงนี้คุณจะออกหน้าจอนี้และสถานะปัจจุบันของคุณจะถูกบันทึกไว้โดยอัตโนมัติ คุณต้องการที่จะทำต่อหรือไม่?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'หมายเหตุ การเปลี่ยนกิจกรรมไดอะล็อกนี้จะมีผลต่อกระบวนการถัดไป',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'หมายเหตู ลูกค้าผู้ใช้จะไม่สามารถมองเห็นหรือใช้ฟิลด์ต่อไปนี้: เจ้าของ ผู้รับผิดชอบ ล็อค
เวลาที่รอดำเนินการและไอดีลูกค้า',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'ช่องคิวสามารถใช้งานได้แค่เฉพาะลูกค้าเมื่อมีการสร้างตั๋วใหม่',
        'Activity Dialog' => 'กิจกรรมไดอะล็อก',
        'Activity dialog Name' => 'ชื่อกิจกรรมไดอะล็อก',
        'Available in' => 'พร้อมใช้งานใน',
        'Description (short)' => 'คำอธิบาย (สั้น)',
        'Description (long)' => 'คำอธิบาย (ยาว)',
        'The selected permission does not exist.' => 'สิทธิ์ที่เลือกไม่มีอยู่',
        'Required Lock' => 'ล็อคที่จำเป็น',
        'The selected required lock does not exist.' => 'ไม่มีล็อคจำเป็นที่ถูกเลือก',
        'Submit Advice Text' => 'ส่งข้อความแนะนำ',
        'Submit Button Text' => 'ส่งข้อความปุ่ม',
        'Fields' => 'ฟิลด์',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'คุณสามารถกำหนดฟิลด์ไปยังกิจกรรมไดอะล็อกนี้โดยการลากองค์ประกอบด้วยเมาส์จากรายการด้านซ้ายไปยังรายการด้านขวา',
        'Filter available fields' => 'ตัวกรองฟิลด์ที่สามารถใช้ได้',
        'Available Fields' => 'ฟิลด์ที่สามารถใช้ได้',
        'Name: %s' => 'ชื่อ: %s',
        'Assigned Fields' => 'ฟิลด์ที่ได้รับมอบหมาย',
        'ArticleType' => 'ประเภทของบทความ',
        'Display' => 'แสดง',
        'Edit Field Details' => 'แก้ไขรายละเอียดของฟิลด์',
        'Customer interface does not support internal article types.' => 'อินเตอร์เฟซของลูกค้าไม่สนับสนุนประเภทบทความภายใน',

        # Template: AdminProcessManagementPath
        'Path' => 'เส้นทาง',
        'Edit this transition' => 'แก้ไขการเปลี่ยนแปลงนี้',
        'Transition Actions' => 'การกระทำเปลี่ยนผ่าน',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'คุณสามารถกำหนดการกระทำเปลี่ยนผ่านไปยังการเปลี่ยนผ่านนี้โดยการลากองค์ประกอบด้วยเมาส์จากรายการด้านซ้ายไปยังรายการด้านขวา',
        'Filter available Transition Actions' => 'ตัวกรองที่สามารถใช้ได้ในการกระทำเปลี่ยนผ่าน',
        'Available Transition Actions' => 'การกระทำเปลี่ยนผ่านที่สามารถใช้ได้',
        'Create New Transition Action' => 'สร้างการกระทำเปลี่ยนผ่านใหม่',
        'Assigned Transition Actions' => 'การกระทำเปลี่ยนผ่านที่ได้รับมอบหมาย',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'กิจกรรมต่างๆ',
        'Filter Activities...' => 'กิจกรรมตัวกรอง ...',
        'Create New Activity' => 'สร้างกิจกรรมใหม่',
        'Filter Activity Dialogs...' => 'ตัวกรองกิจกรรมไดอะล็อก ...',
        'Transitions' => 'การเปลี่ยนผ่าน',
        'Filter Transitions...' => 'ตัวกรองการเปลี่ยนผ่าน',
        'Create New Transition' => 'สร้างการเปลี่ยนผ่านใหม่',
        'Filter Transition Actions...' => 'ตัวกรองการกระทำเปลี่ยนผ่าน',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'แก้ไขขั้นตอน',
        'Print process information' => 'พิมพ์ข้อมูลกระบวนการต่างๆ',
        'Delete Process' => 'ลบกระบวนการ',
        'Delete Inactive Process' => 'ลบกระบวนการที่ไม่ใช้งาน',
        'Available Process Elements' => 'องค์ประกอบของขั้นตอนที่สามารถใช้ได้',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'องค์ประกอบที่ปรากฏข้างต้นในแถบด้านข้างนี้ไม่สามารถย้ายไปยังพื้นที่ด้านขวาโดยใช้การลากและวาง',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'คุณสามารถวางกิจกรรมในพื้นที่ผืนผ้าเพื่อกำหนดกิจกรรมนี้ไปยังขั้นตอน',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'เพื่อกำหนดกิจกรรมไดอะล็อกไปยังกิจกรรม วางองค์ประกอบกิจกรรมไดอะล็อกจากแถบด้านข้างนี้เหนือกิจกรรมที่วางอยู่ในพื้นที่ผืนผ้า',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'การกระทำสามารถกำหนดไปยังการเปลี่ยนผ่านโดยวางองค์ประกอบการกระทำบนฉลากของการเปลี่ยนผ่าน',
        'Edit Process Information' => 'แก้ไขข้อมูลกระบวนการ',
        'Process Name' => 'ชื่อกระบวนการ',
        'The selected state does not exist.' => 'สถานภาพที่เลือกไม่มีอยู่',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'เพิ่มและแก้ไขกิจกรรม กิจกรรมไดอะล็อกและการเปลี่ยนผ่าน',
        'Show EntityIDs' => 'แสดง EntityIDs',
        'Extend the width of the Canvas' => 'ขยายความกว้างของผ้าใบ',
        'Extend the height of the Canvas' => 'ขยายความสูงของผ้าใบ',
        'Remove the Activity from this Process' => 'ลบกิจกรรมออกจากกระบวนการนี้',
        'Edit this Activity' => 'แก้ไขกิจกรรมนี้',
        'Save Activities, Activity Dialogs and Transitions' => 'บันทึกกิจกรรม กิจกรรมไดอะล็อกและการเปลี่ยนผ่าน',
        'Do you really want to delete this Process?' => 'คุณต้องการลบกระบวนการนี้หรือไม่?',
        'Do you really want to delete this Activity?' => 'คุณต้องการลบกิจกรรมนี้หรือไม่?',
        'Do you really want to delete this Activity Dialog?' => 'คุณต้องการลบกิจกรรมไดอะล็อกนี้หรือไม่?',
        'Do you really want to delete this Transition?' => 'คุณต้องการที่จะลบการเปลี่ยนผ่านนี้หรือไม่?',
        'Do you really want to delete this Transition Action?' => 'คุณต้องการที่จะลบการดำเนินการเปลี่ยนผ่านนี้หรือไม่?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'คุณต้องการที่จะลบกิจกรรมนี้จากผ้าใบหรือไม่? ซึ่งคุณสามารถยกเลิกได้โดยการออกจากหน้าจอนี้โดยไม่มีการบันทึกเท่านั้น',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'คุณต้องการที่จะลบการเปลี่ยนผ่านนี้จากผ้าใบหรือไม่? ซึ่งคุณสามารถยกเลิกได้โดยการออกจากหน้าจอนี้โดยไม่มีการบันทึกเท่านั้น',
        'Hide EntityIDs' => 'ซ่อน EntityIDs',
        'Delete Entity' => 'ลบเอ็นติตี้',
        'Remove Entity from canvas' => 'ลบเอ็นติตี้จากผ้าใบ',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'กิจกรรมนี้ถูกใช้แล้วในกระบวนการนี้ คุณไม่สามารถเพิ่มอีกเป็นครั้งที่สอง!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'กิจกรรมนี้ไม่สามารถลบได้เพราะมันเป็นจุดเริ่มต้นของกิจกรรม',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'การเปลี่ยนผ่านนี้ถูกใช้แล้วในกิจกรรมนี้ คุณไม่สามารถใช้งานสองครั้ง!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'การดำเนินการเปลี่ยนผ่านนี้ถูกใช้แล้วในเส้นทางนี้ คุณไม่สามารถใช้งานสองครั้ง!',
        'Remove the Transition from this Process' => 'ลบการเปลี่ยนผ่านออกจากกระบวนการนี้',
        'No TransitionActions assigned.' => 'ไม่มีการดำเนินการเปลี่ยนผ่านที่ได้รับมอบหมาย',
        'The Start Event cannot loose the Start Transition!' => 'จุดเริ่มต้นเหตุการณ์ไม่สามารถให้อิสระที่จุดเริ่มเริ่มต้นการเปลี่ยนผ่าน!',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'ยังไม่มีไดอะล็อกที่ได้รับมอบหมาย เพียงแค่เลือกกิจกรรมไดอะล็อกจากรายการทางด้านซ้ายและลากไปที่นี่',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'การเปลี่ยนผ่านที่ไม่เกี่ยวเนื่องกันถูกวางไว้แล้วบนผ้าใบแล้วโปรดเชื่อมต่อการเปลี่ยนผ่านนี้ก่อนที่จะวางการเปลี่ยนผ่านอื่นๆ',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'ในหน้าจอนี้คุณสามารถสร้างกระบวนการใหม่ การที่จะทำให้กระบวนการใหม่เปิดใช้งานให้ผู้ใช้โปรดให้แน่ใจว่าการตั้งค่าสถานภาพเป็น \'ใช้งาน\' และเชื่อมต่อหลังจากการทำงานของคุณเสร็จสิ้น',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => 'เริ่มต้นกิจกรรม',
        'Contains %s dialog(s)' => 'ประกอบด้วยไดอะล็อก(s) %s',
        'Assigned dialogs' => 'ไดอะล็อกที่ได้รับมอบหมาย',
        'Activities are not being used in this process.' => 'กิจกรรมจะไม่ถูกนำมาใช้ในกระบวนการนี้',
        'Assigned fields' => 'ฟิลด์ที่ได้รับมอบหมาย',
        'Activity dialogs are not being used in this process.' => 'กิจกรรมไดอะล็อกจะไม่ถูกนำมาใช้ในกระบวนการนี้',
        'Condition linking' => 'เงื่อนไขการเชื่อมโยง',
        'Conditions' => 'เงื่อนไข ',
        'Condition' => 'เงื่อนไข ',
        'Transitions are not being used in this process.' => 'การเปลี่ยนผ่านจะไม่ถูกนำมาใช้ในกระบวนการนี้',
        'Module name' => 'ชื่อโมดูล',
        'Transition actions are not being used in this process.' => 'การดำเนินการเปลี่ยนผ่านจะไม่ถูกนำมาใช้ในกระบวนการนี้',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'หมายเหตุ การเปลี่ยนการเปลี่ยนผ่านนี้จะมีผลต่อกระบวนการถัดไป',
        'Transition' => 'การเปลี่ยนผ่าน',
        'Transition Name' => 'ชื่อการเปลี่ยนผ่าน',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'ประเภทของการเชื่อมโยงระหว่างเงื่อนไขต่างๆ',
        'Remove this Condition' => 'ลบเงื่อนไขนี้',
        'Type of Linking' => 'ประเภทของการเชื่อมโยง',
        'Add a new Field' => 'เพิ่มฟิลด์ใหม่',
        'Remove this Field' => 'ลบฟิลด์นี้',
        'And can\'t be repeated on the same condition.' => 'และไม่สามารถทำซ้ำบนเงื่อนไขเดียวกัน',
        'Add New Condition' => 'เพิ่มเงื่อนไขใหม่',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'หมายเหตุ การเปลี่ยนการดำเนินการเปลี่ยนผ่านนี้จะมีผลต่อกระบวนการถัดไป',
        'Transition Action' => 'การกระทำเปลี่ยนผ่าน',
        'Transition Action Name' => 'ชื่อการกระทำเปลี่ยนผ่าน',
        'Transition Action Module' => 'โมดูลการกระทำเปลี่ยนผ่าน',
        'Config Parameters' => 'Config Parameters',
        'Add a new Parameter' => 'เพิ่มพารามิเตอร์ใหม่',
        'Remove this Parameter' => 'ลบพารามิเตอร์นี้',

        # Template: AdminQueue
        'Manage Queues' => 'จัดการคิว',
        'Add queue' => 'เพิ่มคิว',
        'Add Queue' => 'เพิ่มคิว',
        'Edit Queue' => 'แก้ไขคิว',
        'A queue with this name already exists!' => 'คิวที่ใช้ชื่อนี้มีอยู่แล้ว!',
        'Sub-queue of' => 'คิวย่อยของ',
        'Unlock timeout' => 'หมดเวลาการปลดล็อค',
        '0 = no unlock' => '0 = ไม่มีการปลดล็อค',
        'Only business hours are counted.' => 'เฉพาะวันและเวลาทำการที่จะถูกนับ',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'หากเอเยานต์ล็อคตั๋วและไม่ปิดมันก่อนที่จะหมดเวลาการปลดล็อค ตั๋วจะปลดล็อคและจะกลายเป็นตั๋วที่พร้อมใช้งานสำหรับเอเยนต์อื่น ๆ',
        'Notify by' => 'แจ้งโดย',
        '0 = no escalation' => '0 = ไม่มีการขยาย',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'หากไม่มีการเพิ่มรายการติดต่อของลูกค้า ทั้งอีเมลภายนอกหรือโทรศัพท์ไปยังตั๋วใหม่ก่อนเวลาที่กำหนดไว้ที่นี่จะหมดอายุ ตั๋วจะเพิ่มขึ้น',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'หากมีการเพิ่มบทความ เช่นการติดตามผ่านทางอีเมลหรือพอร์ทัลลูกค้า เวลาการอัพเดตการขยายถูกรีเซ็ต หากไม่มีการติดต่อกับลูกค้าไม่ว่าจากอีเมลภายนอกหรือโทรศัพท์ จะถูกเพิ่มเข้าไปในตั๋วก่อนที่เวลาที่กำหนดไว้ที่นี่จะหมดอายุ ตั๋วจะถูกขยายขึ้น',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'หากไม่ได้ตั้งค่าการปิดตั๋วก่อนเวลาที่กำหนดไว้ที่นี่จะหมดอายุตั๋วจะถกขยาย',
        'Follow up Option' => 'ติดตามตัวเลือก',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'โปรดระบุว่าปฏิเสธหรือนำไปสู่ตั๋วใหม่ถ้าหากติดตามตั๋วที่ปิดแล้วจะสามารถเปิดตั๋วอีกครั้ง',
        'Ticket lock after a follow up' => 'ล็อคตั๋วหลังจากการติดตาม',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'ถ้าตั๋วถูกปิดและลูกค้าส่งการติดตามตั๋วจะถูกล็อคให้เจ้าของเก่า',
        'System address' => 'ที่อยู่ของระบบ',
        'Will be the sender address of this queue for email answers.' => 'จะเป็นที่อยู่ของผู้ส่งคิวนี้สำหรับอีเมลคำตอบ',
        'Default sign key' => 'กุญแจเริ่มต้นการเข้าสู่ระบบ',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'The salutation for email answers.' => 'คำขึ้นต้นจดหมายสำหรับอีเมลคำตอบ',
        'The signature for email answers.' => 'ลายเซ็นสำหรับอีเมลคำตอบ',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'จัดการความสัมพันธ์การตอบสนองคิวอัตโนมัติ',
        'This filter allow you to show queues without auto responses' => 'ตัวกรองนี้จะจะอนุญาตให้คุณแสดงคิวได้โดยไม่ต้องตอบสนองอัตโนมัติ',
        'Queues without auto responses' => 'คิวที่ไม่ต้องใช้การตอบสนองอัตโนมัติ',
        'This filter allow you to show all queues' => 'ตัวกรองนี้จะจะอนุญาตให้คุณแสดงคิวทั้งหมดได้',
        'Show all queues' => 'แสดงคิวทั้งหมด',
        'Filter for Queues' => 'ตัวกรองสำหรับคิว',
        'Filter for Auto Responses' => 'ตัวกรองสำหรับการตอบสนองอัตโนมัติ',
        'Auto Responses' => 'การตอบสนองอัตโนมัติ',
        'Change Auto Response Relations for Queue' => 'เปลี่ยนความสัมพันธ์ระหว่างการตอบสนองอัตโนมัติสำหรับคิว',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'จัดการความสัมพันธ์ของแม่แบบคิว',
        'Filter for Templates' => 'ตัวกรองสำหรับแม่แบบ',
        'Templates' => 'รูปแบบ',
        'Change Queue Relations for Template' => 'เปลี่ยนความสัมพันธ์ของคิวสำหรับแม่แบบ',
        'Change Template Relations for Queue' => 'เปลี่ยนความสัมพันธ์ของแม่แบบสำหรับคิว',

        # Template: AdminRegistration
        'System Registration Management' => 'การจัดการระบบการลงทะเบียน',
        'Edit details' => 'แก้ไขรายละเอียด',
        'Show transmitted data' => 'แสดงข้อมูลที่ส่ง',
        'Deregister system' => 'ยกเลิกการลงทะเบียนระบบ',
        'Overview of registered systems' => 'ภาพรวมของระบบการลงทะเบียน',
        'This system is registered with OTRS Group.' => 'ระบบนี้มีการลงทะเบียนกับกลุ่ม OTRS',
        'System type' => 'ชนิดของระบบ',
        'Unique ID' => 'ID ที่ไม่ซ้ำกัน',
        'Last communication with registration server' => 'การสื่อสารกับเซิร์ฟเวอร์การลงทะเบียนครั้งล่าสุด',
        'System registration not possible' => 'การลงทะเบียนระบบเป็นไปไม่ได้',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'โปรดทราบว่าคุณไม่สามารถลงทะเบียนระบบของคุณ ถ้าหาก OTRS Daemon ทำงานไม่ถูกต้อง!',
        'Instructions' => 'คำแนะนำ',
        'System deregistration not possible' => 'การยกเลิกลงทะเบียนระบบเป็นไปไม่ได้',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'โปรดทราบว่าคุณไม่สามารถยกเลิกการลงทะเบียนระบบของคุณ หากคุณกำลังใช้ %s หรือมีสัญญาการให้บริการที่ถูกต้อง',
        'OTRS-ID Login' => 'OTRS-ID เข้าสู่ระบบ ',
        'Read more' => 'อ่านเพิ่มเติม',
        'You need to log in with your OTRS-ID to register your system.' =>
            'คุณจำเป็นต้องเข้าสู่ระบบID OTRSเพื่อลงทะเบียนระบบของคุณ',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'ID OTRS ของคุณคือที่อยู่อีเมลที่คุณใช้ในการลงทะเบียนในหน้าเว็บ OTRS.com',
        'Data Protection' => 'การป้องกันข้อมูล',
        'What are the advantages of system registration?' => 'ข้อดีของการลงทะเบียนระบบคืออะไร?',
        'You will receive updates about relevant security releases.' => 'คุณจะได้รับการอัพเดตเกี่ยวกับการเผยแพร่ระบบรักษาความปลอดภัยที่เกี่ยวข้อง',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'ด้วยการลงทะเบียนระบบของคุณเราสามารถปรับปรุงบริการของเราสำหรับคุณเพราะเรามีข้อมูลที่เกี่ยวข้องทั้งหมด',
        'This is only the beginning!' => 'นี่เป็นเพียงแค่จุดเริ่มต้น!',
        'We will inform you about our new services and offerings soon.' =>
            'เราจะแจ้งให้คุณทราบเกี่ยวกับบริการใหม่ของเราและการให้บริการในเร็ว ๆ นี้',
        'Can I use OTRS without being registered?' => 'ฉันสามารถใช้ OTRS โดยไม่ต้องลงทะเบียนหรือไม่?',
        'System registration is optional.' => 'การลงทะเบียนระบบเป็นแค่ทางเลือกหนึ่ง',
        'You can download and use OTRS without being registered.' => 'คุณสามารถดาวน์โหลดและ OTRS โดยไม่ต้องลงทะเบียน',
        'Is it possible to deregister?' => 'เป็นไปได้หรือไม่ที่จะยกเลิกการลงทะเบียน?',
        'You can deregister at any time.' => 'คุณสามารถยกเลิกการลงทะเบียนได้ตลอดเวลา',
        'Which data is transfered when registering?' => 'ข้อมูลใดจะถูกโอนเมื่อลงทะเบียน?',
        'A registered system sends the following data to OTRS Group:' => 'ระบบที่จดทะเบียนส่งข้อมูลต่อไปนี้ไปยังกลุ่ม OTRS:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'ชื่อโดเมนที่ผ่านการรับรองอย่างเต็มรูปแบบ (FQDN) เวอร์ชั่นของ OTRS, ฐานข้อมูล, ระบบปฏิบัติการและ เวอร์ชันของ Perl',
        'Why do I have to provide a description for my system?' => 'ทำไมฉันจะต้องให้คำอธิบายสำหรับระบบของฉัน?',
        'The description of the system is optional.' => 'คำอธิบายของระบบจะเป็นแค่ตัวเลือก',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'คำอธิบายและชนิดของระบบที่คุณระบุจะช่วยให้คุณระบุและจัดการรายละเอียดของระบบการลงทะเบียนของคุณ',
        'How often does my OTRS system send updates?' => 'ระบบOTRS ของฉันมีการส่งการอัพเดตบ่อยแค่ใหน?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'ระบบของคุณจะส่งการอัพเดตไปยังเซิร์ฟเวอร์การลงทะเบียนในช่วงปกติ',
        'Typically this would be around once every three days.' => 'ซึ่งโดยปกติแล้วประมาณทุกๆสามวัน',
        'Please visit our' => 'กรุณาเยี่ยมชม  ของเรา',
        'portal' => 'พอร์ทัล',
        'and file a request.' => 'และยื่นคำขอ',
        'If you deregister your system, you will lose these benefits:' =>
            'ถ้าคุณยกเลิกการลงทะเบียนระบบของคุณ คุณจะสูญเสียผลประโยชน์เหล่านี้:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'คุณจำเป็นต้องเข้าสู่ระบบด้วย ID OTRSเพื่อยกเลิกการลงทะเบียนระบบของคุณ',
        'OTRS-ID' => 'ID OTRS',
        'You don\'t have an OTRS-ID yet?' => 'คุณยังไม่มีID OTRS ใช่หรือไม่?',
        'Sign up now' => 'สมัครตอนนี้เลย',
        'Forgot your password?' => 'ลืมรหัสผ่าน?',
        'Retrieve a new one' => 'ดึงข้อมูลขึ้นมาใหม่',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'ข้อมูลนี้จะถูกโอนไปยังกลุ่มOTRS บ่อยครั้งเมื่อคุณลงทะเบียนระบบนี้',
        'Attribute' => 'แอตทริบิวต์',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'เวอร์ชั่นของ OTRS',
        'Operating System' => 'ระบบปฏิบัติการ',
        'Perl Version' => 'เวอร์ชั่นของ Perl',
        'Optional description of this system.' => 'ตัวเลือกคำอธิบายของระบบนี้',
        'Register' => 'ลงทะเบียน',
        'Deregister System' => 'ระบบการยกเลิกการลงทะเบียน',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'ดำเนินการต่อด้วยขั้นตอนนี้จะยกเลิกการลงทะเบียนระบบจากกลุ่มOTRS',
        'Deregister' => 'ยกเลิกการลงทะเบียน',
        'You can modify registration settings here.' => 'คุณสามารถแก้ไขการตั้งค่าการลงทะเบียนที่นี่',
        'Overview of transmitted data' => 'ภาพรวมของข้อมูลที่ส่ง',
        'There is no data regularly sent from your system to %s.' => 'ไม่มีข้อมูลที่ส่งเป็นประจำจากระบบของคุณไปยัง % s',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'ข้อมูลต่อไปนี้จะถูกส่งอย่างน้อยทุกๆ 3 วันจากระบบของคุณไปยัง % s',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'ข้อมูลจะถูกโอนในรูปแบบ JSON ผ่านการเชื่อมต่อ https ที่ปลอดภัย ',
        'System Registration Data' => 'ข้อมูลการลงทะเบียนระบบ',
        'Support Data' => 'ข้อมูลการสนับสนุน',

        # Template: AdminRole
        'Role Management' => 'การจัดการบทบาท',
        'Add role' => 'เพิ่มบทบาท',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'สร้างบทบาทและใส่ในกลุ่มนั้น แล้วเพิ่มบทบาทให้กับผู้ใช้',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'ไม่มีบทบาทที่กำหนดไว้ กรุณาใช้ปุ่ม \'เพิ่ม\' เพื่อสร้างบทบาทใหม่',
        'Add Role' => 'เพิ่มบทบาท',
        'Edit Role' => 'แก้ไขบทบาท',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'จัดการความสัมพันธ์ของกลุ่มบทบาท',
        'Filter for Roles' => 'ตัวกรองสำหรับบทบาท',
        'Roles' => 'บทบาท',
        'Select the role:group permissions.' => 'เลือกบทบาท: สิทธิ์ของกลุ่ม',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'หากไม่มีอะไรถูกเลือกแล้วจะไม่มีสิทธิ์ในกลุ่มนี้ (ตั๋วจะไม่สามารถใช้ได้สำหรับบทบาท)',
        'Change Role Relations for Group' => 'เปลี่ยนความสัมพันธ์ของบทบาทสำหรับกลุ่ม',
        'Change Group Relations for Role' => 'เปลี่ยนความสัมพันธ์ของกลุ่มสำหรับบทบาท',
        'Toggle %s permission for all' => 'สลับ %s การอนุญาตทั้งหมด',
        'move_into' => 'ย้ายเข้าไปอยู่ใน',
        'Permissions to move tickets into this group/queue.' => 'สิทธิ์ที่จะย้ายตั๋วไปยัง กลุ่ม/คิว นี้',
        'create' => 'สร้าง',
        'Permissions to create tickets in this group/queue.' => 'สิทธิ์ในการสร้างตั๋วในกลุ่ม/คิว นี้',
        'note' => 'โน้ต',
        'Permissions to add notes to tickets in this group/queue.' => 'สิทธิ์ในการเพิ่มโน้ตไปยังตั๋วในกลุ่ม/คิว นี้',
        'owner' => 'เจ้าของ',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'สิทธิ์ในการเปลี่ยนเจ้าของตั๋วในกลุ่ม/คิวนี้',
        'priority' => 'ลำดับความสำคัญ',
        'Permissions to change the ticket priority in this group/queue.' =>
            'สิทธิ์ในการเปลี่ยนลำดับความสำคัญของตั๋วในกลุ่ม/คิวนี้',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'จัดการความสัมพันธ์ของบทบาทเอเย่นต์',
        'Add agent' => 'เพิ่มเอเย่นต์',
        'Filter for Agents' => 'ตัวกรองสำหรับเอเย่นต์',
        'Agents' => 'เอเย่นต์',
        'Manage Role-Agent Relations' => 'จัดการความสัมพันธ์ของเอเย่นต์บทบาท',
        'Change Role Relations for Agent' => 'เปลี่ยนความสัมพันธ์ของบทบาทสำหรับเอเย่นต์',
        'Change Agent Relations for Role' => 'เปลี่ยนความสัมพันธ์ของเอเย่นต์สำหรับบทบาท',

        # Template: AdminSLA
        'SLA Management' => 'การจัดการ SLA ',
        'Add SLA' => 'เพิ่ม SLA ',
        'Edit SLA' => 'แก้ไข SLA ',
        'Please write only numbers!' => 'กรุณาเขียนตัวเลขเท่านั้น!',

        # Template: AdminSMIME
        'S/MIME Management' => 'การจัดการ S/MIME',
        'SMIME support is disabled' => 'การสนับสนุน SMIME จะถูกปิดใช้งาน',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'เพื่อให้สามารถใช้ SMIME ใน OTRS คุณต้องเปิดการใช้งานก่อน',
        'Enable SMIME support' => 'เปิดใช้งานการสนับสนุน SMIME',
        'Faulty SMIME configuration' => 'การกำหนดค่า SMIME ผิดพลาด',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'เปิดใช้งานการสนับสนุน SMIME แล้วแต่การกำหนดค่าที่เกี่ยวข้องมีข้อผิดพลาด กรุณาตรวจสอบการตั้งค่าโดยใช้ปุ่มด้านล่าง',
        'Check SMIME configuration' => 'ตรวจสอบการกำหนดค่า SMIME',
        'Add certificate' => 'เพิ่มใบรับรอง',
        'Add private key' => 'เพิ่มคีย์ส่วนตัว',
        'Filter for certificates' => 'ตัวกรองสำหรับใบรับรอง',
        'Filter for S/MIME certs' => 'ตัวกรองสำหรับใบรับรอง S / MIME',
        'To show certificate details click on a certificate icon.' => 'หากต้องการแสดงรายละเอียดใบรับรองคลิกที่ไอคอนใบรับรอง',
        'To manage private certificate relations click on a private key icon.' =>
            'ในการจัดการความสัมพันธ์ใบรับรองส่วนตัวคลิกที่ไอคอนรูปกุญแจส่วนตัว',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'คุณสามารถเพิ่มความสัมพันธ์ไปยังใบรับรองส่วนตัวของคุณที่นี่ สิ่งเหล่านี้จะติดอยู่กับลายเซ็นของ S/ MIME ทุกครั้งที่ใช้ใบรับรองนี้เพื่อเข้าสู่ระบบอีเมล',
        'See also' => 'ดูเพิ่มเติม',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'ด้วยวิธีนี้คุณสามารถแก้ไขการรับรองและคีย์ส่วนตัวในระบบแฟ้มได้โดยตรง',
        'Hash' => 'การแฮช',
        'Handle related certificates' => 'จัดการใบรับรองที่เกี่ยวข้อง',
        'Read certificate' => 'อ่านใบรับรอง',
        'Delete this certificate' => 'ลบใบรับรองนี้',
        'Add Certificate' => 'เพิ่มใบรับรอง',
        'Add Private Key' => 'เพิ่มคีย์ส่วนตัว',
        'Secret' => 'ความลับ',
        'Related Certificates for' => 'ใบรับรองที่เกี่ยวข้องสำหรับ',
        'Delete this relation' => 'ลบความสัมพันธ์นี้',
        'Available Certificates' => 'ใบรับรองที่พร้อมใช้งาน',
        'Relate this certificate' => 'เกี่ยวข้องกับใบรับรองนี้',

        # Template: AdminSMIMECertRead
        'Close dialog' => '',
        'Certificate details' => 'รายละเอียดของหนังสือรับรอง',

        # Template: AdminSalutation
        'Salutation Management' => 'การจัดการคำขึ้นต้น',
        'Add salutation' => 'เพิ่มคำขึ้นต้น',
        'Add Salutation' => 'เพิ่มคำขึ้นต้น',
        'Edit Salutation' => 'แก้ไขคำขึ้นต้น',
        'e. g.' => 'ตัวอย่างเช่น',
        'Example salutation' => 'ตัวอย่างคำขึ้นต้น',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'โหมดการรักษาความปลอดภัยจะต้องมีการเปิดใช้งาน!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'โหมดการรักษาความปลอดภัยจะ (ปกติ)มีการตั้งค่าหลังจากที่ติดตั้งระบบเป็นที่เรียบร้อยแล้ว',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'ถ้าโหมดรักษาปลอดภัยไม่ได้เปิดใช้งาน สามารถเปิดใช้งานได้ผ่านทาง sysconfig เพราะแอพลีเคชั่นของคุณกำลังทำงานอยู่',

        # Template: AdminSelectBox
        'SQL Box' => 'กล่องSQL ',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'คุณสามารถใส่ SQL เพื่อส่งไปยังฐานข้อมูลแอพลิเคชันโดยตรงได้ที่นี่ มันไม่ได้เป็นไปได้ที่จะเปลี่ยนเนื้อหาของตารางและเลือกคำสั่งที่ได้รับอนุญาตเท่านั้น',
        'Here you can enter SQL to send it directly to the application database.' =>
            'คุณสามารถใส่ SQL เพื่อส่งไปยังฐานข้อมูลแอพลิเคชันโดยตรงได้ที่นี่',
        'Only select queries are allowed.' => 'เลือกเฉพาะคำสั่งที่ได้รับอนุญาต',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'ไวยากรณ์ของคำสั่ง SQL ของคุณมีความผิดพลา กรุณาตรวจสอบ',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'มีอย่างน้อยหนึ่งพารามิเตอร์ที่ขาดหายไปสำหรับผลผูกพัน กรุณาตรวจสอบ',
        'Result format' => 'รูปแบบผลลัพท์',
        'Run Query' => 'รันคำสั่ง',
        'Query is executed.' => 'คำสั่งถูกดำเนินการ',

        # Template: AdminService
        'Service Management' => 'การจัดการบริการ',
        'Add service' => 'เพิ่มการบริการ',
        'Add Service' => 'เพิ่มการบริการ',
        'Edit Service' => 'แก้ไขการบริการ',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'การบริการย่อยของ',

        # Template: AdminSession
        'Session Management' => 'การจัดการเซสชั่น',
        'All sessions' => 'เซสชันทั้งหมด',
        'Agent sessions' => 'เซสชันเอเย่นต์',
        'Customer sessions' => 'เซสชันลูกค้า',
        'Unique agents' => 'เอเย่นต์ที่ไม่ซ้ำกัน',
        'Unique customers' => 'ลูกค้าที่ไม่ซ้ำกัน',
        'Kill all sessions' => 'ทำลายทุกกลุ่ม',
        'Kill this session' => 'ทำลายกลุ่มนี้',
        'Session' => 'เซสชัน',
        'Kill' => 'ทำลาย',
        'Detail View for SessionID' => 'ดูรายละเอียดสำหรับ SessionID',

        # Template: AdminSignature
        'Signature Management' => 'การจัดการลายเซ็น',
        'Add signature' => 'เพิ่มลายเซ็น',
        'Add Signature' => 'เพิ่มลายเซ็น',
        'Edit Signature' => 'แก้ไขลายเซ็น',
        'Example signature' => 'แก้ไขลายเซ็น',

        # Template: AdminState
        'State Management' => 'การจัดการสถานะ',
        'Add state' => 'เพิ่มสถานะ',
        'Please also update the states in SysConfig where needed.' => 'โปรดอัปเดตสถานะใน sysconfig เมื่อจำเป็น',
        'Add State' => 'เพิ่มสถานะ',
        'Edit State' => 'แก้ไขสถานะ',
        'State type' => 'ประเภทสถานะ',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'ไม่สามารถส่งข้อมูลการสนับสนุนให้กับกลุ่มOTRS',
        'Enable Cloud Services' => 'เปิดใช้บริการคลาวด์',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'ข้อมูลนี้จะถูกส่งไปยังกลุ่มOTRS เป็นประจำ หากต้องการหยุดการส่งข้อมูลนี้โปรดอัปเดตการลงทะเบียนในระบบของคุณ',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'คุณสามารถกระตุ้นการสนับสนุนการส่งข้อมูลโดยการกดปุ่มนี้:',
        'Send Update' => 'ส่งการอัพเดต',
        'Sending Update...' => 'ส่งการอัปเดต ...',
        'Support Data information was successfully sent.' => 'ข้อมูลการสนับสนุนถูกส่งเรียบร้อยแล้ว',
        'Was not possible to send Support Data information.' => 'เป็นไปไม่ได้ที่จะส่งข้อมูลของการสนับสนุนข้อมูล',
        'Update Result' => 'ผลการการอัปเดต',
        'Currently this data is only shown in this system.' => 'ขณะนี้ข้อมูลนี้จะแสดงเฉพาะในระบบนี้',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'กลุมสนับสนุน(รวมถึงข้อมูลการลงทะเบียนระบบ ข้อมูลสนับสนุน รายการของแพคเกจการติดตั้ง
และไฟล์แหล่งที่มาทั้งหมดที่มีการปรับเปลี่ยน) สามารถสร้างขึ้นได้โดยการกดปุ่มนี้:',
        'Generate Support Bundle' => 'สร้างกลุ่มสนับสนุน',
        'Generating...' => 'ผลิต ...',
        'It was not possible to generate the Support Bundle.' => 'มันเป็นไปไม่ได้ที่จะสร้างกลุ่มสนับสนุน',
        'Generate Result' => 'สร้างผลลัพธ์',
        'Support Bundle' => 'กลุ่มสนับสนุน',
        'The mail could not be sent' => 'ไม่สามารถส่งอีเมล',
        'The support bundle has been generated.' => 'กลุ่มสนับสนุนได้รับการสร้างแล้ว',
        'Please choose one of the following options.' => 'โปรดเลือกหนึ่งในตัวเลือกดังต่อไปนี้',
        'Send by Email' => 'ส่งโดยอีเมล์',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'กลุ่มสนับสนุนมีขนาดใหญ่เกินไปที่จะส่งไปทางอีเมลตัวเลือกนี้ถูกปิดใช้งาน',
        'The email address for this user is invalid, this option has been disabled.' =>
            'ที่อยู่อีเมลสำหรับผู้ใช้นี้ไม่ถูกต้องตัวเลือกนี้ถูกปิดใช้งาน',
        'Sending' => 'กำลังส่ง',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'กลุ่มสนับสนุนจะถูกส่งไปยังกลุ่มการตรวจสอบแล้วผ่านทางอีเมล์โดยอัตโนมัติ',
        'Download File' => 'ดาวน์โหลดไฟล์',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'ไฟล์ที่ประกอบด้วยกำสนับสนุนจะถูกดาวน์โหลดไปยังระบบภายใน กรุณาบันทึกไฟล์และส่งไปยังกลุ่มOTRS โดยใช้วิธีอื่น',
        'Error: Support data could not be collected (%s).' => 'ข้อผิดพลาด: ไม่สามารถเก็บรวบรวมข้อมูลสนับสนุน (%s)',
        'Details' => 'รายละเอียด',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => 'นำทางโดยการค้นหาใน %s การตั้งค่า',
        'Navigate by selecting config groups' => 'นำทางโดยการเลือกกลุ่มการตั้งค่า',
        'Download all system config changes' => 'ดาวน์โหลดการเปลี่ยนแปลงการตั้งค่าระบบทั้งหมด',
        'Export settings' => 'การตั้งค่าการส่งออก',
        'Load SysConfig settings from file' => 'โหลดการตั้งค่า sysconfig จากไฟล์',
        'Import settings' => 'การตั้งค่าการนำเข้า',
        'Import Settings' => 'การตั้งค่าการนำเข้า',
        'Please enter a search term to look for settings.' => 'กรุณากรอกคำค้นหาที่จะค้นหาการตั้งค่า',
        'Subgroup' => 'กลุ่มย่อย',
        'Elements' => 'องค์ประกอบ',

        # Template: AdminSysConfigEdit
        'Edit Config Settings in %s → %s' => 'แก้ไขการตั้งค่าการกำหนดค่าใน %s → %s',
        'This setting is read only.' => 'การตั้งค่านี้อ่านได้อย่างเดียว',
        'This config item is only available in a higher config level!' =>
            'รายการการตั้งค่านี้จะใช้ได้เฉพาะในระดับการตั้งค่าที่สูงขึ้น!',
        'Reset this setting' => 'รีเซ็ตการตั้งค่านี้',
        'Error: this file could not be found.' => 'ข้อผิดพลาด: ไม่พบไฟล์นี้',
        'Error: this directory could not be found.' => 'ข้อผิดพลาด: ไม่พบไดเรกทอรีนี้',
        'Error: an invalid value was entered.' => 'ข้อผิดพลาด:มีการป้อนค่าที่ไม่ถูกต้อง',
        'Content' => 'เนื้อหา',
        'Remove this entry' => 'ลบการกรอกข้อมูลนี้',
        'Add entry' => 'เพิ่มการกรอกข้อมูล',
        'Remove entry' => 'ลบการกรอกข้อมูลนี้',
        'Add new entry' => 'เพิ่มการกรอกข้อมูลใหม่',
        'Delete this entry' => 'ลบการกรอกข้อมูลนี้',
        'Create new entry' => 'สร้างการกรอกข้อมูลใหม่',
        'New group' => 'กลุ่มใหม่',
        'Group ro' => 'กลุ่มแถว',
        'Readonly group' => 'กลุ่มอ่านอย่างเดียว',
        'New group ro' => 'กลุ่มแถวใหม่',
        'Loader' => 'ตัวโหลด',
        'File to load for this frontend module' => 'ไฟล์ที่จะโหลดสำหรับโมดูลส่วนหน้านี้',
        'New Loader File' => 'ตัวโหลดไฟล์ใหม่',
        'NavBarName' => 'NavBarName',
        'NavBar' => 'NavBar',
        'LinkOption' => 'ตัวเลือกการเชื่อมโยง',
        'Block' => 'บล็อก',
        'AccessKey' => 'AccessKey',
        'Add NavBar entry' => 'เพิ่มการกรอกข้อมูล NavBar',
        'NavBar module' => 'โมดูล NavBar',
        'Year' => 'ปี',
        'Month' => 'เดือน',
        'Day' => 'วัน',
        'Invalid year' => 'ปีไม่ถูกต้อง',
        'Invalid month' => 'เดือนไม่ถูกต้อง',
        'Invalid day' => 'วันไม่ถูกต้อง',
        'Show more' => 'แสดงเพิ่มเติม',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'การจัดการที่อยู่อีเมลของระบบ',
        'Add system address' => 'เพิ่มที่อยู่ระบบ',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'อีเมลขาเข้าทั้งหมดที่มาที่อยู่นี้ใน ถึง หรือ สำเนา จะถูกส่งไปอยู่ในคิวที่เลือก',
        'Email address' => 'ที่อยู่อีเมล',
        'Display name' => 'ชื่อที่แสดง',
        'Add System Email Address' => 'เพิ่มที่อยู่อีเมลของระบบ',
        'Edit System Email Address' => 'แก้ไขที่อยู่อีเมลของระบบ',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'ชื่อที่ปรากฏและที่อยู่อีเมลจะแสดงบนอีเมลที่คุณส่ง',
        'This system address cannot be set to invalid, because it is used in one or more queue(s).' =>
            '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'การจัดการการบำรุงรักษาระบบ',
        'Schedule New System Maintenance' => 'กำหนดเวลาการบำรุงรักษาระบบใหม่',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'กำหนดการระยะเวลาการบำรุงรักษาระบบเพื่อแจ้งเอเย่นต์และลูกค้าว่าระบบจะทำงานช้าลงในช่วงเวลาดังกล่าว',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'บางครั้งก่อนที่จะการบำรุงรักษาระบบนี้จะเริ่มต้นผู้ใช้จะได้รับการแจ้งเตือนในแต่ละหน้าจอการประกาศเกี่ยวกับเรื่องนี้',
        'Start date' => 'วันที่เริ่มต้น',
        'Stop date' => 'วันที่หยุด',
        'Delete System Maintenance' => 'ลบการบำรุงรักษาระบบ',
        'Do you really want to delete this scheduled system maintenance?' =>
            'คุณต้องการที่จะลบการบำรุงรักษาระบบที่กำหนดนี้?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'แก้ไขการบำรุงรักษาระบบ %s',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'วันที่ไม่ถูกต้อง!',
        'Login message' => 'ข้อความเข้าสู่ระบบ',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'แสดงข้อความเข้าสู่ระบบ',
        'Notify message' => 'แจ้งข้อความ',
        'Manage Sessions' => 'จัดการเซสชั่น',
        'All Sessions' => 'เซสชั่นทั้งหมด',
        'Agent Sessions' => 'เซสชันเอเย่นต์',
        'Customer Sessions' => 'เซสชันลูกค้า',
        'Kill all Sessions, except for your own' => 'ทำลายเซสชันทั้งหมดยกเว้นเซสชันของคุณ',

        # Template: AdminTemplate
        'Manage Templates' => 'จัดการรูปแบบต่างๆ',
        'Add template' => 'เพิ่มแม่แบบ',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'แม่แบบเป็นข้อความเริ่มต้นซึ่งจะช่วยให้เอเย่นต์ของคุณในการเขียนตั๋ว ตอบหรือส่งต่อให้เร็วขึ้น',
        'Don\'t forget to add new templates to queues.' => 'อย่าลืมที่จะเพิ่มแม่แบบใหม่ไปยังคิว',
        'Do you really want to delete this template?' => 'คุณต้องการที่จะลบแม่แบบนี้หรือไม่?',
        'Add Template' => 'เพิ่มแม่แบบ',
        'Edit Template' => 'แก้ไขแม่แบบ',
        'A standard template with this name already exists!' => 'แม่แบบมาตรฐานที่ใช้ชื่อนี้มีอยู่แล้ว!',
        'Create type templates only supports this smart tags' => 'สร้างประเภทแม่แบบซึ่งสนับสนุนเฉพาะสมาร์ทแท็กนี้',
        'Example template' => 'ตัวอย่างแม่แบบ',
        'The current ticket state is' => 'สถานะตั๋วปัจจุบัน',
        'Your email address is' => 'ที่อยู่อีเมลของคุณคือ',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'จัดการแม่แบบ <-> ความสัมพันธ์ของสิ่งที่แนบมา',
        'Filter for Attachments' => 'ตัวกรองสำหรับสิ่งที่แนบมา',
        'Change Template Relations for Attachment' => 'เปลี่ยนความสัมพันธ์ของแม่แบบสำหรับสิ่งที่แนบมา',
        'Change Attachment Relations for Template' => 'เปลี่ยนความสัมพันธ์ของสิ่งที่แนบมาสำหรับแม่แบบ',
        'Toggle active for all' => 'สลับการใช้งานสำหรับทั้งหมด',
        'Link %s to selected %s' => 'การเชื่อมโยง %s เพื่อเลือก %s',

        # Template: AdminType
        'Type Management' => 'ประเภทการจัดการ',
        'Add ticket type' => 'พิ่มประเภทตั๋ว',
        'Add Type' => 'เพิ่มประเภท',
        'Edit Type' => 'แก้ไขประเภท',
        'A type with this name already exists!' => 'ประเภทที่ใช้ชื่อนี้มีอยู่แล้ว!',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'เอเย่นต์จะต้องจัดการกับตั๋ว',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'อย่าลืมที่จะเพิ่มเอเย่นต์ใหม่ไปยังกลุ่มและ/หรือบทบาท!',
        'Please enter a search term to look for agents.' => 'กรุณากรอกคำค้นหาที่จะค้นหาเอเย่นต์',
        'Last login' => 'เข้าระบบครั้งสุดท้าย',
        'Switch to agent' => 'เปลี่ยนเป็นเอเย่นต์',
        'Add Agent' => 'เพิ่มเอเย่นต์',
        'Edit Agent' => 'แก้ไขเอเย่นต์',
        'Title or salutation' => 'หัวข้อหรือคำขึ้นต้น',
        'Firstname' => 'ชื่อ',
        'Lastname' => 'นามสกุล',
        'A user with this username already exists!' => 'มีผู้ใช้งานชื่อนี้อยู่แล้ว!',
        'Will be auto-generated if left empty.' => 'จะสร้างขึ้นโดยอัตโนมัติหากปล่อยทิ้งไว้ว่างเปล่า',
        'Start' => 'เริ่มต้น',
        'End' => 'จบ',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'จัดการความสัมพันธ์ของกลุ่มเอเย่นต์',
        'Add group' => 'เพิ่มกลุ่ม',
        'Change Group Relations for Agent' => 'เปลี่ยนความสัมพันธ์ของกลุ่มสำหรับเอเย่นต์',
        'Change Agent Relations for Group' => 'เปลี่ยนความสัมพันธ์ของเอเย่นต์สำหรับกลุ่ม',

        # Template: AgentBook
        'Address Book' => 'สมุดที่อยู่',
        'Search for a customer' => 'ค้นหาลูกค้า',
        'Add email address %s to the To field' => 'เพิ่มที่อยู่อีเมล% s ไปยังช่อง \'ไปยัง\'',
        'Add email address %s to the Cc field' => 'เพิ่มที่อยู่อีเมล% s ไปยังช่อง \'สำเนาถึง\'',
        'Add email address %s to the Bcc field' => 'เพิ่มที่อยู่อีเมล% s ไปยังช่อง \'สำเนาลับ\'',
        'Apply' => 'นำไปใช้',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'ศูนย์ข้อมูลลูกค้า',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'ลูกค้าผู้ใช้',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'รายการป้อนที่ซ้ำกัน',
        'This address already exists on the address list.' => 'ที่อยู่นี้มีอยู่แล้วในรายการที่อยู่',
        'It is going to be deleted from the field, please try again.' => 'มันจะถูกลบออกจากฟิลด์โปรดลองอีกครั้ง',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'หมายเหตุ: ลูกค้านี้ไม่ถูกต้อง!',
        'Start chat' => 'เริ่มแชท',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTRS Daemon เป็นกระบวนการดีมอนที่ดำเนินงานไม่ตรงกันเช่น เพิ่มตั๋ววิกฤติ, การส่งอีเมล์และอื่น ๆ',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'OTRS Daemon ที่ใช้งานมีผลบังคับใช้สำหรับการทำงานของระบบที่ถูกต้อง',
        'Starting the OTRS Daemon' => 'เริ่มต้น OTRS Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'ตรวจสอบให้แน่ใจว่าไฟล์ \'%s\' มีอยู่ (โดยไม่มีนามสกุล .dist) งาน cron นี้จะตรวจสอบทุกๆ 5 นาทีถ้าOTRS Daemonกำลังทำงานอยู่และเริ่มต้นมันถ้าจำเป็น',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'ดำเนิน \'%sการเริ่มต้น\' เพื่อให้แน่ใจว่างาน cron ของผู้ใช้ \'otrs\' มีการใช้งาน',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'หลังจาก 5 นาทีตรวจสอบดูว่า OTRS Daemonกำลังทำงานในระบบ (\'bin / otrs.Daemon.pl status\')',

        # Template: AgentDashboard
        'Dashboard' => 'แดชบอร์ด',

        # Template: AgentDashboardCalendarOverview
        'in' => 'ใน',

        # Template: AgentDashboardCommon
        'Save settings' => 'บันทึกการตั้งค่า',
        'Close this widget' => 'ปิดเครื่องมือนี้',
        'Available Columns' => 'คอลัมน์ที่พร้อมใช้งาน',
        'Visible Columns (order by drag & drop)' => 'คอลัมน์ที่มองเห็นได้ (จัดเรียงโดยการลากและวาง)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'ตั๋วการขยาย',

        # Template: AgentDashboardCustomerUserList
        'Customer login' => 'ล็อคอินลูกค้า',
        'Customer information' => 'ข้อมูลลูกค้า',
        'Phone ticket' => 'ตั๋วจากโทรศัพท์',
        'Email ticket' => 'อีเมล์ตั๋ว',
        '%s open ticket(s) of %s' => '% s ตั๋วเปิด (s) ของ% s',
        '%s closed ticket(s) of %s' => '% s ตั๋วที่ปิดแล้ว (s) ของ% s',
        'New phone ticket from %s' => 'ตั๋วทางโทรศัพท์ใหม่จาก% s',
        'New email ticket to %s' => 'ตั๋วอีเมลใหม่% s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s สามารถใช้ได้!',
        'Please update now.' => 'โปรดอัปเดตตอนนี้',
        'Release Note' => 'เผยแพร่โน้ต',
        'Level' => 'ระดับ',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'โพสต์เมื่อ %s ที่ผ่านมา',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'การกำหนดค่าสำหรับเครื่องมือสถิตินี้มีข้อผิดพลาดโปรดตรวจสอบการตั้งค่าของคุณ',
        'Download as SVG file' => 'ดาวน์โหลดเป็นไฟล์ SVG',
        'Download as PNG file' => 'ดาวน์โหลดเป็นไฟล์ PNG',
        'Download as CSV file' => 'ดาวน์โหลดเป็นไฟล์ CSV',
        'Download as Excel file' => 'ดาวน์โหลดเป็นไฟล์ Excel',
        'Download as PDF file' => 'ดาวน์โหลดเป็นไฟล์ PDF',
        'Grouped' => 'จัดกลุ่ม',
        'Stacked' => 'ซ้อนกัน',
        'Expanded' => 'มีการขยาย',
        'Stream' => 'สตรีม',
        'No Data Available.' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'โปรดเลือกรูปแบบการออกกราฟที่ถูกต้องในการกำหนดค่าของเครื่องมือนี้',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'เนื้อหาของสถิตินี้จะถูกเตรียมไว้สำหรับคุณโปรดอดทนรอ',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'สถิตินี้ไม่สามารถถูกนำมาใช้ในขณะนี้ได้เพราะการกำหนดค่าของจำเป็นต้องได้รับการแก้ไขโดยผู้ดูแลระบบสถิติ',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'ตั๋วที่ถูกล็อคของฉัน',
        'My watched tickets' => 'ตั๋วดูแล้วของฉัน',
        'My responsibilities' => 'ความรับผิดชอบของฉัน',
        'Tickets in My Queues' => 'ตั๋วในคิวของฉัน',
        'Tickets in My Services' => 'ตั๋วในการบริการของฉัน',
        'Service Time' => 'เวลาบริการ',
        'Remove active filters for this widget.' => 'ลบตัวกรองการใช้งานสำหรับเครื่องมือนี้',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'ผลรวม',

        # Template: AgentDashboardUserOnline
        'out of office' => 'นอกออฟฟิศ',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'จนถึง',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'ตั๋วถูกล็อค',
        'Undo & close' => 'เลิกทำและปิด',

        # Template: AgentInfo
        'Info' => 'ข้อมูล',
        'To accept some news, a license or some changes.' => 'ในการรับข่าว ใบอนุญาตหรือการเปลี่ยนแปลงบางอย่าง',

        # Template: AgentLinkObject
        'Link Object: %s' => 'การเชื่อมโยงออบเจค: %s',
        'go to link delete screen' => 'ไปยังลิงค์หน้าจอการลบ',
        'Select Target Object' => 'เลือกออบเจคของเป้าหมาย',
        'Link object %s with' => '',
        'Unlink Object: %s' => 'ยกเลิกการเชื่อมโยงออบเจค: %s',
        'go to link add screen' => 'ไปยังลิงค์หน้าจอการเพิ่ม',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'แก้ไขการตั้งค่าของคุณ',
        'Did you know? You can help translating OTRS at %s.' => 'คุณรู้หรือไม่ว่าคุณสามารถช่วยแปลOTRSที่% s ?',

        # Template: AgentSpelling
        'Spell Checker' => 'ตัวตรวจสอบการสะกด',
        'spelling error(s)' => 'ข้อผิดพลาดในการสะกดคำ (s)',
        'Apply these changes' => 'ใช้การเปลี่ยนแปลงเหล่านี้',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => 'สถิติ » เพิ่ม',
        'Add New Statistic' => 'เพิ่มสถิติใหม่',
        'Dynamic Matrix' => 'เมทริกซ์ไดนามิค',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            'ตารางรายงานข้อมูลที่แต่ละช่องประกอบด้วยจุดเอกพจน์ข้อมูล (เช่นหมายเลขของตั๋ว)',
        'Dynamic List' => 'รายชื่อไดนามิค',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            'ตารางข้อมูลการรายงานที่แต่ละแถวมีข้อมูลของหนึ่งแอนตีตี้ (เช่นตั๋ว)',
        'Static' => 'คงที่',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            'สถิติซับซ้อนไม่สามารถกำหนดค่าและอาจจะส่งข้อมูลที่ไม่ใช่แบบตารางกลับมา',
        'General Specification' => 'รายละเอียดทั่วไป',
        'Create Statistic' => 'สร้างสถิติ',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => 'สถิติ » แก้ไข %s %s -%s',
        'Run now' => 'รันตอนนี้',
        'Statistics Preview' => 'ตัวอย่างสถิติ',
        'Save statistic' => 'บันทึกสถิติ',

        # Template: AgentStatisticsImport
        'Statistics » Import' => 'สถิติ»นำเข้า',
        'Import Statistic Configuration' => 'นำเข้าการกำหนดค่าสถิติ',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => 'สถิติ»ภาพรวม',
        'Statistics' => 'สถิติ',
        'Run' => 'iyo',
        'Edit statistic "%s".' => 'แก้ไขสถิติ "%s"',
        'Export statistic "%s"' => 'ส่งออกสถิติ "%s"',
        'Export statistic %s' => 'แก้ไขสถิติ %s',
        'Delete statistic "%s"' => 'ลบสถิติ "%s"',
        'Delete statistic %s' => 'ลบสถิติ %s',
        'Do you really want to delete this statistic?' => 'คุณต้องการที่จะลบสถิตินี้หรือไม่?',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => 'สถิติ » ดู %s%s — %s',
        'Statistic Information' => 'ข้อมูลสถิติ',
        'Sum rows' => 'ผลรวมของแถว',
        'Sum columns' => 'ผลรวมของคอลัมน์',
        'Show as dashboard widget' => 'แสดงเป็นเครื่องมือแดชบอร์ด',
        'Cache' => 'แคช',
        'This statistic contains configuration errors and can currently not be used.' =>
            'สถิตินี้ประกอบด้วยข้อผิดพลาดการตั้งค่าและไม่สามารถใช้งานได้ในขณะนี้',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => '',
        'Close %s%s%s' => '',
        'Add Note to %s%s%s' => '',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => '',
        'Change Responsible of %s%s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => 'ฟิลด์ที่มีเครื่องหมายดอกจันทั้งหมด (*) มีผลบังคับใช้',
        'Service invalid.' => 'การบริการที่ใช้ไม่ได้',
        'New Owner' => 'เจ้าของใหม่',
        'Please set a new owner!' => 'โปรดกำหนดเจ้าของใหม่!',
        'New Responsible' => 'ความรับผิดชอบใหม่',
        'Next state' => 'สถานะถัดไป',
        'For all pending* states.' => 'สำหรับสถานะที่ค้างอยู่ทั้งหมด *',
        'Add Article' => 'เพิ่มบทความ',
        'Create an Article' => 'สร้างบทความ',
        'Inform agents' => 'แจ้งเอเย่นต์',
        'Inform involved agents' => 'แจ้งเอเย่นต์ที่เกี่ยวข้อง',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'คุณสามารถเลือกเอเย่นต์เพิ่มเติมที่นี้ซึ่งควรได้รับการแจ้งเตือนเกี่ยวกับบทความใหม่',
        'Text will also be received by' => '',
        'Spell check' => 'ตรวจสอบการสะกด',
        'Text Template' => 'รูปแบบข้อความ',
        'Setting a template will overwrite any text or attachment.' => 'การตั้งค่าแม่แบบจะเขียนทับข้อความหรือสิ่งที่แนบมา',
        'Note type' => 'ประเภทโน้ต',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'การตีกลับไปยัง',
        'You need a email address.' => 'คุณจำเป็นต้องมีที่อยู่อีเมล',
        'Need a valid email address or don\'t use a local email address.' =>
            'ต้องการที่อยู่อีเมลที่ถูกต้องหรือไม่ใช้ที่อยู่อีเมลในท้องถิ่น',
        'Next ticket state' => 'สถานะถัดไปของตั๋ว',
        'Inform sender' => 'แจ้งผู้ส่ง',
        'Send mail' => 'ส่งอีเมล์',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'ตั๋วการทำงานเป็นกลุ่ม',
        'Send Email' => 'ส่งอีเมล์',
        'Merge to' => 'ผสานไปยัง',
        'Invalid ticket identifier!' => 'ตัวระบุตั๋วไม่ถูกต้อง!',
        'Merge to oldest' => 'ผสานไปยังเก่าแก่ที่สุด',
        'Link together' => 'เชื่อมโยงกัน',
        'Link to parent' => 'เชื่อมโยงไปยัง parent',
        'Unlock tickets' => 'ปลดล็อคตั๋ว',
        'Execute Bulk Action' => 'เริ่มดำเนินการเป็นกลุ่ม',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            'ที่อยู่นี้ถูกลงทะเบียนเป็นที่อยู่ในระบบและไม่สามารถนำมาใช้: %s',
        'Please include at least one recipient' => 'โปรดระบุผู้รับอย่างน้อยหนึ่งคน',
        'Remove Ticket Customer' => 'ลบตั๋วลูกค้า',
        'Please remove this entry and enter a new one with the correct value.' =>
            'โปรดลบข้อมูลนี้และป้อนใหม่ด้วยค่าที่ถูกต้อง',
        'Remove Cc' => 'ลบสำเนา',
        'Remove Bcc' => 'ลบสำเนาลับ',
        'Address book' => 'สมุดที่อยู่',
        'Date Invalid!' => 'วันที่ไม่ถูกต้อง!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'สร้างอีเมล์ตั๋วใหม่',
        'Example Template' => 'ตัวอย่างแม่แบบ',
        'From queue' => 'จากคิว',
        'To customer user' => 'ถึงลูกค้าผู้ใช้',
        'Please include at least one customer user for the ticket.' => 'โปรดระบุอย่างน้อยหนึ่งลูกค้าผู้ใช้สำหรับตั๋ว',
        'Select this customer as the main customer.' => 'เลือกลูกค้ารายนี้เป็นลูกค้าหลัก',
        'Remove Ticket Customer User' => 'นำตั๋วลูกค้าผู้ใช้ออก',
        'Get all' => 'ได้รับทั้งหมด',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'ตั๋ว %s: หมดเวลาสำหรับตอบสนองครั้งแรก (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'ตั๋ว %s: เวลาตอบสนองครั้งแรกจะหมดเวลาภายใน %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'ตั๋ว %s: หมดเวลาอัพเดท (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'ตั๋ว %s: เวลาอัพเดตจะหมดภายใน %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'ตั๋ว %s: หมดเวลาสำหรับการแก้ปัญหา (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'ตั๋ว %s: เวลาการแก้ปัญหาจะจบลงภายใน %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'History Content' => 'เนื้อหาประวัติ',
        'Zoom view' => 'มุมมองการซูม',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => 'การตั้งค่าการผสาน',
        'You need to use a ticket number!' => 'คุณจำเป็นต้องใช้หมายเลขตั๋ว!',
        'A valid ticket number is required.' => 'จำเป็นต้องใช้หมายเลขตั๋วที่ถูกต้อง',
        'Need a valid email address.' => 'ต้องการที่อยู่อีเมลที่ถูกต้อง',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'คิวใหม่',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'เลือกทั้งหมด',
        'No ticket data found.' => 'ไม่พบข้อมูลตั๋ว',
        'Open / Close ticket action menu' => 'เปิด/ปิดเมนูตั๋วการดำเนินการ',
        'Select this ticket' => 'เลือกตั๋วนี้',
        'First Response Time' => 'เวลาตอบสนองครั้งแรก',
        'Update Time' => 'เวลาการอัพเดต',
        'Solution Time' => 'เวลาการแก้ปัญหา',
        'Move ticket to a different queue' => 'ย้ายตั๋วไปคิวอื่น',
        'Change queue' => 'เปลี่ยนคิว',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'เปลี่ยนตัวเลือกการค้นหา',
        'Remove active filters for this screen.' => 'ลบตัวกรองที่ใช้งานอยู่สำหรับหน้าจอนี้',
        'Tickets per page' => 'ตั๋วต่อหนึ่งหน้า',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'รีเซ็ตภาพรวม',
        'Column Filters Form' => 'คอลัมน์แบบฟอร์มตัวกรอง',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'แบ่งออกเป็นตั๋วโทรศัพท์ใหม่',
        'Save Chat Into New Phone Ticket' => 'บันทึกแชทลงในตั๋วโทรศัพท์ใหม่',
        'Create New Phone Ticket' => 'สร้างตั๋วจากโทรศัพท์ใหม่ ',
        'Please include at least one customer for the ticket.' => 'กรุณาระบุลูกค้าอย่างน้อยหนึ่งคนสำหรับตั๋ว',
        'To queue' => 'ไปยังคิว',
        'Chat protocol' => 'การแชทโปรโตคอล',
        'The chat will be appended as a separate article.' => 'แชทจะถูกผนวกเป็นบทความที่แยกต่างหาก',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'ว่าง',
        'Download this email' => 'ดาวน์โหลดอีเมล์นี้',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'สร้างการประมวลผลตั๋วใหม่',
        'Process' => 'ขั้นตอน',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'ลงทะเบียนตั๋วเข้าไปในการประมวลผล',

        # Template: AgentTicketSearch
        'Search template' => 'รูปแบบการค้นหา',
        'Create Template' => 'สร้างแม่แบบ',
        'Create New' => 'สร้างใหม่',
        'Profile link' => 'ข้อมูลการเชื่อมโยง',
        'Save changes in template' => 'บันทึกการเปลี่ยนแปลงในแม่แบบ',
        'Filters in use' => 'ตัวกรองที่ใช้งาน',
        'Additional filters' => 'ตัวกรองเพิ่มเติม',
        'Add another attribute' => 'เพิ่มแอตทริบิวต์อื่น',
        'Output' => 'ข้อมูลที่ส่งออกมา',
        'Fulltext' => 'ข้อความฉบับเต็ม',
        'Remove' => 'ลบ',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'การค้นหาในแอตทริบิวต์ จาก ถึง สำเนา เรื่องและเนื้อเรื่องของบทความ การแทนที่คุณลักษณะอื่น ๆ ที่มีชื่อเดียวกัน',
        'CustomerID (complex search)' => '',
        '(e. g. 234*)' => '',
        'CustomerID (exact match)' => '',
        'Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Customer User Login (exact match)' => '',
        'Attachment Name' => 'ชื่อเอกสารที่แนบมา',
        '(e. g. m*file or myfi*)' => '(เช่น. m*file or myfi*)',
        'Created in Queue' => 'สร้างขึ้นในคิว',
        'Lock state' => 'สถานะการล็อค',
        'Watcher' => 'ผู้เฝ้าดู',
        'Article Create Time (before/after)' => 'เวลาที่สร้างบทความ (ก่อน/หลัง)',
        'Article Create Time (between)' => 'เวลาที่สร้างบทความ(ในระหว่าง)',
        'Invalid date' => '',
        'Ticket Create Time (before/after)' => 'เวลาที่สร้างตั๋ว (ก่อน/หลัง)',
        'Ticket Create Time (between)' => 'เวลาที่สร้างตั๋ว (ในระหว่าง)',
        'Ticket Change Time (before/after)' => 'เวลาที่เปลี่ยนตั๋ว (ก่อน/หลัง)',
        'Ticket Change Time (between)' => 'เวลาที่เปลี่ยนตั๋ว (ในระหว่าง)',
        'Ticket Last Change Time (before/after)' => 'เวลาที่เปลี่ยนตั๋วครั้งล่าสุด (ก่อน/หลัง)',
        'Ticket Last Change Time (between)' => 'เวลาที่เปลี่ยนตั๋วครั้งล่าสุด (ในระหว่าง)',
        'Ticket Close Time (before/after)' => 'เวลาที่ปิดตั๋ว (ก่อน/หลัง)',
        'Ticket Close Time (between)' => 'เวลาที่ปิดตั๋ว (ในระหว่าง)',
        'Ticket Escalation Time (before/after)' => 'เวลาการขยายตั๋ว (ก่อน/หลัง)',
        'Ticket Escalation Time (between)' => 'เวลาการขยายตั๋ว(ในระหว่าง)',
        'Archive Search' => 'ค้นหาเอกสารเก่า',
        'Run search' => 'ดำเนินการค้นหา',

        # Template: AgentTicketZoom
        'Article filter' => 'ตัวกรองบทความ',
        'Article Type' => 'ประเภทของบทความ',
        'Sender Type' => 'ประเภทผู้ส่ง',
        'Save filter settings as default' => 'บันทึกการตั้งค่าตัวกรองเป็นค่าเริ่มต้น',
        'Event Type Filter' => 'กิจกรรมของประเภทตัวกรอง',
        'Event Type' => 'ประเภทของกิจกรรม',
        'Save as default' => 'บันทึกเป็นค่าเริ่มต้น',
        'Archive' => 'เอกสารเก่า',
        'This ticket is archived.' => 'จัดเก็บตั๋วนี่แล้ว',
        'Note: Type is invalid!' => 'หมายเหตุ: ประเภทไม่ถูกต้อง!',
        'Locked' => 'ถูกล็อค',
        'Accounted time' => 'เวลาที่คิด',
        'Linked Objects' => 'การเชื่อมโยงออบเจค',
        'Change Queue' => 'เปลี่ยนคิว',
        'There are no dialogs available at this point in the process.' =>
            'ไม่มีไดอะล็อกที่สามารถใช้ได้ในกระบวนการนี้',
        'This item has no articles yet.' => 'ไอเท็มนี้ยังไม่มีบทความ',
        'Ticket Timeline View' => 'มุมมองไทม์ไลน์ตั๋ว',
        'Article Overview' => 'ภาพรวมของบทความ',
        'Article(s)' => 'บทความ(s)',
        'Page' => 'หน้า',
        'Add Filter' => 'เพิ่มตัวกรอง',
        'Set' => 'กำหนด',
        'Reset Filter' => 'รีเซตตัวกรอง',
        'Show one article' => 'แสดงหนึ่งบทความ',
        'Show all articles' => 'แสดงบทความทั้งหมด',
        'Show Ticket Timeline View' => 'แสดงมุมมองไทม์ไลน์ตั๋ว',
        'Unread articles' => 'บทความที่ยังไม่ได้อ่าน ',
        'No.' => 'หมายเลข',
        'Important' => 'สำคัญ',
        'Unread Article!' => 'บทความที่ยังไม่ได้อ่าน!',
        'Incoming message' => 'ข้อความขาเข้า',
        'Outgoing message' => 'ข้อความขาออก',
        'Internal message' => 'ข้อความภายใน',
        'Resize' => 'ปรับขนาด',
        'Mark this article as read' => 'มาร์คว่าได้อ่านบทความนี้แล้ว',
        'Show Full Text' => 'แสดงข้อความแบบเต็ม',
        'Full Article Text' => 'ข้อความบทความเต็ม',
        'No more events found. Please try changing the filter settings.' =>
            'ไม่พบกิจกรรมอื่นๆ โปรดลองเปลี่ยนการตั้งค่าตัวกรอง',
        'by' => 'โดย',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'ในการเปิดการเชื่อมโยงในบทความต่อไปนี้คุณอาจต้องกด Ctrl หรือ Cmd หรือ Shift ค้างไว้ขณะที่คลิกที่ลิงค์ (ขึ้นอยู่กับเบราว์เซอร์ของคุณและ OS)',
        'Close this message' => 'ปิดข้อความนี้',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'ไม่สามารถเปิดบทความ! บางทีมันอาจจะอยู่บนหน้าบทความอื่นได้หรือไม่?',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'เพื่อปกป้องความเป็นส่วนตัวของคุณ เนื้อหาระยะไกลถูกบล็อก',
        'Load blocked content.' => 'โหลดเนื้อหาที่ถูกบล็อก',

        # Template: ChatStartForm
        'First message' => 'ข้อความแรก',

        # Template: CloudServicesDisabled
        'This feature requires cloud services.' => 'ฟีเจอร์นี้ต้องใช้บริการคลาวด์',
        'You can' => 'คุณสามารถ',
        'go back to the previous page' => 'กลับไปที่หน้าก่อนหน้านี้',

        # Template: CustomerAccept
        'Information' => 'ข้อมูล',
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accepted your license.' => '',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => 'รายละเอียด ข้อผิดพลาด',
        'Traceback' => 'ตรวจสอบย้อนกลับ',

        # Template: CustomerFooter
        'Powered by' => 'ให้การสนับสนุนโดย',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'มีหนึ่งหรือมากกว่าหนึ่งข้อผิดพลาดเกิดขึ้น!',
        'Close this dialog' => 'ปิดไดอะล็อกนี้',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'ไม่สามารถเปิดหน้าต่างป๊อปอัพ กรุณาปิดการใช้งานตัวบล็อกป๊อปอัพใดๆสำหรับโปรแกรมนี้',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'ถ้าคุณออกจากหน้านี้ หน้าต่างป๊อปอัพทั้งหมดจะถูกปิดด้วยเช่นกัน!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'ป๊อปอัพของหน้าจอนี้เปิดอยู่แล้ว คุณต้องการที่จะปิดมันและโหลดอันนี้แทน?',
        'There are currently no elements available to select from.' => 'ขณะนี้ไม่มีองค์ประกอบให้เลือกจาก',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'กรุณาปิดโหมดความเข้ากันได้ใน Internet Explorer!',
        'The browser you are using is too old.' => 'เบราว์เซอร์ที่คุณกำลังใช้มันเก่าเกินไป',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS ทำงานกับรายการขนาดใหญ่ของเบราว์เซอร์โปรดอัปเกรดหนึ่งเป็นในจำนวนนี้',
        'Please see the documentation or ask your admin for further information.' =>
            'โปรดอ่านเอกสารหรือขอให้ผู้ดูแลระบบของคุณสำหรับอธิบายข้อมูลเพิ่มเติม',
        'Switch to mobile mode' => 'สลับเป็นโหมดมือถือ',
        'Switch to desktop mode' => 'สลับเป็นโหมดเดสก์ทอป',
        'Not available' => 'ไม่พร้อมใช้งาน',
        'Clear all' => 'ลบทั้งหมด',
        'Clear search' => 'ลบการค้นหา',
        '%s selection(s)...' => '%s การเลือก(s)...',
        'and %s more...' => 'และ %s อื่นๆ...',
        'Filters' => 'ตัวกรอง',
        'Confirm' => 'ยืนยัน',
        'You have unanswered chat requests' => 'คุณมีคำขอร้องแชทที่ยังไม่ได้ตอบ',
        'Accept' => 'ยอมรับ',
        'Decline' => 'ปฏิเสธ',
        'An internal error occurred.' => 'มีข้อผิดพลาดภายในเกิดขึ้น',
        'Connection error' => '',
        'Reload page' => '',
        'Your browser was not able to communicate with OTRS properly, there seems to be something wrong with your network connection. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'There was an error in communication with the server. Server might be experiencing some temporary problems, please reload this page to check if they have been resolved.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'ไม่พร้อมใช้งาน JavaScript',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'เพื่อที่จะได้สัมผัสกับOTRSแล้วคุณจะต้องเปิดใช้งาน JavaScript ในเบราว์เซอร์ของคุณ',
        'Browser Warning' => 'คำเตือนเบราว์เซอร์',
        'One moment please, you are being redirected...' => 'รอสักครู่คุณกำลังถูกนำไป ...',
        'Login' => 'เข้าสู่ระบบ',
        'User name' => 'ชื่อผู้ใช้',
        'Your user name' => 'ชื่อผู้ใช้ของคุณ',
        'Your password' => 'รหัสผ่านของคุณ',
        'Forgot password?' => 'ลืมรหัสผ่าน?',
        '2 Factor Token' => '2 ปัจจัยโทเคน',
        'Your 2 Factor Token' => '2 ปัจจัยโทเคนของคุณ',
        'Log In' => 'เข้าสู่ระบบ',
        'Not yet registered?' => 'ยังไม่ได้ลงทะเบียน?',
        'Request new password' => 'การร้องขอรหัสผ่านใหม่',
        'Your User Name' => 'ชื่อผู้ใช้ของคุณ',
        'A new password will be sent to your email address.' => 'รหัสผ่านใหม่จะถูกส่งไปยังที่อยู่อีเมลของคุณ',
        'Create Account' => 'สร้างบัญชี',
        'Please fill out this form to receive login credentials.' => 'กรุณากรอกแบบฟอร์มนี้เพื่อจะได้รับสิทธิเข้าสู่ระบบ',
        'How we should address you' => 'เราควรทำอย่างไรเพื่อตามหาคุณ',
        'Your First Name' => 'ชื่อของคุณ',
        'Your Last Name' => 'นามสกุลของคุณ',
        'Your email address (this will become your username)' => 'ที่อยู่อีเมลของคุณ (จะกลายเป็นชื่อผู้ใช้ของคุณ)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'การร้องขอแชทขาเข้า',
        'Edit personal preferences' => 'แก้ไขการตั้งค่าส่วนตัว',
        'Logout %s %s' => 'ออกจากระบบ %s %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => 'แยกการอ้างอิง',
        'Open link' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'ข้อตกลงระดับการให้บริการ',

        # Template: CustomerTicketOverview
        'Welcome!' => 'ยินดีต้อนรับ!',
        'Please click the button below to create your first ticket.' => 'กรุณาคลิกที่ปุ่มด้านล่างเพื่อสร้างตั๋วของคุณครั้งแรก',
        'Create your first ticket' => 'สร้างตั๋วของคุณครั้งแรก',

        # Template: CustomerTicketSearch
        'Profile' => 'โปรไฟล์',
        'e. g. 10*5155 or 105658*' => 'เช่น 10*5155 หรือ 105658*',
        'Customer ID' => 'ไอดีลูกค้า',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'ค้นหาแบบฉบับเต็มในตั๋ว FAQ (เช่น "John*n" or "Will*")',
        'Recipient' => 'ผู้รับ',
        'Carbon Copy' => 'สำเนา',
        'e. g. m*file or myfi*' => 'เช่น. m*file or myfi*',
        'Types' => 'ประเภท',
        'Time restrictions' => 'การจำกัดเวลา',
        'No time settings' => 'ไม่มีการตั้งค่าเวลา',
        'Specific date' => 'วันที่เฉพาะเจาะจง',
        'Only tickets created' => 'เฉพาะตั๋วที่สร้างแล้ว',
        'Date range' => 'ช่วงวันที่',
        'Only tickets created between' => 'เฉพาะตั๋วที่สร้างในระหว่าง',
        'Ticket archive system' => 'ระบบเก็บตั๋ว',
        'Save search as template?' => 'บันทึกการค้นหาเป็นแม่แบบ?',
        'Save as Template?' => 'บันทึกเป็นแม่แบบ?',
        'Save as Template' => 'บันทึกเป็นแม่แบบ',
        'Template Name' => 'ชื่อแม่แบบ',
        'Pick a profile name' => 'เลือกชื่อโปรไฟล์',
        'Output to' => 'ส่งออกไปยัง',

        # Template: CustomerTicketSearchResultShort
        'of' => 'ของ',
        'Search Results for' => 'ผลการค้นหาสำหรับ',
        'Remove this Search Term.' => 'ลบคำค้นหานี้',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'เริ่มต้นการสนทนาจากตั๋วนี้',
        'Expand article' => 'Expand article',
        'Next Steps' => 'ขั้นตอนถัดไป',
        'Reply' => 'ตอบกลับ',
        'Chat Protocol' => 'โปรโตคอลแชท',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'ทั้งวัน',
        'Sunday' => 'วันอาทิตย์',
        'Monday' => 'วันจันทร์',
        'Tuesday' => 'วันอังคาร',
        'Wednesday' => 'วันพุธ',
        'Thursday' => 'วันพฤหัสบดี',
        'Friday' => 'วันศุกร์',
        'Saturday' => 'วันเสาร์',
        'Su' => 'อา',
        'Mo' => 'จ',
        'Tu' => 'อ',
        'We' => 'พ',
        'Th' => 'พฤ',
        'Fr' => 'ศ',
        'Sa' => 'ส',
        'Event Information' => 'ข้อมูลกิจกรรม',
        'Ticket fields' => 'ช่องข้อมูลตั๋ว',
        'Dynamic fields' => 'ไดมานิคฟิลด์',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'วันที่ไม่ถูกต้อง (ต้องใช้วันที่ในอนาคต)!',
        'Invalid date (need a past date)!' => 'วันที่ไม่ถูกต้อง (ต้องใช้วันที่ผ่านมา)!',
        'Previous' => 'ก่อนหน้า',
        'Open date selection' => 'การเลือกวันที่เปิด',

        # Template: Error
        'An error occurred.' => 'เกิดข้อผิดพลาด',
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'ส่งรายงานข้อบกพร่อง',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            'กรุณากรอกค่าอย่างน้อยหนึ่งคำค้นหาหรือ* ในการค้นหาอะไรก็ตาม',
        'Please remove the following words from your search as they cannot be searched for:' =>
            'โปรดลบคำต่อไปนี้จากการค้นหาของคุณเนื่องจากไม่สามารถค้นหาได้:',
        'Please check the fields marked as red for valid inputs.' => 'กรุณาตรวจสอบฟิลด์ที่ทำเครื่องหมายสีแดงสำหรับปัจจัยการป้อนข้อมูลที่ถูกต้อง',
        'Please perform a spell check on the the text first.' => 'โปรดดำเนินการตรวจสอบการสะกดในข้อความแรก',
        'Slide the navigation bar' => 'เลื่อนแถบนำทาง',
        'Unavailable for chat' => 'ไม่พร้อมใช้งานสำหรับการสนทนา',
        'Available for internal chats only' => 'พร้อมใช้งานสำหรับการสนทนาภายในเท่านั้น',
        'Available for chats' => 'พร้อมใช้งานสำหรับการสนทนา',
        'Please visit the chat manager' => 'กรุณาเยี่ยมชมผู้จัดการแชท',
        'New personal chat request' => 'การร้องขอแชทส่วนตัวใหม่',
        'New customer chat request' => 'การร้องขอแชทของลูกค้าใหม่',
        'New public chat request' => 'การร้องขอแชทสาธารณะใหม่',
        'Selected user is not available for chat.' => '',
        'New activity' => 'กิจกรรมใหม่',
        'New activity on one of your monitored chats.' => 'กิจกรรมใหม่ของหนึ่งในการสนทนาที่ถูกตรวจสอบของคุณ',
        'Your browser does not support video and audio calling.' => '',
        'Selected user is not available for video and audio call.' => '',
        'Target user\'s browser does not support video and audio calling.' =>
            '',
        'Do you really want to continue?' => 'คุณต้องการที่จะดำเนินการต่อหรือไม่?',
        'Information about the OTRS Daemon' => 'ข้อมูลเกี่ยวกับOTRS Daemon',
        'Communication error' => '',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            'ฟีเจอร์นี้เป็นส่วนหนึ่งของ%s กรุณาติดต่อได้ที่%s สำหรับการอัพเกรด',
        'Find out more about the %s' => 'ค้นหาข้อมูลเพิ่มเติมเกี่ยวกับ %s',

        # Template: Header
        'You are logged in as' => 'คุณได้เข้าสู่ระบบเป็น',

        # Template: Installer
        'JavaScript not available' => 'ไม่พร้อมใช้งาน JavaScript',
        'Step %s' => 'ขั้นตอน %s',
        'Database Settings' => 'การตั้งค่าฐานข้อมูล',
        'General Specifications and Mail Settings' => 'คุณสมบัติทั่วไปและการตั้งค่าเมล์',
        'Finish' => 'เสร็จ',
        'Welcome to %s' => 'ยินดีต้อนรับสู่ %s',
        'Germany' => '',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'เว็บไซต์',
        'Mail check successful.' => 'การตรวจสอบอีเมลประสบความสำเร็จ',
        'Error in the mail settings. Please correct and try again.' => 'เกิดข้อผิดพลาดในการตั้งค่าอีเมล กรุณาแก้ไขและลองอีกครั้ง',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'กำหนดค่าเมล์ขาออก',
        'Outbound mail type' => 'ประเภทอีเมลขาออก',
        'Select outbound mail type.' => 'เลือกประเภทของอีเมลขาออก',
        'Outbound mail port' => 'พอร์ตอีเมลขาออก',
        'Select outbound mail port.' => 'เลือกพอร์ตอีเมลขาออก',
        'SMTP host' => 'โฮสต์ SMTP',
        'SMTP host.' => 'โฮสต์ SMTP',
        'SMTP authentication' => 'การตรวจสอบ SMTP',
        'Does your SMTP host need authentication?' => 'โฮสต์ SMTPของคุณต้องการการตรวจสอบหรือไม่?',
        'SMTP auth user' => 'ผู้ใช้การตรวจสอบ SMTP',
        'Username for SMTP auth.' => 'ชื่อที่ใช้สำหรับการตรวจสอบ SMTP',
        'SMTP auth password' => 'รหัสผ่านการตรวจสอบ SMTP',
        'Password for SMTP auth.' => 'รหัสผ่านของการตรวจสอบ SMTP',
        'Configure Inbound Mail' => 'กำหนดค่าเมล์ขาเข้า',
        'Inbound mail type' => 'ประเภทของจดหมายขาเข้า',
        'Select inbound mail type.' => 'เลือกประเภทของอีเมลขาเข้า',
        'Inbound mail host' => 'โฮสต์อีเมลขาเข้า',
        'Inbound mail host.' => 'โฮสต์อีเมลขาเข้า',
        'Inbound mail user' => 'ผู้ใช้อีเมลขาเข้า',
        'User for inbound mail.' => 'ผู้ใช้สำหรับอีเมลขาเข้า',
        'Inbound mail password' => 'รหัสผ่านอีเมลขาเข้า',
        'Password for inbound mail.' => 'รหัสสำหรับผ่านอีเมลขาเข้า',
        'Result of mail configuration check' => 'ผลของการตรวจสอบการตั้งค่าอีเมล',
        'Check mail configuration' => 'ตรวจสอบการตั้งค่าอีเมล',
        'Skip this step' => 'ข้ามขั้นตอนนี้',

        # Template: InstallerDBResult
        'Database setup successful!' => 'การติดตั้งฐานข้อมูลประสบความสำเร็จ!',

        # Template: InstallerDBStart
        'Install Type' => 'การติดตั้งประเภท',
        'Create a new database for OTRS' => 'สร้างฐานข้อมูลใหม่สำหรับ OTRS',
        'Use an existing database for OTRS' => 'ใช้ฐานข้อมูลที่มีอยู่แล้วสำหรับ OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'ชื่อฐานข้อมูล',
        'Check database settings' => 'ตรวจสอบการตั้งค่าฐานข้อมูล',
        'Result of database check' => 'ผลของการตรวจสอบฐานข้อมูล',
        'Database check successful.' => 'ตรวจสอบฐานข้อมูลประสบความสำเร็จ',
        'Database User' => 'ผู้ใช้ฐานข้อมูล',
        'New' => 'ใหม่',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'ผู้ใช้ฐานข้อมูลใหม่ที่มีการจำกัดสิทธิ์จะถูกสร้างขึ้นสำหรับระบบ OTRSนี้',
        'Repeat Password' => 'ทำซ้ำรหัสผ่าน',
        'Generated password' => 'สร้างรหัสผ่าน',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'รหัสผ่านไม่ตรงกัน',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'พอร์ต',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'เพื่อให้สามารถใช้OTRS คุณจะต้องป้อนบรรทัดต่อไปนี้ในบรรทัดคำสั่งของคุณ (เทอร์มิ / Shell)เป็นหลัก',
        'Restart your webserver' => 'รีสตาร์ทเว็บเซิร์ฟเวอร์ของคุณ',
        'After doing so your OTRS is up and running.' => 'หลังจากทำเช่นนั้น OTRS ของคุณจะขึ้นและทำงาน',
        'Start page' => 'หน้าแรก',
        'Your OTRS Team' => 'ทีมOTRS ของคุณ',

        # Template: InstallerLicense
        'Don\'t accept license' => 'ไม่รับใบอนุญาต',
        'Accept license and continue' => 'รับใบอนุญาตและดำเนินการต่อ',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'ตัวบ่งชี้ของระบบ แต่ละหมายเลขตั๋วและแต่ละเซสชั่นไอดี HTTP ประกอบด้วยหมายเลขนี้',
        'System FQDN' => 'ระบบ FQDN',
        'Fully qualified domain name of your system.' => 'ชื่อโดเมนที่ครบถ้วนของระบบของคุณ',
        'AdminEmail' => 'AdminEmail',
        'Email address of the system administrator.' => 'ที่อยู่อีเมล์ของผู้ดูแลระบบ',
        'Organization' => 'องค์กร',
        'Log' => 'เข้าสู่',
        'LogModule' => 'โมดูลเข้าสู่ระบบ',
        'Log backend to use.' => 'เข้าสู่ระบบแบ็กเอนด์ที่จะใช้',
        'LogFile' => 'LogFile',
        'Webfrontend' => 'Webfrontend',
        'Default language' => 'ภาษาเริ่มต้น',
        'Default language.' => 'ภาษาเริ่มต้น',
        'CheckMXRecord' => 'CheckMXRecord',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'ที่อยู่อีเมลที่ถูกป้อนด้วยตนเองได้รับการตรวจสอบกับระเบียน MX ที่พบใน DNS อย่าใช้ตัวเลือกนี้ถ้า DNS ของคุณช้าหรือไม่สามารถแก้ไขที่อยู่สาธารณะ',

        # Template: LinkObject
        'Object#' => 'ออบเจค#',
        'Add links' => 'เพิ่มลิงค์',
        'Delete links' => 'ลบการเชื่อมโยง',

        # Template: Login
        'Lost your password?' => 'ลืมรหัสผ่านของคุณ?',
        'Request New Password' => 'การร้องขอรหัสผ่านใหม่',
        'Back to login' => 'กลับไปเข้าสู่ระบบ',

        # Template: MetaFloater
        'Scale preview content' => 'ตัวอย่างสเกลเนื้อหา',
        'Open URL in new tab' => 'เปิด URL ในแท็บใหม่',
        'Close preview' => 'ปิดการแสดงตัวอย่าง',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not available' => 'ฟีเจอร์ไม่สามารถใช้ได้',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'ขออภัยฟีเจอร์นี้ของOTRS ไม่สามารถใช้งานกับโทรศัพท์มือถือได้ขณะนี้ หากคุณต้องการที่จะใช้มันคุณสามารถสลับไปยังโหมดเดสก์ทอปหรือเดสก์ทอปของคุณตามปกติ',

        # Template: Motd
        'Message of the Day' => 'ข้อความประจำวัน',
        'This is the message of the day. You can edit this in %s.' => 'ข้อความนี้เป็นข้อความของวันนี้ คุณสามารถแก้ไขนี้',

        # Template: NoPermission
        'Insufficient Rights' => 'สิทธิ์ไม่เพียงพอ',
        'Back to the previous page' => 'กลับไปที่หน้าก่อนหน้านี้',

        # Template: Pagination
        'Show first page' => 'แสดงหน้าแรก',
        'Show previous pages' => 'แสดงหน้าก่อนหน้านี้',
        'Show page %s' => 'แสดงหน้า% s',
        'Show next pages' => 'แสดงหน้าถัดไป',
        'Show last page' => 'แสดงหน้าสุดท้าย',

        # Template: PictureUpload
        'Need FormID!' => 'ต้องการ formID!',
        'No file found!' => 'ไม่พบไฟล์!',
        'The file is not an image that can be shown inline!' => 'ไฟล์ไม่ใช่ภาพที่สามารถแสดงให้เห็นแบบอินไลน์!',

        # Template: PreferencesNotificationEvent
        'Notification' => 'การแจ้งเตือน',
        'No user configurable notifications found.' => 'ไม่พบผู้ใช้ที่สามารถกำหนดค่าการแจ้งเตือน',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'ได้รับข้อความสำหรับการแจ้งเตือน \'%s\' ด้วยวิธีการขนส่ง \'%s\'',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'โปรดทราบว่าคุณไม่สามารถปิดการใช้งานการแจ้งเตือนที่ระบุว่าเป็นที่บังคับใช้อย่างสมบูรณ์',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'ขออภัยคุณไม่สามารถปิดการใช้งานวิธีการทั้งหมดสำหรับการแจ้งเตือนที่ระบุว่าเป็นที่บังคับใช้',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'ขออภัยคุณไม่สามารถปิดการใช้งานวิธีการทั้งหมดสำหรับการแจ้งเตือนนี้',

        # Template: ActivityDialogHeader
        'Process Information' => 'ข้อมูลกระบวนการ',
        'Dialog' => 'ไดอะล็อก',

        # Template: Article
        'Inform Agent' => 'แจ้งเอเย่นต์',

        # Template: PublicDefault
        'Welcome' => 'ยินดีต้อนรับ',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            'นี่คืออินเตอร์เฟซสาธารณะเริ่มต้นของ OTRS! ไม่มีพารามิเตอร์การกระทำที่กำหนด',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'คุณสามารถติดตั้งโมดูลสาธารณะที่สามารถกำหนดเอง (ผ่านผู้จัดการแพคเกจ) เช่นโมดูลFAQซึ่งมีอินเตอร์เฟซสาธารณะ',

        # Template: RichTextEditor
        'Remove Quote' => 'ลบคิว',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'การอนุญาต',
        'You can select one or more groups to define access for different agents.' =>
            'คุณสามารถเลือกหนึ่งหรือมากกว่าหนึ่งกลุ่มเพื่อกำหนดการเข้าถึงสำหรับเอเย่นต์ที่แตกต่างกัน',
        'Result formats' => 'รูปแบบผลลัพธ์',
        'The selected time periods in the statistic are time zone neutral.' =>
            'ช่วงเวลาที่เลือกไว้ในสถิติเป็นโซนเวลาที่เป็นกลาง',
        'Create summation row' => 'สร้างแถวผลรวม',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => 'สร้างคอลัมน์ผลรวม',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => 'ผลการแคช',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'จัดเตรียมสถิติเป็นเครื่องมือที่เอเย่นต์สามารถเปิดใช้งานในแดชบอร์ดของพวกเขา',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'โปรดทราบว่าการเปิดใช้เครื่องมือแผงควบคุมจะเปิดใช้งานแคชสำหรับสถิตินี้ในแดชบอร์ด',
        'If set to invalid end users can not generate the stat.' => 'ถ้าตั้งค่าเป็นผู้ใช้ที่ไม่ถูกต้องจะไม่สามารถสร้างสถิติ',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'มีปัญหาในการกำหนดค่าของสถิตินี้คือ:',
        'You may now configure the X-axis of your statistic.' => 'คุณสามารถกำหนดค่าแกน X ของสถิติของคุณในขณะนี้',
        'This statistic does not provide preview data.' => 'สถิตินี้ไม่ได้ให้ข้อมูลที่แสดงตัวอย่าง',
        'Preview format:' => 'รูปแบบการแสดงตัวอย่าง:',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'โปรดทราบว่าตัวอย่างใช้ข้อมูลแบบสุ่มและไม่พิจารณาตัวกรองข้อมูล',
        'Configure X-Axis' => 'กำหนดค่าแกน X',
        'X-axis' => 'แกน X',
        'Configure Y-Axis' => 'กำหนดค่าแกน Y',
        'Y-axis' => 'แกน Y',
        'Configure Filter' => 'การกำหนดค่าตัวกรอง',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'กรุณาเลือกเพียงหนึ่งองค์ประกอบหรือปิดปุ่ม \'คงที่\'',
        'Absolute period' => 'ช่วงเวลาที่แน่นอน',
        'Between' => 'ระหว่าง',
        'Relative period' => 'ระยะเวลาที่สัมพันธ์กัน',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'ความสมบูรณ์ที่ผ่านมา %s และความสมบูรณ์ในปัจจุบัน+ ที่กำลังจะเกิดขึ้น',
        'Do not allow changes to this element when the statistic is generated.' =>
            'ไม่อนุญาตให้มีการเปลี่ยนแปลงองค์ประกอบนี้เมื่อสถิติจะถูกสร้างขึ้น',

        # Template: StatsParamsWidget
        'Format' => 'รูปแบบ',
        'Exchange Axis' => 'แลกเปลี่ยนแกน',
        'Configurable params of static stat' => 'พารามิเตอร์ที่กำหนดค่าได้ของสถิติแบบคงที่',
        'No element selected.' => 'ไม่มีองค์ประกอบที่ถูกเลือก',
        'Scale' => 'สเกล',
        'show more' => '',
        'show less' => '',

        # Template: D3
        'Download SVG' => 'ดาวน์โหลด SVG',
        'Download PNG' => 'ดาวน์โหลด PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'ช่วงเวลาที่ถูกเลือกจะกำหนดกรอบเวลาเริ่มต้นสำหรับสถิตินี้ในการเก็บรวบรวมข้อมูลจาก',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'กำหนดหน่วยเวลาที่จะใช้ในการแยกช่วงเวลาที่ถูกเลือกเข้าไปในการรายงานข้อมูลด้าน',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'โปรดจำไว้ว่าขนาดสำหรับแกน Y จะต้องมีขนาดใหญ่กว่าขนาดสำหรับแกน X (เช่นแกน X => เดือนที่แกน Y => ปี)',

        # Template: Test
        'OTRS Test Page' => 'หน้าการทดสอบ OTRS',
        'Welcome %s %s' => 'ยินดีต้อนรับ %s %s',
        'Counter' => 'ตัวนับ',

        # Template: Warning
        'Go back to the previous page' => 'กลับไปที่หน้าก่อนหน้านี้',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'View system log messages.' => 'ดูข้อความเข้าสู่ระบบ',
        'Update and extend your system with software packages.' => 'ปรับปรุงและขยายระบบของคุณด้วยซอฟแวร์',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ACLsไม่สามารถนำเข้าเนื่องจากข้อผิดพลาดที่ไม่ทราบโปรดตรวจสอบการล็อก OTRS สำหรับข้อมูลเพิ่มเติม',
        'The following ACLs have been added successfully: %s' => 'ACLs ดังต่อไปนี้ได้รับการเพิ่มเรียบร้อยแล้ว: %s',
        'The following ACLs have been updated successfully: %s' => 'ACLs ดังต่อไปนี้ได้รับการปรับปรุงเรียบร้อยแล้ว: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'มีข้อผิดพลาดการเพิ่ม / อัปเดต ACLs ดังต่อไปนี้ได้:% s กรุณาตรวจสอบแฟ้มบันทึกสำหรับข้อมูลเพิ่มเติม',
        'This field is required' => 'ต้องระบุข้อมูลนี้',
        'There was an error creating the ACL' => 'มีข้อผิดพลาดในการสร้าง ACL ',
        'Need ACLID!' => 'ต้องการ ACLID!',
        'Could not get data for ACLID %s' => 'ไม่สามารถรับข้อมูลสำหรับ ACLID %s',
        'There was an error updating the ACL' => 'มีข้อผิดพลาดการอัพเดท ACL ',
        'There was an error setting the entity sync status.' => 'มีข้อผิดพลาดการตั้งค่าสถานะของเอนทิตีการซิงค์',
        'There was an error synchronizing the ACLs.' => 'มีข้อผิดพลาดในการทำข้อมูล ACLs ให้ตรงกัน',
        'ACL %s could not be deleted' => 'ACL %s ไม่สามารถลบ',
        'There was an error getting data for ACL with ID %s' => 'มีข้อผิดพลาดในการรับข้อมูลสำหรับ ACL ด้วย ID %s',
        'Exact match' => 'คู่ที่เหมาะสม',
        'Negated exact match' => 'คู่ที่เหมาะสมเป็นลบ',
        'Regular expression' => 'การแสดงผลทั่วไป',
        'Regular expression (ignore case)' => 'แสดงออกปกติ (IgnoreCase)',
        'Negated regular expression' => 'แสดงออกปกติเป็นลบ',
        'Negated regular expression (ignore case)' => 'แสดงออกปกติเป็นลบ (ignore case)',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer Company %s already exists!' => 'ลูกค้าบริษัท %s มีอยู่แล้ว!',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'ตั๋วทางโทรศัพท์ใหม่',
        'New email ticket' => 'ตั๋วอีเมลใหม่',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'การตั้งค่าฟิลด์ไม่ถูกต้อง',
        'Objects configuration is not valid' => 'การกำหนดค่าออบเจคไม่ถูกต้อง',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'ไม่สามารถรีเซ็ตคำสั่งฟิลด์ไดนามิกอย่างถูกต้องโปรดตรวจสอบบันทึกข้อผิดพลาดสำหรับรายละเอียดเพิ่มเติม',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'subaction ที่ไม่ได้กำหนด',
        'Need %s' => 'ต้องการ %s',
        'The field does not contain only ASCII letters and numbers.' => 'ฟิลด์ไม่ประกอบด้วยตัวอักษร ASCII และตัวเลข',
        'There is another field with the same name.' => 'มีฟิลด์อื่นที่มีชื่อเดียวกัน',
        'The field must be numeric.' => 'ข้อมูลนี้ต้องเป็นตัวเลข',
        'Need ValidID' => 'ต้องการ ValidID',
        'Could not create the new field' => 'ไม่สามารถสร้างฟิลด์ใหม่',
        'Need ID' => 'ต้องการ ID',
        'Could not get data for dynamic field %s' => 'ไม่สามารถรับข้อมูลสำหรับข้อมูลแบบไดนามิก %s',
        'The name for this field should not change.' => 'ชื่อข้อมูลนี้ไม่ควรเปลี่ยน',
        'Could not update the field %s' => 'ไม่สามารถปรับปรุงฟิลด์ %s',
        'Currently' => 'ปัจจุบัน',
        'Unchecked' => 'ยกเลิกการทำเครื่องหมาย',
        'Checked' => 'ตรวจสอบ',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'ป้องกันการเข้ามาของวันที่ในอนาคต',
        'Prevent entry of dates in the past' => 'ป้องกันการเข้ามาของวันที่ในอดีตที่ผ่านมา',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => 'ค่าข้อมูลในช่องนี้ซ้ำ',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'เลือกผู้รับอย่างน้อยหนึ่งคน',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'archive tickets' => 'ตั๋วที่เก็บถาวร',
        'restore tickets from archive' => 'คืนค่าตั๋วจากคลัง',
        'Need Profile!' => 'ต้องมีโปรไฟล์!',
        'Got no values to check.' => 'ไม่มีค่าสำหรับเช็ค',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'โปรดลบคำต่อไปนี้เพราะมันไม่สามารถนำมาใช้สำหรับการเลือกตั๋ว:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'ต้องการ WebserviceID!',
        'Could not get data for WebserviceID %s' => 'ไม่สามารถรับข้อมูลสำหรับ WebserviceID %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Need InvokerType' => 'ต้องการ InvokerType',
        'Invoker %s is not registered' => 'ไม่ได้ลงทะเบียนผู้ร้องขอ %s',
        'InvokerType %s is not registered' => 'ไม่ได้ลงทะเบียน InvokerType %s',
        'Need Invoker' => 'ต้องการผู้ร้องขอ',
        'Could not determine config for invoker %s' => 'ไม่สามารถตรวจสอบการตั้งค่าสำหรับผู้ร้องขอ %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Could not get registered configuration for action type %s' => 'ไม่สามารถรับการกำหนดค่าลงทะเบียนสำหรับประเภทการกระทำ% s',
        'Could not get backend for %s %s' => 'ไม่สามารถรับแบ็กเอนด์สำหรับ %s %s',
        'Could not update configuration data for WebserviceID %s' => 'ไม่สามารถอัปเดตข้อมูลการกำหนดค่าสำหรับ WebserviceID %s',
        'Keep (leave unchanged)' => 'เก็บ (ปล่อยไม่มีการเปลี่ยนแปลง)',
        'Ignore (drop key/value pair)' => 'ละเว้น (ดรอปคีย์ / ค่าคู่)',
        'Map to (use provided value as default)' => 'แผนที่ (การใช้งานที่มีให้คุ้มค่าเป็นค่าเริ่มต้น)',
        'Exact value(s)' => 'ค่าที่แน่นอน(s)',
        'Ignore (drop Value/value pair)' => 'ละเว้น (ดรอปค่า / ค่าคู่)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'Could not find required library %s' => 'ไม่พบไลบรารีที่จำเป็น %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Need OperationType' => 'ต้องการ OperationType',
        'Operation %s is not registered' => 'ไม่ได้ลงทะเบียนการดำเนินการ %s ',
        'OperationType %s is not registered' => 'ไม่ได้ลงทะเบียน OperationType %s',
        'Need Operation' => 'ต้องการการดำเนินการ',
        'Could not determine config for operation %s' => 'ไม่สามารถตรวจสอบการตั้งค่าสำหรับการดำเนินการ %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need Subaction!' => 'ต้องการ Subaction!',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'มีweb serviceอื่นที่มีชื่อเดียวกัน',
        'There was an error updating the web service.' => 'มีข้อผิดพลาดในการอัพเดท web service.',
        'Web service "%s" updated!' => 'Web service "%s" ได้อัพเดตแล้ว',
        'There was an error creating the web service.' => 'มีข้อผิดพลาดในการสร้าง web service.',
        'Web service "%s" created!' => 'สร้าง Web service "%s" แล้ว',
        'Need Name!' => 'ต้องการชื่อ!',
        'Need ExampleWebService!' => 'ต้องการ ExampleWebService!',
        'Could not read %s!' => 'ไม่สามารถอ่าน%s!',
        'Need a file to import!' => 'ต้องการไฟล์ที่จะนำเข้า!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'ไฟล์ที่นำเข้ามีเนื้อหา YAML ที่ไม่ถูกต้อง! โปรดตรวจสอบบันทึก OTRS สำหรับรายละเอียด',
        'Web service "%s" deleted!' => 'ลบ Web service "%s" แล้ว',
        'New Web service' => '',
        'Operations' => '',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'ไม่มี WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'ไม่สามารถได้รับข้อมูลประวัติศาสตร์สำหรับ WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Notification updated!' => 'ปรับปรุงการแจ้งเตือนแล้ว!',
        'Notification added!' => 'เพิ่มการแจ้งเตือนแล้ว!',
        'There was an error getting data for Notification with ID:%s!' =>
            'มีข้อผิดพลาดในการรับข้อมูลสำหรับการแจ้งเตือนด้วย ID:%s!',
        'Unknown Notification %s!' => 'การแจ้งเตือนที่ไม่ระบุ% s!',
        'There was an error creating the Notification' => 'มีข้อผิดพลาดในการสร้างการแจ้งเตือน',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ไม่สามารถนำเข้าการแจ้งเตือนได้เนื่องจากข้อผิดพลาดที่ไม่ทราบโปรดตรวจสอบการล็อก OTRS สำหรับข้อมูลเพิ่มเติม',
        'The following Notifications have been added successfully: %s' =>
            'การแจ้งเตือนดังต่อไปนี้ได้รับการเพิ่มเรียบร้อยแล้ว: %s',
        'The following Notifications have been updated successfully: %s' =>
            'การแจ้งเตือนดังต่อไปนี้ได้รับการอัพเดตเรียบร้อยแล้ว: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'มีข้อผิดพลาดการเพิ่ม / อัปเดต การแจ้งเตือนดังต่อไปนี้ได้:% s กรุณาตรวจสอบแฟ้มบันทึกสำหรับข้อมูลเพิ่มเติม',
        'Agent who owns the ticket' => 'เอเย่นต์ผู้ที่เป็นเจ้าของตั๋ว',
        'Agent who is responsible for the ticket' => 'เอเย่นต์ที่เป็นผู้รับผิดชอบตั๋ว',
        'All agents watching the ticket' => 'เอเย่นต์ทั้งหมดดูตั๋ว',
        'All agents with write permission for the ticket' => 'เอเย่นต์ทั้งหมดที่มีสิทธิ์ในการเขียนสำหรับตั๋ว',
        'All agents subscribed to the ticket\'s queue' => 'เอเย่นต์ทั้งหมดถูกจัดไปยังคิวของตั๋ว',
        'All agents subscribed to the ticket\'s service' => 'เอเย่นต์ทั้งหมดถูกจัดไปยังการบริการของตั๋ว',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'เอเย่นต์ทั้งหมดถูกจัดไปยังคิวและการบริการของตั๋ว',
        'Customer of the ticket' => 'ลูกค้าของตั๋ว',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'สภาพแวดล้อม PGP ไม่ทำงาน กรุณาตรวจสอบบันทึกสำหรับข้อมูลเพิ่มเติม!',
        'Need param Key to delete!' => 'ต้องการคีย์ param เพื่อใช้ในการลบ',
        'Key %s deleted!' => 'ลบKey %s แล้ว!',
        'Need param Key to download!' => 'ต้องการคีย์ param เพื่อดาวน์โหลด',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            'ขออภัย Apache::Reload เป็นสิ่งจำเป็นเช่นเดียวกับ PerlModule และ PerlInitHandler ในไฟล์ config Apache ดูเพิ่มเติมที่ scripts/apache2-httpd.include.conf หรือคุณสามารถใช้คำสั่งเครื่องมือขีดเส้น bin/otrs.Console.pl เพื่อติดตั้งแพคเกจ!',
        'No such package!' => 'ไม่มีแพคเกจดังกล่าว!',
        'No such file %s in package!' => 'ไม่มีไฟล์ดังกล่าว% s ในแพคเกจ!',
        'No such file %s in local file system!' => 'ไม่มีไฟล์ดังกล่าว% s ในระบบแฟ้มท้องถิ่น!',
        'Can\'t read %s!' => 'ไม่สามารถอ่าน% s!',
        'File is OK' => '',
        'Package has locally modified files.' => 'แพคเกจมีการปรับเปลี่ยนไฟล์ภายในเครื่อง',
        'No packages or no new packages found in selected repository.' =>
            'ไม่พบแพคเกจหรือแพคเกจใหม่ในพื้นที่เก็บข้อมูลที่คุณเลือก',
        'Package not verified due a communication issue with verification server!' =>
            'ไม่ได้ตรวจสอบแพคเกจเนื่องจากปัญหาการสื่อสารกับเซิร์ฟเวอร์การตรวจสอบ!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์คุณสมบัติ OTRS ที่อยู่ในรายการAdd-on !',
        'Can\'t get OTRS Feature Add-on list from server!' => 'ไม่สามารถได้รับคุณสมบัติของเซิร์ฟเวอร์ OTRS ที่อยู่ในรายการAdd-on !',
        'Can\'t get OTRS Feature Add-on from server!' => 'ไม่สามารถได้รับคุณสมบัติ OTRS Add-on จากเซิร์ฟเวอร์!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'ไม่มีตัวกรองดังกล่าว:% s',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Need ExampleProcesses!' => 'ต้องการ ExampleProcesses!',
        'Need ProcessID!' => 'ต้องการ ProcessID!',
        'Yes (mandatory)' => 'ใช่ (จำเป็น)',
        'Unknown Process %s!' => 'การดำเนินการที่ไม่ระบุ% s!',
        'There was an error generating a new EntityID for this Process' =>
            'มีข้อผิดพลาดการสร้าง EntityID ใหม่สำหรับขั้นตอนนี้',
        'The StateEntityID for state Inactive does not exists' => 'ไม่มี StateEntityID สำหรับสถิติที่ไม่ใช้งาน',
        'There was an error creating the Process' => 'มีข้อผิดพลาดในการสร้างการดำเนินการ',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'มีข้อผิดพลาดการตั้งค่าสถานะของการซิงค์เอนทิตีสำหรับขั้นตอนของเอนทิตี: %s',
        'Could not get data for ProcessID %s' => 'ไม่สามารถรับข้อมูลสำหรับ ProcessID %s',
        'There was an error updating the Process' => 'มีข้อผิดพลาดในการอัพเดตการดำเนินการ',
        'Process: %s could not be deleted' => 'การดำเนินการ:  %s ไม่สามารถลบ',
        'There was an error synchronizing the processes.' => 'มีข้อผิดพลาดในการทำซิงค์ข้อมูลการดำเนินการ',
        'The %s:%s is still in use' => '%s:%s ยังคงอยู่ในการใช้งาน',
        'The %s:%s has a different EntityID' => '%s:%s  มี EntityID ที่แตกต่างกัน',
        'Could not delete %s:%s' => 'ไม่สามารถลบ %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'มีข้อผิดพลาดการตั้งค่าสถานะของการซิงค์เอนทิตีสำหรับ %s เอนทิตี: %s',
        'Could not get %s' => 'ไม่สามารถรับ %s',
        'Need %s!' => 'ต้องการ %s!',
        'Process: %s is not Inactive' => 'การดำเนินการ: %s ไม่ได้ใช้งาน',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'มีข้อผิดพลาดการสร้าง EntityID ใหม่สำหรับกิจกรรมนี้',
        'There was an error creating the Activity' => 'มีข้อผิดพลาดในการสร้างกิจกรรม',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'มีข้อผิดพลาดการตั้งค่าสถานะของการซิงค์เอนทิตีสำหรับเอนทิตีกิจกรรม: %s',
        'Need ActivityID!' => 'ต้องการ ActivityID!',
        'Could not get data for ActivityID %s' => 'ไม่สามารถรับข้อมูลสำหรับ ActivityID %s',
        'There was an error updating the Activity' => 'มีข้อผิดพลาดในการอัพเดตกิจกรรม',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'พารามิเตอร์ที่ขาดหายไป: ต้องการกิจกรรมและActivityDialog!',
        'Activity not found!' => 'ไม่พบกิจกรรม!',
        'ActivityDialog not found!' => 'ไม่พบ ActivityDialog!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActivityDialog ได้กำหนดไปยังกิจกรรมแล้ว คุณไม่สามารถเพิ่มActivityDialog!',
        'Error while saving the Activity to the database!' => 'เกิดข้อผิดพลาดขณะกำลังบันทึกกิจกรรมไปยังฐานข้อมูล!',
        'This subaction is not valid' => 'subaction นี้ไม่ถูกต้อง',
        'Edit Activity "%s"' => 'แก้ไขกิจกรรม "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'มีข้อผิดพลาดการสร้าง EntityID ใหม่สำหรับActivityDialogนี้',
        'There was an error creating the ActivityDialog' => 'มีข้อผิดพลาดในการสร้าง ActivityDialog',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'มีข้อผิดพลาดการตั้งค่าสถานะของการซิงค์เอนทิตีสำหรับเอนทิตีActivityDialog: %s',
        'Need ActivityDialogID!' => 'ต้องการ ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'ไม่สามารถรับข้อมูลสำหรับ ActivityDialogID %s',
        'There was an error updating the ActivityDialog' => 'มีข้อผิดพลาดในการอัพเดต ActivityDialog',
        'Edit Activity Dialog "%s"' => 'แก้ไขกิจกรรมการโต้ตอบ "%s"',
        'Agent Interface' => 'อินเตอร์เฟซตัวแทน',
        'Customer Interface' => 'อินเตอร์เฟซลูกค้า',
        'Agent and Customer Interface' => 'อินเตอร์เฟซเอเย่นต์และลูกค้า',
        'Do not show Field' => 'ไม่ต้องแสดงฟิลด์',
        'Show Field' => 'แสดงฟิลด์',
        'Show Field As Mandatory' => 'แสดงฟิลด์เป็นค่าบังคับ',
        'fax' => 'แฟกซ์',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'แก้ไขเส้นทาง',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'มีข้อผิดพลาดการสร้าง EntityID ใหม่สำหรับการเปลี่ยนผ่านนี้',
        'There was an error creating the Transition' => 'มีข้อผิดพลาดในการสร้างการเปลี่ยนผ่าน',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'มีข้อผิดพลาดการตั้งค่าสถานะของการซิงค์เอนทิตีสำหรับเอนทิตีการเปลี่ยนผ่าน: %s',
        'Need TransitionID!' => 'ต้องการ TransitionID!',
        'Could not get data for TransitionID %s' => 'ไม่สามารถรับข้อมูลสำหรับ TransitionID %s',
        'There was an error updating the Transition' => 'มีข้อผิดพลาดในการอัพเดตการเปลี่ยนผ่าน',
        'Edit Transition "%s"' => 'แก้ไขการเปลี่ยนผ่าน "%s"',
        'xor' => 'xor',
        'String' => 'String',
        'Transition validation module' => 'โมดูลการตรวจสอบการเปลี่ยนผ่าน',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'อย่างน้อยหนึ่งการตั้งค่าพารามิเตอร์ที่ถูกต้อง',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'มีข้อผิดพลาดการสร้าง EntityID ใหม่สำหรับTransitionActionนี้',
        'There was an error creating the TransitionAction' => 'มีข้อผิดพลาดในการสร้าง TransitionAction',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'มีข้อผิดพลาดการตั้งค่าสถานะของการซิงค์เอนทิตีสำหรับเอนทิตีTransitionAction: %s',
        'Need TransitionActionID!' => 'ต้องการ TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'ไม่สามารถรับข้อมูลสำหรับ TransitionActionID %s',
        'There was an error updating the TransitionAction' => 'มีข้อผิดพลาดในการอัพเดต TransitionAction',
        'Edit Transition Action "%s"' => 'แก้ไขการกระทำเปลี่ยนผ่าน "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'ข้อผิดพลาด: ไม่ใช่คีย์ทั้งหมดที่ดูเหมือนจะมีค่าหรือในทางกลับกัน',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Don\'t use :: in queue name!' => 'อย่าใช้ :: ในคิวชื่อ!',
        'Click back and change it!' => 'คลิกกลับและเปลี่ยนมัน!',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'คิว (ที่ไม่ต้องใช้การตอบสนองอัตโนมัติ)',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'การผลิต',
        'Test' => '',
        'Training' => 'การฝึกอบรม',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'สภาพแวดล้อม S/MIME ไม่ทำงาน กรุณาตรวจสอบบันทึกสำหรับข้อมูลเพิ่มเติม!',
        'Need param Filename to delete!' => 'ต้องการชื่อไฟล์พารามิเตอร์เพื่อลบ!',
        'Need param Filename to download!' => 'ต้องการชื่อไฟล์พารามิเตอร์เพื่อดาวน์โหลด!',
        'Needed CertFingerprint and CAFingerprint!' => 'ต้องการ CertFingerprin และ CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint จะต้องมีความแตกต่างจาก CertFingerprint',
        'Relation exists!' => 'ความสัมพันธ์ที่มีอยู่!',
        'Relation added!' => 'เพิ่มความสัมพันธ์!',
        'Impossible to add relation!' => 'เป็นไปไม่ได้ที่จะเพิ่มความสัมพันธ์!',
        'Relation doesn\'t exists' => 'ไม่มีความสัมพันธ์',
        'Relation deleted!' => 'ความสัมพันธ์ถูกลบออก!',
        'Impossible to delete relation!' => 'เป็นไปไม่ได้ที่จะลบความสัมพันธ์!',
        'Certificate %s could not be read!' => 'ไม่สามารถอ่านหนังสือรับรอง %s !',
        'Needed Fingerprint' => 'ลายนิ้วมือที่ต้องการ',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation updated!' => 'อัพเดตคำขึ้นต้น!',
        'Salutation added!' => 'เพิ่มคำขึ้นต้น!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'ไม่สามารถอ่าน ไฟล์ %s!',

        # Perl Module: Kernel/Modules/AdminSysConfig.pm
        'Import not allowed!' => 'การนำเข้าไม่ได้รับอนุญาต!',
        'Need File!' => 'ต้องการไฟล์!',
        'Can\'t write ConfigItem!' => 'ไม่สามารถเขียน ConfigItem!',
        '-new-' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'วันที่เริ่มต้นไม่ควรกำหนดหลังจากวันหยุด!',
        'There was an error creating the System Maintenance' => 'มีข้อผิดพลาดในการสร้างการบำรุงรักษาระบบ',
        'Need SystemMaintenanceID!' => 'ต้องการ SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'ไม่สามารถรับข้อมูลสำหรับ SystemMaintenanceID %s',
        'System Maintenance was saved successfully!' => 'จัดเก็บการบำรุงรักษาระบบรียบร้อยแล้ว!',
        'Session has been killed!' => 'เซสชั่นถูกทำลายแล้ว!',
        'All sessions have been killed, except for your own.' => 'ทำลายเซสชันทั้งหมดแล้วยกเว้นเซสชันของคุณ',
        'There was an error updating the System Maintenance' => 'มีข้อผิดพลาดในการอัพเดตการบำรุงรักษาระบบ',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'ไม่สามารถลบการเข้าของ ystemMaintenance: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'อัพเดตแม่แบบแล้ว!',
        'Template added!' => 'เพิ่มแม่แบบแล้ว!',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'ต้องการประเภท!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'ไม่มีการตั้งค่าดังกล่าวสำหรับ %s',
        'Statistic' => 'สถิติ',
        'No preferences for %s!' => 'ไม่มีการกำหนดลักษณะสำหรับ %s!',
        'Can\'t get element data of %s!' => 'ไม่สามารถรับองค์ประกอบของข้อมูลของ %s!',
        'Can\'t get filter content data of %s!' => 'ไม่สามารถรับข้อมูลกรองเนื้อหา',
        'Customer Company Name' => '',
        'Customer User ID' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'ต้องการ SourceObject และ SourceKey!',
        'Please contact the administrator.' => '',
        'You need ro permission!' => 'คุณจำเป็นต้องได้รับอนุญาต',
        'Can not delete link with %s!' => 'ไม่สามารถลบการเชื่อมโยงด้วย %s!',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => 'ไม่สามารถสร้างการเชื่อมโยงด้วย %s!',
        'The object %s cannot link with other object!' => 'ออบเจคนี้ %s ไม่สามารถเชื่อมโยงกับออบเจคอื่น ๆ !',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'ต้องระบุกลุ่มพารามิเตอร์!',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'พารามิเตอร์ %s ขาดหายไป',
        'Invalid Subaction.' => 'Subaction ไม่ถูกต้อง!',
        'Statistic could not be imported.' => 'ไม่สามารถนำสถิติเข้ามาได้',
        'Please upload a valid statistic file.' => 'กรุณาอัปโหลดไฟล์สถิติที่ถูกต้อง',
        'Export: Need StatID!' => 'ส่งออก: ต้องการ StatID!',
        'Delete: Get no StatID!' => 'ลบ: ไม่ได้รับ StatID!',
        'Need StatID!' => 'ต้องการ StatID!',
        'Could not load stat.' => 'ไม่สามารถโหลดสถิติ',
        'Could not create statistic.' => 'ไม่สามารถสร้างสถิติ',
        'Run: Get no %s!' => 'รัน: ไม่ได้รับ %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'ไม่ได้รับ TicketID!',
        'You need %s permissions!' => 'คุณจำเป็นต้องได้ %s รับอนุญาต!',
        'Could not perform validation on field %s!' => 'ไม่สามารถดำเนินการตรวจสอบในช่อง!',
        'No subject' => 'ไม่มีหัวข้อ',
        'Previous Owner' => 'เจ้าของคนก่อนหน้านี้',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '% s จำเป็น!',
        'Plain article not found for article %s!' => 'ไม่พบบทความเปล่าสำหรับบทความ %s!',
        'Article does not belong to ticket %s!' => 'บทความไม่ได้เป็นของตั๋ว %s!',
        'Can\'t bounce email!' => 'ไม่สามารถตีกลับอีเมล!',
        'Can\'t send email!' => 'ไม่สามารถส่งอีเมล!',
        'Wrong Subaction!' => 'Subaction ผิด!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'ไม่สามารถล็อคตั๋ว ไม่ได้รับ TicketIDs!',
        'Ticket (%s) is not unlocked!' => 'ตั๋ว (%s) จะไม่ได้ปลดล็อค!',
        'Bulk feature is not enabled!' => 'ฟีเจอร์ Bulk ไม่ได้เปิดใช้งาน!',
        'No selectable TicketID is given!' => 'ไม่ได้รับ TicketID ที่เลือกไว้!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'You need to select at least one ticket.' => '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Can not determine the ArticleType!' => 'ไม่สามารถกำหนดค่า ArticleType!',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'No Subaction!' => 'ไม่มี Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'ไม่มี TicketID!',
        'System Error!' => 'ระบบผิดพลาด!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Invalid Filter: %s!' => 'ฟิลเตอร์ไม่ถูกต้อง: %s!',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'ไม่สามารถแสดงประวัติ ไม่ได้รับ TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'ไม่สามารถล็อคตั๋ว ไม่ได้รับ TicketIDs!',
        'Sorry, the current owner is %s!' => 'ขออภัยเจ้าของปัจจุบันคือ %s!',
        'Please become the owner first.' => 'กรุณาเป็นเจ้าของคนก่อน',
        'Ticket (ID=%s) is locked by %s!' => 'ตั๋ว (ID=%s) ถูกล็อกโดย %s!',
        'Change the owner!' => 'เปลี่ยนเจ้าของ!',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'ไม่สามารถผสานตั๋วด้วยตัวเอง!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'คุณจำเป็นต้องย้ายสิทธิ์!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'แชทยังไม่ทำงาน',
        'No permission.' => 'ไม่มีสิทธิ์',
        '%s has left the chat.' => '%s ได้ออกจากการแชท',
        'This chat has been closed and will be removed in %s hours.' => 'แชทนี้ได้รับการปิดและจะถูกลบออกใน %s ชั่วโมง',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'ไม่มี ArticleID!',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'ไม่สามารถอ่านบทความธรรมดา! บางทีจะไม่มีอีเมลธรรมดาในแบ็กเอนด์! อ่านข้อความแบ็กเอนด์',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'ต้องการ TicketID!',
        'printed by' => 'พิมพ์โดย',
        'Ticket Dynamic Fields' => 'ฟิลด์ตั๋วแบบไดนามิก',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'ไม่สามารถรับ ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'ไม่มีขั้นตอนการกำหนดค่า!',
        'Process %s is invalid!' => 'ขั้นตอนไม่ถูกต้อง!',
        'Subaction is invalid!' => 'subaction ไม่ถูกต้อง',
        'Parameter %s is missing in %s.' => 'พารามิเตอร์ %s ขาดหายไปใน %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'ไม่มีการกำหนดค่า ActivityDialog สำหรับ %s in _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'ไม่มีการเริ่มต้นสำหรับ ActivityEntityID หรือเริ่มต้น ActivityDialogEntityID สำหรับขั้นตอน: %s in _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'ไม่สามารถรับตั๋วสำหรับ TicketID: %s in _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'ไม่สามารถตรวจสอบ ActivityEntityID ได้เพราะไม่ได้ตั้งค่า DynamicField หรือ Config อย่างถูกต้อง!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s การกำหนดค่า ค่าที่หายไป!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'ไม่ได้รับ ProcessEntityID หรือ TicketID และ ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'ไม่สามารถเริ่ม StartActivityDialog และ StartActivityDialog สำหรับ ProcessEntityID "%s"!',
        'Can\'t get Ticket "%s"!' => 'ไม่สามารถรับตั๋ว "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'ไม่สามารถรับ ProcessEntityID หรือ ActivityEntityID สำหรับตั๋ว "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'ไม่สามารถได้รับการกำหนดค่ากิจกรรมสำหรับ ActivityEntityID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'ไม่สามารถตั้งค่า ActivityDialog สำหรับ ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'ไม่สามารถรับข้อมูลสำหรับฟิลด์ "%s" ของ ActivityDialog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime สามารถนำมาใช้ถ้าสถานะ หรือ StateID มีการกำหนดค่าเดียวกันสำหรับ ',
        'Pending Date' => 'วันที่รอดำเนินการ',
        'for pending* states' => 'สำหรับสถานะที่ค้างอยู่ *',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID หายไป!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'ไม่สามารถได้รับการกำหนดค่าสำหรับ ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'ProcessEntityID หายไป โปรดตรวจสอบ ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'ไม่มี StartActivityDialog หรือ StartActivityDialog สำหรับขั้นตอนการกำหนดค่า "%s"!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'ไม่สามารถสร้างตั๋วสำหรับกระบวนการด้วย ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'ไม่สามารถเซ็ต ProcessEntityID "%s" บน TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'ไม่สามารถเซ็ต ActivityEntityID "%s" บน TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'ไม่สามารถเก็บ ActivityDialog เพราะ TicketID ไม่ถูกต้อง',
        'Invalid TicketID: %s!' => 'TicketID ไม่ถูกต้อง: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'ActivityEntityID หายไปในตั๋ว %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => 'ProcessEntityID หายไปในตั๋ว %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '๋ไม่สามารถเซ็ตค่า DynamicField สำหรับ  %s ของตั๋วด้วยไอดี "%s" ใน  ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'ไม่สามารถเซ็ต PendingTime สำหรับตั๋วด้วยไอดี "%s" ใน ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'การตั้งค่าฟิลด์ Wrong ActivityDialog: %s ไม่สามารถแสดงผล => 1 / แสดงฟิลด์ (กรุณาเปลี่ยนการตั้งค่าให้เป็นการแสดงผล => 0 / ไม่แสดงข้อมูลหรือแสดงผล => 2 / แสดงข้อมูลเป็นจำเป็น)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'ไม่สามารถเซ็ต %s สำหรับตั๋วด้วยไอดี "%s" ใน ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => 'ค่าเริ่มต้นของการกำหนดค่าสำหรับกระบวนการ::Default%s ขาดหาย!',
        'Default Config for Process::Default%s invalid!' => 'ค่าเริ่มต้นของการกำหนดค่าสำหรับกระบวนการ::Default%s ไม่ถูกต้อง!',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Untitled' => 'ไม่ได้ตั้งชื่อ',
        'Customer Name' => '',
        'Invalid Users' => 'ผู้ใช้ที่ไม่ถูกต้อง',
        'CSV' => 'CSV',
        'Excel' => 'Excel',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'ฟีเจอร์ไม่ได้เปิดใช้งาน!',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'ฟีเจอร์ไม่ไช้งาน!',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'ลบลิงค์แล้ว',
        'Ticket Locked' => 'ตั๋วถูกล็อค',
        'Pending Time Set' => 'ตั้งค่าเวลาที่รอการดำเนินการ',
        'Dynamic Field Updated' => 'ไดมานิคฟิลด์อัพเดตแล้ว',
        'Outgoing Email (internal)' => 'อีเมลขาออก (ภายใน)',
        'Ticket Created' => 'ตั๋วที่สร้างขึ้น',
        'Type Updated' => 'อัปเดตประเภทแล้ว',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => 'การขยายเวลาอัพเดตหยุดลงแล้ว',
        'Escalation First Response Time Stopped' => 'การขยายเวลาที่ตอบสนองครั้งแรกหยุดแล้ว',
        'Customer Updated' => 'อัพเดตลูกค้าแล้ว',
        'Internal Chat' => 'แชทภายใน',
        'Automatic Follow-Up Sent' => 'การติดตามอัตโนมัติถูกส่ง',
        'Note Added' => 'เพิ่มโน๊ตแล้ว',
        'Note Added (Customer)' => 'เพิ่มโน๊ตแล้ว (ลูกค้า)',
        'State Updated' => 'อัพเดตสถานภาพแล้ว',
        'Outgoing Answer' => 'คำตอบที่ส่งออก',
        'Service Updated' => 'อัพเดตการบริการแล้ว',
        'Link Added' => 'เพิ่มลิงค์แล้ว',
        'Incoming Customer Email' => 'อีเมลขาเข้าจากลูกค้า',
        'Incoming Web Request' => 'การร้องขอเวบขาเข้า',
        'Priority Updated' => 'อัพเดตลำดับความสำคัญแล้ว',
        'Ticket Unlocked' => 'ตั๋วถูกปลดล็อค',
        'Outgoing Email' => 'อีเมลขาออก',
        'Title Updated' => 'อัปเดตหัวข้อแล้ว',
        'Ticket Merged' => 'ตั๋วรวม',
        'Outgoing Phone Call' => 'โทรศัพท์ขาออก',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => 'เวลาที่คิด',
        'Incoming Phone Call' => 'โทรศัพท์สายเข้า',
        'System Request.' => '',
        'Incoming Follow-Up' => 'การติดตามผลขาเข้า',
        'Automatic Reply Sent' => 'การตอบกลับแบบอัตโนมัติถูกส่ง',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => 'การขยายเวลาการแก้ปัญหาหยุดลงแล้ว',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => 'การขยายเวลาที่ตอบสนองหยุดแล้ว',
        'SLA Updated' => 'อัพเดต SLA แล้ว',
        'Queue Updated' => 'อัปเดตคิวแล้ว',
        'External Chat' => 'แชทภายนอก',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            'ขออภัยคุณไม่มีสิทธิในการเข้าถึงตั๋วนี้ในสถานะปัจจุบันอีกต่อไป',
        'Can\'t get for ArticleID %s!' => 'ไม่สามารถรับสำหรับ ArticleID %s!',
        'Article filter settings were saved.' => 'การตั้งค่าบทความตัวกรองถูกบันทึกไว้แล้ว',
        'Event type filter settings were saved.' => 'การตั้งค่าตัวกรองประเภทเหตุการณ์ถูกบันทึกไว้',
        'Need ArticleID!' => 'ต้องการ ArticleID!',
        'Invalid ArticleID!' => 'ArticleID ไม่ถูกต้อง! ',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',
        'Unavailable' => '',
        'User set their status to unavailable.' => '',
        'Fields with no group' => 'ฟิลด์ที่ไม่มีกลุ่ม',
        'View the source for this Article' => 'ดูแหล่งที่มาสำหรับบทความนี้',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'ต้องการ FileID และ ArticleID',
        'No TicketID for ArticleID (%s)!' => 'ไม่มี TicketID สำหรับ ArticleID (%s)!',
        'No such attachment (%s)!' => 'ไม่มีสิ่งที่แนบมาดังกล่าว (%s)! ',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'ตรวจสอบการตั้งค่า SysConfig สำหรับ %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'ตรวจสอบการตั้งค่า SysConfig สำหรับ %s::TicketTypeDefault.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'ต้องการ CustomerID!',
        'My Tickets' => 'ตั๋วของฉัน',
        'Company Tickets' => 'ตั๋วของบริษัท',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            'โปรดลบคำต่อไปนี้เพราะมันไม่สามารถนำมาใช้สำหรับการค้นหา:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'ไม่สามารถเปิดตั๋ว เปิดในคิวนี้ไม่ได้!',
        'Create a new ticket!' => 'สร้างตั๋วใหม่!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'ใช้งาน SecureMode!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => 'ไม่มีไดเรกทอรี ',
        'Configure "Home" in Kernel/Config.pm first!' => 'กำหนดค่า "Home" in Kernel/Config.pm ก่อน!',
        'File "%s/Kernel/Config.pm" not found!' => 'ไม่พบไฟล์ ',
        'Directory "%s" not found!' => 'ไม่พบไดเรกเทอรี "%s"!',
        'Kernel/Config.pm isn\'t writable!' => 'ไม่สามารถเขียน Kernel/Config.pm ได้!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'หากคุณต้องการที่จะใช้การติดตั้ง ตั้งค่า Kernel/Config.pm เป็น สามารถเขียนได้ สำหรับผู้ใช้เว็บเซิร์ฟเวอร์!',
        'Unknown Check!' => 'ไม่รู้จักตรวจสอบ!',
        'The check "%s" doesn\'t exist!' => 'การตรวจสอบ "%s" ไม่อยู่!',
        'Database %s' => 'ฐานข้อมูล %s',
        'Configure MySQL' => '',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => 'ชนิดของฐานข้อมูลที่ไม่รู้จัก "%s".',
        'Please go back.' => '',
        'Install OTRS - Error' => 'ติดตั้ง OTRS - ข้อผิดพลาด',
        'File "%s/%s.xml" not found!' => 'ไม่พบไฟล์ "%s/%s.xml" ',
        'Contact your Admin!' => 'ติดต่อผู้ดูแลระบบของคุณ!',
        'Syslog' => '',
        'Can\'t write Config file!' => 'ไม่สามารถเขียนไฟล์ config!',
        'Unknown Subaction %s!' => 'Subaction ที่ไม่รู้จัก %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'ไม่สามารถเชื่อมต่อกับฐานข้อมูล,ไม่ได้ติดตั้ง Perl โมดูล DBD::%s!',
        'Can\'t connect to database, read comment!' => 'ไม่สามารถเชื่อมต่อกับฐานข้อมูลกรุณาอ่านความคิดเห็น!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'ข้อผิดพลาด: โปรดตรวจสอบฐานข้อมูลของคุณว่าสามารถรับแพคเกจได้มากกว่า% s MB (ปัจจุบันรับเฉพาะแพคเกจขนาด% s MB) กรุณาปรับให้เข้าการตั้งค่า max_allowed_packet ของฐานข้อมูลของคุณเพื่อหลีกเลี่ยงข้อผิดพลาด',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'ข้อผิดพลาด: กรุณาระบุค่าสำหรับ innodb_log_file_size ในฐานข้อมูลของคุณอย่างน้อย% s MB (ปัจจุบัน:% s MB แนะนำ:% s MB) สำหรับข้อมูลเพิ่มเติมโปรดดูได้ที่',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'ต้องปรับแต่ง Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'การตรวจสอบสิทธิ์ล้มเหลวจาก%s!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Sent message crypted to recipient!' => 'ส่งข้อความที่เข้ารหัสไปยังผู้รับ!',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => 'พบหัวเรื่อง "PGP SIGNED MESSAGE" แต่ไม่ถูกต้อง',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => 'พบหัวเรื่อง "S/MIME SIGNED MESSAGE" แต่ไม่ถูกต้อง',
        'Ticket decrypted before' => 'ตั๋วถอดรหัสก่อน',
        'Impossible to decrypt: private key for email was not found!' => 'เป็นไปไม่ได้ที่จะถอดรหัส: ไม่พบคีย์ส่วนตัวสำหรับอีเมล!',
        'Successful decryption' => 'การถอดรหัสประสบความสำเร็จ',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'เวลาเริ่มต้นของตั๋วจะต้องตั้งค่าหลังเวลาสิ้นสุด!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => '',
        'Can\'t get OTRS News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'sorted ascending' => 'เรียงลำดับจากน้อยไปมาก',
        'sorted descending' => 'เรียงลำดับจากมากไปน้อย',
        'filter not active' => 'ตัวกรองไม่ได้ใช้งาน',
        'filter active' => 'ตัวกรองที่ใช้งาน',
        'This ticket has no title or subject' => 'ตั๋วนี้ไม่มีหัวข้อหรือชื่อเรื่อง',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:' =>
            'ขออภัยคุณไม่ได้รับอนุญาตในการเข้าถึงตั๋วอีกต่อไป',
        'No Permission' => 'ไม่ได้รับอนุญาต',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'เชื่อมโยงเป็น',
        'Search Result' => 'ผลการค้นหา',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s อัพเกรดเป็น %s ในขณะนี้! %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => 'ระยะเวลาการบำรุงรักษาระบบจะเริ่มต้นที่:',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(อยู่ในขั้นตอน)',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'โปรดตรวจสอบว่าคุณได้เลือกอย่างน้อยหนึ่งวิธีการขนส่งสำหรับการแจ้งเตือนที่บังคับใช้',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'โปรดระบุวันที่สิ้นสุดหลังจากวันที่เริ่มต้น',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => 'กรุณาใส่รหัสผ่านใหม่ของคุณ!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No (not supported)' => '',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'ที่ผ่านมาหรือในปัจจุบัน+กำลังจะมาถึงไม่สมบูรณ์ในเวลาที่สัมพันธ์กันค่าที่เลือก',
        'The selected time period is larger than the allowed time period.' =>
            'ระยะเวลาที่เลือกมีระยะเวลาที่นานกว่าระยะเวลาที่ได้รับอนุญาต',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'ไม่มีค่ามาตราส่วนเวลาสำหรับค่ามาตราส่วนเวลาที่เลือกในปัจจุบันบนแกน X',
        'The selected date is not valid.' => 'วันที่ที่เลือกไม่ถูกต้อง.',
        'The selected end time is before the start time.' => 'เวลาสิ้นสุดที่เลือกคือก่อนเวลาเริ่มต้น',
        'There is something wrong with your time selection.' => 'มีข้อผิดพลาดบางอย่างกับการเลือกเวลาของคุณ',
        'Please select only one element or allow modification at stat generation time.' =>
            'กรุณาเลือกเพียงองค์ประกอบหนึ่งหรืออนุญาตให้ปรับเปลี่ยนที่เวลาการสร้างสถิติ',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'กรุณาเลือกอย่างน้อยหนึ่งค่าของฟิลด์นี้หรืออนุญาตให้ปรับเปลี่ยนที่เวลาการสร้างสถิติ',
        'Please select one element for the X-axis.' => 'กรุณาเลือกหนึ่งองค์ประกอบสำหรับแกน X',
        'You can only use one time element for the Y axis.' => 'คุณสามารถใช้องค์ประกอบหนึ่งครั้งสำหรับแกน Y',
        'You can only use one or two elements for the Y axis.' => 'คุณสามารถใช้หนึ่งหรือสององค์ประกอบสำหรับแกน Y',
        'Please select at least one value of this field.' => 'กรุณาเลือกอย่างน้อยหนึ่งค่าในฟิลด์นี้',
        'Please provide a value or allow modification at stat generation time.' =>
            'โปรดระบุค่าหรืออนุญาตให้ปรับเปลี่ยนได้ที่เวลาการสร้างสถิติ',
        'Please select a time scale.' => 'กรุณาเลือกสเกลเวลา',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'ช่วงเวลาการรายงานของคุณมีขนาดเล็กเกินไปโปรดใช้สเกลเวลาที่มีขนาดใหญ่',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'โปรดลบคำต่อไปนี้เพราะมันไม่สามารถที่จะใช้สำหรับการจำกัดตั๋ว:% s',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'จัดเรียงโดย',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session per user limit reached!' => 'เซสชั่นต่อขีดจำกัดของผู้ใช้!',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'ตัวเลือกการกำหนดค่าอ้างอิง',
        'This setting can not be changed.' => 'ไม่สามารถเปลี่ยนแปลงการตั้งค่านี้ได้',
        'This setting is not active by default.' => 'การตั้งค่านี้ยังไม่ทำงานโดยค่าเริ่มต้น',
        'This setting can not be deactivated.' => 'ไม่สามารถปิดการใช้งานการตั้งค่านี้',

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
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'ไม่ได้ติดตั้ง',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'ไม่ทำงาน',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t get Token from sever' => 'ไม่สามารถได้รับ Token จากเซิร์ฟเวอร์',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'ประเภทสถานะ',
        'Created Priority' => 'ลำดับความสำคัญถูกสร้างแล้ว',
        'Created State' => 'สถานะถูกสร้างแล้ว',
        'Create Time' => 'เวลาที่สร้าง',
        'Close Time' => 'เวลาที่ปิด',
        'Escalation - First Response Time' => 'การขยาย - เวลาที่ตอบสนองครั้งแรก',
        'Escalation - Update Time' => 'การขยาย - เวลาการปรับปรุง',
        'Escalation - Solution Time' => 'การขยาย - เวลาการแก้ปัญหา',
        'Agent/Owner' => 'เอเย่นต์/เจ้าของ',
        'Created by Agent/Owner' => 'สร้างโดย เอเย่นต์/เจ้าของ',
        'CustomerUserLogin' => 'CustomerUserLogin',
        'CustomerUserLogin (complex search)' => '',
        'CustomerUserLogin (exact match)' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'การประเมินผลโดย',
        'Ticket/Article Accounted Time' => 'เวลาคิด ตั๋ว/บทความ ',
        'Ticket Create Time' => 'เวลาที่สร้างตั๋ว',
        'Ticket Close Time' => 'เวลาที่ปิดตั๋ว',
        'Accounted time by Agent' => 'เวลาที่คิดโดยเอเย่นต์',
        'Total Time' => '',
        'Ticket Average' => '',
        'Ticket Min Time' => '',
        'Ticket Max Time' => '',
        'Number of Tickets' => '',
        'Article Average' => '',
        'Article Min Time' => '',
        'Article Max Time' => '',
        'Number of Articles' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'ascending' => '',
        'descending' => '',
        'Attributes to be printed' => 'แอตทริบิวต์ที่จะพิมพ์',
        'Sort sequence' => 'เรียงลำดับ',
        'State Historic' => 'ประวัติสถานะ',
        'State Type Historic' => 'ประวัติประเภทสถานะ',
        'Historic Time Range' => 'ช่วงเวลาของประวัติ',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '',
        'Solution Min Time' => '',
        'Solution Max Time' => '',
        'Solution Average (affected by escalation configuration)' => '',
        'Solution Min Time (affected by escalation configuration)' => '',
        'Solution Max Time (affected by escalation configuration)' => '',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '',
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
        'Number of Tickets (affected by escalation configuration)' => '',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'วัน',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'ตารางการแสดง',
        'Internal Error: Could not open file.' => 'ข้อผิดพลาดภายใน: ไม่สามารถเปิดไฟล์',
        'Table Check' => 'ตรวจสอบตาราง',
        'Internal Error: Could not read file.' => 'ข้อผิดพลาดภายใน: ไม่สามารถอ่านไฟล์',
        'Tables found which are not present in the database.' => 'พบตารางซึ่งไม่ได้อยู่ในฐานข้อมูล',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'ขนาดฐานข้อมูล',
        'Could not determine database size.' => 'ไม่สามารถกำหนดขนาดของฐานข้อมูล',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'เวอร์ชั่นฐานข้อมูล',
        'Could not determine database version.' => 'ไม่สามารถกำหนดเวอร์ชั่นของฐานข้อมูล',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'การเชื่อมต่อลูกค้ากับชุดรหัสอักขระ',
        'Setting character_set_client needs to be utf8.' => 'การตั้งค่า character_set_client จะต้องเป็น utf8',
        'Server Database Charset' => 'ฐานข้อมูลชุดรหัสอักขระของเซิร์ฟเวอร์',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'ตั้งค่า character_set_database จะต้องเป็น UNICODE หรือ UTF8',
        'Table Charset' => 'ตารางชุดรหัสอักขระ',
        'There were tables found which do not have utf8 as charset.' => 'พบตารางที่ไม่มีชุดรหัสอักขระเป็น utf8',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'ขนาดInnoDB Log File',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'การตั้งค่า innodb_log_file_size ต้องมีขนาดอย่างน้อย256 MB',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'ขนาดสูงสุดของ Query',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'การตั้งค่า innodb_log_file_size ต้องมีขนาดมากกว่า 20 MB',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'ขนาดQueryของแคช',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'การตั้งค่า \'query_cache_size ที่ควรใช้ (มากกว่า 10 MB แต่ไม่เกิน 512 MB)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'เครื่องมือการจัดเก็บข้อมูลเริ่มต้น',
        'Table Storage Engine' => 'ตารางของเครื่องมือการจัดเก็บข้อมูล',
        'Tables with a different storage engine than the default engine were found.' =>
            'ตารางที่มีเครื่องมือเก็บที่แตกต่างจากเครื่องมือเริ่มต้นถูกค้นพบ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'จำเป็นต้องใช้ MySQL 5.x หรือสูงกว่า',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'การตั้งค่าNLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG ต้องกำหนดเป็น AL32UTF8 (เช่น GERMAN_GERMANY.AL32UTF8)',
        'NLS_DATE_FORMAT Setting' => 'การตั้งค่าNLS_DATE_FORMAT ',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT ต้องกำหนดเป็น \'YYYY-MM-DD HH24: MI: SS\'',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT ตั้งค่าการตรวจสอบ SQL',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'การตั้งค่า client_encoding จะต้องเป็น UNICODE หรือ UTF8',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'การตั้งค่า server_encoding จะต้องเป็น UNICODE หรือ UTF8',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'รูปแบบวันที่',
        'Setting DateStyle needs to be ISO.' => 'การตั้งค่า DateStyle จะต้องเป็น ISO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => 'จำเป็นต้องใช้ PostgreSQL 8.x หรือสูงกว่า',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'แบ่งดิสก์ OTRS ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'การใช้งานดิสก์',
        'The partition where OTRS is located is almost full.' => 'แบ่ง OTRS เมื่อความจำใกล้เต็ม',
        'The partition where OTRS is located has no disk space problems.' =>
            'แบ่ง OTRS เมื่อควาจุของดิสก์ไม่มีปัญหา',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'การแพร่กระจาย',
        'Could not determine distribution.' => 'ไม่สามารถตรวจสอบการแพร่กระจาย',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'เวอร์ชั่นของKernel ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'ระบบการโหลด',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'ระบบโหลดที่ควรจะอยู่ที่จำนวนสูงสุดของซีพียูที่ระบบจะมีได้ (เช่นค่าโหลด 8 หรือน้อยลงในระบบที่มีซีพียู 8 เป็น OK)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'โมดูลPerl',
        'Not all required Perl modules are correctly installed.' => 'ไม่มีการติดตั้งอย่างถูกต้องโมดูล Perl ที่ร้องขอทั้งหมด',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'พื้นที่การแลกเปลี่ยนฟรี (%)',
        'No swap enabled.' => 'ไม่มีการเปิดใช้งานการแลกเปลี่ยน',
        'Used Swap Space (MB)' => 'พื้นที่การแลกเปลี่ยนที่ถูกใช้ (MB)',
        'There should be more than 60% free swap space.' => 'พื้นที่การแลกเปลี่ยนฟรีควรจะมีมากกว่า 60%',
        'There should be no more than 200 MB swap space used.' => 'พื้นที่การแลกเปลี่ยนที่ถูกใช้ควรจะมีมากกว่า 200 MB ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS' => 'OTRS',
        'Config Settings' => '',
        'Could not determine value.' => 'ไม่สามารถกำหนดค่า',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => '',
        'Daemon is not running.' => ' Daemon ไม่ทำงาน',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '',
        'Tickets' => 'ตั๋ว',
        'Ticket History Entries' => 'ประวัติการป้อนตั๋ว',
        'Articles' => 'บทความ',
        'Attachments (DB, Without HTML)' => 'สิ่งที่แนบมา (DB ปราศจาก HTML)',
        'Customers With At Least One Ticket' => 'ลูกค้ามีอย่างน้อยหนึ่งตั๋ว',
        'Dynamic Field Values' => 'ค่าไดนามิกฟิลด์',
        'Invalid Dynamic Fields' => 'ฟิลด์แบบไดนามิกที่ไม่ถูกต้อง',
        'Invalid Dynamic Field Values' => 'ค่าฟิลด์แบบไดนามิกที่ไม่ถูกต้อง',
        'GenericInterface Webservices' => 'GenericInterface Webservices',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'เดือนที่อยู่ระหว่างตั๋วใบแรกและใบสุดท้าย',
        'Tickets Per Month (avg)' => 'ตั๋วต่อเดือน (เฉลี่ย)',
        'Open Tickets' => 'เปิดตั๋ว',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'ชื่อและรหัสผ่านเริ่มต้นของSOAP',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'ความเสี่ยงด้านความปลอดภัย: คุณใช้การตั้งค่าเริ่มต้นสำหรับ SOAP :: ผู้ใช้และSOAP ::รหัสผ่าน กรุณาเปลี่ยนมัน',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'รหัสผ่านเริ่มต้นของผู้ดูแลระบบ',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'ความเสี่ยงด้านความปลอดภัย: บัญชีเอเย่นต์ root@localhost ยังคงใช้รหัสผ่านเริ่มต้น กรุณาเปลี่ยนหรือโมฆะบัญชี',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (ชื่อโดเมน)',
        'Please configure your FQDN setting.' => 'โปรดกำหนดการตั้งค่า FQDN ของคุณ',
        'Domain Name' => 'ชื่อโดเมน',
        'Your FQDN setting is invalid.' => 'การตั้งค่า FQDN คุณไม่ถูกต้อง',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'ระบบไฟล์สามารถเขียนได้',
        'The file system on your OTRS partition is not writable.' => 'ระบบไฟล์ในการแบ่งOTRS ของคุณไม่สามารถเขียนได้',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'สถานะการติดตั้งแพคเกจ',
        'Some packages have locally modified files.' => 'แพคเกจบางส่วนมีการปรับเปลี่ยนไฟล์ภายในเครื่อง',
        'Some packages are not correctly installed.' => 'แพคเกจบางแพคเกจไม่ถูกติดตั้งอย่างถูกต้อง',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'การตั้งค่า SystemID ของคุณไม่ถูกต้อง มันประกอบด้วยตัวเลขเพียงอย่างเดียว',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => 'สถานะเริ่มต้นของประเภทตั๋ว',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'กำหนดค่าประเภทตั๋วเริ่มต้นนี้ไม่ถูกต้องหรือขาดหายไป กรุณาเปลี่ยนการตั้งค่า Ticket::Type::Default และเลือกประเภทของตั๋วที่ถูกต้อง',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'โมดูลตั๋วดัชนี',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'คุณมีมากกว่า 60,000 ตั๋วและควรใช้แบ็กเอนด์ StaticDB ดูคู่มือผู้ดูแลระบบ (ปรับแต่งประสิทธิภาพ) สำหรับข้อมูลเพิ่มเติม',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'ผู้ใช้ไม่ถูกต้องกับตั๋วล็อค',
        'There are invalid users with locked tickets.' => 'มีผู้ใช้ที่ไม่ถูกต้องกับตั๋วที่ถูกล็อคอยู่',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'คุณไม่ควรมีตั๋วที่เปิดอยู่มากกว่า 8,000 ตั๋วในระบบของคุณ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'โมดูลการค้นหาตั๋วดัชนี',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'คุณมีบทความมากกว่า50,000 บทความและควรใช้แบ็กเอนด์ StaticDB ดูคู่มือผู้ดูแลระบบ (ปรับแต่งประสิทธิภาพ) สำหรับข้อมูลเพิ่มเติม',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'บันทึกกำพร้าในตาราง ticket_lock_index ',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            ' ตาราง ticket_lock_index ประกอบด้วยบันทึกกำพร้า โปรดเรียกใช้ bin / otrs.Console.pl"Maint::Ticket::QueueIndexCleanup" เพื่อลบดัชนี StaticDB',
        'Orphaned Records In ticket_index Table' => 'บันทึกกำพร้าในตาราง ticket_index ',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => 'โซนเวลาเซิร์ฟเวอร์',
        'Computed server time offset' => 'เวลาชดเชยการคำนวณเซิร์ฟเวอร์',
        'OTRS TimeZone setting (global time offset)' => 'การตั้งค่า OTRS TimeZone (เวลาทั่วโลกชดเชย)',
        'TimeZone may only be activated for systems running in UTC.' => 'TimeZone อาจจะถูกเปิดใช้งานสำหรับระบบที่ใช้ใน UTC เท่านั้น',
        'OTRS TimeZoneUser setting (per-user time zone support)' => 'การตั้งค่า OTRS TimeZone (ต่อผู้ใช้สนับสนุนโซนเวลา)',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            'TimeZone อาจจะถูกเปิดใช้งานสำหรับระบบที่ใช้ใน UTC ที่ไม่ได้มีกำหนดOTRS TimeZone',
        'OTRS TimeZone setting for calendar ' => 'การตั้งค่า OTRS TimeZone สำหรับปฏิทิน',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webserver',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'โมเดล MPM ',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS  ต้องการให้ Apache จะทำงานกับโมเดล MPM  \'prefork\' ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'การใช้ตัวช่วยดำเนินการ CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'คุณควรใช้ FastCGI หรือ mod_perlเพื่อเพิ่มประสิทธิภาพการทำงานของคุณ',
        'mod_deflate Usage' => 'การใช้งาน mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'กรุณาติดตั้ง mod_deflate เพื่อเพิ่มความเร็ว GUI',
        'mod_filter Usage' => 'การใช้งานmod_filter ',
        'Please install mod_filter if mod_deflate is used.' => 'กรุณาติดตั้ง mod_filter ถ้ากำลังใช้งาน mod_deflate ',
        'mod_headers Usage' => 'การใช้งาน mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'กรุณาติดตั้ง mod_headers เพื่อเพิ่มความเร็ว GUI',
        'Apache::Reload Usage' => 'การใช้งาน Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload หรือ Apache2::Reload ควรถูกใช้เป็น PerlModule และ PerlInitHandler เพื่อป้องกันไม่ให้เว็บเซิร์ฟเวอร์รีสตาร์ทขณะติดตั้งและอัพเกรดโมดูล',
        'Apache2::DBI Usage' => 'การใช้งาน Apache2::DBI',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'ควรจะใช้ Apache2::DBI เพื่อให้ได้ประสิทธิภาพที่ดีขึ้นด้วยการเชื่อมต่อฐานข้อมูลที่ถูกสร้างมาก่อน',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'เวอร์ชั่นของ Webserver',
        'Could not determine webserver version.' => 'ไม่สามารถตรวจสอบเวอร์ชั่นของเว็บเซิร์ฟเวอร์',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'ผู้ใช้งานร่วมกัน',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => 'ไม่ระบุ',
        'OK' => 'โอเค',
        'Problem' => 'ปัญหา',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'รีเซ็ตหรือปลดล็อคเวลา',

        # Perl Module: Kernel/System/Ticket/Event/NotificationEvent/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'PGP sign and encrypt' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'SMIME sign and encrypt' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'ออกจากระบบประสบความสำเร็จ',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => 'ไม่มีการอนุญาตให้ใช้โมดูลส่วนหน้านี้!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'Added via Customer Panel (%s)' => 'เพิ่มผ่านแผงลูกค้า (%s)',
        'Customer user can\'t be added!' => 'ผู้ใช้ลูกค้าไม่สามารถเพิ่ม!',
        'Can\'t send account info!' => 'ไม่สามารถส่งข้อมูลบัญชี!',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'ไม่พบการกระทำ "%s"!',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => 'กลุ่มสำหรับการเข้าถึงเริ่มต้น',
        'Group of all administrators.' => 'กลุ่มของผู้บริหารทั้งหมด',
        'Group for statistics access.' => 'กลุ่มสำหรับการเข้าถึงสถิติ',
        'All new state types (default: viewable).' => 'ประเภทสถานะใหม่ทั้งหมด (ค่าเริ่มต้น: สามารถดูได้)',
        'All open state types (default: viewable).' => 'ประเภทสถานะเปิดทั้งหมด (ค่าเริ่มต้น: สามารถดูได้)',
        'All closed state types (default: not viewable).' => 'ประเภทสถานะปิดทั้งหมด (ค่าเริ่มต้น: ไม่สามารถดูได้)',
        'All \'pending reminder\' state types (default: viewable).' => 'ประเภทสถานะ \'ค้างอยู่แบบแจ้งเตือน\' ทั้งหมด (ค่าเริ่มต้น: สามารถดูได้)',
        'All \'pending auto *\' state types (default: viewable).' => 'ประเภทสถานะ \'ค้างอัตโนมัติ\' ทั้งหมด (ค่าเริ่มต้น: สามารถดูได้)',
        'All \'removed\' state types (default: not viewable).' => 'ประเภทสถานะ \'ถูกลบออก\' ทั้งหมด (ค่าเริ่มต้น: ไม่สามารถดูได้)',
        'State type for merged tickets (default: not viewable).' => 'ประเภทสถานะสำหรับตั๋วที่ถูกผสาน (ค่าเริ่มต้น: ไม่สามารถดูได้)',
        'New ticket created by customer.' => 'ตั๋วใหม่ที่สร้างขึ้นโดยลูกค้า',
        'Ticket is closed successful.' => 'ตั๋วถูกปิดด้วยความสำเร็จ',
        'Ticket is closed unsuccessful.' => 'ตั๋วถูกปิดไม่สำเร็จ',
        'Open tickets.' => 'เปิดตั๋ว',
        'Customer removed ticket.' => 'ลูกค้าลบตั๋วออก',
        'Ticket is pending for agent reminder.' => 'ตั๋วค้างอยู่สำหรับแจ้งเตือนเอเย่นต์',
        'Ticket is pending for automatic close.' => 'ตั๋วค้างอยู่สำหรับปิดอัตโนมัติ',
        'State for merged tickets.' => 'สถานะสำหรับตั๋วที่ถูกผสาน',
        'system standard salutation (en)' => 'ระบบคำขึ้นต้นมาตรฐาน (en)',
        'Standard Salutation.' => 'คำขึ้นต้นมาตรฐาน',
        'system standard signature (en)' => 'ระบบลายเซ็นมาตรฐาน (en)',
        'Standard Signature.' => 'ลายเซ็นมาตรฐาน',
        'Standard Address.' => 'ที่อยู่มาตรฐาน',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'การติดตามตั๋วที่ปิดแล้วเป็นไปได้ที่ตั๋วจะถูกเปิด',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'เป็นไปไม่ได้ที่จะติดตามตั๋วที่ปิดแล้วและไม่มีการสร้างตั๋วใหม่',
        'new ticket' => 'ตั๋วใหม่',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'คิวPostmaster',
        'All default incoming tickets.' => 'ตั๋วเริ่มต้นขาเข้าทั้งหมด',
        'All junk tickets.' => 'ตั๋วขยะทั้งหมด',
        'All misc tickets.' => 'ตั๋ว miscทั้งหมด',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'การตอบกลับอัตโนมัติจะถูกส่งออกมาหลังจากที่ตั๋วใหม่ถูกสร้างขึ้น',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'การปฏิเสธอัตโนมัติจะถูกส่งออกมาหลังจากที่การติดตามถูกปฏิเสธ (ในกรณีที่ตัวเลือกคิวติดตามคือ "ปฏิเสธ")',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'การยืนยันอัตโนมัติจะถูกส่งออกมาหลังจากที่การติดตามได้รับตั๋ว (ในกรณีที่ตัวเลือกคิวติดตามคือ "เป็นไปได้")',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'การตอบสนองอัตโนมัติจะถูกส่งออกมาหลังจากที่การติดตามถูกปฏิเสธและตั๋วใหม่ถูกสร้างขึ้น (ในกรณีที่ตัวเลือกคิวติดตามคือ "ตั๋วใหม่")',
        'Auto remove will be sent out after a customer removed the request.' =>
            'การลบอัตโนมัติจะถูกส่งออกมาหลังจากที่ลูกค้าลบการร้องขอออก',
        'default reply (after new ticket has been created)' => 'การตอบกลับเริ่มต้น (หลังจากตั๋วใหม่ถูกสร้างขึ้น)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'การปฏิเสธเริ่มต้น (หลังจากติดตามและปฏิเสธตั๋วปิด)',
        'default follow-up (after a ticket follow-up has been added)' => 'การติดตามเริ่มต้น (หลังจากตั๋วติดตามได้รับการเพิ่ม)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'การปฏิเสธเริ่มต้น / ตั๋วใหม่ถูกสร้างขึ้น (หลังจากปิดการติดตามด้วยการสร้างตั๋วใหม่)',
        'Unclassified' => 'ไม่จำแนก',
        'tmp_lock' => 'tmp_lock',
        'email-notification-ext' => 'email-notification-ext',
        'email-notification-int' => 'email-notification-int',
        'Ticket create notification' => 'การแจ้งเตือนการสร้างตั๋ว',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'คุณจะได้รับการแจ้งเตือนทุกครั้งที่ตั๋วใหม่ถูกสร้างขึ้นในหนึ่งของ "คิวของฉัน" หรือ "บริการของฉัน"',
        'Ticket follow-up notification (unlocked)' => 'ตั๋วติดตามการแจ้งเตือน (ปลดล็อค)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'คุณจะได้รับการแจ้งเตือนหากลูกค้าส่งติดตามตั๋วปลดล็อคซึ่งอยู่ใน "คิวของฉัน" หรือ "บริการของฉัน"',
        'Ticket follow-up notification (locked)' => 'ตั๋วติดตามการแจ้งเตือน (ล็อค)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'คุณจะได้รับการแจ้งเตือนหากลูกค้าส่งติดตามตั๋วล็อคที่คุณเป็นเจ้าของตั๋วหรือผู้รับผิดชอบ',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'คุณจะได้รับการแจ้งเตือนทันทีที่ตั๋วที่คุณเป็นเจ้าของถูกปลดล็อกโดยอัตโนมัติ',
        'Ticket owner update notification' => 'การแจ้งเตือนการอัพเดตของเจ้าของตั๋ว',
        'Ticket responsible update notification' => 'การแจ้งเตือนการอัพเดตผู้รับผิดชอบตั๋ว',
        'Ticket new note notification' => 'การแจ้งเตือนตั๋วโน้ตใหม่',
        'Ticket queue update notification' => 'การแจ้งเตือนการอัพเดตตั๋วคิว',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'คุณจะได้รับการแจ้งเตือนหากตั๋วจะถูกย้ายไปเป็นหนึ่งใน "คิวของฉัน"',
        'Ticket pending reminder notification (locked)' => 'ตั๋วเตือนที่ค้างอยู่การแจ้งเตือน (ล็อค)',
        'Ticket pending reminder notification (unlocked)' => 'ตั๋วเตือนที่ค้างอยู่การแจ้งเตือน (ปลดล็อค)',
        'Ticket escalation notification' => 'การแจ้งเตือนการขยายตั๋ว',
        'Ticket escalation warning notification' => 'การแจ้งเตือนคำเตือนการขยายตั๋ว',
        'Ticket service update notification' => 'การแจ้งเตือนการอัพเดตตั๋วการบริการ',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'คุณจะได้รับการแจ้งเตือนหากบริการจองตั๋วมีการเปลี่ยนแปลงให้เป็นหนึ่งใน "บริการของฉัน"',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
เรียนลูกค้า

น่าเสียดายที่เราไม่สามารถตรวจสอบจำนวนบัตรที่ถูกต้อง
ในเนื้อหาของคุณ ดังนั้นอีเมลฉบับนี้จึงไม่สามารถทำการประมวลผล

โปรดสร้างตั๋วใหม่ผ่านแผงของลูกค้า

ขอบคุณสำหรับความช่วยเหลือของคุณ!

ทีม Helpdesk ของคุณ
',
        ' (work units)' => '(ยูนิตที่ทำงาน)',
        '"%s" notification was sent to "%s" by "%s".' => '"%s" การแจ้งเตือนที่ถูกส่งไปยัง "%s" โดย "%s"',
        '"Slim" skin which tries to save screen space for power users.' =>
            'สกีน "สลิม" ซึ่งพยายามที่จะประหยัดพื้นที่หน้าจอสำหรับผู้ใช้ไฟฟ้า',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s หน่วยเวลา (s) ถูกคิดแล้ว ตอนนี้ยอดรวมทั้งหมด %s หน่วยเวลา (s)',
        '(UserLogin) Firstname Lastname' => '(UserLogin) ชื่อนามสกุล',
        '(UserLogin) Lastname Firstname' => '(UserLogin) ชื่อ นามสกุล',
        '(UserLogin) Lastname, Firstname' => '(UserLogin) ชื่อ นามสกุล',
        '*** out of office until %s (%s d left) ***' => '*** ออกจากสำนักงานจนกว่า %s (%s dซ้าย) ***',
        '100 (Expert)' => '100 (เชี่ยวชาญ)',
        '200 (Advanced)' => '200 (ขั้นสูง)',
        '300 (Beginner)' => '300 (ระดับต้น)',
        'A TicketWatcher Module.' => 'โมดูล TicketWatcher',
        'A Website' => 'เว็บไซต์',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'รายการของฟิลด์แบบไดนามิกที่มีการรวมเข้าไปในตั๋วหลักในระหว่างการดำเนินการผสาน เฉพาะฟิลด์แบบไดนามิกที่มีความว่างเปล่าในตั๋วหลักจะถูกตั้งค่า',
        'A picture' => 'รูปภาพ',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'โมดูล ACL อนุญาติให้ปิดตั๋วparent ได้ก็ต่อเมื่อตั๋วchildren ทั้งหมดถูกปิด ("สถานะ" ซึ่งแสดงให้เห็นว่าสถานะจะไม่สามารถใช้ได้สำหรับตั๋วparent จนกระทั่ง ตั๋วchildren ทั้งหมดจะถูกปิด)',
        'Access Control Lists (ACL)' => 'รายการการควบคุมการเข้าถึง (ACL)',
        'AccountedTime' => 'AccountedTime',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'เปิดใช้งานกลไกการกระพริบของคิวที่มีตั๋วที่เก่าที่สุด',
        'Activates lost password feature for agents, in the agent interface.' =>
            'เปิดใช้งานฟีเจอร์การลืมรหัสผ่านสำหรับเอเย่นต์ในอินเตอร์เฟซเอเย่นต์',
        'Activates lost password feature for customers.' => 'เปิดใช้งานฟีเจอร์การลืมรหัสผ่านสำหรับลูกค้า',
        'Activates support for customer groups.' => 'เปิดใช้งานการสนับสนุนสำหรับกลุ่มลูกค้า',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'เปิดใช้งานตัวกรองบทความในมุมมองการซูมเพื่อระบุว่าควรแสดงบทความใด',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'เปิดใช้งานธีมที่มีอยู่ในระบบ ค่า 1หมายถึงใช้งาน, 0 หมายถึงไม่ใช้งาน',
        'Activates the ticket archive system search in the customer interface.' =>
            'เปิดใช้งานการค้นหาระบบเก็บตั๋วในอินเตอร์เฟซลูกค้า',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'เปิดใช้งานระบบเก็บตั๋วจะมีระบบที่เร็วขึ้นโดยการย้ายตั๋วบางส่วนออกจากขอบเขตประจำวัน ในการค้นหาตั๋วเหล่านี้ค่าสถานะหน่วยเก็บถาวรจะต้องมีการเปิดใช้งานในการค้นหาตั๋ว',
        'Activates time accounting.' => 'เปิดใช้งานการนับเวลา',
        'ActivityID' => 'ActivityID',
        'Add a comment.' => '',
        'Add a default name for Dynamic Field.' => '',
        'Add an inbound phone call to this ticket' => 'เพิ่มโทรศัพท์ขาเข้าในตั๋วนี้',
        'Add an outbound phone call to this ticket' => 'เพิ่มโทรศัพท์ขาออกไปยังตั๋วนี้',
        'Added email. %s' => 'อีเมลที่เพิ่มเข้ามา %s',
        'Added link to ticket "%s".' => 'การเชื่อมโยงถูกเพิ่มไปยังตั๋วแล้ว "%s"',
        'Added note (%s)' => 'โน้ตที่เพิ่มเข้ามา (%s)',
        'Added subscription for user "%s".' => 'การสมัครสมาชิกถูกเพิ่มสำหรับผู้ใช้ "%s".',
        'Address book of CustomerUser sources.' => 'สมุดที่อยู่ของแหล่งที่มาของลูกค้าผู้ใช้',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'เพิ่มคำต่อท้ายกับปีและเดือนที่เกิดขึ้นจริงไปยังแฟ้มบันทึกของOTRS  แฟ้มบันทึกสำหรับทุกเดือนจะถูกสร้างขึ้น',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'เพิ่มที่อยู่อีเมลของลูกค้าไปยังผู้รับในหน้าจอเขียนตั๋วของอินเตอร์เฟซตัวแทน ที่อยู่อีเมลของลูกค้าจะไม่ถูกเพิ่มถ้าพิมพ์บทความเป็นอีเมลภายใน',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'เพิ่มวันหยุดครั้งหนึ่งสำหรับปฏิทินตามที่ระบุไว้ กรุณาใช้รูปแบบตัวเลขหลักเดียวสำหรับตัวเลข 1-9 (แทน 01-09)',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'เพิ่มวันหยุดครั้งหนึ่ง กรุณาใช้รูปแบบตัวเลขหลักเดียวสำหรับตัวเลข 1-9 (แทน 01-09)',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'เพิ่มวันหยุดถาวรสำหรับปฏิทินตามที่ระบุไว้ กรุณาใช้รูปแบบตัวเลขหลักเดียวสำหรับตัวเลข 1-9 (แทน 01-09)',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'เพิ่มวันหยุดถาวร กรุณาใช้รูปแบบตัวเลขหลักเดียวสำหรับตัวเลข 1-9 (แทน 01-09)',
        'Admin Area.' => 'ส่วนของแอดมิน',
        'After' => 'หลังจาก',
        'Agent Name' => 'ชื่อเอเย่นต์',
        'Agent Name + FromSeparator + System Address Display Name' => 'ชื่อตัวแทน + FromSeparator + ระบบที่อยู่ของชื่อที่ใช้แสดง',
        'Agent Preferences.' => 'การตั้งค่าตัวแทน',
        'Agent called customer.' => 'เอเย่นต์เรียกลูกค้า',
        'Agent interface article notification module to check PGP.' => 'โมดูลการแจ้งเตือนบทความในอินเตอร์เฟซของเอเย่นต์เพื่อตรวจสอบ PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'โมดูลการแจ้งเตือนบทความในอินเตอร์เฟซของเอเย่นต์เพื่อตรวจสอบ S/MIME.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'โมดูลอินเตอร์เฟซเอเย่นต์ในการเข้าถึงการค้นหา NCIC ผ่าน Navbar การควบคุมการเข้าถึงเพิ่มเติมเพื่อแสดงหรือไม่แสดงการเชื่อมโยงนี้สามารถทำได้โดยใช้คีย์ "กลุ่ม บริษัท " และเนื้อหาเช่น"rw:group1;move_into:group2".',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'โมดูลอินเตอร์เฟซเอเย่นต์ในการเข้าถึงการค้นหาแบบเต็ม ผ่าน Navbar การควบคุมการเข้าถึงเพิ่มเติมเพื่อแสดงหรือไม่แสดงการเชื่อมโยงนี้สามารถทำได้โดยใช้คีย์ "กลุ่ม บริษัท " และเนื้อหาเช่น"rw:group1;move_into:group2".',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'โมดูลอินเตอร์เฟซเอเย่นต์ในการเข้าถึงการค้นหาไฟล์ ผ่าน Navbar การควบคุมการเข้าถึงเพิ่มเติมเพื่อแสดงหรือไม่แสดงการเชื่อมโยงนี้สามารถทำได้โดยใช้คีย์ "กลุ่ม บริษัท " และเนื้อหาเช่น"rw:group1;move_into:group2".',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'โมดูลอินเตอร์เฟซเอเย่นเพื่อตรวจสอบอีเมลที่เข้ามาในTicket-Zoom-View ถ้าคีย์ S / MIMEสามารถใช้ได้และเป็นคีย์ที่ถูกต้อง',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'โมดูลอินเตอร์เฟซเอเย่นต์ในการดูจำนวนตั๋วที่ถูกล็อค การควบคุมการเข้าถึงเพิ่มเติมเพื่อแสดงหรือไม่แสดงการเชื่อมโยงนี้สามารถทำได้โดยใช้คีย์ "กลุ่ม บริษัท " และเนื้อหาเช่น"rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'โมดูลอินเตอร์เฟซเอเย่นต์ในการดูจำนวนตั๋วที่อยู่ภายในการรับผิดชอบของเอเย่นต์ การควบคุมการเข้าถึงเพิ่มเติมเพื่อแสดงหรือไม่แสดงการเชื่อมโยงนี้สามารถทำได้โดยใช้คีย์ "กลุ่ม บริษัท " และเนื้อหาเช่น"rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'โมดูลอินเตอร์เฟซเอเย่นต์ในการดูจำนวนตั๋วที่ใน การบริการของฉัน การควบคุมการเข้าถึงเพิ่มเติมเพื่อแสดงหรือไม่แสดงการเชื่อมโยงนี้สามารถทำได้โดยใช้คีย์ "กลุ่ม บริษัท " และเนื้อหาเช่น"rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'โมดูลอินเตอร์เฟซเอเย่นต์ในการดูจำนวนตั๋วที่ถูกดูแล้ว การควบคุมการเข้าถึงเพิ่มเติมเพื่อแสดงหรือไม่แสดงการเชื่อมโยงนี้สามารถทำได้โดยใช้คีย์ "กลุ่ม บริษัท " และเนื้อหาเช่น"rw:group1;move_into:group2".',
        'AgentCustomerSearch' => 'AgentCustomerSearch',
        'AgentCustomerSearch.' => 'AgentCustomerSearch',
        'AgentUserSearch' => 'AgentUserSearch',
        'AgentUserSearch.' => 'AgentUserSearch.',
        'Agents <-> Groups' => 'เอเย่นต์ <-> กลุ่ม',
        'Agents <-> Roles' => 'เอเย่นต์ <-> บทบาท',
        'All customer users of a CustomerID' => 'ลูกค้าผู้ใช้ทั้งหมดของ CustomerID',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'อนุญาตให้เพิ่มโน้ตในหน้าจอตั๋วปิดของอินเตอร์เฟซเอเย่นต์ ซึ่งสามารถเขียนทับโดย Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'อนุญาตให้เพิ่มโน้ตในหน้าจอตั๋วข้อความอิสระของอินเตอร์เฟซเอเย่นต์ ซึ่งสามารถเขียนทับโดย Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'อนุญาตให้เพิ่มโน้ตในหน้าจอโน้ตของตั๋วของอินเตอร์เฟซเอเย่นต์ ซึ่งสามารถเขียนทับโดย Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'อนุญาตให้เพิ่มโน้ตในหน้าจอเจ้าของตั๋วของตั๋วซูมในอินเตอร์เฟซเอเย่นต์ ซึ่งสามารถเขียนทับโดย Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'อนุญาตให้เพิ่มโน้ตในหน้าจอตั๋วที่รอดำเนินการของตั๋วซูมในอินเตอร์เฟซเอเย่นต์ ซึ่งสามารถเขียนทับโดย Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'อนุญาตให้เพิ่มโน้ตในหน้าจอลำดับความสำคัญของตั๋วของตั๋วซูมในอินเตอร์เฟซเอเย่นต์ ซึ่งสามารถเขียนทับโดย Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'อนุญาตให้เพิ่มโน้ตในหน้าจอผู้รับผิดชอบตั๋วของอินเตอร์เฟซเอเย่นต์ ซึ่งสามารถเขียนทับโดย Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'อนุญาตให้ตัวแทนแลกเปลี่ยนแกนของสถิติถ้าพวกเขาสร้างแค่หนึ่ง',
        'Allows agents to generate individual-related stats.' => 'อนุญาตให้เอเย่นต์สร้างสถิติของแต่ละบุคคลที่เกี่ยวข้อง',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'อนุญาตให้เลือกระหว่างแสดงสิ่งที่แนบมาของตั๋วในเบราว์เซอร์ (อินไลน์)หรือทำให้พวกเขาสามารถดาวน์โหลดเท่านั่น (ที่แนบมา)',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'อนุญาตให้เลือกสถานะการเขียนครั้งต่อไปสำหรับตั๋วลูกค้าในอินเตอร์เฟซของลูกค้า',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'อนุญาตให้ลูกค้าเปลี่ยนลำดับความสำคัญของตั๋วในอินเตอร์เฟซของลูกค้า',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'อนุญาตให้ลูกค้ากำหนด SLA ของตั๋วในอินเตอร์เฟซของลูกค้า',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'อนุญาตให้ลูกค้ากำหนดลำดับความสำคัญในอินเตอร์เฟซของลูกค้า',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'อนุญาตให้ลูกค้ากำหนดคิวของตั๋วในอินเตอร์เฟซของลูกค้า หากกำหนดให้เป็น \'ไม่ QueueDefault ควรจะกำหนดค่า',
        'Allows customers to set the ticket service in the customer interface.' =>
            'อนุญาตให้ลูกค้ากำหนดการบริการตั๋วในอินเตอร์เฟซของลูกค้า',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'อนุญาตให้ลูกค้ากำหนดประเภทของตั๋วในอินเตอร์เฟซของลูกค้า หากกำหนดให้เป็น \'ไม่ TicketTypeDefault ควรจะกำหนดค่า',
        'Allows default services to be selected also for non existing customers.' =>
            'อนุญาตให้การบริการเริ่มต้นเป็นตัวเลือกสำหรับลูกค้าที่มียังไม่มี',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'อนุญาตให้กำหนดประเภทใหม่สำหรับตั๋ว (ถ้าคุณลักษณะประเภทตั๋วถูกเปิดใช้งาน)',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'อนุญาตให้กำหนดการบริการและ SLAs สำหรับตั๋ว (เช่นอีเมล,เดสก์ทอป, เครือข่าย, ... ) และแอตทริบิวต์การขยายสำหรับ SLAs (ถ้าการบริการตั๋ว / ฟีเจอร์ SLA ถูกเปิดใช้งาน)',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows generic agent to execute custom command line scripts.' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'อนุญาตให้มีรูปแบบภาพรวมของตั๋วขนาดกลาง (customerinfo => 1 - แสดงข้อมูลของลูกค้าอีกด้วย)',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'อนุญาตให้มีรูปแบบภาพรวมของตั๋วขนาดเล็ก (customerinfo => 1 - แสดงข้อมูลของลูกค้าอีกด้วย)',
        'Allows invalid agents to generate individual-related stats.' => 'อนุญาตให้เอเย่นต์ที่ไม่ถูกต้องสร้างสถิติของแต่ละบุคคลที่เกี่ยวข้อง',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'อนุญาตให้ผู้ดูแลระบบเข้าสู่ระบบเป็นลูกค้า ผ่านแผงการจัดการลูกค้าผู้ใช้',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'อนุญาตให้ผู้ดูแลระบบเข้าสู่ระบบเป็นลูกค้า ผ่านแผงการจัดการผู้ใช้',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'อนุญาตให้กำหนดสถานะตั๋วใหม่ในหน้าจอการย้ายตั๋วของอินเตอร์เฟซเอเย่นต์',
        'Always show RichText if available' => 'แสดง RichText อยู่เสมอด้วยถ้ามี',
        'Arabic (Saudi Arabia)' => 'ภาษาอาหรับ (ซาอุดีอาระเบีย)',
        'Archive state changed: "%s"' => 'สถานะของหน่วยเก็บถาวรได้เปลี่ยนแปลง: "%s"',
        'ArticleTree' => 'ArticleTree',
        'Attachments <-> Templates' => 'เอกสารที่แนบมา <-> แม่แบบ',
        'Auto Responses <-> Queues' => 'การตอบสนองอัตโนมัติ <-> คิว',
        'AutoFollowUp sent to "%s".' => 'ส่ง AutoFollowUp ไปยัง "%s".',
        'AutoReject sent to "%s".' => 'ส่ง AutoReject ไปยัง "%s".',
        'AutoReply sent to "%s".' => 'ส่ง AutoReply ไปยัง "%s".',
        'Automated line break in text messages after x number of chars.' =>
            'แบ่งบรรทัดอัตโนมัติในข้อความหลังจากจำนวนตัวอักษร  x ',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'ล็อคอัตโนมัติและกำหนดเจ้าของไปยังเอเย่นต์ในปัจจุบันหลังจากที่เปิดหน้าจอการย้ายตั๋วของอินเตอร์เฟซเอเย่นต์',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'ล็อคอัตโนมัติและตั้งค่าเจ้าของเป็นเอเย่นต์ปัจจุบันหลังจากถูกเลือกสำหรับการทำงานเป็นกลุ่ม',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'ืกำหนดเจ้าของตั๋วเป็นผู้รับผิดชอบสำหรับมันโดยอัตโนมัติ (ถ้าฟีเจอรตั๋วที่รับผิดชอบเปิดใช้งาน) ทำงานโดยการกระทำของผู้ใช้ที่ล็อกอิน มันไม่ทำงานสำหรับการดำเนินการโดยอัตโนมัติเช่น',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'กำหนดผู้รับผิดชอบตั๋วอัตโนมัติ(หากยังไม่ได้ตั้งค่า) หลังจากที่อัพเดตเจ้าของคนแรก',
        'Balanced white skin by Felix Niklas (slim version).' => 'รักษาความสมดุลของสกีนสีขาวโดย Felix Niklas (รุ่นบาง)',
        'Balanced white skin by Felix Niklas.' => 'รักษาความสมดุลของสกีนสีขาวโดย Felix Niklas',
        'Based on global RichText setting' => 'ขึ้นอยู่กับการตั้งค่าทั่วไปของ RichText',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            'การตั้งค่าดัชนีข้อความเต็มขั้นพื้นฐาน ดำเนินการ  "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" เพื่อสร้างดัชนีใหม่',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'บล็อกอีเมลขาเข้าทั้งหมดที่ไม่มีจำนวนตั๋วที่ถูกต้องในหัวข้อที่มี From: @example.com address.',
        'Bounced to "%s".' => 'ตีกลับไปยัง "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'สร้างดัชนีบทความทันทีหลังจากสร้างบทความ',
        'Bulgarian' => 'ภาษาบุลกาเรีย',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'ตัวอย่างการติดตั้ง CMD ละเว้นอีเมลที่ CMD ภายนอกส่งกลับเอาท์พุทบางส่วนใน STDOUT (อีเมล์จะถูกส่งเข้าไปยัง STDIN ของ some.bin)',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'แคชเเวลาป็นวินาทีสำหรับการตรวจสอบเอเย่นต์ใน GenericInterface',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'แคชเเวลาป็นวินาทีสำหรับการตรวจสอบลูกค้าใน GenericInterface',
        'Cache time in seconds for the DB ACL backend.' => 'แคชเเวลาป็นวินาทีสำหรับแบ็กเอนด์ของ DB ACL',
        'Cache time in seconds for the DB process backend.' => 'แคชเเวลาป็นวินาทีสำหรับกระบวนการเบื้องหลังของ DB ',
        'Cache time in seconds for the SSL certificate attributes.' => 'แคชเเวลาป็นวินาทีสำหรับแอตทริบิวต์ของใบรับรอง SSL',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'แคชเเวลาป็นวินาทีสำหรับแถบนำทางกระบวนการตั๋วโมดูลเอาท์พุท',
        'Cache time in seconds for the web service config backend.' => 'แคชเเวลาป็นวินาทีสำหรับการตั้งค่าส่วนหลังของ web service ',
        'Catalan' => 'Catalan',
        'Change password' => 'เปลี่ยนรหัสผ่าน',
        'Change queue!' => 'เปลี่ยนคิว!',
        'Change the customer for this ticket' => 'เปลี่ยนลูกค้าสำหรับตั๋วนี้',
        'Change the free fields for this ticket' => 'เปลี่ยนฟิลด์ฟรีสำหรับตั๋วนี้',
        'Change the priority for this ticket' => 'เปลี่ยนลำดับความสำคัญสำหรับตั๋วนี้',
        'Change the responsible for this ticket' => 'เปลี่ยนผู้รับผิดชอบสำหรับตั๋วนี้',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'เปลี่ยนลำดับความสำคัญจาก "%s" (%s) เป็น "%s" (%s)',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'เปลี่ยนเจ้าของตั๋วเป็นทุกคน (มีประโยชน์สำหรับ ASP) โดยปกติมีเอเย่นต์เท่านั้นที่มีสิทธิ์ในการ RW ในคิวของตั๋วที่จะแสดง',
        'Checkbox' => 'กล่องตรวจสอบ',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'ตรวจสอบ หากอีเมลนั้นๆคือการติดตามตั๋วที่มีอยู่โดยการค้นหาหัวข้อสำหรับจำนวนตั๋วที่ถูกต้อง',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'ตรวจสอบ SystemID  ในการตรวจจับจำนวนตั๋วสำหรับการติดตาม (ใช้ "ไม่" ถ้า SystemID  มีการเปลี่ยนแปลงหลังการใช้ระบบ)',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            'ตรวจสอบความพร้อมของOTRS Business Solution™ สำหรับระบบนี้',
        'Checks the entitlement status of OTRS Business Solution™.' => 'ตรวจสอบสถานะด้านสิทธิของOTRS Business Solution™ ',
        'Chinese (Simplified)' => 'ภาษาจีน (ประยุกต์)',
        'Chinese (Traditional)' => 'ภาษาจีน (ดั้งเดิม) ',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            'เลือกประเภทของการเปลี่ยนแปลงตั๋วที่คุณต้องการที่จะรับการแจ้งเตือน',
        'Closed tickets (customer user)' => 'ตั๋วที่ปิดแล้ว (ลูกค้าผู้ใช้)',
        'Closed tickets (customer)' => 'ตั๋วที่ปิดแล้ว (ลูกค้า)',
        'Cloud Services' => 'การบริการระบบคลาวด์',
        'Cloud service admin module registration for the transport layer.' =>
            'การลงทะเบียนโมดูลบริการดูแลระบบคลาวด์สำหรับชั้นขนส่ง',
        'Collect support data for asynchronous plug-in modules.' => 'เก็บรวบรวมข้อมูลสนับสนุนสำหรับโมดูลปลั๊กอินที่ไม่ตรงกัน',
        'Column ticket filters for Ticket Overviews type "Small".' => 'คอลัมน์ตัวกรองตั๋วสำหรับประเภทภาพรวมตั๋ว "เล็ก ๆ "',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'คอลัมน์ที่สามารถกรองในมุมมองของการขยายของอินเตอร์เฟซเอเย่นต์ การตั้งค่าที่เป็นไปได้: 0 = ปิดใช้งาน 1 = พร้อมใช้ 2 = เปิดใช้งานตามค่าเริ่มต้น หมายเหตุ: เฉพาะแอตทริบิวต์ของตั๋ว,ไดนามิกฟิลด์ (DynamicField_NameX) และแอตทริบิวต์ของลูกค้า (เช่น CustomerUserPhone, CustomerCompanyName, ... ) เท่านั้นที่ได้รับอนุญาต',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'คอลัมน์ที่สามารถกรองในมุมมองที่ถูกล็อกของอินเตอร์เฟซเอเย่นต์ การตั้งค่าที่เป็นไปได้: 0 = ปิดใช้งาน 1 = พร้อมใช้ 2 = เปิดใช้งานตามค่าเริ่มต้น หมายเหตุ: เฉพาะแอตทริบิวต์ของตั๋ว,ไดนามิกฟิลด์ (DynamicField_NameX) และแอตทริบิวต์ของลูกค้า (เช่น CustomerUserPhone, CustomerCompanyName, ... ) เท่านั้นที่ได้รับอนุญาต',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'คอลัมน์ที่สามารถกรองในมุมมองของคิวของอินเตอร์เฟซเอเย่นต์ การตั้งค่าที่เป็นไปได้: 0 = ปิดใช้งาน 1 = พร้อมใช้ 2 = เปิดใช้งานตามค่าเริ่มต้น หมายเหตุ: เฉพาะแอตทริบิวต์ของตั๋ว,ไดนามิกฟิลด์ (DynamicField_NameX) และแอตทริบิวต์ของลูกค้า (เช่น CustomerUserPhone, CustomerCompanyName, ... ) เท่านั้นที่ได้รับอนุญาต',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'คอลัมน์ที่สามารถกรองในมุมมองของผู้รับผิดชอบขยายของอินเตอร์เฟซเอเย่นต์ การตั้งค่าที่เป็นไปได้: 0 = ปิดใช้งาน 1 = พร้อมใช้ 2 = เปิดใช้งานตามค่าเริ่มต้น หมายเหตุ: เฉพาะแอตทริบิวต์ของตั๋ว,ไดนามิกฟิลด์ (DynamicField_NameX) และแอตทริบิวต์ของลูกค้า (เช่น CustomerUserPhone, CustomerCompanyName, ... ) เท่านั้นที่ได้รับอนุญาต',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'คอลัมน์ที่สามารถกรองในมุมมองของการบริการของอินเตอร์เฟซเอเย่นต์ การตั้งค่าที่เป็นไปได้: 0 = ปิดใช้งาน 1 = พร้อมใช้ 2 = เปิดใช้งานตามค่าเริ่มต้น หมายเหตุ: เฉพาะแอตทริบิวต์ของตั๋ว,ไดนามิกฟิลด์ (DynamicField_NameX) และแอตทริบิวต์ของลูกค้า (เช่น CustomerUserPhone, CustomerCompanyName, ... ) เท่านั้นที่ได้รับอนุญาต',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'คอลัมน์ที่สามารถกรองในมุมมองสถานะของอินเตอร์เฟซเอเย่นต์ การตั้งค่าที่เป็นไปได้: 0 = ปิดใช้งาน 1 = พร้อมใช้ 2 = เปิดใช้งานตามค่าเริ่มต้น หมายเหตุ: เฉพาะแอตทริบิวต์ของตั๋ว,ไดนามิกฟิลด์ (DynamicField_NameX) และแอตทริบิวต์ของลูกค้า (เช่น CustomerUserPhone, CustomerCompanyName, ... ) เท่านั้นที่ได้รับอนุญาต',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'คอลัมน์ที่สามารถกรองในมุมมองการค้นหาตั๋วของอินเตอร์เฟซเอเย่นต์ การตั้งค่าที่เป็นไปได้: 0 = ปิดใช้งาน 1 = พร้อมใช้ 2 = เปิดใช้งานตามค่าเริ่มต้น หมายเหตุ: เฉพาะแอตทริบิวต์ของตั๋ว,ไดนามิกฟิลด์ (DynamicField_NameX) และแอตทริบิวต์ของลูกค้า (เช่น CustomerUserPhone, CustomerCompanyName, ... ) เท่านั้นที่ได้รับอนุญาต',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'คอลัมน์ที่สามารถกรองในมุมมองการดูของอินเตอร์เฟซเอเย่นต์ การตั้งค่าที่เป็นไปได้: 0 = ปิดใช้งาน 1 = พร้อมใช้ 2 = เปิดใช้งานตามค่าเริ่มต้น หมายเหตุ: เฉพาะแอตทริบิวต์ของตั๋ว,ไดนามิกฟิลด์ (DynamicField_NameX) และแอตทริบิวต์ของลูกค้า (เช่น CustomerUserPhone, CustomerCompanyName, ... ) เท่านั้นที่ได้รับอนุญาต',
        'Comment for new history entries in the customer interface.' => 'แสดงความคิดเห็นสำหรับประวัติที่ถูกป้อนใหม่ในอินเตอร์เฟซลูกค้า',
        'Comment2' => 'ความคิดเห็นที่ 2',
        'Communication' => 'การสื่อสาร',
        'Company Status' => 'สถานนะของบริษัท',
        'Company Tickets.' => 'ตั๋วบริษัท',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'ชื่อบริษัทที่จะรวมอยู่ในอีเมลขาออกเป็น ส่วนหัว X',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'โมดูล Compat สำหรับ AgentZoom ไปยัง AgentTicketZoom',
        'Complex' => 'ซับซ้อน',
        'Configure Processes.' => 'กระบวนการกำหนดค่า',
        'Configure and manage ACLs.' => 'กำหนดค่าและจัดการ ACLs',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'กำหนดค่าฐานข้อมูลสะท้อนของ อ่านเท่านั้น ที่คุณต้องการใช้',
        'Configure sending of support data to OTRS Group for improved support.' =>
            'กำหนดค่าการส่งข้อมูลการสนับสนุนให้กับกลุ่มOTRS สำหรับการสนับสนุนที่ดีขึ้น',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'กำหนดค่าว่าหน้าจอใดควรจะแสดงหลังจากที่ตั๋วใหม่ถูกสร้างขึ้น',
        'Configure your own log text for PGP.' => 'กำหนดค่าข้อความบันทึกของคุณสำหรับ PGP',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            'กำหนดค่าค่าเริ่มต้นของการตั้งค่า TicketDynamicField "ชื่อ" จะกำหนดฟิลด์แบบไดนามิกที่จะนำมาใช้ "ค่า" เป็นข้อมูลที่จะถูกตั้งค่าและ "กิจกรรม" จะกำหนดตัวกระตุ้นกิจกรรม กรุณาตรวจสอบคู่มือการพัฒนา (http://otrs.github.io/doc/) บท "Ticket Event Module".',
        'Controls how to display the ticket history entries as readable values.' =>
            'ควบคุมวิธีการแสดงรายการประวัติตั๋วเป็นค่าที่สามารถอ่าน',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'ควบคุมหากลูกค้ามีความสามารถในการจัดเรียงตั๋วของพวกเขา',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'ควบคุมหากมีมากกว่าหนึ่งรายการสามารถตั้งค่าในตั๋วโทรศัพท์ใหม่ในอินเตอร์เฟซเอเย่นต์',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'ควบคุมหากผู้ดูแลระบบได้รับอนุญาตเพื่อนำเข้าการกำหนดค่าระบบที่บันทึกอยู่ใน sysconfig',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'ควบคุมหากผู้ดูแลระบบได้รับอนุญาตให้ทำกาเปลี่ยนแปลงไปยังฐานข้อมูลผ่านทาง AdminSelectBox',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'ควบคุมหากตั๋วและบทความค่าสถานะที่มองเห็นได้จะถูกลบออกเมื่อตั๋วถูกเก็บไว้',
        'Converts HTML mails into text messages.' => 'แปลงอีเมล HTML เป็นข้อความ',
        'Create New process ticket.' => 'สร้างตั๋วกระบวนการใหม่',
        'Create Ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'สร้างและจัดการข้อตกลงระดับการให้บริการ (SLAs)',
        'Create and manage agents.' => 'สร้างและจัดการกับเอเย่นต์',
        'Create and manage attachments.' => 'สร้างและจัดการสิ่งที่แนบมา',
        'Create and manage customer users.' => 'สร้างและจัดการผู้ใช้ลูกค้า',
        'Create and manage customers.' => 'สร้างและจัดการลูกค้า',
        'Create and manage dynamic fields.' => 'สร้างและจัดการฟิลด์แบบไดนามิก',
        'Create and manage groups.' => 'สร้างและจัดการกลุ่ม',
        'Create and manage queues.' => 'สร้างและจัดการคิว',
        'Create and manage responses that are automatically sent.' => 'สร้างและจัดการการตอบสนองที่ถูกส่งอัตโนมัติ',
        'Create and manage roles.' => 'สร้างและจัดการบทบาท',
        'Create and manage salutations.' => 'สร้างและจัดการคำขึ้นต้นจดหมาย',
        'Create and manage services.' => 'สร้างและจัดการการบริการ',
        'Create and manage signatures.' => 'สร้างและจัดการลายเซ็น',
        'Create and manage templates.' => 'สร้างและจัดการรูปแบบ',
        'Create and manage ticket notifications.' => 'สร้างและจัดการการแจ้งเตือนตั๋ว',
        'Create and manage ticket priorities.' => 'สร้างและจัดการลำดับความสำคัญของตั๋ว',
        'Create and manage ticket states.' => 'สร้างและจัดการสถานะตั๋ว',
        'Create and manage ticket types.' => 'สร้างและจัดการกับประเภทของตั๋ว',
        'Create and manage web services.' => 'สร้างและจัดการ web services',
        'Create new Ticket.' => 'สร้างตั๋วใหม่',
        'Create new email ticket and send this out (outbound).' => 'สร้างอีเมล์ตั๋วใหม่และส่งออก(Outbound)',
        'Create new email ticket.' => 'สร้างอีเมล์ตั๋วใหม่',
        'Create new phone ticket (inbound).' => 'สร้างตั๋วโทรศัพท์ใหม่ (ขาเข้า)',
        'Create new phone ticket.' => 'สร้างตั๋วจากโทรศัพท์ใหม่',
        'Create new process ticket.' => 'สร้างตั๋วกระบวนการใหม่',
        'Create tickets.' => 'สร้างตั๋ว',
        'Croatian' => 'ภาษาโครเอเชีย',
        'Custom RSS Feed' => 'กำหนด RSS Feed เอง',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'ข้อความที่กำหนดเองสำหรับหน้าเว็บที่แสดงลูกค้าที่ยังไม่มีตั๋ว(ถ้าคุณต้องการแปลข้อความเหล่านั้น ต้องเพิ่มเข้าไปในโมดูลการแปลที่กำหนดเอง)',
        'Customer Administration' => 'การบริหารลูกค้า',
        'Customer Information Center Search.' => 'การค้นหาศูนย์ข้อมูลลูกค้า',
        'Customer Information Center.' => 'ศูนย์ข้อมูลลูกค้า',
        'Customer Ticket Print Module.' => 'โมดูลพิมพ์ตั๋วลูกค้า',
        'Customer User <-> Groups' => 'ลูกค้าผู้ใช้ <-> กลุ่ม',
        'Customer User <-> Services' => 'ลูกค้าผู้ใช้ <-> การบริการ',
        'Customer User Administration' => 'การบริหารลูกค้าผู้ใช้',
        'Customer Users' => 'ลูกค้าผู้ใช้',
        'Customer called us.' => 'ลูกค้าติดต่อเรา',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'รายการของลูกค้า (ไอคอน)ซึ่งจะแสดงตั๋วปิดของลูกค้ารายนี้เป็นบล็อกข้อมูล ตั้งค่า CustomerUserLogin เป็น 1 เพื่อค้นหาตั๋วตามชื่อสำหรับเข้าสู่ระบบมากกว่าCustomerID',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'รายการของลูกค้า (ไอคอน)ซึ่งจะแสดงตั๋วปิดของลูกค้ารายนี้เป็นบล็อกข้อมูล ตั้งค่า CustomerUserLogin เป็น 1 เพื่อค้นหาตั๋วตามชื่อสำหรับเข้าสู่ระบบมากกว่าCustomerID',
        'Customer preferences.' => 'การกำหนดลักษณะของลูกค้า',
        'Customer request via web.' => 'คำขอของลูกค้าผ่านทางเว็บ',
        'Customer ticket overview' => 'ภาพรวมตั๋วของลูกค้า',
        'Customer ticket search.' => 'การค้นหาตั๋วลูกค้า',
        'Customer ticket zoom' => 'ซูมตั๋วของลูกค้า',
        'Customer user search' => 'การค้นหาลูกค้าผู้ใช้',
        'CustomerID search' => 'การค้นหาไอดีลูกค้า',
        'CustomerName' => 'CustomerName',
        'CustomerUser' => 'CustomerUser',
        'Customers <-> Groups' => 'ลูกค้า <-> กลุ่ม',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'ปรับแต่งคำหยุดสำหรับดัชนี Fulltext คำเหล่านี้จะถูกลบออกจากดัชนีการค้นหา',
        'Czech' => 'ภาษาเช็ก',
        'DEPRECATED: This config setting will be removed in further versions of OTRS. Sets the time (in seconds) a user is marked as active (minimum active time is 300 seconds).' =>
            '',
        'Danish' => 'ภาษาเดนมาร์ก',
        'Data used to export the search result in CSV format.' => 'ข้อมูลถูกนำมาใช้เพื่อส่งออกผลการค้นหาในรูปแบบ CSV',
        'Date / Time' => 'วัน / เวลา',
        'Debug' => 'การแก้ปัญหา',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'แก้ปัญหาการตั้งค่าการแปล หากมีการตั้งไว้ที่ "ใช่" สตริงทั้งหมด (ข้อความ) ที่ไม่มีการแปลจะถูกเขียนไปยัง STDERR ซึ่งมีประโยชน์เมื่อคุณจะสร้างไฟล์การแปลใหม่ มิฉะนั้นแล้วตัวเลือกนี้จะยังคงตั้งค่าเป็น "ไม่"',
        'Default' => 'เริ่มต้น',
        'Default (Slim)' => 'เริ่มต้น (Slim)',
        'Default ACL values for ticket actions.' => 'ค่า ACL เริ่มต้นสำหรับการกระทำของตั๋ว',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'เอนทิตีเริ่มต้นของ ProcessManagement จะนำหน้า ID ของเอนทิตีที่สร้างขึ้นโดยอัตโนมัติ',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'ข้อมูลเริ่มต้นที่จะใช้ในแอตทริบิวต์สำหรับหน้าจอการค้นหาตั๋ว ตัวอย่าง: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;"',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'ข้อมูลเริ่มต้นที่จะใช้ในแอตทริบิวต์สำหรับหน้าจอการค้นหาตั๋ว ตัวอย่าง: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;"',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'ประเภทการแสดงผลเริ่มต้นสำหรับผู้รับ (To, CC) ชื่ออยู่ใน AgentTicketZoom และ CustomerTicketZoom',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'ประเภทการแสดงผลเริ่มต้นสำหรับผู้ส่ง (From) ชื่ออยู่ใน AgentTicketZoom และ CustomerTicketZoom',
        'Default loop protection module.' => 'โมดูลการป้องกันการวนรอบเริ่มต้น',
        'Default queue ID used by the system in the agent interface.' => 'ไอดีคิวเริ่มต้นถูกใช้โดยระบบในอินเตอร์เฟซเอเย่นต์',
        'Default skin for the agent interface (slim version).' => 'สกีนเริ่มต้นสำหรับอินเตอร์เฟซเอเย่นต์ (รุ่นบาง)',
        'Default skin for the agent interface.' => 'สกีนเริ่มต้นสำหรับอินเตอร์เฟซเอเย่นต์',
        'Default skin for the customer interface.' => 'สกีนเริ่มต้นสำหรับอินเตอร์เฟซเลูกค้า (รุ่นบาง)',
        'Default ticket ID used by the system in the agent interface.' =>
            'ไอดีตั๋วเริ่มต้นถูกใช้โดยระบบในอินเตอร์เฟซเอเย่นต์',
        'Default ticket ID used by the system in the customer interface.' =>
            'ไอดีตั๋วเริ่มต้นถูกใช้โดยระบบในอินเตอร์เฟซลูกค้า',
        'Default value for NameX' => 'ค่าเริ่มต้นสำหรับ NameX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'กำหนดตัวกรองสำหรับการแสดงผล HTMLเพื่อเพิ่มการเชื่อมโยงที่อยู่เบื้องหลังของอักขระที่กำหนดไว้ องค์ประกอบของภาพที่จะช่วยให้สามารถป้อนข้อมูลสองชนิดได้ หนึ่งคือชื่อของภาพ (เช่น faq.png)ในกรณีนี้เส้นทางของภาพOTRS จะถูกนำมาใช้ สองคือการแทรกการเชื่อมโยงไปยังภาพ',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            'กำหนดแผนที่ระหว่างตัวแปรข้อมูลของลูกค้าผู้ใช้ล(คีย์) และฟิลด์แบบไดนามิกของตั๋ว (ค่า )จุดประสงค์ในการจัดเก็บข้อมูลของลูกค้าผู้ใช้ในฟิลด์แบบไดนามิกของตั๋ว ฟิลด์แบบไดนามิกจะต้องนำเสนอในระบบและควรจะมีการเปิดใช้งานสำหรับ AgentTicketFreeText, เพื่อให้พวกเขาสามารถตั้งค่า / อัพเดตด้วยตนเองโดยเอเย่นต์ พวกเขาจะต้องไม่ถูกเปิดใช้งานสำหรับ AgentTicketPhone, AgentTicketEmail และ AgentTicketCustomer หากพวกเขาถูกเปิดใช้งาน พวกเขาจะมีความสำคัญมากกว่าค่าที่ตั้งค่าโดยอัตโนมัติ ในการใช้งานแผนที่นี้คุณต้องเปิดใช้การตั้งค่ายังครั้งต่อไปดังต่อไปนี้',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'กำหนดชื่อฟิลด์แบบไดนามิกสำหรับเวลาสิ้นสุด ข้อมูลนี้จะต้องมีการเพิ่มด้วยตนเองในระบบเป็นตั๋ว: "วันที่ / เวลา" และจะต้องเปิดใช้งานในหน้าจอการสร้างตั๋ว และ/หรือ ในหน้าจอการดำเนินการตั๋วอื่นๆ ',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'กำหนดชื่อฟิลด์แบบไดนามิกสำหรับเวลาเริ่มต้น ข้อมูลนี้จะต้องมีการเพิ่มด้วยตนเองในระบบเป็นตั๋ว: "วันที่ / เวลา" และจะต้องเปิดใช้งานในหน้าจอการสร้างตั๋ว และ/หรือ ในหน้าจอการดำเนินการตั๋วอื่นๆ ',
        'Define the max depth of queues.' => 'กำหนดความลึกสูงสุดของคิว',
        'Define the queue comment 2.' => 'กำหนดการแสดงความคิดเห็นเกี่ยวกับคิวที่ 2',
        'Define the service comment 2.' => 'กำหนดการแสดงความคิดเห็นเกี่ยวกับการบริการที่ 2',
        'Define the sla comment 2.' => 'กำหนดการแสดงความคิดเห็นเกี่ยวกับsla ที่ 2',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'กำหนดวันเริ่มต้นของสัปดาห์สำหรับตัวเลือกวันสำหรับปฏิทินที่ระบุไว้',
        'Define the start day of the week for the date picker.' => 'กำหนดวันเริ่มต้นของสัปดาห์สำหรับตัวเลือกวัน',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'กำหนดรายการลูกค้าซึ่งจะสร้างไอคอน LinkedIn ในตอนท้ายของบล็อกข้อมูลลูกค้า',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'กำหนดรายการลูกค้าซึ่งจะสร้างไอคอน XING  ในตอนท้ายของบล็อกข้อมูลลูกค้า',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'กำหนดรายการลูกค้าซึ่งจะสร้างไอคอน google ในตอนท้ายของบล็อกข้อมูลลูกค้า',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'กำหนดรายการลูกค้าซึ่งจะสร้างไอคอน google maps ในตอนท้ายของบล็อกข้อมูลลูกค้า',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'กำหนดรายการเริ่มต้นของคำที่ได้รับการปฏิเสธโดยตรวจสอบการสะกด',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'กำหนดตัวกรองสำหรับการแสดงผล HTMLเพื่อเพิ่มการเชื่อมโยงที่อยู่เบื้องหลังของหมายเลข CVE องค์ประกอบของภาพที่จะช่วยให้สามารถป้อนข้อมูลสองชนิดได้ หนึ่งคือชื่อของภาพ (เช่น faq.png)ในกรณีนี้เส้นทางของภาพOTRS จะถูกนำมาใช้ สองคือการแทรกการเชื่อมโยงไปยังภาพ',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'กำหนดตัวกรองสำหรับการแสดงผล HTMLเพื่อเพิ่มการเชื่อมโยงที่อยู่เบื้องหลังของหมายเลข MSBulletin องค์ประกอบของภาพที่จะช่วยให้สามารถป้อนข้อมูลสองชนิดได้ หนึ่งคือชื่อของภาพ (เช่น faq.png)ในกรณีนี้เส้นทางของภาพOTRS จะถูกนำมาใช้ สองคือการแทรกการเชื่อมโยงไปยังภาพ',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'กำหนดตัวกรองสำหรับการแสดงผล HTMLเพื่อเพิ่มการเชื่อมโยงที่อยู่เบื้องหลังของอักขระที่กำหนดไว้ องค์ประกอบของภาพที่จะช่วยให้สามารถป้อนข้อมูลสองชนิดได้ หนึ่งคือชื่อของภาพ (เช่น faq.png)ในกรณีนี้เส้นทางของภาพOTRS จะถูกนำมาใช้ สองคือการแทรกการเชื่อมโยงไปยังภาพ',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'กำหนดตัวกรองสำหรับการแสดงผล HTMLเพื่อเพิ่มการเชื่อมโยงที่อยู่เบื้องหลังของหมายเลข bugtraq องค์ประกอบของภาพที่จะช่วยให้สามารถป้อนข้อมูลสองชนิดได้ หนึ่งคือชื่อของภาพ (เช่น faq.png)ในกรณีนี้เส้นทางของภาพOTRS จะถูกนำมาใช้ สองคือการแทรกการเชื่อมโยงไปยังภาพ',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'กำหนดตัวกรองเพื่อประมวลผลข้อความในบทความเพื่อที่จะเน้นคำหลักที่กำหนดไว้ล่วงหน้า',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'กำหนดนิพจน์ปกติที่ไม่รวมที่อยู่บางส่วนจากการตรวจสอบไวยากรณ์ (ถ้า "CheckEmailAddresses" ตั้งค่าเป็น "ใช่")กรุณากด regexในช่องนี้สำหรับที่อยู่อีเมล มีนไม่ใช่การสร้างประโยคที่ถูกต้อง แต่เป็นสิ่งจำเป็นสำหรับระบบ (เช่น "root@localhost")',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'กำหนดนิพจน์ปกติที่กรองที่อยู่อีเมลทั้งหมดที่ไม่ควรนำมาใช้ในแอพลิเคชั่น',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'กำหนดเวลาการพักใน microseconds ระหว่างตั๋วในขณะที่พวกเขาผ่านการประมวลผลจากงาน',
        'Defines a useful module to load specific user options or to display news.' =>
            'กำหนดโมดูลที่มีประโยชน์เพื่อโหลดตัวเลือกผู้ใช้ที่ระบุหรือเพื่อแสดงข่าว',
        'Defines all the X-headers that should be scanned.' => 'กำหนดX-ส่วนหัวทั้งหมดที่ควรจะสแกน',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'กำหนดทุกภาษาที่มีอยู่ไปยังโปรแกรมประยุกต์ และระบุชื่อภาษานั่นๆที่นี่เป็นภาษาอังกฤษเท่านั้น',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'กำหนดทุกภาษาที่มีอยู่ไปยังโปรแกรมประยุกต์ และระบุชื่อภาษานั่นๆที่นี้',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'กำหนดพารามิเตอร์ทั้งหมดสำหรับออบเจค RefreshTime ในการตั้งค่าลูกค้าของอินเตอร์เฟซลูกค้า',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'กำหนดพารามิเตอร์ทั้งหมดสำหรับออบเจค ShownTickets ในการตั้งค่าลูกค้าของอินเตอร์เฟซลูกค้า',
        'Defines all the parameters for this item in the customer preferences.' =>
            'กำหนดพารามิเตอร์ทั้งหมดสำหรับรายการนี้ในการตั้งค่าลูกค้า',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => 'กำหนดพารามิเตอร์ทั้งหมดสำหรับการขนส่งการแจ้งเตือนนี้',
        'Defines all the possible stats output formats.' => 'กำหนดรูปแบบผลผลิตสถิติที่เป็นไปได้ทั้งหมด',
        'Defines an alternate URL, where the login link refers to.' => 'กำหนด URL สำรองซึ่งการเชื่อมโยงการเข้าสู่ระบบอ้างถึง.',
        'Defines an alternate URL, where the logout link refers to.' => 'กำหนด URL สำรองซึ่งการเชื่อมโยงการออกจากระบบอ้างถึง.',
        'Defines an alternate login URL for the customer panel..' => 'กำหนด URL เข้าสู่ระบบสำรองสำหรับแผงลูกค้า ..',
        'Defines an alternate logout URL for the customer panel.' => 'กำหนด URL ออกจากระบบสำรองสำหรับแผงลูกค้า ..',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'กำหนดลิงค์ภายนอกไปยังฐานข้อมูลของลูกค้า (เช่น \'http: //yourhost/customer.php CID = [% Data.CustomerID%]\' หรือ \'\')',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'กำหนดจากแอตทริบิวต์ตั๋ว เอเย่นต์สามารถเลือก
ลำดับของผลลัพธ์',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'กำหนดฟิลด์Fromจากอีเมลว่าควรมีลักษณะอย่างไร (ส่งมาจากคำตอบและตั๋วอีเมล)',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'กำหนด หากการจัดเรียงล่วงหน้าตามลำดับความสำคัญที่ควรทำในมุมมองคิว',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'กำหนด หากการจัดเรียงล่วงหน้าตามลำดับความสำคัญที่ควรทำในมุมมองการบริการ',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วปิดในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจออีเมลขาออกในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอการตีกลับตั๋วในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วเขียนในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วส่งต่อในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วข้อความฟรีในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วผสมผสานของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอโน้ตตั๋วในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอของเจ้าของตั๋วของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วที่รอการดำเนินการของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วโทรศัพท์ขาเข้าในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอตั๋วโทรศัพท์ขาออกในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอลำดีบความสำคัญตั๋วของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคในหน้าจอของผู้รับผิดชอบตั๋วในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'กำหนดค่าถ้าหากจำเป็นต้องใช้ตั๋วล็อคเพื่อเปลี่ยนลูกค้าของตั๋วเขียนในอินเตอร์เฟซของเอเย่นต์ (ทำการล็อคตั๋วถ้าหากตั๋วยังไม่ได้ล็อคและเซตให้เอเย่นต์ปัจจุบันเป็นเจ้าของอัตโนมัติ)',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'กำหนดหากเอเย่นต์ควรได้รับอนุญาตในการเข้าสู่ระบบหากพวกเขาไม่มีความลับที่ใช้ร่วมกันเก็บไว้ในการตั้งค่าของพวกเขา เพราะฉะนั้นจึงไม่ได้ใช้ตรวจสอบสองปัจจัย',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'กำหนดหากข้อความเงียบจะต้องมีการสะกดตรวจสอบในอินเตอร์เฟซเอเย่นต์',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'กำหนดหากลูกค้าควรได้รับอนุญาตในการเข้าสู่ระบบหากพวกเขาไม่มีความลับที่ใช้ร่วมกันเก็บไว้ในการตั้งค่าของพวกเขา เพราะฉะนั้นจึงไม่ได้ใช้ตรวจสอบสองปัจจัย',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'กำหนดหากโหมดเสริมควรถูกใช้ (ช่วยให้สามารถใช้ตาราง, แทนที่,ดรรชนีล่าง,ดรรชนีบน,วางจากประโยคและอื่น ๆ )',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'กำหนดหากสัญลักษณ์ที่ถูกต้องก่อนหน้านี้ควรได้รับการยอมรับสำหรับการตรวจสอบ นี่คือความปลอดภัยที่น้อยลงเล็กน้อย แต่ให้เวลาแก่ผู้ใช้มากกว่า 30 วินาทีขึ้นในการป้อนรหัสผ่านเพียงครั้งเดียว',
        'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            'กำหนดถ้าค่าสำหรับฟิลเตอร์ควรจะดึงมาจากตั๋วที่มีอยู่ทั้งหมด ถ้าตั้งค่าเป็น "ใช่" เฉพาะค่าที่ใช้จริงในการออกตั๋วใด ๆ จะสามารถใช้ได้สำหรับการกรอง โปรดทราบ: รายการของลูกค้าจะถูกดึงมาอย่างนี้',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'กำหนดหากการเวลามีผลบังคับใช้ในอินเตอร์เฟสตัวแทน หากเปิดใช้งาน โน้ตจะต้องถูกป้อนสำหรับการกระทำตั๋วทั้งหมด (ไม่ว่าจะเป็นในกรณีที่โน้ตถูกกำหนดค่าเป็นใช้งานหรือมีผลบังคับใช้แต่เดิม
สำหรับหน้าจอการกระทำที่ตั๋วของแต่ละบุคคล)',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'กำหนด หากการนับเวลาจะต้องตั้งค่าไปยังตั๋วทั้งหมดในการดำเนินการเป็นกลุ่ม',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'กำหนดแม่แบบข้อความนอกสำนักงาน สองสตริงพารามิเตอร์ (% s) ที่สามารถใช้ได้: วันที่สิ้นสุดและจำนวนวันที่เหลือ',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'กำหนดคิวที่ตั๋วถูกนำมาใช้สำหรับแสดงเป็นกิจกรรมในปฏิทิน',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'กำหนด IP นิพจน์ทั่วไปที่สำหรับการเข้าถึงพื้นที่เก็บข้อมูลท้องถิ่น คุณจำเป็นต้องเปิดใช้งานนี้เพื่อเข้าถึงพื้นที่เก็บข้อมูลท้องถิ่นของคุณและ  package::RepositoryList จำเป็นต้องใช้ในพื้นที่ห่างไกล',
        'Defines the URL CSS path.' => 'กำหนดเส้นทาง URL CSS',
        'Defines the URL base path of icons, CSS and Java Script.' => 'กำหนดฐานเส้นทาง URL ของไอคอน CSS และ Java Script',
        'Defines the URL image path of icons for navigation.' => 'กำหนดภาพเส้นทาง URL ของไอคอนสำหรับการนำทาง',
        'Defines the URL java script path.' => 'กำหนดเส้นทาง URL java script',
        'Defines the URL rich text editor path.' => 'กำหนดเส้นทางแก้ไขข้อความของ URL ',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'กำหนดที่อยู่ของเซิร์ฟเวอร์ DNS ในกรณีที่จำเป็น
สำหรับ "CheckMXRecord" ',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'กำหนดคีย์การตั้งค่าเอเย่นต์ซึ่งคีย์ลับที่ใช้ร่วมกันถูกเก็บไว้',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'กำหนดข้อความในส่วนเนื้อความสำหรับการแจ้งเตือนอีเมลที่ส่งให้กับเอเย่นต์เกี่ยวกับรหัสผ่านใหม่ (หลังจากที่ใช้การเชื่อมโยงนี้รหัสผ่านใหม่จะถูกส่งไป)',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'กำหนดข้อความในส่วนเนื้อความสำหรับการแจ้งเตือนอีเมลที่ส่งให้กับเอเย่นต์พร้อมกับสัญลักษณ์เกี่ยวกับรหัสผ่านใหม่ที่ถูกร้องขอ(หลังจากที่ใช้การเชื่อมโยงนี้รหัสผ่านใหม่จะถูกส่งไป)',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'กำหนดข้อความในส่วนเนื้อความสำหรับการแจ้งเตือนอีเมลที่ส่งให้กับลูกค้าเกี่ยวกับการบัญชีใหม่',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'กำหนดข้อความในส่วนเนื้อความสำหรับการแจ้งเตือนอีเมลที่ส่งให้กับลูกค้าเกี่ยวกับรหัสผ่านใหม่ (หลังจากที่ใช้การเชื่อมโยงนี้รหัสผ่านใหม่จะถูกส่งไป)',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'กำหนดข้อความในส่วนเนื้อความสำหรับการแจ้งเตือนอีเมลที่ส่งให้กับลูกค้าพร้อมกับสัญลักษณ์เกี่ยวกับรหัสผ่านใหม่ที่ถูกร้องขอ(หลังจากที่ใช้การเชื่อมโยงนี้รหัสผ่านใหม่จะถูกส่งไป)',
        'Defines the body text for rejected emails.' => 'กำหนดข้อความในส่วนเนื้อความสำหรับอีเมลที่ถูกปฏิเสธ',
        'Defines the calendar width in percent. Default is 95%.' => 'กำหนดความกว้างปฏิทินเป็นเปอร์เซ็นต์ เริ่มต้นคือ 95%',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            'กำหนดตัวระบุโหนดคลัสเตอร์ที่จะใช้ในการกำหนดค่าคลัสเตอร์เท่านั้นซึ่งมีระบบส่วนหน้าOTRS มากกว่าหนึ่ง หมายเหตุ: เฉพาะค่า 1-99ที่ได้รับอนุญาต',
        'Defines the column to store the keys for the preferences table.' =>
            'กำหนดคอลัมน์เพื่อจัดเก็บกุญแจสำหรับตารางการตั้งค่า',
        'Defines the config options for the autocompletion feature.' => 'กำหนดตัวเลือกการตั้งค่าสำหรับฟีเจอร์autocompletion',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'กำหนดค่าพารามิเตอร์ของการตั้งค่าของรายการนี้จะแสดงในมุมมองการตั้งค่า',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'กำหนดค่าพารามิเตอร์ของการตั้งค่าของรายการนี้จะแสดงในมุมมองการตั้งค่า การดูแลเพื่อรักษาพจนานุกรมที่ติดตั้งในระบบในส่วนของข้อมูล',
        'Defines the connections for http/ftp, via a proxy.' => 'กำหนดการเชื่อมต่อสำหรับ http/ftp ผ่านพร็อกซี่',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'กำหนดคีย์การตั้งค่าลูกค้าซึ่งคีย์ลับที่ใช้ร่วมกันถูกเก็บไว้',
        'Defines the date input format used in forms (option or input fields).' =>
            'กำหนดรูปแบบการป้อนวันที่ ที่ใช้ในแบบฟอร์ม (ตัวเลือกหรือช่องใส่)',
        'Defines the default CSS used in rich text editors.' => 'กำหนด CSS เริ่มต้นที่ใช้ในการแก้ไขข้อความ',
        'Defines the default auto response type of the article for this operation.' =>
            'กำหนดประเภทการตอบสนองอัตโนมัติเริ่มต้นของบทความนี้สำหรับการดำเนินงาน',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'กำหนดเนื้อเรื่องเริ่มต้นของโน้ตในหน้าจอตั๋วข้อความฟรีในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            'กำหนดธีม front-end เริ่มต้น (HTML)ที่จะใช้โดยตัวแทนและลูกค้า ถ้าคุณชอบคุณสามารถเพิ่มธีมของคุณเอง โปรดดูคู่มือการดูแลระบบที่ตั้งอยู่ที่ http://otrs.github.io/doc/',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'กำหนดภาษา front-end เริ่มต้น ทุกค่าที่เป็นไปจะถูกกำหนดโดยไฟล์ภาษาที่มีอยู่ในระบบ (กรุณาดูการตั้งค่าถัดไป)',
        'Defines the default history type in the customer interface.' => 'กำหนดประเภทเริ่มต้นของประวัติในอินเตอร์เฟสลูกค้า',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'กำหนดจำนวนสูงสุดเริ่มต้นของคุณลักษณะของแกน X สำหรับสเกลเวลา',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'กำหนดจำนวนสูงสุดเริ่มต้นของสถิติต่อหนึ่งหน้าบนหน้าจอภาพรวม',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'กำหนดค่าเริ่มต้นของสถานะครั้งต่อไปสำหรับตั๋วหลังจากที่การติดตามลูกค้าในอินเตอร์เฟสลูกค้า',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วปิดในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วที่เป็นกลุ่มในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วข้อความฟรีในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอโน้ตตั๋วในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอเจ้าของตั๋วในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วที่รอดำเนินการในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอลำดับความสำคัญของตั๋วในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอผู้ดูแลตั๋วในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอการตีกลับตั๋วในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วส่งต่อในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากข้อความได้ถูกส่งในหน้าจออีเมลขาออกในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหากมันคือ
เงียบ / ตอบ ในหน้าจอตั๋วการเขียนในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'กำหนดเนื้อเรื่องเริ่มต้นของโน้ตสำหรับตั๋วโทรศัพท์ในหน้าจอตั๋วโทรศัพท์ขาเข้าในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'กำหนดเนื้อเรื่องเริ่มต้นของโน้ตสำหรับตั๋วโทรศัพท์ในหน้าจอตั๋วโทรศัพท์ขาออกในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วการติดตามลูกค้าในหน้าจอตั๋วซูมในอินเตอร์เฟซของลูกค้า',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วลูกค้าใหม่ในอินเตอร์เฟซของลูกค้า',
        'Defines the default priority of new tickets.' => 'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วใหม่',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'กำหนดคิวเริ่มต้นสำหรับของตั๋วลูกค้าใหม่ในอินเตอร์เฟซของลูกค้า',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'กำหนดการเลือกเริ่มต้นที่เมนูดรอปดาวน์สำหรับออบเจคแบบไดนามิก  (Form: Common Specification).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'กำหนดการเลือกเริ่มต้นที่เมนูดรอปดาวน์สำหรับการอนุญาต  (Form: Common Specification).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'กำหนดการเลือกเริ่มต้นที่เมนูดรอปดาวน์สำหรับรูปแบบสถิติ  (Form: Common Specification) กรุณาใส่รูปแบบคีย์ (see Stats::Format)',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'กำหนดประเภทผู้ส่งเริ่มต้นสำหรับตั๋วโทรศัพท์ในหน้าจอตั๋วโทรศัพท์ขาเข้าของอินเตอร์เฟซเอเย่นต์',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'กำหนดประเภทผู้ส่งเริ่มต้นสำหรับตั๋วโทรศัพท์ในหน้าจอตั๋วโทรศัพท์ขาออกของอินเตอร์เฟซเอเย่นต์',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'กำหนดประเภทผู้ส่งเริ่มต้นสำหรับตั๋วโทรศัพท์ในหน้าจอการซูมตั๋วเข้าของอินเตอร์เฟซลูกค้า',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'กำหนดแอตทริบิวต์การค้นหาตั๋วเริ่มต้นแสดงให้เห็นหน้าจอการค้นหาตั๋ว (AllTickets/ArchivedTickets/NotArchivedTickets).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'กำหนดค่าเริ่มต้นแอตทริบิวต์การค้นหาตั๋วที่แสดงสำหรับหน้าจอการค้นหาตั๋ว',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'กำหนดค่าเริ่มต้นของแอตทริบิวต์การค้นหาตั๋วที่ถูกแสดงสำหรับหน้าจอการค้นหาตั๋ว ตัวอย่าง: "คีย์" ต้องมีชื่อของฟิลด์แบบไดนามิกในกรณีนี้คือ \'X\'  "เนื้อหา" ต้องมีค่าของฟิลด์ไดนามิกซึ่งขึ้นอยู่กับประเภทของฟิลด์ไดนามิก ข้อความ: คือ \'ข้อความ\'  เมนูแบบเลื่อนลง: \'1\',  วันที่ / เวลา: Search_DynamicField_XTimeSlotStartYear = 1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'กำหนดเกณฑ์การจัดเรียงเริ่มต้นสำหรับคิวทั้งหมดที่แสดงในมุมมองคิว',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'กำหนดเกณฑ์การจัดเรียงเริ่มต้นสำหรับการบริการทั้งหมดที่แสดงในมุมมองการบริการ',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'กำหนดเกณฑ์การจัดเรียงเริ่มต้นสำหรับคิวทั้งหมดที่แสดงในมุมมองคิวหลังจากการจัดเรียงลำดับความสำคัญ',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'กำหนดเกณฑ์การจัดเรียงเริ่มต้นสำหรับการบริการทั้งหมดที่แสดงในมุมมองการบริการหลังจากการจัดเรียงลำดับความสำคัญ',
        'Defines the default spell checker dictionary.' => 'กำหนดค่าเริ่มต้นของตรวจสอบการการสะกดคำในพจนานุกรม',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'กำหนดสถานะเริ่มต้นของตั๋วลูกค้าใหม่ในอินเตอร์เฟสลูกค้า',
        'Defines the default state of new tickets.' => 'กำหนดสถานะเริ่มต้นของตั๋วใหม่',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'กำหนดหัวข้อเริ่มต้นสำหรับตั๋วโทรศัพท์ในหน้าจอตั๋วโทรศัพท์ขาเข้าของอินเตอร์เฟซเอเย่นต์',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'กำหนดหัวข้อเริ่มต้นสำหรับตั๋วโทรศัพท์ในหน้าจอตั๋วโทรศัพท์ขาออกของอินเตอร์เฟซเอเย่นต์',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'กำหนดหัวข้อเริ่มต้นของโน้ตในหน้าจอตั๋วข้อความฟรีในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'กำหนดค่าเริ่มต้นของตัวเลขหน่วยวินาที (จากเวลาปัจจุบัน) เพื่อกำหนดงานที่ล้มเหลวของอินเตอร์เฟซทั่วไปใหม่',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'กำหนดคแอตทริบิวต์เริ่มต้นของตั๋วสำหรับการเรียงลำดับตั๋วในการค้นหาตั๋วในอินเตอร์เฟซลูกค้า',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'กำหนดคแอตทริบิวต์เริ่มต้นของตั๋วสำหรับการเรียงลำดับตั๋วในมุมมองการขยายในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'กำหนดคแอตทริบิวต์เริ่มต้นของตั๋วสำหรับการเรียงลำดับตั๋วในมุมมองตั๋วที่ถูกในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'กำหนดคแอตทริบิวต์เริ่มต้นของตั๋วสำหรับการเรียงลำดับตั๋วในมุมมองผู้รับผิดชอบในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'กำหนดคแอตทริบิวต์เริ่มต้นของตั๋วสำหรับการเรียงลำดับตั๋วในมุมมองสถานภาพในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'กำหนดคแอตทริบิวต์เริ่มต้นของตั๋วสำหรับการเรียงลำดับตั๋วในมุมมองการดูในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'กำหนดคแอตทริบิวต์เริ่มต้นของตั๋วสำหรับการเรียงลำดับตั๋วของผลลัพธ์ของการค้นหาตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'กำหนดคแอตทริบิวต์เริ่มต้นของตั๋วสำหรับการเรียงลำดับตั๋วของผลลัพธ์ของการค้นหาตั๋วของการดำเนินการนี้',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'กำหนดการแจ้งเตือนการตีกลับตั๋วเริ่มต้นสำหรับลูกค้า / ผู้ส่งในหน้าจอการตีกลับตั๋วของอินเตอร์เฟซตัวแทน',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วโทรศัพท์ขาเข้าของอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'กำหนดค่าเริ่มต้นของสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วโทรศัพท์ขาออกของอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'กำหนดการจัดเรียงเริ่มต้นของตั๋ว (หลังจากการจัดเรียงลำดับความสำคัญ)ในมุมมองการขยายของอินเตอร์เฟซเอเย่นต์ ขึ้น: เก่าที่สุดด้านบน ลง: ล่าสุดด้านบน',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'กำหนดการจัดเรียงเริ่มต้นของตั๋ว (หลังจากการจัดเรียงลำดับความสำคัญ)ในมุมมองของสถานภาพของอินเตอร์เฟซเอเย่นต์ ขึ้น: เก่าที่สุดด้านบน ลง: ล่าสุดด้านบน',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'กำหนดการจัดเรียงเริ่มต้นของตั๋วในมุมมองของผู้รับผิดชอบของอินเตอร์เฟซเอเย่นต์ ขึ้น: เก่าที่สุดด้านบน ลง: ล่าสุดด้านบน',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'กำหนดการจัดเรียงเริ่มต้นของตั๋วในมุมมองของตั๋วที่ถูกล็อคของอินเตอร์เฟซเอเย่นต์ ขึ้น: เก่าที่สุดด้านบน ลง: ล่าสุดด้านบน',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'กำหนดการจัดเรียงเริ่มต้นของตั๋วในผลลัพธ์ของการค้นหาตั๋วของอินเตอร์เฟซเอเย่นต์ ขึ้น: เก่าที่สุดด้านบน ลง: ล่าสุดด้านบน',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'กำหนดการจัดเรียงเริ่มต้นของตั๋วในผลลัพธ์ของการค้นหาตั๋วของการดำเนินการนี้ ขึ้น: เก่าที่สุดด้านบน ลง: ล่าสุดด้านบน',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'กำหนดการจัดเรียงเริ่มต้นของตั๋วในมุมมองการดูของอินเตอร์เฟซเอเย่นต์ ขึ้น: เก่าที่สุดด้านบน ลง: ล่าสุดด้านบน',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'กำหนดการจัดเรียงเริ่มต้นของตั๋วของผลลัพธ์ของการค้นหาในอินเตอร์เฟซลูกค้า ขึ้น: เก่าที่สุดด้านบน ลง: ล่าสุดด้านบน',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอของตั๋วปิดของอินเตอร์เฟซของเอเย่นต์',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอของตั๋วที่ทำงานเป็นกลุ่มของอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอของตั๋วข้อความฟรีของอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอของโน้ตตั๋วของอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอเจ้าของตั๋วของตั๋วซูมในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอตั๋วที่รอการดำเนินการของตั๋วซูมในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอลำดับความสำคัญของตั๋วของตั๋วซูมในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'กำหนดลำดับความสำคัญเริ่มต้นของตั๋วในหน้าจอของผู้รับผิดชอบตั๋วของตั๋วซูมในอินเตอร์เฟซเอเย่นต์',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'กำหนดประเภทเริ่มต้นของตั๋วสำหรับตั๋วของลูกค้าใหม่ในอินเตอร์เฟสลูกค้า',
        'Defines the default ticket type.' => 'กำหนดสถานะเริ่มต้นของประเภทตั๋ว',
        'Defines the default type for article in the customer interface.' =>
            'กำหนดประเภทเริ่มต้นสำหรับบทความในอินเตอร์เฟสลูกค้า',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของข้อความส่งต่อในหน้าจอตั๋วส่งต่อของอินเตอร์เฟสเอเย่นต์',
        'Defines the default type of the article for this operation.' => 'กำหนดประเภทเริ่มต้นของข้อความส่งต่อสำหรับการดำเนินการนี้',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของข้อความในหน้าจออีเมลขาออกของอินเตอร์เฟสเอเย่นต์',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอของตั๋วปิดของอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอของตั๋วที่ทำงานเป็นกลุ่มของอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอตั๋วข้อความฟรีของอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอโน้ตตั๋วอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอเจ้าของตั๋วของตั๋วซูมในอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอตั๋วที่รอการดำเนินการของตั๋วซูมในอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอตั๋วโทรศัพท์ขาเข้าของอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอตั๋วโทรศัพท์ขาออกของอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอลำดับความสำคัญตั๋วของตั๋วซูมในอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอของผู้รับผิดชอบตั๋วของอินเตอร์เฟซเอเย่นต์',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'กำหนดประเภทเริ่มต้นของโน้ตในหน้าจอการซูมตั๋วของอินเตอร์เฟซลูกค้า',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'กำหนดโมดูลส่วนหน้าที่ใช้เริ่มต้นหากรพารามิเตอร์การดำเนินการไม่ถูกให้ใน url บนอินเตอร์เฟซเอเย่นต์',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'กำหนดโมดูลส่วนหน้าที่ใช้เริ่มต้นหากรพารามิเตอร์การดำเนินการไม่ถูกให้ใน url บนอินเตอร์เฟซลูกค้า',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'กำหนดค่าเริ่มต้นสำหรับพารามิเตอร์การดำเนินการในหน้าสาธารณะ พารามิเตอร์การดำเนินการถูกนำมาใช้ในสคริปต์ของระบบ',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'กำหนดประเภทผู้ส่งเริ่มต้นที่สามารถดูได้ของตั๋ว (เริ่มต้น: ลูกค้า)',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'กำหนดฟิลด์แบบไดนามิกที่ถูกนำมาใช้สำหรับแสดงเป็นกิจกรรมในปฏิทิน',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'กำหนดเส้นทางย้อนกลับเพื่อเปิดเลขฐานสองของ fetchmail หมายเหตุ: ชื่อของเลขฐานสองจะต้องเป็น \'fetchmail\' ถ้ามันแตกต่างกันโปรดใช้การเชื่อมโยงสัญลักษณ์',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'กำหนดตัวกรองเพื่อประมวลผลข้อความในบทความเพื่อที่จะเน้น URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'กำหนดรูปแบบของการตอบสนองในหน้าจอการเขียนตั๋วของอินเตอร์เฟซเอเย่นต์ ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %]เป็นชื่อจริงของFrom).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'กำหนดชื่อโดเมนที่มีคุณสมบัติครบถ้วนของระบบ การตั้งค่านี้จะถูกใช้เป็นตัวแปร OTRS_CONFIG_FQDN ซึ่งพบได้ในรูปแบบของการส่งข้อความทั้งหมดที่ใช้โดยแอพลิเคชั่นเพื่อใช้ในการสร้างการเชื่อมโยงไปตั๋วภายในระบบของคุณ',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'กำหนดกลุ่มสำหรับลูกค้าผู้ใช้ทุกคน (ถ้า CustomerGroupSupport ถูกเปิดใช้งานและคุณไม่ต้องการที่จะจัดการผู้ใช้ทุกคนสำหรับกลุ่มเหล่านี้)',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'กำหนดความสูงสำหรับคอมโพเนนต์แก้ไขข้อความสำหรับหน้าจอนี้ ใส่หมายเลข (พิกเซล) หรือค่าร้อยละ (เทียบ)',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'กำหนดความสูงสำหรับคอมโพเนนต์แก้ไขข้อความ ใส่หมายเลข (พิกเซล) หรือค่าร้อยละ (เทียบ)',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วปิด ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วอีเมล ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วโทรศัพท์ ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วข้อความฟรั ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋ว',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วโน้ต ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอของเจ้าของตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วที่รอการดำเนิการ ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วโทรศัพท์ขาเข้า ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอตั๋วโทรศัพท์ขาออก ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอของลำดับความสำคัญตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำหน้าจอของผู้รับผิดชอบตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำการซูมตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซลูกค้า',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'กำหนดประวัติการแสดงความเห็นสำหรับการกระทำนี้ ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอตั๋วปิด ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอตั๋วอีเมล ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอตั๋วโทรศัพท์ ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอตั๋วข้อความฟรี ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอโน้ตตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอของเจ้าของตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอตั๋วที่รอการดำเนินการซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอตั๋วโทรศัพท์ขาเข้า ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอตั๋วโทรศัพท์ขาออก ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอของลำดับความสำคัญของตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำหน้าจอของผู้รับผิดชอบตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'กำหนดประเภทของประวัติสำหรับการซูมตั๋ว ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซลูกค้า',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'กำหนดประเภทของประวัติสำหรับการกระทำนี้ ซึ่งทำให้เกิดความคุ้นเคยในประวัติของตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'กำหนดเวลาและวันของปฏิทินที่ระบุในการนับเวลาการทำงาน',
        'Defines the hours and week days to count the working time.' => 'กำหนดเวลาและวันเพื่อนับเวลาการทำงาน',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'กำหนดกุญแจสำคัญที่จะได้รับการตรวจสอบด้วยโมดูล Kernel::Modules::AgentInfo  หากผู้ใช้กุญแจสำคัญในการตั้งค่านี้เป็นจริง ข้อความจะได้รับการยอมรับโดยระบบ',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'กำหนดกุญแจสำคัญที่จะได้รับการตรวจสอบด้วย CustomerAccept หากผู้ใช้กุญแจสำคัญในการตั้งค่านี้เป็นจริง ข้อความจะได้รับการยอมรับโดยระบบ',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'กำหนดประเภทลิงค์ \'Normal\' ถ้าชื่อแหล่งที่มาและชื่อเป้าหมายมีค่าเดียวกัน ลิงค์คือไม่มีทิศทาง แต่ถ้าหากมีค่าต่างกัน ลิงค์ที่เกิดคือการเชื่อมโยงทิศทาง',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'กำหนดประเภทลิงค์ \'ParentChild\' ถ้าชื่อแหล่งที่มาและชื่อเป้าหมายมีค่าเดียวกัน ลิงค์คือไม่มีทิศทาง แต่ถ้าหากมีค่าต่างกัน ลิงค์ที่เกิดคือการเชื่อมโยงทิศทาง',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'กำหนดกลุ่มประเภทการเชื่อมโยง ประเภทของการเชื่อมโยงของกลุ่มเดียวกันจะยกเลิกอีกกลุ่มหนึ่ง ตัวอย่าง: หากตั๋ว A  ถูกเชื่อมโยงต่อหนึ่งการเชื่อมโยงแบบ \'Normal\' ด้วยตั๋ว B  แล้วตั๋วเหล่านี้จะไม่สามารถเป็นการเชื่อมโยงเพิ่มเติม ด้วยการเชื่อมโยงของความสัมพันธ์ \'ParentChild\'',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'กำหนดรายชื่อที่เก็บออนไลน์ การติดตั้งอื่นๆสามารถใช้เป็นพื้นที่เก็บข้อมูล ตัวอย่างเช่น : Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'กำหนดรายการของการกระทำที่เป็นไปได้ถัดบนหน้าจอข้อผิดพลาด, เส้นทางแบบเต็มจำเป็นต้องมีจากนั้นก็อาจเป็นไปได้ที่จะเพิ่มการเชื่อมโยงภายนอกหากมีความจำเป็น',
        'Defines the list of types for templates.' => 'กำหนดรายการประเภทสำหรับแม่แบบ',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'กำหนดตำแหน่งที่จะได้รับรายการของพื้นที่เก็บข้อมูลออนไลน์สำหรับแพคเกจเพิ่มเติม ผลลัพท์แรกจะถูกนำมาใช้',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'กำหนดโมดูลบันทึกสำหรับระบบ  "แฟ้ม" คือเขียนข้อความทั้งหมดใน logfile ที่กำหนด "Syslog" จะใช้ syslog  daemon ของระบบ เช่น syslogd',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'กำหนดขนาดสูงสุด (ไบต์) สำหรับไฟล์ที่อัปโหลดผ่านทางเบราว์เซอร์ คำเตือน: การตั้งค่าตัวเลือกนี้ไปเป็นค่าซึ่งอยู่ในระดับต่ำเกินไปอาจก่อให้เกิดมาสก์จำนวนมากในตัวอย่างของOTRS ของคุณเพื่อหยุดการทำงาน (อาจจะเป็นมาสก์ใด ๆที่จะนำข้อมูลจากผู้ใช้)',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'กำหนดเวลาสูงสุดที่ถูกต้อง (เป็นวินาที) สำหรับไอดีเซสชั่น',
        'Defines the maximum number of affected tickets per job.' => 'กำหนดจำนวนสูงสุดของตั๋วที่ได้รับผลกระทบต่อหนึ่งงาน',
        'Defines the maximum number of pages per PDF file.' => 'กำหนดจำนวนสูงสุดของหน้าต่อหนึ่งไฟล์ PDF',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'กำหนดจำนวนสูงสุดของสายที่ยกมาที่จะถูกเพิ่มไปยังการตอบสนอง',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'กำหนดจำนวนสูงสุดของงานที่จะดำเนินการในเวลาเดียวกัน',
        'Defines the maximum size (in MB) of the log file.' => 'กำหนดขนาดสูงสุด (เมกะไบต์) ของไฟล์ล็อก',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'กำหนดขนาดสูงสุดเป็นกิโลไบต์ของการตอบสนอง GenericInterface ที่ได้รับการบันทึกลงในตาราง gi_debugger_entry_content',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'กำหนดโมดูลที่แสดงการแจ้งเตือนทั่วไปในอินเตอร์เฟซเอเย่นต์ ทั้ง "ข้อความ" - ถ้าถูกกำหนดค่า - หรือเนื้อหาของ "แฟ้ม"จะถูกแสดง',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'กำหนดโมดูลที่แสดงเอเย่นต์ที่เข้าสู่ระบบในขณะนี้ทั้งหมดในอินเตอร์เฟซเอเย่นต์',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'กำหนดโมดูลในการตรวจสอบลูกค้า',
        'Defines the module to display a notification if cloud services are disabled.' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนถ้าการบริการคลาวด์ถูกปิดใช้งาน',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนในอินเตอร์เฟซที่แตกต่างกันในโอกาสที่แตกต่างกันสำหรับ OTRS Business Solution™.',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนในอินเตอร์เฟซเอเย่นต์ถ้า OTRS Daemonไม่ได้ทำงานอยู่',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนในอินเตอร์เฟซเอเย่นต์ถ้าตัวเอเย่นต์เข้าสู่ระบบในขณะout-of-office ใช้งานอยู่',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนในอินเตอร์เฟซเอเย่นต์ถ้าตัวเอเย่นต์เข้าสู่ระบบในขณะที่การบำรุงรักษาระบบกำลังใช้งานอยู่',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนในอินเตอร์เฟซเอเย่นต์ถ้าระบบถูกใช้โดยผู้ดูแลระบบ (ปกติคุณไม่ควรทำงานเป็นผู้ดูแลระบบ)',
        'Defines the module to generate code for periodic page reloads.' =>
            'กำหนดโมดูลเพื่อสร้างรหัสสำหรับโหลดหน้าเป็นระยะ ๆ',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'กำหนดโมดูลในการส่งอีเมล "Sendmail" คือการใช้ sendmail เป็นคู่ของระบบปฏิบัติการของคุณได้โดยตรง กลไกต่างๆของ "SMTP" ใช้ mailserver ที่กำหนด (ภายนอก)  "DoNotSendEmail" จะไม่ส่งอีเมลและมันจะเป็นประโยชน์สำหรับการทดสอบระบบ',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'กำหนดโมดูลที่ใช้ในการจัดเก็บข้อมูลเซสชั่น ด้วย "DB" เซิร์ฟเวอร์ส่วนหน้าสามารถแบ่งตัวจากเซิร์ฟเวอร์ฐานข้อมูล  "FS" เร็วกว่า',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'กำหนดชื่อของแอพลิเคชั่นที่จะแสดงในเว็บอินเตอร์เฟส, แท็บและชื่อแถบของเว็บเบราเซอร์',
        'Defines the name of the column to store the data in the preferences table.' =>
            'กำหนดชื่อของคอลัมน์ในการจัดเก็บข้อมูลในตารางการตั้งค่า',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'กำหนดชื่อของคอลัมน์ในการเก็บตัวระบุผู้ใช้ในตารางการตั้งค่า',
        'Defines the name of the indicated calendar.' => 'กำหนดชื่อของปฏิทินที่ระบุ',
        'Defines the name of the key for customer sessions.' => 'กำหนดชื่อของคีย์สำหรับเซสชั่นของลูกค้า',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'กำหนดชื่อของคีย์เซสชั่น เช่น Session, SessionID or OTRS',
        'Defines the name of the table where the user preferences are stored.' =>
            'กำหนดชื่อของตารางที่การตั้งค่าของลูกค้าถูกจัดเก็บไว้',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปที่เป็นไปได้หลังจาก เขียน/ตอบ ตั๋วในหน้าจอตั๋วเขียนในอินเตอร์เฟซเอเย่นต์',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปที่เป็นไปได้หลังจากส่งต่อตั๋วในหน้าจอตั๋วที่ส่งต่อในอินเตอร์เฟซเอเย่นต์',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปที่เป็นไปได้หลังจากส่งข้อความในหน้าจออีเมลขาออกในอินเตอร์เฟซเอเย่นต์',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'กำหนดสถานภาพถัดไปที่เป็นไปได้สำหรับตั๋วลูกค้าในอินเตอร์เฟซลูกค้า',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วปิดในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วที่เป็นกลุ่มในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วข้อความฟรีในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอโน้ตตั๋วในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอเจ้าของตั๋วของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอตั๋วที่รอดำเนินการของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอลำดับความสำคัญของตั๋วซูมในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอผู้ดูแลตั๋วในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากเพิ่มโน้ตในหน้าจอการตีกลับตั๋วในอินเตอร์เฟซของเอเย่นต์',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'กำหนดสถานภาพถัดไปของตั๋วหลังจากถูกย้ายไปยังคิวอื่นในหน้าจอตั๋วที่ถูกย้ายในอินเตอร์เฟซของเอเย่นต์',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'กำหนดจำนวนตัวอักษรต่อบรรทัดที่ใช้ในกรณีที่ทดแทนการแสดงตัวอย่างบทความ HTML ใน TemplateGenerator สำหรับ EventNotifications',
        'Defines the number of days to keep the daemon log files.' => 'กำหนดจำนวนวันที่จะเก็บไฟล์ daemon log',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'กำหนดจำนวนส่วนหัวของฟิลด์ในโมดูลส่วนหน้าสำหรับการเพิ่มและการอัพเดตตัวกรองโพสต์มาสเตอร์ มันสามารถเป็นได้ถึง 99ฟิลด์',
        'Defines the parameters for the customer preferences table.' => 'กำหนดพารามิเตอร์สำหรับตารางการตั้งค่าลูกค้า',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'พารามิเตอร์สำหรับแดชบอร์ดเบื้องหลัง "cmd" ถูกใช้เพื่อระบุคำสั่งกับพารามิเตอร์  "กลุ่ม" จะถูกนำมาใช้เพื่อจำกัดการเข้าถึงปลั๊กอิน (เช่นกลุ่ม: ผู้ดูแลระบบ; กลุ่ม 1; กลุ่ม2;) "เริ่มต้น" ระบุว่าถ้าปลั๊กอินถูกเปิดใช้งานโดยค่าเริ่มต้นหรือหากผู้ใช้ต้องการเพื่อเปิดใช้งานได้ด้วยตนเอง "CacheTTL" หมายถึงระยะเวลาที่หมดอายุของแคชในนาทีสำหรับปลั๊กอิน',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'พารามิเตอร์สำหรับแดชบอร์ดเบื้องหลัง  "กลุ่ม" จะถูกนำมาใช้เพื่อจำกัดการเข้าถึงปลั๊กอิน (เช่นกลุ่ม: ผู้ดูแลระบบ; กลุ่ม 1; กลุ่ม2;) "เริ่มต้น" ระบุว่าถ้าปลั๊กอินถูกเปิดใช้งานโดยค่าเริ่มต้นหรือหากผู้ใช้ต้องการเพื่อเปิดใช้งานได้ด้วยตนเอง "CacheTTL" หมายถึงระยะเวลาที่หมดอายุของแคชในนาทีสำหรับปลั๊กอิน',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'พารามิเตอร์สำหรับแดชบอร์ดเบื้องหลัง  "กลุ่ม" จะถูกนำมาใช้เพื่อจำกัดการเข้าถึงปลั๊กอิน (เช่นกลุ่ม: ผู้ดูแลระบบ; กลุ่ม 1; กลุ่ม2;) "เริ่มต้น" ระบุว่าถ้าปลั๊กอินถูกเปิดใช้งานโดยค่าเริ่มต้นหรือหากผู้ใช้ต้องการเพื่อเปิดใช้งานได้ด้วยตนเอง "CacheTTL" หมายถึงระยะเวลาที่หมดอายุของแคชในนาทีสำหรับปลั๊กอิน',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'พารามิเตอร์สำหรับแดชบอร์ดเบื้องหลัง "จำกัด" คือกำหนดจำนวนของรายการที่แสดงโดยค่าเริ่มต้น   "กลุ่ม" จะถูกนำมาใช้เพื่อจำกัดการเข้าถึงปลั๊กอิน (เช่นกลุ่ม: ผู้ดูแลระบบ; กลุ่ม 1; กลุ่ม2;) "เริ่มต้น" ระบุว่าถ้าปลั๊กอินถูกเปิดใช้งานโดยค่าเริ่มต้นหรือหากผู้ใช้ต้องการเพื่อเปิดใช้งานได้ด้วยตนเอง "CacheTTL" หมายถึงระยะเวลาที่หมดอายุของแคชในนาทีสำหรับปลั๊กอิน',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'กำหนดพารามิเตอร์สำหรับแดชบอร์ดเบื้องหลัง "จำกัด" คือกำหนดจำนวนของรายการที่แสดงโดยค่าเริ่มต้น "กลุ่ม" จะถูกนำมาใช้เพื่อจำกัดการเข้าถึงปลั๊กอิน (เช่นกลุ่ม: ผู้ดูแลระบบ; กลุ่ม 1; กลุ่ม2;) "เริ่มต้น" ระบุว่าถ้าปลั๊กอินถูกเปิดใช้งานโดยค่าเริ่มต้นหรือหากผู้ใช้ต้องการเพื่อเปิดใช้งานได้ด้วยตนเอง "CacheTTL" หมายถึงระยะเวลาที่หมดอายุของแคชในนาทีสำหรับปลั๊กอิน',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'กำหนดรหัสผ่านในการเข้าถึงการจัดการ SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'กำหนดเส้นทางและไฟล์ TTF ในการจัดการกับตัวอักษรตัวหนาตัวเอียงพิมพ์ดีดในเอกสาร PDF',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'กำหนดเส้นทางและไฟล์ TTF ในการจัดการกับตัวอักษรตัวหนาตัวเอียงสัดส่วนในเอกสาร PDF',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'กำหนดเส้นทางและไฟล์ TTF ในการจัดการตัวอักษรพิมพ์ดีดตัวหนาในเอกสาร PDF',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'กำหนดเส้นทางและไฟล์ TTF ในการจัดการกับสัดส่วนตัวอักษรตัวหนาในเอกสาร PDF',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'กำหนดเส้นทางและไฟล์ TTF ในการจัดการแบบอักษรตัวเอียงพิมพ์ดีดในเอกสาร PDF',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'กำหนดเส้นทางและไฟล์ TTF ในการจัดการกับสัดส่วนตัวอักษรตัวเอียงในเอกสาร PDF',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'กำหนดเส้นทางและไฟล์ TTF ในการจัดการตัวอักษรพิมพ์ดีดในเอกสาร PDF',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'กำหนดเส้นทางและไฟล์ TTF ในการจัดการตัวอักษรสัดส่วนในเอกสาร PDF',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'กำหนดเส้นทางของแฟ้มข้อมูลที่ถูกแสดงที่เก็บอยู่ภายใต้ Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.',
        'Defines the path to PGP binary.' => 'กำหนดเส้นทางไปยังเลขฐานสอง PGP',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'กำหนดเส้นทางที่จะเปิดเลขฐานสองของ SSL มันอาจต้องใช้ HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the postmaster default queue.' => 'กำหนดคิวโพสต์มาสเตอร์เริ่มต้น',
        'Defines the priority in which the information is logged and presented.' =>
            'กำหนดลำดับความสำคัญซึ่งข้อมูลจะถูกบันทึกไว้และถูกนำเสนอ',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'กำหนดเป้าหมายผู้รับตั๋วโทรศัพท์และผู้ส่งตั๋วอีเมล("คิว" แสดงคิวทั้งหมด "ที่อยู่ระบบ"แสดงที่อยู่ระบบทั้งหมด) ในอินเตอร์เฟซเอเย่นต์',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'กำหนดเป้าหมายของตั๋ว ("คิว" แสดงคิวทั้งหมด "ที่อยู่ระบบ"แสดงคิวที่ได้รับมอบหมายให้อยู่ในระบบ) ในอินเตอร์เฟซลูกค้า',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'กำหนดการอนุญาตที่จำเป็นเพื่อแสดงตั๋วในมุมมองของการขยายของอินเตอร์เฟซตัวแทน',
        'Defines the search limit for the stats.' => 'กำหนดขีดจำกัดสำหรับสถิติ',
        'Defines the sender for rejected emails.' => 'กำหนดผู้ส่งสำหรับอีเมลที่ถูกปฏิเสธ',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'กำหนดตัวคั่นระหว่างชื่อจริงของเอเย่นต์และที่อยู่อีเมลคิวที่กำหนด',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'กำหนดสิทธิ์มาตรฐานสามารถใช้ได้สำหรับลูกค้าภายในแอพพลิเคชันหากจำเป็นต้องใช้สิทธิ์มากขึ้นคุณสามารถป้อนข้อมูลที่นี่ การกำหนดสิทธิ์จะต้องเป็นรหัสที่ยากที่มีประสิทธิภาพ โปรดตรวจสอบเมื่อเพิ่มสิทธิ์ที่กล่าวถึงข้างต้น, "RW" ยังคงเป็นรายการสุดท้ายที่จะได้รับอนุญาต ',
        'Defines the standard size of PDF pages.' => 'กำหนดขนาดมาตรฐานของหน้า PDF',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'กำหนดสถานะของตั๋วหากได้รับการติดตามและตั๋วถูกปิดแล้ว',
        'Defines the state of a ticket if it gets a follow-up.' => 'กำหนดสถานะของตั๋วหากได้รับการติดตาม',
        'Defines the state type of the reminder for pending tickets.' => 'กำหนดประเภทสถานะของการแจ้งเตือนสำหรับตั๋วที่ค้างอยู่',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'กำหนดหัวข้อสำหรับอีเมล์การแจ้งเตือนที่ส่งถึงเอเย่นต์เกี่ยวกับรหัสผ่านใหม่',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'กำหนดหัวข้อสำหรับอีเมล์การแจ้งเตือนที่ส่งถึงเอเย่นต์พร้อมกับสัญลักษณ์เกี่ยวกับรหัสผ่านใหม่ที่ถูกร้องขอ',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'กำหนดหัวข้อสำหรับอีเมล์การแจ้งเตือนที่ส่งถึงลูกค้าเกี่ยวกับบัญชีใหม่',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'กำหนดหัวข้อสำหรับอีเมล์การแจ้งเตือนที่ส่งถึงลูกค้าเกี่ยวกับรหัสผ่านใหม่',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'กำหนดหัวข้อสำหรับอีเมล์การแจ้งเตือนที่ส่งถึงลูกค้าพร้อมกับสัญลักษณ์เกี่ยวกับรหัสผ่านใหม่ที่ถูกร้องขอ',
        'Defines the subject for rejected emails.' => 'กำหนดหัวข้อสำหรับอีเมลที่ถูกปฏิเสธ',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'กำหนดที่อยู่อีเมลของผู้ดูแลระบบ มันจะถูกแสดงในหน้าจอข้อผิดพลาดของแอพพลิเคชัน',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'กำหนดตัวบ่งชี้ระบบ ทุกๆหมายเลขตั๋วและสตริงเซสชั่นของ http ที่มีไอดีนี้เพื่อให้แน่ใจว่าเฉพาะตั๋วที่อยู่ในระบบของคุณที่จะถูกประมวลผลขณะที่ติดตาม (มีประโยชน์เมื่อการติดต่อสื่อสารระหว่างสองกรณีของOTRS)',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'กำหนดแอตทริบิวต์เป้าหมายในการเชื่อมโยงไปยังฐานข้อมูลของลูกค้าภายนอก เช่น. \'AsPopup PopupType_TicketAction\'',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'กำหนดแอตทริบิวต์เป้าหมายในการเชื่อมโยงไปยังฐานข้อมูลของลูกค้าภายนอก เช่น. \'target="cdb"\'.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'กำหนดฟิลด์ที่ตั๋วที่กำลังจะถูกนำมาแสดงกิจกรรมในปฏิทิน "คีย์" จะกำหนดฟิลด์หรือแอตทริบิวต์ของตั๋วและ "เนื้อหา" จะกำหนดชื่อที่ใช้แสดง',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'กำหนดโซนเวลาของปฏิทินที่ระบุไว้ซึ่งสามารถกำหนดไปยังคิวตามที่ระบุไว้หลังจากนั้น',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => 'กำหนดโมดูลสองปัจจัยในการตรวจสอบเอเย่นต์',
        'Defines the two-factor module to authenticate customers.' => 'กำหนดโมดูลสองปัจจัยในการตรวจสอบลูกค้า',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'กำหนดประเภทของโปรโตคอลที่ใช้โดยเว็บเซิร์ฟเวอร์ที่จะให้บริการแอพลิเคชัน หากโปรโตคอล HTTPS จะถูกนำมาใช้แทน http ธรรมดาจะต้องมีการระบุไว้ที่นี่ เนื่องจากไม่มีผลต่อการตั้งค่าหรือพฤติกรรมเว็บเซิร์ฟเวอร์ก็จะไม่เปลี่ยนวิธีการในการเข้าถึงแอพลิเคชันและถ้ามันไม่ถูกต้องก็จะไม่ป้องกันคุณจากการเข้าสู่แอพลิเคชัน การตั้งค่านี้จะถูกใช้เป็นตัวแปร OTRS_CONFIG_HttpType ซึ่งพบได้ในทุกรูปแบบของข้อความที่ใช้โดยโปรแกรมเพื่อสร้างการเชื่อมโยงตั๋วภายในระบบของคุณเท่านั้น',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'กำหนดตัวอักษรที่ใช้สำหรับการอ้างในอีเมลธรรมดาในหน้าจอการเขียนตั๋วของอินเตอร์เฟซเอเย่นต์ ถ้าว่างเปล่าหรือไม่ใช้งานอีเมลต้นฉบับจะไม่ถูกการอ้างแต่ผนวกเข้ากับการตอบสนอง',
        'Defines the user identifier for the customer panel.' => 'กำหนดตัวระบุผู้ใช้สำหรับแผงลูกค้า',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'กำหนดรหัสผ่านในการเข้าถึงการจัดการ SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'กำหนดประเภทของสถานะที่ถูกต้องสำหรับตั๋ว',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'กำหนดสถานะที่ถูกต้องของตั๋วปลดล็อค เพื่อปลดล็อคตั๋วสคริปต์นี้สามารถนำมาใช้ "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout"',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'กำหนดความกว้างสำหรับส่วนประกอบของการแก้ไขข้อความสำหรับหน้าจอนี้ ป้อนจำนวน (พิกเซล) หรือค่าร้อยละ (เทียบ)',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'กำหนดความกว้างสำหรับส่วนประกอบของการแก้ไขข้อความสำหรับหน้าจอนี้ ป้อนจำนวน (พิกเซล) หรือค่าร้อยละ (เทียบ)',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'กำหนดว่าประเภทผู้ส่งบทความใดควรจะแสดงในการแสดงตัวอย่างของตั๋ว',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'กำหนดรายการที่ที่ใช้ได้สำหรับ \'การกระทำ\' ในระดับที่สามของโครงสร้าง ACL',
        'Defines which items are available in first level of the ACL structure.' =>
            'กำหนดรายการที่ที่ใช้ได้ในระดับแรกของโครงสร้าง ACL ',
        'Defines which items are available in second level of the ACL structure.' =>
            'กำหนดรายการที่ที่ใช้ได้ในระดับที่สองของโครงสร้าง ACL ',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'กำหนดสถานะควรจะตั้งค่าโดยอัตโนมัติ (เนื้อหา)หลังจากเวลาอยู่ระหว่างดำเนินการของสถานะ (Key)ได้รับ',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'กำหนดประเภทบทความที่ควรถูกขยายเมื่อเข้าสู่ภาพรวม ถ้าไม่มีการกำหนดบทความล่าสุดจะขยาย',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'กำหนดว่าตั๋วใดของประเภทสถานะของตั๋วไม่ควรจะอยู่ในรายชื่อตั๋วเชื่อมโยง',
        'Delete expired cache from core modules.' => 'ลบแคชที่หมดอายุจากโมดูลหลัก',
        'Delete expired loader cache weekly (Sunday mornings).' => 'ลบตัวโหลดแคชที่หมดอายุรายสัปดาห์ (เช้าวันอาทิตย์)',
        'Delete expired sessions.' => 'ลบเซสชันที่หมดอายุ',
        'Deleted link to ticket "%s".' => 'ลบการเชื่อมโยงไปยังตั๋ว "%s"',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'ลบเซสชั่นถ้าหากรหัสเซสชั่นที่ใช้กับที่อยู่ IP ระยะไกลไม่ถูกต้อง',
        'Deletes requested sessions if they have timed out.' => 'ลบเซสชันที่ร้องขอหากหมดเวลา',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => 'ปรับใช้และจัดการ OTRS Business Solution™.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'กำหนดถ้ารายการของคิวที่เป็นไปได้จะย้ายเข้าไปในตั๋วควรจะแสดงในรายการแบบเลื่อนหรือในหน้าต่างใหม่ในอินเตอร์เฟซเอเย่นต์ ถ้า "หน้าต่างใหม่" ถูกตั้งค่าคุณสามารถเพิ่มโน้ตไปยังตั๋ว',
        'Determines if the statistics module may generate ticket lists.' =>
            'กำหนดว่าโมดูลสถิติที่นี้อาจสร้างรายการตั๋วได้',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'กำหนดสถานภาพถัดไปที่เป็นไปได้หลังจากสร้างตั๋วอีเมลใหม่ในอินเตอร์เฟซเอเย่นต์',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'กำหนดสถานภาพถัดไปที่เป็นไปได้หลังจากสร้างตั๋วโทรศัพท์ใหม่ในอินเตอร์เฟซเอเย่นต์',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'กำหนดสถานภาพถัดไปที่เป็นไปได้สำหรับดำเนินการตั๋วในอินเตอร์เฟซเอเย่นต์',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'กำหนดหน้าจอถัดไปหลังจากตั๋วลูกค้าใหม่ในอินเตอร์เฟสลูกค้า',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'กำหนดหน้าจอถัดไปหลังจากที่หน้าจอติดตามตั๋วซูมในอินเตอร์เฟสลูกค้า',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'กำหนดหน้าจอถัดไปหลังจากที่ตั๋วจะถูกย้าย LastScreenOverviewจะกลับสู่หน้าจอภาพรวมที่ผ่านมา (เช่นผลการค้นหา queueview แดชบอร์ด) TicketZoomจะกลับไปยัง TicketZoom',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'กำหนดสถานะเป็นไปได้สำหรับตั๋วอยู่ระหว่างดำเนินการซึ่งสถานะการเปลี่ยนแปลงหลังจากที่ครบเวลาที่กำหนด',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'กำหนดเงื่อนไขที่จะแสดงเป็นผู้รับ (ไปยัง:) ตั๋วโทรศัพท์และเป็นผู้ส่ง (จาก:) ตั๋วอีเมลในอินเตอร์เฟซเอเย่นต์ คิวเป็น NewQueueSelectionType "<คิว>" จะแสดงชื่อของคิวและ SystemAddress ว่า "<Realname> << อีเมล์ >>" แสดงชื่อและอีเมล์ของผู้รับ',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'กำหนดเงื่อนไขที่จะแสดงเป็นผู้รับ (ไปยัง:) ตั๋วอีเมลในอินเตอร์เฟซลูกค้า คิวเป็น CustomerPanelSelectionType "<คิว>" จะแสดงชื่อของคิวและ SystemAddress ว่า "<Realname> << อีเมล์ >>" แสดงชื่อและอีเมล์ของผู้รับ',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'กำหนดวิธีการเชื่อมโยงวัตถุจะแสดงในแต่ละมาสก์การซูม',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'กำหนดตัวเลือกที่จะใช้งานได้ของผู้รับ (ตั๋วโทรศัพท์) และผู้ส่ง (ตั๋วอีเมล) ในอินเตอร์เฟสเอเย่นต์',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'กำหนดว่าคิวใดจะสามารถใช้งานได้สำหรับผู้รับตั๋วของอินเตอร์เฟสลูกค้า',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'ปิดการใช้งานส่วนหัวของ HTTP "X-Frame-Options: SAMEORIGIN" เพื่อช่วยให้ OTRS ถูกรวมเป็น IFrame ในเว็บไซต์อื่น ๆ ปิดการใช้งานส่วนหัวของ HTTP นี้อาจจะเกิดปัญหาด้านความปลอดภัย! ปิดการใช้งานเมื่อคุณรู้ว่าสิ่งที่คุณกำลังทำคืออะไรเท่านั้น!',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE.' =>
            'ปิดการใช้งานการรักษาความปลอดภัยที่ถูก จำกัด สำหรับ IFrames ใน IE อาจจะจำเป็นสำหรับ SSO ที่จะทำงานใน IE',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'ปิดการใช้งานการแจ้งเตือนการส่งไปยังเอเย่นต์ที่รับผิดชอบตั๋ว(Ticket::Responsible ต้องมีการเปิดใช้งานการบริการ)',
        'Disables the communication between this system and OTRS Group servers that provides cloud services. If active, some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            'ปิดการใช้งานการสื่อสารระหว่างระบบนี้และเซิร์ฟเวอร์ OTRS กลุ่มที่ให้บริการระบบคลาวด์ หากใช้งาน ฟังก์ชั่นบางอย่างจะหายไปเช่น การลงทะเบียนระบบ การส่งข้อมูลสนับสนุน
การอัพเกรดและการใช้ OTRS ธุรกิจโซลูชั่น™, OTRS ตรวจสอบ™, OTRS ข่าวสารและสินค้าแดชบอร์ดข่าวเครื่องมืออื่น ๆ ในกลุ่ม',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            'ปิดใช้งานการติดตั้งเว็บ (http://yourhost.example.com/otrs/installer.pl) เพื่อป้องกันระบบจากการถูกแย่งชิง ถ้าตั้งค่าเป็น "ไม่" ระบบสามารถติดตั้งและการกำหนดค่าพื้นฐานในปัจจุบันจะถูกนำมาใช้เพื่อเติมคำถามภายในสคริปต์ติดตั้ง ถ้าไม่ได้ใช้งานก็จะปิดการใช้งาน GenericAgent, PackageManager และกล่อง SQL',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'แสดงคำเตือนและป้องกันการค้นหาเมื่อหยุดใช้คำที่อยู่ในการค้นหา Fulltext',
        'Display settings to override defaults for Process Tickets.' => 'แสดงการตั้งค่าแทนที่ค่าเริ่มต้นสำหรับกระบวนการสร้างตั๋ว',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'แสดงเวลาคิดสำหรับบทความในมุมมองการซูมตั๋ว',
        'Dropdown' => 'ดรอปดาวน์',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'คำหยุดดัตช์สำหรับดัชนี Fulltext คำเหล่านี้จะถูกลบออกจากดัชนีการค้นหา',
        'Dynamic Fields Checkbox Backend GUI' => 'ฟิลด์แบบไดนามิก Checkbox Backend GUI',
        'Dynamic Fields Date Time Backend GUI' => 'ฟิลด์แบบไดนามิก Date Time Backend GUI',
        'Dynamic Fields Drop-down Backend GUI' => 'ฟิลด์แบบไดนามิก Drop-down Backend GUI',
        'Dynamic Fields GUI' => ' GUI ฟิลด์แบบไดนามิก',
        'Dynamic Fields Multiselect Backend GUI' => 'ฟิลด์แบบไดนามิก Multiselect Backend GUI',
        'Dynamic Fields Overview Limit' => 'ภาพรวมทีจำกัดของไดมานิคฟิลด์',
        'Dynamic Fields Text Backend GUI' => 'ฟิลด์แบบไดนามิก ฟิลด์แบบไดนามิก',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'ฟิลด์แบบไดนามิก ถูกนำมาใช้เพื่อส่งออกผลการค้นหาในรูปแบบ CSV',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'กลุ่มฟิลด์แบบไดนามิกสำหรับกระบวนการของวิดเจ็ต กุญแจสำคัญคือชื่อของกลุ่ม ค่าประกอบด้วยฟิลด์ที่จะแสดง ตัวอย่าง: \'Key => My Group\', \'Content: Name_X, NameY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'การจำกัดฟิลด์แบบไดนามิกในแต่ละหน้าสำหรับข้อมูลทั่วไปของฟิลด์แบบไดนามิก',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'ตัวเลือกเขตข้อมูลแบบไดนามิกที่แสดงในหน้าจอข้อความตั๋วของอินเตอร์เฟซลูกค้า การตั้งค่าที่เป็นไปได้: 0 = ปิดการใช้งาน 1 = เปิดใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้ หมายเหตุ. หากคุณต้องการแสดงเขตข้อมูลเหล่านี้ยังอยู่ในการซูมตั๋วของอินเตอร์เฟซของลูกค้าคุณต้องเปิดใช้งานพวกเขาใน CustomerTicketZoom ### DynamicField',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ตัวเลือกฟิลด์แบบไดนามิกแสดงในส่วนของการตอบกลับตั๋วในหน้าจอซูมตั๋วของในอินเตอร์เฟซของลูกค้า การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าอีเมลขาออกในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'ไดนามิคฟิลด์แสดงในเครื่องมือกระบวนการซูมตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'ไดนามิคฟิลด์แสดงในแถบด้านข้างในหน้าการซูมตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าตั๋วปิดในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าการเขียนตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าตั๋วอีเมลในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าตั๋วที่ถูกส่งต่อในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าตั๋วข้อความฟรีในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'เขตข้อมูลแบบไดนามิกที่ปรากฏในรูปแบบภาพรวมของตั๋วขนาดกลางของอินเตอร์เฟซตัวแทน การตั้งค่าที่เป็นไปได้: 0 = ปิดการใช้งาน 1 = เปิดใช้งาน',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าจอการย้ายตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าตั๋วโน๊ตในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ตัวเลือกฟิลด์แบบไดนามิกแสดงในหน้าจอภาพรวมในอินเตอร์เฟซของลูกค้า การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ตัวเลือกฟิลด์แบบไดนามิกแสดงในหน้าจอเจ้าของตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ตัวเลือกฟิลด์แบบไดนามิกแสดงในหน้าจอตั๋วที่อยุ่อยู่ระหว่างดำเนินการในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ตัวเลือกฟิลด์แบบไดนามิกแสดงในหน้าจอตั๋วโทรศัพท์สายเข้าในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ตัวเลือกฟิลด์แบบไดนามิกแสดงในหน้าจอตั๋วโทรศัพท์ขาออกในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ตัวเลือกฟิลด์แบบไดนามิกแสดงในหน้าจอตั๋วโทรศัพท์ในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'ไดนามิคฟิลด์แสดงในหน้ามุมมองภาพรวมของรูปแบบการแสดงตัวอย่างตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'ไดนามิคฟิลด์แสดงในหน้าจอการพิมพ์ตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'ไดนามิคฟิลด์แสดงในหน้าการพิมพ์ตั๋วในอินเตอร์เฟซของลูกค้า การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าจอลำดับความสำคัญของตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'ไดนามิคฟิลด์แสดงในหน้าจอผู้รับผิดชอบตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและจำเป็นต้องใช้',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'ไดนามิคฟิลด์แสดงในหน้ามุมมองภาพรวมของการค้นหาตั๋วในอินเตอร์เฟซของลูกค้า การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            'ไดนามิคฟิลด์แสดงในหน้าจอการค้นหาตั๋วในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและแสดงค่าเริ่มต้น',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'ไดนามิคฟิลด์แสดงในหน้าจอการค้นหาตั๋วในอินเตอร์เฟซของลูกค้า การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'ไดนามิคฟิลด์แสดงในหน้ามุมมองภาพรวมของตั๋วขนาดเล็กในอินเตอร์เฟซของเอเย่นต์ การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน 2 = เปิดใช้งานและแสดงค่าเริ่มต้น',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'ไดนามิคฟิลด์แสดงในหน้าจอการซูมตั๋วในอินเตอร์เฟซของลูกค้า การตั้งค่าที่เป็นไปได้คือ 0 = ปิดการใช้งาน 1 = เปิดการใช้งาน ',
        'DynamicField' => 'DynamicField',
        'DynamicField backend registration.' => 'การลงทะเบียนส่วนหลังของ DynamicField',
        'DynamicField object registration.' => 'ารลงทะเบียนออบเจคของDynamicField',
        'E-Mail Outbound' => 'อีเมลขาออก',
        'Edit Customer Companies.' => 'แก้ไขลูกค้าบริษัท',
        'Edit Customer Users.' => 'แก้ไขผู้ใช้ลูกค้า',
        'Edit customer company' => 'แก้ไขลูกค้าบริษัท',
        'Email Addresses' => 'ที่อยู่อีเมล',
        'Email Outbound' => 'อีเมลขาออก',
        'Email sent to "%s".' => 'อีเมลถูกส่งไปยัง "%s"',
        'Email sent to customer.' => 'อีเมลถูกส่งไปยังลูกค้า',
        'Enable keep-alive connection header for SOAP responses.' => 'เปิดใช้งานการเชื่อมต่อหัว keep-alive สำหรับการตอบสนอง SOAP',
        'Enabled filters.' => 'เปิดใช้งานตัวกรอง',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'เปิดใช้การสนับสนุน PGP เมื่อการสนับสนุน PGP เปิดใช้งานสำหรับการเซ็นชื่อและการเข้ารหัสอีเมลจึงขอแนะนำว่าเว็บเซิร์ฟเวอร์รันฐานะผู้ใช้ OTRS มิฉะนั้นจะมีปัญหาเกี่ยวกับสิทธิพิเศษเมื่อมีการเข้าถึงโฟลเดอร์ .gnupg',
        'Enables S/MIME support.' => 'เปิดใช้งานการสนับสนุน S/MIME',
        'Enables customers to create their own accounts.' => 'ช่วยให้ลูกค้าสามารถสร้างบัญชีของตัวเอง',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => 'ช่วยให้การอัปโหลดไฟล์ในส่วนหน้าของแพคเกจผู้จัดการ',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'เปิดหรือปิดใช้แคชสำหรับแม่แบบ คำเตือน: อย่าปิดการใช้งานแม่แบบแคชสำหรับสภาพแวดล้อมการผลิตจะทำให้ประสิทธิภาพการทำงานลดลงมหาศาล! การตั้งค่านี้ควรจะปิดการใช้งานสำหรับเหตุผลการดีบัก!',
        'Enables or disables the debug mode over frontend interface.' => 'เปิดหรือปิดโหมดการแก้ปัญหาในช่วงอินเตอร์เฟซที่ส่วนหน้า',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'เปิดหรือปิดใช้งานคุณลักษณะ Watcher ตั๋วในการติดตามของตั๋วโดยไม่ต้องเป็นเจ้าของหรือรับผิดชอบ',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'เปิดใช้งานการล็อกผลการดำเนินงาน (เข้าสู่ระบบเวลาตอบสนองหน้า) มันจะส่งผลกระทบต่อประสิทธิภาพของระบบ ต้องเปิดใช้งาน Frontend::Module###AdminPerformanceLog',
        'Enables spell checker support.' => 'เปิดใช้งานการสนับสนุนการตรวจสอบการสะกดคำ',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'ช่วยให้ขนาดเคาน์เตอร์ตั๋วน้อยที่สุด (ถ้า "ข้อมูล" ได้รับเลือกเป็น TicketNumberGenerator)',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'เปิดใช้งานคุณลักษณะตั๋วกระทำจำนวนมากสำหรับฟรอนต์เอนของเอเย่นต์ในการทำงานมากกว่าหนึ่งตั๋วในเวลาเดียวกัน',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'เปิดใช้งานคุณลักษณะตั๋วการทำงานเป็นกลุ่มเฉพาะสำหรับกลุ่มที่ระบุไว้',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'ช่วยให้ตั๋วคุณลักษณะความรับผิดชอบที่จะติดตามการตั๋วที่เฉพาะเจาะจง',
        'Enables ticket watcher feature only for the listed groups.' => 'เปิดใช้งานคุณลักษณะ Watcher ตั๋วเฉพาะสำหรับกลุ่มที่ระบุไว้',
        'English (Canada)' => 'ภาษาอังกฤษ (แคนาดา)',
        'English (United Kingdom)' => 'อังกฤษ (สหราชอาณาจักร)',
        'English (United States)' => 'ภาษาอังกฤษ (สหรัฐอเมริกา)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'คำหยุดภาษาอังกฤษสำหรับดัชนี Fulltext คำพูดเหล่านี้จะถูกลบออกจากดัชนีการค้นหา',
        'Enroll process for this ticket' => 'ลงทะเบียนกระบวนการสำหรับตั๋วนี้',
        'Enter your shared secret to enable two factor authentication.' =>
            'ป้อนความลับที่คุณแบ่งปันเพื่อการเปิดใช้งานการตรวจสอบสองปัจจัย',
        'Escalation response time finished' => 'การขยายเวลาตอบสนองเสร็จสิ้น',
        'Escalation response time forewarned' => 'การขยายเวลาตอบสนองที่เตือนล่วงหน้า',
        'Escalation response time in effect' => 'การขยายเวลาตอบสนองมีผลบังคับ',
        'Escalation solution time finished' => 'การขยายเวลาแก้ปัญหาเสร็จสิ้น',
        'Escalation solution time forewarned' => 'การขยายเวลาแก้ปัญหาที่เตือนล่วงหน้า',
        'Escalation solution time in effect' => 'การขยายเวลาแก้ปัญหามีผลบังคับ',
        'Escalation update time finished' => 'การขยายเวลาอัพเดตเสร็จสิ้น',
        'Escalation update time forewarned' => 'การขยายเวลาอัพเดตที่เตือนล่วงหน้า',
        'Escalation update time in effect' => 'การขยายเวลาอัพเดตมีผลบังคับ',
        'Escalation view' => 'มุมมองการขยาย',
        'EscalationTime' => 'เวลาของการขยาย',
        'Estonian' => 'ภาษาเอสโตเนีย',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'การลงทะเบียนโมดูลเหตุการณ์ เพื่อให้ได้ประสิทธิภาพมากขึ้นคุณสามารถกำหนดเหตุการณ์ตัวเรียกโฆษณา (e. ก. จัดกิจกรรม => TicketCreate)',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'การลงทะเบียนโมดูลเหตุการณ์ เพื่อให้ได้ประสิทธิภาพมากขึ้นคุณสามารถกำหนดเหตุการณ์ตัวเรียกโฆษณา (e. ก. จัดกิจกรรม => TicketCreate) เป็นไปได้เฉพาะในกรณีที่ตั๋วฟิลด์แบบไดนามิกทุกตั๋วจำเป็นต้องมีเหตุการณ์เดียวกัน',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'โมดูลเหตุการณ์ที่ดำเนินการคำสั่งการอัพเดตTicketIndex เพื่อเปลี่ยนชื่อคิวถ้าจำเป็นและนำStaticDB มาใช้จริง',
        'Event module that updates customer user search profiles if login changes.' =>
            'โมดูลเหตุการณ์ที่อัพเดทโปรไฟล์ค้นหาของผู้ใช้ลูกค้าหากมีการเปลี่ยนแปลงการเข้าสู่ระบบ',
        'Event module that updates customer user service membership if login changes.' =>
            'โมดูลเหตุการณ์ที่ปรับปรุงสมาชิกผู้ใช้บริการลูกค้าหากมีการเปลี่ยนแปลงการเข้าสู่ระบบ',
        'Event module that updates customer users after an update of the Customer.' =>
            'โมดูลเหตุการณ์ที่ปรับปรุงผู้ใช้ลูกค้าหลังจากการปรับปรุงของลูกค้า',
        'Event module that updates tickets after an update of the Customer User.' =>
            'โมดูลเหตุการณ์ที่ปรับปรุงตั๋วหลังจากการปรับปรุงของผู้ใช้งานลูกค้า',
        'Event module that updates tickets after an update of the Customer.' =>
            'โมดูลเหตุการณ์ที่ปรับปรุงตั๋วหลังจากการปรับปรุงของลูกค้า',
        'Events Ticket Calendar' => 'ปฏิทินตั๋วเหตุการณ์',
        'Execute SQL statements.' => '_',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'รันคำสั่งที่กำหนดเองหรือโมดูล หมายเหตุ: หากโมดูลมีการใช้ฟังก์ชั่นเป็นสิ่งจำเป็น',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'ดำเนินการตรวจการติดตามผลในการตรวจสอบใน In-Reply-To หรือการอ้างอิงข้อมูลส่วนหัวสำหรับอีเมลที่ไม่ได้หมายเลขตั๋วในเนื้อเรื่อง',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'ดำเนินการตรวจการติดตามผลในการตรวจสอบในเนื้อหาของสิ่งที่แนบมาสำหรับอีเมลที่ไม่ได้หมายเลขตั๋วในเนื้อเรื่อง',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'ดำเนินการตรวจการติดตามผลในการตรวจสอบในเนื้อหาอีเมลสำหรับอีเมลที่ไม่ได้หมายเลขตั๋วในเนื้อเรื่อง',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'ดำเนินการตรวจการติดตามผลในการตรวจสอบในแหล่งที่มาอีเมลสำหรับอีเมลที่ไม่ได้หมายเลขตั๋วในเนื้อเรื่อง',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'ส่งบทความทั้งหมดในผลการค้นหาออก (มันสามารถส่งผลกระทบต่อประสิทธิภาพการทำงานของระบบ)',
        'Fetch emails via fetchmail (using SSL).' => 'ดึงข้อมูลอีเมลผ่าน fetchmail (โดยใช้ SSL)',
        'Fetch emails via fetchmail.' => 'ดึงข้อมูลอีเมลผ่าน fetchmail',
        'Fetch incoming emails from configured mail accounts.' => 'ดึงข้อมูลอีเมลขาเข้าจากบัญชีอีเมลการกำหนดค่า',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'เรียกแพคเกจผ่านพร็อกซี่ เขียนทับ "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'ไฟล์ที่แสดงอยู่ในโมดูล Kernel::Modules::AgentInfo ซึ่งอยู่ใต้ Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'ตัวกรองสำหรับการดีบัก ACLs หมายเหตุ: คุณลักษณะตั๋วเพิ่มเติมสามารถเพิ่มในรูปแบบ <OTRS_TICKET_Attribute> เช่น <OTRS_TICKET_Priority>',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'ตัวกรองสำหรับการดีบักการเปลี่ยนภาพ หมายเหตุ: ตัวกรองเพิ่มเติมสามารถเพิ่มในรูปแบบ<OTRS_TICKET_Attribute> เช่น <OTRS_TICKET_Priority>',
        'Filter incoming emails.' => 'ตัวกรองอีเมลขาเข้า',
        'Finnish' => 'ภาษาฟินแลนด์',
        'First Queue' => 'คิวแรก',
        'FirstLock' => 'FirstLock',
        'FirstResponse' => 'FirstResponse',
        'FirstResponseDiffInMin' => 'FirstResponseDiffInMin',
        'FirstResponseInMin' => 'FirstResponseInMin',
        'Firstname Lastname' => 'ชื่อนามสกุล',
        'Firstname Lastname (UserLogin)' => 'ชื่อนามสกุล (ผู้ใช้เข้าสู่ระบบ)',
        'FollowUp for [%s]. %s' => 'ติดตามสำหรับ [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'กองทัพเข้ารหัสอีเมลขาออก(7bit|8bit|quoted-printable|base64) ',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'บังคับให้เลือกสถานภาพของตั๋วที่แตกต่างกัน (จากปัจจุบัน) หลังจากการดำเนินการล็อค กําหนดสถานภาพในปัจจุบันเป็นคีย์และสถานภาพถัดไปหลังจากการดำเนินการล็อคเป็นเนื้อหา',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Forcesที่จะปลดล็อคตั๋วหลังจากที่ถูกย้ายไปยังอีกคิว',
        'Forwarded to "%s".' => 'ส่งต่อไปยัง "%s".',
        'French' => 'ภาษาฝรั่งเศส',
        'French (Canada)' => 'ภาษาฝรั่งเศษ (แคนาดา)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'คำว่าหยุดภาษาฝรั่งเศสสำหรับดัชนี Fulltext คำพูดเหล่านี้จะถูกลบออกจากดัชนีการค้นหา',
        'Frontend' => 'Frontend',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'การลงทะเบียนโมดูล Frontend (ปิดการใช้งานการเชื่อมโยงบริษัท ถ้าไม่มีฟีเจอร์บริษัทถูกนำมาใช้)',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'การลงทะเบียนโมดูล Frontend สำหรับลูกค้า (ปิดการใช้งานหน้าจอของกระบวนการของตั๋วหน้าจอหากไม่สามารถใช้กระบวนการได้)',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'การลงทะเบียนโมดูล Frontend (ปิดการใช้งานหน้าจอของกระบวนการของตั๋วหน้าจอหากไม่สามารถใช้กระบวนการได้)',
        'Frontend module registration for the agent interface.' => 'การลงทะเบียนโมดูล Frontend สำหรับอินเตอร์เฟซของเอเย่นต์',
        'Frontend module registration for the customer interface.' => 'การลงทะเบียนโมดูล Frontend สำหรับอินเตอร์เฟซลูกค้า',
        'Frontend module registration for the public interface.' => 'การลงทะเบียนโมดูล Frontend สำหรับอินเตอร์เฟซสาธารณะ',
        'Frontend theme' => 'ธีม Frontend',
        'Frontend theme.' => '',
        'Full value' => 'ค่าเต็ม',
        'Fulltext index regex filters to remove parts of the text.' => 'ดัชนี regex ของ Fulltext กรองเพื่แลบบางส่วนของข้อความ',
        'Fulltext search' => 'ค้นหาข้อความฉบับเต็ม',
        'Galician' => 'ภาษากาลิเซีย',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            'ข้อมูลทั่วไปของตั๋วแสดงในภาพรวมตั๋ว (ตกหลัง) การตั้งค่าที่เป็นไปได้: 0 =ปิดใช้งาน 1 =พร้อมใช้งาน  2 = เปิดใช้งานโดยค่าเริ่มต้น หมายเหตุ หมายเลขตั๋วไม่สามารถปิดการใช้งานเพราะมันเป็นสิ่งที่จำเป็น',
        'Generate dashboard statistics.' => 'สร้างสถิติแดชบอร์ด',
        'Generic Info module.' => 'โมดูลข้อมูลทั่วไป',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => 'GUI อินเตอร์เฟซทั่วไปของการดีบัก',
        'GenericInterface Invoker GUI' => 'GUI อินเตอร์เฟซทั่วไปของ Invoker',
        'GenericInterface Operation GUI' => 'GUI อินเตอร์เฟซทั่วไปของ Operation',
        'GenericInterface TransportHTTPREST GUI' => 'GUI อินเตอร์เฟซทั่วไปของ TransportHTTPREST',
        'GenericInterface TransportHTTPSOAP GUI' => 'GUI อินเตอร์เฟซทั่วไปของ TransportHTTPSOAP',
        'GenericInterface Web Service GUI' => 'GUI อินเตอร์เฟซทั่วไปของWeb Service',
        'GenericInterface Webservice History GUI' => 'GUI อินเตอร์เฟซทั่วไปของWeb History',
        'GenericInterface Webservice Mapping GUI' => 'GUI อินเตอร์เฟซทั่วไปของ Webservice Mapping',
        'GenericInterface module registration for the invoker layer.' => 'การลงทะเบียนโมดูล GenericInterface สำหรับชั้นของผู้ร้องขอ',
        'GenericInterface module registration for the mapping layer.' => 'การลงทะเบียนโมดูล GenericInterface สำหรับชั้นของการทำแผนที่',
        'GenericInterface module registration for the operation layer.' =>
            'การลงทะเบียนโมดูล GenericInterface สำหรับชั้นของการดำเนินงาน',
        'GenericInterface module registration for the transport layer.' =>
            'การลงทะเบียนโมดูล GenericInterface สำหรับชั้นของการขนส่ง',
        'German' => 'ภาษาเยอรมัน',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'คำหยุดภาษาเยอรมันสำหรับดัชนี Fulltext คำเหล่านี้จะถูกลบออกจากดัชนีการค้นหา',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            'ให้ความเป็นไปได้กับผู้ใช้ในการแทนที่ตัวอักษรที่คั่นสำหรับไฟล์ CSV ที่กำหนดไว้ในแฟ้มการแปล',
        'Global Search Module.' => 'โมดูลการค้นหาทั่วโลก',
        'Go back' => 'กลับไป',
        'Google Authenticator' => 'การรับรองความถูกต้องจาก Google',
        'Graph: Bar Chart' => 'กราฟ: กราฟแท่ง',
        'Graph: Line Chart' => 'กราฟ: แผนภูมิเส้น',
        'Graph: Stacked Area Chart' => 'กราฟ: ซ้อนแผนภูมิพื้นที่',
        'Greek' => 'ภาษากรีก',
        'HTML Reference' => 'อ้างอิงHTML',
        'HTML Reference.' => 'อ้างอิงHTML',
        'Hebrew' => 'ภาษาฮิบรู',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            '',
        'Hindi' => 'ภาษาฮินดี',
        'Hungarian' => 'ภาษาฮังการี',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'สามารถกำหนดโปรแกรมควบคุมฐานข้อมูล (ปกติจะใช้ตรวจสอบอัตโนมัติ)ได้ ถ้า "DB" ถูกเลือกให้ Customer :: AuthModule',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'สามารถกำหนดรหัสผ่านเพื่อเชื่อมต่อกับตารางลูกค้าได้ ถ้า "DB" ถูกเลือกให้ Customer :: AuthModule',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'สามารถกำหนดชื่อผู้ใช้เพื่อเชื่อมต่อกับตารางลูกค้าได้ ถ้า "DB" ถูกเลือกให้ Customer :: AuthModule',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'ต้องกำหนดDSN สำหรับการเชื่อมต่อไปยังตารางลูกค้าถ้า "DB" ถูกเลือกให้ Customer :: AuthModule',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'ต้องกำหนดชื่อคอลัมน์สำหรับ CustomerPassword ในตารางลูกค้าถ้า "DB" ถูกเลือกให้ Customer :: AuthModule',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'ต้องกำหนดรหัสผ่านแบบคริพป์ถ้า "DB" ถูกเลือกให้ Customer :: AuthModule',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'ต้องกำหนดชื่อคอลัมน์สำหรับ CustomerKey ในตารางลูกค้าถ้า "DB" ถูกเลือกให้ Customer :: AuthModule',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'ต้องกำหนดชื่อของตารางที่ข้อมูลลูกค้าของคุณจะถูกเก็บไว้ถ้า "DB" ถูกเลือกให้ Customer :: AuthModule',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'ต้องกำหนดชื่อของตารางที่ข้อมูลของเซสชั่นจะถูกเก็บไว้ถ้า "DB" ถูกเลือกให้ SessionModule',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'ต้องกำหนดไดเรกทอรีที่ข้อมูลของเซสชั่นจะถูกเก็บไว้ถ้า "FS" ถูกเลือกให้ SessionModule',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'คุณสามารถกำหนด (โดยการใช้ RegEx )เพื่อจะตัดส่วนของ REMOTE_USER (เช่น สำหรับการลบโดเมนที่ต่อท้าย) RegExp-Note, $1 จะกลายเป็นล็อกอินใหม่',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'หาก "HTTPBasicAuth" ถูกเลือกให้ Customer::AuthModule คุณสามารถกำหนดเพื่อตัดส่วนหน้าของชื่อผู้ใช้ (เช่น สำหรับโดเมน example_domain\user ไปยังผู้ใช้)',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule และถ้าคุณต้องการที่จะเพิ่มคำต่อท้ายชื่อสำหรับเข้าสู่ระบบให้ลูกค้าทุกคน โปรดระบุที่นี่ เช่น คุณเพียงแค่เขียนชื่อผู้ใช้ แต่ในไดเรกทอรี LDAP จะเป็น user@domain.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule และพารามิเตอร์พิเศษที่มีความจำเป็นสำหรับโมดูล Perl Net::LDAP คุณสามารถระบุพวกเขาที่นี่ โปรดดูที่ "perldoc Net::LDAP" สำหรับข้อมูลเพิ่มเติมเกี่ยวกับพารามิเตอร์',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule จะต้องระบุ ฐาน DN ',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule สามารถระบุโฮสต์ LDAP ได้',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule ตัวระบุผู้ใช้จะต้องระบุ',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule ผู้ใช้สามารถระบุคุณลักษณะได้ สำหรับกลุ่ม LDAP POSIX ใช้UID, สำหรับผู้ที่ไม่ใช่กลุ่ม LDAP POSIX ผู้ใช้งานเต็มรูปแบบ DN',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule คุณสามารถระบุคุณลักษณะการเข้าถึงที่นี่',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule คุณสามารถระบุได้ว่าการใช้งานจะหยุดถ้าการเชื่อมต่อไปยังเซิร์ฟเวอร์ไม่สามารถสร้างเนื่องจากปัญหาเครือข่าย',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'หาก "LDAP" ถูกเลือกให้ Customer::AuthModule คุณสามารถตรวจสอบว่าผู้ใช้ที่ได้รับอนุญาตในการตรวจสอบเพราะเขาอยู่ใน posixGroup เช่น ผู้ใช้ต้องการที่จะอยู่ในกลุ่ม xyz เพื่อใช้ OTRS ระบุกลุ่มที่อาจเข้าสู่ระบบ',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'หาก "LDAP" ถูกเลือก คุณสามารถเพิ่มตัวกรองให้แต่ละแบบสอบถาม LDAP เช่น (mail=*), (objectclass=user) หรือ (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'หาก "SysLog" 5^dเลือกให้ LogModule สามารถระบุสิ่งอำนวยความสะดวกพิเศษการเข้าสู่ระบบได้',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
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
        'If enabled debugging information for ACLs is logged.' => 'หากข้อมูลการแก้จุดบกพร่องที่เปิดใช้งานสำหรับ ACL ถูกบันทึกไว้',
        'If enabled debugging information for transitions is logged.' => 'หากข้อมูลการแก้จุดบกพร่องเปิดใช้งานสำหรับการเปลี่ยนถูกบันทึกไว้',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'หากเปิดใช้งานเดมอนจะเปลี่ยนเส้นทางค่าสตรีมข้อผิดพลาดมาตรฐานไปยังล็อกไฟล์',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'หากเปิดใช้งานเดมอนจะเปลี่ยนเส้นทางค่าสตรีมออกมาตรฐานการล็อกไฟล์',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'หากเปิดใช้งาน ตั๋วโทรศัพท์และตั๋วอีเมลจะเปิดในหน้าต่างใหม่',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is disabled, articles will not automatically be decrypted and stored in the database. Please note that this also means no decryption will take place and the articles will be shown in ticket zoom in their original (encrypted) form.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'รวมตั๋วของ subqueues ต่อค่าเริ่มต้นเมื่อมีการเลือกคิว',
        'Include unknown customers in ticket filter.' => 'รวมถึงลูกค้าที่ไม่รู้จักในตัวกรองตั๋ว',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'Incoming Phone Call.' => 'โทรศัพท์สายเข้า',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indonesian' => '',
        'Input' => 'การป้อนเข้า',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'ภาษาของอินเตอร์เฟซ',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian' => 'ภาษาอิตาลี',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => 'ดิไอวอรี่',
        'Ivory (Slim)' => 'ดิไอวอรี่ (บาง)',
        'Japanese' => 'ภาษาญี่ปุ่น',
        'JavaScript function for the search frontend.' => '',
        'Last customer subject' => 'หัวข้อล่าสุดของลูกค้า',
        'Lastname Firstname' => 'ชื่อนามสกุล',
        'Lastname Firstname (UserLogin)' => 'ชื่อนามสกุล (ผู้ใช้เข้าสู่ระบบ)',
        'Lastname, Firstname' => 'ชื่อ, นามสกุล',
        'Lastname, Firstname (UserLogin)' => 'ชื่อ, นามสกุล (UserLogin)',
        'Latvian' => 'ภาษาแลทเวีย',
        'Left' => 'ซ้าย',
        'Link Object' => 'การเชื่อมโยงออบเจค',
        'Link Object.' => 'วัตถุการเชื่อมโยง',
        'Link agents to groups.' => 'ตัวแทนเชื่อมโยงไปยังกลุ่ม',
        'Link agents to roles.' => 'ลิ้งตัวแทนกับบทบาท',
        'Link attachments to templates.' => 'ลิ้งสิ่งที่แนบมาไปยังแม่แบบ',
        'Link customer user to groups.' => 'ลิ้งผู้ใช้ไปยังลูกค้ากลุ่ม',
        'Link customer user to services.' => 'ลิ้งผู้ใช้ไปยังลูกค้าบริการ',
        'Link queues to auto responses.' => 'ลิ้งคำสั่งไปยังการตอบอัตโนมัติ',
        'Link roles to groups.' => 'ลิ้งบทบาทไปยังกลุ่ม',
        'Link templates to queues.' => 'ลิ้งแม่แบบไปยังคิว',
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
        'Lithuanian' => '',
        'Lock / unlock this ticket' => '',
        'Locked Tickets.' => '',
        'Locked ticket.' => '',
        'Log file for the ticket counter.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Loop-Protection! No auto-response sent to "%s".' => '',
        'Mail Accounts' => 'บัญชีอีเมล',
        'Main menu registration.' => 'การลงทะเบียนเมนูหลัก',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => 'ภาษามาเล',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => '',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark this ticket as junk!' => 'ทำเครื่องหมายตั๋วนี้เป็นขยะ!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum Number of a calendar shown in a dropdown.' => '',
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
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Miscellaneous' => 'เบ็ดเตล็ด',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => 'โมดูลเพื่อสร้างสถิติตั๋ว',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '',
        'Module to grant access to the agent responsible of a ticket.' =>
            '',
        'Module to grant access to the creator of a ticket.' => '',
        'Module to grant access to the owner of a ticket.' => '',
        'Module to grant access to the watcher agents of a ticket.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => 'โมดูลที่จะใช้จัดเก็บฐานข้อมูลของตัวกรอง',
        'Multiselect' => 'หลายรายการ',
        'My Services' => 'การบริการของฉัน',
        'My Tickets.' => 'ตั๋วของฉัน',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'NameX',
        'Nederlands' => 'Nederlands',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'ตั๋วใหม่ [%s] ถูกสร้างแล้ว (Q=%s;P=%s;S=%s).',
        'New Window' => 'หน้าต่างใหม่',
        'New owner is "%s" (ID=%s).' => 'เจ้าของใหม่คือ "%s" (ID=%s).',
        'New process ticket' => 'ตั๋วกระบวนการใหม่',
        'New responsible is "%s" (ID=%s).' => 'ผู้รับผิดชอบใหม่ "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'None' => 'ไม่มี',
        'Norwegian' => 'ภาษานอร์เวย์',
        'Notification sent to "%s".' => 'การแจ้งเตือนที่ส่งไปยัง "%s"',
        'Number of displayed tickets' => 'จำนวนตั๋วที่แสดง',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'เก่า: "%s" ใหม่: "%s"',
        'Open tickets (customer user)' => 'ตั๋วเปิด (ผู้ใช้ของลูกค้า)',
        'Open tickets (customer)' => 'เปิดตั๋ว (ลูกค้า)',
        'Option' => 'ตัวเลือก',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Out Of Office' => 'ออกจากสำนักงาน',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => 'ภาพรวมตั๋วส่งต่อ',
        'Overview Refresh Time' => 'ภาพรวมเวลารีเฟรช',
        'Overview of all escalated tickets.' => 'ภาพรวมของตั๋วที่เพิ่มขึ้นทั้งหมด',
        'Overview of all open Tickets.' => 'ภาพรวมของตั๋วที่เปิดอยู่ทั้งหมด',
        'Overview of all open tickets.' => 'ภาพรวมของตั๋วที่เปิดอยู่ทั้งหมด',
        'Overview of customer tickets.' => 'ภาพรวมของตั๋วของลูกค้า',
        'PGP Key Management' => 'การจัดการคีย์ PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
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
        'ParentChild' => 'ParentChild',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'People' => 'คน',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => 'ภาษาเปอร์เซีย',
        'Phone Call.' => 'โทรศัพท์เรียกเข้า',
        'Picture Upload' => 'อัพโหลดรูปภาพ',
        'Picture upload module.' => 'โมดูลอัพโหลดรูปภาพ',
        'Picture-Upload' => 'อัพโหลด-รูปภาพ',
        'Polish' => 'ภาษาโปแลนด์',
        'Portuguese' => 'ภาษาโปรตุเกส',
        'Portuguese (Brasil)' => 'ภาษาโปรตุเกส (บราซิล)',
        'PostMaster Filters' => 'ตัวกรอง PostMaster',
        'PostMaster Mail Accounts' => 'เมลตัวกรอง PostMaster',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process Ticket.' => 'ตั๋วกระบวนการ',
        'Process pending tickets.' => 'ตั๋วกระบวนการที่ค้างอยู่',
        'Process ticket' => 'ตั๋วกระบวนการ',
        'ProcessID' => 'ProcessID',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'มุมมองคิว',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => 'ช่วงเวลาการฟื้นฟู',
        'Removed subscription for user "%s".' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be active in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => 'รายงาน',
        'Reports (OTRS Business Solution™)' => 'รายงาน (OTRS Business Solution™)',
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
        'Responsible Tickets' => 'ผู้รับผิดชอบตั๋ว',
        'Responsible Tickets.' => 'ผู้รับผิดชอบตั๋ว',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => 'ขวา',
        'Roles <-> Groups' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => 'ภาษารัสเซีย',
        'SMS' => 'SMS',
        'SMS (Short Message Service)' => 'SMS (Short Message Service)',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen' => 'สกรีน',
        'Search Customer' => 'ค้นหาลูกค้า',
        'Search Ticket.' => 'ค้นหาตั๋ว',
        'Search Tickets.' => 'ค้นหาตั๋ว',
        'Search User' => 'ค้นหาผู้ใช้',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => 'ค้นหา',
        'Second Queue' => 'คิวที่สอง',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select your default spelling dictionary.' => '',
        'Select your preferred layout for OTRS.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Select your time zone.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => '',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service view' => 'มุมมองบริการ',
        'ServiceView' => 'มุมมองบริการ',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => '',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
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
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Shared Secret' => 'ความลับที่ใช้ร่วมกัน',
        'Should the cache data be held in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => 'แสดงประวัติสำหรับตั๋วนี้',
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
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
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
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
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
        'Simple' => 'ง่าย ๆ',
        'Skin' => 'ผิว',
        'Slovak' => 'ภาษาสโลวาเกีย',
        'Slovenian' => 'ภาษาสโลเวเนีย',
        'Software Package Manager.' => '',
        'SolutionDiffInMin' => 'SolutionDiffInMin',
        'SolutionInMin' => 'SolutionInMin',
        'Some description!' => 'คำอธิบายบางอย่าง!',
        'Some picture description!' => 'คำอธิบายภาพบางภาพ!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => 'สแปม',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish' => 'ภาษาสเปน',
        'Spanish (Colombia)' => 'ภาษาสเปน (โคลอมเบีย)',
        'Spanish (Mexico)' => 'ภาษาสเปน (เม็กซิโก)',
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
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Spell checker.' => '',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Stat#',
        'Status view' => 'ดูสถานะ',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Swahili' => 'ภาษาสวาฮิลี',
        'Swedish' => 'ภาษาสวีเดน',
        'System Address Display Name' => '',
        'System Maintenance' => '',
        'System Request (%s).' => '',
        'Target' => 'เป้าหมาย',
        'Templates <-> Queues' => '',
        'Textarea' => 'Textarea',
        'Thai' => 'ภาษาไทย',
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
        'This is a description for TimeZone on Customer side.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is part of the admin area of OTRS.' => '',
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
        'This will allow the system to send text messages via SMS.' => '',
        'Ticket Close.' => 'ตั๋วปิด',
        'Ticket Compose Bounce Email.' => '__',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => 'ตั๋วลูกค้า',
        'Ticket Forward Email.' => '',
        'Ticket FreeText.' => '',
        'Ticket History.' => '',
        'Ticket Lock.' => '',
        'Ticket Merge.' => '',
        'Ticket Move.' => '',
        'Ticket Note.' => '',
        'Ticket Notifications' => '',
        'Ticket Outbound Email.' => '',
        'Ticket Owner.' => '',
        'Ticket Pending.' => '',
        'Ticket Print.' => '',
        'Ticket Priority.' => '',
        'Ticket Queue Overview' => '',
        'Ticket Responsible.' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => '',
        'Ticket notifications' => '',
        'Ticket overview' => '',
        'Ticket plain view of an email.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => '',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => '',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for ticket notifications.' => '',
        'Tree view' => '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Ukrainian' => '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => '',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Updated SLA to %s (ID=%s).' => '',
        'Updated Service to %s (ID=%s).' => '',
        'Updated Type to %s (ID=%s).' => '',
        'Updated: %s' => '',
        'Updated: %s=%s;%s=%s;%s=%s;' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => '',
        'View performance benchmark results.' => '',
        'Watch this ticket' => '',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => '',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '',
        'Web View' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'attachment' => '',
        'bounce' => '',
        'compose' => '',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'notice' => '',
        'pending' => '',
        'responsible' => '',
        'stats' => '',

    };
    # $$STOP$$
    return;
}

1;
