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
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
    $Self->{Completeness}        = 0.556276516096831;

    # csv separator
    $Self->{Separator} = '';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => '是',
        'No' => '否',
        'yes' => '是',
        'no' => '未设置',
        'Off' => '关',
        'off' => '关',
        'On' => '开',
        'on' => '开',
        'top' => '顶端',
        'end' => '底部',
        'Done' => '确认',
        'Cancel' => '取消',
        'Reset' => '重置',
        'more than ... ago' => '在...之前',
        'in more than ...' => '',
        'within the last ...' => '在最近...之内',
        'within the next ...' => '在未来...',
        'Created within the last' => '在最近...之内创建的',
        'Created more than ... ago' => '在...之前创建的',
        'Today' => '今天',
        'Tomorrow' => '明天',
        'Next week' => '下周',
        'day' => '天',
        'days' => '天',
        'day(s)' => '天',
        'd' => '天',
        'hour' => '小时',
        'hours' => '小时',
        'hour(s)' => '小时',
        'Hours' => '小时',
        'h' => '时',
        'minute' => '分钟',
        'minutes' => '分钟',
        'minute(s)' => '分钟',
        'Minutes' => '分钟',
        'm' => '分',
        'month' => '月',
        'months' => '月',
        'month(s)' => '月',
        'week' => '星期',
        'week(s)' => '星期',
        'quarter' => '',
        'quarter(s)' => '',
        'half-year' => '',
        'half-year(s)' => '',
        'year' => '年',
        'years' => '年',
        'year(s)' => '年',
        'second(s)' => '秒',
        'seconds' => '秒',
        'second' => '秒',
        's' => '秒',
        'Time unit' => '时间单位',
        'wrote' => '写道',
        'Message' => '消息',
        'Error' => '错误',
        'Bug Report' => 'Bug 报告',
        'Attention' => '注意',
        'Warning' => '警告',
        'Module' => '模块',
        'Modulefile' => '模块文件',
        'Subfunction' => '子功能',
        'Line' => '行',
        'Setting' => '设置',
        'Settings' => '设置',
        'Example' => '范例',
        'Examples' => '范例',
        'valid' => '有效',
        'Valid' => '有效',
        'invalid' => '无效',
        'Invalid' => '无效',
        '* invalid' => '* 无效',
        'invalid-temporarily' => '暂时无效',
        ' 2 minutes' => ' 2 分钟',
        ' 5 minutes' => ' 5 分钟',
        ' 7 minutes' => ' 7 分钟',
        '10 minutes' => '10 分钟',
        '15 minutes' => '15 分钟',
        'Mr.' => '先生',
        'Mrs.' => '女士',
        'Next' => '下一步',
        'Back' => '后退',
        'Next...' => '下一步...',
        '...Back' => '...上一步',
        '-none-' => '-无-',
        'none' => '无',
        'none!' => '无!',
        'none - answered' => '无 - 已答复的',
        'please do not edit!' => '不要编辑!',
        'Need Action' => '需要操作',
        'AddLink' => '增加链接',
        'Link' => '链接',
        'Unlink' => '未链接',
        'Linked' => '已链接',
        'Link (Normal)' => '链接(普通)',
        'Link (Parent)' => '链接(父)',
        'Link (Child)' => '链接(子)',
        'Normal' => '普通',
        'Parent' => '父',
        'Child' => '子',
        'Hit' => '点击',
        'Hits' => '点击数',
        'Text' => '正文',
        'Standard' => '标准',
        'Lite' => '简洁',
        'User' => '用户',
        'Username' => '用户名',
        'Language' => '语言',
        'Languages' => '语言',
        'Password' => '密码',
        'Preferences' => '首选项',
        'Salutation' => '回复抬头',
        'Salutations' => '回复抬头',
        'Signature' => '回复签名',
        'Signatures' => '回复签名',
        'Customer' => '用户单位',
        'CustomerID' => '单位编号',
        'CustomerIDs' => '单位编号',
        'customer' => '用户单位',
        'agent' => '服务人员',
        'system' => '系统',
        'Customer Info' => '用户信息',
        'Customer Information' => '用户信息',
        'Customer Companies' => '用户单位',
        'Company' => '单位',
        'go!' => '开始!',
        'go' => '开始',
        'All' => '全部',
        'all' => '全部',
        'Sorry' => '对不起',
        'update!' => '更新!',
        'update' => '更新',
        'Update' => '更新',
        'Updated!' => '已更新',
        'submit!' => '提交!',
        'submit' => '提交',
        'Submit' => '提交',
        'change!' => '修改!',
        'Change' => '修改',
        'change' => '修改',
        'click here' => '点击这里',
        'Comment' => '注释',
        'Invalid Option!' => '无效选项!',
        'Invalid time!' => '无效时间!',
        'Invalid date!' => '无效日期!',
        'Name' => '名称',
        'Group' => '组',
        'Description' => '描述',
        'description' => '描述',
        'Theme' => '主题',
        'Created' => '创建于',
        'Created by' => '创建人',
        'Changed' => '修改于',
        'Changed by' => '修改人',
        'Search' => '搜索',
        'and' => '和',
        'between' => '绝对',
        'before/after' => '相对',
        'Fulltext Search' => '全文搜索',
        'Data' => '日期',
        'Options' => '选项',
        'Title' => '标题',
        'Item' => '条目',
        'Delete' => '删除',
        'Edit' => '编辑',
        'View' => '查看',
        'Number' => '编号',
        'System' => '系统',
        'Contact' => '联系人',
        'Contacts' => '联系人',
        'Export' => '导出',
        'Up' => '上',
        'Down' => '下',
        'Add' => '添加',
        'Added!' => '已添加!',
        'Category' => '类别',
        'Viewer' => '查看器',
        'Expand' => '展开',
        'Small' => '简洁',
        'Medium' => '基本',
        'Large' => '详细',
        'Date picker' => '日期选择器',
        'Show Tree Selection' => '',
        'The field content is too long!' => '',
        'Maximum size is %s characters.' => '',
        'This field is required or' => '',
        'New message' => '新消息',
        'New message!' => '新消息!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            '请答复工单，然后返回到队列概况!',
        'You have %s new message(s)!' => '您有%s条新消息!',
        'You have %s reminder ticket(s)!' => '您有%s个工单提醒!',
        'The recommended charset for your language is %s!' => '推推荐的语言的字符集是%s!',
        'Change your password.' => '更换你的密码。',
        'Please activate %s first!' => '请首先激活%s！',
        'No suggestions' => '无建议',
        'Word' => '字',
        'Ignore' => '忽略',
        'replace with' => '替换',
        'There is no account with that login name.' => '该用户名没有帐户信息。',
        'Login failed! Your user name or password was entered incorrectly.' =>
            '登录失败！用户名或密码错误。',
        'There is no acount with that user name.' => '没有此用户。',
        'Please contact your administrator' => '请联系管理员',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '',
        'Logout' => '退出',
        'Logout successful. Thank you for using %s!' => '成功退出，谢谢使用!',
        'Feature not active!' => '该特性尚未激活!',
        'Agent updated!' => '服务人员已更新！',
        'Database Selection' => '数据库选择',
        'Create Database' => '创建数据库',
        'System Settings' => '数据库设置 ',
        'Mail Configuration' => '邮件配置',
        'Finished' => '完成',
        'Install OTRS' => '安装OTRS',
        'Intro' => '介绍',
        'License' => '许可证',
        'Database' => '数据库',
        'Configure Mail' => '配置邮件',
        'Database deleted.' => '数据库已删除。',
        'Enter the password for the administrative database user.' => '输入数据库管理员密码。',
        'Enter the password for the database user.' => '输入数据库用户密码。',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '如果你的数据库为root设置了密码，你必须在这里输入；否则，该字段为空。',
        'Database already contains data - it should be empty!' => '数据库中已包含数据 - 应该删除它！',
        'Login is needed!' => '需要先登录!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '',
        'Password is needed!' => '需要密码!',
        'Take this Customer' => '取得这个用户',
        'Take this User' => '取得这个用户',
        'possible' => '可能',
        'reject' => '拒绝',
        'reverse' => '倒序',
        'Facility' => '设施',
        'Time Zone' => '时区',
        'Pending till' => '挂起至',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '不要使用OTRS系统缺省帐号! 请创建新的服务人员帐号。',
        'Dispatching by email To: field.' => '按收件人(To:)分派.',
        'Dispatching by selected Queue.' => '按所选队列分派.',
        'No entry found!' => '无内容!',
        'Session invalid. Please log in again.' => '会话无效，请重新登录.',
        'Session has timed out. Please log in again.' => '会话超时，请重新登录.',
        'Session limit reached! Please try again later.' => '会话数量已超，请过会再试.',
        'No Permission!' => '无权限!',
        '(Click here to add)' => '(点击此处添加)',
        'Preview' => '预览',
        'Package not correctly deployed! Please reinstall the package.' =>
            '软件包未正确安装！请重新安装软件包。',
        '%s is not writable!' => '%s不可写的!',
        'Cannot create %s!' => '无法创建%s!',
        'Check to activate this date' => '选中它，以便设置这个日期',
        'You have Out of Office enabled, would you like to disable it?' =>
            '你已设置为不在办公室，是否取消它?',
        'News about OTRS releases!' => 'OTRS版本新闻',
        'Customer %s added' => '用户%s已添加',
        'Role added!' => '角色已添加！',
        'Role updated!' => '角色已更新！',
        'Attachment added!' => '附件已添加！',
        'Attachment updated!' => '附件已更新！',
        'Response added!' => '回复已添加！',
        'Response updated!' => '回复已更新！',
        'Group updated!' => '组已更新！',
        'Queue added!' => '队列已添加！',
        'Queue updated!' => '队列已更新！',
        'State added!' => '状态已添加！',
        'State updated!' => '状态已更新！',
        'Type added!' => '类型已添加！',
        'Type updated!' => '类型已更新！',
        'Customer updated!' => '用户已更新！',
        'Customer company added!' => '用户单位已添加！',
        'Customer company updated!' => '用户单位已更新！',
        'Note: Company is invalid!' => '注意：单位无效！',
        'Mail account added!' => '邮件账号已添加！',
        'Mail account updated!' => '邮件账号已更新！',
        'System e-mail address added!' => '系统邮件地址已添加！',
        'System e-mail address updated!' => '系统邮件地址已更新！',
        'Contract' => '合同',
        'Online Customer: %s' => '在线用户户: %s',
        'Online Agent: %s' => '在线服务人员：%s',
        'Calendar' => '日历',
        'File' => '文件',
        'Filename' => '文件名',
        'Type' => '类型',
        'Size' => '大小',
        'Upload' => '上传',
        'Directory' => '目录',
        'Signed' => '已签名',
        'Sign' => '签名',
        'Crypted' => '已加密',
        'Crypt' => '加密',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP密钥',
        'PGP Keys' => 'PGP密钥',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME证书',
        'S/MIME Certificates' => 'S/MIME证书',
        'Office' => '办公室',
        'Phone' => '电话',
        'Fax' => '传真',
        'Mobile' => '手机',
        'Zip' => '邮编',
        'City' => '城市',
        'Street' => '街道',
        'Country' => '国家',
        'Location' => '位置',
        'installed' => '已安装',
        'uninstalled' => '未安装',
        'Security Note: You should activate %s because application is already running!' =>
            '安全提示: %s无法激活, 因为此应用已经在运行!',
        'Unable to parse repository index document.' => '无法解析软件仓库索引文档',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '软件仓库中没有当前系统版本可用的软件包。',
        'No packages, or no new packages, found in selected repository.' =>
            '选中的软件仓库中没有需要安装的软件包。',
        'Edit the system configuration settings.' => '编辑系统配置。',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '数据库中的ACL信息与系统配置不一致，请部署所有ACL。',
        'printed at' => '打印日期',
        'Loading...' => '加载中...',
        'Dear Mr. %s,' => '尊敬的%s先生:',
        'Dear Mrs. %s,' => '尊敬的%s女士:',
        'Dear %s,' => '尊敬的%s:',
        'Hello %s,' => '您好, %s:',
        'This email address is not allowed to register. Please contact support staff.' =>
            '',
        'New account created. Sent login information to %s. Please check your email.' =>
            '帐户创建成功。登录信息发送到%s，请查收邮件。',
        'Please press Back and try again.' => '请返回再试一次。',
        'Sent password reset instructions. Please check your email.' => '密码初始化说明已发送，请检查邮件。',
        'Sent new password to %s. Please check your email.' => '新密码已发送到%s，请检查邮件。',
        'Upcoming Events' => '即将发生的事件',
        'Event' => '事件',
        'Events' => '事件',
        'Invalid Token!' => '无效的标记',
        'more' => '更多',
        'Collapse' => '收起',
        'Shown' => '显示',
        'Shown customer users' => '显示用户',
        'News' => '新闻',
        'Product News' => '产品新闻',
        'OTRS News' => 'OTRS新闻',
        '7 Day Stats' => '最近7天统计',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '数据库中的流程管理信息与系统配置不一致，请同步所有流程。',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '扩展包未经OTRS检验！不推荐使用该扩展包.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>如果安装这个扩展包，可能导致以下问题！<br><br>&nbsp;-安全问题<br>&nbsp;-稳定问题<br>&nbsp;-性能问题<br><br>由此导致的问题与OTRS服务合同无关！<br><br>',
        'Mark' => '标记',
        'Unmark' => '取消标记',
        'Bold' => '黑体',
        'Italic' => '斜体',
        'Underline' => '底线',
        'Font Color' => '字型颜色',
        'Background Color' => '背景色',
        'Remove Formatting' => '删除格式',
        'Show/Hide Hidden Elements' => '显示/隐藏 隐藏要素',
        'Align Left' => '左对齐',
        'Align Center' => '居中对齐',
        'Align Right' => '右对齐',
        'Justify' => '对齐',
        'Header' => '信息头',
        'Indent' => '缩进',
        'Outdent' => '凸排',
        'Create an Unordered List' => '创建一个无序列表',
        'Create an Ordered List' => '创建一个有序列表',
        'HTML Link' => 'HTML链接',
        'Insert Image' => '插入图像',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => '复原',
        'Redo' => '重做',
        'OTRS Daemon is not running.' => '',
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Problems processing server result. Please try again later.' => '',
        'Username and password do not match. Please try again.' => '用户名与密码不匹配：请重试。',
        'The selected process is invalid!' => '所选择的流程无效!',
        'Upgrade to %s now!' => '现在就更新到 %s',
        '%s Go to the upgrade center %s' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '有关 %s 的许可证已过期, 请与 %s 联络续约或购买服务合同! 谢谢',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '',
        'Your system was successfully upgraded to %s.' => '你的系统已成功更新到 %s',
        'There was a problem during the upgrade to %s.' => '',
        '%s was correctly reinstalled.' => '%s 已经成功重装。',
        'There was a problem reinstalling %s.' => '重装 %s 时遇到了一个问题。',
        'Your %s was successfully updated.' => '你的 %s 已经成功更新。',
        'There was a problem during the upgrade of %s.' => '升级 %s 时遇到了一个问题。',
        '%s was correctly uninstalled.' => '%s 已经成功卸载。',
        'There was a problem uninstalling %s.' => '卸载 %s 时遇到了一个问题。',

        # Template: AAACalendar
        'New Year\'s Day' => '新年',
        'International Workers\' Day' => '五一劳动节',
        'Christmas Eve' => '圣诞节前夕',
        'First Christmas Day' => '',
        'Second Christmas Day' => '',
        'New Year\'s Eve' => '',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS作为服务请求方',
        'OTRS as provider' => 'OTRS作为服务提供方',
        'Webservice "%s" created!' => 'Web服务"%s"已创建！',
        'Webservice "%s" updated!' => 'Web服务"%s"已更新！',

        # Template: AAAMonth
        'Jan' => '一月',
        'Feb' => '二月',
        'Mar' => '三月',
        'Apr' => '四月',
        'May' => '五月',
        'Jun' => '六月',
        'Jul' => '七月',
        'Aug' => '八月',
        'Sep' => '九月',
        'Oct' => '十月',
        'Nov' => '十一月',
        'Dec' => '十二月',
        'January' => '一月',
        'February' => '二月',
        'March' => '三月',
        'April' => '四月',
        'May_long' => '五月',
        'June' => '六月',
        'July' => '七月',
        'August' => '八月',
        'September' => '九月',
        'October' => '十月',
        'November' => '十一月',
        'December' => '十二月',

        # Template: AAAPreferences
        'Preferences updated successfully!' => '设置更新成功！',
        'User Profile' => '用户资料',
        'Email Settings' => '邮件设置',
        'Other Settings' => '其它设置',
        'Change Password' => '修改密码',
        'Current password' => '当前密码',
        'New password' => '新密码',
        'Verify password' => '重复新密码',
        'Spelling Dictionary' => '拼写检查字典',
        'Default spelling dictionary' => '默认字典',
        'Max. shown Tickets a page in Overview.' => '单页最大工单数。',
        'The current password is not correct. Please try again!' => '当前密码不正确，请重新输入！',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            '无法更改密码。新密码不一致，请重新输入！',
        'Can\'t update password, it contains invalid characters!' => '无法更改密码，密码不能包含非法字符！',
        'Can\'t update password, it must be at least %s characters long!' =>
            '无法更改密码，密码至少需要%s个字符！',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            '无法更改密码，密码必须包含至少2个小写和2个大写字符！',
        'Can\'t update password, it must contain at least 1 digit!' => '无法更改密码，密码至少需要1个数字字符！',
        'Can\'t update password, it must contain at least 2 characters!' =>
            '无法更改密码，密码至少需要2个字符！',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            '无法更改密码，该密码已被使用。请选择一个新密码！',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '选择CSV文件（统计和搜索）中使用的分隔符。如果不指定，系统将使用默认分隔符。',
        'CSV Separator' => 'CSV分隔符',

        # Template: AAATicket
        'Status View' => '状态视图',
        'Service View' => '服务视图',
        'Bulk' => '批量',
        'Lock' => '锁定',
        'Unlock' => '解锁',
        'History' => '历史',
        'Zoom' => '展开',
        'Age' => '总时长',
        'Bounce' => '退回',
        'Forward' => '转发',
        'From' => '发件人',
        'To' => '收件人',
        'Cc' => '抄送',
        'Bcc' => '暗送',
        'Subject' => '主题',
        'Move' => '转移',
        'Queue' => '队列',
        'Queues' => '队列',
        'Priority' => '优先级',
        'Priorities' => '优先级',
        'Priority Update' => '更新优先级',
        'Priority added!' => '优先级已添加!',
        'Priority updated!' => '优先级已更新!',
        'Signature added!' => '签名已添加!',
        'Signature updated!' => '签名已更新!',
        'SLA' => 'SLA',
        'Service Level Agreement' => '服务水平协议',
        'Service Level Agreements' => '服务水平协议',
        'Service' => '服务',
        'Services' => '服务',
        'State' => '状态',
        'States' => '状态',
        'Status' => '状态',
        'Statuses' => '状态',
        'Ticket Type' => '工单类型',
        'Ticket Types' => '工单类型',
        'Compose' => '撰写',
        'Pending' => '挂起',
        'Owner' => '所有者',
        'Owner Update' => '更改所有者',
        'Responsible' => '负责人',
        'Responsible Update' => '更新负责人',
        'Sender' => '发件人',
        'Article' => '信件',
        'Ticket' => '工单',
        'Createtime' => '创建时间',
        'plain' => '纯文本',
        'Email' => '邮件地址',
        'email' => 'E-Mail',
        'Close' => '关闭',
        'Action' => '操作',
        'Attachment' => '附件',
        'Attachments' => '附件',
        'This message was written in a character set other than your own.' =>
            '这封邮件所用字符集与您的系统字符集不符',
        'If it is not displayed correctly,' => '如果没有给正确地显示,',
        'This is a' => '这是一个',
        'to open it in a new window.' => '在新窗口中打开它',
        'This is a HTML email. Click here to show it.' => '这是一封HTML格式邮件，点击这里显示.',
        'Free Fields' => '自定义字段',
        'Merge' => '合并',
        'merged' => '已合并',
        'closed successful' => '成功关闭',
        'closed unsuccessful' => '失败关闭',
        'Locked Tickets Total' => '锁定工单总数',
        'Locked Tickets Reminder Reached' => '锁定工单(提醒时间已过)',
        'Locked Tickets New' => '锁定工单(未读信件)',
        'Responsible Tickets Total' => '负责工单总数',
        'Responsible Tickets New' => '负责的工单(未读信件)',
        'Responsible Tickets Reminder Reached' => '负责的工单(提醒时间已过)',
        'Watched Tickets Total' => '订阅工单总数',
        'Watched Tickets New' => '订阅工单(未读信件)',
        'Watched Tickets Reminder Reached' => '订阅工单(提醒时间已过)',
        'All tickets' => '所有工单',
        'Available tickets' => '未锁定的工单',
        'Escalation' => '升级',
        'last-search' => '上次搜索',
        'QueueView' => '队列视图',
        'Ticket Escalation View' => '工单升级视图',
        'Message from' => '消息来自',
        'End message' => '',
        'Forwarded message from' => '已转发的消息来自',
        'End forwarded message' => '',
        'Bounce Article to a different mail address' => '',
        'Reply to note' => '回复为备注',
        'new' => '新建',
        'open' => '处理中',
        'Open' => '处理中',
        'Open tickets' => '处理中的工单',
        'closed' => '已关闭',
        'Closed' => '已关闭',
        'Closed tickets' => '已关闭的工单',
        'removed' => '已删除',
        'pending reminder' => '挂起提醒',
        'pending auto' => '自动挂起',
        'pending auto close+' => '挂起自动关闭+',
        'pending auto close-' => '挂起自动关闭-',
        'email-external' => ' (邮件-外部)',
        'email-internal' => ' (邮件-内部)',
        'note-external' => ' (备注-外部)',
        'note-internal' => ' (备注-内部)',
        'note-report' => ' (备注-报告)',
        'phone' => ' (电话)',
        'sms' => ' (短信)',
        'webrequest' => ' (Web请求)',
        'lock' => '锁定',
        'unlock' => '未锁定',
        'very low' => '非常低',
        'low' => '低',
        'normal' => '正常',
        'high' => '高',
        'very high' => '非常高',
        '1 very low' => '1-非常低',
        '2 low' => '2-低',
        '3 normal' => '3-正常',
        '4 high' => '4-高',
        '5 very high' => '5-非常高',
        'auto follow up' => '自动跟进',
        'auto reject' => '自动拒绝',
        'auto remove' => '自动删除',
        'auto reply' => '自动回复',
        'auto reply/new ticket' => '自动回复新工单',
        'Create' => '创建',
        'Answer' => '回复',
        'Phone call' => '电话',
        'Ticket "%s" created!' => '工单："%s"已创建!',
        'Ticket Number' => '工单编号',
        'Ticket Object' => '工单对象',
        'No such Ticket Number "%s"! Can\'t link it!' => '编号为"%s"的工单不存在，不能链接!',
        'You don\'t have write access to this ticket.' => '你不具有此工单的写权限',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '只有工单的所有者才能执行此操作。',
        'Please change the owner first.' => '请先更改工单的所有者.',
        'Ticket selected.' => '工单已被选中.',
        'Ticket is locked by another agent.' => '工单被其它服务人员锁定了',
        'Ticket locked.' => '工单已锁定.',
        'Don\'t show closed Tickets' => '不显示已关闭的工单',
        'Show closed Tickets' => '显示已关闭的工单',
        'New Article' => '新信件',
        'Unread article(s) available' => '未读信件',
        'Remove from list of watched tickets' => '取消订阅此工单',
        'Add to list of watched tickets' => '订阅此工单',
        'Email-Ticket' => '邮件工单',
        'Create new Email Ticket' => '创建邮件工单',
        'Phone-Ticket' => '电话工单',
        'Search Tickets' => '搜索工单',
        'Customer Realname' => '',
        'Customer History' => '',
        'Edit Customer Users' => '编辑用户帐户',
        'Edit Customer' => '编辑用户单位',
        'Bulk Action' => '批量处理',
        'Bulk Actions on Tickets' => '批量处理工单',
        'Send Email and create a new Ticket' => '发送邮件并创建新工单',
        'Create new Email Ticket and send this out (Outbound)' => '创建邮件工单(主动)',
        'Create new Phone Ticket (Inbound)' => '创建电话工单(接电话)',
        'Address %s replaced with registered customer address.' => '%s地址已被用户注册的地址所替换',
        'Customer user automatically added in Cc.' => '用户被自动地添加到Cc中.',
        'Overview of all open Tickets' => '所有处理中的工单',
        'Locked Tickets' => '锁定的工单',
        'My Locked Tickets' => '我锁定的工单',
        'My Watched Tickets' => '我订阅的工单',
        'My Responsible Tickets' => '我负责的工单',
        'Watched Tickets' => '订阅的工单',
        'Watched' => '已订阅',
        'Watch' => '订阅',
        'Unwatch' => '取消订阅',
        'Lock it to work on it' => '锁定并处理工单',
        'Unlock to give it back to the queue' => '解锁并释放工单至队列',
        'Show the ticket history' => '显示工单历史信息',
        'Print this ticket' => '打印工单',
        'Print this article' => '打印信件',
        'Split' => '拆分',
        'Split this article' => '拆分信件',
        'Forward article via mail' => '通过邮件转发信件',
        'Change the ticket priority' => '更改工单优先级',
        'Change the ticket free fields!' => '修改自定义字段',
        'Link this ticket to other objects' => '将工单链接至其它对象',
        'Change the owner for this ticket' => '更改工单所有者',
        'Change the  customer for this ticket' => '更改工单用户',
        'Add a note to this ticket' => '添加工单备注',
        'Merge into a different ticket' => '合并至其它工单',
        'Set this ticket to pending' => '挂起工单',
        'Close this ticket' => '关闭工单',
        'Look into a ticket!' => '查看工单内容',
        'Delete this ticket' => '删除工单',
        'Mark as Spam!' => '标记为垃圾!',
        'My Queues' => '我的队列',
        'Shown Tickets' => '显示工单',
        'Shown Columns' => '显示字段',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            '您的单号为"<OTRS_TICKET>"的邮件工单 被合并到单号"<OTRS_MERGE_TO_TICKET>" !',
        'Ticket %s: first response time is over (%s)!' => '工单%s：第一响应时间已超过(%s)!',
        'Ticket %s: first response time will be over in %s!' => '工单%s: 第一响应时间将在(%s)内超时!',
        'Ticket %s: update time is over (%s)!' => '工单%s: 更新时间已超过(%s)!',
        'Ticket %s: update time will be over in %s!' => '工单%s: 更新时间将在(%s)内超时!',
        'Ticket %s: solution time is over (%s)!' => '工单%s: 解决时间已超过(%s)!',
        'Ticket %s: solution time will be over in %s!' => '解决时间将在(%s)内超时!',
        'There are more escalated tickets!' => '有更多升级的工单',
        'Plain Format' => '纯文本格式',
        'Reply All' => '回复所有',
        'Direction' => '方向',
        'New ticket notification' => '新工单通知',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            '如果我的队列中有新的工单，请通知我。',
        'Send new ticket notifications' => '发送新工单通知',
        'Ticket follow up notification' => '工单跟进通知',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '如果用户有回复且我是此工单的所有者或者此工单在我的队列中，请通知我。',
        'Send ticket follow up notifications' => '发送工单跟进通知',
        'Ticket lock timeout notification' => '工单锁定超时通知',
        'Send me a notification if a ticket is unlocked by the system.' =>
            '如果工单被系统解锁，请通知我。',
        'Send ticket lock timeout notifications' => '发送工单锁定超时间通知',
        'Ticket move notification' => '工单转移通知',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            '如果工单转移至我的队列，请通知我。',
        'Send ticket move notifications' => '发送工单队列转移通知',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => '用户队列',
        'QueueView refresh time' => '队列视图刷新频率',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            '如果启用此功能, 队列视图会自动在指定时间内自动刷新.',
        'Refresh QueueView after' => '队列视图多久后刷新',
        'Screen after new ticket' => '创建新工单后的视图',
        'Show this screen after I created a new ticket' => '创建新工单后的显示页面',
        'Closed Tickets' => '关闭的工单',
        'Show closed tickets.' => '显示已关闭工单',
        'Max. shown Tickets a page in QueueView.' => '队列视图每页最大显示数',
        'Ticket Overview "Small" Limit' => '工单概览“小”模式限制',
        'Ticket limit per page for Ticket Overview "Small"' => '工单概览“小”模式每页数量',
        'Ticket Overview "Medium" Limit' => '工单概览“中”模式限制',
        'Ticket limit per page for Ticket Overview "Medium"' => '工单概览“中”模式每页数量',
        'Ticket Overview "Preview" Limit' => '工单概览“预览”模式限制',
        'Ticket limit per page for Ticket Overview "Preview"' => '工单概览“预览”模式每页数量',
        'Ticket watch notification' => '工单订阅通知',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            '对于我所订阅的工单，请给我发送与工单所有者一样通知.',
        'Send ticket watch notifications' => '发送工单订阅通知',
        'Out Of Office Time' => '不在办公室的时间',
        'New Ticket' => '新的工单',
        'Create new Ticket' => '创建工单',
        'Customer called' => '用户致电',
        'phone call' => '电话呼叫',
        'Phone Call Outbound' => '打电话',
        'Phone Call Inbound' => '接电话',
        'Reminder Reached' => '提醒时间已过',
        'Reminder Tickets' => '提醒的工单',
        'Escalated Tickets' => '升级的工单',
        'New Tickets' => '新的工单',
        'Open Tickets / Need to be answered' => '正在处理/需要回复的工单',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            '所有正在处理中且需要回复的工单',
        'All new tickets, these tickets have not been worked on yet' => '所有新建工单，这些工单目前还没有被处理',
        'All escalated tickets' => '所有升级的工单',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '所有提醒时间已过的工单',
        'Archived tickets' => '归档的工单',
        'Unarchived tickets' => '未归档的工单',
        'Ticket Information' => '工单信息',
        'including subqueues' => '',
        'excluding subqueues' => '',

        # Template: AAAWeekDay
        'Sun' => '日',
        'Mon' => '一',
        'Tue' => '二',
        'Wed' => '三',
        'Thu' => '四',
        'Fri' => '五',
        'Sat' => '六',

        # Template: AdminACL
        'ACL Management' => 'ACL管理',
        'Filter for ACLs' => '过滤ACL',
        'Filter' => '过滤器',
        'ACL Name' => 'ACL名称',
        'Actions' => '操作',
        'Create New ACL' => '创建ACL',
        'Deploy ACLs' => '部署ACL',
        'Export ACLs' => '导出ACL',
        'Configuration import' => '导入ACL',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '你可以上传配置文件，以便将ACL导入至系统中。配置文件采用.yml格式，它可以从ACL管理模块中导出。',
        'This field is required.' => '该字段是必须的。',
        'Overwrite existing ACLs?' => '覆盖ACL',
        'Upload ACL configuration' => '上传ACL配置',
        'Import ACL configuration(s)' => '导入ACL配置',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '为了创建ACL，你可以导入ACL配置或从头创建一个全新的ACL。',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '在这里的任何ACL的修改，仅将其保存在系统中。只有在部署ACL后，它才会起作用。',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '注意：列表中的ACL名称排序顺序决定了ACL的执行顺序。如果需要更改ACL的执行顺序，请修改相应的ACL名称。',
        'ACL name' => 'ACL名称',
        'Validity' => '有效性',
        'Copy' => '复制',
        'No data found.' => '没有找到数据。',

        # Template: AdminACLEdit
        'Edit ACL %s' => '编辑ACL %s',
        'Go to overview' => '返回概览',
        'Delete ACL' => '删除ACL',
        'Delete Invalid ACL' => '删除无效的ACL',
        'Match settings' => '匹配条件',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '为ACL设置匹配条件。\'Properties\'用于匹配工单在内存中的属性\'，而\'PropertiesDatabase\'用于匹配工单在数据库中的属性。',
        'Change settings' => '操作动作',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '当匹配条件满足时执行规定的操作动作。记住：\'Possible\'表示允许(白名单)，\'PossibleNot\'表示禁止(黑名单)。',
        'Check the official' => '查看官方',
        'documentation' => '手册',
        'Show or hide the content' => '显示或隐藏内容',
        'Edit ACL information' => '编辑ACL信息',
        'Stop after match' => '匹配后停止',
        'Edit ACL structure' => '编辑ACL结构',
        'Save' => '保存',
        'or' => '或',
        'Save and finish' => '保存并完成',
        'Do you really want to delete this ACL?' => '你确定要删除这个ACL吗？',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '该条目中包含子条目。你确定要删除这个条目及其子条目吗？',
        'An item with this name is already present.' => '名称相同的条目已存在。',
        'Add all' => '添加所有',
        'There was an error reading the ACL data.' => '读取ACL数据时发现一个错误。',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '通过填写表数据实现ACL控制。创建ACL后，就可在编辑模式中添加ACL配置信息。',

        # Template: AdminAttachment
        'Attachment Management' => '附件管理',
        'Add attachment' => '添加附件',
        'List' => '列表',
        'Download file' => '下载文件',
        'Delete this attachment' => '删除附件',
        'Add Attachment' => '添加附件',
        'Edit Attachment' => '编辑附件',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自动回复管理',
        'Add auto response' => '添加自动回复',
        'Add Auto Response' => '添加自动回复',
        'Edit Auto Response' => '编辑自动回复',
        'Response' => '回复内容',
        'Auto response from' => '自动回复的发件人',
        'Reference' => '相关参考',
        'You can use the following tags' => '你可以使用以下的标记',
        'To get the first 20 character of the subject.' => '显示主题的前20个字节',
        'To get the first 5 lines of the email.' => '显示邮件的前五行',
        'To get the realname of the sender (if given).' => '显示发件人的真实姓名',
        'To get the article attribute' => '信件数据属性',
        ' e. g.' => '例如',
        'Options of the current customer user data' => '用户资料属性',
        'Ticket owner options' => '工单所有者属性',
        'Ticket responsible options' => '工单负责人属性',
        'Options of the current user who requested this action' => '工单提交者的属性',
        'Options of the ticket data' => '工单数据属性',
        'Options of ticket dynamic fields internal key values' => '工单动态字段内部键值',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '动态字段显示名称，用于下拉选择和复选框',
        'Config options' => '系统配置数据',
        'Example response' => '这里有一个范例',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '',
        'Support Data Collector' => '',
        'Support data collector' => '',
        'Hint' => '提示',
        'Currently support data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '',
        'Configuration' => '配置',
        'Send support data' => '',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '',
        'System Registration' => '系统注册',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => '',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '系统注册是OTRS集团的一项服务，它为您提供了很多好处!',
        'Please note that you using OTRS cloud services requires the system to be registered.' =>
            '',
        'Register this system' => '',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '',
        'Upgrade to %s' => '升级到 %s',

        # Template: AdminCustomerCompany
        'Customer Management' => '用户单位管理',
        'Wildcards like \'*\' are allowed.' => '允许使用通配置符，例如\'*\'。',
        'Add customer' => '添加用户单位',
        'Select' => '选择',
        'Please enter a search term to look for customers.' => '请输入搜索条件以便检索用户单位资料.',
        'Add Customer' => '添加用户单位',

        # Template: AdminCustomerUser
        'Customer User Management' => '用户管理',
        'Back to search results' => '返回至搜索结果',
        'Add customer user' => '添加用户',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '用户资料用于记录工单历史并允许用户访问服务台门户网站。',
        'Last Login' => '上次登录时间',
        'Login as' => '登陆用户门户',
        'Switch to customer' => '切换至用户',
        'Add Customer User' => '添加用户',
        'Edit Customer User' => '编辑用户',
        'This field is required and needs to be a valid email address.' =>
            '必须输入有效的邮件地址。',
        'This email address is not allowed due to the system configuration.' =>
            '邮件地址不符合系统配置要求。',
        'This email address failed MX check.' => '该邮件域名的MX记录检查无效。',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS问题，请检查你的配置和错误日志文件。',
        'The syntax of this email address is incorrect.' => '该邮件地址语法错误。',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => '管理用户与组的归属关系',
        'Notice' => '注意',
        'This feature is disabled!' => '该功能已关闭',
        'Just use this feature if you want to define group permissions for customers.' =>
            '该功能用于为用户定义权限组。',
        'Enable it here!' => '打开该功能',
        'Edit Customer Default Groups' => '定义用户的默认组',
        'These groups are automatically assigned to all customers.' => '默认组会自动指派给所有用户。',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '你可能通过配置参数"CustomerGroupAlwaysGroups"定义默认组。',
        'Filter for Groups' => '过滤组',
        'Just start typing to filter...' => '',
        'Select the customer:group permissions.' => '选择用户:组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '如果没有选择，就不具备该组的任何权限 (用户不能创建或读取工单)。',
        'Search Results' => '搜索结果',
        'Customers' => '用户单位',
        'No matches found.' => '没有找到相匹配的.',
        'Groups' => '组',
        'Change Group Relations for Customer' => '此用户属于哪些组',
        'Change Customer Relations for Group' => '哪些用户属于此组',
        'Toggle %s Permission for all' => '切换%s权限给全部',
        'Toggle %s permission for %s' => '切换%s权限给%s',
        'Customer Default Groups:' => '用户的默认组:',
        'No changes can be made to these groups.' => '不能更改默认组.',
        'ro' => '',
        'Read only access to the ticket in this group/queue.' => '对于组/队列中的工单具有 \'读\' 的权限',
        'rw' => '',
        'Full read and write access to the tickets in this group/queue.' =>
            '对于组/队列中的工单具有 \'读和写\' 的权限',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => '管理用户与服务之间的关系',
        'Edit default services' => '修改默认服务',
        'Filter for Services' => '过滤服务',
        'Allocate Services to Customer' => '为此用户选择服务',
        'Allocate Customers to Service' => '选择使用此服务的用户',
        'Toggle active state for all' => '切换激活状态给全部',
        'Active' => '激活',
        'Toggle active state for %s' => '切换激活状态给%s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '动态字段管理',
        'Add new field for object' => '为对象添加新的字段',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '动态字段列表',
        'Dynamic fields per page' => '每页动态字段个数',
        'Label' => '标记',
        'Order' => '顺序',
        'Object' => '对象',
        'Delete this field' => '删除这个字段',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '你确定要删除这个动态字段吗? 所有关联的数据将丢失!',
        'Delete field' => '删除字段',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '动态字段',
        'Field' => '字段',
        'Go back to overview' => '返回概况',
        'General' => '常规',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '这个字段是必需的，且它的值只能是字母和数字。',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '必须是唯一的且只有接受字母和数字字符',
        'Changing this value will require manual changes in the system.' =>
            '只能对数据库中直接操作才能修改这个值',
        'This is the name to be shown on the screens where the field is active.' =>
            '标记值作为字段名称显示在屏幕上',
        'Field order' => '字段顺序',
        'This field is required and must be numeric.' => '这个字段是必需的且必须是数字',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '决定动态字段在屏幕上的显示顺序',
        'Field type' => '字段类型',
        'Object type' => '对象类型',
        'Internal field' => '内置字段',
        'This field is protected and can\'t be deleted.' => '这是内置字段，不能删除它。',
        'Field Settings' => '字段设置',
        'Default value' => '默认值',
        'This is the default value for this field.' => '此值是字段的默认值',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '默认的日期差',
        'This field must be numeric.' => '字段值必须是数字字符',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '用“此刻”的时差(秒)计算默认值(例如，3600或-60)',
        'Define years period' => '定义年期',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '激活此选项来定义固定的年份范围(过去的和未来的), 用于显示在此字段的年份中.',
        'Years in the past' => '过去的几年',
        'Years in the past to display (default: 5 years).' => '显示过去的几年 (默认: 5年)',
        'Years in the future' => '未来的几年',
        'Years in the future to display (default: 5 years).' => '显示未来的几年 (默认: 5年)',
        'Show link' => '显示链接',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '可以为字段值指定一个可选的HTTP链接，以便其显示在工单概况和工单详情中。',
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '可选值',
        'Key' => '键',
        'Value' => '值',
        'Remove value' => '删除值',
        'Add value' => '添加值',
        'Add Value' => '添加值',
        'Add empty value' => '添加空值',
        'Activate this option to create an empty selectable value.' => '激活此选项, 创建可选择的空值.',
        'Tree View' => '树状视图',
        'Activate this option to display values as a tree.' => '激活此项，将以树状形式显示值',
        'Translatable values' => '可翻译的值',
        'If you activate this option the values will be translated to the user defined language.' =>
            '激活此项，将用自定义的语言翻译字段值',
        'Note' => '备注',
        'You need to add the translations manually into the language translation files.' =>
            '需要你手工将翻译内容添加到翻译文件中',

        # Template: AdminDynamicFieldText
        'Number of rows' => '行数',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '定义编辑窗口的行数',
        'Number of cols' => '列宽',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '定义编辑窗口的列宽',
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => '出错信息',
        'Add RegEx' => '',

        # Template: AdminEmail
        'Admin Notification' => '管理员通知',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '通过此模块，管理员可以按组和角色给服务人员和用户发送消息。',
        'Create Administrative Message' => '创建管理员通知',
        'Your message was sent to' => '你的信息已被发送到',
        'Send message to users' => '发送信息给注册用户',
        'Send message to group members' => '发送信息到组成员',
        'Group members need to have permission' => '组成员需要权限',
        'Send message to role members' => '发送信息到角色成员',
        'Also send to customers in groups' => '同样发送到该组的用户',
        'Body' => '内容',
        'Send' => '发送',

        # Template: AdminGenericAgent
        'Generic Agent' => '计划任务',
        'Add job' => '添加任务',
        'Last run' => '最后运行',
        'Run Now!' => '现在运行!',
        'Delete this task' => '删除这个任务',
        'Run this task' => '执行这个任务',
        'Job Settings' => '任务设置',
        'Job name' => '任务名称',
        'The name you entered already exists.' => '你输入的名称已经存在。',
        'Toggle this widget' => '收起/展开Widget',
        'Automatic execution (multiple tickets)' => '自动执行(针对多个工单)',
        'Execution Schedule' => '按计划执行',
        'Schedule minutes' => '分',
        'Schedule hours' => '时',
        'Schedule days' => '日',
        'Currently this generic agent job will not run automatically.' =>
            '目前该计划任务不会自动运行',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '若要启用自动执行，则需选择分钟，时间或天',
        'Event based execution (single ticket)' => '基于事件执行(针对特定工单)',
        'Event Triggers' => '事件触发器',
        'List of all configured events' => '配置的事件列表',
        'Delete this event' => '删除这个事件',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '此外，为了让此任务定期反复地执行，您需要定义工单事件，以便触发任务的执行。',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '如果工单事件被触发，工单过滤器将对工单进行检查看其条件是否匹配。任务只对匹配的工单发生作用。',
        'Do you really want to delete this event trigger?' => '你确定要删除这个事件触发器吗？',
        'Add Event Trigger' => '添加事件触发器',
        'Add Event' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '选择事件对象和事件名称，然的点击"+"按钮，即可添加新的事件。',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => '删除这个事件触发器',
        'Remove selection' => '',
        'Select Tickets' => '',
        '(e. g. 10*5155 or 105658*)' => '  例如: 10*5144 或者 105658*',
        '(e. g. 234321)' => '例如: 234321',
        'Customer login' => '用户登录',
        '(e. g. U5150)' => '例如: U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '在信件中全文检索（例如："Mar*in" or "Baue*"）',
        'Agent' => '服务人员',
        'Ticket lock' => '工单锁定',
        'Create times' => '创建时间',
        'No create time settings.' => '没有创建时间。',
        'Ticket created' => '工单创建时间(相对)',
        'Ticket created between' => '工单创建时间(绝对)',
        'Last changed times' => '',
        'No last changed time settings.' => '',
        'Ticket last changed' => '工单最后修改',
        'Ticket last changed between' => '',
        'Change times' => '修改时间',
        'No change time settings.' => '没有修改时间',
        'Ticket changed' => '修改工单时间(相对)',
        'Ticket changed between' => '工单修改时间(绝对)',
        'Close times' => '关闭时间',
        'No close time settings.' => '没有关闭时间',
        'Ticket closed' => '工单关闭时间(相对)',
        'Ticket closed between' => '工单关闭时间(绝对)',
        'Pending times' => '挂起时间',
        'No pending time settings.' => '没有挂起时间',
        'Ticket pending time reached' => '工单挂起时间(相对)',
        'Ticket pending time reached between' => '工单挂起时间(绝对)',
        'Escalation times' => '升级时间',
        'No escalation time settings.' => '没有升级时间',
        'Ticket escalation time reached' => '工单升级时间(相对)',
        'Ticket escalation time reached between' => '工单升级时间(绝对)',
        'Escalation - first response time' => '升级 - 第一响应时间',
        'Ticket first response time reached' => '工单升级 - 第一响应时间(相对)',
        'Ticket first response time reached between' => '工单升级 - 第一响应时间(绝对)',
        'Escalation - update time' => '升级 - 更新时间',
        'Ticket update time reached' => '工单升级 - 更新时间(相对)',
        'Ticket update time reached between' => '工单升级 - 更新时间(绝对)',
        'Escalation - solution time' => '升级 - 解决时间',
        'Ticket solution time reached' => '工单升级 - 解决时间(相对)',
        'Ticket solution time reached between' => '工单升级 - 解决时间(绝对)',
        'Archive search option' => '归档查询选项',
        'Update/Add Ticket Attributes' => '',
        'Set new service' => '设置新服务',
        'Set new Service Level Agreement' => '指定服务水平协议',
        'Set new priority' => '指定优先级',
        'Set new queue' => '指定队列',
        'Set new state' => '指定状态',
        'Pending date' => '挂起时间',
        'Set new agent' => '指定服务人员',
        'new owner' => '指定所有者',
        'new responsible' => '指定负责人',
        'Set new ticket lock' => '工单锁定',
        'New customer' => '指定用户',
        'New customer ID' => '指定用户ID',
        'New title' => '指定称谓',
        'New type' => '指定类型',
        'New Dynamic Field Values' => '新的动态字段值',
        'Archive selected tickets' => '归档选中的工单',
        'Add Note' => '添加备注',
        'Time units' => '时间',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => '给服务人员/用户发送通知',
        'CMD' => '命令',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            '将执行这个命令, 第一个参数是工单 编号，第二个参数是工单的标识符.',
        'Delete tickets' => '删除工单',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '警告：所有影响的工单从数据库删除，将无法恢复！',
        'Execute Custom Module' => '执行客户化模块',
        'Param %s key' => '参数 %s key',
        'Param %s value' => '参数 %s value',
        'Save Changes' => '保存更改',
        'Results' => '结果',
        '%s Tickets affected! What do you want to do?' => '%s 个工单将被影响！你确定要这么做?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告：你选择了"删除"指令。所有删除的工单数据将无法恢复。',
        'Edit job' => '编辑任务',
        'Run job' => '执行任务',
        'Affected Tickets' => '受影响的工单',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Web服务%s的通用接口调试器',
        'You are here' => '',
        'Web Services' => 'Web服务',
        'Debugger' => '调试器',
        'Go back to web service' => '返回到Web服务',
        'Clear' => '删除',
        'Do you really want to clear the debug log of this web service?' =>
            '你确定要删除该Web服务的调试日志吗？',
        'Request List' => '请求列表',
        'Time' => '时间',
        'Remote IP' => '远程IP',
        'Loading' => '装载',
        'Select a single request to see its details.' => '选择一个请求，以便查看其详细信息。',
        'Filter by type' => '按类型过滤',
        'Filter from' => '按日期过滤(从)',
        'Filter to' => '按日期过滤(至)',
        'Filter by remote IP' => '按远程IP过滤',
        'Limit' => '限制',
        'Refresh' => '刷新',
        'Request Details' => '请求详细信息',
        'An error occurred during communication.' => '在通讯时发生一个错误。',
        'Show or hide the content.' => '显示或隐藏该内容.',
        'Clear debug log' => '删除调试日志',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '为Web服务%s添加新的调用程序',
        'Change Invoker %s of Web Service %s' => '修改调用程序%s(Web服务%s)',
        'Add new invoker' => '添加新的调用程序',
        'Change invoker %s' => '修改调用程序%s',
        'Do you really want to delete this invoker?' => '你确定要删除这个调用程序吗？',
        'All configuration data will be lost.' => '所有配置数据将丢失。',
        'Invoker Details' => '调用程序详情',
        'The name is typically used to call up an operation of a remote web service.' =>
            '这个名字通常用于调用远程web服务的一个操作',
        'Please provide a unique name for this web service invoker.' => '请为这个Web服务调用程序提供一个唯一的名称。',
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
        'Asynchronous' => '异步的',
        'This invoker will be triggered by the configured events.' => '配置事件将触发这个调用程序。',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '同步事件触发则是在web请求期间直接处理的。',
        'Save and continue' => '保存并继续',
        'Delete this Invoker' => '删除这个调用程序',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Web服务%s的通用接口映射简单',
        'Go back to' => '返回到',
        'Mapping Simple' => '映射简单',
        'Default rule for unmapped keys' => '未映射键的默认规则',
        'This rule will apply for all keys with no mapping rule.' => '这个规则将应用于所有没有映射规则的键。',
        'Default rule for unmapped values' => '未映射值的默认规则',
        'This rule will apply for all values with no mapping rule.' => '这个规则将应用于所有没有映射规则的值。',
        'New key map' => '新的键映射',
        'Add key mapping' => '添加键映射',
        'Mapping for Key ' => '',
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
        'Do you really want to delete this key mapping?' => '你确定要删除这个键映射吗？',
        'Delete this Key Mapping' => '删除这个键映射',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => '',
        'Mapping XML' => '',
        'Template' => '模板',
        'The entered data is not a valid XSLT stylesheet.' => '',
        'Insert XSLT stylesheet.' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '为Web服务%s添加新的操作',
        'Change Operation %s of Web Service %s' => '修改操作%s(Web服务%s)',
        'Add new operation' => '添加新的操作',
        'Change operation %s' => '修改操作%s',
        'Do you really want to delete this operation?' => '你确定要删除这个操作吗？',
        'Operation Details' => '操作详情',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '这个名称通常用于从一个远程系统调用这个web服务操作。',
        'Please provide a unique name for this web service.' => '请为这个Web服务提供一个唯一的名称。',
        'Mapping for incoming request data' => '映射传入请求数据',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '这个映射将对请求数据进行处理，将它转换为OTRS所期待的数据。',
        'Operation backend' => '操作后端',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '这个OTRS操作后端模块将被调用，以便处理请求、为响应生成数据。',
        'Mapping for outgoing response data' => '映射出站响应数据',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '这个映射将对响应数据进行处理，以便将它转换成远程系统所期待的数据。',
        'Delete this Operation' => '删除这个操作',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => '',
        'Network transport' => '网络传输',
        'Properties' => '属性',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => '消息的最大长度',
        'This field should be an integer number.' => '这个字段值应该是一个整数。',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => '',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Host' => '主机',
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
        'Authentication' => '验证',
        'The authentication mechanism to access the remote system.' => '访问远程系统的认证机制。',
        'A "-" value means no authentication.' => '"-"意味着没有认证。',
        'The user name to be used to access the remote system.' => '用于访问远程系统的用户名。',
        'The password for the privileged user.' => '特权用户的密码。',
        'Use SSL Options' => '启用SSL选项',
        'Show or hide SSL options to connect to the remote system.' => '显示或隐藏用来连接远程系统SSL选项。',
        'Certificate File' => '证书文件',
        'The full path and name of the SSL certificate file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => '',
        'Certificate Password File' => '证书密码文件',
        'The full path and name of the SSL key file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => '',
        'Certification Authority (CA) File' => '认证机构(CA)文件',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Web服务%s的通用接口传输HTTP::SOAP',
        'Endpoint' => '端点',
        'URI to indicate a specific location for accessing a service.' =>
            'URI用来表示访问服务的一个特定的位置。',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '命名空间',
        'URI to give SOAP methods a context, reducing ambiguities.' => '为SOAP方法指定URI(通用资源标识符), 以便消除二义性。',
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
            '在这里你可以指定OTRS能够处理的SOAP消息的最大长度(以字节为单位)。',
        'Encoding' => '编码',
        'The character encoding for the SOAP message contents.' => 'SOAP消息内容的字符编码',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => 'SOAP动作',
        'Set to "Yes" to send a filled SOAPAction header.' => '设置"Yes"时，发送填写了的SOAP动作头。',
        'Set to "No" to send an empty SOAPAction header.' => '设置"No"时，发送空白的SOAP动作头。',
        'SOAPAction separator' => 'SOAP动作分隔符',
        'Character to use as separator between name space and SOAP method.' =>
            '作为名称空间和SOAP方法分隔符的字符。',
        'Usually .Net web services uses a "/" as separator.' => '通常.Net的Web服务使用"/"作为分隔符。',
        'Proxy Server' => '代理服务器',
        'URI of a proxy server to be used (if needed).' => '代理服务器的URI(如果使用代理)。',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '代理用户',
        'The user name to be used to access the proxy server.' => '访问代理服务器的用户名。',
        'Proxy Password' => '代理密码',
        'The password for the proxy user.' => '代理用户的密码。',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'SSL证书文件的完整路径和名称(必须采用p12格式)。',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'The password to open the SSL certificate.' => '访问SSL证书的密码',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '用来验证SSL证书的认证机构证书文件的完整路径和名称。',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '认证机构(CA)目录',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '认证机构目录的完整路径，文件系统中存储CA证书存储地方。',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Sort options' => '',
        'Add new first level element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '通用接口Web服务管理',
        'Add web service' => '添加Web服务',
        'Clone web service' => '克隆Web服务',
        'The name must be unique.' => '名称必须是唯一的。',
        'Clone' => '克隆',
        'Export web service' => '导出Web服务',
        'Import web service' => '导入Web服务',
        'Configuration File' => '配置文件',
        'The file must be a valid web service configuration YAML file.' =>
            '必须是有效的Web服务配置文件(yaml格式)。',
        'Import' => '导入',
        'Configuration history' => '配置历史',
        'Delete web service' => '删除Web服务',
        'Do you really want to delete this web service?' => '你确定要删除这个Web服务吗？',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '保存配置文件后，页面将再次转至编辑页面。',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '如果你想返回到概况，请点击"返回概况"按钮。',
        'Web Service List' => 'Web服务列表',
        'Remote system' => '远程系统',
        'Provider transport' => '服务提供方传输',
        'Requester transport' => '服务请求方传输',
        'Debug threshold' => '调试阀值',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '在提供方模式中，OTRS为远程系统提供Web服务。',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '在请求方模式中，OTRS使用远程系统的Web服务。',
        'Operations are individual system functions which remote systems can request.' =>
            '操作是各种不同的系统功能，可供远程系统请求调用。',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '调用程序为请求远程Web服务准备数据，并其响应的数据进行处理。',
        'Controller' => '控制器',
        'Inbound mapping' => '入站映射',
        'Outbound mapping' => '出站映射',
        'Delete this action' => '删除这个动作',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '至少有一个%s的控制器未被激活或根本就不存在，请检查控制器注册或删除这个%s',
        'Delete webservice' => '删除Web服务',
        'Delete operation' => '删除操作',
        'Delete invoker' => '删除调用程序',
        'Clone webservice' => '克隆Web服务',
        'Import webservice' => '导入Web服务',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Web服务%s通用接口配置历史',
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
            '你确定要恢复Web服务配置的这个版本吗？',
        'Your current web service configuration will be overwritten.' => '当前的Web服务配置将被覆盖',
        'Restore' => '恢复',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '警告：当您更改\'管理\'组的名称时，在SysConfig作出相应的变化之前，你将被管理面板锁住！如果发生这种情况，请用SQL语句把组名改回到\'admin\'',
        'Group Management' => '组管理',
        'Add group' => '添加组',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'admin组允许使用系统管理模块，stats组允许使用统计模块。',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '若要为不同的服务人员分配不同的访问权限，应创建新的组。(例如，采购部、支持部、销售部、...)',
        'It\'s useful for ASP solutions. ' => '这对于ASP解决方案它很有用。',
        'Add Group' => '添加组',
        'Edit Group' => '编辑组',

        # Template: AdminLog
        'System Log' => '系统日志',
        'Here you will find log information about your system.' => '查看系统日志信息。',
        'Hide this message' => '隐藏此消息',
        'Recent Log Entries' => '最近的日志',

        # Template: AdminMailAccount
        'Mail Account Management' => '管理邮件接收地址',
        'Add mail account' => '添加邮件接收地址',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            '接收到的邮件将被分派到邮件接收地址所指定的队列中!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            '如果邮件接收地址被设置为"信任"，OTRS将对邮件信头中现有的X-OTRS标记执行相应的处理操作 (例如，设置工单优先级)！而PostMaster Filter总是要执行的，与邮件接收地址是否被设置为"信认"无关。',
        'Delete account' => '删除帐号',
        'Fetch mail' => '查收邮件',
        'Add Mail Account' => '添加邮件帐号',
        'Example: mail.example.com' => '范例：mail.example.com',
        'IMAP Folder' => 'IMAP文件夹',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '仅当你打算从其它文件夹(非INBOX)读取邮件时，才有必要修改此项.',
        'Trusted' => '是否信任',
        'Dispatching' => '分派',
        'Edit Mail Account' => '编辑邮件接收地址',

        # Template: AdminNavigationBar
        'Admin' => '系统管理',
        'Agent Management' => '服务人员管理',
        'Queue Settings' => '队列设置',
        'Ticket Settings' => '工单设置',
        'System Administration' => '系统管理员',
        'Online Admin Manual' => '管理员在线手册',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '',
        'Add notification' => '添加通知',
        'Export Notifications' => '',
        'Configuration Import' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Overwrite existing notifications?' => '',
        'Upload Notification configuration' => '',
        'Import Notification configuration' => '',
        'Delete this notification' => '删除通知',
        'Do you really want to delete this notification?' => '',
        'Add Notification' => '添加通知',
        'Edit Notification' => '编辑通知',
        'Show in agent preferences' => '',
        'Agent preferences tooltip' => '',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => '工单过滤',
        'Article Filter' => '信件过滤器',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => '信件类型',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => '',
        'Subject match' => '主题匹配',
        'Body match' => '内容匹配',
        'Include attachments to notification' => '通知包含附件',
        'Recipients' => '接收人',
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
        'Notifications are sent to an agent or a customer.' => '发送给服务人员或用户的通知。',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '截取主题的前20个字符（最新的服务人员信件）',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '截取邮件正文内容前5行（最新的服务人员信件）',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '截取邮件主题的前20个字符（最新的用户信件）',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '截取邮件正文内容前5行（最新的用户信件）',

        # Template: AdminNotificationEventTransportEmailSettings
        'Recipient email addresses' => '收件人(邮件地址)',
        'Notification article type' => '信件类型',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '',
        'Downgrade to OTRS Free' => '降级到社区版本',
        'Read documentation' => '',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => '',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '该系统所使用的 %s 许可证无效, 请与 %s 联络续约或购买服务合同! 谢谢',
        '%s not Correctly Installed' => '',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '',
        'Reinstall %s' => '重新安装 %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => '更新 %s',
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
        'Go to OTRS Package Manager' => '进入 OTRS 软件包管理',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => '提供者',
        'Please uninstall the packages first using the package manager and try again.' =>
            '',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '对话',
        'Timeline view in ticket zoom' => '以时间轴视图展开工单',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => '',

        # Template: AdminPGP
        'PGP Management' => 'PGP管理',
        'Use this feature if you want to work with PGP keys.' => '该功能用于管理PGP密钥',
        'Add PGP key' => '添加PGP密钥',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            '通过此模块可以直接编辑在SysConfig中配置的密钥环。',
        'Introduction to PGP' => 'PGP介绍',
        'Result' => '结果',
        'Identifier' => '标识符',
        'Bit' => '位',
        'Fingerprint' => '指纹',
        'Expires' => '过期',
        'Delete this key' => '删除密钥',
        'Add PGP Key' => '添加PGP密钥',
        'PGP key' => 'PGP密钥',

        # Template: AdminPackageManager
        'Package Manager' => '软件包管理',
        'Uninstall package' => '卸载软件包',
        'Do you really want to uninstall this package?' => '是否确认卸载该软件包?',
        'Reinstall package' => '重新安装软件包',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '你确定要重新安装该软包吗? 所有该模块的手工设置将丢失.',
        'Continue' => '继续',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '请确认你的数据库能够接收大于%sMB的数据包（目前能够接收的最大数据包为%sMB）。为了避免程序报错，请调整数据库max_allowed_packet参数。',
        'Install' => '安装',
        'Install Package' => '安装软件包',
        'Update repository information' => '更新软件仓库信息',
        'Online Repository' => '在线软件仓库',
        'Module documentation' => '模块文档',
        'Upgrade' => '升级',
        'Local Repository' => '本地软件仓库',
        'This package is verified by OTRSverify (tm)' => '此软件包已通过OTRSverify(tm)的验证',
        'Uninstall' => '卸载',
        'Reinstall' => '重新安装',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Download package' => '下载该软件包',
        'Rebuild package' => '重新编译',
        'Metadata' => '元数据',
        'Change Log' => '更新记录',
        'Date' => '日期',
        'List of Files' => '文件清单',
        'Permission' => '权限',
        'Download' => '下载',
        'Download file from package!' => '从软件包中下载这个文件',
        'Required' => '必需的',
        'PrimaryKey' => '关键的Key',
        'AutoIncrement' => '自动递增',
        'SQL' => 'SQL',
        'File differences for file %s' => '文件跟%s有差异',

        # Template: AdminPerformanceLog
        'Performance Log' => '性能日志',
        'This feature is enabled!' => '该功能已启用',
        'Just use this feature if you want to log each request.' => '如果想详细记录每个请求, 您可以使用该功能.',
        'Activating this feature might affect your system performance!' =>
            '启动该功能可能影响您的系统性能',
        'Disable it here!' => '关闭该功能',
        'Logfile too large!' => '日志文件过大',
        'The logfile is too large, you need to reset it' => '日志文件太大，请重新初始化。',
        'Overview' => '概况',
        'Range' => '范围',
        'last' => '最后',
        'Interface' => '界面',
        'Requests' => '请求',
        'Min Response' => '最快回应',
        'Max Response' => '最慢回应',
        'Average Response' => '平均回应',
        'Period' => '时长',
        'Min' => '最小',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '邮件过滤器管理',
        'Add filter' => '添加过滤器',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '基于邮件头标记的分派或过滤。可以使用正则表达式进行匹配。',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '如果你只想匹配某个邮件地址，可以在From、To或Cc中使用EMAILADDRESS:info@example.com这样的邮件格式。',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '如果你使用了正则表达式，你可以取出()中匹配的值，再将它写入OTRS标记中(需采用[***]这种格式。)',
        'Delete this filter' => '删除此过滤器',
        'Add PostMaster Filter' => '添加邮件过滤器',
        'Edit PostMaster Filter' => '编辑邮件过滤器',
        'The name is required.' => '过滤器名称是必需项。',
        'Filter Condition' => '过滤条件',
        'AND Condition' => '与条件',
        'Check email header' => '',
        'Negate' => '求反',
        'Look for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '该栏位需使用有效的正则表达式或文字。',
        'Set Email Headers' => '设置邮件头',
        'Set email header' => '',
        'Set value' => '',
        'The field needs to be a literal word.' => '该字段需要输入文字。',

        # Template: AdminPriority
        'Priority Management' => '优先级管理',
        'Add priority' => '添加优先级',
        'Add Priority' => '添加优先级',
        'Edit Priority' => '编辑优先级',

        # Template: AdminProcessManagement
        'Process Management' => '流程管理',
        'Filter for Processes' => '过滤流程',
        'Create New Process' => '创建新的流程',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '你可以上传流程配置文件，以便将流程配置导入至你的系统中。流程配置文件采用.yml格式，它可以从流程管理模块中导出。',
        'Overwrite existing entities' => '',
        'Upload process configuration' => '上传流程配置',
        'Import process configuration' => '导入流程配置',
        'Example processes' => '',
        'Here you can activate best practice example processes that are part of %s. Please note that some additional configuration may be required.' =>
            '',
        'Import example process' => '',
        'Do you want to benefit from processes created by experts? Upgrade to %s to be able to import some sophisticated example processes.' =>
            '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '为了创建新的流程，你可以导入流程配置文件或从新创建它。',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '对流程所做的一切修改仅保存在数据库中。只有执行同步操作后，才会生成或重新生成流程配置文件。',
        'Processes' => '流程',
        'Process name' => '流程名称',
        'Print' => '打印',
        'Export Process Configuration' => '导出流程配置',
        'Copy Process' => '复制流程',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
        'Go Back' => '返回',
        'Please note, that changing this activity will affect the following processes' =>
            '请注意，修改这个环节将影响以下流程',
        'Activity' => '环节',
        'Activity Name' => '环节名称',
        'Activity Dialogs' => '环节操作',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '通过鼠标将左侧列表中的元素拖放至右侧，你可以为这个环节指派环节操作。',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '利用鼠标拖放动作还可以对元素进行排序。',
        'Filter available Activity Dialogs' => '过滤可选的环节操作',
        'Available Activity Dialogs' => '可选的环节操作',
        'Create New Activity Dialog' => '创建新环节操作',
        'Assigned Activity Dialogs' => '指派的环节操作',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '一旦你使用这个按钮或链接,您将退出这个界面且当前状态将被自动保存。你想要继续吗?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '请注意，修改这个环节操作将影响以下环节',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '请注意，用户并不能看到或对以下字段时行操作：Owner, Responsible, Lock, PendingTime and CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => '环节操作',
        'Activity dialog Name' => '环节操作名称',
        'Available in' => '有效界面',
        'Description (short)' => '描述(简短)',
        'Description (long)' => '描述(详细)',
        'The selected permission does not exist.' => '选择的权限不存在',
        'Required Lock' => '需要锁定',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '提交建议文本',
        'Submit Button Text' => '提交按钮文本',
        'Fields' => '字段',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '通过鼠标将左侧列表中的元素拖放至右侧，你可以为这个环节操作指派字段。',
        'Filter available fields' => '过滤可选的字段',
        'Available Fields' => '可选的字段',
        'Assigned Fields' => '指派的字段',
        'Edit Details for Field' => '编辑字段详情',
        'ArticleType' => '信件类型',
        'Display' => '显示',
        'Edit Field Details' => '编辑字段详情',
        'Customer interface does not support internal article types.' => '用户界面不支持内部信件类型。',

        # Template: AdminProcessManagementPath
        'Path' => '路径',
        'Edit this transition' => '编辑这个转向',
        'Transition Actions' => '转向动作',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '通过鼠标将左侧列表中的元素拖放至右侧，你可以为这个转向指派转向动作。',
        'Filter available Transition Actions' => '过滤可选的转向动作',
        'Available Transition Actions' => '可选的转向动作',
        'Create New Transition Action' => '创建新的转向动作',
        'Assigned Transition Actions' => '指派的转向动作',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '环节',
        'Filter Activities...' => '过滤环节...',
        'Create New Activity' => '创建新的环节',
        'Filter Activity Dialogs...' => '过滤环节操作...',
        'Transitions' => '转向',
        'Filter Transitions...' => '过滤转向...',
        'Create New Transition' => '创建新的转向',
        'Filter Transition Actions...' => '过滤转向操作...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '编辑流程',
        'Print process information' => '打印流程信息',
        'Delete Process' => '删除流程',
        'Delete Inactive Process' => '删除非活动的流程',
        'Available Process Elements' => '可选的流程元素',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '通过鼠标拖放动作，可以将左侧栏目上方所列的元素放置在右侧的画布中。',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '可能将环节拖放至画布中，以便为流程指派环节。',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '为了给环节指派环节操作，需要将左侧的环节操作拖放至画布中的环节上。',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '为了实现环节之间的转向，需要将左侧的转向拖放至画布中并将它放至在开始环节上，然后再将转向箭头拖放至结束环节上。',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '为了给转向指派转向动作，需要将左侧转向动作拖放至转向标签上。',
        'Edit Process Information' => '编辑流程信息',
        'Process Name' => '流程名称',
        'The selected state does not exist.' => '选择的状态不存在',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '添加并编辑环节、环节操作和转向',
        'Show EntityIDs' => '显示实体编号',
        'Extend the width of the Canvas' => '扩展画布的宽度',
        'Extend the height of the Canvas' => '扩展画布的高度',
        'Remove the Activity from this Process' => '从这个流程中删除该环节',
        'Edit this Activity' => '编辑该环节',
        'Save settings' => '保存设置',
        'Save Activities, Activity Dialogs and Transitions' => '保存环节、环节操作和转向',
        'Do you really want to delete this Process?' => '你确定要删除这个流程吗？',
        'Do you really want to delete this Activity?' => '你确定要删除这个环节吗？',
        'Do you really want to delete this Activity Dialog?' => '你确定要删除这个环节操作吗？',
        'Do you really want to delete this Transition?' => '你确定要删除这个转向吗？',
        'Do you really want to delete this Transition Action?' => '你确定要删除这个转向动作吗？',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '你确定要从画布中删除这个环节吗？不保存并退出此窗口可撤销删除操作。',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '你确定要从画布中删除这个转向吗？不保存并退出此窗口可撤销删除操作。',
        'Hide EntityIDs' => '隐藏实体编号',
        'Delete Entity' => '删除实体',
        'Remove Entity from canvas' => '从画布中删除实体',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '流程中已包括这个环节，你不能重复添加环节。',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '不能删除这个环节，因为它是开始环节。',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '环节已经使用了这个转向，你不能重复添加转向。',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '路径已经使用了这个转向动作，你不能重复添加转向动作。',
        'Remove the Transition from this Process' => '从该流程中删除转向',
        'No TransitionActions assigned.' => '没有转向动作被指派',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '没有指派的环节操作。请从左侧列表中选择一个环节操作，并将它拖放到这里。',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '画布上已经有一个未连接的转向。在设置另一个转向之前，请先连接这个转向。',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '在这里，你可以创建新的流程。为了使新流程生效，请务必将流程的状态设置为“激活”，将在完成配置工作后执行同步操作。',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '开始环节',
        'Contains %s dialog(s)' => '包含%s操作',
        'Assigned dialogs' => '指派操作',
        'Activities are not being used in this process.' => '该流程未使用环节',
        'Assigned fields' => '指派字段',
        'Activity dialogs are not being used in this process.' => '该流程未使用环节操作',
        'Condition linking' => '条件链接',
        'Conditions' => '条件',
        'Condition' => '条件',
        'Transitions are not being used in this process.' => '该流程未使用转向',
        'Module name' => '模块名称',
        'Transition actions are not being used in this process.' => '该流程未使用转向动作',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '请注意，修改这个转向将影响以下流程。',
        'Transition' => '转向',
        'Transition Name' => '转向名称',
        'Type of Linking between Conditions' => '条件之间的逻辑关系',
        'Remove this Condition' => '删除这个条件',
        'Type of Linking' => '链接类型',
        'Remove this Field' => '删除这个字段',
        'And can\'t be repeated on the same condition.' => '',
        'Add a new Field' => '添加新的字段',
        'Add New Condition' => '添加新的条件',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '请注意，修改这个转向动作将影响以下流程。',
        'Transition Action' => '转向动作',
        'Transition Action Name' => '转向动作名称',
        'Transition Action Module' => '转向动作模块',
        'Config Parameters' => '配置参数',
        'Remove this Parameter' => '删除这个参数',
        'Add a new Parameter' => '添加新的参数',

        # Template: AdminQueue
        'Manage Queues' => '队列管理',
        'Add queue' => '添加队列',
        'Add Queue' => '添加队列',
        'Edit Queue' => '编辑队列',
        'A queue with this name already exists!' => '',
        'Sub-queue of' => '子队列',
        'Unlock timeout' => '超时解锁',
        '0 = no unlock' => '永不解锁',
        'Only business hours are counted.' => '只计算上班时间',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '如果工单被锁定且在锁定超时之前未被关闭，则该工单将被解锁，以便其他服务人员处理该工单.',
        'Notify by' => '超时触发通知',
        '0 = no escalation' => '0 = 不升级  ',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定义的时间之前，服务人员没有对新工单添加任何信件(无论是邮件-外部或电话)，该工单将升级.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '如果有新的信件，例如用户通过门户或邮件发送跟进信件，则对升级更新时间进行复位. 如果在此所定义的时间之前，服务人员没有对新工单添加任何信件，无论是邮件-外部或电话，该工单将升级.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定义的时间之前，工单未被关闭，该工单将升级.',
        'Follow up Option' => '跟进选项',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '如果用户在工单关闭后发送跟进信件，你是允许、拒绝、还是创建新工单?',
        'Ticket lock after a follow up' => '跟进后自动锁定工单',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '如果用户在工单关闭后发送跟进信件，则将该工单锁定给以前的所有者.',
        'System address' => '系统邮件地址',
        'Will be the sender address of this queue for email answers.' => '回复邮件的发送地址',
        'Default sign key' => '默认回复签名',
        'The salutation for email answers.' => '回复邮件中的抬头',
        'The signature for email answers.' => '回复邮件中的签名',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '管理队列的自动回复',
        'Filter for Queues' => '过滤队列',
        'Filter for Auto Responses' => '过滤回复',
        'Auto Responses' => '自动回复',
        'Change Auto Response Relations for Queue' => '设置队列的自动回复',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '管理模板与队列的对应关系',
        'Filter for Templates' => '过滤模板',
        'Templates' => '模板',
        'Change Queue Relations for Template' => '为模板设置队列',
        'Change Template Relations for Queue' => '为队列设置模板',

        # Template: AdminRegistration
        'System Registration Management' => '系统注册管理',
        'Edit details' => '',
        'Show transmitted data' => '',
        'Deregister system' => '取消系统注册',
        'Overview of registered systems' => '注册系统概述',
        'This system is registered with OTRS Group.' => '本系统由OTRS集团注册。',
        'System type' => '系统类型',
        'Unique ID' => '唯一ID',
        'Last communication with registration server' => '与注册服务器上一次的通讯',
        'System registration not possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '',
        'Instructions' => '',
        'System deregistration not possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => 'OTRS-ID登陆',
        'Read more' => '阅读全部',
        'You need to log in with your OTRS-ID to register your system.' =>
            '为了注册系统，需要你先使用OTRS-ID进行登陆。',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'OTRS-ID是你的一个邮件地址，用于在OTRS.com网页进行注册和登陆。',
        'Data Protection' => '',
        'What are the advantages of system registration?' => '系统注册有什么好处?',
        'You will receive updates about relevant security releases.' => '你将及时收到有关安全版本的更新信息。',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '有助于我们改善服务，因为我们从你处获得了必要的相关信息。',
        'This is only the beginning!' => '这仅仅是开始！',
        'We will inform you about our new services and offerings soon.' =>
            '我们会向您发布更多服务和产品。',
        'Can I use OTRS without being registered?' => '如果不进行系统注册，我还可以使用OTRS吗?',
        'System registration is optional.' => '系统注册是可选的。',
        'You can download and use OTRS without being registered.' => '不进行注册，你仍然可以下载和使用OTRS',
        'Is it possible to deregister?' => '可以取消注册吗？',
        'You can deregister at any time.' => '你可以随时取消系统注册',
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
        'In case you would have further questions we would be glad to answer them.' =>
            '如果您还有其它问题，我们非常愿意答复您。',
        'Please visit our' => '请访问我们的',
        'portal' => '门户',
        'and file a request.' => '并提出请求。',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => '',
        'You don\'t have an OTRS-ID yet?' => '还没有OTRS-ID吗？',
        'Sign up now' => '现在注册',
        'Forgot your password?' => '忘记密码了吗？',
        'Retrieve a new one' => '获取新的密码',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '注册本系统后，这个数据会经常传送给OTRS Group',
        'Attribute' => '属性',
        'FQDN' => '',
        'OTRS Version' => 'OTRS版本',
        'Operating System' => '操作系统',
        'Perl Version' => 'Perl版本',
        'Optional description of this system.' => '这个系统可选的描述。',
        'Register' => '注册',
        'Deregister System' => '取消系统注册',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => '取消注册',
        'You can modify registration settings here.' => '',
        'Overview of transmitted data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '系统注册信息',
        'Support Data' => '诊断数据',

        # Template: AdminRole
        'Role Management' => '角色管理',
        'Add role' => '添加角色',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '创建一个角色并将组加入角色,然后将角色赋给用户.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '有没有角色定义. 请使用 \'添加\' 按钮来创建一个新的角色',
        'Add Role' => '添加角色',
        'Edit Role' => '编辑角色',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '管理角色的组权限',
        'Filter for Roles' => '过滤角色',
        'Roles' => '角色',
        'Select the role:group permissions.' => '选择角色:组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '如果没有选择，就不会具有任何权限 (任何工单都看不见)',
        'Change Role Relations for Group' => '选择此组具有的角色权限',
        'Change Group Relations for Role' => '选择此角色具有的组权限',
        'Toggle %s permission for all' => '切换%s权限给全部',
        'move_into' => '',
        'Permissions to move tickets into this group/queue.' => '对于组/队列中的工单具有 \'转移队列\' 的权限',
        'create' => '创建',
        'Permissions to create tickets in this group/queue.' => '对于组/队列具有 \'创建工单\' 的权限',
        'note' => '备注',
        'Permissions to add notes to tickets in this group/queue.' => '对于组/队列具有 \'添加备注\' 的权限',
        'owner' => '所有者',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '对于组/队列具有 \'所有者\' 的权限',
        'priority' => '优先级',
        'Permissions to change the ticket priority in this group/queue.' =>
            '对于组/队列中的工单具有 \'更改优先级\' 的权限',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '定义服务人员的角色',
        'Add agent' => '添加服务人员',
        'Filter for Agents' => '查找服务人员',
        'Agents' => '服务人员',
        'Manage Role-Agent Relations' => '管理服务人员的角色',
        'Change Role Relations for Agent' => '选择此服务人员的角色',
        'Change Agent Relations for Role' => '选择此角色的服务人员',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Add SLA' => '添加SLA',
        'Edit SLA' => '编辑SLA',
        'Please write only numbers!' => '仅可填写数字！',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'Add certificate' => '添加证书',
        'Add private key' => '添加私匙',
        'Filter for certificates' => '过滤证书',
        'Filter for S/MIME certs' => '',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => '参见',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '这样你能够直接编辑文件系统中的证书和私匙。',
        'Hash' => 'Hash',
        'Handle related certificates' => '处理关联的证书',
        'Read certificate' => '读取证书',
        'Delete this certificate' => '删除这个证书',
        'Add Certificate' => '添加证书',
        'Add Private Key' => '添加个人私钥',
        'Secret' => '机密',
        'Related Certificates for' => '关联证书',
        'Delete this relation' => '删除这个关联',
        'Available Certificates' => '可选的证书',
        'Relate this certificate' => '关联这个证书',

        # Template: AdminSMIMECertRead
        'Certificate details' => '',

        # Template: AdminSalutation
        'Salutation Management' => '回复抬头管理',
        'Add salutation' => '添加回复抬头',
        'Add Salutation' => '添加回复抬头',
        'Edit Salutation' => '编辑回复抬头',
        'e. g.' => '例如',
        'Example salutation' => '这里有一个范例',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => '安全模式需要被启用！',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '在初始安装结束后，安全模式通常将被设置',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '系统已启用，请通过SysConfig启用安全模式。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL查询窗口',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            '这里你可以输入并运行数据库SQL的命令。',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL查询的语法有一个错误，请核对。',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '至少有一个参数丢失，请核对。',
        'Result format' => '结果格式',
        'Run Query' => '执行查询',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => '服务管理',
        'Add service' => '添加服务',
        'Add Service' => '添加服务',
        'Edit Service' => '编辑服务',
        'Sub-service of' => '子服务',

        # Template: AdminSession
        'Session Management' => '会话管理',
        'All sessions' => '所有会话',
        'Agent sessions' => '服务人员会话',
        'Customer sessions' => '用户会话',
        'Unique agents' => '实际服务人员',
        'Unique customers' => '实际在线用户',
        'Kill all sessions' => '终止所有会话',
        'Kill this session' => '终止该会话',
        'Session' => '会话',
        'Kill' => '终止',
        'Detail View for SessionID' => '该会话的详细记录',

        # Template: AdminSignature
        'Signature Management' => '回复签名管理',
        'Add signature' => '添加回复签名',
        'Add Signature' => '添加回复签名',
        'Edit Signature' => '编辑回复签名',
        'Example signature' => '签名范例',

        # Template: AdminState
        'State Management' => '工单状态管理',
        'Add state' => '添加工单状态',
        'Please also update the states in SysConfig where needed.' => '请同时在SysConfig中需要地方更新这些状态。',
        'Add State' => '添加工单状态',
        'Edit State' => '编辑工单状态',
        'State type' => '工单状态类型',

        # Template: AdminSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '发送更新',
        'Sending Update...' => '正在发送更新...',
        'Support Data information was successfully sent.' => '诊断信息已发送成功.',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '更新结果',
        'Currently this data is only shown in this system.' => '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '打包系统数据',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '无法打包系统数据.',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',
        'The support bundle has been generated.' => '系统数据已打包成功.',
        'Please choose one of the following options.' => '请选择以下的任一个选项.',
        'Send by Email' => '通过邮件发送',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => '发送中',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '详细的系统数据会自动通过电子邮件方式发送给 OTRS.',
        'Download File' => '下载文件',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '包含系统详细数据的文件已生成在本地服务器上. 请下载该文件通过其他方法发送给 OTRS 或其他的服务提供商.',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => '详情',

        # Template: AdminSysConfig
        'SysConfig' => '系统配置',
        'Navigate by searching in %s settings' => '从%s个配置参数中进行搜索',
        'Navigate by selecting config groups' => '按配置参数分组进行浏览',
        'Download all system config changes' => '下载所有配置(不包括默认配置)',
        'Export settings' => '导出设置',
        'Load SysConfig settings from file' => '从指定文件加载系统配置',
        'Import settings' => '导入设置',
        'Import Settings' => '导入设置',
        'Please enter a search term to look for settings.' => '请输入关键词来查找相关的设置.',
        'Subgroup' => '子组',
        'Elements' => '元素',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => '编辑配置。',
        'This setting is read only.' => '',
        'This config item is only available in a higher config level!' =>
            '该配置项只在高级配置可用！',
        'Reset this setting' => '重置设定',
        'Error: this file could not be found.' => '错误：文件不存在。',
        'Error: this directory could not be found.' => '错误：目录不存在。',
        'Error: an invalid value was entered.' => '错误：输入无效的值。',
        'Content' => '值',
        'Remove this entry' => '删除该条目',
        'Add entry' => '添加条目',
        'Remove entry' => '删除条目',
        'Add new entry' => '添加新条目',
        'Delete this entry' => '删除该条目',
        'Create new entry' => '创建新条目',
        'New group' => '新的组',
        'Group ro' => '组 ro',
        'Readonly group' => '只读权限组',
        'New group ro' => '新的只读权限组',
        'Loader' => '加载',
        'File to load for this frontend module' => '文件装载界面模块',
        'New Loader File' => '新加载文件',
        'NavBarName' => '导航栏名称',
        'NavBar' => '导航栏',
        'LinkOption' => '链接选项',
        'Block' => '块',
        'AccessKey' => '进钥',
        'Add NavBar entry' => '添加导航栏条目',
        'Year' => '年',
        'Month' => '月',
        'Day' => '日',
        'Invalid year' => '无效的年份',
        'Invalid month' => '无效的月份',
        'Invalid day' => '无效的日期',
        'Show more' => '显示更多',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => '邮件发送地址管理',
        'Add system address' => '添加邮件发送地址',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '对于所有接收到的邮件，如果在其邮件中的To或Cc中出现了这些邮件发送地址，则将接收到的邮件分派给邮件发送地址所指定的队列中。',
        'Email address' => '邮件发送地址',
        'Display name' => '名称',
        'Add System Email Address' => '添加邮件发送地址',
        'Edit System Email Address' => '编辑邮件发送地址',
        'The display name and email address will be shown on mail you send.' =>
            '邮件地址和名称将在邮件中显示。',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '系统维护管理',
        'Schedule New System Maintenance' => '系统维护排程',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '当系统在特定的时间进行周期性维护时, 排程会通知服务人员或用户.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '当到达维护时间之前, 当前登录到系统的用户将会在屏幕上收到一个通知.',
        'Start date' => '开始时间',
        'Stop date' => '结束时间',
        'Delete System Maintenance' => '',
        'Do you really want to delete this scheduled system maintenance?' =>
            '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => '',
        'Edit System Maintenance information' => '',
        'Date invalid!' => '日期无效!',
        'Login message' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Manage Templates' => '模板管理',
        'Add template' => '添加模板',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '模板中的正文帮助服务人员快速始建、回复或转发工单。',
        'Don\'t forget to add new templates to queues.' => '别忘了将新模板指派给队列',
        'Add Template' => '添加模板',
        'Edit Template' => '编辑模板',
        'A standard template with this name already exists!' => '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '模板举例',
        'The current ticket state is' => '当前工单状态是',
        'Your email address is' => '你的邮件地址是',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '管理模板与附件之间的关系',
        'Filter for Attachments' => '过滤附件',
        'Change Template Relations for Attachment' => '为附件指定模板',
        'Change Attachment Relations for Template' => '为模板指定附件',
        'Toggle active for all' => '切换激活全部',
        'Link %s to selected %s' => '链接%s到选中的%s',

        # Template: AdminType
        'Type Management' => '工单类型管理',
        'Add ticket type' => '添加工单类型',
        'Add Type' => '添加工单类型',
        'Edit Type' => '编辑工单类型',
        'A type with this name already exists!' => '这个类型的名字已存在!',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => '处理工单是服务人员职责。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '别忘了为服务人员指派组或角色权限！',
        'Please enter a search term to look for agents.' => '请输入一个搜索条件以便查找服务人员。',
        'Last login' => '最后一次登录',
        'Switch to agent' => '切换服务人员',
        'Add Agent' => '添加服务人员',
        'Edit Agent' => '编辑服务人员',
        'Firstname' => '名',
        'Lastname' => '姓',
        'A user with this username already exists!' => '这个用户名已被使用!',
        'Will be auto-generated if left empty.' => '如果为空，将自动生成密码。',
        'Start' => '开始',
        'End' => '结束',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '定义服务人员的组权限',
        'Change Group Relations for Agent' => '选择此服务人员具备的组权限',
        'Change Agent Relations for Group' => '为此组选择服务人员的权限',

        # Template: AgentBook
        'Address Book' => '地址簿',
        'Search for a customer' => '查找用户',
        'Add email address %s to the To field' => '将邮件地址%s添加至To字段',
        'Add email address %s to the Cc field' => '将邮件地址%s添加至Cc字段',
        'Add email address %s to the Bcc field' => '将邮件地址%s添加至Bcc字段',
        'Apply' => '应用',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '用户信息中心',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '用户',

        # Template: AgentCustomerSearch
        'Duplicated entry' => '重复条目',
        'This address already exists on the address list.' => '地址列表已有这个地址。',
        'It is going to be deleted from the field, please try again.' => '将自动删除这个重复的地址，请再试一次。',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '注意：用户是无效的！',

        # Template: AgentDaemonInfo
        'General Information' => '一般信息',
        'OTRS Daemon is a separated process that perform asynchronous tasks' =>
            '',
        '(e.g. Generic Interface asynchronous invoker tasks, Ticket escalation triggering, Email sending, etc.)' =>
            '',
        'It is necessary to have the OTRS Daemon running to make the system work correctly!' =>
            '',
        'Starting OTRS Daemon' => '',
        'Make sure that %s exists (without .dist extension)' => '',
        'Check that cron deamon is running in the system' => '检查系统进程已经运行',
        'Confirm that OTRS cron jobs are running, execute %s start' => '确定 OTRS cron 任务已运行, 执行 %s 启动',

        # Template: AgentDashboard
        'Dashboard' => '信息中心',

        # Template: AgentDashboardCalendarOverview
        'in' => '之内',

        # Template: AgentDashboardCommon
        'Available Columns' => '可选择的字段',
        'Visible Columns (order by drag & drop)' => '显示的字段(通过拖拽可调整顺序)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '升级的工单',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '用户信息',
        'Phone ticket' => '电话工单',
        'Email ticket' => '邮件工单',
        'Start Chat' => '开始对话',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',
        'Start chat' => '开始对话',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is 可用！',
        'Please update now.' => '请现在更新',
        'Release Note' => '版本说明',
        'Level' => '级别',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '发布于%s之前',

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
            '正在为你处理统计数据，请耐心等待。',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '我锁定的工单',
        'My watched tickets' => '我订阅的工单',
        'My responsibilities' => '我负责的工单',
        'Tickets in My Queues' => '我队列中的工单',
        'Tickets in My Services' => '我服务的工单',
        'Service Time' => '服务时间',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '合计',

        # Template: AgentDashboardUserOnline
        'out of office' => '不在办公室',
        'Selected agent is not available for chat' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '直至',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => '工单已锁定',
        'Undo & close' => '',

        # Template: AgentInfo
        'Info' => '详情',
        'To accept some news, a license or some changes.' => '接收新闻、许可证或者一些动态信息。',

        # Template: AgentLinkObject
        'Link Object: %s' => '连接对象: %s',
        'go to link delete screen' => '转至删除链接窗口',
        'Select Target Object' => '选择目标对象',
        'Link Object' => '链接对象',
        'with' => '和',
        'Unlink Object: %s' => '取消连接对象 %s',
        'go to link add screen' => '转至添加链接窗口',

        # Template: AgentPreferences
        'Edit your preferences' => '编辑个人设置',
        'Did you know? You can help translating OTRS at %s.' => '',

        # Template: AgentSpelling
        'Spell Checker' => '拼写检查',
        'spelling error(s)' => '拼写错误',
        'Apply these changes' => '应用这些更改',

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
        'Statistics' => '统计',
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
        'All fields marked with an asterisk (*) are mandatory.' => '所有带 * 的字段都是强制要求输入的字段.',
        'Service invalid.' => '服务无效。',
        'New Owner' => '新所有者',
        'Please set a new owner!' => '请指定新的所有者！',
        'New Responsible' => '新的责任人',
        'Next state' => '工单状态',
        'For all pending* states.' => '',
        'Add Article' => '',
        'Create an Article' => '',
        'Spell check' => '拼写检查',
        'Text Template' => '文本模板',
        'Setting a template will overwrite any text or attachment.' => '',
        'Note type' => '备注类型',
        'Inform Agent' => '通知服务人员',
        'Optional' => '选项',
        'Inform involved Agents' => '通知相关服务人员',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Note will be (also) received by:' => '',

        # Template: AgentTicketBounce
        'Bounce Ticket' => '退回工单',
        'Bounce to' => '退回到 ',
        'You need a email address.' => '需要一个邮件地址。',
        'Need a valid email address or don\'t use a local email address.' =>
            '需要一个有效的邮件地址，同时不可以使用本地邮件地址。',
        'Next ticket state' => '工单状态',
        'Inform sender' => '通知发送者',
        'Send mail' => '发送!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '工单批量处理',
        'Send Email' => '发送邮件',
        'Merge to' => '合并到',
        'Invalid ticket identifier!' => '无效的工单标识符!',
        'Merge to oldest' => '合并至最早提交的工单',
        'Link together' => '相互链接',
        'Link to parent' => '链接到上一级',
        'Unlock tickets' => '工单解锁',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s' => '',
        'Please include at least one recipient' => '请包括至少一个收件人',
        'Remove Ticket Customer' => '删除工单用户',
        'Please remove this entry and enter a new one with the correct value.' =>
            '请删除这个条目并重新输入一个正确的值。',
        'Remove Cc' => '删除Cc',
        'Remove Bcc' => '删除Bcc',
        'Address book' => '地址簿',
        'Date Invalid!' => '日期无效！',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s' => '',
        'Customer user' => '用户',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '创建邮件工单',
        'Example Template' => '',
        'From queue' => '队列',
        'To customer user' => '选择用户',
        'Please include at least one customer user for the ticket.' => '请包括至少一个工单用户。',
        'Select this customer as the main customer.' => '选择这个用户作为主用户',
        'Remove Ticket Customer User' => '删除工单用户',
        'Get all' => '获取全部',
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
        'History Content' => '历史内容',
        'Zoom view' => '缩放视图',

        # Template: AgentTicketMerge
        'Merge %s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => '您需要使用一个工单编号!',
        'A valid ticket number is required.' => '需要有效的工单编号。',
        'Need a valid email address.' => '需要有效的邮件地址。',

        # Template: AgentTicketMove
        'Move %s%s' => '',
        'New Queue' => '新队列',

        # Template: AgentTicketOverviewMedium
        'Select all' => '选择全部',
        'No ticket data found.' => '没有找到工单数据。',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => '',
        'First Response Time' => '第一响应时间',
        'Update Time' => '更新时间',
        'Solution Time' => '解决时间',
        'Move ticket to a different queue' => '将工单转移到另一个队列',
        'Change queue' => '更改队列',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => '修改搜索选项',
        'Remove active filters for this screen.' => '清除此屏的过滤器',
        'Tickets per page' => '工单数/页',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',
        'Column Filters Form' => '',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '保存对话为新的电话工单',
        'Create New Phone Ticket' => '创建电话工单',
        'Please include at least one customer for the ticket.' => '请包括至少一个工单用户。',
        'To queue' => '队列',
        'Chat protocol' => '对话记录',
        'The chat will be appended as a separate article.' => '将对话追加到已有工单',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s' => '',
        'Plain' => '纯文本',
        'Download this email' => '下载该邮件',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '创建流程工单',
        'Process' => '流程',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Search template' => '搜索模板',
        'Create Template' => '创建模板',
        'Create New' => '创建',
        'Profile link' => '按模板搜索',
        'Save changes in template' => '保存变更为模板',
        'Filters in use' => '正在使用搜索条件',
        'Additional filters' => '其他供使用的搜索条件',
        'Add another attribute' => '增加另一个搜索条件',
        'Output' => '搜索结果显示为',
        'Fulltext' => '全文',
        'Remove' => '删除',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '搜索范围覆盖From, To, Cc, 主题和信件.',
        'Customer User Login' => '用户登录用户名',
        'Attachment Name' => '',
        '(e. g. m*file or myfi*)' => '',
        'Created in Queue' => '队列中创建',
        'Lock state' => '锁定状态',
        'Watcher' => '订阅人',
        'Article Create Time (before/after)' => '信件创建时间(相对)',
        'Article Create Time (between)' => '信件创建时间(绝对)',
        'Ticket Create Time (before/after)' => '工单创建时间(相对)',
        'Ticket Create Time (between)' => '工单创建时间(绝对)',
        'Ticket Change Time (before/after)' => '工单更新时间(相对)',
        'Ticket Change Time (between)' => '工单更新时间(绝对)',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Close Time (before/after)' => '工单关闭时间(相对)',
        'Ticket Close Time (between)' => '工单关闭时间(绝对)',
        'Ticket Escalation Time (before/after)' => '工单升级时间(相对)',
        'Ticket Escalation Time (between)' => '工单升级时间(绝对)',
        'Archive Search' => '归档搜索',
        'Run search' => '搜索',

        # Template: AgentTicketZoom
        'Article filter' => '信件过滤器',
        'Article Type' => '信件类别 ',
        'Sender Type' => '发送人类型',
        'Save filter settings as default' => '将过滤器作为缺省设置并保存',
        'Event Type Filter' => '',
        'Event Type' => '',
        'Save as default' => '',
        'Archive' => '归档',
        'This ticket is archived.' => '该工单已归档',
        'Locked' => '锁定状态',
        'Accounted time' => '所用时间',
        'Linked Objects' => '已连接的对象',
        'Change Queue' => '改变队列',
        'There are no dialogs available at this point in the process.' =>
            '目前流程中没有环节操作。',
        'This item has no articles yet.' => '此条目没有信件。',
        'Ticket Timeline View' => '工单时间轴',
        'Article Overview' => '',
        'Article(s)' => '信件',
        'Page' => '页',
        'Add Filter' => '添加过滤器',
        'Set' => '设置',
        'Reset Filter' => '重置过滤器',
        'Show one article' => '显示单一信件',
        'Show all articles' => '显示所有信件',
        'Show Ticket Timeline View' => '以时间轴视图显示工单',
        'Unread articles' => '未读信件',
        'No.' => '编号：',
        'Important' => '重要',
        'Unread Article!' => '未读信件!',
        'Incoming message' => '接收的信息',
        'Outgoing message' => '发出的信息',
        'Internal message' => '内部信息',
        'Resize' => '调整大小',
        'Mark this article as read' => '',
        'Show Full Text' => '显示详细内容',
        'Full Article Text' => '详细内容',
        'No more events found. Please try changing the filter settings.' =>
            '',
        'by' => '由',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '要打开工单里的链接, 你可能需要按 Ctrl 或 Cmd 或 Shift 键的同时单击链接 (取决于您的浏览器和操作系统 ).',
        'Close this message' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '为了保护你的隐私,远程内容被阻挡。',
        'Load blocked content.' => '载入被阻挡的内容。',

        # Template: ChatStartForm
        'First message' => '请一句话描述您的需求',

        # Template: CustomerError
        'Traceback' => '追溯',

        # Template: CustomerFooter
        'Powered by' => 'Powered by',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => '一个或多个错误!',
        'Close this dialog' => '关闭该对话',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '无法打开弹出窗口，请禁用弹出窗口拦截。',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '如果你现在离开该页, 所有弹出的窗口也随之关闭!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '一个弹出窗口已经打开，是否继续关闭？',
        'There are currently no elements available to select from.' => '目前没有可供选择的元素。',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'The browser you are using is too old.' => '你使用的游览器太旧了.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS 已确认下列的游览器可正常显示, 请挑一个你喜欢用的升级之.',
        'Please see the documentation or ask your admin for further information.' =>
            '欲了解更多信息, 请向你的管理询问或参考相关文档.',
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
        'JavaScript Not Available' => '没有启用 JavaScript',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            '要继续使用 OTRS，请打开浏览器的 JavaScript 功能.',
        'Browser Warning' => '提示',
        'One moment please, you are being redirected...' => '',
        'Login' => '登录',
        'User name' => '用户名',
        'Your user name' => '你的用户名',
        'Your password' => '你的密码',
        'Forgot password?' => '密码遗忘?',
        '2 Factor Token' => '',
        'Your 2 Factor Token' => '',
        'Log In' => '登录',
        'Not yet registered?' => '还未注册?',
        'Request new password' => '请求新密码',
        'Your User Name' => '你的用户名',
        'A new password will be sent to your email address.' => '新密码将会发送到您的邮箱中',
        'Create Account' => '创建帐户',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => '称谓',
        'Your First Name' => '名字',
        'Your Last Name' => '姓',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '进入的会话请求',
        'You have unanswered chat requests' => '你有未响应的对话请求',
        'Edit personal preferences' => '编辑个人设置',
        'Logout %s %s' => '',

        # Template: CustomerRichTextEditor
        'Split Quote' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => '服务水平协议',

        # Template: CustomerTicketOverview
        'Welcome!' => '欢迎！',
        'Please click the button below to create your first ticket.' => '请点击下面的按钮创建第一个工单。',
        'Create your first ticket' => '创建第一个工单',

        # Template: CustomerTicketSearch
        'Profile' => '搜索条件',
        'e. g. 10*5155 or 105658*' => '例如: 10*5155 或 105658*',
        'Customer ID' => '用户编号',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => '工单全文搜索 (例如: "John*n" 或 "Will*")',
        'Recipient' => '收件人',
        'Carbon Copy' => '抄送',
        'e. g. m*file or myfi*' => '',
        'Types' => '类型',
        'Time restrictions' => '时间查询条件',
        'No time settings' => '',
        'Only tickets created' => '工单创建于',
        'Only tickets created between' => '工单创建自',
        'Ticket archive system' => '',
        'Save search as template?' => '将搜索保存为模板？',
        'Save as Template?' => '保存为模板',
        'Save as Template' => '保存为模板',
        'Template Name' => '模板名称',
        'Pick a profile name' => '',
        'Output to' => '输出为',

        # Template: CustomerTicketSearchResultShort
        'of' => '在',
        'Search Results for' => '搜索结果',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '',
        'Expand article' => '展开信件',
        'Information' => '信息',
        'Next Steps' => '下一',
        'Reply' => '回复',
        'Chat Protocol' => '',

        # Template: DashboardEventsTicketCalendar
        'All-day' => '全天',
        'Sunday' => '星期天',
        'Monday' => '星期一',
        'Tuesday' => '星期二',
        'Wednesday' => '星期三',
        'Thursday' => '星期四',
        'Friday' => '星期五',
        'Saturday' => '星期六',
        'Su' => '日',
        'Mo' => '一',
        'Tu' => '二',
        'We' => '三',
        'Th' => '四',
        'Fr' => '五',
        'Sa' => '六',
        'Event Information' => '事件信息',
        'Ticket fields' => '工单字段',
        'Dynamic fields' => '动态字段',

        # Template: Datepicker
        'Invalid date (need a future date)!' => '无效的日期（需使用未来的日期）！',
        'Invalid date (need a past date)!' => '',
        'Previous' => '上一步',
        'Open date selection' => '打开日历',

        # Template: Error
        'Oops! An Error occurred.' => '糟, 发生一个错误.',
        'You can' => '你可以',
        'Send a bugreport' => '发送一个错误报告',
        'go back to the previous page' => '返回上一页',
        'Error Details' => '详细错误信息',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            '请至少输入一个搜索条件或 *。',
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
        'You are logged in as' => '您已登录为',

        # Template: Installer
        'JavaScript not available' => 'JavaScript没有启用',
        'Step %s' => '第 %s 步',
        'Database Settings' => '数据库设置',
        'General Specifications and Mail Settings' => '一般设定和邮件配置',
        'Finish' => '完成',
        'Welcome to %s' => '',
        'Web site' => '网址',
        'Mail check successful.' => '邮件配置检查完成',
        'Error in the mail settings. Please correct and try again.' => '邮件设置错误, 请重新修正.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '外发邮件配置',
        'Outbound mail type' => '外发邮件类型',
        'Select outbound mail type.' => '选择外发邮件类型。',
        'Outbound mail port' => '外发邮件端口',
        'Select outbound mail port.' => '选择外发邮件端口。',
        'SMTP host' => 'SMTP服务器',
        'SMTP host.' => 'SMTP服务器。',
        'SMTP authentication' => 'SMTP认证',
        'Does your SMTP host need authentication?' => 'SMTP服务器是否需要验证？',
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
        'Password for inbound mail.' => '接收邮件密码',
        'Result of mail configuration check' => '邮件服务器配置检查结果',
        'Check mail configuration' => '检查邮件配置',
        'Skip this step' => '跳过这一步',

        # Template: InstallerDBResult
        'Database setup successful!' => '数据库设置成功！',

        # Template: InstallerDBStart
        'Install Type' => '安装类型',
        'Create a new database for OTRS' => '为OTRS创建新的数据库',
        'Use an existing database for OTRS' => '使用现有的数据库',

        # Template: InstallerDBmssql
        'Database name' => '数据库名称',
        'Check database settings' => '测试数据库设置',
        'Result of database check' => '数据库检查结果',
        'Database check successful.' => '数据库检查完成.',
        'Database User' => '数据库用户',
        'New' => '新建',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            '已经为OTRS系统创建了新的数据库用户',
        'Repeat Password' => '重复输入密码',
        'Generated password' => '发送自动生成的密码',

        # Template: InstallerDBmysql
        'Passwords do not match' => '密码不匹配',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '端口',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            '为了能够使用OTRS, 您必须以root身份输入以下行在命令行中(Terminal/Shell).',
        'Restart your webserver' => '请重启您web服务器.',
        'After doing so your OTRS is up and running.' => '完成后，您可以启动OTRS系统了.',
        'Start page' => '开始页面',
        'Your OTRS Team' => '您的OTRS小组.',

        # Template: InstallerLicense
        'Don\'t accept license' => '不同意',
        'Accept license and continue' => '同意许可并继续',

        # Template: InstallerSystem
        'SystemID' => '系统ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '每个工单和HTTP会话ID包含系统标识符。',
        'System FQDN' => '系统全称域名',
        'Fully qualified domain name of your system.' => '系统FQDN（全称域名）',
        'AdminEmail' => '管理员地址',
        'Email address of the system administrator.' => '系统管理员邮件地址。',
        'Organization' => '组织',
        'Log' => '日志',
        'LogModule' => '日志模块',
        'Log backend to use.' => '日志后台使用。',
        'LogFile' => '日志文件',
        'Webfrontend' => 'Web 前端',
        'Default language' => '默认语言',
        'Default language.' => '默认语言',
        'CheckMXRecord' => '检查MX记录',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '手动输入的电子邮件地址将通过DNS服务器验证MX记录。如果DNS服务器响应慢或无法提供公网解析，请不要使用此选项。',

        # Template: LinkObject
        'Object#' => '对象#',
        'Add links' => '添加链接',
        'Delete links' => '删除链接',

        # Template: Login
        'Lost your password?' => '忘记密码?',
        'Request New Password' => '请求新密码',
        'Back to login' => '重新登录',

        # Template: MobileNotAvailableWidget
        'Feature not available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => '今日消息',

        # Template: NoPermission
        'Insufficient Rights' => '没有足够的权限',
        'Back to the previous page' => '返回前一页',

        # Template: Pagination
        'Show first page' => '首页',
        'Show previous pages' => '前一页',
        'Show page %s' => '第 %s 页',
        'Show next pages' => '后一页',
        'Show last page' => '尾页',

        # Template: PictureUpload
        'Need FormID!' => '需要FormID',
        'No file found!' => '找不到文件！',
        'The file is not an image that can be shown inline!' => '此文件是不是一个可以显示的图像!',

        # Template: PreferencesNotificationEvent
        'Notification' => '系统通知',
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: PublicDefault
        'Welcome' => '',

        # Template: Test
        'OTRS Test Page' => 'OTRS测试页',
        'Welcome %s %s' => '',
        'Counter' => '计数器',

        # Template: Warning
        'Go back to the previous page' => '返回前一页',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => '创建电话工单',
        'New email ticket' => '创建邮件工单',

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
        'Previous Owner' => '前一个所有者',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Ticket is locked by another agent and will be ignored!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'printed by' => '打印',
        'Ticket Dynamic Fields' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Pending Date' => '挂起时间',
        'for pending* states' => '针对挂起状态',

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
        'X-axis' => 'X轴',
        'Y-axis' => '',
        'The selected start time is before the allowed start time.' => '',
        'The selected end time is later than the allowed end time.' => '',
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
        'You can only use only one or two elements for the Y axis.' => '',
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
        'Order by' => '排序',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => '创建的优先级',
        'Created State' => '创建的状态',
        'CustomerUserLogin' => '用户登陆',
        'Create Time' => '创建时间',
        'Close Time' => '关闭时间',
        'Escalation - First Response Time' => '升级 - 初次响应升级',
        'Escalation - Update Time' => '升级 - 更新时间',
        'Escalation - Solution Time' => '升级 - 解决时间',
        'Agent/Owner' => '服务人员/所有者',
        'Created by Agent/Owner' => '创建人',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => '评估方法',
        'Ticket/Article Accounted Time' => '工单/信件所占用的时间',
        'Ticket Create Time' => '工单创建时间',
        'Ticket Close Time' => '工单关闭时间',
        'Accounted time by Agent' => '服务人员处理工单所用的时间',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'Attributes to be printed' => '打印的属性',
        'Sort sequence' => '排序',
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
        'Database Size' => '数据库大小',
        'Could not determine database size.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '数据库版本',
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
        'Date Format' => '日期格式',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '硬盘使用情况',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '发行版本',
        'Could not determine distribution.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '内核版本',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl 模块',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '可用的交换分区空间(%)',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '交换分区已使用(MB)',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'OTRS' => 'OTRS',
        'Daemon' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Tickets' => '工单',
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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'Open Tickets' => '处理中的工单',
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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'Webserver' => '网站服务器',
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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/IIS/Performance.pm
        'You should use PerlEx to increase your performance.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => '未知',
        'OK' => '好',
        'Problem' => '问题',

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
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s time unit(s) accounted. Now total %s time unit(s).',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'Access Control Lists (ACL)' => '访问控制列表(ACL)',
        'AccountedTime' => '占用时间',
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
        'Added email. %s' => 'Added email. %s',
        'Added link to ticket "%s".' => 'Added link to ticket "%s".',
        'Added note (%s)' => 'Added note (%s)',
        'Added subscription for user "%s".' => 'Added subscription for user "%s".',
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
        'Agent called customer.' => 'Agent called customer.',
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
        'Agents <-> Groups' => '服务人员 <-> 组',
        'Agents <-> Roles' => '服务人员 <-> 角色',
        'All customer users of a CustomerID' => '',
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
        'Archive state changed: "%s"' => '',
        'ArticleTree' => '',
        'Attachments <-> Templates' => '附件 <-> 模板',
        'Auto Responses <-> Queues' => '自动回复 <-> 队列',
        'AutoFollowUp sent to "%s".' => 'AutoFollowUp sent to "%s".',
        'AutoReject sent to "%s".' => 'AutoReject sent to "%s".',
        'AutoReply sent to "%s".' => 'AutoReply sent to "%s".',
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
        'Bounced to "%s".' => 'Bounced to "%s".',
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
        'Change password' => '修改密码',
        'Change queue!' => '转移队列',
        'Change the customer for this ticket' => '更改该工单用户',
        'Change the free fields for this ticket' => '修改自定义字段',
        'Change the priority for this ticket' => '更改工单优先级',
        'Change the responsible for this ticket' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Changed priority from "%s" (%s) to "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '复选框',
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
        'Column ticket filters for Ticket Overviews type "Small".' => '工单概览“小”模式列表字段过滤器',
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
        'Company Status' => '',
        'Company Tickets' => '单位工单',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '配置流程',
        'Configure and manage ACLs.' => '配置和管理ACLs',
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
        'Converts HTML mails into text messages.' => '将HTML邮件转换为文本信息.',
        'Create New process ticket' => '创建流程工单',
        'Create and manage Service Level Agreements (SLAs).' => '创建和管理服务品质协议(SLA)',
        'Create and manage agents.' => '创建和管理服务人员.',
        'Create and manage attachments.' => '创建和管理附件.',
        'Create and manage customer users.' => '创建和管理用户',
        'Create and manage customers.' => '创建和管理用户单位',
        'Create and manage dynamic fields.' => '创建和管理动态字段',
        'Create and manage groups.' => '创建和管理组.',
        'Create and manage queues.' => '创建和管理队列.',
        'Create and manage responses that are automatically sent.' => '创建和管理自动回复.',
        'Create and manage roles.' => '创建和管理角色.',
        'Create and manage salutations.' => '创建和管理邮件开头的问候语.',
        'Create and manage services.' => '创建和管理服务',
        'Create and manage signatures.' => '创建和管理签名',
        'Create and manage templates.' => '创建和管理模板',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => '创建和管理工单优先级别.',
        'Create and manage ticket states.' => '创建和管理工单状态',
        'Create and manage ticket types.' => '创建和管理工单类型. ',
        'Create and manage web services.' => '创建和管理Web服务',
        'Create new email ticket and send this out (outbound)' => '创建邮件工单并给用户邮件',
        'Create new phone ticket (inbound)' => '创建电话工单(接电话)',
        'Create new process ticket' => '创建流程工单',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '用户单位管理',
        'Customer User <-> Groups' => '用户 <-> 组',
        'Customer User <-> Services' => '用户 <-> 服务',
        'Customer User Administration' => '用户管理',
        'Customer Users' => '用户',
        'Customer called us.' => 'Customer called us.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer request via web.' => 'Customer request via web.',
        'Customer user search' => '搜索用户',
        'CustomerID search' => '单位搜索',
        'CustomerName' => '用户名',
        'Customers <-> Groups' => '用户 <-> 组',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '日期 / 时间',
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
        'Deleted link to ticket "%s".' => 'Deleted link to ticket "%s".',
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
        'Dropdown' => '下拉',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '动态字段概览限制',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '动态字段的个数',
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
        'Edit customer company' => '',
        'Email Addresses' => '邮件发送地址',
        'Email sent to "%s".' => 'Email sent to "%s".',
        'Email sent to customer.' => 'Email sent to customer.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '启用过滤器',
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
        'Escalation view' => '升级视图',
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
        'Events Ticket Calendar' => '事件日历',
        'Execute SQL statements.' => '执行SQL命令',
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
        'Filter incoming emails.' => '过滤收到的邮件.',
        'First Queue' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'FollowUp for [%s]. %s' => 'FollowUp for [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'Forwarded to "%s".',
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
        'Frontend theme' => '介面风格',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '全文搜索',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'GenericAgent' => '计划任务',
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
        'Go back' => '返回',
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
            '如果启用，所有概况(信息中心、锁定概况、队列概况)将在指定的间隔时间进行显示刷新。',
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
        'Interface language' => '界面语言',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'JavaScript function for the search frontend.' => '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Left' => '',
        'Link agents to groups.' => '链接服务人员到组.',
        'Link agents to roles.' => '链接服务人员到角色.',
        'Link attachments to templates.' => '链接附件至模板',
        'Link customer user to groups.' => '链接用户至组',
        'Link customer user to services.' => '链接用户至服务',
        'Link queues to auto responses.' => '链接队列至自动回复',
        'Link roles to groups.' => '链接角色至组',
        'Link templates to queues.' => '链接模板至队列',
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
        'Locked ticket.' => 'Locked ticket.',
        'Log file for the ticket counter.' => '',
        'Loop-Protection! No auto-response sent to "%s".' => 'Loop-Protection! No auto-response sent to "%s".',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => '管理邮件加密的PGP密钥.',
        'Manage POP3 or IMAP accounts to fetch email from.' => '管理收取邮件的POP3或IMAP帐号.',
        'Manage S/MIME certificates for email encryption.' => '管理邮件的S/MIME加密证书.',
        'Manage existing sessions.' => '管理当前登录会话.',
        'Manage support data.' => '',
        'Manage system registration.' => '管理系统注册',
        'Manage tasks triggered by event or time based execution.' => '管理基于事件或时间触发的任务',
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
        'Multiselect' => '多选',
        'My Services' => '我的服务',
        'My Tickets' => '我的工单',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
        'New Window' => '',
        'New owner is "%s" (ID=%s).' => 'New owner is "%s" (ID=%s).',
        'New process ticket' => '新的流程工单',
        'New responsible is "%s" (ID=%s).' => 'Archive state changed: "%s"',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'None' => '',
        'Notification sent to "%s".' => 'Notification sent to "%s".',
        'Number of displayed tickets' => '显示工单个数',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'Old: "%s" New: "%s"',
        'Online' => '在线',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Out Of Office' => '不在办公室',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => '升级工单概况',
        'Overview Refresh Time' => '概况刷新间隔',
        'Overview of all open Tickets.' => '',
        'PGP Key Management' => 'PGP密钥管理',
        'PGP Key Upload' => '上传PGP密钥',
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
        'Picture-Upload' => '图片上传',
        'PostMaster Filters' => '收件过滤器',
        'PostMaster Mail Accounts' => '邮件接收地址',
        'Process Information' => '进程信息',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '进程ID',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '以矩阵的形势概述不同状态和不同队列的工单',
        'Queue view' => '队列视图',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => '刷新间隔',
        'Removed subscription for user "%s".' => 'Removed subscription for user "%s".',
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
        'Roles <-> Groups' => '角色 <-> 组',
        'Run file based generic agent jobs (Note: module name need needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '流程工单',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => '上传的S/MIME证书',
        'SMS' => '',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen' => '',
        'Search Customer' => '搜索用户',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Second Queue' => '',
        'Select your frontend Theme.' => '界面主题.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => '给用户和服务人员发送通知',
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
        'Service view' => '服务视图',
        'Set minimum loglevel. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages.' =>
            '',
        'Set sender email addresses for this system.' => '为系统设置发件人的邮件地址.',
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
        'Skin' => '皮肤',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
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
        'Stat#' => '统计#',
        'Status view' => '状态视图',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'System Maintenance' => '',
        'System Request (%s).' => 'System Request (%s).',
        'Templates <-> Queues' => '模板 <-> 队列',
        'Textarea' => '文本块',
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
        'Ticket Queue Overview' => '工单队列',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
        'Ticket notifications' => '',
        'Ticket overview' => '工单一览',
        'TicketNumber' => '工单编号',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => '',
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
        'Unlocked ticket.' => 'Unlocked ticket.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => '更新或安装系统的软件包或模块.',
        'Updated SLA to %s (ID=%s).' => 'Updated SLA to %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Updated Service to %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Updated Type to %s (ID=%s).',
        'Updated: %s' => 'Updated: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Updated: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
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
        'View performance benchmark results.' => '查看性能基准测试结果.',
        'View system log messages.' => '查看系统日志信息',
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
            '您的最常用队列，如果您设置了邮件通知，您将会得到该队列的状态通知.',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            '',

    };
    # $$STOP$$
    return;
}

1;
