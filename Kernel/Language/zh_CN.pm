# --
# Kernel/Language/zh_CN.pm -  provides Chinese Simple language translation
# Copyright (C) 2005 zuowei <j2ee at hirain-sh.com>
# Copyright (C) 2008-2009 Never Min <never at qnofae.org>
# Copyright (C) 2009 Bin Du <bindu2008 at gmail.com>,
# Copyright (C) 2009 Yiye Huang <yiyehuang at gmail.com>
# Copyright (C) 2009 Qingjiu Jia <jiaqj at yahoo.com>
# --
# $Id: zh_CN.pm,v 1.69.2.1 2009-09-22 13:04:55 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.69.2.1 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sun Jul 19 12:24:20 2009

    # possible charsets
    $Self->{Charset} = ['GBK', 'GB2312', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%Y.%M.%D %T';
    $Self->{DateFormatLong}      = ' %A %Y/%M/%D %T';
    $Self->{DateFormatShort}     = '%Y.%M.%D';
    $Self->{DateInputFormat}     = '%Y.%M.%D';
    $Self->{DateInputFormatLong} = '%Y.%M.%D - %T';

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
        'last' => '最后',
        'before' => '早于',
        'day' => '天',
        'days' => '天',
        'day(s)' => '天',
        'hour' => '小时',
        'hours' => '小时',
        'hour(s)' => '小时',
        'minute' => '分钟',
        'minutes' => '分钟',
        'minute(s)' => '分钟',
        'month' => '月',
        'months' => '月',
        'month(s)' => '月',
        'week' => '星期',
        'week(s)' => '星期',
        'year' => '年',
        'years' => '年',
        'year(s)' => '年',
        'second(s)' => '秒',
        'seconds' => '秒',
        'second' => '秒',
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
        'Example' => '示例',
        'Examples' => '示例',
        'valid' => '有效',
        'invalid' => '无效',
        '* invalid' => '* 无效',
        'invalid-temporarily' => '暂时无效',
        ' 2 minutes' => ' 2 分钟',
        ' 5 minutes' => ' 5 分钟',
        ' 7 minutes' => ' 7 分钟',
        '10 minutes' => '10 分钟',
        '15 minutes' => '15 分钟',
        'Mr.' => '先生',
        'Mrs.' => '夫人',
        'Next' => '下一个',
        'Back' => '后退',
        'Next...' => '下一个...',
        '...Back' => '...后退',
        '-none-' => '-无-',
        'none' => '无',
        'none!' => '无!',
        'none - answered' => '无 - 已答复的',
        'please do not edit!' => '不要编辑!',
        'AddLink' => '增加链接',
        'Link' => '链接',
        'Unlink' => '未链接',
        'Linked' => '已链接',
        'Link (Normal)' => '链接 (正常)',
        'Link (Parent)' => '链接 (父)',
        'Link (Child)' => '链接 (子)',
        'Normal' => '正常',
        'Parent' => '父',
        'Child' => '子',
        'Hit' => '点击',
        'Hits' => '点击数',
        'Text' => '正文',
        'Standard' => '标准',
        'Lite' => '简洁',
        'User' => '用户',
        'Username' => '用户名称',
        'Language' => '语言',
        'Languages' => '语言',
        'Password' => '密码',
        'Salutation' => '称谓',
        'Signature' => '签名',
        'Customer' => '客户',
        'CustomerID' => '客户编号',
        'CustomerIDs' => '客户编号',
        'customer' => '客户',
        'agent' => '技术支持人员',
        'system' => '系统',
        'Customer Info' => '客户信息',
        'Customer Company' => '客户单位',
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
        'Valid' => '有效',
        'Invalid Option!' => '无效选项!',
        'Invalid time!' => '无效时间!',
        'Invalid date!' => '无效日期!',
        'Name' => '名称',
        'Group' => '组名',
        'Description' => '描述',
        'description' => '描述',
        'Theme' => '主题',
        'Created' => '创建',
        'Created by' => '创建由',
        'Changed' => '已修改',
        'Changed by' => '修改由',
        'Search' => '搜索',
        'and' => '和',
        'between' => '在',
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
        'Add' => '增加',
        'Added!' => '已增加!',
        'Category' => '目录',
        'Viewer' => '查看器',
        'Expand' => '扩展',
        'New message' => '新消息',
        'New message!' => '新消息!',
        'Please answer this ticket(s) to get back to the normal queue view!' => '请先回复该 Ticket，然后回到正常队列视图!',
        'You got new message!' => '您有新消息!',
        'You have %s new message(s)!' => '您有 %s 条新消息!',
        'You have %s reminder ticket(s)!' => '您有 %s 个提醒!',
        'The recommended charset for your language is %s!' => '建议您所用语言的字符集 %s!',
        'Passwords doesn\'t match! Please try it again!' => '密码不符，请重试!',
        'Password is already in use! Please use an other password!' => '该密码被使用，请使用其他密码!',
        'Password is already used! Please use an other password!' => '该密码被使用，请使用其他密码!',
        'You need to activate %s first to use it!' => '%s 在使用之前请先激活!',
        'No suggestions' => '无建议',
        'Word' => '字',
        'Ignore' => '忽略',
        'replace with' => '替换',
        'There is no account with that login name.' => '该用户名没有帐户信息.',
        'Login failed! Your username or password was entered incorrectly.' => '登录失败，您的用户名或密码不正确.',
        'Please contact your admin' => '请联系系统管理员',
        'Logout successful. Thank you for using OTRS!' => '成功注销，谢谢使用!',
        'Invalid SessionID!' => '无效的会话标识符!',
        'Feature not active!' => '该特性尚未激活!',
        'Notification (Event)' => '通知（事件）',
        'Login is needed!' => '需要先登录!',
        'Password is needed!' => '需要密码!',
        'License' => '许可证',
        'Take this Customer' => '取得这个客户',
        'Take this User' => '取得这个用户',
        'possible' => '可能',
        'reject' => '拒绝',
        'reverse' => '后退',
        'Facility' => '类别',
        'Timeover' => '结束',
        'Pending till' => '等待至',
        'Don\'t work with UserID 1 (System account)! Create new users!' => '不要使用 UserID 1 (系统账号)! 请创建一个新的用户!',
        'Dispatching by email To: field.' => '分派邮件到: 域.',
        'Dispatching by selected Queue.' => '分派邮件到所选队列.',
        'No entry found!' => '无内容!',
        'Session has timed out. Please log in again.' => '会话超时，请重新登录.',
        'No Permission!' => '无权限!',
        'To: (%s) replaced with database email!' => 'To: (%s) 被数据库邮件地址所替代',
        'Cc: (%s) added database email!' => 'Cc: (%s) 增加数据库邮件地址!',
        '(Click here to add)' => '(点击此处增加)',
        'Preview' => '预览',
        'Package not correctly deployed! You should reinstall the Package again!' => '软件包展开不正常! 您需要再一次重新安装这个软件包',
        'Added User "%s"' => '增加用户 "%s".',
        'Contract' => '合同',
        'Online Customer: %s' => '在线客户: %s',
        'Online Agent: %s' => '在线技术支持人员：%s',
        'Calendar' => '日历',
        'File' => '文件',
        'Filename' => '文件名',
        'Type' => '类型',
        'Size' => '大小',
        'Upload' => '上传',
        'Directory' => '目录',
        'Signed' => '已签名',
        'Sign' => '签署',
        'Crypted' => '已加密',
        'Crypt' => '加密',
        'Office' => '办公室',
        'Phone' => '电话',
        'Fax' => '传真',
        'Mobile' => '手机',
        'Zip' => '邮编',
        'City' => '城市',
        'Street' => '街道',
        'Country' => '国家',
        'Location' => '区',
        'installed' => '已安装',
        'uninstalled' => '未安装',
        'Security Note: You should activate %s because application is already running!' => '安全提示: 您不能激活的 %s, 因为此应用已经在运行!',
        'Unable to parse Online Repository index document!' => '不能分列在线资源索引文档',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '在线资源中没有软件包对应需要的框架，但有其他的框架所需软件包',
        'No Packages or no new Packages in selected Online Repository!' => '在所选的在线资源中，没有现存或新的软件包',
        'printed at' => '打印日期',
        'Loading...' => '',
        'Dear Mr. %s,' => '尊敬的 %s 先生:',
        'Dear Mrs. %s,' => '尊敬的 %s 女士:',
        'Dear %s,' => '尊敬的 %s:',
        'Hello %s,' => '您好, %s:',
        'This account exists.' => '这个帐户已存在',
        'New account created. Sent Login-Account to %s.' => '新的帐号已创建, 并寄送通知给 %s.',
        'Please press Back and try again.' => '请返回再试一次.',
        'Sent password token to: %s' => '发送密码到: %s',
        'Sent new password to: %s' => '发送新的密码到: %s',
        'Upcoming Events' => '即将到来的事件',
        'Event' => '事件',
        'Events' => '事件',
        'Invalid Token!' => '非法的标记',
        'more' => '更多',
        'For more info see:' => '更多信息请看',
        'Package verification failed!' => '软件包验证失败',
        'Collapse' => '收起',
        'Shown' => '显示',
        'News' => '新闻',
        'Product News' => '产品新闻',
        'OTRS News' => 'OTRS 新闻',
        '7 Day Stats' => '最近 7 天统计',
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
        'Indent' => '缩',
        'Outdent' => '外突',
        'Create an Unordered List' => '创建一个无序列表',
        'Create an Ordered List' => '创建一个有序列表',
        'HTML Link' => 'HTML链接',
        'Insert Image' => '插入图像',
        'CTRL' => '按CTRL',
        'SHIFT' => '按SHIFT',
        'Undo' => '复原',
        'Redo' => '重做',

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

        # Template: AAANavBar
        'Admin-Area' => '管理区域',
        'Agent-Area' => '技术支持人员区',
        'Ticket-Area' => 'Ticket区',
        'Logout' => '注销',
        'Agent Preferences' => '个人设置',
        'Preferences' => '设置',
        'Agent Mailbox' => '技术支持人员邮箱',
        'Stats' => '统计',
        'Stats-Area' => '统计区',
        'Admin' => '管理',
        'Customer Users' => '客户用户',
        'Customer Users <-> Groups' => '客户用户 <-> 组',
        'Users <-> Groups' => '用户 <-> 组',
        'Roles' => '角色',
        'Roles <-> Users' => '角色 <-> 用户',
        'Roles <-> Groups' => '角色 <-> 组',
        'Salutations' => '称谓',
        'Signatures' => '签名',
        'Email Addresses' => 'Email 地址',
        'Notifications' => '系统通知',
        'Category Tree' => '目录树',
        'Admin Notification' => '管理员通知',

        # Template: AAAPreferences
        'Preferences updated successfully!' => '设置更新成功!',
        'Mail Management' => '邮件相关设置',
        'Frontend' => '前端界面',
        'Other Options' => '其他选项',
        'Change Password' => '修改密码',
        'New password' => '新密码',
        'New password again' => '重复新密码',
        'Select your QueueView refresh time.' => '队列视图刷新时间.',
        'Select your frontend language.' => '界面语言',
        'Select your frontend Charset.' => '界面字符集.',
        'Select your frontend Theme.' => '界面主题.',
        'Select your frontend QueueView.' => '队列视图.',
        'Spelling Dictionary' => '拼写检查字典',
        'Select your default spelling dictionary.' => '缺省拼写检查字典.',
        'Max. shown Tickets a page in Overview.' => '每一页显示的最大 Tickets 数目.',
        'Can\'t update password, your new passwords do not match! Please try again!' => '密码两次不符，无法更新，请重新输入',
        'Can\'t update password, invalid characters!' => '无法更新密码，包含无效字符.',
        'Can\'t update password, must be at least %s characters!' => '无法更新密码，密码长度至少%s位.',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => '无法更新密码，至少包含2个大写字符和2个小写字符.',
        'Can\'t update password, needs at least 1 digit!' => '无法更新密码，至少包含1位数字',
        'Can\'t update password, needs at least 2 characters!' => '无法更新密码，至少包含2个字母!',

        # Template: AAAStats
        'Stat' => '统计',
        'Please fill out the required fields!' => '请填写必填字段',
        'Please select a file!' => '请选择一个文件!',
        'Please select an object!' => '请选择一个对象!',
        'Please select a graph size!' => '请选择图片尺寸!',
        'Please select one element for the X-axis!' => '请选择一个元素的X-轴',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => '请只选择一个元素或关闭被选域的\'Fixed\'按钮',
        'If you use a checkbox you have to select some attributes of the select field!' => '如果你使用复选框你必须选择被选域的一些属性!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '在选定的输入栏请插入一个值，或关闭\'Fixed\'复选框！',
        'The selected end time is before the start time!' => '选定的结束时间早于开始时间！',
        'You have to select one or more attributes from the select field!' => '从被选域中你必须选择一个或多个属性！',
        'The selected Date isn\'t valid!' => '所选日期不有效',
        'Please select only one or two elements via the checkbox!' => '通过复选框，请只选择一个或两个要素！',
        'If you use a time scale element you can only select one element!' => '如果您使用的是时间尺度要素你只能选择其中一个组成部分',
        'You have an error in your time selection!' => '你有一个错误的时间选择！',
        'Your reporting time interval is too small, please use a larger time scale!' => '您的报告时间间隔太小，请使用更大的间隔',
        'The selected start time is before the allowed start time!' => '选定的开始时间早于允许的开始时间',
        'The selected end time is after the allowed end time!' => '选定的结束时间晚于允许的结束时间',
        'The selected time period is larger than the allowed time period!' => '在选定时间段大于允许的时间段',
        'Common Specification' => '共同规范',
        'Xaxis' => 'X轴',
        'Value Series' => '价值系列',
        'Restrictions' => '限制',
        'graph-lines' => '线图',
        'graph-bars' => '柱状图',
        'graph-hbars' => 'H柱状图',
        'graph-points' => '图点',
        'graph-lines-points' => '图线点',
        'graph-area' => '图区',
        'graph-pie' => '饼图',
        'extended' => '扩展',
        'Agent/Owner' => '所有者',
        'Created by Agent/Owner' => '技术支持人员创建的',
        'Created Priority' => '创建的优先级',
        'Created State' => '创建的状态',
        'Create Time' => '创建时间',
        'CustomerUserLogin' => '客户登陆',
        'Close Time' => '关闭时间',
        'TicketAccumulation' => 'Ticket积累',
        'Attributes to be printed' => '要打印的属性',
        'Sort sequence' => '排序序列',
        'Order by' => '按顺序排',
        'Limit' => '极限',
        'Ticketlist' => 'Ticket清单',
        'ascending' => '升序',
        'descending' => '降序',
        'First Lock' => '首先锁定',
        'Evaluation by' => '评价的人',
        'Total Time' => '总时间',
        'Ticket Average' => 'Ticket处理平均时间',
        'Ticket Min Time' => 'Ticket处理最小时间',
        'Ticket Max Time' => 'Ticket处理最大时间',
        'Number of Tickets' => 'Ticket数目',
        'Article Average' => 'Article处理平均时间',
        'Article Min Time' => 'Article处理最小时间',
        'Article Max Time' => 'Article处理最大时间',
        'Number of Articles' => 'Article数量',
        'Accounted time by Agent' => '技术支持人员处理Ticket所用的时间',
        'Ticket/Article Accounted Time' => 'Ticket/Article所占用的时间',
        'TicketAccountedTime' => 'Ticket所占用的时间',
        'Ticket Create Time' => 'Ticket创建时间',
        'Ticket Close Time' => 'Ticket关闭时间',

        # Template: AAATicket
        'Lock' => '锁定',
        'Unlock' => '解锁',
        'History' => '历史',
        'Zoom' => '邮件展开',
        'Age' => '总时间',
        'Bounce' => '回退',
        'Forward' => '转发',
        'From' => '发件人',
        'To' => '收件人',
        'Cc' => '抄送',
        'Bcc' => '暗送',
        'Subject' => '标题',
        'Move' => '移动',
        'Queue' => '队列',
        'Priority' => '优先级',
        'Priority Update' => '更新优先级',
        'State' => '状态',
        'Compose' => '撰写',
        'Pending' => '等待',
        'Owner' => '所有者',
        'Owner Update' => '更新所有者',
        'Responsible' => '负责人',
        'Responsible Update' => '更新负责人',
        'Sender' => '发件人',
        'Article' => '信件',
        'Ticket' => 'Ticket',
        'Createtime' => '创建时间',
        'plain' => '纯文本',
        'Email' => '邮件地址',
        'email' => 'E-Mail',
        'Close' => '关闭',
        'Action' => '动作',
        'Attachment' => '附件',
        'Attachments' => '附件',
        'This message was written in a character set other than your own.' => '这封邮件所用字符集与本系统字符集不符',
        'If it is not displayed correctly,' => '如果显示不正确,',
        'This is a' => '这是一个',
        'to open it in a new window.' => '在新窗口中打开',
        'This is a HTML email. Click here to show it.' => '这是一封HTML格式邮件，点击这里显示.',
        'Free Fields' => '额外信息',
        'Merge' => '合并',
        'merged' => '已合并',
        'closed successful' => '成功关闭',
        'closed unsuccessful' => '关闭失败',
        'new' => '新建',
        'open' => '打开',
        'Open' => '打开',
        'closed' => '关闭',
        'Closed' => '关闭',
        'removed' => '删除',
        'pending reminder' => '等待提醒',
        'pending auto' => '自动等待',
        'pending auto close+' => '等待自动关闭+',
        'pending auto close-' => '等待自动关闭-',
        'email-external' => '外部 E-Mail ',
        'email-internal' => '内部 E-Mail ',
        'note-external' => '外部注解',
        'note-internal' => '内部注解',
        'note-report' => '注解报告',
        'phone' => '电话',
        'sms' => '短信',
        'webrequest' => 'Web请求',
        'lock' => '锁定',
        'unlock' => '未锁定',
        'very low' => '非常低',
        'low' => '低',
        'normal' => '正常',
        'high' => '高',
        'very high' => '非常高',
        '1 very low' => '1 非常低',
        '2 low' => '2 低',
        '3 normal' => '3 正常',
        '4 high' => '4 高',
        '5 very high' => '5 非常高',
        'Ticket "%s" created!' => 'Ticket "%s" 已创建!',
        'Ticket Number' => 'Ticket 编号',
        'Ticket Object' => 'Ticket 对象',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticket "%s" 不存在，不能创建到其的链接!',
        'Don\'t show closed Tickets' => '不显示已关闭的 Tickets',
        'Show closed Tickets' => '显示已关闭的 Tickets',
        'New Article' => '新文章',
        'Email-Ticket' => '邮件 Ticket',
        'Create new Email Ticket' => '创建新的邮件 Ticket',
        'Phone-Ticket' => '电话 Ticket',
        'Search Tickets' => '搜索 Tickets',
        'Edit Customer Users' => '编辑客户帐户',
        'Edit Customer Company' => '编辑客户单位',
        'Bulk Action' => '批量处理',
        'Bulk Actions on Tickets' => '批量处理 Tickets',
        'Send Email and create a new Ticket' => '发送 Email 并创建一个新的 Ticket',
        'Create new Email Ticket and send this out (Outbound)' => '创建新的 Ticket并发送出去',
        'Create new Phone Ticket (Inbound)' => '创建新的电话Ticket（进来的Ticket）',
        'Overview of all open Tickets' => '所有开放 Tickets 概况',
        'Locked Tickets' => '已锁定 Ticket',
        'Watched Tickets' => '订阅 Tickets',
        'Watched' => '订阅',
        'Subscribe' => '订阅',
        'Unsubscribe' => '退订',
        'Lock it to work on it!' => '锁定并开始工作 !',
        'Unlock to give it back to the queue!' => '解锁并送回队列!',
        'Shows the ticket history!' => '显示 Ticket 历史状况!',
        'Print this ticket!' => '打印 Ticket !',
        'Change the ticket priority!' => '修改 Ticket 优先级',
        'Change the ticket free fields!' => '修改 Ticket 额外信息',
        'Link this ticket to an other objects!' => '链接该 Ticket 到其他对象!',
        'Change the ticket owner!' => '修改 Ticket 所有者!',
        'Change the ticket customer!' => '修改 Ticket 所属客户!',
        'Add a note to this ticket!' => '给 Ticket 增加注解!',
        'Merge this ticket!' => '合并该 Ticket!',
        'Set this ticket to pending!' => '将该 Ticket 转入等待状态',
        'Close this ticket!' => '关闭该 Ticket!',
        'Look into a ticket!' => '查看 Ticket 内容',
        'Delete this ticket!' => '删除该 Ticket!',
        'Mark as Spam!' => '标记为垃圾!',
        'My Queues' => '我的队列',
        'Shown Tickets' => '显示 Tickets',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '您的邮件 "<OTRS_TICKET>" 被合并到 "<OTRS_MERGE_TO_TICKET>" !',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: 第一响应时间已耗时(%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: 第一响应时间将耗时(%s)!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: 更新时间已耗时(%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: 更新时间将耗时(%s)!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: 处理解决已耗时(%s)!',
        'Ticket %s: solution time will be over in %s!' => '处理解决将耗时(%s)!',
        'There are more escalated tickets!' => '有更多升级的tickets',
        'New ticket notification' => '新 Ticket 通知',
        'Send me a notification if there is a new ticket in "My Queues".' => '如果我的队列中有新的 Ticket，请通知我.',
        'Follow up notification' => '跟踪通知',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => '如果客户发送了 Ticket 回复，并且我是该 Ticket 的所有者.',
        'Ticket lock timeout notification' => 'Ticket 锁定超时通知 ',
        'Send me a notification if a ticket is unlocked by the system.' => '如果 Ticket 被系统解锁，请通知我.',
        'Move notification' => '移动通知',
        'Send me a notification if a ticket is moved into one of "My Queues".' => '如果有 Ticket 被转入我的队列，请通知我.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => '您的最常用队列，如果您的邮件设置激活，您将会得到该队列的状态通知.',
        'Custom Queue' => '客户队列',
        'QueueView refresh time' => '队列视图刷新时间',
        'Screen after new ticket' => '创建新 Ticket 后的视图',
        'Select your screen after creating a new ticket.' => '选择您创建新 Ticket 后，所显示的视图.',
        'Closed Tickets' => '关闭 Tickets',
        'Show closed tickets.' => '显示已关闭 Tickets.',
        'Max. shown Tickets a page in QueueView.' => '队列视图每页显示 Ticket 数.',
        'Watch notification' => '关注通知',
        'Send me a notification of an watched ticket like an owner of an ticket.' => '对我所关注的ticket，像该ticket的拥有人一样，给我也发一份通知',
        'Out Of Office' => '不在办公室',
        'Select your out of office time.' => '选择你不在办公室的时间',
        'CompanyTickets' => '公司Tickets',
        'MyTickets' => '我的 Tickets',
        'New Ticket' => '新的 Ticket',
        'Create new Ticket' => '创建新的 Ticket',
        'Customer called' => '客户致电',
        'phone call' => '电话呼叫',
        'Reminder Reached' => '提醒已达',
        'Reminder Tickets' => '提醒的 Ticket',
        'Escalated Tickets' => '升级的Ticket',
        'New Tickets' => '新的Ticket',
        'Open Tickets / Need to be answered' => '打开的Tickets/需要回答',
        'Tickets which need to be answered!' => '需要回答的 Ticket',
        'All new tickets!' => '所有新的tickets',
        'All tickets which are escalated!' => '所有升级的tickets',
        'All tickets where the reminder date has reached!' => '所有已到提醒日期的Ticket',
        'Responses' => '回复',
        'Responses <-> Queue' => '回复 <-> 队列',
        'Auto Responses' => '自动回复功能',
        'Auto Responses <-> Queue' => '自动回复 <-> 队列',
        'Attachments <-> Responses' => '附件 <-> 回复',
        'History::Move' => 'Ticket 移到队列 "%s" (%s) 从队列 "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => '更新服务级别协议 to %s (ID=%s).',
        'History::NewTicket' => 'New ticket [%s] created (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp for [%s]. %s',
        'History::SendAutoReject' => '自动拒绝发送给 "%s".',
        'History::SendAutoReply' => '自动回复发送给 "%s".',
        'History::SendAutoFollowUp' => '自动跟踪发送给 "%s".',
        'History::Forward' => '转发给 "%s".',
        'History::Bounce' => '回退到 "%s".',
        'History::SendAnswer' => '信件发送给 "%s".',
        'History::SendAgentNotification' => '"%s"-Benachrichtigung versand an "%s".',
        'History::SendCustomerNotification' => '通知发送给 "%s".',
        'History::EmailAgent' => '发邮件给客户.',
        'History::EmailCustomer' => 'Add mail. %s',
        'History::PhoneCallAgent' => 'Called customer',
        'History::PhoneCallCustomer' => '客户已打过电话',
        'History::AddNote' => '加注释 (%s)',
        'History::Lock' => 'Ticket 锁定.',
        'History::Unlock' => 'Ticket 解锁.',
        'History::TimeAccounting' => '%s time unit(d) counted. Totaly %s time unit(s) counted.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Refreshed: %s',
        'History::PriorityUpdate' => '优先级被更新，从  "%s" (%s) 到 "%s" (%s).',
        'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop protection! sent no auto answer to "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Refreshed: %s',
        'History::StateUpdate' => 'Before "%s" 新: "%s"',
        'History::TicketFreeTextUpdate' => 'Refreshed: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => '客户进行网上请求.',
        'History::TicketLinkAdd' => 'Link to "%s" established.',
        'History::TicketLinkDelete' => 'Link to "%s" removed.',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => '星期日',
        'Mon' => '星期一',
        'Tue' => '星期二',
        'Wed' => '星期三',
        'Thu' => '星期四',
        'Fri' => '星期五',
        'Sat' => '星期六',

        # Template: AdminAttachmentForm
        'Attachment Management' => '附件管理',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => '自动回复管理',
        'Response' => '回复',
        'Auto Response From' => '自动回复来自',
        'Note' => '注解',
        'Useable options' => '可用宏变量',
        'To get the first 20 character of the subject.' => '显示标题的前20个字节',
        'To get the first 5 lines of the email.' => '显示电邮的前五行',
        'To get the realname of the sender (if given).' => '显示发件人的真实名字',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '当前客户信息的可选项 (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Ticket拥有者的可选项 e. g. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Ticket责任选项 (e. g. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '可选的 ticket 数据 (例如: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',

        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => '管理客人单位',
        'Search for' => '搜索',
        'Add Customer Company' => '增加客人单位',
        'Add a new Customer Company.' => '增加客人到单位里',
        'List' => '列表',
        'This values are required.' => '该条目必须填写.',
        'This values are read only.' => '该数据只读.',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => '进行消息撰写的窗口已经被关闭,退出.',
        'This window must be called from compose window' => '该窗口必须由撰写窗口调用',
        'Customer User Management' => '客户用户管理',
        'Add Customer User' => '增加客人',
        'Source' => '数据源',
        'Create' => '创建',
        'Customer user will be needed to have a customer history and to login via customer panel.' => '客户用户必须有一个账号从客户登录页面登录系统.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => '客户用户 <-> 组 管理',
        'Change %s settings' => '修改 %s 设置',
        'Select the user:group permissions.' => '选择 用户:组 权限.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '如果不选择，则该组没有权限 (该组无法处理 Ticket)',
        'Permission' => '权限',
        'ro' => '只读',
        'Read only access to the ticket in this group/queue.' => '队列中的 Ticket 只读.',
        'rw' => '读写',
        'Full read and write access to the tickets in this group/queue.' => '队列中的 Ticket 读/写.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '客户帐号 <-> 服务管理',
        'CustomerUser' => '客户用户',
        'Service' => '服务',
        'Edit default services.' => '编辑默认服务',
        'Search Result' => '搜索结果',
        'Allocate services to CustomerUser' => '分配服务给客户',
        'Active' => '激活',
        'Allocate CustomerUser to service' => '指派客户到服务',

        # Template: AdminEmail
        'Message sent to' => '消息发送给',
        'A message should have a subject!' => '邮件必须有标题!',
        'Recipients' => '收件人',
        'Body' => '内容',
        'Send' => '发送',

        # Template: AdminGenericAgent
        'GenericAgent' => '计划任务',
        'Job-List' => '工作列表',
        'Last run' => '最后运行',
        'Run Now!' => '现在运行!',
        'x' => 'x',
        'Save Job as?' => '保存工作为?',
        'Is Job Valid?' => '工作是否有效?',
        'Is Job Valid' => '工作有效',
        'Schedule' => '安排',
        'Currently this generic agent job will not run automatically.' => '目前这一通用Agent作业将不会自动运行',
        'To enable automatic execution select at least one value from minutes, hours and days!' => '启用自动执行至少选择一个值分钟，时间和日期',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '文章全文搜索 (例如: "Mar*in" 或者 "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '  例如: 10*5144 或者 105658*',
        '(e. g. 234321)' => '例如: 234321',
        'Customer User Login' => '客户用户登录信息',
        '(e. g. U5150)' => '例如: U5150',
        'SLA' => '服务级别协议(SLA)',
        'Agent' => '技术支持人员',
        'Ticket Lock' => 'Ticket 锁状态',
        'TicketFreeFields' => 'Ticket 自由区域',
        'Create Times' => '创建时间',
        'No create time settings.' => '没有创建时间设置',
        'Ticket created' => '创建时间',
        'Ticket created between' => ' 创建时间在',
        'Close Times' => '关闭时间',
        'No close time settings.' => '没有设定关闭时间.',
        'Ticket closed' => '关闭的 Ticket',
        'Ticket closed between' => 'Ticket 关闭时间在',
        'Pending Times' => '待定时间',
        'No pending time settings.' => '没有设置待定时间',
        'Ticket pending time reached' => '待定时间已到的Ticket',
        'Ticket pending time reached between' => '在待定时间内的Ticket ',
        'Escalation Times' => '升级时间',
        'No escalation time settings.' => '没有升级时间设置',
        'Ticket escalation time reached' => '已到升级时间Ticket',
        'Ticket escalation time reached between' => '在升级时间内的Ticket',
        'Escalation - First Response Time' => '任务调升 - 首次回复的时间',
        'Ticket first response time reached' => '首次回复时间已到的Ticket',
        'Ticket first response time reached between' => '在首次回复时间内的Ticket',
        'Escalation - Update Time' => '任务调升 - 更新的时间',
        'Ticket update time reached' => '更新时间已到的Ticket',
        'Ticket update time reached between' => '在更新时间内的Ticket',
        'Escalation - Solution Time' => '任务调升 - 解决的时间',
        'Ticket solution time reached' => '方案解决时间已到的Ticket',
        'Ticket solution time reached between' => '在方案解决时间内已到的Ticket',
        'New Service' => '新的服务级别',
        'New SLA' => '新的服务级别协议(SLA)',
        'New Priority' => '新优先级',
        'New Queue' => '新队列',
        'New State' => '新状态',
        'New Agent' => '新技术支持人员',
        'New Owner' => '新所有者',
        'New Customer' => '新客户',
        'New Ticket Lock' => '新 Ticket 锁',
        'New Type' => '新的类型',
        'New Title' => '新的标题',
        'New TicketFreeFields' => '新的 Ticket 自由区域',
        'Add Note' => '增加注解',
        'Time units' => '时间单元',
        'CMD' => '命令',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '将执行这个命令, 第一个参数是 Ticket 编号，第二个参数是 Ticket 的标识符.',
        'Delete tickets' => '删除 Tickets',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => '警告! 该 Ticket 将会从数据库删除，无法恢复!',
        'Send Notification' => '发送通知',
        'Param 1' => '参数 1',
        'Param 2' => '参数 2',
        'Param 3' => '参数 3',
        'Param 4' => '参数 4',
        'Param 5' => '参数 5',
        'Param 6' => '参数 6',
        'Send agent/customer notifications on changes' => '发送代理/客户通知变更',
        'Save' => '保存',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets 受到影响! 您确定要使用这个计划任务?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => '警告：当您更改\'管理\'组的名称时，在SysConfig作出相应的变化之前，你将被管理面板锁住！如果发生这种情况，请用SQL语句把组名改回到\'admin\'',
        'Group Management' => '组管理',
        'Add Group' => '增加新的组',
        'Add a new Group.' => '增加一个新组',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin 组可以进入系统管理区域, Stats 组可以进入统计管理区',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => '创建新的组来控制不同的存取权限',
        'It\'s useful for ASP solutions.' => '这是一个有效的应用服务提供商(ASP)解决方案.',

        # Template: AdminLog
        'System Log' => '系统日志',
        'Time' => '时间',

        # Template: AdminMailAccount
        'Mail Account Management' => '邮件帐号管理',
        'Host' => '主机',
        'Trusted' => '是否信任',
        'Dispatching' => '分派',
        'All incoming emails with one account will be dispatched in the selected queue!' => '所有来自一个邮件账号的邮件将会被分发到所选队列!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '如果您的帐户是值得信赖的，现有的X-OTRS标题到达时间（优先， ... ）将被使用！邮政过滤器将被使用',

        # Template: AdminNavigationBar
        'Users' => '用户',
        'Groups' => '组',
        'Misc' => '综合',

        # Template: AdminNotificationEventForm
        'Notification Management' => '通知管理',
        'Add Notification' => '增加通知',
        'Add a new Notification.' => '新增一个通知.',
        'Name is required!' => '需要名称!',
        'Event is required!' => '需要事件',
        'A message should have a body!' => '邮件必须包含内容!',
        'Recipient' => '收件人',
        'Group based' => '基于组的',
        'Agent based' => '基于技术支持代表的',
        'Email based' => '基于电邮的',
        'Article Type' => 'Article类别 ',
        'Only for ArticleCreate Event.' => '仅适用于 ArticleCreate 事件',
        'Subject match' => '标题匹配',
        'Body match' => '内容匹配',
        'Notifications are sent to an agent or a customer.' => '通知被发送到技术支持人员或者客户.',
        'To get the first 20 character of the subject (of the latest agent article).' => '截取服务人员新邮件主题的前 20 个字符.',
        'To get the first 5 lines of the body (of the latest agent article).' => '截取服务人员新邮件正文内容前 5 行.',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => '取得信件的属性 (例如: <OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => '截取客户最新邮件主题的前 20 个字符.',
        'To get the first 5 lines of the body (of the latest customer article).' => '截取客人最新邮件正文内容前 5 行.',

        # Template: AdminNotificationForm
        'Notification' => '系统通知',

        # Template: AdminPackageManager
        'Package Manager' => '软件包管理',
        'Uninstall' => '卸载',
        'Version' => '版本',
        'Do you really want to uninstall this package?' => '是否确认卸载该软件包?',
        'Reinstall' => '重新安装',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '您是否准备好重新安装这些软件包 (所有手工设置将会不见)?',
        'Continue' => '继续',
        'Install' => '安装',
        'Package' => '软件包',
        'Online Repository' => '在线知识库',
        'Vendor' => '提供者',
        'Module documentation' => '模块文档',
        'Upgrade' => '升级',
        'Local Repository' => '本地知识库',
        'Status' => '状态',
        'Overview' => '概况',
        'Download' => '下载',
        'Rebuild' => '重新构建',
        'ChangeLog' => '改变记录',
        'Date' => '日期',
        'Filelist' => '文件清单',
        'Download file from package!' => '从软件包中下载这个文件',
        'Required' => '必需的',
        'PrimaryKey' => '关键的Key',
        'AutoIncrement' => '自动递增',
        'SQL' => 'SQL',
        'Diff' => '比较',

        # Template: AdminPerformanceLog
        'Performance Log' => '系统监视器',
        'This feature is enabled!' => '该功能已启用',
        'Just use this feature if you want to log each request.' => '如果您想详细记录每个请求, 您可以使用该功能.',
        'Activating this feature might affect your system performance!' => '启动该功能可能影响您的系统性能',
        'Disable it here!' => '关闭该功能',
        'This feature is disabled!' => '该功能已关闭',
        'Enable it here!' => '打开该功能',
        'Logfile too large!' => '日志文件过大',
        'Logfile too large, you need to reset it!' => '日志文件过大, 你需要重置它',
        'Range' => '范围',
        'Interface' => '界面',
        'Requests' => '请求',
        'Min Response' => '最小回应',
        'Max Response' => '最大回应',
        'Average Response' => '平均回应',
        'Period' => '周期',
        'Min' => '最小',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP 管理',
        'Result' => '结果',
        'Identifier' => '标识符',
        'Bit' => '位',
        'Key' => '密匙',
        'Fingerprint' => '指印',
        'Expires' => '过期',
        'In this way you can directly edit the keyring configured in SysConfig.' => '这种方式，您可以直接编辑在SysConfig设置的键',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '邮件过滤管理',
        'Filtername' => '过滤器名称',
        'Stop after match' => '',
        'Match' => '匹配',
        'Value' => '值',
        'Set' => '设置',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '如果您想根据 X-Headers 内容来过滤，可以使用正规则表达式.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '如果您想仅匹配email 地址， 请使用EMAILADDRESS:info@example.com in From, To or Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '如果您用RegExp，您也能使用匹配值in () as [***] in \'Set\'',

        # Template: AdminPriority
        'Priority Management' => '优先权管理',
        'Add Priority' => '添加优先权',
        'Add a new Priority.' => '增加一个新的优先权',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => '队列 <-> 自动回复管理',
        'settings' => '设置',

        # Template: AdminQueueForm
        'Queue Management' => '队列管理',
        'Sub-Queue of' => '子队列',
        'Unlock timeout' => '自动解锁超时期限',
        '0 = no unlock' => '0 = 不自动解锁  ',
        'Only business hours are counted.' => '仅以上班时间计算',
        '0 = no escalation' => '0 = 无限时  ',
        'Notify by' => '进度通知',
        'Follow up Option' => '跟进选项',
        'Ticket lock after a follow up' => '跟进确认以后，Ticket 将被自动上锁',
        'Systemaddress' => '系统邮件地址',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '如果技术支持人员锁定了 Ticket,但是在一定的时间内没有回复，该 Ticket 将会被自动解锁，而对所有的技术支持人员可视.',
        'Escalation time' => '限时答复时间',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => '该队列只显示规定时间内没有被处理的 Ticket',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '如果 Ticket 已经处于关闭状态，而客户就发送了一个跟进 Ticket，那么这个 Ticket 将会被直接加锁，而所有者被定义为原来所有者',
        'Will be the sender address of this queue for email answers.' => '回复邮件所用的发送者地址',
        'The salutation for email answers.' => '回复邮件所用称谓.',
        'The signature for email answers.' => '回复邮件所用签名.',
        'Customer Move Notify' => 'Ticket 移动客户通知',
        'OTRS sends an notification email to the customer if the ticket is moved.' => '如果 Ticket 被移动，系统将会发送一个通知邮件给客户',
        'Customer State Notify' => 'Ticket 状态客户通知',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => '如果 Ticket 状态改变，系统将会发送通知邮件给客户',
        'Customer Owner Notify' => '客户所有者通告',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => '如果 Ticket 所有者改变，系统将会发送通知邮件给客户.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => '回复 <-> 队列管理',

        # Template: AdminQueueResponsesForm
        'Answer' => '回复',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => '回复 <-> 附件管理',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => '回复内容管理',
        'A response is default text to write faster answer (with default text) to customers.' => '为了快速回复，回复内容定义了每个回复中重复的内容.',
        'Don\'t forget to add a new response a queue!' => '不要忘记增加一个新的回复内容到队列!',
        'The current ticket state is' => '当前 Ticket 状态是',
        'Your email address is new' => '您的邮件地址是新的',

        # Template: AdminRoleForm
        'Role Management' => '角色管理',
        'Add Role' => '增加角色',
        'Add a new Role.' => '新增一个角色',
        'Create a role and put groups in it. Then add the role to the users.' => '创建一个角色并将组加入角色,然后将角色赋给用户.',
        'It\'s useful for a lot of users and groups.' => '当有大量的用户和组的时候，角色非常适合.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => '角色 <-> 组管理',
        'move_into' => '移动到',
        'Permissions to move tickets into this group/queue.' => '允许移动 Tickets 到该组/队列.',
        'create' => '创建',
        'Permissions to create tickets in this group/queue.' => '在该组/队列中创建 Tickets 的权限.',
        'owner' => '所有者',
        'Permissions to change the ticket owner in this group/queue.' => '在该组/队列中修改 Tickets 所有者的权限.',
        'priority' => '优先级',
        'Permissions to change the ticket priority in this group/queue.' => '在该组/队列中修改 Tickets 优先级的权限.',

        # Template: AdminRoleGroupForm
        'Role' => '角色',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => '角色 <-> 用户管理',
        'Select the role:user relations.' => '选择 角色:用户 关联.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => '称呼语管理',
        'Add Salutation' => '增加称呼语',
        'Add a new Salutation.' => '增加一个新的称呼语',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => '安全模式需要启动',
        'Secure mode will (normally) be set after the initial installation is completed.' => '在初始安装结束后，安全模式通常将被设置',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => '为了重新用Web 界面安装，安全模式必须disabled',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => '如果启动模式没有被启动，请通过系统设置启动它因为您的OTRS程序已经运行',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL查询窗口',
        'CSV' => '',
        'HTML' => '',
        'Select Box Result' => '查询结果',

        # Template: AdminService
        'Service Management' => '服务管理',
        'Add Service' => '增加服务',
        'Add a new Service.' => '新增一个服务',
        'Sub-Service of' => '子服务隶属于',

        # Template: AdminSession
        'Session Management' => '会话管理',
        'Sessions' => '会话',
        'Uniq' => '单一',
        'Kill all sessions' => '终止所有会话',
        'Session' => '会话',
        'Content' => '内容',
        'kill session' => '终止会话',

        # Template: AdminSignatureForm
        'Signature Management' => '签名管理',
        'Add Signature' => '增加签名',
        'Add a new Signature.' => '新增一个签名',

        # Template: AdminSLA
        'SLA Management' => '服务级别协议(SLA)管理',
        'Add SLA' => '增加服务级别协议(SLA)',
        'Add a new SLA.' => '新增一个服务级别协议(SLA).',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME 管理',
        'Add Certificate' => '添加证书',
        'Add Private Key' => '添加私匙',
        'Secret' => '密码',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => '用这种方式您可以直接编辑证书和私匙',

        # Template: AdminStateForm
        'State Management' => '状态管理',
        'Add State' => '增加状态',
        'Add a new State.' => '增加一个新的状态',
        'State Type' => '状态类型',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => '您同时更新了 Kernel/Config.pm 中的缺省状态!',
        'See also' => '参见',

        # Template: AdminSysConfig
        'SysConfig' => '系统配置',
        'Group selection' => '选择组',
        'Show' => '显示',
        'Download Settings' => '下载设置',
        'Download all system config changes.' => '下载所有的系统配置变化.',
        'Load Settings' => '加载设置',
        'Subgroup' => '子组',
        'Elements' => '元素',

        # Template: AdminSysConfigEdit
        'Config Options' => '配置选项',
        'Default' => '缺省',
        'New' => '新',
        'New Group' => '新组',
        'Group Ro' => '只读权限的组',
        'New Group Ro' => '新的只读权限的组',
        'NavBarName' => '导航栏名称',
        'NavBar' => '导航栏',
        'Image' => '图片',
        'Prio' => '优先级',
        'Block' => '块',
        'AccessKey' => '进钥',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => '系统邮件地址管理',
        'Add System Address' => '增加系统邮件地址',
        'Add a new System Address.' => '增加一个新的系统邮件地址.',
        'Realname' => '真实姓名',
        'All email addresses get excluded on replaying on composing an email.' => '',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => '所有发送到该收件人的消息将被转到所选择的队列',

        # Template: AdminTypeForm
        'Type Management' => '类型管理',
        'Add Type' => '增加类型',
        'Add a new Type.' => '增加一个新的类型',

        # Template: AdminUserForm
        'User Management' => '人员管理',
        'Add User' => '增加人员',
        'Add a new Agent.' => '增加一个新的人员',
        'Login as' => '登录名',
        'Firstname' => '名',
        'Lastname' => '姓',
        'Start' => '开始',
        'End' => '结束',
        'User will be needed to handle tickets.' => '需要用户来处理 Tickets.',
        'Don\'t forget to add a new user to groups and/or roles!' => '不要忘记增加一个用户到组和角色!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => '用户 <-> 组管理',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => '地址簿',
        'Return to the compose screen' => '回到撰写页面',
        'Discard all changes and return to the compose screen' => '放弃所有修改,回到撰写页面',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => '',

        # Template: AgentDashboardCalendarOverview
        'in' => '',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '',
        'Please update now.' => '请更新',
        'Release Note' => '版本发布注释',
        'Level' => '级别',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '',

        # Template: AgentDashboardTicketGeneric

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline

        # Template: AgentInfo
        'Info' => '详情',

        # Template: AgentLinkObject
        'Link Object: %s' => '连接对象: %s',
        'Object' => '对象',
        'Link Object' => '链接对象',
        'with' => '和',
        'Select' => '选择',
        'Unlink Object: %s' => '未连接对象 %s',

        # Template: AgentLookup
        'Lookup' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => '拼写检查',
        'spelling error(s)' => '拼写错误',
        'or' => '或者',
        'Apply these changes' => '应用这些改变',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => '您是否确认删除该对象?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '选择限制参数，使统计特征化',
        'Fixed' => '修正',
        'Please select only one element or turn off the button \'Fixed\'.' => '请只选择一个元素或关闭被选域的\'Fixed\'按钮',
        'Absolut Period' => '绝对周期',
        'Between' => '',
        'Relative Period' => '相对周期',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '您可以为您的统计制定限制参数',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '如果您删除钩在“固定”复选框，生成该统计的技术支持代表可以改变相应要素的属性',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '插入共同规范',
        'Permissions' => '可许',
        'Format' => '格式',
        'Graphsize' => '图形化',
        'Sum rows' => '总和行',
        'Sum columns' => '总和列',
        'Cache' => '缓存',
        'Required Field' => '必填字段',
        'Selection needed' => '选择需要',
        'Explanation' => '解释',
        'In this form you can select the basic specifications.' => '以这种形式，您可以选择基本规范',
        'Attribute' => '属性',
        'Title of the stat.' => '统计的标题',
        'Here you can insert a description of the stat.' => '您可以插入统计的描述',
        'Dynamic-Object' => '动态对象',
        'Here you can select the dynamic object you want to use.' => '您可以选择您需要使用的动态对象',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '注：这取决于您的安装多少动态对象可以使用',
        'Static-File' => '静态文件',
        'For very complex stats it is possible to include a hardcoded file.' => '对于非常复杂的统计有可能包括一个硬编码文件',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => '如果一个新的硬编码文件存在，可此属性将显示，您可以选择其中一个',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '权限设置。您可以选择一个或多个团体，不同的技术支持代表都可看见该配置的统计',
        'Multiple selection of the output format.' => '输出格式的多种选择',
        'If you use a graph as output format you have to select at least one graph size.' => '如果您使用的是图形的输出格式你必须至少选择一个图形的大小',
        'If you need the sum of every row select yes' => '如需要每行的总和选择 yes’',
        'If you need the sum of every column select yes.' => '如需要每列的总和选择’yes’',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => '大多数的统计资料可以缓存,这将加快这一统计的展示.',
        '(Note: Useful for big databases and low performance server)' => '注：适用于大型数据库和低性能的服务器',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '用无效的统计不可生成统计',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '这是非常有用的，如果你不想让人得到统计的结果或统计结果并不完整',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => '选择价值系列的要素',
        'Scale' => '尺度',
        'minimal' => '最小化',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '请记住，这比额表的价值系列要大于X轴的尺度（如X -轴=>本月， ValueSeries =>年） ',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '在这里，您可以定义一系列的值。你有可能选择一个或两个元素。然后您可以选择元素的属性。每个属性将显示为单一的值。如果您不选择任何属性, 那么当您生成一个统计的时候所有元素的属性将被使用。并且一个新的属性被更新到上次配置中',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '选择将用在x轴的元素',
        'maximal period' => '最大周期',
        'minimal scale' => '最小尺度',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '在这里，您可以定义x轴。您可以选择的一个因素通过单选按钮。如果你没有选择，所有元素的属性将被使用当您生成一个统计的时候。并且一个新的属性被更新到上次配置中',

        # Template: AgentStatsImport
        'Import' => '导入',
        'File is not a Stats config' => '文件不是一个统计配置',
        'No File selected' => '没有文件被选中',

        # Template: AgentStatsOverview
        'Results' => '结果',
        'Total hits' => '点击数',
        'Page' => '页',

        # Template: AgentStatsPrint
        'Print' => '打印',
        'No Element selected.' => '没有元素被选中',

        # Template: AgentStatsView
        'Export Config' => '导出配置',
        'Information about the Stat' => '关于统计的信息',
        'Exchange Axis' => '转换轴',
        'Configurable params of static stat' => '静态统计的配置参数',
        'No element selected.' => '没有被选参数',
        'maximal period from' => '最大周期表',
        'to' => '至',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '通过输入和选择字段，您可以按您的需求来配置统计。您可以修改编辑那些统计要素由您的统计资料管理员来设置。',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => '邮件必须有收件人!',
        'You need a email address (e. g. customer@example.com) in To:!' => '收件人信息必须是邮件地址(例如：customer@example.com)',
        'Bounce ticket' => '回退 Ticket ',
        'Ticket locked!' => 'Ticket 被锁定!',
        'Ticket unlock!' => '解锁 Ticket!',
        'Bounce to' => '回退到 ',
        'Next ticket state' => 'Tickets 状态',
        'Inform sender' => '通知发送者',
        'Send mail!' => '发送!',

        # Template: AgentTicketBulk
        'You need to account time!' => '您需要记录时间',
        'Ticket Bulk Action' => 'Ticket 批量处理',
        'Spell Check' => '拼写检查',
        'Note type' => '注释类型',
        'Next state' => 'Ticket 状态',
        'Pending date' => '待处理日期',
        'Merge to' => '合并到',
        'Merge to oldest' => '合并到最老的',
        'Link together' => '合并在一起',
        'Link to Parent' => '合并到上一级',
        'Unlock Tickets' => '解锁 Tickets',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Ticket 的类型是必须的!',
        'A required field is:' => '必须的字段是',
        'Close ticket' => '关闭 Ticket',
        'Previous Owner' => '前一个所有者',
        'Inform Agent' => '通知技术支持人员',
        'Optional' => '选项',
        'Inform involved Agents' => '通知相关技术支持人员',
        'Attach' => '附件',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => '消息必须经过拼写检查!',
        'Compose answer for ticket' => '撰写答复,Ticket 编号',
        'Pending Date' => '进入等待状态日期',
        'for pending* states' => '针对等待状态',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => '修改 Tickets 所属客户',
        'Set customer user and customer id of a ticket' => '设置 Ticket 所属客户用户',
        'Customer User' => '客户用户',
        'Search Customer' => '搜索客户',
        'Customer Data' => '客户数据',
        'Customer history' => '客户历史情况',
        'All customer tickets.' => '该客户所有 Tickets 记录.',

        # Template: AgentTicketEmail
        'Compose Email' => '撰写 Email',
        'new ticket' => '新建 Ticket',
        'Refresh' => '刷新',
        'Clear To' => '清空',
        'All Agents' => '所有技术支持人员',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => '文章类型',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => '修改 Ticket 额外信息',

        # Template: AgentTicketHistory
        'History of' => '历史',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => '您需要使用一个 Ticket 编号!',
        'Ticket Merge' => 'Ticket 合并',

        # Template: AgentTicketMove
        'Move Ticket' => '移动 Ticket',

        # Template: AgentTicketNote
        'Add note to ticket' => '增加注解到 Ticket',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => '首次报告时间',
        'Service Time' => '服务时间',
        'Update Time' => '更新时间',
        'Solution Time' => '解决时间',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => '您至少需要选择一个 Ticket!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => '过滤器',
        'Change search options' => '修改搜索选项',
        'Tickets' => '',
        'of' => '',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => '撰写答复',
        'Contact customer' => '联系客户',
        'Change queue' => '改变队列',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => '正序排序',
        'up' => '上',
        'sort downward' => '逆序排序',
        'down' => '下',
        'Escalation in' => '限时',
        'Locked' => '锁定状态',

        # Template: AgentTicketOwner
        'Change owner of ticket' => '修改 Ticket 所有者',

        # Template: AgentTicketPending
        'Set Pending' => '设置待处理状态',

        # Template: AgentTicketPhone
        'Phone call' => '电话',
        'Clear From' => '重置',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => '纯文本',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket信息',
        'Accounted time' => '所用时间',
        'Linked-Object' => '已链接对象',
        'by' => '由',

        # Template: AgentTicketPriority
        'Change priority of ticket' => '调整 Ticket 优先级',

        # Template: AgentTicketQueue
        'Tickets shown' => '显示 Ticket',
        'Tickets available' => '可用 Ticket',
        'All tickets' => '所有Ticket',
        'Queues' => '队列',
        'Ticket escalation!' => 'Ticket 限时处理!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => '更改 Ticket 的负责人',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Ticket 搜索',
        'Profile' => '搜索约束条件',
        'Search-Template' => '搜索模板',
        'TicketFreeText' => 'Ticket 额外信息',
        'Created in Queue' => '在队列里建立',
        'Article Create Times' => '',
        'Article created' => '',
        'Article created between' => '',
        'Change Times' => '改变时间',
        'No change time settings.' => '不改变时间设置',
        'Ticket changed' => '',
        'Ticket changed between' => '',
        'Result Form' => '搜索结果显示为',
        'Save Search-Profile as Template?' => '将搜索条件保存为模板',
        'Yes, save it with name' => '是, 保存为名称',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => '全文',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => '展开',
        'Collapse View' => '折叠',
        'Split' => '分解',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Article 过滤设置',
        'Save filter settings as default' => '保存过滤设置为缺省值',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '追溯',

        # Template: CustomerFooter
        'Powered by' => '驱动方',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => '登录',
        'Lost your password?' => '忘记密码?',
        'Request new password' => '设置新密码',
        'Create Account' => '创建帐户',

        # Template: CustomerNavigationBar
        'Welcome %s' => '欢迎 %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => '时间',
        'No time settings.' => '无时间约束.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => '点击这里报告一个 Bug!',

        # Template: Footer
        'Top of Page' => '页面顶端',

        # Template: FooterSmall

        # Template: Header
        'Home' => '首页',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'WEB 安装向导',
        'Welcome to %s' => '欢迎使用 %s',
        'Accept license' => '同意许可',
        'Don\'t accept license' => '不同意',
        'Admin-User' => '管理员',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '如果您的数据库有设置 root 密码, 请在这里输入, 否则, 请保留空白. 出于安全考虑, 我们建议您为 root 设置一个密码, 更多信息请参考数据库帮助文档.',
        'Admin-Password' => '管理员密码',
        'Database-User' => '数据库用户名称',
        'default \'hot\'' => '默认密码 \'hot\'',
        'DB connect host' => '数据连接主机',
        'Database' => '数据库',
        'Default Charset' => '缺省字符集',
        'utf8' => 'UTF-8',
        'false' => '假',
        'SystemID' => '系统ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(系统标识符. Ticket 编号和 http 会话都以这个标识符开头)',
        'System FQDN' => '系统域名',
        '(Full qualified domain name of your system)' => '(系统域名)',
        'AdminEmail' => '管理员地址',
        '(Email of the system admin)' => '(系统管理员邮件地址)',
        'Organization' => '组织',
        'Log' => '日志',
        'LogModule' => '日志模块',
        '(Used log backend)' => '使用日志后端',
        'Logfile' => '日志文件',
        '(Logfile just needed for File-LogModule!)' => '(只有激活 File-LogModule 时才需要 Logfile!)',
        'Webfrontend' => 'Web 前端',
        'Use utf-8 it your database supports it!' => '如果您的数据库支持，使用UTF-8字符编码!',
        'Default Language' => '缺省语言',
        '(Used default language)' => '(使用缺省语言)',
        'CheckMXRecord' => '检查 MX 记录',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '通过撰写答案来检查用过的电子邮件地址的MX记录。您OTRS机器在拨号接入的低速网络里，请不要使用CheckMXRecord!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '为了能够使用OTRS, 您必须以root身份输入以下行在命令行中(Terminal/Shell).',
        'Restart your webserver' => '请重新启动您的 webserver.',
        'After doing so your OTRS is up and running.' => '完成后，您可以启动 OTRS 系统了.',
        'Start page' => '开始页面',
        'Your OTRS Team' => '您的 OTRS 小组.',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => '无权限',

        # Template: Notify
        'Important' => '重要',

        # Template: PrintFooter
        'URL' => '网址',

        # Template: PrintHeader
        'printed by' => '打印于',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: Test
        'OTRS Test Page' => 'OTRS 测试页',
        'Counter' => '计数器',

        # Template: Warning

        # Misc
        'Edit Article' => '编辑信件',
        'Create Database' => '创建数据库',
        'DB Host' => '数据库主机',
        'Ticket Number Generator' => 'Ticket 编号生成器',
        'Create new Phone Ticket' => '创建新的电话 Ticket',
        'Symptom' => '症状',
        'U' => '升序',
        'Site' => '站点',
        'Customer history search (e. g. "ID342425").' => '搜索客户历史 (例如： "ID342425").',
        'Can not delete link with %s!' => '不能删除 %s 的连接',
        'for agent firstname' => '技术支持人员 名',
        'Close!' => '关闭!',
        'No means, send agent and customer notifications on changes.' => '当有改变时不发送通知给技术人员或客户.',
        'A web calendar' => 'Web 日历',
        'to get the realname of the sender (if given)' => '邮件发送人的真实姓名 (如果存在)',
        'OTRS DB Name' => '数据库名称',
        'Notification (Customer)' => '通知(客户)',
        'Select Source (for add)' => '选择数据源(增加功能使用)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '可选的 ticket 数据 (例如: &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => '子对象',
        'Days' => '天',
        'Queue ID' => '队列编号',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => '配置选项 (例如:<OTRS_CONFIG_HttpType>)',
        'System History' => '系统历史',
        'customer realname' => '客户真实姓名',
        'Pending messages' => '消息转入等待状态',
        'for agent login' => '技术支持人员 登录名',
        'Keyword' => '关键字',
        'Close type' => '关闭类型',
        'DB Admin User' => '数据库管理员用户名',
        'for agent user id' => '技术支持人员 用户名',
        'Change user <-> group settings' => '修改 用户 <-> 组 设置',
        'Problem' => '问题',
        'Escalation' => '调整',
        '"}' => '',
        'Order' => '次序',
        'next step' => '下一步',
        'Follow up' => '跟进',
        'Customer history search' => '客户历史搜索',
        'PostMaster Mail Account' => '邮件帐号管理',
        'Stat#' => '统计号',
        'Create new database' => '创建新的数据库',
        'Go' => '执行',
        'Keywords' => '关键字',
        'Ticket Escalation View' => '调整查看 Ticket',
        'Today' => '今天',
        'No * possible!' => '不可使用通配符 "*" !',
        'Load' => '加载',
        'PostMaster Filter' => '邮件内容过滤',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '选择当前用户谁需要这个动作 (例如: &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => '给所有者的消息',
        'to get the first 5 lines of the email' => '邮件正文前5行',
        'Sort by' => '排序',
        'OTRS DB Password' => 'OTRS 用户密码',
        'Last update' => '最后更新于',
        'Tomorrow' => '明天',
        'not rated' => '不予评级',
        'to get the first 20 character of the subject' => '邮件标题前20个字符',
        'Select the customeruser:service relations.' => '选择客户和服务关系.',
        'DB Admin Password' => '数据系统管理员密码',
        'Drop Database' => '删除数据库',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '在这里，您可以定义x轴。您可以选择的一个因素通过单选按钮。然后，你必须选择该元素两个或两个以上的属性。如果您不选择任何属性, 那么当您生成一个统计的时候所有元素的属性将被使用。并且一个新的属性被更新到上次配置中',
        'FileManager' => '文件管理器',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => '当前客户用户信息 (例如: <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => '待处理类型',
        'Comment (internal)' => '注释 (内部)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '可用的 Ticket 归属人信息 (例如: &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '可用的有关 Ticket 信息 (例如: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(使用 Ticket 编号格式)',
        'Reminder' => '提醒',
        'OTRS DB connect host' => 'OTRS 数据库主机',
        'All Agent variables.' => '所有的技术人员变量',
        ' (work units)' => '工作单元',
        'Next Week' => '下周',
        'All Customer variables like defined in config option CustomerUser.' => '所有客户变量可以在配置选项CustomerUser中定义',
        'for agent lastname' => '技术支持人员 名',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => '动作请求者信息 (例如: <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => '消息提醒',
        'Parent-Object' => '父对象',
        'Of couse this feature will take some system performance it self!' => '当然, 该功能会占用一定的系统资源, 加重系统的负担!',
        'Your own Ticket' => '您自己的 Ticket',
        'Detail' => '细节',
        'TicketZoom' => 'Ticket 展开',
        'Open Tickets' => '开放 Tickets',
        'Don\'t forget to add a new user to groups!' => '不要忘记增加新的用户到组!',
        'General Catalog' => '总目录',
        'CreateTicket' => '创建 Ticket',
        'You have to select two or more attributes from the select field!' => '你必须从所选字段中选择两个或两个以上的属性',
        'System Settings' => '数据库设置 ',
        'Finished' => '完成',
        'D' => '降序',
        'All messages' => '所有消息',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '可选的 ticket 数据 (例如: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => '对象已连接到 %s.',
        'A article should have a title!' => '文章必须有标题!',
        'Customer Users <-> Services' => '客户帐号 <-> 服务管理',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '配置选项 (例如: &lt;OTRS_CONFIG_HttpType&gt;)',
        'All email addresses get excluded on replaying on composing and email.' => '所有被取消撰写邮件功能的邮件地址',
        'A web mail client' => 'WebMail 客户端',
        'Compose Follow up' => '撰写跟踪答复',
        'WebMail' => 'WebMail',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Ticket 所有者选项 (例如: <OTRS_OWNER_UserFirstname>)',
        'DB Type' => '数据库类型',
        'kill all sessions' => '中止所有会话',
        'to get the from line of the email' => '邮件来自',
        'Solution' => '解决方案',
        'QueueView' => '队列视图',
        'My Queue' => '我的队列',
        'Select Box' => '选择方框',
        'New messages' => '新消息',
        'Can not create link with %s!' => '不能为 %s 创建连接',
        'Linked as' => '已连接为',
        'modified' => '修改于',
        'Delete old database' => '删除旧数据库',
        'A web file manager' => 'Web 文件管理器',
        'Have a lot of fun!' => 'Have a lot of fun!',
        'send' => '发送',
        'QuickSearch' => '快速搜索',
        'Send no notifications' => '不发送通知',
        'Note Text' => '注解',
        'POP3 Account Management' => 'POP3 帐户管理',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => '系统状态管理',
        'OTRS DB User' => 'OTRS 数据库用户名',
        'Mailbox' => '邮箱',
        'PhoneView' => '电话视图',
        'maximal period form' => '最大周期表',
        'Escaladed Tickets' => '',
        'Yes means, send no agent and customer notifications on changes.' => '当有改变时不发送通知给技术人员或客户.',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => '您的邮件 编号: "<OTRS_TICKET>" 回退到 "<OTRS_BOUNCE_TO>" . 请联系以下地址获取详细信息.',
        'Ticket Status View' => 'Ticket 状态视图',
        'Modified' => '修改于',
        'Ticket selected for bulk action!' => '被选中进行批量操作的 Tickets',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
