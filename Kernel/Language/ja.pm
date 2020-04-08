# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2010-2011 Kaz Kamimura <kamypus at yahoo.co.jp>
# Copyright (C) 2011/12/08 Kaoru Hayama TIS Inc.
# Copyright (C) 2014 Norihiro Tanaka NTT Data Intellilink Corp.
# Copyright (C) 2014 Toshihiro Takehara Cloud ASIA Co., Ltd.
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::ja;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%Y/%M/%D %T';
    $Self->{DateFormatLong}      = '%Y/%M/%D - %T';
    $Self->{DateFormatShort}     = '%Y/%M/%D';
    $Self->{DateInputFormat}     = '%Y/%M/%D';
    $Self->{DateInputFormatLong} = '%Y/%M/%D - %T';
    $Self->{Completeness}        = 0.761090416525567;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = '.';
    $Self->{ThousandSeparator} = ',';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL管理',
        'Actions' => '操作',
        'Create New ACL' => '新しいACLを作成',
        'Deploy ACLs' => 'ACLをデプロイ',
        'Export ACLs' => 'ACLをエクスポート',
        'Filter for ACLs' => 'ACLでフィルタ',
        'Just start typing to filter...' => 'フィルタリングするには入力してください...',
        'Configuration Import' => '設定のインポート',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'ここにACLをインポートするための設定ファイルをアップロードできます。ファイルはACLエディタモジュールによってエクスポートされるような.ymlフォーマットである必要があります。',
        'This field is required.' => 'この領域は必須です。',
        'Overwrite existing ACLs?' => '既存のACLを上書きしますか？',
        'Upload ACL configuration' => 'ACL設定を更新',
        'Import ACL configuration(s)' => 'ACL設定をインポート',
        'Description' => '説明',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '新規のACLは、他のシステムからエクスポートしたACLをインポートするか、完全に新規で作成するかのいずれかの方法で作成できます。',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'ここでのACLの変更はACLをデプロイした後に反映されます。デプロイにより新規の変更は設定に書き込まれます。',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'このテーブルはACLの実行順序に影響を与えます。もし実行順序を変更したい場合には、ACLの名前を変更して下さい。',
        'ACL name' => 'ACL名',
        'Comment' => 'コメント',
        'Validity' => '有効/無効',
        'Export' => 'エクスポート',
        'Copy' => 'コピー',
        'No data found.' => 'データがありません',
        'No matches found.' => '一致しませんでした。',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ACLの %s を編集',
        'Edit ACL' => 'ACLを編集',
        'Go to overview' => '一覧に戻る',
        'Delete ACL' => 'ACLを削除',
        'Delete Invalid ACL' => '無効なACLを削除',
        'Match settings' => '条件設定',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'ACLでマッチする対象を指定します。\'Properties\'の場合現在画面に表示されている値を、\'PropertiesDatabase\'の場合、DBに保存されている値を使用します。',
        'Change settings' => '変更設定',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'マッチした対象をどのように絞り込むかを指定します。\'Possible\'はホワイトリスト、\'PossibleNot\'はブラックリストです。',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => '内容の表示・非表示',
        'Edit ACL Information' => 'ACL情報を編集',
        'Name' => '名前',
        'Stop after match' => '一致後に停止',
        'Edit ACL Structure' => 'ACL構造を修正',
        'Save ACL' => 'ACLの保存',
        'Save' => '保存',
        'or' => 'または',
        'Save and finish' => '保存して終了',
        'Cancel' => '取消',
        'Do you really want to delete this ACL?' => 'このACLを本当に削除しますか？',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'フォームを送信することにより、新規にACLを作成する事ができます。ACLを作成後、編集モードより構成アイテムを追加することができます。',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'カレンダー管理',
        'Add Calendar' => 'カレンダーの登録',
        'Edit Calendar' => 'カレンダーを編集',
        'Calendar Overview' => 'カレンダー表示',
        'Add new Calendar' => 'カレンダーの登録',
        'Import Appointments' => '予約のインポート',
        'Calendar Import' => 'カレンダーをインポート',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'ここでカレンダーの設定ファイルをアップロードすることができます。ファイルはカレンダー管理モジュールがエクスポートした".yml"フォーマットである必要があります。',
        'Overwrite existing entities' => '存在するエンティティを上書き',
        'Upload calendar configuration' => 'カレンダー設定をアップロードする',
        'Import Calendar' => 'カレンダーをインポート',
        'Filter for Calendars' => 'カレンダーでフィルター',
        'Filter for calendars' => 'カレンダーでフィルター',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'グループフィールド毎のユーザーに許可レベルに応じて、システムはカレンダーへのアクセスを許可します。',
        'Read only: users can see and export all appointments in the calendar.' =>
            '読み取り専用：ユーザーはカレンダー内の全ての予定を表示およびエクスポートできます。',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '移動先：ユーザーは予定表の予定を変更することなく、予定表の予定を変更できます。',
        'Create: users can create and delete appointments in the calendar.' =>
            '作成: ユーザーはカレンダーにアポイントメントを作成/削除できます。',
        'Read/write: users can manage the calendar itself.' => '読み書き可能：ユーザーはカレンダー自体を管理できます。',
        'Group' => 'グループ',
        'Changed' => '変更日時',
        'Created' => '作成',
        'Download' => 'ダウンロード',
        'URL' => 'URL',
        'Export calendar' => 'カレンダーのエクスポート',
        'Download calendar' => 'カレンダーのダウンロード',
        'Copy public calendar URL' => '公開カレンダーのURLをコピーする',
        'Calendar' => 'カレンダー',
        'Calendar name' => 'カレンダー名',
        'Calendar with same name already exists.' => '同じ名前のカレンダーは既に存在します。',
        'Color' => '色',
        'Permission group' => '権限グループ',
        'Ticket Appointments' => 'チケットの予約',
        'Rule' => 'ルール',
        'Remove this entry' => '登録を削除',
        'Remove' => '削除',
        'Start date' => '開始日',
        'End date' => '終了日時',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '以下のオプションを使用して、チケットの予定が自動的に作成される範囲を絞り込みます。',
        'Queues' => 'キュー',
        'Please select a valid queue.' => '有効なキューを選択して下さい。',
        'Search attributes' => '検索属性',
        'Add entry' => '登録を追加',
        'Add' => '追加',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'チケットデータに基づいてこのカレンダーで自動予定を作成するためのルールを定義します。',
        'Add Rule' => 'ルールを追加',
        'Submit' => '送信',

        # Template: AdminAppointmentImport
        'Appointment Import' => '予約のインポート',
        'Go back' => '戻る',
        'Uploaded file must be in valid iCal format (.ics).' => 'アップロードするファイルはiCalフォーマット(拡張子.ics)である必要があります。',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'もし意図したカレンダーが表示されていない場合、自身に作成権限が付与されていることを確認してください。',
        'Upload' => 'アップロード',
        'Update existing appointments?' => '既存の予定を更新しますか？',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'カレンダー内に同じユニークIDを持つ既存の予定はすべて上書きされます。',
        'Upload calendar' => 'カレンダーをアップロード',
        'Import appointments' => '予約のインポート',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '予約通知の管理',
        'Add Notification' => '通知の追加',
        'Edit Notification' => '通知の編集',
        'Export Notifications' => '通知をエクスポート',
        'Filter for Notifications' => '通知でフィルター',
        'Filter for notifications' => '通知でフィルター',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'ここでカレンダー通知の設定ファイルをアップロードすることができます。ファイルはカレンダー管理モジュールがエクスポートした".yml"フォーマットである必要があります。',
        'Overwrite existing notifications?' => '存在する通知を上書きしますか。',
        'Upload Notification configuration' => '通知設定のアップロード',
        'Import Notification configuration' => '通知の設定をインポート',
        'List' => 'リスト',
        'Delete' => '削除',
        'Delete this notification' => 'この通知を削除',
        'Show in agent preferences' => '担当者のプリファレンスに表示',
        'Agent preferences tooltip' => '担当者プリファレンスツールチップ',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'このメッセージはこの通知に対するツールチップとして担当者プリファレンス画面に表示されます。',
        'Toggle this widget' => 'このウィジェットを切り替え',
        'Events' => 'イベント',
        'Event' => 'イベント',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'ここで、この通知のトリガーとなるイベントを選択できます。 追加の予約フィルターを以下に適用して、それに適合する予約のみに送信できます。',
        'Appointment Filter' => '予約のフィルター',
        'Type' => 'タイプ',
        'Title' => 'タイトル',
        'Location' => 'ロケーション',
        'Team' => 'チーム',
        'Resource' => 'リソース',
        'Recipients' => '受信者',
        'Send to' => '送信先',
        'Send to these agents' => 'これらの担当者に送信',
        'Send to all group members (agents only)' => 'グループ内の全面バーに送信（担当者のみ）',
        'Send to all role members' => 'ロールの全てのメンバーに送付',
        'Send on out of office' => '外出中の担当者に送信',
        'Also send if the user is currently out of office.' => '現在外出中のユーザーにも送付する。',
        'Once per day' => '一日に一度',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '選択された通知方法を使って1つの予約に対して1日に1度だけユーザーに通知します。',
        'Notification Methods' => '通知方法',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => 'この通知方法を有効化',
        'Transport' => 'トランスポート',
        'At least one method is needed per notification.' => '通知ごとに最低1つの通知方法が必要です。',
        'Active by default in agent preferences' => '担当者の環境設定ではデフォルトで有効になります。',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'これは、全ての担当者の個々の環境設定に通知にチェックが入ります。そして通知されます。',
        'This feature is currently not available.' => 'この機能は現在利用できません。',
        'Upgrade to %s' => '%s にアップグレードする',
        'Please activate this transport in order to use it.' => '使用するには、このトランスポートを有効にしてください。',
        'No data found' => 'データがありません',
        'No notification method found.' => '通知方法が見つかりませんでした。',
        'Notification Text' => '通知文書',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'この言語は存在しないか有効化されていません。必要が無いのであればこの通知文を削除できます。',
        'Remove Notification Language' => '通知する言語の削除',
        'Subject' => '表題',
        'Text' => '本文',
        'Message body' => 'メッセージボディー',
        'Add new notification language' => '新規通知言語を追加',
        'Save Changes' => '変更を保存',
        'Tag Reference' => 'タグリファレンス',
        'Notifications are sent to an agent.' => '通知は担当者へ送信されます。',
        'You can use the following tags' => '次のタグを使用できます',
        'To get the first 20 character of the appointment title.' => 'アポイントの表題から最初の20文字を取得',
        'To get the appointment attribute' => '予定の属性を取得すること',
        ' e. g.' => '例',
        'To get the calendar attribute' => 'カレンダーの属性を取得すること',
        'Attributes of the recipient user for the notification' => '通知する受信者ユーザーの属性',
        'Config options' => '設定オプション',
        'Example notification' => '通知例',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '追加の受信者のメールアドレス',
        'This field must have less then 200 characters.' => 'このフィールドへの入力文字数は200文字未満でなければなりません。',
        'Article visible for customer' => '顧客が閲覧可能な記事',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '顧客または追加のメールアドレスに通知が送られる際に記事が作成されます。',
        'Email template' => 'メールテンプレート',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '完全なメールを生成するためにこのテンプレートを使う。(HTMLメールに対してのみ)',
        'Enable email security' => 'メールセキュリティを有効にする',
        'Email security level' => 'メールのセキュリティレベル',
        'If signing key/certificate is missing' => 'もし署名された鍵/証明書が存在しない場合',
        'If encryption key/certificate is missing' => 'もし暗号化された鍵/証明書が存在しない場合',

        # Template: AdminAttachment
        'Attachment Management' => '添付ファイル管理',
        'Add Attachment' => '添付ファイルを追加',
        'Edit Attachment' => '添付ファイルを編集',
        'Filter for Attachments' => '添付ファイルでフィルタ',
        'Filter for attachments' => '添付ファイルのフィルター',
        'Filename' => 'ファイル名',
        'Download file' => 'ダウンロードファイル',
        'Delete this attachment' => 'この添付ファイルを削除',
        'Do you really want to delete this attachment?' => '本当にこの添付ファイルを削除してよろしいですか？',
        'Attachment' => '添付ファイル',

        # Template: AdminAutoResponse
        'Auto Response Management' => '自動応答管理',
        'Add Auto Response' => '自動応答追加',
        'Edit Auto Response' => '自動応答編集',
        'Filter for Auto Responses' => '自動応答でフィルタ',
        'Filter for auto responses' => '自動応答でフィルター',
        'Response' => '応答',
        'Auto response from' => '自動応答差出人',
        'Reference' => '用例',
        'To get the first 20 character of the subject.' => '表題の最初の20文字を取得',
        'To get the first 5 lines of the email.' => 'メールの最初の5行を取得',
        'To get the name of the ticket\'s customer user (if given).' => 'チケットの顧客ユーザー名を取得(可能な場合)',
        'To get the article attribute' => '記事の属性を取得',
        'Options of the current customer user data' => '現在の顧客ユーザーデータのオプション',
        'Ticket owner options' => 'チケット所有者オプション',
        'Ticket responsible options' => 'チケット責任者オプション',
        'Options of the current user who requested this action' => '操作を要求された現在のユーザーのオプション',
        'Options of the ticket data' => 'チケットデータのオプション',
        'Options of ticket dynamic fields internal key values' => 'チケットのダイナミック・フィールドの内部キー値のオプション',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'チケットのダイナミック・フィールドの表示値のオプション。ドロップダウンまたは複数選択領域で利用可能・',
        'Example response' => '応答例',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'クラウドサービス管理',
        'Support Data Collector' => 'サポート情報コレクター',
        'Support data collector' => 'サポート情報コレクター',
        'Hint' => 'ヒント',
        'Currently support data is only shown in this system.' => '現在サポートしているデーターはこのシステムでのみ表示されています。',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'より良いサポートを提供するために、このデータをOTRSグループにお送りいただくことを強くお勧めします。',
        'Configuration' => '設定',
        'Send support data' => 'サポート情報の送信',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'この操作は、システムによる OTRS Group への追加サポート情報の送信を許可します。',
        'Update' => '更新',
        'System Registration' => 'システム登録',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'データ送信を有効にするために、OTRS Group へのシステムの登録・更新をお願いします (併せて「サポート情報の送信」のチェックを有効にするのを忘れずに)。',
        'Register this System' => 'このシステムをサポート登録する',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'システムのサポート登録機能が無効になっています。設定をご確認ください。',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'OTRSグループへのシステムのサポート登録により、多くのメリットが提供されます。',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'OTRS クラウドサービスのご利用には、システムの登録が必要となりますのでご注意ください。',
        'Register this system' => 'このシステムをサポート登録する',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'ここで、 %s と安全に通信するために利用可能なクラウドサービスを構成できます。',
        'Available Cloud Services' => '利用可能なクラウドサービス',

        # Template: AdminCommunicationLog
        'Communication Log' => 'コミュニケーション・ログ',
        'Time Range' => '時間の範囲',
        'Show only communication logs created in specific time range.' =>
            '特定の時間範囲で作成された通信ログのみを表示します。',
        'Filter for Communications' => '',
        'Filter for communications' => 'コミュニケーションでフィルター',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'この画面では、着信および発信コミュニケーションの概要を確認できます。',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '',
        'Status for: %s' => 'ステータス: %s',
        'Failing accounts' => '失敗したアカウント',
        'Some account problems' => 'いくつかのアカウントの問題',
        'No account problems' => 'アカウントの問題はありません',
        'No account activity' => 'アカウントのアクティビティはありません',
        'Number of accounts with problems: %s' => '問題のあるアカウントの数: %s',
        'Number of accounts with warnings: %s' => '警告のあるアカウント数: %s',
        'Failing communications' => 'コミュニケーションのフィルター',
        'No communication problems' => 'コミュニケーション上の問題はありません',
        'No communication logs' => 'コミュニケーション・ログがない',
        'Number of reported problems: %s' => '報告された問題の数：%s',
        'Open communications' => 'コミュニケーションを開く',
        'No active communications' => '有効なコミュニケーションがありません',
        'Number of open communications: %s' => '開いているコミュニケーションの数：%s',
        'Average processing time' => '平均処理時間',
        'List of communications (%s)' => 'コミュニケーションのリスト (%s)',
        'Settings' => '設定',
        'Entries per page' => '1ページあたりのエントリ数',
        'No communications found.' => 'コミュニケーション・ログが存在しません。',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'アカウントのステータス',
        'Back to overview' => '一覧に戻る',
        'Filter for Accounts' => 'アカウントでフィルター',
        'Filter for accounts' => 'アカウントでフィルター',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '列ヘッダーをクリックすると、列の並べ替えや順序を変更できます。',
        'Account status for: %s' => 'アカウントステータス：%s',
        'Status' => 'ステータス',
        'Account' => 'アカウント',
        'Edit' => '編集',
        'No accounts found.' => 'アカウントが存在しません。',
        'Communication Log Details (%s)' => 'コミュニケーション・ログの詳細(%s)',
        'Direction' => '方向',
        'Start Time' => 'スタート時間',
        'End Time' => '終了時間',
        'No communication log entries found.' => 'コミュニケーション・ログのエントリが見つかりません。',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '期間',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => '優先度',
        'Module' => 'モジュール',
        'Information' => '情報',
        'No log entries found.' => 'ログ・エントリは見つかりませんでした。',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '詳細ビューは%sから%sのコミュニケーションが開始されました。',
        'Filter for Log Entries' => 'ログエントリーでフィルター',
        'Filter for log entries' => 'ログエントリーでフィルター',
        'Show only entries with specific priority and higher:' => '',
        'Communication Log Overview (%s)' => 'コミュニケーション・ログ一覧（%s）',
        'No communication objects found.' => 'コミュニケーション・オブジェクトが見つかりませんでした。',
        'Communication Log Details' => 'コミュニケーション・ログの詳細',
        'Please select an entry from the list.' => 'リストから項目を選択して下さい。',

        # Template: AdminCustomerCompany
        'Customer Management' => '顧客管理',
        'Add Customer' => '顧客を追加',
        'Edit Customer' => '顧客を編集',
        'Search' => '検索',
        'Wildcards like \'*\' are allowed.' => 'ワイルドカード（*）が使用できます。',
        'Select' => '選択',
        'List (only %s shown - more available)' => '一覧 ( %s 件のみ表示、他候補あり)',
        'total' => '合計',
        'Please enter a search term to look for customers.' => '顧客を検索するための条件を入力してください',
        'Customer ID' => '顧客ID',
        'Please note' => '注意',
        'This customer backend is read only!' => 'この顧客情報は読み取り専用です！',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => '顧客-グループ関連性管理',
        'Notice' => '通知',
        'This feature is disabled!' => 'この機能は無効にされています。',
        'Just use this feature if you want to define group permissions for customers.' =>
            '顧客のグループ権限を設定する場合のみこの機能を使用できます。',
        'Enable it here!' => '有効にする',
        'Edit Customer Default Groups' => '顧客の規定グループの編集',
        'These groups are automatically assigned to all customers.' => 'このグループは自動的にすべての顧客に割り当てられます。',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '設定の"CustomerGroupCompanyAlwaysGroups"で設定することができます',
        'Filter for Groups' => 'グループでフィルタ',
        'Select the customer:group permissions.' => '顧客：グループ権限を選択',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '何も選択しない場合、このグループは権限がありません (チケットは顧客が使用できません)',
        'Search Results' => '検索結果',
        'Customers' => '顧客',
        'Groups' => 'グループ',
        'Change Group Relations for Customer' => '顧客に対するグループの関連性を変更',
        'Change Customer Relations for Group' => 'グループに対する顧客の関連性を変更',
        'Toggle %s Permission for all' => '%s の全権限を切り替え',
        'Toggle %s permission for %s' => '%s の %s 権限を切り替え',
        'Customer Default Groups:' => '顧客の規定グループ:',
        'No changes can be made to these groups.' => '変更はこれらのグループに行うことができます。',
        'ro' => '読取り',
        'Read only access to the ticket in this group/queue.' => 'このグループ／キューのチケットを読み取り専用にします。',
        'rw' => '読書き',
        'Full read and write access to the tickets in this group/queue.' =>
            'このグループ／キューのチケットに読み書きを含めた全権限を付与します。',

        # Template: AdminCustomerUser
        'Customer User Management' => '顧客ユーザー管理',
        'Add Customer User' => '顧客ユーザーを追加',
        'Edit Customer User' => '顧客ユーザーを編集',
        'Back to search results' => '検索結果に戻る',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '顧客ユーザーは顧客履歴の使用と顧客パネルからログインするために必要です。',
        'List (%s total)' => '一覧 (全 %s 件)',
        'Username' => 'ユーザー名',
        'Email' => 'メール',
        'Last Login' => '最終ログイン',
        'Login as' => 'このアドレスとしてログイン',
        'Switch to customer' => '顧客に切り替え',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'この顧客情報は読み取り専用ですが、顧客ユーザー設定は変更可能です！',
        'This field is required and needs to be a valid email address.' =>
            'ここは必須領域で、有効なメールアドレスである必要があります。',
        'This email address is not allowed due to the system configuration.' =>
            'このメールアドレスはシステム設定により許可されていません。',
        'This email address failed MX check.' => 'このメールアドレスのMXレコード検査に失敗しました',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS上の問題が発生しました。設定とエラーログを確認してください。',
        'The syntax of this email address is incorrect.' => 'このメールアドレスは正しい形式ではありません',
        'This CustomerID is invalid.' => '顧客IDが不正です。',
        'Effective Permissions for Customer User' => '顧客ユーザーに対する有効な権限',
        'Group Permissions' => 'グループの権限',
        'This customer user has no group permissions.' => 'この顧客ユーザーはグループ権限を保有していません。',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '上の表は、顧客ユーザーに対して有効なグループ権限を示します。 マトリックスは、すべての継承されたアクセス許可（たとえば、顧客グループを介したもの）を考慮に入れます。注：この表は、フォーム内の未送信分を考慮していません。',
        'Customer Access' => '顧客アクセス',
        'Customer' => '顧客',
        'This customer user has no customer access.' => 'この顧客ユーザーには顧客アクセス権がありません。',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '上の表は、パーミッションコンテキストによって 顧客ユーザー に許可された顧客アクセスを示します。 マトリックスは、すべての継承されたアクセス許可（たとえば、顧客グループを介したもの）を考慮に入れます。注：この表は、フォーム内の未送信分を考慮していません。',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '顧客ユーザー - 顧客の関係を管理',
        'Select the customer user:customer relations.' => '顧客ユーザー - 顧客の関係を選択',
        'Customer Users' => '顧客ユーザー',
        'Change Customer Relations for Customer User' => '顧客ユーザーと顧客の関係を変更',
        'Change Customer User Relations for Customer' => '顧客ユーザーと顧客の関係を変更',
        'Toggle active state for all' => 'すべての有効なステータスを切り替え',
        'Active' => '有効',
        'Toggle active state for %s' => '有効なステータス %s を切り替え',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '顧客ユーザー - グループの関係を管理',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '顧客ユーザー のグループ権限を設定する場合のみこの機能を使用できます。',
        'Edit Customer User Default Groups' => '顧客ユーザーのデフォルトグループの編集',
        'These groups are automatically assigned to all customer users.' =>
            'これらのグループは自動的に全顧客ユーザーに設定されます。',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '設定の"CustomerGroupAlwaysGroups"で設定することができます',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '顧客ユーザーを選択 - グループ・パーミッション',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '何も選択しない場合、このグループは権限がありません (チケットは 顧客ユーザー が使用できません)',
        'Customer User Default Groups:' => '顧客ユーザーのデフォルト・グループ',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => '既定のサービス編集',
        'Filter for Services' => 'サービスでフィルタ',
        'Filter for services' => 'サービスでフィルター',
        'Services' => 'サービス',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'ダイナミック・フィールド の管理',
        'Add new field for object' => 'オブジェクトに新規領域を追加',
        'Filter for Dynamic Fields' => 'ダイナミック・フィールドでフィルター',
        'Filter for dynamic fields' => 'ダイナミック・フィールドでフィルター',
        'More Business Fields' => 'その他のビジネス分野',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '',
        'Database' => 'データベース',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '外部データベースをこの ダイナミック・フィールド の構成データソースとして使用します。',
        'Web service' => 'ウェブサービス',
        'External web services can be configured as data sources for this dynamic field.' =>
            '外部Webサービスをこの ダイナミック・フィールド のデータソースとして設定できます。',
        'Contact with data' => 'データと接続',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '新しいフィールドを追加するには、オブジェクトのリストの1つからフィールドタイプを選択します。オブジェクトはフィールドの境界を定義し、フィールドの作成後は変更できません。',
        'Dynamic Fields List' => 'ダイナミック・フィールド 一覧',
        'Dynamic fields per page' => 'ページ毎の ダイナミック・フィールド',
        'Label' => 'ラベル',
        'Order' => '順序',
        'Object' => '対象',
        'Delete this field' => 'この領域を削除',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'ダイナミック・フィールド',
        'Go back to overview' => '一覧に戻る',
        'General' => 'ジェネラル',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'この領域は必須であり、値はアルファベットと数値のみでなければなりません。',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '一意でなければならず、アルファベットと数値のみ受け付けます。',
        'Changing this value will require manual changes in the system.' =>
            'この値の変更はシステム内で手動で行う必要があります。',
        'This is the name to be shown on the screens where the field is active.' =>
            'これは領域がアクティブである画面で表示される名前です。',
        'Field order' => '領域の順序',
        'This field is required and must be numeric.' => 'この領域は必須かつ数値でなければなりません。',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'これはこの領域がアクティブである画面で表示される順序です。',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => '領域タイプ',
        'Object type' => 'オブジェクトタイプ',
        'Internal field' => '内部領域',
        'This field is protected and can\'t be deleted.' => 'この領域は保護されており、削除できません。',
        'This dynamic field is used in the following config settings:' =>
            'このダイナミック・フィールドは、次の設定で使用されます。',
        'Field Settings' => '領域設定',
        'Default value' => 'デフォルト値',
        'This is the default value for this field.' => 'これはこの領域に対するデフォルト値です。',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'デフォルトの日時差',
        'This field must be numeric.' => 'この領域は数値でなければなりません。',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '領域のデフォルト値を計算するための現時点との時間差  (秒単位)。  （例: 3600, -60）',
        'Define years period' => '年の期間を定義',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '過去の年数',
        'Years in the past to display (default: 5 years).' => '表示する過去の年数(デフォルト:5年)。',
        'Years in the future' => '未来の年数',
        'Years in the future to display (default: 5 years).' => '表示する未来の年数(デフォルト:5年)。',
        'Show link' => 'リンクを表示',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => '例',
        'Link for preview' => 'プレビュー用のリンク',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'Restrict entering of dates' => '日付入力の制限',
        'Here you can restrict the entering of dates of tickets.' => '本項目でチケットの日付入力の制限できます',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '選択肢',
        'Key' => '鍵',
        'Value' => '値',
        'Remove value' => '値を削除',
        'Add value' => '値を追加',
        'Add Value' => '値を追加',
        'Add empty value' => '空の値の追加',
        'Activate this option to create an empty selectable value.' => '本項目を有効にすれば空の選択可能項目が作成できます。',
        'Tree View' => 'ツリー表示',
        'Activate this option to display values as a tree.' => '本項目を有効にすれば、値をツリー形式で表示できます。',
        'Translatable values' => '翻訳可能な値',
        'If you activate this option the values will be translated to the user defined language.' =>
            'このオプションを有効にすると、値がユーザーの定義した言語に翻訳されます。',
        'Note' => 'メモ',
        'You need to add the translations manually into the language translation files.' =>
            '翻訳を手動で言語翻訳ファイルに追加する必要があります。',

        # Template: AdminDynamicFieldText
        'Number of rows' => '行数',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '編集画面におけるこの領域の高さ(列数)を指定します。',
        'Number of cols' => '列数',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '編集画面におけるこの領域の幅(文字数)を指定します。',
        'Check RegEx' => '正規表現をチェック',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '本項目で入力値に対する正規表現を設定可能です。　正規表現は モディファイXMSとともに実行されます。',
        'RegEx' => '正規表現',
        'Invalid RegEx' => '無効な正規表現',
        'Error Message' => 'エラーメッセージ',
        'Add RegEx' => '正規表現を追加',

        # Template: AdminEmail
        'Admin Message' => '管理者メッセージ',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '本モジュールにて、管理者からエージェント、グループ、ロールメンバーへメッセージを送信することが可能です。',
        'Create Administrative Message' => '管理者メッセージを作成',
        'Your message was sent to' => '送信されたメッセージ',
        'From' => '差出人',
        'Send message to users' => 'ユーザーにメッセージを送信',
        'Send message to group members' => 'グループのメンバーにメッセージを送信',
        'Group members need to have permission' => 'グループのメンバーは権限を持っている必要があります',
        'Send message to role members' => 'ロールのメンバーにメッセージを送信',
        'Also send to customers in groups' => 'さらにグループの顧客にも送信',
        'Body' => '本文',
        'Send' => '送信',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => '最終実行',
        'Run Now!' => '今すぐ実行！',
        'Delete this task' => 'このタスクを削除',
        'Run this task' => 'このタスクを実行',
        'Job Settings' => 'ジョブ設定',
        'Job name' => 'ジョブ名',
        'The name you entered already exists.' => '入力された名前は既に存在します。',
        'Automatic Execution (Multiple Tickets)' => '自動実行(複数チケット)',
        'Execution Schedule' => '実行スケジュール',
        'Schedule minutes' => 'スケジュール 分',
        'Schedule hours' => 'スケジュール 時',
        'Schedule days' => 'スケジュール 日',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            '現在この一般担当者のジョブは自動実行されません。',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '自動実行を有効にするには、分、時間、日から少なくとも1つの値を選択して下さい。',
        'Event Based Execution (Single Ticket)' => 'イベント実行(単一チケット)',
        'Event Triggers' => 'イベントトリガー',
        'List of all configured events' => '設定された全てのイベントの一覧',
        'Delete this event' => 'このイベントを削除',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'このイベントトリガーを本当に削除しますか？',
        'Add Event Trigger' => 'イベントトリガーを追加',
        'To add a new event select the event object and event name' => '新しいイベントを追加するには、イベントオブジェクトとイベント名を選択します。',
        'Select Tickets' => 'チケットを選択',
        '(e. g. 10*5155 or 105658*)' => '(例 10*5144 または 105658*)',
        '(e. g. 234321)' => '(例 234321)',
        'Customer user ID' => '顧客ユーザーID',
        '(e. g. U5150)' => '(例 U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '記事内全文検索 (例 "Mar*in" または "Baue*")',
        'To' => '宛先',
        'Cc' => 'Cc',
        'Service' => 'サービス',
        'Service Level Agreement' => 'サービスレベル契約（SLA）',
        'Queue' => 'キュー',
        'State' => 'ステータス',
        'Agent' => '担当者',
        'Owner' => '所有者',
        'Responsible' => '責任者',
        'Ticket lock' => 'チケットロック',
        'Dynamic fields' => 'ダイナミック・フィールド',
        'Add dynamic field' => '',
        'Create times' => '作成日時',
        'No create time settings.' => '作成日時を指定しない',
        'Ticket created' => 'チケットを作成したのが',
        'Ticket created between' => 'チケットを作成したのがこの期間内',
        'and' => '-',
        'Last changed times' => '最終変更時間',
        'No last changed time settings.' => '最終変更時間を指定しない',
        'Ticket last changed' => 'チケットが最終更新された',
        'Ticket last changed between' => 'チケットの最終更新がこの期間内',
        'Change times' => '変更時間',
        'No change time settings.' => '変更時間設定を指定しない',
        'Ticket changed' => 'チケットを変更しました',
        'Ticket changed between' => 'チケットの変更がこの期間の間',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'クローズ時間',
        'No close time settings.' => 'クローズ時間を指定しない',
        'Ticket closed' => 'チケットをクローズしたのが',
        'Ticket closed between' => 'チケットをクローズしたのがこの期間内',
        'Pending times' => '保留時間',
        'No pending time settings.' => '保留時間を指定しない',
        'Ticket pending time reached' => '保留期限切れが',
        'Ticket pending time reached between' => '保留期限切れがこの期間内',
        'Escalation times' => 'エスカレーション時間',
        'No escalation time settings.' => 'エスカレーション時間を指定しない',
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
        'Archive search option' => 'アーカイブ検索オプション',
        'Update/Add Ticket Attributes' => 'チケット属性の更新/追加',
        'Set new service' => '新しいサービスを設定',
        'Set new Service Level Agreement' => '新しいサービスレベル契約（SLA）を設定',
        'Set new priority' => '新しい優先度を設定',
        'Set new queue' => '新しいキューを設定',
        'Set new state' => '新しいステータスを設定',
        'Pending date' => '保留日時',
        'Set new agent' => '新しい担当者を設定',
        'new owner' => '新しい所有者',
        'new responsible' => '新しい責任者',
        'Set new ticket lock' => '新しいチケットロックを設定',
        'New customer user ID' => '新しい顧客ユーザーID',
        'New customer ID' => '新しい顧客ID',
        'New title' => '新しいタイトル',
        'New type' => '新しいタイプ',
        'Archive selected tickets' => '選択されたアーカイブ・チケット',
        'Add Note' => 'メモを追加',
        'Visible for customer' => '顧客が閲覧可能な記事',
        'Time units' => '時間の単位',
        'Execute Ticket Commands' => 'チケットコマンドを実行',
        'Send agent/customer notifications on changes' => '変更を担当者／顧客に通知する',
        'CMD' => 'コマンド',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'このコマンドが実行されます。チケット番号は ARG[0] 、チケットIDは ARG[1] です。',
        'Delete tickets' => 'チケット削除',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '警告: 影響を受ける全てのチケットがデータベースから削除されます。復元することはできません。',
        'Execute Custom Module' => 'カスタムモジュールを実行',
        'Param %s key' => 'パラメータキー %s',
        'Param %s value' => 'パラメータ値 %s',
        'Results' => '検索結果',
        '%s Tickets affected! What do you want to do?' => '%s チケットは影響を受けます。どうしますか？',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '警告: 削除オプションを使用します。削除された全てのチケットは消失します。',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '注意: 影響を受けるチケットは %s 件ありますが、変更を行うことのできるのは1ジョブあたり %s 件のみとなります！',
        'Affected Tickets' => '影響を受けるチケット',
        'Age' => '経過時間',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'ジェネリックインターフェース・Webサービス管理',
        'Web Service Management' => 'ウェブサービスの管理',
        'Debugger' => 'デバッガー',
        'Go back to web service' => 'Webサービスに戻る',
        'Clear' => 'クリア',
        'Do you really want to clear the debug log of this web service?' =>
            'このWEBサービスのデバッグログを本当にクリアしますか。',
        'Request List' => 'リクエストリスト',
        'Time' => '時間',
        'Communication ID' => 'コミュニケーションID',
        'Remote IP' => 'リモートIP',
        'Loading' => '読み込み中...',
        'Select a single request to see its details.' => '詳細情報を表示するためには一つのリクエストを選択してください。',
        'Filter by type' => 'タイプでフィルタ',
        'Filter from' => '送信元でフィルタ',
        'Filter to' => '送信先でフィルタ',
        'Filter by remote IP' => 'リモートIPでフィルタ',
        'Limit' => '制限',
        'Refresh' => '自動更新',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'エラー処理の追加',
        'Edit ErrorHandling' => 'エラー処理の修正',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'すべての設定情報は失われます',
        'General options' => '一般的なオプション',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Webサービスの名称として一意の名前を指定してください。',
        'Error handling module backend' => 'エラー処理モジュールのバックエンド',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => '処理中オプション',
        'Configure filters to control error handling module execution.' =>
            '',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '',
        'Operation filter' => '操作フィルター',
        'Only execute error handling module for selected operations.' => '選択したオペレーションに対してのみ、エラー処理モジュールを実行します。',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '',
        'Invoker filter' => 'API実行元をフィルター',
        'Only execute error handling module for selected invokers.' => '選択したAPI実行元に対してのみ、エラー処理モジュールを実行します。',
        'Error message content filter' => 'エラーメッセージコンテンツフィルター',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => 'エラーステージフィルター',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '',
        'Error code' => 'エラーコード',
        'An error identifier for this error handling module.' => 'このエラー処理モジュールのエラー識別子',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => 'エラーメッセージ',
        'An error explanation for this error handling module.' => 'このエラー処理モジュールのエラーの説明',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'このメッセージは、XSLT-Mapping画面およびデバッガ出力でのみ利用可能です。',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '',
        'Default behavior is to resume, processing the next module.' => '',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'このモジュールでは、失敗した要求をスケジュールされた時刻に再試行し、構成できます。',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '',
        'Request retry options' => 'リクエストを再試行するオプション',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '',
        'Schedule retry' => 'スケジュール・リトライ',
        'Should requests causing an error be triggered again at a later time?' =>
            'エラーの原因となったリクエストを、後で再送信する必要がありますか？',
        'Initial retry interval' => '初期のリトライ間隔',
        'Interval after which to trigger the first retry.' => '最初のリトライするトリガーの間隔',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '注：これ以降のすべての再試行間隔は、最初のリクエストに対するエラー処理モジュールの実行時間に基づいています。',
        'Factor for further retries' => 'さらなる再試行の要因',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '例: トリガーを 10:00 、インターバルを1分間隔にあらかじめ設定している場合に、リトライファクターを”２”とすると、次の要領でトリガーが機能します。
10:01(1分後)→10:03(１x２=2分後)→10:07(２x２=4分後)→10:15(４x２=8分後)…※以降、間隔は2倍になります',
        'Maximum retry interval' => '最大リトライ間隔',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'リトライファクターとして"1.5"ないし"2"が選択されている場合、最大リトライ間隔を別途定義することで、意図せず望ましくない間隔が設定されることを防止できます。',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'リトライ間隔を算出した結果が最大リトライ間隔を超過した場合は、自動的に短縮されます。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '例: トリガーを 10:00 、インターバルを1分間隔にあらかじめ設定している場合に、リトライファクターを”２”、最大リトライ間隔を”5分”とすると、次の要領でトリガーが機能します。
10:01(1分後)→10:03(2分後)→10:07(4分後)→10:12(8分後⇒5分後に修正)→10:17…',
        'Maximum retry count' => '最大リトライ間隔',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '最大リトライ回数は、処理要求が失敗してもリトライを行う最大の回数です。但し、初回分はカウントしません。',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '例: トリガーを 10:00 、インターバルを1分間隔にあらかじめ設定している場合に、リトライファクターを”２”、最大リトライ回数を”２”とすると、10:01および10:02にリトライ機能が呼び出されます。',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '',
        'This field must be empty or contain a positive number.' => '',
        'Maximum retry period' => '再試行の最大期間',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'API実行元を追加',
        'Edit Invoker' => 'API実行元を修正',
        'Do you really want to delete this invoker?' => 'このAPI実行元を本当に削除しますか。',
        'Invoker Details' => 'API実行元の詳細',
        'The name is typically used to call up an operation of a remote web service.' =>
            'この名称は、一般的にリモートWebサービスの呼び出しに用いられます。',
        'Invoker backend' => 'API実行元のバックエンド',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'このOTRSのAPI実行元のバックエンドモジュールは、リモートシステムに送信されるデータを準備し、その応答データを処理するために呼び出されます。',
        'Mapping for outgoing request data' => '送信要求データのマッピング',
        'Configure' => '設定',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'OTRSのAPI実行元からのデータは、このマッピングによって処理され、リモートシステムが予期している種類のデータに変換されます。',
        'Mapping for incoming response data' => '着信応答データのマッピング',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'レスポンスデータをこのマッピングにのっとって OTRS のAPI実行元が期待するデータの種類に変換します。',
        'Asynchronous' => '非同期',
        'Condition' => '条件',
        'Edit this event' => 'このイベントを修正',
        'This invoker will be triggered by the configured events.' => 'このAPI実行元は予め設定されたトリガーによって実行されます。',
        'Add Event' => 'イベントを追加',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '新しいイベントを追加するには、イベントオブジェクトをイベント名を選択してから"+"ボタンをクリックしてください',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '非同期型イベントトリガーは、OTRSスケジューラー・デーモンによってバックグラウンドで実行されます（推奨）。',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '同期型イベントトリガーは直接Web画面上のリクエストから実行されます。',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'に戻る',
        'Delete all conditions' => '全ての条件を削除',
        'Do you really want to delete all the conditions for this event?' =>
            '本当にこのイベントのすべての条件を削除してよろしいですか？',
        'General Settings' => '一般的な設定',
        'Event type' => 'イベントタイプ',
        'Conditions' => '条件',
        'Conditions can only operate on non-empty fields.' => '条件は空白でないフィールドに対してのみ使用可能です。',
        'Type of Linking between Conditions' => '条件間のリンクのタイプ',
        'Remove this Condition' => 'この条件を削除',
        'Type of Linking' => 'リンクのタイプ',
        'Fields' => '領域',
        'Add a new Field' => '新しい領域を追加',
        'Remove this Field' => 'この領域を削除',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => '新しい条件を追加',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'マッピング シンプル',
        'Default rule for unmapped keys' => 'アンマップドキーのデフォルトルール',
        'This rule will apply for all keys with no mapping rule.' => '本ルールはマッピングルールが指定されていないすべてのキーに適用されます。',
        'Default rule for unmapped values' => 'アンマップドバリューのデフォルトルール',
        'This rule will apply for all values with no mapping rule.' => '本ルールはマッピングルールが指定されていないすべてのバリューに適用されます。',
        'New key map' => '新しいキー割り当て',
        'Add key mapping' => 'キー割り当ての追加',
        'Mapping for Key ' => 'キーの割り当て',
        'Remove key mapping' => 'キー割り当ての削除',
        'Key mapping' => 'キー割り当て',
        'Map key' => 'キーの割り当て',
        'matching the' => '一致',
        'to new key' => 'へ新しいキーを割り当てる',
        'Value mapping' => '値のマッピング',
        'Map value' => '値の割り当て',
        'to new value' => 'へ新しい値を割り当てる',
        'Remove value mapping' => '割り当てた値の削除',
        'New value map' => '新しい値の割り当て',
        'Add value mapping' => '値の割り当てを追加',
        'Do you really want to delete this key mapping?' => 'このキー割り当てを削除しますか？',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '一般的なショートカット',
        'MacOS Shortcuts' => 'MacOSのショートカット',
        'Comment code' => 'コメント・コード',
        'Uncomment code' => 'コードのコメントを解除する',
        'Auto format code' => '自動フォーマットコード',
        'Expand/Collapse code block' => 'コードブロックを展開/折りたたみ',
        'Find' => '探す',
        'Find next' => '次を探す',
        'Find previous' => '前の検索',
        'Find and replace' => '検索と置換',
        'Find and replace all' => '全ての検索して置き換える',
        'XSLT Mapping' => 'XSLTマッピング',
        'XSLT stylesheet' => 'XSLTスタイルシート',
        'The entered data is not a valid XSLT style sheet.' => '入力されたXSLTスタイルシートの形式が不正です。',
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
        'Regular expressions' => '正規表現',
        'Replace' => '置換',
        'Remove regex' => '正規表現の削除',
        'Add regex' => '正規表現の追加',
        'These filters can be used to transform keys using regular expressions.' =>
            'これらのフィルタは、正規表現を使用してキーを変換するために使用できます。',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '例1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '例2:  Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '例3: Search = \'^(?1\d+) (?2.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'Perlでの正規表現についての情報は、こちらをご覧ください：',
        'Perl regular expressions tutorial' => 'Perl正規表現のチュートリアル',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'オペレーションを追加',
        'Edit Operation' => 'オペレーションを修正',
        'Do you really want to delete this operation?' => 'このオペレーションを本当に削除しますか？',
        'Operation Details' => 'オペレーションの詳細',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'この名称は、一般的にリモートシステムからのWebサービスの呼び出しに用いられます。',
        'Operation backend' => 'オペレーション・バックエンド',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for incoming request data' => '受信したデータのマッピング',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Mapping for outgoing response data' => '送信データのマッピング',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Include Ticket Data' => 'チケットデータを含む',
        'Include ticket data in response.' => '応答のテキスト内に、チケットのデータを含める',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'ネットワーク・トランスポート',
        'Properties' => '項目',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'メッセージの最長値',
        'This field should be an integer number.' => 'この領域は整数値である必要があります。',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => 'Keep-Aliveを送信',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Additional response headers' => '応答ヘッダーを追加',
        'Add response header' => '応答ヘッダーを追加する',
        'Endpoint' => 'エンドポイント',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '例… https://www.otrs.com:10745/api/v1.0 (バックスラッシュを除く)',
        'Timeout' => 'タイムアウト',
        'Timeout value for requests.' => '',
        'Authentication' => '認証',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => 'ベーシック認証のユーザー',
        'The user name to be used to access the remote system.' => 'リモート・システムにアクセスするときに用いるユーザー名',
        'BasicAuth Password' => 'ベーシック認証のパスワード',
        'The password for the privileged user.' => '特権ユーザー用パスワード',
        'Use Proxy Options' => 'プロキシオプションを使用する',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'プロキシサーバ',
        'URI of a proxy server to be used (if needed).' => 'プロキシサーバのURI (任意)',
        'e.g. http://proxy_hostname:8080' => '例… http://proxy_hostname:8080',
        'Proxy User' => 'Proxy ユーザー',
        'The user name to be used to access the proxy server.' => 'プロキシサーバへ接続する際のユーザー名',
        'Proxy Password' => 'Proxy パスワード',
        'The password for the proxy user.' => 'プロキシユーザーのパスワード',
        'Skip Proxy' => 'プロキシーをスキップ',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'SSLオプションを利用する',
        'Show or hide SSL options to connect to the remote system.' => 'リモートシステムに接続するためのSSLオプションの表示/非表示を切替えます。',
        'Client Certificate' => 'クライアント証明書',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'SSLクライアント証明書ファイルの完全パスと名前（PEM、DERまたはPKCS＃12形式である必要があります）。',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => '例 /opt/otrs/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'クライアント認証キー',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'SSLクライアント証明書キーファイルの完全パスと名前（まだ証明書ファイルに含まれていない場合）。',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => '例 /opt/otrs/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'クライアント認証キーのパスワード',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '例… /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '例… /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => 'API実行元に対するコントローラ・マッピング',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '呼び出し元に対する有効な要求コマンド',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'この呼び出し元のリクエストに使用する、特定のHTTPコマンド(オプション)',
        'Default command' => 'デフォルトコマンド',
        'The default HTTP command to use for the requests.' => '要求に使用される標準のHTTPコマンド',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '例. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'SOAPアクションを設定',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '「いいえ」に設定すると、空のSOAPActionヘッダーが送信されます。',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => 'SOAPアクション・スキーム',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'SOAPアクション・セパレータ',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => 'SOAPアクション・フリーテキスト',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => '名前空間',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '例… urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '実際の呼び出し元/操作名の例として \'FunctionName\'が使用されています。',
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
        'Encoding' => 'エンコーディング',
        'The character encoding for the SOAP message contents.' => 'SOAPメッセージコンテントの文字エンコード',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '例… utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'Sort options' => '並べ替えオプション',
        'Add new first level element' => '',
        'Element' => '要素',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Webサービスを追加',
        'Edit Web Service' => 'Webサービスを修正',
        'Clone Web Service' => 'Webサービスをクローン',
        'The name must be unique.' => '名前は一意である必要があります。',
        'Clone' => '複製',
        'Export Web Service' => 'Webサービスをエクスポート',
        'Import web service' => 'ウェブサービスのインポート',
        'Configuration File' => '設定ファイル',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'インポート',
        'Configuration History' => '設定履歴',
        'Delete web service' => 'ウェブサービスの削除',
        'Do you really want to delete this web service?' => '本当にこのWebサービスを削除しますか？',
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
        'Remote system' => 'リモートシステム',
        'Provider transport' => '供給者のトランスポート',
        'Requester transport' => '依頼者のトランスポート',
        'Debug threshold' => 'デバックの閾値',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'Provider(供給者)モードでは、OTRSは他の外部システムにウェブサービスを提供します。',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'Requester(要求者)モードでは、OTRSは他の外部システのウェブサービスを使用します。',
        'Network transport' => 'ネットワーク・トランスポート',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => 'バックエンド',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => 'コントローラー',
        'Inbound mapping' => 'インバウンド・マッピング',
        'Outbound mapping' => 'アウトバウンド・マッピング',
        'Delete this action' => 'このアクションを削除',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => '履歴',
        'Go back to Web Service' => 'Webサービスに戻る',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '設定履歴一覧',
        'Version' => 'バージョン',
        'Create time' => '作成日時',
        'Select a single configuration version to see its details.' => '詳細を表示するには、1つのバージョンのみを選択します。',
        'Export web service configuration' => 'サービス設定のエクスポート',
        'Restore web service configuration' => 'サービス設定の復元',
        'Do you really want to restore this version of the web service configuration?' =>
            'このバージョンのウェブ・サービス設定を復旧します。よろしいですか？',
        'Your current web service configuration will be overwritten.' => '現在のWebサービス設定は上書きされます。',

        # Template: AdminGroup
        'Group Management' => 'グループ管理',
        'Add Group' => 'グループ追加',
        'Edit Group' => 'グループ編集',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '管理グループは管理エリアで取得します。統計グループは統計エリアを取得します',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '統計グループは統計エリアを取得します。異なるエージェントグループへのアクセス許可を操作するには、グループを新規作成してください。（例：購買部、サポート部、営業部等）',
        'It\'s useful for ASP solutions. ' => 'ASPソリューションが便利です',

        # Template: AdminLog
        'System Log' => 'システムログ',
        'Here you will find log information about your system.' => 'ここではシステムに関するログ情報が表示されます。',
        'Hide this message' => 'このメッセージを隠す',
        'Recent Log Entries' => '最近のログ一覧',
        'Facility' => 'ファシリティ',
        'Message' => 'メッセージ',

        # Template: AdminMailAccount
        'Mail Account Management' => 'メールアカウント管理',
        'Add Mail Account' => 'メールアカウント追加',
        'Edit Mail Account for host' => 'ホストのメールアカウントを編集',
        'and user account' => 'ユーザーアカウントと',
        'Filter for Mail Accounts' => 'メールアカウントでフィルター',
        'Filter for mail accounts' => 'メールアカウントでフィルター',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '1つのアカウントを持つ全ての受信Eメールは、選択されたキューにディスパッチされます。',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => 'システム設定',
        'Host' => 'ホスト',
        'Delete account' => 'アカウント削除',
        'Fetch mail' => 'メールを取得',
        'Do you really want to delete this mail account?' => '本当にこのメールアカウントを削除しますか？',
        'Password' => 'パスワード',
        'Example: mail.example.com' => '例: mail.example.com',
        'IMAP Folder' => 'IMAPフォルダー',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'INBOX以外のフォルダからメールを取得したい場合にのみ修正して下さい。',
        'Trusted' => '信頼済',
        'Dispatching' => '振り分け処理',
        'Edit Mail Account' => 'メールアカウント編集',

        # Template: AdminNavigationBar
        'Administration Overview' => '管理一覧',
        'Filter for Items' => 'アイテムをフィルター',
        'Filter' => 'フィルター',
        'Favorites' => 'お気に入り',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '右側のアイテムにカーソルを合わせてスターアイコンをクリックすると、お気に入りを追加できます。',
        'Links' => 'リンク',
        'View the admin manual on Github' => 'Githubの管理マニュアルを表示',
        'No Matches' => 'マッチなし',
        'Sorry, your search didn\'t match any items.' => '申し訳ありませんが、あなたの検索はどのアイテムにも一致しませんでした。',
        'Set as favorite' => 'お気に入りに指定',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'チケット通知管理',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'チケットフィルター',
        'Lock' => 'ロック',
        'SLA' => 'SLA',
        'Customer User ID' => '顧客ユーザーID',
        'Article Filter' => '記事フィルター',
        'Only for ArticleCreate and ArticleSend event' => 'ArticleCreateおよびArticleSendイベントに対してのみ',
        'Article sender type' => '記事送信者タイプ',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Customer visibility' => '顧客の参照',
        'Communication channel' => 'コミュニケーション・チャネル',
        'Include attachments to notification' => '通知が添付ファイルを含む',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '選択された通知方法を使って1つのチケットにつき1度だけユーザーに通知する。',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => '通知は担当者、顧客に送信されます。',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '表題の最初の20文字を取得 (最新の担当者記事)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '本文から最初の5行を取得 (最新の担当者記事)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '表題の最初の20文字を取得 (最新の顧客記事)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '本文から最初の5行を取得 (最新の顧客記事)',
        'Attributes of the current customer user data' => '現在の顧客ユーザの属性',
        'Attributes of the current ticket owner user data' => '現在のチケット所有者の属性',
        'Attributes of the current ticket responsible user data' => '現在の責任者の属性',
        'Attributes of the current agent user who requested this action' =>
            '現在操作を要求している担当者の属性',
        'Attributes of the ticket data' => 'チケットデータの属性',
        'Ticket dynamic fields internal key values' => 'チケットのダイナミック・フィールドの内部用キー値',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'チケットのダイナミック・フィールドの表示値。ドロップダウンまたは複数選択領域で利用可能',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '<OTRS_TICKET_DynamicField_...> を指定することで、現在のチケットの値を参照することができます。',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '%s を管理',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'ドキュメントを参照',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => '',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '',
        '%s not Correctly Installed' => '%s は正常にインストールされました',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '%s は正常にインストールされていません。下のボタンを押して再インストールしてください。',
        'Reinstall %s' => '%s の再インストール',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '%s は正常にインストールされていません。また、こちらのパッケージにはアップデートがあります。',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => '%s のアップデート',
        '%s Not Yet Available' => '%sはまだ存在しません',
        '%s will be available soon.' => '%sはもうすぐ有効となります。',
        '%s Update Available' => '%s 利用できるアップデーターがあります',
        'An update for your %s is available! Please update at your earliest!' =>
            '',
        '%s Correctly Deployed' => '%s 正しくデプロイされました',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'おめでとうございます。 %s は最新版として正常にインストールされました。',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => 'OTRSのカスタマーポータルへアクセス',
        '%s will be available soon. Please check again in a few days.' =>
            '%sはもうすぐ有効になります。数日後に確認してください。',
        'Please have a look at %s for more information.' => '詳細については%sを参照してください。',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'cloud.otrs.comへのHTTPSでの接続の確立ができませんでした。
OTRSが443ポートを用いてcloud.otrs.comに接続できることを確認して下さい。',
        'Package installation requires patch level update of OTRS.' => 'パッケージのインストールには、OTRSのパッチレベルの更新が必要です。',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => 'インストールされているOTRSのバージョンは%sです。',
        'To install this package, you need to update to OTRS %s or higher.' =>
            'このパッケージをインストールするにはOTRS %s以上にアップデートする必要があります。',
        'To install this package, the Maximum OTRS Version is %s.' => 'このパッケージがインストールできるOTRSの最大バージョンは%sです。',
        'To install this package, the required Framework version is %s.' =>
            'このパッケージをインストールするにはフレームワークのバージョンが%sである必要があります。',
        'Why should I keep OTRS up to date?' => 'OTRSのバージョンを最新に保つことが必要な理由',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'With your existing contract you can only use a small part of the %s.' =>
            '現在登録されている契約では、%sの機能の一部しか使用できません。',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'もし%sの全機能を使用したい場合には、契約をアップグレードする必要があります！現在の契約: %s',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'ダウングレードを中止して戻る',
        'Go to OTRS Package Manager' => 'OTRSパッケージマネージャーへ',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'パッケージ%sに依存しているため、現在ダウングレードすることは出来ません',
        'Vendor' => 'ベンダー',
        'Please uninstall the packages first using the package manager and try again.' =>
            'パッケージマネージャでパッケージを削除して再度実行して下さい。',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'チャット',
        'Report Generator' => 'レポート・ジェネレーター',
        'Timeline view in ticket zoom' => 'チケット・ズームにおけるタイムライン',
        'DynamicField ContactWithData' => 'ダイナミック・フィールド日付でコンタクトする',
        'DynamicField Database' => 'ダイナミック・フィールド用データベース',
        'SLA Selection Dialog' => 'SLA選択画面',
        'Ticket Attachment View' => 'チケット添付ファイルビュー',
        'The %s skin' => '%s スキン',

        # Template: AdminPGP
        'PGP Management' => 'PGP管理',
        'Add PGP Key' => 'PGP鍵を追加',
        'PGP support is disabled' => 'PGPサポート機能は無効化されています',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'OTRSでPGPを使用するにはまず有効にする必要があります。',
        'Enable PGP support' => 'PGPサポートの有効化',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGPサポート機能は有効化されましたが、関連する設定にエラーがあります。以下の設定を確認して下さい。',
        'Configure it here!' => 'ここで設定してください！',
        'Check PGP configuration' => 'PGP設定の確認',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'この方法で直接システム設定からキーリング設定を編集できます。',
        'Introduction to PGP' => 'PGPの導入',
        'Identifier' => '識別子',
        'Bit' => 'ビット',
        'Fingerprint' => 'フィンガープリント',
        'Expires' => '期限切れ',
        'Delete this key' => 'この鍵を削除',
        'PGP key' => 'PGPキー',

        # Template: AdminPackageManager
        'Package Manager' => 'パッケージ管理',
        'Uninstall Package' => 'パッケージをアンインストール',
        'Uninstall package' => 'パッケージをアンインストール',
        'Do you really want to uninstall this package?' => 'このパッケージを本当にアンインストールしますか？',
        'Reinstall package' => 'パッケージを再インストール',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'このパッケージを本当に再インストールしますか？ 全ての手動変更点は失われます。',
        'Go to updating instructions' => '',
        'package information' => 'パッケージ情報',
        'Package installation requires a patch level update of OTRS.' => '',
        'Package update requires a patch level update of OTRS.' => '',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            'OTRS Business Solution™のお客様は、カスタマーポータルにアクセスしてリクエストを提出してください。',
        'Please note that your installed OTRS version is %s.' => 'インストールされているOTRSのバージョンは%sです。',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            'このパッケージをインストールするには、OTRSのバージョンを%s以上にアップデートする必要があります。',
        'This package can only be installed on OTRS version %s or older.' =>
            'このパッケージはOTRSのバージョンが%sかそれより古い必要があります。',
        'This package can only be installed on OTRS version %s or newer.' =>
            'このパッケージをインストールするにはOTRSのバージョンが%sかそれより新しい必要があります。',
        'You will receive updates for all other relevant OTRS issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            '',
        'Install Package' => 'パッケージをインストール',
        'Update Package' => 'パッケージを更新',
        'Continue' => '続ける',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'インストール',
        'Update repository information' => 'リポジトリ情報を更新',
        'Cloud services are currently disabled.' => 'クラウドサービスは現在無効化されています',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™️が継続できません！',
        'Enable cloud services' => 'クラウドサービスの有効化',
        'Update all installed packages' => 'インストールされているパッケージを全て更新する',
        'Online Repository' => 'オンラインリポジトリ',
        'Action' => '操作',
        'Module documentation' => 'モジュールの書類',
        'Local Repository' => 'ローカルリポジトリ',
        'This package is verified by OTRSverify (tm)' => 'このパッケージはOTRSVerify(tm)によって確認されています',
        'Uninstall' => 'アンインストール',
        'Package not correctly deployed! Please reinstall the package.' =>
            'パッケージが正しくデプロイされません。再インストールしてください。',
        'Reinstall' => '再インストール',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Package Information' => 'パッケージ情報',
        'Download package' => 'パッケージをダウンロード',
        'Rebuild package' => 'パッケージを再構成',
        'Metadata' => 'メタデータ',
        'Change Log' => '変更履歴',
        'Date' => '日付',
        'List of Files' => 'ファイル一覧',
        'Permission' => '権限',
        'Download file from package!' => 'パッケージからファイルをダウンロードしてください。',
        'Required' => '必要項目',
        'Size' => 'サイズ',
        'Primary Key' => '主キー',
        'Auto Increment' => '自動カウントアップ',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'ファイル%sの差分',
        'File differences for file %s' => '%s ファイルが違います',

        # Template: AdminPerformanceLog
        'Performance Log' => 'パフォーマンスログ',
        'Range' => '範囲',
        'last' => '以内',
        'This feature is enabled!' => 'この機能を有効にする。',
        'Just use this feature if you want to log each request.' => 'この機能は各要求をログに記録したい場合のみ利用してください。',
        'Activating this feature might affect your system performance!' =>
            'この機能を有効にするとシステムのパフォーマンスに影響が出る可能性があります。',
        'Disable it here!' => '無効にする。',
        'Logfile too large!' => 'ログファイルが大きすぎます',
        'The logfile is too large, you need to reset it' => 'ログファイルが大きすぎます。初期化してください。',
        'Reset' => 'リセット',
        'Overview' => '一覧',
        'Interface' => 'インターフェイス',
        'Requests' => '要求',
        'Min Response' => '最少応答',
        'Max Response' => '最大応答',
        'Average Response' => '平均応答',
        'Period' => '期間',
        'minutes' => '分',
        'Min' => '最少',
        'Max' => '最大',
        'Average' => '平均',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'ポストマスター・フィルター管理',
        'Add PostMaster Filter' => 'ポストマスター・フィルターを追加',
        'Edit PostMaster Filter' => 'ポストマスター・フィルターを削除',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '振り分けやメールヘッダを元に受信メールをフィルタします。正規表現を使用できます。',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'メールアドレスのみを一致させたい場合、EMAILADDRESS:info@example.comを差出人、宛先、Ccに使用してください。',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '正規表現を使う場合、設定で一致する値を[***]として使用できます。',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'このフィルタを削除',
        'Do you really want to delete this postmaster filter?' => '本当にこのポストマスター・フィルターを削除しますか？',
        'A postmaster filter with this name already exists!' => 'この名前のポストマスター・フィルターは既に存在します！',
        'Filter Condition' => 'フィルター条件',
        'AND Condition' => 'AND条件',
        'Search header field' => 'ヘッダーフィールドの検索',
        'for value' => '価値観',
        'The field needs to be a valid regular expression or a literal word.' =>
            'このフィールドは有効な正規表現またはリテラル値で入力する必要があります。',
        'Negate' => '否定条件',
        'Set Email Headers' => 'メールヘッダを設定',
        'Set email header' => 'メールヘッダを設定',
        'with value' => '価値のある',
        'The field needs to be a literal word.' => 'このフィールドはリテラル値で入力する必要があります。',
        'Header' => 'ヘッダー',

        # Template: AdminPriority
        'Priority Management' => '優先度管理',
        'Add Priority' => '優先度を追加',
        'Edit Priority' => '優先度を編集',
        'Filter for Priorities' => '優先度でフィルター',
        'Filter for priorities' => '優先度でフィルター',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'プロセス管理',
        'Filter for Processes' => 'プロセスでフィルター',
        'Filter for processes' => '',
        'Create New Process' => '新しいプロセスを追加',
        'Deploy All Processes' => 'すべてのプロセスをデプロイ',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'ここでプロセスの設定ファイルをアップロードすることができます。ファイルは.プロセス管理モジュールがエクスポートしたyamlフォーマットである必要があります。',
        'Upload process configuration' => 'プロセスの設定を更新',
        'Import process configuration' => 'プロセスの設定をインポート',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '新規プロセスを作成するには他システムでエクスポートしたプロセスをインポートするか新規に作成してください。',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '変更はプロセスデータを同期させた場合にのみ反映されます。同期により、行われた変更は実際の設定に反映されます。',
        'Processes' => 'プロセス',
        'Process name' => 'プロセス名',
        'Print' => '印刷',
        'Export Process Configuration' => 'プロセスの設定をエクスポート',
        'Copy Process' => 'プロセスをコピー',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '中止して閉じる',
        'Go Back' => '戻る',
        'Please note, that changing this activity will affect the following processes' =>
            '変更は以下のプロセスに影響を与えます',
        'Activity' => 'アクティビティ',
        'Activity Name' => 'アクティビティ名',
        'Activity Dialogs' => 'アクティビティダイアログ',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '左側のリストから右側のリストへドラッグすることでアクティビティ・ダイアログをアクティビティに関連付けすることが出来ます。',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'このリストの表示順序はドラッグアンドドロップで変更することが出来ます。',
        'Filter available Activity Dialogs' => '利用可能なアクティビティダイアログをフィルタ',
        'Available Activity Dialogs' => '利用可能なアクティビティダイアログ',
        'Name: %s, EntityID: %s' => '名前: %s, エンティティID: %s',
        'Create New Activity Dialog' => '新規アクティビティダイアログを作成',
        'Assigned Activity Dialogs' => '割り当てられたアクティビティダイアログ',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'このアクティビティ・ダイアログに対する変更は以下のアクティビティに影響を与えます',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '顧客は次のフィールドを参照することは出来ませんので注意して下さい: 所有者, 責任者, ロック, 保留時間, 顧客ID',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '顧客の場合、キューはチケットの新規作成時にのみ使用できます。',
        'Activity Dialog' => 'アクティビティダイアログ',
        'Activity dialog Name' => 'アクティビティダイアログ名',
        'Available in' => 'インターフェース',
        'Description (short)' => '説明（概略）',
        'Description (long)' => '説明（詳細）',
        'The selected permission does not exist.' => '選択された権限は存在しません。',
        'Required Lock' => 'ロックをする',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => 'サブミットボタンのアドバイステキスト',
        'Submit Button Text' => 'サブミットボタン名',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'マウスで左から右にドラッグ・アンド・ドロップすることで、アクティビティ・ダイアログにフィールドを関連付けることが出来ます',
        'Filter available fields' => '利用可能な領域をフィルタ',
        'Available Fields' => '利用可能な領域',
        'Assigned Fields' => '割り当てられた領域',
        'Communication Channel' => 'コミュニケーション・チャネル',
        'Is visible for customer' => '顧客が閲覧可能',
        'Display' => '表示',

        # Template: AdminProcessManagementPath
        'Path' => 'パス',
        'Edit this transition' => 'この遷移を編集',
        'Transition Actions' => '遷移動作',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'マウスで左から右にドラッグ・アンド・ドロップすることで、推移アクションをこの推移に関連付けることができます。',
        'Filter available Transition Actions' => '利用可能な遷移動作をフィルタ',
        'Available Transition Actions' => '利用可能な遷移動作',
        'Create New Transition Action' => '新しい遷移アクションを作成',
        'Assigned Transition Actions' => '割り当てられた遷移動作',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'アクティビティ',
        'Filter Activities...' => 'アクティビティの絞り込み',
        'Create New Activity' => '新しいアクティビティを作成',
        'Filter Activity Dialogs...' => 'アクティビティ・ダイアログの絞り込み',
        'Transitions' => '遷移',
        'Filter Transitions...' => '遷移の絞り込み',
        'Create New Transition' => '新しい遷移を作成',
        'Filter Transition Actions...' => '遷移アクションの絞り込み',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'プロセスを編集',
        'Print process information' => 'プロセス情報を印刷',
        'Delete Process' => 'プロセスを削除',
        'Delete Inactive Process' => '非アクティブなプロセスを削除',
        'Available Process Elements' => '有効なプロセス要素',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'サイドバー上の要素はドラッグ・アンド・ドロップによりキャンバス上に配置することができます。',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'アクティビティをキャンバスに配置することでアクティビティをプロセスと関連付けることができます。',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'アクティビティ・ダイアログをアクティビティに関連付けるには、サイドバーからキャンバス上のアクティビティにドラッグ・アンド・ドロップして下さい。',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => 'プロセスの情報を編集',
        'Process Name' => 'プロセス名',
        'The selected state does not exist.' => '選択されたステータスは存在しません。',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'アクティビティ、アクティビティダイアログ、遷移を追加、編集',
        'Show EntityIDs' => 'エンティティIDを表示',
        'Extend the width of the Canvas' => 'キャンバスの幅を広げる',
        'Extend the height of the Canvas' => 'キャンバスの高さを拡大する',
        'Remove the Activity from this Process' => 'このプロセスからアクティビティを削除',
        'Edit this Activity' => 'このアクティビティを編集',
        'Save Activities, Activity Dialogs and Transitions' => 'クティビティ、アクティビティダイアログ、遷移を保存',
        'Do you really want to delete this Process?' => 'このプロセスを本当に削除しますか？',
        'Do you really want to delete this Activity?' => 'このアクティビティを本当に削除しますか？',
        'Do you really want to delete this Activity Dialog?' => 'このアクティビティダイアログを本当に削除しますか？',
        'Do you really want to delete this Transition?' => 'この遷移を本当に削除しますか？',
        'Do you really want to delete this Transition Action?' => 'この遷移動作を本当に削除しますか？',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '本当にこのアクティビティをキャンバス上から削除してもよろしいですか？保存せずにこの画面から移動する場合を除いてこの操作の取り消しはできません。',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '本当にこの遷移をキャンバス上から削除してもよろしいですか？保存せずにこの画面から移動する場合を除いてこの操作の取り消しはできません。',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'この画面では、新規プロセスを作成することが出来ます。作成したプロセスを使用できるようにするには、ステータスを「有効」にした後に変更を同期してください。',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'キャンセルして閉じる',
        'Start Activity' => 'アクティビティを開始',
        'Contains %s dialog(s)' => '%sのダイアログが含まれています',
        'Assigned dialogs' => '割り当てられたダイアログ',
        'Activities are not being used in this process.' => 'アクティビティはこのプロセスで使用されていません。',
        'Assigned fields' => '割り当てられたフィールド',
        'Activity dialogs are not being used in this process.' => 'アクティビティダイアログはこのプロセスで使用されていません。',
        'Condition linking' => '条件リンク',
        'Transitions are not being used in this process.' => '遷移はこのプロセスで使用されていません。',
        'Module name' => 'モジュール名',
        'Transition actions are not being used in this process.' => '遷移アクションはこのプロセスで使用されていません。',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'この推移に対する変更は以下のプロセスに影響を与えます',
        'Transition' => '遷移',
        'Transition Name' => '遷移名',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'この推移アクションに対する変更は、以下のプロセスに影響を与えます',
        'Transition Action' => '遷移動作',
        'Transition Action Name' => '遷移動作名',
        'Transition Action Module' => '遷移動作モジュール',
        'Config Parameters' => 'パラメータの設定',
        'Add a new Parameter' => '新規パラメータを追加',
        'Remove this Parameter' => 'このパラメータを削除',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'キューを追加',
        'Edit Queue' => 'キューを編集',
        'Filter for Queues' => 'キューでフィルター',
        'Filter for queues' => 'キューのフィルター',
        'A queue with this name already exists!' => '同じ名前のキューが既に存在しています！',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => '親キュー',
        'Unlock timeout' => 'ロックの解除期限',
        '0 = no unlock' => '0 = ロック解除しない',
        'hours' => '時間',
        'Only business hours are counted.' => '勤務時間のみ計算されます',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '担当者がチケットロック後、ロック期限切れ前にクローズしていない場合、ロックは解除され、他の担当者がチケットを担当できるようになります。',
        'Notify by' => '通知する時間',
        '0 = no escalation' => '0 = エスカレーションしない',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'ここで定義された時間の前に、新規チケットに顧客連絡先が追加されていないか、メール送信、電話などの連絡を取っていない場合、チケットがエスカレーションされます。',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'メールでのフォローアップやカスタマーポータルに追加された記事があれば、エスカレーション更新期限はリセットされます。ここで定義された時間内に顧客からの外部メールや電話の記録が追加されない場合、チケットがエスカレーションされます。',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'ここで定義された時間の前にチケットがクローズしない場合、チケットがエスカレーションされます。',
        'Follow up Option' => 'フォローアップ・オプション',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'クローズしたチケットにフォローアップしたい場合、チケットを再度対応中にするか、拒否して新規チケットにするかを指定します。',
        'Ticket lock after a follow up' => 'フォローアップ後にチケットをロック',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'チケットがクローズした後に顧客がチケットにフォローアップする場合、旧所有者にロックされます。',
        'System address' => 'システムアドレス',
        'Will be the sender address of this queue for email answers.' => 'このキューでのメール回答はこの送信者アドレスになります。',
        'Default sign key' => '既定のサインキー',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => '挨拶文',
        'The salutation for email answers.' => 'メール回答の挨拶文',
        'Signature' => '署名',
        'The signature for email answers.' => 'メール回答の署名',
        'This queue is used in the following config settings:' => 'このキューは、次の設定で使用されます。',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'キュー-自動応答の関連性の管理',
        'Change Auto Response Relations for Queue' => 'キューに対する自動応答の関連性を変更',
        'This filter allow you to show queues without auto responses' => 'このフィルターを使用すると、自動応答なしでキューを表示できます',
        'Queues without Auto Responses' => '自動応答のないキュー',
        'This filter allow you to show all queues' => 'このフィルターを使用すると、全てのキューを表示できます。',
        'Show All Queues' => '全てのキューを表示',
        'Auto Responses' => '自動応答',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'テンプレート-キューの関連性の管理',
        'Filter for Templates' => 'テンプレートでフィルター',
        'Filter for templates' => '',
        'Templates' => 'テンプレート',

        # Template: AdminRegistration
        'System Registration Management' => 'システム登録管理',
        'Edit System Registration' => 'システム登録を修正',
        'System Registration Overview' => 'システム登録一覧',
        'Register System' => '登録システム',
        'Validate OTRS-ID' => 'OTRS-IDの検証',
        'Deregister System' => 'システム登録',
        'Edit details' => '詳細を編集',
        'Show transmitted data' => '送信されたデータを表示',
        'Deregister system' => 'システムを未登録に戻す',
        'Overview of registered systems' => '登録されたシステムの概要',
        'This system is registered with OTRS Group.' => 'このシステムはOTRS社もしくは関連する会社に登録されています。',
        'System type' => 'システム種別',
        'Unique ID' => 'ユニークID',
        'Last communication with registration server' => '登録管理サーバに対する最後のアクセス',
        'System Registration not Possible' => 'システム登録ができない',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '注意：OTRSデーモンが起動していないと、システムの登録が正常に行えません。',
        'Instructions' => '指示',
        'System Deregistration not Possible' => 'システムの登録解除ができない',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '契約上、%sを使用している場合には登録を解除することが出来ませんので注意して下さい。',
        'OTRS-ID Login' => 'OTRS-ID',
        'Read more' => '続きを読む',
        'You need to log in with your OTRS-ID to register your system.' =>
            'システムを登録するには、OTRS-IDでログインする必要があります。',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'OTRS-IDはOTRS.comのウェブページでサインアップに用いたE-Mailアドレスです。',
        'Data Protection' => 'データ保護',
        'What are the advantages of system registration?' => 'システムを登録することのメリット',
        'You will receive updates about relevant security releases.' => '',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => '',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTRS without being registered?' => '登録せずにOTRSを利用できますか？',
        'System registration is optional.' => 'システムへの登録は任意です。',
        'You can download and use OTRS without being registered.' => 'OTRSは、登録することなくダウンロード・利用することができます。',
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
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'まだ OTRS-ID をお持ちではありませんか？',
        'Sign up now' => '新規登録する',
        'Forgot your password?' => 'パスワードを忘れましたか？',
        'Retrieve a new one' => '',
        'Next' => '次へ',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '',
        'Attribute' => '属性',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'OTRSバージョン',
        'Operating System' => 'オペレーションシステム',
        'Perl Version' => 'Perl バージョン',
        'Optional description of this system.' => '',
        'Register' => '登録',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => '登録解除',
        'You can modify registration settings here.' => '',
        'Overview of Transmitted Data' => '送信されたデータの 概要',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => 'システム登録データ',
        'Support Data' => 'サポートデータ',

        # Template: AdminRole
        'Role Management' => 'ロール管理',
        'Add Role' => 'ロールを追加',
        'Edit Role' => 'ロールを編集',
        'Filter for Roles' => 'ロールでフィルター',
        'Filter for roles' => 'ロールでフィルター',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'ロールを作成してグループを追加後、ユーザーにロールを追加してください。',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '未定義のロールがあります。新しいロールを作成し、追加ボタンを押してください。',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'ロール-グループの関連性管理',
        'Roles' => 'ロール',
        'Select the role:group permissions.' => 'ロール：グループ権限を選択。',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '何も選択しなかった場合は、そのグループへ付与される許可はありません（ロールに関してチケットは利用できません）',
        'Toggle %s permission for all' => '全ての %s の権限を切り替え',
        'move_into' => '移転',
        'Permissions to move tickets into this group/queue.' => 'このグループ／キューにチケットの移転権限を付与',
        'create' => '作成',
        'Permissions to create tickets in this group/queue.' => 'このグループ／キューにチケットの作成権限を付与',
        'note' => 'メモ',
        'Permissions to add notes to tickets in this group/queue.' => 'このグループ／キューにチケットへメモ追加権限を付与',
        'owner' => '所有者',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'このグループ／キューにチケットへ所有者変更権限を付与',
        'priority' => '優先度（priority）',
        'Permissions to change the ticket priority in this group/queue.' =>
            'このグループ／キューにチケットの優先度変更権限を付与',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '担当者-ロールの関連性管理',
        'Add Agent' => '担当者の追加',
        'Filter for Agents' => '担当者でフィルター',
        'Filter for agents' => '',
        'Agents' => '担当者',
        'Manage Role-Agent Relations' => 'ロール-担当者の関連性管理',

        # Template: AdminSLA
        'SLA Management' => 'SLA管理',
        'Edit SLA' => 'SLAを編集',
        'Add SLA' => 'SLAを追加',
        'Filter for SLAs' => 'SLAでフィルター',
        'Please write only numbers!' => '数値しか入力できません。',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME管理',
        'Add Certificate' => '証明書を追加',
        'Add Private Key' => '秘密鍵を追加',
        'SMIME support is disabled' => 'SMIMEのサポートが無効になっています',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '',
        'Enable SMIME support' => 'SMIMEサポートを有効にする',
        'Faulty SMIME configuration' => '無効なSMIME設定',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME機能が有効化されましたが関連する設定にエラーがあります。ボタンを押して設定を確認してください。',
        'Check SMIME configuration' => 'SMIME設定の確認',
        'Filter for Certificates' => '証明書でフィルター',
        'Filter for certificates' => '証明書でフィルタ',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => '参照',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'この方法で直接認証と秘密鍵を編集できます。',
        'Hash' => 'ハッシュ',
        'Create' => '作成',
        'Handle related certificates' => '関連付けられた証明書を利用する',
        'Read certificate' => '証明書を読む',
        'Delete this certificate' => 'この証明書を削除',
        'File' => 'ファイル',
        'Secret' => '秘密',
        'Related Certificates for' => '証明書を関連付ける',
        'Delete this relation' => 'この関係を削除する',
        'Available Certificates' => '利用可能な証明書',
        'Filter for S/MIME certs' => 'S/MIME証明書でフィルター',
        'Relate this certificate' => 'この証明書を関連付ける',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME証明書',
        'Close this dialog' => 'このダイアログを閉じる',
        'Certificate Details' => '証明書の詳細',

        # Template: AdminSalutation
        'Salutation Management' => '挨拶文管理',
        'Add Salutation' => '挨拶文を追加',
        'Edit Salutation' => '挨拶文を編集',
        'Filter for Salutations' => '挨拶文でフィルター',
        'Filter for salutations' => '挨拶文でフィルター',
        'e. g.' => '例',
        'Example salutation' => '挨拶文の例',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'セキュアモードを有効にしてください。',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '初回インストール完了後、セキュアモード (通常) に設定されます',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'セキュアモードが無効の場合、アプリケーションが既に実行されているため、SysConfigを介して有効にします。',

        # Template: AdminSelectBox
        'SQL Box' => 'SQLボックス',
        'Filter for Results' => '結果でフィルター',
        'Filter for results' => '結果でフィルター',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'ここではアプリケーションデータベースに直接送るSQLを入力することができます。表の定義を変更することはできません。選択問合せのみ可能です。',
        'Here you can enter SQL to send it directly to the application database.' =>
            'ここではアプリケーションデータベースに直接送るSQLを入力することができます。',
        'Options' => 'オプション',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQLクエリの構文に誤りがあります。確認してください。',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '',
        'Result format' => '結果の書式',
        'Run Query' => 'クエリー実行',
        '%s Results' => '%s結果',
        'Query is executed.' => 'クエリは実行されました。',

        # Template: AdminService
        'Service Management' => 'サービス管理',
        'Add Service' => 'サービスの追加',
        'Edit Service' => 'サービスの編集',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'サービス名は、(サブサービス名を含めて) 半角200文字以内にする必要があります。',
        'Sub-service of' => '親サービス',

        # Template: AdminSession
        'Session Management' => 'セッション管理',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => '全てのセッション',
        'Agent sessions' => '担当者のセッション',
        'Customer sessions' => '顧客のセッション',
        'Unique agents' => '一意の担当者',
        'Unique customers' => '一意の顧客',
        'Kill all sessions' => '全てのセッションを切断',
        'Kill this session' => '現在のセッションを切断',
        'Filter for Sessions' => 'セッションでフィルター',
        'Filter for sessions' => 'セッションでフィルター',
        'Session' => 'セッション',
        'User' => 'ユーザー',
        'Kill' => '切断',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => '署名管理',
        'Add Signature' => '署名を追加',
        'Edit Signature' => '署名を編集',
        'Filter for Signatures' => '署名でフィルター',
        'Filter for signatures' => '署名でフィルター',
        'Example signature' => '署名の例',

        # Template: AdminState
        'State Management' => 'ステータス管理',
        'Add State' => 'ステータスを追加',
        'Edit State' => 'ステータスを編集',
        'Filter for States' => 'ステータスでフィルター',
        'Filter for states' => 'ステータスでフィルター',
        'Attention' => '注意',
        'Please also update the states in SysConfig where needed.' => 'また、必要に応じてシステム設定のステータスを更新して下さい。',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'このステータスはシステム設定の設定にあり、新しいタイプを指すように設定を更新する必要があります！',
        'State type' => 'ステータスのタイプ',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => 'このステータスは、次の設定で使用されます。',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'OTRS Group へのサポートデータの送信ができません！',
        'Enable Cloud Services' => 'クラウドサービスを有効にする',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'このデータは定期的にOTRSグループに送られます。 このデータの送信を停止するには、システム登録を更新して下さい。',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '手動でこのボタンを押すことにより、サポートデータを送信することができます。',
        'Send Update' => '更新を送信',
        'Currently this data is only shown in this system.' => 'このデータは現在このシステム上で表示されています。',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'このボタンを押すとサポートバンドル(システム登録情報、サポートに必要なデータ、インストールされているパッケージリスト、変更されているソース)が作成されます。',
        'Generate Support Bundle' => 'サポートバンドルの生成',
        'The Support Bundle has been Generated' => 'サポートバンドルが生成されました',
        'Please choose one of the following options.' => '次のいずれかのオプションを選択して下さい。',
        'Send by Email' => 'Eメールで送信',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'サポートバンドルをメールで送信するには大きすぎたため、このオプションは無効化されました。',
        'The email address for this user is invalid, this option has been disabled.' =>
            'このユーザーのメールアドレスは無効です。このオプションは無効になっています。',
        'Sending' => '送信者',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'サポートバンドルはOTRSグループに電子メールで自動的に送信されます。',
        'Download File' => 'ファイルのダウンロード',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'サポートバンドルを含むファイルをダウンロードします。ファイルを保存しOTRSグループに他の手段で送信してください。',
        'Error: Support data could not be collected (%s).' => 'エラー：サポートデータを収集できませんでした。（%s）',
        'Details' => '詳細',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'システムメールアドレスの管理',
        'Add System Email Address' => 'システムメールアドレスの追加',
        'Edit System Email Address' => 'システムメールアドレスの編集',
        'Add System Address' => 'システムアドレスを追加',
        'Filter for System Addresses' => 'システムアドレスでフィルター',
        'Filter for system addresses' => 'システムアドレスでフィルター',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '宛先かCcにこのアドレスを持つ全てのメールは選択されたキューに振り分けられます。',
        'Email address' => 'メールアドレス',
        'Display name' => '表示名',
        'This email address is already used as system email address.' => 'このメールアドレスは、すでにシステム用メールアドレスとして利用されています。',
        'The display name and email address will be shown on mail you send.' =>
            '表示名、メールアドレスは送信メールに表示されます。',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'オンライン管理者向けドキュメント',
        'System configuration' => 'システム設定',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '左側のナビゲーションボックスのツリーを使用して、使用可能な設定をナビゲートします。',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '下の検索フィールドまたは上のナビゲーションの検索アイコンを使用して、特定の設定を見つけます。',
        'Find out how to use the system configuration by reading the %s.' =>
            '%sを読んでシステム設定を使い方を確認して下さい。',
        'Search in all settings...' => '全ての設定で検索...',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '変更のデプロイ',
        'Help' => 'ヘルプ',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'デフォルトでは、あなた自身が行った変更点のみに対してデプロイを行うことができます。もし、あなたが他のユーザーが行った変更点に対してもデプロイを行いたい場合は、画面上部に表示されているリンクをクリックしてアドバンスド・デプロイメント・モードに切り替えてください。',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'デプロイメントが復元され、影響を受けるすべての設定が、選択したデプロイメントの状態に差し戻されています。',
        'Please review the changed settings and deploy afterwards.' => '変更された設定を確認し、その後にデプロイして下さい。',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '変更差分のリストが空であるということは、影響を受けるであろう現状の設定と復元された設定の間に差異がないことを示します。',
        'Changes Overview' => '変更一覧',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            'この実行でデプロイされる変更された設定%sがあります。',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '',
        'There are no settings to be deployed.' => 'デプロイする設定はありません。',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '拡張モードに切り替えて、他のユーザーが変更したデプロイ設定を確認します。',
        'Deploy selected changes' => '選択された変更をデプロイ',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'このグループには設定が含まれていません。 サブグループの1つに移動してみて下さい。',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'インポート&エクスポート',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'システムにインポートするファイル（システム設定からエクスポートされたYML形式）をアップロードします。',
        'Upload system configuration' => 'システム設定をアップロード',
        'Import system configuration' => 'システム設定をインポート',
        'Download current configuration settings of your system in a .yml file.' =>
            '現在のシステム設定のファイル（YML形式）をダウンロードして下さい。',
        'Include user settings' => 'ユーザー設定を含める',
        'Export current configuration' => '現在の設定をエクスポート',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '検索する',
        'Search for category' => 'カテゴリを検索',
        'Settings I\'m currently editing' => '現在編集中の設定',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'カテゴリ "%s"の "%s"の検索結果が返されませんでした。',
        'Your search for "%s" in category "%s" returned one result.' => 'カテゴリ "%s"の "%s"の検索結果が1つ返されました。',
        'Your search for "%s" in category "%s" returned %s results.' => 'カテゴリ "%s"の "%s"の検索結果が%s件の結果を返しました。',
        'You\'re currently not editing any settings.' => '現在、設定を編集していません。',
        'You\'re currently editing %s setting(s).' => 'あなたは現在%sの設定を編集しています。',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => '区分',
        'Run search' => '検索を実行',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => 'カスタム設定の一覧を表示',
        'View single Setting: %s' => '単一の設定を表示：%s',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'システムメンテナンス管理',
        'Schedule New System Maintenance' => '新しいシステムメンテナンスをスケジュール',
        'Filter for System Maintenances' => 'システムメンテナンスでフィルター',
        'Filter for system maintenances' => 'システムメンテナンスでフィルター',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'このシステムメンテナンスが開始する前に、ユーザはシステムメンテナンスが行われることについてアナウンスする各画面上で通知を受け取ります。',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Stop date' => '終了日',
        'Delete System Maintenance' => 'システムメンテナンスを削除',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'システムメンテナンスを修正',
        'Edit System Maintenance Information' => 'システムメンテナンス情報を修正',
        'Date invalid!' => '日時が無効です。',
        'Login message' => 'ログインメッセージ',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'ログインメッセージを表示',
        'Notify message' => '通知メッセージ',
        'Manage Sessions' => 'セッションの管理',
        'All Sessions' => '全てのセッション',
        'Agent Sessions' => '担当者のセッション',
        'Customer Sessions' => '顧客のセッション',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'テンプレートを追加',
        'Edit Template' => 'テンプレートを編集',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'テンプレートは担当者による高速なチケット作成、回答または転送を支援するデフォルトの本文です。',
        'Don\'t forget to add new templates to queues.' => '新しいテンプレートにキューを追加してください。',
        'Attachments' => '添付ファイル',
        'Delete this entry' => 'この登録を削除',
        'Do you really want to delete this template?' => '本当にこのテンプレートを削除してよろしいですか？',
        'A standard template with this name already exists!' => '',
        'Template' => 'テンプレート',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => '作成するタイプテンプレートはこのスマートタグのみをサポートします。',
        'Example template' => 'テンプレート例',
        'The current ticket state is' => '現在のチケットのステータスは',
        'Your email address is' => 'あなたのメールアドレスは',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => '全てを有効に切り替え',
        'Link %s to selected %s' => '%s を選択された %s へリンク',

        # Template: AdminType
        'Type Management' => 'タイプ管理',
        'Add Type' => 'タイプの追加',
        'Edit Type' => 'タイプの編集',
        'Filter for Types' => 'タイプでフィルター',
        'Filter for types' => 'タイプでフィルター',
        'A type with this name already exists!' => 'この名前のタイプは既に存在します!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => '担当者管理',
        'Edit Agent' => '担当者の編集',
        'Edit personal preferences for this agent' => 'この担当者の個人設定を編集',
        'Agents will be needed to handle tickets.' => '担当者はチケットを処理するために必要です。',
        'Don\'t forget to add a new agent to groups and/or roles!' => '新規担当者をグループまたはロールに追加してください。',
        'Please enter a search term to look for agents.' => '担当者を検索するための条件を入力してください。',
        'Last login' => '最終ログイン',
        'Switch to agent' => '担当者を切り替え',
        'Title or salutation' => 'タイトルまたは挨拶文',
        'Firstname' => '姓',
        'Lastname' => '名',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '空白のままにした場合、自動的に生成されます。',
        'Mobile' => '携帯電話',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => 'この担当者にはグループ権限はありません。',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '担当者 - グループの関連性の管理',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'アジェンダ表示',
        'Manage Calendars' => 'カレンダー管理',
        'Add Appointment' => '予約の登録',
        'Today' => '本日',
        'All-day' => '終日',
        'Repeat' => '繰り返し',
        'Notification' => '通知',
        'Yes' => 'はい',
        'No' => 'いいえ',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'カレンダーは見つかりませんでした。 まずカレンダーの管理ページを使用してカレンダーを追加して下さい。',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '予約の登録',
        'Calendars' => 'カレンダー',

        # Template: AgentAppointmentEdit
        'Basic information' => '基本情報',
        'Date/Time' => '日にち/時間',
        'Invalid date!' => '無効な日付です。',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => 'これは繰り返しの予定です。',
        'Click here to see the parent appointment.' => '親の予定を見るには、ここをクリックして下さい。',
        'Click here to edit the parent appointment.' => '親の予定を修正するには、ここをクリックして下さい。',
        'Frequency' => '頻度',
        'Every' => '全て',
        'day(s)' => '日',
        'week(s)' => '週',
        'month(s)' => '月',
        'year(s)' => '年',
        'On' => 'オン',
        'Monday' => '月曜日',
        'Mon' => '月',
        'Tuesday' => '火曜日',
        'Tue' => '火',
        'Wednesday' => '水曜日',
        'Wed' => '水',
        'Thursday' => '木曜日',
        'Thu' => '木',
        'Friday' => '金曜日',
        'Fri' => '金',
        'Saturday' => '土曜日',
        'Sat' => '土',
        'Sunday' => '日曜日',
        'Sun' => '日',
        'January' => '1月',
        'Jan' => '1月',
        'February' => '2月',
        'Feb' => '2月',
        'March' => '3月',
        'Mar' => '3月',
        'April' => '4月',
        'Apr' => '4月',
        'May_long' => '5月',
        'May' => '5月',
        'June' => '6月',
        'Jun' => '6月',
        'July' => '7月',
        'Jul' => '7月',
        'August' => '8月',
        'Aug' => '8月',
        'September' => '9月',
        'Sep' => '9月',
        'October' => '10月',
        'Oct' => '10月',
        'November' => '11月',
        'Nov' => '11月',
        'December' => '12月',
        'Dec' => '12月',
        'Relative point of time' => '',
        'Link' => 'リンク',
        'Remove entry' => '登録を削除',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '顧客情報センター',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '顧客ユーザー',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '注意: 顧客が無効です。',
        'Start chat' => 'チャットを開始する。',
        'Video call' => 'ビデオ通話',
        'Audio call' => '音声通話',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '顧客ユーザーのアドレス帳',
        'Search for recipients and add the results as \'%s\'.' => '受信者を検索し、結果を \'%s\'として追加します。',
        'Search template' => '検索テンプレート',
        'Create Template' => 'テンプレート作成',
        'Create New' => '新規作成',
        'Save changes in template' => '変更したテンプレートを保存',
        'Filters in use' => '使用中のフィルター',
        'Additional filters' => '追加のフィルター',
        'Add another attribute' => '属性を追加',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'XX(顧客)という表記は、顧客企業のデータです。',
        '(e. g. Term* or *Term*)' => '(例 Term *または* Term *）',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => '全選択',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => 'この顧客ユーザーを選択',
        'Add selected customer user to' => '選択した顧客ユーザーを追加する',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => '検索オプション変更',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '顧客ユーザー情報センター',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            '',
        'Starting the OTRS Daemon' => 'OTRS デーモンを起動しています。',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            '',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'ダッシュボード',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '予約の登録',
        'Tomorrow' => '翌日',
        'Soon' => 'すぐに',
        '5 days' => '5日',
        'Start' => '開始',
        'none' => 'なし',

        # Template: AgentDashboardCalendarOverview
        'in' => '＞',

        # Template: AgentDashboardCommon
        'Save settings' => '設定を保存',
        'Close this widget' => 'このウィジェットを閉じる',
        'more' => '続き',
        'Available Columns' => '利用可能な列',
        'Visible Columns (order by drag & drop)' => '表示する列 (ドラッグ&ドロップで並び替えできます)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '顧客関係を変更',
        'Open' => '対応中',
        'Closed' => 'クローズ',
        '%s open ticket(s) of %s' => '%sのオープンチケット%s',
        '%s closed ticket(s) of %s' => '%sのクローズチケット%s',
        'Edit customer ID' => '顧客IDを編集',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'エスカレーション済チケット',
        'Open tickets' => '対応中チケット',
        'Closed tickets' => 'クローズ・チケット',
        'All tickets' => '全てのチケット',
        'Archived tickets' => 'アーカイブされたチケット',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '注意: 顧客ユーザーが無効です。',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '顧客ユーザー情報',
        'Phone ticket' => '電話チケット',
        'Email ticket' => 'メールチケット',
        'New phone ticket from %s' => '%sからの新規電話チケット',
        'New email ticket to %s' => '%s宛の新規メールチケット',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s が利用できます。',
        'Please update now.' => '更新してください',
        'Release Note' => 'リリースノート',
        'Level' => 'レベル',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '%s の前の投稿',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'このレポート・ウィジェットの設定にエラーがあります。設定を確認して下さい。',
        'Download as SVG file' => 'SVGファイルとしてダウンロード',
        'Download as PNG file' => 'PNGファイルとしてダウンロード',
        'Download as CSV file' => 'CSVファイルとしてダウンロード',
        'Download as Excel file' => 'Excelファイルとしてダウンロード',
        'Download as PDF file' => 'PDFファイルとしてダウンロード',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'このウィジェットの設定で有効なグラフ出力形式を選択して下さい。',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'このレポートの内容はあなたのために用意されています。',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'このレポートは、レポート管理者が設定を修正する必要があるため、現在は使用できません。',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '顧客ユーザーに割り当てられた',
        'Accessible for customer user' => '顧客ユーザーにアクセス可能',
        'My locked tickets' => 'ロックチケット',
        'My watched tickets' => '監視チケット',
        'My responsibilities' => '責任チケット',
        'Tickets in My Queues' => '担当キュー内チケット',
        'Tickets in My Services' => '担当サービス内チケット',
        'Service Time' => 'サービス時間',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '計',

        # Template: AgentDashboardUserOnline
        'out of office' => '外出中',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '〜まで',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'ニュース、ライセンスなどの変更を受け付ける。',
        'Yes, accepted.' => 'はい、受け入れます。',

        # Template: AgentLinkObject
        'Manage links for %s' => '%sのリンクを管理',
        'Create new links' => '新しいリンクを作成',
        'Manage existing links' => '既存のリンクを管理',
        'Link with' => 'リンク先',
        'Start search' => '検索',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '現在、リンクはありません。 このアイテムを他のオブジェクトにリンクするには、上部にある[新しいリンクを作成]をクリックしてください。',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => '個人設定を編集',
        'Personal Preferences' => '個人設定',
        'Preferences' => '個人設定',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => 'このエージェントの編集に戻る',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'あなたの個人的な好みを設定してください。 右のチェックマークをクリックして各設定を保存します。',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '以下のナビゲーションツリーを使用して、特定のグループの設定のみを表示することができます。',
        'Dynamic Actions' => 'ダイナミック・アクション',
        'Filter settings...' => 'フィルターを設定中...',
        'Filter for settings' => '設定でフィルター',
        'Save all settings' => 'すべての設定を保存',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'アバターイメージを変更するには、%sにあなたのメールアドレス(%s)を登録して下さい。キャッシュの影響により新しいアバターが利用可能になるまでには時間がかかることがあります。',
        'Off' => 'オフ',
        'End' => '終了',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => 'この設定は現在保存できません。',
        'Save this setting' => 'この設定を保存',
        'Did you know? You can help translating OTRS at %s.' => 'ご存じですか? %sにてOTRSの翻訳にご協力ください。',

        # Template: SettingsList
        'Reset to default' => 'デフォルトにリセットする',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '右側のグループから選択して、変更したい設定を見つけて下さい。',
        'Did you know?' => 'ご存知ですか？',
        'You can change your avatar by registering with your email address %s on %s' =>
            '%sで、あなたの電子メールアドレス%sを登録することによって、あなたのアバターに変更することができます。',

        # Template: AgentSplitSelection
        'Target' => 'ターゲット',
        'Process' => 'プロセス',
        'Split' => '分割',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'レポート管理',
        'Add Statistics' => 'レポートを追加',
        'Read more about statistics in OTRS' => 'OTRSのレポートについて詳細を読む',
        'Dynamic Matrix' => '集計',
        'Each cell contains a singular data point.' => '各セルには特異点が含まれています。',
        'Dynamic List' => '一覧',
        'Each row contains data of one entity.' => '各行には1つのエンティティのデータが含まれています。',
        'Static' => '静的',
        'Non-configurable complex statistics.' => '構成できない複雑なレポート',
        'General Specification' => '一般仕様',
        'Create Statistic' => 'レポートを作成',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'レポートを編集',
        'Run now' => '今すぐ実行',
        'Statistics Preview' => 'レポートのプレビュー',
        'Save Statistic' => 'レポートを保存',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'レポートをインポート',
        'Import Statistics Configuration' => 'レポート設定をインポート',

        # Template: AgentStatisticsOverview
        'Statistics' => 'レポート',
        'Run' => '実行',
        'Edit statistic "%s".' => 'レポート"%s"を修正',
        'Export statistic "%s"' => 'レポート"%s"をエクスポート',
        'Export statistic %s' => 'レポート"%s"をエクスポート',
        'Delete statistic "%s"' => 'レポート"%s"を削除',
        'Delete statistic %s' => 'レポート"%s"を削除',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'レポート一覧',
        'View Statistics' => '統計を閲覧',
        'Statistics Information' => 'レポート情報',
        'Created by' => '作成者',
        'Changed by' => '変更者',
        'Sum rows' => '行の合計',
        'Sum columns' => '列の合計',
        'Show as dashboard widget' => 'ダッシュボードウィジェットとして表示',
        'Cache' => 'キャッシュ',
        'This statistic contains configuration errors and can currently not be used.' =>
            'このレポートには構成エラーがあり、現在は使用できません。',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '%s%s%sのフリーテキストを変更',
        'Change Owner of %s%s%s' => '%s%s%sの所有者を変更',
        'Close %s%s%s' => '%s%s%sを閉じる',
        'Add Note to %s%s%s' => '%s%s%sにメモを追加',
        'Set Pending Time for %s%s%s' => '%s%s%sの保留時間を設定',
        'Change Priority of %s%s%s' => '%s%s%sの優先度を変更',
        'Change Responsible of %s%s%s' => '%s%s%sの責任者を変更',
        'All fields marked with an asterisk (*) are mandatory.' => 'アスタリスク（*）が付いている全ての領域は必須入力です。',
        'The ticket has been locked' => 'チケットはロック済です',
        'Undo & close' => '元に戻して閉じる',
        'Ticket Settings' => 'チケット設定',
        'Queue invalid.' => '無効なキューです。',
        'Service invalid.' => '無効なサービスです',
        'SLA invalid.' => 'SLAが無効です。',
        'New Owner' => '新しい所有者',
        'Please set a new owner!' => '新規所有者を設定してください。',
        'Owner invalid.' => '所有者が無効です。',
        'New Responsible' => '新しい責任者',
        'Please set a new responsible!' => '新しい責任者を設定して下さい！',
        'Responsible invalid.' => '責任者が無効です。',
        'Next state' => 'ステータス',
        'State invalid.' => 'ステータスが無効です。',
        'For all pending* states.' => '全ての保留ステータスに対して有効',
        'Add Article' => '記事を追加',
        'Create an Article' => '記事を作成',
        'Inform agents' => '担当者に通知する',
        'Inform involved agents' => '関係する担当者に通知する',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'ここでは、新しい記事に関する通知を受け取るべき担当者をを選択することができます。',
        'Text will also be received by' => 'このテキストは、次の方も閲覧可能です',
        'Text Template' => '本文テンプレート',
        'Setting a template will overwrite any text or attachment.' => 'テンプレートを設定すると作成中の本文または添付ファイルは上書きされます。',
        'Invalid time!' => '無効な時間です。',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '%s%s%sをバウンス',
        'Bounce to' => 'バウンスto',
        'You need a email address.' => 'メールアドレスが必要です',
        'Need a valid email address or don\'t use a local email address.' =>
            '有効なメールアドレスを使用するか、ローカルなメールアドレスを使用しないでください。',
        'Next ticket state' => 'ステータス',
        'Inform sender' => '送信者に知らせる',
        'Send mail' => 'メール送信！',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'チケット一括処理',
        'Send Email' => 'Eメールの送信',
        'Merge' => '結合',
        'Merge to' => 'これと結合',
        'Invalid ticket identifier!' => '無効なチケット識別子です。',
        'Merge to oldest' => '古いものへ結合',
        'Link together' => '一緒にリンク',
        'Link to parent' => '親へリンク',
        'Unlock tickets' => 'チケットのロック解除',
        'Execute Bulk Action' => '一括処理を実行',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '%s%s%sの返信を作成',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => '受信者を少なくとも1人は含めるようにして下さい。',
        'Select one or more recipients from the customer user address book.' =>
            '顧客ユーザーのアドレス帳から1人以上の受信者を選択します。',
        'Customer user address book' => '顧客ユーザーのアドレス帳',
        'Remove Ticket Customer' => 'チケットの顧客を削除',
        'Please remove this entry and enter a new one with the correct value.' =>
            'このエントリーを削除し、正しい値で新しいエントリーを追加してください。',
        'This address already exists on the address list.' => 'この住所はすでにアドレスリストに存在します。',
        'Remove Cc' => 'Ccを削除',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Bccを削除',
        'Date Invalid!' => '日時が無効です。',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '%s%s%sの顧客を変更',
        'Customer Information' => '顧客情報',
        'Customer user' => '顧客ユーザー',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '新規メールチケットの作成',
        'Example Template' => 'テンプレート例',
        'From queue' => 'キューから',
        'To customer user' => '宛先顧客ユーザー',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => 'チケットの顧客ユーザーを削除',
        'Get all' => '全てを取得',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '%s%s%sの送信メール',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '%s%s%sのメールを再送信',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '%s%s%sを転送',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '%s%s%sの履歴',
        'Filter for history items' => '履歴アイテムをフィルター',
        'Expand/collapse all' => 'すべて展開/折りたたむ',
        'CreateTime' => '作成日時',
        'Article' => '記事',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '%s%s%sをマージ',
        'Merge Settings' => 'マージ設定',
        'You need to use a ticket number!' => '使用するチケット番号が必要です。',
        'A valid ticket number is required.' => '有効なチケット番号が必要です。',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '送信者を通知',
        'Need a valid email address.' => '有効なメールアドレスが必要です。',

        # Template: AgentTicketMove
        'Move %s%s%s' => '%s%s%sを移転',
        'New Queue' => '新規キュー',
        'Move' => '移転',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'チケットデータがありません',
        'Open / Close ticket action menu' => 'チケットアクションメニューを開く/閉じる',
        'Select this ticket' => 'このチケットを選択',
        'Sender' => '送信者',
        'First Response Time' => '初回応答期限',
        'Update Time' => '更新期限',
        'Solution Time' => '解決期限',
        'Move ticket to a different queue' => '別のキューへチケットを移転',
        'Change queue' => 'キュー変更',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'この画面のアクティブなフィルターを削除します。',
        'Tickets per page' => 'ページ毎のチケット数',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'チャンネルがありません。',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '一覧のリセット',
        'Column Filters Form' => 'カラム・フィルター・フォーム',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '新規電話チケットに分割',
        'Save Chat Into New Phone Ticket' => 'チャットを新規チケットに保存する。',
        'Create New Phone Ticket' => '新規電話チケットの作成',
        'Please include at least one customer for the ticket.' => 'チケットには少なくとも1名のお客様を含めるようにして下さい。',
        'To queue' => 'キュー',
        'Chat protocol' => 'チャットプロトコル',
        'The chat will be appended as a separate article.' => 'チャットは新規記事として追加されます。',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '%s%s%sの受話',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '%s%s%sの電子メールを表示',
        'Plain' => '書式なし',
        'Download this email' => 'このメールをダウンロード',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '新しいプロセスチケットを作成',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'チケットをプロセスに登録する',

        # Template: AgentTicketSearch
        'Profile link' => 'プロファイル・リンク',
        'Output' => '出力',
        'Fulltext' => '全文',
        'Customer ID (complex search)' => 'Customer ID (複合検索)',
        '(e. g. 234*)' => '(例 234*)',
        'Customer ID (exact match)' => 'Customer ID (完全一致)',
        'Assigned to Customer User Login (complex search)' => '顧客ユーザーのログインに割り当てられた（複合検索）',
        '(e. g. U51*)' => '(例 U51*)',
        'Assigned to Customer User Login (exact match)' => '顧客のユーザーログインに割り当てられた（完全一致）',
        'Accessible to Customer User Login (exact match)' => '顧客のログインにアクセス可能（完全一致）',
        'Created in Queue' => 'キューで作成された',
        'Lock state' => 'ロックの状態',
        'Watcher' => '監視者',
        'Article Create Time (before/after)' => '記事作成日時 (以前/以後)',
        'Article Create Time (between)' => '記事作成日時 (期間指定)',
        'Please set this to value before end date.' => '終了日より前の値を設定して下さい。',
        'Please set this to value after start date.' => '終了日より後の値を設定して下さい。',
        'Ticket Create Time (before/after)' => 'チケット作成日時 (以前/以後)',
        'Ticket Create Time (between)' => 'チケット作成日時 (期間指定)',
        'Ticket Change Time (before/after)' => 'チケット変更時間 (以前/以後)',
        'Ticket Change Time (between)' => 'チケット変更日時 (期間指定)',
        'Ticket Last Change Time (before/after)' => 'チケット最終変更時間 (以前/以後)',
        'Ticket Last Change Time (between)' => 'チケット最終変更日時 (期間指定)',
        'Ticket Pending Until Time (before/after)' => 'ある時間帯(以前/以後)のチケットを保留中',
        'Ticket Pending Until Time (between)' => 'ある時間帯のチケットを保留中',
        'Ticket Close Time (before/after)' => 'チケット・クローズ時間 (以前/以後)',
        'Ticket Close Time (between)' => 'チケットのクローズ日時 (期間指定)',
        'Ticket Escalation Time (before/after)' => 'チケットエスカレーション時間 (以前/以後)',
        'Ticket Escalation Time (between)' => 'チケットエスカレーション日時 (期間指定)',
        'Archive Search' => 'アーカイブ検索',

        # Template: AgentTicketZoom
        'Sender Type' => '送信者タイプ',
        'Save filter settings as default' => 'デフォルトのフィルター設定を保存',
        'Event Type' => 'イベントタイプ',
        'Save as default' => 'ドラフトとして保存',
        'Drafts' => '下書き',
        'by' => 'by',
        'Change Queue' => 'キューを変更',
        'There are no dialogs available at this point in the process.' =>
            'このプロセスは完了しました。',
        'This item has no articles yet.' => 'このチケットにはまだ記事がありません。',
        'Ticket Timeline View' => 'チケットのタイムラインビュー',
        'Article Overview - %s Article(s)' => '記事一覧 - %s件',
        'Page %s' => '%sページ',
        'Add Filter' => 'フィルターを追加',
        'Set' => '設定',
        'Reset Filter' => 'フィルターをリセット',
        'No.' => '番号',
        'Unread articles' => '未読記事',
        'Via' => '経由',
        'Important' => '重要',
        'Unread Article!' => '未読記事があります。',
        'Incoming message' => '受信メッセージ',
        'Outgoing message' => '送信メッセージ',
        'Internal message' => '内部メッセージ',
        'Sending of this message has failed.' => 'このメッセージの送信に失敗しました。',
        'Resize' => 'リサイズ',
        'Mark this article as read' => 'この記事を既読にして下さい。',
        'Show Full Text' => '全文を表示する',
        'Full Article Text' => '全ての記事テキスト',
        'No more events found. Please try changing the filter settings.' =>
            '',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => '%s経由',
        'by %s' => '%sによって',
        'Toggle article details' => '記事の詳細を切り替える',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '次の記事でリンクを開くには、CtrlキーまたはCmdキーまたはShiftキーを押しながらリンクをクリックする必要があります（ブラウザとOSによって異なります）。',
        'Close this message' => 'このメッセージを閉じる',
        'Image' => '画像',
        'PDF' => 'PDF',
        'Unknown' => 'アンノウン',
        'View' => 'ビュー',

        # Template: LinkTable
        'Linked Objects' => 'オブジェクトをリンク',

        # Template: TicketInformation
        'Archive' => 'アーカイブ',
        'This ticket is archived.' => 'このチケットはアーカイブされています。',
        'Note: Type is invalid!' => '',
        'Pending till' => '保留時間',
        'Locked' => 'ロック状態',
        '%s Ticket(s)' => '%sチケット',
        'Accounted time' => '作業時間',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'ブロックされた内容を読み込み。',

        # Template: Breadcrumb
        'Home' => 'ホーム',
        'Back to admin overview' => '管理一覧に戻る',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'この機能にはクラウドサービスが必要',
        'You can' => '次のことができます: ',
        'go back to the previous page' => '直前のページに戻る',

        # Template: CustomerAccept
        'Dear Customer,' => 'お客様各位',
        'thank you for using our services.' => '私たちのサービスをご利用いただきありがとうございます。',
        'Yes, I accept your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '',
        'Select a customer ID to assign to this ticket.' => '',
        'From all Customer IDs' => '全てのCustomer IDから',
        'From assigned Customer IDs' => '割り当てられた顧客IDから',

        # Template: CustomerError
        'An Error Occurred' => 'エラーが発生しました。',
        'Error Details' => 'エラーの詳細',
        'Traceback' => 'トレースバック',

        # Template: CustomerFooter
        '%s powered by %s™' => '%spowered by %s',
        'Powered by %s™' => 'powered by %s™',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScriptが有効になっていません。',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'ブラウザの警告',
        'The browser you are using is too old.' => 'ご利用のブラウザは古すぎます。',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            '詳細はマニュアルを参照するか、管理者にお問い合わせください。',
        'One moment please, you are being redirected...' => '',
        'Login' => 'ログイン',
        'User name' => 'ユーザー名',
        'Your user name' => 'ユーザー名',
        'Your password' => 'パスワード',
        'Forgot password?' => 'パスワードを忘れましたか？',
        '2 Factor Token' => '',
        'Your 2 Factor Token' => '',
        'Log In' => 'ログイン',
        'Not yet registered?' => '未登録ですか？',
        'Back' => '戻る',
        'Request New Password' => '新規パスワードを申請',
        'Your User Name' => 'ユーザー名',
        'A new password will be sent to your email address.' => '登録されたメールアドレスに新しいパスワードを送信します。',
        'Create Account' => 'アカウント作成',
        'Please fill out this form to receive login credentials.' => '下記のフォームにログイン時に必要となる事項を入力してください。',
        'How we should address you' => '',
        'Your First Name' => 'あなたの姓',
        'Your Last Name' => 'あなたの名字',
        'Your email address (this will become your username)' => 'あなたの電子メールアドレス (ユーザー名になります)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '受信チャット要求',
        'Edit personal preferences' => '個人設定の編集',
        'Logout %s' => '%sをログアウト',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'サービスレベル契約 (SLA)',

        # Template: CustomerTicketOverview
        'Welcome!' => 'ようこそ！',
        'Please click the button below to create your first ticket.' => 'チケットを作成するために下のボタンをクリックしてください。',
        'Create your first ticket' => 'チケット作成',

        # Template: CustomerTicketSearch
        'Profile' => 'プロファイル',
        'e. g. 10*5155 or 105658*' => '例: 10*5155 または 105658*',
        'CustomerID' => '顧客ID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'チケットにおける全文検索（例えば、「John * n」または「Will *」）',
        'Types' => 'タイプ',
        'Time Restrictions' => '時間制限',
        'No time settings' => '時間設定なし',
        'All' => '全て',
        'Specific date' => '特定の日付',
        'Only tickets created' => '作成されたチケットのみ',
        'Date range' => '日付の範囲',
        'Only tickets created between' => 'この期間に作成されたチケットのみ',
        'Ticket Archive System' => 'チケット・アーカイブシステム',
        'Save Search as Template?' => 'テンプレートとして検索を保存しますか？',
        'Save as Template?' => 'テンプレートを保存しますか？',
        'Save as Template' => 'テンプレートとして保存',
        'Template Name' => 'テンプレート名',
        'Pick a profile name' => 'テンプレート名',
        'Output to' => '出力: ',

        # Template: CustomerTicketSearchResultShort
        'of' => '/',
        'Page' => 'ページ',
        'Search Results for' => '検索結果: ',
        'Remove this Search Term.' => 'この検索語を削除して下さい。',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'このチケットからチャットを開始する。',
        'Next Steps' => '次のステップ',
        'Reply' => '返信',

        # Template: Chat
        'Expand article' => '記事を展開',

        # Template: CustomerWarning
        'Warning' => '警告',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'イベント情報',
        'Ticket fields' => 'チケット・フィールド',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '本当にバグですか？ 10つのバグレポートのうち5つは、OTRSのインストールが間違っているか不完全であることに起因しています。',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => '今すぐ、サービス担当までご連絡ください。',
        'Send a bugreport' => 'バグ報告を送信',
        'Expand' => '展開',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => '下書きを更新',
        'Save as new draft' => '新しい下書きとして保存',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '下書き"%s"を読み込んでいます。',
        'You have loaded the draft "%s". You last changed it %s.' => '下書き"%s"を読み込んでいます。 あなたは最後に%sを変更しました。',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'ドラフト"%s"を読み込んでいます。 %sによって%sが最後に変更されました。',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'このドラフトは、このドラフトが作成されてから改訂されたため、古くなっています。',

        # Template: Header
        'View notifications' => '通知を見る',
        'Notifications' => '通知',
        'Notifications (OTRS Business Solution™)' => '通知(OTRS Business Solution™)',
        'Personal preferences' => '個人設定',
        'Logout' => 'ログアウト',
        'You are logged in as' => 'ログイン中: ',

        # Template: Installer
        'JavaScript not available' => 'JavaScriptが利用できません。',
        'Step %s' => 'ステップ %s',
        'License' => 'ライセンス',
        'Database Settings' => 'データベース設定',
        'General Specifications and Mail Settings' => '共通仕様とメール設定',
        'Finish' => '完了',
        'Welcome to %s' => '%s にようこそ',
        'Germany' => '',
        'Phone' => '電話',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Webサイト',

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
        'Password for inbound mail.' => '受信メールのパスワード',
        'Result of mail configuration check' => 'メール設定チェックの結果',
        'Check mail configuration' => 'メール設定チェック',
        'Skip this step' => 'この手順を飛ばす',

        # Template: InstallerDBResult
        'Done' => '完了',
        'Error' => 'エラー',
        'Database setup successful!' => 'データベース　設定成功',

        # Template: InstallerDBStart
        'Install Type' => 'インストールタイプ',
        'Create a new database for OTRS' => '新規にOTRSデータベースを作成する',
        'Use an existing database for OTRS' => '既存のOTRSデータベースを使用する',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'データベースのrootパスワードを設定した場合、この領域を入力しなければなりません。そうでない場合は、この領域を空のままにしてください。',
        'Database name' => 'データベース名',
        'Check database settings' => 'データベース設定をチェック',
        'Result of database check' => 'データベースチェックの結果',
        'Database check successful.' => 'データベースチェックに成功しました。',
        'Database User' => 'データベース・ユーザー',
        'New' => '新規',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'このOTRSシステム用に限られた権限の新規データベースユーザーが作成されます。',
        'Repeat Password' => 'パスワードを再度入力',
        'Generated password' => 'パスワードを生成しました。',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'パスワードが一致しません',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Port',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'OTRSを使用するには、rootでコマンドライン上 (ターミナル／シェル) から次の行を入力する必要があります。',
        'Restart your webserver' => 'Webサーバを再起動してください。',
        'After doing so your OTRS is up and running.' => 'その後、OTRSの起動を実行してください。',
        'Start page' => 'スタートページ',
        'Your OTRS Team' => 'Your OTRS Team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'ライセンスに同意しない',
        'Accept license and continue' => '',

        # Template: InstallerSystem
        'SystemID' => 'システムID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'システムの識別子。各チケット番号とHTTPセッションIDはこの番号が含まれます。',
        'System FQDN' => 'システムのFQDN',
        'Fully qualified domain name of your system.' => 'システムのFQDN',
        'AdminEmail' => '管理者メール',
        'Email address of the system administrator.' => 'システム管理者のメールアドレス',
        'Organization' => '組織',
        'Log' => 'ログ',
        'LogModule' => 'ログモジュール',
        'Log backend to use.' => 'ログバックエンドを使用するには',
        'LogFile' => 'ログファイル',
        'Webfrontend' => 'Webフロントエンド',
        'Default language' => '既定の言語',
        'Default language.' => '既定の言語。',
        'CheckMXRecord' => 'MXレコードのチェック',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '入力されたメールアドレスがDNSのMXレコードと照合されます。利用しているDNSが遅い場合、または公開アドレスが解決できない場合はこのオプションを使用しないでください。',

        # Template: LinkObject
        'Delete link' => 'リンクを削除',
        'Delete Link' => 'リンクを削除',
        'Object#' => '対象の番号',
        'Add links' => 'リンクを追加',
        'Delete links' => 'リンクを削除',

        # Template: Login
        'Lost your password?' => 'パスワードを忘れた方',
        'Back to login' => 'ログイン画面に戻る',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => 'プレビューを閉じる',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => '今日のメッセージ',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => '権限がありません',
        'Back to the previous page' => '前のページに戻る。',

        # Template: Alert
        'Alert' => 'アラート',
        'Powered by' => 'Powered by',

        # Template: Pagination
        'Show first page' => '最初のページを表示',
        'Show previous pages' => '前のページを表示',
        'Show page %s' => '%s ページを表示',
        'Show next pages' => '次のページを表示',
        'Show last page' => '最後のページを表示',

        # Template: PictureUpload
        'Need FormID!' => 'フォームIDの入力が必要です！',
        'No file found!' => 'ファイルがありません！',
        'The file is not an image that can be shown inline!' => '',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '\'%s\' の通知メッセージを、転送方法 \'%s\' で受信します。',

        # Template: ActivityDialogHeader
        'Process Information' => 'プロセス情報',
        'Dialog' => 'ダイアログ',

        # Template: Article
        'Inform Agent' => '担当者に知らせる',

        # Template: PublicDefault
        'Welcome' => 'ようこそ',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => '権限',
        'You can select one or more groups to define access for different agents.' =>
            '担当者ごとに、複数のグループを同時選択することもできます。',
        'Result formats' => '出力フォーマット',
        'Time Zone' => 'タイムゾーン（時間帯）',
        'The selected time periods in the statistic are time zone neutral.' =>
            'レポートの中で選択された期間は、時間帯にナチュラルです。',
        'Create summation row' => '合計行を追加',
        'Generate an additional row containing sums for all data rows.' =>
            '全てのデータ行の合計を含む追加の行を生成します。',
        'Create summation column' => '合計列を追加',
        'Generate an additional column containing sums for all data columns.' =>
            '全てのデータ列の合計を含む追加の列を生成します。',
        'Cache results' => 'キャッシュ結果',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'レポート結果データをキャッシュに保存して、同じ設定で後続のビューで使用するようにしました（少なくとも1つの選択された時間フィールドが必要です）。',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '担当者が自らのダッシュボードでアクティブにできるウィジェットとして統計を利用できます。',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'ダッシュボードウィジェットを有効にすると、ダッシュボードでこの統計のキャッシュが有効化されます。',
        'If set to invalid end users can not generate the stat.' => '無効なエンドユーザーに設定されている場合、統計を生成できません。',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'このレポート情報の設定には問題があります。',
        'You may now configure the X-axis of your statistic.' => 'レポートのX軸を設定できます。',
        'This statistic does not provide preview data.' => 'このレポートはプレビューデータを提供しません。',
        'Preview format' => 'プレビュー形式',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'プレビュー画面ではランダムデータを利用しており、またデータ・フィルタを考慮していませんので、ご留意願います。',
        'Configure X-Axis' => 'X軸の設定',
        'X-axis' => 'X軸',
        'Configure Y-Axis' => 'Y軸の設定',
        'Y-axis' => 'Y軸',
        'Configure Filter' => 'フィルタの設定',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '選択する項目を1つのみにするか、「固定値」をオフにしてください。',
        'Absolute period' => '絶対値',
        'Between %s and %s' => '%sと%sの間',
        'Relative period' => '相対値',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            'レポートが生成されたときにこの要素に変更を許可しないで下さい。',

        # Template: StatsParamsWidget
        'Format' => '書式',
        'Exchange Axis' => '縦横軸の交換',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => '要素が選択されていません。',
        'Scale' => '目盛',
        'show more' => 'もっと見せる',
        'show less' => 'あまり見せない',

        # Template: D3
        'Download SVG' => 'SVG画像のダウンロード',
        'Download PNG' => 'PNG画像のダウンロード',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '選択した期間は、このレポートがデータを収集するためのデフォルトの時間枠を定義します。',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Y軸の目盛はX軸の目盛より大きくする必要があります (例: X軸=>月、Y軸=>年)',

        # Template: SettingsList
        'This setting is disabled.' => 'この設定は無効です。',
        'This setting is fixed but not deployed yet!' => 'この設定は確定しましたが、まだデプロイされていません！',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => 'この設定の詳細オプションを切り替えます。',
        'Disable this setting, so it is no longer effective' => 'この設定を無効にすると無効になります。',
        'Disable' => '無効',
        'Enable this setting, so it becomes effective' => 'この設定を有効にすると有効になります',
        'Enable' => '有効',
        'Reset this setting to its default state' => 'この設定をデフォルトのステータスにリセットする',
        'Reset setting' => 'リセット設定',
        'Allow users to adapt this setting from within their personal preferences' =>
            'ユーザーが個人設定内からこの設定を変更できるようにする。',
        'Allow users to update' => 'ユーザーに更新を許可する',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'ユーザーが個人設定からこの設定を変更するのを許可しないようにする。',
        'Forbid users to update' => 'ユーザーの更新を禁止する',
        'Show user specific changes for this setting' => 'この設定のユーザー固有の変更を表示する',
        'Show user settings' => 'ユーザー設定を表示する',
        'Copy a direct link to this setting to your clipboard' => 'この設定への直接リンクをクリップボードにコピーする',
        'Copy direct link' => 'ダイレクトリンクをコピーする',
        'Remove this setting from your favorites setting' => 'この設定をお気に入り設定から削除',
        'Remove from favourites' => 'お気に入りから削除',
        'Add this setting to your favorites' => 'お気に入りにこの設定を追加',
        'Add to favourites' => 'お気に入りに追加',
        'Cancel editing this setting' => 'この設定の編集をキャンセルする',
        'Save changes on this setting' => 'この設定の変更を保存する',
        'Edit this setting' => 'この設定を編集',
        'Enable this setting' => 'この設定を有効にする',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'このグループには設定が含まれていません。 サブグループの1つまたは別のグループに移動してみて下さい。',

        # Template: SettingsListCompare
        'Now' => '今',
        'User modification' => 'ユーザーの更新',
        'enabled' => '有効',
        'disabled' => '無効',
        'Setting state' => 'ステータスを設定します',

        # Template: Actions
        'Edit search' => '検索を修正',
        'Go back to admin: ' => '管理に戻る：',
        'Deployment' => 'デプロイ',
        'My favourite settings' => '私のお気に入りの設定',
        'Invalid settings' => '無効な設定',

        # Template: DynamicActions
        'Filter visible settings...' => '表示フィルタリングの設定をしています...',
        'Enable edit mode for all settings' => '全ての設定に対して編集モードを有効にする',
        'Save all edited settings' => '編集した全ての設定を保存する',
        'Cancel editing for all settings' => '全ての設定の編集をキャンセルする',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'このウィジェットからのすべてのアクションは、右の表示される設定にのみ適用されます。',

        # Template: Help
        'Currently edited by me.' => '現在私によって編集されています。',
        'Modified but not yet deployed.' => '変更されましたが、まだデプロイされていません。',
        'Currently edited by another user.' => '現在、別のユーザーが編集しています。',
        'Different from its default value.' => 'デフォルト値とは異なります。',
        'Save current setting.' => '現在の設定を保存します。',
        'Cancel editing current setting.' => '現在の設定の編集をキャンセルします。',

        # Template: Navigation
        'Navigation' => 'ナビゲーション',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'OTRS テストページ',
        'Unlock' => 'ロック解除',
        'Welcome %s %s' => 'ようこそ %s %s',
        'Counter' => 'カウンター',

        # Template: Warning
        'Go back to the previous page' => '前のページへ戻る',

        # JS Template: CalendarSettingsDialog
        'Show' => '表示',

        # JS Template: FormDraftAddDialog
        'Draft title' => '下書きタイトル',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '記事の表示',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '本当に"%s"を削除しますか？',
        'Confirm' => '確認',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '読み込み中です。お待ち下さい...',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select files or just drop them here.' => 'クリックしてファイルを選択するか、ここにドロップして下さい。',
        'Click to select a file or just drop it here.' => 'クリックしてファイルを選択するか、ここにドロップします。',
        'Uploading...' => 'アップロード中...',

        # JS Template: InformationDialog
        'Process state' => 'プロセス・ステータス',
        'Running' => '実行中',
        'Finished' => '終了しました',
        'No package information available.' => '利用可能なパッケージ情報はありません。',

        # JS Template: AddButton
        'Add new entry' => '新しい登録を追加',

        # JS Template: AddHashKey
        'Add key' => '鍵を追加',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'デプロイ・コメント...',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => 'デプロイしています。暫くお待ち下さい...',
        'Preparing to deploy, please wait...' => 'デプロイ中です。お待ち下さい...',
        'Deploy now' => '今すぐデプロイ',
        'Try again' => '再試行する',

        # JS Template: DialogReset
        'Reset options' => 'リセットオプション',
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
        'Database Backend' => 'データベース・バックエンド',
        'CustomerIDs' => '顧客ID',
        'Fax' => 'Fax',
        'Street' => '建物名',
        'Zip' => '郵便番号',
        'City' => '住所',
        'Country' => '国',
        'Valid' => '有効',
        'Mr.' => '様',
        'Mrs.' => '様',
        'Address' => 'アドレス',
        'View system log messages.' => 'システム・ログ・メッセージを見る。',
        'Edit the system configuration settings.' => 'システム設定の編集',
        'Update and extend your system with software packages.' => 'このシステムのソフトウェアパッケージの更新と展開',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'データベースから取得したACLの情報はシステム設定と同期していません。全てのACLをデプロイしてください。',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => '次のACLは、無事に追加されました。: %s',
        'The following ACLs have been updated successfully: %s' => '次のACLは、無事に更新されました。: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '次のACLを追加/更新するときにエラーが発生しました。: %s
詳細は、ログファイルを参照してください。',
        'This field is required' => 'このフィールドは必須です',
        'There was an error creating the ACL' => 'ACLデータの作成時にエラーが発生しました。',
        'Need ACLID!' => 'ACL IDの入力が必要です！',
        'Could not get data for ACLID %s' => 'ACL ID %s の値を取得できませんでした',
        'There was an error updating the ACL' => 'ACLの更新時にエラーが発生しました。',
        'There was an error setting the entity sync status.' => '',
        'There was an error synchronizing the ACLs.' => 'ACL間の同期処理中にエラーが発生しました。',
        'ACL %s could not be deleted' => 'ACL %s は削除できません',
        'There was an error getting data for ACL with ID %s' => '',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'スーパーユーザー・アカウント（UserID 1）ではACLの制限が無視されることに注意して下さい。',
        'Exact match' => '完全一致',
        'Negated exact match' => '完全に否定一致',
        'Regular expression' => '正規表現',
        'Regular expression (ignore case)' => '正規表現 (大文字・小文字を無視する)',
        'Negated regular expression' => '否定正規表現',
        'Negated regular expression (ignore case)' => '否定された正規表現（大文字と小文字を区別しない）',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'システムがカレンダーを作成できませんでした！',
        'Please contact the administrator.' => '管理者に連絡してください。',
        'No CalendarID!' => 'CalendarIDがない!',
        'You have no access to this calendar!' => 'あなたはこのカレンダーにアクセスできません！',
        'Error updating the calendar!' => 'カレンダーの更新中にエラーが発生しました!',
        'Couldn\'t read calendar configuration file.' => 'カレンダー設定ファイルを読み込めませんでした。',
        'Please make sure your file is valid.' => 'あなたのファイルが有効であることを確認して下さい。',
        'Could not import the calendar!' => 'カレンダーをインポートできませんでした!',
        'Calendar imported!' => 'カレンダーをインポート!',
        'Need CalendarID!' => 'CalendarIDが必要!',
        'Could not retrieve data for given CalendarID' => '指定されたCalendarIDのデータを取得できませんでした。',
        'Successfully imported %s appointment(s) to calendar %s.' => '%sの予定をカレンダー%sに正常にインポートしました。',
        '+5 minutes' => '+5分',
        '+15 minutes' => '+15分',
        '+30 minutes' => '+30分',
        '+1 hour' => '+1時間',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '権限がない!',
        'System was unable to import file!' => '',
        'Please check the log for more information.' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '',
        'Notification added!' => '通知が追加されました！',
        'There was an error getting data for Notification with ID:%s!' =>
            '',
        'Unknown Notification %s!' => '',
        '%s (copy)' => '',
        'There was an error creating the Notification' => '',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            '次の通知が正常に追加されました：%s',
        'The following Notifications have been updated successfully: %s' =>
            '次の通知が正常に更新されました：%s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Notification updated!' => '',
        'Agent (resources), who are selected within the appointment' => '予定内で選択された担当者（リソース）',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => '添付ファイルを追加しました。',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '自動応答が追加されました！',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => '全てのコミュニケーション',
        'Last 1 hour' => '過去1時間',
        'Last 3 hours' => '過去3時間',
        'Last 6 hours' => '過去6時間',
        'Last 12 hours' => '過去12時間',
        'Last 24 hours' => '過去24時間',
        'Last week' => '先週',
        'Last month' => '先月',
        'Invalid StartTime: %s!' => '',
        'Successful' => '成功',
        'Processing' => '処理中',
        'Failed' => '失敗',
        'Invalid Filter: %s!' => 'フィルターが不正です: %s',
        'Less than a second' => '1秒未満',
        'sorted descending' => '降順に並べ替え',
        'sorted ascending' => '昇順に並べ替え',
        'Trace' => 'トレース',
        'Debug' => 'Debug',
        'Info' => '情報',
        'Warn' => '警告',
        'days' => '日',
        'day' => '日',
        'hour' => '時間',
        'minute' => '分',
        'seconds' => '秒',
        'second' => '秒',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => '顧客企業を更新しました。',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => '顧客企業 %s は、既に存在します！',
        'Customer company added!' => '顧客企業を追加しました。',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => '顧客を更新しました。',
        'New phone ticket' => '新規電話チケットの作成',
        'New email ticket' => '新規メールチケットの作成',
        'Customer %s added' => '顧客 %s を追加しました',
        'Customer user updated!' => '顧客ユーザーが更新されました！',
        'Same Customer' => '同じ顧客',
        'Direct' => '直接',
        'Indirect' => '間接',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '顧客ユーザーをサービスに割り当てる',
        'Allocate Services to Customer User' => '',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '',
        'Objects configuration is not valid' => '',
        'Database (%s)' => 'データベース (%s)',
        'Web service (%s)' => 'Webサービス (%s)',
        'Contact with data (%s)' => 'データ接続 (%s)',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'ダイナミック・フィールドのオーダー定義を初期化できませんでした。詳細はエラーログを参照願います。',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '未定義のサブアクションです。',
        'Need %s' => '%s の入力が必要です。',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => 'ValidIDが必要です',
        'Could not create the new field' => '新しいフィールドを作成できませんでした。',
        'Need ID' => 'IDが必要',
        'Could not get data for dynamic field %s' => 'ダイナミック・フィールド %s の値を取得できませんでした',
        'Change %s field' => '',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => '現在の',
        'Unchecked' => '未選択',
        'Checked' => '選択済み',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '',
        'Prevent entry of dates in the past' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => '分',
        'hour(s)' => '時間',
        'Time unit' => '時間の単位',
        'within the last ...' => '以内(前)',
        'within the next ...' => '以内(後)',
        'more than ... ago' => '... 以前',
        'Unarchived tickets' => 'アーカイブされていないチケット',
        'archive tickets' => 'アーカイブ・チケット',
        'restore tickets from archive' => 'アーカイブからチケットを復元する',
        'Need Profile!' => 'プロファイルの入力が必要です！',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebサービスIDの入力が必要です！',
        'Could not get data for WebserviceID %s' => 'WebサービスID %s の値を取得できませんでした',
        'ascending' => '昇順',
        'descending' => '降順',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'コミュニケーション・タイプが必要です！',
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
        'Invoker deleted' => 'API実行元を削除',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0秒',
        '15 seconds' => '15秒',
        '30 seconds' => '30秒',
        '45 seconds' => '45秒',
        '1 minute' => '1分',
        '2 minutes' => '2分',
        '3 minutes' => '3分',
        '4 minutes' => '4分',
        '5 minutes' => '5分',
        '10 minutes' => '10 分',
        '15 minutes' => '15 分',
        '30 minutes' => '30分',
        '1 hour' => '1時間',
        '2 hours' => '2時間',
        '3 hours' => '3時間',
        '4 hours' => '4時間',
        '5 hours' => '5時間',
        '6 hours' => '6時間',
        '12 hours' => '12時間',
        '18 hours' => '18時間',
        '1 day' => '1日',
        '2 days' => '2日',
        '3 days' => '3日',
        '4 days' => '4日',
        '6 days' => '6日',
        '1 week' => '1週',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'API実行元%sの設定を判別できませんでした。',
        'InvokerType %s is not registered' => 'API実行元%sは登録されていません。',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'API実行元が必要です!',
        'Need Event!' => 'イベントが必要！',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => '',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => '文字列',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
        'Keep (leave unchanged)' => '保持 (変更せずに終了する)',
        'Ignore (drop key/value pair)' => '無視 (キー/値のペアを破棄する)',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '必要なライブラリ%sを見つけることができませんでした。',
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
        'Need valid Subaction!' => '有効なサブアクションが必要です!',
        'This field should be an integer.' => 'この領域は整数である必要があります。',
        'File or Directory not found.' => 'ファイルまたはディレクトリがみつかりません。',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '同名の別のWebサービスがあります。',
        'There was an error updating the web service.' => 'Webサービスの更新時にエラーが発生しました。',
        'There was an error creating the web service.' => 'Webサービスの作成時にエラーが発生しました。',
        'Web service "%s" created!' => 'Webサービス "%s" を作成しました。',
        'Need Name!' => '名前の入力が必要です！',
        'Need ExampleWebService!' => 'ExampleWebServiceが必要です！',
        'Could not load %s.' => '',
        'Could not read %s!' => '%s を読み込めません！',
        'Need a file to import!' => 'インポートするファイルを指定してください！',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '',
        'Web service "%s" deleted!' => 'Webサービス "%s" を削除しました。',
        'OTRS as provider' => 'プロバイダーとしてのOTRS',
        'Operations' => 'オペレーション',
        'OTRS as requester' => 'リクエスターとしてのOTRS',
        'Invokers' => 'API実行元',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'グループを更新しました。',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'メールアカウントを追加しました。',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'メールの宛先で振り分け',
        'Dispatching by selected Queue.' => '選択したキューで振り分け',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'チケットを作成した担当者',
        'Agent who owns the ticket' => 'チケットを保有する担当者',
        'Agent who is responsible for the ticket' => 'チケットの責任者',
        'All agents watching the ticket' => 'チケットを監視しているすべての担当者',
        'All agents with write permission for the ticket' => 'チケット編集可能権限を持つすべての担当者',
        'All agents subscribed to the ticket\'s queue' => 'チケットのキューを購読しているすべての担当者',
        'All agents subscribed to the ticket\'s service' => 'チケットのサービスを購読しているすべての担当者',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'チケットのキュー及びサービスを購読しているすべての担当者',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '最初の記事の全ての受信者',
        'All recipients of the last article' => '最後の記事の全ての受信者',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => 'システムは正常に%sにアップグレードされました。',
        'There was a problem during the upgrade to %s.' => '%sにアップグレード中に問題が発生しました。',
        '%s was correctly reinstalled.' => '%s は正常に再インストールされました',
        'There was a problem reinstalling %s.' => '%s をインストール中に問題が発生しました',
        'Your %s was successfully updated.' => '%sは正常に更新されました。',
        'There was a problem during the upgrade of %s.' => '%sのアップグレード中に問題が発生しました。',
        '%s was correctly uninstalled.' => '%sは正常にアンインストールされました。',
        'There was a problem uninstalling %s.' => '%sのアンインストール時に問題が発生しました。',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP 機構が動作していません。詳しくはログをご覧ください！',
        'Need param Key to delete!' => '削除するには、キーを入力する必要があります！',
        'Key %s deleted!' => 'キー %s を削除しました。',
        'Need param Key to download!' => 'ダウンロードを行うには、キーを入力する必要があります！',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '',
        'No such package!' => 'そのようなパッケージはありません！',
        'No such file %s in package!' => 'パッケージ内にファイル %s はありません！',
        'No such file %s in local file system!' => 'ローカルファイルシステム内にファイル %s はありません！',
        'Can\'t read %s!' => '%s を読み込めません！',
        'File is OK' => 'ファイルは正常です',
        'Package has locally modified files.' => 'パッケージにはローカルに変更されたファイルがあります。',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'パッケージはOTRSグループによって検証されていません。このパッケージの利用を推奨しません。',
        'Not Started' => '始まっていない',
        'Updated' => '更新しました',
        'Already up-to-date' => 'すでに最新版です。',
        'Installed' => 'インストールしました',
        'Not correctly deployed' => '正しくデプロイされませんでした',
        'Package updated correctly' => 'パッケージの更新は正常に終了しました。',
        'Package was already updated' => 'パッケージはすでに更新済みです。',
        'Dependency installed correctly' => '依存するモジュールは正常にインストールされました。',
        'The package needs to be reinstalled' => 'パッケージを再インストールする必要があります',
        'The package contains cyclic dependencies' => 'このパッケージとの依存関係が循環状態にあります。',
        'Not found in on-line repositories' => 'オンライン・リポジトリからは見つかりませんでした。',
        'Required version is higher than available' => '現在お使いのものより新しいバージョンが必要です。',
        'Dependencies fail to upgrade or install' => '依存関係解消のためのインストールまたは更新に失敗しました。',
        'Package could not be installed' => 'パッケージをインストールできませんでした',
        'Package could not be upgraded' => 'パッケージを更新できませんでした',
        'Repository List' => 'リポジトリ・リスト',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            '',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'OTRSアドオンリストサーバーに接続できませんでした！',
        'Can\'t get OTRS Feature Add-on list from server!' => 'OTRS アドオンリストをサーバーから取得できませんでした！',
        'Can\'t get OTRS Feature Add-on from server!' => 'OTRS アドオンをサーバーから取得できませんでした！',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'そのようなフィルターはありません: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => '優先度を追加しました。',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'データベースから取得したプロセス管理情報はシステム設定と同期していません。全てのプロセスを同期させてください。',
        'Need ExampleProcesses!' => 'プロセス例が必要!',
        'Need ProcessID!' => 'ProcessIDが必要!',
        'Yes (mandatory)' => '',
        'Unknown Process %s!' => '',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => '非アクティブなステータスのStateEntityIDは存在しません',
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
        'Could not get %s' => '%sの値が取得できません!',
        'Need %s!' => '%s の入力が必要です!',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => 'ActivityIDが必要!',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => 'Activityが見つかりません!',
        'ActivityDialog not found!' => 'ActivityDialogが見つかりません!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => 'このサブアクションは有効ではありません',
        'Edit Activity "%s"' => 'アクティビティ "%s" を編集',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => 'アクティビティ・ダイアログを作成する際にエラーが発生しました',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => 'アクティビティ・ダイアログIDが必要です！',
        'Could not get data for ActivityDialogID %s' => 'アクティビティ・ダイアログID %s の値を取得できませんでした',
        'There was an error updating the ActivityDialog' => 'アクティビティ・ダイアログの更新時にエラーが発生しました。',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => '担当者インターフェース',
        'Customer Interface' => '顧客インターフェース',
        'Agent and Customer Interface' => '担当者と顧客のインターフェース',
        'Do not show Field' => 'フィールドを表示しない',
        'Show Field' => 'フィールドを表示する',
        'Show Field As Mandatory' => 'フィールドを必須として表示する',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'パスを修正',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'この遷移にエンティティIDを割り当てる際にエラーが発生しました。',
        'There was an error creating the Transition' => '遷移の作成時にエラーが発生しました。',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '遷移IDの入力が必要です！',
        'Could not get data for TransitionID %s' => '遷移ID %s の値を取得できませんでした',
        'There was an error updating the Transition' => '遷移の更新時にエラーが発生しました。',
        'Edit Transition "%s"' => '遷移 "%s" を編集する',
        'Transition validation module' => '遷移有効化モジュール',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'この遷移動作にエンティティID割り当てる際にエラーが発生しました',
        'There was an error creating the TransitionAction' => '遷移動作の作成時にエラーが発生しました。',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '遷移動作IDを入力してください！',
        'Could not get data for TransitionActionID %s' => '遷移アクションID %s の値を取得できませんでした',
        'There was an error updating the TransitionAction' => '遷移動作の更新時にエラーが発生しました。',
        'Edit Transition Action "%s"' => '遷移動作 "%s" の編集',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'キューを更新しました。',
        'Don\'t use :: in queue name!' => 'キューの名称に"::"を使わないでください！',
        'Click back and change it!' => 'クリックして変更してください！',
        '-none-' => '-なし-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '自動応答が設定されていないキュー',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'テンプレートに対するキューの関連性を変更',
        'Change Template Relations for Queue' => 'キューに対するテンプレートの関連性を変更',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '生産',
        'Test' => 'テスト',
        'Training' => 'トレーニング',
        'Development' => 'デプロイ',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'ロールを更新しました。',
        'Role added!' => 'ロールを追加しました。',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'ロールに対するグループの関連性を変更',
        'Change Role Relations for Group' => 'グループに対するロールの関連性を変更',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'ロール',
        'Change Role Relations for Agent' => '担当者に対するロールの関連性を変更',
        'Change Agent Relations for Role' => 'ロールに対する担当者の関連性を変更',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => '最初に %s を有効にしてください。',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME環境は動作していません。ログを確認して下さい！',
        'Need param Filename to delete!' => '削除するにはパラメータとしてファイル名が必要です！',
        'Need param Filename to download!' => 'ダウンロードするにはパラメータとしてファイル名が必要です！',
        'Needed CertFingerprint and CAFingerprint!' => '認証局のフィンガープリントとCA局のフィンガープリントが必要です！',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => '関係が存在します！',
        'Relation added!' => '関係が追加されました！',
        'Impossible to add relation!' => '関係を追加することはできません！',
        'Relation doesn\'t exists' => '関係は存在しません',
        'Relation deleted!' => '関係が削除されました！',
        'Impossible to delete relation!' => '関係を削除することはできません！',
        'Certificate %s could not be read!' => '証明書 %s を読み込めませんでした！',
        'Needed Fingerprint' => 'フィンガープリントが必要です',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '挨拶文を追加しました！',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => '署名を更新しました。',
        'Signature added!' => '署名を追加しました。',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'ステータスを追加しました。',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'ファイル %s を読み込めませんでした！',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'システムメールアドレスを追加しました。',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '無効な設定',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'インポートは許可されていません!',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            '',
        'Category Search' => 'カテゴリ検索',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '設定名がありません！',
        'Missing ResetOptions!' => 'リセット・オプションが不足しています！',
        'Setting is locked by another user!' => '設定は他のユーザーによってロックされています！',
        'System was not able to lock the setting!' => 'システムは設定をロックできませんでした！',
        'System was not able to reset the setting!' => 'システムが設定をリセットできませんでした！',
        'System was unable to update setting!' => 'システムが設定を更新できませんでした！',
        'Missing setting name.' => '設定名がありません。',
        'Setting not found.' => '設定が見つかりません。',
        'Missing Settings!' => '設定がありません！',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '停止日の後に開始日を定義しないで下さい！',
        'There was an error creating the System Maintenance' => 'システムメンテナンスを作成する際にエラーが発生しました',
        'Need SystemMaintenanceID!' => 'システムメンテナンスIDが必要です',
        'Could not get data for SystemMaintenanceID %s' => 'システムメンテナンスID  %sから日付を取得できませんでした',
        'System Maintenance was added successfully!' => 'システムメンテナンスが正常に追加されました！',
        'System Maintenance was updated successfully!' => 'システムメンテナンスが正常に更新されました！',
        'Session has been killed!' => 'セッションは削除されました！',
        'All sessions have been killed, except for your own.' => '貴方自身のセッション以外のセッションは切断されました。',
        'There was an error updating the System Maintenance' => 'システムメンテナンス更新時にエラーが発生しました',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'システムメンテナンス %sは削除できませんでした！',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'テンプレートを更新しました！',
        'Template added!' => 'テンプレートを追加しました！',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'テンプレートに対する添付ファイルの関連性を変更',
        'Change Template Relations for Attachment' => '添付ファイルに対するテンプレートの関連性を変更',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'タイプが必要です！',
        'Type added!' => 'タイプを追加しました。',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => '担当者が更新されました。',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => '担当者に対するグループの関連性を変更',
        'Change Agent Relations for Group' => 'グループに対する担当者の関連性を変更',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => '月',
        'Week' => '週',
        'Day' => '日',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '全ての予約',
        'Appointments assigned to me' => '私に割り当てられた予定',
        'Showing only appointments assigned to you! Change settings' => 'あなたに割り当てられた予約だけを表示する！ 設定を変更して下さい。',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '予約が見つかりません！',
        'Never' => 'なし',
        'Every Day' => '毎日',
        'Every Week' => '毎週',
        'Every Month' => '毎月',
        'Every Year' => '毎年',
        'Custom' => 'カスタム',
        'Daily' => '毎日',
        'Weekly' => '毎週',
        'Monthly' => '毎月',
        'Yearly' => '毎年',
        'every' => '全て',
        'for %s time(s)' => 'for %s time(s)',
        'until ...' => '〜まで',
        'for ... time(s)' => 'for ... time(s)',
        'until %s' => '%s まで',
        'No notification' => '通知なし',
        '%s minute(s) before' => '%s 分前',
        '%s hour(s) before' => '%s 時間前',
        '%s day(s) before' => '%s 日前',
        '%s week before' => '%s 週間前',
        'before the appointment starts' => '予定の開始前',
        'after the appointment has been started' => '予定の開始後',
        'before the appointment ends' => '予定の終了前',
        'after the appointment has been ended' => '予定の終了後',
        'No permission!' => '権限がない!',
        'Cannot delete ticket appointment!' => 'チケット予約を削除できません！',
        'No permissions!' => '権限がない!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => '顧客履歴',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '設定項目 %s は存在しません',
        'Statistic' => 'レポート',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => '顧客名',
        'Customer User Name' => '顧客ユーザー名',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'ソース・オブジェクトとソース・キーが必要です！',
        'You need ro permission!' => 'ro許可が必要です！',
        'Can not delete link with %s!' => '%sに対するリンクが削除できませんでした！',
        '%s Link(s) deleted successfully.' => '%sリンク(複数)が正常に削除されました。',
        'Can not create link with %s! Object already linked as %s.' => 'オブジェクト%sに対するリンクを作成できませんでした！ %sに対するリンクが既に存在します。',
        'Can not create link with %s!' => '%sに対するリンクが作成できませんでした！',
        '%s links added successfully.' => '%sリンクが正常に追加されました。',
        'The object %s cannot link with other object!' => 'オブジェクト%sは他のオブジェクトにリンクできません！',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'パラメータ Groupが必要です！',
        'Updated user preferences' => 'ユーザー設定を更新しました',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '設定が見つかりません！',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'プロセスチケット',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'パラメータ %sが存在しません。',
        'Invalid Subaction.' => '不正なサブアクションです。',
        'Statistic could not be imported.' => 'レポートをインポートできませんでした。',
        'Please upload a valid statistic file.' => '有効なレポート・ファイルをアップロードして下さい。',
        'Export: Need StatID!' => 'エクスポート: StatIDが必要です！',
        'Delete: Get no StatID!' => '削除: StatIDが存在しません！',
        'Need StatID!' => 'StatIDが必要です！',
        'Could not load stat.' => '統計を読み込めませんでした。',
        'Add New Statistic' => '新しいレポートを追加',
        'Could not create statistic.' => 'レポートを作成できませんでした。',
        'Run: Get no %s!' => '実行: %sが存在しません！',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'TicketIDが存在しません！',
        'You need %s permissions!' => '許可 %sが必要です！',
        'Loading draft failed!' => '下書きのロードに失敗しました！',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'この操作を行うには担当者または責任者になる必要があります。',
        'Please change the owner first.' => '最初に担当者を変更してください。',
        'FormDraft functionality disabled!' => 'Form下書き機能が無効になっています！',
        'Draft name is required!' => '下書き名は必須です！',
        'FormDraft name %s is already in use!' => 'FormDraft名%sは既に使用中です！',
        'Could not perform validation on field %s!' => '',
        'No subject' => '件名なし',
        'Could not delete draft!' => '下書きを削除できませんでした。',
        'Previous Owner' => '以前の所有者',
        'wrote' => 'wrote',
        'Message from' => 'Message from',
        'End message' => 'End message',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%sが必要です！',
        'Plain article not found for article %s!' => '%sの記事では一般的な記事が見つかりません！',
        'Article does not belong to ticket %s!' => '記事はチケット%sに属していません！',
        'Can\'t bounce email!' => 'メールをバウンスできません！',
        'Can\'t send email!' => 'メールを送信できません！',
        'Wrong Subaction!' => '不正なサブアクションです！',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'チケットIDが存在しないため、チケットをロックできませんでした！',
        'Ticket (%s) is not unlocked!' => 'チケット(%s)はアンロックされていません！',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '少なくとも1件のチケットを選択する必要があります。',
        'Bulk feature is not enabled!' => '一括機能が有効になっていません！',
        'No selectable TicketID is given!' => '選択可能なチケットIDが存在しません！',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'チケットを選択していないか、他の担当者によってロックされているチケットしか選択していません。',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'アドレス %s は登録された顧客のアドレスに置換されました。',
        'Customer user automatically added in Cc.' => '顧客ユーザーが自動的にCcに追加されました。',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'チケット "%s" を作成しました。',
        'No Subaction!' => 'サブアクションが存在しません！',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'チケットIDが取得できませんでした！',
        'System Error!' => 'システム・エラー！',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'ArticleIDは指定されていません！',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => '翌週',
        'Ticket Escalation View' => 'チケット・エスカレーション・ビュー',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '記事%sが見つかりませんでした！',
        'Forwarded message from' => 'Forwarded message from',
        'End forwarded message' => 'End forwarded message',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'チケットIDが与えられていないため、履歴を表示できませんでした',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'チケットIDが与えられていないため、ロックできませんでした',
        'Sorry, the current owner is %s!' => '現在の所有者は%sです！',
        'Please become the owner first.' => '先に所有者となる必要があります。',
        'Ticket (ID=%s) is locked by %s!' => 'チケット(ID=%s)は%sによってロックされています！',
        'Change the owner!' => '所有者の変更！',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => '新しい記事',
        'Pending' => '保留中',
        'Reminder Reached' => '保留期限切れ',
        'My Locked Tickets' => '担当のロック済チケット',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'チケットは自分自身に対して結合することはできません！',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'move許可が必要です！',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'チャットはアクティブではありません。',
        'No permission.' => '権限がありません！',
        '%s has left the chat.' => '%s はチャットから退出しました。',
        'This chat has been closed and will be removed in %s hours.' => 'このチャットは既にクローズしています。%s 時間後に削除されます。',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'チケットがロックされました。',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '記事IDが存在しません！',
        'This is not an email article.' => 'これは電子メールの記事ではありません。',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'チケットID の入力してください！',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => 'プロセスが作成されていません！',
        'The selected process is invalid!' => '選択されたプロセスは正しくありません。',
        'Process %s is invalid!' => 'プロセス %sは不正です！',
        'Subaction is invalid!' => 'サブアクションが不正です！',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'ActivityEntityIDを特定できませんでした。 ダイナミック・フィールドまたはコンフィグが正しく設定されていません。',
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
        'Pending Date' => '保留期間',
        'for pending* states' => 'ステータス:保留にする',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID が入力されていません！',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '非表示フィールドとして顧客IDを使用できませんでした。',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'ProcessEntityID "%s" を TicketID "%s" に設定できませんでした！',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'ActivityEntityID "%s" を TicketID "%s" に設定できませんでした！',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => 'チケット %s の ActivityEntityID が入力されていません！',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => 'チケット %sの ProcessEntityID が入力されていません！',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'ActivityDialog "％s"のID "％s"を持つチケットの％sのダイナミック・フィールドの値を設定できませんでした！',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'ActivityDialog "%s"にID "%s"のチケットのPendingTimeを設定できませんでした！',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => 'Process::Default%s のデフォルト値が未指定となっています！',
        'Default Config for Process::Default%s invalid!' => 'Process::Default%s のデフォルト値が未指定となっています！',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => '利用可能チケット',
        'including subqueues' => 'サブキューを含む',
        'excluding subqueues' => 'サブキューを除く',
        'QueueView' => 'キュー・ビュー',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => '担当の責任者チケット',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => '最終検索',
        'Untitled' => '',
        'Ticket Number' => 'チケット番号',
        'Ticket' => 'チケット',
        'printed by' => 'printed by',
        'CustomerID (complex search)' => '顧客ID (複合検索)',
        'CustomerID (exact match)' => '顧客ID (完全一致)',
        'Invalid Users' => '無効なユーザー',
        'Normal' => '標準',
        'CSV' => 'CSV',
        'Excel' => 'エクセル',
        'in more than ...' => '以後',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',
        'Service View' => 'サービス・ビュー',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'ステータス・ビュー',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => '担当の監視チケット',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'リンクが削除されました',
        'Ticket Locked' => 'チケットがロックされました',
        'Pending Time Set' => '保留時間を設定',
        'Dynamic Field Updated' => 'ダイナミック・フィールドを更新しました',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'チケット作成済み',
        'Type Updated' => 'タイプが更新されました',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => 'エスカレーション更新期限タイマーが停止されました',
        'Escalation First Response Time Stopped' => 'エスカレーション初回応答期限タイマーが停止されました',
        'Customer Updated' => '顧客が更新されました',
        'Internal Chat' => '内部チャット',
        'Automatic Follow-Up Sent' => '自動フォローアップの送信',
        'Note Added' => '注釈作成済み',
        'Note Added (Customer)' => '注釈作成済み(顧客)',
        'SMS Added' => '追加されたSMS',
        'SMS Added (Customer)' => '追加されたSMS（顧客）',
        'State Updated' => 'ステータスが更新されました',
        'Outgoing Answer' => '回答',
        'Service Updated' => 'サービスが更新されました',
        'Link Added' => 'リンクが追加されました',
        'Incoming Customer Email' => '顧客からのメール',
        'Incoming Web Request' => '受信Webリクエスト',
        'Priority Updated' => '優先度が更新されました',
        'Ticket Unlocked' => 'チケットのロックが解除されました',
        'Outgoing Email' => '送信メール',
        'Title Updated' => 'タイトルが更新されました',
        'Ticket Merged' => 'チケットが結合されました',
        'Outgoing Phone Call' => '架電',
        'Forwarded Message' => '転送されたメッセージ',
        'Removed User Subscription' => '削除されたユーザーサブスクリプション',
        'Time Accounted' => 'アカウンテッドタイム',
        'Incoming Phone Call' => '入電',
        'System Request.' => 'システム要求',
        'Incoming Follow-Up' => 'フォローアップがあります',
        'Automatic Reply Sent' => '自動返信送信',
        'Automatic Reject Sent' => '自動拒否送信済み',
        'Escalation Solution Time In Effect' => 'エスカレーションソリューションの有効期間',
        'Escalation Solution Time Stopped' => 'エスカレーション解決期限タイマーが停止されました',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => 'エスカレーション応答期限タイマーが停止されました',
        'SLA Updated' => 'SLA 更新済み',
        'External Chat' => '外部チャット',
        'Queue Changed' => 'キューが変更されました',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => 'FormDraftIDがありません！',
        'Can\'t get for ArticleID %s!' => 'ArticleID%sを取得できません！',
        'Article filter settings were saved.' => '記事フィルタの設定が保存されました。',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => 'ArticleIDが必要です！',
        'Invalid ArticleID!' => 'ArticleIDが無効です！',
        'Forward article via mail' => 'メール経由で記事を転送',
        'Forward' => '転送',
        'Fields with no group' => '',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',
        'Show one article' => '一つの記事を閲覧',
        'Show all articles' => '全ての記事を閲覧',
        'Show Ticket Timeline View' => '',
        'Show Ticket Timeline View (%s)' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'HTML body attachment is missing!' => 'HTMLボディの添付ファイルがありません！',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileIDとArticleIDが必要です！',
        'No such attachment (%s)!' => 'そのような添付ファイル( %s )はありません！',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '%s::QueueDefault の設定値をご確認ください。',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '%s::TicketTypeDefault の設定値をご確認ください。',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '顧客IDの入力が必要です！',
        'My Tickets' => '担当チケット',
        'Company Tickets' => '企業チケット',
        'Untitled!' => '無題！',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '顧客ユーザの氏名',
        'Created within the last' => '以内に作成された',
        'Created more than ... ago' => '以前に作成された',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'このキューにあるチケットは再オープンできません！',
        'Create a new ticket!' => '新規チケットを作成！',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureModeが有効です！',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => 'ディレクトリ "%s" は存在しません！',
        'Configure "Home" in Kernel/Config.pm first!' => 'まず、 ”Kernel/Config.pm” ファイルの "Home" を設定してください！',
        'File "%s/Kernel/Config.pm" not found!' => '"%s/Kernel/Config.pm" ファイルが見つかりません！',
        'Directory "%s" not found!' => 'ディレクトリ "%s" が見つかりません！',
        'Install OTRS' => 'OTRSをインストール',
        'Intro' => 'イントロ',
        'Kernel/Config.pm isn\'t writable!' => '"Kernel/Config.pm" ファイルに書き込み権限がありません！',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'インストーラーをご利用の場合は、”Kernel.Config.pm” ファイルにWebサーバ実行ユーザによる書き込み権限を付与してください！',
        'Database Selection' => 'データベース選択',
        'Unknown Check!' => '原因不明な障害です！',
        'The check "%s" doesn\'t exist!' => 'チェック "%s"は存在しません！',
        'Enter the password for the database user.' => 'データベースユーザーのパスワードを入力してください。',
        'Database %s' => 'データベース %s',
        'Configure MySQL' => 'MySQLの設定',
        'Enter the password for the administrative database user.' => '管理権限を持つデータベースユーザーのパスワードを入力してください。',
        'Configure PostgreSQL' => 'PostgreSQLの設定',
        'Configure Oracle' => 'Oracleの設定',
        'Unknown database type "%s".' => '"%s"は不明なデータベース形式です。',
        'Please go back.' => '戻って下さい。',
        'Create Database' => 'データベース作成',
        'Install OTRS - Error' => 'OTRSをインストール － エラーが発生しました',
        'File "%s/%s.xml" not found!' => 'ファイル "%s/%s.xml" が見つかりません！',
        'Contact your Admin!' => '管理者に連絡してください！',
        'System Settings' => 'システム設定',
        'Syslog' => 'シスログ',
        'Configure Mail' => 'メール設定',
        'Mail Configuration' => 'メール設定',
        'Can\'t write Config file!' => '設定ファイルに書き込み出来ません！',
        'Unknown Subaction %s!' => '不明なサブアクション%s！',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Perlモジュール DBD::%sがインストールされていないため、DBに接続できませんでした。',
        'Can\'t connect to database, read comment!' => 'データベースに接続できません、コメントを読んで下さい！',
        'Database already contains data - it should be empty!' => '既にデータベースにデータが含まれている場合、空にしなければなりません。',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'innodb_log_file_sizeの設定を少なくとも%s MB以上にしてください(現在: %s MB, 推奨: %s MB)。詳細は%sを参照して下さい。',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '%sがありません！',
        'No such user!' => 'そのようなユーザーはありません！',
        'Invalid calendar!' => '無効なカレンダー',
        'Invalid URL!' => '無効なURL',
        'There was an error exporting the calendar!' => 'カレンダーのエクスポート中にエラーが発生しました。',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Package::RepositoryAccessRegExp の設定が必要です',
        'Authentication failed from %s!' => '%s からの認証が失敗しました！',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => '異なるメールアドレスに記事をバウンス',
        'Bounce' => 'バウンス',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => '全員に返信',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'この記事を再送信',
        'Resend' => '再送信',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'この記事のメッセージログの詳細を表示する。',
        'Message Log' => 'メッセージ・ログ',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'メモに返信',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'この記事を分割',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'この記事の原文を参照する',
        'Plain Format' => '書式なし',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'この記事を印刷',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'sales@otrs.comまでご連絡下さい。',
        'Get Help' => 'ヘルプを得る',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'マーク',
        'Unmark' => 'マーク解除',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => 'OTRS Business Solution™ にアップグレードします。',
        'Re-install Package' => 'パッケージを再インストールする',
        'Upgrade' => 'アップグレード',
        'Re-install' => '再インストール',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => '暗号化済',
        'Sent message encrypted to recipient!' => '',
        'Signed' => '署名済',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '不正な\'PGP SIGNED MESSAGE\'ヘッダが見つかりました！',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '不正な \'S/MIME SIGNED MESSAGE\'ヘッダが見つかりました！',
        'Ticket decrypted before' => '復号前のチケット',
        'Impossible to decrypt: private key for email was not found!' => 'このメールに対応する秘密鍵が存在しないため、復号できませんでした。',
        'Successful decryption' => '復号に成功しました',

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
        'Sign' => '署名',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => '表示',
        'Refresh (minutes)' => '更新 (分)',
        'off' => 'オフ',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '顧客ユーザーを表示',
        'Offline' => 'オフライン',
        'User is currently offline.' => 'ユーザーは現在オフラインです。',
        'User is currently active.' => 'ユーザーは現在活動中です。',
        'Away' => '離席',
        'User was inactive for a while.' => 'ユーザーはしばらくインアクティブです',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => 'OTRSニュースサーバーに接続できませんでした！',
        'Can\'t get OTRS News from server!' => 'OTRS Newsをサーバから取得できませんでした！',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '製品ニュースサーバーに接続できませんでした！',
        'Can\'t get Product News from server!' => '製品ニュースをサーバーから取得できませんでした！',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '%sに接続できませんでした！',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'チケットを表示',
        'Shown Columns' => '列を表示',
        'filter not active' => 'フィルターは有効化されていません',
        'filter active' => 'フィルターを有効化',
        'This ticket has no title or subject' => 'このチケットにはタイトルもしくはテーマが入力されていません',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '週間統計',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '利用できません',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'スタンダード',
        'The following tickets are not updated: %s.' => '',
        'h' => '時間',
        'm' => '分',
        'd' => '日',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'これは',
        'email' => 'メール',
        'click here' => 'ここをクリック',
        'to open it in a new window.' => '新規ウィンドウを開く',
        'Year' => '年',
        'Hours' => '時間',
        'Minutes' => '分',
        'Check to activate this date' => 'この日付を活性化する場合はチェック',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => '権限がありません。',
        'No Permission' => '権限がありません',
        'Show Tree Selection' => 'ツリーセレクターを表示する',
        'Split Quote' => '見積を分割',
        'Remove Quote' => '見積を削除',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'リンク先',
        'Search Result' => '検索結果',
        'Linked' => 'リンク済',
        'Bulk' => '一括',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'ライト',
        'Unread article(s) available' => '未読の記事があります',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '予約',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'アーカイブの検索',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => 'クラウドサービスを利用して、OTRSのすべての機能を活用しましょう！',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s は %sに更新されました！ %s',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'あなたの %s のライセンスはもうすぐ失効します。　 %s にお問い合わせいただき更新を行ってください。',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            ' %s のアップデートが利用可能です。しかしあなたのフレームワークのバージョンとコンフリクトしていますので、事前にフレームワークの更新を行ってください。',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'オンラインの担当者: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => '更にエスカレーションされたチケットがあります。',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'このボタンをクリックして、あなたのプレファレンスにタイムゾーンを選択して下さい。',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'オンラインの顧客: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'OTRSデーモンが起動していません。',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            '外出中が有効になっています。無効にしますか？',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'デプロイされていない設定があります。デプロイしますか？',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '設定は更新されておりますので、ご安心ください。',
        'There is an error updating the system configuration!' => 'システム設定の更新時にエラーが発生しました。',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '%sの利用は、スーパーユーザー・アカウント（UserID 1）を使用しないで下さい！ 新しい担当者を作成し、そのアカウントで作業して下さい。',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',
        'Preferences updated successfully!' => '個人設定を更新しました',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(処理中)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => '現在のパスワード',
        'New password' => '新しいパスワード',
        'Verify password' => '新しいパスワード(確認用)',
        'The current password is not correct. Please try again!' => 'パスワードが正しくありません。再入力してください。',
        'Please supply your new password!' => '新しいパスワードを入力して下さい！',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'パスワードを更新できません。新しいパスワードが一致しません。再入力してください。',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'パスワードを更新できません。%s文字以上必要です。',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'パスワードを更新できません。英語の大文字小文字がそれぞれ2文字ずつ以上必要です。',
        'Can\'t update password, it must contain at least 1 digit!' => 'パスワードを更新できません。数字が1文字以上必要です。',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'パスワードを更新できません。アルファベットが2文字以上必要です。',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'タイムゾーンが正常に更新されました！',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => '無効',
        'valid' => '有効',
        'No (not supported)' => 'いいえ(サポートされていません)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '現在選択されているタイム・スケールの値にX軸のタイム・スケールの値は利用できません。',
        'The selected date is not valid.' => '選択した日付は不正です。',
        'The selected end time is before the start time.' => '選択した終了時刻は開始時刻より前です。',
        'There is something wrong with your time selection.' => '時刻の選択が間違っています。',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => 'X軸の要素を1つ選択してください。',
        'You can only use one time element for the Y axis.' => 'Y軸には時刻の要素は1つだけ指定可能です。',
        'You can only use one or two elements for the Y axis.' => 'Y軸には1つもしくは2つの要素が指定可能です。',
        'Please select at least one value of this field.' => '少なくとも値を1つは選択して下さい。',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => 'タイム・スケールを選択してください',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'レポートする間隔が小さすぎます。間隔をあけてください。',
        'second(s)' => '秒',
        'quarter(s)' => '四半期',
        'half-year(s)' => '半期',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'この設定の編集をキャンセルしてアンロックする',
        'Reset this setting to its default value.' => 'この設定をデフォルトの値にリセットする',
        'Unable to load %s!' => '%sを読み込めません！',
        'Content' => '内容',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'キューに戻すためチケットをロック解除',
        'Lock it to work on it' => '作業するためチケットをロック',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => '監視解除',
        'Remove from list of watched tickets' => '監視チケットリストから削除',
        'Watch' => '監視',
        'Add to list of watched tickets' => '監視チケットリストに追加',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => '順序',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'チケット情報',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'ロック済チケット新規',
        'Locked Tickets Reminder Reached' => 'ロック済チケット時間切れ',
        'Locked Tickets Total' => 'ロック済チケット合計',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => '責任者チケット新規',
        'Responsible Tickets Reminder Reached' => '責任者チケット時間切れ',
        'Responsible Tickets Total' => '責任者チケット合計',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => '監視チケット新規',
        'Watched Tickets Reminder Reached' => '監視チケット時間切れ',
        'Watched Tickets Total' => '監視チケット合計',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'チケットのダイナミック・フィールド',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '予定されていたメンテナンスのため、只今の時間はログインを行うことができません。',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => 'セッション数の上限に近づいていますのでご注意ください。',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '同時接続ユーザ数の上限に達したため、ログインできませんでした。sales@otrs.comに連絡してください。',
        'Session limit reached! Please try again later.' => 'セッション数が上限に達しました。後で再ログインを試みてください。',
        'Session per user limit reached!' => 'ユーザあたりのセッション数の上限に到達しました！',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'セッションが無効です。再ログインしてください。',
        'Session has timed out. Please log in again.' => 'セッションがタイムアウトしました。再ログインしてください。',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'PGP署名のみ',
        'PGP encrypt only' => 'PGP暗号化のみ',
        'SMIME sign only' => 'SMIME署名のみ',
        'SMIME encrypt only' => 'SMIME暗号化のみ',
        'PGP and SMIME not enabled.' => 'PGPとSMIMEが有効化されていません。',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '署名せずに通知を送信',
        'Send unencrypted notification' => '暗号化せずに通知を送信',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '構成オプションリファレンス',
        'This setting can not be changed.' => 'この設定を変更することは出来ません。',
        'This setting is not active by default.' => 'この設定は標準では有効ではありません。',
        'This setting can not be deactivated.' => 'この設定は無効化することはできません。',
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
        'before/after' => '前／後',
        'between' => '期間中',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '例: Text または Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'この領域は必須です。または、',
        'The field content is too long!' => 'その領域の内容が長すぎます。',
        'Maximum size is %s characters.' => '最大サイズは%s文字です。',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '未インストール',
        'installed' => 'インストール済',
        'Unable to parse repository index document.' => 'リポジトリインデックスドキュメントを解析できません。',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'このリポジトリ中でご利用のフレームワークのバージョンに対するパッケージが見つかりません。他のフレームワークのバージョンに対するパッケージのみ含まれます。',
        'File is not installed!' => 'ファイルがインストールされていません！',
        'File is different!' => '',
        'Can\'t read file!' => 'ファイルを読み込めません！',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '<p>このパッケージのインストールを継続すると、以下の問題が発生するかもしれません。</p><ul><li>&nbsp;-セキュリティ上の問題</li><li>&nbsp;-安定性の問題</li><li>&nbsp;-パフォーマンスの問題</li></ul><p>このパッケージを動作させることによって引き起こされた問題はOTRSサービス契約の対象外ですのでご注意ください。</p>',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => '無効',
        'FadeAway' => '未使用',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '登録サーバに接続できません。しばらくしてから再試行してください。',
        'No content received from registration server. Please try again later.' =>
            '登録サーバから受信した内容がありません。しばらくしてから再試行してください。',
        'Can\'t get Token from sever' => 'サーバーからトークンを取得できませんでした',
        'Username and password do not match. Please try again.' => 'ユーザー名とパスワードが一致しません。再試行してください。',
        'Problems processing server result. Please try again later.' => 'サーバから受信した内容を処理しているときに問題が発生しました。再試行してください。',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '合計',
        'week' => '週',
        'quarter' => '四半期',
        'half-year' => '半期',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'ステータス・タイプ',
        'Created Priority' => '作成時の優先度',
        'Created State' => '作成されたステータス',
        'Create Time' => '作成日時',
        'Pending until time' => 'ある時間まで保留中',
        'Close Time' => 'クローズ時間',
        'Escalation' => 'エスカレーション',
        'Escalation - First Response Time' => 'エスカレーション - 第1の応答時間',
        'Escalation - Update Time' => 'エスカレーション - 更新期限',
        'Escalation - Solution Time' => 'エスカレーション - 解決時間',
        'Agent/Owner' => '担当者／所有者',
        'Created by Agent/Owner' => '作成した担当者／所有者',
        'Assigned to Customer User Login' => '顧客ユーザログインに割り当てられました。',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => '評価',
        'Ticket/Article Accounted Time' => 'チケット／記事の作業時間',
        'Ticket Create Time' => 'チケット作成日時',
        'Ticket Close Time' => 'チケット・クローズ時間',
        'Accounted time by Agent' => '担当者の作業時間',
        'Total Time' => '合計時間',
        'Ticket Average' => 'チケット平均',
        'Ticket Min Time' => 'チケット最少時間',
        'Ticket Max Time' => 'チケット最大時間',
        'Number of Tickets' => 'チケットの数',
        'Article Average' => '記事平均',
        'Article Min Time' => '記事最少時間',
        'Article Max Time' => '記事最大時間',
        'Number of Articles' => '記事の数',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '無制限',
        'Attributes to be printed' => '印刷する属性',
        'Sort sequence' => '並べ替え順序',
        'State Historic' => 'ステータスの履歴',
        'State Type Historic' => 'ステータス・タイプの履歴',
        'Historic Time Range' => '',
        'Number' => '番号',
        'Last Changed' => '最終変更日時',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '平均解決時間',
        'Solution Min Time' => '最少解決時間',
        'Solution Max Time' => '最大解決時間',
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
        'Days' => '日',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'テーブル プレゼンス',
        'Internal Error: Could not open file.' => 'インターナルエラー: ファイルをオープンすることができません',
        'Table Check' => 'テーブルチェック',
        'Internal Error: Could not read file.' => 'インターナルエラー: ファイルが読み込めませんでした',
        'Tables found which are not present in the database.' => 'データベースに存在しないテーブルが見つかりました',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'データーベースサイズ',
        'Could not determine database size.' => 'データーベースサイズが特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'データベースのバージョン',
        'Could not determine database version.' => 'データベースのバージョンが特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'クライアントコネクションのキャラクターセット',
        'Setting character_set_client needs to be utf8.' => 'character_set_client は utf8 に設定する必要があります',
        'Server Database Charset' => 'データーベースサーバーのキャラクターセット',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Table キャラクターセット',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDBログのファイルサイズ',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'innodb_log_file_size 設定は最低でも256MBにする必要があります。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'デフォルト値は不正です',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '最大クエリサイズ',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'クエリキャッシュサイズ',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'query_cache_size の設定を行ってください (設定値は10MB以上512MB以下に設定する必要があります)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'デフォルトのストレージエンジン',
        'Table Storage Engine' => 'ストレージエンジン',
        'Tables with a different storage engine than the default engine were found.' =>
            'デフォルトのストレージエンジンと違うストレージエンジン設定の Table が見つかりました',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '動作要件は MySQL 5.x 以上になっています ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG 設定',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANGはal32utf8に設定する必要があります(例: ja_JP.AL32UTF8)。',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT 設定',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT は YYYY-MM-DD HH24:MI:SS に設定されている必要があります',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT 設定 SQL チェック',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => ' client_encodingはユニコードまたはUTF8 に設定する必要があります',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'server_encodingはユニコードまたはUTF8 に設定する必要があります',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'データーフォーマット',
        'Setting DateStyle needs to be ISO.' => '日付の設定はISOフォーマットに従ってください',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'OTRS ディスクパーティション',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'ディスク利用率',
        'The partition where OTRS is located is almost full.' => 'OTRS がインストールされているディスクパーティションがもうすぐいっぱいになります',
        'The partition where OTRS is located has no disk space problems.' =>
            'OTRS がインストールされているディスクパーティションはディスクスペースの問題は起こっていません',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'OTRS ディスクパーティション使用率',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'ディストリビューション',
        'Could not determine distribution.' => 'ディストリビューションを特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'カーネルバージョン',
        'Could not determine kernel version.' => 'カーネルバージョンを特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'システムロード',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'CPUの最大値はシステムの最大値を超えて読み込むことはできません(例. 8または8以下のCPUを　8 CPUのシステムで読み込むことは可能です).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl モジュール',
        'Not all required Perl modules are correctly installed.' => '必要な Perl モジュールが一部インストールされていません ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '未使用の Swap 領域 (%)',
        'No swap enabled.' => 'スワップが存在していません。',
        'Used Swap Space (MB)' => '利用 Swap 領域 (MB) ',
        'There should be more than 60% free swap space.' => '未利用のSwap領域が少なくとも 60 % 必要です',
        'There should be no more than 200 MB swap space used.' => '200MB 以上のSwap 領域が存在してはいけない',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => 'OTRS',
        'Article Search Index Status' => '記事検索インデックスのステータス',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'コミュニケーション・チャンネルごとの記事',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '着信コミュニケーション',
        'Outgoing communications' => '発信コミュニケーション',
        'Failed communications' => 'コミュニケーションの失敗',
        'Average processing time of communications (s)' => 'コミュニケーションの平均処理時間(s)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'コミュニケーション・ログのアカウント・ステータス（24時間以内）',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => 'Config 設定',
        'Could not determine value.' => 'value を特定できませんでした',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'デーモン',
        'Daemon is running.' => 'デーモンは稼働中です。',
        'Daemon is not running.' => 'デーモンは稼働していません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => 'データーベースレコード',
        'Tickets' => 'チケット',
        'Ticket History Entries' => 'チケット履歴エントリ',
        'Articles' => '記事',
        'Attachments (DB, Without HTML)' => '添付(DB, HTML以外)',
        'Customers With At Least One Ticket' => '一つ以上のチケットがある顧客',
        'Dynamic Field Values' => 'ダイナミック・フィールドの値',
        'Invalid Dynamic Fields' => '不正なダイナミック・フィールドです',
        'Invalid Dynamic Field Values' => 'ダイナミック・フィールドの値は不正です',
        'GenericInterface Webservices' => 'ジェネリックインターフェース・Webサービス',
        'Process Tickets' => 'プロセス・チケット',
        'Months Between First And Last Ticket' => '最初と最後のチケットとの間には月間',
        'Tickets Per Month (avg)' => '月毎のチケット数(平均)',
        'Open Tickets' => '対応中チケット',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'デフォルトのSOAPユーザ名とパスワード',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'セキュリティーリスク: SOAP::User 及び SOAP::Password のデフォルト設定を利用しています、変更を行ってください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '管理者のデフォルトパスワード',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'セキュリティーリスク: エージェントアカウント root@localhost はいまだにデフォルトパスワードを利用しています、変更を行ってください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => 'Eメール送信キュー',
        'Emails queued for sending' => '送信待ちのEメール',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (ドメインネーム)',
        'Please configure your FQDN setting.' => 'FQDNの設定を確認して下さい。',
        'Domain Name' => 'ドメインネーム',
        'Your FQDN setting is invalid.' => 'FQDNの設定が不正です',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '書き込み可能なファイルシステム',
        'The file system on your OTRS partition is not writable.' => 'OTRSパーティション上のファイルシステムは書き込み可能ではありません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '従来構成のバックアップ',
        'No legacy configuration backup files found.' => '従来構成のバックアップファイルは見つかりませんでした。',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'パッケージの導入状態',
        'Some packages have locally modified files.' => 'いくつかのパッケージがローカルで修正されています。',
        'Some packages are not correctly installed.' => '正常にインストールされていないパッケージが存在します',
        'Package Verification Status' => 'パッケージの検証結果',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            'いくつかのパッケージはOTRS社で認証されていません。これらのパッケージの使用は推奨しません。',
        'Package Framework Version Status' => 'パッケージフレームワークバージョン',
        'Some packages are not allowed for the current framework version.' =>
            'いくつかのパッケージは現在のフレームワークのバージョンに対応していません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => 'パッケージリスト',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => 'スプールされたメール',
        'There are emails in var/spool that OTRS could not process.' => 'OTRSが処理できなかったメールがvar/spool以下に存在しています。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'あなたのSystemID設定は不正です。数字以外は利用できません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '標準のチケットタイプ',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '設定された標準のチケットタイプは不正か存在していません。Ticket::Type::Default設定を確認し、正しいチケットタイプを指定してください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'チケットインデクスモジュール',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'システムにチケットが60,000以上あるため、バックエンドにはStaticDBを利用するべきです。詳細は管理者マニュアル(パフォーマンスチューニング)を参照してください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'システム内にチケットが 8,000以上オープンにしないでください',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'チケット検索インデックス・モジュール',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'ticket_lock_indexテーブルに孤立したレコード',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'テーブル ticket_lock_indexに孤立したレコードが存在しています。 StaticDBのインデックスを正しくするためにbin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup"を実行してください。',
        'Orphaned Records In ticket_index Table' => 'ticket_indexテーブルに孤立したレコード',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'テーブル ticket_indexに孤立したレコードが存在しています。 StaticDBのインデックスを正しくするためにbin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" を実行してください。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '時刻設定',
        'Server time zone' => 'サーバのタイムゾーン',
        'OTRS time zone' => 'OTRSのタイムゾーン',
        'OTRS time zone is not set.' => 'OTRSのタイムゾーンが設定されていません。',
        'User default time zone' => 'ユーザーのデフォルトタイムゾーン',
        'User default time zone is not set.' => 'ユーザーのデフォルトのタイムゾーンが設定されていません。',
        'Calendar time zone is not set.' => 'カレンダーのタイムゾーンが設定されていません。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - 担当者スキンの使用状況',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - 担当者のテーマ使用状況',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - 特殊レポート',
        'Agents using custom main menu ordering' => 'カスタムメインメニューのオーダーを使用する担当者',
        'Agents using favourites for the admin overview' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Webサーバー',
        'Loaded Apache Modules' => 'ロードされたApacheモジュール',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPMモデル',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRSはapacheがMPMモデルがpreforkで実行されている必要があります。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGIアクセラレータの有無',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'パフォーマンス向上のためFastCGIまたはmod_perlの使用を推奨します。',
        'mod_deflate Usage' => 'mod_deflateの有無',
        'Please install mod_deflate to improve GUI speed.' => 'GUIのパフォーマンス向上のためmod_deflateをインストールしてください。',
        'mod_filter Usage' => 'mod_filter の有無',
        'Please install mod_filter if mod_deflate is used.' => 'moddeflateを利用する場合は、mod_filterをインストールしてください。',
        'mod_headers Usage' => 'mod_headersの有無',
        'Please install mod_headers to improve GUI speed.' => 'GUIのパフォーマンス向上のためmod_headersをインストールしてください。',
        'Apache::Reload Usage' => 'Apache::Reloadモジュール使用',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            ' PerlModuleとしてApache::Reload あるいは Apache2::Reload が利用され、インストールあるいはモジュールのアップグレード中のWebサーバー再起動を防ぐために、PerlInitHandlerが利用されるべきです',
        'Apache2::DBI Usage' => 'Apache2::DBIモジュール使用',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '既存DBコネクションを有効に利用するため、Apache2::DBIを使用するとより良いパフォーマンスを得ることが出来ます。',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '環境変数',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webサイトバージョン',
        'Could not determine webserver version.' => 'WEBサーバのバージョンを決定できません。',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '同時接続ユーザー詳細',
        'Concurrent Users' => '同時実行ユーザー',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => '問題',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '設定 %s は存在しません！',
        'Setting %s is not locked to this user!' => 'Setting %s is not locked to this user!',
        'Setting value is not valid!' => '設定された値は無効です！',
        'Could not add modified setting!' => '変更した設定を追加できませんでした！',
        'Could not update modified setting!' => '変更した設定を更新できませんでした！',
        'Setting could not be unlocked!' => '設定はアンロックされていません！',
        'Missing key %s!' => 'キー %s がありません！',
        'Invalid setting: %s' => '設定が不正です: %s',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => '',
        'All Settings' => '全ての設定',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'デフォルト',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '有効',
        'Disabled' => '無効',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => 'システムはユーザー日付をOTRSTimeZoneから算出できませんでした！',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            'システムはユーザー日時をOTRSTimeZoneから算出できませんでした！',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '正常な値ではありません！確認の上、この設定を修正してください。',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'アンロック時間のリセット',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => 'チャットメッセージ本文',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            'ログインできません。ユーザー名またはパスワードを確認してください。',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => 'セッションIDを削除できません。',
        'Logout successful.' => 'ログアウトしました。',
        'Feature not active!' => '機能が有効になっていません。',
        'Sent password reset instructions. Please check your email.' => 'パスワードを初期化する手順を送信しました。メールを確認してください。',
        'Invalid Token!' => '無効なトークンです',
        'Sent new password to %s. Please check your email.' => '新しいパスワードを %s に送信しました。メールを確認してください。',
        'Error: invalid session.' => 'エラー: セッションが無効な値です。',
        'No Permission to use this frontend module!' => 'このフロントエンドモジュールを使用する権限がありません',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '承認に成功しましたが、該当する顧客情報が存在しませんでした。管理者に連絡してください。',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'パスワードのリセットができませんでした。管理者に連絡してください。',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'このe-mailアドレスはすでに存在します。ログインまたはパスワードのリセットを行ってください。',
        'This email address is not allowed to register. Please contact support staff.' =>
            'このemailアドレスの登録は認められていません。サポートにお問い合わせください。',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '顧客ユーザーが追加できませんでした。',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            '新規アカウントを作成しました。ログイン情報を %s に送信しました。メールを確認してください。',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => '無効-暫定',
        'Group for default access.' => '一般ユーザ用のデフォルトグループ',
        'Group of all administrators.' => '管理者用グループ',
        'Group for statistics access.' => 'レポート・レポート操作用のグループ',
        'new' => '新規',
        'All new state types (default: viewable).' => '全ての新規ステータス・タイプ（デフォルト：表示可能）',
        'open' => '対応中',
        'All open state types (default: viewable).' => '全ての対応中ステータス・タイプ（デフォルト：表示可能）',
        'closed' => 'クローズ',
        'All closed state types (default: not viewable).' => '全ての完了ステータス・タイプ（デフォルト：表示可能）',
        'pending reminder' => '保留中 (期限付)',
        'All \'pending reminder\' state types (default: viewable).' => '全ての \'ペンディング・リマインダー\' ステータス・タイプ（デフォルト：表示可能）',
        'pending auto' => '保留中 (自動)',
        'All \'pending auto *\' state types (default: viewable).' => '全ての保留中 (自動) ステータス・タイプ（デフォルト：表示可能）',
        'removed' => '削除',
        'All \'removed\' state types (default: not viewable).' => '全ての削除ステータス・タイプ（デフォルト：表示不可能）',
        'merged' => '結合済',
        'State type for merged tickets (default: not viewable).' => 'マージされたチケットのステータス・タイプ (デフォルト：表示不可)',
        'New ticket created by customer.' => '顧客が作成した新規チケット',
        'closed successful' => 'クローズ (成功)',
        'Ticket is closed successful.' => 'チケットは成功としてクローズされました。',
        'closed unsuccessful' => 'クローズ (不成功)',
        'Ticket is closed unsuccessful.' => 'チケットは不成功としてクローズされました。',
        'Open tickets.' => '対応中チケット',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '担当者のリマインダーのチケットは保留中です。',
        'pending auto close+' => '保留 (自動クローズ＋)',
        'Ticket is pending for automatic close.' => 'チケットは自動クローズ設定月で保留されました。',
        'pending auto close-' => '保留 (自動クローズ－)',
        'State for merged tickets.' => 'マージされたチケットのステータス',
        'system standard salutation (en)' => 'システム標準の挨拶文 (日本語)',
        'Standard Salutation.' => '標準の挨拶文',
        'system standard signature (en)' => 'システム標準の署名 (日本語)',
        'Standard Signature.' => '標準の署名',
        'Standard Address.' => '標準のアドレス',
        'possible' => '可能',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'クローズ・チケットに対するフォローアップが可能です。チケットは再オープンされます。',
        'reject' => '拒否',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'クローズ・チケットへのフォローアップはできません。新規チケットも作成されません。',
        'new ticket' => '新規チケット',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'ポストマスター・キュー',
        'All default incoming tickets.' => 'デフォルトでは全てのチケットが入ります。',
        'All junk tickets.' => '全てのジャンクチケット',
        'All misc tickets.' => '全ての未分類チケット',
        'auto reply' => '自動返答',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => '自動リジェクト',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => '自動フォローアップ',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => '自動返答/新規チケット',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => '自動除去',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '未分類',
        '1 very low' => '1 最低',
        '2 low' => '2 低',
        '3 normal' => '3 中',
        '4 high' => '4 高',
        '5 very high' => '5 最高',
        'unlock' => 'ロック解除',
        'lock' => 'ロック',
        'tmp_lock' => '',
        'agent' => '担当者',
        'system' => 'システム',
        'customer' => '顧客',
        'Ticket create notification' => '新規作成通知',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '"My Queues"および"My Services"に新しいチケットが作成されると、通知を受信します。',
        'Ticket follow-up notification (unlocked)' => 'チケット・フォローアップ通知 (ロック解除)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => 'チケット・フォローアップ通知 (ロック)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'ロック期限切れチケット通知',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => 'チケットの所有者変更通知',
        'Ticket responsible update notification' => 'チケットの責任者変更通知',
        'Ticket new note notification' => 'チケットのノート追加通知',
        'Ticket queue update notification' => 'チケット・キュー更新通知',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '"My Queues"で指定しているキューにチケットが移動された際に通知されます。',
        'Ticket pending reminder notification (locked)' => 'チケットのペンディングリマインダー通知(ロック中)',
        'Ticket pending reminder notification (unlocked)' => 'チケットのペンティングリマインダー通知(未ロック)',
        'Ticket escalation notification' => 'チケットのエスカレーション通知',
        'Ticket escalation warning notification' => 'チケットのエスカレーション警告通知',
        'Ticket service update notification' => 'チケット・サービス更新通知',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'My Servidesに登録しているチケットのサービスが変更された場合に通知されます。',
        'Appointment reminder notification' => '予約リマインダーの通知',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => 'チケット送信失敗通知',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => '全てを追加',
        'An item with this name is already present.' => 'この名前の項目は既に存在します。',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'このアイテムは、配下にサブアイテムを保有しています。このアイテムをサブアイテムと共に削除してもよろしいですか？',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'もっと多く',
        'Less' => 'もっと少なく',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'クリップボードにコピーするにはCtrl+C(Cmd+C)を押してください。',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'この添付ファイルを削除',
        'Deleting attachment...' => '添付ファイルを削除しています...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '添付ファイル削除時にエラーが発生しました。詳細はログを確認してください。',
        'Attachment was deleted successfully.' => '添付ファイルが正常に削除されました。',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'このダイナミック・フィールドを本当に削除しますか？全てのデータが失われます。',
        'Delete field' => 'ダイナミックフィールド',
        'Deleting the field and its data. This may take a while...' => 'フィールドとそれに属するデータを削除します。これには少々時間が掛かることがあります。',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '選択項目を削除',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'このイベントトリガーを削除',
        'Duplicate event.' => 'イベントを複製',
        'This event is already attached to the job, Please use a different one.' =>
            'このイベントはすでにジョブにアタッチされています。ほかのイベントをご利用ください。',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'コミュニケーション中にエラーが発生しました。',
        'Request Details' => '要求の詳細',
        'Request Details for Communication ID' => 'Communication IDの要求の詳細',
        'Show or hide the content.' => 'コンテンツの表示・非表示',
        'Clear debug log' => 'デバッグログを削除',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'このAPI実行元を削除',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'このキー割り当ての削除',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'このオペレーションを削除',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'ウェブサービスの複製',
        'Delete operation' => 'オペレーションを削除',
        'Delete invoker' => 'API実行元を削除',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '警告: あなたの名前を変更するグループの管理者はシステム設定の中で適切な変更を行う前にあなたの管理者パネルはロックアウトされます。この問題が発生した場合、管理するSQLステートメントごとにグループを元に戻してください',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'この言語での通知を本当に削除しますか？',
        'Do you really want to delete this notification?' => 'この通知を本当に削除しますか？',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'パッケージのアップグレードが最近終了しました。 結果を見るにはここをクリックして下さい。',
        'No response from get package upgrade result.' => '',
        'Update all packages' => 'パッケージを全て更新する',
        'Dismiss' => '非表示',
        'Update All Packages' => 'パッケージを全て更新する',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '現在は未対応です',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'こちらは現在パッケージの更新中のため無効化されています。',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            'こちらは現在 OTRS デーモンが停止中のため無効化されています。',
        'Are you sure you want to update all installed packages?' => '全てのパッケージを更新します。よろしいですか？',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'このポストマスター・フィルターを削除',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'ポストマスターフィルターを削除します。この処理には時間がかかる場合があります。',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'キャンバスからエンティティを削除',
        'No TransitionActions assigned.' => '推移アクションが関連付けられていません。',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'ダイアログが関連付けられていません。適切なダイアログを左から個々にドラッグしてください。',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'このアクティビティは開始アクティビティであるため削除できません。',
        'Remove the Transition from this Process' => 'このプロセスから遷移を削除',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'このボタンもしくはリンクを選択すると即座にこの画面を離れ、現在の状態が自動的に保存されます。続行しますか？',
        'Delete Entity' => 'エンティティを削除',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'このアクティビティは既にプロセスで使用されています。2度追加できません。',
        'Error during AJAX communication' => 'AJAX通信時にエラーが発生しました',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '接続されていない推移がキャンバス上に存在します。他の推移を配置する前に接続してください。',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'この遷移は既にこのアクティビティに対して使用されています。2度使用できません。',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'の遷移動作は既にこのパスで使用されています。2度使用できません。',
        'Hide EntityIDs' => 'エンティティIDを隠す',
        'Edit Field Details' => '領域の詳細を編集',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '申し訳ありませんが、最後に残された選択肢は削除できません。',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '更新を送信中…',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => 'OTRS Group へのサポートデータを送信できませんでした。',
        'Update Result' => 'アップデート結果',
        'Generating...' => '作成中...',
        'It was not possible to generate the Support Bundle.' => 'サポートバンドルが生成できませんでした。',
        'Generate Result' => '生成結果',
        'Support Bundle' => 'サポートバンドル',
        'The mail could not be sent' => 'メールが送信できませんでした',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '手動アップデート',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => '読み込み中...',
        'Search the System Configuration' => 'システム設定の検索',
        'Please enter at least one search word to find anything.' => '何かを見つけるために少なくとも1つの検索単語を入力してください。',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => 'デプロイ',
        'The deployment is already running.' => 'デプロイメントはすでに実行中です。',
        'Deployment successful. You\'re being redirected...' => 'デプロイに成功しました。 ',
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
            'このスケジュールされたシステムメンテナンスを本当に削除しますか？',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'テンプレートを削除',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'カレンダー',
        'Timeline Month' => '月間タイムライン',
        'Timeline Week' => '週間タイムライン',
        'Timeline Day' => '日中タイムライン',
        'Previous' => '過去',
        'Resources' => 'リソース',
        'Su' => '日',
        'Mo' => '月',
        'Tu' => '火',
        'We' => '水',
        'Th' => '木',
        'Fr' => '金',
        'Sa' => '土',
        'This is a repeating appointment' => 'これは繰り返しの予定です。',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'この発生またはすべて発生だけを編集しますか？',
        'All occurrences' => '全ての発生',
        'Just this occurrence' => 'この発生時点',
        'Too many active calendars' => '有効化されたカレンダーが多すぎます',
        'Please either turn some off first or increase the limit in configuration.' =>
            '',
        'Restore default settings' => 'デフォルト値に戻す',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => '重複した登録',
        'It is going to be deleted from the field, please try again.' => '',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '少なくとも検索したい単語を１つ（なんでもいい時は*を）入力してください。',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => 'OTRS デーモンの紹介',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '',
        'month' => '月',
        'Remove active filters for this widget.' => 'このウィジットに対するアクティブ・フィルターを除去',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'しばらくお待ちください..',
        'Searching for linkable objects. This may take a while...' => 'リンク可能なオブジェクトを検索しています。 これは時間がかかる場合があります...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'AdBlockやAdBlockPlus等、広告ブロックプラグインが検出されました。これらのプラグインの使用に起因する問題が報告されていますので、このドメインを除外対象にすることを推奨します。',
        'Do not show this warning again.' => 'この警告を再表示しない',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '申し訳ありません。必須とマークされている通知は無効化することはできません。',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '申し訳ありません。この通知を無効化することはできません。',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            'エラーが発生しました。管理者に連絡してください。',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'デスクトップモードへ',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'この要素は子供が存在するため削除できません。',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'このレポートを削除してよろしいですか？',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'チケットに割り当てる顧客IDを選択してください',
        'Do you really want to continue?' => '本当にこの操作を継続してよろしいですか？',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '...あまり見せない',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '新しい下書きを追加',
        'Delete draft' => '下書きを削除',
        'There are no more drafts available.' => '下書きがありません',
        'It was not possible to delete this draft.' => 'この下書きは削除できません',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => '記事フィルタ',
        'Apply' => '適用',
        'Event Type Filter' => 'イベントタイプ・フィルター',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'ナビゲーションバーを操作してください',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Internet Explorerの互換モードを無効にして下さい。',
        'Find out more' => '詳細を参照',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'モバイルモードへ',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'エラー:ブラウザチェックに失敗しました',
        'Reload page' => 'ページの再読み込み',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => '一つ以上のエラーが発生しました。',

        # JS File: Core.Installer
        'Mail check successful.' => 'メールチェックに成功しました。',
        'Error in the mail settings. Please correct and try again.' => 'メール設定中にエラーが発生しました。再設定してください。',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '新規ウィンドウで注釈を開く',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => 'キーは必須です',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => '対応開始日を選択',
        'Invalid date (need a future date)!' => '無効な日付です。 (未来の日付が必要)',
        'Invalid date (need a past date)!' => '',

        # JS File: Core.UI.InputFields
        'Not available' => '',
        'and %s more...' => '他%sつ',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'すべてクリア',
        'Filters' => 'フィルター',
        'Clear search' => '検索条件をクリア',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'このページから移動します。全てのポップアップウィンドウを閉じてもよろしいですか？',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '既にポップアップウィンドウを開いています。開いているウィンドウを閉じて新しく開きますか？',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'ポップアップウィンドウを開けませんでした。アプリケーションのポップアップブロッカーを無効にしてください。',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => 'フィルターを削除',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => '現在選択可能な要素はありません。',

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
        'yes' => 'はい',
        'no' => 'いいえ',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => '',

        # JS File: OTRSMultiBarChart
        'Grouped' => '',
        'Stacked' => '',

        # JS File: OTRSStackedAreaChart
        'Stream' => 'ストリーム',
        'Expanded' => '展開',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
お客様

表題に記載ののチケット番号は有効ではございません。
大変申し訳ありませんが、このメールの処理は行われません。

カスタマーパネルより新たなチケットを作成願います。

ヘルプデスク担当
',
        ' (work units)' => '(工数)',
        ' 2 minutes' => ' 2 分',
        ' 5 minutes' => ' 5 分',
        ' 7 minutes' => ' 7 分',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(ユーザー名) 姓 名 ',
        '(UserLogin) Lastname Firstname' => '',
        '(UserLogin) Lastname, Firstname' => '(ユーザー名) 名, 姓',
        '*** out of office until %s (%s d left) ***' => '***％s 日までの休暇中***',
        '0 - Disabled' => '0 - 無効',
        '1 - Available' => '1 - 存在',
        '1 - Enabled' => '1 - 有効',
        '10 Minutes' => '10分',
        '100 (Expert)' => '100 (熟練者向け)',
        '15 Minutes' => '15分',
        '2 - Enabled and required' => '2 - 有効さらに必須',
        '2 - Enabled and shown by default' => '2 - 有効さらにデフォルトで表示',
        '2 - Enabled by default' => '',
        '2 Minutes' => '2分',
        '200 (Advanced)' => '200 (中級者向け)',
        '30 Minutes' => '30分',
        '300 (Beginner)' => '300 (初心者向け)',
        '5 Minutes' => '5分',
        'A TicketWatcher Module.' => 'TicketWatcher モジュール',
        'A Website' => 'Webサイト',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'マージ操作中にメインチケットにマージされるダイナミック・フィールドの一覧。 メインチケットで空のダイナミック・フィールドのみが設定されます。',
        'A picture' => '写真',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '親チケットについて、その全ての子チケットが既にクローズされている場合にのみ、クローズすることを許可するACLモジュールです（“State”は、全ての子チケットがクローズされるまで、親チケットにどの状態が適用不可であるかを示しています）。',
        'Access Control Lists (ACL)' => 'アクセス制御リスト (ACL)',
        'AccountedTime' => '作業時間',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '最も古いチケットを含むキューの、点滅メカニズムを有効にします。',
        'Activates lost password feature for agents, in the agent interface.' =>
            '担当者インタフェースにおいて、パスワード忘れ機能を有効にします。',
        'Activates lost password feature for customers.' => '顧客に関する、パスワード忘れ機能を有効にします。',
        'Activates support for customer and customer user groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'ズーム・ビューで、どの項目を表示するか特定するために項目フィルタを有効にします。',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'システムで利用可能なテーマをアクティベートします。値1がアクティブ、0が非アクティブを意味します。',
        'Activates the ticket archive system search in the customer interface.' =>
            'カスタマー・インターフェースでチケット・アーカイブ・システムの検索を有効化します。',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'チケット・アーカイブ・システムを有効にすることで、チケットの一部をデイリーの範囲から外し、システムのスピードを速くします。これらのチケットを検索する際には、チケット検索においてアーカイブ・フラッグを有効にする必要があります。',
        'Activates time accounting.' => 'タイム・アカウンティングを有効にします。',
        'ActivityID' => 'ActivityID',
        'Add a note to this ticket' => 'このチケットにメモを追加',
        'Add an inbound phone call to this ticket' => '受電の記録を追加します。',
        'Add an outbound phone call to this ticket' => '架電の記録を追加します。',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'Added email. %s',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'Added link to ticket "%s".',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'Added subscription for user "%s".',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'OTRSログ・ファイルに対して、実際の年と月による接尾辞を追加します。毎月のログファイルが作成されます。',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => '管理',
        'Admin Area.' => '',
        'Admin Notification' => '管理者通知',
        'Admin area navigation for the agent interface.' => '担当者Webインタフェースの管理ナビゲーション',
        'Admin modules overview.' => '管理モジュール一覧',
        'Admin.' => '管理',
        'Administration' => '管理',
        'Agent Customer Search' => '担当者顧客の検索',
        'Agent Customer Search.' => '担当者顧客の検索',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent Statistics.' => '担当者に関する統計',
        'Agent User Search' => '担当者の検索',
        'Agent User Search.' => '担当者の検索',
        'Agent interface article notification module to check PGP.' => 'PGPをチェックするための、担当者インタフェースの項目通知のモジュールです。',
        'Agent interface article notification module to check S/MIME.' =>
            'S/MIME-Keyが利用可能かつtrueである場合、Ticket-Zoom-Viewで受信Eメールをチェックする、担当者インタフェースのモジュールです。',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'S/MIME-Keyが利用可能かつtrueである場合、Ticket-Zoom-Viewで受信Eメールをチェックする、担当者インタフェースのモジュールです。',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '担当者Webインタフェース通知モジュールを使用して、マイサービスのチケット数を確認します。 このリンクを表示するかどうかを示す追加のアクセス制御は、 "グループ"キーと "rw：group1; move_into：group2"のようなコンテンツを使用して行うことができます。',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            'AgentTicketZoom ウィジェットでは、チケットに関連付けられたオブジェクトがテーブル表示されます。',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            'AgentTicketZoom ウィジェットでは、チケットに対応する顧客情報がサイドバーに表示されます。',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            'AgentTicketZoom ウィジェットでは、チケットデータがサイドバーに表示されます。',
        'Agents ↔ Groups' => '担当者 ↔ グループ',
        'Agents ↔ Roles' => '担当者 ↔ ロール',
        'All CustomerIDs of a customer user.' => '顧客ユーザーの全てのCustomerID',
        'All attachments (OTRS Business Solution™)' => 'すべての添付ファイル（OTRS Business Solution™）',
        'All customer users of a CustomerID' => '顧客IDの全ての顧客ユーザー',
        'All escalated tickets' => '全エスカレーションチケット',
        'All new tickets, these tickets have not been worked on yet' => '全新規チケット。まだ着手されていません',
        'All open tickets, these tickets have already been worked on.' =>
            '全対応中チケット。すでに着手済みのものです',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '全保留チケット中、期限切れのもの',
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
            '担当者が統計情報を生成する場合、担当者が統計情報の軸を交換できるようにします。',
        'Allows agents to generate individual-related stats.' => '統計出力において所有者・責任者を選択できるようにします。',
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
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '顧客が顧客インタフェースでチケット・サービスを設定することを、許可します。',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'チケットに関するサービスおよびSLA（例：email, desktop, network, ...)、およびSLAのエスカレーション属性を定義することを、許可します（チケット・サービス/SLA機能が有効となっている場合）。',
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
            '中程度のフォーマットでのチケット一覧の表示を許可します（CustomerInfo => 1 - 顧客情報も表示します)。',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '小さいフォーマットでのチケット一覧の表示を許可します（CustomerInfo => 1 - 顧客情報も表示します)。',
        'Allows invalid agents to generate individual-related stats.' => '統計出力において無効にされた担当者も出力対象とします。',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '管理者は、顧客ユーザ管理パネルを経由して、他の顧客としてログインすることができます。',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '管理者が、ユーザ管理パネルを通じて、別のユーザとしてログインすることを許可します。',
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
            '担当者インタフェースの移動チケット画面で、新しいチケット状態を設定することを許可します。',
        'Always show RichText if available' => '',
        'Answer' => '回答',
        'Appointment Calendar overview page.' => '予約カレンダーの表示',
        'Appointment Notifications' => '予約の通知',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            '',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            '',
        'Appointment edit screen.' => '予定の編集画面',
        'Appointment list' => '予約リスト',
        'Appointment list.' => '予約リスト',
        'Appointment notifications' => '予約通知',
        'Appointments' => '予約',
        'Arabic (Saudi Arabia)' => '',
        'ArticleTree' => '',
        'Attachment Name' => '添付ファイル名',
        'Automated line break in text messages after x number of chars.' =>
            'X個の文字型の後の、テキスト・メッセージにおける自動化されたライン・ブレイク。',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'バルク・アクションのために選択した後に、所有者をロックし現在のAgentに設定します。',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '最初の所有者が設定されるときに、自動的にチケットの責任者を設定します（まだ設定されていなければ）。',
        'Avatar' => 'アバター',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Felix Niklasによるバランスト・ホワイト・スキンです。',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '件名に有効なチケット番号を持たない全ての受信メールを、From: @example.com addressを用いてブロックします。',
        'Bounced to "%s".' => 'Bounced to "%s".',
        'Bulgarian' => 'ブルガリア語',
        'Bulk Action' => '一括処理',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD例のセットアップです。外部CMDがSTDOUTにおいてアウトプットを戻してくる場合にEメールを無視します（Eメールは、STDIN of some.binへとパイプされます）。',
        'CSV Separator' => 'CSV区切り文字',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'チケットプロセスナビゲーションバー出力モジュールのキャッシュ時間（秒）。',
        'Cache time in seconds for the web service config backend.' => '',
        'Calendar manage screen.' => 'カレンダー管理の画面',
        'Catalan' => '',
        'Change password' => 'パスワード変更',
        'Change queue!' => 'キュー変更！',
        'Change the customer for this ticket' => 'このチケットの顧客を変更',
        'Change the free fields for this ticket' => 'このチケットの自由領域を変更',
        'Change the owner for this ticket' => 'このチケットの所有者を変更',
        'Change the priority for this ticket' => 'このチケットの優先度を変更',
        'Change the responsible for this ticket' => '',
        'Change your avatar image.' => 'あなたのアバターイメージを変更して下さい。',
        'Change your password and more.' => 'パスワードなどを変更してください。',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Changed priority from "%s" (%s) to "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '全員に対して、チケット所有者の変更を行います（ASPにおいて便利です）。通常は、チケットのキューにおいてrw許可を持つ担当者のみが、表示されます。',
        'Chat communication channel.' => 'チャット・コミュニケーション・チャネル',
        'Checkbox' => 'チェックボックス',
        'Checks for articles that needs to be updated in the article search index.' =>
            '',
        'Checks for communication log entries to be deleted.' => '削除するコミュニケーション・ログのエントリをチェックします。',
        'Checks for queued outgoing emails to be sent.' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            'このシステムのOTRS Business Solution™の可用性をチェックします。',
        'Checks the entitlement status of OTRS Business Solution™.' => 'OTRS Business Solution™の権利の状態を確認します。',
        'Child' => '子',
        'Chinese (Simplified)' => '',
        'Chinese (Traditional)' => '',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '通知を受け取りたい予定を選択して下さい。',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => 'クリスマスイブ',
        'Close' => 'クローズ',
        'Close this ticket' => 'このチケットをクローズ',
        'Closed tickets (customer user)' => 'クローズ・チケット(顧客ユーザー)',
        'Closed tickets (customer)' => 'クローズ・チケット(顧客)',
        'Cloud Services' => 'クラウドサービス',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => 'チケット一覧(S)でのカラムチケット・フィルター',
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
        'Comment for new history entries in the customer interface.' => '顧客インタフェースの新規履歴エントリーのためのコメントです。',
        'Comment2' => '',
        'Communication' => 'コミュニケーション',
        'Communication & Notifications' => 'コミュニケーション & 通知',
        'Communication Log GUI' => 'コミュニケーション・ログGUI',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => 'コミュニケーション・ログの一覧制限',
        'Company Status' => '企業ステータス',
        'Company Tickets.' => '',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Compose' => '作成',
        'Configure Processes.' => 'プロセスの構成',
        'Configure and manage ACLs.' => 'ACLの設定と管理',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '新規チケットが作成された後に表示する画面を選択してください。',
        'Configure your own log text for PGP.' => 'PGPのための利用者独自のログテキストを設定します。',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            '顧客が自らのチケットをソートする機能を持つかどうかを、コントロールします。',
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
        'Converts HTML mails into text messages.' => 'HTMLメールをテキストメッセージに変換',
        'Create New process ticket.' => 'プロセスチケットを作成',
        'Create Ticket' => 'チケットを作成',
        'Create a new calendar appointment linked to this ticket' => 'このチケットにリンクされている新しい予定を作成',
        'Create and manage Service Level Agreements (SLAs).' => 'サービスレベル契約 (SLA) の作成と管理',
        'Create and manage agents.' => '担当者の作成と管理',
        'Create and manage appointment notifications.' => '予定通知の作成と管理',
        'Create and manage attachments.' => '添付ファイルの作成と管理',
        'Create and manage calendars.' => 'カレンダーの作成と管理',
        'Create and manage customer users.' => '顧客ユーザーの作成と管理',
        'Create and manage customers.' => '顧客の作成と管理',
        'Create and manage dynamic fields.' => 'ダイナミック・フィールドの作成と管理',
        'Create and manage groups.' => 'グループの作成と管理',
        'Create and manage queues.' => 'キューの作成と管理',
        'Create and manage responses that are automatically sent.' => '自動送信する応答の作成と管理',
        'Create and manage roles.' => 'ロールの作成と管理',
        'Create and manage salutations.' => '挨拶文の作成と管理',
        'Create and manage services.' => 'サービスの作成と管理',
        'Create and manage signatures.' => '署名の作成と管理',
        'Create and manage templates.' => 'テンプレートの作成と管理',
        'Create and manage ticket notifications.' => 'チケット通知の作成と管理',
        'Create and manage ticket priorities.' => 'チケット優先度の作成と管理',
        'Create and manage ticket states.' => 'チケット状態の作成と管理',
        'Create and manage ticket types.' => 'チケットタイプの作成と管理',
        'Create and manage web services.' => 'Webサービスの作成と管理',
        'Create new Ticket.' => '新規チケットの作成',
        'Create new appointment.' => '予約を登録',
        'Create new email ticket and send this out (outbound).' => '新しいメールチケットを作成し、これを送信します。（送信）',
        'Create new email ticket.' => '新規電子メールチケットの作成',
        'Create new phone ticket (inbound).' => '新規電話チケット(着信)の作成',
        'Create new phone ticket.' => '新規電話チケットの作成',
        'Create new process ticket.' => 'プロセスチケットを作成',
        'Create tickets.' => 'チケットの作成',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => 'クロアチア',
        'Custom RSS Feed' => 'カスタムRSSフィード',
        'Custom RSS feed.' => 'カスタムRSSフィード',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '顧客管理',
        'Customer Companies' => '顧客企業',
        'Customer IDs' => '顧客ID',
        'Customer Information Center Search.' => '顧客情報センターの検索',
        'Customer Information Center search.' => '',
        'Customer Information Center.' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User Administration' => '顧客ユーザー管理',
        'Customer User Information' => '顧客ユーザー情報',
        'Customer User Information Center Search.' => '顧客ユーザー情報センターの検索',
        'Customer User Information Center search.' => '',
        'Customer User Information Center.' => '',
        'Customer Users ↔ Customers' => '顧客ユーザー ↔ 顧客',
        'Customer Users ↔ Groups' => '顧客ユーザー ↔ グループ',
        'Customer Users ↔ Services' => '顧客ユーザー ↔ サービス',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => '',
        'Customer ticket overview' => '顧客チケット一覧',
        'Customer ticket search.' => '顧客チケットの検索',
        'Customer ticket zoom' => '顧客チケット・ズーム',
        'Customer user search' => '顧客ユーザーの検索',
        'CustomerID search' => '顧客IDの検索',
        'CustomerName' => '顧客名',
        'CustomerUser' => 'CustomerUser（顧客ユーザ）',
        'Customers ↔ Groups' => '顧客 ↔ グループ',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => 'チェコ語',
        'Danish' => 'デンマーク語',
        'Dashboard overview.' => 'ダッシュボード一覧',
        'Data used to export the search result in CSV format.' => '検索結果をCSVフォーマットでエクスポートするために使用されるデータです。',
        'Date / Time' => '日時',
        'Default (Slim)' => 'デフォルト (Slim)',
        'Default ACL values for ticket actions.' => 'チケット・アクションに関するデフォルトのACLの値です。',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'AgentTicketZoom および CustomerTicketZoom 上でデフォルト表示する受信者名(To,Cc)',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'AgentTicketZoom および CustomerTicketZoom 上でデフォルト表示する送信者名(From)',
        'Default loop protection module.' => 'デフォルトのループ・プロテクション・モジュールです。',
        'Default queue ID used by the system in the agent interface.' => '担当者インタフェースにおいて、システムによって使用されるデフォルトのキューIDです。',
        'Default skin for the agent interface (slim version).' => '担当者インターフェースのデフォルトスキン (スリムバージョン)',
        'Default skin for the agent interface.' => '担当者インターフェースのデフォルトスキン',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '担当者インタフェースにおいて、システムによって使用されるデフォルトのチケットIDです。',
        'Default ticket ID used by the system in the customer interface.' =>
            '顧客インタフェースで、システムによって使用されるデフォルトのチケットIDです。',
        'Default value for NameX' => 'NameX用のデフォルト値',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定義された文字列（string）の後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
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
            'インシデントカレンダーの日付ピッカーにおける週の開始曜日を設定します。',
        'Define the start day of the week for the date picker.' => '日付ピッカーにおける週の開始曜日を設定します。',
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
            '顧客情報ブロックの最後において、LinkedInアイコンを作成するための顧客アイテムを定義します。',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '顧客情報ブロックの最後において、XINGアイコンを作成するための顧客アイテムを定義します。',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '顧客情報ブロックの最後において、Googleマップのアイコンを作成するための顧客アイテムを定義します。',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '顧客情報ブロックの最後において、Googleマップのアイコンを作成するための顧客アイテムを定義します。',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'CVEナンバーの後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'MSBulletinナンバーの後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '定義された文字列（string）の後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'バグトラック・ナンバーの後ろにリンクを追加するhtmlアウトプットのための、フィルタを定義します。エレメント・イメージは、2種類のインプットを許可します。すぐに、イメージの名前です（つまりfaq.png）。この場合、OTRSイメージ・パスが使用されます。2つめの可能性は、イメージにリンクを挿入することです。',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '事前定義されたキーワードをハイライトするため、項目の中のテキストを処理するフィルタを定義します。',
        'Defines a permission context for customer to group assignment.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '一部のアドレスをシンタクスのチェックから除外する、通常の表現を定義します（"CheckEmailAddresses"が“Yes”に設定されている場合）。このフィールドに、構文的には有効でないがシステムには必要であるEメールアドレス（例："root@localhost"）に関するregrexを入力してください。',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'アプリケーションで使用されるべきではない全Eメール・アドレスをフィルタするための、一般表現を定義します。',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '特定のユーザ・オプションをロードしたり、ニュースを表示したりするための、役に立つモジュールを定義します。',
        'Defines all the X-headers that should be scanned.' => 'スキャンされるべき全てのX－ヘッダーを定義します。',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '顧客インタフェースの顧客プレファレンスにおいて、RefreshTimeオブジェクトのための全パラメータを定義します。',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '顧客インタフェースの顧客プレファレンスにおいて、ShownTicketsオブジェクトのための全パラメータを定義します。',
        'Defines all the parameters for this item in the customer preferences.' =>
            '顧客プレファレンスにおいて、本アイテムの全パラメータを定義してください。',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => '全ての可能な統計アウトプットのフォーマットを定義します。',
        'Defines an alternate URL, where the login link refers to.' => 'ログイン・リンクが参照する、代替URLを定義します。',
        'Defines an alternate URL, where the logout link refers to.' => 'ログアウト・リンクが参照する、代替URLを定義します。',
        'Defines an alternate login URL for the customer panel..' => '顧客パネルのための代替ログインURLを定義します。',
        'Defines an alternate logout URL for the customer panel.' => '顧客パネルのための代替ログアウトURLを定義します。',
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
        'Defines chat communication channel.' => 'チャット・コミュニケーション・チャネルを定義します。',
        'Defines default headers for outgoing emails.' => '',
        'Defines email communication channel.' => '電子メール・コミュニケーション・チャネルを定義します。',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'EメールのFromフィールドについて（回答およびEメールチケットからの目標）が、どのように見えるべきかを定義します。',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '担当者インタフェースのクローズ・チケット画面で、チケット・ロックが必要とされるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者に設定されます）。',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
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
            '担当者インタフェースのチケット・メモ画面で、チケット・ロックが必要とされるかどうかを定義します（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
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
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '顧客インタフェースで拡張モードを使用すべきかどうかを定義します(これにより、表・置換機能・各種スクリプト・Wordからの貼り付けなどが利用可能になります)。',
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
            'タイム・アカウンティングがバルク・アクションにおける全てのチケットに対して、必ず設定されるかどうかを定義します。',
        'Defines internal communication channel.' => '内部コミュニケーション・チャネルを定義します。',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines phone communication channel.' => '電話コミュニケーション・チャネルを定義します。',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'ローカル・レポジトリにアクセスするための、IPの正規表現を定義します。ローカル・レポジトリにアクセスするために、これを有効にする必要があり、またpackage::RepositoryListはリモート・ホストにおいて必要とされます。',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '',
        'Defines the URL CSS path.' => 'URL・CSパスを定義します。',
        'Defines the URL base path of icons, CSS and Java Script.' => 'アイコン、CSS、Java ScriptのURLベースのパスを定義します。',
        'Defines the URL image path of icons for navigation.' => 'ナビゲーションのためのアイコンのURLイメージ・パスを定義します。',
        'Defines the URL java script path.' => 'URL Java Scriptパスを定義します。',
        'Defines the URL rich text editor path.' => 'URLリッチテキスト・エディター・パスを定義します。',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '必要な場合には"CheckMXRecord"検索のための、専用DNSサーバのアドレスを定義します。',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '新アカウントについて、顧客に送信される通知メールの本文テキストを定義します。',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => 'リジェクトされたEメールの本文を定義します。',
        'Defines the calendar width in percent. Default is 95%.' => 'カレンダの幅をパーセントで定義します。デフォルトは95%です。',
        'Defines the column to store the keys for the preferences table.' =>
            'プレファレンス・テーブルのためのキーを格納するコラムを定義してください。',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '本アイテムのコンフィグ・パラメータを、プレファレンス・ビューで表示されるように定義します。',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'プロキシ経由で、http/ftpのための接続を定義します。',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            'フォームで使用されるデータ・インプット・フォーマットを定義します（オプションまたはインプット・フィールド）。',
        'Defines the default CSS used in rich text editors.' => 'リッチテキスト・エディターで使用されるデフォルトCSSを定義します。',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、メモのデフォルトの本文を定義します。',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '顧客ユーザーのアドレス帳の検索（CustomerUser又はCustomerCompany）のデフォルトのフィルターフィールドを定義します。 CustomerCompanyフィールドには、接頭辞 \'CustomerCompany_\'を追加する必要があります。',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'デフォルトのフロント・エンドの言語を設定します。全ての可能性ある値は、システムの利用可能な言語ファイルによって定義されます（次の設定を参照ください)。.',
        'Defines the default history type in the customer interface.' => '顧客インタフェースのデフォルトの履歴タイプを定義します。',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'タイム・スケールに関するX軸属性の、デフォルト最大数を定義します。',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '一覧画面の1ページあたりのデフォルトの最大統計数を定義します。',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '顧客インタフェースで、顧客フォローアップ後のチケットに対するデフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、チケットのメモを追加した後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、メモを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・メモ画面で、メモを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、メモを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、メモを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、メモを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、メモを追加した後の、デフォルトのチケットの次の状態を定義します。',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '担当者インタフェースのチケット・バウンス画面で、チケットがバウンスされた後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '担当者インタフェースのチケット転送画面で、チケットが転送された後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '担当者インタフェースの外部メール送信画面で、メッセージが送信された後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、チケットが構成（compose）/回答（answer）された後の、デフォルトの次の状態を定義します。',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、電話チケットのためのデフォルトのメモ本文テキストを定義します。',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '顧客インタフェースのチケット・ズーム画面で、フォローアップ顧客チケットの優先度を定義します。',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '顧客インタフェースで、新規顧客チケットのデフォルトの優先度を定義します。',
        'Defines the default priority of new tickets.' => '新規チケットのデフォルトの優先度を定義します。',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '顧客インタフェースで、新規顧客チケットのためのデフォルトのキューを定義します。',
        'Defines the default queue for new tickets in the agent interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'ダイナミックオブジェクトに関するドロップダウン・メニューにおいて、デフォルトの選択を定義します(Form: Common Specification)。',
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
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'チケット検索画面で、デフォルトの表示されるチケット検索属性を定義します。',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'デフォルトで表示するチケット検索条件を定義します。
Keyはダイナミック・フィールドの名前（この例の場合は"X"）を指定します。
Contentはダイナミック・フィールドの形式によって設定内容が異なります。
例）
[テキスト]
’文字列’ （任意の文字列）
[ドロップダウン]
\'1\' （項目の順番）
[日時]
\'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'キュー・ビューの全てのキューに関して、優先度ソートの後の、デフォルトのソート順番を定義します。',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '顧客インタフェースで、新規顧客チケットのデフォルトの状態を定義します。',
        'Defines the default state of new tickets.' => '新規チケットのデフォルトの状態を定義します。',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、電話チケットのためのデフォルトの件名を定義します。',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、メモのデフォルトの件名を定義します。',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '顧客インタフェースのチケット検索で、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '担当者インタフェースのエスカレーション・ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '担当者インタフェースのロック済チケット・ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '担当者インタフェースの責任ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '担当者インタフェースのステータスビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '担当者インタフェースの監視（watch）ビューで、チケット・ソートのためのデフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '担当者インタフェースのチケット検索結果のチケット・ソートについて、デフォルトのチケット属性を定義します。',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '担当者インタフェースのチケット・バウンス画面で、顧客/送信者に対するデフォルトのチケット・バウンス通知を定義します。',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '担当者インタフェースの電話応答着信画面で、電話メモを追加した後のチケットのデフォルトの次の状態を定義します。',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースの電話応答発信画面で、電話メモを追加した後のチケットのデフォルトの次の状態を定義します。',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースのエスカレーション・ビューで、デフォルトのチケット順番（優先度ソート後）を定義します。Up:一番古いものをトップに. Down:最新のものをトップに。',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースのステータスビューで、デフォルトのチケット順番（優先度によるソートの後）を定義します。Up: 最も古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            ' 担当者インタフェースの責任ビューで、デフォルトのチケットの順番を定義します。Up: 一番古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースのロック済チケット・ビューで、デフォルトのチケットの順番を定義します。Up: 一番古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '担当者インタフェースのチケット検索結果で、デフォルトのチケット順番を定義します。Up: 最も古いものがトップ. Down: 最新のものがトップ。',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
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
            '担当者インタフェースのチケット・メモ画面で、デフォルトのチケット優先度を定義します。',
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
        'Defines the default ticket type.' => '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '担当者インタフェースにおいてURLにActionパラメータが与えられない場合、デフォルトで使用されるFrontend-Moduleを定義します。',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '顧客インタフェースのURLに対してActionパラメータが何も与えられない場合の、デフォルトで使用されるFrontend-Moduleを定義します。',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'チケットについて視認できる、デフォルトの送信者タイプを定義します（デフォルト：customer）。',
        'Defines the default visibility of the article to customer for this operation.' =>
            'この操作のために顧客へデフォルトで参照する設定を定義します。',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'カレンダ・イベントで表示するダイナミック・フィールドを定義します。',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'URLをハイライトするため、項目の中のテキストを処理するフィルタを定義します。',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'フルに認定されたシステムのドメイン名を定義します。この設定は変数OTRS_CONFIG_FQDNとして使用され、アプリケーションによって使用されるメッセージングの全てのフォームに存在し、ご利用のシステム内のチケットへのリンクを作成することとなります。',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '全顧客が所属するグループを定義します（CustomerGroupSupportが有効であり、全顧客ユーザをこれらのグループで管理したくない場合）。',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、クローズ・チケット画面アクションの履歴コメントを定義します。',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースでチケット履歴のために使用される、Eメール・チケット画面アクションの履歴コメントを定義します。',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースのチケット履歴で使用される、電話チケット画面アクションに関する履歴コメントを定義します。',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'チケット履歴で使用される、チケット・フリー・テキスト画面のアクションに関する履歴コメントを定義します。',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '担当者インタフェースのチケット履歴で使用される、チケット・メモ画面アクションに関する履歴コメントを定義します。',
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
            '担当者インタフェースのチケット履歴で使用される、チケット・メモ画面アクションについて、履歴タイプを定義します。',
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
        'Defines the list of params that can be passed to ticket search function.' =>
            '',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '追加的パッケージに関して、オンラインのレポジトリー・リストにアクセスするためのロケーションを定義します。1つめの利用可能な結果が使用されます。',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'システムのログ・モジュールを定義します。"ファイル"は、与えられたログファイルの全メッセージをライトし、"SysLog"はそのシステムのsyslog daemon、つまりsyslogdを使用します。',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'ブラウザからOTRSへファイルアップロードする最大サイズ（バイト単位）を定義します。 警告：このオプションを低すぎる値に設定すると、OTRSインスタンス内の多くのインプット機能が機能しなくなる可能性があります。',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'セッションIDのための最大有効時間（秒）を定義します。',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => 'PDFファイルごとの最大ページ数を定義します。',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'ログ・ファイルの最大サイズ（MB）を定義します。',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '担当者インタフェースにおいて、現在ログインしている全ユーザを表示させるモジュールを定義します。',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '顧客を認証するモジュールを定義します。',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'OTRS Business Solution™の様々な機会に異なるインタフェースで通知を表示するモジュールを定義します。',
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
            'もし、システムがアドミン・ユーザによって使用されている場合、担当者インタフェースにおいて通知を表示させるモジュールを定義します（通常はアドミンとして行動する必要はありません）。',
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
            'セッション・データを格納するために使用されるモジュールを定義します。"DB"により、フロント・エンドのサーバをdbサーバから分離させることができます。"FS"はより速いものです。',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'ウェブ・インタフェース、ウェブ・ブラウザのタブおよびタイトル・バーに表示されるアプリケーション名を定義します。',
        'Defines the name of the column to store the data in the preferences table.' =>
            'プレファレンス・テーブルにおいてデータを格納するコラムの名前を定義します。',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'プレファレンス・テーブルにおいてユーザ識別子を格納するためのコラムの名前を定義します。',
        'Defines the name of the indicated calendar.' => 'インシデントカレンダーの名称を設定してください。',
        'Defines the name of the key for customer sessions.' => '顧客セッションのためのキーの名前を定義します。',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'セッション・キーの名前を定義します。つまり、Session、SessionID、OTRSです。',
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、チケットを構成/回答した後の、可能性ある次の状態を定義します。',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '担当者インタフェースのチケット転送画面で、チケットを作成した後の、可能性ある次の状態を規定します。',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'エージェント画面のメール送信画面後に設定できる状態をを設定してください。',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '顧客インタフェースで顧客チケットに関する、次の可能性ある状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、チケットのメモを追加した後の次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、メモを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・メモ画面で、メモを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、メモを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、メモを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、メモを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、メモを追加した後のチケットの次の状態を定義します。',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '担当者インタフェースのチケット・バウンス画面で、チケットのバウンスされた後の次の状態を定義します。',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '担当者インタフェースの移動チケット画面で、チケットが他のキューへ移動させられた後の次の状態を定義します。',
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
        'Defines the parameters for the customer preferences table.' => '顧客プレファレンス・テーブルのためのパラメータを定義してください。',
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
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => 'PGPバイナリへのパスを定義します。',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'sslバイナリを開くためのパスを定義します。HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).が必要になるかもしれません。',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '担当者が非アクティブのために「不在」としてマークされるまでの期間（分単位）を定義します（たとえば、「ログインユーザー」ウィジェット内またはチャット用）。',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '顧客が非アクティブのために「不在」としてマークされるまでの期間（分単位）を定義します（たとえば、「ログインユーザー」ウィジェット内またはチャット用）。',
        'Defines the postmaster default queue.' => 'ポストマスターのデフォルトのキューを定義します。',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '統計に関する検索のリミットを定義します。',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => 'リジェクトされたEメールの送信者を定義します。',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '担当者の実名と与えられたキューのEメールアドレスに間に置く分離を定義します。',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'アプリケーション内で顧客が利用できる標準の許可を定義します。もし、より多くの許可が必要になった場合、ここに入力してください。許可が効力を持つためには、ハード・コーディングされる必要があります。なお、前述した許可のいずれかを追加する場合、“rw”許可が、最後のエントリとなることを確実にしてください。',
        'Defines the standard size of PDF pages.' => 'PDFページの標準サイズを定義します。',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'クローズされたチケットに対してフォローアップを受け取った場合のチケットの状態を定義します。',
        'Defines the state of a ticket if it gets a follow-up.' => 'フォローアップを受け取った場合のチケットの状態を定義します。',
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
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'システム識別子を定義します。すべてのチケット番号とHTTPセッションの文字列は、このIDが含まれています。これはをシステムに属している唯一のチケットがフォローアップとして処理されることを確実にします。（2つのOTRSのインスタンス間で通信する場合に便利です）',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'システム識別子を定義します。すべてのチケット番号とHTTPセッションの文字列は、このIDが含まれています。これはをシステムに属している唯一のチケットがフォローアップとして処理されることを確実にします。（2つのOTRSのインスタンス間で通信する場合に便利です）',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '外部顧客データベースへのリンクにおける、ターゲット属性を定義します。例：\'target="cdb"\'',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the ticket plugin for calendar appointments.' => '予定のカレンダーのチケットプラグインを定義します。',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'アプリケーションにサービスを提供するWebサーバが使用するプロトコルの種類を定義します。 HTTPSプロトコルをプレーンHTTPの代わりに使用する場合はここで指定する必要があります。これがないWebサーバの設定や行動に影響を与えるので、アプリケーションへのアクセスの方法を変更しないと、それが間違っている場合、アプリケーションにログインできなくなることがあります。この設定は、システム内でのチケットへのリンクを構成するためにアプリケーションが使用するメッセージングのすべての形態で発見されている変数、OTRS_CONFIG_HttpTypeとして使用されます。',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '顧客パネルのためのユーザ識別子を定義します。',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'SOAPハンドルにアクセスするためのユーザ名を定義します(bin/cgi-bin/rpc.pl)。',
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
            'リッチテキスト・エディター・コンポーネントを定義します。数字（ピクセル）またはパーセント値（相対的）を入力します。',
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
            '状態（キー）のペンディング・タイムが終了した後に、どの状態が自動的に設定されるべきか（コンテンツ）を定義します。',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '期限切れのセッションデータを削除する。',
        'Delete expired ticket draft entries.' => '期限切れのチケット下書きエントリを削除します。',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'このチケットを削除',
        'Deleted link to ticket "%s".' => 'Deleted link to ticket "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'もしセッションIDが、無効なリモートIPアドレスと共に使用されている場合、セッションを削除します。',
        'Deletes requested sessions if they have timed out.' => 'リクエストされたセッションがタイムアウトしている場合に削除します。',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => 'OTRS Business Solution™のデプロイと管理',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'チケットへ移動していくであろう、可能性あるキューのリストが、担当者インタフェースにドロップ・ダウン・リストまたは新規ウィンドウとして表示されるべきかどうかを定義します。"New Window"を設定した場合、チケットに移動メモを追加することができます。',
        'Determines if the statistics module may generate ticket lists.' =>
            'レポート・モジュールがチケットリストを生成するかどうかを決定します。',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '担当者インタフェースで、Eメール・チケットを作成した後の、可能性ある次のチケット状態を定義します。',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットを作成した後の、次の可能性あるチケット状態を定義します。',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '顧客インタフェースで、新規顧客チケットの後の次の画面を決定します。',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '顧客インタフェースで、ズームされたチケットのフォローアップ画面の後の次の画面を定義します。',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'タイム・リミットを越えてから状態を変更したペンディング・チケットに対して、可能となる状態を定義します。',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'リンクされたオブジェクトがそれぞれのズームマスクで表示される方式を定義します。',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '顧客インタフェースで、チケットの受信者としてどのキューを有効とするかを定義します。',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'HTTPヘッダ"Content-Security-Policy”を無効化し、外部のスクリプトコンテンツの読み込みを許可します。 このHTTPヘッダを無効にすることにより、セキュリティ上の問題が生じることがあります! 変更内容をよく理解している場合に限り無効化を実行してください!',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'HTTPヘッダ"X-Frame-Options: SAMEORIGIN”を無効化し、OTRSを外部のWebサイトの一部としてiframeに埋め込むことを許可します。 このHTTPヘッダを無効にすることにより、セキュリティ上の問題が生じることがあります! 変更内容をよく理解している場合に限り無効化を実行してください!',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => 'クラウドサービスの無効化',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            'チケットの責任者である担当者への、リマインダー通知の送信を無効にします(Ticket::Responsibleが有効にされる必要があります)。',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display communication log entries.' => 'コミュニケーション・ログのエントリを表示します。',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'チケット・ズーム・ビューで、項目に関してアカウントされた時間を表示します。',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => '降順',
        'Dropdown' => 'ドロップダウン',
        'Dutch' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Dynamic Fields Checkbox Backend GUI' => 'ダイナミックフィールド・チェックボックス・バックエンドGUI',
        'Dynamic Fields Date Time Backend GUI' => 'ダイナミック・フィールド・日時バックエンドGUI',
        'Dynamic Fields Drop-down Backend GUI' => 'ダイナミック・フィールド・ドロップダウン・バックエンドGUI',
        'Dynamic Fields GUI' => 'ダイナミックフィーールドのGUI',
        'Dynamic Fields Multiselect Backend GUI' => 'ダイナミック・フィールド複数選択バックエンドGUI',
        'Dynamic Fields Overview Limit' => 'ダイナミック・フィールド一覧の表示数',
        'Dynamic Fields Text Backend GUI' => 'ダイナミックフィールド・テキストバックエンドGUI',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '検索結果をCSVフォーマットでエクスポートする際に利用するダイナミック・フィールドです。',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => 'ダイナミック・フィールド一覧内のダイナミック・フィールド表示上限数',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '担当者インタフェースの電子メール送信画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '担当者インタフェースのチケットプロセス詳細に表示するダイナミック・フィールド',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '担当者インタフェースチケット詳細画面のサイドバーに表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '担当者インタフェースのチケットクローズ画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット作成画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '担当者インタフェースのチケット電子メール送信画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '担当者インタフェースのチケット転送画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケットフリーテキスト画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '担当者インタフェースのチケット移動画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット注釈画面に表示するダイナミック・フィールド',
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
            '担当者インターフェイスのチケットプレビュー形式画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '担当者インターフェイスのチケット印刷画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '担当者インタフェースのチケット優先度画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '担当者インターフェイスのチケット責任者画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '担当者インタフェースのチケット検索画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '担当者インターフェイスのコンパクトなチケット概要画面に表示するダイナミック・フィールド',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '',
        'DynamicField' => 'ダイナミック・フィールド',
        'DynamicField backend registration.' => 'ダイナミック・フィールドのバックエンド登録',
        'DynamicField object registration.' => 'ダイナミックフィールドのオブジェクト登録',
        'DynamicField_%s' => 'DynamicField_%s',
        'E-Mail Outbound' => 'メール送信',
        'Edit Customer Companies.' => '顧客企業を編集',
        'Edit Customer Users.' => '顧客ユーザーを編集',
        'Edit appointment' => '予約の編集',
        'Edit customer company' => '顧客企業を編集',
        'Email Addresses' => 'メールアドレス',
        'Email Outbound' => '電子メール発信',
        'Email Resend' => '電子メール再送信',
        'Email communication channel.' => '電子メールのコミュニケーション・チャネル',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Enabled filters.' => 'フィルターを有効にする',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'PGPを有効化します。PGPサポートでメールの署名と暗号化が有効になっている場合は、.gnupgフォルダにアクセスする際の権限問題を回避するため、WebサーバーをOTRSユーザーとして実行することを強くお勧めします。 ',
        'Enables S/MIME support.' => 'S/MIMEサポートを有効にします。',
        'Enables customers to create their own accounts.' => '顧客が自ら自身のアカウントを作成できるようにします。',
        'Enables fetch S/MIME from CustomerUser backend support.' => '顧客ユーザー情報サポートからS / MIME設定を取得できるようにします。',
        'Enables file upload in the package manager frontend.' => 'パッケージ・マネジャー・フロントエンドでの、ファイル・アップロードを有効にします。',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '所有者または責任者になること無くチケットのコールバックを続けるため、チケット監視機能を有効または無効にします。',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'パフォーマンス・ログを有効にします（ページ・レスポンス・タイムのログを取ります）。システム・パフォーマンスに影響が出ます。Frontend::Module###AdminPerformanceLogを有効とする必要があります。',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '担当者フロントエンドで、同時に2つ以上のチケットの作業を可能にするためのチケット・バルク・アクション機能を有効にするものです。',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'リストされたグループに対してのみ、チケット・バルク・アクション機能を有効にします。',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '特定のチケットにコールバックするため、チケット責任者機能を有効にします。',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => 'リストされたグループためにのみ、チケット監視機能を有効にします。',
        'English (Canada)' => '英語(カナダ)',
        'English (United Kingdom)' => '英語(イギリス)',
        'English (United States)' => '英語(アメリカ合衆国)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'エスカレーションチケット',
        'Escalation view' => 'エスカレーション・ビュー',
        'EscalationTime' => '',
        'Estonian' => 'エストニア語',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
            'ダイナミック・フィールドに対応する顧客ユーザーオブジェクト名を更新するイベント・モジュール',
        'Event module that updates customer user search profiles if login changes.' =>
            'ログインが変更された際に顧客ユーザーの検索プロファイルを更新するイベント・モジュール',
        'Event module that updates customer user service membership if login changes.' =>
            'ログインが変更された際に顧客ユーザーのサービスメンバーシップを更新するイベント・モジュール',
        'Event module that updates customer users after an update of the Customer.' =>
            '顧客情報が更新された際に顧客ユーザー情報を更新するイベント・モジュール',
        'Event module that updates tickets after an update of the Customer User.' =>
            '顧客ユーザー情報が更新された際チケットを更新するイベント・モジュール',
        'Event module that updates tickets after an update of the Customer.' =>
            '顧客情報が更新された際にチケットを更新するイベント・モジュール',
        'Events Ticket Calendar' => 'イベント・チケット・カレンダー',
        'Example package autoload configuration.' => 'パッケージの自動ロード設定の例',
        'Execute SQL statements.' => 'SQL文の実行',
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
            '検索結果で、全ての項目ツリーをエクスポートします（システム・パフォーマンスに影響が出る場合があります）。',
        'External' => '外部',
        'External Link' => '外部リンク',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'プロキシ経由でパッケージを取ってきます（フェッチ）。"WebUserAgent::Proxy"を上書きします。',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => '受信メールフィルター',
        'Finnish' => 'フィンランド語',
        'First Christmas Day' => 'ファースト・クリスマスデー',
        'First Queue' => '第一キュー',
        'First response time' => '初回応答期限',
        'FirstLock' => '初回ロック',
        'FirstResponse' => '初回応答',
        'FirstResponseDiffInMin' => '初回応答期限超過時間',
        'FirstResponseInMin' => '初回応答時間',
        'Firstname Lastname' => '姓 名',
        'Firstname Lastname (UserLogin)' => '姓 名 (ユーザー名)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '送信Eメールのエンコードを強制します(7bit|8bit|quoted-printable|base64)。',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'ロックのアクションの後に、（現状から）異なるチケット状態を強制的に選択します。現在の状態をキーとして定義し、ロック・アクションの後に来る次の状態をコンテンツとして選択してください。',
        'Forces to unlock tickets after being moved to another queue.' =>
            'チケットが他のキューに移動された後に、強制的にアンロックします。',
        'Forwarded to "%s".' => 'Forwarded to "%s".',
        'Free Fields' => '自由領域',
        'French' => 'フランス語',
        'French (Canada)' => 'フランス語（カナダ）',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => 'フロントエンド',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            'フロントエンド・モジュールの登録 (チケット・サービス機能が使われていない場合、AgentTicketServiceリンクは無効)。',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'フロントエンド・モジュールの登録 (企業機能が使われていない場合、企業リンクは無効)。',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '顧客向けのフロントエンド・モジュールの登録 (プロセスが利用可能ではない場合、チケット・プロセス画面リンクは無効)。',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'フロントエンド・モジュールの登録 (プロセスが利用可能ではない場合、チケット・プロセス画面リンクは無効)。',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            'フロントエンドモジュールを登録（個人用のお気に入りを「管理」のサブナビゲーション項目として表示）',
        'Frontend module registration for the agent interface.' => '担当者インタフェースに関するフロントエンド・モジュールの登録です。',
        'Frontend module registration for the customer interface.' => '担当者インタフェースに関するフロントエンド・モジュールの登録です。',
        'Frontend module registration for the public interface.' => '公開画面のフロントエンドモジュールの定義',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '全文検索',
        'Galician' => 'ガリシア語',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => 'ダッシュボードのレポート情報を生成します。',
        'Generic Info module.' => '',
        'GenericAgent' => '管理用ジョブ',
        'GenericInterface Debugger GUI' => 'ジェネリックインターフェース・デバッカーGUI',
        'GenericInterface ErrorHandling GUI' => 'ジェネリックインターフェース・エラー処理GUI',
        'GenericInterface Invoker Event GUI' => 'ジェネリックインターフェース・API実行元イベントのGUI',
        'GenericInterface Invoker GUI' => 'ジェネリックインターフェース・API実行元のGUI',
        'GenericInterface Operation GUI' => 'ジェネリックインターフェース・操作先GUI',
        'GenericInterface TransportHTTPREST GUI' => 'ジェネリックインターフェイス・トランスポートのHTTPREST GUI',
        'GenericInterface TransportHTTPSOAP GUI' => 'ジェネリックインターフェイス・トランスポートのHTTPSOAP GUI',
        'GenericInterface Web Service GUI' => 'ジェネリックインターフェース・WebサービスGUI',
        'GenericInterface Web Service History GUI' => 'ジェネリックインターフェース・Webサービス履歴GUI',
        'GenericInterface Web Service Mapping GUI' => 'ジェネリックインターフェース・WebサービスマッピングGUI',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'German' => 'ドイツ語',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => '',
        'Go to dashboard!' => 'ダッシュボードに移動する',
        'Good PGP signature.' => '',
        'Google Authenticator' => '',
        'Graph: Bar Chart' => 'グラフ:棒グラフ',
        'Graph: Line Chart' => 'グラフ:折れ線グラフ',
        'Graph: Stacked Area Chart' => 'グラフ:積み上げ面グラフ',
        'Greek' => 'ギリシャ語',
        'Hebrew' => 'ヘブライ語',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '',
        'High contrast skin for visually impaired users.' => '',
        'Hindi' => 'ヒンディー語',
        'Hungarian' => 'ハンガリー語',
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
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
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
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'もしログ・モジュールに関して"SysLog"が選択されていた場合、ロギングで使用されるべき文字セットが特定されます。',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'もしログ・モジュールに関して"File"が選択されていた場合、ログ・ファイルが必ず特定されます。もしファイルが存在しなければ、システムにより作成されます。',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '"SMTP"構造のいずれかがSendmailモジュールとして選択され、かつメール・サーバへの認証が必要な場合、パスワードを特定する必要があります。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '"SMTP"構造のいずれかがSendmailモジュールとして選択され、かつメール・サーバへの認証が必要な場合、ユーザ名を特定する必要があります。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '"SMTP"構造のいずれかがSendmailモジュールとして選択された場合、メールを送信するメール・ホストが特定されている必要があります。',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '"SMTP"構造のいずれかがSendmailモジュールとして選択された場合、メール・サーバが受信接続をlistenしている（待っている）ポートが特定されている必要があります。',
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
            '有効にすると、OTRSは全JavaScriptファイルを縮小した形式で配信します。',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '有効にされた場合、TicketPhoneおよびTicketEmailは新しいウィンドウで開きます。',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '有効にした場合、ダッシュボード、ロック済チケット・ビュー、キュー・ビューは自動で指定時間後に更新されます。',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '有効にした場合、メイン・メニューの1つめのレベルのものが、マウスを乗せるだけで開きます（1回クリックの代わりに）。',
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
            'ここで指定した文言（正規表現）にマッチした場合、オート・レスポンダーによりメッセージは送られません。',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '外出予定がある場合、外出日を設定して他のユーザーに知らせることができます。',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Import appointments screen.' => '予約画面をインポート',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '担当者インタフェースのチケット検索で、項目の作成時間を含みます。',
        'Incoming Phone Call.' => '電話着信',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => '',
        'Inline' => '',
        'Input' => '入力',
        'Interface language' => 'インターフェイスの言語',
        'Internal communication channel.' => '内部コミュニケーション・チャネル',
        'International Workers\' Day' => '国際労働者の日',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'アプリケーション内でドメインごとのベースで使用されている異なる担当者間を区別するためなど、異なるスキンを設定することが可能です。通常の表現（regrex）を使用することで、Key/Contentのペアをドメインにマッチするように設定することが可能です。“Key”の値はドメインにマッチするべきであり、“Content”の値はご利用のシステムの有効なスキンであるべきです。Regrexの適切な形式については、入力例を参照してください。',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'アプリケーション内でドメインごとのベースで使用される異なる顧客ごとを見分けるため、などの場合、異なるスキンを設定することも可能です。通常の表現を使用することで（regex）、Key/Contentのペアーをドメインにマッチするように設定することが可能です。"Key"の中の値はドメインにマッチするべきであり、"Content"の中の値はご利用のシステム上の有効なスキンであるべきです。Regrexの適切な形式への入力例をご覧ください。',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '異なるテーマを、担当者と顧客の間で異なるように、アプリケーション内でドメインごとの単位で使用されるように、設定することができます。regular expression (regex)を使用することにより、ドメインにマッチするようにKey/Contentを設定することが可能です。“Key”の値はドメインにマッチさせるべきであり、“Content”の値はご利用のシステムで有効なテーマとしてください。regrexの適切な形式のための入力例を確認してください。',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => 'イタリア語',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => '日本語',
        'JavaScript function for the search frontend.' => '',
        'Korean' => '',
        'Language' => '言語',
        'Large' => '大',
        'Last Screen Overview' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => '',
        'Lastname, Firstname' => '名, 姓',
        'Lastname, Firstname (UserLogin)' => '名, 姓 (ユーザー名)',
        'LastnameFirstname' => '',
        'Latvian' => 'ラトビア語',
        'Left' => 'のこり',
        'Link Object' => '連結対象',
        'Link Object.' => 'リンク・オブジェクト',
        'Link agents to groups.' => '担当者をグループへ連結',
        'Link agents to roles.' => '担当者をロールへ連結',
        'Link customer users to customers.' => '顧客のユーザーを顧客にリンクさせる。',
        'Link customer users to groups.' => '顧客のユーザーをグループにリンクさせる。',
        'Link customer users to services.' => '顧客のユーザーをサービスにリンクさせる。',
        'Link customers to groups.' => '顧客をグループにリンクさせる。',
        'Link queues to auto responses.' => 'キューを自動応答へ連結',
        'Link roles to groups.' => 'ロールをグループへ連結',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => 'テンプレートをキューへ連結',
        'Link this ticket to other objects' => 'このチケットを他のオブジェクトへリンク',
        'Links 2 tickets with a "Normal" type link.' => '“ノーマル”タイプのリンクを持つチケットへのリンクです。.',
        'Links 2 tickets with a "ParentChild" type link.' => '“親子”タイプのリンクを持つチケットへのリンクです。',
        'Links appointments and tickets with a "Normal" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '担当者インタフェースに対して、常にロードされるCSSファイルのリストです。',
        'List of CSS files to always be loaded for the customer interface.' =>
            '顧客インタフェースに対して、常にロードされるCSSファイルのリストです。',
        'List of JS files to always be loaded for the agent interface.' =>
            '担当者インタフェースに対して、常にロードされるJSファイルのリストです。',
        'List of JS files to always be loaded for the customer interface.' =>
            '顧客インタフェースに対して、常にロードされるJSファイルのリストです。',
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
            '作成時に新しいキューに自動的に割り当てられるデフォルトの標準テンプレートのリスト。',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => 'リストビュー',
        'Lithuanian' => 'リトアニア語',
        'Loader module registration for the agent interface.' => '担当者Webインタフェースのローダーモジュール登録',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => 'このチケットをロック/アンロックします',
        'Locked Tickets' => 'ロック済チケット',
        'Locked Tickets.' => 'ロックされたチケット',
        'Locked ticket.' => 'Locked ticket.',
        'Logged in users.' => 'ログインユーザー',
        'Logged-In Users' => 'ログインユーザー',
        'Logout of customer panel.' => '顧客パネルのログアウト',
        'Look into a ticket!' => 'チケットを閲覧する',
        'Loop protection: no auto-response sent to "%s".' => 'ループ防止機能: 自動返信を"%s"宛に送信しません。',
        'Macedonian' => '',
        'Mail Accounts' => 'メールアカウント',
        'MailQueue configuration settings.' => 'メールキューの構成を設定',
        'Main menu item registration.' => '',
        'Main menu registration.' => '',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Eメールの送信または電話/Eメール・チケットの提出の前に、アプリケーションにEメール・アドレスのMXレコードをチェックさせるようにします。',
        'Makes the application check the syntax of email addresses.' => 'アプリケーションにEメール・アドレスのシンタクスをチェックさせます。',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'セッション管理に、htmlクッキーを使用させるようにします。htmlクッキーが無効にされている場合、またはクライアント・ブラウザがhtmlクッキーを無効にしている場合、システムは通常どおり動作し、またセッションIDをリンクに付け加えます。',
        'Malay' => 'マレー語',
        'Manage OTRS Group cloud services.' => 'OTRSグループのクラウドサービスの管理',
        'Manage PGP keys for email encryption.' => 'メール暗号用のPGP鍵管理',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'メール受信用POP3/IMAPアカウント管理',
        'Manage S/MIME certificates for email encryption.' => 'メール暗号用のS/MIME証明書管理',
        'Manage System Configuration Deployments.' => 'システム設定のデプロイを管理する。',
        'Manage different calendars.' => '様々なカレンダーを管理します。',
        'Manage existing sessions.' => '既存セッション管理',
        'Manage support data.' => 'サポート情報の管理',
        'Manage system registration.' => 'システム登録の管理',
        'Manage tasks triggered by event or time based execution.' => 'イベントトリガーまたは時間ベースで実行されるタスクの管理',
        'Mark as Spam!' => '迷惑メールにする',
        'Mark this ticket as junk!' => 'このチケットをジャンクとしてマークします!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '1日においてEメール・アドレスを入手する自動メールによる返答の最大数です（ループ・プロテクション）。',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'POP3/POP3S/IMAP/IMAPS経由で取ってくることが可能なメールのKBytesの最大値です。',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '担当者インタフェースの検索結果で、表示されるチケットの最大数です。',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '顧客インタフェースの検索結果で表示される、チケットの最大数です。',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'チケットズームビューにおける、顧客情報テーブルの最大サイズ (文字) です。',
        'Medium' => '中',
        'Merge this ticket and all articles into another ticket' => '別のチケットの全ての記事とこのチケットを結合',
        'Merged Ticket (%s/%s) to (%s/%s).' => 'チケットを（%s/%s）から（%s/%s）にマージしました。',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'チケット番号 <OTRS_TICKET> は、チケット番号 <OTRS_MERGE_TO_TICKET> にマージされました。',
        'Minute' => '分',
        'Miscellaneous' => 'その他',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '顧客インタフェースで、新規チケット画面におけるTo-selectionのモジュールです。',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '顧客がチケットにアクセスするためのグループ・パーミッションをチェックするモジュールです。',
        'Module to check the group permissions for the access to tickets.' =>
            'チケットにアクセスするためのグループ・パーミッションをチェックするモジュールです。',
        'Module to compose signed messages (PGP or S/MIME).' => '署名されたメッセージを構成するモジュールです（PGP または S/MIME)。',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '利用する電子メールのセキュリティオプションを定義するモジュールです（PGPとS/MIMEを選択可能）',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '受信メッセージについてフィルターし操作するためのモジュールです。From: noreply@ addressを用いて、全てのスパム・メールをブロック/無視します。',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '受信メッセージについてフィルターし操作するためのモジュールです。チケットのフリーテキストに対して4桁の数字を得て、「Match」において正規表現を使用します。
（例：From / \'(.+?)@.+?\'とし、「Set」にて「[***]」として後方参照を使用します。）',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => 'アカウンテッド・タイム・チケット統計を生成するモジュールです。',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '担当者インタフェースにおいて、ショート・チケット検索のためのhtml OpenSearchプロフィールを生成するモジュールです。',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '顧客インタフェースで、ショート・チケット検索のためのhtml OpenSearchプロファイルを生成するためのモジュール。',
        'Module to generate ticket solution and response time statistics.' =>
            'チケット・ソリューションおよびレスポンス・タイム統計を生成するためのモジュールです。',
        'Module to generate ticket statistics.' => 'チケット統計を作成するためのモジュールです。',
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
            '通知とエスカレーションを表示するためのモジュールです(ShownMax: 最大、表示されたエスカレーション、EscalationInMinutes: エスカレートされるチケットを表示、CacheTime: 計算されたエスカレーションのキャッシュ秒数)。',
        'Module to use database filter storage.' => 'データベース・フィルター・ストレージを使用するモジュールです。',
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => 'Multiselect',
        'My Queues' => '担当キュー',
        'My Services' => '担当サービス',
        'My Tickets.' => '担当チケット',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'カスタム・キューの名前です。カスタム・キューとは、利用者が特に優先するキューの一覧であり、プレファレンス設定から選択できます。',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New Ticket' => '新規チケット',
        'New Tickets' => '新規チケット',
        'New Window' => '新規ウィンドウ',
        'New Year\'s Day' => '元日',
        'New Year\'s Eve' => '大晦日',
        'New process ticket' => '新規プロセスチケット',
        'News about OTRS releases!' => 'OTRSリリース情報!',
        'News about OTRS.' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '担当者インタフェースのチケット電話アウトバウンド画面で、電話メモを追加した後の次の可能性あるチケットの状態です。',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => 'なし',
        'Norwegian' => 'ノルウェー語',
        'Notification Settings' => '通知設定',
        'Notified about response time escalation.' => '応答時間のエスカレーションが通知されます。',
        'Notified about solution time escalation.' => '解決時間のエスカレーションが通知されます。',
        'Notified about update time escalation.' => '更新時間のエスカレーションが通知されます。',
        'Number of displayed tickets' => '表示チケット数',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '担当者インタフェースの検索ユーティリティにより、表示される行（チケット毎）の数です。',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '担当者インタフェースの検索結果の各ページで、表示されるチケットの数です。',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '顧客インタフェースの検索結果の各ページで表示される、チケット数です。',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => 'OTRSグループ・サービス',
        'OTRS News' => 'OTRSニュース',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTRSは、フルテキスト検索や統計生成などの高価な操作に、1つまたは複数の読み取り専用ミラーデータベースを使用できます。 ここでは、最初のミラーデータベースのDSNを指定できます。',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '外部リンクを開く！',
        'Open tickets (customer user)' => '対応中チケット(顧客ユーザー)',
        'Open tickets (customer)' => '対応中チケット(顧客)',
        'Option' => 'オプション',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Other Customers' => '',
        'Out Of Office' => '外出中',
        'Out Of Office Time' => '外出中',
        'Out of Office users.' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Kernel::System::Ticketに既に存在している機能を多重定義（再定義）します。簡単にカスタマイズを追加したい場合に使用されます。',
        'Overview Escalated Tickets.' => 'エスカレーション済チケット一覧',
        'Overview Refresh Time' => '一覧自動更新間隔',
        'Overview of all Tickets per assigned Queue.' => '割り当てられたキューごとのすべてのチケット一覧。',
        'Overview of all appointments.' => '全ての予約の一覧',
        'Overview of all escalated tickets.' => 'すべてのエスカレーション済チケット一覧',
        'Overview of all open Tickets.' => 'すべての対応中チケット一覧',
        'Overview of all open tickets.' => 'すべての対応中チケット一覧',
        'Overview of customer tickets.' => '顧客チケット一覧',
        'PGP Key' => 'PGP鍵',
        'PGP Key Management' => 'PGPキーの管理',
        'PGP Keys' => 'PGP鍵',
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
        'Parameters of the example SLA attribute Comment2.' => 'example SLA attribute Comment2のパラメータです。',
        'Parameters of the example queue attribute Comment2.' => 'example queue attribute Comment2のパラメータです。',
        'Parameters of the example service attribute Comment2.' => 'example service attribute Comment2のパラメータです。',
        'Parent' => '親',
        'ParentChild' => '親子関係',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'ログ・ファイルのパスです（LoopProtectionModuleに関して“FS”が選択されており、それが強制である場合にのみ適用されます）。',
        'Pending time' => '保留期限',
        'People' => '担当者/顧客',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => 'Eメール・ウィンドウを構成するために許容される幅です。',
        'Permitted width for compose note windows.' => 'メモ・ウィンドウを構成するために許容される幅です。',
        'Persian' => 'ペルシア語',
        'Phone Call Inbound' => '電話応答着信',
        'Phone Call Outbound' => '電話応答発信',
        'Phone Call.' => '',
        'Phone call' => '電話応答',
        'Phone communication channel.' => '電話コミュニケーション・チャネル',
        'Phone-Ticket' => '電話チケット',
        'Picture Upload' => '画像のアップロード',
        'Picture upload module.' => '',
        'Picture-Upload' => '画像のアップロード',
        'Plugin search' => 'プラグイン検索',
        'Plugin search module for autocomplete.' => 'オートコンプリート用のプラグイン検索モジュール',
        'Polish' => 'ポーランド語',
        'Portuguese' => 'ポルトガル語',
        'Portuguese (Brasil)' => 'ポルトガル語（ブラジル）',
        'PostMaster Filters' => 'ポストマスター・フィルター',
        'PostMaster Mail Accounts' => 'メールアカウント',
        'Print this ticket' => 'このチケットを印刷',
        'Priorities' => '優先度',
        'Process Management Activity Dialog GUI' => 'プロセス管理アクティビティダイアログGUI',
        'Process Management Activity GUI' => 'プロセス管理アクテビティGUI',
        'Process Management Path GUI' => 'プロセス管理パスGUI',
        'Process Management Transition Action GUI' => 'プロセス管理遷移動作GUI',
        'Process Management Transition GUI' => 'プロセス管理遷移GUI',
        'Process Ticket.' => 'プロセスチケット',
        'Process pending tickets.' => '保留中プロセスチケット',
        'ProcessID' => 'プロセスID',
        'Processes & Automation' => 'プロセス & 自動化',
        'Product News' => '製品ニュース',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            'キューごとの状態ごとのチケットのマトリックス概要を提供します。',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => '公開するカレンダー',
        'Public calendar.' => '公開するカレンダー',
        'Queue view' => 'キュー・ビュー',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => 'AgentTicketQueueのチケットインデックスを再構築します。',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => '更新間隔',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => '保留期限切れチケット',
        'Removed subscription for user "%s".' => 'Removed subscription for user "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '古いシステム設定のデプロイを削除します。（日曜の朝）',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'チケットがアーカイブされるとき、チケット監視者の情報を削除する。',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '担当者インタフェースのチケット構成画面で、オリジナルの送信者を、コンポーズ・アンサー上の現在の顧客のEメール・アドレスに置換します。',
        'Reports' => 'レポート',
        'Reports (OTRS Business Solution™)' => 'レポート（OTRS Business Solution™）',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '担当者インタフェースで、チケットの顧客を変更するための必要な許可です。',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '担当者インタフェースで、クローズ・チケット画面を使用するために必要な許可です。',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '',
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
            '担当者インタフェースのチケット・メモ画面を使用するための必要な許可です。',
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
        'Resend Ticket Email.' => 'チケットメールの再送信',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'チケットの所有者を、チケットが移動された、または別のキューに移動した場合、リセットおよびアンロックします。',
        'Resource Overview (OTRS Business Solution™)' => 'リソース表示 (OTRS Business Solution™)',
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '権限',
        'Roles ↔ Groups' => 'ロールーグループ',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '実行中のプロセスチケット',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'AdminCustomerUserモジュールにアクセスした時に、存在する顧客ユーザに関して最初のワイルド・カード検索を実行します。',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => 'ロシア語',
        'S/MIME Certificates' => 'S/MIME証明書',
        'SMS' => 'SMS',
        'SMS (Short Message Service)' => 'SMS (Short Message Service)',
        'Salutations' => '挨拶文',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => 'メンテナンス期間をスケジュール',
        'Screen after new ticket' => '新規チケット作成後の画面',
        'Search Customer' => '顧客を検索します。',
        'Search Ticket.' => 'チケットを検索する。',
        'Search Tickets.' => 'チケットを検索する。',
        'Search User' => 'ユーザを検索します。',
        'Search backend default router.' => 'バックエンドのデフォルト・ルーターを検索します。',
        'Search backend router.' => 'バックエンド・ルーターを検索します。',
        'Search.' => '検索する',
        'Second Christmas Day' => 'セカンド・クリスマスデー',
        'Second Queue' => '第二キュー',
        'Select after which period ticket overviews should refresh automatically.' =>
            'チケット表示の更新間隔を選択してください。',
        'Select how many tickets should be shown in overviews by default.' =>
            '一覧に表示するデフォルトのチケット数を選択して下さい。',
        'Select the main interface language.' => '主として使用する言語を選択してください。',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'CSVファイル（統計と検索）で使用される区切り文字を選択します。ここで区切り文字を選択しない場合、あなたの言語のデフォルトの区切り文字が使用されます。',
        'Select your frontend Theme.' => 'フロントエンドのテーマを選択してください。',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '自分のタイムゾーンを選択して下さい。全ての時間は、このタイムゾーンで表示されます。',
        'Select your preferred layout for the software.' => 'ソフトウェアに適したレイアウトを選択して下さい。',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => '使用するキャッシュバックエンドを選択してください。',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'ウェブ・インタフェースを通じてアップロードを取り扱うための、モジュールを選択します。"DB"は全てのアップロードをデータベースに格納し、"FS"はファイル・システムを使用します。',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => 'このチケットから新規メールを発信',
        'Send notifications to users.' => 'ユーザーに通知の送信',
        'Sender type for new tickets from the customer inteface.' => '顧客インタフェースからの新規チケットのための送信者タイプです。',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'チケットがアンロックされた際に、所有者にのみ担当者フォローアップ通知を送信します (デフォルト設定では、全ての担当者に通知を送ります)。',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Bccを経由して特定されたアドレスに送信Eメールを送ります。バックアップ目的のためにのみ使用してください。',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'リマインダ日付を迎えたら、アンロック・チケットのリマインダ通知を送信します（チケット所有者だけに送信されます）。',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '',
        'Sent "%s" notification to "%s" via "%s".' => '',
        'Sent auto follow-up to "%s".' => '"%s"への自動フォローアップを送信しました。',
        'Sent auto reject to "%s".' => '"%s"に自動拒否を送信しました。',
        'Sent auto reply to "%s".' => '"%s"に自動返信を送信しました。',
        'Sent email to "%s".' => '"%s"にメールを送りました。',
        'Sent email to customer.' => '顧客に電子メールを送信しました。',
        'Sent notification to "%s".' => '"%s"への通知を送信しました。',
        'Serbian Cyrillic' => 'セルビア語（キリル文字）',
        'Serbian Latin' => 'セルビア語（ラテン文字）',
        'Service Level Agreements' => 'サービスレベル契約（SLA）',
        'Service view' => 'サービス・ビュー',
        'ServiceView' => 'サービス・ビュー',
        'Set a new password by filling in your current password and a new one.' =>
            '現在のパスワードと新しいパスワードを入力して、新しいパスワードを設定して下さい。',
        'Set sender email addresses for this system.' => 'このシステムのメール送信者を設定',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoomで、インラインHTML項目のデフォルトの高さ（pixel）を設定します。',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoomで、インラインHTML項目の最大高さ（pixel）を設定します。',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => 'このチケットを保留に設定',
        'Sets if SLA must be selected by the agent.' => 'SLAが担当者によって必ず選択される必要があるかどうかを設定します。',
        'Sets if SLA must be selected by the customer.' => 'SLAが顧客によって必ず選択される必要があるかどうかを設定します。',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '担当者がキューを選択する必要があるかどうかを設定します。',
        'Sets if service must be selected by the agent.' => 'サービスが担当者によって必ず選択される必要があるかどうかを設定します。',
        'Sets if service must be selected by the customer.' => 'サービスが顧客によって必ず選択される必要があるかどうかを設定します。',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => 'チケットの所有者が担当者によって必ず選択される必要があるかどうかを設定します。',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '状態が非ペンディング状態に変更された場合、チケットのペンディング・タイムを0に設定します。',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'タッチされていないチケットを含むキューをハイライトするための、経過時間を分で設定します（第1レベル）。',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'タッチされていないチケットを含むキューをハイライトするための、経過時間を分で設定します（第2レベル）。',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '管理者の設定レベルの設定です。設定レベルに拠り、いくつかのシステム設定オプションは表示されなくなります。設定レベルは昇順です：Expert, Advanced, Beginner。設定レベルが高いほど（Beginnerを最高とします）、ユーザが、システムを二度と使用できなくなるような設定を誤って行うことが、起こりにくくなります。',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '担当者Webインターフェイスで新しいメールチケットのデフォルト記事を顧客参照と定義します。',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '担当者Webインターフェイスで新しい電話チケットのデフォルト記事を顧客参照と定義します。',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、追加されたメモに関するデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '担当者インタフェースの移動チケット画面で、追加されるメモのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・メモ画面で、追加されたメモのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、追加されたメモのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、追加されたメモのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、追加されたメモのデフォルトの本文テキストを設定します。',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、追加されたメモのデフォルトの本文テキストを設定します。',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of split tickets in the agent interface.' =>
            '担当者Webインターフェイスのスプリットチケットのデフォルトリンクタイプを設定します。',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '担当者Webインタフェースで、分割されたチケットのデフォルトのリンク・タイプを設定します。',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットのためのデフォルトの次の状態を設定します。',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '担当者インタフェースで、Eメール・チケットを作成した後の、デフォルトの次のチケット状態を設定します。',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '担当者インタフェースで、新規電話チケットのためのデフォルトのメモのテキストを設定します（例：\'New ticket via call\'）。',
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
            '担当者インタフェースのクローズ・チケット画面で、追加されたメモに関するデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '担当者インタフェースの移動チケット画面で、追加されるメモのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・メモ画面で、追加されたメモのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、追加されたメモのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、追加されたメモのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、追加されたメモのデフォルトの件名を設定します。',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、追加されたメモのデフォルトの件名を設定します。',
        'Sets the default text for new email tickets in the agent interface.' =>
            '担当者インタフェースで、新規Eメール・チケットに関してデフォルトのテキストを設定します。',
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
            'テキスト・メッセージに表示される行の数を設定します（つまり、キュー・ズーム内のチケット・ラインのためです）。',
        'Sets the options for PGP binary.' => 'PGPバイナリのためのオプションを設定します。',
        'Sets the password for private PGP key.' => '秘密PGP鍵のためのパスワードを設定します。',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '優先される時間の単位（例：作業時間、時間、分）を設定します。',
        'Sets the preferred digest to be used for PGP binary.' => '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'ウェブ・サーバ上に設定されるように、サーバ上のスクリプト・フォルダに対する接頭辞を設定します。この設定は、OTRS_CONFIG_ScriptAlias変数として設定され、これはアプリケーションによって使用されるメッセージングの全フォームに存在し、システム内のチケットへのリンクを作成するために使用されます。',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット・クローズ画面で、キューを設定します。',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット自由テキスト画面で、キューを設定します。',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケットノート画面で、キューを設定します。',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケットのチケット所有者画面で、キューを設定します。',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、キューを設定します。',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、キューを設定します。',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット責任者画面で、キューを設定します。',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのチケット・クローズ画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット自由テキスト画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・メモ画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、チケットの責任を有する担当者を設定します。',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、チケットの責任を持つ担当者を設定します。',
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
        'Sets the stats hook.' => '統計フックを設定します。',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、チケットの所有者を設定します。',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '担当者インタフェースのチケット・バルク画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・メモ画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、チケット所有者を設定します。',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、チケット所有者を設定します。',
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'http/ftp downloadsのためのタイムアウト（秒）を設定します。',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'パッケージ・ダウンロードのためのタイムアウト（秒）を設定します。"WebUserAgent::Timeout"を上書きします。',
        'Shared Secret' => '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '担当者インタフェースにおいて、電話およびEメールのチケットにおける責任者のセレクションを表示します。',
        'Show article as rich text even if rich text writing is disabled.' =>
            'リッチ・テキストのライティングが無効にされている場合でも、項目をリッチ・テキストで表示します。',
        'Show command line output.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => 'このチケットの履歴を表示',
        'Show the ticket history' => 'チケットの履歴を表示',
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
            '担当者インタフェースの全チケット一覧で、チケットにメモを追加するためのリンクをメニューに表示します。',
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
            '担当者インタフェースの全チケット一覧で、チケットをクローズするためのリンクをメニューに表示します。',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '担当者インタフェースの全チケット一覧で、チケットを削除するするためのリンクをメニューに表示します。本リンクを表示または非表示にするための追加的アクセス・コントロールについては、“Group”キーおよび"rw:group1;move_into:group2"のようなコンテンツを使用することで可能になります。',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットをロック/アンロックするためのリンクをメニューに表示します。',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットを移動するためのリンクをメニューに表示します。',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットのチケット履歴を確認するためのリンクをメニューに表示します。',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットの優先度を設定するためのリンクをメニューに表示します。',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '担当者インタフェースの全チケット一覧で、チケットにズームするためのリンクをメニューに表示します。',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '担当者インタフェースの項目ズーム・ビューにおいて、項目の添付ファイルにhtmlオンライン・ビュアーでアクセスするためのリンクを表示します。',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '担当者インタフェースの項目ズーム・ビューにおいて、項目の添付ファイルをダウンロードするためのリンクを表示します。',
        'Shows a link to see a zoomed email ticket in plain text.' => 'ズームされたEメール・チケットを、プレイン・テキストで見るためのリンクを表示します。',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・メモ画面で、そのチケットに関与する全担当者のリストです。',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、そのチケットに関与する全ての担当者のリストを表示します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '担当者インタフェースのクローズ・チケット画面で、可能性ある担当者（キュー/チケットに対してメモの許可を有する全ての担当者）のリストを表示し、そのメモについて誰に通知するべきか決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '担当者インタフェースのチケット・フリー・テキスト・スクリーンで、可能性ある全ての担当者（キュー/チケットに関してメモ許可を有する全ての担当者）を表示し、そのメモに関して誰に通知するべきかを決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '担当者インタフェースのチケット・メモ画面で、可能性ある担当者（キュー/チケットに対してメモ許可を持つ全担当者）を表示し、そのメモについて誰に通知するか決定しまう。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、全ての可能性ある担当者（キュー/チケットにメモ許可を有する全ての担当者）のリストを表示し、そのメモについて誰に通知するべきかを決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、全ての可能性ある担当者（キュー/チケットにメモ許可を有する全ての担当者）のリストを表示し、そのメモについて誰に通知するべきかを決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、全ての可能性ある担当者（キュー/チケットにメモ許可を有する全ての担当者）のリストを表示し、そのメモについて誰に通知するべきかを決定します。',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、全ての可能性ある担当者（キュー/チケットにメモ許可を有する全ての担当者）のリストを表示し、そのメモについて誰に通知するべきかを決定します。',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'チケット一覧のプレビューを表示します(CustomerInfo => 1 - 顧客情報も表示しますCustomerInfoMaxSize max ? 顧客情報の文字サイズです)。',
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => 'キュー・ビューで、roとrwの両方全てのキューを表示します。',
        'Shows all both ro and rw tickets in the service view.' => 'サービス・ビュー内の読み取り専用と読み書き可能なチケットの両方を全て表示する。',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '担当者インタフェースのエスカレーション・ビューにある、全てのオープン・チケット（たとえロックされていたとしても）を表示します。',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '全ての顧客識別子をマルチ・セレクトのフィールドに表示します（顧客識別子を多く抱えている場合は利便性が低いです）。',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '担当者インタフェースにおいて、電話およびEメールのチケットにおける所有者のセレクションを表示します。',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'AgentTicketPhone、AgentTicketEmail、AgentTicketCustomerにおいて、顧客履歴チケットを表示します。',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '最後の顧客の項目の件名またはチケットのタイトルを、小さいフォーマットの一覧で表示します。',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'システム内に存在する親/子キューのリストを、ツリーまたはリストの形式で表示します。',
        'Shows information on how to start OTRS Daemon' => 'OTRSデーモンの起動手順を紹介します。',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '担当者インタフェースのチケット・ズームの下で、ノーマルまたは逆順でソートされた項目を表示します。',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '構成画面において、顧客ユーザ情報（電話およびEメール）を表示します。',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
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
            '担当者インタフェースのチケット・メモ画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット所有者画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット保留画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '担当者インタフェースのズームされたチケットのチケット優先度画面で、チケット優先度のオプションを表示します。',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '担当者インタフェースのチケット責任者画面で、チケット優先度のオプションを表示します。',
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
        'Signatures' => '署名',
        'Simple' => 'シンプル',
        'Skin' => 'スキン',
        'Slovak' => 'スロバキア語',
        'Slovenian' => 'スロベニア語',
        'Small' => '小',
        'Software Package Manager.' => 'ソフトウェアパッケージマネージャー',
        'Solution time' => '解決期限',
        'SolutionDiffInMin' => '解決期限超過時間',
        'SolutionInMin' => '解決時間',
        'Some description!' => 'いくつかの説明！',
        'Some picture description!' => 'いくつかの画像の説明！',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '1つのキューがキュー・ビューで選択され、チケットが優先度によってソートされた後に、チケットをソートします（昇順または降順）。Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top)。キーに関してキューIDを使用し、値（value）に関して0または1を使用してください。',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => 'スパム',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'スパム・アサシンのセットアップ例です。スパム・アサシンによってマークされたEメールを無視します。',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'SpamAssassinのセットアップ例です。マークされたメールを、スパム・キューへ移動します。',
        'Spanish' => 'スペイン語',
        'Spanish (Colombia)' => 'スペイン語(コロンビア)',
        'Spanish (Mexico)' => 'スペイン語(メキシコ)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '担当者が自分自身のアクションに関してEメール通知を受け取る必要があるかどうか、を設定します。',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => 'SSL認証が格納されるディレクトリを特定します。',
        'Specifies the directory where private SSL certificates are stored.' =>
            '秘密SSL認証が格納されるディレクトリを特定します。',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '「SwitchToCustomer」機能にアクセスできるように、ユーザーがRW権限を必要とするグループを指定します。',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '担当者の姓と名を表示する順序を指定してください。',
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
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'ログ・ファイルの中でCGIスクリプト・エントリーを意味するテキストを規定します。',
        'Specifies user id of the postmaster data base.' => 'ポストマスター・データベースのユーザIDを特定します。',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            'データベースの第一ミラーの認証パスワードを指定してください。',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Stable' => '安定',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'アプリケーション内で担当者にとって標準的に利用可能な許可です。もし、さらに多くの許可が必要であれば、ここで加えることができます。許可は、効果的になるように設定する必要があります。いくつか他の良い許可も、ビルト・インで提供されています：note, close, pending, customer, freetext, move, compose, responsible, forward, bounce。“rw”は、常に最後の登録許可であることを確認してください。',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '統計カウンティングの数をスタートします。全ての新規統計はこの数字を増加させます。',
        'Started response time escalation.' => '応答時間のエスカレーションを開始しました。',
        'Started solution time escalation.' => '解決時間のエスカレーションを開始しました。',
        'Started update time escalation.' => '更新時間のエスカレーションを開始しました。',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => '統計番号',
        'States' => 'ステータス',
        'Statistic Reports overview.' => '',
        'Statistics overview.' => 'レポート一覧',
        'Status view' => 'ステータス・ビュー',
        'Stopped response time escalation.' => '応答時間のエスカレーションを停止しました。',
        'Stopped solution time escalation.' => '解決時間のエスカレーションを停止しました。',
        'Stopped update time escalation.' => '更新時間のエスカレーションを停止しました。',
        'Stores cookies after the browser has been closed.' => 'ブラウザが閉じられた後に、クッキーを格納します。',
        'Strips empty lines on the ticket preview in the queue view.' => 'キュー画面で、チケット・プレビューの空の行を削除します。',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => 'スワヒリ語',
        'Swedish' => 'スウェーデン語',
        'System Address Display Name' => 'システムアドレスの表示名',
        'System Configuration Deployment' => 'システム設定のデプロイ',
        'System Configuration Group' => 'システム設定グループ',
        'System Maintenance' => 'システムメンテナンス',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => 'テンプレート ↔ キュー',
        'Textarea' => 'Textarea',
        'Thai' => 'タイ',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '担当者インタフェースで使用されるべき、担当者スキンのインターナル・ネームです。Frontend::Agent::Skinsにおける利用可能なスキンをチェックしてください。',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '顧客インタフェースにて使用される顧客スキンのInternalNameです。Frontend::Customer::Skinsにおいて利用可能なスキンをチェックしてください。',
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
            'チケットフックとチケット番号の間の仕切りです。例：\': \'',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '顧客インターフェイスの見出し',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '例えばTicket#, Call#, MyTicket#などのチケットの識別子です。デフォルトはTicket#です。',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'スキン"デフォルト"時に担当者インターフェイスで表示されるロゴ。詳細は"AgentLogo"を参照してください。',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            'スキン"ivory"時に担当者インターフェイスで表示されるロゴ。詳細は"AgentLogo"を参照してください。',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            'スキン"ivory-slim"時に担当者インターフェイスで表示されるロゴ。詳細は"AgentLogo"を参照してください。',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            'スキン"slim"時に担当者インターフェイスで表示されるロゴ。詳細は"AgentLogo"を参照してください。',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '顧客画面のヘッダ部分に表示するロゴを設定します。画像の',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'AgentTicketZoomの拡大表示モードで1ページあたりに表示する記事の数',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'AgentTicketZoomの通常表示モードで1ページあたりに表示する記事の数',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '一度にメール取得を実施可能な最大数に達しました。',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Eメール・リプライにおける件名の最初のテキストです。例：RE, AW, AS。',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Eメールが転送された際の、件名の最初のテキストです。例：FW, Fwd, WG。',
        'The value of the From field' => '',
        'Theme' => 'テーマ',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            'これは、デフォルトの黒地と橙色をモチーフにした、顧客インタフェース向けのスキンです。',
        'This is the default orange - black skin.' => 'これは、デフォルトの黒地と橙色をモチーフにしたスキンです。',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '定義された場合、全てのリクエストに対して、本モジュールおよびそのPreRun()機能が実行されます。本モジュールは、いくつかのユーザ・オプションをチェックするため、または新しいアプリケーションのニュースを表示させるために、役立つものです。',
        'This module is part of the admin area of OTRS.' => 'このモジュールは、OTRS の管理者エリアの一機能です。',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'このオプションは、プロセス管理のアクティビティ・エンティティIDを格納するためのダイナミック・フィールドを定義します。',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'このオプションは、プロセス管理のプロセス・エンティティIDを格納するためのダイナミック・フィールドを定義します。',
        'This option defines the process tickets default lock.' => 'このオプションは、プロセスチケットの標準ロック状態を定義します。',
        'This option defines the process tickets default priority.' => 'このオプションは、プロセスチケットの標準重要度を定義します。',
        'This option defines the process tickets default queue.' => 'このオプションは、プロセスチケットの標準キューを定義します。',
        'This option defines the process tickets default state.' => 'このオプションは、プロセスチケットのデフォルトのステータスを定義します。',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'This setting is deprecated. Set OTRSTimeZone instead.' => '',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            '',
        'This will allow the system to send text messages via SMS.' => 'この操作は、システムによるSMS経由でのメッセージ送信を許可します。',
        'Ticket Close.' => 'チケットをクローズする',
        'Ticket Compose Bounce Email.' => 'バウンスメールを送信する',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => 'チケットの顧客',
        'Ticket Forward Email.' => 'チケットをメール転送する',
        'Ticket FreeText.' => 'チケットのフリーテキスト',
        'Ticket History.' => 'チケット履歴を見る',
        'Ticket Lock.' => 'チケットをロックする',
        'Ticket Merge.' => 'チケットを結合する',
        'Ticket Move.' => 'チケットを移動する',
        'Ticket Note.' => 'チケットに記事を残す',
        'Ticket Notifications' => 'チケット通知',
        'Ticket Outbound Email.' => '外部メールを送信する',
        'Ticket Overview "Medium" Limit' => 'チケット一覧(M)の表示数',
        'Ticket Overview "Preview" Limit' => 'チケット一覧(プレビュー)の表示数',
        'Ticket Overview "Small" Limit' => 'チケット一覧(S)の表示数',
        'Ticket Owner.' => 'チケット所有者',
        'Ticket Pending.' => 'チケットを保留する',
        'Ticket Print.' => 'チケット印刷',
        'Ticket Priority.' => 'チケットの優先度',
        'Ticket Queue Overview' => 'チケット・キュー一覧',
        'Ticket Responsible.' => 'チケット責任者',
        'Ticket Watcher' => 'チケット監視者',
        'Ticket Zoom' => 'チケットのズーム',
        'Ticket Zoom.' => 'チケット・ズーム',
        'Ticket bulk module.' => 'チケットの一括モジュール',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => 'チケット通知',
        'Ticket overview' => 'チケット一覧',
        'Ticket plain view of an email.' => 'メール用チケット簡易表示',
        'Ticket split dialog.' => 'チケット分割ダイアログ',
        'Ticket title' => 'チケットタイトル',
        'Ticket zoom view.' => 'チケット・ズーム・ビュー',
        'TicketNumber' => 'チケット番号',
        'Tickets.' => 'チケット',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '保留中のステートを設定した場合、実際の時間に加えられる時間（秒）です。(default: 86400 = 1 day)',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '添付ファイルをダウンロード',
        'To view HTML attachments.' => 'HTML添付ファイルを表示するには',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => 'ツリー表示',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => 'トルコ語',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '透過型HTTPSプロキシを利用するなどの理由によりSSL証明書の有効性チェックを無効化することもありますが、自己責任で実施願います。',
        'Turns on drag and drop for the main navigation.' => 'メイン画面でドラッグアンドドロップを有効にします。',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => 'あなたが望むようにシステムを微調整する。',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => 'ウクライナ語',
        'Unlock tickets that are past their unlock timeout.' => 'アンロック期限を過ぎたチケットはロックが解除されます。',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'メモが追加され、所有者が外出中の場合は、チケットのロックを解除します。',
        'Unlocked ticket.' => 'Unlocked ticket.',
        'Up' => '昇順',
        'Upcoming Events' => '直近のイベント',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '全ての項目が確認された、または新規のArticleが作成された場合に、チケット“Seen”フラグをアップデートします。',
        'Update time' => '更新日時',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'チケット属性がアップデートされた後に、チケット・エスカレーション・インデックスをアップデートします。',
        'Updates the ticket index accelerator.' => 'チケット・インデックス・アクセラレイタのアップです',
        'Upload your PGP key.' => 'PGPキーをアップロードしてください。',
        'Upload your S/MIME certificate.' => 'S/MIME証明書をアップロードしてください。',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'User Profile' => 'ユーザーのプロファイル',
        'UserFirstname' => '姓',
        'UserLastname' => '名',
        'Users, Groups & Roles' => 'ユーザー, グループ & ロール',
        'Uses richtext for viewing and editing ticket notification.' => 'チケット通知の作成と表示確認にリッチテキストを利用します。',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '作成と表示確認にリッチテキストを利用します。: 記事、挨拶、署名、標準テンプレート、自動応答と通知',
        'Vietnam' => 'ベトナム',
        'View all attachments of the current ticket' => '現在のチケットにある全ての添付ファイルを表示する',
        'View performance benchmark results.' => 'パフォーマンス・ベンチマーク結果を見る。',
        'Watch this ticket' => 'このチケットを見る。',
        'Watched Tickets' => '監視チケット',
        'Watched Tickets.' => '監視チケット',
        'We are performing scheduled maintenance.' => '定期メンテナンスを実施中です。',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '定期メンテナンスを実施中です。ログインはしばらくお待ちください。',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '定期メンテナンスを実施中です。',
        'Web Services' => 'Webサービス',
        'Web View' => 'Web ビュー',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '担当者 がチケットを作成すると、自動的に チケット をその 担当者に割り当ててロックするかどうかを設定します。',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'チケットがマージされると、有効ではなくなったチケットに自動的にメモが追加されます。このメモの内容をここで定義できます(担当者はこの本文を変更できません)。',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'チケットがマージされると、有効ではなくなったチケットに自動的にメモが追加されます。このメモの件名をここで定義できます(担当者はこの件名を変更できません)。',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '担当者インタフェースでズームされたチケットのチケット結合画面で、チケット・ロックが必要かどうかを定義します。（チケットがまだロックされていない場合、チケットはロックされ現在の担当者が自動的に所有者として設定されます）。',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => 'はい、アーカイブされたチケットを非表示にします。',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'チケット番号"<OTRS_TICKET>" のメールは、"<OTRS_BOUNCE_TO>"宛にバウンスされました。詳細は、このアドレスまでお問合せください。',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'メールのチケット番号 "<OTRS_TICKET>" を "<OTRS_MERGE_TO_TICKET>" と結合しました。',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '優先キューの選択。有効になっている場合は、電子メールでこれらのキューについての通知を受け取ります。',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '優先サービスの選択。有効になっている場合は、電子メールでこれらのサービスについての通知を受け取ります。',
        'Zoom' => 'ズーム',
        'attachment' => '添付ファイル',
        'bounce' => 'bounce（返送）',
        'compose' => 'compose（作成）',
        'debug' => 'デバッグ',
        'error' => 'エラー',
        'forward' => '転送',
        'info' => '情報',
        'inline' => 'インライン',
        'normal' => '中',
        'notice' => '通知',
        'pending' => '保留',
        'phone' => '電話',
        'responsible' => 'responsible （責任者）',
        'reverse' => '反転',
        'stats' => 'stats',

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
