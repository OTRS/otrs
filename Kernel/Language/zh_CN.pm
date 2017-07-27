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
    $Self->{Completeness}        = 0.998183652875883;

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
        'Done' => '完成',
        'Cancel' => '取消',
        'Reset' => '重置',
        'more than ... ago' => '在...之前',
        'in more than ...' => '不超过...',
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
        'quarter' => '一刻钟',
        'quarter(s)' => '一刻钟',
        'half-year' => '半年',
        'half-year(s)' => '半年',
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
        'Example' => '样例',
        'Examples' => '样例',
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
        'Unlink' => '取消链接',
        'Linked' => '已链接',
        'Link (Normal)' => '普通链接',
        'Link (Parent)' => '父链接',
        'Link (Child)' => '子链接',
        'Normal' => '普通',
        'Parent' => '父',
        'Child' => '子',
        'Hit' => '点击',
        'Hits' => '点击数',
        'Text' => '文本',
        'Standard' => '标准',
        'Lite' => '简洁',
        'User' => '用户',
        'Username' => '用户名',
        'Language' => '语言',
        'Languages' => '语言',
        'Password' => '密码',
        'Preferences' => '偏好设置',
        'Salutation' => '问候语',
        'Salutations' => '问候语',
        'Signature' => '签名',
        'Signatures' => '签名',
        'Customer' => '客户',
        'CustomerID' => 'CustomerID',
        'CustomerIDs' => 'CustomerIDs',
        'customer' => '客户',
        'agent' => '服务人员',
        'system' => '系统',
        'Customer Info' => '客户信息',
        'Customer Information' => '客户信息',
        'Customer Companies' => '客户单位',
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
        'Change' => '变更',
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
        'Created' => '已创建',
        'Created by' => '创建人',
        'Changed' => '修改于',
        'Changed by' => '修改人',
        'Search' => '搜索',
        'and' => '和',
        'between' => '在...之间',
        'before/after' => '在...之前/之后',
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
        'Show Tree Selection' => '显示树状选项',
        'The field content is too long!' => '字段值太长了！',
        'Maximum size is %s characters.' => '最多%s个字符。',
        'This field is required or' => '这个字段是必填的',
        'New message' => '新消息',
        'New message!' => '新消息!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            '请答复工单，然后返回到队列视图!',
        'You have %s new message(s)!' => '您有%s条新消息!',
        'You have %s reminder ticket(s)!' => '您有%s个工单提醒!',
        'The recommended charset for your language is %s!' => '当前语言推荐的字符集是%s!',
        'Change your password.' => '修改你的密码。',
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
            '认证成功，但是后端没有发现此客户的记录，请联系你的管理员。',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '这个e-mail地址已经存在，请直接登录或重置密码。',
        'Logout' => '退出',
        'Logout successful. Thank you for using %s!' => '成功退出，谢谢使用%s！',
        'Feature not active!' => '功能尚未激活!',
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
        'Database already contains data - it should be empty!' => '数据库中已包含数据 - 应该清空它！',
        'Login is needed!' => '需要先登录!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '当前正在执行计划内的系统维护，暂时无法登录。',
        'Password is needed!' => '需要密码!',
        'Take this Customer' => '取得这个客户',
        'Take this User' => '取得这个客户联系人',
        'possible' => '可能',
        'reject' => '拒绝',
        'reverse' => '倒序',
        'Facility' => '设施',
        'Time Zone' => '时区',
        'Pending till' => '挂起至',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '不要使用OTRS系统超级用户帐号! 请创建并使用新的服务人员帐号。',
        'Dispatching by email To: field.' => '按收件人(To:)分派。',
        'Dispatching by selected Queue.' => '按所选队列分派。',
        'No entry found!' => '无内容!',
        'Session invalid. Please log in again.' => '会话无效，请重新登录。',
        'Session has timed out. Please log in again.' => '会话超时，请重新登录。',
        'Session limit reached! Please try again later.' => '会话数量已超，请过会再试。',
        'No Permission!' => '无权限!',
        '(Click here to add)' => '(点击此处添加)',
        'Preview' => '预览',
        'Package not correctly deployed! Please reinstall the package.' =>
            '软件包未正确安装！请重新安装软件包。',
        '%s is not writable!' => '%s不可写的!',
        'Cannot create %s!' => '无法创建%s!',
        'Check to activate this date' => '选中它，以便激活这个日期',
        'You have Out of Office enabled, would you like to disable it?' =>
            '你已设置为不在办公室，是否取消它?',
        'News about OTRS releases!' => 'OTRS版本新闻',
        'Go to dashboard!' => '进入仪表板！',
        'Customer %s added' => '客户%s已添加',
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
        'Customer updated!' => '客户已更新！',
        'Customer company added!' => '客户单位已添加！',
        'Customer company updated!' => '客户单位已更新！',
        'Note: Company is invalid!' => '注意：客户单位无效！',
        'Mail account added!' => '邮件账号已添加！',
        'Mail account updated!' => '邮件账号已更新！',
        'System e-mail address added!' => '系统邮件地址已添加！',
        'System e-mail address updated!' => '系统邮件地址已更新！',
        'Contract' => '合同',
        'Online Customer: %s' => '在线客户联系人: %s',
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
        'uninstalled' => '已卸载',
        'Security Note: You should activate %s because application is already running!' =>
            '安全注意事项: 因为此系统已经在运行，您应该激活%s！',
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
            '这个email地址无法注册，请联系支持人员。',
        'New account created. Sent login information to %s. Please check your email.' =>
            '帐户创建成功。登录信息发送到%s，请查收邮件。',
        'Please press Back and try again.' => '请返回再试一次。',
        'Sent password reset instructions. Please check your email.' => '密码重置说明已发送，请检查邮件。',
        'Sent new password to %s. Please check your email.' => '新密码已发送到%s，请检查邮件。',
        'Upcoming Events' => '即将发生的事件',
        'Event' => '事件',
        'Events' => '事件',
        'Invalid Token!' => '无效的标记',
        'more' => '更多',
        'Collapse' => '收起',
        'Shown' => '显示',
        'Shown customer users' => '显示客户联系人',
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
        'Font Color' => '字体颜色',
        'Background Color' => '背景色',
        'Remove Formatting' => '删除格式',
        'Show/Hide Hidden Elements' => '显示/隐藏 隐藏元素',
        'Align Left' => '左对齐',
        'Align Center' => '居中对齐',
        'Align Right' => '右对齐',
        'Justify' => '两端对齐',
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
        'OTRS Daemon is not running.' => 'OTRS守护进程没有运行。',
        'Can\'t contact registration server. Please try again later.' => '不能连接到注册服务器，请稍后重试。',
        'No content received from registration server. Please try again later.' =>
            '注册服务器未返回有效信息，请稍后重试。',
        'Problems processing server result. Please try again later.' => '处理服务器返回信息时出现问题，请稍后重试。',
        'Username and password do not match. Please try again.' => '用户名与密码不匹配，请重试。',
        'The selected process is invalid!' => '所选择的流程无效!',
        'Upgrade to %s now!' => '现在就更新到 %s',
        '%s Go to the upgrade center %s' => '%s 进入升级中心 %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '有关 %s 的许可证已过期, 请与 %s 联络续约或购买服务合同! 谢谢',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '您的%s有新版本可用，但是与当前的框架版本不兼容！请先升级当前的框架版本！',
        'Your system was successfully upgraded to %s.' => '你的系统已成功更新到 %s',
        'There was a problem during the upgrade to %s.' => '升级到%s的过程中出现问题。',
        '%s was correctly reinstalled.' => '%s 已经成功重装。',
        'There was a problem reinstalling %s.' => '重装 %s 时遇到了一个问题。',
        'Your %s was successfully updated.' => '你的 %s 已经成功更新。',
        'There was a problem during the upgrade of %s.' => '升级 %s 时遇到了一个问题。',
        '%s was correctly uninstalled.' => '%s 已经成功卸载。',
        'There was a problem uninstalling %s.' => '卸载 %s 时遇到了一个问题。',
        'Enable cloud services to unleash all OTRS features!' => '启用云服务以激活OTRS的所有功能！',

        # Template: AAACalendar
        'New Year\'s Day' => '新年',
        'International Workers\' Day' => '五一劳动节',
        'Christmas Eve' => '平安夜',
        'First Christmas Day' => '圣诞节的第一天',
        'Second Christmas Day' => '圣诞节的第二天',
        'New Year\'s Eve' => '除夕',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS作为服务请求方',
        'OTRS as provider' => 'OTRS作为服务提供方',
        'Webservice "%s" created!' => 'Web服务“%s”已创建！',
        'Webservice "%s" updated!' => 'Web服务“%s”已更新！',

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
        'Preferences updated successfully!' => '偏好设置更新成功！',
        'User Profile' => '用户配置文件',
        'Email Settings' => '邮件设置',
        'Other Settings' => '其它设置',
        'Notification Settings' => '通知设置',
        'Change Password' => '修改密码',
        'Current password' => '当前密码',
        'New password' => '新密码',
        'Verify password' => '重复新密码',
        'Spelling Dictionary' => '拼写检查字典',
        'Default spelling dictionary' => '默认拼写检查字典',
        'Max. shown Tickets a page in Overview.' => '单页最大工单数。',
        'The current password is not correct. Please try again!' => '当前密码不正确，请重新输入！',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            '无法修改密码。新密码不一致，请重新输入！',
        'Can\'t update password, it contains invalid characters!' => '无法修改密码，密码不能包含非法字符！',
        'Can\'t update password, it must be at least %s characters long!' =>
            '无法修改密码，密码至少需要%s个字符！',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            '无法修改密码，密码必须包含至少2个小写和2个大写字符！',
        'Can\'t update password, it must contain at least 1 digit!' => '无法修改密码，密码至少需要1个数字字符！',
        'Can\'t update password, it must contain at least 2 characters!' =>
            '无法修改密码，密码至少需要2个字符！',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            '无法修改密码，该密码已使用过。请选择一个新密码！',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '选择CSV文件（统计和搜索）中使用的分隔符。如果不指定，系统将使用当前语言的默认分隔符。',
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
        'Service Level Agreement' => '服务级别协议',
        'Service Level Agreements' => '服务级别协议',
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
        'If it is not displayed correctly,' => '如果没有正确地显示,',
        'This is a' => '这是一个',
        'to open it in a new window.' => '在新窗口中打开它',
        'This is a HTML email. Click here to show it.' => '这是一封HTML格式邮件，点击这里显示。',
        'Free Fields' => '自定义字段',
        'Merge' => '合并',
        'merged' => '已合并',
        'closed successful' => '成功关闭',
        'closed unsuccessful' => '失败关闭',
        'Locked Tickets Total' => '锁定工单总数',
        'Locked Tickets Reminder Reached' => '提醒过的锁定工单数',
        'Locked Tickets New' => '新的锁定工单数',
        'Responsible Tickets Total' => '负责的工单总数',
        'Responsible Tickets New' => '负责的新工单数',
        'Responsible Tickets Reminder Reached' => '提醒过的负责的工单数',
        'Watched Tickets Total' => '关注的工单总数',
        'Watched Tickets New' => '关注的新工单数',
        'Watched Tickets Reminder Reached' => '关注且提醒过的工单数',
        'All tickets' => '所有工单',
        'Available tickets' => '未锁定的工单',
        'Escalation' => '升级',
        'last-search' => '上次搜索',
        'QueueView' => '队列视图',
        'Ticket Escalation View' => '工单升级视图',
        'Message from' => '消息来自',
        'End message' => '消息结束',
        'Forwarded message from' => '已转发的消息来自',
        'End forwarded message' => '转发消息结束',
        'Bounce Article to a different mail address' => '将邮件退回到另一个邮箱地址',
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
        'pending auto close+' => '等待自动成功关闭',
        'pending auto close-' => '等待自动失败关闭',
        'email-external' => ' (邮件-外部)',
        'email-internal' => ' (邮件-内部)',
        'note-external' => ' (备注-外部)',
        'note-internal' => ' (备注-内部)',
        'note-report' => ' (备注-报告)',
        'phone' => ' (电话)',
        'sms' => '短信',
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
        'auto reply/new ticket' => '自动回复/新建工单',
        'Create' => '创建',
        'Answer' => '回复',
        'Phone call' => '电话',
        'Ticket "%s" created!' => '工单“%s”已创建!',
        'Ticket Number' => '工单编号',
        'Ticket Object' => '工单对象',
        'No such Ticket Number "%s"! Can\'t link it!' => '编号为“%s”的工单不存在，不能链接!',
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
        'Remove from list of watched tickets' => '从关注工单列表中移除',
        'Add to list of watched tickets' => '添加到关注工单列表',
        'Email-Ticket' => '邮件工单',
        'Create new Email Ticket' => '创建邮件工单',
        'Phone-Ticket' => '电话工单',
        'Search Tickets' => '搜索工单',
        'Customer Realname' => '客户联系人真实姓名',
        'Customer History' => '客户历史',
        'Edit Customer Users' => '编辑客户联系人',
        'Edit Customer' => '编辑客户',
        'Bulk Action' => '批量操作',
        'Bulk Actions on Tickets' => '工单批量操作',
        'Send Email and create a new Ticket' => '发送邮件并创建新工单',
        'Create new Email Ticket and send this out (Outbound)' => '创建邮件工单(主动)',
        'Create new Phone Ticket (Inbound)' => '创建电话工单(接电话)',
        'Address %s replaced with registered customer address.' => '%s地址已被客户联系人注册的地址所替换',
        'Customer user automatically added in Cc.' => '客户联系人被自动地添加到Cc中.',
        'Overview of all open Tickets' => '所有处理中的工单',
        'Locked Tickets' => '锁定的工单',
        'My Locked Tickets' => '我锁定的工单',
        'My Watched Tickets' => '我关注的工单',
        'My Responsible Tickets' => '我负责的工单',
        'Watched Tickets' => '关注的工单',
        'Watched' => '已关注',
        'Watch' => '关注',
        'Unwatch' => '取消关注',
        'Lock it to work on it' => '锁定并处理工单',
        'Unlock to give it back to the queue' => '解锁并释放工单到队列',
        'Show the ticket history' => '显示工单历史信息',
        'Print this ticket' => '打印工单',
        'Print this article' => '打印信件',
        'Split' => '拆分',
        'Split this article' => '拆分信件',
        'Forward article via mail' => '通过邮件转发信件',
        'Change the ticket priority' => '更改工单优先级',
        'Change the ticket free fields!' => '修改工单的自定义字段',
        'Link this ticket to other objects' => '将工单链接到其它对象',
        'Change the owner for this ticket' => '更改工单所有者',
        'Change the  customer for this ticket' => '更改工单客户',
        'Add a note to this ticket' => '添加工单备注',
        'Merge into a different ticket' => '合并到其它工单',
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
        'Ticket %s: first response time is over (%s)!' => '工单%s：首次响应时间已超过(%s)!',
        'Ticket %s: first response time will be over in %s!' => '工单%s: 首次响应时间将在(%s)内超时!',
        'Ticket %s: update time is over (%s)!' => '工单%s: 更新时间已超过(%s)!',
        'Ticket %s: update time will be over in %s!' => '工单%s: 更新时间将在(%s)内超时!',
        'Ticket %s: solution time is over (%s)!' => '工单%s: 解决时间已超过(%s)!',
        'Ticket %s: solution time will be over in %s!' => '工单%s: 解决时间将在(%s)内超时!',
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
            '如果客户有回复且我是此工单的所有者，或者此工单解锁且在我的关注队列中，请通知我。',
        'Send ticket follow up notifications' => '发送工单跟进通知',
        'Ticket lock timeout notification' => '工单锁定超时通知',
        'Send me a notification if a ticket is unlocked by the system.' =>
            '如果工单被系统解锁，请通知我。',
        'Send ticket lock timeout notifications' => '发送工单锁定超时间通知',
        'Ticket move notification' => '工单转移通知',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            '如果工单转移到我的队列，请通知我。',
        'Send ticket move notifications' => '发送工单队列转移通知',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '你最感兴趣的队列。启用此功能后你可以通过邮件获得这些队列的通知信息。',
        'Custom Queue' => '定制队列',
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
        'Ticket watch notification' => '工单关注通知',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            '对于我所关注的工单，请给我发送与工单所有者一样通知.',
        'Send ticket watch notifications' => '发送工单关注通知',
        'Out Of Office Time' => '不在办公室的时间',
        'New Ticket' => '新建工单',
        'Create new Ticket' => '创建工单',
        'Customer called' => '客户致电',
        'phone call' => '电话呼叫',
        'Phone Call Outbound' => '打电话',
        'Phone Call Inbound' => '接电话',
        'Reminder Reached' => '提醒时间已过',
        'Reminder Tickets' => '提醒的工单',
        'Escalated Tickets' => '升级的工单',
        'New Tickets' => '新建工单',
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
        'including subqueues' => '包含子队列',
        'excluding subqueues' => '排除子队列',

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
        'Filter for ACLs' => 'ACL过滤器',
        'Filter' => '过滤器',
        'ACL Name' => 'ACL名称',
        'Actions' => '操作',
        'Create New ACL' => '创建ACL',
        'Deploy ACLs' => '部署ACL',
        'Export ACLs' => '导出ACL',
        'Configuration import' => '导入ACL',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '你可以上传配置文件，以便将ACL导入到系统中。配置文件采用.yml格式，它可以从ACL管理模块中导出。',
        'This field is required.' => '该字段是必须的。',
        'Overwrite existing ACLs?' => '覆盖ACL',
        'Upload ACL configuration' => '上传ACL配置',
        'Import ACL configuration(s)' => '导入ACL配置',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '为了创建ACL，你可以导入ACL配置或从头创建一个全新的ACL。',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '在这里的任何ACL的修改，仅将其保存在系统中。只有在部署ACL后，它才会起作用。',
        'ACLs' => 'ACL',
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
        'documentation' => '文档',
        'Show or hide the content' => '显示或隐藏内容',
        'Edit ACL information' => '编辑ACL信息',
        'Stop after match' => '匹配后停止',
        'Edit ACL structure' => '编辑ACL结构',
        'Save settings' => '保存设置',
        'Save ACL' => '保存访问控制列表',
        'Save' => '保存',
        'or' => '或',
        'Save and finish' => '保存并完成',
        'Do you really want to delete this ACL?' => '您真的想要删除这个ACL吗？',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '该条目中包含子条目。您真的想要删除这个条目及其子条目吗？',
        'An item with this name is already present.' => '名称相同的条目已存在。',
        'Add all' => '添加所有',
        'There was an error reading the ACL data.' => '读取ACL数据时发现一个错误。',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '通过填写表单数据实现ACL控制。创建ACL后，就可在编辑模式中添加ACL配置信息。',

        # Template: AdminAttachment
        'Attachment Management' => '附件管理',
        'Add attachment' => '添加附件',
        'List' => '列表',
        'Download file' => '下载文件',
        'Delete this attachment' => '删除附件',
        'Do you really want to delete this attachment?' => '你是否确定要删除该附件？',
        'Add Attachment' => '添加附件',
        'Edit Attachment' => '编辑附件',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自动响应管理',
        'Add auto response' => '添加自动响应',
        'Add Auto Response' => '添加自动响应',
        'Edit Auto Response' => '编辑自动响应',
        'Response' => '回复内容',
        'Auto response from' => '自动响应的发件人',
        'Reference' => '相关参考',
        'You can use the following tags' => '你可以使用以下的标记',
        'To get the first 20 character of the subject.' => '获取主题的前20个字节',
        'To get the first 5 lines of the email.' => '获取邮件的前五行',
        'To get the name of the ticket\'s customer user (if given).' => '获取工单的客户联系人名字（如果有）。',
        'To get the article attribute' => '获取邮件的属性信息',
        ' e. g.' => '例如',
        'Options of the current customer user data' => '客户联系人资料属性',
        'Ticket owner options' => '工单所有者属性',
        'Ticket responsible options' => '工单负责人属性',
        'Options of the current user who requested this action' => '工单提交者的属性',
        'Options of the ticket data' => '工单数据属性',
        'Options of ticket dynamic fields internal key values' => '工单动态字段内部键值',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '动态字段显示名称，用于下拉选择和复选框',
        'Config options' => '系统配置数据',
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
        'Upgrade to %s' => '升级到 %s',

        # Template: AdminCustomerCompany
        'Customer Management' => '客户管理',
        'Wildcards like \'*\' are allowed.' => '允许使用通配置符，例如\'*\'。',
        'Add customer' => '添加客户',
        'Select' => '选择',
        'List (only %s shown - more available)' => '列表 (目前显示%s-显示更多)',
        'List (%s total)' => '列表（总共 %s）',
        'Please enter a search term to look for customers.' => '请输入搜索条件以便检索客户资料.',
        'Add Customer' => '添加客户',

        # Template: AdminCustomerUser
        'Customer User Management' => '客户联系人管理',
        'Back to search results' => '返回到搜索结果',
        'Add customer user' => '添加客户联系人',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '工单的客户历史信息需要有客户联系人，客户界面登录也需要用客户联系人。',
        'Last Login' => '上次登录时间',
        'Login as' => '登陆客户门户',
        'Switch to customer' => '切换到客户联系人',
        'Add Customer User' => '添加客户联系人',
        'Edit Customer User' => '编辑客户联系人',
        'This field is required and needs to be a valid email address.' =>
            '必须输入有效的邮件地址。',
        'This email address is not allowed due to the system configuration.' =>
            '邮件地址不符合系统配置要求。',
        'This email address failed MX check.' => '该邮件域名的MX记录检查无效。',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS问题，请检查你的配置和错误日志文件。',
        'The syntax of this email address is incorrect.' => '该邮件地址语法错误。',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => '管理客户与组的关系',
        'Notice' => '注意',
        'This feature is disabled!' => '该功能已关闭',
        'Just use this feature if you want to define group permissions for customers.' =>
            '该功能用于为客户定义权限组。',
        'Enable it here!' => '打开该功能',
        'Edit Customer Default Groups' => '定义客户的默认组',
        'These groups are automatically assigned to all customers.' => '默认组会自动分配给所有客户。',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '你可能通过配置参数"CustomerGroupAlwaysGroups"定义默认组。',
        'Filter for Groups' => '组过滤器',
        'Just start typing to filter...' => '在此输入过滤字符...',
        'Select the customer:group permissions.' => '选择客户:组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '如果没有选择，就不具备该组的任何权限 (客户不能创建或读取工单)。',
        'Search Results' => '搜索结果',
        'Customers' => '客户',
        'No matches found.' => '没有找到相匹配的.',
        'Groups' => '组',
        'Change Group Relations for Customer' => '此客户属于哪些组',
        'Change Customer Relations for Group' => '哪些客户属于此组',
        'Toggle %s Permission for all' => '全部授予/取消 %s 权限',
        'Toggle %s permission for %s' => '授予/取消 %s 权限给 %s',
        'Customer Default Groups:' => '客户的默认组:',
        'No changes can be made to these groups.' => '不能更改默认组.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => '对于组/队列中的工单具有 \'读\' 的权限',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            '对于组/队列中的工单具有 \'读和写\' 的权限',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => '管理客户与服务之间的关系',
        'Edit default services' => '修改默认服务',
        'Filter for Services' => '服务过滤器',
        'Allocate Services to Customer' => '为此客户选择服务',
        'Allocate Customers to Service' => '选择使用此服务的客户',
        'Toggle active state for all' => '全部激活/不激活状态',
        'Active' => '激活',
        'Toggle active state for %s' => '%s 激活/不激活状态',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '动态字段管理',
        'Add new field for object' => '为对象添加新的字段',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '为了增加一个新的字段，从对象列表中选择一个字段类型，对象定义了字段的范围并且不能在创建后修改。',
        'Dynamic Fields List' => '动态字段列表',
        'Dynamic fields per page' => '每页动态字段个数',
        'Label' => '标记',
        'Order' => '顺序',
        'Object' => '对象',
        'Delete this field' => '删除这个字段',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '您真的想要删除这个动态字段吗? 所有关联的数据将丢失!',
        'Delete field' => '删除字段',
        'Deleting the field and its data. This may take a while...' => '正在删除动态字段和它的数据。这可能会用一些时间...',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '动态字段',
        'Field' => '字段',
        'Go back to overview' => '返回概览',
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
            '可以为字段值指定一个可选的HTTP链接，以便其显示在工单概览和工单详情中。',
        'Link for preview' => '连接预览',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '如果填写了内容，在工单详情窗口中当鼠标移动到这个URL上方时将显示URL的预览。请注意：要使这个功能生效，还需要上面的常规URL字段也填写好了内容。',
        'Restrict entering of dates' => '限制输入日期',
        'Here you can restrict the entering of dates of tickets.' => '在这里可以限制输入工单日期。',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '可选值',
        'Key' => '键',
        'Value' => '值',
        'Remove value' => '删除值',
        'Add value' => '添加值',
        'Add Value' => '添加值',
        'Add empty value' => '添加空值',
        'Activate this option to create an empty selectable value.' => '激活此选项, 创建可选择的空值.',
        'Tree View' => '树形视图',
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
            '定义编辑窗口的列宽（单位：字符）',
        'Check RegEx' => '正则表达式检查',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '您可以在这里指定一个正则表达式来检查值是否符合要求，正则表达式将在编辑器的扩展内存中执行。',
        'RegEx' => '正则表达式',
        'Invalid RegEx' => '无效的正则表达式',
        'Error Message' => '错误消息',
        'Add RegEx' => '添加正则表达式',

        # Template: AdminEmail
        'Admin Notification' => '管理员通知',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '通过此模块，管理员可以给服务人员、组或角色发送消息。',
        'Create Administrative Message' => '创建管理员通知',
        'Your message was sent to' => '你的信息已被发送到',
        'Send message to users' => '发送信息给注册用户',
        'Send message to group members' => '发送信息到组成员',
        'Group members need to have permission' => '组成员需要权限',
        'Send message to role members' => '发送信息到角色成员',
        'Also send to customers in groups' => '同样发送到该组的客户',
        'Body' => '内容',
        'Send' => '发送',

        # Template: AdminGenericAgent
        'Generic Agent' => '自动任务',
        'Add job' => '添加任务',
        'Last run' => '最后运行',
        'Run Now!' => '现在运行!',
        'Delete this task' => '删除这个任务',
        'Run this task' => '执行这个任务',
        'Do you really want to delete this task?' => '你是否确定要删除该任务？',
        'Job Settings' => '任务设置',
        'Job name' => '任务名称',
        'The name you entered already exists.' => '你输入的名称已经存在。',
        'Toggle this widget' => '收起/展开小部件',
        'Automatic execution (multiple tickets)' => '自动执行(针对多个工单)',
        'Execution Schedule' => '执行计划',
        'Schedule minutes' => '计划的分钟',
        'Schedule hours' => '计划的小时',
        'Schedule days' => '计划的天',
        'Currently this generic agent job will not run automatically.' =>
            '目前这个自动任务不会自动运行。',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '若要启用自动执行，则需指定执行的分钟、小时和天！',
        'Event based execution (single ticket)' => '基于事件执行(针对特定工单)',
        'Event Triggers' => '事件触发器',
        'List of all configured events' => '配置的事件列表',
        'Delete this event' => '删除这个事件',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '作为定期自动执行的补充或替代，您可以定义工单事件来触发这个任务的执行。',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '如果工单事件被触发，工单过滤器将对工单进行检查看其条件是否匹配。任务只对匹配的工单发生作用。',
        'Do you really want to delete this event trigger?' => '您真的想要删除这个事件触发器吗？',
        'Add Event Trigger' => '添加事件触发器',
        'Add Event' => '添加事件',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '选择事件对象和事件名称，然的点击"+"按钮，即可添加新的事件。',
        'Duplicate event.' => '复制事件',
        'This event is already attached to the job, Please use a different one.' =>
            '该事件已经附加到任务，请重新选择。',
        'Delete this Event Trigger' => '删除这个事件触发器',
        'Remove selection' => '删除选择',
        'Select Tickets' => '选择工单',
        '(e. g. 10*5155 or 105658*)' => '  例如: 10*5144 或者 105658*',
        '(e. g. 234321)' => '例如: 234321',
        'Customer user' => '客户联系人',
        '(e. g. U5150)' => '例如: U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '在信件中全文检索（例如："Mar*in" or "Baue*"）',
        'Agent' => '服务人员',
        'Ticket lock' => '工单锁定',
        'Create times' => '创建时间',
        'No create time settings.' => '没有创建时间。',
        'Ticket created' => '工单创建时间',
        'Ticket created between' => '工单创建时间（在...之间）',
        'Last changed times' => '最后修改时间',
        'No last changed time settings.' => '没有最后修改时间',
        'Ticket last changed' => '工单最后修改',
        'Ticket last changed between' => '工单最后修改时间（在...之间）',
        'Change times' => '修改时间',
        'No change time settings.' => '没有设置修改时间',
        'Ticket changed' => '工单修改时间',
        'Ticket changed between' => '工单修改时间（在...之间）',
        'Close times' => '关闭时间',
        'No close time settings.' => '没有关闭时间',
        'Ticket closed' => '工单关闭时间',
        'Ticket closed between' => '工单关闭时间（在...之间）',
        'Pending times' => '挂起时间',
        'No pending time settings.' => '没有挂起时间',
        'Ticket pending time reached' => '工单挂起时间已到',
        'Ticket pending time reached between' => '工单挂起时间（在...之间）',
        'Escalation times' => '升级时间',
        'No escalation time settings.' => '没有升级时间',
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
        'New customer user' => '指定客户联系人',
        'New customer ID' => '指定客户ID',
        'New title' => '指定标题',
        'New type' => '指定类型',
        'New Dynamic Field Values' => '指定动态字段值',
        'Archive selected tickets' => '归档选中的工单',
        'Add Note' => '添加备注',
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
        'Save Changes' => '保存更改',
        'Results' => '结果',
        '%s Tickets affected! What do you want to do?' => '%s 个工单将被影响！你确定要这么做?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告：你选择了"删除"指令。所有删除的工单数据将无法恢复。',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '警告：%s 个工单将被影响，但一个任务执行时只能修改 %s 个工单！',
        'Edit job' => '编辑任务',
        'Run job' => '执行任务',
        'Affected Tickets' => '受影响的工单',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Web服务 %s 的通用接口调试器',
        'You are here' => '你在这里',
        'Web Services' => 'Web服务',
        'Debugger' => '调试器',
        'Go back to web service' => '返回到Web服务',
        'Clear' => '清空',
        'Do you really want to clear the debug log of this web service?' =>
            '您真的想要清空该Web服务的调试日志吗？',
        'Request List' => '请求列表',
        'Time' => '时间',
        'Remote IP' => '远程IP',
        'Loading' => '装载中',
        'Select a single request to see its details.' => '选择一个请求，以便查看其详细信息。',
        'Filter by type' => '按类型过滤',
        'Filter from' => '按日期过滤(从)',
        'Filter to' => '按日期过滤(到)',
        'Filter by remote IP' => '按远程IP过滤',
        'Limit' => '限制',
        'Refresh' => '刷新',
        'Request Details' => '请求详细信息',
        'An error occurred during communication.' => '在通讯时发生一个错误。',
        'Show or hide the content.' => '显示或隐藏该内容.',
        'Clear debug log' => '清空调试日志',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '为Web服务 %s 添加新的调用程序',
        'Change Invoker %s of Web Service %s' => '修改调用程序%s(Web服务%s)',
        'Add new invoker' => '添加新的调用程序',
        'Change invoker %s' => '修改调用程序%s',
        'Do you really want to delete this invoker?' => '您真的想要删除这个调用程序吗？',
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
            '异步的事件触发器将由后端的OTRS调度程序守护进程处理（推荐）。',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '同步的事件触发器则是在web请求期间直接处理的。',
        'Save and continue' => '保存并继续',
        'Delete this Invoker' => '删除这个调用程序',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Web服务 %s 的通用接口简单映射',
        'Go back to' => '返回到',
        'Mapping Simple' => '简单映射',
        'Default rule for unmapped keys' => '未映射键的默认规则',
        'This rule will apply for all keys with no mapping rule.' => '这个规则将应用于所有没有映射规则的键。',
        'Default rule for unmapped values' => '未映射值的默认规则',
        'This rule will apply for all values with no mapping rule.' => '这个规则将应用于所有没有映射规则的值。',
        'New key map' => '新的键映射',
        'Add key mapping' => '添加键映射',
        'Mapping for Key ' => '键映射',
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
        'Delete this Key Mapping' => '删除这个键映射',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => 'Web服务 %s 的通用接口XSLT映射',
        'Mapping XML' => 'XML映射',
        'Template' => '模板',
        'The entered data is not a valid XSLT stylesheet.' => '输入的数据不是一个有效的XSLT样式表。',
        'Insert XSLT stylesheet.' => '插入XSLT样式表。',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '为Web服务 %s 添加新的操作',
        'Change Operation %s of Web Service %s' => '为Web服务 %s 修改操作 %s ',
        'Add new operation' => '添加新的操作',
        'Change operation %s' => '修改操作 %s ',
        'Do you really want to delete this operation?' => '您真的想要删除这个操作吗？',
        'Operation Details' => '操作详情',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '这个名称通常用于从一个远程系统调用这个web服务操作。',
        'Please provide a unique name for this web service.' => '请为这个Web服务提供一个唯一的名称。',
        'Mapping for incoming request data' => '映射传入请求数据',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '这个映射将对请求数据进行处理，将它转换为OTRS所期待的数据。',
        'Operation backend' => '操作后端',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '这个OTRS操作后端模块将被调用，以便处理请求、生成响应数据。',
        'Mapping for outgoing response data' => '映射出站响应数据',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '这个映射将对响应数据进行处理，以便将它转换成远程系统所期待的数据。',
        'Delete this Operation' => '删除这个操作',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => 'Web服务 %s 的通用接口传输HTTP::REST',
        'Network transport' => '网络传输',
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
        'Host' => '主机',
        'Remote host URL for the REST requests.' => 'REST请求的远程主机地址',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '例如：https://www.otrs.com:10745/api/v1.0 (最后不带斜杠/)',
        'Controller mapping for Invoker' => '调用程序的控制器映射',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '控制器接受调用程序发送的请求。以“:“作为标记的变量将被数据值和其它传递参数替换。',
        'Valid request command for Invoker' => '调用程序有效的请求命令',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '调用程序用于请求的特定的HTTP命令。',
        'Default command' => '默认命令',
        'The default HTTP command to use for the requests.' => '用于请求的默认HTTP命令',
        'Authentication' => '身份验证',
        'The authentication mechanism to access the remote system.' => '访问远程系统的认证机制。',
        'A "-" value means no authentication.' => '"-"意味着无需认证。',
        'The user name to be used to access the remote system.' => '用于访问远程系统的用户名。',
        'The password for the privileged user.' => '特权用户的密码。',
        'Use SSL Options' => '启用SSL选项',
        'Show or hide SSL options to connect to the remote system.' => '显示或隐藏用来连接远程系统SSL选项。',
        'Certificate File' => '证书文件',
        'The full path and name of the SSL certificate file.' => 'SSL证书文件的完整路径和名称',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => '例如：/opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => '证书密码文件',
        'The full path and name of the SSL key file.' => 'SSL密钥文件的完整路径和名称',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => '例如：/opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => '认证机构(CA)文件',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            '用来验证SSL证书的认证机构证书文件的完整路径和名称。',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => '例如：/opt/otrs/var/certificates/REST/CA/ca.file',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Web服务 %s 的通用接口传输HTTP::SOAP',
        'Endpoint' => '端点',
        'URI to indicate a specific location for accessing a service.' =>
            'URI用来表示访问服务的一个特定的位置。',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '例如：http://local.otrs.com:8000/Webservice/Example',
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
        'The character encoding for the SOAP message contents.' => 'SOAP消息内容的字符编码',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '例如：utf-8, latin1, iso-8859-1, cp1250等等。',
        'SOAPAction' => 'SOAP动作',
        'Set to "Yes" to send a filled SOAPAction header.' => '设置"Yes"时，发送填写了的SOAP动作头。',
        'Set to "No" to send an empty SOAPAction header.' => '设置"No"时，发送空白的SOAP动作头。',
        'SOAPAction separator' => 'SOAP动作分隔符',
        'Character to use as separator between name space and SOAP method.' =>
            '作为命名空间和SOAP方法之间分隔符的字符。',
        'Usually .Net web services uses a "/" as separator.' => '通常.Net的Web服务使用斜杠"/"作为分隔符。',
        'Proxy Server' => '代理服务器',
        'URI of a proxy server to be used (if needed).' => '代理服务器的URI(如果使用代理)。',
        'e.g. http://proxy_hostname:8080' => '例如：http://proxy_hostname:8080',
        'Proxy User' => '代理用户',
        'The user name to be used to access the proxy server.' => '访问代理服务器的用户名。',
        'Proxy Password' => '代理密码',
        'The password for the proxy user.' => '代理用户的密码。',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'SSL证书文件的完整路径和名称(必须采用.p12格式)。',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '例如：/opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => '访问SSL证书的密码',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '用来验证SSL证书的认证机构证书文件的完整路径和名称。',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '例如：/opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => '认证机构(CA)目录',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '认证机构目录的完整路径，文件系统中存储CA证书的地方。',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '例如：/opt/otrs/var/certificates/SOAP/CA',
        'Sort options' => '排序选项',
        'Add new first level element' => '添加新的第一级元素',
        'Element' => '元素',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '出站XML字段的排序顺序（下面的函数名称封装结构）-查看关于SOAP传输的文档。',

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
            '必须是有效的Web服务配置文件(YAML格式)。',
        'Import' => '导入',
        'Configuration history' => '配置历史',
        'Delete web service' => '删除Web服务',
        'Do you really want to delete this web service?' => '您真的想要删除这个Web服务吗？',
        'Ready-to-run Web Services' => '运行就绪的WEB服务',
        'Here you can activate ready-to-run web services showcasing our best practices that are a part of %s.' =>
            '你可以在这里激活运行就绪的WEB服务（作为%s的一部分的展示我们的最佳实践）。',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '请注意：这些WEB服务可能依赖于其它仅在某些%s合同级别中才可用的模块(导入时会有详细提示信息)。',
        'Import ready-to-run web service' => '导入运行就绪的WEB服务',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated ready-to-run web services.' =>
            '你想从专家创建的WEB服务中受益吗？升级到%s 就能导入一些复杂的运行就绪的WEB服务。',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '保存配置文件后，页面将再次转到编辑页面。',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '如果你想返回到概览，请点击"返回概览"按钮。',
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
            '操作是各种不同的系统函数，可供远程系统请求调用。',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '调用程序为请求远程Web服务准备数据，并其响应的数据进行处理。',
        'Controller' => '控制器',
        'Inbound mapping' => '入站映射',
        'Outbound mapping' => '出站映射',
        'Delete this action' => '删除这个动作',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '至少有一个 %s 的控制器未被激活或根本就不存在，请检查控制器注册或删除这个 %s',
        'Delete webservice' => '删除Web服务',
        'Delete operation' => '删除操作',
        'Delete invoker' => '删除调用程序',
        'Clone webservice' => '克隆Web服务',
        'Import webservice' => '导入Web服务',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Web服务 %s 通用接口配置历史',
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
        'total' => '总共',
        'Add Group' => '添加组',
        'Edit Group' => '编辑组',

        # Template: AdminLog
        'System Log' => '系统日志',
        'Here you will find log information about your system.' => '查看系统日志信息。',
        'Hide this message' => '隐藏此消息',
        'Recent Log Entries' => '最近的日志条目',

        # Template: AdminMailAccount
        'Mail Account Management' => '邮件帐户管理',
        'Add mail account' => '添加邮件帐户',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            '接收到的邮件将被分派到邮件接收地址所指定的队列中!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            '如果邮件接收地址被设置为"信任"，OTRS将对邮件信头中现有的X-OTRS标记执行相应的处理操作 (例如，设置工单优先级)！而邮箱管理员过滤总是要执行的，与邮件接收地址是否被设置为"信认"无关。',
        'Delete account' => '删除帐号',
        'Fetch mail' => '查收邮件',
        'Add Mail Account' => '添加邮件帐号',
        'Example: mail.example.com' => '样例：mail.example.com',
        'IMAP Folder' => 'IMAP文件夹',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '仅当你打算从其它文件夹(非INBOX)读取邮件时，才有必要修改此项.',
        'Trusted' => '是否信任',
        'Dispatching' => '分派',
        'Edit Mail Account' => '编辑邮件帐号',

        # Template: AdminNavigationBar
        'Admin' => '系统管理',
        'Agent Management' => '服务人员管理',
        'Queue Settings' => '队列设置',
        'Ticket Settings' => '工单设置',
        'System Administration' => '系统管理员',
        'Online Admin Manual' => '管理员在线手册',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '工单通知管理',
        'Add notification' => '添加通知',
        'Export Notifications' => '导出通知',
        'Configuration Import' => '导入通知',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '在这里你可以上传一个配置文件以便导入工单通知，必须是与工单通知模块导出的文件一样的.yml格式。',
        'Overwrite existing notifications?' => '覆盖已存在的通知?',
        'Upload Notification configuration' => '上传通知配置',
        'Import Notification configuration' => '导入通知配置',
        'Delete this notification' => '删除通知',
        'Do you really want to delete this notification?' => '您真的想要删除这个通知?',
        'Add Notification' => '添加通知',
        'Edit Notification' => '编辑通知',
        'Show in agent preferences' => '在服务人员偏好设置里显示',
        'Agent preferences tooltip' => '服务人员偏好设置提示',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '这个信息将会在服务人员偏好设置窗口作为这个通知的提示信息显示。',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '在这里你可以选择哪个事件将会触发这个通知，下面的工单过滤器可以选择符合特定条件的工单。',
        'Ticket Filter' => '工单过滤器',
        'Article Filter' => '信件过滤器',
        'Only for ArticleCreate and ArticleSend event' => '仅对ArticleCreate和ArticleSend事件',
        'Article type' => '信件类型',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '如果ArticleCreate或ArticleSend被用作触发事件，你还需要指定信件过滤条件，请至少选择一个信件过滤字段。',
        'Article sender type' => '信件发送人类型',
        'Subject match' => '主题匹配',
        'Body match' => '内容匹配',
        'Include attachments to notification' => '通知包含附件',
        'Recipients' => '接收人',
        'Send to' => '发送给',
        'Send to these agents' => '发送给服务人员',
        'Send to all group members' => '发送给组的所有成员',
        'Send to all role members' => '发送给角色的所有成员',
        'Send on out of office' => '不在办公室也发送',
        'Also send if the user is currently out of office.' => '用户设置了不在办公室时仍然发送。',
        'Once per day' => '一天一次',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '每个工单的通知使用选择的方式一天只发送一次。',
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
        'No data found' => '没有找到数据。',
        'No notification method found.' => '没有找到通知方法。',
        'Notification Text' => '通知内容',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '系统中没有或者没有启用这个语言，不需要时可以将通知内容删除。',
        'Remove Notification Language' => '删除通知语言',
        'Message body' => '消息正文',
        'Add new notification language' => '添加通知语言',
        'Do you really want to delete this notification language?' => '您真的要删除这个通知语言吗？',
        'Tag Reference' => '标签参考',
        'Notifications are sent to an agent or a customer.' => '发送给服务人员或客户的通知。',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '获取主题的前20个字符（最新的服务人员信件）',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '获取邮件正文内容前5行（最新的服务人员信件）',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '获取邮件主题的前20个字符（最新的客户信件）',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '获取邮件正文内容前5行（最新的客户信件）',
        'Attributes of the current customer user data' => '客户联系人的属性',
        'Attributes of the current ticket owner user data' => '工单所有者的属性',
        'Attributes of the current ticket responsible user data' => '工单负责人的属性',
        'Attributes of the current agent user who requested this action' =>
            '请示此动作的服务人员的属性',
        'Attributes of the recipient user for the notification' => '通知收件人的属性',
        'Attributes of the ticket data' => '工单的属性',
        'Ticket dynamic fields internal key values' => '工单动态字段内部键值',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '工单动态字段显示值，对下拉式和多项选择字段有用',
        'Example notification' => '通知样例',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '额外的收件人邮件地址',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '你可以使用诸如<OTRS_TICKET_DynamicField_...>之类的OTRS标签来插入当前工单中的值。',
        'Notification article type' => '信件类型',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '如果通知发送给客户或额外的邮件地址时创建一封信件。',
        'Email template' => '邮件模板',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '使用这个模板生成完整的邮件（仅对HTML邮件）。',
        'Enable email security' => '启用电子邮件安全。',
        'Email security level' => '电子邮件安全级别。',
        'If signing key/certificate is missing' => '如果签名密钥/证书丢失了。',
        'If encryption key/certificate is missing' => '如果加密密钥/证书丢失了。',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '管理 %s',
        'Go to the OTRS customer portal' => '访问OTRS客户门户',
        'Downgrade to OTRS Free' => '降级到免费版本',
        'Read documentation' => '阅读文档',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s 定期连接到cloud.otrs.com检查可用更新，并验证合同的有效性。',
        'Unauthorized Usage Detected' => '检测到未经授权的使用',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '该系统所使用的 %s 许可证无效, 请与 %s 联络续约或购买服务合同! 谢谢',
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
        'Package installation requires patch level update of OTRS.' => '软件包安装需要更新OTRS的补丁级别。',
        'Please visit our customer portal and file a request.' => '请访问我们的客户门户并提出请求。',
        'Everything else will be done as part of your contract.' => '一切都将作为您的合同的一部分完成。',
        'Your installed OTRS version is %s.' => '您安装的OTRS版本是%s。',
        'To install the current version of OTRS Business Solution™, you need to update to OTRS %s or higher.' =>
            '要安装当前版本的OTRS Business Solution™，您需要更新到OTRS %s或更高版本。',
        'To install the current version of OTRS Business Solution™, the Maximum OTRS Version is %s.' =>
            '要安装当前版本的OTRS Business Solution™，最高的OTRS版本为%s。',
        'To install this package, the required Framework version is %s.' =>
            '要安装此软件包，所需的框架版本为％s。',
        'Why should I keep OTRS up to date?' => '为什么要保持OTRS是最新的？',
        'You will receive updates about relevant security issues.' => '您将收到有关安全问题的更新。',
        'You will receive updates for all other relevant OTRS issues' => '您将收到所有其他OTRS相关问题的更新',
        'An update for your %s is available! Please update at your earliest!' =>
            '%s 有更新版本可用了！请尽早更新！',
        '%s Correctly Deployed' => '%s 已经正确地部署',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '恭喜，你的%s 已经正确地安装到最新版本！',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '%s 很快就可用了，请过几天再检查一次。',
        'Please have a look at %s for more information.' => '有关更多信息,请查看 %s。',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            'OTRS免费版本是所有功能的基础，继续升级到%s 前请先注册！',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '在从%s 受益之前，请先联系%s 以获得%s 合同。',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '不能通过HTTPS连接到cloud.otrs.com，请确保你的OTRS系统能够通过端口443连接到cloud.otrs.com。',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '要安装此软件包，您需要更新到OTRS %s或更高版本。',
        'To install this package, the Maximum OTRS Version is %s.' => '要安装此软件包，OTRS最高版本为%s。',
        'With your existing contract you can only use a small part of the %s.' =>
            '当前的合同表明你只能使用%s 的小部分功能。',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '如欲发挥%s 的全部优势，请联系%s 升级%s 合同！',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '取消降级并返回',
        'Go to OTRS Package Manager' => '进入 OTRS 软件包管理',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '当前不能降级，因为以下软件包依赖%s：',
        'Vendor' => '提供者',
        'Please uninstall the packages first using the package manager and try again.' =>
            '请在软件包管理模块中先删除这些软件包，然后再试一次。',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            '你打算降级到OTRS免费版本，以下功能特性和相关数据将全部丢失：',
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
        'PGP support is disabled' => 'PGP支持已禁用。',
        'To be able to use PGP in OTRS, you have to enable it first.' => '要在OTRS中使用PGP，你必须首先启用它。',
        'Enable PGP support' => '启用PGP支持',
        'Faulty PGP configuration' => '错误的PGP配置',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '已启用PGP支持，但是相关的配置包含有错误。请使用下面的按钮检查配置。',
        'Configure it here!' => '在这里配置PGP！',
        'Check PGP configuration' => '检查PGP配置',
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
            '您真的想要重新安装该软包吗? 所有该模块的手工设置将丢失.',
        'Go to upgrading instructions' => '转到升级说明',
        'package information' => '软件包信息',
        'Package installation requires a patch level update of OTRS.' => '安装软件包需要将OTRS补丁级别更新',
        'Package update requires a patch level update of OTRS.' => '升级软件包需要将OTRS补丁级别更新',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '如果您是OTRS Business Solution™客户，请访问我们的客户门户并提交请求。',
        'Please note that your installed OTRS version is %s.' => '请注意，您安装的OTRS版本是%s。',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            '安装这个软件包，你需要升级OTRS版本到%s或者更高',
        'This package can only be installed on OTRS version %s or older.' =>
            '这个软件包只能安装在OTRS版本%s或者更低 ',
        'This package can only be installed on OTRS version %s or newer.' =>
            '这个软件包只能安装在OTRS版本%s或者更高',
        'You will receive updates for all other relevant OTRS issues.' =>
            '你将收到所有其他有关OTRS问题的更新',
        'How can I do a patch level update if I don’t have a contract?' =>
            '如果没有合约，我怎么更新补丁级别？',
        'Please find all relevant information within the upgrading instructions at %s.' =>
            '请在升级说明%s中找到所有相关信息。',
        'In case you would have further questions we would be glad to answer them.' =>
            '如果您还有其它问题，我们非常愿意答复您。',
        'Continue' => '继续',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '请确认你的数据库能够接收大于%s MB的数据包（目前能够接收的最大数据包为%s MB）。为了避免程序报错，请调整数据库max_allowed_packet参数。',
        'Install' => '安装',
        'Install Package' => '安装软件包',
        'Update repository information' => '更新软件仓库信息',
        'Cloud services are currently disabled.' => '云服务当前被禁用了。',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™（OTRS验证）不能继续！',
        'Enable cloud services' => '启用云服务',
        'Online Repository' => '在线软件仓库',
        'Module documentation' => '模块文档',
        'Upgrade' => '升级',
        'Local Repository' => '本地软件仓库',
        'This package is verified by OTRSverify (tm)' => '此软件包已通过OTRSverify(tm)的验证',
        'Uninstall' => '卸载',
        'Reinstall' => '重新安装',
        'Features for %s customers only' => '仅%s 才能使用的功能',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '你能从%s 得到以下可选的功能特性，请联系%s 获取更多信息。',
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
        'Primary Key' => '主密钥',
        'Auto Increment' => '自动增加',
        'SQL' => 'SQL',
        'File differences for file %s' => '文件跟%s 有差异',

        # Template: AdminPerformanceLog
        'Performance Log' => '性能日志',
        'This feature is enabled!' => '该功能已启用',
        'Just use this feature if you want to log each request.' => '如果想详细记录每个请求, 您可以使用该功能.',
        'Activating this feature might affect your system performance!' =>
            '启动该功能可能影响您的系统性能',
        'Disable it here!' => '关闭该功能',
        'Logfile too large!' => '日志文件过大',
        'The logfile is too large, you need to reset it' => '日志文件太大，请重置日志文件。',
        'Overview' => '概览',
        'Range' => '范围',
        'last' => '最后',
        'Interface' => '界面',
        'Requests' => '请求',
        'Min Response' => '最快响应',
        'Max Response' => '最慢响应',
        'Average Response' => '平均响应',
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
            '如果你使用了正则表达式，你可以取出()中匹配的值(需采用[***]这种格式)，在设置邮件头的值时使用。',
        'Delete this filter' => '删除此过滤器',
        'Do you really want to delete this filter?' => '你是否确定要删除该过滤器？',
        'Add PostMaster Filter' => '添加邮件过滤器',
        'Edit PostMaster Filter' => '编辑邮件过滤器',
        'A postmaster filter with this name already exists!' => '该邮箱管理员过滤器名称已被使用！',
        'Filter Condition' => '过滤器条件',
        'AND Condition' => '“与”条件',
        'Check email header' => '检查邮件头',
        'Negate' => '求反',
        'Look for value' => '查找值',
        'The field needs to be a valid regular expression or a literal word.' =>
            '该栏位需使用有效的正则表达式或文字。',
        'Set Email Headers' => '设置邮件头',
        'Set email header' => '设置邮件头',
        'Set value' => '设置值',
        'The field needs to be a literal word.' => '该字段需要输入文字。',

        # Template: AdminPriority
        'Priority Management' => '优先级管理',
        'Add priority' => '添加优先级',
        'Add Priority' => '添加优先级',
        'Edit Priority' => '编辑优先级',

        # Template: AdminProcessManagement
        'Process Management' => '流程管理',
        'Filter for Processes' => '流程过滤器',
        'Create New Process' => '创建新的流程',
        'Deploy All Processes' => '部署所有流程',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '你可以上传流程配置文件，以便将流程配置导入到你的系统中。流程配置文件采用.yml格式，它可以从流程管理模块中导出。',
        'Overwrite existing entities' => '覆盖已存在的流程',
        'Upload process configuration' => '上传流程配置',
        'Import process configuration' => '导入流程配置',
        'Ready-to-run Processes' => '就绪的流程',
        'Here you can activate ready-to-run processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '你可以在此激活能展示我们最佳实践的就绪流程，请注意可能需要一些额外的配置。',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated ready-to-run processes.' =>
            '你想从专家创建的流程中受益吗？升级到%s 就能导入一些复杂的运行就绪的流程。',
        'Import ready-to-run process' => '导入就绪的流程',
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
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '一旦你使用这个按钮或链接,您将离开这个界面且当前状态将被自动保存。你想要继续吗?',

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
        'The selected permission does not exist.' => '选择的权限不存在',
        'Required Lock' => '需要锁定',
        'The selected required lock does not exist.' => '选择的需要锁定不存在（无法锁定）。',
        'Submit Advice Text' => '提交按钮的建议文本',
        'Submit Button Text' => '提交按钮的文本',
        'Fields' => '字段',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '用鼠标将左侧列表中的元素拖放到右侧，你可以为这个活动对话框分配字段。',
        'Filter available fields' => '可用字段的过滤器',
        'Available Fields' => '可用的字段',
        'Name: %s' => '名称：%s',
        'Assigned Fields' => '分配的字段',
        'ArticleType' => '信件类型',
        'Display' => '显示',
        'Edit Field Details' => '编辑字段详情',
        'Customer interface does not support internal article types.' => '客户界面不支持内部信件类型。',

        # Template: AdminProcessManagementPath
        'Path' => '路径',
        'Edit this transition' => '编辑这个转换',
        'Transition Actions' => '转换动作',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '用鼠标将左侧列表中的元素拖放到右侧，你可以为这个转换分配转换动作。',
        'Filter available Transition Actions' => '可用转换动作的过滤器',
        'Available Transition Actions' => '可用的转换动作',
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
        'The selected state does not exist.' => '选择的状态不存在',
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
            '您真的想要从画布中删除这个活动吗？不保存并离开此窗口可撤销删除操作。',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您真的想要从画布中删除这个转换吗？不保存并离开此窗口可撤销删除操作。',
        'Hide EntityIDs' => '隐藏实体编号',
        'Delete Entity' => '删除实体',
        'Remove Entity from canvas' => '从画布中删除实体',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '流程中已包括这个活动，你不能重复添加活动。',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '不能删除这个活动，因为它是开始活动。',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '活动已经使用了这个转换，你不能重复添加转换。',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '路径已经使用了这个转换动作，你不能重复添加转换动作。',
        'Remove the Transition from this Process' => '从流程中删除这个转换',
        'No TransitionActions assigned.' => '没有分配转换动作',
        'The Start Event cannot loose the Start Transition!' => '起始事件不能释放起始转换！',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '没有分配活动对话框。请从左侧列表中选择一个活动对话框，并将它拖放到这里。',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '画布上已经有一个未连接的转换。在设置另一个转换之前，请先连接这个转换。',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '在这里，你可以创建新的流程。为了使新流程生效，请务必将流程的状态设置为“激活”，并在完成配置工作后执行部署流程操作。',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '取消并关闭',
        'Start Activity' => '开始活动',
        'Contains %s dialog(s)' => '包含%s 个对话框',
        'Assigned dialogs' => '分配对话框',
        'Activities are not being used in this process.' => '该流程未使用活动',
        'Assigned fields' => '分配的字段',
        'Activity dialogs are not being used in this process.' => '该流程未使用活动对话框',
        'Condition linking' => '条件链接',
        'Conditions' => '条件',
        'Condition' => '条件',
        'Transitions are not being used in this process.' => '该流程未使用转换',
        'Module name' => '模块名称',
        'Transition actions are not being used in this process.' => '该流程未使用转换动作',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '请注意，修改这个转换将影响以下流程',
        'Transition' => '转换',
        'Transition Name' => '转换名称',
        'Conditions can only operate on non-empty fields.' => '条件只能作用于非空字段。',
        'Type of Linking between Conditions' => '条件之间的逻辑关系',
        'Remove this Condition' => '删除这个条件',
        'Type of Linking' => '链接关系',
        'Add a new Field' => '添加新的字段',
        'Remove this Field' => '删除这个字段',
        'And can\'t be repeated on the same condition.' => '同一条件中不能对相同字段使用“和”关系。',
        'Add New Condition' => '添加新的条件',

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
        'Manage Queues' => '队列管理',
        'Add queue' => '添加队列',
        'Add Queue' => '添加队列',
        'Edit Queue' => '编辑队列',
        'A queue with this name already exists!' => '队列名已存在！',
        'Sub-queue of' => '父队列',
        'Unlock timeout' => '解锁超时',
        '0 = no unlock' => '0 = 不解锁',
        'Only business hours are counted.' => '只计算上班时间',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '如果工单被锁定且在解锁超时之前未被关闭，则该工单将被解锁，以便其他服务人员能够处理该工单。',
        'Notify by' => '触发通知阈值',
        '0 = no escalation' => '0 = 不升级  ',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定义的时间之前，服务人员没有对新工单添加任何客户联络(无论是外部邮件或电话)，该工单将升级.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '如果有新的信件，例如客户通过门户或邮件发送跟进信件，则升级更新时间重置。 如果在此所定义的时间之前，服务人员没有对新工单添加任何客户联络(无论是外部邮件或电话)，该工单将升级.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定义的时间之前，工单未被关闭，该工单将升级。',
        'Follow up Option' => '跟进选项',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '如果在工单关闭后跟进会重新处理工单，你是允许、拒绝或者创建新的工单?',
        'Ticket lock after a follow up' => '跟进后自动锁定工单',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '如果客户在工单关闭后发送跟进信件，则将该工单锁定给以前的所有者。',
        'System address' => '系统邮件地址',
        'Will be the sender address of this queue for email answers.' => '回复邮件的发送地址',
        'Default sign key' => '默认签名',
        'The salutation for email answers.' => '回复邮件中的问候语。',
        'The signature for email answers.' => '回复邮件中的签名。',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '管理队列的自动响应',
        'This filter allow you to show queues without auto responses' => '这个过滤器允许显示没有自动响应的队列',
        'Queues without auto responses' => '没有自动响应的队列',
        'This filter allow you to show all queues' => '这个过滤器允许显示所有队列',
        'Show all queues' => '显示所有队列',
        'Filter for Queues' => '队列过滤器',
        'Filter for Auto Responses' => '自动响应过滤器',
        'Auto Responses' => '自动响应',
        'Change Auto Response Relations for Queue' => '修改队列的自动响应关系',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '管理模板与队列的对应关系',
        'Filter for Templates' => '模板过滤器',
        'Templates' => '模板',
        'Change Queue Relations for Template' => '修改模板的队列关系',
        'Change Template Relations for Queue' => '修改队列的模板关系',

        # Template: AdminRegistration
        'System Registration Management' => '系统注册管理',
        'Edit details' => '编辑详细信息',
        'Show transmitted data' => '显示已传输的数据',
        'Deregister system' => '取消系统注册',
        'Overview of registered systems' => '注册系统概述',
        'This system is registered with OTRS Group.' => '本系统已注册到OTRS集团。',
        'System type' => '系统类型',
        'Unique ID' => '唯一ID',
        'Last communication with registration server' => '与注册服务器上一次的通讯',
        'System registration not possible' => '系统注册不可能',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '请注意：如果OTRS守护进程没有正确运行，你就不能注册你的系统！',
        'Instructions' => '说明',
        'System deregistration not possible' => '系统取消注册不可能',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '请注意：如果你正在使用%s 或有一个有效的服务合同，你就不能取消你的系统注册！',
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
        'Please visit our' => '请访问我们的',
        'portal' => '门户',
        'and file a request.' => '并提出请求。',
        'If you deregister your system, you will lose these benefits:' =>
            '如果你取消注册你的系统，你将失去以下好处：',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '为了取消注册你的系统，你需要以OTRS-ID登录。',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => '还没有OTRS-ID吗？',
        'Sign up now' => '现在注册',
        'Forgot your password?' => '忘记密码了吗？',
        'Retrieve a new one' => '获取新的密码',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '注册本系统后，这个数据会经常传送给OTRS Group',
        'Attribute' => '属性',
        'FQDN' => '正式域名',
        'OTRS Version' => 'OTRS版本',
        'Operating System' => '操作系统',
        'Perl Version' => 'Perl版本',
        'Optional description of this system.' => '本系统可选的描述。',
        'Register' => '注册',
        'Deregister System' => '取消系统注册',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '继续这一步将从OTRS集团取消注册本系统。',
        'Deregister' => '取消注册',
        'You can modify registration settings here.' => '你可以在这里修改注册设置。',
        'Overview of transmitted data' => '传输的数据概览',
        'There is no data regularly sent from your system to %s.' => '你的系统还没有定期向%s 发送数据。',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '你的系统至少每3天向%s 发送一次以下数据。',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'JSON格式的数据将通过安全的HTTPS连接进行上传。',
        'System Registration Data' => '系统注册信息',
        'Support Data' => '支持数据',

        # Template: AdminRole
        'Role Management' => '角色管理',
        'Add role' => '添加角色',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '创建一个角色并将组加入角色,然后将角色赋给用户.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '还没有定义角色，请使用“添加”按钮来创建一个新的角色',
        'Add Role' => '添加角色',
        'Edit Role' => '编辑角色',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '管理角色和组的关系',
        'Filter for Roles' => '角色过滤器',
        'Roles' => '角色',
        'Select the role:group permissions.' => '选择角色的组权限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '如果没有选择，角色就不会具有任何权限 (任何工单都看不见)',
        'Change Role Relations for Group' => '为组指定角色权限',
        'Change Group Relations for Role' => '为角色指定组权限',
        'Toggle %s permission for all' => '全部授予/取消 %s 权限',
        'move_into' => '转移到',
        'Permissions to move tickets into this group/queue.' => '将工单转移到这个组/队列的权限',
        'create' => '创建',
        'Permissions to create tickets in this group/queue.' => '在这个组/队列具有创建工单的权限',
        'note' => '备注',
        'Permissions to add notes to tickets in this group/queue.' => '在此组/队列具有添加备注的权限',
        'owner' => '所有者',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '在此组/队列具有变更工单所有者的权限',
        'priority' => '优先级',
        'Permissions to change the ticket priority in this group/queue.' =>
            '在此组/队列具有更改工单优先级的权限',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '管理服务人员与角色的关系',
        'Add agent' => '添加服务人员',
        'Filter for Agents' => '服务人员过滤器',
        'Agents' => '服务人员',
        'Manage Role-Agent Relations' => '管理角色与服务人员的关系',
        'Change Role Relations for Agent' => '为服务人员指定角色',
        'Change Agent Relations for Role' => '为角色指定服务人员',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Add SLA' => '添加SLA',
        'Edit SLA' => '编辑SLA',
        'Please write only numbers!' => '仅可填写数字！',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'SMIME support is disabled' => '已禁用SMIME支持。',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '要在OTRS中使用SMIME，你必须首先启用它。',
        'Enable SMIME support' => '启用SMIME支持',
        'Faulty SMIME configuration' => '错误的SMIME配置',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '已启用SMIME支持，但是相关的配置包含有错误。请使用下面的按钮检查配置。',
        'Check SMIME configuration' => '检查SMIME配置',
        'Add certificate' => '添加证书',
        'Add private key' => '添加私匙',
        'Filter for certificates' => '证书过滤器',
        'Filter for S/MIME certs' => 'S/MIME证书过滤器',
        'To show certificate details click on a certificate icon.' => '点击证书图标可显示证书详细信息。',
        'To manage private certificate relations click on a private key icon.' =>
            '点击私钥图标可管理私钥证书关系。',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '你可以在这里添加私钥关系，这些关系将嵌入到邮件的S/MIME签名中。',
        'See also' => '参见',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '这样你能够直接编辑文件系统中的证书和私匙。',
        'Hash' => '哈希',
        'Handle related certificates' => '处理关联的证书',
        'Read certificate' => '读取证书',
        'Delete this certificate' => '删除这个证书',
        'Add Certificate' => '添加证书',
        'Add Private Key' => '添加私钥',
        'Secret' => '机密',
        'Related Certificates for' => '关联证书',
        'Delete this relation' => '删除这个关联',
        'Available Certificates' => '可用的证书',
        'Relate this certificate' => '关联这个证书',

        # Template: AdminSMIMECertRead
        'Close dialog' => '关闭对话',
        'Certificate details' => '证书详细信息',

        # Template: AdminSalutation
        'Salutation Management' => '问候语管理',
        'Add salutation' => '添加问候语',
        'Add Salutation' => '添加问候语',
        'Edit Salutation' => '编辑问候语',
        'e. g.' => '例如：',
        'Example salutation' => '问候语样例',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => '需要启用安全模式！',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '在初始安装结束后，通常都设置系统为安全模式。',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '如果安全模式没有激活，可在系统运行时通过系统配置激活安全模式。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL查询窗口',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '你可以在这里输入SQL语句直接发送给数据库。不能修改表的内容，只允许select查询语句。',
        'Here you can enter SQL to send it directly to the application database.' =>
            '你可以在这里输入SQL语句直接发送给数据库。',
        'Only select queries are allowed.' => '只允许select查询语句。',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL查询的语法有一个错误，请核对。',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '至少缺失一个参数，请检查。',
        'Result format' => '结果格式',
        'Run Query' => '执行查询',
        'Query is executed.' => '查询已执行。',

        # Template: AdminService
        'Service Management' => '服务管理',
        'Add service' => '添加服务',
        'Add Service' => '添加服务',
        'Edit Service' => '编辑服务',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '服务名最大长度为200字符(和子服务一致)',
        'Sub-service of' => '上一级服务',

        # Template: AdminSession
        'Session Management' => '会话管理',
        'All sessions' => '所有会话数',
        'Agent sessions' => '服务人员会话数',
        'Customer sessions' => '客户会话数',
        'Unique agents' => '实际服务人员数',
        'Unique customers' => '实际在线客户数',
        'Kill all sessions' => '终止所有会话',
        'Kill this session' => '终止该会话',
        'Session' => '会话',
        'Kill' => '终止',
        'Detail View for SessionID' => '会话的详细记录，会话ID',

        # Template: AdminSignature
        'Signature Management' => '签名管理',
        'Add signature' => '添加签名',
        'Add Signature' => '添加签名',
        'Edit Signature' => '编辑签名',
        'Example signature' => '签名样例',

        # Template: AdminState
        'State Management' => '工单状态管理',
        'Add state' => '添加工单状态',
        'Please also update the states in SysConfig where needed.' => '请同时在系统配置中需要的地方更新这些工单状态。',
        'Add State' => '添加工单状态',
        'Edit State' => '编辑工单状态',
        'State type' => '工单状态类型',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => '不能将支持数据发送给OTRS集团！',
        'Enable Cloud Services' => '启用云服务',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '这些数据被定期发送到OTRS集团，要停止发送这些数据，请更新你的系统注册配置。',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '你可以通过这个按钮手动发送支持数据：',
        'Send Update' => '发送更新',
        'Sending Update...' => '正在发送更新...',
        'Support Data information was successfully sent.' => '诊断信息已发送成功。',
        'Was not possible to send Support Data information.' => '不能发送支持数据。',
        'Update Result' => '更新结果',
        'Currently this data is only shown in this system.' => '目前支持数据只是在本地系统上显示。',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '点击以下按钮生成支持数据包（包括：系统注册信息、支持数据、已安装软件包列表和本地所有修改过的源代码文件）',
        'Generate Support Bundle' => '生成支持数据包',
        'Generating...' => '正在生成...',
        'It was not possible to generate the Support Bundle.' => '无法生成支持数据包。',
        'Generate Result' => '打包结果',
        'Support Bundle' => '支持数据包',
        'The mail could not be sent' => '邮件没有发送成功。',
        'The support bundle has been generated.' => '支持数据已打包成功。',
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

        # Template: AdminSysConfig
        'SysConfig' => '系统配置',
        'Navigate by searching in %s settings' => '搜索%s 个配置后浏览',
        'Navigate by selecting config groups' => '选择配置分组浏览',
        'Download all system config changes' => '下载所有配置变更(不包括默认配置)',
        'Export settings' => '导出设置',
        'Load SysConfig settings from file' => '从指定文件加载系统配置',
        'Import settings' => '导入设置',
        'Import Settings' => '导入设置',
        'Please enter a search term to look for settings.' => '请输入一个搜索条件来查找相关的设置。',
        'Subgroup' => '子组',
        'Elements' => '元素',

        # Template: AdminSysConfigEdit
        'Edit Config Settings in %s → %s' => '编辑%s → %s中的配置设置',
        'This setting is read only.' => '这个设置是只读的。',
        'This config item is only available in a higher config level!' =>
            '该配置项只在高级配置可用！',
        'Reset this setting' => '恢复到默认设置',
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
        'Group ro' => '组ro',
        'Readonly group' => '只读权限组',
        'New group ro' => '新的只读权限组',
        'Loader' => '加载器',
        'File to load for this frontend module' => '加载前端界面模块的文件',
        'New Loader File' => '新的加载器文件',
        'NavBarName' => '导航栏名称',
        'NavBar' => '导航栏',
        'LinkOption' => '链接选项',
        'Block' => '块',
        'AccessKey' => '快速键',
        'Add NavBar entry' => '添加导航栏条目',
        'NavBar module' => '导航栏模块',
        'Year' => '年',
        'Month' => '月',
        'Day' => '日',
        'Invalid year' => '无效的年份',
        'Invalid month' => '无效的月份',
        'Invalid day' => '无效的日期',
        'Show more' => '显示更多',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => '系统邮件地址管理',
        'Add system address' => '添加系统邮件地址',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '对于所有接收到的邮件，如果在其To或Cc中出现了该系统邮件地址，则将邮件分派到选择的队列中。',
        'Email address' => '邮件地址',
        'Display name' => '显示名称',
        'Add System Email Address' => '添加统邮件地址',
        'Edit System Email Address' => '编辑统邮件地址',
        'This email address is already used as system email address.' => '此电子邮件地址已经用于系统电子邮件',
        'The display name and email address will be shown on mail you send.' =>
            '邮件地址和显示名称将在发送的邮件中显示。',
        'This system address cannot be set to invalid, because it is used in one or more queue(s).' =>
            '该系统地址不能设置为无效，因为它已在一个或多个队列中使用。',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '系统维护管理',
        'Schedule New System Maintenance' => '安排新的系统维护',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '安排一个系统维护期会通知服务人员或用户：本系统在这个时间段停止使用。',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '当到达维护时间之前, 当前登录到系统的用户将会在屏幕上收到一个通知。',
        'Start date' => '开始时间',
        'Stop date' => '结束时间',
        'Delete System Maintenance' => '删除系统维护',
        'Do you really want to delete this scheduled system maintenance?' =>
            '您真的要删除这个已安排的系统维护吗？',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => '编辑系统维护%s',
        'Edit System Maintenance Information' => '编辑系统维护信息',
        'Date invalid!' => '日期无效!',
        'Login message' => '登录消息',
        'Show login message' => '显示登录消息',
        'Notify message' => '通知消息',
        'Manage Sessions' => '管理会话',
        'All Sessions' => '所有会话',
        'Agent Sessions' => '服务人员会话',
        'Customer Sessions' => '客户会话',
        'Kill all Sessions, except for your own' => '杀掉除本会话外的所有会话',

        # Template: AdminTemplate
        'Manage Templates' => '模板管理',
        'Add template' => '添加模板',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '模板就是一些能帮助服务人员快速创建、回复或转发工单的默认文本。',
        'Don\'t forget to add new templates to queues.' => '别忘了将新模板分配给队列。',
        'Do you really want to delete this template?' => '您真的想要删除这个模板吗？',
        'Add Template' => '添加模板',
        'Edit Template' => '编辑模板',
        'A standard template with this name already exists!' => '模板名称已存在！',
        'Create type templates only supports this smart tags' => '“Create创建”类型的模板只支持以下智能标签',
        'Example template' => '模板样例',
        'The current ticket state is' => '当前工单状态是',
        'Your email address is' => '你的邮件地址是',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '管理模板与附件的关系',
        'Filter for Attachments' => '附件过滤器',
        'Change Template Relations for Attachment' => '为附件指定模板',
        'Change Attachment Relations for Template' => '为模板指定附件',
        'Toggle active for all' => '全部激活/不激活',
        'Link %s to selected %s' => '链接 %s 到选中的 %s',

        # Template: AdminType
        'Type Management' => '工单类型管理',
        'Add ticket type' => '添加工单类型',
        'Add Type' => '添加工单类型',
        'Edit Type' => '编辑工单类型',
        'A type with this name already exists!' => '类型名字已存在!',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => '处理工单是需要服务人员的。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '别忘了为新增的服务人员分配组或角色权限！',
        'Please enter a search term to look for agents.' => '请输入一个搜索条件以便查找服务人员。',
        'Last login' => '最后一次登录',
        'Switch to agent' => '切换到服务人员',
        'Add Agent' => '添加服务人员',
        'Edit Agent' => '编辑服务人员',
        'Title or salutation' => '标题或问候语',
        'Firstname' => '名',
        'Lastname' => '姓',
        'A user with this username already exists!' => '这个用户名已被使用!',
        'Will be auto-generated if left empty.' => '如果为空，将自动生成密码。',
        'Start' => '开始',
        'End' => '结束',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '管理服务人员的组权限',
        'Change Group Relations for Agent' => '修改此服务人员的组权限',
        'Change Agent Relations for Group' => '为此组选择服务人员的权限',

        # Template: AgentBook
        'Address Book' => '地址簿',
        'Search for a customer' => '查找客户',
        'Add email address %s to the To field' => '将邮件地址%s添加到To字段',
        'Add email address %s to the Cc field' => '将邮件地址%s添加到Cc字段',
        'Add email address %s to the Bcc field' => '将邮件地址%s添加到Bcc字段',
        'Apply' => '应用',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '客户信息中心',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '客户联系人',

        # Template: AgentCustomerSearch
        'Duplicated entry' => '重复条目',
        'This address already exists on the address list.' => '地址列表已有这个地址。',
        'It is going to be deleted from the field, please try again.' => '将自动删除这个重复的地址，请再试一次。',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '注意：客户是无效的！',
        'Start chat' => '开始聊天',
        'Video call' => '视频通话',
        'Audio call' => '语音通话',

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

        # Template: AgentDashboardCalendarOverview
        'in' => '之内',

        # Template: AgentDashboardCommon
        'Close this widget' => '关闭这个小部件',
        'Available Columns' => '可用的字段',
        'Visible Columns (order by drag & drop)' => '显示的字段(可通过拖放调整顺序)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '升级的工单',

        # Template: AgentDashboardCustomerUserList
        'Customer login' => '客户登录名',
        'Customer information' => '客户信息',
        'Phone ticket' => '电话工单',
        'Email ticket' => '邮件工单',
        '%s open ticket(s) of %s' => '%s个处理中的工单，共%s个',
        '%s closed ticket(s) of %s' => '%s个已关闭的工单，共%s个',
        'New phone ticket from %s' => '来自于%s新的电话工单',
        'New email ticket to %s' => '给%s新的邮件工单',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s可用了！',
        'Please update now.' => '请现在更新。',
        'Release Note' => '版本说明',
        'Level' => '级别',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '发布于%s之前',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '统计widget（小部件）的配置有错误，请检查你的设置。',
        'Download as SVG file' => '下载为SVG格式的文件',
        'Download as PNG file' => '下载为PNG格式的文件',
        'Download as CSV file' => '下载为CSV格式的文件',
        'Download as Excel file' => '下载为Excel格式的文件',
        'Download as PDF file' => '下载为PDF格式的文件',
        'Grouped' => '分组的',
        'Stacked' => '堆叠的',
        'Expanded' => '展开的',
        'Stream' => '流',
        'No Data Available.' => '没有可用数据。',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '请为统计小部件选择有效的图形输出格式。',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '正在为你处理统计数据，请耐心等待。',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '这个统计当前还不能使用，需要统计管理员校正配置。',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '我锁定的工单',
        'My watched tickets' => '我关注的工单',
        'My responsibilities' => '我负责的工单',
        'Tickets in My Queues' => '我队列中的工单',
        'Tickets in My Services' => '我服务的工单',
        'Service Time' => '服务时间',
        'Remove active filters for this widget.' => '移除这个小部件的活动过滤器。',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '合计',

        # Template: AgentDashboardUserOnline
        'out of office' => '不在办公室',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '直到',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => '工单已锁定',
        'Undo & close' => '撤销并关闭',

        # Template: AgentInfo
        'Info' => '详情',
        'To accept some news, a license or some changes.' => '接收新闻、许可证或者一些变更信息。',

        # Template: AgentLinkObject
        'Link Object: %s' => '链接对象: %s',
        'go to link delete screen' => '转到删除链接窗口',
        'Select Target Object' => '选择目标对象',
        'Link object %s with' => '要连接到 %s 的对象为',
        'Unlink Object: %s' => '取消连接对象：%s',
        'go to link add screen' => '转到添加链接窗口',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '检测到未经授权的使用 %s',
        'If you decide to downgrade to OTRS Free, you will lose all database tables and data related to %s.' =>
            '如果决定降级到OTRS免费版本，会丢失%s相关的所有数据库表及其数据。',

        # Template: AgentPreferences
        'Edit your preferences' => '编辑个人设置',
        'Did you know? You can help translating OTRS at %s.' => '你知道吗? 你也可以通过%s帮助翻译 OTRS。',

        # Template: AgentSpelling
        'Spell Checker' => '拼写检查',
        'spelling error(s)' => '拼写错误',
        'Apply these changes' => '应用这些更改',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => '统计»添加',
        'Add New Statistic' => '添加新的统计',
        'Dynamic Matrix' => '动态矩阵',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            '表格式的数据报表，每个单元格包含一个单一的数据点（例如：工单数量）。',
        'Dynamic List' => '动态列表',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            '表格式的数据报表，每一行包含一个实体（例如：一个工单）的数据。',
        'Static' => '静态',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            '不能配置复杂的统计，可能返回非表格化的数据。',
        'General Specification' => '一般设定',
        'Create Statistic' => '创建统计',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => '统计»编辑%s%s — %s',
        'Run now' => '立即运行',
        'Statistics Preview' => '统计预览',
        'Save statistic' => '保存统计',

        # Template: AgentStatisticsImport
        'Statistics » Import' => '统计»导入',
        'Import Statistic Configuration' => '导入统计配置',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => '统计»概览',
        'Statistics' => '统计',
        'Run' => '运行',
        'Edit statistic "%s".' => '编辑统计“%s”。',
        'Export statistic "%s"' => '导出统计“%s”',
        'Export statistic %s' => '导出统计%s',
        'Delete statistic "%s"' => '删除统计“%s”',
        'Delete statistic %s' => '删除统计%s',
        'Do you really want to delete this statistic?' => '您真的要删除这个统计吗？',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => '统计»查看%s%s — %s',
        'Statistic Information' => '统计详细信息',
        'Sum rows' => '行汇总',
        'Sum columns' => '列汇总',
        'Show as dashboard widget' => '以仪表板小部件显示',
        'Cache' => '缓存',
        'This statistic contains configuration errors and can currently not be used.' =>
            '统计包含有错误配置，当前不能使用。',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '修改%s%s%s的自定义文本。',
        'Change Owner of %s%s%s' => '变更工单%s%s%s的所有者',
        'Close %s%s%s' => '关闭%s%s%s',
        'Add Note to %s%s%s' => '添加备注到',
        'Set Pending Time for %s%s%s' => '为%s%s%s添加挂起时间',
        'Change Priority of %s%s%s' => '变更工单%s%s%s的优先级',
        'Change Responsible of %s%s%s' => '变更工单%s%s%s的负责人',
        'All fields marked with an asterisk (*) are mandatory.' => '所有带“*”的字段都是强制要求输入的字段.',
        'Service invalid.' => '服务无效。',
        'New Owner' => '新的所有者',
        'Please set a new owner!' => '请指定新的所有者！',
        'New Responsible' => '新的负责人',
        'Next state' => '工单下一状态',
        'For all pending* states.' => '适用于各种挂起状态。',
        'Add Article' => '添加信件',
        'Create an Article' => '创建一封信件',
        'Inform agents' => '通知服务人员',
        'Inform involved agents' => '通知相关服务人员',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '你可以在这里选择额外的服务人员，以收到这封信件的通知。',
        'Text will also be received by' => '内容也将被以下人员接收到：',
        'Spell check' => '拼写检查',
        'Text Template' => '内容模板',
        'Setting a template will overwrite any text or attachment.' => '设置一个模板将覆盖任何文本或附件。',
        'Note type' => '备注类型',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '退回%s%s%s',
        'Bounce to' => '退回到 ',
        'You need a email address.' => '需要一个邮件地址。',
        'Need a valid email address or don\'t use a local email address.' =>
            '需要一个有效的邮件地址，不可以使用本地邮件地址。',
        'Next ticket state' => '工单下一状态',
        'Inform sender' => '通知发送者',
        'Send mail' => '发送邮件',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '工单批量操作',
        'Send Email' => '发送邮件',
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
        'Remove Ticket Customer' => '移除工单客户',
        'Please remove this entry and enter a new one with the correct value.' =>
            '请删除这个条目并重新输入一个正确的值。',
        'Remove Cc' => '移除Cc',
        'Remove Bcc' => '移除Bcc',
        'Address book' => '地址簿',
        'Date Invalid!' => '日期无效！',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '变更工单%s%s%s的客户联系人',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '创建邮件工单',
        'Example Template' => '模板样例',
        'From queue' => '从队列',
        'To customer user' => '选择客户联系人',
        'Please include at least one customer user for the ticket.' => '请包括至少一个客户联系人。',
        'Select this customer as the main customer.' => '选择这个客户联系人作为主要联系人。',
        'Remove Ticket Customer User' => '移除客户联系人',
        'Get all' => '获取全部',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '%s%s%s的外发邮件',

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
        'History Content' => '历史值',
        'Zoom view' => '详情视图',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '合并%s%s%s',
        'Merge Settings' => '合并设置',
        'You need to use a ticket number!' => '您需要使用一个工单编号!',
        'A valid ticket number is required.' => '需要有效的工单编号。',
        'Need a valid email address.' => '需要有效的邮件地址。',

        # Template: AgentTicketMove
        'Move %s%s%s' => '转移%s%s%s',
        'New Queue' => '新队列',

        # Template: AgentTicketOverviewMedium
        'Select all' => '选择全部',
        'No ticket data found.' => '没有找到工单数据。',
        'Open / Close ticket action menu' => '处理/关闭工单动作的菜单',
        'Select this ticket' => '选择这个工单',
        'First Response Time' => '首次响应时间',
        'Update Time' => '更新时间',
        'Solution Time' => '解决时间',
        'Move ticket to a different queue' => '将工单转移到另一个队列',
        'Change queue' => '更改队列',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => '修改搜索选项',
        'Remove active filters for this screen.' => '清除此屏的过滤器',
        'Tickets per page' => '工单数/页',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '刷新概览视图',
        'Column Filters Form' => '字段过滤器表单',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '拆分为新的电话工单',
        'Save Chat Into New Phone Ticket' => '保存聊天为新的电话工单',
        'Create New Phone Ticket' => '创建电话工单',
        'Please include at least one customer for the ticket.' => '请包括至少一个客户联系人。',
        'To queue' => '队列',
        'Chat protocol' => '聊天协议',
        'The chat will be appended as a separate article.' => '将聊天内容作为单独的信件追加到工单',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '%s%s%s的电话',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '查看%s%s%s的邮件纯文本',
        'Plain' => '纯文本',
        'Download this email' => '下载该邮件',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '创建流程工单',
        'Process' => '流程',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '注册工单到一个流程',

        # Template: AgentTicketSearch
        'Search template' => '搜索模板',
        'Create Template' => '创建模板',
        'Create New' => '创建搜索模板',
        'Profile link' => '按模板搜索',
        'Save changes in template' => '保存变更到模板',
        'Filters in use' => '正在使用的过滤器',
        'Additional filters' => '其他可用的过滤器',
        'Add another attribute' => '增加另一个搜索条件',
        'Output' => '搜索结果格式为',
        'Fulltext' => '全文',
        'Remove' => '移除',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '只搜索From、To、Cc、主题和信件正文，不管其它属性。',
        'CustomerID (complex search)' => 'CustomerID(复合搜索)',
        '(e. g. 234*)' => '(例如： 234*)',
        'CustomerID (exact match)' => 'CustomerID(精确匹配)',
        'Customer User Login (complex search)' => '客户联系人登录名(复合搜索)',
        '(e. g. U51*)' => '(例如：U51*)',
        'Customer User Login (exact match)' => '客户联系人登录名(精确匹配)',
        'Attachment Name' => '附件名',
        '(e. g. m*file or myfi*)' => '（例如：m*file或myfi*）',
        'Created in Queue' => '由队列中创建',
        'Lock state' => '锁定状态',
        'Watcher' => '关注人',
        'Article Create Time (before/after)' => '信件创建时间（在...之前/之后）',
        'Article Create Time (between)' => '信件创建时间（在...之间）',
        'Invalid date' => '无效日期',
        'Ticket Create Time (before/after)' => '工单创建时间（在...之前/之后）',
        'Ticket Create Time (between)' => '工单创建时间（在...之间）',
        'Ticket Change Time (before/after)' => '工单修改时间（在...之前/之后）',
        'Ticket Change Time (between)' => '工单修改时间（在...之间）',
        'Ticket Last Change Time (before/after)' => '工单最后修改时间（在...之前/之后）',
        'Ticket Last Change Time (between)' => '工单最后修改时间（在...之间）',
        'Ticket Close Time (before/after)' => '工单关闭时间（在...之前/之后）',
        'Ticket Close Time (between)' => '工单关闭时间（在...之间）',
        'Ticket Escalation Time (before/after)' => '工单升级时间（在...之前/之后）',
        'Ticket Escalation Time (between)' => '工单升级时间（在...之间）',
        'Archive Search' => '归档搜索',
        'Run search' => '搜索',

        # Template: AgentTicketZoom
        'Article filter' => '信件过滤器',
        'Article Type' => '信件类别 ',
        'Sender Type' => '发送人类型',
        'Save filter settings as default' => '将过滤器设置保存为默认过滤器',
        'Event Type Filter' => '事件类型过滤器',
        'Event Type' => '事件类型',
        'Save as default' => '保存为默认',
        'Archive' => '归档',
        'This ticket is archived.' => '该工单已归档',
        'Note: Type is invalid!' => '注意：类型无效！',
        'Locked' => '锁定状态',
        'Accounted time' => '所用工时',
        'Linked Objects' => '连接的对象',
        'Change Queue' => '改变队列',
        'There are no dialogs available at this point in the process.' =>
            '目前流程中没有可用的活动对话框。',
        'This item has no articles yet.' => '此条目还没有信件。',
        'Ticket Timeline View' => '工单时间轴视图',
        'Article Overview' => '信件概览',
        'Article(s)' => '信件',
        'Page' => '页',
        'Add Filter' => '添加过滤器',
        'Set' => '设置',
        'Reset Filter' => '重置过滤器',
        'Show one article' => '显示单一信件',
        'Show all articles' => '显示所有信件',
        'Show Ticket Timeline View' => '以时间轴视图显示工单',
        'Unread articles' => '未读信件',
        'No.' => 'NO.',
        'Important' => '重要',
        'Unread Article!' => '未读信件!',
        'Incoming message' => '接收的消息',
        'Outgoing message' => '发出的消息',
        'Internal message' => '内部消息',
        'Resize' => '调整大小',
        'Mark this article as read' => '标记该信件为已读',
        'Show Full Text' => '显示详细内容',
        'Full Article Text' => '详细内容',
        'No more events found. Please try changing the filter settings.' =>
            '没有找到更多的事件，请尝试修改过滤器设置。',
        'by' => '由',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '要打开工单里的链接, 你可能需要单击链接的同时按住Ctrl或Cmd或Shift键(取决于您的浏览器和操作系统 ).',
        'Close this message' => '关闭本消息',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '不能打开信件！或许它在另外一个信件页面上打开了？',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '为了保护你的隐私,远程内容被阻挡。',
        'Load blocked content.' => '载入被阻挡的内容。',

        # Template: ChatStartForm
        'First message' => '请一句话描述您的需求',

        # Template: CloudServicesDisabled
        'This feature requires cloud services.' => '这个功能需要启用云服务。',
        'You can' => '你可以',
        'go back to the previous page' => '返回上一页',

        # Template: CustomerError
        'An Error Occurred' => '发生了一个错误',
        'Error Details' => '详细错误信息',
        'Traceback' => '追溯',

        # Template: CustomerFooter
        'Powered by' => '技术支持：',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => '发生了一个或多个错误!',
        'Close this dialog' => '关闭该对话框',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '无法打开弹出窗口，请禁用本应用的弹出窗口拦截设置。',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '如果你现在离开该页, 所有弹出的窗口也随之关闭!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '一个弹出窗口已经打开，你想先关闭它再打开一个吗？',
        'There are currently no elements available to select from.' => '目前没有可供选择的元素。',
        'Please turn off Compatibility Mode in Internet Explorer!' => '请关闭IE的兼容模式！',
        'The browser you are using is too old.' => '你使用的游览器版本太老了。',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS可运行在在大量的游览器中, 请升级到下面任意一个。',
        'Please see the documentation or ask your admin for further information.' =>
            '欲了解更多信息, 请向你的管理询问或参考相关文档.',
        'Switch to mobile mode' => '切换到移动模式',
        'Switch to desktop mode' => '切换到桌面模式',
        'Not available' => '不可用',
        'Clear all' => '清除所有',
        'Clear search' => '清除搜索',
        '%s selection(s)...' => '选择%s...',
        'and %s more...' => '和%s 更多...',
        'Filters' => '过滤器',
        'Confirm' => '确认',
        'You have unanswered chat requests' => '你有未响应的聊天请求',
        'Accept' => '接受',
        'Decline' => '拒绝',
        'An internal error occurred.' => '发生了一个内部错误。',
        'Connection error' => '连接错误',
        'Reload page' => '刷新页面',
        'Your browser was not able to communicate with OTRS properly, there seems to be something wrong with your network connection. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '你的浏览器无法与OTRS正常通讯，可能有网络连接问题。你可以手动刷新页面或者等待浏览器自动重连。',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '连接在临时中断后已重连，因此本页面上的元素可能已无法正常工作。为了能重新正常使用所有的元素，强烈建议刷新本页面。',

        # Template: CustomerLogin
        'JavaScript Not Available' => '没有启用JavaScript',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            '要继续使用 OTRS，请打开浏览器的 JavaScript 功能。',
        'Browser Warning' => '浏览器的警告',
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
        'Request new password' => '请求新密码',
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
        'Logout %s %s' => '退出 %s%s',

        # Template: CustomerRichTextEditor
        'Split Quote' => '拆分引用',
        'Open link' => '打开连接',

        # Template: CustomerTicketMessage
        'Service level agreement' => '服务级别协议',

        # Template: CustomerTicketOverview
        'Welcome!' => '欢迎！',
        'Please click the button below to create your first ticket.' => '请点击下面的按钮创建第一个工单。',
        'Create your first ticket' => '创建第一个工单',

        # Template: CustomerTicketSearch
        'Profile' => '搜索条件',
        'e. g. 10*5155 or 105658*' => '例如: 10*5155 或 105658*',
        'Customer ID' => '客户ID',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => '工单全文搜索 (例如: "John*n" 或 "Will*")',
        'Recipient' => '收件人',
        'Carbon Copy' => '抄送',
        'e. g. m*file or myfi*' => '例如：m*file或myfi*',
        'Types' => '类型',
        'Time restrictions' => '时间查询条件',
        'No time settings' => '没有设置时间',
        'Specific date' => '指定日期',
        'Only tickets created' => '仅工单创建时间',
        'Date range' => '日期范围',
        'Only tickets created between' => '仅工单创建时间区间',
        'Ticket archive system' => '工单归档系统',
        'Save search as template?' => '将搜索保存为模板？',
        'Save as Template?' => '保存为模板吗？',
        'Save as Template' => '保存为模板',
        'Template Name' => '模板名称',
        'Pick a profile name' => '输入模板名称',
        'Output to' => '输出为',

        # Template: CustomerTicketSearchResultShort
        'of' => '在',
        'Search Results for' => '以下条件的搜索结果',
        'Remove this Search Term.' => '移除这个搜索条件',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '从这个工单开始一次聊天',
        'Expand article' => '展开信件',
        'Information' => '信息',
        'Next Steps' => '下一步',
        'Reply' => '回复',
        'Chat Protocol' => '聊天协议',

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
        'Invalid date (need a past date)!' => '无效的日期（需使用过去的日期）！',
        'Previous' => '上一步',
        'Open date selection' => '打开日历',

        # Template: Error
        'An error occurred.' => '发生了一个错误。',
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '真的是一个BUG吗？十个BUG报告有五个起因于错误或不完整的OTRS安装。',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '通过%s，我们的专家通过技术支持和定期安全更新来确保正确安装且后台程序正常。',
        'Contact our service team now.' => '联系服务团队',
        'Send a bugreport' => '发送一个BUG报告',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            '请至少输入一个搜索条件或输入*搜索所有。',
        'Please remove the following words from your search as they cannot be searched for:' =>
            '请移除以下不能用于搜索的词语：',
        'Please check the fields marked as red for valid inputs.' => '请检查标记为红色的字段，需要输入有效的值。',
        'Please perform a spell check on the the text first.' => '请先对文本进行拼写检查。',
        'Slide the navigation bar' => '滑动导航栏',
        'Unavailable for chat' => '不能进行聊天',
        'Available for internal chats only' => '只能进行内部聊天',
        'Available for chats' => '可以进行聊天',
        'Please visit the chat manager' => '请访问聊天管理器',
        'New personal chat request' => '新的私聊请求',
        'New customer chat request' => '新的客户聊天请求',
        'New public chat request' => '新的公共聊天请求',
        'Selected user is not available for chat.' => '不能与选择的用户聊天。',
        'New activity' => '新的聊天活动',
        'New activity on one of your monitored chats.' => '你关注的某个聊天有了新的活动。',
        'Your browser does not support video and audio calling.' => '您的浏览器不支持视频和音频通话。',
        'Selected user is not available for video and audio call.' => '不能与选择的用户进行视频和音频通话。',
        'Target user\'s browser does not support video and audio calling.' =>
            '目标用户的浏览器不支持视频和音频通话。',
        'Do you really want to continue?' => '您真的要继续吗？',
        'Information about the OTRS Daemon' => '关于OTRS守护进程的信息',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            '这个功能需要%s才能使用，请到%s联系我们升级。',
        'Find out more about the %s' => '查找%s的更多信息',

        # Template: Header
        'You are logged in as' => '您已登录为',

        # Template: Installer
        'JavaScript not available' => 'JavaScript没有启用',
        'Step %s' => '第%s步',
        'Database Settings' => '数据库设置',
        'General Specifications and Mail Settings' => '一般设定和邮件配置',
        'Finish' => '完成',
        'Welcome to %s' => '欢迎使用%s',
        'Web site' => '网址',
        'Mail check successful.' => '邮件配置检查成功完成。',
        'Error in the mail settings. Please correct and try again.' => '邮件设置错误, 请修改后再试一次。',

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
        'Database setup successful!' => '数据库设置成功！',

        # Template: InstallerDBStart
        'Install Type' => '安装类型',
        'Create a new database for OTRS' => '为OTRS创建新的数据库',
        'Use an existing database for OTRS' => '使用现有的OTRS数据库',

        # Template: InstallerDBmssql
        'Database name' => '数据库名称',
        'Check database settings' => '测试数据库设置',
        'Result of database check' => '数据库检查结果',
        'Database check successful.' => '数据库检查完成。',
        'Database User' => '数据库用户',
        'New' => '新建',
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
        'Object#' => '对象号',
        'Add links' => '添加链接',
        'Delete links' => '删除链接',

        # Template: Login
        'Lost your password?' => '忘记密码?',
        'Request New Password' => '请求新密码',
        'Back to login' => '重新登录',

        # Template: MetaFloater
        'Scale preview content' => '缩放预览内容',
        'Open URL in new tab' => '在新的标签页打开链接',
        'Close preview' => '关闭预览',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '这个网站不允许被嵌入，无法提供预览。',

        # Template: MobileNotAvailableWidget
        'Feature not available' => '功能不可用',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '抱歉，当前的OTRS不能用于移动终端。如果你想在移动终端上使用，你可以切换到桌面模式或使用普通桌面终端。',

        # Template: Motd
        'Message of the Day' => '今日消息',
        'This is the message of the day. You can edit this in %s.' => '这是今日消息，你可以在文件%s中编辑它的内容。',

        # Template: NoPermission
        'Insufficient Rights' => '没有足够的权限',
        'Back to the previous page' => '返回前一页',

        # Template: Pagination
        'Show first page' => '首页',
        'Show previous pages' => '前一页',
        'Show page %s' => '第%s页',
        'Show next pages' => '后一页',
        'Show last page' => '尾页',

        # Template: PictureUpload
        'Need FormID!' => '需要FormID',
        'No file found!' => '找不到文件！',
        'The file is not an image that can be shown inline!' => '此文件是不是一个可以显示的图像!',

        # Template: PreferencesNotificationEvent
        'Notification' => '通知',
        'No user configurable notifications found.' => '没有找到可以配置的通知。',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '接收通知\'%s\'的消息，通过传输方法\'%s\'。',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '请注意，你不能禁用标记为强制的通知。',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '抱歉，你不能将标记为强制的通知的所有传输方法都禁用掉。',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '抱歉，你不能将本通知的所有传输方法都禁用掉。',

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

        # Template: RichTextEditor
        'Remove Quote' => '移除引用',

        # Template: GeneralSpecificationsWidget
        'Permissions' => '权限',
        'You can select one or more groups to define access for different agents.' =>
            '你可以为不同的服务人员选择一个或多个组以定义访问权限。',
        'Result formats' => '结果格式',
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
        'Preview format:' => '预览格式：',
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
        'Between' => '时间区间',
        'Relative period' => '相对时间段',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '过去完成%s，当前和即将完成%s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            '统计生成后不允许修改这个元素。',

        # Template: StatsParamsWidget
        'Format' => '格式',
        'Exchange Axis' => '转换坐标轴',
        'Configurable params of static stat' => '静态统计的配置参数',
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

        # Template: Test
        'OTRS Test Page' => 'OTRS测试页',
        'Welcome %s %s' => '欢迎使用%s %s',
        'Counter' => '计数器',

        # Template: Warning
        'Go back to the previous page' => '返回前一页',

        # Perl Module: Kernel/Config/Defaults.pm
        'View system log messages.' => '查看系统日志信息',
        'Update and extend your system with software packages.' => '更新或安装系统的软件包或模块。',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '由于未知错误不能导入ACL，请检查OTRS日志以获得更多信息。',
        'The following ACLs have been added successfully: %s' => '下列ACL已经成功添加：%s',
        'The following ACLs have been updated successfully: %s' => '下列ACL已经成功更新：%s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '在添加/更新下列ACL：%s 时出现一些错误，请检查OTRS日志以获得更多信息。',
        'This field is required' => '这个字段是必需的',
        'There was an error creating the ACL' => '创建ACL时出现了一个错误',
        'Need ACLID!' => '需要ACLID',
        'Could not get data for ACLID %s' => '不能获得ACLID为%s 的数据',
        'There was an error updating the ACL' => '更新ACL时出现了一个错误',
        'There was an error setting the entity sync status.' => '设置条目同步状态时出现了一个错误。',
        'There was an error synchronizing the ACLs.' => '部署ACL时出现了一个错误。',
        'ACL %s could not be deleted' => '不能删除ACL %s',
        'There was an error getting data for ACL with ID %s' => '获得ID为%s 的ACL的数据时出现了一个错误',
        'Exact match' => '完全匹配',
        'Negated exact match' => '完全匹配取反',
        'Regular expression' => '正则表达式',
        'Regular expression (ignore case)' => '正则表达式（忽略大小写）',
        'Negated regular expression' => '正则表达式取反',
        'Negated regular expression (ignore case)' => '正则表达式（忽略大小写）取反',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer Company %s already exists!' => '客户单位 %s 已经存在！',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => '创建电话工单',
        'New email ticket' => '创建邮件工单',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '不是有效的字段配置。',
        'Objects configuration is not valid' => '不是有效的对象配置。',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '不能正确地重置动态字段顺序，请检查错误日志以获得更多详细信息。',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '没有定义的子动作。',
        'Need %s' => '需要%s',
        'The field does not contain only ASCII letters and numbers.' => '这个字段不是仅包含ASCII字符和数字。',
        'There is another field with the same name.' => '存在同名的另一字段。',
        'The field must be numeric.' => '这个字段必须是数字。',
        'Need ValidID' => '需要有效的ID',
        'Could not create the new field' => '不能创建这个新字段',
        'Need ID' => '需要ID',
        'Could not get data for dynamic field %s' => '不能获得动态字段%s 的数据',
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
        'archive tickets' => '归档工单',
        'restore tickets from archive' => '从归档中恢复工单',
        'Need Profile!' => '需要配置文件！',
        'Got no values to check.' => '没有检查到值。',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '请移除以下不能用于工单选择的词语：',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '需要WebserviceID！',
        'Could not get data for WebserviceID %s' => '不能获得WebserviceID %s的数据。',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Need InvokerType' => '需要调用程序类型',
        'Invoker %s is not registered' => '调用程序%s 没有注册。',
        'InvokerType %s is not registered' => '调用程序类型 %s 没有注册。',
        'Need Invoker' => '需要调用程序',
        'Could not determine config for invoker %s' => '不能确定调用程序%s 的配置',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Could not get registered configuration for action type %s' => '不能获得动作类型%s 的注册配置。',
        'Could not get backend for %s %s' => '不能获得 %s %s的后端',
        'Could not update configuration data for WebserviceID %s' => '不能更新WebserviceID %s的配置数据',
        'Keep (leave unchanged)' => '保持（保持不变）',
        'Ignore (drop key/value pair)' => '忽略（丢弃键/值对）',
        'Map to (use provided value as default)' => '映射到（使用提供的值作为默认值）',
        'Exact value(s)' => '准确值',
        'Ignore (drop Value/value pair)' => '忽略（丢弃键/值对）',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'Could not find required library %s' => '不能找到需要的库%s',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Need OperationType' => '需要操作类型',
        'Operation %s is not registered' => '操作%s 没有注册',
        'OperationType %s is not registered' => '操作类型%s 没有注册',
        'Need Operation' => '需要操作',
        'Could not determine config for operation %s' => '不能确定操作%s 的配置',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need Subaction!' => '需要子动作！',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '存在同名的另一WEB服务。',
        'There was an error updating the web service.' => '更新WEB服务时出现了一个错误。',
        'Web service "%s" updated!' => 'Web服务“%s”已经更新！',
        'There was an error creating the web service.' => '创建WEB服务时出现了一个错误。',
        'Web service "%s" created!' => 'Web服务“%s”已经创建！',
        'Need Name!' => '需要名称！',
        'Need ExampleWebService!' => '需要WEB服务示例！',
        'Could not read %s!' => '不能读取 %s！',
        'Need a file to import!' => '导入需要一个文件！',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '导入的文件没有有效的YAML内容！请检查OTRS日志以获取详细信息',
        'Web service "%s" deleted!' => 'Web服务“%s”已经删除！',
        'New Web service' => '新的WEB服务',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '没有 WebserviceHistoryID ！',
        'Could not get history data for WebserviceHistoryID %s' => '不能获取WebserviceHistoryID为%s的历史数据',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Notification updated!' => '通知已更新！',
        'Notification added!' => '通知已添加！',
        'There was an error getting data for Notification with ID:%s!' =>
            '获取ID为%s的通知数据时出现了一个错误！',
        'Unknown Notification %s!' => '未知通知 %s！',
        'There was an error creating the Notification' => '创建通知时出现了一个错误',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '由于一个未知错误不能导入通知，请检查OTRS日志以获取更多信息',
        'The following Notifications have been added successfully: %s' =>
            '下列通知已成功添加：%s',
        'The following Notifications have been updated successfully: %s' =>
            '下列通知已成功更新：%s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '添加/更新下列通知时出现错误：%s，请检查OTRS日志以获取更多信息。',
        'Agent who owns the ticket' => '拥有这个工单的服务人员',
        'Agent who is responsible for the ticket' => '对这个工单负责的服务人员',
        'All agents watching the ticket' => '所有关注这个工单的服务人员',
        'All agents with write permission for the ticket' => '所有对这个工单有写权限的服务人员',
        'All agents subscribed to the ticket\'s queue' => '所有关注了工单所在队列的服务人员',
        'All agents subscribed to the ticket\'s service' => '所有关注了工单服务的服务人员',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '所有关注了工单所在队列和工单所属服务的服务人员',
        'Customer of the ticket' => '该工单的客户',
        'Yes, but require at least one active notification method' => '是的，但是需要至少一个激活的通知方法',

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
        'No packages or no new packages found in selected repository.' =>
            '选择的软件仓库中没有软件包或没有新的软件包。',
        'Package not verified due a communication issue with verification server!' =>
            '不能验证软件包，因为与验证服务器无法正常通讯！',
        'Can\'t connect to OTRS Feature Add-on list server!' => '不能连接到OTRS附加功能列表服务器！',
        'Can\'t get OTRS Feature Add-on list from server!' => '不能从服务器获取OTRS附加功能列表！',
        'Can\'t get OTRS Feature Add-on from server!' => '不能从服务器获取OTRS附加功能！',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '没有这个过滤器：%s',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
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
        'Process: %s could not be deleted' => '不能删除流程：%s ',
        'There was an error synchronizing the processes.' => '部署该流程时出现了一个错误',
        'The %s:%s is still in use' => ' %s:%s 仍在使用中',
        'The %s:%s has a different EntityID' => ' %s:%s 有一个不同的EntityID',
        'Could not delete %s:%s' => '不能删除 %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '为 %s 实体： %s 设置实体同步状态时出现了一个错误',
        'Could not get %s' => '不能获取 %s',
        'Need %s!' => '需要 %s！',
        'Process: %s is not Inactive' => '流程： %s 的状态不是‘非活动的’',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '为这个活动生成新的EntityID时出现了一个错误。',
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
        'This subaction is not valid' => '这个子动作无效！',
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
        'fax' => '传真',

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
        'xor' => '异或',
        'String' => '字符串',
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
        'Don\'t use :: in queue name!' => '不要在队列名称中使用双冒号 ::',
        'Click back and change it!' => '点击返回并修改它！',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '没有自动响应的队列',

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

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation updated!' => '问候语已更新！',
        'Salutation added!' => '问候语已添加！',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '不能读取文件%s！',

        # Perl Module: Kernel/Modules/AdminSysConfig.pm
        'Import not allowed!' => '不允许导入！',
        'Need File!' => '需要文件！',
        'Can\'t write ConfigItem!' => '不能写入配置条目！',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '开始日期不能在结束日期之后！',
        'There was an error creating the System Maintenance' => '创建系统维护时出现了一个错误',
        'Need SystemMaintenanceID!' => '需要SystemMaintenanceID！',
        'Could not get data for SystemMaintenanceID %s' => '不能获得SystemMaintenanceID %s的数据',
        'System Maintenance was saved successfully!' => '系统维护成功保存！',
        'Session has been killed!' => '会话已经被kill掉！',
        'All sessions have been killed, except for your own.' => '除了本会话外，所有会话都已经被kill掉！',
        'There was an error updating the System Maintenance' => '更新系统维护时出现了一个错误',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '不能删除系统维护条目：%s！',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '模板已更新！',
        'Template added!' => '模板已添加！',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '需要类型！',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '没有%s 的配置',
        'Statistic' => '统计',
        'No preferences for %s!' => '没有%s的偏好设置！',
        'Can\'t get element data of %s!' => '不能获得%s 的元素数据！',
        'Can\'t get filter content data of %s!' => '不能获得%s 的过滤器内容数据！',
        'Customer Company Name' => '客户单位名称',
        'Customer User ID' => '客户联系人ID',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '需要SourceObject（源对象）和SourceKey（源键）！',
        'Please contact the administrator.' => '请联系系统管理员。',
        'You need ro permission!' => '需要ro只读权限！',
        'Can not delete link with %s!' => '不能删除到%s的链接！',
        'Can not create link with %s! Object already linked as %s.' => '不能创建到 %s 的连接！对象已连接为 %s。',
        'Can not create link with %s!' => '不能创建到%s的链接！',
        'The object %s cannot link with other object!' => '对象 %s 不能被其它对象链接！',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '参数“组”是必需的！',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '缺失参数“%s”。',
        'Invalid Subaction.' => '无效的子动作。',
        'Statistic could not be imported.' => '不能导入统计。',
        'Please upload a valid statistic file.' => '请上传一个有效的统计文件。',
        'Export: Need StatID!' => '导出：需要StatID（统计ID）！',
        'Delete: Get no StatID!' => '删除：没有StatID（统计ID）！',
        'Need StatID!' => '需要StatID（统计ID）！',
        'Could not load stat.' => '不能载入统计。',
        'Could not create statistic.' => '不能创建统计。',
        'Run: Get no %s!' => '运行：没有获得 %s！',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '没有指定TicketID 工单编号！',
        'You need %s permissions!' => '需要%s 权限！',
        'Could not perform validation on field %s!' => '不能验证字段%s ！',
        'No subject' => '没有主题',
        'Previous Owner' => '前一个所有者',

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
        'Bulk feature is not enabled!' => '批量操作功能还没有启用！',
        'No selectable TicketID is given!' => '没有指定可选择的工单编号！',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '你要么没有选择工单，要么只选择了已被其他服务人员锁定的工单。',
        'You need to select at least one ticket.' => '你需要选择至少一个工单。',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '由于被其它服务人员锁定或者你没有其写入权限，下列工单将被忽略：%s。',
        'The following tickets were locked: %s.' => '下列工单已被锁定：%s。',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Can not determine the ArticleType!' => '不能确定信件类型！',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'No Subaction!' => '没有子操作！',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '没有获得工单编号！',
        'System Error!' => '系统错误！',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Invalid Filter: %s!' => '无效的过滤器：%s！',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '不能显示历史，没有指定工单编号！',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '不能锁定工单，没有指定工单编号！',
        'Sorry, the current owner is %s!' => '抱歉，当前所有者是：%s！',
        'Please become the owner first.' => '请首先成为所有者。',
        'Ticket (ID=%s) is locked by %s!' => '工单（ID=%s）已被 %s 锁定！',
        'Change the owner!' => '变更所有者！',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '不能将工单合并到它自己！',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '你需要转换权限！',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '聊天不是活动的。',
        'No permission.' => '没有权限。',
        '%s has left the chat.' => '%s已经离开了聊天。',
        'This chat has been closed and will be removed in %s hours.' => '这个聊天已经关闭，将在%s小时内删除。',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '没有ArticleID！',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '不能读取纯文本信件！可能在后端没有纯文件邮件！读取后端消息。',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '需要TicketID 工单编号！',
        'printed by' => '打印：',
        'Ticket Dynamic Fields' => '工单动态字段',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '不能获取ActivityDialogEntityID “%s”！',
        'No Process configured!' => '还没有配置流程！',
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
            '不能获得活动对话框实体ID “%s”的活动对话框配置。',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '不能获取活动对话框“%s”的动态字段“%s”的数据。',
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
            '此步骤不再属于工单“%s%s%s”流程的当前活动！ 另一位用户在此期间改变了这个工单。请关闭此工单，再重新加载这个工单。',
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

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Untitled' => '无标题',
        'Customer Name' => '客户名字',
        'Invalid Users' => '无效用户',
        'CSV' => 'CSV',
        'Excel' => 'Excel',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '功能没有启用！',

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
        'Customer Updated' => '客户联系人已更新',
        'Internal Chat' => '内部聊天',
        'Automatic Follow-Up Sent' => '发送自动跟进',
        'Note Added' => '已增加备注',
        'Note Added (Customer)' => '已增加备注-客户联系人',
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
        'Queue Updated' => '队列已更新',
        'External Chat' => '外部聊天',
        'Queue Changed' => '队列已变更',
        'Notification Was Sent' => '通知已发送',
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            '抱歉，工单当前状态下你没有权限访问了。',
        'Can\'t get for ArticleID %s!' => '不能获得ID为“%s”的信件！',
        'Article filter settings were saved.' => '信件过滤器设置已保存。',
        'Event type filter settings were saved.' => '事件类型过滤器设置已保存。',
        'Need ArticleID!' => '需要信件ID！',
        'Invalid ArticleID!' => '无效的信件ID！',
        'Offline' => '离线',
        'User is currently offline.' => '用户当前离线',
        'User is currently active.' => '用户当前已激活。',
        'Away' => '离开',
        'User was inactive for a while.' => '用户暂时未激活。',
        'Unavailable' => '不可用',
        'User set their status to unavailable.' => '用户设置他们的状态为不可用。',
        'Fields with no group' => '没有分组的字段',
        'View the source for this Article' => '查看这个信件的源',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '需要文件ID和信件ID！',
        'No TicketID for ArticleID (%s)!' => '信件ID (%s)没有工单ID！',
        'No such attachment (%s)!' => '没有这个附件（%s）！',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '检查系统配置 %s::QueueDefault 的设置。',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '检查系统配置 %s::TicketTypeDefault 的设置。',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '需要客户联系人ID！',
        'My Tickets' => '我的工单',
        'Company Tickets' => '单位工单',
        'Untitled!' => '未命名！',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
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
        'Kernel/Config.pm isn\'t writable!' => '文件Kernel/Config.pm不可写入！',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '如果你要使用安装器，设置WEB服务器用户对文件Kernel/Config.pm有写权限！',
        'Unknown Check!' => '未知的检查！',
        'The check "%s" doesn\'t exist!' => '检查“%s”不存在！',
        'Database %s' => '数据库%s',
        'Configure MySQL' => '配置MySQL',
        'Configure PostgreSQL' => '配置PostgreSQL',
        'Configure Oracle' => '配置ORACLE',
        'Unknown database type "%s".' => '未知的数据库类型“%s”。',
        'Please go back.' => '请返回。',
        'Install OTRS - Error' => '安装OTRS - 错误',
        'File "%s/%s.xml" not found!' => '没有找到文件“%s/%s.xml”！',
        'Contact your Admin!' => '联系你的系统管理员！',
        'Syslog' => 'Syslog',
        'Can\'t write Config file!' => '不能写入配置文件！',
        'Unknown Subaction %s!' => '未知的子操作 %s！',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '不能连接到数据库，没有安装Perl模块 DBD::%s！',
        'Can\'t connect to database, read comment!' => '不能连接到数据库，读取注释！',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '错误：请确认你的数据库能够接收大于%sMB的数据包（目前能够接收的最大数据包为%sMB）。为了避免程序报错，请调整数据库max_allowed_packet参数。',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '错误：请设置数据库参数innodb_log_file_size至少为%s MB（当前：%s MB，推荐：%s MB），请参阅 %s 获取更多信息。',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '需要配置 Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => '从 %s 身份认证失败！',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Sent message crypted to recipient!' => '发送加密消息给收件人！',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '发现无效的“PGP签名消息”头标识！',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '发现无效的“S/MIME签名消息”头标识！',
        'Ticket decrypted before' => '工单解密在……之前',
        'Impossible to decrypt: private key for email was not found!' => '无法解密：没有找到邮件的私钥！',
        'Successful decryption' => '成功解密',

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
        'sorted ascending' => '升序排序',
        'sorted descending' => '降序排序',
        'filter not active' => '过滤器没有激活',
        'filter active' => '过滤器是活动的',
        'This ticket has no title or subject' => '这个工单没有标题或主题',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:' =>
            '很抱歉，在这个工单的当前状态下你无权访问。你可以采取下列操作之一：',
        'No Permission' => '没有权限',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '链接为',
        'Search Result' => '搜索结果',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '归档搜索',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '现在升级%s到%s！%s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => '一次系统维护即将开始于：',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '（进行中）',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '请确保您已经为强制通知选择至少一种传输方法。',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '请指定在开始时间之后的结束时间。',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => '请提供你的新密码!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No (not supported)' => '不支持',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '没有选择过去完成的或“当前+即将”完成的相对时间值',
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
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '请移除以下不能用于工单限制的词语：',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => '排序',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '无法读取ACL配置文件。 请确保该文件有效。',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '你已经超出了并发服务人员的最大数，请联系sales@otrs.com。',
        'Please note that the session limit is almost reached.' => '请注意，会话数即将达到极限。',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '登录被拒绝！已经达到服务人员最大并发数！请立即联系sales@otrs.com！',
        'Session per user limit reached!' => '达到用户会话限制！',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '配置选项参考手册',
        'This setting can not be changed.' => '这个设置不能修改。',
        'This setting is not active by default.' => '这个设置默认没有激活。',
        'This setting can not be deactivated.' => '不能使这个设置失效。',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '客户联系人“%s”已经存在。',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '这个电子邮件地址已被其他客户联系人使用。',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '如：Text或Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '忽略该字段。',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '无法读取通知配置文件。 请确保该文件有效。',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '没有安装',
        'File is not installed!' => '文件没有安装！',
        'File is different!' => '文件被修改！',
        'Can\'t read file!' => '不能读取文件！',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '流程“%s”及其所有数据已成功导入。',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => '非活动的',
        'FadeAway' => '消退',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t get Token from sever' => '不能从服务器获取令牌',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '总和',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '工单状态类型',
        'Created Priority' => '创建的优先级',
        'Created State' => '创建的状态',
        'Create Time' => '创建时间',
        'Close Time' => '关闭时间',
        'Escalation - First Response Time' => '升级 - 首次响应时间',
        'Escalation - Update Time' => '升级 - 更新时间',
        'Escalation - Solution Time' => '升级 - 解决时间',
        'Agent/Owner' => '服务人员/所有者',
        'Created by Agent/Owner' => '创建人',
        'CustomerUserLogin' => '客户联系人登录',
        'CustomerUserLogin (complex search)' => '客户联系人登录名(复合搜索)',
        'CustomerUserLogin (exact match)' => '客户联系人登录名(精确匹配)',

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
        'ascending' => '升序',
        'descending' => '降序',
        'Attributes to be printed' => '要打印的属性',
        'Sort sequence' => '排序',
        'State Historic' => '状态历史',
        'State Type Historic' => '工单状态类型历史',
        'Historic Time Range' => '历史信息的时间范围',

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
        'Setting character_set_client needs to be utf8.' => 'character_set_client需要设置为utf8。',
        'Server Database Charset' => '服务器端数据库字符集',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'character_set_database需要设置为UNICODE或UTF8。',
        'Table Charset' => '表字符集',
        'There were tables found which do not have utf8 as charset.' => '字符集没有设置成utf8的表。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB日志文件大小',
        'The setting innodb_log_file_size must be at least 256 MB.' => '参数innodb_log_file_size必须设置为至少256MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '最大查询大小',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            '参数\'max_allowed_packet\'必须设置为大于20MB。',

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
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT必须设置为\'YYYY-MM-DD HH24:MI:SS\'',
        'NLS_DATE_FORMAT Setting SQL Check' => 'SQL检查NLS_DATE_FORMAT设置',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'client_encoding需要设置为UNICODE或UTF8。',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'server_encoding需要设置为UNICODE或UTF8。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '日期格式',
        'Setting DateStyle needs to be ISO.' => '设置日期格式为国际标准格式。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL需要8.X及以上版本。',

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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '系统负载',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '系统负载最大值为系统CPU数（例如：8CPU的系统负载小于等于8才是正常的）。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl 模块',
        'Not all required Perl modules are correctly installed.' => '部分Perl模块没有正确安装。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '可用的交换空间(%)',
        'No swap enabled.' => '没有启用交换空间。',
        'Used Swap Space (MB)' => '交换分区已使用(MB)',
        'There should be more than 60% free swap space.' => '需要至少60%的可用交换空间',
        'There should be no more than 200 MB swap space used.' => '交换空间不应该使用超过200MB。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS' => 'OTRS',
        'Config Settings' => '编辑配置。',
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

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '默认的SOAP用户名和密码',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '安全风险：你使用了默认的SOAP::User和SOAP::Password设置，请修改。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '默认的系统管理员密码',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '安全风险：服务人员帐户root@localhost还在使用默认密码。请修改密码或禁用此帐户。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ErrorLog.pm
        'Error Log' => '错误日志',
        'There are error reports in your system log.' => '这是你系统日志中的错误报告.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '正式域名',
        'Please configure your FQDN setting.' => '请配置您的正式域名。',
        'Domain Name' => '域名',
        'Your FQDN setting is invalid.' => '您的正式域名无效。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '文件系统是可写的',
        'The file system on your OTRS partition is not writable.' => 'OTRS分区所有文件系统是不可写的。',

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
        'There are emails in var/spool that OTRS could not process.' => 'var/spool目录下有一些OTRS无法处理的邮件。',

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
        'Open Tickets' => '处理中的工单',
        'You should not have more than 8,000 open tickets in your system.' =>
            '您的系统不能有超过8000个处理中的工单。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '工单搜索索引模块',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '您已经超过50000封信件，应该使用后端静态数据库。请参阅管理员手册（性能调优部分）查阅更多信息。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'ticket_lock_index表中的孤儿记录',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'ticket_lock_index表中包含孤儿记录。请运行bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup"清理静态数据库的索引。',
        'Orphaned Records In ticket_index Table' => 'ticket_index表中的孤儿记录',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'ticket_index表中包含孤儿记录。请运行bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup"，清理静态数据库的索引。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '时间设置',
        'Server time zone' => '服务器时区',
        'Computed server time offset' => '计算服务器时间偏移',
        'OTRS TimeZone setting (global time offset)' => 'OTRS时区设置（全局时间偏移）',
        'TimeZone may only be activated for systems running in UTC.' => '时区只能在系统运行于UTC时间时才能激活。',
        'OTRS TimeZoneUser setting (per-user time zone support)' => 'OTRS用户时区设置（支持每个用户的时区）',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            '用户时区只能在系统运行于UTC时间且没有设置OTRS时区时才能激活。',
        'OTRS TimeZone setting for calendar ' => 'OTRS时区设置，适用日历',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'WEB服务器',
        'Loaded Apache Modules' => '已载入的Apache模块',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM多路处理模块',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS需要apache运行“prefork”MPM多路处理模块',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI加速器用法',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '您应该使用FastCGI或mod_perl来提升性能。',
        'mod_deflate Usage' => 'mod_deflate用法',
        'Please install mod_deflate to improve GUI speed.' => '安装模块mod_deflate来提升图形界面的速度。',
        'mod_filter Usage' => 'mod_filter用法',
        'Please install mod_filter if mod_deflate is used.' => '如果使用了mod_deflate，请安装使用mod_filter模块。',
        'mod_headers Usage' => 'mod_headers用法',
        'Please install mod_headers to improve GUI speed.' => '安装模块mod_headers来提升图形界面的速度。',
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
        'Unknown' => '未知',
        'OK' => '好',
        'Problem' => '问题',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '重置解锁时间。',

        # Perl Module: Kernel/System/Ticket/Event/NotificationEvent/Transport/Email.pm
        'PGP sign only' => '仅PGP签名',
        'PGP encrypt only' => '仅PGP加密',
        'PGP sign and encrypt' => 'PGP签名和加密',
        'SMIME sign only' => '仅SMIME签名',
        'SMIME encrypt only' => '仅SMIME加密',
        'SMIME sign and encrypt' => 'SMIME签名和加密',
        'PGP and SMIME not enabled.' => '没有启用PGP和SMIME。',
        'Skip notification delivery' => '跳过通知递送',
        'Send unsigned notification' => '发送未签名的通知',
        'Send unencrypted notification' => '发送未加密的通知',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '不能移除会话ID。',
        'Logout successful.' => '成功注销。',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '没有权限使用这个前端界面模块！',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '认证成功，但是后端没有发现此客户的记录，请联系系统管理员。',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '重置密码未成功，请联系系统管理员。',
        'Added via Customer Panel (%s)' => '通过客户界面已添加（%s）',
        'Customer user can\'t be added!' => '不能添加客户联系人！',
        'Can\'t send account info!' => '不能发送帐户信息！',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '没有找到操作“%s”！',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => '具有默认权限的组。',
        'Group of all administrators.' => '所有管理员的组。',
        'Group for statistics access.' => '具有统计权限的组。',
        'All new state types (default: viewable).' => '所有新工单的状态类型（默认：可查看）。',
        'All open state types (default: viewable).' => '所有处理中的工单的状态类型（默认：可查看）。',
        'All closed state types (default: not viewable).' => '所有已关闭工单的状态类型（默认：不可查看）。',
        'All \'pending reminder\' state types (default: viewable).' => '所有挂起提醒的工单的状态类型（默认：可查看）。',
        'All \'pending auto *\' state types (default: viewable).' => '所有挂起等待成功/失败关闭的工单的状态类型（默认：可查看）。',
        'All \'removed\' state types (default: not viewable).' => '所有已移除工单的状态类型（默认：不可查看）。',
        'State type for merged tickets (default: not viewable).' => '合并的工单的状态类型（默认：不可查看）。',
        'New ticket created by customer.' => '客户创建的新工单。',
        'Ticket is closed successful.' => '工单已经成功关闭。',
        'Ticket is closed unsuccessful.' => '工单没有成功关闭。',
        'Open tickets.' => '处理工单。',
        'Customer removed ticket.' => '客户移除工单。',
        'Ticket is pending for agent reminder.' => '工单为服务人员提醒而挂起。',
        'Ticket is pending for automatic close.' => '工单等待自动关闭而挂起。',
        'State for merged tickets.' => '已合并工单的状态。',
        'system standard salutation (en)' => '系统标准问候语（英）',
        'Standard Salutation.' => '标准问候语。',
        'system standard signature (en)' => '系统标准签名（英）',
        'Standard Signature.' => '标准签名。',
        'Standard Address.' => '标准地址。',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '跟进已关闭工单是可能的，这将会重新处理工单。',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '跟进已关闭工单是不可能的，不会创建新工单。',
        'new ticket' => '新建工单',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '不能跟进已关闭工单，这将会创建一个新的工单。',
        'Postmaster queue.' => '邮箱管理员队列。',
        'All default incoming tickets.' => '所有默认进入的工单。',
        'All junk tickets.' => '所有的垃圾工单。',
        'All misc tickets.' => '所有的杂项工单。',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '创建新工单后会发送自动答复。',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '跟进工单被拒绝后会发送自动拒绝（在队列跟进选项设置为“拒绝”时）。',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '跟进工单被接受后会发送自动确认（在队列跟进选项设置为“可能”时）。',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '跟进工单被拒绝并创建新工单后会发送自动响应（在队列跟进选项设置为“新建工单”时）。',
        'Auto remove will be sent out after a customer removed the request.' =>
            '客户移除请求后会发送自动移除。',
        'default reply (after new ticket has been created)' => '默认答复（新工单创建后）',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '默认拒绝（跟进已关闭工单被拒绝后）',
        'default follow-up (after a ticket follow-up has been added)' => '默认跟进（添加工单跟进后）',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '默认拒绝并创建新工单（跟进已关闭工单则创建新工单）',
        'Unclassified' => '未分类',
        'tmp_lock' => '临时锁',
        'email-notification-ext' => '邮件通知-外部',
        'email-notification-int' => '邮件通知-内部',
        'Ticket create notification' => '工单创建通知',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '每当创建一个新的工单，且该工单所属队列或服务在你设置的“我的队列”或“我的服务”中时，你都将收到一个通知。',
        'Ticket follow-up notification (unlocked)' => '工单跟进通知（解锁）',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '如果一个客户联系人发送了一个跟进到一个解锁工单，且该工单所属队列或服务在你设置的“我的队列”或“我的服务”中时，你都将收到一个通知。',
        'Ticket follow-up notification (locked)' => '工单跟进通知（锁定）',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '如果一个客户联系人发送了一个跟进到你是所有者或负责人的工单时，你都将收到一个通知。',
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
        ' (work units)' => '（工作时间）',
        '"%s" notification was sent to "%s" by "%s".' => '“%s”条通知已发送给“%s”，发件人：“%s”。',
        '"Slim" skin which tries to save screen space for power users.' =>
            '为高级用户节约窗口空间的“修身版”皮肤。',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '已用%s时间单位，现在总共%s时间单位。',
        '(UserLogin) Firstname Lastname' => '（登录用户名）名 姓',
        '(UserLogin) Lastname Firstname' => '（登录用户名）姓 名',
        '(UserLogin) Lastname, Firstname' => '（登录用户名）姓, 名',
        '*** out of office until %s (%s d left) ***' => '*** %s前不在办公室（还有%s天）***',
        '100 (Expert)' => '100（专家）',
        '200 (Advanced)' => '200（高级）',
        '300 (Beginner)' => '300（新手）',
        'A TicketWatcher Module.' => '工单关注者模块。',
        'A Website' => '网址',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '在合并工单过程中合并到主工单的动态字段列表，只有主工单中为空的动态字段才会被设置。',
        'A picture' => '图片',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL模块仅在所有子工单都关闭后才允许关闭父工单（除非所有子工单都已经关闭，否则父工单显示的“状态”均不可用）',
        'Access Control Lists (ACL)' => '访问控制列表(ACL)',
        'AccountedTime' => '所用工时',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '包含最早工单的队列激活闪烁提醒机制。',
        'Activates lost password feature for agents, in the agent interface.' =>
            '在服务人员界面中，激活忘记密码功能。',
        'Activates lost password feature for customers.' => '在客户界面中，激活忘记密码功能。',
        'Activates support for customer groups.' => '激活客户组支持功能。',
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
        'Add an inbound phone call to this ticket' => '为本工单添加电话接入',
        'Add an outbound phone call to this ticket' => '为本工单添加拨出电话',
        'Added email. %s' => '添加电子邮件：%s',
        'Added link to ticket "%s".' => '添加到工单的链接：“%s”.',
        'Added note (%s)' => '添加备注：%s',
        'Added subscription for user "%s".' => '用户“%s”添加关注。',
        'Address book of CustomerUser sources.' => '客户联系人通讯录。',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '为OTRS日志文件添加实际年月的后缀，每月创建一个日志文件。',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '在服务人员界面中，在编写工单时添加客户邮件地址到收件人，如果信件类型为内部邮件则不添加客户邮件地址。',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '为指定的日历添加非固定假期，请使用从1到9的单数字模式（而不是01-09）。',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '添加非固定假期，请使用从1到9的单数字模式（而不是01-09）。',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '为指定的日历添加固定假期，请使用从1到9的单数字模式（而不是01-09）。',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '添加固定假期，请使用从1到9的单数字模式（而不是01-09）。',
        'Admin Area.' => '系统管理区。',
        'After' => '在...之后',
        'Agent Name' => '服务人员姓名',
        'Agent Name + FromSeparator + System Address Display Name' => '服务人员姓名 + 隔离符号 + 系统邮件地址显示姓名',
        'Agent Preferences.' => '服务人员偏好设置。',
        'Agent called customer.' => '服务人员已打电话给客户。',
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
        'AgentCustomerSearch' => '服务人员搜索客户',
        'AgentCustomerSearch.' => '服务人员搜索客户。',
        'AgentUserSearch' => '服务人员搜索客户联系人',
        'AgentUserSearch.' => '服务人员搜索客户联系人。',
        'Agents <-> Groups' => '服务人员 <-> 组',
        'Agents <-> Roles' => '服务人员 <-> 角色',
        'All customer users of a CustomerID' => '一个客户ID的所有客户联系人',
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
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '在客户界面允许设置工单的队列，如果此处设置为“NO”，则需要配置参数QueueDefault（默认队列）。',
        'Allows customers to set the ticket service in the customer interface.' =>
            '在客户界面允许设置工单所属的服务。',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '在客户界面允许设置工单的类型，如果此处设置为“NO”，需要设置工单默认类型。',
        'Allows default services to be selected also for non existing customers.' =>
            '允许未知客户选择默认服务。',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            '允许定义新的工单类型（如果启用了工单类型功能）。',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '允许定义工单的服务和SLA（例如：邮件、桌面、网络等等），以及SLA的升级属性（如果启用了工单服务/SLA功能）。',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '允许在服务人员界面搜索工单时扩展搜索条件，通过这个功能您可以按如下条件搜索：带“(*key1*&&*key2*)”或“(*key1*||*key2*)”条件的工单标题。',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '允许在客户界面搜索工单时扩展搜索条件，通过这个功能您可以按如下条件搜索：带“(*key1*&&*key2*)”或“(*key1*||*key2*)”条件的工单标题。',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '允许在自动任务界面搜索工单时扩展搜索条件，通过这个功能您可以按如下条件搜索：“(key1&&key2)”或“(key1||key2)”。',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '允许拥有一个基本概览视图（如果CustomerInfo => 1还将显示客户信息）。',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '允许拥有一个简洁概览视图（如果CustomerInfo => 1还将显示客户信息）。',
        'Allows invalid agents to generate individual-related stats.' => '允许失效的服务人员生成个人相关的统计。',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '允许系统管理员作为其他客户登录（通过客户联系人管理面板）。',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '允许系统管理员作为其他用户登录（通过服务人员管理面板）。',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '在服务人员界面允许在转移工单界面设置新的工单状态。',
        'Always show RichText if available' => '始终显示可用的富文本',
        'Arabic (Saudi Arabia)' => '阿拉伯语（沙特阿拉伯）',
        'Archive state changed: "%s"' => '归档状态变更：“%s”',
        'ArticleTree' => '信件树',
        'Attachments <-> Templates' => '附件 <-> 模板',
        'Auto Responses <-> Queues' => '自动响应 <-> 队列',
        'AutoFollowUp sent to "%s".' => '自动跟进已发送给“%s”。',
        'AutoReject sent to "%s".' => '自动拒绝已发送给“%s”。',
        'AutoReply sent to "%s".' => '自动回复已发送给“%s”。',
        'Automated line break in text messages after x number of chars.' =>
            '文本消息中在X个字符后自动换行。',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '在服务人员界面处理转移工单后自动锁定并设置当前服务人员为工单所有者。',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '选择批量操作后自动锁定并设置当前服务人员为工单所有者。',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '如果启用了工单负责人功能，自动设置工单所有者为其负责人。这个选项只适用于登录用户的手动操作，不适用于自动操作如自动任务、邮箱管理员过滤和通用接口。',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '在第一次工单所有者更新后自动设置工单的负责人（如果还没有设置）。',
        'Balanced white skin by Felix Niklas (slim version).' => 'Felix Niklas的平衡白皮肤（修身版）',
        'Balanced white skin by Felix Niklas.' => 'Felix Niklas的平衡白皮肤',
        'Based on global RichText setting' => '基于全局富文本设置',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            '基本的全文索引设置。执行"bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild"以生成一个新索引。',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '阻止所有来自@example.com地址、主题中无有效工单号的进入邮件。',
        'Bounced to "%s".' => '退回到“%s”。',
        'Builds an article index right after the article\'s creation.' =>
            '在信件创建后立即创建索引。',
        'Bulgarian' => '保加利亚语',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '命令行样例设置。忽略外部命令行返回在STDOUT（标准输出）上的一些输出的邮件（邮件将用管道输入到some.bin的STDIN标准输入）。',
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
        'Catalan' => '加泰罗尼亚语',
        'Change password' => '修改密码',
        'Change queue!' => '变更队列！',
        'Change the customer for this ticket' => '更改这个工单的客户',
        'Change the free fields for this ticket' => '修改这个工单的自由字段',
        'Change the priority for this ticket' => '更改这个工单的优先级',
        'Change the responsible for this ticket' => '更改这个工单的负责人',
        'Changed priority from "%s" (%s) to "%s" (%s).' => '工单优先级从“%s” (%s)变更到 “%s” (%s)。',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '变更工单所有者为所有人（ASP有用），一般只显示这个工单队列中有读写权限的服务人员。',
        'Checkbox' => '复选框',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '通过搜索主题中的有效工单号，检查一个邮件是否是跟进到已存在的工单。',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '在跟进工单的工单号检测时检查系统ID（如果使用系统后变更过系统ID，则设置为“NO”）。',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '检查本系统的OTRS商业版可用性。',
        'Checks the entitlement status of OTRS Business Solution™.' => '检查OTRS商业版的权利状态。',
        'Chinese (Simplified)' => '简体中文',
        'Chinese (Traditional)' => '繁体中文',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            '选择你需要接收哪一些工单变动通知消息。',
        'Closed tickets (customer user)' => '已关闭的工单（客户联系人）',
        'Closed tickets (customer)' => '已关闭的工单（客户）',
        'Cloud Services' => '云服务',
        'Cloud service admin module registration for the transport layer.' =>
            '云服务的传输层管理模块注册',
        'Collect support data for asynchronous plug-in modules.' => '收集异步插件模块的支持数据',
        'Column ticket filters for Ticket Overviews type "Small".' => '工单概览简洁模式的字段过滤器',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '在服务人员界面中，工单升级视图中字段可以过滤。可能的设置为：0 = 禁用，1 = 可用，2 = 默认启用。注意：只有只有工单属性、动态字段（DynamicField_NameX）和客户属性（例如：CustomerUserPhone、 CustomerCompanyName ...）允许过滤。',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '在服务人员界面中，工单锁定视图中字段可以过滤。可能的设置为：0 = 禁用，1 = 可用，2 = 默认启用。注意：只有只有工单属性、动态字段（DynamicField_NameX）和客户属性（例如：CustomerUserPhone、 CustomerCompanyName ...）允许过滤。',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '在服务人员界面中，工单队列视图中字段可以过滤。可能的设置为：0 = 禁用，1 = 可用，2 = 默认启用。注意：只有只有工单属性、动态字段（DynamicField_NameX）和客户属性（例如：CustomerUserPhone、 CustomerCompanyName ...）允许过滤。',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '在服务人员界面中，工单负责人视图中字段可以过滤。可能的设置为：0 = 禁用，1 = 可用，2 = 默认启用。注意：只有只有工单属性、动态字段（DynamicField_NameX）和客户属性（例如：CustomerUserPhone、 CustomerCompanyName ...）允许过滤。',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '在服务人员界面中，工单服务视图中字段可以过滤。可能的设置为：0 = 禁用，1 = 可用，2 = 默认启用。注意：只有只有工单属性、动态字段（DynamicField_NameX）和客户属性（例如：CustomerUserPhone、 CustomerCompanyName ...）允许过滤。',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '在服务人员界面中，工单状态视图中字段可以过滤。可能的设置为：0 = 禁用，1 = 可用，2 = 默认启用。注意：只有只有工单属性、动态字段（DynamicField_NameX）和客户属性（例如：CustomerUserPhone、 CustomerCompanyName ...）允许过滤。',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '在服务人员界面中，工单搜索结果中字段可以过滤。可能的设置为：0 = 禁用，1 = 可用，2 = 默认启用。注意：只有只有工单属性、动态字段（DynamicField_NameX）和客户属性（例如：CustomerUserPhone、 CustomerCompanyName ...）允许过滤。',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '在服务人员界面中，工单关注视图中字段可以过滤。可能的设置为：0 = 禁用，1 = 可用，2 = 默认启用。注意：只有只有工单属性、动态字段（DynamicField_NameX）和客户属性（例如：CustomerUserPhone、 CustomerCompanyName ...）允许过滤。',
        'Comment for new history entries in the customer interface.' => '在客户界面中新的历史条目的注释。',
        'Comment2' => '注释2',
        'Communication' => '沟通',
        'Company Status' => '单位状态',
        'Company Tickets.' => '单位工单。',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '单位名称将作为X-Header包括在外出邮件中',
        'Compat module for AgentZoom to AgentTicketZoom.' => '服务人员工单详情视图中服务人员详情的兼容模块。',
        'Complex' => '复杂',
        'Configure Processes.' => '配置流程。',
        'Configure and manage ACLs.' => '配置和管理ACLs',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '配置任何您想要使用的额外只读镜像数据库。',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '配置为提升支持效果而发送给OTRDS集团的支持数据。',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '配置创建新工单后显示的界面。',
        'Configure your own log text for PGP.' => '配置您自己的PGP日志文本。',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            '配置默认的TicketDynamicField（工单动态字段）设置，“Name（名称）”定义要使用的动态字段，“Value（值）”是要设置的数值，“Event（事件）”定义触发的事件。请检查开发手册（http://otrs.github.io/doc/）的“Ticket Event Module（工单事件模块）”章节。',
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
            '控制系统管理员能否通过SQL查询窗口修改数据库。',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '控制工单和信件归档后的可见标志是否被移除。',
        'Converts HTML mails into text messages.' => '将HTML邮件转换为文本信息。',
        'Create New process ticket.' => '创建新的流程工单。',
        'Create and manage Service Level Agreements (SLAs).' => '创建和管理服务品质协议(SLA)。',
        'Create and manage agents.' => '创建和管理服务人员。',
        'Create and manage attachments.' => '创建和管理附件。',
        'Create and manage customer users.' => '创建和管理客户联系人。',
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
        'Create and manage ticket types.' => '创建和管理工单类型。 ',
        'Create and manage web services.' => '创建和管理Web服务。',
        'Create new Ticket.' => '创建新工单。',
        'Create new email ticket and send this out (outbound).' => '创建新的邮件工单并给客户发邮件（外发）。',
        'Create new email ticket.' => '创建新的邮件工单。',
        'Create new phone ticket (inbound).' => '创建新的电话工单（来电）。',
        'Create new phone ticket.' => '创建新的电话工单。',
        'Create new process ticket.' => '创建新的流程工单。',
        'Create tickets.' => '创建工单。',
        'Croatian' => '克罗地亚语',
        'Custom RSS Feed' => '定制RSS订阅',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '显示给还没有工单的客户的网页定制文本（如果您需要翻译这些文本，将它们添加到定制翻译模块）。',
        'Customer Administration' => '客户管理',
        'Customer Information Center Search.' => '客户信息中心搜索。',
        'Customer Information Center.' => '客户信息中心。',
        'Customer Ticket Print Module.' => '客户工单打印模块。',
        'Customer User <-> Groups' => '客户联系人 <-> 组',
        'Customer User <-> Services' => '客户联系人 <-> 服务',
        'Customer User Administration' => '客户联系人管理',
        'Customer Users' => '客户联系人',
        'Customer called us.' => '客户给我们打过电话。',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '显示已关闭工单信息块的客户信息（图标）。设置参数CustomerUserLogin为1，则基于登录名而不是客户ID搜索工单。',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '显示处理中工单信息块的客户信息（图标）。设置参数CustomerUserLogin为1，则基于登录名而不是客户ID搜索工单。',
        'Customer preferences.' => '客户偏好设置。',
        'Customer request via web.' => '客户通过WEB提交的请求。',
        'Customer ticket overview' => '客户工单概览',
        'Customer ticket search.' => '客户工单搜索。',
        'Customer ticket zoom' => '客户工单详情',
        'Customer user search' => '客户联系人搜索',
        'CustomerID search' => '客户ID搜索',
        'CustomerName' => '客户名称',
        'CustomerUser' => '客户联系人',
        'Customers <-> Groups' => '客户 <-> 组',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引可定制的停用词，这些词将从搜索索引中移除。',
        'Czech' => '捷克语',
        'DEPRECATED: This config setting will be removed in further versions of OTRS. Sets the time (in seconds) a user is marked as active (minimum active time is 300 seconds).' =>
            '',
        'Danish' => '丹麦语',
        'Data used to export the search result in CSV format.' => '用于将搜索结果输出为CSV格式的数据。',
        'Date / Time' => '日期 / 时间',
        'Debug' => '调试',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '调试翻译设置。如果此处设置为“是”，所有没有翻译的字符串（文本）将被输出到STDERR（标准错误）。这对创建一个新的翻译文件有用，否则，这个选项应保持设置为“否”。',
        'Default' => '默认',
        'Default (Slim)' => '默认（修身版）',
        'Default ACL values for ticket actions.' => '工单操作的默认ACL值。',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '自动生成的流程实体ID的默认前缀。',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '工单搜索窗口用于搜索属性的默认数据。示例：“TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;”。',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '工单搜索窗口用于搜索属性的默认数据。示例：“TicketCreateTimeStartYear=2015;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2015;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;”。',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '在服务人员和客户工单详情中收件人（TO，CC）的默认显示类型。',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '在服务人员和客户工单详情中发件人（From）的默认显示类型。',
        'Default loop protection module.' => '默认的邮件循环保护模块。',
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
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '定义客户联系人数据（键）与工单动态字段（值）的映射。目的是在工单动态字段中存储客户联系人数据。动态字段必须存在于系统中且启用了AgentTicketFreeText（服务人员工单自由文本），这样才能由服务人员手动设置/更新。动态字段不能在服务人员电话工单、邮件工单和客户工单中启用，否则他们将优先于自动设置值。要使用这些映射，还要激活接下来的设置。',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '定义结束时间的动态字段名称。这个字段需要手动加入到系统作为工单的一种“日期/时间”，并且要在工单创建窗口和/或其它任何工单操作窗口激活。',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '定义开始时间的动态字段名称。这个字段需要手动加入到系统作为工单的一种“日期/时间”，并且要在工单创建窗口和/或其它任何工单操作窗口激活。',
        'Define the max depth of queues.' => '定义队列的最大深度。',
        'Define the queue comment 2.' => '定义队列注释2。',
        'Define the service comment 2.' => '定义服务注释2。',
        'Define the sla comment 2.' => '定义SLA注释2。',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '为选定的日历定义日期选择器中一周的起始日。',
        'Define the start day of the week for the date picker.' => '定义日期选择器中一周的起始日。',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '定义链接对象小部件(LinkObject::ViewMode = "complex")要显示的列。注意：只有工单属性和动态字段（DynamicField_NameX）才能作为默认列，可用的设置值为：0 = 禁用，1 = 可用， 2 = 默认启用。',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '定义一个客户条目，以在客户信息块的尾部生成一个LinkedIn图标。',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '定义一个客户条目，以在客户信息块的尾部生成一个XING图标。',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '定义一个客户条目，以在客户信息块的尾部生成一个谷歌图标。',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '定义一个客户条目，以在客户信息块的尾部生成一个谷歌地图图标。',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '定义一个默认的词语列表，拼写检查器会忽略这个列表中的词语。',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定义HTML输出结果中在CVE号码后面添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（如faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定义HTML输出结果中在微软公告号码后面添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（如faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '在HTML输出结果中为预定义字符串添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（如faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定义HTML输出结果中在BUG追踪号码后面添加链接的过滤器。图像元素允许两种输入方式：第一种是用图像的名称（如faq.png），在这种情况下会使用OTRS的图像路径；第二种是插入图像的链接。',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '定义一个在服务人员工单详情窗口从信件文本中搜集CVE编号的过滤器，并在靠近信件的一个自定义区块中显示结果。如果想要在鼠标移到到链接元素上时显示内容预览，就填写URLPreview字段。它可以与URL中的地址相同，也可以是另外一个URL。请注意：一些网站不能在iframe框架中显示（如Google），这样就无法在预览模式中正常显示内容。',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '定义信件中处理文本的过滤器，以便高亮预定义的关键词。',
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
            '定义一个客户数据库的外部链接（例如：\'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' 或 \'\'）',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '定义服务人员选择结果顺序的工单属性。',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '定义邮件（来自于答复和邮件工单）发件人字段的显示样式。',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '定义队列视图是否按优先级预先排序。',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '定义服务视图是否按优先级预先排序。',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单关闭窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单外出邮件窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单退回窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单编写窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单转发窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单自定义字段窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单合并窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单备注窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单所有者窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单挂起窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单电话接入窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单拨出电话窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单优先级窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在工单负责人窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '定义服务人员界面在变更工单客户窗口是否需要工单锁定（如果工单还没有锁定，则工单被锁定且当前服务人员被自动设置为工单所有者）。',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '定义是否允许因在个人偏好设置中没有存储共享密钥而不能使用双因素身份验证的服务人员登录。',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '定义在服务人员界面中编写消息时是否进行拼写检查。',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '定义是否允许因在个人偏好设置中没有存储共享密钥而不能使用双因素身份验证的客户联系人登录。',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '定义客户界面是否使用增强模式（启用表格、替换、下标、上标、从WORD粘贴等功能）。',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '定义是否使用增加模式（可以使用表格、替换、下标、上标、从WORD中粘贴等等）。',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '定义在身份验证时是否接受先前有效的链接令牌。这稍微降低了安全性但是给用户多了30秒时间来输入他们的一次性密码。',
        'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '定义过滤器的值是否应从所有可用的工单中检索。如果设置为“是”，则只有实际用在工单中的值才能用于过滤。请注意：客户联系人列表将像这样始终被检索。',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '定义在服务人员界面工时管理是否是强制的。如果激活，所有工单操作必须输入一个备注（不管是否启用了工单备注，也不管个别工单操作界面本来就是强制的）。',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '定义在批量操作中是否设置所有工单的工时管理。',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '定义不在办公室的消息模板。有两个字符串参数（%s）：结束日期和剩余天数。',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '定义将工单作为日历事件显示的队列。',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '使用公共模块 \'PublicSupportDataCollector\' （如用于OTRS守护进程的模块）定义用于搜集支持数据的HTTP主机名。',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '定义IP正则表达式以访问本地的软件仓库。您需要启用这个设置以访问本地的软件仓库，远程主机上还需要设置package::RepositoryList。',
        'Defines the URL CSS path.' => '定义CSS路径的URL地址。',
        'Defines the URL base path of icons, CSS and Java Script.' => '定义图标、CSS和Javascript的URL基本路径。',
        'Defines the URL image path of icons for navigation.' => '定义导航栏图标的URL图像地址。',
        'Defines the URL java script path.' => '定义Javascript路径的URL地址。',
        'Defines the URL rich text editor path.' => '定义富文本编辑器的URL地址。',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '定义专用的DNS服务器地址，如果需要，用于“检查MX记录”时查找。',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '定义服务人员存储的共享密钥中的预设密钥。',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '定义发送给服务人员关于新密码的通知邮件的正文文本（点击这个链接后将发送新密码）。',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '定义发送给服务人员关于新请求密码的链接的正文文本（点击这个链接后将发送新密码）。',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '定义发送给客户联系人关于新帐户信息的通知邮件的正文文本。',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '定义发送给客户联系人关于新密码的正文文本（点击这个链接后将发送新密码）。',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '定义发送给客户联系人关于新密码的链接的正文文本（点击这个链接后将发送新密码）。',
        'Defines the body text for rejected emails.' => '定义拒绝邮件的正文文本。',
        'Defines the calendar width in percent. Default is 95%.' => '定义日历的宽度（%），默认为95%。',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            '定义群集节点标识符。仅在多于1个OTRS前端系统的群集配置中使用。注意：只允许1-99的值。',
        'Defines the column to store the keys for the preferences table.' =>
            '定义在偏好设置表中存储密钥的字段',
        'Defines the config options for the autocompletion feature.' => '定义自动完成功能的配置选项。',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '定义在个人偏好设置视图中显示这个条目的配置参数。',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.' =>
            '定义在偏好设置中这个条目的配置参数。\'PasswordRegExp\'保证密码不匹配一个正则表达式；\'PasswordMinSize\'定义密码的最小字符数；如果至少需要2个小写字母和2个大写字母就设置合适的选项为“1”，\'PasswordMin2Characters\'定义密码如果要包含至少2个字母字符（设置为0或1）；\'PasswordNeedDigit\'控制是否至少包含1个数字（设置为0或1）；\'PasswordMaxLoginFailed\'设置最大登录失败数，一个服务人员在登录失败次数达到这个数后会临时无效。',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '定义在个人偏好设置视图中显示这个条目的配置参数。注意维护在数据区安装到系统中的词典。',
        'Defines the connections for http/ftp, via a proxy.' => '定义通过代理到HTTP/FTP的连接。',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '定义客户存储的共享密钥中的预设密钥。',
        'Defines the date input format used in forms (option or input fields).' =>
            '定义表单中数据的输入格式（选项或输入字段）。',
        'Defines the default CSS used in rich text editors.' => '定义用于富文本编辑器的默认CSS。',
        'Defines the default auto response type of the article for this operation.' =>
            '定义这个信件操作的默认自动响应类型。',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段界面的默认备注正文。',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            '定义服务人员和客户使用的默认前端主题（HTML）。如果您喜欢，您可以添加您自己的主题。请参考管理员手册http://otrs.github.io/doc/。',
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
            '定义服务人员界面在关闭工单窗口添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '定义服务人员界面在工单批量操作窗口添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面在工单自定义字段窗口添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '定义服务人员界面在工单备注窗口添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面在工单所有者窗口添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面在工单挂起窗口添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面在工单优先级窗口添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '定义服务人员界面在工单负责人窗口添加备注后的默认下一个工单状态。',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '定义服务人员界面在工单退回窗口退回工单后的默认下一个工单状态。',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '定义服务人员界面在工单转发窗口转发工单后的默认下一个工单状态。',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '定义服务人员界面在工单外出邮件窗口发送消息后的默认下一个工单状态。',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '定义服务人员界面在工单编写窗口编写或答复工单后的默认下一个工单状态。',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面在工单电话接入窗口电话工单的默认备注正文文本。',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面在工单拨出电话窗口电话工单的默认备注正文文本。',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '在客户界面中，工单详情窗口跟进客户工单的默认优先级。',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '在客户界面中，创建客户工单的默认优先级。',
        'Defines the default priority of new tickets.' => '定义创建工单的默认优先级。',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '在客户界面中，创建客户工单的默认队列。',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '定义动态对象下拉菜单的默认选择项（表单：一般设定）。',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '定义权限下拉菜单的默认选择项（表单：一般设定）。',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '定义统计格式下拉菜单的默认选择项（表单：一般设定）。请插入格式键（参考Stats::Format）。',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面工单电话接入窗口中电话工单默认的发送人类型。',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面工单电话拨出窗口中电话工单默认的发送人类型。',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '定义服务人员界面工单详情窗口中工单默认的发送人类型。',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '定义工单搜索窗口中默认显示的工单搜索属性（所有工单/归档工单/未归档工单）。',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '定义工单搜索窗口中默认显示的工单搜索属性。',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '定义工单搜索窗口中默认显示的工单搜索属性。“键”必须在动态字段名称后加“X”，“值”必须是动态字段类型相关的值，文本：\'a text\'，下拉菜单：\'1\'，日期/时间：\'Search_DynamicField_XTimeSlotStartYear=1974;Search_DynamicField_XTimeSlotStartMonth=01;Search_DynamicField_XTimeSlotStartDay=26;Search_DynamicField_XTimeSlotStartHour=00;Search_DynamicField_XTimeSlotStartMinute=00;Search_DynamicField_XTimeSlotStartSecond=00;Search_DynamicField_XTimeSlotStopYear=2013; earch_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\'或者\'Search_DynamicField_XTimePointFormat=week;Search_DynamicField_XTimePointStart=Before;Search_DynamicField_XTimePointValue=7\'。',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '定义在工单队列视图中默认的排序条件。',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '定义在工单服务视图中默认的排序条件。',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '定义在工单队列视图中在优先级排序后默认的排序顺序。',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '定义在工单服务视图中在优先级排序后默认的排序顺序。',
        'Defines the default spell checker dictionary.' => '定义默认的拼写检查词典。',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '定义客户界面中新建客户工单的默认状态。',
        'Defines the default state of new tickets.' => '定义新建工单的默认状态。',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面工单电话接入窗口电话工单的默认主题。',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面工单拨出电话窗口电话工单的默认主题。',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段窗口工单备注的默认主题。',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '定义通用接口失败的任务重新安排的默认秒数（从当前时间开始）。',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '定义客户界面中工单搜索窗口工单排序的默认工单属性。',
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
            '定义服务人员界面工单退回窗口退回客户/发送人默认的工单退回通知。',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面工单电话接入窗口添加电话备注后默认的工单下一状态。',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面工单拨出电话窗口添加电话备注后默认的工单下一状态。',
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
            '定义服务人员界面关闭工单窗口默认的工单优先级。',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '定义服务人员界面工单批量操作窗口默认的工单优先级。',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段窗口默认的工单优先级。',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '定义服务人员界面工单备注窗口默认的工单优先级。',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单所有者窗口默认的工单优先级。',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单挂起窗口默认的工单优先级。',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单优先级窗口默认的工单优先级。',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '定义服务人员界面工单负责人窗口默认的工单优先级。',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '定义客户界面新建客户工单窗口默认的工单类型。',
        'Defines the default ticket type.' => '定义默认的工单类型。',
        'Defines the default type for article in the customer interface.' =>
            '定义客户界面信件的默认类型。',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '定义服务人员界面工单转发窗口转发消息的默认类型。',
        'Defines the default type of the article for this operation.' => '定义本次操作中信件的默认类型。',
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            '定义服务人员界面邮件外出窗口默认的消息类型。',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '定义服务人员界面关闭工单窗口默认的备注类型。',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '定义服务人员界面工单批量操作窗口默认的备注类型。',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段窗口默认的备注类型。',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '定义服务人员界面工单备注窗口默认的备注类型。',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单所有者窗口默认的备注类型。',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单挂起窗口默认的备注类型。',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '定义服务人员界面工单电话接入窗口默认的备注类型。',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '定义服务人员界面工单电话拨出窗口默认的备注类型。',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单优先级窗口默认的备注类型。',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '定义服务人员界面工单负责人窗口默认的备注类型。',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '定义客户界面工单详情窗口默认的备注类型。',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '定义服务人员界面如果URL地址没有给定操作参数时使用的默认前端模块。',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '定义客户界面如果URL地址没有给定操作参数时使用的默认前端模块。',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '定义公共界面操作参数的默认值。操作参数用于系统中的脚本。',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '定义工单默认可见的发送人类型（默认：客户）。',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '定义显示在日历事件中的动态字段。',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '定义打开fetchmail二进制文件的路径。注意:二进制文件名必须为\'fetchmail\'，如果不是，请使用符号链接。',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '定义信件中处理文本的过滤器，以便高亮URL地址。',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '定义服务人员界面工单编写窗口响应的发件人格式（[% Data.OrigFrom | html %]是发件人，[% Data.OrigFromName |html %] 是仅有发件人真实姓名。',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '定义本系统的正式域名。这个设置用于变量OTRS_CONFIG_FQDN，在所有的消息表单中使用，以创建系统内部到工单的链接。',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '定义每一个客户联系人都在的组（如果启用了客户组支持，并且您不想去管理这些组中的每一个用户）。',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '定义本窗口富文本编辑器组件的高度。输入数值（像素值）或百分比值（相对值）。',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '定义富文本编辑器组件的高度。输入数值（像素值）或百分比值（相对值）。',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单关闭操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单邮件操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '为工单自定义字段窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '为工单备注操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '为工单所有者操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '为工单挂起操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话接入操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话拨出操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '为工单优先级操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '为工单负责人操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '为工单展开操作窗口定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '为本次操作定义历史注释信息，以用于服务人员界面的工单历史。',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单关闭操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单邮件操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '为工单自定义字段操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '为工单备注操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '为工单所有者操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '为工单挂起操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话接入操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '为工单电话拨出操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '为工单优先级操作窗口定义历史类型，以用于服务人员界面的工单历史。',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '为工单负责人操作窗口定义历史类型，以用于服务人员界面的工单历史。',
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
            '定义在线软件仓库列表。另一个用于安装的软件仓库，例如：键="http://example.com/otrs/public.pl?Action=PublicRepository;File=" ，值="Some Name"。 ',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '定义错误窗口可用的下一步操作列表,可以根据需要添加外部链接（必须提供完整路径）。',
        'Defines the list of types for templates.' => '定义模板类型的列表。',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '定义为额外软件包获取在线软件仓库列表的地址，将使用第一个可用的结果。',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '定义系统的日志模块。“File（文件）”将所有消息写入一个指定的日志文件，“SysLog（系统日志）”使用操作系统的syslog守护进程如syslogd。',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '定义通过浏览器上传文件的最大尺寸（单位：字节）。警告：这个选项设置过小将使您的OTRS实例出现许多遮罩窗口导致停止工作（可能是需要用户输入的任何遮罩窗口）。',
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
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '定义服务人员界面如果服务人员在“不在办公室”期间登录系统就显示一个通知的模块。',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '定义服务人员界面如果服务人员在系统维护期间登录系统就显示一个通知的模块。',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '定义服务人员界面如果服务人员会话数达到预警值时就显示一个通知的模块。',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '定义服务人员界面如果以管理员帐户登录系统（正常情况下您不应该用管理员帐户工作）就显示一个通知的模块。',
        'Defines the module to generate code for periodic page reloads.' =>
            '定义生成定期页面刷新代码的模块。',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '定义发送邮件的模块。“Sendmail”直接使用操作系统中的Sendmail程序；任何“SMTP”方式使用指定的外部邮件服务器；“DoNotSendEmail（不发送邮件）”不会发送邮件，在测试系统时有用。',
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
            '定义存储客户联系人偏好设置的表的名称。',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '定义服务人员界面工单编写窗口编写/答复一个工单后下一个可能的状态。',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '定义服务人员界面工单转发窗口转发一个工单后下一个可能的状态。',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '定义服务人员界面工单外出邮件窗口发送一个消息后下一个可能的状态。',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '定义客户界面客户工单下一个可能的状态。',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '定义服务人员界面工单关闭窗口添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '定义服务人员界面工单批量操作窗口添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '定义服务人员界面工单自定义字段操作窗口添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '定义服务人员界面工单备注窗口添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单所有者操作窗口添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单挂起操作窗口添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '定义服务人员界面工单优先级操作窗口添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '定义服务人员界面工单负责人操作窗口添加备注后的下一个工单状态。',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '定义服务人员界面工单退回操作窗口退回工单后的下一个工单状态。',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '定义服务人员界面转移工单窗口转移工单到另一队列后的下一个工单状态。',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '定义HTML信件预览时的每行字符数，替换事件通知模块的模板生成器设置。',
        'Defines the number of days to keep the daemon log files.' => '定义保留守护进程日志文件的天数。',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '定义前端模块添加和更新邮件管理员过滤器的标题字段，最多99个字段。',
        'Defines the parameters for the customer preferences table.' => '定义客户偏好设置表的参数。',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '定义仪表板后端的参数。“Cmd（命令行）”用于指定带参数的命令；“GROUP（组）用于本插件的访问权限限制（如 Group:admin;group1;group2）；“Default（默认）”代表这个插件是默认启用还是需要用户手动启用；“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '定义仪表板后端的参数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）；“Default（默认）”代表这个插件是默认启用还是需要用户手动启用；“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '定义仪表板后端的参数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）；“Default（默认）”代表这个插件是默认启用还是需要用户手动启用；“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '定义仪表板后端的参数。“Limit（限制）定义默认显示的条目数；“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）；“Default（默认）”代表这个插件是默认启用还是需要用户手动启用；“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '定义仪表板后端的参数。“Limit（限制）定义默认显示的条目数；“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）；“Default（默认）”代表这个插件是默认启用还是需要用户手动启用；“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
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
        'Defines the sender for rejected emails.' => '定义拒绝邮件的发件人。',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '定义服务人员真实姓名和给定队列邮件地址之间的分隔符。',
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
            '定义发送给客户联系人关于新帐户的通知邮件的主题。',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '定义发送给客户联系人关于新密码的通知邮件的主题。',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '定义发送给客户联系人关于请求的新密码的链接的通知邮件的主题。',
        'Defines the subject for rejected emails.' => '定义拒绝邮件的主题。',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '定义系统管理员的邮件地址，它将显示在本系统的错误窗口中。',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '定义本系统的标识符。每个工单编号和HTTP会话字符串均包含这个ID。这确保只有属于本系统的工单才会被跟进处理（在两套OTRS实例间通讯时有用）。',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '定义到外部客户数据库的目标属性，例如：\'AsPopup PopupType_TicketAction\'。',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '定义到外部客户数据库的目标属性，例如：\'target="cdb"\'。',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '定义要显示为日历事件的工单字段。“键”定义工单字段或工单属性，“值”定义显示的名称。',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '定义一个指定日历（可能在以后分配给一个指定的队列）的时区。',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '使用公共模块“PublicSupportDataCollector”（例如用于OTRS守护进程的模块）来定义支持数据收集的超时（以秒为单位，最小为20秒）。',
        'Defines the two-factor module to authenticate agents.' => '定义服务人员的双因素身份验证模块。',
        'Defines the two-factor module to authenticate customers.' => '定义客户的双因素身份验证模块。',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '定义本系统的WEB服务器使用的协议类型。如果要用HTTPS协议代替明文的HTTP协议，就在这里指定。 因为这个设置并不影响WEB服务器的设置或行为，所以不会改变访问本系统的方式。 如果设置错误，也不会阻止您登录系统。这个设置只是作为一个变量OTRS_CONFIG_HttpType使用，可以在系统使用的所有消息的表单中找到，用来创建在系统内到工单的链接。',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '定义服务人员界面工单编写窗口使用的普通文本邮件引用字符。如果这个设置为空或不激活，原始邮件将不会被引用而是追加到回复内容中。',
        'Defines the user identifier for the customer panel.' => '定义客户门户的用户标识符。',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '定义访问SOAP句柄(bin/cgi-bin/rpc.pl)的用户名。',
        'Defines the valid state types for a ticket.' => '定义一个工单有效的状态类型。',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '定义解锁的工单有效的状态。为解锁工单，可以使用脚本"bin/otrs.Console.pl Maint::Ticket::UnlockTimeout"。',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '定义工单能看到的锁定状态。注意：修改这个设置后，请确保删除缓存以便使用新值。默认：未锁定，临时锁定。',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '定义本窗口中富文本编辑器组件的宽度。输入数值（像素值）或百分比值（相对值）。',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '定义富文本编辑器组件的宽度。输入数值（像素值）或百分比值（相对值）。',
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
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '定义进入概览视图时要展开的信件类型。如果没有定义，则展开最近的信件。',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '定义在链接的工单列表中不出现的工单状态类型。',
        'Delete expired cache from core modules.' => '删除核心模块过期的缓存。',
        'Delete expired loader cache weekly (Sunday mornings).' => '每周删除过期的载入器缓存（星期天早晨）。',
        'Delete expired sessions.' => '删除过期的会话。',
        'Deleted link to ticket "%s".' => '到工单“%s”的链接已删除。',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '如果会话ID被无效的远程IP地址使用则删除该会话。',
        'Deletes requested sessions if they have timed out.' => '删除超时的会话请求。',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '启用后，如果发生了任何的AJAX错误，就在前端传递扩展的调试信息。',
        'Deploy and manage OTRS Business Solution™.' => '部署并管理OTRS商业版。',
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
            '确定在客户界面创建新客户工单后的下一个窗口。',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '确定在客户界面跟进工单窗口的下一个窗口。',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '确定工单转移队列后的下一个窗口。LastScreenOverview将返回到最后的概览窗口（例如：搜索结果、队列视图、仪表板），TicketZoom将返回到工单详情视图。',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '确定挂起工单在到达时间限制后变更状态的可能状态。',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '确定服务人员界面电话工单显示为收件人（To:）和邮件工单显示为发件人（From:）的字符串。如果NewQueueSelectionType参数设置为“队列”，"<Queue>"显示队列名称，如果NewQueueSelectionType参数设置“系统邮件地址”，"<Realname> <<Email>>"显示收件人的名称和邮件地址。',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '确定客户界面工单显示为收件人（To:）的字符串。如果NewQueueSelectionType参数设置为“队列”，"<Queue>"显示队列名称，如果NewQueueSelectionType参数设置“系统邮件地址”，"<Realname> <<Email>>"显示收件人的名称和邮件地址。',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '确定链接对象显示在每个遮罩窗口的方式。',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '确定服务人员界面收件人（电话工单）和发件人（邮件工单）哪些选项有效。',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '确定客户界面哪些队列可以作为工单的有效收件人。',
        'Development' => '开发',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '禁用HHTP头"Content-Security-Policy"以便允许载入扩展的脚本内容。禁用这个HTTP头可能引起安全问题！仅在您知道您在干什么时才禁用它！',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '禁用HHTP头"X-Frame-Options: SAMEORIGIN" 以便允许OTRS可以包含在其它网址的IFrame框架中。禁用这个HTTP头可能有安全问题！仅在您知道您在干什么时才禁用它！',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE.' =>
            '禁用IE中IFrame框架的受限安全，可能在IE的SSO（单点登录）中需要。',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '禁止发送提醒通知给工单负责人（需要激活Ticket::Responsible设置）。',
        'Disables the communication between this system and OTRS Group servers that provides cloud services. If active, some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '禁用本系统到OTRS集团提供云服务的服务器的通讯。如果激活，某些功能如系统注册、发送支持数据、升级到OTRS Business Solution™（OTRS商业版）、OTRS Verify™（OTRS验证）、仪表板中的OTRS新闻和产品新闻小部件等将失效。',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '禁用WEB安装程序(http://yourhost.example.com/otrs/installer.pl)，防止系统被劫持。如果设置为“否”，系统能够被重新安装，当前的基本配置将被安装脚本的预设问题替换。如果不禁用，还同时禁用了通用代理、软件包管理和SQL查询窗口。',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '在全文搜索使用停止词时显示一个警告并阻止搜索',
        'Display settings to override defaults for Process Tickets.' => '为流程工单显示设置值覆盖默认值。',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '在工单详情视图中显示所用工时。',
        'Dropdown' => '下拉选择框',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的荷兰语停止词。这些词将从搜索索引中移除。',
        'Dynamic Fields Checkbox Backend GUI' => '动态字段复选框后端图形界面',
        'Dynamic Fields Date Time Backend GUI' => '动态字段日期时间后端图形界面',
        'Dynamic Fields Drop-down Backend GUI' => '动态字段下拉框后端图形界面',
        'Dynamic Fields GUI' => '动态字段图形界面',
        'Dynamic Fields Multiselect Backend GUI' => '动态字段多选框后端图形界面',
        'Dynamic Fields Overview Limit' => '动态字段概览限制',
        'Dynamic Fields Text Backend GUI' => '动态字段文本框后端图形界面',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '用于输出搜索结果为CSV格式的动态字段。',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '流程小部件的动态字段组。键是组名，值是要显示的动态字段。例如：\'键 => My Group\'，\'值: Name_X, NameY\'。',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '动态字段概览视图的每页动态字段数',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '在客户界面工单消息窗口显示动态字段的选项。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。注意：如果您想在客户界面工单详情视图显示这些动态字段，还需要启用CustomerTicketZoom###DynamicField设置。',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在客户界面工单详情窗口工单回复区段显示动态字段的选项。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面外出邮件窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在服务人员界面工单详情窗口流程小部件显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在服务人员界面工单详情窗口侧边栏显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单关闭窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单编写窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单邮件窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单转发窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单自定义字段窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在服务人员界面工单基本概览视图窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单转移窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单备注窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在客户界面工单概览窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单所有者窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单挂起窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单电话接入窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单电话拨出窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单电话沟通窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在服务人员界面工单预览格式概览窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在服务人员界面工单打印窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在客户界面工单打印窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在客户界面工单打印窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '在服务人员界面工单负责人窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且必填。',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在服务人员界面工单搜索结果概览窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '在服务人员界面工单搜索窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用，2 - 启用且默认显示。',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在客户界面工单搜索窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '在服务人员界面工单简洁概览视图窗口显示的动态字段。可能的设置：0 - 禁用，1 - 可用，2 - 默认启用。',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '在客户界面工单详情窗口显示的动态字段。可能的设置：0 - 禁用，1 - 启用。',
        'DynamicField' => 'DynamicField（动态字段）',
        'DynamicField backend registration.' => '动态字段后端注册。',
        'DynamicField object registration.' => '动态字段对象注册。',
        'E-Mail Outbound' => '外发邮件',
        'Edit Customer Companies.' => '编辑客户单位。',
        'Edit Customer Users.' => '编辑客户联系人。',
        'Edit customer company' => '编辑客户单位',
        'Email Addresses' => '邮件地址',
        'Email Outbound' => '外发邮件',
        'Email sent to "%s".' => '邮件已发送给“%s”.',
        'Email sent to customer.' => '邮件已发送给客户联系人。',
        'Enable keep-alive connection header for SOAP responses.' => '启用SOAP响应的持久连接头。',
        'Enabled filters.' => '启用的过滤器',
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
        'Enables spell checker support.' => '启用拼写检查。',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '启用最小的工单计数器大小（如果TicketNumberGenerator工单编号生成器选择为“日期”）',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '启用工单批量操作，以在服务人员前端一次性操作多个工单。',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '仅对列表中的组启用批量操作功能。',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '启用工单负责人功能，以跟踪指定的工单。',
        'Enables ticket watcher feature only for the listed groups.' => '仅对列表中的组启用工单关注人功能。',
        'English (Canada)' => '英语（加拿大）',
        'English (United Kingdom)' => '英语（英国）',
        'English (United States)' => '英语（美国）',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的英语停止词，这些词将从搜索索引中移除。',
        'Enroll process for this ticket' => '这个工单的注册过程',
        'Enter your shared secret to enable two factor authentication.' =>
            '输入你的共享密钥以启用双因素身份验证。',
        'Escalation response time finished' => '工单升级响应时间完成',
        'Escalation response time forewarned' => '工单升级响应时间预先警告',
        'Escalation response time in effect' => '工单升级响应实际时间',
        'Escalation solution time finished' => '工单升级解决时间完成',
        'Escalation solution time forewarned' => '工单升级解决时间预先警告',
        'Escalation solution time in effect' => '工单升级解决实际时间',
        'Escalation update time finished' => '工单升级更新时间完成',
        'Escalation update time forewarned' => '工单升级更新时间预先警告',
        'Escalation update time in effect' => '工单升级更新实际时间',
        'Escalation view' => '升级视图',
        'EscalationTime' => '升级时间',
        'Estonian' => '爱沙尼亚',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '事件模块注册。为获得更好的性能你可以定义一个触发事件（例如：事件 => 工单创建）。',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '事件模块注册。为获得更好的性能你可以定义一个触发事件（例如：事件 => 工单创建），只有工单的所有动态字段需要同一事件时才可能。',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '对TicketIndex（工单索引）执行更新语句以重命名列队名称（如果有重命名需要且使用静态数据库）的事件模块。',
        'Event module that updates customer user search profiles if login changes.' =>
            '登录用户变化时更新客户联系人搜索模板的事件模块。',
        'Event module that updates customer user service membership if login changes.' =>
            '登录用户变化时更新客户联系人服务关系的事件模块。',
        'Event module that updates customer users after an update of the Customer.' =>
            '更新客户资料后更新客户联系人的事件模块。',
        'Event module that updates tickets after an update of the Customer User.' =>
            '更新客户联系人后更新工单的事件模块。',
        'Event module that updates tickets after an update of the Customer.' =>
            '更新客户后更新工单的事件模块。',
        'Events Ticket Calendar' => '事件日历',
        'Execute SQL statements.' => '执行SQL语句。',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '执行定制的命令或模块。注意：如果使用模块，需要使用函数。',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '为主题中没有工单编号的邮件执行回复或引用头的跟进检查。',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '为主题中没有工单编号的邮件执行附件内容的跟进检查。',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '为主题中没有工单编号的邮件执行邮件正文内容的跟进检查。',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '为主题中没有工单编号的邮件执行未加工的源邮件的跟进检查。',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '在搜索结果中输出整个信件树（这会影响系统性能）。',
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
        'First Queue' => '第一队列',
        'FirstLock' => '首次锁定',
        'FirstResponse' => '首次响应',
        'FirstResponseDiffInMin' => '首次响应时间差（分钟）',
        'FirstResponseInMin' => '首次响应时间（分钟）',
        'Firstname Lastname' => '名 姓',
        'Firstname Lastname (UserLogin)' => '名 姓（登录用户名）',
        'FollowUp for [%s]. %s' => '[%s]. %s的跟进',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '外发邮件强制编码为（7bit|8bit|可打印|base64）。',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '工单锁定后强制选择与当前不同的另一个工单状态，定义键为当前状态，值为锁定后的下一个工单状态。',
        'Forces to unlock tickets after being moved to another queue.' =>
            '工单转移到另一队列后强制解锁。',
        'Forwarded to "%s".' => '已转发给“%s”。',
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
            '客户界面前端模块注册（如果没有可用流程，禁用工单流程窗口）。',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '前端模块注册（如果没有可用流程，禁用工单流程窗口）。',
        'Frontend module registration for the agent interface.' => '服务人员界面的前端模块注册。',
        'Frontend module registration for the customer interface.' => '客户界面的前端模块注册。',
        'Frontend theme' => '前端界面主题',
        'Frontend theme.' => '前端界面主题。',
        'Full value' => '全值',
        'Fulltext index regex filters to remove parts of the text.' => '用于移除部分文本的全文索引正则表达式',
        'Fulltext search' => '全文搜索',
        'Galician' => '加利西亚语',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '显示在工单概览视图中的一般工单数据。可能的设置为：0 = 禁用， 1 = 可用的，2 = 默认启用。注意：工单编号是必需的，无法禁用。',
        'Generate dashboard statistics.' => '生成仪表板统计。',
        'Generic Info module.' => '通用信息模块。',
        'GenericAgent' => '自动任务',
        'GenericInterface Debugger GUI' => '通用接口调试器图形界面',
        'GenericInterface Invoker GUI' => '通用接口调用程序图形界面',
        'GenericInterface Operation GUI' => '通用接口操作图形界面',
        'GenericInterface TransportHTTPREST GUI' => '通用接口传输HTTPREST 图形界面',
        'GenericInterface TransportHTTPSOAP GUI' => '通用接口传输HTTPSOAP 图形界面',
        'GenericInterface Web Service GUI' => '通用接口WEB服务图形界面',
        'GenericInterface Webservice History GUI' => '通用接口WEB服务历史图形界面',
        'GenericInterface Webservice Mapping GUI' => '通用接口WEB服务映射图形界面',
        'GenericInterface module registration for the invoker layer.' => '调用程序层的通用接口模块注册。',
        'GenericInterface module registration for the mapping layer.' => '映射层的通用接口模块注册。',
        'GenericInterface module registration for the operation layer.' =>
            '操作层的通用接口模块注册。',
        'GenericInterface module registration for the transport layer.' =>
            '传输层的通用接口模块注册。',
        'German' => '德语',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的德语停止词，这些词将从搜索索引中移除。',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '给最终用户覆盖CSV文件中的分隔符的机会，在翻译文件中定义分隔符。',
        'Global Search Module.' => '全局搜索模块。',
        'Go back' => '返回',
        'Google Authenticator' => '谷歌身份验证器',
        'Graph: Bar Chart' => '图形：条形图',
        'Graph: Line Chart' => '图形：折线图',
        'Graph: Stacked Area Chart' => '图形：堆叠面积图',
        'Greek' => '希腊语',
        'HTML Reference' => 'HTML引用',
        'HTML Reference.' => 'HTML引用。',
        'Hebrew' => '希伯来语',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            '帮助您扩展信件全文搜索（From, To, Cc,主题和正文搜索）。运行时对实时数据进行全文搜索（少于50000个工单时工作较好），静态数据库将搜索所有信件，并在信件创建后建立索引，越来越多的全文搜索占用约50%的空间。使用"bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild"来创建初始索引。',
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
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '如果Customer::AuthModule（客户认证模块）选择“数据库”，必须指定密码的加密类型。',
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
            '如果Customer::AuthModule（客户认证模块）选择“HTTPBasicAuth（HTTP基本认证）”，您可以指定剥离用户名的主要部分（如域名，比如将example_domain\user变为user）。',
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
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '如果日志模块选用了“SysLog”，可以指定一个专用的日志消息源（在Solaris系统中需要使用\'stream\'）。',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '如果日志模块选用了“SysLog”，可以指定记录日志的字符集。',
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
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '如果启用了此选项，OTRS将用压缩格式传送所有的CSS文件。警告：如果您关闭了此选项，在IE7中使用OTRS可能会有问题，因为IE7不能载入超过32个CSS文件。',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '如果启用了此选项，OTRS将用压缩格式传送所有的JavaScript文件。',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '如果启用了此选项，电话工单和邮件工单将在新窗口中打开。',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '如果启用了此选项，将从WEB界面、HTTP头信息和外发邮件的X-Headers头信息中移除OTRS版本标签。注意：如果你要修改这个选项，请确保清空缓存。',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '如果启用了此选项，客户可以搜索所有服务的工单（不管这个客户分配了什么服务）。',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '如果启用了此选项，所有概览视图(仪表板、锁定工单视图、队列视图)将在指定的间隔时间自动刷新。',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '如果启用了此选项，在鼠标移动到主菜单位置时打开一级子菜单（而不是需要点击后再打开）。',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '如果没有指定SendmailNotificationEnvelopeFrom，这个选项可确保使用邮件的发件人地址而不是空白的发件人（在某些邮件服务器的配置中需要此选项）。',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '如果设置了此参数，这个地址用于外发通知的信件发件人头信息。如果没有指定地址，则信件发件人头信息为空（除非设置了SendmailNotificationEnvelopeFrom::FallbackToEmailFrom参数）。',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '如果设置了此参数，这个地址将用于外发消息（不是通知-通知在下面查看）的信件发件人头。如果不指定地址，信件发件人头就为空。',
        'If this option is disabled, articles will not automatically be decrypted and stored in the database. Please note that this also means no decryption will take place and the articles will be shown in ticket zoom in their original (encrypted) form.' =>
            '如果禁用此选项，则信件将不会自动解密并存储在数据库中。 请注意，这也意味着不会发生解密，文章会以原始（加密）形式显示在工单详情窗口。',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '如果这个选项设置为“是”，服务人员或客户通过WEB界面创建的工单将收到自动响应（如果配置了自动响应）。如果这个选项设置为“否”，则不会发送自动响应。',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '如果这个正则表达式匹配了，自动响应不会发送任何消息。',
        'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '如果激活这个设置，本地修改内容不会在软件包管理器和支持数据收集工具中高亮显示为错误。',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '如果你要外出，通过设置你不在办公室的确切日期，你可能希望让其他用户知道。',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '忽略系统发件人信件类型 （如：自动响应或电子邮件通知），在 工单详情窗口或在大视图窗口自动扩展时将其标记为 \'未读信件\' 。',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '选择队列的时候默认包括子队列的工单',
        'Include unknown customers in ticket filter.' => '在工单过滤器中包括未知客户联系人。',
        'Includes article create times in the ticket search of the agent interface.' =>
            '服务人员界面工单搜索时包括工单创建时间。',
        'Incoming Phone Call.' => '来电。',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '索引加速器：选择您的后端工单视图加速器模块。“RuntimeDB（运行时数据库）”实时生成每个队列视图（工单总数不超过60000个且系统打开的工单不超过6000个时没有性能问题）。“StaticDB（静态数据库）是最强大的模块，它使用额外的类似于视图的工单索引表（工单总数超过80000且系统打开的工单超过6000时推荐使用），使用命令"bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild"来初始化索引。',
        'Indonesian' => '印度尼西亚语',
        'Input' => 'Input（输入）',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '如果您想使用拼写检查器，请在系统中安装ispell 或 aspell。请指定ispell 或 aspell在操作系统中的程序路径。',
        'Interface language' => '界面语言',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '配置不同皮肤是可能的，例如：区分系统中基于域名的不同服务人员。您可以使用一个正则表达式配置一个键/内容组合来匹配一个域名。“键”应该匹配域名，“值”是一个系统中有效的皮肤。请参照样例条目修改正则表达式的合适格式。',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '配置不同皮肤是可能的，例如：区分系统中基于域名的不同客户。您可以使用一个正则表达式配置一个键/内容组合来匹配一个域名。“键”应该匹配域名，“值”是一个系统中有效的皮肤。请参照样例条目修改正则表达式的合适格式。',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '配置不同主题是可能的，例如：区分系统中基于域名的不同服务人员和客户。您可以使用一个正则表达式配置一个键/内容组合来匹配一个域名。“键”应该匹配域名，“值”是一个系统中有效的皮肤。请参照样例条目修改正则表达式的合适格式。',
        'Italian' => '意大利语',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '全文索引的意大利语停止词，这些词将从搜索索引中移除。',
        'Ivory' => '象牙白',
        'Ivory (Slim)' => '象牙白（修身版）',
        'Japanese' => '日语',
        'JavaScript function for the search frontend.' => '搜索界面的JavaScript函数。',
        'Last customer subject' => '最后客户主题',
        'Lastname Firstname' => '姓 名',
        'Lastname Firstname (UserLogin)' => '姓 名（登录用户名）',
        'Lastname, Firstname' => '姓, 名',
        'Lastname, Firstname (UserLogin)' => '姓, 名（登录用户名）',
        'Latvian' => '拉脱维亚语',
        'Left' => '左',
        'Link Object' => '链接对象',
        'Link Object.' => '链接对象。',
        'Link agents to groups.' => '链接服务人员到组。',
        'Link agents to roles.' => '链接服务人员到角色。',
        'Link attachments to templates.' => '链接附件到模板。',
        'Link customer user to groups.' => '链接客户联系人到组',
        'Link customer user to services.' => '链接客户联系人到服务。',
        'Link queues to auto responses.' => '链接队列到自动响应',
        'Link roles to groups.' => '链接角色到组',
        'Link templates to queues.' => '链接模板到队列',
        'Links 2 tickets with a "Normal" type link.' => '将2个工单链接为“普通”。',
        'Links 2 tickets with a "ParentChild" type link.' => '将2个工单链接为“父子”。',
        'List of CSS files to always be loaded for the agent interface.' =>
            '服务人员界面始终载入的CSS文件列表。',
        'List of CSS files to always be loaded for the customer interface.' =>
            '客户界面始终载入的CSS文件列表。',
        'List of JS files to always be loaded for the agent interface.' =>
            '服务人员界面始终载入的JS文件列表。',
        'List of JS files to always be loaded for the customer interface.' =>
            '客户界面始终载入的JS文件列表。',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '图形界面显示的客户单位事件列表。',
        'List of all CustomerUser events to be displayed in the GUI.' => '图形界面显示的客户联系人事件列表。',
        'List of all DynamicField events to be displayed in the GUI.' => '图形界面显示的动态字段事件列表。',
        'List of all Package events to be displayed in the GUI.' => '图形界面显示的软件包事件列表。',
        'List of all article events to be displayed in the GUI.' => '图形界面显示的信件事件列表。',
        'List of all queue events to be displayed in the GUI.' => '图形界面显示的队列事件列表。',
        'List of all ticket events to be displayed in the GUI.' => '图形界面显示的工单事件列表。',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '自动分配给新建队列的默认标准模板列表',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '服务人员界面始终载入的响应CSS文件列表。',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '客户界面始终载入的响应CSS文件列表。',
        'List view' => '列表视图',
        'Lithuanian' => '立陶宛语',
        'Lock / unlock this ticket' => '锁定/解锁这个工单',
        'Locked Tickets.' => '锁定的工单。',
        'Locked ticket.' => '锁定的工单。',
        'Log file for the ticket counter.' => '工单计数器的日志文件。',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '退出客户面板。',
        'Loop-Protection! No auto-response sent to "%s".' => '邮件循环保护! 没有自动响应发送给“%s”.',
        'Mail Accounts' => '邮件帐户',
        'Main menu registration.' => '主菜单注册。',
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
        'Manage existing sessions.' => '管理已登录会话。',
        'Manage support data.' => '管理支持数据。',
        'Manage system registration.' => '管理系统注册。',
        'Manage tasks triggered by event or time based execution.' => '管理事件触发或基于时间执行的任务',
        'Mark this ticket as junk!' => '标记这个工单为垃圾!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '在编写工单窗口客户信息表格（电话和邮件）的最大尺寸（单位：字符）。',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '服务人员界面已通知的服务人员窗口的最大尺寸（单位：行）。',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '服务人员界面相关的服务人员窗口的最大尺寸（单位：行）。',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '在邮件回复和一些概览视图窗口信件主题的最大尺寸。',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '一天中给自己的邮件地址自动邮件响应最大数（邮件循环保护）。',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '通过POP3/POP3S/IMAP/IMAPS能够收取的邮件最大尺寸（单位：KB）。',
        'Maximum Number of a calendar shown in a dropdown.' => '一个日历显示在下拉选择框中的最大数字。',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '工单详情视图信件动态字段的最大长度（单位：字符）。',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '工单详情视图侧边栏动态字段的最大长度（单位：字符）。',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '服务人员界面搜索结果显示的最大工单数。',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '客户界面搜索结果显示的最大工单数。',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '本次操作结果显示的最大工单数。',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '工单详情视图客户信息表格的最大尺寸（单位：字符）。',
        'Merge this ticket and all articles into another ticket' => '将这个工单和所有的信件合并到另一工单',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '合并工单<OTRS_TICKET>到 <OTRS_MERGE_TO_TICKET>。',
        'Miscellaneous' => '杂项',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '客户界面创建工间窗口用于选择的模块。',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '检查邮件是否标记为内部邮件的模块（因为转发的内部邮件）。信件类型和发件人类型定义了到达邮件/信件的值。',
        'Module to check the group permissions for customer access to tickets.' =>
            '检查客户访问工单组权限的模块。',
        'Module to check the group permissions for the access to tickets.' =>
            '检查访问工单组权限的模块。',
        'Module to compose signed messages (PGP or S/MIME).' => '编写签名（PGP或S/MIME）消息的模块。',
        'Module to crypt composed messages (PGP or S/MIME).' => '加密（PGP或S/MIME）已编写消息的模块。',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '收取客户用户进入消息的SMIME证书的模块。',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '和处理进入消息的模块。阻止或忽略所有发件人为noreply@开头地址的垃圾邮件',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '和处理进入消息的模块。工单自定义字段取得4个数字的号码，使用正则表达式匹配，如收件人 =>  \'(.+?)@.+?\'，在set => 像[***]g一样使用()。',
        'Module to filter encrypted bodies of incoming messages.' => '过滤进入消息加密过的正文的模块。',
        'Module to generate accounted time ticket statistics.' => '生成工单统计所用工时的模块。',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '在服务人员界面为简化工单搜索生成HTML开放式搜索模板的模块。',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '在客户界面为简化工单搜索生成HTML开放式搜索模板的模块。',
        'Module to generate ticket solution and response time statistics.' =>
            '生成工单解决时间和响应时间统计的模块。',
        'Module to generate ticket statistics.' => '生成工单统计的模块。',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '如果工单的客户ID匹配客户的客户ID则授予访问权限的模块。',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '如果工单的客户ID匹配客户的客户联系人ID则授予访问权限的模块。',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '授予访问曾经涉及一个工单的服务人员权限的模块（基于工单历史条目）。',
        'Module to grant access to the agent responsible of a ticket.' =>
            '授予到工单负责人访问权限的模块。',
        'Module to grant access to the creator of a ticket.' => '授予访问工单创建人权限的模块。',
        'Module to grant access to the owner of a ticket.' => '授予访问工单所有者权限的模块。',
        'Module to grant access to the watcher agents of a ticket.' => '授予访问工单关注人服务人员人权限的模块。',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '显示通知和升级信息的模块（ShownMax：显示升级的最大数，EscalationInMinutes：显示将在...分钟内升级的工单，CacheTime：经计算的升级缓冲秒数）',
        'Module to use database filter storage.' => '使用数据库过滤器的模块。',
        'Multiselect' => '多选',
        'My Services' => '我的服务',
        'My Tickets.' => '我的工单。',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '定制队列的名称。定制队列是您的首选队列，能够在偏好设置中选择。',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '定制服务的名称。定制服务是您的首选服务，能够在偏好设置中选择。',
        'NameX' => 'NameX',
        'Nederlands' => '荷兰语',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => '新工单[%s]已创建(Q=%s;P=%s;S=%s)。',
        'New Window' => '新窗口',
        'New owner is "%s" (ID=%s).' => '新的所有者是：“%s” (ID=%s)。',
        'New process ticket' => '新的流程工单',
        'New responsible is "%s" (ID=%s).' => '新的负责人是：“%s” (ID=%s)。',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '服务人员界面工单电话接入窗口在添加一个电话备注后工单可能的下一状态。',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '服务人员界面工单电话拨出窗口在添加一个电话备注后工单可能的下一状态。',
        'None' => '没有',
        'Norwegian' => '挪威语',
        'Notification sent to "%s".' => '通知已发送给 “%s”.',
        'Number of displayed tickets' => '显示工单个数',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '服务人员界面搜索工具显示每个工单的行数。',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '服务人员界面搜索结果每页显示的工单数。',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '客户界面搜索结果每页显示的工单数。',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTRS能够使用一个或多个只读镜像数据库以扩展操作（如全文搜索或生成统计报表）。您可以在这里指定第一个镜像数据库的DSN（数据源名称）。',
        'Old: "%s" New: "%s"' => '旧的: “%s” 新的: “%s”',
        'Open tickets (customer user)' => '处理中的工单（客户联系人）',
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
        'Out Of Office' => '不在办公室',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '重载（重定义）Kernel::System::Ticket中的函数，以便容易添加定制内容。',
        'Overview Escalated Tickets.' => '升级工单概览。',
        'Overview Refresh Time' => '概览刷新间隔',
        'Overview of all escalated tickets.' => '所有升级了的工单的概览。',
        'Overview of all open Tickets.' => '所有处理中的工单概览。',
        'Overview of all open tickets.' => '所有处理中的工单概览。',
        'Overview of customer tickets.' => '客户工单概览。',
        'PGP Key Management' => 'PGP密钥管理',
        'Package event module file a scheduler task for update registration.' =>
            '软件包事件模块注册。',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '服务人员界面偏好设置视图创建下一个遮罩对象的参数。',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '服务人员界面偏好设置视图定制队列对象的参数。',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '服务人员界面偏好设置视图定制服务对象的参数。',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '服务人员界面偏好设置刷新时间对象的参数。',
        'Parameters for the column filters of the small ticket overview.' =>
            '工单概览简洁模式的字段过滤器参数。',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面客户单位信息的仪表板后端的参数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTL”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面客户ID状态小部件的仪表板后端的参数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面客户联系人列表视图仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '服务人员界面新工单概览仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。注意：只有工单属性和动态字段（DynamicField_NameX）允许作为默认字段。可能的设置为：0 = 禁用， 1 = 可用，2 = 默认启用。',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '服务人员界面工单处理概览仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。注意：只有工单属性和动态字段（DynamicField_NameX）允许作为默认字段。可能的设置为：0 = 禁用， 1 = 可用，2 = 默认启用。',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面队列概览小部件仪表板后端的参数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“队列权限组”不是强制要求的，如果启用了，只有属于这个权限组中的队列才会进入列表。 “状态”是状态的列表，键是小部件中状态的排序顺序。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用；“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面运行中的流程工单概览仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '服务人员界面工单升级概览仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。注意：只有工单属性和动态字段（DynamicField_NameX）允许作为默认字段。可能的设置为：0 = 禁用， 1 = 可用，2 = 默认启用。',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面工单事件日历仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '服务人员界面工单挂起提醒概览仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。注意：只有工单属性和动态字段（DynamicField_NameX）允许作为默认字段。可能的设置为：0 = 禁用， 1 = 可用，2 = 默认启用。',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面工单统计仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '服务人员界面即将发生的事件小部件仪表板后端的参数。“Limit（限制）定义默认显示的条目数。“GROUP（组）用于到本插件的访问权限限制（如 Group:admin;group1;group2）。“Default（默认）”代表这个插件是默认启用还是需要用户手动启用。“CacheTTLLocal”表明本插件的缓存过期时间（单位：分钟）。',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '动态字段概览视图用来显示动态字段的页面的参数。',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '工单基本概览视图用来显示工单的页面的参数。',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '工单简洁概览视图用来显示工单的页面的参数。',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '工单预览概览用来显示工单的页面的参数。',
        'Parameters of the example SLA attribute Comment2.' => 'SLA样例属性Comment2（注释2）的参数。',
        'Parameters of the example queue attribute Comment2.' => '队列样例属性Comment2（注释2）的参数。',
        'Parameters of the example service attribute Comment2.' => '服务样例属性Comment2（注释2）的参数。',
        'ParentChild' => '父子',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '日志文件的路径（仅在邮件循环保护模块选择文件系统时适用且这是强制需要的）。',
        'People' => '人员',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '为每个配置的WEB服务的每个事件执行配置好的操作（以调用程序角色）。',
        'Permitted width for compose email windows.' => '编写邮件窗口允许的宽度。',
        'Permitted width for compose note windows.' => '编写备注窗口允许的宽度。',
        'Persian' => '波斯语',
        'Phone Call.' => '电话。',
        'Picture Upload' => '图片上传',
        'Picture upload module.' => '图片上传模块。',
        'Picture-Upload' => '图片上传',
        'Polish' => '波兰语',
        'Portuguese' => '葡萄牙语',
        'Portuguese (Brasil)' => '葡萄牙语（巴西）',
        'PostMaster Filters' => '邮箱管理员过滤器',
        'PostMaster Mail Accounts' => '邮箱管理员邮件帐户',
        'Process Management Activity Dialog GUI' => '流程管理 活动对话框的图形界面',
        'Process Management Activity GUI' => '流程管理 活动的图形界面',
        'Process Management Path GUI' => '流程管理 路径的图形界面',
        'Process Management Transition Action GUI' => '流程管理 转换动作的图形界面',
        'Process Management Transition GUI' => '流程管理 转换的图形界面',
        'Process Ticket.' => '流程工单。',
        'Process pending tickets.' => '处理挂起的工单。',
        'Process ticket' => '流程工单',
        'ProcessID' => '流程ID',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '针对CSRF（跨站请求伪造）漏洞利用的保护（参阅http://en.wikipedia.org/wiki/Cross-site_request_forgery获取更多信息）。',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '提供一个按状态和队列的工单矩阵概览。',
        'Queue view' => '队列视图',
        'Rebuild the ticket index for AgentTicketQueue.' => '为AgentTicketQueue（服务人员工单队列）重建工单索引。',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '通过外部工单编号识别一个工单是否为已有工单的跟进。',
        'Refresh interval' => '刷新间隔',
        'Removed subscription for user "%s".' => '用户“%s”已移除的关注。',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '工单归档时移除该工单的关注人信息。',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be active in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '从客户后端更新已有的SMIME证书。注意：需要在系统配置中激活SMIME和SMIME::FetchFromCustomer，且客户后端模块需要配置为收取UserSMIMECertificate 属性。',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '服务人员界面工单编写窗口，用客户联系人当前的邮件地址替换编写回复时的原始发件人。',
        'Reports' => '报表',
        'Reports (OTRS Business Solution™)' => '报表 (OTRS商业版)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '从spool目录中重新处理的邮件不能被导入到第一的位置。',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '服务人员界面修改一个工单的客户必需的权限。',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '服务人员界面使用关闭工单窗口必需的权限。',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '服务人员界面使用外发邮件窗口必需的权限。',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '服务人员界面使用退回工单窗口必需的权限。',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '服务人员界面使用编写工单窗口必需的权限。',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '服务人员界面使用工单转发窗口必需的权限。',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '服务人员界面使用工单自定义字段窗口必需的权限。',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '服务人员界面使用合并工单窗口必需的权限。',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '服务人员界面使用工单备注窗口必需的权限。',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '服务人员界面使用工单所有者窗口必需的权限。',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '服务人员界面使用工单挂起窗口必需的权限。',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '服务人员界面使用工单接入电话窗口必需的权限。',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '服务人员界面使用工单拨出电话窗口必需的权限。',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '服务人员界面使用工单优先级窗口必需的权限。',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '服务人员界面使用工单负责人窗口必需的权限。',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '如果工单转移到另一个队列，重置并解锁工单所有者。',
        'Responsible Tickets' => '负责的工单',
        'Responsible Tickets.' => '负责的工单.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '从归档中恢复一个工单（只针对工单状态变更为任何可处理的状态的事件）。',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '在列表中保留所有的服务，即使他们是无效的子元素。',
        'Right' => '右',
        'Roles <-> Groups' => '角色 <-> 组',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '运行基于文件的自动任务(注意：需要在-configuration-module参数中指定模块名，如"Kernel::System::GenericAgent")。',
        'Running Process Tickets' => '运行中的流程工单',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '访问管理客户单位模块时执行一个初始的已有全部客户单位的搜索。',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '访问管理客户联系人模块时执行一个初始的已有全部客户联系人的搜索。',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '系统运行到“演示”模式。如果设置为“是”，服务人员能够修改偏好设置，如通过WEB界面选择语言和主题，这些变更只对当前会话有效。服务人员不能修改密码。',
        'Russian' => '俄语',
        'SMS' => '短信',
        'SMS (Short Message Service)' => '短信(短消息)',
        'Sample command output' => '命令输出样例',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '保存信件的附件。“数据库”在数据库中存储所有数据（不推荐在存储大容量附件时使用）。“文件系统”在文件系统中保存数据；这个选项更快但WEB服务器要以OTRS用户运行。即使是在生产环境您也可以在这两种模式间切换，而不会丢失数据。备注：使用“文件系统”时不能搜索附件名。',
        'Schedule a maintenance period.' => '计划一个系统维护期。',
        'Screen' => '窗口',
        'Search Customer' => '搜索客户',
        'Search Ticket.' => '搜索工单。',
        'Search Tickets.' => '搜索工单。',
        'Search User' => '搜索用户',
        'Search backend default router.' => '搜索的后端默认路由。',
        'Search backend router.' => '搜索的后端路由。',
        'Search.' => '搜索。',
        'Second Queue' => '第二队列',
        'Select after which period ticket overviews should refresh automatically.' =>
            '选择工单概览视图自动刷新的时间间隔。',
        'Select how many tickets should be shown in overviews by default.' =>
            '选择概览视图中默认显示的工单数。',
        'Select the main interface language.' => '选择主界面语言。',
        'Select your default spelling dictionary.' => '选择默认的拼写检查字典。',
        'Select your preferred layout for OTRS.' => '选择你喜欢的OTRS布局。',
        'Select your preferred theme for OTRS.' => '选择你喜欢的OTRS界面主题。',
        'Selects the cache backend to use.' => '选择使用的缓存后端。',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '选择处理WEB界面上传文件的模块。“数据库”存储所有上传文件到数据库中，“文件系统”存储所有上传文件到文件系统中。',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '选择工单编号生成器模块。“自动增量”--递增工单编号，系统ID和计数器配合使用的格式为：系统ID.计数器（如1010138、1010139）。“日期”--会用当前日期、系统ID和计数器共同生成工单编号，格式为：年.月.日.系统ID.计数器（如200206231010138、200206231010139）。“日期校验和”--计数器的值以校验和的方式追加日期和系统ID的字符串后面，校验和每日轮换，这种格式为：年.月.日.系统ID.计数器.校验和（如2002070110101520、2002070110101535）。“随机”--生成随机的工单编号，格式为：系统ID.随机数（如100057866352、103745394596）。',
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
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '发送在系统管理界面“通知（事件）”中配置好的通知。',
        'Serbian Cyrillic' => '塞尔维亚西里尔语',
        'Serbian Latin' => '塞尔维亚拉丁语',
        'Service view' => '服务视图',
        'ServiceView' => '服务视图',
        'Set a new password by filling in your current password and a new one.' =>
            '填写当前密码和一个新的密码来设置新密码。',
        'Set sender email addresses for this system.' => '为系统设置发件人的邮件地址.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '设置服务人员工单详情窗口内嵌HTML信件的默认高度（单位：像素）。',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '设置一个自动任务执行一次能处理的工单数限制。',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '设置服务人员工单详情窗口内嵌HTML信件的最大高度（单位：像素）。',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '设置最小日志级别。 如果选择\'error\'，则只会记录错误。 使用\'debug\'可以获取所有日志消息。 日志级别的顺序是：\'debug\'，\'info\'，\'notice\'和\'error\'。',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '如果你信任所有的公共和私有PGP密钥（即使它们不是可信任签名认证的），设置这个参数为“是”。',
        'Sets if SLA must be selected by the agent.' => '设置是否必须由服务人员选择SLA。',
        'Sets if SLA must be selected by the customer.' => '设置是否必须由客户选择SLA。',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '设置是否必须由服务人员填写备注，能够被参数Ticket::Frontend::NeedAccountedTime覆盖。',
        'Sets if service must be selected by the agent.' => '设置是否必须由服务人员选择服务。',
        'Sets if service must be selected by the customer.' => '设置是否必须由客户选择服务。',
        'Sets if ticket owner must be selected by the agent.' => '设置是否必须由服务人员选择工单所有者。',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '如果工单状态变更到非挂起状态，设置挂起时间为0。',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '为包含尚未触碰的工单的高亮队列设置老化时间（单位：分钟）（一线）。',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '为包含尚未处理的工单的高亮队列设置老化时间（单位：分钟）（二线）。',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '设置系统管理员的配置级别。取决于配置级别，一些系统配置选项不会显示。配置级别递升序次为：专家、高级、新手。更高的配置级别是（例如新手是最高级别），更低级别是管理员在某种程度上只是偶尔配置一下就不再使用了。',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '设置工单概览的预览模式中工单计数是可见的。',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '设置服务人员界面新建邮件工单的默认信件类型。',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '设置服务人员界面新建电话工单的默认信件类型。',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '设置服务人员界面关闭工单窗口添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '设置服务人员界面转移工单窗口添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注窗口添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单所有者窗口添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单挂起窗口添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级窗口添加备注的的默认正文文本。',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人窗口添加备注的的默认正文文本。',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '设置服务人员和客户界面登录窗口的默认错误消息，在系统处于维护期时显示。',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '设置服务人员界面拆分工单的默认链接类型。',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '设置服务人员和客户界面登录窗口的默认消息，在系统处于维护期时显示。',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '设置系统处于维护期时显示通知的默认消息。',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '设置服务人员界面新建电话工单的默认下一状态。',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '设置服务人员界面创建邮件工单后的默认下一状态。',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '设置服务人员界面新建电话工单的默认备注文本，例如：“通过电话新建的工单”。',
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
            '设置服务人员界面新建电话工单的默认主题，例如“打电话”。',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '设置服务人员界面关闭工单窗口添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '设置服务人员界面转移工单窗口添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注窗口添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面转移工单窗口添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面挂起工单窗口添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级窗口添加备注的默认主题。',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人窗口添加备注的默认主题。',
        'Sets the default text for new email tickets in the agent interface.' =>
            '设置服务人员界面新建邮件工单的默认文本。',
        'Sets the display order of the different items in the preferences view.' =>
            '设置在偏好设置视图显示不同条目的顺序。',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '设置一个会话被终止且用户登出前的非活动时间（单位：秒）。',
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
            '设置最小的工单计数器大小（如果工单编号生成器选用“自动增量”）。默认是5（位数），意味着计数器从10000开始。',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '设置在系统维护期多少分钟之前开始显示一个引起注意的通知。',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '设置文本消息显示的行数（例如：队列视图中工单的行）。',
        'Sets the options for PGP binary.' => '设置PGP程序的选项。',
        'Sets the order of the different items in the customer preferences view.' =>
            '设置客户偏好设置视图显示不同条目的顺序。',
        'Sets the password for private PGP key.' => '设置PGP私钥的密码。',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '设置首选的时间单位（如 work units、小时、分钟）。',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '设置配置的web服务器上脚本目录的前缀，这个设置用于变量OTRS_CONFIG_ScriptAlias，此变量可在系统的所有消息表单中找到，用来在系统内创建到工单的链接。',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单关闭窗口的队列。',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单自定义字段窗口的队列。',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单备注窗口的队列。',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单所有者窗口的队列。',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单挂起窗口的队列。',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级窗口的队列。',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单负责人窗口的队列。',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '设置服务人员界面工单关闭窗口的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '设置服务人员界面工单批量操作窗口的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '设置服务人员界面工单自定义字段窗口的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注窗口的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单所有者窗口的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单挂起窗口的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级窗口的服务人员负责人。',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人窗口的服务人员负责人。',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '设置服务人员界面工单关闭窗口的服务（需要激活工单::服务）。',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '设置服务人员界面工单自定义字段窗口的服务（需要激活工单::服务）。',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '设置服务人员界面工单备注窗口的服务（需要激活工单::服务）。',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '设置服务人员界面工单所有者窗口的服务（需要激活工单::服务）。',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '设置服务人员界面工单挂起窗口的服务（需要激活工单::服务）。',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '设置服务人员界面工单优先级窗口的服务（需要激活工单::服务）。',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '设置服务人员界面工单负责人窗口的服务（需要激活工单::服务）。',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '设置服务人员界面关闭工单窗口的工单状态。',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '设置服务人员界面工单批量处理窗口的工单状态。',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '设置服务人员界面工单自定义字段窗口的工单状态。',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注窗口的工单状态。',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人窗口的工单状态。',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单详情的所有者窗口的工单状态。',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单详情的挂起窗口的工单状态。',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单详情的优先级窗口的工单状态。',
        'Sets the stats hook.' => '设置统计挂钩。',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '设置系统时区（需要系统采用UTC时间，否则与本地时间会有时间差）。',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '设置服务人员界面关闭工单窗口的工单所有者。',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '设置服务人员界面工单批量操作窗口的工单所有者。',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '设置服务人员界面工单自定义字段窗口的工单所有者。',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '设置服务人员界面工单备注窗口的工单所有者。',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单所有者窗口的工单所有者。',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单挂起窗口的工单所有者。',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '设置服务人员界面工单优先级窗口的工单所有者。',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '设置服务人员界面工单负责人窗口的工单所有者。',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '设置服务人员界面工单挂起窗口的工单所有者。',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '设置服务人员界面工单批量操作窗口的工单类型。',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '设置服务人员界面工单自定义字段窗口的工单类型（需要激活工单::类型）。',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '设置服务人员界面工单备注窗口的工单类型（需要激活工单::类型）。',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '设置服务人员界面工单所有者窗口的工单类型（需要激活工单::类型）。',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '设置服务人员界面工单挂起窗口的工单类型（需要激活工单::类型）。',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '设置服务人员界面工单优先级窗口的工单类型（需要激活工单::类型）。',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '设置服务人员界面工单负责人窗口的工单类型（需要激活工单::类型）。',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '设置http/ftp下载的超时时间（单位：秒）。',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '设置软件下载的超时时间（单位：秒），覆盖参数“WebUserAgent::Timeout”。',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '按用户设置用户时区（需要系统采用UTC时间且设置了时区，否则会与本地时间有时间差）。',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '基于Javascript或浏览器时区在登录时按用户设置用户时区。',
        'Shared Secret' => '共享密钥',
        'Should the cache data be held in memory?' => '缓存数据应该保留在内存吗？',
        'Should the cache data be stored in the selected cache backend?' =>
            '缓存数据要保存到选择的缓存后端吗？',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '在服务人员界面电话/邮件工单中显示负责人选择。',
        'Show article as rich text even if rich text writing is disabled.' =>
            '以富文本格式显示信件（即使富文本编写被禁用）。',
        'Show queues even when only locked tickets are in.' => '显示队列（即使队列里只有已锁定的工单）。',
        'Show the current owner in the customer interface.' => '在客户界面显示工单当前所有者。',
        'Show the current queue in the customer interface.' => '在客户界面显示当前队列。',
        'Show the history for this ticket' => '显示这个工单的历史',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '如果信件有附件，在工单详情视图显示有计数的图标。',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为关注/取消关注工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为链接工单到另一对象菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为合并工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为访问工单历史菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为工单自定义字段菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为添加工单备注菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为添加工单备注菜单显示一个链接。',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为关闭工单菜单显示一个链接。',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为关闭工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '在服务人员界面所有工单概览视图，为删除工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为删除工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '在服务人员界面工单详情视图中，为注册工单到一个流程菜单显示一个链接。',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为返回菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '在服务人员界面工单概览视图中，为锁定/解锁工单显示一个链接。',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为锁定/解锁工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为转移工单菜单显示一个链接。',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为打印工单/信件菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为查看请求工单的客户菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。在服务人员界面工单详情视图中，为锁定/解锁工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为查看工单历史菜单显示一个链接。',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为查看工单所有者菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为查看工单优先级菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为查看工单负责人菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为发送工单的外发邮件菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '在服务人员界面工单各种概览视图中，在菜单中为设置工单为垃圾显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为挂起工单菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序。',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为设置工单优先级菜单显示一个链接。',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '在服务人员界面所有工单概览视图，为工单详情窗口菜单显示一个链接。',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '在服务人员界面信件详情视图中，为通过HTML在线查看器访问信件附件显示一个链接。',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '在服务人员界面信件详情视图中，为下载信件附件显示一个链接。',
        'Shows a link to see a zoomed email ticket in plain text.' => '为以纯文本查看邮件工单显示一个链接。',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '在服务人员界面工单详情视图中，为设置工单为垃圾菜单显示一个链接。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。 为了给菜单条目分组，使用键"ClusterName（菜单组名称）"，其值可为您想在界面上看到的任何菜单组名称（系统默认为Miscellaneous-杂项），使用键"ClusterPriority（菜单组优先级）"来配置工具栏中菜单组的显示顺序',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '在服务人员界面关闭工单窗口，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '在服务人员界面工单自定义字段窗口，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '在服务人员界面工单备注窗口，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单所有者窗口，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单挂起窗口，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单优先级窗口，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面工单负责人窗口，显示这个工单相关的所有服务人员列表。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '在服务人员界面关闭工单窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '在服务人员界面工单自定义字段窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '在服务人员界面工单备注窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单所有者窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单挂起窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单优先级窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面工单负责人窗口，显示这个工单所有可能的服务人员（需要具有这个队列或工单的备注权限）列表，用于确定谁将收到关于这个备注的通知。',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '显示工单概览的预览（如果参数CustomerInfo值为1，还将显示客户信息，参数CustomerInfoMaxSize定义了显示客户信息的最大字符数）。',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '显示一个工单队列视图中工单列表排序的工单属性选择器，可用于选择的属性项可通过参数\'TicketOverviewMenuSort###SortAttributes\'配置。',
        'Shows all both ro and rw queues in the queue view.' => '在工单队列视图中显示所有RO（只读）和RW（读写）队列。',
        'Shows all both ro and rw tickets in the service view.' => '在工单服务视图中显示所有RO（只读）和RW（读写）服务。',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '在服务人员界面工单升级视图显示所有处理中的工单（即使工单已被锁定）。',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '在服务人员界面工单状态视图显示所有处理中的工单（即使工单已被锁定）。',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '在工单详情视图显示显示这个工单所有展开的信件。',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '在多选框字段中显示所有的客户ID（如果客户ID过多则不可用）。',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '在一个多选框字段中显示所有的客户联系人（如果客户联系人过多则不好用）。',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '在服务人员界面电话和邮件工单窗口显示所有者选择器。',
        'Shows colors for different article types in the article table.' =>
            '在信件表格中为不同的信件类型显示不同的颜色。',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '在AgentTicketPhone（服务人员电话工单）、AgentTicketEmail（服务人员邮件工单）和AgentTicketCustomer（服务人员客户工单）模块显示客户历史工单信息。',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '在工单概览视图简洁模式显示最近的客户信件的主题或工单标题。',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '以树形或列表形式显示系统中存在的父/子队列的清单。',
        'Shows information on how to start OTRS Daemon' => '显示如何启动OTRS守护进程的信息。',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '在客户界面显示已激活的工单属性（0 = 禁用，1 = 启用）。',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '在服务人员界面工单详情视图，按正常排序或反向排序显示信件。',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '在工单编写窗口显示客户联系人信息（电话和邮件）。',
        'Shows the customer user\'s info in the ticket zoom view.' => '在工单详情视图显示客户联系人信息。',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '在服务人员仪表板显示当天消息（MOTD）。“组”用来限制本插件的访问权限（如 组: admin;group1;group2;）。“默认”表示本插件是默认启用还是需要用户手动启用。',
        'Shows the message of the day on login screen of the agent interface.' =>
            '在服务人员界面登录窗口显示当天消息（MOTD）。',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '在服务人员界面显示工单历史（倒序）。',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '在服务人员界面关闭工单窗口是否显示工单优先级的选项。',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '在服务人员界面转移工单窗口是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '在服务人员界面工单批量操作窗口是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '在服务人员界面工单自定义字段窗口是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '在服务人员界面工单备注窗口是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单所有者窗口是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单挂起窗口是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单优先级窗口是否显示工单优先级的选项。',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面工单负责人窗口显示工单优先级选项。',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '在服务人员界面工单自定义字段窗口显示工单标题标题字段。',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '在服务人员界面关闭工单窗口显示工单标题字段。',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '在服务人员界面工单备注窗口显示工单标题字段。',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单所有者窗口显示工单标题字段。',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单挂起窗口显示工单标题字段。',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '在服务人员界面工单优先级窗口显示工单标题字段。',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '在服务人员界面工单负责人窗口显示工单标题字段。',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '如果设置为“是”，则以长格式显示时间（天、小时、分钟）；如果设置为“否”，则以短格式显示时间（天、小时）。',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '如果设置为“是”，则显示时间的完整描述（days-天，hours-小时，minutes-分钟）；如果设置为“否”，则只显示时间的首字母（d-天，h-时,m-分）。',
        'Simple' => '简单',
        'Skin' => '皮肤',
        'Slovak' => '斯洛伐克语',
        'Slovenian' => '斯洛文尼亚语',
        'Software Package Manager.' => '软件包管理器。',
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
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '为这个工单遮罩窗口（工单自定义字段窗口）指定可用的备注类型。如果取消选择这个选项，则使用ArticleTypeDefault（默认信件类型）的设置且从遮罩窗口中移除备注类型选项。',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '服务人员界面编写工单窗口，如果不能自动检测到信件类型，指定默认的信件类型。',
        'Specifies the different article types that will be used in the system.' =>
            '指定将在系统中使用的不同信件类型。',
        'Specifies the different note types that will be used in the system.' =>
            '指定将在系统中使用的不同备注类型。',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '如果TicketStorageModule参数设置为“FS（文件系统）”，指定存储数据的目录。',
        'Specifies the directory where SSL certificates are stored.' => '指定存储SSL证书的目录。',
        'Specifies the directory where private SSL certificates are stored.' =>
            '指定存储私有SSL证书的目录。',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '指定系统发送通知的邮件地址。这个邮件地址用来创建通知管理员的完整显示名称（如"OTRS通知"otrs@your.example.com），您可以使用配置的变量OTRS_CONFIG_FQDN，或者选择另外的邮件地址。',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '指定从调度程序任务获取通知消息的邮件地址。',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '指定组名，以便组中有rw（读写）权限的用户能够访问“切换到客户”功能。',
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
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '指定在创建缓存文件时使用多少级子目录，这可以防止一个目录中有太多的缓存文件。',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '指定获取OTRS商业版更新的通道。警告：开发版可能无法完成更新，您的系统可能经历无法恢复的错误，并且系统在极端情况下可能变得无法响应！',
        'Specify the password to authenticate for the first mirror database.' =>
            '指定第一个镜像数据库的认证密码。',
        'Specify the username to authenticate for the first mirror database.' =>
            '指定第一个镜像数据库的认证用户名。',
        'Spell checker.' => '拼写检查器。',
        'Stable' => '稳定的',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '系统中服务人员可用的标准权限，如果需要更多的权限，可以在这里输入。权限必须已定义好且有效，一些好的权限已经内置：备注、关闭、挂起、客户、自定义字段、转移、编写、负责人、转发和退回。请确保“rw（读写）始终是注册权限的最后一条。',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '统计计数的开始数，这个数字在每个新的统计后增加。',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '在打开链接对象遮罩窗口后搜索一次所有活动对象。',
        'Stat#' => '统计号',
        'Status view' => '状态视图',
        'Stores cookies after the browser has been closed.' => '在浏览器关闭后保存cookies。',
        'Strips empty lines on the ticket preview in the queue view.' => '在工单队列视图工单预览时去掉空白行。',
        'Strips empty lines on the ticket preview in the service view.' =>
            '在工单服务视图工单预览时去掉空白行。',
        'Swahili' => '斯瓦希里语',
        'Swedish' => '瑞典语',
        'System Address Display Name' => '系统邮件地址显示姓名',
        'System Maintenance' => '系统维护',
        'System Request (%s).' => '系统请求 (%s)。',
        'Target' => '目标',
        'Templates <-> Queues' => '模板 <-> 队列',
        'Textarea' => '多行文本',
        'Thai' => '泰国语',
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
        'The daemon registration for the scheduler task worker.' => 'task worker调度程序的守护进程注册。',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'TicketHook和工单编号之间的分隔符，如“:”。',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '发出事件后的持续时间，在这个时间段抑制新的升级通知和开始事件。',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '邮件主题的格式，“左”代表\'[TicketHook#:12345] Some Subject\'，“右”代表\'Some Subject [TicketHook#:12345]\'，“无”代表\'Some Subject\'（没有工单编号）。如果设置为“无”，您应该验证设置PostMaster::CheckFollowUpModule###0200-References是激活的，以识别邮件头的跟进。',
        'The headline shown in the customer interface.' => '客户界面显示的标题。',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '工单的标识符，如Ticket#、Call#、MyTicket#，默认为Ticket#。',
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
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '服务人员界面显示在登录窗口的LOGO，图片的URL地址必须是皮肤图片目录的相对URL。',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '在工单详情窗口一个页面上能展开的最大信件数。',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '在工单详情窗口一个页面上能显示的最大信件数。',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '重连到邮件服务器前一次能收取邮件的最大数。',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '回复邮件中加在主题前的文字，如RE、AW或AS。',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '转发邮件中加在主题前的文字，如FW、Fwd或WG。',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            '这个事件模块存储客户联系人的属性为工单动态字段，如何配置这个映射请查看上面的设置。',
        'This is the default orange - black skin for the customer interface.' =>
            '这是客户界面默认的橙色-黑色皮肤。',
        'This is the default orange - black skin.' => '这是默认的橙色-黑色皮肤。',
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
            '这个选项将拒绝客户联系人访问不是由他本人创建的客户工单。',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '这个设置允许您使用自己的国家列表覆盖内置的国家列表，如果您只想用到一小部分的国家时格外有用。',
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
        'Ticket Owner.' => '工单所有者。',
        'Ticket Pending.' => '工单挂起。',
        'Ticket Print.' => '工单打印。',
        'Ticket Priority.' => '工单优先级。',
        'Ticket Queue Overview' => '工单队列概览',
        'Ticket Responsible.' => '工单负责人。',
        'Ticket Watcher' => '工单关注人',
        'Ticket Zoom.' => '工单详情。',
        'Ticket bulk module.' => '工单批量操作模块。',
        'Ticket event module that triggers the escalation stop events.' =>
            '触发升级停止事件的工单事件模块。',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => '工单转移到新队列：“%s” (%s) ，原队列为：“%s” (%s)。',
        'Ticket notifications' => '工单通知',
        'Ticket overview' => '工单概览',
        'Ticket plain view of an email.' => '显示工单邮件的纯文本。',
        'Ticket title' => '工单标题',
        'Ticket zoom view.' => '工单详情视图。',
        'TicketNumber' => '工单编号',
        'Tickets.' => '工单。',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '如果设置一个挂起状态，添加到实际时间的秒数（默认：86400 = 1天）。',
        'Title updated: Old: "%s", New: "%s"' => '标题已更新，原为：“%s”，新标题：“%s”。',
        'To accept login information, such as an EULA or license.' => '接受登录信息，如EULA（最终用户许可协议）或许可。',
        'To download attachments.' => '下载附件。',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '在软件包管理器中显示/不显示OTRS扩展功能。',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '工具栏条目的快捷键。可以通过使用键“Group（组）”和值如“rw:group1;move_into:group2”来实现显示/不显示这个链接的额外访问控制。',
        'Transport selection for ticket notifications.' => '工单通知的传输选择。',
        'Tree view' => '树形视图',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '工单升级事件和工单升级通知事件的触发器。',
        'Turkish' => '土耳其语',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '关闭SSL证书验证，例如在使用HTTPS透明代理时。使用这个设置风险自负！',
        'Turns on drag and drop for the main navigation.' => '开启主菜单的拖放功能。',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '开启图形界面使用的动画。如果使用动画有问题（如性能问题），您可以在这里关闭动画。',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '开启远程IP地址检查，如果系统通过代理或拨号连接，应该设置为“否”，因为远程IP在每次请求时可能都不一样。',
        'Ukrainian' => '乌克兰语',
        'Unlock tickets that are past their unlock timeout.' => '过了解锁超时时间后解锁工单。',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '每当添加备注或所有者不在办公室时，解锁工单。',
        'Unlocked ticket.' => '解锁的工单。',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '如果每个工单都已看过或创建了新的信件，更新工单“已看”标志',
        'Updated SLA to %s (ID=%s).' => '%s (ID=%s)已更新SLA。',
        'Updated Service to %s (ID=%s).' => '%s (ID=%s)已更新服务。',
        'Updated Type to %s (ID=%s).' => '%s (ID=%s)已更新类型。',
        'Updated: %s' => '已更新: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => '已更新： %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '在工单属性更新后更新工单升级指标。',
        'Updates the ticket index accelerator.' => '更新工单索引加速器。',
        'Upload your PGP key.' => '上传你的PGP密钥。',
        'Upload your S/MIME certificate.' => '上传你的S/MIME证书。',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '服务人员界面在合适的地方（输入字段）使用新式选择和自动完成字段。',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '客户界面在合适的地方（输入字段）使用新式选择和自动完成字段。',
        'UserFirstname' => '用户的名字',
        'UserLastname' => '用户的姓',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '服务人员界面工单编写窗口在编写邮件回答时使用在回复CC列表中的Cc收件人。',
        'Uses richtext for viewing and editing ticket notification.' => '查看和编辑工单通知时使用富文本。',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '查看和编辑以下内容时使用富文本：信件、问候语、签名、标准模板、自动响应和通知。',
        'Vietnam' => '越南语',
        'View performance benchmark results.' => '查看性能基准测试结果.',
        'Watch this ticket' => '关注这个工单',
        'Watched Tickets.' => '关注的工单。',
        'We are performing scheduled maintenance.' => '我们正在执行计划的系统维护。',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '我们正在执行系统维护，暂时无法登录。',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '我们正在执行系统维护，很快就恢复正常使用。',
        'Web View' => 'WEB视图',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '工单被合并时，自动添加一个备注到不再活动的工单，您可以在这里定义这个备注的正文（这个文本不能被服务人员修改）。',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '工单被合并时，自动添加一个备注到不再活动的工单，您可以在这里定义这个备注的主题（这个主题不能被服务人员修改）。',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '工单被合并时，通过设置“通知发送人”复选框选项，客户能收到邮件通知，您可以在这个文本框中定义一个预先格式化的文本（服务人员可在以后修改）。',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '通过在Ticket::Frontend::ZoomCollectMetaFilters中配置的过滤器确定是否收集信件元信息。',
        'Yes, but hide archived tickets' => '是的，但是隐藏已归档的工单。',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '您的工单号为“<OTRS_TICKET>”的邮件已经退回给“<OTRS_BOUNCE_TO>”，请联系这个地址以获得更多的信息。',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '你的优先队列中选择的队列，如果启用了，你还会得到有关这些队列的电子邮件通知。',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '你的优先服务中选择的服务，如果启用了，你还会得到有关这些队列的电子邮件通知。',
        'attachment' => '附件',
        'bounce' => '退回',
        'compose' => '编写',
        'debug' => '调试',
        'error' => '错误',
        'forward' => '转发',
        'info' => '信息',
        'inline' => '内联',
        'notice' => '注意',
        'pending' => '挂起',
        'responsible' => '负责人',
        'stats' => 'stats',

    };
    # $$STOP$$
    return;
}

1;
