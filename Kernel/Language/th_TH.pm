# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
    $Self->{Completeness}        = 0.585506264815442;

    # csv separator
    $Self->{Separator}         = ',';

    $Self->{DecimalSeparator}  = '.';
    $Self->{ThousandSeparator} = ',';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'การจัดการ ACL',
        'Actions' => 'การกระทำ',
        'Create New ACL' => 'สร้างACL ใหม่',
        'Deploy ACLs' => 'การปรับใช้ ACLs',
        'Export ACLs' => 'ส่งออก ACL',
        'Filter for ACLs' => 'ตัวกรองสำหรับ ACLs',
        'Just start typing to filter...' => 'แค่เริ่มต้นการพิมพ์เพื่อกรอง ...',
        'Configuration Import' => 'การกำหนดค่าการนำเข้า',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'คุณสามารถอัปโหลดไฟล์การกำหนดค่าที่จะนำเข้าACLs สู่ในระบบของคุณที่นี่และไฟล์ต้องอยู่ในรูปแบบ .ymlขณะที่ส่งออกโดยโมดูลตัวแก้ไขACL',
        'This field is required.' => 'จำเป็นต้องกรอกข้อมูลในช่องนี้.',
        'Overwrite existing ACLs?' => 'เขียนทับ ACLs ที่มีอยู่?',
        'Upload ACL configuration' => 'อัปโหลดการกำหนดค่า ACL',
        'Import ACL configuration(s)' => 'นำเข้าการกำหนดค่า ACL',
        'Description' => 'คำอธิบาย',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'เพื่อสร้างACLใหม่คุณสามารถสร้างโดยนำเข้าACLsที่ถูกส่งเข้ามาจากระบบอื่นหรือสร้างใหม่',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'การเปลี่ยนแปลง ACLs ที่นี่จะส่งผลกระทบต่อการทำงานของระบบเท่านั้น ถ้าหากคุณปรับใช้ข้อมูล ACL ในภายหลัง จะทำให้การเปลี่ยนแปลครั้งใหม่นั้นถูกเขียนที่การกำหนดค่าเนื่องการปรับใช้ข้อมูล ACL',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'โปรดทราบ: ตารางนี้แสดงถึงลำดับการดำเนินการของ ACLsถ้าคุณต้องการที่จะเปลี่ยนลำดับดำเนินการของ ACLs โปรดเปลี่ยนชื่อ ACLs ที่ ได้รับผลกระทบ',
        'ACL name' => 'ชื่อ ACL',
        'Comment' => 'ความคิดเห็น',
        'Validity' => 'ความถูกต้อง',
        'Export' => 'ส่งออก',
        'Copy' => 'คัดลอก',
        'No data found.' => 'ไม่พบข้อมูล.',
        'No matches found.' => 'ไม่พบคู่',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'แก้ไข ACL %s',
        'Edit ACL' => '',
        'Go to overview' => 'ไปที่ภาพรวม',
        'Delete ACL' => 'ลบACL',
        'Delete Invalid ACL' => 'ลบ ACL ที่ใช้ไม่ได้',
        'Match settings' => 'การตั้งค่าการจับคู่',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'กำหนดหลักเกณฑ์การจับคู่สำหรับ ACL นี้ ใช้ \'Properties\' เพื่อให้ตรงกับหน้าจอปัจจุบันหรือ \'PropertiesDatabase\' เพื่อให้ตรงกับคุณลักษณะของตั๋วในปัจจุบันที่อยู่ในฐานข้อมูล',
        'Change settings' => 'เปลี่ยนการตั้งค่า',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'ตั้งค่าสิ่งที่คุณต้องการที่จะเปลี่ยนแปลงถ้าหากตรงตามเกณฑ์ โปรดจำไว้ว่า \'Possible\' เป็นรายการที่อนุญาต \'PossibleNo\' คือแบล็คลิสต์',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'แสดงหรือซ่อนเนื้อหา',
        'Edit ACL Information' => '',
        'Name' => 'ชื่อ',
        'Stop after match' => 'หยุดหลังจากจับคู่แล้ว',
        'Edit ACL Structure' => '',
        'Save ACL' => '',
        'Save' => 'บันทึก',
        'or' => 'หรือ',
        'Save and finish' => 'บันทึกและเสร็จสิ้น',
        'Cancel' => 'ยกเลิก',
        'Do you really want to delete this ACL?' => 'คุณต้องการลบ ACL นี้หรือไม่?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'สร้าง ACL ใหม่โดยการส่งข้อมูลแบบฟอร์ม หลังจากที่สร้าง ACLคุณจะสามารถเพิ่มรายการการตั้งค่าในโหมดแก้ไข',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '',
        'Add Calendar' => '',
        'Edit Calendar' => '',
        'Calendar Overview' => '',
        'Add new Calendar' => '',
        'Import Appointments' => '',
        'Calendar Import' => '',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '',
        'Overwrite existing entities' => 'เขียนทับแอนตีตี้ที่มีอยู่',
        'Upload calendar configuration' => '',
        'Import Calendar' => '',
        'Filter for Calendars' => '',
        'Filter for calendars' => '',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            '',
        'Read only: users can see and export all appointments in the calendar.' =>
            '',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '',
        'Create: users can create and delete appointments in the calendar.' =>
            '',
        'Read/write: users can manage the calendar itself.' => '',
        'Group' => 'กลุ่ม',
        'Changed' => 'เปลี่ยนแล้ว',
        'Created' => 'สร้างแล้ว',
        'Download' => 'ดาวน์โหลด',
        'URL' => '',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => 'ปฏิทิน',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => 'บทบาทหน้าที่',
        'Remove this entry' => 'ลบการกรอกข้อมูลนี้',
        'Remove' => 'ลบ',
        'Start date' => 'วันที่เริ่มต้น',
        'End date' => '',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => 'คิว',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => 'เพิ่มการกรอกข้อมูล',
        'Add' => 'เพิ่ม',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => 'ส่ง',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => 'กลับไป',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => 'อัพโหลด',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '',
        'Add Notification' => 'เพิ่มการแจ้งเตือน',
        'Edit Notification' => 'แก้ไขการแจ้งเตือน',
        'Export Notifications' => 'ส่งออกการแจ้งเตือน',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => 'เขียนทับการแจ้งเตือนที่มีอยู่?',
        'Upload Notification configuration' => 'อัปโหลดการตั้งค่าการแจ้งเตือน',
        'Import Notification configuration' => 'นำเข้าการตั้งค่าการแจ้งเตือน',
        'List' => 'ลิสต์',
        'Delete' => 'ลบ',
        'Delete this notification' => 'ลบการแจ้งเตือนนี้',
        'Show in agent preferences' => 'แสดงในการตั้งค่าเอเย่นต์',
        'Agent preferences tooltip' => 'คำแนะนำการตั้งค่าเอเย่นต์',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'ข้อความนี้จะแสดงบนหน้าจอการตั้งค่าเอเย่นต์เพื่อเป็นคำแนะนำสำหรับการแจ้งเตือนนี้',
        'Toggle this widget' => 'สลับเครื่องมือนี้',
        'Events' => 'กิจกรรม',
        'Event' => 'กิจกรรม',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '',
        'Type' => 'ประเภท',
        'Title' => 'หัวข้อ',
        'Location' => 'ตำแหน่งที่อยู่',
        'Team' => '',
        'Resource' => '',
        'Recipients' => 'ผู้รับ',
        'Send to' => 'ส่งถึง',
        'Send to these agents' => 'ส่งให้เอเย่นต์เหล่านี้',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => 'ส่งให้กับสมาชิกที่มีบทบาททั้งหมด',
        'Send on out of office' => 'ส่งออกจากสำนักงาน',
        'Also send if the user is currently out of office.' => 'ส่งเช่นกันหากผู้ใช้ปัจจุบันอยู่นอกออฟฟิศ',
        'Once per day' => 'วันละครั้ง',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
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
        'Upgrade to %s' => 'อัพเกรดเป็น% s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => 'ไม่พบข้อมูล',
        'No notification method found.' => 'ไม่พบวิธีการแจ้งเตือน',
        'Notification Text' => 'ข้อความแจ้งเตือน',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'ภาษานี้ไม่ถูกเสนอหรือเปิดใช้งานในระบบ ข้อความแจ้งเตือนนี้อาจถูกลบออกหากไม่มีความจำเป็นอีกต่อไป',
        'Remove Notification Language' => 'ลบภาษาของการแจ้งเตือน',
        'Subject' => 'หัวข้อ',
        'Text' => 'ข้อความ',
        'Message body' => 'เนื้อหาของข้อความ',
        'Add new notification language' => 'เพิ่มภาษาใหม่ของการแจ้งเตือน',
        'Save Changes' => 'บันทึกการเปลี่ยนแปลง',
        'Tag Reference' => 'แท็กข้อมูลอ้างอิง',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => 'คุณสามารถใช้แท็กต่อไปนี้',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => 'ตัวอย่างเช่น',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => 'คุณลักษณะของผู้ใช้ผู้รับสำหรับการแจ้งเตือน',
        'Config options' => 'ตัวเลือกการกำหนดค่า',
        'Example notification' => 'ตัวอย่างการแจ้งเตือน',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'ที่อยู่อีเมลของผู้รับเพิ่มเติม',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'บทความที่จะถูกสร้างขึ้นหากการแจ้งเตือนถูกส่งให้กับลูกค้าหรือที่อยู่อีเมลเพิ่มเติม',
        'Email template' => 'แม่แบบของอีเมล์',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'ใช้รูปแบบนี้เพื่อสร้างอีเมลที่สมบูรณ์ (เฉพาะอีเมล HTML)',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminAttachment
        'Attachment Management' => 'การจัดการสิ่งที่แนบมา',
        'Add Attachment' => 'เพิ่มเอกสารแนบ',
        'Edit Attachment' => 'แก้ไขสิ่งที่แนบมา',
        'Filter for Attachments' => 'ตัวกรองสำหรับสิ่งที่แนบมา',
        'Filter for attachments' => '',
        'Filename' => 'ชื่อไฟล์',
        'Download file' => 'ดาวน์โหลดไฟล์',
        'Delete this attachment' => 'ลบสิ่งที่แนบมานี้',
        'Do you really want to delete this attachment?' => '',
        'Attachment' => 'สิ่งที่แนบมา',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'การจัดการการตอบสนองอัตโนมัติ',
        'Add Auto Response' => 'เพิ่มการตอบสนองอัตโนมัติ',
        'Edit Auto Response' => 'แก้ไขการตอบสนองอัตโนมัติ',
        'Filter for Auto Responses' => 'ตัวกรองสำหรับการตอบสนองอัตโนมัติ',
        'Filter for auto responses' => '',
        'Response' => 'ตอบสนอง',
        'Auto response from' => 'การตอบสนองอัตโนมัติจาก',
        'Reference' => 'อ้างอิง',
        'To get the first 20 character of the subject.' => 'เพื่อให้ได้20 ตัวอักษรแรกของเนื้อเรื่อง',
        'To get the first 5 lines of the email.' => 'เพื่อให้ได้5 บรรทัดแรกของอีเมล',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'เพื่อให้ได้คุณลักษณะของบทความ',
        'Options of the current customer user data' => 'ตัวเลือกของลูกค้าผู้ใช้ข้อมูลในปัจจุบัน',
        'Ticket owner options' => 'ตัวเลือกเจ้าของตั๋ว',
        'Ticket responsible options' => 'ตัวเลือกผู้รับผิดชอบตั๋ว',
        'Options of the current user who requested this action' => 'ตัวเลือกของผู้ใช้ปัจจุบันที่ร้องขอการกระทำนี้',
        'Options of the ticket data' => 'ตัวเลือกของข้อมูลของตั๋ว',
        'Options of ticket dynamic fields internal key values' => 'ตัวเลือกของช่องตั๋วแบบไดนามิกค่าคีย์ภายใน',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'ตัวเลือกของช่องตั๋วแบบไดนามิกที่แสดงค่าที่มีประโยชน์สำหรับDropdownและช่องสำหรับเลือกหลายรายการ',
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
        'Update' => 'อัปเดต',
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

        # Template: AdminCommunicationLog
        'Communication Log' => '',
        'Time Range' => '',
        'Show only communication logs created in specific time range.' =>
            '',
        'Filter for Communications' => '',
        'Filter for communications' => '',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '',
        'Status for: %s' => '',
        'Failing accounts' => '',
        'Some account problems' => '',
        'No account problems' => '',
        'No account activity' => '',
        'Number of accounts with problems: %s' => '',
        'Number of accounts with warnings: %s' => '',
        'Failing communications' => '',
        'No communication problems' => '',
        'No communication logs' => '',
        'Number of reported problems: %s' => '',
        'Open communications' => '',
        'No active communications' => '',
        'Number of open communications: %s' => '',
        'Average processing time' => '',
        'List of communications (%s)' => '',
        'Settings' => 'การตั้งค่า',
        'Entries per page' => '',
        'No communications found.' => '',
        '%s s' => '',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '',
        'Back to overview' => '',
        'Filter for Accounts' => '',
        'Filter for accounts' => '',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '',
        'Account status for: %s' => '',
        'Status' => 'สถานะ',
        'Account' => '',
        'Edit' => 'แก้ไข',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'ทิศทาง',
        'Start Time' => '',
        'End Time' => '',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'ลำดับความสำคัญ',
        'Module' => 'โมดูล',
        'Information' => 'ข้อมูล',
        'No log entries found.' => '',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '',
        'Filter for Log Entries' => '',
        'Filter for log entries' => '',
        'Show only entries with specific priority and higher:' => '',
        'Communication Log Overview (%s)' => '',
        'No communication objects found.' => '',
        'Communication Log Details' => '',
        'Please select an entry from the list.' => '',

        # Template: AdminCustomerCompany
        'Customer Management' => 'การจัดการลูกค้า',
        'Add Customer' => 'เพิ่มลูกค้า',
        'Edit Customer' => 'แก้ไขลูกค้า',
        'Search' => 'ค้นหา',
        'Wildcards like \'*\' are allowed.' => 'สัญลักษณ์เช่น \'*\' ได้รับอนุญาต',
        'Select' => 'เลือก',
        'List (only %s shown - more available)' => '',
        'total' => 'ผลรวม',
        'Please enter a search term to look for customers.' => 'กรุณากรอกคำค้นหาที่จะค้นหาลูกค้า',
        'Customer ID' => 'ไอดีลูกค้า',
        'Please note' => '',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'จัดการความสัมพันธ์กับกลุ่มลูกค้า',
        'Notice' => 'การแจ้งให้ทราบ',
        'This feature is disabled!' => 'ฟีเจอร์นี้จะถูกปิดใช้งาน!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'เพียงแค่ใช้ฟีเจอร์นี้ถ้าคุณต้องการที่จะกำหนดสิทธิ์ของกลุ่มสำหรับลูกค้า',
        'Enable it here!' => 'เปิดใช้งานได้ที่นี่!',
        'Edit Customer Default Groups' => 'แก้ไขกลุ่มลูกค้าเริ่มต้น',
        'These groups are automatically assigned to all customers.' => 'กลุ่มเหล่านี้จะถูกกำหนดอัตโนมัติไปยังลูกค้าทุกท่าน',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'ตัวกรองสำหรับกลุ่มต่างๆ',
        'Select the customer:group permissions.' => 'เลือกลูกค้า: สิทธิ์ของกลุ่ม',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'หากไม่มีอะไรถูกเลือกแล้วจะไม่มีสิทธิ์ในกลุ่มนี้ (ตั๋วจะไม่สามารถใช้ได้สำหรับลูกค้า)',
        'Search Results' => 'ผลการค้นหา',
        'Customers' => 'ลูกค้า',
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

        # Template: AdminCustomerUser
        'Customer User Management' => 'การจัดการลูกค้าผู้ใช้',
        'Add Customer User' => 'เพิ่มลูกค้าผู้ใช้',
        'Edit Customer User' => 'แก้ไขลูกค้าผู้ใช้',
        'Back to search results' => 'กลับไปยังผลการค้นหา',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'ลูกค้าผู้ใช้จำเป็นต้องมีประวัติลูกค้าและเข้าสู่ระบบผ่านทางแผงของลูกค้า',
        'List (%s total)' => '',
        'Username' => 'ชื่อผู้ใช้',
        'Email' => 'อีเมล์',
        'Last Login' => 'เข้าระบบครั้งสุดท้าย',
        'Login as' => 'เข้าระบบเป็น',
        'Switch to customer' => 'เปลี่ยนเป็นลูกค้า',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'ข้อมูลนี้จำเป็นและต้องป็นที่อยู่อีเมลที่ถูกต้อง',
        'This email address is not allowed due to the system configuration.' =>
            'อีเมลนี้จะไม่ได้รับอนุญาตเนื่องจากการกำหนดค่าระบบ',
        'This email address failed MX check.' => 'อีเมลนี้ล้มเหลวในการตรวจสอบ MX',
        'DNS problem, please check your configuration and the error log.' =>
            'ปัญหา DNS โปรดตรวจสอบการตั้งค่าและล็อกข้อผิดพลาดของคุณ',
        'The syntax of this email address is incorrect.' => 'รูปแบบของที่อยู่อีเมลนี้ไม่ถูกต้อง',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'ลูกค้า',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => 'ลูกค้าผู้ใช้',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'สลับสถานะการทำงานทั้งหมด',
        'Active' => 'ใช้งาน',
        'Toggle active state for %s' => 'สลับสถานะการทำงานสำหรับ %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'คุณสามารถจัดการกลุ่มคนเหล่านี้ผ่านการตั้งค่าการกำหนดรูปแบบ "CustomerGroupAlwaysGroups"',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'แก้ไขการบริการเริ่มต้น',
        'Filter for Services' => 'ตัวกรองสำหรับการบริการ',
        'Filter for services' => '',
        'Services' => 'การบริการ',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'การจัดการDynamic Fields ',
        'Add new field for object' => 'เพิ่มฟิลด์ใหม่สำหรับออบเจค',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'More Business Fields' => '',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '',
        'Database' => 'ฐานข้อมูล',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'Contact with data' => 'ติดต่อกับข้อมูล',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'ในการเพิ่มช่องข้อมูลใหม่ โปรดเลือกชนิดของช่องข้อมูลจากรายการของออบเจคและออบเจคจะกําหนดขอบเขตของช่องข้อมูลและมันไม่สามารถเปลี่ยนแปลงได้หลังจากการสร้างแล้ว',
        'Dynamic Fields List' => 'รายการไดมานิคฟิลด์',
        'Dynamic fields per page' => 'ไดมานิคฟิลด์แต่ละหน้า',
        'Label' => 'ฉลาก',
        'Order' => 'ลำดับ',
        'Object' => 'ออบเจค',
        'Delete this field' => 'ลบฟิลด์นี้',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'ไดมานิคฟิลด์',
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
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'ประเภทของฟิลด์',
        'Object type' => 'ประเภทของออบเจค',
        'Internal field' => 'ฟิลด์ภายใน',
        'This field is protected and can\'t be deleted.' => 'ข้อมูลนี้มีการป้องกันและไม่สามารถลบได้',
        'This dynamic field is used in the following config settings:' =>
            '',
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
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => 'ตัวอย่าง',
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
        'Admin Message' => '',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'ด้วยโมดูลนี้ผู้ดูแลระบบสามารถส่งข้อความไปยังตัวแทน กลุ่มหรือสมาชิกบทบาท',
        'Create Administrative Message' => 'สร้างข้อความการดูแลระบบ',
        'Your message was sent to' => 'ข้อความของคุณถูกส่งไปยัง',
        'From' => 'จาก',
        'Send message to users' => 'ส่งข้อความไปยังผู้ใช้',
        'Send message to group members' => 'ส่งข้อความไปยังสมาชิกในกลุ่ม',
        'Group members need to have permission' => 'สมาชิกในกลุ่มต้องได้รับอนุญาต',
        'Send message to role members' => 'ส่งข้อความไปยังสมาชิกบทบาท',
        'Also send to customers in groups' => 'และยังส่งให้กับลูกค้าในกลุ่ม',
        'Body' => 'เนื้อหา',
        'Send' => 'ส่ง',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'การทำงานที่ผ่านมา',
        'Run Now!' => 'รันตอนนี้!',
        'Delete this task' => 'ลบงานนี้',
        'Run this task' => 'รันงานนี้',
        'Job Settings' => 'การตั้งค่าการทำงาน',
        'Job name' => 'ชื่องาน',
        'The name you entered already exists.' => 'ชื่อที่คุณป้อนมีอยู่แล้ว',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => 'ตารางเวลาการดำเนินการ',
        'Schedule minutes' => 'ตารางนาที',
        'Schedule hours' => 'ตารางชั่วโมง',
        'Schedule days' => 'ตารางวัน',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'ขณะนี้เอเย่นต์งานงานทั่วไปจะไม่ทำงานโดยอัตโนมัติ',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'เพื่อเปิดใช้งานการดำเนินการแบบอัตโนมัติเลือกอย่างน้อยหนึ่งค่าจากนาทีชั่วโมงและวัน!',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'ตัวกระตุ้นกิจกรรม',
        'List of all configured events' => 'รายการของกิจกรรมที่มีการกำหนดค่าทั้งหมด',
        'Delete this event' => 'ลบอีเว้นท์นี้',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'นอกจากนี้หรืออีกทางเลือกหนึ่งเพื่อให้การดำเนินการเป็นระยะๆ คุณสามารถกำหนดตั๋วกิจกรรมที่จะส่งสัญญาณให้งานนี้',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'หากตั๋วกิจกรรมถูกยกเลิก ตัวกรองตั๋วจะถูกนำมาใช้เพื่อตรวจสอบว่าตรงกับตั๋ว แล้วงานจะรันบนตั๋วที่ว่า',
        'Do you really want to delete this event trigger?' => 'คุณต้องการลบตัวกระตุ้นกิจกรรมนี้หรือไม่?',
        'Add Event Trigger' => 'เพิ่มตัวกระตุ้นกิจกรรม',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'เลือกตั๋ว',
        '(e. g. 10*5155 or 105658*)' => '(เช่น 10*5155 หรือ 105658*)',
        '(e. g. 234321)' => '(เช่น  234321)',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(เช่น U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'ค้นหาแบบฉบับเต็มในบทความ (เช่น "Mar*in" หรือ "Baue*")',
        'To' => 'ถึง',
        'Cc' => 'Cc',
        'Service' => 'การบริการ',
        'Service Level Agreement' => 'ข้อตกลงระดับการให้บริการ',
        'Queue' => 'คิว',
        'State' => 'สถานภาพ',
        'Agent' => 'เอเย่นต์',
        'Owner' => 'เจ้าของ',
        'Responsible' => 'การตอบสนอง',
        'Ticket lock' => 'ตั๋วล็อค',
        'Dynamic fields' => 'ไดมานิคฟิลด์',
        'Add dynamic field' => '',
        'Create times' => 'เวลาที่สร้าง',
        'No create time settings.' => 'ไม่มีการตั้งค่าเวลาที่สร้าง',
        'Ticket created' => 'ตั๋วที่สร้างขึ้น',
        'Ticket created between' => 'ตั๋วถูกสร้างขึ้นระหว่าง',
        'and' => 'และ',
        'Last changed times' => 'เวลาการเปลี่ยนแปลงครั้งล่าสุด',
        'No last changed time settings.' => 'ไม่มีการตั้งค่าเวลาการเปลี่ยนแปลงครั้งล่าสุด',
        'Ticket last changed' => 'การเปลี่ยนแปลงตั๋วล่าสุด',
        'Ticket last changed between' => 'ตั๋วเปลี่ยนแปลงล่าสุดระหว่าง',
        'Change times' => 'เวลาที่เปลี่ยนแปลง',
        'No change time settings.' => 'ไม่มีการตั้งค่าเวลาการเปลี่ยนแปลง',
        'Ticket changed' => 'ตั๋วถูกเปลี่ยนแปลง',
        'Ticket changed between' => 'ตั๋วถูกเปลี่ยนแปลงระหว่าง',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
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
        'New customer user ID' => '',
        'New customer ID' => 'ไอดีลูกค้าใหม่',
        'New title' => 'หัวข้อใหม่',
        'New type' => 'ประเภทใหม่',
        'Archive selected tickets' => 'การเก็บถาวรของตั๋วที่ถูกเลือก',
        'Add Note' => 'เพิ่มโน้ต',
        'Visible for customer' => '',
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
        'Results' => 'ผลลัพธ์',
        '%s Tickets affected! What do you want to do?' => 'ตั๋ว s% ได้รับผลกระทบ! คุณต้องการจะทำอะไร?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'คำเตือน: คุณใช้ตัวเลือกลบ ตั๋วที่ถูกลบทั้งหมดจะหายไป!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'คำเตือน: มีตั๋ว% s ได้รับผลกระทบ แต่ s% เท่านั้นที่อาจมีการเปลี่ยนแปลงในระหว่างการดำเนินงานหนึ่ง!',
        'Affected Tickets' => 'ตั๋วที่ได้รับผลกระทบ',
        'Age' => 'อายุ',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'อินเตอร์เฟซทั่วไปของการจัดการ Web Service',
        'Web Service Management' => '',
        'Debugger' => 'การดีบัก',
        'Go back to web service' => 'กลับไปWeb Services',
        'Clear' => 'ล้าง',
        'Do you really want to clear the debug log of this web service?' =>
            'คุณต้องการที่จะยกเลิกการบันทึกของการแก้ปัญหาของweb serviceนี้หรือไม่?',
        'Request List' => 'ลิสต์การร้องขอ',
        'Time' => 'เวลา',
        'Communication ID' => '',
        'Remote IP' => 'รีโมท IP',
        'Loading' => 'กำลังโหลด',
        'Select a single request to see its details.' => 'เลือกคำขอเดียวเพื่อดูรายละเอียด',
        'Filter by type' => 'กรองตามประเภท',
        'Filter from' => 'กรองจากการ',
        'Filter to' => 'กรองเพื่อ',
        'Filter by remote IP' => 'กรองตามremote IP',
        'Limit' => 'ขีดจำกัด',
        'Refresh' => 'รีเฟรช',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'ข้อมูลการกำหนดค่าทั้งหมดจะหายไป',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'โปรดระบุชื่อที่ไม่ซ้ำกันสำหรับweb service นี้',
        'Error handling module backend' => '',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => '',
        'Configure filters to control error handling module execution.' =>
            '',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '',
        'Operation filter' => '',
        'Only execute error handling module for selected operations.' => '',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '',
        'Invoker filter' => '',
        'Only execute error handling module for selected invokers.' => '',
        'Error message content filter' => '',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => '',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '',
        'Error code' => '',
        'An error identifier for this error handling module.' => '',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => '',
        'An error explanation for this error handling module.' => '',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '',
        'Default behavior is to resume, processing the next module.' => '',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '',
        'Request retry options' => '',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '',
        'Schedule retry' => '',
        'Should requests causing an error be triggered again at a later time?' =>
            '',
        'Initial retry interval' => '',
        'Interval after which to trigger the first retry.' => '',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '',
        'Factor for further retries' => '',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '',
        'Maximum retry interval' => '',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '',
        'Maximum retry count' => '',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '',
        'This field must be empty or contain a positive number.' => '',
        'Maximum retry period' => '',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '',
        'Edit Invoker' => '',
        'Do you really want to delete this invoker?' => 'คุณต้องการลบผู้ร้องขอนี้หรือไม่?',
        'Invoker Details' => 'รายละเอียดของผู้ร้องขอ',
        'The name is typically used to call up an operation of a remote web service.' =>
            'โดยปกติจะใช้ชื่อนี้เพื่อเรียกการทำงานของweb serviceจากระยะไกล',
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
        'Condition' => 'เงื่อนไข ',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'ผู้ร้องขอนี้จะถูกกำหนดโดยกิจกรรมที่ถูกกำหนดไว้',
        'Add Event' => 'เพิ่มกิจกรรม',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'ในการเพิ่มกิจกรรมใหม่เลือกออปเจ็กต์กิจกรรมและชื่อกิจกรรมและคลิกที่ปุ่ม "+"',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'ตัวกระตุ้นกิจกรรมที่ไม่ตรงกันจะถูกจัดการโดย OTRS Scheduler Daemon ในเบื้องหลัง (แนะนำ)',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'ตัวกระต้นกิจกรรมที่ตรงกันจะถูกประมวลผลโดยตรงในระหว่างการร้องขอเว็บ',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'กลับไปยัง',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => 'เงื่อนไข ',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'ประเภทของการเชื่อมโยงระหว่างเงื่อนไขต่างๆ',
        'Remove this Condition' => 'ลบเงื่อนไขนี้',
        'Type of Linking' => 'ประเภทของการเชื่อมโยง',
        'Fields' => 'ฟิลด์',
        'Add a new Field' => 'เพิ่มฟิลด์ใหม่',
        'Remove this Field' => 'ลบฟิลด์นี้',
        'And can\'t be repeated on the same condition.' => 'และไม่สามารถทำซ้ำบนเงื่อนไขเดียวกัน',
        'Add New Condition' => 'เพิ่มเงื่อนไขใหม่',

        # Template: AdminGenericInterfaceMappingSimple
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

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => '',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => '',
        'Find' => '',
        'Find next' => '',
        'Find previous' => '',
        'Find and replace' => '',
        'Find and replace all' => '',
        'XSLT Mapping' => '',
        'XSLT stylesheet' => '',
        'The entered data is not a valid XSLT style sheet.' => '',
        'Here you can add or modify your XSLT mapping code.' => '',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => '',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => '',
        'Replace' => '',
        'Remove regex' => '',
        'Add regex' => '',
        'These filters can be used to transform keys using regular expressions.' =>
            '',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            '',
        'Perl regular expressions tutorial' => '',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '',
        'Edit Operation' => '',
        'Do you really want to delete this operation?' => 'คุณต้องการที่จะลบการดำเนินการนี้หรือไม่?',
        'Operation Details' => 'รายละเอียดการดำเนินงาน',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'โดยปกติจะใช้ชื่อนี้เพื่อเรียกการทำงานของweb serviceนี้จากระยะไกล',
        'Operation backend' => 'การดำเนินงานเบื้องหลัง',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'โมดูลผู้ร้องขอเบื้องหลังของOTRSนี้จะถูกเรียกจากภายในเพื่อเพื่อดำเนินการตามคำขอและสร้างข้อมูลสำหรับการตอบสนอง',
        'Mapping for incoming request data' => 'แผนที่สำหรับข้อมูลการร้องขอขาเข้า',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'ข้อมูลการร้องขอจะถูกประมวลผลโดยแผนที่นี้เพื่อเปลี่ยนมันไปเป็นข้อมูลตามการคาดการของ OTRS',
        'Mapping for outgoing response data' => 'แผนที่สำหรับข้อมูลการตอบสนองที่ส่งออก',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'ข้อมูลการตอบสนองจะถูกประมวลผลโดยแผนที่นี้เพื่อเปลี่ยนมันไปเป็นข้อมูลการคาดการของระบบระยะไกล',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
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
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'จุดสิ้นสุด',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'เช่น https://www.otrs.com:10745/api/v1.0 (โดยไม่ต้องต่อท้ายด้วยเครื่องหมาย backslash)',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'การรับรองความถูกต้อง',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'ชื่อผู้ใช้ที่จะใช้ในการเข้าถึงระบบรีโมต',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'รหัสผ่านสำหรับผู้ใช้ที่ได้รับสิทธิพิเศษ',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'เซิร์ฟเวอร์สำรอง',
        'URI of a proxy server to be used (if needed).' => 'URI ของเซิร์ฟเวอร์สำรองที่จะใช้ (ถ้าจำเป็น)',
        'e.g. http://proxy_hostname:8080' => 'เช่น. http: // proxy_hostname: 8080',
        'Proxy User' => 'ผู้ใช้สำรอง',
        'The user name to be used to access the proxy server.' => 'ชื่อผู้ใช้ที่จะใช้ในการเข้าถึงเซิร์ฟเวอร์สำรอง',
        'Proxy Password' => 'รหัสผ่านสำรอง',
        'The password for the proxy user.' => 'รหัสผ่านสำหรับตัวแทนผู้ใช้งาน',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'ใช้ตัวเลือก SSL',
        'Show or hide SSL options to connect to the remote system.' => 'แสดงหรือซ่อนตัวเลือก SSL เพื่อเชื่อมต่อกับระบบรีโมต',
        'Client Certificate' => '',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => '',
        'Client Certificate Key' => '',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => '',
        'Client Certificate Key Password' => '',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'เส้นทางแบบเต็มและชื่อของผู้มีอำนาจในการรับรองไฟล์ใบรับรองเพื่อตรวจใบรับรอง SSL',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'เช่น /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'สารบบผู้ออกใบรับรอง (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'เส้นทางแบบเต็มของไดเรกทอรีผู้มีสิทธิ์ออกใบรับรองซึ่งใบรับรองCAจะถูกเก็บไว้ในระบบไฟล์',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'เช่น /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => 'ตัวควบคุมการทำแผนที่สำหรับผู้ร้องขอ',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'ตัวควบคุมที่ผู้ร้องขอควรส่งการร้องขอไป ตัวแปรถูกทำเครื่องหมายด้วย \':\' จะได้รับการแทนที่ด้วยค่าข้อมูลและผ่านไปตามคำขอต่อไป (เช่น / ตั๋ว /: TicketID UserLogin =: UserLogin&Password =: รหัสผ่าน)',
        'Valid request command for Invoker' => 'คำสั่งคำขอที่ถูกต้องสำหรับผู้ร้องขอ',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'คำสั่ง HTTP ที่เฉพาะเจาะจงที่จะใช้สำหรับการร้องขอด้วย Invoker นี้ (ถ้ามี)',
        'Default command' => 'คำสั่งเริ่มต้น',
        'The default HTTP command to use for the requests.' => 'คำสั่ง HTTP เริ่มต้นที่จะใช้สำหรับการร้องขอ',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '',
        'Set SOAPAction' => '',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => '',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'ตัวคั่น SOAPAction',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
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
        'Sort options' => 'ตัวเลือกการจัดเรียง',
        'Add new first level element' => 'เพิ่มองค์ประกอบขั้นแรกใหม่',
        'Element' => 'องค์ประกอบ',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'ลำดับการจัดเรียงขาออกสำหรับฟิลด์ XML (เริ่มต้นโครงสร้างข้างล่างฟังก์ชั่นการห่อหุ้ม) - ดูเอกสารสำหรับการขนส่งSOAP',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => 'ชื่อต้องไม่ซ้ำกัน.',
        'Clone' => 'โคลนนิ่ง',
        'Export Web Service' => '',
        'Import web service' => 'นำเข้า web service',
        'Configuration File' => 'ไฟล์การกำหนดค่า',
        'The file must be a valid web service configuration YAML file.' =>
            'ไฟล์ดังกล่าวจะต้องเป็นไฟล์การกำหนดค่าYAML web serviceที่ถูกต้อง',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'นำเข้า',
        'Configuration History' => '',
        'Delete web service' => 'ลบ web service',
        'Do you really want to delete this web service?' => 'คุณต้องการลบweb serviceนี้หรือไม่?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'หลังจากที่คุณบันทึกการตั้งค่าคุณจะถูกเปลี่ยนเส้นทางไปยังหน้าจอการแก้ไขอีกครั้ง',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'ถ้าคุณต้องการที่จะกลับไปที่ภาพรวมโปรดคลิกที่ปุ่ม "ไปที่ภาพรวม"',
        'Remote system' => 'ระบบระยะไกล',
        'Provider transport' => 'ขนส่งผู้ให้บริการ',
        'Requester transport' => 'การขนส่งผู้ร้องขอ',
        'Debug threshold' => 'เกณฑ์การแก้ปัญหา',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'ในโหมดผู้ให้บริการ OTRS เสนอบริการเว็บที่ใช้โดยระบบทางไกล',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'ในโหมดการร้องขอ, OTRSใช้บริการเว็บของระบบทางไกล',
        'Network transport' => 'เครือข่ายการขนส่ง',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
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

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'ประวัติ',
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

        # Template: AdminGroup
        'Group Management' => 'การจัดการกลุ่ม',
        'Add Group' => 'เพิ่มกลุ่ม',
        'Edit Group' => 'แก้ไขกลุ่ม',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'กลุ่มผู้ดูแลระบบจะได้รับการเข้าไปในพื้นที่ของแอดมินและกลุ่มสถิติจะได้รับพื้นที่สถิติ',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'สร้างกลุ่มใหม่เพื่อจัดการสิทธิ์การเข้าถึงสำหรับกลุ่มที่แตกต่างกันของเอเย่นต์ (เช่นฝ่ายจัดซื้อ, ฝ่ายสนับสนุนฝ่ายขาย, ... )',
        'It\'s useful for ASP solutions. ' => 'ซึ่งจะมีประโยชน์สำหรับการแก้ปัญหา ASP',

        # Template: AdminLog
        'System Log' => 'ระบบ Log',
        'Here you will find log information about your system.' => 'คุณจะพบข้อมูลเกี่ยวกับการเข้าสู่ระบบในระบบของคุณที่นี่',
        'Hide this message' => 'ซ่อนข้อความนี้',
        'Recent Log Entries' => 'รายการการเข้าสู่ระบบล่าสุด',
        'Facility' => 'สิ่งอำนวยความสะดวก',
        'Message' => 'ข้อความ',

        # Template: AdminMailAccount
        'Mail Account Management' => 'การจัดการบัญชีเมล',
        'Add Mail Account' => 'เพิ่มบัญชีอีเมล',
        'Edit Mail Account for host' => '',
        'and user account' => '',
        'Filter for Mail Accounts' => '',
        'Filter for mail accounts' => '',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => '',
        'Host' => 'โฮสต์',
        'Delete account' => 'ลบบัญชี',
        'Fetch mail' => 'การดึงข้อมูลอีเมล',
        'Do you really want to delete this mail account?' => '',
        'Password' => 'รหัสผ่าน',
        'Example: mail.example.com' => 'ตัวอย่าง: mail.example.com',
        'IMAP Folder' => 'โฟลเดอร์ IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'ปรับเปลี่ยนแค่นี้ถ้าคุณต้องการที่จะดึงอีเมลจากโฟลเดอร์ที่แตกต่างจากINBOX',
        'Trusted' => 'ที่น่าเชื่อถือ',
        'Dispatching' => 'ส่งออกไปยังปลายทาง',
        'Edit Mail Account' => 'แก้ไขบัญชีเมล',

        # Template: AdminNavigationBar
        'Administration Overview' => '',
        'Filter for Items' => '',
        'Filter' => 'ตัวกรอง',
        'Favorites' => '',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => '',
        'View the admin manual on Github' => '',
        'No Matches' => '',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'การจัดการการแจ้งเตือนตั๋ว',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'คุณสามารถอัปโหลดไฟล์การกำหนดค่าที่จะนำการแจ้งเตือนตั๋วเข้าสู่ระบบของคุณที่นี่และไฟล์ต้องอยู่ในรูปแบบ .ymlขณะที่ส่งออกโดยโมดูลการแจ้งเตือนตั๋ว',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'คุณสามารถเลือกกิจกรรมที่จะกระตุ้นประกาศนี้ที่นี่ ตัวกรองตั๋วเพิ่มเติมสามารถนำมาใช้เพียงเพื่อส่งค่าตั๋วกับเกณฑ์ที่แน่นอน',
        'Ticket Filter' => 'ตัวกรองตั๋ว',
        'Lock' => 'ล็อค',
        'SLA' => 'SLA',
        'Customer User ID' => '',
        'Article Filter' => 'ตัวกรองบทความ',
        'Only for ArticleCreate and ArticleSend event' => 'เฉพาะ ArticleCreate และกิจกรรม ArticleSend',
        'Article sender type' => 'ประเภทผู้ส่งบทความ',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'หาก ArticleCreate หรือ ArticleSend ใช้เป็นตัวกรุตุ้นกิจกรรมคุณจะต้องระบุตัวกรองบทความเช่นกัน โปรดเลือกอย่างน้อยหนึ่งฟิลด์ตัวกรองบทความ',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'แนบเอกสารไปยังการแจ้งเตือน',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'แจ้งให้ผู้ใช้เพียงครั้งเดียวต่อวันเกี่ยวกับตั๋วเพียงใบเดียวโดยใช้การขนส่งที่คุณเลือก',
        'This field is required and must have less than 4000 characters.' =>
            '',
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
        'Attributes of the ticket data' => 'คุณลักษณะของข้อมูลตั๋ว',
        'Ticket dynamic fields internal key values' => 'ค่าคีย์ภายในช่องตั๋วแบบไดนามิก',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'ช่องตั๋วแบบไดนามิกแสดงค่าที่มีประโยชน์สำหรับDropdownและช่องสำหรับเลือกหลายรายการ',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'จัดการ% s',
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
        'An update for your %s is available! Please update at your earliest!' =>
            'การอัปเดตสำหรับ% s ของคุณพร้อมใช้งาน โปรดอัปเดตโดยเร็วที่สุด!',
        '%s Correctly Deployed' => '%s ถูกนำไปใช้อย่างถูกต้อง',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'ขอแสดงความยินดี %s ของคุณมีการติดตั้งอย่างถูกต้องและเป็นเวอร์ชั่นล่าสุด',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => '',
        '%s will be available soon. Please check again in a few days.' =>
            '%s จะสามารถใช้ได้ในเร็ว ๆ นี้ กรุณาตรวจสอบอีกครั้งภายในไม่กี่วันนี้',
        'Please have a look at %s for more information.' => 'โปรดดูได้ที่ %s สำหรับข้อมูลเพิ่มเติม',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'ก่อนที่คุณจะสามารถได้รับประโยชน์จาก %s กรุณาติดต่อ %s เพื่อรับสัญญาของคุณ %s',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'การเชื่อมต่อกับ cloud.otrs.com ผ่าน HTTPS ไม่สามารถยืนยันได โปรดตรวจสอบว่า OTRSของคุณคุณสามารถเชื่อมต่อกับ cloud.otrs.com ผ่านทางพอร์ต443',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => '',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
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
        'Add PGP Key' => 'เพิ่มคีย์ PGP',
        'PGP support is disabled' => 'การสนับสนุน PGP จะถูกปิดใช้งาน',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'เพื่อให้สามารถใช้ PGP ใน OTRS คุณต้องเปิดการใช้งานก่อน',
        'Enable PGP support' => 'เปิดใช้การสนับสนุน PGP',
        'Faulty PGP configuration' => 'การกำหนดค่า PGP ผิดพลาด',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'เปิดใช้งานการสนับสนุน PGP แล้วแต่การกำหนดค่าที่เกี่ยวข้องมีข้อผิดพลาด กรุณาตรวจสอบการตั้งค่าโดยใช้ปุ่มด้านล่าง',
        'Configure it here!' => 'กำหนดค่าได้ที่นี่!',
        'Check PGP configuration' => 'ตรวจสอบการตั้งค่า PHP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'ด้วยวิธีนี้คุณสามารถแก้ไขการคีย์การกำหนดค่าใน sysconfigได้โดยตรง',
        'Introduction to PGP' => 'ข้อมูลเบื้องต้นเกี่ยวกับ PGP',
        'Identifier' => 'ตัวบ่งชี้',
        'Bit' => 'บิต',
        'Fingerprint' => 'ลายนิ้วมือ',
        'Expires' => 'หมดอายุ',
        'Delete this key' => 'ลบคีย์นี้',
        'PGP key' => 'คีย์ PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'ตัวจัดการแพคเกจ',
        'Uninstall Package' => '',
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
        'Install Package' => 'ติดตั้งแพคเกจ',
        'Update Package' => '',
        'Continue' => 'ดำเนินการต่อ',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'กรุณาตรวจสอบให้แน่ใจว่าฐานข้อมูลของคุณรับขนาดแพคเกจมากกว่า %s MB  (ขณะนี้สามารถยอมรับเฉพาะแพคเกจที่มีขนาดถึง %s MB) กรุณาปรับตั้งค่า max_allowed_packet ของฐานข้อมูลของคุณเพื่อหลีกเลี่ยงข้อผิดพลาด',
        'Install' => 'ติดตั้ง',
        'Update repository information' => 'อัปเดตข้อมูลของพื้นที่เก็บข้อมูล',
        'Cloud services are currently disabled.' => 'บริการคลาวด์ถูกปิดการใช้งานในขณะนี้',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™ ไม่สามารถดำเนินการต่อไป!',
        'Enable cloud services' => 'เปิดใช้บริการคลาวด์',
        'Update all installed packages' => '',
        'Online Repository' => 'พื้นที่เก็บข้อมูลออนไลน์',
        'Action' => 'การดำเนินการ',
        'Module documentation' => 'เอกสารของโมดูล',
        'Local Repository' => 'พื้นที่เก็บข้อมูลท้องถิ่น',
        'This package is verified by OTRSverify (tm)' => 'แพคเกจนี้ถูกตรวจสอบโดยOTRSverify (tm)',
        'Uninstall' => 'ยกเลิกการติดตั้ง',
        'Package not correctly deployed! Please reinstall the package.' =>
            'ไม่สามารถใช้งานแพคเกจได้อย่างถูกต้อง! กรุณาติดตั้งแพคเกจ',
        'Reinstall' => 'ติดตั้งใหม่',
        'Features for %s customers only' => 'ฟีเจอร์สำหรับลูกค้า% เท่านั้น',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'ด้วย %s คุณสามารถได้รับประโยชน์จากคุณสมบัติเสริมต่อไปนี้ กรุณาติดต่อกับ% s ถ้าคุณต้องการข้อมูลเพิ่มเติม',
        'Package Information' => '',
        'Download package' => 'ดาวน์โหลดแพคเกจ',
        'Rebuild package' => 'สร้างแพคเกจอีกครั้ง',
        'Metadata' => 'ข้อมูลเมต้า',
        'Change Log' => 'เปลี่ยนแปลงการเข้าสู่ระบบ',
        'Date' => 'วัน',
        'List of Files' => 'รายการไฟล์',
        'Permission' => 'การอนุญาต',
        'Download file from package!' => 'ดาวน์โหลดไฟล์จากแพคเกจ',
        'Required' => 'ที่จำเป็น',
        'Size' => 'ขนาด',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'ความแตกต่างของไฟล์สำหรับไฟล์ %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'การเข้าสู่ระบบการปฏิบัติงาน',
        'Range' => 'ช่วง',
        'last' => 'ล่าสุด',
        'This feature is enabled!' => 'ฟีเจอร์ได้เปิดใช้งาน!',
        'Just use this feature if you want to log each request.' => 'เพียงใช้ฟีเจอร์นี้ถ้าคุณต้องการที่จะบันทึกคำขอแต่ละคำขอ',
        'Activating this feature might affect your system performance!' =>
            'การเปิดใช้งานคุณสมบัตินี้อาจส่งผลกระทบต่อประสิทธิภาพการทำงานของระบบของคุณ!',
        'Disable it here!' => 'ปิดการใช้งานได้ที่นี่!',
        'Logfile too large!' => 'logfile มีขนาดใหญ่เกินไป!',
        'The logfile is too large, you need to reset it' => 'logfile มีขนาดใหญ่เกินไป! คุณจำเป็นต้องรีเซ็ตมัน',
        'Reset' => 'รีเซ็ต',
        'Overview' => 'ภาพรวม',
        'Interface' => 'อินเตอร์เฟซ',
        'Requests' => 'การร้องขอ',
        'Min Response' => 'การตอบสนองขั้นต่ำ',
        'Max Response' => 'การตอบสนองสูงสุด',
        'Average Response' => 'การตอบสนองโดยเฉลี่ย',
        'Period' => 'ระยะเวลา',
        'minutes' => 'นาที',
        'Min' => 'นาที',
        'Max' => 'สูงสุด',
        'Average' => 'ค่าเฉลี่ย',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'การจัดการตัวกรองPostmaster',
        'Add PostMaster Filter' => 'เพิ่มตัวกรอง PostMaster',
        'Edit PostMaster Filter' => 'แก้ไขตัวกรอง PostMaster',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'เพื่อส่งหรือกรองอีเมลขาเข้าขึ้นอยู่กับหัวข้อของอีเมล นอกจากนี้ยังสามารถจับคู่โดยใช้นิพจน์ปกติ',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'ถ้าคุณต้องการเพียงเพื่อให้ที่อยู่อีเมลตรงกัน โปรดใช้ EMAILADDRESS: info@example.com ใน
จาก ถึงหรือสำเนา',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'ถ้าคุณใช้นิพจน์ปกติคุณก็ยังสามารถใช้ค่าจับคู่ใน () เป็น [***] ในการดำเนินการ \'ตั้งค่า\'',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'ลบตัวกรองนี้',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'เงื่อนไขตัวกรอง',
        'AND Condition' => 'เงื่อนไข AND',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'ฟิลด์จะต้องเป็นนิพจน์ทั่วไปที่ถูกต้องหรือเป็นตัวอักษรที่มีความหมาย',
        'Negate' => 'ปฏิเสธ',
        'Set Email Headers' => 'กำหนดหัวข้ออีเมล์',
        'Set email header' => 'กำหนดหัวข้ออีเมล์',
        'with value' => '',
        'The field needs to be a literal word.' => 'ฟิลด์จะต้องเป็นตัวอักษรที่มีความหมาย',
        'Header' => 'หัวข้อ',

        # Template: AdminPriority
        'Priority Management' => 'การบริหารจัดการลำดับความสำคัญ',
        'Add Priority' => 'เพิ่มลำดับความสำคัญ',
        'Edit Priority' => 'แก้ไขลำดับความสำคัญ',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'กระบวนการจัดการ',
        'Filter for Processes' => 'ตัวกรองสำหรับกระบวนการต่างๆ',
        'Filter for processes' => '',
        'Create New Process' => 'สร้างการประมวลผลใหม่',
        'Deploy All Processes' => 'ปรับใช้กระบวนการทั้งหมด',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'คุณสามารถอัปโหลดไฟล์การกำหนดค่าที่จะนำเข้าสู่กระบวนการในระบบของคุณที่นี่และไฟล์ต้องอยู่ในรูปแบบ .ymlขณะที่ส่งออกโดยโมดูลการจัดการกระบวนการ ',
        'Upload process configuration' => 'อัปโหลดการกำหนดค่าขั้นตอนต่างๆ',
        'Import process configuration' => 'นำเข้าการกำหนดค่าขั้นตอน',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => '',
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
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'คุณสามารถกำหนดฟิลด์ไปยังกิจกรรมไดอะล็อกนี้โดยการลากองค์ประกอบด้วยเมาส์จากรายการด้านซ้ายไปยังรายการด้านขวา',
        'Filter available fields' => 'ตัวกรองฟิลด์ที่สามารถใช้ได้',
        'Available Fields' => 'ฟิลด์ที่สามารถใช้ได้',
        'Assigned Fields' => 'ฟิลด์ที่ได้รับมอบหมาย',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => 'แสดง',

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
        'Transitions are not being used in this process.' => 'การเปลี่ยนผ่านจะไม่ถูกนำมาใช้ในกระบวนการนี้',
        'Module name' => 'ชื่อโมดูล',
        'Transition actions are not being used in this process.' => 'การดำเนินการเปลี่ยนผ่านจะไม่ถูกนำมาใช้ในกระบวนการนี้',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'หมายเหตุ การเปลี่ยนการเปลี่ยนผ่านนี้จะมีผลต่อกระบวนการถัดไป',
        'Transition' => 'การเปลี่ยนผ่าน',
        'Transition Name' => 'ชื่อการเปลี่ยนผ่าน',

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
        'Queue Management' => '',
        'Add Queue' => 'เพิ่มคิว',
        'Edit Queue' => 'แก้ไขคิว',
        'Filter for Queues' => 'ตัวกรองสำหรับคิว',
        'Filter for queues' => '',
        'A queue with this name already exists!' => 'คิวที่ใช้ชื่อนี้มีอยู่แล้ว!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'คิวย่อยของ',
        'Unlock timeout' => 'หมดเวลาการปลดล็อค',
        '0 = no unlock' => '0 = ไม่มีการปลดล็อค',
        'hours' => 'ชั่วโมง',
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
        'Salutation' => 'คำขึ้นต้น',
        'The salutation for email answers.' => 'คำขึ้นต้นจดหมายสำหรับอีเมลคำตอบ',
        'Signature' => 'ลายเซ็น',
        'The signature for email answers.' => 'ลายเซ็นสำหรับอีเมลคำตอบ',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'จัดการความสัมพันธ์การตอบสนองคิวอัตโนมัติ',
        'Change Auto Response Relations for Queue' => 'เปลี่ยนความสัมพันธ์ระหว่างการตอบสนองอัตโนมัติสำหรับคิว',
        'This filter allow you to show queues without auto responses' => 'ตัวกรองนี้จะจะอนุญาตให้คุณแสดงคิวได้โดยไม่ต้องตอบสนองอัตโนมัติ',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => 'ตัวกรองนี้จะจะอนุญาตให้คุณแสดงคิวทั้งหมดได้',
        'Show All Queues' => '',
        'Auto Responses' => 'การตอบสนองอัตโนมัติ',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'จัดการความสัมพันธ์ของแม่แบบคิว',
        'Filter for Templates' => 'ตัวกรองสำหรับแม่แบบ',
        'Filter for templates' => '',
        'Templates' => 'รูปแบบ',

        # Template: AdminRegistration
        'System Registration Management' => 'การจัดการระบบการลงทะเบียน',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTRS-ID' => '',
        'Deregister System' => 'ระบบการยกเลิกการลงทะเบียน',
        'Edit details' => 'แก้ไขรายละเอียด',
        'Show transmitted data' => 'แสดงข้อมูลที่ส่ง',
        'Deregister system' => 'ยกเลิกการลงทะเบียนระบบ',
        'Overview of registered systems' => 'ภาพรวมของระบบการลงทะเบียน',
        'This system is registered with OTRS Group.' => 'ระบบนี้มีการลงทะเบียนกับกลุ่ม OTRS',
        'System type' => 'ชนิดของระบบ',
        'Unique ID' => 'ID ที่ไม่ซ้ำกัน',
        'Last communication with registration server' => 'การสื่อสารกับเซิร์ฟเวอร์การลงทะเบียนครั้งล่าสุด',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'โปรดทราบว่าคุณไม่สามารถลงทะเบียนระบบของคุณ ถ้าหาก OTRS Daemon ทำงานไม่ถูกต้อง!',
        'Instructions' => 'คำแนะนำ',
        'System Deregistration not Possible' => '',
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
        'If you deregister your system, you will lose these benefits:' =>
            'ถ้าคุณยกเลิกการลงทะเบียนระบบของคุณ คุณจะสูญเสียผลประโยชน์เหล่านี้:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'คุณจำเป็นต้องเข้าสู่ระบบด้วย ID OTRSเพื่อยกเลิกการลงทะเบียนระบบของคุณ',
        'OTRS-ID' => 'ID OTRS',
        'You don\'t have an OTRS-ID yet?' => 'คุณยังไม่มีID OTRS ใช่หรือไม่?',
        'Sign up now' => 'สมัครตอนนี้เลย',
        'Forgot your password?' => 'ลืมรหัสผ่าน?',
        'Retrieve a new one' => 'ดึงข้อมูลขึ้นมาใหม่',
        'Next' => 'ถัดไป',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'ข้อมูลนี้จะถูกโอนไปยังกลุ่มOTRS บ่อยครั้งเมื่อคุณลงทะเบียนระบบนี้',
        'Attribute' => 'แอตทริบิวต์',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'เวอร์ชั่นของ OTRS',
        'Operating System' => 'ระบบปฏิบัติการ',
        'Perl Version' => 'เวอร์ชั่นของ Perl',
        'Optional description of this system.' => 'ตัวเลือกคำอธิบายของระบบนี้',
        'Register' => 'ลงทะเบียน',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'ดำเนินการต่อด้วยขั้นตอนนี้จะยกเลิกการลงทะเบียนระบบจากกลุ่มOTRS',
        'Deregister' => 'ยกเลิกการลงทะเบียน',
        'You can modify registration settings here.' => 'คุณสามารถแก้ไขการตั้งค่าการลงทะเบียนที่นี่',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => 'ไม่มีข้อมูลที่ส่งเป็นประจำจากระบบของคุณไปยัง % s',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'ข้อมูลต่อไปนี้จะถูกส่งอย่างน้อยทุกๆ 3 วันจากระบบของคุณไปยัง % s',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'ข้อมูลจะถูกโอนในรูปแบบ JSON ผ่านการเชื่อมต่อ https ที่ปลอดภัย ',
        'System Registration Data' => 'ข้อมูลการลงทะเบียนระบบ',
        'Support Data' => 'ข้อมูลการสนับสนุน',

        # Template: AdminRole
        'Role Management' => 'การจัดการบทบาท',
        'Add Role' => 'เพิ่มบทบาท',
        'Edit Role' => 'แก้ไขบทบาท',
        'Filter for Roles' => 'ตัวกรองสำหรับบทบาท',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'สร้างบทบาทและใส่ในกลุ่มนั้น แล้วเพิ่มบทบาทให้กับผู้ใช้',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'ไม่มีบทบาทที่กำหนดไว้ กรุณาใช้ปุ่ม \'เพิ่ม\' เพื่อสร้างบทบาทใหม่',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'จัดการความสัมพันธ์ของกลุ่มบทบาท',
        'Roles' => 'บทบาท',
        'Select the role:group permissions.' => 'เลือกบทบาท: สิทธิ์ของกลุ่ม',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'หากไม่มีอะไรถูกเลือกแล้วจะไม่มีสิทธิ์ในกลุ่มนี้ (ตั๋วจะไม่สามารถใช้ได้สำหรับบทบาท)',
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
        'Add Agent' => 'เพิ่มเอเย่นต์',
        'Filter for Agents' => 'ตัวกรองสำหรับเอเย่นต์',
        'Filter for agents' => '',
        'Agents' => 'เอเย่นต์',
        'Manage Role-Agent Relations' => 'จัดการความสัมพันธ์ของเอเย่นต์บทบาท',

        # Template: AdminSLA
        'SLA Management' => 'การจัดการ SLA ',
        'Edit SLA' => 'แก้ไข SLA ',
        'Add SLA' => 'เพิ่ม SLA ',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'กรุณาเขียนตัวเลขเท่านั้น!',

        # Template: AdminSMIME
        'S/MIME Management' => 'การจัดการ S/MIME',
        'Add Certificate' => 'เพิ่มใบรับรอง',
        'Add Private Key' => 'เพิ่มคีย์ส่วนตัว',
        'SMIME support is disabled' => 'การสนับสนุน SMIME จะถูกปิดใช้งาน',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'เพื่อให้สามารถใช้ SMIME ใน OTRS คุณต้องเปิดการใช้งานก่อน',
        'Enable SMIME support' => 'เปิดใช้งานการสนับสนุน SMIME',
        'Faulty SMIME configuration' => 'การกำหนดค่า SMIME ผิดพลาด',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'เปิดใช้งานการสนับสนุน SMIME แล้วแต่การกำหนดค่าที่เกี่ยวข้องมีข้อผิดพลาด กรุณาตรวจสอบการตั้งค่าโดยใช้ปุ่มด้านล่าง',
        'Check SMIME configuration' => 'ตรวจสอบการกำหนดค่า SMIME',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'ตัวกรองสำหรับใบรับรอง',
        'To show certificate details click on a certificate icon.' => 'หากต้องการแสดงรายละเอียดใบรับรองคลิกที่ไอคอนใบรับรอง',
        'To manage private certificate relations click on a private key icon.' =>
            'ในการจัดการความสัมพันธ์ใบรับรองส่วนตัวคลิกที่ไอคอนรูปกุญแจส่วนตัว',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'คุณสามารถเพิ่มความสัมพันธ์ไปยังใบรับรองส่วนตัวของคุณที่นี่ สิ่งเหล่านี้จะติดอยู่กับลายเซ็นของ S/ MIME ทุกครั้งที่ใช้ใบรับรองนี้เพื่อเข้าสู่ระบบอีเมล',
        'See also' => 'ดูเพิ่มเติม',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'ด้วยวิธีนี้คุณสามารถแก้ไขการรับรองและคีย์ส่วนตัวในระบบแฟ้มได้โดยตรง',
        'Hash' => 'การแฮช',
        'Create' => 'สร้าง',
        'Handle related certificates' => 'จัดการใบรับรองที่เกี่ยวข้อง',
        'Read certificate' => 'อ่านใบรับรอง',
        'Delete this certificate' => 'ลบใบรับรองนี้',
        'File' => 'ไฟล์',
        'Secret' => 'ความลับ',
        'Related Certificates for' => 'ใบรับรองที่เกี่ยวข้องสำหรับ',
        'Delete this relation' => 'ลบความสัมพันธ์นี้',
        'Available Certificates' => 'ใบรับรองที่พร้อมใช้งาน',
        'Filter for S/MIME certs' => 'ตัวกรองสำหรับใบรับรอง S / MIME',
        'Relate this certificate' => 'เกี่ยวข้องกับใบรับรองนี้',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'ใบรับรอง S/MIME',
        'Close this dialog' => 'ปิดไดอะล็อกนี้',
        'Certificate Details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'การจัดการคำขึ้นต้น',
        'Add Salutation' => 'เพิ่มคำขึ้นต้น',
        'Edit Salutation' => 'แก้ไขคำขึ้นต้น',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'ตัวอย่างเช่น',
        'Example salutation' => 'ตัวอย่างคำขึ้นต้น',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'โหมดการรักษาความปลอดภัยจะ (ปกติ)มีการตั้งค่าหลังจากที่ติดตั้งระบบเป็นที่เรียบร้อยแล้ว',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'ถ้าโหมดรักษาปลอดภัยไม่ได้เปิดใช้งาน สามารถเปิดใช้งานได้ผ่านทาง sysconfig เพราะแอพลีเคชั่นของคุณกำลังทำงานอยู่',

        # Template: AdminSelectBox
        'SQL Box' => 'กล่องSQL ',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'คุณสามารถใส่ SQL เพื่อส่งไปยังฐานข้อมูลแอพลิเคชันโดยตรงได้ที่นี่ มันไม่ได้เป็นไปได้ที่จะเปลี่ยนเนื้อหาของตารางและเลือกคำสั่งที่ได้รับอนุญาตเท่านั้น',
        'Here you can enter SQL to send it directly to the application database.' =>
            'คุณสามารถใส่ SQL เพื่อส่งไปยังฐานข้อมูลแอพลิเคชันโดยตรงได้ที่นี่',
        'Options' => 'ตัวเลือก',
        'Only select queries are allowed.' => 'เลือกเฉพาะคำสั่งที่ได้รับอนุญาต',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'ไวยากรณ์ของคำสั่ง SQL ของคุณมีความผิดพลา กรุณาตรวจสอบ',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'มีอย่างน้อยหนึ่งพารามิเตอร์ที่ขาดหายไปสำหรับผลผูกพัน กรุณาตรวจสอบ',
        'Result format' => 'รูปแบบผลลัพท์',
        'Run Query' => 'รันคำสั่ง',
        '%s Results' => '',
        'Query is executed.' => 'คำสั่งถูกดำเนินการ',

        # Template: AdminService
        'Service Management' => 'การจัดการบริการ',
        'Add Service' => 'เพิ่มการบริการ',
        'Edit Service' => 'แก้ไขการบริการ',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'การบริการย่อยของ',

        # Template: AdminSession
        'Session Management' => 'การจัดการเซสชั่น',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'เซสชันทั้งหมด',
        'Agent sessions' => 'เซสชันเอเย่นต์',
        'Customer sessions' => 'เซสชันลูกค้า',
        'Unique agents' => 'เอเย่นต์ที่ไม่ซ้ำกัน',
        'Unique customers' => 'ลูกค้าที่ไม่ซ้ำกัน',
        'Kill all sessions' => 'ทำลายทุกกลุ่ม',
        'Kill this session' => 'ทำลายกลุ่มนี้',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'เซสชัน',
        'User' => 'ผู้ใช้',
        'Kill' => 'ทำลาย',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'การจัดการลายเซ็น',
        'Add Signature' => 'เพิ่มลายเซ็น',
        'Edit Signature' => 'แก้ไขลายเซ็น',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'แก้ไขลายเซ็น',

        # Template: AdminState
        'State Management' => 'การจัดการสถานะ',
        'Add State' => 'เพิ่มสถานะ',
        'Edit State' => 'แก้ไขสถานะ',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'ความสนใจ',
        'Please also update the states in SysConfig where needed.' => 'โปรดอัปเดตสถานะใน sysconfig เมื่อจำเป็น',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'ประเภทสถานะ',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'ไม่สามารถส่งข้อมูลการสนับสนุนให้กับกลุ่มOTRS',
        'Enable Cloud Services' => 'เปิดใช้บริการคลาวด์',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'ข้อมูลนี้จะถูกส่งไปยังกลุ่มOTRS เป็นประจำ หากต้องการหยุดการส่งข้อมูลนี้โปรดอัปเดตการลงทะเบียนในระบบของคุณ',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'คุณสามารถกระตุ้นการสนับสนุนการส่งข้อมูลโดยการกดปุ่มนี้:',
        'Send Update' => 'ส่งการอัพเดต',
        'Currently this data is only shown in this system.' => 'ขณะนี้ข้อมูลนี้จะแสดงเฉพาะในระบบนี้',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'กลุมสนับสนุน(รวมถึงข้อมูลการลงทะเบียนระบบ ข้อมูลสนับสนุน รายการของแพคเกจการติดตั้ง
และไฟล์แหล่งที่มาทั้งหมดที่มีการปรับเปลี่ยน) สามารถสร้างขึ้นได้โดยการกดปุ่มนี้:',
        'Generate Support Bundle' => 'สร้างกลุ่มสนับสนุน',
        'The Support Bundle has been Generated' => '',
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

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'การจัดการที่อยู่อีเมลของระบบ',
        'Add System Email Address' => 'เพิ่มที่อยู่อีเมลของระบบ',
        'Edit System Email Address' => 'แก้ไขที่อยู่อีเมลของระบบ',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'อีเมลขาเข้าทั้งหมดที่มาที่อยู่นี้ใน ถึง หรือ สำเนา จะถูกส่งไปอยู่ในคิวที่เลือก',
        'Email address' => 'ที่อยู่อีเมล',
        'Display name' => 'ชื่อที่แสดง',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'ชื่อที่ปรากฏและที่อยู่อีเมลจะแสดงบนอีเมลที่คุณส่ง',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '',
        'System configuration' => '',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '',
        'Find out how to use the system configuration by reading the %s.' =>
            '',
        'Search in all settings...' => '',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '',
        'Help' => '',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '',
        'Please review the changed settings and deploy afterwards.' => '',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '',
        'Changes Overview' => '',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '',
        'There are no settings to be deployed.' => '',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '',
        'Deploy selected changes' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => '',
        'Import system configuration' => '',
        'Download current configuration settings of your system in a .yml file.' =>
            '',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '',
        'Search for category' => '',
        'Settings I\'m currently editing' => '',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '',
        'Your search for "%s" in category "%s" returned one result.' => '',
        'Your search for "%s" in category "%s" returned %s results.' => '',
        'You\'re currently not editing any settings.' => '',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'หมวดหมู่',
        'Run search' => 'ดำเนินการค้นหา',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'การจัดการการบำรุงรักษาระบบ',
        'Schedule New System Maintenance' => 'กำหนดเวลาการบำรุงรักษาระบบใหม่',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'กำหนดการระยะเวลาการบำรุงรักษาระบบเพื่อแจ้งเอเย่นต์และลูกค้าว่าระบบจะทำงานช้าลงในช่วงเวลาดังกล่าว',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'บางครั้งก่อนที่จะการบำรุงรักษาระบบนี้จะเริ่มต้นผู้ใช้จะได้รับการแจ้งเตือนในแต่ละหน้าจอการประกาศเกี่ยวกับเรื่องนี้',
        'Stop date' => 'วันที่หยุด',
        'Delete System Maintenance' => 'ลบการบำรุงรักษาระบบ',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
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
        'Template Management' => '',
        'Add Template' => 'เพิ่มแม่แบบ',
        'Edit Template' => 'แก้ไขแม่แบบ',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'แม่แบบเป็นข้อความเริ่มต้นซึ่งจะช่วยให้เอเย่นต์ของคุณในการเขียนตั๋ว ตอบหรือส่งต่อให้เร็วขึ้น',
        'Don\'t forget to add new templates to queues.' => 'อย่าลืมที่จะเพิ่มแม่แบบใหม่ไปยังคิว',
        'Attachments' => 'สิ่งที่แนบมา',
        'Delete this entry' => 'ลบการกรอกข้อมูลนี้',
        'Do you really want to delete this template?' => 'คุณต้องการที่จะลบแม่แบบนี้หรือไม่?',
        'A standard template with this name already exists!' => 'แม่แบบมาตรฐานที่ใช้ชื่อนี้มีอยู่แล้ว!',
        'Template' => 'แม่แบบ',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'สร้างประเภทแม่แบบซึ่งสนับสนุนเฉพาะสมาร์ทแท็กนี้',
        'Example template' => 'ตัวอย่างแม่แบบ',
        'The current ticket state is' => 'สถานะตั๋วปัจจุบัน',
        'Your email address is' => 'ที่อยู่อีเมลของคุณคือ',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'สลับการใช้งานสำหรับทั้งหมด',
        'Link %s to selected %s' => 'การเชื่อมโยง %s เพื่อเลือก %s',

        # Template: AdminType
        'Type Management' => 'ประเภทการจัดการ',
        'Add Type' => 'เพิ่มประเภท',
        'Edit Type' => 'แก้ไขประเภท',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'ประเภทที่ใช้ชื่อนี้มีอยู่แล้ว!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'การจัดการเอเย่นต์',
        'Edit Agent' => 'แก้ไขเอเย่นต์',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'เอเย่นต์จะต้องจัดการกับตั๋ว',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'อย่าลืมที่จะเพิ่มเอเย่นต์ใหม่ไปยังกลุ่มและ/หรือบทบาท!',
        'Please enter a search term to look for agents.' => 'กรุณากรอกคำค้นหาที่จะค้นหาเอเย่นต์',
        'Last login' => 'เข้าระบบครั้งสุดท้าย',
        'Switch to agent' => 'เปลี่ยนเป็นเอเย่นต์',
        'Title or salutation' => 'หัวข้อหรือคำขึ้นต้น',
        'Firstname' => 'ชื่อ',
        'Lastname' => 'นามสกุล',
        'A user with this username already exists!' => 'มีผู้ใช้งานชื่อนี้อยู่แล้ว!',
        'Will be auto-generated if left empty.' => 'จะสร้างขึ้นโดยอัตโนมัติหากปล่อยทิ้งไว้ว่างเปล่า',
        'Mobile' => 'โทรศัพท์มือถือ',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'จัดการความสัมพันธ์ของกลุ่มเอเย่นต์',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '',
        'Add Appointment' => '',
        'Today' => 'วันนี้',
        'All-day' => 'ทั้งวัน',
        'Repeat' => '',
        'Notification' => 'การแจ้งเตือน',
        'Yes' => 'ใช่',
        'No' => 'ไม่',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'วันที่ไม่ถูกต้อง!',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'วัน(s)',
        'week(s)' => 'อาทิตย์(s)',
        'month(s)' => 'เดือน(s)',
        'year(s)' => 'ปี(s)',
        'On' => 'เปิด',
        'Monday' => 'วันจันทร์',
        'Mon' => 'จ',
        'Tuesday' => 'วันอังคาร',
        'Tue' => 'อ',
        'Wednesday' => 'วันพุธ',
        'Wed' => 'พ',
        'Thursday' => 'วันพฤหัสบดี',
        'Thu' => 'พฤ',
        'Friday' => 'วันศุกร์',
        'Fri' => 'ศ',
        'Saturday' => 'วันเสาร์',
        'Sat' => 'ส',
        'Sunday' => 'วันอาทิตย์',
        'Sun' => 'อา',
        'January' => 'มกราคม',
        'Jan' => 'ม.ค.',
        'February' => 'กุมภาพันธ์',
        'Feb' => 'ก.พ',
        'March' => 'มีนาคม',
        'Mar' => 'มี.ค.',
        'April' => 'เมษายน',
        'Apr' => 'เม.ย.',
        'May_long' => 'พฤษภาคม',
        'May' => 'พ.ค.',
        'June' => 'มิถุนายน',
        'Jun' => 'มิ.ย.',
        'July' => 'กรกฎาคม',
        'Jul' => 'ก.ค.',
        'August' => 'สิงหาคม',
        'Aug' => 'ส.ค.',
        'September' => 'กันยายน',
        'Sep' => 'ก.ย.',
        'October' => 'ตุลาคม\t',
        'Oct' => 'ต.ค.',
        'November' => 'พฤศจิกายน\t',
        'Nov' => 'พ.ย.',
        'December' => 'ธันวาคม',
        'Dec' => 'ธ.ค.',
        'Relative point of time' => '',
        'Link' => 'ลิงค์',
        'Remove entry' => 'ลบการกรอกข้อมูลนี้',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'ศูนย์ข้อมูลลูกค้า',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'ลูกค้าผู้ใช้',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'หมายเหตุ: ลูกค้านี้ไม่ถูกต้อง!',
        'Start chat' => 'เริ่มแชท',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'รูปแบบการค้นหา',
        'Create Template' => 'สร้างแม่แบบ',
        'Create New' => 'สร้างใหม่',
        'Save changes in template' => 'บันทึกการเปลี่ยนแปลงในแม่แบบ',
        'Filters in use' => 'ตัวกรองที่ใช้งาน',
        'Additional filters' => 'ตัวกรองเพิ่มเติม',
        'Add another attribute' => 'เพิ่มแอตทริบิวต์อื่น',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'เลือกทั้งหมด',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'เปลี่ยนตัวเลือกการค้นหา',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '',

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

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => 'พรุ่งนี้',
        'Soon' => '',
        '5 days' => '',
        'Start' => 'เริ่มต้น',
        'none' => 'ไม่มี',

        # Template: AgentDashboardCalendarOverview
        'in' => 'ใน',

        # Template: AgentDashboardCommon
        'Save settings' => 'บันทึกการตั้งค่า',
        'Close this widget' => 'ปิดเครื่องมือนี้',
        'more' => 'มากขึ้น',
        'Available Columns' => 'คอลัมน์ที่พร้อมใช้งาน',
        'Visible Columns (order by drag & drop)' => 'คอลัมน์ที่มองเห็นได้ (จัดเรียงโดยการลากและวาง)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'เปิด',
        'Closed' => 'ปิด',
        '%s open ticket(s) of %s' => '% s ตั๋วเปิด (s) ของ% s',
        '%s closed ticket(s) of %s' => '% s ตั๋วที่ปิดแล้ว (s) ของ% s',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'ตั๋วการขยาย',
        'Open tickets' => 'เปิดตั๋ว',
        'Closed tickets' => 'ปิดตั๋ว',
        'All tickets' => 'ตั๋วทุกใบ',
        'Archived tickets' => 'ตั๋วที่เก็บถาวร',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => 'ตั๋วจากโทรศัพท์',
        'Email ticket' => 'อีเมล์ตั๋ว',
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
        'Please select a valid graph output format in the configuration of this widget.' =>
            'โปรดเลือกรูปแบบการออกกราฟที่ถูกต้องในการกำหนดค่าของเครื่องมือนี้',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'เนื้อหาของสถิตินี้จะถูกเตรียมไว้สำหรับคุณโปรดอดทนรอ',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'สถิตินี้ไม่สามารถถูกนำมาใช้ในขณะนี้ได้เพราะการกำหนดค่าของจำเป็นต้องได้รับการแก้ไขโดยผู้ดูแลระบบสถิติ',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'ตั๋วที่ถูกล็อคของฉัน',
        'My watched tickets' => 'ตั๋วดูแล้วของฉัน',
        'My responsibilities' => 'ความรับผิดชอบของฉัน',
        'Tickets in My Queues' => 'ตั๋วในคิวของฉัน',
        'Tickets in My Services' => 'ตั๋วในการบริการของฉัน',
        'Service Time' => 'เวลาบริการ',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => 'นอกออฟฟิศ',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'จนถึง',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'ในการรับข่าว ใบอนุญาตหรือการเปลี่ยนแปลงบางอย่าง',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => '',
        'Link with' => '',
        'Start search' => '',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'แก้ไขการตั้งค่าของคุณ',
        'Personal Preferences' => '',
        'Preferences' => 'การกำหนดลักษณะ',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => '',
        'Filter settings...' => '',
        'Filter for settings' => '',
        'Save all settings' => '',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '',
        'Off' => 'ปิด',
        'End' => 'จบ',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTRS at %s.' => 'คุณรู้หรือไม่ว่าคุณสามารถช่วยแปลOTRSที่% s ?',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => 'เป้าหมาย',
        'Process' => 'ขั้นตอน',
        'Split' => 'แยก',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTRS' => '',
        'Dynamic Matrix' => 'เมทริกซ์ไดนามิค',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'รายชื่อไดนามิค',
        'Each row contains data of one entity.' => '',
        'Static' => 'คงที่',
        'Non-configurable complex statistics.' => '',
        'General Specification' => 'รายละเอียดทั่วไป',
        'Create Statistic' => 'สร้างสถิติ',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => 'รันตอนนี้',
        'Statistics Preview' => 'ตัวอย่างสถิติ',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'สถิติ',
        'Run' => 'iyo',
        'Edit statistic "%s".' => 'แก้ไขสถิติ "%s"',
        'Export statistic "%s"' => 'ส่งออกสถิติ "%s"',
        'Export statistic %s' => 'แก้ไขสถิติ %s',
        'Delete statistic "%s"' => 'ลบสถิติ "%s"',
        'Delete statistic %s' => 'ลบสถิติ %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'สร้างโดย',
        'Changed by' => 'เปลี่ยนโดย',
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
        'The ticket has been locked' => 'ตั๋วถูกล็อค',
        'Undo & close' => 'เลิกทำและปิด',
        'Ticket Settings' => 'การตั้งค่าตั๋ว',
        'Queue invalid.' => '',
        'Service invalid.' => 'การบริการที่ใช้ไม่ได้',
        'SLA invalid.' => '',
        'New Owner' => 'เจ้าของใหม่',
        'Please set a new owner!' => 'โปรดกำหนดเจ้าของใหม่!',
        'Owner invalid.' => '',
        'New Responsible' => 'ความรับผิดชอบใหม่',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'สถานะถัดไป',
        'State invalid.' => '',
        'For all pending* states.' => 'สำหรับสถานะที่ค้างอยู่ทั้งหมด *',
        'Add Article' => 'เพิ่มบทความ',
        'Create an Article' => 'สร้างบทความ',
        'Inform agents' => 'แจ้งเอเย่นต์',
        'Inform involved agents' => 'แจ้งเอเย่นต์ที่เกี่ยวข้อง',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'คุณสามารถเลือกเอเย่นต์เพิ่มเติมที่นี้ซึ่งควรได้รับการแจ้งเตือนเกี่ยวกับบทความใหม่',
        'Text will also be received by' => '',
        'Text Template' => 'รูปแบบข้อความ',
        'Setting a template will overwrite any text or attachment.' => 'การตั้งค่าแม่แบบจะเขียนทับข้อความหรือสิ่งที่แนบมา',
        'Invalid time!' => 'เวลาไม่ถูกต้อง!',

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
        'Merge' => 'ผสาน',
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
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'ลบตั๋วลูกค้า',
        'Please remove this entry and enter a new one with the correct value.' =>
            'โปรดลบข้อมูลนี้และป้อนใหม่ด้วยค่าที่ถูกต้อง',
        'This address already exists on the address list.' => 'ที่อยู่นี้มีอยู่แล้วในรายการที่อยู่',
        'Remove Cc' => 'ลบสำเนา',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'ลบสำเนาลับ',
        'Date Invalid!' => 'วันที่ไม่ถูกต้อง!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',
        'Customer Information' => 'ข้อมูลลูกค้า',
        'Customer user' => 'ลูกค้าผู้ใช้',

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

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

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
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => 'เวลาในการสร้าง',
        'Article' => 'บทความ',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => 'การตั้งค่าการผสาน',
        'You need to use a ticket number!' => 'คุณจำเป็นต้องใช้หมายเลขตั๋ว!',
        'A valid ticket number is required.' => 'จำเป็นต้องใช้หมายเลขตั๋วที่ถูกต้อง',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => 'ต้องการที่อยู่อีเมลที่ถูกต้อง',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'คิวใหม่',
        'Move' => 'ย้าย',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'ไม่พบข้อมูลตั๋ว',
        'Open / Close ticket action menu' => 'เปิด/ปิดเมนูตั๋วการดำเนินการ',
        'Select this ticket' => 'เลือกตั๋วนี้',
        'Sender' => 'ผู้ส่ง',
        'First Response Time' => 'เวลาตอบสนองครั้งแรก',
        'Update Time' => 'เวลาการอัพเดต',
        'Solution Time' => 'เวลาการแก้ปัญหา',
        'Move ticket to a different queue' => 'ย้ายตั๋วไปคิวอื่น',
        'Change queue' => 'เปลี่ยนคิว',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'ลบตัวกรองที่ใช้งานอยู่สำหรับหน้าจอนี้',
        'Tickets per page' => 'ตั๋วต่อหนึ่งหน้า',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

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

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'ลงทะเบียนตั๋วเข้าไปในการประมวลผล',

        # Template: AgentTicketSearch
        'Profile link' => 'ข้อมูลการเชื่อมโยง',
        'Output' => 'ข้อมูลที่ส่งออกมา',
        'Fulltext' => 'ข้อความฉบับเต็ม',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'สร้างขึ้นในคิว',
        'Lock state' => 'สถานะการล็อค',
        'Watcher' => 'ผู้เฝ้าดู',
        'Article Create Time (before/after)' => 'เวลาที่สร้างบทความ (ก่อน/หลัง)',
        'Article Create Time (between)' => 'เวลาที่สร้างบทความ(ในระหว่าง)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'เวลาที่สร้างตั๋ว (ก่อน/หลัง)',
        'Ticket Create Time (between)' => 'เวลาที่สร้างตั๋ว (ในระหว่าง)',
        'Ticket Change Time (before/after)' => 'เวลาที่เปลี่ยนตั๋ว (ก่อน/หลัง)',
        'Ticket Change Time (between)' => 'เวลาที่เปลี่ยนตั๋ว (ในระหว่าง)',
        'Ticket Last Change Time (before/after)' => 'เวลาที่เปลี่ยนตั๋วครั้งล่าสุด (ก่อน/หลัง)',
        'Ticket Last Change Time (between)' => 'เวลาที่เปลี่ยนตั๋วครั้งล่าสุด (ในระหว่าง)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'เวลาที่ปิดตั๋ว (ก่อน/หลัง)',
        'Ticket Close Time (between)' => 'เวลาที่ปิดตั๋ว (ในระหว่าง)',
        'Ticket Escalation Time (before/after)' => 'เวลาการขยายตั๋ว (ก่อน/หลัง)',
        'Ticket Escalation Time (between)' => 'เวลาการขยายตั๋ว(ในระหว่าง)',
        'Archive Search' => 'ค้นหาเอกสารเก่า',

        # Template: AgentTicketZoom
        'Sender Type' => 'ประเภทผู้ส่ง',
        'Save filter settings as default' => 'บันทึกการตั้งค่าตัวกรองเป็นค่าเริ่มต้น',
        'Event Type' => 'ประเภทของกิจกรรม',
        'Save as default' => 'บันทึกเป็นค่าเริ่มต้น',
        'Drafts' => '',
        'by' => 'โดย',
        'Change Queue' => 'เปลี่ยนคิว',
        'There are no dialogs available at this point in the process.' =>
            'ไม่มีไดอะล็อกที่สามารถใช้ได้ในกระบวนการนี้',
        'This item has no articles yet.' => 'ไอเท็มนี้ยังไม่มีบทความ',
        'Ticket Timeline View' => 'มุมมองไทม์ไลน์ตั๋ว',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'เพิ่มตัวกรอง',
        'Set' => 'กำหนด',
        'Reset Filter' => 'รีเซตตัวกรอง',
        'No.' => 'หมายเลข',
        'Unread articles' => 'บทความที่ยังไม่ได้อ่าน ',
        'Via' => '',
        'Important' => 'สำคัญ',
        'Unread Article!' => 'บทความที่ยังไม่ได้อ่าน!',
        'Incoming message' => 'ข้อความขาเข้า',
        'Outgoing message' => 'ข้อความขาออก',
        'Internal message' => 'ข้อความภายใน',
        'Sending of this message has failed.' => '',
        'Resize' => 'ปรับขนาด',
        'Mark this article as read' => 'มาร์คว่าได้อ่านบทความนี้แล้ว',
        'Show Full Text' => 'แสดงข้อความแบบเต็ม',
        'Full Article Text' => 'ข้อความบทความเต็ม',
        'No more events found. Please try changing the filter settings.' =>
            'ไม่พบกิจกรรมอื่นๆ โปรดลองเปลี่ยนการตั้งค่าตัวกรอง',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'ในการเปิดการเชื่อมโยงในบทความต่อไปนี้คุณอาจต้องกด Ctrl หรือ Cmd หรือ Shift ค้างไว้ขณะที่คลิกที่ลิงค์ (ขึ้นอยู่กับเบราว์เซอร์ของคุณและ OS)',
        'Close this message' => 'ปิดข้อความนี้',
        'Image' => '',
        'PDF' => '',
        'Unknown' => 'ไม่ระบุ',
        'View' => 'มุมมอง',

        # Template: LinkTable
        'Linked Objects' => 'การเชื่อมโยงออบเจค',

        # Template: TicketInformation
        'Archive' => 'เอกสารเก่า',
        'This ticket is archived.' => 'จัดเก็บตั๋วนี่แล้ว',
        'Note: Type is invalid!' => 'หมายเหตุ: ประเภทไม่ถูกต้อง!',
        'Pending till' => 'รอดำเนินการจนถึง',
        'Locked' => 'ถูกล็อค',
        '%s Ticket(s)' => '',
        'Accounted time' => 'เวลาที่คิด',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'เพื่อปกป้องความเป็นส่วนตัวของคุณ เนื้อหาระยะไกลถูกบล็อก',
        'Load blocked content.' => 'โหลดเนื้อหาที่ถูกบล็อก',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'คุณสามารถ',
        'go back to the previous page' => 'กลับไปที่หน้าก่อนหน้านี้',

        # Template: CustomerAccept
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accept your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '',
        'Select a customer ID to assign to this ticket.' => '',
        'From all Customer IDs' => '',
        'From assigned Customer IDs' => '',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => 'รายละเอียด ข้อผิดพลาด',
        'Traceback' => 'ตรวจสอบย้อนกลับ',

        # Template: CustomerFooter
        '%s powered by %s™' => '',
        'Powered by %s™' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'ไม่พร้อมใช้งาน JavaScript',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'คำเตือนเบราว์เซอร์',
        'The browser you are using is too old.' => 'เบราว์เซอร์ที่คุณกำลังใช้มันเก่าเกินไป',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'โปรดอ่านเอกสารหรือขอให้ผู้ดูแลระบบของคุณสำหรับอธิบายข้อมูลเพิ่มเติม',
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
        'Back' => 'กลับไป',
        'Request New Password' => 'การร้องขอรหัสผ่านใหม่',
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
        'Logout %s' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'ข้อตกลงระดับการให้บริการ',

        # Template: CustomerTicketOverview
        'Welcome!' => 'ยินดีต้อนรับ!',
        'Please click the button below to create your first ticket.' => 'กรุณาคลิกที่ปุ่มด้านล่างเพื่อสร้างตั๋วของคุณครั้งแรก',
        'Create your first ticket' => 'สร้างตั๋วของคุณครั้งแรก',

        # Template: CustomerTicketSearch
        'Profile' => 'โปรไฟล์',
        'e. g. 10*5155 or 105658*' => 'เช่น 10*5155 หรือ 105658*',
        'CustomerID' => 'ไอดีลูกค้า',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'ประเภท',
        'Time Restrictions' => '',
        'No time settings' => 'ไม่มีการตั้งค่าเวลา',
        'All' => 'ทั้งหมด',
        'Specific date' => 'วันที่เฉพาะเจาะจง',
        'Only tickets created' => 'เฉพาะตั๋วที่สร้างแล้ว',
        'Date range' => 'ช่วงวันที่',
        'Only tickets created between' => 'เฉพาะตั๋วที่สร้างในระหว่าง',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'บันทึกเป็นแม่แบบ?',
        'Save as Template' => 'บันทึกเป็นแม่แบบ',
        'Template Name' => 'ชื่อแม่แบบ',
        'Pick a profile name' => 'เลือกชื่อโปรไฟล์',
        'Output to' => 'ส่งออกไปยัง',

        # Template: CustomerTicketSearchResultShort
        'of' => 'ของ',
        'Page' => 'หน้า',
        'Search Results for' => 'ผลการค้นหาสำหรับ',
        'Remove this Search Term.' => 'ลบคำค้นหานี้',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'เริ่มต้นการสนทนาจากตั๋วนี้',
        'Next Steps' => 'ขั้นตอนถัดไป',
        'Reply' => 'ตอบกลับ',

        # Template: Chat
        'Expand article' => 'Expand article',

        # Template: CustomerWarning
        'Warning' => 'คำเตือน',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'ข้อมูลกิจกรรม',
        'Ticket fields' => 'ช่องข้อมูลตั๋ว',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'ส่งรายงานข้อบกพร่อง',
        'Expand' => 'การขยาย',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => '',
        'Save as new draft' => '',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '',
        'You have loaded the draft "%s". You last changed it %s.' => '',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '',

        # Template: Header
        'View notifications' => 'ดูการแจ้งเตือน',
        'Notifications' => '',
        'Notifications (OTRS Business Solution™)' => '',
        'Personal preferences' => '',
        'Logout' => 'ออกจากระบบ',
        'You are logged in as' => 'คุณได้เข้าสู่ระบบเป็น',

        # Template: Installer
        'JavaScript not available' => 'ไม่พร้อมใช้งาน JavaScript',
        'Step %s' => 'ขั้นตอน %s',
        'License' => 'ใบอนุญาต',
        'Database Settings' => 'การตั้งค่าฐานข้อมูล',
        'General Specifications and Mail Settings' => 'คุณสมบัติทั่วไปและการตั้งค่าเมล์',
        'Finish' => 'เสร็จ',
        'Welcome to %s' => 'ยินดีต้อนรับสู่ %s',
        'Germany' => '',
        'Phone' => 'โทรศัพท์',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'เว็บไซต์',

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
        'Done' => 'ดำเนินการเสร็จแล้ว',
        'Error' => 'ข้อผิดพลาด',
        'Database setup successful!' => 'การติดตั้งฐานข้อมูลประสบความสำเร็จ!',

        # Template: InstallerDBStart
        'Install Type' => 'การติดตั้งประเภท',
        'Create a new database for OTRS' => 'สร้างฐานข้อมูลใหม่สำหรับ OTRS',
        'Use an existing database for OTRS' => 'ใช้ฐานข้อมูลที่มีอยู่แล้วสำหรับ OTRS',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'หากคุณตั้งรหัสผ่าน root สำหรับฐานข้อมูลของคุณก็จะต้องป้อนเข้าที่นี่หากไม่ได้ตั้งค่าไว้ ก็ปล่อยให้ฟิลด์นี้ว่างเปล่า',
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
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => 'ออบเจค#',
        'Add links' => 'เพิ่มลิงค์',
        'Delete links' => 'ลบการเชื่อมโยง',

        # Template: Login
        'Lost your password?' => 'ลืมรหัสผ่านของคุณ?',
        'Back to login' => 'กลับไปเข้าสู่ระบบ',

        # Template: MetaFloater
        'Scale preview content' => 'ตัวอย่างสเกลเนื้อหา',
        'Open URL in new tab' => 'เปิด URL ในแท็บใหม่',
        'Close preview' => 'ปิดการแสดงตัวอย่าง',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'ขออภัยฟีเจอร์นี้ของOTRS ไม่สามารถใช้งานกับโทรศัพท์มือถือได้ขณะนี้ หากคุณต้องการที่จะใช้มันคุณสามารถสลับไปยังโหมดเดสก์ทอปหรือเดสก์ทอปของคุณตามปกติ',

        # Template: Motd
        'Message of the Day' => 'ข้อความประจำวัน',
        'This is the message of the day. You can edit this in %s.' => 'ข้อความนี้เป็นข้อความของวันนี้ คุณสามารถแก้ไขนี้',

        # Template: NoPermission
        'Insufficient Rights' => 'สิทธิ์ไม่เพียงพอ',
        'Back to the previous page' => 'กลับไปที่หน้าก่อนหน้านี้',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'ให้การสนับสนุนโดย',

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
        'No user configurable notifications found.' => 'ไม่พบผู้ใช้ที่สามารถกำหนดค่าการแจ้งเตือน',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'ได้รับข้อความสำหรับการแจ้งเตือน \'%s\' ด้วยวิธีการขนส่ง \'%s\'',

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

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'การอนุญาต',
        'You can select one or more groups to define access for different agents.' =>
            'คุณสามารถเลือกหนึ่งหรือมากกว่าหนึ่งกลุ่มเพื่อกำหนดการเข้าถึงสำหรับเอเย่นต์ที่แตกต่างกัน',
        'Result formats' => 'รูปแบบผลลัพธ์',
        'Time Zone' => 'โซนเวลา',
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
        'Preview format' => '',
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
        'Between %s and %s' => '',
        'Relative period' => 'ระยะเวลาที่สัมพันธ์กัน',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'ความสมบูรณ์ที่ผ่านมา %s และความสมบูรณ์ในปัจจุบัน+ ที่กำลังจะเกิดขึ้น',
        'Do not allow changes to this element when the statistic is generated.' =>
            'ไม่อนุญาตให้มีการเปลี่ยนแปลงองค์ประกอบนี้เมื่อสถิติจะถูกสร้างขึ้น',

        # Template: StatsParamsWidget
        'Format' => 'รูปแบบ',
        'Exchange Axis' => 'แลกเปลี่ยนแกน',
        'Configurable Params of Static Stat' => '',
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

        # Template: SettingsList
        'This setting is disabled.' => '',
        'This setting is fixed but not deployed yet!' => '',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => '',
        'Enable this setting, so it becomes effective' => '',
        'Enable' => '',
        'Reset this setting to its default state' => '',
        'Reset setting' => '',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => '',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '',
        'Forbid users to update' => '',
        'Show user specific changes for this setting' => '',
        'Show user settings' => '',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => '',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => '',
        'Add this setting to your favorites' => '',
        'Add to favourites' => '',
        'Cancel editing this setting' => '',
        'Save changes on this setting' => '',
        'Edit this setting' => '',
        'Enable this setting' => '',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => '',
        'User modification' => '',
        'enabled' => '',
        'disabled' => '',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => '',
        'Go back to admin: ' => '',
        'Deployment' => '',
        'My favourite settings' => '',
        'Invalid settings' => '',

        # Template: DynamicActions
        'Filter visible settings...' => '',
        'Enable edit mode for all settings' => '',
        'Save all edited settings' => '',
        'Cancel editing for all settings' => '',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '',

        # Template: Help
        'Currently edited by me.' => '',
        'Modified but not yet deployed.' => '',
        'Currently edited by another user.' => '',
        'Different from its default value.' => '',
        'Save current setting.' => '',
        'Cancel editing current setting.' => '',

        # Template: Navigation
        'Navigation' => '',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'หน้าการทดสอบ OTRS',
        'Unlock' => 'ปลดล็อค',
        'Welcome %s %s' => 'ยินดีต้อนรับ %s %s',
        'Counter' => 'ตัวนับ',

        # Template: Warning
        'Go back to the previous page' => 'กลับไปที่หน้าก่อนหน้านี้',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => '',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'ยืนยัน',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select files or just drop them here.' => '',
        'Click to select a file or just drop it here.' => '',
        'Uploading...' => '',

        # JS Template: InformationDialog
        'Process state' => '',
        'Running' => '',
        'Finished' => 'เสร็จสิ้น',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'เพิ่มการกรอกข้อมูลใหม่',

        # JS Template: AddHashKey
        'Add key' => '',

        # JS Template: DialogDeployment
        'Deployment comment...' => '',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '',
        'Preparing to deploy, please wait...' => '',
        'Deploy now' => '',
        'Try again' => '',

        # JS Template: DialogReset
        'Reset options' => '',
        'Reset setting on global level.' => '',
        'Reset globally' => '',
        'Remove all user changes.' => '',
        'Reset locally' => '',
        'user(s) have modified this setting.' => '',
        'Do you really want to reset this setting to it\'s default value?' =>
            '',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'CustomerIDs' => 'ไอดีลูกค้า',
        'Fax' => 'แฟกซ์',
        'Street' => 'ถนน',
        'Zip' => 'รหัสไปรษณีย์',
        'City' => 'เมือง',
        'Country' => 'ประเทศ',
        'Valid' => 'ถูกต้อง',
        'Mr.' => 'นาย',
        'Mrs.' => 'นาง',
        'Address' => 'ที่อยู่',
        'View system log messages.' => 'ดูข้อความเข้าสู่ระบบ',
        'Edit the system configuration settings.' => 'แก้ไขการตั้งค่าการกำหนดค่าระบบ',
        'Update and extend your system with software packages.' => 'ปรับปรุงและขยายระบบของคุณด้วยซอฟแวร์',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ข้อมูลACL จากฐานข้อมูลไม่ได้ซิงค์กับการกำหนดค่าระบบกรุณาใช้งาน ACLs ทั้งหมด',
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
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'คู่ที่เหมาะสม',
        'Negated exact match' => 'คู่ที่เหมาะสมเป็นลบ',
        'Regular expression' => 'การแสดงผลทั่วไป',
        'Regular expression (ignore case)' => 'แสดงออกปกติ (IgnoreCase)',
        'Negated regular expression' => 'แสดงออกปกติเป็นลบ',
        'Negated regular expression (ignore case)' => 'แสดงออกปกติเป็นลบ (ignore case)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '',
        'Please contact the administrator.' => '',
        'No CalendarID!' => '',
        'You have no access to this calendar!' => '',
        'Error updating the calendar!' => '',
        'Couldn\'t read calendar configuration file.' => '',
        'Please make sure your file is valid.' => '',
        'Could not import the calendar!' => '',
        'Calendar imported!' => '',
        'Need CalendarID!' => '',
        'Could not retrieve data for given CalendarID' => '',
        'Successfully imported %s appointment(s) to calendar %s.' => '',
        '+5 minutes' => '',
        '+15 minutes' => '',
        '+30 minutes' => '',
        '+1 hour' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '',
        'System was unable to import file!' => '',
        'Please check the log for more information.' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '',
        'Notification added!' => 'เพิ่มการแจ้งเตือนแล้ว!',
        'There was an error getting data for Notification with ID:%s!' =>
            'มีข้อผิดพลาดในการรับข้อมูลสำหรับการแจ้งเตือนด้วย ID:%s!',
        'Unknown Notification %s!' => 'การแจ้งเตือนที่ไม่ระบุ% s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'มีข้อผิดพลาดในการสร้างการแจ้งเตือน',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ไม่สามารถนำเข้าการแจ้งเตือนได้เนื่องจากข้อผิดพลาดที่ไม่ทราบโปรดตรวจสอบการล็อก OTRS สำหรับข้อมูลเพิ่มเติม',
        'The following Notifications have been added successfully: %s' =>
            'การแจ้งเตือนดังต่อไปนี้ได้รับการเพิ่มเรียบร้อยแล้ว: %s',
        'The following Notifications have been updated successfully: %s' =>
            'การแจ้งเตือนดังต่อไปนี้ได้รับการอัพเดตเรียบร้อยแล้ว: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'มีข้อผิดพลาดการเพิ่ม / อัปเดต การแจ้งเตือนดังต่อไปนี้ได้:% s กรุณาตรวจสอบแฟ้มบันทึกสำหรับข้อมูลเพิ่มเติม',
        'Notification updated!' => 'ปรับปรุงการแจ้งเตือนแล้ว!',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'เพิ่มสิ่งที่แนบมาแล้ว!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => '',
        'Last 1 hour' => '',
        'Last 3 hours' => '',
        'Last 6 hours' => '',
        'Last 12 hours' => '',
        'Last 24 hours' => '',
        'Last week' => '',
        'Last month' => '',
        'Invalid StartTime: %s!' => '',
        'Successful' => '',
        'Processing' => '',
        'Failed' => 'ล้มเหลว',
        'Invalid Filter: %s!' => 'ฟิลเตอร์ไม่ถูกต้อง: %s!',
        'Less than a second' => '',
        'sorted descending' => 'เรียงลำดับจากมากไปน้อย',
        'sorted ascending' => 'เรียงลำดับจากน้อยไปมาก',
        'Trace' => '',
        'Debug' => 'การแก้ปัญหา',
        'Info' => 'ข้อมูล',
        'Warn' => '',
        'days' => 'วัน',
        'day' => 'วัน',
        'hour' => 'ชั่วโมง',
        'minute' => 'นาที',
        'seconds' => 'วินาที',
        'second' => 'วินาที',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'อัปเดตลูกค้าบริษัทแล้ว!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => 'ลูกค้าบริษัท %s มีอยู่แล้ว!',
        'Customer company added!' => 'เพิ่มลูกค้าบริษัทแล้ว!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'อัปเดตลูกค้าแล้ว!',
        'New phone ticket' => 'ตั๋วทางโทรศัพท์ใหม่',
        'New email ticket' => 'ตั๋วอีเมลใหม่',
        'Customer %s added' => 'ลูกค้าเพิ่มขึ้น % s',
        'Customer user updated!' => '',
        'Same Customer' => '',
        'Direct' => '',
        'Indirect' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '',
        'Allocate Services to Customer User' => '',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'การตั้งค่าฟิลด์ไม่ถูกต้อง',
        'Objects configuration is not valid' => 'การกำหนดค่าออบเจคไม่ถูกต้อง',
        'Database (%s)' => '',
        'Web service (%s)' => '',
        'Contact with data (%s)' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'ไม่สามารถรีเซ็ตคำสั่งฟิลด์ไดนามิกอย่างถูกต้องโปรดตรวจสอบบันทึกข้อผิดพลาดสำหรับรายละเอียดเพิ่มเติม',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'subaction ที่ไม่ได้กำหนด',
        'Need %s' => 'ต้องการ %s',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => 'ฟิลด์ไม่ประกอบด้วยตัวอักษร ASCII และตัวเลข',
        'There is another field with the same name.' => 'มีฟิลด์อื่นที่มีชื่อเดียวกัน',
        'The field must be numeric.' => 'ข้อมูลนี้ต้องเป็นตัวเลข',
        'Need ValidID' => 'ต้องการ ValidID',
        'Could not create the new field' => 'ไม่สามารถสร้างฟิลด์ใหม่',
        'Need ID' => 'ต้องการ ID',
        'Could not get data for dynamic field %s' => 'ไม่สามารถรับข้อมูลสำหรับข้อมูลแบบไดนามิก %s',
        'Change %s field' => '',
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
        'minute(s)' => 'นาที(s)',
        'hour(s)' => 'ชั่วโมง(s)',
        'Time unit' => 'หน่วยเวลา',
        'within the last ...' => 'ภายในครั้งล่าสุด',
        'within the next ...' => 'ภายในครั้งต่อไป...',
        'more than ... ago' => 'มากกว่า... ที่ผ่านมา',
        'Unarchived tickets' => 'ตั๋วถาวรที่ถูกยกเลิก',
        'archive tickets' => 'ตั๋วที่เก็บถาวร',
        'restore tickets from archive' => 'คืนค่าตั๋วจากคลัง',
        'Need Profile!' => 'ต้องมีโปรไฟล์!',
        'Got no values to check.' => 'ไม่มีค่าสำหรับเช็ค',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'โปรดลบคำต่อไปนี้เพราะมันไม่สามารถนำมาใช้สำหรับการเลือกตั๋ว:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'ต้องการ WebserviceID!',
        'Could not get data for WebserviceID %s' => 'ไม่สามารถรับข้อมูลสำหรับ WebserviceID %s',
        'ascending' => '',
        'descending' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '',
        'Invalid Subaction!' => '',
        'Need ErrorHandlingType!' => '',
        'ErrorHandlingType %s is not registered' => '',
        'Could not update web service' => '',
        'Need ErrorHandling' => '',
        'Could not determine config for error handler %s' => '',
        'Invoker processing outgoing request data' => '',
        'Mapping outgoing request data' => '',
        'Transport processing request into response' => '',
        'Mapping incoming response data' => '',
        'Invoker processing incoming response data' => '',
        'Transport receiving incoming request data' => '',
        'Mapping incoming request data' => '',
        'Operation processing incoming request data' => '',
        'Mapping outgoing response data' => '',
        'Transport sending outgoing response data' => '',
        'skip same backend modules only' => '',
        'skip all modules' => '',
        'Operation deleted' => '',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '',
        '15 seconds' => '',
        '30 seconds' => '',
        '45 seconds' => '',
        '1 minute' => '',
        '2 minutes' => '',
        '3 minutes' => '',
        '4 minutes' => '',
        '5 minutes' => '',
        '10 minutes' => '10 นาที',
        '15 minutes' => '15 นาที',
        '30 minutes' => '',
        '1 hour' => '',
        '2 hours' => '',
        '3 hours' => '',
        '4 hours' => '',
        '5 hours' => '',
        '6 hours' => '',
        '12 hours' => '',
        '18 hours' => '',
        '1 day' => '',
        '2 days' => '',
        '3 days' => '',
        '4 days' => '',
        '6 days' => '',
        '1 week' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'ไม่สามารถตรวจสอบการตั้งค่าสำหรับผู้ร้องขอ %s',
        'InvokerType %s is not registered' => 'ไม่ได้ลงทะเบียน InvokerType %s',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => 'ไม่สามารถอัปเดตข้อมูลการกำหนดค่าสำหรับ WebserviceID %s',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => 'String',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'ไม่สามารถรับการกำหนดค่าลงทะเบียนสำหรับประเภทการกระทำ% s',
        'Could not get backend for %s %s' => 'ไม่สามารถรับแบ็กเอนด์สำหรับ %s %s',
        'Keep (leave unchanged)' => 'เก็บ (ปล่อยไม่มีการเปลี่ยนแปลง)',
        'Ignore (drop key/value pair)' => 'ละเว้น (ดรอปคีย์ / ค่าคู่)',
        'Map to (use provided value as default)' => 'แผนที่ (การใช้งานที่มีให้คุ้มค่าเป็นค่าเริ่มต้น)',
        'Exact value(s)' => 'ค่าที่แน่นอน(s)',
        'Ignore (drop Value/value pair)' => 'ละเว้น (ดรอปค่า / ค่าคู่)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => 'ไม่พบไลบรารีที่จำเป็น %s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '',
        'Incoming request data before mapping (ProviderRequestInput)' => '',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'ไม่สามารถตรวจสอบการตั้งค่าสำหรับการดำเนินการ %s',
        'OperationType %s is not registered' => 'ไม่ได้ลงทะเบียน OperationType %s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'มีweb serviceอื่นที่มีชื่อเดียวกัน',
        'There was an error updating the web service.' => 'มีข้อผิดพลาดในการอัพเดท web service.',
        'There was an error creating the web service.' => 'มีข้อผิดพลาดในการสร้าง web service.',
        'Web service "%s" created!' => 'สร้าง Web service "%s" แล้ว',
        'Need Name!' => 'ต้องการชื่อ!',
        'Need ExampleWebService!' => 'ต้องการ ExampleWebService!',
        'Could not load %s.' => '',
        'Could not read %s!' => 'ไม่สามารถอ่าน%s!',
        'Need a file to import!' => 'ต้องการไฟล์ที่จะนำเข้า!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'ไฟล์ที่นำเข้ามีเนื้อหา YAML ที่ไม่ถูกต้อง! โปรดตรวจสอบบันทึก OTRS สำหรับรายละเอียด',
        'Web service "%s" deleted!' => 'ลบ Web service "%s" แล้ว',
        'OTRS as provider' => 'OTRS เป็นผู้ให้บริการ',
        'Operations' => '',
        'OTRS as requester' => 'OTRS เป็นผู้ร้องขอ',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'ไม่มี WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'ไม่สามารถได้รับข้อมูลประวัติศาสตร์สำหรับ WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'อัปเดตกลุ่มแล้ว!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'เพิ่มบัญชีอีเมลแล้ว!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'ส่งโดยการส่งอีเมล์ไปที่: ฟิลด์',
        'Dispatching by selected Queue.' => 'ส่งโดยคิวที่เลือก',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => 'เอเย่นต์ผู้ที่เป็นเจ้าของตั๋ว',
        'Agent who is responsible for the ticket' => 'เอเย่นต์ที่เป็นผู้รับผิดชอบตั๋ว',
        'All agents watching the ticket' => 'เอเย่นต์ทั้งหมดดูตั๋ว',
        'All agents with write permission for the ticket' => 'เอเย่นต์ทั้งหมดที่มีสิทธิ์ในการเขียนสำหรับตั๋ว',
        'All agents subscribed to the ticket\'s queue' => 'เอเย่นต์ทั้งหมดถูกจัดไปยังคิวของตั๋ว',
        'All agents subscribed to the ticket\'s service' => 'เอเย่นต์ทั้งหมดถูกจัดไปยังการบริการของตั๋ว',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'เอเย่นต์ทั้งหมดถูกจัดไปยังคิวและการบริการของตั๋ว',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => 'ระบบของคุณประสบความสำเร็จในการอัพเกรดเปน % s',
        'There was a problem during the upgrade to %s.' => 'มีปัญหาเกิดขึ้นระหว่างการอัพเกรดเป็น% s',
        '%s was correctly reinstalled.' => '% s ได้รับการติดตั้งอย่างถูกต้อง',
        'There was a problem reinstalling %s.' => 'มีปัญหาในการติดตั้งอีกครั้ง% s',
        'Your %s was successfully updated.' => '% s ของคุณอัพเดตเรียบร้อยแล้ว',
        'There was a problem during the upgrade of %s.' => 'มีปัญหาเกิดขึ้นระหว่างการอัพเกรดของ% s',
        '%s was correctly uninstalled.' => '% sได้ยกเลิกการติดตั้งอย่างถูกต้อง',
        'There was a problem uninstalling %s.' => 'มีปัญหาในการถอนการติดตั้ง% s ',

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
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'แพคเกจยังไม่ได้รับการตรวจสอบโดยกลุ่ม OTRS! ขอแนะนำไม่ให้ใช้แพคเกจนี้',
        'Not Started' => '',
        'Updated' => '',
        'Already up-to-date' => '',
        'Installed' => '',
        'Not correctly deployed' => '',
        'Package updated correctly' => '',
        'Package was already updated' => '',
        'Dependency installed correctly' => '',
        'The package needs to be reinstalled' => '',
        'The package contains cyclic dependencies' => '',
        'Not found in on-line repositories' => '',
        'Required version is higher than available' => '',
        'Dependencies fail to upgrade or install' => '',
        'Package could not be installed' => '',
        'Package could not be upgraded' => '',
        'Repository List' => '',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            'ไม่ได้ตรวจสอบแพคเกจเนื่องจากปัญหาการสื่อสารกับเซิร์ฟเวอร์การตรวจสอบ!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์คุณสมบัติ OTRS ที่อยู่ในรายการAdd-on !',
        'Can\'t get OTRS Feature Add-on list from server!' => 'ไม่สามารถได้รับคุณสมบัติของเซิร์ฟเวอร์ OTRS ที่อยู่ในรายการAdd-on !',
        'Can\'t get OTRS Feature Add-on from server!' => 'ไม่สามารถได้รับคุณสมบัติ OTRS Add-on จากเซิร์ฟเวอร์!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'ไม่มีตัวกรองดังกล่าว:% s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'เพิ่มลำดับความสำคัญ!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'ข้อมูลการจัดการกระบวนการจากฐานข้อมูลไม่ได้อยู่ในซิงค์กับการกำหนดค่าระบบกรุณาเชื่อมต่อกระบวนการทั้งหมด',
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
        'Queue updated!' => 'อัปเดตคิวแล้ว!',
        'Don\'t use :: in queue name!' => 'อย่าใช้ :: ในคิวชื่อ!',
        'Click back and change it!' => 'คลิกกลับและเปลี่ยนมัน!',
        '-none-' => '-ไม่มี-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'คิว (ที่ไม่ต้องใช้การตอบสนองอัตโนมัติ)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'เปลี่ยนความสัมพันธ์ของคิวสำหรับแม่แบบ',
        'Change Template Relations for Queue' => 'เปลี่ยนความสัมพันธ์ของแม่แบบสำหรับคิว',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'การผลิต',
        'Test' => '',
        'Training' => 'การฝึกอบรม',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'อัปเดตบทบาทแล้ว!',
        'Role added!' => 'เพิ่มบทบาทแล้ว!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'เปลี่ยนความสัมพันธ์ของกลุ่มสำหรับบทบาท',
        'Change Role Relations for Group' => 'เปลี่ยนความสัมพันธ์ของบทบาทสำหรับกลุ่ม',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'เปลี่ยนความสัมพันธ์ของบทบาทสำหรับเอเย่นต์',
        'Change Agent Relations for Role' => 'เปลี่ยนความสัมพันธ์ของเอเย่นต์สำหรับบทบาท',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'กรุณาเปิดใช้งาน %s ก่อน!',

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
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'เพิ่มคำขึ้นต้น!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'อัพเดตลายเซ็นแล้ว!',
        'Signature added!' => 'เพิ่มลายเซ็นแล้ว!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'เพิ่มสถานภาพแล้ว!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'ไม่สามารถอ่าน ไฟล์ %s!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'เพิ่มระบบที่อยู่อีเมล์!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'การนำเข้าไม่ได้รับอนุญาต!',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            '',
        'Category Search' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to lock the setting!' => '',
        'System was not able to reset the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => '',
        'Missing Settings!' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'วันที่เริ่มต้นไม่ควรกำหนดหลังจากวันหยุด!',
        'There was an error creating the System Maintenance' => 'มีข้อผิดพลาดในการสร้างการบำรุงรักษาระบบ',
        'Need SystemMaintenanceID!' => 'ต้องการ SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'ไม่สามารถรับข้อมูลสำหรับ SystemMaintenanceID %s',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => 'เซสชั่นถูกทำลายแล้ว!',
        'All sessions have been killed, except for your own.' => 'ทำลายเซสชันทั้งหมดแล้วยกเว้นเซสชันของคุณ',
        'There was an error updating the System Maintenance' => 'มีข้อผิดพลาดในการอัพเดตการบำรุงรักษาระบบ',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'ไม่สามารถลบการเข้าของ ystemMaintenance: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'อัพเดตแม่แบบแล้ว!',
        'Template added!' => 'เพิ่มแม่แบบแล้ว!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'เปลี่ยนความสัมพันธ์ของสิ่งที่แนบมาสำหรับแม่แบบ',
        'Change Template Relations for Attachment' => 'เปลี่ยนความสัมพันธ์ของแม่แบบสำหรับสิ่งที่แนบมา',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'ต้องการประเภท!',
        'Type added!' => 'เพิ่มประเภทแล้ว!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'อัปเดตเอเย่นต์แล้ว',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'เปลี่ยนความสัมพันธ์ของกลุ่มสำหรับเอเย่นต์',
        'Change Agent Relations for Group' => 'เปลี่ยนความสัมพันธ์ของเอเย่นต์สำหรับกลุ่ม',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'เดือน',
        'Week' => '',
        'Day' => 'วัน',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '',
        'Appointments assigned to me' => '',
        'Showing only appointments assigned to you! Change settings' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '',
        'Never' => '',
        'Every Day' => '',
        'Every Week' => '',
        'Every Month' => '',
        'Every Year' => '',
        'Custom' => '',
        'Daily' => '',
        'Weekly' => '',
        'Monthly' => '',
        'Yearly' => '',
        'every' => '',
        'for %s time(s)' => '',
        'until ...' => '',
        'for ... time(s)' => '',
        'until %s' => '',
        'No notification' => '',
        '%s minute(s) before' => '',
        '%s hour(s) before' => '',
        '%s day(s) before' => '',
        '%s week before' => '',
        'before the appointment starts' => '',
        'after the appointment has been started' => '',
        'before the appointment ends' => '',
        'after the appointment has been ended' => '',
        'No permission!' => '',
        'Cannot delete ticket appointment!' => '',
        'No permissions!' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'ประวัติของลูกค้า',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'ไม่มีการตั้งค่าดังกล่าวสำหรับ %s',
        'Statistic' => 'สถิติ',
        'No preferences for %s!' => 'ไม่มีการกำหนดลักษณะสำหรับ %s!',
        'Can\'t get element data of %s!' => 'ไม่สามารถรับองค์ประกอบของข้อมูลของ %s!',
        'Can\'t get filter content data of %s!' => 'ไม่สามารถรับข้อมูลกรองเนื้อหา',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'ต้องการ SourceObject และ SourceKey!',
        'You need ro permission!' => 'คุณจำเป็นต้องได้รับอนุญาต',
        'Can not delete link with %s!' => 'ไม่สามารถลบการเชื่อมโยงด้วย %s!',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => 'ไม่สามารถสร้างการเชื่อมโยงด้วย %s!',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => 'ออบเจคนี้ %s ไม่สามารถเชื่อมโยงกับออบเจคอื่น ๆ !',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'ต้องระบุกลุ่มพารามิเตอร์!',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'ตั๋วกระบวนการ',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'พารามิเตอร์ %s ขาดหายไป',
        'Invalid Subaction.' => 'Subaction ไม่ถูกต้อง!',
        'Statistic could not be imported.' => 'ไม่สามารถนำสถิติเข้ามาได้',
        'Please upload a valid statistic file.' => 'กรุณาอัปโหลดไฟล์สถิติที่ถูกต้อง',
        'Export: Need StatID!' => 'ส่งออก: ต้องการ StatID!',
        'Delete: Get no StatID!' => 'ลบ: ไม่ได้รับ StatID!',
        'Need StatID!' => 'ต้องการ StatID!',
        'Could not load stat.' => 'ไม่สามารถโหลดสถิติ',
        'Add New Statistic' => 'เพิ่มสถิติใหม่',
        'Could not create statistic.' => 'ไม่สามารถสร้างสถิติ',
        'Run: Get no %s!' => 'รัน: ไม่ได้รับ %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'ไม่ได้รับ TicketID!',
        'You need %s permissions!' => 'คุณจำเป็นต้องได้ %s รับอนุญาต!',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'ขออภัยคุณต้องเป็นเจ้าของตั๋วเพื่อดำเนินการ',
        'Please change the owner first.' => 'กรุณาเปลี่ยนผู้เป็นเจ้าของก่อน',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => 'ไม่สามารถดำเนินการตรวจสอบในช่อง!',
        'No subject' => 'ไม่มีหัวข้อ',
        'Could not delete draft!' => '',
        'Previous Owner' => 'เจ้าของคนก่อนหน้านี้',
        'wrote' => 'เขียน',
        'Message from' => 'ข้อความจาก',
        'End message' => 'ข้อความตอนท้าย',

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
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '',
        'Bulk feature is not enabled!' => 'ฟีเจอร์ Bulk ไม่ได้เปิดใช้งาน!',
        'No selectable TicketID is given!' => 'ไม่ได้รับ TicketID ที่เลือกไว้!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'ที่อยู่% s แทนที่ด้วยที่อยู่ของลูกค้าที่ลงทะเบียน',
        'Customer user automatically added in Cc.' => 'ผู้ใช้ลูกค้าถูกเพิ่มโดยอัตโนมัติใน  Cc',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'สร้างตั๋ว "%s" แล้ว!',
        'No Subaction!' => 'ไม่มี Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'ไม่มี TicketID!',
        'System Error!' => 'ระบบผิดพลาด!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'อาทิตย์ถัดไป',
        'Ticket Escalation View' => 'มุมมองการขยายตั๋ว',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'ส่งต่อข้อความจา',
        'End forwarded message' => 'ข้อความตอนท้ายของข้อความที่ส่งต่อ',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'ไม่สามารถแสดงประวัติ ไม่ได้รับ TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'ไม่สามารถล็อคตั๋ว ไม่ได้รับ TicketIDs!',
        'Sorry, the current owner is %s!' => 'ขออภัยเจ้าของปัจจุบันคือ %s!',
        'Please become the owner first.' => 'กรุณาเป็นเจ้าของคนก่อน',
        'Ticket (ID=%s) is locked by %s!' => 'ตั๋ว (ID=%s) ถูกล็อกโดย %s!',
        'Change the owner!' => 'เปลี่ยนเจ้าของ!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'บทความใหม่',
        'Pending' => 'อยู่ระหว่างดำเนินการ',
        'Reminder Reached' => 'การแจ้งเตือนถึงแล้ว',
        'My Locked Tickets' => 'ตั๋วที่ถูกล็อคของฉัน',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'ไม่สามารถผสานตั๋วด้วยตัวเอง!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'คุณจำเป็นต้องย้ายสิทธิ์!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'แชทยังไม่ทำงาน',
        'No permission.' => 'ไม่มีสิทธิ์',
        '%s has left the chat.' => '%s ได้ออกจากการแชท',
        'This chat has been closed and will be removed in %s hours.' => 'แชทนี้ได้รับการปิดและจะถูกลบออกใน %s ชั่วโมง',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'ตั๋วถูกล็อค',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'ไม่มี ArticleID!',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'ไม่สามารถอ่านบทความธรรมดา! บางทีจะไม่มีอีเมลธรรมดาในแบ็กเอนด์! อ่านข้อความแบ็กเอนด์',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'ต้องการ TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'ไม่สามารถรับ ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'ไม่มีขั้นตอนการกำหนดค่า!',
        'The selected process is invalid!' => 'ขั้นตอนที่เลือกไม่ถูกต้อง!',
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

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'ตั๋วที่สามารถใช้ได้',
        'including subqueues' => 'รวมถึงคิวย่อย',
        'excluding subqueues' => 'ไม่รวมคิวย่อย',
        'QueueView' => 'มุมมองของคิว',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'ตั๋วที่ฉันมีความรับผิดชอบ',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'การค้นหาครั้งสุดท้าย',
        'Untitled' => 'ไม่ได้ตั้งชื่อ',
        'Ticket Number' => 'หมายเลขตั๋ว',
        'Ticket' => 'ตั๋ว',
        'printed by' => 'พิมพ์โดย',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => 'ผู้ใช้ที่ไม่ถูกต้อง',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'ในมากกว่า...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'ฟีเจอร์ไม่ได้เปิดใช้งาน!',
        'Service View' => 'ุมุมมองการบริการ',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'มุมมองสถานภาพ',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'ตั๋วดูแล้วของฉัน',

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
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
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
        'External Chat' => 'แชทภายนอก',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => 'ไม่สามารถรับสำหรับ ArticleID %s!',
        'Article filter settings were saved.' => 'การตั้งค่าบทความตัวกรองถูกบันทึกไว้แล้ว',
        'Event type filter settings were saved.' => 'การตั้งค่าตัวกรองประเภทเหตุการณ์ถูกบันทึกไว้',
        'Need ArticleID!' => 'ต้องการ ArticleID!',
        'Invalid ArticleID!' => 'ArticleID ไม่ถูกต้อง! ',
        'Forward article via mail' => 'ส่งต่อบทความผ่านทางอีเมล',
        'Forward' => 'ส่งต่อ',
        'Fields with no group' => 'ฟิลด์ที่ไม่มีกลุ่ม',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'ไม่สามารถเปิดบทความ! บางทีมันอาจจะอยู่บนหน้าบทความอื่นได้หรือไม่?',
        'Show one article' => 'แสดงหนึ่งบทความ',
        'Show all articles' => 'แสดงบทความทั้งหมด',
        'Show Ticket Timeline View' => 'แสดงมุมมองไทม์ไลน์ตั๋ว',
        'Show Ticket Timeline View (%s)' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => 'ไม่มี TicketID สำหรับ ArticleID (%s)!',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'ต้องการ FileID และ ArticleID',
        'No such attachment (%s)!' => 'ไม่มีสิ่งที่แนบมาดังกล่าว (%s)! ',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'ตรวจสอบการตั้งค่า SysConfig สำหรับ %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'ตรวจสอบการตั้งค่า SysConfig สำหรับ %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'ต้องการ CustomerID!',
        'My Tickets' => 'ตั๋วของฉัน',
        'Company Tickets' => 'ตั๋วของบริษัท',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'ชื่อจริงของลูกค้า',
        'Created within the last' => 'สร้างขึ้นภายในครั้งล่าสุด...',
        'Created more than ... ago' => 'สร้างขึ้นมากกว่า...ที่ผ่านมา',
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
        'Install OTRS' => 'การติดตั้งOTRS',
        'Intro' => 'แนะนำ',
        'Kernel/Config.pm isn\'t writable!' => 'ไม่สามารถเขียน Kernel/Config.pm ได้!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'หากคุณต้องการที่จะใช้การติดตั้ง ตั้งค่า Kernel/Config.pm เป็น สามารถเขียนได้ สำหรับผู้ใช้เว็บเซิร์ฟเวอร์!',
        'Database Selection' => 'การเลือกฐานข้อมูล',
        'Unknown Check!' => 'ไม่รู้จักตรวจสอบ!',
        'The check "%s" doesn\'t exist!' => 'การตรวจสอบ "%s" ไม่อยู่!',
        'Enter the password for the database user.' => 'ป้อนรหัสผ่านสำหรับผู้ใช้ฐานข้อมูล',
        'Database %s' => 'ฐานข้อมูล %s',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'ป้อนรหัสผ่านสำหรับผู้ใช้ฐานข้อมูลในการบริหาร',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => 'ชนิดของฐานข้อมูลที่ไม่รู้จัก "%s".',
        'Please go back.' => '',
        'Create Database' => 'สร้างฐานข้อมูล',
        'Install OTRS - Error' => 'ติดตั้ง OTRS - ข้อผิดพลาด',
        'File "%s/%s.xml" not found!' => 'ไม่พบไฟล์ "%s/%s.xml" ',
        'Contact your Admin!' => 'ติดต่อผู้ดูแลระบบของคุณ!',
        'System Settings' => 'การตั้งค่าระบบ',
        'Syslog' => '',
        'Configure Mail' => 'กำหนดค่าเมล์',
        'Mail Configuration' => 'การกำหนดค่าเมล์',
        'Can\'t write Config file!' => 'ไม่สามารถเขียนไฟล์ config!',
        'Unknown Subaction %s!' => 'Subaction ที่ไม่รู้จัก %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'ไม่สามารถเชื่อมต่อกับฐานข้อมูล,ไม่ได้ติดตั้ง Perl โมดูล DBD::%s!',
        'Can\'t connect to database, read comment!' => 'ไม่สามารถเชื่อมต่อกับฐานข้อมูลกรุณาอ่านความคิดเห็น!',
        'Database already contains data - it should be empty!' => 'ฐานข้อมูลมีข้อมูลอยู่แล้ว - มันควรจะว่างเปล่า!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'ข้อผิดพลาด: โปรดตรวจสอบฐานข้อมูลของคุณว่าสามารถรับแพคเกจได้มากกว่า% s MB (ปัจจุบันรับเฉพาะแพคเกจขนาด% s MB) กรุณาปรับให้เข้าการตั้งค่า max_allowed_packet ของฐานข้อมูลของคุณเพื่อหลีกเลี่ยงข้อผิดพลาด',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'ข้อผิดพลาด: กรุณาระบุค่าสำหรับ innodb_log_file_size ในฐานข้อมูลของคุณอย่างน้อย% s MB (ปัจจุบัน:% s MB แนะนำ:% s MB) สำหรับข้อมูลเพิ่มเติมโปรดดูได้ที่',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '',
        'No such user!' => '',
        'Invalid calendar!' => '',
        'Invalid URL!' => '',
        'There was an error exporting the calendar!' => '',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'ต้องปรับแต่ง Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'การตรวจสอบสิทธิ์ล้มเหลวจาก%s!',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'บทความตีกลับไปยังที่อยู่อีเมลที่แตกต่างกัน',
        'Bounce' => 'การตีกลับ',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'ตอบกลับทั้งหมด',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'ตอบกลับไปยังโน้ต',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'แยกบทความนี้',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'ดูแหล่งที่มาสำหรับบทความนี้',
        'Plain Format' => 'รูปแบบธรรมดา',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'พิมพ์บทความนี้',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'มาร์ค',
        'Unmark' => 'ยกเลิกการมาร์ค',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => '',
        'Re-install Package' => '',
        'Upgrade' => 'อัพเกรด',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Crypted',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'ลงนาม',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => 'พบหัวเรื่อง "PGP SIGNED MESSAGE" แต่ไม่ถูกต้อง',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => 'พบหัวเรื่อง "S/MIME SIGNED MESSAGE" แต่ไม่ถูกต้อง',
        'Ticket decrypted before' => 'ตั๋วถอดรหัสก่อน',
        'Impossible to decrypt: private key for email was not found!' => 'เป็นไปไม่ได้ที่จะถอดรหัส: ไม่พบคีย์ส่วนตัวสำหรับอีเมล!',
        'Successful decryption' => 'การถอดรหัสประสบความสำเร็จ',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => '',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '',
        'PGP sign' => '',
        'PGP sign and encrypt' => '',
        'PGP encrypt' => '',
        'SMIME sign' => '',
        'SMIME sign and encrypt' => '',
        'SMIME encrypt' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '',
        'Sign' => 'ลงนาม',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'แสดงให้เห็น',
        'Refresh (minutes)' => '',
        'off' => 'ปิด',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'ผู้ใช้งานลูกค้าที่แสดงให้เห็น',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',

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
        'Shown Tickets' => 'ตั๋วที่แสดง',
        'Shown Columns' => 'คอลัมน์ที่แสดง',
        'filter not active' => 'ตัวกรองไม่ได้ใช้งาน',
        'filter active' => 'ตัวกรองที่ใช้งาน',
        'This ticket has no title or subject' => 'ตั๋วนี้ไม่มีหัวข้อหรือชื่อเรื่อง',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'สถิติ 7 วัน',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'มาตรฐาน',
        'The following tickets are not updated: %s.' => '',
        'h' => 'ช',
        'm' => 'ด',
        'd' => 'ว',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'นี่คือ',
        'email' => 'อีเมล์',
        'click here' => 'คลิกที่นี้',
        'to open it in a new window.' => 'เพื่อเปิดในหน้าต่างใหม่',
        'Year' => 'ปี',
        'Hours' => 'ชั่วโมง',
        'Minutes' => 'นาที',
        'Check to activate this date' => 'ตรวจสอบเพื่อเปิดใช้งานวันนี้',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'ไม่มีสิทธิ์!',
        'No Permission' => 'ไม่ได้รับอนุญาต',
        'Show Tree Selection' => 'แสดงการเลือก Tree ',
        'Split Quote' => 'แยกการอ้างอิง',
        'Remove Quote' => 'ลบคิว',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'เชื่อมโยงเป็น',
        'Search Result' => 'ผลการค้นหา',
        'Linked' => 'เชื่อมต่อแล้ว',
        'Bulk' => 'จำนวนมาก',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Lite',
        'Unread article(s) available' => 'บทความยังไม่ได้อ่าน (s)ที่สามารถใช้ได้',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => 'เปิดใช้บริการคลาวด์เพื่อเปิดใช้งานคุณสมบัติ OTRS ทั้งหมด!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s อัพเกรดเป็น %s ในขณะนี้! %s',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'ใบอนุญาตสำหรับ% s ของคุณกำลังจะหมดอายุ กรุณาโทรติดต่อกับ% s เพื่อต่อสัญญาของคุณ!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'การอัปเดตสำหรับ% s ของคุณพร้อมใช้งาน แต่มีข้อขัดแย้งกับเวอร์ชั่นเฟรมเวิร์คของคุณ! โปรดอัปเดตเฟรมเวิร์คก่อน!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'เอเย่นต์ออนไลน์:%s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'มีตั๋วที่มีการขยายมากขึ้น!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'ลูกค้าออนไลน์:%s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'OTRS Daemonไม่ทำงาน',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'คุณไม่อยู่ที่สำนักงานที่เปิดใช้งาน คุณต้องการจะปิดการใช้งานหรือไม่?',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'โปรดตรวจสอบว่าคุณได้เลือกอย่างน้อยหนึ่งวิธีการขนส่งสำหรับการแจ้งเตือนที่บังคับใช้',
        'Preferences updated successfully!' => 'อัพเดตการตั้งค่าเรียบร้อยแล้ว!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(อยู่ในขั้นตอน)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'โปรดระบุวันที่สิ้นสุดหลังจากวันที่เริ่มต้น',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'รหัสผ่านปัจจุบัน',
        'New password' => 'รหัสผ่านใหม่',
        'Verify password' => 'ยืนยันรหัสผ่าน',
        'The current password is not correct. Please try again!' => 'รหัสผ่านปัจจุบันไม่ถูกต้อง กรุณาลองอีกครั้ง!',
        'Please supply your new password!' => 'กรุณาใส่รหัสผ่านใหม่ของคุณ!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'ไม่สามารถอัพเดตรหัสผ่าน เนื่องจากรหัสผ่านใหม่ของคุณไม่ตรงกัน กรุณาลองอีกครั้ง!',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'ไม่สามารถอัพเดตรหัสผ่าน ต้องมีความยาวอักขระอย่างน้อย% s!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'ไม่สามารถอัพเดตรหัสผ่าน เนื่องจากต้องมีตัวเลขอย่างน้อย 1 หลัก!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'ถูกต้อง',
        'valid' => 'ถูกต้อง',
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
        'second(s)' => 'วินาที(s)',
        'quarter(s)' => 'ไตรมาส(s)',
        'half-year(s)' => 'ครึ่งปี(s)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'โปรดลบคำต่อไปนี้เพราะมันไม่สามารถที่จะใช้สำหรับการจำกัดตั๋ว:% s',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'เนื้อหา',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'ปลดล็อคเพื่อส่งกลับไปที่คิว',
        'Lock it to work on it' => 'ล็อคไว้เพื่อทำงานกับมัน',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'ยังไม่ได้ดู',
        'Remove from list of watched tickets' => 'ลบออกจากรายการของตั๋วที่ดูแล้ว',
        'Watch' => 'ดู',
        'Add to list of watched tickets' => 'เพิ่มไปยังรายการของตั๋วที่ดูแล้ว',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'จัดเรียงโดย',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'ข้อมูลของตั๋ว',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'ตั๋วล็อคใหม่',
        'Locked Tickets Reminder Reached' => 'การแจ้งเตือนการล็อคตั๋วมาถึงแล้ว',
        'Locked Tickets Total' => 'จำนวนรวมตั๋วล็อค',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'ผู้รับผิดชอบตั๋วใหม่',
        'Responsible Tickets Reminder Reached' => 'การแจ้งเตือนผู้รับผิดชอบตั๋วมาถึงแล้ว',
        'Responsible Tickets Total' => 'จำนวนรวมของตั๋วที่มีความรับผิดชอบ',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'ตั๋วใหม่ที่ดูแล้ว',
        'Watched Tickets Reminder Reached' => 'การแจ้งเตือนตั๋วที่ดูแล้วมาถึงแล้ว',
        'Watched Tickets Total' => 'จำนวนรวมของตั๋วที่ดูแล้ว',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'ฟิลด์ตั๋วแบบไดนามิก',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'ยังไม่สามารถเข้าสู่ระบบในตอนนี้เนื่องจากการบำรุงรักษาระบบที่กำหนด',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session limit reached! Please try again later.' => 'เซสชั่นถึงขีดจำกัด! กรุณาลองใหม่อีกครั้งในภายหลัง.',
        'Session per user limit reached!' => 'เซสชั่นต่อขีดจำกัดของผู้ใช้!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'เซสชั่นที่ไม่ถูกต้อง กรุณาเข้าสู่ระบบอีกครั้ง',
        'Session has timed out. Please log in again.' => 'เซสชั่นได้หมดเวลา กรุณาเข้าสู่ระบบอีกครั้ง',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'ตัวเลือกการกำหนดค่าอ้างอิง',
        'This setting can not be changed.' => 'ไม่สามารถเปลี่ยนแปลงการตั้งค่านี้ได้',
        'This setting is not active by default.' => 'การตั้งค่านี้ยังไม่ทำงานโดยค่าเริ่มต้น',
        'This setting can not be deactivated.' => 'ไม่สามารถปิดการใช้งานการตั้งค่านี้',
        'This setting is not visible.' => '',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'ก่อน/หลัง',
        'between' => 'ระหว่าง',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'ต้องการฟิลด์นี้หรือ',
        'The field content is too long!' => 'เนื้อหาในฟิลด์ยาวเกินไป',
        'Maximum size is %s characters.' => 'จำนวนที่มากที่สุดคือ %s ตัวอักษร',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'ไม่ได้ติดตั้ง',
        'installed' => 'ติดตั้งแล้ว',
        'Unable to parse repository index document.' => 'ไม่สามารถที่จะแยกพื้นที่เก็บข้อมูลเอกสารดัชนี',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'ไม่พบแพคเกจสำหรับเฟรมเวิร์คของคุณในพื้นที่เก็บข้อมูลนี้ มีเพียงแพคเกจสำหรับเฟรมเวิร์ครุ่นอื่นๆ',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'ไม่ทำงาน',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'ไม่สามารถติดต่อกับเซิร์ฟเวอร์ลงทะเบียน กรุณาลองใหม่อีกครั้งในภายหลัง.',
        'No content received from registration server. Please try again later.' =>
            'ไม่มีเนื้อหาที่ได้รับจากเซิร์ฟเวอร์ลงทะเบียนกรุณาลองใหม่อีกครั้งในภายหลัง.',
        'Can\'t get Token from sever' => 'ไม่สามารถได้รับ Token จากเซิร์ฟเวอร์',
        'Username and password do not match. Please try again.' => 'ชื่อผู้ใช้และรหัสผ่านไม่ตรงกัน กรุณาลองอีกครั้ง.',
        'Problems processing server result. Please try again later.' => 'ปัญหาการประมวลผลผลจากเซิร์ฟเวอร์ กรุณาลองใหม่อีกครั้งในภายหลัง.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '',
        'week' => 'อาทิตย์',
        'quarter' => 'ไตรมาส',
        'half-year' => 'ครึ่งปี',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'ประเภทสถานะ',
        'Created Priority' => 'ลำดับความสำคัญถูกสร้างแล้ว',
        'Created State' => 'สถานะถูกสร้างแล้ว',
        'Create Time' => 'เวลาที่สร้าง',
        'Pending until time' => '',
        'Close Time' => 'เวลาที่ปิด',
        'Escalation' => 'การขยาย',
        'Escalation - First Response Time' => 'การขยาย - เวลาที่ตอบสนองครั้งแรก',
        'Escalation - Update Time' => 'การขยาย - เวลาการปรับปรุง',
        'Escalation - Solution Time' => 'การขยาย - เวลาการแก้ปัญหา',
        'Agent/Owner' => 'เอเย่นต์/เจ้าของ',
        'Created by Agent/Owner' => 'สร้างโดย เอเย่นต์/เจ้าของ',
        'Assigned to Customer User Login' => '',

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
        'Attributes to be printed' => 'แอตทริบิวต์ที่จะพิมพ์',
        'Sort sequence' => 'เรียงลำดับ',
        'State Historic' => 'ประวัติสถานะ',
        'State Type Historic' => 'ประวัติประเภทสถานะ',
        'Historic Time Range' => 'ช่วงเวลาของประวัติ',
        'Number' => 'หมายเลข',
        'Last Changed' => '',

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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

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
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'ตารางชุดรหัสอักขระ',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'ขนาดInnoDB Log File',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'การตั้งค่า innodb_log_file_size ต้องมีขนาดอย่างน้อย256 MB',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'ขนาดสูงสุดของ Query',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'การตั้งค่า client_encoding จะต้องเป็น UNICODE หรือ UTF8',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'การตั้งค่า server_encoding จะต้องเป็น UNICODE หรือ UTF8',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'รูปแบบวันที่',
        'Setting DateStyle needs to be ISO.' => 'การตั้งค่า DateStyle จะต้องเป็น ISO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

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
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'ระบบการโหลด',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'ระบบโหลดที่ควรจะอยู่ที่จำนวนสูงสุดของซีพียูที่ระบบจะมีได้ (เช่นค่าโหลด 8 หรือน้อยลงในระบบที่มีซีพียู 8 เป็น OK)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'โมดูลPerl',
        'Not all required Perl modules are correctly installed.' => 'ไม่มีการติดตั้งอย่างถูกต้องโมดูล Perl ที่ร้องขอทั้งหมด',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'พื้นที่การแลกเปลี่ยนฟรี (%)',
        'No swap enabled.' => 'ไม่มีการเปิดใช้งานการแลกเปลี่ยน',
        'Used Swap Space (MB)' => 'พื้นที่การแลกเปลี่ยนที่ถูกใช้ (MB)',
        'There should be more than 60% free swap space.' => 'พื้นที่การแลกเปลี่ยนฟรีควรจะมีมากกว่า 60%',
        'There should be no more than 200 MB swap space used.' => 'พื้นที่การแลกเปลี่ยนที่ถูกใช้ควรจะมีมากกว่า 200 MB ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => 'OTRS',
        'Article Search Index Status' => '',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '',
        'Outgoing communications' => '',
        'Failed communications' => '',
        'Average processing time of communications (s)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (ชื่อโดเมน)',
        'Please configure your FQDN setting.' => 'โปรดกำหนดการตั้งค่า FQDN ของคุณ',
        'Domain Name' => 'ชื่อโดเมน',
        'Your FQDN setting is invalid.' => 'การตั้งค่า FQDN คุณไม่ถูกต้อง',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'ระบบไฟล์สามารถเขียนได้',
        'The file system on your OTRS partition is not writable.' => 'ระบบไฟล์ในการแบ่งOTRS ของคุณไม่สามารถเขียนได้',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

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
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

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
        'OTRS time zone' => '',
        'OTRS time zone is not set.' => '',
        'User default time zone' => '',
        'User default time zone is not set.' => '',
        'Calendar time zone is not set.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => '',
        'Agents using favourites for the admin overview' => '',

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
        'OK' => 'โอเค',
        'Problem' => 'ปัญหา',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '',
        'Setting %s is not locked to this user!' => '',
        'Setting value is not valid!' => '',
        'Could not add modified setting!' => '',
        'Could not update modified setting!' => '',
        'Setting could not be unlocked!' => '',
        'Missing key %s!' => '',
        'Invalid setting: %s' => '',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => '',
        'All Settings' => '',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'เริ่มต้น',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '',
        'Disabled' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'รีเซ็ตหรือปลดล็อคเวลา',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            'เข้าระบบลงล้มเหลว! ชื่อผู้ใช้หรือรหัสผ่านของคุณไม่ถูกต้อง',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'ออกจากระบบประสบความสำเร็จ',
        'Feature not active!' => 'ฟีเจอร์ใช้งานไม่ได้!',
        'Sent password reset instructions. Please check your email.' => 'ได้ส่งคำแนะนำสำหรับการรีเซ็ตรหัสผ่านแล้ว กรุณาตรวจสอบอีเมลของคุณ',
        'Invalid Token!' => 'Token ไม่ถูกต้อง!',
        'Sent new password to %s. Please check your email.' => 'รหัสผ่านใหม่ถูกส่งไปยัง% s กรุณาตรวจสอบอีเมลของคุณ',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => 'ไม่มีการอนุญาตให้ใช้โมดูลส่วนหน้านี้!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'อีเมลนี้มีอยู่แล้วกรุณาเข้าสู่ระบบหรือรีเซ็ตรหัสผ่านของคุณ',
        'This email address is not allowed to register. Please contact support staff.' =>
            'ที่อยู่อีเมลนี้ไม่ได้รับอนุญาตให้ลงทะเบียน กรุณาติดต่อเจ้าหน้าที่ฝ่ายสนับสนุน',
        'Added via Customer Panel (%s)' => 'เพิ่มผ่านแผงลูกค้า (%s)',
        'Customer user can\'t be added!' => 'ผู้ใช้ลูกค้าไม่สามารถเพิ่ม!',
        'Can\'t send account info!' => 'ไม่สามารถส่งข้อมูลบัญชี!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'สร้างบัญชีใหม่เรียบร้อยแล้ว ข้อมูลส่งเข้าสู่ระบบไปยัง% s กรุณาตรวจสอบอีเมลของคุณ',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'ไม่พบการกระทำ "%s"!',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'ไม่ถูกต้องชั่วคราว',
        'Group for default access.' => 'กลุ่มสำหรับการเข้าถึงเริ่มต้น',
        'Group of all administrators.' => 'กลุ่มของผู้บริหารทั้งหมด',
        'Group for statistics access.' => 'กลุ่มสำหรับการเข้าถึงสถิติ',
        'new' => 'ใหม่',
        'All new state types (default: viewable).' => 'ประเภทสถานะใหม่ทั้งหมด (ค่าเริ่มต้น: สามารถดูได้)',
        'open' => 'เปิด',
        'All open state types (default: viewable).' => 'ประเภทสถานะเปิดทั้งหมด (ค่าเริ่มต้น: สามารถดูได้)',
        'closed' => 'ปิด',
        'All closed state types (default: not viewable).' => 'ประเภทสถานะปิดทั้งหมด (ค่าเริ่มต้น: ไม่สามารถดูได้)',
        'pending reminder' => 'การแจ้งเตือนที่ค้างอยู่',
        'All \'pending reminder\' state types (default: viewable).' => 'ประเภทสถานะ \'ค้างอยู่แบบแจ้งเตือน\' ทั้งหมด (ค่าเริ่มต้น: สามารถดูได้)',
        'pending auto' => 'อยู่ระหว่างดำเนินการอัตโนมัติ',
        'All \'pending auto *\' state types (default: viewable).' => 'ประเภทสถานะ \'ค้างอัตโนมัติ\' ทั้งหมด (ค่าเริ่มต้น: สามารถดูได้)',
        'removed' => 'ลบออก',
        'All \'removed\' state types (default: not viewable).' => 'ประเภทสถานะ \'ถูกลบออก\' ทั้งหมด (ค่าเริ่มต้น: ไม่สามารถดูได้)',
        'merged' => 'ผสาน',
        'State type for merged tickets (default: not viewable).' => 'ประเภทสถานะสำหรับตั๋วที่ถูกผสาน (ค่าเริ่มต้น: ไม่สามารถดูได้)',
        'New ticket created by customer.' => 'ตั๋วใหม่ที่สร้างขึ้นโดยลูกค้า',
        'closed successful' => 'การปิดที่ประสบความสำเร็จ',
        'Ticket is closed successful.' => 'ตั๋วถูกปิดด้วยความสำเร็จ',
        'closed unsuccessful' => 'การปิดที่ไม่ประสบความสำเร็จ',
        'Ticket is closed unsuccessful.' => 'ตั๋วถูกปิดไม่สำเร็จ',
        'Open tickets.' => 'เปิดตั๋ว',
        'Customer removed ticket.' => 'ลูกค้าลบตั๋วออก',
        'Ticket is pending for agent reminder.' => 'ตั๋วค้างอยู่สำหรับแจ้งเตือนเอเย่นต์',
        'pending auto close+' => 'อยู่ระหว่างดำเนินการปิดอัตโนมัติ +',
        'Ticket is pending for automatic close.' => 'ตั๋วค้างอยู่สำหรับปิดอัตโนมัติ',
        'pending auto close-' => 'อยู่ระหว่างดำเนินการปิดอัตโนมัติ -',
        'State for merged tickets.' => 'สถานะสำหรับตั๋วที่ถูกผสาน',
        'system standard salutation (en)' => 'ระบบคำขึ้นต้นมาตรฐาน (en)',
        'Standard Salutation.' => 'คำขึ้นต้นมาตรฐาน',
        'system standard signature (en)' => 'ระบบลายเซ็นมาตรฐาน (en)',
        'Standard Signature.' => 'ลายเซ็นมาตรฐาน',
        'Standard Address.' => 'ที่อยู่มาตรฐาน',
        'possible' => 'ความเป็นไปได้',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'การติดตามตั๋วที่ปิดแล้วเป็นไปได้ที่ตั๋วจะถูกเปิด',
        'reject' => 'ปฏิเสธ',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'เป็นไปไม่ได้ที่จะติดตามตั๋วที่ปิดแล้วและไม่มีการสร้างตั๋วใหม่',
        'new ticket' => 'ตั๋วใหม่',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'คิวPostmaster',
        'All default incoming tickets.' => 'ตั๋วเริ่มต้นขาเข้าทั้งหมด',
        'All junk tickets.' => 'ตั๋วขยะทั้งหมด',
        'All misc tickets.' => 'ตั๋ว miscทั้งหมด',
        'auto reply' => 'ตอบกลับอัตโนมัติ',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'การตอบกลับอัตโนมัติจะถูกส่งออกมาหลังจากที่ตั๋วใหม่ถูกสร้างขึ้น',
        'auto reject' => 'ปฏิเสธอัตโนมัติ',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'การปฏิเสธอัตโนมัติจะถูกส่งออกมาหลังจากที่การติดตามถูกปฏิเสธ (ในกรณีที่ตัวเลือกคิวติดตามคือ "ปฏิเสธ")',
        'auto follow up' => 'ติดตามอัตโนมัติ',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'การยืนยันอัตโนมัติจะถูกส่งออกมาหลังจากที่การติดตามได้รับตั๋ว (ในกรณีที่ตัวเลือกคิวติดตามคือ "เป็นไปได้")',
        'auto reply/new ticket' => 'ตอบกลับอัตโนมัติ/ตั๋วใหม่',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'การตอบสนองอัตโนมัติจะถูกส่งออกมาหลังจากที่การติดตามถูกปฏิเสธและตั๋วใหม่ถูกสร้างขึ้น (ในกรณีที่ตัวเลือกคิวติดตามคือ "ตั๋วใหม่")',
        'auto remove' => 'ลบออกอัตโนมัติ',
        'Auto remove will be sent out after a customer removed the request.' =>
            'การลบอัตโนมัติจะถูกส่งออกมาหลังจากที่ลูกค้าลบการร้องขอออก',
        'default reply (after new ticket has been created)' => 'การตอบกลับเริ่มต้น (หลังจากตั๋วใหม่ถูกสร้างขึ้น)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'การปฏิเสธเริ่มต้น (หลังจากติดตามและปฏิเสธตั๋วปิด)',
        'default follow-up (after a ticket follow-up has been added)' => 'การติดตามเริ่มต้น (หลังจากตั๋วติดตามได้รับการเพิ่ม)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'การปฏิเสธเริ่มต้น / ตั๋วใหม่ถูกสร้างขึ้น (หลังจากปิดการติดตามด้วยการสร้างตั๋วใหม่)',
        'Unclassified' => 'ไม่จำแนก',
        '1 very low' => '1 ต่ำมาก',
        '2 low' => '2 ต่ำ',
        '3 normal' => '3 ปกติ',
        '4 high' => '4 สูง',
        '5 very high' => '5 สูงมาก',
        'unlock' => 'ปลดล็อค',
        'lock' => 'ล็อค',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'เอเย่นต์',
        'system' => 'ระบบ',
        'customer' => 'ลูกค้า',
        'Ticket create notification' => 'การแจ้งเตือนการสร้างตั๋ว',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'คุณจะได้รับการแจ้งเตือนทุกครั้งที่ตั๋วใหม่ถูกสร้างขึ้นในหนึ่งของ "คิวของฉัน" หรือ "บริการของฉัน"',
        'Ticket follow-up notification (unlocked)' => 'ตั๋วติดตามการแจ้งเตือน (ปลดล็อค)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'คุณจะได้รับการแจ้งเตือนหากลูกค้าส่งติดตามตั๋วปลดล็อคซึ่งอยู่ใน "คิวของฉัน" หรือ "บริการของฉัน"',
        'Ticket follow-up notification (locked)' => 'ตั๋วติดตามการแจ้งเตือน (ล็อค)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'คุณจะได้รับการแจ้งเตือนหากลูกค้าส่งติดตามตั๋วล็อคที่คุณเป็นเจ้าของตั๋วหรือผู้รับผิดชอบ',
        'Ticket lock timeout notification' => 'การแจ้งเตือนตั๋วล็อคหมดเวลา',
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
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'เพิ่มทั้งหมด',
        'An item with this name is already present.' => 'ไอเท็มที่ใช้ชื่อนี้ได้ถูกนำเสนอแล้ว',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'รายการนี้ยังคงประกอบด้วยรายการย่อย คุณแน่ใจหรือไม่ว่าคุณต้องการลบรายการนี้ซึ่งรวมถึงรายการย่อย?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '',
        'Less' => '',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '',
        'Deleting attachment...' => '',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '',
        'Attachment was deleted successfully.' => '',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'คุณแน่ใจหรือไม่ที่จะลบไดมานิคฟิลด์นี้? ข้อมูลที่เกี่ยวข้องทั้งหมดจะหายไป!',
        'Delete field' => 'ลบฟิลด์',
        'Deleting the field and its data. This may take a while...' => 'การลบฟิลด์และข้อมูล อาจจะใช้เวลาสักครู่ ...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'ลบการคัดเลือก',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'ลบกระตุ้นกิจกรรมนี้',
        'Duplicate event.' => 'กิจกรรมที่ซ้ำกัน',
        'This event is already attached to the job, Please use a different one.' =>
            'กิจกรรมนี้แนบมากับงานเป็นที่เรียบร้อยแล้ว โปรดใช้กิจกรรมอื่นแทน',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'เกิดข้อผิดพลาดในระหว่างการสื่อสาร',
        'Request Details' => 'รายละเอียดการร้องขอ',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'แสดงหรือซ่อนเนื้อหา',
        'Clear debug log' => 'ยกเลิกการบันทึกการแก้ปัญหา',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'ลบผู้ร้องขอนี้',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'ลบคีย์ของการทำแผนที่นี้',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'ลบการดำเนินการนี้',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'โคลนนิ่ง web service',
        'Delete operation' => 'ลบการดำเนินการ',
        'Delete invoker' => 'ลบผู้ร้องขอ',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'คำเตือน: เมื่อคุณเปลี่ยนชื่อของกลุ่ม \'ผู้ดูแลระบบ\' ก่อนที่จะทำการเปลี่ยนแปลงที่เหมาะสมใน sysconfig คุณจะถูกล็อคออกจากแผงการดูแลระบบ!หากเกิดเหตุการณ์นี้กรุณาเปลี่ยนชื่อกลุ่มกลับไปเป็นผู้ดูแลระบบต่อหนึ่งคำสั่ง SQL',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'คุณต้องการที่จะลบภาษาของการแจ้งเตือนนี้หรือไม่?',
        'Do you really want to delete this notification?' => 'คุณต้องการที่จะลบการแจ้งเตือนนี้หรือไม่?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '',
        'Dismiss' => 'ยกเลิก',
        'Update All Packages' => '',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            '',
        'Are you sure you want to update all installed packages?' => '',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'ลบเอ็นติตี้จากผ้าใบ',
        'No TransitionActions assigned.' => 'ไม่มีการดำเนินการเปลี่ยนผ่านที่ได้รับมอบหมาย',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'ยังไม่มีไดอะล็อกที่ได้รับมอบหมาย เพียงแค่เลือกกิจกรรมไดอะล็อกจากรายการทางด้านซ้ายและลากไปที่นี่',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'กิจกรรมนี้ไม่สามารถลบได้เพราะมันเป็นจุดเริ่มต้นของกิจกรรม',
        'Remove the Transition from this Process' => 'ลบการเปลี่ยนผ่านออกจากกระบวนการนี้',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'ทันทีที่คุณจะใช้ปุ่มหรือการเชื่อมโยงนี้คุณจะออกหน้าจอนี้และสถานะปัจจุบันของคุณจะถูกบันทึกไว้โดยอัตโนมัติ คุณต้องการที่จะทำต่อหรือไม่?',
        'Delete Entity' => 'ลบเอ็นติตี้',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'กิจกรรมนี้ถูกใช้แล้วในกระบวนการนี้ คุณไม่สามารถเพิ่มอีกเป็นครั้งที่สอง!',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'การเปลี่ยนผ่านที่ไม่เกี่ยวเนื่องกันถูกวางไว้แล้วบนผ้าใบแล้วโปรดเชื่อมต่อการเปลี่ยนผ่านนี้ก่อนที่จะวางการเปลี่ยนผ่านอื่นๆ',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'การเปลี่ยนผ่านนี้ถูกใช้แล้วในกิจกรรมนี้ คุณไม่สามารถใช้งานสองครั้ง!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'การดำเนินการเปลี่ยนผ่านนี้ถูกใช้แล้วในเส้นทางนี้ คุณไม่สามารถใช้งานสองครั้ง!',
        'Hide EntityIDs' => 'ซ่อน EntityIDs',
        'Edit Field Details' => 'แก้ไขรายละเอียดของฟิลด์',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'ส่งการอัปเดต ...',
        'Support Data information was successfully sent.' => 'ข้อมูลการสนับสนุนถูกส่งเรียบร้อยแล้ว',
        'Was not possible to send Support Data information.' => 'เป็นไปไม่ได้ที่จะส่งข้อมูลของการสนับสนุนข้อมูล',
        'Update Result' => 'ผลการการอัปเดต',
        'Generating...' => 'ผลิต ...',
        'It was not possible to generate the Support Bundle.' => 'มันเป็นไปไม่ได้ที่จะสร้างกลุ่มสนับสนุน',
        'Generate Result' => 'สร้างผลลัพธ์',
        'Support Bundle' => 'กลุ่มสนับสนุน',
        'The mail could not be sent' => 'ไม่สามารถส่งอีเมล',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'กำลังโหลด ...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => '',
        'The deployment is already running.' => '',
        'Deployment successful. You\'re being redirected...' => '',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '',
        'Reset option is required!' => '',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '',
        'Unlock setting.' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'คุณต้องการที่จะลบการบำรุงรักษาระบบที่กำหนดนี้?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'ก่อนหน้า',
        'Resources' => '',
        'Su' => 'อา',
        'Mo' => 'จ',
        'Tu' => 'อ',
        'We' => 'พ',
        'Th' => 'พฤ',
        'Fr' => 'ศ',
        'Sa' => 'ส',
        'This is a repeating appointment' => '',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '',
        'All occurrences' => '',
        'Just this occurrence' => '',
        'Too many active calendars' => '',
        'Please either turn some off first or increase the limit in configuration.' =>
            '',
        'Restore default settings' => '',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'รายการป้อนที่ซ้ำกัน',
        'It is going to be deleted from the field, please try again.' => 'มันจะถูกลบออกจากฟิลด์โปรดลองอีกครั้ง',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'กรุณากรอกค่าอย่างน้อยหนึ่งคำค้นหาหรือ* ในการค้นหาอะไรก็ตาม',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => 'ข้อมูลเกี่ยวกับOTRS Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'กรุณาตรวจสอบฟิลด์ที่ทำเครื่องหมายสีแดงสำหรับปัจจัยการป้อนข้อมูลที่ถูกต้อง',
        'month' => 'เดือน',
        'Remove active filters for this widget.' => 'ลบตัวกรองการใช้งานสำหรับเครื่องมือนี้',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '',
        'Searching for linkable objects. This may take a while...' => '',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '',
        'Do not show this warning again.' => '',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'ขออภัยคุณไม่สามารถปิดการใช้งานวิธีการทั้งหมดสำหรับการแจ้งเตือนที่ระบุว่าเป็นที่บังคับใช้',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'ขออภัยคุณไม่สามารถปิดการใช้งานวิธีการทั้งหมดสำหรับการแจ้งเตือนนี้',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'สลับเป็นโหมดเดสก์ทอป',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'โปรดลบคำต่อไปนี้จากการค้นหาของคุณเนื่องจากไม่สามารถค้นหาได้:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'คุณต้องการที่จะลบสถิตินี้หรือไม่?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'คุณต้องการที่จะดำเนินการต่อหรือไม่?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'ตัวกรองบทความ',
        'Apply' => 'นำไปใช้',
        'Event Type Filter' => 'กิจกรรมของประเภทตัวกรอง',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'เลื่อนแถบนำทาง',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'กรุณาปิดโหมดความเข้ากันได้ใน Internet Explorer!',
        'Find out more' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'สลับเป็นโหมดมือถือ',

        # JS File: Core.App
        'Error: Browser Check failed!' => '',
        'Reload page' => '',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'มีหนึ่งหรือมากกว่าหนึ่งข้อผิดพลาดเกิดขึ้น!',

        # JS File: Core.Installer
        'Mail check successful.' => 'การตรวจสอบอีเมลประสบความสำเร็จ',
        'Error in the mail settings. Please correct and try again.' => 'เกิดข้อผิดพลาดในการตั้งค่าอีเมล กรุณาแก้ไขและลองอีกครั้ง',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'การเลือกวันที่เปิด',
        'Invalid date (need a future date)!' => 'วันที่ไม่ถูกต้อง (ต้องใช้วันที่ในอนาคต)!',
        'Invalid date (need a past date)!' => 'วันที่ไม่ถูกต้อง (ต้องใช้วันที่ผ่านมา)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'ไม่พร้อมใช้งาน',
        'and %s more...' => 'และ %s อื่นๆ...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'ลบทั้งหมด',
        'Filters' => 'ตัวกรอง',
        'Clear search' => 'ลบการค้นหา',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'ถ้าคุณออกจากหน้านี้ หน้าต่างป๊อปอัพทั้งหมดจะถูกปิดด้วยเช่นกัน!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'ป๊อปอัพของหน้าจอนี้เปิดอยู่แล้ว คุณต้องการที่จะปิดมันและโหลดอันนี้แทน?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'ไม่สามารถเปิดหน้าต่างป๊อปอัพ กรุณาปิดการใช้งานตัวบล็อกป๊อปอัพใดๆสำหรับโปรแกรมนี้',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => '',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'ขณะนี้ไม่มีองค์ประกอบให้เลือกจาก',

        # JS File: Core.UI
        'Please only select one file for upload.' => '',
        'Sorry, you can only upload one file here.' => '',
        'Sorry, you can only upload %s files.' => '',
        'Please only select at most %s files for upload.' => '',
        'The following files are not allowed to be uploaded: %s' => '',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '',
        'No space left for the following files: %s' => '',
        'Available space %s of %s.' => '',
        'Upload information' => '',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '',

        # JS File: Core.Language.UnitTest
        'yes' => 'ใช่',
        'no' => 'ไม่',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => '',

        # JS File: OTRSMultiBarChart
        'Grouped' => 'จัดกลุ่ม',
        'Stacked' => 'ซ้อนกัน',

        # JS File: OTRSStackedAreaChart
        'Stream' => 'สตรีม',
        'Expanded' => 'มีการขยาย',

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
        ' 2 minutes' => '2 นาที',
        ' 5 minutes' => '5 นาที',
        ' 7 minutes' => '7 นาที',
        '"Slim" skin which tries to save screen space for power users.' =>
            'สกีน "สลิม" ซึ่งพยายามที่จะประหยัดพื้นที่หน้าจอสำหรับผู้ใช้ไฟฟ้า',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(UserLogin) ชื่อนามสกุล',
        '(UserLogin) Lastname Firstname' => '(UserLogin) ชื่อ นามสกุล',
        '(UserLogin) Lastname, Firstname' => '(UserLogin) ชื่อ นามสกุล',
        '*** out of office until %s (%s d left) ***' => '*** ออกจากสำนักงานจนกว่า %s (%s dซ้าย) ***',
        '0 - Disabled' => '',
        '1 - Available' => '',
        '1 - Enabled' => '',
        '10 Minutes' => '',
        '100 (Expert)' => '100 (เชี่ยวชาญ)',
        '15 Minutes' => '',
        '2 - Enabled and required' => '',
        '2 - Enabled and shown by default' => '',
        '2 - Enabled by default' => '',
        '2 Minutes' => '',
        '200 (Advanced)' => '200 (ขั้นสูง)',
        '30 Minutes' => '',
        '300 (Beginner)' => '300 (ระดับต้น)',
        '5 Minutes' => '',
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
        'Activates support for customer and customer user groups.' => '',
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
        'Add a note to this ticket' => 'เพิ่มโน้ตไปยังตั๋วนี้',
        'Add an inbound phone call to this ticket' => 'เพิ่มโทรศัพท์ขาเข้าในตั๋วนี้',
        'Add an outbound phone call to this ticket' => 'เพิ่มโทรศัพท์ขาออกไปยังตั๋วนี้',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'อีเมลที่เพิ่มเข้ามา %s',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'การเชื่อมโยงถูกเพิ่มไปยังตั๋วแล้ว "%s"',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'การสมัครสมาชิกถูกเพิ่มสำหรับผู้ใช้ "%s".',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'เพิ่มคำต่อท้ายกับปีและเดือนที่เกิดขึ้นจริงไปยังแฟ้มบันทึกของOTRS  แฟ้มบันทึกสำหรับทุกเดือนจะถูกสร้างขึ้น',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'เพิ่มที่อยู่อีเมลของลูกค้าไปยังผู้รับในหน้าจอเขียนตั๋วของอินเตอร์เฟซตัวแทน ที่อยู่อีเมลของลูกค้าจะไม่ถูกเพิ่มถ้าพิมพ์บทความเป็นอีเมลภายใน',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'ผู้ดูแลระบบ',
        'Admin Area.' => 'ส่วนของแอดมิน',
        'Admin Notification' => 'ผู้ดูแลการแจ้งเตือน',
        'Admin area navigation for the agent interface.' => '',
        'Admin modules overview.' => '',
        'Admin.' => '',
        'Administration' => '',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Name' => 'ชื่อเอเย่นต์',
        'Agent Name + FromSeparator + System Address Display Name' => 'ชื่อตัวแทน + FromSeparator + ระบบที่อยู่ของชื่อที่ใช้แสดง',
        'Agent Preferences.' => 'การตั้งค่าตัวแทน',
        'Agent Statistics.' => '',
        'Agent User Search' => '',
        'Agent User Search.' => '',
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
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            '',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            '',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            '',
        'Agents ↔ Groups' => '',
        'Agents ↔ Roles' => '',
        'All CustomerIDs of a customer user.' => '',
        'All attachments (OTRS Business Solution™)' => '',
        'All customer users of a CustomerID' => 'ลูกค้าผู้ใช้ทั้งหมดของ CustomerID',
        'All escalated tickets' => 'ตั๋วการขยายทั้งหมด',
        'All new tickets, these tickets have not been worked on yet' => 'ตั๋วใหม่ทั้งหมดเหล่านี้ยังไม่ได้ถูกทำงาน',
        'All open tickets, these tickets have already been worked on.' =>
            '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'ตั๋วทั้งหมดที่มีการตั้งค่าการแจ้งเตือนซึ่งการแจ้งเตือนวันที่ได้รับแล้ว',
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
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            'อนุญาตให้ลูกค้ากำหนดการบริการตั๋วในอินเตอร์เฟซของลูกค้า',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            'อนุญาตให้การบริการเริ่มต้นเป็นตัวเลือกสำหรับลูกค้าที่มียังไม่มี',
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
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'อนุญาตให้กำหนดสถานะตั๋วใหม่ในหน้าจอการย้ายตั๋วของอินเตอร์เฟซเอเย่นต์',
        'Always show RichText if available' => 'แสดง RichText อยู่เสมอด้วยถ้ามี',
        'Answer' => 'ตอบ',
        'Appointment Calendar overview page.' => '',
        'Appointment Notifications' => '',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            '',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            '',
        'Appointment edit screen.' => '',
        'Appointment list' => '',
        'Appointment list.' => '',
        'Appointment notifications' => '',
        'Appointments' => '',
        'Arabic (Saudi Arabia)' => 'ภาษาอาหรับ (ซาอุดีอาระเบีย)',
        'ArticleTree' => 'ArticleTree',
        'Attachment Name' => 'ชื่อเอกสารที่แนบมา',
        'Automated line break in text messages after x number of chars.' =>
            'แบ่งบรรทัดอัตโนมัติในข้อความหลังจากจำนวนตัวอักษร  x ',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'ล็อคอัตโนมัติและกำหนดเจ้าของไปยังเอเย่นต์ในปัจจุบันหลังจากที่เปิดหน้าจอการย้ายตั๋วของอินเตอร์เฟซเอเย่นต์',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'ล็อคอัตโนมัติและตั้งค่าเจ้าของเป็นเอเย่นต์ปัจจุบันหลังจากถูกเลือกสำหรับการทำงานเป็นกลุ่ม',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'ืกำหนดเจ้าของตั๋วเป็นผู้รับผิดชอบสำหรับมันโดยอัตโนมัติ (ถ้าฟีเจอรตั๋วที่รับผิดชอบเปิดใช้งาน) ทำงานโดยการกระทำของผู้ใช้ที่ล็อกอิน มันไม่ทำงานสำหรับการดำเนินการโดยอัตโนมัติเช่น',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'กำหนดผู้รับผิดชอบตั๋วอัตโนมัติ(หากยังไม่ได้ตั้งค่า) หลังจากที่อัพเดตเจ้าของคนแรก',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => 'รักษาความสมดุลของสกีนสีขาวโดย Felix Niklas (รุ่นบาง)',
        'Balanced white skin by Felix Niklas.' => 'รักษาความสมดุลของสกีนสีขาวโดย Felix Niklas',
        'Based on global RichText setting' => 'ขึ้นอยู่กับการตั้งค่าทั่วไปของ RichText',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'บล็อกอีเมลขาเข้าทั้งหมดที่ไม่มีจำนวนตั๋วที่ถูกต้องในหัวข้อที่มี From: @example.com address.',
        'Bounced to "%s".' => 'ตีกลับไปยัง "%s".',
        'Bulgarian' => 'ภาษาบุลกาเรีย',
        'Bulk Action' => 'ดำเนินการเป็นกลุ่ม',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'ตัวอย่างการติดตั้ง CMD ละเว้นอีเมลที่ CMD ภายนอกส่งกลับเอาท์พุทบางส่วนใน STDOUT (อีเมล์จะถูกส่งเข้าไปยัง STDIN ของ some.bin)',
        'CSV Separator' => 'ตัวคั่น CSV ',
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
        'Calendar manage screen.' => '',
        'Catalan' => 'Catalan',
        'Change password' => 'เปลี่ยนรหัสผ่าน',
        'Change queue!' => 'เปลี่ยนคิว!',
        'Change the customer for this ticket' => 'เปลี่ยนลูกค้าสำหรับตั๋วนี้',
        'Change the free fields for this ticket' => 'เปลี่ยนฟิลด์ฟรีสำหรับตั๋วนี้',
        'Change the owner for this ticket' => 'เปลี่ยนเจ้าของตั๋วนี้',
        'Change the priority for this ticket' => 'เปลี่ยนลำดับความสำคัญสำหรับตั๋วนี้',
        'Change the responsible for this ticket' => 'เปลี่ยนผู้รับผิดชอบสำหรับตั๋วนี้',
        'Change your avatar image.' => '',
        'Change your password and more.' => '',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'เปลี่ยนลำดับความสำคัญจาก "%s" (%s) เป็น "%s" (%s)',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'เปลี่ยนเจ้าของตั๋วเป็นทุกคน (มีประโยชน์สำหรับ ASP) โดยปกติมีเอเย่นต์เท่านั้นที่มีสิทธิ์ในการ RW ในคิวของตั๋วที่จะแสดง',
        'Chat communication channel.' => '',
        'Checkbox' => 'กล่องตรวจสอบ',
        'Checks for articles that needs to be updated in the article search index.' =>
            '',
        'Checks for communication log entries to be deleted.' => '',
        'Checks for queued outgoing emails to be sent.' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'ตรวจสอบ หากอีเมลนั้นๆคือการติดตามตั๋วที่มีอยู่โดยการค้นหาหัวข้อสำหรับจำนวนตั๋วที่ถูกต้อง',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            'ตรวจสอบความพร้อมของOTRS Business Solution™ สำหรับระบบนี้',
        'Checks the entitlement status of OTRS Business Solution™.' => 'ตรวจสอบสถานะด้านสิทธิของOTRS Business Solution™ ',
        'Child' => 'Child',
        'Chinese (Simplified)' => 'ภาษาจีน (ประยุกต์)',
        'Chinese (Traditional)' => 'ภาษาจีน (ดั้งเดิม) ',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => 'วันคริสต์มาสอีฟ',
        'Close' => 'ปิด',
        'Close this ticket' => 'ปิดตั๋วนี้',
        'Closed tickets (customer user)' => 'ตั๋วที่ปิดแล้ว (ลูกค้าผู้ใช้)',
        'Closed tickets (customer)' => 'ตั๋วที่ปิดแล้ว (ลูกค้า)',
        'Cloud Services' => 'การบริการระบบคลาวด์',
        'Cloud service admin module registration for the transport layer.' =>
            'การลงทะเบียนโมดูลบริการดูแลระบบคลาวด์สำหรับชั้นขนส่ง',
        'Collect support data for asynchronous plug-in modules.' => 'เก็บรวบรวมข้อมูลสนับสนุนสำหรับโมดูลปลั๊กอินที่ไม่ตรงกัน',
        'Column ticket filters for Ticket Overviews type "Small".' => 'คอลัมน์ตัวกรองตั๋วสำหรับประเภทภาพรวมตั๋ว "เล็ก ๆ "',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'แสดงความคิดเห็นสำหรับประวัติที่ถูกป้อนใหม่ในอินเตอร์เฟซลูกค้า',
        'Comment2' => 'ความคิดเห็นที่ 2',
        'Communication' => 'การสื่อสาร',
        'Communication & Notifications' => '',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => 'สถานนะของบริษัท',
        'Company Tickets.' => 'ตั๋วบริษัท',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'ชื่อบริษัทที่จะรวมอยู่ในอีเมลขาออกเป็น ส่วนหัว X',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'โมดูล Compat สำหรับ AgentZoom ไปยัง AgentTicketZoom',
        'Complex' => 'ซับซ้อน',
        'Compose' => 'เรียบเรียง',
        'Configure Processes.' => 'กระบวนการกำหนดค่า',
        'Configure and manage ACLs.' => 'กำหนดค่าและจัดการ ACLs',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'กำหนดค่าฐานข้อมูลสะท้อนของ อ่านเท่านั้น ที่คุณต้องการใช้',
        'Configure sending of support data to OTRS Group for improved support.' =>
            'กำหนดค่าการส่งข้อมูลการสนับสนุนให้กับกลุ่มOTRS สำหรับการสนับสนุนที่ดีขึ้น',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'กำหนดค่าว่าหน้าจอใดควรจะแสดงหลังจากที่ตั๋วใหม่ถูกสร้างขึ้น',
        'Configure your own log text for PGP.' => 'กำหนดค่าข้อความบันทึกของคุณสำหรับ PGP',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            'กำหนดค่าค่าเริ่มต้นของการตั้งค่า TicketDynamicField "ชื่อ" จะกำหนดฟิลด์แบบไดนามิกที่จะนำมาใช้ "ค่า" เป็นข้อมูลที่จะถูกตั้งค่าและ "กิจกรรม" จะกำหนดตัวกระตุ้นกิจกรรม กรุณาตรวจสอบคู่มือการพัฒนา (https://doc.otrs.com/doc/) บท "Ticket Event Module".',
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
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'ควบคุมหากตั๋วและบทความค่าสถานะที่มองเห็นได้จะถูกลบออกเมื่อตั๋วถูกเก็บไว้',
        'Converts HTML mails into text messages.' => 'แปลงอีเมล HTML เป็นข้อความ',
        'Create New process ticket.' => 'สร้างตั๋วกระบวนการใหม่',
        'Create Ticket' => '',
        'Create a new calendar appointment linked to this ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'สร้างและจัดการข้อตกลงระดับการให้บริการ (SLAs)',
        'Create and manage agents.' => 'สร้างและจัดการกับเอเย่นต์',
        'Create and manage appointment notifications.' => '',
        'Create and manage attachments.' => 'สร้างและจัดการสิ่งที่แนบมา',
        'Create and manage calendars.' => '',
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
        'Create new appointment.' => '',
        'Create new email ticket and send this out (outbound).' => 'สร้างอีเมล์ตั๋วใหม่และส่งออก(Outbound)',
        'Create new email ticket.' => 'สร้างอีเมล์ตั๋วใหม่',
        'Create new phone ticket (inbound).' => 'สร้างตั๋วโทรศัพท์ใหม่ (ขาเข้า)',
        'Create new phone ticket.' => 'สร้างตั๋วจากโทรศัพท์ใหม่',
        'Create new process ticket.' => 'สร้างตั๋วกระบวนการใหม่',
        'Create tickets.' => 'สร้างตั๋ว',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => 'ภาษาโครเอเชีย',
        'Custom RSS Feed' => 'กำหนด RSS Feed เอง',
        'Custom RSS feed.' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'ข้อความที่กำหนดเองสำหรับหน้าเว็บที่แสดงลูกค้าที่ยังไม่มีตั๋ว(ถ้าคุณต้องการแปลข้อความเหล่านั้น ต้องเพิ่มเข้าไปในโมดูลการแปลที่กำหนดเอง)',
        'Customer Administration' => 'การบริหารลูกค้า',
        'Customer Companies' => 'บริษัทลูกค้า',
        'Customer IDs' => '',
        'Customer Information Center Search.' => 'การค้นหาศูนย์ข้อมูลลูกค้า',
        'Customer Information Center search.' => '',
        'Customer Information Center.' => 'ศูนย์ข้อมูลลูกค้า',
        'Customer Ticket Print Module.' => 'โมดูลพิมพ์ตั๋วลูกค้า',
        'Customer User Administration' => 'การบริหารลูกค้าผู้ใช้',
        'Customer User Information' => '',
        'Customer User Information Center Search.' => '',
        'Customer User Information Center search.' => '',
        'Customer User Information Center.' => '',
        'Customer Users ↔ Customers' => '',
        'Customer Users ↔ Groups' => '',
        'Customer Users ↔ Services' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'รายการของลูกค้า (ไอคอน)ซึ่งจะแสดงตั๋วปิดของลูกค้ารายนี้เป็นบล็อกข้อมูล ตั้งค่า CustomerUserLogin เป็น 1 เพื่อค้นหาตั๋วตามชื่อสำหรับเข้าสู่ระบบมากกว่าCustomerID',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'รายการของลูกค้า (ไอคอน)ซึ่งจะแสดงตั๋วปิดของลูกค้ารายนี้เป็นบล็อกข้อมูล ตั้งค่า CustomerUserLogin เป็น 1 เพื่อค้นหาตั๋วตามชื่อสำหรับเข้าสู่ระบบมากกว่าCustomerID',
        'Customer preferences.' => 'การกำหนดลักษณะของลูกค้า',
        'Customer ticket overview' => 'ภาพรวมตั๋วของลูกค้า',
        'Customer ticket search.' => 'การค้นหาตั๋วลูกค้า',
        'Customer ticket zoom' => 'ซูมตั๋วของลูกค้า',
        'Customer user search' => 'การค้นหาลูกค้าผู้ใช้',
        'CustomerID search' => 'การค้นหาไอดีลูกค้า',
        'CustomerName' => 'CustomerName',
        'CustomerUser' => 'CustomerUser',
        'Customers ↔ Groups' => '',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'ปรับแต่งคำหยุดสำหรับดัชนี Fulltext คำเหล่านี้จะถูกลบออกจากดัชนีการค้นหา',
        'Czech' => 'ภาษาเช็ก',
        'Danish' => 'ภาษาเดนมาร์ก',
        'Dashboard overview.' => '',
        'Data used to export the search result in CSV format.' => 'ข้อมูลถูกนำมาใช้เพื่อส่งออกผลการค้นหาในรูปแบบ CSV',
        'Date / Time' => 'วัน / เวลา',
        'Default (Slim)' => 'เริ่มต้น (Slim)',
        'Default ACL values for ticket actions.' => 'ค่า ACL เริ่มต้นสำหรับการกระทำของตั๋ว',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'เอนทิตีเริ่มต้นของ ProcessManagement จะนำหน้า ID ของเอนทิตีที่สร้างขึ้นโดยอัตโนมัติ',
        'Default agent name' => '',
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
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            '',
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
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            '',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'กำหนดรายการลูกค้าซึ่งจะสร้างไอคอน LinkedIn ในตอนท้ายของบล็อกข้อมูลลูกค้า',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'กำหนดรายการลูกค้าซึ่งจะสร้างไอคอน XING  ในตอนท้ายของบล็อกข้อมูลลูกค้า',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'กำหนดรายการลูกค้าซึ่งจะสร้างไอคอน google ในตอนท้ายของบล็อกข้อมูลลูกค้า',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'กำหนดรายการลูกค้าซึ่งจะสร้างไอคอน google maps ในตอนท้ายของบล็อกข้อมูลลูกค้า',
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
        'Defines a permission context for customer to group assignment.' =>
            '',
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
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            '',
        'Defines an overview module to show the address book view of a customer user list.' =>
            '',
        'Defines available article actions for Chat articles.' => '',
        'Defines available article actions for Email articles.' => '',
        'Defines available article actions for Internal articles.' => '',
        'Defines available article actions for Phone articles.' => '',
        'Defines available article actions for invalid articles.' => '',
        'Defines available groups for the admin overview screen.' => '',
        'Defines chat communication channel.' => '',
        'Defines default headers for outgoing emails.' => '',
        'Defines email communication channel.' => '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'กำหนดจากแอตทริบิวต์ตั๋ว เอเย่นต์สามารถเลือก
ลำดับของผลลัพธ์',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
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
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
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
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'กำหนดหากลูกค้าควรได้รับอนุญาตในการเข้าสู่ระบบหากพวกเขาไม่มีความลับที่ใช้ร่วมกันเก็บไว้ในการตั้งค่าของพวกเขา เพราะฉะนั้นจึงไม่ได้ใช้ตรวจสอบสองปัจจัย',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'กำหนดหากโหมดเสริมควรถูกใช้ (ช่วยให้สามารถใช้ตาราง, แทนที่,ดรรชนีล่าง,ดรรชนีบน,วางจากประโยคและอื่น ๆ )',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'กำหนดหากสัญลักษณ์ที่ถูกต้องก่อนหน้านี้ควรได้รับการยอมรับสำหรับการตรวจสอบ นี่คือความปลอดภัยที่น้อยลงเล็กน้อย แต่ให้เวลาแก่ผู้ใช้มากกว่า 30 วินาทีขึ้นในการป้อนรหัสผ่านเพียงครั้งเดียว',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'กำหนด หากการนับเวลาจะต้องตั้งค่าไปยังตั๋วทั้งหมดในการดำเนินการเป็นกลุ่ม',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'กำหนดแม่แบบข้อความนอกสำนักงาน สองสตริงพารามิเตอร์ (% s) ที่สามารถใช้ได้: วันที่สิ้นสุดและจำนวนวันที่เหลือ',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'กำหนดคิวที่ตั๋วถูกนำมาใช้สำหรับแสดงเป็นกิจกรรมในปฏิทิน',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'กำหนด IP นิพจน์ทั่วไปที่สำหรับการเข้าถึงพื้นที่เก็บข้อมูลท้องถิ่น คุณจำเป็นต้องเปิดใช้งานนี้เพื่อเข้าถึงพื้นที่เก็บข้อมูลท้องถิ่นของคุณและ  package::RepositoryList จำเป็นต้องใช้ในพื้นที่ห่างไกล',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '',
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
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'กำหนดข้อความในส่วนเนื้อความสำหรับการแจ้งเตือนอีเมลที่ส่งให้กับลูกค้าเกี่ยวกับการบัญชีใหม่',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => 'กำหนดข้อความในส่วนเนื้อความสำหรับอีเมลที่ถูกปฏิเสธ',
        'Defines the calendar width in percent. Default is 95%.' => 'กำหนดความกว้างปฏิทินเป็นเปอร์เซ็นต์ เริ่มต้นคือ 95%',
        'Defines the column to store the keys for the preferences table.' =>
            'กำหนดคอลัมน์เพื่อจัดเก็บกุญแจสำหรับตารางการตั้งค่า',
        'Defines the config options for the autocompletion feature.' => 'กำหนดตัวเลือกการตั้งค่าสำหรับฟีเจอร์autocompletion',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'กำหนดค่าพารามิเตอร์ของการตั้งค่าของรายการนี้จะแสดงในมุมมองการตั้งค่า',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'กำหนดการเชื่อมต่อสำหรับ http/ftp ผ่านพร็อกซี่',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'กำหนดคีย์การตั้งค่าลูกค้าซึ่งคีย์ลับที่ใช้ร่วมกันถูกเก็บไว้',
        'Defines the date input format used in forms (option or input fields).' =>
            'กำหนดรูปแบบการป้อนวันที่ ที่ใช้ในแบบฟอร์ม (ตัวเลือกหรือช่องใส่)',
        'Defines the default CSS used in rich text editors.' => 'กำหนด CSS เริ่มต้นที่ใช้ในการแก้ไขข้อความ',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            'กำหนดประเภทการตอบสนองอัตโนมัติเริ่มต้นของบทความนี้สำหรับการดำเนินงาน',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'กำหนดเนื้อเรื่องเริ่มต้นของโน้ตในหน้าจอตั๋วข้อความฟรีในอินเตอร์เฟซของเอเย่นต์',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            'กำหนดธีม front-end เริ่มต้น (HTML)ที่จะใช้โดยตัวแทนและลูกค้า ถ้าคุณชอบคุณสามารถเพิ่มธีมของคุณเอง โปรดดูคู่มือการดูแลระบบที่ตั้งอยู่ที่ https://doc.otrs.com/doc/',
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
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
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
        'Defines the default queue for new tickets in the agent interface.' =>
            '',
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
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'กำหนดโมดูลส่วนหน้าที่ใช้เริ่มต้นหากรพารามิเตอร์การดำเนินการไม่ถูกให้ใน url บนอินเตอร์เฟซเอเย่นต์',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'กำหนดโมดูลส่วนหน้าที่ใช้เริ่มต้นหากรพารามิเตอร์การดำเนินการไม่ถูกให้ใน url บนอินเตอร์เฟซลูกค้า',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'กำหนดค่าเริ่มต้นสำหรับพารามิเตอร์การดำเนินการในหน้าสาธารณะ พารามิเตอร์การดำเนินการถูกนำมาใช้ในสคริปต์ของระบบ',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'กำหนดประเภทผู้ส่งเริ่มต้นที่สามารถดูได้ของตั๋ว (เริ่มต้น: ลูกค้า)',
        'Defines the default visibility of the article to customer for this operation.' =>
            '',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'กำหนดฟิลด์แบบไดนามิกที่ถูกนำมาใช้สำหรับแสดงเป็นกิจกรรมในปฏิทิน',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'กำหนดเส้นทางย้อนกลับเพื่อเปิดเลขฐานสองของ fetchmail หมายเหตุ: ชื่อของเลขฐานสองจะต้องเป็น \'fetchmail\' ถ้ามันแตกต่างกันโปรดใช้การเชื่อมโยงสัญลักษณ์',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'กำหนดตัวกรองเพื่อประมวลผลข้อความในบทความเพื่อที่จะเน้น URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'กำหนดรูปแบบของการตอบสนองในหน้าจอการเขียนตั๋วของอินเตอร์เฟซเอเย่นต์ ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %]เป็นชื่อจริงของFrom).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'กำหนดชื่อโดเมนที่มีคุณสมบัติครบถ้วนของระบบ การตั้งค่านี้จะถูกใช้เป็นตัวแปร OTRS_CONFIG_FQDN ซึ่งพบได้ในรูปแบบของการส่งข้อความทั้งหมดที่ใช้โดยแอพลิเคชั่นเพื่อใช้ในการสร้างการเชื่อมโยงไปตั๋วภายในระบบของคุณ',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
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
        'Defines the list of params that can be passed to ticket search function.' =>
            '',
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
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนในอินเตอร์เฟซเอเย่นต์ถ้าตัวเอเย่นต์เข้าสู่ระบบในขณะout-of-office ใช้งานอยู่',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนในอินเตอร์เฟซเอเย่นต์ถ้าตัวเอเย่นต์เข้าสู่ระบบในขณะที่การบำรุงรักษาระบบกำลังใช้งานอยู่',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'กำหนดโมดูลเพื่อแสดงการแจ้งเตือนในอินเตอร์เฟซเอเย่นต์ถ้าระบบถูกใช้โดยผู้ดูแลระบบ (ปกติคุณไม่ควรทำงานเป็นผู้ดูแลระบบ)',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            'กำหนดโมดูลเพื่อสร้างรหัสสำหรับโหลดหน้าเป็นระยะ ๆ',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            '',
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
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'กำหนดจำนวนตัวอักษรต่อบรรทัดที่ใช้ในกรณีที่ทดแทนการแสดงตัวอย่างบทความ HTML ใน TemplateGenerator สำหรับ EventNotifications',
        'Defines the number of days to keep the daemon log files.' => 'กำหนดจำนวนวันที่จะเก็บไฟล์ daemon log',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'กำหนดจำนวนส่วนหัวของฟิลด์ในโมดูลส่วนหน้าสำหรับการเพิ่มและการอัพเดตตัวกรองโพสต์มาสเตอร์ มันสามารถเป็นได้ถึง 99ฟิลด์',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '',
        'Defines the number of hours a successful communication will be stored.' =>
            '',
        'Defines the parameters for the customer preferences table.' => 'กำหนดพารามิเตอร์สำหรับตารางการตั้งค่าลูกค้า',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
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
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
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
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => 'กำหนดผู้ส่งสำหรับอีเมลที่ถูกปฏิเสธ',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'กำหนดตัวคั่นระหว่างชื่อจริงของเอเย่นต์และที่อยู่อีเมลคิวที่กำหนด',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
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
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'กำหนดฟิลด์ที่ตั๋วที่กำลังจะถูกนำมาแสดงกิจกรรมในปฏิทิน "คีย์" จะกำหนดฟิลด์หรือแอตทริบิวต์ของตั๋วและ "เนื้อหา" จะกำหนดชื่อที่ใช้แสดง',
        'Defines the ticket plugin for calendar appointments.' => '',
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
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'กำหนดสถานะที่ถูกต้องของตั๋วปลดล็อค เพื่อปลดล็อคตั๋วสคริปต์นี้สามารถนำมาใช้ "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout"',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'กำหนดความกว้างสำหรับส่วนประกอบของการแก้ไขข้อความสำหรับหน้าจอนี้ ป้อนจำนวน (พิกเซล) หรือค่าร้อยละ (เทียบ)',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'กำหนดความกว้างสำหรับส่วนประกอบของการแก้ไขข้อความสำหรับหน้าจอนี้ ป้อนจำนวน (พิกเซล) หรือค่าร้อยละ (เทียบ)',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '',
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
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'กำหนดว่าตั๋วใดของประเภทสถานะของตั๋วไม่ควรจะอยู่ในรายชื่อตั๋วเชื่อมโยง',
        'Delete expired cache from core modules.' => 'ลบแคชที่หมดอายุจากโมดูลหลัก',
        'Delete expired loader cache weekly (Sunday mornings).' => 'ลบตัวโหลดแคชที่หมดอายุรายสัปดาห์ (เช้าวันอาทิตย์)',
        'Delete expired sessions.' => 'ลบเซสชันที่หมดอายุ',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'ลบตั๋วนี้',
        'Deleted link to ticket "%s".' => 'ลบการเชื่อมโยงไปยังตั๋ว "%s"',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'ลบเซสชั่นถ้าหากรหัสเซสชั่นที่ใช้กับที่อยู่ IP ระยะไกลไม่ถูกต้อง',
        'Deletes requested sessions if they have timed out.' => 'ลบเซสชันที่ร้องขอหากหมดเวลา',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => 'ปรับใช้และจัดการ OTRS Business Solution™.',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
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
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'แสดงคำเตือนและป้องกันการค้นหาเมื่อหยุดใช้คำที่อยู่ในการค้นหา Fulltext',
        'Display communication log entries.' => '',
        'Display settings to override defaults for Process Tickets.' => 'แสดงการตั้งค่าแทนที่ค่าเริ่มต้นสำหรับกระบวนการสร้างตั๋ว',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'แสดงเวลาคิดสำหรับบทความในมุมมองการซูมตั๋ว',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => 'ลง',
        'Dropdown' => 'ดรอปดาวน์',
        'Dutch' => '',
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
        'Dynamic fields limit per page for Dynamic Fields Overview.' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '',
        'DynamicField' => 'DynamicField',
        'DynamicField backend registration.' => 'การลงทะเบียนส่วนหลังของ DynamicField',
        'DynamicField object registration.' => 'ารลงทะเบียนออบเจคของDynamicField',
        'DynamicField_%s' => '',
        'E-Mail Outbound' => 'อีเมลขาออก',
        'Edit Customer Companies.' => 'แก้ไขลูกค้าบริษัท',
        'Edit Customer Users.' => 'แก้ไขผู้ใช้ลูกค้า',
        'Edit appointment' => '',
        'Edit customer company' => 'แก้ไขลูกค้าบริษัท',
        'Email Addresses' => 'ที่อยู่อีเมล',
        'Email Outbound' => 'อีเมลขาออก',
        'Email Resend' => '',
        'Email communication channel.' => '',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => 'เปิดใช้งานการเชื่อมต่อหัว keep-alive สำหรับการตอบสนอง SOAP',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
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
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'ช่วยให้ขนาดเคาน์เตอร์ตั๋วน้อยที่สุด (ถ้า "ข้อมูล" ได้รับเลือกเป็น TicketNumberGenerator)',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'เปิดใช้งานคุณลักษณะตั๋วกระทำจำนวนมากสำหรับฟรอนต์เอนของเอเย่นต์ในการทำงานมากกว่าหนึ่งตั๋วในเวลาเดียวกัน',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'เปิดใช้งานคุณลักษณะตั๋วการทำงานเป็นกลุ่มเฉพาะสำหรับกลุ่มที่ระบุไว้',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'ช่วยให้ตั๋วคุณลักษณะความรับผิดชอบที่จะติดตามการตั๋วที่เฉพาะเจาะจง',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => 'เปิดใช้งานคุณลักษณะ Watcher ตั๋วเฉพาะสำหรับกลุ่มที่ระบุไว้',
        'English (Canada)' => 'ภาษาอังกฤษ (แคนาดา)',
        'English (United Kingdom)' => 'อังกฤษ (สหราชอาณาจักร)',
        'English (United States)' => 'ภาษาอังกฤษ (สหรัฐอเมริกา)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'คำหยุดภาษาอังกฤษสำหรับดัชนี Fulltext คำพูดเหล่านี้จะถูกลบออกจากดัชนีการค้นหา',
        'Enroll process for this ticket' => 'ลงทะเบียนกระบวนการสำหรับตั๋วนี้',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'ตั๋วการขยาย',
        'Escalation view' => 'มุมมองการขยาย',
        'EscalationTime' => 'เวลาของการขยาย',
        'Estonian' => 'ภาษาเอสโตเนีย',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'การลงทะเบียนโมดูลเหตุการณ์ เพื่อให้ได้ประสิทธิภาพมากขึ้นคุณสามารถกำหนดเหตุการณ์ตัวเรียกโฆษณา (e. ก. จัดกิจกรรม => TicketCreate)',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'การลงทะเบียนโมดูลเหตุการณ์ เพื่อให้ได้ประสิทธิภาพมากขึ้นคุณสามารถกำหนดเหตุการณ์ตัวเรียกโฆษณา (e. ก. จัดกิจกรรม => TicketCreate) เป็นไปได้เฉพาะในกรณีที่ตั๋วฟิลด์แบบไดนามิกทุกตั๋วจำเป็นต้องมีเหตุการณ์เดียวกัน',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'โมดูลเหตุการณ์ที่ดำเนินการคำสั่งการอัพเดตTicketIndex เพื่อเปลี่ยนชื่อคิวถ้าจำเป็นและนำStaticDB มาใช้จริง',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
            '',
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
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => '_',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'รันคำสั่งที่กำหนดเองหรือโมดูล หมายเหตุ: หากโมดูลมีการใช้ฟังก์ชั่นเป็นสิ่งจำเป็น',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'ดำเนินการตรวจการติดตามผลในการตรวจสอบใน In-Reply-To หรือการอ้างอิงข้อมูลส่วนหัวสำหรับอีเมลที่ไม่ได้หมายเลขตั๋วในเนื้อเรื่อง',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'ดำเนินการตรวจการติดตามผลในการตรวจสอบในเนื้อหาของสิ่งที่แนบมาสำหรับอีเมลที่ไม่ได้หมายเลขตั๋วในเนื้อเรื่อง',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'ดำเนินการตรวจการติดตามผลในการตรวจสอบในเนื้อหาอีเมลสำหรับอีเมลที่ไม่ได้หมายเลขตั๋วในเนื้อเรื่อง',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'ดำเนินการตรวจการติดตามผลในการตรวจสอบในแหล่งที่มาอีเมลสำหรับอีเมลที่ไม่ได้หมายเลขตั๋วในเนื้อเรื่อง',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'ส่งบทความทั้งหมดในผลการค้นหาออก (มันสามารถส่งผลกระทบต่อประสิทธิภาพการทำงานของระบบ)',
        'External' => '',
        'External Link' => '',
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
        'First Christmas Day' => 'วันแรกของคริสต์มาส',
        'First Queue' => 'คิวแรก',
        'First response time' => '',
        'FirstLock' => 'FirstLock',
        'FirstResponse' => 'FirstResponse',
        'FirstResponseDiffInMin' => 'FirstResponseDiffInMin',
        'FirstResponseInMin' => 'FirstResponseInMin',
        'Firstname Lastname' => 'ชื่อนามสกุล',
        'Firstname Lastname (UserLogin)' => 'ชื่อนามสกุล (ผู้ใช้เข้าสู่ระบบ)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'กองทัพเข้ารหัสอีเมลขาออก(7bit|8bit|quoted-printable|base64) ',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'บังคับให้เลือกสถานภาพของตั๋วที่แตกต่างกัน (จากปัจจุบัน) หลังจากการดำเนินการล็อค กําหนดสถานภาพในปัจจุบันเป็นคีย์และสถานภาพถัดไปหลังจากการดำเนินการล็อคเป็นเนื้อหา',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Forcesที่จะปลดล็อคตั๋วหลังจากที่ถูกย้ายไปยังอีกคิว',
        'Forwarded to "%s".' => 'ส่งต่อไปยัง "%s".',
        'Free Fields' => 'ฟิลด์ฟรี',
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
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the agent interface.' => 'การลงทะเบียนโมดูล Frontend สำหรับอินเตอร์เฟซของเอเย่นต์',
        'Frontend module registration for the customer interface.' => 'การลงทะเบียนโมดูล Frontend สำหรับอินเตอร์เฟซลูกค้า',
        'Frontend module registration for the public interface.' => 'การลงทะเบียนโมดูล Frontend สำหรับอินเตอร์เฟซสาธารณะ',
        'Full value' => 'ค่าเต็ม',
        'Fulltext index regex filters to remove parts of the text.' => 'ดัชนี regex ของ Fulltext กรองเพื่แลบบางส่วนของข้อความ',
        'Fulltext search' => 'ค้นหาข้อความฉบับเต็ม',
        'Galician' => 'ภาษากาลิเซีย',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => 'สร้างสถิติแดชบอร์ด',
        'Generic Info module.' => 'โมดูลข้อมูลทั่วไป',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => 'GUI อินเตอร์เฟซทั่วไปของการดีบัก',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => 'GUI อินเตอร์เฟซทั่วไปของ Invoker',
        'GenericInterface Operation GUI' => 'GUI อินเตอร์เฟซทั่วไปของ Operation',
        'GenericInterface TransportHTTPREST GUI' => 'GUI อินเตอร์เฟซทั่วไปของ TransportHTTPREST',
        'GenericInterface TransportHTTPSOAP GUI' => 'GUI อินเตอร์เฟซทั่วไปของ TransportHTTPSOAP',
        'GenericInterface Web Service GUI' => 'GUI อินเตอร์เฟซทั่วไปของWeb Service',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => 'การลงทะเบียนโมดูล GenericInterface สำหรับชั้นของผู้ร้องขอ',
        'GenericInterface module registration for the mapping layer.' => 'การลงทะเบียนโมดูล GenericInterface สำหรับชั้นของการทำแผนที่',
        'GenericInterface module registration for the operation layer.' =>
            'การลงทะเบียนโมดูล GenericInterface สำหรับชั้นของการดำเนินงาน',
        'GenericInterface module registration for the transport layer.' =>
            'การลงทะเบียนโมดูล GenericInterface สำหรับชั้นของการขนส่ง',
        'German' => 'ภาษาเยอรมัน',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'คำหยุดภาษาเยอรมันสำหรับดัชนี Fulltext คำเหล่านี้จะถูกลบออกจากดัชนีการค้นหา',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => 'โมดูลการค้นหาทั่วโลก',
        'Go to dashboard!' => 'ไปที่แดชบอร์ด!',
        'Good PGP signature.' => '',
        'Google Authenticator' => 'การรับรองความถูกต้องจาก Google',
        'Graph: Bar Chart' => 'กราฟ: กราฟแท่ง',
        'Graph: Line Chart' => 'กราฟ: แผนภูมิเส้น',
        'Graph: Stacked Area Chart' => 'กราฟ: ซ้อนแผนภูมิพื้นที่',
        'Greek' => 'ภาษากรีก',
        'Hebrew' => 'ภาษาฮิบรู',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '',
        'High contrast skin for visually impaired users.' => '',
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
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
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
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
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
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'หากเปิดใช้งาน ตั๋วโทรศัพท์และตั๋วอีเมลจะเปิดในหน้าต่างใหม่',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Import appointments screen.' => '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'รวมตั๋วของ subqueues ต่อค่าเริ่มต้นเมื่อมีการเลือกคิว',
        'Include unknown customers in ticket filter.' => 'รวมถึงลูกค้าที่ไม่รู้จักในตัวกรองตั๋ว',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'Incoming Phone Call.' => 'โทรศัพท์สายเข้า',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => '',
        'Inline' => '',
        'Input' => 'การป้อนเข้า',
        'Interface language' => 'ภาษาของอินเตอร์เฟซ',
        'Internal communication channel.' => '',
        'International Workers\' Day' => 'วันแรงงานสากล',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => 'ภาษาอิตาลี',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => 'ดิไอวอรี่',
        'Ivory (Slim)' => 'ดิไอวอรี่ (บาง)',
        'Japanese' => 'ภาษาญี่ปุ่น',
        'JavaScript function for the search frontend.' => '',
        'Korean' => '',
        'Language' => 'ภาษา',
        'Large' => 'ขนาดใหญ่',
        'Last Screen Overview' => '',
        'Last customer subject' => 'หัวข้อล่าสุดของลูกค้า',
        'Lastname Firstname' => 'ชื่อนามสกุล',
        'Lastname Firstname (UserLogin)' => 'ชื่อนามสกุล (ผู้ใช้เข้าสู่ระบบ)',
        'Lastname, Firstname' => 'ชื่อ, นามสกุล',
        'Lastname, Firstname (UserLogin)' => 'ชื่อ, นามสกุล (UserLogin)',
        'LastnameFirstname' => '',
        'Latvian' => 'ภาษาแลทเวีย',
        'Left' => 'ซ้าย',
        'Link Object' => 'การเชื่อมโยงออบเจค',
        'Link Object.' => 'วัตถุการเชื่อมโยง',
        'Link agents to groups.' => 'ตัวแทนเชื่อมโยงไปยังกลุ่ม',
        'Link agents to roles.' => 'ลิ้งตัวแทนกับบทบาท',
        'Link customer users to customers.' => '',
        'Link customer users to groups.' => '',
        'Link customer users to services.' => '',
        'Link customers to groups.' => '',
        'Link queues to auto responses.' => 'ลิ้งคำสั่งไปยังการตอบอัตโนมัติ',
        'Link roles to groups.' => 'ลิ้งบทบาทไปยังกลุ่ม',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => 'ลิ้งแม่แบบไปยังคิว',
        'Link this ticket to other objects' => 'เชื่อมโยงตั๋วนี้เพื่อออบเจคอื่น ๆ',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'Links appointments and tickets with a "Normal" type link.' => '',
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
        'List of all LinkObject events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all appointment events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all calendar events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lithuanian' => '',
        'Loader module registration for the agent interface.' => '',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => '',
        'Locked Tickets' => 'ตั๋วที่ถูกล็อค',
        'Locked Tickets.' => '',
        'Locked ticket.' => '',
        'Logged in users.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Look into a ticket!' => 'มองเข้าไปในตั๋ว!',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => 'บัญชีอีเมล',
        'MailQueue configuration settings.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => 'การลงทะเบียนเมนูหลัก',
        'Makes the application block external content loading.' => '',
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
        'Manage System Configuration Deployments.' => '',
        'Manage different calendars.' => '',
        'Manage existing sessions.' => '',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark as Spam!' => 'มาร์คว่าเป็นสแปม!',
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
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Medium' => 'ขนาดกลาง',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Minute' => '',
        'Miscellaneous' => 'เบ็ดเตล็ด',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
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
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            '',
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
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => 'หลายรายการ',
        'My Queues' => 'คิวของฉัน',
        'My Services' => 'การบริการของฉัน',
        'My Tickets.' => 'ตั๋วของฉัน',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => 'NameX',
        'New Ticket' => 'ตั๋วใหม่',
        'New Tickets' => 'ตั๋วใหม่',
        'New Window' => 'หน้าต่างใหม่',
        'New Year\'s Day' => 'วันขึ้นปีใหม่',
        'New Year\'s Eve' => 'วันส่งท้ายปีเก่า',
        'New process ticket' => 'ตั๋วกระบวนการใหม่',
        'News about OTRS releases!' => 'ข่าวเกี่ยวกับการเผยแพร่OTRS !',
        'News about OTRS.' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => 'ไม่มี',
        'Norwegian' => 'ภาษานอร์เวย์',
        'Notification Settings' => 'การตั้งค่าการแจ้งเตือน',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'จำนวนตั๋วที่แสดง',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => '',
        'OTRS News' => 'ข่าวOTRS',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '',
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
        'Other Customers' => '',
        'Out Of Office' => 'ออกจากสำนักงาน',
        'Out Of Office Time' => 'หมดเวลาทำงาน',
        'Out of Office users.' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => 'ภาพรวมตั๋วส่งต่อ',
        'Overview Refresh Time' => 'ภาพรวมเวลารีเฟรช',
        'Overview of all Tickets per assigned Queue.' => '',
        'Overview of all appointments.' => '',
        'Overview of all escalated tickets.' => 'ภาพรวมของตั๋วที่เพิ่มขึ้นทั้งหมด',
        'Overview of all open Tickets.' => 'ภาพรวมของตั๋วที่เปิดอยู่ทั้งหมด',
        'Overview of all open tickets.' => 'ภาพรวมของตั๋วที่เปิดอยู่ทั้งหมด',
        'Overview of customer tickets.' => 'ภาพรวมของตั๋วของลูกค้า',
        'PGP Key' => 'คีย์ PGP',
        'PGP Key Management' => 'การจัดการคีย์ PGP',
        'PGP Keys' => 'คีย์ PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Parent' => 'Parent',
        'ParentChild' => 'ParentChild',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Pending time' => '',
        'People' => 'คน',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => 'ภาษาเปอร์เซีย',
        'Phone Call Inbound' => 'โทรศัพท์ขาเข้า',
        'Phone Call Outbound' => 'โทรศัพท์ขาออก',
        'Phone Call.' => 'โทรศัพท์เรียกเข้า',
        'Phone call' => 'สายเข้า',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'ตั๋วจากโทรศัพท์',
        'Picture Upload' => 'อัพโหลดรูปภาพ',
        'Picture upload module.' => 'โมดูลอัพโหลดรูปภาพ',
        'Picture-Upload' => 'อัพโหลด-รูปภาพ',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => 'ภาษาโปแลนด์',
        'Portuguese' => 'ภาษาโปรตุเกส',
        'Portuguese (Brasil)' => 'ภาษาโปรตุเกส (บราซิล)',
        'PostMaster Filters' => 'ตัวกรอง PostMaster',
        'PostMaster Mail Accounts' => 'เมลตัวกรอง PostMaster',
        'Print this ticket' => 'พิมพ์ตั๋วนี้',
        'Priorities' => 'ลำดับความสำคัญ',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process Ticket.' => 'ตั๋วกระบวนการ',
        'Process pending tickets.' => 'ตั๋วกระบวนการที่ค้างอยู่',
        'ProcessID' => 'ProcessID',
        'Processes & Automation' => '',
        'Product News' => 'ข่าวผลิตภัณฑ์',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => '',
        'Public calendar.' => '',
        'Queue view' => 'มุมมองคิว',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => 'ช่วงเวลาการฟื้นฟู',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => 'ตั๋วการแจ้งเตือน',
        'Removed subscription for user "%s".' => '',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
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
        'Required permissions to use the email resend screen in the agent interface.' =>
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
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Resource Overview (OTRS Business Solution™)' => '',
        'Responsible Tickets' => 'ผู้รับผิดชอบตั๋ว',
        'Responsible Tickets.' => 'ผู้รับผิดชอบตั๋ว',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => 'ขวา',
        'Roles ↔ Groups' => '',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => 'ภาษารัสเซีย',
        'S/MIME Certificates' => 'ใบรับรอง S/MIME',
        'SMS' => 'SMS',
        'SMS (Short Message Service)' => 'SMS (Short Message Service)',
        'Salutations' => 'คำขึ้นต้น',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen after new ticket' => 'หน้าจอหลังจากตั๋วใหม่',
        'Search Customer' => 'ค้นหาลูกค้า',
        'Search Ticket.' => 'ค้นหาตั๋ว',
        'Search Tickets.' => 'ค้นหาตั๋ว',
        'Search User' => 'ค้นหาผู้ใช้',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => 'ค้นหา',
        'Second Christmas Day' => 'วันที่สองของ',
        'Second Queue' => 'คิวที่สอง',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'เลือกตัวอักษรตัวคั่นที่ใช้ในไฟล์ CSV (สถิติและการค้นหา) ถ้าคุณไม่ได้เลือกตัวคั่นตอนนี้ ตัวคั่นเริ่มต้นสำหรับภาษาของคุณจะถูกนำไปใช้แทน',
        'Select your frontend Theme.' => '',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
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
        'Sent "%s" notification to "%s" via "%s".' => '',
        'Sent auto follow-up to "%s".' => '',
        'Sent auto reject to "%s".' => '',
        'Sent auto reply to "%s".' => '',
        'Sent email to "%s".' => '',
        'Sent email to customer.' => '',
        'Sent notification to "%s".' => '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service Level Agreements' => 'ข้อตกลงระดับการให้บริการ',
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
        'Set this ticket to pending' => 'เซตตั๋วนี้ในที่รอดำเนินการ',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets if ticket responsible must be selected by the agent.' => '',
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
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
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
        'Sets the default link type of split tickets in the agent interface.' =>
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
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the preferred digest to be used for PGP binary.' => '',
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
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
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
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the time zone being used internally by OTRS to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            '',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTRS time zone and the user\'s time zone.' =>
            '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Shared Secret' => 'ความลับที่ใช้ร่วมกัน',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show command line output.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => 'แสดงประวัติสำหรับตั๋วนี้',
        'Show the ticket history' => 'แสดงประวัติตั๋ว',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows information on how to start OTRS Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
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
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '',
        'Signature data.' => '',
        'Signatures' => 'ลายเซ็น',
        'Simple' => 'ง่าย ๆ',
        'Skin' => 'ผิว',
        'Slovak' => 'ภาษาสโลวาเกีย',
        'Slovenian' => 'ภาษาสโลเวเนีย',
        'Small' => 'ขนาดเล็ก',
        'Software Package Manager.' => '',
        'Solution time' => '',
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
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
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
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
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
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Stat#',
        'States' => 'สถานภาพ',
        'Statistic Reports overview.' => '',
        'Statistics overview.' => '',
        'Status view' => 'ดูสถานะ',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => 'ภาษาสวาฮิลี',
        'Swedish' => 'ภาษาสวีเดน',
        'System Address Display Name' => '',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Maintenance' => '',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => '',
        'Textarea' => 'Textarea',
        'Thai' => 'ภาษาไทย',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
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
        'The daemon registration for the system configuration deployment sync manager.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
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
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'The value of the From field' => '',
        'Theme' => 'ตีม',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
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
        'This setting is deprecated. Set OTRSTimeZone instead.' => '',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
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
        'Ticket Overview "Medium" Limit' => 'ภาพรวมของตั๋วขนาดกลาง',
        'Ticket Overview "Preview" Limit' => 'ภาพรวมของตั๋ว "ดูตัวอย่าง" จำกัด',
        'Ticket Overview "Small" Limit' => 'ภาพรวมของตั๋วขนาดเล็ก',
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
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => '',
        'Ticket overview' => '',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => '',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'To view HTML attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => '',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => '',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => '',
        'Up' => 'ขึ้น',
        'Upcoming Events' => 'กิจกรรมที่กำลังจะมาถึง',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update time' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'User Profile' => 'โปรไฟล์ผู้ใช้',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Users, Groups & Roles' => '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => '',
        'View all attachments of the current ticket' => '',
        'View performance benchmark results.' => '',
        'Watch this ticket' => '',
        'Watched Tickets' => 'ตั๋วดูแล้ว',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => '',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '',
        'Web Services' => 'Web Services',
        'Web View' => '',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'อีเมล์ของคุณที่มีหมายเลขตั๋ว "<OTRS_TICKET>" ถูกรวมกับ "<OTRS_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'Zoom' => 'ซูม',
        'attachment' => '',
        'bounce' => '',
        'compose' => '',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'normal' => 'ปกติ',
        'notice' => '',
        'pending' => '',
        'phone' => 'โทรศัพท์',
        'responsible' => '',
        'reverse' => 'ย้อนกลับ',
        'stats' => '',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
        '+%s more',
        'A key with this name (\'%s\') already exists.',
        'A package upgrade was recently finished. Click here to see the results.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',
        'Add',
        'Add Event Trigger',
        'Add all',
        'Add entry',
        'Add key',
        'Add new draft',
        'Add new entry',
        'Add to favourites',
        'Agent',
        'All occurrences',
        'All-day',
        'An error occurred during communication.',
        'An error occurred! Please check the browser error log for more details!',
        'An item with this name is already present.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.',
        'An unknown error occurred. Please contact the administrator.',
        'Apply',
        'Appointment',
        'Apr',
        'April',
        'Are you sure you want to delete this appointment? This operation cannot be undone.',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article display',
        'Article filter',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'Attachment was deleted successfully.',
        'Attachments',
        'Aug',
        'August',
        'Available space %s of %s.',
        'Basic information',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?',
        'Calendar',
        'Cancel',
        'Cannot proceed',
        'Clear',
        'Clear all',
        'Clear debug log',
        'Clear search',
        'Click to delete this attachment.',
        'Click to select a file for upload.',
        'Click to select a file or just drop it here.',
        'Click to select files or just drop them here.',
        'Clone web service',
        'Close preview',
        'Close this dialog',
        'Complex %s with %s arguments',
        'Confirm',
        'Could not open popup window. Please disable any popup blockers for this application.',
        'Current selection',
        'Currently not possible',
        'Customer interface does not support articles not visible for customers.',
        'Data Protection',
        'Date/Time',
        'Day',
        'Dec',
        'December',
        'Delete',
        'Delete Entity',
        'Delete conditions',
        'Delete draft',
        'Delete error handling module',
        'Delete field',
        'Delete invoker',
        'Delete operation',
        'Delete this Attachment',
        'Delete this Event Trigger',
        'Delete this Invoker',
        'Delete this Key Mapping',
        'Delete this Mail Account',
        'Delete this Operation',
        'Delete this PostMasterFilter',
        'Delete this Template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting the field and its data. This may take a while...',
        'Deleting the mail account and its data. This may take a while...',
        'Deleting the postmaster filter and its data. This may take a while...',
        'Deleting the template and its data. This may take a while...',
        'Deploy',
        'Deploy now',
        'Deploying, please wait...',
        'Deployment comment...',
        'Deployment successful. You\'re being redirected...',
        'Descending sort applied, ',
        'Description',
        'Dismiss',
        'Do not show this warning again.',
        'Do you really want to continue?',
        'Do you really want to delete "%s"?',
        'Do you really want to delete this certificate?',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
        'Do you really want to delete this scheduled system maintenance?',
        'Do you really want to delete this statistic?',
        'Do you really want to reset this setting to it\'s default value?',
        'Do you really want to revert this setting to its historical value?',
        'Don\'t save, update manually',
        'Draft title',
        'Duplicate event.',
        'Duplicated entry',
        'Edit Field Details',
        'Edit this setting',
        'Edit this transition',
        'End date',
        'Error',
        'Error during AJAX communication',
        'Error during AJAX communication. Status: %s, Error: %s',
        'Error in the mail settings. Please correct and try again.',
        'Error: Browser Check failed!',
        'Event Type Filter',
        'Expanded',
        'Feb',
        'February',
        'Filters',
        'Find out more',
        'Finished',
        'First select a customer user, then select a customer ID to assign to this ticket.',
        'Fr',
        'Fri',
        'Friday',
        'Generate',
        'Generate Result',
        'Generating...',
        'Grouped',
        'Help',
        'Hide EntityIDs',
        'If you now leave this page, all open popup windows will be closed, too!',
        'Import web service',
        'Information about the OTRS Daemon',
        'Invalid date (need a future date)!',
        'Invalid date (need a past date)!',
        'Invalid date!',
        'It is going to be deleted from the field, please try again.',
        'It is not possible to add a new event trigger because the event is not set.',
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.',
        'It was not possible to delete this draft.',
        'It was not possible to generate the Support Bundle.',
        'Jan',
        'January',
        'Jul',
        'July',
        'Jump',
        'Jun',
        'June',
        'Just this occurrence',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.',
        'Less',
        'Link',
        'Loading, please wait...',
        'Loading...',
        'Location',
        'Mail check successful.',
        'Mapping for Key',
        'Mapping for Key %s',
        'Mar',
        'March',
        'May',
        'May_long',
        'Mo',
        'Mon',
        'Monday',
        'Month',
        'More',
        'Name',
        'Namespace %s could not be initialized, because %s could not be found.',
        'Next',
        'No Data Available.',
        'No TransitionActions assigned.',
        'No data found.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'No matches found.',
        'No package information available.',
        'No response from get package upgrade result.',
        'No response from get package upgrade run status.',
        'No response from package upgrade all.',
        'No sort applied, ',
        'No space left for the following files: %s',
        'Not available',
        'Notice',
        'Notification',
        'Nov',
        'November',
        'OK',
        'Oct',
        'October',
        'One or more errors occurred!',
        'Open URL in new tab',
        'Open date selection',
        'Open this node in a new window',
        'Please add values for all keys before saving the setting.',
        'Please check the fields marked as red for valid inputs.',
        'Please either turn some off first or increase the limit in configuration.',
        'Please enter at least one search value or * to find anything.',
        'Please enter at least one search word to find anything.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.',
        'Please only select at most %s files for upload.',
        'Please only select one file for upload.',
        'Please remove the following words from your search as they cannot be searched for:',
        'Please see the documentation or ask your admin for further information.',
        'Please turn off Compatibility Mode in Internet Explorer!',
        'Please wait...',
        'Preparing to deploy, please wait...',
        'Press Ctrl+C (Cmd+C) to copy to clipboard',
        'Previous',
        'Process state',
        'Queues',
        'Reload page',
        'Reload page (%ss)',
        'Remove',
        'Remove Entity from canvas',
        'Remove active filters for this widget.',
        'Remove all user changes.',
        'Remove from favourites',
        'Remove selection',
        'Remove the Transition from this Process',
        'Remove the filter',
        'Remove this dynamic field',
        'Remove this entry',
        'Repeat',
        'Request Details',
        'Request Details for Communication ID',
        'Reset',
        'Reset globally',
        'Reset locally',
        'Reset option is required!',
        'Reset options',
        'Reset setting',
        'Reset setting on global level.',
        'Resource',
        'Resources',
        'Restore default settings',
        'Restore web service configuration',
        'Rule',
        'Running',
        'Sa',
        'Sat',
        'Saturday',
        'Save',
        'Save and update automatically',
        'Scale preview content',
        'Search',
        'Search attributes',
        'Search the System Configuration',
        'Searching for linkable objects. This may take a while...',
        'Select a customer ID to assign to this ticket',
        'Select a customer ID to assign to this ticket.',
        'Select all',
        'Sending Update...',
        'Sep',
        'September',
        'Setting a template will overwrite any text or attachment.',
        'Settings',
        'Show',
        'Show EntityIDs',
        'Show current selection',
        'Show or hide the content.',
        'Slide the navigation bar',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.',
        'Sorry, the only existing condition can\'t be removed.',
        'Sorry, the only existing field can\'t be removed.',
        'Sorry, the only existing parameter can\'t be removed.',
        'Sorry, you can only upload %s files.',
        'Sorry, you can only upload one file here.',
        'Split',
        'Stacked',
        'Start date',
        'Status',
        'Stream',
        'Su',
        'Sun',
        'Sunday',
        'Support Bundle',
        'Support Data information was successfully sent.',
        'Switch to desktop mode',
        'Switch to mobile mode',
        'System Registration',
        'Team',
        'Th',
        'The browser you are using is too old.',
        'The deployment is already running.',
        'The following files are not allowed to be uploaded: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s',
        'The following files were already uploaded and have not been uploaded again: %s',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.',
        'The key must not be empty.',
        'The mail could not be sent',
        'There are currently no elements available to select from.',
        'There are no more drafts available.',
        'There is a package upgrade process running, click here to see status information about the upgrade progress.',
        'There was an error deleting the attachment. Please check the logs for more information.',
        'There was an error. Please save all settings you are editing and check the logs for more information.',
        'This Activity cannot be deleted because it is the Start Activity.',
        'This Activity is already used in the Process. You cannot add it twice!',
        'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!',
        'This address already exists on the address list.',
        'This element has children elements and can currently not be removed.',
        'This event is already attached to the job, Please use a different one.',
        'This feature is part of the %s. Please contact us at %s for an upgrade.',
        'This field can have no more than 250 characters.',
        'This field is required.',
        'This is %s',
        'This is a repeating appointment',
        'This is currently disabled because of an ongoing package upgrade.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?',
        'This option is currently disabled because the OTRS Daemon is not running.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.',
        'This window must be called from compose window.',
        'Thu',
        'Thursday',
        'Timeline Day',
        'Timeline Month',
        'Timeline Week',
        'Title',
        'Today',
        'Too many active calendars',
        'Try again',
        'Tu',
        'Tue',
        'Tuesday',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.',
        'Unknown',
        'Unlock setting.',
        'Update All Packages',
        'Update Result',
        'Update all packages',
        'Update manually',
        'Upload information',
        'Uploading...',
        'Use options below to narrow down for which tickets appointments will be automatically created.',
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',
        'Warning',
        'Was not possible to send Support Data information.',
        'We',
        'Wed',
        'Wednesday',
        'Week',
        'Would you like to edit just this occurrence or all occurrences?',
        'Yes',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.',
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.',
        'You have undeployed settings, would you like to deploy them?',
        'activate to apply a descending sort',
        'activate to apply an ascending sort',
        'activate to remove the sort',
        'and %s more...',
        'day',
        'month',
        'more',
        'no',
        'none',
        'or',
        'sorting is disabled',
        'user(s) have modified this setting.',
        'week',
        'yes',
    ];

    # $$STOP$$
    return;
}

1;
