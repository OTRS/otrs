# --
# Copyright (C) 2005 zuowei <j2ee at hirain-sh.com>
# Copyright (C) 2008-2010 Never Min <never at qnofae.org>
# Copyright (C) 2009 Bin Du <bindu2008 at gmail.com>,
# Copyright (C) 2009 Yiye Huang <yiyehuang at gmail.com>
# Copyright (C) 2009 Qingjiu Jia <jiaqj at yahoo.com>
# Copyright (C) 2011 Martin Liu <liuzh66 at gmail.com> http://martinliu.cn
# Copyright (C) 2013 Michael Shi <micshi at 163.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::zh_CN;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y.%M.%D %T';
    $Self->{DateFormatLong}      = ' %A %Y/%M/%D %T';
    $Self->{DateFormatShort}     = '%Y.%M.%D';
    $Self->{DateInputFormat}     = '%Y.%M.%D';
    $Self->{DateInputFormatLong} = '%Y.%M.%D - %T';
    $Self->{Completeness}        = 0.9962749746021;

    # csv separator
    $Self->{Separator}         = '';

    $Self->{DecimalSeparator}  = '.';
    $Self->{ThousandSeparator} = ',';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL管理',
        'Actions' => '操作',
        'Create New ACL' => '创建ACL',
        'Deploy ACLs' => '部署ACL',
        'Export ACLs' => '导出ACL',
        'Filter for ACLs' => 'ACL过滤器',
        'Just start typing to filter...' => '在此输入过滤字符...',
        'Configuration Import' => '配置导入',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '你可以上传配置文件，以便将ACL导入到系统中。配置文件采用.yml格式，它可以从ACL管理模块中导出。',
        'This field is required.' => '该字段是必须的。',
        'Overwrite existing ACLs?' => '覆盖现有的ACL吗？',
        'Upload ACL configuration' => '上传ACL配置',
        'Import ACL configuration(s)' => '导入ACL配置',
        'Description' => '描述',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '为了创建ACL，你可以导入ACL配置或从头创建一个全新的ACL。',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '在这里的任何ACL的修改，仅将其保存在系统中。只有在部署ACL后，它才会起作用。',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '注意：列表中的ACL名称排序顺序决定了ACL的执行顺序。如果需要更改ACL的执行顺序，请修改相应的ACL名称。',
        'ACL name' => 'ACL名称',
        'Comment' => '注释',
        'Validity' => '有效性',
        'Export' => '导出',
        'Copy' => '复制',
        'No data found.' => '没有找到数据。',
        'No matches found.' => '没有找到相匹配的.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '编辑ACL %s',
        'Edit ACL' => '编辑ACL',
        'Go to overview' => '返回概览',
        'Delete ACL' => '删除ACL',
        'Delete Invalid ACL' => '删除无效的ACL',
        'Match settings' => '匹配条件',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '为ACL设置匹配条件。\'Properties\'用于匹配工单在内存中的属性\'，而\'PropertiesDatabase\'用于匹配工单在数据库中的属性。',
        'Change settings' => '操作动作',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '当匹配条件满足时执行规定的操作动作。记住：\'Possible\'表示允许(白名单)，\'PossibleNot\'表示禁止(黑名单)。',
        'Check the official %sdocumentation%s.' => '查看 %s 的官方文档 %s。',
        'Show or hide the content' => '显示或隐藏内容',
        'Edit ACL Information' => '编辑ACL信息',
        'Name' => '名称',
        'Stop after match' => '匹配后停止',
        'Edit ACL Structure' => '编辑ACL结构',
        'Save ACL' => '保存访问控制列表',
        'Save' => '保存',
        'or' => 'or（或）',
        'Save and finish' => '保存并完成',
        'Cancel' => '取消',
        'Do you really want to delete this ACL?' => '您真的想要删除这个ACL吗？',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '通过填写表单数据实现ACL控制。创建ACL后，就可在编辑模式中添加ACL配置信息。',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '日历管理',
        'Add Calendar' => '添加日历',
        'Edit Calendar' => '编辑日历',
        'Calendar Overview' => '日历概览',
        'Add new Calendar' => '添加新的日历',
        'Import Appointments' => '导入预约',
        'Calendar Import' => '日历导入',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '你可以在这里上传一个配置文件来导入一个日历到系统中。这个文件必须是类似通过日历管理模块导出的.yml格式。',
        'Overwrite existing entities' => '覆盖现有条目',
        'Upload calendar configuration' => '上传日历配置',
        'Import Calendar' => '导入日历',
        'Filter for Calendars' => '日历筛选',
        'Filter for calendars' => '日历过滤器',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            '根据组字段，系统通过用户的权限级别来允许用户能够访问的日历。',
        'Read only: users can see and export all appointments in the calendar.' =>
            '只读：用户可以看到和导出日历中所有的预约。',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '转移：用户可以修改日历中的预约，但不能修改选择的日历。',
        'Create: users can create and delete appointments in the calendar.' =>
            '创建：用户可以创建和删除日历中的预约。',
        'Read/write: users can manage the calendar itself.' => '读写：用户可以管理日历。',
        'Group' => '组',
        'Changed' => '修改时间',
        'Created' => '创建时间',
        'Download' => '下载',
        'URL' => '网址',
        'Export calendar' => '导出日历',
        'Download calendar' => '下载日历',
        'Copy public calendar URL' => '复制公共日历网址',
        'Calendar' => '日历',
        'Calendar name' => '日历名称',
        'Calendar with same name already exists.' => '已有同名的日历。',
        'Color' => '颜色',
        'Permission group' => '权限组',
        'Ticket Appointments' => '工单预约',
        'Rule' => '规则',
        'Remove this entry' => '删除该条目',
        'Remove' => '移除',
        'Start date' => '开始时间',
        'End date' => '结束日期',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '使用以下选项缩小能够自动创建工单预约的范围。',
        'Queues' => '队列',
        'Please select a valid queue.' => '请选择一个有效的队列。',
        'Search attributes' => '搜索属性',
        'Add entry' => '添加条目',
        'Add' => '添加',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '定义在这个日历中基于工单数据自动创建预约的规则。',
        'Add Rule' => '添加规则',
        'Submit' => '提交',

        # Template: AdminAppointmentImport
        'Appointment Import' => '预约导入',
        'Go back' => '返回',
        'Uploaded file must be in valid iCal format (.ics).' => '上传文件必须是有效的iCal格式(.ics)。',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '如果此处未列出所需的日历，请确保您至少有“创建”权限。',
        'Upload' => '上传',
        'Update existing appointments?' => '更新已有的预约吗？',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '相同UniqueID的日历中所有已有的预约都会被覆盖。',
        'Upload calendar' => '上传日历',
        'Import appointments' => '导入预约',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '预约通知管理',
        'Add Notification' => '添加通知',
        'Edit Notification' => '编辑通知',
        'Export Notifications' => '导出通知',
        'Filter for Notifications' => '通知过滤器',
        'Filter for notifications' => '通知过滤器',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '在这里你可以上传一个配置文件以便导入预约通知，必须是与预约通知模块导出的文件一样的.yml格式。',
        'Overwrite existing notifications?' => '覆盖现有的通知吗?',
        'Upload Notification configuration' => '上传通知配置',
        'Import Notification configuration' => '导入通知配置',
        'List' => '列表',
        'Delete' => '删除',
        'Delete this notification' => '删除通知',
        'Show in agent preferences' => '在服务人员偏好设置里显示',
        'Agent preferences tooltip' => '服务人员偏好设置提示',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '这个信息将会在服务人员偏好设置屏幕作为这个通知的提示信息显示。',
        'Toggle this widget' => '收起/展开小部件',
        'Events' => 'Events（事件）',
        'Event' => '事件',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '在这里你可以选择哪个事件将会触发这个通知，下面的预约过滤器可以选择符合特定条件的预约。',
        'Appointment Filter' => '预约过滤器',
        'Type' => '类型',
        'Title' => '标题',
        'Location' => '位置',
        'Team' => '团队',
        'Resource' => '资源',
        'Recipients' => '收件人',
        'Send to' => '发送给',
        'Send to these agents' => '发送给服务人员',
        'Send to all group members (agents only)' => '发送给组的所有成员（仅服务人员）',
        'Send to all role members' => '发送给角色的所有成员',
        'Send on out of office' => '不在办公室也发送',
        'Also send if the user is currently out of office.' => '用户设置了不在办公室时仍然发送。',
        'Once per day' => '一天一次',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '每个预约的通知使用选择的方式一天只发送一次。',
        'Notification Methods' => '通知方法',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '这里有几种发送给收件人的方法，请至少选择下面的一种方法。',
        'Enable this notification method' => '启用这个通知方法',
        'Transport' => '传输',
        'At least one method is needed per notification.' => '每个通知至少需要一种方法。',
        'Active by default in agent preferences' => '在服务人员偏好设置中默认激活',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '如果选中这个复选框，即使分配为收件人的服务人员在偏好设置中没有选择接收这个通知，这个通知仍然会发送给该服务人员。',
        'This feature is currently not available.' => '该功能当前不可用。',
        'Upgrade to %s' => '升级到 %s',
        'Please activate this transport in order to use it.' => '请激活此传输方式以使用它。',
        'No data found' => '没有找到数据',
        'No notification method found.' => '没有找到通知方法。',
        'Notification Text' => '通知内容',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '系统中没有或者没有启用这个语言，不需要时可以将通知内容删除。',
        'Remove Notification Language' => '删除通知语言',
        'Subject' => '主题',
        'Text' => '文本',
        'Message body' => '消息正文',
        'Add new notification language' => '添加通知语言',
        'Save Changes' => '保存更改',
        'Tag Reference' => '标签参考',
        'Notifications are sent to an agent.' => '发送给服务人员的通知。',
        'You can use the following tags' => '你可以使用以下的标记',
        'To get the first 20 character of the appointment title.' => '获取预约的前20个字符。',
        'To get the appointment attribute' => '获取预约的属性',
        ' e. g.' => ' 例如：',
        'To get the calendar attribute' => '获取日历的属性',
        'Attributes of the recipient user for the notification' => '通知收件人的属性',
        'Config options' => '系统配置数据',
        'Example notification' => '通知样例',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '额外的收件人邮件地址',
        'This field must have less then 200 characters.' => '这个字段不能超过200个字符。',
        'Article visible for customer' => '信件对客户的可见性',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '如果通知发送给客户或额外的邮件地址时创建一封信件。',
        'Email template' => '邮件模板',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '使用这个模板生成完整的邮件（仅对HTML邮件）。',
        'Enable email security' => '启用电子邮件安全',
        'Email security level' => '电子邮件安全级别',
        'If signing key/certificate is missing' => '如果签名密钥/证书丢失了',
        'If encryption key/certificate is missing' => '如果加密密钥/证书丢失了',

        # Template: AdminAttachment
        'Attachment Management' => '附件管理',
        'Add Attachment' => '添加附件',
        'Edit Attachment' => '编辑附件',
        'Filter for Attachments' => '附件过滤器',
        'Filter for attachments' => '附件过滤器',
        'Filename' => '文件名',
        'Download file' => '下载文件',
        'Delete this attachment' => '删除附件',
        'Do you really want to delete this attachment?' => '你是否确定要删除该附件？',
        'Attachment' => '附件',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自动响应管理',
        'Add Auto Response' => '添加自动响应',
        'Edit Auto Response' => '编辑自动响应',
        'Filter for Auto Responses' => '自动响应过滤器',
        'Filter for auto responses' => '自动响应过滤器',
        'Response' => '回复内容',
        'Auto response from' => '自动响应的发件人',
        'Reference' => 'ACL设置参考',
        'To get the first 20 character of the subject.' => '获取主题的前20个字符。',
        'To get the first 5 lines of the email.' => '获取邮件的前五行。',
        'To get the name of the ticket\'s customer user (if given).' => '获取工单的客户用户名字（如果有）。',
        'To get the article attribute' => '获取邮件的属性信息',
        'Options of the current customer user data' => '客户用户资料属性',
        'Ticket owner options' => '工单所有者属性',
        'Ticket responsible options' => '工单负责人属性',
        'Options of the current user who requested this action' => '工单提交者的属性',
        'Options of the ticket data' => '工单数据属性',
        'Options of ticket dynamic fields internal key values' => '工单动态字段内部键值',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '动态字段显示名称，用于下拉选择和复选框',
        'Example response' => '自动响应样例',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '云服务管理',
        'Support Data Collector' => '支持数据收集工具',
        'Support data collector' => '支持数据收集工具',
        'Hint' => '提示',
        'Currently support data is only shown in this system.' => '当前的支持数据只是在系统中显示。',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '极力推荐将支持数据发送给OTRS集团以便获得更好的支持。',
        'Configuration' => '配置',
        'Send support data' => '发送支持数据',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '允许系统发送额外的支持数据信息给OTRS集团。',
        'Update' => '更新',
        'System Registration' => '系统注册',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '为了启用数据发送功能，请将您的系统注册到OTRS集团或更新您的注册信息（确保激活了“发送支持数据”选项。）',
        'Register this System' => '注册本系统',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '本系统的系统注册功能已被禁用，请检查你的配置。',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '系统注册是OTRS集团的一项服务，它为您提供了很多好处!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            '请注意：为了使用OTRS云服务，需要先注册系统。',
        'Register this system' => '注册本系统',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '你可以在这里配置可用的云服务，其与%s的通信是安全的。',
        'Available Cloud Services' => '可用的云服务',

        # Template: AdminCommunicationLog
        'Communication Log' => '通信日志',
        'Time Range' => '时间范围',
        'Show only communication logs created in specific time range.' =>
            '仅显示指定时间范围内创建的通信日志。',
        'Filter for Communications' => '交互筛选',
        'Filter for communications' => '通信过滤器',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '在此屏幕中，你可以看到有关传入和外发通信的概览。',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '你可以通过单击列标题来更改列的排序和顺序。',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '如果你点击不同的条目，你将被重定向到关于此消息的详情屏幕。',
        'Status for: %s' => '%s的状态',
        'Failing accounts' => '失败的帐户',
        'Some account problems' => '一些帐户问题',
        'No account problems' => '没有帐户问题',
        'No account activity' => '没有帐户活动',
        'Number of accounts with problems: %s' => '问题帐户的数量：%s',
        'Number of accounts with warnings: %s' => '报警帐户的数量：%s',
        'Failing communications' => '失败的通信',
        'No communication problems' => '没有通信问题',
        'No communication logs' => '没有通信日志',
        'Number of reported problems: %s' => '报告的问题的数量：%s',
        'Open communications' => '处理通信',
        'No active communications' => '没有活动的通信',
        'Number of open communications: %s' => '处理通信的数量：%s',
        'Average processing time' => '平均处理时间',
        'List of communications (%s)' => '通信清单（%s）',
        'Settings' => '设置',
        'Entries per page' => '每页条目数',
        'No communications found.' => '没有找到通信。',
        '%s s' => '%s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '帐户状态',
        'Back to overview' => '返回总览界面',
        'Filter for Accounts' => '账号筛选',
        'Filter for accounts' => '帐户过滤器',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '你可以通过单击列标题来更改列的排序和顺序。',
        'Account status for: %s' => '%s的帐户状态',
        'Status' => '状态',
        'Account' => '帐户',
        'Edit' => '编辑',
        'No accounts found.' => '没有找到帐户。',
        'Communication Log Details (%s)' => '通信日志详情（%s）',
        'Direction' => '方向',
        'Start Time' => '开始时间',
        'End Time' => '结束时间',
        'No communication log entries found.' => '没有找到通信日志条目。',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '持续',

        # Template: AdminCommunicationLogObjectLog
        '#' => '序号',
        'Priority' => '优先级',
        'Module' => 'Module（模块）',
        'Information' => '信息',
        'No log entries found.' => '没有找到日志条目。',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '通信%s的详情视图开始于%s',
        'Filter for Log Entries' => '日志条目过滤器',
        'Filter for log entries' => '日志条目过滤器',
        'Show only entries with specific priority and higher:' => '仅显示具有特定和更高优先级的条目：',
        'Communication Log Overview (%s)' => '通信日志概览（%s）',
        'No communication objects found.' => '没有找到通信目标。',
        'Communication Log Details' => '通信日志详情',
        'Please select an entry from the list.' => '请从列表中选择一个条目。',

        # Template: AdminCustomerCompany
        'Customer Management' => '客户管理',
        'Add Customer' => '添加客户',
        'Edit Customer' => '编辑客户',
        'Search' => '搜索',
        'Wildcards like \'*\' are allowed.' => '允许使用通配置符，例如\'*\'。',
        'Select' => '选择',
        'List (only %s shown - more available)' => '列表 (目前显示%s-显示更多)',
        'total' => '总共',
        'Please enter a search term to look for customers.' => '请输入搜索条件以便检索客户资料.',
        'Customer ID' => '客户ID',
        'Please note' => '请注意',
        'This customer backend is read only!' => '客户后端是只读的！',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => '管理客户与组的关系',
        'Notice' => 'Notice（注意）',
        'This feature is disabled!' => '该功能已关闭！',
        'Just use this feature if you want to define group permissions for customers.' =>
            '该功能用于为客户定义权限组。',
        'Enable it here!' => '在这里启用！',
        'Edit Customer Default Groups' => '定义客户的默认组',
        'These groups are automatically assigned to all customers.' => '默认组会自动分配给所有客户。',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '你可能通过配置设置"CustomerGroupCompanyAlwaysGroups"管理这些组。',
        'Filter for Groups' => '组过滤器',
        'Select the customer:group permissions.' => '选择客户:组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '如果没有选择，就不具备该组的任何权限 (客户不能创建或读取工单)。',
        'Search Results' => '搜索结果',
        'Customers' => '客户',
        'Groups' => '组',
        'Change Group Relations for Customer' => '此客户属于哪些组',
        'Change Customer Relations for Group' => '哪些客户属于此组',
        'Toggle %s Permission for all' => '全部授予/取消 %s 权限',
        'Toggle %s permission for %s' => '授予/取消 %s 权限给 %s',
        'Customer Default Groups:' => '客户的默认组:',
        'No changes can be made to these groups.' => '不能更改默认组.',
        'ro' => 'ro（只读）',
        'Read only access to the ticket in this group/queue.' => '对于组/队列中的工单具有 \'只读\'权限。',
        'rw' => 'rw（读写）',
        'Full read and write access to the tickets in this group/queue.' =>
            '对于组/队列中的工单具有完整的\'读写\'权限。',

        # Template: AdminCustomerUser
        'Customer User Management' => '客户用户管理',
        'Add Customer User' => '添加客户用户',
        'Edit Customer User' => '编辑客户用户',
        'Back to search results' => '返回到搜索结果',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '工单的客户历史信息需要有客户用户，客户界面登录也需要用客户用户。',
        'List (%s total)' => '列表（总共 %s）',
        'Username' => '用户名',
        'Email' => '邮件地址',
        'Last Login' => '上次登录时间',
        'Login as' => '登陆客户门户',
        'Switch to customer' => '切换到客户',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '这个客户后端是只读的，但可以修改客户的用户首选项！',
        'This field is required and needs to be a valid email address.' =>
            '必须输入有效的邮件地址。',
        'This email address is not allowed due to the system configuration.' =>
            '邮件地址不符合系统配置要求。',
        'This email address failed MX check.' => '该邮件域名的MX记录检查无效。',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS问题，请检查你的配置和错误日志文件。',
        'The syntax of this email address is incorrect.' => '该邮件地址语法错误。',
        'This CustomerID is invalid.' => '这个客户ID是无效的。',
        'Effective Permissions for Customer User' => '客户用户的有效权限',
        'Group Permissions' => '组权限',
        'This customer user has no group permissions.' => '这个客户用户没有组权限。',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '上表显示了客户用户的有效组权限，这个矩阵考虑了所有继承的权限（例如通过客户组）。 注意：此表没有考虑对此表单做了更改但没有提交的内容。',
        'Customer Access' => '客户访问',
        'Customer' => '客户',
        'This customer user has no customer access.' => '这个客户用户没有客户访问权限。',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '上表显示了通过权限上下文为客户用户授予的客户访问权限。该矩阵考虑了所有继承的访问权限（例如通过客户组）。注意：此表没有考虑对此表单做了更改但没有提交的内容。',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '管理客户用户和客户的关联',
        'Select the customer user:customer relations.' => '选择客户用户关联的客户。',
        'Customer Users' => '客户用户',
        'Change Customer Relations for Customer User' => '修改客户用户和客户的关联',
        'Change Customer User Relations for Customer' => '修改客户关联的用户',
        'Toggle active state for all' => '全部激活/不激活状态',
        'Active' => 'Active（活动的）',
        'Toggle active state for %s' => '%s 激活/不激活状态',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '管理客户用户与组的关系',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '如果要为客户用户定义组权限，请使用此功能。',
        'Edit Customer User Default Groups' => '编辑客户用户的默认组',
        'These groups are automatically assigned to all customer users.' =>
            '这些组自动分配给所有的客户用户。',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '你可能通过配置参数"CustomerGroupAlwaysGroups"定义默认组。',
        'Filter for groups' => '群组筛选',
        'Select the customer user - group permissions.' => '选择客户用户和组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '如果没有选择，就不具备该组的任何权限 (客户用户不能使用工单)。',
        'Customer User Default Groups:' => '客户用户的默认组：',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '管理客户-服务之间的联系',
        'Edit default services' => '修改默认服务',
        'Filter for Services' => '服务过滤器',
        'Filter for services' => '服务过滤器',
        'Services' => '服务',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '动态字段管理',
        'Add new field for object' => '为对象添加新的字段',
        'Filter for Dynamic Fields' => '动态字段过滤器',
        'Filter for dynamic fields' => '动态字段过滤器',
        'More Business Fields' => '更多商业版字段',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '您想要从商业版的额外动态字段类型中受益吗？ 升级到%s以访问以下字段类型：',
        'Database' => '数据库',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '使用外部数据库作为此动态字段的可配置数据源。',
        'Web service' => 'Web服务',
        'External web services can be configured as data sources for this dynamic field.' =>
            '外部Web服务可以配置为该动态字段的数据源。',
        'Contact with data' => '连接数据',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '此功能允许将（多个）联系人信息添加到工单中。',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '为了增加一个新的字段，从对象列表中选择一个字段类型，对象定义了字段的范围并且不能在创建后修改。',
        'Dynamic Fields List' => '动态字段列表',
        'Dynamic fields per page' => '每页动态字段个数',
        'Label' => '标签',
        'Order' => '订单',
        'Object' => '对象',
        'Delete this field' => '删除这个字段',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '动态字段',
        'Go back to overview' => '返回概览',
        'General' => '一般',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '这个字段是必需的，且它的值只能是字母和数字。',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '必须是唯一的且只接受字母和数字字符。',
        'Changing this value will require manual changes in the system.' =>
            '更改此值需要在系统中进行手动更改。',
        'This is the name to be shown on the screens where the field is active.' =>
            '这是在激活了该字段的屏幕上显示的名称。',
        'Field order' => '字段顺序',
        'This field is required and must be numeric.' => '这个字段是必需的且必须是数字。',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '这是在激活了该字段的屏幕上显示的顺序。',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '不可能使此条目无效，所有配置设置都必须事先更改。',
        'Field type' => '字段类型',
        'Object type' => '对象类型',
        'Internal field' => '内置字段',
        'This field is protected and can\'t be deleted.' => '这是内置字段，不能删除它。',
        'This dynamic field is used in the following config settings:' =>
            '这个动态字段已用于以下配置设置中：',
        'Field Settings' => '字段设置',
        'Default value' => '默认值',
        'This is the default value for this field.' => '这是该字段的默认值。',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '默认的日期差',
        'This field must be numeric.' => '此字段必须是数字。',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '使用与“此刻”的时差(秒)计算默认值(例如，3600或-60)。',
        'Define years period' => '定义年期',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '激活此选项来定义固定的年份范围(过去的和未来的), 用于显示在此字段的年份中.',
        'Years in the past' => '过去的年数',
        'Years in the past to display (default: 5 years).' => '显示过去的年份 (默认: 5年)。',
        'Years in the future' => '未来的几年',
        'Years in the future to display (default: 5 years).' => '显示未来的年份 (默认: 5年)。',
        'Show link' => '显示链接',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '可以为字段值指定一个可选的HTTP链接，以便其显示在工单概览和工单详情中。',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '如果不应编码特殊字符（&、@、 :、 / 等），请使用“url”代替“uri”过滤器。',
        'Example' => '样例',
        'Link for preview' => '连接预览',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '如果填写了内容，在工单详情屏幕中当鼠标移动到这个URL上方时将显示URL的预览。请注意：要使这个功能生效，还需要上面的常规URL字段也填写好了内容。',
        'Restrict entering of dates' => '限制输入日期',
        'Here you can restrict the entering of dates of tickets.' => '在这里可以限制输入工单日期。',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '可能值',
        'Key' => '键',
        'Value' => '值',
        'Remove value' => '删除值',
        'Add value' => '添加值',
        'Add Value' => '添加值',
        'Add empty value' => '添加空值',
        'Activate this option to create an empty selectable value.' => '激活此选项, 创建可选择的空值.',
        'Tree View' => '树形视图',
        'Activate this option to display values as a tree.' => '激活此选项，将以树状形式显示值。',
        'Translatable values' => '可翻译的值',
        'If you activate this option the values will be translated to the user defined language.' =>
            '如果激活此选项，这些值将被转换为用户定义的语言。',
        'Note' => '备注',
        'You need to add the translations manually into the language translation files.' =>
            '您需要将翻译手动添加到语言翻译文件中。',

        # Template: AdminDynamicFieldText
        'Number of rows' => '行数',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '在编辑模式中指定此字段的高度（行）。',
        'Number of cols' => '列宽',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '定义编辑屏幕的列宽（单位：字符）。',
        'Check RegEx' => '正则表达式检查',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '您可以在这里指定一个正则表达式来检查值是否符合要求，正则表达式将在编辑器的扩展内存中执行。',
        'RegEx' => '正则表达式',
        'Invalid RegEx' => '无效的正则表达式',
        'Error Message' => '错误消息',
        'Add RegEx' => '添加正则表达式',

        # Template: AdminEmail
        'Admin Message' => '管理消息',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '通过此模块，管理员可以给服务人员、组或角色发送消息。',
        'Create Administrative Message' => '创建管理员通知',
        'Your message was sent to' => '你的信息已被发送到',
        'From' => '发件人',
        'Send message to users' => '发送信息给注册用户',
        'Send message to group members' => '发送信息到组成员',
        'Group members need to have permission' => '组成员需要权限',
        'Send message to role members' => '发送信息到角色成员',
        'Also send to customers in groups' => '同样发送到该组的客户',
        'Body' => '内容',
        'Send' => '发送',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '自动任务管理',
        'Edit Job' => '编辑任务',
        'Add Job' => '添加任务',
        'Run Job' => '运行任务',
        'Filter for Jobs' => '任务筛选',
        'Filter for jobs' => '任务筛选',
        'Last run' => '最后运行',
        'Run Now!' => '现在运行!',
        'Delete this task' => '删除这个任务',
        'Run this task' => '执行这个任务',
        'Job Settings' => '任务设置',
        'Job name' => '任务名称',
        'The name you entered already exists.' => '你输入的名称已经存在。',
        'Automatic Execution (Multiple Tickets)' => '自动执行(针对多个工单)',
        'Execution Schedule' => '执行计划',
        'Schedule minutes' => '计划的分钟',
        'Schedule hours' => '计划的小时',
        'Schedule days' => '计划的天',
        'Automatic execution values are in the system timezone.' => '自动执行时间在系统时区中的值。',
        'Currently this generic agent job will not run automatically.' =>
            '目前这个自动任务不会自动运行。',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '若要启用自动执行，则需指定执行的分钟、小时和天！',
        'Event Based Execution (Single Ticket)' => '基于事件执行(针对特定工单)',
        'Event Triggers' => '事件触发器',
        'List of all configured events' => '配置的事件列表',
        'Delete this event' => '删除这个事件',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '作为定期自动执行的补充或替代，您可以定义工单事件来触发这个任务的执行。',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '如果工单事件被触发，工单过滤器将对工单进行检查看其条件是否匹配。任务只对匹配的工单发生作用。',
        'Do you really want to delete this event trigger?' => '您真的想要删除这个事件触发器吗？',
        'Add Event Trigger' => '添加事件触发器',
        'To add a new event select the event object and event name' => '要添加新事件，请选择事件对象和事件名称',
        'Select Tickets' => '选择工单',
        '(e. g. 10*5155 or 105658*)' => '（例如: 10*5144 或者 105658*）',
        '(e. g. 234321)' => '（例如: 234321）',
        'Customer user ID' => '客户用户ID',
        '(e. g. U5150)' => '（例如: U5150）',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '在信件中全文检索（例如："Mar*in" or "Baue*"）。',
        'To' => '收件人',
        'Cc' => '抄送',
        'Service' => '服务',
        'Service Level Agreement' => '服务级别协议',
        'Queue' => '队列',
        'State' => '状态',
        'Agent' => '服务人员',
        'Owner' => '所有者',
        'Responsible' => '负责人',
        'Ticket lock' => '工单锁定',
        'Dynamic fields' => '动态字段',
        'Add dynamic field' => '添加动态字段',
        'Create times' => '创建时间',
        'No create time settings.' => '没有创建时间。',
        'Ticket created' => '工单创建时间',
        'Ticket created between' => '工单创建时间（在...之间）',
        'and' => 'and（与）',
        'Last changed times' => '最后修改时间',
        'No last changed time settings.' => '没有最后修改时间设置。',
        'Ticket last changed' => '工单最后修改',
        'Ticket last changed between' => '工单最后修改时间（在...之间）',
        'Change times' => '修改时间',
        'No change time settings.' => '没有修改时间设置。',
        'Ticket changed' => '工单修改时间',
        'Ticket changed between' => '工单修改时间（在...之间）',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => '关闭时间',
        'No close time settings.' => '没有关闭时间设置。',
        'Ticket closed' => '工单关闭时间',
        'Ticket closed between' => '工单关闭时间（在...之间）',
        'Pending times' => '挂起时间',
        'No pending time settings.' => '没有挂起时间设置。',
        'Ticket pending time reached' => '工单挂起时间已到',
        'Ticket pending time reached between' => '工单挂起时间（在...之间）',
        'Escalation times' => '升级时间',
        'No escalation time settings.' => '没有升级时间设置。',
        'Ticket escalation time reached' => '工单升级时间已到',
        'Ticket escalation time reached between' => '工单升级时间（在...之间）',
        'Escalation - first response time' => '升级 - 首次响应时间',
        'Ticket first response time reached' => '工单升级 - 首次响应时间已到',
        'Ticket first response time reached between' => '工单升级 - 首次响应时间（在...之间）',
        'Escalation - update time' => '升级 - 更新时间',
        'Ticket update time reached' => '工单升级 - 更新时间已到',
        'Ticket update time reached between' => '工单升级 - 更新时间（在...之间）',
        'Escalation - solution time' => '升级 - 解决时间',
        'Ticket solution time reached' => '工单升级 - 解决时间已到',
        'Ticket solution time reached between' => '工单升级 - 解决时间（在...之间）',
        'Archive search option' => '归档搜索选项',
        'Update/Add Ticket Attributes' => '更新/添加工单属性',
        'Set new service' => '设置新服务',
        'Set new Service Level Agreement' => '设置新的服务级别协议',
        'Set new priority' => '设置新的优先级',
        'Set new queue' => '设置新的队列',
        'Set new state' => '设置新的状态',
        'Pending date' => '挂起时间',
        'Set new agent' => '设置新的服务人员',
        'new owner' => '指定所有者',
        'new responsible' => '指定负责人',
        'Set new ticket lock' => '工单锁定',
        'New customer user ID' => '新建客户用户ID',
        'New customer ID' => '指定客户ID',
        'New title' => '指定标题',
        'New type' => '指定类型',
        'Archive selected tickets' => '归档选中的工单',
        'Add Note' => '添加备注',
        'Visible for customer' => '对客户的可见性',
        'Time units' => '时间单元',
        'Execute Ticket Commands' => '执行工单指令',
        'Send agent/customer notifications on changes' => '给服务人员/客户发送通知',
        'CMD' => '命令',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            '将执行这个命令, 第一个参数是工单编号，第二个参数是工单ID。',
        'Delete tickets' => '删除工单',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '警告：所有影响的工单将从数据库删除，且无法恢复！',
        'Execute Custom Module' => '执行定制模块',
        'Param %s key' => '参数 %s 的键',
        'Param %s value' => '参数 %s 的值',
        'Results' => '结果',
        '%s Tickets affected! What do you want to do?' => '%s 个工单将被影响！你确定要这么做?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告：你选择了"删除"指令，所有删除的工单都将丢失，无法恢复！',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '警告：%s 个工单将被影响，但一个任务执行时只能修改 %s 个工单！',
        'Affected Tickets' => '受影响的工单',
        'Age' => '总时长',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => '通用接口Web服务管理',
        'Web Service Management' => '管理WEB服务',
        'Debugger' => '调试器',
        'Go back to web service' => '返回到Web服务',
        'Clear' => '清空',
        'Do you really want to clear the debug log of this web service?' =>
            '您真的想要清空该Web服务的调试日志吗？',
        'Request List' => '请求列表',
        'Time' => '时间',
        'Communication ID' => '通信ID',
        'Remote IP' => '远程IP',
        'Loading' => '正在加载',
        'Select a single request to see its details.' => '选择一个请求，以便查看其详细信息。',
        'Filter by type' => '按类型过滤',
        'Filter from' => '按日期过滤(从)',
        'Filter to' => '按日期过滤(到)',
        'Filter by remote IP' => '按远程IP过滤',
        'Limit' => '限制',
        'Refresh' => '刷新',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '添加错误处理',
        'Edit ErrorHandling' => '编辑错误处理',
        'Do you really want to delete this error handling module?' => '你确定要删除这个错误处理模块吗?',
        'All configuration data will be lost.' => '所有配置数据将丢失。',
        'General options' => '一般选项',
        'The name can be used to distinguish different error handling configurations.' =>
            '该名称可用于区分不同的错误处理配置。',
        'Please provide a unique name for this web service.' => '请为这个Web服务提供一个唯一的名称。',
        'Error handling module backend' => '错误处理模块后端',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            '这个OTRS错误处理后端模块将被内部调用以处理错误处理机制。',
        'Processing options' => '处理选项',
        'Configure filters to control error handling module execution.' =>
            '配置过滤器来控制错误处理模块执行。',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '只有匹配所有配置的过滤器（如果有的话）的请求将触发模块执行。',
        'Operation filter' => '操作过滤器',
        'Only execute error handling module for selected operations.' => '只对选定的操作执行错误处理模块。',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '注意：接收传入请求数据时发生错误，操作未确定。 涉及此错误阶段的过滤器不应使用操作过滤器。',
        'Invoker filter' => '调用程序过滤器',
        'Only execute error handling module for selected invokers.' => '只对选定的调用程序执行错误处理模块。',
        'Error message content filter' => '错误消息内容过滤器',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '输入一个正则表达式来限制哪些错误消息应导致错误处理模块执行。',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '将考虑匹配错误消息主题和数据（如调试器错误条目中所示）。',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '示例：输入\'^.*401 Unauthorized.*\$\' ，仅处理与认证相关的错误。',
        'Error stage filter' => '错误阶段过滤器',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '只对特定处理阶段发生的错误执行错误处理模块。',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '示例：仅处理无法应用传出数据映射的错误。',
        'Error code' => '错误代码',
        'An error identifier for this error handling module.' => '该错误处理模块的错误标识符。',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '此标识符将在XSLT映射中可用，并在调试器输出中显示。',
        'Error message' => '错误消息',
        'An error explanation for this error handling module.' => '该错误处理模块的错误说明。',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '此消息将在XSLT映射中可用，并在调试器输出中显示。',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '定义在执行模块后是否应该停止处理，跳过所有剩余的模块，或者只跳过同一个后端的模块。',
        'Default behavior is to resume, processing the next module.' => '默认行为是恢复，处理下一个模块。',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '此模块允许配置失败请求的安排重试次数。',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '通用接口Web服务的默认行为是每个请求仅发送一次，在错误后不再安排发送。',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '如果针对个别请求执行多个能够计划重试的模块，则最后执行的模块是权威性的，并确定是否安排重试。',
        'Request retry options' => '请求重试选项',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '当请求导致错误处理模块执行（基于处理选项）时，将应用重试选项。',
        'Schedule retry' => '安排重试',
        'Should requests causing an error be triggered again at a later time?' =>
            '是否应该在稍后的时间再次触发引起错误的请求？',
        'Initial retry interval' => '初始重试间隔',
        'Interval after which to trigger the first retry.' => '间隔之后触发第一次重试。',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '注意：本次及后期所有的重试间隔都基于初始请求的错误处理模块的执行时间。',
        'Factor for further retries' => '进一步重试的因子',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '如果请求在第一次重试后仍然返回错误，定义是使用相同的间隔时间还是增加间隔时间来触发后续重试。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '示例：如果一个请求的初始间隔为“1分钟”、重试因子为“2”，初始触发在10:00，重试将触发在10:01（1分钟），10:03（2 * 1 = 2 分钟），10:07（2 * 2 = 4分钟），10:15（2 * 4 = 8分钟），...',
        'Maximum retry interval' => '最大重试间隔',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '如果选择重试间隔因子“1.5”或“2”，则可以通过定义允许的最大间隔时间来防止不期望的长间隔时间。',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '计算出超过最大重试间隔的间隔将自动相应缩短。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '示例：示例：如果一个请求的初始时间间隔为“1分钟”，重试因子为“2”，最大间隔为“5分钟”，初始触发在10:00，重试将触发在10:01（1分钟），10 ：03（2分钟），10:07（4分钟），10:12（8 => 5分钟），10:17，...',
        'Maximum retry count' => '最大重试次数',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '失败请求被丢弃之前的最大重试次数，不计入初始请求。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '示例：如果一个请求的初始时间间隔为“1分钟”，重试因子为“2”，最大重试次数为“2”，初始触发在10:00，将仅在10:01和10:03触发重试。',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '注意：如果配置了最大重试时间并且较早到达，则可能无法达到最大重试次数。',
        'This field must be empty or contain a positive number.' => '此字段必须为空或包含正数。',
        'Maximum retry period' => '最大重试时间',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '在丢弃失败请求之前重试的最长时间（基于初始请求的错误处理模块执行时间）。',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '在最大时间段之后正常触发的重试（根据重试间隔计算）将在最大时间段到达时自动触发一次。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '示例：如果一个请求的初始间隔为“1分钟”、重试因子为“2”、最大重试时间为“30分钟”，初始触发在10:00，重试将触发在10:01、10:03、10:07、10:15，最后在10：31 => 10:30触发一次。',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '注意：如果配置了最大重试次数并且较早到达，则可能无法达到最大重试时间。',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '添加调用程序',
        'Edit Invoker' => '编辑调用程序',
        'Do you really want to delete this invoker?' => '您真的想要删除这个调用程序吗？',
        'Invoker Details' => '调用程序详情',
        'The name is typically used to call up an operation of a remote web service.' =>
            '该名称通常用于调用远程Web服务的操作。',
        'Invoker backend' => '调用程序后端',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '这个OTRS调用程序后端模块被调用后，负责准备需要发送给远程系统的数据，并处理它的响应数据。',
        'Mapping for outgoing request data' => '映射出站请求数据',
        'Configure' => '配置',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '这个映射将对OTRS调用程序输出的数据进行处理，将它转换为远程系统所期待的数据。',
        'Mapping for incoming response data' => '映射入站请求数据',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '这个映射将对响应数据进行处理，将它转换为OTRS调用程序所期待的数据。',
        'Asynchronous' => '异步',
        'Condition' => '条件',
        'Edit this event' => '编辑这个事件',
        'This invoker will be triggered by the configured events.' => '配置事件将触发这个调用程序。',
        'Add Event' => '添加事件',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '要添加新事件，请选择事件对象和事件名称，然后单击“+”按钮',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '异步的事件触发器将由后端的OTRS调度程序守护进程处理（推荐）。',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '同步的事件触发器则是在web请求期间直接处理的。',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'Web服务%s的通用接口调用程序事件设置',
        'Go back to' => '返回到',
        'Delete all conditions' => '删除所有条件',
        'Do you really want to delete all the conditions for this event?' =>
            '你确定要删除这个事件的所有条件吗？',
        'General Settings' => '常规设置',
        'Event type' => '事件类型',
        'Conditions' => '条件',
        'Conditions can only operate on non-empty fields.' => '条件只能作用于非空字段。',
        'Type of Linking between Conditions' => '条件之间的逻辑关系',
        'Remove this Condition' => '删除这个条件',
        'Type of Linking' => '链接关系',
        'Fields' => '字段',
        'Add a new Field' => '添加新的字段',
        'Remove this Field' => '删除这个字段',
        'And can\'t be repeated on the same condition.' => '同一条件中不能对相同字段使用“和”关系。',
        'Add New Condition' => '添加新的条件',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => '简单映射',
        'Default rule for unmapped keys' => '未映射键的默认规则',
        'This rule will apply for all keys with no mapping rule.' => '这个规则将应用于所有没有映射规则的键。',
        'Default rule for unmapped values' => '未映射值的默认规则',
        'This rule will apply for all values with no mapping rule.' => '这个规则将应用于所有没有映射规则的值。',
        'New key map' => '新的键映射',
        'Add key mapping' => '添加键映射',
        'Mapping for Key ' => '键的映射 ',
        'Remove key mapping' => '删除键映射',
        'Key mapping' => '键映射',
        'Map key' => '映射键',
        'matching the' => '将匹配的',
        'to new key' => '映射到新键',
        'Value mapping' => '值映射',
        'Map value' => '映射值',
        'to new value' => '映射到新值',
        'Remove value mapping' => '删除值映射',
        'New value map' => '新的值映射',
        'Add value mapping' => '添加值映射',
        'Do you really want to delete this key mapping?' => '您真的想要删除这个键映射吗？',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '通用快捷键',
        'MacOS Shortcuts' => 'MacOS快捷键',
        'Comment code' => '注释代码',
        'Uncomment code' => '取消注释',
        'Auto format code' => '自动格式化代码',
        'Expand/Collapse code block' => '展开/收起代码块',
        'Find' => '查找',
        'Find next' => '查找下一个',
        'Find previous' => '查找上一个',
        'Find and replace' => '查找并替换',
        'Find and replace all' => '查找并替换所有',
        'XSLT Mapping' => 'XSLT映射',
        'XSLT stylesheet' => 'XSLT样式表',
        'The entered data is not a valid XSLT style sheet.' => '输入的数据不是有效的XSLT样式表。',
        'Here you can add or modify your XSLT mapping code.' => '您可以在此添加或修改XSLT映射代码。',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '编辑字段允许您使用不同的功能，如自动格式化、窗口调整大小以及标签和括号补齐。',
        'Data includes' => '数据包括',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '选择在早期请求/响应阶段创建的一组或多组要包含在可映射数据中的数据集合。',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '这些数据集合将出现在 \'/DataInclude/<DataSetName>\'的数据结构中（有关详细信息，请参阅实际请求的调试器输出）。',
        'Data key regex filters (before mapping)' => '数据键正则表达式过滤器（映射之前）',
        'Data key regex filters (after mapping)' => '数据键正则表达式过滤器（映射之后）',
        'Regular expressions' => '正则表达式',
        'Replace' => '替换',
        'Remove regex' => '移除正则表达式',
        'Add regex' => '添加正则表达式',
        'These filters can be used to transform keys using regular expressions.' =>
            '这些过滤器可用于使用正则表达式转换键。',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '数据结构将递归遍历，所有配置的正则表达式都将应用于所有键。',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '使用案例：例如删除不需要的键前缀或纠正作为XML元素名称无效的键。',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '示例1：搜索= \'^jira:\'/替换= \'\' ，可将 \'jira:element\' 变成\'element\'。',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '示例2：搜索 = \'^\' / 替换 = \'_\' ，可将\'16x16\' 变成\'_16x16\'。',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '示例3：搜索= \'^(?<number>\d+) (?<text>.+?)\$\' / 替换= \'_\$+{text}_\$+{number}\'，可将 \'16 elementname\' 变成 \'_elementname_16\'。',
        'For information about regular expressions in Perl please see here:' =>
            '有关Perl中正则表达式的信息，请参见：',
        'Perl regular expressions tutorial' => 'Perl正则表达式教程',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '如果需要修饰符，则必须在正则表达式中指定它们。',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '这里定义的正则表达式将在XSLT映射之前应用。',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '这里定义的正则表达式将在XSLT映射之后应用。',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '添加操作',
        'Edit Operation' => '编辑操作',
        'Do you really want to delete this operation?' => '您真的想要删除这个操作吗？',
        'Operation Details' => '操作详情',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '这个名称通常用于从一个远程系统调用这个web服务操作。',
        'Operation backend' => '操作后端',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '这个OTRS操作后端模块将被调用，以便处理请求、生成响应数据。',
        'Mapping for incoming request data' => '映射传入请求数据',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '这个映射将对请求数据进行处理，将它转换为OTRS所期待的数据。',
        'Mapping for outgoing response data' => '映射出站响应数据',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '这个映射将对响应数据进行处理，以便将它转换成远程系统所期待的数据。',
        'Include Ticket Data' => '包含工单数据',
        'Include ticket data in response.' => '在响应中包含工单数据。',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '网络传输',
        'Properties' => '属性',
        'Route mapping for Operation' => '为操作路由映射',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '为这个操作定义获取映射的路由。以“:“作为标记的变量将得到输入名称和其它传递参数的映射。',
        'Valid request methods for Operation' => '操作的有效请求方法',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '限制这个操作使用指定的请求方法。如果没有选择方法，则所有的请求都可以接受。',
        'Maximum message length' => '消息的最大长度',
        'This field should be an integer number.' => '这个字段值应该是一个整数。',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '在这里你可以指定OTRS能够处理的REST消息的最大长度(以字节为单位)。',
        'Send Keep-Alive' => '发送Keep-Alive（保持连接）',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '此配置定义传入的连接应该关闭还是保持连接。',
        'Additional response headers' => '附加响应头',
        'Add response header' => '添加响应头',
        'Endpoint' => '端点',
        'URI to indicate specific location for accessing a web service.' =>
            '用于指示访问Web服务的特定位置的URI。',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '例如：https://www.otrs.com:10745/api/v1.0 (最后不带斜杠/)',
        'Timeout' => '超时',
        'Timeout value for requests.' => '请求的超时值。',
        'Authentication' => 'Authentication（身份验证）',
        'An optional authentication mechanism to access the remote system.' =>
            '用于访问远程系统的可选认证机制。',
        'BasicAuth User' => '基本认证用户',
        'The user name to be used to access the remote system.' => '用于访问远程系统的用户名。',
        'BasicAuth Password' => '基本认证密码',
        'The password for the privileged user.' => '特权用户的密码。',
        'Use Proxy Options' => '使用代理选项',
        'Show or hide Proxy options to connect to the remote system.' => '显示或隐藏连接到远程系统的代理选项。',
        'Proxy Server' => '代理服务器',
        'URI of a proxy server to be used (if needed).' => '代理服务器的URI(如果使用代理)。',
        'e.g. http://proxy_hostname:8080' => '例如：http://proxy_hostname:8080',
        'Proxy User' => '代理用户',
        'The user name to be used to access the proxy server.' => '访问代理服务器的用户名。',
        'Proxy Password' => '代理密码',
        'The password for the proxy user.' => '代理用户的密码。',
        'Skip Proxy' => '跳过代理',
        'Skip proxy servers that might be configured globally?' => '跳过可能已在全局配置的代理服务器吗？',
        'Use SSL Options' => '启用SSL选项',
        'Show or hide SSL options to connect to the remote system.' => '显示或隐藏用来连接远程系统SSL选项。',
        'Client Certificate' => '客户证书',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'SSL客户端证书文件的完整路径和名称（必须为PEM、DER或PKCS＃12格式）。',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => '例如： /opt/otrs/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => '客户证书密钥',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'SSL客户端证书密钥文件的完整路径和名称（如果尚未包含在证书文件中）。',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => '例如： /opt/otrs/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => '客户端证书密钥密码',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '如果密钥被加密，则此密码用于打开SSL证书。',
        'Certification Authority (CA) Certificate' => '认证机构（CA）证书',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '用来验证SSL证书的认证机构证书文件的完整路径和名称。',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '例如：/opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => '认证机构(CA)目录',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '认证机构目录的完整路径，文件系统中存储CA证书的地方。',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '例如：/opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => '调用程序的控制器映射',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '控制器接受调用程序发送的请求。以“:“作为标记的变量将被数据值和其它传递参数替换。',
        'Valid request command for Invoker' => '调用程序有效的请求命令',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '调用程序用于请求的特定的HTTP命令。',
        'Default command' => '默认命令',
        'The default HTTP command to use for the requests.' => '用于请求的默认HTTP命令。',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '例如： https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => '设置SOAP动作',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '设置为“是”，发送填写了的SOAPAction 头。',
        'Set to "No" in order to send an empty SOAPAction header.' => '设置为“否”，发送空白SOAPAction 头。',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '设置为“是”，检查接收的SOAPAction头（如果不为空）。',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '设置为“否”，忽略接收的SOAPAction标头。',
        'SOAPAction scheme' => 'SOAPAction方案',
        'Select how SOAPAction should be constructed.' => '选择如何构建SOAPAction。',
        'Some web services require a specific construction.' => '某些Web服务需要特定的结构。',
        'Some web services send a specific construction.' => '某些Web服务发送一个特定的构造。',
        'SOAPAction separator' => 'SOAP动作分隔符',
        'Character to use as separator between name space and SOAP operation.' =>
            '用作名称空间和SOAP操作之间的分隔符的字符。',
        'Usually .Net web services use "/" as separator.' => '通常.Net的Web服务使用"/"作为分隔符。',
        'SOAPAction free text' => 'SOAPAction自由文本',
        'Text to be used to as SOAPAction.' => '要用作SOAPAction的文本。',
        'Namespace' => '命名空间',
        'URI to give SOAP methods a context, reducing ambiguities.' => '为SOAP方法指定URI(通用资源标识符), 以便消除二义性。',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '例如：urn:otrs-com:soap:functions或http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => '请求名称方案',
        'Select how SOAP request function wrapper should be constructed.' =>
            '选择如何构建SOAP请求函数封装器。',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '“FunctionName”可用作实际调用程序/操作命名样例。',
        '\'FreeText\' is used as example for actual configured value.' =>
            '“FreeText”可用作实际配置值的样例。',
        'Request name free text' => '请求名称自定义字段',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '用于封装器名称后缀或替换的文本。',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '请考虑XML元素命名的限制（例如：不使用\'<\'和\'&\'）。',
        'Response name scheme' => '回复名称方案',
        'Select how SOAP response function wrapper should be constructed.' =>
            '选择如何构建SOAP回复函数封装器。',
        'Response name free text' => '回复名称自由文本',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '在这里你可以指定OTRS能够处理的SOAP消息的最大长度(以字节为单位)。',
        'Encoding' => '编码',
        'The character encoding for the SOAP message contents.' => 'SOAP消息内容的字符编码。',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '例如：utf-8, latin1, iso-8859-1, cp1250等等。',
        'Sort options' => '排序选项',
        'Add new first level element' => '添加新的第一级元素',
        'Element' => '元素',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '出站XML字段的排序顺序（下面的函数名称封装结构）-查看关于SOAP传输的文档。',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '添加Web服务',
        'Edit Web Service' => '编辑Web服务',
        'Clone Web Service' => '克隆Web服务',
        'The name must be unique.' => '名称必须是唯一的。',
        'Clone' => '克隆',
        'Export Web Service' => '导出Web服务',
        'Import web service' => '导入Web服务',
        'Configuration File' => '配置文件',
        'The file must be a valid web service configuration YAML file.' =>
            '必须是有效的Web服务配置文件(YAML格式)。',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '可以在此指定Web服务的名称。 如果此字段为空，则将使用配置文件的名称作为其名称。',
        'Import' => '导入',
        'Configuration History' => '配置历史',
        'Delete web service' => '删除Web服务',
        'Do you really want to delete this web service?' => '您真的想要删除这个Web服务吗？',
        'Ready2Adopt Web Services' => '即开即用的Web服务',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '你可以在这里激活即开即用的WEB服务，作为%s的一部分展示我们的最佳实践。',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '请注意：这些WEB服务可能依赖于其它仅在某些%s合同级别中才可用的模块(导入时会有详细提示信息)。',
        'Import Ready2Adopt web service' => '导入即开即用的WEB服务',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '你想从专家创建的WEB服务中受益吗？升级到%s 就能导入一些复杂的即开即用的WEB服务。',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '保存配置文件后，页面将再次转到编辑页面。',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '如果你想返回到概览，请点击"返回概览"按钮。',
        'Remote system' => '远程系统',
        'Provider transport' => '服务提供方传输',
        'Requester transport' => '服务请求方传输',
        'Debug threshold' => '调试阀值',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '在提供方模式中，OTRS为远程系统提供Web服务。',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '在请求方模式中，OTRS使用远程系统的Web服务。',
        'Network transport' => '网络传输',
        'Error Handling Modules' => '错误处理模块',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '错误处理模块用于在通信过程中发生错误时作出反应。 这些模块以特定的顺序执行，可以通过拖放来更改顺序。',
        'Backend' => '后端',
        'Add error handling module' => '添加错误处理模块',
        'Operations are individual system functions which remote systems can request.' =>
            '操作是各种不同的系统函数，可供远程系统请求调用。',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '调用程序为请求远程Web服务准备数据，并其响应的数据进行处理。',
        'Controller' => '控制器',
        'Inbound mapping' => '入站映射',
        'Outbound mapping' => '出站映射',
        'Delete this action' => '删除这个动作',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '至少有一个 %s 的控制器未被激活或根本就不存在，请检查控制器注册或删除这个 %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => '历史',
        'Go back to Web Service' => '返回到Web服务',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '在这里，你可以查看当前Web服务配置的旧版本，导出或恢复它们。',
        'Configuration History List' => '配置历史列表',
        'Version' => '版本',
        'Create time' => '创建时间',
        'Select a single configuration version to see its details.' => '选择一个配置版本，以便查看它的详细情况。',
        'Export web service configuration' => '导出Web服务配置',
        'Restore web service configuration' => '导入Web服务配置',
        'Do you really want to restore this version of the web service configuration?' =>
            '您真的想要恢复Web服务配置的这个版本吗？',
        'Your current web service configuration will be overwritten.' => '当前的Web服务配置将被覆盖。',

        # Template: AdminGroup
        'Group Management' => '组管理',
        'Add Group' => '添加组',
        'Edit Group' => '编辑组',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'admin组允许使用系统管理模块，stats组允许使用统计模块。',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '若要为不同的服务人员分配不同的访问权限，应创建新的组。(例如，采购部、支持部、销售部...)。 ',
        'It\'s useful for ASP solutions. ' => '它对ASP解决方案非常有用。 ',

        # Template: AdminLog
        'System Log' => '系统日志',
        'Here you will find log information about your system.' => '查看系统日志信息。',
        'Hide this message' => '隐藏此消息',
        'Recent Log Entries' => '最近的日志条目',
        'Facility' => '设施',
        'Message' => '消息',

        # Template: AdminMailAccount
        'Mail Account Management' => '邮件帐户管理',
        'Add Mail Account' => '添加邮件帐号',
        'Edit Mail Account for host' => '编辑邮件帐户，主机',
        'and user account' => '和用户帐户',
        'Filter for Mail Accounts' => '邮件帐户过滤器',
        'Filter for mail accounts' => '邮件帐户过滤器',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '同一帐户的所有传入电子邮件将在所选的队列中分派。',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '如果你的帐户被标记为受信任，则在到达时间已经存在的X-OTRS标头（优先级等）将被保留并被使用，例如用于邮箱管理员过滤器。',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '外发电子邮件可以通过%s中的Sendmail开头的设置进行配置。',
        'System Configuration' => '系统配置',
        'Host' => '主机',
        'Delete account' => '删除帐号',
        'Fetch mail' => '查收邮件',
        'Do you really want to delete this mail account?' => '您确定要删除这个邮件帐户吗？',
        'Password' => '密码',
        'Example: mail.example.com' => '样例：mail.example.com',
        'IMAP Folder' => 'IMAP文件夹',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '仅当你打算从其它文件夹(非INBOX)读取邮件时，才有必要修改此项.',
        'Trusted' => '是否信任',
        'Dispatching' => '分派',
        'Edit Mail Account' => '编辑邮件帐号',

        # Template: AdminNavigationBar
        'Administration Overview' => '系统管理概览',
        'Filter for Items' => '条目过滤器',
        'Filter' => '过滤器',
        'Favorites' => '收藏夹',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '你可以移动鼠标到条目的右上角并点击星形图标来将条目添加到收藏夹。',
        'Links' => '链接',
        'View the admin manual on Github' => '查看Github上的管理手册',
        'No Matches' => '无匹配',
        'Sorry, your search didn\'t match any items.' => '对不起，你的搜索不匹配任何条目。',
        'Set as favorite' => '添加到收藏夹',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '工单通知管理',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '在这里你可以上传一个配置文件以便导入工单通知，必须是与工单通知模块导出的文件一样的.yml格式。',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '在这里你可以选择哪个事件将会触发这个通知，下面的工单过滤器可以选择符合特定条件的工单。',
        'Ticket Filter' => '工单过滤',
        'Lock' => '锁定',
        'SLA' => 'SLA',
        'Customer User ID' => '客户用户ID',
        'Article Filter' => '信件过滤器',
        'Only for ArticleCreate and ArticleSend event' => '仅对ArticleCreate和ArticleSend事件',
        'Article sender type' => '信件发送人类型',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '如果ArticleCreate或ArticleSend被用作触发事件，你还需要指定信件过滤条件，请至少选择一个信件过滤字段。',
        'Customer visibility' => '客户可见度',
        'Communication channel' => '通信渠道',
        'Include attachments to notification' => '通知包含附件',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '每个工单的通知使用选择的方式一天只发送一次。',
        'This field is required and must have less than 4000 characters.' =>
            '这个字段是必须的，并且不能超过4000个字符。',
        'Notifications are sent to an agent or a customer.' => '发送给服务人员或客户的通知。',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '获取主题的前20个字符（最新的服务人员信件）。',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '获取邮件正文内容前5行（最新的服务人员信件）。',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '获取邮件主题的前20个字符（最新的客户信件）。',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '获取邮件正文内容前5行（最新的客户信件）。',
        'Attributes of the current customer user data' => '客户用户的属性',
        'Attributes of the current ticket owner user data' => '工单所有者的属性',
        'Attributes of the current ticket responsible user data' => '工单负责人的属性',
        'Attributes of the current agent user who requested this action' =>
            '请示此动作的服务人员的属性',
        'Attributes of the ticket data' => '工单的属性',
        'Ticket dynamic fields internal key values' => '工单动态字段内部键值',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '工单动态字段显示值，对下拉式和多项选择字段有用',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '使用逗号或分号分隔电子邮件地址。',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '你可以使用诸如<OTRS_TICKET_DynamicField_...>之类的OTRS标签来插入当前工单中的值。',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '管理 %s',
        'Downgrade to ((OTRS)) Community Edition' => '降级为 ((OTRS)) 社区版',
        'Read documentation' => '阅读文档',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s 定期连接到cloud.otrs.com检查可用更新，并验证合同的有效性。',
        'Unauthorized Usage Detected' => '检测到未经授权的使用',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '该系统所使用的 %s 许可证无效！ 请与%s联系续订或激活您的合同！',
        '%s not Correctly Installed' => '%s 没有正确安装',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '%s 没有正确安装，请点击下面的按钮重新安装。',
        'Reinstall %s' => '重新安装 %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '%s 没有正确安装，已经有了可用的更新版本。',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '你可以重新安装当前版本，或者安装新版本（推荐更新到新版本）。',
        'Update %s' => '更新 %s',
        '%s Not Yet Available' => '%s 还不可用',
        '%s will be available soon.' => '%s 很快就可用了。',
        '%s Update Available' => '%s 更新可用',
        'An update for your %s is available! Please update at your earliest!' =>
            '%s 有更新版本可用了！请尽早更新！',
        '%s Correctly Deployed' => '%s 已经正确地部署',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '恭喜，你的%s 已经正确地安装到最新版本！',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => '访问OTRS客户门户',
        '%s will be available soon. Please check again in a few days.' =>
            '%s 很快就可用了，请过几天再检查一次。',
        'Please have a look at %s for more information.' => '有关更多信息,请查看 %s。',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            ' ((OTRS)) 社区版是所有特色功能的基础，继续升级到%s 前请先注册！',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '在从%s 受益之前，请先联系%s 以获得%s 合同。',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '不能通过HTTPS连接到cloud.otrs.com，请确保你的OTRS系统能够通过端口443连接到cloud.otrs.com。',
        'Package installation requires patch level update of OTRS.' => '软件包安装需要更新OTRS的补丁级别。',
        'Please visit our customer portal and file a request.' => '请访问我们的客户门户并提出请求。',
        'Everything else will be done as part of your contract.' => '一切都将作为您的合同的一部分完成。',
        'Your installed OTRS version is %s.' => '您安装的OTRS版本是%s。',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '要安装此软件包，您需要更新到OTRS %s或更高版本。',
        'To install this package, the Maximum OTRS Version is %s.' => '要安装此软件包，OTRS最高版本为%s。',
        'To install this package, the required Framework version is %s.' =>
            '要安装此软件包，所需的框架版本为%s。',
        'Why should I keep OTRS up to date?' => '为什么要保持OTRS是最新的？',
        'You will receive updates about relevant security issues.' => '您将收到有关安全问题的更新。',
        'You will receive updates for all other relevant OTRS issues' => '您将收到所有其他OTRS相关问题的更新',
        'With your existing contract you can only use a small part of the %s.' =>
            '当前的合同表明你只能使用%s 的小部分功能。',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '如欲发挥%s 的全部优势，请升级合同！联系%s。',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '取消降级并返回',
        'Go to OTRS Package Manager' => '进入 OTRS 软件包管理',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '当前不能降级，因为以下软件包依赖%s：',
        'Vendor' => '提供者',
        'Please uninstall the packages first using the package manager and try again.' =>
            '请在软件包管理模块中先删除这些软件包，然后再试一次。',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '你打算降级到 ((OTRS)) 社区版，以下功能特性和相关数据将全部丢失：',
        'Chat' => '聊天',
        'Report Generator' => '报表生成器',
        'Timeline view in ticket zoom' => '以时间轴视图展开工单',
        'DynamicField ContactWithData' => '动态字段ContactWithData',
        'DynamicField Database' => '动态字段Database',
        'SLA Selection Dialog' => 'SLA选择对话框',
        'Ticket Attachment View' => '工单附件视图',
        'The %s skin' => '%s 皮肤',

        # Template: AdminPGP
        'PGP Management' => 'PGP管理',
        'Add PGP Key' => '添加PGP密钥',
        'PGP support is disabled' => 'PGP支持已禁用',
        'To be able to use PGP in OTRS, you have to enable it first.' => '要在OTRS中使用PGP，你必须首先启用它。',
        'Enable PGP support' => '启用PGP支持',
        'Faulty PGP configuration' => '错误的PGP配置',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '已启用PGP支持，但是相关的配置包含有错误。请使用下面的按钮检查配置。',
        'Configure it here!' => '在这里配置PGP！',
        'Check PGP configuration' => '检查PGP配置',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            '通过此模块可以直接编辑在SysConfig中配置的密钥环。',
        'Introduction to PGP' => 'PGP介绍',
        'Identifier' => '标识符',
        'Bit' => '位',
        'Fingerprint' => '指纹',
        'Expires' => '过期',
        'Delete this key' => '删除密钥',
        'PGP key' => 'PGP密钥',

        # Template: AdminPackageManager
        'Package Manager' => '软件包管理器',
        'Uninstall Package' => '卸载软件包',
        'Uninstall package' => '卸载软件包',
        'Do you really want to uninstall this package?' => '是否确认卸载该软件包?',
        'Reinstall package' => '重新安装软件包',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '您真的想要重新安装该软包吗? 所有该模块的手工设置将丢失.',
        'Go to updating instructions' => '转到升级说明',
        'package information' => '软件包信息',
        'Package installation requires a patch level update of OTRS.' => '安装软件包需要将OTRS补丁级别更新。',
        'Package update requires a patch level update of OTRS.' => '升级软件包需要将OTRS补丁级别更新。',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '如果您是OTRS 商业版™客户，请访问我们的客户门户并提交请求。',
        'Please note that your installed OTRS version is %s.' => '请注意，您安装的OTRS版本是%s。',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            '安装这个软件包，你需要升级OTRS版本到%s或者更高。',
        'This package can only be installed on OTRS version %s or older.' =>
            '这个软件包只能安装在OTRS版本%s或者更低。',
        'This package can only be installed on OTRS version %s or newer.' =>
            '这个软件包只能安装在OTRS版本%s或者更高。',
        'You will receive updates for all other relevant OTRS issues.' =>
            '你将收到所有其他有关OTRS问题的更新。',
        'How can I do a patch level update if I don’t have a contract?' =>
            '如果没有合约，我怎么更新补丁级别？',
        'Please find all relevant information within the updating instructions at %s.' =>
            '请在升级说明%s中查找所有相关的信息。',
        'In case you would have further questions we would be glad to answer them.' =>
            '如果您还有其它问题，我们非常愿意答复您。',
        'Install Package' => '安装软件包',
        'Update Package' => '更新软件包',
        'Continue' => '继续',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '请确认你的数据库能够接收大于%s MB的数据包（目前能够接收的最大数据包为%s MB）。为了避免程序报错，请调整数据库max_allowed_packet参数。',
        'Install' => '安装',
        'Update repository information' => '更新软件仓库信息',
        'Cloud services are currently disabled.' => '云服务当前被禁用了。',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™（OTRS验证）不能继续！',
        'Enable cloud services' => '启用云服务',
        'Update all installed packages' => '更新所有已安装的软件包',
        'Online Repository' => '在线软件仓库',
        'Action' => '操作',
        'Module documentation' => '模块文档',
        'Local Repository' => '本地软件仓库',
        'This package is verified by OTRSverify (tm)' => '此软件包已通过OTRSverify(tm)的验证',
        'Uninstall' => '卸载',
        'Package not correctly deployed! Please reinstall the package.' =>
            '软件包未正确安装！请重新安装软件包。',
        'Reinstall' => '重新安装',
        'Features for %s customers only' => '仅%s 才能使用的功能',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '你能从%s 得到以下可选的功能特性，请联系%s 获取更多信息。',
        'Package Information' => '软件包信息',
        'Download package' => '下载该软件包',
        'Rebuild package' => '重新编译',
        'Metadata' => '元数据',
        'Change Log' => '更新记录',
        'Date' => '日期',
        'List of Files' => '文件清单',
        'Permission' => '权限',
        'Download file from package!' => '从软件包中下载这个文件！',
        'Required' => '必需的',
        'Size' => '大小',
        'Primary Key' => '主密钥',
        'Auto Increment' => '自动增加',
        'SQL' => 'SQL',
        'File Differences for File %s' => '文件%s的文件差异',
        'File differences for file %s' => '文件跟%s 有差异',

        # Template: AdminPerformanceLog
        'Performance Log' => '性能日志',
        'Range' => '范围',
        'last' => '最后',
        'This feature is enabled!' => '该功能已启用！',
        'Just use this feature if you want to log each request.' => '如果想详细记录每个请求, 您可以使用该功能.',
        'Activating this feature might affect your system performance!' =>
            '启动该功能可能影响您的系统性能！',
        'Disable it here!' => '关闭该功能！',
        'Logfile too large!' => '日志文件过大！',
        'The logfile is too large, you need to reset it' => '日志文件太大，请重置日志文件',
        'Reset' => '重置',
        'Overview' => '概览',
        'Interface' => '界面',
        'Requests' => '请求',
        'Min Response' => '最快响应',
        'Max Response' => '最慢响应',
        'Average Response' => '平均响应',
        'Period' => '时长',
        'minutes' => '分钟',
        'Min' => '最小',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '管理邮箱管理员过滤器',
        'Add PostMaster Filter' => '添加邮箱管理员过滤器',
        'Edit PostMaster Filter' => '编辑邮箱管理员过滤器',
        'Filter for PostMaster Filters' => '邮箱管理员过滤规则筛选',
        'Filter for PostMaster filters' => '邮箱管理员过滤规则筛选',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '基于邮件标头标记的分派或过滤。可以使用正则表达式进行匹配。',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '如果你只想匹配某个邮件地址，可以在From、To或Cc中使用EMAILADDRESS:info@example.com这样的邮件格式。',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '如果你使用了正则表达式，你可以取出()中匹配的值(需采用[***]这种格式)，在设置邮件标头的值时使用。',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '您还可以使用命名捕获%s并在\'Set\'操作中使用名称%s（例如Regexp：%s，Set 操作：%s）。 匹配到的EMAILADDRESS命名为\'%s\'。',
        'Delete this filter' => '删除此过滤器',
        'Do you really want to delete this postmaster filter?' => '您确定要删除这个邮箱管理员过滤器吗？',
        'A postmaster filter with this name already exists!' => '该邮箱管理员过滤器名称已被使用！',
        'Filter Condition' => '过滤器条件',
        'AND Condition' => '“与”条件',
        'Search header field' => '搜索标头字段',
        'for value' => '查找值',
        'The field needs to be a valid regular expression or a literal word.' =>
            '该栏位需使用有效的正则表达式或文字。',
        'Negate' => '求反',
        'Set Email Headers' => '设置邮件标头',
        'Set email header' => '设置邮件标头',
        'with value' => '使用值',
        'The field needs to be a literal word.' => '该字段需要输入文字。',
        'Header' => '标头',

        # Template: AdminPriority
        'Priority Management' => '优先级管理',
        'Add Priority' => '添加优先级',
        'Edit Priority' => '编辑优先级',
        'Filter for Priorities' => '优先级过滤器',
        'Filter for priorities' => '优先级过滤器',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '此优先级已存在于系统配置的一个设置中，需要更新设置以确认指向新的优先级！',
        'This priority is used in the following config settings:' => '这个优先级已用于以下的系统配置设置：',

        # Template: AdminProcessManagement
        'Process Management' => '流程管理',
        'Filter for Processes' => '流程过滤器',
        'Filter for processes' => '流程筛选',
        'Create New Process' => '创建新的流程',
        'Deploy All Processes' => '部署所有流程',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '你可以上传流程配置文件，以便将流程配置导入到你的系统中。流程配置文件采用.yml格式，它可以从流程管理模块中导出。',
        'Upload process configuration' => '上传流程配置',
        'Import process configuration' => '导入流程配置',
        'Ready2Adopt Processes' => '即开即用的流程',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '你可以在此激活能展示我们最佳实践的即开即用的流程，请注意这可能需要一些额外的配置。',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '你想从专家创建的流程中受益吗？升级到%s 就能导入一些复杂的即开即用的流程。',
        'Import Ready2Adopt process' => '导入即开即用的流程',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '为了创建新的流程，你可以导入从其它系统导出的流程配置文件，或者重新创建一个。',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '对流程所做的一切修改仅保存在数据库中。只有执行部署流程操作后，才会生成或重新生成流程配置文件。',
        'Processes' => '流程',
        'Process name' => '流程名称',
        'Print' => '打印',
        'Export Process Configuration' => '导出流程配置',
        'Copy Process' => '复制流程',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '取消并关闭',
        'Go Back' => '返回',
        'Please note, that changing this activity will affect the following processes' =>
            '请注意，修改这个活动将影响以下流程',
        'Activity' => '活动',
        'Activity Name' => '活动名称',
        'Activity Dialogs' => '活动对话框',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '用鼠标将左侧列表中的元素拖放到右侧，你可以为这个活动分配活动对话框。',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '利用鼠标拖放动作还可以对元素进行排序。',
        'Filter available Activity Dialogs' => '可用的活动对话框过滤器',
        'Available Activity Dialogs' => '可用的活动对话框',
        'Name: %s, EntityID: %s' => '名称：%s， EntityID： %s',
        'Create New Activity Dialog' => '创建新的活动对话框',
        'Assigned Activity Dialogs' => '分配的活动对话框',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '请注意，修改这个活动对话框将影响以下活动',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '请注意，客户并不能看到或使用以下字段：Owner, Responsible, Lock, PendingTime and CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '队列字段只能在客户创建新工单时使用。',
        'Activity Dialog' => '活动对话框',
        'Activity dialog Name' => '活动对话框名称',
        'Available in' => '在以下界面可用',
        'Description (short)' => '描述(简短)',
        'Description (long)' => '描述(详细)',
        'The selected permission does not exist.' => '选择的权限不存在。',
        'Required Lock' => '需要锁定',
        'The selected required lock does not exist.' => '选择的需要锁定不存在（无法锁定）。',
        'Submit Advice Text' => '提交按钮的建议文本',
        'Submit Button Text' => '提交按钮的文本',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '用鼠标将左侧列表中的元素拖放到右侧，你可以为这个活动对话框分配字段。',
        'Filter available fields' => '可用字段的过滤器',
        'Available Fields' => '可用的字段',
        'Assigned Fields' => '分配的字段',
        'Communication Channel' => '通信渠道',
        'Is visible for customer' => '对客户可见',
        'Display' => 'Display（显示）',

        # Template: AdminProcessManagementPath
        'Path' => '路径',
        'Edit this transition' => '编辑这个转换',
        'Transition Actions' => '转换操作',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '用鼠标将左侧列表中的元素拖放到右侧，你可以为这个转换分配转换动作。',
        'Filter available Transition Actions' => '可用转换动作的过滤器',
        'Available Transition Actions' => '可用的转换操作',
        'Create New Transition Action' => '创建新的转换动作',
        'Assigned Transition Actions' => '分配的转换动作',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '活动',
        'Filter Activities...' => '活动过滤器...',
        'Create New Activity' => '创建新的活动',
        'Filter Activity Dialogs...' => '活动对话框过滤器...',
        'Transitions' => '转换',
        'Filter Transitions...' => '转换过滤器...',
        'Create New Transition' => '创建新的转换',
        'Filter Transition Actions...' => '转换动作过滤器...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '编辑流程',
        'Print process information' => '打印流程信息',
        'Delete Process' => '删除流程',
        'Delete Inactive Process' => '删除非活动的流程',
        'Available Process Elements' => '可用的流程元素',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '用鼠标拖放动作，可以将左侧栏目上方所列的元素放置在右侧的画布中。',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '可能将活动拖放到画布中，以便为流程分配活动。',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '为了给活动分配活动对话框，需要将左侧的活动对话框拖放到画布中的活动上。',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '要创建两个活动的连接，你可以先拖放转换元素到开始活动上，然后移动连接箭头的尾端到结束活动上。',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '为了给转换分配转换动作，需要将左侧转换动作拖放到转换标签上。',
        'Edit Process Information' => '编辑流程信息',
        'Process Name' => '流程名称',
        'The selected state does not exist.' => '选择的状态不存在。',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '添加并编辑活动、活动对话框和转换',
        'Show EntityIDs' => '显示实体编号',
        'Extend the width of the Canvas' => '扩展画布的宽度',
        'Extend the height of the Canvas' => '扩展画布的高度',
        'Remove the Activity from this Process' => '从流程中删除这个活动',
        'Edit this Activity' => '编辑这个活动',
        'Save Activities, Activity Dialogs and Transitions' => '保存活动、活动对话框和转换',
        'Do you really want to delete this Process?' => '您真的想要删除这个流程吗？',
        'Do you really want to delete this Activity?' => '您真的想要删除这个活动吗？',
        'Do you really want to delete this Activity Dialog?' => '您真的想要删除这个活动对话框吗？',
        'Do you really want to delete this Transition?' => '您真的想要删除这个转换吗？',
        'Do you really want to delete this Transition Action?' => '您真的想要删除这个转换动作吗？',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您真的想要从画布中删除这个活动吗？不保存并离开此屏幕可撤销删除操作。',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您真的想要从画布中删除这个转换吗？不保存并离开此屏幕可撤销删除操作。',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '在这里，你可以创建新的流程。为了使新流程生效，请务必将流程的状态设置为“激活”，并在完成配置工作后执行部署流程操作。',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '取消并关闭',
        'Start Activity' => '开始活动',
        'Contains %s dialog(s)' => '包含%s 个对话框',
        'Assigned dialogs' => '分配对话框',
        'Activities are not being used in this process.' => '该流程未使用活动。',
        'Assigned fields' => '分配的字段',
        'Activity dialogs are not being used in this process.' => '该流程未使用活动对话框。',
        'Condition linking' => '条件链接',
        'Transitions are not being used in this process.' => '该流程未使用转换。',
        'Module name' => '模块名称',
        'Transition actions are not being used in this process.' => '该流程未使用转换动作。',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '请注意，修改这个转换将影响以下流程',
        'Transition' => '转换',
        'Transition Name' => '转换名称',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '请注意，修改这个转换动作将影响以下流程',
        'Transition Action' => '转换动作',
        'Transition Action Name' => '转换动作名称',
        'Transition Action Module' => '转换动作模块',
        'Config Parameters' => '配置参数',
        'Add a new Parameter' => '添加新的参数',
        'Remove this Parameter' => '删除这个参数',

        # Template: AdminQueue
        'Queue Management' => '队列管理',
        'Add Queue' => '添加队列',
        'Edit Queue' => '编辑队列',
        'Filter for Queues' => '队列过滤器',
        'Filter for queues' => '队列过滤器',
        'A queue with this name already exists!' => '队列名已存在！',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '这个队列已存在于系统配置的一个设置中，需要更新设置以确认指向新的队列！',
        'Sub-queue of' => '父队列',
        'Unlock timeout' => '解锁超时',
        '0 = no unlock' => '0 = 不解锁',
        'hours' => '小时',
        'Only business hours are counted.' => '只计算上班时间。',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '如果工单被锁定且在解锁超时之前未被关闭，则该工单将被解锁，以便其他服务人员能够处理该工单。',
        'Notify by' => '触发通知阈值',
        '0 = no escalation' => '0 = 不升级',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定义的时间之前，服务人员没有对新工单添加任何客户联络(无论是外部邮件或电话)，该工单将升级.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '如果有新的信件，例如客户通过门户或邮件发送跟进信件，则升级更新时间重置。 如果在此所定义的时间之前，服务人员没有对新工单添加任何客户联络(无论是外部邮件或电话)，该工单将升级.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定义的时间之前，工单未被关闭，该工单将升级。',
        'Follow up Option' => '跟进选项',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '如果在工单关闭后跟进，指定是重新处理工单、拒绝跟进还是创建新的工单。',
        'Ticket lock after a follow up' => '跟进后自动锁定工单',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '如果客户在工单关闭后发送跟进信件，则将该工单锁定给以前的所有者。',
        'System address' => '系统邮件地址',
        'Will be the sender address of this queue for email answers.' => '将作为邮件答复的队列的发件人地址。',
        'Default sign key' => '默认签名',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'PGP密钥或者S/MIME证书需要被添加标识符到选定的队列系统电子邮件地址，以便使用。',
        'Salutation' => '问候语',
        'The salutation for email answers.' => '回复邮件中的问候语。',
        'Signature' => '签名',
        'The signature for email answers.' => '回复邮件中的签名。',
        'This queue is used in the following config settings:' => '这个队列已用于以下的系统配置设置：',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '管理队列的自动响应',
        'Change Auto Response Relations for Queue' => '修改队列的自动响应关系',
        'This filter allow you to show queues without auto responses' => '这个过滤器允许显示没有自动响应的队列',
        'Queues without Auto Responses' => '没有自动响应的队列',
        'This filter allow you to show all queues' => '这个过滤器允许显示所有队列',
        'Show All Queues' => '显示所有队列',
        'Auto Responses' => '自动响应',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '管理模板与队列的对应关系',
        'Filter for Templates' => '模板过滤器',
        'Filter for templates' => '模板筛选',
        'Templates' => '模板',

        # Template: AdminRegistration
        'System Registration Management' => '系统注册管理',
        'Edit System Registration' => '编辑系统注册',
        'System Registration Overview' => '系统注册概览',
        'Register System' => '注册系统',
        'Validate OTRS-ID' => '验证OTRS-ID',
        'Deregister System' => '取消系统注册',
        'Edit details' => '编辑详细信息',
        'Show transmitted data' => '显示已传输的数据',
        'Deregister system' => '取消系统注册',
        'Overview of registered systems' => '注册系统概述',
        'This system is registered with OTRS Group.' => '本系统已注册到OTRS集团。',
        'System type' => '系统类型',
        'Unique ID' => '唯一ID',
        'Last communication with registration server' => '与注册服务器上一次的通信',
        'System Registration not Possible' => '系统注册不可能',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '请注意：如果OTRS守护进程没有正确运行，你就不能注册你的系统！',
        'Instructions' => '说明',
        'System Deregistration not Possible' => '系统取消注册不可能',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '请注意：如果你正在使用%s 或具有一个有效的服务合同，你就不能取消你的系统注册。',
        'OTRS-ID Login' => 'OTRS-ID登陆',
        'Read more' => '阅读更多',
        'You need to log in with your OTRS-ID to register your system.' =>
            '为了注册系统，需要你先使用OTRS-ID进行登陆。',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'OTRS-ID是你在OTRS.com网站注册的电子邮箱地址。',
        'Data Protection' => '数据保护',
        'What are the advantages of system registration?' => '系统注册有什么好处?',
        'You will receive updates about relevant security releases.' => '你将及时收到有关安全版本的更新信息。',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '你的系统注册有助于我们改善为你提供的服务，因为我们能获得必要的相关信息。',
        'This is only the beginning!' => '这仅仅是开始！',
        'We will inform you about our new services and offerings soon.' =>
            '有了新的服务和产品我们能很快通知你。',
        'Can I use OTRS without being registered?' => '如果不进行系统注册，我还可以使用OTRS吗?',
        'System registration is optional.' => '系统注册是可选的。',
        'You can download and use OTRS without being registered.' => '不进行注册，你仍然可以下载和使用OTRS。',
        'Is it possible to deregister?' => '可以取消注册吗？',
        'You can deregister at any time.' => '你可以随时取消系统注册。',
        'Which data is transfered when registering?' => '注册后，哪些数据会被上传?',
        'A registered system sends the following data to OTRS Group:' => '注册过的系统会将以下数据上传给OTRS集团：',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            '域名(FQDN)、OTRS版本、数据库、操作系统和Perl版本。',
        'Why do I have to provide a description for my system?' => '为什么需要我提供有关注册系统的描述?',
        'The description of the system is optional.' => '注册系统的描述是可选的。',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '注册系统描述和类型有助于您识别和管理系统的细节。',
        'How often does my OTRS system send updates?' => '我的OTRS系统上传数据的频度?',
        'Your system will send updates to the registration server at regular intervals.' =>
            '你的系统将定期向注册服务器发送更新。',
        'Typically this would be around once every three days.' => '通常这将是大约每3天1次。',
        'If you deregister your system, you will lose these benefits:' =>
            '如果你取消注册你的系统，你将失去以下好处：',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '为了取消注册你的系统，你需要以OTRS-ID登录。',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => '还没有OTRS-ID吗？',
        'Sign up now' => '现在注册',
        'Forgot your password?' => '忘记密码了吗？',
        'Retrieve a new one' => '获取新的密码',
        'Next' => '下一步',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '注册本系统后，这个数据会经常传送给OTRS集团。',
        'Attribute' => '属性',
        'FQDN' => '正式域名',
        'OTRS Version' => 'OTRS版本',
        'Operating System' => '操作系统',
        'Perl Version' => 'Perl版本',
        'Optional description of this system.' => '本系统可选的描述。',
        'Register' => '注册',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '继续这一步将从OTRS集团取消注册本系统。',
        'Deregister' => '取消注册',
        'You can modify registration settings here.' => '你可以在这里修改注册设置。',
        'Overview of Transmitted Data' => '已传输的数据概览',
        'There is no data regularly sent from your system to %s.' => '你的系统还没有定期向%s 发送数据。',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '你的系统至少每3天向%s 发送一次以下数据。',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'JSON格式的数据将通过安全的HTTPS连接进行上传。',
        'System Registration Data' => '系统注册信息',
        'Support Data' => '支持数据',

        # Template: AdminRole
        'Role Management' => '角色管理',
        'Add Role' => '添加角色',
        'Edit Role' => '编辑角色',
        'Filter for Roles' => '角色过滤器',
        'Filter for roles' => '角色过滤器',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '创建一个角色并将组加入角色,然后将角色赋给用户.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '还没有定义角色，请使用“添加”按钮来创建一个新的角色。',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '管理角色和组的关系',
        'Roles' => '角色',
        'Select the role:group permissions.' => '选择角色的组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '如果没有选择，角色就不会具有任何权限 (任何工单都看不见)。',
        'Toggle %s permission for all' => '全部授予/取消 %s 权限',
        'move_into' => '转移到',
        'Permissions to move tickets into this group/queue.' => '将工单转移到这个组/队列的权限。',
        'create' => 'create（创建）',
        'Permissions to create tickets in this group/queue.' => '在这个组/队列具有创建工单的权限。',
        'note' => 'note（备注）',
        'Permissions to add notes to tickets in this group/queue.' => '在这个组/队列具有添加备注的权限。',
        'owner' => 'owner（所有者）',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '在这个组/队列具有变更工单所有者的权限。',
        'priority' => '优先级',
        'Permissions to change the ticket priority in this group/queue.' =>
            '在这个组/队列具有更改工单优先级的权限。',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '管理服务人员与角色的关系',
        'Add Agent' => '添加服务人员',
        'Filter for Agents' => '服务人员过滤器',
        'Filter for agents' => '过滤服务人员',
        'Agents' => '服务人员',
        'Manage Role-Agent Relations' => '管理角色与服务人员的关系',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Edit SLA' => '编辑SLA',
        'Add SLA' => '添加SLA',
        'Filter for SLAs' => 'SLA过滤器',
        'Please write only numbers!' => '仅可填写数字！',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'Add Certificate' => '添加证书',
        'Add Private Key' => '添加私钥',
        'SMIME support is disabled' => 'SMIME支持已禁用',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '要在OTRS中使用SMIME，你必须首先启用它。',
        'Enable SMIME support' => '启用SMIME支持',
        'Faulty SMIME configuration' => '错误的SMIME配置',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '已启用SMIME支持，但是相关的配置包含有错误。请使用下面的按钮检查配置。',
        'Check SMIME configuration' => '检查SMIME配置',
        'Filter for Certificates' => '证书过滤器',
        'Filter for certificates' => '证书过滤器',
        'To show certificate details click on a certificate icon.' => '点击证书图标可显示证书详细信息。',
        'To manage private certificate relations click on a private key icon.' =>
            '点击私钥图标可管理私钥证书关系。',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '你可以在这里添加私钥关系，这些关系将嵌入到邮件的S/MIME签名中。',
        'See also' => '参见',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '这样你能够直接编辑文件系统中的证书和私匙。',
        'Hash' => '哈希',
        'Create' => '创建',
        'Handle related certificates' => '处理关联的证书',
        'Read certificate' => '读取证书',
        'Delete this certificate' => '删除这个证书',
        'File' => '文件',
        'Secret' => '机密',
        'Related Certificates for' => '关联证书',
        'Delete this relation' => '删除这个关联',
        'Available Certificates' => '可用的证书',
        'Filter for S/MIME certs' => 'S/MIME证书过滤器',
        'Relate this certificate' => '关联这个证书',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME证书',
        'Close this dialog' => '关闭该对话框',
        'Certificate Details' => '证书详情',

        # Template: AdminSalutation
        'Salutation Management' => '问候语管理',
        'Add Salutation' => '添加问候语',
        'Edit Salutation' => '编辑问候语',
        'Filter for Salutations' => '问候语过滤器',
        'Filter for salutations' => '问候语过滤器',
        'e. g.' => '例如：',
        'Example salutation' => '问候语样例',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '需要启用安全模式！',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '在初始安装结束后，通常都设置系统为安全模式。',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '如果安全模式没有激活，可在系统运行时通过系统配置激活安全模式。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL查询窗口',
        'Filter for Results' => '过滤结果',
        'Filter for results' => '过滤结果',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '你可以在这里输入SQL语句直接发送给数据库。不能修改表的内容，只允许select查询语句。',
        'Here you can enter SQL to send it directly to the application database.' =>
            '你可以在这里输入SQL语句直接发送给数据库。',
        'Options' => '选项',
        'Only select queries are allowed.' => '只允许select查询语句。',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL查询的语法有一个错误，请核对。',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '至少缺失一个参数，请检查。',
        'Result format' => '结果格式',
        'Run Query' => '执行查询',
        '%s Results' => '%s 的结果',
        'Query is executed.' => '查询已执行。',

        # Template: AdminService
        'Service Management' => '服务管理',
        'Add Service' => '添加服务',
        'Edit Service' => '编辑服务',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '服务名(含子服务)最大长度为200字符。',
        'Sub-service of' => '上一级服务',

        # Template: AdminSession
        'Session Management' => '会话管理',
        'Detail Session View for %s (%s)' => '%s(%s)会话详情视图',
        'All sessions' => '所有会话数',
        'Agent sessions' => '服务人员会话数',
        'Customer sessions' => '客户会话数',
        'Unique agents' => '实际服务人员数',
        'Unique customers' => '实际在线客户数',
        'Kill all sessions' => '终止所有会话',
        'Kill this session' => '终止该会话',
        'Filter for Sessions' => '会话过滤器',
        'Filter for sessions' => '会话过滤器',
        'Session' => '会话',
        'User' => '用户',
        'Kill' => '终止',
        'Detail View for SessionID: %s - %s' => '会话ID：%s - %s的详情视图',

        # Template: AdminSignature
        'Signature Management' => '签名管理',
        'Add Signature' => '添加签名',
        'Edit Signature' => '编辑签名',
        'Filter for Signatures' => '签名过滤器',
        'Filter for signatures' => '签名过滤器',
        'Example signature' => '签名样例',

        # Template: AdminState
        'State Management' => '工单状态管理',
        'Add State' => '添加工单状态',
        'Edit State' => '编辑工单状态',
        'Filter for States' => '状态过滤器',
        'Filter for states' => '状态过滤器',
        'Attention' => '注意',
        'Please also update the states in SysConfig where needed.' => '请同时在系统配置中需要的地方更新这些工单状态。',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '这个状态已存在于系统配置的一个设置中，需要更新设置以确认指向新的状态！',
        'State type' => '工单状态类型',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '无法使此条目无效，因为系统中没有其他合并状态！',
        'This state is used in the following config settings:' => '这个状态已用于以下的系统配置设置：',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => '不能将支持数据发送给OTRS集团！',
        'Enable Cloud Services' => '启用云服务',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '这些数据被定期发送到OTRS集团，要停止发送这些数据，请更新你的系统注册配置。',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '你可以通过这个按钮手动发送支持数据：',
        'Send Update' => '发送更新',
        'Currently this data is only shown in this system.' => '目前支持数据只是在本地系统上显示。',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '点击以下按钮生成支持数据包（包括：系统注册信息、支持数据、已安装软件包列表和本地所有修改过的源代码文件）：',
        'Generate Support Bundle' => '生成支持数据包',
        'The Support Bundle has been Generated' => '已生成支持包',
        'Please choose one of the following options.' => '请选择以下的任一个选项。',
        'Send by Email' => '通过邮件发送',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '支持数据包太大无法通过邮件发送，本选项无法使用。',
        'The email address for this user is invalid, this option has been disabled.' =>
            '当前用户的邮件地址无效，本选项无法使用。',
        'Sending' => '发送中',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '支持数据包会自动通过电子邮件方式发送给OTRS集团。',
        'Download File' => '下载文件',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '包含支持数据包的文件已经可以下载到本地。请保存文件，然后通过其他方法把这个文件发送给OTRS集团。',
        'Error: Support data could not be collected (%s).' => '错误：%s 无法收集支持数据。',
        'Details' => '详情',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => '系统邮件地址管理',
        'Add System Email Address' => '添加统邮件地址',
        'Edit System Email Address' => '编辑统邮件地址',
        'Add System Address' => '添加系统地址',
        'Filter for System Addresses' => '系统地址过滤器',
        'Filter for system addresses' => '系统地址过滤器',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '对于所有接收到的邮件，如果在其To或Cc中出现了该系统邮件地址，则将邮件分派到选择的队列中。',
        'Email address' => '电子邮件地址',
        'Display name' => '显示名称',
        'This email address is already used as system email address.' => '这个电子邮件地址已经用于系统电子邮件地址。',
        'The display name and email address will be shown on mail you send.' =>
            '邮件地址和显示名称将在发送的邮件中显示。',
        'This system address cannot be set to invalid.' => '该系统地址不能设置为无效。',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '此系统地址不能设置为无效，因为它用于一个或多个队列或自动响应。',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '在线管理员文档',
        'System configuration' => '系统配置',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '使用左侧导航框中的树形结构浏览可用的设置。',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '使用下面的搜索字段或从顶部导航的搜索图标查找某些设置。',
        'Find out how to use the system configuration by reading the %s.' =>
            '通过阅读%s来了解如何使用系统配置。',
        'Search in all settings...' => '在所有设置中搜索...',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '目前没有可用的设置。 在使用软件之前，请确保运行 \'otrs.Console.pl Maint::Config::Rebuild\'。',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '更改部署',
        'Help' => '帮助',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '这是所有设置的概览，如果现在启动它，它将成为部署的一部分。 可以通过点击右上角的图标来比较每个设置当前与其先前的状态。',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '要从部署中排除某些设置，请单击设置的顶部栏中的复选框。',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '默认情况下，只会部署你自己更改的设置。 如果您想部署其他用户更改的设置，请点击屏幕顶部的链接进入高级部署模式。',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '刚刚恢复部署，所有受影响的设置已从所选部署恢复到原状态。',
        'Please review the changed settings and deploy afterwards.' => '请查看已更改的设置，然后再进行部署。',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '一个空的更改列表意味着在当前受影响的设置状态和已恢复的状态之间没有差异。',
        'Changes Overview' => '更改概览',
        'There are %s changed settings which will be deployed in this run.' =>
            '有%s个更改的设置将在本次运行中部署。',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '切换到基本模式，仅部署由你更改的设置。',
        'You have %s changed settings which will be deployed in this run.' =>
            '你有%s个更改的设置将在本次运行中部署。',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '切换到高级模式，还可以部署其他用户更改的设置。',
        'There are no settings to be deployed.' => '没有要部署的设置。',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '切换到高级模式，查看其他用户更改的可部署设置。',
        'Deploy selected changes' => '部署所选更改',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '这个组不包含任何设置， 请尝试浏览它的一个子组。',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '导入和导出',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '上传要导入到系统的文件（从系统配置模块导出的.yml格式）。',
        'Upload system configuration' => '上传系统配置',
        'Import system configuration' => '导入系统配置',
        'Download current configuration settings of your system in a .yml file.' =>
            '下载当前的系统配置设置到一个.yml文件。',
        'Include user settings' => '包括用户设置',
        'Export current configuration' => '导出当前配置',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '搜索',
        'Search for category' => '搜索类别',
        'Settings I\'m currently editing' => '我正在编辑的设置',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '搜索“%s”（在“%s”类别中）没有返回任何结果。',
        'Your search for "%s" in category "%s" returned one result.' => '搜索“%s”（在“%s”类别中）返回了一个结果。',
        'Your search for "%s" in category "%s" returned %s results.' => '搜索“%s”（在“%s”类别中）返回了%s个结果。',
        'You\'re currently not editing any settings.' => '你当前没有编辑任何设置。',
        'You\'re currently editing %s setting(s).' => '你正在编辑%s设置。',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => '类别',
        'Run search' => '搜索',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '查看设置的自定义列表',
        'View single Setting: %s' => '查看单个设置：%s',
        'Go back to Deployment Details' => '返回到部署详情',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '系统维护管理',
        'Schedule New System Maintenance' => '安排新的系统维护',
        'Filter for System Maintenances' => '系统维护过滤器',
        'Filter for system maintenances' => '系统维护过滤器',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '安排一个系统维护期会通知服务人员或用户：本系统在这个时间段停止使用。',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '当到达维护时间之前, 当前登录到系统的用户将会在屏幕上收到一个通知。',
        'Stop date' => '结束时间',
        'Delete System Maintenance' => '删除系统维护',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '编辑系统维护',
        'Edit System Maintenance Information' => '编辑系统维护信息',
        'Date invalid!' => '日期无效!',
        'Login message' => '登录消息',
        'This field must have less then 250 characters.' => '这个字段不能超过250个字符。',
        'Show login message' => '显示登录消息',
        'Notify message' => '通知消息',
        'Manage Sessions' => '管理会话',
        'All Sessions' => '所有会话',
        'Agent Sessions' => '服务人员会话',
        'Customer Sessions' => '客户会话',
        'Kill all Sessions, except for your own' => '终止除本会话外的所有会话',

        # Template: AdminTemplate
        'Template Management' => '模板管理',
        'Add Template' => '添加模板',
        'Edit Template' => '编辑模板',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '模板就是一些能帮助服务人员快速创建、回复或转发工单的默认文本。',
        'Don\'t forget to add new templates to queues.' => '别忘了将新模板分配给队列。',
        'Attachments' => '附件',
        'Delete this entry' => '删除该条目',
        'Do you really want to delete this template?' => '您真的想要删除这个模板吗？',
        'A standard template with this name already exists!' => '模板名称已存在！',
        'Template' => '模版',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => '“Create创建”类型的模板只支持以下智能标签',
        'Example template' => '模板样例',
        'The current ticket state is' => '当前工单状态是',
        'Your email address is' => '你的邮件地址是',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '管理模板和附件的关联',
        'Toggle active for all' => '全部激活/不激活',
        'Link %s to selected %s' => '链接 %s 到选中的 %s',

        # Template: AdminType
        'Type Management' => '工单类型管理',
        'Add Type' => '添加工单类型',
        'Edit Type' => '编辑工单类型',
        'Filter for Types' => '类型过滤器',
        'Filter for types' => '类型过滤器',
        'A type with this name already exists!' => '类型名字已存在!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '这个类型已存在于系统配置的一个设置中，需要更新设置以确认指向新的类型态！',
        'This type is used in the following config settings:' => '这个类型已用于以下的系统配置设置：',

        # Template: AdminUser
        'Agent Management' => '服务人员管理',
        'Edit Agent' => '编辑服务人员',
        'Edit personal preferences for this agent' => '编辑这个服务人员的个人偏好设置',
        'Agents will be needed to handle tickets.' => '处理工单是需要服务人员的。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '别忘了为新增的服务人员分配组或角色权限！',
        'Please enter a search term to look for agents.' => '请输入一个搜索条件以便查找服务人员。',
        'Last login' => '最后一次登录',
        'Switch to agent' => '切换到服务人员',
        'Title or salutation' => '标题或问候语',
        'Firstname' => '名',
        'Lastname' => '姓',
        'A user with this username already exists!' => '这个用户名已被使用!',
        'Will be auto-generated if left empty.' => '如果为空，将自动生成密码。',
        'Mobile' => '手机',
        'Effective Permissions for Agent' => '服务人员的有效权限',
        'This agent has no group permissions.' => '这个服务人员没有组权限。',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '上表显示了服务人员的有效组权限。 矩阵考虑了所有继承的权限（例如通过角色继承）。',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '管理服务人员的组权限',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => '日程概览',
        'Manage Calendars' => '管理日历',
        'Add Appointment' => '添加预约',
        'Today' => '今天',
        'All-day' => '全天',
        'Repeat' => '重复',
        'Notification' => '通知',
        'Yes' => '是',
        'No' => '否',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '没有找到日历。请先通过管理日历界面添加一个日历。',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '添加新的预约',
        'Calendars' => '日历',

        # Template: AgentAppointmentEdit
        'Basic information' => '基本信息',
        'Date/Time' => '日期 / 时间',
        'Invalid date!' => '无效日期!',
        'Please set this to value before End date.' => '请设置这个值为结束日期之前。',
        'Please set this to value after Start date.' => '请设置这个值为开始日期之后。',
        'This an occurrence of a repeating appointment.' => '这是一个重复预约的一次时间。',
        'Click here to see the parent appointment.' => '点击这里查看父预约。',
        'Click here to edit the parent appointment.' => '点击这里编辑父预约。',
        'Frequency' => '频率',
        'Every' => '每',
        'day(s)' => '天',
        'week(s)' => '星期',
        'month(s)' => '月',
        'year(s)' => '年',
        'On' => '开',
        'Monday' => '星期一',
        'Mon' => '一',
        'Tuesday' => '星期二',
        'Tue' => '二',
        'Wednesday' => '星期三',
        'Wed' => '三',
        'Thursday' => '星期四',
        'Thu' => '四',
        'Friday' => '星期五',
        'Fri' => '五',
        'Saturday' => '星期六',
        'Sat' => '六',
        'Sunday' => '星期天',
        'Sun' => '日',
        'January' => '一月',
        'Jan' => '一月',
        'February' => '二月',
        'Feb' => '二月',
        'March' => '三月',
        'Mar' => '三月',
        'April' => '四月',
        'Apr' => '四月',
        'May_long' => '五月',
        'May' => '五月',
        'June' => '六月',
        'Jun' => '六月',
        'July' => '七月',
        'Jul' => '七月',
        'August' => '八月',
        'Aug' => '八月',
        'September' => '九月',
        'Sep' => '九月',
        'October' => '十月',
        'Oct' => '十月',
        'November' => '十一月',
        'Nov' => '十一月',
        'December' => '十二月',
        'Dec' => '十二月',
        'Relative point of time' => '相对的时间',
        'Link' => '链接',
        'Remove entry' => '删除条目',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '客户信息中心',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '客户用户',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '注意：客户是无效的！',
        'Start chat' => '开始聊天',
        'Video call' => '视频通话',
        'Audio call' => '语音通话',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '客户用户通讯录',
        'Search for recipients and add the results as \'%s\'.' => '搜索收件人并将结果添加为“%s”。',
        'Search template' => '搜索模板',
        'Create Template' => '创建模板',
        'Create New' => '创建搜索模板',
        'Save changes in template' => '保存变更到模板',
        'Filters in use' => '正在使用的过滤器',
        'Additional filters' => '其他可用的过滤器',
        'Add another attribute' => '增加另一个搜索条件',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '标识符“（客户）”的属性来自客户单位。',
        '(e. g. Term* or *Term*)' => '（例如： Term* 或 *Term*）',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => '选择全部',
        'The customer user is already selected in the ticket mask.' => '客户用户已经在工单遮罩窗口中被选中。',
        'Select this customer user' => '选择这个客户用户',
        'Add selected customer user to' => '添加选中的客户用户到',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => '修改搜索选项',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '客户用户信息中心',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTRS守护进程用来执行异步任务，例如：触发工单升级、发送电子邮件等等。',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'OTRS守护进程正常运行是正确的系统操作所必需的。',
        'Starting the OTRS Daemon' => '正在启动OTRS守护进程',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            '确保存在文件“%s”（没有.dist扩展名）。这个CRON任务会每5分钟检查一次OTRS守护进程是否在运行，并在需要时启动它。',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            '执行\'%s start\'确保\'otrs\'用户的cron任务是活动的。',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            '5分钟后，在系统中执行\'bin/otrs.Daemon.pl status\'，检查OTRS守护进程是否正常运行。',

        # Template: AgentDashboard
        'Dashboard' => '仪表板',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '新建预约',
        'Tomorrow' => '明天',
        'Soon' => '很快',
        '5 days' => '5天',
        'Start' => '开始',
        'none' => '无',

        # Template: AgentDashboardCalendarOverview
        'in' => '之内',

        # Template: AgentDashboardCommon
        'Save settings' => '保存设置',
        'Close this widget' => '关闭这个小部件',
        'more' => '更多',
        'Available Columns' => '可用的字段',
        'Visible Columns (order by drag & drop)' => '显示的字段(可通过拖放调整顺序)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '变更客户关系',
        'Open' => 'Open（处理中）',
        'Closed' => '已关闭',
        '%s open ticket(s) of %s' => '%s个处理中的工单，共%s个',
        '%s closed ticket(s) of %s' => '%s个已关闭的工单，共%s个',
        'Edit customer ID' => '编辑客户ID',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '升级的工单',
        'Open tickets' => '处理中的工单',
        'Closed tickets' => '已关闭的工单',
        'All tickets' => '所有工单',
        'Archived tickets' => '归档的工单',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '注意：客户用户无效！',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '客户用户信息',
        'Phone ticket' => '电话工单',
        'Email ticket' => '邮件工单',
        'New phone ticket from %s' => '来自于%s新的电话工单',
        'New email ticket to %s' => '给%s新的邮件工单',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s可用了！',
        'Please update now.' => '请现在更新。',
        'Release Note' => '版本说明',
        'Level' => '级别',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '发布于%s之前。',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '统计widget（小部件）的配置有错误，请检查你的设置。',
        'Download as SVG file' => '下载为SVG格式的文件',
        'Download as PNG file' => '下载为PNG格式的文件',
        'Download as CSV file' => '下载为CSV格式的文件',
        'Download as Excel file' => '下载为Excel格式的文件',
        'Download as PDF file' => '下载为PDF格式的文件',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '请为统计小部件选择有效的图形输出格式。',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '正在为你处理统计数据，请耐心等待。',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '这个统计当前还不能使用，需要统计管理员校正配置。',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '分配给客户用户',
        'Accessible for customer user' => '客户用户可访问',
        'My locked tickets' => '我锁定的工单',
        'My watched tickets' => '我关注的工单',
        'My responsibilities' => '我负责的工单',
        'Tickets in My Queues' => '我的队列中的工单',
        'Tickets in My Services' => '我服务的工单',
        'Service Time' => '服务时间',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '合计',

        # Template: AgentDashboardUserOnline
        'out of office' => '不在办公室',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '直到',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => '接收新闻、许可证或者一些变更信息。',
        'Yes, accepted.' => '是的，接受。',

        # Template: AgentLinkObject
        'Manage links for %s' => '管理%s的链接',
        'Create new links' => '创建新链接',
        'Manage existing links' => '管理现有链接',
        'Link with' => '链接到',
        'Start search' => '开始搜索',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '目前没有链接。 请点击顶部的“创建新链接”将此项目链接到其他对象。',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '检测到未经授权的使用 %s',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '如果决定降级到 ((OTRS)) 社区版，会丢失%s相关的所有数据库表及其数据。',

        # Template: AgentPreferences
        'Edit your preferences' => '编辑个人设置',
        'Personal Preferences' => '个人偏好设置',
        'Preferences' => '偏好设置',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '请注意：你现在编辑的是%s的偏好设置。',
        'Go back to editing this agent' => '去编辑这个服务人员',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '设置你的个人偏好。 通过单击右侧的钩形符号来保存每个设置。',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '你可以使用下面的导航树仅显示某些组的设置。',
        'Dynamic Actions' => '动态操作',
        'Filter settings...' => '过滤设置...',
        'Filter for settings' => '设置过滤器',
        'Save all settings' => '保存所有设置',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '头像功能已被系统管理员禁用，此处用你的简称替代。',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '你可以注册您的电子邮件地址%s（在%s）来更改您的头像图像。 请注意，由于缓存，可能需要一些时间才能使你的新头像变得可用。',
        'Off' => '关',
        'End' => '结束',
        'This setting can currently not be saved.' => '此设置目前无法保存。',
        'This setting can currently not be saved' => '此设置目前无法保存',
        'Save this setting' => '保存该设置',
        'Did you know? You can help translating OTRS at %s.' => '你知道吗? 你也可以通过%s帮助翻译 OTRS。',

        # Template: SettingsList
        'Reset to default' => '重置为默认',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '从右侧的组中选择您想要更改的设置。',
        'Did you know?' => '你知道吗？',
        'You can change your avatar by registering with your email address %s on %s' =>
            '你可以注册您的电子邮件地址%s（在%s网站）来更改你的头像',

        # Template: AgentSplitSelection
        'Target' => '目标',
        'Process' => '流程',
        'Split' => '拆分',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '统计管理',
        'Add Statistics' => '添加统计',
        'Read more about statistics in OTRS' => '详细了解OTR关于统计的信息',
        'Dynamic Matrix' => '动态矩阵',
        'Each cell contains a singular data point.' => '每个单元格包含一个单数据点。',
        'Dynamic List' => '动态列表',
        'Each row contains data of one entity.' => '每行包含一个实体的数据。',
        'Static' => '静态',
        'Non-configurable complex statistics.' => '不可配置的复杂统计。',
        'General Specification' => '一般设定',
        'Create Statistic' => '创建统计',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '编辑统计',
        'Run now' => '立即运行',
        'Statistics Preview' => '统计预览',
        'Save Statistic' => '保存统计',

        # Template: AgentStatisticsImport
        'Import Statistics' => '导入统计',
        'Import Statistics Configuration' => '导入统计配置',

        # Template: AgentStatisticsOverview
        'Statistics' => '统计',
        'Run' => '运行',
        'Edit statistic "%s".' => '编辑统计“%s”。',
        'Export statistic "%s"' => '导出统计“%s”',
        'Export statistic %s' => '导出统计%s',
        'Delete statistic "%s"' => '删除统计“%s”',
        'Delete statistic %s' => '删除统计%s',

        # Template: AgentStatisticsView
        'Statistics Overview' => '统计概览',
        'View Statistics' => '查看统计',
        'Statistics Information' => '统计信息',
        'Created by' => '创建人',
        'Changed by' => '修改人',
        'Sum rows' => '行汇总',
        'Sum columns' => '列汇总',
        'Show as dashboard widget' => '以仪表板小部件显示',
        'Cache' => '缓存',
        'This statistic contains configuration errors and can currently not be used.' =>
            '统计包含有错误配置，当前不能使用。',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '修改%s%s%s的自由文本',
        'Change Owner of %s%s%s' => '变更工单%s%s%s的所有者',
        'Close %s%s%s' => '关闭%s%s%s',
        'Add Note to %s%s%s' => '添加备注到',
        'Set Pending Time for %s%s%s' => '为%s%s%s添加挂起时间',
        'Change Priority of %s%s%s' => '变更工单%s%s%s的优先级',
        'Change Responsible of %s%s%s' => '变更工单%s%s%s的负责人',
        'All fields marked with an asterisk (*) are mandatory.' => '所有带“*”的字段都是强制要求输入的字段.',
        'The ticket has been locked' => '工单已锁定',
        'Undo & close' => '撤销并关闭',
        'Ticket Settings' => '工单设置',
        'Queue invalid.' => '队列无效。',
        'Service invalid.' => '服务无效。',
        'SLA invalid.' => 'SLA无效。',
        'New Owner' => '新的所有者',
        'Please set a new owner!' => '请指定新的所有者！',
        'Owner invalid.' => '所有者无效。',
        'New Responsible' => '新的负责人',
        'Please set a new responsible!' => '请指定新的负责人！',
        'Responsible invalid.' => '负责人无效。',
        'Next state' => '工单下一状态',
        'State invalid.' => '状态无效。',
        'For all pending* states.' => '适用于各种挂起状态。',
        'Add Article' => '添加信件',
        'Create an Article' => '创建一封信件',
        'Inform agents' => '通知服务人员',
        'Inform involved agents' => '通知相关服务人员',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '你可以在这里选择额外的服务人员，以收到这封信件的通知。',
        'Text will also be received by' => '内容也将被以下人员接收到',
        'Text Template' => '内容模板',
        'Setting a template will overwrite any text or attachment.' => '设置一个模板将覆盖任何文本或附件。',
        'Invalid time!' => '无效时间!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '退回%s%s%s',
        'Bounce to' => '退回到',
        'You need a email address.' => '需要一个邮件地址。',
        'Need a valid email address or don\'t use a local email address.' =>
            '需要一个有效的邮件地址，不可以使用本地邮件地址。',
        'Next ticket state' => '工单下一状态',
        'Inform sender' => '通知发送者',
        'Send mail' => '发送邮件',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '工单批量操作',
        'Send Email' => '发送邮件',
        'Merge' => '合并',
        'Merge to' => '合并到',
        'Invalid ticket identifier!' => '无效的工单标识符!',
        'Merge to oldest' => '合并到最早提交的工单',
        'Link together' => '相互链接',
        'Link to parent' => '链接到上一级',
        'Unlock tickets' => '解锁工单',
        'Execute Bulk Action' => '执行批量操作',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '撰写工单%s%s%s的回复邮件',
        'This address is registered as system address and cannot be used: %s' =>
            '这个邮件地址：%s已被注册为系统邮件地址，不能使用。',
        'Please include at least one recipient' => '请包括至少一个收件人',
        'Select one or more recipients from the customer user address book.' =>
            '从客户用户通讯录中选择一个或多个收件人。',
        'Customer user address book' => '客户用户通讯录',
        'Remove Ticket Customer' => '移除工单客户',
        'Please remove this entry and enter a new one with the correct value.' =>
            '请删除这个条目并重新输入一个正确的值。',
        'This address already exists on the address list.' => '地址列表已有这个地址。',
        'Remove Cc' => '移除Cc',
        'Bcc' => '暗送',
        'Remove Bcc' => '移除Bcc',
        'Date Invalid!' => '日期无效！',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '变更工单%s%s%s的客户',
        'Customer Information' => '客户信息',
        'Customer user' => '客户用户',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '创建邮件工单',
        'Example Template' => '模板样例',
        'From queue' => '从队列',
        'To customer user' => '选择客户用户',
        'Please include at least one customer user for the ticket.' => '请包括至少一个客户用户。',
        'Select this customer as the main customer.' => '选择这个客户用户作为主要联系人。',
        'Remove Ticket Customer User' => '移除客户用户',
        'Get all' => '获取全部',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '%s%s%s的外发邮件',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '重新发送电子邮件给%s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '工单%s：首次响应时间已超时(%s/%s)！',
        'Ticket %s: first response time will be over in %s/%s!' => '工单%s：首次响应时间将在%s/%s内超时！',
        'Ticket %s: update time is over (%s/%s)!' => '工单%s：更新时间已超时(%s/%s)！',
        'Ticket %s: update time will be over in %s/%s!' => '工单%s: 更新时间将在%s/%s内超时！',
        'Ticket %s: solution time is over (%s/%s)!' => '工单%s: 解决时间已超时(%s/%s)！',
        'Ticket %s: solution time will be over in %s/%s!' => '工单%s：解决时间将在%s/%s内超时！',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '转发%s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '%s%s%s历史',
        'Filter for history items' => '历史条目过滤器',
        'Expand/collapse all' => '全部展开/折叠',
        'CreateTime' => '创建时间',
        'Article' => '信件',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '合并%s%s%s',
        'Merge Settings' => '合并设置',
        'You need to use a ticket number!' => '您需要使用一个工单编号!',
        'A valid ticket number is required.' => '需要有效的工单编号。',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '尝试输入工单编号或标题的一部分，以便进行搜索。',
        'Limit the search to tickets with same Customer ID (%s).' => '仅搜索具有相同客户ID（%s）的工单。',
        'Inform Sender' => '通知发送者',
        'Need a valid email address.' => '需要有效的邮件地址。',

        # Template: AgentTicketMove
        'Move %s%s%s' => '转移%s%s%s',
        'New Queue' => '新队列',
        'Move' => '转移',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => '没有找到工单数据。',
        'Open / Close ticket action menu' => '处理/关闭工单动作的菜单',
        'Select this ticket' => '选择这个工单',
        'Sender' => '发件人',
        'First Response Time' => '首次响应时间',
        'Update Time' => '更新时间',
        'Solution Time' => '解决时间',
        'Move ticket to a different queue' => '将工单转移到另一个队列',
        'Change queue' => '更改队列',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => '清除这个屏幕的过滤器。',
        'Tickets per page' => '工单数/页',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '频道丢失',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '刷新概览视图',
        'Column Filters Form' => '字段过滤器表单',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '拆分为新的电话工单',
        'Save Chat Into New Phone Ticket' => '保存聊天为新的电话工单',
        'Create New Phone Ticket' => '创建电话工单',
        'Please include at least one customer for the ticket.' => '请包括至少一个客户用户。',
        'To queue' => '队列',
        'Chat protocol' => '聊天协议',
        'The chat will be appended as a separate article.' => '将聊天内容作为单独的信件追加到工单。',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '%s%s%s的电话',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '查看%s%s%s的邮件纯文本',
        'Plain' => '纯文本',
        'Download this email' => '下载该邮件',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '创建流程工单',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '注册工单到一个流程',

        # Template: AgentTicketSearch
        'Profile link' => '按模板搜索',
        'Output' => '搜索结果格式为',
        'Fulltext' => '全文',
        'Customer ID (complex search)' => 'CustomerID(复合搜索)',
        '(e. g. 234*)' => '(例如： 234*)',
        'Customer ID (exact match)' => 'CustomerID(精确匹配)',
        'Assigned to Customer User Login (complex search)' => '分配给客户用户登录名（复杂搜索）',
        '(e. g. U51*)' => '(例如：U51*)',
        'Assigned to Customer User Login (exact match)' => '分配给客户用户登录名（精确匹配）',
        'Accessible to Customer User Login (exact match)' => '可访问的客户用户登录名（精确匹配）',
        'Created in Queue' => '由队列中创建',
        'Lock state' => '锁定状态',
        'Watcher' => '关注人',
        'Article Create Time (before/after)' => '信件创建时间（在...之前/之后）',
        'Article Create Time (between)' => '信件创建时间（在...之间）',
        'Please set this to value before end date.' => '请设置这个值为结束日期之前。',
        'Please set this to value after start date.' => '请设置这个值为开始日期之后。',
        'Ticket Create Time (before/after)' => '工单创建时间（在...之前/之后）',
        'Ticket Create Time (between)' => '工单创建时间（在...之间）',
        'Ticket Change Time (before/after)' => '工单修改时间（在...之前/之后）',
        'Ticket Change Time (between)' => '工单修改时间（在...之间）',
        'Ticket Last Change Time (before/after)' => '工单最后修改时间（在...之前/之后）',
        'Ticket Last Change Time (between)' => '工单最后修改时间（在...之间）',
        'Ticket Pending Until Time (before/after)' => '工单挂起待定时间（之前/之后）',
        'Ticket Pending Until Time (between)' => '工单挂起待定时间（在...之间）',
        'Ticket Close Time (before/after)' => '工单关闭时间（在...之前/之后）',
        'Ticket Close Time (between)' => '工单关闭时间（在...之间）',
        'Ticket Escalation Time (before/after)' => '工单升级时间（在...之前/之后）',
        'Ticket Escalation Time (between)' => '工单升级时间（在...之间）',
        'Archive Search' => '归档搜索',

        # Template: AgentTicketZoom
        'Sender Type' => '发送人类型',
        'Save filter settings as default' => '将过滤器设置保存为默认过滤器',
        'Event Type' => '事件类型',
        'Save as default' => '保存为默认',
        'Drafts' => '草稿',
        'by' => '由',
        'Change Queue' => '改变队列',
        'There are no dialogs available at this point in the process.' =>
            '目前流程中没有可用的活动对话框。',
        'This item has no articles yet.' => '此条目还没有信件。',
        'Ticket Timeline View' => '工单时间轴视图',
        'Article Overview - %s Article(s)' => '信件概览-%s个信件',
        'Page %s' => '第%s页',
        'Add Filter' => '添加过滤器',
        'Set' => '设置',
        'Reset Filter' => '重置过滤器',
        'No.' => 'NO.',
        'Unread articles' => '未读信件',
        'Via' => '通过',
        'Important' => '重要',
        'Unread Article!' => '未读信件!',
        'Incoming message' => '接收的消息',
        'Outgoing message' => '发出的消息',
        'Internal message' => '内部消息',
        'Sending of this message has failed.' => '发送这个消息已失败。',
        'Resize' => '调整大小',
        'Mark this article as read' => '标记该信件为已读',
        'Show Full Text' => '显示详细内容',
        'Full Article Text' => '详细内容',
        'No more events found. Please try changing the filter settings.' =>
            '没有找到更多的事件，请尝试修改过滤器设置。',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => '通过%s',
        'by %s' => '来自%s',
        'Toggle article details' => '切换信件详情',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '此消息正在处理中。 已尝试发送%s次，下次重试将在%s。',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '要打开工单里的链接, 你可能需要单击链接的同时按住Ctrl或Cmd或Shift键(取决于您的浏览器和操作系统 ).',
        'Close this message' => '关闭本消息',
        'Image' => '图片',
        'PDF' => 'PDF',
        'Unknown' => '未知',
        'View' => '查看',

        # Template: LinkTable
        'Linked Objects' => '连接的对象',

        # Template: TicketInformation
        'Archive' => '归档',
        'This ticket is archived.' => '该工单已归档。',
        'Note: Type is invalid!' => '注意：类型无效！',
        'Pending till' => '挂起至',
        'Locked' => '锁定状态',
        '%s Ticket(s)' => '%s个工单',
        'Accounted time' => '所用工时',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '由于系统丢失了%s频道，无法预览该信件。',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '此功能是%s的一部分， 请通过%s与我们联系以进行升级。',
        'Please re-install %s package in order to display this article.' =>
            '请重新安装%s软件包以显示该信件。',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '为了保护你的隐私,远程内容被阻挡。',
        'Load blocked content.' => '载入被阻挡的内容。',

        # Template: Breadcrumb
        'Home' => '首页',
        'Back to admin overview' => '返回到系统管理概览',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '这个功能需要启用云服务',
        'You can' => '你可以',
        'go back to the previous page' => '返回上一页',

        # Template: CustomerAccept
        'Dear Customer,' => '尊敬的客户，',
        'thank you for using our services.' => '感谢您使用我们的服务。',
        'Yes, I accept your license.' => '是，同意许可。',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '客户ID不可更改，不能将其他客户ID分配给这个工单。',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '首先选择一个客户用户，然后你可以选择一个客户ID来分配给这个工单。',
        'Select a customer ID to assign to this ticket.' => '选择要分配给这个工单的客户ID。',
        'From all Customer IDs' => '从所有的客户ID',
        'From assigned Customer IDs' => '从已分配的客户ID',

        # Template: CustomerError
        'An Error Occurred' => '发生了一个错误',
        'Error Details' => '详细错误信息',
        'Traceback' => '追溯',

        # Template: CustomerFooter
        '%s powered by %s™' => '%s由%s™提供技术支持',
        'Powered by %s™' => '由%s™提供技术支持',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s发现可能有网络问题。 你可以尝试手动刷新此页面，也可以等浏览器自行重连。',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '连接在临时中断后已重连，因此本页面上的元素可能已无法正常工作。为了能重新正常使用所有的元素，强烈建议刷新本页面。',

        # Template: CustomerLogin
        'JavaScript Not Available' => '没有启用JavaScript',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '为了体验这个软件，你需要在浏览器中启用JavaScript。',
        'Browser Warning' => '浏览器的警告',
        'The browser you are using is too old.' => '你使用的游览器版本太老了。',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '本软件可以在大量的浏览器中运行，请升级到其中之一。',
        'Please see the documentation or ask your admin for further information.' =>
            '欲了解更多信息, 请向你的管理询问或参考相关文档.',
        'One moment please, you are being redirected...' => '请稍候，正在重定向...',
        'Login' => '登录',
        'User name' => '用户名',
        'Your user name' => '你的用户名',
        'Your password' => '你的密码',
        'Forgot password?' => '密码忘记?',
        '2 Factor Token' => '双因素令牌',
        'Your 2 Factor Token' => '你的双因素令牌',
        'Log In' => '登录',
        'Not yet registered?' => '还未注册?',
        'Back' => '后退',
        'Request New Password' => '请求新密码',
        'Your User Name' => '你的用户名',
        'A new password will be sent to your email address.' => '新密码将会发送到您的邮箱中。',
        'Create Account' => '创建帐户',
        'Please fill out this form to receive login credentials.' => '请填写这个表单以便接收登录凭证。',
        'How we should address you' => '称谓',
        'Your First Name' => '名字',
        'Your Last Name' => '姓',
        'Your email address (this will become your username)' => '您的邮件地址（这将是你的登录用户名）',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '进入的聊天请求',
        'Edit personal preferences' => '编辑个人偏好设置',
        'Logout %s' => '注销 %s',

        # Template: CustomerTicketMessage
        'Service level agreement' => '服务级别协议',

        # Template: CustomerTicketOverview
        'Welcome!' => '欢迎！',
        'Please click the button below to create your first ticket.' => '请点击下面的按钮创建第一个工单。',
        'Create your first ticket' => '创建第一个工单',

        # Template: CustomerTicketSearch
        'Profile' => '搜索条件',
        'e. g. 10*5155 or 105658*' => '例如: 10*5155 或 105658*',
        'CustomerID' => 'CustomerID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '对工单进行全文搜索（例如 "John*n" 或 "Will*"）',
        'Types' => '类型',
        'Time Restrictions' => '时间限制',
        'No time settings' => '没有设置时间',
        'All' => '全部',
        'Specific date' => '指定日期',
        'Only tickets created' => '仅工单创建时间',
        'Date range' => '日期范围',
        'Only tickets created between' => '仅工单创建时间区间',
        'Ticket Archive System' => '工单归档系统',
        'Save Search as Template?' => '将搜索保存为模板吗？',
        'Save as Template?' => '保存为模板吗？',
        'Save as Template' => '保存为模板',
        'Template Name' => '模板名称',
        'Pick a profile name' => '输入模板名称',
        'Output to' => '输出为',

        # Template: CustomerTicketSearchResultShort
        'of' => '在',
        'Page' => '页',
        'Search Results for' => '以下条件的搜索结果',
        'Remove this Search Term.' => '移除这个搜索词。',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '从这个工单开始一次聊天',
        'Next Steps' => '下一步',
        'Reply' => '回复',

        # Template: Chat
        'Expand article' => '展开信件',

        # Template: CustomerWarning
        'Warning' => '警告',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => '事件信息',
        'Ticket fields' => '工单字段',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '真的是一个BUG吗？十个BUG报告有五个起因于错误或不完整的OTRS安装。',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '通过%s，我们的专家通过技术支持和定期安全更新来确保正确安装且后台程序正常。',
        'Contact our service team now.' => '现在就联系我们的服务团队。',
        'Send a bugreport' => '发送一个BUG报告',
        'Expand' => '展开',

        # Template: AttachmentList
        'Click to delete this attachment.' => '点击以删除这个附件。',

        # Template: DraftButtons
        'Update draft' => '更新草稿',
        'Save as new draft' => '另存为新的草稿',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '你已加载草稿“%s”。',
        'You have loaded the draft "%s". You last changed it %s.' => '你已加载草稿“%s”。 你最后更改了%s。',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '你已加载草稿“%s”。 最后更改了%s的是%s。',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '请注意，这个草稿已经过时了，因为这个草稿创建后该工单已经被修改过了。',

        # Template: Header
        'View notifications' => '查看通知',
        'Notifications' => '通知',
        'Notifications (OTRS Business Solution™)' => '通知 (OTRS商业版)',
        'Personal preferences' => '个人偏好设置',
        'Logout' => '注销',
        'You are logged in as' => '您已登录为',

        # Template: Installer
        'JavaScript not available' => 'JavaScript没有启用',
        'Step %s' => '第%s步',
        'License' => '许可证',
        'Database Settings' => '数据库设置',
        'General Specifications and Mail Settings' => '一般设定和邮件配置',
        'Finish' => '完成',
        'Welcome to %s' => '欢迎使用%s',
        'Germany' => '德国',
        'Phone' => '电话',
        'United States' => '美国',
        'Mexico' => '墨西哥',
        'Hungary' => '匈牙利',
        'Brazil' => '巴西',
        'Singapore' => '新加坡',
        'Hong Kong' => '香港',
        'Web site' => '网址',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '外发邮件配置',
        'Outbound mail type' => '外发邮件类型',
        'Select outbound mail type.' => '选择外发邮件类型。',
        'Outbound mail port' => '外发邮件端口',
        'Select outbound mail port.' => '选择外发邮件端口。',
        'SMTP host' => 'SMTP服务器',
        'SMTP host.' => 'SMTP服务器。',
        'SMTP authentication' => 'SMTP认证',
        'Does your SMTP host need authentication?' => 'SMTP服务器是否需要认证？',
        'SMTP auth user' => 'SMTP认证用户名',
        'Username for SMTP auth.' => 'SMTP认证用户名。',
        'SMTP auth password' => 'SMTP认证密码',
        'Password for SMTP auth.' => 'SMTP认证密码。',
        'Configure Inbound Mail' => '接收邮件配置',
        'Inbound mail type' => '接收邮件类型',
        'Select inbound mail type.' => '选择接收邮件类型。',
        'Inbound mail host' => '接收邮件服务器',
        'Inbound mail host.' => '接收邮件服务器。',
        'Inbound mail user' => '接收邮件用户名',
        'User for inbound mail.' => '接收邮件用户名。',
        'Inbound mail password' => '接收邮件密码',
        'Password for inbound mail.' => '接收邮件密码。',
        'Result of mail configuration check' => '邮件配置检查结果',
        'Check mail configuration' => '检查邮件配置',
        'Skip this step' => '跳过这一步',

        # Template: InstallerDBResult
        'Done' => '完成',
        'Error' => 'Error（错误）',
        'Database setup successful!' => '数据库设置成功！',

        # Template: InstallerDBStart
        'Install Type' => '安装类型',
        'Create a new database for OTRS' => '为OTRS创建新的数据库',
        'Use an existing database for OTRS' => '使用现有的OTRS数据库',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '如果你的数据库为root设置了密码，你必须在这里输入；否则，该字段为空。',
        'Database name' => '数据库名称',
        'Check database settings' => '测试数据库设置',
        'Result of database check' => '数据库检查结果',
        'Database check successful.' => '数据库检查完成。',
        'Database User' => '数据库用户',
        'New' => 'New（新建）',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            '已经为OTRS系统创建了新的数据库普通用户。',
        'Repeat Password' => '重复输入密码',
        'Generated password' => '自动生成的密码',

        # Template: InstallerDBmysql
        'Passwords do not match' => '密码不匹配',

        # Template: InstallerDBoracle
        'SID' => '实例名',
        'Port' => '端口',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            '为了能够使用OTRS, 您必须以root身份在命令行中(Terminal/Shell)输入以下行。',
        'Restart your webserver' => '重启web服务器',
        'After doing so your OTRS is up and running.' => '完成这些后，您的OTRS系统就启动并运行了。',
        'Start page' => '开始页面',
        'Your OTRS Team' => 'OTRS团队',

        # Template: InstallerLicense
        'Don\'t accept license' => '不同意许可',
        'Accept license and continue' => '同意许可并继续',

        # Template: InstallerSystem
        'SystemID' => '系统ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '系统的标识符，每个工单编号和HTTP会话ID均包含系统ID。',
        'System FQDN' => '系统正式域名',
        'Fully qualified domain name of your system.' => '系统FQDN（正式域名）。',
        'AdminEmail' => '管理员地址',
        'Email address of the system administrator.' => '系统管理员邮件地址。',
        'Organization' => '组织',
        'Log' => '日志',
        'LogModule' => '日志模块',
        'Log backend to use.' => '日志后端使用。',
        'LogFile' => '日志文件',
        'Webfrontend' => 'Web前端',
        'Default language' => '默认语言',
        'Default language.' => '默认语言。',
        'CheckMXRecord' => '检查MX记录',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '手动输入的电子邮件地址将通过DNS服务器验证MX记录。如果DNS服务器响应慢或无法提供公网解析，请不要使用此选项。',

        # Template: LinkObject
        'Delete link' => '删除链接',
        'Delete Link' => '删除链接',
        'Object#' => '对象号',
        'Add links' => '添加链接',
        'Delete links' => '删除链接',

        # Template: Login
        'Lost your password?' => '忘记密码?',
        'Back to login' => '重新登录',

        # Template: MetaFloater
        'Scale preview content' => '缩放预览内容',
        'Open URL in new tab' => '在新的标签页打开链接',
        'Close preview' => '关闭预览',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '这个网站不允许被嵌入，无法提供预览。',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '功能不可用',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '抱歉，当前的OTRS不能用于移动终端。如果你想在移动终端上使用，你可以切换到桌面模式或使用普通桌面终端。',

        # Template: Motd
        'Message of the Day' => '今日消息',
        'This is the message of the day. You can edit this in %s.' => '这是今日消息，你可以在文件%s中编辑它的内容。',

        # Template: NoPermission
        'Insufficient Rights' => '没有足够的权限',
        'Back to the previous page' => '返回前一页',

        # Template: Alert
        'Alert' => '警告',
        'Powered by' => '技术支持：',

        # Template: Pagination
        'Show first page' => '首页',
        'Show previous pages' => '前一页',
        'Show page %s' => '第%s页',
        'Show next pages' => '后一页',
        'Show last page' => '尾页',

        # Template: PictureUpload
        'Need FormID!' => '需要FormID！',
        'No file found!' => '找不到文件！',
        'The file is not an image that can be shown inline!' => '此文件是不是一个可以显示的图像!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '没有找到可以配置的通知。',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '接收通知\'%s\'的消息，通过传输方法\'%s\'。',

        # Template: ActivityDialogHeader
        'Process Information' => '流程信息',
        'Dialog' => '对话框',

        # Template: Article
        'Inform Agent' => '通知服务人员',

        # Template: PublicDefault
        'Welcome' => '欢迎',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '这是OTRS默认的公共界面！没有操作参数。',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '你可以安装一个定制的有公共界面的公共模块（通过软件包管理器），例如FAQ知识库模块。',

        # Template: GeneralSpecificationsWidget
        'Permissions' => '权限',
        'You can select one or more groups to define access for different agents.' =>
            '你可以为不同的服务人员选择一个或多个组以定义访问权限。',
        'Result formats' => '结果格式',
        'Time Zone' => '时区',
        'The selected time periods in the statistic are time zone neutral.' =>
            '统计的选定时间段是时区中立的（无时区）。',
        'Create summation row' => '创建汇总行',
        'Generate an additional row containing sums for all data rows.' =>
            '生成一个额外的行来包含所有数据行的汇总。',
        'Create summation column' => '创建汇总列',
        'Generate an additional column containing sums for all data columns.' =>
            '生成一个额外的列来包含所有数据列的汇总。',
        'Cache results' => '缓存结果',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '在缓存中保存统计结果，以便在相同配置（需要至少一个选定的时间字段）时能够用于随后的视图。',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '将该统计变为小部件，以便服务人员能够在仪表板中激活使用。',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '请注意，这个统计启用为仪表板小部件将激活缓存功能。',
        'If set to invalid end users can not generate the stat.' => '如果设置为无效，将无法生成统计。',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '这个统计的配置还有如下问题：',
        'You may now configure the X-axis of your statistic.' => '你可以现在配置统计的X轴（横坐标轴）。',
        'This statistic does not provide preview data.' => '这个统计没有预览数据。',
        'Preview format' => '预览格式',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '请注意，预览使用随机数据，并且没有过滤数据。',
        'Configure X-Axis' => '配置X轴',
        'X-axis' => 'X轴',
        'Configure Y-Axis' => '配置Y轴',
        'Y-axis' => 'Y轴',
        'Configure Filter' => '配置过滤器',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '请只选择一个元素或使“固定”复选框未被选中。',
        'Absolute period' => '绝对时间段',
        'Between %s and %s' => '在%s 和 %s之间',
        'Relative period' => '相对时间段',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '过去完成%s，当前和即将完成%s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            '统计生成后不允许修改这个元素。',

        # Template: StatsParamsWidget
        'Format' => '格式',
        'Exchange Axis' => '转换坐标轴',
        'Configurable Params of Static Stat' => '静态统计的可配置参数',
        'No element selected.' => '没有选择元素。',
        'Scale' => '时间刻度',
        'show more' => '显示更多',
        'show less' => '收起',

        # Template: D3
        'Download SVG' => '下载SVG',
        'Download PNG' => '下载PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '选定的时间段定义了统计收集数据的默认时间范围。',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '定义报表中数据点拆分为选定时间区间的时间间隔。',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '请记住：Y轴的时间刻度必须大于X轴的时间刻度（例如：X轴=>月，Y轴=>年）。',

        # Template: SettingsList
        'This setting is disabled.' => '这个设置已被禁用。',
        'This setting is fixed but not deployed yet!' => '这个设置已修正，但尚未部署！',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '这个设置目前已在%s中覆盖，所以无法在这里更改！',
        'Changing this setting is only available in a higher config level!' =>
            '更改此设置仅适用于更高的配置级别！',
        '%s (%s) is currently working on this setting.' => '%s（%s）正在处理这个设置。',
        'Toggle advanced options for this setting' => '显示/隐藏此设置的高级选项',
        'Disable this setting, so it is no longer effective' => '禁用此设置，因此它不再有效',
        'Disable' => '禁用',
        'Enable this setting, so it becomes effective' => '启用此设置，使其生效',
        'Enable' => '启用',
        'Reset this setting to its default state' => '将此设置重置为默认状态',
        'Reset setting' => '重置设置',
        'Allow users to adapt this setting from within their personal preferences' =>
            '允许用户从个人偏好设置中调整这个设置',
        'Allow users to update' => '允许用户更新',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '不再允许用户在个人偏好设置中调整这个设置',
        'Forbid users to update' => '禁止用户更新',
        'Show user specific changes for this setting' => '显示这个设置的用户特定变更',
        'Show user settings' => '显示用户设置',
        'Copy a direct link to this setting to your clipboard' => '将这个设置的直接链接复制到剪贴板',
        'Copy direct link' => '复制直接链接',
        'Remove this setting from your favorites setting' => '从你的收藏夹中删除这个设置',
        'Remove from favourites' => '从收藏夹中移除',
        'Add this setting to your favorites' => '将这个设置添加到你的收藏夹',
        'Add to favourites' => '添加到收藏夹',
        'Cancel editing this setting' => '取消编辑这个设置',
        'Save changes on this setting' => '保存这个设置的更改',
        'Edit this setting' => '编辑这个设置',
        'Enable this setting' => '启用这个设置',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '此组不包含任何设置。 请尝试浏览其中一个子组或另一个组。',

        # Template: SettingsListCompare
        'Now' => '立即',
        'User modification' => '用户修改',
        'enabled' => '已启用',
        'disabled' => '已禁用',
        'Setting state' => '设置状态',

        # Template: Actions
        'Edit search' => '编辑搜索',
        'Go back to admin: ' => '返回到系统管理： ',
        'Deployment' => '部署',
        'My favourite settings' => '我收藏的设置',
        'Invalid settings' => '设置无效',

        # Template: DynamicActions
        'Filter visible settings...' => '过滤可见的设置...',
        'Enable edit mode for all settings' => '启用所有设置的编辑模式',
        'Save all edited settings' => '保存所有编辑过的设置',
        'Cancel editing for all settings' => '取消编辑所有设置',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '这个小部件的所有操作仅适用于右侧可见的设置。',

        # Template: Help
        'Currently edited by me.' => '目前由我编辑。',
        'Modified but not yet deployed.' => '已修改但尚未部署。',
        'Currently edited by another user.' => '目前由其他用户编辑。',
        'Different from its default value.' => '与其默认值不同。',
        'Save current setting.' => '保存当前设置。',
        'Cancel editing current setting.' => '取消编辑当前设置。',

        # Template: Navigation
        'Navigation' => '导航',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '使用%s，系统配置支持版本控制、回滚和用户特定的配置设置。',

        # Template: Test
        'OTRS Test Page' => 'OTRS测试页',
        'Unlock' => '解锁',
        'Welcome %s %s' => '欢迎使用%s %s',
        'Counter' => '计数器',

        # Template: Warning
        'Go back to the previous page' => '返回前一页',

        # JS Template: CalendarSettingsDialog
        'Show' => '显示',

        # JS Template: FormDraftAddDialog
        'Draft title' => '草稿标题',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '信件显示',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '你确定要删除“%s”吗？',
        'Confirm' => '确认',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '加载中，请稍候...',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '点击以选择一个文件上传。',
        'Click to select files or just drop them here.' => '单击以选择文件或将文件拖放到这里。',
        'Click to select a file or just drop it here.' => '单击以选择一个文件或将文件拖放到这里。',
        'Uploading...' => '上传中...',

        # JS Template: InformationDialog
        'Process state' => '流程状态',
        'Running' => '正在运行',
        'Finished' => '完成',
        'No package information available.' => '没有可用的软件包信息。',

        # JS Template: AddButton
        'Add new entry' => '添加新条目',

        # JS Template: AddHashKey
        'Add key' => '添加键',

        # JS Template: DialogDeployment
        'Deployment comment...' => '部署注释...',
        'This field can have no more than 250 characters.' => '此字段不能超过250个字符。',
        'Deploying, please wait...' => '正在部署，请稍候...',
        'Preparing to deploy, please wait...' => '准备部署，请稍候...',
        'Deploy now' => '现在部署',
        'Try again' => '重试',

        # JS Template: DialogReset
        'Reset options' => '重置选项',
        'Reset setting on global level.' => '在全局级别重置设置。',
        'Reset globally' => '全局重置',
        'Remove all user changes.' => '移除所有的用户更改。',
        'Reset locally' => '本地重置',
        'user(s) have modified this setting.' => '用户已经修改过此设置。',
        'Do you really want to reset this setting to it\'s default value?' =>
            '你确定要重置这个设置到它的默认值吗？',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '可以使用类别选择来将导航树限制在选择的类别中。一旦选择了某个类别，导航树将被重新构建。',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '数据库后端',
        'CustomerIDs' => '客户ID',
        'Fax' => '传真',
        'Street' => '街道',
        'Zip' => '邮编',
        'City' => '城市',
        'Country' => '国家',
        'Valid' => '有效',
        'Mr.' => '先生',
        'Mrs.' => '女士',
        'Address' => '地址',
        'View system log messages.' => '查看系统日志信息。',
        'Edit the system configuration settings.' => '编辑系统配置。',
        'Update and extend your system with software packages.' => '更新或安装系统的软件包或模块。',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '数据库中的ACL信息与系统配置不一致，请部署所有ACL。',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '由于未知错误不能导入ACL，请检查OTRS日志以获得更多信息',
        'The following ACLs have been added successfully: %s' => '下列ACL已经成功添加：%s',
        'The following ACLs have been updated successfully: %s' => '下列ACL已经成功更新：%s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '在添加/更新下列ACL：%s 时出现一些错误，请检查OTRS日志以获得更多信息。',
        'This field is required' => '这个字段是必需的',
        'There was an error creating the ACL' => '创建ACL时出现了一个错误',
        'Need ACLID!' => '需要ACLID！',
        'Could not get data for ACLID %s' => '不能获得ACLID为%s 的数据',
        'There was an error updating the ACL' => '更新ACL时出现了一个错误',
        'There was an error setting the entity sync status.' => '设置条目同步状态时出现了一个错误。',
        'There was an error synchronizing the ACLs.' => '部署ACL时出现了一个错误。',
        'ACL %s could not be deleted' => '不能删除ACL %s',
        'There was an error getting data for ACL with ID %s' => '获得ID为%s 的ACL的数据时出现了一个错误',
        '%s (copy) %s' => '%s (副本) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '请注意，超级用户帐户（UserID 1）将忽略ACL限制。',
        'Exact match' => '完全匹配',
        'Negated exact match' => '完全匹配取反',
        'Regular expression' => '正则表达式',
        'Regular expression (ignore case)' => '正则表达式（忽略大小写）',
        'Negated regular expression' => '正则表达式取反',
        'Negated regular expression (ignore case)' => '正则表达式（忽略大小写）取反',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '系统不能创建日历！',
        'Please contact the administrator.' => '请联系系统管理员。',
        'No CalendarID!' => '没有日历ID！',
        'You have no access to this calendar!' => '你无权访问这个日历！',
        'Error updating the calendar!' => '更新日历出错！',
        'Couldn\'t read calendar configuration file.' => '不能读取日历的配置文件。',
        'Please make sure your file is valid.' => '请确保你的文件是有效的。',
        'Could not import the calendar!' => '无法导入这个日历！',
        'Calendar imported!' => '日历已导入！',
        'Need CalendarID!' => '需要日历ID！',
        'Could not retrieve data for given CalendarID' => '无法返回给定的日历ID的数据',
        'Successfully imported %s appointment(s) to calendar %s.' => '成功将预约%s导入到日历%s。',
        '+5 minutes' => '+5分钟',
        '+15 minutes' => '+15分钟',
        '+30 minutes' => '+30分钟',
        '+1 hour' => '+1小时',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '没有权限',
        'System was unable to import file!' => '系统无法导入文件！',
        'Please check the log for more information.' => '更多信息请检查日志。',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '这个通知的名字已存在!',
        'Notification added!' => '通知已添加！',
        'There was an error getting data for Notification with ID:%s!' =>
            '获取ID为%s的通知数据时出现了一个错误！',
        'Unknown Notification %s!' => '未知通知 %s！',
        '%s (copy)' => '%s (副本)',
        'There was an error creating the Notification' => '创建通知时出现了一个错误',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '由于一个未知错误不能导入通知，请检查OTRS日志以获取更多信息',
        'The following Notifications have been added successfully: %s' =>
            '下列通知已成功添加：%s',
        'The following Notifications have been updated successfully: %s' =>
            '下列通知已成功更新：%s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '添加/更新下列通知时出现错误：%s，请检查OTRS日志以获取更多信息。',
        'Notification updated!' => '通知已更新！',
        'Agent (resources), who are selected within the appointment' => '这个预约选择的服务人员（资源）',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '所有对这个预约（日历）至少有读权限的服务人员',
        'All agents with write permission for the appointment (calendar)' =>
            '所有对这个预约（日历）有写权限的服务人员',
        'Yes, but require at least one active notification method.' => '是的，但需要至少一个活动的通知方法。',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => '附件已添加！',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '自动响应已添加！',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '无效的通讯ID！',
        'All communications' => '所有通信',
        'Last 1 hour' => '最近1小时',
        'Last 3 hours' => '最近3小时',
        'Last 6 hours' => '最近6小时',
        'Last 12 hours' => '最近12小时',
        'Last 24 hours' => '最近24小时',
        'Last week' => '最近一周',
        'Last month' => '最近一月',
        'Invalid StartTime: %s!' => '无效的开始时间：%s！',
        'Successful' => '成功',
        'Processing' => '处理',
        'Failed' => '失败',
        'Invalid Filter: %s!' => '无效的过滤器：%s！',
        'Less than a second' => '不到一秒钟',
        'sorted descending' => '降序排序',
        'sorted ascending' => '升序排序',
        'Trace' => '跟踪',
        'Debug' => 'Debug（调试）',
        'Info' => 'Info（信息）',
        'Warn' => '警告',
        'days' => '天',
        'day' => '天',
        'hour' => '小时',
        'minute' => '分钟',
        'seconds' => '秒',
        'second' => '秒',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => '客户单位已更新！',
        'Dynamic field %s not found!' => '没有找到动态字段“%s”！',
        'Unable to set value for dynamic field %s!' => '不能设置动态字段%s 的值！',
        'Customer Company %s already exists!' => '客户单位 %s 已经存在！',
        'Customer company added!' => '客户单位已添加！',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '找不到\'CustomerGroupPermissionContext（客户组权限上下文）\'的配置！',
        'Please check system configuration.' => '请检查系统配置。',
        'Invalid permission context configuration:' => '无效的权限上下文配置：',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => '客户已更新！',
        'New phone ticket' => '创建电话工单',
        'New email ticket' => '创建邮件工单',
        'Customer %s added' => '客户%s已添加',
        'Customer user updated!' => '客户用户已更新！',
        'Same Customer' => '同一客户',
        'Direct' => '直接',
        'Indirect' => '间接',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '修改组的客户用户关系',
        'Change Group Relations for Customer User' => '修改客户用户的组关系',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '分配客户用户到服务',
        'Allocate Services to Customer User' => '分配服务到客户用户',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '不是有效的字段配置',
        'Objects configuration is not valid' => '不是有效的对象配置',
        'Database (%s)' => '数据库 (%s)',
        'Web service (%s)' => 'Web服务(%s)',
        'Contact with data (%s)' => '联系人信息（%s）',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '不能正确地重置动态字段顺序，请检查错误日志以获得更多详细信息。',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '没有定义的子动作。',
        'Need %s' => '需要%s',
        'Add %s field' => '添加%s字段',
        'The field does not contain only ASCII letters and numbers.' => '这个字段不是仅包含ASCII字符和数字。',
        'There is another field with the same name.' => '存在同名的另一字段。',
        'The field must be numeric.' => '这个字段必须是数字。',
        'Need ValidID' => '需要有效的ID',
        'Could not create the new field' => '不能创建这个新字段',
        'Need ID' => '需要ID',
        'Could not get data for dynamic field %s' => '不能获得动态字段%s 的数据',
        'Change %s field' => '修改%s字段',
        'The name for this field should not change.' => '不能更改这个字段的名称。',
        'Could not update the field %s' => '不能更新字段 %s',
        'Currently' => '当前',
        'Unchecked' => '未检查',
        'Checked' => '已检查',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '防止未来的日期条目',
        'Prevent entry of dates in the past' => '防止过去的日期条目',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => '这个字段值是重复的。',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '选择至少一个收件人。',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => '分钟',
        'hour(s)' => '小时',
        'Time unit' => '时间单位',
        'within the last ...' => '在最近...之内',
        'within the next ...' => '在未来...',
        'more than ... ago' => '在...之前',
        'Unarchived tickets' => '未归档的工单',
        'archive tickets' => '归档工单',
        'restore tickets from archive' => '从归档中恢复工单',
        'Need Profile!' => '需要配置文件！',
        'Got no values to check.' => '没有检查到值。',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '请移除以下不能用于工单选择的词语：',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '需要WebserviceID！',
        'Could not get data for WebserviceID %s' => '不能获得WebserviceID %s的数据',
        'ascending' => '升序',
        'descending' => '降序',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '需要通信类型！',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '通信类型需要是“Requester（请求者）”或“Provider（提供者）”！',
        'Invalid Subaction!' => '无效的子动作！',
        'Need ErrorHandlingType!' => '需要ErrorHandlingType （错误处理类型）！',
        'ErrorHandlingType %s is not registered' => 'ErrorHandlingType （错误处理类型）%s没有注册',
        'Could not update web service' => '无法更新WEB服务',
        'Need ErrorHandling' => '需要错误处理',
        'Could not determine config for error handler %s' => '无法确定错误处理程序%s的配置',
        'Invoker processing outgoing request data' => '调用模块正在处理发出的请求数据',
        'Mapping outgoing request data' => '正在匹配发出的请求数据',
        'Transport processing request into response' => '传输模块正在处理响应请求',
        'Mapping incoming response data' => '正在匹配传入的响应数据',
        'Invoker processing incoming response data' => '调用模块正在处理传入的响应数据',
        'Transport receiving incoming request data' => '传输模块正在接收传入的请求数据',
        'Mapping incoming request data' => '正在匹配传入的请求数据',
        'Operation processing incoming request data' => '操作模块正在处理传入的请求数据',
        'Mapping outgoing response data' => '正在匹配发出的响应数据',
        'Transport sending outgoing response data' => '传输模块正在发送发出的请求数据',
        'skip same backend modules only' => '只跳过相同的后台模块',
        'skip all modules' => '跳过所有模块',
        'Operation deleted' => '操作已删除',
        'Invoker deleted' => '调用程序已删除',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0秒',
        '15 seconds' => '15秒',
        '30 seconds' => '30秒',
        '45 seconds' => '45秒',
        '1 minute' => '1分钟',
        '2 minutes' => '2分钟',
        '3 minutes' => '3分钟',
        '4 minutes' => '4分钟',
        '5 minutes' => '5分钟',
        '10 minutes' => '10 分钟',
        '15 minutes' => '15 分钟',
        '30 minutes' => '30分钟',
        '1 hour' => '1小时',
        '2 hours' => '2小时',
        '3 hours' => '3小时',
        '4 hours' => '4小时',
        '5 hours' => '5小时',
        '6 hours' => '6小时',
        '12 hours' => '12小时',
        '18 hours' => '18小时',
        '1 day' => '1天',
        '2 days' => '2天',
        '3 days' => '3天',
        '4 days' => '4天',
        '6 days' => '6天',
        '1 week' => '1周',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => '不能确定调用程序%s 的配置',
        'InvokerType %s is not registered' => '调用程序类型 %s 没有注册',
        'MappingType %s is not registered' => '映射类型%s 没有注册',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '需要调用程序！',
        'Need Event!' => '需要事件！',
        'Could not get registered modules for Invoker' => '无法获得调用程序的注册模块',
        'Could not get backend for Invoker %s' => '不能获得调用程序 %s的后端',
        'The event %s is not valid.' => '事件 %s 无效。',
        'Could not update configuration data for WebserviceID %s' => '不能更新WebserviceID %s的配置数据',
        'This sub-action is not valid' => '这个子动作无效',
        'xor' => 'xor（异或）',
        'String' => '字符串',
        'Regexp' => '正则表达式',
        'Validation Module' => '验证模块',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '出站数据的简单映射',
        'Simple Mapping for Incoming Data' => '传入数据的简单映射',
        'Could not get registered configuration for action type %s' => '不能获得操作类型%s 的注册配置',
        'Could not get backend for %s %s' => '不能获得 %s %s的后端',
        'Keep (leave unchanged)' => '保持（保持不变）',
        'Ignore (drop key/value pair)' => '忽略（丢弃键/值对）',
        'Map to (use provided value as default)' => '映射到（使用提供的值作为默认值）',
        'Exact value(s)' => '准确值',
        'Ignore (drop Value/value pair)' => '忽略（丢弃键/值对）',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '出站数据的XSLT映射',
        'XSLT Mapping for Incoming Data' => '传入数据的XSLT映射',
        'Could not find required library %s' => '不能找到需要的库%s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '处理前的传出请求数据（RequesterRequestInput）',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '映射前的传出请求数据（RequesterRequestPrepareOutput）',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '映射后的传出请求数据（RequesterRequestMapOutput）',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '映射前的传入响应数据（RequesterResponseInput）',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '错误处理后的传出错误处理程序数据（RequesterErrorHandlingOutput）',
        'Incoming request data before mapping (ProviderRequestInput)' => '映射前的传入请求数据（ProviderRequestInput）',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '映射后的传入请求数据（ProviderRequestMapOutput）',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '映射前的传出响应数据（ProviderResponseInput）',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '错误处理后的传出错误处理程序数据（ProviderErrorHandlingOutput）',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => '不能确定操作%s 的配置',
        'OperationType %s is not registered' => '操作类型%s 没有注册',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '需要有效的子动作！',
        'This field should be an integer.' => '该字段应为整数。',
        'File or Directory not found.' => '找不到文件或目录。',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '存在同名的另一WEB服务。',
        'There was an error updating the web service.' => '更新WEB服务时出现了一个错误。',
        'There was an error creating the web service.' => '创建WEB服务时出现了一个错误。',
        'Web service "%s" created!' => 'Web服务“%s”已经创建！',
        'Need Name!' => '需要名称！',
        'Need ExampleWebService!' => '需要WEB服务示例！',
        'Could not load %s.' => '不能载入 %s。',
        'Could not read %s!' => '不能读取 %s！',
        'Need a file to import!' => '导入需要一个文件！',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '导入的文件没有有效的YAML内容！请检查OTRS日志以获取详细信息',
        'Web service "%s" deleted!' => 'Web服务“%s”已经删除！',
        'OTRS as provider' => 'OTRS作为服务提供方',
        'Operations' => '操作',
        'OTRS as requester' => 'OTRS作为服务请求方',
        'Invokers' => '调用程序',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '没有 WebserviceHistoryID ！',
        'Could not get history data for WebserviceHistoryID %s' => '不能获取WebserviceHistoryID为%s的历史数据',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => '组已更新！',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => '邮件账号已添加！',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '电子邮件帐户提取已被另一个进程提取。 请稍后再试！',
        'Dispatching by email To: field.' => '按收件人(To:)分派。',
        'Dispatching by selected Queue.' => '按所选队列分派。',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '创建该工单的服务人员',
        'Agent who owns the ticket' => '拥有这个工单的服务人员',
        'Agent who is responsible for the ticket' => '对这个工单负责的服务人员',
        'All agents watching the ticket' => '所有关注这个工单的服务人员',
        'All agents with write permission for the ticket' => '所有对这个工单有写权限的服务人员',
        'All agents subscribed to the ticket\'s queue' => '所有关注了工单所在队列的服务人员',
        'All agents subscribed to the ticket\'s service' => '所有关注了工单服务的服务人员',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '所有关注了工单所在队列和工单所属服务的服务人员',
        'Customer user of the ticket' => '该工单的客户用户',
        'All recipients of the first article' => '第一封信件的所有收件人',
        'All recipients of the last article' => '最近一封信件的所有收件人',
        'Invisible to customer' => '客户不可见',
        'Visible to customer' => '对客户可见',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => '你的系统已成功更新到 %s。',
        'There was a problem during the upgrade to %s.' => '升级到%s的过程中出现问题。',
        '%s was correctly reinstalled.' => '%s 已经成功重装。',
        'There was a problem reinstalling %s.' => '重装 %s 时遇到了一个问题。',
        'Your %s was successfully updated.' => '你的 %s 已经成功更新。',
        'There was a problem during the upgrade of %s.' => '升级 %s 时遇到了一个问题。',
        '%s was correctly uninstalled.' => '%s 已经成功卸载。',
        'There was a problem uninstalling %s.' => '卸载 %s 时遇到了一个问题。',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP环境不能正常工作，请检查日志获取更多信息！',
        'Need param Key to delete!' => '需要参数“密钥”才能删除！',
        'Key %s deleted!' => '密钥%s 已删除！',
        'Need param Key to download!' => '需要参数“密钥”才能下载！',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '抱歉，在Apache配置文件中需要Apache::Reload作为PerlModule和PerlInitHandler。另请查看scripts/apache2-httpd.include.conf。或者您也可以使用命令行工具bin/otrs.Console.pl来安装软件包！',
        'No such package!' => '没有这个软件包！',
        'No such file %s in package!' => '软件包中没有%s 文件！',
        'No such file %s in local file system!' => '本地文件系统中没有%s 文件！',
        'Can\'t read %s!' => '不能读取%s！',
        'File is OK' => '文件正常',
        'Package has locally modified files.' => '软件包中有本地修改过的文件。',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '扩展包未经OTRS检验！不推荐使用该扩展包.',
        'Not Started' => '没有启动',
        'Updated' => '更新时间',
        'Already up-to-date' => '已经是最新的',
        'Installed' => '安装时间',
        'Not correctly deployed' => '没有已经正确地部署',
        'Package updated correctly' => '软件包已正确地更新',
        'Package was already updated' => '软件包已经更新',
        'Dependency installed correctly' => '依赖软件已正确地安装',
        'The package needs to be reinstalled' => '需要重新安装这个软件包',
        'The package contains cyclic dependencies' => '软件包包含循环依赖项',
        'Not found in on-line repositories' => '在线软件库中找不到',
        'Required version is higher than available' => '所需版本高于可用版本',
        'Dependencies fail to upgrade or install' => '无法更新或安装依赖软件',
        'Package could not be installed' => '软件包无法安装',
        'Package could not be upgraded' => '软件包无法更新',
        'Repository List' => '软件仓库列表',
        'No packages found in selected repository. Please check log for more info!' =>
            '在选定的软件仓库中找不到软件包， 请查看日志以获取更多信息！',
        'Package not verified due a communication issue with verification server!' =>
            '不能验证软件包，因为与验证服务器无法正常通信！',
        'Can\'t connect to OTRS Feature Add-on list server!' => '不能连接到OTRS附加功能列表服务器！',
        'Can\'t get OTRS Feature Add-on list from server!' => '不能从服务器获取OTRS附加功能列表！',
        'Can\'t get OTRS Feature Add-on from server!' => '不能从服务器获取OTRS附加功能！',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '没有这个过滤器：%s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => '优先级已添加!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '数据库中的流程管理信息与系统配置不一致，请同步所有流程。',
        'Need ExampleProcesses!' => '需要ExampleProcesses！',
        'Need ProcessID!' => '需要流程ID！',
        'Yes (mandatory)' => '是（强制）',
        'Unknown Process %s!' => '未知的流程 %s！',
        'There was an error generating a new EntityID for this Process' =>
            '为这个流程生成新的实体ID时出现了一个错误',
        'The StateEntityID for state Inactive does not exists' => '状态为‘非活动的’的StateEntityID不存在',
        'There was an error creating the Process' => '创建该流程时出现了一个错误',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '为流程实体：%s设置实体同步状态时出现了一个错误',
        'Could not get data for ProcessID %s' => '不能获取ID为 %s的流程数据',
        'There was an error updating the Process' => '更新该流程时出现了一个错误',
        'Process: %s could not be deleted' => '不能删除流程：%s',
        'There was an error synchronizing the processes.' => '同步该流程时出现了一个错误。',
        'The %s:%s is still in use' => '%s:%s 仍在使用中',
        'The %s:%s has a different EntityID' => '%s:%s 有一个不同的EntityID',
        'Could not delete %s:%s' => '不能删除 %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '为 %s 实体： %s 设置实体同步状态时出现了一个错误',
        'Could not get %s' => '不能获取 %s',
        'Need %s!' => '需要 %s！',
        'Process: %s is not Inactive' => '流程： %s 的状态不是‘非活动的’',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '为这个活动生成新的EntityID时出现了一个错误',
        'There was an error creating the Activity' => '创建活动时出现了一个错误',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '设置活动实体： %s的同步状态时出现了一个错误',
        'Need ActivityID!' => '需要ActivityID！',
        'Could not get data for ActivityID %s' => '不能获得ActivityID %s的数据',
        'There was an error updating the Activity' => '更新活动时出现了一个错误',
        'Missing Parameter: Need Activity and ActivityDialog!' => '参数缺失：需要活动或活动对话框！',
        'Activity not found!' => '没有找到活动！',
        'ActivityDialog not found!' => '没有找到活动对话框！',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '活动对话框已经分配给活动，不能重复添加活动对话框！',
        'Error while saving the Activity to the database!' => '保存活动到数据库时出错！',
        'This subaction is not valid' => '这个子操作无效',
        'Edit Activity "%s"' => '编辑活动“%s”',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '为这个活动对话框生成一个新EntityID时出现了一个错误',
        'There was an error creating the ActivityDialog' => '创建这个活动对话框时出现了一个错误',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '设置活动对话框实体的同步状态时出现了一个错误',
        'Need ActivityDialogID!' => '需要ActivityDialogID！',
        'Could not get data for ActivityDialogID %s' => '不能获得ActivityDialogID %s的数据',
        'There was an error updating the ActivityDialog' => '更新活动对话框时出现了一个错误',
        'Edit Activity Dialog "%s"' => '编辑活动对话框“%s”',
        'Agent Interface' => '服务人员界面',
        'Customer Interface' => '客户界面',
        'Agent and Customer Interface' => '服务人员和客户界面',
        'Do not show Field' => '不显示字段',
        'Show Field' => '显示字段',
        'Show Field As Mandatory' => '显示字段为必填',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '编辑路径',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '为这个转换生成新的EntityID时出现了一个错误',
        'There was an error creating the Transition' => '创建转换时出现了一个错误',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '设置转换实体的同步状态时出现了一个错误',
        'Need TransitionID!' => '需要TransitionID！',
        'Could not get data for TransitionID %s' => '不能获得TransitionID %s的数据',
        'There was an error updating the Transition' => '更新转换时出现了一个错误',
        'Edit Transition "%s"' => '编辑转换“%s”',
        'Transition validation module' => '转换验证模块',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '至少需要一个有效的配置参数。',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '为这个转换动作生成一个新的EntityID时出现了一个错误',
        'There was an error creating the TransitionAction' => '创建转换动作时出现了一个错误',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '设置转换动作实体：%s的同步状态时出现了一个错误',
        'Need TransitionActionID!' => '需要TransitionActionID！',
        'Could not get data for TransitionActionID %s' => '不能获得TransitionActionID %s的数据',
        'There was an error updating the TransitionAction' => '更新转换动作时出现了一个错误',
        'Edit Transition Action "%s"' => '编辑转换操作“%s”',
        'Error: Not all keys seem to have values or vice versa.' => '错误：不是所有键都有值，或存在没有键的值。',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => '队列已更新！',
        'Don\'t use :: in queue name!' => '不要在队列名称中使用双冒号 “::”！',
        'Click back and change it!' => '点击返回并修改它！',
        '-none-' => '-无-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '没有自动响应的队列',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => '修改模板的队列关系',
        'Change Template Relations for Queue' => '修改队列的模板关系',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '生产',
        'Test' => '测试',
        'Training' => '培训',
        'Development' => '开发',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => '角色已更新！',
        'Role added!' => '角色已添加！',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => '为角色指定组权限',
        'Change Role Relations for Group' => '为组指定角色权限',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '角色',
        'Change Role Relations for Agent' => '为服务人员指定角色',
        'Change Agent Relations for Role' => '为角色指定服务人员',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => '请首先激活%s！',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME环境没有正常工作，请检查日志以获取更多信息！',
        'Need param Filename to delete!' => '需要参数文件名才能删除！',
        'Need param Filename to download!' => '需要参数文件名才能下载！',
        'Needed CertFingerprint and CAFingerprint!' => '需要证书指纹和认证机构指纹！',
        'CAFingerprint must be different than CertFingerprint' => '认证机构指纹必须与证书指纹不同',
        'Relation exists!' => '关系已经存在！',
        'Relation added!' => '关系已添加！',
        'Impossible to add relation!' => '不可能添加关系！',
        'Relation doesn\'t exists' => '关系不存在',
        'Relation deleted!' => '关系已删除！',
        'Impossible to delete relation!' => '不可能删除关系！',
        'Certificate %s could not be read!' => '不能读取证书 %s ！',
        'Needed Fingerprint' => '需要指纹',
        'Handle Private Certificate Relations' => '处理私有证书关系',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '问候语已添加！',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => '签名已更新!',
        'Signature added!' => '签名已添加!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => '状态已添加！',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '不能读取文件%s！',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => '系统邮件地址已添加！',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '无效的设置',
        'There are no invalid settings active at this time.' => '当前没有使用无效的设置。',
        'You currently don\'t have any favourite settings.' => '你目前没有收藏任何设置。',
        'The following settings could not be found: %s' => '找不到以下设置：%s',
        'Import not allowed!' => '不允许导入！',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            '由于一个未知错误不能导入系统配置，请检查OTRS日志以获取更多信息。',
        'Category Search' => '搜索类别',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            '某些导入的设置不在配置的当前状态中，或者无法进行更新。 请查看OTRS日志了解更多信息。',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '锁定之前需要启用该设置！',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '你无法编辑此设置，因为%s（%s）目前正在编辑。',
        'Missing setting name!' => '缺少设置名称！',
        'Missing ResetOptions!' => '缺少重置选项！',
        'Setting is locked by another user!' => '设置被其它用户锁定！',
        'System was not able to lock the setting!' => '系统无法锁定该设置！',
        'System was not able to reset the setting!' => '系统无法重置该设置！',
        'System was unable to update setting!' => '系统无法更新该设置！',
        'Missing setting name.' => '缺少设置名称。',
        'Setting not found.' => '没有找到设置。',
        'Missing Settings!' => '缺少设置！',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '开始日期不能在结束日期之后！',
        'There was an error creating the System Maintenance' => '创建系统维护时出现了一个错误',
        'Need SystemMaintenanceID!' => '需要SystemMaintenanceID！',
        'Could not get data for SystemMaintenanceID %s' => '不能获得SystemMaintenanceID %s的数据',
        'System Maintenance was added successfully!' => '系统维护添加成功！',
        'System Maintenance was updated successfully!' => '系统维护更新成功！',
        'Session has been killed!' => '会话已经被终止掉！',
        'All sessions have been killed, except for your own.' => '除了本会话外，所有会话都已经被kill掉。',
        'There was an error updating the System Maintenance' => '更新系统维护时出现了一个错误',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '不能删除系统维护条目：%s！',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '模板已更新！',
        'Template added!' => '模板已添加！',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '为模板指定附件',
        'Change Template Relations for Attachment' => '为附件指定模板',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '需要类型！',
        'Type added!' => '类型已添加！',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => '服务人员已更新！',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => '修改此服务人员的组权限',
        'Change Agent Relations for Group' => '为此组选择服务人员的权限',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => '月',
        'Week' => '周',
        'Day' => '日',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '所有预约',
        'Appointments assigned to me' => '分配给我的预约',
        'Showing only appointments assigned to you! Change settings' => '仅显示分配给你的预约！修改设置',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '没有找到预约！',
        'Never' => '永不',
        'Every Day' => '每天',
        'Every Week' => '每周',
        'Every Month' => '每月',
        'Every Year' => '每年',
        'Custom' => '定制',
        'Daily' => '每天一次',
        'Weekly' => '每周一次',
        'Monthly' => '每月一次',
        'Yearly' => '每年一次',
        'every' => '每',
        'for %s time(s)' => '%s次',
        'until ...' => '直到...',
        'for ... time(s)' => '...次',
        'until %s' => '直到%s',
        'No notification' => '没有通知',
        '%s minute(s) before' => '%s分钟前',
        '%s hour(s) before' => '%s小时前',
        '%s day(s) before' => '%s天前',
        '%s week before' => '%s周前',
        'before the appointment starts' => '在预约开始前',
        'after the appointment has been started' => '在预约开始后',
        'before the appointment ends' => '在预约结束前',
        'after the appointment has been ended' => '在预约结束后',
        'No permission!' => '没有权限！',
        'Cannot delete ticket appointment!' => '不能删除工单预约！',
        'No permissions!' => '没有权限！',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s 更多',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => '客户历史',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '没有指定收件人字段！',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '没有%s 的配置',
        'Statistic' => '统计',
        'No preferences for %s!' => '没有%s的偏好设置！',
        'Can\'t get element data of %s!' => '不能获得%s 的元素数据！',
        'Can\'t get filter content data of %s!' => '不能获得%s 的过滤器内容数据！',
        'Customer Name' => '客户名字',
        'Customer User Name' => '客户用户姓名',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '需要SourceObject（源对象）和SourceKey（源键）！',
        'You need ro permission!' => '需要ro只读权限！',
        'Can not delete link with %s!' => '不能删除到%s的链接！',
        '%s Link(s) deleted successfully.' => '成功删除%s个链接。',
        'Can not create link with %s! Object already linked as %s.' => '不能创建到 %s 的连接！对象已连接为 %s。',
        'Can not create link with %s!' => '不能创建到%s的链接！',
        '%s links added successfully.' => '成功添加%s个链接。',
        'The object %s cannot link with other object!' => '对象 %s 不能被其它对象链接！',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '参数“组”是必需的！',
        'Updated user preferences' => '用户偏好设置已更新',
        'System was unable to deploy your changes.' => '系统无法部署你的变更。',
        'Setting not found!' => '没有找到设置！',
        'System was unable to reset the setting!' => '系统无法重置该设置！',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '流程工单',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '缺失参数“%s”。',
        'Invalid Subaction.' => '无效的子动作。',
        'Statistic could not be imported.' => '不能导入统计。',
        'Please upload a valid statistic file.' => '请上传一个有效的统计文件。',
        'Export: Need StatID!' => '导出：需要StatID（统计ID）！',
        'Delete: Get no StatID!' => '删除：没有StatID（统计ID）！',
        'Need StatID!' => '需要StatID（统计ID）！',
        'Could not load stat.' => '不能载入统计。',
        'Add New Statistic' => '添加新的统计',
        'Could not create statistic.' => '不能创建统计。',
        'Run: Get no %s!' => '运行：没有获得 %s！',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '没有指定TicketID 工单编号！',
        'You need %s permissions!' => '需要%s 权限！',
        'Loading draft failed!' => '加载草稿失败！',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '只有工单的所有者才能执行此操作。',
        'Please change the owner first.' => '请先更改工单的所有者.',
        'FormDraft functionality disabled!' => '表单草稿功能已禁用！',
        'Draft name is required!' => '草稿名称是必需的！',
        'FormDraft name %s is already in use!' => '表单草稿的名称%s已使用！',
        'Could not perform validation on field %s!' => '不能验证字段%s ！',
        'No subject' => '没有主题',
        'Could not delete draft!' => '无法删除草稿！',
        'Previous Owner' => '前一个所有者',
        'wrote' => '写道',
        'Message from' => '消息来自',
        'End message' => '消息结束',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '需要%s！',
        'Plain article not found for article %s!' => '信件 %s 的纯文本没有找到！',
        'Article does not belong to ticket %s!' => '信件不属于工单%s！',
        'Can\'t bounce email!' => '不能退回邮件！',
        'Can\'t send email!' => '不能发送邮件！',
        'Wrong Subaction!' => '错误的子操作！',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '不能锁定工单，没有指定工单编辑！',
        'Ticket (%s) is not unlocked!' => '工单（%s）没有解锁！',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '由于被其它服务人员锁定或者你没有其写入权限，下列工单将被忽略：%s。',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '由于被其它服务人员锁定或者你没有其写入权限，此工单将被忽略：%s。',
        'You need to select at least one ticket.' => '你需要选择至少一个工单。',
        'Bulk feature is not enabled!' => '批量操作功能还没有启用！',
        'No selectable TicketID is given!' => '没有指定可选择的工单编号！',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '你要么没有选择工单，要么只选择了已被其他服务人员锁定的工单。',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '由于被其它服务人员锁定或者你没有其写入权限，下列工单将被忽略：%s。',
        'The following tickets were locked: %s.' => '下列工单已被锁定：%s。',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '如果主题只包含工单钩子，则信件主题将为空！',
        'Address %s replaced with registered customer address.' => '地址%s已被注册的客户地址所替换。',
        'Customer user automatically added in Cc.' => '客户用户被自动地添加到Cc中.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => '工单“%s”已创建!',
        'No Subaction!' => '没有子操作！',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '没有获得工单编号！',
        'System Error!' => '系统错误！',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '没有指定信件ID！',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => '下周',
        'Ticket Escalation View' => '工单升级视图',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '没有找到信件%s！',
        'Forwarded message from' => '已转发的消息来自',
        'End forwarded message' => '转发消息结束',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '不能显示历史，没有指定工单编号！',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '不能锁定工单，没有指定工单编号！',
        'Sorry, the current owner is %s!' => '抱歉，当前所有者是：%s！',
        'Please become the owner first.' => '请首先成为所有者。',
        'Ticket (ID=%s) is locked by %s!' => '工单（ID=%s）已被 %s 锁定！',
        'Change the owner!' => '变更所有者！',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => '新信件',
        'Pending' => '挂起',
        'Reminder Reached' => '提醒时间已过',
        'My Locked Tickets' => '我锁定的工单',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '不能将工单合并到它自己！',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '你需要转换权限！',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '聊天不是活动的。',
        'No permission.' => '没有权限。',
        '%s has left the chat.' => '%s已经离开了聊天。',
        'This chat has been closed and will be removed in %s hours.' => '这个聊天已经关闭，将在%s小时内删除。',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => '工单已锁定.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '没有ArticleID！',
        'This is not an email article.' => '这不是电子邮件信件。',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '不能读取纯文本信件！可能在后端没有纯文件邮件！读取后端消息。',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '需要TicketID 工单编号！',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '不能获取ActivityDialogEntityID “%s”！',
        'No Process configured!' => '还没有配置流程！',
        'The selected process is invalid!' => '所选择的流程无效!',
        'Process %s is invalid!' => '流程%s 无效！',
        'Subaction is invalid!' => '子操作无效！',
        'Parameter %s is missing in %s.' => '缺失参数“%s”，在“%s”。',
        'No ActivityDialog configured for %s in _RenderAjax!' => '在函数_RenderAjax中 %s 没有配置活动对话框！',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '在函数_GetParam 中没有获得流程 %s 的开始活动实体ID或开始活动对话框实体ID！',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '在函数_GetParam 中不能获取工单编号为 %s 的工单！',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '不能确定活动实体ID，动态字段或配置不正确！',
        'Process::Default%s Config Value missing!' => 'Process::Default%s 没有配置值！',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '没有获得流程实体ID，或者没有获得工单ID和活动对话框实体ID！',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '不能获得流程实体ID为“%s”的开始活动和开始活动对话框！',
        'Can\'t get Ticket "%s"!' => '不能获得工单“%s”！',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '不能获得工单“%s”的流程实体ID或活动实体ID！',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '不能获得活动实体ID “%s”的活动配置！',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '不能获得活动对话框实体ID “%s”的活动对话框配置！',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '不能获取活动对话框“%s”的动态字段“%s”的数据！',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '挂起时间只能在同一个活动对话框配置了状态或状态ID时使用。活动对话框：%s！',
        'Pending Date' => '挂起时间',
        'for pending* states' => '针对各种挂起状态',
        'ActivityDialogEntityID missing!' => '缺少ActivityDialogEntityID（活动对话框实体ID）！',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '不能获得ActivityDialogEntityID（活动对话框实体ID） “%s”的配置！',
        'Couldn\'t use CustomerID as an invisible field.' => '不能将CustomerID（客户ID）用作不可见字段。',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '缺少ProcessEntityID（流程实体ID），请检查您的模板文件ActivityDialogHeader.tt！',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '流程“%s”没有配置开始活动或开始活动对话框！',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '不能为流程实体ID为“%s”的流程创建工单！',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '不能设置流程实体ID “%s”在工单ID “%s”中！',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '不能设置活动实体ID “%s”在工单ID “%s”中！',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '不能存储活动对话框，无效的工单ID： %s！',
        'Invalid TicketID: %s!' => '无效的工单ID： “%s”！',
        'Missing ActivityEntityID in Ticket %s!' => '在工单 “%s”中缺少活动实体ID！',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '此步骤不再属于工单“%s%s%s”流程的当前活动！ 另一位用户在此期间改变了这个工单。请关闭此窗口，再重新加载这个工单。',
        'Missing ProcessEntityID in Ticket %s!' => '在工单 “%s”中缺少流程实体ID！',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '不能设置动态字段“%s”的值，工单ID为“%s”，活动对话框 “%s”！',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '不能设置工单 “%s”的挂起时间，活动对话框 “%s”！',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '错误的活动对话框字段配置：%s 不能设置为Display => 1/显示字段（请修改它的配置为Display => 0/不显示字段或Display => 2 /强制显示字段）！',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '不能设置“%s”，工单ID为“%s”，活动对话框 “%s”！',
        'Default Config for Process::Default%s missing!' => 'Process::Default%s 默认配置缺失！',
        'Default Config for Process::Default%s invalid!' => 'Process::Default%s 默认配置无效！',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => '未锁定的工单',
        'including subqueues' => '包含子队列',
        'excluding subqueues' => '排除子队列',
        'QueueView' => '队列视图',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => '我负责的工单',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => '上次搜索',
        'Untitled' => '无标题',
        'Ticket Number' => '工单编号',
        'Ticket' => '工单',
        'printed by' => '打印人：',
        'CustomerID (complex search)' => 'CustomerID(复合搜索)',
        'CustomerID (exact match)' => 'CustomerID(精确匹配)',
        'Invalid Users' => '无效用户',
        'Normal' => '普通',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => '不超过...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '功能没有启用！',
        'Service View' => '服务视图',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => '状态视图',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => '我关注的工单',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '功能没有激活',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '连接已删除',
        'Ticket Locked' => '工单已锁定',
        'Pending Time Set' => '挂起时间设置',
        'Dynamic Field Updated' => '动态字段已更新',
        'Outgoing Email (internal)' => '外发邮件-内部',
        'Ticket Created' => '工单已创建',
        'Type Updated' => '类型已更新',
        'Escalation Update Time In Effect' => '实际升级更新时间',
        'Escalation Update Time Stopped' => '升级更新时间已停止',
        'Escalation First Response Time Stopped' => '升级首次响应时间已停止',
        'Customer Updated' => '客户用户已更新',
        'Internal Chat' => '内部聊天',
        'Automatic Follow-Up Sent' => '发送自动跟进',
        'Note Added' => '已增加备注',
        'Note Added (Customer)' => '已增加备注-客户用户',
        'SMS Added' => '短信已添加',
        'SMS Added (Customer)' => '短信已添加（客户）',
        'State Updated' => '状态已更新',
        'Outgoing Answer' => '答复',
        'Service Updated' => '服务已更新',
        'Link Added' => '连接已增加',
        'Incoming Customer Email' => '客户来信',
        'Incoming Web Request' => '进入的WEB请求',
        'Priority Updated' => '优先级已更新',
        'Ticket Unlocked' => '工单已解锁',
        'Outgoing Email' => '外发邮件',
        'Title Updated' => '主题已更新',
        'Ticket Merged' => '工单已合并',
        'Outgoing Phone Call' => '致电',
        'Forwarded Message' => '已转发的消息',
        'Removed User Subscription' => '已移除的用户订阅',
        'Time Accounted' => '所用时间',
        'Incoming Phone Call' => '来电',
        'System Request.' => '系统请求。',
        'Incoming Follow-Up' => '进入的跟进',
        'Automatic Reply Sent' => '发送自动回复',
        'Automatic Reject Sent' => '自动拒绝已发送',
        'Escalation Solution Time In Effect' => '实际升级解决时间',
        'Escalation Solution Time Stopped' => '升级解决时间已停止',
        'Escalation Response Time In Effect' => '实际升级响应时间',
        'Escalation Response Time Stopped' => '升级响应时间已停止',
        'SLA Updated' => 'SLA 已更新',
        'External Chat' => '外部聊天',
        'Queue Changed' => '队列已变更',
        'Notification Was Sent' => '通知已发送',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '这个工单不存在，或者它的当前状态下你无权访问它。',
        'Missing FormDraftID!' => '缺少表单草稿ID！',
        'Can\'t get for ArticleID %s!' => '不能获得ID为“%s”的信件！',
        'Article filter settings were saved.' => '信件过滤器设置已保存。',
        'Event type filter settings were saved.' => '事件类型过滤器设置已保存。',
        'Need ArticleID!' => '需要信件ID！',
        'Invalid ArticleID!' => '无效的信件ID！',
        'Forward article via mail' => '通过邮件转发信件',
        'Forward' => '转发',
        'Fields with no group' => '没有分组的字段',
        'Invisible only' => '仅不可见的',
        'Visible only' => '仅可见的',
        'Visible and invisible' => '所有的',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '不能打开信件！或许它在另外一个信件页面上打开了？',
        'Show one article' => '显示单一信件',
        'Show all articles' => '显示所有信件',
        'Show Ticket Timeline View' => '以时间轴视图显示工单',
        'Show Ticket Timeline View (%s)' => '显示工单时间轴视图(%s)',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '没有获取到表单ID。',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '错误：文件无法正确删除，请联系您的管理员（缺少文件ID）。',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '需要信件ID！',
        'No TicketID for ArticleID (%s)!' => '信件ID (%s)没有工单ID！',
        'HTML body attachment is missing!' => '缺少HTML body附件！',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '需要文件ID和信件ID！',
        'No such attachment (%s)!' => '没有这个附件（%s）！',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '检查系统配置 %s::QueueDefault 的设置。',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '检查系统配置 %s::TicketTypeDefault 的设置。',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '您没有足够的权限在默认队列中创建工单。',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '需要客户ID！',
        'My Tickets' => '我的工单',
        'Company Tickets' => '单位工单',
        'Untitled!' => '未命名！',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '客户用户真实姓名',
        'Created within the last' => '在最近...之内创建的',
        'Created more than ... ago' => '在...之前创建的',
        'Please remove the following words because they cannot be used for the search:' =>
            '请移除以下不能用于搜索的词语：',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '不能重新处理工单，在这个队列不可能！',
        'Create a new ticket!' => '创建一个新工单！',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '激活了安全模式！',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '如果你要重新运行安装程序，请在系统配置中禁用安全模式。',
        'Directory "%s" doesn\'t exist!' => '目录 “%s”不存在！',
        'Configure "Home" in Kernel/Config.pm first!' => '首先在文件Kernel/Config.pm中配置“Home”！',
        'File "%s/Kernel/Config.pm" not found!' => '没有找到文件“%s/Kernel/Config.pm”！',
        'Directory "%s" not found!' => '没有找到目录“%s”！',
        'Install OTRS' => '安装OTRS',
        'Intro' => '介绍',
        'Kernel/Config.pm isn\'t writable!' => '文件Kernel/Config.pm不可写入！',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '如果你要使用安装器，设置WEB服务器用户对文件Kernel/Config.pm有写权限！',
        'Database Selection' => '数据库选择',
        'Unknown Check!' => '未知的检查！',
        'The check "%s" doesn\'t exist!' => '检查“%s”不存在！',
        'Enter the password for the database user.' => '输入数据库用户密码。',
        'Database %s' => '数据库%s',
        'Configure MySQL' => '配置MySQL',
        'Enter the password for the administrative database user.' => '输入数据库管理员密码。',
        'Configure PostgreSQL' => '配置PostgreSQL',
        'Configure Oracle' => '配置ORACLE',
        'Unknown database type "%s".' => '未知的数据库类型“%s”。',
        'Please go back.' => '请返回。',
        'Create Database' => '创建数据库',
        'Install OTRS - Error' => '安装OTRS - 错误',
        'File "%s/%s.xml" not found!' => '没有找到文件“%s/%s.xml”！',
        'Contact your Admin!' => '联系你的系统管理员！',
        'System Settings' => '系统设置',
        'Syslog' => 'Syslog',
        'Configure Mail' => '配置邮件',
        'Mail Configuration' => '邮件配置',
        'Can\'t write Config file!' => '不能写入配置文件！',
        'Unknown Subaction %s!' => '未知的子操作 %s！',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '不能连接到数据库，没有安装Perl模块 DBD::%s！',
        'Can\'t connect to database, read comment!' => '不能连接到数据库，读取注释！',
        'Database already contains data - it should be empty!' => '数据库中已包含数据 - 应该清空它！',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '错误：请确认你的数据库能够接收大于%sMB的数据包（目前能够接收的最大数据包为%sMB）。为了避免程序报错，请调整数据库max_allowed_packet参数。',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '错误：请设置数据库参数innodb_log_file_size至少为%s MB（当前：%s MB，推荐：%s MB），请参阅 %s 获取更多信息。',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '错误的数据库排序规则（%s是%s，但需要是utf8）。',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '没有%s!',
        'No such user!' => '没有这个用户！',
        'Invalid calendar!' => '无效日历！',
        'Invalid URL!' => '无效网址！',
        'There was an error exporting the calendar!' => '导出日历时出错！',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '需要配置 Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => '从 %s 身份认证失败！',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => '将邮件退回到另一个邮箱地址',
        'Bounce' => '退回',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => '回复所有',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '重发这个信件',
        'Resend' => '重发',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '查看这个信件的消息日志详细信息',
        'Message Log' => '消息日志',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => '回复为备注',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => '拆分信件',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '查看这个信件的源',
        'Plain Format' => '纯文本格式',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => '打印信件',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '请通过sales@otrs.com联系我们',
        'Get Help' => '获取帮助',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => '标记',
        'Unmark' => '取消标记',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => '更新到OTRS商业版',
        'Re-install Package' => '重新安装软件包',
        'Upgrade' => '升级',
        'Re-install' => '重新安装',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => '已加密',
        'Sent message encrypted to recipient!' => '发送加密消息到收件人！',
        'Signed' => '已签名',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '发现无效的“PGP签名消息”头标识！',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '发现无效的“S/MIME签名消息”头标识！',
        'Ticket decrypted before' => '工单解密在……之前',
        'Impossible to decrypt: private key for email was not found!' => '无法解密：没有找到邮件的私钥！',
        'Successful decryption' => '成功解密',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '地址：\'%s\' 没有加密密钥可用。 ',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '地址：\'%s\' 没有选择加密密钥。 ',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '地址：\'%s\' 无法使用过期的加密密钥。 ',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '地址：\'%s\' 不能使用已撤销的加密密钥。 ',
        'Encrypt' => '加密',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '密钥/证书只会显示给具有多个密钥/证书的收件人，找到的第一个密钥/证书将被预选，请确保选择了正确的密钥/证书。',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '电子邮件安全',
        'PGP sign' => 'PGP签名',
        'PGP sign and encrypt' => 'PGP签名和加密',
        'PGP encrypt' => 'PGP加密',
        'SMIME sign' => 'SMIME签名',
        'SMIME sign and encrypt' => 'SMIME签名和加密',
        'SMIME encrypt' => 'SMIME加密',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '不能使用过期的签名密钥：\'%s\'。 ',
        'Cannot use revoked signing key: \'%s\'. ' => '不能使用已撤销的签名密钥：“%s”。 ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '没有签名密钥可用于地址：\'%s\'。',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '地址：\'%s\'没有选择签名密钥。',
        'Sign' => '签名',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '密钥/证书只会显示给具有多个密钥/证书的发件人，找到的第一个密钥/证书将被预选，请确保选择了正确的密钥/证书。',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => '显示',
        'Refresh (minutes)' => '刷新（分钟）',
        'off' => '关',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '显示客户ID',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '显示客户用户',
        'Offline' => '离线',
        'User is currently offline.' => '用户当前离线。',
        'User is currently active.' => '用户当前已激活。',
        'Away' => '离开',
        'User was inactive for a while.' => '用户暂时未激活。',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '工单开始时间被设置在结束时间之后！',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => '无法连接OTRS新闻服务器！',
        'Can\'t get OTRS News from server!' => '无法从服务器获取OTRS新闻！',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '无法连接到产品新闻服务器！',
        'Can\'t get Product News from server!' => '无法从服务器获取产品新闻！',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '无法连接到%s！',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => '显示工单',
        'Shown Columns' => '显示字段',
        'filter not active' => '过滤器没有激活',
        'filter active' => '过滤器是活动的',
        'This ticket has no title or subject' => '这个工单没有标题或主题',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '最近7天统计',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '用户设置他们的状态为不可用。',
        'Unavailable' => '不可用',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => '标准',
        'The following tickets are not updated: %s.' => '下列工单没有更新：%s。',
        'h' => '时',
        'm' => '分',
        'd' => '天',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '这个工单不存在，或者它的当前状态下你无权访问它。你可以采取下列操作之一：',
        'This is a' => '这是一个',
        'email' => '电子邮件',
        'click here' => '点击这里',
        'to open it in a new window.' => '在新窗口中打开。',
        'Year' => '年',
        'Hours' => '小时',
        'Minutes' => '分钟',
        'Check to activate this date' => '选中它，以便激活这个日期',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => '无权限!',
        'No Permission' => '没有权限',
        'Show Tree Selection' => '显示树状选项',
        'Split Quote' => '拆分引用',
        'Remove Quote' => '移除引用',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '链接为',
        'Search Result' => '搜索结果',
        'Linked' => '已链接',
        'Bulk' => '批量',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => '精简',
        'Unread article(s) available' => '未读信件',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '预约',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '归档搜索',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => '启用云服务以激活OTRS的所有功能！',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '现在升级%s到%s！%s',
        'Please verify your license data!' => '请验证您的许可证数据！',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '您的%s的许可证即将过期， 请与%s联系续订您的合同！',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '您的%s有新版本可用，但是与当前的框架版本不兼容！请先升级当前的框架版本！',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => '在线服务人员：%s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => '还有更多升级的工单！',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '请在偏好设置中选择一个时区，然后单击保存按钮进行确认。',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => '在线客户: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '正在进行系统维护！',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '一次系统维护将开始于：%s，预计结束时间为：%s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'OTRS守护进程没有运行。',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            '你已设置为不在办公室，是否取消它?',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            '使用了没有通过OTRS集团验证的软件包，这些软件包可能会威胁到您的整个系统！ 建议不要使用未经验证的软件包。',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '您已经部署了%s个无效的设置，点击此处显示无效的设置。',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '你有取消部署的设置，是否要部署它们？',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '配置正在更新，请耐心等待...',
        'There is an error updating the system configuration!' => '更新系统配置时出现错误！',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '不要用超级用户帐户使用%s！ 创建新的服务人员，并使用这些帐户进行工作。',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '请确保您已经为强制通知选择至少一种传输方法。',
        'Preferences updated successfully!' => '偏好设置更新成功！',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '（进行中）',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '请指定在开始时间之后的结束时间。',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => '当前密码',
        'New password' => '新密码',
        'Verify password' => '重复新密码',
        'The current password is not correct. Please try again!' => '当前密码不正确，请重新输入！',
        'Please supply your new password!' => '请提供你的新密码!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            '无法修改密码。新密码不一致，请重新输入！',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '当前系统配置禁止此密码，如有其他问题，请联系管理员。',
        'Can\'t update password, it must be at least %s characters long!' =>
            '无法修改密码，密码至少需要%s个字符！',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '无法更新密码，必须至少包含2个小写字母和2个大写字母！',
        'Can\'t update password, it must contain at least 1 digit!' => '无法修改密码，密码至少需要1个数字字符！',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '无法更新密码，必须至少包含2个字母字符！',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '时区更新成功！',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => '无效',
        'valid' => '有效',
        'No (not supported)' => '不支持',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '没有选择过去完成的或“当前+即将”完成的相对时间值。',
        'The selected time period is larger than the allowed time period.' =>
            '选择的时间段超出了允许的时间段。',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'X轴没有可用的时间刻度值。',
        'The selected date is not valid.' => '选择的日期无效。',
        'The selected end time is before the start time.' => '选择的结束日期在开始日期之前。',
        'There is something wrong with your time selection.' => '您选择的时间有一些问题。',
        'Please select only one element or allow modification at stat generation time.' =>
            '请只选择一个元素或允许在统计生成时修改。',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '请选择至少一个值或允许在统计生成时修改。',
        'Please select one element for the X-axis.' => '请为X轴选择一个元素。',
        'You can only use one time element for the Y axis.' => '您只能在Y轴上使用一个时间元素。',
        'You can only use one or two elements for the Y axis.' => '您只能在Y轴上使用一个或两个元素。',
        'Please select at least one value of this field.' => '请为这个字段选择至少一个值。',
        'Please provide a value or allow modification at stat generation time.' =>
            '请提供至少一个值或允许在统计生成时修改。',
        'Please select a time scale.' => '请选择一个时间刻度。',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '您的报表时间间隔太短，请使用更大一点的时间刻度。',
        'second(s)' => '秒',
        'quarter(s)' => '一刻钟',
        'half-year(s)' => '半年',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '请删除以下不能用于工单限制的词语：%s。',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '取消编辑并解锁此设置',
        'Reset this setting to its default value.' => '将这个设置重置为默认值。',
        'Unable to load %s!' => '无法加载%s！',
        'Content' => '值',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => '解锁并释放工单到队列',
        'Lock it to work on it' => '锁定并处理工单',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => '取消关注',
        'Remove from list of watched tickets' => '从关注工单列表中移除',
        'Watch' => '关注',
        'Add to list of watched tickets' => '添加到关注工单列表',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => '排序',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => '工单信息',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => '新的锁定工单数',
        'Locked Tickets Reminder Reached' => '提醒过的锁定工单数',
        'Locked Tickets Total' => '锁定工单总数',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => '负责的新工单数',
        'Responsible Tickets Reminder Reached' => '提醒过的负责的工单数',
        'Responsible Tickets Total' => '负责的工单总数',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => '关注的新工单数',
        'Watched Tickets Reminder Reached' => '关注且提醒过的工单数',
        'Watched Tickets Total' => '关注的工单总数',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => '工单动态字段',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '无法读取ACL配置文件。 请确保该文件有效。',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '当前正在执行计划内的系统维护，暂时无法登录。',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '你已经超出了并发服务人员的最大数，请联系sales@otrs.com。',
        'Please note that the session limit is almost reached.' => '请注意，会话数即将达到极限。',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '登录被拒绝！已经达到服务人员最大并发数！请立即联系sales@otrs.com！',
        'Session limit reached! Please try again later.' => '会话数量已超，请过会再试。',
        'Session per user limit reached!' => '达到用户会话限制！',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => '会话无效，请重新登录。',
        'Session has timed out. Please log in again.' => '会话超时，请重新登录。',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '仅PGP签名',
        'PGP encrypt only' => '仅PGP加密',
        'SMIME sign only' => '仅SMIME签名',
        'SMIME encrypt only' => '仅SMIME加密',
        'PGP and SMIME not enabled.' => '没有启用PGP和SMIME。',
        'Skip notification delivery' => '跳过通知递送',
        'Send unsigned notification' => '发送未签名的通知',
        'Send unencrypted notification' => '发送未加密的通知',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '配置选项参考手册',
        'This setting can not be changed.' => '这个设置不能修改。',
        'This setting is not active by default.' => '这个设置默认没有激活。',
        'This setting can not be deactivated.' => '不能使这个设置失效。',
        'This setting is not visible.' => '这个设置不可见。',
        'This setting can be overridden in the user preferences.' => '这个设置可以在用户偏好设置中被覆盖。',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '这个设置可以在用户偏好设置中被覆盖，但默认不会处于活动状态。。',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '客户用户“%s”已经存在。',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '这个电子邮件地址已被其他客户用户使用。',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => '在...之前/之后',
        'between' => '在...之间',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '如：Text或Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '忽略该字段。',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => '这个字段是必填的',
        'The field content is too long!' => '字段值太长了！',
        'Maximum size is %s characters.' => '最多%s个字符。',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '无法读取通知配置文件。 请确保该文件有效。',
        'Imported notification has body text with more than 4000 characters.' =>
            '导入的通知包含的正文文本超过4000个字符。',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '没有安装',
        'installed' => '已安装',
        'Unable to parse repository index document.' => '无法解析软件仓库索引文档。',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '软件仓库中没有当前系统版本可用的软件包。',
        'File is not installed!' => '文件没有安装！',
        'File is different!' => '文件被修改！',
        'Can\'t read file!' => '不能读取文件！',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '<p>如果安装这个扩展包，可能导致以下问题：</p><ul><li>安全问题</li><li>稳定问题</li><li>性能问题</li></ul><p>请注意，使用此软件包所引起的问题不在OTRS服务合同范围内。</p>',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '<p>默认情况下，无法安装未经OTRS集团验证的软件包。 您可以通过系统配置设置“AllowNotVerifiedPackages”激活安装未经验证的软件包。</p>',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '流程“%s”及其所有数据已成功导入。',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => '非活动的',
        'FadeAway' => '消退',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '不能连接到注册服务器，请稍后重试。',
        'No content received from registration server. Please try again later.' =>
            '注册服务器未返回有效信息，请稍后重试。',
        'Can\'t get Token from sever' => '不能从服务器获取令牌',
        'Username and password do not match. Please try again.' => '用户名与密码不匹配，请重试。',
        'Problems processing server result. Please try again later.' => '处理服务器返回信息时出现问题，请稍后重试。',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '总和',
        'week' => '星期',
        'quarter' => '一刻钟',
        'half-year' => '半年',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '工单状态类型',
        'Created Priority' => '创建的优先级',
        'Created State' => '创建的状态',
        'Create Time' => '创建时间',
        'Pending until time' => '挂起待定时间',
        'Close Time' => '关闭时间',
        'Escalation' => '升级',
        'Escalation - First Response Time' => '首次响应时间升级',
        'Escalation - Update Time' => '更新时间升级',
        'Escalation - Solution Time' => '解决时间升级',
        'Agent/Owner' => '服务人员/所有者',
        'Created by Agent/Owner' => '创建人',
        'Assigned to Customer User Login' => '分配给客户用户登录名',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => '评估方法',
        'Ticket/Article Accounted Time' => '工单/信件所用工时',
        'Ticket Create Time' => '工单创建时间',
        'Ticket Close Time' => '工单关闭时间',
        'Accounted time by Agent' => '服务人员处理工单所用工时',
        'Total Time' => '时间总合',
        'Ticket Average' => '工单平均处理时间',
        'Ticket Min Time' => '工单最小处理时间',
        'Ticket Max Time' => '工单最大处理时间',
        'Number of Tickets' => '工单数',
        'Article Average' => '信件平均处理时间',
        'Article Min Time' => '信件最小处理时间',
        'Article Max Time' => '信件最大处理时间',
        'Number of Articles' => '信件数',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '无限制',
        'Attributes to be printed' => '要打印的属性',
        'Sort sequence' => '排序',
        'State Historic' => '状态历史',
        'State Type Historic' => '工单状态类型历史',
        'Historic Time Range' => '历史信息的时间范围',
        'Number' => '编号',
        'Last Changed' => '最近更改',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '平均解决时间',
        'Solution Min Time' => '最小解决时间',
        'Solution Max Time' => '最大解决时间',
        'Solution Average (affected by escalation configuration)' => '平均解决时间（受升级配置影响）',
        'Solution Min Time (affected by escalation configuration)' => '最小解决时间（受升级配置影响）',
        'Solution Max Time (affected by escalation configuration)' => '最大解决时间（受升级配置影响）',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '平均解决工作时间（受升级配置影响）',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '最小解决工作时间（受升级配置影响）',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '最大解决工作时间（受升级配置影响）',
        'First Response Average (affected by escalation configuration)' =>
            '平均首次响应时间（受升级配置影响）',
        'First Response Min Time (affected by escalation configuration)' =>
            '最小首次响应时间（受升级配置影响）',
        'First Response Max Time (affected by escalation configuration)' =>
            '最大首次响应时间（受升级配置影响）',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '平均首次响应工作时间（受升级配置影响）',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '最小首次响应工作时间（受升级配置影响）',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '最大首次响应工作时间（受升级配置影响）',
        'Number of Tickets (affected by escalation configuration)' => '工单数量（受升级配置影响）',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => '天',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '过时的表',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '在数据库中找到了过时的表，如果空的话可以将其删除。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '表存在',
        'Internal Error: Could not open file.' => '内部错误：不能打开文件。',
        'Table Check' => '表检查',
        'Internal Error: Could not read file.' => '内部错误：不能读取文件。',
        'Tables found which are not present in the database.' => '数据库中不存在的表。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => '数据库大小',
        'Could not determine database size.' => '不能确定数据库大小。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '数据库版本',
        'Could not determine database version.' => '不能确定数据库版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '客户端连接字符集',
        'Setting character_set_client needs to be utf8.' => 'character_set_client 需要设置为utf8。',
        'Server Database Charset' => '服务器端数据库字符集',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => 'character_set_database 需要设置为\'utf8\'。',
        'Table Charset' => '表字符集',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '字符集没有设置成 \'utf8\'的表。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB日志文件大小',
        'The setting innodb_log_file_size must be at least 256 MB.' => '参数innodb_log_file_size必须设置为至少256MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '无效的默认值',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '找到具有无效的默认值的表。 为了自动修复它，请运行：bin/otrs.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '最大查询大小',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '\'max_allowed_packet\'必须设置为大于64MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '查询缓存大小',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '参数\'query_cache_size\'必须设置且大于10MB小于512MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '默认的存储引擎',
        'Table Storage Engine' => '表存储引擎',
        'Tables with a different storage engine than the default engine were found.' =>
            '以下表使用的存储引擎与默认存储引擎不同。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '需要MySQL 5.X或更高版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG设置',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG必须设置为al32utf8（例如：GERMAN_GERMANY.AL32UTF8）。',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT设置',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT 必须设置为\'YYYY-MM-DD HH24:MI:SS\'。',
        'NLS_DATE_FORMAT Setting SQL Check' => 'SQL检查NLS_DATE_FORMAT设置',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '主键序列和触发器',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '发现下面的序列和/或触发器可能有错误的名称， 请手动重命名。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'client_encoding 需要设置为UNICODE或UTF8。',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'server_encoding 需要设置为UNICODE或UTF8。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '日期格式',
        'Setting DateStyle needs to be ISO.' => '设置日期格式为国际标准格式。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '主键序列',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '发现下面的序列可能有错误的名称， 请手动重命名。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '需要PostgreSQL 9.2或更高版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'OTRS磁盘分区',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '硬盘使用情况',
        'The partition where OTRS is located is almost full.' => 'OTRS分区已经快满了。',
        'The partition where OTRS is located has no disk space problems.' =>
            'OTRS分区没有磁盘空间问题了。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '硬盘使用情况',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '发行版本',
        'Could not determine distribution.' => '不能确定发行版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '内核版本',
        'Could not determine kernel version.' => '不能确定内核版本。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '系统负载',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '系统负载最大值为系统CPU数（例如：8CPU的系统负载小于等于8才是正常的）。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl 模块',
        'Not all required Perl modules are correctly installed.' => '部分Perl模块没有正确安装。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'Perl 模块 Audit',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'CPAN::Audit 报告一个或多个已安装的 Perl 模块是否存在已知漏洞。 请注意，在不更改版本号的情况下修补Perl模块的发行版可能存在误报。',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '在已安装的Perl模块中 CPAN::Audit 未报告出任何已知漏洞。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '可用的交换空间(%)',
        'No swap enabled.' => '没有启用交换空间。',
        'Used Swap Space (MB)' => '交换分区已使用(MB)',
        'There should be more than 60% free swap space.' => '需要至少60%的可用交换空间。',
        'There should be no more than 200 MB swap space used.' => '交换空间不应该使用超过200MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => 'OTRS',
        'Article Search Index Status' => '信件搜索索引状态',
        'Indexed Articles' => '索引过的信件',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '信件/通信渠道',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '传入的通信',
        'Outgoing communications' => '外发的通信',
        'Failed communications' => '失败的通信',
        'Average processing time of communications (s)' => '通信平均处理时间',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '通讯日志帐号状态（最近24小时）',
        'No connections found.' => '找不到连接。',
        'ok' => 'OK',
        'permanent connection errors' => '永久性连接错误',
        'intermittent connection errors' => '间歇性连接错误',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => '配置设置',
        'Could not determine value.' => '不能确定参数值。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => '守护进程',
        'Daemon is running.' => '守护进程正在运行。',
        'Daemon is not running.' => '守护进程没有运行。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '数据库记录',
        'Tickets' => '工单',
        'Ticket History Entries' => '工单历史条目',
        'Articles' => '信件',
        'Attachments (DB, Without HTML)' => '附件（DB，不包括HTML文件）',
        'Customers With At Least One Ticket' => '至少有一个工单的客户',
        'Dynamic Field Values' => '动态字段值',
        'Invalid Dynamic Fields' => '无效的动态字段',
        'Invalid Dynamic Field Values' => '无效的动态字段值',
        'GenericInterface Webservices' => '通用接口Web服务',
        'Process Tickets' => '流程工单',
        'Months Between First And Last Ticket' => '最早和最后工单的月数',
        'Tickets Per Month (avg)' => '平均每月工单数',
        'Open Tickets' => '处理中的工单',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '默认的SOAP用户名和密码',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '安全风险：你使用了默认的SOAP::User和SOAP::Password设置，请修改。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '默认的系统管理员密码',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '安全风险：服务人员帐户root@localhost还在使用默认密码。请修改密码或禁用此帐户。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '电子邮件发送队列',
        'Emails queued for sending' => '已排队准备发送的电子邮件',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '正式域名',
        'Please configure your FQDN setting.' => '请配置您的正式域名。',
        'Domain Name' => '域名',
        'Your FQDN setting is invalid.' => '您的正式域名无效。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '文件系统是可写的',
        'The file system on your OTRS partition is not writable.' => 'OTRS分区所有文件系统是不可写的。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '遗留的配置备份',
        'No legacy configuration backup files found.' => '找不到遗留的配置备份文件。',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '在 Kernel/Config/Backups 文件夹中找到的旧版配置备份文件，但某些软件包可能仍然需要它们。',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '已安装的软件包不再需要旧的配置备份文件，请从 Kernel/Config/Backups 文件夹中删除它们。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '软件包安装状态',
        'Some packages have locally modified files.' => '一些软件包有在本地修改过的文件。',
        'Some packages are not correctly installed.' => '一些软件包没有正确安装。',
        'Package Verification Status' => '软件包验证状态',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '一些软件包未经OTRS团队验证！不推荐使用该扩展包。',
        'Package Framework Version Status' => '软件包框架版本状态',
        'Some packages are not allowed for the current framework version.' =>
            '一些软件包无法在当前的框架版本中使用。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => '软件包列表',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '会话配置设置',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '假脱机邮件',
        'There are emails in var/spool that OTRS could not process.' => 'var/spool 目录下有一些OTRS无法处理的邮件。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '您的系统ID设置无效，它只能包含数字。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '默认工单类型',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '配置的默认工单类型无效或缺失，请修改设置Ticket::Type::Default，选择一个有效的工单类型。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '工单索引模块',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '您已经超过60000个工单，应该使用后端静态数据库。请参阅管理员手册（性能调优部分）查阅更多信息。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '有锁定的工单的无效用户',
        'There are invalid users with locked tickets.' => '出现了有锁定的工单的无效用户。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '您的系统不能有超过8000个处理中的工单。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '工单搜索索引模块',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '索引进程强制将原始信件文本存储在信件搜索索引中，而不执行过滤器或应用停用词列表。 这将增加搜索索引的大小，从而可能减慢全文搜索。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'ticket_lock_index 表中的孤儿记录',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'ticket_lock_index 表中包含孤儿记录。请运行bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup"清理静态数据库的索引。',
        'Orphaned Records In ticket_index Table' => 'ticket_index 表中的孤儿记录',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'ticket_index表中包含孤儿记录，请运行bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup"，清理静态数据库的索引。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '时间设置',
        'Server time zone' => '服务器时区',
        'OTRS time zone' => 'OTRS时区',
        'OTRS time zone is not set.' => 'OTRS时区未设置。',
        'User default time zone' => '用户默认时区',
        'User default time zone is not set.' => '用户默认时区未设置。',
        'Calendar time zone is not set.' => '日历时区未设置。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '用户界面 - 服务人员皮肤用法',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '用户界面 - 服务人员主题用法',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => '用户界面 - 特殊的统计',
        'Agents using custom main menu ordering' => '服务人员使用定制的主菜单排序',
        'Agents using favourites for the admin overview' => '服务人员在系统管理概览使用收藏夹',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'WEB服务器',
        'Loaded Apache Modules' => '已载入的Apache模块',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM多路处理模块',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS需要apache运行“prefork”MPM多路处理模块。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI加速器用法',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '您应该使用FastCGI或mod_perl来提升性能。',
        'mod_deflate Usage' => 'mod_deflate用法',
        'Please install mod_deflate to improve GUI speed.' => '安装模块mod_deflate来提升GUI的速度。',
        'mod_filter Usage' => 'mod_filter用法',
        'Please install mod_filter if mod_deflate is used.' => '如果使用了mod_deflate，请安装使用mod_filter模块。',
        'mod_headers Usage' => 'mod_headers用法',
        'Please install mod_headers to improve GUI speed.' => '安装模块mod_headers来提升GUI的速度。',
        'Apache::Reload Usage' => 'Apache::Reload用法',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload或Apache2::Reload应该被用作PERL模块和PERL初始化处理程序，以防止在安装和升级模块时WEB服务器重启。',
        'Apache2::DBI Usage' => 'Apache2::DBI用法',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '应该用Apache2::DBI的预先数据库连接来获得更好的性能。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '环境变量',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '收集支持数据',
        'Support data could not be collected from the web server.' => '不能从WEB服务器收集支持数据。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'WEB服务器版本',
        'Could not determine webserver version.' => '不能确定WEB服务器版本。',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '并发用户详细信息',
        'Concurrent Users' => '并发用户数',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '好',
        'Problem' => '问题',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '设置%s不存在！',
        'Setting %s is not locked to this user!' => '设置%s未锁定到这个用户！',
        'Setting value is not valid!' => '设置值无效！',
        'Could not add modified setting!' => '无法添加修改过的设置！',
        'Could not update modified setting!' => '无法更新修改过的设置！',
        'Setting could not be unlocked!' => '设置无法解锁！',
        'Missing key %s!' => '缺失键%s！',
        'Invalid setting: %s' => '无效的设置：%s',
        'Could not combine settings values into a perl hash.' => '无法将设置值组合成一个perl哈希。',
        'Can not lock the deployment for UserID \'%s\'!' => '无法锁定用户ID为 \'%s\'的部署！',
        'All Settings' => '所有设置',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => '默认',
        'Value is not correct! Please, consider updating this field.' => '值不正确！ 请考虑更新这个字段。',
        'Value doesn\'t satisfy regex (%s).' => '值不满足正则表达式（%s）。',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '已启用',
        'Disabled' => '已禁用',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => '系统无法在OTRSTimeZone中计算用户的日期！',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            '系统无法在OTRSTimeZone中计算用户的日期时间！',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '值不正确！ 请考虑更新这个模块。',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '值不正确！ 请考虑更新这个设置。',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '重置解锁时间。',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '聊天参与人',
        'Chat Message Text' => '聊天消息文本',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            '登录失败！用户名或密码错误。',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '认证成功，但在数据库中没有找到用户数据记录，请联系系统管理员。',
        'Can`t remove SessionID.' => '不能移除会话ID。',
        'Logout successful.' => '成功注销。',
        'Feature not active!' => '功能尚未激活!',
        'Sent password reset instructions. Please check your email.' => '密码重置说明已发送，请检查邮件。',
        'Invalid Token!' => '令牌无效！',
        'Sent new password to %s. Please check your email.' => '新密码已发送到%s，请检查邮件。',
        'Error: invalid session.' => '错误：无效会话。',
        'No Permission to use this frontend module!' => '没有权限使用这个前端界面模块！',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '认证成功，但是后端没有发现此客户的记录，请联系系统管理员。',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '重置密码未成功，请联系系统管理员。',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '这个e-mail地址已经存在，请直接登录或重置密码。',
        'This email address is not allowed to register. Please contact support staff.' =>
            '这个email地址无法注册，请联系支持人员。',
        'Added via Customer Panel (%s)' => '通过客户界面已添加（%s）',
        'Customer user can\'t be added!' => '不能添加客户用户！',
        'Can\'t send account info!' => '不能发送帐户信息！',
        'New account created. Sent login information to %s. Please check your email.' =>
            '帐户创建成功。登录信息发送到%s，请查收邮件。',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '没有找到操作“%s”！',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => '暂时无效',
        'Group for default access.' => '具有默认权限的组。',
        'Group of all administrators.' => '所有管理员的组。',
        'Group for statistics access.' => '具有统计权限的组。',
        'new' => 'new-新建',
        'All new state types (default: viewable).' => '所有新工单的状态类型（默认：可查看）。',
        'open' => 'open-处理中',
        'All open state types (default: viewable).' => '所有处理中的工单的状态类型（默认：可查看）。',
        'closed' => 'closed-已关闭',
        'All closed state types (default: not viewable).' => '所有已关闭工单的状态类型（默认：不可查看）。',
        'pending reminder' => '挂起提醒',
        'All \'pending reminder\' state types (default: viewable).' => '所有挂起提醒的工单的状态类型（默认：可查看）。',
        'pending auto' => '等待自动',
        'All \'pending auto *\' state types (default: viewable).' => '所有等待自动成功/失败关闭的工单的状态类型（默认：可查看）。',
        'removed' => 'removed-已删除',
        'All \'removed\' state types (default: not viewable).' => '所有已移除工单的状态类型（默认：不可查看）。',
        'merged' => 'merged-已合并',
        'State type for merged tickets (default: not viewable).' => '合并的工单的状态类型（默认：不可查看）。',
        'New ticket created by customer.' => '客户创建的新工单。',
        'closed successful' => 'closed successful-成功关闭',
        'Ticket is closed successful.' => '工单已经成功关闭。',
        'closed unsuccessful' => 'closed unsuccessful-失败关闭',
        'Ticket is closed unsuccessful.' => '工单没有成功关闭。',
        'Open tickets.' => '处理工单。',
        'Customer removed ticket.' => '客户移除工单。',
        'Ticket is pending for agent reminder.' => '工单为服务人员提醒而挂起。',
        'pending auto close+' => '挂起等待成功关闭',
        'Ticket is pending for automatic close.' => '工单等待自动关闭而挂起。',
        'pending auto close-' => '挂起等待失败关闭',
        'State for merged tickets.' => '已合并工单的状态。',
        'system standard salutation (en)' => '系统标准问候语（英）',
        'Standard Salutation.' => '标准问候语。',
        'system standard signature (en)' => '系统标准签名（英）',
        'Standard Signature.' => '标准签名。',
        'Standard Address.' => '标准地址。',
        'possible' => '可能',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '跟进已关闭工单是可能的，这将会重新处理工单。',
        'reject' => '拒绝',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '跟进已关闭工单是不可能的，不会创建新工单。',
        'new ticket' => '新建工单',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '不能跟进已关闭工单，这将会创建一个新的工单。',
        'Postmaster queue.' => '邮箱管理员队列。',
        'All default incoming tickets.' => '所有默认进入的工单。',
        'All junk tickets.' => '所有的垃圾工单。',
        'All misc tickets.' => '所有的杂项工单。',
        'auto reply' => 'auto reply-自动回复',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '创建新工单后会发送自动答复。',
        'auto reject' => 'auto reject 自动拒绝',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '跟进工单被拒绝后会发送自动拒绝（在队列跟进选项设置为“拒绝”时）。',
        'auto follow up' => 'auto follow up-自动跟进',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '跟进工单被接受后会发送自动确认（在队列跟进选项设置为“可能”时）。',
        'auto reply/new ticket' => '自动回复/新工单',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '跟进工单被拒绝并创建新工单后会发送自动响应（在队列跟进选项设置为“新建工单”时）。',
        'auto remove' => 'auto remove-自动移除',
        'Auto remove will be sent out after a customer removed the request.' =>
            '客户移除请求后会发送自动移除。',
        'default reply (after new ticket has been created)' => '默认答复（新工单创建后）',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '默认拒绝（跟进已关闭工单被拒绝后）',
        'default follow-up (after a ticket follow-up has been added)' => '默认跟进（添加工单跟进后）',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '默认拒绝并创建新工单（跟进已关闭工单则创建新工单）',
        'Unclassified' => '未分类',
        '1 very low' => '1-非常低',
        '2 low' => '2-低',
        '3 normal' => '3-正常',
        '4 high' => '4-高',
        '5 very high' => '5-非常高',
        'unlock' => '未锁定',
        'lock' => '锁定',
        'tmp_lock' => '临时锁',
        'agent' => '服务人员',
        'system' => '系统',
        'customer' => '客户',
        'Ticket create notification' => '工单创建通知',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '每当创建一个新的工单，且该工单所属队列或服务在你设置的“我的队列”或“我的服务”中时，你都将收到一个通知。',
        'Ticket follow-up notification (unlocked)' => '工单跟进通知（解锁）',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '如果一个客户用户发送了一个跟进到一个解锁工单，且该工单所属队列或服务在你设置的“我的队列”或“我的服务”中时，你都将收到一个通知。',
        'Ticket follow-up notification (locked)' => '工单跟进通知（锁定）',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '如果一个客户用户发送了一个跟进到你是所有者或负责人的工单时，你都将收到一个通知。',
        'Ticket lock timeout notification' => '工单锁定超时通知',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '你是所有者的工单一被自动解锁你就会收到一个通知。',
        'Ticket owner update notification' => '工单所有者更新通知',
        'Ticket responsible update notification' => '工单负责人更新通知',
        'Ticket new note notification' => '工单添加备注通知',
        'Ticket queue update notification' => '工单队列更新通知',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '如果一个工单被转移到了你设置的“我的队列”之一，你将收到一个通知。',
        'Ticket pending reminder notification (locked)' => '工单挂起提醒通知（锁定）',
        'Ticket pending reminder notification (unlocked)' => '工单挂起提醒通知（解锁）',
        'Ticket escalation notification' => '工单升级通知',
        'Ticket escalation warning notification' => '工单升级警告通知',
        'Ticket service update notification' => '工单服务更新通知',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '如果一个工单的服务变更为你设置的“我的服务”之一，你将收到一个通知。',
        'Appointment reminder notification' => '预约提醒通知',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '每当你的一个预约到达提醒时间时，你就会收到一个通知。',
        'Ticket email delivery failure notification' => '工单邮件发送失败通知',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'AJAX通信时发生错误。 状态：%s，错误：%s',
        'This window must be called from compose window.' => '必须从撰写窗口调用此窗口。',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => '添加所有',
        'An item with this name is already present.' => '名称相同的条目已存在。',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '该条目中包含子条目。您真的想要删除这个条目及其子条目吗？',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '更多',
        'Less' => '更少',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '按Ctrl + C（Cmd + C）复制到剪贴板',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '删除这个附件',
        'Deleting attachment...' => '正在删除附件...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '删除附件时出错。 请检查日志以获取更多信息。',
        'Attachment was deleted successfully.' => '附件已成功删除。',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '您真的想要删除这个动态字段吗? 所有关联的数据将丢失!',
        'Delete field' => '删除字段',
        'Deleting the field and its data. This may take a while...' => '正在删除这个动态字段及其相关数据，可能还要等一会儿...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '删除此动态字段',
        'Remove selection' => '删除选择',
        'Do you really want to delete this generic agent job?' => '您真的想要删除这个自动任务吗？',
        'Delete this Event Trigger' => '删除这个事件触发器',
        'Duplicate event.' => '复制事件。',
        'This event is already attached to the job, Please use a different one.' =>
            '该事件已经附加到任务，请重新选择。',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => '在通信时发生一个错误。',
        'Request Details' => '请求详细信息',
        'Request Details for Communication ID' => '通信ID的请求详细信息',
        'Show or hide the content.' => '显示或隐藏该内容.',
        'Clear debug log' => '清空调试日志',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '删除错误处理模块',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '无法添加一个新的事件触发器，因为没有设置事件。',
        'Delete this Invoker' => '删除这个调用程序',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '对不起，唯一存在的条件是无法删除的。',
        'Sorry, the only existing field can\'t be removed.' => '对不起，唯一存在的字段是无法删除的。',
        'Delete conditions' => '删除条件',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '键 %s的映射',
        'Mapping for Key' => '键的映射',
        'Delete this Key Mapping' => '删除这个键映射',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => '删除这个操作',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => '克隆Web服务',
        'Delete operation' => '删除操作',
        'Delete invoker' => '删除调用程序',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '警告：当您更改\'管理\'组的名称时，在SysConfig作出相应的变化之前，你将被管理面板锁住！如果发生这种情况，请用SQL语句把组名改回到\'admin\'。',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '删除这个邮件帐户',
        'Deleting the mail account and its data. This may take a while...' =>
            '正在删除这个邮件帐户及其相关数据。 可能还要等一会儿...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '您真的要删除这个通知语言吗？',
        'Do you really want to delete this notification?' => '您真的想要删除这个通知?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '您真的要删除该键吗？',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '有一个程序包升级过程正在运行，点击这里查看有关升级进度的状态信息。',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '最近完成了一个软件包的升级，点击这里查看结果。',
        'No response from get package upgrade result.' => '获取软件包升级结果时没有响应。',
        'Update all packages' => '更新所有软件包',
        'Dismiss' => '取消',
        'Update All Packages' => '更新所有软件包',
        'No response from package upgrade all.' => '获取全部软件包升级结果时没有响应。',
        'Currently not possible' => '目前不可能',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '由于正在进行软件包升级，因此目前已被禁用。',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            '由于OTRS守护进程没有运行，这个选项当前被禁用。',
        'Are you sure you want to update all installed packages?' => '您确定要更新所有已安装的软件包吗？',
        'No response from get package upgrade run status.' => '获取软件包升级运行状态时没有响应。',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '删除此PostMasterFilter（邮箱管理员过滤器）',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '删除这个邮件管理员过滤器及其相关数据。 可能还要等一会儿...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => '从画布中删除实体',
        'No TransitionActions assigned.' => '没有分配转换动作。',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '没有分配活动对话框。请从左侧列表中选择一个活动对话框，并将它拖放到这里。',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '不能删除这个活动，因为它是开始活动。',
        'Remove the Transition from this Process' => '从流程中删除这个转换',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '一旦你使用这个按钮或链接,您将离开这个界面且当前状态将被自动保存。你想要继续吗?',
        'Delete Entity' => '删除实体',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '流程中已包括这个活动，你不能重复添加活动！',
        'Error during AJAX communication' => 'AJAX通信时发生错误',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '画布上已经有一个未连接的转换。在设置另一个转换之前，请先连接这个转换。',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '活动已经使用了这个转换，你不能重复添加转换！',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '路径已经使用了这个转换动作，你不能重复添加转换动作！',
        'Hide EntityIDs' => '隐藏实体编号',
        'Edit Field Details' => '编辑字段详情',
        'Customer interface does not support articles not visible for customers.' =>
            '客户界面不支持客户不可见的信件。',
        'Sorry, the only existing parameter can\'t be removed.' => '对不起，唯一存在的参数是无法删除的。',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '你确定要删除这个证书吗？',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '正在发送更新...',
        'Support Data information was successfully sent.' => '诊断信息已发送成功。',
        'Was not possible to send Support Data information.' => '不能发送支持数据。',
        'Update Result' => '更新结果',
        'Generating...' => '正在生成...',
        'It was not possible to generate the Support Bundle.' => '无法生成支持数据包。',
        'Generate Result' => '打包结果',
        'Support Bundle' => '支持数据包',
        'The mail could not be sent' => '邮件无法发送',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '无法将此条目设置为无效。 所有受影响的配置设置必须事先更改。',
        'Cannot proceed' => '无法继续',
        'Update manually' => '手动更新',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '为了反映您刚刚做出的更改，您可以自动更新受影响的设置，也可以点击“手动更新”。',
        'Save and update automatically' => '保存并自动更新',
        'Don\'t save, update manually' => '不保存，手动更新',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '您当前正在查看的条目是尚未部署的配置设置的一部分，这使得无法在当前状态下进行编辑，请等待设置部署后再编辑。 如果您不确定下一步该怎么办，请与系统管理员联系。',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => '载入中...',
        'Search the System Configuration' => '搜索系统配置',
        'Please enter at least one search word to find anything.' => '请输入至少一个搜索词以查找任何内容。',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '很遗憾，现在不能开始部署，也许是因为另一个服务人员已经开始部署了。 请稍后再试。',
        'Deploy' => '部署',
        'The deployment is already running.' => '部署已经在运行。',
        'Deployment successful. You\'re being redirected...' => '部署成功。 您正在重定向...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '有一个错误。 请保存您正在编辑的所有设置，并检查日志以获取更多信息。',
        'Reset option is required!' => '必须重置选项！',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '通过恢复此部署，所有设置将恢复为开始部署时所具有的值。 你确定要继续吗？',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '带有值的键不能被重命名。 请删除此键/值对，然后重新添加它。',
        'Unlock setting.' => '解锁设置。',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            '您真的要删除这个已安排的系统维护吗？',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '删除这个模板',
        'Deleting the template and its data. This may take a while...' =>
            '删除这个模板及其相关数据。 可能还要等一会儿...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '跳转',
        'Timeline Month' => '月时间表',
        'Timeline Week' => '周时间表',
        'Timeline Day' => '每日时间表',
        'Previous' => '上一步',
        'Resources' => '资源',
        'Su' => '日',
        'Mo' => '一',
        'Tu' => '二',
        'We' => '三',
        'Th' => '四',
        'Fr' => '五',
        'Sa' => '六',
        'This is a repeating appointment' => '这是一个重复的预约',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '你想仅编辑本次预约的时间还是重复预约所有的时间？',
        'All occurrences' => '所有预约',
        'Just this occurrence' => '仅本次预约',
        'Too many active calendars' => '激活的日历太多',
        'Please either turn some off first or increase the limit in configuration.' =>
            '请关闭一些日历或者在配置中增加限制数。',
        'Restore default settings' => '恢复默认设置',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '你真的要删除这个预约吗？这个操作无法回退。',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '首先选择一个客户用户，然后选择一个客户ID来分配给这个工单。',
        'Duplicated entry' => '重复条目',
        'It is going to be deleted from the field, please try again.' => '将自动删除这个重复的地址，请再试一次。',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '请至少输入一个搜索条件或输入*搜索所有。',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => '关于OTRS守护进程的信息',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '请检查标记为红色的字段，需要输入有效的值。',
        'month' => '月',
        'Remove active filters for this widget.' => '移除这个小部件的活动过滤器。',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '请稍候...',
        'Searching for linkable objects. This may take a while...' => '正在搜索可链接的对象，可能还要等一会儿...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '你确定要删除这个链接吗？',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '您是否使用像AdBlock或AdBlockPlus这样的浏览器插件？ 这可能会导致一些问题，我们强烈建议您为此域添加例外。',
        'Do not show this warning again.' => '不要再显示这个警告。',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '抱歉，你不能将标记为强制的通知的所有传输方法都禁用掉。',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '抱歉，你不能将本通知的所有传输方法都禁用掉。',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '请注意，你更改的设置至少有一个需要重新加载页面。 点击这里重新加载当前屏幕。',
        'An unknown error occurred. Please contact the administrator.' =>
            '出现未知错误，请联系管理员。',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => '切换到桌面模式',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '请移除以下不能用于搜索的词语：',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '生成',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '这个元素有子元素，目前不能被删除。',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '您真的要删除这个统计吗？',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '选择要分配给这个工单的客户ID',
        'Do you really want to continue?' => '您真的要继续吗？',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => ' ...还有%s',
        ' ...show less' => ' ...显示少量',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '添加新的草稿',
        'Delete draft' => '删除草稿',
        'There are no more drafts available.' => '没有更多的草稿可用。',
        'It was not possible to delete this draft.' => '不能删除这个草稿。',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => '信件过滤器',
        'Apply' => '应用',
        'Event Type Filter' => '事件类型过滤器',

        # JS File: Core.Agent
        'Slide the navigation bar' => '滑动导航栏',
        'Please turn off Compatibility Mode in Internet Explorer!' => '请关闭IE的兼容模式！',
        'Find out more' => '了解更多',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => '切换到移动模式',

        # JS File: Core.App
        'Error: Browser Check failed!' => '错误：浏览器检查失败！',
        'Reload page' => '刷新页面',
        'Reload page (%ss)' => '刷新页面（%ss）',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '命名空间%s无法初始化，因为找不到%s。',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '发生错误！ 请查看浏览器错误日志了解更多详情！',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => '发生了一个或多个错误!',

        # JS File: Core.Installer
        'Mail check successful.' => '邮件配置检查成功完成。',
        'Error in the mail settings. Please correct and try again.' => '邮件设置错误, 请修改后再试一次。',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '在新窗口中打开此节点',
        'Please add values for all keys before saving the setting.' => '在保存设置之前，请添加所有键的值。',
        'The key must not be empty.' => '键不能为空。',
        'A key with this name (\'%s\') already exists.' => '此名称（\'%s\'）的键已存在。',
        'Do you really want to revert this setting to its historical value?' =>
            '你确定要把这个设置恢复到它的历史值吗？',

        # JS File: Core.UI.Datepicker
        'Open date selection' => '打开日历',
        'Invalid date (need a future date)!' => '无效的日期（需使用未来的日期）！',
        'Invalid date (need a past date)!' => '无效的日期（需使用过去的日期）！',

        # JS File: Core.UI.InputFields
        'Not available' => '不可用',
        'and %s more...' => '还有%s...',
        'Show current selection' => '显示当前选择',
        'Current selection' => '当前选择',
        'Clear all' => '清除所有',
        'Filters' => '过滤器',
        'Clear search' => '清除搜索',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '如果你现在离开该页, 所有弹出的窗口也随之关闭!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '一个弹出屏幕已经打开，你想先关闭它再打开一个吗？',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '无法打开弹出窗口，请禁用本应用的弹出屏幕拦截设置。',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '已应用升序排序， ',
        'Descending sort applied, ' => '已应用降序排序， ',
        'No sort applied, ' => '没有应用排序， ',
        'sorting is disabled' => '排序被禁用',
        'activate to apply an ascending sort' => '激活以应用升序排序',
        'activate to apply a descending sort' => '激活以应用降序排序',
        'activate to remove the sort' => '激活以取消排序',

        # JS File: Core.UI.Table
        'Remove the filter' => '移除过滤器',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => '目前没有可供选择的元素。',

        # JS File: Core.UI
        'Please only select one file for upload.' => '请只选择一个文件进行上传。',
        'Sorry, you can only upload one file here.' => '对不起，您只能在这里上传一个文件。',
        'Sorry, you can only upload %s files.' => '对不起，您只能在这里上传%s个文件。',
        'Please only select at most %s files for upload.' => '请至少选择%s个文件进行上传。',
        'The following files are not allowed to be uploaded: %s' => '不允许上传以下文件：%s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '以下文件超过允许的单个文件最大大小%s，没有上传的文件有：%s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '以下文件已上传，没有重复上传：%s',
        'No space left for the following files: %s' => '以下文件没有可用空间：%s',
        'Available space %s of %s.' => '可用空间%s，总共%s。',
        'Upload information' => '上传信息',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '删除附件时发生未知错误，请再试一次。 如果错误仍然存在，请与系统管理员联系。',

        # JS File: Core.Language.UnitTest
        'yes' => '是',
        'no' => '否',
        'This is %s' => '这是%s',
        'Complex %s with %s arguments' => '复杂%s，带有%s参数',

        # JS File: OTRSLineChart
        'No Data Available.' => '没有可用数据。',

        # JS File: OTRSMultiBarChart
        'Grouped' => '分组的',
        'Stacked' => '堆叠的',

        # JS File: OTRSStackedAreaChart
        'Stream' => '流',
        'Expanded' => '展开的',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
尊敬的客户，

很不幸我们没有找到你主题中提到的工单号，所以这封邮件无法处理。

请通过客户网页创建一个新的工单。

感谢您的支持！
您的服务台团队
',
        ' (work units)' => ' （工作日）',
        ' 2 minutes' => ' 2 分钟',
        ' 5 minutes' => ' 5 分钟',
        ' 7 minutes' => ' 7 分钟',
        '"Slim" skin which tries to save screen space for power users.' =>
            '为高级用户节约屏幕空间的“修身版”皮肤。',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '（登录用户名）名 姓',
        '(UserLogin) Lastname Firstname' => '（登录用户名）姓 名',
        '(UserLogin) Lastname, Firstname' => '（登录用户名）姓, 名',
        '*** out of office until %s (%s d left) ***' => '*** %s前不在办公室（还有%s天）***',
        '0 - Disabled' => '0 - 禁用',
        '1 - Available' => '1 - 可用',
        '1 - Enabled' => '1 - 启用',
        '10 Minutes' => '10分钟',
        '100 (Expert)' => '100（专家）',
        '15 Minutes' => '15分钟',
        '2 - Enabled and required' => '2 - 启用且必需',
        '2 - Enabled and shown by default' => '2 - 启用并默认显示',
        '2 - Enabled by default' => '2 - 默认启用',
        '2 Minutes' => '2分钟',
        '200 (Advanced)' => '200（高级）',
        '30 Minutes' => '30分钟',
        '300 (Beginner)' => '300（新手）',
        '5 Minutes' => '5 分钟',
        'A TicketWatcher Module.' => '工单关注者模块。',
        'A Website' => '网址',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '在合并工单过程中合并到主工单的动态字段列表，只有主工单中为空的动态字段才会被设置。',
        'A picture' => '图片',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL模块仅在所有子工单都关闭后才允许关闭父工单（除非所有子工单都已经关闭，否则父工单显示的“状态”均不可用）。',
        'Access Control Lists (ACL)' => '访问控制列表(ACL)',
        'AccountedTime' => '占用时间',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '包含最早工单的队列激活闪烁提醒机制。',
        'Activates lost password feature for agents, in the agent interface.' =>
            '在服务人员界面中，激活忘记密码功能。',
        'Activates lost password feature for customers.' => '在客户界面中，激活忘记密码功能。',
        'Activates support for customer and customer user groups.' => '激活对客户和客户用户组的支持。',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '在详情视图中激活信件过滤器以指定显示的信件。',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '激活系统中的可用主题。值1-代表激活，0-代表不激活。',
        'Activates the ticket archive system search in the customer interface.' =>
            '在客户界面中，激活工单归档搜索功能。',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '激活工单归档系统，将一些工单移出日常范围以便拥有更快速的系统响应。要搜索这些工单，需要在工单搜索时启用“归档搜索”。',
        'Activates time accounting.' => '激活工时管理。',
        'ActivityID' => '活动ID',
        'Add a note to this ticket' => '添加工单备注',
        'Add an inbound phone call to this ticket' => '为本工单添加一个客户来电',
        'Add an outbound phone call to this ticket' => '为本工单添加致电客户',
        'Added %s time unit(s), for a total of %s time unit(s).' => '已添加%s个时间单位，总共有%s个时间单位。',
        'Added email. %s' => '已添加电子邮件：%s',
        'Added follow-up to ticket [%s]. %s' => '已添加到工单 [%s]的跟进。%s',
        'Added link to ticket "%s".' => '已添加到工单的链接：“%s”。',
        'Added note (%s).' => '已添加备注 (%s)。',
        'Added phone call from customer.' => '已添加来自客户的电话。',
        'Added phone call to customer.' => '已添加打给客户的电话。',
        'Added subscription for user "%s".' => '已为用户“%s”添加关注。',
        'Added system request (%s).' => '已添加系统请求 (%s)。',
        'Added web request from customer.' => '已添加来自客户的网页请求。',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '为OTRS日志文件添加实际年月的后缀，每月创建一个日志文件。',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '在服务人员界面中，在编写工单时添加客户邮件地址到收件人，如果信件类型为内部邮件则不添加客户邮件地址。',
        'Adds the one time vacation days for the indicated calendar.' => '为指定日历添加一次假期。',
        'Adds the one time vacation days.' => '添加一次性假期。',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '为指定日历添加永久假期。',
        'Adds the permanent vacation days.' => '添加永久假期。',
        'Admin' => '系统管理',
        'Admin Area.' => '系统管理区。',
        'Admin Notification' => '管理员通知',
        'Admin area navigation for the agent interface.' => '服务人员界面系统管理模块导航。',
        'Admin modules overview.' => '系统管理模块概览。',
        'Admin.' => '系统管理。',
        'Administration' => '管理',
        'Agent Customer Search' => '服务人员搜索客户',
        'Agent Customer Search.' => '服务人员搜索客户。',
        'Agent Name' => '服务人员姓名',
        'Agent Name + FromSeparator + System Address Display Name' => '服务人员姓名 + 隔离符号 + 系统邮件地址显示姓名',
        'Agent Preferences.' => '服务人员偏好设置。',
        'Agent Statistics.' => '服务人员统计。',
        'Agent User Search' => '服务人员搜索用户',
        'Agent User Search.' => '服务人员搜索用户。',
        'Agent interface article notification module to check PGP.' => '服务人员界面检查PGP的信件通知模块。',
        'Agent interface article notification module to check S/MIME.' =>
            '服务人员界面检查S/MIME的信件通知模块。',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '通过导航栏访问客户信息中心的服务人员界面模块。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '通过导航栏访问全文搜索的服务人员界面模块。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '通过导航栏访问搜索模板的服务人员界面模块。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '如果启用S/MIME且有可用键时在工单详情视图检查进入邮件的服务人员界面模块。',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '查看锁定工单数的服务人员界面通知模块。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '查看服务人员负责工单数的服务人员界面通知模块。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '查看服务人员所属服务工单数的服务人员界面通知模块。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '查看服务人员关注工单数的服务人员界面通知模块。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            '服务人员工单详情小部件，显示链接到该工单的对象表。',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            '服务人员工单详情小部件，在侧边栏中显示客户信息。',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            '服务人员工单详情小部件，在侧边栏显示工单数据。',
        'Agents ↔ Groups' => '服务人员 ↔ 组',
        'Agents ↔ Roles' => '服务人员 ↔ 角色',
        'All CustomerIDs of a customer user.' => '一个客户用户的所有客户ID。',
        'All attachments (OTRS Business Solution™)' => '所有附件（OTRS商业解决方案）',
        'All customer users of a CustomerID' => '一个客户ID的所有客户用户',
        'All escalated tickets' => '所有升级的工单',
        'All new tickets, these tickets have not been worked on yet' => '所有新建工单，这些工单目前还没有被处理',
        'All open tickets, these tickets have already been worked on.' =>
            '所有处理的工单，这些工单已经在处理了。',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '所有提醒时间已过的工单',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '在服务人员界面允许在工单关闭界面添加备注，可以被Ticket::Frontend::NeedAccountedTime设置覆盖。',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '在服务人员界面允许在工单自定义字段界面添加备注，可以被Ticket::Frontend::NeedAccountedTime设置覆盖。',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '在服务人员界面允许在工单备注界面添加备注，可以被Ticket::Frontend::NeedAccountedTime设置覆盖。',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '在服务人员界面允许在工单所有者界面添加备注，可以被Ticket::Frontend::NeedAccountedTime设置覆盖。',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '在服务人员界面允许在工单详情的挂起界面添加备注，可以被Ticket::Frontend::NeedAccountedTime设置覆盖。',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '在服务人员界面允许在工单详情的优先级界面添加备注，可以被Ticket::Frontend::NeedAccountedTime设置覆盖。',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '在服务人员界面允许在工单负责人界面添加备注，可以被Ticket::Frontend::NeedAccountedTime设置覆盖。',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '允许服务人员交换生成的统计的X轴和Y轴。',
        'Allows agents to generate individual-related stats.' => '允许服务人员生成其个人相关的统计。',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '允许选择是在浏览器中显示附件（inline）或只是提供附件下载（attachment）。',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '在客户界面允许选择客户工单的下一个编写状态。',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '在客户界面允许选择工单的优先级。',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '在客户界面允许设置工单的SLA。',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '在客户界面允许设置工单的优先级。',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '允许在客户界面设置工单的队列，如果此处未启用，则需要配置QueueDefault（默认队列）。',
        'Allows customers to set the ticket service in the customer interface.' =>
            '在客户界面允许设置工单所属的服务。',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '允许在客户界面设置工单类型，如果此处未启用，则需要配置TicketTypeDefault（默认工单类型）。',
        'Allows default services to be selected also for non existing customers.' =>
            '允许未知客户选择默认服务。',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '允许定义工单的服务和SLA（例如：邮件、桌面、网络等等），以及SLA的升级属性（如果启用了工单服务/SLA功能）。',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '允许在服务人员界面搜索工单时扩展搜索条件，通过这个功能您可以按如下条件搜索：带“(*key1*&&*key2*)”或“(*key1*||*key2*)”条件的工单标题。',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '允许在客户界面搜索工单时扩展搜索条件，通过这个功能您可以按如下条件搜索：带“(*key1*&&*key2*)”或“(*key1*||*key2*)”条件的工单标题。',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '允许在自动任务界面搜索工单时扩展搜索条件，通过这个功能您可以按如下条件搜索：“(key1&&key2)”或“(key1||key2)”。',
        'Allows generic agent to execute custom command line scripts.' =>
            '允许自动任务执行定制的命令行脚本。',
        'Allows generic agent to execute custom modules.' => '允许自动任务执行定制的模块。',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '允许拥有一个基本版式的工单概览视图（如果CustomerInfo => 1还将显示客户信息）。',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '允许拥有一个简洁版式的工单概览视图（如果CustomerInfo => 1还将显示客户信息）。',
        'Allows invalid agents to generate individual-related stats.' => '允许失效的服务人员生成个人相关的统计。',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '允许系统管理员作为其他客户登录（通过客户用户管理面板）。',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '允许系统管理员作为其他用户登录（通过服务人员管理面板）。',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            '允许在服务人员界面关闭工单屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            '允许在服务人员界面外发邮件屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            '允许在服务人员界面工单撰写屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            '允许在服务人员界面工单转发屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            '允许在服务人员界面关闭自定义字段屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            '允许在服务人员界面工单转移屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            '允许在服务人员界面工单备注屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            '允许在服务人员界面工单所有者屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            '允许在服务人员界面工单挂起屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            '允许在服务人员界面工单电话接入屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            '允许在服务人员界面工单电话拨出屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            '允许在服务人员界面工单优先级屏幕将当前工作保存为草稿。',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            '允许在服务人员界面工单负责人屏幕将当前工作保存为草稿。',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '允许服务人员界面移动工单界面设置新的工单状态。',
        'Always show RichText if available' => '始终显示富文本（如果有富文本）',
        'Answer' => '回复',
        'Appointment Calendar overview page.' => '预约日历概览页面。',
        'Appointment Notifications' => '预约通知',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            '预约日历事件模块，准备预约的通知消息。',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            '预约日历事件模块，更新工单的预约数据。',
        'Appointment edit screen.' => '预约编辑屏幕。',
        'Appointment list' => '预约列表',
        'Appointment list.' => '预约列表。',
        'Appointment notifications' => '预约通知',
        'Appointments' => '预约',
        'Arabic (Saudi Arabia)' => '阿拉伯语（沙特阿拉伯）',
        'ArticleTree' => '信件树',
        'Attachment Name' => '附件名',
        'Automated line break in text messages after x number of chars.' =>
            '文本消息中在X个字符后自动换行。',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '工单解锁后，自动更改所有者无效的工单的状态。从一个状态类型映射到一个新的工单状态。',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '在服务人员界面处理转移工单后自动锁定并设置当前服务人员为工单所有者。',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '选择批量操作后自动锁定并设置当前服务人员为工单所有者。',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '如果启用了工单负责人功能，自动设置工单所有者为其负责人。这个选项只适用于登录用户的手动操作，不适用于自动操作如自动任务、邮箱管理员过滤和通用接口。',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '在第一次工单所有者更新后自动设置工单的负责人（如果还没有设置）。',
        'Avatar' => '头像',
        'Balanced white skin by Felix Niklas (slim version).' => 'Felix Niklas制作的平衡白皮肤（修身版）。',
        'Balanced white skin by Felix Niklas.' => 'Felix Niklas制作的平衡白皮肤。',
        'Based on global RichText setting' => '基于全局富文本设置',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '基本的全文索引设置。执行 "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" 以生成一个新索引。',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '阻止所有来自@example.com地址、主题中无有效工单号的进入邮件。',
        'Bounced to "%s".' => '退回给“%s”。',
        'Bulgarian' => '保加利亚语',
        'Bulk Action' => '批量操作',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '命令行样例设置。忽略外部命令行返回在STDOUT（标准输出）上的一些输出的邮件（邮件将用管道输入到some.bin的STDIN标准输入）。',
        'CSV Separator' => 'CSV分隔符',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '在通用接口服务人员认证的缓存时间（秒）。',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '在通用接口客户认证的缓存时间（秒）。',
        'Cache time in seconds for the DB ACL backend.' => '数据库ACL后端的缓存时间（秒）。',
        'Cache time in seconds for the DB process backend.' => '数据库进程后端的缓存时间（秒）。',
        'Cache time in seconds for the SSL certificate attributes.' => 'SSL证书属性的缓存时间（秒）。',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '工单处理导航栏输出模块的缓存时间（秒）。',
        'Cache time in seconds for the web service config backend.' => 'WEB服务配置后端的缓存时间（秒）。',
        'Calendar manage screen.' => '日历管理屏幕。',
        'Catalan' => '加泰罗尼亚语',
        'Change password' => '修改密码',
        'Change queue!' => '变更队列！',
        'Change the customer for this ticket' => '更改这个工单的客户',
        'Change the free fields for this ticket' => '修改这个工单的自由字段',
        'Change the owner for this ticket' => '更改工单所有者',
        'Change the priority for this ticket' => '更改这个工单的优先级',
        'Change the responsible for this ticket' => '更改这个工单的负责人',
        'Change your avatar image.' => '更改你的头像图片。',
        'Change your password and more.' => '更改你的密码及其它。',
        'Changed SLA to "%s" (%s).' => '已修改SLA为"%s" (%s)。',
        'Changed archive state to "%s".' => '已修改归档状态为"%s" 。',
        'Changed customer to "%s".' => '已更改客户为"%s" 。',
        'Changed dynamic field %s from "%s" to "%s".' => '已修改动态字段%s 从"%s" 到"%s" 。',
        'Changed owner to "%s" (%s).' => '已更改所有者为 "%s" (%s)。',
        'Changed pending time to "%s".' => '已更改挂起时间到 "%s"。',
        'Changed priority from "%s" (%s) to "%s" (%s).' => '工单优先级已从“%s” (%s)变更到 “%s” (%s)。',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '队列已从“%s” (%s)变更到 “%s” (%s)。',
        'Changed responsible to "%s" (%s).' => '已变更负责人为 "%s" (%s)。',
        'Changed service to "%s" (%s).' => '已变更服务为 "%s" (%s)。',
        'Changed state from "%s" to "%s".' => '状态已从"%s"变更为"%s"。',
        'Changed title from "%s" to "%s".' => '标题已从"%s"变更为"%s"。',
        'Changed type from "%s" (%s) to "%s" (%s).' => '类型已从“%s” (%s)变更到 “%s” (%s)。',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '变更工单所有者为所有人（ASP有用），一般只显示这个工单队列中有读写权限的服务人员。',
        'Chat communication channel.' => '聊天通信渠道。',
        'Checkbox' => '复选框',
        'Checks for articles that needs to be updated in the article search index.' =>
            '检查信件搜索索引中需要更新的信件。',
        'Checks for communication log entries to be deleted.' => '检查要删除的通信日志条目。',
        'Checks for queued outgoing emails to be sent.' => '检查要发送的排队外发邮件。',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '通过搜索主题中的有效工单号，检查一个邮件是否是跟进到已存在的工单。',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '在跟进工单的工单编号检测时检查系统ID。如果不启用，系统ID将在使用系统后更改。',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '检查本系统的OTRS商业版可用性。',
        'Checks the entitlement status of OTRS Business Solution™.' => '检查OTRS商业版的权利状态。',
        'Child' => '子',
        'Chinese (Simplified)' => '简体中文',
        'Chinese (Traditional)' => '繁体中文',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '选择你要接收哪些预约变动的通知消息。',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '选择你要接收哪些工单变更的通知消息。 请注意，您不能完全禁用标记为强制性的通知。',
        'Choose which notifications you\'d like to receive.' => '选择您想要接收的通知。',
        'Christmas Eve' => '平安夜',
        'Close' => '关闭',
        'Close this ticket' => '关闭工单',
        'Closed tickets (customer user)' => '已关闭的工单（客户用户）',
        'Closed tickets (customer)' => '已关闭的工单（客户）',
        'Cloud Services' => '云服务',
        'Cloud service admin module registration for the transport layer.' =>
            '云服务的传输层管理模块注册。',
        'Collect support data for asynchronous plug-in modules.' => '收集异步插件模块的支持数据。',
        'Column ticket filters for Ticket Overviews type "Small".' => '工单概览简洁版式的字段过滤器。',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '可以在服务人员界面工单升级视图中过滤的列。 注意：只允许使用工单属性、动态字段（DynamicField_NameX）和客户属性（例如CustomerUserPhone，CustomerCompanyName，...）。',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '可以在服务人员界面锁定的工单视图中过滤的列。 注意：只允许使用工单属性、动态字段（DynamicField_NameX）和客户属性（例如CustomerUserPhone，CustomerCompanyName，...）。',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '可以在服务人员界面工单队列视图中过滤的列。 注意：只允许使用工单属性、动态字段（DynamicField_NameX）和客户属性（例如CustomerUserPhone，CustomerCompanyName，...）。',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '可以在服务人员界面工单负责人视图中过滤的列。 注意：只允许使用工单属性、动态字段（DynamicField_NameX）和客户属性（例如CustomerUserPhone，CustomerCompanyName，...）。',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '可以在服务人员界面工单服务视图中过滤的列。 注意：只允许使用工单属性、动态字段（DynamicField_NameX）和客户属性（例如CustomerUserPhone，CustomerCompanyName，...）。',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '可以在服务人员界面工单状态视图中过滤的列。 注意：只允许使用工单属性、动态字段（DynamicField_NameX）和客户属性（例如CustomerUserPhone，CustomerCompanyName，...）。',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '可以在服务人员界面工单搜索结果视图中过滤的列。 注意：只允许使用工单属性、动态字段（DynamicField_NameX）和客户属性（例如CustomerUserPhone，CustomerCompanyName，...）。',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '可以在服务人员界面工单关注视图中过滤的列。 注意：只允许使用工单属性、动态字段（DynamicField_NameX）和客户属性（例如CustomerUserPhone，CustomerCompanyName，...）。',
        'Comment for new history entries in the customer interface.' => '在客户界面中新的历史条目的注释。',
        'Comment2' => '注释2',
        'Communication' => '通信',
        'Communication & Notifications' => '通信和通知',
        'Communication Log GUI' => '通信日志图形用户界面',
        'Communication log limit per page for Communication Log Overview.' =>
            '通信日志概览中每页的通信日志条目限制。',
        'CommunicationLog Overview Limit' => '通信日志概览限制',
        'Company Status' => '单位状态',
        'Company Tickets.' => '单位工单。',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '单位名称将作为X-Header包括在外发邮件中。',
        'Compat module for AgentZoom to AgentTicketZoom.' => '服务人员工单详情视图中服务人员详情的兼容模块。',
        'Complex' => '复杂',
        'Compose' => '撰写',
        'Configure Processes.' => '配置流程。',
        'Configure and manage ACLs.' => '配置和管理ACL。',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '配置任何您想要使用的额外只读镜像数据库。',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '配置为提升支持效果而发送给OTRDS集团的支持数据。',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '配置创建新工单后显示的界面。',
        'Configure your own log text for PGP.' => '配置您自己的PGP日志文本。',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            '配置默认的TicketDynamicField（工单动态字段）设置，“Name（名称）”定义要使用的动态字段，“Value（值）”是要设置的数值，“Event（事件）”定义触发的事件。请检查开发手册 (https://doc.otrs.com/doc/) 的“Ticket Event Module（工单事件模块）”章节。',
        'Controls how to display the ticket history entries as readable values.' =>
            '控制如何显示工单历史条目为可读值。',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '控制是否自动将未知客户的发件人地址复制为CustomerID 。',
        'Controls if CustomerID is read-only in the agent interface.' => '控制在服务人员界面中CustomerID 是否为只读。',
        'Controls if customers have the ability to sort their tickets.' =>
            '控制客户能否对他们的工单排序。',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '控制在服务人员界面中新建电话工单能否设置不止一个“发件人”条目。',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '控制系统管理员能否在系统配置中导入一个已保存的配置。',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '控制系统管理员能否通过SQL查询屏幕修改数据库。',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '控制自动填充字段是否用于管理客户用户界面中的客户ID选择。',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '控制工单和信件归档后的可见标志是否被移除。',
        'Converts HTML mails into text messages.' => '将HTML邮件转换为文本信息。',
        'Create New process ticket.' => '创建新的流程工单。',
        'Create Ticket' => '创建工单',
        'Create a new calendar appointment linked to this ticket' => '创建一个新的日历预约到这个工单',
        'Create and manage Service Level Agreements (SLAs).' => '创建和管理服务品质协议(SLA)。',
        'Create and manage agents.' => '创建和管理服务人员。',
        'Create and manage appointment notifications.' => '创建和管理预约通知.',
        'Create and manage attachments.' => '创建和管理附件。',
        'Create and manage calendars.' => '创建和管理日历。',
        'Create and manage customer users.' => '创建和管理客户用户。',
        'Create and manage customers.' => '创建和管理客户。',
        'Create and manage dynamic fields.' => '创建和管理动态字段。',
        'Create and manage groups.' => '创建和管理组。',
        'Create and manage queues.' => '创建和管理队列。',
        'Create and manage responses that are automatically sent.' => '创建和管理自动响应。',
        'Create and manage roles.' => '创建和管理角色。',
        'Create and manage salutations.' => '创建和管理邮件开头的问候语。',
        'Create and manage services.' => '创建和管理服务。',
        'Create and manage signatures.' => '创建和管理签名。',
        'Create and manage templates.' => '创建和管理模板。',
        'Create and manage ticket notifications.' => '创建和管理工单通知。',
        'Create and manage ticket priorities.' => '创建和管理工单优先级别。',
        'Create and manage ticket states.' => '创建和管理工单状态。',
        'Create and manage ticket types.' => '创建和管理工单类型。',
        'Create and manage web services.' => '创建和管理Web服务。',
        'Create new Ticket.' => '创建新工单。',
        'Create new appointment.' => '创建新的预约。',
        'Create new email ticket and send this out (outbound).' => '创建新的邮件工单并给客户发邮件（外发）。',
        'Create new email ticket.' => '创建新的邮件工单。',
        'Create new phone ticket (inbound).' => '创建新的电话工单（来电）。',
        'Create new phone ticket.' => '创建新的电话工单。',
        'Create new process ticket.' => '创建新的流程工单。',
        'Create tickets.' => '创建工单。',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '已创建工单 [%s]，在 "%s"，优先级为"%s" ，状态为"%s"。',
        'Croatian' => '克罗地亚语',
        'Custom RSS Feed' => '定制RSS订阅',
        'Custom RSS feed.' => '定制RSS订阅。',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '显示给还没有工单的客户的网页定制文本（如果您需要翻译这些文本，将它们添加到定制翻译模块）。',
        'Customer Administration' => '客户管理',
        'Customer Companies' => '客户单位',
        'Customer IDs' => '客户ID',
        'Customer Information Center Search.' => '客户信息中心搜索。',
        'Customer Information Center search.' => '客户信息中心搜索。',
        'Customer Information Center.' => '客户信息中心。',
        'Customer Ticket Print Module.' => '客户工单打印模块。',
        'Customer User Administration' => '客户用户管理',
        'Customer User Information' => '客户用户信息',
        'Customer User Information Center Search.' => '客户用户信息中心搜索。',
        'Customer User Information Center search.' => '客户用户信息中心搜索。',
        'Customer User Information Center.' => '客户用户信息中心。',
        'Customer Users ↔ Customers' => '客户用户 ↔ 客户',
        'Customer Users ↔ Groups' => '客户用户 ↔ 组',
        'Customer Users ↔ Services' => '客户用户 ↔ 服务',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '显示已关闭工单信息块的客户信息（图标）。设置参数CustomerUserLogin为1，则基于登录名而不是客户ID搜索工单。',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '显示处理中工单信息块的客户信息（图标）。设置参数CustomerUserLogin为1，则基于登录名而不是客户ID搜索工单。',
        'Customer preferences.' => '客户偏好设置。',
        'Customer ticket overview' => '客户工单概览',
        'Customer ticket search.' => '客户工单搜索。',
        'Customer ticket zoom' => '客户工单详情',
        'Customer user search' => '客户用户搜索',
        'CustomerID search' => '客户ID搜索',
        'CustomerName' => '客户名称',
        'CustomerUser' => '客户',
        'Customers ↔ Groups' => '客户 ↔ 组',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引可定制的停用词，这些词将从搜索索引中移除。',
        'Czech' => '捷克语',
        'Danish' => '丹麦语',
        'Dashboard overview.' => '仪表板概览。',
        'Data used to export the search result in CSV format.' => '用于将搜索结果输出为CSV格式的数据。',
        'Date / Time' => '日期 / 时间',
        'Default (Slim)' => '默认（修身版）',
        'Default ACL values for ticket actions.' => '工单操作的默认ACL值。',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '自动生成的流程实体ID的默认前缀。',
        'Default agent name' => '默认的服务人员姓名',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '工单搜索屏幕用于搜索属性的默认数据。示例：“TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;”。',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '工单搜索屏幕用于搜索属性的默认数据。示例：“TicketCreateTimeStartYear=2015;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2015;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;”。',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '在服务人员和客户工单详情中收件人（TO，CC）的默认显示类型。',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '在服务人员和客户工单详情中发件人（From）的默认显示类型。',
        'Default loop protection module.' => '默认的邮件环路保护模块。',
        'Default queue ID used by the system in the agent interface.' => '在服务人员界面中系统使用的默认队列ID。',
        'Default skin for the agent interface (slim version).' => '服务人员界面的默认皮肤（修身版）。',
        'Default skin for the agent interface.' => '服务人员界面的默认皮肤。',
        'Default skin for the customer interface.' => '客户界面的默认皮肤。',
        'Default ticket ID used by the system in the agent interface.' =>
            '在服务人员界面中系统使用的默认工单ID。',
        'Default ticket ID used by the system in the customer interface.' =>
            '在客户界面中系统使用的默认工单ID。',
        'Default value for NameX' => 'NameX的默认值',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '定义链接对象小部件(LinkObject::ViewMode = \"complex\")设置按钮中的操作。请注意，这些操作必须已经在以下JS和CSS文件中注册：Core.AllocationList.css、Core.UI.AllocationList.js、 Core.UI.Table.Sort.js、Core.Agent.TableFilters.js。',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '在HTML输出结果中为预定义字符串添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（例如：faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            '定义客户用户数据（键）与工单动态字段（值）的映射。目的是在工单动态字段中存储客户用户数据。动态字段必须存在于系统中且启用了AgentTicketFreeText（服务人员工单自由文本），这样才能由服务人员手动设置/更新。动态字段不能在服务人员电话工单、邮件工单和客户工单中启用，否则他们将优先于自动设置值。要使用这些映射，还要激活Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser的设置。',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '定义结束时间的动态字段名称。这个字段需要手动加入到系统作为工单的一种“日期/时间”，并且要在工单创建屏幕和/或其它任何工单操作屏幕激活。',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '定义开始时间的动态字段名称。这个字段需要手动加入到系统作为工单的一种“日期/时间”，并且要在工单创建屏幕和/或其它任何工单操作屏幕激活。',
        'Define the max depth of queues.' => '定义队列的最大深度。',
        'Define the queue comment 2.' => '定义队列注释2。',
        'Define the service comment 2.' => '定义服务注释2。',
        'Define the sla comment 2.' => '定义SLA注释2。',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '为选定的日历定义日期选择器中一周的起始日。',
        'Define the start day of the week for the date picker.' => '定义日期选择器中一周的起始日。',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '如果没有分配邮件地址的个人全球统一标识头像，则定义信件视图应该使用哪个头像作为默认图像。 查看 https://gravatar.com/site/implement/images/ 以了解更多信息。',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '如果没有分配给服务人员的邮件地址的个人全球统一标识头像，则定义当前服务人员应该使用哪个头像作为默认图像。 查看 https://gravatar.com/site/implement/images/ 以了解更多信息。',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            '定义服务人员工单详情中的服务人员头像和的发件人图片使用哪个头像引擎。 如果选择“无”，则用缩写替代。 请注意，选择除“无”之外的任何内容都会将特定用户的加密过的电子邮件地址传输到外部服务。',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '定义链接的预约小部件(LinkObject::ViewMode = "complex")要显示的列。可用的设置值为：0 = 禁用，1 = 可用， 2 = 默认启用。',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '定义链接的工单小部件中显示哪些列（LinkObject::ViewMode = "complex"）。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '定义一个客户条目，以在客户信息块的尾部生成一个LinkedIn图标。',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '定义一个客户条目，以在客户信息块的尾部生成一个XING图标。',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '定义一个客户条目，以在客户信息块的尾部生成一个谷歌图标。',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '定义一个客户条目，以在客户信息块的尾部生成一个谷歌地图图标。',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定义HTML输出结果中在CVE号码后面添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（如faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定义HTML输出结果中在微软公告号码后面添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（如faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '在HTML输出结果中为预定义字符串添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（如faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定义HTML输出结果中在BUG追踪号码后面添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（如faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '定义一个在服务人员工单详情屏幕从信件文本中搜集CVE编号的过滤器，并在靠近信件的一个自定义区块中显示结果。如果想要在鼠标移到到链接元素上时显示内容预览，就填写URLPreview字段。它可以与URL中的地址相同，也可以是另外一个URL。请注意：一些网站不能在iframe框架中显示（如Google），这样就无法在预览模式中正常显示内容。',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '定义信件中处理文本的过滤器，以便高亮预定义的关键词。',
        'Defines a permission context for customer to group assignment.' =>
            '定义客户分按组分配的权限上下文。',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '定义一个执行语法检查以排除某些地址的正则表达式（如果参数“检查邮件地址”设置为“是”）。请在这里为语句构成上无效但系统需要的邮件地址输入一个正则表达式（如root@localhost）。',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '定义一个正则表达式过滤不能在本系统中使用的所有邮件地址。',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '定义工单被任务处理前的睡眠时间（微秒）。',
        'Defines a useful module to load specific user options or to display news.' =>
            '定义一个有用的模块以载入指定的用户选项或显示新闻。',
        'Defines all the X-headers that should be scanned.' => '定义所有应被扫描的X-header（信头）。',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '定义本系统可用的所有语言。在这里只指定语言的英文名称。',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '定义本系统可用的所有语言。在这里只指定语言的本地化名称。',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '在客户界面个人偏好设置中定义RefreshTime（刷新时间）对象的所有参数。',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '在客户界面个人偏好设置中定义ShownTickets（显示工单）对象的所有参数。',
        'Defines all the parameters for this item in the customer preferences.' =>
            '在客户偏好设置中定义这个条目的所有参数。',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '定义在客户偏好设置中这个条目的所有参数。\'PasswordRegExp\'保证密码不匹配一个正则表达式；\'PasswordMinSize\'定义密码的最小字符数；如果至少需要2个小写字母和2个大写字母就设置合适的选项为“1”，\'PasswordMin2Characters\'定义密码如果要包含至少2个字母字符（设置为0或1）；\'PasswordNeedDigit\'控制是否至少包含1个数字（设置为0或1）。',
        'Defines all the parameters for this notification transport.' => '为这个通知传输定义所有的参数。',
        'Defines all the possible stats output formats.' => '定义所有可能的统计输出格式。',
        'Defines an alternate URL, where the login link refers to.' => '定义一个用户登录链接的备选URL地址。',
        'Defines an alternate URL, where the logout link refers to.' => '定义一个用户退出链接的备选URL地址。',
        'Defines an alternate login URL for the customer panel..' => '定义客户门户的登录备用URL地址。',
        'Defines an alternate logout URL for the customer panel.' => '定义客户门户的退出备用URL地址。',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '定义一个客户数据库的外部链接（例如：\'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' 或 \'\'）。',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            '定义一个图标，链接预约编辑屏幕中的当前位置到谷歌地图页面。',
        'Defines an overview module to show the address book view of a customer user list.' =>
            '定义一个概览模块以显示客户用户列表的通讯录视图。',
        'Defines available article actions for Chat articles.' => '定义聊天信件的可用信件操作。',
        'Defines available article actions for Email articles.' => '定义电子邮件信件的可用信件操作。',
        'Defines available article actions for Internal articles.' => '定义内部信件的可用信件操作。',
        'Defines available article actions for Phone articles.' => '定义电话信件的可用信件操作。',
        'Defines available article actions for invalid articles.' => '定义无效信件的可用信件操作。',
        'Defines available groups for the admin overview screen.' => '为管理员概览屏幕定义可用组。',
        'Defines chat communication channel.' => '定义聊天通信渠道。',
        'Defines default headers for outgoing emails.' => '定义外发电子邮件的默认标头。',
        'Defines email communication channel.' => '定义电子邮件通信通道。',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '定义服务人员选择结果顺序的工单属性。',
        'Defines groups for preferences items.' => '为偏好设置项定义分组。',
        'Defines how many deployments the system should keep.' => '定义系统应保留多少个部署。',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '定义邮件（来自于答复和邮件工单）发件人字段的显示样式。',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '定义队列视图是否按优先级预先排序。',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '定义服务视图是否按优先级预先排序。',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单关闭屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单外出邮件屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单重发邮件窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单退回屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单编写屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单转发屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单自定义字段屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单合并屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单备注屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单所有者屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单挂起屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单客户来电屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单致电客户屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单优先级屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单负责人屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在变更工单客户屏幕是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '定义是否允许因在个人偏好设置中没有存储共享密钥而不能使用双因素身份验证的服务人员登录。',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '定义是否允许因在个人偏好设置中没有存储共享密钥而不能使用双因素身份验证的客户用户登录。',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '定义本系统能否与OTRS集团提供云服务的服务器通信。如果设置为“禁用云服务”，某些功能如系统注册、发送支持数据、升级到OTRS Business Solution™（OTRS商业解决方案）、OTRS Verify™（OTRS验证）、仪表板中的OTRS新闻和产品新闻小部件等将失效。',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '定义客户界面是否使用增强模式（启用表格、替换、下标、上标、从WORD粘贴等功能）。',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '定义是否使用增强模式（启用表格、替换、下标、上标、从WORD粘贴等功能）。',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            '定义对相关客户可见的第一个信件是否应扩展显示，如果没有定义，则会扩展显示最新的信件。',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面电子邮件外发屏幕中的消息。',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面电子邮件重发屏幕中的消息。',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单撰写屏幕中的消息。',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单转发屏幕中的消息。',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面关闭工单屏幕中的备注。',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单批量操作屏幕中的备注。',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单自定义字段屏幕中的备注。',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单备注屏幕中的备注。',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单所有者屏幕中的备注。',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单挂起屏幕中的备注。',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单优先级屏幕中的备注。',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            '定义默认情况下客户是否可以看到服务人员界面工单负责人屏幕中的备注。',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '定义在身份验证时是否接受先前有效的链接令牌。这稍微降低了安全性但是给用户多了30秒时间来输入他们的一次性密码。',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '定义过滤器的值是否应从所有可用的工单中检索。如果启用了，则只有实际用在工单中的值才能用于过滤。请注意：客户用户列表将像这样始终被检索。',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '定义在服务人员界面工时管理是否是强制的。如果启用了，所有工单操作必须输入一个备注（不管是否启用了工单备注，也不管个别工单操作屏幕本来就是强制的）。',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '定义在批量操作中是否设置所有工单的工时管理。',
        'Defines internal communication channel.' => '定义内部通信渠道。',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '定义不在办公室的消息模板。有两个字符串参数（%s）：结束日期和剩余天数。',
        'Defines phone communication channel.' => '定义电话通信渠道。',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '定义将工单作为日历事件显示的队列。',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '使用公共模块 \'PublicSupportDataCollector\' （如用于OTRS守护进程的模块）定义用于搜集支持数据的HTTP主机名。',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '定义IP正则表达式以访问本地的软件仓库。您需要启用这个设置以访问本地的软件仓库，远程主机上还需要设置package::RepositoryList。',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '定义在过滤器中用来保持工单的当前状态的邮件标头。',
        'Defines the URL CSS path.' => '定义CSS路径的URL地址。',
        'Defines the URL base path of icons, CSS and Java Script.' => '定义图标、CSS和Javascript的URL基本路径。',
        'Defines the URL image path of icons for navigation.' => '定义导航栏图标的URL图像地址。',
        'Defines the URL java script path.' => '定义Javascript路径的URL地址。',
        'Defines the URL rich text editor path.' => '定义富文本编辑器的URL地址。',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '定义专用的DNS服务器地址，如果需要，用于“检查MX记录”时查找。',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '定义服务人员存储的共享密钥中的预设密钥。',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '定义时间选择中可用的增量。 选择“分钟”可以从1-59选择一小时的所有分钟数；选择“30分钟”，则只能选择一小时和半小时。',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '定义发送给服务人员关于新密码的通知邮件的正文。',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '定义发送给服务人员关于请求的新密码的链接的通知邮件的正文。',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '定义发送给客户关于新帐户信息的通知邮件的正文文本。',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '定义发送给客户关于新密码的通知邮件的正文。',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '定义发送给客户关于请求的新密码的链接的通知邮件的正文。',
        'Defines the body text for rejected emails.' => '定义拒绝邮件的正文文本。',
        'Defines the calendar width in percent. Default is 95%.' => '定义日历的宽度（%），默认为95%。',
        'Defines the column to store the keys for the preferences table.' =>
            '定义在偏好设置表中存储密钥的字段。',
        'Defines the config options for the autocompletion feature.' => '定义自动完成功能的配置选项。',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '定义在个人偏好设置视图中显示这个条目的配置参数。',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '定义在偏好设置中这个条目的配置参数。\'PasswordRegExp\'保证密码不匹配一个正则表达式；\'PasswordMinSize\'定义密码的最小字符数；如果至少需要2个小写字母和2个大写字母就设置合适的选项为“1”，\'PasswordMin2Characters\'定义密码如果要包含至少2个字母字符（设置为0或1）；\'PasswordNeedDigit\'控制是否至少包含1个数字（设置为0或1）；\'PasswordMaxLoginFailed\'设置最大登录失败数，一个服务人员在登录失败次数达到这个数后会临时无效。请注意：将\'Active（激活）\'设置为0只会阻止服务人员根据他们的个人偏好编辑此组的设置，但仍然允许管理员以其他用户的名义编辑其偏好设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '定义此条目的配置参数，以显示在偏好设置视图中。 请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Defines the connections for http/ftp, via a proxy.' => '定义通过代理到HTTP/FTP的连接。',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '定义客户存储的共享密钥中的预设密钥。',
        'Defines the date input format used in forms (option or input fields).' =>
            '定义表单中数据的输入格式（选项或输入字段）。',
        'Defines the default CSS used in rich text editors.' => '定义用于富文本编辑器的默认CSS。',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '定义客户界面工单详情视图中默认的服务人员姓名。',
        'Defines the default auto response type of the article for this operation.' =>
            '定义这个信件操作的默认自动响应类型。',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段界面的默认备注正文。',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '定义客户用户通讯录搜索（客户用户或客户单位）中的默认过滤器字段。 对于客户单位字段，必须添加一个前缀“CustomerCompany_”。',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            '定义服务人员和客户使用的默认前端主题（HTML）。如果您喜欢，您可以添加您自己的主题。请参考管理员手册https://doc.otrs.com/doc/ 。',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '定义默认的前端语言。所有可能的值由系统中可用的语言文件确定（查看下一个设置）。',
        'Defines the default history type in the customer interface.' => '定义客户界面中的默认历史类型。',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '定义X轴时间刻度属性的默认最大数。',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '定义概览视图中每页统计的默认最大数。',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '在客户界面中定义客户跟进工单后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '定义服务人员界面在关闭工单屏幕添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面在工单自定义字段屏幕添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '定义服务人员界面在工单备注屏幕添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面在工单所有者屏幕添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面在工单挂起屏幕添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面在工单优先级屏幕添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '定义服务人员界面在工单负责人屏幕添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '定义服务人员界面在工单退回屏幕退回工单后的默认下一个工单状态。',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '定义服务人员界面在工单转发屏幕转发工单后的默认下一个工单状态。',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '定义服务人员界面在工单外出邮件屏幕发送消息后的默认下一个工单状态。',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '定义服务人员界面在工单编写屏幕编写或答复工单后的默认下一个工单状态。',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '定义服务人员界面在工单批量操作屏幕的默认下一个工单状态。',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面在工单电话接入屏幕电话工单的默认备注正文文本。',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面在工单拨出电话屏幕电话工单的默认备注正文文本。',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '在客户界面中，工单详情屏幕跟进客户工单的默认优先级。',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '在客户界面中，创建客户工单的默认优先级。',
        'Defines the default priority of new tickets.' => '定义创建工单的默认优先级。',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '在客户界面中，创建客户工单的默认队列。',
        'Defines the default queue for new tickets in the agent interface.' =>
            '定义服务人员界面新建工单的默认队列。',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '定义动态对象下拉菜单的默认选择项（表单：一般设定）。',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '定义权限下拉菜单的默认选择项（表单：一般设定）。',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '定义统计格式下拉菜单的默认选择项（表单：一般设定）。请插入格式键（参考Stats::Format）。',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面工单电话接入屏幕中电话工单默认的发送人类型。',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面工单电话拨出屏幕中电话工单默认的发送人类型。',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '定义服务人员界面工单详情屏幕中工单默认的发送人类型。',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '定义工单搜索屏幕中默认显示的工单搜索属性（所有工单/归档工单/未归档工单）。',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '定义工单搜索屏幕中默认显示的工单搜索属性。',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '定义工单搜索屏幕中默认显示的工单搜索属性。“键”必须在动态字段名称后加“X”，“值”必须是动态字段类型相关的值，文本：\'a text\'，下拉菜单：\'1\'，日期/时间：\'Search_DynamicField_XTimeSlotStartYear=1974;Search_DynamicField_XTimeSlotStartMonth=01;Search_DynamicField_XTimeSlotStartDay=26;Search_DynamicField_XTimeSlotStartHour=00;Search_DynamicField_XTimeSlotStartMinute=00;Search_DynamicField_XTimeSlotStartSecond=00;Search_DynamicField_XTimeSlotStopYear=2013; earch_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\'或者\'Search_DynamicField_XTimePointFormat=week;Search_DynamicField_XTimePointStart=Before;Search_DynamicField_XTimePointValue=7\'。',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '定义在工单队列视图中默认的排序条件。',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '定义在工单服务视图中默认的排序条件。',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '定义在工单队列视图中在优先级排序后默认的排序顺序。',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '定义在工单服务视图中在优先级排序后默认的排序顺序。',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '定义客户界面中新建客户工单的默认状态。',
        'Defines the default state of new tickets.' => '定义新建工单的默认状态。',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面工单电话接入屏幕电话工单的默认主题。',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面工单拨出电话屏幕电话工单的默认主题。',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段屏幕工单备注的默认主题。',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '定义通用接口失败的任务重新安排的默认秒数（从当前时间开始）。',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '定义客户界面中工单搜索屏幕工单排序的默认工单属性。',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '定义服务人员界面工单升级视图工单排序的默认工单属性。',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '定义服务人员界面锁定的工单视图工单排序的默认工单属性。',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '定义服务人员界面工单负责人视图工单排序的默认工单属性。',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '定义服务人员界面工单状态视图工单排序的默认工单属性。',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '定义服务人员界面工单关注视图工单排序的默认工单属性。',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '定义服务人员界面工单搜索结果工单排序的默认工单属性。',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '定义本次操作中工单搜索结果工单排序的默认工单属性。',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '定义服务人员界面工单退回屏幕退回客户/发送人默认的工单退回通知。',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面工单电话接入屏幕添加电话备注后默认的工单下一状态。',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面工单拨出电话屏幕添加电话备注后默认的工单下一状态。',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '定义服务人员界面工单升级视图的默认工单顺序（在优先级排序之后）。上：最老的在最上面，下：最近的在最上面。',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '定义服务人员界面工单状态视图的默认工单顺序（在优先级排序之后）。上：最老的在最上面，下：最近的在最上面。',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '定义服务人员界面工单负责人视图的默认工单顺序。上：最老的在最上面，下：最近的在最上面。',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '定义服务人员界面锁定的工单视图的默认工单顺序。上：最老的在最上面，下：最近的在最上面。',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '定义服务人员界面工单搜索结果的默认工单顺序。上：最老的在最上面，下：最近的在最上面。',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '定义本次操作中工单搜索结果的默认工单顺序。上：最老的在最上面，下：最近的在最上面。',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '定义服务人员界面工单关注视图的默认工单顺序。上：最老的在最上面，下：最近的在最上面。',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '定义客户界面工单搜索结果的默认工单顺序。上：最老的在最上面，下：最近的在最上面。',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '定义服务人员界面关闭工单屏幕默认的工单优先级。',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '定义服务人员界面工单批量操作屏幕默认的工单优先级。',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段屏幕默认的工单优先级。',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '定义服务人员界面工单备注屏幕默认的工单优先级。',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单所有者屏幕默认的工单优先级。',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单挂起屏幕默认的工单优先级。',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单优先级屏幕默认的工单优先级。',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '定义服务人员界面工单负责人屏幕默认的工单优先级。',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '定义客户界面新建客户工单屏幕默认的工单类型。',
        'Defines the default ticket type.' => '定义默认的工单类型。',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '定义服务人员界面如果URL地址没有给定操作参数时使用的默认前端模块。',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '定义客户界面如果URL地址没有给定操作参数时使用的默认前端模块。',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '定义公共界面操作参数的默认值。操作参数用于系统中的脚本。',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '定义工单默认可见的发送人类型（默认：客户）。',
        'Defines the default visibility of the article to customer for this operation.' =>
            '定义这个信件操作对客户的默认可见性。',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '定义客户可见的注释中“发件人”字段的显示样式。 可以在 Ticket::Frontend::CustomerTicketZoom###DefaultAgentName 设置中定义默认的服务人员姓名。',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '定义显示在日历事件中的动态字段。',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '定义事件对象类型，以便通过AdminAppointmentNotificationEvent（管理预约通知事件）处理。',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '定义打开fetchmail二进制文件的路径。请注意：二进制文件名必须为\'fetchmail\'，如果不是，请使用符号链接。',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '定义信件中处理文本的过滤器，以便高亮URL地址。',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '定义服务人员界面工单编写屏幕响应的发件人格式（[% Data.OrigFrom | html %]是发件人，[% Data.OrigFromName |html %] 是仅有发件人真实姓名。',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '定义本系统的正式域名。这个设置用于变量OTRS_CONFIG_FQDN，在所有的消息表单中使用，以创建系统内部到工单的链接。',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '定义每个客户用户都会在其中的组（如果启用了CustomerGroupSupport-客户组支持，并且你不想管理这些组的每个客户用户）。',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '定义每个客户都会在其中的组（如果启用了CustomerGroupSupport-客户组支持，并且你不想管理这些组的每个客户）。',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '定义本屏幕富文本编辑器组件的高度。输入数值（像素值）或百分比值（相对值）。',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '定义富文本编辑器组件的高度。输入数值（像素值）或百分比值（相对值）。',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单关闭操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单邮件操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '为工单自定义字段屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '为工单备注操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '为工单所有者操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '为工单挂起操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话接入操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话拨出操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '为工单优先级操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '为工单负责人操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '为工单展开操作屏幕定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '为本次操作定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单关闭操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单邮件操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '为工单自定义字段操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '为工单备注操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '为工单所有者操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '为工单挂起操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话接入操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话拨出操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '为工单优先级操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '为工单负责人操作屏幕定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '为工单详情操作定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '定义本次操作中的历史类型，以用于服务人员界面的工单历史。',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '定义指定日历每周天数和小时数，以便计算工作时间。',
        'Defines the hours and week days to count the working time.' => '定义每周天数和小时数，以便计算工作时间。',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '定义与Kernel::Modules::AgentInfo模块一起检查的键。如果这个用户偏好键设置为真，这个消息是被系统接受的。',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '定义与CustomerAccept一起检查的键，如果这个用户偏好键设置为真，这个消息是被系统接受的。',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '定义链接类型“普通”。如果源名称和目标名称相同，则结果链接是无方向链接，否则结果链接是方向性链接。',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '定义链接类型“父子”。如果源名称和目标名称相同，则结果链接是无方向链接，否则结果链接是方向性链接。',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '定义链接类型组。同一组的链接类型废除另外一个，例如：如果工单A以“普通”链接到工单B，则这些工单不能添加另外的“父子”链接。',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '定义在线软件仓库列表。另一个用于安装的软件仓库，例如：键="http://example.com/otrs/public.pl?Action=PublicRepository;File=" ，值="Some Name"。',
        'Defines the list of params that can be passed to ticket search function.' =>
            '定义能传递到工单搜索功能的参数清单。',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '定义错误屏幕可用的下一步操作列表,可以根据需要添加外部链接（必须提供完整路径）。',
        'Defines the list of types for templates.' => '定义模板类型的列表。',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '定义为额外软件包获取在线软件仓库列表的地址，将使用第一个可用的结果。',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '定义系统的日志模块。“File（文件）”将所有消息写入一个指定的日志文件，“SysLog（系统日志）”使用操作系统的syslog守护进程如syslogd。',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '定义通过浏览器上传文件的最大尺寸（单位：字节）。警告：这个选项设置过小将使您的OTRS实例出现许多遮罩屏幕导致停止工作（可能是需要用户输入的任何遮罩屏幕）。',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '定义一个会话ID的最大有效时间（单位：秒）。',
        'Defines the maximum number of affected tickets per job.' => '定义每个任务影响的最大工单数。',
        'Defines the maximum number of pages per PDF file.' => '定义每个PDF文件的最大页数。',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '定义添加到响应中引用的最大行数。',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '定义能同时执行的最大任务数。',
        'Defines the maximum size (in MB) of the log file.' => '定义日志文件的最大尺寸（单位：MB）。',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '定义通用接口响应记录日志到表gi_debugger_entry_content的最大尺寸（单位：KB）。',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '定义服务人员界面显示一个通用通知的模块。可以是“Text（文本）”-如果配置了-，或者是“File（文件）”的内容将被显示。',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '定义服务人员界面显示当前登录的所有服务人员的模块。',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '定义服务人员界面显示当前登录的所有客户人员的模块。',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '定义客户界面显示当前登录的所有服务人员的模块。',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '定义客户界面显示当前登录的所有客户人员的模块。',
        'Defines the module to authenticate customers.' => '定义客户身份验证的模块。',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '定义云服务被禁用时显示一个通知消息的模块。',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '定义在不同界面不同场合显示OTRS商业版通知的模块。',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '定义服务人员界面如果OTRS守护进程没有运行就显示一个通知的模块。',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '如果系统配置不同步，定义在服务人员界面中显示一条通知的模块。',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '如果服务人员还没有选择一个时区，定义在服务人员界面中显示一条通知的模块。',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '定义服务人员界面如果服务人员在“不在办公室”期间登录系统就显示一个通知的模块。',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '定义服务人员界面如果服务人员在系统维护期间登录系统就显示一个通知的模块。',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '定义服务人员界面如果服务人员会话数达到预警值时就显示一个通知的模块。',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '如果启用了安装未经验证的软件包，则定义在服务人员界面中显示通知的模块（仅系统管理员会显示）。',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '定义服务人员界面如果以管理员帐户登录系统（正常情况下您不应该用管理员帐户工作）就显示一个通知的模块。',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '如果部署了无效的系统配置设置，定义在服务人员界面中显示一条通知的模块。',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '如果修改过系统配置设置但还没有部署，定义在服务人员界面中显示一条通知的模块。',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '如果客户在系统维护期间登录，定义在客户界面中显示一条通知的模块。',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '如果客户用户还没有选择一个时区，定义在客户界面中显示一条通知的模块。',
        'Defines the module to generate code for periodic page reloads.' =>
            '定义生成定期页面刷新代码的模块。',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            '定义发送电子邮件的模块。 “DoNotSendEmail”根本不发送电子邮件。 任何“SMTP”机制都使用指定的（外部）邮件服务器。 “Sendmail”直接使用操作系统的sendmail二进制文件。 “Test”不会发送电子邮件，而是将它们写入$OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ 以用于测试目的。',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '定义存储会话数据的模块。使用“DB（数据库）”则前端服务器能从数据库服务器中拆分出来。“FS（文件系统）”更快一些。',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '定义本应用的名称，显示在WEB界面WEB浏览器的标签页和标题栏。',
        'Defines the name of the column to store the data in the preferences table.' =>
            '定义在偏好设置表中存储数据的列名称。',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '定义在偏好设置表中存储用户标识符的列名称。',
        'Defines the name of the indicated calendar.' => '定义指定的日历名称。',
        'Defines the name of the key for customer sessions.' => '定义客户会话中关键词的名称。',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '定义会话中关键词的名称，如Session、SessionID或OTRS。',
        'Defines the name of the table where the user preferences are stored.' =>
            '定义存储用户偏好设置的表的名称。',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '定义服务人员界面工单编写屏幕编写/答复一个工单后下一个可能的状态。',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '定义服务人员界面工单转发屏幕转发一个工单后下一个可能的状态。',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '定义服务人员界面工单外出邮件屏幕发送一个消息后下一个可能的状态。',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '定义客户界面客户工单下一个可能的状态。',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '定义服务人员界面工单关闭屏幕添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段操作屏幕添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '定义服务人员界面工单备注屏幕添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单所有者操作屏幕添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单挂起操作屏幕添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单优先级操作屏幕添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '定义服务人员界面工单负责人操作屏幕添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '定义服务人员界面工单退回操作屏幕退回工单后的下一个工单状态。',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '定义服务人员界面转移工单屏幕转移工单到另一队列后的下一个工单状态。',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '定义服务人员界面在工单批量操作屏幕的下一个工单状态。',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '定义HTML信件预览时的每行字符数，替换事件通知模块的模板生成器设置。',
        'Defines the number of days to keep the daemon log files.' => '定义保留守护进程日志文件的天数。',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '定义前端模块添加和更新邮箱管理员过滤器的标题字段，最多99个字段。',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '定义通信将被存储的小时数，无论其状态是什么。',
        'Defines the number of hours a successful communication will be stored.' =>
            '定义成功的通信将被存储的小时数。',
        'Defines the parameters for the customer preferences table.' => '定义客户偏好设置表的参数。',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '定义仪表板后端参数。“Cmd”用于指定带有参数的命令。“GROUP（组）”用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '定义仪表板后端参数。“GROUP（组）”用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”定义本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '定义仪表板后端参数。“GROUP（组）”用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '定义仪表板后端参数。“Limit（限制”）定义默认显示的条目数。“GROUP（组）”用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '定义仪表板后端参数。“Limit（限制”）定义默认显示的条目数。“GROUP（组）”用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”定义本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '定义访问SOAP句柄(bin/cgi-bin/rpc.pl)的密码。',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '定义PDF文档中粗斜体等宽字体的TTF字体文件的路径和文件名。',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '定义PDF文档中粗斜体比例字体的TTF字体文件的路径和文件名。',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '定义PDF文档中粗体等宽字体的TTF字体文件的路径和文件名。',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '定义PDF文档中粗体比例字体的TTF字体文件的路径和文件名。',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '定义PDF文档中斜体等宽字体的TTF字体文件的路径和文件名。',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '定义PDF文档中斜体比例字体的TTF字体文件的路径和文件名。',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '定义PDF文档中等宽字体的TTF字体文件的路径和文件名。',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '定义PDF文档中比例字体的TTF字体文件的路径和文件名。',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '定义显示位于Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt信息文件的路径。',
        'Defines the path to PGP binary.' => '定义PGP程序文件的路径。',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '定义SSL程序文件的路径，可能需要HOME环境变量($ENV{HOME} = \'/var/lib/wwwrun\';)。',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '定义由于不活动而将服务人员标记为“离开”的时间（单位：分钟）（例如：在“已登录的用户”小部件或聊天中）。',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '定义由于不活动而将客户标记为“离开”的时间（单位：分钟）（例如：在“已登录的用户”小部件或聊天中）。',
        'Defines the postmaster default queue.' => '定义邮件管理员的默认队列。',
        'Defines the priority in which the information is logged and presented.' =>
            '定义信息被记录和呈现的优先级。',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '定义服务人员界面电话工单的收件人和邮件工单的发件人（“队列”显示所有队列，“系统邮件地址”显示所有的系统邮件）。',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '定义客户界面工单收件人的目标（“Queue队列”显示所有的队列，“SystemAddress系统邮件地址”只显示分配到系统邮件地址的队列）。',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '定义服务人员界面升级视图显示工单所必需的权限。',
        'Defines the search limit for the stats.' => '定义统计的搜索限制。',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '定义AgentCustomerUserAddressBook（服务人员界面客户用户通讯录）屏幕的搜索参数。 使用\'CustomerTicketTextField\'设置，可以指定收件人字段的值。',
        'Defines the sender for rejected emails.' => '定义拒绝邮件的发件人。',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '定义服务人员真实姓名和给定队列邮件地址之间的分隔符。',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '定义在服务人员界面客户用户通讯录搜索结果屏幕中显示的列和位置。',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '定义OTRS系统的客户和公共界面中页脚区域显示的链接。 “Key（键）”中的值是外部网址，“Content（内容）”中的值是显示的文字。',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '定义本系统客户可用的标准权限。如果需要更多的权限，您可以在这里输入。权限必须确实硬编码以保证生效。请确保在添加前面任何提到的权限时，“rw（读写）”权限保持为最后一个条目。',
        'Defines the standard size of PDF pages.' => '定义PDF页面的标准尺寸。',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '定义一个工单被跟进但已经关闭时工单的状态。',
        'Defines the state of a ticket if it gets a follow-up.' => '定义一个工单被跟进时工单的状态。',
        'Defines the state type of the reminder for pending tickets.' => '定义挂起工单提醒的状态类型。',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '定义发送给服务人员关于新密码的通知邮件的主题。',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '定义发送给服务人员关于请求的新密码的链接的通知邮件的主题。',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '定义发送给客户关于新帐户的通知邮件的主题。',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '定义发送给客户关于新密码的通知邮件的主题。',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '定义发送给客户关于请求的新密码的链接的通知邮件的主题。',
        'Defines the subject for rejected emails.' => '定义拒绝邮件的主题。',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '定义系统管理员的邮件地址，它将显示在本系统的错误屏幕中。',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '定义本系统的标识符。每个工单编号和HTTP会话字符串均包含这个ID。这确保只有属于本系统的工单才会被跟进处理（在两套OTRS实例间通信时有用）。',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '定义到外部客户数据库的目标属性，例如：\'AsPopup PopupType_TicketAction\'。',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '定义到外部客户数据库的目标属性，例如：\'target="cdb"\'。',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '定义工单预约类型后端，用于工单动态字段日期时间。',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '定义工单预约类型后端，用于工单升级时间。',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '定义工单预约类型后端，用于工单挂起时间。',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '定义要显示为日历事件的工单字段。“键”定义工单字段或工单属性，“值”定义显示的名称。',
        'Defines the ticket plugin for calendar appointments.' => '定义日历预约的工单插件。',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '定义一个指定日历（可能在以后分配给一个指定的队列）的时区。',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '使用公共模块“PublicSupportDataCollector”（例如用于OTRS守护进程的模块）来定义支持数据收集的超时（以秒为单位，最小为20秒）。',
        'Defines the two-factor module to authenticate agents.' => '定义服务人员的双因素身份验证模块。',
        'Defines the two-factor module to authenticate customers.' => '定义客户的双因素身份验证模块。',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '定义本系统的WEB服务器使用的协议类型。如果要用HTTPS协议代替明文的HTTP协议，就在这里指定。 因为这个设置并不影响WEB服务器的设置或行为，所以不会改变访问本系统的方式。 如果设置错误，也不会阻止您登录系统。这个设置只是作为一个变量OTRS_CONFIG_HttpType使用，可以在系统使用的所有消息的表单中找到，用来创建在系统内到工单的链接。',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '定义服务人员界面工单编写屏幕使用的普通文本邮件引用字符。如果这个设置为空或不激活，原始邮件将不会被引用而是追加到回复内容中。',
        'Defines the user identifier for the customer panel.' => '定义客户门户的用户标识符。',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '定义访问SOAP句柄(bin/cgi-bin/rpc.pl)的用户名。',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '定义用户头像。 请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '定义工单的有效状态类型。如果一个工单处于此设置中任一状态类型的状态，则该工单将被视为打开，否则将被视为关闭。',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '定义解锁的工单有效的状态。为解锁工单，可以使用脚本"bin/otrs.Console.pl Maint::Ticket::UnlockTimeout"。',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '定义工单能看到的锁定状态。注意：修改这个设置后，请确保删除缓存以便使用新值。默认：未锁定，临时锁定。',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '定义本屏幕中富文本编辑器组件的宽度。输入数值（像素值）或百分比值（相对值）。',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '定义富文本编辑器组件的宽度。输入数值（像素值）或百分比值（相对值）。',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '定义指定类型的草稿自最近修改之后到被认为已过期之前的分钟数。',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '定义全文搜索是否索引已归档的工单。',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '定义工单预览时显示的信件发送人类型。',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '定义ACL结构第三级的\'动作\'有哪些可用条目。',
        'Defines which items are available in first level of the ACL structure.' =>
            '定义ACL结构第一级的\'动作\'有哪些可用条目。',
        'Defines which items are available in second level of the ACL structure.' =>
            '定义ACL结构第二级的\'动作\'有哪些可用条目。',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '定义在工单状态（键）挂起时间到达后，哪个状态将被自动设置（值）。',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '定义在链接的工单列表中不出现的工单状态类型。',
        'Delete expired cache from core modules.' => '删除核心模块过期的缓存。',
        'Delete expired loader cache weekly (Sunday mornings).' => '每周删除过期的加载器缓存（星期天早晨）。',
        'Delete expired sessions.' => '删除过期的会话。',
        'Delete expired ticket draft entries.' => '删除过期的工单草稿条目。',
        'Delete expired upload cache hourly.' => '每小时删除过期的上传缓存。',
        'Delete this ticket' => '删除这个工单',
        'Deleted link to ticket "%s".' => '到工单“%s”的链接已删除。',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '如果会话ID被无效的远程IP地址使用则删除该会话。',
        'Deletes requested sessions if they have timed out.' => '删除超时的会话请求。',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '启用后，如果发生了任何的AJAX错误，就在前端传递扩展的调试信息。',
        'Deploy and manage OTRS Business Solution™.' => '部署并管理OTRS商业版。',
        'Detached' => '已卸下',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '确定在每个详情遮罩窗口中是否应在每个链接旁边显示删除链接的按钮。',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '确定在服务人员界面转移工单到可能的队列列表是否在下拉列表中或新窗口显示。如果设置为“新窗口”，您可以为这个工单添加一个移动备注。',
        'Determines if the statistics module may generate ticket lists.' =>
            '确定统计模块是否可以生成工单清单。',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '确定在服务人员界面创建新邮件工单后下一个可能的工单状态。',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '确定在服务人员界面创建新电话工单后下一个可能的工单状态。',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '确定在服务人员界面处理工单下一个可能的工单状态。',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '确定在客户界面处理工单下一个可能的工单状态。',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '确定在客户界面创建新客户工单后的下一个屏幕。',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '确定在客户界面跟进工单屏幕的下一个屏幕。',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '确定工单转移队列后的下一个屏幕。LastScreenOverview将返回到最后的概览屏幕（例如：搜索结果、队列视图、仪表板），TicketZoom将返回到工单详情视图。',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '确定挂起工单在到达时间限制后变更状态的可能状态。',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '确定服务人员界面电话工单显示为收件人（To:）和邮件工单显示为发件人（From:）的字符串。如果NewQueueSelectionType参数设置为“队列”，"<Queue>"显示队列名称，如果NewQueueSelectionType参数设置“系统邮件地址”，"<Realname> <<Email>>"显示收件人的名称和邮件地址。',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '确定客户界面工单显示为收件人（To:）的字符串。如果NewQueueSelectionType参数设置为“队列”，"<Queue>"显示队列名称，如果NewQueueSelectionType参数设置“系统邮件地址”，"<Realname> <<Email>>"显示收件人的名称和邮件地址。',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '确定链接对象显示在每个遮罩屏幕的方式。',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '确定服务人员界面收件人（电话工单）和发件人（邮件工单）哪些选项有效。',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '确定客户界面哪些队列可以作为工单的有效收件人。',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '禁用HHTP头"Content-Security-Policy"以便允许载入扩展的脚本内容。禁用这个HTTP头可能引起安全问题！仅在您知道您在干什么时才禁用它！',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '禁用HHTP头"X-Frame-Options: SAMEORIGIN" 以便允许OTRS可以包含在其它网址的IFrame框架中。禁用这个HTTP头可能有安全问题！仅在您知道您在干什么时才禁用它！',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => '禁用云服务',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '禁止发送提醒通知给工单负责人（需要启用Ticket::Responsible设置）。',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '当工单关闭时，取消到最近浏览页/仪表板的重定向。',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '禁用WEB安装程序(http://yourhost.example.com/otrs/installer.pl)，防止系统被劫持。如果不启用，系统能够被重新安装，当前的基本配置将被安装脚本的预设问题替换。如果启用了，还同时禁用了通用代理、软件包管理和SQL查询窗口。',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '在全文搜索使用了停止词时显示一个警告并阻止搜索。',
        'Display communication log entries.' => '显示通信日志条目。',
        'Display settings to override defaults for Process Tickets.' => '为流程工单显示设置值覆盖默认值。',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '在工单详情视图中显示所用工时。',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '在工单详情视图中显示与当前工单具有相同的客户ID的所有工单数。',
        'Down' => '下',
        'Dropdown' => '下拉选择框',
        'Dutch' => '荷兰语',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的荷兰语停止词。这些词将从搜索索引中移除。',
        'Dynamic Fields Checkbox Backend GUI' => '动态字段复选框后端GUI',
        'Dynamic Fields Date Time Backend GUI' => '动态字段日期时间后端GUI',
        'Dynamic Fields Drop-down Backend GUI' => '动态字段下拉框后端GUI',
        'Dynamic Fields GUI' => '动态字段GUI',
        'Dynamic Fields Multiselect Backend GUI' => '动态字段多选框后端GUI',
        'Dynamic Fields Overview Limit' => '动态字段概览限制',
        'Dynamic Fields Text Backend GUI' => '动态字段文本框后端图形界面',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '用于输出搜索结果为CSV格式的动态字段。',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '流程小部件的动态字段组。键是组名，值是要显示的动态字段。例如：\'键 => My Group\'，\'值: Name_X, NameY\'。',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => '动态字段概览视图的每页动态字段数限制。',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '在客户界面的工单消息屏幕中显示的动态字段选项。 注意。 如果要在客户界面的工单详情屏幕中显示这些字段，则必须在CustomerTicketZoom ### DynamicField中启用它们。',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '在客户界面的工单详情屏幕中工单回复部分显示的动态字段选项。',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '在服务人员界面的电子邮件外发屏幕中显示的动态字段。',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '在服务人员界面的工单详情屏幕中显示在流程小部件中的动态字段。',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '在服务人员界面的工单详情屏幕中显示在侧边栏中的动态字段。',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '在服务人员界面的工单关闭屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '在服务人员界面的工单撰写屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '在服务人员界面的工单电子邮件屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '在服务人员界面的工单转发屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '在服务人员界面的工单自定义字段屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '在服务人员界面的工单概览基本版式屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '在服务人员界面的工单转移屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '在服务人员界面的工单备注屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            '在客户界面的工单概览屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            '在服务人员界面的工单所有者屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            '在服务人员界面的工单挂起屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            '在服务人员界面的工单电话接入屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            '在服务人员界面的工单电话拨出屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            '在服务人员界面的工单电话屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            '在服务人员界面的工单预览格式概览屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '在服务人员界面的工单打印屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '在客户界面的工单打印屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '在服务人员界面的工单优先级屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面的工单负责人屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '在客户界面的工单搜索概览屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '在服务人员界面的工单搜索屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '在客户界面的工单搜索屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '在服务人员界面的工单概览简洁版式屏幕中显示的动态字段。',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '在客户界面的工单详情屏幕中显示的动态字段。',
        'DynamicField' => 'DynamicField（动态字段）',
        'DynamicField backend registration.' => '动态字段后端注册。',
        'DynamicField object registration.' => '动态字段对象注册。',
        'DynamicField_%s' => 'DynamicField_%s',
        'E-Mail Outbound' => '外发邮件',
        'Edit Customer Companies.' => '编辑客户单位。',
        'Edit Customer Users.' => '编辑客户用户。',
        'Edit appointment' => '编辑预约',
        'Edit customer company' => '编辑客户单位',
        'Email Addresses' => '邮件地址',
        'Email Outbound' => '外发邮件',
        'Email Resend' => '邮件重发',
        'Email communication channel.' => '电子邮件通信通道。',
        'Enable highlighting queues based on ticket age.' => '启用基于工单年龄的突出显示队列。',
        'Enable keep-alive connection header for SOAP responses.' => '启用SOAP响应的持久连接头。',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '如果你信任所有的公共和私有PGP密钥（即使它们不是可信任签名认证的），则启用这个参数。',
        'Enabled filters.' => '启用的过滤器。',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '启用PGP支持。当启用PGP签名和加密邮件时，强烈推荐以OTRS用户运行WEB服务器，否则，访问.pnugp目录会有权限问题。',
        'Enables S/MIME support.' => '启用S/MIME支持。',
        'Enables customers to create their own accounts.' => '允许客户自己建立帐户。',
        'Enables fetch S/MIME from CustomerUser backend support.' => '在客户用户后端支持模块启用收取S/MIME（邮件）。',
        'Enables file upload in the package manager frontend.' => '在软件包管理前端启用文件上传。',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '启用或禁用模板缓存。警告：不要在生产环境禁用模板缓存，因为这会引起巨大的性能下降！这个设置只在调试时才禁用！',
        'Enables or disables the debug mode over frontend interface.' => '启用或禁用前端界面的调试模式。',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '启用或禁用工单关注人功能，以便非所有者或负责人也能跟踪工单情况。',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '启用性能日志（记录页面响应时间）。这会影响系统性能。必须先启用参数Frontend::Module###AdminPerformanceLog。',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '启用最小的工单计数器大小（如果TicketNumberGenerator工单编号生成器选择为“日期”）。',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '启用工单批量操作，以在服务人员前端一次性操作多个工单。',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '仅对列表中的组启用批量操作功能。',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '启用工单负责人功能，以跟踪指定的工单。',
        'Enables ticket type feature.' => '启用工单类型功能。',
        'Enables ticket watcher feature only for the listed groups.' => '仅对列表中的组启用工单关注人功能。',
        'English (Canada)' => '英语（加拿大）',
        'English (United Kingdom)' => '英语（英国）',
        'English (United States)' => '英语（美国）',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的英语停止词，这些词将从搜索索引中移除。',
        'Enroll process for this ticket' => '这个工单的注册过程',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '输入您的共享密钥以启用双因素身份验证。 警告：确保将共享密钥添加到生成器应用程序，并且应用程序运行良好。 否则，如果没有双因素令牌，您将无法再登录。',
        'Escalated Tickets' => '升级的工单',
        'Escalation view' => '升级视图',
        'EscalationTime' => '升级时间',
        'Estonian' => '爱沙尼亚',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '事件模块注册。为获得更好的性能你可以定义一个触发事件（例如：事件 => 工单创建）。',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '事件模块注册。为获得更好的性能你可以定义一个触发事件（例如：事件 => 工单创建），只有工单的所有动态字段需要同一事件时才可能。',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '对TicketIndex（工单索引）执行更新语句以重命名队列名称（如果有重命名需要且实际使用了静态数据库）的事件模块。',
        'Event module that updates customer company object name for dynamic fields.' =>
            '更新客户单位动态字段的对象名称的事件模块。',
        'Event module that updates customer user object name for dynamic fields.' =>
            '更新客户用户动态字段的对象名称的事件模块。',
        'Event module that updates customer user search profiles if login changes.' =>
            '登录用户变化时更新客户用户搜索模板的事件模块。',
        'Event module that updates customer user service membership if login changes.' =>
            '登录用户变化时更新客户用户服务关系的事件模块。',
        'Event module that updates customer users after an update of the Customer.' =>
            '更新客户资料后更新客户用户的事件模块。',
        'Event module that updates tickets after an update of the Customer User.' =>
            '更新客户用户后更新工单的事件模块。',
        'Event module that updates tickets after an update of the Customer.' =>
            '更新客户后更新工单的事件模块。',
        'Events Ticket Calendar' => '事件日历',
        'Example package autoload configuration.' => '软件包自动加载配置示例。',
        'Execute SQL statements.' => '执行SQL语句。',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '执行定制的命令或模块。注意：如果使用模块，需要使用函数。',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '为主题中没有工单编号的邮件执行回复或引用头的跟进检查。',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => '对OTRS头\'X-OTRS-Bounce\'执行后续检查。',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '为主题中没有工单编号的邮件执行附件内容的跟进检查。',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '为主题中没有工单编号的邮件执行邮件正文内容的跟进检查。',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '为主题中没有工单编号的邮件执行未加工的源邮件的跟进检查。',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '在搜索结果中输出整个信件树（这会影响系统性能）。',
        'External' => '外部',
        'External Link' => '外部链接',
        'Fetch emails via fetchmail (using SSL).' => '通过fetchmail获取邮件（使用SSL）。',
        'Fetch emails via fetchmail.' => '通过fetchmail获取邮件。',
        'Fetch incoming emails from configured mail accounts.' => '从配置的邮件帐户获取进入邮件。',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '通过代理获取软件包，覆盖“WebUserAgent::Proxy”设置。',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '显示在模块Kernel::Modules::AgentInfo中的文件，位于Kernel/Output/HTML/Templates/Standard/AgentInfo.tt。',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '调试ACL的过滤器。注意：可以按以下格式添加更多的工单属性 <OTRS_TICKET_属性>，例如：<OTRS_TICKET_Priority>。',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '调试转换的过滤器。注意：可以按以下格式添加更多的过滤器 <OTRS_TICKET_属性>，例如：<OTRS_TICKET_Priority>。',
        'Filter incoming emails.' => '进入的邮件的过滤器。',
        'Finnish' => '芬兰语',
        'First Christmas Day' => '圣诞节的第一天',
        'First Queue' => '第一队列',
        'First response time' => '首次响应时间',
        'FirstLock' => '首次锁定',
        'FirstResponse' => '首次响应',
        'FirstResponseDiffInMin' => '首次响应时间差（分钟）',
        'FirstResponseInMin' => '首次响应时间（分钟）',
        'Firstname Lastname' => '名 姓',
        'Firstname Lastname (UserLogin)' => '名 姓（登录用户名）',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '对于这些状态类型，在链表中的工单编号将被划线。',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '强制将原始信件文本存储在信件搜索索引中，而不执行过滤器或应用停用词列表。 这将增加搜索索引的大小，从而可能减慢全文搜索。',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '外发邮件强制编码为（7bit|8bit|可打印|base64）。',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '工单锁定后强制选择与当前不同的另一个工单状态，定义键为当前状态，值为锁定后的下一个工单状态。',
        'Forces to unlock tickets after being moved to another queue.' =>
            '工单转移到另一队列后强制解锁。',
        'Forwarded to "%s".' => '已转发给“%s”。',
        'Free Fields' => '自定义字段',
        'French' => '法语',
        'French (Canada)' => '法语（加拿大）',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的法语停止词，这些词将从搜索索引中移除。',
        'Frontend' => '前端',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '前端模块注册（如果没有使用工单服务功能，禁用服务人员工单服务链接）。',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '前端模块注册（如果没有使用客户单位功能，禁用客户单位链接）。',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '客户界面前端模块注册（如果没有可用流程，禁用工单流程屏幕）。',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '前端模块注册（如果没有可用流程，禁用工单流程屏幕）。',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '前端模块注册（作为“系统管理”的子导航项目显示个人收藏夹）。',
        'Frontend module registration for the agent interface.' => '服务人员界面的前端模块注册。',
        'Frontend module registration for the customer interface.' => '客户界面的前端模块注册。',
        'Frontend module registration for the public interface.' => '公共界面的前端模块注册。',
        'Full value' => '全值',
        'Fulltext index regex filters to remove parts of the text.' => '全文索引正则表达式过滤器用来删除部分文本。',
        'Fulltext search' => '全文搜索',
        'Galician' => '加利西亚语',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '在工单概览中显示的一般工单数据（低效运行）。 请注意，工单编号不能被禁用，因为它是必要的。',
        'Generate dashboard statistics.' => '生成仪表板统计。',
        'Generic Info module.' => '通用信息模块。',
        'GenericAgent' => '自动任务',
        'GenericInterface Debugger GUI' => '通用接口调试器图形界面',
        'GenericInterface ErrorHandling GUI' => '通用接口错误处理图形界面',
        'GenericInterface Invoker Event GUI' => '通用接口调用程序事件图形界面',
        'GenericInterface Invoker GUI' => '通用接口调用程序GUI',
        'GenericInterface Operation GUI' => '通用接口操作GUI',
        'GenericInterface TransportHTTPREST GUI' => '通用接口传输HTTPREST GUI',
        'GenericInterface TransportHTTPSOAP GUI' => '通用接口传输HTTPSOAP GUI',
        'GenericInterface Web Service GUI' => '通用接口WEB服务GUI',
        'GenericInterface Web Service History GUI' => '通用接口WEB服务历史图形界面',
        'GenericInterface Web Service Mapping GUI' => '通用接口WEB服务映射图形界面',
        'GenericInterface module registration for an error handling module.' =>
            '错误处理模块的通用接口模块注册。',
        'GenericInterface module registration for the invoker layer.' => '调用程序层的通用接口模块注册。',
        'GenericInterface module registration for the mapping layer.' => '映射层的通用接口模块注册。',
        'GenericInterface module registration for the operation layer.' =>
            '操作层的通用接口模块注册。',
        'GenericInterface module registration for the transport layer.' =>
            '传输层的通用接口模块注册。',
        'German' => '德语',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的德语停止词，这些词将从搜索索引中移除。',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '给客户用户授予对来自同一单位的客户用户的工单（工单的客户ID等于客户用户的客户ID）基于组的访问权限。',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '使最终用户能够覆盖转换文件中定义的CSV文件分隔符。 请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Global Search Module.' => '全局搜索模块。',
        'Go to dashboard!' => '进入仪表板！',
        'Good PGP signature.' => '',
        'Google Authenticator' => '谷歌身份验证器',
        'Graph: Bar Chart' => '图形：条形图',
        'Graph: Line Chart' => '图形：折线图',
        'Graph: Stacked Area Chart' => '图形：堆叠面积图',
        'Greek' => '希腊语',
        'Hebrew' => '希伯来语',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '帮助扩展信件全文搜索（发件人、收件人、抄送、主题和正文搜索）。它将在信件创建后条带化所有信件并建立索引，提升全文搜索50%的效率。可使用命令 "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" 来创建初始索引。',
        'High Contrast' => '高对比度',
        'High contrast skin for visually impaired users.' => '用于视力受损用户的高对比度皮肤。',
        'Hindi' => '印度语',
        'Hungarian' => '匈牙利语',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“数据库”，可以指定数据库驱动（一般使用自动检测）。',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“数据库”，可以指定连接到客户表的密码。',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“数据库”，可以指定连接到客户表的用户名。',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“数据库”，必须指定连接到客户表的DSN（数据源名称）。',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“数据库”，必须指定客户表中客户密码的字段名称。',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '如果为Customer::AuthModule（客户认证模块）选择了“DB（数据库）”，则必须指定密码的加密类型。',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“数据库”，必须指定客户表中客户密钥的字段名称。',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“数据库”，必须指定保存客户数据的表名。',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '如果会话模块选择“数据库”，必须指定保存会话数据的数据库表名。',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '如果会话模块选择“文件系统”，必须指定保存会话数据的目录。',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '如果Customer::AuthModule（客户认证模块）选择“HTTPBasicAuth（HTTP基本认证）”，您可以使用正则表达式剥去REMOTE_USER的部分内容（如剥去尾部的域名）。正则表达式注释：$1将是新的登录名。',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '如果Customer::AuthModule（客户认证模块）选择“HTTPBasicAuth（HTTP基本认证）”，您可以指定剥去用户名称的主要部分（例如域名，如从example_domain\user变为user）。',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，并且如果您想给每个客户登录名添加一个前缀，则在这里指定，例如，你只想写入用户名user，但在您的LDAP目录存在user@domain。',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，并且perl模块Net::LDAP需要一些特殊参数，您可以在这里指定它们。查阅"perldoc Net::LDAP"获取这些参数的更多信息。',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，并且您的用户只能匿名访问LDAP树，但您想搜索整个LDAP数据， 您可以使用一个有权限访问LDAP的用户来实现，在这里指定这个特殊用户的密码。',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，并且您的用户只能匿名访问LDAP树，但您想搜索整个LDAP数据， 您可以使用一个有权限访问LDAP的用户来实现，在这里指定这个特殊用户的用户名。',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，必须指定BaseDN（基础域名）。',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，可以指定LDAP主机。',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，必须指定用户标识。',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，可以指定用户属性。对LDAP posixGroups使用UID，对非LDAP posixGroups使用用户DN全称。',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，可以在这里指定访问属性。',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，您可以指定系统是否要停止的条件（例如由于网络问题无法建立到服务器的连接）。',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '如果Customer::AuthModule（客户认证模块）选择“LDAP”，您可以检查在posixGroup组中的用户是否允许认证，例如：用户需要在组xyz才能使用OTRS。指定这个有权访问系统的组名。',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '如果选用了LDAP，您可以为每个LDAP查询添加一个过滤器，例如：(mail=*)、 (objectclass=user) 或 (!objectclass=computer)。',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“Radius”，必须指定验证Radius主机的密码。',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“Radius”，必须指定Radius主机。',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '如果Customer::AuthModule（客户认证模块）选择“Radius”， 您可以指定系统是否要停止的条件（例如由于网络问题无法建立到服务器的连接）。',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '如果发送邮件模块选用了“Sendmail”，必须指定Sendmail的位置和需要的配置。',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '如果日志模块选用了“SysLog”，可以指定一个专用的日志程序模块。',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '如果日志模块选用了“SysLog”，可以指定记录日志的字符集。',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '如果为CryptType(加密类型)选择了“bcrypt”，请使用此处指定的bcrypt哈希cost 值。 目前最大支持的cost 值为31。',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '如果日志模块选用了“文件”，必须指定日志文件名。如果文件不存在，系统会创建它。',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '如果激活此选项，没有正则表达式能够匹配允许用户注册的邮件地址。',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '如果激活此选项，一个正则表达式能够匹配允许用户注册的邮件地址。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '如果发送邮件模块选用了“SMTP”，并且邮件服务器需要认证，必须指定一个密码。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '如果发送邮件模块选用了“SMTP”，并且邮件服务器需要认证，必须指定一个用户名。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '如果发送邮件模块选用了“SMTP”，并且邮件服务器需要认证，必须指定发送邮件的服务器。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '如果发送邮件模块选用了“SMTP”，并且邮件服务器需要认证，必须指定邮件服务器监听的端口。',
        'If enabled debugging information for ACLs is logged.' => '如果启用了此选项，将记录ACL的调试信息。',
        'If enabled debugging information for transitions is logged.' => '如果启用了此选项，将记录转换的调试信息。',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '如果启用了此选项，守护进程的标准错误流将重定向到一个日志文件。',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '如果启用了此选项，守护进程的标准输出流将重定向到一个日志文件。',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '如果启用，守护程序将使用此目录创建其PID文件。 注意：请在任何更改之前停止守护程序，并且只有在不使用<$OTRSHome>/var/run/时才使用此设置。',
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '如果启用，OTRS将以最小化的形式提供所有CSS文件。',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '如果启用了此选项，OTRS将用压缩格式传送所有的JavaScript文件。',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '如果启用了此选项，电话工单和邮件工单将在新窗口中打开。',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '如果启用了此选项，将从WEB界面、HTTP头信息和外发邮件的X-Headers头信息中移除OTRS版本标签。注意：如果你要修改这个选项，请确保清空缓存。',
        'If enabled, the cache data be held in memory.' => '如果启用了，缓存数据将会保留在内存中。',
        'If enabled, the cache data will be stored in cache backend.' => '如果启用了，缓存数据将会存储到缓存后端。',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '如果启用了此选项，客户可以搜索所有服务的工单（不管这个客户分配了什么服务）。',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '如果启用了此选项，所有概览视图(仪表板、锁定工单视图、队列视图)将在指定的间隔时间自动刷新。',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '如果启用了此选项，在鼠标移动到主菜单位置时打开一级子菜单（而不是需要点击后再打开）。',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '如果启用，那么尚未选择时区的用户将被通知选择时区。 注意：如果（1）用户尚未选择时区，并且（2）OTRSTimeZone和UserDefaultTimeZone相同，（3）未设置为UTC，则不会显示通知。',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '如果没有指定SendmailNotificationEnvelopeFrom，这个选项可确保使用邮件的发件人地址而不是空白的发件人（在某些邮件服务器的配置中需要此选项）。',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '如果设置了此参数，这个地址用于外发通知的信件发件人头信息。如果没有指定地址，则信件发件人头信息为空（除非设置了SendmailNotificationEnvelopeFrom::FallbackToEmailFrom参数）。',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '如果设置了此参数，这个地址将用于外发消息（不是通知-通知在下面查看）的信件发件人头。如果不指定地址，信件发件人头就为空。',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '如果这个选项启用了，服务人员或客户通过WEB界面创建的工单将收到自动响应（如果配置了自动响应）。如果这个选项不启用，则不会发送自动响应。',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '如果这个正则表达式匹配了，自动响应不会发送任何消息。',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '如果启用了本设置，就可以安装未经 OTRS集团验证的软件包。这些软件包可能会威胁到您的整个系统！',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '如果启用这个设置，本地修改内容不会在软件包管理器和支持数据收集工具中高亮显示为错误。',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '如果你要外出，通过设置你不在办公室的确切日期，你可能希望让其他用户知道。',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '忽略系统发件人信件类型 （如：自动响应或电子邮件通知），在 工单详情屏幕或在大视图屏幕自动扩展时将其标记为 \'未读信件\' 。',
        'Import appointments screen.' => '导入预约屏幕。',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '选择队列的时候默认包括子队列的工单。',
        'Include unknown customers in ticket filter.' => '在工单过滤器中包括未知客户。',
        'Includes article create times in the ticket search of the agent interface.' =>
            '服务人员界面工单搜索时包括工单创建时间。',
        'Incoming Phone Call.' => '客户来电。',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '索引加速器：选择您的后端工单视图加速器模块。“RuntimeDB（运行时数据库）”实时生成每个队列视图（工单总数不超过60000个且系统打开的工单不超过6000个时没有性能问题）。“StaticDB（静态数据库）是最强大的模块，它使用额外的类似于视图的工单索引表（工单总数超过80000且系统打开的工单超过6000时推荐使用），使用命令"bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild"来初始化索引。',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '表明是否应该将始终退回邮件视为正常的跟进处理。',
        'Indonesian' => '印度尼西亚语',
        'Inline' => '内联',
        'Input' => '输入',
        'Interface language' => '界面语言',
        'Internal communication channel.' => '内部通信渠道。',
        'International Workers\' Day' => '五一劳动节',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '配置不同皮肤是可能的，例如：区分系统中基于域名的不同服务人员。您可以使用一个正则表达式配置一个键/内容组合来匹配一个域名。“键”应该匹配域名，“值”是一个系统中有效的皮肤。请参照样例条目修改正则表达式的合适格式。',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '配置不同皮肤是可能的，例如：区分系统中基于域名的不同客户。您可以使用一个正则表达式配置一个键/内容组合来匹配一个域名。“键”应该匹配域名，“值”是一个系统中有效的皮肤。请参照样例条目修改正则表达式的合适格式。',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '配置不同主题是可能的，例如：区分系统中基于域名的不同服务人员和客户。您可以使用一个正则表达式配置一个键/内容组合来匹配一个域名。“键”应该匹配域名，“值”是一个系统中有效的皮肤。请参照样例条目修改正则表达式的合适格式。',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => '意大利语',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的意大利语停止词，这些词将从搜索索引中移除。',
        'Ivory' => '象牙白',
        'Ivory (Slim)' => '象牙白（修身版）',
        'Japanese' => '日语',
        'JavaScript function for the search frontend.' => '搜索界面的JavaScript函数。',
        'Korean' => '韩语',
        'Language' => '语言',
        'Large' => '详细',
        'Last Screen Overview' => '最近屏幕概览',
        'Last customer subject' => '最后客户主题',
        'Lastname Firstname' => '姓 名',
        'Lastname Firstname (UserLogin)' => '姓 名（登录用户名）',
        'Lastname, Firstname' => '姓, 名',
        'Lastname, Firstname (UserLogin)' => '姓, 名（登录用户名）',
        'LastnameFirstname' => '姓名',
        'Latvian' => '拉脱维亚语',
        'Left' => '左',
        'Link Object' => '链接对象',
        'Link Object.' => '链接对象。',
        'Link agents to groups.' => '链接服务人员到组。',
        'Link agents to roles.' => '链接服务人员到角色。',
        'Link customer users to customers.' => '链接客户用户到客户。',
        'Link customer users to groups.' => '链接客户用户到组。',
        'Link customer users to services.' => '链接客户用户到服务。',
        'Link customers to groups.' => '链接客户到组。',
        'Link queues to auto responses.' => '链接队列到自动响应。',
        'Link roles to groups.' => '链接角色到组。',
        'Link templates to attachments.' => '连接模板到附件。',
        'Link templates to queues.' => '链接模板到队列。',
        'Link this ticket to other objects' => '将工单链接到其它对象',
        'Links 2 tickets with a "Normal" type link.' => '将2个工单链接为“普通”。',
        'Links 2 tickets with a "ParentChild" type link.' => '将2个工单链接为“父子”。',
        'Links appointments and tickets with a "Normal" type link.' => '将预约和工单链接为“普通”类型。',
        'List of CSS files to always be loaded for the agent interface.' =>
            '服务人员界面始终载入的CSS文件列表。',
        'List of CSS files to always be loaded for the customer interface.' =>
            '客户界面始终载入的CSS文件列表。',
        'List of JS files to always be loaded for the agent interface.' =>
            '服务人员界面始终载入的JS文件列表。',
        'List of JS files to always be loaded for the customer interface.' =>
            '客户界面始终载入的JS文件列表。',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '在图形用户界面中显示的所有客户单位事件列表。',
        'List of all CustomerUser events to be displayed in the GUI.' => '在图形用户界面中显示的所有客户用户事件列表。',
        'List of all DynamicField events to be displayed in the GUI.' => '在图形用户界面中显示的所有动态字段事件列表。',
        'List of all LinkObject events to be displayed in the GUI.' => '在图形用户界面中显示的所有链接对象列表。',
        'List of all Package events to be displayed in the GUI.' => '在图形用户界面中显示的所有软件包事件列表。',
        'List of all appointment events to be displayed in the GUI.' => '在图形用户界面中显示的所有预约事件列表。',
        'List of all article events to be displayed in the GUI.' => '在图形用户界面中显示的信件事件列表。',
        'List of all calendar events to be displayed in the GUI.' => '在图形用户界面中显示的所有日历事件列表。',
        'List of all queue events to be displayed in the GUI.' => '在图形用户界面中显示的队列事件列表。',
        'List of all ticket events to be displayed in the GUI.' => '在图形用户界面中显示的工单事件列表。',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '在创建日历时可用于选择的16进制RGB颜色列表。请使用足够深色的颜色，以确保能够显示上面白色的文本。',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '自动分配给新建队列的默认标准模板列表。',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '服务人员界面始终载入的响应CSS文件列表。',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '客户界面始终载入的响应CSS文件列表。',
        'List view' => '列表视图',
        'Lithuanian' => '立陶宛语',
        'Loader module registration for the agent interface.' => '服务人员界面的加载器模块注册。',
        'Loader module registration for the customer interface.' => '客户界面的加载器模块注册。',
        'Lock / unlock this ticket' => '锁定/解锁这个工单',
        'Locked Tickets' => '锁定的工单',
        'Locked Tickets.' => '锁定的工单。',
        'Locked ticket.' => '锁定的工单。',
        'Logged in users.' => '已登录的用户。',
        'Logged-In Users' => '登录用户',
        'Logout of customer panel.' => '退出客户面板。',
        'Look into a ticket!' => '查看工单内容！',
        'Loop protection: no auto-response sent to "%s".' => '环路保护：没有自动响应发送到“%s”。',
        'Macedonian' => '马其顿',
        'Mail Accounts' => '邮件帐户',
        'MailQueue configuration settings.' => '邮件队列配置设置。',
        'Main menu item registration.' => '注册主菜单条目。',
        'Main menu registration.' => '主菜单注册。',
        'Makes the application block external content loading.' => '使应用程序阻止外部内容加载。',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '在发送邮件或提交电话工单/邮件工单前让系统检查邮件地址的MX记录。',
        'Makes the application check the syntax of email addresses.' => '让系统检查邮件地址的语法。',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '让会话管理使用HTML Cookies。如果禁用了html cookies或客户端浏览器禁用了html cookies，系统仍会正常工作，并将会话ID追加到链接地址中。',
        'Malay' => '马来语',
        'Manage OTRS Group cloud services.' => '管理 OTRS 集团云服务。',
        'Manage PGP keys for email encryption.' => '管理邮件加密的PGP密钥。',
        'Manage POP3 or IMAP accounts to fetch email from.' => '管理收取邮件的POP3或IMAP帐号。',
        'Manage S/MIME certificates for email encryption.' => '管理邮件加密的S/MIME证书。',
        'Manage System Configuration Deployments.' => '管理系统配置部署。',
        'Manage different calendars.' => '管理不同的日历。',
        'Manage existing sessions.' => '管理已登录会话。',
        'Manage support data.' => '管理支持数据。',
        'Manage system registration.' => '管理系统注册。',
        'Manage tasks triggered by event or time based execution.' => '管理事件触发或基于时间执行的任务。',
        'Mark as Spam!' => '标记为垃圾!',
        'Mark this ticket as junk!' => '标记这个工单为垃圾!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '在编写工单屏幕客户信息表格（电话和邮件）的最大尺寸（单位：字符）。',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '服务人员界面已通知的服务人员屏幕的最大尺寸（单位：行）。',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '服务人员界面相关的服务人员屏幕的最大尺寸（单位：行）。',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '在邮件回复和一些概览视图屏幕信件主题的最大尺寸。',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '一天中给自己的邮件地址发送自动邮件响应的最大数（邮件环路保护）。',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '一天中给自己的邮件地址发送自动邮件响应的最大数，可按电子邮件地址进行配置（邮件环路保护）。',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '通过POP3/POP3S/IMAP/IMAPS能够收取的邮件最大尺寸（单位：KB）。',
        'Maximum Number of a calendar shown in a dropdown.' => '一个日历显示在下拉选择框中的最大数字。',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '工单详情视图信件动态字段的最大长度（单位：字符）。',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '工单详情视图侧边栏动态字段的最大长度（单位：字符）。',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '日历概览屏幕能激活的日历最大数。请注意：大量的激活日历会对服务器产生太多的同步调用，可能会有性能影响。',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '服务人员界面搜索结果显示的最大工单数。',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '客户界面搜索结果显示的最大工单数。',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '本次操作结果显示的最大工单数。',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '工单详情视图客户信息表格的最大尺寸（单位：字符）。',
        'Medium' => '基本',
        'Merge this ticket and all articles into another ticket' => '将这个工单和所有的信件合并到另一工单',
        'Merged Ticket (%s/%s) to (%s/%s).' => '已将工单(%s/%s)合并到(%s/%s)。',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '合并工单<OTRS_TICKET>到 <OTRS_MERGE_TO_TICKET>。',
        'Minute' => '分钟',
        'Miscellaneous' => '杂项',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '客户界面创建工间屏幕用于选择的模块。',
        'Module to check if a incoming e-mail message is bounce.' => '检查传入的电子邮件是否退回的模块。',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '检查邮件是否应该被标记为内部（因为原始转发的内部电子邮件）的模块。 IsVisibleForCustomer（是否对客户可见）和SenderType（发件人类型）定义了到达电子邮件/信件的值。',
        'Module to check the group permissions for customer access to tickets.' =>
            '检查客户访问工单组权限的模块。',
        'Module to check the group permissions for the access to tickets.' =>
            '检查访问工单组权限的模块。',
        'Module to compose signed messages (PGP or S/MIME).' => '撰写签名（PGP或S/MIME）消息的模块。',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '定义要使用的电子邮件安全选项（PGP或S/MIME）的模块。',
        'Module to encrypt composed messages (PGP or S/MIME).' => '加密已撰写的消息（PGP或S/MIME）的模块。',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '收取客户用户传入消息的SMIME证书的模块。',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '过滤和处理进入消息的模块，阻止或忽略所有发件人为noreply@开头地址的垃圾邮件。',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '过滤和处理进入消息的模块。工单自定义字段取得4个数字的号码，使用正则表达式匹配，如 From => \'(.+?)@.+?\'，在Set => 中像[***]一样使用()。',
        'Module to filter encrypted bodies of incoming messages.' => '过滤进入消息加密过的正文的模块。',
        'Module to generate accounted time ticket statistics.' => '生成工单统计所用工时的模块。',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '在服务人员界面为简化工单搜索生成HTML开放式搜索模板的模块。',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '在客户界面为简化工单搜索生成HTML开放式搜索模板的模块。',
        'Module to generate ticket solution and response time statistics.' =>
            '生成工单解决时间和响应时间统计的模块。',
        'Module to generate ticket statistics.' => '生成工单统计的模块。',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            '如果客户的客户ID具有必要的组权限，则授予访问权限的模块。',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '如果工单的客户ID匹配客户的客户ID，则授予访问权限的模块。',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '如果工单的客户ID匹配客户的客户用户ID，则授予访问权限的模块。',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '授予访问曾经涉及一个工单的服务人员权限的模块（基于工单历史条目）。',
        'Module to grant access to the agent responsible of a ticket.' =>
            '授予到工单负责人访问权限的模块。',
        'Module to grant access to the creator of a ticket.' => '授予访问工单创建人权限的模块。',
        'Module to grant access to the owner of a ticket.' => '授予访问工单所有者权限的模块。',
        'Module to grant access to the watcher agents of a ticket.' => '授予访问工单关注人服务人员人权限的模块。',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '显示通知和升级信息的模块（ShownMax：显示升级的最大数，EscalationInMinutes：显示要此分钟数内升级的工单，CacheTime：经计算的升级缓冲秒数）。',
        'Module to use database filter storage.' => '使用数据库过滤器的模块。',
        'Module used to detect if attachments are present.' => '用于检测是否存在附件的模块。',
        'Multiselect' => '多选框',
        'My Queues' => '我的队列',
        'My Services' => '我的服务',
        'My Tickets.' => '我的工单。',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '定制队列的名称。定制队列是您的首选队列，能够在偏好设置中选择。',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '定制服务的名称。定制服务是您的首选服务，能够在偏好设置中选择。',
        'NameX' => 'NameX',
        'New Ticket' => '新建工单',
        'New Tickets' => '新建工单',
        'New Window' => '新窗口',
        'New Year\'s Day' => '新年',
        'New Year\'s Eve' => '除夕',
        'New process ticket' => '新的流程工单',
        'News about OTRS releases!' => 'OTRS版本新闻！',
        'News about OTRS.' => 'OTRS新闻。',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '服务人员界面工单电话接入屏幕在添加一个电话备注后工单可能的下一状态。',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '服务人员界面工单电话拨出屏幕在添加一个电话备注后工单可能的下一状态。',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => '没有',
        'Norwegian' => '挪威语',
        'Notification Settings' => '通知设置',
        'Notified about response time escalation.' => '通知响应时间升级。',
        'Notified about solution time escalation.' => '通知解决时间升级。',
        'Notified about update time escalation.' => '通知更新时间升级。',
        'Number of displayed tickets' => '显示工单个数',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '服务人员界面搜索工具显示每个工单的行数。',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '服务人员界面搜索结果每页显示的工单数。',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '客户界面搜索结果每页显示的工单数。',
        'Number of tickets to be displayed in each page.' => '每页显示的工单数量。',
        'OTRS Group Services' => 'OTRS集团服务',
        'OTRS News' => 'OTRS新闻',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTRS能够使用一个或多个只读镜像数据库以扩展操作（如全文搜索或生成统计报表）。您可以在这里指定第一个镜像数据库的DSN（数据源名称）。',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            'OTRS不支持对没有结束日期或没有重复次数的预约做循环处理。在导入过程中，可能有ICS文件包含了此类预约。作为替代，系统将所有的此类预约创建为已过去的预约，然后加上接下来的N个月(默认120个月或10年)的重复预约。',
        'Open an external link!' => '打开一个外部链接！',
        'Open tickets (customer user)' => '处理中的工单（客户用户）',
        'Open tickets (customer)' => '处理中的工单（客户）',
        'Option' => '选项',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '（可选）创建人检查权限模块的队列限制。如果设置了此参数，只有指定队列的工单才授予权限。',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '（可选）相关人检查权限模块的队列限制。如果设置了此参数，只有指定队列的工单才授予权限。',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '（可选）所有者检查权限模块的队列限制。如果设置了此参数，只有指定队列的工单才授予权限。',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '（可选）负责人检查权限模块的队列限制。如果设置了此参数，只有指定队列的工单才授予权限。',
        'Other Customers' => '其它客户',
        'Out Of Office' => '不在办公室',
        'Out Of Office Time' => '不在办公室的时间',
        'Out of Office users.' => '不在办公室的用户。',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '重载（重定义）Kernel::System::Ticket中的函数，以便容易添加定制内容。',
        'Overview Escalated Tickets.' => '已升级工单概览。',
        'Overview Refresh Time' => '概览刷新间隔',
        'Overview of all Tickets per assigned Queue.' => '每个分配队列的所有工单概览。',
        'Overview of all appointments.' => '所有预约的概览。',
        'Overview of all escalated tickets.' => '所有已升级工单的概览。',
        'Overview of all open Tickets.' => '所有处理中的工单概览。',
        'Overview of all open tickets.' => '所有处理中的工单概览。',
        'Overview of customer tickets.' => '客户工单概览。',
        'PGP Key' => 'PGP密钥',
        'PGP Key Management' => 'PGP密钥管理',
        'PGP Keys' => 'PGP密钥',
        'Package event module file a scheduler task for update registration.' =>
            '软件包事件模块注册。',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '服务人员界面的偏好设置视图中CreateNextMask对象的参数。请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '服务人员界面的偏好设置视图中CustomQueue 对象的参数。请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '服务人员界面的偏好设置视图中CustomService 对象的参数。请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '服务人员界面的偏好设置视图中RefreshTime （刷新时间）对象的参数。请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '工单概览简洁版式的列过滤器参数。 请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面客户单位信息的仪表板后端的参数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面客户ID列表概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面客户ID状态小部件的仪表板后端的参数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面客户用户信息的仪表板后端的参数。“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面客户用户列表视图仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面新建工单概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面新建工单概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面处理工单概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面处理工单概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '服务人员界面执行中的队列概览小部件的仪表板后端的参数。“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“QueuePermissionGroup（队列权限组）”不是必需的，只有在启用了权限组且队列属于此权限组时才会显示队列。"States（状态）"是状态的列表，该键是小部件中状态的排序顺序。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '服务人员界面执行中的流程工单概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面工单升级概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面工单升级概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面工单升级概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '服务人员界面工单事件日历的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面工单挂起提醒概览的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面工单挂起提醒的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '服务人员界面工单挂起提醒的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。 注意：只有工单属性和动态字段（DynamicField_NameX）才允许使用DefaultColumns（默认字段）。',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '服务人员界面工单统计的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '服务人员界面即将发生的事件小部件的仪表板后端的参数。"Limit（限制）" 是默认的显示条目数，“GROUP”（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。“Mandatory（强制）”确定插件是否始终显示且不能被服务人员移除。',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '通信日志概览页面（用于显示通信日志条目）的参数。',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '动态字段概览页面（用来显示动态字段）的参数。请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '工单概览基本版式页面（用来显示工单）的参数。请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '工单概览简洁版式页面（用来显示工单）的参数。请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '工单概览预览版式页面（用来显示工单）的参数。请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Parameters of the example SLA attribute Comment2.' => 'SLA样例属性Comment2（注释2）的参数。',
        'Parameters of the example queue attribute Comment2.' => '队列样例属性Comment2（注释2）的参数。',
        'Parameters of the example service attribute Comment2.' => '服务样例属性Comment2（注释2）的参数。',
        'Parent' => '父',
        'ParentChild' => '父子',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '日志文件的路径（仅在邮件循环保护模块选择文件系统时适用且这是强制需要的）。',
        'Pending time' => '挂起时间',
        'People' => '人员',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '对每个已配置的Web服务的每个事件（作为调用程序）执行配置的操作。',
        'Permitted width for compose email windows.' => '编写邮件屏幕允许的宽度。',
        'Permitted width for compose note windows.' => '编写备注屏幕允许的宽度。',
        'Persian' => '波斯语',
        'Phone Call Inbound' => '客户来电',
        'Phone Call Outbound' => '致电客户',
        'Phone Call.' => '电话。',
        'Phone call' => '电话',
        'Phone communication channel.' => '电话通信渠道。',
        'Phone-Ticket' => '电话工单',
        'Picture Upload' => '图片上传',
        'Picture upload module.' => '图片上传模块。',
        'Picture-Upload' => '图片上传',
        'Plugin search' => '搜索插件',
        'Plugin search module for autocomplete.' => '用于自动完成的搜索插件模块。',
        'Polish' => '波兰语',
        'Portuguese' => '葡萄牙语',
        'Portuguese (Brasil)' => '葡萄牙语（巴西）',
        'PostMaster Filters' => '邮箱管理员过滤器',
        'PostMaster Mail Accounts' => '邮箱管理员邮件帐户',
        'Print this ticket' => '打印工单',
        'Priorities' => '优先级',
        'Process Management Activity Dialog GUI' => '流程管理 活动对话框的GUI',
        'Process Management Activity GUI' => '流程管理 活动的GUI',
        'Process Management Path GUI' => '流程管理 路径的GUI',
        'Process Management Transition Action GUI' => '流程管理 转换动作的GUI',
        'Process Management Transition GUI' => '流程管理 转换的GUI',
        'Process Ticket.' => '流程工单。',
        'Process pending tickets.' => '处理挂起的工单。',
        'ProcessID' => '流程ID',
        'Processes & Automation' => '流程和自动化',
        'Product News' => '产品新闻',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '针对CSRF(跨站请求伪造)漏洞利用的保护(参阅 https://en.wikipedia.org/wiki/Cross-site_request_forgery 获取更多信息)。',
        'Provides a matrix overview of the tickets per state per queue' =>
            '提供每个队列每个状态的工单的矩阵概览',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '即使工单未被分配给相同客户ID的客户用户，也可以为客户用户提供基于权限组的工单访问权限。',
        'Public Calendar' => '公共日历',
        'Public calendar.' => '公共日历。',
        'Queue view' => '队列视图',
        'Queues ↔ Auto Responses' => '队列 ↔ 自动回复',
        'Rebuild the ticket index for AgentTicketQueue.' => '为AgentTicketQueue（服务人员工单队列）重建工单索引。',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '通过外部工单编号识别一个工单是否为已有工单的跟进。 注意：“NumberRegExp”表达式中的第一个捕获组将用作工单编号值。',
        'Refresh interval' => '刷新间隔',
        'Registers a log module, that can be used to log communication related information.' =>
            '注册一个日志模块用于记录通信相关信息。',
        'Reminder Tickets' => '提醒的工单',
        'Removed subscription for user "%s".' => '用户“%s”已移除的关注。',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '删除在指定天数之前创建的旧的通用接口调试日志条目。',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '删除旧的系统配置部署（星期日上午）。',
        'Removes old ticket number counters (each 10 minutes).' => '删除旧的工单编号计数器（每10分钟）。',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '工单归档时移除该工单的关注人信息。',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '从客户后端更新已有的SMIME证书。注意：需要在系统配置中启用SMIME和SMIME::FetchFromCustomer，且客户后端模块需要配置为收取UserSMIMECertificate 属性。',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '服务人员界面工单编写屏幕，用客户当前的邮件地址替换编写回复时的原始发件人。',
        'Reports' => '报表',
        'Reports (OTRS Business Solution™)' => '报表 (OTRS商业版)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '从spool目录中重新处理的邮件不能被导入到第一的位置。',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '服务人员界面修改一个工单的客户必需的权限。',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '服务人员界面使用关闭工单屏幕必需的权限。',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '服务人员界面使用外发邮件屏幕必需的权限。',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '服务人员界面使用重发邮件重发屏幕必需的权限。',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '服务人员界面使用退回工单屏幕必需的权限。',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '服务人员界面使用编写工单屏幕必需的权限。',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '服务人员界面使用工单转发屏幕必需的权限。',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '服务人员界面使用工单自定义字段屏幕必需的权限。',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '服务人员界面使用合并工单屏幕必需的权限。',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '服务人员界面使用工单备注屏幕必需的权限。',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '服务人员界面使用工单所有者屏幕必需的权限。',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '服务人员界面使用工单挂起屏幕必需的权限。',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '服务人员界面使用工单接入电话屏幕必需的权限。',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '服务人员界面使用工单拨出电话屏幕必需的权限。',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '服务人员界面使用工单优先级屏幕必需的权限。',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '服务人员界面使用工单负责人屏幕必需的权限。',
        'Resend Ticket Email.' => '重发工单邮件。',
        'Resent email to "%s".' => '已重发邮件到"%s"。',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '如果工单转移到另一个队列，重置并解锁工单所有者。',
        'Resource Overview (OTRS Business Solution™)' => '资源概览（OTRS商业版）',
        'Responsible Tickets' => '负责的工单',
        'Responsible Tickets.' => '负责的工单.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '从归档中恢复一个工单（只针对工单状态变更为任何可处理的状态的事件）。',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '在列表中保留所有的服务，即使他们是无效的子元素。',
        'Right' => '权限',
        'Roles ↔ Groups' => '角色 ↔ 组',
        'Romanian' => '罗马尼亚',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '运行基于文件的自动任务(注意：需要在-configuration-module参数中指定模块名，如"Kernel::System::GenericAgent")。',
        'Running Process Tickets' => '运行中的流程工单',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '访问管理客户单位模块时执行一个初始的已有全部客户单位的搜索。',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '访问管理客户用户模块时执行一个初始的已有全部客户用户的搜索。',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '以“演示”模式运行系统。如果启用了，服务人员能够修改偏好设置，如通过WEB界面选择语言和主题，这些变更内容只对当前会话有效。服务人员不能修改密码。',
        'Russian' => '俄语',
        'S/MIME Certificates' => 'S/MIME证书',
        'SMS' => '短信',
        'SMS (Short Message Service)' => '短信(短消息)',
        'Salutations' => '问候语',
        'Sample command output' => '命令输出样例',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '保存信件的附件。“数据库”在数据库中存储所有数据（不推荐在存储大容量附件时使用）。“文件系统”在文件系统中保存数据；这个选项更快但WEB服务器要以OTRS用户运行。即使是在生产环境您也可以在这两种模式间切换，而不会丢失数据。备注：使用“文件系统”时不能搜索附件名。',
        'Schedule a maintenance period.' => '计划一个系统维护期。',
        'Screen after new ticket' => '创建新工单后的视图',
        'Search Customer' => '搜索客户',
        'Search Ticket.' => '搜索工单。',
        'Search Tickets.' => '搜索工单。',
        'Search User' => '搜索用户',
        'Search backend default router.' => '搜索的后端默认路由。',
        'Search backend router.' => '搜索的后端路由。',
        'Search.' => '搜索。',
        'Second Christmas Day' => '圣诞节的第二天',
        'Second Queue' => '第二队列',
        'Select after which period ticket overviews should refresh automatically.' =>
            '选择工单概览视图自动刷新的时间间隔。',
        'Select how many tickets should be shown in overviews by default.' =>
            '选择概览视图中默认显示的工单数。',
        'Select the main interface language.' => '选择主界面语言。',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '选择CSV文件（统计和搜索）中使用的分隔符。如果不指定，系统将使用当前语言的默认分隔符。',
        'Select your frontend Theme.' => '选择您的界面主题。',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '选择你的个人时区，所有时间将相对于这个时区显示。',
        'Select your preferred layout for the software.' => '选择你喜欢的软件布局。',
        'Select your preferred theme for OTRS.' => '选择你喜欢的OTRS界面主题。',
        'Selects the cache backend to use.' => '选择使用的缓存后端。',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '选择处理WEB界面上传文件的模块。“数据库”存储所有上传文件到数据库中，“文件系统”存储所有上传文件到文件系统中。',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '选择工单编号生成器模块。 使用“AutoIncrement（自动增量）”，系统ID和计数器一起使用“系统ID.计数器”格式（例如1010138,1010139）使用增加工单编号。 使用“Date（日期）”，工单编号将由当前日期、系统ID和计数器生成。 该格式看起来像“年.月.日.系统ID.计数器”（例如200206231010138,200206231010139）。 使用“DateChecksum（日期校验和）”，计数器将作为校验和追加到日期和系统ID的字符串。 校验和将每天轮换。 该格式看起来像“年.月.日.系统ID.计数器.校验和”（例如2002070110101520,2002070110101535）。',
        'Send new outgoing mail from this ticket' => '从这个工单发送新的外发邮件',
        'Send notifications to users.' => '给用户发送通知。',
        'Sender type for new tickets from the customer inteface.' => '客户界面新工单的发件人类型。',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '如果一个工单未锁定发送服务人员的跟进通知只给所有者（默认会发送通知到所有服务人员）。',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '通过BCC（密件抄送）发送所有外发邮件到指定地址。请只在备份情况下使用这个选项。',
        'Sends customer notifications just to the mapped customer.' => '仅给映射的客户用户发送客户通知。',
        'Sends registration information to OTRS group.' => '发送注册信息到OTRS集团。',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '在到达提醒时间后发送解锁工单的提醒通知（只发送给工单所有者）。',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '发送在系统管理界面“工单通知”中配置好的通知。',
        'Sent "%s" notification to "%s" via "%s".' => '已发送"%s"通知到"%s"，通过"%s"方式。',
        'Sent auto follow-up to "%s".' => '已发送自动跟进到"%s"。',
        'Sent auto reject to "%s".' => '已发送自动拒绝到"%s"。',
        'Sent auto reply to "%s".' => '已发送自动回复到"%s"。',
        'Sent email to "%s".' => '已发送电子邮件到"%s"。',
        'Sent email to customer.' => '已发送电子邮件给客户。',
        'Sent notification to "%s".' => '已发送通知到"%s"。',
        'Serbian Cyrillic' => '塞尔维亚西里尔语',
        'Serbian Latin' => '塞尔维亚拉丁语',
        'Service Level Agreements' => '服务级别协议',
        'Service view' => '服务视图',
        'ServiceView' => '服务视图',
        'Set a new password by filling in your current password and a new one.' =>
            '填写当前密码和一个新的密码来设置新密码。',
        'Set sender email addresses for this system.' => '为系统设置发件人的邮件地址.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '设置服务人员工单详情屏幕内嵌HTML信件的默认高度（单位：像素）。',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '设置一个自动任务执行一次能处理的工单数限制。',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '设置服务人员工单详情屏幕内嵌HTML信件的最大高度（单位：像素）。',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '设置最小日志级别。 如果选择\'error\'，则只会记录错误。 使用\'debug\'可以获取所有日志消息。 日志级别的顺序是：\'debug\'，\'info\'，\'notice\'和\'error\'。',
        'Set this ticket to pending' => '挂起工单',
        'Sets if SLA must be selected by the agent.' => '设置是否必须由服务人员选择SLA。',
        'Sets if SLA must be selected by the customer.' => '设置是否必须由客户选择SLA。',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '设置是否必须由服务人员填写备注，能够被参数Ticket::Frontend::NeedAccountedTime覆盖。',
        'Sets if queue must be selected by the agent.' => '设置是否必须由服务人员选择队列。',
        'Sets if service must be selected by the agent.' => '设置是否必须由服务人员选择服务。',
        'Sets if service must be selected by the customer.' => '设置是否必须由客户选择服务。',
        'Sets if state must be selected by the agent.' => '设置是否必须由服务人员选择状态。',
        'Sets if ticket owner must be selected by the agent.' => '设置是否必须由服务人员选择工单所有者。',
        'Sets if ticket responsible must be selected by the agent.' => '设置是否必须由服务人员选择工单负责人。',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '如果工单状态变更到非挂起状态，设置挂起时间为0。',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '为包含尚未触碰的工单的高亮队列设置老化时间（单位：分钟）（一线）。',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '为包含尚未处理的工单的高亮队列设置老化时间（单位：分钟）（二线）。',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '设置系统管理员的配置级别。取决于配置级别，一些系统配置选项不会显示。配置级别递升序次为：专家、高级、新手。更高的配置级别是（例如新手是最高级别），更低级别是管理员在某种程度上只是偶尔配置一下就不再使用了。',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '设置工单概览预览版式中可见的信件数。',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '设置在服务人员界面中新建电子邮件工单默认的信件对客户可见性。',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '设置在服务人员界面中新建电话工单默认的信件对客户可见性。',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '设置服务人员界面关闭工单屏幕添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '设置服务人员界面工单转移屏幕添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注屏幕添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单所有者屏幕添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单挂起屏幕添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级屏幕添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人屏幕添加备注的的默认正文文本。',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '设置服务人员和客户界面登录屏幕的默认错误消息，在系统处于维护期时显示。',
        'Sets the default link type of split tickets in the agent interface.' =>
            '设置在服务人员界面拆分工单默认的链接类型。',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '设置服务人员界面拆分工单的默认链接类型。',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '设置服务人员和客户界面登录屏幕的默认消息，在系统处于维护期时显示。',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '设置系统处于维护期时显示通知的默认消息。',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '设置服务人员界面新建电话工单的默认下一状态。',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '设置服务人员界面创建邮件工单后的默认下一状态。',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '设置服务人员界面新建电话工单的默认备注文本，例如：“通过客户来电新建的工单”。',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '设置服务人员界面新建邮件工单的默认优先级。',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '设置服务人员界面新建电话工单的默认优先级。',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '设置服务人员界面新建邮件工单的默认发件人类型。',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '设置服务人员界面新建电话工单的默认发件人类型。',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '设置服务人员界面新建邮件工单的默认主题，例如“邮件外发”。',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '设置服务人员界面新建电话工单的默认主题，例如“客户来电”。',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '设置服务人员界面关闭工单屏幕添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '设置服务人员界面工单转移屏幕添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注屏幕添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面转移工单屏幕添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面挂起工单屏幕添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级屏幕添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人屏幕添加备注的默认主题。',
        'Sets the default text for new email tickets in the agent interface.' =>
            '设置服务人员界面新建邮件工单的默认文本。',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '设置一个会话被终止且用户登出前的非活动时间（单位：秒）。',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '设置在SessionMaxIdleTime中定义的时间范围内最大的活动服务人员数，之后才能对登录的服务人员显示先前的警告。',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '设置SessionMaxIdleTime中定义的时间范围内最大的活动服务人员数。',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '设置SessionMaxIdleTime中定义的时间范围内的最大的活动客户数。',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '设置SessionMaxIdleTime中定义的时间范围内每个服务人员最大的活动会话数。',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '设置SessionMaxIdleTime中定义的时间范围内每个客户最大的活动会话数。',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            '设置PGP用于使用和加密邮件的方法。 注意Inline（内联）方法与富文本t消息不兼容。',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '设置最小的工单计数器大小（如果工单编号生成器选用“自动增量”）。默认是5（位数），意味着计数器从10000开始。',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '设置在系统维护期多少分钟之前开始显示一个引起注意的通知。',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '设置文本消息显示的行数（例如：队列视图中工单的行）。',
        'Sets the options for PGP binary.' => '设置PGP程序的选项。',
        'Sets the password for private PGP key.' => '设置PGP私钥的密码。',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '设置首选的时间单位（如 工作日、小时、分钟）。',
        'Sets the preferred digest to be used for PGP binary.' => '设置要用于PGP二进制文件的首选摘要。',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '设置配置的web服务器上脚本目录的前缀，这个设置用于变量OTRS_CONFIG_ScriptAlias，此变量可在系统的所有消息表单中找到，用来在系统内创建到工单的链接。',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单关闭屏幕的队列。',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单自定义字段屏幕的队列。',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单备注屏幕的队列。',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单所有者屏幕的队列。',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单挂起屏幕的队列。',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级屏幕的队列。',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单负责人屏幕的队列。',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '设置服务人员界面工单关闭屏幕的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '设置服务人员界面工单批量操作屏幕的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '设置服务人员界面工单自定义字段屏幕的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注屏幕的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单所有者屏幕的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单挂起屏幕的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级屏幕的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人屏幕的服务人员负责人。',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '设置服务人员界面工单关闭屏幕的服务（需要启用Ticket::Service）。',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '设置服务人员界面工单自定义字段屏幕的服务（需要启用Ticket::Service）。',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '设置服务人员界面工单备注屏幕的服务（需要启用Ticket::Service）。',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '设置服务人员界面工单所有者屏幕的服务（需要启用Ticket::Service）。',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '设置服务人员界面工单挂起屏幕的服务（需要启用Ticket::Service）。',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '设置服务人员界面工单优先级屏幕的服务（需要启用Ticket::Service）。',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '设置服务人员界面工单负责人屏幕的服务（需要启用Ticket::Service）。',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '设置服务人员界面关闭工单屏幕的工单状态。',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '设置服务人员界面工单批量处理屏幕的工单状态。',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '设置服务人员界面工单自定义字段屏幕的工单状态。',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注屏幕的工单状态。',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人屏幕的工单状态。',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单详情的所有者屏幕的工单状态。',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单详情的挂起屏幕的工单状态。',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单详情的优先级屏幕的工单状态。',
        'Sets the stats hook.' => '设置统计Hook。',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '设置服务人员界面关闭工单屏幕的工单所有者。',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '设置服务人员界面工单批量操作屏幕的工单所有者。',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '设置服务人员界面工单自定义字段屏幕的工单所有者。',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注屏幕的工单所有者。',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单所有者屏幕的工单所有者。',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单挂起屏幕的工单所有者。',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级屏幕的工单所有者。',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人屏幕的工单所有者。',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '设置服务人员界面工单关闭屏幕的工单类型（需要启用Ticket::Type）。',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '设置服务人员界面工单批量操作屏幕的工单类型。',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '设置服务人员界面工单自定义字段屏幕的工单类型（需要启用Ticket::Type）。',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '设置服务人员界面工单备注屏幕的工单类型（需要启用Ticket::Type）。',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '设置服务人员界面工单所有者屏幕的工单类型（需要启用Ticket::Type）。',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '设置服务人员界面工单挂起屏幕的工单类型（需要启用Ticket::Type）。',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '设置服务人员界面工单优先级屏幕的工单类型（需要启用Ticket::Type）。',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '设置服务人员界面工单负责人屏幕的工单类型（需要启用Ticket::Type）。',
        'Sets the time zone being used internally by OTRS to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            '将OTRS内部使用的时区设置如在数据库中存储日期和时间。 警告：此设置一旦设置就不能更改，包含日期/时间的工单或其他数据已据此创建。',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTRS time zone and the user\'s time zone.' =>
            '设置将分配给新创建的用户的时区，并将用于尚未设置时区的用户。 这是默认使用的时区，用于转换OTRS时区与用户时区之间的日期和时间。',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '设置http/ftp下载的超时时间（单位：秒）。',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '设置软件下载的超时时间（单位：秒），覆盖参数“WebUserAgent::Timeout”。',
        'Shared Secret' => '共享密钥',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '在服务人员界面电话/邮件工单中显示负责人选择。',
        'Show article as rich text even if rich text writing is disabled.' =>
            '以富文本格式显示信件（即使富文本编写被禁用）。',
        'Show command line output.' => '显示命令行输出。',
        'Show queues even when only locked tickets are in.' => '显示队列（即使队列里只有已锁定的工单）。',
        'Show the current owner in the customer interface.' => '在客户界面显示工单当前所有者。',
        'Show the current queue in the customer interface.' => '在客户界面显示当前队列。',
        'Show the history for this ticket' => '显示这个工单的历史',
        'Show the ticket history' => '显示工单历史信息',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '如果信件有附件，在工单详情视图显示附件数。',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情屏幕，在菜单上显示一个链接，以创建一个日历预约并直接链接到此工单。可通过键“Group”和值如“rw:group1;move_into:group2”进行额外的访问控制，以显示或不显示这个链接。如果要放到菜单组中，使用键“ClusterName”，值可以是界面上能看到的任意名称。使用键“ClusterPriority”来配置菜单组在工具栏中显示的顺序。',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“关注/取消关注工单”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“链接工单到另一对象”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“合并工单”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“访问工单历史”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“工单自定义字段”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“添加工单备注”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为“添加工单备注”菜单显示一个链接。',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“添加客户来电”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“添加致电客户”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“修改请求工单的客户”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。在服务人员界面工单详情视图中，为锁定/解锁工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“修改工单所有者”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“修改工单负责人”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为“关闭工单”菜单显示一个链接。',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“关闭工单”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '在服务人员界面所有工单概览视图，为“删除工单”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“删除工单”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '在服务人员界面工单详情视图中，为“注册工单到一个流程”菜单显示一个链接。',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“返回”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '在服务人员界面工单概览视图中，为“锁定/解锁工单”显示一个链接。',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“锁定/解锁工单”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为“转移工单”菜单显示一个链接。',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“打印工单/信件”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为“查看工单历史”菜单显示一个链接。',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“查看工单优先级”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“发送工单的外发邮件”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '在服务人员界面工单各种概览视图中，为“设置工单为垃圾”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“挂起工单”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为“设置工单优先级”菜单显示一个链接。',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为“工单详情”菜单显示一个链接。',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '在服务人员界面信件详情视图中，为通过HTML在线查看器访问信件附件显示一个链接。',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '在服务人员界面信件详情视图中，为下载信件附件显示一个链接。',
        'Shows a link to see a zoomed email ticket in plain text.' => '为以纯文本查看邮件工单显示一个链接。',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为“设置工单为垃圾”菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '在服务人员界面关闭工单屏幕，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '在服务人员界面工单自定义字段屏幕，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '在服务人员界面工单备注屏幕，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单所有者屏幕，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单挂起屏幕，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单优先级屏幕，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面工单负责人屏幕，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '在服务人员界面关闭工单屏幕，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '在服务人员界面工单自定义字段屏幕，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '在服务人员界面工单备注屏幕，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单所有者屏幕，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单挂起屏幕，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单优先级屏幕，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面工单负责人屏幕，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '显示工单概览的预览（如果参数CustomerInfo值为1，还将显示客户信息，参数CustomerInfoMaxSize定义了显示客户信息的最大字符数）。',
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '在OTRS 商业版™的工单附件视图的菜单中显示一个头部预览链接。',
        'Shows all both ro and rw queues in the queue view.' => '在工单队列视图中显示所有RO（只读）和RW（读写）队列。',
        'Shows all both ro and rw tickets in the service view.' => '在工单服务视图中显示所有RO（只读）和RW（读写）服务。',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '在服务人员界面工单升级视图显示所有处理中的工单（即使工单已被锁定）。',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '在服务人员工单详情视图中展开显示这个工单所有的信件。',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '在客户的工单详情视图中展开显示这个工单所有的信件。',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '在多选框字段中显示所有的客户ID（如果客户ID过多则不可用）。',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '在一个多选框字段中显示所有的客户用户（如果客户用户过多则不好用）。',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '在服务人员界面电话和邮件工单屏幕显示所有者选择器。',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '在AgentTicketPhone（服务人员电话工单）、AgentTicketEmail（服务人员邮件工单）和AgentTicketCustomer（服务人员客户工单）模块显示客户历史工单信息。',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '在工单概览简洁版式中显示最近的客户信件的主题或工单标题。',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '以树形或列表形式显示系统中存在的父/子队列的清单。',
        'Shows information on how to start OTRS Daemon' => '显示如何启动OTRS守护进程的信息',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '在服务人员界面的工单详情视图中显示到外部页面的链接。 可以通过使用键“Group”和内容如“rw：group1; move_into：group2”来完成额外的访问控制，以显示或不显示此链接。',
        'Shows the article head information in the agent zoom view.' => '在服务人员工单详情视图显示信件的头部信息。',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '在服务人员界面工单详情视图，按正常排序或反向排序显示信件。',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '在工单编写屏幕显示客户用户信息（电话和邮件）。',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '在客户界面显示已启用的工单属性（0 = 禁用，1 = 启用）。',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '在服务人员仪表板中显示当天的消息（MOTD）。 “组”用于限制对插件的访问（例如，组：admin; group1; group2;）。 “默认”表示插件是默认启用，还是需要用户手动启用插件。 “强制”确定插件是否始终显示，不能被服务人员移除。',
        'Shows the message of the day on login screen of the agent interface.' =>
            '在服务人员界面登录屏幕显示当天消息（MOTD）。',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '在服务人员界面显示工单历史（倒序）。',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '在服务人员界面关闭工单屏幕是否显示工单优先级的选项。',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '在服务人员界面转移工单屏幕是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '在服务人员界面工单批量操作屏幕是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '在服务人员界面工单自定义字段屏幕是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '在服务人员界面工单备注屏幕是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单所有者屏幕是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单挂起屏幕是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单优先级屏幕是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面工单负责人屏幕显示工单优先级选项。',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '在服务人员界面关闭工单屏幕显示工单标题字段。',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '在服务人员界面工单自定义字段屏幕显示工单标题标题字段。',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '在服务人员界面工单备注屏幕显示工单标题字段。',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单所有者屏幕显示工单标题字段。',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单挂起屏幕显示工单标题字段。',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单优先级屏幕显示工单标题字段。',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面工单负责人屏幕显示工单标题字段。',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '如果启用，则以长格式显示时间（天、小时、分钟）；如果不启用，则以短格式显示时间（天、小时）。',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '如果启用，则显示时间的完整描述（天、小时、分钟）；如果不启用，则只显示时间的首字母（d-天，h-时,m-分）。',
        'Signature data.' => '',
        'Signatures' => '签名',
        'Simple' => '简单',
        'Skin' => '皮肤',
        'Slovak' => '斯洛伐克语',
        'Slovenian' => '斯洛文尼亚语',
        'Small' => '简洁',
        'Software Package Manager.' => '软件包管理器。',
        'Solution time' => '解决时间',
        'SolutionDiffInMin' => '解决时间差（分钟）',
        'SolutionInMin' => '解决时间（分钟）',
        'Some description!' => '一些描述！',
        'Some picture description!' => '一些图片的描述！',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '队列视图选择一个队列后按升序或降序排序工单（在工单以优先级排序之后）。值：0 = 升序（最老的在最上面，默认），1 = 降序（最近的在最上面），键为队列ID，值为0或1。',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '服务视图选择一个队列后按升序或降序排序工单（在工单以优先级排序之后）。值：0 = 升序（最老的在最上面，默认），1 = 降序（最近的在最上面），键为队列ID，值为0或1。',
        'Spam' => '垃圾邮件',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Spam Assassin（是一种安装在邮件服务器上的邮件过滤器）样例设置，忽略SpamAssassin标记的邮件。',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Spam Assassin（是一种安装在邮件服务器上的邮件过滤器）样例设置，将标记的邮件移到垃圾队列。',
        'Spanish' => '西班牙语',
        'Spanish (Colombia)' => '西班牙语（哥伦比亚）',
        'Spanish (Mexico)' => '西班牙语（墨西哥）',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的西班牙语停止词，这些词将从搜索索引中移除。',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '设置服务人员是否收到自己的工单动作的邮件通知。',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '如果为“ArticleStorage（信件存储）”选择了“FS（文件系统）”，指定存储数据的目录。',
        'Specifies the directory where SSL certificates are stored.' => '指定存储SSL证书的目录。',
        'Specifies the directory where private SSL certificates are stored.' =>
            '指定存储私有SSL证书的目录。',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '指定系统发送通知的邮件地址。这个邮件地址用来创建通知管理员的完整显示名称（如"OTRS通知"otrs@your.example.com），您可以使用配置的变量OTRS_CONFIG_FQDN，或者选择另外的邮件地址。',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '指定从调度程序任务获取通知消息的邮件地址。',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '指定组名，以便组中有rw（读写）权限的用户能够访问“切换到客户”功能。',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '指定用户需要rw（读写）权限的组，以便他们可以编辑其他用户的首选项。',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '指定系统发送通知的姓名，这个发件人姓名用于创建通知管理员完整的显示名称（如"OTRS通知"otrs@your.example.com）。',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '指定服务人员显示姓和名的先后顺序。',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '指定页面头部LOGO文件的路径（gif|jpg|png，700 X 100 像素）。',
        'Specifies the path of the file for the performance log.' => '指定性能日志文件的路径。',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '指定在WEB界面查看微软Excel文件的转换器路径。',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '指定在WEB界面查看微软Word文件的转换器路径。',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '指定在WEB界面查看PDF文档的转换器路径。',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '指定在WEB界面查看XML文件的转换器路径。',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '指定在日志文件中表示CGI脚本条目的文本。',
        'Specifies user id of the postmaster data base.' => '指定邮箱管理员数据库的用户ID。',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '指定在搜索附件时是否检查所有的存储后端。这个选项只在安装时选择了一些附件保存在文件系统、一些附件保存到数据库中时才需要设置。',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '指定（MIMEBase）文章附件是否将被索引和可搜索。',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '指定在创建缓存文件时使用多少级子目录，这可以防止一个目录中有太多的缓存文件。',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '指定获取OTRS商业版更新的通道。警告：开发版可能无法完成更新，您的系统可能经历无法恢复的错误，并且系统在极端情况下可能变得无法响应！',
        'Specify the password to authenticate for the first mirror database.' =>
            '指定第一个镜像数据库的认证密码。',
        'Specify the username to authenticate for the first mirror database.' =>
            '指定第一个镜像数据库的认证用户名。',
        'Stable' => '稳定的',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '系统中服务人员可用的标准权限，如果需要更多的权限，可以在这里输入。权限必须已定义好且有效，一些好的权限已经内置：备注、关闭、挂起、客户、自定义字段、转移、编写、负责人、转发和退回。请确保“rw（读写）始终是注册权限的最后一条。',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '统计计数的开始数，这个数字在每个新的统计后增加。',
        'Started response time escalation.' => '响应时间升级已启动。',
        'Started solution time escalation.' => '解决时间升级已启动。',
        'Started update time escalation.' => '更新时间升级已启动。',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '在打开链接对象遮罩屏幕后搜索一次所有活动对象。',
        'Stat#' => '统计号',
        'States' => '状态',
        'Statistic Reports overview.' => '统计报告概览。',
        'Statistics overview.' => '统计概览。',
        'Status view' => '状态视图',
        'Stopped response time escalation.' => '响应时间升级已停止。',
        'Stopped solution time escalation.' => '解决时间升级已停止。',
        'Stopped update time escalation.' => '更新时间升级已停止。',
        'Stores cookies after the browser has been closed.' => '在浏览器关闭后保存cookies。',
        'Strips empty lines on the ticket preview in the queue view.' => '在工单队列视图工单预览时去掉空白行。',
        'Strips empty lines on the ticket preview in the service view.' =>
            '在工单服务视图工单预览时去掉空白行。',
        'Support Agent' => '维护人员',
        'Swahili' => '斯瓦希里语',
        'Swedish' => '瑞典语',
        'System Address Display Name' => '系统邮件地址显示姓名',
        'System Configuration Deployment' => '系统配置部署',
        'System Configuration Group' => '系统配置组',
        'System Maintenance' => '系统维护',
        'Templates ↔ Attachments' => '模板 ↔ 附件',
        'Templates ↔ Queues' => '模板↔队列',
        'Textarea' => '文本区域',
        'Thai' => '泰国语',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '服务人员界面皮肤的内部名称，请在Frontend::Agent::Loader::Agent::Skin中检查可用的皮肤。',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '客户界面皮肤的内部名称，请在Frontend::Customer::Loader::Customer::Skin中检查可用的皮肤。',
        'The daemon registration for the scheduler cron task manager.' =>
            'cron任务管理器调度程序的守护进程注册。',
        'The daemon registration for the scheduler future task manager.' =>
            '未来任务管理器调度程序的守护进程注册。',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '自动任务管理器调度程序的守护进程注册。',
        'The daemon registration for the scheduler task worker.' => '任务worker调度程序的守护进程注册。',
        'The daemon registration for the system configuration deployment sync manager.' =>
            '系统配置部署同步管理器的守护程序注册。',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'TicketHook和工单编号之间的分隔符，如“:”。',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '发出事件后的持续时间，在这个时间段抑制新的升级通知和开始事件。',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '邮件主题的格式，“左”代表\'[TicketHook#:12345] Some Subject\'，“右”代表\'Some Subject [TicketHook#:12345]\'，“无”代表\'Some Subject\'（没有工单编号）。如果设置为“无”，您应该验证设置PostMaster::CheckFollowUpModule###0200-References是激活的，以识别邮件标头的跟进。',
        'The headline shown in the customer interface.' => '客户界面显示的标题。',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '工单的标识符，如Ticket#、Call#、MyTicket#，默认为Ticket#。',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
            '服务人员界面“High Contrast（高对比度）”皮肤显示在顶部的LOGO，查看“AgentLogo”以获得更多描述。',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '服务人员界面“默认”皮肤显示在顶部的LOGO，查看“AgentLogo”以获得更多描述。',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '服务人员界面“ivory”皮肤显示在顶部的LOGO，查看“AgentLogo”以获得更多描述。',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '服务人员界面“象牙白-修身版”皮肤显示在顶部的LOGO，查看“AgentLogo”以获得更多描述。',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '服务人员界面“修身版”皮肤显示在顶部的LOGO，查看“AgentLogo”以获得更多描述。',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '服务人员界面显示在顶部的LOGO，图片的URL地址可以是皮肤图片目录的相对URL，也可以是远程WEB服务器的完整URL。',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '客户界面显示在顶部的LOGO，图片的URL地址可以是皮肤图片目录的相对URL，也可以是远程WEB服务器的完整URL。',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '服务人员界面显示在登录窗口顶部的LOGO，图片的URL地址可以是皮肤图片目录的相对路径，也可以是远程WEB服务器的完整地址。',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '在工单详情屏幕一个页面上能展开的最大信件数。',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '在工单详情屏幕一个页面上能显示的最大信件数。',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '重连到邮件服务器前一次能收取邮件的最大数。',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '您提供的密码无效。 密码必须包含字母（A-Z，大写）和数字（2-7），并且必须包含16个字符。',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '回复邮件中加在主题前的文字，如RE、AW或AS。',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '转发邮件中加在主题前的文字，如FW、Fwd或WG。',
        'The value of the From field' => '“发件人”字段的值',
        'Theme' => '主题',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '这个事件模块将客户用户的属性存储为工单动态字段，如何配置这个映射请查看DynamicFieldFromCustomerUser::Mapping设置。',
        'This is a Description for Comment on Framework.' => '这是在框架中关于注释的描述信息。',
        'This is a Description for DynamicField on Framework.' => '这是在框架中关于动态字段的描述信息。',
        'This is the default orange - black skin for the customer interface.' =>
            '这是客户界面默认的橙色-黑色皮肤。',
        'This is the default orange - black skin.' => '这是默认的橙色-黑色皮肤。',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '每次请求时这个模块和它的PreRun()函数（如果定义了）将被执行。',
        'This module is part of the admin area of OTRS.' => '这个模块是OTRS系统管理的一部分。',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '这个选项定义存储流程管理活动条目ID的动态字段。',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '这个选项定义存储流程管理流程条目ID的动态字段。',
        'This option defines the process tickets default lock.' => '这个选项定义流程工单的默认锁定。',
        'This option defines the process tickets default priority.' => '这个选项定义流程工单的默认优先级。',
        'This option defines the process tickets default queue.' => '这个选项定义流程工单的默认队列。',
        'This option defines the process tickets default state.' => '这个选项定义流程工单的默认状态。',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '这个选项将拒绝客户用户访问不是由他本人创建的客户单位工单。',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '这个设置允许您使用自己的国家列表覆盖内置的国家列表，如果您只想用到一小部分的国家时格外有用。',
        'This setting is deprecated. Set OTRSTimeZone instead.' => '此设置已弃用。 替代方式是设置OTRSTimeZone。',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            '这个设置显示所有概览屏幕（而不是仅队列视图）中的排序属性。',
        'This will allow the system to send text messages via SMS.' => '这个选项允许系统通过短信发送文本消息。',
        'Ticket Close.' => '工单关闭。',
        'Ticket Compose Bounce Email.' => '工单编写退回邮件。',
        'Ticket Compose email Answer.' => '工单编写邮件回复。',
        'Ticket Customer.' => '工单客户。',
        'Ticket Forward Email.' => '工单转发邮件。',
        'Ticket FreeText.' => '工单自定义字段。',
        'Ticket History.' => '工单历史。',
        'Ticket Lock.' => '工单锁定。',
        'Ticket Merge.' => '工单合并。',
        'Ticket Move.' => '工单转移（队列）。',
        'Ticket Note.' => '工单备注。',
        'Ticket Notifications' => '工单通知',
        'Ticket Outbound Email.' => '工单外发邮件。',
        'Ticket Overview "Medium" Limit' => '工单概览基本版式的限制',
        'Ticket Overview "Preview" Limit' => '工单概览预览版式的限制',
        'Ticket Overview "Small" Limit' => '工单概览简洁版式的限制',
        'Ticket Owner.' => '工单所有者。',
        'Ticket Pending.' => '工单挂起。',
        'Ticket Print.' => '工单打印。',
        'Ticket Priority.' => '工单优先级。',
        'Ticket Queue Overview' => '工单队列概览',
        'Ticket Responsible.' => '工单负责人。',
        'Ticket Watcher' => '工单关注人',
        'Ticket Zoom' => '工单详情',
        'Ticket Zoom.' => '工单详情。',
        'Ticket bulk module.' => '工单批量操作模块。',
        'Ticket event module that triggers the escalation stop events.' =>
            '触发升级停止事件的工单事件模块。',
        'Ticket limit per page for Ticket Overview "Medium".' => '工单概览基本版式的每页工单数量。',
        'Ticket limit per page for Ticket Overview "Preview".' => '工单概览预览版式的每页工单数量。',
        'Ticket limit per page for Ticket Overview "Small".' => '工单概览简洁版式的每页工单数量。',
        'Ticket notifications' => '工单通知',
        'Ticket overview' => '工单概览',
        'Ticket plain view of an email.' => '显示工单邮件的纯文本。',
        'Ticket split dialog.' => '工单拆分对话框。',
        'Ticket title' => '工单标题',
        'Ticket zoom view.' => '工单详情视图。',
        'TicketNumber' => '工单编号',
        'Tickets.' => '工单。',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '如果设置一个挂起状态，添加到实际时间的秒数（默认：86400 = 1天）。',
        'To accept login information, such as an EULA or license.' => '接受登录信息，如EULA（最终用户许可协议）或许可。',
        'To download attachments.' => '下载附件。',
        'To view HTML attachments.' => '查看HTML附件。',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '在软件包管理器中显示/不显示OTRS扩展功能。',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '工具栏条目的快捷键。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '预约通知的传输选项。 请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '工单通知的传输选项。 请注意：将\'Active（激活）\'设置为0只会阻止服务人员在个人偏好设置中编辑此组的设置，但仍然允许管理员以其他用户的名义编辑这些设置。 使用\'PreferenceGroup\'来控制这些设置应该显示在用户界面的哪个区域。',
        'Tree view' => '树形视图',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '基于某些工单时间添加或更新自动日历预约的触发器。',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '工单升级事件和工单升级通知事件的触发器。',
        'Turkish' => '土耳其语',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '关闭SSL证书验证，例如在使用HTTPS透明代理时。使用这个设置风险自负！',
        'Turns on drag and drop for the main navigation.' => '开启主菜单的拖放功能。',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '开启远程IP地址检查。如果通过代理或拨号连接访问系统，应该关闭，因为远程IP在每次请求时可能都不一样。',
        'Tweak the system as you wish.' => '根据需要调整系统。',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '要使用的守护程序日志循环类型：选择“OTRS”以使OTRS系统处理文件循环，或选择“外部”以使用第三方循环机制（如logrotate）。 注意：外部循环机制需要使用其自身的配置。',
        'Ukrainian' => '乌克兰语',
        'Unlock tickets that are past their unlock timeout.' => '过了解锁超时时间后解锁工单。',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '每当添加备注或所有者不在办公室时，解锁工单。',
        'Unlocked ticket.' => '解锁的工单。',
        'Up' => '上',
        'Upcoming Events' => '即将发生的事件',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '如果每个工单都已看过或创建了新的信件，更新工单“已看”标志。',
        'Update time' => '更新时间',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '在工单属性更新后更新工单升级指标。',
        'Updates the ticket index accelerator.' => '更新工单索引加速器。',
        'Upload your PGP key.' => '上传你的PGP密钥。',
        'Upload your S/MIME certificate.' => '上传你的S/MIME证书。',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '服务人员界面在合适的地方（输入字段）使用新式选择和自动完成字段。',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '客户界面在合适的地方（输入字段）使用新式选择和自动完成字段。',
        'User Profile' => '用户资料',
        'UserFirstname' => '用户的名字',
        'UserLastname' => '用户的姓',
        'Users, Groups & Roles' => '用户、组和角色',
        'Uses richtext for viewing and editing ticket notification.' => '查看和编辑工单通知时使用富文本。',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '查看和编辑以下内容时使用富文本：信件、问候语、签名、标准模板、自动响应和通知。',
        'Vietnam' => '越南语',
        'View all attachments of the current ticket' => '查看当前工单的所有附件',
        'View performance benchmark results.' => '查看性能基准测试结果.',
        'Watch this ticket' => '关注这个工单',
        'Watched Tickets' => '关注的工单',
        'Watched Tickets.' => '关注的工单。',
        'We are performing scheduled maintenance.' => '我们正在执行计划的系统维护。',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '我们正在执行系统维护，暂时无法登录。',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '我们正在执行系统维护，很快就恢复正常使用。',
        'Web Services' => 'Web服务',
        'Web View' => 'WEB视图',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '服务人员创建工单时，工单是否被自动锁定到该服务人员。',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '工单被合并时，自动添加一个备注到不再活动的工单，您可以在这里定义这个备注的正文（这个文本不能被服务人员修改）。',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '工单被合并时，自动添加一个备注到不再活动的工单，您可以在这里定义这个备注的主题（这个主题不能被服务人员修改）。',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '工单被合并时，通过设置“通知发送人”复选框选项，客户能收到邮件通知，您可以在这个文本框中定义一个预先格式化的文本（服务人员可在以后修改）。',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '通过在Ticket::Frontend::ZoomCollectMetaFilters中配置的过滤器确定是否收集信件元信息。',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '是否强制将所有请求从http重定向到https协议。启用此选项之前，请检查Web服务器是否正确配置了https协议。',
        'Yes, but hide archived tickets' => '是，但隐藏已归档的工单',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '您的工单号为“<OTRS_TICKET>”的邮件已经退回给“<OTRS_BOUNCE_TO>”，请联系这个地址以获得更多的信息。',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            '您的单号为"<OTRS_TICKET>"的邮件已被合并到工单"<OTRS_MERGE_TO_TICKET>" 。',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '你的优先队列中选择的队列，如果启用了，你还会得到有关这些队列的电子邮件通知。',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '你的优先服务中选择的服务，如果启用了，你还会得到有关这些队列的电子邮件通知。',
        'Zoom' => '展开',
        'attachment' => '附件',
        'bounce' => '退回',
        'compose' => '编写',
        'debug' => '调试',
        'error' => '错误',
        'forward' => '转发',
        'info' => '信息',
        'inline' => '内联',
        'normal' => '正常',
        'notice' => '注意',
        'pending' => '挂起',
        'phone' => '电话',
        'responsible' => '负责人',
        'reverse' => '倒序',
        'stats' => 'stats（统计）',

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
