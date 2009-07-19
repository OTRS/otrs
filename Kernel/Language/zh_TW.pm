# --
# Kernel/Language/zh_TW.pm - provides Chinese Traditional language translation
# --
# Copyright (C) 2009 Bin Du <bindu2008 at gmail.com>
# Copyright (C) 2009 Yiye Huang <yiyehuang at gmail.com>
# Copyright (C) 2009 Qingjiu Jia <jiaqj at yahoo.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_TW;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sun Jul 19 12:24:09 2009

    # possible charsets
    $Self->{Charset} = ['GBK', 'Big5', ];
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
        'no' => '未設置',
        'Off' => '關',
        'off' => '關',
        'On' => '開',
        'on' => '開',
        'top' => '頂端',
        'end' => '底部',
        'Done' => '確認',
        'Cancel' => '取消',
        'Reset' => '重置',
        'last' => '最后',
        'before' => '早於',
        'day' => '天',
        'days' => '天',
        'day(s)' => '天',
        'hour' => '小時',
        'hours' => '小時',
        'hour(s)' => '小時',
        'minute' => '分鐘',
        'minutes' => '分鐘',
        'minute(s)' => '分鐘',
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
        'wrote' => '寫道',
        'Message' => '消息',
        'Error' => '錯誤',
        'Bug Report' => 'Bug 報告',
        'Attention' => '注意',
        'Warning' => '警告',
        'Module' => '模塊',
        'Modulefile' => '模塊文件',
        'Subfunction' => '子功能',
        'Line' => '行',
        'Setting' => '設置',
        'Settings' => '設置',
        'Example' => '示例',
        'Examples' => '示例',
        'valid' => '有效',
        'invalid' => '無效',
        '* invalid' => '* 無效',
        'invalid-temporarily' => '暫時無效',
        ' 2 minutes' => ' 2 分鐘',
        ' 5 minutes' => ' 5 分鐘',
        ' 7 minutes' => ' 7 分鐘',
        '10 minutes' => '10 分鐘',
        '15 minutes' => '15 分鐘',
        'Mr.' => '先生',
        'Mrs.' => '夫人',
        'Next' => '下一個',
        'Back' => '后退',
        'Next...' => '下一個...',
        '...Back' => '...后退',
        '-none-' => '-無-',
        'none' => '無',
        'none!' => '無!',
        'none - answered' => '無 - 已答復的',
        'please do not edit!' => '不要編輯!',
        'AddLink' => '增加鏈接',
        'Link' => '鏈接',
        'Unlink' => '未鏈接',
        'Linked' => '已鏈接',
        'Link (Normal)' => '鏈接 (正常)',
        'Link (Parent)' => '鏈接 (父)',
        'Link (Child)' => '鏈接 (子)',
        'Normal' => '正常',
        'Parent' => '父',
        'Child' => '子',
        'Hit' => '點擊',
        'Hits' => '點擊數',
        'Text' => '正文',
        'Standard' => '',
        'Lite' => '簡潔',
        'User' => '用戶',
        'Username' => '用戶名稱',
        'Language' => '語言',
        'Languages' => '語言',
        'Password' => '密碼',
        'Salutation' => '稱謂',
        'Signature' => '簽名',
        'Customer' => '客戶',
        'CustomerID' => '客戶編號',
        'CustomerIDs' => '客戶編號',
        'customer' => '客戶',
        'agent' => '技術支持人員',
        'system' => '系統',
        'Customer Info' => '客戶信息',
        'Customer Company' => '客戶單位',
        'Company' => '單位',
        'go!' => '開始!',
        'go' => '開始',
        'All' => '全部',
        'all' => '全部',
        'Sorry' => '對不起',
        'update!' => '更新!',
        'update' => '更新',
        'Update' => '更新',
        'Updated!' => '',
        'submit!' => '提交!',
        'submit' => '提交',
        'Submit' => '提交',
        'change!' => '修改!',
        'Change' => '修改',
        'change' => '修改',
        'click here' => '點擊這裡',
        'Comment' => '注釋',
        'Valid' => '有效',
        'Invalid Option!' => '無效選項!',
        'Invalid time!' => '無效時間!',
        'Invalid date!' => '無效日期!',
        'Name' => '名稱',
        'Group' => '組名',
        'Description' => '描述',
        'description' => '描述',
        'Theme' => '主題',
        'Created' => '創建',
        'Created by' => '創建由',
        'Changed' => '已修改',
        'Changed by' => '修改由',
        'Search' => '搜索',
        'and' => '和',
        'between' => '在',
        'Fulltext Search' => '全文搜索',
        'Data' => '日期',
        'Options' => '選項',
        'Title' => '標題',
        'Item' => '條目',
        'Delete' => '刪除',
        'Edit' => '編輯',
        'View' => '查看',
        'Number' => '編號',
        'System' => '系統',
        'Contact' => '聯系人',
        'Contacts' => '聯系人',
        'Export' => '導出',
        'Up' => '上',
        'Down' => '下',
        'Add' => '增加',
        'Added!' => '',
        'Category' => '目錄',
        'Viewer' => '查看器',
        'Expand' => '擴展',
        'New message' => '新消息',
        'New message!' => '新消息!',
        'Please answer this ticket(s) to get back to the normal queue view!' => '請先回復該 Ticket，然后回到正常隊列視圖!',
        'You got new message!' => '您有新消息!',
        'You have %s new message(s)!' => '您有 %s 條新消息!',
        'You have %s reminder ticket(s)!' => '您有 %s 個提醒!',
        'The recommended charset for your language is %s!' => '建議您所用語言的字符集 %s!',
        'Passwords doesn\'t match! Please try it again!' => '密碼不符，請重試!',
        'Password is already in use! Please use an other password!' => '該密碼被使用，請使用其他密碼!',
        'Password is already used! Please use an other password!' => '該密碼被使用，請使用其他密碼!',
        'You need to activate %s first to use it!' => '%s 在使用之前請先激活!',
        'No suggestions' => '無建議',
        'Word' => '字',
        'Ignore' => '忽略',
        'replace with' => '替換',
        'There is no account with that login name.' => '該用戶名沒有帳戶信息.',
        'Login failed! Your username or password was entered incorrectly.' => '登錄失敗，您的用戶名或密碼不正確.',
        'Please contact your admin' => '請聯系系統管理員',
        'Logout successful. Thank you for using OTRS!' => '成功注銷，謝謝使用!',
        'Invalid SessionID!' => '無效的會話標識符!',
        'Feature not active!' => '該特性尚未激活!',
        'Notification (Event)' => '通知（事件）',
        'Login is needed!' => '需要先登錄!',
        'Password is needed!' => '需要密碼!',
        'License' => '許可証',
        'Take this Customer' => '取得這個客戶',
        'Take this User' => '取得這個用戶',
        'possible' => '可能',
        'reject' => '拒絕',
        'reverse' => '后退',
        'Facility' => '類別',
        'Timeover' => '結束',
        'Pending till' => '等待至',
        'Don\'t work with UserID 1 (System account)! Create new users!' => '不要使用 UserID 1 (系統賬號)! 請創建一個新的用戶!',
        'Dispatching by email To: field.' => '分派郵件到: 域.',
        'Dispatching by selected Queue.' => '分派郵件到所選隊列.',
        'No entry found!' => '無內容!',
        'Session has timed out. Please log in again.' => '會話超時，請重新登錄.',
        'No Permission!' => '無權限!',
        'To: (%s) replaced with database email!' => 'To: (%s) 被數據庫郵件地址所替代',
        'Cc: (%s) added database email!' => 'Cc: (%s) 增加數據庫郵件地址!',
        '(Click here to add)' => '(點擊此處增加)',
        'Preview' => '預覽',
        'Package not correctly deployed! You should reinstall the Package again!' => '軟件包展開不正常! 您需要再一次重新安裝這個軟件包',
        'Added User "%s"' => '增加用戶 "%s".',
        'Contract' => '合同',
        'Online Customer: %s' => '在線客戶: %s',
        'Online Agent: %s' => '在線技術支持人員：%s',
        'Calendar' => '日歷',
        'File' => '文件',
        'Filename' => '文件名',
        'Type' => '類型',
        'Size' => '大小',
        'Upload' => '上載',
        'Directory' => '目錄',
        'Signed' => '已簽名',
        'Sign' => '簽署',
        'Crypted' => '已加密',
        'Crypt' => '加密',
        'Office' => '辦公室',
        'Phone' => '電話',
        'Fax' => '傳真',
        'Mobile' => '手機',
        'Zip' => '郵編',
        'City' => '城市',
        'Street' => '街道',
        'Country' => '國家',
        'Location' => '區',
        'installed' => '已安裝',
        'uninstalled' => '未安裝',
        'Security Note: You should activate %s because application is already running!' => '安全提示: 您不能激活的 %s, 因為此應用已經在運行!',
        'Unable to parse Online Repository index document!' => '不能分列在線資源索引文檔',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '在線資源中沒有軟件包對應需要的框架，但有其他的框架所需軟件包',
        'No Packages or no new Packages in selected Online Repository!' => '在所選的在線資源中，沒有現存或新的軟件包',
        'printed at' => '打印日期',
        'Loading...' => '',
        'Dear Mr. %s,' => '尊敬的 %s 先生:',
        'Dear Mrs. %s,' => '尊敬的 %s 女士:',
        'Dear %s,' => '尊敬的 %s:',
        'Hello %s,' => '您好, %s:',
        'This account exists.' => '這個帳戶已存在',
        'New account created. Sent Login-Account to %s.' => '新的帳號已創建, 並寄送通知給 %s.',
        'Please press Back and try again.' => '請返回再試一次.',
        'Sent password token to: %s' => '發送密碼到: %s',
        'Sent new password to: %s' => '發送新的密碼到: %s',
        'Upcoming Events' => '即將到來的事件',
        'Event' => '事件',
        'Events' => '事件',
        'Invalid Token!' => '非法的標記',
        'more' => '更多',
        'For more info see:' => '更多信息請看',
        'Package verification failed!' => '軟件包驗証失敗',
        'Collapse' => '收',
        'Shown' => '',
        'News' => '新聞',
        'Product News' => '產品新聞',
        'OTRS News' => '',
        '7 Day Stats' => '',
        'Bold' => '黑體',
        'Italic' => '斜體',
        'Underline' => '底線',
        'Font Color' => '字型顏色',
        'Background Color' => '背景色',
        'Remove Formatting' => '刪除格式',
        'Show/Hide Hidden Elements' => '顯示/隱藏 隱藏要素',
        'Align Left' => '左對齊',
        'Align Center' => '居中對齊',
        'Align Right' => '右對齊',
        'Justify' => '對齊',
        'Header' => '信息頭',
        'Indent' => '縮',
        'Outdent' => '外突',
        'Create an Unordered List' => '創建一個無序列表',
        'Create an Ordered List' => '創建一個有序列表',
        'HTML Link' => 'HTML鏈接',
        'Insert Image' => '插入圖像',
        'CTRL' => '按CTRL',
        'SHIFT' => '按SHIFT',
        'Undo' => '復原',
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
        'June' => '六月',
        'July' => '七月',
        'August' => '八月',
        'September' => '九月',
        'October' => '十月',
        'November' => '十一月',
        'December' => '十二月',

        # Template: AAANavBar
        'Admin-Area' => '管理區域',
        'Agent-Area' => '技術支持人員區',
        'Ticket-Area' => 'Ticket區',
        'Logout' => '注銷',
        'Agent Preferences' => '個人設置',
        'Preferences' => '設置',
        'Agent Mailbox' => '技術支持人員郵箱',
        'Stats' => '統計',
        'Stats-Area' => '統計區',
        'Admin' => '管理',
        'Customer Users' => '客戶用戶',
        'Customer Users <-> Groups' => '客戶用戶 <-> 組',
        'Users <-> Groups' => '用戶 <-> 組',
        'Roles' => '角色',
        'Roles <-> Users' => '角色 <-> 用戶',
        'Roles <-> Groups' => '角色 <-> 組',
        'Salutations' => '稱謂',
        'Signatures' => '簽名',
        'Email Addresses' => 'Email 地址',
        'Notifications' => '系統通知',
        'Category Tree' => '目錄樹',
        'Admin Notification' => '管理員通知',

        # Template: AAAPreferences
        'Preferences updated successfully!' => '設置更新成功!',
        'Mail Management' => '郵件相關設置',
        'Frontend' => '前端界面',
        'Other Options' => '其他選項',
        'Change Password' => '修改密碼',
        'New password' => '新密碼',
        'New password again' => '重復新密碼',
        'Select your QueueView refresh time.' => '隊列視圖刷新時間.',
        'Select your frontend language.' => '界面語言',
        'Select your frontend Charset.' => '界面字符集.',
        'Select your frontend Theme.' => '界面主題.',
        'Select your frontend QueueView.' => '隊列視圖.',
        'Spelling Dictionary' => '拼寫檢查字典',
        'Select your default spelling dictionary.' => '缺省拼寫檢查字典.',
        'Max. shown Tickets a page in Overview.' => '每一頁顯示的最大 Tickets 數目.',
        'Can\'t update password, your new passwords do not match! Please try again!' => '密碼兩次不符，無法更新，請重新輸入',
        'Can\'t update password, invalid characters!' => '無法更新密碼，包含無效字符.',
        'Can\'t update password, must be at least %s characters!' => '無法更新密碼，密碼長度至少%s位.',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => '無法更新密碼，至少包含2個大寫字符和2個小寫字符.',
        'Can\'t update password, needs at least 1 digit!' => '無法更新密碼，至少包含1位數字',
        'Can\'t update password, needs at least 2 characters!' => '無法更新密碼，至少包含2個字母!',

        # Template: AAAStats
        'Stat' => '統計',
        'Please fill out the required fields!' => '請填寫必填字段',
        'Please select a file!' => '請選擇一個文件!',
        'Please select an object!' => '請選擇一個對象!',
        'Please select a graph size!' => '請選擇圖片尺寸!',
        'Please select one element for the X-axis!' => '請選擇一個元素的X-軸',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => '請隻選擇一個元素或關閉被選域的\'Fixed\'按鈕',
        'If you use a checkbox you have to select some attributes of the select field!' => '如果你使用復選框你必須選擇被選域的一些屬性!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '在選定的輸入欄請插入一個值，或關閉\'Fixed\'復選框！',
        'The selected end time is before the start time!' => '選定的結束時間早於開始時間！',
        'You have to select one or more attributes from the select field!' => '從被選域中你必須選擇一個或多個屬性！',
        'The selected Date isn\'t valid!' => '所選日期不有效',
        'Please select only one or two elements via the checkbox!' => '通過復選框，請隻選擇一個或兩個要素！',
        'If you use a time scale element you can only select one element!' => '如果您使用的是時間尺度要素你隻能選擇其中一個組成部分',
        'You have an error in your time selection!' => '你有一個錯誤的時間選擇！',
        'Your reporting time interval is too small, please use a larger time scale!' => '您的報告時間間隔太小，請使用更大的間隔',
        'The selected start time is before the allowed start time!' => '選定的開始時間早於允許的開始時間',
        'The selected end time is after the allowed end time!' => '選定的結束時間晚於允許的結束時間',
        'The selected time period is larger than the allowed time period!' => '在選定時間段大於允許的時間段',
        'Common Specification' => '共同規范',
        'Xaxis' => 'X軸',
        'Value Series' => '價值系列',
        'Restrictions' => '限制',
        'graph-lines' => '線圖',
        'graph-bars' => '柱狀圖',
        'graph-hbars' => 'H柱狀圖',
        'graph-points' => '圖點',
        'graph-lines-points' => '圖線點',
        'graph-area' => '圖區',
        'graph-pie' => '餅圖',
        'extended' => '擴展',
        'Agent/Owner' => '所有者',
        'Created by Agent/Owner' => '技術支持人員創建的',
        'Created Priority' => '創建的優先級',
        'Created State' => '創建的狀態',
        'Create Time' => '創建時間',
        'CustomerUserLogin' => '客戶登陸',
        'Close Time' => '關閉時間',
        'TicketAccumulation' => 'Ticket積累',
        'Attributes to be printed' => '要打印的屬性',
        'Sort sequence' => '排序序列',
        'Order by' => '按順序排',
        'Limit' => '極限',
        'Ticketlist' => 'Ticket清單',
        'ascending' => '升序',
        'descending' => '降序',
        'First Lock' => '首先鎖定',
        'Evaluation by' => '評價的人',
        'Total Time' => '總時間',
        'Ticket Average' => 'Ticket處理平均時間',
        'Ticket Min Time' => 'Ticket處理最小時間',
        'Ticket Max Time' => 'Ticket處理最大時間',
        'Number of Tickets' => 'Ticket數目',
        'Article Average' => 'Article處理平均時間',
        'Article Min Time' => 'Article處理最小時間',
        'Article Max Time' => 'Article處理最大時間',
        'Number of Articles' => 'Article數量',
        'Accounted time by Agent' => '技術支持人員處理Ticket所用的時間',
        'Ticket/Article Accounted Time' => 'Ticket/Article所佔用的時間',
        'TicketAccountedTime' => 'Ticket所佔用的時間',
        'Ticket Create Time' => 'Ticket創建時間',
        'Ticket Close Time' => 'Ticket關閉時間',

        # Template: AAATicket
        'Lock' => '鎖定',
        'Unlock' => '解鎖',
        'History' => '歷史',
        'Zoom' => '郵件展開',
        'Age' => '總時間',
        'Bounce' => '回退',
        'Forward' => '轉發',
        'From' => '發件人',
        'To' => '收件人',
        'Cc' => '抄送',
        'Bcc' => '暗送',
        'Subject' => '標題',
        'Move' => '移動',
        'Queue' => '隊列',
        'Priority' => '優先級',
        'Priority Update' => '更新優先級',
        'State' => '狀態',
        'Compose' => '撰寫',
        'Pending' => '等待',
        'Owner' => '所有者',
        'Owner Update' => '更新所有者',
        'Responsible' => '負責人',
        'Responsible Update' => '更新負責人',
        'Sender' => '發件人',
        'Article' => '信件',
        'Ticket' => 'Ticket',
        'Createtime' => '創建時間',
        'plain' => '純文本',
        'Email' => '郵件地址',
        'email' => 'E-Mail',
        'Close' => '關閉',
        'Action' => '動作',
        'Attachment' => '附件',
        'Attachments' => '附件',
        'This message was written in a character set other than your own.' => '這封郵件所用字符集與本系統字符集不符',
        'If it is not displayed correctly,' => '如果顯示不正確,',
        'This is a' => '這是一個',
        'to open it in a new window.' => '在新窗口中打開',
        'This is a HTML email. Click here to show it.' => '這是一封HTML格式郵件，點擊這裡顯示.',
        'Free Fields' => '額外信息',
        'Merge' => '合並',
        'merged' => '已合並',
        'closed successful' => '成功關閉',
        'closed unsuccessful' => '關閉失敗',
        'new' => '新建',
        'open' => '打開',
        'Open' => '打開',
        'closed' => '關閉',
        'Closed' => '關閉',
        'removed' => '刪除',
        'pending reminder' => '等待提醒',
        'pending auto' => '自動等待',
        'pending auto close+' => '等待自動關閉+',
        'pending auto close-' => '等待自動關閉-',
        'email-external' => '外部 E-Mail ',
        'email-internal' => '內部 E-Mail ',
        'note-external' => '外部注解',
        'note-internal' => '內部注解',
        'note-report' => '注解報告',
        'phone' => '電話',
        'sms' => '短信',
        'webrequest' => 'Web請求',
        'lock' => '鎖定',
        'unlock' => '未鎖定',
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
        'Ticket "%s" created!' => 'Ticket "%s" 已創建!',
        'Ticket Number' => 'Ticket 編號',
        'Ticket Object' => 'Ticket 對象',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ticket "%s" 不存在，不能創建到其的鏈接!',
        'Don\'t show closed Tickets' => '不顯示已關閉的 Tickets',
        'Show closed Tickets' => '顯示已關閉的 Tickets',
        'New Article' => '新文章',
        'Email-Ticket' => '郵件 Ticket',
        'Create new Email Ticket' => '創建新的郵件 Ticket',
        'Phone-Ticket' => '電話 Ticket',
        'Search Tickets' => '搜索 Tickets',
        'Edit Customer Users' => '編輯客戶帳戶',
        'Edit Customer Company' => '編輯客戶單位',
        'Bulk Action' => '批量處理',
        'Bulk Actions on Tickets' => '批量處理 Tickets',
        'Send Email and create a new Ticket' => '發送 Email 並創建一個新的 Ticket',
        'Create new Email Ticket and send this out (Outbound)' => '創建新的 Ticket並發送出去',
        'Create new Phone Ticket (Inbound)' => '創建新的電話Ticket（進來的Ticket）',
        'Overview of all open Tickets' => '所有開放 Tickets 概況',
        'Locked Tickets' => '已鎖定 Ticket',
        'Watched Tickets' => '訂閱 Tickets',
        'Watched' => '訂閱',
        'Subscribe' => '訂閱',
        'Unsubscribe' => '退訂',
        'Lock it to work on it!' => '鎖定並開始工作 !',
        'Unlock to give it back to the queue!' => '解鎖並送回隊列!',
        'Shows the ticket history!' => '顯示 Ticket 歷史狀況!',
        'Print this ticket!' => '打印 Ticket !',
        'Change the ticket priority!' => '修改 Ticket 優先級',
        'Change the ticket free fields!' => '修改 Ticket 額外信息',
        'Link this ticket to an other objects!' => '鏈接該 Ticket 到其他對象!',
        'Change the ticket owner!' => '修改 Ticket 所有者!',
        'Change the ticket customer!' => '修改 Ticket 所屬客戶!',
        'Add a note to this ticket!' => '給 Ticket 增加注解!',
        'Merge this ticket!' => '合並該 Ticket!',
        'Set this ticket to pending!' => '將該 Ticket 轉入等待狀態',
        'Close this ticket!' => '關閉該 Ticket!',
        'Look into a ticket!' => '查看 Ticket 內容',
        'Delete this ticket!' => '刪除該 Ticket!',
        'Mark as Spam!' => '標記為垃圾!',
        'My Queues' => '我的隊列',
        'Shown Tickets' => '顯示 Tickets',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '您的郵件 "<OTRS_TICKET>" 被合並到 "<OTRS_MERGE_TO_TICKET>" !',
        'Ticket %s: first response time is over (%s)!' => 'Ticket %s: 第一響應時間已耗時(%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Ticket %s: 第一響應時間將耗時(%s)!',
        'Ticket %s: update time is over (%s)!' => 'Ticket %s: 更新時間已耗時(%s)!',
        'Ticket %s: update time will be over in %s!' => 'Ticket %s: 更新時間將耗時(%s)!',
        'Ticket %s: solution time is over (%s)!' => 'Ticket %s: 處理解決已耗時(%s)!',
        'Ticket %s: solution time will be over in %s!' => '處理解決將耗時(%s)!',
        'There are more escalated tickets!' => '有更多升級的tickets',
        'New ticket notification' => '新 Ticket 通知',
        'Send me a notification if there is a new ticket in "My Queues".' => '如果我的隊列中有新的 Ticket，請通知我.',
        'Follow up notification' => '跟蹤通知',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => '如果客戶發送了 Ticket 回復，並且我是該 Ticket 的所有者.',
        'Ticket lock timeout notification' => 'Ticket 鎖定超時通知 ',
        'Send me a notification if a ticket is unlocked by the system.' => '如果 Ticket 被系統解鎖，請通知我.',
        'Move notification' => '移動通知',
        'Send me a notification if a ticket is moved into one of "My Queues".' => '如果有 Ticket 被轉入我的隊列，請通知我.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => '您的最常用隊列，如果您的郵件設置激活，您將會得到該隊列的狀態通知.',
        'Custom Queue' => '客戶隊列',
        'QueueView refresh time' => '隊列視圖刷新時間',
        'Screen after new ticket' => '創建新 Ticket 后的視圖',
        'Select your screen after creating a new ticket.' => '選擇您創建新 Ticket 后，所顯示的視圖.',
        'Closed Tickets' => '關閉 Tickets',
        'Show closed tickets.' => '顯示已關閉 Tickets.',
        'Max. shown Tickets a page in QueueView.' => '隊列視圖每頁顯示 Ticket 數.',
        'Watch notification' => '關注通知',
        'Send me a notification of an watched ticket like an owner of an ticket.' => '對我所關注的ticket，像該ticket的擁有人一樣，給我也發一份通知',
        'Out Of Office' => '不在辦公室',
        'Select your out of office time.' => '選擇你不在辦公室的時間',
        'CompanyTickets' => '公司Tickets',
        'MyTickets' => '我的 Tickets',
        'New Ticket' => '新的 Ticket',
        'Create new Ticket' => '創建新的 Ticket',
        'Customer called' => '客戶致電',
        'phone call' => '電話呼叫',
        'Reminder Reached' => '提醒已達',
        'Reminder Tickets' => '提醒的 Ticket',
        'Escalated Tickets' => '升級的Ticket',
        'New Tickets' => '新的Ticket',
        'Open Tickets / Need to be answered' => '打開的Tickets/需要回答',
        'Tickets which need to be answered!' => '需要回答的 Ticket',
        'All new tickets!' => '所有新的tickets',
        'All tickets which are escalated!' => '所有升級的tickets',
        'All tickets where the reminder date has reached!' => '所有已到提醒日期的Ticket',
        'Responses' => '回復',
        'Responses <-> Queue' => '回復 <-> 隊列',
        'Auto Responses' => '自動回復功能',
        'Auto Responses <-> Queue' => '自動回復 <-> 隊列',
        'Attachments <-> Responses' => '附件 <-> 回復',
        'History::Move' => 'Ticket 移到隊列 "%s" (%s) 從隊列 "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => '更新服務級別協議 to %s (ID=%s).',
        'History::NewTicket' => 'New ticket [%s] created (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp for [%s]. %s',
        'History::SendAutoReject' => '自動拒絕發送給 "%s".',
        'History::SendAutoReply' => '自動回復發送給 "%s".',
        'History::SendAutoFollowUp' => '自動跟蹤發送給 "%s".',
        'History::Forward' => '轉發給 "%s".',
        'History::Bounce' => '回退到 "%s".',
        'History::SendAnswer' => '信件發送給 "%s".',
        'History::SendAgentNotification' => '"%s"-Benachrichtigung versand an "%s".',
        'History::SendCustomerNotification' => '通知發送給 "%s".',
        'History::EmailAgent' => '發郵件給客戶.',
        'History::EmailCustomer' => 'Add mail. %s',
        'History::PhoneCallAgent' => 'Called customer',
        'History::PhoneCallCustomer' => '客戶已打過電話',
        'History::AddNote' => '加注釋 (%s)',
        'History::Lock' => 'Ticket 鎖定.',
        'History::Unlock' => 'Ticket 解鎖.',
        'History::TimeAccounting' => '%s time unit(d) counted. Totaly %s time unit(s) counted.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Refreshed: %s',
        'History::PriorityUpdate' => '優先級被更新，從  "%s" (%s) 到 "%s" (%s).',
        'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop protection! sent no auto answer to "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Refreshed: %s',
        'History::StateUpdate' => 'Before "%s" 新: "%s"',
        'History::TicketFreeTextUpdate' => 'Refreshed: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => '客戶進行網上請求.',
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
        'Auto Response Management' => '自動回復管理',
        'Response' => '回復',
        'Auto Response From' => '自動回復來自',
        'Note' => '注解',
        'Useable options' => '可用宏變量',
        'To get the first 20 character of the subject.' => '顯示標題的前20個字節',
        'To get the first 5 lines of the email.' => '顯示電郵的前五行',
        'To get the realname of the sender (if given).' => '顯示發件人的真實名字',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '當前客戶信息的可選項 (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Ticket擁有者的可選項 e. g. <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Ticket責任選項 (e. g. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => '管理客人單位',
        'Search for' => '搜索',
        'Add Customer Company' => '增加客人單位',
        'Add a new Customer Company.' => '增加客人到單位裡',
        'List' => '列表',
        'This values are required.' => '該條目必須填寫.',
        'This values are read only.' => '該數據隻讀.',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => '進行消息撰寫的窗口已經被關閉,退出.',
        'This window must be called from compose window' => '該窗口必須由撰寫窗口調用',
        'Customer User Management' => '客戶用戶管理',
        'Add Customer User' => '增加客人',
        'Source' => '數據源',
        'Create' => '創建',
        'Customer user will be needed to have a customer history and to login via customer panel.' => '客戶用戶必須有一個賬號從客戶登錄頁面登錄系統.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => '客戶用戶 <-> 組 管理',
        'Change %s settings' => '修改 %s 設置',
        'Select the user:group permissions.' => '選擇 用戶:組 權限.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '如果不選擇，則該組沒有權限 (該組無法處理 Ticket)',
        'Permission' => '權限',
        'ro' => '隻讀',
        'Read only access to the ticket in this group/queue.' => '隊列中的 Ticket 隻讀.',
        'rw' => '讀寫',
        'Full read and write access to the tickets in this group/queue.' => '隊列中的 Ticket 讀/寫.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '客戶帳號 <-> 服務管理',
        'CustomerUser' => '客戶用戶',
        'Service' => '服務',
        'Edit default services.' => '編輯默認服務',
        'Search Result' => '搜索結果',
        'Allocate services to CustomerUser' => '分配服務給客戶',
        'Active' => '激活',
        'Allocate CustomerUser to service' => '指派客戶到服務',

        # Template: AdminEmail
        'Message sent to' => '消息發送給',
        'A message should have a subject!' => '郵件必須有標題!',
        'Recipients' => '收件人',
        'Body' => '內容',
        'Send' => '發送',

        # Template: AdminGenericAgent
        'GenericAgent' => '計劃任務',
        'Job-List' => '工作列表',
        'Last run' => '最后運行',
        'Run Now!' => '現在運行!',
        'x' => '',
        'Save Job as?' => '保存工作為?',
        'Is Job Valid?' => '工作是否有效?',
        'Is Job Valid' => '工作有效',
        'Schedule' => '安排',
        'Currently this generic agent job will not run automatically.' => '目前這一通用Agent作業將不會自動運行',
        'To enable automatic execution select at least one value from minutes, hours and days!' => '啟用自動執行至少選擇一個值分鐘，時間和日期',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '文章全文搜索 (例如: "Mar*in" 或者 "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '  例如: 10*5144 或者 105658*',
        '(e. g. 234321)' => '例如: 234321',
        'Customer User Login' => '客戶用戶登錄信息',
        '(e. g. U5150)' => '例如: U5150',
        'SLA' => '服務級別協議(SLA)',
        'Agent' => '技術支持人員',
        'Ticket Lock' => 'Ticket 鎖狀態',
        'TicketFreeFields' => 'Ticket 自由區域',
        'Create Times' => '創建時間',
        'No create time settings.' => '沒有創建時間設置',
        'Ticket created' => '創建時間',
        'Ticket created between' => ' 創建時間在',
        'Close Times' => '關閉時間',
        'No close time settings.' => '',
        'Ticket closed' => '關閉的 Ticket',
        'Ticket closed between' => '',
        'Pending Times' => '待定時間',
        'No pending time settings.' => '沒有設置待定時間',
        'Ticket pending time reached' => '待定時間已到的Ticket',
        'Ticket pending time reached between' => '在待定時間內的Ticket ',
        'Escalation Times' => '升級時間',
        'No escalation time settings.' => '沒有升級時間設置',
        'Ticket escalation time reached' => '已到升級時間Ticket',
        'Ticket escalation time reached between' => '在升級時間內的Ticket',
        'Escalation - First Response Time' => '任務調升 - 首次回復的時間',
        'Ticket first response time reached' => '首次回復時間已到的Ticket',
        'Ticket first response time reached between' => '在首次回復時間內的Ticket',
        'Escalation - Update Time' => '任務調升 - 更新的時間',
        'Ticket update time reached' => '更新時間已到的Ticket',
        'Ticket update time reached between' => '在更新時間內的Ticket',
        'Escalation - Solution Time' => '任務調升 - 解決的時間',
        'Ticket solution time reached' => '方案解決時間已到的Ticket',
        'Ticket solution time reached between' => '在方案解決時間內已到的Ticket',
        'New Service' => '新的服務級別',
        'New SLA' => '新的服務級別協議(SLA)',
        'New Priority' => '新優先級',
        'New Queue' => '新隊列',
        'New State' => '新狀態',
        'New Agent' => '新技術支持人員',
        'New Owner' => '新所有者',
        'New Customer' => '新客戶',
        'New Ticket Lock' => '新 Ticket 鎖',
        'New Type' => '新的類型',
        'New Title' => '新的標題',
        'New TicketFreeFields' => '新的 Ticket 自由區域',
        'Add Note' => '增加注解',
        'Time units' => '時間單元',
        'CMD' => '命令',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '將執行這個命令, 第一個參數是 Ticket 編號，第二個參數是 Ticket 的標識符.',
        'Delete tickets' => '刪除 Tickets',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => '警告! 該 Ticket 將會從數據庫刪除，無法恢復!',
        'Send Notification' => '發送通知',
        'Param 1' => '參數 1',
        'Param 2' => '參數 2',
        'Param 3' => '參數 3',
        'Param 4' => '參數 4',
        'Param 5' => '參數 5',
        'Param 6' => '參數 6',
        'Send agent/customer notifications on changes' => '發送代理/客戶通知變更',
        'Save' => '保存',
        '%s Tickets affected! Do you really want to use this job?' => '%s Tickets 受到影響! 您確定要使用這個計劃任務?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => '警告：當您更改\'管理\'組的名稱時，在SysConfig作出相應的變化之前，你將被管理面板鎖住！如果發生這種情況，請用SQL語句把組名改回到\'admin\'',
        'Group Management' => '組管理',
        'Add Group' => '增加新的組',
        'Add a new Group.' => '增加一個新組',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin 組可以進入系統管理區域, Stats 組可以進入統計管理區',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => '創建新的組來控制不同的存取權限',
        'It\'s useful for ASP solutions.' => '這是一個有效的應用服務提供商(ASP)解決方案.',

        # Template: AdminLog
        'System Log' => '系統日志',
        'Time' => '時間',

        # Template: AdminMailAccount
        'Mail Account Management' => '郵件帳號管理',
        'Host' => '主機',
        'Trusted' => '是否信任',
        'Dispatching' => '分派',
        'All incoming emails with one account will be dispatched in the selected queue!' => '所有來自一個郵件賬號的郵件將會被分發到所選隊列!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '如果您的帳戶是值得信賴的，現有的X-OTRS標題到達時間（優先， ... ）將被使用！郵政過濾器將被使用',

        # Template: AdminNavigationBar
        'Users' => '用戶',
        'Groups' => '組',
        'Misc' => '綜合',

        # Template: AdminNotificationEventForm
        'Notification Management' => '通知管理',
        'Add Notification' => '增加通知',
        'Add a new Notification.' => '',
        'Name is required!' => '需要名稱!',
        'Event is required!' => '需要事件',
        'A message should have a body!' => '郵件必須包含內容!',
        'Recipient' => '收件人',
        'Group based' => '基於組的',
        'Agent based' => '基於技術支持代表的',
        'Email based' => '基於電郵的',
        'Article Type' => 'Article類別 ',
        'Only for ArticleCreate Event.' => '',
        'Subject match' => '標題匹配',
        'Body match' => '內容匹配',
        'Notifications are sent to an agent or a customer.' => '通知被發送到技術支持人員或者客戶.',
        'To get the first 20 character of the subject (of the latest agent article).' => '',
        'To get the first 5 lines of the body (of the latest agent article).' => '',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => '',
        'To get the first 20 character of the subject (of the latest customer article).' => '',
        'To get the first 5 lines of the body (of the latest customer article).' => '',

        # Template: AdminNotificationForm
        'Notification' => '系統通知',

        # Template: AdminPackageManager
        'Package Manager' => '軟件包管理',
        'Uninstall' => '卸載',
        'Version' => '版本',
        'Do you really want to uninstall this package?' => '是否確認卸載該軟件包?',
        'Reinstall' => '重新安裝',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '您是否准備好重新安裝這些軟件包 (所有手工設置將會不見)?',
        'Continue' => '繼續',
        'Install' => '安裝',
        'Package' => '軟件包',
        'Online Repository' => '在線知識庫',
        'Vendor' => '提供者',
        'Module documentation' => '模塊文檔',
        'Upgrade' => '升級',
        'Local Repository' => '本地知識庫',
        'Status' => '狀態',
        'Overview' => '概況',
        'Download' => '下載',
        'Rebuild' => '重新構建',
        'ChangeLog' => '改變記錄',
        'Date' => '日期',
        'Filelist' => '文件清單',
        'Download file from package!' => '從軟件包中下載這個文件',
        'Required' => '必需的',
        'PrimaryKey' => '關鍵的Key',
        'AutoIncrement' => '自動遞增',
        'SQL' => 'SQL',
        'Diff' => '比較',

        # Template: AdminPerformanceLog
        'Performance Log' => '系統監視器',
        'This feature is enabled!' => '該功能已啟用',
        'Just use this feature if you want to log each request.' => '如果您想詳細記錄每個請求, 您可以使用該功能.',
        'Activating this feature might affect your system performance!' => '啟動該功能可能影響您的系統性能',
        'Disable it here!' => '關閉該功能',
        'This feature is disabled!' => '該功能已關閉',
        'Enable it here!' => '打開該功能',
        'Logfile too large!' => '日志文件過大',
        'Logfile too large, you need to reset it!' => '日志文件過大, 你需要重置它',
        'Range' => '范圍',
        'Interface' => '界面',
        'Requests' => '請求',
        'Min Response' => '最小回應',
        'Max Response' => '最大回應',
        'Average Response' => '平均回應',
        'Period' => '周期',
        'Min' => '最小',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP 管理',
        'Result' => '結果',
        'Identifier' => '標識符',
        'Bit' => '位',
        'Key' => '密匙',
        'Fingerprint' => '指印',
        'Expires' => '過期',
        'In this way you can directly edit the keyring configured in SysConfig.' => '這種方式，您可以直接編輯在SysConfig設置的鍵',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '郵件過濾管理',
        'Filtername' => '過濾器名稱',
        'Stop after match' => '',
        'Match' => '匹配',
        'Value' => '值',
        'Set' => '設置',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '如果您想根據 X-Headers 內容來過濾，可以使用正規則表達式.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '如果您想僅匹配email 地址， 請使用EMAILADDRESS:info@example.com in From, To or Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '如果您用RegExp，您也能使用匹配值in () as [***] in \'Set\'',

        # Template: AdminPriority
        'Priority Management' => '優先權管理',
        'Add Priority' => '添加優先權',
        'Add a new Priority.' => '增加一個新的優先權',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => '隊列 <-> 自動回復管理',
        'settings' => '設置',

        # Template: AdminQueueForm
        'Queue Management' => '隊列管理',
        'Sub-Queue of' => '子隊列',
        'Unlock timeout' => '自動解鎖超時期限',
        '0 = no unlock' => '0 = 不自動解鎖  ',
        'Only business hours are counted.' => '僅以上班時間計算',
        '0 = no escalation' => '0 = 無限時  ',
        'Notify by' => '進度通知',
        'Follow up Option' => '跟進選項',
        'Ticket lock after a follow up' => '跟進確認以后，Ticket 將被自動上鎖',
        'Systemaddress' => '系統郵件地址',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '如果技術支持人員鎖定了 Ticket,但是在一定的時間內沒有回復，該 Ticket 將會被自動解鎖，而對所有的技術支持人員可視.',
        'Escalation time' => '限時答復時間',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => '該隊列隻顯示規定時間內沒有被處理的 Ticket',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '如果 Ticket 已經處於關閉狀態，而客戶就發送了一個跟進 Ticket，那麼這個 Ticket 將會被直接加鎖，而所有者被定義為原來所有者',
        'Will be the sender address of this queue for email answers.' => '回復郵件所用的發送者地址',
        'The salutation for email answers.' => '回復郵件所用稱謂.',
        'The signature for email answers.' => '回復郵件所用簽名.',
        'Customer Move Notify' => 'Ticket 移動客戶通知',
        'OTRS sends an notification email to the customer if the ticket is moved.' => '如果 Ticket 被移動，系統將會發送一個通知郵件給客戶',
        'Customer State Notify' => 'Ticket 狀態客戶通知',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => '如果 Ticket 狀態改變，系統將會發送通知郵件給客戶',
        'Customer Owner Notify' => '客戶所有者通告',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => '如果 Ticket 所有者改變，系統將會發送通知郵件給客戶.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => '回復 <-> 隊列管理',

        # Template: AdminQueueResponsesForm
        'Answer' => '回復',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => '回復 <-> 附件管理',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => '回復內容管理',
        'A response is default text to write faster answer (with default text) to customers.' => '為了快速回復，回復內容定義了每個回復中重復的內容.',
        'Don\'t forget to add a new response a queue!' => '不要忘記增加一個新的回復內容到隊列!',
        'The current ticket state is' => '當前 Ticket 狀態是',
        'Your email address is new' => '您的郵件地址是新的',

        # Template: AdminRoleForm
        'Role Management' => '角色管理',
        'Add Role' => '增加角色',
        'Add a new Role.' => '新增一個角色',
        'Create a role and put groups in it. Then add the role to the users.' => '創建一個角色並將組加入角色,然后將角色賦給用戶.',
        'It\'s useful for a lot of users and groups.' => '當有大量的用戶和組的時候，角色非常適合.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => '角色 <-> 組管理',
        'move_into' => '移動到',
        'Permissions to move tickets into this group/queue.' => '允許移動 Tickets 到該組/隊列.',
        'create' => '創建',
        'Permissions to create tickets in this group/queue.' => '在該組/隊列中創建 Tickets 的權限.',
        'owner' => '所有者',
        'Permissions to change the ticket owner in this group/queue.' => '在該組/隊列中修改 Tickets 所有者的權限.',
        'priority' => '優先級',
        'Permissions to change the ticket priority in this group/queue.' => '在該組/隊列中修改 Tickets 優先級的權限.',

        # Template: AdminRoleGroupForm
        'Role' => '角色',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => '角色 <-> 用戶管理',
        'Select the role:user relations.' => '選擇 角色:用戶 關聯.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => '稱呼語管理',
        'Add Salutation' => '增加稱呼語',
        'Add a new Salutation.' => '增加一個新的稱呼語',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => '安全模式需要啟動',
        'Secure mode will (normally) be set after the initial installation is completed.' => '在初始安裝結束后，安全模式通常將被設置',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => '為了重新用Web 界面安裝，安全模式必須disabled',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => '如果啟動模式沒有被啟動，請通過系統設置啟動它因為您的OTRS程序已經運行',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL查詢窗口',
        'CSV' => '',
        'HTML' => '',
        'Select Box Result' => '查詢結果',

        # Template: AdminService
        'Service Management' => '服務管理',
        'Add Service' => '增加服務',
        'Add a new Service.' => '新增一個服務',
        'Sub-Service of' => '子服務隸屬於',

        # Template: AdminSession
        'Session Management' => '會話管理',
        'Sessions' => '會話',
        'Uniq' => '單一',
        'Kill all sessions' => '終止所有會話',
        'Session' => '會話',
        'Content' => '內容',
        'kill session' => '終止會話',

        # Template: AdminSignatureForm
        'Signature Management' => '簽名管理',
        'Add Signature' => '增加簽名',
        'Add a new Signature.' => '新增一個簽名',

        # Template: AdminSLA
        'SLA Management' => '服務級別協議(SLA)管理',
        'Add SLA' => '增加服務級別協議(SLA)',
        'Add a new SLA.' => '新增一個服務級別協議(SLA).',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME 管理',
        'Add Certificate' => '添加証書',
        'Add Private Key' => '添加私匙',
        'Secret' => '密碼',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => '用這種方式您可以直接編輯証書和私匙',

        # Template: AdminStateForm
        'State Management' => '狀態管理',
        'Add State' => '增加狀態',
        'Add a new State.' => '增加一個新的狀態',
        'State Type' => '狀態類型',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => '您同時更新了 Kernel/Config.pm 中的缺省狀態!',
        'See also' => '參見',

        # Template: AdminSysConfig
        'SysConfig' => '系統配置',
        'Group selection' => '選擇組',
        'Show' => '顯示',
        'Download Settings' => '下載設置',
        'Download all system config changes.' => '下載所有的系統配置變化.',
        'Load Settings' => '加載設置',
        'Subgroup' => '子組',
        'Elements' => '元素',

        # Template: AdminSysConfigEdit
        'Config Options' => '配置選項',
        'Default' => '缺省',
        'New' => '新',
        'New Group' => '新組',
        'Group Ro' => '隻讀權限的組',
        'New Group Ro' => '新的隻讀權限的組',
        'NavBarName' => '導航欄名稱',
        'NavBar' => '導航欄',
        'Image' => '圖片',
        'Prio' => '優先級',
        'Block' => '塊',
        'AccessKey' => '進鑰',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => '系統郵件地址管理',
        'Add System Address' => '增加系統郵件地址',
        'Add a new System Address.' => '增加一個新的系統郵件地址.',
        'Realname' => '真實姓名',
        'All email addresses get excluded on replaying on composing an email.' => '',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => '所有發送到該收件人的消息將被轉到所選擇的隊列',

        # Template: AdminTypeForm
        'Type Management' => '類型管理',
        'Add Type' => '增加類型',
        'Add a new Type.' => '增加一個新的類型',

        # Template: AdminUserForm
        'User Management' => '人員管理',
        'Add User' => '增加人員',
        'Add a new Agent.' => '增加一個新的人員',
        'Login as' => '登錄名',
        'Firstname' => '名',
        'Lastname' => '姓',
        'Start' => '開始',
        'End' => '結束',
        'User will be needed to handle tickets.' => '需要用戶來處理 Tickets.',
        'Don\'t forget to add a new user to groups and/or roles!' => '不要忘記增加一個用戶到組和角色!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => '用戶 <-> 組管理',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => '地址簿',
        'Return to the compose screen' => '回到撰寫頁面',
        'Discard all changes and return to the compose screen' => '放棄所有修改,回到撰寫頁面',

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
        'Please update now.' => '請更新',
        'Release Note' => '版本發布注釋',
        'Level' => '級別',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '',

        # Template: AgentDashboardTicketGeneric

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline

        # Template: AgentInfo
        'Info' => '詳情',

        # Template: AgentLinkObject
        'Link Object: %s' => '連接對象: %s',
        'Object' => '對象',
        'Link Object' => '鏈接對象',
        'with' => '和',
        'Select' => '選擇',
        'Unlink Object: %s' => '未連接對象 %s',

        # Template: AgentLookup
        'Lookup' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => '拼寫檢查',
        'spelling error(s)' => '拼寫錯誤',
        'or' => '或者',
        'Apply these changes' => '應用這些改變',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => '您是否確認刪除該對象?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '選擇限制參數，使統計特征化',
        'Fixed' => '',
        'Please select only one element or turn off the button \'Fixed\'.' => '請隻選擇一個元素或關閉被選域的\'Fixed\'按鈕',
        'Absolut Period' => '絕對周期',
        'Between' => '',
        'Relative Period' => '相對周期',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '您可以為您的統計制定限制參數',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '如果您刪除鉤在“固定”復選框，生成該統計的技術支持代表可以改變相應要素的屬性',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '插入共同規范',
        'Permissions' => '可許',
        'Format' => '格式',
        'Graphsize' => '圖形化',
        'Sum rows' => '總和行',
        'Sum columns' => '總和列',
        'Cache' => '緩存',
        'Required Field' => '必填字段',
        'Selection needed' => '選擇需要',
        'Explanation' => '解釋',
        'In this form you can select the basic specifications.' => '以這種形式，您可以選擇基本規范',
        'Attribute' => '屬性',
        'Title of the stat.' => '統計的標題',
        'Here you can insert a description of the stat.' => '您可以插入統計的描述',
        'Dynamic-Object' => '動態對象',
        'Here you can select the dynamic object you want to use.' => '您可以選擇您需要使用的動態對象',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '注：這取決於您的安裝多少動態對象可以使用',
        'Static-File' => '靜態文件',
        'For very complex stats it is possible to include a hardcoded file.' => '對於非常復雜的統計有可能包括一個硬編碼文件',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => '如果一個新的硬編碼文件存在，可此屬性將顯示，您可以選擇其中一個',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '權限設置。您可以選擇一個或多個團體，不同的技術支持代表都可看見該配置的統計',
        'Multiple selection of the output format.' => '輸出格式的多種選擇',
        'If you use a graph as output format you have to select at least one graph size.' => '如果您使用的是圖形的輸出格式你必須至少選擇一個圖形的大小',
        'If you need the sum of every row select yes' => '如需要每行的總和選擇 yes’',
        'If you need the sum of every column select yes.' => '如需要每列的總和選擇’yes’',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => '大多數的統計資料可以緩存,這將加快這一統計的展示.',
        '(Note: Useful for big databases and low performance server)' => '注：適用於大型數據庫和低性能的服務器',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '用無效的統計不可生成統計',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '這是非常有用的，如果你不想讓人得到統計的結果或統計結果並不完整',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => '選擇價值系列的要素',
        'Scale' => '尺度',
        'minimal' => '最小化',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '請記住，這比額表的價值系列要大於X軸的尺度（如X -軸=>本月， ValueSeries =>年） ',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '在這裡，您可以定義一系列的值。你有可能選擇一個或兩個因素。然后您可以選擇元素的屬性。每個屬性將顯示為單一的值。如果您不選擇任何屬性, 那麼當您生成一個統計的時候所有元素的屬性將被使用。並且一個新的屬性被更新到上次配置中',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '選擇將用在x軸的元素',
        'maximal period' => '最大周期',
        'minimal scale' => '最小尺度',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '在這裡，您可以定義x軸。您可以選擇的一個因素通過單選按鈕。如果你沒有選擇，所有元素的屬性將被使用當您生成一個統計的時候。並且一個新的屬性被更新到上次配置中',

        # Template: AgentStatsImport
        'Import' => '導入',
        'File is not a Stats config' => '文件不是一個統計配置',
        'No File selected' => '沒有文件被選中',

        # Template: AgentStatsOverview
        'Results' => '結果',
        'Total hits' => '點擊數',
        'Page' => '頁',

        # Template: AgentStatsPrint
        'Print' => '打印',
        'No Element selected.' => '沒有元素被選中',

        # Template: AgentStatsView
        'Export Config' => '導出配置',
        'Information about the Stat' => '關於統計的信息',
        'Exchange Axis' => '轉換軸',
        'Configurable params of static stat' => '靜態統計的配置參數',
        'No element selected.' => '沒有被選參數',
        'maximal period from' => '最大周期表',
        'to' => '至',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '通過輸入和選擇字段，您可以按您的需求來配置統計。您可以修改編輯那些統計要素由您的統計資料管理員來設置。',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => '郵件必須有收件人!',
        'You need a email address (e. g. customer@example.com) in To:!' => '收件人信息必須是郵件地址(例如：customer@example.com)',
        'Bounce ticket' => '回退 Ticket ',
        'Ticket locked!' => 'Ticket 被鎖定!',
        'Ticket unlock!' => '解鎖 Ticket!',
        'Bounce to' => '回退到 ',
        'Next ticket state' => 'Tickets 狀態',
        'Inform sender' => '通知發送者',
        'Send mail!' => '發送!',

        # Template: AgentTicketBulk
        'You need to account time!' => '您需要記錄時間',
        'Ticket Bulk Action' => 'Ticket 批量處理',
        'Spell Check' => '拼寫檢查',
        'Note type' => '注釋類型',
        'Next state' => 'Ticket 狀態',
        'Pending date' => '待處理日期',
        'Merge to' => '合並到',
        'Merge to oldest' => '合並到最老的',
        'Link together' => '合並在一起',
        'Link to Parent' => '合並到上一級',
        'Unlock Tickets' => '解鎖 Tickets',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Ticket 的類型是必須的!',
        'A required field is:' => '必須的字段是',
        'Close ticket' => '關閉 Ticket',
        'Previous Owner' => '前一個所有者',
        'Inform Agent' => '通知技術支持人員',
        'Optional' => '選項',
        'Inform involved Agents' => '通知相關技術支持人員',
        'Attach' => '附件',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => '消息必須經過拼寫檢查!',
        'Compose answer for ticket' => '撰寫答復,Ticket 編號',
        'Pending Date' => '進入等待狀態日期',
        'for pending* states' => '針對等待狀態',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => '修改 Tickets 所屬客戶',
        'Set customer user and customer id of a ticket' => '設置 Ticket 所屬客戶用戶',
        'Customer User' => '客戶用戶',
        'Search Customer' => '搜索客戶',
        'Customer Data' => '客戶數據',
        'Customer history' => '客戶歷史情況',
        'All customer tickets.' => '該客戶所有 Tickets 記錄.',

        # Template: AgentTicketEmail
        'Compose Email' => '撰寫 Email',
        'new ticket' => '新建 Ticket',
        'Refresh' => '刷新',
        'Clear To' => '清空',
        'All Agents' => '所有技術支持人員',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => '文章類型',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => '修改 Ticket 額外信息',

        # Template: AgentTicketHistory
        'History of' => '歷史',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => '您需要使用一個 Ticket 編號!',
        'Ticket Merge' => 'Ticket 合並',

        # Template: AgentTicketMove
        'Move Ticket' => '移動 Ticket',

        # Template: AgentTicketNote
        'Add note to ticket' => '增加注解到 Ticket',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => '首次報告時間',
        'Service Time' => '服務時間',
        'Update Time' => '更新時間',
        'Solution Time' => '解決時間',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => '您至少需要選擇一個 Ticket!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => '過濾器',
        'Change search options' => '修改搜索選項',
        'Tickets' => '',
        'of' => '',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => '撰寫答復',
        'Contact customer' => '聯系客戶',
        'Change queue' => '改變隊列',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => '正序排序',
        'up' => '上',
        'sort downward' => '逆序排序',
        'down' => '下',
        'Escalation in' => '限時',
        'Locked' => '鎖定狀態',

        # Template: AgentTicketOwner
        'Change owner of ticket' => '修改 Ticket 所有者',

        # Template: AgentTicketPending
        'Set Pending' => '設置待處理狀態',

        # Template: AgentTicketPhone
        'Phone call' => '電話',
        'Clear From' => '重置',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => '純文本',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Ticket信息',
        'Accounted time' => '所用時間',
        'Linked-Object' => '已鏈接對象',
        'by' => '由',

        # Template: AgentTicketPriority
        'Change priority of ticket' => '調整 Ticket 優先級',

        # Template: AgentTicketQueue
        'Tickets shown' => '顯示 Ticket',
        'Tickets available' => '可用 Ticket',
        'All tickets' => '所有Ticket',
        'Queues' => '隊列',
        'Ticket escalation!' => 'Ticket 限時處理!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => '更改 Ticket 的負責人',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Ticket 搜索',
        'Profile' => '搜索約束條件',
        'Search-Template' => '搜索模板',
        'TicketFreeText' => 'Ticket 額外信息',
        'Created in Queue' => '在隊列裡建立',
        'Article Create Times' => '',
        'Article created' => '',
        'Article created between' => '',
        'Change Times' => '改變時間',
        'No change time settings.' => '不改變時間設置',
        'Ticket changed' => '',
        'Ticket changed between' => '',
        'Result Form' => '搜索結果顯示為',
        'Save Search-Profile as Template?' => '將搜索條件保存為模板',
        'Yes, save it with name' => '是, 保存為名稱',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => '全文',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => '展開',
        'Collapse View' => '折疊',
        'Split' => '分解',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Article 過濾設置',
        'Save filter settings as default' => '保存過濾設置為缺省值',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '追溯',

        # Template: CustomerFooter
        'Powered by' => '驅動方',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => '登錄',
        'Lost your password?' => '忘記密碼?',
        'Request new password' => '設置新密碼',
        'Create Account' => '創建帳戶',

        # Template: CustomerNavigationBar
        'Welcome %s' => '歡迎 %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => '時間',
        'No time settings.' => '無時間約束.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => '點擊這裡報告一個 Bug!',

        # Template: Footer
        'Top of Page' => '頁面頂端',

        # Template: FooterSmall

        # Template: Header
        'Home' => '',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'WEB 安裝向導',
        'Welcome to %s' => '歡迎使用 %s',
        'Accept license' => '同意許可',
        'Don\'t accept license' => '不同意',
        'Admin-User' => '管理員',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '如果您的數據庫有設置 root 密碼, 請在這裡輸入, 否則, 請保留空白. 出於安全考慮, 我們建議您為 root 設置一個密碼, 更多信息請參考數據庫幫助文檔.',
        'Admin-Password' => '管理員密碼',
        'Database-User' => '數據庫用戶名稱',
        'default \'hot\'' => '默認密碼 \'hot\'',
        'DB connect host' => '數據連接主機',
        'Database' => '數據庫',
        'Default Charset' => '缺省字符集',
        'utf8' => 'UTF-8',
        'false' => '假',
        'SystemID' => '系統ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(系統標識符. Ticket 編號和 http 會話都以這個標識符開頭)',
        'System FQDN' => '系統域名',
        '(Full qualified domain name of your system)' => '(系統域名)',
        'AdminEmail' => '管理員地址',
        '(Email of the system admin)' => '(系統管理員郵件地址)',
        'Organization' => '組織',
        'Log' => '日志',
        'LogModule' => '日志模塊',
        '(Used log backend)' => '使用日志后端',
        'Logfile' => '日志文件',
        '(Logfile just needed for File-LogModule!)' => '(隻有激活 File-LogModule 時才需要 Logfile!)',
        'Webfrontend' => 'Web 前端',
        'Use utf-8 it your database supports it!' => '如果您的數據庫支持，使用UTF-8字符編碼!',
        'Default Language' => '缺省語言',
        '(Used default language)' => '(使用缺省語言)',
        'CheckMXRecord' => '檢查 MX 記錄',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '通過撰寫答案來檢查用過的電子郵件地址的MX記錄。您OTRS機器在撥號接入的低速網絡裡，請不要使用CheckMXRecord!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '為了能夠使用OTRS, 您必須以root身份輸入以下行在命令行中(Terminal/Shell).',
        'Restart your webserver' => '請重新啟動您的 webserver.',
        'After doing so your OTRS is up and running.' => '完成后，您可以啟動 OTRS 系統了.',
        'Start page' => '開始頁面',
        'Your OTRS Team' => '您的 OTRS 小組.',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => '無權限',

        # Template: Notify
        'Important' => '重要',

        # Template: PrintFooter
        'URL' => '網址',

        # Template: PrintHeader
        'printed by' => '打印於',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: Test
        'OTRS Test Page' => 'OTRS 測試頁',
        'Counter' => '計數器',

        # Template: Warning

        # Misc
        'Edit Article' => '編輯信件',
        'Create Database' => '創建數據庫',
        'DB Host' => '數據庫主機',
        'Ticket Number Generator' => 'Ticket 編號生成器',
        'Create new Phone Ticket' => '創建新的電話 Ticket',
        'Symptom' => '症狀',
        'U' => '升序',
        'Site' => '站點',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_USERFIRSTNAME>)' => '',
        'Customer history search (e. g. "ID342425").' => '搜索客戶歷史 (例如： "ID342425").',
        'Can not delete link with %s!' => '不能刪除 %s 的連接',
        'for agent firstname' => '技術支持人員 名',
        'Close!' => '關閉!',
        'No means, send agent and customer notifications on changes.' => '當有改變時不發送通知給技術人員或客戶.',
        'A web calendar' => 'Web 日歷',
        'to get the realname of the sender (if given)' => '郵件發送人的真實姓名 (如果存在)',
        'OTRS DB Name' => '數據庫名稱',
        'Notification (Customer)' => '',
        'Select Source (for add)' => '選擇數據源(增加功能使用)',
        'Child-Object' => '子對象',
        'Days' => '天',
        'Queue ID' => '隊列編號',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => '配置選項 (例如: <OTRS_CONFIG_HttpType>)',
        'System History' => '系統歷史',
        'customer realname' => '客戶真實姓名',
        'Pending messages' => '消息轉入等待狀態',
        'for agent login' => '技術支持人員 登錄名',
        'Keyword' => '關鍵字',
        'Close type' => '關閉類型',
        'DB Admin User' => '數據庫管理員用戶名',
        'for agent user id' => '技術支持人員 用戶名',
        'Change user <-> group settings' => '修改 用戶 <-> 組 設置',
        'Problem' => '問題',
        'Escalation' => '調整',
        '"}' => '',
        'Order' => '次序',
        'next step' => '下一步',
        'Follow up' => '跟進',
        'Customer history search' => '客戶歷史搜索',
        'PostMaster Mail Account' => '郵件帳號管理',
        'Stat#' => '',
        'Create new database' => '創建新的數據庫',
        'Go' => '執行',
        'Keywords' => '關鍵字',
        'Ticket Escalation View' => '調整查看 Ticket',
        'Today' => '今天',
        'No * possible!' => '不可使用通配符 "*" !',
        'Load' => '加載',
        'PostMaster Filter' => '郵件內容過濾',
        'Message for new Owner' => '給所有者的消息',
        'to get the first 5 lines of the email' => '郵件正文前5行',
        'Sort by' => '排序',
        'OTRS DB Password' => 'OTRS 用戶密碼',
        'Last update' => '最后更新於',
        'Tomorrow' => '明天',
        'not rated' => '不予評級',
        'to get the first 20 character of the subject' => '郵件標題前20個字符',
        'Select the customeruser:service relations.' => '',
        'DB Admin Password' => '數據系統管理員密碼',
        'Drop Database' => '刪除數據庫',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '在這裡，您可以定義x軸。您可以選擇的一個因素通過單選按鈕。然后，你必須選擇該元素兩個或兩個以上的屬性。如果您不選擇任何屬性, 那麼當您生成一個統計的時候所有元素的屬性將被使用。並且一個新的屬性被更新到上次配置中',
        'FileManager' => '文件管理器',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => '當前客戶用戶信息 (例如: <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => '待處理類型',
        'Comment (internal)' => '注釋 (內部)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '可用的有關 Ticket 信息 (例如: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(使用 Ticket 編號格式)',
        'Reminder' => '提醒',
        'OTRS DB connect host' => 'OTRS 數據庫主機',
        'All Agent variables.' => '所有的技術人員變量',
        ' (work units)' => '工作單元',
        'Next Week' => '下周',
        'All Customer variables like defined in config option CustomerUser.' => '所有客戶變量可以在配置選項CustomerUser中定義',
        'for agent lastname' => '技術支持人員 名',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => '動作請求者信息 (例如: <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => '消息提醒',
        'Parent-Object' => '父對象',
        'Of couse this feature will take some system performance it self!' => '當然, 該功能會佔用一定的系統資源, 加重系統的負擔!',
        'Your own Ticket' => '您自己的 Ticket',
        'Detail' => '細節',
        'TicketZoom' => 'Ticket 展開',
        'Open Tickets' => '開放 Tickets',
        'Don\'t forget to add a new user to groups!' => '不要忘記增加新的用戶到組!',
        'General Catalog' => '總目錄',
        'CreateTicket' => '創建 Ticket',
        'You have to select two or more attributes from the select field!' => '你必須從所選字段中選擇兩個或兩個以上的屬性',
        'System Settings' => '數據庫設置 ',
        'Finished' => '完成',
        'D' => '降序',
        'All messages' => '所有消息',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Object already linked as %s.' => '對象已連接到 %s.',
        'A article should have a title!' => '文章必須有標題!',
        'Customer Users <-> Services' => '客戶帳號 <-> 服務管理',
        'All email addresses get excluded on replaying on composing and email.' => '所有被取消撰寫郵件功能的郵件地址',
        'A web mail client' => 'WebMail 客戶端',
        'Compose Follow up' => '撰寫跟蹤答復',
        'WebMail' => 'WebMail',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Ticket 所有者選項 (例如: <OTRS_OWNER_UserFirstname>)',
        'DB Type' => '數據庫類型',
        'kill all sessions' => '中止所有會話',
        'to get the from line of the email' => '郵件來自',
        'Solution' => '解決方案',
        'QueueView' => '隊列視圖',
        'My Queue' => '我的隊列',
        'Select Box' => '選擇方框',
        'New messages' => '新消息',
        'Ticket owner options (e. g. <OTRS_OWNER_USERFIRSTNAME>)' => '可用的 Ticket 歸屬人信息 (例如: <OTRS_OWNER_USERFIRSTNAME>)',
        'Can not create link with %s!' => '不能為 %s 創建連接',
        'Linked as' => '已連接為',
        'modified' => '修改於',
        'Delete old database' => '刪除舊數據庫',
        'A web file manager' => 'Web 文件管理器',
        'Have a lot of fun!' => 'Have a lot of fun!',
        'send' => '發送',
        'QuickSearch' => '快速搜索',
        'Send no notifications' => '不發送通知',
        'Note Text' => '注解',
        'POP3 Account Management' => 'POP3 帳戶管理',
        'System State Management' => '系統狀態管理',
        'OTRS DB User' => 'OTRS 數據庫用戶名',
        'Mailbox' => '郵箱',
        'PhoneView' => '電話視圖',
        'maximal period form' => '最大周期表',
        'Escaladed Tickets' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_USERFIRSTNAME>)' => '',
        'Yes means, send no agent and customer notifications on changes.' => '當有改變時不發送通知給技術人員或客戶.',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => '您的郵件 編號: "<OTRS_TICKET>" 回退到 "<OTRS_BOUNCE_TO>" . 請聯系以下地址獲取詳細信息.',
        'Ticket Status View' => 'Ticket 狀態視圖',
        'Modified' => '修改於',
        'Ticket selected for bulk action!' => '被選中進行批量操作的 Tickets',
    };
    # $$STOP$$
    return;
}

1;
