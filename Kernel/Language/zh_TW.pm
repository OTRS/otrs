# --
# Kernel/Language/zh_TW.pm - provides Chinese Traditional language translation
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

    # csv separator
    $Self->{Separator} = '';

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
        'more than ... ago' => '...之前',
        'in more than ...' => '...內',
        'within the last ...' => '在過去的...',
        'within the next ...' => '在接下來的...',
        'Created within the last' => '在過去的...創建',
        'Created more than ... ago' => '在...之前創建',
        'Today' => '今天',
        'Tomorrow' => '明天',
        'Next week' => '下週',
        'day' => '天',
        'days' => '天',
        'day(s)' => '天',
        'd' => '天',
        'hour' => '小時',
        'hours' => '小時',
        'hour(s)' => '小時',
        'Hours' => '小時',
        'h' => '時',
        'minute' => '分鐘',
        'minutes' => '分鐘',
        'minute(s)' => '分鐘',
        'Minutes' => '分鐘',
        'm' => '分',
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
        's' => '秒',
        'Time unit' => '時間單位',
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
        'Example' => '範例',
        'Examples' => '範例',
        'valid' => '有效',
        'Valid' => '有效',
        'invalid' => '無效',
        'Invalid' => '無效',
        '* invalid' => '* 無效',
        'invalid-temporarily' => '暫時無效',
        ' 2 minutes' => ' 2 分鐘',
        ' 5 minutes' => ' 5 分鐘',
        ' 7 minutes' => ' 7 分鐘',
        '10 minutes' => '10 分鐘',
        '15 minutes' => '15 分鐘',
        'Mr.' => '先生',
        'Mrs.' => '女士',
        'Next' => '下一步',
        'Back' => '上一步',
        'Next...' => '下一步...',
        '...Back' => '...上一步',
        '-none-' => '-無-',
        'none' => '無',
        'none!' => '無!',
        'none - answered' => '無 - 已答復的',
        'please do not edit!' => '不要編輯!',
        'Need Action' => '需要操作',
        'AddLink' => '增加鏈接',
        'Link' => '鏈接',
        'Unlink' => '未鏈接',
        'Linked' => '已鏈接',
        'Link (Normal)' => '鏈接(普通)',
        'Link (Parent)' => '鏈接(父)',
        'Link (Child)' => '鏈接(子)',
        'Normal' => '普通',
        'Parent' => '父',
        'Child' => '子',
        'Hit' => '點擊',
        'Hits' => '點擊數',
        'Text' => '正文',
        'Standard' => '標準',
        'Lite' => '簡潔',
        'User' => '用戶',
        'Username' => '用戶名',
        'Language' => '語言',
        'Languages' => '語言',
        'Password' => '密碼',
        'Preferences' => '首選項',
        'Salutation' => '回復抬頭',
        'Salutations' => '回復抬頭',
        'Signature' => '回復簽名',
        'Signatures' => '回復簽名',
        'Customer' => '用戶單位',
        'CustomerID' => '單位編號',
        'CustomerIDs' => '單位編號',
        'customer' => '用戶單位',
        'agent' => '服務人員',
        'system' => '系統',
        'Customer Info' => '用戶信息',
        'Customer Information' => '用戶信息',
        'Customer Company' => '用戶單位',
        'Customer Companies' => '用戶單位',
        'Company' => '單位',
        'go!' => '開始!',
        'go' => '開始',
        'All' => '全部',
        'all' => '全部',
        'Sorry' => '對不起',
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
        'click here' => '點擊這裡',
        'Comment' => '註釋',
        'Invalid Option!' => '無效選項!',
        'Invalid time!' => '無效時間!',
        'Invalid date!' => '無效日期!',
        'Name' => '名稱',
        'Group' => '組',
        'Description' => '描述',
        'description' => '描述',
        'Theme' => '主題',
        'Created' => '創建於',
        'Created by' => '創建人',
        'Changed' => '修改於',
        'Changed by' => '修改人',
        'Search' => '搜索',
        'and' => '及',
        'between' => '絕對',
        'before/after' => '相對',
        'Fulltext Search' => '',
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
        'Add' => '添加',
        'Added!' => '已添加!',
        'Category' => '類别',
        'Viewer' => '查看器',
        'Expand' => '展開',
        'Small' => '簡潔',
        'Medium' => '基本',
        'Large' => '詳細',
        'Date picker' => '日期選擇器',
        'Show Tree Selection' => '',
        'The field content is too long!' => '',
        'Maximum size is %s characters.' => '',
        'This field is required or' => '',
        'New message' => '新消息',
        'New message!' => '新消息!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            '請答復工單，然後返回到隊列概況!',
        'You have %s new message(s)!' => '您有%s條新消息!',
        'You have %s reminder ticket(s)!' => '您有%s個工單提醒!',
        'The recommended charset for your language is %s!' => '推薦的語言的字符集是%s!',
        'Change your password.' => '更換您的密碼。',
        'Please activate %s first!' => '請首先激活%s！',
        'No suggestions' => '無建議',
        'Word' => '字',
        'Ignore' => '忽略',
        'replace with' => '替換',
        'There is no account with that login name.' => '該用戶名沒有帳戶信息。',
        'Login failed! Your user name or password was entered incorrectly.' =>
            '登錄失敗！用戶名或密碼錯誤。',
        'There is no acount with that user name.' => '沒有此用戶。',
        'Please contact your administrator' => '請聯繫管理員',
        'Logout' => '退出',
        'Logout successful. Thank you for using %s!' => '成功退出，謝謝使用!',
        'Feature not active!' => '該功能尚未激活!',
        'Agent updated!' => '服務人員已更新！',
        'Database Selection' => '數據庫選擇',
        'Create Database' => '創建數據庫',
        'System Settings' => '數據庫設置 ',
        'Mail Configuration' => '郵件配置',
        'Finished' => '完成',
        'Install OTRS' => '安裝OTRS',
        'Intro' => '介紹',
        'License' => '許可証',
        'Database' => '數據庫',
        'Configure Mail' => '配置郵件',
        'Database deleted.' => '數據庫已刪除。',
        'Enter the password for the administrative database user.' => '輸入數據庫管理員密碼。',
        'Enter the password for the database user.' => '輸入數據庫用戶密碼。',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '如果您的數據庫為root設置了密碼，您必須在這裡輸入；否則，該字段為空。',
        'Database already contains data - it should be empty!' => '數據庫中已包含數據 - 應該刪除它！',
        'Login is needed!' => '需要先登錄!',
        'Password is needed!' => '需要密碼!',
        'Take this Customer' => '取得這個用戶',
        'Take this User' => '取得這個用戶',
        'possible' => '可能',
        'reject' => '拒絕',
        'reverse' => '倒序',
        'Facility' => '設施',
        'Time Zone' => '時區',
        'Pending till' => '掛起至',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '不要使用OTRS系統缺省帳號! 請創建新的服務人員帳號。',
        'Dispatching by email To: field.' => '按收件人(To:)分派.',
        'Dispatching by selected Queue.' => '按所選隊列分派.',
        'No entry found!' => '無内容!',
        'Session invalid. Please log in again.' => '會話無效，請重新登錄.',
        'Session has timed out. Please log in again.' => '會話超時，請重新登錄.',
        'Session limit reached! Please try again later.' => '超過會話數量，請稍後再試.',
        'No Permission!' => '無權限!',
        '(Click here to add)' => '(點擊此處添加)',
        'Preview' => '預覽',
        'Package not correctly deployed! Please reinstall the package.' =>
            '軟件包未正確安裝！請重新安裝軟件包。',
        '%s is not writable!' => '%s不可寫的!',
        'Cannot create %s!' => '無法創建%s!',
        'Check to activate this date' => '選中它，以便設置這個日期',
        'You have Out of Office enabled, would you like to disable it?' =>
            '您已設置為不在辦公室，是否取消它?',
        'Customer %s added' => '用戶%s已添加',
        'Role added!' => '角色已添加！',
        'Role updated!' => '角色已更新！',
        'Attachment added!' => '附件已添加！',
        'Attachment updated!' => '附件已更新！',
        'Response added!' => '回復已添加！',
        'Response updated!' => '回復已更新！',
        'Group updated!' => '組已更新！',
        'Queue added!' => '隊列已添加！',
        'Queue updated!' => '隊列已更新！',
        'State added!' => '狀態已添加！',
        'State updated!' => '狀態已更新！',
        'Type added!' => '類型已添加！',
        'Type updated!' => '類型已更新！',
        'Customer updated!' => '用戶已更新！',
        'Customer company added!' => '用戶單位已添加！',
        'Customer company updated!' => '用戶單位已更新！',
        'Note: Company is invalid!' => '注意：單位無效！',
        'Mail account added!' => '郵件帳號已添加！',
        'Mail account updated!' => '郵件帳號已更新！',
        'System e-mail address added!' => '系統郵件地址已添加！',
        'System e-mail address updated!' => '系統郵件地址已更新！',
        'Contract' => '合同',
        'Online Customer: %s' => '在綫用戶: %s',
        'Online Agent: %s' => '在綫服務人員：%s',
        'Calendar' => '日曆',
        'File' => '文件',
        'Filename' => '文件名稱',
        'Type' => '類型',
        'Size' => '大小',
        'Upload' => '上傳',
        'Directory' => '目錄',
        'Signed' => '已簽名',
        'Sign' => '簽名',
        'Crypted' => '已加密',
        'Crypt' => '加密',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP密鑰',
        'PGP Keys' => 'PGP密鑰',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME証書',
        'S/MIME Certificates' => 'S/MIME証書',
        'Office' => '辦公室',
        'Phone' => '電話',
        'Fax' => '傳真',
        'Mobile' => '手機',
        'Zip' => '郵編',
        'City' => '城市',
        'Street' => '街道',
        'Country' => '國家',
        'Location' => '位置',
        'installed' => '已安裝',
        'uninstalled' => '未安裝',
        'Security Note: You should activate %s because application is already running!' =>
            '安全提示: %s無法激活, 因為此應用已經正在運行!',
        'Unable to parse repository index document.' => '無法解釋軟件倉庫索引文檔',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '軟件倉庫中沒有當前系統版本可用的軟件包。',
        'No packages, or no new packages, found in selected repository.' =>
            '所選的軟件倉庫中沒有需要安裝的軟件包。',
        'Edit the system configuration settings.' => '編輯系統配置。',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '數據庫中的ACL信息與系統配置不一致，請部署所有ACL。',
        'printed at' => '打印日期',
        'Loading...' => '加載中...',
        'Dear Mr. %s,' => '尊敬的%s先生:',
        'Dear Mrs. %s,' => '尊敬的%s女士:',
        'Dear %s,' => '尊敬的%s:',
        'Hello %s,' => '您好, %s:',
        'This email address already exists. Please log in or reset your password.' =>
            '郵件地址已存在，請登錄或重新初始化密碼。',
        'New account created. Sent login information to %s. Please check your email.' =>
            '帳戶創建成功。登錄信息發送到%s，請查收郵件。',
        'Please press Back and try again.' => '請返回再試一次。',
        'Sent password reset instructions. Please check your email.' => '密碼初始化說明已發送，請檢查郵件。',
        'Sent new password to %s. Please check your email.' => '新密碼已發送到%s，請檢查郵件。',
        'Upcoming Events' => '即將發生的事件',
        'Event' => '事件',
        'Events' => '事件',
        'Invalid Token!' => '無效的標記',
        'more' => '更多',
        'Collapse' => '收起',
        'Shown' => '顯示',
        'Shown customer users' => '顯示用戶',
        'News' => '新聞',
        'Product News' => '產品新聞',
        'OTRS News' => 'OTRS新聞',
        '7 Day Stats' => '最近7天統計',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '數據庫中的流程管理信息與系統配置不一致，請同步所有流程。',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '擴展包未經OTRS檢驗！不推薦使用該擴展包.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>如果安裝這個擴展包，可能導致以下問題！<br><br>&nbsp;-安全問題<br>&nbsp;-穩定問題<br>&nbsp;-性能問題<br><br>由此導致的問題與OTRS服務合同無關！<br><br>',
        'Mark' => '標記',
        'Unmark' => '取消標記',
        'Bold' => '粗體',
        'Italic' => '斜體',
        'Underline' => '底綫',
        'Font Color' => '字型顏色',
        'Background Color' => '背景顏色',
        'Remove Formatting' => '刪除格式',
        'Show/Hide Hidden Elements' => '顯示/隱藏 隱藏要素',
        'Align Left' => '左對齊',
        'Align Center' => '置中對齊',
        'Align Right' => '右對齊',
        'Justify' => '對齊',
        'Header' => '信息頭',
        'Indent' => '增加縮進',
        'Outdent' => '減少縮進',
        'Create an Unordered List' => '創建一個無序列表',
        'Create an Ordered List' => '創建一個有序列表',
        'HTML Link' => 'HTML鏈接',
        'Insert Image' => '插入圖像',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => '復原',
        'Redo' => '重做',
        'Scheduler process is registered but might not be running.' => '調度程序已註冊，但可能沒有運行。',
        'Scheduler is not running.' => '調度程序沒有運行。',
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Problems processing server result. Please try again later.' => '',
        'Username and password do not match. Please try again.' => '',
        'The selected process is invalid!' => '',

        # Template: AAACalendar
        'New Year\'s Day' => '元旦',
        'International Workers\' Day' => '勞動節',
        'Christmas Eve' => '平安夜',
        'First Christmas Day' => '聖誕節',
        'Second Christmas Day' => '聖誕節後第一個周日',
        'New Year\'s Eve' => '除夕',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS作為服務請求方',
        'OTRS as provider' => 'OTRS作為服務提供方',
        'Webservice "%s" created!' => 'Web服務"%s"已創建！',
        'Webservice "%s" updated!' => 'Web服務"%s"已更新！',

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
        'Preferences updated successfully!' => '設置更新成功！',
        'User Profile' => '用戶資料',
        'Email Settings' => '郵件設置',
        'Other Settings' => '其它設置',
        'Change Password' => '修改密碼',
        'Current password' => '當前密碼',
        'New password' => '新密碼',
        'Verify password' => '重複新密碼',
        'Spelling Dictionary' => '拼寫檢查字典',
        'Default spelling dictionary' => '默認字典',
        'Max. shown Tickets a page in Overview.' => '單頁最大工單數。',
        'The current password is not correct. Please try again!' => '當前密碼不正確，請重新輸入！',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            '無法更改密碼。新密碼不一致，請重新輸入！',
        'Can\'t update password, it contains invalid characters!' => '無法更改密碼，密碼不能包含非法字符！',
        'Can\'t update password, it must be at least %s characters long!' =>
            '無法更改密碼，密碼至少需要%s個字符！',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            '無法更改密碼，密碼必須包含至少2個小寫和2個大寫字符！',
        'Can\'t update password, it must contain at least 1 digit!' => '無法更改密碼，密碼至少需要1個數字字符！',
        'Can\'t update password, it must contain at least 2 characters!' =>
            '無法更改密碼，密碼至少需要2個字符！',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            '無法更改密碼，該密碼已被使用。請選擇一個新密碼！',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '選擇CSV文件（統計和搜索）中使用的分隔符。如果不指定，系統將使用默認分隔符。',
        'CSV Separator' => 'CSV分隔符',

        # Template: AAAStats
        'Stat' => '統計',
        'Sum' => '總和',
        'No (not supported)' => '不支持',
        'Please fill out the required fields!' => '請填寫必填字段',
        'Please select a file!' => '請選擇一個文件！',
        'Please select an object!' => '請選擇一個對象！',
        'Please select a graph size!' => '請選擇圖片尺寸！',
        'Please select one element for the X-axis!' => '請為X軸選擇一個元素',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            '請只選擇一個元素或關閉選中字段的\'Fixed\'按鈕',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            '如果使用複選框，必須選擇選中字段的部分屬性！',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            '請在選中的輸入框中輸入一個值，或關閉\'Fixed\'複選框！',
        'The selected end time is before the start time!' => '選擇的結束時間早於開始時間！',
        'You have to select one or more attributes from the select field!' =>
            '必須為選中的字段選擇一個或多個屬性！',
        'The selected Date isn\'t valid!' => '選擇的日期無效',
        'Please select only one or two elements via the checkbox!' => '請通過複選框選擇一個或兩個要素！',
        'If you use a time scale element you can only select one element!' =>
            '如果使用時間尺度要素，只能選擇其中一個',
        'You have an error in your time selection!' => '選擇時間錯誤！',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            '報告時間間隔太短，請使用更長的間隔！',
        'The selected start time is before the allowed start time!' => '選擇的開始時間早於允許的開始時間！',
        'The selected end time is after the allowed end time!' => '選擇的結束時間晚於允許的結束時間！',
        'The selected time period is larger than the allowed time period!' =>
            '選擇時間段大於允許的時間段！',
        'Common Specification' => '一般規範',
        'X-axis' => 'X軸',
        'Value Series' => '值系列',
        'Restrictions' => '限制條件',
        'graph-lines' => '綫圖',
        'graph-bars' => '柱狀圖',
        'graph-hbars' => 'H柱狀圖',
        'graph-points' => '圖點',
        'graph-lines-points' => '圖綫點',
        'graph-area' => '區圖',
        'graph-pie' => '餅圖',
        'extended' => '擴展',
        'Agent/Owner' => '服務人員/所有者',
        'Created by Agent/Owner' => '創建人',
        'Created Priority' => '創建的優先級',
        'Created State' => '創建的狀態',
        'Create Time' => '創建時間',
        'CustomerUserLogin' => '用戶登陸',
        'Close Time' => '關閉時間',
        'TicketAccumulation' => '工單累計',
        'Attributes to be printed' => '打印的屬性',
        'Sort sequence' => '排序',
        'Order by' => '排序',
        'Limit' => '限制',
        'Ticketlist' => '工單清單',
        'ascending' => '升序',
        'descending' => '降序',
        'First Lock' => '首次鎖定',
        'Evaluation by' => '評估方法',
        'Total Time' => '時間總合',
        'Ticket Average' => '工單平均處理時間',
        'Ticket Min Time' => '工單最小處理時間',
        'Ticket Max Time' => '工單最大處理時間',
        'Number of Tickets' => '工單數',
        'Article Average' => '信件平均處理時間',
        'Article Min Time' => '信件最小處理時間',
        'Article Max Time' => '信件最大處理時間',
        'Number of Articles' => '信件數',
        'Accounted time by Agent' => '服務人員處理工單所用的時間',
        'Ticket/Article Accounted Time' => '工單/信件所佔用的時間',
        'TicketAccountedTime' => '工單所佔用的時間',
        'Ticket Create Time' => '工單創建時間',
        'Ticket Close Time' => '工單關閉時間',

        # Template: AAATicket
        'Status View' => '狀態視圖',
        'Bulk' => '批量',
        'Lock' => '鎖定',
        'Unlock' => '解鎖',
        'History' => '歷史',
        'Zoom' => '展開',
        'Age' => '總時長',
        'Bounce' => '退回',
        'Forward' => '轉發',
        'From' => '發件人',
        'To' => '收件人',
        'Cc' => '抄送',
        'Bcc' => '暗送',
        'Subject' => '主題',
        'Move' => '轉移',
        'Queue' => '隊列',
        'Queues' => '隊列',
        'Priority' => '優先級',
        'Priorities' => '優先級',
        'Priority Update' => '更新優先級',
        'Priority added!' => '優先級已添加!',
        'Priority updated!' => '優先級已更新!',
        'Signature added!' => '簽名已添加!',
        'Signature updated!' => '簽名已更新!',
        'SLA' => 'SLA',
        'Service Level Agreement' => '服務水平協議',
        'Service Level Agreements' => '服務水平協議',
        'Service' => '服務',
        'Services' => '服務',
        'State' => '狀態',
        'States' => '狀態',
        'Status' => '狀態',
        'Statuses' => '狀態',
        'Ticket Type' => '工單類型',
        'Ticket Types' => '工單類型',
        'Compose' => '撰寫',
        'Pending' => '掛起',
        'Owner' => '所有者',
        'Owner Update' => '更改所有者',
        'Responsible' => '負責人',
        'Responsible Update' => '更新負責人',
        'Sender' => '發件人',
        'Article' => '信件',
        'Ticket' => '工單',
        'Createtime' => '創建時間',
        'plain' => '純文本',
        'Email' => '郵件地址',
        'email' => 'E-Mail',
        'Close' => '關閉',
        'Action' => '操作',
        'Attachment' => '附件',
        'Attachments' => '附件',
        'This message was written in a character set other than your own.' =>
            '這封郵件所用字符集與您的系統字符集不符',
        'If it is not displayed correctly,' => '如果沒有給正確地顯示,',
        'This is a' => '這是一個',
        'to open it in a new window.' => '在新窗口中打開它',
        'This is a HTML email. Click here to show it.' => '這是一封HTML格式郵件，點擊這裡顯示.',
        'Free Fields' => '自定義字段',
        'Merge' => '合併',
        'merged' => '已合併',
        'closed successful' => '成功關閉',
        'closed unsuccessful' => '失敗關閉',
        'Locked Tickets Total' => '鎖定工單總數',
        'Locked Tickets Reminder Reached' => '鎖定工單(提醒時間已過)',
        'Locked Tickets New' => '鎖定工單(未讀信件)',
        'Responsible Tickets Total' => '負責工單總數',
        'Responsible Tickets New' => '負責的工單(未讀信件)',
        'Responsible Tickets Reminder Reached' => '負責的工單(提醒時間已過)',
        'Watched Tickets Total' => '訂閱工單總數',
        'Watched Tickets New' => '訂閱工單(未讀信件)',
        'Watched Tickets Reminder Reached' => '訂閱工單(提醒時間已過)',
        'All tickets' => '所有工單',
        'Available tickets' => '未鎖定的工單',
        'Escalation' => '升級',
        'last-search' => '上次搜索',
        'QueueView' => '隊列視圖',
        'Ticket Escalation View' => '工單升級視圖',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => '新建',
        'open' => '處理中',
        'Open' => '處理中',
        'Open tickets' => '處理中的工單',
        'closed' => '已關閉',
        'Closed' => '已關閉',
        'Closed tickets' => '已關閉的工單',
        'removed' => '已刪除',
        'pending reminder' => '掛起提醒',
        'pending auto' => '自動掛起',
        'pending auto close+' => '掛起自動關閉+',
        'pending auto close-' => '掛起自動關閉-',
        'email-external' => ' (郵件-外部)',
        'email-internal' => ' (郵件-内部)',
        'note-external' => ' (備註-外部)',
        'note-internal' => ' (備註-内部)',
        'note-report' => ' (備註-報告)',
        'phone' => ' (電話)',
        'sms' => ' (短信)',
        'webrequest' => ' (Web請求)',
        'lock' => '鎖定',
        'unlock' => '未鎖定',
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
        'auto follow up' => '自動跟進',
        'auto reject' => '自動拒絕',
        'auto remove' => '自動刪除',
        'auto reply' => '自動回復',
        'auto reply/new ticket' => '自動回復新工單',
        'Create' => '創建',
        'Answer' => '回復',
        'Phone call' => '電話',
        'Ticket "%s" created!' => '工單："%s"已創建!',
        'Ticket Number' => '工單編號',
        'Ticket Object' => '工單對象',
        'No such Ticket Number "%s"! Can\'t link it!' => '編號為"%s"的工單不存在，不能鏈接!',
        'You don\'t have write access to this ticket.' => '您不具有此工單的寫權限',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '只有工單的所有者才能執行此操作。',
        'Please change the owner first.' => '請先更改工單的所有者.',
        'Ticket selected.' => '工單已被選中.',
        'Ticket is locked by another agent.' => '工單被其它服務人員鎖定了',
        'Ticket locked.' => '工單已鎖定.',
        'Don\'t show closed Tickets' => '不顯示已關閉的工單',
        'Show closed Tickets' => '顯示已關閉的工單',
        'New Article' => '新信件',
        'Unread article(s) available' => '未讀信件',
        'Remove from list of watched tickets' => '取消訂閱此工單',
        'Add to list of watched tickets' => '訂閱此工單',
        'Email-Ticket' => '郵件工單',
        'Create new Email Ticket' => '創建郵件工單',
        'Phone-Ticket' => '電話工單',
        'Search Tickets' => '搜索工單',
        'Edit Customer Users' => '編輯用戶帳戶',
        'Edit Customer Company' => '編輯用戶單位',
        'Bulk Action' => '批量處理',
        'Bulk Actions on Tickets' => '批量處理工單',
        'Send Email and create a new Ticket' => '發送郵件並創建新工單',
        'Create new Email Ticket and send this out (Outbound)' => '創建郵件工單(主動)',
        'Create new Phone Ticket (Inbound)' => '創建電話工單(接電話)',
        'Address %s replaced with registered customer address.' => '%s地址已被用戶註冊的地址所替換',
        'Customer user automatically added in Cc.' => '用戶被自動地添加到Cc中.',
        'Overview of all open Tickets' => '所有處理中的工單',
        'Locked Tickets' => '鎖定的工單',
        'My Locked Tickets' => '我鎖定的工單',
        'My Watched Tickets' => '我訂閱的工單',
        'My Responsible Tickets' => '我負責的工單',
        'Watched Tickets' => '訂閱的工單',
        'Watched' => '已訂閱',
        'Watch' => '訂閱',
        'Unwatch' => '取消訂閱',
        'Lock it to work on it' => '鎖定並處理工單',
        'Unlock to give it back to the queue' => '解鎖並釋放工單至隊列',
        'Show the ticket history' => '顯示工單歷史信息',
        'Print this ticket' => '打印工單',
        'Print this article' => '打印信件',
        'Split' => '拆分',
        'Split this article' => '拆分信件',
        'Forward article via mail' => '通過郵件轉發信件',
        'Change the ticket priority' => '更改工單優先級',
        'Change the ticket free fields!' => '修改自定義字段',
        'Link this ticket to other objects' => '將工單鏈接至其它對象',
        'Change the owner for this ticket' => '更改工單所有者',
        'Change the  customer for this ticket' => '更改工單用戶',
        'Add a note to this ticket' => '添加工單備註',
        'Merge into a different ticket' => '合併至其它工單',
        'Set this ticket to pending' => '掛起工單',
        'Close this ticket' => '關閉工單',
        'Look into a ticket!' => '查看工單内容',
        'Delete this ticket' => '刪除工單',
        'Mark as Spam!' => '標記為垃圾!',
        'My Queues' => '我的隊列',
        'Shown Tickets' => '顯示工單',
        'Shown Columns' => '顯示字段',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            '您的單號為"<OTRS_TICKET>"的郵件工單 被合併到單號"<OTRS_MERGE_TO_TICKET>" !',
        'Ticket %s: first response time is over (%s)!' => '工單%s：第一響應時間已超過(%s)!',
        'Ticket %s: first response time will be over in %s!' => '工單%s: 第一響應時間將在(%s)内超時!',
        'Ticket %s: update time is over (%s)!' => '工單%s: 更新時間已超過(%s)!',
        'Ticket %s: update time will be over in %s!' => '工單%s: 更新時間將在(%s)内超時!',
        'Ticket %s: solution time is over (%s)!' => '工單%s: 解決時間已超過(%s)!',
        'Ticket %s: solution time will be over in %s!' => '解決時間將在(%s)内超時!',
        'There are more escalated tickets!' => '有更多升級的工單',
        'Plain Format' => '純文本格式',
        'Reply All' => '回復所有',
        'Direction' => '方向',
        'Agent (All with write permissions)' => '服務人員（具有寫權限）',
        'Agent (Owner)' => '服務人員（所有者）',
        'Agent (Responsible)' => '服務人員（負責人）',
        'New ticket notification' => '新工單通知',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            '如果我的隊列中有新的工單，請通知我。',
        'Send new ticket notifications' => '發送新工單通知',
        'Ticket follow up notification' => '工單跟進通知',
        'Ticket lock timeout notification' => '工單鎖定超時通知',
        'Send me a notification if a ticket is unlocked by the system.' =>
            '如果工單被系統解鎖，請通知我。',
        'Send ticket lock timeout notifications' => '發送工單鎖定超時間通知',
        'Ticket move notification' => '工單轉移通知',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            '如果工單轉移至我的隊列，請通知我。',
        'Send ticket move notifications' => '發送工單隊列轉移通知',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => '用戶隊列',
        'QueueView refresh time' => '隊列視圖刷新頻率',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            '如果啟用此功能, 隊列視圖會自動在指定時間内自動刷新.',
        'Refresh QueueView after' => '隊列視圖多久後刷新',
        'Screen after new ticket' => '創建新工單後的視圖',
        'Show this screen after I created a new ticket' => '創建新工單後的顯示頁面',
        'Closed Tickets' => '關閉的工單',
        'Show closed tickets.' => '顯示已關閉工單',
        'Max. shown Tickets a page in QueueView.' => '隊列視圖每頁最大顯示數',
        'Ticket Overview "Small" Limit' => '工單概覽“小”模式限制',
        'Ticket limit per page for Ticket Overview "Small"' => '工單概覽“小”模式每頁數量',
        'Ticket Overview "Medium" Limit' => '工單概覽“中”模式限制',
        'Ticket limit per page for Ticket Overview "Medium"' => '工單概覽“中”模式每頁數量',
        'Ticket Overview "Preview" Limit' => '工單概覽“預覽”模式限制',
        'Ticket limit per page for Ticket Overview "Preview"' => '工單概覽“預覽”模式每頁數量',
        'Ticket watch notification' => '工單訂閱通知',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            '對於我所訂閱的工單，請給我發送與工單所有者一樣通知.',
        'Send ticket watch notifications' => '發送工單訂閱通知',
        'Out Of Office Time' => '不在辦公室的時間',
        'New Ticket' => '新的工單',
        'Create new Ticket' => '創建工單',
        'Customer called' => '用戶致電',
        'phone call' => '電話呼叫',
        'Phone Call Outbound' => '打電話',
        'Phone Call Inbound' => '接電話',
        'Reminder Reached' => '提醒時間已過',
        'Reminder Tickets' => '提醒的工單',
        'Escalated Tickets' => '升級的工單',
        'New Tickets' => '新的工單',
        'Open Tickets / Need to be answered' => '正在處理/需要回復的工單',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            '所有正在處理中且需要回復的工單',
        'All new tickets, these tickets have not been worked on yet' => '所有新建工單，這些工單目前還沒有被處理',
        'All escalated tickets' => '所有升級的工單',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '所有提醒時間已過的工單',
        'Archived tickets' => '歸檔的工單',
        'Unarchived tickets' => '未歸檔的工單',
        'Ticket Information' => '工單信息',
        'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'FollowUp for [%s]. %s',
        'History::SendAutoReject' => 'AutoReject sent to "%s".',
        'History::SendAutoReply' => 'AutoReply sent to "%s".',
        'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
        'History::Forward' => 'Forwarded to "%s".',
        'History::Bounce' => 'Bounced to "%s".',
        'History::SendAnswer' => 'Email sent to "%s".',
        'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
        'History::SendCustomerNotification' => 'Notification sent to "%s".',
        'History::EmailAgent' => 'Email sent to customer.',
        'History::EmailCustomer' => 'Added email. %s',
        'History::PhoneCallAgent' => 'Agent called customer.',
        'History::PhoneCallCustomer' => 'Customer called us.',
        'History::AddNote' => 'Added note (%s)',
        'History::Lock' => 'Locked ticket.',
        'History::Unlock' => 'Unlocked ticket.',
        'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Updated: %s',
        'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
        'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Updated: %s',
        'History::StateUpdate' => 'Old: "%s" New: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Updated: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Customer request via web.',
        'History::TicketLinkAdd' => 'Added link to ticket "%s".',
        'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',
        'History::SystemRequest' => 'System Request (%s).',
        'History::ResponsibleUpdate' => 'Archive state changed: "%s"',
        'History::ArchiveFlagUpdate' => '',
        'History::TicketTitleUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => '',
        'Mon' => '',
        'Tue' => '',
        'Wed' => '',
        'Thu' => '',
        'Fri' => '',
        'Sat' => '',

        # Template: AdminACL
        'ACL Management' => 'ACL管理',
        'Filter for ACLs' => '過濾ACL',
        'Filter' => '過濾器',
        'ACL Name' => 'ACL名稱',
        'Actions' => '操作',
        'Create New ACL' => '創建ACL',
        'Deploy ACLs' => '部署ACL',
        'Export ACLs' => '導出ACL',
        'Configuration import' => '導入ACL',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '您可以上傳配置文件，以便將ACL導入至系統中。配置文件採用.yml格式，它可以從ACL管理模塊中導出。',
        'This field is required.' => '該字段是必須的。',
        'Overwrite existing ACLs?' => '覆蓋ACL',
        'Upload ACL configuration' => '上傳ACL配置',
        'Import ACL configuration(s)' => '導入ACL配置',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '為了創建ACL，您可以導入ACL配置或從頭創建一個全新的ACL。',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '在這裡的任何ACL的修改，僅將其保存在系統中。只有在部署ACL後，它才會起作用。',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '註意：列表中的ACL名稱排序順序決定了ACL的執行順序。如果需要更改ACL的執行順序，請修改相應的ACL名稱。',
        'ACL name' => 'ACL名稱',
        'Validity' => '有效性',
        'Copy' => '複製',
        'No data found.' => '沒有找到數據。',

        # Template: AdminACLEdit
        'Edit ACL %s' => '編輯ACL %s',
        'Go to overview' => '返回概覽',
        'Delete ACL' => '刪除ACL',
        'Delete Invalid ACL' => '刪除無效的ACL',
        'Match settings' => '匹配條件',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '為ACL設置匹配條件。\'Properties\'用於匹配工單在内存中的屬性\'，而\'PropertiesDatabase\'用於匹配工單在數據庫中的屬性。',
        'Change settings' => '操作動作',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '當匹配條件滿足時執行規定的操作動作。記住：\'Possible\'表示允許(白名單)，\'PossibleNot\'表示禁止(黑名單)。',
        'Check the official' => '查看官方',
        'documentation' => '手冊',
        'Show or hide the content' => '顯示或隱藏内容',
        'Edit ACL information' => '編輯ACL信息',
        'Stop after match' => '匹配後停止',
        'Edit ACL structure' => '編輯ACL結構',
        'Save' => '保存',
        'or' => '',
        'Save and finish' => '保存並完成',
        'Do you really want to delete this ACL?' => '您確定要刪除這個ACL嗎？',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '該條目中包含子條目。您確定要刪除這個條目及其子條目嗎？',
        'An item with this name is already present.' => '名稱相同的條目已存在。',
        'Add all' => '添加所有',
        'There was an error reading the ACL data.' => '讀取ACL數據時發現一個錯誤。',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '通過填寫表數據實現ACL控制。創建ACL後，就可在編輯模式中添加ACL配置信息。',

        # Template: AdminAttachment
        'Attachment Management' => '附件管理',
        'Add attachment' => '添加附件',
        'List' => '列表',
        'Download file' => '下載文件',
        'Delete this attachment' => '刪除附件',
        'Add Attachment' => '添加附件',
        'Edit Attachment' => '編輯附件',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自動回復管理',
        'Add auto response' => '添加自動回復',
        'Add Auto Response' => '添加自動回復',
        'Edit Auto Response' => '編輯自動回復',
        'Response' => '回復内容',
        'Auto response from' => '自動回復的發件人',
        'Reference' => '相關参考',
        'You can use the following tags' => '您可以使用以下的標記',
        'To get the first 20 character of the subject.' => '顯示主題的前20個字節',
        'To get the first 5 lines of the email.' => '顯示郵件的前五行',
        'To get the realname of the sender (if given).' => '顯示發件人的真實姓名',
        'To get the article attribute' => '信件數據屬性',
        ' e. g.' => '例如',
        'Options of the current customer user data' => '用戶資料屬性',
        'Ticket owner options' => '工單所有者屬性',
        'Ticket responsible options' => '工單負責人屬性',
        'Options of the current user who requested this action' => '工單提交者的屬性',
        'Options of the ticket data' => '工單數據屬性',
        'Options of ticket dynamic fields internal key values' => '工單動態字段内部鍵值',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '動態字段顯示名稱，用於下拉選擇和複選框',
        'Config options' => '系統配置數據',
        'Example response' => '這裡有一個範例',

        # Template: AdminCustomerCompany
        'Customer Management' => '用戶單位管理',
        'Wildcards like \'*\' are allowed.' => '允許使用通配置符，例如\'*\'。',
        'Add customer' => '添加用戶單位',
        'Select' => '選擇',
        'Please enter a search term to look for customers.' => '請輸入搜索條件以便檢索用戶單位資料.',
        'Add Customer' => '添加用戶單位',
        'Edit Customer' => '編輯用戶單位',

        # Template: AdminCustomerUser
        'Customer User Management' => '用戶管理',
        'Back to search results' => '返回至搜索結果',
        'Add customer user' => '添加用戶',
        'Hint' => '提示',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '用戶資料用於記錄工單歷史並允許用戶訪問服務台門戶網站。',
        'Last Login' => '上次登錄時間',
        'Login as' => '登陸用戶門戶',
        'Switch to customer' => '切換至用戶',
        'Add Customer User' => '添加用戶',
        'Edit Customer User' => '編輯用戶',
        'This field is required and needs to be a valid email address.' =>
            '必須輸入有效的郵件地址。',
        'This email address is not allowed due to the system configuration.' =>
            '郵件地址不符合系統配置要求。',
        'This email address failed MX check.' => '該郵件域名的MX記錄檢查無效。',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS問題，請檢查您的配置和錯誤日誌文件。',
        'The syntax of this email address is incorrect.' => '該郵件地址語法錯誤。',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => '管理用戶與組的歸屬關係',
        'Notice' => '註意',
        'This feature is disabled!' => '該功能已關閉',
        'Just use this feature if you want to define group permissions for customers.' =>
            '該功能用於為用戶定義權限組。',
        'Enable it here!' => '打開該功能',
        'Search for customers.' => '搜索用戶。',
        'Edit Customer Default Groups' => '定義用戶的默認組',
        'These groups are automatically assigned to all customers.' => '默認組會自動指派給所有用戶。',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '您可能通過配置参數"CustomerGroupAlwaysGroups"定義默認組。',
        'Filter for Groups' => '過濾組',
        'Select the customer:group permissions.' => '選擇用戶:組權限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '如果沒有選擇，就不具備該組的任何權限 (用戶不能創建或讀取工單)。',
        'Search Results' => '搜索結果',
        'Customers' => '用戶單位',
        'Groups' => '組',
        'No matches found.' => '沒有找到相匹配的.',
        'Change Group Relations for Customer' => '此用戶屬於哪些組',
        'Change Customer Relations for Group' => '哪些用戶屬於此組',
        'Toggle %s Permission for all' => '切換%s權限給全部',
        'Toggle %s permission for %s' => '切換%s權限給%s',
        'Customer Default Groups:' => '用戶的默認組:',
        'No changes can be made to these groups.' => '不能更改默認組.',
        'ro' => '',
        'Read only access to the ticket in this group/queue.' => '對於組/隊列中的工單具有 \'讀\' 的權限',
        'rw' => '',
        'Full read and write access to the tickets in this group/queue.' =>
            '對於組/隊列中的工單具有 \'讀和寫\' 的權限',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => '管理用戶與服務之間的關系',
        'Edit default services' => '修改默認服務',
        'Filter for Services' => '過濾服務',
        'Allocate Services to Customer' => '為此用戶選擇服務',
        'Allocate Customers to Service' => '選擇使用此服務的用戶',
        'Toggle active state for all' => '切換激活狀態給全部',
        'Active' => '激活',
        'Toggle active state for %s' => '切換激活狀態給%s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '動態字段管理',
        'Add new field for object' => '為對象添加新的字段',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '為了創建新的字段，請先確定該字段是工單字段還是信件字段，並選擇正確的字段類型。字段創建後，您無法將信件字段改為工單字段，反之亦然。',
        'Dynamic Fields List' => '動態字段列表',
        'Dynamic fields per page' => '每頁動態字段個數',
        'Label' => '標記',
        'Order' => '順序',
        'Object' => '對象',
        'Delete this field' => '刪除這個字段',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '您確定要刪除這個動態字段嗎? 所有關聯的數據將丢失!',
        'Delete field' => '刪除字段',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '動態字段',
        'Field' => '字段',
        'Go back to overview' => '返回概況',
        'General' => '常規',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '這個字段是必需的，且它的值只能是字母和數字。',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '必須是唯一的且只有接受字母和數字字符',
        'Changing this value will require manual changes in the system.' =>
            '只能對數據庫中直接操作才能修改這個值',
        'This is the name to be shown on the screens where the field is active.' =>
            '標記值作為字段名稱顯示在屏幕上',
        'Field order' => '字段順序',
        'This field is required and must be numeric.' => '這個字段是必需的且必須是數字',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '決定動態字段在屏幕上的顯示順序',
        'Field type' => '字段類型',
        'Object type' => '對象類型',
        'Internal field' => '内置字段',
        'This field is protected and can\'t be deleted.' => '這是内置字段，不能刪除它。',
        'Field Settings' => '字段設置',
        'Default value' => '默認值',
        'This is the default value for this field.' => '此值是字段的默認值',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '默認的日期差',
        'This field must be numeric.' => '字段值必須是數字字符',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '用“此刻”的時差(秒)計算默認值(例如，3600或-60)',
        'Define years period' => '定義年期',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '激活此選項來定義固定的年份範圍(過去的和未來的), 用於顯示在此字段的年份中.',
        'Years in the past' => '過去的幾年',
        'Years in the past to display (default: 5 years).' => '顯示過去的幾年 (默認: 5年)',
        'Years in the future' => '未來的幾年',
        'Years in the future to display (default: 5 years).' => '顯示未來的幾年 (默認: 5年)',
        'Show link' => '顯示鏈接',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '可以為字段值指定一個可選的HTTP鏈接，以便其顯示在工單概況和工單詳情中。',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '可選值',
        'Key' => '鍵',
        'Value' => '值',
        'Remove value' => '刪除值',
        'Add value' => '添加值',
        'Add Value' => '添加值',
        'Add empty value' => '添加空值',
        'Activate this option to create an empty selectable value.' => '激活此選項, 創建可選擇的空值.',
        'Tree View' => '樹狀視圖',
        'Activate this option to display values as a tree.' => '激活此項，將以樹狀形式顯示值',
        'Translatable values' => '可翻譯的值',
        'If you activate this option the values will be translated to the user defined language.' =>
            '激活此項，將用自定義的語言翻譯字段值',
        'Note' => '備註',
        'You need to add the translations manually into the language translation files.' =>
            '需要您手動將翻譯内容添加到翻譯文件中',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => '行數',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '定義編輯窗口的行數',
        'Number of cols' => '列寬',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '定義編輯窗口的列寬',

        # Template: AdminEmail
        'Admin Notification' => '管理員通知',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '通過此模塊，管理員可以按組和角色給服務人員和用戶發送消息。',
        'Create Administrative Message' => '創建管理員通知',
        'Your message was sent to' => '您的信息已被發送到',
        'Send message to users' => '發送信息給註冊用戶',
        'Send message to group members' => '發送信息到組成員',
        'Group members need to have permission' => '組成員需要權限',
        'Send message to role members' => '發送信息到角色成員',
        'Also send to customers in groups' => '同樣發送到該組的用戶',
        'Body' => '内容',
        'Send' => '發送',

        # Template: AdminGenericAgent
        'Generic Agent' => '計劃任務',
        'Add job' => '添加任務',
        'Last run' => '最後運行',
        'Run Now!' => '現在運行!',
        'Delete this task' => '刪除這個任務',
        'Run this task' => '執行這個任務',
        'Job Settings' => '任務設置',
        'Job name' => '任務名稱',
        'The name you entered already exists.' => '您輸入的名稱已經存在。',
        'Toggle this widget' => '收起/展開Widget',
        'Automatic execution (multiple tickets)' => '自動執行(針對多個工單)',
        'Execution Schedule' => '按計劃執行',
        'Schedule minutes' => '分',
        'Schedule hours' => '時',
        'Schedule days' => '日',
        'Currently this generic agent job will not run automatically.' =>
            '目前該計劃任務不會自動運行',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '若要啟用自動執行，則需選擇分鐘，時間或天',
        'Event based execution (single ticket)' => '基於事件執行(針對特定工單)',
        'Event Triggers' => '事件觸發器',
        'List of all configured events' => '配置的事件列表',
        'Delete this event' => '刪除這個事件',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '此外，為了让此任務定期反復地執行，您需要定義工單事件，以便觸發任務的執行。',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '如果工單事件被觸發，工單過濾器將對工單進行檢查看其條件是否匹配。任務只對匹配的工單發生作用。',
        'Do you really want to delete this event trigger?' => '您確定要刪除這個事件觸發器嗎？',
        'Add Event Trigger' => '添加事件觸發器',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '選擇事件對象和事件名稱，然後點擊"+"按鈕，即可添加新的事件。',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => '刪除這個事件觸發器',
        'Ticket Filter' => '工單過濾',
        '(e. g. 10*5155 or 105658*)' => '  例如: 10*5144 或者 105658*',
        '(e. g. 234321)' => '例如: 234321',
        'Customer login' => '用戶登錄',
        '(e. g. U5150)' => '例如: U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '在信件中全文檢索（例如："Mar*in" or "Baue*"）',
        'Agent' => '服務人員',
        'Ticket lock' => '工單鎖定',
        'Create times' => '創建時間',
        'No create time settings.' => '沒有創建時間。',
        'Ticket created' => '工單創建時間(相對)',
        'Ticket created between' => '工單創建時間(絕對)',
        'Change times' => '修改時間',
        'No change time settings.' => '沒有修改時間',
        'Ticket changed' => '修改工單時間(相對)',
        'Ticket changed between' => '工單修改時間(絕對)',
        'Close times' => '關閉時間',
        'No close time settings.' => '沒有關閉時間',
        'Ticket closed' => '工單關閉時間(相對)',
        'Ticket closed between' => '工單關閉時間(絕對)',
        'Pending times' => '掛起時間',
        'No pending time settings.' => '沒有掛起時間',
        'Ticket pending time reached' => '工單掛起時間(相對)',
        'Ticket pending time reached between' => '工單掛起時間(絕對)',
        'Escalation times' => '升級時間',
        'No escalation time settings.' => '沒有升級時間',
        'Ticket escalation time reached' => '工單升級時間(相對)',
        'Ticket escalation time reached between' => '工單升級時間(絕對)',
        'Escalation - first response time' => '升級 - 第一響應時間',
        'Ticket first response time reached' => '工單升級 - 第一響應時間(相對)',
        'Ticket first response time reached between' => '工單升級 - 第一響應時間(絕對)',
        'Escalation - update time' => '升級 - 更新時間',
        'Ticket update time reached' => '工單升級 - 更新時間(相對)',
        'Ticket update time reached between' => '工單升級 - 更新時間(絕對)',
        'Escalation - solution time' => '升級 - 解決時間',
        'Ticket solution time reached' => '工單升級 - 解決時間(相對)',
        'Ticket solution time reached between' => '工單升級 - 解決時間(絕對)',
        'Archive search option' => '歸檔查詢選項',
        'Ticket Action' => '工單處理',
        'Set new service' => '設置新服務',
        'Set new Service Level Agreement' => '指定服務水平協議',
        'Set new priority' => '指定優先級',
        'Set new queue' => '指定隊列',
        'Set new state' => '指定狀態',
        'Pending date' => '掛起時間',
        'Set new agent' => '指定服務人員',
        'new owner' => '指定所有者',
        'new responsible' => '指定負責人',
        'Set new ticket lock' => '工單鎖定',
        'New customer' => '指定用戶',
        'New customer ID' => '指定用戶ID',
        'New title' => '指定稱謂',
        'New type' => '指定類型',
        'New Dynamic Field Values' => '新的動態字段值',
        'Archive selected tickets' => '歸檔選中的工單',
        'Add Note' => '添加備註',
        'Time units' => '時間',
        '(work units)' => '',
        'Ticket Commands' => '工單命令',
        'Send agent/customer notifications on changes' => '給服務人員/用戶發送通知',
        'CMD' => '命令',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            '將執行這個命令, 第一個参數是工單 編號，第二個参數是工單的標識符.',
        'Delete tickets' => '刪除工單',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '警告：所有影響的工單從數據庫刪除，將無法恢復！',
        'Execute Custom Module' => '執行客戶化模塊',
        'Param %s key' => '参數 %s key',
        'Param %s value' => '参數 %s value',
        'Save Changes' => '保存更改',
        'Results' => '結果',
        '%s Tickets affected! What do you want to do?' => '%s 個工單將被影響！您確定要這麼做?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告：您選擇了"刪除"指令。所有刪除的工單數據將無法恢復。',
        'Edit job' => '編輯任務',
        'Run job' => '執行任務',
        'Affected Tickets' => '受影響的工單',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Web服務%s的通用接口調試器',
        'Web Services' => 'Web服務',
        'Debugger' => '調試器',
        'Go back to web service' => '返回到Web服務',
        'Clear' => '刪除',
        'Do you really want to clear the debug log of this web service?' =>
            '您確定要刪除該Web服務的調試日誌嗎？',
        'Request List' => '請求列表',
        'Time' => '時間',
        'Remote IP' => '遠程IP',
        'Loading' => '連載',
        'Select a single request to see its details.' => '選擇一個請求，以便查看其詳細信息。',
        'Filter by type' => '按類型過濾',
        'Filter from' => '按日期過濾(從)',
        'Filter to' => '按日期過濾(至)',
        'Filter by remote IP' => '按遠程IP過濾',
        'Refresh' => '刷新',
        'Request Details' => '請求詳細信息',
        'An error occurred during communication.' => '在通訊時發生一個錯誤。',
        'Clear debug log' => '刪除調試日誌',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '為Web服務%s添加新的調用程序',
        'Change Invoker %s of Web Service %s' => '修改調用程序%s(Web服務%s)',
        'Add new invoker' => '添加新的調用程序',
        'Change invoker %s' => '修改調用程序%s',
        'Do you really want to delete this invoker?' => '您確定要刪除這個調用程序嗎？',
        'All configuration data will be lost.' => '所有配置數據將丢失。',
        'Invoker Details' => '調用程序詳情',
        'The name is typically used to call up an operation of a remote web service.' =>
            '這個名字通常用於調用遠程web服務的一個操作',
        'Please provide a unique name for this web service invoker.' => '請為這個Web服務調用程序提供一個唯一的名稱。',
        'Invoker backend' => '調用程序後端',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '這個OTRS調用程序後端模塊被調用後，負責準備需要發送給遠程系統的數據，並處理它的響應數據。',
        'Mapping for outgoing request data' => '映射出站請求數據',
        'Configure' => '配置',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '這個映射將對OTRS調用程序輸出的數據進行處理，將它轉換為遠程系統所期待的數據。',
        'Mapping for incoming response data' => '映射入站請求數據',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '這個映射將對響應數據進行處理，將它轉換為OTRS調用程序所期待的數據。',
        'Asynchronous' => '異步的',
        'This invoker will be triggered by the configured events.' => '配置事件將觸發這個調用程序。',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '異步事件觸發是由後台的OTRS調度處理的(推薦)。',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '同步事件觸發則是在web請求期間直接處理的。',
        'Save and continue' => '保存並繼續',
        'Delete this Invoker' => '刪除這個調用程序',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Web服務%s的通用接口映射簡單',
        'Go back to' => '返回到',
        'Mapping Simple' => '映射簡單',
        'Default rule for unmapped keys' => '未映射鍵的默認規則',
        'This rule will apply for all keys with no mapping rule.' => '這個規則將應用於所有沒有映射規則的鍵。',
        'Default rule for unmapped values' => '未映射值的默認規則',
        'This rule will apply for all values with no mapping rule.' => '這個規則將應用於所有沒有映射規則的值。',
        'New key map' => '新的鍵映射',
        'Add key mapping' => '添加鍵映射',
        'Mapping for Key ' => '',
        'Remove key mapping' => '刪除鍵映射',
        'Key mapping' => '鍵映射',
        'Map key' => '映射鍵',
        'matching the' => '將匹配的',
        'to new key' => '映射到新鍵',
        'Value mapping' => '值映射',
        'Map value' => '映射值',
        'to new value' => '映射到新值',
        'Remove value mapping' => '刪除值映射',
        'New value map' => '新的值映射',
        'Add value mapping' => '添加值映射',
        'Do you really want to delete this key mapping?' => '您確定要刪除這個鍵映射嗎？',
        'Delete this Key Mapping' => '刪除這個鍵映射',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '為Web服務%s添加新的操作',
        'Change Operation %s of Web Service %s' => '修改操作%s(Web服務%s)',
        'Add new operation' => '添加新的操作',
        'Change operation %s' => '修改操作%s',
        'Do you really want to delete this operation?' => '您確定要刪除這個操作嗎？',
        'Operation Details' => '操作詳情',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '這個名稱通常用於從一個遠程系統調用這個web服務操作。',
        'Please provide a unique name for this web service.' => '請為這個Web服務提供一個唯一的名稱。',
        'Mapping for incoming request data' => '映射傳入請求數據',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '這個映射將對請求數據進行處理，將它轉換為OTRS所期待的數據。',
        'Operation backend' => '操作後端',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '這個OTRS操作後端模塊將被調用，以便處理請求、為響應生成數據。',
        'Mapping for outgoing response data' => '映射出站響應數據',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '這個映射將對響應數據進行處理，以便將它轉換成遠程系統所期待的數據。',
        'Delete this Operation' => '刪除這個操作',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Web服務%s的通用接口傳輸HTTP::SOAP',
        'Network transport' => '網絡傳輸',
        'Properties' => '屬性',
        'Endpoint' => '端點',
        'URI to indicate a specific location for accessing a service.' =>
            'URI用來表示訪問服務的一個特定的位置。',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '命名空間',
        'URI to give SOAP methods a context, reducing ambiguities.' => '為SOAP方法指定URI(通用資源標識符), 以便消除二義性。',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => '消息的最大長度',
        'This field should be an integer number.' => '這個字段值應該是一個整數。',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '在這裡您可以指定OTRS能夠處理的SOAP消息的最大長度(以字節為單位)。',
        'Encoding' => '編碼',
        'The character encoding for the SOAP message contents.' => 'SOAP消息内容的字符編碼',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => 'SOAP動作',
        'Set to "Yes" to send a filled SOAPAction header.' => '設置"Yes"時，發送填寫了的SOAP動作頭。',
        'Set to "No" to send an empty SOAPAction header.' => '設置"No"時，發送空白的SOAP動作頭。',
        'SOAPAction separator' => 'SOAP動作分隔符',
        'Character to use as separator between name space and SOAP method.' =>
            '作為名稱空間和SOAP方法分隔符的字符。',
        'Usually .Net web services uses a "/" as separator.' => '通常.Net的Web服務使用"/"作為分隔符。',
        'Authentication' => '驗証',
        'The authentication mechanism to access the remote system.' => '訪問遠程系統的認証機制。',
        'A "-" value means no authentication.' => '"-"意味着沒有認証。',
        'The user name to be used to access the remote system.' => '用於訪問遠程系統的用戶名。',
        'The password for the privileged user.' => '特權用戶的密碼。',
        'Use SSL Options' => '啟用SSL選項',
        'Show or hide SSL options to connect to the remote system.' => '顯示或隱藏用來連接遠程系統SSL選項。',
        'Certificate File' => '証書文件',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'SSL証書文件的完整路徑和名稱(必須採用p12格式)。',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'Certificate Password File' => '証書密碼文件',
        'The password to open the SSL certificate.' => '訪問SSL証書的密碼',
        'Certification Authority (CA) File' => '認証機構(CA)文件',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '用來驗証SSL証書的認証機構証書文件的完整路徑和名稱。',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '認証機構(CA)目錄',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '認証機構目錄的完整路徑，文件系統中存儲CA証書存儲地方。',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Proxy Server' => '代理服務器',
        'URI of a proxy server to be used (if needed).' => '代理服務器的URI(如果使用代理)。',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '代理用戶',
        'The user name to be used to access the proxy server.' => '訪問代理服務器的用戶名。',
        'Proxy Password' => '代理密碼',
        'The password for the proxy user.' => '代理用戶的密碼。',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '通用接口Web服務管理',
        'Add web service' => '添加Web服務',
        'Clone web service' => '克隆Web服務',
        'The name must be unique.' => '名稱必須是唯一的。',
        'Clone' => '克隆',
        'Export web service' => '導出Web服務',
        'Import web service' => '導入Web服務',
        'Configuration File' => '配置文件',
        'The file must be a valid web service configuration YAML file.' =>
            '必須是有效的Web服務配置文件(yaml格式)。',
        'Import' => '導入',
        'Configuration history' => '配置歷史',
        'Delete web service' => '刪除Web服務',
        'Do you really want to delete this web service?' => '您確定要刪除這個Web服務嗎？',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '保存配置文件後，頁面將再次轉至編輯頁面。',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '如果您想返回到概況，請點擊"返回概況"按鈕。',
        'Web Service List' => 'Web服務列表',
        'Remote system' => '遠程系統',
        'Provider transport' => '服務提供方傳輸',
        'Requester transport' => '服務請求方傳輸',
        'Details' => '詳情',
        'Debug threshold' => '調試閥值',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '在提供方模式中，OTRS為遠程系統提供Web服務。',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '在請求方模式中，OTRS使用遠程系統的Web服務。',
        'Operations are individual system functions which remote systems can request.' =>
            '操作是各種不同的系統功能，可供遠程系統請求調用。',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '調用程序為請求遠程Web服務准備數據，並其響應的數據進行處理。',
        'Controller' => '控制器',
        'Inbound mapping' => '入站映射',
        'Outbound mapping' => '出站映射',
        'Delete this action' => '刪除這個動作',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '至少有一個%s的控制器未被激活或根本就不存在，請檢查控制器註冊或刪除這個%s',
        'Delete webservice' => '刪除Web服務',
        'Delete operation' => '刪除操作',
        'Delete invoker' => '刪除調用程序',
        'Clone webservice' => '克隆Web服務',
        'Import webservice' => '導入Web服務',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Web服務%s通用接口配置歷史',
        'Go back to Web Service' => '返回到Web服務',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '在這裡，您可以查看當前Web服務配置的舊版本，導出或恢復它們。',
        'Configuration History List' => '配置歷史列表',
        'Version' => '版本',
        'Create time' => '創建時間',
        'Select a single configuration version to see its details.' => '選擇一個配置版本，以便查看它的詳細情況。',
        'Export web service configuration' => '導出Web服務配置',
        'Restore web service configuration' => '導入Web服務配置',
        'Do you really want to restore this version of the web service configuration?' =>
            '您確定要恢復Web服務配置的這個版本嗎？',
        'Your current web service configuration will be overwritten.' => '當前的Web服務配置將被覆蓋',
        'Show or hide the content.' => '顯示或隱藏該内容.',
        'Restore' => '恢復',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '警告：當您更改\'管理\'組的名稱時，在SysConfig作出相應的變化之前，您將被管理面板鎖住！如果發生這種情況，請用SQL語句把組名改回到\'admin\'',
        'Group Management' => '組管理',
        'Add group' => '添加組',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'admin組允許使用系統管理模塊，stats組允許使用統計模塊。',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '若要為不同的服務人員分配不同的訪問權限，應創建新的組。(例如，採購部、支持部、銷售部、...)',
        'It\'s useful for ASP solutions. ' => '這對於ASP解決方案它很有用。',
        'Add Group' => '添加組',
        'Edit Group' => '編輯組',

        # Template: AdminLog
        'System Log' => '系統日誌',
        'Here you will find log information about your system.' => '查看系統日誌信息。',
        'Hide this message' => '隱藏此消息',
        'Recent Log Entries' => '最近的日誌',

        # Template: AdminMailAccount
        'Mail Account Management' => '管理郵件接收地址',
        'Add mail account' => '添加郵件接收地址',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            '接收到的郵件將被分派到郵件接收地址所指定的隊列中!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            '如果郵件接收地址被設置為"信任"，OTRS將對郵件信頭中現有的X-OTRS標記執行相應的處理操作 (例如，設置工單優先級)！而PostMaster Filter总是要執行的，與郵件接收地址是否被設置為"信認"無關。',
        'Host' => '主機',
        'Delete account' => '刪除帳號',
        'Fetch mail' => '查收郵件',
        'Add Mail Account' => '添加郵件帳號',
        'Example: mail.example.com' => '範例：mail.example.com',
        'IMAP Folder' => 'IMAP文件夾',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '僅當您打算從其它文件夾(非INBOX)讀取郵件時，才有必要修改此項.',
        'Trusted' => '是否信任',
        'Dispatching' => '分派',
        'Edit Mail Account' => '編輯郵件接收地址',

        # Template: AdminNavigationBar
        'Admin' => '系統管理',
        'Agent Management' => '服務人員管理',
        'Queue Settings' => '隊列設置',
        'Ticket Settings' => '工單設置',
        'System Administration' => '系統管理員',

        # Template: AdminNotification
        'Notification Management' => '通知管理',
        'Select a different language' => '選擇不同的語言',
        'Filter for Notification' => '過濾通知',
        'Notifications are sent to an agent or a customer.' => '發送給服務人員或用戶的通知。',
        'Notification' => '系統通知',
        'Edit Notification' => '編輯通知',
        'e. g.' => '例如',
        'Options of the current customer data' => '當前用戶數據選項',

        # Template: AdminNotificationEvent
        'Add notification' => '添加通知',
        'Delete this notification' => '刪除通知',
        'Add Notification' => '添加通知',
        'Article Filter' => '信件過濾器',
        'Only for ArticleCreate event' => '僅對ArticleCreate事件有效',
        'Article type' => '信件類型',
        'Article sender type' => '',
        'Subject match' => '主題匹配',
        'Body match' => '内容匹配',
        'Include attachments to notification' => '通知包含附件',
        'Recipient' => '收件人',
        'Recipient groups' => '收件人(組)',
        'Recipient agents' => '收件人(服務人員)',
        'Recipient roles' => '收件人(角色)',
        'Recipient email addresses' => '收件人(郵件地址)',
        'Notification article type' => '信件類型',
        'Only for notifications to specified email addresses' => '僅限於給指定郵件地址發送的通知',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '截取主題的前20個字符（最新的服務人員信件）',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '截取郵件正文内容前5行（最新的服務人員信件）',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '截取郵件主題的前20個字符（最新的用戶信件）',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '截取郵件正文内容前5行（最新的用戶信件）',

        # Template: AdminPGP
        'PGP Management' => 'PGP管理',
        'Use this feature if you want to work with PGP keys.' => '該功能用於管理PGP密鑰',
        'Add PGP key' => '添加PGP密鑰',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            '通過此模塊可以直接編輯在SysConfig中配置的密鑰環。',
        'Introduction to PGP' => 'PGP介紹',
        'Result' => '結果',
        'Identifier' => '標識符',
        'Bit' => '位',
        'Fingerprint' => '指紋',
        'Expires' => '過期',
        'Delete this key' => '刪除密鑰',
        'Add PGP Key' => '添加PGP密鑰',
        'PGP key' => 'PGP密鑰',

        # Template: AdminPackageManager
        'Package Manager' => '軟件包管理',
        'Uninstall package' => '卸載軟件包',
        'Do you really want to uninstall this package?' => '是否確認卸載該軟件包?',
        'Reinstall package' => '重新安裝軟件包',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '您確定要重新安裝該軟包嗎? 所有該模塊的手工設置將丢失.',
        'Continue' => '繼續',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '請確認您的數據庫能夠接收大於%sMB的數據包（目前能夠接收的最大數據包為%sMB）。為了避免程序報錯，請調整數據庫max_allowed_packet参數。',
        'Install' => '安裝',
        'Install Package' => '安裝軟件包',
        'Update repository information' => '更新軟件倉庫信息',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '沒有找到您所需要的功能嗎？OTRS為服務合同用戶提供專屬附加組件：',
        'Online Repository' => '在綫軟件倉庫',
        'Vendor' => '提供者',
        'Module documentation' => '模塊文檔',
        'Upgrade' => '升級',
        'Local Repository' => '本地軟件倉庫',
        'This package is verified by OTRSverify (tm)' => '此軟件包已通過OTRSverify(tm)的驗証',
        'Uninstall' => '卸載',
        'Reinstall' => '重新安裝',
        'Feature Add-Ons' => '擴展軟件包',
        'Download package' => '下載該軟件包',
        'Rebuild package' => '重新編譯',
        'Metadata' => '元數據',
        'Change Log' => '更新記錄',
        'Date' => '日期',
        'List of Files' => '文件清單',
        'Permission' => '權限',
        'Download' => '下載',
        'Download file from package!' => '從軟件包中下載這個文件',
        'Required' => '必需的',
        'PrimaryKey' => '關鍵的Key',
        'AutoIncrement' => '自動遞增',
        'SQL' => 'SQL',
        'File differences for file %s' => '文件跟%s有差異',

        # Template: AdminPerformanceLog
        'Performance Log' => '性能日誌',
        'This feature is enabled!' => '該功能已啟用',
        'Just use this feature if you want to log each request.' => '如果想詳細記錄每個請求, 您可以使用該功能.',
        'Activating this feature might affect your system performance!' =>
            '啟動該功能可能影響您的系統性能',
        'Disable it here!' => '關閉該功能',
        'Logfile too large!' => '日誌文件過大',
        'The logfile is too large, you need to reset it' => '日誌文件太大，請重新初始化。',
        'Overview' => '概況',
        'Range' => '範圍',
        'last' => '最後',
        'Interface' => '界面',
        'Requests' => '請求',
        'Min Response' => '最快回應',
        'Max Response' => '最慢回應',
        'Average Response' => '平均回應',
        'Period' => '時長',
        'Min' => '最小',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '郵件過濾器管理',
        'Add filter' => '添加過濾器',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '基於郵件頭標記的分派或過濾。可以使用正則表達式進行匹配。',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '如果您只想匹配某個郵件地址，可以在From、To或Cc中使用EMAILADDRESS:info@example.com這樣的郵件格式。',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '如果您使用了正則表達式，您可以取出()中匹配的值，再將它寫入OTRS標記中(需採用[***]這種格式。)',
        'Delete this filter' => '刪除此過濾器',
        'Add PostMaster Filter' => '添加郵件過濾器',
        'Edit PostMaster Filter' => '編輯郵件過濾器',
        'The name is required.' => '過濾器名稱是必需項。',
        'Filter Condition' => '過濾條件',
        'AND Condition' => '與條件',
        'Negate' => '求反',
        'The field needs to be a valid regular expression or a literal word.' =>
            '該欄位需使用有效的正則表達式或文字。',
        'Set Email Headers' => '設置郵件頭',
        'The field needs to be a literal word.' => '該字段需要輸入文字。',

        # Template: AdminPriority
        'Priority Management' => '優先級管理',
        'Add priority' => '添加優先級',
        'Add Priority' => '添加優先級',
        'Edit Priority' => '編輯優先級',

        # Template: AdminProcessManagement
        'Process Management' => '流程管理',
        'Filter for Processes' => '過濾流程',
        'Process Name' => '流程名稱',
        'Create New Process' => '創建新的流程',
        'Synchronize All Processes' => '同步所有流程',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '您可以上傳流程配置文件，以便將流程配置導入至您的系統中。流程配置文件採用.yml格式，它可以從流程管理模塊中導出。',
        'Upload process configuration' => '上傳流程配置',
        'Import process configuration' => '導入流程配置',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '為了創建新的流程，您可以導入流程配置文件或從新創建它。',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '對流程所做的一切修改僅保存在數據庫中。只有執行同步操作後，才會生成或重新生成流程配置文件。',
        'Processes' => '流程',
        'Process name' => '流程名稱',
        'Print' => '打印',
        'Export Process Configuration' => '導出流程配置',
        'Copy Process' => '複製流程',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => '取消並關閉窗口',
        'Go Back' => '返回',
        'Please note, that changing this activity will affect the following processes' =>
            '請注意，修改這個環節將影響以下流程',
        'Activity' => '環節',
        'Activity Name' => '環節名稱',
        'Activity Dialogs' => '環節操作',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '通過鼠標將左側列表中的元素拖放至右側，您可以為這個環節指派環節操作。',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '利用鼠標拖放動作還可以對元素進行排序。',
        'Filter available Activity Dialogs' => '過濾可選的環節操作',
        'Available Activity Dialogs' => '可選的環節操作',
        'Create New Activity Dialog' => '創建新環節操作',
        'Assigned Activity Dialogs' => '指派的環節操作',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '一旦您使用這個按鈕或鏈接,您將退出這個界面且當前狀態將被自動保存。您想要繼續嗎?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '請注意，修改這個環節操作將影響以下環節',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '請注意，用戶並不能看到或對以下字段時行操作：Owner, Responsible, Lock, PendingTime and CustomerID.',
        'Activity Dialog' => '環節操作',
        'Activity dialog Name' => '環節操作名稱',
        'Available in' => '有效界面',
        'Description (short)' => '描述(簡短)',
        'Description (long)' => '描述(詳細)',
        'The selected permission does not exist.' => '選擇的權限不存在',
        'Required Lock' => '需要鎖定',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '提交建議文本',
        'Submit Button Text' => '提交按鈕文本',
        'Fields' => '字段',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '通過鼠標將左側列表中的元素拖放至右側，您可以為這個環節操作指派字段。',
        'Filter available fields' => '過濾可選的字段',
        'Available Fields' => '可選的字段',
        'Assigned Fields' => '指排的字段',
        'Edit Details for Field' => '編輯字段詳情',
        'ArticleType' => '信件類型',
        'Display' => '顯示',
        'Edit Field Details' => '編輯字段詳情',
        'Customer interface does not support internal article types.' => '用戶界面不支援内部信件類型。',

        # Template: AdminProcessManagementPath
        'Path' => '路徑',
        'Edit this transition' => '編輯這個轉向',
        'Transition Actions' => '轉向動作',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '通過鼠標將左側列表中的元素拖放至右側，您可以為這個轉向指派轉向動作。',
        'Filter available Transition Actions' => '過濾可選的轉向動作',
        'Available Transition Actions' => '可選的轉向動作',
        'Create New Transition Action' => '創建新的轉向動作',
        'Assigned Transition Actions' => '指派的轉向動作',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '環節',
        'Filter Activities...' => '過濾環節...',
        'Create New Activity' => '創建新的環節',
        'Filter Activity Dialogs...' => '過濾環節操作...',
        'Transitions' => '轉向',
        'Filter Transitions...' => '過濾轉向...',
        'Create New Transition' => '創建新的轉向',
        'Filter Transition Actions...' => '過濾轉向操作...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '編輯流程',
        'Print process information' => '打印流程信息',
        'Delete Process' => '刪除流程',
        'Delete Inactive Process' => '刪除非活動的流程',
        'Available Process Elements' => '可選的流程元素',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '通過鼠標拖放動作，可以將左側欄目上方所列的元素放置在右側的畫布中。',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '可能將環節拖放至畫布中，以便為流程指派環節。',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '為了給環節指派環節操作，需要將左側的環節操作拖放至畫布中的環節上。',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '為了實現環節之間的轉向，需要將左側的轉向拖放至畫布中並將它放至在開始環節上，然後再將轉向箭頭拖放至結束環節上。',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '為了給轉向指派轉向動作，需要將左側轉向動作拖放至轉向標簽上。',
        'Edit Process Information' => '編輯流程信息',
        'The selected state does not exist.' => '選擇的狀態不存在',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '添加並編輯環節、環節操作和轉向',
        'Show EntityIDs' => '顯示實體編號',
        'Extend the width of the Canvas' => '擴展畫布的寬度',
        'Extend the height of the Canvas' => '擴展畫布的高度',
        'Remove the Activity from this Process' => '從這個流程中刪除該環節',
        'Edit this Activity' => '編輯該環節',
        'Save settings' => '保存設置',
        'Save Activities, Activity Dialogs and Transitions' => '保存環節、環節操作和轉向',
        'Do you really want to delete this Process?' => '您確定要刪除這個流程嗎？',
        'Do you really want to delete this Activity?' => '您確定要刪除這個環節嗎？',
        'Do you really want to delete this Activity Dialog?' => '您確定要刪除這個環節操作嗎？',
        'Do you really want to delete this Transition?' => '您確定要刪除這個轉向嗎？',
        'Do you really want to delete this Transition Action?' => '您確定要刪除這個轉向動作嗎？',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您確定要從畫布中刪除這個環節嗎？不保存並退出此窗口可撤銷刪除操作。',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '您確定要從畫布中刪除這個轉向嗎？不保存並退出此窗口可撤銷刪除操作。',
        'Hide EntityIDs' => '隱藏實體編號',
        'Delete Entity' => '刪除實體',
        'Remove Entity from canvas' => '從畫布中刪除實體',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '流程中已包括這個環節，您不能重復添加環節。',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '不能刪除這個環節，因為它是開始環節。',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '環節已經使用了這個轉向，您不能重復添加轉向。',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '路徑已經使用了這個轉向動作，您不能重復添加轉向動作。',
        'Remove the Transition from this Process' => '從該流程中刪除轉向',
        'No TransitionActions assigned.' => '沒有轉向動作被指派',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '沒有指派的環節操作。請從左側列表中選擇一個環節操作，並將它拖放到這裡。',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '畫布上已經有一個未連接的轉向。在設置另一個轉向之前，請先連接這個轉向。',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '在這裡，您可以創建新的流程。為了使新流程生效，請務必將流程的狀態設置為“激活”，將在完成配置工作後執行同步操作。',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '開始環節',
        'Contains %s dialog(s)' => '包含%s操作',
        'Assigned dialogs' => '指派操作',
        'Activities are not being used in this process.' => '該流程未使用環節',
        'Assigned fields' => '指派字段',
        'Activity dialogs are not being used in this process.' => '該流程未使用環節操作',
        'Condition linking' => '條件鏈接',
        'Conditions' => '條件',
        'Condition' => '條件',
        'Transitions are not being used in this process.' => '該流程未使用轉向',
        'Module name' => '模塊名稱',
        'Configuration' => '配置',
        'Transition actions are not being used in this process.' => '該流程未使用轉向動作',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '請注意，修改這個轉向將影響以下流程。',
        'Transition' => '轉向',
        'Transition Name' => '轉向名稱',
        'Type of Linking between Conditions' => '條件之間的邏輯關系',
        'Remove this Condition' => '刪除這個條件',
        'Type of Linking' => '鏈接類型',
        'Remove this Field' => '刪除這個字段',
        'Add a new Field' => '添加新的字段',
        'Add New Condition' => '添加新的條件',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '請注意，修改這個轉向動作將影響以下流程。',
        'Transition Action' => '轉向動作',
        'Transition Action Name' => '轉向動作名稱',
        'Transition Action Module' => '轉向動作模塊',
        'Config Parameters' => '配置参數',
        'Remove this Parameter' => '刪除這個参數',
        'Add a new Parameter' => '添加新的参數',

        # Template: AdminQueue
        'Manage Queues' => '隊列管理',
        'Add queue' => '添加隊列',
        'Add Queue' => '添加隊列',
        'Edit Queue' => '編輯隊列',
        'Sub-queue of' => '子隊列',
        'Unlock timeout' => '超時解鎖',
        '0 = no unlock' => '永不解鎖',
        'Only business hours are counted.' => '只計算上班時間',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '如果工單被鎖定且在鎖定超時之前未被關閉，則該工單將被解鎖，以便其他服務人員處理該工單.',
        'Notify by' => '超時觸發通知',
        '0 = no escalation' => '0 = 不升級  ',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定義的時間之前，服務人員沒有對新工單添加任何信件(無論是郵件-外部或電話)，該工單將升級.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '如果有新的信件，例如用戶通過門戶或郵件發送跟進信件，則對升級更新時間進行復位. 如果在此所定義的時間之前，服務人員沒有對新工單添加任何信件，無論是郵件-外部或電話，該工單將升級.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '如果在此所定義的時間之前，工單未被關閉，該工單將升級.',
        'Follow up Option' => '跟進選項',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '如果用戶在工單關閉後發送跟進信件，您是允許、拒絕、還是創建新工單?',
        'Ticket lock after a follow up' => '跟進後自動鎖定工單',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '如果用戶在工單關閉後發送跟進信件，則將該工單鎖定給以前的所有者.',
        'System address' => '系統郵件地址',
        'Will be the sender address of this queue for email answers.' => '回復郵件的發送地址',
        'Default sign key' => '默認回復簽名',
        'The salutation for email answers.' => '回復郵件中的抬頭',
        'The signature for email answers.' => '回復郵件中的簽名',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '管理隊列的自動回復',
        'Filter for Queues' => '過濾隊列',
        'Filter for Auto Responses' => '過濾回復',
        'Auto Responses' => '自動回復',
        'Change Auto Response Relations for Queue' => '設置隊列的自動回復',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '管理模板與隊列的對應關系',
        'Filter for Templates' => '過濾模板',
        'Templates' => '模板',
        'Change Queue Relations for Template' => '為模板設置隊列',
        'Change Template Relations for Queue' => '為隊列設置模板',

        # Template: AdminRegistration
        'System Registration Management' => '系統註冊管理',
        'Edit details' => '',
        'Overview of registered systems' => '註冊系統概述',
        'Deregister system' => '取消系統註冊',
        'System Registration' => '系統註冊',
        'This system is registered with OTRS Group.' => '本系統由OTRS集團註冊。',
        'System type' => '系統類型',
        'Unique ID' => '唯一ID',
        'Last communication with registration server' => '與註冊服務器上一次的通訊',
        'OTRS-ID Login' => 'OTRS-ID登陸',
        'System registration is a service of OTRS group, which provides a lot of advantages!' =>
            '系統註冊是OTRS集團的一項服務，它為您提供了很多好處!',
        'Read more' => '閱讀全部',
        'You need to log in with your OTRS-ID to register your system.' =>
            '為了註冊系統，需要您先使用OTRS-ID進行登陸。',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'OTRS-ID是您的一個郵件地址，用於在OTRS.com網頁進行註冊和登陸。',
        'What are the advantages of system registration?' => '系統註冊有什麼好處?',
        'You will receive updates about relevant security releases.' => '您將及時收到有關安全版本的更新信息。',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '有助於我們改善服務，因為我們從您處獲得了必要的相關信息。',
        'This is only the beginning!' => '這僅僅是開始！',
        'We will inform you about our new services and offerings soon.' =>
            '我們會向您發布更多服務和產品。',
        'Can I use OTRS without being registered?' => '如果不進行系統註冊，我還可以使用OTRS嗎?',
        'System registration is optional.' => '系統註冊是可選的。',
        'You can download and use OTRS without being registered.' => '不進行註冊，您仍然可以下載和使用OTRS',
        'Is it possible to deregister?' => '可以取消註冊嗎？',
        'You can deregister at any time.' => '您可以隨時取消系統註冊',
        'Which data is transfered when registering?' => '註冊後，哪些數據會被上傳?',
        'A registered system sends the following data to OTRS Group:' => '註冊過的系統會將以下數據上傳給OTRS集團：',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            '域名(FQDN)、OTRS版本、數據庫、操作系統和Perl版本。',
        'Why do I have to provide a description for my system?' => '為什麼需要我提供有關註冊系統的描述?',
        'The description of the system is optional.' => '註冊系統的描述是可選的。',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '註冊系統描述和類型有助於您識别和管理系統的細節。',
        'How often does my OTRS system send updates?' => '我的OTRS系統上傳數據的頻度?',
        'Your system will send updates to the registration server at regular intervals.' =>
            '您的系統將定期向註冊服務器發送更新。',
        'Typically this would be around once every three days.' => '通常這將是大约每3天1次。',
        'In case you would have further questions we would be glad to answer them.' =>
            '如果您還有其它問題，我們非常願意答復您。',
        'Please visit our' => '請訪問我們的',
        'portal' => '門戶',
        'and file a request.' => '並提出請求。',
        'If you deregister your system, you will loose these benefits:' =>
            '如果您取消系統註冊，您將放棄這些好處:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => '',
        'You don\'t have an OTRS-ID yet?' => '還沒有OTRS-ID嗎？',
        'Sign up now' => '現在註冊',
        'Forgot your password?' => '忘記密碼了嗎？',
        'Retrieve a new one' => '獲取新的密碼',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '註冊本系統後，這個數據會經常傳送給OTRS Group',
        'Attribute' => '屬性',
        'FQDN' => '',
        'OTRS Version' => 'OTRS版本',
        'Operating System' => '操作系統',
        'Perl Version' => 'Perl版本',
        'Optional description of this system.' => '這個系統可選的描述。',
        'Register' => '註冊',
        'Deregister System' => '取消系統註冊',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => '取消註冊',
        'You can modify the system type and description here.' => '',

        # Template: AdminRole
        'Role Management' => '角色管理',
        'Add role' => '添加角色',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '創建一個角色並將組加入角色,然後將角色赋給用戶.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '有沒有角色定義. 請使用 \'添加\' 按鈕來創建一個新的角色',
        'Add Role' => '添加角色',
        'Edit Role' => '編輯角色',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '管理角色的組權限',
        'Filter for Roles' => '過濾角色',
        'Roles' => '角色',
        'Select the role:group permissions.' => '選擇角色:組權限。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '如果沒有選擇，就不會具有任何權限 (任何工單都看不見)',
        'Change Role Relations for Group' => '選擇此組具有的角色權限',
        'Change Group Relations for Role' => '選擇此角色具有的組權限',
        'Toggle %s permission for all' => '切換%s權限給全部',
        'move_into' => '',
        'Permissions to move tickets into this group/queue.' => '對於組/隊列中的工單具有 \'轉移隊列\' 的權限',
        'create' => '',
        'Permissions to create tickets in this group/queue.' => '對於組/隊列具有 \'創建工單\' 的權限',
        'priority' => '',
        'Permissions to change the ticket priority in this group/queue.' =>
            '對於組/隊列中的工單具有 \'更改優先級\' 的權限',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '定義服務人員的角色',
        'Filter for Agents' => '查找服務人員',
        'Agents' => '服務人員',
        'Manage Role-Agent Relations' => '管理服務人員的角色',
        'Change Role Relations for Agent' => '選擇此服務人員的角色',
        'Change Agent Relations for Role' => '選擇此角色的服務人員',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Add SLA' => '添加SLA',
        'Edit SLA' => '編輯SLA',
        'Please write only numbers!' => '僅可填寫數字！',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'Add certificate' => '添加証書',
        'Add private key' => '添加私匙',
        'Filter for certificates' => '過濾証書',
        'Filter for SMIME certs' => '過濾SMIME証書',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '在這裡，您可以添加您的私人証書的關係，當您使用這個証書簽署一份電子郵件時，它們將嵌入到SMIME簽名中。',
        'See also' => '参見',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '這樣您能夠直接編輯文件系統中的証書和私匙。',
        'Hash' => 'Hash',
        'Handle related certificates' => '處理關聯的証書',
        'Read certificate' => '讀取証書',
        'Delete this certificate' => '刪除這個証書',
        'Add Certificate' => '添加証書',
        'Add Private Key' => '添加個人私鑰',
        'Secret' => '機密',
        'Related Certificates for' => '關聯証書',
        'Delete this relation' => '刪除這個關聯',
        'Available Certificates' => '可選的証書',
        'Relate this certificate' => '關聯這個証書',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => 'SMIME証書',
        'Close window' => '關閉窗口',

        # Template: AdminSalutation
        'Salutation Management' => '回復抬頭管理',
        'Add salutation' => '添加回復抬頭',
        'Add Salutation' => '添加回復抬頭',
        'Edit Salutation' => '編輯回復抬頭',
        'Example salutation' => '這裡有一個範例',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '這個選項將強制啟動調度，即使這個程序僅是在數據庫中註冊的',
        'Start scheduler' => '啟動調度',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '無法啟動調度程序，請檢查調度是否正在運行，選擇強制啟動選項並再次尝試啟動',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => '安全模式需要被啟用！',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '在初始安裝結束後，安全模式通常將被設置',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '系統已啟用，請通過SysConfig啟用安全模式。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL查詢窗口',
        'Here you can enter SQL to send it directly to the application database.' =>
            '這裡您可以輸入並運行數據庫SQL的命令。',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL查詢的語法有一個錯誤，請核對。',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '至少有一個参數丢失，請核對。',
        'Result format' => '結果格式',
        'Run Query' => '執行查詢',

        # Template: AdminService
        'Service Management' => '服務管理',
        'Add service' => '添加服務',
        'Add Service' => '添加服務',
        'Edit Service' => '編輯服務',
        'Sub-service of' => '子服務',

        # Template: AdminSession
        'Session Management' => '會話管理',
        'All sessions' => '所有會話',
        'Agent sessions' => '服務人員會話',
        'Customer sessions' => '用戶會話',
        'Unique agents' => '實際服務人員',
        'Unique customers' => '實際在綫用戶',
        'Kill all sessions' => '终止所有會話',
        'Kill this session' => '终止該會話',
        'Session' => '會話',
        'Kill' => '终止',
        'Detail View for SessionID' => '該會話的詳細記錄',

        # Template: AdminSignature
        'Signature Management' => '回復簽名管理',
        'Add signature' => '添加回復簽名',
        'Add Signature' => '添加回復簽名',
        'Edit Signature' => '編輯回復簽名',
        'Example signature' => '簽名範例',

        # Template: AdminState
        'State Management' => '工單狀態管理',
        'Add state' => '添加工單狀態',
        'Please also update the states in SysConfig where needed.' => '請同時在SysConfig中需要地方更新這些狀態。',
        'Add State' => '添加工單狀態',
        'Edit State' => '編輯工單狀態',
        'State type' => '工單狀態類型',

        # Template: AdminSysConfig
        'SysConfig' => '系統配置',
        'Navigate by searching in %s settings' => '從%s個配置参數中進行搜索',
        'Navigate by selecting config groups' => '按配置参數分組進行瀏覽',
        'Download all system config changes' => '下載所有配置(不包括默認配置)',
        'Export settings' => '導出設置',
        'Load SysConfig settings from file' => '從指定文件加載系統配置',
        'Import settings' => '導入設置',
        'Import Settings' => '導入設置',
        'Please enter a search term to look for settings.' => '請輸入關鍵詞來查找相關的設置.',
        'Subgroup' => '子組',
        'Elements' => '元素',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => '修改配置',
        'This config item is only available in a higher config level!' =>
            '該配置項只在高級配置可用！',
        'Reset this setting' => '重置設定',
        'Error: this file could not be found.' => '錯誤：文件不存在。',
        'Error: this directory could not be found.' => '錯誤：目錄不存在。',
        'Error: an invalid value was entered.' => '錯誤：輸入無效的值。',
        'Content' => '值',
        'Remove this entry' => '刪除該條目',
        'Add entry' => '添加條目',
        'Remove entry' => '刪除條目',
        'Add new entry' => '添加新條目',
        'Delete this entry' => '刪除該條目',
        'Create new entry' => '創建新條目',
        'New group' => '新的組',
        'Group ro' => '組 ro',
        'Readonly group' => '只讀權限組',
        'New group ro' => '新的只讀權限組',
        'Loader' => '加載',
        'File to load for this frontend module' => '文件裝載界面模塊',
        'New Loader File' => '新加載文件',
        'NavBarName' => '導航欄名稱',
        'NavBar' => '導航欄',
        'LinkOption' => '鏈接選項',
        'Block' => '塊',
        'AccessKey' => '進鑰',
        'Add NavBar entry' => '添加導航欄條目',
        'Year' => '年',
        'Month' => '月',
        'Day' => '日',
        'Invalid year' => '無效的年份',
        'Invalid month' => '無效的月份',
        'Invalid day' => '無效的日期',
        'Show more' => '顯示更多',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => '郵件發送地址管理',
        'Add system address' => '添加郵件發送地址',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '對於所有接收到的郵件，如果在其郵件中的To或Cc中出現了這些郵件發送地址，則將接收到的郵件分派給郵件發送地址所指定的隊列中。',
        'Email address' => '郵件發送地址',
        'Display name' => '名稱',
        'Add System Email Address' => '添加郵件發送地址',
        'Edit System Email Address' => '編輯郵件發送地址',
        'The display name and email address will be shown on mail you send.' =>
            '郵件地址和名稱將在郵件中顯示。',

        # Template: AdminTemplate
        'Manage Templates' => '模板管理',
        'Add template' => '添加模板',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '模板中的正文幫助服務人員快速始建、回復或轉發工單。',
        'Don\'t forget to add new templates to queues.' => '别忘了將新模板指派給隊列',
        'Add Template' => '添加模板',
        'Edit Template' => '編輯模板',
        'Template' => '模板',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '模板舉例',
        'The current ticket state is' => '當前工單狀態是',
        'Your email address is' => '您的郵件地址是',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '管理模板與附件之間的關係',
        'Filter for Attachments' => '過濾附件',
        'Change Template Relations for Attachment' => '為附件指定模板',
        'Change Attachment Relations for Template' => '為模板指定附件',
        'Toggle active for all' => '切換激活全部',
        'Link %s to selected %s' => '鏈接%s到選中的%s',

        # Template: AdminType
        'Type Management' => '工單類型管理',
        'Add ticket type' => '添加工單類型',
        'Add Type' => '添加工單類型',
        'Edit Type' => '編輯工單類型',

        # Template: AdminUser
        'Add agent' => '添加服務人員',
        'Agents will be needed to handle tickets.' => '處理工單是服務人員職責。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '别忘了為服務人員指派組或角色權限！',
        'Please enter a search term to look for agents.' => '請輸入一個搜索條件以便查找服務人員。',
        'Last login' => '最後一次登錄',
        'Switch to agent' => '切換服務人員',
        'Add Agent' => '添加服務人員',
        'Edit Agent' => '編輯服務人員',
        'Firstname' => '名',
        'Lastname' => '姓',
        'Will be auto-generated if left empty.' => '如果為空，將自動生成密碼。',
        'Start' => '開始',
        'End' => '結束',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '定義服務人員的組權限',
        'Change Group Relations for Agent' => '選擇此服務人員具備的組權限',
        'Change Agent Relations for Group' => '為此組選擇服務人員的權限',
        'note' => '',
        'Permissions to add notes to tickets in this group/queue.' => '對於組/隊列具有 \'添加備註\' 的權限',
        'owner' => '',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '對於組/隊列具有 \'所有者\' 的權限',

        # Template: AgentBook
        'Address Book' => '地址簿',
        'Search for a customer' => '查找用戶',
        'Add email address %s to the To field' => '將郵件地址%s添加至To字段',
        'Add email address %s to the Cc field' => '將郵件地址%s添加至Cc字段',
        'Add email address %s to the Bcc field' => '將郵件地址%s添加至Bcc字段',
        'Apply' => '應用',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '用戶信息中心',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => '用戶編號',
        'Customer User' => '用戶',

        # Template: AgentCustomerSearch
        'Duplicated entry' => '重復條目',
        'This address already exists on the address list.' => '地址列表已有這個地址。',
        'It is going to be deleted from the field, please try again.' => '將自動刪除這個重復的地址，請再試一次。',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '注意：用戶是無效的！',

        # Template: AgentDashboard
        'Dashboard' => '儀表板',

        # Template: AgentDashboardCalendarOverview
        'in' => '之内',

        # Template: AgentDashboardCommon
        'Available Columns' => '可選擇的字段',
        'Visible Columns (order by drag & drop)' => '顯示的字段(通過拖拽可調整順序)',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '升級的工單',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '用戶信息',
        'Phone ticket' => '電話工單',
        'Email ticket' => '郵件工單',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s is 可用！',
        'Please update now.' => '請現在更新',
        'Release Note' => '版本說明',
        'Level' => '級别',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '發布於%s之前',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            '正在為您處理統計數據，請耐心等待。',
        'Grouped' => '',
        'Stacked' => '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '我鎖定的工單',
        'My watched tickets' => '我訂閱的工單',
        'My responsibilities' => '我負責的工單',
        'Tickets in My Queues' => '我隊列中的工單',
        'Service Time' => '服務時間',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '合計',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '不在辦公室',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '直至',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => '工單已鎖定',
        'Undo & close window' => '取消並關閉窗口',

        # Template: AgentInfo
        'Info' => '詳情',
        'To accept some news, a license or some changes.' => '接收新聞、許可証或者一些動態信息。',

        # Template: AgentLinkObject
        'Link Object: %s' => '連接對象: %s',
        'go to link delete screen' => '轉至刪除鏈接窗口',
        'Select Target Object' => '選擇目標對象',
        'Link Object' => '鏈接對象',
        'with' => '和',
        'Unlink Object: %s' => '取消連接對象 %s',
        'go to link add screen' => '轉至添加鏈接窗口',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => '編輯個人設置',

        # Template: AgentSpelling
        'Spell Checker' => '拼寫檢查',
        'spelling error(s)' => '拼寫錯誤',
        'Apply these changes' => '應用這些更改',

        # Template: AgentStatsDelete
        'Delete stat' => '刪除統計',
        'Stat#' => '統計#',
        'Do you really want to delete this stat?' => '您確認要刪除該統計?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => '第 %s 步',
        'General Specifications' => '一般設定',
        'Select the element that will be used at the X-axis' => '選擇X軸使用的要素',
        'Select the elements for the value series' => '選擇值系列要素',
        'Select the restrictions to characterize the stat' => '選擇限制條件',
        'Here you can make restrictions to your stat.' => '您可以為統計指定限制参數',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            '如果“固定”復選框未被選中，則可以改變相應要素的屬性。',
        'Fixed' => '固定',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '請只選擇一個元素或使“固定”復選框未被選中。',
        'Absolute Period' => '絕對時間',
        'Between' => '',
        'Relative Period' => '相對時間',
        'The last' => '過去的',
        'Finish' => '完成',

        # Template: AgentStatsEditSpecification
        'Permissions' => '權限',
        'You can select one or more groups to define access for different agents.' =>
            '可選中一個或多個組以便定義不同服務人員。',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            '部分結果格式被禁止使用。原因是至少有一個軟件包沒有安裝。',
        'Please contact your administrator.' => '請聯系系統管理員。',
        'Graph size' => '圖形尺寸',
        'If you use a graph as output format you have to select at least one graph size.' =>
            '如果您使用的是圖形的輸出格式您必須至少選擇一個圖形的大小',
        'Sum rows' => '行合計',
        'Sum columns' => '列合計',
        'Use cache' => '使用緩存',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            '大多數的統計資料可以緩存，這將提高統計報表的計算速度。',
        'Show as dashboard widget' => '作為儀表板顯示部件',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '將該統計作為部件顯示在儀表板中.',
        'Please note' => '請注意',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '啟用儀表板中的統計部件將激活統計緩存',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            '對於儀表板統計部件您只能設置相對時間',
        'IE8 doesn\'t support statistics dashboard widgets.' => 'IE8不能顯示儀表板統計部件',
        'If set to invalid end users can not generate the stat.' => '如果設置為無效，將無法生成統計。',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => '在這裡可以定義值系列。',
        'You have the possibility to select one or two elements.' => '可選擇一個或兩個要素。',
        'Then you can select the attributes of elements.' => '然後可以指定要素屬性。',
        'Each attribute will be shown as single value series.' => '每個屬性將作為單一的值系列進行顯示。',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            '如果不選擇任何屬性，生成統計時將利用元素的所有屬性，以及上次配置時添加新屬性。',
        'Scale' => '時間刻度',
        'minimal' => '時間單位',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            '請記住，這值系列的時間尺度要大於X軸的尺度（例如，X-軸 => 本月， ValueSeries => 年） ',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            '在這裡可以定義X軸。可以通過單選按鈕選擇要素。',
        'maximal period' => '時間範圍',
        'minimal scale' => '時間刻度',

        # Template: AgentStatsImport
        'Import Stat' => '導入統計',
        'File is not a Stats config' => '文件不是一個統計配置',
        'No File selected' => '沒有文件被選中',

        # Template: AgentStatsOverview
        'Stats' => '統計',

        # Template: AgentStatsPrint
        'No Element selected.' => '沒有元素被選中',

        # Template: AgentStatsView
        'Export config' => '導出配置',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            '輸入和選擇的字段將影響報表的格式和數據内容。',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            '確切說報表的格式和數據内容是由統計管理員決定的。',
        'Stat Details' => '統計詳情',
        'Format' => '格式',
        'Graphsize' => '圖形化',
        'Cache' => '緩存',
        'Exchange Axis' => '轉換軸',

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => '静態統計的配置参數',
        'No element selected.' => '沒有被選参數',
        'maximal period from' => '最大時間範圍從',
        'to' => '至',
        'not changable for dashboard statistics' => '',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => '修改工單自定義字段',
        'Change Owner of Ticket' => '更改工單所有者',
        'Close Ticket' => '關閉工單',
        'Add Note to Ticket' => '添加工單備註',
        'Set Pending' => '設置掛起狀態',
        'Change Priority of Ticket' => '修改工單優先級',
        'Change Responsible of Ticket' => '更改工單負責人',
        'All fields marked with an asterisk (*) are mandatory.' => '所有带 * 的字段都是強制要求輸入的字段.',
        'Service invalid.' => '服務無效。',
        'New Owner' => '新所有者',
        'Please set a new owner!' => '請指定新的所有者！',
        'Previous Owner' => '前一個所有者',
        'Inform Agent' => '通知服務人員',
        'Optional' => '選項',
        'Inform involved Agents' => '通知相關服務人員',
        'Spell check' => '拼寫檢查',
        'Note type' => '備註類型',
        'Next state' => '工單狀態',
        'Date invalid!' => '日期無效!',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '退回工單',
        'Bounce to' => '退回到 ',
        'You need a email address.' => '需要一個郵件地址。',
        'Need a valid email address or don\'t use a local email address.' =>
            '需要一個有效的郵件地址，同時不可以使用本地郵件地址。',
        'Next ticket state' => '工單狀態',
        'Inform sender' => '通知發送者',
        'Send mail' => '發送!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '工單批量處理',
        'Send Email' => '發送郵件',
        'Merge to' => '合併到',
        'Invalid ticket identifier!' => '無效的工單標識符!',
        'Merge to oldest' => '合併至最早提交的工單',
        'Link together' => '相互鏈接',
        'Link to parent' => '鏈接到上一級',
        'Unlock tickets' => '工單解鎖',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => '撰寫答復工單',
        'Please include at least one recipient' => '請包括至少一個收件人',
        'Remove Ticket Customer' => '刪除工單用戶',
        'Please remove this entry and enter a new one with the correct value.' =>
            '請刪除這個條目並重新輸入一個正確的值。',
        'Remove Cc' => '刪除Cc',
        'Remove Bcc' => '刪除Bcc',
        'Address book' => '地址簿',
        'Pending Date' => '掛起時間',
        'for pending* states' => '針對掛起狀態',
        'Date Invalid!' => '日期無效！',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => '更改工單用戶',
        'Customer user' => '用戶',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '創建郵件工單',
        'From queue' => '隊列',
        'To customer user' => '選擇用戶',
        'Please include at least one customer user for the ticket.' => '請包括至少一個工單用戶。',
        'Select this customer as the main customer.' => '選擇這個用戶作為主用戶',
        'Remove Ticket Customer User' => '刪除工單用戶',
        'Get all' => '獲取全部',
        'Text Template' => '文本模板',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => '歷史',
        'History Content' => '歷史内容',
        'Zoom view' => '缩放視圖',

        # Template: AgentTicketMerge
        'Ticket Merge' => '工單合並',
        'You need to use a ticket number!' => '您需要使用一個工單編號!',
        'A valid ticket number is required.' => '需要有效的工單編號。',
        'Need a valid email address.' => '需要有效的郵件地址。',

        # Template: AgentTicketMove
        'Move Ticket' => '更改工單隊列',
        'New Queue' => '新隊列',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => '選擇全部',
        'No ticket data found.' => '沒有找到工單數據。',
        'First Response Time' => '第一響應時間',
        'Update Time' => '更新時間',
        'Solution Time' => '解決時間',
        'Move ticket to a different queue' => '將工單轉移到另一個隊列',
        'Change queue' => '更改隊列',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => '修改搜索選項',
        'Remove active filters for this screen.' => '清除此屏的過濾器',
        'Tickets per page' => '工單數/頁',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',
        'Column Filters Form' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => '創建電話工單',
        'Please include at least one customer for the ticket.' => '請包括至少一個工單用戶。',
        'To queue' => '隊列',

        # Template: AgentTicketPhoneCommon

        # Template: AgentTicketPlain
        'Email Text Plain View' => '郵件純文本視圖',
        'Plain' => '純文本',
        'Download this email' => '下載該郵件',

        # Template: AgentTicketPrint
        'Ticket-Info' => '工單信息',
        'Accounted time' => '所用時間',
        'Linked-Object' => '鏈接的對象',
        'by' => '由',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '創建流程工單',
        'Process' => '流程',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => '搜索模板',
        'Create Template' => '創建模板',
        'Create New' => '創建',
        'Profile link' => '按模板搜索',
        'Save changes in template' => '保存變更為模板',
        'Add another attribute' => '增加另一個搜索條件',
        'Output' => '搜索結果顯示為',
        'Fulltext' => '全文',
        'Remove' => '刪除',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '搜索範圍覆蓋From, To, Cc, 主題和信件.',
        'Customer User Login' => '用戶登錄用戶名',
        'Created in Queue' => '隊列中創建',
        'Lock state' => '鎖定狀態',
        'Watcher' => '訂閱人',
        'Article Create Time (before/after)' => '信件創建時間(相對)',
        'Article Create Time (between)' => '信件創建時間(絕對)',
        'Ticket Create Time (before/after)' => '工單創建時間(相對)',
        'Ticket Create Time (between)' => '工單創建時間(絕對)',
        'Ticket Change Time (before/after)' => '工單更新時間(相對)',
        'Ticket Change Time (between)' => '工單更新時間(絕對)',
        'Ticket Close Time (before/after)' => '工單關閉時間(相對)',
        'Ticket Close Time (between)' => '工單關閉時間(絕對)',
        'Ticket Escalation Time (before/after)' => '工單升級時間(相對)',
        'Ticket Escalation Time (between)' => '工單升級時間(絕對)',
        'Archive Search' => '歸檔搜索',
        'Run search' => '搜索',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => '信件過濾器',
        'Article Type' => '信件類别 ',
        'Sender Type' => '發送人類型',
        'Save filter settings as default' => '將過濾器作為缺省設置並保存',
        'Archive' => '歸檔',
        'This ticket is archived.' => '該工單已歸檔',
        'Locked' => '鎖定狀態',
        'Linked Objects' => '已連接的對象',
        'Article(s)' => '信件',
        'Change Queue' => '改變隊列',
        'There are no dialogs available at this point in the process.' =>
            '目前流程中沒有環節操作。',
        'This item has no articles yet.' => '此條目沒有信件。',
        'Add Filter' => '添加過濾器',
        'Set' => '設置',
        'Reset Filter' => '重置過濾器',
        'Show one article' => '顯示單一信件',
        'Show all articles' => '顯示所有信件',
        'Unread articles' => '未讀信件',
        'No.' => '編號：',
        'Important' => '重要',
        'Unread Article!' => '未讀信件!',
        'Incoming message' => '接收的信息',
        'Outgoing message' => '發出的信息',
        'Internal message' => '内部信息',
        'Resize' => '調整大小',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '為了保護您的隱私,遠程内容被阻擋。',
        'Load blocked content.' => '載入被阻擋的内容。',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => '追溯',

        # Template: CustomerFooter
        'Powered by' => 'Powered by',
        'One or more errors occurred!' => '一個或多個錯誤!',
        'Close this dialog' => '關閉該對話',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '無法打開彈出窗口，請禁用彈出窗口攔截。',
        'There are currently no elements available to select from.' => '目前沒有可供選擇的元素。',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => '沒有啟用 JavaScript',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            '要繼續使用 OTRS，請打開瀏覽器的 JavaScript 功能.',
        'Browser Warning' => '提示',
        'The browser you are using is too old.' => '您使用的游覽器太舊了.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS 已確認下列的游覽器可正常顯示, 請挑一個您喜歡用的升級之.',
        'Please see the documentation or ask your admin for further information.' =>
            '欲了解更多信息, 請向您的管理詢問或参考相關文檔.',
        'Login' => '登錄',
        'User name' => '用戶名',
        'Your user name' => '您的用戶名',
        'Your password' => '您的密碼',
        'Forgot password?' => '密碼遺忘?',
        'Log In' => '登錄',
        'Not yet registered?' => '還未註冊?',
        'Request new password' => '請求新密碼',
        'Your User Name' => '您的用戶名',
        'A new password will be sent to your email address.' => '新密碼將會發送到您的郵箱中',
        'Create Account' => '創建帳戶',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => '稱謂',
        'Your First Name' => '名字',
        'Your Last Name' => '姓',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => '編輯個人設置',
        'Logout %s' => '退出 %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => '服務水平協議',

        # Template: CustomerTicketOverview
        'Welcome!' => '歡迎！',
        'Please click the button below to create your first ticket.' => '請點擊下面的按鈕創建第一個工單。',
        'Create your first ticket' => '創建第一個工單',

        # Template: CustomerTicketPrint
        'Ticket Print' => '工單打印',
        'Ticket Dynamic Fields' => '',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => '搜索條件',
        'e. g. 10*5155 or 105658*' => '例如: 10*5155 或 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => '工單全文搜索 (例如: "John*n" 或 "Will*")',
        'Carbon Copy' => '抄送',
        'Types' => '類型',
        'Time restrictions' => '時間查詢條件',
        'No time settings' => '',
        'Only tickets created' => '工單創建於',
        'Only tickets created between' => '工單創建自',
        'Ticket archive system' => '',
        'Save search as template?' => '將搜索保存為模板？',
        'Save as Template?' => '保存為模板',
        'Save as Template' => '保存為模板',
        'Template Name' => '模板名稱',
        'Pick a profile name' => '',
        'Output to' => '輸出為',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => '在',
        'Page' => '頁',
        'Search Results for' => '搜索結果',

        # Template: CustomerTicketZoom
        'Expand article' => '展開信件',
        'Information' => '信息',
        'Next Steps' => '下一',
        'Reply' => '回復',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
        'All-day' => '',
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
        'Ticket fields' => '工單字段',
        'Dynamic fields' => '動態字段',

        # Template: Datepicker
        'Invalid date (need a future date)!' => '無效的日期（需使用未來的日期）！',
        'Previous' => '上一步',
        'Open date selection' => '打開日歷',

        # Template: Error
        'Oops! An Error occurred.' => '糟, 發生一個錯誤.',
        'Error Message' => '出錯信息',
        'You can' => '您可以',
        'Send a bugreport' => '發送一個錯誤報告',
        'go back to the previous page' => '返回上一頁',
        'Error Details' => '詳細錯誤信息',

        # Template: Footer
        'Top of page' => '返回顶部',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '如果您現在離開該頁, 所有彈出的窗口也隨之關閉!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '一個彈出窗口已經打開，是否繼續關閉？',
        'Please enter at least one search value or * to find anything.' =>
            '請至少輸入一個搜索條件或 *。',
        'Please check the fields marked as red for valid inputs.' => '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'You are logged in as' => '您已登錄為',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript沒有啟用',
        'Database Settings' => '數據庫設置',
        'General Specifications and Mail Settings' => '一般設定和郵件配置',
        'Welcome to %s' => '歡迎使用 %s',
        'Web site' => '網址',
        'Mail check successful.' => '郵件配置檢查完成',
        'Error in the mail settings. Please correct and try again.' => '郵件設置錯誤, 請重新修正.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '外發郵件配置',
        'Outbound mail type' => '外發郵件類型',
        'Select outbound mail type.' => '選擇外發郵件類型。',
        'Outbound mail port' => '外發郵件端口',
        'Select outbound mail port.' => '選擇外發郵件端口。',
        'SMTP host' => 'SMTP服務器',
        'SMTP host.' => 'SMTP服務器。',
        'SMTP authentication' => 'SMTP認証',
        'Does your SMTP host need authentication?' => 'SMTP服務器是否需要驗証？',
        'SMTP auth user' => 'SMTP認証用戶名',
        'Username for SMTP auth.' => 'SMTP認証用戶名。',
        'SMTP auth password' => 'SMTP認証密碼',
        'Password for SMTP auth.' => 'SMTP認証密碼。',
        'Configure Inbound Mail' => '接收郵件配置',
        'Inbound mail type' => '接收郵件類型',
        'Select inbound mail type.' => '選擇接收郵件類型。',
        'Inbound mail host' => '接收郵件服務器',
        'Inbound mail host.' => '接收郵件服務器。',
        'Inbound mail user' => '接收郵件用戶名',
        'User for inbound mail.' => '接收郵件用戶名。',
        'Inbound mail password' => '接收郵件密碼',
        'Password for inbound mail.' => '接收郵件密碼',
        'Result of mail configuration check' => '郵件服務器配置檢查結果',
        'Check mail configuration' => '檢查郵件配置',
        'Skip this step' => '跳過這一步',

        # Template: InstallerDBResult
        'Database setup successful!' => '數據庫設置成功！',

        # Template: InstallerDBStart
        'Install Type' => '安裝類型',
        'Create a new database for OTRS' => '為OTRS創建新的數據庫',
        'Use an existing database for OTRS' => '使用現有的數據庫',

        # Template: InstallerDBmssql
        'Database name' => '數據庫名稱',
        'Check database settings' => '測試數據庫設置',
        'Result of database check' => '數據庫檢查結果',
        'OK' => '',
        'Database check successful.' => '數據庫檢查完成.',
        'Database User' => '數據庫用戶',
        'New' => '新建',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            '已經為OTRS系統創建了新的數據庫用戶',
        'Repeat Password' => '重復輸入密碼',
        'Generated password' => '發送自動生成的密碼',

        # Template: InstallerDBmysql
        'Passwords do not match' => '密碼不匹配',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerDBpostgresql

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            '為了能夠使用OTRS, 您必須以root身份輸入以下行在命令行中(Terminal/Shell).',
        'Restart your webserver' => '請重啟您web服務器.',
        'After doing so your OTRS is up and running.' => '完成後，您可以啟動OTRS系統了.',
        'Start page' => '開始頁面',
        'Your OTRS Team' => '您的OTRS小組.',

        # Template: InstallerLicense
        'Accept license' => '同意許可',
        'Don\'t accept license' => '不同意',

        # Template: InstallerLicenseText

        # Template: InstallerSystem
        'SystemID' => '系統ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '每個工單和HTTP會話ID包含系統標識符。',
        'System FQDN' => '系統全稱域名',
        'Fully qualified domain name of your system.' => '系統FQDN（全稱域名）',
        'AdminEmail' => '管理員地址',
        'Email address of the system administrator.' => '系統管理員郵件地址。',
        'Organization' => '組織',
        'Log' => '日誌',
        'LogModule' => '日誌模塊',
        'Log backend to use.' => '日誌後台使用。',
        'LogFile' => '日誌文件',
        'Webfrontend' => 'Web 前端',
        'Default language' => '默認語言',
        'Default language.' => '默認語言',
        'CheckMXRecord' => '檢查MX記錄',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '手動輸入的電子郵件地址將通過DNS服務器驗証MX記錄。如果DNS服務器響應慢或無法提供公網解析，請不要使用此選項。',

        # Template: LinkObject
        'Object#' => '對象#',
        'Add links' => '添加鏈接',
        'Delete links' => '刪除鏈接',

        # Template: Login
        'Lost your password?' => '忘記密碼?',
        'Request New Password' => '請求新密碼',
        'Back to login' => '重新登錄',

        # Template: Motd
        'Message of the Day' => '今日消息',

        # Template: NoPermission
        'Insufficient Rights' => '沒有足夠的權限',
        'Back to the previous page' => '返回前一頁',

        # Template: Notify

        # Template: Pagination
        'Show first page' => '首頁',
        'Show previous pages' => '前一頁',
        'Show page %s' => '第 %s 頁',
        'Show next pages' => '後一頁',
        'Show last page' => '尾頁',

        # Template: PictureUpload
        'Need FormID!' => '需要FormID',
        'No file found!' => '找不到文件！',
        'The file is not an image that can be shown inline!' => '此文件是不是一個可以顯示的圖像!',

        # Template: PrintFooter

        # Template: PrintHeader
        'printed by' => '打印',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS測試頁',
        'Welcome %s' => '歡迎 %s',
        'Counter' => '計數器',

        # Template: Warning
        'Go back to the previous page' => '返回前一頁',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'Access Control Lists (ACL)' => '訪問控制列表(ACL)',
        'AccountedTime' => '佔用時間',
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
        'Agent Notifications' => '服務人員通知',
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
        'Agent interface notification module to check the used charset.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => '服務人員 <-> 組',
        'Agents <-> Roles' => '服務人員 <-> 角色',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
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
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'ArticleTree' => '',
        'Attachments <-> Templates' => '附件 <-> 模板',
        'Auto Responses <-> Queues' => '自動回復 <-> 隊列',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
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
        'Change password' => '修改密碼',
        'Change queue!' => '轉移隊列',
        'Change the customer for this ticket' => '更改該工單用戶',
        'Change the free fields for this ticket' => '修改自定義字段',
        'Change the priority for this ticket' => '更改工單優先級',
        'Change the responsible person for this ticket' => '更改工單負責人',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '複選框',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '工單概覽“小”模式列表字段過濾器',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => '',
        'Company Tickets' => '單位工單',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '配置流程',
        'Configure and manage ACLs.' => '配置和管理ACLs',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '將HTML郵件轉換為文本信息.',
        'Create New process ticket' => '創建流程工單',
        'Create and manage Service Level Agreements (SLAs).' => '創建和管理服務品質協議(SLA)',
        'Create and manage agents.' => '創建和管理服務人員.',
        'Create and manage attachments.' => '創建和管理附件.',
        'Create and manage customer users.' => '創建和管理用戶',
        'Create and manage customers.' => '創建和管理用戶單位',
        'Create and manage dynamic fields.' => '創建和管理動態字段',
        'Create and manage event based notifications.' => '創建和管理通知(事件)',
        'Create and manage groups.' => '創建和管理組.',
        'Create and manage queues.' => '創建和管理隊列.',
        'Create and manage responses that are automatically sent.' => '創建和管理自動回復.',
        'Create and manage roles.' => '創建和管理角色.',
        'Create and manage salutations.' => '創建和管理郵件開頭的問候語.',
        'Create and manage services.' => '創建和管理服務',
        'Create and manage signatures.' => '創建和管理簽名',
        'Create and manage templates.' => '創建和管理模板',
        'Create and manage ticket priorities.' => '創建和管理工單優先級别.',
        'Create and manage ticket states.' => '創建和管理工單狀態',
        'Create and manage ticket types.' => '創建和管理工單類型. ',
        'Create and manage web services.' => '創建和管理Web服務',
        'Create new email ticket and send this out (outbound)' => '創建郵件工單並給用戶郵件',
        'Create new phone ticket (inbound)' => '創建電話工單(接電話)',
        'Create new process ticket' => '創建流程工單',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '用戶單位管理',
        'Customer Company Information' => '用戶單位信息',
        'Customer User <-> Groups' => '用戶 <-> 組',
        'Customer User <-> Services' => '用戶 <-> 服務',
        'Customer User Administration' => '用戶管理',
        'Customer Users' => '用戶',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '用戶名',
        'Customers <-> Groups' => '用戶 <-> 組',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '日期 / 時間',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
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
        'Defines a list of groups which should have the permission to see stats dashboards (e.g. group1;group2;group3).' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
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
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
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
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
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
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
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
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
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
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
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
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum size (in MB) of the log file.' => '',
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
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
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
        'Defines the parameters for the customer preferences table.' => '',
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
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
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
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
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
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
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
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
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
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '下拉',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '動態字段概覽限制',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '動態字段的個數',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
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
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => '郵件發送地址',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '啟用過濾器',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
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
        'Escalation view' => '升級視圖',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Execute SQL statements.' => '執行SQL命令',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => '過濾收到的郵件.',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => '語言介面',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => '介面風格',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => '計劃任務',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
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
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
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
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '如果啟用，所有概況(儀表板、鎖定概況、隊列概況)將在指定的間隔時間進行顯示刷新。',
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
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => '界面語言',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Link agents to groups.' => '鏈接服務人員到組.',
        'Link agents to roles.' => '鏈接服務人員到角色.',
        'Link attachments to templates.' => '鏈接附件至模板',
        'Link customer user to groups.' => '鏈接用戶至組',
        'Link customer user to services.' => '鏈接用戶至服務',
        'Link queues to auto responses.' => '鏈接隊列至自動回復',
        'Link roles to groups.' => '鏈接角色至組',
        'Link templates to queues.' => '鏈接模板至隊列',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => '',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => '管理郵件加密的PGP密鑰.',
        'Manage POP3 or IMAP accounts to fetch email from.' => '管理收取郵件的POP3或IMAP帳號.',
        'Manage S/MIME certificates for email encryption.' => '管理郵件的S/MIME加密証書.',
        'Manage existing sessions.' => '管理當前登錄會話.',
        'Manage notifications that are sent to agents.' => '管理發送給服務人員的通知',
        'Manage system registration.' => '管理系統註冊',
        'Manage tasks triggered by event or time based execution.' => '管理基於事件或時間觸發的任務',
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
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
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
        'Multiselect' => '多選',
        'My Tickets' => '我的工單',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => '創建郵件工單',
        'New phone ticket' => '創建電話工單',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => '通知(事件)',
        'Number of displayed tickets' => '顯示工單個數',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '正在處理中的工單(單位)',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => '升級工單概況',
        'Overview Refresh Time' => '概況刷新間隔',
        'Overview of all open Tickets.' => '',
        'PGP Key Management' => 'PGP密鑰管理',
        'PGP Key Upload' => '上傳PGP密鑰',
        'Parameters for .' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
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
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => '',
        'PostMaster Filters' => '收件過濾器',
        'PostMaster Mail Accounts' => '郵件接收地址',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '以矩阵的形势概述不同狀態和不同隊列的工單',
        'Queue view' => '隊列視圖',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => '刷新間隔',
        'Refresh interval' => '刷新間隔',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
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
        'Roles <-> Groups' => '角色 <-> 組',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => '上傳的S/MIME証書',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search Customer' => '搜索用戶',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => '界面主題.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '如果用戶有回復且我是此工單的所有者或者此工單在我的隊列中，請通知我。',
        'Send notifications to users.' => '給用戶和服務人員發送通知',
        'Send ticket follow up notifications' => '發送工單跟進通知',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => '為系統設置發件人的郵件地址.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent.' => '',
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
        'Sets the default link type of splitted tickets in the agent interface.' =>
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
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
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
        'Sets the size of the statistic graph.' => '',
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
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
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
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
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
        'Skin' => '皮膚',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
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
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => '統計',
        'Status view' => '狀態視圖',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Templates <-> Queues' => '模板 <-> 隊列',
        'Textarea' => '文本塊',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
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
        'Ticket Queue Overview' => '工單隊列',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => '工單一覽',
        'TicketNumber' => '工單編號',
        'Tickets' => '工單',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => '更新或安裝系統的軟件包或模塊.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => '查看性能基准測試結果.',
        'View system log messages.' => '查看系統日誌信息',
        'Wear this frontend skin' => '當前使用的皮膚',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            '您的最常用隊列，如果您設置了郵件通知，您將會得到該隊列的狀態通知.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        ' (work units)' => '(分鐘)',
        '(before/after)' => '(相對)',
        '(between)' => '(絕對)',
        'Add Customer Company' => '添加用戶單位',
        'Add Response' => '添加回復',
        'Add customer company' => '添加用戶單位',
        'Add response' => '添加回復',
        'All master tickets' => '所有主工單',
        'All slave tickets' => '所有從工單',
        'All solved tickets' => '所有已解決的工單',
        'Attachments <-> Responses' => '附件 <-> 回復',
        'BuildDate' => '創建日期',
        'BuildHost' => '創建主機',
        'CIC search for CustomerID' => '用戶ID搜索',
        'CIC search for CustomerUser' => '用戶搜索',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            '無法更改密碼，密碼至少需要個小寫和2個大寫字符！',
        'Change Attachment Relations for Response' => '為回復指定附件',
        'Change Queue Relations for Response' => '為回復指定隊列',
        'Change Response Relations for Attachment' => '為附件指定回復',
        'Change Response Relations for Queue' => '為隊列指定回復',
        'Create and manage companies.' => '創建和管理用戶單位.',
        'Create and manage response templates.' => '創建和管理回復模板.',
        'Currently only MySQL is supported in the web installer.' => 'Web安裝向導目前僅支持MySQL。',
        'Customer Company Management' => '管理用戶單位',
        'Customer Data' => '用戶數據',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            '需要建立用戶檔案以記錄服務過程，並可让用戶從自助服務界面登錄。',
        'CustomerID Search' => '單位編號搜索',
        'CustomerUser Search' => '用戶搜索',
        'CustomerUserID' => '用戶單位編號',
        'Customers <-> Services' => '用戶 <-> 服務',
        'DB host' => '數據庫服務器',
        'Database Backend' => '數據庫後台',
        'Database-User' => '數據庫用戶名',
        'Debug' => '調試',
        'Dynamic-Object' => '動態-對象',
        'Edit Response' => '編輯回復',
        'Escalation - First Response Time' => '升級 - 第一響應時間',
        'Escalation - Solution Time' => '升級 - 解決時間',
        'Escalation - Update Time' => '升級 - 更新時間',
        'Escalation in' => '升級',
        'EscalationResponseTime' => '升級響應時間',
        'EscalationSolutionTime' => '升級解決時間',
        'EscalationTime' => '升級時間',
        'EscalationUpdateTime' => '升級更新時間',
        'Events Ticket Calendar' => '工單事件日暦',
        'False' => '出錯',
        'Filter for Responses' => '過濾回復',
        'Filter name' => '過濾器名稱',
        'First you need to log in with your OTRS-ID.' => '首先需要您使用OTRS-ID進行登陸。',
        'For more info see:' => '更多信息請看',
        'Force Start' => '強制運行',
        'Framework' => '架構',
        'From customer' => '來自用戶',
        'Fulltext search' => '全文搜索',
        'Fulltext-Search' => '全文搜索',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            '如果您的數據庫有設置 root 密碼, 請在這裡輸入, 否則, 請保留空白. 出於安全考慮, 我們建議您為 root 設置一個密碼, 更多信息請参考數據庫幫助文檔.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            '如果使用其他數據庫安裝OTRS，請参考README文檔。',
        'Invokers' => '調用程序',
        'LINKED AS' => '鏈接為',
        'Link attachments to responses templates.' => '鏈接附件到回復模板.',
        'Link customers to groups.' => '鏈接用戶到組.',
        'Link customers to services.' => '鏈接用戶到服務.',
        'Link responses to queues.' => '鏈接回復模板到隊列',
        'Log file location is only needed for File-LogModule!' => '只需要為File-LogModule指定日誌文件位置!',
        'Logout successful. Thank you for using OTRS!' => '成功退出，谢谢使用!',
        'Manage Response-Queue Relations' => '管理回復與隊列的對應關系',
        'Manage Responses' => '管理回復',
        'Manage Responses <-> Attachments Relations' => '管理回復與附件的對應關系',
        'Manage periodic tasks.' => '管理周期性執行的任務.',
        'Mapping for Key' => '為鍵建立映射',
        'Master Ticket' => '主工單',
        'Master Tickets' => '主工單',
        'MasterSlave' => '主從',
        'New Master Ticket' => '新的主工單',
        'Online' => '在綫',
        'Operations' => '操作',
        'Out Of Office' => '不在辦公室',
        'Package verification failed!' => '軟件包驗証失败',
        'Password is required.' => '請輸入密碼。',
        'PendingTime' => '掛起時間',
        'Please contact your administrator!' => '請聯系系統管理員！',
        'Please enter a search term to look for customer companies.' => '請輸入一個搜索條件以查找用戶單位。',
        'Please supply a' => '請提供',
        'Please supply a first name' => '請提供您的名字',
        'Please supply a last name' => '請提供您的姓',
        'ProcessManagementActivityID' => '流程管理活動編號',
        'ProcessManagementProcessID' => '流程管理流程編號',
        'PropertiesDatabase' => '數據庫屬性',
        'Queue, filter active' => '隊列，過濾器已激活',
        'Queue, filter not active' => '隊列，過濾器未激活',
        'Responses' => '回復',
        'Responses <-> Queues' => '回復 <-> 隊列',
        'Search Result' => '搜索結果',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            '為了重新用Web 界面安裝，安全模式必須禁用',
        'Send update now' => '現在發送更新',
        'Slave Tickets' => '從工單',
        'Solved Tickets' => '已解決的工單',
        'Spam' => '垃圾',
        'Start Scheduler' => '運行調度程序',
        'State Type' => '狀態類型',
        'StateAction' => '工單狀態變化',
        'Statistic: widget' => '統計：儀表板顯示部件',
        'The following ACLs have been updated successfully:' => '以下ACLs配置已成功更新。',
        'There where errors adding/updating the following ACLs:' => '添加/更新以下ACLs時出現錯誤：',
        'URL' => '網址',
        'archive tickets' => '工單歸檔',
        'before' => '早於',
        'default \'hot\'' => '默認密碼 \'hot\'',
        'filter active' => '過濾器已激活',
        'filter not active' => '過濾器未激活',
        'restore tickets from archive' => '恢復已歸檔的工單',
        'settings' => '設置',

    };
    # $$STOP$$
    return;
}

1;
