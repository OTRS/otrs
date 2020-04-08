# --
# Copyright (C) 2011 O.P.S <sales at OptForOPS.com>
# Copyright (C) 2011 Chetan Nagaonkar <Chetan_Nagaonkar at OptForOPS.com>
# Copyright (C) 2011 Chetan Nagaonkar <ChetanNagaonkar at yahoo.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::hi;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y - %T';
    $Self->{DateFormatLong}      = '%A, %D %B %Y - %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.272265492719269;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = '';
    $Self->{ThousandSeparator} = '';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => '',
        'Actions' => 'क्रियाएँ',
        'Create New ACL' => '',
        'Deploy ACLs' => '',
        'Export ACLs' => '',
        'Filter for ACLs' => '',
        'Just start typing to filter...' => '',
        'Configuration Import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'इस क्षेत्र की आवश्यकता है।',
        'Overwrite existing ACLs?' => '',
        'Upload ACL configuration' => '',
        'Import ACL configuration(s)' => '',
        'Description' => 'विवरण',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '',
        'ACL name' => '',
        'Comment' => 'टिप्पणी',
        'Validity' => '',
        'Export' => 'निर्यात',
        'Copy' => '',
        'No data found.' => 'कोई आंकड़ा नहीं मिला।',
        'No matches found.' => 'कोई मिलान नहीं मिले।',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Edit ACL' => '',
        'Go to overview' => 'अवलोकन के लिए जाएँ',
        'Delete ACL' => '',
        'Delete Invalid ACL' => '',
        'Match settings' => '',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => '',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'अंतर्वस्तु दिखाएँ या छुपाएँ',
        'Edit ACL Information' => '',
        'Name' => 'नाम',
        'Stop after match' => 'मिलान के बाद स्र्कें',
        'Edit ACL Structure' => '',
        'Save ACL' => '',
        'Save' => 'सुरक्षित करे',
        'or' => 'या',
        'Save and finish' => '',
        'Cancel' => 'रद्द',
        'Do you really want to delete this ACL?' => '',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

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
        'Overwrite existing entities' => '',
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
        'Group' => 'समूह',
        'Changed' => 'बदल गया',
        'Created' => 'बनाया',
        'Download' => 'डाउनलोड करें',
        'URL' => '',
        'Export calendar' => '',
        'Download calendar' => '',
        'Copy public calendar URL' => '',
        'Calendar' => 'पंचांग',
        'Calendar name' => '',
        'Calendar with same name already exists.' => '',
        'Color' => '',
        'Permission group' => '',
        'Ticket Appointments' => '',
        'Rule' => '',
        'Remove this entry' => 'इस प्रविष्टि को हटाएँ',
        'Remove' => 'हटायें',
        'Start date' => '',
        'End date' => '',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '',
        'Queues' => 'श्रेणीया',
        'Please select a valid queue.' => '',
        'Search attributes' => '',
        'Add entry' => 'प्रविष्टि जोड़ें',
        'Add' => 'जोड़ें',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '',
        'Add Rule' => '',
        'Submit' => 'यहॉ जमा करे',

        # Template: AdminAppointmentImport
        'Appointment Import' => '',
        'Go back' => '',
        'Uploaded file must be in valid iCal format (.ics).' => '',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '',
        'Upload' => 'अपलोड',
        'Update existing appointments?' => '',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '',
        'Upload calendar' => '',
        'Import appointments' => '',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '',
        'Add Notification' => 'अधिसूचना जोड़ें',
        'Edit Notification' => 'अधिसूचनाएँ संपादित करें',
        'Export Notifications' => '',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => '',
        'Upload Notification configuration' => '',
        'Import Notification configuration' => '',
        'List' => 'सूची',
        'Delete' => 'हटाएँ',
        'Delete this notification' => 'इस अधिसूचना को हटाएँ',
        'Show in agent preferences' => '',
        'Agent preferences tooltip' => '',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Toggle this widget' => 'इस मशीन को स्विच करें',
        'Events' => 'कार्यक्रम',
        'Event' => 'कार्यक्रम',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => '',
        'Type' => 'प्रकार',
        'Title' => 'शीर्षक',
        'Location' => 'स्थान',
        'Team' => '',
        'Resource' => '',
        'Recipients' => '',
        'Send to' => '',
        'Send to these agents' => '',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => '',
        'Send on out of office' => '',
        'Also send if the user is currently out of office.' => '',
        'Once per day' => '',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '',
        'Notification Methods' => '',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => '',
        'Transport' => '',
        'At least one method is needed per notification.' => '',
        'Active by default in agent preferences' => '',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '',
        'This feature is currently not available.' => '',
        'Upgrade to %s' => '',
        'Please activate this transport in order to use it.' => '',
        'No data found' => '',
        'No notification method found.' => '',
        'Notification Text' => '',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '',
        'Remove Notification Language' => '',
        'Subject' => 'विषय',
        'Text' => 'पूर्ण पाठ',
        'Message body' => '',
        'Add new notification language' => '',
        'Save Changes' => 'परिवर्तन  सुरक्षित करें',
        'Tag Reference' => '',
        'Notifications are sent to an agent.' => '',
        'You can use the following tags' => 'आप निम्नलिखित टैग का उपयोग कर सकते हैं।',
        'To get the first 20 character of the appointment title.' => '',
        'To get the appointment attribute' => '',
        ' e. g.' => 'उदा.',
        'To get the calendar attribute' => '',
        'Attributes of the recipient user for the notification' => '',
        'Config options' => 'संरचना के विकल्पों',
        'Example notification' => '',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Email template' => '',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminAttachment
        'Attachment Management' => 'अनुलग्नक प्रबंधन',
        'Add Attachment' => 'संलग्नक जोड़ें',
        'Edit Attachment' => 'संलग्नक संपादित करें',
        'Filter for Attachments' => 'संलग्नक के लिए निस्पादक',
        'Filter for attachments' => '',
        'Filename' => 'संचिका का नाम',
        'Download file' => 'फ़ाइल डाउनलोड करें',
        'Delete this attachment' => 'इस संलग्नक को हटाएँ ',
        'Do you really want to delete this attachment?' => '',
        'Attachment' => 'संलग्नक',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'स्वत प्रतिक्रिया प्रबंधन ',
        'Add Auto Response' => 'स्वत प्रतिक्रिया जोड़ें',
        'Edit Auto Response' => 'स्वत प्रतिक्रिया संपादित करें',
        'Filter for Auto Responses' => 'स्वतप्रतिक्रियाओं के लिए निस्पादक',
        'Filter for auto responses' => '',
        'Response' => 'प्रतिक्रिया',
        'Auto response from' => 'स्वत प्रतिक्रिया से',
        'Reference' => 'संदर्भ में',
        'To get the first 20 character of the subject.' => 'विषय के पहले 20 वर्ण प्राप्त करने के लिए।',
        'To get the first 5 lines of the email.' => 'ईमेल की पहली 5 लाइनें प्राप्त करने के लिए।',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'अनुच्छेद विशेषता प्राप्त करने के लिए।',
        'Options of the current customer user data' => 'मौजूदा ग्राहक उपयोगकर्ता के आंकड़ॊ के विकल्प',
        'Ticket owner options' => 'टिकट स्वामी विकल्प',
        'Ticket responsible options' => 'टिकट उत्तरदायी विकल्प',
        'Options of the current user who requested this action' => 'वर्तमान उपयोगकर्ता के विकल्प जिसनॆ इस कार्रवाई के लिए अनुरोध किया।',
        'Options of the ticket data' => 'टिकट आंकड़ॊ के विकल्प',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Example response' => 'उदाहरण प्रतिक्रिया',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '',
        'Support Data Collector' => '',
        'Support data collector' => '',
        'Hint' => 'संकेत',
        'Currently support data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '',
        'Configuration' => '',
        'Send support data' => '',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '',
        'Update' => 'अद्यतनीकरण',
        'System Registration' => '',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => '',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            '',
        'Register this system' => '',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '',

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
        'Settings' => 'सेटिंग्स',
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
        'Status' => 'स्तर',
        'Account' => '',
        'Edit' => 'संपादित करें',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'दिशा',
        'Start Time' => '',
        'End Time' => '',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'प्राथमिकता',
        'Module' => 'मॉड्यूल',
        'Information' => '',
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
        'Customer Management' => 'ग्राहक प्रबंधन',
        'Add Customer' => 'ग्राहक जोड़ें',
        'Edit Customer' => 'ग्राहक संपादित करें',
        'Search' => 'खोजें',
        'Wildcards like \'*\' are allowed.' => '',
        'Select' => 'चुनें',
        'List (only %s shown - more available)' => '',
        'total' => '',
        'Please enter a search term to look for customers.' => 'कृपया ग्राहकों को देखने के लिए एक खोज शब्द दर्ज करें।',
        'Customer ID' => 'ग्राहक ID',
        'Please note' => '',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'ग्राहक-समूह संबंधों का प्रबंधन करें',
        'Notice' => 'समन',
        'This feature is disabled!' => 'यह सुविधा निष्क्रिय है।',
        'Just use this feature if you want to define group permissions for customers.' =>
            'यदि आप ग्राहकों के लिए समूह अनुमतियाँ परिभाषित करना चाहते हैं तो इस सुविधा का उपयोग करें।',
        'Enable it here!' => 'यहाँ सक्रिय करें।',
        'Edit Customer Default Groups' => 'ग्राहक तयशुदा समूह संपादित करें',
        'These groups are automatically assigned to all customers.' => 'यह समूह स्वतः सभी ग्राहकों के लिए आवंटित हो जाते हैं।',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'समूहों के लिए निस्पादक',
        'Select the customer:group permissions.' => 'ग्राहक:समूह अनुमतियाँ चुनें।',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'अगर कुछ भी नहीं चुना जाता है,तो फिर इस समूह में कोई अनुमतियाँ नहीं हैं(टिकट ग्राहकों के लिए उपलब्ध नहीं होगा)। ',
        'Search Results' => 'खोज परिणाम:',
        'Customers' => 'ग्राहकों',
        'Groups' => 'समूहों',
        'Change Group Relations for Customer' => 'ग्राहक के लिए समूह संबंधों को बदलें',
        'Change Customer Relations for Group' => 'समूह के लिए ग्राहक संबंधों को बदलें',
        'Toggle %s Permission for all' => 'स्विच %s सभी के लिए अनुमति है',
        'Toggle %s permission for %s' => 'स्विच %s %s के लिए अनुमति है',
        'Customer Default Groups:' => 'ग्राहक तयशुदा समूहॆ:',
        'No changes can be made to these groups.' => 'इन समूहों में कोई बदलाव नहीं किया जा सकता।',
        'ro' => 'केवल पढ़ने के लिए',
        'Read only access to the ticket in this group/queue.' => 'इस समूह/श्रेणी के टिकट को केवल पढ़ने के लिए प्रवेश।',
        'rw' => 'पढ़ने और लिखने के लिए',
        'Full read and write access to the tickets in this group/queue.' =>
            'इस समूह/श्रेणी के टिकट को पढ़ने और लिखने के लिए प्रवेश।',

        # Template: AdminCustomerUser
        'Customer User Management' => '',
        'Add Customer User' => '',
        'Edit Customer User' => '',
        'Back to search results' => '',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '',
        'List (%s total)' => '',
        'Username' => 'उपयोगकर्ता का नाम',
        'Email' => 'ईमेल',
        'Last Login' => 'पिछला प्रवेश ',
        'Login as' => 'के रूप में प्रवेश',
        'Switch to customer' => '',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'यह क्षेत्र जरूरी है और एक मान्य ईमेल पतॆ की आवश्यकता है।',
        'This email address is not allowed due to the system configuration.' =>
            'यह ईमेल पता प्रणाली विन्यास की वजह से स्वीकार्य नहीं है।',
        'This email address failed MX check.' => 'यह ईमेल पता MX जांच में विफल रहा।',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => 'इस ईमेल पते के वाक्य रचना ग़लत है।',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'ग्राहक',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => '',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'सभी के लिए सक्रिय स्थिति स्विच करें',
        'Active' => 'क्रियाशील',
        'Toggle active state for %s' => 'सक्रिय स्थिति स्विच करें %s के लिए',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'आप विन्यास व्यवस्था "ग्राहक समूह सदैव समूहों" के माध्यम से इन समूहों का प्रबंधन कर सकते हैं।',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'तयशुदा सेवाएं संपादित करें',
        'Filter for Services' => 'सेवाओं के लिए निस्पादक',
        'Filter for services' => '',
        'Services' => 'सेवाएँ',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'More Business Fields' => '',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '',
        'Database' => 'आंकड़ाकोष',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'Contact with data' => '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => '',
        'Object' => 'वस्तु',
        'Delete this field' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '',
        'Go back to overview' => '',
        'General' => '',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '',
        'Changing this value will require manual changes in the system.' =>
            '',
        'This is the name to be shown on the screens where the field is active.' =>
            '',
        'Field order' => '',
        'This field is required and must be numeric.' => '',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => '',
        'Object type' => '',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => '',
        'Default value' => 'तयशुदा मान',
        'This is the default value for this field.' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '',
        'This field must be numeric.' => '',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => '',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '',
        'Years in the past to display (default: 5 years).' => '',
        'Years in the future' => '',
        'Years in the future to display (default: 5 years).' => '',
        'Show link' => '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => 'उदाहरण',
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => 'कुंजी',
        'Value' => 'मान',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => '',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldText
        'Number of rows' => '',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => '',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => 'त्रुटि संदेश',
        'Add RegEx' => '',

        # Template: AdminEmail
        'Admin Message' => '',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'इस मॉड्यूल के साथ,प्रशासक प्रतिनिधि,समूह,या भूमिका के सदस्यों को संदेश भेज सकते हैं। ',
        'Create Administrative Message' => 'प्रशासनिक संदेश बनाएँ',
        'Your message was sent to' => 'आपका संदेश को भेजा गया',
        'From' => 'से',
        'Send message to users' => 'उपयोगकर्ताओं को संदेश भेजें',
        'Send message to group members' => 'समूह के सदस्यों को संदेश भेजें',
        'Group members need to have permission' => 'समूह सदस्यों को अनुमति की आवश्यकता है',
        'Send message to role members' => 'भूमिका के सदस्यों को संदेश भेजें',
        'Also send to customers in groups' => 'समूह में ग्राहकों को भी भेजें',
        'Body' => 'मुख्य-भाग',
        'Send' => 'भेजें',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'पिछले भागो',
        'Run Now!' => 'अब चलाएँ',
        'Delete this task' => 'इस कार्य को हटाएँ',
        'Run this task' => 'इस कार्य को चलाएँ',
        'Job Settings' => 'कार्य व्यवस्थाऐं',
        'Job name' => 'कार्य का नाम',
        'The name you entered already exists.' => '',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'अनुसूची मिनट ',
        'Schedule hours' => 'अनुसूची घंटे',
        'Schedule days' => 'अनुसूची दिनों',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'फ़िलहाल इस सामान्य प्रतिनिधि के काम स्वचालित रूप से नहीं चलेंगे।',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'स्वचालित निष्पादन सक्रिय करने के लिए मिनट,घंटे और दिनों से कम से कम एक मान का चयन करें।',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => '',
        'List of all configured events' => '',
        'Delete this event' => '',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => '',
        '(e. g. 10*5155 or 105658*)' => '(उदा: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(उदा: 234321)',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(उदा: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'अनुच्छेद में पूर्ण पाठ खोजें(उदा: "Mar*in" or "Baue*") ',
        'To' => 'को',
        'Cc' => 'प्रति ',
        'Service' => 'सेवा',
        'Service Level Agreement' => 'सेवा लेवल समझौता',
        'Queue' => 'श्रेणी',
        'State' => 'अवस्था',
        'Agent' => 'प्रतिनिधि',
        'Owner' => 'स्वामी',
        'Responsible' => 'उत्तरदायी',
        'Ticket lock' => 'टिकट लॉक',
        'Dynamic fields' => '',
        'Add dynamic field' => '',
        'Create times' => 'समय बनाएँ',
        'No create time settings.' => 'कोई समय बनाने की व्यवस्थाऐं नहीं।',
        'Ticket created' => 'टिकट बनाया',
        'Ticket created between' => 'टिकट के बीच में बनाया गया',
        'and' => 'और',
        'Last changed times' => '',
        'No last changed time settings.' => '',
        'Ticket last changed' => '',
        'Ticket last changed between' => '',
        'Change times' => '',
        'No change time settings.' => '',
        'Ticket changed' => '',
        'Ticket changed between' => '',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'बंद समय',
        'No close time settings.' => 'कोई बंद समय व्यवस्थाऐं नहीं।',
        'Ticket closed' => 'टिकट बंद हुआ',
        'Ticket closed between' => 'टिकट के बीच में बंद हुआ',
        'Pending times' => 'विचाराधीन समय',
        'No pending time settings.' => 'कोई विचाराधीन समय व्यवस्थाऐं नहीं।',
        'Ticket pending time reached' => 'टिकट विचाराधीन समय आ गया',
        'Ticket pending time reached between' => 'टिकट विचाराधीन समय आ गया के बीच में',
        'Escalation times' => 'संवर्धित समय',
        'No escalation time settings.' => 'कोई संवर्धित समय व्यवस्थाऐं नहीं।',
        'Ticket escalation time reached' => 'टिकट संवर्धित समय आ गया',
        'Ticket escalation time reached between' => 'टिकट संवर्धित समय आ गया के बीच में',
        'Escalation - first response time' => 'संवर्धित पहली प्रतिक्रिया समय',
        'Ticket first response time reached' => 'टिकट पहली प्रतिक्रिया समय आ गया',
        'Ticket first response time reached between' => 'टिकट पहली प्रतिक्रिया समय आ गया के बीच में',
        'Escalation - update time' => 'संवर्धित अद्यतन समय ',
        'Ticket update time reached' => 'टिकट अद्यतन समय आ गया',
        'Ticket update time reached between' => 'टिकट अद्यतन समय आ गया के बीच में',
        'Escalation - solution time' => 'संवर्धित समाधान समय',
        'Ticket solution time reached' => 'टिकट समाधान समय आ गया',
        'Ticket solution time reached between' => 'टिकट समाधान समय आ गया के बीच में',
        'Archive search option' => 'संग्रह खोज विकल्प',
        'Update/Add Ticket Attributes' => '',
        'Set new service' => 'नई सेवा निर्धारित करें',
        'Set new Service Level Agreement' => 'नये सेवा लेवल समझौतॆ निर्धारित करें',
        'Set new priority' => 'नई प्राथमिकता निर्धारित करें',
        'Set new queue' => 'नई श्रेणी निर्धारित करें',
        'Set new state' => 'नई स्थिति निर्धारित करें',
        'Pending date' => 'विचाराधीन दिनांक',
        'Set new agent' => 'नया प्रतिनिधि निर्धारित करें',
        'new owner' => 'नया स्वामी',
        'new responsible' => '',
        'Set new ticket lock' => 'नया टिकट लॉक निर्धारित करें',
        'New customer user ID' => '',
        'New customer ID' => 'नया ग्राहक ID',
        'New title' => 'नया शीर्षक',
        'New type' => 'नए प्रकार',
        'Archive selected tickets' => 'संग्रह टिकट चयनित',
        'Add Note' => 'टिप्पणी जोड़ें',
        'Visible for customer' => '',
        'Time units' => 'समय इकाइयों',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'बदलाव पर प्रतिनिधि/ग्राहक कि अधिसूचना भेजें',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'यह  आदेश चलाएँ। ARG[0] टिकट संख्या होगी, ARG[0] टिकट id।',
        'Delete tickets' => 'टिकट हटाएँ',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'चेतावनी:सभी प्रभावित टिकट आंकड़ाकोष से हटा दिए जाएँगे और तब ये पुनर्स्थापित नहीं हो सकते।',
        'Execute Custom Module' => 'कस्टम मॉड्यूल चलाएँ',
        'Param %s key' => 'पैरा %s कुंजी',
        'Param %s value' => 'पैरा %s मूल्य',
        'Results' => 'परिणाम',
        '%s Tickets affected! What do you want to do?' => '%s प्रभावित टिकट। आप क्या करना चाहते हैं?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'चेतावनी: आपनॆ हटाएँ विकल्प का उपयोग किया है। सभी नष्ट टिकट लुप्त जाऍगॆ।',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Affected Tickets' => 'प्रभावित टिकट',
        'Age' => 'आयु',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => '',
        'Web Service Management' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'समय',
        'Communication ID' => '',
        'Remote IP' => '',
        'Loading' => '',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Limit' => 'सीमा',
        'Refresh' => '',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => '',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => '',
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
        'Do you really want to delete this invoker?' => '',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => '',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Asynchronous' => '',
        'Condition' => '',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Add Event' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => '',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => '',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Fields' => '',
        'Add a new Field' => '',
        'Remove this Field' => '',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => '',
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
        'Do you really want to delete this operation?' => '',
        'Operation Details' => '',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => '',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => '',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => '',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => '',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => '',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => '',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => '',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => '',
        'The password for the proxy user.' => '',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
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
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => '',
        'The default HTTP command to use for the requests.' => '',

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
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => '',
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
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Response name free text' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => '',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'Sort options' => '',
        'Add new first level element' => '',
        'Element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => '',
        'Clone' => '',
        'Export Web Service' => '',
        'Import web service' => '',
        'Configuration File' => '',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'आयात',
        'Configuration History' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Network transport' => '',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
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

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'इतिहास',
        'Go back to Web Service' => '',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'संस्करण',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',

        # Template: AdminGroup
        'Group Management' => 'समूह प्रबंधन',
        'Add Group' => 'समूह जोड़ें',
        'Edit Group' => 'समूह संपादित करें',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'व्यवस्थापक समूह के लिए समूह प्रबंधन के क्षेत्र का प्रयोग है और आँकड़े समूह आँकड़े क्षेत्र को प्राप्त करने के लिए।',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            ' विभिन्न समूहों के एजेंट की विभिन्न उपयोग अनुमतियो को संभालने के लिए नयॆ समूह बनाएँ।(उदा. क्रय विभाग,समर्थन विभाग,बिक्री विभाग,...)',
        'It\'s useful for ASP solutions. ' => 'यह ASP समाधान के लिए उपयोगी है।',

        # Template: AdminLog
        'System Log' => 'प्रणाली अभिलेख ',
        'Here you will find log information about your system.' => 'यहाँ पर आपको अपनी प्रणाली के बारे में अभिलेख की जानकारी मिल जाएगी।',
        'Hide this message' => 'इस संदेश को छिपाएँ',
        'Recent Log Entries' => 'ताज़ा अभिलेख प्रविष्टियां',
        'Facility' => 'सहूलियत',
        'Message' => 'संदेश',

        # Template: AdminMailAccount
        'Mail Account Management' => 'मेल खाता प्रबंधन',
        'Add Mail Account' => 'मेल खाता जोड़ें',
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
        'Host' => 'मेजबान',
        'Delete account' => 'खाता हटाएँ',
        'Fetch mail' => 'आनयन मेल',
        'Do you really want to delete this mail account?' => '',
        'Password' => 'कूटशब्द',
        'Example: mail.example.com' => 'उदाहरण:मेल.उदाहरण.कॉम',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'विश्वसनीय',
        'Dispatching' => 'प्रेषण',
        'Edit Mail Account' => 'मेल खाता संपादित करें',

        # Template: AdminNavigationBar
        'Administration Overview' => '',
        'Filter for Items' => '',
        'Filter' => 'निस्पादक',
        'Favorites' => '',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => '',
        'View the admin manual on Github' => '',
        'No Matches' => '',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'टिकट निस्पादक',
        'Lock' => 'लॉक',
        'SLA' => 'SLA',
        'Customer User ID' => '',
        'Article Filter' => 'अनुच्छेद निस्पादक',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article sender type' => '',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'अधिसूचना में संलग्नक शामिल करें',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'अधिसूचनाएँ एक प्रतिनिधि या एक ग्राहक को भेजी जाती है।',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'विषय के पहले 20 वर्ण (नवीनतम प्रतिनिधि अनुच्छेद में से) प्राप्त करने के लिए।',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'मुख्य-भाग (नवीनतम प्रतिनिधि अनुच्छेद में से एक) के पहले 5 लाइनें प्राप्त करने के लिए।',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'विषय के पहले 20 वर्ण (नवीनतम ग्राहक अनुच्छेद में से) प्राप्त करने के लिए।',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'मुख्य-भाग (नवीनतम ग्राहक अनुच्छेद  के) के पहले 5 लाइनें प्राप्त करने के लिए।',
        'Attributes of the current customer user data' => '',
        'Attributes of the current ticket owner user data' => '',
        'Attributes of the current ticket responsible user data' => '',
        'Attributes of the current agent user who requested this action' =>
            '',
        'Attributes of the ticket data' => '',
        'Ticket dynamic fields internal key values' => '',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '',
        'Downgrade to ((OTRS)) Community Edition' => '',
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
        'Go to the OTRS customer portal' => '',
        '%s will be available soon. Please check again in a few days.' =>
            '',
        'Please have a look at %s for more information.' => '',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '',
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
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '',
        'Go to OTRS Package Manager' => '',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'विक्रेता',
        'Please uninstall the packages first using the package manager and try again.' =>
            '',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '',
        'Report Generator' => '',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => '',

        # Template: AdminPGP
        'PGP Management' => 'PGP प्रबंधन',
        'Add PGP Key' => 'PGP कुंजी जोड़ें',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTRS, you have to enable it first.' => '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => '',
        'Check PGP configuration' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'इस तरह आपको सीधे प्रणाली विन्यास में विन्यस्त कुंजीरिंग संपादित कर सकते हैं।',
        'Introduction to PGP' => 'PGP के लिए परिचय',
        'Identifier' => 'पहचानकर्ता',
        'Bit' => 'थोड़ा',
        'Fingerprint' => 'अंगुली-चिह्न',
        'Expires' => 'समय सीमा समाप्त',
        'Delete this key' => 'इस कुंजी को हटाएँ',
        'PGP key' => 'PGP कुंजी',

        # Template: AdminPackageManager
        'Package Manager' => 'संकुल प्रबंधक',
        'Uninstall Package' => '',
        'Uninstall package' => 'संकुल जिनकी स्थापना रद्द हॊ गयी है',
        'Do you really want to uninstall this package?' => 'क्या आप वास्तव में इस संकुल की स्थापना रद्द करना चाहते हैं?',
        'Reinstall package' => 'संकुल की पुनर्स्थापना',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'क्या आप वास्तव में इस संकुल की पुनर्स्थापना करना चाहते हैं?सभी हस्तचालित परिवर्तन लुप्त हो जाएंगे।',
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
            '',
        'Install Package' => 'संकुल स्थापित करें',
        'Update Package' => '',
        'Continue' => 'जारी रखें',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'स्थापित',
        'Update repository information' => 'कोष जानकारी अद्यतन करें',
        'Cloud services are currently disabled.' => '',
        'OTRS Verify™ can not continue!' => '',
        'Enable cloud services' => '',
        'Update all installed packages' => '',
        'Online Repository' => 'ऑनलाइन कोष',
        'Action' => 'कार्रवाई',
        'Module documentation' => 'मॉड्यूल दस्तावेज',
        'Local Repository' => 'स्थानीय कोष',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'स्थापना रद्द',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        'Reinstall' => 'पुनर्स्थापना',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Package Information' => '',
        'Download package' => 'संकुल डाउनलोड करें ',
        'Rebuild package' => 'संकुल फिर से बनाएँ',
        'Metadata' => 'मेटाडेटा',
        'Change Log' => 'अभिलेख बदलना',
        'Date' => 'दिनांक',
        'List of Files' => 'फाइलों की सूची',
        'Permission' => 'अनुमति',
        'Download file from package!' => 'संकुल से फ़ाइल डाउनलोड करें ',
        'Required' => 'आवश्यकता',
        'Size' => 'आकार',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'फ़ाइल %s के लिए फ़ाइल अंतर',

        # Template: AdminPerformanceLog
        'Performance Log' => 'प्रदर्शन अभिलेख',
        'Range' => 'सीमा',
        'last' => 'पिछला',
        'This feature is enabled!' => 'यह सुविधा सक्षम है',
        'Just use this feature if you want to log each request.' => 'इस सुविधा का प्रयोग करें यदि आप प्रत्येक अनुरोध का अभिलेख चाहते हैं।',
        'Activating this feature might affect your system performance!' =>
            'यह सुविधा सक्रिय होनॆ पर आपके प्रणाली के प्रदर्शन को प्रभावित कर सकता।',
        'Disable it here!' => 'यहाँ निष्क्रिय करें',
        'Logfile too large!' => 'अभिलेख फ़ाइल बहुत बड़ा है',
        'The logfile is too large, you need to reset it' => 'अभिलेख फ़ाइल बहुत बड़ा है,इसे पुनर्स्थापित करनॆ की आवश्यकता हैं।',
        'Reset' => 'पुनर्स्थापित',
        'Overview' => 'अवलोकन',
        'Interface' => 'अंतरफलक',
        'Requests' => 'अनुरोध',
        'Min Response' => 'न्यूनतम प्रतिक्रिया',
        'Max Response' => 'अधिकतम प्रतिक्रिया',
        'Average Response' => 'औसत प्रतिक्रिया',
        'Period' => 'अवधि',
        'minutes' => 'मिनटों',
        'Min' => 'न्यूनतम',
        'Max' => 'अधिकत',
        'Average' => 'औसत',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'डाकपाल निस्पादक प्रबंधन',
        'Add PostMaster Filter' => 'डाकपाल निस्पादक जोड़ें',
        'Edit PostMaster Filter' => 'डाकपाल निस्पादक को संपादित करें',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            ' ईमेल शीर्षक के आधार पर आने वाली ईमेल को प्रेषण या निस्पादक करने के लिए। नियमित भाव सॆ भी मिलान संभव है।',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'यदि आप केवल ईमेल पते का मिलान करना चाहते हैं,तो से,प्रति या प्रतिलिपिसे में EMAILADDRESinfo@example.com का उपयोग करें।',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'यदि आप नियमित भाव का उपयोग करें,तो आप \निर्धारित करें\ कार्रवाई में जो मिलान मान () में है उसॆ [***] के रूप में उपयोग कर सकते हैं।',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'इस निस्पादक को हटाएँ',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'निस्पादक की शर्त',
        'AND Condition' => '',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Negate' => '',
        'Set Email Headers' => 'ईमेल शीर्षक निर्धारित करें',
        'Set email header' => '',
        'with value' => '',
        'The field needs to be a literal word.' => '',
        'Header' => 'शीर्षक',

        # Template: AdminPriority
        'Priority Management' => 'प्राथमिकता प्रबंधन',
        'Add Priority' => 'प्राथमिकता जोड़ें',
        'Edit Priority' => 'प्राथमिकता संपादित करें ',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter for processes' => '',
        'Create New Process' => '',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Print' => 'मुद्रित करें',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
        'Go Back' => '',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => '',
        'Activity Name' => '',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => '',
        'Description (short)' => '',
        'Description (long)' => '',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => '',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => '',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '',
        'Filter Activities...' => '',
        'Create New Activity' => '',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => '',
        'Delete Process' => '',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'Process Name' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
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

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '',
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Add a new Parameter' => '',
        'Remove this Parameter' => '',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'श्रेणी जोड़ें',
        'Edit Queue' => 'श्रेणी को संपादित करें',
        'Filter for Queues' => 'श्रेणी के लिए निस्पादक',
        'Filter for queues' => '',
        'A queue with this name already exists!' => '',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'की उप-श्रेणी',
        'Unlock timeout' => 'अनलॉक समय समाप्त',
        '0 = no unlock' => '0 = कोई अनलॉक  नहीं',
        'hours' => 'घंटे',
        'Only business hours are counted.' => 'केवल व्यापार घंटे गिने जाते हैं।',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'यदि एक प्रतिनिधि टिकट को लॉक करता है और अनलॉक समय समाप्ति बीत जानॆ से पहले उसे बंद नहीं करता है, टिकट अनलॉक हो जाएगा और अन्य प्रतिनिधियॊ के लिए उपलब्ध हो जाएगा।',
        'Notify by' => 'के द्वारा सूचित करें',
        '0 = no escalation' => '0 = कोई संवर्धित नहीं',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'यदि यहां परिभाषित समय समाप्त होनॆ से पहले टिकट को यदि एक ग्राहक संपर्क नहीं जोड़ा जाता है,या तो बाहरी-ईमेल या फोन भी नहीं जोड़ा जाता है,तो टिकट संवर्धित हो जाएगा।',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'यदि एक अनुच्छेद जोड़ा जाए,जैसे कोई अनुवर्ती ईमेल या ग्राहक पोर्टल के माध्यम से,वृद्धि अद्यतन समय पुनर्स्थापित हो जाता है। यदि यहां परिभाषित समय समाप्त होनॆ से पहले टिकट को यदि एक ग्राहक संपर्क नहीं जोड़ा जाता है,या तो बाहरी-ईमेल या फोन भी नहीं जोड़ा जाता है,तो टिकट संवर्धित हो जाएगा। ',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'यदि टिकट बंद को स्थापित नहीं है यहां परिभाषित समय समाप्त होनॆ से पहले,तो टिकट संवर्धित हो जाएगा।',
        'Follow up Option' => 'निगरानी विकल्प',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'यह निर्दिष्ट करता है की यदि बंद टिकट को निगरानी विकल्प दिया जाए तो वह टिकट को पुनः खोल सकता है,अस्वीकार कर सकता है या एक नए टिकट को बना सकता है।',
        'Ticket lock after a follow up' => 'टिकट लॉक निगरानी के बाद ',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'यदि एक टिकट बंद है और ग्राहक एक अनुवर्ती भेजता है तो टिकट पुराने स्वामी को लॉक कर दिया जायेगा।',
        'System address' => 'प्रणाली का पता',
        'Will be the sender address of this queue for email answers.' => 'ईमेल के जवाब के लिए इस श्रेणी में प्रेषक का पता होगा।',
        'Default sign key' => 'तयशुदा हस्ताक्षर कुंजी',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'अभिवादन',
        'The salutation for email answers.' => 'ईमेल उत्तर के लिए अभिवादन।',
        'Signature' => 'हस्ताक्षर',
        'The signature for email answers.' => 'ईमेल उत्तर के लिए हस्ताक्षर।',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'श्रेणी-स्वतप्रतिक्रिया संबंधों का प्रबंधन करें',
        'Change Auto Response Relations for Queue' => 'श्रेणी के लिए स्वतप्रतिक्रिया संबंधों को बदलॆ',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => '',
        'Show All Queues' => '',
        'Auto Responses' => 'स्वत प्रतिक्रियाएँ',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Filter for templates' => '',
        'Templates' => '',

        # Template: AdminRegistration
        'System Registration Management' => '',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTRS-ID' => '',
        'Deregister System' => '',
        'Edit details' => '',
        'Show transmitted data' => '',
        'Deregister system' => '',
        'Overview of registered systems' => '',
        'This system is registered with OTRS Group.' => '',
        'System type' => '',
        'Unique ID' => '',
        'Last communication with registration server' => '',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '',
        'Instructions' => '',
        'System Deregistration not Possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => '',
        'Read more' => '',
        'You need to log in with your OTRS-ID to register your system.' =>
            '',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            '',
        'Data Protection' => '',
        'What are the advantages of system registration?' => '',
        'You will receive updates about relevant security releases.' => '',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => '',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTRS without being registered?' => '',
        'System registration is optional.' => '',
        'You can download and use OTRS without being registered.' => '',
        'Is it possible to deregister?' => '',
        'You can deregister at any time.' => '',
        'Which data is transfered when registering?' => '',
        'A registered system sends the following data to OTRS Group:' => '',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            '',
        'Why do I have to provide a description for my system?' => '',
        'The description of the system is optional.' => '',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '',
        'How often does my OTRS system send updates?' => '',
        'Your system will send updates to the registration server at regular intervals.' =>
            '',
        'Typically this would be around once every three days.' => '',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => '',
        'You don\'t have an OTRS-ID yet?' => '',
        'Sign up now' => 'अभी पंजीकरण करें',
        'Forgot your password?' => '',
        'Retrieve a new one' => '',
        'Next' => 'अगला',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '',
        'Attribute' => '',
        'FQDN' => '',
        'OTRS Version' => '',
        'Operating System' => '',
        'Perl Version' => '',
        'Optional description of this system.' => '',
        'Register' => '',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => '',
        'You can modify registration settings here.' => '',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

        # Template: AdminRole
        'Role Management' => 'भूमिका प्रबंधन',
        'Add Role' => 'भूमिका जोड़ें',
        'Edit Role' => 'भूमिका संपादित करें',
        'Filter for Roles' => 'भूमिकाओं के लिए निस्पादक',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'एक भूमिका बनाएँ और समूहों को उसमें डालॆ। फिर भूमिका को उपयोगकर्ताओं से जोड़ें।',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'वहाँ कोई परिभाषित भूमिकाएं नहीं है। कृपया \'जोड़ें \' बटन का उपयोग करें नई भूमिका बनाने के लिए।',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'भूमिका-समूह संबंधों का प्रबंधन करें',
        'Roles' => 'भूमिकाएं',
        'Select the role:group permissions.' => 'भूमिका:समूह अनुमतियों का चयन करें',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'अगर कुछ भी चयनित नहीं है,तो फिर इस समूह में कोई अनुमतियाँ नहीं हैं(टिकट भूमिका के लिए उपलब्ध नहीं होंगे)।',
        'Toggle %s permission for all' => 'स्विच %s सभी के लिए अनुमति है',
        'move_into' => 'में स्थानांतरित',
        'Permissions to move tickets into this group/queue.' => 'इस समूह/श्रेणी में टिकट स्थानांतरित करने के लिए अनुमतियाँ।',
        'create' => 'बनाने के लिए',
        'Permissions to create tickets in this group/queue.' => 'इस समूह/श्रेणी में टिकट बनाने के लिए करने के लिए अनुमतियाँ।',
        'note' => 'टिप्पणी',
        'Permissions to add notes to tickets in this group/queue.' => 'इस समूह/श्रेणी मॆ टिकटों को टिप्पणी जोड़ने के लिए अनुमतियाँ।',
        'owner' => 'स्वामी',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'इस समूह/श्रेणी मॆ टिकटों के स्वामी बदलने के लिए अनुमतियाँ।',
        'priority' => 'प्राथमिकता',
        'Permissions to change the ticket priority in this group/queue.' =>
            'इस समूह/श्रेणी में टिकट की प्राथमिकता बदलने के लिए अनुमतियाँ।',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'प्रतिनिधि-भूमिका संबंधों का प्रबंधन करें',
        'Add Agent' => 'प्रतिनिधि जोड़ें',
        'Filter for Agents' => 'प्रतिनिधियॊ के लिए निस्पादक',
        'Filter for agents' => '',
        'Agents' => 'प्रतिनिधियॊ',
        'Manage Role-Agent Relations' => 'भूमिका-प्रतिनिधि संबंधों का प्रबंधन करें',

        # Template: AdminSLA
        'SLA Management' => 'SLA प्रबंधन',
        'Edit SLA' => 'SLA संपादित करें',
        'Add SLA' => 'SLA जोड़ें',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'केवल संख्याएँ लिखें',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME प्रबंधन',
        'Add Certificate' => 'प्रमाणपत्र जोड़ें',
        'Add Private Key' => 'निजी कुंजी जोड़ें',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Filter for Certificates' => '',
        'Filter for certificates' => '',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'यह भी देखें',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'इस तरह आप सीधे प्रमाणीकरण और फाइल प्रणाली में निजी कुंजी संपादित कर सकते हैं।',
        'Hash' => 'इस तरह आप सीधे प्रमाणीकरण और फाइल प्रणाली में निजी कुंजी संपादित कर सकते हैं।',
        'Create' => 'बनाएँ',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => 'इस प्रमाणपत्र को हटाएँ',
        'File' => 'संचिका',
        'Secret' => 'गोपनीय',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Filter for S/MIME certs' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME प्रमाणपत्र',
        'Close this dialog' => 'इस संवाद को बंद करें',
        'Certificate Details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'अभिवादन प्रबंधन',
        'Add Salutation' => 'अभिवादन जोड़ें ',
        'Edit Salutation' => 'अभिवादन संपादित करें',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'उदा.',
        'Example salutation' => 'अभिवादन के उदाहरण',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'सुरक्षित मोड (सामान्य रूप से)प्रारंभिक स्थापना पूरी होनॆ के बाद निर्धारित किया जाएगा।',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'यदि सुरक्षित मोड सक्रिय नहीं है,तो उसे प्रणाली विन्यास के माध्यम से सक्रिय करें क्योंकि आपका अनुप्रयोग पहले से चल रहा है।',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL संदूक',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            'SQL को सीधे अनुप्रयोग डेटाबेस को भेजने के लिए यहाँ दर्ज कर सकते हैं।',
        'Options' => 'विकल्प',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'आपकी SQL क्वेरी के वाक्यविन्यास मॆ गलती हैं। उसकी जाँच करें।',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'इसमें बंधन के लिए कम से कम गायब एक मापदण्ड है। उसकी जाँच करें।',
        'Result format' => 'परिणाम का स्वरूप',
        'Run Query' => 'क्वेरी चलाएँ',
        '%s Results' => '',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => 'सेवा प्रबंधन',
        'Add Service' => 'सेवा जोड़ें ',
        'Edit Service' => 'सेवा संपादित करें',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'की उप-सेवा',

        # Template: AdminSession
        'Session Management' => 'सत्र प्रबंधन',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'सभी सत्रों',
        'Agent sessions' => 'प्रतिनिधि सत्र',
        'Customer sessions' => 'ग्राहक सत्र',
        'Unique agents' => 'अद्वितीय प्रतिनिधि',
        'Unique customers' => 'अद्वितीय ग्राहक',
        'Kill all sessions' => 'सभी सत्रों को नष्ट कर दे',
        'Kill this session' => 'इस सत्र को नष्ट कर दे',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'सत्र',
        'User' => 'उपयोगकर्ता',
        'Kill' => 'नष्ट',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'हस्ताक्षर प्रबंधन',
        'Add Signature' => 'हस्ताक्षर जोड़ें',
        'Edit Signature' => 'हस्ताक्षर संपादित करें',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'हस्ताक्षर के उदाहरण',

        # Template: AdminState
        'State Management' => 'स्थिति प्रबंधन',
        'Add State' => 'स्थिति जोड़ें',
        'Edit State' => 'स्थिति संपादित करें',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'ध्यान दें',
        'Please also update the states in SysConfig where needed.' => '',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'स्थिति के प्रकार',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => '',
        'Enable Cloud Services' => '',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Currently this data is only shown in this system.' => '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => 'प्रेषक',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'तंत्र ईमेल पते प्रबंधन',
        'Add System Email Address' => 'प्रणाली का ईमेल पता शामिल करें',
        'Edit System Email Address' => 'प्रणाली का ईमेल पता संपादित करें',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'प्रति या प्रतिलिपि के इस पते के साथ सभी आने वाली ईमेल को चयनित श्रेणी को भेज दिया जाएगा।',
        'Email address' => 'ईमेल पता',
        'Display name' => 'प्रदर्शित होने वाला नाम',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'आपके द्वारा भेजे गए मेल पर प्रदर्शित होने वाला नाम और ईमेल पता दिखाया जाएगा।',
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
        'Category' => 'वर्ग',
        'Run search' => '',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '',
        'Schedule New System Maintenance' => '',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Stop date' => '',
        'Delete System Maintenance' => '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'अवैध दिनांक',
        'Login message' => '',
        'This field must have less then 250 characters.' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => '',
        'Edit Template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Attachments' => 'संलग्नक',
        'Delete this entry' => 'इस प्रविष्टि को हटाएँ',
        'Do you really want to delete this template?' => '',
        'A standard template with this name already exists!' => '',
        'Template' => '',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'वर्तमान टिकट की स्थिति है ',
        'Your email address is' => 'आपका ईमेल पता है',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'सभी के लिए स्विच सक्रिय करें',
        'Link %s to selected %s' => 'लिंक %s को चयनित %s',

        # Template: AdminType
        'Type Management' => 'प्रकार प्रबंधन',
        'Add Type' => 'प्रकार जोड़ें',
        'Edit Type' => 'प्रकार संपादित करें',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => '',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'प्रतिनिधि प्रबंधन',
        'Edit Agent' => 'प्रतिनिधि संपादित करें',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'प्रतिनिधियॊ के लिए टिकट संभालना जरूरी हो जाएगा।',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'प्रतिनिधियॊ को समूहों और/या भूमिकाएं सॆ जोड़ना ना भुलॆ।',
        'Please enter a search term to look for agents.' => 'कृपया एक खोज शब्द दर्ज करें प्रतिनिधियॊ को देखने के लिए।',
        'Last login' => 'पिछला प्रवेश',
        'Switch to agent' => 'प्रतिनिधि से बदलें',
        'Title or salutation' => '',
        'Firstname' => 'पहला नाम',
        'Lastname' => 'आखिरी नाम',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '',
        'Mobile' => 'मोबाइल',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'प्रतिनिधि-समूह संबंधों का प्रबंधन करें',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '',
        'Manage Calendars' => '',
        'Add Appointment' => '',
        'Today' => 'आज',
        'All-day' => '',
        'Repeat' => '',
        'Notification' => 'अधिसूचनाएँ',
        'Yes' => 'हाँ',
        'No' => 'नहीं',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '',
        'Calendars' => '',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'अवैध दिनांक',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'दिनों',
        'week(s)' => 'हफ्ते',
        'month(s)' => 'महीने',
        'year(s)' => 'वर्षों',
        'On' => 'चालू करें',
        'Monday' => 'सोमवार',
        'Mon' => 'सोमवार',
        'Tuesday' => 'मंगलवार',
        'Tue' => 'मंगलवार',
        'Wednesday' => 'बुधवार',
        'Wed' => 'बुधवार',
        'Thursday' => 'गुरूवार',
        'Thu' => 'गुस्र्वार',
        'Friday' => 'शुक्रवार',
        'Fri' => 'शुक्रवार',
        'Saturday' => 'शनिवार',
        'Sat' => 'शनिवार',
        'Sunday' => 'रविवार',
        'Sun' => 'रविवार',
        'January' => 'जनवरी',
        'Jan' => 'जनवरी',
        'February' => 'फ़रवरी',
        'Feb' => 'फ़रवरी',
        'March' => 'मार्च',
        'Mar' => 'मार्च',
        'April' => 'अप्रैल',
        'Apr' => 'अप्रैल',
        'May_long' => 'मई',
        'May' => 'मई',
        'June' => 'जून',
        'Jun' => 'जून',
        'July' => 'जुलाई',
        'Jul' => 'जुलाई',
        'August' => 'अगस्त',
        'Aug' => 'अगस्त',
        'September' => 'सितम्बर',
        'Sep' => 'सितम्बर',
        'October' => 'अक्टूबर',
        'Oct' => 'अक्टूबर',
        'November' => 'नवम्बर',
        'Nov' => 'नवम्बर',
        'December' => 'दिसम्बर',
        'Dec' => 'दिसम्बर',
        'Relative point of time' => '',
        'Link' => 'कड़ी',
        'Remove entry' => 'प्रविष्टि को हटाएँ',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '',
        'Start chat' => '',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'टेम्पलेट खोजें',
        'Create Template' => 'टेम्पलेट बनाएँ',
        'Create New' => 'नया बनाएँ',
        'Save changes in template' => 'टेम्पलेट में बदलाव सुरक्षित करें',
        'Filters in use' => '',
        'Additional filters' => '',
        'Add another attribute' => 'एक और विशेषता जोड़ें',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'सभी का चयन करें',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'खोज विकल्प बदलें',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            '',
        'Starting the OTRS Daemon' => '',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            '',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'नियंत्रण-पट्ट',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '',
        'Tomorrow' => 'कल',
        'Soon' => '',
        '5 days' => '',
        'Start' => 'आरंभ',
        'none' => 'कोई नहीं',

        # Template: AgentDashboardCalendarOverview
        'in' => 'में',

        # Template: AgentDashboardCommon
        'Save settings' => '',
        'Close this widget' => '',
        'more' => 'अधिक',
        'Available Columns' => '',
        'Visible Columns (order by drag & drop)' => '',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'खुला',
        'Closed' => 'बंद',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',
        'Open tickets' => '',
        'Closed tickets' => '',
        'All tickets' => 'सभी टिकट',
        'Archived tickets' => '',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s उपलब्ध है',
        'Please update now.' => 'कृपया अभी अद्यतन करें',
        'Release Note' => 'प्रकाशन टिप्पणी',
        'Level' => 'स्तर',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '%s पहले प्रस्तुत।',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '',
        'Download as SVG file' => '',
        'Download as PNG file' => '',
        'Download as CSV file' => '',
        'Download as Excel file' => '',
        'Download as PDF file' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => '',
        'My watched tickets' => '',
        'My responsibilities' => '',
        'Tickets in My Queues' => '',
        'Tickets in My Services' => '',
        'Service Time' => 'सेवा समय',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'किसी समाचार,लाइसेंस या कुछ बदलाव स्वीकार करने के लिए।',
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
        'Edit your preferences' => 'अपनी वरीयताएँ संपादित करें',
        'Personal Preferences' => '',
        'Preferences' => 'वरीयताएं',
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
        'Off' => 'बंद',
        'End' => 'समाप्त',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTRS at %s.' => '',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => '',
        'Process' => '',
        'Split' => '',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTRS' => '',
        'Dynamic Matrix' => '',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => '',
        'Each row contains data of one entity.' => '',
        'Static' => '',
        'Non-configurable complex statistics.' => '',
        'General Specification' => '',
        'Create Statistic' => '',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => '',
        'Statistics Preview' => '',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'सांख्यिकी',
        'Run' => '',
        'Edit statistic "%s".' => '',
        'Export statistic "%s"' => '',
        'Export statistic %s' => '',
        'Delete statistic "%s"' => '',
        'Delete statistic %s' => '',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'द्वारा बनाया गया',
        'Changed by' => 'से बदला',
        'Sum rows' => 'पंक्ति योग',
        'Sum columns' => 'स्तंभ योग',
        'Show as dashboard widget' => '',
        'Cache' => 'द्रुतिका',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => '',
        'Close %s%s%s' => '',
        'Add Note to %s%s%s' => '',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => '',
        'Change Responsible of %s%s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => '',
        'The ticket has been locked' => 'टिकट के लॉक कर दिया गया है',
        'Undo & close' => '',
        'Ticket Settings' => 'टिकट व्यवस्थाऐं',
        'Queue invalid.' => '',
        'Service invalid.' => 'अवैध सेवा।',
        'SLA invalid.' => '',
        'New Owner' => 'नया स्वामी',
        'Please set a new owner!' => 'कृपया नया स्वामी सेट करें',
        'Owner invalid.' => '',
        'New Responsible' => '',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'अगली स्थिति',
        'State invalid.' => '',
        'For all pending* states.' => '',
        'Add Article' => '',
        'Create an Article' => '',
        'Inform agents' => '',
        'Inform involved agents' => '',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Text will also be received by' => '',
        'Text Template' => '',
        'Setting a template will overwrite any text or attachment.' => '',
        'Invalid time!' => 'अवैध समय',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'फलांग तक',
        'You need a email address.' => 'आपको ईमेल पते की आवश्यकता।',
        'Need a valid email address or don\'t use a local email address.' =>
            'एक मान्य ईमेल पता की आवश्यकता है या एक स्थानीय ईमेल पते का उपयोग मत किजिए।',
        'Next ticket state' => 'टिकट की अगली स्थिति',
        'Inform sender' => 'प्रेषक को सूचित करें',
        'Send mail' => 'मेल भेजें',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'टिकट थोक कार्रवाई',
        'Send Email' => 'मेल भेजें',
        'Merge' => 'मिलाएं',
        'Merge to' => 'मे मिलाएं',
        'Invalid ticket identifier!' => 'अवैध टिकट पहचानकर्ता',
        'Merge to oldest' => 'पुराने मे मिलाएं',
        'Link together' => 'एक साथ लिंक करें',
        'Link to parent' => 'अभिभावकों के साथ लिंक करें',
        'Unlock tickets' => 'अनलॉक टिकट',
        'Execute Bulk Action' => '',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => '',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'This address already exists on the address list.' => '',
        'Remove Cc' => '',
        'Bcc' => 'गुप्त प्रति',
        'Remove Bcc' => '',
        'Date Invalid!' => 'अवैध दिनांक',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',
        'Customer Information' => 'ग्राहक की जानकारी',
        'Customer user' => 'ग्राहक उपयोगकर्ता',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'नई ईमेल टिकट बनाएँ',
        'Example Template' => '',
        'From queue' => 'श्रेणी से',
        'To customer user' => '',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'सभी प्राप्त करें',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => '',
        'Article' => 'अनुच्छेद',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => 'आपको एक टिकट नंबर का उपयोग आवश्यक है',
        'A valid ticket number is required.' => 'एक वैध टिकट संख्या की आवश्यकता है।',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => 'वैध ईमेल पता चाहिए।',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'नई श्रेणी',
        'Move' => 'स्थान-परिवर्तन',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'कोई टिकट आंकड़ा नहीं मिला',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => '',
        'Sender' => 'प्रेषक',
        'First Response Time' => 'पहला प्रतिक्रिया समय',
        'Update Time' => 'अद्यतन समय',
        'Solution Time' => 'समाधान समय',
        'Move ticket to a different queue' => 'एक अलग श्रेणी में टिकट को ले जाएँ',
        'Change queue' => 'श्रेणी बदलें',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'टिकट प्रति पृष्ठ',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',
        'Column Filters Form' => '',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'नया फोन टिकट बनाएँ',
        'Please include at least one customer for the ticket.' => '',
        'To queue' => 'श्रेणी में',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'सरल',
        'Download this email' => 'इस ईमेल को डाउनलोड करें',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Profile link' => '',
        'Output' => 'आउटपुट',
        'Fulltext' => 'पूर्ण पाठ',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'श्रेणी में बनाया गया',
        'Lock state' => 'लॉक स्थिति',
        'Watcher' => 'पहरेदार',
        'Article Create Time (before/after)' => 'अनुच्छेद बनाने का समय (के बाद/से पहले)',
        'Article Create Time (between)' => 'अनुच्छेद बनाने का समय (बीच में)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'टिकट बनाने का समय (के बाद/से पहले)',
        'Ticket Create Time (between)' => 'टिकट बनाने का समय (बीच में)',
        'Ticket Change Time (before/after)' => 'टिकट बदलनॆ का समय (के बाद/से पहले)',
        'Ticket Change Time (between)' => 'टिकट बदलनॆ का समय (बीच में)',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'टिकट बंद होने का समय (के बाद/से पहले)',
        'Ticket Close Time (between)' => 'टिकट बंद होने का समय (बीच में)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'संग्रह खोजें',

        # Template: AgentTicketZoom
        'Sender Type' => 'प्रेषक का प्रकार',
        'Save filter settings as default' => 'तयशुदा रूप में निस्पादक की व्यवस्थाऐं सुरक्षित करें',
        'Event Type' => '',
        'Save as default' => '',
        'Drafts' => '',
        'by' => 'द्वारा',
        'Change Queue' => 'श्रेणी बदलें',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Ticket Timeline View' => '',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'निस्पादक जोड़ें',
        'Set' => 'निर्धारित करें',
        'Reset Filter' => 'निस्पादक को फिर से निर्धारित करें',
        'No.' => 'संख्या',
        'Unread articles' => 'अपठित अनुच्छेद',
        'Via' => '',
        'Important' => '',
        'Unread Article!' => 'अपठित अनुच्छेद',
        'Incoming message' => 'आने वाले संदेश',
        'Outgoing message' => 'जाने वाले संदेश ',
        'Internal message' => 'अंदरूनी संदेश',
        'Sending of this message has failed.' => '',
        'Resize' => 'आकारबदलें',
        'Mark this article as read' => '',
        'Show Full Text' => '',
        'Full Article Text' => '',
        'No more events found. Please try changing the filter settings.' =>
            '',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => '',
        'Image' => '',
        'PDF' => '',
        'Unknown' => '',
        'View' => 'देखें',

        # Template: LinkTable
        'Linked Objects' => 'लिंक्ड वस्तु',

        # Template: TicketInformation
        'Archive' => '',
        'This ticket is archived.' => '',
        'Note: Type is invalid!' => '',
        'Pending till' => 'स्थगित जब तक',
        'Locked' => 'लॉकड',
        '%s Ticket(s)' => '',
        'Accounted time' => 'अकाउंटटेड समय',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'लोड विषयवस्तु अवरुद्ध',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'आप कर सकते हैं',
        'go back to the previous page' => 'पिछले पृष्ठ पर वापस जाने के लिए',

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
        'Error Details' => 'त्रुटि का विवरण',
        'Traceback' => 'ट्रेसबैक',

        # Template: CustomerFooter
        '%s powered by %s™' => '',
        'Powered by %s™' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'जावास्क्रिप्ट उपलब्ध नहीं है।',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'ब्राउज़र चेतावनी',
        'The browser you are using is too old.' => 'आप जो ब्राउज़र उपयोग कर रहे बहुत पुराना है।',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'कृपया अधिक जानकारी के लिए दस्तावेज़ देखे या अपने व्यवस्थापक से पूछे।',
        'One moment please, you are being redirected...' => '',
        'Login' => 'प्रवेश',
        'User name' => 'उपयोगकर्ता का नाम',
        'Your user name' => 'आपका उपयोगकर्ता नाम',
        'Your password' => 'आपका कूटशब्द',
        'Forgot password?' => 'कूटशब्द भूल गए?',
        '2 Factor Token' => '',
        'Your 2 Factor Token' => '',
        'Log In' => 'प्रवेश',
        'Not yet registered?' => 'अभी तक पंजीकृत नही?',
        'Back' => 'वापस',
        'Request New Password' => 'नए कूटशब्द के लिए अनुरोध करे',
        'Your User Name' => 'आपका उपयोगकर्ता नाम',
        'A new password will be sent to your email address.' => 'एक नया कूटशब्द आपके ईमेल पते पर भेजा जाएगा।',
        'Create Account' => 'खाता बनाएँ',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'हम आपको कैसे संबोधित करें',
        'Your First Name' => 'आपका पहला नाम',
        'Your Last Name' => 'आपका आखिरी नाम',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '',
        'Edit personal preferences' => 'व्यक्तिगत वरीयताएँ संपादित करें',
        'Logout %s' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'सेवा स्तर अनुबंध',

        # Template: CustomerTicketOverview
        'Welcome!' => 'आपका स्वागत है',
        'Please click the button below to create your first ticket.' => 'अपना पहला टिकट बनाने के लिए कृपया नीचे दिए गए बटन को दबाऐ।',
        'Create your first ticket' => 'अपना पहला टिकट बनाएँ',

        # Template: CustomerTicketSearch
        'Profile' => 'वर्णन',
        'e. g. 10*5155 or 105658*' => 'उदा.: 10*5155 or 105658*',
        'CustomerID' => 'ग्राहक ID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'प्रकार',
        'Time Restrictions' => '',
        'No time settings' => '',
        'All' => 'सभी',
        'Specific date' => '',
        'Only tickets created' => 'केवल टिकट बनाए',
        'Date range' => '',
        'Only tickets created between' => 'कॆवल वही टिकट जो इस बीच बनाए गए',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'टेम्पलेट के रूप में सुरक्षित करें ?',
        'Save as Template' => '',
        'Template Name' => 'टेम्पलेट का नाम',
        'Pick a profile name' => '',
        'Output to' => 'को आउटपुट',

        # Template: CustomerTicketSearchResultShort
        'of' => 'की',
        'Page' => 'पृष्ठ',
        'Search Results for' => 'के लिए परिणाम खोजें',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '',
        'Next Steps' => '',
        'Reply' => 'जवाब देना',

        # Template: Chat
        'Expand article' => 'अनुच्छेद का विस्तार करें',

        # Template: CustomerWarning
        'Warning' => 'चेतावनी',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => '',
        'Ticket fields' => '',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '',
        'Send a bugreport' => 'दोष रिपोर्ट भेजें',
        'Expand' => 'विस्तार',

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
        'View notifications' => '',
        'Notifications' => '',
        'Notifications (OTRS Business Solution™)' => '',
        'Personal preferences' => '',
        'Logout' => 'बाहर प्रवेश करें',
        'You are logged in as' => 'आप इस रूप में प्रवॆशित हैं।',

        # Template: Installer
        'JavaScript not available' => 'जावास्क्रिप्ट उपलब्ध नहीं है।',
        'Step %s' => 'चरण %s',
        'License' => 'स्वच्छंदता',
        'Database Settings' => 'आंकड़ाकोष व्यवस्थाऐं',
        'General Specifications and Mail Settings' => 'सामान्य निर्दिष्टीकरण और मेल व्यवस्थाऐं',
        'Finish' => 'खत्म',
        'Welcome to %s' => '',
        'Germany' => '',
        'Phone' => 'फोन',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'वेबसाइट',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'आउटबाउंड मेल विन्यस्त करें',
        'Outbound mail type' => 'आउटबाउंड मेल का प्रकार',
        'Select outbound mail type.' => 'आउटबाउंड मेल प्रकार का चयन करें।',
        'Outbound mail port' => 'आउटबाउंड मेल का द्वारक',
        'Select outbound mail port.' => 'आउटबाउंड मेल द्वारक का चयन करें।',
        'SMTP host' => 'SMTP मेजबान',
        'SMTP host.' => 'SMTP मेजबान।',
        'SMTP authentication' => 'SMTP प्रमाणीकरण',
        'Does your SMTP host need authentication?' => 'क्या आपके SMTP मेजबान को प्रमाणीकरण की आवश्यकता है?',
        'SMTP auth user' => 'SMTP प्रमाणीकरण उपयोगकर्ता',
        'Username for SMTP auth.' => 'SMTP प्रमाणीकरण के लिए उपयोगकर्ता नाम',
        'SMTP auth password' => 'SMTP प्रमाणीकरण का कूटशब्द',
        'Password for SMTP auth.' => 'SMTP प्रमाणीकरण के लिए कूटशब्द',
        'Configure Inbound Mail' => 'इनबाउंड मेल विन्यस्त करें',
        'Inbound mail type' => 'इनबाउंड मेल का प्रकार',
        'Select inbound mail type.' => 'इनबाउंड मेल प्रकार का चयन करें।',
        'Inbound mail host' => 'इनबाउंड मेल का मेजबान',
        'Inbound mail host.' => 'इनबाउंड मेल का मेजबान।',
        'Inbound mail user' => 'इनबाउंड मेल उपयोगकर्ता ',
        'User for inbound mail.' => 'इनबाउंड मेल के लिए उपयोगकर्ता।',
        'Inbound mail password' => 'इनबाउंड मेल कूटशब्द',
        'Password for inbound mail.' => 'इनबाउंड मेल के लिए कूटशब्द।',
        'Result of mail configuration check' => 'मेल विन्यास की जाँच के नतीजे',
        'Check mail configuration' => 'मेल विन्यास की जाँच करें',
        'Skip this step' => 'यह चरण छोड़ें',

        # Template: InstallerDBResult
        'Done' => 'किया',
        'Error' => 'त्रुटि',
        'Database setup successful!' => '',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database name' => '',
        'Check database settings' => 'आंकड़ाकोष व्यवस्थाऒं की जाँच करें',
        'Result of database check' => 'आंकड़ाकोष की जाँच के नतीजे',
        'Database check successful.' => 'आंकड़ाकोष की जाँच सफल रही।',
        'Database User' => '',
        'New' => 'नया',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'सीमित अधिकार के साथ एक नया आंकड़ाकोष उपयोगकर्ता इस OTRS प्रणाली के लिए बनाया जाएगा।',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'OTRS का प्रयोग करनॆ कॆ लिए आपको निम्नलिखित पंक्ति रूट के रूप में कमांड लाइन (टर्मिनल/शैल) में दॆनी होगी।',
        'Restart your webserver' => 'वेबसर्वर पुनरारंभ करें',
        'After doing so your OTRS is up and running.' => 'ऐसा करने के बाद आपका OTRS तैयार है।',
        'Start page' => 'प्रारंभिक पेज',
        'Your OTRS Team' => 'आपका OTRS समूह',

        # Template: InstallerLicense
        'Don\'t accept license' => 'लाइसेंस स्वीकार नहीं',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'SystemID' => 'सिस्टम ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'प्रणाली का पहचानकर्ता। प्रत्येक टिकट संख्या और प्रत्येक HTTP सत्र ID कॆ पास यह संख्या होती हैं।',
        'System FQDN' => 'प्रणाली FQDN',
        'Fully qualified domain name of your system.' => 'पूरी तरह से योग्य आपके सिस्टम का प्रक्षेत्र नाम।',
        'AdminEmail' => 'व्यवस्थापक ईमेल',
        'Email address of the system administrator.' => 'प्रणाली प्रशासक का ईमेल पता।',
        'Organization' => 'संगठन',
        'Log' => 'अभिलेख',
        'LogModule' => 'मॉड्यूल अभिलेख',
        'Log backend to use.' => 'अभिलेख का बैकेंड प्रयोग के लिये',
        'LogFile' => 'अभिलेख फ़ाइल',
        'Webfrontend' => 'वेब दृश्यपटल',
        'Default language' => 'तयशुदा भाषा',
        'Default language.' => 'तयशुदा भाषा।',
        'CheckMXRecord' => 'MX रिकार्ड की जाँच करें',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'ईमेल पते जो कि दस्ती रूप से दाखिल कर रहे हैं,वो DNS मॆं MX रिकॉर्ड्स से जाँचे जा रहे है। इस विकल्प का उपयोग न करें यदि आपके DNS धीमा है या सार्वजनिक पते को हल नहीं कर सकता।',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => 'वस्तु#',
        'Add links' => 'लिंक जोड़ें',
        'Delete links' => 'लिंक हटाएँ',

        # Template: Login
        'Lost your password?' => ' आपने कूटशब्द खो दिया?',
        'Back to login' => 'प्रवेश करने के लिए वापस जाएँ',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => '',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'आज के दिन का संदेश',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'अपर्याप्त अधिकार',
        'Back to the previous page' => 'पिछले पृष्ठ पर वापस जाएँ',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'द्वारा संचालित',

        # Template: Pagination
        'Show first page' => 'पहला पृष्ठ दिखाएँ ',
        'Show previous pages' => 'पिछले पृष्ठ दिखाएँ',
        'Show page %s' => '%s पृष्ठ दिखाएँ',
        'Show next pages' => 'अगले पृष्ठ दिखाएँ',
        'Show last page' => 'अंतिम पृष्ठ दिखाएँ ',

        # Template: PictureUpload
        'Need FormID!' => 'प्रपत्र ID की आवश्यकता है',
        'No file found!' => 'कोई फाइल नहीं मिली',
        'The file is not an image that can be shown inline!' => 'फ़ाइल एक छवि नहीं है जो इनलाइन दिखाया जा सकता है।',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => '',
        'Dialog' => '',

        # Template: Article
        'Inform Agent' => 'प्रतिनिधि को सूचित करें ',

        # Template: PublicDefault
        'Welcome' => '',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'अनुमतियाँ',
        'You can select one or more groups to define access for different agents.' =>
            'आप एक या अधिक समूहों का चयन करके विभिन्न प्रतिनिधियॊ के लिए उपयोग निर्धारित कर सकते हैं।',
        'Result formats' => '',
        'Time Zone' => 'समय क्षेत्र',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => '',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'यदि अवैध अंत उपयोगकर्ताओं के लिए निर्धारित तॊ आँकड़े उत्पन्न नहीं कर सकते।',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '',
        'You may now configure the X-axis of your statistic.' => '',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '',
        'Configure X-Axis' => '',
        'X-axis' => 'X-अक्ष',
        'Configure Y-Axis' => '',
        'Y-axis' => '',
        'Configure Filter' => '',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'कृपया केवल एक ही तत्व का चयन करें या "निश्चित" बटन बंद करें।',
        'Absolute period' => '',
        'Between %s and %s' => '',
        'Relative period' => '',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Format' => 'प्रारूप',
        'Exchange Axis' => 'विनिमय अक्ष',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'कोई भी तत्व चयनित नहीं',
        'Scale' => 'मापक',
        'show more' => '',
        'show less' => '',

        # Template: D3
        'Download SVG' => '',
        'Download PNG' => '',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '',

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
        'OTRS Test Page' => 'OTRS परीक्षण पृष्ठ',
        'Unlock' => 'अनलॉक',
        'Welcome %s %s' => '',
        'Counter' => 'पटल',

        # Template: Warning
        'Go back to the previous page' => 'पिछले पृष्ठ पर वापस जाएँ',

        # JS Template: CalendarSettingsDialog
        'Show' => '',

        # JS Template: FormDraftAddDialog
        'Draft title' => '',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => '',

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
        'Finished' => 'समाप्त',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'नई प्रविष्टि जोड़ें',

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
        'CustomerIDs' => 'ग्राहक IDs',
        'Fax' => 'फैक्स',
        'Street' => 'मार्ग',
        'Zip' => 'ज़िप',
        'City' => 'शहर',
        'Country' => 'देश',
        'Valid' => 'वैध',
        'Mr.' => 'श्रीमान',
        'Mrs.' => 'श्रीमती',
        'Address' => '',
        'View system log messages.' => 'प्रणाली अभिलेख संदेशों को देखें।',
        'Edit the system configuration settings.' => 'प्रणाली विन्यास व्यवस्थाऐं संपादित करें।',
        'Update and extend your system with software packages.' => 'सॉफ्टवेयर संकुल के साथ आपकी प्रणाली अद्यतन और विस्तार करें।',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => '',
        'The following ACLs have been updated successfully: %s' => '',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '',
        'This field is required' => '',
        'There was an error creating the ACL' => '',
        'Need ACLID!' => '',
        'Could not get data for ACLID %s' => '',
        'There was an error updating the ACL' => '',
        'There was an error setting the entity sync status.' => '',
        'There was an error synchronizing the ACLs.' => '',
        'ACL %s could not be deleted' => '',
        'There was an error getting data for ACL with ID %s' => '',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => '',
        'Negated exact match' => '',
        'Regular expression' => '',
        'Regular expression (ignore case)' => '',
        'Negated regular expression' => '',
        'Negated regular expression (ignore case)' => '',

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
        'Notification added!' => '',
        'There was an error getting data for Notification with ID:%s!' =>
            '',
        'Unknown Notification %s!' => '',
        '%s (copy)' => '',
        'There was an error creating the Notification' => '',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            '',
        'The following Notifications have been updated successfully: %s' =>
            '',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Notification updated!' => '',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'संलग्नक जोड़ा गया।',

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
        'Failed' => '',
        'Invalid Filter: %s!' => '',
        'Less than a second' => '',
        'sorted descending' => '',
        'sorted ascending' => '',
        'Trace' => '',
        'Debug' => '',
        'Info' => 'जानकारी',
        'Warn' => '',
        'days' => 'दिनों',
        'day' => 'दिन',
        'hour' => 'घंटा',
        'minute' => 'मिनट',
        'seconds' => 'सेकंड',
        'second' => 'सेकंड',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => '',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => '',
        'Customer company added!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'ग्राहक अद्यतन। ',
        'New phone ticket' => 'नया फोन टिकट',
        'New email ticket' => 'नया ईमेल टिकट',
        'Customer %s added' => 'ग्राहक %s जोड़ा गया। ',
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
        'Fields configuration is not valid' => '',
        'Objects configuration is not valid' => '',
        'Database (%s)' => '',
        'Web service (%s)' => '',
        'Contact with data (%s)' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '',
        'Need %s' => '',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => '',
        'Could not create the new field' => '',
        'Need ID' => '',
        'Could not get data for dynamic field %s' => '',
        'Change %s field' => '',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => '',
        'Unchecked' => '',
        'Checked' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '',
        'Prevent entry of dates in the past' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'मिनटों',
        'hour(s)' => 'घंटे',
        'Time unit' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'more than ... ago' => '',
        'Unarchived tickets' => '',
        'archive tickets' => '',
        'restore tickets from archive' => '',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => 'बढ़ते हुए',
        'descending' => 'घटते हुए',

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
        '10 minutes' => '10 मिनट',
        '15 minutes' => '15 मिनट',
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
        'Could not determine config for invoker %s' => '',
        'InvokerType %s is not registered' => '',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => '',
        'This sub-action is not valid' => '',
        'xor' => '',
        'String' => '',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
        'Keep (leave unchanged)' => '',
        'Ignore (drop key/value pair)' => '',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '',
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
        'Could not determine config for operation %s' => '',
        'OperationType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '',
        'There was an error updating the web service.' => '',
        'There was an error creating the web service.' => '',
        'Web service "%s" created!' => '',
        'Need Name!' => '',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => '',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '',
        'Web service "%s" deleted!' => '',
        'OTRS as provider' => '',
        'Operations' => '',
        'OTRS as requester' => '',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'समूह अद्यतन।',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => '',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'ईमेल से भेजने के लिए :क्षेत्र',
        'Dispatching by selected Queue.' => 'चयनित श्रेणी से भेजने के लिए।',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => '',
        'Agent who is responsible for the ticket' => '',
        'All agents watching the ticket' => '',
        'All agents with write permission for the ticket' => '',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => '',
        'There was a problem during the upgrade to %s.' => '',
        '%s was correctly reinstalled.' => '',
        'There was a problem reinstalling %s.' => '',
        'Your %s was successfully updated.' => '',
        'There was a problem during the upgrade of %s.' => '',
        '%s was correctly uninstalled.' => '',
        'There was a problem uninstalling %s.' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => '',
        'Key %s deleted!' => '',
        'Need param Key to download!' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '',
        'No such package!' => '',
        'No such file %s in package!' => '',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => '',
        'File is OK' => '',
        'Package has locally modified files.' => '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
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
            '',
        'Can\'t connect to OTRS Feature Add-on list server!' => '',
        'Can\'t get OTRS Feature Add-on list from server!' => '',
        'Can\'t get OTRS Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => '',
        'Yes (mandatory)' => '',
        'Unknown Process %s!' => '',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => '',
        'There was an error creating the Process' => '',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '',
        'Could not get data for ProcessID %s' => '',
        'There was an error updating the Process' => '',
        'Process: %s could not be deleted' => '',
        'There was an error synchronizing the processes.' => '',
        'The %s:%s is still in use' => '',
        'The %s:%s has a different EntityID' => '',
        'Could not delete %s:%s' => '',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => '',
        'Need %s!' => '',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => '',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => '',
        'ActivityDialog not found!' => '',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => '',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => '',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => '',
        'Customer Interface' => '',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => '',
        'Show Field As Mandatory' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '',
        'There was an error creating the Transition' => '',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '',
        'Could not get data for TransitionID %s' => '',
        'There was an error updating the Transition' => '',
        'Edit Transition "%s"' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '',
        'There was an error creating the TransitionAction' => '',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '',
        'Could not get data for TransitionActionID %s' => '',
        'There was an error updating the TransitionAction' => '',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'श्रेणी अद्यतन।',
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',
        '-none-' => '-कोई नहीं-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '',
        'Test' => '',
        'Training' => '',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'भूमिका अद्यतन।',
        'Role added!' => 'भूमिका जोडी गयी।',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'समूह संबंधों को भूमिका  के लिए बदलॆ',
        'Change Role Relations for Group' => 'समूह के लिए भूमिका संबंधों को बदलॆ',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'प्रतिनिधि के लिए भूमिका संबंधों को बदलॆ',
        'Change Agent Relations for Role' => 'प्रतिनिधि संबंधों को भूमिका  के लिए बदलॆ',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'कृपया पहले %s को सक्रिय करें ।',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => '',
        'Relation added!' => '',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => '',
        'Relation deleted!' => '',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => '',
        'Signature added!' => '',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'अवस्था जोडी गयी।',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => '',
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
        'Start date shouldn\'t be defined after Stop date!' => '',
        'There was an error creating the System Maintenance' => '',
        'Need SystemMaintenanceID!' => '',
        'Could not get data for SystemMaintenanceID %s' => '',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => '',
        'All sessions have been killed, except for your own.' => '',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '',
        'Template added!' => '',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '',
        'Change Template Relations for Attachment' => '',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',
        'Type added!' => 'प्रकार जोड़ा गया।',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'प्रतिनिधि अद्यतन।',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'प्रतिनिधि के लिए समूह संबंधों को बदलॆ',
        'Change Agent Relations for Group' => 'समूह के लिए प्रतिनिधि संबंधों को बदलॆ',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'महीना',
        'Week' => '',
        'Day' => 'दिन',

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
        'Customer History' => '',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => '',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => '',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => '',
        'Can not delete link with %s!' => '',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => '',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '',
        'Invalid Subaction.' => '',
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Add New Statistic' => '',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => '',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Please change the owner first.' => '',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => '',
        'Could not delete draft!' => '',
        'Previous Owner' => 'पिछला स्वामी',
        'wrote' => 'लिखा',
        'Message from' => '',
        'End message' => '',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
        'Can\'t bounce email!' => '',
        'Can\'t send email!' => '',
        'Wrong Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '',
        'Ticket (%s) is not unlocked!' => '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => '',
        'Customer user automatically added in Cc.' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'टिकट "%s" बना।',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => '',
        'Ticket Escalation View' => 'टिकट संवर्धित दृश्य',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'नया अनुच्छेद',
        'Pending' => 'विचाराधीन',
        'Reminder Reached' => 'अनुस्मारक आ गया',
        'My Locked Tickets' => 'मेरे लॉकड टिकट',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '',
        'No permission.' => '',
        '%s has left the chat.' => '',
        'This chat has been closed and will be removed in %s hours.' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => '',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => '',
        'The selected process is invalid!' => '',
        'Process %s is invalid!' => '',
        'Subaction is invalid!' => '',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '',
        'Process::Default%s Config Value missing!' => '',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '',
        'Can\'t get Ticket "%s"!' => '',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '',
        'Pending Date' => 'विचाराधीन दिनांक',
        'for pending* states' => 'विचाराधीन* स्थिति के लिए',
        'ActivityDialogEntityID missing!' => '',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => '',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => '',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => '',
        'Default Config for Process::Default%s invalid!' => '',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => '',
        'including subqueues' => '',
        'excluding subqueues' => '',
        'QueueView' => 'श्रेणी दृश्य',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'मेरे उत्तरदायी टिकट',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'पिछली खोज',
        'Untitled' => '',
        'Ticket Number' => 'टिकट संख्या',
        'Ticket' => 'टिकट',
        'printed by' => 'के द्वारा मुद्रित',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => '',
        'Normal' => 'सामान्य',
        'CSV' => '',
        'Excel' => '',
        'in more than ...' => '',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => '',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'स्तर दृश्य',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'मेरे ध्यानाधीन टिकट',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '',
        'Ticket Locked' => '',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => '',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => '',
        'Type Updated' => '',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => '',
        'Internal Chat' => '',
        'Automatic Follow-Up Sent' => '',
        'Note Added' => '',
        'Note Added (Customer)' => '',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => '',
        'Outgoing Answer' => '',
        'Service Updated' => '',
        'Link Added' => '',
        'Incoming Customer Email' => '',
        'Incoming Web Request' => '',
        'Priority Updated' => '',
        'Ticket Unlocked' => '',
        'Outgoing Email' => '',
        'Title Updated' => '',
        'Ticket Merged' => '',
        'Outgoing Phone Call' => '',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => '',
        'System Request.' => '',
        'Incoming Follow-Up' => '',
        'Automatic Reply Sent' => '',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => '',
        'External Chat' => '',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Forward article via mail' => '',
        'Forward' => 'आगे',
        'Fields with no group' => '',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',
        'Show one article' => 'एक अनुच्छेद दिखाएँ',
        'Show all articles' => 'सभी अनुच्छेद दिखाएँ',
        'Show Ticket Timeline View' => '',
        'Show Ticket Timeline View (%s)' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '',
        'No such attachment (%s)!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '',
        'My Tickets' => 'मेरे टिकट',
        'Company Tickets' => 'कंपनी के टिकट',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '',
        'Create a new ticket!' => '',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => '',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => '',
        'Install OTRS' => '',
        'Intro' => '',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => '',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => '',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => '',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'आंकड़ाकोष बनाएँ',
        'Install OTRS - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'System Settings' => 'प्रणाली व्यवस्थाऐं',
        'Syslog' => '',
        'Configure Mail' => '',
        'Mail Configuration' => 'डाक विन्यास',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => '',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '',
        'No such user!' => '',
        'Invalid calendar!' => '',
        'Invalid URL!' => '',
        'There was an error exporting the calendar!' => '',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => '',
        'Bounce' => 'फलांग',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'सबको उत्तर दें',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'सादा स्वरूप',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => '',
        'Unmark' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => '',
        'Re-install Package' => '',
        'Upgrade' => 'उन्नयन',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'क्रिप्टटेड',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'हस्ताक्षरित',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '',
        'Ticket decrypted before' => '',
        'Impossible to decrypt: private key for email was not found!' => '',
        'Successful decryption' => '',

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
        'Sign' => 'संकेत',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'दिखाए',
        'Refresh (minutes)' => '',
        'off' => 'बंद',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => '',
        'Can\'t get OTRS News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'दिखाए गए टिकट',
        'Shown Columns' => '',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '7 दिन के आँकड़े',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'मानक',
        'The following tickets are not updated: %s.' => '',
        'h' => 'एच',
        'm' => 'म',
        'd' => 'डी',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'यह एक',
        'email' => 'ईमेल',
        'click here' => 'यहाँ दबाऐ',
        'to open it in a new window.' => 'नई विंडो में खोलने के लिए',
        'Year' => 'वर्ष',
        'Hours' => 'घंटे',
        'Minutes' => 'मिनटों',
        'Check to activate this date' => '',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'अनुमति नहीं है।',
        'No Permission' => '',
        'Show Tree Selection' => '',
        'Split Quote' => '',
        'Remove Quote' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '',
        'Search Result' => '',
        'Linked' => 'लिंक किए गए',
        'Bulk' => 'थोक',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'लाइट',
        'Unread article(s) available' => 'उपलब्ध अपठित अनुच्छेद',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'ऑनलाइन प्रतिनिधि: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'यहाँ और भी संवर्धित टिकटें हैं।',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'ऑनलाइन ग्राहक: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => '',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            '',

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
            '',
        'Preferences updated successfully!' => 'वरीयताएं सफलतापूर्वक अद्यतन।',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'वर्तमान कूटशब्द',
        'New password' => 'नया कूटशब्द',
        'Verify password' => 'कूटशब्द सत्यापित करें',
        'The current password is not correct. Please try again!' => 'वर्तमान कूटशब्द सही नहीं है। कृपया पुनः प्रयास करें।',
        'Please supply your new password!' => '',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'कूटशब्द अद्यतन नहीं किया जा सकता,आपका नया कूटशब्द मेल नहीं खाता है,कृपया पुनः प्रयास करें।',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'कूटशब्द अद्यतन नहीं किया जा सकता,यह कम से कम %s वर्ण लंबा होना चाहिए।',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'कूटशब्द अद्यतन नहीं किया जा सकता,इसमें कम से कम 1 अंक होना चाहिए।',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'अवैध',
        'valid' => 'वैध',
        'No (not supported)' => '',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => '',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'second(s)' => 'सेकंड',
        'quarter(s)' => '',
        'half-year(s)' => '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'अंतर्वस्तु',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => '',
        'Lock it to work on it' => '',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'अनदॆखॆ',
        'Remove from list of watched tickets' => 'ध्यानाधीन टिकटों की सूची से हटाएं।',
        'Watch' => 'देखो',
        'Add to list of watched tickets' => 'ध्यानाधीन टिकटों की सूची में जोड़ें।',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'के आदेश से',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => '',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'नए लॉकड टिकट',
        'Locked Tickets Reminder Reached' => 'लॉकड टिकट अनुस्मारक आ गया',
        'Locked Tickets Total' => 'कुल लॉकड टिकट',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'नए उत्तरदायी टिकट',
        'Responsible Tickets Reminder Reached' => 'उत्तरदायी टिकट अनुस्मारक आ गया',
        'Responsible Tickets Total' => 'कुल उत्तरदायी टिकट',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'नए ध्यानाधीन टिकट',
        'Watched Tickets Reminder Reached' => 'ध्यानाधीन टिकट अनुस्मारक आ गया',
        'Watched Tickets Total' => 'कुल ध्यानाधीन टिकट',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => '',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session limit reached! Please try again later.' => '',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'सत्र का समय समाप्त हो गया है। कृपया फिर से प्रवेश करें।',

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
        'Configuration Options Reference' => '',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => '',
        'This setting can not be deactivated.' => '',
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
        'before/after' => '',
        'between' => 'बीच में',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => '',
        'The field content is too long!' => '',
        'Maximum size is %s characters.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'installed' => 'स्थापित',
        'Unable to parse repository index document.' => 'संग्रह सूचकांक दस्तावेज़ की व्याख्या करने में असमर्थ।',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'आपकी रूपरेखा संस्करण के लिए कोई संकुल इस संग्रह में नहीं मिला,इसके केवल दूसरे रूपरेखा संस्करणों के लिए संकुल शामिल हैं।',
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
        'Inactive' => '',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => '',
        'Problems processing server result. Please try again later.' => '',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'योग',
        'week' => 'हफ़्ता',
        'quarter' => '',
        'half-year' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'प्राथमिकता बनाई गई',
        'Created State' => 'अवस्था बनाया गया',
        'Create Time' => 'समय बनाएँ',
        'Pending until time' => '',
        'Close Time' => 'बंद होने का समय',
        'Escalation' => 'संवर्धित',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'प्रतिनिधि/स्वामी',
        'Created by Agent/Owner' => 'प्रतिनिधि/स्वामी के द्वारा बनाया गया',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'मूल्यांकन से',
        'Ticket/Article Accounted Time' => 'टिकट/अनुच्छेद लेखा समय',
        'Ticket Create Time' => 'टिकट बनाने का समय',
        'Ticket Close Time' => 'टिकट बंद होने का समय',
        'Accounted time by Agent' => 'प्रतिनिधि द्वारा लेखा  समय',
        'Total Time' => 'कुल समय',
        'Ticket Average' => 'टिकट औसत',
        'Ticket Min Time' => 'टिकट-न्यूनतम समय',
        'Ticket Max Time' => 'टिकट-अधिकतम समय',
        'Number of Tickets' => 'टिकटों की संख्या',
        'Article Average' => 'अनुच्छेद-औसत',
        'Article Min Time' => 'अनुच्छेद-न्यूनतम समय',
        'Article Max Time' => 'अनुच्छेद-अधिकतम समय',
        'Number of Articles' => 'अनुच्छेद की संख्या',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'विशेषताएँ मुद्रित करने के लिए',
        'Sort sequence' => 'क्रमबद्ध श्रृंखला',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => 'संख्या',
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
        'Days' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

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
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => '',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '',
        'Could not determine distribution.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => '',
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
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '',
        'Tickets' => 'टिकटें',
        'Ticket History Entries' => '',
        'Articles' => '',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',
        'Open Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => '',
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
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => '',
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
        'Webserver' => '',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
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
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '',
        'Problem' => '',

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
        'Default' => '',
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
        'Reset of unlock time.' => '',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            'प्रवेश असफल। आपका उपयोगकर्ता नाम या कूटशब्द गलत प्रविष्ट किया गया था।',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => '',
        'Feature not active!' => 'सुविधा सक्रिय नहीं है।',
        'Sent password reset instructions. Please check your email.' => 'कूटशब्द पुनर्स्थापित निर्देशों को भेज दियॆ। कृपया अपना ईमेल देखें।',
        'Invalid Token!' => 'अवैध टोकन',
        'Sent new password to %s. Please check your email.' => 'नये कूटशब्द की जानकारी %s को भेजी। कृपया अपना ईमेल देखें।',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '',
        'This email address is not allowed to register. Please contact support staff.' =>
            '',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'नया खाता बन गया। प्रवेश करने की जानकारी %s को भेजी। कृपया अपना ईमेल देखें।',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'अवैध-अस्थायी रूप',
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'new' => 'नया',
        'All new state types (default: viewable).' => '',
        'open' => 'खुला',
        'All open state types (default: viewable).' => '',
        'closed' => 'बंद',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'विचाराधीन चेतावनी',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'विचाराधीन स्वत',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'हटा दिया',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'मिलाएं गए',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'closed successful' => 'सफलतापूर्वक समाप्त',
        'Ticket is closed successful.' => '',
        'closed unsuccessful' => 'असफलतापूर्वक समाप्त',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'विचाराधीन स्वत बंद+',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'विचाराधीन स्वत बंद-',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'संभव है',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'अस्वीकार',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => '',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => '',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => '',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => '',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => '',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        '1 very low' => '1 बहुत निम्न',
        '2 low' => '2 निम्न',
        '3 normal' => '3 सामान्य',
        '4 high' => '4 उच्च',
        '5 very high' => '5 बहुत उच्च',
        'unlock' => 'अनलॉक',
        'lock' => 'लॉक',
        'tmp_lock' => '',
        'agent' => 'प्रतिनिधि',
        'system' => 'प्रणाली',
        'customer' => 'ग्राहक',
        'Ticket create notification' => '',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'टिकट लॉक समय समाप्ति अधिसूचना',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => '',
        'Ticket responsible update notification' => '',
        'Ticket new note notification' => '',
        'Ticket queue update notification' => '',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => '',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => '',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => '',
        'An item with this name is already present.' => '',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '',

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
            '',
        'Delete field' => '',
        'Deleting the field and its data. This may take a while...' => '',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => '',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => '',
        'Request Details' => '',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => '',
        'Clear debug log' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => '',
        'Delete operation' => '',
        'Delete invoker' => '',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'चेतावनी: जब आप \'व्यवस्थापक\'समूह का नाम बदले, प्रणाली विन्यास में उपयुक्त बदलाव करने से पहले, आपको प्रशासन के बाहर अवरोधित कर दिया जाएगा। यदि ऐसा होता है, तो कृपया प्रत्येक SQL वचन के लिए व्यवस्थापक के समूह का नाम बदले।',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '',
        'Do you really want to delete this notification?' => '',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '',
        'Dismiss' => '',
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
        'Remove Entity from canvas' => '',
        'No TransitionActions assigned.' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'Remove the Transition from this Process' => '',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',
        'Delete Entity' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Hide EntityIDs' => '',
        'Edit Field Details' => '',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',

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
        'Loading...' => 'लोड हो रहा है।',
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
            '',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'पिछला',
        'Resources' => '',
        'Su' => 'रविवार',
        'Mo' => 'सोमवार',
        'Tu' => 'मंगलवार',
        'We' => 'बुधवार',
        'Th' => 'गुरूवार',
        'Fr' => 'शुक्रवार',
        'Sa' => 'शनिवार',
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
        'Duplicated entry' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => '',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '',
        'month' => 'महीना',
        'Remove active filters for this widget.' => '',

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
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => '',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => '',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'अनुच्छेद निस्पादक',
        'Apply' => 'लागू करें',
        'Event Type Filter' => '',

        # JS File: Core.Agent
        'Slide the navigation bar' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'Find out more' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => '',

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
        'One or more errors occurred!' => 'एक या अधिक त्रुटि आई है',

        # JS File: Core.Installer
        'Mail check successful.' => 'मेल की जाँच सफल रही।',
        'Error in the mail settings. Please correct and try again.' => 'मेल व्यवस्थाऐं करने में त्रुटि हैं। सही करें तथा पुनः प्रयास करें।',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'दिनांक चयन को खोलें',
        'Invalid date (need a future date)!' => 'अवैध दिनांक(आगामी दिनांक की जरूरत है)',
        'Invalid date (need a past date)!' => '',

        # JS File: Core.UI.InputFields
        'Not available' => '',
        'and %s more...' => '',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => '',
        'Filters' => '',
        'Clear search' => '',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'यदि अब आप इस पृष्ठ को छॊडॆंगॆ,सभी खुले पॉपअप विंडोज़ भी बंद हो जायेंगे।',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'इस स्क्रीन का एक पॉपअप पहले से ही खुला है। क्या आप उसे बंद करके उसकी बजाय इसे लोड करना चाहते हैं?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'पॉपअप विंडो नहीं खोला जा सकता। कृपया इस अनुप्रयोग के लिए पॉपअप ब्लॉकर्स निष्क्रिय करें।',

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
        'There are currently no elements available to select from.' => '',

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
        'yes' => 'हाँ',
        'no' => 'नहीं',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => '',

        # JS File: OTRSMultiBarChart
        'Grouped' => '',
        'Stacked' => '',

        # JS File: OTRSStackedAreaChart
        'Stream' => '',
        'Expanded' => '',

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
        ' 2 minutes' => ' 2 मिनट',
        ' 5 minutes' => ' 5 मिनट',
        ' 7 minutes' => ' 7 मिनट',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => 'विविध %s।',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname Firstname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        '*** out of office until %s (%s d left) ***' => '',
        '0 - Disabled' => '',
        '1 - Available' => '',
        '1 - Enabled' => '',
        '10 Minutes' => '',
        '100 (Expert)' => '',
        '15 Minutes' => '',
        '2 - Enabled and required' => '',
        '2 - Enabled and shown by default' => '',
        '2 - Enabled by default' => '',
        '2 Minutes' => '',
        '200 (Advanced)' => '',
        '30 Minutes' => '',
        '300 (Beginner)' => '',
        '5 Minutes' => '',
        'A TicketWatcher Module.' => '',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL मॉड्यूल जनक टिकटों तभी बंद करने की अनुमति देता है जब उसके सभी चिल्ड्रन पहले से ही बंद हो।(" स्थिति" से पता चलता है की कोंनसी स्थिति जनक टिकटों के लिए उपलब्ध नहीं हैं जब तक कि सभी चिल्ड्रन टिकटें बंद न हो)।',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'श्रेणी के एक निमिष व्यवस्था सक्रिय करता है जिसमें सबसे पुराना टिकट शामिल होता है।',
        'Activates lost password feature for agents, in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में कूटशब्द खो दिया सुविधा को सक्रिय करता है।',
        'Activates lost password feature for customers.' => 'कूटशब्द खो दिया सुविधा को ग्राहकों के लिए सक्रिय करता है।',
        'Activates support for customer and customer user groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'ज़ूम दृश्य में जो अनुच्छेद दिखाया जाना चाहिये अनुच्छेद निस्पादक को सक्रिय करता है।',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'प्रणाली पर उपलब्ध थीम को सक्रिय करता है।मान 1 का मतलब सक्रिय है,0 का मतलब है निष्क्रिय।',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'प्रणाली तेज बनाने के लिए टिकटों को दैनिक दायरे से बाहर ले जाने वाले टिकट संग्रह प्रणाली को सक्रिय करता है। इन टिकटों को खोजने के लिए,संग्रह चिह्नक को टिकट खोज में सक्रिय किया जाना चाहिए।',
        'Activates time accounting.' => 'समय लेखाकरण सक्रिय करता है।',
        'ActivityID' => '',
        'Add a note to this ticket' => '',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'ग्राहक ईमेल %s।',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'टिकट के लिए लिंक जोड़ा गया "%s"।',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'सदस्यता लें "%s"।',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'वास्तविक वर्ष और महीने के साथ OTRS अभिलेख फ़ाइल को एक प्रत्यय जोड़ता है।हर महीने के लिए एक अभिलेख फ़ाइल बनाया जाएगा।',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'व्यवस्थापक',
        'Admin Area.' => '',
        'Admin Notification' => 'व्यवस्थापक अधिसूचना',
        'Admin area navigation for the agent interface.' => '',
        'Admin modules overview.' => '',
        'Admin.' => '',
        'Administration' => '',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent Statistics.' => '',
        'Agent User Search' => '',
        'Agent User Search.' => '',
        'Agent interface article notification module to check PGP.' => 'PGP की जाँच करने के लिए प्रतिनिधि अंतरफलक अनुच्छेद अधिसूचना मॉड्यूल।',
        'Agent interface article notification module to check S/MIME.' =>
            'S/MIME की जाँच करने के लिए प्रतिनिधि अंतरफलक अनुच्छेद अधिसूचना मॉड्यूल।',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'प्रतिनिधि अंतरफलक मॉड्यूल टिकट-ज़ूम-दृश्य में आने वाली ईमेल की जाँच करने के लिए अगर एस / MIME-कुंजी उपलब्ध है और सही है।',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
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
        'All customer users of a CustomerID' => '',
        'All escalated tickets' => 'सभी संवर्धित टिकट',
        'All new tickets, these tickets have not been worked on yet' => 'सभी नये टिकट,इन टिकटों पर अभी तक काम नहीं किया गया है।',
        'All open tickets, these tickets have already been worked on.' =>
            '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'सभी टिकट एक अनुस्मारक सेट के साथ जहाँ दिनांक अनुस्मारक पहुँच गया है।',
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
            'आँकड़ॊ की धुरी विनिमय करने के लिए प्रतिनिधि को अनुमति देता है यदि वे एक उत्पन्न करते है।',
        'Allows agents to generate individual-related stats.' => 'अलग अलग संबंधित आँकड़े उत्पन्न करने के लिए प्रतिनिधि को अनुमति देता है।',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'ब्राउज़र (इनलाइन) में एक टिकट के संलग्नक दिखाने या सिर्फ उन्हें डाउनलोड करने योग्य (संलग्नक) के बीच में चुनने की अनुमति देता है।',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में ग्राहक टिकटों के लिए अगली रचना स्थिति को चुनने की अनुमति देता है।',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट प्राथमिकता बदलने के लिए अनुमति देता है।',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट SLA स्थापित करने के लिए अनुमति देता है।',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट प्राथमिकता बदलने के लिए अनुमति देता है।',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            'ग्राहकों को ग्राहक अंतरफलक में टिकट सेवा स्थापित करने के लिए अनुमति देता है।',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'टिकटों के लिए सेवाओं और SLAs(उदा. ईमेल,डेस्कटॉप,नेटवर्क,...) और SLAs के लिए संवर्धित विशेषताओं(यदि टिकट सेवा/SLA सुविधा सक्षम है) को परिभाषित करने के लिए की अनुमति देता है।',
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
            'एक मध्यम प्रारूप टिकट अवलोकन होने की अनुमति देता है(ग्राहक जानकारी =>1 - यह भी ग्राहकों की जानकारी दिखाता है)।',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'एक छोटे प्रारूप टिकट अवलोकन होने की अनुमति देता है(ग्राहक जानकारी =>1 - यह भी ग्राहकों की जानकारी दिखाता है)।',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'प्रशासक को प्रशासन पैनल के माध्यम से अन्य उपयोगकर्ताओं को प्रशासक के रूप में प्रवेश की अनुमति देता है।',
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
            'प्रतिनिधि अंतरफलक के स्थानांतरित टिकट स्क्रीन में एक नया टिकट स्थिति स्थापित करने के लिए अनुमति देता है।',
        'Always show RichText if available' => '',
        'Answer' => '',
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
        'Arabic (Saudi Arabia)' => '',
        'ArticleTree' => '',
        'Attachment Name' => '',
        'Automated line break in text messages after x number of chars.' =>
            'पाठ संदेशों में स्वचालित पंक्ति विराम अक्षरों की x संख्या के बाद।',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'थोक कार्रवाई चुनने के बाद स्वचालित रूप से वर्तमान प्रतिनिधि के लिए लॉक और स्वामी निर्धारित करें।',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'पहला स्वामी अद्यतन करने के बाद स्वचालित रूप से एक टिकट का उत्तरदायी(अगर यह अभी तक निर्धारित नहीं है)निर्धारित करें।',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'संतुलित सफेद सतही फेलिक्स निकलस के द्वारा',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'सभी आने वाली ईमेल से:@ example.com पते के जिनके विषय में एक वैध टिकट नंबर नहीं है उनको रोकें।',
        'Bounced to "%s".' => 'फलांग "%s"।',
        'Bulgarian' => '',
        'Bulk Action' => 'थोक क्रिया',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD उदाहरण स्थापना,ईमेल पर ध्यान न दें जब बाहरी CMD STDOUT को कुछ उत्पादन देता है(ईमेल some.bin का stdin में पहुंचाया जाएगा)।',
        'CSV Separator' => 'CSV विभाजक',
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
        'Calendar manage screen.' => '',
        'Catalan' => '',
        'Change password' => 'कूटशब्द बदलें',
        'Change queue!' => 'श्रेणी बदलें',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the owner for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible for this ticket' => '',
        'Change your avatar image.' => '',
        'Change your password and more.' => '',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'अद्यतन प्राथमिकता "%s" (%s)  "%s" (%s)।',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'टिकट का स्वामी सभी को करने के लिए बदलें(ASP के लिए उपयोगी)। आम तौर पर टिकट की श्रेणी में ही पढ़ने और लिखने की अनुमति के साथ प्रतिनिधि दिखाया जाएगा।',
        'Chat communication channel.' => '',
        'Checkbox' => '',
        'Checks for articles that needs to be updated in the article search index.' =>
            '',
        'Checks for communication log entries to be deleted.' => '',
        'Checks for queued outgoing emails to be sent.' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Child' => 'संतान',
        'Chinese (Simplified)' => '',
        'Chinese (Traditional)' => '',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => '',
        'Close' => 'अंत',
        'Close this ticket' => '',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Cloud Services' => '',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
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
        'Comment for new history entries in the customer interface.' => 'ग्राहक अंतरफलक में इतिहास नई प्रविष्टियों के लिए टिप्पणी।',
        'Comment2' => '',
        'Communication' => '',
        'Communication & Notifications' => '',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => '',
        'Company Tickets.' => '',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Compose' => 'लिखें',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '',
        'Configure your own log text for PGP.' => 'आपके PGP के लिए अपनी अभिलेख पाठ विन्यस्त करें।',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'नियंत्रित करता है यदि ग्राहकों को उनके टिकट सॉर्ट करने की क्षमता है।',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'HTML मेल को पाठ संदेशों में बदलता है। ',
        'Create New process ticket.' => '',
        'Create Ticket' => '',
        'Create a new calendar appointment linked to this ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'सेवा स्तर के समझौतों को बनाएँ और प्रबंधन करें।',
        'Create and manage agents.' => 'प्रतिनिधियॊ को बनाएँ और प्रबंधन करें।',
        'Create and manage appointment notifications.' => '',
        'Create and manage attachments.' => 'संलग्नक को बनाएँ और प्रबंधन करें।',
        'Create and manage calendars.' => '',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'ग्राहकों को बनाएँ और प्रबंधन करें।',
        'Create and manage dynamic fields.' => '',
        'Create and manage groups.' => 'समूहों को बनाएँ और प्रबंधन करें।',
        'Create and manage queues.' => 'श्रेणीयों को बनाएँ और प्रबंधन करें।',
        'Create and manage responses that are automatically sent.' => 'प्रतिक्रियाएं जो स्वचालित रूप से भेजी जाती है को बनाएँ और प्रबंधन करें।',
        'Create and manage roles.' => 'भूमिकाएं को बनाएँ और प्रबंधन करें।',
        'Create and manage salutations.' => 'अभिवादनों को बनाएँ और प्रबंधन करें।',
        'Create and manage services.' => 'सेवाओं को बनाएँ और प्रबंधन करें।',
        'Create and manage signatures.' => 'हस्ताक्षरों को बनाएँ और प्रबंधन करें।',
        'Create and manage templates.' => '',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => 'टिकट प्राथमिकताओं को बनाएँ और प्रबंधन करें।',
        'Create and manage ticket states.' => 'टिकट स्थितियों को बनाएँ और प्रबंधन करें।',
        'Create and manage ticket types.' => 'टिकट के प्रकारों को बनाएँ और प्रबंधन करें।',
        'Create and manage web services.' => '',
        'Create new Ticket.' => '',
        'Create new appointment.' => '',
        'Create new email ticket and send this out (outbound).' => '',
        'Create new email ticket.' => '',
        'Create new phone ticket (inbound).' => '',
        'Create new phone ticket.' => '',
        'Create new process ticket.' => '',
        'Create tickets.' => '',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => '',
        'Custom RSS Feed' => '',
        'Custom RSS feed.' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '',
        'Customer Companies' => 'ग्राहक की कंपनियां',
        'Customer IDs' => '',
        'Customer Information Center Search.' => '',
        'Customer Information Center search.' => '',
        'Customer Information Center.' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User Administration' => '',
        'Customer User Information' => '',
        'Customer User Information Center Search.' => '',
        'Customer User Information Center search.' => '',
        'Customer User Information Center.' => '',
        'Customer Users ↔ Customers' => '',
        'Customer Users ↔ Groups' => '',
        'Customer Users ↔ Services' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => '',
        'Customer ticket overview' => '',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'CustomerUser' => '',
        'Customers ↔ Groups' => '',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'Danish' => '',
        'Dashboard overview.' => '',
        'Data used to export the search result in CSV format.' => 'CSV प्रारूप में खोज परिणाम भेजने के लिए उपयोग होनेवाला आंकड़ा।',
        'Date / Time' => '',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => 'तयशुदा ACL मान टिकट कार्रवाई के लिए।',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => 'तयशुदा पाश सुरक्षा मॉड्यूल',
        'Default queue ID used by the system in the agent interface.' => 'प्रतिनिधि अंतरफलक में सिस्टम के द्वारा प्रयुक्त तयशुदा श्रेणीID।',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में सिस्टम के द्वारा प्रयुक्त तयशुदा टिकटID।',
        'Default ticket ID used by the system in the customer interface.' =>
            'ग्राहक अंतरफलक में सिस्टम के द्वारा प्रयुक्त तयशुदा टिकटID।',
        'Default value for NameX' => '',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'HTML उत्पादन को  परिभाषित स्ट्रिंग के पीछे की लिंक जोड़ने के लिए एक निस्पादक परिभाषित करे। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
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
        'Define the start day of the week for the date picker.' => 'दिनांक पिकर के लिए सप्ताह की शुरुआत के दिन निर्धारित करें।',
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
            'एक ग्राहक वस्तु को परिभाषित करें, जो एक ग्राहक को जानकारी ब्लॉक के अंत में एक LinkedIn चिह्न उत्पन्न करता है।',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'एक ग्राहक वस्तु को परिभाषित करें,जो एक ग्राहक को जानकारी ब्लॉक के अंत में एक XING चिह्न उत्पन्न करता है।',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'एक ग्राहक वस्तु को परिभाषित करें,जो एक ग्राहक को जानकारी ब्लॉक के अंत में एक गूगल चिह्न उत्पन्न करता है।',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'एक ग्राहक वस्तु को परिभाषित करें,जो एक ग्राहक को जानकारी ब्लॉक के अंत में एक गूगल मानचित्र का चिह्न उत्पन्न करता है।',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Html उत्पादन को CVE संख्या के पीछे लिंक जोड़ने के लिए एक निस्पादक परिभाषित करें। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Html उत्पादन को MSBulletin संख्या के पीछे लिंक जोड़ने के लिए एक निस्पादक परिभाषित करें। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Html उत्पादन को परिभाषित स्ट्रिंग संख्या के पीछे लिंक जोड़ने के लिए एक निस्पादक परिभाषित करें। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Html उत्पादन को परिभाषित बगटै्क संख्या के पीछे लिंक जोड़ने के लिए एक निस्पादक परिभाषित करें। तत्व छवि दो इनपुट प्रकार की अनुमति देता है। एक बार एक छवि के नाम से(उदा.faq.png)। ऐसी स्थिति में OTRS छवि के पथ का उपयोग किया जाएगा। दूसरी संभावना छवि को कड़ी सम्मिलित करने की है।',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'अनुच्छेद में एक पाठ प्रक्रिया निस्पादक परिभाषित करें,पूर्वनिर्धारित खोजशब्दों को उजागर करने के लिए। ',
        'Defines a permission context for customer to group assignment.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'एक नियमित अभिव्यक्ति को परिभाषित करें जिसमें वाक्यविन्यास से कुछ पते शामिल नहीं है(यदि "ईमेल पतों की जाँच करें" "हाँ" पर स्थापित है)। ईमेल पते के लिए इस क्षेत्र में एक नियमित अभिव्यक्ति दर्ज करें,जो वाक्य रचना से वैध नहीं है,लेकिन सिस्टम के लिए आवश्यक हैं (अर्थात् "root@localhost")।',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'एक नियमित अभिव्यक्ति को परिभाषित करें जो सभी ईमेल पते जो आवेदन पत्र में प्रयुक्त नहीं होना चाहिए को निस्पादित करता है।',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            'एक उपयोगी मॉड्यूल को परिभाषित करें विशिष्ट उपयोगकर्ता विकल्प लोड करने के लिए या समाचार प्रदर्शन करने के लिए।',
        'Defines all the X-headers that should be scanned.' => 'सभी एक्स हेडर जो स्कैन किया जाना चाहिए को परिभाषित करता है।',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'ग्राहक अंतरफलक के ग्राहक वरीयताओं में ताज़ा टाइम वस्तु के लिए सभी पैरामीटर्स निर्धारित करता है।',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'ग्राहक अंतरफलक के ग्राहक वरीयताओं में टिकट दिखाए वस्तु के लिए सभी पैरामीटर्स निर्धारित करता है।',
        'Defines all the parameters for this item in the customer preferences.' =>
            'ग्राहक वरीयताओं में इस वस्तु के लिए सभी पैरामीटर्स निर्धारित करता है।',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => 'सभी संभव आँकड़े आउटपुट स्वरूप को परिभाषित करता है।',
        'Defines an alternate URL, where the login link refers to.' => 'एक वैकल्पिक URL को परिभाषित करें,जहां प्रवेश कड़ी संदर्भित करता है।',
        'Defines an alternate URL, where the logout link refers to.' => 'एक वैकल्पिक URL को परिभाषित करें।,जहां लॉगआउट कड़ी संदर्भित करता है।',
        'Defines an alternate login URL for the customer panel..' => 'ग्राहक पैनल के लिए एक वैकल्पिक प्रवेश URL को परिभाषित करता है।',
        'Defines an alternate logout URL for the customer panel.' => 'ग्राहक पैनल के लिए एक वैकल्पिक लॉगआउट URL को परिभाषित करता है।',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
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
            '',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'ईमेल(उत्तर और ईमेल टिकट से भेजा गया) के से क्षेत्र कैसे दिखना चाहिए,को परिभाषित करता है। ',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट बंद स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट फलांग स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट रचना स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट अग्रिम स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट मुक्त पाठ स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास जूम टिकट की विलय स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट टिप्पणी स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास जूम टिकट की स्वामी स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास जूम टिकट की विचाराधीन स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट फोन आउटबाउंड स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास जूम टिकट की प्राथमिकता स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट उत्तरदायी स्क्रीन में  एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'यदि प्रतिनिधि अंतरफलक के पास टिकट का ग्राहक बदलने के लिए एक टिकट लॉक की आवश्यकता है तो परिभाषित करता है(यदि अभी तक टिकट बंद नहीं है,टिकट बंद हो जाए है और वर्तमान प्रतिनिधि उसके मालिक के रूप में अपने आप स्थापित हो जाएगा)।',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
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
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'स्थानीय भंडार तक पहुँचने के लिए आईपी नियमित अभिव्यक्ति परिभाषित करें। आपको अपनी स्थानीय भंडार का उपयोग करने के लिए यह सक्षम करने आवश्यकता है और पैकेज:: स्रोत सूची दूरस्थ मेजबान पर आवश्यक है।',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '',
        'Defines the URL CSS path.' => 'URL CSS पथ को परिभाषित करता है।',
        'Defines the URL base path of icons, CSS and Java Script.' => 'चिह्न,CSS और जावा स्क्रिप्ट का URL आधार पथ को परिभाषित करता है।',
        'Defines the URL image path of icons for navigation.' => 'नेविगेशन के लिए URL चिह्न की छवि पथ को परिभाषित करता है।',
        'Defines the URL java script path.' => 'URL जावा स्क्रिप्ट पथ को परिभाषित करता है।',
        'Defines the URL rich text editor path.' => 'URL समृद्ध पाठ संपादक पथ को परिभाषित करता है।',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '"CheckMXRecord" देखने के लिए,यदि आवश्यक हो तो,एक समर्पित DNS सर्वर का पता को परिभाषित करता है।',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'नए खाते के बारे में,ग्राहकों को भेजा जाने वाला अधिसूचना मेल के लिए मुख्य-भाग पाठ परिभाषित करें।',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => 'अस्वीकृत ईमेल मुख्य-भाग लिए के पाठ को परिभाषित करता है।',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            'वरीयताएँ तालिका के लिए चाबी संग्रहीत स्तंभ को परिभाषित करता है।',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'वरीयता दृश्य में देखने के लिए,इस वस्तु का विन्यास पैरामीटर को परिभाषित करता है।',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'एक प्रॉक्सी के माध्यम से,Http/ftp के लिए कनेक्शन को परिभाषित करता है।',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            'तारीख निवेश रूपों में उपयोग प्रारूप को परिभाषित करता है(विकल्प या निवेश क्षेत्र)।',
        'Defines the default CSS used in rich text editors.' => 'समृद्ध पाठ संपादकों में प्रयुक्त तयशुदा CSS को परिभाषित करता है।',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अग्रांत से टिकट मुक्त पाठ स्क्रीन में एक टिप्पणी के तयशुदा मुख्य-भाग को परिभाषित करता है।',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'तयशुदा अग्रांत भाषा परिभाषित करें। सभी संभावित मान प्रणाली पर उपलब्ध भाषा फ़ाइलों से निर्धारित होते हैं(अगली व्यवस्थाओ को देखें)।',
        'Defines the default history type in the customer interface.' => 'ग्राहक अंतरफलक में तयशुदा इतिहास के प्रकार को परिभाषित करता है।',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'समय के पैमाने के लिए X-अक्ष विशेषताओं की तयशुदा अधिकतम संख्या को परिभाषित करता है।',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट की स्क्रीन पर,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की मुक्त पाठ स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की टिप्पणी स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के  जूम टिकट की स्वामी स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के  जूम टिकट की विचाराधीन स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के  जूम टिकट की प्राथमिकता स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की उत्तरदायी स्क्रीन में,एक टिप्पणी जोड़ने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की फलांग स्क्रीन में,वापस होने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की अग्रिम स्क्रीन में,अग्रेषित होने के बाद टिकट की अगली तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'एक टिकट की तयशुदा अगली स्थिति को परिभाषित करता है। यदि यह रचित है/जवाब टिकट की प्रतिनिधि अंतरफलक रचना की स्क्रीन में।',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के फोन आउटबाउंड स्क्रीन में फोन टिकटों के लिए तयशुदा टिप्पणी मुख्य-भाग पाठ को परिभाषित करता है।',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में नए ग्राहक टिकटों की तयशुदा प्राथमिकता को परिभाषित करता है।',
        'Defines the default priority of new tickets.' => 'नई टिकटों की तयशुदा प्राथमिकता को परिभाषित करता है।',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में नए ग्राहक टिकटों के लिए तयशुदा श्रेणी को परिभाषित करता है।',
        'Defines the default queue for new tickets in the agent interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'सक्रिय वस्तुओं के लिए ड्रॉप डाउन मेनू में तयशुदा चुनाव को परिभाषित करता है(प्रपत्र:सामान्य विशिष्टता)।',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'अनुमतियों के लिए ड्रॉप डाउन मेनू में तयशुदा चुनाव को परिभाषित करता है(प्रपत्र:सामान्य विशिष्टता)।',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'आँकड़े प्रारूप के लिए ड्रॉप डाउन मेनू में तयशुदा चुनाव को परिभाषित करता है(प्रपत्र:सामान्य विशिष्टता)। कृपया स्वरूप कुंजी सम्मिलित करें(आँकड़े:प्रारूप देखें)।',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की फोन आउटबाउंड स्क्रीन में फोन टिकटों के लिए तयशुदा प्रेषक प्रकार को परिभाषित करता है।',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'ग्राहक अंतरफलक के टिकट की ज़ूम स्क्रीन में फोन टिकटों के लिए तयशुदा प्रेषक प्रकार को परिभाषित करता है।',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'टिकट की खोज स्क्रीन के लिए दिखाई टिकट की तयशुदा खोज विशेषता को परिभाषित करता है।',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'प्राथमिकता के आधार पर क्रमबद्ध करने के बाद,श्रेणी दृश्य में प्रदर्शित सभी श्रेणीऔ के लिए तयशुदा क्रमबद्ध करने के क्रम को परिभाषित करता है।',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में नए ग्राहक टिकटों की तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default state of new tickets.' => 'नये टिकटों की तयशुदा स्थिति को परिभाषित करता है।',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की फोन आउटबाउंड फोन स्क्रीन में टिकटों के लिए तयशुदा विषय को परिभाषित करता है।',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट की मुक्त पाठ स्क्रीन में टिप्पणी के तयशुदा विषय को परिभाषित करता है।',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'ग्राहक अंतरफलक के टिकट की खोज में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के संवर्धित दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के लॉक दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के उत्तरदायी दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के स्तर दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के ध्यानाधीन दृश्य में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के खोज परिणाम में तयशुदा टिकट की छँटाई के लिए टिकट की विशेषता को परिभाषित करता है।',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के बाउंस स्क्रीन में ग्राहक/प्रेषक के लिए तयशुदा टिकट के अधिसूचना बाउंस को परिभाषित करता है।',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट के फोन आउटबाउंड स्क्रीन में एक फोन टिप्पणी जोड़ने के बाद तयशुदा टिकट की अगली स्थिति को परिभाषित करता है।',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की संवर्धित दृश्य में तयशुदा टिकट के क्रम(प्राथमिकता आधार पर क्रमबद्ध करें करने के बाद) को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की स्तर दृश्य में तयशुदा टिकट के क्रम(प्राथमिकता आधार पर क्रमबद्ध करें करने के बाद) को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की उत्तरदायी दृश्य में तयशुदा टिकट के क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की लॉक दृश्य में तयशुदा टिकट के क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की खोज परिणाम में तयशुदा टिकट के क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'प्रतिनिधि अंतरफलक की ध्यानाधीन दृश्य में तयशुदा टिकट के क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'ग्राहक अंतरफलक में एक खोज परिणाम के टिकट के तयशुदा क्रम को परिभाषित करता है। ऊपर:शीर्ष पर सबसे पुरानी। नीचे:शीर्ष पर नवीनतम।',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट बंद के स्क्रीन में तयशुदा टिकट के प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक के स्क्रीन में तयशुदा टिकट के प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ के स्क्रीन में तयशुदा टिकट के प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी के स्क्रीन में तयशुदा टिकट के प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट स्वामी स्क्रीन में तयशुदा टिकट की प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट विचाराधीन स्क्रीन में तयशुदा टिकट की प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट प्राथमिकता स्क्रीन में तयशुदा टिकट की प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट उत्तरदायी स्क्रीन में तयशुदा टिकट की प्राथमिकता को परिभाषित करता है।',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default ticket type.' => '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'यदि प्रतिनिधि अंतरफलक के url में कोई कार्रवाई प्रतिमान नहीं दिया जाता है तो मुखपटल-मॉड्यूल के प्रयोग को परिभाषित करता है।',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'यदि ग्राहक अंतरफलक के url में कोई कार्रवाई प्रतिमान नहीं दिया जाता है तो मुखपटल-मॉड्यूल के प्रयोग को परिभाषित करता है।',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'सार्वजनिक मुखपटल के लिए कार्रवाई प्रतिमान के तयशुदा मान को परिभाषित करता है। क्रिया प्रतिमान प्रणाली की लिपियों में प्रयोग किया जाता है।',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'एक टिकट के तयशुदा देखने योग्य प्रेषक के प्रकार को परिभाषित करता है(तयशुदा:ग्राहक)।',
        'Defines the default visibility of the article to customer for this operation.' =>
            '',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'URLs को उजागर करने के लिए,अनुच्छेद के पाठ की प्रक्रियाओं के लिए निस्पादक को परिभाषित करता है।',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'पूरी तरह से योग्य प्रणाली के डोमेन नाम को परिभाषित करता है। यह व्यवस्था किसी परिवर्तनीय के रूप में प्रयोग की जाती है, OTRS_CONFIG_FQDN जो अनुप्रयोग द्वारा उपयोग संदेश प्रेषण के सभी रूपों में पाया जाता है,आपकी प्रणाली में टिकटों के लिए लिंक बनाने के लिए।',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'बंद टिकट स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'ईमेल टिकट स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'फ़ोन टिकट स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'टिकट मुक्त पाठ स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट टिप्पणी स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट स्वामी स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट विचाराधीन स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट फोन आउटबाउंड स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट प्राथमिकता स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट उत्तरदायी स्क्रीन कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'टिकट ज़ूम कार्रवाई के लिए इतिहास समीक्षा को परिभाषित करता है,जो टिकट इतिहास के लिए ग्राहक अंतरफलक में प्रयोग किया जाता है।',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'बंद टिकट स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'ईमेल टिकट स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'फोन टिकट स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'टिकट मुक्त पाठ स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट टिप्पणी स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट स्वामी स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट विचाराधीन स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट फोन आउटबाउंड स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट प्राथमिकता स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'टिकट उत्तरदायी स्क्रीन कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए प्रतिनिधि अंतरफलक में इस्तेमाल किया जाता है।',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'टिकट ज़ूम कार्रवाई के लिए इतिहास के प्रकार को परिभाषित करता है,जो टिकट इतिहास के लिए ग्राहक अंतरफलक में प्रयोग किया जाता है।',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => 'कार्य समय की गणना करने के लिए घंटे और सप्ताह के दिनों को परिभाषित करता है।',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Kernel::Modules::AgentInfo मॉड्यूल के साथ जाँच करने के लिए कुंजी को परिभाषित करता है। यदि यह उपयोगकर्ता वरीयता कुंजी सही है,तो संदेश प्रणाली द्वारा स्वीकार कर लिए जाते हैं।',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'ग्राहकस्वीकार के साथ जाँच करने के लिए कुंजी को परिभाषित करता है। यदि यह उपयोगकर्ता वरीयता कुंजी सही है,तो संदेश प्रणाली द्वारा स्वीकार कर लिए जाते हैं।',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '\'सामान्य\' लिंक के प्रकार को परिभाषित करता है। यदि स्रोत नाम और लक्ष्य नाम का एक ही मान है,तो परिणामी लिंक गैर दिशात्मक है;अन्यथा,परिणाम एक दिशात्मक लिंक है।',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '\'जनक\बालक\' लिंक के प्रकार को परिभाषित करता है। यदि स्रोत नाम और लक्ष्य नाम का एक ही मान है,तो परिणामी लिंक गैर दिशात्मक है;अन्यथा,परिणाम एक दिशात्मक लिंक है।',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'लिंक के प्रकार समूहों को परिभाषित करता है। एक ही समूह के लिंक प्रकार एक दूसरे को रद्द कर देंगे।उदाहरण: यदि टिकट A टिकट B के साथ एक \'सामान्य\' लिंक के अनुसार जुड़ा हुआ है,तब इन टिकटों को \'जनक\बालक\' संबंध की लिंक के साथ नहीं जोड़ा जा सकता है।',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of params that can be passed to ticket search function.' =>
            '',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'अतिरिक्त संकुल के लिए ऑनलाइन भंडार सूची प्राप्त करने के लिए स्थान को परिभाषित करता है। पहले उपलब्ध परिणाम का उपयोग किया जाएगा।',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'प्रणाली के लिए अभिलेख मॉड्यूल को परिभाषित करता है। "फाइल" सभी संदेशों को किसी दिए गए अभिलेखफ़ाइल में लिखता है,"syslog" प्रणाली के syslog डेमॉन का उपयोग करता है, जैसे syslogd।',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'सत्र के लिए अधिकतम मान्य समय (सेकेंड में) पहचान को परिभाषित करता है।',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => 'PDF फ़ाइल के अनुसार पृष्ठों की अधिकतम संख्या को परिभाषित करता है।',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'अभिलेख फ़ाइल के अधिकतम आकार(MB में) को परिभाषित करता है।',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में वर्तमान में सभी प्रवॆशित प्रतिनिधियॊ को दिखाने वाले मॉड्यूल को परिभाषित करता है।',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'ग्राहकों को प्रमाणित करने वाले मॉड्यूल को परिभाषित करता है।',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'प्रतिनिधि अंतरफलक में एक अधिसूचना प्रदर्शित करने के लिए मॉड्यूल को परिभाषित करता है,अगर प्रणाली व्यवस्थापक उपयोगकर्ता के द्वारा प्रयोग किया जाता है (सामान्यतः आपको व्यवस्थापक के रूप में काम नहीं करना चाहिए)।',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            '',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'सत्र आंकड़ों को संग्रह करने के लिए मॉड्यूल को परिभाषित करता है। "DB" के साथ दृश्यपटल सर्वर को db सर्वर से विभाजित किया जा सकता है।  "FS" तेज है।',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'अनुप्रयोग का नाम,वेब अंतरफलक में दिखाए गए, वेब ब्राउज़र के टैब और शीर्षक पट्टी को परिभाषित करता।',
        'Defines the name of the column to store the data in the preferences table.' =>
            'वरीयताओं तालिका में आंकड़ों को संग्रह करने के लिए कॉलम के नाम को परिभाषित करता है। ',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'वरीयताओं तालिका में उपयोगकर्ता पहचानक के लिए कॉलम के नाम को परिभाषित करता है।',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => 'ग्राहक सत्र के लिए कुंजी का नाम को परिभाषित करता है।',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'सत्र कुंजी के नाम को परिभाषित करता है। उदा. सत्र SessionID,या OTRS।',
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट रचना स्क्रीन में रचना/जवाब टिकट  के बाद अगली संभव स्थिति को परिभाषित करता है।',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट अग्रेषित स्क्रीन में अग्रेषण टिकट के बाद  के बाद अगली संभव स्थिति को परिभाषित करता है।',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'ग्राहक अंतरफलक में ग्राहक टिकटों के लिए अगली संभव स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट की स्वामी स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट की विचाराधीन स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट की प्राथमिकता स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट फलांग स्क्रीन में टिप्पणी जोड़ने के बाद एक टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के स्थानांतरित टिकट स्क्रीन में अन्य श्रेणी में स्थानांतरित हो जाने के बाद टिकट के अगली स्थिति को परिभाषित करता है।',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '',
        'Defines the number of hours a successful communication will be stored.' =>
            '',
        'Defines the parameters for the customer preferences table.' => 'ग्राहक वरीयता तालिका के लिए मापदंडों को परिभाषित करता है।',
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
            'SOAP हैंडल(bin/cgi-bin/rpc.pl) का उपयोग करने के लिए कूटशब्द को परिभाषित करता है।',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'PDF दस्तावेज़ों में इटैलिक,मोटा मोनो दूरी फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'PDF दस्तावेज़ों में इटैलिक,मोटा आनुपातिक फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'PDF दस्तावेज़ों में मोटा मोनो दूरी फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'PDF दस्तावेज़ों में मोटा आनुपातिक फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'PDF दस्तावेज़ों में इटैलिक मोनो दूरी फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'PDF दस्तावेज़ों में इटैलिक आनुपातिक फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'PDF दस्तावेज़ों में मोनो दूरी फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'PDF दस्तावेज़ों में आनुपातिक फ़ॉन्ट को संभालने के लिए पथ और TTF-फ़ाइल को परिभाषित करता है।',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => 'द्विआधारी PGP के पथ को परिभाषित करता है।',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'द्विआधारी openssl के पथ को परिभाषित करता है। इसे एक घरेलू वातावरण की आवश्यकता हो सकती ($ENV{HOME} = \'/var/lib/wwwrun\';)।',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the postmaster default queue.' => 'डाकपाल तयशुदा श्रेणी को परिभाषित करता है।',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => 'आँकड़े के लिए खोज सीमा को परिभाषित करता है।',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'प्रतिनिधियॊ के असली नाम और कतार के दिए गए ईमेल पते के बीच विभाजक को परिभाषित करता है।',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'अनुप्रयोग के भीतर ग्राहकों के लिए उपलब्ध मानक अनुमतियों को परिभाषित करता है। यदि अधिक अनुमतियों की आवश्यकता हैं,तो आप उन्हें यहाँ दर्ज कर सकते हैं। अनुमतियाँ प्रभावी होने के लिए कठिन कोडित होना चाहिए। कृपया यह सुनिश्चित करें कि जब सामने दी गई वर्णित अनुमतियाँ को जोडें तो"rw" अनुमति अंतिम प्रविष्टि रहती हैं।',
        'Defines the standard size of PDF pages.' => 'PDF पृष्ठों के मानक आकार को परिभाषित करता है।',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'टिकट की स्थिति को परिभाषित करता है यदि अनुसरण हो जाता है और टिकट पहले ही बंद हो गया था।',
        'Defines the state of a ticket if it gets a follow-up.' => 'टिकट की स्थिति को परिभाषित करता है यदि अनुसरण हो जाता है।',
        'Defines the state type of the reminder for pending tickets.' => 'अनुस्मारक की टिकटों के लिए विचाराधीन स्थिति के प्रकार को परिभाषित करता है।',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'नए कूटशब्द के बारे में प्रतिनिधियॊ को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'नए शब्दकूट अनुरोध के बारे में प्रतीक के साथ प्रतिनिधियॊ को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'नए खाते के बारे में ग्राहकों को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'नए खाते के बारे में ग्राहकों को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'नए शब्दकूट अनुरोध के बारे में प्रतीक के साथ ग्राहकों को भेजे जाने वाले अधिसूचना मेल के लिए विषय को परिभाषित करता है।',
        'Defines the subject for rejected emails.' => 'खारिज कर दिए ईमेल के लिए विषय को परिभाषित करता है।',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'प्रणाली प्रशासक के ईमेल पते को परिभाषित करता है। यह अनुप्रयोग की त्रुटि स्क्रीन में प्रदर्शित किया जाएगा।',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'बाहरी ग्राहक आंकड़ाकोष की कड़ी में लक्ष्य विशेषता को परिभाषित करता है।',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the ticket plugin for calendar appointments.' => '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'ग्राहक पटल के लिए उपयोगकर्ता पहचानक को परिभाषित करता है।',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'SOAP(bin/cgi-bin/rpc.pl)हैंडल का उपयोग करने के लिए उपयोगकर्ता नाम को परिभाषित करता है।',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'समृद्ध पाठ संपादक घटक के लिए चौड़ाई को परिभाषित करता है।(पिक्सेल) संख्या या प्रतिशत मान (सापेक्ष) को लिखें।',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
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
            'स्थिति का विचाराधीन समय(कुंजी) पुरा हो जाने के बाद,स्थिति जो स्वचालित रूप से निर्धारित हो जानी चाहिए (सामग्री) को परिभाषित करता है।',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => '',
        'Deleted link to ticket "%s".' => 'टिकट के लिए लिंक हटाया "%s"।',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'एक सत्र यदि सत्र पहचान अवैध दूरदराज के IP पते के साथ इस्तेमाल किया जाता है को नष्ट कर देता है।',
        'Deletes requested sessions if they have timed out.' => 'अनुरोध सत्र को नष्ट कर देता है यदि उनका समय समाप्त हो गया है।',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'प्रतिनिधि अंतरफलक में संभव श्रेणीयों की सूची जिनमें टिकटों को स्थानांतरित कर सकते है उनको एक ड्रॉपडाउन सूची में या एक नई विंडो में प्रदर्शित किया जाना चाहिए। यदि "नई विंडो" निर्धारित है तो आप टिकटों के लिए एक स्थानांतरित टिप्पणी जोड़ सकते हैं।',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक नया ईमेल टिकटों के बनने के बाद,अगली संभव टिकट स्थिति निर्धारित करता है।',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक नये फोन टिकट के बनने के बाद,अगली संभव टिकट स्थिति निर्धारित करता है।',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'ग्राहक अंतरफलक में नए ग्राहक टिकट के बाद अगली स्क्रीन निर्धारित करता है।',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'विचाराधीन टिकट जो समय सीमा तक पहुँचने के बाद स्थिति बदल लेते हैं उनकी संभावित स्थिति को निर्धारित करता है।',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'लिंक वस्तुऐं हर ज़ूम नकाब में जिस तरह से प्रदर्शित  की जाती हैं उसे निर्धारित करता है।',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'ग्राहक अंतरफलक में  टिकट प्राप्तकर्ताओं के लिए जो श्रेणी वैध होगी उनको निर्धारित करता है।',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display communication log entries.' => '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'टिकट ज़ूम दृश्य में एक अनुच्छेद के समय का हिसाब प्रदर्शित करता है।',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => 'नीचे',
        'Dropdown' => '',
        'Dutch' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
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
        'DynamicField' => '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'DynamicField_%s' => '',
        'E-Mail Outbound' => '',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit appointment' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'ईमेल पते',
        'Email Outbound' => '',
        'Email Resend' => '',
        'Email communication channel.' => '',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Enabled filters.' => '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'S/MIME समर्थन सक्षम बनाता है।',
        'Enables customers to create their own accounts.' => 'ग्राहकों को अपने खाते बनाने के लिए सक्षम बनाता है।',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => 'पैकेज प्रबंधक दृश्यपटल में फ़ाइल अपलोड सक्षम बनाता है।',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'बिना  स्वामी और न ही जिम्मेदार का ट्रैक रखने के लिए,टिकट पहरेदार सुविधा को सक्षम या अक्षम बनाता है।',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'अभिलेख प्रदर्शन को को सक्षम बनाता है(पृष्ठ की प्रतिक्रिया समय के लिए अभिलेख)। यह प्रणाली के प्रदर्शन को प्रभावित करेगा। दृश्यपटल::मॉड्यूल### व्यवस्थापक प्रदर्शन अभिलेख सक्षम होना चाहिए।',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'एक समय में एक से अधिक टिकटों पर काम करने के लिए प्रतिनिधि दृश्यपटल की टिकट थोक कार्रवाई सुविधा को सक्षम बनाता है।',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'केवल सूचीबद्ध समूहों के लिए टिकट थोक कार्रवाई सुविधा को सक्षम बनाता है।',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'निर्दिष्ट टिकटों का ट्रैक रखने के लिए टिकट जिम्मेदार सुविधा को सक्षम बनाता है।',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => 'केवल सूचीबद्ध समूहों के लिए टिकट पहरेदार सुविधा को सक्षम बनाता है।',
        'English (Canada)' => '',
        'English (United Kingdom)' => '',
        'English (United States)' => '',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'संवर्धित टिकटें',
        'Escalation view' => 'संवर्धित दृश्य',
        'EscalationTime' => '',
        'Estonian' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
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
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => 'SQL बयान चलाएँ।',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'खोज परिणाम में पूरे अनुच्छेद वृक्ष को निर्यात करता है।',
        'External' => '',
        'External Link' => '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'प्रॉक्सी के माध्यम से संकुल को आनयन करता है। "वेब प्रयोक्ता प्रतिनिधि:प्रॉक्सी उपरिलेखन करता है।',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'आने वाले ईमेल निस्पादक।',
        'Finnish' => '',
        'First Christmas Day' => '',
        'First Queue' => '',
        'First response time' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'बाहर जाने की ईमेल के कूटबन्धन करने के लिए मजबूर करता है(7bit|8bit|quoted-printable|base64)।',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'लॉक कार्रवाई के बाद एक अलग स्थिति(वर्तमान से) चुनने के लिए टिकट को मजबूर करता है। कुंजी के रूप में वर्तमान स्थिति को परिभाषित करें,और सामग्री के रूप में लॉक कार्रवाई के बाद अगली स्थिति को।',
        'Forces to unlock tickets after being moved to another queue.' =>
            'अन्य कतार में स्थानांतरित होने के बाद टिकटों को अनलॉक करने के लिए मजबूर करता है।',
        'Forwarded to "%s".' => 'आगे"%s"।',
        'Free Fields' => 'स्वतंत्र क्षेत्र',
        'French' => '',
        'French (Canada)' => '',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'दृश्यपटल मॉड्यूल पंजीकरण(कंपनी लिंक निष्क्रिय करे यदि कंपनी सुविधा का उपयोग नहीं किया है)।',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the agent interface.' => 'प्रतिनिधि अंतरफलक के लिए दृश्यपटल मॉड्यूल पंजीकरण।',
        'Frontend module registration for the customer interface.' => 'ग्राहक अंतरफलक के लिए दृश्यपटल मॉड्यूल पंजीकरण।',
        'Frontend module registration for the public interface.' => '',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'Galician' => '',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'Generic Info module.' => '',
        'GenericAgent' => 'सामान्य प्रतिनिधि',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'German' => '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => '',
        'Go to dashboard!' => '',
        'Good PGP signature.' => '',
        'Google Authenticator' => '',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => '',
        'Hebrew' => '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '',
        'High contrast skin for visually impaired users.' => '',
        'Hindi' => '',
        'Hungarian' => '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो आंकड़ाकोष संचालक(सामान्य रूप से स्वत:पहचान प्रयोग किया जाता है) निर्दिष्ट किया जा सकता है।',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो एक पासवर्ड ग्राहक तालिका से जुड़ने लिए निर्दिष्ट किया जा सकता है।',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो एक उपयोगकर्ता नाम ग्राहक तालिका से जुड़ने लिए निर्दिष्ट किया जा सकता है।',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो ग्राहक तालिका में संपर्क के लिए DSN निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो ग्राहक कूटशब्द के लिए ग्राहक तालिका में स्तंभ नाम निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो ग्राहक तालिका में ग्राहक कुंजी के लिए स्तंभ का नाम निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'यदि "डीबी" ग्राहक::AuthModule के लिए चयन किया गया,तो तालिका जहाँ आपका ग्राहक आंकड़ा संग्रहीत किया जाना चाहिए का नाम निर्दिष्ट किया जाना चाहिए।',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'यदि "डीबी" SessionModule के लिए चयन किया गया,तो आंकड़ाकोष में एक तालिका जहां सत्र आंकड़ों को संग्रहीत किया जाएगा निर्दिष्ट किया जाना चाहिए।',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'यदि "एफएस" SessionModule के लिए चयन किया गया,तो एक निर्देशिका जहाँ सत्र आंकड़ों को संग्रहीत किया जाएगा निर्दिष्ट किया जाना चाहिए।',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'यदि "HTTPBasicAuth" ग्राहक::AuthModule के लिए चयन किया गया,तो आप(RegExp का उपयोग करके) REMOTE_USER(उदा.अनुगामी डोमेन हटाने के लिए) के पट्टी भागों को निर्दिष्ट कर सकते हैं। RegExp-नोट, $ 1 नया प्रवेश होगा।',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'यदि "HTTPBasicAuth" ग्राहक::AuthModule के लिए चयन किया गया,तो आप उपयोगकर्ता नाम के प्रमुख पट्टी भागों को निर्दिष्ट कर सकते हैं।',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया और यदि आप हर ग्राहक के लिए एक प्रवेश नाम प्रत्यय जोड़ना चाहते हैं,यहाँ निर्दिष्ट करते हैं,उदा.आप उपयोगकर्ता नाम उपयोगकर्ता लिखना चाहते हैं लेकिन आपकी LDAP निर्देशिका में user@domain मौजूद हैं।',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया और Net::LDAP perl मॉड्यूल के लिए विशेष मापदंड आवश्यक हैं,आप उन्हें यहाँ निर्दिष्ट कर सकते हैं। मापदंडों के बारे में अधिक जानकारी के लिए "perldoc Net::LDAP" देखें।',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया और आपके उपयोगकर्ताओं को LDAP वृक्ष के लिए केवल गुमनाम उपयोग हैं,लेकिन आप आंकड़ों के माध्यम से खोज करना चाहते हैं,आप एक उपयोगकर्ता जिसको LDAP निर्देशिका का उपयोग है के साथ यह कर सकते हैं। विशेष उपयोगकर्ता के लिए कूटशब्द यहाँ निर्दिष्ट करें।',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया और आपके उपयोगकर्ताओं को LDAP वृक्ष के लिए केवल गुमनाम उपयोग हैं,लेकिन आप आंकड़ों के माध्यम से खोज करना चाहते हैं,आप एक उपयोगकर्ता जिसको LDAP निर्देशिका का उपयोग है के साथ यह कर सकते हैं। विशेष उपयोगकर्ता के लिए उपयोगकर्ता नाम यहाँ निर्दिष्ट करें।',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो BaseDN निर्दिष्ट किया जाना चाहिए।',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो LDAP मेजबान निर्दिष्ट किया जा सकता है।',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो उपयोगकर्ता पहचानकर्ता निर्दिष्ट किया जाना चाहिए।',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो उपयोगकर्ता विशेषताएँ निर्दिष्ट की जा सकती है। LDAP posixGroups के लिए UID उपयोग करते हैं,गैर LDAP posixGroups के लिए पूर्ण उपयोगकर्ता DN का उपयोग करें।',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो आप एक्सेस विशेषताएँ यहां निर्दिष्ट कर सकते हैं।',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो आप निर्दिष्ट कर सकते हैं यदि अनुप्रयोग बंद हो जाएगा। उदा. यदि किसी सर्वर से कोई संबंध नेटवर्क समस्याओं के कारण स्थापित नहीं किया जा सकता है।',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'यदि "LDAP" ग्राहक::AuthModule के लिए चयन किया गया, तो आप जाँच कर सकते हैं यदि उपयोगकर्ता को प्रमाणित करने की अनुमति दी है क्योंकि वह एक posixGroup में है,उदा. उपयोगकर्ता के लिए एक समूह xyz में होना चाहिए OTRS का उपयोग करने के लिए।',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'यदि "LDAP" चुना गया,आप एक निस्पादक हर LDAP क्वेरी के लिए जोड़ सकते हैं,उदा. (mail=*), (objectclass=user) or (!objectclass=computer)।',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'यदि ग्राहक::AuthModule के लिए "त्रिज्या" चयन किया गया,कूटशब्द त्रिज्या मेजबान प्रमाणित करने करने के लिए निर्दिष्ट किया जाना चाहिए।',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'यदि ग्राहक::AuthModule के लिए "त्रिज्या" चयन किया गया,त्रिज्या मेजबान निर्दिष्ट किया जाना चाहिए।',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'यदि ग्राहक::AuthModule के लिए "त्रिज्या" चयन किया गया,तो आप निर्दिष्ट कर सकते हैं यदि अनुप्रयोग बंद हो जाएगा। उदा. यदि किसी सर्वर से कोई संबंध नेटवर्क समस्याओं के कारण स्थापित नहीं किया जा सकता है।',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'यदि SendmailModule के रूप में "Sendmail" चुना गया,sendmail द्विआधारी के स्थान और आवश्यक विकल्प निर्दिष्ट किया जाना चाहिए।',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'यदि LogModule लिए "syslog" चुना गया,एक विशेष अभिलेख सुविधा निर्दिष्ट की जा सकती है।',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'यदि LogModule लिए "syslog" चुना गया,वर्णसमूह जो प्रवेश करने के लिए इस्तेमाल किया जाना चाहिए निर्दिष्ट किया जा सकता है।',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'यदि "फाइल " LogModule के लिए चुना गया,एक अभिलेख फ़ाइल जरूर निर्दिष्ट करना चाहिए। यदि फ़ाइल मौजूद नहीं है,यह प्रणाली द्वारा बनाई जाएगी।',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'यदि "एसएमटीपी" तंत्र को किसी भी SendmailModule के रूप में चुना गया,और मेल सर्वर के लिए प्रमाणीकरण की जरूरत है,एक कूटशब्द जरूर निर्दिष्ट करे।',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'यदि "एसएमटीपी" तंत्र को किसी भी SendmailModule के रूप में चुना गया,और मेल सर्वर के लिए प्रमाणीकरण की जरूरत है,एक उपयोगकर्ता नाम जरूर निर्दिष्ट करे।',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'यदि "एसएमटीपी" तंत्र को किसी भी SendmailModule के रूप में चुना गया,मेल मेजबान जो बाहर मेल भेजता है निर्दिष्ट किया जाना चाहिए।',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'यदि "एसएमटीपी" तंत्र को किसी भी SendmailModule के रूप में चुना गया,पोर्ट जहाँ आपका मेल सर्वर आवक कनेक्शन के लिए सुन रहा है जरूर निर्दिष्ट करना चाहिए।',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'यदि सक्रिय है,OTRS छोटे किए गए प्रपत्र में सभी जावास्क्रिप्ट फ़ाइलें वितरित करेगा।',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'यदि सक्रिय है,टिकट फोन और ईमेल टिकट नये विंडो में खुल जाएगा।',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'यदि सक्रिय है,मुख्य मेनू के पहले के स्तर को माउस मंडराना खोलता है(के बजाय केवल क्लिक से)।',
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
            'यदि यह नियमित अभिव्यक्ति से मेल खाता है,स्वतःप्रत्युत्तर से कोई संदेश नहीं भेजें।',
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
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट खोज में अनुच्छेद बनाने समय शामिल हैं।',
        'Incoming Phone Call.' => '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => '',
        'Inline' => '',
        'Input' => '',
        'Interface language' => 'अंतरफलक भाषा',
        'Internal communication channel.' => '',
        'International Workers\' Day' => '',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'विभिन्न सतही विन्यस्त करना संभव है,उदाहरण के लिए विभिन्न प्रतिनिधि के बीच भेद करने के लिए,अनुप्रयोग में प्रति एक डोमेन के आधार पर इस्तेमाल किया जा सकता हैं। एक नियमित अभिव्यक्ति(Regex) का उपयोग करना,आप एक कुंजी/सामग्री जोड़ी विन्यस्त करने एक डोमेन मिलान कर सकते हैं। डोमेन में "कुंजी" मान से मेल खाना चाहिए और "सामग्री" में मूल्य अपने प्रणाली पर एक वैध सतही होना चाहिए। regex के उचित रूप के लिए उदाहरण प्रविष्टियों को देखें।',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'विभिन्न सतही विन्यस्त करना संभव है,उदाहरण के लिए विभिन्न ग्राहकों के बीच भेद करने के लिए,अनुप्रयोग में प्रति एक डोमेन के आधार पर इस्तेमाल किया जा सकता हैं। एक नियमित अभिव्यक्ति(Regex) का उपयोग करना,आप एक कुंजी/सामग्री जोड़ी विन्यस्त करने एक डोमेन मिलान कर सकते हैं। डोमेन में "कुंजी" मान से मेल खाना चाहिए और "सामग्री" में मूल्य अपने प्रणाली पर एक वैध सतही होना चाहिए। regex के उचित रूप के लिए उदाहरण प्रविष्टियों को देखें।',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'विभिन्न थीम विन्यस्त करना संभव है,उदाहरण के लिए विभिन्न प्रतिनिधि और ग्राहकों के बीच भेद करने के लिए,अनुप्रयोग में प्रति एक डोमेन के आधार पर इस्तेमाल किया जा सकता हैं। एक नियमित अभिव्यक्ति(Regex) का उपयोग करना,आप एक कुंजी/सामग्री जोड़ी विन्यस्त करने एक डोमेन मिलान कर सकते हैं। डोमेन में "कुंजी" मान से मेल खाना चाहिए और "सामग्री" में मूल्य अपने प्रणाली पर एक वैध थीम होना चाहिए। regex के उचित रूप के लिए उदाहरण प्रविष्टियों को देखें।',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => '',
        'JavaScript function for the search frontend.' => '',
        'Korean' => '',
        'Language' => 'भाषा',
        'Large' => 'बड़ा',
        'Last Screen Overview' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'LastnameFirstname' => '',
        'Latvian' => '',
        'Left' => '',
        'Link Object' => 'लिंक वस्तु',
        'Link Object.' => '',
        'Link agents to groups.' => 'प्रतिनिधिओं को समूहों से जोडें।',
        'Link agents to roles.' => 'प्रतिनिधिओं को भूमिकाओं से जोडें।',
        'Link customer users to customers.' => '',
        'Link customer users to groups.' => '',
        'Link customer users to services.' => '',
        'Link customers to groups.' => '',
        'Link queues to auto responses.' => 'श्रेणीयों को स्वत प्रतिक्रियाओं से जोडें।',
        'Link roles to groups.' => 'भूमिकाओं को समूहों से जोडें।',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => '',
        'Link this ticket to other objects' => '',
        'Links 2 tickets with a "Normal" type link.' => '2 टिकटों को "सामान्य"प्रकार के लिंक के साथ जोडें।',
        'Links 2 tickets with a "ParentChild" type link.' => '2 टिकटों को "ParentChild"प्रकार के लिंक के साथ जोडें।',
        'Links appointments and tickets with a "Normal" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            'प्रतिनिधि इंटरफ़ेस के लिए हमेशा लोड होने वाली सीएसएस फ़ाइलों के सूची।',
        'List of CSS files to always be loaded for the customer interface.' =>
            'ग्राहक इंटरफ़ेस के लिए हमेशा लोड होने वाली सीएसएस फ़ाइलों के सूची।',
        'List of JS files to always be loaded for the agent interface.' =>
            'प्रतिनिधि इंटरफ़ेस के लिए हमेशा लोड होने वाली JS फ़ाइलों के सूची।',
        'List of JS files to always be loaded for the customer interface.' =>
            'ग्राहक इंटरफ़ेस के लिए हमेशा लोड होने वाली JS फ़ाइलों के सूची।',
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
        'Locked Tickets' => 'लॉकड टिकटें',
        'Locked Tickets.' => '',
        'Locked ticket.' => 'लॉक।',
        'Logged in users.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Look into a ticket!' => 'टिकट में देखें',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => '',
        'MailQueue configuration settings.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => '',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'एक ईमेल भेजने या एक टेलीफोन जमा या ईमेल के टिकट से पहले अनुप्रयोग ईमेल पतों की MX रिकॉर्ड की जाँच करें।',
        'Makes the application check the syntax of email addresses.' => 'अनुप्रयोग ईमेल पतों के वाक्यविन्यास की जाँच करें।',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'सत्र प्रबंधन html कुकीज़ का उपयोग करता है। यदि html कुकीज़ अक्षम हो जाते हैं या यदि ग्राहक ब्राउज़र html कुकीज़ को अक्षम कर देता हैं,तो प्रणाली सामान्य रूप से काम करेगी और लिंक करने के लिए आईडी सत्र संलग्न करें।',
        'Malay' => '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => 'ईमेल कूटलेखन के लिए PGP कुंजी प्रबंधित का प्रबंधन करें।',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'ईमेल आनयन करने के लिए POP3 या IMAP खातों का प्रबंधन करें।',
        'Manage S/MIME certificates for email encryption.' => 'ईमेल कूटलेखन के लिए S/MIME प्रमाणपत्र कुंजी प्रबंधित का प्रबंधन करें।',
        'Manage System Configuration Deployments.' => '',
        'Manage different calendars.' => '',
        'Manage existing sessions.' => 'मौजूदा सत्र का प्रबंधन करें।',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark as Spam!' => 'अवांछनीय मार्क करें',
        'Mark this ticket as junk!' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'ग्राहक जानकारी तालिका(फोन और ईमेल) के स्क्रीन रचना में अधिकतम आकार(अक्षरों में)।',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'अधिकतम स्वत ईमेल प्रतिक्रियाओं जो ईमेल पता एक दिन स्वयं के लिए(लूप-संरक्षण)।',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'मेल जोPOP3/POP3S/IMAP/IMAPS के माध्यम से आनयन हूए के अधिकतम आकार Kbytes में।',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'टिकटों की अधिकतम संख्या प्रतिनिधि अंतरफलक में एक खोज के परिणाम में प्रदर्शित करने के लिए।',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'टिकटों की अधिकतम संख्या ग्राहक अंतरफलक में एक खोज के परिणाम में प्रदर्शित करने के लिए।',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'टिकट ज़ूम दृश्य में ग्राहक जानकारी तालिका का अधिकतम आकार(अक्षरों में)।',
        'Medium' => 'मध्यम',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Minute' => '',
        'Miscellaneous' => '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'ग्राहक अंतरफलक में नई टिकट स्क्रीन में चयन के लिए माड्यूल।',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => 'हस्ताक्षरित संदेश(PGP या S/MIME) लिखने के लिए मॉड्यूल।',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'आवक संदेशों में हेरफेर और निस्पादक करने के लिए मॉड्यूल। ब्लॉक/अनदेखा सभी अवांछनीय ईमेल से:noreply@ address के साथ।',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'आवक संदेशों में हेरफेर और निस्पादक करने के लिए मॉड्यूल। टिकट मुक्त पाठ के लिए एक 4 अंकों की संख्या प्राप्त करें,मैच में regex का उपयोग करें,उदा.से :=> \'(.+?)@.+?\',और उपयोग करें () रूप में [***] में Set =>',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में html मुक्त खोज छोटे टिकट के लिए खोजें रूपरेखा उत्पन्न करने के लिए मॉड्यूल।',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'ग्राहक अंतरफलक में html मुक्त खोज छोटे टिकट के लिए खोजें रूपरेखा उत्पन्न करने के लिए मॉड्यूल।',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
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
            'सूचनाएँ और संवर्धित को दिखाने के लिए मॉड्यूल(ShownMax: अधिकतम संवर्धित दिखाए,EscalationInMinutes:टिकट दिखाना जो संवर्धित होगें,CacheTime: सेकंड में गणना की बढ़ोतरी के संचित)।',
        'Module to use database filter storage.' => 'आंकड़ाकोष संग्रहण निस्पादक उपयोग करने के लिए मॉड्यूल।',
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => '',
        'My Queues' => 'मेरी श्रेणी',
        'My Services' => '',
        'My Tickets.' => '',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'अनुकूलित श्रेणी के नाम। अनुकूलित कतार एक कतार चयन है,आपकी वरीयता श्रेणीयों का और चयनित किया जा सकता है वरीयता व्यवस्थाओ में।',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New Ticket' => 'नये टिकट ',
        'New Tickets' => 'नई टिकटें ',
        'New Window' => '',
        'New Year\'s Day' => '',
        'New Year\'s Eve' => '',
        'New process ticket' => '',
        'News about OTRS releases!' => '',
        'News about OTRS.' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट फोन आउटबाउंड स्क्रीन में एक फोन टिप्पणी जोड़ने के बाद टिकट की अगली संभव स्थिति।',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => '',
        'Norwegian' => '',
        'Notification Settings' => '',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'प्रदर्शित टिकट की संख्या',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'पंक्तियों(प्रति टिकट) की संख्या जो प्रतिनिधि अंतरफलक में खोज उपयोगिता द्वारा दिखाए जाते हैं।',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक खोज परिणाम के प्रत्येक पृष्ठ में प्रदर्शित होने के लिए टिकटों की संख्या।',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'ग्राहक अंतरफलक में एक खोज परिणाम के प्रत्येक पृष्ठ में प्रदर्शित होने के लिए टिकटों की संख्या।',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => '',
        'OTRS News' => 'OTRS समाचार',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Option' => '',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Other Customers' => '',
        'Out Of Office' => '',
        'Out Of Office Time' => 'कार्यालय के समय से बाहर',
        'Out of Office users.' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'अधिभार(पुनर्व्याख्या) मौजूदा कार्य Kernel::System::Ticket में। आसानी से अनुकूलन जोड़ने के लिए। ',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => '',
        'Overview of all Tickets per assigned Queue.' => '',
        'Overview of all appointments.' => '',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => 'सभी खुले टिकटों का ओवरव्यू',
        'Overview of all open tickets.' => '',
        'Overview of customer tickets.' => '',
        'PGP Key' => 'PGP कुंजी',
        'PGP Key Management' => '',
        'PGP Keys' => 'PGP कुंजियाँ',
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
        'Parameters of the example SLA attribute Comment2.' => ' SLA विशेषता समीक्षा2 के उदाहरण के मापदंड।',
        'Parameters of the example queue attribute Comment2.' => 'श्रेणी विशेषता समीक्षा2 के उदाहरण के मापदंड।',
        'Parameters of the example service attribute Comment2.' => 'सेवा विशेषता समीक्षा2 के उदाहरण के मापदंड।',
        'Parent' => 'अभिभावक',
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'अभिलेख फ़ाइल के लिए पथ(यह तभी लागू होगा जब "FS" LoopProtectionModule के लिए चुना गया और यह अनिवार्य है)।',
        'Pending time' => '',
        'People' => '',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => 'रचना ईमेल विंडोज़ के लिए अनुमति प्राप्त चौड़ाई।',
        'Permitted width for compose note windows.' => 'रचना टिप्पणी विंडोज़ के लिए अनुमति प्राप्त चौड़ाई।',
        'Persian' => '',
        'Phone Call Inbound' => '',
        'Phone Call Outbound' => 'फोन कॉल आउटबाउंड',
        'Phone Call.' => '',
        'Phone call' => 'फोन कॉल',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'फोन टिकट',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => '',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => 'डाकपाल निस्पादक',
        'PostMaster Mail Accounts' => 'डाकपाल मेल खाते',
        'Print this ticket' => '',
        'Priorities' => 'प्राथमिकताएं',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process Ticket.' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Processes & Automation' => '',
        'Product News' => 'उत्पाद समाचार',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => '',
        'Public calendar.' => '',
        'Queue view' => 'श्रेणी दृश्य',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => 'ताज़ाकरण अंतराल',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => 'अनुस्मारक टिकटें',
        'Removed subscription for user "%s".' => 'सदस्यता रद्द करें "%s"।',
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
            'प्रतिनिधि अंतरफलक रचना स्क्रीन में जवाब रचना पर मौलिक प्रेषक को वर्तमान ग्राहक के ईमेल पते के साथ बदलता है।',
        'Reports' => '',
        'Reports (OTRS Business Solution™)' => '',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक टिकट के ग्राहकों को बदलने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में बंद टिकट स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट फलांग स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट रचना स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट अग्रिम स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट मुक्त पाठ स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट विलय स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट टिप्पणी स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट स्वामी स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट स्वामी स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट फोन आउटबाउंड स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में जूम टिकट के टिकट प्राथमिकता स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट उत्तरदायी स्क्रीन का उपयोग करने के लिए आवश्यक अनुमतियां।',
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'यदि अन्य कतार में स्थानांतरित होने के बाद टिकट के स्वामी को फिर से निर्धारित करता है और अनलॉक करता है।',
        'Resource Overview (OTRS Business Solution™)' => '',
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
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
        'Russian' => '',
        'S/MIME Certificates' => 'S/MIME प्रमाणपत्रों',
        'SMS' => '',
        'SMS (Short Message Service)' => '',
        'Salutations' => 'अभिवादन',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen after new ticket' => 'नये टिकट के बाद की स्क्रीन',
        'Search Customer' => 'ग्राहक खोजें',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => '',
        'Search backend default router.' => 'बैकेंड तयशुदा अनुर्मागक खोजें।',
        'Search backend router.' => 'बैकेंड अनुर्मागक खोजें।',
        'Search.' => '',
        'Second Christmas Day' => '',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'CSV संचिका (आँकड़े और खोजों) में उपयोग कियॆ जानॆवालॆ विभाजक वर्ण को चुनें। यदि आप यहाँ एक विभाजक चयन नहीं करते हैं, तो आपकी भाषा के लिए तयशुदा विभाजक का उपयोग किया जाएगा।',
        'Select your frontend Theme.' => 'आपकी दृश्यपटल थीम चुनें।',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'वेब अंतरफलक के द्वारा अपलोड संभालने के लिए मॉड्यूल चुनता है। "DB" आंकड़ाकोष में सभी अपलोड को संग्रहीत करता है,"FS" फ़ाइल प्रणाली का उपयोग करता है।',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'उपयोगकर्ताओं को अधिसूचनाएँ भेजें।',
        'Sender type for new tickets from the customer inteface.' => 'ग्राहक अंतरफलक से नये टिकटों के लिए प्रेषक प्रकार।',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'प्रतिनिधि अनुवर्ती अधिसूचना स्वामी को ही भेजता है,यदि एक टिकट अनलॉक है(सभी एजेंटों को अधिसूचना भेजना तयशुदा है)',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'गुप्त प्रतिलिपि के माध्यम से सभी बाहर जाने वाले ईमेल निर्दिष्ट पते पर भेजता है। यह बैकअप कारणों के लिए ही प्रयोग करें।',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'अनलॉक टिकट के लिए अनुस्मारक अधिसूचना भेजता है,अनुस्मारक दिनांक पहुँचने के बाद(केवल टिकट स्वामी को भेजा जाता है)।',
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
        'Service Level Agreements' => 'सेवा लेवल समझौतॆ',
        'Service view' => '',
        'ServiceView' => '',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => 'इस प्रणाली के लिए प्रेषक ईमेल पते निर्धारित करें।',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoom में इनलाइन HTML अनुच्छेद की तयशुदा ऊंचाई(पिक्सेल में) निर्धारित करें।',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoom में इनलाइन HTML अनुच्छेद की अधिकतम ऊंचाई(पिक्सेल में) निर्धारित करें।',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'स्थापित करता है,यदि टिकट स्वामी प्रतिनिधि के द्वारा चुना जाना चाहिए।',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'एक टिकट का विचाराधीन समय 0 स्थापित करता है,यदि स्थिति एक गैर-विचाराधीन स्थिति में बदल जाए।',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'श्रेणीयो में शामिल अछूते टिकटों पर प्रकाश डालाने के लिए मिनटों(प्रथम स्तर) में आयु स्थापित करता है।',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'श्रेणीयो में शामिल अछूते टिकटों पर प्रकाश डालाने के लिए मिनटों(द्वितीय स्तर) में आयु स्थापित करता है।',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'प्रशासक के विन्यास स्तर को स्थापित करता है। विन्यास स्तर के आधार पर,कुछ sysconfig विकल्प नहीं दिखाए जाएंगे। विन्यास स्तर बढ़ते क्रम में हैं:विशेषज्ञ,विकसित,शुरुआत। अधिक विन्यास स्तर पर(उदाहरण के लिए शुरुआत सर्वाधिक है),यह संभावना कम है कि उपयोगकर्ता गलती से प्रणाली को इस तरह विन्यस्त कर सकते हैं कि प्रणाली उपयोग करने योग्य नहीं रहें।',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट स्थानांतरित स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा मुख्य-भाग पाठ स्थापित करता है।',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of split tickets in the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में विभाजित टिकटों की तयशुदा लिंक प्रकार स्थापित करता है।',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये फोन टिकटों के लिए तयशुदा अगली स्थिति स्थापित करता है।',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में एक ईमेल टिकट के बनने के बाद तयशुदा अगली टिकट स्थिति स्थापित करता है।',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'नए टेलीफोन टिकटों के लिए तयशुदा टिप्पणी पाठ स्थापित करता है। प्रतिनिधि अंतरफलक में  उदा.\'कॉल के माध्यम से न्यू टिकट \'',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये ईमेल टिकटों के लिए तयशुदा प्राथमिकता स्थापित करता है।',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये फोन टिकटों के लिए तयशुदा प्राथमिकता स्थापित करता है।',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये ईमेल टिकटों के लिए तयशुदा प्रेषक प्रकार स्थापित करता है।',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये फोन टिकटों के लिए तयशुदा प्रेषक प्रकार स्थापित करता है।',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये ईमेल टिकटों(उदा \'ईमेल आउटबाउंड\') के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में नये फोन टिकटों(उदा \'फोन कॉल\') के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट स्थानांतरित स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में जोडी गयी टिप्पणी के लिए तयशुदा विषय स्थापित करता है।',
        'Sets the default text for new email tickets in the agent interface.' =>
            'एजेंट अंतरफलक में नये ईमेल टिकटों के लिए तयशुदा पाठ स्थापित करता है।',
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
            'पंक्तियों की संख्या जो पाठ संदेश में प्रदर्शित किए जाते हैं को स्थापित करता है(उदा. QueueZoom में टिकट लाइनें)।',
        'Sets the options for PGP binary.' => 'PGP द्विआधारी के लिए विकल्प स्थापित करता है।',
        'Sets the password for private PGP key.' => 'निजी PGP कुंजी के लिए कूटशब्द स्थापित करता है।',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'अनुशंसित समय इकाइयों को स्थापित करता है(उदा. कार्य,इकाइयों,घंटे,मिनट)।',
        'Sets the preferred digest to be used for PGP binary.' => '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'सर्वर पर लिपि फ़ोल्डर में उपसर्ग स्थापित करता है,जिस रूप में वेब सर्वर पर विन्यस्त है। यह व्यवस्था किसी परिवर्तनीय के रूप में प्रयोग कि जाती है,OTRS_CONFIG_ScriptAlias जो के सभी रूपों में पाया जाता है अनुप्रयोग द्वारा उपयोग संदेश प्रेषण में,इस प्रणाली के भीतर टिकटों के लिए लिंक बनाने के लिए।',
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
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिकट के उत्तरदायी प्रतिनिधि को स्थापित करता है।',
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
        'Sets the stats hook.' => 'आँकड़ों के हुक को स्थापित करता है।',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के स्वामी स्क्रीन में स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के विचाराधीन स्क्रीन में स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक के जूम टिकट के प्राथमिकता स्क्रीन में स्वामी को स्थापित करता है।',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिकट के स्वामी को स्थापित करता है।',
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'http / FTP डाउनलोड करने के लिए समय समाप्ति(सेकेंड में) को स्थापित करता है।',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'संकुल डाउनलोड करने के लिए समय समाप्ति (सेकेंड में) को स्थापित करता है। "WebUserAgent::Timeout" को अधिलेखित करता है।',
        'Shared Secret' => '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में फोन और ईमेल के टिकटों में एक जिम्मेदार चयन दिखाएँ।',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show command line output.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => '',
        'Show the ticket history' => '',
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
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में हर टिकट के अवलोकन में टिप्पणी को जोड़ने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
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
            'प्रतिनिधि अंतरफलक के टिकट ज़ूम दृश्य में हर टिकट के अवलोकन में टिकट बंद करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट को नष्ट करने के लिए विकल्प सूची में एक कड़ी दिखाता है। अतिरिक्त अभिगम नियंत्रण दिखाने या नहीं दिखाने के लिए ये कड़ी किया जा सकता है कुंजी "समूह" का उपयोग करके और "rw:group1;move_into:group2" विषयवस्तु की तरह।',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट अवलोकन में टिकट लॉक/अनलॉक करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट स्थानांतरित करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट इतिहास देखने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'प्रतिनिधि अंतरफलक में हर टिकट के अवलोकन में टिकट की प्राथमिकता को निर्धारित करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट अवलोकन में एक टिकट ज़ूम करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में अनुच्छेद के ज़ूम दृश्य में HTML ऑनलाइन दर्शक के माध्यम से अनुच्छेद संलग्नक उपयोग के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में अनुच्छेद के ज़ूम दृश्य में अनुच्छेद संलग्नक डाउनलोड करने के लिए विकल्प सूची में एक कड़ी दिखाता है।',
        'Shows a link to see a zoomed email ticket in plain text.' => 'सादे पाठ में एक जूम टिकट देखने के लिए एक कड़ी दिखाता है।',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट स्वामी स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट विचाराधीन स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट प्राथमिकता स्क्रीन में।',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'इस टिकट में सभी शामिल प्रतिनिधियों की एक सूची दिखाता है,प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट स्वामी स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट विचाराधीन स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट प्राथमिकता स्क्रीन में।',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'सभी संभावित प्रतिनिधियों की एक सूची दिखाता है(सभी प्रतिनिधि श्रेणी/टिकट में टिप्पणी अनुमतियों के साथ) निर्धारित करने के लिए जिसको इस नोट के बारे में सूचित किया जाना चाहिए,प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में।',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'टिकट अवलोकन का पूर्वावलोकन दिखाता है(ग्राहक जानकारी => 1- ग्राहक जानकारी भी दिखाता है,CustomerInfoMaxSize ग्राहक जानकारी के अक्षरों में अधिकतम आकार)।',
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'श्रेणी दृश्य में दोनों सभी ro और rw श्रेणीयो को दिखाता है।',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'प्रतिनिधि अंतरफलक की संवर्धित दृश्य में सभी खुले टिकट(भले ही वे लॉकङ हो) दिखाता है।',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'बहु चयन क्षेत्र में सभी ग्राहक पहचानकर्ताओं को दिखाता है(उपयोगी नहीं यदि आपके पास ग्राहक पहचानकर्ता बहुत है)।',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में फोन और ईमेल टिकट में एक स्वामी चयन को दिखाता है।',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'प्रतिनिधि टिकट फोन,प्रतिनिधि टिकट ईमेल,और प्रतिनिधि टिकट ग्राहक में ग्राहक इतिहास टिकट दिखाता है।',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'छोटे प्रारूप अवलोकन में या तो अंतिम ग्राहक अनुच्छेद विषय या टिकट शीर्षक दिखाता है।',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'एक वृक्ष या एक सूची के रूप में वर्तमान प्रणाली में जनक/बालक श्रेणी सूची दिखाता है।',
        'Shows information on how to start OTRS Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'अनुच्छेद दिखाता है सामान्य रूप से हल या विपरीत दिशा में,प्रतिनिधि अंतरफलक में ज़ूम टिकट के अंतर्गत।',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'रचना स्क्रीन में ग्राहक उपयोगकर्ता जानकारी(फोन और ईमेल) दिखाता है।',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के प्रवेश स्क्रीन में दिन के संदेश दिखाता है।',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में टिकट इतिहास(विपरीत आदेश) दिखाता है।',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के बंद टिकट स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के स्थानांतरित टिकट स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट थोक स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट मुक्त पाठ स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट टिप्पणी स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट स्वामी स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट विचाराधीन स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'प्रतिनिधि अंतरफलक में ज़ूम टिकट के टिकट प्राथमिकता स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'प्रतिनिधि अंतरफलक के टिकट उत्तरदायी स्क्रीन में टिकट प्राथमिकता विकल्प दिखाता है।',
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
        'Signatures' => 'हस्ताक्षर',
        'Simple' => '',
        'Skin' => 'सतही',
        'Slovak' => '',
        'Slovenian' => '',
        'Small' => 'लघु',
        'Software Package Manager.' => '',
        'Solution time' => '',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'टिकटों(आरोही या अवरोही) को क्रमबद्ध करता है जब श्रेणी दृश्य में एक ही श्रेणी का चयन किया जाता है और टिकट प्राथमिकता के आधार पर बाद में क्रमबद्ध किए जाते हैं। मान:0=आरोही(शीर्ष में सबसे पुराना,तयशुदा),1=अवरोही(शीर्ष में नवीनतम)। कुंजी के लिए QueueID और मूल्य के लिए 0 या 1 का प्रयोग करें।',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'अवांछनीय अवरोधी उदाहरण स्थापना। ईमेल जो अवांछनीय अवरोधी से चिह्नित हैं पर ध्यान न दें।',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'अवांछनीय अवरोधी उदाहरण स्थापना। चिह्नित मेल अवांछनीय श्रेणी में स्थानांतरित करें।',
        'Spanish' => '',
        'Spanish (Colombia)' => '',
        'Spanish (Mexico)' => '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'निर्दिष्ट करता है यदि एक प्रतिनिधि अपने खुद के कार्यों की ईमेल अधिसूचना प्राप्त करना चाहे।',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => 'निर्देशिका निर्दिष्ट करता है जहाँ SSL प्रमाणपत्र संग्रहीत हैं।',
        'Specifies the directory where private SSL certificates are stored.' =>
            'निर्देशिका निर्दिष्ट करता है जहाँ निजी SSL प्रमाणपत्र संग्रहीत हैं।',
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
            'पृष्ठ शीर्षक में प्रतीक चिह्न के लिए फ़ाइल का पथ निर्दिष्ट करता है(gif|jpg|png, 700 x 100 पिक्सेल)।',
        'Specifies the path of the file for the performance log.' => 'प्रदर्शन के लिए अभिलेख के लिए फ़ाइल का पथ निर्दिष्ट करता है।',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'वेब अंतरफलक में,परिवर्तक के लिए पथ निर्दिष्ट करता है जो Microsoft Excel फ़ाइलों को देखने की अनुमति देता हैं।',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'वेब अंतरफलक में,परिवर्तक के लिए पथ निर्दिष्ट करता है जो Microsoft Word फ़ाइलों को देखने की अनुमति देता हैं।',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'वेब अंतरफलक में,परिवर्तक के लिए पथ निर्दिष्ट करता है जो PDF दस्तावेजों को देखने की अनुमति देता हैं।',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'वेब अंतरफलक में,परिवर्तक के लिए पथ निर्दिष्ट करता है जो XML फ़ाइलों को देखने की अनुमति देता हैं।',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'पाठ को निर्दिष्ट करता है जो लॉग फ़ाइल में दिखाई देना चाहिए CGI स्क्रिप्ट प्रविष्टि निरूपित करने के लिए।',
        'Specifies user id of the postmaster data base.' => 'डाकपाल आंकड़ा कोष के उपयोगकर्ता आईडी को निर्दिष्ट करता है।',
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
            'मानक अनुप्रयोग के भीतर प्रतिनिधियों के लिए उपलब्ध अनुमतियाँ। यदि अधिक अनुमतियों की आवश्यकता है,उन्हें यहाँ दर्ज किया जा सकता। अनुमतियों के लिए प्रभावी होगा परिभाषित किया जाना चाहिए। कुछ अन्य अच्छी अन्तर्निहित अनुमतियाँ भी प्रदान की है: टिप्पणी,विचाराधीन,बंद,ग्राहक,मुक्त पाठ,स्थानांतरित,रचना,उत्तरदायी,अग्रेषण और फलांग। सुनिश्चित करें कि "rw" हमेशा अंतिम पंजीकृत अनुमति हैं।',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'सांख्यिकी की गणना के लिए आरंभ संख्या। हर नया आँकड़ा इस संख्या बढ़ता है।',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => '',
        'States' => 'स्तर',
        'Statistic Reports overview.' => '',
        'Statistics overview.' => '',
        'Status view' => 'स्तर दृश्य',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => 'ब्राउज़र के बंद होने के बाद कुकीज़ को संग्रहीत करता है।',
        'Strips empty lines on the ticket preview in the queue view.' => 'कतार दृश्य में टिकट पूर्वावलोकन पर रिक्त पंक्तियाँ खाली कर देता है।',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => '',
        'Swedish' => '',
        'System Address Display Name' => '',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Maintenance' => '',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => '',
        'Textarea' => '',
        'Thai' => '',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'प्रतिनिधि की आंतरिक सतही का नाम जो प्रतिनिधि अंतरफलक में उपयोग किया जाना चाहिए। दृश्यपटल::एजेंट::सतही में उपलब्ध सतही की जाँच करें।',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'ग्राहक की आंतरिक सतही का नाम जो ग्राहक अंतरफलक में उपयोग किया जाना चाहिए। दृश्यपटल::ग्राहक::सतही में उपलब्ध सतही की जाँच करें।',
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
            'टिकट हूक और टिकट संख्या के बीच विभाजक। उदा. \': \'।',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => 'ग्राहक अंतरफलक में दिखाया गया शीर्षक।',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'एक टिकट के लिए पहचानकर्ता,उदा टिकट#,कॉल#,मेरा टिकट#। तयशुदा टिकट# हैं।',
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
            'एक ईमेल जवाब में विषय के प्रारंभ में पाठ,उदा. RE, AW, या AS।',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'एक ईमेल जवाब में विषय के प्रारंभ में पाठ जब एक ईमेल अग्रेषित किया हैं,उदा. FW, Fwd, या WG। ',
        'The value of the From field' => '',
        'Theme' => 'थीम',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'इस मॉड्यूल और उसके(PreRun) प्रकार्य में क्रियान्वित किया जाएगा,यदि परिभाषित हैं,प्रत्येक अनुरोध के लिए। यह मॉड्यूल उपयोगी है कुछ उपयोगकर्ता की जाँच विकल्प या नये अनुप्रयोगों के बारे में समाचार प्रदर्शित करने के लिए।',
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
        'Ticket Close.' => '',
        'Ticket Compose Bounce Email.' => '',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => '',
        'Ticket Forward Email.' => '',
        'Ticket FreeText.' => '',
        'Ticket History.' => '',
        'Ticket Lock.' => '',
        'Ticket Merge.' => '',
        'Ticket Move.' => '',
        'Ticket Note.' => '',
        'Ticket Notifications' => '',
        'Ticket Outbound Email.' => '',
        'Ticket Overview "Medium" Limit' => 'टिकट अवलोकन "मध्यम" सीमा ',
        'Ticket Overview "Preview" Limit' => 'टिकट अवलोकन "पूर्वावलोकन " सीमा',
        'Ticket Overview "Small" Limit' => 'टिकट अवलोकन "लघु" सीमा ',
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
        'Ticket overview' => 'टिकट अवलोकन ',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => '',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'यदि विचाराधीन स्तिथि निर्धारित कर रहे हैं जो समय सेकंड में हैं वास्तविक समय में जुड जाएगा(तयशुदा:86400=1 दिन)।',
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
        'Unlocked ticket.' => 'अनलॉक।',
        'Up' => 'ऊपर',
        'Upcoming Events' => 'आगामी कार्यक्रम',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'टिकट "देखा है" चिह्नक अद्यतन करें,यदि हर अनुच्छेद देखा लिया है या एक नया अनुच्छेद बनाया है।',
        'Update time' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'टिकट विशेषता अद्यतन के बाद टिकट के संवर्धित सूचकांक को अद्यतन करें।',
        'Updates the ticket index accelerator.' => 'टिकट सूचकांक गतिवर्धक को अद्यतन करें।',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'User Profile' => 'उपयोगकर्ता रूपरेखा',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Users, Groups & Roles' => '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => '',
        'View all attachments of the current ticket' => '',
        'View performance benchmark results.' => 'प्रदर्शन बेंचमार्क परिणाम देखें।',
        'Watch this ticket' => '',
        'Watched Tickets' => 'ध्यानाधीन टिकटें',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => '',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '',
        'Web Services' => '',
        'Web View' => '',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'जब टिकटों को विलय कर रहे हैं, चेक बॉक्स "सूचित प्रेषक" निर्धारित करने के बाद ग्राहक को ईमेल द्वारा सूचित किया जा सकता है। इस पाठ क्षेत्र में,आप एक पूर्व स्वरूपित पाठ परिभाषित कर सकते हैं जो बाद में प्रतिनिधियों द्वारा संशोधित किया जा सकता है। ',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'आपका ईमेल टिकट संख्या "<OTRS_TICKET>" "<OTRS_MERGE_TO_TICKET>" में मिलाया जाता है।',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'Zoom' => 'ज़ूम',
        'attachment' => '',
        'bounce' => '',
        'compose' => '',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'normal' => 'सामान्य',
        'notice' => '',
        'pending' => '',
        'phone' => 'फोन',
        'responsible' => '',
        'reverse' => 'उलटा',
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
