# --
# Kernel/Language/ja.pm - provides Japanese language translation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# Copyright (C) 2010-2011 Kaz Kamimura <kamypus at yahoo.co.jp>
# Copyright (C) 2011/12/08 Kaoru Hayama TIS Inc.
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::ja;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-06-14 08:49:36

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y/%M/%D %T';
    $Self->{DateFormatLong}      = '%Y/%M/%D - %T';
    $Self->{DateFormatShort}     = '%Y/%M/%D';
    $Self->{DateInputFormat}     = '%Y/%M/%D';
    $Self->{DateInputFormatLong} = '%Y/%M/%D - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'はい',
        'No' => 'いいえ',
        'yes' => 'はい',
        'no' => 'いいえ',
        'Off' => 'オフ',
        'off' => 'オフ',
        'On' => 'オン',
        'on' => 'オン',
        'top' => '先頭',
        'end' => '最後',
        'Done' => '完了',
        'Cancel' => '取消',
        'Reset' => 'リセット',
        'last' => '以内',
        'before' => '以前',
        'Today' => '今日',
        'Tomorrow' => '明日',
        'Next week' => '',
        'day' => '日',
        'days' => '日',
        'day(s)' => '日',
        'd' => '日',
        'hour' => '時間',
        'hours' => '時間',
        'hour(s)' => '時間',
        'Hours' => '時間',
        'h' => '時間',
        'minute' => '分',
        'minutes' => '分',
        'minute(s)' => '分',
        'Minutes' => '分',
        'm' => '分',
        'month' => '月',
        'months' => '月',
        'month(s)' => '月',
        'week' => '週',
        'week(s)' => '週',
        'year' => '年',
        'years' => '年',
        'year(s)' => '年',
        'second(s)' => '秒',
        'seconds' => '秒',
        'second' => '秒',
        's' => '',
        'wrote' => '',
        'Message' => 'メッセージ',
        'Error' => 'エラー',
        'Bug Report' => 'バグ報告',
        'Attention' => '注意',
        'Warning' => '警告',
        'Module' => 'モジュール',
        'Modulefile' => 'モジュールファイル',
        'Subfunction' => 'サブファンクション',
        'Line' => '行',
        'Setting' => '設定',
        'Settings' => '設定',
        'Example' => '例',
        'Examples' => '例',
        'valid' => '有効',
        'Valid' => '有効',
        'invalid' => '無効',
        'Invalid' => '',
        '* invalid' => '* は無効です',
        'invalid-temporarily' => '無効-暫定',
        ' 2 minutes' => ' 2 分',
        ' 5 minutes' => ' 5 分',
        ' 7 minutes' => ' 7 分',
        '10 minutes' => '10 分',
        '15 minutes' => '15 分',
        'Mr.' => '',
        'Mrs.' => '',
        'Next' => '次へ',
        'Back' => '戻る',
        'Next...' => '次へ...',
        '...Back' => '...戻る',
        '-none-' => '-なし-',
        'none' => 'なし',
        'none!' => 'ありません！',
        'none - answered' => 'なし - 回答済',
        'please do not edit!' => '編集しないでください！',
        'Need Action' => '操作が必要',
        'AddLink' => '連結を追加',
        'Link' => '連結',
        'Unlink' => '連結解除',
        'Linked' => '連結済',
        'Link (Normal)' => '連結 (標準)',
        'Link (Parent)' => '連結 (親)',
        'Link (Child)' => '連結 (子)',
        'Normal' => '標準',
        'Parent' => '親',
        'Child' => '子',
        'Hit' => 'ヒット',
        'Hits' => '件',
        'Text' => '本文',
        'Standard' => 'スタンダード',
        'Lite' => 'ライト',
        'User' => 'ユーザー',
        'Username' => 'ユーザー名',
        'Language' => '言語',
        'Languages' => '言語',
        'Password' => 'パスワード',
        'Preferences' => '個人設定',
        'Salutation' => '挨拶文',
        'Salutations' => '挨拶文',
        'Signature' => '署名',
        'Signatures' => '署名',
        'Customer' => '顧客',
        'CustomerID' => '顧客ID',
        'CustomerIDs' => '顧客ID',
        'customer' => '顧客',
        'agent' => '担当者',
        'system' => 'システム',
        'Customer Info' => '顧客情報',
        'Customer Information' => '顧客情報',
        'Customer Company' => '顧客企業',
        'Customer Companies' => '顧客企業',
        'Company' => '企業名',
        'go!' => '実行！',
        'go' => '実行',
        'All' => '全て',
        'all' => '全て',
        'Sorry' => '申し訳ありません',
        'update!' => '更新！',
        'update' => '更新',
        'Update' => '更新',
        'Updated!' => '更新しました！',
        'submit!' => '送信！',
        'submit' => '送信',
        'Submit' => '送信',
        'change!' => '変更！',
        'Change' => '変更',
        'change' => '変更',
        'click here' => 'ここをクリック',
        'Comment' => 'コメント',
        'Invalid Option!' => '無効なオプションです！',
        'Invalid time!' => '無効な時間です！',
        'Invalid date!' => '無効な日付です！',
        'Name' => '名前',
        'Group' => 'グループ',
        'Description' => '説明',
        'description' => '説明',
        'Theme' => 'テーマ',
        'Created' => '作成日',
        'Created by' => '作成者',
        'Changed' => '変更日',
        'Changed by' => '変更者',
        'Search' => '検索',
        'and' => '?',
        'between' => 'この間',
        'Fulltext Search' => '全文検索',
        'Data' => 'データ',
        'Options' => 'オプション',
        'Title' => 'タイトル',
        'Item' => 'アイテム',
        'Delete' => '削除',
        'Edit' => '編集',
        'View' => '一覧',
        'Number' => '番号',
        'System' => 'システム',
        'Contact' => '連絡',
        'Contacts' => '連絡',
        'Export' => 'エクスポート',
        'Up' => '昇順',
        'Down' => '降順',
        'Add' => '追加',
        'Added!' => '追加しました！',
        'Category' => '区分',
        'Viewer' => '閲覧者',
        'Expand' => '展開',
        'Small' => '小',
        'Medium' => '中',
        'Large' => '大',
        'Date picker' => '日付抽出',
        'New message' => '新規メッセージ',
        'New message!' => '新規メッセージ！',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            '通常のキュー画面に戻るにはこのチケットに回答してください！',
        'You have %s new message(s)!' => '%s件の新規メッセージがあります！',
        'You have %s reminder ticket(s)!' => '%s件の保留期限チケットがあります',
        'The recommended charset for your language is %s!' => '選択した言語の文字コードは %s を推奨します',
        'Change your password.' => 'パスワードを変更',
        'Please activate %s first!' => '最初に %s を有効にしてください！',
        'No suggestions' => '候補なし',
        'Word' => '単語',
        'Ignore' => '無視',
        'replace with' => '置換',
        'There is no account with that login name.' => 'ログイン名に一致するアカウントはありません',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'ログインできません。ユーザー名またはパスワードを確認してください。',
        'There is no acount with that user name.' => '該当ユーザー名のアカウントはありません。',
        'Please contact your administrator' => '管理者に連絡してください',
        'Logout' => 'ログアウト',
        'Logout successful. Thank you for using %s!' => '',
        'Feature not active!' => '機能が有効になっていません！',
        'Agent updated!' => '担当者更新！',
        'Create Database' => 'データベース作成',
        'System Settings' => 'システム設定',
        'Mail Configuration' => 'メール設定',
        'Finished' => '終了しました',
        'Install OTRS' => '',
        'Intro' => '',
        'License' => 'ライセンス',
        'Database' => 'データベース',
        'Configure Mail' => '',
        'Database deleted.' => '',
        'Database setup successful!' => '',
        'Generated password' => '',
        'Login is needed!' => 'ログインしてください！',
        'Password is needed!' => 'パスワードを入力してください！',
        'Take this Customer' => 'この顧客を選択',
        'Take this User' => 'このユーザーを選択',
        'possible' => '可能',
        'reject' => '拒否',
        'reverse' => '反転',
        'Facility' => 'ファシリティ',
        'Time Zone' => 'タイムゾーン（時間帯）',
        'Pending till' => '保留時間',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'メールの宛先で振り分け',
        'Dispatching by selected Queue.' => '選択したキューで振り分け',
        'No entry found!' => '登録がありません！',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => '接続が時間切れです。再ログインしてください。',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => '権限がありません！',
        '(Click here to add)' => '(クリックして追加)',
        'Preview' => 'プレビュー',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => '',
        'Cannot create %s!' => '%s が作成できません！',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => '顧客 %s を追加しました',
        'Role added!' => '役割を追加しました！',
        'Role updated!' => '役割を更新しました！',
        'Attachment added!' => '添付ファイルを追加しました！',
        'Attachment updated!' => '添付ファイルを更新しました！',
        'Response added!' => '返答を追加しました！',
        'Response updated!' => '返答を更新しました！',
        'Group updated!' => 'グループを更新しました！',
        'Queue added!' => 'キューを追加しました！',
        'Queue updated!' => 'キューを更新しました！',
        'State added!' => '状態を追加しました！',
        'State updated!' => '状態を更新しました！',
        'Type added!' => 'タイプを追加しました！',
        'Type updated!' => 'タイプを更新しました！',
        'Customer updated!' => '顧客を更新しました！',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Mail account added!' => '',
        'Mail account updated!' => '',
        'System e-mail address added!' => '',
        'System e-mail address updated!' => '',
        'Contract' => '契約',
        'Online Customer: %s' => 'オンラインの顧客: %s',
        'Online Agent: %s' => 'オンラインの担当者: %s',
        'Calendar' => 'カレンダー',
        'File' => 'ファイル',
        'Filename' => 'ファイル名',
        'Type' => 'タイプ',
        'Size' => 'サイズ',
        'Upload' => 'アップロード',
        'Directory' => 'ディレクトリ',
        'Signed' => '署名済',
        'Sign' => '署名',
        'Crypted' => '暗号化済',
        'Crypt' => '暗号化',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP鍵',
        'PGP Keys' => 'PGP鍵',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME証明書',
        'S/MIME Certificates' => 'S/MIME証明書',
        'Office' => '事務所',
        'Phone' => '電話',
        'Fax' => 'Fax',
        'Mobile' => '携帯電話',
        'Zip' => '〒',
        'City' => '住所',
        'Street' => '建物名',
        'Country' => '国',
        'Location' => 'ロケーション',
        'installed' => 'インストール済',
        'uninstalled' => '未インストール',
        'Security Note: You should activate %s because application is already running!' =>
            'セキュリティメモ： %sを有効にしてください！アプリケーションが既に実行中です！',
        'Unable to parse repository index document.' => '',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '',
        'No packages, or no new packages, found in selected repository.' =>
            '',
        'Edit the system configuration settings.' => 'システム設定の編集',
        'printed at' => '印刷する',
        'Loading...' => '読み込み中...',
        'Dear Mr. %s,' => '%s 様',
        'Dear Mrs. %s,' => '%s 様',
        'Dear %s,' => '%s 様',
        'Hello %s,' => '%s さん',
        'This email address already exists. Please log in or reset your password.' =>
            'このemailアドレスは既に存在します。ログインするかパスワードを初期化してください。',
        'New account created. Sent login information to %s. Please check your email.' =>
            '新規アカウントを作成しました。ログイン情報を %s に送信しました。メールを確認してください。',
        'Please press Back and try again.' => '[戻る]ボタンを押してやり直してください。',
        'Sent password reset instructions. Please check your email.' => '',
        'Sent new password to %s. Please check your email.' => '新しいパスワードを %s に送信しました。メールを確認してください。',
        'Upcoming Events' => '直近のイベント',
        'Event' => 'イベント',
        'Events' => 'イベント',
        'Invalid Token!' => '無効なトークンです',
        'more' => '続き',
        'Collapse' => '',
        'Shown' => '表示',
        'Shown customer users' => '',
        'News' => 'ニュース',
        'Product News' => '製品ニュース',
        'OTRS News' => 'OTRSニュース',
        '7 Day Stats' => '週間統計',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Bold' => '太字',
        'Italic' => '斜体',
        'Underline' => '下線',
        'Font Color' => '文字色',
        'Background Color' => '背景色',
        'Remove Formatting' => '書式を削除',
        'Show/Hide Hidden Elements' => '要素を表示／非表示',
        'Align Left' => '左寄せ',
        'Align Center' => '中央揃え',
        'Align Right' => '右寄せ',
        'Justify' => '両端揃え',
        'Header' => 'ヘッダー',
        'Indent' => '字下げ',
        'Outdent' => '字下げ解除',
        'Create an Unordered List' => '番号なしリストの作成',
        'Create an Ordered List' => '番号付きリストの作成',
        'HTML Link' => 'HTMLリンク',
        'Insert Image' => '画像の挿入',
        'CTRL' => '',
        'SHIFT' => '',
        'Undo' => '元に戻す',
        'Redo' => 'やり直し',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => '',
        'International Workers\' Day' => '',
        'Christmas Eve' => '',
        'First Christmas Day' => '',
        'Second Christmas Day' => '',
        'New Year\'s Eve' => '',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

        # Template: AAAMonth
        'Jan' => '1月',
        'Feb' => '2月',
        'Mar' => '3月',
        'Apr' => '4月',
        'May' => '5月',
        'Jun' => '6月',
        'Jul' => '7月',
        'Aug' => '8月',
        'Sep' => '9月',
        'Oct' => '10月',
        'Nov' => '11月',
        'Dec' => '12月',
        'January' => '1月',
        'February' => '2月',
        'March' => '3月',
        'April' => '4月',
        'May_long' => '5月',
        'June' => '6月',
        'July' => '7月',
        'August' => '8月',
        'September' => '9月',
        'October' => '10月',
        'November' => '11月',
        'December' => '12月',

        # Template: AAAPreferences
        'Preferences updated successfully!' => '個人設定を更新しました',
        'User Profile' => 'ユーザーのプロファイル',
        'Email Settings' => 'メール設定',
        'Other Settings' => 'その他の設定',
        'Change Password' => 'パスワード変更',
        'Current password' => '',
        'New password' => '新規パスワード',
        'Verify password' => '確認パスワード',
        'Spelling Dictionary' => 'スペルチェック辞書',
        'Default spelling dictionary' => '既定のスペルチェック辞書',
        'Max. shown Tickets a page in Overview.' => '一覧時のチケット表示最大数',
        'The current password is not correct. Please try again!' => 'パスワードが正しくありません。再入力してください！',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'パスワードが更新できませんでした。新しいパスワードが一致しません。再入力してください！',
        'Can\'t update password, it contains invalid characters!' => 'パスワードが更新できませんでした。無効な文字が含まれています！',
        'Can\'t update password, it must be at least %s characters long!' =>
            'パスワードが更新できませんでした。%s は長すぎます！',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            'パスワードが更新できませんでした。英語の大文字小文字が2文字ずつ以上必要です！',
        'Can\'t update password, it must contain at least 1 digit!' => 'パスワードが更新できませんでした。数字が1文字以上必要です！',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'パスワードが更新できませんでした。2文字以上必要です！',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'パスワードが更新できませんでした。このパスワードは既に使用されています。新しいものを入力してください！',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'CSVファイル（統計と検索）で使用される区切り文字を選択します。ここで区切り文字を選択しない場合、あなたの言語のデフォルトの区切り文字が使用されます。',
        'CSV Separator' => 'CSV区切り文字',

        # Template: AAAStats
        'Stat' => '状態',
        'Sum' => '',
        'Please fill out the required fields!' => '必須項目を入力してください！',
        'Please select a file!' => 'ファイルを選択してください！',
        'Please select an object!' => '対象を選択してください！',
        'Please select a graph size!' => 'グラフサイズを選択してください！',
        'Please select one element for the X-axis!' => 'X軸の要素を一つ選択してください！',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            '要素を一つだけ選択するかオフにしてください！',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'チェックボックスの要素を選択してください！',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            '選択項目に値が入力されていません！',
        'The selected end time is before the start time!' => '開始時間を終了時間より前にしてください！',
        'You have to select one or more attributes from the select field!' =>
            '項目を1つ以上を選択してください！',
        'The selected Date isn\'t valid!' => '選択された日時が無効です',
        'Please select only one or two elements via the checkbox!' => '1つまたは2つのチェックボックスを選択してください！',
        'If you use a time scale element you can only select one element!' =>
            'タイムスケールは1つだけ選択してください！',
        'You have an error in your time selection!' => 'その時間の選択はエラーです！',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'レポートする感覚が小さすぎます。間隔をあけてください！',
        'The selected start time is before the allowed start time!' => '選択された開始時刻は許可されている時間の前です！',
        'The selected end time is after the allowed end time!' => '選択された終了時間は許可されている時間の後です！',
        'The selected time period is larger than the allowed time period!' =>
            '選択された期間は許可されている周期よりも大きいです！',
        'Common Specification' => '共通仕様',
        'X-axis' => 'X軸',
        'Value Series' => '値系列',
        'Restrictions' => '制限',
        'graph-lines' => '線グラフ',
        'graph-bars' => '棒グラフ',
        'graph-hbars' => '横棒グラフ',
        'graph-points' => '散布図',
        'graph-lines-points' => '点線グラフ',
        'graph-area' => '面積図',
        'graph-pie' => '円グラフ',
        'extended' => '拡張',
        'Agent/Owner' => '担当者／所有者',
        'Created by Agent/Owner' => '作成した担当者／所有者',
        'Created Priority' => '作成時の優先度',
        'Created State' => '作成時の状態',
        'Create Time' => '作成日時',
        'CustomerUserLogin' => '顧客ユーザーログイン',
        'Close Time' => '完了時間',
        'TicketAccumulation' => '蓄積チケット',
        'Attributes to be printed' => '印刷する属性',
        'Sort sequence' => '並べ替え順序',
        'Order by' => '順序',
        'Limit' => '制限',
        'Ticketlist' => 'チケットリスト',
        'ascending' => '昇順',
        'descending' => '降順',
        'First Lock' => '初回ロック',
        'Evaluation by' => '評価',
        'Total Time' => '合計時間',
        'Ticket Average' => 'チケット平均',
        'Ticket Min Time' => 'チケット最少時間',
        'Ticket Max Time' => 'チケット最大時間',
        'Number of Tickets' => 'チケットの数',
        'Article Average' => '記事平均',
        'Article Min Time' => '記事最少時間',
        'Article Max Time' => '記事最大時間',
        'Number of Articles' => '記事の数',
        'Accounted time by Agent' => '担当者の作業時間',
        'Ticket/Article Accounted Time' => 'チケット／記事の作業時間',
        'TicketAccountedTime' => 'チケット作業時間',
        'Ticket Create Time' => 'チケット作成時間',
        'Ticket Close Time' => 'チケット完了時間',

        # Template: AAATicket
        'Status View' => '状態一覧',
        'Bulk' => '一括',
        'Lock' => 'ロック',
        'Unlock' => 'ロック解除',
        'History' => '履歴',
        'Zoom' => '拡大',
        'Age' => '経過時間',
        'Bounce' => 'バウンス',
        'Forward' => '転送',
        'From' => '差出人',
        'To' => '宛先',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => '表題',
        'Move' => '移転',
        'Queue' => 'キュー',
        'Queues' => 'キュー',
        'Priority' => '優先度',
        'Priorities' => '優先度',
        'Priority Update' => '優先度更新',
        'Priority added!' => '',
        'Priority updated!' => '',
        'Signature added!' => '',
        'Signature updated!' => '',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'サービスレベル契約（SLA）',
        'Service Level Agreements' => 'サービスレベル契約（SLA）',
        'Service' => 'サービス',
        'Services' => 'サービス',
        'State' => '状態',
        'States' => '状態',
        'Status' => '状態',
        'Statuses' => '状態',
        'Ticket Type' => 'チケットタイプ',
        'Ticket Types' => 'チケットタイプ',
        'Compose' => '作成',
        'Pending' => '保留',
        'Owner' => '所有者',
        'Owner Update' => '所有者更新',
        'Responsible' => '応答',
        'Responsible Update' => '応答更新',
        'Sender' => '送信者',
        'Article' => '記事',
        'Ticket' => 'チケット',
        'Createtime' => '作成日時',
        'plain' => '書式なし',
        'Email' => 'メール',
        'email' => 'メール',
        'Close' => '完了',
        'Action' => '操作',
        'Attachment' => '添付ファイル',
        'Attachments' => '添付ファイル',
        'This message was written in a character set other than your own.' =>
            'このメッセージは現在使用中の文字コードではないもので書かれています。',
        'If it is not displayed correctly,' => '正しく表示されない場合、',
        'This is a' => 'これは',
        'to open it in a new window.' => '新規ウィンドウを開く',
        'This is a HTML email. Click here to show it.' => 'これはHTMLメールです。クリックで見れます。',
        'Free Fields' => '自由領域',
        'Merge' => '結合',
        'merged' => '結合済',
        'closed successful' => '完了 (成功)',
        'closed unsuccessful' => '完了 (不成功)',
        'Locked Tickets Total' => 'ロック済チケット合計',
        'Locked Tickets Reminder Reached' => 'ロック済チケット時間切れ',
        'Locked Tickets New' => 'ロック済チケット新規',
        'Responsible Tickets Total' => '応答チケット合計',
        'Responsible Tickets New' => '応答チケット新規',
        'Responsible Tickets Reminder Reached' => '応答チケット時間切れ',
        'Watched Tickets Total' => '監視チケット合計',
        'Watched Tickets New' => '監視チケット新規',
        'Watched Tickets Reminder Reached' => '監視チケット時間切れ',
        'All tickets' => '全てのチケット',
        'Available tickets' => '',
        'Escalation' => 'エスカレーション',
        'last-search' => '',
        'QueueView' => 'キュー一覧',
        'Ticket Escalation View' => 'チケットエスカレーション一覧',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => '新規',
        'open' => '対応中',
        'Open' => '対応中',
        'Open tickets' => '',
        'closed' => '完了',
        'Closed' => '完了',
        'Closed tickets' => '',
        'removed' => '削除',
        'pending reminder' => '保留 (期限付)',
        'pending auto' => '保留 (自動)',
        'pending auto close+' => '保留 (自動完了＋)',
        'pending auto close-' => '保留 (自動完了－)',
        'email-external' => 'メール-外部',
        'email-internal' => 'メール-内部',
        'note-external' => '注釈-外部',
        'note-internal' => '注釈-内部',
        'note-report' => '注釈-報告',
        'phone' => '電話',
        'sms' => 'SMS',
        'webrequest' => 'WEB要求',
        'lock' => 'ロック',
        'unlock' => 'ロック解除',
        'very low' => '最低',
        'low' => '低',
        'normal' => '中',
        'high' => '高',
        'very high' => '最高',
        '1 very low' => '1 最低',
        '2 low' => '2 低',
        '3 normal' => '3 中',
        '4 high' => '4 高',
        '5 very high' => '5 最高',
        'auto follow up' => '自動フォロー・アップ',
        'auto reject' => '自動リジェクト',
        'auto remove' => '自動除去',
        'auto reply' => '自動返答',
        'auto reply/new ticket' => '自動返答/新規チケット',
        'Ticket "%s" created!' => 'チケット "%s" を作成しました！',
        'Ticket Number' => 'チケット番号',
        'Ticket Object' => 'チケット対象',
        'No such Ticket Number "%s"! Can\'t link it!' => 'チケット番号 "%s" がありません！連結できませんでした！',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Please change the owner first.' => '',
        'Ticket selected.' => '',
        'Ticket is locked by another agent.' => '',
        'Ticket locked.' => '',
        'Don\'t show closed Tickets' => '完了チケットを非表示',
        'Show closed Tickets' => '完了チケットを表示',
        'New Article' => '新規項目',
        'Unread article(s) available' => '未読の記事があります',
        'Remove from list of watched tickets' => '監視チケットリストから削除しました',
        'Add to list of watched tickets' => '監視チケットリストに追加しました',
        'Email-Ticket' => 'メールチケット',
        'Create new Email Ticket' => '新規メールチケット作成',
        'Phone-Ticket' => '電話チケット',
        'Search Tickets' => 'チケット検索',
        'Edit Customer Users' => '顧客ユーザー編集',
        'Edit Customer Company' => '顧客企業編集',
        'Bulk Action' => '一括処理',
        'Bulk Actions on Tickets' => 'チケットへの一括処理',
        'Send Email and create a new Ticket' => 'メール送信と新規チケット作成',
        'Create new Email Ticket and send this out (Outbound)' => '新規メールチケットを作成し送信（外部）',
        'Create new Phone Ticket (Inbound)' => '新規電話チケット作成（受信）',
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
        'Overview of all open Tickets' => '全対応中チケット一覧',
        'Locked Tickets' => 'ロック済チケット',
        'My Locked Tickets' => '担当のロック済チケット',
        'My Watched Tickets' => '担当の監視チケット',
        'My Responsible Tickets' => '担当の応答チケット',
        'Watched Tickets' => '監視チケット',
        'Watched' => '監視中',
        'Watch' => '監視',
        'Unwatch' => '監視解除',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => '',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'チケットの自由入力領域を変更する',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'チケットを閲覧する',
        'Delete this ticket' => '',
        'Mark as Spam!' => '迷惑メールにする',
        'My Queues' => '担当キュー',
        'Shown Tickets' => 'チケットを表示',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'メールのチケット番号 "<OTRS_TICKET>" を "<OTRS_MERGE_TO_TICKET>" と結合しました！',
        'Ticket %s: first response time is over (%s)!' => 'チケット %s: 初回応答期限切れです(%s)！',
        'Ticket %s: first response time will be over in %s!' => 'チケット %s: 初回応答期限を超えそうです %s！',
        'Ticket %s: update time is over (%s)!' => 'チケット %s: 更新期限切れです (%s)！',
        'Ticket %s: update time will be over in %s!' => 'チケット %s: 更新期限を超えそうです %s！',
        'Ticket %s: solution time is over (%s)!' => 'チケット %s: 解決期限切れです (%s)！',
        'Ticket %s: solution time will be over in %s!' => 'チケット %s: 解決期限を超えそうです %s！',
        'There are more escalated tickets!' => '更にエスカレーションされたチケットがあります！',
        'Plain Format' => '書式なし',
        'Reply All' => '全員に返信',
        'Direction' => '方向',
        'Agent (All with write permissions)' => '',
        'Agent (Owner)' => '',
        'Agent (Responsible)' => '',
        'New ticket notification' => '新規チケット通知',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            '新規チケットが担当キューに入ったら通知を送信',
        'Send new ticket notifications' => '新規チケット通知を送信',
        'Ticket follow up notification' => '追跡チケット通知',
        'Ticket lock timeout notification' => 'ロック期限切れチケット通知',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'チケットがシステムにロック解除されたら通知を送信',
        'Send ticket lock timeout notifications' => 'ロック期限切れ通知を送信',
        'Ticket move notification' => '移転チケット通知',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            '移転チケットが担当キューに入ったら通知を送信',
        'Send ticket move notifications' => '移転チケット通知を送信',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'お気に入りのキューを選択。有効にした場合、これらのキューについてメール通知を受信します',
        'Custom Queue' => 'カスタムキュー',
        'QueueView refresh time' => 'キュー一覧自動更新間隔',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            '有効にした場合、キュー一覧は自動で指定時間後に更新されます',
        'Refresh QueueView after' => 'この時間が経過後、キュー一覧を更新',
        'Screen after new ticket' => '新規チケット作成後の画面',
        'Show this screen after I created a new ticket' => '新規チケット作成後に表示する画面',
        'Closed Tickets' => '完了チケット',
        'Show closed tickets.' => '完了チケットを見る',
        'Max. shown Tickets a page in QueueView.' => '',
        'Ticket Overview "Small" Limit' => 'チケット一覧(S)の表示数',
        'Ticket limit per page for Ticket Overview "Small"' => 'チケット一覧(S)での1ページ毎のチケット数',
        'Ticket Overview "Medium" Limit' => 'チケット一覧(M)の表示数',
        'Ticket limit per page for Ticket Overview "Medium"' => 'チケット一覧(M)の1ページ毎の表示数',
        'Ticket Overview "Preview" Limit' => 'チケット一覧(プレビュー)の表示数',
        'Ticket limit per page for Ticket Overview "Preview"' => 'チケット一覧(プレビュー)の1ページ毎の表示数',
        'Ticket watch notification' => '監視チケット通知',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'チケット所有者が受け取る通知と同じものを監視チケットにも送信',
        'Send ticket watch notifications' => '監視チケット通知を送信',
        'Out Of Office Time' => '勤務時間外',
        'New Ticket' => '新規チケット',
        'Create new Ticket' => '新規チケット作成',
        'Customer called' => '顧客が電話をかけてきた',
        'phone call' => '電話応答',
        'Phone Call Outbound' => '電話応答発信',
        'Phone Call Inbound' => '',
        'Reminder Reached' => '保留期限切れ',
        'Reminder Tickets' => '保留期限切れチケット',
        'Escalated Tickets' => 'エスカレーションチケット',
        'New Tickets' => '新規チケット',
        'Open Tickets / Need to be answered' => '対応中チケット／要対応',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            '全対応中チケット。着手済みだが応答が必要です',
        'All new tickets, these tickets have not been worked on yet' => '全新規チケット。まだ着手されていません',
        'All escalated tickets' => '全エスカレーションチケット',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '全保留チケット中、期限切れのもの',
        'Archived tickets' => '',
        'Unarchived tickets' => '',
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
        'History::TicketDynamicFieldUpdate' => '',
        'History::WebRequestCustomer' => 'Customer request via web.',
        'History::TicketLinkAdd' => 'Added link to ticket "%s".',
        'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',
        'History::SystemRequest' => 'System Request (%s).',
        'History::ResponsibleUpdate' => 'New responsible is "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => '日',
        'Mon' => '月',
        'Tue' => '火',
        'Wed' => '水',
        'Thu' => '木',
        'Fri' => '金',
        'Sat' => '土',

        # Template: AdminAttachment
        'Attachment Management' => '添付ファイル管理',
        'Actions' => '操作',
        'Go to overview' => '一覧へ移動',
        'Add attachment' => '添付ファイルを追加',
        'List' => 'リスト',
        'Validity' => '',
        'No data found.' => 'データがありません',
        'Download file' => 'ダウンロードファイル',
        'Delete this attachment' => 'この添付ファイルを削除',
        'Add Attachment' => '添付ファイルを追加',
        'Edit Attachment' => '添付ファイルを編集',
        'This field is required.' => 'この領域は必須です',
        'or' => 'または',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自動応答管理',
        'Add auto response' => '自動応答追加',
        'Add Auto Response' => '自動応答追加',
        'Edit Auto Response' => '自動応答編集',
        'Response' => '応答',
        'Auto response from' => '自動応答差出人',
        'Reference' => '用例',
        'You can use the following tags' => '次のタグを使用できます',
        'To get the first 20 character of the subject.' => '表題の最初の20文字を取得',
        'To get the first 5 lines of the email.' => 'メールの最初の5行を取得',
        'To get the realname of the sender (if given).' => '送信者の実名を取得(可能な場合)',
        'To get the article attribute' => '記事の属性を取得',
        ' e. g.' => '例',
        'Options of the current customer user data' => '現在の顧客ユーザーデータのオプション',
        'Ticket owner options' => 'チケット所有者オプション',
        'Ticket responsible options' => 'チケット応答オプション',
        'Options of the current user who requested this action' => '操作を要求された現在のユーザーのオプション',
        'Options of the ticket data' => 'チケットデータのオプション',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => '設定オプション',
        'Example response' => '応答例',

        # Template: AdminCustomerCompany
        'Customer Company Management' => '顧客企業管理',
        'Wildcards like \'*\' are allowed.' => 'ワイルドカード（*）が使用できます。',
        'Add customer company' => '顧客企業を追加',
        'Please enter a search term to look for customer companies.' => '顧客企業の検索文字を入力してください',
        'Add Customer Company' => '顧客企業を追加',

        # Template: AdminCustomerUser
        'Customer Management' => '顧客管理',
        'Back to search results' => '',
        'Add customer' => '顧客を追加',
        'Select' => '選択',
        'Hint' => 'ヒント',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            '顧客は顧客履歴の使用と顧客パネルからログインするために必要です。',
        'Please enter a search term to look for customers.' => '顧客の検索文字列を入力してください',
        'Last Login' => '最終ログイン',
        'Login as' => 'このアドレスとしてログイン',
        'Switch to customer' => '',
        'Add Customer' => '顧客を追加',
        'Edit Customer' => '顧客を編集',
        'This field is required and needs to be a valid email address.' =>
            'ここは必須領域で、有効なメールアドレスである必要があります。',
        'This email address is not allowed due to the system configuration.' =>
            'このメールアドレスはシステム設定により許可されていません。',
        'This email address failed MX check.' => 'このメールアドレスのMXレコード検査に失敗しました',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => 'このメールアドレスは正しい形式ではありません',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => '顧客－グループ関連性管理',
        'Notice' => '通知',
        'This feature is disabled!' => 'この機能は無効にされています！',
        'Just use this feature if you want to define group permissions for customers.' =>
            '顧客のグループ権限を設定する場合のみこの機能を使用できます。',
        'Enable it here!' => '有効にする',
        'Search for customers.' => '',
        'Edit Customer Default Groups' => '顧客の規定グループの編集',
        'These groups are automatically assigned to all customers.' => 'このグループは自動的にすべての顧客に割り当てられます。',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'フィルタのグループ',
        'Select the customer:group permissions.' => '顧客：グループ権限を選択',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '何も選択しない場合、このグループは権限がありません (チケットは顧客が使用できません)',
        'Search Results' => '検索結果',
        'Customers' => '顧客',
        'Groups' => 'グループ',
        'No matches found.' => '一致しませんでした。',
        'Change Group Relations for Customer' => '顧客とグループの関連性を変更',
        'Change Customer Relations for Group' => 'グループと顧客の関連性を変更',
        'Toggle %s Permission for all' => '%s の全権限を切り替え',
        'Toggle %s permission for %s' => '%s の %s 権限を切り替え',
        'Customer Default Groups:' => '顧客の規定グループ:',
        'No changes can be made to these groups.' => '変更はこれらのグループに行うことができます。',
        'ro' => '読取り',
        'Read only access to the ticket in this group/queue.' => 'このグループ／キューのチケットを読み取り専用にします。',
        'rw' => '読書き',
        'Full read and write access to the tickets in this group/queue.' =>
            'このグループ／キューのチケットに読み書きを含めた全権限を付与します。',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => '顧客－サービス関連性管理',
        'Edit default services' => '既定のサービス編集',
        'Filter for Services' => 'サービスのフィルタ',
        'Allocate Services to Customer' => 'サービスを顧客に割り当て',
        'Allocate Customers to Service' => '顧客をサービスに割り当て',
        'Toggle active state for all' => 'すべての有効な状態を切り替え',
        'Active' => '有効',
        'Toggle active state for %s' => '有効な状態 %s を切り替え',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => '順序',
        'Object' => '対象',
        'Delete this field' => '',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '',
        'Delete field' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '',
        'Field' => '',
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
        'Field type' => '',
        'Object type' => '',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => '',
        'Default value' => '規定値',
        'This is the default value for this field.' => '',
        'Save' => '保存',

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

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => '鍵',
        'Value' => '値',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => '注釈',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => '',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => '',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',

        # Template: AdminEmail
        'Admin Notification' => '管理者通知',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '本モジュールにて、管理者からエージェント、グループ、ロールメンバーへメッセージを送信することが可能です。',
        'Create Administrative Message' => '管理者メッセージを作成',
        'Your message was sent to' => '送信されたメッセージ',
        'Send message to users' => 'ユーザーにメッセージを送信',
        'Send message to group members' => 'グループのメンバーにメッセージを送信',
        'Group members need to have permission' => 'グループのメンバーは権限を持っている必要があります',
        'Send message to role members' => '役割のメンバーにメッセージを送信',
        'Also send to customers in groups' => 'さらにグループの顧客にも送信',
        'Body' => '本文',
        'Send' => '送信',

        # Template: AdminGenericAgent
        'Generic Agent' => '管理用ジョブ',
        'Add job' => 'ジョブ追加',
        'Last run' => '最終実行',
        'Run Now!' => '今すぐ実行！',
        'Delete this task' => 'このタスクを削除',
        'Run this task' => 'このタスクを実行',
        'Job Settings' => 'ジョブ設定',
        'Job name' => 'ジョブ名',
        'Currently this generic agent job will not run automatically.' =>
            '現在この一般担当者のジョブは自動実行されません。',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '自動実行を有効にするには、分、時間、日から少なくとも1つの値を選択して下さい。',
        'Schedule minutes' => 'スケジュール 分',
        'Schedule hours' => 'スケジュール 時',
        'Schedule days' => 'スケジュール 日',
        'Toggle this widget' => 'このウィジェットを切り替え',
        'Ticket Filter' => 'チケットフィルタ',
        '(e. g. 10*5155 or 105658*)' => '(例 10*5144 または 105658*)',
        '(e. g. 234321)' => '(例 234321)',
        'Customer login' => '顧客ログイン名',
        '(e. g. U5150)' => '(例 U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '記事内全文検索 (例 "Mar*in" または "Baue*")',
        'Agent' => '担当者',
        'Ticket lock' => 'チケットロック',
        'Create times' => '作成時間',
        'No create time settings.' => '作成時間を設定しない',
        'Ticket created' => 'チケットを作成したのが',
        'Ticket created between' => 'チケットを作成したのがこの期間内',
        'Change times' => '',
        'No change time settings.' => '変更時間設定がありません。',
        'Ticket changed' => 'チケットを変更しました',
        'Ticket changed between' => 'チケットの変更がこの期間の間',
        'Close times' => '完了時間',
        'No close time settings.' => '完了時間を設定しない',
        'Ticket closed' => 'チケットを完了したのが',
        'Ticket closed between' => 'チケットを完了したのがこの期間内',
        'Pending times' => '保留時間',
        'No pending time settings.' => '保留時間を設定しない',
        'Ticket pending time reached' => '保留期限切れが',
        'Ticket pending time reached between' => '保留期限切れがこの期間内',
        'Escalation times' => 'エスカレーション時間',
        'No escalation time settings.' => 'エスカレーション時間を設定しない',
        'Ticket escalation time reached' => 'エスカレーション時間到達が',
        'Ticket escalation time reached between' => 'エスカレーション時間がこの期間内',
        'Escalation - first response time' => 'エスカレーション - 初回応答期限',
        'Ticket first response time reached' => 'チケット初回応答期限が',
        'Ticket first response time reached between' => 'チケット初回応答期限がこの期間内',
        'Escalation - update time' => 'エスカレーション - 更新期限',
        'Ticket update time reached' => 'チケット更新期限が',
        'Ticket update time reached between' => 'チケット更新期限がこの期間内',
        'Escalation - solution time' => 'エスカレーション - 解決期限',
        'Ticket solution time reached' => 'チケット解決期限が',
        'Ticket solution time reached between' => 'チケット解決期限がこの期間内',
        'Archive search option' => '書庫検索オプション',
        'Ticket Action' => 'チケットの操作',
        'Set new service' => '新規サービスを設定',
        'Set new Service Level Agreement' => '新規のサービスレベル契約（SLA）を設定',
        'Set new priority' => '新規優先度を設定',
        'Set new queue' => '新規キューを設定',
        'Set new state' => '新規に状態を設定',
        'Set new agent' => '新規担当者を設定',
        'new owner' => '新規所有者',
        'new responsible' => '',
        'Set new ticket lock' => '新規チケットロックを設定',
        'New customer' => '新規顧客',
        'New customer ID' => '新規顧客ID',
        'New title' => '新規タイトル',
        'New type' => '新規タイプ',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => '書庫の選択済みチケット',
        'Add Note' => '新規注釈',
        'Time units' => '時間単位',
        '(work units)' => '(稼働時間)',
        'Ticket Commands' => 'チケットコマンド',
        'Send agent/customer notifications on changes' => '変更を担当者／顧客に通知する',
        'CMD' => 'コマンド',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'このコマンドが実行されます。チケット番号は ARG[0] 、チケットIDは ARG[1] です。',
        'Delete tickets' => 'チケット削除',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '警告: 影響を受ける全てのつけっとがデータベースから削除されます。復元することはできません！',
        'Execute Custom Module' => 'カスタムモジュールを実行',
        'Param %s key' => 'パラメータキー %s',
        'Param %s value' => 'パラメータ値 %s',
        'Save Changes' => '変更を保存',
        'Results' => '検索結果',
        '%s Tickets affected! What do you want to do?' => '%s チケットは影響を受けます。どうしますか？',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告: 削除オプションを使用します。削除された全てのチケットは消失します！',
        'Edit job' => 'ジョブ編集',
        'Run job' => 'ジョブ実行',
        'Affected Tickets' => '影響を受けるチケット',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => '時間',
        'Remote IP' => '',
        'Loading' => '読み込み中...',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => '自動更新',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Show or hide the content' => '内容の表示・非表示',
        'Clear debug log' => '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => '',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Please provide a unique name for this web service invoker.' => '',
        'The name you entered already exists.' => '',
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
        'Event Triggers' => '',
        'Asynchronous' => '',
        'Delete this event' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => '',
        'Save and finish' => '',
        'Delete this Invoker' => '',
        'Delete this Event Trigger' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => '',
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
        'Delete this Key Mapping' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => '',
        'Change operation %s' => '',
        'Do you really want to delete this operation?' => '',
        'Operation Details' => '',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => '',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => '',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => '',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'Certificate Password File' => '',
        'The password to open the SSL certificate.' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Proxy Server' => '',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => '',
        'The password for the proxy user.' => '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => '',
        'Clone web service' => '',
        'The name must be unique.' => '',
        'Clone' => '',
        'Export web service' => '',
        'Import web service' => '',
        'Configuration File' => '',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => 'インポート',
        'Configuration history' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Details' => '',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
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
        'Delete webservice' => '',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => '',
        'Import webservice' => '',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => '',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'バージョン',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => '',
        'Restore' => '',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '警告: あなたの名前を変更するグループの管理者はsysconfigの中で適切な変更を行う前にあなたの管理者パネルはロックアウトされます。この問題が発生した場合、管理するSQLステートメントごとにグループを元に戻してください',
        'Group Management' => 'グループ管理',
        'Add group' => 'グループ追加',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '管理グループは管理エリアで取得します。統計グループは統計エリアを取得します',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '統計グループは統計エリアを取得します。異なるエージェントグループへのアクセス許可を操作するには、グループを新規作成してください。（例：購買部、サポート部、営業部等）',
        'It\'s useful for ASP solutions. ' => 'ASPソリューションが便利です',
        'Add Group' => 'グループ追加',
        'Edit Group' => 'グループ編集',

        # Template: AdminLog
        'System Log' => 'システムログ',
        'Here you will find log information about your system.' => 'ここではシステムに関するログ情報が表示されます。',
        'Hide this message' => 'このメッセージを隠す',
        'Recent Log Entries' => '最近のログ一覧',

        # Template: AdminMailAccount
        'Mail Account Management' => 'メールアカウント管理',
        'Add mail account' => 'メールアカウント追加',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'アカウントで受信された全てのメールが選択したキューに振り分けられます。',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            '信頼されたアカウントの場合、受信時には既存のX-OTRSヘッダ(優先度など)が使用されます。PostMasterフィルタは常に使用されます。',
        'Host' => 'ホスト',
        'Delete account' => 'アカウント削除',
        'Fetch mail' => 'メールを取得',
        'Add Mail Account' => 'メールアカウント追加',
        'Example: mail.example.com' => '例: mail.example.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => '信頼済',
        'Dispatching' => '振り分け処理',
        'Edit Mail Account' => 'メールアカウント編集',

        # Template: AdminNavigationBar
        'Admin' => '管理',
        'Agent Management' => '担当者管理',
        'Queue Settings' => 'キュー設定',
        'Ticket Settings' => 'チケット設定',
        'System Administration' => 'システム管理',

        # Template: AdminNotification
        'Notification Management' => '通知管理',
        'Select a different language' => '別の言語を選択',
        'Filter for Notification' => '通知フィルタ',
        'Notifications are sent to an agent or a customer.' => '通知は担当者、顧客に送信されます。',
        'Notification' => '通知',
        'Edit Notification' => '通知の編集',
        'e. g.' => '例',
        'Options of the current customer data' => 'この顧客データのオプション',

        # Template: AdminNotificationEvent
        'Add notification' => '通知の追加',
        'Delete this notification' => 'この通知を削除',
        'Add Notification' => '通知の追加',
        'Recipient groups' => '受信グループ',
        'Recipient agents' => '受信担当者',
        'Recipient roles' => '受信役割',
        'Recipient email addresses' => '受信 メールアドレス',
        'Article type' => '記事タイプ',
        'Only for ArticleCreate event' => '記事作成イベントのみ',
        'Article sender type' => '',
        'Subject match' => '表題が一致',
        'Body match' => '本文が一致',
        'Include attachments to notification' => '通知が添付ファイルを含む',
        'Notification article type' => '記事タイプの通知',
        'Only for notifications to specified email addresses' => '指定メールアドレスへの通知のみ',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '表題の最初の20文字を取得 (最新の担当者記事)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '本文から最初の5行を取得 (最新の担当者記事)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '表題の最初の20文字を取得 (最新の顧客記事)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '本文から最初の5行を取得 (最新の顧客記事)',

        # Template: AdminPGP
        'PGP Management' => 'PGP管理',
        'Use this feature if you want to work with PGP keys.' => 'PGP鍵を利用される際に本機能をご利用ください。',
        'Add PGP key' => 'PGP鍵追加',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'この方法で直接SysConfigからキーリング設定を編集できます。',
        'Introduction to PGP' => 'PGPの導入',
        'Result' => '結果',
        'Identifier' => '識別子',
        'Bit' => 'ビット',
        'Fingerprint' => 'フィンガープリント',
        'Expires' => '期限切れ',
        'Delete this key' => 'この鍵を削除',
        'Add PGP Key' => 'PGP鍵を追加',
        'PGP key' => '',

        # Template: AdminPackageManager
        'Package Manager' => 'パッケージ管理',
        'Uninstall package' => 'パッケージをアンインストール',
        'Do you really want to uninstall this package?' => 'このパッケージをアンインストールしますか？',
        'Reinstall package' => 'パッケージを再インストール',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'このパッケージを再インストールしますか？ 全ての手動変更点は失われます。',
        'Continue' => '続ける',
        'Install' => 'インストール',
        'Install Package' => 'パッケージをインストール',
        'Update repository information' => 'リポジトリ情報を更新',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'オンラインリポジトリ',
        'Vendor' => 'ベンダー',
        'Module documentation' => 'モジュールの書類',
        'Upgrade' => 'アップグレード',
        'Local Repository' => 'ローカルリポジトリ',
        'Uninstall' => 'アンインストール',
        'Reinstall' => '再インストール',
        'Feature Add-Ons' => '',
        'Download package' => 'パッケージをダウンロード',
        'Rebuild package' => 'パッケージを再構成',
        'Metadata' => 'メタデータ',
        'Change Log' => '変更履歴',
        'Date' => '日付',
        'List of Files' => '領域のリスト',
        'Permission' => '権限',
        'Download' => 'ダウンロード',
        'Download file from package!' => 'パッケージからファイルをダウンロードしてください！',
        'Required' => '必要項目',
        'PrimaryKey' => 'プライマリキー',
        'AutoIncrement' => '自動増加',
        'SQL' => 'SQL',
        'File differences for file %s' => '%s ファイルが違います',

        # Template: AdminPerformanceLog
        'Performance Log' => 'パフォーマンスログ',
        'This feature is enabled!' => 'この機能を有効にする！',
        'Just use this feature if you want to log each request.' => 'この機能は各要求をログに記録したい場合のみ利用してください。',
        'Activating this feature might affect your system performance!' =>
            'この機能を有効にするとシステムのパフォーマンスに影響が出る可能性があります。',
        'Disable it here!' => '無効にする！',
        'Logfile too large!' => 'ログファイルが大きすぎます',
        'The logfile is too large, you need to reset it' => 'ログファイルが大きすぎます。初期化してください。',
        'Overview' => '一覧',
        'Range' => '範囲',
        'Interface' => 'インターフェイス',
        'Requests' => '要求',
        'Min Response' => '最少応答',
        'Max Response' => '最大応答',
        'Average Response' => '平均応答',
        'Period' => '期間',
        'Min' => '最少',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'ポストマスター・フィルタ管理',
        'Add filter' => 'フィルタの追加',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '振り分けやメールヘッダを元に受信メールをフィルタします。正規表現を使用できます。',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'メールアドレスのみを一致させたい場合、EMAILADDRESS:info@example.comを差出人、宛先、Ccに使用してください。',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '正規表現を使う場合、設定で一致する値を[***]として使用できます。',
        'Delete this filter' => 'このフィルタを削除',
        'Add PostMaster Filter' => 'ポストマスター・フィルタを追加',
        'Edit PostMaster Filter' => 'PostMasterフィルタを削除',
        'Filter name' => 'フィルタ名',
        'The name is required.' => '',
        'Stop after match' => '一致後に停止',
        'Filter Condition' => 'フィルタ条件',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'メールヘッダを設定',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => '優先度管理',
        'Add priority' => '優先度を追加',
        'Add Priority' => '優先度を追加',
        'Edit Priority' => '優先度を編集',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter' => 'フィルタ',
        'Process Name' => '',
        'Create New Process' => '',
        'Synchronize All Processes' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Copy' => '',
        'Print' => '印刷',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => '取り消してウィンドウを閉じる',
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
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
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
        'Fields' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Edit Details for Field' => '',
        'ArticleType' => '',
        'Display' => '',
        'Edit Field Details' => '',
        'Customer interface does not support internal article types.' => '',

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

        # Template: AdminProcessManagementPopupResponse

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
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => '',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Remove the Transition from this Process' => '',
        'No TransitionActions assigned.' => '',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => '',
        'Condition' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Configuration' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Remove this Field' => '',
        'Add a new Field' => '',
        'Add New Condition' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Remove this Parameter' => '',
        'Add a new Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => 'キュー管理',
        'Add queue' => 'キューを追加',
        'Add Queue' => 'キューを追加',
        'Edit Queue' => 'キューを編集',
        'Sub-queue of' => 'このサブキュー',
        'Unlock timeout' => 'ロックの解除期限',
        '0 = no unlock' => '0 = ロック解除しない',
        'Only business hours are counted.' => '勤務時間のみ計算されます',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '担当者がチケットロック後、ロック期限切れ前に完了していない場合、ロックは解除され、他の担当者がチケットを担当できるようになります。',
        'Notify by' => '通知する時間',
        '0 = no escalation' => '0 = エスカレーションしない',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'ここで定義された時間の前に、新規チケットに顧客連絡先が追加されていないか、メール送信、電話などの連絡を取っていない場合、チケットがエスカレーションされます。',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'メールでの追跡やカスタマーポータルに追加された記事があれば、エスカレーション更新期限はリセットされます。ここで定義された時間内に顧客からの外部メールや電話の記録が追加されない場合、チケットがエスカレーションされます。',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'ここで定義された時間の前にチケットが完了しない場合、チケットがエスカレーションされます。',
        'Follow up Option' => '追跡オプション',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '完了したチケットを追跡したい場合、チケットを再度対応中にするか、拒否して新規チケットにするかを指定します。',
        'Ticket lock after a follow up' => 'チケットロック後に追跡',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'チケットが完了後に顧客がチケットを追跡する場合、旧所有者にロックされます。',
        'System address' => 'システムアドレス',
        'Will be the sender address of this queue for email answers.' => 'このキューでのメール回答はこの送信者アドレスになります。',
        'Default sign key' => '既定のサインキー',
        'The salutation for email answers.' => 'メール回答の挨拶文',
        'The signature for email answers.' => 'メール回答の署名',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'キュー - 自動応答の関連性の管理',
        'Filter for Queues' => 'キューフィルタ',
        'Filter for Auto Responses' => '自動応答フィルタ',
        'Auto Responses' => '自動応答',
        'Change Auto Response Relations for Queue' => 'キューと自動応答の関連性を変更',
        'settings' => '設定',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => '応答 - キューの関連性の管理',
        'Filter for Responses' => '応答フィルタ',
        'Responses' => '応答',
        'Change Queue Relations for Response' => '応答とキューの関連性を変更',
        'Change Response Relations for Queue' => 'キューと応答の関連性を変更',

        # Template: AdminResponse
        'Manage Responses' => '応答管理',
        'Add response' => '応答を追加',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            '',
        'Don\'t forget to add new responses to queues.' => '',
        'Delete this entry' => 'この登録を削除',
        'Add Response' => '応答を登録',
        'Edit Response' => '応答を編集',
        'The current ticket state is' => '現在のチケットの状態は',
        'Your email address is' => 'あなたのメールアドレスは',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => '添付ファイル <-> 応答の関連性の管理',
        'Filter for Attachments' => '添付ファイルフィルタ',
        'Change Response Relations for Attachment' => '添付ファイルと応答の関連性を変更',
        'Change Attachment Relations for Response' => '応答と添付ファイルの関連性を変更',
        'Toggle active for all' => '全てを有効に切り替え',
        'Link %s to selected %s' => '%s と %s を連結',

        # Template: AdminRole
        'Role Management' => '役割管理',
        'Add role' => '役割を追加',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '役割を作成してグループを追加後、ユーザーに役割を追加してください。',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '未定義の役割があります。新しい役割を作成し、追加ボタンを押してください。',
        'Add Role' => '役割を追加',
        'Edit Role' => '役割を編集',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '役割 - グループの関連性管理',
        'Filter for Roles' => '役割のフィルタ',
        'Roles' => '役割',
        'Select the role:group permissions.' => '役割：グループ権限を選択。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '何も選択しなかった場合は、そのグループへ付与される許可はありません（役割に関してチケットは利用できません）',
        'Change Role Relations for Group' => 'グループと役割の関連性を変更',
        'Change Group Relations for Role' => '役割とグループの関連性を変更',
        'Toggle %s permission for all' => '全ての %s の権限を切り替え',
        'move_into' => '移動',
        'Permissions to move tickets into this group/queue.' => 'このグループ／キューにチケットの移転権限を付与',
        'create' => '作成',
        'Permissions to create tickets in this group/queue.' => 'このグループ／キューにチケットの作成権限を付与',
        'priority' => '優先度',
        'Permissions to change the ticket priority in this group/queue.' =>
            'このグループ／キューにチケットの優先度変更権限を付与',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '担当者 - 役割の関連性管理',
        'Filter for Agents' => '担当者名フィルタリング(担当者名を入力してください)',
        'Agents' => '担当者',
        'Manage Role-Agent Relations' => '役割 - 担当者の関連性管理',
        'Change Role Relations for Agent' => '担当者と役割の関連性を変更',
        'Change Agent Relations for Role' => '役割用と担当者の関連性を変更',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Add SLA' => 'SLAを追加',
        'Edit SLA' => 'SLAを編集',
        'Please write only numbers!' => '数値しか入力できません！',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'Add certificate' => '証明書の追加',
        'Add private key' => '秘密鍵の追加',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => '参照',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'この方法で直接認証と秘密鍵を編集できます。',
        'Hash' => 'ハッシュ',
        'Create' => '作成',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => 'この証明書を削除',
        'Add Certificate' => '証明書を追加',
        'Add Private Key' => '秘密鍵を追加',
        'Secret' => '秘密',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'ウィンドウを閉じる',

        # Template: AdminSalutation
        'Salutation Management' => '挨拶文管理',
        'Add salutation' => '挨拶文を追加',
        'Add Salutation' => '挨拶文を追加',
        'Edit Salutation' => '挨拶文を編集',
        'Example salutation' => '挨拶文の例',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'セキュアモードを有効にしてください！',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '初回インストール完了後、セキュアモード (通常) に設定されます',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'セキュアモードが無効の場合、アプリケーションが既に実行されているため、SysConfigを介して有効にします。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQLボックス',
        'Here you can enter SQL to send it directly to the application database.' =>
            'データベースにSQLを直接送信できます。',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            '',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '',
        'Result format' => '結果の書式',
        'Run Query' => 'クエリー実行',

        # Template: AdminService
        'Service Management' => 'サービス管理',
        'Add service' => 'サービスの追加',
        'Add Service' => 'サービスの追加',
        'Edit Service' => 'サービスの編集',
        'Sub-service of' => '親サービス',

        # Template: AdminSession
        'Session Management' => 'セッション管理',
        'All sessions' => '全セッション',
        'Agent sessions' => '担当者セッション',
        'Customer sessions' => '顧客セッション',
        'Unique agents' => '一意の担当者',
        'Unique customers' => '一意の顧客',
        'Kill all sessions' => '全セッション切断',
        'Kill this session' => '現在のセッションを切断',
        'Session' => 'セッション',
        'Kill' => '切断',
        'Detail View for SessionID' => 'セッションIDの詳細表示',

        # Template: AdminSignature
        'Signature Management' => '署名管理',
        'Add signature' => '署名を追加',
        'Add Signature' => '署名を追加',
        'Edit Signature' => '署名を編集',
        'Example signature' => '署名の例',

        # Template: AdminState
        'State Management' => '状態管理',
        'Add state' => '状態を追加',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => '状態を追加',
        'Edit State' => '状態を編集',
        'State type' => '状態のタイプ',

        # Template: AdminSysConfig
        'SysConfig' => 'システムコンフィグ',
        'Navigate by searching in %s settings' => '検索した %s の設定へ移動',
        'Navigate by selecting config groups' => '選択した設定グループへ移動',
        'Download all system config changes' => '変更された全システム設定をダウンロード',
        'Export settings' => '設定のエクスポート',
        'Load SysConfig settings from file' => 'ファイルからSysConfig設定を読み込み',
        'Import settings' => '設定のインポート',
        'Import Settings' => '設定のインポート',
        'Please enter a search term to look for settings.' => '検索設定を見て用語を入力してください。',
        'Subgroup' => 'サブグループ',
        'Elements' => '要素',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => '設定を編集',
        'This config item is only available in a higher config level!' =>
            'この項目は高設定レベルで設定できます！',
        'Reset this setting' => 'この設定をリセット',
        'Error: this file could not be found.' => 'エラー: ファイルが見つかりませんでした。',
        'Error: this directory could not be found.' => 'エラー: ディレクトリが見つかりませんでした。',
        'Error: an invalid value was entered.' => 'エラー: 無効な値が入力されました。',
        'Content' => '内容',
        'Remove this entry' => '登録を削除',
        'Add entry' => '登録を追加',
        'Remove entry' => '登録を削除',
        'Add new entry' => '新しい登録を追加',
        'Create new entry' => '新しい登録を作成',
        'New group' => '新規グループ',
        'Group ro' => 'グループ ro',
        'Readonly group' => '読み取りグループ',
        'New group ro' => '新規グループ ro',
        'Loader' => 'ローダー',
        'File to load for this frontend module' => 'このファイルからフロントエンドモジュールを読み込みます',
        'New Loader File' => '新規読み込みファイル',
        'NavBarName' => 'ナビゲーションバー名',
        'NavBar' => 'ナビゲーションバー',
        'LinkOption' => '連結オプション',
        'Block' => 'ブロック',
        'AccessKey' => 'アクセスキー',
        'Add NavBar entry' => 'ナビゲーションバーに追加',
        'Year' => '年',
        'Month' => '月',
        'Day' => '日',
        'Invalid year' => '無効な年',
        'Invalid month' => '無効な月',
        'Invalid day' => '無効な日',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'システムメールアドレスの管理',
        'Add system address' => 'システムアドレス追加',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '宛先かCcにこのアドレスを持つ全てのメールは選択されたキューに振り分けられます。',
        'Email address' => 'メールアドレス',
        'Display name' => '表示名',
        'Add System Email Address' => 'システムメールアドレスの追加',
        'Edit System Email Address' => 'システムメールアドレスの編集',
        'The display name and email address will be shown on mail you send.' =>
            '表示名、メールアドレスは送信メールに表示されます。',

        # Template: AdminType
        'Type Management' => 'タイプ管理',
        'Add ticket type' => 'チケットタイプの追加',
        'Add Type' => 'タイプの追加',
        'Edit Type' => 'タイプの編集',

        # Template: AdminUser
        'Add agent' => '担当者の追加',
        'Agents will be needed to handle tickets.' => '担当者はチケットを処理するために必要です。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '新規担当者をグループまたは役割に追加してください！',
        'Please enter a search term to look for agents.' => '担当者検索の用語を入力してください。',
        'Last login' => '最終ログイン',
        'Switch to agent' => '担当者を切り替え',
        'Add Agent' => '担当者の追加',
        'Edit Agent' => '担当者の編集',
        'Firstname' => '名',
        'Lastname' => '姓',
        'Password is required.' => '',
        'Start' => '開始',
        'End' => '終了',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '担当者 - グループの関連性の管理',
        'Change Group Relations for Agent' => '担当者とグループの関連性を変更',
        'Change Agent Relations for Group' => 'グループと担当者の関連性を変更',
        'note' => '注釈',
        'Permissions to add notes to tickets in this group/queue.' => 'このグループ／キューにチケットへ注釈追加権限を付与',
        'owner' => '所有者',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'このグループ／キューにチケットへ所有者変更権限を付与',

        # Template: AgentBook
        'Address Book' => 'アドレス帳',
        'Search for a customer' => '顧客を検索',
        'Add email address %s to the To field' => '宛先にメールアドレス %s を追加',
        'Add email address %s to the Cc field' => 'Ccにメールアドレス %s を追加',
        'Add email address %s to the Bcc field' => 'Bccにメールアドレス %s を追加',
        'Apply' => '適用',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => '顧客ID',
        'Customer User' => '顧客ユーザー',

        # Template: AgentCustomerSearch
        'Search Customer' => '顧客検索',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'ダッシュボード',

        # Template: AgentDashboardCalendarOverview
        'in' => '＞',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s が利用できます！',
        'Please update now.' => '更新してください',
        'Release Note' => 'リリースノート',
        'Level' => 'レベル',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '%s の前の投稿',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '',
        'My watched tickets' => '',
        'My responsibilities' => '',
        'Tickets in My Queues' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'チケットはロック済です',
        'Undo & close window' => '元に戻してウィンドウを閉じる',

        # Template: AgentInfo
        'Info' => '情報',
        'To accept some news, a license or some changes.' => 'ニュース、ライセンスなどの変更を受け付ける。',

        # Template: AgentLinkObject
        'Link Object: %s' => '連結対象: %s',
        'go to link delete screen' => '連結解除画面へ移動',
        'Select Target Object' => '対象を選択',
        'Link Object' => '連結対象',
        'with' => 'と',
        'Unlink Object: %s' => '連結解除対象: %s',
        'go to link add screen' => '連結画面へ移動',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => '個人設定を編集',

        # Template: AgentSpelling
        'Spell Checker' => 'スペルチェック',
        'spelling error(s)' => 'つづり間違い',
        'Apply these changes' => 'この変更を適用',

        # Template: AgentStatsDelete
        'Delete stat' => '統計を削除',
        'Stat#' => '統計番号',
        'Do you really want to delete this stat?' => 'この統計を削除してよろしいですか？',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'ステップ %s',
        'General Specifications' => '共通仕様',
        'Select the element that will be used at the X-axis' => 'X軸で使用される要素の選択',
        'Select the elements for the value series' => '系列値の要素を選択',
        'Select the restrictions to characterize the stat' => '統計の表現を選択',
        'Here you can make restrictions to your stat.' => '統計の合計値を制限することができます',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            '"Fixed"チェックボックスからフックを除外した場合、統計を生成するエージェントが対応する要素の属性を変更することができます。',
        'Fixed' => '固定',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '',
        'Absolute Period' => '絶対値',
        'Between' => 'この間',
        'Relative Period' => '相対値',
        'The last' => '最終',
        'Finish' => '完了',

        # Template: AgentStatsEditSpecification
        'Permissions' => '権限',
        'You can select one or more groups to define access for different agents.' =>
            'エージェントごとに、複数のグループを同時選択することもできます。',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            '必要なパッケージがインストールされていないため、一部の結果の形式が無効になっています。',
        'Please contact your administrator.' => 'システム管理者に連絡してください。',
        'Graph size' => 'グラフサイズ',
        'If you use a graph as output format you have to select at least one graph size.' =>
            '出力形式がグラフの場合、少なくともひとつのグラフのサイズを選択してください。',
        'Sum rows' => '行の合計',
        'Sum columns' => '列の合計',
        'Use cache' => 'キャッシュの使用',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            '統計情報はほとんどがキャッシュすることができます。この統計でのプレゼンテーションを高速化できます',
        'If set to invalid end users can not generate the stat.' => '無効なエンドユーザーに設定されている場合、統計を生成できません。',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'ここで値系列を定義できます',
        'You have the possibility to select one or two elements.' => '1つか2つの要素を選択可能です。',
        'Then you can select the attributes of elements.' => 'その後、要素の属性を選択できます。',
        'Each attribute will be shown as single value series.' => '各属性は単一の値の系列として表示されます。',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            '右の属性を何も選択しない場合、前回の環境設定で追加されたものを含めた全ての属性が、統計生成に使われます。',
        'Scale' => '目盛',
        'minimal' => '最少',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            '値系列の目盛はX軸の目盛より大きくする必要があります (例: X軸=>月、値系列=>年)',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'X軸が定義できます。ラジオボタンで1つの要素を選択してください。',
        'maximal period' => '最大単位',
        'minimal scale' => '最少目盛',

        # Template: AgentStatsImport
        'Import Stat' => '統計のインポート',
        'File is not a Stats config' => 'ファイルは統計の設定ではありません',
        'No File selected' => 'ファイルが選択されていません',

        # Template: AgentStatsOverview
        'Stats' => '統計',

        # Template: AgentStatsPrint
        'No Element selected.' => '要素が選択されていません。',

        # Template: AgentStatsView
        'Export config' => '設定のエクスポート',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            '選択した入力領域を使用すると、書式や統計内容に影響を与えます',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            '設定可能なフィールドとフォーマットは、統計の管理者によって厳密に定義されます。',
        'Stat Details' => '統計の詳細',
        'Format' => '書式',
        'Graphsize' => 'グラフのサイズ',
        'Cache' => 'キャッシュ',
        'Exchange Axis' => '縦横軸の交換',
        'Configurable params of static stat' => '静的統計情報の設定可能パラメータ',
        'No element selected.' => '要素が選択されていません。',
        'maximal period from' => '最大期間から',
        'to' => '',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'チケットの自由入力を変更',
        'Change Owner of Ticket' => 'チケットの所有者を変更',
        'Close Ticket' => 'チケットを閉じる',
        'Add Note to Ticket' => 'チケットに注釈を追加',
        'Set Pending' => '保留に設定',
        'Change Priority of Ticket' => 'チケットの優先度を変更',
        'Change Responsible of Ticket' => 'チケットの応答者を変更',
        'Service invalid.' => '無効なサービスです',
        'New Owner' => '新規所有者',
        'Please set a new owner!' => '新規所有者を設定してください！',
        'Previous Owner' => '以前の所有者',
        'Inform Agent' => '担当者に知らせる',
        'Optional' => 'オプション',
        'Inform involved Agents' => '関係担当者に知らせる',
        'Spell check' => 'スペルチェック',
        'Note type' => '注釈タイプ',
        'Next state' => '次の状態',
        'Pending date' => '保留日時',
        'Date invalid!' => '日時が無効です！',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'バウンスto',
        'You need a email address.' => 'メールアドレスが必要です',
        'Need a valid email address or don\'t use a local email address.' =>
            '有効なメールアドレスを使用するか、ローカルなメールアドレスを使用しないでください。',
        'Next ticket state' => 'チケットの次の状態',
        'Inform sender' => '送信者に知らせる',
        'Send mail!' => 'メール送信！',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'チケット一括処理',
        'Send Email' => '',
        'Merge to' => 'これと結合',
        'Invalid ticket identifier!' => '無効なチケット識別子です！',
        'Merge to oldest' => '古いものへ結合',
        'Link together' => '一緒に連結',
        'Link to parent' => '親と連結',
        'Unlock tickets' => 'チケットのロック解除',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'チケットの回答を作成',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Please include at least one recipient' => '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'アドレス帳',
        'Pending Date' => '保留期間',
        'for pending* states' => '状態:保留にする',
        'Date Invalid!' => '日時が無効です！',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'チケットの顧客を変更',
        'Customer user' => '顧客ユーザー',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '新規メールチケットの作成',
        'From queue' => 'キューから',
        'To customer' => '',
        'Please include at least one customer for the ticket.' => '',
        'Get all' => '全てを取得',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => '履歴: ',
        'History Content' => '履歴内容',
        'Zoom view' => '拡大表示',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'チケット結合',
        'You need to use a ticket number!' => '使用するチケット番号が必要です。',
        'A valid ticket number is required.' => '有効なチケット番号が必要です。',
        'Need a valid email address.' => '有効なメールアドレスが必要です。',

        # Template: AgentTicketMove
        'Move Ticket' => 'チケット移転',
        'New Queue' => '新規キュー',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => '全選択',
        'No ticket data found.' => 'チケットデータがありません',
        'First Response Time' => '初回応答期限',
        'Service Time' => 'サービス時間',
        'Update Time' => '更新期限',
        'Solution Time' => '解決期限',
        'Move ticket to a different queue' => '別のキューへチケットを移転',
        'Change queue' => 'キュー変更',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => '検索オプション変更',
        'Tickets per page' => '',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'エスカレーション: ',
        'Locked' => 'ロック状態',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => '新規電話チケットの作成',
        'From customer' => '顧客メールアドレス',
        'To queue' => 'キューへ',

        # Template: AgentTicketPhoneCommon
        'Phone call' => '電話応答',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'メールのテキスト書式表示',
        'Plain' => '書式なし',
        'Download this email' => 'このメールをダウンロード',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'チケット情報',
        'Accounted time' => '作業時間',
        'Linked-Object' => '連結対象',
        'by' => '',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => '検索テンプレート',
        'Create Template' => 'テンプレート作成',
        'Create New' => '新規作成',
        'Profile link' => '',
        'Save changes in template' => '変更したテンプレートを保存',
        'Add another attribute' => '属性を追加',
        'Output' => '出力',
        'Fulltext' => '全文',
        'Remove' => '削除',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => '顧客ユーザーログイン',
        'Created in Queue' => 'キューで作成された',
        'Lock state' => 'ロックの状態',
        'Watcher' => '監視者',
        'Article Create Time (before/after)' => '記事作成時間 (前／後)',
        'Article Create Time (between)' => '記事作成時間 (期間中)',
        'Ticket Create Time (before/after)' => 'チケット作成時間 (前／後)',
        'Ticket Create Time (between)' => 'チケット作成時間 (期間中)',
        'Ticket Change Time (before/after)' => 'チケット変更時間 (前／後)',
        'Ticket Change Time (between)' => 'チケット変更時間 (期間中)',
        'Ticket Close Time (before/after)' => 'チケット完了時間 (前／後)',
        'Ticket Close Time (between)' => 'チケット完了時間 (期間中)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => '書庫検索',
        'Run search' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => '記事フィルタ',
        'Article Type' => '記事タイプ',
        'Sender Type' => '',
        'Save filter settings as default' => '既定のフィルタ設定を保存',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Linked Objects' => '連結済対象',
        'Article(s)' => '記事',
        'Change Queue' => 'キュー変更',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Article Filter' => '記事フィルタ',
        'Add Filter' => 'フィルタ追加',
        'Set' => '設定',
        'Reset Filter' => 'フィルタをリセット',
        'Show one article' => '一つの記事を閲覧',
        'Show all articles' => '全ての記事を閲覧',
        'Unread articles' => '未読記事',
        'No.' => '番号',
        'Unread Article!' => '未読記事があります！',
        'Incoming message' => '受信メッセージ',
        'Outgoing message' => '送信メッセージ',
        'Internal message' => '内部メッセージ',
        'Resize' => 'リサイズ',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'ブロックされた内容を読み込み。',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'トレースバック',

        # Template: CustomerFooter
        'Powered by' => '',
        'One or more errors occurred!' => '一つ以上のエラーが発生しました。',
        'Close this dialog' => 'このダイアログを閉じる',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'ポップアップウィンドウを開けませんでした。アプリケーションのポップアップブロッカーを無効にしてください。',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScriptが有効になっていません。',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'OTRSを利用するにはお使いのブラウザでJavaScriptを有効にする必要があります。',
        'Browser Warning' => 'ブラウザの警告',
        'The browser you are using is too old.' => 'ご利用のブラウザは古すぎます。',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRSは次のいずれかのブラウザで実行してください。ブラウザ内で巨大なリストを使用します。',
        'Please see the documentation or ask your admin for further information.' =>
            '詳細はマニュアルを参照するか、管理者にお問い合わせください。',
        'Login' => 'ログイン',
        'User name' => 'ユーザー名',
        'Your user name' => 'ユーザー名',
        'Your password' => 'パスワード',
        'Forgot password?' => 'パスワードを忘れましたか？',
        'Log In' => 'ログイン',
        'Not yet registered?' => '未登録ですか？',
        'Sign up now' => '新規登録する',
        'Request new password' => '新規パスワードを申請',
        'Your User Name' => 'ユーザー名',
        'A new password will be sent to your email address.' => '登録されたメールアドレスに新しいパスワードを送信しました。',
        'Create Account' => 'アカウント作成',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => '',
        'Your First Name' => 'あなたの名前',
        'Your Last Name' => 'あなたの名字',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => '個人設定の編集',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'サービスレベル契約 (SLA)',

        # Template: CustomerTicketOverview
        'Welcome!' => '',
        'Please click the button below to create your first ticket.' => '',
        'Create your first ticket' => '',

        # Template: CustomerTicketPrint
        'Ticket Print' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'プロファイル',
        'e. g. 10*5155 or 105658*' => '例: 10*5155 または 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'チケット内全文検索 (例 "Max*" または "Muster*")',
        'Recipient' => '宛先',
        'Carbon Copy' => 'Cc',
        'Time restrictions' => '時間制限',
        'No time settings' => '',
        'Only tickets created' => '作成されたチケットのみ',
        'Only tickets created between' => 'この期間に作成されたチケットのみ',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => 'テンプレートを保存しますか？',
        'Save as Template' => '',
        'Template Name' => 'テンプレート名',
        'Pick a profile name' => '',
        'Output to' => '出力: ',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => '/',
        'Page' => 'ページ',
        'Search Results for' => '検索結果: ',

        # Template: CustomerTicketZoom
        'Show  article' => '',
        'Expand article' => '',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => '返信',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => '無効な日付です！ (未来の日付が必要)',
        'Previous' => '過去',
        'Sunday' => '日曜日',
        'Monday' => '月曜日',
        'Tuesday' => '火曜日',
        'Wednesday' => '水曜日',
        'Thursday' => '木曜日',
        'Friday' => '金曜日',
        'Saturday' => '土曜日',
        'Su' => '日',
        'Mo' => '月',
        'Tu' => '火',
        'We' => '水',
        'Th' => '木',
        'Fr' => '金',
        'Sa' => '土',
        'Open date selection' => '対応開始日を選択',

        # Template: Error
        'Oops! An Error occurred.' => 'エラーが発生しました！',
        'Error Message' => 'エラーメッセージ',
        'You can' => '次のことができます: ',
        'Send a bugreport' => 'バグ報告を送信',
        'go back to the previous page' => '直前のページに戻る',
        'Error Details' => 'エラー詳細',

        # Template: Footer
        'Top of page' => 'ページトップへ',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'このページから移動します。全てのポップアップウィンドウを閉じてもよろしいですか？',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '既にポップアップウィンドウを開いています。開いているウィンドウを閉じて新しく開きますか？',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'ログイン中: ',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScriptが利用できません。',
        'Database Settings' => 'データベース設定',
        'General Specifications and Mail Settings' => '共通仕様とメール設定',
        'Registration' => '',
        'Welcome to %s' => 'ようこそ %s へ',
        'Web site' => 'Webサイト',
        'Database check successful.' => 'データベースチェックに成功しました。',
        'Mail check successful.' => 'メールチェックに成功しました。',
        'Error in the mail settings. Please correct and try again.' => 'メール設定中にエラーが発生しました。再設定してください。',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '送信メール設定',
        'Outbound mail type' => '送信メールタイプ',
        'Select outbound mail type.' => '送信メールタイプを選択',
        'Outbound mail port' => '送信メールポート',
        'Select outbound mail port.' => '送信メールポートを選択',
        'SMTP host' => 'SMTPホスト',
        'SMTP host.' => 'SMTPホスト名',
        'SMTP authentication' => 'SMTP認証',
        'Does your SMTP host need authentication?' => 'SMTP認証の必要はありますか？',
        'SMTP auth user' => 'SMTP認証ユーザー',
        'Username for SMTP auth.' => 'SMTP認証で使用するユーザー名',
        'SMTP auth password' => 'SMTP認証パスワード',
        'Password for SMTP auth.' => 'SMTP認証で使用するパスワード',
        'Configure Inbound Mail' => '受信メール設定',
        'Inbound mail type' => '受信メールタイプ',
        'Select inbound mail type.' => '受信メールタイプを選択',
        'Inbound mail host' => '受信メールホスト',
        'Inbound mail host.' => '受信メールホスト名',
        'Inbound mail user' => '受信メールユーザー',
        'User for inbound mail.' => 'メールを受信するユーザー',
        'Inbound mail password' => '受信メールパスワード',
        'Password for inbound mail.' => 'メールを受信するパスワード',
        'Result of mail configuration check' => 'メール設定チェックの結果',
        'Check mail configuration' => 'メール設定チェック',
        'Skip this step' => 'この手順を飛ばす',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => '失敗',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'データベースのrootパスワードが設定されている場合、ここに入力する必要があります。されていない場合は空白にしてください。セキュリティ上の理由から、私たちはrootのパスワードを設定することをお勧めしません。詳しくはデータベースのマニュアルを参照してください。',
        'Currently only MySQL is supported in the web installer.' => '現在のインストーラーはMySQLのみサポートしています。',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'もしOTRSに違うタイプのデータベースをインストールしたい場合、README.databaseファイルを参照してください。',
        'Database-User' => 'データベースユーザー',
        'New' => '新規',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'このOTRSシステム用に限られた権限の新規データベースユーザーが作成されます。',
        'default \'hot\'' => '既定パスワード \'hot\'',
        'DB host' => 'データベース - ホスト',
        'Check database settings' => 'データベース設定をチェック',
        'Result of database check' => 'データベースチェックの結果',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'OTRSを使用するには、rootでコマンドライン上 (ターミナル／シェル) から次の行を入力する必要があります。',
        'Restart your webserver' => 'Webサーバを再起動してください。',
        'After doing so your OTRS is up and running.' => 'その後、OTRSの起動を実行してください。',
        'Start page' => 'スタートページ',
        'Your OTRS Team' => '',

        # Template: InstallerLicense
        'Accept license' => 'ライセンスに同意する',
        'Don\'t accept license' => 'ライセンスに同意しない',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => '組織',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'システムID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'システムの識別子。各チケット番号とHTTPセッションIDはこの番号が含まれます。',
        'System FQDN' => 'システムのFQDN',
        'Fully qualified domain name of your system.' => 'システムのFQDN',
        'AdminEmail' => '管理者メール',
        'Email address of the system administrator.' => 'システム管理者のメールアドレス',
        'Log' => 'ログ',
        'LogModule' => 'ログモジュール',
        'Log backend to use.' => 'ログバックエンドを使用するには',
        'LogFile' => 'ログファイル',
        'Log file location is only needed for File-LogModule!' => 'File-LogModuleのためにログファイルの場所が必要です。',
        'Webfrontend' => 'Webフロントエンド',
        'Default language' => '既定の言語',
        'Default language.' => '既定の言語。',
        'CheckMXRecord' => 'MXレコードのチェック',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '入力されたメールアドレスがDNSのMXレコードと照合されます。利用しているDNSが遅い場合、または公開アドレスが解決できない場合はこのオプションを使用しないでください。',

        # Template: LinkObject
        'Object#' => '対象の番号',
        'Add links' => '連結を追加',
        'Delete links' => '連結を削除',

        # Template: Login
        'Lost your password?' => 'パスワードを忘れた方',
        'Request New Password' => '新規パスワードを申請',
        'Back to login' => 'ログイン画面に戻る',

        # Template: Motd
        'Message of the Day' => '今日のメッセージ',

        # Template: NoPermission
        'Insufficient Rights' => '権限がありません',
        'Back to the previous page' => '前のページに戻る。',

        # Template: Notify

        # Template: Pagination
        'Show first page' => '最初のページを表示',
        'Show previous pages' => '前のページを表示',
        'Show page %s' => '%s ページを表示',
        'Show next pages' => '次のページを表示',
        'Show last page' => '最後のページを表示',

        # Template: PictureUpload
        'Need FormID!' => '',
        'No file found!' => '',
        'The file is not an image that can be shown inline!' => '',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => '',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS テストページ',
        'Welcome %s' => 'ようこそ %s へ',
        'Counter' => 'カウンター',

        # Template: Warning
        'Go back to the previous page' => '前のページへ戻る',

        # SysConfig
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '親チケットについて、その全ての子チケットがすでにクローズされている場合にのみ、クローズすることを許可するACLモジュールです（“State”は、全ての子チケットがクローズされるまで、親チケットにどの状態が適用不可であるかを示しています）。',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '最も古いチケットを含むキューの、点滅メカニズムを有効にします。',
        'Activates lost password feature for agents, in the agent interface.' =>
            '担当者インタフェースにおいて、パスワード忘れ機能を有効にします。',
        'Activates lost password feature for customers.' => '顧客に関する、パスワード忘れ機能を有効にします。',
        'Activates support for customer groups.' => '顧客グループのためのサポートを有効にします。',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'ズーム・ビューで、どの項目を表示するか特定するために項目フィルタを有効にします。',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'システムで利用可能なテーマをアクティベートします。値1がアクティブ、0が非アクティブを意味します。',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'チケット・アーカイブ・システムを有効にすることで、チケットの一部をデイリーの範囲から外し、システムのスピードを速くします。これらのチケットを検索する際には、チケット検索においてアーカイブ・フラッグを有効にする必要があります。',
        'Activates time accounting.' => 'タイム・アカウンティングを有効にします。',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'OTRSログ・ファイルに対して、実際の年と月による接尾辞を追加します。毎月のログファイルが作成されます。',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '一度だけの休日を追加します。数字は1～9までの単純な数字のパターンを使用してください（01～09ではない）。',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '定常的な休日を追加します。数字は1～9までの単純な数字のパターンを使用してください（01～09ではない）。',
        'Agent Notifications' => '担当者通知',
        'Agent interface article notification module to check PGP.' => 'PGPをチェックするための、担当者インタフェースの項目通知のモジュールです。',
        'Agent interface article notification module to check S/MIME.' =>
            'S/MIME-Keyが利用可能かつtrueである場合、Ticket-Zoom-Viewで受信Eメールをチェックする、担当者インタフェースのモジュールです。',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'nav barを通じてフル・テキスト検索にアクセスするための、担当者インタフェースのモジュールです。',
        'Agent interface module to access search profiles via nav bar.' =>
            'nav barを通じて検索プロファイルにアクセスするための、担当者インタフェースのモジュールです。',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'S/MIME-Keyが利用可能かつtrueである場合、Ticket-Zoom-Viewで受信Eメールをチェックする、担当者インタフェースのモジュールです。',
        'Agent interface notification module to check the used charset.' =>
            '使用されている文字セットを確認するための、担当者インタフェース通知モジュールです。',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '1人の担当者が責任を有するチケットの数を見るための、担当者インタフェース通知モジュールです。',
        'Agent interface notification module to see the number of watched tickets.' =>
            '監視されているチケットの数を見るための、担当者インタフェース通知モジュールです。',
        'Agents <-> Groups' => '担当者 <-> グループ',
        'Agents <-> Roles' => '担当者 <-> 役割',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、ノートの追加を許可します。',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、ノート追加を許可します。',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、ノートの追加を許可します。',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、ノートの追加を許可します。',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、注釈の追加を許可します。',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、ノートの追加を許可します。',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、ノートの追加を許可します。',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '',
        'Allows agents to generate individual-related stats.' => '担当者が、個別に関連する（individual-related）統計を生成できるようにします。',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'チケットの添付をブラウザに表示するか（インライン）、単にダウンロードできるようにするか（アタッチメント）、選択できるようにします。',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '顧客インタフェースで、顧客チケットに関する次の構成（compose）状態を選択することを許可します。',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '顧客が顧客インタフェースでチケット優先度を設定することを、許可します。',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '顧客が顧客インタフェースでチケットSLAを設定することを、許可します。',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '顧客が顧客インタフェースでチケット優先度を設定することを、許可します。',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '顧客が顧客インタフェースでチケット・キューを設定することを、許可します。‘No’に設定した場合、QueueDefaultを設定する必要があります。',
        'Allows customers to set the ticket service in the customer interface.' =>
            '顧客が顧客インタフェースでチケット・サービスを設定することを、許可します。',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'チケットに関して新規タイプを定義することを許可します（チケット責任者機能が有効となっている場合）。',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'チケットに関するサービスおよびSLA（例：email, desktop, network, ...)、およびSLAのエスカレーション属性を定義することを、許可します（チケット・サービス/SLA機能が有効となっている場合）。',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '顧客インタフェースのチケット検索で、検索条件の拡張を許可します。この機能により、利用者はw. g.を次のような条件で検索できます"(key1&&key2)" または "(key1||key2)"。',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '中程度のフォーマットでのチケット一覧の表示を許可します（CustomerInfo => 1 - 顧客情報も表示します)。',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '小さいフォーマットでのチケット一覧の表示を許可します（CustomerInfo => 1 - 顧客情報も表示します)。',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '管理者が、ユーザ管理パネルを通じて、別のユーザとしてログインすることを許可します。',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '担当者インタフェースの移動チケット画面で、新しいチケット状態を設定することを許可します。',
        'ArticleTree' => '',
        'Attachments <-> Responses' => '添付ファイル <-> 応答',
        'Auto Responses <-> Queues' => '自動応答 <-> キュー',
        'Automated line break in text messages after x number of chars.' =>
            'X個の文字型の後の、テキスト・メッセージにおける自動化されたライン・ブレイク。',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'バルク・アクションのために選択した後に、所有者をロックし現在のAgentに設定します。',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'チケット所有者を、自動的にそのチケットの責任者として設定します（チケット責任者機能が有効となっている場合）。',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '1人目の所有者のアップデートの後、自動的にチケットの責任者を設定します（もし、また設定されていなければ）。',
        'Balanced white skin by Felix Niklas.' => 'Felix Niklasによるバランスト・ホワイト・スキンです。',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '件名に有効なチケット番号を持たない全ての受信メールを、From: @example.com addressを用いてブロックします。',
        'Builds an article index right after the article\'s creation.' =>
            '項目作成の直後に、項目インデックスをビルドします。',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD例のセットアップです。外部CMDがSTDOUTにおいてアウトプットを戻してくる場合にEメールを無視します（Eメールは、STDIN of some.binへとパイプされます）。',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'パスワード変更',
        'Change queue!' => '',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '全員に対して、チケット所有者の変更を行います（ASPにおいて便利です）。通常は、チケットのキューにおいてrw許可を持つ担当者のみが、表示されます。',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'チケット番号ディテクションの中のシステムIDを、フォロー・アップのために確認します（もし、システムIDがシステム利用後に変更されていた場合は“No”を使用してください）。',
        'Closed tickets of customer' => '',
        'Comment for new history entries in the customer interface.' => '顧客インタフェースの新規履歴エントリーのためのコメントです。',
        'Company Status' => '',
        'Company Tickets' => '企業チケット',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure your own log text for PGP.' => 'PGPのための利用者独自のログテキストを設定します。',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '顧客が自らのチケットをソートする機能を持つかどうかを、コントロールします。',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'HTMLメールをテキストメッセージに変換',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'サービスレベル契約 (SLA) の作成と管理',
        'Create and manage agents.' => '担当者の作成と管理',
        'Create and manage attachments.' => '添付ファイルの作成と管理',
        'Create and manage companies.' => '企業の作成と管理',
        'Create and manage customers.' => '顧客の作成と管理',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => 'イベント経由通知の作成と管理',
        'Create and manage groups.' => 'グループの作成と管理',
        'Create and manage queues.' => 'キューの作成と管理',
        'Create and manage response templates.' => '応答テンプレートの作成と管理',
        'Create and manage responses that are automatically sent.' => '自動送信する応答の作成と管理',
        'Create and manage roles.' => '役割の作成と管理',
        'Create and manage salutations.' => '挨拶文の作成と管理',
        'Create and manage services.' => 'サービスの作成と管理',
        'Create and manage signatures.' => '署名の作成と管理',
        'Create and manage ticket priorities.' => 'チケット優先度の作成と管理',
        'Create and manage ticket states.' => 'チケット状態の作成と管理',
        'Create and manage ticket types.' => 'チケットタイプの作成と管理',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => '新規メールチケットと外部送信の作成',
        'Create new phone ticket (inbound)' => '新規受信電話チケットの作成',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '顧客に対して表示されるチケットがまだ無いページのための、カスタム・テキストです。',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => '顧客ユーザー',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => '顧客 <-> グループ',
        'Customers <-> Services' => '顧客 <-> サービス',
        'Data used to export the search result in CSV format.' => '検索結果をCSVフォーマットでエクスポートするために使用されるデータです。',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '翻訳セットのデバッグです。“Yes”にセットした場合、翻訳の無い全ての文字列（テキスト）がSTDERRに書かれます。これは、新しく翻訳ファイルを作成している場合に役立ちます。そうでなければ“No”のままにしてください。',
        'Default ACL values for ticket actions.' => 'チケット・アクションに関するデフォルトのACLの値です。',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'デフォルトのループ・プロテクション・モジュールです。',
        'Default queue ID used by the system in the agent interface.' => '担当者インタフェースにおいて、システムによって使用されるデフォルトのキューIDです。',
        'Default skin for OTRS 3.0 interface.' => 'OTRS 3.0インタフェースのデフォルトのスキンです。',
        'Default skin for interface.' => 'インタフェースのためのデフォルトのスキンです。',
        'Default ticket ID used by the system in the agent interface.' =>
            '担当者インタフェースにおいて、システムによって使用されるデフォルトのチケットIDです。',
        'Default ticket ID used by the system in the customer interface.' =>
            '顧客インタフェースで、システムによって使用されるデフォルトのチケットIDです。',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定義された文字列（string）の後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => '日付ピッカーにおける週の開始曜日を設定します。',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '顧客情報ブロックの最後において、LinkedInアイコンを作成するための顧客アイテムを定義します。',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '顧客情報ブロックの最後において、XINGアイコンを作成するための顧客アイテムを定義します。',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '顧客情報ブロックの最後において、Googleマップのアイコンを作成するための顧客アイテムを定義します。',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '顧客情報ブロックの最後において、Googleマップのアイコンを作成するための顧客アイテムを定義します。',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'スペル・チェッカーから無視される、デフォルトのワード・リストを定義します。',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'CVEナンバーの後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'MSBulletinナンバーの後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定義された文字列（string）の後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'バグトラック・ナンバーの後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '事前定義されたキーワードをハイライトするため、項目の中のテキストを処理するフィルタを定義します。',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '一部のアドレスをシンタクスのチェックから除外する、通常の表現を定義します（"CheckEmailAddresses"が“Yes”に設定されている場合）。このフィールドに、構文的には有効でないがシステムには必要であるEメールアドレス（例："root@localhost"）に関するregrexを入力してください。',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'アプリケーションで使用されるべきではない全Eメール・アドレスをフィルタするための、一般表現を定義します。',
        'Defines a useful module to load specific user options or to display news.' =>
            '特定のユーザ・オプションをロードしたり、ニュースを表示したりするための、役に立つモジュールを定義します。',
        'Defines all the X-headers that should be scanned.' => 'スキャンされるべき全てのX－ヘッダーを定義します。',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'アプリケーションに関して利用可能な全言語を定義します。Key/Contentのペアは、フロント・エンドに表示される名前を、適切な言語PMファイルにリンクさせています。“Key”バリューは、PMファイルのbase-nameとしてください（例：de.pmがファイルであれば、deが“Key”バリューとなります）。”Content“バリューは、フロント・エンドのための表示名としてください。独自に定義した言語は全てここで特定してください（さらに詳細な情報については、開発者ドキュメントを参照くださいhttp://doc.otrs.org/）。non-ASCII文字については、HTML相応のものを使用してください(例：ドイツ語のoe = o umlautオーウムラウトについては、&ouml; symbolの使用が必要となります)。',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '顧客インタフェースの顧客プレファレンスにおいて、RefreshTimeオブジェクトのための全パラメータを定義します。',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '顧客インタフェースの顧客プレファレンスにおいて、ShownTicketsオブジェクトのための全パラメータを定義します。',
        'Defines all the parameters for this item in the customer preferences.' =>
            '顧客プレファレンスにおいて、本アイテムの全パラメータを定義してください。',
        'Defines all the possible stats output formats.' => '全ての可能な統計アウトプットのフォーマットを定義します。',
        'Defines an alternate URL, where the login link refers to.' => 'ログイン・リンクが参照する、代替URLを定義します。',
        'Defines an alternate URL, where the logout link refers to.' => 'ログアウト・リンクが参照する、代替URLを定義します。',
        'Defines an alternate login URL for the customer panel..' => '顧客パネルのための代替ログインURLを定義します。',
        'Defines an alternate logout URL for the customer panel.' => '顧客パネルのための代替ログアウトURLを定義します。',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'EメールのFromフィールドについて（回答およびEメールチケットからの目標）が、どのように見えるべきかを定義します。',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのクローズ・チケット画面で、チケット・ロックが必要とされるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者に設定されます）。',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースで、チケット・バウンス画面でチケットのロックが要求されるかどうかを定義します（まだチケットがロックされていなければ、チケットはロックされ現在の担当者が自動的に所有者に設定されます）。',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのチケット構成画面で、チケット・ロックが要求されるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのチケット転送画面で、チケット・ロックが必要とされるかどうかを定義します。（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのチケット・フリー・テキスト画面で、チケット・ロックが必要であるかどうかを設定します。（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのチケット・ノート画面で、チケット・ロックが必要とされるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、チケット・ロックが必要とされるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、チケット・ロックが必要とされるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、チケット・ロックが必要かどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、チケット・ロックが必要とされるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのチケット責任者画面で、チケット・ロックが必要とされるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースで、チケットの顧客を変更するためにチケットのロックが必要かどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '担当者インタフェースにおいて、構成されたメッセージが必ずスペル・チェックされるかどうかを定義します。',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '担当者インタフェースにおいてタイム・アカウンティングが強制的かどうかを定義します。',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'タイム・アカウンティングがバルク・アクションにおける全てのチケットに対して、必ず設定されるかどうかを定義します。',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'ローカル・レポジトリにアクセスするための、IPの正規表現を定義します。ローカル・レポジトリにアクセスするために、これを有効にする必要があり、またpackage::RepositoryListはリモート・ホストにおいて必要とされます。',
        'Defines the URL CSS path.' => 'URL・CSパスを定義します。',
        'Defines the URL base path of icons, CSS and Java Script.' => 'アイコン、CSS、Java ScriptのURLベースのパスを定義します。',
        'Defines the URL image path of icons for navigation.' => 'ナビゲーションのためのアイコンのURLイメージ・パスを定義します。',
        'Defines the URL java script path.' => 'URL Java Scriptパスを定義します。',
        'Defines the URL rich text editor path.' => 'URLリッチテキスト・エディター・パスを定義します。',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '必要な場合には"CheckMXRecord"検索のための、専用DNSサーバのアドレスを定義します。',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '新しいパスワードに関して、担当者に送信される通知メールの本文テキストを定義します（本リンクを使用した後に、新しいパスワードが送信されます）。',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '新規にリクエストされたパスワードに関するトークンと共に、担当者に送信される通知メールの本文テキストを定義します（本リンクを使用した後に、新しいパスワードが送信されます）。',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '新アカウントについて、顧客に送信される通知メールの本文テキストを定義します。',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '新パスワードについて、顧客に送信される通知メールの本文テキストを定義します（本リンクが使用された後に、新しいパスワードが送信されます）。',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '新しくリクエストされたパスワードに関するトークンと共に、顧客に送信される通知メールの本文テキストとを定義します（本リンクが使用された後に、新しいパスワードが送信されます）。',
        'Defines the body text for rejected emails.' => 'リジェクトされたEメールの本文を定義します。',
        'Defines the boldness of the line drawed by the graph.' => 'グラフによって描かれる線の太さを定義します。',
        'Defines the colors for the graphs.' => 'グラフの色を定義します。',
        'Defines the column to store the keys for the preferences table.' =>
            'プレファレンス・テーブルのためのキーを格納するコラムを定義してください。',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '本アイテムのコンフィグ・パラメータを、プレファレンス・ビューで表示されるように定義します。',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '本アイテムのコンフィグ・パラメータを、プレファレンス・ビューで表示されるように定義します。データ・セクションにおいては、システムにインストールされたディクショナリを保持するよう注意してください。',
        'Defines the connections for http/ftp, via a proxy.' => 'プロキシ経由で、http/ftpのための接続を定義します。',
        'Defines the date input format used in forms (option or input fields).' =>
            'フォームで使用されるデータ・インプット・フォーマットを定義します（オプションまたはインプット・フィールド）。',
        'Defines the default CSS used in rich text editors.' => 'リッチテキスト・エディターで使用されるデフォルトCSSを定義します。',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、ノートのデフォルトの本文を定義します。',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'デフォルトのフロント・エンド（HTML）のテーマを、担当者および顧客によって使用できるように定義します。デフォルトのテーマは、Standard and Liteです。お望みであれば、独自にテーマを追加することもできます。管理者用マニュアルを参照ください。http://doc.otrs.org/',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'デフォルトのフロント・エンドの言語を設定します。全ての可能性ある値は、システムの利用可能な言語ファイルによって定義されます（次の設定を参照ください)。.',
        'Defines the default history type in the customer interface.' => '顧客インタフェースのデフォルトの履歴タイプを定義します。',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'タイム・スケールに関するX軸属性の、デフォルト最大数を定義します。',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '一覧ページに表示される、検索結果のデフォルト最大数を定義します。',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            '顧客インタフェースで、顧客フォロー・アップの後のチケットに関してデフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、チケットのノートを追加した後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、チケットのノートを追加した後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、ノートを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、ノートを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、ノートを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、注釈を追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、ノートを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、ノートを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '担当者インタフェースのチケット・バウンス画面で、チケットがバウンスされた後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '担当者インタフェースのチケット転送画面で、チケットの転送された後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、チケットが構成（compose）/回答（answer）された後の、デフォルトの次の状態を定義します。',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、電話チケットのためのデフォルトのノート本文テキストを定義します。',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            '顧客インタフェースのチケット・ズーム画面で、フォロー・アップ顧客チケットの優先度を定義します。',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '顧客インタフェースで、新規顧客チケットのデフォルトの優先度を定義します。',
        'Defines the default priority of new tickets.' => '新規チケットのデフォルトの優先度を定義します。',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '顧客インタフェースで、新規顧客チケットのためのデフォルトのキューを定義します。',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '動的オブジェクトに関するドロップダウン・メニューにおいて、デフォルトの選択を定義します(Form: Common Specification)。',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '許可（permission）に関するドロップダウン・メニューにおいて、デフォルトの選択を定義します(Form: Common Specification)。',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '統計フォーマットに関するドロップダウン・メニューにおいて、デフォルトの選択を定義します(Form: Common Specification)。フォーマット・キーを挿入してください（Stats::Formatを確認ください）。',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、電話チケットに関するデフォルトの送信者タイプを設定します。',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '顧客インタフェースのチケット・ズーム画面の、チケットに関するデフォルトの送信者タイプを定義します。',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'チケット検索画面で、デフォルトの表示されるチケット検索属性を定義します。',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'キュー・ビューの全てのキューに関して、優先度ソートの後の、デフォルトのソート順番を定義します。',
        'Defines the default spell checker dictionary.' => 'デフォルトのスペル・チェッカー辞書を定義します。',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '顧客インタフェースで、新規顧客チケットのデフォルトの状態を定義します。',
        'Defines the default state of new tickets.' => '新規チケットのデフォルトの状態を定義します。',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、電話チケットのためのデフォルトの件名を定義します。',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、ノートのデフォルトの件名を定義します。',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '顧客インタフェースのチケット検索で、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '担当者インタフェースのエスカレーション・ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '担当者インタフェースのロック済チケット・ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '担当者インタフェースの責任ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '担当者インタフェースの状態ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '担当者インタフェースの監視（watch）ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '担当者インタフェースのチケット検索結果のチケット・ソートについて、デフォルトのチケット属性を定義します。',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '担当者インタフェースのチケット・バウンス画面で、顧客/送信者に対するデフォルトのチケット・バウンス通知を定義します。',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、電話ノートを追加した後のチケットのデフォルトの次の状態を定義してください。',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースのエスカレーション・ビューで、デフォルトのチケット順番（優先度ソート後）を定義します。Up:一番古いものをトップに. Down:最新のものをトップに。',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースの状態ビューで、デフォルトのチケット順番（優先度によるソートの後）を定義します。Up: 最も古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            ' 担当者インタフェースの責任ビューで、デフォルトのチケットの順番を定義します。Up: 一番古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースのロック済チケット・ビューで、デフォルトのチケットの順番を定義します。Up: 一番古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースのチケット検索結果で、デフォルトのチケット順番を定義します。Up: 最も古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースの監視（watch）ビューで、デフォルトのチケットの順番を定義します。Up: 一番古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '顧客インタフェースのチケット検索結果で、デフォルトのチケット順番を定義します。Up: 最も古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、デフォルトのチケット優先度を定義します。',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、チケットのデフォルトの優先度を定義します。',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、デフォルトのチケット優先度を定義します。',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、デフォルトのチケット優先度を定義します。',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、デフォルトのチケット優先度を定義します。',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、デフォルトのチケット優先度を定義します。',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、デフォルトのチケット優先度を定義します。',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、デフォルトのチケット優先度を定義します。',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '顧客インタフェースで、項目のデフォルトのタイプを定義します。',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '担当者インタフェースのチケット転送画面で、転送されたメッセージのデフォルトのタイプを定義します。',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、ノートのデフォルトのタイプを定義します。',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、デフォルトのノートのタイプを定義します。',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、ノートのデフォルトのタイプを定義します。',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、ノートのデフォルトのタイプを決定します。',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、デフォルトの注釈のタイプを定義します。',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、デフォルトの注釈のタイプを定義します。',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、デフォルトのノートのタイプを定義します。',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、デフォルトのノートのタイプを定義します。',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、デフォルトのノートのタイプを定義します。',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '顧客インタフェースのチケット・ズーム画面の、デフォルトのノートのタイプを定義します。',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '担当者インタフェースにおいてURLにActionパラメータが与えられない場合、デフォルトで使用されるFrontend-Moduleを定義します。',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '顧客インタフェースのURLに対してActionパラメータが何も与えられない場合の、デフォルトで使用されるFrontend-Moduleを定義します。',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'チケットについて視認できる、デフォルトの送信者タイプを定義します（デフォルト：customer）。',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'URLをハイライトするため、項目の中のテキストを処理するフィルタを定義します。',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'フルに認定されたシステムのドメイン名を定義します。この設定は変数OTRS_CONFIG_FQDNとして使用され、アプリケーションによって使用されるメッセージングの全てのフォームに存在し、ご利用のシステム内のチケットへのリンクを作成することとなります。',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '全顧客が所属するグループを定義します（CustomerGroupSupportが有効であり、全ユーザをこれらのグループで管理したくない場合）。',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '凡例の高さを定義します。',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、クローズ・チケット画面アクションの履歴コメントを定義します。',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、Eメール・チケット画面アクションの履歴コメントを定義します。',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースのチケット履歴で使用される、電話チケット画面アクションに関する履歴コメントを定義します。',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'チケット履歴で使用される、チケット・フリー・テキスト画面のアクションに関する履歴コメントを定義します。',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースのチケット履歴で使用される、チケット・ノート画面アクションに関する履歴コメントを定義します。',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のためにしようされる、チケット所有者画面のアクションのための履歴コメントを定義します。',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、チケット保留画面のアクションのための履歴コメントを定義します。',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースのチケット履歴で使用される、チケット電話アウトバウンド画面アクションに関する履歴コメントを定義します。',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、チケット優先度画面のアクションのための履歴コメントを定義します。',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、チケット責任者画面のアクションのための履歴コメントを定義します。',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '顧客インタフェースでチケット履歴のために使用される、チケット・ズーム・アクションのため履歴コメントを定義します。',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、クローズ・チケット画面アクションの履歴タイプを定義します。',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、Eメール・チケット画面アクションの履歴タイプを定義します。',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースのチケット履歴で使用される、電話チケット画面アクションについて、履歴タイプを定義します。',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'チケット履歴で使用される。、チケット・フリー・テキスト画面のアクションに関して履歴タイプを定義します。',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースのチケット履歴で使用される、チケット・ノート画面アクションについて、履歴タイプを定義します。',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、チケット所有者画面のアクションのための履歴タイプを定義します。',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、チケット保留画面のアクションのための履歴タイプを定義します。',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースのチケット履歴で使用される、チケット電話アウトバウンド画面アクションについて、履歴タイプを定義します。',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、チケット優先度画面のアクションのための履歴タイプを定義します。',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、チケット責任者画面のアクションのための履歴タイプを定義します。',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '顧客インタフェースでチケット履歴のために使用される、チケット・ズーム・アクションのための履歴タイプを定義します。',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '業務時間とカウントする時間と週の平日数を定義します。',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Kernel::Modules::AgentInfoモジュールによってチェックされるキーを定義します。もし、このユーザ・プレファレンス・キーがtrueである場合、メッセージはシステムにより受諾されます。',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'CustomerAcceptを用いてキーを定義します。もし、このユーザ・プレファレンスがtrueである場合、メッセージがシステムによって受諾されます。',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'リンク・タイプ"ノーマル"の定義です。もしソース名およびターゲット名が同じ値を含んでいる場合、結果のリンクは非直接リンクになり、そうでない結果は直接リンクになります。',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'リンク・タイプ\'ParentChild\'の定義です。もしソース名およびターゲット名が同じ値を含んでいる場合、結果のリンクは非直接リンクになり、そうでない結果は直接リンクになります。',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'リンク・タイプのグループの定義です。同じグループのリンク・タイプは、お互いにキャンセルするように働きます。もしチケットAがチケットBと共に"ノーマル"にリンクされている場合、これらのチケットは\'ParentChild\'関係のリンクとともに追加的にリンクされることはできません。',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '追加的パッケージに関して、オンラインのレポジトリー・リストにアクセスするためのロケーションを定義します。1つめの利用可能な結果が使用されます。',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'システムのログ・モジュールを定義します。"ファイル"は、与えられたログファイルの全メッセージをライトし、"SysLog"はそのシステムのsyslog daemon、つまりsyslogdを使用します。',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            'ブラウザごとのファイル・アップロードの最大サイズ（バイト）を定義します。',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'セッションIDのための最大有効時間（秒）を定義します。',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'PDFファイルごとの最大ページ数を定義します。',
        'Defines the maximum size (in MB) of the log file.' => 'ログ・ファイルの最大サイズ（MB）を定義します。',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '担当者インタフェースにおいて、現在ログインしている全顧客を表示させるモジュールを定義します。',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '担当者インタフェースにおいて、現在ログインしている全ユーザを表示させるモジュールを定義します。',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '顧客インタフェースにおいて、最近ログインした担当者を表示するモジュールを定義してください。',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '顧客インタフェースにおいて、最近ログインした顧客を表示するモジュールを定義してください。',
        'Defines the module to authenticate customers.' => '顧客を認証するモジュールを定義します。',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'もし、システムがアドミン・ユーザによって使用されている場合、担当者インタフェースにおいて通知を表示させるモジュールを定義します（通常はアドミンとして行動する必要はありません）。',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'htmlサイトのhtmlリフレッシュ・ヘッダーを生成するモジュールを定義します。',
        'Defines the module to generate html refresh headers of html sites.' =>
            'htmlサイトのhtmlリフレッシュ・ヘッダーを生成するモジュールを定義します。',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'メールを送信するためのモジュールを定義します。"Sendmail"は、ご利用のオペレーティング・システムのsendmailバイナリを直接使用します。"SMTP"メカニズムのいずれもが、特定された（外部）メール・サーバを使用します。"DoNotSendEmail"は、Eメールを送らないもので、システム・テストの際に役立ちます。',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'セッション・データを格納するために使用されるモジュールを定義します。"DB"により、フロント・エンドのサーバをdbサーバから分離させることができます。"FS"はより速いものです。',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'ウェブ・インタフェース、ウェブ・ブラウザのタブおよびタイトル・バーに表示されるアプリケーション名を定義します。',
        'Defines the name of the column to store the data in the preferences table.' =>
            'プレファレンス・テーブルにおいてデータを格納するコラムの名前を定義します。',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'プレファレンス・テーブルにおいてユーザ識別子を格納するためのコラムの名前を定義します。',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '顧客セッションのためのキーの名前を定義します。',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'セッション・キーの名前を定義します。つまり、Session、SessionID、OTRSです。',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '顧客のプレファレンスが格納される、テーブル名を定義してください。',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、チケットを構成/回答した後の、可能性ある次の状態を定義します。',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '担当者インタフェースのチケット転送画面で、チケットを作成した後の、可能性ある次の状態を規定します。',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '顧客インタフェースで顧客チケットに関する、次の可能性ある状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、チケットのノートを追加した後の次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、チケットのノートを追加した後の次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、ノートを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、ノートを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、ノートを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、注釈を追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、ノートを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、ノートを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '担当者インタフェースのチケット・バウンス画面で、チケットのバウンスされた後の次の状態を定義します。',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '担当者インタフェースの移動チケット画面で、チケットが他のキューへ移動させられた後の次の状態を定義します。',
        'Defines the parameters for the customer preferences table.' => '顧客プレファレンス・テーブルのためのパラメータを定義してください。',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'ダッシュボード・バックエンドに関するパラメータを定義します。“Group”は、プラグインへのアクセスを制限するために使用されます（Group: admin;group1;group2;)。“Default”は、プラグインがデフォルトで有効になっているか、またはそれをユーザが手動で有効にする必要があるか、を示しています。“CacheTTLLocal”は、プラグインに関してキャッシュが時間切れとなる時間を分で定義します。',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'ダッシュボード・バックエンドに関するパラメータを定義します。“Group”は、プラグインへのアクセスを制限するために使用されます（Group: admin;group1;group2;)。“Default”は、プラグインがデフォルトで有効になっているか、またはそれをユーザが手動で有効にする必要があるか、を示しています。“CacheTTLLocal”は、プラグインに関してキャッシュが時間切れとなる時間を分で定義します。',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'ダッシュボード・バックエンドに関するパラメータを定義します。“Limit”は、デフォルトで表示されるエントリー数を定義します。“Group”は、プラグインへのアクセスを制限するために使用されます（Group: admin;group1;group2;)。“Default”は、プラグインがデフォルトで有効になっているか、またはそれをユーザが手動で有効にする必要があるか、を示しています。“CacheTTLLocal”は、プラグインに関してキャッシュが時間切れとなる時間を分で定義します。',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'ダッシュボード・バックエンドに関するパラメータを定義します。“Limit”は、デフォルトで表示されるエントリー数を定義します。“Group”は、プラグインへのアクセスを制限するために使用されます（Group: admin;group1;group2;)。“Default”は、プラグインがデフォルトで有効になっているか、またはそれをユーザが手動で有効にする必要があるか、を示しています。“CacheTTLLocal”は、プラグインに関してキャッシュが時間切れとなる時間を分で定義します。',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'SOAPハンドルにアクセスするためのパスワードを定義します(bin/cgi-bin/rpc.pl)。',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'PDFドキュメントで、太字でイタリックの等幅のフォントを扱うための、パスおよびTTF-Fileを定義します。',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'PDFドキュメントで、太字でイタリックのプロポーショナル・フォントを扱うための、パスおよびTTF-Fileを定義します。',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'PDFドキュメントで、太字の等幅フォントを扱うための、パスおよびTTF-Fileを定義します。',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'PDFドキュメントで、太字のプロポーショナル・フォントを扱うための、パスおよびTTF-Fileを定義します。',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'PDFドキュメントで、イタリックの等幅フォントを扱うための、パスおよびTTF-Fileを定義します。',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'PDFドキュメントで、イタリックのプロポーショナル・フォントを扱うための、パスおよびTTF-Fileを定義します。',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'PDFドキュメントで、等幅フォントを扱うための、パスおよびTTF-Fileを定義します。',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'PDFドキュメントのプロポーショナル・フォントを扱うための、パスおよびTTF-Fileを定義します。',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Kernel/Output/HTML/Standard/CustomerAccept.dtlの下に置かれている、shown info fileのパスを定義します。',
        'Defines the path to PGP binary.' => 'PGPバイナリへのパスを定義します。',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'sslバイナリを開くためのパスを定義します。HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).が必要になるかもしれません。',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '凡例の配置を定義します。これはフォームの2つの文字キーにしてください：\'B[LCR]|R[TCB]\'。1つめの文字は配置（下または右）を示し、2つめの文字はアラインメント（左、右、中心、上、下）を示します。',
        'Defines the postmaster default queue.' => 'ポストマスターのデフォルトのキューを定義します。',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '担当者インタフェースにおいて、電話チケットの受領者ターゲットおよびEメール・チケットの送信者を定義します（“Queue”は全てのキューを表示し、“SystemAddress”は全てのシステム・アドレスを表示します）。',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '顧客インタフェースで、チケットの受信者ターゲットを定義します("Queue"は全てのキューを表示し、"SystemAddress"は全てのシステム・アドレスを表示します)。',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '統計に関する検索のリミットを定義します。',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '担当者の実名と与えられたキューのEメールアドレスに間に置く分離を定義します。',
        'Defines the spacing of the legends.' => '凡例の間隔を定義します。',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'アプリケーション内で顧客が利用できる標準の許可を定義します。もし、より多くの許可が必要になった場合、ここに入力してください。許可が効力を持つためには、ハード・コーディングされる必要があります。なお、前述した許可のいずれかを追加する場合、“rw”許可が、最後のエントリとなることを確実にしてください。',
        'Defines the standard size of PDF pages.' => 'PDFページの標準サイズを定義します。',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'フォロー・アップをゲットし、チケットがすでにクローズされていた際のチケットの状態を定義します。',
        'Defines the state of a ticket if it gets a follow-up.' => 'フォロー・アップをゲットした際のチケットの状態を定義します。',
        'Defines the state type of the reminder for pending tickets.' => 'ペンディング・チケットに関するリマインダーの状態タイプを定義します。',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '新しいパスワードに関して、担当者に送信される通知メールの件名を定義します。',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '新規にリクエストされたパスワードに関するトークンと共に、担当者に送信される通知メールの件名を定義します。',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '新アカウントについて、顧客に送信される通知メールの件名を定義します。',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '新パスワードについて、顧客に送信される通知メールの件名を定義します。',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '新しくリクエストされたパスワードに関するトークンと共に、顧客に送信される通知メールの件名を定義します。',
        'Defines the subject for rejected emails.' => 'リジェクトされたEメールの件名を定義します。',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'システム管理者のEメール・アドレスを定義します。アプリケーションのエラー画面に表示されるものです。',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'システム識別子（アイデンティファー）の設定です。全てのチケット番号およびhttpセッションの文字列は、このIDを含んでいます。これにより、フォロー・アップの際などに、ご利用者（貴社）のシステムに属するチケットのみを処理するようになります（2つのOTRS間でやり取りをする際などに便利です）。',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '外部顧客データベースへのリンクにおける、ターゲット属性を定義します。例：\'target="cdb"\'',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'アプリケーションをサーブするために、ウェブ・サーバによって使用されるプロトコルのタイプを定義します。もしhttpプロトコルが平素のhttpの代わりに使用されるのであれば、ここで特定する必要があります。また、それが、ウェブ・サーバの設定または振舞いには影響を与えることは無いため、アプリケーションへのアクセス方法を変更することはなく、もし不適切なものであってもご利用者のアプリケーションへのログインを妨げることはありません。この設定はOTRS_CONFIG_HttpType変数として使用され、これはアプリケーションによって使用されるメッセージングの全フォームに存在するものであり、ご利用のシステム内のチケットへのリンクを作成するために使用されます。',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、Eメール引用のために使用されるキャラクタを定義します。',
        'Defines the user identifier for the customer panel.' => '顧客パネルのためのユーザ識別子を定義します。',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'SOAPハンドルにアクセスするためのユーザ名を定義します(bin/cgi-bin/rpc.pl)。',
        'Defines the valid state types for a ticket.' => 'チケットについて有効な状態タイプを定義します。',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'アンロックされたチケットについて、有効な状態を定義します。チケットをアンロックするには、スクリプト"bin/otrs.UnlockTickets.pl"を使用できます。',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'チケットについて、視認できるロックを定義します。デフォルト：unlock, tmp_lock。',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'リッチテキスト・エディター・コンポーネントを定義します。数字（ピクセル）またはパーセント値（相対的）を入力します。',
        'Defines the width of the legend.' => '凡例の幅を定義します。',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '状態（キー）のペンディング・タイムが終了した後に、どの状態が自動的に設定されるべきか（コンテンツ）を定義します。',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => 'オートコンプリート・クエリの間のディレイ・タイムをミリ秒単位で指定します。',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'もしセッションIDが、無効なリモートIPアドレスと共に使用されている場合、セッションを削除します。',
        'Deletes requested sessions if they have timed out.' => 'リクエストされたセッションがタイムアウトしている場合に削除します。',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'チケットへ移動していくであろう、可能性あるキューのリストが、担当者インタフェースにドロップ・ダウン・リストまたは新規ウィンドウとして表示されるべきかどうかを定義します。"New Window"を設定した場合、チケットに移動ノートを追加することができます。',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            'オートコンプリート機能の検索結果コンテナーについて、その幅を動的に変更するかどうかを定義します。',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '担当者インタフェースで、Eメール・チケットを作成した後の、可能性ある次のチケット状態を定義します。',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットを作成した後の、次の可能性あるチケット状態を定義します。',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '顧客インタフェースで、新規顧客チケットの後の次の画面を決定します。',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '客インタフェースで、ズームされたチケットのフォロー・アップ画面の後の次の画面を定義します。',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'タイム・リミットを越えてから状態を変更したペンディング・チケットに対して、可能となる状態を定義します。',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '担当者インタフェースにおいて、電話チケットの受領者(To:)、およびEメール・チケットの送信者(From:)として表示される文字列を定義します。キューに関しては、NewQueueSelectionType "<Queue>"がキューの名前を表示し、SystemAddress "<Realname> <<Email>>"は受領者の名前およびEメールを表示します。',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '顧客インタフェースで、チケットの受信者(To:)として表示される文字列を定義します。CustomerPanelSelectionTypeとしてのキューに関して"<Queue>"はキューの名前を表示し、
SystemAddressに関して"<Realname> <<Email>>"は受信者の名前およびEメールを表示します。
',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'リンクされたオブジェクトがそれぞれのズーム・マスクで表示される方式を定義します。',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '担当者インタフェースにおいて、受領者（電話チケット）および送信者（Eメール・チケット）に関する、どのオプションが有効となるかを定義します。',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '顧客インタフェースで、チケットの受信者としてどのキューを有効とするかを定義します。',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'チケットの責任者である担当者への、リマインダー通知の送信を無効にします(Ticket::Responsibleが有効にされる必要があります)。',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'チケット・ズーム・ビューで、項目に関してアカウントされた時間を表示します。',
        'Dropdown' => '',
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
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
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
        'Email Addresses' => 'メールアドレス',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'PDF出力を有効にします。CPAN モジュール PDF::API2が必要となりますが、もしインストールされていなければPDF出力は無効にされます。',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'PGPサポートを有効にします。PGPサポートがメールの署名およびセキュアリングのために有効となっている際は、ウェブ・サーバをOTRSユーザとして動作させることを強く推奨します。そうでない場合、.gnupgフォルダにアクセスする時の特権に関して問題が発生します。',
        'Enables S/MIME support.' => 'S/MIMEサポートを有効にします。',
        'Enables customers to create their own accounts.' => '顧客に自らのアカウントを作成できるようにします。',
        'Enables file upload in the package manager frontend.' => 'パッケージ・マネジャー・フロントエンドでの、ファイル・アップロードを有効にします。',
        'Enables or disable the debug mode over frontend interface.' => 'フロントエンド・インタフェース上でのデバッグを、有効または無効にします。',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '担当者インタフェースにおいて、顧客検索のためのオートコンプリート機能を、有効または無効にします。',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '所有者または責任者になること無くチケットの追跡を続けるため、チケット監視機能を有効または無効にします。',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'パフォーマンス・ログを有効にします（ページ・レスポンス・タイムのログを取ります）。システム・パフォーマンスに影響が出ます。Frontend::Module###AdminPerformanceLogを有効とする必要があります。',
        'Enables spell checker support.' => 'スペル・チェッカー・サポートを有効にします。',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '担当者フロントエンドで、同時に2つ以上のチケットの作業を可能にするためのチケット・バルク・アクション機能を有効にするものです。',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'リストされたグループに対してのみ、チケット・バルク・アクション機能を有効にします。',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '特定のチケットを追跡するため、チケット責任者機能を有効にします。',
        'Enables ticket watcher feature only for the listed groups.' => 'リストされたグループためにのみ、チケット監視機能を有効にします。',
        'Escalation view' => 'エスカレーション一覧',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => 'SQL文の実行',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '件名にチケット番号を持たないメールに関して、In-Reply-Toまたはレファレンス・ヘッダーにおけるフォロー・アップ・チェックを行います。',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '件名にチケット番号を持たないメールに関して、フォロー・アップのメール添付ファイルのチェックを行います。',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '件名にチケット番号を持たないメールに関して、フォロー・アップのメール・チェックを行います。',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '件名にチケット番号を持たないメールに関して、フォロー・アップのplain/rawメール・チェックを行います。 ',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '検索結果で、全ての項目ツリーをエクスポートします（システム・パフォーマンスに影響が出る場合があります）。',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'プロキシ経由でパッケージを取ってきます（フェッチ）。"WebUserAgent::Proxy"を上書きします。',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'もし、Kernel/Output/HTML/Standard/AgentInfo.dtl.の下に置かれた場合、Kernel::Modules::AgentInfoモジュールによって表示されるファイルです。',
        'Filter incoming emails.' => '受信メールフィルタ',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '送信Eメールのエンコードを強制します(7bit|8bit|quoted-printable|base64)。',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'ロックのアクションの後に、（現状から）異なるチケット状態を強制的に選択します。現在の状態をキーとして定義し、ロック・アクションの後に来る次の状態をコンテンツとして選択してください。',
        'Forces to unlock tickets after being moved to another queue.' =>
            'チケットが他のキューに移動された後に、強制的にアンロックします。',
        'Frontend language' => 'フロントエンドの言語',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'フロントエンド・モジュールの登録です（カンパニー機能が使われていない場合にはカンパニー・リンクを削除します）。',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '担当者インタフェースに関するフロントエンド・モジュールの登録です。',
        'Frontend module registration for the customer interface.' => '担当者インタフェースに関するフロントエンド・モジュールの登録です。',
        'Frontend theme' => 'フロントエンドのテーマ',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => '管理用ジョブ',
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
            'エンド・ユーザに、翻訳ファイルで定義されている、CSVファイルに関するセパレータ・キャラクターをオーバーライドする可能性を与えます。',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'チケットの顧客IDが顧客ユーザIDと合致していた、および顧客がそのチケットが入っているキューに対するグループ許可を持っていた場合に、顧客に対してアクセスを付与します。',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'ご利用の項目フル・テキスト検索を拡張することを助けます(From, To, Cc, 件名、本文、による検索)。ランタイムは、ライブ・データについてフル・テキスト検索を行います（最大50000枚のチケットまでは問題無く動作します）。StaticDBは、フル・テキスト検索を50%増加させながら、全ての項目を削除し項目作成の後にインデックスを構築します。イニシャル・インデックスを作成するには、"bin/otrs.RebuildFulltextIndex.pl"を使用してください。',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'もし、Customer::AuthModuleに関して“DB”が選択されていた場合、データベース・ドライバー（通常は自動ディテクションが使用される）を特定できます。',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'もし、Customer::AuthModuleに関して“DB”が選択されていた場合、顧客テーブルに接続するためのパスワードを特定できます。',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'もし、Customer::AuthModuleに関して“DB”が選択されていた場合、顧客テーブルに接続するためのユーザ名を特定できます。',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'もし、Customer::AuthModuleに関して“DB”が選択されていた場合、顧客テーブルに対する接続のためのDSNを特定する必要があります。',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'もし、Customer::AuthModuleに関して“DB”が選択されていた場合、顧客テーブル内のCustomerPasswordのためのコラム名を特定する必要があります。',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'もし、Customer::AuthModuleに関して“DB”が選択されていた場合、パスワードのcryptタイプを特定する必要があります。',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'もし、Customer::AuthModuleに関して“DB”が選択されていた場合、顧客テーブル内のCustomerKeyのためのコラム名を特定する必要があります。',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'もし、Customer::AuthModuleに関して“DB”が選択されていた場合、顧客データが格納されるべきテーブル名を特定する必要があります。',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'セッション・モジュールに"DB"が選択されていた場合、セッション・データが格納されるデータベースのテーブルを特定する必要があります。',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'セッション・モジュールに"FS"が選択されていた場合、セッション・データが格納されるディレクトリを特定する必要があります。',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Customer::AuthModuleに関して"HTTPBasicAuth"が選択されていた場合、（RegExpを使用することで）REMOTE_USERの部分を削除することができます（例：trailing domainsを削除するなど）。RegExp-Note, $1が新しいログインとなります。',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Customer::AuthModuleに関して"HTTPBasicAuth"が選択されていた場合、ユーザ名の始まりの部分を削除することができます（例：ドメインにおいて、example_domain\userをuserに変える）。',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Customer::AuthModuleに関して“LDAP”が選択されていて、全ての顧客ログイン名にsuffix（後ろに付く接尾辞）を追加したい場合、ここで特定してください。例えば、ユーザ名のみを書いても、ユーザがLDAPディレクトリの中ではuser@domainとして存在するなどです。',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Customer::AuthModuleに関して“LDAP”が選択されていて、Net::LDAP perl モジュールに対して特別なパラメータが必要な場合、ここで設定できます。パラメータに関するより詳細な情報は、"perldoc Net::LDAPを参照ください。',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Customer::AuthModuleに関して“LDAP”が選択されていて、ユーザがLDAPツリーに対して匿名アクセスのみを持っていて、しかしながらデータを検索したいという場合、これをLDAPディレクトリへのアクセスを持つユーザによって行うことができます。この特別なユーザについて、ここでパスワードを設定してください。',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Customer::AuthModuleに関して“LDAP”が選択されていて、ユーザがLDAPツリーに対して匿名アクセスのみを持っていて、しかしながらデータを検索したいという場合、これをLDAPディレクトリへのアクセスを持つユーザによって行うことができます。この特別なユーザについて、ここでユーザ名を特定してください。',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Customer::AuthModuleに関して、“LDAP”が選択されていた場合、BaseDNを特定する必要があります。',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Customer::AuthModuleに関して、“LDAP”が選択されていた場合、LDAPホストを特定できます。',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Customer::AuthModuleに関して、“LDAP”が選択されていた場合、ユーザ識別子を特定する必要があります。',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Customer::AuthModuleに関して、“LDAP”が選択されていた場合、ユーザ属性を特定することができます。LDAPのためにposixGroupはUIDを使用し、non LDAP posixGroupはfull user DNを使用します。',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Customer::AuthModuleに関して、“LDAP”が選択されていた場合、ここにおいてアクセス属性を特定することができます。',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Customer::AuthModuleに関して“LDAP”が選択されている場合に、例えばサーバー接続がネットワークの問題で確立できない際に、アプリケーションを停止させるかどうかを設定できます。',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Customer::AuthModuleに関して“LDAP”が選択されていた場合、ユーザについて、例えばOTRSを利用するためグループxyzにいる必要がある場合に、posixGroupにいるという理由で認証することを許可されるかどうかを、確認することができます。システムにアクセスする可能性があるグループを特定してください。',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '“LDAP”が選択されていた場合、LDAPクエリーそれぞれにフィルタを追加することができます。例えば、(mail=*), (objectclass=user), (!objectclass=computer)などです。',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Customer::AuthModuleに関して“Radius”が選択されていた場合、radiusホストに対する認証を行うためのパスワードを特定する必要があります。',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Customer::AuthModuleに関して“Radius”が選択されていた場合、radiusホストを特定する必要があります。',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Customer::AuthModuleに関して“Radius”が選択されていた場合、例えばサーバー接続がネットワークの問題で確立できない際に、アプリケーションを停止させるかどうかを設定できます。',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '"Sendmail"がSendmailモジュールとして選択された場合、sendmailバイナリおよび必要オプションのロケーションが特定されている必要があります。',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'もしログ・モジュールに関して"SysLog"が選択されていた場合、特別なログ・ファシリティが特定されます。',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            'もしログ・モジュールに関して"SysLog"が選択されていた場合、特別なログsockが特定されます（solarisにおいては\'stream\'を使用する必要があるかもしれません）。',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'もしログ・モジュールに関して"SysLog"が選択されていた場合、ロギングで使用されるべき文字セットが特定されます。',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'もしログ・モジュールに関して"File"が選択されていた場合、ログ・ファイルが必ず特定されます。もしファイルが存在しなければ、システムにより作成されます。',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、チケットのノートを追加した後の次の状態を定義します。',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、担当者によってノートが追加された場合にチケットの状態を設定します。',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、ノートが担当者によって追加された場合、チケットの状態を設定します。',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'ノートが担当者によって追加された場合、担当者インタフェースのチケット・ノート画面でチケットの状態を設定します。',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'ノートが担当者によって追加された場合、担当者インタフェースのチケット責任者画面でチケットの状態を設定します。',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、ノートが担当者によって追加された場合、チケットの状態を設定します。',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、注釈が担当者によって追加された場合、チケットの状態を設定します。',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、ノートが担当者によって追加された場合、チケットの状態を設定します。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '"SMTP"構造のいずれかがSendmailモジュールとして選択され、かつメール・サーバへの認証が必要な場合、パスワードを特定する必要があります。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '"SMTP"構造のいずれかがSendmailモジュールとして選択され、かつメール・サーバへの認証が必要な場合、ユーザ名を特定する必要があります。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '"SMTP"構造のいずれかがSendmailモジュールとして選択された場合、メールを送信するメール・ホストが特定されている必要があります。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '"SMTP"構造のいずれかがSendmailモジュールとして選択された場合、メール・サーバが受信接続をlistenしている（待っている）ポートが特定されている必要があります。',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '有効にすると、OTRSは全CSSファイルを縮小した形で配信します。もし、これをオフにすると、IE7においては32CSSファイル以上をロードできないため、問題が発生する可能性が高いです。',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '有効にすると、OTRSは全JavaScriptファイルを縮小した形式で配信します。',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '有効にされた場合、TicketPhoneおよびTicketEmailは新しいウィンドウで開きます。',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            '有効にすると、OTRSバージョンのタグがHTTPヘッダーから除去されます。',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '有効にした場合、メイン・メニューの1つめのレベルのものが、マウスを乗せるだけで開きます（1回クリックの代わりに）。',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'ここで指定した文言（正規表現）にマッチした場合、オート・レスポンダーによりメッセージは送られません。',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'もし、担当者チケット・フルテキスト検索のためまたは統計を生成するために、ミラー・データベースを使用したい場合、本データベースへのDSNを特定します。',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'もし、担当者チケット・フルテキスト検索のためまたは統計を生成するために、ミラー・データベースを使用したい場合、本データベースに対して認証するためのパスワードを特定します。',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'もし、担当者チケット・フルテキスト検索のためまたは統計を生成するために、ミラー・データベースを使用したい場合、本データベースに対して認証させるユーザを特定します。',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '新規項目機能のシステム・センダー・タイプを持つ項目を、無視します（例：自動返答またはEメール通知など）。',
        'Includes article create times in the ticket search of the agent interface.' =>
            '担当者インタフェースのチケット検索で、項目の作成時間を含みます。',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'IndexAccelerator：ご利用のバックエンドのTicketViewAcceleratorモジュールを選択します。"RuntimeDB"は、チケット・テーブルから浮き上がった各キュー・ビューを生成します（システム内で合計で60,000程度のチケット、オープン・チケット6,000までは、パフォーマンスは問題ないでしょう。"StaticDB"は、もっともパワフルなモジュールであり、ビューのように動作する追加のチケット－インデックス・テーブルを使用するものです（80,000のチケットおよび6,000のオープンチケットがシステムに保存される場合、推奨します）。初期のインデックス・アップデートには、"bin/otrs.RebuildTicketIndex.pl"を使用してください。',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '利用者がスペル・チェッカーを使用したい場合、システム上にispellまたはaspellをインストールします。ご利用のオペレーティング・システム上で、aspellまたはispellへのパスを特定します。',
        'Interface language' => 'インターフェイスの言語',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'アプリケーション内でドメインごとのベースで使用されている異なる担当者間を区別するためなど、異なるスキンを設定することが可能です。通常の表現（regrex）を使用することで、Key/Contentのペアをドメインにマッチするように設定することが可能です。“Key”の値はドメインにマッチするべきであり、“Content”の値はご利用のシステムの有効なスキンであるべきです。Regrexの適切な形式については、入力例を参照してください。',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'アプリケーション内でドメインごとのベースで使用される異なる顧客ごとを見分けるため、などの場合、異なるスキンを設定することも可能です。通常の表現を使用することで（regex）、Key/Contentのペアーをドメインにマッチするように設定することが可能です。"Key"の中の値はドメインにマッチするべきであり、"Content"の中の値はご利用のシステム上の有効なスキンであるべきです。Regrexの適切な形式への入力例をご覧ください。',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '異なるテーマを、担当者と顧客の間で異なるように、アプリケーション内でドメインごとの単位で使用されるように、設定することができます。regular expression (regex)を使用することにより、ドメインにマッチするようにKey/Contentを設定することが可能です。“Key”の値はドメインにマッチさせるべきであり、“Content”の値はご利用のシステムで有効なテーマとしてください。regrexの適切な形式のための入力例を確認してください。',
        'Link agents to groups.' => '担当者をグループへ連結',
        'Link agents to roles.' => '担当者を役割へ連結',
        'Link attachments to responses templates.' => '添付ファイルを応答テンプレートへ連結',
        'Link customers to groups.' => '顧客をグループへ連結',
        'Link customers to services.' => '顧客をサービスへ連結',
        'Link queues to auto responses.' => 'キューを自動応答へ連結',
        'Link responses to queues.' => '応答をキューへ連結',
        'Link roles to groups.' => '役割をグループへ連結',
        'Links 2 tickets with a "Normal" type link.' => '“ノーマル”タイプのリンクを持つチケットへのリンクです。.',
        'Links 2 tickets with a "ParentChild" type link.' => '“親子”タイプのリンクを持つチケットへのリンクです。',
        'List of CSS files to always be loaded for the agent interface.' =>
            '担当者インタフェースに対して、常にロードされるCSSファイルのリストです。',
        'List of CSS files to always be loaded for the customer interface.' =>
            '顧客インタフェースに対して、常にロードされるCSSファイルのリストです。',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            '顧客インタフェースに対して、常にロードされるIE7特有のCSSファイルのリストです。',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '担当者インタフェースに対して、常にロードされるIE8特有のCSSファイルのリストです。',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '顧客インタフェースに対して、常にロードされるIE8特有のCSSファイルのリストです。',
        'List of JS files to always be loaded for the agent interface.' =>
            '担当者インタフェースに対して、常にロードされるJSファイルのリストです。',
        'List of JS files to always be loaded for the customer interface.' =>
            '顧客インタフェースに対して、常にロードされるJSファイルのリストです。',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'チケット・カウンターのためのログ・ファイルです。',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Eメールの送信または電話/Eメール・チケットの提出の前に、アプリケーションにEメール・アドレスのMXレコードをチェックさせるようにします。',
        'Makes the application check the syntax of email addresses.' => 'アプリケーションにEメール・アドレスのシンタクスをチェックさせます。',
        'Makes the picture transparent.' => '画像を透明にします。',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'セッション管理に、htmlクッキーを使用させるようにします。htmlクッキーが無効にされている場合、またはクライアント・ブラウザがhtmlクッキーを無効にしている場合、システムは通常どおり動作し、またセッションIDをリンクに付け加えます。',
        'Manage PGP keys for email encryption.' => 'メール暗号用のPGP鍵管理',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'メール受信用POP3/IMAPアカウント管理',
        'Manage S/MIME certificates for email encryption.' => 'メール暗号用のS/MIME証明書管理',
        'Manage existing sessions.' => '既存セッション管理',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => '周期的なタスク管理',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => 'Eメール・リプライにおける件名の最大サイズです。',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '1日においてEメール・アドレスを入手する自動メールによる返答の最大数です（ループ・プロテクション）。',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'POP3/POP3S/IMAP/IMAPS経由で取ってくることが可能なメールのKBytesの最大値です。',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '担当者インタフェースの検索結果で、表示されるチケットの最大数です。',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '顧客インタフェースの検索結果で表示される、チケットの最大数です。',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'チケット･ズーム・ビューにおける、顧客情報テーブル（電話およびEメール）の最大サイズ（文字）です。',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '顧客インタフェースで、新規チケット画面におけるTo-selectionのモジュールです。',
        'Module to check customer permissions.' => '顧客の許可をチェックするためのモジュールです。',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'あるユーザが、特別なグループに加入しているか確認するためのモジュールです。ユーザが特別なグループに入っておりro権限とrw権限を持っていれば、アクセスが付与されます。',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '到着したEメールがEメール－内部としてマークするべきものかどうかを、チェックするモジュールです（オリジナルの転送されたインターナルのEメールのため）。ArticleTypeおよびSenderTypeが、到着したEメール/項目の値を定義します。',
        'Module to check the agent responsible of a ticket.' => 'チケットの責任者となる担当者を確認するモジュールです。',
        'Module to check the group permissions for the access to customer tickets.' =>
            '顧客チケットへのアクセスに関して、グループ許可を確認します。',
        'Module to check the owner of a ticket.' => 'チケットの所有者を確認するモジュールです。',
        'Module to check the watcher agents of a ticket.' => 'チケットの監視人担当者をチェックするためのモジュールです。',
        'Module to compose signed messages (PGP or S/MIME).' => '署名されたメッセージを構成するモジュールです（PGP または S/MIME)。',
        'Module to crypt composed messages (PGP or S/MIME).' => '構成されたメッセージを暗号化（crypt）するモジュールです(PGP or S/MIME)。',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '受信メッセージについてフィルターし操作するためのモジュールです。From: noreply@ addressを用いて、全てのスパム・メールをブロック/無視します。',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '受信メッセージについてフィルターし操作するためのモジュールです。チケットのフリーテキストに対して4桁の数字を得て、「Match」において正規表現を使用します。
（例：From / \'(.+?)@.+?\'とし、「Set」にて「[***]」として後方参照を使用します。）',
        'Module to generate accounted time ticket statistics.' => 'アカウンテッド・タイム・チケット統計を生成するモジュールです。',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '担当者インタフェースにおいて、ショート・チケット検索のためのhtml OpenSearchプロフィールを生成するモジュールです。',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '顧客インタフェースで、ショート・チケット検索のためのhtml OpenSearchプロファイルを生成するためのモジュール。',
        'Module to generate ticket solution and response time statistics.' =>
            'チケット・ソリューションおよびレスポンス・タイム統計を生成するためのモジュールです。',
        'Module to generate ticket statistics.' => 'チケット統計を作成するためのモジュールです。',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '通知とエスカレーションを表示するためのモジュールです(ShownMax: 最大、表示されたエスカレーション、EscalationInMinutes: エスカレートされるチケットを表示、CacheTime: 計算されたエスカレーションのキャッシュ秒数)。',
        'Module to use database filter storage.' => 'データベース・フィルタ・ストレージを使用するモジュールです。',
        'Multiselect' => '',
        'My Tickets' => '担当チケット',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'カスタム・キューの名前です。カスタム・キューとは、利用者が特に優先するキューの一覧であり、プレファレンス設定から選択できます。',
        'NameX' => '',
        'New email ticket' => '新規メールチケットの作成',
        'New phone ticket' => '新規電話チケットの作成',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、電話ノートを追加した後の次の可能性あるチケットの状態です。',
        'Notifications (Event)' => '通知 (イベント)',
        'Number of displayed tickets' => '表示チケット数',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '担当者インタフェースの検索ユーティリティにより、表示される行（チケット毎）の数です。',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '担当者インタフェースの検索結果の各ページで、表示されるチケットの数です。',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '顧客インタフェースの検索結果の各ページで表示される、チケット数です。',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Kernel::System::Ticketに既に存在している機能を多重定義（再定義）します。簡単にカスタマイズを追加したい場合に使用されます。',
        'Overview Escalated Tickets' => 'エスカレーション済チケット一覧',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => '全対応中チケット一覧',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'PGP鍵アップロード',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '担当者インタフェースのプレファレンス・ビューにあるCreateNextMaskオブジェクトのパラメータです。',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '担当者インタフェースのプレファレンス・ビューにある、CustomQueueオブジェクトのパラメータです。',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '担当者インタフェースのプレファレンス・ビューにある、FollowUpNotifyオブジェクトのパラメータです。',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '担当者インタフェースのプレファレンス・ビューにある、LockTimeoutNotifyオブジェクトのパラメータです。',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '担当者インタフェースのプレファレンス・ビューにある、MoveNotifyオブジェクトのパラメータです。',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '担当者インタフェースのプレファレンス・ビューにある、NewTicketNotifyオブジェクトのパラメータです。',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '担当者インタフェースのプレファレンス・ビューにある、RefreshTimeオブジェクトのパラメータです。',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '担当者インタフェースのプレファレンス・ビューにある、WatcherNotifyオブジェクトのパラメータです。',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '担当者インタフェースにおける新規チケット一覧のダッシュボード・バックエンドに関するパラメータです。"Limit"は、表示されるデフォルトのエントリー数です。"Group"は、プラグインへのアクセスを制限するために使用されます(例：Group: admin;group1;group2;)。"Default"は、プラグインがデフォルトで有効となっているか、またはユーザがそれを手動で有効にする必要があるか、を定義します。"CacheTTLLocal"は、プラグインのキャッシュ・タイム（分）です。',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '担当者インタフェースにおけるチケット・カレンダーのダッシュボード・バックエンドに関するパラメータです。"Limit"は、表示されるデフォルトのエントリー数です。"Group"は、プラグインへのアクセスを制限するために使用されます(例：Group: admin;group1;group2;)。"Default"は、プラグインがデフォルトで有効となっているか、またはユーザがそれを手動で有効にする必要があるか、を定義します。"CacheTTLLocal"は、プラグインのキャッシュ・タイム（分）です。',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '担当者インタフェースにおけるチケット・エスカレーション一覧のダッシュボード・バックエンドに関するパラメータです。"Limit"は、表示されるデフォルトのエントリー数です。"Group"は、プラグインへのアクセスを制限するために使用されます(例：Group: admin;group1;group2;)。"Default"は、プラグインがデフォルトで有効となっているか、またはユーザがそれを手動で有効にする必要があるか、を定義します。"CacheTTLLocal"は、プラグインのキャッシュ・タイム（分）です。',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '担当者インタフェースにおけるチケット・ペンディング・リマインダー一覧のダッシュボード・バックエンドに関するパラメータです。"Limit"は、表示されるデフォルトのエントリー数です。"Group"は、プラグインへのアクセスを制限するために使用されます(例：Group: admin;group1;group2;)。"Default"は、プラグインがデフォルトで有効となっているか、またはユーザがそれを手動で有効にする必要があるか、を定義します。"CacheTTLLocal"は、プラグインのキャッシュ・タイム（分）です。',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '担当者インタフェースにおけるチケット・ペンディング・リマインダー一覧のダッシュボード・バックエンドに関するパラメータです。"Limit"は、表示されるデフォルトのエントリー数です。"Group"は、プラグインへのアクセスを制限するために使用されます(例：Group: admin;group1;group2;)。"Default"は、プラグインがデフォルトで有効となっているか、またはユーザがそれを手動で有効にする必要があるか、を定義します。"CacheTTLLocal"は、プラグインのキャッシュ・タイム（分）です。',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '担当者インタフェースにおけるチケット統計のダッシュボード・バックエンドに関するパラメータです。"Limit"は、表示されるデフォルトのエントリー数です。"Group"は、プラグインへのアクセスを制限するために使用されます(例：Group: admin;group1;group2;)。"Default"は、プラグインがデフォルトで有効となっているか、またはユーザがそれを手動で有効にする必要があるか、を定義します。"CacheTTLLocal"は、プラグインのキャッシュ・タイム（分）です。',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '中程度のチケット一覧のページ（チケットが表示されている）のパラメータです。',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '小さいチケット一覧のページ（チケットが表示されている）のパラメータです。',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'チケット・プレビュー一覧のページ（チケットが表示されている）のパラメータです。',
        'Parameters of the example SLA attribute Comment2.' => 'example SLA attribute Comment2のパラメータです。',
        'Parameters of the example queue attribute Comment2.' => 'example queue attribute Comment2のパラメータです。',
        'Parameters of the example service attribute Comment2.' => 'example service attribute Comment2のパラメータです。',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'ログ・ファイルのパスです（LoopProtectionModuleに関して“FS”が選択されており、それが強制である場合にのみ適用されます）。',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '担当者インタフェースにおけるQueueObjectオブジェクトのための全ての設定を格納するファイルのパスです。',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '顧客インタフェースに関して、QueueObjectオブジェクトのための全ての設定を格納するファイルのパスです。',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '担当者インタフェースにおけるTicketObjectオブジェクトのための全ての設定を格納するファイルのパスです。',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '顧客インタフェースに関して、TicketObjectのための全ての設定を格納するファイルのパスです。',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => 'Eメール・ウィンドウを構成するために許容される幅です。',
        'Permitted width for compose note windows.' => 'ノート・ウィンドウを構成するために許容される幅です。',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'ポストマスター・フィルタ',
        'PostMaster Mail Accounts' => 'メールアカウント',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'CSRF (Cross Site Request Forgery)攻撃に対するプロテクションです（さらに詳細はhttp://en.wikipedia.org/wiki/Cross-site_request_forgeryを参照ください）。',
        'Queue view' => 'キュー一覧',
        'Refresh Overviews after' => '',
        'Refresh interval' => '更新間隔',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、オリジナルの送信者を、コンポーズ・アンサー上の現在の顧客のEメール・アドレスに置換します。',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '担当者インタフェースで、チケットの顧客を変更するための必要な許可です。',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '担当者インタフェースで、クローズ・チケット画面を使用するために必要な許可です。',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '担当者インタフェースで、チケット・バウンス画面を使用するために必要な許可です。',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '担当者インタフェースで、チケット構成画面を使用するための必要な許可です。',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '担当者インタフェースのチケット転送画面を使用するために必要な許可です。',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '担当者インタフェースで、チケット・フリー・テキスト画面を使用する為の必要な許可です。',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースで、ズームされたチケットのチケット結合画面を使用するための必要な許可です。',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面を使用するための必要な許可です。',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースで、ズームされたチケットのチケット所有者画面を使用するための必要な許可です。',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースで、ズームされたチケットのチケット保留画面を使用するための必要な許可です。',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '担当者インタフェースで、チケット電話アウトバウンド画面を使用するための必要な許可です。',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースで、ズームされたチケットのチケット優先度画面を使用するための必要な許可です。',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '担当者インタフェースで、チケット責任者画面を使用するための必要な許可です。',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'チケットの所有者を、チケットが移動された、または別のキューに移動した場合、リセットおよびアンロックします。',
        'Responses <-> Queues' => '応答 <-> キュー',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'チケットをアーカイブから救出します（ただし、イベントが状態変更の場合であり、クローズの状態から利用可能ななんらかのオープンの状態に変更された場合とします）。',
        'Roles <-> Groups' => '役割 <-> グループ',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'AdminCustomerUserモジュールにアクセスした時に、存在する顧客ユーザに関して最初のワイルド・カード検索を実行します。',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'システムを“デモ”モードで動作させます。“Yes”に設定すると、担当者が、担当者用ウェブ・インタフェースを通して、言語選択やテーマなどのプレファレンスを変更できるようになります。これらの変更は、現在のセッションにおいてのみ有効です。担当者がパスワードを変更することはできません。',
        'S/MIME Certificate Upload' => 'S/MIME証明書アップロード',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '項目の添付ファイルを保存します。. "DB"は、全てのデータをデータベースに保存します（大きな添付物の保存にはお奨めしません）。"FS"は、データをファイル・システム上に保存するもので、これは速い方法ですがウェブ・サーバがOTRSユーザの配下で動作している必要があります。すでに製品となっているシステムにおいても、データを損失すること無く、モジュール間で切替を行うことができます。',
        'Search backend default router.' => 'バックエンドのデフォルト・ルーターを検索します。',
        'Search backend router.' => 'バックエンド・ルーターを検索します。',
        'Select your frontend Theme.' => 'フロントエンドのテーマを選択してください。',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'ウェブ・インタフェースを通じてアップロードを取り扱うための、モジュールを選択します。"DB"は全てのアップロードをデータベースに格納し、"FS"はファイル・システムを使用します。',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'チケット番号を生成するモジュールを選択します。"AutoIncrement"は、チケット番号をインクリメントし、システムIDおよびカウンターはシステムIDカウンター・フォーマット（例：1010138, 1010139)と共に使用されます。“Date”によって、チケット番号は、現在の日付、システムID、カウンターによって生成されることとなります。フォーマットは、Year.Month.Day.SystemID.counterのようなものです(例：200206231010138, 200206231010139)。"DateChecksum"により、カウンターが、日付およびシステムIDのストリング（文字列）に対するチェックサムとして追加されます。チェックサムは、日ごとに実施されます。フォーマットはYear.Month.Day.SystemID.Counter.CheckSumのようになります(例： 2002070110101520, 2002070110101535)。"Random"は、チケット番号をランダムに生成するもので、フォーマットは"SystemID.Random" (例：100057866352, 103745394596)などとなります。',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '顧客が追跡し、かつ自分がチケット所有者になるか、チケットがロック解除されて自分が購読中のキューのいずれかになった場合通知を送信',
        'Send notifications to users.' => 'ユーザーに通知を送信',
        'Send ticket follow up notifications' => 'チケット追跡通知の送信',
        'Sender type for new tickets from the customer inteface.' => '顧客インタフェースからの新規チケットのための送信者タイプです。',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'チケットがアンロックされた際に、所有者にのみ担当者フォロー・アップ通知を送信します（デフォルト設定では、全ての担当者に通知を送ります）。',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Bccを経由して特定されたアドレスに送信Eメールを送ります。バックアップ目的のためにのみ使用してください。',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'マップされた顧客にのみ顧客通知を送信します。通常は、もし顧客が誰もマップされていない場合、最新のカスタマーが通知を受け取ることになります。',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'リマインダ日付を迎えたら、アンロック・チケットのリマインダ通知を送信します（チケット所有者だけに送信されます）。',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '管理インタフェースの"Notfication (Event)"の下で設定された通知を送信します。',
        'Set sender email addresses for this system.' => 'このシステムのメール送信者を設定',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoomで、インラインHTML項目のデフォルトの高さ（pixel）を設定します。',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoomで、インラインHTML項目の最大高さ（pixel）を設定します。',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'ご利用の全公開/秘密PGP鍵について、信頼される署名によって認証されていなくても信頼する場合、これをyesに設定してください。',
        'Sets if ticket owner must be selected by the agent.' => 'チケットの所有者が担当者によって必ず選択される必要があるかどうかを設定します。',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '状態が非ペンディング状態に変更された場合、チケットのペンディング・タイムを0に設定します。',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'タッチされていないチケットを含むキューをハイライトするための、経過時間を分で設定します（第1レベル）。',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'タッチされていないチケットを含むキューをハイライトするための、経過時間を分で設定します（第2レベル）。',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '管理者のコンフィグ・レベルの設定です。コンフィグ・レベルに拠り、いくつかのシステム・コンフィグ・オプションは表示されなくなります。コンフィグ・レベルは昇順です：Expert, Advanced, Beginner。コンフィグ・レベルが高いほど（Beginnerを最高とします）、ユーザが、システムを二度と使用できなくなるような設定を誤って行うことが、起こりにくくなります。',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '担当者インタフェースで、新規Eメール・チケットに関してデフォルトの送信者タイプを設定します。',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットのための、デフォルトの項目タイプを設定します。',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、追加されたノートに関するデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '担当者インタフェースの移動チケット画面で、追加されるノートのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、追加されたノートのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、追加されたノートのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、追加された注釈のデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、追加されたノートのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、追加されたノートのデフォルトの本文テキストを設定します。',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '担当者インタフェースで、分割されたチケットのデフォルトのリンク・タイプを設定します。',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットのためのデフォルトの次の状態を設定します。',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '担当者インタフェースで、Eメール・チケットを作成した後の、デフォルトの次のチケット状態を設定します。',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットのためのデフォルトのノートのテキストを設定します（例：\'New ticket via call\'）。',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '担当者インタフェースで、新規Eメール・チケットに関してデフォルトの優先度を設定します。',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットのためのデフォルトの優先度を設定します。',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '担当者インタフェースで、新規Eメール・チケットに関してデフォルトの送信者タイプを設定します。',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットのためのデフォルトの送信者タイプを設定します。',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '担当者インタフェースで、新規Eメール・チケットに関してデフォルトの件名を設定します（例：\'email Outbound\')。',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットのためのデフォルトの件名を設定します。（例：\'Phone call\'）',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、追加されたノートに関するデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '担当者インタフェースの移動チケット画面で、追加されるノートのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、追加されたノートのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、追加されたノートのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、追加された注釈のデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、追加されたノートのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、追加されたノートのデフォルトの件名を設定します。',
        'Sets the default text for new email tickets in the agent interface.' =>
            '担当者インタフェースで、新規Eメール・チケットに関してデフォルトのテキストを設定します。',
        'Sets the display order of the different items in the preferences view.' =>
            'プレファレンス・ビューにおいて異なるアイテムを表示する順番を設定します。',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'セッションが切られユーザがログアウトするまで経過する、非活動時間（秒）を設定します。',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '最小のチケット・カウンター・サイズを設定します（"AutoIncrement"がチケット番号生成として選択されていた場合）。デフォルトは5で、これはカウンターが10000から始まることを意味します。',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            'オートコンプリート・クエリーが送信される前に、最小文字数を設定します。',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'テキスト・メッセージに表示される行の数を設定します（つまり、キュー・ズーム内のチケット・ラインのためです）。',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            'オートコンプリート機能に関して、表示される検索結果の数を設定します。',
        'Sets the options for PGP binary.' => 'PGPバイナリのためのオプションを設定します。',
        'Sets the order of the different items in the customer preferences view.' =>
            '顧客プレファレンス・ビューにおいて、異なる項目の順番を設定してください。',
        'Sets the password for private PGP key.' => '秘密PGP鍵のためのパスワードを設定します。',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '優先される時間の単位（例：業務ユニット、時間、分）を設定します。',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'ウェブ・サーバ上に設定されるように、サーバ上のスクリプト・フォルダに対する接頭辞を設定します。この設定は、OTRS_CONFIG_ScriptAlias変数として設定され、これはアプリケーションによって使用されるメッセージングの全フォームに存在し、システム内のチケットへのリンクを作成するために使用されます。',
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
            '担当者インタフェースのクローズ・チケット画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、チケットに関して責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、チケットの責任を持つ担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、チケットの責任を持つ担当者を設定します。',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '担当者インタフェースのクローズ・チケット画面で、サービスを設定します(Ticket::Serviceを有効とする必要があります)。',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、サービスを設定します(Ticket::Serviceを有効とする必要があります)。',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '担当者インタフェースのチケット・ノート画面で、サービスを設定します(Ticket::Serviceを有効とする必要があります)。',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、サービスを設定します（Ticket::Serviceを有効とする必要があります)。',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、サービスを設定します（Ticket::Serviceを有効とする必要があります)。',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '担当者インタフェースのチケット責任者画面で、サービスを設定します(Ticket::Serviceを有効とする必要があります)。',
        'Sets the size of the statistic graph.' => '統計グラフのサイズを設定します。',
        'Sets the stats hook.' => '統計フックを設定します。',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            'システムのタイム・ゾーン（システム・タイムとしてUTCを持つシステムが必要）。そうでない場合、これはローカル・タイムに対するdiffタイムとなります。',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、チケットの所有者を設定します。',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、チケット所有者を設定します。',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '担当者インタフェースのクローズ・チケット画面で、チケット・タイプを設定します（Ticket::Typeを有効とする必要があります）。',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '担当者インタフェースのチケット・フリー・テキスト画面で、チケットのタイプを設定します。Ticket::Typeが有効となっている必要があります。',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '担当者インタフェースのチケット・ノート画面で、チケット・タイプを設定します（Ticket::Typeを有効とする必要があります)。',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、チケット・タイプを設定します（Ticket::Typeを有効とする必要があります）。',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、チケット・タイプを設定します（Ticket::Typeを有効とする必要があります）。',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '担当者インタフェースのチケット責任者画面で、チケット・タイプを設定します（Ticket::Typeを有効とする必要があります)。',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => '表示されるタイム・タイプを設定します。',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'http/ftp downloadsのためのタイムアウト（秒）を設定します。',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'パッケージ・ダウンロードのためのタイムアウト（秒）を設定します。"WebUserAgent::Timeout"を上書きします。',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'ユーザごとのユーザ・タイム・ゾーンを設定します（システム・タイムとしてUTCを持つシステム、およびTimeZone下のUTCが必要）。そうでない場合、これはローカル・タイムに対するdiffタイムとなります。',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'ログイン・タイムにおけるjava script / browser time zone オフセット機能を基に、ユーザごとのユーザ・タイム・ゾーンを設定します。',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '担当者インタフェースにおいて、電話およびEメールのチケットにおける責任者のセレクションを表示します。',
        'Show article as rich text even if rich text writing is disabled.' =>
            'リッチ・テキストのライティングが無効にされている場合でも、項目をリッチ・テキストで表示します。',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '項目に添付ファイルがある場合、チケット・ズームでアイコン・アカウントを表示します。',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットのサブスクライブ/アンサブスクライブを行うためのリンクをメニューに表示します。',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットを他のオブジェクトとリンクさせるリンクをメニューに表示します。',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットを結合（merge）させるためのリンクをメニューに表示します。',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケット履歴にアクセスするためのリンクをメニューに表示します。',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットにフリー・テキスト・フィールドを追加するためのリンクをメニューに表示します。',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットにノートを追加するためのリンクをメニューに表示します。',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットにノートを追加するためのリンクをメニューに表示します。',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットをクローズするためのリンクをメニューに表示します。',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットをクローズするためのリンクをメニューに表示します。',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '担当者インタフェースの全チケット一覧で、チケットを削除するするためのリンクをメニューに表示します。本リンクを表示または非表示にするための追加的アクセス・コントロールについては、“Group”キーおよび"rw:group1;move_into:group2"のようなコンテンツを使用することで可能になります。',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットを削除するためのリンクをメニューに表示します。本リンクを表示または非表示にするための追加的アクセス・コントロールについては、“Group”キーおよび"rw:group1;move_into:group2"のようなコンテンツを使用することで可能になります。',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューに戻るためのリンクを、メニューに表示します。',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットをロック/アンロックするためのリンクをメニューに表示します。',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットをロック/アンロックするためのリンクをメニューに表示します。',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットを移動するためのリンクをメニューに表示します。',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットまたは項目を印刷するためのリンクをメニューに表示します。',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、そのチケットをリクエストした顧客を確認するためのリンクをメニューに表示します。',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットのチケット履歴を確認するためのリンクをメニューに表示します。',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットの所有者を確認するためのリンクをメニューに表示します。',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットの優先度を確認するためのリンクをメニューに表示します。',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットの責任を有する担当者を確認するためのリンクをメニューに表示します。',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットを保留に設定するためのリンクをメニューに表示します。',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '担当者インタフェースの全チケット一覧で、チケットをスパムとして設定するためのリンクをメニューに表示します。本リンクを表示または非表示にするための追加的アクセス・コントロールについては、“Group”キーおよび"rw:group1;move_into:group2"のようなコンテンツを使用することで可能になります。',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットの優先度を設定するためのリンクをメニューに表示します。',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットにズームするためのリンクをメニューに表示します。',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '担当者インタフェースの項目ズーム・ビューにおいて、項目の添付ファイルにhtmlオンライン・ビュアーでアクセスするためのリンクを表示します。',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '担当者インタフェースの項目ズーム・ビューにおいて、項目の添付ファイルをダウンロードするためのリンクを表示します。',
        'Shows a link to see a zoomed email ticket in plain text.' => 'ズームされたEメール・チケットを、プレイン・テキストで見るためのリンクを表示します。',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '担当者インタフェースのチケット・ズーム・ビューで、チケットをスパムとして設定するするためのリンクをメニューに表示します。本リンクを表示または非表示にするための追加的アクセス・コントロールについては、“Group”キーおよび"rw:group1;move_into:group2"のようなコンテンツを使用することで可能になります。',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、そのチケットに関与する全担当者のリストです。',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、可能性ある担当者（キュー/チケットに対してノートの許可を有する全ての担当者）のリストを表示し、そのノートについて誰に通知するべきか決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、可能性ある全ての担当者（キュー/チケットに関してノート許可を有する全ての担当者）を表示し、そのノートに関して誰に通知するべきかを決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、可能性ある担当者（キュー/チケットに対してノート許可を持つ全担当者）を表示し、そのノートについて誰に通知するか決定しまう。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、全ての可能性ある担当者（キュー/チケットにノート許可を有する全ての担当者）のリストを表示し、その注釈について誰に通知するべきかを決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、全ての可能性ある担当者（キュー/チケットに注釈許可を有する全ての担当者）のリストを表示し、その注釈について誰に通知するべきかを決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、全ての可能性ある担当者（キュー/チケットにノート許可を有する全ての担当者）のリストを表示し、そのノートについて誰に通知するべきかを決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、全ての可能性ある担当者（キュー/チケットにノート許可を有する全ての担当者）のリストを表示し、そのノートについて誰に通知するべきかを決定します。',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'チケット一覧のプレビューを表示します(CustomerInfo => 1 - 顧客情報も表示しますCustomerInfoMaxSize max – 顧客情報の文字サイズです)。',
        'Shows all both ro and rw queues in the queue view.' => 'キュー・ビューで、roとrwの両方全てのキューを表示します。',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '担当者インタフェースのエスカレーション・ビューにある、全てのオープン・チケット（たとえロックされていたとしても）を表示します。',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '担当者インタフェースの状態ビューで、全てのオープンのチケット（ロックされているものも含む）を表示します。',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'ズーム・ビューで、チケットの全項目を表示します（拡大される）',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '全ての顧客識別子をマルチ・セレクトのフィールドに表示します（顧客識別子を多く抱えている場合は利便性が低いです）。',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '担当者インタフェースにおいて、電話およびEメールのチケットにおける所有者のセレクションを表示します。',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'AgentTicketPhone、AgentTicketEmail、AgentTicketCustomerにおいて、顧客履歴チケットを表示します。',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '最後の顧客の項目の件名またはチケットのタイトルを、小さいフォーマットの一覧で表示します。',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'システム内に存在する親/子キューのリストを、ツリーまたはリストの形式で表示します。',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '顧客インタフェースで有効化されたチケット属性を表示します（0 = Disabled、 1 = Enabled)。',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '担当者インタフェースのチケット・ズームの下で、ノーマルまたは逆順でソートされた項目を表示します。',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '構成画面において、顧客ユーザ情報（電話およびEメール）を表示します。',
        'Shows the customer user\'s info in the ticket zoom view.' => 'チケット・ズーム・ビューにおける顧客ユーザの情報を表示します。',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '担当者ダッシュボードに、その日のメッセージ（MOTD）を表示します。“Group”は、プラグインへのアクセスを制限するために使用されます（Group: admin;group1;group2;)。“Default”は、プラグインがデフォルトで有効になっているか、またはそれをユーザが手動で有効にする必要があるか、を示しています。',
        'Shows the message of the day on login screen of the agent interface.' =>
            '担当者インタフェースのログイン画面において、その日のメッセージを表示します。',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '担当者インタフェースで、チケット履歴（逆の順番）を表示します。',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、チケット優先度オプションを表示します。',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '担当者インタフェースの移動チケット画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、チケットの優先度オプションを表示します。',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、チケット優先度のオプションを表示します。',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、タイトルのフィールドを表示します。',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、タイトルのフィールドを表示します。',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・ノート画面で、タイトルのフィールドを表示します。',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、タイトルのフィールドを表示します。',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、タイトルのフィールドを表示します。',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、タイトルのフィールドを表示します。',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、タイトルのフィールドを表示します。',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '"Yes"に設定すると時間を長いフォーマットで表示し（日、時、分）、"No"に設定すると短いフォーマットで表示します（日、時）。',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '"Yes"に設定すると完全な記述による時間を表示し（days, hours, minutes)、"No"に設定すると最初の文字のみ表示します（d, h, m）。',
        'Skin' => 'スキン',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '1つのキューがキュー・ビューで選択され、チケットが優先度によってソートされた後に、チケットをソートします（昇順または降順）。Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top)。キーに関してキューIDを使用し、値（value）に関して0または1を使用してください。',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'スパム・アサシンのセットアップ例です。スパム・アサシンによってマークされたEメールを無視します。',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'SpamAssassinのセットアップ例です。マークされたメールを、スパム・キューへ移動します。',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '担当者が自分自身のアクションに関してEメール通知を受け取る必要があるかどうか、を設定します。',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => 'チャートの背景色を指定します。',
        'Specifies the background color of the picture.' => '画像の背景色を指定します。',
        'Specifies the border color of the chart.' => 'チャートの境界色を指定します。',
        'Specifies the border color of the legend.' => '凡例の境界色を指定します。',
        'Specifies the bottom margin of the chart.' => 'チャートの下のマージンを指定します。',
        'Specifies the different article types that will be used in the system.' =>
            'システムで使用される異なる項目のタイプを特定します。',
        'Specifies the different note types that will be used in the system.' =>
            'システムで使用される、異なるノートのタイプを特定します。',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'TicketStorageModuleに関して“FS”が選ばれている場合、データを保存するためにディレクトリを保存してください。',
        'Specifies the directory where SSL certificates are stored.' => 'SSL認証が格納されるディレクトリを特定します。',
        'Specifies the directory where private SSL certificates are stored.' =>
            '秘密SSL認証が格納されるディレクトリを特定します。',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '通知を送信する際に、アプリケーションによって使用されるEメール・アドレスを設定します。Eメール・アドレスは、通知マスターに対して完全なディスプレイ名を作るために、使用されます（例："OTRS Notification Master" otrs@your.example.com）。ご利用のコンフィグに設定されているOTRS_CONFIG_FQDN変数を使用したり、別のEメール・アドレスを選択したりすることも可能です。通知は、en::Customer::QueueUpdate または en::Agent::Moveなどのメッセージです。',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => 'チャートの左のマージンを指定します。',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '通知を送信する際に、アプリケーションによって使用される名前を設定します。送信者名は、通知マスターに対して完全なディスプレイ名を作るために、使用されます（例："OTRS Notification Master" otrs@your.example.com）。通知は、en::Customer::QueueUpdate または en::Agent::Moveなどのメッセージです。.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'ページ・ヘッダーにおいて、ロゴのためのファイルへのパスを特定します(gif|jpg|png, 700 x 100 pixel)。',
        'Specifies the path of the file for the performance log.' => 'パフォーマンス・ログのためのファイルのパスを特定します。',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'ウェブ・インタフェースにて、Microsoft Excelファイルを見られるようにするコンバータへのパスを特定します。',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'ウェブ・インタフェースにて、Microsoft Wordファイルを見られるようにするコンバータへのパスを特定します。',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'ウェブ・インタフェースにて、PDFドキュメントを見られるようにするコンバータへのパスを特定します。',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'ウェブ・インタフェースにて、XMLファイルを見られるようにするコンバータへのパスを特定します。',
        'Specifies the right margin of the chart.' => 'チャートの右のマージンを指定します。',
        'Specifies the text color of the chart (e. g. caption).' => 'チャートの文字色を指定します(例: キャプション)。',
        'Specifies the text color of the legend.' => '凡例の文字色を指定します。',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'ログ・ファイルの中でCGIスクリプト・エントリーを意味するテキストを規定します。',
        'Specifies the top margin of the chart.' => 'チャートの上のマージンを指定します。',
        'Specifies user id of the postmaster data base.' => 'ポストマスター・データベースのユーザIDを特定します。',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'アプリケーション内で担当者にとって標準的に利用可能な許可です。もし、さらに多くの許可が必要であれば、ここで加えることができます。許可は、効果的になるように設定する必要があります。いくつか他の良い許可も、ビルト・インで提供されています：note, close, pending, customer, freetext, move, compose, responsible, forward, bounce。“rw”は、常に最後の登録許可であることを確認してください。',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '統計カウンティングの数をスタートします。全ての新規統計はこの数字を増加させます。',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => '統計',
        'Status view' => '状態一覧',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'ブラウザが閉じられた後に、クッキーを格納します。',
        'Strips empty lines on the ticket preview in the queue view.' => 'キュー・ビューで、チケット・プレビューの空の行を削除します。',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '"bin/PostMasterMailAccount.pl"が、特定された数のメッセージの後に、POP3/POP3S/IMAP/IMAPSホストに接続します。',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '担当者インタフェースで使用されるべき、担当者スキンのインターナル・ネームです。Frontend::Agent::Skinsにおける利用可能なスキンをチェックしてください。',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '顧客インタフェースにて使用される顧客スキンのInternalNameです。Frontend::Customer::Skinsにおいて利用可能なスキンをチェックしてください。',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'チケットフックとチケット番号の間の仕切りです。例：\': \'',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '件名のフォーマットです。\'Left\'は、\'[TicketHook#:12345] 件名\'を意味し、\'Right\'は、\'件名 [TicketHook#:12345]\'を意味し、\'None\'は、\'件名\'でチケット番号はありません。最後のパターンでは、Eメール・ヘッダーおよび本文を基にフォロー・アップであることを認識するため、PostmasterFollowupSearchInRawまたはPostmasterFollowUpSearchInReferencesを有効にすると良いでしょう。',
        'The headline shown in the customer interface.' => '顧客インターフェイスの見出し',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '例えばTicket#, Call#, MyTicket#などのチケットの識別子です。デフォルトはTicket#です。',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '担当者インタフェースのログイン・ボックスに表示されるロゴです。本イメージに対するURLは、スキン・イメージ・ディレクトリへの相対URLである必要があります。',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Eメール・リプライにおける件名の最初のテキストです。例：RE, AW, AS。',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Eメールが転送された際の、件名の最初のテキストです。例：FW, Fwd, WG。',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '定義された場合、全てのリクエストに対して、本モジュールおよびそのPreRun()機能が実行されます。本モジュールは、いくつかのユーザ・オプションをチェックするため、または新しいアプリケーションのニュースを表示させるために、役立つものです。',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'チケット一覧',
        'TicketNumber' => '',
        'Tickets' => 'チケット',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '保留中のステートを設定した場合、実際の時間に加えられる時間（秒）です。(default: 86400 = 1 day)',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => 'ショートカットのためのツールバー・アイテムです。',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'GUIで使用されるアニメーションをONにします。もし、これらのアニメーションに問題がある場合（パフォーマンス問題など）、ここでOFFにできます。',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'リモートIPアドレス・チェックをONにします。もし、例えばproxy farmまたはdialup connection経由でアプリケーションが使用されている場合、"No"の設定する必要があります。なぜなら、リモートIPアドレスは、ほとんどの場合リクエストごとに異なるからです。',
        'Types' => 'タイプ',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '全ての項目が確認された、または新規のArticleが作成された場合に、チケット“Seen”フラグをアップデートします。',
        'Update and extend your system with software packages.' => 'このシステムのソフトウェアパッケージの更新と拡張',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'チケット属性がアップデートされた後に、チケット・エスカレーション・インデックスをアップデートします。',
        'Updates the ticket index accelerator.' => 'チケット・インデックス・アクセラレイタのアップです',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、コンポーズEメール回答にあるCCリスト上からCC受信者を使用します。',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            'ビューと編集のためにリッチテキストを使用します：アーティクル、挨拶、署名、標準的な返答、自動返答、通知。',
        'View performance benchmark results.' => 'パフォーマンスベンチマーク結果を見る。',
        'View system log messages.' => 'システムログメッセージを見る。',
        'Wear this frontend skin' => 'このフロントエンドスキンに変更。',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '"Inform Sender"チェック・ボックスを設定することで、チケットが結合された際に顧客がEメールで通知されるようにできます。このテキスト領域では、担当者によって後から修正できる事前フォーマット化されたテキストを定義することができます。',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '担当者インタフェースでズームされたチケットのチケット結合画面で、チケット・ロックが必要かどうかを定義します。（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            '',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、受領者に顧客Eメール・アドレスを追加します。',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '担当者インタフェースのチケット検索で、検索条件の拡張を許可します。この機能により、利用者はw. g.を次のような条件で検索できます"(key1&&key2)" または "(key1||key2)"。',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'フル・テキストのインデックスを設定します。新しいインデックスを作成するには、"bin/otrs.RebuildFulltextIndex.pl"を実行してください。',
        'Customer Data' => '顧客情報',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box (to avoid the use of destructive queries, such as DROP DATABASE, and also to steal user passwords).' =>
            'ウェブ・インストーラーを無効にし(http://yourhost.example.com/otrs/installer.pl)、システムがハイジャックされるのを防ぎます。もし、“No”に設定されている場合は、システムは再インストールすることができ、現在の基本設定がインストーラー・スクリプト内の質問に事前投入されます。もしアクティブでなれけば、Generic Agent、パッケージ・マネジャー、SQLボックスも無効にします（これは、DROP DATABASEなどの破壊的クエリーの使用を避け、ユーザ・パスワードの盗難を防ぐためです）。',
        'Experimental "Slim" skin which tries to save screen space for power users.' =>
            'パワーユーザ用に画面スペースを省くための、実験的な“スリム”スキンです。',
        'For more info see:' => '詳細情報：',
        'Logout successful. Thank you for using OTRS!' => 'ログアウトしました。OTRSのご利用ありがとうございます！',
        'Maximum size (in characters) of the customer info table in the queue view.' =>
            'キュー・ビューにおける、顧客情報テーブル（電話およびEメール）の最大サイズ（文字）です。',
        'Package verification failed!' => 'パッケージの検証に失敗しました',
        'Please supply a' => '入力してください: ',
        'Please supply a first name' => '名前を入力してください',
        'Please supply a last name' => '名字を入力してください。',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'セキュアモードで実行中のため、Webインストーラーで再インストールするには無効にする必要があります。',

    };
   # $$STOP$$
   return;
}

1;
